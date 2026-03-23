.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: Status-text Runnable for EpicMainActivity.
# Sets syncText.setText(val$msg) on the UI thread.
# Used for on-screen diagnostic messages at sync failure points.

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$msg:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;->val$msg:Ljava/lang/String;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 2
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->syncText:Landroid/widget/TextView;
    if-eqz v1, :done
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;->val$msg:Ljava/lang/String;
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :done
    return-void
.end method
