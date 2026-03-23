.class public Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;
.super Ljava/lang/Object;

# BannerHub: Reads/writes Epic credentials to {filesDir}/epic/credentials.json.
# JSON format (single-line, no whitespace):
#   {"access_token":"...","refresh_token":"...","account_id":"...",
#    "display_name":"...","expires_at":1234567890123}
#
# Static methods:
#   getCredFile(Context)          → File
#   load(Context)                 → EpicCredentials or null
#   save(Context, EpicCredentials)→ void
#   clear(Context)                → void
#   parseJsonLongField(json, key) → long  (shared utility)


.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# ── static File getCredFile(Context) ─────────────────────────────────────────
.method public static getCredFile(Landroid/content/Context;)Ljava/io/File;
    .locals 3

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v0

    const-string v1, "epic"
    new-instance v2, Ljava/io/File;
    invoke-direct {v2, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v2}, Ljava/io/File;->mkdirs()Z

    const-string v1, "credentials.json"
    new-instance v0, Ljava/io/File;
    invoke-direct {v0, v2, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method


# ── static EpicCredentials load(Context) ─────────────────────────────────────
.method public static load(Landroid/content/Context;)Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
    .locals 12

    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->getCredFile(Landroid/content/Context;)Ljava/io/File;
    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->exists()Z
    move-result v1
    if-nez v1, :file_exists
    const/4 v0, 0x0
    return-object v0

    :file_exists
    :try_start
    new-instance v1, Ljava/io/FileInputStream;
    invoke-direct {v1, v0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    new-instance v2, Ljava/io/InputStreamReader;
    const-string v3, "UTF-8"
    invoke-direct {v2, v1, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    new-instance v3, Ljava/io/BufferedReader;
    invoke-direct {v3, v2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    :read_loop
    invoke-virtual {v3}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v5
    if-eqz v5, :read_done
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop

    :read_done
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4   # full JSON string

    const-string v5, "access_token"
    invoke-static {v4, v5}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5

    const-string v6, "refresh_token"
    invoke-static {v4, v6}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6

    const-string v7, "account_id"
    invoke-static {v4, v7}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v7

    const-string v8, "display_name"
    invoke-static {v4, v8}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v8

    const-string v9, "expires_at"
    invoke-static {v4, v9}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->parseJsonLongField(Ljava/lang/String;Ljava/lang/String;)J
    move-result-wide v9     # v9+v10 = expiresAt
    :try_end

    if-eqz v5, :parse_fail

    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
    invoke-direct {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;-><init>()V
    iput-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accessToken:Ljava/lang/String;
    iput-object v6, v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->refreshToken:Ljava/lang/String;
    iput-object v7, v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accountId:Ljava/lang/String;
    iput-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->displayName:Ljava/lang/String;
    iput-wide v9, v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->expiresAt:J
    return-object v0

    :parse_fail
    const/4 v0, 0x0
    return-object v0

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all
    :catch_all
    const/4 v0, 0x0
    return-object v0
.end method


# ── static void save(Context, EpicCredentials) ───────────────────────────────
.method public static save(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;)V
    .locals 6

    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->getCredFile(Landroid/content/Context;)Ljava/io/File;
    move-result-object v0

    :try_start
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "{\"access_token\":\""
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget-object v2, p1, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accessToken:Ljava/lang/String;
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\",\"refresh_token\":\""
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget-object v2, p1, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->refreshToken:Ljava/lang/String;
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\",\"account_id\":\""
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget-object v2, p1, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accountId:Ljava/lang/String;
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\",\"display_name\":\""
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget-object v2, p1, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->displayName:Ljava/lang/String;
    if-nez v2, :has_name
    const-string v2, ""
    :has_name
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\",\"expires_at\":"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget-wide v2, p1, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->expiresAt:J
    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, "}"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1

    new-instance v2, Ljava/io/FileOutputStream;
    invoke-direct {v2, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    new-instance v3, Ljava/io/OutputStreamWriter;
    const-string v4, "UTF-8"
    invoke-direct {v3, v2, v4}, Ljava/io/OutputStreamWriter;-><init>(Ljava/io/OutputStream;Ljava/lang/String;)V
    invoke-virtual {v3, v1}, Ljava/io/OutputStreamWriter;->write(Ljava/lang/String;)V
    invoke-virtual {v3}, Ljava/io/OutputStreamWriter;->close()V
    :try_end

    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_e
    :catch_e
    return-void
.end method


# ── static void clear(Context) ───────────────────────────────────────────────
.method public static clear(Landroid/content/Context;)V
    .locals 1
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->getCredFile(Landroid/content/Context;)Ljava/io/File;
    move-result-object v0
    invoke-virtual {v0}, Ljava/io/File;->delete()Z
    return-void
.end method


# ── static long parseJsonLongField(String json, String key) ──────────────────
# Returns the numeric long after "key": in the JSON. Returns 0L on failure.
.method public static parseJsonLongField(Ljava/lang/String;Ljava/lang/String;)J
    .locals 8

    :try_start
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "\""
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, "\":"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I
    move-result v1
    const/4 v2, -0x1
    if-ne v1, v2, :found
    const-wide/16 v0, 0x0
    return-wide v0

    :found
    invoke-virtual {v0}, Ljava/lang/String;->length()I
    move-result v2
    add-int v1, v1, v2

    invoke-virtual {p0}, Ljava/lang/String;->length()I
    move-result v3

    :skip_ws
    if-ge v1, v3, :ws_done
    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C
    move-result v4
    const/16 v5, 0x20
    if-ne v4, v5, :ws_done
    add-int/lit8 v1, v1, 0x1
    goto :skip_ws
    :ws_done

    move v2, v1
    :num_loop
    if-ge v2, v3, :num_done
    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C
    move-result v4
    const/16 v5, 0x30
    const/16 v6, 0x39
    if-lt v4, v5, :check_minus
    if-gt v4, v6, :num_done
    add-int/lit8 v2, v2, 0x1
    goto :num_loop
    :check_minus
    const/16 v5, 0x2D
    if-ne v4, v5, :num_done
    add-int/lit8 v2, v2, 0x1
    goto :num_loop
    :num_done

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0
    return-wide v0
    :try_end

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all
    :catch_all
    const-wide/16 v0, 0x0
    return-wide v0
.end method
