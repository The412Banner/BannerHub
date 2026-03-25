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

    # Parse CDN base (first non-Cloudflare) → v3
    invoke-static {v6}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->parseCdnBase(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3

    # Parse manifest download URL → v7 (reuse v7; v5 free)
    invoke-static {v6}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->parseManifestDownloadUrl(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v7   # v7 = manifestUrl
    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z
    move-result v5
    if-nez v5, :err_api

    # ── Step 5: Parse cloud directory from manifest URL ───────────────────
    invoke-static {v7, v3, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->parseCloudDir(Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;)V

    # Extract query string from manifest URL (e.g. "?cf_token=...") for chunk CDN auth
    const-string v5, "?"
    const/4 v6, 0x0
    invoke-virtual {v7, v5, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v5
    if-ltz v5, :no_qs
    invoke-virtual {v7, v5}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v5
    iput-object v5, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->queryString:Ljava/lang/String;
    goto :after_qs
    :no_qs
    const-string v5, ""
    iput-object v5, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->queryString:Ljava/lang/String;
    :after_qs

    # ── Step 6: Post progress ─────────────────────────────────────────────
    const-string v5, "Downloading manifest..."
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V

    # ── Step 7: Download binary manifest ──────────────────────────────────
    # Write binary manifest URL to debug file
    invoke-static {v0, v7}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    const-string v5, ""
    invoke-static {v7, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B
    move-result-object v5   # v5 = manifestBytes (v7 free)
    if-eqz v5, :err_manifest

    # Debug: log byte count + first byte (12=binary magic, 123='{' JSON)
    array-length v6, v5
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "manifest bytes: "
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-static {v0, v7}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    const/4 v6, 0x0
    aget-byte v6, v5, v6
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "manifest[0]: "
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-static {v0, v7}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V

    # ── Step 8: Detect JSON manifest (not yet supported) ─────────────────
    const/4 v6, 0x0
    aget-byte v6, v5, v6
    const/16 v7, 0x7B   # '{' = 123
    if-ne v6, v7, :not_json
    const-string v5, "JSON manifest not yet supported"
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;
    invoke-direct {v4, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$12;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    invoke-virtual {v0, v4}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    goto :finish
    :not_json

    # ── Step 8b: Parse binary header + decompress body ────────────────────
    invoke-static {v5, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->parseBody([BLcom/xj/landscape/launcher/ui/menu/EpicManifestData;)Ljava/nio/ByteBuffer;
    move-result-object v5   # v5 = bodyBuf (also fills data.manifestVersion + chunkDir)
    if-eqz v5, :err_parsebody
    const-string v6, "parseBody ok"
    invoke-static {v0, v6}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V

    # ── Step 9: Skip ManifestMeta section ────────────────────────────────
    invoke-static {v5}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->skipManifestMeta(Ljava/nio/ByteBuffer;)V
    const-string v6, "meta skipped"
    invoke-static {v0, v6}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V

    # ── Step 10: Parse ChunkDataList ──────────────────────────────────────
    invoke-static {v5, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->parseChunkList(Ljava/nio/ByteBuffer;Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;)Z
    move-result v6
    if-eqz v6, :err_parse
    iget v6, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkCount:I
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "chunks: "
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-static {v0, v7}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V

    # ── Step 11: Parse FileManifestList ───────────────────────────────────
    invoke-static {v5, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->parseFileList(Ljava/nio/ByteBuffer;Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;)Z
    move-result v6
    if-eqz v6, :err_parse
    iget-object v6, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->fileNames:[Ljava/lang/String;
    array-length v6, v6
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "files: "
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-static {v0, v7}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->writeDebug(Landroid/content/Context;Ljava/lang/String;)V
    # v5 (bodyBuf) no longer needed — free it logically

    # ── Step 12: Create install dir + temp dir ────────────────────────────
    iget-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$installDir:Ljava/lang/String;
    new-instance v6, Ljava/io/File;
    invoke-direct {v6, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v6}, Ljava/io/File;->mkdirs()Z   # ignore result

    # tempDir = cacheDir + "/epic_chunks"
    invoke-virtual {v0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;
    move-result-object v6
    invoke-virtual {v6}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v6
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, "/epic_chunks"
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    new-instance v4, Ljava/io/File;
    invoke-direct {v4, v6}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v4}, Ljava/io/File;->mkdirs()Z   # v4 = tempDir (kept for all chunk downloads)

    # ── Step 13: Post progress "Installing N files..." ────────────────────
    iget v5, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->fileCount:I
    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v6
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "Installing "
    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v7, " files..."
    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static {v0, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->postProgress(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V

    # ── Step 14: File assembly loop ───────────────────────────────────────
    iget-object v6, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->fileNames:[Ljava/lang/String;
    iget v5, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->fileCount:I
    # v5 = fileIdx outer loop, counts 0..fileCount-1
    const/4 v5, 0x0   # reset to 0 for outer loop (fileCount is in data)

    :file_loop
    iget v11, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->fileCount:I
    if-ge v5, v11, :all_done

    # Get filename, normalize Windows separators
    aget-object v9, v6, v5
    const/16 v10, 0x5C   # '\\'
    const/16 v11, 0x2F   # '/'
    invoke-virtual {v9, v10, v11}, Ljava/lang/String;->replace(CC)Ljava/lang/String;
    move-result-object v9   # v9 = normalized filename

    # Build output file path = installDir + "/" + filename
    iget-object v12, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->val$installDir:Ljava/lang/String;
    new-instance v13, Ljava/lang/StringBuilder;
    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v13, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v12, "/"
    invoke-virtual {v13, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v13, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v9   # v9 = output file absolute path

    # Create output file (make parent dirs first)
    new-instance v10, Ljava/io/File;
    invoke-direct {v10, v9}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v10}, Ljava/io/File;->getParentFile()Ljava/io/File;
    move-result-object v11
    if-eqz v11, :skip_mkdir
    invoke-virtual {v11}, Ljava/io/File;->mkdirs()Z
    :skip_mkdir

    # Open FileOutputStream for this file
    new-instance v7, Ljava/io/FileOutputStream;
    invoke-direct {v7, v10}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    # v7 = FileOutputStream (kept open for all parts of this file)

    # Get chunk part data for this file
    iget-object v8, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->filePartData:[Ljava/lang/String;
    aget-object v9, v8, v5   # v9 = filePartData[fileIdx]

    # Skip if empty (zero-byte file)
    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z
    move-result v10
    if-nez v10, :close_file

    # Split part data on ";" → parts String[]
    const-string v10, ";"
    invoke-virtual {v9, v10}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v6   # v6 = parts String[]

    # Inner part loop
    const/4 v8, 0x0   # v8 = partIdx
    :part_loop
    array-length v9, v6
    if-ge v8, v9, :close_file

    aget-object v9, v6, v8   # v9 = part string "chunkIdx:chunkOffset:partSize"
    const-string v10, ":"
    invoke-virtual {v9, v10}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v10   # v10 = tokens[3]

    const/4 v9, 0x0
    aget-object v9, v10, v9
    invoke-static {v9}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v11   # v11 = chunkIdx

    const/4 v9, 0x1
    aget-object v9, v10, v9
    invoke-static {v9}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v12   # v12 = chunkOffset

    const/4 v9, 0x2
    aget-object v9, v10, v9
    invoke-static {v9}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v13   # v13 = partSize

    # Skip if chunkIdx < 0 (GUID not found during parse)
    if-ltz v11, :next_part

    # Build chunk URL
    invoke-static {v3, v1, v11}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->buildChunkUrl(Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;I)Ljava/lang/String;
    move-result-object v14   # v14 = chunkUrl

    # Build cache file path = tempDir/chunk_{chunkIdx}
    invoke-static {v4, v11}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$7;->buildCachePath(Ljava/io/File;I)Ljava/lang/String;
    move-result-object v9   # v9 = cache path string
    new-instance v10, Ljava/io/File;
    invoke-direct {v10, v9}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    # v10 = cache File

    # Check if cached
    invoke-virtual {v10}, Ljava/io/File;->exists()Z
    move-result v9
    if-eqz v9, :download_chunk

    # Cache hit: read from disk
    invoke-static {v10}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->readFile(Ljava/io/File;)[B
    move-result-object v14   # v14 = chunkData (overwrites chunkUrl ref, no longer needed)
    goto :write_chunk

    :download_chunk
    # Cache miss: download + decompress
    invoke-static {v14, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->downloadAndDecompressChunk(Ljava/lang/String;Ljava/lang/String;)[B
    move-result-object v14   # v14 = chunkData
    if-eqz v14, :next_part   # download failed → skip part
    # Write to cache
    new-instance v9, Ljava/io/FileOutputStream;
    invoke-direct {v9, v10}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    invoke-virtual {v9, v14}, Ljava/io/FileOutputStream;->write([B)V
    invoke-virtual {v9}, Ljava/io/FileOutputStream;->close()V

    :write_chunk
    if-eqz v14, :next_part
    # Write chunkData[chunkOffset .. chunkOffset+partSize] to output file
    invoke-virtual {v7, v14, v12, v13}, Ljava/io/FileOutputStream;->write([BII)V

    :next_part
    # Restore v6 = fileNames array (inner loop clobbered it with parts[])
    # (We reload fileNames below if needed after inner loop)
    add-int/lit8 v8, v8, 0x1
    goto :part_loop

    :close_file
    invoke-virtual {v7}, Ljava/io/FileOutputStream;->close()V
    # Restore v6 = fileNames for outer loop check
    iget-object v6, v1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->fileNames:[Ljava/lang/String;

    add-int/lit8 v5, v5, 0x1
    goto :file_loop

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
