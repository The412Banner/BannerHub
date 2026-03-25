.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.super Landroidx/fragment/app/FragmentActivity;

# BannerHub: Epic Games library activity.
# If no stored credentials → starts EpicLoginActivity and finishes.
# Otherwise builds a ScrollView game list and starts a background sync thread ($1).
#
# Fields:
#   gameList  – LinearLayout that $2 appends game cards to
#   syncText  – "Syncing..." TextView hidden by $3 when sync completes


.field public gameList:Landroid/widget/LinearLayout;
.field public syncText:Landroid/widget/TextView;


.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroidx/fragment/app/FragmentActivity;-><init>()V
    return-void
.end method


.method protected onCreate(Landroid/os/Bundle;)V
    .locals 5

    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    # ── Check stored credentials ───────────────────────────────────────────────
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->load(Landroid/content/Context;)Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
    move-result-object v0
    if-nez v0, :have_creds

    # No credentials → launch login activity
    new-instance v0, Landroid/content/Intent;
    const-class v1, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void

    :have_creds

    # ── Build ScrollView → LinearLayout ───────────────────────────────────────
    new-instance v0, Landroid/widget/ScrollView;
    invoke-direct {v0, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    iput-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->gameList:Landroid/widget/LinearLayout;

    # ── Header TextView ────────────────────────────────────────────────────────
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v3, "Epic Games Library"
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/4 v3, -0x1   # 0xFFFFFFFF white
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    const/16 v3, 0x11  # Gravity.CENTER = 17
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V
    const/4 v3, 0x2    # TypedValue.COMPLEX_UNIT_SP = 2
    const/high16 v4, 0x41A00000  # 20.0f
    invoke-virtual {v2, v3, v4}, Landroid/widget/TextView;->setTextSize(IF)V
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── "Syncing..." status TextView ───────────────────────────────────────────
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v3, "Syncing..."
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v3, 0xFFAAAAAA
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V
    iput-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->syncText:Landroid/widget/TextView;
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Attach and display ─────────────────────────────────────────────────────
    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V
    invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V

    # ── Start sync thread ──────────────────────────────────────────────────────
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;
    const-string v3, "https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true"
    invoke-direct {v2, p0, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    new-instance v3, Ljava/lang/Thread;
    invoke-direct {v3, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v3}, Ljava/lang/Thread;->start()V

    return-void
.end method


.method public onBackPressed()V
    .locals 0
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method
