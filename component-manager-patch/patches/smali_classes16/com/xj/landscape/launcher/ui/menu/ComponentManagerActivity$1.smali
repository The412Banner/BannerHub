.class Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# Background thread: calls WcpExtractor.extract(), posts result to UI via Handler
# On success, queries the injected filename and saves it to SharedPreferences

.field final this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
.field final val$uri:Landroid/net/Uri;
.field final val$componentDir:Ljava/io/File;
.field final val$handler:Landroid/os/Handler;

.method constructor <init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;Landroid/net/Uri;Ljava/io/File;Landroid/os/Handler;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;->val$uri:Landroid/net/Uri;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;->val$componentDir:Ljava/io/File;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;->val$handler:Landroid/os/Handler;
    return-void
.end method

.method public run()V
    .locals 6

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;->this$0:Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;->val$handler:Landroid/os/Handler;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;->val$uri:Landroid/net/Uri;
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;->val$componentDir:Ljava/io/File;

    invoke-virtual {v0}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v4

    :try_start
    invoke-static {v4, v2, v3}, Lcom/xj/landscape/launcher/ui/menu/WcpExtractor;->extract(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/io/File;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch_t

    # Success: query filename from URI using activity helper, then save to SharedPreferences
    # v0=activity, v1=handler, v2=uri, v3=componentDir are all still valid
    invoke-virtual {v0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->getFileName(Landroid/net/Uri;)Ljava/lang/String;
    move-result-object v5

    const-string v2, "bh_injected"
    const/4 v4, 0x0
    invoke-virtual {v0, v2, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v3
    invoke-interface {v2, v3, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v2
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Post UI runnable with null result (success)
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2;
    const/4 v3, 0x0
    invoke-direct {v2, v0, v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;Ljava/lang/String;)V
    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    return-void

    :catch_t
    move-exception v2
    invoke-virtual {v2}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;
    move-result-object v2

    # Failure: post UI runnable with error message
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2;
    invoke-direct {v3, v0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;Ljava/lang/String;)V
    invoke-virtual {v1, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    return-void

.end method
