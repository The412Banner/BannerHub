.class public Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;
.super Ljava/lang/Object;

# BannerHub: Parsed Epic binary manifest holder.
# Populated by EpicInstallHelper.parseChunkList() and parseFileList().

# Chunk list (parallel arrays, indexed 0..chunkCount-1)
.field public chunkCount:I
.field public chunkGuidHex:[Ljava/lang/String;   # 32-char uppercase hex per chunk
.field public chunkHashes:[J                      # rolling hash (uint64) per chunk
.field public chunkGroupNums:[I                   # 0-255 group number per chunk

# File list (parallel arrays, indexed 0..fileCount-1)
.field public fileCount:I
.field public fileNames:[Ljava/lang/String;        # Windows-style path (may contain \)
# filePartData[f] = semicolon-separated "chunkIdx:chunkOffset:size" per chunk part
.field public filePartData:[Ljava/lang/String;

# Manifest metadata (set by parseBody)
.field public manifestVersion:I   # feature level from header
.field public cloudDir:Ljava/lang/String;   # "/Builds/Game/CloudDir/" (trailing slash)
.field public chunkDir:Ljava/lang/String;   # "Chunks", "ChunksV2", "ChunksV3", "ChunksV4"
.field public queryString:Ljava/lang/String;   # "?cf_token=..." query from manifest URL; appended to chunk URLs for CDN auth


.method public constructor <init>()V
    .locals 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    const-string v0, ""
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->cloudDir:Ljava/lang/String;
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkDir:Ljava/lang/String;
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->queryString:Ljava/lang/String;
    return-void
.end method
