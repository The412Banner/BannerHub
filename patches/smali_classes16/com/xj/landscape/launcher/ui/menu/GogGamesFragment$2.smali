.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;
.super Ljava/lang/Object;

# BannerHub: UI-thread Runnable for GogGamesFragment.
# Receives the parsed list of GOG game titles from $1.
# Clears gameListLayout, adds a styled TextView per title,
# then shows scrollView and hides statusView.
# If the list is empty, shows "No GOG games found" in statusView.

.implements Ljava/lang/Runnable;

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
.field public final b:Ljava/util/ArrayList;  # game titles


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/util/ArrayList;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->b:Ljava/util/ArrayList;

    return-void
.end method


.method public run()V
    .locals 8

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->b:Ljava/util/ArrayList;

    # Null list = session expired (token was cleared by $1 after non-200 response)
    if-eqz v1, :session_expired

    # Check if list is empty
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v2

    if-nez v2, :has_games

    # No games — show message in statusView, keep scrollView gone
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

    # Get context for TextView creation
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v3
    if-eqz v3, :done

    # Clear existing children from gameListLayout
    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->gameListLayout:Landroid/widget/LinearLayout;
    if-eqz v4, :done
    invoke-virtual {v4}, Landroid/widget/LinearLayout;->removeAllViews()V

    # Iterate titles and add a TextView per title
    const/4 v5, 0x0  # i = 0

    :loop_start
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v6
    if-ge v5, v6, :loop_done

    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v6  # title string

    new-instance v7, Landroid/widget/TextView;
    invoke-direct {v7, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v7, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Text color 0xFFE0E0E0
    const v6, 0xFFE0E0E0
    invoke-virtual {v7, v6}, Landroid/widget/TextView;->setTextColor(I)V

    # Text size 15sp — setTextSize(float) uses SP units by default
    const/high16 v6, 0x41700000  # 15.0f
    invoke-virtual {v7, v6}, Landroid/widget/TextView;->setTextSize(F)V

    # Padding 32px on all sides
    const/16 v6, 0x20  # 32
    invoke-virtual {v7, v6, v6, v6, v6}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v4, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    add-int/lit8 v5, v5, 0x1
    goto :loop_start

    :loop_done

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
