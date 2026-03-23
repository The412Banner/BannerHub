.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$8;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: UI progress Runnable for Epic install pipeline.
# Posted by $7 (download thread) to update syncText with current status.
# Also makes syncText VISIBLE in case $3 already hid it.

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$message:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$8;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$8;->val$message:Ljava/lang/String;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 2
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$8;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$8;->val$message:Ljava/lang/String;
    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->syncText:Landroid/widget/TextView;
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/4 v1, 0x0   # View.VISIBLE = 0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V
    return-void
.end method
