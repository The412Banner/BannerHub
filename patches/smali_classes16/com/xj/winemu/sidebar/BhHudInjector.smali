.class public Lcom/xj/winemu/sidebar/BhHudInjector;
.super Ljava/lang/Object;
.source "SourceFile"

# Called from WineActivity.onResume() to inject BhFrameRating into DecorView
# without requiring the sidebar to be opened first.
# Also called implicitly from BhPerfSetupDelegate.onAttachedToWindow() as a fallback.

# direct methods
.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# p0 = Activity (WineActivity)
.method public static injectOrUpdate(Landroid/app/Activity;)V
    .locals 7

    if-eqz p0, :done

    # v0 = Window
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v0
    if-eqz v0, :done

    # v0 = DecorView (as ViewGroup)
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;
    move-result-object v0
    if-eqz v0, :done
    check-cast v0, Landroid/view/ViewGroup;

    # v1 = SharedPreferences "bh_prefs"
    const-string v2, "bh_prefs"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1

    # v2 = winlator_hud pref (boolean)
    const-string v3, "winlator_hud"
    const/4 v4, 0x0
    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2

    # v3 = existing BhFrameRating (by tag)
    const-string v4, "bh_frame_rating"
    invoke-virtual {v0, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v3

    if-nez v3, :update_existing

    # Not yet injected — only add if HUD is enabled
    if-eqz v2, :done

    # Create BhFrameRating with Activity context (needed for FPS reflection)
    new-instance v4, Lcom/xj/winemu/sidebar/BhFrameRating;
    invoke-direct {v4, p0}, Lcom/xj/winemu/sidebar/BhFrameRating;-><init>(Landroid/content/Context;)V

    # Tag it for re-lookup
    const-string v5, "bh_frame_rating"
    invoke-virtual {v4, v5}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    # FrameLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, TOP|RIGHT = 0x35)
    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v6, -0x2
    const/16 v3, 0x35
    invoke-direct {v5, v6, v6, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    # VISIBLE
    const/4 v6, 0x0
    invoke-virtual {v4, v6}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v0, v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    goto :done

    # BhFrameRating already in DecorView — sync visibility with current pref
    :update_existing
    if-eqz v2, :set_gone
    const/4 v4, 0x0
    goto :set_vis
    :set_gone
    const/16 v4, 0x8
    :set_vis
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    :done
    return-void
.end method
