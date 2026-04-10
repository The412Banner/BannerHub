package app.revanced.extension.gamehub;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Environment;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import java.util.zip.GZIPInputStream;
import java.util.zip.Inflater;

/**
 * GOG Gen 1 + Gen 2 download pipeline, mirroring BannerHub 5.3.5.
 *
 * startDownload() spawns a background thread.  Progress is reported via
 * Callback, which must post to the main thread before touching any Views.
 *
 * Pipeline (Gen 2):
 *   1. builds?generation=2 → build ID → manifest URL
 *   2. fetch + decompress manifest → installDirectory, depots[]
 *   3. per depot: fetch + decompress manifest → collect DepotFiles
 *   4. secure_link → CDN base URL
 *   5. per file: download chunks → zlib inflate → assemble
 *   6. write _gog_manifest.json, report done
 *
 * Fallback (Gen 1):
 *   1. builds?generation=1 → manifest URL
 *   2. per file: Range-based byte download → assemble
 */
public final class GogDownloadManager {

    private static final String TAG = "BH_GOG_DL";
    private static final int TIMEOUT = 30_000;

    public interface Callback {
        void onProgress(String msg, int pct);
        void onComplete(String exePath);
        void onError(String msg);
        default void onCancelled() {}
        /**
         * Called when multiple executable candidates are found and the user must
         * choose.  {@code candidates} is a list of absolute paths.  Call
         * {@code onSelected.accept(path)} with the chosen path to continue.
         * Default: pick the first candidate automatically.
         */
        default void onSelectExe(java.util.List<String> candidates,
                                  java.util.function.Consumer<String> onSelected) {
            if (!candidates.isEmpty()) onSelected.accept(candidates.get(0));
        }
    }

    private GogDownloadManager() {}

    /**
     * Starts the download in a background thread.
     * Returns a cancel Runnable: call it to stop the download and delete any
     * partially downloaded files for this game.
     */
    public static Runnable startDownload(Context ctx, GogGame game, Callback cb) {
        AtomicBoolean cancelled = new AtomicBoolean(false);
        AtomicReference<File> installDirRef = new AtomicReference<>(null);
        Thread t = new Thread(() -> doDownload(ctx, game, cb, cancelled, installDirRef),
                "gog-dl-" + game.gameId);
        t.start();
        return () -> {
            cancelled.set(true);
            File dir = installDirRef.get();
            if (dir != null) deleteDir(dir);
            cb.onCancelled();
        };
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Main pipeline
    // ─────────────────────────────────────────────────────────────────────────

    private static void doDownload(Context ctx, GogGame game, Callback cb,
                                    AtomicBoolean cancelled, AtomicReference<File> installDirRef) {
        StringBuilder dbg = new StringBuilder();
        dbg.append("=== BH GOG Debug === game=").append(game.gameId)
           .append(" title=").append(game.title).append("\n");
        try {
            if (cancelled.get()) return;
            cb.onProgress("Checking token…", 0);

            SharedPreferences prefs = ctx.getSharedPreferences("bh_gog_prefs", 0);
            String token = prefs.getString("access_token", null);
            if (token == null) { cb.onError("Not logged in to GOG"); return; }

            int loginTime  = prefs.getInt("bh_gog_login_time", 0);
            int expiresIn  = prefs.getInt("bh_gog_expires_in", 3600);
            int nowSec     = (int) (System.currentTimeMillis() / 1000L);
            if (loginTime == 0 || nowSec >= loginTime + expiresIn) {
                cb.onProgress("Refreshing token…", 0);
                String newToken = GogTokenRefresh.refresh(ctx);
                if (newToken == null) { cb.onError("Token expired — please sign in again"); return; }
                token = newToken;
            }
            dbg.append("token OK\n");

            if (cancelled.get()) return;
            cb.onProgress("Fetching builds…", 2);

            // Try Gen 2 — builds list is public, no auth needed; fall back to authed if null
            String buildsUrl = "https://content-system.gog.com/products/" + game.gameId
                    + "/os/windows/builds?generation=2";
            String buildsJson = httpGet(buildsUrl, null);
            if (buildsJson == null) buildsJson = httpGet(buildsUrl, token);
            dbg.append("gen2_builds_url=").append(buildsUrl).append("\n");
            dbg.append("gen2_builds_response=").append(buildsJson == null ? "NULL"
                    : buildsJson.substring(0, Math.min(300, buildsJson.length()))).append("\n");

            if (buildsJson != null) {
                String err = runGen2(ctx, game, token, buildsJson, cb, dbg, cancelled, installDirRef);
                if (err == null) { writeDebug(ctx, dbg); return; }
                dbg.append("gen2_failed=").append(err).append("\n");
            }

            if (cancelled.get()) return;
            cb.onProgress("Gen 2 unavailable, trying Gen 1…", 10);

            // Fallback Gen 1
            String builds1Url = "https://content-system.gog.com/products/" + game.gameId
                    + "/os/windows/builds?generation=1";
            String builds1Json = httpGet(builds1Url, null);
            if (builds1Json == null) builds1Json = httpGet(builds1Url, token);
            dbg.append("gen1_builds_response=").append(builds1Json == null ? "NULL"
                    : builds1Json.substring(0, Math.min(300, builds1Json.length()))).append("\n");
            if (builds1Json == null) {
                writeDebug(ctx, dbg);
                cb.onError("No builds available for this game"); return;
            }
            String err1 = runGen1(ctx, game, token, builds1Json, cb, dbg, cancelled, installDirRef);
            if (err1 != null) {
                dbg.append("gen1_failed=").append(err1).append("\n");

                // Both gen1 and gen2 empty → old installer system, fall back to direct download
                if ("NO_CS_BUILDS".equals(err1)) {
                    cb.onProgress("No Galaxy builds — trying installer download…", 12);
                    String installerErr = runInstaller(ctx, game, token, cb, dbg, cancelled, installDirRef);
                    if (installerErr == null) { writeDebug(ctx, dbg); return; }
                    dbg.append("installer_failed=").append(installerErr).append("\n");
                    writeDebug(ctx, dbg);
                    cb.onError("No downloadable builds for this game");
                } else {
                    writeDebug(ctx, dbg);
                    cb.onError("Download failed: " + err1);
                }
            } else {
                writeDebug(ctx, dbg);
            }
        } catch (Exception e) {
            dbg.append("EXCEPTION=").append(e).append("\n");
            writeDebug(ctx, dbg);
            cb.onError("Download error: " + e.getMessage());
        }
    }

    private static void writeDebug(Context ctx, StringBuilder dbg) {
        try {
            java.io.File dir = ctx.getExternalFilesDir(null);
            if (dir == null) dir = ctx.getFilesDir();
            java.io.File f = new java.io.File(dir, "bh_gog_debug.txt");
            writeFile(f, dbg.toString().getBytes("UTF-8"));
            Log.i(TAG, "Debug written to: " + f.getAbsolutePath());
        } catch (Exception e) {
            Log.e(TAG, "writeDebug failed", e);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Gen 2 pipeline
    // ─────────────────────────────────────────────────────────────────────────

    // Returns null on success, error description string on failure.
    private static String runGen2(Context ctx, GogGame game, String token,
                                   String buildsJson, Callback cb, StringBuilder dbg,
                                   AtomicBoolean cancelled, AtomicReference<File> installDirRef) {
        try {
            dbg.append("\n--- Gen2 ---\n");
            JSONObject builds = new JSONObject(buildsJson);
            JSONArray items = builds.optJSONArray("items");
            if (items == null || items.length() == 0)
                return "no items in builds response";
            dbg.append("items=").append(items.length()).append("\n");

            // Pick first windows build
            String buildId = null, manifestUrl = null;
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                dbg.append("item[").append(i).append("] os=").append(item.optString("os"))
                   .append(" gen=").append(item.optInt("generation")).append("\n");
                if ("windows".equals(item.optString("os"))) {
                    buildId     = item.optString("build_id");
                    manifestUrl = item.optString("link");
                    if (manifestUrl == null || manifestUrl.isEmpty())
                        manifestUrl = item.optString("meta_url");
                    break;
                }
            }
            if (buildId == null || manifestUrl == null || manifestUrl.isEmpty())
                return "no windows build or manifest URL empty";
            dbg.append("buildId=").append(buildId).append("\nmanifestUrl=")
               .append(manifestUrl.substring(0, Math.min(120, manifestUrl.length()))).append("\n");

            cb.onProgress("Fetching manifest…", 5);
            byte[] manifestRaw = fetchBytes(manifestUrl, token);
            if (manifestRaw == null) return "manifest fetch returned null";
            dbg.append("manifestRaw bytes=").append(manifestRaw.length)
               .append(String.format(" first2=%02X%02X\n", manifestRaw[0]&0xFF, manifestRaw[1]&0xFF));
            String manifestStr = decompressBytes(manifestRaw);
            if (manifestStr == null) return "manifest decompress failed";
            dbg.append("manifestStr snippet=")
               .append(manifestStr.substring(0, Math.min(300, manifestStr.length()))).append("\n");

            JSONObject manifest = new JSONObject(manifestStr);
            String installDir = manifest.optString("installDirectory", game.title);
            JSONArray depots  = manifest.optJSONArray("depots");
            if (depots == null)
                return "no depots in manifest; keys=" + manifest.keys().toString();
            dbg.append("installDir=").append(installDir).append(" depots=").append(depots.length()).append("\n");

            // Extract temp_executable from products[0] (primary exe hint)
            String tempExe = null;
            JSONArray products = manifest.optJSONArray("products");
            if (products != null && products.length() > 0) {
                tempExe = products.getJSONObject(0).optString("temp_executable", null);
                if (tempExe != null && tempExe.isEmpty()) tempExe = null;
            }
            dbg.append("tempExe=").append(tempExe).append("\n");

            // Collect DepotFiles from each language-compatible depot
            cb.onProgress("Reading depot manifests…", 10);
            List<DepotFile> files = new ArrayList<>();
            for (int i = 0; i < depots.length(); i++) {
                JSONObject depot = depots.getJSONObject(i);
                JSONArray languages = depot.optJSONArray("languages");
                boolean compatible = false;
                if (languages == null || languages.length() == 0) {
                    compatible = true;
                } else {
                    String langsStr = languages.toString();
                    if (langsStr.contains("*") || langsStr.contains("en-US")
                            || langsStr.contains("\"en\"") || langsStr.contains("english")) {
                        compatible = true;
                    }
                }
                dbg.append("depot[").append(i).append("] langs=").append(languages)
                   .append(" compat=").append(compatible).append("\n");
                if (!compatible) continue;

                // "manifest" field is a hash — build CDN URL from it
                String manifestHash = depot.optString("manifest");
                if (manifestHash == null || manifestHash.isEmpty()) continue;
                String metaUrl = "https://gog-cdn-fastly.gog.com/content-system/v2/meta/"
                        + buildCdnPath(manifestHash);
                dbg.append("depot[").append(i).append("] metaUrl=").append(metaUrl).append("\n");

                byte[] dmRaw = fetchBytes(metaUrl, null);  // CDN, no auth needed
                if (dmRaw == null) {
                    dbg.append("depot[").append(i).append("] meta fetch FAILED\n");
                    continue;
                }
                String dmStr = decompressBytes(dmRaw);
                if (dmStr == null) {
                    dbg.append("depot[").append(i).append("] decompress FAILED\n");
                    continue;
                }

                dbg.append("depot[").append(i).append("] manifest=")
                   .append(dmStr.substring(0, Math.min(500, dmStr.length()))).append("\n");
                int before = files.size();
                parseDepotManifest(dmStr, files);
                dbg.append("depot[").append(i).append("] added ").append(files.size() - before).append(" files\n");
            }

            if (files.isEmpty()) return "no depot files collected after processing all depots";
            dbg.append("total files=").append(files.size()).append("\n");

            // Fetch CDN base URL via secure_link
            cb.onProgress("Fetching CDN link…", 15);
            String baseProductId = game.gameId;
            if (products != null && products.length() > 0) {
                String pid = products.getJSONObject(0).optString("productId", null);
                if (pid != null && !pid.isEmpty()) baseProductId = pid;
            }
            String secureLinkUrl = "https://content-system.gog.com/products/" + baseProductId
                    + "/secure_link?_version=2&generation=2&path=/";
            String secureLinkJson = httpGet(secureLinkUrl, token);
            dbg.append("secure_link_url=").append(secureLinkUrl).append("\n");
            dbg.append("secure_link_response=").append(secureLinkJson == null ? "NULL"
                    : secureLinkJson.substring(0, Math.min(400, secureLinkJson.length()))).append("\n");
            String cdnBase = parseCdnUrl(secureLinkJson);
            dbg.append("cdnBase=").append(cdnBase).append("\n");
            if (cdnBase == null)
                return "cdnBase null; secure_link_response=" + (secureLinkJson == null ? "NULL"
                        : secureLinkJson.substring(0, Math.min(200, secureLinkJson.length())));

            // Install dir
            File installPath = GogInstallPath.getInstallDir(ctx, installDir);
            installPath.mkdirs();
            installDirRef.set(installPath);
            File chunksDir = new File(installPath, ".gog_chunks");
            chunksDir.mkdirs();

            // Download + assemble files — 6 parallel threads
            final int total = files.size();
            final AtomicInteger doneCount    = new AtomicInteger(0);
            final AtomicLong    totalBytes   = new AtomicLong(0);
            final AtomicLong    lastSpeedMs  = new AtomicLong(System.currentTimeMillis());
            final AtomicLong    lastSpeedB   = new AtomicLong(0);
            final AtomicLong    speedBps     = new AtomicLong(0);
            final AtomicBoolean anyFailed    = new AtomicBoolean(false);
            final String        fCdnBase     = cdnBase;
            final java.util.concurrent.ConcurrentLinkedQueue<String> fileLog2 =
                    new java.util.concurrent.ConcurrentLinkedQueue<>();
            dbg.append("gen2 parallel download: ").append(total).append(" files, 8 threads\n");

            ExecutorService pool = Executors.newFixedThreadPool(8);
            List<Future<Void>> futures = new ArrayList<>();
            for (DepotFile df : files) {
                futures.add(pool.submit((Callable<Void>) () -> {
                    if (cancelled.get() || anyFailed.get()) return null;
                    File outFile = new File(installPath, df.relativePath);
                    File tmpFile = new File(installPath, df.relativePath + ".bhtmp");
                    outFile.getParentFile().mkdirs();

                    // Resume: skip if already fully written
                    if (outFile.exists() && outFile.length() > 0) {
                        int done = doneCount.incrementAndGet();
                        int pct  = 15 + (int) ((done / (float) total) * 80);
                        cb.onProgress("Resuming…", pct);
                        return null;
                    }

                    for (int attempt = 1; attempt <= 3; attempt++) {
                        if (cancelled.get() || anyFailed.get()) return null;
                        tmpFile.delete();
                        long fileBytes = 0;
                        boolean ok = false;
                        try (FileOutputStream fos = new FileOutputStream(tmpFile)) {
                            ok = true;
                            for (DepotFile.ChunkRef chunk : df.chunks) {
                                if (cancelled.get()) return null;
                                String chunkPath = buildCdnPath(chunk.hash);
                                int qIdx = fCdnBase.indexOf('?');
                                String chunkUrl = qIdx >= 0
                                        ? fCdnBase.substring(0, qIdx) + "/" + chunkPath + fCdnBase.substring(qIdx)
                                        : fCdnBase + "/" + chunkPath;
                                byte[] chunkRaw = fetchBytes(chunkUrl, null);
                                if (chunkRaw == null) { ok = false; break; }
                                fileBytes += chunkRaw.length;
                                byte[] inflated = inflateZlib(chunkRaw);
                                if (inflated == null) inflated = chunkRaw;
                                fos.write(inflated);
                            }
                        } catch (Exception e) {
                            ok = false;
                        }
                        if (ok) {
                            if (outFile.exists()) outFile.delete();
                            tmpFile.renameTo(outFile);
                            int done = doneCount.incrementAndGet();
                            long tb  = totalBytes.addAndGet(fileBytes);
                            int pct  = 15 + (int) ((done / (float) total) * 80);
                            long nowMs  = System.currentTimeMillis();
                            long prevMs = lastSpeedMs.get();
                            if (nowMs - prevMs >= 500 && lastSpeedMs.compareAndSet(prevMs, nowMs)) {
                                long prevB = lastSpeedB.getAndSet(tb);
                                long dt = nowMs - prevMs;
                                if (dt > 0) speedBps.set((tb - prevB) * 1000L / dt);
                            }
                            String speedStr = formatSpeed(speedBps.get());
                            String name = df.relativePath.contains("/")
                                    ? df.relativePath.substring(df.relativePath.lastIndexOf('/') + 1)
                                    : df.relativePath;
                            cb.onProgress("Downloading: " + name
                                    + (speedStr.isEmpty() ? "" : "  " + speedStr), pct);
                            return null;
                        }
                        fileLog2.add("RETRY attempt=" + attempt + " file=" + df.relativePath);
                        tmpFile.delete();
                        if (attempt < 3) {
                            try { Thread.sleep(1000L << (attempt - 1)); }
                            catch (InterruptedException ie) { Thread.currentThread().interrupt(); return null; }
                        }
                    }
                    fileLog2.add("FAIL file=" + df.relativePath);
                    Log.e(TAG, "Gen2 file failed after 3 attempts: " + df.relativePath);
                    anyFailed.set(true);
                    return null;
                }));
            }
            pool.shutdown();
            try {
                for (Future<Void> f : futures) f.get();
            } catch (Exception e) {
                pool.shutdownNow();
                return "parallel download error: " + e;
            }
            for (String line : fileLog2) dbg.append(line).append("\n");
            if (cancelled.get()) return "cancelled";
            if (anyFailed.get()) return "one or more chunks failed to download";
            dbg.append("gen2 download complete: ").append(doneCount.get()).append(" files OK\n");

            // Write manifest marker
            String manifestMarker = "{\"gameId\":\"" + game.gameId
                    + "\",\"installDir\":\"" + installDir + "\"}";
            writeFile(new File(installPath, "_gog_manifest.json"), manifestMarker.getBytes("UTF-8"));

            // Delete chunks temp dir
            deleteDir(chunksDir);

            cb.onProgress("Install complete!", 100);

            // Save install dir before exe resolution (needed if onSelectExe is async)
            SharedPreferences.Editor ed0 = ctx.getSharedPreferences("bh_gog_prefs", 0).edit();
            ed0.putString("gog_dir_" + game.gameId, installDir);
            ed0.apply();

            // Find exe — prefer temp_executable hint from manifest
            if (tempExe != null) {
                File hinted = new File(installPath, tempExe);
                if (hinted.exists()) {
                    String exePath = hinted.getAbsolutePath();
                    ctx.getSharedPreferences("bh_gog_prefs", 0).edit()
                            .putString("gog_exe_" + game.gameId, exePath).apply();
                    cb.onComplete(exePath);
                    return null;
                }
            }

            // Collect all candidates; let user pick if ambiguous
            List<String> candidates = collectExeCandidates(installPath);
            if (candidates.size() == 1) {
                String exePath = candidates.get(0);
                ctx.getSharedPreferences("bh_gog_prefs", 0).edit()
                        .putString("gog_exe_" + game.gameId, exePath).apply();
                cb.onComplete(exePath);
            } else if (candidates.size() > 1) {
                cb.onSelectExe(candidates, selected -> {
                    if (selected != null && !selected.isEmpty()) {
                        ctx.getSharedPreferences("bh_gog_prefs", 0).edit()
                                .putString("gog_exe_" + game.gameId, selected).apply();
                    }
                    cb.onComplete(selected != null ? selected : "");
                });
            } else {
                cb.onComplete(""); // no exe found
            }
            return null; // success
        } catch (Exception e) {
            return "exception: " + e;
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Gen 1 pipeline
    // ─────────────────────────────────────────────────────────────────────────

    // Returns null on success, error description string on failure.
    private static String runGen1(Context ctx, GogGame game, String token,
                                   String buildsJson, Callback cb, StringBuilder dbg,
                                   AtomicBoolean cancelled, AtomicReference<File> installDirRef) {
        try {
            dbg.append("\n--- Gen1 ---\n");
            JSONObject builds = new JSONObject(buildsJson);
            JSONArray items = builds.optJSONArray("items");
            if (items == null || items.length() == 0)
                return builds.optInt("total_count", -1) == 0 ? "NO_CS_BUILDS" : "no items (api error)";

            String manifestUrl = null;
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                if ("windows".equals(item.optString("os"))) {
                    manifestUrl = item.optString("link");
                    break;
                }
            }
            if (manifestUrl == null || manifestUrl.isEmpty())
                return "no windows manifest URL";
            dbg.append("manifestUrl=").append(manifestUrl.substring(0, Math.min(80, manifestUrl.length()))).append("\n");

            cb.onProgress("Fetching Gen 1 manifest…", 12);
            byte[] raw = fetchBytes(manifestUrl, token);
            if (raw == null) return "manifest fetch null";
            String manifestStr = decompressBytes(raw);
            if (manifestStr == null) return "manifest decompress failed";

            JSONObject manifest = new JSONObject(manifestStr);
            String installDir  = manifest.optString("installDirectory", game.title);
            JSONArray depots   = manifest.optJSONArray("depot");
            if (depots == null) return "no depot array in manifest";

            // Collect files from all depots
            List<Gen1File> files = new ArrayList<>();
            for (int i = 0; i < depots.length(); i++) {
                JSONObject depot = depots.getJSONObject(i);
                boolean isSupport = depot.optBoolean("support", false);
                if (isSupport) continue;
                JSONArray jFiles = depot.optJSONArray("files");
                if (jFiles == null) continue;
                for (int j = 0; j < jFiles.length(); j++) {
                    JSONObject f = jFiles.getJSONObject(j);
                    String path   = f.optString("path");
                    long offset   = f.optLong("offset", 0);
                    long size     = f.optLong("size", 0);
                    String url    = f.optString("url");
                    if (path == null || url == null || size == 0) continue;
                    files.add(new Gen1File(path, url, offset, size));
                }
            }

            if (files.isEmpty()) return "no files in manifest";
            dbg.append("gen1 files=").append(files.size()).append("\n");

            File installPath = GogInstallPath.getInstallDir(ctx, installDir);
            installPath.mkdirs();
            installDirRef.set(installPath);

            final int totalG1                   = files.size();
            final AtomicInteger doneG1          = new AtomicInteger(0);
            final AtomicLong    totalBytesG1    = new AtomicLong(0);
            final AtomicLong    lastSpeedMsG1   = new AtomicLong(System.currentTimeMillis());
            final AtomicLong    lastSpeedBG1    = new AtomicLong(0);
            final AtomicLong    speedBpsG1      = new AtomicLong(0);
            final AtomicBoolean anyFailedG1     = new AtomicBoolean(false);
            final java.util.concurrent.ConcurrentLinkedQueue<String> fileLog1 =
                    new java.util.concurrent.ConcurrentLinkedQueue<>();
            dbg.append("gen1 parallel download: ").append(totalG1).append(" files, 8 threads\n");

            ExecutorService poolG1 = Executors.newFixedThreadPool(8);
            List<Future<Void>> futuresG1 = new ArrayList<>();
            for (Gen1File gf : files) {
                futuresG1.add(poolG1.submit((Callable<Void>) () -> {
                    if (cancelled.get() || anyFailedG1.get()) return null;
                    File outFile = new File(installPath, gf.path);
                    outFile.getParentFile().mkdirs();

                    // Resume: skip if size already matches
                    if (outFile.exists() && outFile.length() == gf.size) {
                        int done = doneG1.incrementAndGet();
                        int pct  = 15 + (int) ((done / (float) totalG1) * 80);
                        cb.onProgress("Resuming…", pct);
                        return null;
                    }

                    for (int attempt = 1; attempt <= 3; attempt++) {
                        if (cancelled.get()) return null;
                        outFile.delete();
                        boolean ok = downloadRange(gf.url, gf.offset, gf.size, outFile);
                        if (ok) {
                            int done   = doneG1.incrementAndGet();
                            long tb    = totalBytesG1.addAndGet(gf.size);
                            int pct    = 15 + (int) ((done / (float) totalG1) * 80);
                            long nowMs  = System.currentTimeMillis();
                            long prevMs = lastSpeedMsG1.get();
                            if (nowMs - prevMs >= 500 && lastSpeedMsG1.compareAndSet(prevMs, nowMs)) {
                                long prevB = lastSpeedBG1.getAndSet(tb);
                                long dt = nowMs - prevMs;
                                if (dt > 0) speedBpsG1.set((tb - prevB) * 1000L / dt);
                            }
                            String speedStr = formatSpeed(speedBpsG1.get());
                            String name = gf.path.contains("/")
                                    ? gf.path.substring(gf.path.lastIndexOf('/') + 1) : gf.path;
                            cb.onProgress("Downloading: " + name
                                    + (speedStr.isEmpty() ? "" : "  " + speedStr), pct);
                            return null;
                        }
                        fileLog1.add("RETRY attempt=" + attempt + " file=" + gf.path);
                        if (attempt < 3) {
                            try { Thread.sleep(1000L << (attempt - 1)); }
                            catch (InterruptedException ie) { Thread.currentThread().interrupt(); return null; }
                        }
                    }
                    fileLog1.add("FAIL file=" + gf.path);
                    Log.e(TAG, "Gen1 file failed after 3 attempts: " + gf.path);
                    anyFailedG1.set(true);
                    return null;
                }));
            }
            poolG1.shutdown();
            try {
                for (Future<Void> f : futuresG1) f.get();
            } catch (Exception e) {
                poolG1.shutdownNow();
                return "gen1 parallel error: " + e;
            }
            for (String line : fileLog1) dbg.append(line).append("\n");
            if (cancelled.get()) return "cancelled";
            if (anyFailedG1.get()) return "one or more gen1 files failed to download";
            dbg.append("gen1 download complete: ").append(doneG1.get()).append(" files OK\n");

            cb.onProgress("Install complete!", 100);

            SharedPreferences.Editor ed0 = ctx.getSharedPreferences("bh_gog_prefs", 0).edit();
            ed0.putString("gog_dir_" + game.gameId, installDir);
            ed0.apply();

            List<String> candidates = collectExeCandidates(installPath);
            if (candidates.size() == 1) {
                String exePath = candidates.get(0);
                ctx.getSharedPreferences("bh_gog_prefs", 0).edit()
                        .putString("gog_exe_" + game.gameId, exePath).apply();
                cb.onComplete(exePath);
            } else if (candidates.size() > 1) {
                cb.onSelectExe(candidates, selected -> {
                    if (selected != null && !selected.isEmpty()) {
                        ctx.getSharedPreferences("bh_gog_prefs", 0).edit()
                                .putString("gog_exe_" + game.gameId, selected).apply();
                    }
                    cb.onComplete(selected != null ? selected : "");
                });
            } else {
                cb.onComplete("");
            }
            return null; // success
        } catch (Exception e) {
            return "exception: " + e;
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Installer (old GOG downloader — games without content-system builds)
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Fetches the Windows installer for games that have no content-system builds.
     * Uses api.gog.com/products/{id}?expand=downloads → installers[].manualUrl
     * → follow redirect → download .exe to installDir.
     * Returns null on success, error string on failure.
     */
    private static String runInstaller(Context ctx, GogGame game, String token,
                                        Callback cb, StringBuilder dbg,
                                        AtomicBoolean cancelled, AtomicReference<File> installDirRef) {
        try {
            dbg.append("\n--- Installer fallback ---\n");
            String productUrl = "https://api.gog.com/products/" + game.gameId + "?expand=downloads";
            String productJson = httpGet(productUrl, token);
            dbg.append("product_response=").append(productJson == null ? "NULL"
                    : productJson.substring(0, Math.min(400, productJson.length()))).append("\n");
            if (productJson == null) return "product fetch null";

            JSONObject product = new JSONObject(productJson);
            JSONObject downloads = product.optJSONObject("downloads");
            if (downloads == null) return "no downloads object";

            JSONArray installers = downloads.optJSONArray("installers");
            if (installers == null || installers.length() == 0) return "no installers";

            // Find windows installer
            String manualUrl = null;
            String fileName  = null;
            for (int i = 0; i < installers.length(); i++) {
                JSONObject inst = installers.getJSONObject(i);
                if ("windows".equals(inst.optString("os"))) {
                    JSONArray files = inst.optJSONArray("files");
                    if (files != null && files.length() > 0) {
                        JSONObject f = files.getJSONObject(0);
                        manualUrl = f.optString("downlink", null);
                        if (manualUrl == null) manualUrl = f.optString("manualUrl", null);
                        fileName  = f.optString("filename", game.title + "_installer.exe");
                    }
                    if (manualUrl == null) manualUrl = inst.optString("manualUrl", null);
                    if (fileName == null)  fileName  = game.title + "_installer.exe";
                    break;
                }
            }
            dbg.append("manualUrl=").append(manualUrl).append(" fileName=").append(fileName).append("\n");
            if (manualUrl == null) return "no windows installer manualUrl";

            // Resolve the manualUrl → signed download URL (follows redirect)
            String downloadUrl = resolveRedirect(manualUrl, token);
            dbg.append("downloadUrl=").append(downloadUrl == null ? "NULL"
                    : downloadUrl.substring(0, Math.min(120, downloadUrl.length()))).append("\n");
            if (downloadUrl == null) return "redirect resolve failed";

            // Download the installer .exe
            File installDir = GogInstallPath.getInstallDir(ctx, game.title);
            installDir.mkdirs();
            installDirRef.set(installDir);
            if (cancelled.get()) return "cancelled";
            File outFile = new File(installDir, fileName);

            cb.onProgress("Downloading installer: " + fileName, 15);
            downloadWithProgress(downloadUrl, outFile, cb, cancelled);

            // Save prefs
            SharedPreferences.Editor ed = ctx.getSharedPreferences("bh_gog_prefs", 0).edit();
            ed.putString("gog_dir_" + game.gameId, game.title);
            ed.putString("gog_exe_" + game.gameId, outFile.getAbsolutePath());
            ed.apply();

            cb.onProgress("Installer downloaded!", 100);
            cb.onComplete(outFile.getAbsolutePath());
            return null; // success
        } catch (Exception e) {
            return "exception: " + e;
        }
    }

    /**
     * Follows HTTP redirects on the GOG manualUrl to get the actual download URL.
     * Handles: relative URLs, multi-hop redirects (up to 5), and GOG API endpoints
     * that return 200 JSON with a nested "downlink" field instead of a redirect.
     */
    private static String resolveRedirect(String url, String token) {
        try {
            // GOG manualUrl is relative like /downloader/get/... — prepend host
            if (url.startsWith("/")) url = "https://www.gog.com" + url;
            for (int hop = 0; hop < 5; hop++) {
                HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
                conn.setConnectTimeout(TIMEOUT);
                conn.setReadTimeout(TIMEOUT);
                conn.setInstanceFollowRedirects(false);
                if (token != null) conn.setRequestProperty("Authorization", "Bearer " + token);
                int code = conn.getResponseCode();
                String location = conn.getHeaderField("Location");
                if (code == 301 || code == 302 || code == 303 || code == 307 || code == 308) {
                    conn.disconnect();
                    if (location == null) return null;
                    if (location.startsWith("/")) location = "https://www.gog.com" + location;
                    url = location;
                    continue;
                }
                if (code == 200) {
                    // Some GOG API endpoints return JSON {"downlink":"https://..."} instead of redirect
                    String ct = conn.getContentType();
                    if (ct != null && ct.contains("application/json")) {
                        StringBuilder sb = new StringBuilder();
                        try (BufferedReader br = new BufferedReader(
                                new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                            String line;
                            while ((line = br.readLine()) != null) sb.append(line);
                        }
                        conn.disconnect();
                        JSONObject json = new JSONObject(sb.toString());
                        String inner = json.optString("downlink", null);
                        if (inner != null && !inner.isEmpty()) {
                            url = inner;
                            continue; // follow the inner URL
                        }
                    } else {
                        conn.disconnect();
                    }
                    return url; // final URL
                }
                conn.disconnect();
                return null; // unexpected response
            }
            return null; // too many hops
        } catch (Exception e) {
            return null;
        }
    }

    private static String formatSpeed(long bps) {
        if (bps <= 0) return "";
        if (bps >= 1048576) return String.format("%.1f MB/s", bps / 1048576.0);
        return (bps / 1024) + " KB/s";
    }

    /** Downloads url to outFile, reporting progress via cb. */
    private static void downloadWithProgress(String url, File out, Callback cb, AtomicBoolean cancelled) {
        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setConnectTimeout(TIMEOUT);
            conn.setReadTimeout(60_000);
            int total = conn.getContentLength();
            try (InputStream is = conn.getInputStream();
                 FileOutputStream fos = new FileOutputStream(out)) {
                byte[] buf = new byte[131072];
                int n, downloaded = 0;
                long speedWindowStart = System.currentTimeMillis();
                long speedWindowBytes = 0;
                long speedBps = 0;
                while ((n = is.read(buf)) != -1) {
                    if (cancelled.get()) return;
                    fos.write(buf, 0, n);
                    downloaded += n;
                    speedWindowBytes += n;
                    long elapsed = System.currentTimeMillis() - speedWindowStart;
                    if (elapsed >= 500) {
                        speedBps = speedWindowBytes * 1000L / elapsed;
                        speedWindowStart = System.currentTimeMillis();
                        speedWindowBytes = 0;
                    }
                    if (total > 0) {
                        int pct = 15 + (int) ((downloaded / (float) total) * 80);
                        String speed = formatSpeed(speedBps);
                        cb.onProgress("Downloading: " + out.getName()
                                + (speed.isEmpty() ? "" : "  " + speed), pct);
                    }
                }
            }
            conn.disconnect();
        } catch (Exception e) {
            Log.e(TAG, "downloadWithProgress failed", e);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────────────────────────────────

    /** Parses a Gen 2 depot manifest and appends DepotFile entries to {@code out}. */
    private static void parseDepotManifest(String json, List<DepotFile> out) {
        try {
            JSONObject root = new JSONObject(json);
            JSONObject depotObj = root.optJSONObject("depot");
            if (depotObj == null) return;
            JSONArray depot = depotObj.optJSONArray("items");
            if (depot == null) return;
            for (int i = 0; i < depot.length(); i++) {
                JSONObject entry = depot.getJSONObject(i);
                String path = entry.optString("path", "").replace("\\", "/");
                if (path.startsWith("/")) path = path.substring(1);
                JSONArray chunks = entry.optJSONArray("chunks");
                if (path.isEmpty() || chunks == null || chunks.length() == 0) continue;

                DepotFile df = new DepotFile(path);
                for (int c = 0; c < chunks.length(); c++) {
                    JSONObject chunk = chunks.getJSONObject(c);
                    String md5 = chunk.optString("compressedMd5");
                    if (md5 == null || md5.isEmpty()) md5 = chunk.optString("md5");
                    if (md5 != null && !md5.isEmpty()) df.chunks.add(new DepotFile.ChunkRef(md5));
                }
                if (!df.chunks.isEmpty()) out.add(df);
            }
        } catch (Exception e) {
            Log.w(TAG, "parseDepotManifest error", e);
        }
    }

    /** Builds the CDN path from a chunk hash: "ab/cd/abcdef..." */
    private static String buildCdnPath(String hash) {
        return hash.substring(0, 2) + "/" + hash.substring(2, 4) + "/" + hash;
    }

    /** Parses the secure_link JSON → CDN base URL (strips trailing /{path}). */
    private static String parseCdnUrl(String json) {
        if (json == null) return null;
        try {
            JSONObject obj = new JSONObject(json);
            JSONArray urls = obj.optJSONArray("urls");
            if (urls == null || urls.length() == 0) return null;
            JSONObject first = urls.getJSONObject(0);
            String urlFormat = first.optString("url_format");
            JSONObject params = first.optJSONObject("parameters");
            if (urlFormat == null || params == null) return null;

            // Replace {key} placeholders
            java.util.Iterator<String> keys = params.keys();
            while (keys.hasNext()) {
                String k = keys.next();
                String v = params.optString(k);
                urlFormat = urlFormat.replace("{" + k + "}", v);
            }
            urlFormat = urlFormat.replace("\\/", "/");

            // Strip trailing /{path}
            int idx = urlFormat.indexOf("/{path}");
            if (idx >= 0) urlFormat = urlFormat.substring(0, idx);
            return urlFormat;
        } catch (Exception e) {
            return null;
        }
    }

    /** Downloads a byte range from {@code url} and writes it to {@code out}. */
    private static boolean downloadRange(String url, long offset, long size, File out) {
        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setConnectTimeout(TIMEOUT);
            conn.setReadTimeout(TIMEOUT);
            conn.setRequestProperty("Range", "bytes=" + offset + "-" + (offset + size - 1));
            try (InputStream is = conn.getInputStream();
                 FileOutputStream fos = new FileOutputStream(out)) {
                byte[] buf = new byte[131072];
                int n;
                while ((n = is.read(buf)) != -1) fos.write(buf, 0, n);
            }
            conn.disconnect();
            return true;
        } catch (Exception e) {
            Log.w(TAG, "downloadRange failed: " + url, e);
            return false;
        }
    }

    /** HTTP GET, returns response body string or null on failure. */
    private static String httpGet(String url, String token) {
        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setConnectTimeout(TIMEOUT);
            conn.setReadTimeout(TIMEOUT);
            conn.setRequestProperty("User-Agent", "GOG Galaxy");
            if (token != null) conn.setRequestProperty("Authorization", "Bearer " + token);
            if (conn.getResponseCode() != 200) { conn.disconnect(); return null; }
            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            conn.disconnect();
            return sb.toString();
        } catch (Exception e) {
            return null;
        }
    }

    /** Fetches URL bytes, returns null on failure. */
    private static byte[] fetchBytes(String url, String token) {
        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setConnectTimeout(TIMEOUT);
            conn.setReadTimeout(TIMEOUT);
            conn.setRequestProperty("User-Agent", "GOG Galaxy");
            if (token != null) conn.setRequestProperty("Authorization", "Bearer " + token);
            if (conn.getResponseCode() != 200) { conn.disconnect(); return null; }
            int contentLength = conn.getContentLength();
            ByteArrayOutputStream bos = contentLength > 0
                    ? new ByteArrayOutputStream(contentLength)
                    : new ByteArrayOutputStream();
            byte[] buf = new byte[131072];
            try (InputStream is = conn.getInputStream()) {
                int n;
                while ((n = is.read(buf)) != -1) bos.write(buf, 0, n);
            }
            conn.disconnect();
            return bos.toByteArray();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Detects gzip (0x1F 0x8B) or zlib (0x78 xx) and decompresses.
     * Falls back to raw UTF-8 string.
     */
    private static String decompressBytes(byte[] data) {
        if (data == null || data.length < 2) return null;
        try {
            int b0 = data[0] & 0xFF, b1 = data[1] & 0xFF;
            if (b0 == 0x1F && b1 == 0x8B) {
                // gzip
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                try (GZIPInputStream gzip = new GZIPInputStream(new ByteArrayInputStream(data))) {
                    byte[] buf = new byte[4096];
                    int n;
                    while ((n = gzip.read(buf)) != -1) bos.write(buf, 0, n);
                }
                return bos.toString("UTF-8");
            }
            if (b0 == 0x78) {
                // zlib
                Inflater inf = new Inflater();
                inf.setInput(data);
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                byte[] buf = new byte[4096];
                while (!inf.finished()) {
                    int n = inf.inflate(buf);
                    if (n == 0) break;
                    bos.write(buf, 0, n);
                }
                inf.end();
                return bos.toString("UTF-8");
            }
            return new String(data, "UTF-8");
        } catch (Exception e) {
            return null;
        }
    }

    /** zlib-inflate a raw deflate block (chunk data). */
    private static byte[] inflateZlib(byte[] data) {
        try {
            if (data == null || data.length < 2) return null;
            int b0 = data[0] & 0xFF;
            if (b0 != 0x78) return null; // not zlib
            Inflater inf = new Inflater();
            inf.setInput(data);
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            byte[] buf = new byte[8192];
            while (!inf.finished()) {
                int n = inf.inflate(buf);
                if (n == 0) break;
                bos.write(buf, 0, n);
            }
            inf.end();
            return bos.toByteArray();
        } catch (Exception e) {
            return null;
        }
    }

    private static void writeFile(File f, byte[] data) throws IOException {
        try (FileOutputStream fos = new FileOutputStream(f)) {
            fos.write(data);
        }
    }

    private static void deleteDir(File dir) {
        if (dir == null || !dir.exists()) return;
        File[] children = dir.listFiles();
        if (children != null) for (File c : children) deleteDir(c);
        dir.delete();
    }

    /**
     * Scans {@code installDir} recursively for the first .exe that is not in
     * a "redist" or "Redist" path (same heuristic as BannerHub).
     * Returns absolute path or null.
     */
    static String findExe(File installDir, String gameId, String relDir) {
        String found = findExeRecursive(installDir);
        return found;
    }

    private static String findExeRecursive(File dir) {
        if (!dir.isDirectory()) return null;
        File[] files = dir.listFiles();
        if (files == null) return null;
        for (File f : files) {
            if (f.isFile() && f.getName().toLowerCase().endsWith(".exe")) {
                String path = f.getAbsolutePath().toLowerCase();
                if (!path.contains("redist") && !path.contains("unins")) {
                    return f.getAbsolutePath();
                }
            }
        }
        for (File f : files) {
            if (f.isDirectory()) {
                String sub = findExeRecursive(f);
                if (sub != null) return sub;
            }
        }
        return null;
    }

    /**
     * Collects ALL qualifying .exe candidates under {@code dir}, excluding
     * known helper/redist patterns.  Returns absolute paths, shallowest first.
     */
    static List<String> collectExeCandidates(File dir) {
        List<String> result = new ArrayList<>();
        collectExeRecursive(dir, result);
        return result;
    }

    private static void collectExeRecursive(File dir, List<String> out) {
        if (!dir.isDirectory()) return;
        File[] files = dir.listFiles();
        if (files == null) return;
        // Files before subdirs so shallowest paths appear first
        for (File f : files) {
            if (f.isFile() && f.getName().toLowerCase().endsWith(".exe")) {
                String path = f.getAbsolutePath().toLowerCase();
                if (!path.contains("redist") && !path.contains("unins")
                        && !path.contains("setup") && !path.contains("crash")
                        && !path.contains("report") && !path.contains("helper")
                        && !path.contains("dotnet") && !path.contains("vcredist")
                        && !path.contains("directx")) {
                    out.add(f.getAbsolutePath());
                }
            }
        }
        for (File f : files) {
            if (f.isDirectory()) collectExeRecursive(f, out);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Data holders
    // ─────────────────────────────────────────────────────────────────────────

    private static class DepotFile {
        final String relativePath;
        final List<ChunkRef> chunks = new ArrayList<>();

        DepotFile(String relativePath) { this.relativePath = relativePath; }

        static class ChunkRef {
            final String hash;
            ChunkRef(String hash) { this.hash = hash; }
        }
    }

    private static class Gen1File {
        final String path, url;
        final long offset, size;
        Gen1File(String path, String url, long offset, long size) {
            this.path = path; this.url = url; this.offset = offset; this.size = size;
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Pre-install size check
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Fetches the estimated installed size in bytes for a game.
     * Gen 2: fetches builds → manifest → sums depot[].size fields (2 HTTP calls).
     * Gen 1: checks items[].total_size in builds response.
     * Returns -1 if the size cannot be determined.
     * Runs on the calling thread — call from a background thread.
     */
    public static long fetchGameSize(Context ctx, GogGame game) {
        try {
            SharedPreferences prefs = ctx.getSharedPreferences("bh_gog_prefs", 0);
            String token = prefs.getString("access_token", null);
            if (token == null) return -1;

            // Gen 2: builds → manifest → sum depot sizes
            String buildsUrl = "https://content-system.gog.com/products/" + game.gameId
                    + "/os/windows/builds?generation=2";
            String buildsJson = httpGet(buildsUrl, null);
            if (buildsJson == null) buildsJson = httpGet(buildsUrl, token);
            if (buildsJson != null) {
                JSONObject builds = new JSONObject(buildsJson);
                JSONArray items = builds.optJSONArray("items");
                if (items != null) {
                    for (int i = 0; i < items.length(); i++) {
                        JSONObject item = items.getJSONObject(i);
                        if (!"windows".equals(item.optString("os"))) continue;
                        String mUrl = item.optString("link");
                        if (mUrl == null || mUrl.isEmpty()) mUrl = item.optString("meta_url");
                        if (mUrl == null || mUrl.isEmpty()) break;
                        byte[] raw = fetchBytes(mUrl, token);
                        if (raw == null) break;
                        String mStr = decompressBytes(raw);
                        if (mStr == null) break;
                        JSONObject manifest = new JSONObject(mStr);
                        JSONArray depots = manifest.optJSONArray("depots");
                        if (depots != null) {
                            long total = 0;
                            for (int d = 0; d < depots.length(); d++)
                                total += depots.getJSONObject(d).optLong("size", 0);
                            if (total > 0) return total;
                        }
                        break;
                    }
                }
            }

            // Gen 1 fallback: check total_size in build items
            String builds1Url = "https://content-system.gog.com/products/" + game.gameId
                    + "/os/windows/builds?generation=1";
            String builds1Json = httpGet(builds1Url, null);
            if (builds1Json == null) builds1Json = httpGet(builds1Url, token);
            if (builds1Json != null) {
                JSONObject builds1 = new JSONObject(builds1Json);
                JSONArray items1 = builds1.optJSONArray("items");
                if (items1 != null) {
                    for (int i = 0; i < items1.length(); i++) {
                        JSONObject item = items1.getJSONObject(i);
                        if (!"windows".equals(item.optString("os"))) continue;
                        long sz = item.optLong("total_size", 0);
                        if (sz > 0) return sz;
                        break;
                    }
                }
            }
            return -1;
        } catch (Exception e) {
            return -1;
        }
    }

    /** Formats a byte count as a human-readable string (KB / MB / GB). */
    public static String formatBytes(long bytes) {
        if (bytes <= 0) return "Unknown";
        if (bytes < 1024L * 1024) return String.format("%.1f KB", bytes / 1024.0);
        if (bytes < 1024L * 1024 * 1024) return String.format("%.1f MB", bytes / (1024.0 * 1024));
        return String.format("%.2f GB", bytes / (1024.0 * 1024 * 1024));
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Copy to Downloads (public, called from GogGamesActivity)
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Copies an installed game's directory to the public Downloads/GOG Games/ folder.
     * Runs on the calling thread — must be called from a background thread.
     * Returns the destination path, or null on failure.
     */
    public static String copyToDownloads(Context ctx, String gameId) {
        SharedPreferences prefs = ctx.getSharedPreferences("bh_gog_prefs", 0);
        String dirName = prefs.getString("gog_dir_" + gameId, null);
        if (dirName == null) return null;

        File src = GogInstallPath.getInstallDir(ctx, dirName);
        if (!src.exists()) return null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            // Android 10+ — MediaStore.Downloads, no permission needed
            try {
                String relPath = "Download/GOG Games/" + dirName;
                copyDirMediaStore(ctx, src, relPath);
                return relPath;
            } catch (Exception e) {
                Log.e(TAG, "copyToDownloads (MediaStore) failed", e);
                return null;
            }
        } else {
            // Android 9 and below — direct File copy
            File dest = new File(
                    new File(Environment.getExternalStoragePublicDirectory(
                            Environment.DIRECTORY_DOWNLOADS), "GOG Games"), dirName);
            dest.mkdirs();
            try {
                copyDir(src, dest);
                return dest.getAbsolutePath();
            } catch (Exception e) {
                Log.e(TAG, "copyToDownloads failed", e);
                return null;
            }
        }
    }

    @android.annotation.TargetApi(android.os.Build.VERSION_CODES.Q)
    private static void copyDirMediaStore(Context ctx, File src, String relativePath)
            throws IOException {
        File[] files = src.listFiles();
        if (files == null) return;
        for (File f : files) {
            if (f.isDirectory()) {
                copyDirMediaStore(ctx, f, relativePath + "/" + f.getName());
            } else {
                android.content.ContentValues cv = new android.content.ContentValues();
                cv.put(android.provider.MediaStore.Downloads.DISPLAY_NAME, f.getName());
                cv.put(android.provider.MediaStore.Downloads.RELATIVE_PATH, relativePath + "/");
                cv.put(android.provider.MediaStore.Downloads.IS_PENDING, 1);

                android.net.Uri uri = ctx.getContentResolver().insert(
                        android.provider.MediaStore.Downloads.EXTERNAL_CONTENT_URI, cv);
                if (uri == null) throw new IOException("MediaStore insert failed: " + f.getName());

                try (java.io.OutputStream os = ctx.getContentResolver().openOutputStream(uri);
                     FileInputStream fis = new FileInputStream(f)) {
                    if (os == null) throw new IOException("openOutputStream null");
                    byte[] buf = new byte[8192];
                    int n;
                    while ((n = fis.read(buf)) != -1) os.write(buf, 0, n);
                }

                cv.clear();
                cv.put(android.provider.MediaStore.Downloads.IS_PENDING, 0);
                ctx.getContentResolver().update(uri, cv, null, null);
            }
        }
    }

    private static void copyDir(File src, File dst) throws IOException {
        File[] files = src.listFiles();
        if (files == null) return;
        for (File f : files) {
            File target = new File(dst, f.getName());
            if (f.isDirectory()) {
                target.mkdirs();
                copyDir(f, target);
            } else {
                copyFile(f, target);
            }
        }
    }

    private static void copyFile(File src, File dst) throws IOException {
        byte[] buf = new byte[8192];
        try (FileInputStream fis = new FileInputStream(src);
             FileOutputStream fos = new FileOutputStream(dst)) {
            int n;
            while ((n = fis.read(buf)) != -1) fos.write(buf, 0, n);
        }
    }
}
