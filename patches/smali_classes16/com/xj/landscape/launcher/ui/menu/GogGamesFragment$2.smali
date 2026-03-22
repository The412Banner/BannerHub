.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;
.super Ljava/lang/Object;

# BannerHub: UI-thread Runnable for GogGamesFragment.
# Receives ArrayList<GogGame> from $1 and builds a card list:
#   Each card = horizontal LinearLayout (dark rounded bg)
#     Left: ImageView 60dp×60dp (thumbnail, loaded async by $4)
#     Right: vertical LinearLayout
#       - Title TextView (white, 15sp, bold)
#       - Meta TextView (grey, 13sp): "Category · Developer"
#   Tap on card opens GogGamesFragment$3 detail dialog.
# Null list = session expired. Empty list = no games.

.implements Ljava/lang/Runnable;

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
.field public final b:Ljava/util/ArrayList;  # ArrayList<GogGame>


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/util/ArrayList;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->b:Ljava/util/ArrayList;

    return-void
.end method


.method public run()V
    .locals 17

    # p0 = v17 with .locals 17 — too high for iget-object (4-bit limit).
    # Move this into v14 (free at start of method) for the two field reads.
    # v16 is now a free local used to hold the checkmark TextView (persistent).
    move-object/from16 v14, p0
    iget-object v0, v14, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iget-object v1, v14, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->b:Ljava/util/ArrayList;

    # Null = session expired (token cleared by $1 after non-200 response)
    if-eqz v1, :session_expired

    # Empty = no games in library
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v2
    if-nez v2, :has_games

    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->statusView:Landroid/widget/TextView;
    if-eqz v3, :done
    const-string v4, "No GOG games found"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/4 v4, 0x0  # VISIBLE
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V
    goto :done

    :session_expired
    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->statusView:Landroid/widget/TextView;
    if-eqz v3, :done
    const-string v4, "Session expired - sign in again via the GOG side menu"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/4 v4, 0x0  # VISIBLE
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V
    goto :done

    :has_games

    # Get context
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v3
    if-eqz v3, :done

    # Get gameListLayout, clear existing children
    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->gameListLayout:Landroid/widget/LinearLayout;
    if-eqz v4, :done
    invoke-virtual {v4}, Landroid/widget/LinearLayout;->removeAllViews()V

    # v2 = display density float (stored for dp→px throughout loop)
    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v2
    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v2
    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    # Loop: v5 = i
    const/4 v5, 0x0

    :loop_start
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v14
    if-ge v5, v14, :loop_done

    # v6 = GogGame
    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v6
    check-cast v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;

    # ── Card root: horizontal LinearLayout ───────────────────────────────────
    new-instance v7, Landroid/widget/LinearLayout;
    invoke-direct {v7, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v14, 0x0  # HORIZONTAL
    invoke-virtual {v7, v14}, Landroid/widget/LinearLayout;->setOrientation(I)V

    # Rounded dark background via GradientDrawable
    new-instance v12, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v12}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    const v14, 0xFF1A1A1A
    invoke-virtual {v12, v14}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    # corner radius = 10dp (float, not converted to int)
    const/high16 v14, 0x41200000  # 10.0f
    mul-float v14, v2, v14
    invoke-virtual {v12, v14}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v7, v12}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # Card padding: 12dp all sides
    const/high16 v14, 0x41400000  # 12.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    invoke-virtual {v7, v14, v14, v14, v14}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Make card clickable + focusable (focusable enables D-pad/controller navigation)
    const/4 v14, 0x1
    invoke-virtual {v7, v14}, Landroid/view/View;->setClickable(Z)V
    invoke-virtual {v7, v14}, Landroid/view/View;->setFocusable(Z)V

    # Touch ripple foreground (selectableItemBackground resolved from theme)
    # Guard: resolveAttribute may return resourceId=0 on some themes/ROMs
    # — getDrawable(0) would throw Resources$NotFoundException
    new-instance v12, Landroid/util/TypedValue;
    invoke-direct {v12}, Landroid/util/TypedValue;-><init>()V
    invoke-virtual {v3}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;
    move-result-object v13
    const v14, 0x0101009d  # android.R.attr.selectableItemBackground
    const/4 v15, 0x1
    invoke-virtual {v13, v14, v12, v15}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z
    move-result v14  # true if attribute was resolved
    if-eqz v14, :skip_ripple
    iget v13, v12, Landroid/util/TypedValue;->resourceId:I
    if-eqz v13, :skip_ripple  # 0 = resolved as data/color, not a resource ID
    invoke-virtual {v3, v13}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;
    move-result-object v13
    if-eqz v13, :skip_ripple
    invoke-virtual {v7, v13}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V
    :skip_ripple

    # ── Thumbnail ImageView (60dp × 60dp) ────────────────────────────────────
    new-instance v8, Landroid/widget/ImageView;
    invoke-direct {v8, v3}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    const v14, 0xFF333333  # placeholder grey (visible against #1A1A1A card bg)
    invoke-virtual {v8, v14}, Landroid/view/View;->setBackgroundColor(I)V

    sget-object v14, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v8, v14}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    # Fixed LP: 78dp × 78dp (60dp × 1.3 — card 30% taller)
    const/high16 v14, 0x429C0000  # 78.0f
    mul-float v14, v2, v14
    float-to-int v14, v14

    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v13, v14, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v7, v8, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Launch $4 thumbnail loader
    iget-object v15, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->imageUrl:Ljava/lang/String;
    if-eqz v15, :skip_thumb

    new-instance v12, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$4;
    invoke-direct {v12, v15, v8}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$4;-><init>(Ljava/lang/String;Landroid/widget/ImageView;)V
    new-instance v15, Ljava/lang/Thread;
    invoke-direct {v15, v12}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v15}, Ljava/lang/Thread;->start()V

    :skip_thumb

    # ── Right info LinearLayout (vertical) ───────────────────────────────────
    new-instance v9, Landroid/widget/LinearLayout;
    invoke-direct {v9, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v14, 0x1  # VERTICAL
    invoke-virtual {v9, v14}, Landroid/widget/LinearLayout;->setOrientation(I)V

    # Left padding = 12dp (gap between image and text)
    const/high16 v14, 0x41400000  # 12.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    const/4 v15, 0x0
    invoke-virtual {v9, v14, v15, v15, v15}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Align content to top — button row + ProgressBar added below title/meta
    const/16 v14, 0x30  # Gravity.TOP
    invoke-virtual {v9, v14}, Landroid/widget/LinearLayout;->setGravity(I)V

    # ── Title TextView ────────────────────────────────────────────────────────
    new-instance v10, Landroid/widget/TextView;
    invoke-direct {v10, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iget-object v15, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->title:Ljava/lang/String;
    if-eqz v15, :no_title
    invoke-virtual {v10, v15}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :no_title

    const v15, 0xFFF0F0F0
    invoke-virtual {v10, v15}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v15, 0x41700000  # 15.0f
    invoke-virtual {v10, v15}, Landroid/widget/TextView;->setTextSize(F)V

    sget-object v15, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;
    invoke-virtual {v10, v15}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-virtual {v9, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Meta string: "Category · Developer" ──────────────────────────────────
    new-instance v12, Ljava/lang/StringBuilder;
    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v14, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->category:Ljava/lang/String;
    if-eqz v14, :meta_no_cat
    invoke-virtual {v12, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :meta_no_cat

    iget-object v14, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->developer:Ljava/lang/String;
    if-eqz v14, :meta_no_dev
    const-string v15, " · "
    invoke-virtual {v12, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v12, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :meta_no_dev

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v14  # v14 = meta string

    # ── Meta TextView ─────────────────────────────────────────────────────────
    new-instance v11, Landroid/widget/TextView;
    invoke-direct {v11, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v11, v14}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v15, 0xFF888888
    invoke-virtual {v11, v15}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v15, 0x41500000  # 13.0f
    invoke-virtual {v11, v15}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v9, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Installed checkmark ("✓ Installed", green 10sp) ─────────────────────────
    # Always created in v13 (4-bit); persisted in v16 via move-object/from16
    # (8-bit dest is valid). v16 is then passed to $6 via range {v10..v16}.
    new-instance v13, Landroid/widget/TextView;
    invoke-direct {v13, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v15, "✓ Installed"
    invoke-virtual {v13, v15}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v15, 0xFF4CAF50
    invoke-virtual {v13, v15}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v15, 0x41200000  # 10.0f sp
    invoke-virtual {v13, v15}, Landroid/widget/TextView;->setTextSize(F)V

    # Persist ref in v16 (move-object/from16: 8-bit dest v16, 16-bit src v13)
    move-object/from16 v16, v13

    # Default GONE (v13 still = checkmark)
    const/16 v15, 0x8
    invoke-virtual {v13, v15}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v9, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Check if already installed → flip to VISIBLE
    iget-object v14, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->gameId:Ljava/lang/String;
    if-eqz v14, :ck_done  # no gameId → stays GONE

    new-instance v13, Ljava/lang/StringBuilder;
    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V
    const-string v15, "gog_exe_"
    invoke-virtual {v13, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v14  # "gog_exe_{gameId}"

    const-string v15, "bh_gog_prefs"
    const/4 v13, 0x0
    invoke-virtual {v3, v15, v13}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v15  # SP

    const-string v13, ""
    invoke-interface {v15, v14, v13}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v13  # pref value

    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z
    move-result v13
    if-nez v13, :ck_done  # empty = not installed → stays GONE

    # Already installed → reload checkmark and set VISIBLE
    move-object/from16 v13, v16  # v13 = checkmark ref (from v16)
    const/4 v15, 0x0  # VISIBLE
    invoke-virtual {v13, v15}, Landroid/view/View;->setVisibility(I)V

    :ck_done

    # ── Gen 1 / Gen 2 badge (10sp, orange=Gen1, blue=Gen2, skip if 0=unknown) ──
    iget-object v13, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->gameId:Ljava/lang/String;
    if-eqz v13, :gen_badge_done

    new-instance v14, Ljava/lang/StringBuilder;
    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V
    const-string v15, "gog_gen_"
    invoke-virtual {v14, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v13

    const-string v14, "bh_gog_prefs"
    const/4 v15, 0x0
    invoke-virtual {v3, v14, v15}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v14

    const/4 v15, 0x0
    invoke-interface {v14, v13, v15}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v13  # 0=unknown, 1=Gen1, 2=Gen2

    if-eqz v13, :gen_badge_done  # 0 = not yet synced, skip

    new-instance v11, Landroid/widget/TextView;
    invoke-direct {v11, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const/4 v14, 0x2
    if-ne v13, v14, :gen_badge_1
    const-string v14, "Gen 2"
    const v15, 0xFF4FC3F7  # light blue
    goto :gen_badge_set

    :gen_badge_1
    const-string v14, "Gen 1"
    const v15, 0xFFFF9800  # orange

    :gen_badge_set
    invoke-virtual {v11, v14}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v11, v15}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v15, 0x41200000  # 10.0f sp
    invoke-virtual {v11, v15}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v9, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :gen_badge_done

    # ── Install Button (VISIBLE — full width in right section) ────────────────
    new-instance v8, Landroid/widget/Button;
    invoke-direct {v8, v3}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v14, "Install"
    invoke-virtual {v8, v14}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFFFFFFF  # white text
    invoke-virtual {v8, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41400000  # 12.0f sp (default ~14-15sp, 20% smaller)
    invoke-virtual {v8, v14}, Landroid/widget/TextView;->setTextSize(F)V
    # LP(WRAP_CONTENT, 40dp, gravity=END) — right-aligned compact button
    const/high16 v14, 0x42200000  # 40.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v15, -0x2  # WRAP_CONTENT
    invoke-direct {v13, v15, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const v15, 0x800005  # Gravity.END
    iput v15, v13, Landroid/widget/LinearLayout$LayoutParams;->gravity:I
    invoke-virtual {v9, v8, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── ProgressBar (GONE — shown during download, horizontal style) ──────────
    new-instance v10, Landroid/widget/ProgressBar;
    const/4 v14, 0x0           # null AttributeSet
    const v15, 0x1010078       # android.R.attr.progressBarStyleHorizontal
    invoke-direct {v10, v3, v14, v15}, Landroid/widget/ProgressBar;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    const/16 v14, 0x64  # max = 100
    invoke-virtual {v10, v14}, Landroid/widget/ProgressBar;->setMax(I)V
    const/16 v14, 0x8  # GONE
    invoke-virtual {v10, v14}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v9, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Status TextView (GONE — shows step text during download) ──────────────
    new-instance v11, Landroid/widget/TextView;
    invoke-direct {v11, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const v14, 0xFF888888  # grey text
    invoke-virtual {v11, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41200000  # 10.0f sp
    invoke-virtual {v11, v14}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v14, 0x8  # GONE
    invoke-virtual {v11, v14}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v9, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Launch Button (GONE — shown + enabled by GogDownloadManager$3 at 100%) ─
    new-instance v12, Landroid/widget/Button;
    invoke-direct {v12, v3}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v14, "Launch"
    invoke-virtual {v12, v14}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v14, 0xFFFFFFFF  # white text
    invoke-virtual {v12, v14}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v14, 0x41400000  # 12.0f sp
    invoke-virtual {v12, v14}, Landroid/widget/TextView;->setTextSize(F)V

    # Check gog_exe_{gameId} → show+enable Launch if already installed
    iget-object v13, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->gameId:Ljava/lang/String;
    if-eqz v13, :launch_gone

    new-instance v15, Ljava/lang/StringBuilder;
    invoke-direct {v15}, Ljava/lang/StringBuilder;-><init>()V
    const-string v14, "gog_exe_"
    invoke-virtual {v15, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v15, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v13

    const-string v14, "bh_gog_prefs"
    const/4 v15, 0x0
    invoke-virtual {v3, v14, v15}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v14

    const-string v15, ""
    invoke-interface {v14, v13, v15}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z
    move-result v13
    if-nez v13, :launch_gone

    # Already installed: show + enable Launch, hide Install button
    const/4 v13, 0x0  # VISIBLE
    invoke-virtual {v12, v13}, Landroid/view/View;->setVisibility(I)V
    const/4 v13, 0x1
    invoke-virtual {v12, v13}, Landroid/view/View;->setEnabled(Z)V
    const/16 v13, 0x8  # GONE
    invoke-virtual {v8, v13}, Landroid/view/View;->setVisibility(I)V
    goto :set_launch_click

    :launch_gone
    const/16 v13, 0x8  # GONE
    invoke-virtual {v12, v13}, Landroid/view/View;->setVisibility(I)V

    :set_launch_click
    new-instance v13, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$7;
    invoke-direct {v13, v3, v6}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$7;-><init>(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    invoke-virtual {v12, v13}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    # LP(WRAP_CONTENT, 40dp, gravity=END) for Launch button
    const/high16 v14, 0x42200000  # 40.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v15, -0x2  # WRAP_CONTENT
    invoke-direct {v13, v15, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const v15, 0x800005  # Gravity.END
    iput v15, v13, Landroid/widget/LinearLayout$LayoutParams;->gravity:I
    invoke-virtual {v9, v12, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Wire Install button click → $6 (shows size dialog) ───────────────────
    # $6.<init> needs 7 consecutive regs. v10=bar, v11=statusTV, v12=launchBtn.
    # Save them to v13/v14/v15, place new-instance at v10, ctx/game at v11/v12.
    # v16=checkmark TextView (persistent from checkmark block above).
    move-object v13, v10   # save ProgressBar
    move-object v14, v11   # save statusTV
    move-object v15, v12   # save Launch Button
    new-instance v10, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;
    move-object v11, v3    # Context
    move-object v12, v6    # GogGame
    # v13=ProgressBar, v14=statusTV, v15=LaunchButton, v16=checkmark
    invoke-direct/range {v10 .. v16}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;-><init>(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;Landroid/widget/ProgressBar;Landroid/widget/TextView;Landroid/widget/Button;Landroid/widget/TextView;)V
    invoke-virtual {v8, v10}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # ── Add right layout to card with weight=1 ────────────────────────────────
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v14, 0x0    # width = 0 (weight-driven)
    const/4 v15, -0x2   # height = WRAP_CONTENT (adapts to all card content)
    const/high16 v12, 0x3f800000  # weight = 1.0f
    invoke-direct {v13, v14, v15, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v7, v9, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Click listener: $3 takes GogGame, opens detail dialog ────────────────
    new-instance v12, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;
    invoke-direct {v12, v0, v6}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    invoke-virtual {v7, v12}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # ── Outer LP: MATCH_PARENT × WRAP_CONTENT + margins 12/6dp ──────────────
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v14, -0x1   # MATCH_PARENT
    const/4 v15, -0x2   # WRAP_CONTENT
    invoke-direct {v13, v14, v15}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    # margins: left=12dp, top=6dp, right=12dp, bottom=6dp
    const/high16 v14, 0x41400000  # 12.0f
    mul-float v14, v2, v14
    float-to-int v14, v14  # v14 = 12dp px

    const/high16 v15, 0x40C00000  # 6.0f
    mul-float v15, v2, v15
    float-to-int v15, v15  # v15 = 6dp px

    invoke-virtual {v13, v14, v15, v14, v15}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v4, v7, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    add-int/lit8 v5, v5, 0x1
    goto :loop_start

    :loop_done

    # Establish initial focus on first card so D-pad/controller navigation can start.
    # ScrollView.arrowScroll() only moves focus if findFocus() is non-null —
    # without this, the first D-pad press has no anchor and just scrolls.
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;
    move-result-object v5
    if-eqz v5, :focus_done
    invoke-virtual {v5}, Landroid/view/View;->requestFocus()Z
    :focus_done

    # Hide statusView, show scrollView
    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->statusView:Landroid/widget/TextView;
    if-eqz v5, :show_scroll
    const/16 v6, 0x8  # GONE
    invoke-virtual {v5, v6}, Landroid/view/View;->setVisibility(I)V

    :show_scroll
    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->scrollView:Landroid/widget/ScrollView;
    if-eqz v5, :done
    const/4 v6, 0x0  # VISIBLE
    invoke-virtual {v5, v6}, Landroid/view/View;->setVisibility(I)V

    :done
    return-void
.end method
