.class Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# UI thread: shows inject result toast and refreshes component list
# val$result == null means success; non-null is the error message

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
.field final val$result:Ljava/lang/String;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2;->val$result:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 4

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2;->val$result:Ljava/lang/String;

    if-nez v1, :show_error

    # Success
    const-string v2, "Injected successfully"
    const/4 v3, 0x1
    invoke-static {v0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void

    :show_error
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "Inject failed: "
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x1
    invoke-static {v0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void

.end method
