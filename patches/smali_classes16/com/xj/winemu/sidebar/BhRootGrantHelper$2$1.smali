.class public Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "SourceFile"

# Worker thread: runs "su -c id", stores result in prefs, posts toast to main thread.

.field final a:Landroid/content/Context;
.field final b:Landroid/content/SharedPreferences;


.method public constructor <init>(Landroid/content/Context;Landroid/content/SharedPreferences;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1;->a:Landroid/content/Context;

    iput-object p2, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1;->b:Landroid/content/SharedPreferences;

    return-void
.end method


.method public run()V
    .locals 8

    :try_start_0

    # Process p = Runtime.getRuntime().exec(new String[]{"su", "-c", "id"});
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v0

    const/4 v1, 0x3

    new-array v1, v1, [Ljava/lang/String;

    const-string v2, "su"

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const-string v2, "-c"

    const/4 v3, 0x1

    aput-object v2, v1, v3

    const-string v2, "id"

    const/4 v3, 0x2

    aput-object v2, v1, v3

    invoke-virtual {v0, v1}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v0

    # int exit = p.waitFor();
    invoke-virtual {v0}, Ljava/lang/Process;->waitFor()I

    move-result v1

    # p.destroy();
    invoke-virtual {v0}, Ljava/lang/Process;->destroy()V

    # boolean granted = (exit == 0);
    const/4 v2, 0x0

    if-nez v1, :cond_denied

    const/4 v2, 0x1

    :cond_denied

    # prefs.edit().putBoolean("root_granted", granted).apply();
    iget-object v3, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1;->b:Landroid/content/SharedPreferences;

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v4, "root_granted"

    invoke-interface {v3, v4, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V

    # new Handler(Looper.getMainLooper()).post(new BhRootGrantHelper$2$1$1(ctx, granted));
    new-instance v3, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v4

    invoke-direct {v3, v4}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v4, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1$1;

    iget-object v5, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1;->a:Landroid/content/Context;

    invoke-direct {v4, v5, v2}, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1$1;-><init>(Landroid/content/Context;Z)V

    invoke-virtual {v3, v4}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0

    return-void
.end method
