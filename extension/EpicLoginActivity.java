package app.revanced.extension.gamehub;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * WebView OAuth2 login for Epic Games (authorization_code flow).
 *
 * Flow:
 *   1. Load Epic login page in WebView
 *   2. After login, Epic redirects to epicgames.com/id/api/redirect which serves
 *      a JSON page body: {"authorizationCode":"XXXX",...}
 *   3. onPageFinished detects the redirect URL, reads page body via evaluateJavascript
 *   4. Background thread: POST to token endpoint with Legendary client credentials
 *   5. Save to EpicCredentialStore, finish()
 */
public class EpicLoginActivity extends Activity {

    private static final String TAG = "BH_EPIC";

    private static final String AUTH_URL =
            "https://www.epicgames.com/id/login"
            + "?redirectUrl=https%3A%2F%2Fwww.epicgames.com%2Fid%2Fapi%2Fredirect"
            + "%3FclientId%3D" + EpicAuthClient.CLIENT_ID
            + "%26responseType%3Dcode";

    private static final String REDIRECT_HOST = "https://www.epicgames.com/id/api/redirect";

    private WebView webView;
    private final AtomicBoolean codeCaptured = new AtomicBoolean(false);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        webView = new WebView(this);
        WebSettings ws = webView.getSettings();
        ws.setJavaScriptEnabled(true);
        ws.setDomStorageEnabled(true);
        ws.setUserAgentString(EpicAuthClient.USER_AGENT);
        webView.setWebViewClient(new EpicWebViewClient());
        setContentView(webView);
        webView.loadUrl(AUTH_URL);
        Log.d(TAG, "EpicLoginActivity: loading auth page");
    }

    private void handleJsonPage(WebView view) {
        if (!codeCaptured.compareAndSet(false, true)) return;
        view.stopLoading();
        // Read the raw JSON text from the page body
        view.evaluateJavascript(
            "(function(){ try { return document.body.innerText; } catch(e){ return ''; } })()",
            json -> {
                if (json == null) { codeCaptured.set(false); return; }
                // evaluateJavascript returns a JS string literal — strip outer quotes
                if (json.startsWith("\"")) json = json.substring(1, json.length() - 1);
                // Unescape JSON string (evaluateJavascript escapes \n \r \" etc.)
                json = json.replace("\\n", "").replace("\\r", "").replace("\\\"", "\"");

                final String authCode = extractField(json, "authorizationCode");
                if (authCode == null || authCode.isEmpty()) {
                    Log.e(TAG, "authorizationCode not found in page: " + json);
                    codeCaptured.set(false);
                    Toast.makeText(this, "Epic login failed, please try again", Toast.LENGTH_SHORT).show();
                    webView.loadUrl(AUTH_URL);
                    return;
                }

                Log.d(TAG, "Epic auth code captured, exchanging for tokens...");
                new Thread(() -> {
                    EpicAuthClient.TokenResult result = EpicAuthClient.exchangeCode(authCode);

                    if (result == null) {
                        Log.e(TAG, "Epic token exchange failed");
                        runOnUiThread(() -> {
                            codeCaptured.set(false);
                            Toast.makeText(EpicLoginActivity.this,
                                    "Epic login failed, please try again", Toast.LENGTH_SHORT).show();
                            webView.loadUrl(AUTH_URL);
                        });
                        return;
                    }

                    EpicCredentialStore.Credentials creds = new EpicCredentialStore.Credentials();
                    creds.accessToken  = result.accessToken;
                    creds.refreshToken = result.refreshToken;
                    creds.accountId    = result.accountId;
                    creds.displayName  = result.displayName;
                    creds.expiresAt    = result.expiresAt;
                    EpicCredentialStore.save(EpicLoginActivity.this, creds);

                    Log.d(TAG, "Epic login saved OK for: " + result.displayName);
                    runOnUiThread(() -> finish());
                }).start();
            }
        );
    }

    /** Minimal JSON field extractor — pulls the string value for a given key. */
    private static String extractField(String json, String key) {
        String search = "\"" + key + "\":\"";
        int start = json.indexOf(search);
        if (start < 0) return null;
        start += search.length();
        int end = json.indexOf("\"", start);
        if (end < 0) return null;
        return json.substring(start, end);
    }

    // ── WebViewClient ─────────────────────────────────────────────────────────

    private class EpicWebViewClient extends WebViewClient {

        @Override
        public void onPageFinished(WebView view, String url) {
            if (url != null && url.startsWith(REDIRECT_HOST)) {
                handleJsonPage(view);
            }
        }
    }
}
