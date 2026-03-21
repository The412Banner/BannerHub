.class public final Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$4;
.super Ljava/lang/Object;

# BannerHub: UI-thread Runnable — show error toast when GOG login fails.

.implements Ljava/lang/Runnable;


.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$4;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    return-void
.end method


.method public run()V
    .locals 3

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$4;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    const-string v1, "GOG login failed. Please try again."

    const/4 v2, 0x0  # Toast.LENGTH_SHORT

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v1

    invoke-virtual {v1}, Landroid/widget/Toast;->show()V

    # Reload the auth page so user sees the login form again instead of a blank screen
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->webView:Landroid/webkit/WebView;

    invoke-static {}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->buildAuthUrl()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    return-void
.end method
