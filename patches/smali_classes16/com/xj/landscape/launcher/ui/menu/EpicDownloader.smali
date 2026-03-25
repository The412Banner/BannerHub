.class public Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;
.super Ljava/lang/Object;
.source "EpicDownloader.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;,
        Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;,
        Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;,
        Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;,
        Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;,
        Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "EpicDownloader"

.field private static final UA:Ljava/lang/String; = "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static dbg(Landroid/content/Context;Ljava/lang/String;)V
    .locals 3

    .prologue
    .line 852
    const-string v0, "EpicDownloader"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[DBG] "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 853
    if-nez p0, :cond_1

    .line 862
    :cond_0
    :goto_0
    return-void

    .line 855
    :cond_1
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0, v0}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    .line 856
    if-eqz v0, :cond_0

    .line 857
    new-instance v1, Ljava/io/File;

    const-string v2, "bh_epic_debug.txt"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 858
    new-instance v0, Ljava/io/FileWriter;

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Ljava/io/FileWriter;-><init>(Ljava/io/File;Z)V

    .line 859
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/io/FileWriter;->write(Ljava/lang/String;)V

    .line 860
    invoke-virtual {v0}, Ljava/io/FileWriter;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 861
    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method public static decompressChunk([BI)[B
    .locals 6

    .prologue
    const/4 v0, 0x0

    .line 602
    :try_start_0
    invoke-static {p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v1

    sget-object v2, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 603
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    .line 604
    const v3, -0x4e01c55e

    if-eq v2, v3, :cond_0

    .line 605
    const-string v1, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Bad chunk magic: 0x"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-static {v2}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 644
    :goto_0
    return-object v0

    .line 608
    :cond_0
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    .line 609
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    .line 610
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v3

    .line 611
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    add-int/lit8 v4, v4, 0x10

    invoke-virtual {v1, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 612
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    add-int/lit8 v4, v4, 0x8

    invoke-virtual {v1, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 613
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B

    move-result v1

    and-int/lit16 v4, v1, 0xff

    .line 616
    if-ltz v2, :cond_1

    array-length v1, p0

    if-lt v2, v1, :cond_2

    .line 617
    :cond_1
    const-string v1, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Bad chunk headerSize: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 642
    :catch_0
    move-exception v1

    .line 643
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "decompressChunk error: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 620
    :cond_2
    :try_start_1
    new-array v1, v3, [B

    .line 621
    const/4 v5, 0x0

    invoke-static {p0, v2, v1, v5, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 623
    and-int/lit8 v2, v4, 0x1

    if-eqz v2, :cond_6

    .line 625
    new-instance v2, Ljava/util/zip/Inflater;

    invoke-direct {v2}, Ljava/util/zip/Inflater;-><init>()V

    .line 626
    invoke-virtual {v2, v1}, Ljava/util/zip/Inflater;->setInput([B)V

    .line 627
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    .line 628
    if-lez p1, :cond_3

    :goto_1
    invoke-direct {v1, p1}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 629
    const/high16 v3, 0x10000

    new-array v3, v3, [B

    .line 631
    :goto_2
    invoke-virtual {v2, v3}, Ljava/util/zip/Inflater;->inflate([B)I

    move-result v4

    if-lez v4, :cond_4

    const/4 v5, 0x0

    invoke-virtual {v1, v3, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_2

    .line 628
    :cond_3
    const/high16 p1, 0x100000

    goto :goto_1

    .line 632
    :cond_4
    invoke-virtual {v2}, Ljava/util/zip/Inflater;->end()V

    .line 633
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1

    .line 634
    array-length v2, v1

    if-nez v2, :cond_5

    .line 635
    const-string v1, "EpicDownloader"

    const-string v2, "Chunk inflate produced 0 bytes"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0

    :cond_5
    move-object v0, v1

    .line 638
    goto/16 :goto_0

    :cond_6
    move-object v0, v1

    .line 641
    goto/16 :goto_0
.end method

.method public static deleteDir(Ljava/io/File;)V
    .locals 5

    .prologue
    .line 839
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_0

    .line 848
    :goto_0
    return-void

    .line 840
    :cond_0
    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v1

    .line 841
    if-eqz v1, :cond_2

    .line 842
    array-length v2, v1

    const/4 v0, 0x0

    :goto_1
    if-ge v0, v2, :cond_2

    aget-object v3, v1, v0

    .line 843
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->deleteDir(Ljava/io/File;)V

    .line 842
    :goto_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 844
    :cond_1
    invoke-virtual {v3}, Ljava/io/File;->delete()Z

    goto :goto_2

    .line 847
    :cond_2
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    goto :goto_0
.end method

.method public static downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B
    .locals 7

    .prologue
    const/4 v1, 0x0

    .line 768
    .line 770
    :try_start_0
    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 771
    const/16 v2, 0x7530

    :try_start_1
    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 772
    const v2, 0xea60

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 773
    const-string v2, "GET"

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    .line 774
    const-string v2, "User-Agent"

    const-string v3, "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"

    invoke-virtual {v0, v2, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 775
    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_0

    .line 776
    const-string v2, "Authorization"

    invoke-virtual {v0, v2, p1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 778
    :cond_0
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v2

    .line 779
    const/16 v3, 0xc8

    if-eq v2, v3, :cond_2

    .line 780
    const-string v3, "EpicDownloader"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "HTTP "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, " for "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v3, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 794
    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_1
    move-object v0, v1

    .line 792
    :goto_0
    return-object v0

    .line 783
    :cond_2
    :try_start_2
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    .line 784
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v3}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 785
    const/16 v4, 0x2000

    new-array v4, v4, [B

    .line 787
    :goto_1
    invoke-virtual {v2, v4}, Ljava/io/InputStream;->read([B)I

    move-result v5

    const/4 v6, -0x1

    if-eq v5, v6, :cond_4

    const/4 v6, 0x0

    invoke-virtual {v3, v4, v6, v5}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    goto :goto_1

    .line 790
    :catch_0
    move-exception v2

    move-object v3, v0

    .line 791
    :goto_2
    :try_start_3
    const-string v0, "EpicDownloader"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "downloadBytes error ["

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "]: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v2}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    .line 794
    if-eqz v3, :cond_3

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_3
    move-object v0, v1

    .line 792
    goto :goto_0

    .line 788
    :cond_4
    :try_start_4
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    .line 789
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    move-result-object v1

    .line 794
    if-eqz v0, :cond_5

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_5
    move-object v0, v1

    .line 789
    goto :goto_0

    .line 794
    :catchall_0
    move-exception v0

    move-object v2, v0

    move-object v3, v1

    :goto_3
    if-eqz v3, :cond_6

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 795
    :cond_6
    throw v2

    .line 794
    :catchall_1
    move-exception v1

    move-object v2, v1

    move-object v3, v0

    goto :goto_3

    :catchall_2
    move-exception v0

    move-object v2, v0

    goto :goto_3

    .line 790
    :catch_1
    move-exception v0

    move-object v2, v0

    move-object v3, v1

    goto :goto_2
.end method

.method public static downloadChunk(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;Ljava/lang/String;Ljava/util/List;Ljava/io/File;)Z
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;",
            "Ljava/lang/String;",
            "Ljava/util/List",
            "<",
            "Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;",
            ">;",
            "Ljava/io/File;",
            ")Z"
        }
    .end annotation

    .prologue
    .line 565
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->getPath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 567
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_0
    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    .line 571
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->cloudDir:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, "/"

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 573
    const/4 v4, 0x0

    :try_start_0
    invoke-static {v1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v1

    .line 574
    if-eqz v1, :cond_0

    .line 576
    iget v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->windowSize:I

    invoke-static {v1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->decompressChunk([BI)[B

    move-result-object v1

    .line 577
    if-nez v1, :cond_1

    .line 578
    const-string v1, "EpicDownloader"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Decompress failed for chunk from "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 586
    :catch_0
    move-exception v1

    .line 587
    const-string v4, "EpicDownloader"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "CDN "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v5, " failed for "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v5, ": "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v4, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    .line 582
    :cond_1
    :try_start_1
    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, p3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 583
    :try_start_2
    invoke-virtual {v4, v1}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    .line 584
    const/4 v0, 0x1

    .line 591
    :goto_1
    return v0

    .line 583
    :catchall_0
    move-exception v1

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    throw v1
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    .line 590
    :cond_2
    const-string v0, "EpicDownloader"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "All CDNs failed for chunk "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 591
    const/4 v0, 0x0

    goto :goto_1
.end method

.method public static downloadManifest(Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)[B
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/util/List",
            "<",
            "Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;",
            ">;)[B"
        }
    .end annotation

    .prologue
    const/4 v1, 0x0

    .line 368
    :try_start_0
    const-string v0, "\"manifests\""

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    .line 369
    if-gez v0, :cond_0

    move-object v0, v1

    .line 401
    :goto_0
    return-object v0

    .line 370
    :cond_0
    const-string v2, "\"uri\""

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 371
    if-gez v0, :cond_1

    move-object v0, v1

    goto :goto_0

    .line 372
    :cond_1
    const-string v2, ":"

    add-int/lit8 v0, v0, 0x5

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 373
    if-gez v0, :cond_2

    move-object v0, v1

    goto :goto_0

    .line 374
    :cond_2
    const-string v2, "\""

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 375
    if-gez v0, :cond_3

    move-object v0, v1

    goto :goto_0

    .line 376
    :cond_3
    const-string v2, "\""

    add-int/lit8 v3, v0, 0x1

    invoke-virtual {p0, v2, v3}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 377
    if-gez v2, :cond_4

    move-object v0, v1

    goto :goto_0

    .line 378
    :cond_4
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    .line 382
    const-string v2, "?"

    invoke-virtual {v0, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_5

    const/4 v2, 0x0

    const-string v3, "?"

    invoke-virtual {v0, v3}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v0, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    .line 383
    :cond_5
    const-string v2, "/"

    invoke-virtual {v0, v2}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v2

    .line 384
    if-gez v2, :cond_6

    move-object v0, v1

    goto :goto_0

    .line 385
    :cond_6
    add-int/lit8 v2, v2, 0x1

    invoke-virtual {v0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v3

    .line 386
    const-string v0, "EpicDownloader"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Manifest filename: "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 389
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_7
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_8

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    .line 390
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->cloudDir:Ljava/lang/String;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, "/"

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->authParams:Ljava/lang/String;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 391
    const-string v5, "EpicDownloader"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Trying manifest: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 392
    const/4 v5, 0x0

    invoke-static {v2, v5}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v2

    .line 393
    if-eqz v2, :cond_7

    array-length v5, v2

    const/4 v6, 0x4

    if-le v5, v6, :cond_7

    .line 394
    const-string v3, "EpicDownloader"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Manifest OK from "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v4, " bytes="

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    array-length v4, v2

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-object v0, v2

    .line 395
    goto/16 :goto_0

    .line 398
    :catch_0
    move-exception v0

    .line 399
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "downloadManifest error: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_8
    move-object v0, v1

    .line 401
    goto/16 :goto_0
.end method

.method private static extractQueryParams(Ljava/lang/String;I)Ljava/lang/String;
    .locals 8

    .prologue
    const/4 v1, 0x0

    .line 309
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    add-int/lit16 v2, p1, 0x7d0

    invoke-static {v0, v2}, Ljava/lang/Math;->min(II)I

    move-result v0

    .line 310
    const-string v2, "\"queryParams\""

    invoke-virtual {p0, v2, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 311
    if-ltz v2, :cond_0

    if-le v2, v0, :cond_1

    :cond_0
    const-string v0, ""

    .line 352
    :goto_0
    return-object v0

    .line 312
    :cond_1
    const-string v0, "["

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 313
    if-gez v0, :cond_2

    const-string v0, ""

    goto :goto_0

    .line 314
    :cond_2
    const-string v2, "]"

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 315
    if-gez v2, :cond_3

    const-string v0, ""

    goto :goto_0

    .line 316
    :cond_3
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    .line 317
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, ""

    goto :goto_0

    .line 319
    :cond_4
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v0, "?"

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 320
    const/4 v2, 0x1

    move v0, v1

    .line 322
    :goto_1
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v5

    if-ge v0, v5, :cond_5

    .line 324
    const-string v5, "\"name\""

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 325
    if-gez v0, :cond_6

    .line 350
    :cond_5
    if-eqz v2, :cond_8

    const-string v0, ""

    goto :goto_0

    .line 326
    :cond_6
    const-string v5, ":"

    add-int/lit8 v0, v0, 0x6

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 327
    if-ltz v0, :cond_5

    .line 328
    const-string v5, "\""

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 329
    if-ltz v0, :cond_5

    .line 330
    const-string v5, "\""

    add-int/lit8 v6, v0, 0x1

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 331
    if-ltz v5, :cond_5

    .line 332
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {v3, v0, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    .line 335
    const-string v6, "\"value\""

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 336
    if-ltz v5, :cond_5

    .line 337
    const-string v6, ":"

    add-int/lit8 v5, v5, 0x7

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 338
    if-ltz v5, :cond_5

    .line 339
    const-string v6, "\""

    add-int/lit8 v5, v5, 0x1

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 340
    if-ltz v5, :cond_5

    .line 341
    const-string v6, "\""

    add-int/lit8 v7, v5, 0x1

    invoke-virtual {v3, v6, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v6

    .line 342
    if-ltz v6, :cond_5

    .line 343
    add-int/lit8 v5, v5, 0x1

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 345
    if-nez v2, :cond_7

    const-string v2, "&"

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 346
    :cond_7
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 348
    add-int/lit8 v0, v6, 0x1

    move v2, v1

    .line 349
    goto :goto_1

    .line 350
    :cond_8
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    goto/16 :goto_0

    .line 351
    :catch_0
    move-exception v0

    .line 352
    const-string v0, ""

    goto/16 :goto_0
.end method

.method public static install(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Landroid/content/Context;)Z
    .locals 14

    .prologue
    .line 117
    :try_start_0
    const-string v1, "install() entered"

    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 118
    const-string v1, "Parsing CDN URLs..."

    move-object/from16 v0, p3

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 121
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseCdnUrls(Ljava/lang/String;)Ljava/util/List;

    move-result-object v4

    .line 122
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "parseCdnUrls: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " CDNs"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 123
    invoke-interface {v4}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 124
    const-string v1, "ERROR: no CDN URLs in API response"

    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 125
    const-string v1, "EpicDownloader"

    const-string v2, "No CDN URLs in manifest API response"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 126
    const/4 v1, 0x0

    .line 231
    :goto_0
    return v1

    .line 128
    :cond_0
    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_1
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    .line 129
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "  CDN: "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v5, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    move-object/from16 v0, p4

    invoke-static {v0, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 130
    const-string v3, "EpicDownloader"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "  CDN: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-object v6, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "  auth: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-object v1, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->authParams:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, "(none)"

    :goto_2
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    .line 229
    :catch_0
    move-exception v1

    .line 230
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Install failed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 231
    const/4 v1, 0x0

    goto :goto_0

    .line 130
    :cond_1
    :try_start_1
    const-string v1, "YES"

    goto :goto_2

    .line 134
    :cond_2
    const-string v1, "Downloading manifest..."

    move-object/from16 v0, p3

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 135
    const-string v1, "downloadManifest starting..."

    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 136
    invoke-static {p0, p1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadManifest(Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)[B

    move-result-object v1

    .line 137
    if-nez v1, :cond_3

    .line 138
    const-string v1, "ERROR: manifest download failed (all CDNs returned null/empty)"

    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 139
    const-string v1, "EpicDownloader"

    const-string v2, "Failed to download manifest binary"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 140
    const/4 v1, 0x0

    goto/16 :goto_0

    .line 142
    :cond_3
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "manifest bytes: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    array-length v3, v1

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " first="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const/4 v3, 0x0

    aget-byte v3, v1, v3

    and-int/lit16 v3, v3, 0xff

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    move-object/from16 v0, p4

    invoke-static {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 143
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Manifest bytes: "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    array-length v5, v1

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 146
    const-string v2, "Parsing manifest..."

    move-object/from16 v0, p3

    invoke-static {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 147
    invoke-static {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    move-result-object v5

    .line 148
    if-nez v5, :cond_4

    .line 149
    const-string v1, "ERROR: manifest parse failed"

    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 150
    const-string v1, "EpicDownloader"

    const-string v2, "Failed to parse manifest"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 151
    const/4 v1, 0x0

    goto/16 :goto_0

    .line 153
    :cond_4
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "manifest parsed: chunkDir="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " chunks="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 154
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " files="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    .line 155
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 153
    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 156
    const-string v1, "EpicDownloader"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Manifest: chunkDir="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " chunks="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 157
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " files="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    .line 158
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 156
    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 161
    new-instance v6, Ljava/io/File;

    move-object/from16 v0, p2

    invoke-direct {v6, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 162
    invoke-virtual {v6}, Ljava/io/File;->mkdirs()Z

    .line 163
    new-instance v7, Ljava/io/File;

    const-string v1, ".chunks"

    invoke-direct {v7, v6, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 164
    invoke-virtual {v7}, Ljava/io/File;->mkdirs()Z

    .line 166
    iget-object v1, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v8

    .line 167
    const/4 v1, 0x0

    .line 168
    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v9

    move v3, v1

    :goto_3
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_9

    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    .line 169
    new-instance v10, Ljava/io/File;

    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v10, v7, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 170
    invoke-virtual {v10}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_6

    .line 171
    if-nez v3, :cond_5

    .line 173
    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    invoke-virtual {v1, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->getPath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    .line 174
    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v2, 0x0

    invoke-interface {v4, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    iget-object v2, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v12, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    const/4 v2, 0x0

    invoke-interface {v4, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    iget-object v2, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->cloudDir:Ljava/lang/String;

    invoke-virtual {v12, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 175
    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "first chunk: "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    invoke-virtual {v12, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v12, "/"

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    move-object/from16 v0, p4

    invoke-static {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 177
    :cond_5
    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    invoke-static {v1, v2, v4, v10}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadChunk(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;Ljava/lang/String;Ljava/util/List;Ljava/io/File;)Z

    move-result v2

    if-nez v2, :cond_6

    .line 178
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "ERROR: chunk download failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    move-object/from16 v0, p4

    invoke-static {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 179
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Failed to download chunk "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 180
    const/4 v1, 0x0

    goto/16 :goto_0

    .line 183
    :cond_6
    add-int/lit8 v1, v3, 0x1

    .line 184
    rem-int/lit16 v2, v1, 0x1f4

    if-eqz v2, :cond_7

    if-ne v1, v8, :cond_8

    .line 185
    :cond_7
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Downloading chunks ("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ")"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    move-object/from16 v0, p3

    invoke-static {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    :cond_8
    move v3, v1

    .line 187
    goto/16 :goto_3

    .line 190
    :cond_9
    const-string v1, "Assembling files..."

    move-object/from16 v0, p3

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 191
    iget-object v1, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v3

    .line 192
    const/4 v1, 0x0

    .line 193
    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    move v2, v1

    :goto_4
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_f

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    .line 195
    iget-object v5, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->filename:Ljava/lang/String;

    const-string v8, "\\"

    const-string v9, "/"

    invoke-virtual {v5, v8, v9}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v5

    .line 196
    new-instance v8, Ljava/io/File;

    invoke-direct {v8, v6, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 197
    invoke-virtual {v8}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v9

    .line 198
    if-eqz v9, :cond_a

    invoke-virtual {v9}, Ljava/io/File;->mkdirs()Z

    .line 200
    :cond_a
    new-instance v9, Ljava/io/FileOutputStream;

    invoke-direct {v9, v8}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 201
    new-instance v8, Ljava/io/BufferedOutputStream;

    const/high16 v10, 0x10000

    invoke-direct {v8, v9, v10}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;I)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 203
    :try_start_2
    iget-object v1, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->parts:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :goto_5
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_c

    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;

    .line 204
    new-instance v10, Ljava/io/File;

    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guidStr()Ljava/lang/String;

    move-result-object v11

    invoke-direct {v10, v7, v11}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 205
    invoke-virtual {v10}, Ljava/io/File;->exists()Z

    move-result v11

    if-nez v11, :cond_b

    .line 206
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 207
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Missing cached chunk "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guidStr()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " for file "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 208
    const/4 v1, 0x0

    .line 214
    :try_start_3
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    goto/16 :goto_0

    .line 210
    :cond_b
    :try_start_4
    invoke-static {v10}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFile(Ljava/io/File;)[B

    move-result-object v10

    .line 211
    iget v11, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    iget v1, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    invoke-virtual {v8, v10, v11, v1}, Ljava/io/BufferedOutputStream;->write([BII)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_5

    .line 214
    :catchall_0
    move-exception v1

    :try_start_5
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 215
    throw v1

    .line 214
    :cond_c
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 217
    add-int/lit8 v1, v2, 0x1

    .line 218
    rem-int/lit16 v2, v1, 0xc8

    if-eqz v2, :cond_d

    if-ne v1, v3, :cond_e

    .line 219
    :cond_d
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Assembling files ("

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, "/"

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, ")"

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    move-object/from16 v0, p3

    invoke-static {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    :cond_e
    move v2, v1

    .line 221
    goto/16 :goto_4

    .line 224
    :cond_f
    invoke-static {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->deleteDir(Ljava/io/File;)V

    .line 226
    const-string v1, "EpicDownloader"

    const-string v2, "Install complete!"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_0

    .line 227
    const/4 v1, 0x1

    goto/16 :goto_0
.end method

.method public static parseCdnUrls(Ljava/lang/String;)Ljava/util/List;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List",
            "<",
            "Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;",
            ">;"
        }
    .end annotation

    .prologue
    .line 243
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 245
    :try_start_0
    const-string v1, "\"manifests\""

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    .line 246
    if-gez v1, :cond_1

    .line 299
    :cond_0
    :goto_0
    return-object v0

    .line 247
    :cond_1
    const-string v2, "["

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 248
    if-ltz v1, :cond_0

    .line 252
    add-int/lit8 v1, v1, 0x1

    .line 258
    :goto_1
    const-string v2, "\"uri\""

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v3

    .line 259
    if-ltz v3, :cond_0

    .line 262
    const-string v1, ":"

    add-int/lit8 v2, v3, 0x5

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 263
    if-ltz v1, :cond_0

    .line 264
    const-string v2, "\""

    add-int/lit8 v1, v1, 0x1

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 265
    if-ltz v1, :cond_0

    .line 266
    const-string v2, "\""

    add-int/lit8 v4, v1, 0x1

    invoke-virtual {p0, v2, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 267
    if-ltz v2, :cond_0

    .line 268
    add-int/lit8 v1, v1, 0x1

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 269
    add-int/lit8 v2, v2, 0x1

    .line 272
    const-string v4, "/Builds"

    invoke-virtual {v1, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    .line 273
    if-gez v4, :cond_2

    move v1, v2

    goto :goto_1

    .line 275
    :cond_2
    const/4 v5, 0x0

    invoke-virtual {v1, v5, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 276
    const-string v6, "http"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_3

    move v1, v2

    goto :goto_1

    .line 279
    :cond_3
    const-string v6, "cloudflare.epicgamescdn.com"

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-eqz v6, :cond_4

    move v1, v2

    goto :goto_1

    .line 282
    :cond_4
    invoke-virtual {v1, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    .line 284
    const-string v4, "?"

    invoke-virtual {v1, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    .line 285
    if-ltz v4, :cond_5

    const/4 v6, 0x0

    invoke-virtual {v1, v6, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 286
    :cond_5
    const-string v4, "/"

    invoke-virtual {v1, v4}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v4

    .line 287
    if-gez v4, :cond_6

    move v1, v2

    goto :goto_1

    .line 288
    :cond_6
    const/4 v6, 0x0

    invoke-virtual {v1, v6, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 292
    invoke-static {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->extractQueryParams(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v3

    .line 294
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    invoke-direct {v4, v5, v1, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move v1, v2

    .line 295
    goto :goto_1

    .line 296
    :catch_0
    move-exception v1

    .line 297
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "parseCdnUrls error: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0
.end method

.method private static parseJsonManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;
    .locals 18

    .prologue
    .line 657
    :try_start_0
    new-instance v2, Ljava/lang/String;

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    move-object/from16 v0, p0

    invoke-direct {v2, v0, v3}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    .line 658
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    .line 662
    :try_start_1
    const-string v2, "ManifestFileVersion"

    const-string v4, "0"

    invoke-virtual {v3, v2, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    move-result v2

    .line 665
    :goto_0
    const/16 v4, 0xf

    if-lt v2, v4, :cond_0

    :try_start_2
    const-string v2, "ChunksV4"

    move-object v4, v2

    .line 670
    :goto_1
    const-string v2, "ChunkHashList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    .line 671
    const-string v2, "DataGroupList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v6

    .line 672
    const-string v2, "ChunkFilesizeList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v7

    .line 674
    if-nez v5, :cond_3

    .line 675
    const-string v2, "EpicDownloader"

    const-string v3, "JSON manifest: no ChunkHashList"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 676
    const/4 v2, 0x0

    .line 760
    :goto_2
    return-object v2

    .line 663
    :catch_0
    move-exception v2

    const/4 v2, 0x0

    goto :goto_0

    .line 666
    :cond_0
    const/4 v4, 0x6

    if-lt v2, v4, :cond_1

    const-string v2, "ChunksV3"

    move-object v4, v2

    goto :goto_1

    .line 667
    :cond_1
    const/4 v4, 0x3

    if-lt v2, v4, :cond_2

    const-string v2, "ChunksV2"

    move-object v4, v2

    goto :goto_1

    .line 668
    :cond_2
    const-string v2, "ChunksV4"

    move-object v4, v2

    goto :goto_1

    .line 680
    :cond_3
    new-instance v8, Ljava/util/LinkedHashMap;

    invoke-direct {v8}, Ljava/util/LinkedHashMap;-><init>()V

    .line 681
    invoke-virtual {v5}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v9

    .line 682
    :cond_4
    :goto_3
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_8

    .line 683
    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 684
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v10

    const/16 v11, 0x20

    if-lt v10, v11, :cond_4

    .line 685
    invoke-virtual {v5, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 687
    new-instance v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-direct {v11}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;-><init>()V

    .line 688
    iget-object v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/16 v15, 0x8

    invoke-virtual {v2, v14, v15}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v14

    const/16 v15, 0x10

    invoke-static {v14, v15}, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J

    move-result-wide v14

    long-to-int v14, v14

    aput v14, v12, v13

    .line 689
    iget-object v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v13, 0x1

    const/16 v14, 0x8

    const/16 v15, 0x10

    invoke-virtual {v2, v14, v15}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v14

    const/16 v15, 0x10

    invoke-static {v14, v15}, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J

    move-result-wide v14

    long-to-int v14, v14

    aput v14, v12, v13

    .line 690
    iget-object v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v13, 0x2

    const/16 v14, 0x10

    const/16 v15, 0x18

    invoke-virtual {v2, v14, v15}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v14

    const/16 v15, 0x10

    invoke-static {v14, v15}, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J

    move-result-wide v14

    long-to-int v14, v14

    aput v14, v12, v13

    .line 691
    iget-object v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v13, 0x3

    const/16 v14, 0x18

    const/16 v15, 0x20

    invoke-virtual {v2, v14, v15}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v14

    const/16 v15, 0x10

    invoke-static {v14, v15}, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J

    move-result-wide v14

    long-to-int v14, v14

    aput v14, v12, v13

    .line 694
    if-eqz v10, :cond_5

    invoke-virtual {v10}, Ljava/lang/String;->length()I
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    move-result v12

    const/16 v13, 0x10

    if-lt v12, v13, :cond_5

    .line 696
    const/4 v12, 0x0

    const/16 v13, 0x10

    :try_start_3
    invoke-virtual {v10, v12, v13}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v10

    const/16 v12, 0x10

    invoke-static {v10, v12}, Ljava/lang/Long;->parseUnsignedLong(Ljava/lang/String;I)J

    move-result-wide v12

    iput-wide v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->hash:J
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_2

    .line 700
    :cond_5
    :goto_4
    if-eqz v6, :cond_6

    .line 701
    :try_start_4
    const-string v10, "0"

    invoke-virtual {v6, v2, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    invoke-static {v10}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v10

    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->groupNum:I
    :try_end_4
    .catch Ljava/lang/NumberFormatException; {:try_start_4 .. :try_end_4} :catch_3
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_1

    .line 704
    :cond_6
    :goto_5
    if-eqz v7, :cond_7

    .line 705
    :try_start_5
    const-string v10, "0"

    invoke-virtual {v7, v2, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    invoke-static {v10}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v12

    iput-wide v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->fileSize:J
    :try_end_5
    .catch Ljava/lang/NumberFormatException; {:try_start_5 .. :try_end_5} :catch_4
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_1

    .line 709
    :cond_7
    :goto_6
    const/4 v10, 0x0

    :try_start_6
    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->windowSize:I

    .line 711
    invoke-interface {v8, v2, v11}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_1

    goto/16 :goto_3

    .line 758
    :catch_1
    move-exception v2

    .line 759
    const-string v3, "EpicDownloader"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "parseJsonManifest error: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v2}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 760
    const/4 v2, 0x0

    goto/16 :goto_2

    .line 697
    :catch_2
    move-exception v10

    const-wide/16 v12, 0x0

    :try_start_7
    iput-wide v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->hash:J

    goto :goto_4

    .line 702
    :catch_3
    move-exception v10

    const/4 v10, 0x0

    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->groupNum:I

    goto :goto_5

    .line 706
    :catch_4
    move-exception v10

    const-wide/16 v12, 0x0

    iput-wide v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->fileSize:J

    goto :goto_6

    .line 715
    :cond_8
    const-string v2, "FileManifestList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v5

    .line 716
    if-nez v5, :cond_9

    .line 717
    const-string v2, "EpicDownloader"

    const-string v3, "JSON manifest: no FileManifestList"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 718
    const/4 v2, 0x0

    goto/16 :goto_2

    .line 721
    :cond_9
    new-instance v6, Ljava/util/ArrayList;

    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v2

    invoke-direct {v6, v2}, Ljava/util/ArrayList;-><init>(I)V

    .line 722
    const/4 v2, 0x0

    move v3, v2

    :goto_7
    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v3, v2, :cond_c

    .line 723
    invoke-virtual {v5, v3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    .line 724
    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    invoke-direct {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;-><init>()V

    .line 725
    const-string v9, "Filename"

    const-string v10, ""

    invoke-virtual {v2, v9, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    iput-object v9, v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->filename:Ljava/lang/String;

    .line 727
    const-string v9, "FileChunkParts"

    invoke-virtual {v2, v9}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v9

    .line 728
    if-eqz v9, :cond_b

    .line 729
    const/4 v2, 0x0

    :goto_8
    invoke-virtual {v9}, Lorg/json/JSONArray;->length()I

    move-result v10

    if-ge v2, v10, :cond_b

    .line 730
    invoke-virtual {v9, v2}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v10

    .line 731
    new-instance v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;

    invoke-direct {v11}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;-><init>()V

    .line 732
    const-string v12, "Guid"

    const-string v13, ""

    invoke-virtual {v10, v12, v13}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    .line 733
    invoke-virtual {v12}, Ljava/lang/String;->length()I

    move-result v13

    const/16 v14, 0x20

    if-lt v13, v14, :cond_a

    .line 734
    iget-object v13, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v14, 0x0

    const/4 v15, 0x0

    const/16 v16, 0x8

    move/from16 v0, v16

    invoke-virtual {v12, v15, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v15

    const/16 v16, 0x10

    invoke-static/range {v15 .. v16}, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J

    move-result-wide v16

    move-wide/from16 v0, v16

    long-to-int v15, v0

    aput v15, v13, v14

    .line 735
    iget-object v13, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v14, 0x1

    const/16 v15, 0x8

    const/16 v16, 0x10

    move/from16 v0, v16

    invoke-virtual {v12, v15, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v15

    const/16 v16, 0x10

    invoke-static/range {v15 .. v16}, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J

    move-result-wide v16

    move-wide/from16 v0, v16

    long-to-int v15, v0

    aput v15, v13, v14

    .line 736
    iget-object v13, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v14, 0x2

    const/16 v15, 0x10

    const/16 v16, 0x18

    move/from16 v0, v16

    invoke-virtual {v12, v15, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v15

    const/16 v16, 0x10

    invoke-static/range {v15 .. v16}, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J

    move-result-wide v16

    move-wide/from16 v0, v16

    long-to-int v15, v0

    aput v15, v13, v14

    .line 737
    iget-object v13, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v14, 0x3

    const/16 v15, 0x18

    const/16 v16, 0x20

    move/from16 v0, v16

    invoke-virtual {v12, v15, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v12

    const/16 v15, 0x10

    invoke-static {v12, v15}, Ljava/lang/Long;->parseLong(Ljava/lang/String;I)J

    move-result-wide v16

    move-wide/from16 v0, v16

    long-to-int v12, v0

    aput v12, v13, v14
    :try_end_7
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_1

    .line 739
    :cond_a
    :try_start_8
    const-string v12, "Offset"

    const-string v13, "0"

    invoke-virtual {v10, v12, v13}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    invoke-static {v12}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v12

    iput v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I
    :try_end_8
    .catch Ljava/lang/NumberFormatException; {:try_start_8 .. :try_end_8} :catch_5
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_8} :catch_1

    .line 741
    :goto_9
    :try_start_9
    const-string v12, "Size"

    const-string v13, "0"

    invoke-virtual {v10, v12, v13}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    invoke-static {v10}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v10

    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I
    :try_end_9
    .catch Ljava/lang/NumberFormatException; {:try_start_9 .. :try_end_9} :catch_6
    .catch Ljava/lang/Exception; {:try_start_9 .. :try_end_9} :catch_1

    .line 743
    :goto_a
    :try_start_a
    iget-object v10, v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->parts:Ljava/util/List;

    invoke-interface {v10, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 729
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_8

    .line 740
    :catch_5
    move-exception v12

    const/4 v12, 0x0

    iput v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    goto :goto_9

    .line 742
    :catch_6
    move-exception v10

    const/4 v10, 0x0

    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    goto :goto_a

    .line 746
    :cond_b
    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 722
    add-int/lit8 v2, v3, 0x1

    move v3, v2

    goto/16 :goto_7

    .line 749
    :cond_c
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    invoke-direct {v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;-><init>()V

    .line 750
    iput-object v4, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    .line 751
    new-instance v3, Ljava/util/ArrayList;

    invoke-interface {v8}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v5

    invoke-direct {v3, v5}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    iput-object v3, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 752
    iput-object v6, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    .line 753
    const-string v3, "EpicDownloader"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "JSON manifest: chunkDir="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " chunks="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 754
    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " files="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 755
    invoke-interface {v6}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 753
    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_a
    .catch Ljava/lang/Exception; {:try_start_a .. :try_end_a} :catch_1

    goto/16 :goto_2
.end method

.method public static parseManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;
    .locals 17

    .prologue
    .line 413
    :try_start_0
    invoke-static/range {p0 .. p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 416
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 417
    const v2, 0x44bec00c

    if-eq v0, v2, :cond_0

    .line 419
    const-string v0, "EpicDownloader"

    const-string v1, "Non-binary manifest, trying JSON parser"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 420
    invoke-static/range {p0 .. p0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseJsonManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    move-result-object v0

    .line 548
    :goto_0
    return-object v0

    .line 422
    :cond_0
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v3

    .line 423
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v4

    .line 424
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    .line 425
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    add-int/lit8 v0, v0, 0x14

    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 426
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B

    move-result v0

    and-int/lit16 v5, v0, 0xff

    .line 427
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 431
    const/16 v2, 0xf

    if-lt v0, v2, :cond_1

    const-string v0, "ChunksV4"

    move-object v2, v0

    .line 437
    :goto_1
    invoke-virtual {v1, v3}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 438
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    new-array v0, v0, [B

    .line 439
    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 442
    and-int/lit8 v1, v5, 0x1

    if-eqz v1, :cond_4

    .line 443
    new-instance v1, Ljava/util/zip/Inflater;

    invoke-direct {v1}, Ljava/util/zip/Inflater;-><init>()V

    .line 444
    invoke-virtual {v1, v0}, Ljava/util/zip/Inflater;->setInput([B)V

    .line 445
    new-array v0, v4, [B

    .line 446
    invoke-virtual {v1, v0}, Ljava/util/zip/Inflater;->inflate([B)I

    move-result v3

    .line 447
    invoke-virtual {v1}, Ljava/util/zip/Inflater;->end()V

    .line 448
    if-eq v3, v4, :cond_4

    .line 449
    const-string v0, "EpicDownloader"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Decomp size mismatch: expected "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " got "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 450
    const/4 v0, 0x0

    goto :goto_0

    .line 432
    :cond_1
    const/4 v2, 0x6

    if-lt v0, v2, :cond_2

    const-string v0, "ChunksV3"

    move-object v2, v0

    goto :goto_1

    .line 433
    :cond_2
    const/4 v2, 0x3

    if-lt v0, v2, :cond_3

    const-string v0, "ChunksV2"

    move-object v2, v0

    goto :goto_1

    .line 434
    :cond_3
    const-string v0, "Chunks"

    move-object v2, v0

    goto :goto_1

    .line 455
    :cond_4
    invoke-static {v0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v3

    .line 458
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 459
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v1

    add-int/lit8 v1, v1, -0x4

    add-int/2addr v0, v1

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 462
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v1

    .line 463
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v4

    .line 464
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->get()B

    .line 465
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v5

    .line 467
    new-instance v6, Ljava/util/ArrayList;

    invoke-direct {v6, v5}, Ljava/util/ArrayList;-><init>(I)V

    .line 468
    const/4 v0, 0x0

    :goto_2
    if-ge v0, v5, :cond_5

    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-direct {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;-><init>()V

    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 471
    :cond_5
    invoke-interface {v6}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v7

    :goto_3
    invoke-interface {v7}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_6

    invoke-interface {v7}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    .line 472
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x0

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 473
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x1

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 474
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x2

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 475
    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v8, 0x3

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v9

    aput v9, v0, v8
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_3

    .line 546
    :catch_0
    move-exception v0

    .line 547
    const-string v1, "EpicDownloader"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "parseManifest error: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 548
    const/4 v0, 0x0

    goto/16 :goto_0

    .line 477
    :cond_6
    :try_start_1
    invoke-interface {v6}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v7

    :goto_4
    invoke-interface {v7}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_7

    invoke-interface {v7}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getLong()J

    move-result-wide v8

    iput-wide v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->hash:J

    goto :goto_4

    .line 479
    :cond_7
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    mul-int/lit8 v7, v5, 0x14

    add-int/2addr v0, v7

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 480
    invoke-interface {v6}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v7

    :goto_5
    invoke-interface {v7}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_8

    invoke-interface {v7}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->get()B

    move-result v8

    and-int/lit16 v8, v8, 0xff

    iput v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->groupNum:I

    goto :goto_5

    .line 481
    :cond_8
    invoke-interface {v6}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v7

    :goto_6
    invoke-interface {v7}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_9

    invoke-interface {v7}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v8

    iput v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->windowSize:I

    goto :goto_6

    .line 482
    :cond_9
    invoke-interface {v6}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v7

    :goto_7
    invoke-interface {v7}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_a

    invoke-interface {v7}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getLong()J

    move-result-wide v8

    iput-wide v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->fileSize:J

    goto :goto_7

    .line 485
    :cond_a
    add-int v0, v1, v4

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 488
    new-instance v1, Ljava/util/LinkedHashMap;

    mul-int/lit8 v0, v5, 0x2

    invoke-direct {v1, v0}, Ljava/util/LinkedHashMap;-><init>(I)V

    .line 489
    invoke-interface {v6}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_8
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_b

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v7

    invoke-interface {v1, v7, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_8

    .line 492
    :cond_b
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    .line 493
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v7

    .line 494
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->get()B

    .line 495
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v8

    .line 497
    new-instance v9, Ljava/util/ArrayList;

    invoke-direct {v9, v8}, Ljava/util/ArrayList;-><init>(I)V

    .line 498
    const/4 v0, 0x0

    :goto_9
    if-ge v0, v8, :cond_c

    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    invoke-direct {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;-><init>()V

    invoke-interface {v9, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_9

    .line 501
    :cond_c
    invoke-interface {v9}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_a
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_d

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;

    move-result-object v10

    iput-object v10, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->filename:Ljava/lang/String;

    goto :goto_a

    .line 503
    :cond_d
    const/4 v0, 0x0

    :goto_b
    if-ge v0, v8, :cond_e

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;

    add-int/lit8 v0, v0, 0x1

    goto :goto_b

    .line 505
    :cond_e
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    mul-int/lit8 v1, v8, 0x14

    add-int/2addr v0, v1

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 507
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    add-int/2addr v0, v8

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 509
    const/4 v0, 0x0

    move v1, v0

    :goto_c
    if-ge v1, v8, :cond_10

    .line 510
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    .line 511
    const/4 v0, 0x0

    :goto_d
    if-ge v0, v10, :cond_f

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;

    add-int/lit8 v0, v0, 0x1

    goto :goto_d

    .line 509
    :cond_f
    add-int/lit8 v0, v1, 0x1

    move v1, v0

    goto :goto_c

    .line 514
    :cond_10
    invoke-interface {v9}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v8

    :cond_11
    invoke-interface {v8}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_12

    invoke-interface {v8}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    .line 515
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    .line 516
    const/4 v1, 0x0

    :goto_e
    if-ge v1, v10, :cond_11

    .line 517
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v11

    .line 518
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v12

    .line 519
    new-instance v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;

    invoke-direct {v13}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;-><init>()V

    .line 520
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x0

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 521
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x1

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 522
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x2

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 523
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x3

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 524
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v14

    iput v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    .line 525
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v14

    iput v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    .line 526
    iget-object v14, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->parts:Ljava/util/List;

    invoke-interface {v14, v13}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 528
    add-int/2addr v11, v12

    invoke-virtual {v3, v11}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 516
    add-int/lit8 v1, v1, 0x1

    goto :goto_e

    .line 533
    :cond_12
    add-int v0, v4, v7

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 536
    new-instance v1, Ljava/util/LinkedHashMap;

    mul-int/lit8 v0, v5, 0x2

    invoke-direct {v1, v0}, Ljava/util/LinkedHashMap;-><init>(I)V

    .line 537
    invoke-interface {v6}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_f
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_13

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v4, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_f

    .line 538
    :cond_13
    new-instance v3, Ljava/util/ArrayList;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-direct {v3, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 540
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    invoke-direct {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;-><init>()V

    .line 541
    iput-object v2, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    .line 542
    iput-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 543
    iput-object v9, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0
.end method

.method private static progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V
    .locals 1

    .prologue
    .line 865
    if-eqz p0, :cond_0

    invoke-interface {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;->onProgress(Ljava/lang/String;)V

    .line 866
    :cond_0
    const-string v0, "EpicDownloader"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 867
    return-void
.end method

.method public static readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;
    .locals 3

    .prologue
    .line 807
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 808
    if-nez v0, :cond_0

    const-string v0, ""

    .line 819
    :goto_0
    return-object v0

    .line 809
    :cond_0
    if-gez v0, :cond_1

    .line 810
    neg-int v0, v0

    add-int/lit8 v0, v0, -0x1

    .line 811
    mul-int/lit8 v0, v0, 0x2

    new-array v1, v0, [B

    .line 812
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 813
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getShort()S

    .line 814
    new-instance v0, Ljava/lang/String;

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_16LE:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    goto :goto_0

    .line 816
    :cond_1
    add-int/lit8 v0, v0, -0x1

    new-array v1, v0, [B

    .line 817
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 818
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B

    .line 819
    new-instance v0, Ljava/lang/String;

    sget-object v2, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    goto :goto_0
.end method

.method public static readFile(Ljava/io/File;)[B
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    .line 826
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 827
    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v2

    long-to-int v0, v2

    new-array v2, v0, [B

    .line 828
    const/4 v0, 0x0

    .line 829
    :goto_0
    array-length v3, v2

    if-ge v0, v3, :cond_0

    .line 830
    array-length v3, v2

    sub-int/2addr v3, v0

    invoke-virtual {v1, v2, v0, v3}, Ljava/io/FileInputStream;->read([BII)I

    move-result v3

    .line 831
    if-gez v3, :cond_1

    .line 834
    :cond_0
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V

    .line 835
    return-object v2

    .line 832
    :cond_1
    add-int/2addr v0, v3

    .line 833
    goto :goto_0
.end method
