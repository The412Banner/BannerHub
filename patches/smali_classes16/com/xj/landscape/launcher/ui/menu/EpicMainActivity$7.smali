.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: Background download Runnable for Epic Games install flow.
# Triggered by EpicMainActivity$9 when user confirms install dialog.
# Full pipeline: manifest fetch → binary parse → chunk download → file assembly.
#
# Fields:
#   this$0       = EpicMainActivity (Context + Handler)
#   val$appName  = EGS app identifier
#   val$namespace  = EGS namespace
#   val$catalogItemId = EGS catalog item ID
#   val$installDir = absolute path to install root (e.g. /storage/emulated/0/Epic/{appName})

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$appName:Ljava/lang/String;
.field final synthetic val$namespace:Ljava/lang/String;
.field final synthetic val$catalogItemId:Ljava/lang/String;
.field final synthetic val$installDir:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$appName:Ljava/lang/String;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$namespace:Ljava/lang/String;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$catalogItemId:Ljava/lang/String;
    iput-object p5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$installDir:Ljava/lang/String;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# postProgress: post an $8 Runnable via runOnUiThread to update syncText.
# p1 = EpicMainActivity, p2 = message String
.method private static postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    .locals 2
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$8;
    invoke-direct {v0, p1, p2}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$8;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {p1, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method


.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;

    # TODO(beta25): full pipeline — manifest fetch + binary parse + chunk download + assembly.
    # Stub: show "Install not yet implemented" in syncText.
    const-string v1, "Install: fetching manifest..."
    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V

    return-void
.end method
