.class public final Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;
.super Ljava/lang/Object;
.source "SourceFile"

# OnCheckedChangeListener for the "Extra Detailed" checkbox.
# Guards against winlator_hud being off, saves hud_extra_detail pref,
# then delegates all HUD visibility to BhHudInjector.injectOrUpdate().

.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;

.field public final a:Landroid/content/Context;

.method public constructor <init>(Landroid/content/Context;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;->a:Landroid/content/Context;
    return-void
.end method

.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 5
    # p1 = CompoundButton (unused), p2 = isChecked

    # Get SharedPreferences
    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;->a:Landroid/content/Context;
    const-string v1, "bh_prefs"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1

    # Guard: do nothing if winlator_hud is off
    const-string v2, "winlator_hud"
    const/4 v3, 0x0
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    if-eqz v2, :done

    # Save hud_extra_detail pref
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    const-string v3, "hud_extra_detail"
    invoke-interface {v2, v3, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Delegate all HUD visibility to BhHudInjector
    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;->a:Landroid/content/Context;
    check-cast v2, Landroid/app/Activity;
    invoke-static {v2}, Lcom/xj/winemu/sidebar/BhHudInjector;->injectOrUpdate(Landroid/app/Activity;)V

    :done
    return-void
.end method
