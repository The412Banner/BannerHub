package app.revanced.extension.gamehub;

import android.util.Base64;
import android.util.Log;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Epic Games OAuth2 HTTP layer.
 *
 * Client credentials are the public Legendary/EGL credentials — same ones used
 * by Legendary CLI and documented publicly.
 *
 * Token endpoint: POST https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token
 *   Auth header:  Basic base64("clientId:clientSecret")
 *   Body (form):  grant_type=authorization_code&code=<code>&token_type=eg1
 *               / grant_type=refresh_token&refresh_token=<rt>&token_type=eg1
 *
 * Exchange code: GET https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange
 *   Auth header:  Bearer <accessToken>
 *   Returns:      {"code": "<short-lived exchange code>"}
 */
public class EpicAuthClient {

    private static final String TAG = "BH_EPIC";

    // Legendary public credentials (same as legendary CLI)
    static final String CLIENT_ID     = "34a02cf8f4414e29b15921876da36f9a";
    static final String CLIENT_SECRET = "daafbccc737745039dffe53d94fc76cf";

    private static final String TOKEN_URL    =
            "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token";
    private static final String EXCHANGE_URL =
            "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange";

    static final String USER_AGENT = "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit";

    public static class TokenResult {
        public String accessToken;
        public String refreshToken;
        public String accountId;
        public String displayName;
        public long   expiresAt;  // epoch millis
    }

    /** Exchange authorization_code for access + refresh tokens. */
    public static TokenResult exchangeCode(String authCode) {
        return postToken("grant_type=authorization_code&code=" + authCode + "&token_type=eg1");
    }

    /** Refresh using refresh_token. */
    public static TokenResult refreshToken(String refreshToken) {
        return postToken("grant_type=refresh_token&refresh_token=" + refreshToken + "&token_type=eg1");
    }

    private static TokenResult postToken(String formBody) {
        try {
            String creds64 = Base64.encodeToString(
                    (CLIENT_ID + ":" + CLIENT_SECRET).getBytes(StandardCharsets.UTF_8),
                    Base64.NO_WRAP);

            HttpURLConnection conn = (HttpURLConnection) new URL(TOKEN_URL).openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(30000);
            conn.setDoOutput(true);
            conn.setRequestProperty("Authorization", "Basic " + creds64);
            conn.setRequestProperty("User-Agent",    USER_AGENT);
            conn.setRequestProperty("Content-Type",  "application/x-www-form-urlencoded");

            byte[] bodyBytes = formBody.getBytes(StandardCharsets.UTF_8);
            conn.setRequestProperty("Content-Length", String.valueOf(bodyBytes.length));
            try (OutputStream os = conn.getOutputStream()) { os.write(bodyBytes); }

            int code = conn.getResponseCode();
            InputStream is = (code < 400) ? conn.getInputStream() : conn.getErrorStream();
            String resp = readStream(is);
            conn.disconnect();

            if (code < 200 || code >= 300) {
                Log.e(TAG, "Epic token HTTP " + code + ": " + resp);
                return null;
            }

            JSONObject json = new JSONObject(resp);
            TokenResult result = new TokenResult();
            result.accessToken  = json.optString("access_token",  null);
            result.refreshToken = json.optString("refresh_token", null);
            result.accountId    = json.optString("account_id",    "");
            result.displayName  = json.optString("displayName",   "");

            // expires_at may be ISO8601 string; fall back to expires_in seconds
            long expiresIn = json.optLong("expires_in", 7200L);
            String expiresAtStr = json.optString("expires_at", null);
            long expiresAtMs;
            if (expiresAtStr != null && !expiresAtStr.isEmpty()) {
                try {
                    // Parse ISO8601 manually: "2026-03-29T12:00:00.000Z"
                    expiresAtMs = parseIso8601(expiresAtStr);
                } catch (Exception e) {
                    expiresAtMs = System.currentTimeMillis() + expiresIn * 1000L;
                }
            } else {
                expiresAtMs = System.currentTimeMillis() + expiresIn * 1000L;
            }
            result.expiresAt = expiresAtMs;

            return result.accessToken != null ? result : null;

        } catch (Exception e) {
            Log.e(TAG, "Epic postToken failed", e);
            return null;
        }
    }

    /**
     * Get a short-lived exchange code for launching a game.
     * Pass returned code as -AUTH_PASSWORD when launching the game exe.
     */
    public static String getExchangeCode(String accessToken) {
        try {
            String resp = getRequest(EXCHANGE_URL, accessToken);
            if (resp == null) return null;
            JSONObject json = new JSONObject(resp);
            return json.optString("code", null);
        } catch (Exception e) {
            Log.e(TAG, "Epic getExchangeCode failed", e);
            return null;
        }
    }

    /** Authorized GET — returns response body string or null on failure. */
    public static String getRequest(String urlStr, String accessToken) {
        HttpURLConnection conn = null;
        try {
            conn = (HttpURLConnection) new URL(urlStr).openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(30000);
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            conn.setRequestProperty("User-Agent", USER_AGENT);

            int code = conn.getResponseCode();
            InputStream is = (code < 400) ? conn.getInputStream() : conn.getErrorStream();
            String resp = readStream(is);
            conn.disconnect();

            if (code < 200 || code >= 300) {
                Log.e(TAG, "Epic GET HTTP " + code + " from " + urlStr + ": " + resp);
                return null;
            }
            return resp;
        } catch (Exception e) {
            Log.e(TAG, "Epic getRequest failed: " + urlStr, e);
            return null;
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    /** Authorized GET → raw bytes (for manifest binary download). */
    public static byte[] getBytes(String urlStr, String accessToken) {
        HttpURLConnection conn = null;
        try {
            conn = (HttpURLConnection) new URL(urlStr).openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(120000);
            if (accessToken != null)
                conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            conn.setRequestProperty("User-Agent", USER_AGENT);

            int code = conn.getResponseCode();
            if (code < 200 || code >= 300) {
                Log.e(TAG, "Epic getBytes HTTP " + code + " from " + urlStr);
                return null;
            }
            return conn.getInputStream().readAllBytes();
        } catch (Exception e) {
            Log.e(TAG, "Epic getBytes failed: " + urlStr, e);
            return null;
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private static String readStream(InputStream is) throws IOException {
        if (is == null) return "";
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }

    /**
     * Parse ISO 8601 date string to epoch millis.
     * Format: "2026-03-29T12:00:00.000Z"
     */
    private static long parseIso8601(String s) throws Exception {
        // Use simple calculation — avoids java.time (not available pre-API 26)
        // "2026-03-29T12:00:00.000Z"
        int year   = Integer.parseInt(s.substring(0, 4));
        int month  = Integer.parseInt(s.substring(5, 7));
        int day    = Integer.parseInt(s.substring(8, 10));
        int hour   = Integer.parseInt(s.substring(11, 13));
        int minute = Integer.parseInt(s.substring(14, 16));
        int second = Integer.parseInt(s.substring(17, 19));

        // Days since epoch (Jan 1 1970) using Julian day number calculation
        long jd = 367L * year - (7 * (year + (month + 9) / 12)) / 4
                + (275 * month) / 9 + day + 1721013L;
        long epochDays = jd - 2440588L; // 2440588 = JDN of 1970-01-01
        return epochDays * 86400000L + hour * 3600000L + minute * 60000L + second * 1000L;
    }
}
