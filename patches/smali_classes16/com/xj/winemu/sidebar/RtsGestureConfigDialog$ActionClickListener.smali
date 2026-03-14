.class public Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$ActionClickListener;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;

# instance fields
.field private final owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
.field private final key:Ljava/lang/String;

# direct methods
.method public constructor <init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$ActionClickListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    iput-object p2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$ActionClickListener;->key:Ljava/lang/String;
    return-void
.end method

# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 3

    # Persist selection
    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$ActionClickListener;->key:Ljava/lang/String;
    invoke-static {v0, p2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->setRtsGestureAction(Ljava/lang/String;I)V

    # Update label text directly without rebuilding dialog
    iget-object v1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$ActionClickListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    iget-object v2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$ActionClickListener;->key:Ljava/lang/String;
    invoke-virtual {v1, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->updateActionLabelForKey(Ljava/lang/String;)V

    if-eqz p1, :cond_end
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    :cond_end
    return-void
.end method
