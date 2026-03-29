package app.revanced.extension.gamehub;

import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Amazon Games distribution API client.
 *
 * All gaming endpoints share these headers:
 *   X-Amz-Target:       <operation>
 *   x-amzn-token:       <accessToken>
 *   User-Agent:         com.amazon.agslauncher.win/3.0.9202.1
 *   Content-Type:       application/json
 *   Content-Encoding:   amz-1.0          ← REQUIRED
 */
public class AmazonApiClient {

    private static final String TAG = "BH_AMAZON";

    private static final String ENTITLEMENTS_URL =
            "https://gaming.amazon.com/api/distribution/entitlements";
    private static final String DISTRIBUTION_URL =
            "https://gaming.amazon.com/api/distribution/v2/public";
    private static final String SDK_CHANNEL_URL  =
            "https://gaming.amazon.com/api/distribution/v2/public/download/channel/"
            + "87d38116-4cbf-4af0-a371-a5b498975346";

    private static final String GAMING_USER_AGENT  = "com.amazon.agslauncher.win/3.0.9202.1";
    private static final String DOWNLOAD_USER_AGENT = "nile/0.1 Amazon";
    private static final String KEY_ID              = "d5dc8b8b-86c8-4fc4-ae93-18c0def5314d";

    // ── GetEntitlements ───────────────────────────────────────────────────────

    /**
     * Fetches the full owned-games list (paginated).
     * Returns all games deduplicated by productId.
     */
    public static List<AmazonGame> getEntitlements(String accessToken, String deviceSerial) {
        Map<String, AmazonGame> seen = new HashMap<>();
        String nextToken = null;
        String hardwareHash = AmazonPKCEGenerator.sha256Upper(deviceSerial);

        do {
            try {
                JSONObject body = new JSONObject();
                body.put("Operation",       "GetEntitlements");
                body.put("clientId",        "Sonic");
                body.put("syncPoint",       JSONObject.NULL);
                body.put("nextToken",       nextToken != null ? nextToken : JSONObject.NULL);
                body.put("maxResults",      50);
                body.put("productIdFilter", JSONObject.NULL);
                body.put("keyId",           KEY_ID);
                body.put("hardwareHash",    hardwareHash);

                String resp = postGaming(ENTITLEMENTS_URL,
                        "com.amazonaws.agslauncher.AnimusEntitlementsService.GetEntitlements",
                        accessToken, body.toString());
                if (resp == null) break;

                JSONObject json = new JSONObject(resp);
                JSONArray entitlements = json.optJSONArray("entitlements");
                if (entitlements == null) break;

                for (int i = 0; i < entitlements.length(); i++) {
                    JSONObject e = entitlements.getJSONObject(i);
                    AmazonGame game = parseEntitlement(e);
                    if (game != null && !game.productId.isEmpty()) {
                        seen.put(game.productId, game);
                    }
                }

                nextToken = json.optString("nextToken", null);
                if (nextToken != null && nextToken.isEmpty()) nextToken = null;

            } catch (Exception ex) {
                Log.e(TAG, "getEntitlements page failed", ex);
                break;
            }
        } while (nextToken != null);

        return new ArrayList<>(seen.values());
    }

    private static AmazonGame parseEntitlement(JSONObject e) {
        try {
            JSONObject product  = e.optJSONObject("product");
            if (product == null) return null;

            AmazonGame game = new AmazonGame();
            game.entitlementId = e.optString("id", "");
            game.productId     = product.optString("id", "");
            game.title         = product.optString("title", "Unknown");
            game.productSku    = product.optString("sku", "");

            JSONObject detail = product.optJSONObject("productDetail");
            if (detail != null) {
                game.artUrl = detail.optString("iconUrl", "");
                JSONObject details = detail.optJSONObject("details");
                if (details != null) {
                    if (game.artUrl.isEmpty()) {
                        game.artUrl = details.optString("logoUrl", "");
                    }
                    game.heroUrl   = details.optString("backgroundUrl1", "");
                    if (game.heroUrl.isEmpty()) {
                        game.heroUrl = details.optString("backgroundUrl2", "");
                    }
                    game.developer = details.optString("developer", "");
                    game.publisher = details.optString("publisher", "");
                }
            }
            return game;
        } catch (Exception ex) {
            Log.e(TAG, "parseEntitlement failed", ex);
            return null;
        }
    }

    // ── GetGameDownload ───────────────────────────────────────────────────────

    public static class GameDownloadSpec {
        public String downloadUrl;
        public String versionId;
    }

    /**
     * Returns the download spec (downloadUrl + versionId) for a game.
     * Uses entitlementId (top-level UUID), NOT productId.
     */
    public static GameDownloadSpec getGameDownload(String accessToken, String entitlementId) {
        try {
            JSONObject body = new JSONObject();
            body.put("entitlementId", entitlementId);
            body.put("Operation", "GetGameDownload");

            String resp = postGaming(DISTRIBUTION_URL,
                    "com.amazonaws.agslauncher.AnimusDistributionService.GetGameDownload",
                    accessToken, body.toString());
            if (resp == null) return null;

            JSONObject json = new JSONObject(resp);
            GameDownloadSpec spec = new GameDownloadSpec();
            spec.downloadUrl = json.optString("downloadUrl", "");
            spec.versionId   = json.optString("versionId", "");
            return spec.downloadUrl.isEmpty() ? null : spec;

        } catch (Exception e) {
            Log.e(TAG, "getGameDownload failed", e);
            return null;
        }
    }

    // ── GetLiveVersionIds ─────────────────────────────────────────────────────

    /**
     * Returns the live versionId for a game (for update checks).
     * productIds: list of "amzn1.adg.product.XXXX" strings.
     */
    public static String getLiveVersionId(String accessToken, String productId) {
        try {
            JSONArray arr = new JSONArray();
            arr.put(productId);

            JSONObject body = new JSONObject();
            body.put("productIds", arr);
            body.put("Operation", "GetLiveVersionIds");

            String resp = postGaming(DISTRIBUTION_URL,
                    "com.amazonaws.agslauncher.AnimusDistributionService.GetLiveVersionIds",
                    accessToken, body.toString());
            if (resp == null) return null;

            JSONObject json = new JSONObject(resp);
            JSONObject versions = json.optJSONObject("versionIds");
            if (versions == null) return null;
            return versions.optString(productId, null);

        } catch (Exception e) {
            Log.e(TAG, "getLiveVersionId failed", e);
            return null;
        }
    }

    // ── SDK channel download spec ─────────────────────────────────────────────

    /**
     * Returns the JSON body for the SDK DLL channel download spec.
     * Used by AmazonSdkManager to get FuelSDK and AmazonGamesSDK DLL download URLs.
     */
    public static String getSdkChannelSpec(String accessToken) {
        return AmazonAuthClient.getRequest(
                SDK_CHANNEL_URL, accessToken, "x-amzn-token",
                "User-Agent", GAMING_USER_AGENT);
    }

    // ── appendPath helper ─────────────────────────────────────────────────────

    /**
     * Appends a path segment to a base URL that may contain query parameters.
     *
     * If baseUrl = "https://cdn.example.com/path?token=xyz"
     * and segment = "files/abc123"
     * → "https://cdn.example.com/path/files/abc123?token=xyz"
     */
    public static String appendPath(String baseUrl, String segment) {
        int qIdx = baseUrl.indexOf('?');
        if (qIdx >= 0) {
            String path  = baseUrl.substring(0, qIdx);
            String query = baseUrl.substring(qIdx);        // includes '?'
            return path + "/" + segment + query;
        }
        return baseUrl + "/" + segment;
    }

    // ── HTTP helpers ──────────────────────────────────────────────────────────

    /** POST to gaming.amazon.com with required amz-1.0 headers. */
    static String postGaming(String urlStr, String target,
                              String accessToken, String body) {
        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(30000);
            conn.setDoOutput(true);
            conn.setRequestProperty("X-Amz-Target",       target);
            conn.setRequestProperty("x-amzn-token",       accessToken);
            conn.setRequestProperty("User-Agent",         GAMING_USER_AGENT);
            conn.setRequestProperty("Content-Type",       "application/json");
            conn.setRequestProperty("Content-Encoding",   "amz-1.0");

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int code = conn.getResponseCode();
            InputStream is = (code < 400) ? conn.getInputStream() : conn.getErrorStream();
            String resp = readStream(is);
            conn.disconnect();

            if (code < 200 || code >= 300) {
                Log.e(TAG, "HTTP " + code + " from " + urlStr + ": " + resp);
                return null;
            }
            return resp;

        } catch (Exception e) {
            Log.e(TAG, "postGaming failed: " + urlStr, e);
            return null;
        }
    }

    /** GET a file as raw bytes (for manifest.proto download). */
    public static byte[] getBytes(String urlStr, String accessToken) {
        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(120000);
            if (accessToken != null)
                conn.setRequestProperty("x-amzn-token", accessToken);
            conn.setRequestProperty("User-Agent", DOWNLOAD_USER_AGENT);

            int code = conn.getResponseCode();
            if (code < 200 || code >= 300) {
                Log.e(TAG, "getBytes HTTP " + code + " from " + urlStr);
                conn.disconnect();
                return null;
            }
            byte[] data = conn.getInputStream().readAllBytes();
            conn.disconnect();
            return data;
        } catch (Exception e) {
            Log.e(TAG, "getBytes failed: " + urlStr, e);
            return null;
        }
    }

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
}
