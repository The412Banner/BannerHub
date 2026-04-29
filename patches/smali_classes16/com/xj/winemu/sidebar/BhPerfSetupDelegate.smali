.class public Lcom/xj/winemu/sidebar/BhPerfSetupDelegate;
.super Landroid/view/View;
.source "SourceFile"

# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Landroid/view/View;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
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

    # ── BH: inject LSFG gear button at top of Performance panel ──────────────
    # Guard: skip if already added (sidebar can reopen without re-creating the layout)
    const-string v3, "bh_lsfg_btn"
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v3
    if-nez v3, :cond_lsfg_done

    # Build the button (gameId resolved from context at click time via BhLsfgManager.getGameIdFromContext)
    new-instance v9, Landroid/widget/Button;
    invoke-direct {v9, v1}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v10, "⚙  LSFG Frame Gen"
    invoke-virtual {v9, v10}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v10, -0x1
    invoke-virtual {v9, v10}, Landroid/widget/Button;->setTextColor(I)V
    # Explicit background so the button is visible in the dark sidebar panel
    const v10, 0xFF1565C0
    invoke-virtual {v9, v10}, Landroid/view/View;->setBackgroundColor(I)V

    # Tag so the guard above fires on sidebar reopen
    const-string v10, "bh_lsfg_btn"
    invoke-virtual {v9, v10}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    # Wire click listener → opens BhLsfgInGameDialog
    new-instance v10, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;
    invoke-direct {v10, v1}, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;-><init>(Landroid/content/Context;)V
    invoke-virtual {v9, v10}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Insert at index 0 (very top, above Native Rendering+)
    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v11, -0x1
    const/4 v12, -0x2
    invoke-direct {v10, v11, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    check-cast v0, Landroid/view/ViewGroup;
    const/4 v11, 0x0
    invoke-virtual {v0, v9, v11, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    :cond_lsfg_done
    # ─────────────────────────────────────────────────────────────────────────

    # v2 = SharedPreferences "bh_prefs"
    const-string v3, "bh_prefs"
    const/4 v4, 0x0
    invoke-virtual {v1, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2

    # v5 = root_granted pref (set by BhRootGrantHelper via app settings — never call su here)
    const-string v3, "root_granted"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
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

    # ── "Extra Detailed" CheckBox (below Winlator HUD switch) ────────────────
    const-string v3, "bh_hud_extra_cb"
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v3

    if-nez v3, :cond_extra_cb_exists

    # Create CheckBox(context)
    new-instance v3, Landroid/widget/CheckBox;
    invoke-direct {v3, v1}, Landroid/widget/CheckBox;-><init>(Landroid/content/Context;)V

    # Tag for re-lookup
    const-string v4, "bh_hud_extra_cb"
    invoke-virtual {v3, v4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    # setText("Extra Detailed")
    const-string v4, "Extra Detailed"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # setTextColor(gray — grayed out, feature not yet ready)
    const v4, 0xFF888888
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    # LayoutParams: MATCH_PARENT x WRAP_CONTENT, topMargin = round(density * 4)
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1
    const/4 v6, -0x2
    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v5
    invoke-virtual {v5}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v5
    iget v5, v5, Landroid/util/DisplayMetrics;->density:F
    const/4 v6, 0x4
    int-to-float v6, v6
    mul-float v5, v5, v6
    float-to-int v5, v5
    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    # v0 may be View at this join point depending on path — re-cast to ViewGroup
    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0, v3, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :cond_extra_cb_exists
    check-cast v3, Landroid/widget/CheckBox;

    # Re-read winlator_hud pref to decide enabled state
    const-string v4, "winlator_hud"
    const/4 v5, 0x0
    invoke-interface {v2, v4, v5}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v4

    if-eqz v4, :cb_disable

    # HUD is ON: enable checkbox, full alpha, restore pref state, set listener
    const/4 v5, 0x1
    invoke-virtual {v3, v5}, Landroid/view/View;->setEnabled(Z)V
    const v5, 0x3f800000
    invoke-virtual {v3, v5}, Landroid/view/View;->setAlpha(F)V

    const-string v5, "hud_extra_detail"
    const/4 v6, 0x0
    invoke-interface {v2, v5, v6}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v5
    invoke-virtual {v3, v5}, Landroid/widget/CompoundButton;->setChecked(Z)V

    new-instance v5, Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;
    invoke-direct {v5, v1}, Lcom/xj/winemu/sidebar/BhHudExtraDetailListener;-><init>(Landroid/content/Context;)V
    invoke-virtual {v3, v5}, Landroid/widget/CompoundButton;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    goto :cb_done

    :cb_disable
    # HUD is OFF: disable, half-alpha, force unchecked
    const/4 v5, 0x0
    invoke-virtual {v3, v5}, Landroid/widget/CompoundButton;->setChecked(Z)V
    invoke-virtual {v3, v5}, Landroid/view/View;->setEnabled(Z)V
    const v5, 0x3f000000
    invoke-virtual {v3, v5}, Landroid/view/View;->setAlpha(F)V

    :cb_done

    # ── "Konkr Style" CheckBox (below Extra Detailed) ────────────────────────
    const-string v3, "bh_hud_konkr_cb"
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v3

    if-nez v3, :cond_konkr_cb_exists

    # Create CheckBox(context)
    new-instance v3, Landroid/widget/CheckBox;
    invoke-direct {v3, v1}, Landroid/widget/CheckBox;-><init>(Landroid/content/Context;)V

    const-string v4, "bh_hud_konkr_cb"
    invoke-virtual {v3, v4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    const-string v4, "Konkr Style"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v4, 0xFFFFFFFF
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1
    const/4 v6, -0x2
    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v5
    invoke-virtual {v5}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v5
    iget v5, v5, Landroid/util/DisplayMetrics;->density:F
    const/4 v6, 0x4
    int-to-float v6, v6
    mul-float v5, v5, v6
    float-to-int v5, v5
    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0, v3, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :cond_konkr_cb_exists
    check-cast v3, Landroid/widget/CheckBox;

    # Re-read winlator_hud pref
    const-string v4, "winlator_hud"
    const/4 v5, 0x0
    invoke-interface {v2, v4, v5}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v4

    if-eqz v4, :konkr_cb_disable

    # HUD is ON: enable checkbox, restore pref state, set listener
    const/4 v5, 0x1
    invoke-virtual {v3, v5}, Landroid/view/View;->setEnabled(Z)V
    const v5, 0x3f800000
    invoke-virtual {v3, v5}, Landroid/view/View;->setAlpha(F)V

    const-string v5, "hud_konkr_style"
    const/4 v6, 0x0
    invoke-interface {v2, v5, v6}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v5
    invoke-virtual {v3, v5}, Landroid/widget/CompoundButton;->setChecked(Z)V

    new-instance v5, Lcom/xj/winemu/sidebar/BhHudKonkrListener;
    invoke-direct {v5, v1}, Lcom/xj/winemu/sidebar/BhHudKonkrListener;-><init>(Landroid/content/Context;)V
    invoke-virtual {v3, v5}, Landroid/widget/CompoundButton;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    goto :konkr_cb_done

    :konkr_cb_disable
    const/4 v5, 0x0
    invoke-virtual {v3, v5}, Landroid/widget/CompoundButton;->setChecked(Z)V
    invoke-virtual {v3, v5}, Landroid/view/View;->setEnabled(Z)V
    const v5, 0x3f000000
    invoke-virtual {v3, v5}, Landroid/view/View;->setAlpha(F)V

    :konkr_cb_done

    # ── HUD Opacity label ────────────────────────────────────────────────────
    const-string v3, "bh_hud_opacity_label"
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v3

    if-nez v3, :cond_opacity_label_exists

    new-instance v3, Landroid/widget/TextView;
    invoke-direct {v3, v1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v4, "bh_hud_opacity_label"
    invoke-virtual {v3, v4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    const-string v4, "HUD Opacity"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v4, 0xFFFFFFFF
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1
    const/4 v6, -0x2
    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v5
    invoke-virtual {v5}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v5
    iget v5, v5, Landroid/util/DisplayMetrics;->density:F
    const/4 v6, 0x4
    int-to-float v6, v6
    mul-float v5, v5, v6
    float-to-int v5, v5
    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0, v3, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :cond_opacity_label_exists

    # ── HUD Opacity SeekBar ───────────────────────────────────────────────────
    const-string v3, "bh_hud_opacity_bar"
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v3

    if-nez v3, :cond_opacity_bar_exists

    new-instance v3, Landroid/widget/SeekBar;
    invoke-direct {v3, v1}, Landroid/widget/SeekBar;-><init>(Landroid/content/Context;)V

    const-string v4, "bh_hud_opacity_bar"
    invoke-virtual {v3, v4}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    # setMax(100)
    const/16 v4, 0x64
    invoke-virtual {v3, v4}, Landroid/widget/ProgressBar;->setMax(I)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1
    const/4 v6, -0x2
    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v5
    invoke-virtual {v5}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v5
    iget v5, v5, Landroid/util/DisplayMetrics;->density:F
    const/4 v6, 0x2
    int-to-float v6, v6
    mul-float v5, v5, v6
    float-to-int v5, v5
    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0, v3, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :cond_opacity_bar_exists
    check-cast v3, Landroid/widget/SeekBar;

    # Sync progress from pref (default 80)
    const-string v4, "hud_opacity"
    const/16 v5, 0x50
    invoke-interface {v2, v4, v5}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v4
    invoke-virtual {v3, v4}, Landroid/widget/ProgressBar;->setProgress(I)V

    # Set listener
    new-instance v4, Lcom/xj/winemu/sidebar/BhHudOpacityListener;
    invoke-direct {v4, v1}, Lcom/xj/winemu/sidebar/BhHudOpacityListener;-><init>(Landroid/content/Context;)V
    invoke-virtual {v3, v4}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    # ── Delegate all HUD visibility to BhHudInjector (handles both HUDs correctly) ──
    check-cast v1, Landroid/app/Activity;
    invoke-static {v1}, Lcom/xj/winemu/sidebar/BhHudInjector;->injectOrUpdate(Landroid/app/Activity;)V

    :cond_done
    return-void
.end method
