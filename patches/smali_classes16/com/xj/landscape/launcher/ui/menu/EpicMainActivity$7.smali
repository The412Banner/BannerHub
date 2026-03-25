.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: Epic Games install background Runnable.
# Full pipeline: manifest API → binary manifest parse → chunk download → file assembly.
#
# Flow:
#   1. EpicTokenRefresh.refresh() → authHeader "Bearer {token}"
#   2. Fetch launcher API manifest JSON
#   3. Parse manifest URI + CDN base URL
#   4. Download binary manifest (unsigned CDN URL with query params)
#   5. Parse 41-byte header, zlib-decompress body if needed
#   6. Skip ManifestMeta section
#   7. Parse ChunkDataList (GUIDs/hashes/groupNums)
#   8. Parse FileManifestList (filenames + chunk parts)
#   9. For each file: download+decompress chunks → assemble → write to installDir
#  10. Post "Install complete!" or error message to syncText
#
# Register map in run() (.locals 15, p0=this):
#   v0  = Context (this$0 = EpicMainActivity)
#   v1  = EpicManifestData (allocated early, kept throughout)
#   v2  = authHeader String ("Bearer {token}")
#   v3  = cdnBase String (first non-Cloudflare CDN)
#   v4  = tempDir File (getCacheDir()/epic_chunks)
#   v5  = bodyBuf ByteBuffer / fileIdx (reused after parse phase)
#   v6  = parts String[] (split filePartData per file)
#   v7  = FileOutputStream (current output file)
#   v8  = partIdx (inner loop) / temp
#   v9  = temp String / File
#   v10 = tokens String[] / cache File
#   v11 = chunkIdx int
#   v12 = chunkOffset int
#   v13 = partSize int
#   v14 = chunkUrl String / chunkData byte[]

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$appName:Ljava/lang/String;
.field final synthetic val$namespace:Ljava/lang/String;
.field final synthetic val$catalogItemId:Ljava/lang/String;
.field final synthetic val$installDir:Ljava/lang/String;
.field final synthetic val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$appName:Ljava/lang/String;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$namespace:Ljava/lang/String;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$catalogItemId:Ljava/lang/String;
    iput-object p5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$installDir:Ljava/lang/String;
    iput-object p6, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# Post a progress message to syncText via runOnUiThread.
.method private static postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    .locals 2
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$8;
    invoke-direct {v0, p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$8;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method


# Append a line to getExternalFilesDir/bh_epic_debug.txt.
# Silently swallows all exceptions so it never breaks the install flow.
.method private static writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    .locals 4
    :try_start
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v0
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v2, "/bh_epic_debug.txt"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    new-instance v1, Ljava/io/FileWriter;
    const/4 v2, 0x1
    invoke-direct {v1, v0, v2}, Ljava/io/FileWriter;-><init>(Ljava/lang/String;Z)V
    invoke-virtual {v1, p1}, Ljava/io/FileWriter;->write(Ljava/lang/String;)V
    const-string v2, "\n"
    invoke-virtual {v1, v2}, Ljava/io/FileWriter;->write(Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/io/FileWriter;->close()V
    :done
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :skip
    :skip
    return-void
.end method


# Build a temporary chunk cache file path: tempDir/chunk_{chunkIdx}
.method private static buildCachePath(Ljava/io/File;I)Ljava/lang/String;
    .locals 3
    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v0
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v2, "/chunk_"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method


.method public run()V
    .locals 15

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;

    # Allocate EpicManifestData early (v1 kept for all phases)
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;
    invoke-direct {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;-><init>()V

    :try_start

    # ── Step 1: Load + refresh credentials ────────────────────────────────
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicTokenRefresh;->refresh(Landroid/content/Context;)Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
    move-result-object v5
    if-eqz v5, :err_creds
    iget-object v6, v5, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accessToken:Ljava/lang/String;
    if-eqz v6, :err_creds
    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z
    move-result v7
    if-nez v7, :err_creds
    # Build authHeader = "Bearer " + accessToken
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "Bearer "
    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2   # v2 = authHeader (kept for all chunk downloads)

    # ── Step 2: Post progress showing appName so we can verify UUID vs real name ──
    iget-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$appName:Ljava/lang/String;
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "Fetching: "
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V

    # Write ns + catalogItemId to debug file
    iget-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$namespace:Ljava/lang/String;
    iget-object v6, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$catalogItemId:Ljava/lang/String;
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "ns="
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v8, " cat="
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V

    # ── Step 3: Build manifest API URL ────────────────────────────────────
    iget-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$namespace:Ljava/lang/String;
    iget-object v6, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$catalogItemId:Ljava/lang/String;
    iget-object v7, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$appName:Ljava/lang/String;
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V
    const-string v9, "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace/"
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v9, "/catalogItem/"
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v9, "/app/"
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v9, "/label/Live"
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5   # v5 = manifest API URL

    # Write manifest URL to debug file
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V

    # ── Step 4: Fetch manifest API response ───────────────────────────────
    invoke-static {v5, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B
    move-result-object v5
    if-eqz v5, :err_api
    new-instance v6, Ljava/lang/String;
    const-string v7, "UTF-8"
    invoke-direct {v6, v5, v7}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    # v6 = manifest API JSON response

    # ── Hand off to EpicDownloader: CDN rotation, manifest dl, chunk download, assembly ──
    # v6 = manifestApiJson, v2 = bearerToken, install to val$installDir
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$installDir:Ljava/lang/String;
    const/4 v4, 0x0   # null ProgressCallback
    invoke-static {v6, v2, v3, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->install(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;)Z
    move-result v4
    if-nez v4, :all_done

    # Install returned false — report error
    const-string v5, "Install failed (check logcat)"
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;
    invoke-direct {v4, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    goto :finish

    # ── Step 15: Install complete ─────────────────────────────────────────
    :all_done
    const-string v5, "Install complete!"
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    # Post success UI: progressBar/statusTV GONE, checkTV/launchBtn VISIBLE, save bh_epic_prefs
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    iget-object v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$installDir:Ljava/lang/String;
    new-instance v5, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$11;
    invoke-direct {v5, v0, v3, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$11;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;Ljava/lang/String;)V
    invoke-virtual {v0, v5}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    goto :finish

    :err_creds
    const-string v5, "Install failed: not logged in"
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;
    invoke-direct {v4, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    goto :finish
    :err_api
    sget v5, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->lastHttpStatus:I
    iget-object v8, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$appName:Ljava/lang/String;
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "HTTP "
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v7, " app="
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    sget-object v5, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->lastError:Ljava/lang/String;
    if-eqz v5, :api_err_done
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z
    move-result v6
    if-nez v6, :api_err_done
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    :api_err_done
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;
    invoke-direct {v4, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    goto :finish
    :err_manifest
    sget v6, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->lastHttpStatus:I
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "Manifest DL err HTTP "
    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    sget-object v5, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->lastError:Ljava/lang/String;
    if-eqz v5, :manifest_err_done
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z
    move-result v6
    if-nez v6, :manifest_err_done
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    :manifest_err_done
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;
    invoke-direct {v4, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    goto :finish
    :err_parsebody
    const-string v5, "parseBody failed (bad header/magic?)"
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;
    invoke-direct {v4, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    goto :finish
    :err_parse
    const-string v5, "Install failed: manifest parse error"
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;
    invoke-direct {v4, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    goto :finish   # must not fall through to move-exception in :catch_all

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all
    :catch_all
    move-exception v5
    invoke-virtual {v5}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;
    invoke-direct {v4, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :finish
    return-void
.end method
