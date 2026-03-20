.class public Lcom/xj/winemu/sidebar/BhRootGrantHelper$2;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;
.source "SourceFile"

# "Grant Access" button listener — starts a worker thread to run su.

.field final a:Landroid/content/Context;
.field final b:Landroid/content/SharedPreferences;


.method public constructor <init>(Landroid/content/Context;Landroid/content/SharedPreferences;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2;->a:Landroid/content/Context;

    iput-object p2, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2;->b:Landroid/content/SharedPreferences;

    return-void
.end method


.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 4

    # new Thread(new BhRootGrantHelper$2$1(ctx, prefs)).start();
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1;

    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2;->a:Landroid/content/Context;

    iget-object v3, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2;->b:Landroid/content/SharedPreferences;

    invoke-direct {v1, v2, v3}, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1;-><init>(Landroid/content/Context;Landroid/content/SharedPreferences;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method
