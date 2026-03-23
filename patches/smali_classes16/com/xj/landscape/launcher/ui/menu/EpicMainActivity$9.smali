.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;

# BannerHub: AlertDialog positive-button listener for Epic install confirmation.
# Created by EpicMainActivity$5 when user taps Install button.
# onClick: starts EpicMainActivity$7 (background download Runnable) in a new Thread.
#
# Register map in onClick (.locals 7):
#   v0 = EpicMainActivity$7 instance  ← v0 for invoke-direct/range {v0..v5}
#   v1 = activity (this$0)
#   v2 = appName
#   v3 = namespace
#   v4 = catalogItemId
#   v5 = installDir
#   v6 = Thread

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$appName:Ljava/lang/String;
.field final synthetic val$namespace:Ljava/lang/String;
.field final synthetic val$catalogItemId:Ljava/lang/String;
.field final synthetic val$installDir:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$appName:Ljava/lang/String;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$namespace:Ljava/lang/String;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$catalogItemId:Ljava/lang/String;
    iput-object p5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$installDir:Ljava/lang/String;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 7

    # v1-v5 = constructor args for $7 (loaded before allocation so they're in the right slots)
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$appName:Ljava/lang/String;
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$namespace:Ljava/lang/String;
    iget-object v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$catalogItemId:Ljava/lang/String;
    iget-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$installDir:Ljava/lang/String;

    # v0 = $7 instance, then invoke-direct/range {v0..v5} (6 consecutive registers)
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;
    invoke-direct/range {v0 .. v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    new-instance v6, Ljava/lang/Thread;
    invoke-direct {v6, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v6}, Ljava/lang/Thread;->start()V

    return-void
.end method
