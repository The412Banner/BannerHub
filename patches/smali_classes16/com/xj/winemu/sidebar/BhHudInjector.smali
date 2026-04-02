.class public Lcom/xj/winemu/sidebar/BhHudInjector;
.super Ljava/lang/Object;
.source "SourceFile"

# Called from WineActivity.onResume() to inject BhFrameRating / BhDetailedHud into DecorView.
# Logic:
#   winlator_hud=false              → both HUDs hidden
#   winlator_hud=true + extra=false → BhFrameRating visible, BhDetailedHud hidden
#   winlator_hud=true + extra=true  → BhFrameRating hidden, BhDetailedHud visible (created if needed)

# direct methods
.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# p0 = Activity (WineActivity)
.method public static injectOrUpdate(Landroid/app/Activity;)V
    .locals 11

    if-eqz p0, :done

    # v0 = DecorView (ViewGroup)
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;
    move-result-object v0
    if-eqz v0, :done
    check-cast v0, Landroid/view/ViewGroup;

    # v1 = SharedPreferences "bh_prefs"
    const-string v2, "bh_prefs"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1

    # v2 = winlator_hud pref
    const-string v3, "winlator_hud"
    const/4 v4, 0x0
    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2

    # v3 = hud_extra_detail pref
    const-string v4, "hud_extra_detail"
    const/4 v5, 0x0
    invoke-interface {v1, v4, v5}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3

    # ── BhFrameRating (normal HUD) ─────────────────────────────────────────

    # Find existing BhFrameRating by tag
    const-string v4, "bh_frame_rating"
    invoke-virtual {v0, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v4

    # Determine if normal HUD should be visible:
    #   winlator_hud=true AND hud_extra_detail=false
    if-eqz v2, :fr_should_hide
    if-nez v3, :fr_should_hide
    const/4 v5, 0x1         # should show
    goto :fr_vis_known
    :fr_should_hide
    const/4 v5, 0x0         # should hide
    :fr_vis_known

    if-nez v4, :fr_update

    # Not created yet — only create if it should be visible
    if-eqz v5, :fr_skip

    new-instance v6, Lcom/xj/winemu/sidebar/BhFrameRating;
    invoke-direct {v6, p0}, Lcom/xj/winemu/sidebar/BhFrameRating;-><init>(Landroid/content/Context;)V
    const-string v7, "bh_frame_rating"
    invoke-virtual {v6, v7}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    new-instance v7, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v8, -0x2
    const/16 v9, 0x35
    invoke-direct {v7, v8, v8, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V
    const/4 v8, 0x0
    invoke-virtual {v6, v8}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v0, v6, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    goto :fr_skip

    :fr_update
    if-eqz v5, :fr_gone
    const/4 v6, 0x0
    goto :fr_set_vis
    :fr_gone
    const/16 v6, 0x8
    :fr_set_vis
    invoke-virtual {v4, v6}, Landroid/view/View;->setVisibility(I)V

    :fr_skip

    # ── BhDetailedHud (extra detail HUD) ────────────────────────────────────

    # Find existing BhDetailedHud by tag
    const-string v4, "bh_detailed_hud"
    invoke-virtual {v0, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v4

    # Determine if detailed HUD should be visible:
    #   winlator_hud=true AND hud_extra_detail=true
    if-eqz v2, :dh_should_hide
    if-eqz v3, :dh_should_hide
    const/4 v5, 0x1
    goto :dh_vis_known
    :dh_should_hide
    const/4 v5, 0x0
    :dh_vis_known

    if-nez v4, :dh_update

    # Not created yet — only create if it should be visible
    if-eqz v5, :done

    new-instance v6, Lcom/xj/winemu/sidebar/BhDetailedHud;
    invoke-direct {v6, p0}, Lcom/xj/winemu/sidebar/BhDetailedHud;-><init>(Landroid/content/Context;)V
    const-string v7, "bh_detailed_hud"
    invoke-virtual {v6, v7}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    new-instance v7, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v8, -0x2
    const/16 v9, 0x35
    invoke-direct {v7, v8, v8, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V
    const/4 v8, 0x0
    invoke-virtual {v6, v8}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v0, v6, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    goto :done

    :dh_update
    if-eqz v5, :dh_gone
    const/4 v6, 0x0
    goto :dh_set_vis
    :dh_gone
    const/16 v6, 0x8
    :dh_set_vis
    invoke-virtual {v4, v6}, Landroid/view/View;->setVisibility(I)V

    :done
    return-void
.end method
