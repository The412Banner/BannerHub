.class public final synthetic Lcom/xj/landscape/launcher/ui/gamedetail/BhLsfgLambda;
.super Ljava/lang/Object;

# implements kotlin.jvm.functions.Function1 — called when user taps LSFG Frame Gen
.implements Lkotlin/jvm/functions/Function1;

.field public final a:Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;
.field public final b:Lcom/xj/common/service/bean/GameDetailEntity;

.method public synthetic constructor <init>(Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;Lcom/xj/common/service/bean/GameDetailEntity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhLsfgLambda;->a:Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhLsfgLambda;->b:Lcom/xj/common/service/bean/GameDetailEntity;

    return-void
.end method

.method public final invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 5

    # v0 = GameDetailSettingMenu
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhLsfgLambda;->a:Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;

    # v1 = FragmentActivity (Activity context — required for startActivity)
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;->z()Landroidx/fragment/app/FragmentActivity;
    move-result-object v1

    # v2 = GameDetailEntity
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhLsfgLambda;->b:Lcom/xj/common/service/bean/GameDetailEntity;

    # Replicate GameHub's own gameId resolution (same as BhExportLambda):
    #   if getId() > 0  → gameId = String.valueOf(getId())   (catalog/server game)
    #   else            → gameId = getLocalGameId()           (locally-added game)
    invoke-virtual {v2}, Lcom/xj/common/service/bean/GameDetailEntity;->getId()I
    move-result v3

    if-gtz v3, :has_server_id

    invoke-virtual {v2}, Lcom/xj/common/service/bean/GameDetailEntity;->getLocalGameId()Ljava/lang/String;
    move-result-object v3
    goto :resolve_done

    :has_server_id
    invoke-static {v3}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;
    move-result-object v3

    :resolve_done

    # Launch BhLsfgSettingsActivity with EXTRA_GAME_ID so it knows which game to configure
    new-instance v4, Landroid/content/Intent;
    const-class v0, Lapp/revanced/extension/gamehub/BhLsfgSettingsActivity;
    invoke-direct {v4, v1, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    const-string v0, "bh_lsfg_game_id"
    invoke-virtual {v4, v0, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;
    invoke-virtual {v1, v4}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    const/4 v0, 0x0
    return-object v0
.end method
