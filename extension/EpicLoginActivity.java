package app.revanced.extension.gamehub;

import android.app.Activity;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebResourceRequest;
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
 *   2. Intercept redirect to https://www.epicgames.com/id/api/redirect?...&code=<authcode>
 *   3. Extract authorization code from redirect URL
 *   4. Background thread: POST to token endpoint with Legendary client credentials
 *   5. Save to EpicCredentialStore, finish()
 *
 * Redirect intercepted in all three WebViewClient hooks with AtomicBoolean double-fire guard.
 */
public class EpicLoginActivity extends Activity {

    private static final String TAG = "BH_EPIC";

    private static final String AUTH_URL =
            "https://www.epicgames.com/id/login"
            + "?redirectUrl=https%3A%2F%2Fwww.epicgames.com%2Fid%2Fapi%2Fredirect"
            + "%3FclientId%3D" + EpicAuthClient.CLIENT_ID
            + "%26responseType%3Dcode";

    // The redirect URL we intercept to capture the auth code
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

    // ── Redirect detection ────────────────────────────────────────────────────

    private static boolean isEpicRedirect(String url) {
        return url.startsWith(REDIRECT_HOST) && url.contains("code=");
    }

    private static String extractAuthCode(String url) {
        return Uri.parse(url).getQueryParameter("code");
    }

    private void handleCodeCapture(WebView view, String url) {
        if (!isEpicRedirect(url)) return;
        if (!codeCaptured.compareAndSet(false, true)) return; // double-fire guard

        String code = extractAuthCode(url);
        if (code == null) {
            Log.e(TAG, "Epic redirect missing auth code: " + url);
            codeCaptured.set(false);
            return;
        }

        if (view != null) view.stopLoading();
        Log.d(TAG, "Epic auth code captured, exchanging for tokens...");

        final String capturedCode = code;
        new Thread(() -> {
            EpicAuthClient.TokenResult result = EpicAuthClient.exchangeCode(capturedCode);

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

    // ── WebViewClient ─────────────────────────────────────────────────────────

    private class EpicWebViewClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            String url = request.getUrl().toString();
            if (isEpicRedirect(url)) {
                handleCodeCapture(view, url);
                return true;
            }
            return false;
        }

        @Override
        @SuppressWarnings("deprecation")
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (isEpicRedirect(url)) {
                handleCodeCapture(view, url);
                return true;
            }
            return false;
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            if (isEpicRedirect(url)) {
                handleCodeCapture(view, url);
            }
        }
    }
}
