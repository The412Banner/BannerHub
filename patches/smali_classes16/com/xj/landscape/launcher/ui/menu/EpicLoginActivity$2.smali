.class public Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: Token exchange Runnable for EpicLoginActivity.
# Runs on a background thread. POSTs authorizationCode to Epic OAuth endpoint
# (grant_type=authorization_code), saves EpicCredentials on success, then
# posts $4 (success) or $5 (failure) back to the UI thread.
#
# .locals 15 → p0 = v15 (within 4-bit range; v16 would break iget-object)
#
# Register map for run():
#   v0  = authCode (String)
#   v1  = this$0  (EpicLoginActivity / Context)  — preserved throughout
#   v2  = POST body StringBuilder → body string
#            → cmp-long int temp → wide const temp (7200000)
#            → EpicCredentials object (after :has_expires)
#            → $4/$5 runnable object (success/failure)
#   v3  = URL string → URL object → const/string temp → wide const hi
#   v4  = HttpURLConnection
#   v5  = int/OutputStream/int responseCode/InputStream/"expires_at" → wide pair lo (0L)
#   v6  = byte[]/InputStreamReader/int NO_WRAP/const 200  → wide pair hi (0L)
#   v7  = "UTF-8" / BufferedReader
#   v8  = response StringBuilder → response JSON String
#   v9  = response line (loop) → access_token
#  v10  = refresh_token
#  v11  = account_id
#  v12  = displayName
#  v13  = expiresAt wide lo
#  v14  = expiresAt wide hi
#  p0  (= v15) = this (EpicLoginActivity$2)

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;
.field final synthetic authCode:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$2;->authCode:Ljava/lang/String;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 15

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$2;->authCode:Ljava/lang/String;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;

    :try_start

    # ── Build POST body ───────────────────────────────────────────────────────
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "grant_type=authorization_code&code="
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, "&token_type=eg1"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2   # v2 = body string

    # ── Open connection ───────────────────────────────────────────────────────
    const-string v3, "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token"
    new-instance v4, Ljava/net/URL;
    invoke-direct {v4, v3}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v4}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v4
    check-cast v4, Ljava/net/HttpURLConnection;

    const-string v3, "POST"
    invoke-virtual {v4, v3}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/4 v3, 0x1
    invoke-virtual {v4, v3}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    const/16 v3, 0x3A98   # 15000ms
    invoke-virtual {v4, v3}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v4, v3}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # ── Basic auth header: base64(client_id:client_secret) ───────────────────
    const-string v5, "34a02cf8f4414e29b15921876da36f9a:daafbccc737745039dffe53d94fc76cf"
    const-string v6, "UTF-8"
    invoke-virtual {v5, v6}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B
    move-result-object v5
    const/4 v6, 0x2   # Base64.NO_WRAP
    invoke-static {v5, v6}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;
    move-result-object v5   # v5 = base64 encoded credentials

    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "Basic "
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5   # v5 = "Basic <b64>"

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
    invoke-virtual {v2, v6}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B
    move-result-object v6
    invoke-virtual {v5, v6}, Ljava/io/OutputStream;->write([B)V
    invoke-virtual {v5}, Ljava/io/OutputStream;->close()V

    # ── Check response code ───────────────────────────────────────────────────
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v5
    const/16 v6, 0xC8   # 200
    if-eq v5, v6, :read_response
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->disconnect()V
    goto :run_failure

    # ── Read response body ────────────────────────────────────────────────────
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
    move-result-object v8   # v8 = response JSON string

    # ── Parse tokens ──────────────────────────────────────────────────────────
    const-string v9, "access_token"
    invoke-static {v8, v9}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9   # v9 = access_token or null
    if-nez v9, :got_access
    goto :run_failure

    :got_access
    const-string v10, "refresh_token"
    invoke-static {v8, v10}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v10

    const-string v11, "account_id"
    invoke-static {v8, v11}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v11

    const-string v12, "displayName"
    invoke-static {v8, v12}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v12

    const-string v5, "expires_at"
    invoke-static {v8, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->parseJsonLongField(Ljava/lang/String;Ljava/lang/String;)J
    move-result-wide v13   # v13+v14 = expiresAt (0 if ISO string)

    # expiresAt fallback: if 0 use now + 2h
    const-wide/16 v5, 0x0
    cmp-long v2, v13, v5   # v2 (int) = sign(expiresAt - 0)  [v2 reused here]
    if-nez v2, :has_expires
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v13
    const-wide/32 v2, 0x6DDD00   # 7200000ms = 2h  [v2+v3 as wide]
    add-long v13, v13, v2

    :has_expires

    # ── Build EpicCredentials  [v2 reused as EpicCredentials object] ──────────
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
    invoke-direct {v2}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;-><init>()V

    iput-object v9, v2, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accessToken:Ljava/lang/String;

    if-eqz v10, :skip_refresh
    iput-object v10, v2, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->refreshToken:Ljava/lang/String;
    :skip_refresh

    if-eqz v11, :skip_account
    iput-object v11, v2, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accountId:Ljava/lang/String;
    :skip_account

    if-eqz v12, :skip_name
    iput-object v12, v2, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->displayName:Ljava/lang/String;
    :skip_name

    iput-wide v13, v2, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->expiresAt:J

    # ── Persist and post success to UI thread ─────────────────────────────────
    invoke-static {v1, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicCredentialStore;->save(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;)V

    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$4;
    invoke-direct {v3, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;)V
    invoke-virtual {v1, v3}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void

    # ── Failure: post $5 to UI thread ─────────────────────────────────────────
    :run_failure
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$5;
    invoke-direct {v2, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$5;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;)V
    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$5;
    invoke-direct {v2, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity$5;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicLoginActivity;)V
    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
