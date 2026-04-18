.class public Lapp/revanced/extension/gamehub/ui/GameIdHelper;
.super Ljava/lang/Object;
.source "GameIdHelper.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic lambda$setupCopyableText$0(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Landroid/view/View;)V
    .locals 0

    .line 67
    const-string p3, "clipboard"

    invoke-virtual {p0, p3}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Landroid/content/ClipboardManager;

    if-eqz p3, :cond_0

    .line 69
    invoke-static {p1, p2}, Landroid/content/ClipData;->newPlainText(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Landroid/content/ClipData;

    move-result-object p2

    invoke-virtual {p3, p2}, Landroid/content/ClipboardManager;->setPrimaryClip(Landroid/content/ClipData;)V

    .line 70
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " copied!"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 p2, 0x0

    invoke-static {p0, p1, p2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    :cond_0
    return-void
.end method

.method public static populateGameId(Landroid/app/Activity;)V
    .locals 10

    .line 25
    const-string v0, ""

    .line 0
    const-string v1, "Launcher ID: "

    const-string v2, "Steam App ID: "

    .line 25
    :try_start_0
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v3

    if-nez v3, :cond_0

    goto/16 :goto_2

    .line 28
    :cond_0
    const-string v4, "steamAppId"

    invoke-virtual {v3, v4, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 29
    const-string v5, "localGameId"

    invoke-virtual {v3, v5, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    # Resolve the actual settings key — mirrors BhExportLambda logic:
    # catalog games store settings under the numeric "id" extra (getId() > 0 path),
    # locally-added games use localGameId. Show whichever key is actually used so
    # users configure Beacon with the correct value.
    const-string v9, "id"
    const-string v5, "0"
    invoke-virtual {v3, v9, v5}, Landroid/os/Bundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z
    move-result v8
    if-nez v8, :bhid_use_local

    invoke-virtual {v5, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v8
    if-nez v8, :bhid_use_local

    move-object v0, v9

    :bhid_use_local

    .line 31
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v3
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const/4 v5, 0x1

    const-string v6, "0"

    const/4 v7, 0x0

    if-nez v3, :cond_1

    :try_start_1
    invoke-virtual {v6, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1

    move v3, v5

    goto :goto_0

    :cond_1
    move v3, v7

    .line 32
    :goto_0
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-nez v8, :cond_2

    invoke-virtual {v6, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_2

    goto :goto_1

    :cond_2
    move v5, v7

    :goto_1
    if-nez v3, :cond_3

    if-nez v5, :cond_3

    goto :goto_2

    .line 35
    :cond_3
    const-string v6, "ll_game_id_container"

    invoke-static {p0, v6}, Lapp/revanced/extension/gamehub/ui/GameIdHelper;->resolveId(Landroid/app/Activity;Ljava/lang/String;)I

    move-result v6

    if-nez v6, :cond_4

    goto :goto_2

    .line 38
    :cond_4
    invoke-virtual {p0, v6}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v6

    if-nez v6, :cond_5

    goto :goto_2

    .line 41
    :cond_5
    invoke-virtual {v6, v7}, Landroid/view/View;->setVisibility(I)V

    if-eqz v3, :cond_6

    .line 44
    const-string v3, "tv_steam_app_id"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v6, "Steam App ID"

    invoke-static {p0, v3, v2, v4, v6}, Lapp/revanced/extension/gamehub/ui/GameIdHelper;->setupCopyableText(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_6
    if-eqz v5, :cond_7

    .line 48
    const-string v2, "tv_local_game_id"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v3, "Launcher ID"

    invoke-static {p0, v2, v1, v0, v3}, Lapp/revanced/extension/gamehub/ui/GameIdHelper;->setupCopyableText(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    :cond_7
    :goto_2
    return-void

    :catch_0
    move-exception p0

    .line 52
    sget-object v0, Lapp/revanced/extension/gamehub/util/GHLog;->GAME_ID:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v1, "populateGameId failed"

    invoke-virtual {v0, v1, p0}, Lapp/revanced/extension/gamehub/util/GHLog;->w(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static resolveId(Landroid/app/Activity;Ljava/lang/String;)I
    .locals 2

    .line 76
    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v1, "id"

    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p1, v1, p0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method private static setupCopyableText(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 58
    invoke-static {p0, p1}, Lapp/revanced/extension/gamehub/ui/GameIdHelper;->resolveId(Landroid/app/Activity;Ljava/lang/String;)I

    move-result p1

    if-nez p1, :cond_0

    goto :goto_0

    .line 61
    :cond_0
    invoke-virtual {p0, p1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    if-nez p1, :cond_1

    :goto_0
    return-void

    .line 64
    :cond_1
    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p2, 0x0

    .line 65
    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setVisibility(I)V

    .line 66
    new-instance p2, Lapp/revanced/extension/gamehub/ui/GameIdHelper$$ExternalSyntheticLambda0;

    invoke-direct {p2, p0, p4, p3}, Lapp/revanced/extension/gamehub/ui/GameIdHelper$$ExternalSyntheticLambda0;-><init>(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method
