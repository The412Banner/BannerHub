.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# BannerHub: Launch button OnClickListener for Epic game cards.
# Reads epic_installed_{appName} from bh_epic_prefs → installDir.
# Casts context to LandscapeLauncherMainActivity and calls B3(installDir)
# to open the built-in Import Game dialog (EditImportedGameInfoDialog).

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 7

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;

    # appName from card
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->appName:Ljava/lang/String;
    if-eqz v2, :launch_done

    # Read epic_installed_{appName} from bh_epic_prefs
    const-string v3, "bh_epic_prefs"
    const/4 v4, 0x0
    invoke-virtual {v0, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "epic_installed_"
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4   # key

    const-string v5, ""
    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3   # installDir (or "")

    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z
    move-result v4
    if-eqz v4, :path_ready

    # No path stored
    const-string v4, "Reinstall game to enable launch"
    const/4 v5, 0x0
    invoke-static {v0, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v4
    invoke-virtual {v4}, Landroid/widget/Toast;->show()V
    goto :launch_done

    :path_ready
    # Normalize backslashes
    const-string v4, "\\"
    const-string v5, "/"
    invoke-virtual {v3, v4, v5}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v3

    # Cast to LandscapeLauncherMainActivity and call B3(installDir)
    check-cast v0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;
    invoke-virtual {v0, v3}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->B3(Ljava/lang/String;)V

    :launch_done
    return-void
.end method
