.class public Lcom/xj/landscape/launcher/ui/menu/GogTokenRefresh;
.super Ljava/lang/Object;

# BannerHub: Static helper for silent GOG access token refresh.
# Reads refresh_token from bh_gog_prefs, sends GET to auth.gog.com/token
# with grant_type=refresh_token query params, saves new access_token +
# refresh_token to SP, returns new access_token on success or null on failure.


.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# ── static String refresh(Context ctx) ───────────────────────────────────────
# Returns new access_token string on success, null on any failure.
.method public static refresh(Landroid/content/Context;)Ljava/lang/String;
    .locals 13

    # v0–v10 used; p0 = context

    # ── Read refresh_token from SharedPreferences ─────────────────────────────
    const-string v0, "bh_gog_prefs"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0

    const-string v1, "refresh_token"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1  # refreshToken or null

    if-nez v1, :have_refresh_token

    const/4 v0, 0x0
    return-object v0  # no stored refresh_token → caller must re-login

    :have_refresh_token

    :try_start

    # ── Build GET URL with query params ───────────────────────────────────────
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "https://auth.gog.com/token?client_id=46899977096215655&client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9&grant_type=refresh_token&refresh_token="
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2  # full URL string

    # ── Open GET connection ───────────────────────────────────────────────────
    new-instance v3, Ljava/net/URL;
    invoke-direct {v3, v2}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v3
    check-cast v3, Ljava/net/HttpURLConnection;

    const-string v4, "GET"
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v4, 0x3a98  # 15000 ms
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # ── Check HTTP status ─────────────────────────────────────────────────────
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v4
    const/16 v5, 0xC8  # 200
    if-eq v4, v5, :read_response

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    const/4 v0, 0x0
    return-object v0  # non-200 → return null

    :read_response

    # ── Read response body ────────────────────────────────────────────────────
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v4
    new-instance v5, Ljava/io/InputStreamReader;
    const-string v6, "UTF-8"
    invoke-direct {v5, v4, v6}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    new-instance v6, Ljava/io/BufferedReader;
    invoke-direct {v6, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    :read_loop
    invoke-virtual {v6}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v8
    if-eqz v8, :read_done
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop

    :read_done
    invoke-virtual {v6}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7  # JSON response body

    # ── Parse new access_token ────────────────────────────────────────────────
    const-string v8, "access_token"
    invoke-static {v7, v8}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v8  # new access_token or null

    if-nez v8, :got_access_token

    const/4 v0, 0x0
    return-object v0  # no access_token in response

    :got_access_token

    # ── Parse new refresh_token ───────────────────────────────────────────────
    const-string v9, "refresh_token"
    invoke-static {v7, v9}, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;->parseJsonStringField(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9  # new refresh_token (may be null if not rotated)

    # ── Save new tokens to SharedPreferences ──────────────────────────────────
    const-string v10, "bh_gog_prefs"
    const/4 v4, 0x0
    invoke-virtual {p0, v10, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v4

    const-string v5, "access_token"
    invoke-interface {v4, v5, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v4

    if-eqz v9, :skip_refresh_save

    const-string v5, "refresh_token"
    invoke-interface {v4, v5, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v4

    :skip_refresh_save

    # ── Store loginTime = System.currentTimeMillis() / 1000 ───────────────────
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v5   # v5+v6 = millis (long)
    const-wide/16 v9, 0x3E8  # v9+v10 = 1000L
    div-long v5, v5, v9   # v5+v6 = seconds since epoch
    long-to-int v5, v5    # v5 = int seconds (valid until 2038)
    const-string v6, "bh_gog_login_time"
    invoke-interface {v4, v6, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v4

    # ── Store expires_in = 3600 (GOG access tokens are always 1 hour) ─────────
    const/16 v5, 0xE10  # 3600
    const-string v6, "bh_gog_expires_in"
    invoke-interface {v4, v6, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-object v8  # return new access_token

    :try_end

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all
    const/4 v0, 0x0
    return-object v0

.end method
