.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: UI Runnable posted by $1 for each Epic game.
# Builds a GOG-style collapsible capsule card in EpicMainActivity.gameList:
#
#   [collapsed header — always visible]
#     ImageView (60dp cover art) | Title  ✓ ····· ▼
#
#   [expandSection — GONE by default, shown on card tap]
#     "Epic Games" subtitle
#     ✓ Installed (green, GONE unless installed)
#     ProgressBar (GONE during idle)
#     Status TextView (GONE during idle)
#     Install button  OR  Add to Launcher button
#
# Card tap (collapsed) → expand (collapse any other open card).
# Card tap (expanded)  → detail dialog (title, Platform, Uninstall if installed).
# Arrow tap            → collapse.
#
# Register map (.locals 15):
#   v0  = this$0 (EpicMainActivity)
#   v1  = appName String
#   v2  = density float
#   v3  = gameList LinearLayout
#   v4  = card root LinearLayout (VERTICAL) — permanent until end
#   v5  = reused: GradientDrawable, topRow, expandSection, LP, temp
#   v6  = reused: coverIV, titleArea, widget in expandSection, temp
#   v7  = reused: thread, titleRow, arrowTV, widget in expandSection, temp
#   v8  = reused: temp LP / widget
#   v9  = reused: temp
#   v10 = installed boolean (0=not installed, 1=installed) — kept from first pref check
#   v11 = reused: temp LP / spacer
#   v12 = reused: temp LP
#   v13 = reused: click listener / temp
#   v14 = reused: float/int temp for dp conversions

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic appName:Ljava/lang/String;
.field final synthetic namespace:Ljava/lang/String;
.field final synthetic catalogItemId:Ljava/lang/String;
.field public val$coverUrl:Ljava/lang/String;
.field public displayTitle:Ljava/lang/String;

# Card widget refs — set in run(), read by $5/$11/$12/$13/$14/$15/$16/$17
.field public val$progressBar:Landroid/widget/ProgressBar;
.field public val$statusTV:Landroid/widget/TextView;
.field public val$checkTV:Landroid/widget/TextView;
.field public val$addBtn:Landroid/widget/Button;
.field public val$launchBtn:Landroid/widget/Button;
.field public val$collapsedCheckTV:Landroid/widget/TextView;


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
    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->gameList:Landroid/widget/LinearLayout;

    # Display density
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v2
    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v2
    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    # ── Check installed state early (v10 = 1 if installed, 0 if not) ──────────
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V
    const-string v9, "epic_installed_"
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8   # key

    const-string v9, "bh_epic_prefs"
    const/4 v10, 0x0
    invoke-virtual {v0, v9, v10}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v9
    const-string v10, ""
    invoke-interface {v9, v8, v10}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9   # installDir or ""

    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z
    move-result v10   # v10 = 1 if NOT installed (pref empty)
    if-eqz v10, :pref_set   # pref non-empty → installed

    # Pref empty — fallback: check if dir exists
    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v8
    invoke-virtual {v8}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v8
    new-instance v9, Ljava/lang/StringBuilder;
    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v8, "/epic_games/"
    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v9, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8
    new-instance v9, Ljava/io/File;
    invoke-direct {v9, v8}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v9}, Ljava/io/File;->exists()Z
    move-result v10   # 1 if dir exists (installed), 0 if not
    goto :installed_check_done

    :pref_set
    const/4 v10, 0x1   # installed = true

    :installed_check_done
    # v10 = 1 if installed, 0 if not. Keep throughout run().

    # ── Card root (VERTICAL, rounded corners, dark #1A1A2E) ───────────────────
    new-instance v4, Landroid/widget/LinearLayout;
    invoke-direct {v4, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v14, 0x1
    invoke-virtual {v4, v14}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v5, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v5}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    const v14, 0xFF1A1A2E
    invoke-virtual {v5, v14}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/high16 v14, 0x41000000   # 8.0f (corner radius)
    mul-float v14, v2, v14
    invoke-virtual {v5, v14}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v4, v5}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # Card padding 10dp
    const/high16 v14, 0x41200000   # 10.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    invoke-virtual {v4, v14, v14, v14, v14}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # ── topRow (HORIZONTAL, CENTER_VERTICAL) ──────────────────────────────────
    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v14, 0x0
    invoke-virtual {v5, v14}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v14, 0x10   # Gravity.CENTER_VERTICAL
    invoke-virtual {v5, v14}, Landroid/widget/LinearLayout;->setGravity(I)V

    # coverIV (60dp square, CENTER_CROP, dark #333333 bg)
    new-instance v6, Landroid/widget/ImageView;
    invoke-direct {v6, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V
    const v14, 0xFF333333
    invoke-virtual {v6, v14}, Landroid/view/View;->setBackgroundColor(I)V
    sget-object v7, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v6, v7}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V
    const/high16 v14, 0x42700000   # 60.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v7, v14, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x41200000   # 10.0f (rightMargin)
    mul-float v14, v2, v14
    float-to-int v14, v14
    iput v14, v7, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I
    invoke-virtual {v5, v6, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Start cover art loader $10 if coverUrl non-empty
    iget-object v7, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$coverUrl:Ljava/lang/String;
    if-eqz v7, :no_cover
    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z
    move-result v8
    if-nez v8, :no_cover
    new-instance v8, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10;
    invoke-direct {v8, v7, v6}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10;-><init>(Ljava/lang/String;Landroid/widget/ImageView;)V
    new-instance v9, Ljava/lang/Thread;
    invoke-direct {v9, v8}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v9}, Ljava/lang/Thread;->start()V
    :no_cover
    # v6 = coverIV (captured by $10 or dropped), v7/v8/v9 freed

    # titleArea (VERTICAL LL, weight=1 in topRow)
    new-instance v6, Landroid/widget/LinearLayout;
    invoke-direct {v6, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v8, 0x1
    invoke-virtual {v6, v8}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/4 v7, 0x0    # 0dp width
    const/4 v8, -0x2   # WRAP_CONTENT height
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v9, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x3F800000   # 1.0f weight
    iput v14, v9, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v5, v6, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    # v5 = topRow (still needed for arrowTV), v6 = titleArea

    # titleRow (HORIZONTAL, CENTER_VERTICAL inside titleArea)
    new-instance v7, Landroid/widget/LinearLayout;
    invoke-direct {v7, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v8, 0x0
    invoke-virtual {v7, v8}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v8, 0x10
    invoke-virtual {v7, v8}, Landroid/widget/LinearLayout;->setGravity(I)V

    # titleTV (displayTitle, #F0F0F0, 15sp, bold, ellipsize)
    new-instance v8, Landroid/widget/TextView;
    invoke-direct {v8, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    iget-object v9, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->displayTitle:Ljava/lang/String;
    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFF0F0F0
    invoke-virtual {v8, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41700000   # 15.0f
    invoke-virtual {v8, v14}, Landroid/widget/TextView;->setTextSize(F)V
    sget-object v9, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;
    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V
    const/4 v9, 0x1
    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setMaxLines(I)V
    sget-object v9, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;
    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V
    invoke-virtual {v7, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    # v8, v9 freed

    # collapsedCheckTV " ✓" (green #4CAF50, 14sp; GONE unless installed)
    new-instance v8, Landroid/widget/TextView;
    invoke-direct {v8, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v9, " \u2713"
    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFF4CAF50
    invoke-virtual {v8, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41600000   # 14.0f
    invoke-virtual {v8, v14}, Landroid/widget/TextView;->setTextSize(F)V
    if-eqz v10, :ccTVgone
    const/4 v9, 0x0     # VISIBLE if installed
    goto :ccTVvis
    :ccTVgone
    const/16 v9, 0x8    # GONE if not installed
    :ccTVvis
    invoke-virtual {v8, v9}, Landroid/view/View;->setVisibility(I)V
    iput-object v8, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$collapsedCheckTV:Landroid/widget/TextView;
    invoke-virtual {v7, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    # v8, v9 freed

    # Spacer (weight=1 to push arrow to the right in titleRow)
    new-instance v8, Landroid/view/View;
    invoke-direct {v8, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    const/4 v9, 0x0
    new-instance v11, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v11, v9, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x3F800000   # 1.0f
    iput v14, v11, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v7, v8, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    # v8, v9, v11 freed

    # Add titleRow (v7) to titleArea (v6)
    invoke-virtual {v6, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    # v6, v7 freed

    # arrowTV "▼" (grey #888888, 14sp, leftPadding 8dp)
    new-instance v6, Landroid/widget/TextView;
    invoke-direct {v6, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v7, "\u25bc"
    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFF888888
    invoke-virtual {v6, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41600000   # 14.0f
    invoke-virtual {v6, v14}, Landroid/widget/TextView;->setTextSize(F)V
    const/high16 v14, 0x41000000   # 8.0f (leftPadding)
    mul-float v14, v2, v14
    float-to-int v14, v14
    const/4 v7, 0x0
    invoke-virtual {v6, v14, v7, v7, v7}, Landroid/widget/TextView;->setPadding(IIII)V
    # Store arrowTV field before adding (needed by $14 and $15 constructors later)
    # We will iput it after building expandSection so we have both refs for click wiring.
    # Keep v6 = arrowTV for now.
    invoke-virtual {v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V   # topRow.addView(arrowTV)

    # Add topRow (v5) to card (v4)
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    # v5 freed; v6 = arrowTV (keep for field iput + click listener)

    # ── expandSection (VERTICAL, GONE by default) ─────────────────────────────
    new-instance v5, Landroid/widget/LinearLayout;
    invoke-direct {v5, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v7, 0x1
    invoke-virtual {v5, v7}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v7, 0x8
    invoke-virtual {v5, v7}, Landroid/view/View;->setVisibility(I)V

    # Subtitle "Epic Games" (grey #888888, 11sp, topMargin 6dp)
    new-instance v7, Landroid/widget/TextView;
    invoke-direct {v7, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v8, "Epic Games"
    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFF888888
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41300000   # 11.0f
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextSize(F)V
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v9, -0x1
    const/4 v11, -0x2
    invoke-direct {v8, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x40C00000   # 6.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    iput v14, v8, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    invoke-virtual {v5, v7, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    # v7, v8, v9, v11 freed

    # checkTV "✓ Installed" (green #4CAF50, 10sp, GONE unless installed)
    new-instance v7, Landroid/widget/TextView;
    invoke-direct {v7, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v8, "\u2713 Installed"
    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFF4CAF50
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41200000   # 10.0f
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextSize(F)V
    if-eqz v10, :ckgone
    const/4 v8, 0x0
    goto :ckvis
    :ckgone
    const/16 v8, 0x8
    :ckvis
    invoke-virtual {v7, v8}, Landroid/view/View;->setVisibility(I)V
    iput-object v7, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$checkTV:Landroid/widget/TextView;
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v9, -0x1
    const/4 v11, -0x2
    invoke-direct {v8, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x40800000   # 4.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    iput v14, v8, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    invoke-virtual {v5, v7, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    # v7, v8, v9, v11 freed

    # progressBar (GONE, horizontal, topMargin 6dp)
    new-instance v7, Landroid/widget/ProgressBar;
    const/4 v8, 0x0
    const v9, 0x1010078   # android.R.attr.progressBarStyleHorizontal
    invoke-direct {v7, v0, v8, v9}, Landroid/widget/ProgressBar;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    const/16 v8, 0x64
    invoke-virtual {v7, v8}, Landroid/widget/ProgressBar;->setMax(I)V
    const/16 v8, 0x8
    invoke-virtual {v7, v8}, Landroid/view/View;->setVisibility(I)V
    iput-object v7, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$progressBar:Landroid/widget/ProgressBar;
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v9, -0x1
    const/high16 v14, 0x40C00000   # 6.0f height
    mul-float v14, v2, v14
    float-to-int v14, v14
    invoke-direct {v8, v9, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x40C00000   # 6.0f topMargin
    mul-float v14, v2, v14
    float-to-int v14, v14
    iput v14, v8, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    invoke-virtual {v5, v7, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    # v7, v8, v9 freed

    # statusTV (grey #888888, 11sp, GONE)
    new-instance v7, Landroid/widget/TextView;
    invoke-direct {v7, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const v14, 0xFF888888
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41300000   # 11.0f
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v8, 0x8
    invoke-virtual {v7, v8}, Landroid/view/View;->setVisibility(I)V
    iput-object v7, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$statusTV:Landroid/widget/TextView;
    invoke-virtual {v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    # v7, v8 freed

    # addBtn "Install" (MATCH_PARENT × 40dp, topMargin 8dp; GONE if installed, VISIBLE if not)
    new-instance v7, Landroid/widget/Button;
    invoke-direct {v7, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v8, "Install"
    invoke-virtual {v7, v8}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFFFFFFF
    invoke-virtual {v7, v14}, Landroid/widget/Button;->setTextColor(I)V
    const/high16 v14, 0x41400000   # 12.0f
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextSize(F)V
    if-nez v10, :addbtngone
    const/4 v8, 0x0     # not installed → VISIBLE
    goto :addbtnvis
    :addbtngone
    const/16 v8, 0x8    # installed → GONE
    :addbtnvis
    invoke-virtual {v7, v8}, Landroid/view/View;->setVisibility(I)V
    iput-object v7, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$addBtn:Landroid/widget/Button;
    new-instance v8, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;
    invoke-direct {v8, v0, p0}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v7, v8}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    const/4 v8, -0x1   # MATCH_PARENT
    const/high16 v14, 0x42200000   # 40.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v9, v8, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x41000000   # 8.0f topMargin
    mul-float v14, v2, v14
    float-to-int v14, v14
    iput v14, v9, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    invoke-virtual {v5, v7, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    # v7, v8, v9 freed

    # launchBtn "Add to Launcher" (MATCH_PARENT × 40dp, topMargin 4dp; VISIBLE if installed, GONE if not)
    new-instance v7, Landroid/widget/Button;
    invoke-direct {v7, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v8, "Add to Launcher"
    invoke-virtual {v7, v8}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFFFFFFF
    invoke-virtual {v7, v14}, Landroid/widget/Button;->setTextColor(I)V
    const/high16 v14, 0x41400000   # 12.0f
    invoke-virtual {v7, v14}, Landroid/widget/TextView;->setTextSize(F)V
    if-eqz v10, :launchgone
    const/4 v8, 0x0     # installed → VISIBLE
    goto :launchvis
    :launchgone
    const/16 v8, 0x8    # not installed → GONE
    :launchvis
    invoke-virtual {v7, v8}, Landroid/view/View;->setVisibility(I)V
    const/4 v8, 0x1
    invoke-virtual {v7, v8}, Landroid/view/View;->setEnabled(Z)V
    iput-object v7, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$launchBtn:Landroid/widget/Button;
    new-instance v8, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;
    invoke-direct {v8, v0, p0}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v7, v8}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    const/4 v8, -0x1   # MATCH_PARENT
    const/high16 v14, 0x42200000   # 40.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v9, v8, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v14, 0x40800000   # 4.0f topMargin
    mul-float v14, v2, v14
    float-to-int v14, v14
    iput v14, v9, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I
    invoke-virtual {v5, v7, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    # v5=expandSection, v6=arrowTV, v7/v8/v9/v10/v11 freed

    # iput expandSection and arrowTV fields (needed by click listeners)
    # (note: v5=expandSection, v6=arrowTV are still in registers)
    # Store both fields
    # expandSection is v5; we need to iput it but $14/$15 constructors need it as arg.
    # Wire arrow click listener ($15)
    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$15;
    invoke-direct {v7, v0, v5, v6}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$15;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Landroid/widget/LinearLayout;Landroid/widget/TextView;)V
    invoke-virtual {v6, v7}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    # v7 freed

    # Wire card click listener ($14)
    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;
    invoke-direct {v7, v0, p0, v5, v6}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;Landroid/widget/LinearLayout;Landroid/widget/TextView;)V
    invoke-virtual {v4, v7}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    # v5, v6, v7 freed

    # Add expandSection (we need it again — load from $14's stored field? No, we still have it... wait, v5 was freed above)
    # Actually v5 was NOT freed — it was used in $14/$15 constructors but not overwritten.
    # Let me re-read: after launchBtn addView, "v5=expandSection, v6=arrowTV, v7/v8/v9 freed"
    # Then we create $15 using {v7, v0, v5, v6} — v7 is new $15 instance, v5/v6 passed as args (not freed)
    # Then $14 uses {v7, v0, p0, v5, v6} — same.
    # So v5 (expandSection) is still valid. Good.
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    # v5 freed now

    # ── Add card to gameList with 8dp bottom margin ───────────────────────────
    const/high16 v14, 0x41000000   # 8.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    const/4 v5, -0x1   # MATCH_PARENT
    const/4 v6, -0x2   # WRAP_CONTENT
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v7, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    iput v14, v7, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I
    invoke-virtual {v3, v4, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-void
.end method
