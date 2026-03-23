.class public Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$3;
.super Ljava/lang/Object;

# BannerHub: JavaScript interface for EpicLoginActivity.
# Registered as "EpicInterface" on the WebView.
# onCode(String) is called by injected JS with document.body.innerText.
# Parses authorizationCode from the JSON body, then starts $2 on a
# background thread to exchange it for tokens.

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$3;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# Called from JS on the WebView JS thread.
# p1 = full text of document.body (JSON from Epic redirect page).
.method public onCode(Ljava/lang/String;)V
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .locals 3

    # Parse "authorizationCode" field from the JSON body text
    const-string v0, "authorizationCode"
    invoke-static {p1, v0}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0   # authorizationCode string or null

    # Ignore if not the auth code page or already consumed
    if-eqz v0, :done

    # Create token exchange runnable and start background thread
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$3;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$2;
    invoke-direct {v2, v1, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;Ljava/lang/String;)V

    new-instance v0, Ljava/lang/Thread;
    invoke-direct {v0, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    :done
    return-void
.end method
