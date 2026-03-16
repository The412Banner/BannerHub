# CompleteRunnable — UI thread: show toast with result message, finish activity
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
.field final val$message:Ljava/lang/String;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;->val$message:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 3
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;->val$message:Ljava/lang/String;
    const/4 v2, 0x1
    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->finish()V
    return-void
.end method
