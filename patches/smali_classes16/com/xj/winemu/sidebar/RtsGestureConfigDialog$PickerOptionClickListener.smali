.class public Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# instance fields
.field private final owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
.field private final key:Ljava/lang/String;
.field private final optionIndex:I
.field private final dialog:Landroid/app/Dialog;

# direct methods
.method public constructor <init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    iput-object p2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;->key:Ljava/lang/String;
    iput p3, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;->optionIndex:I
    iput-object p4, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;->dialog:Landroid/app/Dialog;
    return-void
.end method

# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 4

    :try_start
    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    if-eqz v0, :try_end
    
    iget-object v1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;->key:Ljava/lang/String;
    if-eqz v1, :try_end

    iget v2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;->optionIndex:I

    # Persist immediately to MMKV
    invoke-static {v1, v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->setRtsGestureAction(Ljava/lang/String;I)V

    # Update label text immediately so user sees the change
    invoke-virtual {v0, v1}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->updateActionLabelForKey(Ljava/lang/String;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch_err

    # Dismiss dialog safely
    iget-object v3, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;->dialog:Landroid/app/Dialog;
    if-eqz v3, :cond_done
    :try_dismiss
    invoke-virtual {v3}, Landroid/app/Dialog;->dismiss()V
    :try_dismiss_end
    .catch Ljava/lang/Throwable; {:try_dismiss .. :try_dismiss_end} :dismiss_err
    
    :dismiss_err
    :cond_done
    return-void

    :catch_err
    return-void
.end method
