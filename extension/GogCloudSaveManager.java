package app.revanced.extension.gamehub;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * GOG Cloud Save upload/download manager.
 *
 * API base: https://cloudstorage.gog.com/v1/{userId}/{clientId}
 *
 * List files:   GET  /v1/{userId}/{clientId}
 * Download:     GET  /v1/{userId}/{clientId}/{filename}
 * Upload:       PUT  /v1/{userId}/{clientId}/{filename}
 *
 * Uses the regular GOG access_token (Bearer) and gameId as clientId.
 * Token is refreshed automatically if needed before calls.
 */
public final class GogCloudSaveManager {

    private static final String TAG = "BH_GOG_CLOUD";
    private static final String BASE = "https://cloudstorage.gog.com/v1/";
    private static final int TIMEOUT = 30_000;

    public interface Callback {
        void onStatus(String message);
        void onDone(String summary);
        void onError(String message);
    }

    /** Scan local folder and upload files newer than cloud versions. */
    public static void uploadSaves(Context ctx, String gameId, File localFolder, Callback cb) {
        new Thread(() -> {
            try {
                SharedPreferences prefs = ctx.getSharedPreferences("bh_gog_prefs", 0);
                String galaxyToken = getValidToken(ctx, prefs);
                if (galaxyToken == null) { cb.onError("Not logged in to GOG"); return; }
                String userId = prefs.getString("user_id", null);
                if (userId == null) { cb.onError("GOG user ID not found — please sign in again"); return; }
                String clientId = GogDownloadManager.getOrFetchClientId(ctx, gameId, galaxyToken);
                String token = getGameScopedToken(ctx, gameId, clientId, prefs);
                if (token == null) token = galaxyToken; // fallback
                debug(ctx, "GOG upload — gameId=" + gameId + " userId=" + userId + " clientId=" + clientId + " scopedToken=" + (token.equals(galaxyToken) ? "fallback" : "ok"));

                cb.onStatus("Fetching cloud file list…");
                List<CloudFile> cloudFiles = listCloudFiles(ctx, userId, clientId, token);

                File[] localFiles = localFolder.listFiles();
                if (localFiles == null || localFiles.length == 0) {
                    cb.onDone("No local files to upload");
                    return;
                }

                int uploaded = 0;
                int skipped  = 0;
                for (File local : localFiles) {
                    if (!local.isFile()) continue;
                    String name = local.getName();
                    long localModMs = local.lastModified();
                    long cloudModMs = getCloudModifiedMs(cloudFiles, name);

                    if (cloudModMs >= localModMs) {
                        skipped++;
                        continue;
                    }

                    cb.onStatus("Uploading: " + name);
                    byte[] data = readFile(local);
                    if (data == null) { cb.onError("Failed to read: " + name); return; }

                    boolean ok = putFile(userId, clientId, token, name, data);
                    if (!ok) { cb.onError("Upload failed for: " + name); return; }
                    uploaded++;
                }

                if (uploaded == 0 && skipped > 0) {
                    cb.onDone("Already up to date (" + skipped + " file" + (skipped == 1 ? "" : "s") + ")");
                } else if (uploaded > 0) {
                    cb.onDone("Uploaded " + uploaded + " file" + (uploaded == 1 ? "" : "s"));
                } else {
                    cb.onDone("No files to upload");
                }

            } catch (Exception e) {
                Log.e(TAG, "uploadSaves failed", e);
                debug(ctx, "uploadSaves exception: " + e.getMessage());
                if ("CLOUD_SAVES_NOT_SUPPORTED".equals(e.getMessage()))
                    cb.onError("This game does not support GOG cloud saves");
                else
                    cb.onError("Upload error: " + e.getMessage());
            }
        }, "gog-cloud-upload-" + gameId).start();
    }

    /** Download all cloud save files to local folder, overwriting local copies. */
    public static void downloadSaves(Context ctx, String gameId, File localFolder, Callback cb) {
        new Thread(() -> {
            try {
                SharedPreferences prefs = ctx.getSharedPreferences("bh_gog_prefs", 0);
                String galaxyToken = getValidToken(ctx, prefs);
                if (galaxyToken == null) { cb.onError("Not logged in to GOG"); return; }
                String userId = prefs.getString("user_id", null);
                if (userId == null) { cb.onError("GOG user ID not found — please sign in again"); return; }
                String clientId = GogDownloadManager.getOrFetchClientId(ctx, gameId, galaxyToken);
                String token = getGameScopedToken(ctx, gameId, clientId, prefs);
                if (token == null) token = galaxyToken; // fallback
                debug(ctx, "GOG download — gameId=" + gameId + " userId=" + userId + " clientId=" + clientId + " scopedToken=" + (token.equals(galaxyToken) ? "fallback" : "ok"));

                cb.onStatus("Fetching cloud file list…");
                List<CloudFile> cloudFiles = listCloudFiles(ctx, userId, clientId, token);

                if (cloudFiles.isEmpty()) {
                    cb.onDone("No cloud saves found");
                    return;
                }

                if (!localFolder.exists()) localFolder.mkdirs();

                int downloaded = 0;
                for (CloudFile cf : cloudFiles) {
                    cb.onStatus("Downloading: " + cf.name);
                    byte[] data = getFile(userId, clientId, token, cf.name);
                    if (data == null) { cb.onError("Download failed for: " + cf.name); return; }
                    File dest = new File(localFolder, cf.name);
                    writeFile(dest, data);
                    downloaded++;
                }

                cb.onDone("Downloaded " + downloaded + " file" + (downloaded == 1 ? "" : "s"));

            } catch (Exception e) {
                Log.e(TAG, "downloadSaves failed", e);
                debug(ctx, "downloadSaves exception: " + e.getMessage());
                if ("CLOUD_SAVES_NOT_SUPPORTED".equals(e.getMessage()))
                    cb.onError("This game does not support GOG cloud saves");
                else
                    cb.onError("Download error: " + e.getMessage());
            }
        }, "gog-cloud-download-" + gameId).start();
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    /**
     * Obtains a game-scoped GOG access token for cloud storage.
     * GOG's cloudstorage API requires a token issued with the game's own
     * client_id/client_secret (not the Galaxy app credentials).
     * We re-use the Galaxy refresh_token but swap in the game credentials.
     * Returns null if clientSecret is missing or the exchange fails.
     */
    private static String getGameScopedToken(Context ctx, String gameId, String clientId,
                                              SharedPreferences prefs) {
        String clientSecret = prefs.getString("gog_client_secret_" + gameId, null);
        if (clientSecret == null || clientSecret.isEmpty()) {
            debug(ctx, "getGameScopedToken: no clientSecret cached for " + gameId + " — falling back");
            return null;
        }
        String refreshToken = prefs.getString("refresh_token", null);
        if (refreshToken == null) {
            debug(ctx, "getGameScopedToken: no Galaxy refresh_token");
            return null;
        }
        try {
            String urlStr = "https://auth.gog.com/token"
                    + "?client_id=" + java.net.URLEncoder.encode(clientId, "UTF-8")
                    + "&client_secret=" + java.net.URLEncoder.encode(clientSecret, "UTF-8")
                    + "&grant_type=refresh_token"
                    + "&refresh_token=" + java.net.URLEncoder.encode(refreshToken, "UTF-8");
            debug(ctx, "getGameScopedToken: requesting scoped token for clientId=" + clientId);
            HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
            conn.setConnectTimeout(TIMEOUT);
            conn.setReadTimeout(TIMEOUT);
            conn.setRequestProperty("User-Agent", "GOG Galaxy");
            int code = conn.getResponseCode();
            debug(ctx, "getGameScopedToken: HTTP=" + code);
            if (code != 200) { conn.disconnect(); return null; }
            String body = readStream(conn.getInputStream());
            conn.disconnect();
            JSONObject json = new JSONObject(body);
            String accessToken = json.optString("access_token", null);
            if (accessToken != null && !accessToken.isEmpty()) {
                debug(ctx, "getGameScopedToken: OK, got scoped token");
                return accessToken;
            }
        } catch (Exception e) {
            debug(ctx, "getGameScopedToken exception: " + e.getMessage());
        }
        return null;
    }

    private static String getValidToken(Context ctx, SharedPreferences prefs) {
        String token = prefs.getString("access_token", null);
        if (token == null) return GogTokenRefresh.refresh(ctx);
        // Refresh if within 5 minutes of expiry
        long loginTime = prefs.getInt("bh_gog_login_time", 0) * 1000L;
        long expiresIn = prefs.getInt("bh_gog_expires_in", 3600) * 1000L;
        if (System.currentTimeMillis() > loginTime + expiresIn - 300_000L) {
            String fresh = GogTokenRefresh.refresh(ctx);
            return fresh != null ? fresh : token;
        }
        return token;
    }

    private static class CloudFile {
        String name;
        long lastModifiedMs; // epoch milliseconds
    }

    private static List<CloudFile> listCloudFiles(Context ctx, String userId, String clientId, String token)
            throws Exception {
        String url = BASE + userId + "/" + clientId;
        debug(ctx, "listCloudFiles URL=" + url);
        String body = getRequest(url, token);
        debug(ctx, "listCloudFiles response len=" + (body == null ? "null" : body.length()) + " snippet=" + (body != null ? body.substring(0, Math.min(120, body.length())) : ""));
        List<CloudFile> result = new ArrayList<>();
        if (body == null || body.isEmpty()) return result;
        JSONArray arr = new JSONArray(body);
        for (int i = 0; i < arr.length(); i++) {
            JSONObject obj = arr.optJSONObject(i);
            if (obj == null) continue;
            CloudFile cf = new CloudFile();
            cf.name = obj.optString("name", "");
            long lastMod = obj.optLong("last_modified", 0L);
            // GOG returns seconds; convert to ms
            cf.lastModifiedMs = lastMod > 1_000_000_000_000L ? lastMod : lastMod * 1000L;
            if (!cf.name.isEmpty()) result.add(cf);
        }
        return result;
    }

    private static long getCloudModifiedMs(List<CloudFile> cloudFiles, String name) {
        for (CloudFile cf : cloudFiles) {
            if (cf.name.equals(name)) return cf.lastModifiedMs;
        }
        return 0L;
    }

    private static String getRequest(String urlStr, String token) throws Exception {
        HttpURLConnection conn = openConn(urlStr, "GET", token);
        int code = conn.getResponseCode();
        Log.d(TAG, "GET " + urlStr + " → " + code);
        if (code == 404) { conn.disconnect(); return "[]"; }
        if (code < 200 || code >= 300) {
            String errBody = "";
            try { errBody = readStream(conn.getErrorStream()); } catch (Exception ignored) {}
            conn.disconnect();
            if (errBody.contains("not_enabled_for_client") || errBody.contains("disabled"))
                throw new Exception("CLOUD_SAVES_NOT_SUPPORTED");
            throw new Exception("HTTP " + code + " body=" + errBody.substring(0, Math.min(200, errBody.length())));
        }
        String body = readStream(conn.getInputStream());
        conn.disconnect();
        return body;
    }

    private static byte[] getFile(String userId, String clientId, String token, String filename)
            throws Exception {
        String urlStr = BASE + userId + "/" + clientId + "/" + java.net.URLEncoder.encode(filename, "UTF-8");
        HttpURLConnection conn = openConn(urlStr, "GET", token);
        int code = conn.getResponseCode();
        if (code < 200 || code >= 300) {
            conn.disconnect();
            throw new Exception("HTTP " + code + " for " + filename);
        }
        byte[] data = readBytes(conn.getInputStream());
        conn.disconnect();
        return data;
    }

    private static boolean putFile(String userId, String clientId, String token,
                                    String filename, byte[] data) {
        try {
            String urlStr = BASE + userId + "/" + clientId + "/" + java.net.URLEncoder.encode(filename, "UTF-8");
            HttpURLConnection conn = openConn(urlStr, "PUT", token);
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/octet-stream");
            conn.setRequestProperty("Content-Length", String.valueOf(data.length));
            conn.getOutputStream().write(data);
            int code = conn.getResponseCode();
            conn.disconnect();
            return code >= 200 && code < 300;
        } catch (Exception e) {
            Log.e(TAG, "putFile failed for " + filename, e);
            return false;
        }
    }

    private static HttpURLConnection openConn(String urlStr, String method, String token)
            throws Exception {
        HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
        conn.setRequestMethod(method);
        conn.setConnectTimeout(TIMEOUT);
        conn.setReadTimeout(TIMEOUT);
        conn.setRequestProperty("User-Agent", "GOG Galaxy");
        conn.setRequestProperty("Authorization", "Bearer " + token);
        return conn;
    }

    private static String readStream(InputStream is) throws Exception {
        StringBuilder sb = new StringBuilder();
        byte[] buf = new byte[4096];
        int n;
        while ((n = is.read(buf)) != -1) sb.append(new String(buf, 0, n, "UTF-8"));
        return sb.toString();
    }

    private static byte[] readBytes(InputStream is) throws Exception {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        byte[] buf = new byte[8192];
        int n;
        while ((n = is.read(buf)) != -1) bos.write(buf, 0, n);
        return bos.toByteArray();
    }

    private static byte[] readFile(File f) {
        try (FileInputStream fis = new FileInputStream(f)) {
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            byte[] buf = new byte[8192];
            int n;
            while ((n = fis.read(buf)) != -1) bos.write(buf, 0, n);
            return bos.toByteArray();
        } catch (Exception e) {
            Log.e(TAG, "readFile failed: " + f, e);
            return null;
        }
    }

    private static void writeFile(File dest, byte[] data) throws Exception {
        try (FileOutputStream fos = new FileOutputStream(dest)) {
            fos.write(data);
        }
    }

    // ── Debug file helper ─────────────────────────────────────────────────────

    static void debug(Context ctx, String msg) {
        try {
            String ts = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
            String line = ts + " [GOG] " + msg + "\n";
            File f = new File(android.os.Environment.getExternalStorageDirectory(), "bh_cloud_debug.txt");
            try (FileOutputStream fos = new FileOutputStream(f, true)) {
                fos.write(line.getBytes("UTF-8"));
            }
        } catch (Exception ignored) {}
        Log.d(TAG, msg);
    }

    private GogCloudSaveManager() {}
}
