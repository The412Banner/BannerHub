.class public Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;
.super Ljava/lang/Object;

# BannerHub: Static helpers for Epic Games install pipeline.
# All methods are static — no instance needed.

# Stores the last non-200 HTTP status code from downloadBytes for UI diagnostics.
# -1 means an exception was thrown (see lastError for the message).
.field public static lastHttpStatus:I
# Stores the last exception message from downloadBytes. "" if no exception.
.field public static lastError:Ljava/lang/String;
#
# Methods:
#   readAllStream(InputStream) → byte[]
#   downloadBytes(String url, String auth) → byte[]
#   decompressZlib(byte[]) → byte[]
#   readFString(ByteBuffer) → String
#   toHex8(int) → String          8-char uppercase hex
#   toHex16(long) → String        16-char uppercase hex
#   toHex2(int) → String          2-char lowercase hex
#   parseManifestDownloadUrl(String json) → String
#   parseCdnBase(String json) → String
#   parseBody(byte[] manifestBytes, EpicManifestData data) → ByteBuffer
#   parseCloudDir(String manifestUrl, String cdnBase, EpicManifestData data)
#   skipManifestMeta(ByteBuffer body)
#   parseChunkList(ByteBuffer body, EpicManifestData data) → boolean
#   parseFileList(ByteBuffer body, EpicManifestData data) → boolean
#   buildChunkUrl(String cdnBase, EpicManifestData data, int idx) → String
#   downloadAndDecompressChunk(String url, String auth) → byte[]
#   readFile(File f) → byte[]

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


# ── readAllStream ──────────────────────────────────────────────────────────────
.method public static readAllStream(Ljava/io/InputStream;)[B
    .locals 5
    new-instance v0, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V
    const/16 v1, 0x2000
    new-array v1, v1, [B
    :loop
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I
    move-result v2
    if-ltz v2, :done
    const/4 v3, 0x0
    invoke-virtual {v0, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :loop
    :done
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v0
    return-object v0
.end method


# ── downloadBytes ──────────────────────────────────────────────────────────────
# auth = "Bearer {token}" or "" for no auth header
.method public static downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B
    .locals 4
    # Clear lastError at start of each call so stale messages don't persist
    const-string v0, ""
    sput-object v0, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->lastError:Ljava/lang/String;
    :try_start
    new-instance v0, Ljava/net/URL;
    invoke-direct {v0, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v1
    check-cast v1, Ljava/net/HttpURLConnection;
    const-string v0, "GET"
    invoke-virtual {v1, v0}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V
    const/16 v0, 0x7530
    invoke-virtual {v1, v0}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v1, v0}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z
    move-result v0
    if-nez v0, :no_auth
    const-string v0, "Authorization"
    invoke-virtual {v1, v0, p1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V
    :no_auth
    const-string v0, "User-Agent"
    const-string v2, "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"
    invoke-virtual {v1, v0, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v0
    const/16 v2, 0xC8
    if-ne v0, v2, :bad
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v2
    invoke-static {v2}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->readAllStream(Ljava/io/InputStream;)[B
    move-result-object v3
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V
    return-object v3
    :bad
    # Store status code in static field so caller can include it in UI error message
    sput v0, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->lastHttpStatus:I
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_ex
    # fall-through from :bad — non-200 response, return null
    const/4 v0, 0x0
    return-object v0

    :catch_ex
    # Capture exception message into lastError; set lastHttpStatus=-1 to distinguish from HTTP 0
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    sput-object v0, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->lastError:Ljava/lang/String;
    const/16 v0, -1
    sput v0, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->lastHttpStatus:I
    const/4 v0, 0x0
    return-object v0
.end method


# ── decompressZlib ─────────────────────────────────────────────────────────────
.method public static decompressZlib([B)[B
    .locals 3
    :try_start
    new-instance v0, Ljava/io/ByteArrayInputStream;
    invoke-direct {v0, p0}, Ljava/io/ByteArrayInputStream;-><init>([B)V
    new-instance v1, Ljava/util/zip/InflaterInputStream;
    invoke-direct {v1, v0}, Ljava/util/zip/InflaterInputStream;-><init>(Ljava/io/InputStream;)V
    invoke-static {v1}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->readAllStream(Ljava/io/InputStream;)[B
    move-result-object v2
    invoke-virtual {v1}, Ljava/util/zip/InflaterInputStream;->close()V
    return-object v2
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return-object v0
.end method


# ── toHex8 ─────────────────────────────────────────────────────────────────────
# Format int as 8-char uppercase hex (left-padded with zeros).
.method public static toHex8(I)Ljava/lang/String;
    .locals 4
    invoke-static {p0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->length()I
    move-result v1
    const-string v2, "00000000"
    invoke-virtual {v2, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method


# ── toHex16 ────────────────────────────────────────────────────────────────────
# Format long as 16-char uppercase hex (left-padded with zeros).
.method public static toHex16(J)Ljava/lang/String;
    .locals 4
    invoke-static {p0, p1}, Ljava/lang/Long;->toHexString(J)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->length()I
    move-result v1
    const-string v2, "0000000000000000"
    invoke-virtual {v2, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method


# ── toHex2 ─────────────────────────────────────────────────────────────────────
# Format int as 2-char lowercase hex (for group number).
.method public static toHex2(I)Ljava/lang/String;
    .locals 3
    invoke-static {p0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->length()I
    move-result v1
    const/4 v2, 0x2
    if-ge v1, v2, :done
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "0"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    :done
    return-object v0
.end method


# ── readFString ────────────────────────────────────────────────────────────────
# Read an Epic FString from a ByteBuffer (little-endian).
# Positive length = ASCII bytes (includes null terminator).
# Negative length = UTF-16LE chars (absolute value, includes null terminator).
# Zero = empty string.
.method public static readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;
    .locals 5
    :try_start
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v0   # len
    if-eqz v0, :empty
    if-ltz v0, :utf16
    # ASCII: len bytes (includes null terminator → read len, use len-1 chars)
    new-array v1, v0, [B
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;
    add-int/lit8 v2, v0, -0x1   # len - 1
    const/4 v3, 0x0
    const-string v4, "US-ASCII"
    new-instance v0, Ljava/lang/String;
    invoke-direct {v0, v1, v3, v2, v4}, Ljava/lang/String;-><init>([BIILjava/lang/String;)V
    return-object v0
    :utf16
    neg-int v0, v0               # charCount (includes null)
    mul-int/lit8 v1, v0, 0x2     # byte count
    new-array v1, v1, [B
    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;
    add-int/lit8 v2, v0, -0x1    # charCount - 1
    mul-int/lit8 v2, v2, 0x2     # byte count without null
    const/4 v3, 0x0
    const-string v4, "UTF-16LE"
    new-instance v0, Ljava/lang/String;
    invoke-direct {v0, v1, v3, v2, v4}, Ljava/lang/String;-><init>([BIILjava/lang/String;)V
    return-object v0
    :empty
    const-string v0, ""
    return-object v0
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :err
    :err
    const-string v0, ""
    return-object v0
.end method


# ── parseManifestDownloadUrl ───────────────────────────────────────────────────
# Extract "uri" value + build query string from "queryParams" array.
# Returns full signed manifest URL, or "" on failure.
#
# Register map (.locals 13):
#   v0  = cursor pos (reused)
#   v1  = temp int (end pos, length, etc.)
#   v2  = temp String
#   v3  = uriBase String
#   v4  = queryParamsEnd pos
#   v5  = StringBuilder (query string accumulator)
#   v6  = firstParam flag (0=first, 1=not first)
#   v7  = paramName String
#   v8  = nameKeyStart cursor
#   v9  = const "\"name\"" (length 6)
#   v10 = const "\"value\"" (length 7)
#   v11 = const "\"" (quote)
#   v12 = const int for key lengths
.method public static parseManifestDownloadUrl(Ljava/lang/String;)Ljava/lang/String;
    .locals 13
    # ── Extract "uri" value ────────────────────────────────────────────────
    const-string v9, "\"uri\""
    const/4 v0, 0x0
    invoke-virtual {p0, v9, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :fail
    invoke-virtual {v9}, Ljava/lang/String;->length()I
    move-result v1
    add-int v0, v0, v1       # advance past "uri" key
    const-string v11, "\""
    invoke-virtual {p0, v11, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :fail
    add-int/lit8 v0, v0, 0x1   # past opening quote
    invoke-virtual {p0, v11, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v1
    if-ltz v1, :fail
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v3   # v3 = uriBase

    # ── Find queryParams array bounds ──────────────────────────────────────
    const-string v9, "\"queryParams\""
    const/4 v0, 0x0
    invoke-virtual {p0, v9, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :no_params

    # Find opening [
    const-string v2, "["
    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :no_params

    # Find closing ]
    const-string v2, "]"
    invoke-virtual {p0, v2, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v4   # v4 = queryParamsEnd
    if-ltz v4, :no_params

    # ── Build query string from name/value pairs ───────────────────────────
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const/4 v6, 0x0   # firstParam = true (0)
    const-string v9, "\"name\""
    const-string v10, "\"value\""
    # cursor v8 starts just after the [ bracket
    add-int/lit8 v8, v0, 0x1

    :param_loop
    invoke-virtual {p0, v9, v8}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :params_done
    if-ge v0, v4, :params_done
    # advance past "name" key
    invoke-virtual {v9}, Ljava/lang/String;->length()I
    move-result v1
    add-int v0, v0, v1
    # find opening quote of name value
    invoke-virtual {p0, v11, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :params_done
    add-int/lit8 v0, v0, 0x1
    # find closing quote
    invoke-virtual {p0, v11, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v1
    if-ltz v1, :params_done
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v7   # v7 = paramName

    # now find "value" key after v1
    invoke-virtual {p0, v10, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :params_done
    if-ge v0, v4, :params_done
    invoke-virtual {v10}, Ljava/lang/String;->length()I
    move-result v1
    add-int v0, v0, v1
    invoke-virtual {p0, v11, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v0
    if-ltz v0, :params_done
    add-int/lit8 v0, v0, 0x1
    invoke-virtual {p0, v11, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v1
    if-ltz v1, :params_done
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v2   # v2 = paramValue
    # advance cursor past this value
    add-int/lit8 v8, v1, 0x1

    # append to query string
    if-eqz v6, :not_first
    const-string v12, "&"
    invoke-virtual {v5, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :not_first
    const/4 v6, 0x1   # firstParam = false
    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v12, "="
    invoke-virtual {v5, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :param_loop

    :params_done
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1   # query string
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v0
    if-nez v0, :no_params
    # return uriBase + "?" + queryString
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v2, "?"
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0

    :no_params
    return-object v3    # just return uri with no query params
    :fail
    const-string v0, ""
    return-object v0
.end method


# ── parseCdnBase ───────────────────────────────────────────────────────────────
# Find first non-Cloudflare URL in cdnList array. Returns "" on failure.
.method public static parseCdnBase(Ljava/lang/String;)Ljava/lang/String;
    .locals 8
    const-string v0, "\"cdnList\""
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v1
    if-ltz v1, :fail
    const-string v0, "]"
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v2   # end of cdnList array
    if-ltz v2, :fail
    const-string v3, "\"url\""
    const-string v4, "\""
    const-string v5, "cloudflare"
    :url_loop
    invoke-virtual {p0, v3, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v6
    if-ltz v6, :fail
    if-ge v6, v2, :fail
    invoke-virtual {v3}, Ljava/lang/String;->length()I
    move-result v7
    add-int v6, v6, v7
    invoke-virtual {p0, v4, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v6
    if-ltz v6, :fail
    add-int/lit8 v6, v6, 0x1
    invoke-virtual {p0, v4, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v7
    if-ltz v7, :fail
    invoke-virtual {p0, v6, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v6   # candidate URL
    invoke-virtual {v6, v5}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :url_loop   # skip cloudflare
    return-object v6
    :fail
    const-string v0, ""
    return-object v0
.end method


# ── parseBody ──────────────────────────────────────────────────────────────────
# Parse binary manifest header (41 bytes), decompress body if storedAs & 1,
# store manifestVersion + chunkDir in data. Returns ByteBuffer over body, or null.
#
# Header layout:
#   0: magic uint32 (0x44BEC00C)
#   4: header_size uint32
#   8: size_compressed uint32
#  12: size_uncompressed uint32
#  16: sha_hash 20 bytes
#  36: stored_as uint8
#  37: version uint32 (manifest feature level)
.method public static parseBody([BLcom/xj/landscape/launcher/ui/menu/EpicManifestData;)Ljava/nio/ByteBuffer;
    .locals 9
    :try_start
    # Wrap bytes in little-endian ByteBuffer
    invoke-static {p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;
    move-result-object v0
    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;
    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    # Read header fields
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I   # magic (skip verify)
    move-result v1
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v2   # headerSize
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v3   # sizeCompressed
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I   # sizeUncompressed
    move-result v4

    # Seek to stored_as byte at offset 36 (skip SHA1: 20 bytes from pos 16)
    const/16 v5, 0x24   # 36
    invoke-virtual {v0, v5}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/ByteBuffer;
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->get()B
    move-result v5
    shl-int/lit8 v5, v5, 0x18
    ushr-int/lit8 v5, v5, 0x18   # zero-extend byte → stored_as (0-255)

    # Read version (manifest feature level) at offset 37
    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v6   # version

    # Store manifestVersion + compute chunkDir
    iput v6, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->manifestVersion:I
    const/16 v7, 0xF   # 15
    if-lt v6, v7, :not_v4
    const-string v7, "ChunksV4"
    iput-object v7, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkDir:Ljava/lang/String;
    goto :dir_done
    :not_v4
    const/4 v7, 0x6
    if-lt v6, v7, :not_v3
    const-string v7, "ChunksV3"
    iput-object v7, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkDir:Ljava/lang/String;
    goto :dir_done
    :not_v3
    const/4 v7, 0x3
    if-lt v6, v7, :not_v2
    const-string v7, "ChunksV2"
    iput-object v7, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkDir:Ljava/lang/String;
    goto :dir_done
    :not_v2
    const-string v7, "Chunks"
    iput-object v7, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkDir:Ljava/lang/String;
    :dir_done

    # Seek to body start (at headerSize)
    invoke-virtual {v0, v2}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/ByteBuffer;

    # Extract body bytes (sizeCompressed bytes)
    new-array v7, v3, [B
    invoke-virtual {v0, v7}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    # Decompress if needed (storedAs & 1)
    and-int/lit8 v8, v5, 0x1
    if-eqz v8, :no_decomp
    invoke-static {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->decompressZlib([B)[B
    move-result-object v7
    if-eqz v7, :fail
    :no_decomp

    # Wrap body in little-endian ByteBuffer and return
    invoke-static {v7}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;
    move-result-object v7
    sget-object v8, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;
    invoke-virtual {v7, v8}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;
    return-object v7
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return-object v0
.end method


# ── parseCloudDir ──────────────────────────────────────────────────────────────
# Extract cloud directory from manifest URL by stripping cdnBase and filename.
# e.g. "https://cdn.net/Builds/Game/CloudDir/file.manifest?X=Y" + "https://cdn.net"
#    → "/Builds/Game/CloudDir/"
.method public static parseCloudDir(Ljava/lang/String;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;)V
    .locals 4
    # Strip cdnBase prefix from manifestUrl
    invoke-virtual {p1}, Ljava/lang/String;->length()I
    move-result v0   # cdnBase length
    invoke-virtual {p0}, Ljava/lang/String;->length()I
    move-result v1
    if-ge v0, v1, :fail
    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v0   # path part: "/Builds/Game/CloudDir/file.manifest?..."
    # Strip query params: find ? and cut
    const-string v1, "?"
    invoke-virtual {v0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I
    move-result v1
    if-ltz v1, :no_query
    const/4 v2, 0x0
    invoke-virtual {v0, v2, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v0
    :no_query
    # Find last slash and keep everything up to and including it
    const-string v1, "/"
    invoke-virtual {v0, v1}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I
    move-result v1
    if-ltz v1, :fail
    add-int/lit8 v1, v1, 0x1   # include the slash
    const/4 v2, 0x0
    invoke-virtual {v0, v2, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v0   # cloudDir = "/Builds/Game/CloudDir/"
    iput-object v0, p2, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->cloudDir:Ljava/lang/String;
    return-void
    :fail
    const-string v0, "/"
    iput-object v0, p2, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->cloudDir:Ljava/lang/String;
    return-void
.end method


# ── skipManifestMeta ───────────────────────────────────────────────────────────
# Read the ManifestMeta section size and skip past it.
.method public static skipManifestMeta(Ljava/nio/ByteBuffer;)V
    .locals 2
    :try_start
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v0   # section size (includes the size field itself = 4 bytes)
    add-int/lit8 v1, v0, -0x4   # remaining bytes after size field
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->position()I
    move-result v0
    add-int v0, v0, v1
    invoke-virtual {p0, v0}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/ByteBuffer;
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :done
    :done
    return-void
.end method


# ── parseChunkList ─────────────────────────────────────────────────────────────
# Parse the ChunkDataList section from body ByteBuffer.
# Columnar format: all GUIDs → all hashes → all SHAs → all groupNums → all windowSizes → all fileSizes
# Fills data.chunkCount, chunkGuidHex[], chunkHashes[], chunkGroupNums[].
# Returns true on success.
#
# Register map (.locals 11):
#   v0 = chunkCount
#   v1 = loop index i
#   v2 = chunkGuidHex String[]
#   v3 = chunkHashes long[]
#   v4 = chunkGroupNums int[]
#   v5, v6, v7, v8 = GUID ints (g1-g4)
#   v9 = temp String / StringBuilder
#   v10 = temp long (hash) — wide pair v10:v11
.method public static parseChunkList(Ljava/nio/ByteBuffer;Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;)Z
    .locals 12
    :try_start
    # Read section size (uint32) + data version (uint8) then chunk count
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I   # section size, ignore
    move-result v9
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B      # data version, ignore
    move-result v9
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v0   # chunkCount

    iput v0, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkCount:I

    # Allocate arrays
    new-array v2, v0, [Ljava/lang/String;
    new-array v3, v0, [J
    new-array v4, v0, [I
    iput-object v2, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkGuidHex:[Ljava/lang/String;
    iput-object v3, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkHashes:[J
    iput-object v4, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkGroupNums:[I

    # ── Read GUIDs (columnar) ─────────────────────────────────────────────
    const/4 v1, 0x0
    :guid_loop
    if-ge v1, v0, :guid_done
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v5
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v6
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v7
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v8
    # Build 32-char uppercase hex string from 4 ints
    new-instance v9, Ljava/lang/StringBuilder;
    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V
    invoke-static {v5}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex8(I)Ljava/lang/String;
    move-result-object v11
    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v6}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex8(I)Ljava/lang/String;
    move-result-object v11
    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v7}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex8(I)Ljava/lang/String;
    move-result-object v11
    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v8}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex8(I)Ljava/lang/String;
    move-result-object v11
    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v9
    aput-object v9, v2, v1
    add-int/lit8 v1, v1, 0x1
    goto :guid_loop
    :guid_done

    # ── Read hashes (columnar, uint64 each) ───────────────────────────────
    const/4 v1, 0x0
    :hash_loop
    if-ge v1, v0, :hash_done
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getLong()J
    move-result-wide v10
    aput-wide v10, v3, v1
    add-int/lit8 v1, v1, 0x1
    goto :hash_loop
    :hash_done

    # ── Skip SHA hashes (columnar, 20 bytes each) ─────────────────────────
    mul-int/lit8 v5, v0, 0x14   # count * 20
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->position()I
    move-result v6
    add-int v5, v5, v6
    invoke-virtual {p0, v5}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/ByteBuffer;

    # ── Read group numbers (columnar, uint8 each) ─────────────────────────
    const/4 v1, 0x0
    :grp_loop
    if-ge v1, v0, :grp_done
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B
    move-result v5
    shl-int/lit8 v5, v5, 0x18
    ushr-int/lit8 v5, v5, 0x18   # zero-extend byte → groupNum (0-255)
    aput v5, v4, v1
    add-int/lit8 v1, v1, 0x1
    goto :grp_loop
    :grp_done

    # ── Skip window sizes (columnar, uint32 each) ─────────────────────────
    mul-int/lit8 v5, v0, 0x4
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->position()I
    move-result v6
    add-int v5, v5, v6
    invoke-virtual {p0, v5}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/ByteBuffer;

    # ── Skip file sizes (columnar, int64 each) ────────────────────────────
    mul-int/lit8 v5, v0, 0x8
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->position()I
    move-result v6
    add-int v5, v5, v6
    invoke-virtual {p0, v5}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/ByteBuffer;

    const/4 v0, 0x1
    return v0
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return v0
.end method


# ── parseFileList ──────────────────────────────────────────────────────────────
# Parse the FileManifestList section.
# For each file, reads filename + chunk parts, stores packed part data.
# filePartData[f] = "chunkIdx:chunkOffset:partSize[;...]"
# Returns true on success.
#
# Register map (.locals 14):
# p0=v14 (ByteBuffer), p1=v15 (EpicManifestData) — both ≤ v15
#   v0  = fileCount
#   v1  = f (file loop index)
#   v2  = fileNames String[]
#   v3  = filePartData String[]
#   v4  = guidHex (String after GUID build)
#   v5  = part data StringBuilder
#   v6  = partCount / tagCount
#   v7  = p (part loop index)
#   v8,v9,v10,v11 = GUID ints g1-g4; reused as chunkOffset, partSize, searchIdx, chunkCount
#   v12 = chunkGuidHex[] array
#   v13 = temp (pos seek, GUID hex temps, search element/bool)
.method public static parseFileList(Ljava/nio/ByteBuffer;Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;)Z
    .locals 14
    :try_start
    # Read section size + data version + file count
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v12   # section size, discard
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B
    move-result v12   # data version, discard
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v0   # fileCount

    iput v0, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->fileCount:I
    new-array v2, v0, [Ljava/lang/String;
    new-array v3, v0, [Ljava/lang/String;
    iput-object v2, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->fileNames:[Ljava/lang/String;
    iput-object v3, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->filePartData:[Ljava/lang/String;

    iget-object v12, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkGuidHex:[Ljava/lang/String;
    # v12 = chunkGuidHex array for GUID lookup

    const/4 v1, 0x0
    :file_loop
    if-ge v1, v0, :file_done

    # filename (FString)
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;
    move-result-object v4
    aput-object v4, v2, v1

    # symlink_target (FString, discard)
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;
    move-result-object v4   # discard

    # Skip file_hash (20 bytes) + flags (1 byte)
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->position()I
    move-result v13
    add-int/lit8 v13, v13, 0x15   # 20 + 1 = 21 (0x15)
    invoke-virtual {p0, v13}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/ByteBuffer;

    # Install tags array (count + FStrings, skip)
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v6   # tagCount
    const/4 v7, 0x0
    :tag_loop
    if-ge v7, v6, :tag_done
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->readFString(Ljava/nio/ByteBuffer;)Ljava/lang/String;
    move-result-object v4   # discard
    add-int/lit8 v7, v7, 0x1
    goto :tag_loop
    :tag_done

    # Chunk parts
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v6   # partCount

    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const/4 v7, 0x0

    :part_loop
    if-ge v7, v6, :part_done

    # Read GUID (4 × uint32)
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v8
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v9
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v10
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v11

    # Build guidHex for lookup
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    invoke-static {v8}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex8(I)Ljava/lang/String;
    move-result-object v13
    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v9}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex8(I)Ljava/lang/String;
    move-result-object v13
    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v10}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex8(I)Ljava/lang/String;
    move-result-object v13
    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v11}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex8(I)Ljava/lang/String;
    move-result-object v13
    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4   # v4 = guidHex

    # Read chunkOffset → v8, partSize → v9 (GUID words v8-v11 are now free)
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v8   # chunkOffset
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I
    move-result v9   # partSize

    # Find chunkIdx: v10=searchIdx, v11=chunkCount, v13=element/bool
    const/4 v10, 0x0
    array-length v11, v12
    :search_loop
    if-ge v10, v11, :search_done
    aget-object v13, v12, v10
    invoke-virtual {v13, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v13
    if-nez v13, :search_done
    add-int/lit8 v10, v10, 0x1
    goto :search_loop
    :search_done
    # v10 = chunkIdx (or array-length if not found)
    array-length v11, v12
    if-ne v10, v11, :idx_ok
    const/4 v10, -0x1   # not found
    :idx_ok

    # Append ";chunkIdx:chunkOffset:partSize" — v10=idx, v8=offset, v9=size, v11=tmp
    if-eqz v7, :first_part
    const-string v11, ";"
    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :first_part
    invoke-static {v10}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v11
    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v11, ":"
    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v8}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v11
    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v11, ":"
    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v9}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
    move-result-object v11
    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v7, v7, 0x1
    goto :part_loop

    :part_done
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    aput-object v4, v3, v1

    add-int/lit8 v1, v1, 0x1
    goto :file_loop

    :file_done
    const/4 v0, 0x1
    return v0
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return v0
.end method


# ── buildChunkUrl ──────────────────────────────────────────────────────────────
# Build the full CDN URL for chunk at index idx.
# Format: {cdnBase}{cloudDir}{chunkDir}/{groupHex2}/{hash16}_{guid32}.chunk
.method public static buildChunkUrl(Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;I)Ljava/lang/String;
    .locals 9
    iget-object v0, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->cloudDir:Ljava/lang/String;
    iget-object v1, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkDir:Ljava/lang/String;
    iget-object v2, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkGroupNums:[I
    iget-object v3, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkHashes:[J
    iget-object v4, p1, Lcom/xj/landscape/launcher/ui/menu/EpicManifestData;->chunkGuidHex:[Ljava/lang/String;
    aget v5, v2, p2           # groupNum
    aget-wide v6, v3, p2      # hash (wide)
    aget-object v8, v4, p2    # guidHex String
    invoke-static {v5}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex2(I)Ljava/lang/String;
    move-result-object v5     # groupHex2
    invoke-static {v6, v7}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->toHex16(J)Ljava/lang/String;
    move-result-object v6     # hash16
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, "/"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, "_"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, ".chunk"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method


# ── downloadAndDecompressChunk ─────────────────────────────────────────────────
# Download a .chunk file, parse its header, and decompress body if flags & 1.
# Returns raw (decompressed if needed) chunk body bytes, or null on failure.
#
# Chunk header layout:
#   0: magic uint32 (0xB1FE3AA2)
#   4: version uint32
#   8: header_size uint32  ← data starts here
#  12: data_size uint32 (uncompressed)
#  16: guid 16 bytes
#  32: rolling_hash uint64
#  40: sha_hash 20 bytes
#  60: hash_type uint8
#  61: flags uint8  ← bit 0 = zlib
.method public static downloadAndDecompressChunk(Ljava/lang/String;Ljava/lang/String;)[B
    .locals 7
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->downloadBytes(Ljava/lang/String;Ljava/lang/String;)[B
    move-result-object v0
    if-eqz v0, :fail
    :try_start
    invoke-static {v0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;
    move-result-object v1
    sget-object v2, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;
    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;
    # Read header fields
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I   # magic, skip
    move-result v2
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I   # version, skip
    move-result v2
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I   # headerSize
    move-result v3
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->getInt()I   # dataSize (uncompressed)
    move-result v4
    # Seek to flags byte at offset 61
    const/16 v5, 0x3D   # 61
    invoke-virtual {v1, v5}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/ByteBuffer;
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B
    move-result v2   # hash_type, ignore
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->get()B
    move-result v5   # flags
    shl-int/lit8 v5, v5, 0x18
    ushr-int/lit8 v5, v5, 0x18   # zero-extend byte → flags (0-255)
    # Seek to data start (at headerSize) and extract
    invoke-virtual {v1, v3}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/ByteBuffer;
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->remaining()I
    move-result v6
    new-array v2, v6, [B
    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;
    # Decompress if flags & 1
    and-int/lit8 v3, v5, 0x1
    if-eqz v3, :no_decomp
    invoke-static {v2}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->decompressZlib([B)[B
    move-result-object v2
    :no_decomp
    return-object v2
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return-object v0
.end method


# ── readFile ───────────────────────────────────────────────────────────────────
# Read all bytes from a File into a byte[]. Returns null on failure.
.method public static readFile(Ljava/io/File;)[B
    .locals 3
    :try_start
    new-instance v0, Ljava/io/FileInputStream;
    invoke-direct {v0, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/EpicInstallHelper;->readAllStream(Ljava/io/InputStream;)[B
    move-result-object v1
    invoke-virtual {v0}, Ljava/io/FileInputStream;->close()V
    return-object v1
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return-object v0
.end method
