.class public final Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;
.super Ljava/lang/Object;


# ─────────────────────────────────────────────────────
#  getFirstByte(Context, Uri) -> int
#  Reads first byte of URI stream (unsigned 0-255).
#  Returns -1 on error. 0x28=Zstd  0xFD=XZ  0x50=ZIP
# ─────────────────────────────────────────────────────
.method public static getFirstByte(Landroid/content/Context;Landroid/net/Uri;)I
    .locals 2
    :try_start
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    invoke-virtual {v0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;
    move-result-object v0
    invoke-virtual {v0}, Ljava/io/InputStream;->read()I
    move-result v1
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    and-int/lit16 v1, v1, 0xff
    return v1
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :err
    :err
    move-exception v0
    const/4 v1, -0x1
    return v1
.end method


# ─────────────────────────────────────────────────────
#  getDisplayName(Context, Uri) -> String
#  Queries ContentResolver for _display_name. Returns "" on error.
# ─────────────────────────────────────────────────────
.method public static getDisplayName(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .locals 9
    :try_start
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0           # ContentResolver

    # build consecutive registers for query(Uri, String[], String, String[], String)
    move-object v1, p1              # Uri
    const/4 v7, 0x1
    new-array v7, v7, [Ljava/lang/String;
    const-string v8, "_display_name"
    const/4 v6, 0x0
    aput-object v8, v7, v6
    move-object v2, v7              # projection
    const/4 v3, 0x0                 # selection null
    const/4 v4, 0x0                 # selectionArgs null
    const/4 v5, 0x0                 # sortOrder null
    invoke-virtual/range {v0 .. v5}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    move-result-object v6           # Cursor

    const-string v7, ""
    if-eqz v6, :ret
    invoke-interface {v6}, Landroid/database/Cursor;->moveToFirst()Z
    move-result v8
    if-eqz v8, :close_cur
    const/4 v8, 0x0
    invoke-interface {v6, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;
    move-result-object v7
    :close_cur
    invoke-interface {v6}, Landroid/database/Cursor;->close()V
    :ret
    # fallback: if empty, use URI last path segment (works for file:// URIs)
    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z
    move-result v8
    if-eqz v8, :ret_done
    invoke-virtual {p1}, Landroid/net/Uri;->getLastPathSegment()Ljava/lang/String;
    move-result-object v8
    if-eqz v8, :ret_done
    move-object v7, v8
    :ret_done
    return-object v7
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :dn_err
    :dn_err
    move-exception v0
    invoke-virtual {p1}, Landroid/net/Uri;->getLastPathSegment()Ljava/lang/String;
    move-result-object v1
    if-nez v1, :dn_ret
    const-string v1, ""
    :dn_ret
    return-object v1
.end method


# ─────────────────────────────────────────────────────
#  stripExt(String filename) -> String
#  Removes last extension: "foo.wcp" -> "foo"
# ─────────────────────────────────────────────────────
.method public static stripExt(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    const-string v0, "."
    invoke-virtual {p0, v0}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I
    move-result v1
    if-lez v1, :no_dot
    const/4 v0, 0x0
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object p0
    :no_dot
    return-object p0
.end method


# ─────────────────────────────────────────────────────
#  makeComponentDir(Context, String name) -> File
#  Creates filesDir/usr/home/components/<name>/
# ─────────────────────────────────────────────────────
.method public static makeComponentDir(Landroid/content/Context;Ljava/lang/String;)Ljava/io/File;
    .locals 3
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;
    move-result-object v0
    const-string v1, "usr/home/components"
    new-instance v2, Ljava/io/File;
    invoke-direct {v2, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v0, Ljava/io/File;
    invoke-direct {v0, v2, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z
    return-object v0
.end method


# ─────────────────────────────────────────────────────
#  openTar(Context, Uri, int firstByte) -> TarArchiveInputStream
#  Wraps URI stream in Zstd (0x28) or XZ decompressor.
#  Caller must close the returned stream.
# ─────────────────────────────────────────────────────
.method public static openTar(Landroid/content/Context;Landroid/net/Uri;I)Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;
    .locals 3
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    invoke-virtual {v0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;
    move-result-object v0

    const/16 v1, 0x28
    if-ne p2, v1, :xz_path

    # Zstd path
    new-instance v1, Lcom/github/luben/zstd/ZstdInputStreamNoFinalizer;
    invoke-direct {v1, v0}, Lcom/github/luben/zstd/ZstdInputStreamNoFinalizer;-><init>(Ljava/io/InputStream;)V
    new-instance v2, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;
    invoke-direct {v2, v1}, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;-><init>(Ljava/io/InputStream;)V
    return-object v2

    :xz_path
    # XZ path
    const/4 v1, -0x1
    new-instance v2, Lorg/tukaani/xz/XZInputStream;
    invoke-direct {v2, v0, v1}, Lorg/tukaani/xz/XZInputStream;-><init>(Ljava/io/InputStream;I)V
    new-instance v1, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;
    invoke-direct {v1, v2}, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;-><init>(Ljava/io/InputStream;)V
    return-object v1
.end method


# ─────────────────────────────────────────────────────
#  readWcpProfile(Context, Uri, int firstByte) -> String
#  Finds and returns profile.json content from a WCP tar.
#  Returns null on error or if profile.json not found.
# ─────────────────────────────────────────────────────
.method public static readWcpProfile(Landroid/content/Context;Landroid/net/Uri;I)Ljava/lang/String;
    .locals 9
    # v0=TarArchiveInputStream  v1=result(null)
    # v2=ByteArrayOutputStream  v3=TarArchiveEntry
    # v4=entry name  v5=byte buf  v6=offset  v7=len  v8=tmp

    :try_start
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->openTar(Landroid/content/Context;Landroid/net/Uri;I)Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;
    move-result-object v0
    const/4 v1, 0x0             # result = null

    :entry_loop
    invoke-virtual {v0}, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;->s()Lorg/apache/commons/compress/archivers/tar/TarArchiveEntry;
    move-result-object v3
    if-eqz v3, :loop_done

    invoke-virtual {v3}, Lorg/apache/commons/compress/archivers/tar/TarArchiveEntry;->getName()Ljava/lang/String;
    move-result-object v4

    # skip directories
    const-string v5, "/"
    invoke-virtual {v4, v5}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v8
    if-nez v8, :entry_loop

    # check for profile.json
    const-string v5, "profile.json"
    invoke-virtual {v4, v5}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v8
    if-eqz v8, :entry_loop

    # read profile.json into ByteArrayOutputStream
    new-instance v2, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V
    const/16 v7, 0x400
    new-array v5, v7, [B
    const/4 v6, 0x0

    :read_loop
    array-length v7, v5
    invoke-virtual {v0, v5, v6, v7}, Ljava/io/InputStream;->read([BII)I
    move-result v8
    if-lez v8, :read_done
    invoke-virtual {v2, v5, v6, v8}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :read_loop

    :read_done
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v3
    const-string v4, "UTF-8"
    new-instance v1, Ljava/lang/String;
    invoke-direct {v1, v3, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    # found it — fall through to loop_done

    :loop_done
    invoke-virtual {v0}, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;->close()V
    return-object v1

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_p
    :catch_p
    move-exception v0
    const/4 v1, 0x0
    return-object v1
.end method


# ─────────────────────────────────────────────────────
#  extractWcp(Context, Uri, int firstByte, File dir, boolean flatten)
#  Extracts WCP tar contents into dir. Skips profile.json.
#  flatten=true: all files land directly in dir (FEXCore).
#  flatten=false: preserves system32/syswow64 structure.
# ─────────────────────────────────────────────────────
.method public static extractWcp(Landroid/content/Context;Landroid/net/Uri;ILjava/io/File;Z)V
    .locals 10
    # p0=ctx p1=uri p2=firstByte p3=dir p4=flatten
    # v0=TarArchiveInputStream v1=TarArchiveEntry v2=entryName
    # v3=outFile v4=FileOutputStream v5=buf[B
    # v6=offset v7=len v8=tmp v9=parent

    :try_start
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->openTar(Landroid/content/Context;Landroid/net/Uri;I)Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;
    move-result-object v0

    const/16 v7, 0x2000
    new-array v5, v7, [B        # 8KB write buffer
    const/4 v6, 0x0             # read offset always 0

    :entry_loop
    invoke-virtual {v0}, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;->s()Lorg/apache/commons/compress/archivers/tar/TarArchiveEntry;
    move-result-object v1
    if-eqz v1, :extract_done

    invoke-virtual {v1}, Lorg/apache/commons/compress/archivers/tar/TarArchiveEntry;->getName()Ljava/lang/String;
    move-result-object v2

    # skip directories (name ends with "/")
    const-string v8, "/"
    invoke-virtual {v2, v8}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v8
    if-nez v8, :entry_loop

    # skip profile.json
    const-string v8, "profile.json"
    invoke-virtual {v2, v8}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v8
    if-nez v8, :entry_loop

    # if flatten, strip to last path component
    if-eqz p4, :path_ready
    const-string v8, "/"
    invoke-virtual {v2, v8}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I
    move-result v8
    if-ltz v8, :path_ready
    add-int/lit8 v8, v8, 0x1
    invoke-virtual {v2, v8}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2

    :path_ready
    new-instance v3, Ljava/io/File;
    invoke-direct {v3, p3, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    # ensure parent directory exists
    invoke-virtual {v3}, Ljava/io/File;->getParentFile()Ljava/io/File;
    move-result-object v9
    if-eqz v9, :write_file
    invoke-virtual {v9}, Ljava/io/File;->mkdirs()Z

    :write_file
    new-instance v4, Ljava/io/FileOutputStream;
    invoke-direct {v4, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    :write_loop
    array-length v7, v5
    invoke-virtual {v0, v5, v6, v7}, Ljava/io/InputStream;->read([BII)I
    move-result v8
    if-lez v8, :file_done
    invoke-virtual {v4, v5, v6, v8}, Ljava/io/OutputStream;->write([BII)V
    goto :write_loop

    :file_done
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V
    goto :entry_loop

    :extract_done
    invoke-virtual {v0}, Lorg/apache/commons/compress/archivers/tar/TarArchiveInputStream;->close()V
    return-void

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_ex
    :catch_ex
    move-exception v0
    return-void
.end method


# ─────────────────────────────────────────────────────
#  extractZip(Context, Uri, File dir) -> String
#  Extracts ZIP contents flat into dir.
#  Returns meta.json content string, or "" if absent.
# ─────────────────────────────────────────────────────
.method public static extractZip(Landroid/content/Context;Landroid/net/Uri;Ljava/io/File;)Ljava/lang/String;
    .locals 10
    # p0=ctx p1=uri p2=dir
    # v0=ZipInputStream v1=ZipEntry v2=flatName
    # v3=outFile v4=FileOutputStream v5=buf[B
    # v6=ByteArrayOutputStream(meta) v7=offset v8=len v9=metaResult

    :try_start
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    invoke-virtual {v0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;
    move-result-object v0
    new-instance v1, Ljava/util/zip/ZipInputStream;
    invoke-direct {v1, v0}, Ljava/util/zip/ZipInputStream;-><init>(Ljava/io/InputStream;)V
    move-object v0, v1

    const-string v9, ""         # meta result = empty
    const/16 v8, 0x2000
    new-array v5, v8, [B
    const/4 v7, 0x0

    :zip_loop
    invoke-virtual {v0}, Ljava/util/zip/ZipInputStream;->getNextEntry()Ljava/util/zip/ZipEntry;
    move-result-object v1
    if-eqz v1, :zip_done

    invoke-virtual {v1}, Ljava/util/zip/ZipEntry;->getName()Ljava/lang/String;
    move-result-object v2

    # skip directories
    const-string v8, "/"
    invoke-virtual {v2, v8}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v8
    if-nez v8, :next_entry

    # flatten: strip to filename only
    const-string v8, "/"
    invoke-virtual {v2, v8}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I
    move-result v8
    if-ltz v8, :have_fname
    add-int/lit8 v8, v8, 0x1
    invoke-virtual {v2, v8}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2
    :have_fname

    # is this meta.json?
    const-string v8, "meta.json"
    invoke-virtual {v2, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v8
    if-eqz v8, :zip_write

    # read meta.json into memory
    new-instance v6, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v6}, Ljava/io/ByteArrayOutputStream;-><init>()V
    const/4 v7, 0x0
    :meta_loop
    array-length v8, v5
    invoke-virtual {v0, v5, v7, v8}, Ljava/io/InputStream;->read([BII)I
    move-result v8
    if-lez v8, :meta_done
    invoke-virtual {v6, v5, v7, v8}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :meta_loop
    :meta_done
    invoke-virtual {v6}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v6
    const-string v8, "UTF-8"
    new-instance v9, Ljava/lang/String;
    invoke-direct {v9, v6, v8}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    goto :next_entry

    :zip_write
    new-instance v3, Ljava/io/File;
    invoke-direct {v3, p2, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v4, Ljava/io/FileOutputStream;
    invoke-direct {v4, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    const/4 v7, 0x0
    :zwrite_loop
    array-length v8, v5
    invoke-virtual {v0, v5, v7, v8}, Ljava/io/InputStream;->read([BII)I
    move-result v8
    if-lez v8, :zwrite_done
    invoke-virtual {v4, v5, v7, v8}, Ljava/io/OutputStream;->write([BII)V
    goto :zwrite_loop
    :zwrite_done
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V

    :next_entry
    invoke-virtual {v0}, Ljava/util/zip/ZipInputStream;->closeEntry()V
    goto :zip_loop

    :zip_done
    invoke-virtual {v0}, Ljava/util/zip/ZipInputStream;->close()V
    return-object v9

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_zip
    :catch_zip
    move-exception v0
    const-string v9, ""
    return-object v9
.end method


# ─────────────────────────────────────────────────────
#  registerComponent(Context, String name, String version,
#                    String desc, int contentType)
#  Builds EnvLayerEntity + ComponentRepo(state=INSTALLED)
#  and calls EmuComponents.D() to persist the registration.
#
#  EnvLayerEntity <init> param → field mapping (from smali):
#    p1=blurb  p2=fileMd5  p3+p4=fileSize(J)  p5=id(I)
#    p6=logo   p7=displayName  p8=name  p9=fileName
#    p10=type(I)  p11=version  p12=versionCode(I)
#    p13(saved as v0)=downloadUrl  p14=upgradeMsg
#    p15=subData  p16=base  p17=framework  p18=frameworkType
#    p19=isSteam(I)
# ─────────────────────────────────────────────────────
.method public static registerComponent(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 20
    # With .locals 20: v0-v19 are locals; p0=v20 p1=v21 p2=v22 p3=v23 p4=v24
    # Params above v15 must use move-object/from16 or move/from16

    # ── Build EnvLayerEntity via invoke-direct/range {v0..v19} ──
    # EnvLayerEntity <init> param→field (verified from smali):
    #  v0=this  v1=blurb  v2=fileMd5  v3+v4=fileSize(J)  v5=id(I)
    #  v6=logo  v7=displayName  v8=name  v9=fileName  v10=type(I)
    #  v11=version  v12=versionCode(I)  v13=downloadUrl  v14=upgradeMsg
    #  v15=subData  v16=base  v17=framework  v18=frameworkType  v19=isSteam(I)

    new-instance v0, Lcom/xj/winemu/api/bean/EnvLayerEntity;
    move-object/from16 v1, p3          # blurb = desc
    const-string v2, ""                # fileMd5 @NotNull
    const-wide/16 v3, 0x0              # fileSize J (v3=lo, v4=hi)
    const/4 v5, 0x0                    # id I
    const-string v6, ""                # logo @NotNull
    move-object/from16 v7, p1          # displayName = name
    move-object/from16 v8, p1          # name @NotNull
    const-string v9, ""                # fileName @NotNull
    move/from16 v10, p4                # type I = contentType
    move-object/from16 v11, p2         # version @NotNull
    const/4 v12, 0x0                   # versionCode I
    const-string v13, ""               # downloadUrl @NotNull
    const-string v14, ""               # upgradeMsg
    const/4 v15, 0x0                   # subData null (v15 = max for const/4)
    const/16 v16, 0x0                  # base null
    const/16 v17, 0x0                  # framework null
    const/16 v18, 0x0                  # frameworkType null
    const/16 v19, 0x0                  # isSteam I

    invoke-direct/range {v0 .. v19}, Lcom/xj/winemu/api/bean/EnvLayerEntity;-><init>(Ljava/lang/String;Ljava/lang/String;JILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;ILjava/lang/String;Ljava/lang/String;Lcom/xj/common/download/bean/SubData;Lcom/xj/winemu/api/bean/EnvLayerEntity;Ljava/lang/String;Ljava/lang/String;I)V
    # v0 = initialized EnvLayerEntity

    # save entity to v8, then reuse v0-v7 for ComponentRepo
    move-object v8, v0

    # ── Build ComponentRepo via invoke-direct/range {v0..v7} ──
    new-instance v0, LComponentRepo;
    move-object/from16 v1, p1          # name
    move-object/from16 v2, p2          # version
    sget-object v3, LState;->Extracted:LState;
    move-object v4, v8                 # EnvLayerEntity
    const/4 v5, 0x0                    # isDep = false
    const/4 v6, 0x0                    # isBase = false
    const/4 v7, 0x0                    # depInfo = null

    invoke-direct/range {v0 .. v7}, LComponentRepo;-><init>(Ljava/lang/String;Ljava/lang/String;LState;Lcom/xj/winemu/api/bean/EnvLayerEntity;ZZLcom/winemu/core/DependencyManager$Companion$Info;)V
    # v0 = initialized ComponentRepo

    # ── Register with EmuComponents.D() ──
    sget-object v1, Lcom/xj/winemu/EmuComponents;->c:Lcom/xj/winemu/EmuComponents$Companion;
    invoke-virtual {v1}, Lcom/xj/winemu/EmuComponents$Companion;->a()Lcom/xj/winemu/EmuComponents;
    move-result-object v1
    invoke-virtual {v1, v0}, Lcom/xj/winemu/EmuComponents;->D(LComponentRepo;)V

    return-void
.end method


# ─────────────────────────────────────────────────────
#  injectComponent(Context, Uri, int contentType)
#  Main entry: detects format, extracts to new
#  components/<name>/ folder, registers with EmuComponents.
#  Shows toast with result.
#
#  contentType ints: DXVK=12 VKD3D=13 Box64=94 FEXCore=95 GPU=10
# ─────────────────────────────────────────────────────
.method public static injectComponent(Landroid/content/Context;Landroid/net/Uri;I)V
    .locals 10
    # p0=ctx  p1=uri  p2=contentType
    # v0=firstByte  v1=jsonStr  v2=JSONObject
    # v3=name  v4=version  v5=desc  v6=targetDir  v7=flatten(Z)/tmp  v8=tmp  v9=File(rename)

    :try_start
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->getFirstByte(Landroid/content/Context;Landroid/net/Uri;)I
    move-result v0

    # ZIP check: first byte 0x50 = 'P'
    const/16 v8, 0x50
    if-ne v0, v8, :wcp_path

    # ── ZIP branch ────────────────────────────────────
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->getDisplayName(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    move-result-object v3
    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->stripExt(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3       # v3 = filename (no ext), used as fallback name

    invoke-static {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->makeComponentDir(Landroid/content/Context;Ljava/lang/String;)Ljava/io/File;
    move-result-object v6       # target dir

    invoke-static {p0, p1, v6}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->extractZip(Landroid/content/Context;Landroid/net/Uri;Ljava/io/File;)Ljava/lang/String;
    move-result-object v1       # meta.json string (or "")

    # defaults before parsing meta.json
    # v3 (ZIP filename) is the component name AND directory name — never overwritten
    move-object v4, v3          # version = filename (fallback)
    const-string v5, ""         # desc = empty

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v8
    if-nez v8, :zip_register

    # parse meta.json
    new-instance v2, Lorg/json/JSONObject;
    invoke-direct {v2, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    # Fix 1: use driverVersion as version string (not meta.json name)
    const-string v8, "driverVersion"
    invoke-virtual {v2, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v8
    invoke-virtual {v8}, Ljava/lang/String;->isEmpty()Z
    move-result v7
    if-nez v7, :zip_check_desc
    move-object v4, v8          # version = driverVersion

    :zip_check_desc
    const-string v8, "description"
    invoke-virtual {v2, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5       # desc from meta.json

    # Fix 2: if libraryName != "libvulkan_freedreno.so", rename the file
    const-string v8, "libraryName"
    invoke-virtual {v2, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v7       # v7 = libraryName
    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z
    move-result v8
    if-nez v8, :zip_register    # no libraryName → skip
    const-string v8, "libvulkan_freedreno.so"
    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v8
    if-nez v8, :zip_register    # already correct name → skip
    # rename File(dir, libraryName) → File(dir, "libvulkan_freedreno.so")
    new-instance v8, Ljava/io/File;
    invoke-direct {v8, v6, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v9, Ljava/io/File;
    const-string v7, "libvulkan_freedreno.so"
    invoke-direct {v9, v6, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v8, v9}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    :zip_register
    invoke-static {p0, v3, v4, v5, p2}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->registerComponent(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
    goto :show_success

    # ── WCP branch ────────────────────────────────────
    :wcp_path
    invoke-static {p0, p1, v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->readWcpProfile(Landroid/content/Context;Landroid/net/Uri;I)Ljava/lang/String;
    move-result-object v1

    if-nez v1, :have_profile
    # profile.json missing or unreadable — fall back to filename
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->getDisplayName(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    move-result-object v3
    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->stripExt(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    move-object v4, v3
    const-string v5, ""
    goto :have_name

    :have_profile
    new-instance v2, Lorg/json/JSONObject;
    invoke-direct {v2, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v8, "versionName"
    invoke-virtual {v2, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3       # versionName

    const-string v8, "description"
    invoke-virtual {v2, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5       # desc

    # version = versionName
    move-object v4, v3

    # fallback name if versionName empty
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z
    move-result v8
    if-eqz v8, :have_name
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->getDisplayName(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    move-result-object v3
    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->stripExt(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    move-object v4, v3
    :have_name

    # flatten=true only for FEXCore (contentType == 0x5f = 95)
    const/16 v8, 0x5f
    const/4 v7, 0x0
    if-ne p2, v8, :do_extract
    const/4 v7, 0x1
    :do_extract

    # create target directory
    invoke-static {p0, v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->makeComponentDir(Landroid/content/Context;Ljava/lang/String;)Ljava/io/File;
    move-result-object v6

    # extract WCP files
    invoke-static {p0, p1, v0, v6, v7}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->extractWcp(Landroid/content/Context;Landroid/net/Uri;ILjava/io/File;Z)V

    # register
    invoke-static {p0, v3, v4, v5, p2}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->registerComponent(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V

    :show_success
    # build "Added to GameHub: <name>"
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v8, "Added to GameHub: "
    invoke-virtual {v1, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8

    :toast_and_return
    const/4 v1, 0x1
    invoke-static {p0, v8, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    return-void

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_main
    :catch_main
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v8
    if-nez v8, :has_msg
    const-string v8, "Injection failed"
    :has_msg
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "Error: "
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8
    const/4 v1, 0x1
    invoke-static {p0, v8, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    return-void
.end method


# ─────────────────────────────────────────────────────
#  appendLocalComponents(List<DialogSettingListItemEntity>, int contentType)
#  Appends locally installed EmuComponents matching contentType to the list.
#  contentType=32 (TRANSLATOR) also includes BOX64(94) and FEXCORE(95).
#  Called from GameSettingViewModel$fetchList$1 before callback invocation.
# ─────────────────────────────────────────────────────
.method public static appendLocalComponents(Ljava/util/List;I)V
    .locals 9
    # p0 = List  p1 = contentType
    # v0 = EmuComponents  v1 = Collection  v2 = Iterator
    # v3 = ComponentRepo  v4 = EnvLayerEntity  v5 = type int
    # v6 = DialogSettingListItemEntity  v7 = String temp  v8 = bool/int temp

    :try_start
    invoke-static {}, Lcom/xj/winemu/EmuComponents;->e()Lcom/xj/winemu/EmuComponents;
    move-result-object v0
    if-eqz v0, :done

    iget-object v1, v0, Lcom/xj/winemu/EmuComponents;->a:Ljava/util/HashMap;
    if-eqz v1, :done

    invoke-virtual {v1}, Ljava/util/HashMap;->values()Ljava/util/Collection;
    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;
    move-result-object v2

    :iter_loop
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z
    move-result v8
    if-eqz v8, :done

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, LComponentRepo;

    invoke-virtual {v3}, LComponentRepo;->getEntry()Lcom/xj/winemu/api/bean/EnvLayerEntity;
    move-result-object v4
    if-eqz v4, :iter_loop

    invoke-virtual {v4}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getType()I
    move-result v5

    # Direct type match
    if-eq v5, p1, :type_match

    # Special: TRANSLATOR(0x20=32) also matches BOX64(0x5e=94) and FEXCORE(0x5f=95)
    const/16 v8, 0x20
    if-ne p1, v8, :iter_loop
    const/16 v8, 0x5e
    if-eq v5, v8, :type_match
    const/16 v8, 0x5f
    if-ne v5, v8, :iter_loop

    :type_match
    new-instance v6, Lcom/xj/winemu/bean/DialogSettingListItemEntity;
    invoke-direct {v6}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;-><init>()V

    # setTitle(name)
    invoke-virtual {v3}, LComponentRepo;->getName()Ljava/lang/String;
    move-result-object v7
    invoke-virtual {v6, v7}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->setTitle(Ljava/lang/String;)V

    # setDisplayName(entity.displayName or name fallback)
    invoke-virtual {v4}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getDisplayName()Ljava/lang/String;
    move-result-object v7
    if-eqz v7, :use_name_disp
    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z
    move-result v8
    if-nez v8, :use_name_disp
    invoke-virtual {v6, v7}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->setDisplayName(Ljava/lang/String;)V
    goto :after_disp
    :use_name_disp
    invoke-virtual {v3}, LComponentRepo;->getName()Ljava/lang/String;
    move-result-object v7
    invoke-virtual {v6, v7}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->setDisplayName(Ljava/lang/String;)V
    :after_disp

    # setType(p1)
    invoke-virtual {v6, p1}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->setType(I)V

    # setEnvLayerEntity(v4)
    invoke-virtual {v6, v4}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->setEnvLayerEntity(Lcom/xj/winemu/api/bean/EnvLayerEntity;)V

    # setDownloaded(true)
    const/4 v8, 0x1
    invoke-virtual {v6, v8}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->setDownloaded(Z)V

    invoke-interface {p0, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    goto :iter_loop

    :done
    return-void

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_al
    :catch_al
    move-exception v0
    return-void
.end method
