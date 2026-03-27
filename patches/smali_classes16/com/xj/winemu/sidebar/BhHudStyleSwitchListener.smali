.class public final synthetic Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;
.super Ljava/lang/Object;
.source "SourceFile"

# Toggles between GameHub HUD (UnifiedHUDView) and Winlator-style HUD (BhFrameRating).
# When Winlator HUD is turned on:  shows BhFrameRating, hides GameHub hudLayer.
# When Winlator HUD is turned off: hides BhFrameRating (hudLayer stays as-is).

# interfaces
.implements Lkotlin/jvm/functions/Function0;

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lkotlin/jvm/functions/Function0<",
        "Lkotlin/Unit;",
        ">;"
    }
.end annotation

# instance fields
.field public final synthetic a:Lcom/xj/winemu/view/SidebarSwitchItemView;
.field public final synthetic b:Landroid/content/Context;

# direct methods
.method public synthetic constructor <init>(Lcom/xj/winemu/view/SidebarSwitchItemView;Landroid/content/Context;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->a:Lcom/xj/winemu/view/SidebarSwitchItemView;
    iput-object p2, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->b:Landroid/content/Context;
    return-void
.end method

# virtual methods
.method public final invoke()Ljava/lang/Object;
    .locals 6

    # Toggle switch state
    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->a:Lcom/xj/winemu/view/SidebarSwitchItemView;
    invoke-virtual {v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z
    move-result v1
    xor-int/lit8 v1, v1, 0x1
    invoke-virtual {v0, v1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    # Save "winlator_hud" pref
    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->b:Landroid/content/Context;
    const-string v3, "bh_prefs"
    const/4 v4, 0x0
    invoke-virtual {v2, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    const-string v4, "winlator_hud"
    invoke-interface {v3, v4, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Get DecorView
    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;->b:Landroid/content/Context;
    check-cast v2, Landroid/app/Activity;
    invoke-virtual {v2}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v2
    invoke-virtual {v2}, Landroid/view/Window;->getDecorView()Landroid/view/View;
    move-result-object v2

    # Update BhFrameRating visibility
    const-string v3, "bh_frame_rating"
    invoke-virtual {v2, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v3
    if-eqz v3, :cond_hud_layer

    if-eqz v1, :fr_gone
    const/4 v4, 0x0
    goto :fr_set_vis
    :fr_gone
    const/16 v4, 0x8
    :fr_set_vis
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    # If turning Winlator HUD on: hide GameHub hudLayer to avoid double overlay
    :cond_hud_layer
    if-eqz v1, :done

    const v3, 0x7f0a050b
    invoke-virtual {v2, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    if-eqz v3, :done

    const/16 v4, 0x8
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    :done
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;
    return-object v0
.end method
