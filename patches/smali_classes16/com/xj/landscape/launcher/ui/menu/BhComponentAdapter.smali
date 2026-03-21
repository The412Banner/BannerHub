.class public Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;
.super Landroidx/recyclerview/widget/RecyclerView$Adapter;

# RecyclerView adapter for the component list.
# Card layout: colored accent strip | name TextView (flex) | type badge | arrow ›

.field private activity:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
.field private allComponents:[Ljava/io/File;
.field private filteredComponents:[Ljava/io/File;

.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    .locals 1
    invoke-direct {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->activity:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
    const/4 v0, 0x0
    new-array v0, v0, [Ljava/io/File;
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->allComponents:[Ljava/io/File;
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->filteredComponents:[Ljava/io/File;
    return-void
.end method

# ── updateComponents(File[]): replace list, clear filter ──────────────────────
.method public updateComponents([Ljava/io/File;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->allComponents:[Ljava/io/File;
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->filteredComponents:[Ljava/io/File;
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->notifyDataSetChanged()V
    return-void
.end method

# ── filter(String): rebuild filteredComponents from allComponents ──────────────
.method public filter(Ljava/lang/String;)V
    .locals 8
    # p1 = query string

    if-eqz p1, :reset
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z
    move-result v0
    if-nez v0, :reset

    # lowercase query
    invoke-virtual {p1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;
    move-result-object v0   # lower query

    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->allComponents:[Ljava/io/File;
    array-length v2, v1

    new-instance v3, Ljava/util/ArrayList;
    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    const/4 v4, 0x0
    :filter_loop
    if-ge v4, v2, :filter_done
    aget-object v5, v1, v4
    invoke-virtual {v5}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {v6}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;
    move-result-object v6
    invoke-virtual {v6, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v7
    if-eqz v7, :filter_skip
    invoke-interface {v3, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :filter_skip
    add-int/lit8 v4, v4, 0x1
    goto :filter_loop

    :filter_done
    invoke-interface {v3}, Ljava/util/Collection;->size()I
    move-result v4
    new-array v5, v4, [Ljava/io/File;
    invoke-interface {v3, v5}, Ljava/util/Collection;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v5
    check-cast v5, [Ljava/io/File;
    iput-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->filteredComponents:[Ljava/io/File;
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->notifyDataSetChanged()V
    return-void

    :reset
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->allComponents:[Ljava/io/File;
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->filteredComponents:[Ljava/io/File;
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->notifyDataSetChanged()V
    return-void
.end method

# ── getFiltered(int): return filteredComponents[pos] ──────────────────────────
.method public getFiltered(I)Ljava/io/File;
    .locals 1
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->filteredComponents:[Ljava/io/File;
    aget-object v0, v0, p1
    return-object v0
.end method

# ── getItemCount() ────────────────────────────────────────────────────────────
.method public getItemCount()I
    .locals 1
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->filteredComponents:[Ljava/io/File;
    array-length v0, v0
    return v0
.end method

# ── onItemTapped(int adapterPos): find real index in allComponents, show dialog
.method public onItemTapped(I)V
    .locals 5
    # p1 = adapter position in filteredComponents
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->filteredComponents:[Ljava/io/File;
    aget-object v0, v0, p1    # filteredFile

    # find index in allComponents
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->allComponents:[Ljava/io/File;
    array-length v2, v1
    const/4 v3, 0x0
    const/4 v4, 0x0

    :find_loop
    if-ge v3, v2, :find_done
    aget-object v4, v1, v3
    invoke-virtual {v4, v0}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-nez v4, :found
    add-int/lit8 v3, v3, 0x1
    goto :find_loop

    :found
    # v3 = real index
    :find_done
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->activity:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
    invoke-virtual {v1, v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showOptionsDialog(I)V
    return-void
.end method

# ── getTypeName(String name) ──────────────────────────────────────────────────
.method public static getTypeName(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;
    move-result-object v0

    const-string v1, "dxvk"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-eqz v1, :not_dxvk
    const-string v1, "DXVK"
    return-object v1

    :not_dxvk
    const-string v1, "vkd3d"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-eqz v1, :not_vkd3d
    const-string v1, "VKD3D"
    return-object v1

    :not_vkd3d
    const-string v1, "box64"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-eqz v1, :not_box64
    const-string v1, "Box64"
    return-object v1

    :not_box64
    const-string v1, "fex"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-eqz v1, :not_fex
    const-string v1, "FEX"
    return-object v1

    :not_fex
    const-string v1, "turnip"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :is_gpu
    const-string v1, "vulkan"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :is_gpu
    const-string v1, "adreno"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :is_gpu
    const-string v1, "driver"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :is_gpu
    const-string v1, "gpu"
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v1
    if-eqz v1, :not_gpu

    :is_gpu
    const-string v1, "GPU"
    return-object v1

    :not_gpu
    const-string v1, "WCP"
    return-object v1
.end method

# ── getTypeColor(String typeName) ─────────────────────────────────────────────
.method public static getTypeColor(Ljava/lang/String;)I
    .locals 1
    const-string v0, "DXVK"
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :not_dxvk
    const v0, 0xFF4D8FFF
    return v0

    :not_dxvk
    const-string v0, "VKD3D"
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :not_vkd3d
    const v0, 0xFF9B59B6
    return v0

    :not_vkd3d
    const-string v0, "Box64"
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :not_box64
    const v0, 0xFF47B24F
    return v0

    :not_box64
    const-string v0, "FEX"
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :not_fex
    const v0, 0xFFE67E22
    return v0

    :not_fex
    const-string v0, "GPU"
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :not_gpu
    const v0, 0xFFF0C140
    return v0

    :not_gpu
    const v0, 0xFF888E99
    return v0
.end method

# ── onCreateViewHolder: build card view programmatically ──────────────────────
.method public onCreateViewHolder(Landroid/view/ViewGroup;I)Landroidx/recyclerview/widget/RecyclerView$ViewHolder;
    .locals 13
    # p0=v13(adapter/this)  p1=v14(parent ViewGroup)  p2=v15(viewType int)
    # All params v13-v15 are in range. Locals: v0-v12.
    #
    # Stable refs kept alive until ViewHolder constructor:
    #   v7 = card LinearLayout (itemView)
    #   v8 = accentStrip View
    #   v9 = nameText TextView
    #   v10 = typeBadge TextView
    #   v11 = badgeBg GradientDrawable
    # Temps: v0=ctx, v1=activity, v2=temp, v3=4dp, v4=8dp, v5=12dp, v6=36dp, v12=temp GD/LP

    # v0 = context (from parent ViewGroup)
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v0

    # v1 = activity (for dp() calls)
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->activity:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;

    # Compute dp values
    const/4 v2, 0x4
    invoke-virtual {v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v3    # v3 = 4dp px

    const/16 v2, 0x8
    invoke-virtual {v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v4    # v4 = 8dp px

    const/16 v2, 0xc
    invoke-virtual {v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v5    # v5 = 12dp px

    const/16 v2, 0x24
    invoke-virtual {v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v6    # v6 = 36dp px

    # ── v7 = outer card: horizontal LinearLayout ──────────────────────────────
    new-instance v7, Landroid/widget/LinearLayout;
    invoke-direct {v7, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x0
    invoke-virtual {v7, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V    # HORIZONTAL
    const/16 v2, 0x10
    invoke-virtual {v7, v2}, Landroid/widget/LinearLayout;->setGravity(I)V        # CENTER_VERTICAL

    # Card background: dark rounded rect (temp GD in v12)
    new-instance v12, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v12}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    const v2, 0xFF252535
    invoke-virtual {v12, v2}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    int-to-float v2, v4    # 8dp as float for corner radius
    invoke-virtual {v12, v2}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v7, v12}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # Card padding: 12dp all sides
    invoke-virtual {v7, v5, v5, v5, v5}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Card LayoutParams: MATCH_PARENT x WRAP_CONTENT, margins 12/8/12/8 (8dp top+bottom gap between cards)
    new-instance v12, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, -0x1    # MATCH_PARENT
    const/4 v1, -0x2    # WRAP_CONTENT (temporarily reuse v1)
    invoke-direct {v12, v2, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v12, v5, v4, v5, v4}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v7, v12}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    # Restore v1 = activity (overwritten above)
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->activity:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;

    # ── v8 = accent strip View ────────────────────────────────────────────────
    new-instance v8, Landroid/view/View;
    invoke-direct {v8, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    # Accent strip GD: temp in v12 (only needed to set background, not stored in ViewHolder)
    new-instance v12, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v12}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    int-to-float v2, v3    # 4dp as float for corner radius
    invoke-virtual {v12, v2}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v8, v12}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # Accent strip LayoutParams: 4dp wide x 36dp tall, right margin 12dp
    new-instance v12, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v12, v3, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/4 v2, 0x0
    invoke-virtual {v12, v2, v2, v5, v2}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v7, v8, v12}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Text column LinearLayout (temp in v12 until added to card) ────────────
    new-instance v12, Landroid/widget/LinearLayout;
    invoke-direct {v12, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v12, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V    # VERTICAL

    # ── v9 = name TextView ────────────────────────────────────────────────────
    new-instance v9, Landroid/widget/TextView;
    invoke-direct {v9, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const/high16 v2, 0x41700000    # 15sp
    invoke-virtual {v9, v2}, Landroid/widget/TextView;->setTextSize(F)V
    const v2, 0xFFFFFFFF
    invoke-virtual {v9, v2}, Landroid/widget/TextView;->setTextColor(I)V
    const/4 v2, 0x1
    invoke-virtual {v9, v2}, Landroid/widget/TextView;->setMaxLines(I)V
    sget-object v2, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;
    invoke-virtual {v9, v2}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V
    invoke-virtual {v12, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── v10 = type badge TextView ─────────────────────────────────────────────
    new-instance v10, Landroid/widget/TextView;
    invoke-direct {v10, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const/high16 v2, 0x41300000    # 11sp
    invoke-virtual {v10, v2}, Landroid/widget/TextView;->setTextSize(F)V

    # ── v11 = badge background GradientDrawable ────────────────────────────────
    new-instance v11, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v11}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    int-to-float v2, v3    # 4dp as float for corner radius
    invoke-virtual {v11, v2}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v10, v11}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # Badge padding: 6dp / 4dp / 6dp / 4dp
    const/16 v2, 0x6
    invoke-virtual {v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v2    # 6dp px
    invoke-virtual {v10, v2, v3, v2, v3}, Landroid/widget/TextView;->setPadding(IIII)V

    # Badge LayoutParams: WRAP_CONTENT x WRAP_CONTENT, top margin = 4dp (v3)
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v1, -0x2    # WRAP_CONTENT
    invoke-direct {v2, v1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/4 v1, 0x0
    invoke-virtual {v2, v1, v3, v1, v1}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v12, v10, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Text column LayoutParams: width=0 height=WRAP_CONTENT weight=1.0f
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v1, 0x0
    const/4 v6, -0x2    # WRAP_CONTENT (reuse v6, 36dp no longer needed)
    const/high16 v3, 0x3f800000    # 1.0f (reuse v3, 4dp no longer needed)
    invoke-direct {v2, v1, v6, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v7, v12, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Arrow TextView (temp in v2) ───────────────────────────────────────────
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v1, "\u203a"
    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41a00000    # 20sp
    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const v1, 0xFF666666
    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v7, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Set RecyclerView.LayoutParams on card: MATCH_PARENT x WRAP_CONTENT
    new-instance v2, Landroidx/recyclerview/widget/RecyclerView$LayoutParams;
    const/4 v1, -0x1    # MATCH_PARENT
    const/4 v3, -0x2    # WRAP_CONTENT
    invoke-direct {v2, v1, v3}, Landroidx/recyclerview/widget/RecyclerView$LayoutParams;-><init>(II)V
    invoke-virtual {v7, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    # Make card focusable so D-pad can highlight it
    const/4 v0, 0x1
    invoke-virtual {v7, v0}, Landroid/view/View;->setFocusable(Z)V

    # Foreground StateListDrawable: focused=orange tint, pressed=dark overlay, default=transparent
    new-instance v0, Landroid/graphics/drawable/StateListDrawable;
    invoke-direct {v0}, Landroid/graphics/drawable/StateListDrawable;-><init>()V

    # focused → orange overlay
    const/4 v12, 0x1
    new-array v1, v12, [I
    const v2, 0x0101009c
    const/4 v12, 0x0
    aput v2, v1, v12
    new-instance v2, Landroid/graphics/drawable/ColorDrawable;
    const v3, 0x60FF9800
    invoke-direct {v2, v3}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v0, v1, v2}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    # pressed → dark overlay
    const/4 v12, 0x1
    new-array v1, v12, [I
    const v2, 0x010100a7
    const/4 v12, 0x0
    aput v2, v1, v12
    new-instance v2, Landroid/graphics/drawable/ColorDrawable;
    const v3, 0x40000000
    invoke-direct {v2, v3}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v0, v1, v2}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    # default → transparent
    const/4 v12, 0x0
    new-array v1, v12, [I
    new-instance v2, Landroid/graphics/drawable/ColorDrawable;
    const v3, 0x00000000
    invoke-direct {v2, v3}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v0, v1, v2}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    invoke-virtual {v7, v0}, Landroid/view/View;->setForeground(Landroid/graphics/drawable/Drawable;)V

    # ── Assemble ViewHolder: move to consecutive v0..v6 ───────────────────────
    # Constructor: <init>(adapter, itemView, accentStrip, nameText, typeBadge, badgeBg)
    move-object v2, v7     # itemView (card) → v2
    move-object v3, v8     # accentStrip → v3
    move-object v4, v9     # nameText → v4
    move-object v5, v10    # typeBadge → v5
    move-object v6, v11    # badgeBg → v6
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter$ViewHolder;
    move-object v1, p0     # adapter → v1
    invoke-direct/range {v0 .. v6}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter$ViewHolder;-><init>(Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;Landroid/view/View;Landroid/view/View;Landroid/widget/TextView;Landroid/widget/TextView;Landroid/graphics/drawable/GradientDrawable;)V
    return-object v0
.end method

# ── onBindViewHolder ──────────────────────────────────────────────────────────
.method public onBindViewHolder(Landroidx/recyclerview/widget/RecyclerView$ViewHolder;I)V
    .locals 6
    # p1=ViewHolder  p2=position
    check-cast p1, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter$ViewHolder;

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->filteredComponents:[Ljava/io/File;
    aget-object v0, v0, p2    # File at position

    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v1    # name

    invoke-static {v1}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->getTypeName(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2    # typeName

    invoke-static {v2}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->getTypeColor(Ljava/lang/String;)I
    move-result v3    # typeColor

    # Set name
    iget-object v4, p1, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter$ViewHolder;->nameText:Landroid/widget/TextView;
    invoke-virtual {v4, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Set type badge text + color
    iget-object v4, p1, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter$ViewHolder;->typeBadge:Landroid/widget/TextView;
    invoke-virtual {v4, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    invoke-virtual {v4, v3}, Landroid/widget/TextView;->setTextColor(I)V

    # Badge background: (typeColor & 0x00FFFFFF) | 0x33000000
    const v5, 0x00FFFFFF
    and-int/2addr v5, v3
    const v4, 0x33000000
    or-int/2addr v5, v4
    iget-object v4, p1, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter$ViewHolder;->badgeBg:Landroid/graphics/drawable/GradientDrawable;
    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    # Accent strip color
    iget-object v4, p1, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter$ViewHolder;->accentStrip:Landroid/view/View;
    invoke-virtual {v4, v3}, Landroid/view/View;->setBackgroundColor(I)V

    return-void
.end method
