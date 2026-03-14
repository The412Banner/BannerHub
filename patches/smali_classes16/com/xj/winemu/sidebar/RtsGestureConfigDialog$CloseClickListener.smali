.class public Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$CloseClickListener;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "CloseClickListener"
.end annotation

# instance fields
.field final synthetic this$0:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;

# direct methods
.method public constructor <init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;)V
    .locals 0

    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$CloseClickListener;->this$0:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 1

    :try_start
    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$CloseClickListener;->this$0:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    if-eqz v0, :cond_end
    
    iget-object v0, v0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->dialog:Landroid/app/Dialog;
    if-eqz v0, :cond_end
    
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch_err
    
    :catch_err
    :cond_end
    return-void
.end method
