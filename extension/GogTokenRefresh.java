package app.revanced.extension.gamehub;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Static helper for silent GOG access-token refresh.
 * Must be called from a background thread (performs blocking network I/O).
 *
 * Reads refresh_token from "bh_gog_prefs", sends GET to auth.gog.com/token,
 * saves new tokens + timestamps back to the same prefs, and returns the new
 * access_token string (or null on any failure).
 */
public final class GogTokenRefresh {

    private static final String TAG = "BH_GOG";

    // GOG embedded client credentials (publicly documented / open-source)
    private static final String TOKEN_URL_PREFIX =
            "https://auth.gog.com/token" +
            "?client_id=46899977096215655" +
            "&client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9" +
            "&grant_type=refresh_token&refresh_token=";

    private GogTokenRefresh() {}

    /**
     * Blocking token refresh. Returns new access_token or null on failure.
     */
    public static String refresh(Context ctx) {
        SharedPreferences prefs = ctx.getSharedPreferences("bh_gog_prefs", 0);
        String refreshToken = prefs.getString("refresh_token", null);
        if (refreshToken == null) return null;

        try {
            URL url = new URL(TOKEN_URL_PREFIX + refreshToken);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(15000);

            if (conn.getResponseCode() != 200) {
                conn.disconnect();
                return null;
            }

            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            conn.disconnect();

            String body = sb.toString();
            String newAccessToken  = GogLoginActivity.parseJsonStringField(body, "access_token");
            String newRefreshToken = GogLoginActivity.parseJsonStringField(body, "refresh_token");

            if (newAccessToken == null) return null;

            SharedPreferences.Editor ed = prefs.edit();
            ed.putString("access_token", newAccessToken);
            if (newRefreshToken != null) ed.putString("refresh_token", newRefreshToken);
            int nowSec = (int) (System.currentTimeMillis() / 1000L);
            ed.putInt("bh_gog_login_time", nowSec);
            ed.putInt("bh_gog_expires_in", 3600);
            ed.apply();

            Log.d(TAG, "Token refreshed OK");
            return newAccessToken;
        } catch (Exception e) {
            Log.e(TAG, "Token refresh failed", e);
            return null;
        }
    }
}
