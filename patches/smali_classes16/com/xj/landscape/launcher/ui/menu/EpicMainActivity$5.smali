.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# BannerHub: "Install" button OnClickListener for Epic game cards.
# Gets appName/ns/catId from the card ($2) instance.
# On click: builds installDir, shows AlertDialog.
# Positive "Install" → $9 (transitions card to loading state) → $7 (download thread).
# Cancel → no card state change.

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 10

    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v6, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;

    # Extract appName, namespace, catalogItemId from card
    iget-object v2, v6, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->appName:Ljava/lang/String;
    iget-object v3, v6, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->namespace:Ljava/lang/String;
    iget-object v4, v6, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->catalogItemId:Ljava/lang/String;

    # Build installDir = getFilesDir()/epic_games/{appName}
    # NOTE: visibility changes (hide addBtn, show progressBar+statusTV) moved to
    # $9.onClick() so Cancel leaves the card unchanged.
    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v7
    const-string v8, "epic_games"
    new-instance v5, Ljava/io/File;
    invoke-direct {v5, v7, v8}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v7, Ljava/io/File;
    invoke-direct {v7, v5, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v7}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v5   # v5 = installDir

    # Create $9 in v0 — v0..v6 consecutive: ($9, activity, appName, ns, catId, installDir, card)
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;
    invoke-direct/range {v0 .. v6}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V

    # Build message = "Install to:\n" + installDir + "\n\nChunks downloaded from Epic CDN."
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "Install to:\n"
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v8, "\n\nChunks downloaded from Epic CDN."
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7   # message

    # AlertDialog
    new-instance v8, Landroid/app/AlertDialog$Builder;
    invoke-direct {v8, v1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    const-string v9, "Install Game"
    invoke-virtual {v8, v9}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    invoke-virtual {v8, v7}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    const-string v9, "Install"
    invoke-virtual {v8, v9, v0}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    const-string v9, "Cancel"
    const/4 v7, 0x0
    invoke-virtual {v8, v9, v7}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    invoke-virtual {v8}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method
