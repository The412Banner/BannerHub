.class public Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$AppPopupDismissListener;
.super Ljava/lang/Object;
.implements Landroidx/appcompat/widget/PopupMenu$OnDismissListener;

# instance fields
.field private final owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;

# direct methods
.method public constructor <init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$AppPopupDismissListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    return-void
.end method

# virtual methods
.method public onDismiss(Landroidx/appcompat/widget/PopupMenu;)V
    .locals 1
    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$AppPopupDismissListener;->owner:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    invoke-virtual {v0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->applyPendingSelectionIfAny()V
    return-void
.end method
