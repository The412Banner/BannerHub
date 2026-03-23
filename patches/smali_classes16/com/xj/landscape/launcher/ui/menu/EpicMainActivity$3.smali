.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$3;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: Sync-done Runnable for EpicMainActivity.
# Posted to UI thread by $1 when library sync completes (or fails).
# Hides the "Syncing..." TextView (View.GONE = 8).

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$3;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$3;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->syncText:Landroid/widget/TextView;
    if-eqz v1, :done
    const/16 v0, 0x8   # View.GONE = 8
    invoke-virtual {v1, v0}, Landroid/view/View;->setVisibility(I)V
    :done
    return-void
.end method
