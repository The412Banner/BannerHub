.class public final Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;
.super Ljava/lang/Object;

# BannerHub: Runnable that exchanges the GOG authorization code for a token,
# fetches the username from userData.json, saves everything to SharedPreferences,
# then finishes GogLoginActivity on the main thread.

.implements Ljava/lang/Runnable;


.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;
.field public final b:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->b:Ljava/lang/String;

    return-void
.end method


# ── readHttpResponse(HttpURLConnection): read full response body as String ────
.method public readHttpResponse(Ljava/net/HttpURLConnection;)Ljava/lang/String;
    .locals 7

    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v0

    new-instance v1, Ljava/io/InputStreamReader;

    const-string v2, "UTF-8"

    invoke-direct {v1, v0, v2}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    new-instance v2, Ljava/io/BufferedReader;

    invoke-direct {v2, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    :read_loop

    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :read_done

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :read_loop

    :read_done

    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method


# ── run: token exchange + user info fetch ─────────────────────────────────────
.method public run()V
    .locals 11

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->b:Ljava/lang/String;

    :try_start

    # ── Step 1: build token request body ─────────────────────────────────────
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "client_id=46899977096215655&client_secret=9d85c43b1482497dbbce61f6e4aa173a&grant_type=authorization_code&code="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "&redirect_uri=https%3A%2F%2Fembed.gog.com%2Fon_login_success%3Forigin%3Dclient"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2  # requestBody

    # ── Step 2: POST to token endpoint ────────────────────────────────────────
    new-instance v3, Ljava/net/URL;

    const-string v4, "https://auth.gog.com/token"

    invoke-direct {v3, v4}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v3  # URLConnection

    check-cast v3, Ljava/net/HttpURLConnection;

    const-string v4, "POST"

    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/4 v4, 0x1

    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    # Timeouts: 15 seconds (0x3A98 = 15000ms)
    const/16 v4, 0x3a98

    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const-string v4, "Content-Type"

    const-string v5, "application/x-www-form-urlencoded"

    invoke-virtual {v3, v4, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    # Write body
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v4

    const-string v5, "UTF-8"

    invoke-virtual {v2, v5}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V

    # Read response
    invoke-virtual {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->readHttpResponse(Ljava/net/HttpURLConnection;)Ljava/lang/String;

    move-result-object v4  # tokenJson

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    # ── Step 3: parse token response ─────────────────────────────────────────
    const-string v5, "access_token"

    invoke-static {v4, v5}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5  # accessToken

    if-eqz v5, :failed

    const-string v6, "refresh_token"

    invoke-static {v4, v6}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6  # refreshToken

    const-string v7, "user_id"

    invoke-static {v4, v7}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7  # userId

    # ── Step 4: fetch username from userData.json ─────────────────────────────
    new-instance v8, Ljava/net/URL;

    const-string v9, "https://embed.gog.com/userData.json"

    invoke-direct {v8, v9}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v8}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v8

    check-cast v8, Ljava/net/HttpURLConnection;

    # Timeouts on userData connection too
    const/16 v9, 0x3a98

    invoke-virtual {v8, v9}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    invoke-virtual {v8, v9}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # Set Bearer token header
    const-string v9, "Authorization"

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Bearer "

    invoke-virtual {v10, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v8, v9, v10}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0, v8}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->readHttpResponse(Ljava/net/HttpURLConnection;)Ljava/lang/String;

    move-result-object v9  # userDataJson

    invoke-virtual {v8}, Ljava/net/HttpURLConnection;->disconnect()V

    # Parse username
    const-string v10, "username"

    invoke-static {v9, v10}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9  # username

    if-nez v9, :got_username

    const-string v9, "Unknown"

    :got_username

    # ── Step 5: save to SharedPreferences ─────────────────────────────────────
    const-string v10, "bh_gog_prefs"

    const/4 v4, 0x0

    invoke-virtual {v0, v10, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    const-string v10, "access_token"

    invoke-interface {v4, v10, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    const-string v10, "refresh_token"

    invoke-interface {v4, v10, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    const-string v10, "user_id"

    invoke-interface {v4, v10, v7}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    const-string v10, "username"

    invoke-interface {v4, v10, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    # ── Step 6: finish activity on main thread ────────────────────────────────
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$3;

    invoke-direct {v2, v0}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V

    invoke-virtual {v0, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :done

    :failed

    # Token exchange failed — show toast on UI thread
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$4;

    invoke-direct {v2, v0}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V

    invoke-virtual {v0, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :done

    :try_end

    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all

    # On any network/parse error, reload the auth page
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$4;

    invoke-direct {v2, v0}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V

    invoke-virtual {v0, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method
