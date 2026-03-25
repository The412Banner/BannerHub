.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$13;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# BannerHub: Add button OnClickListener for Epic game cards (post-install).
# Reads epic_installed_{appName} from bh_epic_prefs → installDir (fallback: default path).
# Scans installDir for first non-redist .exe, then shows EditImportedGameInfoDialog
# directly (EpicMainActivity extends FragmentActivity).

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

    # Pref empty — fallback: build getFilesDir()/epic_games/{appName} and check exists
    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v5
    invoke-virtual {v5}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v5
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v5, "/epic_games/"
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    new-instance v6, Ljava/io/File;
    invoke-direct {v6, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v6}, Ljava/io/File;->exists()Z
    move-result v6
    if-eqz v6, :no_default_path
    move-object v3, v5    # use default path
    goto :path_ready

    :no_default_path
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

    # Scan installDir for a .exe file (skip "redist" in name).
    # v1/v2 are free here (card and appName no longer needed).
    # v3 = installDir; update to exe path if found.
    new-instance v1, Ljava/io/File;
    invoke-direct {v1, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v2       # v2 = File[] (may be null)
    if-eqz v2, :exe_scan_done
    array-length v4, v2         # v4 = length
    const/4 v5, 0x0             # v5 = index
    :exe_scan_loop
    if-ge v5, v4, :exe_scan_done
    aget-object v6, v2, v5      # v6 = File
    invoke-virtual {v6}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v1       # v1 = name
    invoke-virtual {v1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;
    move-result-object v1
    const-string v6, "redist"
    invoke-virtual {v1, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v6
    if-nez v6, :exe_skip        # skip redistributables
    const-string v6, ".exe"
    invoke-virtual {v1, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v6
    if-eqz v6, :exe_skip
    aget-object v1, v2, v5      # reload File (v1 was overwritten with name)
    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v3       # v3 = exe path
    goto :exe_scan_done
    :exe_skip
    add-int/lit8 v5, v5, 0x1
    goto :exe_scan_loop
    :exe_scan_done

    # Show EditImportedGameInfoDialog directly — EpicMainActivity is now a FragmentActivity,
    # so it can host the dialog without needing to cast to LandscapeLauncherMainActivity.
    # Equivalent to what B3(installDir) does in LandscapeLauncherMainActivity.
    sget-object v1, Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog;->s:Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog$Companion;
    move-object v2, v0    # v2 = EpicMainActivity (FragmentActivity)
    # v3 = exe path (or installDir if no exe found)
    const/4 v4, 0x0       # null Function1 callback
    const/4 v5, 0x4       # default-args mask (makes callback default to null)
    const/4 v6, 0x0       # null Object (DefaultConstructorMarker)
    invoke-static/range {v1 .. v6}, Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog$Companion;->c(Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog$Companion;Landroidx/fragment/app/FragmentActivity;Ljava/lang/String;Lkotlin/jvm/functions/Function1;ILjava/lang/Object;)Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog;

    :launch_done
    return-void
.end method
