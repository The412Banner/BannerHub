.class public Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$MenuClickListener;
.super Ljava/lang/Object;
.implements Landroid/widget/PopupMenu$OnMenuItemClickListener;

# instance fields
.field private final owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
.field private final key:Ljava/lang/String;

# direct methods
.method public constructor <init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$MenuClickListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    iput-object p2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$MenuClickListener;->key:Ljava/lang/String;
    return-void
.end method

# virtual methods
.method public onMenuItemClick(Landroid/view/MenuItem;)Z
    .locals 5

    if-eqz p1, :cond_false
    :try_start
    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I
    move-result v0

    iget-object v1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$MenuClickListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    iget-object v2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$MenuClickListener;->key:Ljava/lang/String;
    invoke-virtual {v1, v2, v0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->setPendingSelection(Ljava/lang/String;I)V

    const/4 v3, 0x1
    return v3
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch_err

    :catch_err
    const/4 v4, 0x0
    return v4

    :cond_false
    const/4 v0, 0x0
    return v0
.end method
