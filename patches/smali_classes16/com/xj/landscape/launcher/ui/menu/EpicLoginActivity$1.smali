.class public Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$1;
.super Landroid/webkit/WebViewClient;

# BannerHub: WebViewClient for EpicLoginActivity.
# onPageFinished: detects /id/api/redirect URL → injects JS to read
# document.body.innerText and pass it to EpicInterface.onCode().

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;
    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V
    return-void
.end method


.method public onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 2

    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V

    # Check if the current URL is the Epic redirect/auth-code page
    if-eqz p2, :done

    const-string v0, "/id/api/redirect"
    invoke-virtual {p2, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :done

    # Inject JS to extract the JSON body and pass it to our JS interface
    const-string v0, "javascript:(function(){try{EpicInterface.onCode(document.body.innerText);}catch(e){}})()"
    invoke-virtual {p1, v0}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    :done
    return-void
.end method
