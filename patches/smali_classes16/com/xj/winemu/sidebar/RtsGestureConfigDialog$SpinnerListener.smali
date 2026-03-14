.class public Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$SpinnerListener;
.super Ljava/lang/Object;
.source "RtsGestureConfigDialog.java"

# interfaces
.implements Landroid/widget/AdapterView$OnItemSelectedListener;

# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "SpinnerListener"
.end annotation

# instance fields
.field final synthetic this$0:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
.field private gestureName:Ljava/lang/String;

# direct methods
.method public constructor <init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$SpinnerListener;->this$0:Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$SpinnerListener;->gestureName:Ljava/lang/String;

    return-void
.end method

# virtual methods
.method public onItemSelected(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
    .locals 1

    # Get gesture name
    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$SpinnerListener;->gestureName:Ljava/lang/String;
    if-eqz v0, :cond_done
    
    # Save the action index
    invoke-static {v0, p3}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->setRtsGestureAction(Ljava/lang/String;I)V
    
    :cond_done
    return-void
.end method

.method public onNothingSelected(Landroid/widget/AdapterView;)V
    .locals 0
    return-void
.end method
