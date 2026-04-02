.class public final Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;
.super Ljava/lang/Object;
.source "SourceFile"

# OnCheckedChangeListener for the "Extra Detailed" checkbox.
# Saves hud_extra_detail pref and swaps which HUD is visible in the DecorView:
#   checked=true  → hide BhFrameRating, show BhDetailedHud (create if needed)
#   checked=false → show BhFrameRating, hide BhDetailedHud

.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;

# instance fields
.field public final a:Landroid/content/Context;

# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;->a:Landroid/content/Context;
    return-void
.end method

# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 10
    # p1 = CompoundButton (unused)
    # p2 = isChecked

    # Save "hud_extra_detail" pref
    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;->a:Landroid/content/Context;
    const-string v1, "bh_prefs"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v2, "hud_extra_detail"
    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Get DecorView
    iget-object v1, p0, Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;->a:Landroid/content/Context;
    check-cast v1, Landroid/app/Activity;
    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v2
    if-eqz v2, :done
    invoke-virtual {v2}, Landroid/view/Window;->getDecorView()Landroid/view/View;
    move-result-object v2
    if-eqz v2, :done
    check-cast v2, Landroid/view/ViewGroup;

    # v3 = BhFrameRating (may be null — not yet created)
    const-string v3, "bh_frame_rating"
    invoke-virtual {v2, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v3

    # v4 = BhDetailedHud (may be null — not yet created)
    const-string v4, "bh_detailed_hud"
    invoke-virtual {v2, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v4

    if-nez p2, :show_detailed

    # ── Unchecked: show BhFrameRating, hide BhDetailedHud ─────────────────

    if-eqz v3, :hide_detailed
    const/4 v5, 0x0
    invoke-virtual {v3, v5}, Landroid/view/View;->setVisibility(I)V

    :hide_detailed
    if-eqz v4, :done
    const/16 v5, 0x8
    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V
    goto :done

    # ── Checked: hide BhFrameRating, show/create BhDetailedHud ────────────

    :show_detailed
    if-eqz v3, :create_or_show_detailed
    const/16 v5, 0x8
    invoke-virtual {v3, v5}, Landroid/view/View;->setVisibility(I)V

    :create_or_show_detailed
    if-eqz v4, :create_detailed

    # BhDetailedHud already exists — make it visible
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V
    goto :done

    # BhDetailedHud doesn't exist yet — create it with Activity context
    :create_detailed
    iget-object v5, p0, Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;->a:Landroid/content/Context;
    new-instance v6, Lcom/xj/winemu/sidebar/BhDetailedHud;
    invoke-direct {v6, v5}, Lcom/xj/winemu/sidebar/BhDetailedHud;-><init>(Landroid/content/Context;)V

    const-string v7, "bh_detailed_hud"
    invoke-virtual {v6, v7}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    # FrameLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, TOP|RIGHT = 0x35)
    new-instance v7, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v8, -0x2
    const/16 v9, 0x35
    invoke-direct {v7, v8, v8, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    const/4 v8, 0x0
    invoke-virtual {v6, v8}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v2, v6, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :done
    return-void
.end method
