.class public final Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10;
.super Ljava/lang/Object;

# BannerHub: Background image loader for Epic game cover art.
# Fetches a Bitmap from imageUrl on a background thread via HttpURLConnection.
# On success posts EpicMainActivity$10$1 (setImageBitmap) via View.post().
# Silent catch on any exception — ImageView keeps its dark-grey placeholder.

.implements Ljava/lang/Runnable;

.field public final a:Ljava/lang/String;         # imageUrl
.field public final b:Landroid/widget/ImageView; # target ImageView


.method public constructor <init>(Ljava/lang/String;Landroid/widget/ImageView;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10;->a:Ljava/lang/String;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10;->b:Landroid/widget/ImageView;

    return-void
.end method


.method public run()V
    .locals 6

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10;->a:Ljava/lang/String;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10;->b:Landroid/widget/ImageView;

    :try_start

    # Open HTTP connection
    new-instance v2, Ljava/net/URL;
    invoke-direct {v2, v0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v2
    check-cast v2, Ljava/net/HttpURLConnection;

    const/16 v3, 0x3a98   # 15000 ms timeout
    invoke-virtual {v2, v3}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v2, v3}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v3

    const/16 v4, 0xC8   # 200
    if-ne v3, v4, :abort

    # Decode stream to Bitmap
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v3

    invoke-static {v3}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;)Landroid/graphics/Bitmap;
    move-result-object v3   # v3 = Bitmap

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    if-eqz v3, :fetch_done

    # Post setImageBitmap to main thread via View.post()
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10$1;
    invoke-direct {v4, v1, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10$1;-><init>(Landroid/widget/ImageView;Landroid/graphics/Bitmap;)V
    invoke-virtual {v1, v4}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    goto :fetch_done

    :abort
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    :fetch_done

    :try_end
    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all
    return-void

.end method
