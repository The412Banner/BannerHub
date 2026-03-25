.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;

# BannerHub: AlertDialog positive-button listener for Epic install confirmation.
# Created by $5 when user confirms the Add dialog.
# onClick: starts EpicMainActivity$7 (background download Runnable) in a new Thread.

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$appName:Ljava/lang/String;
.field final synthetic val$namespace:Ljava/lang/String;
.field final synthetic val$catalogItemId:Ljava/lang/String;
.field final synthetic val$installDir:Ljava/lang/String;
.field final synthetic val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$appName:Ljava/lang/String;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$namespace:Ljava/lang/String;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$catalogItemId:Ljava/lang/String;
    iput-object p5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$installDir:Ljava/lang/String;
    iput-object p6, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 8

    # v1-v6 = constructor args for $7: activity, appName, ns, catId, installDir, card
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$appName:Ljava/lang/String;
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$namespace:Ljava/lang/String;
    iget-object v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$catalogItemId:Ljava/lang/String;
    iget-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$installDir:Ljava/lang/String;
    iget-object v6, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$9;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;

    # v0 = $7 instance, invoke-direct/range {v0..v6}
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;
    invoke-direct/range {v0 .. v6}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V

    new-instance v7, Ljava/lang/Thread;
    invoke-direct {v7, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v7}, Ljava/lang/Thread;->start()V

    return-void
.end method
