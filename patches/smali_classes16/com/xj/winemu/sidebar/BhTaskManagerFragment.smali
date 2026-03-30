.class public Lcom/xj/winemu/sidebar/BhTaskManagerFragment;
.super Landroidx/fragment/app/Fragment;
.source "SourceFile"

# Wine Task Manager sidebar tab — three-tab UI:
#   Always visible at top: Container Info (device, Android ver, CPU, RAM)
#   Tab 0 "Applications" — Wine infra processes (non-.exe)
#   Tab 1 "Processes"    — Windows .exe processes
#   Tab 2 "Launch"       — file browser rooted at WINEPREFIX; tap drive → browse
#                          directories (yellow ▶) and launchable files (white);
#                          tap a .exe/.msi/.bat/.cmd to launch via Wine
#   Auto-refreshes every 3 seconds while visible (tabs 0/1 only)

.field public appsLayout:Landroid/widget/LinearLayout;
.field public procsLayout:Landroid/widget/LinearLayout;
.field public launchLayout:Landroid/widget/LinearLayout;
.field public currentPathText:Landroid/widget/TextView;
.field public fileListLayout:Landroid/widget/LinearLayout;
.field public wineRootPath:Ljava/lang/String;
.field public currentBrowsePath:Ljava/lang/String;
.field public bhContext:Landroid/content/Context;
.field public handler:Landroid/os/Handler;
.field public autoRefresher:Ljava/lang/Runnable;

# Colors (0xAARRGGBB signed ints):
#   white   = -1          (0xFFFFFFFF)
#   yellow  = -0x3400     (0xFFFFCC00)  section headers
#   lt-gray = -0x555556   (0xFFAAAAAA)  placeholder text

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroidx/fragment/app/Fragment;-><init>()V
    return-void
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

# ── Read VRam limit from SharedPreferences ────────────────────────
# Casts context to WineActivity, reads WineActivityData.a (gameId),
# opens "pc_g_setting<gameId>" SP, reads pc_ls_max_memory (int, MB).
# Returns "1024 MB", "Unlimited" if 0, or "N/A" on error.
.method private static getContainerVramInfo(Landroid/content/Context;)Ljava/lang/String;
    .locals 3
    :try_start_vram
    check-cast p0, Lcom/xj/winemu/WineActivity;
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;
    if-eqz v0, :vram_unlimited
    iget-object v0, v0, Lcom/xj/winemu/api/bean/WineActivityData;->a:Ljava/lang/String;
    if-eqz v0, :vram_unlimited

    # Build "pc_g_setting" + gameId
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "pc_g_setting"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1

    # getSharedPreferences(spName, MODE_PRIVATE=0)
    const/4 v2, 0x0
    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0

    # getInt("pc_ls_max_memory", 0)
    const-string v1, "pc_ls_max_memory"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    move-result v0
    :try_end_vram
    .catch Ljava/lang/Exception; {:try_start_vram .. :try_end_vram} :vram_err

    if-eqz v0, :vram_unlimited

    # Return "XXXX MB"
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v2, " MB"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0

    :vram_unlimited
    const-string v0, "Unlimited"
    return-object v0

    :vram_err
    const-string v0, "N/A"
    return-object v0
.end method

# ── Build the RAM info string ─────────────────────────────────────
# Reads /proc/meminfo for used/total device RAM.
# (No per-container system RAM limit exists; WINEMU_MEMORY_LIMIT is VRam.)
# Returns e.g. "4096 MB used / 7629 MB total"
.method private static getContainerRamInfo()Ljava/lang/String;
    .locals 8
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

    # usedMb = (totalKb - availKb) / 1024; totalMb = totalKb / 1024
    sub-long v4, v0, v2
    const-wide/16 v6, 0x400
    div-long/2addr v4, v6   # v4-v5 = usedMb
    div-long/2addr v0, v6   # v0-v1 = totalMb

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

# ── Read env var from a wine child process's /proc/<pid>/environ ──
# Scans /proc for the first .exe process, reads its environ (which is
# null-byte delimited), and extracts the value for the given key.
# Returns the value string, or null if not found.
.method private static readWineEnv(Ljava/lang/String;)Ljava/lang/String;
    .locals 9
    # v0 = /proc File (temp)
    # v1 = File[] proc entries
    # v2 = array length
    # v3 = loop index
    # v4 = current File entry
    # v5 = pid string / offset-0 const
    # v6 = path string / bytes-read int / indexOf result / key prefix len
    # v7 = byte[] buf / content String / temp int
    # v8 = RAF / FileInputStream / comm string / bool / content String

    new-instance v0, Ljava/io/File;
    const-string v1, "/proc"
    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v1
    if-eqz v1, :not_found
    array-length v2, v1
    const/4 v3, 0x0

    :proc_loop
    if-ge v3, v2, :not_found

    aget-object v4, v1, v3
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v5

    # Skip non-numeric entries (only PID dirs are numeric)
    :try_start_parse
    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    :try_end_parse
    .catch Ljava/lang/NumberFormatException; {:try_start_parse .. :try_end_parse} :next_proc

    # Build /proc/<pid>/comm
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "/proc/"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v7, "/comm"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6

    # Read comm file
    :try_start_comm
    new-instance v8, Ljava/io/RandomAccessFile;
    const-string v7, "r"
    invoke-direct {v8, v6, v7}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v8}, Ljava/io/RandomAccessFile;->readLine()Ljava/lang/String;
    move-result-object v8
    :try_end_comm
    .catch Ljava/lang/Exception; {:try_start_comm .. :try_end_comm} :next_proc

    if-eqz v8, :next_proc
    invoke-virtual {v8}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v8
    invoke-virtual {v8}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;
    move-result-object v8
    const-string v7, ".exe"
    invoke-virtual {v8, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v7
    if-eqz v7, :next_proc

    # Found .exe — build /proc/<pid>/environ path
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "/proc/"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v7, "/environ"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6

    # Read environ as raw bytes (null-byte delimited KEY=VALUE pairs)
    :try_start_env
    const v7, 0x4000
    new-array v7, v7, [B
    new-instance v8, Ljava/io/FileInputStream;
    invoke-direct {v8, v6}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V
    invoke-virtual {v8, v7}, Ljava/io/FileInputStream;->read([B)I
    move-result v6          # v6 = bytes read
    invoke-virtual {v8}, Ljava/io/FileInputStream;->close()V
    :try_end_env
    .catch Ljava/lang/Exception; {:try_start_env .. :try_end_env} :next_proc

    if-lez v6, :next_proc

    # Convert bytes to String (null bytes become \u0000)
    new-instance v8, Ljava/lang/String;
    const/4 v5, 0x0         # offset = 0
    invoke-direct {v8, v7, v5, v6}, Ljava/lang/String;-><init>([BII)V
    # v8 = environ content String

    # Build "KEY=" search prefix
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v5, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, "="
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5   # v5 = "KEY="

    # Find "KEY=" in the environ string
    invoke-virtual {v8, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I
    move-result v6          # v6 = position of "KEY=" (-1 if absent)
    if-ltz v6, :next_proc

    # Advance past "KEY=" to get value start position
    invoke-virtual {v5}, Ljava/lang/String;->length()I
    move-result v7
    add-int/2addr v6, v7   # v6 = value start position

    # Find next null byte (char 0) from value start
    const/4 v7, 0x0
    invoke-virtual {v8, v7, v6}, Ljava/lang/String;->indexOf(II)I
    move-result v7          # v7 = end of value (-1 if no null found)

    if-ltz v7, :value_to_end

    # Extract value[v6 .. v7]
    invoke-virtual {v8, v6, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v0
    return-object v0

    :value_to_end
    invoke-virtual {v8, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v0
    return-object v0

    :next_proc
    add-int/lit8 v3, v3, 0x1
    goto :proc_loop

    :not_found
    const/4 v0, 0x0
    return-object v0
.end method

# ── Build the CPU info string (container-accurate) ────────────────
# Reads WINEMU_CPU_AFFINITY bitmask for assigned cores.
# Returns e.g. "CPU Cores:  4 / 8 total"
.method private static getContainerCpuInfo()Ljava/lang/String;
    .locals 5
    # v0 = affinityStr / result string
    # v1 = assigned cores
    # v2 = total cores (device)
    # v3 = temp bool / int / StringBuilder
    # v4 = temp String

    # Default: use getActiveCores() for both
    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getActiveCores()I
    move-result v1
    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getActiveCores()I
    move-result v2

    # Try WINEMU_CPU_AFFINITY from wine child process environ
    :try_start_0
    const-string v0, "WINEMU_CPU_AFFINITY"
    invoke-static {v0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->readWineEnv(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :build_cpu_str
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z
    move-result v3
    if-nez v3, :build_cpu_str
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v3
    if-eqz v3, :build_cpu_str  # 0 means no limit (all cores)
    invoke-static {v3}, Ljava/lang/Integer;->bitCount(I)I
    move-result v1              # assigned = number of set bits in affinity mask
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :build_cpu_str

    :build_cpu_str
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "CPU Cores:  "
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v4, " / "
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v4, " total"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

# ── Count online CPU cores from /proc/stat ────────────────────────
# Counts lines starting with "cpu" + digit (cpu0, cpu1, ...) which the
# kernel scheduler only emits for cores that are actually online.
.method private static getActiveCores()I
    .locals 5
    const/4 v0, 0x0  # count
    :try_start_0
    new-instance v1, Ljava/io/RandomAccessFile;
    const-string v2, "/proc/stat"
    const-string v3, "r"
    invoke-direct {v1, v2, v3}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    :read_loop
    invoke-virtual {v1}, Ljava/io/RandomAccessFile;->readLine()Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :read_done

    # Need at least 4 chars: "cpu0"
    invoke-virtual {v2}, Ljava/lang/String;->length()I
    move-result v3
    const/4 v4, 0x4
    if-lt v3, v4, :read_loop

    # Must start with "cpu"
    const-string v3, "cpu"
    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v3
    if-eqz v3, :read_loop

    # 4th character must be a digit '0'-'9'
    const/4 v3, 0x3
    invoke-virtual {v2, v3}, Ljava/lang/String;->charAt(I)C
    move-result v3
    const/16 v4, 0x30   # '0'
    if-lt v3, v4, :read_loop
    const/16 v4, 0x39   # '9'
    if-gt v3, v4, :read_loop

    add-int/lit8 v0, v0, 0x1
    goto :read_loop

    :read_done
    invoke-virtual {v1}, Ljava/io/RandomAccessFile;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :err
    return v0
    :err
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

# ── showTab — show one content panel, hide the others ─────────────
# Tab 0 = Applications, Tab 1 = Processes, Tab 2 = Launch
.method public showTab(I)V
    .locals 5
    const/4 v0, 0x0     # VISIBLE
    const/16 v1, 0x8    # GONE

    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->appsLayout:Landroid/widget/LinearLayout;
    iget-object v3, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->procsLayout:Landroid/widget/LinearLayout;
    iget-object v4, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->launchLayout:Landroid/widget/LinearLayout;

    # Hide all three first
    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v3, v1}, Landroid/view/View;->setVisibility(I)V
    if-eqz v4, :show_selected
    invoke-virtual {v4, v1}, Landroid/view/View;->setVisibility(I)V

    :show_selected
    const/4 v1, 0x1
    if-eq p1, v1, :show_procs
    const/4 v1, 0x2
    if-eq p1, v1, :show_launch
    invoke-virtual {v2, v0}, Landroid/view/View;->setVisibility(I)V
    return-void

    :show_procs
    invoke-virtual {v3, v0}, Landroid/view/View;->setVisibility(I)V
    return-void

    :show_launch
    if-eqz v4, :return_launch
    invoke-virtual {v4, v0}, Landroid/view/View;->setVisibility(I)V
    # First-time init: if currentBrowsePath is null, start background init
    iget-object v1, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->currentBrowsePath:Ljava/lang/String;
    if-nez v1, :return_launch
    new-instance v1, Ljava/lang/Thread;
    new-instance v2, Lcom/xj/winemu/sidebar/BhInitLaunchRunnable;
    invoke-direct {v2, p0}, Lcom/xj/winemu/sidebar/BhInitLaunchRunnable;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;)V
    invoke-direct {v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V
    :return_launch
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

    # CPU cores row (container-accurate: WINEMU_CPU_AFFINITY bitmask)
    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getContainerCpuInfo()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Sys RAM row (device-wide /proc/meminfo used/total)
    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getContainerRamInfo()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Sys RAM:     "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # VRam Limit row (from SharedPreferences pc_ls_max_memory via WineActivity.gameId)
    invoke-static {v0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getContainerVramInfo(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "VRam Limit:  "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Device name row
    sget-object v3, Landroid/os/Build;->MODEL:Ljava/lang/String;
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Device:      "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Android version row
    sget-object v3, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "Android:     "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, " (API "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v6, ")"
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
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

    # Button "Launch" (tabIndex=2, weight=1)
    new-instance v4, Landroid/widget/Button;
    invoke-direct {v4, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v5, "Launch"
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v5, -0x1
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setTextColor(I)V
    const/high16 v5, 0x41200000
    invoke-virtual {v4, v5}, Landroid/widget/Button;->setTextSize(F)V
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setAllCaps(Z)V
    new-instance v5, Lcom/xj/winemu/sidebar/BhTabListener;
    const/4 v6, 0x2
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

    # ── LAUNCH tab content (GONE initially) ──────────────────────────
    new-instance v3, Landroid/widget/LinearLayout;
    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v4, 0x1   # VERTICAL
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v4, 0x8  # GONE
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V
    iput-object v3, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->launchLayout:Landroid/widget/LinearLayout;

    # Current path display
    new-instance v4, Landroid/widget/TextView;
    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v5, "/"
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v5, -0x3400    # yellow
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v5, 0x41200000   # 10.0f sp
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v5, 0x4
    const/16 v6, 0x8
    invoke-virtual {v4, v5, v6, v5, v5}, Landroid/widget/TextView;->setPadding(IIII)V
    iput-object v4, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->currentPathText:Landroid/widget/TextView;
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # File list container
    new-instance v4, Landroid/widget/LinearLayout;
    invoke-direct {v4, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v5, 0x1   # VERTICAL
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V
    iput-object v4, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->fileListLayout:Landroid/widget/LinearLayout;
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object v1

    :return_null
    const/4 v0, 0x0
    return-object v0
.end method

# ── browseTo — populate the Launch tab for a given directory path ──
# Called on the main thread.
# p0 = this, p1 = absolute path to browse
.method public browseTo(Ljava/lang/String;)V
    .locals 12
    # v0  = context (bhContext)
    # v1  = temp view / string / bool
    # v2  = fileListLayout
    # v3  = items String[]
    # v4  = array length (also reused as temp int before loop)
    # v5  = loop index
    # v6  = current item string (from array)
    # v7  = temp (bool, int, StringBuilder, string)
    # v8  = absolute item path / dir display name
    # v9  = dir absolute path / wineRootPath / temp
    # v10 = TextView row
    # v11 = click listener

    # Store current path
    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->currentBrowsePath:Ljava/lang/String;

    # Update path display
    iget-object v1, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->currentPathText:Landroid/widget/TextView;
    if-eqz v1, :get_lists
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :get_lists
    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->fileListLayout:Landroid/widget/LinearLayout;
    if-eqz v2, :done
    invoke-virtual {v2}, Landroid/widget/LinearLayout;->removeAllViews()V

    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->bhContext:Landroid/content/Context;
    if-eqz v0, :done

    # ── Up button (only when not at wineRootPath) ─────────────────────
    iget-object v9, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->wineRootPath:Ljava/lang/String;
    if-eqz v9, :no_up
    invoke-virtual {p1, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v7
    if-nez v7, :no_up

    # Parent = p1.substring(0, lastIndexOf('/'))
    const/16 v4, 0x2f    # '/' char code
    invoke-virtual {p1, v4}, Ljava/lang/String;->lastIndexOf(I)I
    move-result v7
    if-lez v7, :no_up
    const/4 v4, 0x0
    invoke-virtual {p1, v4, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v9  # parent path

    new-instance v10, Landroid/widget/TextView;
    invoke-direct {v10, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v7, "\u2191  .."
    invoke-virtual {v10, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v7, -0x3400    # yellow
    invoke-virtual {v10, v7}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v7, 0x41500000  # 13.0f sp
    invoke-virtual {v10, v7}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v7, 0x8
    invoke-virtual {v10, v7, v7, v7, v7}, Landroid/widget/TextView;->setPadding(IIII)V
    new-instance v11, Lcom/xj/winemu/sidebar/BhFolderListener;
    invoke-direct {v11, p0, v9}, Lcom/xj/winemu/sidebar/BhFolderListener;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;Ljava/lang/String;)V
    invoke-virtual {v10, v11}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v2, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :no_up

    # ── List directory ────────────────────────────────────────────────
    invoke-static {p1}, Lapp/revanced/extension/gamehub/BhWineLaunchHelper;->listDir(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v3
    if-eqz v3, :done
    array-length v4, v3
    const/4 v5, 0x0

    :loop
    if-ge v5, v4, :done
    aget-object v6, v3, v5

    # Directory? (entry name ends with "/")
    const-string v7, "/"
    invoke-virtual {v6, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v7
    if-nez v7, :is_dir

    # Launchable file?
    invoke-static {v6}, Lapp/revanced/extension/gamehub/BhWineLaunchHelper;->isLaunchable(Ljava/lang/String;)Z
    move-result v7
    if-eqz v7, :next_item

    # ── Launchable file: white text, ExeLaunchListener ────────────────
    # Absolute path = p1 + "/" + v6
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v7, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v8, "/"
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8  # absolute path

    new-instance v10, Landroid/widget/TextView;
    invoke-direct {v10, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v10, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v7, -0x1       # white
    invoke-virtual {v10, v7}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v7, 0x41500000
    invoke-virtual {v10, v7}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v7, 0x8
    invoke-virtual {v10, v7, v7, v7, v7}, Landroid/widget/TextView;->setPadding(IIII)V
    new-instance v11, Lcom/xj/winemu/sidebar/BhExeLaunchListener;
    invoke-direct {v11, p0, v8}, Lcom/xj/winemu/sidebar/BhExeLaunchListener;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;Ljava/lang/String;)V
    invoke-virtual {v10, v11}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v2, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    goto :next_item

    :is_dir
    # Strip trailing "/" to get display name
    invoke-virtual {v6}, Ljava/lang/String;->length()I
    move-result v7
    add-int/lit8 v7, v7, -0x1
    const/4 v9, 0x0
    invoke-virtual {v6, v9, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v8  # dir name (no trailing slash)

    # Absolute path = p1 + "/" + v8
    new-instance v9, Ljava/lang/StringBuilder;
    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v9, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v7, "/"
    invoke-virtual {v9, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v9  # absolute dir path

    # ── Directory: yellow text with "▶ " prefix, FolderListener ──────
    new-instance v10, Landroid/widget/TextView;
    invoke-direct {v10, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v11, "\u25b6 "
    invoke-virtual {v7, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-virtual {v10, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v7, -0x3400    # yellow
    invoke-virtual {v10, v7}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v7, 0x41500000
    invoke-virtual {v10, v7}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v7, 0x8
    invoke-virtual {v10, v7, v7, v7, v7}, Landroid/widget/TextView;->setPadding(IIII)V
    new-instance v11, Lcom/xj/winemu/sidebar/BhFolderListener;
    invoke-direct {v11, p0, v9}, Lcom/xj/winemu/sidebar/BhFolderListener;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;Ljava/lang/String;)V
    invoke-virtual {v10, v11}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v2, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :next_item
    add-int/lit8 v5, v5, 0x1
    goto :loop

    :done
    return-void
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

# ── onResume — start 3-second auto-refresh loop ──────────────────
.method public onResume()V
    .locals 3
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onResume()V
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v0
    new-instance v1, Landroid/os/Handler;
    invoke-direct {v1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v1, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->handler:Landroid/os/Handler;
    new-instance v2, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$AutoRefreshRunnable;
    invoke-direct {v2, p0, v1}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$AutoRefreshRunnable;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;Landroid/os/Handler;)V
    iput-object v2, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->autoRefresher:Ljava/lang/Runnable;
    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    return-void
.end method

# ── onPause — stop auto-refresh loop ────────────────────────────
.method public onPause()V
    .locals 2
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onPause()V
    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->handler:Landroid/os/Handler;
    if-eqz v0, :no_handler
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V
    :no_handler
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
