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
    .locals 6

    invoke-super {p0}, Landroid/view/View;->onAttachedToWindow()V

    # Get parent view (performance_fl LinearLayout — contains all sibling switches)
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
    move-result-object v0
    if-eqz v0, :cond_done
    check-cast v0, Landroid/view/View;

    # Get context for SharedPreferences
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v1
    if-eqz v1, :cond_done

    const-string v2, "bh_prefs"
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2

    # Check root_granted pref (set via Settings -> Advanced -> Grant Root Access)
    const-string v3, "root_granted"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v5

    # Sustained Perf switch
    const v1, 0x7f0a0f0e
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Lcom/xj/winemu/view/SidebarSwitchItemView;
    if-eqz v1, :cond_adreno

    const-string v3, "sustained_perf"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    invoke-virtual {v1, v3}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    if-eqz v5, :cond_sustained_no_root

    # Root available — wire up click listener normally
    new-instance v3, Lcom/xj/winemu/sidebar/SustainedPerfSwitchClickListener;
    invoke-direct {v3, v1}, Lcom/xj/winemu/sidebar/SustainedPerfSwitchClickListener;-><init>(Lcom/xj/winemu/view/SidebarSwitchItemView;)V
    invoke-virtual {v1, v3}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V
    goto :cond_adreno

    :cond_sustained_no_root
    # No root — grey out (0.5f = 0x3F000000), leave no click listener
    const v3, 0x3f000000
    invoke-virtual {v1, v3}, Landroid/view/View;->setAlpha(F)V

    # Max Adreno Clocks switch
    :cond_adreno
    const v1, 0x7f0a0f0f
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Lcom/xj/winemu/view/SidebarSwitchItemView;
    if-eqz v1, :cond_done

    const-string v3, "max_adreno_clocks"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    invoke-virtual {v1, v3}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    if-eqz v5, :cond_adreno_no_root

    # Root available — wire up click listener normally
    new-instance v3, Lcom/xj/winemu/sidebar/MaxAdrenoClickListener;
    invoke-direct {v3, v1}, Lcom/xj/winemu/sidebar/MaxAdrenoClickListener;-><init>(Lcom/xj/winemu/view/SidebarSwitchItemView;)V
    invoke-virtual {v1, v3}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V
    goto :cond_done

    :cond_adreno_no_root
    # No root — grey out (0.5f = 0x3F000000), leave no click listener
    const v3, 0x3f000000
    invoke-virtual {v1, v3}, Landroid/view/View;->setAlpha(F)V

    :cond_done
    return-void
.end method
