.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: Background library-sync Runnable for EpicMainActivity.
# 1. Refreshes access token via EpicTokenRefresh.refresh().
# 2. GETs https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true
# 3. Parses "appName":"..." occurrences from JSON response.
# 4. Skips entries where appName is empty or "1".
# 5. Posts EpicMainActivity$2(appName) to UI thread per valid game.
# 6. Posts EpicMainActivity$3 when done (hides "Syncing..." text).
#
# Register map (.locals 15  →  p0 = v15):
#   v0  = this$0 (EpicMainActivity / Context) — preserved throughout
#   v1  = EpicCredentials → later reused as $3 Runnable
#   v2  = accessToken String
#   v3  = temp strings / StringBuilder result / closing-quote marker
#   v4  = HttpURLConnection
#   v5  = InputStream / temp
#   v6  = InputStreamReader / temp
#   v7  = BufferedReader
#   v8  = response StringBuilder → JSON String
#   v9  = line String (read loop)
#  v10  = parse cursor (int pos, reused as start pos)
#  v11  = marker string "\"appName\":"
#  v12  = indexOf/length result (int temp, reused as end pos)
#  v13  = extracted appName String
#  v14  = boolean temp / $2 Runnable
#  p0   = v15 = this (EpicMainActivity$1)
#
# Key idioms:
#   indexOf returns -1 when not found → use if-ltz (< 0) instead of if-eq reg,-1
#   add 1 literal → add-int/lit8 (format 22b, 8-bit literal)

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 15

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;

    :try_start

    const-string v3, "BH_EPIC"
    const-string v4, "sync_start"
    invoke-static {v3, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    # ── Refresh access token ───────────────────────────────────────────────────
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicTokenRefresh;->refresh(Landroid/content/Context;)Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
    move-result-object v1
    if-nez v1, :have_creds
    const-string v3, "BH_EPIC"
    const-string v4, "no_creds"
    invoke-static {v3, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    goto :sync_done

    :have_creds
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accessToken:Ljava/lang/String;
    if-nez v2, :have_token
    const-string v3, "BH_EPIC"
    const-string v4, "no_token"
    invoke-static {v3, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    goto :sync_done

    :have_token

    # ── Open connection ────────────────────────────────────────────────────────
    const-string v3, "https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true"
    new-instance v4, Ljava/net/URL;
    invoke-direct {v4, v3}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v4}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v4
    check-cast v4, Ljava/net/HttpURLConnection;

    const-string v3, "GET"
    invoke-virtual {v4, v3}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v3, 0x3A98  # 15000ms
    invoke-virtual {v4, v3}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v4, v3}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # ── Authorization: Bearer {accessToken} ───────────────────────────────────
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Bearer "
    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3

    const-string v5, "Authorization"
    invoke-virtual {v4, v5, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v3, "User-Agent"
    const-string v5, "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"
    invoke-virtual {v4, v3, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    # ── Check response code ────────────────────────────────────────────────────
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v3
    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v5
    const-string v6, "BH_EPIC"
    invoke-static {v6, v5}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    const/16 v5, 0xC8   # 200
    if-eq v3, v5, :read_resp
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->disconnect()V
    goto :sync_done

    # ── Read response body ─────────────────────────────────────────────────────
    :read_resp
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v5
    new-instance v6, Ljava/io/InputStreamReader;
    const-string v3, "UTF-8"
    invoke-direct {v6, v5, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
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
    move-result-object v8   # v8 = JSON response String

    # ── Parse "appName":"..." records ─────────────────────────────────────────
    # v10 = pos cursor;  v11 = marker;  v12 = int temp;  v13 = appName String
    # v14 = bool/runnable temp;  v3 = closing-quote string "\""
    #
    # indexOf returns -1 when not found → if-ltz detects this without a literal reg.
    # add-int/lit8 adds a small integer literal (format 22b).

    const/4 v10, 0x0
    const-string v11, "\"appName\":"
    const-string v3, "\""

    :parse_loop
    invoke-virtual {v8, v11, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10            # v10 = idx of "appName": or -1
    if-ltz v10, :sync_done     # not found → done

    # advance past marker
    invoke-virtual {v11}, Ljava/lang/String;->length()I
    move-result v12
    add-int v10, v10, v12

    # find opening quote of value (skips optional whitespace after colon)
    invoke-virtual {v8, v3, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10            # v10 = position of opening '"', or -1
    if-ltz v10, :sync_done
    add-int/lit8 v10, v10, 0x1  # advance past opening '"'

    # find closing quote
    invoke-virtual {v8, v3, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v12            # v12 = end of appName value, or -1
    if-ltz v12, :sync_done     # no closing quote → done

    # extract appName
    invoke-virtual {v8, v10, v12}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13     # v13 = appName

    # advance cursor past this value
    add-int/lit8 v10, v12, 0x1

    # skip empty appName
    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z
    move-result v14
    if-nez v14, :parse_loop

    # skip placeholder "1"
    const-string v14, "1"
    invoke-virtual {v13, v14}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v14
    if-nez v14, :parse_loop

    # post $2 to UI thread
    new-instance v14, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    invoke-direct {v14, v0, v13}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v14}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :parse_loop

    # ── Post $3 (hide "Syncing...") ────────────────────────────────────────────
    :sync_done
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$3;
    invoke-direct {v1, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;)V
    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
    :try_end

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all
    :catch_all
    const-string v0, "BH_EPIC"
    const-string v1, "exception"
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$3;
    invoke-direct {v1, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;)V
    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
