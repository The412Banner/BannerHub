.class public final synthetic Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;
.super Ljava/lang/Object;
.source "SourceFile"

# Toggles the Winlator HUD.
# Saves winlator_hud pref, clears hud_extra_detail when turning off,
# updates Extra Detail checkbox state, delegates all HUD visibility to
# BhHudInjector.injectOrUpdate(), and hides the GameHub hudLayer when ON.

.implements Lkotlin/jvm/functions/Function0;

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lkotlin/jvm/functions/Function0<",
        "Lkotlin/Unit;",
        ">;"
    }
.end annotation

.field public final synthetic a:Lcom/xj/winemu/view/SidebarSwitchItemView;
.field public final synthetic b:Landroid/content/Context;

.method public synthetic constructor <init>(Lcom/xj/winemu/view/SidebarSwitchItemView;Landroid/content/Context;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->a:Lcom/xj/winemu/view/SidebarSwitchItemView;
    iput-object p2, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->b:Landroid/content/Context;
    return-void
.end method

.method public final invoke()Ljava/lang/Object;
    .locals 8

    # ── Toggle switch, v1 = new state (1=on, 0=off) ──────────────────────────
    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->a:Lcom/xj/winemu/view/SidebarSwitchItemView;
    invoke-virtual {v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z
    move-result v1
    xor-int/lit8 v1, v1, 0x1
    invoke-virtual {v0, v1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    # ── Get SharedPreferences (v3) ────────────────────────────────────────────
    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->b:Landroid/content/Context;
    const-string v3, "bh_prefs"
    const/4 v4, 0x0
    invoke-virtual {v2, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3

    # ── Save winlator_hud pref ────────────────────────────────────────────────
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v4
    const-string v5, "winlator_hud"
    invoke-interface {v4, v5, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    # ── If HUD turning OFF: clear hud_extra_detail pref ──────────────────────
    if-nez v1, :get_decor

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v4
    const-string v5, "hud_extra_detail"
    const/4 v6, 0x0
    invoke-interface {v4, v5, v6}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    # ── Get DecorView (v4) ────────────────────────────────────────────────────
    :get_decor
    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->b:Landroid/content/Context;
    check-cast v2, Landroid/app/Activity;
    invoke-virtual {v2}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v4
    invoke-virtual {v4}, Landroid/view/Window;->getDecorView()Landroid/view/View;
    move-result-object v4

    # ── Update Extra Detail checkbox enabled/alpha state ─────────────────────
    const-string v5, "bh_hud_extra_cb"
    invoke-virtual {v4, v5}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v5
    if-eqz v5, :update_huds

    check-cast v5, Landroid/widget/CheckBox;

    if-nez v1, :cb_enable

    # HUD OFF: disable, half-alpha, force unchecked
    const/4 v6, 0x0
    invoke-virtual {v5, v6}, Landroid/widget/CompoundButton;->setChecked(Z)V
    invoke-virtual {v5, v6}, Landroid/view/View;->setEnabled(Z)V
    const v6, 0x3f000000
    invoke-virtual {v5, v6}, Landroid/view/View;->setAlpha(F)V
    goto :update_huds

    :cb_enable
    # HUD ON: enable, full alpha
    const/4 v6, 0x1
    invoke-virtual {v5, v6}, Landroid/view/View;->setEnabled(Z)V
    const v6, 0x3f800000
    invoke-virtual {v5, v6}, Landroid/view/View;->setAlpha(F)V

    # ── Delegate all HUD creation/visibility to BhHudInjector ────────────────
    :update_huds
    invoke-static {v2}, Lcom/xj/winemu/sidebar/BhHudInjector;->injectOrUpdate(Landroid/app/Activity;)V

    # ── If HUD ON: hide GameHub hudLayer to avoid double overlay ─────────────
    if-eqz v1, :done

    const v5, 0x7f0a050b
    invoke-virtual {v4, v5}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v5
    if-eqz v5, :done

    const/16 v6, 0x8
    invoke-virtual {v5, v6}, Landroid/view/View;->setVisibility(I)V

    :done
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;
    return-object v0
.end method
