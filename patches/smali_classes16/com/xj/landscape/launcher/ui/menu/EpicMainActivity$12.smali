.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: UI error Runnable for Epic install pipeline.
# Posted by $7 on any install failure to restore the card to its pre-install state:
#   progressBar GONE, statusTV GONE, addBtn VISIBLE.

.field final synthetic val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 3

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;

    # progressBar → GONE
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$progressBar:Landroid/widget/ProgressBar;
    const/16 v2, 0x8
    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    # statusTV → GONE
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$statusTV:Landroid/widget/TextView;
    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    # addBtn → VISIBLE
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$addBtn:Landroid/widget/Button;
    const/4 v2, 0x0
    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    return-void
.end method
