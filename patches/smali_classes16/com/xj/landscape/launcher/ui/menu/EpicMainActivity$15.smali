.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$15;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# BannerHub: Arrow (▼/▲) OnClickListener for Epic game cards.
# Tapping the arrow always collapses the expandSection and resets the arrow to ▼.
# Also clears EpicMainActivity.expandedSection / expandedArrow fields.

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$expandSection:Landroid/widget/LinearLayout;
.field final synthetic val$arrowTV:Landroid/widget/TextView;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Landroid/widget/LinearLayout;Landroid/widget/TextView;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$15;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$15;->val$expandSection:Landroid/widget/LinearLayout;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$15;->val$arrowTV:Landroid/widget/TextView;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 4

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$15;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$15;->val$expandSection:Landroid/widget/LinearLayout;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$15;->val$arrowTV:Landroid/widget/TextView;

    # Collapse expandSection
    const/16 v3, 0x8
    invoke-virtual {v1, v3}, Landroid/view/View;->setVisibility(I)V

    # Reset arrow to ▼
    const-string v3, "\u25bc"
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Clear activity-level expanded state
    const/4 v3, 0x0
    iput-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->expandedSection:Landroid/widget/LinearLayout;
    iput-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->expandedArrow:Landroid/widget/TextView;

    return-void
.end method
