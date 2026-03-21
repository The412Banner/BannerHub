.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;
.super Ljava/lang/Object;

# BannerHub: Background fetch Runnable for GogGamesFragment.
# GETs embed.gog.com/account/getFilteredProducts?mediaType=1&sortBy=title
# with Bearer auth, parses "title":"..." entries, posts GogGamesFragment$2
# to the main thread via Handler(Looper.getMainLooper()).
# On any exception posts an empty list so the UI shows "No GOG games found".

.implements Ljava/lang/Runnable;

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
.field public final b:Ljava/lang/String;  # accessToken


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->b:Ljava/lang/String;

    return-void
.end method


.method public run()V
    .locals 10

    # v0 = fragment ref
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    # v1 = accessToken
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->b:Ljava/lang/String;

    # titles = new ArrayList
    new-instance v2, Ljava/util/ArrayList;
    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    :try_start

    # Open connection
    new-instance v3, Ljava/net/URL;
    const-string v4, "https://embed.gog.com/account/getFilteredProducts?mediaType=1&sortBy=title"
    invoke-direct {v3, v4}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v3
    check-cast v3, Ljava/net/HttpURLConnection;

    # Timeouts: 15 s
    const/16 v4, 0x3a98
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # Authorization header
    const-string v4, "Authorization"
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "Bearer "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v3, v4, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    # Check HTTP response code — non-200 means expired/invalid token
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v4
    const/16 v5, 0xC8  # 200
    if-eq v4, v5, :ok_200

    # Non-200 (e.g. 401 Unauthorized): clear stored access_token so the UI
    # shows the "sign in" prompt rather than "loading" on next open
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v4
    if-eqz v4, :expired_disconnect
    const-string v5, "bh_gog_prefs"
    const/4 v6, 0x0
    invoke-virtual {v4, v5, v6}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v5
    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v5
    const-string v6, "access_token"
    invoke-interface {v5, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5
    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V
    :expired_disconnect
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    const/4 v2, 0x0  # null list — signals session expired to $2
    goto :post_ui

    :ok_200
    # Read response
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
    move-result-object v7  # json response string

    # Parse all "title":"VALUE" entries
    # v8 = search key, v9 = pos
    const-string v8, "\"title\":\""
    const/4 v9, 0x0

    :parse_loop
    invoke-virtual {v7, v8, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v9
    const/4 v4, -0x1
    if-eq v9, v4, :parse_done

    # advance past the key+opening-quote
    invoke-virtual {v8}, Ljava/lang/String;->length()I
    move-result v4
    add-int/2addr v9, v4  # v9 = index of first char of title value

    # find closing quote
    const-string v4, "\""
    invoke-virtual {v7, v4, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v4
    const/4 v5, -0x1
    if-eq v4, v5, :parse_done

    invoke-virtual {v7, v9, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v5  # title string

    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    # next search starts after closing quote
    add-int/lit8 v9, v4, 0x1
    goto :parse_loop

    :parse_done

    :try_end

    # Post UI runnable to main thread
    :post_ui
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v3

    new-instance v4, Landroid/os/Handler;
    invoke-direct {v4, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;
    invoke-direct {v3, v0, v2}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/util/ArrayList;)V

    invoke-virtual {v4, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all
    # On error: post empty list → UI shows "No GOG games found"
    goto :post_ui

.end method
