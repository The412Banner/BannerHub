.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: UI Runnable posted by $1 for each Epic game found in library.
# Builds a GOG-style horizontal card in EpicMainActivity.gameList:
#   Left:  60dp×60dp dark-grey (#333333) placeholder with first-letter TextView
#   Right: vertical LinearLayout (weight=1, 12dp left padding)
#     - Title TextView (appName, white #F0F0F0, 15sp bold)
#     - Subtitle TextView ("Epic Games", grey #888888, 13sp)
#     - Install Button (white text, MATCH_PARENT × 40dp, 8dp top margin)
# Card: horizontal LL, rounded dark #1A1A1A bg (10dp radius), 12dp padding.
#
# Register map (.locals 15 → p0 = v15):
#   v0  = this$0 (EpicMainActivity)
#   v1  = appName String
#   v2  = density float (dp→px)
#   v3  = gameList LinearLayout
#   v4  = card root LinearLayout (HORIZONTAL)
#   v5  = GradientDrawable / LayoutParams (reused)
#   v6  = placeholder LinearLayout (left, 60dp square)
#   v7  = letter TextView
#   v8  = right info LinearLayout (VERTICAL)
#   v9  = title TextView
#   v10 = subtitle TextView
#   v11 = Install Button
#   v12 = EpicMainActivity$5 (OnClickListener)
#   v13 = LayoutParams temp / int temp
#   v14 = float/int temp
#   p0  = v15 = this

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
    .locals 15

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->appName:Ljava/lang/String;

    # Get gameList
    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->gameList:Landroid/widget/LinearLayout;

    # Display density for dp→px conversion
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v2
    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v2
    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    # ── Card root: HORIZONTAL LinearLayout ───────────────────────────────────
    new-instance v4, Landroid/widget/LinearLayout;
    invoke-direct {v4, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v14, 0x0   # HORIZONTAL
    invoke-virtual {v4, v14}, Landroid/widget/LinearLayout;->setOrientation(I)V

    # Rounded dark background: GradientDrawable, color #1A1A1A, radius 10dp
    new-instance v5, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v5}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    const v14, 0xFF1A1A1A
    invoke-virtual {v5, v14}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/high16 v14, 0x41200000   # 10.0f
    mul-float v14, v2, v14
    invoke-virtual {v5, v14}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v4, v5}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # Card padding: 12dp all sides
    const/high16 v14, 0x41400000   # 12.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    invoke-virtual {v4, v14, v14, v14, v14}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # ── Left placeholder: dark grey, 60dp × 60dp, gravity CENTER ─────────────
    new-instance v6, Landroid/widget/LinearLayout;
    invoke-direct {v6, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const v14, 0xFF333333
    invoke-virtual {v6, v14}, Landroid/view/View;->setBackgroundColor(I)V
    const/16 v14, 0x11   # Gravity.CENTER = 17
    invoke-virtual {v6, v14}, Landroid/widget/LinearLayout;->setGravity(I)V

    # LP: 60dp × 60dp
    const/high16 v14, 0x42700000   # 60.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v13, v14, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v4, v6, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # First-letter TextView inside placeholder (appName guaranteed non-empty by $1)
    new-instance v7, Landroid/widget/TextView;
    invoke-direct {v7, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const/4 v13, 0x0
    const/4 v14, 0x1
    invoke-virtual {v1, v13, v14}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    invoke-virtual {v7, v13}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFCCCCCC
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41900000   # 18.0f
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextSize(F)V
    sget-object v13, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;
    invoke-virtual {v7, v13}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V
    invoke-virtual {v6, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Right info panel: VERTICAL LinearLayout, weight=1 ────────────────────
    new-instance v8, Landroid/widget/LinearLayout;
    invoke-direct {v8, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v14, 0x1   # VERTICAL
    invoke-virtual {v8, v14}, Landroid/widget/LinearLayout;->setOrientation(I)V

    # Left padding = 12dp (gap between placeholder and text)
    const/high16 v14, 0x41400000   # 12.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    const/4 v13, 0x0
    invoke-virtual {v8, v14, v13, v13, v13}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Gravity.TOP = 48 (0x30)
    const/16 v14, 0x30
    invoke-virtual {v8, v14}, Landroid/widget/LinearLayout;->setGravity(I)V

    # LP: 0dp width, WRAP_CONTENT height, weight=1.0f
    const/4 v13, 0x0   # 0dp width
    const/4 v14, -0x2  # WRAP_CONTENT = -2
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v5, v13, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x3F800000   # 1.0f
    iput v14, v5, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v4, v8, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Title TextView (appName, white #F0F0F0, 15sp bold) ────────────────────
    new-instance v9, Landroid/widget/TextView;
    invoke-direct {v9, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v9, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFF0F0F0
    invoke-virtual {v9, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41700000   # 15.0f
    invoke-virtual {v9, v14}, Landroid/widget/TextView;->setTextSize(F)V
    sget-object v13, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;
    invoke-virtual {v9, v13}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V
    invoke-virtual {v8, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Subtitle TextView ("Epic Games", grey #888888, 13sp) ──────────────────
    new-instance v10, Landroid/widget/TextView;
    invoke-direct {v10, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v13, "Epic Games"
    invoke-virtual {v10, v13}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFF888888
    invoke-virtual {v10, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41500000   # 13.0f
    invoke-virtual {v10, v14}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v8, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Install Button (MATCH_PARENT × 40dp, 8dp top margin) ─────────────────
    new-instance v11, Landroid/widget/Button;
    invoke-direct {v11, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v13, "Install"
    invoke-virtual {v11, v13}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFFFFFFF
    invoke-virtual {v11, v14}, Landroid/widget/Button;->setTextColor(I)V

    # Wire OnClickListener
    new-instance v12, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;
    invoke-direct {v12, v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v11, v12}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # LP: MATCH_PARENT × 40dp, topMargin = 8dp
    const/high16 v14, 0x42200000   # 40.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    const/4 v13, -0x1   # MATCH_PARENT = -1
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v5, v13, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x41000000   # 8.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    iput v14, v5, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    invoke-virtual {v8, v11, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Add card to gameList ──────────────────────────────────────────────────
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-void
.end method
