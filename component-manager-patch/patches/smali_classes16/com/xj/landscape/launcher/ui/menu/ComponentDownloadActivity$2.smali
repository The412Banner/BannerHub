# ShowCategoriesRunnable — UI thread: call showCategories() after fetch completes
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    return-void
.end method

.method public run()V
    .locals 1
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->showCategories()V
    return-void
.end method
