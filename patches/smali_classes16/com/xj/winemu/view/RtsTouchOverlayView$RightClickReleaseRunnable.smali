.class Lcom/xj/winemu/view/RtsTouchOverlayView$RightClickReleaseRunnable;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;

# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/xj/winemu/view/RtsTouchOverlayView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "RightClickReleaseRunnable"
.end annotation

# instance fields
.field final synthetic this$0:Lcom/xj/winemu/view/RtsTouchOverlayView;

# direct methods
.method public constructor <init>(Lcom/xj/winemu/view/RtsTouchOverlayView;)V
    .locals 0

    iput-object p1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView$RightClickReleaseRunnable;->this$0:Lcom/xj/winemu/view/RtsTouchOverlayView;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# virtual methods
.method public run()V
    .locals 6

    # Get parent view's WinUIBridge
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView$RightClickReleaseRunnable;->this$0:Lcom/xj/winemu/view/RtsTouchOverlayView;
    iget-object v0, v0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    # Check X11Controller is ready
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Release: c0(0, 0, button=3, isDown=false, isRelative=true)
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x3  # button 3 = right click
    const/4 v4, 0x0  # isDown = false (release)
    const/4 v5, 0x1
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    :cond_end
    return-void
.end method
