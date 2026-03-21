.class public final Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;
.super Landroid/webkit/WebViewClient;

# BannerHub: WebViewClient for GogLoginActivity.
# Intercepts redirect to embed.gog.com/on_login_success,
# extracts the authorization code, and starts the token exchange thread.

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V
    .locals 0

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    return-void
.end method


.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Z
    .locals 5

    # Get URL string from request
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object v0  # Uri

    invoke-virtual {v0}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v1  # url string

    # Check if it starts with the GOG success redirect prefix
    const-string v2, "https://embed.gog.com/on_login_success"

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :not_redirect

    # Extract "code" query parameter from the Uri
    const-string v2, "code"

    invoke-virtual {v0, v2}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2  # code

    if-eqz v2, :redirect_no_code

    # Start token exchange on a background thread
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    new-instance v4, Ljava/lang/Thread;

    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;

    invoke-direct {v0, v3, v2}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;Ljava/lang/String;)V

    invoke-direct {v4, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v4}, Ljava/lang/Thread;->start()V

    :redirect_no_code

    const/4 v0, 0x1

    return v0

    :not_redirect

    const/4 v0, 0x0

    return v0
.end method
