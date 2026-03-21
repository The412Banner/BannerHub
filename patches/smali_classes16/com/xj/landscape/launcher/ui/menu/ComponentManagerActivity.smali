.class public final Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
.super Landroidx/appcompat/app/AppCompatActivity;

# BannerHub Component Manager — redesigned UI
# Card-based RecyclerView, bottom action buttons, empty state
# Swipe LEFT = remove, Swipe RIGHT = backup

.field public recyclerView:Landroidx/recyclerview/widget/RecyclerView;
.field public adapter:Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;
.field public emptyState:Landroid/view/View;
.field public countBadge:Landroid/widget/TextView;

# State fields (same semantics as before)
.field public components:[Ljava/io/File;
.field public selectedIndex:I
.field public selectedType:I
.field public pendingUri:Landroid/net/Uri;
.field public pendingType:I
.field public mode:I

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V
    return-void
.end method

# ── dp(int): convert dp to pixels ─────────────────────────────────────────────
.method public dp(I)I
    .locals 3
    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v0
    iget v1, v0, Landroid/util/DisplayMetrics;->density:F
    int-to-float v2, p1
    mul-float/2addr v2, v1
    float-to-int v2, v2
    return v2
.end method

# ── onCreate ───────────────────────────────────────────────────────────────────
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 0
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->buildUI()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

# ── buildUI: assemble the whole screen programmatically ───────────────────────
.method public buildUI()V
    .locals 6

    # Root: vertical LinearLayout, black bg, fitsSystemWindows
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    invoke-virtual {v0, v1}, Landroid/view/View;->setFitsSystemWindows(Z)V
    const v1, 0xFF0D0D0D
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V

    # Header
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->buildHeader()Landroid/widget/LinearLayout;
    move-result-object v1
    const/4 v2, -0x1   # MATCH_PARENT
    const/4 v3, -0x2   # WRAP_CONTENT
    invoke-virtual {v0, v1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;II)V

    # Content (RecyclerView + empty state in FrameLayout), weight=1
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->buildContent()Landroid/widget/FrameLayout;
    move-result-object v1
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v2, -0x1
    const/4 v3, 0x0
    const/high16 v5, 0x3f800000  # 1.0f
    invoke-direct {v4, v2, v3, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v0, v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(Landroid/view/View;)V
    return-void
.end method

# ── buildHeader ───────────────────────────────────────────────────────────────
.method public buildHeader()Landroid/widget/LinearLayout;
    .locals 10

    const/16 v8, 0xc    # 12dp
    const/16 v9, 0x10   # 16dp
    invoke-virtual {p0, v8}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v0    # 12px
    invoke-virtual {p0, v9}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v1    # 16px

    new-instance v2, Landroid/widget/LinearLayout;
    invoke-direct {v2, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V   # HORIZONTAL
    const/16 v3, 0x10
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setGravity(I)V       # CENTER_VERTICAL
    const v3, 0xFF161616
    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V
    invoke-virtual {v2, v1, v0, v1, v0}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Back button "←"
    new-instance v3, Landroid/widget/TextView;
    invoke-direct {v3, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v4, "\u2190"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v4, 0x41a00000    # 20sp
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V
    const v4, 0xFFFFFFFF
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhBackListener;
    invoke-direct {v4, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhBackListener;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Spacer 12dp
    new-instance v3, Landroid/view/View;
    invoke-direct {v3, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    const/4 v4, 0x1
    invoke-virtual {v2, v3, v0, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;II)V

    # Title "Component Manager" flex
    new-instance v3, Landroid/widget/TextView;
    invoke-direct {v3, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v4, "Component Manager"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v4, 0x41880000    # 17sp
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V
    const v4, 0xFFFF9800
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, 0x0
    const/4 v6, -0x2
    const/high16 v7, 0x3f800000  # 1.0f
    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Count badge TextView (stored as field)
    new-instance v3, Landroid/widget/TextView;
    invoke-direct {v3, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const/high16 v4, 0x41400000    # 12sp
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V
    const v4, 0xFF888888
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    iput-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->countBadge:Landroid/widget/TextView;

    # Spacer
    new-instance v3, Landroid/view/View;
    invoke-direct {v3, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    const/4 v4, 0x1
    invoke-virtual {v2, v3, v0, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;II)V

    # "+ Add" button in header (orange, compact)
    const-string v3, "+ Add"
    const v4, 0xFFFF9800
    invoke-virtual {p0, v3, v4}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->makeBtn(Ljava/lang/String;I)Landroid/widget/TextView;
    move-result-object v3
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhAddListener;
    invoke-direct {v4, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhAddListener;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # "↓ DL" button in header (orange, compact)
    const-string v3, "\u2193 DL"
    const v4, 0xFFFF9800
    invoke-virtual {p0, v3, v4}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->makeBtn(Ljava/lang/String;I)Landroid/widget/TextView;
    move-result-object v3
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhDownloadListener;
    invoke-direct {v4, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhDownloadListener;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # weight=0.5 flex spacer to shift buttons toward center-right
    new-instance v3, Landroid/view/View;
    invoke-direct {v3, p0}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, 0x0
    const/4 v6, -0x2
    const/high16 v7, 0x3f000000
    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # "✕ All" button (remove all)
    new-instance v3, Landroid/widget/TextView;
    invoke-direct {v3, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v4, "\u2715 All"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v4, 0x41400000    # 12sp
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V
    const v4, 0xFFFF5555
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhRemoveAllListener;
    invoke-direct {v4, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhRemoveAllListener;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object v2
.end method

# ── buildSearchBar ────────────────────────────────────────────────────────────
.method public buildSearchBar()Landroid/widget/EditText;
    .locals 5

    new-instance v0, Landroid/widget/EditText;
    invoke-direct {v0, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const-string v1, "Search components..."
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V
    const v1, 0xFFFFFFFF
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const v1, 0xFF555555
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setHintTextColor(I)V
    const v1, 0xFF1E1E30
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V

    const/16 v1, 0x10   # 16dp
    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v1
    const/16 v2, 0xa    # 10dp
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v2
    invoke-virtual {v0, v1, v2, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    # Single line
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setSingleLine(Z)V

    # TextWatcher
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$7;
    invoke-direct {v1, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$7;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->addTextChangedListener(Landroid/text/TextWatcher;)V

    # Separator line below search
    const v1, 0xFF2A2A4A
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V

    return-object v0
.end method

# ── buildContent: FrameLayout with RecyclerView + empty state ─────────────────
.method public buildContent()Landroid/widget/FrameLayout;
    .locals 8

    new-instance v0, Landroid/widget/FrameLayout;
    invoke-direct {v0, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    # RecyclerView
    new-instance v1, Landroidx/recyclerview/widget/RecyclerView;
    invoke-direct {v1, p0}, Landroidx/recyclerview/widget/RecyclerView;-><init>(Landroid/content/Context;)V
    const v2, 0xFF0D0D0D
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackgroundColor(I)V

    # LinearLayoutManager
    new-instance v2, Landroidx/recyclerview/widget/LinearLayoutManager;
    invoke-direct {v2, p0}, Landroidx/recyclerview/widget/LinearLayoutManager;-><init>(Landroid/content/Context;)V
    invoke-virtual {v1, v2}, Landroidx/recyclerview/widget/RecyclerView;->setLayoutManager(Landroidx/recyclerview/widget/RecyclerView$LayoutManager;)V

    # Padding top/bottom 8dp, clipToPadding=false
    const/16 v2, 0x8
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v2
    invoke-virtual {v1, v2, v2, v2, v2}, Landroidx/recyclerview/widget/RecyclerView;->setPadding(IIII)V
    const/4 v2, 0x0
    invoke-virtual {v1, v2}, Landroid/view/ViewGroup;->setClipToPadding(Z)V

    # Create adapter and attach
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;
    invoke-direct {v2, p0}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    iput-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->adapter:Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;
    invoke-virtual {v1, v2}, Landroidx/recyclerview/widget/RecyclerView;->setAdapter(Landroidx/recyclerview/widget/RecyclerView$Adapter;)V
    iput-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    # Attach swipe callback
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/BhSwipeCallback;
    invoke-direct {v3, p0, v2}, Lcom/xj/landscape/launcher/ui/menu/BhSwipeCallback;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;)V
    new-instance v4, Landroidx/recyclerview/widget/ItemTouchHelper;
    invoke-direct {v4, v3}, Landroidx/recyclerview/widget/ItemTouchHelper;-><init>(Landroidx/recyclerview/widget/ItemTouchHelper$Callback;)V
    invoke-virtual {v4, v1}, Landroidx/recyclerview/widget/ItemTouchHelper;->attachToRecyclerView(Landroidx/recyclerview/widget/RecyclerView;)V

    # Empty state
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->buildEmptyState()Landroid/view/View;
    move-result-object v3
    iput-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->emptyState:Landroid/view/View;

    # Add both to FrameLayout (MATCH_PARENT x MATCH_PARENT)
    const/4 v4, -0x1
    invoke-virtual {v0, v1, v4, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;II)V
    invoke-virtual {v0, v3, v4, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;II)V

    return-object v0
.end method

# ── buildEmptyState ───────────────────────────────────────────────────────────
.method public buildEmptyState()Landroid/view/View;
    .locals 5

    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v1, 0x11
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setGravity(I)V    # CENTER

    # Emoji icon
    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v2, "\uD83D\uDCE6"
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v2, 0x42400000    # 48sp
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v2, 0x11
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setGravity(I)V
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # "No components installed"
    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v2, "No components installed"
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v2, 0x41800000    # 16sp
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V
    const v2, 0xFFCCCCCC
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v2, 0x11
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setGravity(I)V
    const/16 v2, 0x8
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v2
    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # "Tap buttons below to add or download"
    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v2, "Tap the buttons below to add or download components"
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v2, 0x41500000    # 13sp
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextSize(F)V
    const v2, 0xFF888888
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v2, 0x11
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setGravity(I)V
    const/16 v2, 0x20
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v2
    const/4 v3, 0x4
    invoke-virtual {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v3
    invoke-virtual {v1, v2, v3, v2, v3}, Landroid/widget/TextView;->setPadding(IIII)V
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object v0
.end method

# ── buildBottomBar ────────────────────────────────────────────────────────────
.method public buildBottomBar()Landroid/widget/LinearLayout;
    .locals 10

    const/16 v8, 0x8
    invoke-virtual {p0, v8}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v8    # 8dp px
    const/4 v9, 0x6
    invoke-virtual {p0, v9}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v9    # 6dp px

    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V   # HORIZONTAL
    const v1, 0xFF161616
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V
    invoke-virtual {v0, v8, v8, v8, v8}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # "Add New" button (orange, small, left-aligned)
    const-string v1, "+ Add New"
    const v2, 0xFFFF9800
    invoke-virtual {p0, v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->makeBtn(Ljava/lang/String;I)Landroid/widget/TextView;
    move-result-object v1
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhAddListener;
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhAddListener;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    invoke-virtual {v1, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, -0x2
    const/16 v5, 0x20
    invoke-virtual {p0, v5}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v5
    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v3, v8, v9, v8, v9}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v0, v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # "Download" button (orange, small, left-aligned)
    const-string v1, "\u2193 Download"
    const v2, 0xFFFF9800
    invoke-virtual {p0, v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->makeBtn(Ljava/lang/String;I)Landroid/widget/TextView;
    move-result-object v1
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhDownloadListener;
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$BhDownloadListener;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    invoke-virtual {v1, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, -0x2
    const/16 v5, 0x20
    invoke-virtual {p0, v5}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v5
    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v3, v8, v9, v8, v9}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V
    invoke-virtual {v0, v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method

# ── makeBtn(String label, int color) → TextView styled as button ──────────────
.method public makeBtn(Ljava/lang/String;I)Landroid/widget/TextView;
    .locals 5

    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/high16 v1, 0x41600000    # 14sp
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const v1, 0xFFFFFFFF
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v1, 0x11
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setGravity(I)V   # CENTER

    # Rounded background
    new-instance v1, Landroid/graphics/drawable/GradientDrawable;
    invoke-direct {v1}, Landroid/graphics/drawable/GradientDrawable;-><init>()V
    invoke-virtual {v1, p2}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V
    const/16 v2, 0x8
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v2
    int-to-float v2, v2
    invoke-virtual {v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # padding: 8dp H, 4dp V (compact for header)
    const/16 v1, 0x8
    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v1
    const/4 v2, 0x4
    invoke-virtual {p0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->dp(I)I
    move-result v2
    invoke-virtual {v0, v1, v2, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object v0
.end method

# ── showComponents: reload dirs, update adapter and UI ────────────────────────
.method public showComponents()V
    .locals 8

    const/4 v0, 0x0
    iput v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I

    # Scan components dir
    new-instance v1, Ljava/io/File;
    invoke-virtual {p0}, Landroid/app/Activity;->getFilesDir()Ljava/io/File;
    move-result-object v2
    const-string v3, "usr/home/components"
    invoke-direct {v1, v2, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v2

    new-instance v3, Ljava/util/ArrayList;
    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    if-eqz v2, :scan_done
    array-length v4, v2
    const/4 v5, 0x0
    :scan_loop
    if-ge v5, v4, :scan_done
    aget-object v6, v2, v5
    invoke-virtual {v6}, Ljava/io/File;->isDirectory()Z
    move-result v7
    if-eqz v7, :scan_skip
    invoke-interface {v3, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :scan_skip
    add-int/lit8 v5, v5, 0x1
    goto :scan_loop

    :scan_done
    invoke-interface {v3}, Ljava/util/Collection;->size()I
    move-result v4
    new-array v5, v4, [Ljava/io/File;
    invoke-interface {v3, v5}, Ljava/util/Collection;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v5
    check-cast v5, [Ljava/io/File;
    iput-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;

    # Update adapter
    iget-object v6, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->adapter:Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;
    invoke-virtual {v6, v5}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->updateComponents([Ljava/io/File;)V

    # Update empty state visibility
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->updateEmptyState()V

    # Update count badge
    iget-object v6, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->countBadge:Landroid/widget/TextView;
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v4, " installed"
    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

# ── updateEmptyState: show/hide based on adapter item count ───────────────────
.method public updateEmptyState()V
    .locals 3
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->adapter:Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->getItemCount()I
    move-result v0
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->emptyState:Landroid/view/View;
    if-eqz v0, :is_empty
    # has items: show RV, hide empty
    const/4 v0, 0x0
    invoke-virtual {v1, v0}, Landroid/view/View;->setVisibility(I)V   # VISIBLE
    const/16 v0, 0x8
    invoke-virtual {v2, v0}, Landroid/view/View;->setVisibility(I)V   # GONE
    return-void
    :is_empty
    const/16 v0, 0x8
    invoke-virtual {v1, v0}, Landroid/view/View;->setVisibility(I)V   # GONE
    const/4 v0, 0x0
    invoke-virtual {v2, v0}, Landroid/view/View;->setVisibility(I)V   # VISIBLE
    return-void
.end method

# ── onSearchChanged: filter adapter + update empty state ──────────────────────
.method public onSearchChanged(Ljava/lang/String;)V
    .locals 1
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->adapter:Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;
    invoke-virtual {v0, p1}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->filter(Ljava/lang/String;)V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->updateEmptyState()V
    return-void
.end method

# ── showOptionsDialog: AlertDialog with per-component actions ─────────────────
.method public showOptionsDialog(I)V
    .locals 5
    iput p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I

    # Title = component name
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    aget-object v0, v0, p1
    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v0    # name

    # Items array
    const/4 v1, 0x3
    new-array v1, v1, [Ljava/lang/String;
    const/4 v2, 0x0
    const-string v3, "Inject / Replace file..."
    aput-object v3, v1, v2
    const/4 v2, 0x1
    const-string v3, "Backup to Downloads"
    aput-object v3, v1, v2
    const/4 v2, 0x2
    const-string v3, "Remove"
    aput-object v3, v1, v2

    new-instance v2, Landroid/app/AlertDialog$Builder;
    invoke-direct {v2, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    invoke-virtual {v2, v0}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    move-result-object v2

    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$5;
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$5;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    invoke-virtual {v2, v1, v3}, Landroid/app/AlertDialog$Builder;->setItems([Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v2

    const-string v3, "Cancel"
    const/4 v4, 0x0
    invoke-virtual {v2, v3, v4}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v2
    invoke-virtual {v2}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    return-void
.end method

# ── showTypeDialog: AlertDialog to pick component type for new inject ──────────
.method public showTypeDialog()V
    .locals 4

    const/4 v0, 0x5
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "DXVK"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "VKD3D-Proton"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    const-string v2, "Box64"
    aput-object v2, v0, v1
    const/4 v1, 0x3
    const-string v2, "FEXCore"
    aput-object v2, v0, v1
    const/4 v1, 0x4
    const-string v2, "GPU Driver / Turnip"
    aput-object v2, v0, v1

    new-instance v1, Landroid/app/AlertDialog$Builder;
    invoke-direct {v1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    const-string v2, "Select Component Type"
    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    move-result-object v1

    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$6;
    invoke-direct {v2, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$6;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    invoke-virtual {v1, v0, v2}, Landroid/app/AlertDialog$Builder;->setItems([Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v1

    const-string v2, "Cancel"
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v1
    invoke-virtual {v1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    return-void
.end method

# ── removeFiltered(int): called on swipe-left ──────────────────────────────────
.method public removeFiltered(I)V
    .locals 4
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->adapter:Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;
    invoke-virtual {v0, p1}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->getFiltered(I)Ljava/io/File;
    move-result-object v0    # File to remove

    # Find its index in allComponents
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    array-length v2, v1
    const/4 v3, 0x0
    :find_loop
    if-ge v3, v2, :find_done
    aget-object v2, v1, v3
    invoke-virtual {v2, v0}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :found
    add-int/lit8 v3, v3, 0x1
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    array-length v2, v1
    goto :find_loop

    :found
    :find_done
    iput v3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->removeComponent()V
    return-void
.end method

# ── backupFiltered(int): called on swipe-right ─────────────────────────────────
.method public backupFiltered(I)V
    .locals 4
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->adapter:Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;
    invoke-virtual {v0, p1}, Lcom/xj/landscape/launcher/ui/menu/BhComponentAdapter;->getFiltered(I)Ljava/io/File;
    move-result-object v0

    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    array-length v2, v1
    const/4 v3, 0x0
    :find_loop
    if-ge v3, v2, :find_done
    aget-object v2, v1, v3
    invoke-virtual {v2, v0}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :found
    add-int/lit8 v3, v3, 0x1
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    array-length v2, v1
    goto :find_loop

    :found
    :find_done
    iput v3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->backupComponent()V
    return-void
.end method

# ── pickFile ──────────────────────────────────────────────────────────────────
.method public pickFile()V
    .locals 2
    new-instance v0, Landroid/content/Intent;
    const-string v1, "android.intent.action.OPEN_DOCUMENT"
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v1, "android.intent.category.OPENABLE"
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    const-string v1, "*/*"
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;
    const/16 v1, 0x3e9
    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V
    return-void
.end method

# ── getFileName(Uri): resolve display name from ContentResolver ────────────────
.method public getFileName(Landroid/net/Uri;)Ljava/lang/String;
    .locals 6
    # p0=v6(Activity this), p1=v7(Uri)
    invoke-virtual {p0}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0    # v0 = ContentResolver
    move-object v1, p1       # v1 = Uri (MUST come before overwriting v1 with array)
    const/4 v3, 0x1
    new-array v2, v3, [Ljava/lang/String;  # v2 = String[1] (projection)
    const-string v3, "_display_name"
    const/4 v4, 0x0
    aput-object v3, v2, v4   # projection[0] = "_display_name"
    const/4 v3, 0x0          # null selection
    const/4 v4, 0x0          # null selectionArgs
    const/4 v5, 0x0          # null sortOrder
    # v0=ContentResolver, v1=Uri, v2=projection, v3=null, v4=null, v5=null
    invoke-virtual/range {v0 .. v5}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    move-result-object v0
    if-eqz v0, :no_cursor
    invoke-interface {v0}, Landroid/database/Cursor;->moveToFirst()Z
    move-result v1
    if-eqz v1, :close_cursor
    const/4 v1, 0x0
    invoke-interface {v0, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;
    move-result-object v1
    invoke-interface {v0}, Landroid/database/Cursor;->close()V
    return-object v1
    :close_cursor
    invoke-interface {v0}, Landroid/database/Cursor;->close()V
    :no_cursor
    const-string v0, "component_file"
    return-object v0
.end method

# ── backupComponent ────────────────────────────────────────────────────────────
.method public backupComponent()V
    .locals 6
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    aget-object v0, v0, v1
    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v1
    sget-object v2, Landroid/os/Environment;->DIRECTORY_DOWNLOADS:Ljava/lang/String;
    invoke-static {v2}, Landroid/os/Environment;->getExternalStoragePublicDirectory(Ljava/lang/String;)Ljava/io/File;
    move-result-object v2
    new-instance v3, Ljava/io/File;
    const-string v4, "BannerHub"
    invoke-direct {v3, v2, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v4, Ljava/io/File;
    invoke-direct {v4, v3, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v4}, Ljava/io/File;->mkdirs()Z
    :try_start
    invoke-virtual {p0, v0, v4}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->copyDir(Ljava/io/File;Ljava/io/File;)V
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_backup
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Backed up to Downloads/BannerHub/"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    const/4 v4, 0x1
    invoke-static {p0, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v3
    invoke-virtual {v3}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
    :catch_backup
    move-exception v3
    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Backup failed: "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    const/4 v4, 0x1
    invoke-static {p0, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v3
    invoke-virtual {v3}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

# ── copyDir ───────────────────────────────────────────────────────────────────
.method public copyDir(Ljava/io/File;Ljava/io/File;)V
    .locals 9
    invoke-virtual {p2}, Ljava/io/File;->mkdirs()Z
    invoke-virtual {p1}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v0
    if-eqz v0, :copy_done
    array-length v1, v0
    const/4 v2, 0x0
    :copy_loop
    if-ge v2, v1, :copy_done
    aget-object v3, v0, v2
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z
    move-result v4
    if-eqz v4, :copy_file
    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v4
    new-instance v5, Ljava/io/File;
    invoke-direct {v5, p2, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {p0, v3, v5}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->copyDir(Ljava/io/File;Ljava/io/File;)V
    goto :copy_next
    :copy_file
    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v4
    new-instance v5, Ljava/io/File;
    invoke-direct {v5, p2, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v6, Ljava/io/FileInputStream;
    invoke-direct {v6, v3}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    new-instance v7, Ljava/io/FileOutputStream;
    invoke-direct {v7, v5}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    const/16 v8, 0x2000
    new-array v8, v8, [B
    :read_loop
    invoke-virtual {v6, v8}, Ljava/io/InputStream;->read([B)I
    move-result v4
    if-lez v4, :read_done
    const/4 v5, 0x0
    invoke-virtual {v7, v8, v5, v4}, Ljava/io/OutputStream;->write([BII)V
    goto :read_loop
    :read_done
    invoke-virtual {v6}, Ljava/io/InputStream;->close()V
    invoke-virtual {v7}, Ljava/io/OutputStream;->close()V
    :copy_next
    add-int/lit8 v2, v2, 0x1
    goto :copy_loop
    :copy_done
    return-void
.end method

# ── injectFile ────────────────────────────────────────────────────────────────
.method public injectFile(Landroid/net/Uri;)V
    .locals 9
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    aget-object v0, v0, v1
    invoke-virtual {p0}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v3
    move-object v4, p1
    const/4 v5, 0x1
    new-array v5, v5, [Ljava/lang/String;
    const-string v6, "_display_name"
    const/4 v7, 0x0
    aput-object v6, v5, v7
    const/4 v6, 0x0
    const/4 v7, 0x0
    const/4 v8, 0x0
    invoke-virtual/range {v3 .. v8}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    move-result-object v4
    const-string v1, "injected_file"
    if-eqz v4, :no_cursor
    invoke-interface {v4}, Landroid/database/Cursor;->moveToFirst()Z
    move-result v5
    if-eqz v5, :close_cursor
    const/4 v5, 0x0
    invoke-interface {v4, v5}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;
    move-result-object v1
    :close_cursor
    invoke-interface {v4}, Landroid/database/Cursor;->close()V
    :no_cursor
    new-instance v2, Ljava/io/File;
    invoke-direct {v2, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    :try_inject_start
    invoke-virtual {v3, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;
    move-result-object v4
    new-instance v5, Ljava/io/FileOutputStream;
    invoke-direct {v5, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    const/16 v6, 0x2000
    new-array v6, v6, [B
    :inject_read_loop
    invoke-virtual {v4, v6}, Ljava/io/InputStream;->read([B)I
    move-result v7
    if-lez v7, :inject_read_done
    const/4 v8, 0x0
    invoke-virtual {v5, v6, v8, v7}, Ljava/io/OutputStream;->write([BII)V
    goto :inject_read_loop
    :inject_read_done
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V
    invoke-virtual {v5}, Ljava/io/OutputStream;->close()V
    :try_inject_end
    .catch Ljava/lang/Exception; {:try_inject_start .. :try_inject_end} :inject_catch
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Injected: "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    const/4 v5, 0x1
    invoke-static {p0, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v4
    invoke-virtual {v4}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
    :inject_catch
    move-exception v4
    invoke-virtual {v4}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v4
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "Inject failed: "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    const/4 v5, 0x1
    invoke-static {p0, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v4
    invoke-virtual {v4}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

# ── removeComponent ────────────────────────────────────────────────────────────
.method public removeComponent()V
    .locals 6
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    aget-object v0, v0, v1
    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v1
    invoke-static {}, Lcom/xj/winemu/EmuComponents;->e()Lcom/xj/winemu/EmuComponents;
    move-result-object v2
    if-eqz v2, :skip_emu
    iget-object v3, v2, Lcom/xj/winemu/EmuComponents;->a:Ljava/util/HashMap;
    if-eqz v3, :skip_emu
    invoke-virtual {v3, v1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    :skip_emu
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->deleteDir(Ljava/io/File;)V
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "Removed: "
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x1
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

# ── deleteDir (static) ────────────────────────────────────────────────────────
.method public static deleteDir(Ljava/io/File;)V
    .locals 5
    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v0
    if-eqz v0, :delete_self
    array-length v1, v0
    const/4 v2, 0x0
    :del_loop
    if-ge v2, v1, :delete_self
    aget-object v3, v0, v2
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z
    move-result v4
    if-eqz v4, :del_file
    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->deleteDir(Ljava/io/File;)V
    goto :del_next
    :del_file
    invoke-virtual {v3}, Ljava/io/File;->delete()Z
    :del_next
    add-int/lit8 v2, v2, 0x1
    goto :del_loop
    :delete_self
    invoke-virtual {p0}, Ljava/io/File;->delete()Z
    return-void
.end method

# ── checkDuplicate ────────────────────────────────────────────────────────────
.method public checkDuplicate(Landroid/net/Uri;I)V
    .locals 6
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->getComponentName(Landroid/content/Context;Landroid/net/Uri;I)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {p0}, Landroid/app/Activity;->getFilesDir()Ljava/io/File;
    move-result-object v1
    const-string v2, "usr/home/components"
    new-instance v3, Ljava/io/File;
    invoke-direct {v3, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v1, Ljava/io/File;
    invoke-direct {v1, v3, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/io/File;->exists()Z
    move-result v2
    if-eqz v2, :no_dup
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->pendingUri:Landroid/net/Uri;
    iput p2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->pendingType:I
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "\""
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v5, "\" is already installed.\nReplace it?"
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    new-instance v3, Landroid/app/AlertDialog$Builder;
    invoke-direct {v3, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    const-string v5, "Already Installed"
    invoke-virtual {v3, v5}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    move-result-object v3
    invoke-virtual {v3, v4}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    move-result-object v3
    new-instance v5, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$4;
    invoke-direct {v5, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    const-string v4, "Replace"
    invoke-virtual {v3, v4, v5}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v3
    const-string v4, "Cancel"
    const/4 v5, 0x0
    invoke-virtual {v3, v4, v5}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v3
    invoke-virtual {v3}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    return-void
    :no_dup
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->injectComponent(Landroid/content/Context;Landroid/net/Uri;I)V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

# ── confirmRemoveAll ──────────────────────────────────────────────────────────
.method public confirmRemoveAll()V
    .locals 5
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    array-length v1, v2
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Remove all "
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v4, " component(s)?\nThis cannot be undone."
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    new-instance v0, Landroid/app/AlertDialog$Builder;
    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    const-string v4, "Remove All Components"
    invoke-virtual {v0, v4}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    move-result-object v0
    invoke-virtual {v0, v3}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    move-result-object v0
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$3;
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;)V
    const-string v4, "Remove All"
    invoke-virtual {v0, v4, v3}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v0
    const-string v4, "Cancel"
    const/4 v3, 0x0
    invoke-virtual {v0, v4, v3}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    move-result-object v0
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    return-void
.end method

# ── removeAllComponents ────────────────────────────────────────────────────────
.method public removeAllComponents()V
    .locals 8
    invoke-static {}, Lcom/xj/winemu/EmuComponents;->e()Lcom/xj/winemu/EmuComponents;
    move-result-object v0
    const/4 v1, 0x0
    if-eqz v0, :no_emu
    iget-object v1, v0, Lcom/xj/winemu/EmuComponents;->a:Ljava/util/HashMap;
    :no_emu
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    array-length v3, v2
    const/4 v4, 0x0
    :remove_loop
    if-ge v4, v3, :remove_done
    aget-object v5, v2, v4
    new-instance v7, Ljava/io/File;
    const-string v6, ".bh_injected"
    invoke-direct {v7, v5, v6}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v7}, Ljava/io/File;->exists()Z
    move-result v7
    if-eqz v7, :skip_remove
    invoke-virtual {v5}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v6
    if-eqz v1, :skip_unreg
    invoke-virtual {v1, v6}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    :skip_unreg
    invoke-static {v5}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->deleteDir(Ljava/io/File;)V
    :skip_remove
    add-int/lit8 v4, v4, 0x1
    goto :remove_loop
    :remove_done
    const-string v5, "BannerHub components removed"
    const/4 v6, 0x0
    invoke-static {p0, v5, v6}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v5
    invoke-virtual {v5}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

# ── onActivityResult ──────────────────────────────────────────────────────────
.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 3
    invoke-super {p0, p1, p2, p3}, Landroidx/appcompat/app/AppCompatActivity;->onActivityResult(IILandroid/content/Intent;)V
    const/16 v0, 0x3e9
    if-ne p1, v0, :not_our_request
    const/4 v0, -0x1
    if-ne p2, v0, :not_ok
    if-eqz p3, :not_ok
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;
    move-result-object v0
    if-eqz v0, :not_ok
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I
    const/4 v2, 0x3
    if-ne v1, v2, :replace_mode
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedType:I
    invoke-virtual {p0, v0, v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->checkDuplicate(Landroid/net/Uri;I)V
    return-void
    :replace_mode
    invoke-virtual {p0, v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->injectFile(Landroid/net/Uri;)V
    return-void
    :not_ok
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
    :not_our_request
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

# ── onBackPressed ─────────────────────────────────────────────────────────────
.method public onBackPressed()V
    .locals 0
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onBackPressed()V
    return-void
.end method

# ─── Inline click listener inner classes ──────────────────────────────────────
# These are static-like inner classes for the button click listeners in buildHeader/buildBottomBar.
# They live as separate .smali files but are referenced here.
