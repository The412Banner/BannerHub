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
    private static final int    MAX_PARALLEL          = 6;
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
        if (game.entitlementId == null || game.entitlementId.isEmpty()) {
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
                Log.e(TAG, "getGameDownload failed for: " + game.title);
                return false;
            }
            log("downloadUrl: " + spec.downloadUrl);

            // Step 2: Download manifest
            log("Downloading manifest.proto...");
            String manifestUrl = AmazonApiClient.appendPath(spec.downloadUrl, "manifest.proto");
            byte[] manifestBytes = AmazonApiClient.getBytes(manifestUrl, accessToken);
            if (manifestBytes == null) {
                Log.e(TAG, "manifest download failed");
                return false;
            }
            log("Manifest downloaded: " + manifestBytes.length + " bytes");

            // Step 3: Parse manifest
            AmazonManifest.ParsedManifest manifest = AmazonManifest.parse(manifestBytes);
            log("Manifest parsed: " + manifest.allFiles.size() + " files, "
                    + manifest.totalInstallSize + " bytes total");

            if (progress != null) {
                progress.onProgress(0, manifest.totalInstallSize, "Starting…");
            }

            // Step 4: Download files in batches of 6
            AtomicLong downloaded      = new AtomicLong(0);
            AtomicLong lastEmit        = new AtomicLong(0);
            AtomicLong lastSpeedMs     = new AtomicLong(System.currentTimeMillis());
            AtomicLong lastSpeedBytes  = new AtomicLong(0);
            AtomicLong currentSpeedBps = new AtomicLong(0);
            List<AmazonManifest.ManifestFile> files = manifest.allFiles;

            ExecutorService pool = Executors.newFixedThreadPool(MAX_PARALLEL);
            try {
                for (int batchStart = 0; batchStart < files.size(); batchStart += MAX_PARALLEL) {
                    // Cancellation check between batches
                    if (cancel != null && cancel.isCancelled()) {
                        log("Cancelled between batches");
                        cleanupTmpFiles(installDir);
                        deleteMarker(installDir, IN_PROGRESS_MARKER);
                        return false;
                    }

                    int batchEnd = Math.min(batchStart + MAX_PARALLEL, files.size());
                    List<AmazonManifest.ManifestFile> batch = files.subList(batchStart, batchEnd);
                    List<Callable<Boolean>> tasks = new ArrayList<>();

                    for (AmazonManifest.ManifestFile file : batch) {
                        final String dlUrl  = spec.downloadUrl;
                        final String tkn    = accessToken;
                        tasks.add(() -> downloadFileWithRetry(
                                file, dlUrl, tkn, installDir,
                                downloaded, lastEmit, manifest.totalInstallSize,
                                lastSpeedMs, lastSpeedBytes, currentSpeedBps,
                                progress, cancel));
                    }

                    List<Future<Boolean>> futures = pool.invokeAll(tasks);
                    for (Future<Boolean> f : futures) {
                        if (!f.get()) {
                            log("A file in batch failed — aborting download");
                            pool.shutdownNow();
                            deleteMarker(installDir, IN_PROGRESS_MARKER);
                            return false;
                        }
                    }
                }
            } finally {
                pool.shutdownNow();
            }

            // Step 5: Cache manifest and mark installed
            cacheManifest(ctx, game.productId, manifestBytes);

            new File(installDir, IN_PROGRESS_MARKER).delete();
            new File(installDir, COMPLETE_MARKER).createNewFile();

            log("Install complete: " + game.title + " → " + installDir.getAbsolutePath());
            return true;

        } catch (Exception e) {
            Log.e(TAG, "install failed for: " + game.title, e);
            deleteMarker(installDir, IN_PROGRESS_MARKER);
            return false;
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
