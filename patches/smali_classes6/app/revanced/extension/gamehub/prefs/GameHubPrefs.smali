.class public Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;
.super Ljava/lang/Object;
.source "GameHubPrefs.java"


# static fields
.field public static final CONTENT_TYPE_API:I = 0x1a

.field public static final CONTENT_TYPE_CPU_USAGE:I = 0x1c

.field public static final CONTENT_TYPE_LOG_REQUESTS:I = 0x1b

.field public static final CONTENT_TYPE_PERF_METRICS:I = 0x1d

.field public static final CONTENT_TYPE_SD_CARD_STORAGE:I = 0x18

.field private static final BANNERHUB_URL:Ljava/lang/String; = "https://bannerhub-api.the412banner.workers.dev/"

.field private static final EMUREADY_URL:Ljava/lang/String; = "https://gamehub-lite-api.emuready.workers.dev/"

.field private static final KEY_CPU_USAGE:Ljava/lang/String; = "cpu_usage_display"

.field private static final KEY_CUSTOM_STORAGE:Ljava/lang/String; = "use_custom_storage"

.field private static final KEY_API_SOURCE:Ljava/lang/String; = "api_source"

.field private static final KEY_LAST_API_SOURCE:Ljava/lang/String; = "last_api_source"

.field private static final KEY_LOG_ALL_REQUESTS:Ljava/lang/String; = "log_all_requests"

.field private static final KEY_PERF_METRICS:Ljava/lang/String; = "perf_metrics_display"

.field private static final KEY_STORAGE_PATH:Ljava/lang/String; = "steam_storage_path"

.field private static final PREFS_NAME:Ljava/lang/String; = "steam_storage_pref"

.field private static volatile startupCheckDone:Z


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static addCompatibilityHeaders(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 5

    .line 308
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v1, "addHeader"

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/Class;

    const-class v3, Ljava/lang/String;

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const-class v3, Ljava/lang/String;

    const/4 v4, 0x1

    aput-object v3, v2, v4

    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 309
    const-string v1, "User-Agent"

    const-string v2, "Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"

    filled-new-array {v1, v2}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 313
    const-string v1, "Accept"

    const-string v2, "application/json, text/plain, */*"

    filled-new-array {v1, v2}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 314
    const-string v1, "Accept-Language"

    const-string v2, "en-US,en;q=0.9"

    filled-new-array {v1, v2}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 315
    const-string v1, "Connection"

    const-string v2, "keep-alive"

    filled-new-array {v1, v2}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception v0

    .line 317
    sget-object v1, Lapp/revanced/extension/gamehub/util/GHLog;->PREFS:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v2, "addCompatibilityHeaders failed"

    invoke-virtual {v1, v2, v0}, Lapp/revanced/extension/gamehub/util/GHLog;->w(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-object p0
.end method

.method public static autoDetectSDCardStorage()Ljava/lang/String;
    .locals 8

    const/4 v0, 0x0

    .line 358
    :try_start_0
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object v1

    .line 359
    invoke-virtual {v1, v0}, Landroid/content/Context;->getExternalFilesDirs(Ljava/lang/String;)[Ljava/io/File;

    move-result-object v1

    .line 360
    array-length v2, v1

    const/4 v3, 0x0

    move v4, v3

    :goto_0
    if-ge v4, v2, :cond_3

    aget-object v5, v1, v4

    if-nez v5, :cond_0

    goto :goto_1

    .line 363
    :cond_0
    invoke-virtual {v5}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v5

    # BannerHub: skip primary/emulated storage — only accept true removable SD cards
    const-string v6, "/storage/emulated/"
    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v6
    if-nez v6, :goto_1

    .line 364
    const-string v6, "/Android/data"

    invoke-virtual {v5, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v6

    if-gez v6, :cond_1

    goto :goto_1

    .line 366
    :cond_1
    invoke-virtual {v5, v3, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 367
    new-instance v6, Ljava/io/File;

    const-string v7, "GHL"

    invoke-direct {v6, v5, v7}, Ljava/io/File;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    # BannerHub: create GHL folder if it doesn't exist (no longer requires pre-existing folder)
    invoke-virtual {v6}, Ljava/io/File;->mkdirs()Z

    invoke-virtual {v6}, Ljava/io/File;->canWrite()Z

    move-result v6

    if-eqz v6, :cond_2

    .line 369
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "steam_storage_path"

    invoke-interface {v1, v2, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v5

    :cond_2
    :goto_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :catch_0
    move-exception v1

    .line 374
    sget-object v2, Lapp/revanced/extension/gamehub/util/GHLog;->PREFS:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v3, "autoDetectSDCardStorage failed"

    invoke-virtual {v2, v3, v1}, Lapp/revanced/extension/gamehub/util/GHLog;->w(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_3
    return-object v0
.end method

.method private static clearComponentAndTokenCaches()V
    .locals 3

    .line 75
    :try_start_0
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object v0

    .line 78
    const-string v1, "sp_winemu_all_components12"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 79
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 80
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 81
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 82
    const-string v1, "sp_winemu_all_containers"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 83
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 84
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 85
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 86
    const-string v1, "sp_winemu_all_imageFs"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 87
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 88
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 89
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 91
    const-string v1, "pc_g_setting"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 93
    const-string v1, "net_cookies"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 95
    invoke-static {}, Lapp/revanced/extension/gamehub/token/TokenProvider;->clearCache()V

    .line 97
    invoke-static {}, Lapp/revanced/extension/gamehub/ui/CompatibilityCache;->clear()V

    .line 100
    invoke-virtual {v0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v0

    invoke-static {v0}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->deleteCacheContents(Ljava/io/File;)V

    .line 101
    sget-object v0, Lapp/revanced/extension/gamehub/util/GHLog;->PREFS:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v1, "Cleared all caches for API source change"

    invoke-virtual {v0, v1}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0

    .line 103
    sget-object v1, Lapp/revanced/extension/gamehub/util/GHLog;->PREFS:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v2, "clearComponentAndTokenCaches failed"

    invoke-virtual {v1, v2, v0}, Lapp/revanced/extension/gamehub/util/GHLog;->w(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static deleteCacheContents(Ljava/io/File;)V
    .locals 4

    if-eqz p0, :cond_3

    .line 112
    invoke-virtual {p0}, Ljava/io/File;->isDirectory()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_1

    .line 113
    :cond_0
    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object p0

    if-nez p0, :cond_1

    goto :goto_1

    .line 115
    :cond_1
    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_3

    aget-object v2, p0, v1

    .line 116
    invoke-virtual {v2}, Ljava/io/File;->isDirectory()Z

    move-result v3

    if-eqz v3, :cond_2

    .line 117
    invoke-static {v2}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->deleteCacheContents(Ljava/io/File;)V

    .line 119
    :cond_2
    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_3
    :goto_1
    return-void
.end method

.method public static getAvailableStorage()J
    .locals 5

    .line 328
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isCustomStorageEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getCustomStoragePath()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    if-eqz v0, :cond_1

    .line 329
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_1

    .line 330
    new-instance v1, Ljava/io/File;

    invoke-direct {v1, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    goto :goto_1

    .line 331
    :cond_1
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v1

    .line 332
    :goto_1
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_2

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v1

    .line 333
    :cond_2
    new-instance v0, Landroid/os/StatFs;

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/StatFs;-><init>(Ljava/lang/String;)V

    .line 334
    invoke-virtual {v0}, Landroid/os/StatFs;->getAvailableBlocksLong()J

    move-result-wide v1

    invoke-virtual {v0}, Landroid/os/StatFs;->getBlockSizeLong()J

    move-result-wide v3

    mul-long/2addr v1, v3

    return-wide v1
.end method

.method private static getBodyContentLength(Ljava/lang/Object;)J
    .locals 4

    .line 544
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v1, "contentLength"

    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v1, v2, [Ljava/lang/Object;

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Long;

    invoke-virtual {p0}, Ljava/lang/Long;->longValue()J

    move-result-wide v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-wide v0

    :catch_0
    const-wide/16 v0, -0x1

    return-wide v0
.end method

.method private static getBodyContentType(Ljava/lang/Object;)Ljava/lang/String;
    .locals 5

    const/4 v0, 0x0

    .line 532
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "contentType"

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    new-array v2, v3, [Ljava/lang/Object;

    invoke-virtual {v1, p0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 533
    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    :cond_0
    return-object v0
.end method

.method private static getContentLength(Ljava/lang/Object;)J
    .locals 7

    const-wide/16 v0, -0x1

    .line 520
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const-string v3, "header"

    const/4 v4, 0x1

    new-array v4, v4, [Ljava/lang/Class;

    const-class v5, Ljava/lang/String;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    const-string v3, "Content-Length"

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {v2, p0, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    if-eqz p0, :cond_0

    .line 521
    invoke-static {p0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_0
    return-wide v0
.end method

.method private static getContentType(Ljava/lang/Object;)Ljava/lang/String;
    .locals 5

    .line 508
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v1, "header"

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Class;

    const-class v3, Ljava/lang/String;

    const/4 v4, 0x0

    aput-object v3, v2, v4

    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    const-string v1, "Content-Type"

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public static getCustomSettingName(I)Ljava/lang/String;
    .locals 1

    const/16 v0, 0x18

    if-ne p0, v0, :cond_0

    .line 230
    const-string p0, "SD Card Storage"

    return-object p0

    :cond_0
    const/16 v0, 0x1a

    if-ne p0, v0, :cond_1

    .line 231
    const-string p0, "Compatibility API"

    return-object p0

    :cond_1
    const/16 v0, 0x1b

    if-ne p0, v0, :cond_2

    .line 232
    const-string p0, "Log All Requests"

    return-object p0

    :cond_2
    const/16 v0, 0x1c

    if-ne p0, v0, :cond_3

    .line 233
    const-string p0, "CPU Usage Display"

    return-object p0

    :cond_3
    const/16 v0, 0x1d

    if-ne p0, v0, :cond_4

    .line 234
    const-string p0, "Performance Metrics"

    return-object p0

    :cond_4
    const/4 p0, 0x0

    return-object p0
.end method

.method public static getCustomStoragePath()Ljava/lang/String;
    .locals 3

    .line 135
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "steam_storage_path"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static getEffectiveApiUrl(Ljava/lang/String;)Ljava/lang/String;
    .locals 7

    .line 204
    const-string v0, "last_api_source"

    .line 0
    const-string v1, "API source mismatch on startup (current="

    .line 204
    sget-boolean v2, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->startupCheckDone:Z

    if-nez v2, :cond_1

    const/4 v2, 0x1

    .line 205
    sput-boolean v2, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->startupCheckDone:Z

    .line 207
    :try_start_0
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v3

    .line 208
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getApiSource()I

    move-result v4

    .line 210
    const/4 v2, -0x1
    invoke-interface {v3, v0, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v2

    .line 211
    invoke-interface {v3, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_0

    if-eq v4, v2, :cond_1

    .line 212
    :cond_0
    sget-object v5, Lapp/revanced/extension/gamehub/util/GHLog;->PREFS:Lapp/revanced/extension/gamehub/util/GHLog;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v6, ", last="

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ") \u2014 clearing caches"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v5, v1}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V

    .line 214
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->clearComponentAndTokenCaches()V

    .line 215
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1, v0, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 218
    sget-object v1, Lapp/revanced/extension/gamehub/util/GHLog;->PREFS:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v2, "Startup API source check failed"

    invoke-virtual {v1, v2, v0}, Lapp/revanced/extension/gamehub/util/GHLog;->w(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 221
    :cond_1
    :goto_0
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getApiSource()I

    move-result v0

    if-eqz v0, :cond_url_gamehub

    const/4 v1, 0x1
    if-ne v0, v1, :cond_url_bannerhub

    const-string p0, "https://gamehub-lite-api.emuready.workers.dev/"
    goto :cond_url_gamehub

    :cond_url_bannerhub
    const-string p0, "https://bannerhub-api.the412banner.workers.dev/"

    :cond_url_gamehub
    return-object p0
.end method

.method public static getEffectiveStoragePath(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    .line 179
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isCustomStorageEnabled()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    if-eqz p0, :cond_6

    .line 180
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_0

    .line 182
    :cond_1
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getCustomStoragePath()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_6

    .line 183
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_2

    goto :goto_0

    .line 185
    :cond_2
    new-instance v1, Ljava/io/File;

    invoke-direct {v1, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 186
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_6

    invoke-virtual {v1}, Ljava/io/File;->isDirectory()Z

    move-result v1

    if-nez v1, :cond_3

    goto :goto_0

    .line 188
    :cond_3
    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_4

    goto :goto_0

    .line 190
    :cond_4
    const-string v1, "/files/Steam"

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-gez v1, :cond_5

    goto :goto_0

    .line 193
    :cond_5
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :cond_6
    :goto_0
    return-object p0
.end method

.method public static getInitialSwitchValue(IZ)Z
    .locals 1

    const/16 v0, 0x18

    if-ne p0, v0, :cond_0

    .line 164
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isCustomStorageEnabled()Z

    move-result p0

    return p0

    :cond_0
    const/16 v0, 0x1a

    if-ne p0, v0, :cond_1

    .line 165
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isExternalAPI()Z

    move-result p0

    return p0

    :cond_1
    const/16 v0, 0x1b

    if-ne p0, v0, :cond_2

    .line 166
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isLogAllRequestsEnabled()Z

    move-result p0

    return p0

    :cond_2
    const/16 v0, 0x1c

    if-ne p0, v0, :cond_3

    .line 167
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isCpuUsageEnabled()Z

    move-result p0

    return p0

    :cond_3
    const/16 v0, 0x1d

    if-ne p0, v0, :cond_4

    .line 168
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isPerfMetricsEnabled()Z

    move-result p0

    return p0

    :cond_4
    return p1
.end method

.method private static getPrefs()Landroid/content/SharedPreferences;
    .locals 3

    .line 32
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object v0

    const-string v1, "steam_storage_pref"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/app/Application;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    return-object v0
.end method

.method public static handleSettingToggle(IZ)Z
    .locals 3

    const/16 v0, 0x18

    const/4 v1, 0x0

    if-ne p0, v0, :cond_2

    if-eqz p1, :cond_1

    .line 251
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->autoDetectSDCardStorage()Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_0

    .line 253
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object p0

    const-string p1, "No SD card found"

    invoke-static {p0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    .line 254
    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return v1

    .line 257
    :cond_0
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "use_custom_storage"

    const/4 v0, 0x1

    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return v0

    .line 260
    :cond_1
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->useInternalStorage()V

    return v1

    :cond_2
    const/16 v0, 0x1b

    if-ne p0, v0, :cond_4

    .line 264
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isLogAllRequestsEnabled()Z

    move-result p0

    xor-int/lit8 p1, p0, 0x1

    .line 265
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "log_all_requests"

    invoke-interface {v0, v2, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    if-nez p0, :cond_3

    .line 266
    const-string p0, "Logging all API requests"

    goto :goto_0

    :cond_3
    const-string p0, "Logging 4xx requests only"

    .line 267
    :goto_0
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object v0

    invoke-static {v0, p0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    .line 268
    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return p1

    :cond_4
    const/16 v0, 0x1c

    if-ne p0, v0, :cond_6

    .line 271
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isCpuUsageEnabled()Z

    move-result p0

    xor-int/lit8 p1, p0, 0x1

    .line 272
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "cpu_usage_display"

    invoke-interface {v0, v2, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    if-nez p0, :cond_5

    .line 273
    const-string p0, "CPU usage display enabled"

    goto :goto_1

    :cond_5
    const-string p0, "CPU usage display disabled"

    .line 274
    :goto_1
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object v0

    invoke-static {v0, p0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    .line 275
    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return p1

    :cond_6
    const/16 v0, 0x1d

    if-ne p0, v0, :cond_8

    .line 278
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isPerfMetricsEnabled()Z

    move-result p0

    xor-int/lit8 p1, p0, 0x1

    .line 279
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "perf_metrics_display"

    invoke-interface {v0, v2, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    if-nez p0, :cond_7

    .line 280
    const-string p0, "Performance metrics enabled"

    goto :goto_2

    :cond_7
    const-string p0, "Performance metrics disabled"

    .line 281
    :goto_2
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object v0

    invoke-static {v0, p0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    .line 282
    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return p1

    :cond_8
    const/16 v0, 0x1a

    if-ne p0, v0, :cond_a

    .line 285
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->toggleAPI()V

    .line 286
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->clearComponentAndTokenCaches()V

    .line 287
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "last_api_source"

    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getApiSource()I

    move-result v2

    invoke-interface {p0, v0, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    # 3-way toast based on new api_source
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getApiSource()I

    move-result v0

    if-eqz v0, :api_cond_gamehub

    const/4 v2, 0x1

    if-ne v0, v2, :api_cond_bannerhub

    const-string p0, "Switched to EmuReady API \u2014 restart to refresh components"

    goto :api_goto_toast

    :api_cond_bannerhub
    const-string p0, "Switched to BannerHub API \u2014 restart to refresh components"

    goto :api_goto_toast

    :api_cond_gamehub
    const-string p0, "Switched to Official API \u2014 restart to refresh components"

    .line 291
    :api_goto_toast
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object v0

    invoke-static {v0, p0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    .line 292
    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    # Return isExternalAPI() as the new switch state
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isExternalAPI()Z

    move-result p1

    :cond_a
    return p1
.end method

.method public static isCpuUsageEnabled()Z
    .locals 3

    .line 54
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "cpu_usage_display"

    const/4 v2, 0x1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public static isCustomStorageEnabled()Z
    .locals 3

    .line 124
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "use_custom_storage"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public static isExternalAPI()Z
    .locals 1

    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getApiSource()I

    move-result v0

    if-eqz v0, :cond_not_external

    const/4 v0, 0x1

    return v0

    :cond_not_external
    const/4 v0, 0x0

    return v0
.end method

# Returns the selected API source: 0=GameHub (default), 1=EmuReady, 2=BannerHub
.method public static getApiSource()I
    .locals 3

    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "api_source"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    return v0
.end method

# Sets the selected API source (0=GameHub, 1=EmuReady, 2=BannerHub), saves pref, clears caches, shows toast
.method public static setApiSource(I)V
    .locals 4

    # Save api_source pref
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v2, "api_source"
    invoke-interface {v1, v2, p0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Save last_api_source (used for startup mismatch detection)
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v2, "last_api_source"
    invoke-interface {v1, v2, p0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Clear all component / token caches
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->clearComponentAndTokenCaches()V

    # Build toast message based on chosen source
    const/4 v1, 0x0
    if-eqz p0, :api_src_gamehub
    const/4 v2, 0x1
    if-ne p0, v2, :api_src_bannerhub
    const-string v3, "Switched to EmuReady API \u2014 restart to refresh components"
    goto :api_src_toast
    :api_src_bannerhub
    const-string v3, "Switched to BannerHub API \u2014 restart to refresh components"
    goto :api_src_toast
    :api_src_gamehub
    const-string v3, "Switched to Official API \u2014 restart to refresh components"
    :api_src_toast
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;
    move-result-object v0
    invoke-static {v0, v3, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method public static isLogAllRequestsEnabled()Z
    .locals 3

    .line 50
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "log_all_requests"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public static isPerfMetricsEnabled()Z
    .locals 3

    .line 58
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "perf_metrics_display"

    const/4 v2, 0x1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public static isSettingEnabled(I)Z
    .locals 1

    const/16 v0, 0x18

    if-ne p0, v0, :cond_0

    .line 146
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isCustomStorageEnabled()Z

    move-result p0

    return p0

    :cond_0
    const/16 v0, 0x1a

    if-ne p0, v0, :cond_1

    .line 147
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isExternalAPI()Z

    move-result p0

    return p0

    :cond_1
    const/16 v0, 0x1b

    if-ne p0, v0, :cond_2

    .line 148
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isLogAllRequestsEnabled()Z

    move-result p0

    return p0

    :cond_2
    const/16 v0, 0x1c

    if-ne p0, v0, :cond_3

    .line 149
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isCpuUsageEnabled()Z

    move-result p0

    return p0

    :cond_3
    const/16 v0, 0x1d

    if-ne p0, v0, :cond_4

    .line 150
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isPerfMetricsEnabled()Z

    move-result p0

    return p0

    :cond_4
    const/4 p0, 0x0

    return p0
.end method

.method private static isTextContentType(Ljava/lang/String;)Z
    .locals 2

    const/4 v0, 0x1

    if-nez p0, :cond_0

    return v0

    .line 556
    :cond_0
    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p0, v1}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    .line 557
    const-string v1, "text/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "json"

    .line 558
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "xml"

    .line 559
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "html"

    .line 560
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "form-urlencoded"

    .line 561
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return p0

    :cond_2
    :goto_0
    return v0
.end method

.method public static logApiRequest(Ljava/lang/Object;)V
    .locals 10

    const-string v0, "Response body: "

    const-string v1, ", "

    const-string v2, "Response body: <binary "

    .line 388
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isLogAllRequestsEnabled()Z

    move-result v3

    if-nez v3, :cond_0

    goto/16 :goto_1

    .line 390
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    const-string v4, "request"

    const/4 v5, 0x0

    new-array v6, v5, [Ljava/lang/Class;

    invoke-virtual {v3, v4, v6}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    new-array v4, v5, [Ljava/lang/Object;

    invoke-virtual {v3, p0, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    .line 391
    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    const-string v6, "url"

    new-array v7, v5, [Ljava/lang/Class;

    invoke-virtual {v4, v6, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    new-array v6, v5, [Ljava/lang/Object;

    invoke-virtual {v4, v3, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    .line 392
    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v6

    const-string v7, "method"

    new-array v8, v5, [Ljava/lang/Class;

    invoke-virtual {v6, v7, v8}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v6

    new-array v7, v5, [Ljava/lang/Object;

    invoke-virtual {v6, v3, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    .line 393
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v7

    const-string v8, "code"

    new-array v9, v5, [Ljava/lang/Class;

    invoke-virtual {v7, v8, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v7

    new-array v8, v5, [Ljava/lang/Object;

    invoke-virtual {v7, p0, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/Integer;

    invoke-virtual {v7}, Ljava/lang/Integer;->intValue()I

    move-result v7

    .line 395
    sget-object v8, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v9, "=== API Request ==="

    invoke-virtual {v8, v9}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V

    .line 396
    sget-object v8, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v9, " "

    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " \u2192 HTTP "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v8, v4}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V

    .line 398
    invoke-static {v3}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->logRequestDetails(Ljava/lang/Object;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    .line 402
    :try_start_1
    invoke-static {p0}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getContentType(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    .line 403
    invoke-static {v3}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isTextContentType(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 404
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "peekBody"

    const/4 v3, 0x1

    new-array v3, v3, [Ljava/lang/Class;

    sget-object v4, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    aput-object v4, v3, v5

    .line 405
    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    const-wide/32 v2, 0x100000

    .line 406
    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v1, p0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 408
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "string"

    new-array v3, v5, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    new-array v2, v5, [Ljava/lang/Object;

    invoke-virtual {v1, p0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    if-eqz p0, :cond_3

    .line 409
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_3

    .line 410
    sget-object v1, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V

    goto :goto_1

    .line 413
    :cond_1
    invoke-static {p0}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getContentLength(Ljava/lang/Object;)J

    move-result-wide v4

    .line 414
    sget-object p0, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-wide/16 v2, 0x0

    cmp-long v2, v4, v2

    if-ltz v2, :cond_2

    .line 415
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " bytes>"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_2
    const-string v1, ">"

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 414
    invoke-virtual {p0, v0}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_1

    .line 418
    :catch_0
    :try_start_2
    sget-object p0, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v0, "Response body: <unreadable>"

    invoke-virtual {p0, v0}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_1

    :catch_1
    move-exception p0

    .line 421
    sget-object v0, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v1, "logApiRequest failed"

    invoke-virtual {v0, v1, p0}, Lapp/revanced/extension/gamehub/util/GHLog;->w(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_3
    :goto_1
    return-void
.end method

.method public static logFailedApiRequest(Ljava/lang/Object;Ljava/lang/String;)V
    .locals 8

    const-string v0, "Response body: "

    .line 435
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isLogAllRequestsEnabled()Z

    move-result v1

    if-eqz v1, :cond_0

    goto/16 :goto_0

    .line 437
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "request"

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    new-array v2, v3, [Ljava/lang/Object;

    invoke-virtual {v1, p0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 438
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const-string v4, "url"

    new-array v5, v3, [Ljava/lang/Class;

    invoke-virtual {v2, v4, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    new-array v4, v3, [Ljava/lang/Object;

    invoke-virtual {v2, v1, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    .line 439
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    const-string v5, "method"

    new-array v6, v3, [Ljava/lang/Class;

    invoke-virtual {v4, v5, v6}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    new-array v5, v3, [Ljava/lang/Object;

    invoke-virtual {v4, v1, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 440
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const-string v6, "code"

    new-array v7, v3, [Ljava/lang/Class;

    invoke-virtual {v5, v6, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v5

    new-array v3, v3, [Ljava/lang/Object;

    invoke-virtual {v5, p0, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    .line 442
    sget-object v3, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v5, "=== Failed API Request ==="

    invoke-virtual {v3, v5}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V

    .line 443
    sget-object v3, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, " \u2192 HTTP "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v3, p0}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V

    .line 445
    invoke-static {v1}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->logRequestDetails(Ljava/lang/Object;)V

    if-eqz p1, :cond_1

    .line 448
    sget-object p0, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_1
    :goto_0
    return-void

    :catch_0
    move-exception p0

    .line 451
    sget-object p1, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v0, "logFailedApiRequest failed"

    invoke-virtual {p1, v0, p0}, Lapp/revanced/extension/gamehub/util/GHLog;->w(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static logRequestDetails(Ljava/lang/Object;)V
    .locals 12

    const/4 v0, 0x1

    const/4 v1, 0x0

    .line 462
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const-string v3, "headers"

    new-array v4, v1, [Ljava/lang/Class;

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    new-array v3, v1, [Ljava/lang/Object;

    invoke-virtual {v2, p0, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    .line 463
    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    const-string v4, "size"

    new-array v5, v1, [Ljava/lang/Class;

    invoke-virtual {v3, v4, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    .line 464
    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    const-string v5, "name"

    new-array v6, v0, [Ljava/lang/Class;

    sget-object v7, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v7, v6, v1

    invoke-virtual {v4, v5, v6}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    .line 465
    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const-string v6, "value"

    new-array v7, v0, [Ljava/lang/Class;

    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v8, v7, v1

    invoke-virtual {v5, v6, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v5

    .line 466
    new-array v6, v1, [Ljava/lang/Object;

    invoke-virtual {v3, v2, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    move v6, v1

    :goto_0
    if-ge v6, v3, :cond_0

    .line 468
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    filled-new-array {v7}, [Ljava/lang/Object;

    move-result-object v7

    invoke-virtual {v4, v2, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    .line 469
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    filled-new-array {v8}, [Ljava/lang/Object;

    move-result-object v8

    invoke-virtual {v5, v2, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    .line 470
    sget-object v9, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "  "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v10, ": "

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v9, v7}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 473
    :catch_0
    sget-object v2, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v3, "Request headers: <unreadable>"

    invoke-virtual {v2, v3}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V

    .line 478
    :cond_0
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const-string v3, "body"

    new-array v4, v1, [Ljava/lang/Class;

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    new-array v3, v1, [Ljava/lang/Object;

    invoke-virtual {v2, p0, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_3

    .line 480
    invoke-static {p0}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getBodyContentType(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    .line 481
    invoke-static {v2}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isTextContentType(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 482
    const-string v2, "okio.Buffer"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    .line 483
    new-array v3, v1, [Ljava/lang/Class;

    invoke-virtual {v2, v3}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v3

    new-array v4, v1, [Ljava/lang/Object;

    invoke-virtual {v3, v4}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    .line 484
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    const-string v5, "writeTo"

    new-array v0, v0, [Ljava/lang/Class;

    const-string v6, "okio.BufferedSink"

    .line 485
    invoke-static {v6}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v6

    aput-object v6, v0, v1

    invoke-virtual {v4, v5, v0}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v4

    .line 486
    invoke-virtual {v0, p0, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 487
    const-string p0, "readUtf8"

    new-array v0, v1, [Ljava/lang/Class;

    invoke-virtual {v2, p0, v0}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    new-array v0, v1, [Ljava/lang/Object;

    invoke-virtual {p0, v3, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    if-eqz p0, :cond_3

    .line 488
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_3

    .line 489
    sget-object v0, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Request body: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V

    goto :goto_2

    .line 492
    :cond_1
    invoke-static {p0}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getBodyContentLength(Ljava/lang/Object;)J

    move-result-wide v0

    .line 493
    sget-object p0, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Request body: <binary "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-wide/16 v3, 0x0

    cmp-long v3, v0, v3

    if-ltz v3, :cond_2

    .line 494
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, ", "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " bytes>"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_1

    :cond_2
    const-string v0, ">"

    :goto_1
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 493
    invoke-virtual {p0, v0}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_2

    .line 498
    :catch_1
    sget-object p0, Lapp/revanced/extension/gamehub/util/GHLog;->NET:Lapp/revanced/extension/gamehub/util/GHLog;

    const-string v0, "Request body: <unreadable>"

    invoke-virtual {p0, v0}, Lapp/revanced/extension/gamehub/util/GHLog;->d(Ljava/lang/String;)V

    :cond_3
    :goto_2
    return-void
.end method

.method public static setStoragePath(Ljava/lang/String;)V
    .locals 2

    .line 341
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "steam_storage_path"

    invoke-interface {v0, v1, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method public static shouldForceEnableSteamInput(Z)Z
    .locals 1

    .line 46
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->isExternalAPI()Z

    move-result v0

    if-nez v0, :cond_1

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x1

    return p0
.end method

# Cycles api_source: 0 (GameHub) → 1 (EmuReady) → 2 (BannerHub) → 0
.method public static toggleAPI()V
    .locals 4

    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getApiSource()I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    const/4 v1, 0x3

    rem-int v0, v0, v1

    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "api_source"

    invoke-interface {v2, v3, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method public static toggleStorageLocation()V
    .locals 4

    .line 128
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    .line 129
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const/4 v2, 0x0

    .line 130
    const-string v3, "use_custom_storage"

    invoke-interface {v0, v3, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    invoke-interface {v1, v3, v0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 131
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method public static useInternalStorage()V
    .locals 3

    .line 348
    invoke-static {}, Lapp/revanced/extension/gamehub/prefs/GameHubPrefs;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "use_custom_storage"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method
