.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: UI Runnable posted by $1 for each Epic game found in library.
# Builds a GOG-style horizontal card in EpicMainActivity.gameList:
#   Left:  60dp×60dp ImageView (dark-grey #333333 bg; cover art loaded async by $10)
#   Right: vertical LinearLayout (weight=1, 12dp left padding)
#     - Title TextView (displayTitle, white #F0F0F0, 15sp bold)
#     - Subtitle TextView ("Epic Games", grey #888888, 13sp)
#     - Checkmark TextView (✓, green #4CAF50, 20sp, GONE until installed)
#     - Add Button (VISIBLE when not installed; triggers download+install via $5)
#     - ProgressBar (GONE; shown during install)
#     - Status TextView (GONE; shows progress steps during install)
#     - Launch Button (GONE until installed; imports game to GameHub via $13)
# On build: checks bh_epic_prefs epic_installed_{appName} → if set, flips to installed state.
#
# Register map (.locals 15):
#   v0  = this$0 (EpicMainActivity)
#   v1  = appName String
#   v2  = density float
#   v3  = gameList LinearLayout
#   v4  = card root LinearLayout (HORIZONTAL)
#   v5  = GradientDrawable / LayoutParams (reused)
#   v6  = ImageView (left, 60dp square)
#   v7  = coverUrl String
#   v8  = right info LinearLayout (VERTICAL)
#   v9  = TextView (title, then checkmark, then statusTV — reused at different stages)
#   v10 = TextView (subtitle)
#   v11 = Add Button
#   v12 = ProgressBar / Launch Button / click-listener / $10 (reused across stages)
#   v13 = LayoutParams / click-listener / temp
#   v14 = float/int temp

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic appName:Ljava/lang/String;
.field final synthetic namespace:Ljava/lang/String;
.field final synthetic catalogItemId:Ljava/lang/String;
.field public val$coverUrl:Ljava/lang/String;
.field public displayTitle:Ljava/lang/String;

# Card widget refs — set in run(), read by $5/$11/$12/$13 via the card instance
.field public val$progressBar:Landroid/widget/ProgressBar;
.field public val$statusTV:Landroid/widget/TextView;
.field public val$checkTV:Landroid/widget/TextView;
.field public val$addBtn:Landroid/widget/Button;
.field public val$launchBtn:Landroid/widget/Button;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->appName:Ljava/lang/String;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->namespace:Ljava/lang/String;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->catalogItemId:Ljava/lang/String;
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

    # ── Load coverUrl into v7 ─────────────────────────────────────────────────
    iget-object v7, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$coverUrl:Ljava/lang/String;

    # ── Left: ImageView, 60dp × 60dp, dark bg, CENTER_CROP ───────────────────
    new-instance v6, Landroid/widget/ImageView;
    invoke-direct {v6, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    const v14, 0xFF333333
    invoke-virtual {v6, v14}, Landroid/view/View;->setBackgroundColor(I)V
    sget-object v13, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v6, v13}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V
    const/high16 v14, 0x42700000   # 60.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v13, v14, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v4, v6, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Right info panel: VERTICAL LinearLayout, weight=1 ────────────────────
    new-instance v8, Landroid/widget/LinearLayout;
    invoke-direct {v8, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v14, 0x1   # VERTICAL
    invoke-virtual {v8, v14}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/high16 v14, 0x41400000   # 12.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    const/4 v13, 0x0
    invoke-virtual {v8, v14, v13, v13, v13}, Landroid/widget/LinearLayout;->setPadding(IIII)V
    const/16 v14, 0x30   # Gravity.TOP = 48
    invoke-virtual {v8, v14}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/4 v13, 0x0   # 0dp width
    const/4 v14, -0x2  # WRAP_CONTENT
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v5, v13, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x3F800000   # 1.0f weight
    iput v14, v5, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v4, v8, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Title TextView (displayTitle, #F0F0F0, 15sp bold) ────────────────────
    new-instance v9, Landroid/widget/TextView;
    invoke-direct {v9, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    iget-object v10, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->displayTitle:Ljava/lang/String;
    invoke-virtual {v9, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFF0F0F0
    invoke-virtual {v9, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41700000   # 15.0f
    invoke-virtual {v9, v14}, Landroid/widget/TextView;->setTextSize(F)V
    sget-object v13, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;
    invoke-virtual {v9, v13}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V
    invoke-virtual {v8, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Subtitle TextView ("Epic Games", #888888, 13sp) ──────────────────────
    new-instance v10, Landroid/widget/TextView;
    invoke-direct {v10, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v13, "Epic Games"
    invoke-virtual {v10, v13}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFF888888
    invoke-virtual {v10, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41500000   # 13.0f
    invoke-virtual {v10, v14}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v8, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Checkmark TextView (✓, green #4CAF50, 20sp, GONE) ────────────────────
    new-instance v9, Landroid/widget/TextView;
    invoke-direct {v9, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v13, "\u2713"   # ✓
    invoke-virtual {v9, v13}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFF4CAF50   # green
    invoke-virtual {v9, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41A00000   # 20.0f
    invoke-virtual {v9, v14}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v14, 0x8   # GONE
    invoke-virtual {v9, v14}, Landroid/view/View;->setVisibility(I)V
    iput-object v9, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$checkTV:Landroid/widget/TextView;
    invoke-virtual {v8, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Install Button (WRAP_CONTENT × 40dp, gravity=END, white, "Install") ──────────
    new-instance v11, Landroid/widget/Button;
    invoke-direct {v11, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v13, "Install"
    invoke-virtual {v11, v13}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFFFFFFF
    invoke-virtual {v11, v14}, Landroid/widget/Button;->setTextColor(I)V
    const/high16 v14, 0x41400000   # 12.0f
    invoke-virtual {v11, v14}, Landroid/widget/TextView;->setTextSize(F)V
    iput-object v11, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$addBtn:Landroid/widget/Button;

    # Wire Add button → $5(activity, this-$2-instance)
    new-instance v13, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;
    invoke-direct {v13, v0, p0}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v11, v13}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # LP: WRAP_CONTENT × 40dp, gravity=END
    const/high16 v14, 0x42200000   # 40.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    const/4 v13, -0x2   # WRAP_CONTENT
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v5, v13, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const v14, 0x800005   # Gravity.END
    iput v14, v5, Landroid/widget/LinearLayout$LayoutParams;->gravity:I
    invoke-virtual {v8, v11, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── ProgressBar (GONE, horizontal) ───────────────────────────────────────
    new-instance v12, Landroid/widget/ProgressBar;
    const/4 v13, 0x0
    const v14, 0x1010078   # android.R.attr.progressBarStyleHorizontal
    invoke-direct {v12, v0, v13, v14}, Landroid/widget/ProgressBar;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    const/16 v13, 0x64   # max = 100
    invoke-virtual {v12, v13}, Landroid/widget/ProgressBar;->setMax(I)V
    const/16 v13, 0x8   # GONE
    invoke-virtual {v12, v13}, Landroid/view/View;->setVisibility(I)V
    iput-object v12, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$progressBar:Landroid/widget/ProgressBar;
    invoke-virtual {v8, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Status TextView (GONE, grey #888888, 10sp) ────────────────────────────
    new-instance v9, Landroid/widget/TextView;
    invoke-direct {v9, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const v14, 0xFF888888
    invoke-virtual {v9, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41200000   # 10.0f
    invoke-virtual {v9, v14}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v14, 0x8   # GONE
    invoke-virtual {v9, v14}, Landroid/view/View;->setVisibility(I)V
    iput-object v9, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$statusTV:Landroid/widget/TextView;
    invoke-virtual {v8, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Add Button (GONE until installed; "Add" adds game to GameHub via $13 → B3) ─────
    new-instance v12, Landroid/widget/Button;
    invoke-direct {v12, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v13, "Add"
    invoke-virtual {v12, v13}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFFFFFFF
    invoke-virtual {v12, v14}, Landroid/widget/Button;->setTextColor(I)V
    const/high16 v14, 0x41400000   # 12.0f
    invoke-virtual {v12, v14}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v14, 0x8   # GONE
    invoke-virtual {v12, v14}, Landroid/view/View;->setVisibility(I)V
    iput-object v12, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$launchBtn:Landroid/widget/Button;

    # Wire Launch button → $13(activity, this-$2-instance)
    new-instance v13, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;
    invoke-direct {v13, v0, p0}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v12, v13}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # LP: WRAP_CONTENT × 40dp, gravity=END
    const/high16 v14, 0x42200000   # 40.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    const/4 v13, -0x2   # WRAP_CONTENT
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v5, v13, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const v14, 0x800005   # Gravity.END
    iput v14, v5, Landroid/widget/LinearLayout$LayoutParams;->gravity:I
    invoke-virtual {v8, v12, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Add card to gameList ──────────────────────────────────────────────────
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Check installed state → flip visibilities ─────────────────────────────
    # Build key "epic_installed_{appName}"
    new-instance v12, Ljava/lang/StringBuilder;
    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V
    const-string v13, "epic_installed_"
    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v12, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v12   # key

    const-string v13, "bh_epic_prefs"
    const/4 v14, 0x0
    invoke-virtual {v0, v13, v14}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v13   # SharedPreferences

    const-string v14, ""
    invoke-interface {v13, v12, v14}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v12   # installDir or ""

    invoke-virtual {v12}, Ljava/lang/String;->isEmpty()Z
    move-result v13
    if-nez v13, :not_installed

    # Installed: hide Add, show checkmark + Launch (enabled)
    iget-object v12, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$addBtn:Landroid/widget/Button;
    const/16 v13, 0x8
    invoke-virtual {v12, v13}, Landroid/view/View;->setVisibility(I)V

    iget-object v12, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$checkTV:Landroid/widget/TextView;
    const/4 v13, 0x0
    invoke-virtual {v12, v13}, Landroid/view/View;->setVisibility(I)V

    iget-object v12, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$launchBtn:Landroid/widget/Button;
    const/4 v13, 0x0
    invoke-virtual {v12, v13}, Landroid/view/View;->setVisibility(I)V
    const/4 v13, 0x1
    invoke-virtual {v12, v13}, Landroid/view/View;->setEnabled(Z)V

    :not_installed

    # ── Launch thumbnail loader if coverUrl is available ──────────────────────
    if-eqz v7, :skip_thumb
    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z
    move-result v14
    if-nez v14, :skip_thumb

    new-instance v12, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10;
    invoke-direct {v12, v7, v6}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10;-><init>(Ljava/lang/String;Landroid/widget/ImageView;)V
    new-instance v13, Ljava/lang/Thread;
    invoke-direct {v13, v12}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v13}, Ljava/lang/Thread;->start()V

    :skip_thumb
    return-void
.end method
