.class public Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.source "SourceFile"

# Handler.post Runnable: shows a Toast on the main thread with the root grant result.

.field final a:Landroid/content/Context;
.field final b:Z


.method public constructor <init>(Landroid/content/Context;Z)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1$1;->a:Landroid/content/Context;

    iput p2, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1$1;->b:Z

    return-void
.end method


.method public run()V
    .locals 3

    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1$1;->a:Landroid/content/Context;

    iget-boolean v1, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2$1$1;->b:Z

    if-eqz v1, :cond_denied

    const-string v1, "Root access granted! Open the in-game Performance menu to activate controls."

    goto :do_toast

    :cond_denied

    const-string v1, "Root access was denied or is not available on this device."

    :do_toast

    const/4 v2, 0x1

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method
