.class public final Lcom/xj/winemu/sidebar/BhHudOpacityListener;
.super Ljava/lang/Object;
.source "SourceFile"

# OnSeekBarChangeListener for the HUD Opacity slider.
# Saves "hud_opacity" (0-100) to bh_prefs and calls applyBackgroundOpacity(int)
# on whichever HUD(s) are currently in the DecorView.

.implements Landroid/widget/SeekBar$OnSeekBarChangeListener;

.field public final a:Landroid/content/Context;

# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhHudOpacityListener;->a:Landroid/content/Context;
    return-void
.end method

# virtual methods
.method public onProgressChanged(Landroid/widget/SeekBar;IZ)V
    .locals 4
    # p1 = SeekBar, p2 = progress (0-100), p3 = fromUser (ignored)

    # Save "hud_opacity" pref
    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhHudOpacityListener;->a:Landroid/content/Context;
    const-string v1, "bh_prefs"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v2, "hud_opacity"
    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Get DecorView into v3 (kept across both HUD lookups)
    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhHudOpacityListener;->a:Landroid/content/Context;
    check-cast v0, Landroid/app/Activity;
    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v1
    invoke-virtual {v1}, Landroid/view/Window;->getDecorView()Landroid/view/View;
    move-result-object v3

    # Update BhFrameRating if present
    const-string v1, "bh_frame_rating"
    invoke-virtual {v3, v1}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :try_detailed
    check-cast v1, Lcom/xj/winemu/sidebar/BhFrameRating;
    invoke-virtual {v1, p2}, Lcom/xj/winemu/sidebar/BhFrameRating;->applyBackgroundOpacity(I)V

    # Update BhDetailedHud if present
    :try_detailed
    const-string v1, "bh_detailed_hud"
    invoke-virtual {v3, v1}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :try_konkr
    check-cast v1, Lcom/xj/winemu/sidebar/BhDetailedHud;
    invoke-virtual {v1, p2}, Lcom/xj/winemu/sidebar/BhDetailedHud;->applyBackgroundOpacity(I)V

    # Update BhKonkrHud if present
    :try_konkr
    const-string v1, "bh_konkr_hud"
    invoke-virtual {v3, v1}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :done
    check-cast v1, Lcom/xj/winemu/sidebar/BhKonkrHud;
    invoke-virtual {v1, p2}, Lcom/xj/winemu/sidebar/BhKonkrHud;->applyBackgroundOpacity(I)V

    :done
    return-void
.end method

.method public onStartTrackingTouch(Landroid/widget/SeekBar;)V
    .locals 0
    return-void
.end method

.method public onStopTrackingTouch(Landroid/widget/SeekBar;)V
    .locals 0
    return-void
.end method
