# DownloadRunnable — background: stream file to cacheDir, call injectComponent, post $4 with result
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$3;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$3;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    return-void
.end method

.method public run()V
    .locals 9
    # v0=outer  v1=filename  v2=destFile  v3=HttpURLConnection/reuse
    # v4=urlString/InputStream/reuse  v5=FileOutputStream  v6=byte[]  v7=bytesRead/type  v8=Uri/reuse

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$3;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;

    :try_start

    # v1 = filename
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mDownloadFilename:Ljava/lang/String;

    # v2 = cacheDir/filename
    invoke-virtual {v0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;
    move-result-object v3
    new-instance v2, Ljava/io/File;
    invoke-direct {v2, v3, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    # open HTTP connection to mDownloadUrl
    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mDownloadUrl:Ljava/lang/String;
    new-instance v3, Ljava/net/URL;
    invoke-direct {v3, v4}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v3
    check-cast v3, Ljava/net/HttpURLConnection;

    const v4, 0x7530
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v4

    # stream to file
    new-instance v5, Ljava/io/FileOutputStream;
    invoke-direct {v5, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/16 v6, 0x2000
    new-array v6, v6, [B

    :copy_loop
    invoke-virtual {v4, v6}, Ljava/io/InputStream;->read([B)I
    move-result v7
    if-lez v7, :copy_done
    const/4 v8, 0x0
    invoke-virtual {v5, v6, v8, v7}, Ljava/io/OutputStream;->write([BII)V
    goto :copy_loop

    :copy_done
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V
    invoke-virtual {v5}, Ljava/io/FileOutputStream;->close()V

    # prepare Uri + type, then post $5 to UI thread — injectComponent calls Toast internally
    # so it must run on the UI thread (background thread has no Looper)
    invoke-static {v2}, Landroid/net/Uri;->fromFile(Ljava/io/File;)Landroid/net/Uri;
    move-result-object v8

    invoke-static {v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->detectType(Ljava/lang/String;)I
    move-result v7

    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mDownloadFilename:Ljava/lang/String;
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;
    invoke-direct {v3, v0, v8, v7, v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Landroid/net/Uri;ILjava/lang/String;)V
    invoke-virtual {v0, v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    :try_end
    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_dl

    :catch_dl
    move-exception v3
    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v3
    if-nez v3, :has_dl_err
    const-string v3, "Unknown error"
    :has_dl_err
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Download failed: "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;
    invoke-direct {v4, v0, v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v4}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
