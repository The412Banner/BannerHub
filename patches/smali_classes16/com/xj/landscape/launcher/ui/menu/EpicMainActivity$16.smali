.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;
.implements Ljava/lang/Runnable;

# BannerHub: Uninstall button handler for Epic game detail dialog.
# Implements both DialogInterface$OnClickListener (onClick → spawn Thread(this))
# and Runnable (run → delete installDir, clear pref, post $17 UI reset).

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$appName:Ljava/lang/String;
.field final synthetic val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;->val$appName:Ljava/lang/String;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# DialogInterface$OnClickListener.onClick — spawns background uninstall thread
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 2
    new-instance v0, Ljava/lang/Thread;
    invoke-direct {v0, p0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V
    return-void
.end method


# Runnable.run — delete installDir folder, clear pref, post UI reset
.method public run()V
    .locals 9

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;->val$appName:Ljava/lang/String;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;

    # Build installDir path: getFilesDir()/epic_games/{appName}
    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v3
    invoke-virtual {v3}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, "/epic_games/"
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3   # v3 = installDir path

    # Delete the directory recursively
    new-instance v4, Ljava/io/File;
    invoke-direct {v4, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-static {v4}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;->deleteDir(Ljava/io/File;)V

    # Remove pref key: epic_installed_{appName}
    const-string v3, "bh_epic_prefs"
    const/4 v4, 0x0
    invoke-virtual {v0, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v4   # Editor

    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "epic_installed_"
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5   # key

    invoke-interface {v4, v5}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Post UI reset via runOnUiThread($17)
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$17;
    invoke-direct {v3, v0, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$17;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v0, v3}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method


# Recursive directory delete
.method private static deleteDir(Ljava/io/File;)V
    .locals 4

    if-eqz p0, :done
    invoke-virtual {p0}, Ljava/io/File;->exists()Z
    move-result v0
    if-eqz v0, :done

    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v1
    if-eqz v1, :delete_self

    array-length v2, v1
    const/4 v3, 0x0
    :loop
    if-ge v3, v2, :delete_self
    aget-object v0, v1, v3
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;->deleteDir(Ljava/io/File;)V
    add-int/lit8 v3, v3, 0x1
    goto :loop

    :delete_self
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    :done
    return-void
.end method
