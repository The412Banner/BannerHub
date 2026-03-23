.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# BannerHub: Install-button OnClickListener for EpicMainActivity game cards.
# Shows an AlertDialog confirming install path (/storage/emulated/0/Epic/{appName}).
# Positive "Install" → EpicMainActivity$9 → starts EpicMainActivity$7 (download thread).
# Negative "Cancel" → dismiss.
#
# Register map (.locals 9):
#   v0 = this$0 (EpicMainActivity / Context)
#   v1 = appName
#   v2 = namespace
#   v3 = catalogItemId
#   v4 = installDir String
#   v5 = message String / reused
#   v6 = EpicMainActivity$9 (dialog positive listener)
#   v7 = AlertDialog$Builder
#   v8 = temp String

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$appName:Ljava/lang/String;
.field final synthetic val$namespace:Ljava/lang/String;
.field final synthetic val$catalogItemId:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$appName:Ljava/lang/String;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$namespace:Ljava/lang/String;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$catalogItemId:Ljava/lang/String;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 9

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$appName:Ljava/lang/String;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$namespace:Ljava/lang/String;
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$catalogItemId:Ljava/lang/String;

    # Build installDir = "/storage/emulated/0/Epic/" + appName
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "/storage/emulated/0/Epic/"
    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4   # v4 = installDir

    # Build message = "Install to:\n" + installDir + "\n\nSize will be downloaded from Epic CDN."
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "Install to:\n"
    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v8, "\n\nChunks will be downloaded from Epic CDN."
    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5   # v5 = message

    # Create $9 dialog positive listener (holds activity, appName, ns, catId, installDir)
    new-instance v6, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;
    invoke-direct {v6, v0, v1, v2, v3, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    # Build AlertDialog
    new-instance v7, Landroid/app/AlertDialog$Builder;
    invoke-direct {v7, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v8, "Install Game"
    invoke-virtual {v7, v8}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    invoke-virtual {v7, v5}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    # Positive button → $9
    const-string v8, "Install"
    invoke-virtual {v7, v8, v6}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    # Negative button → dismiss (null listener)
    const-string v8, "Cancel"
    const/4 v5, 0x0
    invoke-virtual {v7, v8, v5}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v7}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method
