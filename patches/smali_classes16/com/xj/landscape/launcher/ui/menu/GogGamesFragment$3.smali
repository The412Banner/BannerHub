.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;
.super Ljava/lang/Object;

# BannerHub: OnClickListener for each game card in GogGamesFragment.
# Shows an AlertDialog with:
#   - cover art ImageView (200dp height, loaded async by GogGamesFragment$4)
#   - info TextView: Genre, Developer
#   - description TextView (Html.fromHtml, max 5 lines, shown if non-null)
#   - store URL TextView (blue)
# Dialog title is set to the game title via AlertDialog.Builder.setTitle().

.implements Landroid/view/View$OnClickListener;

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
.field public final b:Lcom/xj/landscape/launcher/ui/menu/GogGame;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 11

    # v0 = context
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v0
    if-eqz v0, :done

    # v1 = GogGame
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    # v8 = display density float (used throughout for dp→px)
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v7
    invoke-virtual {v7}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v7
    iget v8, v7, Landroid/util/DisplayMetrics;->density:F

    # ── Root LinearLayout (vertical, dark bg) ────────────────────────────────
    new-instance v2, Landroid/widget/LinearLayout;
    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v7, 0x1  # VERTICAL
    invoke-virtual {v2, v7}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const v7, 0xFF0D0D0D
    invoke-virtual {v2, v7}, Landroid/view/View;->setBackgroundColor(I)V

    # ── Game title TextView (inside dark view — no AlertDialog system title bar) ──
    new-instance v4, Landroid/widget/TextView;
    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->title:Ljava/lang/String;
    if-eqz v9, :no_dialog_title_tv
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :no_dialog_title_tv

    const v9, 0xFFFFFFFF
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v9, 0x41900000  # 18.0f sp
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setTextSize(F)V

    sget-object v9, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/high16 v9, 0x41800000  # 16.0f
    mul-float v9, v8, v9
    float-to-int v9, v9  # 16dp px

    const/high16 v10, 0x41000000  # 8.0f
    mul-float v10, v8, v10
    float-to-int v10, v10  # 8dp px

    invoke-virtual {v4, v9, v9, v9, v10}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Cover art ImageView (MATCH_PARENT × 200dp) ───────────────────────────
    new-instance v3, Landroid/widget/ImageView;
    invoke-direct {v3, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    const v7, 0xFF1A1A1A  # placeholder bg
    invoke-virtual {v3, v7}, Landroid/view/View;->setBackgroundColor(I)V

    sget-object v7, Landroid/widget/ImageView$ScaleType;->FIT_CENTER:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v3, v7}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    # LP: MATCH_PARENT × 200dp
    const/high16 v7, 0x43480000  # 200.0f
    mul-float v7, v8, v7
    float-to-int v7, v7  # v7 = 200dp in px

    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v10, -0x1  # MATCH_PARENT
    invoke-direct {v9, v10, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v2, v3, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Start async cover art loader ($4)
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->imageUrl:Ljava/lang/String;
    if-eqz v9, :skip_cover_load

    new-instance v10, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$4;
    invoke-direct {v10, v9, v3}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$4;-><init>(Ljava/lang/String;Landroid/widget/ImageView;)V
    new-instance v9, Ljava/lang/Thread;
    invoke-direct {v9, v10}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v9}, Ljava/lang/Thread;->start()V

    :skip_cover_load

    # ── Info TextView (genre, developer) ─────────────────────────────────────
    # Build info string with StringBuilder
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    # Genre
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->category:Ljava/lang/String;
    if-eqz v9, :info_no_genre
    const-string v10, "Genre: "
    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :info_no_genre

    # Developer
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->developer:Ljava/lang/String;
    if-eqz v9, :info_no_dev
    const-string v10, "\nDeveloper: "
    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :info_no_dev

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v9  # v9 = info string

    new-instance v4, Landroid/widget/TextView;
    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v9, 0xFFCCCCCC
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v9, 0x41600000  # 14.0f
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setTextSize(F)V

    # Padding: 16dp H, 10dp V
    const/high16 v9, 0x41800000  # 16.0f
    mul-float v9, v8, v9
    float-to-int v9, v9  # v9 = 16dp px

    const/high16 v10, 0x41200000  # 10.0f
    mul-float v10, v8, v10
    float-to-int v10, v10  # v10 = 10dp px

    invoke-virtual {v4, v9, v10, v9, v10}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Description TextView (optional, Html.fromHtml rendered) ──────────────
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->description:Ljava/lang/String;
    if-eqz v9, :skip_desc

    new-instance v4, Landroid/widget/TextView;
    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    # Render HTML markup (API 24+ two-arg form; minSdk=29 so safe)
    const/4 v10, 0x0
    invoke-static {v9, v10}, Landroid/text/Html;->fromHtml(Ljava/lang/String;I)Landroid/text/Spanned;
    move-result-object v9
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v9, 0xFFAAAAAA
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v9, 0x41400000  # 12.0f sp
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 v9, 0x5  # max 5 lines
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setMaxLines(I)V

    # Padding: 16dp H, 8dp V
    const/high16 v9, 0x41800000  # 16.0f
    mul-float v9, v8, v9
    float-to-int v9, v9
    const/high16 v10, 0x41000000  # 8.0f
    mul-float v10, v8, v10
    float-to-int v10, v10
    invoke-virtual {v4, v9, v10, v9, v10}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :skip_desc

    # ── Store URL TextView ────────────────────────────────────────────────────
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->storeUrl:Ljava/lang/String;
    if-eqz v9, :skip_store

    move-object v6, v9  # save storeUrl before v9 gets overwritten by color/padding temps

    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v5, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v9, 0xFF5B9BD5  # blue
    invoke-virtual {v5, v9}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v9, 0x41400000  # 12.0f
    invoke-virtual {v5, v9}, Landroid/widget/TextView;->setTextSize(F)V

    const/high16 v9, 0x41800000  # 16dp
    mul-float v9, v8, v9
    float-to-int v9, v9
    const/high16 v10, 0x41000000  # 8dp
    mul-float v10, v8, v10
    float-to-int v10, v10

    invoke-virtual {v5, v9, v10, v9, v10}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v2, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Make store URL tappable — opens in browser
    new-instance v9, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$5;
    invoke-direct {v9, v0, v6}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$5;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    invoke-virtual {v5, v9}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    const/4 v9, 0x1
    invoke-virtual {v5, v9}, Landroid/view/View;->setClickable(Z)V

    :skip_store

    # ── AlertDialog ───────────────────────────────────────────────────────────
    new-instance v6, Landroid/app/AlertDialog$Builder;
    invoke-direct {v6, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    invoke-virtual {v6, v2}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    const-string v9, "Close"
    const/4 v10, 0x0
    invoke-virtual {v6, v9, v10}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    # Install button (always shown — negative = left)
    new-instance v9, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;
    invoke-direct {v9, v0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;-><init>(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    const-string v10, "Install"
    invoke-virtual {v6, v10, v9}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    # Launch button (always shown — neutral = far left)
    new-instance v9, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$7;
    invoke-direct {v9, v0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$7;-><init>(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    const-string v10, "Launch"
    invoke-virtual {v6, v10, v9}, Landroid/app/AlertDialog$Builder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v6}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    :done
    return-void
.end method
