.class public Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;
.super Landroid/app/Activity;

# BannerHub: WebView-based GOG OAuth2 login screen.
# Opens GOG auth page, intercepts on_login_success redirect,
# exchanges code for token via auth.gog.com/token,
# fetches username from embed.gog.com/userData.json,
# saves to SharedPreferences "bh_gog_prefs".
#
# GOG embedded client credentials (publicly documented):
#   client_id  = "46899977096215655"
#   client_secret = "9d85c43b1482497dbbce61f6e4aa173a"

.field public webView:Landroid/webkit/WebView;


.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method


# ── buildAuthUrl(): returns GOG OAuth2 authorization URL ─────────────────────
.method public static buildAuthUrl()Ljava/lang/String;
    .locals 1

    const-string v0, "https://auth.gog.com/auth?client_id=46899977096215655&redirect_uri=https%3A%2F%2Fembed.gog.com%2Fon_login_success%3Forigin%3Dclient&response_type=code&layout=client2"

    return-object v0
.end method


# ── parseJsonStringField(String json, String key): simple JSON string extractor
.method public static parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 5

    # Build search string: "key":"
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\":\""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0  # searchStr = "key":"

    # Find searchStr in json
    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1  # idx

    const/4 v2, -0x1

    if-ne v1, v2, :found

    const/4 v0, 0x0

    return-object v0  # not found, return null

    :found

    # start = idx + searchStr.length()
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v3

    add-int/2addr v1, v3  # start = idx + len

    # Find closing " after start
    const-string v3, "\""

    invoke-virtual {p0, v3, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v4  # end

    if-ne v4, v2, :get_sub

    const/4 v0, 0x0

    return-object v0

    :get_sub

    invoke-virtual {p0, v1, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method


# ── onCreate ─────────────────────────────────────────────────────────────────
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 4

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    # Create WebView
    new-instance v0, Landroid/webkit/WebView;

    invoke-direct {v0, p0}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->webView:Landroid/webkit/WebView;

    # Enable JavaScript
    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    # Enable DOM storage (some auth pages need it)
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    # Set User-Agent to match GOG Galaxy desktop client
    const-string v2, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) GOG Galaxy/2.0"

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setUserAgentString(Ljava/lang/String;)V

    # Set custom WebViewClient to intercept redirect
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;

    invoke-direct {v1, p0}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    # Set as content view
    invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V

    # Load auth URL
    invoke-static {}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->buildAuthUrl()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    return-void
.end method


# ── onBackPressed ─────────────────────────────────────────────────────────────
.method public onBackPressed()V
    .locals 0

    invoke-super {p0}, Landroid/app/Activity;->onBackPressed()V

    return-void
.end method
