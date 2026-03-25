.class public Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;
.super Ljava/lang/Object;
.source "EpicDownloader.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "ChunkPart"
.end annotation


# instance fields
.field public guid:[I

.field public offset:I

.field public size:I


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 70
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 71
    const/4 v0, 0x4

    new-array v0, v0, [I

    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    return-void
.end method


# virtual methods
.method public guidStr()Ljava/lang/String;
    .locals 7

    .prologue
    const/4 v6, 0x3

    const/4 v5, 0x2

    const/4 v4, 0x1

    const/4 v3, 0x0

    .line 76
    const-string v0, "%08X%08X%08X%08X"

    const/4 v1, 0x4

    new-array v1, v1, [Ljava/lang/Object;

    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    aget v2, v2, v3

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v3

    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    aget v2, v2, v4

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v4

    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    aget v2, v2, v5

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v5

    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkPart;->guid:[I

    aget v2, v2, v6

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v6

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
