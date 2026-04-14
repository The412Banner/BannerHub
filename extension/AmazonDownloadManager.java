package app.revanced.extension.gamehub;

import android.content.Context;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Amazon Games download pipeline.
 *
 * Flow:
 *   1. GetGameDownload (entitlementId) → downloadUrl + versionId
 *   2. GET {downloadUrl}/manifest.proto → parse AmazonManifest
 *   3. For each file (batches of 6 parallel):
 *      a. Resume check: skip if destFile.length() == file.size
 *      b. GET {downloadUrl}/files/{hashHex} → tmp file
 *      c. SHA-256 verify → rename to final path
 *   4. Mark game installed
 *
 * Configuration:
 *   MAX_PARALLEL = 6, MAX_RETRIES = 3, backoff 1s/2s/4s
 *   Progress emitted every 512KB
 *   Cancellation checked per batch and inside byte-copy loop
 *   Download User-Agent: "nile/0.1 Amazon"
 */
public class AmazonDownloadManager {

    private static final String TAG                   = "BH_AMAZON";
    private static final int    MAX_PARALLEL          = 8;
    private static final int    MAX_RETRIES           = 3;
    private static final long   PROGRESS_INTERVAL     = 512L * 1024L;  // 512 KB
    private static final String DOWNLOAD_USER_AGENT   = "nile/0.1 Amazon";

    private static final String IN_PROGRESS_MARKER    = ".amazon_download_in_progress";
    private static final String COMPLETE_MARKER        = ".amazon_download_complete";

    // ── Callbacks ─────────────────────────────────────────────────────────────

    public interface ProgressCallback {
        /** Called on a background thread. bytesDownloaded / totalBytes may be -1 if unknown. */
        void onProgress(long bytesDownloaded, long totalBytes, String currentFile);
    }

    public interface CancelChecker {
        boolean isCancelled();
    }

    // ── Main entry ────────────────────────────────────────────────────────────

    /**
     * Downloads and installs an Amazon game.
     *
     * @param ctx        Android context (for filesDir)
     * @param game       AmazonGame with entitlementId + productSku populated
     * @param accessToken valid bearer token (auto-refreshed if needed)
     * @param installDir  target install directory
     * @param progress    progress callback (may be null)
     * @param cancel      cancellation checker (may be null)
     * @return true on success, false on failure or cancellation
     */
    public static boolean install(Context ctx,
                                   AmazonGame game,
                                   String accessToken,
                                   File installDir,
                                   ProgressCallback progress,
                                   CancelChecker cancel) {
        StringBuilder dbg = new StringBuilder();
        dbg.append("=== BH Amazon Debug === game=").append(game.productId)
           .append(" title=").append(game.title).append("\n");
        dbg.append("entitlementId=").append(game.entitlementId).append("\n");

        if (game.entitlementId == null || game.entitlementId.isEmpty()) {
            dbg.append("ERROR: entitlementId is blank\n");
            writeDebug(ctx, dbg);
            Log.e(TAG, "entitlementId is blank for: " + game.title);
            return false;
        }

        try {
            // Create install dir
            installDir.mkdirs();
            new File(installDir, IN_PROGRESS_MARKER).createNewFile();

            // Step 1: GetGameDownload
            log("Getting download spec for: " + game.title);
            AmazonApiClient.GameDownloadSpec spec =
                    AmazonApiClient.getGameDownload(accessToken, game.entitlementId);
            if (spec == null) {
                dbg.append("ERROR: getGameDownload returned null\n");
                writeDebug(ctx, dbg);
                Log.e(TAG, "getGameDownload failed for: " + game.title);
                return false;
            }
            dbg.append("downloadUrl=").append(spec.downloadUrl).append("\n");
            dbg.append("versionId=").append(spec.versionId).append("\n");
            log("downloadUrl: " + spec.downloadUrl);

            // Step 2: Download manifest
            log("Downloading manifest.proto...");
            String manifestUrl = AmazonApiClient.appendPath(spec.downloadUrl, "manifest.proto");
            dbg.append("manifestUrl=").append(manifestUrl).append("\n");
            byte[] manifestBytes = AmazonApiClient.getBytes(manifestUrl, accessToken);
            if (manifestBytes == null) {
                dbg.append("ERROR: manifest download failed\n");
                writeDebug(ctx, dbg);
                Log.e(TAG, "manifest download failed");
                return false;
            }
            dbg.append("manifestBytes=").append(manifestBytes.length).append("\n");
            log("Manifest downloaded: " + manifestBytes.length + " bytes");

            // Step 3: Parse manifest
            AmazonManifest.ParsedManifest manifest = AmazonManifest.parse(manifestBytes);
            dbg.append("files=").append(manifest.allFiles.size())
               .append(" totalInstallSize=").append(manifest.totalInstallSize)
               .append(String.format(" (%.1f MB)\n", manifest.totalInstallSize / 1048576.0));
            log("Manifest parsed: " + manifest.allFiles.size() + " files, "
                    + manifest.totalInstallSize + " bytes total");

            if (progress != null) {
                progress.onProgress(0, manifest.totalInstallSize, "Starting…");
            }

            // Step 4: Download all files — MAX_PARALLEL threads
            AtomicLong downloaded      = new AtomicLong(0);
            AtomicLong lastEmit        = new AtomicLong(0);
            AtomicLong lastSpeedMs     = new AtomicLong(System.currentTimeMillis());
            AtomicLong lastSpeedBytes  = new AtomicLong(0);
            AtomicLong currentSpeedBps = new AtomicLong(0);
            List<AmazonManifest.ManifestFile> files = manifest.allFiles;
            java.util.concurrent.ConcurrentLinkedQueue<String> fileLog =
                    new java.util.concurrent.ConcurrentLinkedQueue<>();

            ExecutorService pool = Executors.newFixedThreadPool(MAX_PARALLEL);
            List<Future<Boolean>> futures = new ArrayList<>();
            for (AmazonManifest.ManifestFile file : files) {
                final String dlUrl = spec.downloadUrl;
                final String tkn   = accessToken;
                futures.add(pool.submit(() -> {
                    boolean ok = downloadFileWithRetry(
                            file, dlUrl, tkn, installDir,
                            downloaded, lastEmit, manifest.totalInstallSize,
                            lastSpeedMs, lastSpeedBytes, currentSpeedBps,
                            progress, cancel);
                    if (!ok) fileLog.add("FAIL: " + file.unixPath());
                    return ok;
                }));
            }
            pool.shutdown();
            try {
                for (Future<Boolean> f : futures) {
                    if (!f.get()) {
                        for (String line : fileLog) dbg.append(line).append("\n");
                        dbg.append("ERROR: a file failed — aborting\n");
                        writeDebug(ctx, dbg);
                        log("A file failed — aborting download");
                        pool.shutdownNow();
                        deleteMarker(installDir, IN_PROGRESS_MARKER);
                        return false;
                    }
                }
            } catch (Exception e) {
                for (String line : fileLog) dbg.append(line).append("\n");
                dbg.append("ERROR: pool exception=").append(e).append("\n");
                writeDebug(ctx, dbg);
                Log.e(TAG, "Download pool error", e);
                pool.shutdownNow();
                deleteMarker(installDir, IN_PROGRESS_MARKER);
                return false;
            }

            // Step 5: Cache manifest and mark installed
            cacheManifest(ctx, game.productId, manifestBytes);

            new File(installDir, IN_PROGRESS_MARKER).delete();
            new File(installDir, COMPLETE_MARKER).createNewFile();

            dbg.append("INSTALL COMPLETE: ").append(game.title)
               .append(" → ").append(installDir.getAbsolutePath()).append("\n");
            writeDebug(ctx, dbg);
            log("Install complete: " + game.title + " → " + installDir.getAbsolutePath());
            return true;

        } catch (Exception e) {
            dbg.append("EXCEPTION: ").append(e).append("\n");
            writeDebug(ctx, dbg);
            Log.e(TAG, "install failed for: " + game.title, e);
            deleteMarker(installDir, IN_PROGRESS_MARKER);
            return false;
        }
    }

    private static void writeDebug(Context ctx, StringBuilder dbg) {
        try {
            java.io.File dir = ctx.getExternalFilesDir(null);
            if (dir == null) dir = ctx.getFilesDir();
            java.io.File f = new java.io.File(dir, "bh_amazon_debug.txt");
            try (java.io.FileOutputStream fos = new java.io.FileOutputStream(f)) {
                fos.write(dbg.toString().getBytes("UTF-8"));
            }
            Log.i(TAG, "Debug written to: " + f.getAbsolutePath());
        } catch (Exception e) {
            Log.e(TAG, "writeDebug failed", e);
        }
    }

    // ── File download with retry ──────────────────────────────────────────────

    private static boolean downloadFileWithRetry(
            AmazonManifest.ManifestFile file,
            String baseUrl,
            String accessToken,
            File installDir,
            AtomicLong totalDownloaded,
            AtomicLong lastEmit,
            long totalSize,
            AtomicLong lastSpeedMs,
            AtomicLong lastSpeedBytes,
            AtomicLong currentSpeedBps,
            ProgressCallback progress,
            CancelChecker cancel) {

        File destFile = new File(installDir, file.unixPath());
        File tmpFile  = new File(installDir, file.unixPath() + ".tmp");

        // Resume check: skip if already fully downloaded
        if (destFile.exists() && destFile.length() == file.size) {
            totalDownloaded.addAndGet(file.size);
            return true;
        }

        String hashHex = file.hashHex();
        String fileUrl = AmazonApiClient.appendPath(baseUrl, "files/" + hashHex);

        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            // Ensure parent dirs exist
            destFile.getParentFile().mkdirs();

            try {
                if (downloadFile(fileUrl, tmpFile, totalDownloaded, lastEmit,
                                 totalSize, lastSpeedMs, lastSpeedBytes, currentSpeedBps,
                                 progress, cancel)) {
                    // SHA-256 verify (hashAlgorithm==0)
                    if (file.hashAlgorithm == 0 && file.hashBytes.length > 0) {
                        byte[] computed = sha256(tmpFile);
                        if (!Arrays.equals(computed, file.hashBytes)) {
                            Log.e(TAG, "SHA-256 mismatch for: " + file.unixPath());
                            tmpFile.delete();
                            if (attempt < MAX_RETRIES) {
                                Thread.sleep(1000L << (attempt - 1));
                                continue;
                            }
                            return false;
                        }
                    }
                    // Rename tmp → dest
                    if (destFile.exists()) destFile.delete();
                    if (!tmpFile.renameTo(destFile)) {
                        Log.e(TAG, "Failed to rename tmp → " + destFile.getAbsolutePath());
                        return false;
                    }
                    return true;
                } else {
                    // Cancelled
                    tmpFile.delete();
                    return false;
                }
            } catch (InterruptedException ie) {
                Thread.currentThread().interrupt();
                tmpFile.delete();
                return false;
            } catch (Exception e) {
                Log.e(TAG, "Attempt " + attempt + " failed for: " + file.unixPath(), e);
                tmpFile.delete();
                if (attempt < MAX_RETRIES) {
                    try { Thread.sleep(1000L << (attempt - 1)); }
                    catch (InterruptedException ie) { Thread.currentThread().interrupt(); return false; }
                }
            }
        }
        return false;
    }

    /**
     * Downloads url to tmpFile.
     * @return true = success, false = cancelled
     */
    private static boolean downloadFile(
            String urlStr,
            File tmpFile,
            AtomicLong totalDownloaded,
            AtomicLong lastEmit,
            long totalSize,
            AtomicLong lastSpeedMs,
            AtomicLong lastSpeedBytes,
            AtomicLong currentSpeedBps,
            ProgressCallback progress,
            CancelChecker cancel) throws IOException {

        HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
        conn.setConnectTimeout(30000);
        conn.setReadTimeout(120000);
        conn.setRequestProperty("User-Agent", DOWNLOAD_USER_AGENT);

        int code = conn.getResponseCode();
        if (code < 200 || code >= 300) {
            Log.e(TAG, "HTTP " + code + " for: " + urlStr);
            conn.disconnect();
            throw new IOException("HTTP " + code);
        }

        try (InputStream in = conn.getInputStream();
             FileOutputStream out = new FileOutputStream(tmpFile)) {

            byte[] buf = new byte[65536];
            int n;
            while ((n = in.read(buf)) >= 0) {
                // Cancellation check inside read loop
                if (cancel != null && cancel.isCancelled()) {
                    conn.disconnect();
                    return false;
                }
                out.write(buf, 0, n);
                long dl = totalDownloaded.addAndGet(n);
                long emit = lastEmit.get();
                if (progress != null && dl - emit >= PROGRESS_INTERVAL) {
                    if (lastEmit.compareAndSet(emit, dl)) {
                        // Speed: one thread wins CAS every 500ms
                        long nowMs     = System.currentTimeMillis();
                        long prevMs    = lastSpeedMs.get();
                        long timeDelta = nowMs - prevMs;
                        if (timeDelta >= 500 && lastSpeedMs.compareAndSet(prevMs, nowMs)) {
                            long prevB  = lastSpeedBytes.getAndSet(dl);
                            long bDelta = dl - prevB;
                            if (timeDelta > 0) currentSpeedBps.set(bDelta * 1000L / timeDelta);
                        }
                        String cleanName = tmpFile.getName().replace(".tmp", "");
                        String speed     = formatSpeed(currentSpeedBps.get());
                        String label     = cleanName + (speed.isEmpty() ? "" : "  " + speed);
                        progress.onProgress(dl, totalSize, label);
                    }
                }
            }
        } finally {
            conn.disconnect();
        }
        return true;
    }

    // ── Install size (no download) ────────────────────────────────────────────

    /**
     * Fetches the total install size (bytes) by downloading and parsing
     * the manifest.proto only. Does NOT download any game files.
     * Returns -1 on failure. Call from a background thread.
     */
    public static long fetchInstallSizeBytes(String accessToken, String entitlementId) {
        try {
            AmazonApiClient.GameDownloadSpec spec =
                    AmazonApiClient.getGameDownload(accessToken, entitlementId);
            if (spec == null) return -1;
            String manifestUrl = AmazonApiClient.appendPath(spec.downloadUrl, "manifest.proto");
            byte[] bytes = AmazonApiClient.getBytes(manifestUrl, accessToken);
            if (bytes == null) return -1;
            AmazonManifest.ParsedManifest manifest = AmazonManifest.parse(bytes);
            return (manifest != null && manifest.totalInstallSize > 0)
                    ? manifest.totalInstallSize : -1;
        } catch (Exception e) {
            Log.w(TAG, "fetchInstallSizeBytes Amazon: " + e.getMessage());
            return -1;
        }
    }

    // ── Speed formatting ─────────────────────────────────────────────────────

    private static String formatSpeed(long bps) {
        if (bps <= 0) return "";
        if (bps >= 1048576) return String.format("%.1f MB/s", bps / 1048576.0);
        return (bps / 1024) + " KB/s";
    }

    // ── SHA-256 ───────────────────────────────────────────────────────────────

    private static byte[] sha256(File file) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        try (FileInputStream fis = new FileInputStream(file)) {
            byte[] buf = new byte[65536];
            int n;
            while ((n = fis.read(buf)) >= 0) {
                digest.update(buf, 0, n);
            }
        }
        return digest.digest();
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private static void cacheManifest(Context ctx, String productId, byte[] data) {
        try {
            File dir = new File(ctx.getFilesDir(), "manifests/amazon");
            dir.mkdirs();
            File f = new File(dir, productId + ".proto");
            try (FileOutputStream fos = new FileOutputStream(f)) {
                fos.write(data);
            }
        } catch (Exception e) {
            Log.e(TAG, "cacheManifest failed", e);
        }
    }

    private static void deleteMarker(File dir, String name) {
        new File(dir, name).delete();
    }

    private static void cleanupTmpFiles(File dir) {
        if (!dir.isDirectory()) return;
        File[] files = dir.listFiles();
        if (files == null) return;
        for (File f : files) {
            if (f.getName().endsWith(".tmp")) f.delete();
        }
    }

    /** Returns true if a partial download exists for this install dir. */
    public static boolean hasPartialDownload(File installDir) {
        return new File(installDir, IN_PROGRESS_MARKER).exists();
    }

    /** Returns true if the game is fully installed. */
    public static boolean isInstalled(File installDir) {
        return new File(installDir, COMPLETE_MARKER).exists();
    }

    private static void log(String msg) {
        Log.d(TAG, msg);
    }
}
