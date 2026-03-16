# InjectRunnable — UI thread: call injectComponent (which toasts internally), then finish activity
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
.field final val$uri:Landroid/net/Uri;
.field final val$type:I
.field final val$filename:Ljava/lang/String;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Landroid/net/Uri;ILjava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$uri:Landroid/net/Uri;
    iput p3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$type:I
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$filename:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 5
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$uri:Landroid/net/Uri;
    iget v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$type:I

    invoke-static {v0, v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->injectComponent(Landroid/content/Context;Landroid/net/Uri;I)V

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->finish()V
    return-void
.end method
