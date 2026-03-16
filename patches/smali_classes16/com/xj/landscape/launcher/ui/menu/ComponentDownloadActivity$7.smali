# KimchiDriversRunnable — background: GET Nightlies kimchi/drivers.json,
#                         parse releases[] array, collect all .wcp/.zip/.xz assets,
#                         name format: "tag / assetName", url = original_url,
#                         populate mAllNames/mAllUrls, post $2 (showCategories on UI thread)
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
.field final val$url:Ljava/lang/String;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;->val$url:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 15
    # .locals 15 → v0-v14 locals, p0=v15 (within 4-bit range)
    # Setup:  v1=temp  v2=URL→HttpURLConnection→label string  v3=stream/reader  v4=reader temp  v5=StringBuilder→responseStr
    # Parse:  v6=root JSONObject→releases JSONArray  v7=release count  v8=release index
    # Outer:  v9=tag (String, kept alive across inner loop)  v10=assets JSONArray  v11=asset count  v12=asset index
    # Inner:  v13=asset JSONObject→label StringBuilder  v14=asset name
    # v5 reused as mirror_url after responseStr consumed into JSONObject

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

    :try_start

    # open HTTP connection to val$url
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$7;->val$url:Ljava/lang/String;
    new-instance v2, Ljava/net/URL;
    invoke-direct {v2, v1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v2}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v2
    check-cast v2, Ljava/net/HttpURLConnection;

    const-string v1, "GET"
    invoke-virtual {v2, v1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V
    const v1, 0x3a98
    invoke-virtual {v2, v1}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v2, v1}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V
    const-string v1, "User-Agent"
    const-string v3, "BannerHub/1.0"
    invoke-virtual {v2, v1, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    # read response into StringBuilder (v5)
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v3
    new-instance v4, Ljava/io/InputStreamReader;
    invoke-direct {v4, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V
    new-instance v3, Ljava/io/BufferedReader;
    invoke-direct {v3, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    :read_loop
    invoke-virtual {v3}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :read_done
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop
    :read_done
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5

    # parse root JSONObject, extract "releases" JSONArray into v6
    new-instance v6, Lorg/json/JSONObject;
    invoke-direct {v6, v5}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    # v5 now free — reused as mirror_url in inner loop
    const-string v1, "releases"
    invoke-virtual {v6, v1}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v6

    invoke-virtual {v6}, Lorg/json/JSONArray;->length()I
    move-result v7
    const/4 v8, 0x0

    # outer loop: iterate all releases
    :release_loop
    if-ge v8, v7, :release_done

    invoke-virtual {v6, v8}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v9

    # extract assets array before overwriting v9 with tag
    const-string v1, "assets"
    invoke-virtual {v9, v1}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v10

    # v9 = tag string (kept alive across all inner loop iterations)
    const-string v1, "tag"
    invoke-virtual {v9, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9

    invoke-virtual {v10}, Lorg/json/JSONArray;->length()I
    move-result v11
    const/4 v12, 0x0

    # inner loop: iterate assets for this release
    :asset_loop
    if-ge v12, v11, :asset_done

    invoke-virtual {v10, v12}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v13

    # v14 = asset name
    const-string v1, "name"
    invoke-virtual {v13, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v14

    # accept .wcp, .zip, .xz only
    const-string v1, ".wcp"
    invoke-virtual {v14, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :accept_asset
    const-string v1, ".zip"
    invoke-virtual {v14, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-nez v1, :accept_asset
    const-string v1, ".xz"
    invoke-virtual {v14, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :skip_asset

    :accept_asset
    # v5 = original_url (mirror_url filenames don't match actual uploaded asset names)
    const-string v1, "original_url"
    invoke-virtual {v13, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5

    # v13 now free — reuse as label StringBuilder: "tag / assetName"
    new-instance v13, Ljava/lang/StringBuilder;
    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v13, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, " / "
    invoke-virtual {v13, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2

    # add label to mAllNames, mirror_url to mAllUrls
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mAllNames:Ljava/util/ArrayList;
    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mAllUrls:Ljava/util/ArrayList;
    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :skip_asset
    add-int/lit8 v12, v12, 0x1
    goto :asset_loop

    :asset_done
    add-int/lit8 v8, v8, 0x1
    goto :release_loop

    :release_done

    # post $2 to UI thread — calls showCategories()
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;
    invoke-direct {v1, v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;)V
    invoke-virtual {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    :try_end
    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_fetch

    :catch_fetch
    move-exception v1
    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v1
    if-nez v1, :has_err_msg
    const-string v1, "Unknown error"
    :has_err_msg
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "Fetch failed: "
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;
    invoke-direct {v2, v0, v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
