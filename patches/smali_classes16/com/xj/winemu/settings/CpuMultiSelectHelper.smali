.class public final Lcom/xj/winemu/settings/CpuMultiSelectHelper;
.super Ljava/lang/Object;

# BannerHub: multi-select CPU core dialog.
# p0 = View (anchor — getContext() for dialog; must be non-null)
# p1 = String gameId
# p2 = int contentType (CONTENT_TYPE_CORE_LIMIT)
# p3 = Function1 callback (NOT invoked — avoids j3 NPE; SPUtils saves directly)
#
# Register map:
#  v0  = Context (p0.getContext())
#  v1  = helper singleton → CharSequence[8] labels
#  v2  = ops → boolean[8] checked
#  v3  = SPUtils → temp string/metrics
#  v4  = key String → null/WRAP_CONTENT
#  v5  = currentMask (int) → $1 listener
#  v6  = temp index/Html flags=0 → $2 listener
#  v7  = temp Html string → $3 listener
#  v8  = Html flags(0) → AlertDialog.Builder → AlertDialog → Window

.method public static show(Landroid/view/View;Ljava/lang/String;ILkotlin/jvm/functions/Function1;)V
    .locals 9

    # --- Context ---
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v0

    # --- Helper singleton ---
    sget-object v1, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->a:Lcom/xj/winemu/settings/PcGameSettingDataHelper;

    # --- Operations ---
    invoke-virtual {v1, p1}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->v(Ljava/lang/String;)Lcom/xj/winemu/settings/PcGameSettingOperations;
    move-result-object v2

    # --- SPUtils ---
    invoke-virtual {v2}, Lcom/xj/winemu/settings/PcGameSettingOperations;->c0()Lcom/blankj/utilcode/util/SPUtils;
    move-result-object v3

    # --- Key string ---
    const/4 v4, 0x2
    const/4 v5, 0x0
    invoke-static {v1, p2, v5, v4, v5}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->A(Lcom/xj/winemu/settings/PcGameSettingDataHelper;ILjava/lang/String;ILjava/lang/Object;)Ljava/lang/String;
    move-result-object v4

    # --- Current mask via C(ops, 0, 1, null) ---
    const/4 v5, 0x0
    const/4 v1, 0x1
    invoke-static {v2, v5, v1, v5}, Lcom/xj/winemu/settings/PcGameSettingOperations;->C(Lcom/xj/winemu/settings/PcGameSettingOperations;IILjava/lang/Object;)I
    move-result v5
    # v1 (1) and v2 (ops) now free

    # --- Build CharSequence[8] labels with Html.fromHtml for smaller text ---
    const/16 v1, 0x8
    new-array v1, v1, [Ljava/lang/CharSequence;
    const/4 v8, 0x0    # Html.FROM_HTML_MODE_LEGACY = 0 (flags)

    const/4 v6, 0x0
    const-string v7, "<small>Core 0 (Efficiency)</small>"
    invoke-static {v7, v8}, Landroid/text/Html;->fromHtml(Ljava/lang/String;I)Landroid/text/Spanned;
    move-result-object v7
    aput-object v7, v1, v6

    const/4 v6, 0x1
    const-string v7, "<small>Core 1 (Efficiency)</small>"
    invoke-static {v7, v8}, Landroid/text/Html;->fromHtml(Ljava/lang/String;I)Landroid/text/Spanned;
    move-result-object v7
    aput-object v7, v1, v6

    const/4 v6, 0x2
    const-string v7, "<small>Core 2 (Efficiency)</small>"
    invoke-static {v7, v8}, Landroid/text/Html;->fromHtml(Ljava/lang/String;I)Landroid/text/Spanned;
    move-result-object v7
    aput-object v7, v1, v6

    const/4 v6, 0x3
    const-string v7, "<small>Core 3 (Efficiency)</small>"
    invoke-static {v7, v8}, Landroid/text/Html;->fromHtml(Ljava/lang/String;I)Landroid/text/Spanned;
    move-result-object v7
    aput-object v7, v1, v6

    const/4 v6, 0x4
    const-string v7, "<small>Core 4 (Performance)</small>"
    invoke-static {v7, v8}, Landroid/text/Html;->fromHtml(Ljava/lang/String;I)Landroid/text/Spanned;
    move-result-object v7
    aput-object v7, v1, v6

    const/4 v6, 0x5
    const-string v7, "<small>Core 5 (Performance)</small>"
    invoke-static {v7, v8}, Landroid/text/Html;->fromHtml(Ljava/lang/String;I)Landroid/text/Spanned;
    move-result-object v7
    aput-object v7, v1, v6

    const/4 v6, 0x6
    const-string v7, "<small>Core 6 (Performance)</small>"
    invoke-static {v7, v8}, Landroid/text/Html;->fromHtml(Ljava/lang/String;I)Landroid/text/Spanned;
    move-result-object v7
    aput-object v7, v1, v6

    const/4 v6, 0x7
    const-string v7, "<small>Core 7 (Prime)</small>"
    invoke-static {v7, v8}, Landroid/text/Html;->fromHtml(Ljava/lang/String;I)Landroid/text/Spanned;
    move-result-object v7
    aput-object v7, v1, v6
    # v1 = labels, v6/v7/v8 free

    # --- Build boolean[8] checked ---
    const/16 v2, 0x8
    new-array v2, v2, [Z

    # Core 0 (mask = 1)
    const/4 v6, 0x0
    const/4 v7, 0x1
    and-int/2addr v7, v5
    if-eqz v7, :cond_c0f
    const/4 v7, 0x1
    goto :goto_c0
    :cond_c0f
    const/4 v7, 0x0
    :goto_c0
    aput-boolean v7, v2, v6

    # Core 1 (mask = 2)
    const/4 v6, 0x1
    const/4 v7, 0x2
    and-int/2addr v7, v5
    if-eqz v7, :cond_c1f
    const/4 v7, 0x1
    goto :goto_c1
    :cond_c1f
    const/4 v7, 0x0
    :goto_c1
    aput-boolean v7, v2, v6

    # Core 2 (mask = 4)
    const/4 v6, 0x2
    const/4 v7, 0x4
    and-int/2addr v7, v5
    if-eqz v7, :cond_c2f
    const/4 v7, 0x1
    goto :goto_c2
    :cond_c2f
    const/4 v7, 0x0
    :goto_c2
    aput-boolean v7, v2, v6

    # Core 3 (mask = 8)
    const/4 v6, 0x3
    const/16 v7, 0x8
    and-int/2addr v7, v5
    if-eqz v7, :cond_c3f
    const/4 v7, 0x1
    goto :goto_c3
    :cond_c3f
    const/4 v7, 0x0
    :goto_c3
    aput-boolean v7, v2, v6

    # Core 4 (mask = 16 = 0x10)
    const/4 v6, 0x4
    const/16 v7, 0x10
    and-int/2addr v7, v5
    if-eqz v7, :cond_c4f
    const/4 v7, 0x1
    goto :goto_c4
    :cond_c4f
    const/4 v7, 0x0
    :goto_c4
    aput-boolean v7, v2, v6

    # Core 5 (mask = 32 = 0x20)
    const/4 v6, 0x5
    const/16 v7, 0x20
    and-int/2addr v7, v5
    if-eqz v7, :cond_c5f
    const/4 v7, 0x1
    goto :goto_c5
    :cond_c5f
    const/4 v7, 0x0
    :goto_c5
    aput-boolean v7, v2, v6

    # Core 6 (mask = 64 = 0x40)
    const/4 v6, 0x6
    const/16 v7, 0x40
    and-int/2addr v7, v5
    if-eqz v7, :cond_c6f
    const/4 v7, 0x1
    goto :goto_c6
    :cond_c6f
    const/4 v7, 0x0
    :goto_c6
    aput-boolean v7, v2, v6

    # Core 7 (mask = 128 = 0x80)
    const/4 v6, 0x7
    const/16 v7, 0x80
    and-int/2addr v7, v5
    if-eqz v7, :cond_c7f
    const/4 v7, 0x1
    goto :goto_c7
    :cond_c7f
    const/4 v7, 0x0
    :goto_c7
    aput-boolean v7, v2, v6
    # v2 = checked, v5/v6/v7 free

    # --- $1: OnMultiChoiceClickListener(checked[]) ---
    new-instance v5, Lcom/xj/winemu/settings/CpuMultiSelectHelper$1;
    invoke-direct {v5, v2}, Lcom/xj/winemu/settings/CpuMultiSelectHelper$1;-><init>([Z)V

    # --- $2: PositiveButton(checked[], SPUtils, key, callback) — 5 regs, no /range needed ---
    new-instance v6, Lcom/xj/winemu/settings/CpuMultiSelectHelper$2;
    invoke-direct {v6, v2, v3, v4, p3}, Lcom/xj/winemu/settings/CpuMultiSelectHelper$2;-><init>([ZLcom/blankj/utilcode/util/SPUtils;Ljava/lang/String;Lkotlin/jvm/functions/Function1;)V

    # --- $3: NegativeButton(SPUtils, key, callback) — 4 regs, no /range needed ---
    new-instance v7, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;
    invoke-direct {v7, v3, v4, p3}, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;-><init>(Lcom/blankj/utilcode/util/SPUtils;Ljava/lang/String;Lkotlin/jvm/functions/Function1;)V
    # v3 and v4 now free

    # --- AlertDialog.Builder ---
    new-instance v8, Landroid/app/AlertDialog$Builder;
    invoke-direct {v8, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v3, "CPU Core Limit"
    invoke-virtual {v8, v3}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v8, v1, v2, v5}, Landroid/app/AlertDialog$Builder;->setMultiChoiceItems([Ljava/lang/CharSequence;[ZLandroid/content/DialogInterface$OnMultiChoiceClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v3, "Apply"
    invoke-virtual {v8, v3, v6}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v3, "No Limit"
    invoke-virtual {v8, v3, v7}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v3, "Cancel"
    const/4 v4, 0x0
    invoke-virtual {v8, v3, v4}, Landroid/app/AlertDialog$Builder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    # --- Show ---
    invoke-virtual {v8}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    move-result-object v8

    # --- Limit height to 80% of screen ---
    invoke-virtual {v8}, Landroid/app/AlertDialog;->getWindow()Landroid/view/Window;
    move-result-object v8
    if-eqz v8, :cond_bh_nosize

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v3
    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v3
    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v3
    iget v3, v3, Landroid/util/DisplayMetrics;->heightPixels:I
    mul-int/lit16 v3, v3, 0x4
    div-int/lit16 v3, v3, 0x5    # 80% = 4/5

    const/4 v4, -0x2             # WRAP_CONTENT = -2
    invoke-virtual {v8, v4, v3}, Landroid/view/Window;->setLayout(II)V

    :cond_bh_nosize
    return-void
.end method
