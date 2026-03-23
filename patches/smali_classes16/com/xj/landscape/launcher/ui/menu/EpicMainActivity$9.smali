.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;

# BannerHub: AlertDialog positive-button listener for Epic install confirmation.
# Created by EpicMainActivity$5 when user taps Install button.
# onClick: starts EpicMainActivity$7 (background download Runnable) in a new Thread.

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

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$appName:Ljava/lang/String;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$namespace:Ljava/lang/String;
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$catalogItemId:Ljava/lang/String;
    iget-object v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$installDir:Ljava/lang/String;

    # Create and start download thread
    new-instance v5, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;
    invoke-direct {v5, v0, v1, v2, v3, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    new-instance v6, Ljava/lang/Thread;
    invoke-direct {v6, v5}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v6}, Ljava/lang/Thread;->start()V

    return-void
.end method
