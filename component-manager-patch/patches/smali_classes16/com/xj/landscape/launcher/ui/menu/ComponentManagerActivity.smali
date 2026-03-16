.class public final Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.implements Landroid/widget/AdapterView$OnItemClickListener;

.field private listView:Landroid/widget/ListView;
.field private mode:I
.field private components:[Ljava/io/File;
.field private selectedIndex:I
.field private selectedType:I

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 5
    # v0=LinearLayout  v1=TextView/float  v2=ListView  v3=LayoutParams/tmp  v4=int/float tmp
    # p1 reused as scratch after super call

    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    # ── ListView ──────────────────────────────────────────────
    new-instance v2, Landroid/widget/ListView;
    invoke-direct {v2, p0}, Landroid/widget/ListView;-><init>(Landroid/content/Context;)V
    iput-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->listView:Landroid/widget/ListView;
    invoke-virtual {v2, p0}, Landroid/widget/AbsListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V
    # clip-to-padding false so list scrolls behind nav bar padding without items being cut off
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Landroid/view/ViewGroup;->setClipToPadding(Z)V

    # ── Title TextView ────────────────────────────────────────
    new-instance v1, Landroid/widget/TextView;
    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v3, "Banners Component Manager"
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    # text size 18sp
    const/high16 v3, 0x41900000
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setTextSize(F)V
    # text color white
    const v3, -0x1
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setTextColor(I)V
    # padding: 48px left/right, 24px top/bottom
    const/16 v3, 0x30
    const/16 v4, 0x18
    invoke-virtual {v1, v3, v4, v3, v4}, Landroid/widget/TextView;->setPadding(IIII)V

    # ── LinearLayout (vertical root) ──────────────────────────
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v3, 0x1
    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V
    # fitsSystemWindows on root: pads for status bar + nav bar automatically
    invoke-virtual {v0, v3}, Landroid/view/View;->setFitsSystemWindows(Z)V

    # add TextView with MATCH_PARENT x WRAP_CONTENT
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, -0x1
    const/4 p1, -0x2
    invoke-direct {v3, v4, p1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v0, v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # add ListView with MATCH_PARENT x 0dp, weight=1 (fills remaining space)
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v4, -0x1
    const/4 p1, 0x0
    const/high16 v1, 0x3f800000
    invoke-direct {v3, v4, p1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v0, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(Landroid/view/View;)V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

# ── mode=0: lists existing components + "Add New Component" at top ──
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
    if-eqz v2, :only_add_btn
    array-length v3, v2
    if-eqz v3, :only_add_btn

    # collect dirs
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
    if-eqz v3, :only_add_btn

    new-array v5, v3, [Ljava/io/File;
    invoke-interface {v4, v5}, Ljava/util/Collection;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v5
    check-cast v5, [Ljava/io/File;
    iput-object v5, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;

    # build display list: ["+ Add New Component", dir1, dir2, ...]
    add-int/lit8 v6, v3, 0x1
    new-array v6, v6, [Ljava/lang/String;
    const/4 v7, 0x0
    const-string v8, "+ Add New Component"
    aput-object v8, v6, v7

    const/4 v7, 0x0
    :name_loop
    if-ge v7, v3, :name_done
    aget-object v8, v5, v7
    invoke-virtual {v8}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v8
    add-int/lit8 v4, v7, 0x1
    aput-object v8, v6, v4
    add-int/lit8 v7, v7, 0x1
    goto :name_loop
    :name_done

    new-instance v7, Landroid/widget/ArrayAdapter;
    sget v8, Landroid/R$layout;->simple_list_item_1:I
    invoke-direct {v7, p0, v8, v6}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;I[Ljava/lang/Object;)V
    iget-object v8, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->listView:Landroid/widget/ListView;
    invoke-virtual {v8, v7}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V
    return-void

    :only_add_btn
    # no components yet — still show Add New option
    const/4 v0, 0x0
    const/4 v1, 0x0
    new-array v1, v1, [Ljava/io/File;
    iput-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    const/4 v2, 0x1
    new-array v2, v2, [Ljava/lang/String;
    const-string v3, "+ Add New Component"
    aput-object v3, v2, v0
    new-instance v3, Landroid/widget/ArrayAdapter;
    sget v4, Landroid/R$layout;->simple_list_item_1:I
    invoke-direct {v3, p0, v4, v2}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;I[Ljava/lang/Object;)V
    iget-object v4, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->listView:Landroid/widget/ListView;
    invoke-virtual {v4, v3}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V
    return-void
.end method

# ── mode=1: options for a selected existing component ──
.method public showOptions()V
    .locals 4
    const/4 v0, 0x1
    iput v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I
    const/4 v0, 0x4
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "Inject/Replace file..."
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "Backup"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    const-string v2, "Remove"
    aput-object v2, v0, v1
    const/4 v1, 0x3
    const-string v2, "\u2190 Back"
    aput-object v2, v0, v1
    new-instance v1, Landroid/widget/ArrayAdapter;
    sget v2, Landroid/R$layout;->simple_list_item_1:I
    invoke-direct {v1, p0, v2, v0}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;I[Ljava/lang/Object;)V
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->listView:Landroid/widget/ListView;
    invoke-virtual {v2, v1}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V
    return-void
.end method

# ── mode=2: select component type for new injection ──
.method public showTypeSelection()V
    .locals 4
    const/4 v0, 0x2
    iput v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I
    const/4 v0, 0x7
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "\u2193 Download from Online Repos"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "DXVK"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    const-string v2, "VKD3D-Proton"
    aput-object v2, v0, v1
    const/4 v1, 0x3
    const-string v2, "Box64"
    aput-object v2, v0, v1
    const/4 v1, 0x4
    const-string v2, "FEXCore"
    aput-object v2, v0, v1
    const/4 v1, 0x5
    const-string v2, "GPU Driver / Turnip"
    aput-object v2, v0, v1
    const/4 v1, 0x6
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
    # p3=int position, p4+p5=long id (unused)
    iget v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I

    # mode=0: component list
    if-nez v0, :not0
    if-nez p3, :existing_comp
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showTypeSelection()V
    return-void
    :existing_comp
    add-int/lit8 v1, p3, -0x1
    iput v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showOptions()V
    return-void

    # mode=1: options for existing component
    :not0
    const/4 v1, 0x1
    if-ne v0, v1, :not1
    packed-switch p3, :sw1_data
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void

    # mode=2: type selection for new injection
    :not1
    const/4 v1, 0x2
    if-ne v0, v1, :default_back
    # position 0 = Download from Nightlies
    if-nez p3, :not_download
    const-class v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    new-instance v1, Landroid/content/Intent;
    invoke-direct {v1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    return-void
    :not_download
    add-int/lit8 v1, p3, -0x1
    packed-switch v1, :sw2_data
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void

    :default_back
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void

    # ── mode=1 switch targets ──────────────────────────
    :sw1_0
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->pickFile()V
    return-void
    :sw1_1
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->backupComponent()V
    return-void
    :sw1_2
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->removeComponent()V
    return-void
    :sw1_3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void

    # ── mode=2 switch targets ──────────────────────────
    :sw2_0
    const/16 v1, 0xc            # DXVK = 12
    goto :type_sel
    :sw2_1
    const/16 v1, 0xd            # VKD3D = 13
    goto :type_sel
    :sw2_2
    const/16 v1, 0x5e           # Box64 = 94
    goto :type_sel
    :sw2_3
    const/16 v1, 0x5f           # FEXCore = 95
    goto :type_sel
    :sw2_4
    const/16 v1, 0xa            # GPU Driver = 10
    goto :type_sel
    :sw2_5
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void

    :type_sel
    iput v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedType:I
    const/4 v0, 0x3
    iput v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->pickFile()V
    return-void

    # ── switch data tables ─────────────────────────────
    nop
    :sw1_data
    .packed-switch 0x0
        :sw1_0
        :sw1_1
        :sw1_2
        :sw1_3
    .end packed-switch

    nop
    :sw2_data
    .packed-switch 0x0
        :sw2_0
        :sw2_1
        :sw2_2
        :sw2_3
        :sw2_4
        :sw2_5
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
    .locals 3
    invoke-super {p0, p1, p2, p3}, Landroidx/appcompat/app/AppCompatActivity;->onActivityResult(IILandroid/content/Intent;)V
    const/16 v0, 0x3e9
    if-ne p1, v0, :not_our_request
    const/4 v0, -0x1
    if-ne p2, v0, :not_ok
    if-eqz p3, :not_ok
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;
    move-result-object v0
    if-eqz v0, :not_ok

    # branch on mode: 1 = replace existing, 3 = inject new
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->mode:I
    const/4 v2, 0x3
    if-ne v1, v2, :replace_mode

    # mode=3: inject new component via helper
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedType:I
    invoke-static {p0, v0, v1}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->injectComponent(Landroid/content/Context;Landroid/net/Uri;I)V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void

    :replace_mode
    # mode=1: replace existing component (original behaviour)
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
    .locals 9

    # v0 = component dir
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    aget-object v0, v0, v1

    # v3 = ContentResolver
    invoke-virtual {p0}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v3

    # Query _display_name
    move-object v4, p1
    const/4 v5, 0x1
    new-array v5, v5, [Ljava/lang/String;
    const-string v6, "_display_name"
    const/4 v7, 0x0
    aput-object v6, v5, v7
    const/4 v6, 0x0
    const/4 v7, 0x0
    const/4 v8, 0x0
    invoke-virtual/range {v3 .. v8}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    move-result-object v4

    const-string v1, "injected_file"

    if-eqz v4, :no_cursor
    invoke-interface {v4}, Landroid/database/Cursor;->moveToFirst()Z
    move-result v5
    if-eqz v5, :close_cursor
    const/4 v5, 0x0
    invoke-interface {v4, v5}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;
    move-result-object v1
    :close_cursor
    invoke-interface {v4}, Landroid/database/Cursor;->close()V
    :no_cursor

    # v2 = destination file
    new-instance v2, Ljava/io/File;
    invoke-direct {v2, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    :try_inject_start
    invoke-virtual {v3, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;
    move-result-object v4

    new-instance v5, Ljava/io/FileOutputStream;
    invoke-direct {v5, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/16 v6, 0x2000
    new-array v6, v6, [B

    :inject_read_loop
    invoke-virtual {v4, v6}, Ljava/io/InputStream;->read([B)I
    move-result v7
    if-lez v7, :inject_read_done
    const/4 v8, 0x0
    invoke-virtual {v5, v6, v8, v7}, Ljava/io/OutputStream;->write([BII)V
    goto :inject_read_loop

    :inject_read_done
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V
    invoke-virtual {v5}, Ljava/io/OutputStream;->close()V
    :try_inject_end
    .catch Ljava/lang/Exception; {:try_inject_start .. :try_inject_end} :inject_catch

    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "Injected: "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    const/4 v5, 0x1
    invoke-static {p0, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v4
    invoke-virtual {v4}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void

    :inject_catch
    move-exception v4
    invoke-virtual {v4}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
    move-result-object v4
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "Inject failed: "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4
    const/4 v5, 0x1
    invoke-static {p0, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v4
    invoke-virtual {v4}, Landroid/widget/Toast;->show()V
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

.method public removeComponent()V
    .locals 6
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->components:[Ljava/io/File;
    iget v1, p0, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->selectedIndex:I
    aget-object v0, v0, v1

    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v1

    # unregister from EmuComponents in-memory HashMap
    invoke-static {}, Lcom/xj/winemu/EmuComponents;->e()Lcom/xj/winemu/EmuComponents;
    move-result-object v2
    if-eqz v2, :skip_emu
    iget-object v3, v2, Lcom/xj/winemu/EmuComponents;->a:Ljava/util/HashMap;
    if-eqz v3, :skip_emu
    invoke-virtual {v3, v1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    :skip_emu

    # delete folder recursively
    invoke-static {v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->deleteDir(Ljava/io/File;)V

    # toast "Removed: <name>"
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "Removed: "
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2
    const/4 v3, 0x1
    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v2
    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
.end method

.method public static deleteDir(Ljava/io/File;)V
    .locals 5
    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v0
    if-eqz v0, :delete_self
    array-length v1, v0
    const/4 v2, 0x0
    :del_loop
    if-ge v2, v1, :delete_self
    aget-object v3, v0, v2
    invoke-virtual {v3}, Ljava/io/File;->isDirectory()Z
    move-result v4
    if-eqz v4, :del_file
    invoke-static {v3}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->deleteDir(Ljava/io/File;)V
    goto :del_next
    :del_file
    invoke-virtual {v3}, Ljava/io/File;->delete()Z
    :del_next
    add-int/lit8 v2, v2, 0x1
    goto :del_loop
    :delete_self
    invoke-virtual {p0}, Ljava/io/File;->delete()Z
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
