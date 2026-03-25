.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$17;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: UI update Runnable posted by $16 after Epic game uninstall completes.
# Resets card to not-installed state:
#   checkTV → GONE, collapsedCheckTV → GONE, launchBtn → GONE, addBtn → VISIBLE.
# Shows a Toast.

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$17;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$17;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 4

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$17;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$17;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;

    const/16 v3, 0x8   # GONE

    # checkTV → GONE
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$checkTV:Landroid/widget/TextView;
    invoke-virtual {v2, v3}, Landroid/view/View;->setVisibility(I)V

    # collapsedCheckTV → GONE
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$collapsedCheckTV:Landroid/widget/TextView;
    invoke-virtual {v2, v3}, Landroid/view/View;->setVisibility(I)V

    # launchBtn → GONE
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$launchBtn:Landroid/widget/Button;
    invoke-virtual {v2, v3}, Landroid/view/View;->setVisibility(I)V

    # addBtn → VISIBLE
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$addBtn:Landroid/widget/Button;
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Landroid/view/View;->setVisibility(I)V

    # Also hide statusTV (clear any "Install failed" text)
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$statusTV:Landroid/widget/TextView;
    const/16 v3, 0x8
    invoke-virtual {v2, v3}, Landroid/view/View;->setVisibility(I)V

    # Toast "Game uninstalled"
    const-string v2, "Game uninstalled"
    const/4 v3, 0x0
    invoke-static {v0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    return-void
.end method
