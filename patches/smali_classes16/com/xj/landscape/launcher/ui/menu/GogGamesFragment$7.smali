.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$7;
.super Ljava/lang/Object;

# BannerHub: Launch click listener for installed GOG games.
# Reads the stored exe path from bh_gog_prefs (gog_exe_{gameId}),
# builds a WineActivityData Parcelable, and starts PcGameSetupActivity.

.implements Landroid/content/DialogInterface$OnClickListener;

.field public final a:Landroid/content/Context;
.field public final b:Lcom/xj/landscape/launcher/ui/menu/GogGame;


.method public constructor <init>(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$7;->a:Landroid/content/Context;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$7;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    return-void
.end method


.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 18

    # p0=v18=this — bridge into 4-bit range
    move-object/from16 v1, p0

    # v0 = context
    iget-object v0, v1, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$7;->a:Landroid/content/Context;

    # v1 = GogGame
    iget-object v1, v1, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$7;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    # v2 = gameId
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->gameId:Ljava/lang/String;
    if-eqz v2, :launch_done

    # v9 = gameName (title) — save before we build other strings
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->title:Ljava/lang/String;

    # Read gog_exe_{gameId} from bh_gog_prefs
    const-string v4, "bh_gog_prefs"
    const/4 v5, 0x0
    invoke-virtual {v0, v4, v5}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "gog_exe_"
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5

    const-string v6, ""
    invoke-interface {v4, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4  # raw exe path

    # Bail if no exe path stored
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z
    move-result v5
    if-nez v5, :launch_done

    # Normalize: replace backslashes with forward slashes
    const-string v5, "\\"
    const-string v6, "/"
    invoke-virtual {v4, v5, v6}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v4  # exePath normalized → v3

    # Rearrange for range invoke: v1=WineActivityData(this), v2=gameId, v3=exePath, v9=gameName
    move-object v3, v4   # v3 = exePath
    new-instance v1, Lcom/xj/winemu/api/bean/WineActivityData;

    # Fill remaining args for WineActivityData constructor:
    # (gameId, exePath, bgUrl, bgRes, isLaunchDesktop, isLocalGame,
    #  steamAppId, gameName, canUseSteamClient, steamClientDirPath,
    #  controllerSwitch, gameVideoUrl, disableImageQualityPlugin,
    #  redmagicBinder, seamlessTransition, isUseSteamAppIdForScript)
    const/4 v4, 0x0     # bgUrl = null
    const/4 v5, 0x0     # bgRes = 0
    const/4 v6, 0x0     # isLaunchDesktop = false
    const/4 v7, 0x1     # isLocalGame = true
    const/4 v8, 0x0     # steamAppId = null
    # v9 = gameName (set above)
    const/4 v10, 0x0    # canUseSteamClient = false
    const/4 v11, 0x0    # steamClientDirPath = null
    const/4 v12, 0x0    # controllerSwitch = false
    const/4 v13, 0x0    # gameVideoUrl = null
    const/4 v14, 0x0    # disableImageQualityPlugin = false
    const/4 v15, 0x0    # redmagicBinder = null
    const/16 v16, 0x0   # seamlessTransition = false
    const/16 v17, 0x0   # isUseSteamAppIdForScript = false

    invoke-direct/range {v1 .. v17}, Lcom/xj/winemu/api/bean/WineActivityData;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IZZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;ZLjava/lang/String;ZLandroid/os/IBinder;ZZ)V

    # Build Intent for PcGameSetupActivity
    new-instance v2, Landroid/content/Intent;
    const-class v3, Lcom/xj/winemu/setup/ui/PcGameSetupActivity;
    invoke-direct {v2, v0, v3}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v3, "wine_data"
    invoke-virtual {v2, v3, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    const/high16 v3, 0x10000000  # FLAG_ACTIVITY_NEW_TASK
    invoke-virtual {v2, v3}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    invoke-virtual {v0, v2}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    :launch_done
    return-void
.end method
