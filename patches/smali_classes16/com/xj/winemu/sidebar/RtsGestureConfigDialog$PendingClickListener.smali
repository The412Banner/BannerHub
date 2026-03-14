.class public Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PendingClickListener;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;

# instance fields
.field private final owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
.field private final key:Ljava/lang/String;

# direct methods
.method public constructor <init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PendingClickListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    iput-object p2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PendingClickListener;->key:Ljava/lang/String;
    return-void
.end method

# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 4

    :try_start
    if-eqz p1, :try_end
    
    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PendingClickListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    if-eqz v0, :try_end
    
    iget-object v1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PendingClickListener;->key:Ljava/lang/String;
    if-eqz v1, :try_end

    # Persist immediately to MMKV
    invoke-static {v1, p2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->setRtsGestureAction(Ljava/lang/String;I)V

    # Update label text immediately so user sees the change
    invoke-virtual {v0, v1}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->updateActionLabelForKey(Ljava/lang/String;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch_err

    # Dismiss dialog safely
    if-eqz p1, :cond_done
    :try_dismiss
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V
    :try_dismiss_end
    .catch Ljava/lang/Throwable; {:try_dismiss .. :try_dismiss_end} :dismiss_err
    
    :dismiss_err
    :cond_done
    return-void

    :catch_err
    const/4 v3, 0x0
    return-void
.end method
