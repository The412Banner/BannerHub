package app.revanced.extension.gamehub;

import android.app.Activity;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * WebView-based GOG OAuth2 login screen.
 *
 * Uses implicit flow (response_type=token): tokens arrive in the redirect
 * URL fragment — no separate token-exchange request needed.
 *
 * Flow:
 *   1. Load GOG auth page in WebView
 *   2. Intercept redirect to embed.gog.com/on_login_success
 *   3. Parse fragment: access_token, refresh_token, user_id
 *   4. Background thread: fetch userData.json → username
 *   5. Save all to "bh_gog_prefs" SharedPreferences, finish()
 */
public class GogLoginActivity extends Activity {

    private static final String TAG = "BH_GOG";
    static final String AUTH_URL =
            "https://auth.gog.com/auth" +
            "?client_id=46899977096215655" +
            "&redirect_uri=https%3A%2F%2Fembed.gog.com%2Fon_login_success%3Forigin%3Dclient" +
            "&response_type=token&layout=client2";

    WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        webView = new WebView(this);
        WebSettings ws = webView.getSettings();
        ws.setJavaScriptEnabled(true);
        ws.setDomStorageEnabled(true);
        ws.setUserAgentString("Mozilla/5.0 (Windows NT 10.0; Win64; x64) GOG Galaxy/2.0");
        webView.setWebViewClient(new GogWebViewClient());
        setContentView(webView);
        webView.loadUrl(AUTH_URL);
    }

    // ── Static helper reused by GogTokenRefresh ───────────────────────────────

    /** Extracts a string field from a minimal JSON blob (no library needed). */
    public static String parseJsonStringField(String json, String key) {
        if (json == null || key == null) return null;
        String search = "\"" + key + "\":\"";
        int idx = json.indexOf(search);
        if (idx < 0) return null;
        int start = idx + search.length();
        int end = json.indexOf('"', start);
        if (end < 0) return null;
        return json.substring(start, end);
    }

    // ── Inner WebViewClient ───────────────────────────────────────────────────

    private class GogWebViewClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            Uri uri = request.getUrl();
            if (uri.toString().startsWith("https://embed.gog.com/on_login_success")) {
                handleImplicitRedirect(uri);
                return true;
            }
            return false;
        }

        @Override
        @SuppressWarnings("deprecation")
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (url.startsWith("https://embed.gog.com/on_login_success")) {
                handleImplicitRedirect(Uri.parse(url));
                return true;
            }
            return false;
        }

        private void handleImplicitRedirect(Uri uri) {
            String fragment = uri.getFragment();
            if (fragment == null) return;

            // Parse fragment as a query string: "x://x?<fragment>"
            Uri frag = Uri.parse("x://x?" + fragment);
            String accessToken  = frag.getQueryParameter("access_token");
            if (accessToken == null) return;
            String refreshToken = frag.getQueryParameter("refresh_token");
            String userId       = frag.getQueryParameter("user_id");

            // Show feedback and start background thread
            webView.loadData(
                    "<html><body style='background:#111;color:#ccc;font-family:sans-serif;" +
                    "font-size:20px;text-align:center;padding-top:40%'>" +
                    "Logging in to GOG...</body></html>",
                    "text/html", "UTF-8");

            new Thread(new LoginRunnable(accessToken, refreshToken, userId)).start();
        }
    }

    // ── Background Runnable: fetch username, save prefs, finish ──────────────

    private class LoginRunnable implements Runnable {
        final String accessToken, refreshToken, userId;

        LoginRunnable(String accessToken, String refreshToken, String userId) {
            this.accessToken  = accessToken;
            this.refreshToken = refreshToken;
            this.userId       = userId;
        }

        @Override
        public void run() {
            try {
                // Fetch username from userData.json
                String username = "Unknown";
                try {
                    URL url = new URL("https://embed.gog.com/userData.json");
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setConnectTimeout(15000);
                    conn.setReadTimeout(15000);
                    conn.setRequestProperty("Authorization", "Bearer " + accessToken);
                    StringBuilder sb = new StringBuilder();
                    try (BufferedReader br = new BufferedReader(
                            new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                        String line;
                        while ((line = br.readLine()) != null) sb.append(line);
                    }
                    conn.disconnect();
                    String parsed = parseJsonStringField(sb.toString(), "username");
                    if (parsed != null) username = parsed;
                } catch (Exception ignored) {}

                // Save to SharedPreferences
                SharedPreferences.Editor ed = GogLoginActivity.this
                        .getSharedPreferences("bh_gog_prefs", 0).edit();
                ed.putString("access_token", accessToken);
                if (refreshToken != null) ed.putString("refresh_token", refreshToken);
                if (userId != null)       ed.putString("user_id", userId);
                ed.putString("username", username);
                int nowSec = (int) (System.currentTimeMillis() / 1000L);
                ed.putInt("bh_gog_login_time", nowSec);
                ed.putInt("bh_gog_expires_in", 3600);
                ed.apply();

                Log.d(TAG, "Login saved for: " + username);
                runOnUiThread(() -> finish());
            } catch (Exception e) {
                Log.e(TAG, "Login post-processing failed", e);
                runOnUiThread(() -> {
                    Toast.makeText(GogLoginActivity.this, "Login error, please try again",
                            Toast.LENGTH_SHORT).show();
                    webView.loadUrl(AUTH_URL);
                });
            }
        }
    }
}
