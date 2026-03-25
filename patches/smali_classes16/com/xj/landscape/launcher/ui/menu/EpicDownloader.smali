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
    .line 845
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

    .line 846
    if-nez p0, :cond_1

    .line 855
    :cond_0
    :goto_0
    return-void

    .line 848
    :cond_1
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0, v0}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    .line 849
    if-eqz v0, :cond_0

    .line 850
    new-instance v1, Ljava/io/File;

    const-string v2, "bh_epic_debug.txt"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 851
    new-instance v0, Ljava/io/FileWriter;

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Ljava/io/FileWriter;-><init>(Ljava/io/File;Z)V

    .line 852
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

    .line 853
    invoke-virtual {v0}, Ljava/io/FileWriter;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 854
    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method public static decompressChunk([BI)[B
    .locals 6

    .prologue
    const/4 v0, 0x0

    .line 595
    :try_start_0
    invoke-static {p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v1

    sget-object v2, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 596
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    .line 597
    const v3, -0x4e01c55e

    if-eq v2, v3, :cond_0

    .line 598
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

    .line 637
    :goto_0
    return-object v0

    .line 601
    :cond_0
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    .line 602
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v2

    .line 603
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v3

    .line 604
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    add-int/lit8 v4, v4, 0x10

    invoke-virtual {v1, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 605
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    add-int/lit8 v4, v4, 0x8

    invoke-virtual {v1, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 606
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B

    move-result v1

    and-int/lit16 v4, v1, 0xff

    .line 609
    if-ltz v2, :cond_1

    array-length v1, p0

    if-lt v2, v1, :cond_2

    .line 610
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

    .line 635
    :catch_0
    move-exception v1

    .line 636
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

    .line 613
    :cond_2
    :try_start_1
    new-array v1, v3, [B

    .line 614
    const/4 v5, 0x0

    invoke-static {p0, v2, v1, v5, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 616
    and-int/lit8 v2, v4, 0x1

    if-eqz v2, :cond_6

    .line 618
    new-instance v2, Ljava/util/zip/Inflater;

    invoke-direct {v2}, Ljava/util/zip/Inflater;-><init>()V

    .line 619
    invoke-virtual {v2, v1}, Ljava/util/zip/Inflater;->setInput([B)V

    .line 620
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    .line 621
    if-lez p1, :cond_3

    :goto_1
    invoke-direct {v1, p1}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 622
    const/high16 v3, 0x10000

    new-array v3, v3, [B

    .line 624
    :goto_2
    invoke-virtual {v2, v3}, Ljava/util/zip/Inflater;->inflate([B)I

    move-result v4

    if-lez v4, :cond_4

    const/4 v5, 0x0

    invoke-virtual {v1, v3, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_2

    .line 621
    :cond_3
    const/high16 p1, 0x100000

    goto :goto_1

    .line 625
    :cond_4
    invoke-virtual {v2}, Ljava/util/zip/Inflater;->end()V

    .line 626
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1

    .line 627
    array-length v2, v1

    if-nez v2, :cond_5

    .line 628
    const-string v1, "EpicDownloader"

    const-string v2, "Chunk inflate produced 0 bytes"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0

    :cond_5
    move-object v0, v1

    .line 631
    goto/16 :goto_0

    :cond_6
    move-object v0, v1

    .line 634
    goto/16 :goto_0
.end method

.method public static deleteDir(Ljava/io/File;)V
    .locals 5

    .prologue
    .line 832
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_0

    .line 841
    :goto_0
    return-void

    .line 833
    :cond_0
    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v1

    .line 834
    if-eqz v1, :cond_2

    .line 835
    array-length v2, v1

    const/4 v0, 0x0

    :goto_1
    if-ge v0, v2, :cond_2

    aget-object v3, v1, v0

    .line 836
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->deleteDir(Ljava/io/File;)V

    .line 835
    :goto_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 837
    :cond_1
    invoke-virtual {v3}, Ljava/io/File;->delete()Z

    goto :goto_2

    .line 840
    :cond_2
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    goto :goto_0
.end method

.method public static downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B
    .locals 7

    .prologue
    const/4 v1, 0x0

    .line 761
    .line 763
    :try_start_0
    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 764
    const/16 v2, 0x7530

    :try_start_1
    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 765
    const v2, 0xea60

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 766
    const-string v2, "GET"

    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    .line 767
    const-string v2, "User-Agent"

    const-string v3, "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"

    invoke-virtual {v0, v2, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 768
    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_0

    .line 769
    const-string v2, "Authorization"

    invoke-virtual {v0, v2, p1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 771
    :cond_0
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v2

    .line 772
    const/16 v3, 0xc8

    if-eq v2, v3, :cond_2

    .line 773
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

    .line 787
    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_1
    move-object v0, v1

    .line 785
    :goto_0
    return-object v0

    .line 776
    :cond_2
    :try_start_2
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    .line 777
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v3}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 778
    const/16 v4, 0x2000

    new-array v4, v4, [B

    .line 780
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

    .line 783
    :catch_0
    move-exception v2

    move-object v3, v0

    .line 784
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

    .line 787
    if-eqz v3, :cond_3

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_3
    move-object v0, v1

    .line 785
    goto :goto_0

    .line 781
    :cond_4
    :try_start_4
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    .line 782
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    move-result-object v1

    .line 787
    if-eqz v0, :cond_5

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_5
    move-object v0, v1

    .line 782
    goto :goto_0

    .line 787
    :catchall_0
    move-exception v0

    move-object v2, v0

    move-object v3, v1

    :goto_3
    if-eqz v3, :cond_6

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 788
    :cond_6
    throw v2

    .line 787
    :catchall_1
    move-exception v1

    move-object v2, v1

    move-object v3, v0

    goto :goto_3

    :catchall_2
    move-exception v0

    move-object v2, v0

    goto :goto_3

    .line 783
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
    .line 558
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->getPath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 560
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

    .line 564
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

    .line 566
    const/4 v4, 0x0

    :try_start_0
    invoke-static {v1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v1

    .line 567
    if-eqz v1, :cond_0

    .line 569
    iget v4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->windowSize:I

    invoke-static {v1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->decompressChunk([BI)[B

    move-result-object v1

    .line 570
    if-nez v1, :cond_1

    .line 571
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

    .line 579
    :catch_0
    move-exception v1

    .line 580
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

    .line 575
    :cond_1
    :try_start_1
    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, p3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 576
    :try_start_2
    invoke-virtual {v4, v1}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    .line 577
    const/4 v0, 0x1

    .line 584
    :goto_1
    return v0

    .line 576
    :catchall_0
    move-exception v1

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    throw v1
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    .line 583
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

    .line 584
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

    .line 364
    :try_start_0
    const-string v0, "\"manifests\""

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    .line 365
    if-gez v0, :cond_1

    move-object v0, v1

    .line 394
    :cond_0
    :goto_0
    return-object v0

    .line 366
    :cond_1
    const-string v2, "\"uri\""

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 367
    if-gez v0, :cond_2

    move-object v0, v1

    goto :goto_0

    .line 368
    :cond_2
    const-string v2, ":"

    add-int/lit8 v0, v0, 0x5

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 369
    if-gez v0, :cond_3

    move-object v0, v1

    goto :goto_0

    .line 370
    :cond_3
    const-string v2, "\""

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 371
    if-gez v0, :cond_4

    move-object v0, v1

    goto :goto_0

    .line 372
    :cond_4
    const-string v2, "\""

    add-int/lit8 v3, v0, 0x1

    invoke-virtual {p0, v2, v3}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 373
    if-gez v2, :cond_5

    move-object v0, v1

    goto :goto_0

    .line 374
    :cond_5
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    .line 376
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

    .line 377
    invoke-static {v2, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v0

    .line 378
    if-eqz v0, :cond_6

    array-length v3, v0

    if-gt v3, v7, :cond_0

    .line 381
    :cond_6
    const-string v0, "/Builds"

    invoke-virtual {v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    .line 382
    if-gez v0, :cond_7

    move-object v0, v1

    goto :goto_0

    .line 383
    :cond_7
    invoke-virtual {v2, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    .line 385
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_8
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_9

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    .line 386
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 387
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

    .line 388
    invoke-static {v0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v0

    .line 389
    if-eqz v0, :cond_8

    array-length v4, v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-le v4, v7, :cond_8

    goto/16 :goto_0

    .line 391
    :catch_0
    move-exception v0

    .line 392
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

    .line 394
    goto/16 :goto_0
.end method

.method private static extractQueryParams(Ljava/lang/String;I)Ljava/lang/String;
    .locals 8

    .prologue
    const/4 v1, 0x0

    .line 308
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    add-int/lit16 v2, p1, 0x7d0

    invoke-static {v0, v2}, Ljava/lang/Math;->min(II)I

    move-result v0

    .line 309
    const-string v2, "\"queryParams\""

    invoke-virtual {p0, v2, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 310
    if-ltz v2, :cond_0

    if-le v2, v0, :cond_1

    :cond_0
    const-string v0, ""

    .line 351
    :goto_0
    return-object v0

    .line 311
    :cond_1
    const-string v0, "["

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 312
    if-gez v0, :cond_2

    const-string v0, ""

    goto :goto_0

    .line 313
    :cond_2
    const-string v2, "]"

    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 314
    if-gez v2, :cond_3

    const-string v0, ""

    goto :goto_0

    .line 315
    :cond_3
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    .line 316
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, ""

    goto :goto_0

    .line 318
    :cond_4
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v0, "?"

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 319
    const/4 v2, 0x1

    move v0, v1

    .line 321
    :goto_1
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v5

    if-ge v0, v5, :cond_5

    .line 323
    const-string v5, "\"name\""

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 324
    if-gez v0, :cond_6

    .line 349
    :cond_5
    if-eqz v2, :cond_8

    const-string v0, ""

    goto :goto_0

    .line 325
    :cond_6
    const-string v5, ":"

    add-int/lit8 v0, v0, 0x6

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 326
    if-ltz v0, :cond_5

    .line 327
    const-string v5, "\""

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {v3, v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    .line 328
    if-ltz v0, :cond_5

    .line 329
    const-string v5, "\""

    add-int/lit8 v6, v0, 0x1

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 330
    if-ltz v5, :cond_5

    .line 331
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {v3, v0, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    .line 334
    const-string v6, "\"value\""

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 335
    if-ltz v5, :cond_5

    .line 336
    const-string v6, ":"

    add-int/lit8 v5, v5, 0x7

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 337
    if-ltz v5, :cond_5

    .line 338
    const-string v6, "\""

    add-int/lit8 v5, v5, 0x1

    invoke-virtual {v3, v6, v5}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 339
    if-ltz v5, :cond_5

    .line 340
    const-string v6, "\""

    add-int/lit8 v7, v5, 0x1

    invoke-virtual {v3, v6, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v6

    .line 341
    if-ltz v6, :cond_5

    .line 342
    add-int/lit8 v5, v5, 0x1

    invoke-virtual {v3, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 344
    if-nez v2, :cond_7

    const-string v2, "&"

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 345
    :cond_7
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 347
    add-int/lit8 v0, v6, 0x1

    move v2, v1

    .line 348
    goto :goto_1

    .line 349
    :cond_8
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    goto/16 :goto_0

    .line 350
    :catch_0
    move-exception v0

    .line 351
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

    .line 230
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

    .line 228
    :catch_0
    move-exception v1

    .line 229
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

    .line 230
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
    invoke-static {p0, p1, v4}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadManifest(Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)[B

    move-result-object v1

    .line 136
    if-nez v1, :cond_3

    .line 137
    const-string v1, "ERROR: manifest download failed"

    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 138
    const-string v1, "EpicDownloader"

    const-string v2, "Failed to download manifest binary"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 139
    const/4 v1, 0x0

    goto/16 :goto_0

    .line 141
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

    .line 142
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

    .line 145
    const-string v2, "Parsing manifest..."

    move-object/from16 v0, p3

    invoke-static {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 146
    invoke-static {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    move-result-object v5

    .line 147
    if-nez v5, :cond_4

    .line 148
    const-string v1, "ERROR: manifest parse failed"

    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 149
    const-string v1, "EpicDownloader"

    const-string v2, "Failed to parse manifest"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 150
    const/4 v1, 0x0

    goto/16 :goto_0

    .line 152
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

    .line 153
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " files="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    .line 154
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 152
    move-object/from16 v0, p4

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->dbg(Landroid/content/Context;Ljava/lang/String;)V

    .line 155
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

    .line 156
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " files="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    .line 157
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 155
    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 160
    new-instance v6, Ljava/io/File;

    move-object/from16 v0, p2

    invoke-direct {v6, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 161
    invoke-virtual {v6}, Ljava/io/File;->mkdirs()Z

    .line 162
    new-instance v7, Ljava/io/File;

    const-string v1, ".chunks"

    invoke-direct {v7, v6, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 163
    invoke-virtual {v7}, Ljava/io/File;->mkdirs()Z

    .line 165
    iget-object v1, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v8

    .line 166
    const/4 v1, 0x0

    .line 167
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

    .line 168
    new-instance v10, Ljava/io/File;

    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guidStr()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v10, v7, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 169
    invoke-virtual {v10}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_6

    .line 170
    if-nez v3, :cond_5

    .line 172
    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    invoke-virtual {v1, v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->getPath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    .line 173
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

    .line 174
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

    .line 176
    :cond_5
    iget-object v2, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    invoke-static {v1, v2, v4, v10}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->downloadChunk(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;Ljava/lang/String;Ljava/util/List;Ljava/io/File;)Z

    move-result v2

    if-nez v2, :cond_6

    .line 177
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

    .line 178
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

    .line 179
    const/4 v1, 0x0

    goto/16 :goto_0

    .line 182
    :cond_6
    add-int/lit8 v1, v3, 0x1

    .line 183
    rem-int/lit16 v2, v1, 0x1f4

    if-eqz v2, :cond_7

    if-ne v1, v8, :cond_8

    .line 184
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

    .line 186
    goto/16 :goto_3

    .line 189
    :cond_9
    const-string v1, "Assembling files..."

    move-object/from16 v0, p3

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V

    .line 190
    iget-object v1, v5, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v3

    .line 191
    const/4 v1, 0x0

    .line 192
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

    .line 194
    iget-object v5, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->filename:Ljava/lang/String;

    const-string v8, "\\"

    const-string v9, "/"

    invoke-virtual {v5, v8, v9}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v5

    .line 195
    new-instance v8, Ljava/io/File;

    invoke-direct {v8, v6, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 196
    invoke-virtual {v8}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v9

    .line 197
    if-eqz v9, :cond_a

    invoke-virtual {v9}, Ljava/io/File;->mkdirs()Z

    .line 199
    :cond_a
    new-instance v9, Ljava/io/FileOutputStream;

    invoke-direct {v9, v8}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 200
    new-instance v8, Ljava/io/BufferedOutputStream;

    const/high16 v10, 0x10000

    invoke-direct {v8, v9, v10}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;I)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 202
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

    .line 203
    new-instance v10, Ljava/io/File;

    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guidStr()Ljava/lang/String;

    move-result-object v11

    invoke-direct {v10, v7, v11}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 204
    invoke-virtual {v10}, Ljava/io/File;->exists()Z

    move-result v11

    if-nez v11, :cond_b

    .line 205
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 206
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

    .line 207
    const/4 v1, 0x0

    .line 213
    :try_start_3
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    goto/16 :goto_0

    .line 209
    :cond_b
    :try_start_4
    invoke-static {v10}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFile(Ljava/io/File;)[B

    move-result-object v10

    .line 210
    iget v11, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    iget v1, v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    invoke-virtual {v8, v10, v11, v1}, Ljava/io/BufferedOutputStream;->write([BII)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_5

    .line 213
    :catchall_0
    move-exception v1

    :try_start_5
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 214
    throw v1

    .line 213
    :cond_c
    invoke-virtual {v8}, Ljava/io/BufferedOutputStream;->close()V

    .line 216
    add-int/lit8 v1, v2, 0x1

    .line 217
    rem-int/lit16 v2, v1, 0xc8

    if-eqz v2, :cond_d

    if-ne v1, v3, :cond_e

    .line 218
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

    .line 220
    goto/16 :goto_4

    .line 223
    :cond_f
    invoke-static {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->deleteDir(Ljava/io/File;)V

    .line 225
    const-string v1, "EpicDownloader"

    const-string v2, "Install complete!"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_0

    .line 226
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
    .line 242
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 244
    :try_start_0
    const-string v1, "\"manifests\""

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    .line 245
    if-gez v1, :cond_1

    .line 298
    :cond_0
    :goto_0
    return-object v0

    .line 246
    :cond_1
    const-string v2, "["

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 247
    if-ltz v1, :cond_0

    .line 251
    add-int/lit8 v1, v1, 0x1

    .line 257
    :goto_1
    const-string v2, "\"uri\""

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v3

    .line 258
    if-ltz v3, :cond_0

    .line 261
    const-string v1, ":"

    add-int/lit8 v2, v3, 0x5

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 262
    if-ltz v1, :cond_0

    .line 263
    const-string v2, "\""

    add-int/lit8 v1, v1, 0x1

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    .line 264
    if-ltz v1, :cond_0

    .line 265
    const-string v2, "\""

    add-int/lit8 v4, v1, 0x1

    invoke-virtual {p0, v2, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v2

    .line 266
    if-ltz v2, :cond_0

    .line 267
    add-int/lit8 v1, v1, 0x1

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 268
    add-int/lit8 v2, v2, 0x1

    .line 271
    const-string v4, "/Builds"

    invoke-virtual {v1, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    .line 272
    if-gez v4, :cond_2

    move v1, v2

    goto :goto_1

    .line 274
    :cond_2
    const/4 v5, 0x0

    invoke-virtual {v1, v5, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 275
    const-string v6, "http"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_3

    move v1, v2

    goto :goto_1

    .line 278
    :cond_3
    const-string v6, "cloudflare.epicgamescdn.com"

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-eqz v6, :cond_4

    move v1, v2

    goto :goto_1

    .line 281
    :cond_4
    invoke-virtual {v1, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    .line 283
    const-string v4, "?"

    invoke-virtual {v1, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    .line 284
    if-ltz v4, :cond_5

    const/4 v6, 0x0

    invoke-virtual {v1, v6, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 285
    :cond_5
    const-string v4, "/"

    invoke-virtual {v1, v4}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v4

    .line 286
    if-gez v4, :cond_6

    move v1, v2

    goto :goto_1

    .line 287
    :cond_6
    const/4 v6, 0x0

    invoke-virtual {v1, v6, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    .line 291
    invoke-static {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->extractQueryParams(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v3

    .line 293
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;

    invoke-direct {v4, v5, v1, v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move v1, v2

    .line 294
    goto :goto_1

    .line 295
    :catch_0
    move-exception v1

    .line 296
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
    .line 650
    :try_start_0
    new-instance v2, Ljava/lang/String;

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    move-object/from16 v0, p0

    invoke-direct {v2, v0, v3}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    .line 651
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    .line 655
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

    .line 658
    :goto_0
    const/16 v4, 0xf

    if-lt v2, v4, :cond_0

    :try_start_2
    const-string v2, "ChunksV4"

    move-object v4, v2

    .line 663
    :goto_1
    const-string v2, "ChunkHashList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    .line 664
    const-string v2, "DataGroupList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v6

    .line 665
    const-string v2, "ChunkFilesizeList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v7

    .line 667
    if-nez v5, :cond_3

    .line 668
    const-string v2, "EpicDownloader"

    const-string v3, "JSON manifest: no ChunkHashList"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 669
    const/4 v2, 0x0

    .line 753
    :goto_2
    return-object v2

    .line 656
    :catch_0
    move-exception v2

    const/4 v2, 0x0

    goto :goto_0

    .line 659
    :cond_0
    const/4 v4, 0x6

    if-lt v2, v4, :cond_1

    const-string v2, "ChunksV3"

    move-object v4, v2

    goto :goto_1

    .line 660
    :cond_1
    const/4 v4, 0x3

    if-lt v2, v4, :cond_2

    const-string v2, "ChunksV2"

    move-object v4, v2

    goto :goto_1

    .line 661
    :cond_2
    const-string v2, "ChunksV4"

    move-object v4, v2

    goto :goto_1

    .line 673
    :cond_3
    new-instance v8, Ljava/util/LinkedHashMap;

    invoke-direct {v8}, Ljava/util/LinkedHashMap;-><init>()V

    .line 674
    invoke-virtual {v5}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v9

    .line 675
    :cond_4
    :goto_3
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_8

    .line 676
    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 677
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v10

    const/16 v11, 0x20

    if-lt v10, v11, :cond_4

    .line 678
    invoke-virtual {v5, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 680
    new-instance v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-direct {v11}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;-><init>()V

    .line 681
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

    .line 682
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

    .line 683
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

    .line 684
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

    .line 687
    if-eqz v10, :cond_5

    invoke-virtual {v10}, Ljava/lang/String;->length()I
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    move-result v12

    const/16 v13, 0x10

    if-lt v12, v13, :cond_5

    .line 689
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

    .line 693
    :cond_5
    :goto_4
    if-eqz v6, :cond_6

    .line 694
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

    .line 697
    :cond_6
    :goto_5
    if-eqz v7, :cond_7

    .line 698
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

    .line 702
    :cond_7
    :goto_6
    const/4 v10, 0x0

    :try_start_6
    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->windowSize:I

    .line 704
    invoke-interface {v8, v2, v11}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_1

    goto/16 :goto_3

    .line 751
    :catch_1
    move-exception v2

    .line 752
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

    .line 753
    const/4 v2, 0x0

    goto/16 :goto_2

    .line 690
    :catch_2
    move-exception v10

    const-wide/16 v12, 0x0

    :try_start_7
    iput-wide v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->hash:J

    goto :goto_4

    .line 695
    :catch_3
    move-exception v10

    const/4 v10, 0x0

    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->groupNum:I

    goto :goto_5

    .line 699
    :catch_4
    move-exception v10

    const-wide/16 v12, 0x0

    iput-wide v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->fileSize:J

    goto :goto_6

    .line 708
    :cond_8
    const-string v2, "FileManifestList"

    invoke-virtual {v3, v2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v5

    .line 709
    if-nez v5, :cond_9

    .line 710
    const-string v2, "EpicDownloader"

    const-string v3, "JSON manifest: no FileManifestList"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 711
    const/4 v2, 0x0

    goto/16 :goto_2

    .line 714
    :cond_9
    new-instance v6, Ljava/util/ArrayList;

    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v2

    invoke-direct {v6, v2}, Ljava/util/ArrayList;-><init>(I)V

    .line 715
    const/4 v2, 0x0

    move v3, v2

    :goto_7
    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v3, v2, :cond_c

    .line 716
    invoke-virtual {v5, v3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    .line 717
    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    invoke-direct {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;-><init>()V

    .line 718
    const-string v9, "Filename"

    const-string v10, ""

    invoke-virtual {v2, v9, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    iput-object v9, v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->filename:Ljava/lang/String;

    .line 720
    const-string v9, "FileChunkParts"

    invoke-virtual {v2, v9}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v9

    .line 721
    if-eqz v9, :cond_b

    .line 722
    const/4 v2, 0x0

    :goto_8
    invoke-virtual {v9}, Lorg/json/JSONArray;->length()I

    move-result v10

    if-ge v2, v10, :cond_b

    .line 723
    invoke-virtual {v9, v2}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v10

    .line 724
    new-instance v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;

    invoke-direct {v11}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;-><init>()V

    .line 725
    const-string v12, "Guid"

    const-string v13, ""

    invoke-virtual {v10, v12, v13}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    .line 726
    invoke-virtual {v12}, Ljava/lang/String;->length()I

    move-result v13

    const/16 v14, 0x20

    if-lt v13, v14, :cond_a

    .line 727
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

    .line 728
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

    .line 729
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

    .line 730
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

    .line 732
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

    .line 734
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

    .line 736
    :goto_a
    :try_start_a
    iget-object v10, v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->parts:Ljava/util/List;

    invoke-interface {v10, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 722
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_8

    .line 733
    :catch_5
    move-exception v12

    const/4 v12, 0x0

    iput v12, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    goto :goto_9

    .line 735
    :catch_6
    move-exception v10

    const/4 v10, 0x0

    iput v10, v11, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    goto :goto_a

    .line 739
    :cond_b
    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 715
    add-int/lit8 v2, v3, 0x1

    move v3, v2

    goto/16 :goto_7

    .line 742
    :cond_c
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    invoke-direct {v2}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;-><init>()V

    .line 743
    iput-object v4, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    .line 744
    new-instance v3, Ljava/util/ArrayList;

    invoke-interface {v8}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v5

    invoke-direct {v3, v5}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    iput-object v3, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 745
    iput-object v6, v2, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    .line 746
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

    .line 747
    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " files="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 748
    invoke-interface {v6}, Ljava/util/List;->size()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 746
    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_a
    .catch Ljava/lang/Exception; {:try_start_a .. :try_end_a} :catch_1

    goto/16 :goto_2
.end method

.method public static parseManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;
    .locals 17

    .prologue
    .line 406
    :try_start_0
    invoke-static/range {p0 .. p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 409
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 410
    const v2, 0x44bec00c

    if-eq v0, v2, :cond_0

    .line 412
    const-string v0, "EpicDownloader"

    const-string v1, "Non-binary manifest, trying JSON parser"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 413
    invoke-static/range {p0 .. p0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->parseJsonManifest([B)Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    move-result-object v0

    .line 541
    :goto_0
    return-object v0

    .line 415
    :cond_0
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v3

    .line 416
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v4

    .line 417
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    .line 418
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    add-int/lit8 v0, v0, 0x14

    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 419
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B

    move-result v0

    and-int/lit16 v5, v0, 0xff

    .line 420
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 424
    const/16 v2, 0xf

    if-lt v0, v2, :cond_1

    const-string v0, "ChunksV4"

    move-object v2, v0

    .line 430
    :goto_1
    invoke-virtual {v1, v3}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 431
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    new-array v0, v0, [B

    .line 432
    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 435
    and-int/lit8 v1, v5, 0x1

    if-eqz v1, :cond_4

    .line 436
    new-instance v1, Ljava/util/zip/Inflater;

    invoke-direct {v1}, Ljava/util/zip/Inflater;-><init>()V

    .line 437
    invoke-virtual {v1, v0}, Ljava/util/zip/Inflater;->setInput([B)V

    .line 438
    new-array v0, v4, [B

    .line 439
    invoke-virtual {v1, v0}, Ljava/util/zip/Inflater;->inflate([B)I

    move-result v3

    .line 440
    invoke-virtual {v1}, Ljava/util/zip/Inflater;->end()V

    .line 441
    if-eq v3, v4, :cond_4

    .line 442
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

    .line 443
    const/4 v0, 0x0

    goto :goto_0

    .line 425
    :cond_1
    const/4 v2, 0x6

    if-lt v0, v2, :cond_2

    const-string v0, "ChunksV3"

    move-object v2, v0

    goto :goto_1

    .line 426
    :cond_2
    const/4 v2, 0x3

    if-lt v0, v2, :cond_3

    const-string v0, "ChunksV2"

    move-object v2, v0

    goto :goto_1

    .line 427
    :cond_3
    const-string v0, "Chunks"

    move-object v2, v0

    goto :goto_1

    .line 448
    :cond_4
    invoke-static {v0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v3

    .line 451
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 452
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v1

    add-int/lit8 v1, v1, -0x4

    add-int/2addr v0, v1

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 455
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v1

    .line 456
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v4

    .line 457
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->get()B

    .line 458
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v5

    .line 460
    new-instance v6, Ljava/util/ArrayList;

    invoke-direct {v6, v5}, Ljava/util/ArrayList;-><init>(I)V

    .line 461
    const/4 v0, 0x0

    :goto_2
    if-ge v0, v5, :cond_5

    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;

    invoke-direct {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;-><init>()V

    invoke-interface {v6, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 464
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

    .line 465
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x0

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 466
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x1

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 467
    iget-object v8, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v9, 0x2

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    aput v10, v8, v9

    .line 468
    iget-object v0, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;->guid:[I

    const/4 v8, 0x3

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v9

    aput v9, v0, v8
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_3

    .line 539
    :catch_0
    move-exception v0

    .line 540
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

    .line 541
    const/4 v0, 0x0

    goto/16 :goto_0

    .line 470
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

    .line 472
    :cond_7
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    mul-int/lit8 v7, v5, 0x14

    add-int/2addr v0, v7

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 473
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

    .line 474
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

    .line 475
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

    .line 478
    :cond_a
    add-int v0, v1, v4

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 481
    new-instance v1, Ljava/util/LinkedHashMap;

    mul-int/lit8 v0, v5, 0x2

    invoke-direct {v1, v0}, Ljava/util/LinkedHashMap;-><init>(I)V

    .line 482
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

    .line 485
    :cond_b
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v4

    .line 486
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v7

    .line 487
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->get()B

    .line 488
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v8

    .line 490
    new-instance v9, Ljava/util/ArrayList;

    invoke-direct {v9, v8}, Ljava/util/ArrayList;-><init>(I)V

    .line 491
    const/4 v0, 0x0

    :goto_9
    if-ge v0, v8, :cond_c

    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;

    invoke-direct {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;-><init>()V

    invoke-interface {v9, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_9

    .line 494
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

    .line 496
    :cond_d
    const/4 v0, 0x0

    :goto_b
    if-ge v0, v8, :cond_e

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;

    add-int/lit8 v0, v0, 0x1

    goto :goto_b

    .line 498
    :cond_e
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    mul-int/lit8 v1, v8, 0x14

    add-int/2addr v0, v1

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 500
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v0

    add-int/2addr v0, v8

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 502
    const/4 v0, 0x0

    move v1, v0

    :goto_c
    if-ge v1, v8, :cond_10

    .line 503
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    .line 504
    const/4 v0, 0x0

    :goto_d
    if-ge v0, v10, :cond_f

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;

    add-int/lit8 v0, v0, 0x1

    goto :goto_d

    .line 502
    :cond_f
    add-int/lit8 v0, v1, 0x1

    move v1, v0

    goto :goto_c

    .line 507
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

    .line 508
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v10

    .line 509
    const/4 v1, 0x0

    :goto_e
    if-ge v1, v10, :cond_11

    .line 510
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->position()I

    move-result v11

    .line 511
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v12

    .line 512
    new-instance v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;

    invoke-direct {v13}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;-><init>()V

    .line 513
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x0

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 514
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x1

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 515
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x2

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 516
    iget-object v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    const/4 v15, 0x3

    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v16

    aput v16, v14, v15

    .line 517
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v14

    iput v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->offset:I

    .line 518
    invoke-virtual {v3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v14

    iput v14, v13, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->size:I

    .line 519
    iget-object v14, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;->parts:Ljava/util/List;

    invoke-interface {v14, v13}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 521
    add-int/2addr v11, v12

    invoke-virtual {v3, v11}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 509
    add-int/lit8 v1, v1, 0x1

    goto :goto_e

    .line 526
    :cond_12
    add-int v0, v4, v7

    invoke-virtual {v3, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 529
    new-instance v1, Ljava/util/LinkedHashMap;

    mul-int/lit8 v0, v5, 0x2

    invoke-direct {v1, v0}, Ljava/util/LinkedHashMap;-><init>(I)V

    .line 530
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

    .line 531
    :cond_13
    new-instance v3, Ljava/util/ArrayList;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-direct {v3, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 533
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;

    invoke-direct {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;-><init>()V

    .line 534
    iput-object v2, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    .line 535
    iput-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 536
    iput-object v9, v0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0
.end method

.method private static progress(Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;Ljava/lang/String;)V
    .locals 1

    .prologue
    .line 858
    if-eqz p0, :cond_0

    invoke-interface {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ProgressCallback;->onProgress(Ljava/lang/String;)V

    .line 859
    :cond_0
    const-string v0, "EpicDownloader"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 860
    return-void
.end method

.method public static readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;
    .locals 3

    .prologue
    .line 800
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result v0

    .line 801
    if-nez v0, :cond_0

    const-string v0, ""

    .line 812
    :goto_0
    return-object v0

    .line 802
    :cond_0
    if-gez v0, :cond_1

    .line 803
    neg-int v0, v0

    add-int/lit8 v0, v0, -0x1

    .line 804
    mul-int/lit8 v0, v0, 0x2

    new-array v1, v0, [B

    .line 805
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 806
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getShort()S

    .line 807
    new-instance v0, Ljava/lang/String;

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_16LE:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    goto :goto_0

    .line 809
    :cond_1
    add-int/lit8 v0, v0, -0x1

    new-array v1, v0, [B

    .line 810
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 811
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B

    .line 812
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
    .line 819
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 820
    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v2

    long-to-int v0, v2

    new-array v2, v0, [B

    .line 821
    const/4 v0, 0x0

    .line 822
    :goto_0
    array-length v3, v2

    if-ge v0, v3, :cond_0

    .line 823
    array-length v3, v2

    sub-int/2addr v3, v0

    invoke-virtual {v1, v2, v0, v3}, Ljava/io/FileInputStream;->read([BII)I

    move-result v3

    .line 824
    if-gez v3, :cond_1

    .line 827
    :cond_0
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V

    .line 828
    return-object v2

    .line 825
    :cond_1
    add-int/2addr v0, v3

    .line 826
    goto :goto_0
.end method
