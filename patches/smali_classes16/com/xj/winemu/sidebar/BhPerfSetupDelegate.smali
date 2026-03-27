.class public Lcom/xj/winemu/sidebar/BhPerfSetupDelegate;
.super Landroid/view/View;
.source "SourceFile"


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Landroid/view/View;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

# Returns true if root (su) is available and granted.
# Runs "su -c id" and checks exit code — returns false on any failure.
.method public static isRootAvailable()Z
    .locals 4

    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v0

    const/4 v1, 0x3
    new-array v1, v1, [Ljava/lang/String;

    const-string v2, "su"
    const/4 v3, 0x0
    aput-object v2, v1, v3

    const-string v2, "-c"
    const/4 v3, 0x1
    aput-object v2, v1, v3

    const-string v2, "id"
    const/4 v3, 0x2
    aput-object v2, v1, v3

    invoke-virtual {v0, v1}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;
    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Process;->waitFor()I
    move-result v1

    invoke-virtual {v0}, Ljava/lang/Process;->destroy()V

    const/4 v0, 0x0
    if-nez v1, :cond_no_root
    const/4 v0, 0x1
    :cond_no_root
    return v0
    :try_end_0

    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    :catch_0
    const/4 v0, 0x0
    return v0
.end method


# virtual methods
.method protected onAttachedToWindow()V
    .locals 13

    invoke-super {p0}, Landroid/view/View;->onAttachedToWindow()V

    # v0 = parent view (performance_fl LinearLayout)
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v0
    if-eqz v0, :cond_done
    check-cast v0, Landroid/view/View;

    # v1 = context (WineActivity)
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v1
    if-eqz v1, :cond_done

    # v2 = SharedPreferences "bh_prefs"
    const-string v3, "bh_prefs"
    const/4 v4, 0x0
    invoke-virtual {v1, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2

    # v5 = isRootAvailable
    invoke-static {}, Lcom/xj/winemu/sidebar/BhPerfSetupDelegate;->isRootAvailable()Z
    move-result v5

    # ── Sustained Perf switch ──────────────────────────────────────────────
    const v3, 0x7f0a0f0e
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    check-cast v3, Lcom/xj/winemu/view/SidebarSwitchItemView;
    if-eqz v3, :cond_adreno

    const-string v4, "sustained_perf"
    const/4 v6, 0x0
    invoke-interface {v2, v4, v6}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v4
    invoke-virtual {v3, v4}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    if-eqz v5, :cond_sustained_no_root

    new-instance v4, Lcom/xj/winemu/sidebar/SustainedPerfSwitchClickListener;
    invoke-direct {v4, v3}, Lcom/xj/winemu/sidebar/SustainedPerfSwitchClickListener;-><init>(Lcom/xj/winemu/view/SidebarSwitchItemView;)V
    invoke-virtual {v3, v4}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V
    goto :cond_adreno

    :cond_sustained_no_root
    const v4, 0x3f000000
    invoke-virtual {v3, v4}, Landroid/view/View;->setAlpha(F)V

    # ── Max Adreno Clocks switch ───────────────────────────────────────────
    :cond_adreno
    const v3, 0x7f0a0f0f
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    check-cast v3, Lcom/xj/winemu/view/SidebarSwitchItemView;
    if-eqz v3, :cond_winlator_hud

    const-string v4, "max_adreno_clocks"
    const/4 v6, 0x0
    invoke-interface {v2, v4, v6}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v4
    invoke-virtual {v3, v4}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    if-eqz v5, :cond_adreno_no_root

    new-instance v4, Lcom/xj/winemu/sidebar/MaxAdrenoClickListener;
    invoke-direct {v4, v3}, Lcom/xj/winemu/sidebar/MaxAdrenoClickListener;-><init>(Lcom/xj/winemu/view/SidebarSwitchItemView;)V
    invoke-virtual {v3, v4}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V
    goto :cond_winlator_hud

    :cond_adreno_no_root
    const v4, 0x3f000000
    invoke-virtual {v3, v4}, Landroid/view/View;->setAlpha(F)V

    # ── Winlator HUD Style toggle (added programmatically) ────────────────
    :cond_winlator_hud

    # Find existing by tag "bh_hud_switch"
    const-string v3, "bh_hud_switch"
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v6

    if-nez v6, :cond_hud_switch_exists

    # Create SidebarSwitchItemView(context, null)
    const/4 v7, 0x0
    new-instance v6, Lcom/xj/winemu/view/SidebarSwitchItemView;
    invoke-direct {v6, v1, v7}, Lcom/xj/winemu/view/SidebarSwitchItemView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    # Tag for re-lookup next time sidebar opens
    const-string v7, "bh_hud_switch"
    invoke-virtual {v6, v7}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    # Set title via tv_name (id 0x7f0a0db6)
    const v7, 0x7f0a0db6
    invoke-virtual {v6, v7}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v7
    check-cast v7, Landroid/widget/TextView;
    const-string v8, "Winlator HUD Style"
    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # LayoutParams: MATCH_PARENT x WRAP_CONTENT
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v8, -0x1
    const/4 v9, -0x2
    invoke-direct {v7, v8, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0, v6, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Set state + click listener
    :cond_hud_switch_exists
    check-cast v6, Lcom/xj/winemu/view/SidebarSwitchItemView;

    const-string v7, "winlator_hud"
    const/4 v8, 0x0
    invoke-interface {v2, v7, v8}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v7
    invoke-virtual {v6, v7}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    new-instance v8, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;
    invoke-direct {v8, v6, v1}, Lcom/xj/winemu/sidebar/BhHudStyleSwitchListener;-><init>(Lcom/xj/winemu/view/SidebarSwitchItemView;Landroid/content/Context;)V
    invoke-virtual {v6, v8}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V

    # ── Inject BhFrameRating into DecorView (once per WineActivity instance) ─
    check-cast v1, Landroid/app/Activity;
    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v8
    invoke-virtual {v8}, Landroid/view/Window;->getDecorView()Landroid/view/View;
    move-result-object v8
    check-cast v8, Landroid/view/ViewGroup;

    const-string v9, "bh_frame_rating"
    invoke-virtual {v8, v9}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v9

    if-nez v9, :cond_fr_update_vis

    # Create BhFrameRating with application context to avoid Window leak
    invoke-virtual {v1}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;
    move-result-object v10
    new-instance v9, Lcom/xj/winemu/sidebar/BhFrameRating;
    invoke-direct {v9, v10}, Lcom/xj/winemu/sidebar/BhFrameRating;-><init>(Landroid/content/Context;)V

    const-string v10, "bh_frame_rating"
    invoke-virtual {v9, v10}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    # FrameLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, TOP|RIGHT = 0x35)
    new-instance v10, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v11, -0x2
    const/16 v12, 0x35
    invoke-direct {v10, v11, v11, v12}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    # Initial visibility from pref
    const-string v11, "winlator_hud"
    const/4 v12, 0x0
    invoke-interface {v2, v11, v12}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v11
    if-eqz v11, :fr_gone_init
    const/4 v12, 0x0
    goto :fr_set_vis_init
    :fr_gone_init
    const/16 v12, 0x8
    :fr_set_vis_init
    invoke-virtual {v9, v12}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v8, v9, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    goto :cond_done

    # BhFrameRating already exists — sync visibility with current pref
    :cond_fr_update_vis
    const-string v10, "winlator_hud"
    const/4 v11, 0x0
    invoke-interface {v2, v10, v11}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v10
    if-eqz v10, :fr_gone_update
    const/4 v11, 0x0
    goto :fr_set_vis_update
    :fr_gone_update
    const/16 v11, 0x8
    :fr_set_vis_update
    invoke-virtual {v9, v11}, Landroid/view/View;->setVisibility(I)V

    :cond_done
    return-void
.end method
