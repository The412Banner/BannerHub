.class public Lcom/xj/landscape/launcher/ui/menu/EpicTokenRefresh;
.super Ljava/lang/Object;

# BannerHub: Static helper for silent Epic access token refresh.
# Endpoint: POST https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token
# Auth:     Basic base64(EPIC_CLIENT_ID:EPIC_CLIENT_SECRET)
# Body:     grant_type=refresh_token&refresh_token={token}&token_type=eg1
#
# refresh(Context) → EpicCredentials (updated) or null on failure.
# Uses 5-minute buffer: if (now + 5min) >= expiresAt → refresh.
#
# EPIC_CLIENT_ID     = 34a02cf8f4414e29b15921876da36f9a  (Legendary public credentials)
# EPIC_CLIENT_SECRET = daafbccc737745039dffe53d94fc76cf


.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# ── static boolean needsRefresh(EpicCredentials) ─────────────────────────────
# Returns true if token expires within 5 minutes.
.method public static needsRefresh(Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;)Z
    .locals 4

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0               # v0+v1 = now (ms)

    const-wide/32 v2, 0x4B000         # 5 * 60 * 1000 = 300000ms
    add-long v0, v0, v2               # v0+v1 = now + 5min

    iget-wide v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->expiresAt:J
    cmp-long v0, v0, v2
    if-ltz v0, :still_valid

    const/4 v0, 0x1
    return v0

    :still_valid
    const/4 v0, 0x0
    return v0
.end method


# ── static EpicCredentials refresh(Context) ──────────────────────────────────
# Loads stored credentials, refreshes if needed, saves and returns updated creds.
# Returns null if no credentials stored or refresh fails.
.method public static refresh(Landroid/content/Context;)Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
    .locals 12

    # Load stored credentials
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->load(Landroid/content/Context;)Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
    move-result-object v0
    if-nez v0, :have_creds
    const/4 v0, 0x0
    return-object v0

    :have_creds
    # Check if refresh needed
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicTokenRefresh;->needsRefresh(Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;)Z
    move-result v1
    if-nez v1, :do_refresh
    return-object v0    # still valid — return as-is

    :do_refresh
    iget-object v1, v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->refreshToken:Ljava/lang/String;
    if-nez v1, :have_refresh_token
    const/4 v0, 0x0
    return-object v0

    :have_refresh_token
    :try_start

    # ── Build POST body ───────────────────────────────────────────────────────
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "grant_type=refresh_token&refresh_token="
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, "&token_type=eg1"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2   # POST body

    # ── Open connection ───────────────────────────────────────────────────────
    const-string v3, "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token"
    new-instance v4, Ljava/net/URL;
    invoke-direct {v4, v3}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v4}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v4
    check-cast v4, Ljava/net/HttpURLConnection;

    const-string v5, "POST"
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/4 v5, 0x1
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    const/16 v5, 0x3A98   # 15000ms
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # ── Basic auth header: base64(client_id:client_secret) ───────────────────
    const-string v5, "34a02cf8f4414e29b15921876da36f9a:daafbccc737745039dffe53d94fc76cf"
    invoke-static {v5}, Landroid/util/Base64;->encode([B, I)[B
    # Base64.encode takes byte[], flags — need to get bytes first
    const-string v6, "UTF-8"
    invoke-virtual {v5}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B
    move-result-object v5
    const/4 v6, 0x2   # Base64.NO_WRAP
    invoke-static {v5, v6}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;
    move-result-object v5   # base64 encoded

    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "Basic "
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5   # "Basic <b64>"

    const-string v6, "Authorization"
    invoke-virtual {v4, v6, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v5, "Content-Type"
    const-string v6, "application/x-www-form-urlencoded"
    invoke-virtual {v4, v5, v6}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v5, "User-Agent"
    const-string v6, "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"
    invoke-virtual {v4, v5, v6}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    # ── Write body ────────────────────────────────────────────────────────────
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;
    move-result-object v5
    const-string v6, "UTF-8"
    invoke-virtual {v2}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B
    move-result-object v6
    invoke-virtual {v5, v6}, Ljava/io/OutputStream;->write([B)V
    invoke-virtual {v5}, Ljava/io/OutputStream;->close()V

    # ── Check response code ───────────────────────────────────────────────────
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v5
    const/16 v6, 0xC8   # 200
    if-eq v5, v6, :read_response
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->disconnect()V
    const/4 v0, 0x0
    return-object v0

    :read_response
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v5
    new-instance v6, Ljava/io/InputStreamReader;
    const-string v7, "UTF-8"
    invoke-direct {v6, v5, v7}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    new-instance v7, Ljava/io/BufferedReader;
    invoke-direct {v7, v6}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    :resp_loop
    invoke-virtual {v7}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v9
    if-eqz v9, :resp_done
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :resp_loop

    :resp_done
    invoke-virtual {v7}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8   # JSON response

    # ── Parse new tokens ──────────────────────────────────────────────────────
    const-string v9, "access_token"
    invoke-static {v8, v9}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9
    if-nez v9, :got_access
    const/4 v0, 0x0
    return-object v0

    :got_access
    const-string v10, "refresh_token"
    invoke-static {v8, v10}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v10

    const-string v11, "expires_at"
    invoke-static {v8, v11}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->parseJsonLongField(Ljava/lang/String;Ljava/lang/String;)J
    move-result-wide v5   # v5+v6 = expiresAt

    # ── Update credentials object ─────────────────────────────────────────────
    iput-object v9, v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accessToken:Ljava/lang/String;
    if-eqz v10, :skip_refresh
    iput-object v10, v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->refreshToken:Ljava/lang/String;
    :skip_refresh

    # If expiresAt not present in response, compute now + 2h
    const-wide/16 v2, 0x0
    cmp-long v2, v5, v2
    if-nez v2, :has_expires
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v5
    const-wide/32 v2, 0x6DDD00    # 2 * 60 * 60 * 1000 = 7200000
    add-long v5, v5, v2
    :has_expires
    iput-wide v5, v0, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->expiresAt:J

    # ── Persist and return ────────────────────────────────────────────────────
    invoke-static {p0, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->save(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;)V
    return-object v0
    :try_end

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all
    :catch_all
    const/4 v0, 0x0
    return-object v0
.end method
