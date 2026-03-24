.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: Background library-sync Runnable for EpicMainActivity.
# 1. Refreshes access token via EpicTokenRefresh.refresh().
# 2. GETs the library URL stored in the `url` field (first page = base URL;
#    subsequent pages append &cursor={stateToken} from prior response).
# 3. Parses "appName":"..." occurrences from JSON response.
# 4. Skips entries where appName is empty or "1".
# 5. Posts EpicMainActivity$2(appName) to UI thread per valid game.
# 6. At end: if response contains "stateToken", spawns new $1 with next URL.
#    Otherwise posts "Sync done" status (hides "Syncing..." text).
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
#  v12  = indexOf/length result (int temp, reused as end pos / platform bound)
#  v13  = extracted appName String
#  v14  = boolean temp / $2 Runnable / platform check result
#  p0   = v15 = this (EpicMainActivity$1)
#
# Key idioms:
#   indexOf returns -1 when not found → use if-ltz (< 0) instead of if-eq reg,-1
#   add 1 literal → add-int/lit8 (format 22b, 8-bit literal)

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic url:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->url:Ljava/lang/String;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 15

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;

    :try_start

    const-string v3, "BH_EPIC"
    const-string v4, "sync_start"
    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    iget-object v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->url:Ljava/lang/String;
    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    # Show on-screen status
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;
    const-string v4, "Syncing library..."
    invoke-direct {v3, v0, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v3}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    # ── Refresh access token ───────────────────────────────────────────────────
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicTokenRefresh;->refresh(Landroid/content/Context;)Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
    move-result-object v1
    if-nez v1, :have_creds
    const-string v3, "BH_EPIC"
    const-string v4, "no_creds"
    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;
    const-string v4, "Err: token refresh returned null"
    invoke-direct {v3, v0, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v3}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void

    :have_creds
    iget-object v2, v1, Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;->accessToken:Ljava/lang/String;
    if-nez v2, :have_token
    const-string v3, "BH_EPIC"
    const-string v4, "no_token"
    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;
    const-string v4, "Err: null access token"
    invoke-direct {v3, v0, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v3}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void

    :have_token

    # ── Open connection ────────────────────────────────────────────────────────
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->url:Ljava/lang/String;
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
    invoke-static {v6, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    const/16 v5, 0xC8   # 200
    if-eq v3, v5, :read_resp
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->disconnect()V
    # show HTTP error code on screen
    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v4
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "HTTP error: "
    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;
    invoke-direct {v3, v0, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v3}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void

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

    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;
    const-string v4, "Parsing library..."
    invoke-direct {v3, v0, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v3}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    # ── Parse "appName":"..." records ─────────────────────────────────────────
    # v10 = pos cursor;  v11 = appName marker;  v12 = int temp;  v13 = appName String
    # v14 = bool/runnable temp;  v3 = closing-quote string "\""
    # v4  = namespace marker;    v5  = catalogItemId marker
    # v6  = namespace String;    v7  = catalogItemId String
    # v9  = backward-search temp position
    #
    # indexOf returns -1 when not found → if-ltz detects this without a literal reg.
    # add-int/lit8 adds a small integer literal (format 22b).
    # lastIndexOf(String,int) searches backward from cursor — finds same-record field.

    const/4 v10, 0x0
    const-string v11, "\"appName\" :"
    const-string v3, "\""
    const-string v4, "\"namespace\" :"
    const-string v5, "\"catalogItemId\" :"

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

    # ── Extract namespace (forward search from cursor) ────────────────────────
    const-string v6, ""
    invoke-virtual {v8, v4, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v9
    if-ltz v9, :ns_done
    invoke-virtual {v4}, Ljava/lang/String;->length()I
    move-result v12
    add-int v9, v9, v12
    invoke-virtual {v8, v3, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v9
    if-ltz v9, :ns_done
    add-int/lit8 v9, v9, 0x1
    invoke-virtual {v8, v3, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v12
    if-ltz v12, :ns_done
    invoke-virtual {v8, v9, v12}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v6
    :ns_done

    # Skip namespace "ue" (Unreal Engine tools — not installable games)
    const-string v9, "ue"
    invoke-virtual {v6, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v14
    if-nez v14, :parse_loop

    # ── Extract catalogItemId (forward search from cursor) ────────────────────
    const-string v7, ""
    invoke-virtual {v8, v5, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v9
    if-ltz v9, :cat_done
    invoke-virtual {v5}, Ljava/lang/String;->length()I
    move-result v12
    add-int v9, v9, v12
    invoke-virtual {v8, v3, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v9
    if-ltz v9, :cat_done
    add-int/lit8 v9, v9, 0x1
    invoke-virtual {v8, v3, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v12
    if-ltz v12, :cat_done
    invoke-virtual {v8, v9, v12}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v7
    :cat_done

    # ── Platform filter: skip non-Windows entries ─────────────────────────────
    # Extract this record's JSON fragment: from v10 to the next "appName" marker.
    # This bounds the search to the current record, avoiding false matches.
    # v12 = next record start (or string length if this is the last record)
    # v9  = record fragment string
    invoke-virtual {v8, v11, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v12
    if-gez v12, :plat_have_bound
    invoke-virtual {v8}, Ljava/lang/String;->length()I
    move-result v12
    :plat_have_bound
    invoke-virtual {v8, v10, v12}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v9   # v9 = current record JSON fragment

    const-string v12, "\"platform\""
    invoke-virtual {v9, v12}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v14
    if-eqz v14, :plat_ok   # no platform field → keep (assume Windows-compatible)

    const-string v12, "Windows"
    invoke-virtual {v9, v12}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v14
    if-nez v14, :plat_ok

    const-string v12, "Win32"
    invoke-virtual {v9, v12}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v14
    if-nez v14, :plat_ok

    goto :parse_loop   # platform field exists but no Windows/Win32 → skip

    :plat_ok

    # Save library appName (v13) before fetchTitle might overwrite it.
    # v12 is free here (was temp position in platform check).
    # v12 = library appName (for manifest URL); v13 = display title (for card UI).
    move-object v12, v13

    # ── Fetch display title from catalog API ──────────────────────────────────
    # Returns: null = DLC (skip), "" = fetch failed (keep v13=appName), else = title
    invoke-static {v0, v2, v6, v7}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$6;->fetchTitle(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9
    if-nez v9, :not_dlc   # null = DLC → log and skip
    const-string v3, "BH_EPIC"
    new-instance v9, Ljava/lang/StringBuilder;
    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "dlc:"
    invoke-virtual {v9, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v9, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v9
    invoke-static {v3, v9}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    goto :parse_loop
    :not_dlc
    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z
    move-result v14
    if-nez v14, :title_done   # "" = fetch failed → v13 stays as library appName
    move-object v13, v9        # fetchTitle succeeded → v13 = display title
    :title_done
    # Replace library UUID in v12 with catalog artifact appName when available.
    # $6.lastAppName is set (and reset) inside fetchTitle for each call.
    sget-object v9, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$6;->lastAppName:Ljava/lang/String;
    # DEBUG: log what the catalog API returned for "appName"
    const-string v14, "BH_EPIC"
    invoke-static {v14, v9}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    if-eqz v9, :keep_lib_appname
    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z
    move-result v14
    if-nez v14, :keep_lib_appname
    move-object v12, v9   # v12 = catalog artifact appName (correct for manifest URL)
    :keep_lib_appname
    # v12 = artifact appName for manifest URL
    # v13 = display title (or library UUID if fetchTitle failed)

    # Fetch cover art URL
    invoke-static {v0, v2, v6, v7}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$6;->fetchCoverUrl(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v9   # v9 = coverUrl ("" if not found)

    # post $2 to UI thread:
    #   appName field (v12) = library appName → used in manifest URL via $5/$9/$7
    #   displayTitle field (v13) = display title → shown on card TextView
    new-instance v14, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    invoke-direct {v14, v0, v12, v6, v7}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    iput-object v9, v14, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$coverUrl:Ljava/lang/String;
    iput-object v13, v14, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->displayTitle:Ljava/lang/String;
    invoke-virtual {v0, v14}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :parse_loop

    # ── Parse done — check for next page via stateToken ───────────────────────
    :sync_done
    # v8 = full JSON response (still valid); v0 = context; v2 = accessToken
    # Parse "nextCursor" value using format-agnostic seek
    const-string v3, "\"nextCursor\""
    const-string v4, "\""
    const/4 v9, 0x0
    invoke-virtual {v8, v3, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v9
    if-ltz v9, :no_next_page

    invoke-virtual {v3}, Ljava/lang/String;->length()I
    move-result v10
    add-int v9, v9, v10

    invoke-virtual {v8, v4, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v9
    if-ltz v9, :no_next_page
    add-int/lit8 v9, v9, 0x1

    invoke-virtual {v8, v4, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10
    if-ltz v10, :no_next_page

    invoke-virtual {v8, v9, v10}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v3   # v3 = stateToken value
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z
    move-result v9
    if-nez v9, :no_next_page

    # Log the cursor value
    const-string v4, "BH_EPIC"
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v9, "cursor:"
    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-static {v4, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    # Build next URL: base_url + "&cursor=" + nextCursor
    iget-object v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->url:Ljava/lang/String;
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, "&cursor="
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3   # v3 = next page URL

    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;
    invoke-direct {v4, v0, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    new-instance v5, Ljava/lang/Thread;
    invoke-direct {v5, v4}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v5}, Ljava/lang/Thread;->start()V
    return-void

    :no_next_page
    const-string v3, "BH_EPIC"
    const-string v4, "lastpage"
    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;
    const-string v3, "Sync done"
    invoke-direct {v1, v0, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
    :try_end

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all
    :catch_all
    move-exception v3
    invoke-virtual {v3}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v3          # v3 = "java.io.IOException: ..." or similar
    const-string v4, "BH_EPIC"
    invoke-static {v4, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    # Show exception on screen instead of hiding, so user can read it
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;
    invoke-direct {v1, v0, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$4;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;)V
    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
.end method
