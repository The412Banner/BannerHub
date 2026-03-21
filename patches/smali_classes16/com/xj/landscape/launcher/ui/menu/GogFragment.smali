.class public Lcom/xj/landscape/launcher/ui/menu/GogFragment;
.super Landroidx/fragment/app/Fragment;

# BannerHub: GOG Games tab fragment
# Shows login card or signed-in card based on stored token.
# Auth state stored in SharedPreferences "bh_gog_prefs":
#   access_token, refresh_token, user_id, username


# Saved views for refreshView()
.field public loginCard:Landroid/widget/LinearLayout;
.field public loggedInCard:Landroid/widget/LinearLayout;
.field public usernameView:Landroid/widget/TextView;


.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroidx/fragment/app/Fragment;-><init>()V

    return-void
.end method


# ── dp(int): convert dp → px ─────────────────────────────────────────────────
.method public dp(I)I
    .locals 3

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v1, v0, Landroid/util/DisplayMetrics;->density:F

    int-to-float v2, p1

    mul-float/2addr v2, v1

    float-to-int v2, v2

    return v2
.end method


# ── isLoggedIn(Context): check SharedPreferences for access_token ─────────────
.method public isLoggedIn(Landroid/content/Context;)Z
    .locals 3

    const-string v0, "bh_gog_prefs"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "access_token"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :not_logged_in

    const/4 v0, 0x1

    return v0

    :not_logged_in

    const/4 v0, 0x0

    return v0
.end method


# ── buildLoginCard(Context) ───────────────────────────────────────────────────
.method public buildLoginCard(Landroid/content/Context;)Landroid/widget/LinearLayout;
    .locals 4

    # Root card: dark navy bg, vertical, centered, padded
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const v1, 0xFF1A1A2E

    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V

    const/4 v1, 0x11  # Gravity.CENTER

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v1, 0x28  # 40dp

    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->dp(I)I

    move-result v1

    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/view/View;->setPadding(IIII)V

    # GOG title
    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "GOG.com"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v3, 0x42000000  # 32.0f sp

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const v3, 0xFFFFFFFF  # white

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v3, 0x11  # Gravity.CENTER

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    const/4 v3, 0x0   # null typeface (use default)

    const/4 v1, 0x1   # Typeface.BOLD

    invoke-virtual {v2, v3, v1}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Subtitle
    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "Sign in to access your GOG game library"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v3, 0x41600000  # 14.0f sp

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const v3, 0xFFAAAAAA  # light gray

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v3, 0x11  # Gravity.CENTER

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    const/16 v1, 0x10  # 16dp top margin
    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->dp(I)I
    move-result v1
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v1, -0x2  # WRAP_CONTENT
    invoke-direct {v3, v1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v1, 0x10  # 16dp top margin
    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->dp(I)I
    move-result v1
    iput v1, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Login button
    new-instance v2, Landroid/widget/Button;

    invoke-direct {v2, p1}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v3, "Login with GOG"

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const v3, 0xFF7033FF  # GOG purple

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V

    const v3, 0xFFFFFFFF  # white text

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/GogFragment$1;

    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogFragment;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v1, -0x2  # WRAP_CONTENT
    invoke-direct {v3, v1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v1, 0x18  # 24dp top margin
    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->dp(I)I
    move-result v1
    iput v1, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method


# ── buildLoggedInCard(Context) ────────────────────────────────────────────────
.method public buildLoggedInCard(Landroid/content/Context;)Landroid/widget/LinearLayout;
    .locals 4

    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const v1, 0xFF1A1A2E

    invoke-virtual {v0, v1}, Landroid/view/View;->setBackgroundColor(I)V

    const/4 v1, 0x11  # Gravity.CENTER

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v1, 0x28  # 40dp

    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->dp(I)I

    move-result v1

    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/view/View;->setPadding(IIII)V

    # GOG title
    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "GOG.com"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v3, 0x42000000  # 32.0f sp

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const v3, 0xFFFFFFFF

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v3, 0x11

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    const/4 v3, 0x0

    const/4 v1, 0x1

    invoke-virtual {v2, v3, v1}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Username label — stored in field usernameView for refreshView()
    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, ""

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v3, 0x41600000  # 14.0f sp

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const v3, 0xFFCCCCCC  # light gray

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v3, 0x11

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    iput-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->usernameView:Landroid/widget/TextView;

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v1, -0x2
    invoke-direct {v3, v1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v1, 0x10
    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->dp(I)I
    move-result v1
    iput v1, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Library placeholder
    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "Game library coming soon"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v3, 0x41600000  # 14.0f sp

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const v3, 0xFF888888

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v3, 0x11

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v1, -0x2
    invoke-direct {v3, v1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v1, 0x18
    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->dp(I)I
    move-result v1
    iput v1, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Sign out button
    new-instance v2, Landroid/widget/Button;

    invoke-direct {v2, p1}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v3, "Sign Out"

    invoke-virtual {v2, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const v3, 0xFF444444  # dark button

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V

    const v3, 0xFFFFFFFF

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/GogFragment$2;

    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogFragment;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v1, -0x2
    invoke-direct {v3, v1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v1, 0x28
    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->dp(I)I
    move-result v1
    iput v1, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-object v0
.end method


# ── onCreateView ─────────────────────────────────────────────────────────────
.method public onCreateView(Landroid/view/LayoutInflater;Landroid/view/ViewGroup;Landroid/os/Bundle;)Landroid/view/View;
    .locals 4

    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->getContext()Landroid/content/Context;

    move-result-object v0  # Context

    # Root frame (FrameLayout fills the tab, dark bg)
    new-instance v1, Landroid/widget/FrameLayout;

    invoke-direct {v1, v0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    const v2, 0xFF0D0D0D

    invoke-virtual {v1, v2}, Landroid/view/View;->setBackgroundColor(I)V

    # Build both cards
    invoke-virtual {p0, v0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->buildLoginCard(Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object v2

    iput-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->loginCard:Landroid/widget/LinearLayout;

    invoke-virtual {p0, v0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->buildLoggedInCard(Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object v3

    iput-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->loggedInCard:Landroid/widget/LinearLayout;

    # Add both cards — visibility set in refreshView()
    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v0, -0x1  # MATCH_PARENT

    invoke-direct {v2, v0, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->loginCard:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v3, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v0, -0x1

    invoke-direct {v2, v0, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->loggedInCard:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v3, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Set initial visibility
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->refreshView()V

    return-object v1
.end method


# ── onResume ─────────────────────────────────────────────────────────────────
.method public onResume()V
    .locals 0

    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onResume()V

    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->refreshView()V

    return-void
.end method


# ── refreshView: toggle loginCard / loggedInCard visibility ──────────────────
.method public refreshView()V
    .locals 5

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->loginCard:Landroid/widget/LinearLayout;

    if-eqz v0, :skip

    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->getContext()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :skip

    invoke-virtual {p0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->isLoggedIn(Landroid/content/Context;)Z

    move-result v2

    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->loggedInCard:Landroid/widget/LinearLayout;

    if-eqz v2, :show_login

    # Logged in — show loggedInCard, hide loginCard
    const/4 v4, 0x0  # VISIBLE

    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    const/4 v4, 0x8  # GONE

    invoke-virtual {v0, v4}, Landroid/view/View;->setVisibility(I)V

    # Update username text
    const-string v4, "bh_gog_prefs"

    const/4 v0, 0x0

    invoke-virtual {v1, v4, v0}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v4, "username"

    const-string v1, "Unknown"

    invoke-interface {v0, v4, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0  # username

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Signed in as: "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->usernameView:Landroid/widget/TextView;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :skip

    :show_login

    # Not logged in — show loginCard, hide loggedInCard
    const/4 v4, 0x0  # VISIBLE

    invoke-virtual {v0, v4}, Landroid/view/View;->setVisibility(I)V

    const/4 v4, 0x8  # GONE

    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    :skip

    return-void
.end method
