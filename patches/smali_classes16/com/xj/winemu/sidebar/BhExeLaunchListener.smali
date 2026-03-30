.class public Lcom/xj/winemu/sidebar/BhExeLaunchListener;
.super Ljava/lang/Object;
.source "SourceFile"

# onClick: show a "Launching: <name>" Toast then call BhWineLaunchHelper.launchExe.

.implements Landroid/view/View$OnClickListener;

.field public final fragment:Lcom/xj/winemu/sidebar/BhTaskManagerFragment;
.field public final exePath:Ljava/lang/String;

.method public constructor <init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhExeLaunchListener;->fragment:Lcom/xj/winemu/sidebar/BhTaskManagerFragment;
    iput-object p2, p0, Lcom/xj/winemu/sidebar/BhExeLaunchListener;->exePath:Ljava/lang/String;
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 5
    # v0 = context
    # v1 = exePath
    # v2 = filename (last path segment)
    # v3 = toast message
    # v4 = last-slash position / StringBuilder

    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhExeLaunchListener;->fragment:Lcom/xj/winemu/sidebar/BhTaskManagerFragment;
    iget-object v0, v0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->bhContext:Landroid/content/Context;
    if-eqz v0, :launch

    iget-object v1, p0, Lcom/xj/winemu/sidebar/BhExeLaunchListener;->exePath:Ljava/lang/String;

    # Extract filename: find last '/' then substring from there+1
    const/16 v4, 0x2f    # '/'
    invoke-virtual {v1, v4}, Ljava/lang/String;->lastIndexOf(I)I
    move-result v4
    if-ltz v4, :use_full_path
    add-int/lit8 v4, v4, 0x1
    invoke-virtual {v1, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v2
    goto :build_toast

    :use_full_path
    move-object v2, v1

    :build_toast
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Launching: "
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3

    const/4 v4, 0x0    # Toast.LENGTH_SHORT
    invoke-static {v0, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v3
    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    :launch
    iget-object v1, p0, Lcom/xj/winemu/sidebar/BhExeLaunchListener;->exePath:Ljava/lang/String;
    invoke-static {v1}, Lapp/revanced/extension/gamehub/BhWineLaunchHelper;->launchExe(Ljava/lang/String;)V
    return-void
.end method
