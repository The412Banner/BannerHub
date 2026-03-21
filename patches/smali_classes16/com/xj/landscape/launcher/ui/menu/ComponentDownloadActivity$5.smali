# InjectRunnable — UI thread: call injectComponent (which toasts internally), then finish activity
.class final Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
.field final val$uri:Landroid/net/Uri;
.field final val$type:I
.field final val$filename:Ljava/lang/String;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;Landroid/net/Uri;ILjava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$uri:Landroid/net/Uri;
    iput p3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$type:I
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$filename:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 12
    # v0  = activity (this$0)
    # v1  = uri / filesDir / found-component-name / val$filename
    # v2  = type / compDir File / files[] / lastIndexOf / mCurrentRepo
    # v3:v4 = pre-inject timestamp (wide) / later reused for mDownloadUrl/"dl:url"
    # v5  = "usr/home/components" / loop len / SP / editor return / "1" / ":type" str
    # v6  = loop index
    # v7  = dir File / type name string / StringBuilder for type key
    # v8:v9 = lastModified() wide result
    # v10 = cmpg-long result
    # v11 = candidate component name

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$uri:Landroid/net/Uri;
    iget v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$type:I

    # Record wall-clock time before injection — used to identify the new component dir
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v3    # v3:v4 = pre-inject timestamp

    invoke-static {v0, v1, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->injectComponent(Landroid/content/Context;Landroid/net/Uri;I)V

    # === Identify newly created component directory by scanning components/ ===
    # Build File(getFilesDir(), "usr/home/components")
    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v1
    new-instance v2, Ljava/io/File;
    const-string v5, "usr/home/components"
    invoke-direct {v2, v1, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v2    # v2 = files[] (may be null)

    const/4 v1, 0x0          # v1 = found component name (null initially)

    if-eqz v2, :use_filename
    array-length v5, v2
    if-eqz v5, :use_filename

    # Scan loop: find dir with lastModified > pre-inject timestamp
    # v6=index, v5=len, v7=dir, v8:v9=modTime, v10=cmp, v11=candidate name
    const/4 v6, 0x0
    :scan_loop
    if-ge v6, v5, :scan_done

    aget-object v7, v2, v6
    invoke-virtual {v7}, Ljava/io/File;->lastModified()J
    move-result-wide v8        # v8:v9 = dir.lastModified()

    cmp-long v10, v8, v3      # compare(modTime, timestamp): +1 if newer
    if-lez v10, :scan_next    # <= 0 means not newer than pre-inject time

    invoke-virtual {v7}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v11
    move-object v1, v11       # v1 = newest component name found so far
    move-wide v3, v8          # update reference to keep the latest modified

    :scan_next
    add-int/lit8 v6, v6, 0x1
    goto :scan_loop

    :scan_done
    if-nez v1, :write_sp      # found a new dir name → skip filename fallback

    :use_filename
    # Fall back: derive SP key from val$filename (strip extension)
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$filename:Ljava/lang/String;
    const/16 v2, 0x2e
    invoke-virtual {v1, v2}, Ljava/lang/String;->lastIndexOf(I)I
    move-result v2
    if-lez v2, :write_sp
    const/4 v3, 0x0
    invoke-virtual {v1, v3, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v1

    :write_sp
    # v0 = activity, v1 = component name (SP key)

    # v2 = mCurrentRepo
    iget-object v2, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mCurrentRepo:Ljava/lang/String;
    if-nez v2, :repo_ok
    const-string v2, "BannerHub"
    :repo_ok

    # v3 = "dl:" + mDownloadUrl
    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->mDownloadUrl:Ljava/lang/String;
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "dl:"
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3   # v3 = "dl:url"

    # v4 = type name string derived from val$type int
    iget v4, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5;->val$type:I
    const/16 v5, 0x5f
    if-ne v4, v5, :not_fex
    const-string v4, "FEXCore"
    goto :type_done
    :not_fex
    const/16 v5, 0x5e
    if-ne v4, v5, :not_box64
    const-string v4, "Box64"
    goto :type_done
    :not_box64
    const/16 v5, 0xd
    if-ne v4, v5, :not_vkd3d
    const-string v4, "VKD3D"
    goto :type_done
    :not_vkd3d
    const/16 v5, 0xa
    if-ne v4, v5, :not_gpu
    const-string v4, "GPU"
    goto :type_done
    :not_gpu
    const/16 v5, 0xc
    if-ne v4, v5, :not_dxvk
    const-string v4, "DXVK"
    goto :type_done
    :not_dxvk
    const/4 v4, 0x0           # unknown type — skip type write
    :type_done

    # Get SP + editor
    const-string v5, "banners_sources"
    const/4 v6, 0x0
    invoke-virtual {v0, v5, v6}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v5
    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v5   # v5 = editor

    # Write: component name (v1) → repo name (v2)
    invoke-interface {v5, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v6

    # Write: "dl:url" (v3) → "1"
    const-string v6, "1"
    invoke-interface {v5, v3, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v6

    # Write: type key (v1 + ":type") → type name (v4), only if v4 != null
    if-eqz v4, :no_type_write
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v7, ":type"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-interface {v5, v6, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v6
    :no_type_write

    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;->finish()V
    return-void
.end method
