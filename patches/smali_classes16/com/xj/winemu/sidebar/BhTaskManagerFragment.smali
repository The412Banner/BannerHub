.class public Lcom/xj/winemu/sidebar/BhTaskManagerFragment;
.super Landroidx/fragment/app/Fragment;
.source "SourceFile"

# Wine Task Manager sidebar tab — two-tab UI:
#   Always visible at top: Container Info (CPU cores, RAM, VRAM)
#   Tab 0 "Applications" — Wine infra processes (non-.exe)
#   Tab 1 "Processes"    — Windows .exe processes

.field public appsLayout:Landroid/widget/LinearLayout;
.field public procsLayout:Landroid/widget/LinearLayout;
.field public bhContext:Landroid/content/Context;

# Colors (0xAARRGGBB signed ints):
#   white   = -1          (0xFFFFFFFF)
#   yellow  = -0x3400     (0xFFFFCC00)  section headers
#   lt-gray = -0x555556   (0xFFAAAAAA)  placeholder text

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroidx/fragment/app/Fragment;-><init>()V
    return-void
.end method

# ── Read first line of a file; returns null on error ─────────────
.method private static readFileLine(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    :try_start_0
    new-instance v0, Ljava/io/RandomAccessFile;
    const-string v1, "r"
    invoke-direct {v0, p0, v1}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->readLine()Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->close()V
    return-object v1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :err
    :err
    const/4 v0, 0x0
    return-object v0
.end method

# ── Parse kB value from a /proc/meminfo line ─────────────────────
# e.g. "MemTotal:       7861248 kB" -> 7861248L
.method private static parseMemKb(Ljava/lang/String;)J
    .locals 4
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
    const-string v1, "\\s+"
    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v0
    const/4 v1, 0x1
    aget-object v0, v0, v1
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v2
    return-wide v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :err
    :err
    const-wide/16 v0, 0x0
    return-wide v0
.end method

# ── Build the RAM info string ────────────────────────────────────
# Returns e.g. "4096 MB used / 7629 MB total"
.method private static getRamInfo()Ljava/lang/String;
    .locals 10
    const-wide/16 v0, 0x0   # totalKb
    const-wide/16 v2, 0x0   # availKb

    :try_start_0
    new-instance v4, Ljava/io/RandomAccessFile;
    const-string v5, "/proc/meminfo"
    const-string v6, "r"
    invoke-direct {v4, v5, v6}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    :read_loop
    invoke-virtual {v4}, Ljava/io/RandomAccessFile;->readLine()Ljava/lang/String;
    move-result-object v5
    if-eqz v5, :read_done

    const-string v6, "MemTotal:"
    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v6
    if-eqz v6, :check_avail
    invoke-static {v5}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->parseMemKb(Ljava/lang/String;)J
    move-result-wide v0
    goto :read_loop

    :check_avail
    const-string v6, "MemAvailable:"
    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v6
    if-eqz v6, :read_loop
    invoke-static {v5}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->parseMemKb(Ljava/lang/String;)J
    move-result-wide v2
    goto :read_done

    :read_done
    invoke-virtual {v4}, Ljava/io/RandomAccessFile;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :ram_err

    # usedKb = totalKb - availKb; convert to MB
    sub-long v4, v0, v2
    const-wide/16 v6, 0x400
    div-long/2addr v4, v6
    div-long/2addr v0, v6

    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v6, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    const-string v7, " MB used / "
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    const-string v7, " MB total"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0

    :ram_err
    const-string v0, "N/A"
    return-object v0
.end method

# ── Build the VRAM info string ────────────────────────────────────
# Reads from Qualcomm KGSL sysfs; falls back to "N/A"
.method private static getVramInfo()Ljava/lang/String;
    .locals 4
    const-string v0, "/sys/class/kgsl/kgsl-3d0/gpumem_mapped"
    invoke-static {v0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->readFileLine(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :try_gpu_total

    :try_start_0
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0
    const-wide/32 v2, 0x100000  # 1 MB = 1048576
    div-long/2addr v0, v2
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    const-string v3, " MB (mapped)"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :try_gpu_total

    :try_gpu_total
    const-string v0, "/sys/class/kgsl/kgsl-3d0/gpumem_alloc"
    invoke-static {v0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->readFileLine(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :vram_na
    :try_start_1
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0
    const-wide/32 v2, 0x100000
    div-long/2addr v0, v2
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    const-string v3, " MB (alloc)"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :vram_na

    :vram_na
    const-string v0, "N/A"
    return-object v0
.end method

# ── Count online CPU cores ────────────────────────────────────────
.method private static getActiveCores()I
    .locals 5
    const/4 v0, 0x0  # active count
    const/4 v1, 0x0  # core index

    :core_loop
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "/sys/devices/system/cpu/cpu"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v3, "/online"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2

    invoke-static {v2}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->readFileLine(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :cores_done

    :try_start_0
    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v2
    const-string v3, "1"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :next_core
    add-int/lit8 v0, v0, 0x1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :next_core

    :next_core
    add-int/lit8 v1, v1, 0x1
    const/16 v3, 0x20
    if-lt v1, v3, :core_loop

    :cores_done
    add-int/lit8 v0, v0, 0x1  # cpu0 has no "online" file, always on
    return v0
.end method

# ── Helper: plain info-row TextView ──────────────────────────────
.method private static makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .locals 3
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v1, -0x1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v1, 0x41500000   # 13.0f sp
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v1, 0x6
    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/TextView;->setPadding(IIII)V
    return-object v0
.end method

# ── Helper: section header TextView ──────────────────────────────
.method private static makeHeaderText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .locals 3
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v1, -0x3400    # yellow
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v1, 0x41600000   # 14.0f sp
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v1, 0x4
    const/16 v2, 0xC
    invoke-virtual {v0, v1, v2, v1, v1}, Landroid/widget/TextView;->setPadding(IIII)V
    return-object v0
.end method

# ── showTab — show one content panel, hide the other ─────────────
.method public showTab(I)V
    .locals 4
    const/4 v0, 0x0     # VISIBLE
    const/16 v1, 0x8    # GONE

    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->appsLayout:Landroid/widget/LinearLayout;
    iget-object v3, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->procsLayout:Landroid/widget/LinearLayout;

    # Hide both first
    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v3, v1}, Landroid/view/View;->setVisibility(I)V

    # Show selected (default: tab 0 = Applications)
    const/4 v1, 0x1
    if-eq p1, v1, :show_procs
    invoke-virtual {v2, v0}, Landroid/view/View;->setVisibility(I)V
    return-void

    :show_procs
    invoke-virtual {v3, v0}, Landroid/view/View;->setVisibility(I)V
    return-void
.end method

# ── onCreateView ─────────────────────────────────────────────────
# Builds:
#   ScrollView
#     LinearLayout (vertical root)
#       Container Info (always visible): header + CPU/RAM/VRAM rows
#       LinearLayout (tab bar, horizontal)
#         Button "Applications" (weight=1, tabIndex=0)
#         Button "Processes"    (weight=1, tabIndex=1)
#         Button "↺"            (refresh)
#       appsLayout  (LinearLayout, VISIBLE)
#       procsLayout (LinearLayout, GONE)
.method public onCreateView(Landroid/view/LayoutInflater;Landroid/view/ViewGroup;Landroid/os/Bundle;)Landroid/view/View;
    .locals 8
    # v0 = context
    # v1 = ScrollView (returned)
    # v2 = root vertical LinearLayout
    # v3 = tab bar / sub-layout / temp
    # v4 = button / temp view
    # v5 = listener / LP / temp
    # v6 = LP weight / temp float / temp int
    # v7 = LP height / temp

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;
    move-result-object v0
    if-eqz v0, :return_null

    iput-object v0, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->bhContext:Landroid/content/Context;

    # Root ScrollView
    new-instance v1, Landroid/widget/ScrollView;
    invoke-direct {v1, v0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    # Vertical content LinearLayout
    new-instance v2, Landroid/widget/LinearLayout;
    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v3, 0x1
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v3, 0x10   # 16px padding
    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Add content to ScrollView
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v4, -0x1   # MATCH_PARENT
    const/4 v5, -0x2   # WRAP_CONTENT
    invoke-direct {v3, v4, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v2, v3}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── CONTAINER INFO (always visible at top) ────────────────────────
    const-string v3, "Container Info"
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeHeaderText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # CPU cores row
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v3
    invoke-virtual {v3}, Ljava/lang/Runtime;->availableProcessors()I
    move-result v3   # total cores
    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getActiveCores()I
    move-result v4   # active cores
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "CPU Cores:  "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v6, " active / "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v6, " total"
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # RAM row
    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getRamInfo()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "RAM:         "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # VRAM row
    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getVramInfo()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "VRAM:        "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── TAB BAR (horizontal) ─────────────────────────────────────────
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v4, 0x0   # HORIZONTAL
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    # Button "Applications" (tabIndex=0, weight=1)
    new-instance v4, Landroid/widget/Button;
    invoke-direct {v4, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v5, "Applications"
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v5, -0x1
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setTextColor(I)V
    const/high16 v5, 0x41200000   # 10.0f sp
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setTextSize(F)V
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setAllCaps(Z)V
    new-instance v5, Lcom/xj/winemu/sidebar/BhTabListener;
    const/4 v6, 0x0
    invoke-direct {v5, p0, v6}, Lcom/xj/winemu/sidebar/BhTabListener;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;I)V
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v6, 0x0
    const/4 v7, -0x2
    invoke-direct {v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v6, 0x3f800000   # 1.0f weight
    iput v6, v5, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v3, v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Button "Processes" (tabIndex=1, weight=1)
    new-instance v4, Landroid/widget/Button;
    invoke-direct {v4, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v5, "Processes"
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v5, -0x1
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setTextColor(I)V
    const/high16 v5, 0x41200000
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setTextSize(F)V
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setAllCaps(Z)V
    new-instance v5, Lcom/xj/winemu/sidebar/BhTabListener;
    const/4 v6, 0x1
    invoke-direct {v5, p0, v6}, Lcom/xj/winemu/sidebar/BhTabListener;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;I)V
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v6, 0x0
    const/4 v7, -0x2
    invoke-direct {v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v6, 0x3f800000
    iput v6, v5, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v3, v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Button "↺" (Refresh, no weight — fixed size)
    new-instance v4, Landroid/widget/Button;
    invoke-direct {v4, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v5, "\u21ba"
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v5, -0x1
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setTextColor(I)V
    new-instance v5, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$RefreshListener;
    invoke-direct {v5, p0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$RefreshListener;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;)V
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── APPLICATIONS tab content (VISIBLE initially) ──────────────────
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v4, 0x1   # VERTICAL
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V
    iput-object v3, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->appsLayout:Landroid/widget/LinearLayout;
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── PROCESSES tab content (GONE initially) ────────────────────────
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v4, 0x1
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v4, 0x8   # GONE
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V
    iput-object v3, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->procsLayout:Landroid/widget/LinearLayout;
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Kick off initial scan (populates appsLayout + procsLayout)
    invoke-virtual {p0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->startScan()V

    return-object v1

    :return_null
    const/4 v0, 0x0
    return-object v0
.end method

# ── startScan ────────────────────────────────────────────────────
.method public startScan()V
    .locals 2
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$ScanRunnable;
    invoke-direct {v1, p0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$ScanRunnable;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;)V
    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V
    return-void
.end method

# ── onScanComplete — called on main thread ───────────────────────
# p1 = ArrayList<String> names, p2 = ArrayList<Integer> pids
# Splits into appsLayout (.exe) and procsLayout (wine* infra)
.method public onScanComplete(Ljava/util/ArrayList;Ljava/util/ArrayList;)V
    .locals 13
    # v0  = appsLayout
    # v1  = procsLayout
    # v2  = context
    # v3  = list size
    # v4  = loop index
    # v5  = name (String)
    # v6  = pid (int)
    # v7  = row LinearLayout
    # v8  = name TextView
    # v9  = StringBuilder / temp
    # v10 = temp string / LP height arg (reused)
    # v11 = Kill Button
    # v12 = LP for name TextView / KillListener / isExe (reused)

    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->appsLayout:Landroid/widget/LinearLayout;
    if-eqz v0, :done
    iget-object v1, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->procsLayout:Landroid/widget/LinearLayout;
    if-eqz v1, :done
    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->bhContext:Landroid/content/Context;
    if-eqz v2, :done

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->removeAllViews()V
    invoke-virtual {v1}, Landroid/widget/LinearLayout;->removeAllViews()V

    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I
    move-result v3

    const/4 v4, 0x0   # loop index
    :proc_loop
    if-ge v4, v3, :post_loop

    invoke-virtual {p1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v5
    check-cast v5, Ljava/lang/String;

    invoke-virtual {p2, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v6
    check-cast v6, Ljava/lang/Integer;
    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I
    move-result v6

    # Build row: horizontal LinearLayout
    new-instance v7, Landroid/widget/LinearLayout;
    invoke-direct {v7, v2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v8, 0x0   # HORIZONTAL
    invoke-virtual {v7, v8}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v8, 0x10  # CENTER_VERTICAL
    invoke-virtual {v7, v8}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/4 v8, 0x4
    invoke-virtual {v7, v8, v8, v8, v8}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Process name TextView (weight=1)
    new-instance v8, Landroid/widget/TextView;
    invoke-direct {v8, v2}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    new-instance v9, Ljava/lang/StringBuilder;
    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v9, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v10, "  (PID "
    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v10, ")"
    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v9
    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v9, -0x1
    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v9, 0x41400000   # 12.0f sp
    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setTextSize(F)V
    new-instance v12, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v9, 0x0
    const/4 v10, -0x2
    invoke-direct {v12, v9, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v9, 0x3f800000
    iput v9, v12, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v7, v8, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Kill button
    new-instance v11, Landroid/widget/Button;
    invoke-direct {v11, v2}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v9, "Kill"
    invoke-virtual {v11, v9}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v9, -0x1
    invoke-virtual {v11, v9}, Landroid/widget/Button;->setTextColor(I)V
    const/high16 v9, 0x41400000
    invoke-virtual {v11, v9}, Landroid/widget/Button;->setTextSize(F)V
    new-instance v12, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$KillListener;
    invoke-direct {v12, v6, p0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$KillListener;-><init>(ILcom/xj/winemu/sidebar/BhTaskManagerFragment;)V
    invoke-virtual {v11, v12}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v7, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Route row: .exe Windows processes → procsLayout; Wine infra (non-.exe) → appsLayout
    const-string v9, ".exe"
    invoke-virtual {v5, v9}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v12
    if-nez v12, :add_to_procs
    invoke-virtual {v0, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    goto :next_proc
    :add_to_procs
    invoke-virtual {v1, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :next_proc
    add-int/lit8 v4, v4, 0x1
    goto :proc_loop

    :post_loop
    # Placeholder for empty apps list
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getChildCount()I
    move-result v3
    if-nez v3, :check_procs
    const-string v3, "No Wine processes running"
    invoke-static {v2, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    const v4, -0x555556    # gray
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :check_procs
    invoke-virtual {v1}, Landroid/widget/LinearLayout;->getChildCount()I
    move-result v3
    if-nez v3, :done
    const-string v3, "No Windows processes running"
    invoke-static {v2, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    const v4, -0x555556    # gray
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :done
    return-void
.end method
