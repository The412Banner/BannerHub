.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$6;
.super Ljava/lang/Object;

# BannerHub: Static catalog title fetcher for EpicMainActivity.
# fetchTitle(Context, String accessToken, String namespace, String catalogItemId)
#   GETs the Epic catalog API for one item and parses the "title" field.
#   Returns the title string, or "" on any failure (network, auth, parse).
#
# Endpoint:
#   https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/
#   namespace/{namespace}/bulk/items?id={catalogItemId}&includeDLCDetails=true
#   &includeMainGameDetails=true&country=US&locale=en-US
#
# Register map (.locals 10 — static method, no p0=this):
#   p0 = Context
#   p1 = accessToken
#   p2 = namespace
#   p3 = catalogItemId
#   v0 = StringBuilder / URL / temp
#   v1 = string temp
#   v2 = HttpURLConnection
#   v3 = InputStream / InputStreamReader
#   v4 = BufferedReader
#   v5 = response StringBuilder → response String
#   v6 = line String (read loop)
#   v7 = int temp (cursor, indexOf result)
#   v8 = title key marker "\"title\""
#   v9 = quote marker string "\""
# Parse strategy: find "title" key, then seek next '"' past it (skips any
# spacing around ':'), extract until next '"'. Works for both compact
# ("title":"value") and pretty-printed ("title" : "value") JSON.


.method public static fetchTitle(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 10

    # Short-circuit if namespace or catalogItemId is empty
    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z
    move-result v0
    if-nez v0, :no_title
    invoke-virtual {p3}, Ljava/lang/String;->isEmpty()Z
    move-result v0
    if-nez v0, :no_title

    :try_start

    # Build URL: .../namespace/{namespace}/bulk/items?id={catalogItemId}&...
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace/"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, "/bulk/items?id="
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, "&includeMainGameDetails=true&country=US&locale=en-US"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1   # v1 = URL string

    new-instance v0, Ljava/net/URL;
    invoke-direct {v0, v1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v2
    check-cast v2, Ljava/net/HttpURLConnection;

    const-string v0, "GET"
    invoke-virtual {v2, v0}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V
    const/16 v0, 0x1388   # 5000ms connect + read timeout
    invoke-virtual {v2, v0}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v2, v0}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # Authorization: Bearer {accessToken}
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "Bearer "
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v1, "Authorization"
    invoke-virtual {v2, v1, v0}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "User-Agent"
    const-string v1, "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"
    invoke-virtual {v2, v0, v1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v7
    const/16 v0, 0xC8   # 200
    if-ne v7, v0, :non200

    # ── Read response body ────────────────────────────────────────────────────
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v3
    new-instance v0, Ljava/io/InputStreamReader;
    const-string v1, "UTF-8"
    invoke-direct {v0, v3, v1}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    new-instance v4, Ljava/io/BufferedReader;
    invoke-direct {v4, v0}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    :read_loop
    invoke-virtual {v4}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v6
    if-eqz v6, :read_done
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop

    :read_done
    invoke-virtual {v4}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5   # v5 = JSON response

    # ── DLC check: only filter if mainGameItem is positively an object ────────
    # Look for "mainGameItem":{" or "mainGameItem\" : {" — the opening brace of
    # the parent-game object that Epic sets on DLC items.
    # Any other value (null, absent, empty) is treated as a base game.
    # This avoids false positives from null-spacing variations.
    const-string v8, "mainGameItem\":{"
    const/4 v7, 0x0
    invoke-virtual {v5, v8, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v7
    if-gez v7, :is_dlc   # compact ":{" found → DLC

    const-string v8, "mainGameItem\" : {"
    const/4 v7, 0x0
    invoke-virtual {v5, v8, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v7
    if-gez v7, :is_dlc   # pretty-printed " : {" found → DLC

    # No DLC marker found → base game, proceed to title parse
    goto :not_dlc

    :is_dlc
    const-string v0, ""
    return-object v0   # diagnostic: return "" so DLC shows as UUID appName instead of being dropped

    :not_dlc

    # ── Parse "title" value — format-agnostic (works with and without spaces) ──
    # Strategy: find "title" key, then seek to the NEXT '"' after it.
    # That '"' is the opening quote of the value regardless of ":" or " : " spacing.
    const-string v8, "\"title\""
    const-string v9, "\""
    const/4 v7, 0x0

    # Find "title" key
    invoke-virtual {v5, v8, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v7
    if-ltz v7, :no_title

    # Advance past the key (length of "\"title\"" = 7 chars)
    invoke-virtual {v8}, Ljava/lang/String;->length()I
    move-result v0
    add-int v7, v7, v0

    # Find opening quote of value (skips `:` and any whitespace)
    invoke-virtual {v5, v9, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v7
    if-ltz v7, :no_title
    add-int/lit8 v7, v7, 0x1   # advance past opening quote

    # Find closing quote
    invoke-virtual {v5, v9, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :no_title

    invoke-virtual {v5, v7, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v0   # v0 = title
    return-object v0

    :non200
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all
    :no_title
    const-string v0, ""
    return-object v0

.end method


# ── fetchCoverUrl ──────────────────────────────────────────────────────────────
# Same HTTP call as fetchTitle; parses keyImages for DieselGameBoxTall URL.
# Falls back to DieselGameBox if Tall not found.  Returns "" on any failure.
.method public static fetchCoverUrl(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 10
    # p0=Context, p1=accessToken, p2=namespace, p3=catalogItemId

    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z
    move-result v0
    if-nez v0, :no_cover
    invoke-virtual {p3}, Ljava/lang/String;->isEmpty()Z
    move-result v0
    if-nez v0, :no_cover

    :try_start

    # Build catalog URL (same endpoint as fetchTitle)
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace/"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, "/bulk/items?id="
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, "&includeMainGameDetails=true&country=US&locale=en-US"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1

    # Open HTTP GET
    new-instance v0, Ljava/net/URL;
    invoke-direct {v0, v1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v2
    check-cast v2, Ljava/net/HttpURLConnection;
    const/16 v1, 0x3a98
    invoke-virtual {v2, v1}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v2, v1}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V
    const-string v1, "GET"
    invoke-virtual {v2, v1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V
    const-string v1, "User-Agent"
    const-string v3, "EpicGamesLauncher/14.0.8"
    invoke-virtual {v2, v1, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V
    const-string v1, "Authorization"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Bearer "
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v1, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v1
    const/16 v3, 0xC8
    if-ne v1, v3, :non200

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v3
    new-instance v0, Ljava/io/InputStreamReader;
    invoke-direct {v0, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V
    new-instance v4, Ljava/io/BufferedReader;
    invoke-direct {v4, v0}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    :read_loop
    invoke-virtual {v4}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v6
    if-eqz v6, :read_done
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop
    :read_done
    invoke-virtual {v4}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5   # v5 = JSON response

    # ── Find cover image type: try DieselGameBoxTall first, then DieselGameBox ─
    const-string v8, "DieselGameBoxTall"
    const/4 v7, 0x0
    invoke-virtual {v5, v8, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v7
    if-gez v7, :found_type

    # Fallback: "DieselGameBox" with surrounding quotes avoids matching BoxTall
    const-string v8, "\"DieselGameBox\""
    const/4 v7, 0x0
    invoke-virtual {v5, v8, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v7
    if-ltz v7, :no_cover

    :found_type
    # From v7, find "url" key forward (within the same JSON object, ~300 chars)
    const-string v9, "\"url\""
    invoke-virtual {v5, v9, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v7
    if-ltz v7, :no_cover

    # Advance past "url" key length
    invoke-virtual {v9}, Ljava/lang/String;->length()I
    move-result v0
    add-int v7, v7, v0

    # Find opening quote of value (skips ':' and any whitespace)
    const-string v9, "\""
    invoke-virtual {v5, v9, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v7
    if-ltz v7, :no_cover
    add-int/lit8 v7, v7, 0x1   # past opening quote

    # Find closing quote
    invoke-virtual {v5, v9, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :no_cover

    invoke-virtual {v5, v7, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v0
    return-object v0

    :non200
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all
    :no_cover
    const-string v0, ""
    return-object v0

.end method
