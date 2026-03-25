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
    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static decompressChunk([BI)[B
    .locals 6

    .prologue
    const/4 v0, 0x0

    .line 572
    :try_start_0
    invoke-static {p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v1

    sget-object v2, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 573
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    .line 574
    const v3, -0x4e01c55e

    if-eq v2, v3, :cond_1

    .line 575
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

    .line 616
    :cond_0
    :goto_0
    return-object v0

    .line 578
    :cond_1
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    .line 579
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    .line 580
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v3

    .line 581
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    add-int/lit8 v4, v4, 0x10

    invoke-virtual {v1, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 582
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    add-int/lit8 v4, v4, 0x8

    invoke-virtual {v1, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 583
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B

    move-result v1

    and-int/lit16 v4, v1, 0xff

    .line 586
    if-ltz v2, :cond_2

    array-length v1, p0

    if-lt v2, v1, :cond_3

    .line 587
    :cond_2
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

    .line 614
    :catch_0
    move-exception v1

    .line 615
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

    .line 590
    :cond_3
    :try_start_1
    new-array v1, v3, [B

    .line 591
    const/4 v5, 0x0

    invoke-static {p0, v2, v1, v5, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 593
    and-int/lit8 v2, v4, 0x1

    if-eqz v2, :cond_5

    .line 595
    new-instance v3, Ljava/util/zip/Inflater;

    invoke-direct {v3}, Ljava/util/zip/Inflater;-><init>()V

    .line 596
    invoke-virtual {v3, v1}, Ljava/util/zip/Inflater;->setInput([B)V

    .line 597
    new-array v2, p1, [B

    .line 598
    invoke-virtual {v3, v2}, Ljava/util/zip/Inflater;->inflate([B)I

    move-result v4

    .line 599
    invoke-virtual {v3}, Ljava/util/zip/Inflater;->end()V

    .line 600
    if-eq v4, p1, :cond_4

    .line 601
    const-string v1, "EpicDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Chunk decomp size mismatch: expected="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, " got="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 603
    if-lez v4, :cond_0

    .line 604
    new-array v1, v4, [B

    .line 605
    const/4 v3, 0x0

    const/4 v5, 0x0

    invoke-static {v2, v3, v1, v5, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    move-object v0, v1

    .line 606
    goto/16 :goto_0

    :cond_4
    move-object v0, v2

    .line 610
    goto/16 :goto_0

    :cond_5
    move-object v0, v1

    .line 613
    goto/16 :goto_0
.end method

.method public static deleteDir(Ljava/io/File;)V
    .locals 5

    .prologue
    .line 695
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_0

    .line 704
    :goto_0
    return-void

    .line 696
    :cond_0
    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v1

    .line 697
    if-eqz v1, :cond_2

    .line 698
    array-length v2, v1

    const/4 v0, 0x0

    :goto_1
    if-ge v0, v2, :cond_2

    aget-object v3, v1, v0

    .line 699
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->deleteDir(Ljava/io/File;)V

    .line 698
    :goto_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 700
    :cond_1
    invoke-virtual {v3}, Ljava/io/File;->delete()Z

    goto :goto_2

    .line 703
    :cond_2
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    goto :goto_0
.end method

.method public static downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B
    .locals 7

    .prologue
    const/4 v1, 0x0

    .line 624
    .line 626
    :try_start_0
    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 627
    const/16 v2, 0x7530

    :try_start_1
    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 628
    const v2, 0xea60

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 629
    const-string v2, "GET"

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    .line 630
    const-string v2, "User-Agent"

    const-string v3, "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"

    invoke-virtual {v0, v2, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 631
    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_0

    .line 632
    const-string v2, "Authorization"

    invoke-virtual {v0, v2, p1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 634
    :cond_0
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v2

    .line 635
    const/16 v3, 0xc8

    if-eq v2, v3, :cond_2

    .line 636
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

    .line 650
    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_1
    move-object v0, v1

    .line 648
    :goto_0
    return-object v0

    .line 639
    :cond_2
    :try_start_2
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    .line 640
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v3}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 641
    const/16 v4, 0x2000

    new-array v4, v4, [B

    .line 643
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

    .line 646
    :catch_0
    move-exception v2

    move-object v3, v0

    .line 647
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

    .line 650
    if-eqz v3, :cond_3

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_3
    move-object v0, v1

    .line 648
    goto :goto_0

    .line 644
    :cond_4
    :try_start_4
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    .line 645
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    move-result-object v1

    .line 650
    if-eqz v0, :cond_5

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_5
    move-object v0, v1

    .line 645
    goto :goto_0

    .line 650
    :catchall_0
    move-exception v0

    move-object v2, v0

    move-object v3, v1

    :goto_3
    if-eqz v3, :cond_6

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 651
    :cond_6
    throw v2

    .line 650
    :catchall_1
    move-exception v1

    move-object v2, v1

    move-object v3, v0

    goto :goto_3

    :catchall_2
    move-exception v0

    move-object v2, v0

    goto :goto_3

    .line 646
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
    .line 538
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->getPath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 540
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

    .line 541
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

    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->authParams:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 543
    const/4 v4, 0x0

    :try_start_0
    invoke-static {v1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v1

    .line 544
    if-eqz v1, :cond_0

    .line 546
    iget v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->windowSize:I

    invoke-static {v1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->decompressChunk([BI)[B

    move-result-object v1

    .line 547
    if-nez v1, :cond_1

    .line 548
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

    .line 556
    :catch_0
    move-exception v1

    .line 557
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

    .line 552
    :cond_1
    :try_start_1
    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, p3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 553
    :try_start_2
    invoke-virtual {v4, v1}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    .line 554
    const/4 v0, 0x1

    .line 561
    :goto_1
    return v0

    .line 553
    :catchall_0
    move-exception v1

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    throw v1
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    .line 560
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

    .line 561
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

    .line 344
    :try_start_0
    const-string v0, "\"manifests\""

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    .line 345
    if-gez v0, :cond_1

    move-object v0, v1

    .line 374
    :cond_0
    :goto_0
    return-object v0

    .line 346
    :cond_1
    const-string v2, "\"uri\""

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 347
    if-gez v0, :cond_2

    move-object v0, v1

    goto :goto_0

    .line 348
    :cond_2
    const-string v2, ":"

    add-int/lit8 v0, v0, 0x5

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 349
    if-gez v0, :cond_3

    move-object v0, v1

    goto :goto_0

    .line 350
    :cond_3
    const-string v2, "\""

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 351
    if-gez v0, :cond_4

    move-object v0, v1

    goto :goto_0

    .line 352
    :cond_4
    const-string v2, "\""

    add-int/lit8 v3, v0, 0x1

    invoke-virtual {p0, v2, v3}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 353
    if-gez v2, :cond_5

    move-object v0, v1

    goto :goto_0

    .line 354
    :cond_5
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    .line 356
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

    .line 357
    invoke-static {v2, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v0

    .line 358
    if-eqz v0, :cond_6

    array-length v3, v0

    if-gt v3, v7, :cond_0

    .line 361
    :cond_6
    const-string v0, "/Builds"

    invoke-virtual {v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    .line 362
    if-gez v0, :cond_7

    move-object v0, v1

    goto :goto_0

    .line 363
    :cond_7
    invoke-virtual {v2, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    .line 365
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_8
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_9

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    .line 366
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 367
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

    .line 368
    invoke-static {v0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v0

    .line 369
    if-eqz v0, :cond_8

    array-length v4, v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-le v4, v7, :cond_8

    goto/16 :goto_0

    .line 371
    :catch_0
    move-exception v0

    .line 372
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

    .line 374
    goto/16 :goto_0
.end method

.method private static extractQueryParams(Ljava/lang/String;I)Ljava/lang/String;
    .locals 8

    .prologue
    const/4 v1, 0x0

    .line 288
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    add-int/lit16 v2, p1, 0x7d0

    invoke-static {v0, v2}, Ljava/lang/Math;->min(II)I

    move-result v0

    .line 289
    const-string v2, "\"queryParams\""

    invoke-virtual {p0, v2, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 290
    if-ltz v2, :cond_0

    if-le v2, v0, :cond_1

    :cond_0
    const-string v0, ""

    .line 331
    :goto_0
    return-object v0

    .line 291
    :cond_1
    const-string v0, "["

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 292
    if-gez v0, :cond_2

    const-string v0, ""

    goto :goto_0

    .line 293
    :cond_2
    const-string v2, "]"

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 294
    if-gez v2, :cond_3

    const-string v0, ""

    goto :goto_0

    .line 295
    :cond_3
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    .line 296
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, ""

    goto :goto_0

    .line 298
    :cond_4
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v0, "?"

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 299
    const/4 v2, 0x1

    move v0, v1

    .line 301
    :goto_1
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v5

    if-ge v0, v5, :cond_5

    .line 303
    const-string v5, "\"name\""

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 304
    if-gez v0, :cond_6

    .line 329
    :cond_5
    if-eqz v2, :cond_8

    const-string v0, ""

    goto :goto_0

    .line 305
    :cond_6
    const-string v5, ":"

    add-int/lit8 v0, v0, 0x6

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 306
    if-ltz v0, :cond_5

    .line 307
    const-string v5, "\""

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 308
    if-ltz v0, :cond_5

    .line 309
    const-string v5, "\""

    add-int/lit8 v6, v0, 0x1

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 310
    if-ltz v5, :cond_5

    .line 311
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {v3, v0, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    .line 314
    const-string v6, "\"value\""

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 315
    if-ltz v5, :cond_5

    .line 316
    const-string v6, ":"

    add-int/lit8 v5, v5, 0x7

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 317
    if-ltz v5, :cond_5

    .line 318
    const-string v6, "\""

    add-int/lit8 v5, v5, 0x1

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 319
    if-ltz v5, :cond_5

    .line 320
    const-string v6, "\""

    add-int/lit8 v7, v5, 0x1

    invoke-virtual {v3, v6, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v6

    .line 321
    if-ltz v6, :cond_5

    .line 322
    add-int/lit8 v5, v5, 0x1

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 324
    if-nez v2, :cond_7

    const-string v2, "&"

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 325
    :cond_7
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 327
    add-int/lit8 v0, v6, 0x1

    move v2, v1

    .line 328
    goto :goto_1

    .line 329
    :cond_8
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    goto/16 :goto_0

    .line 330
    :catch_0
    move-exception v0

    .line 331
    const-string v0, ""

    goto/16 :goto_0
.end method

.method public static install(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;)Z
    .locals 12

    .prologue
    const/4 v1, 0x0

    .line 110
    :try_start_0
    const-string v0, "Parsing CDN URLs..."

    invoke-static {p3, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 115
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseCdnUrls(Ljava/lang/String;)Ljava/util/List;

    move-result-object v3

    .line 116
    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 117
    const-string v0, "EpicDownloader"

    const-string v2, "No CDN URLs in manifest API response"

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v0, v1

    .line 210
    :goto_0
    return v0

    .line 120
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

    .line 121
    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_1
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    .line 122
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

    .line 208
    :catch_0
    move-exception v0

    .line 209
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

    .line 210
    goto :goto_0

    .line 122
    :cond_1
    :try_start_1
    const-string v0, "YES"

    goto :goto_2

    .line 126
    :cond_2
    const-string v0, "Downloading manifest..."

    invoke-static {p3, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 127
    invoke-static {p0, p1, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadManifest(Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)[B

    move-result-object v0

    .line 128
    if-nez v0, :cond_3

    .line 129
    const-string v0, "EpicDownloader"

    const-string v2, "Failed to download manifest binary"

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v0, v1

    .line 130
    goto/16 :goto_0

    .line 132
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

    .line 135
    const-string v2, "Parsing manifest..."

    invoke-static {p3, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 136
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    move-result-object v4

    .line 137
    if-nez v4, :cond_4

    .line 138
    const-string v0, "EpicDownloader"

    const-string v2, "Failed to parse manifest"

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v0, v1

    .line 139
    goto/16 :goto_0

    .line 141
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

    .line 142
    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, " files="

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v5, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    .line 143
    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 141
    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 147
    new-instance v5, Ljava/io/File;

    invoke-direct {v5, p2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 148
    invoke-virtual {v5}, Ljava/io/File;->mkdirs()Z

    .line 149
    new-instance v6, Ljava/io/File;

    const-string v0, ".chunks"

    invoke-direct {v6, v5, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 150
    invoke-virtual {v6}, Ljava/io/File;->mkdirs()Z

    .line 152
    iget-object v0, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v7

    .line 154
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

    .line 155
    new-instance v9, Ljava/io/File;

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v10

    invoke-direct {v9, v6, v10}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 156
    invoke-virtual {v9}, Ljava/io/File;->exists()Z

    move-result v10

    if-nez v10, :cond_5

    .line 157
    iget-object v10, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    invoke-static {v0, v10, v3, v9}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadChunk(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;Ljava/lang/String;Ljava/util/List;Ljava/io/File;)Z

    move-result v9

    if-nez v9, :cond_5

    .line 158
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

    .line 159
    goto/16 :goto_0

    .line 162
    :cond_5
    add-int/lit8 v0, v2, 0x1

    .line 163
    rem-int/lit16 v2, v0, 0x1f4

    if-eqz v2, :cond_6

    if-ne v0, v7, :cond_7

    .line 164
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

    .line 166
    goto :goto_3

    .line 169
    :cond_8
    const-string v0, "Assembling files..."

    invoke-static {p3, v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 170
    iget-object v0, v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v3

    .line 172
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

    .line 174
    iget-object v7, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->filename:Ljava/lang/String;

    const-string v8, "\\"

    const-string v9, "/"

    invoke-virtual {v7, v8, v9}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v7

    .line 175
    new-instance v8, Ljava/io/File;

    invoke-direct {v8, v5, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 176
    invoke-virtual {v8}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v9

    .line 177
    if-eqz v9, :cond_9

    invoke-virtual {v9}, Ljava/io/File;->mkdirs()Z

    .line 179
    :cond_9
    new-instance v9, Ljava/io/FileOutputStream;

    invoke-direct {v9, v8}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 180
    new-instance v8, Ljava/io/BufferedOutputStream;

    const/high16 v10, 0x10000

    invoke-direct {v8, v9, v10}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;I)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 182
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

    .line 183
    new-instance v10, Ljava/io/File;

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guidStr()Ljava/lang/String;

    move-result-object v11

    invoke-direct {v10, v6, v11}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 184
    invoke-virtual {v10}, Ljava/io/File;->exists()Z

    move-result v11

    if-nez v11, :cond_a

    .line 185
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 186
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

    .line 193
    :try_start_3
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    move v0, v1

    .line 187
    goto/16 :goto_0

    .line 189
    :cond_a
    :try_start_4
    invoke-static {v10}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFile(Ljava/io/File;)[B

    move-result-object v10

    .line 190
    iget v11, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    iget v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    invoke-virtual {v8, v10, v11, v0}, Ljava/io/BufferedOutputStream;->write([BII)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_5

    .line 193
    :catchall_0
    move-exception v0

    :try_start_5
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 194
    throw v0

    .line 193
    :cond_b
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 196
    add-int/lit8 v0, v2, 0x1

    .line 197
    rem-int/lit16 v2, v0, 0xc8

    if-eqz v2, :cond_c

    if-ne v0, v3, :cond_d

    .line 198
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

    .line 200
    goto/16 :goto_4

    .line 203
    :cond_e
    invoke-static {v6}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->deleteDir(Ljava/io/File;)V

    .line 205
    const-string v0, "EpicDownloader"

    const-string v2, "Install complete!"

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_0

    .line 206
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
    .line 222
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 224
    :try_start_0
    const-string v1, "\"manifests\""

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    .line 225
    if-gez v1, :cond_1

    .line 278
    :cond_0
    :goto_0
    return-object v0

    .line 226
    :cond_1
    const-string v2, "["

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 227
    if-ltz v1, :cond_0

    .line 231
    add-int/lit8 v1, v1, 0x1

    .line 237
    :goto_1
    const-string v2, "\"uri\""

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v3

    .line 238
    if-ltz v3, :cond_0

    .line 241
    const-string v1, ":"

    add-int/lit8 v2, v3, 0x5

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 242
    if-ltz v1, :cond_0

    .line 243
    const-string v2, "\""

    add-int/lit8 v1, v1, 0x1

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 244
    if-ltz v1, :cond_0

    .line 245
    const-string v2, "\""

    add-int/lit8 v4, v1, 0x1

    invoke-virtual {p0, v2, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 246
    if-ltz v2, :cond_0

    .line 247
    add-int/lit8 v1, v1, 0x1

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 248
    add-int/lit8 v2, v2, 0x1

    .line 251
    const-string v4, "/Builds"

    invoke-virtual {v1, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    .line 252
    if-gez v4, :cond_2

    move v1, v2

    goto :goto_1

    .line 254
    :cond_2
    const/4 v5, 0x0

    invoke-virtual {v1, v5, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 255
    const-string v6, "http"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_3

    move v1, v2

    goto :goto_1

    .line 258
    :cond_3
    const-string v6, "cloudflare.epicgamescdn.com"

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-eqz v6, :cond_4

    move v1, v2

    goto :goto_1

    .line 261
    :cond_4
    invoke-virtual {v1, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    .line 263
    const-string v4, "?"

    invoke-virtual {v1, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    .line 264
    if-ltz v4, :cond_5

    const/4 v6, 0x0

    invoke-virtual {v1, v6, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 265
    :cond_5
    const-string v4, "/"

    invoke-virtual {v1, v4}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v4

    .line 266
    if-gez v4, :cond_6

    move v1, v2

    goto :goto_1

    .line 267
    :cond_6
    const/4 v6, 0x0

    invoke-virtual {v1, v6, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 271
    invoke-static {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->extractQueryParams(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v3

    .line 273
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    invoke-direct {v4, v5, v1, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move v1, v2

    .line 274
    goto :goto_1

    .line 275
    :catch_0
    move-exception v1

    .line 276
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

.method public static parseManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;
    .locals 17

    .prologue
    .line 386
    :try_start_0
    invoke-static/range {p0 .. p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 389
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 390
    const v2, 0x44bec00c

    if-eq v0, v2, :cond_0

    .line 392
    const-string v1, "EpicDownloader"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Non-binary manifest magic=0x"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 393
    const/4 v0, 0x0

    .line 521
    :goto_0
    return-object v0

    .line 395
    :cond_0
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v3

    .line 396
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v4

    .line 397
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    .line 398
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    add-int/lit8 v0, v0, 0x14

    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 399
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B

    move-result v0

    and-int/lit16 v5, v0, 0xff

    .line 400
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 404
    const/16 v2, 0xf

    if-lt v0, v2, :cond_1

    const-string v0, "ChunksV4"

    move-object v2, v0

    .line 410
    :goto_1
    invoke-virtual {v1, v3}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 411
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    new-array v0, v0, [B

    .line 412
    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 415
    and-int/lit8 v1, v5, 0x1

    if-eqz v1, :cond_4

    .line 416
    new-instance v1, Ljava/util/zip/Inflater;

    invoke-direct {v1}, Ljava/util/zip/Inflater;-><init>()V

    .line 417
    invoke-virtual {v1, v0}, Ljava/util/zip/Inflater;->setInput([B)V

    .line 418
    new-array v0, v4, [B

    .line 419
    invoke-virtual {v1, v0}, Ljava/util/zip/Inflater;->inflate([B)I

    move-result v3

    .line 420
    invoke-virtual {v1}, Ljava/util/zip/Inflater;->end()V

    .line 421
    if-eq v3, v4, :cond_4

    .line 422
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

    .line 423
    const/4 v0, 0x0

    goto :goto_0

    .line 405
    :cond_1
    const/4 v2, 0x6

    if-lt v0, v2, :cond_2

    const-string v0, "ChunksV3"

    move-object v2, v0

    goto :goto_1

    .line 406
    :cond_2
    const/4 v2, 0x3

    if-lt v0, v2, :cond_3

    const-string v0, "ChunksV2"

    move-object v2, v0

    goto :goto_1

    .line 407
    :cond_3
    const-string v0, "Chunks"

    move-object v2, v0

    goto :goto_1

    .line 428
    :cond_4
    invoke-static {v0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v3

    .line 431
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 432
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v1

    add-int/lit8 v1, v1, -0x4

    add-int/2addr v0, v1

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 435
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v1

    .line 436
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v4

    .line 437
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->get()B

    .line 438
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v5

    .line 440
    new-instance v6, Ljava/util/ArrayList;

    invoke-direct {v6, v5}, Ljava/util/ArrayList;-><init>(I)V

    .line 441
    const/4 v0, 0x0

    :goto_2
    if-ge v0, v5, :cond_5

    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-direct {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;-><init>()V

    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 444
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

    .line 445
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x0

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 446
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x1

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 447
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x2

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 448
    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v8, 0x3

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v9

    aput v9, v0, v8
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_3

    .line 519
    :catch_0
    move-exception v0

    .line 520
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

    .line 521
    const/4 v0, 0x0

    goto/16 :goto_0

    .line 450
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

    .line 452
    :cond_7
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    mul-int/lit8 v7, v5, 0x14

    add-int/2addr v0, v7

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 453
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

    .line 454
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

    .line 455
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

    .line 458
    :cond_a
    add-int v0, v1, v4

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 461
    new-instance v1, Ljava/util/LinkedHashMap;

    mul-int/lit8 v0, v5, 0x2

    invoke-direct {v1, v0}, Ljava/util/LinkedHashMap;-><init>(I)V

    .line 462
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

    .line 465
    :cond_b
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    .line 466
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v7

    .line 467
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->get()B

    .line 468
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v8

    .line 470
    new-instance v9, Ljava/util/ArrayList;

    invoke-direct {v9, v8}, Ljava/util/ArrayList;-><init>(I)V

    .line 471
    const/4 v0, 0x0

    :goto_9
    if-ge v0, v8, :cond_c

    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    invoke-direct {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;-><init>()V

    invoke-interface {v9, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_9

    .line 474
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

    .line 476
    :cond_d
    const/4 v0, 0x0

    :goto_b
    if-ge v0, v8, :cond_e

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;

    add-int/lit8 v0, v0, 0x1

    goto :goto_b

    .line 478
    :cond_e
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    mul-int/lit8 v1, v8, 0x14

    add-int/2addr v0, v1

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 480
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    add-int/2addr v0, v8

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 482
    const/4 v0, 0x0

    move v1, v0

    :goto_c
    if-ge v1, v8, :cond_10

    .line 483
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    .line 484
    const/4 v0, 0x0

    :goto_d
    if-ge v0, v10, :cond_f

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;

    add-int/lit8 v0, v0, 0x1

    goto :goto_d

    .line 482
    :cond_f
    add-int/lit8 v0, v1, 0x1

    move v1, v0

    goto :goto_c

    .line 487
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

    .line 488
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    .line 489
    const/4 v1, 0x0

    :goto_e
    if-ge v1, v10, :cond_11

    .line 490
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v11

    .line 491
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v12

    .line 492
    new-instance v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;

    invoke-direct {v13}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;-><init>()V

    .line 493
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x0

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 494
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x1

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 495
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x2

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 496
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x3

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 497
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v14

    iput v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    .line 498
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v14

    iput v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    .line 499
    iget-object v14, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->parts:Ljava/util/List;

    invoke-interface {v14, v13}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 501
    add-int/2addr v11, v12

    invoke-virtual {v3, v11}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 489
    add-int/lit8 v1, v1, 0x1

    goto :goto_e

    .line 506
    :cond_12
    add-int v0, v4, v7

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 509
    new-instance v1, Ljava/util/LinkedHashMap;

    mul-int/lit8 v0, v5, 0x2

    invoke-direct {v1, v0}, Ljava/util/LinkedHashMap;-><init>(I)V

    .line 510
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

    .line 511
    :cond_13
    new-instance v3, Ljava/util/ArrayList;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-direct {v3, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 513
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    invoke-direct {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;-><init>()V

    .line 514
    iput-object v2, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    .line 515
    iput-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 516
    iput-object v9, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0
.end method

.method private static progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V
    .locals 1

    .prologue
    .line 707
    if-eqz p0, :cond_0

    invoke-interface {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;->onProgress(Ljava/lang/String;)V

    .line 708
    :cond_0
    const-string v0, "EpicDownloader"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 709
    return-void
.end method

.method public static readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;
    .locals 3

    .prologue
    .line 663
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 664
    if-nez v0, :cond_0

    const-string v0, ""

    .line 675
    :goto_0
    return-object v0

    .line 665
    :cond_0
    if-gez v0, :cond_1

    .line 666
    neg-int v0, v0

    add-int/lit8 v0, v0, -0x1

    .line 667
    mul-int/lit8 v0, v0, 0x2

    new-array v1, v0, [B

    .line 668
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 669
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getShort()S

    .line 670
    new-instance v0, Ljava/lang/String;

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_16LE:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    goto :goto_0

    .line 672
    :cond_1
    add-int/lit8 v0, v0, -0x1

    new-array v1, v0, [B

    .line 673
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 674
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B

    .line 675
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
    .line 682
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 683
    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v2

    long-to-int v0, v2

    new-array v2, v0, [B

    .line 684
    const/4 v0, 0x0

    .line 685
    :goto_0
    array-length v3, v2

    if-ge v0, v3, :cond_0

    .line 686
    array-length v3, v2

    sub-int/2addr v3, v0

    invoke-virtual {v1, v2, v0, v3}, Ljava/io/FileInputStream;->read([BII)I

    move-result v3

    .line 687
    if-gez v3, :cond_1

    .line 690
    :cond_0
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V

    .line 691
    return-object v2

    .line 688
    :cond_1
    add-int/2addr v0, v3

    .line 689
    goto :goto_0
.end method
