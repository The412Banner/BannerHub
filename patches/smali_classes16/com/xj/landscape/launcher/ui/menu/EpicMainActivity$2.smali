.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: UI Runnable posted by $1 for each Epic game found in library.
# Adds a card (LinearLayout) to EpicMainActivity.gameList containing:
#   - TextView: appName (white, 16sp)
#   - Button:   "Install" (white text, height 80px, MATCH_PARENT width)
#
# Register map (.locals 8  →  p0 = v8):
#   v0 = this$0 (EpicMainActivity / Context)
#   v1 = appName String
#   v2 = gameList LinearLayout
#   v3 = card LinearLayout
#   v4 = name TextView → Install Button (reused after addView)
#   v5 = string temp → LinearLayout$LayoutParams
#   v6 = LP width (-1 = MATCH_PARENT)  / float temp (16.0f)
#   v7 = LP height (80px)
#   p0 = v8 = this

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic appName:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->appName:Ljava/lang/String;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 8

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->appName:Ljava/lang/String;

    # Get gameList
    iget-object v2, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->gameList:Landroid/widget/LinearLayout;

    # ── Card container LinearLayout ────────────────────────────────────────────
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v4, 0x1   # VERTICAL
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v4, 0x10  # 16px padding
    invoke-virtual {v3, v4, v4, v4, v4}, Landroid/view/View;->setPadding(IIII)V
    const v4, 0xFF222222
    invoke-virtual {v3, v4}, Landroid/view/View;->setBackgroundColor(I)V

    # ── appName TextView ───────────────────────────────────────────────────────
    new-instance v4, Landroid/widget/TextView;
    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v4, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/4 v5, -0x1   # white 0xFFFFFFFF
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setTextColor(I)V
    const/4 v5, 0x2    # SP unit
    const/high16 v6, 0x41800000  # 16.0f
    invoke-virtual {v4, v5, v6}, Landroid/widget/TextView;->setTextSize(IF)V
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Install Button with explicit height ────────────────────────────────────
    new-instance v4, Landroid/widget/Button;
    invoke-direct {v4, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v5, "Install"
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const/4 v5, -0x1   # white text
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setTextColor(I)V

    new-instance v5, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;
    invoke-direct {v5, v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v6, -0x1   # MATCH_PARENT = -1
    const/16 v7, 0x50  # 80px height
    invoke-direct {v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v3, v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Add card to gameList ───────────────────────────────────────────────────
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-void
.end method
