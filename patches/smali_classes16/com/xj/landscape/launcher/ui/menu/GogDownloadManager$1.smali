.class public final Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;
.super Ljava/lang/Object;

# BannerHub: GOG Gen 2 download pipeline Runnable.
# Steps:
#   1 — builds API → find windows gen2 build → get link
#   2 — fetch+decompress build manifest → installDirectory, baseProductId, depots[]
#   3 — per depot: fetch+decompress meta → collect DepotFile items (language filtered)
#   4 — fetch secure CDN link → base CDN URL
#   5+6 — per file: download chunks → assemble (zlib decompress if needed)
#   7 — write _gog_manifest.json, delete .gog_chunks/, toast "Install complete"

.implements Ljava/lang/Runnable;

.field public final a:Landroid/content/Context;
.field public final b:Lcom/xj/landscape/launcher/ui/menu/GogGame;
.field public c:Ljava/lang/String;
.field public d:Landroid/widget/ProgressBar;
.field public e:Landroid/widget/Button;
.field public g:Landroid/widget/TextView;   # statusTV
.field public f:Landroid/os/Handler;


.method public constructor <init>(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;Landroid/widget/ProgressBar;Landroid/widget/TextView;Landroid/widget/Button;)V
    .locals 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->a:Landroid/content/Context;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->d:Landroid/widget/ProgressBar;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->g:Landroid/widget/TextView;
    iput-object p5, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->e:Landroid/widget/Button;

    # Create Handler on main looper for UI progress updates
    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->f:Landroid/os/Handler;

    return-void
.end method


# ─── postProgress(progress, message) → void ─────────────────────────────────
.method private postProgress(ILjava/lang/String;)V
    .locals 6

    # null-check ProgressBar (v1); with .locals 6, p0=v6 p1=v7 p2=v8 so
    # {v0..v5} are 6 consecutive locals usable for invoke-direct/range
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->d:Landroid/widget/ProgressBar;
    if-eqz v1, :pp_done

    # Build GogDownloadManager$3 with consecutive {v0..v5} for range invoke
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;
    # v1 = ProgressBar (already loaded above)
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->g:Landroid/widget/TextView;
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->e:Landroid/widget/Button;
    move v4, p1
    move-object v5, p2
    invoke-direct/range {v0 .. v5}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$3;-><init>(Landroid/widget/ProgressBar;Landroid/widget/TextView;Landroid/widget/Button;ILjava/lang/String;)V

    # v0 = $3 instance (still valid); load Handler into v1, post
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->f:Landroid/os/Handler;
    invoke-virtual {v1, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :pp_done
    return-void
.end method


# ─── httpGet(url, token) → String or null ────────────────────────────────────
.method private httpGet(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 9

    :try_hg_start
    new-instance v0, Ljava/net/URL;
    invoke-direct {v0, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v1
    check-cast v1, Ljava/net/HttpURLConnection;

    const/16 v2, 0x7530
    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    if-eqz p2, :hg_no_auth
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Bearer "
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    const-string v5, "Authorization"
    invoke-virtual {v1, v5, v4}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V
    :hg_no_auth

    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v2
    const/16 v3, 0xC8
    if-ne v2, v3, :hg_fail

    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v3
    new-instance v4, Ljava/io/InputStreamReader;
    const-string v5, "UTF-8"
    invoke-direct {v4, v3, v5}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    new-instance v5, Ljava/io/BufferedReader;
    invoke-direct {v5, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    :hg_read_loop
    invoke-virtual {v5}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v7
    if-eqz v7, :hg_read_done
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :hg_read_loop

    :hg_read_done
    invoke-virtual {v5}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0

    :hg_fail
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V
    const/4 v0, 0x0
    return-object v0

    :try_hg_end
    .catch Ljava/lang/Exception; {:try_hg_start .. :try_hg_end} :hg_ex
    :hg_ex
    const/4 v0, 0x0
    return-object v0
.end method


# ─── fetchBytes(url, token) → [B or null ─────────────────────────────────────
.method private fetchBytes(Ljava/lang/String;Ljava/lang/String;)[B
    .locals 9

    :try_fb_start
    new-instance v0, Ljava/net/URL;
    invoke-direct {v0, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v1
    check-cast v1, Ljava/net/HttpURLConnection;

    const/16 v2, 0x7530
    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    if-eqz p2, :fb_no_auth
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Bearer "
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    const-string v5, "Authorization"
    invoke-virtual {v1, v5, v4}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V
    :fb_no_auth

    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v2
    const/16 v3, 0xC8
    if-ne v2, v3, :fb_fail

    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v3
    new-instance v4, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v4}, Ljava/io/ByteArrayOutputStream;-><init>()V
    const/16 v5, 0x1000
    new-array v5, v5, [B

    :fb_loop
    invoke-virtual {v3, v5}, Ljava/io/InputStream;->read([B)I
    move-result v6
    const/4 v7, -0x1
    if-eq v6, v7, :fb_done
    const/4 v8, 0x0
    invoke-virtual {v4, v5, v8, v6}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :fb_loop

    :fb_done
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v4}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v0
    return-object v0

    :fb_fail
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V
    const/4 v0, 0x0
    return-object v0

    :try_fb_end
    .catch Ljava/lang/Exception; {:try_fb_start .. :try_fb_end} :fb_ex
    :fb_ex
    const/4 v0, 0x0
    return-object v0
.end method


# ─── decompressBytes([B) → String or null ─────────────────────────────────────
# Detects gzip (0x1F 0x8B), zlib (0x78 xx), or plain UTF-8.
.method private decompressBytes([B)Ljava/lang/String;
    .locals 10

    if-eqz p1, :dc_null
    array-length v0, p1
    const/4 v1, 0x2
    if-lt v0, v1, :dc_plain

    const/4 v0, 0x0
    aget-byte v1, p1, v0  # byte[0]
    const/4 v2, 0x1
    aget-byte v2, p1, v2  # byte[1]

    # Check gzip: 0x1F 0x8B
    const/16 v3, 0x1F
    if-ne v1, v3, :dc_check_zlib
    const/16 v4, -0x75  # 0x8B signed = -117
    if-ne v2, v4, :dc_check_zlib

    :try_gzip_start
    new-instance v3, Ljava/io/ByteArrayInputStream;
    invoke-direct {v3, p1}, Ljava/io/ByteArrayInputStream;-><init>([B)V
    new-instance v4, Ljava/util/zip/GZIPInputStream;
    invoke-direct {v4, v3}, Ljava/util/zip/GZIPInputStream;-><init>(Ljava/io/InputStream;)V
    new-instance v5, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v5}, Ljava/io/ByteArrayOutputStream;-><init>()V
    const/16 v6, 0x1000
    new-array v6, v6, [B
    :gzip_loop
    invoke-virtual {v4, v6}, Ljava/io/InputStream;->read([B)I
    move-result v7
    const/4 v8, -0x1
    if-eq v7, v8, :gzip_done
    const/4 v8, 0x0
    invoke-virtual {v5, v6, v8, v7}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :gzip_loop
    :gzip_done
    invoke-virtual {v4}, Ljava/util/zip/GZIPInputStream;->close()V
    invoke-virtual {v5}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v0
    const-string v1, "UTF-8"
    new-instance v2, Ljava/lang/String;
    invoke-direct {v2, v0, v1}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    return-object v2
    :try_gzip_end
    .catch Ljava/lang/Exception; {:try_gzip_start .. :try_gzip_end} :dc_plain

    :dc_check_zlib
    # Check zlib: first byte 0x78 (120)
    const/16 v3, 0x78
    if-ne v1, v3, :dc_plain

    :try_zlib_start
    new-instance v3, Ljava/util/zip/Inflater;
    invoke-direct {v3}, Ljava/util/zip/Inflater;-><init>()V
    invoke-virtual {v3, p1}, Ljava/util/zip/Inflater;->setInput([B)V
    new-instance v4, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v4}, Ljava/io/ByteArrayOutputStream;-><init>()V
    const/16 v5, 0x1000
    new-array v5, v5, [B
    :zlib_loop
    invoke-virtual {v3}, Ljava/util/zip/Inflater;->finished()Z
    move-result v6
    if-nez v6, :zlib_done
    invoke-virtual {v3, v5}, Ljava/util/zip/Inflater;->inflate([B)I
    move-result v6
    if-eqz v6, :zlib_done
    const/4 v7, 0x0
    invoke-virtual {v4, v5, v7, v6}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :zlib_loop
    :zlib_done
    invoke-virtual {v3}, Ljava/util/zip/Inflater;->end()V
    invoke-virtual {v4}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v0
    const-string v1, "UTF-8"
    new-instance v2, Ljava/lang/String;
    invoke-direct {v2, v0, v1}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    return-object v2
    :try_zlib_end
    .catch Ljava/lang/Exception; {:try_zlib_start .. :try_zlib_end} :dc_plain

    :dc_plain
    :try_plain_start
    const-string v0, "UTF-8"
    new-instance v1, Ljava/lang/String;
    invoke-direct {v1, p1, v0}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    return-object v1
    :try_plain_end
    .catch Ljava/lang/Exception; {:try_plain_start .. :try_plain_end} :dc_null

    :dc_null
    const/4 v0, 0x0
    return-object v0
.end method


# ─── buildCdnPath(hash) → "ab/cd/abcdef..." ──────────────────────────────────
.method private buildCdnPath(Ljava/lang/String;)Ljava/lang/String;
    .locals 5

    const/4 v0, 0x0
    const/4 v1, 0x2
    invoke-virtual {p1, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v2

    const/4 v3, 0x4
    invoke-virtual {p1, v1, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v0, "/"
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method


# ─── parseCdnUrl(json) → base CDN URL or null ────────────────────────────────
# Parses secure_link response, replaces {param} placeholders, strips "/{path}".
.method private parseCdnUrl(Ljava/lang/String;)Ljava/lang/String;
    .locals 9

    :try_pcu_start
    new-instance v0, Lorg/json/JSONObject;
    invoke-direct {v0, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v1, "urls"
    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v1
    if-eqz v1, :pcu_fail

    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I
    move-result v2
    if-lez v2, :pcu_fail

    const/4 v2, 0x0
    invoke-virtual {v1, v2}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v1

    const-string v2, "url_format"
    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :pcu_fail

    const-string v3, "parameters"
    invoke-virtual {v1, v3}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;
    move-result-object v3
    if-eqz v3, :pcu_fail

    # Replace all {key} placeholders with parameter values
    invoke-virtual {v3}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;
    move-result-object v4

    :pcu_key_loop
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z
    move-result v5
    if-eqz v5, :pcu_key_done
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v5
    check-cast v5, Ljava/lang/String;

    invoke-virtual {v3, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6

    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "{"
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v8, "}"
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7

    invoke-virtual {v2, v7, v6}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v2
    goto :pcu_key_loop

    :pcu_key_done
    # Unescape \/ → /
    const-string v5, "\\/"
    const-string v6, "/"
    invoke-virtual {v2, v5, v6}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v2

    # Strip trailing /{path}
    const-string v5, "/{path}"
    invoke-virtual {v2, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I
    move-result v5
    const/4 v6, -0x1
    if-eq v5, v6, :pcu_return
    const/4 v6, 0x0
    invoke-virtual {v2, v6, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v2

    :pcu_return
    return-object v2

    :pcu_fail
    const/4 v0, 0x0
    return-object v0

    :try_pcu_end
    .catch Ljava/lang/Exception; {:try_pcu_start .. :try_pcu_end} :pcu_ex
    :pcu_ex
    const/4 v0, 0x0
    return-object v0
.end method


# ─── readFile(File) → [B or null ─────────────────────────────────────────────
.method private readFile(Ljava/io/File;)[B
    .locals 7

    :try_rf_start
    new-instance v0, Ljava/io/FileInputStream;
    invoke-direct {v0, p1}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    new-instance v1, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V
    const/16 v2, 0x1000
    new-array v2, v2, [B
    :rf_loop
    invoke-virtual {v0, v2}, Ljava/io/InputStream;->read([B)I
    move-result v3
    const/4 v4, -0x1
    if-eq v3, v4, :rf_done
    const/4 v5, 0x0
    invoke-virtual {v1, v2, v5, v3}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :rf_loop
    :rf_done
    invoke-virtual {v0}, Ljava/io/FileInputStream;->close()V
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v0
    return-object v0
    :try_rf_end
    .catch Ljava/lang/Exception; {:try_rf_start .. :try_rf_end} :rf_ex
    :rf_ex
    const/4 v0, 0x0
    return-object v0
.end method


# ─── downloadChunk(url, destFile) → boolean ──────────────────────────────────
# Up to 3 attempts with 2s/4s/8s backoff.
.method private downloadChunk(Ljava/lang/String;Ljava/io/File;)Z
    .locals 9

    const/4 v0, 0x0  # attempt

    :dc_retry_loop
    const/4 v1, 0x3
    if-ge v0, v1, :dc_fail

    :try_dc_start
    new-instance v2, Ljava/net/URL;
    invoke-direct {v2, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v2}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v3
    check-cast v3, Ljava/net/HttpURLConnection;

    const/16 v4, 0x7530
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const-string v4, "User-Agent"
    const-string v5, "GOG Galaxy"
    invoke-virtual {v3, v4, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v4
    const/16 v5, 0xC8
    if-ne v4, v5, :dc_bad_status

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v5
    new-instance v6, Ljava/io/FileOutputStream;
    invoke-direct {v6, p2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    const/16 v7, 0x1000
    new-array v7, v7, [B

    :dc_read_loop
    invoke-virtual {v5, v7}, Ljava/io/InputStream;->read([B)I
    move-result v8
    const/4 v4, -0x1
    if-eq v8, v4, :dc_read_done
    const/4 v4, 0x0
    invoke-virtual {v6, v7, v4, v8}, Ljava/io/OutputStream;->write([BII)V
    goto :dc_read_loop

    :dc_read_done
    invoke-virtual {v5}, Ljava/io/InputStream;->close()V
    invoke-virtual {v6}, Ljava/io/FileOutputStream;->close()V
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    const/4 v0, 0x1
    return v0

    :dc_bad_status
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    :try_dc_end
    .catch Ljava/lang/Exception; {:try_dc_start .. :try_dc_end} :dc_next_attempt

    :dc_next_attempt
    add-int/lit8 v0, v0, 0x1

    # Backoff: 2^(attempt+1) * 1000ms
    const/4 v1, 0x1
    shl-int v1, v1, v0
    const/16 v2, 0x3E8
    mul-int v1, v1, v2
    int-to-long v1, v1   # v1:v2 = millis as long

    :try_sleep_start
    invoke-static {v1, v2}, Ljava/lang/Thread;->sleep(J)V
    :try_sleep_end
    .catch Ljava/lang/Exception; {:try_sleep_start .. :try_sleep_end} :dc_skip_sleep
    :dc_skip_sleep

    goto :dc_retry_loop

    :dc_fail
    const/4 v0, 0x0
    return v0
.end method


# ─── processDepotManifest(json, filesList) → void ────────────────────────────
# Parses one decompressed depot manifest JSON string; appends DepotFile items
# (non-support) to filesList.
.method private processDepotManifest(Ljava/lang/String;Ljava/util/ArrayList;)V
    .locals 8

    :try_pdm_start
    new-instance v0, Lorg/json/JSONObject;
    invoke-direct {v0, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v1, "depot"
    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;
    move-result-object v0
    if-eqz v0, :pdm_done

    const-string v1, "items"
    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v1
    if-eqz v1, :pdm_done

    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I
    move-result v2
    const/4 v3, 0x0

    :pdm_item_loop
    if-ge v3, v2, :pdm_done

    invoke-virtual {v1, v3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v4

    # Only process DepotFile type
    const-string v5, "type"
    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    const-string v6, "DepotFile"
    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    if-eqz v5, :pdm_item_next

    # Skip "support" flagged files
    const-string v5, "flags"
    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v5
    if-eqz v5, :pdm_no_flags
    invoke-virtual {v5}, Lorg/json/JSONArray;->toString()Ljava/lang/String;
    move-result-object v5
    const-string v6, "support"
    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v5
    if-nez v5, :pdm_item_next
    :pdm_no_flags

    invoke-virtual {p2, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :pdm_item_next
    add-int/lit8 v3, v3, 0x1
    goto :pdm_item_loop

    :pdm_done
    return-void

    :try_pdm_end
    .catch Ljava/lang/Exception; {:try_pdm_start .. :try_pdm_end} :pdm_done
.end method


# ─── assembleFile(fileObj, installDir, baseCdnUrl, chunkDir) → void ──────────
# Downloads all chunks for one DepotFile and assembles into the output file.
.method private assembleFile(Lorg/json/JSONObject;Ljava/io/File;Ljava/lang/String;Ljava/io/File;)V
    .locals 11

    # p0=v11=this, p1=v12=fileObj, p2=v13=installDir, p3=v14=baseCdnUrl, p4=v15=chunkDir
    # All params p0-p4 map to v11-v15 (within 4-bit range).

    # v0 = normalized path (String) → free after outputFile created; BAOS during inflate
    # v1 = chunks JSONArray (LIVE throughout)
    # v2 = outputFile (File)  (LIVE for appending)
    # v3 = chunk index
    # v4 = chunk count
    # v5 = chunk JSONObject → offset=0 scratch during inflate
    # v6 = compressedMd5 hash → Inflater during inflate
    # v7 = chunkFile (File)
    # v8 = chunkUrl (String) → inflate buffer during inflate
    # v9 = chunk bytes ([B) → inflate result
    # v10 = compressedSize (int) → inflate count

    const-string v0, "path"
    invoke-virtual {p1, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :af_done

    # Normalize backslashes → forward slashes
    const-string v1, "\\"
    const-string v2, "/"
    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v0

    # Strip leading /
    const-string v1, "/"
    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :af_no_strip
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v0
    :af_no_strip

    const-string v1, "chunks"
    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v1
    if-eqz v1, :af_done

    # Create output file and parent dirs
    new-instance v2, Ljava/io/File;
    invoke-direct {v2, p2, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v2}, Ljava/io/File;->getParentFile()Ljava/io/File;
    move-result-object v0  # v0 now free (path consumed)
    if-eqz v0, :af_no_mkdirs
    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z
    :af_no_mkdirs

    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I
    move-result v4
    const/4 v3, 0x0

    :af_chunk_loop
    if-ge v3, v4, :af_done

    :try_af_chunk_start
    invoke-virtual {v1, v3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v5

    const-string v6, "compressedMd5"
    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6
    if-eqz v6, :af_chunk_next

    # Build chunkFile path: chunkDir/{hash}.chunk
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v0, ".chunk"
    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0

    new-instance v7, Ljava/io/File;
    invoke-direct {v7, p4, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    # Build chunkUrl: baseCdnUrl + "/" + buildCdnPath(hash)
    invoke-direct {p0, v6}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->buildCdnPath(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6

    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v8, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v0, "/"
    invoke-virtual {v8, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8  # chunkUrl

    # Skip download if cached non-empty
    invoke-virtual {v7}, Ljava/io/File;->exists()Z
    move-result v0
    if-eqz v0, :af_download
    invoke-virtual {v7}, Ljava/io/File;->length()J
    move-result-wide v9   # v9=low-word, v10=high-word
    long-to-int v9, v9    # convert to int so if-nez is valid (verifier rejects if-nez on long)
    if-nez v9, :af_cached

    :af_download
    invoke-direct {p0, v8, v7}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->downloadChunk(Ljava/lang/String;Ljava/io/File;)Z

    :af_cached
    # Read cached chunk bytes
    invoke-virtual {v7}, Ljava/io/File;->exists()Z
    move-result v0
    if-eqz v0, :af_chunk_next

    invoke-direct {p0, v7}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->readFile(Ljava/io/File;)[B
    move-result-object v9
    if-eqz v9, :af_chunk_next

    # Check compressedSize vs size (v6 is free here — cdnPath string was consumed at line 660)
    const-string v0, "compressedSize"
    invoke-virtual {v5, v0}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I
    move-result v10
    const-string v0, "size"
    invoke-virtual {v5, v0}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I
    move-result v6  # NOT v11 — v11=p0=this; overwriting it causes type=Conflict on loop back-edge

    if-eq v10, v6, :af_write  # same size = uncompressed, write directly

    # Decompress with Inflater (zlib nowrap=false)
    # Free registers here: v0 (path done), v5 (chunkObj done), v6 (hash done), v8 (url done), v10 (size done)
    # v6=Inflater, v0=BAOS, v8=buffer([B), v10=inflate-count, v5=offset(0)
    :try_inflate_start
    new-instance v6, Ljava/util/zip/Inflater;
    invoke-direct {v6}, Ljava/util/zip/Inflater;-><init>()V
    invoke-virtual {v6, v9}, Ljava/util/zip/Inflater;->setInput([B)V
    new-instance v0, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V
    const/16 v8, 0x1000
    new-array v8, v8, [B
    :inflate_loop
    invoke-virtual {v6}, Ljava/util/zip/Inflater;->finished()Z
    move-result v10
    if-nez v10, :inflate_done
    invoke-virtual {v6, v8}, Ljava/util/zip/Inflater;->inflate([B)I
    move-result v10
    if-eqz v10, :inflate_done
    const/4 v5, 0x0
    invoke-virtual {v0, v8, v5, v10}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :inflate_loop
    :inflate_done
    invoke-virtual {v6}, Ljava/util/zip/Inflater;->end()V
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v9
    :try_inflate_end
    .catch Ljava/lang/Exception; {:try_inflate_start .. :try_inflate_end} :af_chunk_next

    :af_write
    # Append v9 bytes to outputFile v2 (v6 is free here — Inflater branch done or skipped)
    :try_afwrite_start
    const/4 v0, 0x1  # append=true
    new-instance v6, Ljava/io/FileOutputStream;
    invoke-direct {v6, v2, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;Z)V
    invoke-virtual {v6, v9}, Ljava/io/OutputStream;->write([B)V
    invoke-virtual {v6}, Ljava/io/FileOutputStream;->close()V
    :try_afwrite_end
    .catch Ljava/lang/Exception; {:try_afwrite_start .. :try_afwrite_end} :af_chunk_next

    # Delete chunk after writing
    invoke-virtual {v7}, Ljava/io/File;->delete()Z

    :try_af_chunk_end
    .catch Ljava/lang/Exception; {:try_af_chunk_start .. :try_af_chunk_end} :af_chunk_next

    :af_chunk_next
    add-int/lit8 v3, v3, 0x1
    goto :af_chunk_loop

    :af_done
    return-void
.end method


# ─── showToast(msg) → void ───────────────────────────────────────────────────
.method private showToast(Ljava/lang/String;)V
    .locals 4

    # p0=v4=this, p1=v5=msg — post to main thread to avoid Looper crash
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->a:Landroid/content/Context;

    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$2;
    invoke-direct {v1, v0, p1}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$2;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    new-instance v2, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v3
    invoke-direct {v2, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    invoke-virtual {v2, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    return-void
.end method


# ─── deleteDir(file) → void ──────────────────────────────────────────────────
.method private deleteDir(Ljava/io/File;)V
    .locals 5

    if-eqz p1, :dd_done
    invoke-virtual {p1}, Ljava/io/File;->isDirectory()Z
    move-result v0
    if-eqz v0, :dd_delete
    invoke-virtual {p1}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v1
    if-eqz v1, :dd_delete
    array-length v2, v1
    const/4 v3, 0x0
    :dd_child_loop
    if-ge v3, v2, :dd_delete
    aget-object v4, v1, v3
    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->deleteDir(Ljava/io/File;)V
    add-int/lit8 v3, v3, 0x1
    goto :dd_child_loop
    :dd_delete
    invoke-virtual {p1}, Ljava/io/File;->delete()Z
    :dd_done
    return-void
.end method


# ─── run() — main pipeline ────────────────────────────────────────────────────
.method public run()V
    .locals 15

    # p0 = this = v15 (within 4-bit range — no move-object/from16 needed)
    # v0  = ctx (Context)
    # v1  = accessToken (String)
    # v2  = gameId (String)
    # v3  = scratch / temp JSON / URL builder
    # v4  = scratch / temp string
    # v5  = installDir (File)  [set after step 2]
    # v6  = baseProductId (String)  [set in step 2]
    # v7  = depotsArray (JSONArray)  [set in step 2]
    # v8  = filesList (ArrayList<JSONObject>)  [set before step 3]
    # v9  = loop index
    # v10 = loop length
    # v11 = baseCdnUrl (String)  [set in step 4]
    # v12 = chunkCacheDir (File)  [set before step 5]
    # v13 = scratch
    # v14 = scratch  (title loaded fresh at step 7 toast)

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->a:Landroid/content/Context;
    if-eqz v0, :run_done

    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;
    iget-object v2, v3, Lcom/xj/landscape/launcher/ui/menu/GogGame;->gameId:Ljava/lang/String;
    if-eqz v2, :run_done

    :try_run_start

    # ── Get access token ─────────────────────────────────────────────────────
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/GogTokenRefresh;->refresh(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :err_token

    const/4 v4, 0x5
    const-string v13, "Fetching build info..."
    invoke-direct {p0, v4, v13}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->postProgress(ILjava/lang/String;)V

    # ── Step 1: builds API ────────────────────────────────────────────────────
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "https://content-system.gog.com/products/"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, "/os/windows/builds?generation=2"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4

    invoke-direct {p0, v4, v1}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->httpGet(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :err_builds

    new-instance v3, Lorg/json/JSONObject;
    invoke-direct {v3, v4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v4, "items"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v3
    if-eqz v3, :err_gen1

    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I
    move-result v9
    if-lez v9, :err_gen1

    # Find first windows item
    const/4 v9, 0x0
    const/4 v10, -0x1  # selectedIdx
    :s1_scan_loop
    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I
    move-result v13
    if-ge v9, v13, :s1_scan_done
    invoke-virtual {v3, v9}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v13
    const-string v14, "os"
    invoke-virtual {v13, v14}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v14
    const-string v4, "windows"
    invoke-virtual {v14, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v14
    if-eqz v14, :s1_scan_next
    move v10, v9
    goto :s1_scan_done
    :s1_scan_next
    add-int/lit8 v9, v9, 0x1
    goto :s1_scan_loop
    :s1_scan_done
    const/4 v13, -0x1
    if-eq v10, v13, :err_gen1

    invoke-virtual {v3, v10}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v3

    const-string v4, "link"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4  # build manifest link
    if-eqz v4, :err_gen1
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z
    move-result v9
    if-nez v9, :err_gen1

    # ── Step 2: fetch+decompress build manifest ───────────────────────────────
    # v4 = manifest link URL (must not be clobbered); v3 is free (JSONObject consumed)
    const/16 v13, 0x14
    const-string v3, "Fetching manifest..."
    invoke-direct {p0, v13, v3}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->postProgress(ILjava/lang/String;)V

    invoke-direct {p0, v4, v1}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->fetchBytes(Ljava/lang/String;Ljava/lang/String;)[B
    move-result-object v4
    if-eqz v4, :err_manifest

    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->decompressBytes([B)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :err_manifest

    new-instance v3, Lorg/json/JSONObject;
    invoke-direct {v3, v4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v4, "installDirectory"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4  # installDirectory string
    if-eqz v4, :err_manifest
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z
    move-result v9
    if-nez v9, :err_manifest

    const-string v13, "baseProductId"
    invoke-virtual {v3, v13}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6  # baseProductId
    if-eqz v6, :err_manifest

    const-string v13, "depots"
    invoke-virtual {v3, v13}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v7  # depotsArray
    if-eqz v7, :err_manifest

    # Resolve install dir
    iget-object v13, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->a:Landroid/content/Context;
    invoke-static {v13, v4}, Lcom/xj/landscape/launcher/ui/menu/GogInstallPath;->getInstallDir(Landroid/content/Context;Ljava/lang/String;)Ljava/io/File;
    move-result-object v5  # installDir (File)
    invoke-virtual {v5}, Ljava/io/File;->mkdirs()Z

    # Extract products[0].temp_executable → store in field c for later SP write
    const-string v9, "products"
    invoke-virtual {v3, v9}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v9
    if-eqz v9, :exe_skip
    invoke-virtual {v9}, Lorg/json/JSONArray;->length()I
    move-result v10
    if-lez v10, :exe_skip
    const/4 v10, 0x0
    invoke-virtual {v9, v10}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;
    move-result-object v9
    if-eqz v9, :exe_skip
    const-string v10, "temp_executable"
    invoke-virtual {v9, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9
    if-eqz v9, :exe_skip
    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z
    move-result v10
    if-nez v10, :exe_skip
    iput-object v9, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->c:Ljava/lang/String;
    :exe_skip

    # ── Step 3: depot manifests → collect DepotFile items ────────────────────
    new-instance v8, Ljava/util/ArrayList;
    invoke-direct {v8}, Ljava/util/ArrayList;-><init>()V

    const/4 v9, 0x0
    invoke-virtual {v7}, Lorg/json/JSONArray;->length()I
    move-result v10

    :depot_loop
    if-ge v9, v10, :depot_loop_done

    invoke-virtual {v7, v9}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;
    move-result-object v3

    # Language filter
    const-string v4, "languages"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;
    move-result-object v4
    if-eqz v4, :depot_lang_ok

    invoke-virtual {v4}, Lorg/json/JSONArray;->toString()Ljava/lang/String;
    move-result-object v13
    const-string v14, "*"
    invoke-virtual {v13, v14}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v14
    if-nez v14, :depot_lang_ok
    const-string v14, "en-US"
    invoke-virtual {v13, v14}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v14
    if-nez v14, :depot_lang_ok
    const-string v14, "\"en\""
    invoke-virtual {v13, v14}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v14
    if-nez v14, :depot_lang_ok
    const-string v14, "english"
    invoke-virtual {v13, v14}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v14
    if-eqz v14, :depot_next

    :depot_lang_ok
    const-string v4, "manifest"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :depot_next
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z
    move-result v13
    if-nez v13, :depot_next

    # Build CDN meta URL
    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->buildCdnPath(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v13

    new-instance v14, Ljava/lang/StringBuilder;
    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "https://gog-cdn-fastly.gog.com/content-system/v2/meta/"
    invoke-virtual {v14, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v13

    invoke-direct {p0, v13, v1}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->fetchBytes(Ljava/lang/String;Ljava/lang/String;)[B
    move-result-object v13
    if-eqz v13, :depot_next

    invoke-direct {p0, v13}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->decompressBytes([B)Ljava/lang/String;
    move-result-object v13
    if-eqz v13, :depot_next

    invoke-direct {p0, v13, v8}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->processDepotManifest(Ljava/lang/String;Ljava/util/ArrayList;)V

    :depot_next
    add-int/lit8 v9, v9, 0x1
    goto :depot_loop
    :depot_loop_done

    # ── Exe fallback: if temp_executable absent, scan depot files for first .exe ──
    iget-object v9, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->c:Ljava/lang/String;
    if-nez v9, :exe_scan_done

    const/4 v9, 0x0
    invoke-virtual {v8}, Ljava/util/ArrayList;->size()I
    move-result v10

    :exe_scan_loop
    if-ge v9, v10, :exe_scan_done

    invoke-virtual {v8, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v11
    check-cast v11, Lorg/json/JSONObject;
    const-string v12, "path"
    invoke-virtual {v11, v12}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v12
    if-eqz v12, :exe_scan_next
    invoke-virtual {v12}, Ljava/lang/String;->isEmpty()Z
    move-result v13
    if-nez v13, :exe_scan_next

    # Case-insensitive: lowercase copy for checks
    invoke-virtual {v12}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;
    move-result-object v13

    # Must end with .exe
    const-string v14, ".exe"
    invoke-virtual {v13, v14}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v14
    if-eqz v14, :exe_scan_next

    # Skip redistributable paths
    const-string v14, "redist"
    invoke-virtual {v13, v14}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v14
    if-nez v14, :exe_scan_next

    # Normalize backslashes and store as field c (relative path to exe)
    const-string v13, "\\"
    const-string v14, "/"
    invoke-virtual {v12, v13, v14}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v12
    iput-object v12, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->c:Ljava/lang/String;
    goto :exe_scan_done

    :exe_scan_next
    add-int/lit8 v9, v9, 0x1
    goto :exe_scan_loop

    :exe_scan_done

    invoke-virtual {v8}, Ljava/util/ArrayList;->size()I
    move-result v9
    if-lez v9, :err_no_files

    const/16 v9, 0x28
    const-string v4, "Getting CDN link..."
    invoke-direct {p0, v9, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->postProgress(ILjava/lang/String;)V

    # ── Step 4: secure CDN link ───────────────────────────────────────────────
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "https://content-system.gog.com/products/"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, "/secure_link?_version=2&generation=2&path=/"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4

    invoke-direct {p0, v4, v1}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->httpGet(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :err_cdn

    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->parseCdnUrl(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v11  # baseCdnUrl
    if-eqz v11, :err_cdn

    # ── Step 5+6: download+assemble all files ─────────────────────────────────
    const/16 v4, 0x2D
    const-string v13, "Downloading files..."
    invoke-direct {p0, v4, v13}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->postProgress(ILjava/lang/String;)V

    # Create chunk cache dir
    new-instance v12, Ljava/io/File;
    const-string v4, ".gog_chunks"
    invoke-direct {v12, v5, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v12}, Ljava/io/File;->mkdirs()Z

    const/4 v9, 0x0
    invoke-virtual {v8}, Ljava/util/ArrayList;->size()I
    move-result v10

    :file_loop
    if-ge v9, v10, :file_loop_done

    invoke-virtual {v8, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v13
    check-cast v13, Lorg/json/JSONObject;

    invoke-direct {p0, v13, v5, v11, v12}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->assembleFile(Lorg/json/JSONObject;Ljava/io/File;Ljava/lang/String;Ljava/io/File;)V

    add-int/lit8 v9, v9, 0x1

    # ── Per-file progress "Downloading files... X%" ───────────────────────────
    # pct = v9 * 40 / v10 + 45  (maps 0→45% .. total→85%)
    mul-int/lit8 v13, v9, 0x28          # v13 = v9 * 40
    div-int v13, v13, v10              # v13 = (v9*40)/v10
    add-int/lit8 v13, v13, 0x2D       # v13 = pct (45..85)

    new-instance v14, Ljava/lang/StringBuilder;
    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "Downloading files... "
    invoke-virtual {v14, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v3, "%"
    invoke-virtual {v14, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v14              # v14 = "Downloading files... X%"

    invoke-direct {p0, v13, v14}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->postProgress(ILjava/lang/String;)V

    goto :file_loop
    :file_loop_done

    const/16 v9, 0x55
    const-string v4, "Assembling..."
    invoke-direct {p0, v9, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->postProgress(ILjava/lang/String;)V

    # ── Step 7: finalize ──────────────────────────────────────────────────────
    const/16 v13, 0x5A
    const-string v4, "Finishing up..."
    invoke-direct {p0, v13, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->postProgress(ILjava/lang/String;)V

    # Write _gog_manifest.json
    new-instance v13, Ljava/io/File;
    const-string v14, "_gog_manifest.json"
    invoke-direct {v13, v5, v14}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    :try_mf_start
    new-instance v14, Ljava/io/FileOutputStream;
    invoke-direct {v14, v13}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    const-string v3, "{\"installed\":true}"
    const-string v4, "UTF-8"
    invoke-virtual {v3, v4}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B
    move-result-object v3
    invoke-virtual {v14, v3}, Ljava/io/OutputStream;->write([B)V
    invoke-virtual {v14}, Ljava/io/FileOutputStream;->close()V
    :try_mf_end
    .catch Ljava/lang/Exception; {:try_mf_start .. :try_mf_end} :mf_skip
    :mf_skip

    # Save install data to bh_gog_prefs (always runs after successful install)
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;
    iget-object v14, v0, Lcom/xj/landscape/launcher/ui/menu/GogGame;->gameId:Ljava/lang/String;
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->a:Landroid/content/Context;
    const-string v3, "bh_gog_prefs"
    const/4 v4, 0x0
    invoke-virtual {v0, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v3

    # Always write gog_dir_{gameId} = installDir name (e.g. "CyberpunkRedMod")
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "gog_dir_"
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v5}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v6
    invoke-interface {v3, v4, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    # Write gog_exe_{gameId} only if temp_executable was found in manifest
    iget-object v13, p0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->c:Ljava/lang/String;
    if-eqz v13, :sp_apply
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "gog_exe_"
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v5}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v6
    const-string v7, "\\"
    const-string v8, "/"
    invoke-virtual {v13, v7, v8}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v13
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v6, "/"
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6
    invoke-interface {v3, v4, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    :sp_apply
    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Delete chunk cache dir
    invoke-direct {p0, v12}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->deleteDir(Ljava/io/File;)V

    # Progress 100% + checkmark in dialog status text
    const/16 v3, 0x64
    const-string v4, "\u2713 Complete"
    invoke-direct {p0, v3, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->postProgress(ILjava/lang/String;)V

    goto :run_done

    :err_token
    const-string v4, "GOG: could not get access token"
    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->showToast(Ljava/lang/String;)V
    goto :run_done

    :err_builds
    const-string v4, "GOG: failed to fetch builds"
    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->showToast(Ljava/lang/String;)V
    goto :run_done

    :err_gen1
    const-string v4, "GOG: no Gen 2 build (Gen 1 fallback pending)"
    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->showToast(Ljava/lang/String;)V
    goto :run_done

    :err_manifest
    const-string v4, "GOG: failed to read build manifest"
    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->showToast(Ljava/lang/String;)V
    goto :run_done

    :err_no_files
    const-string v4, "GOG: no files found in depot manifests"
    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->showToast(Ljava/lang/String;)V
    goto :run_done

    :err_cdn
    const-string v4, "GOG: failed to get CDN download link"
    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->showToast(Ljava/lang/String;)V
    goto :run_done

    :try_run_end
    .catch Ljava/lang/Exception; {:try_run_start .. :try_run_end} :run_ex

    :run_ex
    const-string v4, "GOG download error (unexpected)"
    invoke-direct {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;->showToast(Ljava/lang/String;)V

    :run_done
    return-void
.end method
