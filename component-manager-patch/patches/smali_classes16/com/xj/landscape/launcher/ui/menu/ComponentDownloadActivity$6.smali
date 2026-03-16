# PackJsonFetchRunnable — background: GET pack.json flat array, skip Wine/Proton,
#                         extract filename from remoteUrl, populate mAllNames/mAllUrls,
#                         post $2 (showCategories on UI thread)
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$6;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
.field final val$url:Ljava/lang/String;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$6;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$6;->val$url:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 12
    # v0=outer  v1=url/strings  v2=URL/HttpURLConnection/strings
    # v3=InputStream/BufferedReader  v4=InputStreamReader/line/filename
    # v5=StringBuilder/responseStr  v6=line/JSONArray  v7=length
    # v8=index  v9=JSONObject  v10=mAllNames  v11=mAllUrls

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$6;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

    :try_start

    # open HTTP connection to val$url
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$6;->val$url:Ljava/lang/String;
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

    # read response into StringBuilder
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
    move-result-object v4
    if-eqz v4, :read_done
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop
    :read_done
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5

    # parse flat JSONArray
    new-instance v6, Lorg/json/JSONArray;
    invoke-direct {v6, v5}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6}, Lorg/json/JSONArray;->length()I
    move-result v7
    const/4 v8, 0x0

    iget-object v10, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mAllNames:Ljava/util/ArrayList;
    iget-object v11, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mAllUrls:Ljava/util/ArrayList;

    :pack_loop
    if-ge v8, v7, :pack_done

    invoke-virtual {v6, v8}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v9

    # v1 = type string
    const-string v1, "type"
    invoke-virtual {v9, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1

    # skip Wine (no known GameHub type int)
    const-string v2, "Wine"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :skip_entry

    # skip Proton (no known GameHub type int)
    const-string v2, "Proton"
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-nez v2, :skip_entry

    # v3 = remoteUrl
    const-string v3, "remoteUrl"
    invoke-virtual {v9, v3}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3

    # v4 = filename = last path segment of remoteUrl (after last '/')
    const/16 v4, 0x2f
    invoke-virtual {v3, v4}, Ljava/lang/String;->lastIndexOf(I)I
    move-result v4
    add-int/lit8 v4, v4, 0x1
    invoke-virtual {v3, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v4

    invoke-virtual {v10, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    invoke-virtual {v11, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :skip_entry
    add-int/lit8 v8, v8, 0x1
    goto :pack_loop

    :pack_done

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
