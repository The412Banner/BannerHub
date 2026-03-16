.class public final Lcom/xj/landscape/launcher/ui/menu/WcpExtractor;
.super Ljava/lang/Object;

# Uses classes already built into GameHub's APK — no external dex injection needed.
#
# ZstdInputStreamNoFinalizer  (com.github.luben.zstd) — NOT obfuscated (JNI class, @Keep)
#   constructor: <init>(Ljava/io/InputStream;)V
#
# XZInputStream  (org.tukaani.xz) — NOT obfuscated
#   constructor: <init>(Ljava/io/InputStream;I)V  [I = memory limit, -1 = unlimited]
#
# TarArchiveInputStream  (org.apache.commons.compress.archivers.tar) — OBFUSCATED
#   constructor: <init>(Ljava/io/InputStream;)V  [kept]
#   getNextTarEntry() → obfuscated as s() (verified: getNextEntry bridge calls s())
#   read([BII)I  [kept]
#   close()V     [kept]
#
# TarArchiveEntry — OBFUSCATED
#   getName()Ljava/lang/String;  [kept — from ArchiveEntry interface]
#   isDirectory() is obfuscated; detect directories by getName().endsWith("/") instead

.method public static extract(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/io/File;)V
    .locals 9
    # p0=ContentResolver  p1=Uri  p2=destDir

    # Clear and recreate destDir before injection
    invoke-static {p2}, Lcom/xj/landscape/launcher/ui/menu/WcpExtractor;->clearDir(Ljava/io/File;)V
    invoke-virtual {p2}, Ljava/io/File;->mkdirs()Z

    # v0 = raw InputStream from SAF
    invoke-virtual {p0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;
    move-result-object v0

    # v1 = BufferedInputStream (supports mark/reset for format detection)
    new-instance v1, Ljava/io/BufferedInputStream;
    invoke-direct {v1, v0}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    # v2 = header byte[4]
    const/4 v2, 0x4
    new-array v2, v2, [B

    # Mark 4 bytes, read header, reset to beginning
    const/4 v3, 0x4
    invoke-virtual {v1, v3}, Ljava/io/BufferedInputStream;->mark(I)V
    const/4 v3, 0x0
    const/4 v4, 0x4
    invoke-virtual {v1, v2, v3, v4}, Ljava/io/InputStream;->read([BII)I
    invoke-virtual {v1}, Ljava/io/BufferedInputStream;->reset()V

    # Load header bytes (sign-extended ints)
    const/4 v3, 0x0
    aget-byte v4, v2, v3
    const/4 v3, 0x1
    aget-byte v5, v2, v3
    const/4 v3, 0x2
    aget-byte v6, v2, v3
    const/4 v3, 0x3
    aget-byte v7, v2, v3

    # ── ZIP: magic 0x50 0x4B ────────────────────────────────────────────────
    const/16 v3, 0x50
    if-ne v4, v3, :not_zip
    const/16 v3, 0x4B
    if-ne v5, v3, :not_zip

    invoke-static {v1, p2}, Lcom/xj/landscape/launcher/ui/menu/WcpExtractor;->extractZip(Ljava/io/InputStream;Ljava/io/File;)V
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    return-void

    # ── zstd tar: magic 0x28 0xB5(-75) 0x2F 0xFD(-3) ───────────────────────
    :not_zip
    const/16 v3, 0x28
    if-ne v4, v3, :not_zstd
    const/16 v3, -0x4B
    if-ne v5, v3, :not_zstd
    const/16 v3, 0x2F
    if-ne v6, v3, :not_zstd
    const/4 v3, -0x3
    if-ne v7, v3, :not_zstd

    new-instance v8, Lcom/github/luben/zstd/ZstdInputStreamNoFinalizer;
    invoke-direct {v8, v1}, Lcom/github/luben/zstd/ZstdInputStreamNoFinalizer;-><init>(Ljava/io/InputStream;)V
    invoke-static {v8, p2}, Lcom/xj/landscape/launcher/ui/menu/WcpExtractor;->extractTar(Ljava/io/InputStream;Ljava/io/File;)V
    invoke-virtual {v8}, Ljava/io/InputStream;->close()V
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    return-void

    # ── XZ tar: magic 0xFD(-3) 0x37 0x7A 0x58 ──────────────────────────────
    :not_zstd
    const/4 v3, -0x3
    if-ne v4, v3, :unknown_format
    const/16 v3, 0x37
    if-ne v5, v3, :unknown_format
    const/16 v3, 0x7A
    if-ne v6, v3, :unknown_format
    const/16 v3, 0x58
    if-ne v7, v3, :unknown_format

    new-instance v8, Lorg/tukaani/xz/XZInputStream;
    const/4 v3, -0x1    # memory limit = -1 (unlimited)
    invoke-direct {v8, v1, v3}, Lorg/tukaani/xz/XZInputStream;-><init>(Ljava/io/InputStream;I)V
    invoke-static {v8, p2}, Lcom/xj/landscape/launcher/ui/menu/WcpExtractor;->extractTar(Ljava/io/InputStream;Ljava/io/File;)V
    invoke-virtual {v8}, Ljava/io/InputStream;->close()V
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    return-void

    :unknown_format
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    new-instance v3, Ljava/lang/Exception;
    const-string v4, "Unknown format (not ZIP/zstd/XZ)"
    invoke-direct {v3, v4}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V
    throw v3

.end method

# ── Recursively delete all contents of dir (keep dir itself) ────────────────
.method private static clearDir(Ljava/io/File;)V
    .locals 5

    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v0
    if-eqz v0, :done

    array-length v1, v0
    const/4 v2, 0x0

    :loop
    if-ge v2, v1, :done
    aget-object v3, v0, v2
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z
    move-result v4
    if-eqz v4, :del_file

    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/WcpExtractor;->clearDir(Ljava/io/File;)V
    invoke-virtual {v3}, Ljava/io/File;->delete()Z
    goto :next

    :del_file
    invoke-virtual {v3}, Ljava/io/File;->delete()Z

    :next
    add-int/lit8 v2, v2, 0x1
    goto :loop

    :done
    return-void

.end method

# ── ZIP extraction: flat (basename only) — for Turnip / adrenotools ─────────
.method private static extractZip(Ljava/io/InputStream;Ljava/io/File;)V
    .locals 7

    new-instance v0, Ljava/util/zip/ZipInputStream;
    invoke-direct {v0, p0}, Ljava/util/zip/ZipInputStream;-><init>(Ljava/io/InputStream;)V

    const/16 v2, 0x2000
    new-array v2, v2, [B

    :zip_loop
    invoke-virtual {v0}, Ljava/util/zip/ZipInputStream;->getNextEntry()Ljava/util/zip/ZipEntry;
    move-result-object v1
    if-eqz v1, :zip_done

    invoke-virtual {v1}, Ljava/util/zip/ZipEntry;->isDirectory()Z
    move-result v3
    if-nez v3, :zip_skip

    # Flatten: get basename only (same as BCI)
    invoke-virtual {v1}, Ljava/util/zip/ZipEntry;->getName()Ljava/lang/String;
    move-result-object v4
    new-instance v5, Ljava/io/File;
    invoke-direct {v5, v4}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v5}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v4

    new-instance v5, Ljava/io/File;
    invoke-direct {v5, p1, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    new-instance v6, Ljava/io/FileOutputStream;
    invoke-direct {v6, v5}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    :zip_read_loop
    invoke-virtual {v0, v2}, Ljava/io/InputStream;->read([B)I
    move-result v3
    if-lez v3, :zip_read_done
    const/4 v4, 0x0
    invoke-virtual {v6, v2, v4, v3}, Ljava/io/OutputStream;->write([BII)V
    goto :zip_read_loop

    :zip_read_done
    invoke-virtual {v6}, Ljava/io/OutputStream;->close()V

    :zip_skip
    invoke-virtual {v0}, Ljava/util/zip/ZipInputStream;->closeEntry()V
    goto :zip_loop

    :zip_done
    invoke-virtual {v0}, Ljava/util/zip/ZipInputStream;->close()V
    return-void

.end method

# ── Tar extraction (decompressed stream already provided) ────────────────────
# Reads profile.json to detect FEXCore (flattenToRoot).
# FEXCore  → files go to component root (flat)
# Others   → preserve system32/syswow64 directory structure
#
# TarArchiveInputStream method names (obfuscated in GameHub's dex):
#   getNextTarEntry() → s()   (getNextEntry bridge delegates to s())
#   read([BII)I       → read([BII)I  (kept)
#   close()V          → close()V     (kept)
#
# TarArchiveEntry:
#   getName() → getName()  (kept, from ArchiveEntry interface)
#   isDirectory() is obfuscated — detect via getName().endsWith("/")
.method private static extractTar(Ljava/io/InputStream;Ljava/io/File;)V
    .locals 11
    # p0 = decompressed InputStream   p1 = destDir File

    # v0 = TarArchiveInputStream
    new-instance v0, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;
    invoke-direct {v0, p0}, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;-><init>(Ljava/io/InputStream;)V

    # v1 = flattenToRoot (0=false)
    const/4 v1, 0x0

    # v2 = read buffer
    const/16 v2, 0x2000
    new-array v2, v2, [B

    :tar_loop
    # v3 = next entry via obfuscated s() = getNextTarEntry()
    invoke-virtual {v0}, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;->s()Lorg/apache/commons/compress/archivers/tar/TarArchiveEntry;
    move-result-object v3
    if-eqz v3, :tar_done

    # v4 = entry name
    invoke-virtual {v3}, Lorg/apache/commons/compress/archivers/tar/TarArchiveEntry;->getName()Ljava/lang/String;
    move-result-object v4

    # Skip directories: tar directories have names ending with "/"
    const-string v5, "/"
    invoke-virtual {v4, v5}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v5
    if-nez v5, :tar_loop

    # Check for profile.json to detect FEXCore
    const-string v5, "profile.json"
    invoke-virtual {v4, v5}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v5
    if-eqz v5, :not_profile

    # Read profile.json and check for "FEXCore"
    new-instance v6, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v6}, Ljava/io/ByteArrayOutputStream;-><init>()V

    :profile_read_loop
    invoke-virtual {v0, v2}, Ljava/io/InputStream;->read([B)I
    move-result v5
    if-lez v5, :profile_read_done
    const/4 v7, 0x0
    invoke-virtual {v6, v2, v7, v5}, Ljava/io/OutputStream;->write([BII)V
    goto :profile_read_loop

    :profile_read_done
    invoke-virtual {v6}, Ljava/io/ByteArrayOutputStream;->toString()Ljava/lang/String;
    move-result-object v7
    const-string v5, "FEXCore"
    invoke-virtual {v7, v5}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v5
    if-eqz v5, :tar_loop
    const/4 v1, 0x1
    goto :tar_loop

    :not_profile
    # Strip leading "./" from entry name
    const-string v5, "./"
    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v5
    if-eqz v5, :no_strip
    const/4 v5, 0x2
    invoke-virtual {v4, v5}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v4

    :no_strip
    if-eqz v1, :preserve_path

    # flattenToRoot: use just the basename (FEXCore)
    new-instance v9, Ljava/io/File;
    invoke-direct {v9, v4}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v9}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v8
    new-instance v9, Ljava/io/File;
    invoke-direct {v9, p1, v8}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    goto :write_entry

    :preserve_path
    # Preserve system32/syswow64 structure (DXVK/VKD3D/Box64)
    new-instance v9, Ljava/io/File;
    invoke-direct {v9, p1, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v9}, Ljava/io/File;->getParentFile()Ljava/io/File;
    move-result-object v8
    if-eqz v8, :write_entry
    invoke-virtual {v8}, Ljava/io/File;->mkdirs()Z

    :write_entry
    new-instance v10, Ljava/io/FileOutputStream;
    invoke-direct {v10, v9}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    :write_loop
    invoke-virtual {v0, v2}, Ljava/io/InputStream;->read([B)I
    move-result v5
    if-lez v5, :write_done
    const/4 v7, 0x0
    invoke-virtual {v10, v2, v7, v5}, Ljava/io/OutputStream;->write([BII)V
    goto :write_loop

    :write_done
    invoke-virtual {v10}, Ljava/io/OutputStream;->close()V
    goto :tar_loop

    :tar_done
    invoke-virtual {v0}, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;->close()V
    return-void

.end method
