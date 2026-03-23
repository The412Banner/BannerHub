.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# BannerHub: Install-button OnClickListener for EpicMainActivity game cards.
# Shows an AlertDialog confirming install path (/storage/emulated/0/Epic/{appName}).
# Positive "Install" → EpicMainActivity$9 → starts EpicMainActivity$7 (download thread).
# Negative "Cancel" → dismiss.
#
# Register map (.locals 8):
#   v0 = EpicMainActivity$9 instance  ← must sit at v0 for invoke-direct/range {v0..v5}
#   v1 = activity (this$0)
#   v2 = appName
#   v3 = namespace
#   v4 = catalogItemId
#   v5 = installDir String  (arg4 for $9 ctor)
#   v6 = StringBuilder / message String / "Install" label String (reused)
#   v7 = AlertDialog$Builder

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
    .locals 8

    # Load fields into v1-v4 (these become the 2nd–5th args for $9 constructor)
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$appName:Ljava/lang/String;
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$namespace:Ljava/lang/String;
    iget-object v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$5;->val$catalogItemId:Ljava/lang/String;

    # Build installDir = "/storage/emulated/0/Epic/" + appName → v5 (arg4 for $9 ctor)
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "/storage/emulated/0/Epic/"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5   # v5 = installDir

    # Create $9 in v0 — now v0..v5 are consecutive for range call
    # invoke-direct/range {v0..v5} = this=v0, activity=v1, appName=v2, ns=v3, catId=v4, installDir=v5
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;
    invoke-direct/range {v0 .. v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    # Build message = "Install to:\n" + installDir + "\n\nChunks downloaded from Epic CDN."
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "Install to:\n"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v7, "\n\nChunks downloaded from Epic CDN."
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6   # v6 = message

    # Build AlertDialog — v7 = Builder, v1 = activity/context
    new-instance v7, Landroid/app/AlertDialog$Builder;
    invoke-direct {v7, v1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v5, "Install Game"
    invoke-virtual {v7, v5}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    invoke-virtual {v7, v6}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    # Positive button "Install" → $9 (v0)
    const-string v6, "Install"
    invoke-virtual {v7, v6, v0}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    # Negative button "Cancel" → null
    const-string v5, "Cancel"
    const/4 v6, 0x0
    invoke-virtual {v7, v5, v6}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v7}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method
