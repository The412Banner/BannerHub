.class public final Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;
.super Landroid/webkit/WebViewClient;

# BannerHub: WebViewClient for GogLoginActivity.
# Intercepts redirect to embed.gog.com/on_login_success.
# Implicit flow (response_type=token): tokens arrive in URL fragment
# (#access_token=TOKEN&refresh_token=REFRESH&user_id=UID&...)
# Parse fragment directly — no token exchange HTTP request needed.

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V
    .locals 0

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    return-void
.end method


# ── Helper: parse implicit-flow fragment and start $2 thread ─────────────────
# fragmentUri = Uri.parse("x://x?" + fragment) to reuse getQueryParameter
# Extracts access_token, refresh_token, user_id; starts $2; shows feedback.
# Returns 1 (intercept) always when called.
# Registers on entry: v0=source Uri (has fragment), v0-v6 available
.method private handleImplicitRedirect(Landroid/net/Uri;)V
    .locals 7

    # Get URL fragment: "access_token=TOKEN&refresh_token=R&user_id=U&..."
    invoke-virtual {p1}, Landroid/net/Uri;->getFragment()Ljava/lang/String;

    move-result-object v0  # fragment string

    if-eqz v0, :no_fragment

    # Wrap fragment as query string: "x://x?<fragment>" for Uri.getQueryParameter
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "x://x?"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1  # fragment parsed as query Uri

    const-string v2, "access_token"

    invoke-virtual {v1, v2}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2  # accessToken

    if-eqz v2, :no_fragment

    const-string v3, "refresh_token"

    invoke-virtual {v1, v3}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3  # refreshToken (may be null)

    const-string v4, "user_id"

    invoke-virtual {v1, v4}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4  # userId (may be null)

    # Start $2 thread: fetches userData.json, saves tokens to SP, finishes
    iget-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    new-instance v6, Ljava/lang/Thread;

    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;

    invoke-direct {v1, v5, v2, v3, v4}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v6, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v6}, Ljava/lang/Thread;->start()V

    # Replace WebView content with "Logging in..." feedback
    iget-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    iget-object v5, v5, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->webView:Landroid/webkit/WebView;

    const-string v1, "<html><body style='background:#111;color:#ccc;font-family:sans-serif;font-size:20px;text-align:center;padding-top:40%'>Logging in to GOG...</body></html>"

    const-string v2, "text/html"

    const-string v3, "UTF-8"

    invoke-virtual {v5, v1, v2, v3}, Landroid/webkit/WebView;->loadData(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :no_fragment

    return-void
.end method


# ── shouldOverrideUrlLoading (WebResourceRequest variant — API 24+) ───────────
.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Z
    .locals 3

    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object v0  # Uri

    invoke-virtual {v0}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v1  # url string

    const-string v2, "https://embed.gog.com/on_login_success"

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :not_redirect

    # It is the on_login_success redirect — parse fragment for tokens
    invoke-direct {p0, v0}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;->handleImplicitRedirect(Landroid/net/Uri;)V

    const/4 v0, 0x1

    return v0

    :not_redirect

    const/4 v0, 0x0

    return v0
.end method


# ── shouldOverrideUrlLoading (deprecated String variant — older Android) ──────
.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Ljava/lang/String;)Z
    .locals 3

    const-string v0, "https://embed.gog.com/on_login_success"

    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :not_redirect2

    # Parse the URL string into a Uri to extract the fragment
    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1  # Uri

    invoke-direct {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;->handleImplicitRedirect(Landroid/net/Uri;)V

    const/4 v0, 0x1

    return v0

    :not_redirect2

    const/4 v0, 0x0

    return v0
.end method
