.class public Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;
.super Ljava/lang/Object;
.source "EpicDownloader.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "ParsedManifest"
.end annotation


# instance fields
.field public chunkDir:Ljava/lang/String;

.field public files:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$FileInfo;",
            ">;"
        }
    .end annotation
.end field

.field public uniqueChunks:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ChunkInfo;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 90
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 91
    const-string v0, "ChunksV4"

    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->chunkDir:Ljava/lang/String;

    .line 92
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->uniqueChunks:Ljava/util/List;

    .line 93
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$ParsedManifest;->files:Ljava/util/List;

    return-void
.end method
