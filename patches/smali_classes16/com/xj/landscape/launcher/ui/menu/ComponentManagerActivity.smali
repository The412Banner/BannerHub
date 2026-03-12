.class public final Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.implements Landroid/widget/AdapterView$OnItemClickListener;

.field private listView:Landroid/widget/ListView;
.field private mode:I
.field private components:[Ljava/io/File;
.field private selectedIndex:I

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V
    new-instance v0, Landroid/widget/ListView;
    invoke-direct {v0, p0}, Landroid/widget/ListView;-><init>(Landroid/content/Context;)V
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->listView:Landroid/widget/ListView;
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(Landroid/view/View;)V
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->listView:Landroid/widget/ListView;
    invoke-virtual {v0, p0}, Landroid/widget/AbsListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V
    const-string v0, "Component Manager"
    invoke-virtual {p0, v0}, Landroid/app/Activity;->setTitle(Ljava/lang/CharSequence;)V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

.method public showComponents()V
    .locals 9
    const/4 v0, 0x0
    iput v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I
    new-instance v1, Ljava/io/File;
    invoke-virtual {p0}, Landroid/app/Activity;->getFilesDir()Ljava/io/File;
    move-result-object v2
    const-string v3, "usr/home/components"
    invoke-direct {v1, v2, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v2
    if-eqz v2, :no_components
    array-length v3, v2
    if-eqz v3, :no_components
    new-instance v4, Ljava/util/ArrayList;
    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V
    const/4 v5, 0x0
    :loop_start
    if-ge v5, v3, :loop_end
    aget-object v6, v2, v5
    invoke-virtual {v6}, Ljava/io/File;->isDirectory()Z
    move-result v7
    if-eqz v7, :not_dir
    invoke-interface {v4, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :not_dir
    add-int/lit8 v5, v5, 0x1
    goto :loop_start
    :loop_end
    invoke-interface {v4}, Ljava/util/Collection;->size()I
    move-result v3
    if-eqz v3, :no_components
    new-array v5, v3, [Ljava/io/File;
    invoke-interface {v4, v5}, Ljava/util/Collection;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v5
    check-cast v5, [Ljava/io/File;
    iput-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    new-array v6, v3, [Ljava/lang/String;
    const/4 v7, 0x0
    :name_loop
    if-ge v7, v3, :name_loop_end
    aget-object v8, v5, v7
    invoke-virtual {v8}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v8
    aput-object v8, v6, v7
    add-int/lit8 v7, v7, 0x1
    goto :name_loop
    :name_loop_end
    new-instance v7, Landroid/widget/ArrayAdapter;
    sget v8, Landroid/R$layout;->simple_list_item_1:I
    invoke-direct {v7, p0, v8, v6}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;I[Ljava/lang/Object;)V
    iget-object v8, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->listView:Landroid/widget/ListView;
    invoke-virtual {v8, v7}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V
    return-void
    :no_components
    const-string v1, "No components found"
    const/4 v2, 0x1
    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method

.method public showOptions()V
    .locals 4
    const/4 v0, 0x1
    iput v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I
    const/4 v0, 0x3
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "Inject file..."
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "Backup"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    const-string v2, "\u2190 Back"
    aput-object v2, v0, v1
    new-instance v1, Landroid/widget/ArrayAdapter;
    sget v2, Landroid/R$layout;->simple_list_item_1:I
    invoke-direct {v1, p0, v2, v0}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;I[Ljava/lang/Object;)V
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->listView:Landroid/widget/ListView;
    invoke-virtual {v2, v1}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V
    return-void
.end method

.method public onItemClick(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
    .locals 2
    iget v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I
    if-nez v0, :options_mode
    iput p3, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showOptions()V
    return-void
    :options_mode
    packed-switch p3, :pswitch_data
    goto :switch_default
    :pswitch_0
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->pickFile()V
    return-void
    :pswitch_1
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->backupComponent()V
    return-void
    :pswitch_2
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
    :switch_default
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
    nop
    :pswitch_data
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
.end method

.method public pickFile()V
    .locals 2
    new-instance v0, Landroid/content/Intent;
    const-string v1, "android.intent.action.OPEN_DOCUMENT"
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v1, "android.intent.category.OPENABLE"
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;
    const-string v1, "*/*"
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;
    const/16 v1, 0x3e9
    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V
    return-void
.end method

.method public backupComponent()V
    .locals 6
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    aget-object v0, v0, v1
    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v1
    sget-object v2, Landroid/os/Environment;->DIRECTORY_DOWNLOADS:Ljava/lang/String;
    invoke-static {v2}, Landroid/os/Environment;->getExternalStoragePublicDirectory(Ljava/lang/String;)Ljava/io/File;
    move-result-object v2
    new-instance v3, Ljava/io/File;
    const-string v4, "BannerHub"
    invoke-direct {v3, v2, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v4, Ljava/io/File;
    invoke-direct {v4, v3, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v4}, Ljava/io/File;->mkdirs()Z
    :try_start
    invoke-virtual {p0, v0, v4}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->copyDir(Ljava/io/File;Ljava/io/File;)V
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_backup
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Backed up to Downloads/BannerHub/"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    const/4 v4, 0x1
    invoke-static {p0, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v3
    invoke-virtual {v3}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
    :catch_backup
    move-exception v3
    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Backup failed: "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    const/4 v4, 0x1
    invoke-static {p0, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v3
    invoke-virtual {v3}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

.method public copyDir(Ljava/io/File;Ljava/io/File;)V
    .locals 9
    invoke-virtual {p2}, Ljava/io/File;->mkdirs()Z
    invoke-virtual {p1}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v0
    if-eqz v0, :copy_done
    array-length v1, v0
    const/4 v2, 0x0
    :copy_loop
    if-ge v2, v1, :copy_done
    aget-object v3, v0, v2
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z
    move-result v4
    if-eqz v4, :copy_file
    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v4
    new-instance v5, Ljava/io/File;
    invoke-direct {v5, p2, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {p0, v3, v5}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->copyDir(Ljava/io/File;Ljava/io/File;)V
    goto :copy_next
    :copy_file
    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v4
    new-instance v5, Ljava/io/File;
    invoke-direct {v5, p2, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v6, Ljava/io/FileInputStream;
    invoke-direct {v6, v3}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    new-instance v7, Ljava/io/FileOutputStream;
    invoke-direct {v7, v5}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    const/16 v8, 0x2000
    new-array v8, v8, [B
    :read_loop
    invoke-virtual {v6, v8}, Ljava/io/InputStream;->read([B)I
    move-result v4
    if-lez v4, :read_done
    const/4 v5, 0x0
    invoke-virtual {v7, v8, v5, v4}, Ljava/io/OutputStream;->write([BII)V
    goto :read_loop
    :read_done
    invoke-virtual {v6}, Ljava/io/InputStream;->close()V
    invoke-virtual {v7}, Ljava/io/OutputStream;->close()V
    :copy_next
    add-int/lit8 v2, v2, 0x1
    goto :copy_loop
    :copy_done
    return-void
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 2
    invoke-super {p0, p1, p2, p3}, Landroidx/appcompat/app/AppCompatActivity;->onActivityResult(IILandroid/content/Intent;)V
    const/16 v0, 0x3e9
    if-ne p1, v0, :not_our_request
    const/4 v0, -0x1
    if-ne p2, v0, :not_ok
    if-eqz p3, :not_ok
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;
    move-result-object v0
    if-eqz v0, :not_ok
    invoke-virtual {p0, v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->injectFile(Landroid/net/Uri;)V
    return-void
    :not_ok
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
    :not_our_request
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

.method public injectFile(Landroid/net/Uri;)V
    .locals 4

    # v0 = component dir
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    aget-object v0, v0, v1

    # v1 = Handler(mainLooper)
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    new-instance v2, Landroid/os/Handler;
    invoke-direct {v2, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    # v1 = background worker runnable
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;
    invoke-direct {v1, p0, p1, v0, v2}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;Landroid/net/Uri;Ljava/io/File;Landroid/os/Handler;)V

    # Start background thread
    new-instance v3, Ljava/lang/Thread;
    invoke-direct {v3, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v3}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public onBackPressed()V
    .locals 1
    iget v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I
    if-eqz v0, :call_super
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
    :call_super
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onBackPressed()V
    return-void
.end method
