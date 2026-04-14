package app.revanced.extension.gamehub;

import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.zip.Inflater;

/**
 * Epic Games download pipeline.
 *
 * Handles manifest API JSON parsing, CDN selection, manifest binary download/parse,
 * chunk download with CDN rotation, and file assembly.
 *
 * Critical notes (from GameNative EpicDownloadManager):
 *   - Skip cloudflare.epicgamescdn.com CDN — 403 on chunks
 *   - Chunk subfolder = DECIMAL groupNum "%02d" (NOT hex)
 *   - NO auth tokens on chunk URLs — only on manifest binary download
 *   - Binary manifest magic = 0x44BEC00C; JSON manifest if magic doesn't match
 *
 * Credits: The GameNative Team — https://github.com/utkarshdalal/GameNative
 */
public class EpicDownloadManager {

    private static final String TAG = "BH_EPIC";
    private static final String UA  = "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit";

    // ── Public interface ──────────────────────────────────────────────────────

    public interface ProgressCallback {
        void onProgress(String message, int pct);
    }

    // ── Data classes (public for EpicApiClient size calc) ─────────────────────

    /** One CDN entry from the manifest API response. */
    public static class CdnUrl {
        public final String baseUrl;    // e.g. "https://fastly-download.epicgames.com"
        public final String cloudDir;   // e.g. "/Builds/Org/o-xxx/yyy/default"
        public final String authParams; // e.g. "?f_token=..." or ""

        public CdnUrl(String baseUrl, String cloudDir, String authParams) {
            this.baseUrl    = baseUrl;
            this.cloudDir   = cloudDir;
            this.authParams = authParams;
        }
    }

    /** Chunk info from ChunkDataList section. */
    public static class ChunkInfo {
        public int[]  guid = new int[4]; // 4 uint32 in binary read order
        public long   hash;              // uint64 stored as signed long
        public int    groupNum;          // uint8 subfolder (DECIMAL)
        public int    windowSize;        // uncompressed size
        public long   fileSize;          // compressed download size

        public String guidStr() {
            return String.format("%08X%08X%08X%08X", guid[0], guid[1], guid[2], guid[3]);
        }

        /** Full chunk path: "ChunksV4/94/HASH_GUID.chunk" */
        public String getPath(String chunkDir) {
            String sub     = String.format("%02d", groupNum);  // DECIMAL — critical!
            String hashHex = String.format("%016X", hash);
            return chunkDir + "/" + sub + "/" + hashHex + "_" + guidStr() + ".chunk";
        }
    }

    /** One file part referencing a specific chunk. */
    public static class ChunkPart {
        public int[] guid = new int[4];
        public int   offset;
        public int   size;

        public String guidStr() {
            return String.format("%08X%08X%08X%08X", guid[0], guid[1], guid[2], guid[3]);
        }
    }

    /** One file from FileManifestList. */
    public static class FileInfo {
        public String         filename = "";
        public List<ChunkPart> parts   = new ArrayList<>();
    }

    // ── EpicManifest (parsed result + static parse methods) ───────────────────

    public static class EpicManifest {
        public String          chunkDir     = "ChunksV4";
        public List<ChunkInfo> uniqueChunks = new ArrayList<>();
        public List<FileInfo>  files        = new ArrayList<>();

        // Parsed manifest also holds CDN URLs for download
        public List<CdnUrl> cdnUrls = new ArrayList<>();

        /**
         * Parse the manifest API JSON, download the manifest binary, and parse it.
         * Returns null on any failure.
         */
        public static ParsedManifest parseManifestApiJson(String manifestApiJson,
                                                           String accessToken) {
            try {
                List<CdnUrl> cdnUrls = parseCdnUrls(manifestApiJson);
                if (cdnUrls.isEmpty()) {
                    Log.e(TAG, "No CDN URLs in manifest API response");
                    return null;
                }

                byte[] manifestBytes = downloadManifest(manifestApiJson, cdnUrls);
                if (manifestBytes == null || manifestBytes.length == 0) {
                    Log.e(TAG, "Manifest binary download failed");
                    return null;
                }

                ParsedManifest pm = parseManifest(manifestBytes);
                if (pm != null) pm.cdnUrls = cdnUrls;
                return pm;
            } catch (Exception e) {
                Log.e(TAG, "parseManifestApiJson failed", e);
                return null;
            }
        }

        public static class ParsedManifest extends EpicManifest {
            // cdnUrls inherited from EpicManifest
        }
    }

    // ── Main entry: download + install ────────────────────────────────────────

    /**
     * Download and install an Epic game.
     *
     * @param manifestApiJson  Raw JSON string from EpicApiClient.getManifestApiJson()
     * @param accessToken      Access token (NOT used on chunk URLs — only stored for future use)
     * @param installDirPath   Absolute path where game files should be written
     * @param progressCallback Optional progress callback
     * @return true on success
     */
    public static boolean install(
            android.content.Context ctx,
            String manifestApiJson,
            String accessToken,
            String installDirPath,
            ProgressCallback progressCallback) {
        StringBuilder dbg = new StringBuilder();
        dbg.append("=== BH Epic Debug ===\n");
        dbg.append("installDirPath=").append(installDirPath).append("\n");
        try {
            progress(progressCallback, "Parsing CDN URLs...", 0);

            List<CdnUrl> cdnUrls = parseCdnUrls(manifestApiJson);
            if (cdnUrls.isEmpty()) {
                dbg.append("ERROR: No CDN URLs in manifest API response\n");
                writeDebug(ctx, dbg);
                Log.e(TAG, "No CDN URLs in manifest API response");
                return false;
            }
            for (CdnUrl c : cdnUrls) {
                dbg.append("CDN: ").append(c.baseUrl)
                   .append("  cloudDir=").append(c.cloudDir)
                   .append("  auth=").append(c.authParams.isEmpty() ? "(none)" : "YES").append("\n");
                Log.i(TAG, "  CDN: " + c.baseUrl + "  auth: " + (c.authParams.isEmpty() ? "(none)" : "YES"));
            }

            progress(progressCallback, "Downloading manifest...", 0);
            byte[] manifestBytes = downloadManifest(manifestApiJson, cdnUrls);
            if (manifestBytes == null) {
                dbg.append("ERROR: Manifest binary download failed\n");
                writeDebug(ctx, dbg);
                Log.e(TAG, "Manifest binary download failed");
                return false;
            }
            dbg.append("manifestBytes=").append(manifestBytes.length).append("\n");
            Log.i(TAG, "Manifest bytes: " + manifestBytes.length);

            progress(progressCallback, "Parsing manifest...", 0);
            EpicManifest.ParsedManifest manifest = parseManifest(manifestBytes);
            if (manifest == null) {
                dbg.append("ERROR: Manifest parse failed\n");
                writeDebug(ctx, dbg);
                Log.e(TAG, "Manifest parse failed");
                return false;
            }
            manifest.cdnUrls = cdnUrls;
            dbg.append("chunkDir=").append(manifest.chunkDir)
               .append(" chunks=").append(manifest.uniqueChunks.size())
               .append(" files=").append(manifest.files.size()).append("\n");
            Log.i(TAG, "Manifest: chunkDir=" + manifest.chunkDir
                    + " chunks=" + manifest.uniqueChunks.size()
                    + " files=" + manifest.files.size());

            File installDir  = new File(installDirPath);
            installDir.mkdirs();
            File chunkCacheDir = new File(installDir, ".chunks");
            chunkCacheDir.mkdirs();

            // Calculate total download bytes for smooth byte-level progress
            long totalBytes = 0;
            for (ChunkInfo chunk : manifest.uniqueChunks) totalBytes += Math.max(chunk.fileSize, 1);
            final long fTotalBytes = totalBytes;
            final int totalChunks  = manifest.uniqueChunks.size();
            final AtomicLong completedBytes    = new AtomicLong(0);
            final AtomicInteger completedCount = new AtomicInteger(0);
            final AtomicInteger failCount      = new AtomicInteger(0);
            final AtomicLong lastSpeedMs       = new AtomicLong(System.currentTimeMillis());
            final AtomicLong lastSpeedBytes    = new AtomicLong(0);
            final AtomicLong currentSpeedBps   = new AtomicLong(0);
            final java.util.concurrent.ConcurrentLinkedQueue<String> chunkLog =
                    new java.util.concurrent.ConcurrentLinkedQueue<>();

            dbg.append("totalDownloadBytes=").append(totalBytes)
               .append(String.format(" (%.1f MB)\n", totalBytes / 1048576.0));

            // Download unique chunks — 8 parallel threads
            ExecutorService pool = Executors.newFixedThreadPool(8);
            for (ChunkInfo chunk : manifest.uniqueChunks) {
                final ChunkInfo fc = chunk;
                pool.submit(() -> {
                    File cachedFile = new File(chunkCacheDir, fc.guidStr());
                    if (!cachedFile.exists()) {
                        if (!downloadChunkStreaming(fc, manifest.chunkDir, cdnUrls, cachedFile)) {
                            Log.e(TAG, "Chunk download failed: " + fc.guidStr());
                            chunkLog.add("FAIL chunk=" + fc.guidStr());
                            failCount.incrementAndGet();
                            return;
                        }
                    }
                    long done = completedBytes.addAndGet(Math.max(fc.fileSize, 1));
                    int  cnt  = completedCount.incrementAndGet();
                    int  pct  = (int)(done * 80L / fTotalBytes);

                    long nowMs     = System.currentTimeMillis();
                    long prevMs    = lastSpeedMs.get();
                    long timeDelta = nowMs - prevMs;
                    if (timeDelta >= 500 && lastSpeedMs.compareAndSet(prevMs, nowMs)) {
                        long prevB  = lastSpeedBytes.getAndSet(done);
                        long bDelta = done - prevB;
                        if (timeDelta > 0) currentSpeedBps.set(bDelta * 1000L / timeDelta);
                    }

                    String mb    = String.format("%.1f / %.1f MB", done / 1048576.0, fTotalBytes / 1048576.0);
                    String speed = formatSpeed(currentSpeedBps.get());
                    progress(progressCallback,
                            "Downloading chunks (" + cnt + "/" + totalChunks + ")  " + mb
                            + (speed.isEmpty() ? "" : "  " + speed), pct);
                });
            }
            pool.shutdown();
            try {
                pool.awaitTermination(Long.MAX_VALUE, TimeUnit.MILLISECONDS);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                dbg.append("ERROR: chunk pool interrupted\n");
                writeDebug(ctx, dbg);
                return false;
            }

            // Drain per-chunk failures into dbg
            for (String line : chunkLog) dbg.append(line).append("\n");

            if (failCount.get() > 0) {
                dbg.append("ERROR: ").append(failCount.get()).append(" chunks failed\n");
                writeDebug(ctx, dbg);
                Log.e(TAG, failCount.get() + " chunks failed to download");
                return false;
            }
            dbg.append("chunksOK=").append(completedCount.get()).append("\n");

            // Assemble files — show each filename as it is written
            int totalFiles = manifest.files.size();
            int doneFiles  = 0;
            dbg.append("assembling ").append(totalFiles).append(" files\n");
            for (FileInfo file : manifest.files) {
                String relPath = file.filename.replace("\\", "/");
                File outFile   = new File(installDir, relPath);
                File parent    = outFile.getParentFile();
                if (parent != null) parent.mkdirs();

                String displayName = relPath.contains("/")
                        ? relPath.substring(relPath.lastIndexOf('/') + 1) : relPath;
                int pct = 80 + (int)(doneFiles * 20L / totalFiles);
                progress(progressCallback, "Writing: " + displayName, pct);

                try (FileOutputStream fos = new FileOutputStream(outFile);
                     BufferedOutputStream bos = new BufferedOutputStream(fos, 65536)) {
                    for (ChunkPart part : file.parts) {
                        File cachedChunk = new File(chunkCacheDir, part.guidStr());
                        if (!cachedChunk.exists()) {
                            dbg.append("ERROR: missing chunk ").append(part.guidStr())
                               .append(" for ").append(relPath).append("\n");
                            writeDebug(ctx, dbg);
                            Log.e(TAG, "Missing cached chunk " + part.guidStr() + " for " + relPath);
                            return false;
                        }
                        byte[] chunkData = readFile(cachedChunk);
                        bos.write(chunkData, part.offset, part.size);
                    }
                }

                doneFiles++;
            }

            deleteDir(chunkCacheDir);
            dbg.append("INSTALL COMPLETE: ").append(installDirPath).append("\n");
            writeDebug(ctx, dbg);
            Log.i(TAG, "Epic install complete: " + installDirPath);
            return true;

        } catch (Exception e) {
            dbg.append("EXCEPTION: ").append(e).append("\n");
            writeDebug(ctx, dbg);
            Log.e(TAG, "Epic install failed", e);
            return false;
        }
    }

    private static void writeDebug(android.content.Context ctx, StringBuilder dbg) {
        try {
            java.io.File dir = ctx.getExternalFilesDir(null);
            if (dir == null) dir = ctx.getFilesDir();
            java.io.File f = new java.io.File(dir, "bh_epic_debug.txt");
            try (FileOutputStream fos = new FileOutputStream(f)) {
                fos.write(dbg.toString().getBytes("UTF-8"));
            }
            Log.i(TAG, "Debug written to: " + f.getAbsolutePath());
        } catch (Exception e) {
            Log.e(TAG, "writeDebug failed", e);
        }
    }

    // ── CDN URL parsing ───────────────────────────────────────────────────────

    /**
     * Extract all CDN entries from the manifest API JSON.
     * Skips cloudflare.epicgamescdn.com.
     */
    public static List<CdnUrl> parseCdnUrls(String json) {
        List<CdnUrl> result = new ArrayList<>();
        try {
            int manifestsIdx = json.indexOf("\"manifests\"");
            if (manifestsIdx < 0) return result;
            int arrStart = json.indexOf("[", manifestsIdx);
            if (arrStart < 0) return result;

            int cursor = arrStart + 1;
            while (true) {
                int uriKeyIdx = json.indexOf("\"uri\"", cursor);
                if (uriKeyIdx < 0) break;

                int colon = json.indexOf(":", uriKeyIdx + 5);
                if (colon < 0) break;
                int q1 = json.indexOf("\"", colon + 1);
                if (q1 < 0) break;
                int q2 = json.indexOf("\"", q1 + 1);
                if (q2 < 0) break;
                String uri = json.substring(q1 + 1, q2);
                cursor = q2 + 1;

                int buildsIdx = uri.indexOf("/Builds");
                if (buildsIdx < 0) continue;

                String baseUrl = uri.substring(0, buildsIdx);
                if (!baseUrl.startsWith("http")) continue;
                if (baseUrl.contains("cloudflare.epicgamescdn.com")) continue;

                String afterBase = uri.substring(buildsIdx);
                int qMark = afterBase.indexOf("?");
                if (qMark >= 0) afterBase = afterBase.substring(0, qMark);
                int lastSlash = afterBase.lastIndexOf("/");
                if (lastSlash < 0) continue;
                String cloudDir = afterBase.substring(0, lastSlash);

                String authParams = extractQueryParams(json, uriKeyIdx);
                result.add(new CdnUrl(baseUrl, cloudDir, authParams));
            }
        } catch (Exception e) {
            Log.e(TAG, "parseCdnUrls error: " + e.getMessage());
        }
        return result;
    }

    private static String extractQueryParams(String json, int nearPos) {
        try {
            int end    = Math.min(json.length(), nearPos + 2000);
            int qpIdx  = json.indexOf("\"queryParams\"", nearPos);
            if (qpIdx < 0 || qpIdx > end) return "";
            int arrOpen  = json.indexOf("[", qpIdx);
            if (arrOpen < 0) return "";
            int arrClose = json.indexOf("]", arrOpen);
            if (arrClose < 0) return "";
            String arrContent = json.substring(arrOpen + 1, arrClose).trim();
            if (arrContent.isEmpty()) return "";

            StringBuilder sb = new StringBuilder("?");
            boolean first = true;
            int pos = 0;
            while (pos < arrContent.length()) {
                int nameIdx = arrContent.indexOf("\"name\"", pos);
                if (nameIdx < 0) break;
                int nColon = arrContent.indexOf(":", nameIdx + 6);
                if (nColon < 0) break;
                int nq1 = arrContent.indexOf("\"", nColon + 1);
                if (nq1 < 0) break;
                int nq2 = arrContent.indexOf("\"", nq1 + 1);
                if (nq2 < 0) break;
                String name = arrContent.substring(nq1 + 1, nq2);

                int valIdx = arrContent.indexOf("\"value\"", nq2);
                if (valIdx < 0) break;
                int vColon = arrContent.indexOf(":", valIdx + 7);
                if (vColon < 0) break;
                int vq1 = arrContent.indexOf("\"", vColon + 1);
                if (vq1 < 0) break;
                int vq2 = arrContent.indexOf("\"", vq1 + 1);
                if (vq2 < 0) break;
                String value = arrContent.substring(vq1 + 1, vq2);

                if (!first) sb.append("&");
                sb.append(name).append("=").append(value);
                first = false;
                pos = vq2 + 1;
            }
            return first ? "" : sb.toString();
        } catch (Exception e) {
            return "";
        }
    }

    // ── Manifest download ─────────────────────────────────────────────────────

    /**
     * Download the manifest binary, trying each CDN in order.
     * Auth tokens (queryParams) are appended to the manifest URL — but NOT to chunk URLs.
     */
    public static byte[] downloadManifest(String json, List<CdnUrl> cdnUrls) {
        try {
            int manifestsIdx = json.indexOf("\"manifests\"");
            if (manifestsIdx < 0) return null;
            int uriIdx = json.indexOf("\"uri\"", manifestsIdx);
            if (uriIdx < 0) return null;
            int colon = json.indexOf(":", uriIdx + 5);
            if (colon < 0) return null;
            int q1 = json.indexOf("\"", colon + 1);
            if (q1 < 0) return null;
            int q2 = json.indexOf("\"", q1 + 1);
            if (q2 < 0) return null;
            String firstUri = json.substring(q1 + 1, q2);

            String uriPath = firstUri.contains("?") ? firstUri.substring(0, firstUri.indexOf("?")) : firstUri;
            int lastSlash = uriPath.lastIndexOf("/");
            if (lastSlash < 0) return null;
            String manifestFilename = uriPath.substring(lastSlash + 1);
            Log.i(TAG, "Manifest filename: " + manifestFilename);

            for (CdnUrl cdn : cdnUrls) {
                String url = cdn.baseUrl + cdn.cloudDir + "/" + manifestFilename + cdn.authParams;
                Log.i(TAG, "Trying manifest CDN: " + cdn.baseUrl);
                byte[] bytes = downloadBytes(url, null);
                if (bytes != null && bytes.length > 4) {
                    Log.i(TAG, "Manifest OK (" + bytes.length + " bytes) from " + cdn.baseUrl);
                    return bytes;
                }
            }
        } catch (Exception e) {
            Log.e(TAG, "downloadManifest error: " + e.getMessage());
        }
        return null;
    }

    // ── Manifest parsing ──────────────────────────────────────────────────────

    public static EpicManifest.ParsedManifest parseManifest(byte[] bytes) {
        try {
            ByteBuffer buf = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN);

            int magic = buf.getInt();
            if (magic != 0x44BEC00C) {
                Log.w(TAG, "Non-binary manifest, trying JSON parser");
                return parseJsonManifest(bytes);
            }

            int headerSize       = buf.getInt();
            int sizeUncompressed = buf.getInt();
            /* sizeCompressed */ buf.getInt();
            buf.position(buf.position() + 20); // skip SHA-1
            int storedAs = buf.get() & 0xFF;
            int version  = buf.getInt();

            String chunkDir;
            if      (version >= 15) chunkDir = "ChunksV4";
            else if (version >= 6)  chunkDir = "ChunksV3";
            else if (version >= 3)  chunkDir = "ChunksV2";
            else                    chunkDir = "Chunks";

            buf.position(headerSize);
            byte[] bodyBytes = new byte[buf.remaining()];
            buf.get(bodyBytes);

            if ((storedAs & 1) != 0) {
                Inflater inflater = new Inflater();
                inflater.setInput(bodyBytes);
                byte[] decomp = new byte[sizeUncompressed];
                int got = inflater.inflate(decomp);
                inflater.end();
                if (got != sizeUncompressed) {
                    Log.e(TAG, "Decomp size mismatch: expected " + sizeUncompressed + " got " + got);
                    return null;
                }
                bodyBytes = decomp;
            }

            ByteBuffer body = ByteBuffer.wrap(bodyBytes).order(ByteOrder.LITTLE_ENDIAN);

            // Skip ManifestMeta section
            int metaSize = body.getInt();
            body.position(body.position() - 4 + metaSize);

            // ChunkDataList section
            int cdlStart = body.position();
            int cdlSize  = body.getInt();
            body.get(); // version byte
            int chunkCount = body.getInt();

            List<ChunkInfo> chunks = new ArrayList<>(chunkCount);
            for (int i = 0; i < chunkCount; i++) chunks.add(new ChunkInfo());

            for (ChunkInfo c : chunks) {
                c.guid[0] = body.getInt();
                c.guid[1] = body.getInt();
                c.guid[2] = body.getInt();
                c.guid[3] = body.getInt();
            }
            for (ChunkInfo c : chunks) c.hash       = body.getLong();
            body.position(body.position() + 20 * chunkCount); // skip SHA-1s
            for (ChunkInfo c : chunks) c.groupNum   = body.get() & 0xFF;
            for (ChunkInfo c : chunks) c.windowSize = body.getInt();
            for (ChunkInfo c : chunks) c.fileSize   = body.getLong();

            body.position(cdlStart + cdlSize);

            Map<String, ChunkInfo> chunkMap = new LinkedHashMap<>(chunkCount * 2);
            for (ChunkInfo c : chunks) chunkMap.put(c.guidStr(), c);

            // FileManifestList section
            int fmlStart = body.position();
            int fmlSize  = body.getInt();
            body.get(); // version byte
            int fileCount = body.getInt();

            List<FileInfo> files = new ArrayList<>(fileCount);
            for (int i = 0; i < fileCount; i++) files.add(new FileInfo());

            for (FileInfo f : files) f.filename = readFString(body);
            for (int i = 0; i < fileCount; i++) readFString(body);           // symlink targets
            body.position(body.position() + 20 * fileCount);                  // skip SHA-1s
            body.position(body.position() + fileCount);                        // skip flags
            for (int i = 0; i < fileCount; i++) {                             // install tags
                int tagCount = body.getInt();
                for (int j = 0; j < tagCount; j++) readFString(body);
            }
            for (FileInfo f : files) {
                int partCount = body.getInt();
                for (int j = 0; j < partCount; j++) {
                    int partStart      = body.position();
                    int partStructSize = body.getInt();
                    ChunkPart part = new ChunkPart();
                    part.guid[0] = body.getInt();
                    part.guid[1] = body.getInt();
                    part.guid[2] = body.getInt();
                    part.guid[3] = body.getInt();
                    part.offset  = body.getInt();
                    part.size    = body.getInt();
                    f.parts.add(part);
                    body.position(partStart + partStructSize);
                }
            }

            body.position(fmlStart + fmlSize);

            Map<String, ChunkInfo> seenMap = new LinkedHashMap<>(chunkCount * 2);
            for (ChunkInfo c : chunks) seenMap.put(c.guidStr(), c);

            EpicManifest.ParsedManifest result = new EpicManifest.ParsedManifest();
            result.chunkDir     = chunkDir;
            result.uniqueChunks = new ArrayList<>(seenMap.values());
            result.files        = files;
            return result;

        } catch (Exception e) {
            Log.e(TAG, "parseManifest error", e);
            return null;
        }
    }

    // ── JSON manifest (older games) ───────────────────────────────────────────

    private static EpicManifest.ParsedManifest parseJsonManifest(byte[] bytes) {
        try {
            String jsonStr = new String(bytes, StandardCharsets.UTF_8);
            JSONObject root = new JSONObject(jsonStr);

            int manifestVersion = 0;
            try { manifestVersion = Integer.parseInt(root.optString("ManifestFileVersion", "0")); }
            catch (NumberFormatException ignored) {}
            String chunkDir;
            if      (manifestVersion >= 15) chunkDir = "ChunksV4";
            else if (manifestVersion >= 6)  chunkDir = "ChunksV3";
            else if (manifestVersion >= 3)  chunkDir = "ChunksV2";
            else                            chunkDir = "ChunksV4";

            JSONObject chunkHashList     = root.optJSONObject("ChunkHashList");
            JSONObject dataGroupList     = root.optJSONObject("DataGroupList");
            JSONObject chunkFilesizeList = root.optJSONObject("ChunkFilesizeList");

            if (chunkHashList == null) {
                Log.e(TAG, "JSON manifest: no ChunkHashList");
                return null;
            }

            Map<String, ChunkInfo> chunkMap = new LinkedHashMap<>();
            Iterator<String> keys = chunkHashList.keys();
            while (keys.hasNext()) {
                String guidHex = keys.next();
                if (guidHex.length() < 32) continue;
                String hashHex = chunkHashList.getString(guidHex);

                ChunkInfo c = new ChunkInfo();
                c.guid[0] = (int) Long.parseLong(guidHex.substring(0, 8),  16);
                c.guid[1] = (int) Long.parseLong(guidHex.substring(8,  16), 16);
                c.guid[2] = (int) Long.parseLong(guidHex.substring(16, 24), 16);
                c.guid[3] = (int) Long.parseLong(guidHex.substring(24, 32), 16);

                if (hashHex != null && hashHex.length() >= 16) {
                    try { c.hash = Long.parseUnsignedLong(hashHex.substring(0, 16), 16); }
                    catch (Exception ignored) { c.hash = 0; }
                }
                if (dataGroupList != null) {
                    try { c.groupNum = Integer.parseInt(dataGroupList.optString(guidHex, "0")); }
                    catch (NumberFormatException ignored) { c.groupNum = 0; }
                }
                if (chunkFilesizeList != null) {
                    try { c.fileSize = Long.parseLong(chunkFilesizeList.optString(guidHex, "0"), 16); }
                    catch (NumberFormatException ignored) { c.fileSize = 0; }
                }
                c.windowSize = 0;
                chunkMap.put(guidHex, c);
            }

            JSONArray fileList = root.optJSONArray("FileManifestList");
            if (fileList == null) {
                Log.e(TAG, "JSON manifest: no FileManifestList");
                return null;
            }

            List<FileInfo> files = new ArrayList<>(fileList.length());
            for (int i = 0; i < fileList.length(); i++) {
                JSONObject fileObj = fileList.getJSONObject(i);
                FileInfo fi = new FileInfo();
                fi.filename = fileObj.optString("Filename", "");

                JSONArray chunkParts = fileObj.optJSONArray("FileChunkParts");
                if (chunkParts != null) {
                    for (int j = 0; j < chunkParts.length(); j++) {
                        JSONObject partObj = chunkParts.getJSONObject(j);
                        ChunkPart part = new ChunkPart();
                        String partGuid = partObj.optString("Guid", "");
                        if (partGuid.length() >= 32) {
                            part.guid[0] = (int) Long.parseLong(partGuid.substring(0, 8),  16);
                            part.guid[1] = (int) Long.parseLong(partGuid.substring(8,  16), 16);
                            part.guid[2] = (int) Long.parseLong(partGuid.substring(16, 24), 16);
                            part.guid[3] = (int) Long.parseLong(partGuid.substring(24, 32), 16);
                        }
                        try { part.offset = Integer.parseInt(partObj.optString("Offset", "0")); }
                        catch (NumberFormatException ignored) { part.offset = 0; }
                        try { part.size = Integer.parseInt(partObj.optString("Size", "0")); }
                        catch (NumberFormatException ignored) { part.size = 0; }
                        fi.parts.add(part);
                    }
                }
                files.add(fi);
            }

            EpicManifest.ParsedManifest result = new EpicManifest.ParsedManifest();
            result.chunkDir     = chunkDir;
            result.uniqueChunks = new ArrayList<>(chunkMap.values());
            result.files        = files;
            Log.i(TAG, "JSON manifest: chunkDir=" + chunkDir
                    + " chunks=" + result.uniqueChunks.size()
                    + " files=" + files.size());
            return result;

        } catch (Exception e) {
            Log.e(TAG, "parseJsonManifest error", e);
            return null;
        }
    }

    // ── Chunk download ────────────────────────────────────────────────────────

    public static boolean downloadChunk(ChunkInfo chunk, String chunkDir,
                                         List<CdnUrl> cdnUrls, File outFile) {
        String chunkPath = chunk.getPath(chunkDir);
        for (CdnUrl cdn : cdnUrls) {
            // NO auth tokens on chunk URLs — Fastly/Akamai serve chunks publicly
            String url = cdn.baseUrl + cdn.cloudDir + "/" + chunkPath;
            try {
                byte[] raw = downloadBytes(url, null);
                if (raw == null) continue;

                byte[] data = decompressChunk(raw, chunk.windowSize);
                if (data == null) {
                    Log.w(TAG, "Decompress failed from " + cdn.baseUrl);
                    continue;
                }

                try (FileOutputStream fos = new FileOutputStream(outFile)) {
                    fos.write(data);
                }
                return true;

            } catch (Exception e) {
                Log.w(TAG, "CDN " + cdn.baseUrl + " failed for chunk " + chunk.guidStr()
                        + ": " + e.getMessage());
            }
        }
        Log.e(TAG, "All CDNs failed for chunk " + chunk.guidStr());
        return false;
    }

    public static byte[] decompressChunk(byte[] raw, int expectedSize) {
        try {
            ByteBuffer buf = ByteBuffer.wrap(raw).order(ByteOrder.LITTLE_ENDIAN);
            int magic = buf.getInt();
            if (magic != 0xB1FE3AA2) {
                Log.e(TAG, "Bad chunk magic: 0x" + Integer.toHexString(magic));
                return null;
            }
            buf.getInt(); // headerVersion
            int headerSize     = buf.getInt();
            int compressedSize = buf.getInt();
            buf.position(buf.position() + 16); // skip GUID
            buf.position(buf.position() + 8);  // skip hash
            int storedAs = buf.get() & 0xFF;

            if (headerSize < 0 || headerSize >= raw.length) {
                Log.e(TAG, "Bad chunk headerSize: " + headerSize);
                return null;
            }
            byte[] data = new byte[compressedSize];
            System.arraycopy(raw, headerSize, data, 0, compressedSize);

            if ((storedAs & 1) != 0) {
                Inflater inflater = new Inflater();
                inflater.setInput(data);
                ByteArrayOutputStream baos = new ByteArrayOutputStream(
                        expectedSize > 0 ? expectedSize : 1048576);
                byte[] ibuf = new byte[65536];
                int n;
                while ((n = inflater.inflate(ibuf)) > 0) baos.write(ibuf, 0, n);
                inflater.end();
                byte[] result = baos.toByteArray();
                if (result.length == 0) {
                    Log.e(TAG, "Chunk inflate produced 0 bytes");
                    return null;
                }
                return result;
            }
            return data;

        } catch (Exception e) {
            Log.e(TAG, "decompressChunk error: " + e.getMessage());
            return null;
        }
    }

    // ── HTTP ──────────────────────────────────────────────────────────────────

    public static byte[] downloadBytes(String urlStr, String bearerToken) {
        HttpURLConnection conn = null;
        try {
            conn = (HttpURLConnection) new URL(urlStr).openConnection();
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(60000);
            conn.setRequestMethod("GET");
            conn.setRequestProperty("User-Agent", UA);
            if (bearerToken != null && !bearerToken.isEmpty())
                conn.setRequestProperty("Authorization", bearerToken);
            int code = conn.getResponseCode();
            if (code != 200) {
                Log.w(TAG, "HTTP " + code + " for " + urlStr);
                return null;
            }
            int contentLength = conn.getContentLength();
            ByteArrayOutputStream out = contentLength > 0
                    ? new ByteArrayOutputStream(contentLength)
                    : new ByteArrayOutputStream();
            InputStream in = conn.getInputStream();
            byte[] buf = new byte[131072];
            int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
            in.close();
            return out.toByteArray();
        } catch (Exception e) {
            Log.w(TAG, "downloadBytes error [" + urlStr + "]: " + e.getMessage());
            return null;
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    /**
     * Streams a chunk directly from CDN to outFile without holding the full
     * compressed + decompressed data in memory simultaneously.
     * Reads HTTP stream → parses chunk header → inflates/copies payload → writes to file.
     */
    private static boolean downloadChunkStreaming(ChunkInfo chunk, String chunkDir,
                                                   List<CdnUrl> cdnUrls, File outFile) {
        String chunkPath = chunk.getPath(chunkDir);
        for (CdnUrl cdn : cdnUrls) {
            String url = cdn.baseUrl + cdn.cloudDir + "/" + chunkPath;
            HttpURLConnection conn = null;
            try {
                conn = (HttpURLConnection) new URL(url).openConnection();
                conn.setConnectTimeout(30000);
                conn.setReadTimeout(60000);
                conn.setRequestProperty("User-Agent", UA);
                if (conn.getResponseCode() != 200) { conn.disconnect(); continue; }

                try (InputStream in = conn.getInputStream();
                     FileOutputStream fos = new FileOutputStream(outFile)) {

                    // Read first 41 bytes: magic(4)+headerVersion(4)+headerSize(4)+
                    //   compressedSize(4)+GUID(16)+hash(8)+storedAs(1)
                    byte[] hdrBuf = new byte[41];
                    readFully(in, hdrBuf);
                    ByteBuffer hdr = ByteBuffer.wrap(hdrBuf).order(ByteOrder.LITTLE_ENDIAN);
                    int magic = hdr.getInt();
                    if (magic != 0xB1FE3AA2) {
                        Log.w(TAG, "Bad chunk magic (streaming): 0x" + Integer.toHexString(magic));
                        continue;
                    }
                    hdr.getInt(); // headerVersion
                    int headerSize     = hdr.getInt();
                    int compressedSize = hdr.getInt();
                    hdr.position(hdr.position() + 24); // skip GUID(16) + hash(8)
                    int storedAs = hdr.get() & 0xFF;

                    // Skip any extra header bytes beyond the 41 we already read
                    if (headerSize > 41) skipFully(in, headerSize - 41);

                    // Stream payload → file
                    byte[] iobuf = new byte[131072];
                    if ((storedAs & 1) != 0) {
                        // zlib-compressed payload
                        Inflater inflater = new Inflater();
                        byte[] obuf = new byte[131072];
                        int remaining = compressedSize;
                        try {
                            while (remaining > 0 && !inflater.finished()) {
                                if (inflater.needsInput()) {
                                    int toRead = Math.min(iobuf.length, remaining);
                                    int n = in.read(iobuf, 0, toRead);
                                    if (n <= 0) break;
                                    remaining -= n;
                                    inflater.setInput(iobuf, 0, n);
                                }
                                int out = inflater.inflate(obuf);
                                if (out > 0) fos.write(obuf, 0, out);
                            }
                            // drain any remaining output
                            int out;
                            while ((out = inflater.inflate(obuf)) > 0) fos.write(obuf, 0, out);
                        } finally {
                            inflater.end();
                        }
                    } else {
                        // stored as-is
                        int remaining = compressedSize;
                        while (remaining > 0) {
                            int toRead = Math.min(iobuf.length, remaining);
                            int n = in.read(iobuf, 0, toRead);
                            if (n <= 0) break;
                            fos.write(iobuf, 0, n);
                            remaining -= n;
                        }
                    }
                }
                conn.disconnect();
                return true;
            } catch (Exception e) {
                Log.w(TAG, "CDN " + cdn.baseUrl + " streaming failed for "
                        + chunk.guidStr() + ": " + e.getMessage());
                if (conn != null) conn.disconnect();
            }
        }
        Log.e(TAG, "All CDNs failed (streaming) for chunk " + chunk.guidStr());
        return false;
    }

    private static void readFully(InputStream in, byte[] buf) throws IOException {
        int offset = 0;
        while (offset < buf.length) {
            int n = in.read(buf, offset, buf.length - offset);
            if (n < 0) throw new IOException("Stream ended after " + offset + "/" + buf.length + " bytes");
            offset += n;
        }
    }

    private static void skipFully(InputStream in, int count) throws IOException {
        byte[] skip = new byte[Math.min(count, 4096)];
        int remaining = count;
        while (remaining > 0) {
            int n = in.read(skip, 0, Math.min(skip.length, remaining));
            if (n < 0) throw new IOException("Stream ended during skip");
            remaining -= n;
        }
    }

    // ── FString ───────────────────────────────────────────────────────────────

    public static String readFString(ByteBuffer buf) {
        int length = buf.getInt();
        if (length == 0) return "";
        if (length < 0) {
            int chars = (-length) - 1;
            byte[] bytes = new byte[chars * 2];
            buf.get(bytes);
            buf.getShort(); // null terminator
            return new String(bytes, StandardCharsets.UTF_16LE);
        } else {
            byte[] bytes = new byte[length - 1];
            buf.get(bytes);
            buf.get(); // null terminator
            return new String(bytes, StandardCharsets.US_ASCII);
        }
    }

    // ── Install size (no download) ────────────────────────────────────────────

    /**
     * Fetches the total uncompressed install size (bytes) by downloading and
     * parsing just the manifest. Does NOT download any game files.
     * Returns -1 on failure. Call from a background thread.
     */
    public static long fetchInstallSizeBytes(String accessToken, String namespace,
                                              String catalogItemId, String appName) {
        try {
            String manifestApiJson = EpicApiClient.getManifestApiJson(
                    accessToken, namespace, catalogItemId, appName);
            if (manifestApiJson == null) return -1;
            EpicManifest.ParsedManifest manifest =
                    EpicManifest.parseManifestApiJson(manifestApiJson, accessToken);
            if (manifest == null) return -1;
            long total = 0;
            for (ChunkInfo chunk : manifest.uniqueChunks)
                total += Math.max(chunk.windowSize, 0);
            return total > 0 ? total : -1;
        } catch (Exception e) {
            Log.w(TAG, "fetchInstallSizeBytes Epic: " + e.getMessage());
            return -1;
        }
    }

    // ── Utilities ─────────────────────────────────────────────────────────────

    public static byte[] readFile(File f) throws Exception {
        try (FileInputStream fis = new FileInputStream(f)) {
            byte[] data = new byte[(int) f.length()];
            int off = 0;
            while (off < data.length) {
                int r = fis.read(data, off, data.length - off);
                if (r < 0) break;
                off += r;
            }
            return data;
        }
    }

    public static void deleteDir(File dir) {
        if (!dir.exists()) return;
        File[] files = dir.listFiles();
        if (files != null) {
            for (File f : files) {
                if (f.isDirectory()) deleteDir(f);
                else f.delete();
            }
        }
        dir.delete();
    }

    private static String formatSpeed(long bps) {
        if (bps <= 0) return "";
        if (bps >= 1048576) return String.format("%.1f MB/s", bps / 1048576.0);
        return (bps / 1024) + " KB/s";
    }

    private static void progress(ProgressCallback cb, String msg, int pct) {
        if (cb != null) cb.onProgress(msg, pct);
        Log.i(TAG, "[" + pct + "%] " + msg);
    }
}
