.class public Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$4;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: Success Runnable for EpicLoginActivity.
# Posted to UI thread by $2 on successful token exchange.
# Shows "Epic login successful!" Toast and finishes the activity.

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$4;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 3

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$4;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;

    const-string v1, "Epic login successful!"
    const/4 v2, 0x1   # Toast.LENGTH_LONG
    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;->finish()V

    return-void
.end method
