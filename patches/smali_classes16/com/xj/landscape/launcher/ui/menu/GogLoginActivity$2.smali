.class public final Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;
.super Ljava/lang/Object;

# BannerHub: Runnable that fetches the GOG username from userData.json
# using the access_token obtained via implicit flow (response_type=token).
# No token exchange needed — tokens arrive in the redirect URL fragment.
# Saves access_token, refresh_token, user_id, username to SharedPreferences
# "bh_gog_prefs", then finishes GogLoginActivity on the main thread.

.implements Ljava/lang/Runnable;


.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;
.field public final b:Ljava/lang/String;  # accessToken
.field public final c:Ljava/lang/String;  # refreshToken (may be null)
.field public final d:Ljava/lang/String;  # userId (may be null)


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->b:Ljava/lang/String;

    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->c:Ljava/lang/String;

    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->d:Ljava/lang/String;

    return-void
.end method


# ── readHttpResponse: read response body, handles 4xx/5xx via getErrorStream ──
.method public readHttpResponse(Ljava/net/HttpURLConnection;)Ljava/lang/String;
    .locals 7

    # Check HTTP status code — use getErrorStream() for 4xx/5xx
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v5  # HTTP status code

    const/16 v6, 0x190  # 400

    if-lt v5, v6, :use_input_stream

    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getErrorStream()Ljava/io/InputStream;

    move-result-object v0

    if-nez v0, :got_stream

    const-string v0, "{}"

    return-object v0

    :use_input_stream

    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v0

    :got_stream

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

    # Log response for debugging
    const-string v2, "BH_GOG"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "userData HTTP "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ": "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v0
.end method


# ── run: fetch userData.json, save tokens to SP, finish activity ──────────────
.method public run()V
    .locals 12

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->b:Ljava/lang/String;

    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->c:Ljava/lang/String;

    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->d:Ljava/lang/String;

    :try_start

    # ── Fetch username from userData.json ─────────────────────────────────────
    new-instance v4, Ljava/net/URL;

    const-string v5, "https://embed.gog.com/userData.json"

    invoke-direct {v4, v5}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v4

    check-cast v4, Ljava/net/HttpURLConnection;

    # Timeouts: 15 seconds
    const/16 v5, 0x3a98

    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    invoke-virtual {v4, v5}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # Authorization: Bearer <accessToken>
    const-string v5, "Authorization"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Bearer "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v5, v6}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0, v4}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$2;->readHttpResponse(Ljava/net/HttpURLConnection;)Ljava/lang/String;

    move-result-object v5  # userDataJson

    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->disconnect()V

    # ── Parse username ────────────────────────────────────────────────────────
    const-string v6, "username"

    invoke-static {v5, v6}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6  # username

    if-nez v6, :got_username

    const-string v6, "Unknown"

    :got_username

    # ── Save to SharedPreferences "bh_gog_prefs" ──────────────────────────────
    const-string v7, "bh_gog_prefs"

    const/4 v5, 0x0

    invoke-virtual {v0, v7, v5}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    const-string v7, "access_token"

    invoke-interface {v5, v7, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    const-string v7, "refresh_token"

    invoke-interface {v5, v7, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    const-string v7, "user_id"

    invoke-interface {v5, v7, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    const-string v7, "username"

    invoke-interface {v5, v7, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    # ── Store loginTime = System.currentTimeMillis() / 1000 ───────────────────
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v8   # v8+v9 = millis (long)
    const-wide/16 v10, 0x3E8  # v10+v11 = 1000L
    div-long v8, v8, v10  # v8+v9 = seconds since epoch
    long-to-int v8, v8    # v8 = int seconds (valid until 2038)
    const-string v9, "bh_gog_login_time"
    invoke-interface {v5, v9, v8}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    # ── Store expires_in = 3600 (GOG access tokens are always 1 hour) ─────────
    const/16 v8, 0xE10  # 3600
    const-string v9, "bh_gog_expires_in"
    invoke-interface {v5, v9, v8}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V

    # ── Finish GogLoginActivity on main thread ────────────────────────────────
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$3;

    invoke-direct {v2, v0}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V

    invoke-virtual {v0, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :done

    :done

    :try_end

    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all

    # Network/parse error — show error toast + reload auth page
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$4;

    invoke-direct {v2, v0}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V

    invoke-virtual {v0, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method
