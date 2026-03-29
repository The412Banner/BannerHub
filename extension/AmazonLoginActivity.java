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
 * WebView OAuth2 login for Amazon Games (PKCE / authorization_code flow).
 *
 * Flow:
 *   1. Generate PKCE state (serial, clientId, verifier, challenge)
 *   2. Load Amazon sign-in page in WebView with code_challenge
 *   3. Intercept redirect to https://www.amazon.com/?openid.assoc_handle=amzn_sonic_games_launcher
 *   4. Extract openid.oa2.authorization_code from redirect URL
 *   5. Background thread: POST to https://api.amazon.com/auth/register → bearer tokens
 *   6. Save to AmazonCredentialStore, finish()
 *
 * Captures redirect via ALL THREE hooks (shouldOverrideUrlLoading×2 + onPageStarted)
 * with AtomicBoolean double-fire guard.
 */
public class AmazonLoginActivity extends Activity {

    private static final String TAG = "BH_AMAZON";

    private String pendingVerifier;
    private String pendingSerial;
    private String pendingClientId;

    private WebView webView;
    private final AtomicBoolean codeCaptured = new AtomicBoolean(false);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Generate PKCE state BEFORE loading WebView
        pendingSerial   = AmazonPKCEGenerator.generateDeviceSerial();
        pendingClientId = AmazonPKCEGenerator.generateClientId(pendingSerial);
        pendingVerifier = AmazonPKCEGenerator.generateCodeVerifier();
        String challenge = AmazonPKCEGenerator.generateCodeChallenge(pendingVerifier);

        Log.d(TAG, "AmazonLoginActivity: PKCE ready, loading auth page");

        webView = new WebView(this);
        WebSettings ws = webView.getSettings();
        ws.setJavaScriptEnabled(true);
        ws.setDomStorageEnabled(true);
        ws.setUserAgentString(AmazonAuthClient.USER_AGENT);
        webView.setWebViewClient(new AmazonWebViewClient());
        setContentView(webView);
        webView.loadUrl(buildAuthUrl(pendingClientId, challenge));
    }

    // ── Auth URL ──────────────────────────────────────────────────────────────

    private static String buildAuthUrl(String clientId, String codeChallenge) {
        return "https://www.amazon.com/ap/signin"
            + "?openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0"
            + "&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select"
            + "&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select"
            + "&openid.mode=checkid_setup"
            + "&openid.oa2.scope=device_auth_access"
            + "&openid.ns.oa2=http%3A%2F%2Fwww.amazon.com%2Fap%2Fext%2Foauth%2F2"
            + "&openid.oa2.response_type=code"
            + "&openid.oa2.code_challenge_method=S256"
            + "&openid.oa2.client_id=device%3A" + clientId
            + "&language=en_US"
            + "&marketPlaceId=ATVPDKIKX0DER"
            + "&openid.return_to=https%3A%2F%2Fgaming.amazon.com"
            + "&openid.pape.max_auth_age=0"
            + "&openid.ns.pape=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Fpape%2F1.0"
            + "&openid.assoc_handle=amzn_sonic_games_launcher"
            + "&pageId=amzn_sonic_games_launcher"
            + "&openid.oa2.code_challenge=" + codeChallenge;
    }

    // ── Redirect detection ────────────────────────────────────────────────────

    static boolean isAmazonRedirect(String url) {
        return (url.startsWith("https://www.amazon.com/")
             || url.startsWith("https://amazon.com/")
             || url.startsWith("https://gaming.amazon.com/"))
            && url.contains("openid.assoc_handle=amzn_sonic_games_launcher");
    }

    private static String extractAuthCode(String url) {
        return Uri.parse(url).getQueryParameter("openid.oa2.authorization_code");
    }

    private void handleCodeCapture(WebView view, String url) {
        if (!isAmazonRedirect(url)) return;
        if (!codeCaptured.compareAndSet(false, true)) return; // double-fire guard

        String code = extractAuthCode(url);
        if (code == null) {
            Log.e(TAG, "Amazon redirect missing auth code: " + url);
            codeCaptured.set(false);
            return;
        }

        if (view != null) view.stopLoading();
        Log.d(TAG, "Amazon auth code captured, registering device...");

        final String capturedCode     = code;
        final String capturedVerifier = pendingVerifier;
        final String capturedSerial   = pendingSerial;
        final String capturedClientId = pendingClientId;

        new Thread(() -> {
            AmazonAuthClient.RegisterResult result = AmazonAuthClient.registerDevice(
                    capturedCode, capturedVerifier, capturedSerial, capturedClientId);

            if (result == null) {
                Log.e(TAG, "Device registration failed");
                runOnUiThread(() -> {
                    codeCaptured.set(false);
                    Toast.makeText(AmazonLoginActivity.this,
                            "Amazon login failed, please try again", Toast.LENGTH_SHORT).show();
                });
                return;
            }

            AmazonCredentialStore.Credentials creds = new AmazonCredentialStore.Credentials();
            creds.accessToken  = result.accessToken;
            creds.refreshToken = result.refreshToken;
            creds.deviceSerial = capturedSerial;
            creds.clientId     = capturedClientId;
            creds.expiresAt    = System.currentTimeMillis() + (result.expiresIn * 1000L);
            AmazonCredentialStore.save(AmazonLoginActivity.this, creds);

            Log.d(TAG, "Amazon login saved OK, token expires in " + result.expiresIn + "s");
            runOnUiThread(() -> finish());
        }).start();
    }

    // ── WebViewClient — intercept redirect in all three hooks ─────────────────

    private class AmazonWebViewClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            String url = request.getUrl().toString();
            if (isAmazonRedirect(url)) {
                handleCodeCapture(view, url);
                return true;
            }
            return false;
        }

        @Override
        @SuppressWarnings("deprecation")
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (isAmazonRedirect(url)) {
                handleCodeCapture(view, url);
                return true;
            }
            return false;
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            if (isAmazonRedirect(url)) {
                handleCodeCapture(view, url);
            }
        }
    }
}
