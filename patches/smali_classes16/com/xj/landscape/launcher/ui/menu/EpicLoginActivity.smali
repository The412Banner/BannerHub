.class public Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;
.super Landroid/app/Activity;

# BannerHub: Epic Games Store OAuth login WebView activity.
# Loads Epic login page → detects redirect to /id/api/redirect
# → $1 (WebViewClient) injects JS → $3 (JS interface) receives authorizationCode
# → $2 (Runnable) exchanges code for tokens → EpicCredentialStore.save()
# → $4 (success) or $5 (failure) Toast + finish.

.field public webView:Landroid/webkit/WebView;


.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method


.method protected onCreate(Landroid/os/Bundle;)V
    .locals 5

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    # ── Create WebView ────────────────────────────────────────────────────────
    new-instance v0, Landroid/webkit/WebView;
    invoke-direct {v0, p0}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;->webView:Landroid/webkit/WebView;

    # ── Configure WebSettings ─────────────────────────────────────────────────
    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;
    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    const-string v3, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    invoke-virtual {v1, v3}, Landroid/webkit/WebSettings;->setUserAgentString(Ljava/lang/String;)V

    # ── Add JavaScript interface ($3 receives auth code from injected JS) ─────
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$3;
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;)V
    const-string v4, "EpicInterface"
    invoke-virtual {v0, v3, v4}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V

    # ── Set WebViewClient ($1 intercepts redirect page) ───────────────────────
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$1;
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;)V
    invoke-virtual {v0, v3}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    # ── Set content view and load Epic login URL ──────────────────────────────
    invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V

    const-string v3, "https://www.epicgames.com/id/login?redirectUrl=https%3A%2F%2Fwww.epicgames.com%2Fid%2Fapi%2Fredirect%3FclientId%3D34a02cf8f4414e29b15921876da36f9a%26responseType%3Dcode"
    invoke-virtual {v0, v3}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    return-void
.end method


.method public onBackPressed()V
    .locals 1

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;->webView:Landroid/webkit/WebView;
    invoke-virtual {v0}, Landroid/webkit/WebView;->canGoBack()Z
    move-result v0
    if-eqz v0, :no_back

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;->webView:Landroid/webkit/WebView;
    invoke-virtual {v0}, Landroid/webkit/WebView;->goBack()V
    return-void

    :no_back
    invoke-super {p0}, Landroid/app/Activity;->onBackPressed()V
    return-void
.end method
