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
    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static decompressChunk([BI)[B
    .locals 6

    .prologue
    const/4 v0, 0x0

    .line 578
    :try_start_0
    invoke-static {p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v1

    sget-object v2, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 579
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    .line 580
    const v3, -0x4e01c55e

    if-eq v2, v3, :cond_0

    .line 581
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

    .line 620
    :goto_0
    return-object v0

    .line 584
    :cond_0
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    .line 585
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    .line 586
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v3

    .line 587
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    add-int/lit8 v4, v4, 0x10

    invoke-virtual {v1, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 588
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    add-int/lit8 v4, v4, 0x8

    invoke-virtual {v1, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 589
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B

    move-result v1

    and-int/lit16 v4, v1, 0xff

    .line 592
    if-ltz v2, :cond_1

    array-length v1, p0

    if-lt v2, v1, :cond_2

    .line 593
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

    .line 618
    :catch_0
    move-exception v1

    .line 619
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

    .line 596
    :cond_2
    :try_start_1
    new-array v1, v3, [B

    .line 597
    const/4 v5, 0x0

    invoke-static {p0, v2, v1, v5, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 599
    and-int/lit8 v2, v4, 0x1

    if-eqz v2, :cond_6

    .line 601
    new-instance v2, Ljava/util/zip/Inflater;

    invoke-direct {v2}, Ljava/util/zip/Inflater;-><init>()V

    .line 602
    invoke-virtual {v2, v1}, Ljava/util/zip/Inflater;->setInput([B)V

    .line 603
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    .line 604
    if-lez p1, :cond_3

    :goto_1
    invoke-direct {v1, p1}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 605
    const/high16 v3, 0x10000

    new-array v3, v3, [B

    .line 607
    :goto_2
    invoke-virtual {v2, v3}, Ljava/util/zip/Inflater;->inflate([B)I

    move-result v4

    if-lez v4, :cond_4

    const/4 v5, 0x0

    invoke-virtual {v1, v3, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_2

    .line 604
    :cond_3
    const/high16 p1, 0x100000

    goto :goto_1

    .line 608
    :cond_4
    invoke-virtual {v2}, Ljava/util/zip/Inflater;->end()V

    .line 609
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1

    .line 610
    array-length v2, v1

    if-nez v2, :cond_5

    .line 611
    const-string v1, "EpicDownloader"

    const-string v2, "Chunk inflate produced 0 bytes"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0

    :cond_5
    move-object v0, v1

    .line 614
    goto/16 :goto_0

    :cond_6
    move-object v0, v1

    .line 617
    goto/16 :goto_0
.end method

.method public static deleteDir(Ljava/io/File;)V
    .locals 5

    .prologue
    .line 815
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_0

    .line 824
    :goto_0
    return-void

    .line 816
    :cond_0
    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v1

    .line 817
    if-eqz v1, :cond_2

    .line 818
    array-length v2, v1

    const/4 v0, 0x0

    :goto_1
    if-ge v0, v2, :cond_2

    aget-object v3, v1, v0

    .line 819
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->deleteDir(Ljava/io/File;)V

    .line 818
    :goto_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 820
    :cond_1
    invoke-virtual {v3}, Ljava/io/File;->delete()Z

    goto :goto_2

    .line 823
    :cond_2
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    goto :goto_0
.end method

.method public static downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B
    .locals 7

    .prologue
    const/4 v1, 0x0

    .line 744
    .line 746
    :try_start_0
    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 747
    const/16 v2, 0x7530

    :try_start_1
    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 748
    const v2, 0xea60

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 749
    const-string v2, "GET"

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    .line 750
    const-string v2, "User-Agent"

    const-string v3, "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"

    invoke-virtual {v0, v2, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 751
    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_0

    .line 752
    const-string v2, "Authorization"

    invoke-virtual {v0, v2, p1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 754
    :cond_0
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v2

    .line 755
    const/16 v3, 0xc8

    if-eq v2, v3, :cond_2

    .line 756
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

    .line 770
    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_1
    move-object v0, v1

    .line 768
    :goto_0
    return-object v0

    .line 759
    :cond_2
    :try_start_2
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    .line 760
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v3}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 761
    const/16 v4, 0x2000

    new-array v4, v4, [B

    .line 763
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

    .line 766
    :catch_0
    move-exception v2

    move-object v3, v0

    .line 767
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

    .line 770
    if-eqz v3, :cond_3

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_3
    move-object v0, v1

    .line 768
    goto :goto_0

    .line 764
    :cond_4
    :try_start_4
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    .line 765
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    move-result-object v1

    .line 770
    if-eqz v0, :cond_5

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_5
    move-object v0, v1

    .line 765
    goto :goto_0

    .line 770
    :catchall_0
    move-exception v0

    move-object v2, v0

    move-object v3, v1

    :goto_3
    if-eqz v3, :cond_6

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 771
    :cond_6
    throw v2

    .line 770
    :catchall_1
    move-exception v1

    move-object v2, v1

    move-object v3, v0

    goto :goto_3

    :catchall_2
    move-exception v0

    move-object v2, v0

    goto :goto_3

    .line 766
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
    .line 541
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->getPath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 543
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

    .line 547
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

    .line 549
    const/4 v4, 0x0

    :try_start_0
    invoke-static {v1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v1

    .line 550
    if-eqz v1, :cond_0

    .line 552
    iget v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->windowSize:I

    invoke-static {v1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->decompressChunk([BI)[B

    move-result-object v1

    .line 553
    if-nez v1, :cond_1

    .line 554
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

    .line 562
    :catch_0
    move-exception v1

    .line 563
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

    .line 558
    :cond_1
    :try_start_1
    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, p3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 559
    :try_start_2
    invoke-virtual {v4, v1}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    .line 560
    const/4 v0, 0x1

    .line 567
    :goto_1
    return v0

    .line 559
    :catchall_0
    move-exception v1

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    throw v1
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    .line 566
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

    .line 567
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
    const/4 v7, 0x4

    const/4 v1, 0x0

    .line 347
    :try_start_0
    const-string v0, "\"manifests\""

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    .line 348
    if-gez v0, :cond_1

    move-object v0, v1

    .line 377
    :cond_0
    :goto_0
    return-object v0

    .line 349
    :cond_1
    const-string v2, "\"uri\""

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 350
    if-gez v0, :cond_2

    move-object v0, v1

    goto :goto_0

    .line 351
    :cond_2
    const-string v2, ":"

    add-int/lit8 v0, v0, 0x5

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 352
    if-gez v0, :cond_3

    move-object v0, v1

    goto :goto_0

    .line 353
    :cond_3
    const-string v2, "\""

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 354
    if-gez v0, :cond_4

    move-object v0, v1

    goto :goto_0

    .line 355
    :cond_4
    const-string v2, "\""

    add-int/lit8 v3, v0, 0x1

    invoke-virtual {p0, v2, v3}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 356
    if-gez v2, :cond_5

    move-object v0, v1

    goto :goto_0

    .line 357
    :cond_5
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    .line 359
    const-string v0, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Manifest URI: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 360
    invoke-static {v2, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v0

    .line 361
    if-eqz v0, :cond_6

    array-length v3, v0

    if-gt v3, v7, :cond_0

    .line 364
    :cond_6
    const-string v0, "/Builds"

    invoke-virtual {v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    .line 365
    if-gez v0, :cond_7

    move-object v0, v1

    goto :goto_0

    .line 366
    :cond_7
    invoke-virtual {v2, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    .line 368
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_8
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_9

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    .line 369
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 370
    const-string v4, "EpicDownloader"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Manifest fallback: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 371
    invoke-static {v0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v0

    .line 372
    if-eqz v0, :cond_8

    array-length v4, v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-le v4, v7, :cond_8

    goto/16 :goto_0

    .line 374
    :catch_0
    move-exception v0

    .line 375
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

    :cond_9
    move-object v0, v1

    .line 377
    goto/16 :goto_0
.end method

.method private static extractQueryParams(Ljava/lang/String;I)Ljava/lang/String;
    .locals 8

    .prologue
    const/4 v1, 0x0

    .line 291
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    add-int/lit16 v2, p1, 0x7d0

    invoke-static {v0, v2}, Ljava/lang/Math;->min(II)I

    move-result v0

    .line 292
    const-string v2, "\"queryParams\""

    invoke-virtual {p0, v2, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 293
    if-ltz v2, :cond_0

    if-le v2, v0, :cond_1

    :cond_0
    const-string v0, ""

    .line 334
    :goto_0
    return-object v0

    .line 294
    :cond_1
    const-string v0, "["

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 295
    if-gez v0, :cond_2

    const-string v0, ""

    goto :goto_0

    .line 296
    :cond_2
    const-string v2, "]"

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 297
    if-gez v2, :cond_3

    const-string v0, ""

    goto :goto_0

    .line 298
    :cond_3
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    .line 299
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, ""

    goto :goto_0

    .line 301
    :cond_4
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v0, "?"

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 302
    const/4 v2, 0x1

    move v0, v1

    .line 304
    :goto_1
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v5

    if-ge v0, v5, :cond_5

    .line 306
    const-string v5, "\"name\""

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 307
    if-gez v0, :cond_6

    .line 332
    :cond_5
    if-eqz v2, :cond_8

    const-string v0, ""

    goto :goto_0

    .line 308
    :cond_6
    const-string v5, ":"

    add-int/lit8 v0, v0, 0x6

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 309
    if-ltz v0, :cond_5

    .line 310
    const-string v5, "\""

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 311
    if-ltz v0, :cond_5

    .line 312
    const-string v5, "\""

    add-int/lit8 v6, v0, 0x1

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 313
    if-ltz v5, :cond_5

    .line 314
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {v3, v0, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    .line 317
    const-string v6, "\"value\""

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 318
    if-ltz v5, :cond_5

    .line 319
    const-string v6, ":"

    add-int/lit8 v5, v5, 0x7

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 320
    if-ltz v5, :cond_5

    .line 321
    const-string v6, "\""

    add-int/lit8 v5, v5, 0x1

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 322
    if-ltz v5, :cond_5

    .line 323
    const-string v6, "\""

    add-int/lit8 v7, v5, 0x1

    invoke-virtual {v3, v6, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v6

    .line 324
    if-ltz v6, :cond_5

    .line 325
    add-int/lit8 v5, v5, 0x1

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 327
    if-nez v2, :cond_7

    const-string v2, "&"

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 328
    :cond_7
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 330
    add-int/lit8 v0, v6, 0x1

    move v2, v1

    .line 331
    goto :goto_1

    .line 332
    :cond_8
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    goto/16 :goto_0

    .line 333
    :catch_0
    move-exception v0

    .line 334
    const-string v0, ""

    goto/16 :goto_0
.end method

.method public static install(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;)Z
    .locals 12

    .prologue
    const/4 v1, 0x0

    .line 113
    :try_start_0
    const-string v0, "Parsing CDN URLs..."

    invoke-static {p3, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 118
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseCdnUrls(Ljava/lang/String;)Ljava/util/List;

    move-result-object v3

    .line 119
    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 120
    const-string v0, "EpicDownloader"

    const-string v2, "No CDN URLs in manifest API response"

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v0, v1

    .line 213
    :goto_0
    return v0

    .line 123
    :cond_0
    const-string v0, "EpicDownloader"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "CDN URLs found: "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 124
    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_1
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    .line 125
    const-string v4, "EpicDownloader"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "  CDN: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-object v6, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "  auth: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->authParams:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "(none)"

    :goto_2
    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v4, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    .line 211
    :catch_0
    move-exception v0

    .line 212
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Install failed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    move v0, v1

    .line 213
    goto :goto_0

    .line 125
    :cond_1
    :try_start_1
    const-string v0, "YES"

    goto :goto_2

    .line 129
    :cond_2
    const-string v0, "Downloading manifest..."

    invoke-static {p3, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 130
    invoke-static {p0, p1, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadManifest(Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)[B

    move-result-object v0

    .line 131
    if-nez v0, :cond_3

    .line 132
    const-string v0, "EpicDownloader"

    const-string v2, "Failed to download manifest binary"

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v0, v1

    .line 133
    goto/16 :goto_0

    .line 135
    :cond_3
    const-string v2, "EpicDownloader"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Manifest bytes: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    array-length v5, v0

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v2, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 138
    const-string v2, "Parsing manifest..."

    invoke-static {p3, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 139
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    move-result-object v4

    .line 140
    if-nez v4, :cond_4

    .line 141
    const-string v0, "EpicDownloader"

    const-string v2, "Failed to parse manifest"

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v0, v1

    .line 142
    goto/16 :goto_0

    .line 144
    :cond_4
    const-string v0, "EpicDownloader"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Manifest: chunkDir="

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v5, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, " chunks="

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v5, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 145
    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, " files="

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v5, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    .line 146
    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 144
    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 150
    new-instance v5, Ljava/io/File;

    invoke-direct {v5, p2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 151
    invoke-virtual {v5}, Ljava/io/File;->mkdirs()Z

    .line 152
    new-instance v6, Ljava/io/File;

    const-string v0, ".chunks"

    invoke-direct {v6, v5, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 153
    invoke-virtual {v6}, Ljava/io/File;->mkdirs()Z

    .line 155
    iget-object v0, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v7

    .line 157
    iget-object v0, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v8

    move v2, v1

    :goto_3
    invoke-interface {v8}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_8

    invoke-interface {v8}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    .line 158
    new-instance v9, Ljava/io/File;

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v10

    invoke-direct {v9, v6, v10}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 159
    invoke-virtual {v9}, Ljava/io/File;->exists()Z

    move-result v10

    if-nez v10, :cond_5

    .line 160
    iget-object v10, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    invoke-static {v0, v10, v3, v9}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadChunk(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;Ljava/lang/String;Ljava/util/List;Ljava/io/File;)Z

    move-result v9

    if-nez v9, :cond_5

    .line 161
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Failed to download chunk "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v0, v1

    .line 162
    goto/16 :goto_0

    .line 165
    :cond_5
    add-int/lit8 v0, v2, 0x1

    .line 166
    rem-int/lit16 v2, v0, 0x1f4

    if-eqz v2, :cond_6

    if-ne v0, v7, :cond_7

    .line 167
    :cond_6
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "Downloading chunks ("

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v9, "/"

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v9, ")"

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {p3, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    :cond_7
    move v2, v0

    .line 169
    goto :goto_3

    .line 172
    :cond_8
    const-string v0, "Assembling files..."

    invoke-static {p3, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 173
    iget-object v0, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v3

    .line 175
    iget-object v0, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    move v2, v1

    :goto_4
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_e

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    .line 177
    iget-object v7, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->filename:Ljava/lang/String;

    const-string v8, "\\"

    const-string v9, "/"

    invoke-virtual {v7, v8, v9}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v7

    .line 178
    new-instance v8, Ljava/io/File;

    invoke-direct {v8, v5, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 179
    invoke-virtual {v8}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v9

    .line 180
    if-eqz v9, :cond_9

    invoke-virtual {v9}, Ljava/io/File;->mkdirs()Z

    .line 182
    :cond_9
    new-instance v9, Ljava/io/FileOutputStream;

    invoke-direct {v9, v8}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 183
    new-instance v8, Ljava/io/BufferedOutputStream;

    const/high16 v10, 0x10000

    invoke-direct {v8, v9, v10}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;I)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 185
    :try_start_2
    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->parts:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :goto_5
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_b

    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;

    .line 186
    new-instance v10, Ljava/io/File;

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guidStr()Ljava/lang/String;

    move-result-object v11

    invoke-direct {v10, v6, v11}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 187
    invoke-virtual {v10}, Ljava/io/File;->exists()Z

    move-result v11

    if-nez v11, :cond_a

    .line 188
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 189
    const-string v2, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Missing cached chunk "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guidStr()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, " for file "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 196
    :try_start_3
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    move v0, v1

    .line 190
    goto/16 :goto_0

    .line 192
    :cond_a
    :try_start_4
    invoke-static {v10}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFile(Ljava/io/File;)[B

    move-result-object v10

    .line 193
    iget v11, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    iget v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    invoke-virtual {v8, v10, v11, v0}, Ljava/io/BufferedOutputStream;->write([BII)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_5

    .line 196
    :catchall_0
    move-exception v0

    :try_start_5
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 197
    throw v0

    .line 196
    :cond_b
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 199
    add-int/lit8 v0, v2, 0x1

    .line 200
    rem-int/lit16 v2, v0, 0xc8

    if-eqz v2, :cond_c

    if-ne v0, v3, :cond_d

    .line 201
    :cond_c
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Assembling files ("

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v7, "/"

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v7, ")"

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {p3, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    :cond_d
    move v2, v0

    .line 203
    goto/16 :goto_4

    .line 206
    :cond_e
    invoke-static {v6}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->deleteDir(Ljava/io/File;)V

    .line 208
    const-string v0, "EpicDownloader"

    const-string v2, "Install complete!"

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_0

    .line 209
    const/4 v0, 0x1

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
    .line 225
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 227
    :try_start_0
    const-string v1, "\"manifests\""

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    .line 228
    if-gez v1, :cond_1

    .line 281
    :cond_0
    :goto_0
    return-object v0

    .line 229
    :cond_1
    const-string v2, "["

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 230
    if-ltz v1, :cond_0

    .line 234
    add-int/lit8 v1, v1, 0x1

    .line 240
    :goto_1
    const-string v2, "\"uri\""

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v3

    .line 241
    if-ltz v3, :cond_0

    .line 244
    const-string v1, ":"

    add-int/lit8 v2, v3, 0x5

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 245
    if-ltz v1, :cond_0

    .line 246
    const-string v2, "\""

    add-int/lit8 v1, v1, 0x1

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 247
    if-ltz v1, :cond_0

    .line 248
    const-string v2, "\""

    add-int/lit8 v4, v1, 0x1

    invoke-virtual {p0, v2, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 249
    if-ltz v2, :cond_0

    .line 250
    add-int/lit8 v1, v1, 0x1

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 251
    add-int/lit8 v2, v2, 0x1

    .line 254
    const-string v4, "/Builds"

    invoke-virtual {v1, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    .line 255
    if-gez v4, :cond_2

    move v1, v2

    goto :goto_1

    .line 257
    :cond_2
    const/4 v5, 0x0

    invoke-virtual {v1, v5, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 258
    const-string v6, "http"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_3

    move v1, v2

    goto :goto_1

    .line 261
    :cond_3
    const-string v6, "cloudflare.epicgamescdn.com"

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-eqz v6, :cond_4

    move v1, v2

    goto :goto_1

    .line 264
    :cond_4
    invoke-virtual {v1, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    .line 266
    const-string v4, "?"

    invoke-virtual {v1, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    .line 267
    if-ltz v4, :cond_5

    const/4 v6, 0x0

    invoke-virtual {v1, v6, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 268
    :cond_5
    const-string v4, "/"

    invoke-virtual {v1, v4}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v4

    .line 269
    if-gez v4, :cond_6

    move v1, v2

    goto :goto_1

    .line 270
    :cond_6
    const/4 v6, 0x0

    invoke-virtual {v1, v6, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 274
    invoke-static {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->extractQueryParams(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v3

    .line 276
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    invoke-direct {v4, v5, v1, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move v1, v2

    .line 277
    goto :goto_1

    .line 278
    :catch_0
    move-exception v1

    .line 279
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
    .line 633
    :try_start_0
    new-instance v2, Ljava/lang/String;

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    move-object/from16 v0, p0

    invoke-direct {v2, v0, v3}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    .line 634
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    .line 638
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

    .line 641
    :goto_0
    const/16 v4, 0xf

    if-lt v2, v4, :cond_0

    :try_start_2
    const-string v2, "ChunksV4"

    move-object v4, v2

    .line 646
    :goto_1
    const-string v2, "ChunkHashList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    .line 647
    const-string v2, "DataGroupList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v6

    .line 648
    const-string v2, "ChunkFilesizeList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v7

    .line 650
    if-nez v5, :cond_3

    .line 651
    const-string v2, "EpicDownloader"

    const-string v3, "JSON manifest: no ChunkHashList"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 652
    const/4 v2, 0x0

    .line 736
    :goto_2
    return-object v2

    .line 639
    :catch_0
    move-exception v2

    const/4 v2, 0x0

    goto :goto_0

    .line 642
    :cond_0
    const/4 v4, 0x6

    if-lt v2, v4, :cond_1

    const-string v2, "ChunksV3"

    move-object v4, v2

    goto :goto_1

    .line 643
    :cond_1
    const/4 v4, 0x3

    if-lt v2, v4, :cond_2

    const-string v2, "ChunksV2"

    move-object v4, v2

    goto :goto_1

    .line 644
    :cond_2
    const-string v2, "ChunksV4"

    move-object v4, v2

    goto :goto_1

    .line 656
    :cond_3
    new-instance v8, Ljava/util/LinkedHashMap;

    invoke-direct {v8}, Ljava/util/LinkedHashMap;-><init>()V

    .line 657
    invoke-virtual {v5}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v9

    .line 658
    :cond_4
    :goto_3
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_8

    .line 659
    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 660
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v10

    const/16 v11, 0x20

    if-lt v10, v11, :cond_4

    .line 661
    invoke-virtual {v5, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 663
    new-instance v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-direct {v11}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;-><init>()V

    .line 664
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

    .line 665
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

    .line 666
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

    .line 667
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

    .line 670
    if-eqz v10, :cond_5

    invoke-virtual {v10}, Ljava/lang/String;->length()I
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    move-result v12

    const/16 v13, 0x10

    if-lt v12, v13, :cond_5

    .line 672
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

    .line 676
    :cond_5
    :goto_4
    if-eqz v6, :cond_6

    .line 677
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

    .line 680
    :cond_6
    :goto_5
    if-eqz v7, :cond_7

    .line 681
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

    .line 685
    :cond_7
    :goto_6
    const/4 v10, 0x0

    :try_start_6
    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->windowSize:I

    .line 687
    invoke-interface {v8, v2, v11}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_1

    goto/16 :goto_3

    .line 734
    :catch_1
    move-exception v2

    .line 735
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

    .line 736
    const/4 v2, 0x0

    goto/16 :goto_2

    .line 673
    :catch_2
    move-exception v10

    const-wide/16 v12, 0x0

    :try_start_7
    iput-wide v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->hash:J

    goto :goto_4

    .line 678
    :catch_3
    move-exception v10

    const/4 v10, 0x0

    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->groupNum:I

    goto :goto_5

    .line 682
    :catch_4
    move-exception v10

    const-wide/16 v12, 0x0

    iput-wide v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->fileSize:J

    goto :goto_6

    .line 691
    :cond_8
    const-string v2, "FileManifestList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v5

    .line 692
    if-nez v5, :cond_9

    .line 693
    const-string v2, "EpicDownloader"

    const-string v3, "JSON manifest: no FileManifestList"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 694
    const/4 v2, 0x0

    goto/16 :goto_2

    .line 697
    :cond_9
    new-instance v6, Ljava/util/ArrayList;

    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v2

    invoke-direct {v6, v2}, Ljava/util/ArrayList;-><init>(I)V

    .line 698
    const/4 v2, 0x0

    move v3, v2

    :goto_7
    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v3, v2, :cond_c

    .line 699
    invoke-virtual {v5, v3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    .line 700
    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    invoke-direct {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;-><init>()V

    .line 701
    const-string v9, "Filename"

    const-string v10, ""

    invoke-virtual {v2, v9, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    iput-object v9, v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->filename:Ljava/lang/String;

    .line 703
    const-string v9, "FileChunkParts"

    invoke-virtual {v2, v9}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v9

    .line 704
    if-eqz v9, :cond_b

    .line 705
    const/4 v2, 0x0

    :goto_8
    invoke-virtual {v9}, Lorg/json/JSONArray;->length()I

    move-result v10

    if-ge v2, v10, :cond_b

    .line 706
    invoke-virtual {v9, v2}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v10

    .line 707
    new-instance v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;

    invoke-direct {v11}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;-><init>()V

    .line 708
    const-string v12, "Guid"

    const-string v13, ""

    invoke-virtual {v10, v12, v13}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    .line 709
    invoke-virtual {v12}, Ljava/lang/String;->length()I

    move-result v13

    const/16 v14, 0x20

    if-lt v13, v14, :cond_a

    .line 710
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

    .line 711
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

    .line 712
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

    .line 713
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

    .line 715
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

    .line 717
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

    .line 719
    :goto_a
    :try_start_a
    iget-object v10, v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->parts:Ljava/util/List;

    invoke-interface {v10, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 705
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_8

    .line 716
    :catch_5
    move-exception v12

    const/4 v12, 0x0

    iput v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    goto :goto_9

    .line 718
    :catch_6
    move-exception v10

    const/4 v10, 0x0

    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    goto :goto_a

    .line 722
    :cond_b
    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 698
    add-int/lit8 v2, v3, 0x1

    move v3, v2

    goto/16 :goto_7

    .line 725
    :cond_c
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    invoke-direct {v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;-><init>()V

    .line 726
    iput-object v4, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    .line 727
    new-instance v3, Ljava/util/ArrayList;

    invoke-interface {v8}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v5

    invoke-direct {v3, v5}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    iput-object v3, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 728
    iput-object v6, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    .line 729
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

    .line 730
    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " files="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 731
    invoke-interface {v6}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 729
    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_a
    .catch Ljava/lang/Exception; {:try_start_a .. :try_end_a} :catch_1

    goto/16 :goto_2
.end method

.method public static parseManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;
    .locals 17

    .prologue
    .line 389
    :try_start_0
    invoke-static/range {p0 .. p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 392
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 393
    const v2, 0x44bec00c

    if-eq v0, v2, :cond_0

    .line 395
    const-string v0, "EpicDownloader"

    const-string v1, "Non-binary manifest, trying JSON parser"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 396
    invoke-static/range {p0 .. p0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseJsonManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    move-result-object v0

    .line 524
    :goto_0
    return-object v0

    .line 398
    :cond_0
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v3

    .line 399
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v4

    .line 400
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    .line 401
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    add-int/lit8 v0, v0, 0x14

    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 402
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B

    move-result v0

    and-int/lit16 v5, v0, 0xff

    .line 403
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 407
    const/16 v2, 0xf

    if-lt v0, v2, :cond_1

    const-string v0, "ChunksV4"

    move-object v2, v0

    .line 413
    :goto_1
    invoke-virtual {v1, v3}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 414
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    new-array v0, v0, [B

    .line 415
    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 418
    and-int/lit8 v1, v5, 0x1

    if-eqz v1, :cond_4

    .line 419
    new-instance v1, Ljava/util/zip/Inflater;

    invoke-direct {v1}, Ljava/util/zip/Inflater;-><init>()V

    .line 420
    invoke-virtual {v1, v0}, Ljava/util/zip/Inflater;->setInput([B)V

    .line 421
    new-array v0, v4, [B

    .line 422
    invoke-virtual {v1, v0}, Ljava/util/zip/Inflater;->inflate([B)I

    move-result v3

    .line 423
    invoke-virtual {v1}, Ljava/util/zip/Inflater;->end()V

    .line 424
    if-eq v3, v4, :cond_4

    .line 425
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

    .line 426
    const/4 v0, 0x0

    goto :goto_0

    .line 408
    :cond_1
    const/4 v2, 0x6

    if-lt v0, v2, :cond_2

    const-string v0, "ChunksV3"

    move-object v2, v0

    goto :goto_1

    .line 409
    :cond_2
    const/4 v2, 0x3

    if-lt v0, v2, :cond_3

    const-string v0, "ChunksV2"

    move-object v2, v0

    goto :goto_1

    .line 410
    :cond_3
    const-string v0, "Chunks"

    move-object v2, v0

    goto :goto_1

    .line 431
    :cond_4
    invoke-static {v0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v3

    .line 434
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 435
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v1

    add-int/lit8 v1, v1, -0x4

    add-int/2addr v0, v1

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 438
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v1

    .line 439
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v4

    .line 440
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->get()B

    .line 441
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v5

    .line 443
    new-instance v6, Ljava/util/ArrayList;

    invoke-direct {v6, v5}, Ljava/util/ArrayList;-><init>(I)V

    .line 444
    const/4 v0, 0x0

    :goto_2
    if-ge v0, v5, :cond_5

    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-direct {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;-><init>()V

    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 447
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

    .line 448
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x0

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 449
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x1

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 450
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x2

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 451
    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v8, 0x3

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v9

    aput v9, v0, v8
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_3

    .line 522
    :catch_0
    move-exception v0

    .line 523
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

    .line 524
    const/4 v0, 0x0

    goto/16 :goto_0

    .line 453
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

    .line 455
    :cond_7
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    mul-int/lit8 v7, v5, 0x14

    add-int/2addr v0, v7

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 456
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

    .line 457
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

    .line 458
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

    .line 461
    :cond_a
    add-int v0, v1, v4

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 464
    new-instance v1, Ljava/util/LinkedHashMap;

    mul-int/lit8 v0, v5, 0x2

    invoke-direct {v1, v0}, Ljava/util/LinkedHashMap;-><init>(I)V

    .line 465
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

    .line 468
    :cond_b
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    .line 469
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v7

    .line 470
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->get()B

    .line 471
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v8

    .line 473
    new-instance v9, Ljava/util/ArrayList;

    invoke-direct {v9, v8}, Ljava/util/ArrayList;-><init>(I)V

    .line 474
    const/4 v0, 0x0

    :goto_9
    if-ge v0, v8, :cond_c

    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    invoke-direct {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;-><init>()V

    invoke-interface {v9, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_9

    .line 477
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

    .line 479
    :cond_d
    const/4 v0, 0x0

    :goto_b
    if-ge v0, v8, :cond_e

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;

    add-int/lit8 v0, v0, 0x1

    goto :goto_b

    .line 481
    :cond_e
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    mul-int/lit8 v1, v8, 0x14

    add-int/2addr v0, v1

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 483
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    add-int/2addr v0, v8

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 485
    const/4 v0, 0x0

    move v1, v0

    :goto_c
    if-ge v1, v8, :cond_10

    .line 486
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    .line 487
    const/4 v0, 0x0

    :goto_d
    if-ge v0, v10, :cond_f

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;

    add-int/lit8 v0, v0, 0x1

    goto :goto_d

    .line 485
    :cond_f
    add-int/lit8 v0, v1, 0x1

    move v1, v0

    goto :goto_c

    .line 490
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

    .line 491
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    .line 492
    const/4 v1, 0x0

    :goto_e
    if-ge v1, v10, :cond_11

    .line 493
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v11

    .line 494
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v12

    .line 495
    new-instance v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;

    invoke-direct {v13}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;-><init>()V

    .line 496
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x0

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 497
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x1

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 498
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x2

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 499
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x3

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 500
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v14

    iput v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    .line 501
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v14

    iput v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    .line 502
    iget-object v14, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->parts:Ljava/util/List;

    invoke-interface {v14, v13}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 504
    add-int/2addr v11, v12

    invoke-virtual {v3, v11}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 492
    add-int/lit8 v1, v1, 0x1

    goto :goto_e

    .line 509
    :cond_12
    add-int v0, v4, v7

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 512
    new-instance v1, Ljava/util/LinkedHashMap;

    mul-int/lit8 v0, v5, 0x2

    invoke-direct {v1, v0}, Ljava/util/LinkedHashMap;-><init>(I)V

    .line 513
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

    .line 514
    :cond_13
    new-instance v3, Ljava/util/ArrayList;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-direct {v3, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 516
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    invoke-direct {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;-><init>()V

    .line 517
    iput-object v2, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    .line 518
    iput-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 519
    iput-object v9, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0
.end method

.method private static progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V
    .locals 1

    .prologue
    .line 827
    if-eqz p0, :cond_0

    invoke-interface {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;->onProgress(Ljava/lang/String;)V

    .line 828
    :cond_0
    const-string v0, "EpicDownloader"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 829
    return-void
.end method

.method public static readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;
    .locals 3

    .prologue
    .line 783
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 784
    if-nez v0, :cond_0

    const-string v0, ""

    .line 795
    :goto_0
    return-object v0

    .line 785
    :cond_0
    if-gez v0, :cond_1

    .line 786
    neg-int v0, v0

    add-int/lit8 v0, v0, -0x1

    .line 787
    mul-int/lit8 v0, v0, 0x2

    new-array v1, v0, [B

    .line 788
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 789
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getShort()S

    .line 790
    new-instance v0, Ljava/lang/String;

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_16LE:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    goto :goto_0

    .line 792
    :cond_1
    add-int/lit8 v0, v0, -0x1

    new-array v1, v0, [B

    .line 793
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 794
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B

    .line 795
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
    .line 802
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 803
    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v2

    long-to-int v0, v2

    new-array v2, v0, [B

    .line 804
    const/4 v0, 0x0

    .line 805
    :goto_0
    array-length v3, v2

    if-ge v0, v3, :cond_0

    .line 806
    array-length v3, v2

    sub-int/2addr v3, v0

    invoke-virtual {v1, v2, v0, v3}, Ljava/io/FileInputStream;->read([BII)I

    move-result v3

    .line 807
    if-gez v3, :cond_1

    .line 810
    :cond_0
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V

    .line 811
    return-object v2

    .line 808
    :cond_1
    add-int/2addr v0, v3

    .line 809
    goto :goto_0
.end method
