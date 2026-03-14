.class public final Lcom/winemu/core/controller/X11Controller;
.super Ljava/lang/Object;
.source "r8-map-id-712846b76e3224c0169ce621759774aea144e14d75c3fb3c733f7f2b03c1bb19"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/winemu/core/controller/X11Controller$Companion;,
        Lcom/winemu/core/controller/X11Controller$WindowEventCallback;
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
.end annotation


# static fields
.field public static final f:Lcom/winemu/core/controller/X11Controller$Companion;


# instance fields
.field public a:Lcom/winemu/ui/X11View;

.field public b:Lcom/winemu/core/input/TouchInputManager;

.field public c:Landroid/view/ViewGroup;

.field public d:Landroid/app/Activity;

.field public e:Lcom/winemu/core/controller/X11Controller$WindowEventCallback;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    new-instance v0, Lcom/winemu/core/controller/X11Controller$Companion;

    .line 2
    .line 3
    const/4 v1, 0x0

    .line 4
    invoke-direct {v0, v1}, Lcom/winemu/core/controller/X11Controller$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 5
    .line 6
    .line 7
    sput-object v0, Lcom/winemu/core/controller/X11Controller;->f:Lcom/winemu/core/controller/X11Controller$Companion;

    .line 8
    .line 9
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static final C(Lcom/winemu/ui/X11View;Lcom/winemu/core/controller/X11Controller;Z)V
    .locals 0

    .line 1
    if-eqz p2, :cond_1

    .line 2
    .line 3
    new-instance p2, Lcom/winemu/core/controller/n;

    .line 4
    .line 5
    invoke-direct {p2, p1}, Lcom/winemu/core/controller/n;-><init>(Lcom/winemu/core/controller/X11Controller;)V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p0, p2}, Landroid/view/View;->setOnCapturedPointerListener(Landroid/view/View$OnCapturedPointerListener;)V

    .line 9
    .line 10
    .line 11
    iget-object p1, p1, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    .line 12
    .line 13
    if-nez p1, :cond_0

    .line 14
    .line 15
    const-string p1, "inputManager"

    .line 16
    .line 17
    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 18
    .line 19
    .line 20
    const/4 p1, 0x0

    .line 21
    :cond_0
    const/high16 p2, 0x3f800000    # 1.0f

    .line 22
    .line 23
    invoke-virtual {p1, p2}, Lcom/winemu/core/input/TouchInputManager;->z(F)V

    .line 24
    .line 25
    .line 26
    invoke-virtual {p0}, Landroid/view/View;->requestPointerCapture()V

    .line 27
    .line 28
    .line 29
    return-void

    .line 30
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->releasePointerCapture()V

    .line 31
    .line 32
    .line 33
    return-void
.end method

.method public static final D(Lcom/winemu/core/controller/X11Controller;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 2

    .line 1
    iget-object p1, p0, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    .line 2
    .line 3
    const/4 v0, 0x0

    .line 4
    if-nez p1, :cond_0

    .line 5
    .line 6
    const-string p1, "inputManager"

    .line 7
    .line 8
    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    move-object p1, v0

    .line 12
    :cond_0
    iget-object v1, p0, Lcom/winemu/core/controller/X11Controller;->c:Landroid/view/ViewGroup;

    .line 13
    .line 14
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 15
    .line 16
    .line 17
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 18
    .line 19
    if-nez p0, :cond_1

    .line 20
    .line 21
    const-string p0, "x11View"

    .line 22
    .line 23
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 24
    .line 25
    .line 26
    goto :goto_0

    .line 27
    :cond_1
    move-object v0, p0

    .line 28
    :goto_0
    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 29
    .line 30
    .line 31
    invoke-virtual {p1, v1, v0, p2}, Lcom/winemu/core/input/TouchInputManager;->u(Landroid/view/View;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 32
    .line 33
    .line 34
    move-result p0

    .line 35
    return p0
.end method

.method public static synthetic a(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    invoke-static {p0, p1, p2, p3}, Lcom/winemu/core/controller/X11Controller;->z(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 2
    .line 3
    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic b(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    invoke-static {p0, p1, p2, p3}, Lcom/winemu/core/controller/X11Controller;->y(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 2
    .line 3
    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic c(Lcom/winemu/ui/X11View;Lcom/winemu/core/controller/X11Controller;Z)V
    .locals 0

    .line 1
    invoke-static {p0, p1, p2}, Lcom/winemu/core/controller/X11Controller;->C(Lcom/winemu/ui/X11View;Lcom/winemu/core/controller/X11Controller;Z)V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static synthetic d(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    invoke-static {p0, p1, p2, p3}, Lcom/winemu/core/controller/X11Controller;->x(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 2
    .line 3
    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic e(Lcom/winemu/core/controller/X11Controller;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    invoke-static {p0, p1, p2}, Lcom/winemu/core/controller/X11Controller;->D(Lcom/winemu/core/controller/X11Controller;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 2
    .line 3
    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static final synthetic f(Lcom/winemu/core/controller/X11Controller;)Lcom/winemu/core/input/TouchInputManager;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic g(Lcom/winemu/core/controller/X11Controller;)V
    .locals 0

    .line 1
    invoke-virtual {p0}, Lcom/winemu/core/controller/X11Controller;->m()V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static final synthetic h(Lcom/winemu/core/controller/X11Controller;)V
    .locals 0

    .line 1
    invoke-virtual {p0}, Lcom/winemu/core/controller/X11Controller;->n()V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static final x(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 1

    .line 1
    iget-object p2, p0, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    .line 2
    .line 3
    const/4 v0, 0x0

    .line 4
    if-nez p2, :cond_0

    .line 5
    .line 6
    const-string p2, "inputManager"

    .line 7
    .line 8
    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    move-object p2, v0

    .line 12
    :cond_0
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 13
    .line 14
    if-nez p0, :cond_1

    .line 15
    .line 16
    const-string p0, "x11View"

    .line 17
    .line 18
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 19
    .line 20
    .line 21
    goto :goto_0

    .line 22
    :cond_1
    move-object v0, p0

    .line 23
    :goto_0
    invoke-static {p3}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 24
    .line 25
    .line 26
    invoke-virtual {p2, p1, v0, p3}, Lcom/winemu/core/input/TouchInputManager;->u(Landroid/view/View;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 27
    .line 28
    .line 29
    move-result p0

    .line 30
    return p0
.end method

.method public static final y(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 1

    .line 1
    iget-object p2, p0, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    .line 2
    .line 3
    const/4 v0, 0x0

    .line 4
    if-nez p2, :cond_0

    .line 5
    .line 6
    const-string p2, "inputManager"

    .line 7
    .line 8
    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    move-object p2, v0

    .line 12
    :cond_0
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 13
    .line 14
    if-nez p0, :cond_1

    .line 15
    .line 16
    const-string p0, "x11View"

    .line 17
    .line 18
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 19
    .line 20
    .line 21
    goto :goto_0

    .line 22
    :cond_1
    move-object v0, p0

    .line 23
    :goto_0
    invoke-static {p3}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 24
    .line 25
    .line 26
    invoke-virtual {p2, p1, v0, p3}, Lcom/winemu/core/input/TouchInputManager;->u(Landroid/view/View;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 27
    .line 28
    .line 29
    move-result p0

    .line 30
    return p0
.end method

.method public static final z(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 1

    .line 1
    iget-object p2, p0, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    .line 2
    .line 3
    const/4 v0, 0x0

    .line 4
    if-nez p2, :cond_0

    .line 5
    .line 6
    const-string p2, "inputManager"

    .line 7
    .line 8
    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    move-object p2, v0

    .line 12
    :cond_0
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 13
    .line 14
    if-nez p0, :cond_1

    .line 15
    .line 16
    const-string p0, "x11View"

    .line 17
    .line 18
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 19
    .line 20
    .line 21
    goto :goto_0

    .line 22
    :cond_1
    move-object v0, p0

    .line 23
    :goto_0
    invoke-static {p3}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 24
    .line 25
    .line 26
    invoke-virtual {p2, p1, v0, p3}, Lcom/winemu/core/input/TouchInputManager;->u(Landroid/view/View;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 27
    .line 28
    .line 29
    move-result p0

    .line 30
    return p0
.end method


# virtual methods
.method public final A(Landroid/app/Activity;)V
    .locals 4

    .line 1
    new-instance v0, Lcom/winemu/core/input/TouchInputManager;

    .line 2
    .line 3
    new-instance v1, Lcom/winemu/core/input/TouchInputManager$RenderStub$NullStub;

    .line 4
    .line 5
    invoke-direct {v1}, Lcom/winemu/core/input/TouchInputManager$RenderStub$NullStub;-><init>()V

    .line 6
    .line 7
    .line 8
    new-instance v2, Lcom/winemu/core/input/TouchEventDispatcher;

    .line 9
    .line 10
    new-instance v3, Lcom/winemu/core/controller/X11Controller$setupInputManager$1;

    .line 11
    .line 12
    invoke-direct {v3}, Lcom/winemu/core/controller/X11Controller$setupInputManager$1;-><init>()V

    .line 13
    .line 14
    .line 15
    invoke-direct {v2, v3}, Lcom/winemu/core/input/TouchEventDispatcher;-><init>(Lcom/winemu/core/input/InputCallback;)V

    .line 16
    .line 17
    .line 18
    invoke-direct {v0, p1, v1, v2}, Lcom/winemu/core/input/TouchInputManager;-><init>(Landroid/content/Context;Lcom/winemu/core/input/TouchInputManager$RenderStub;Lcom/winemu/core/input/TouchEventDispatcher;)V

    .line 19
    .line 20
    .line 21
    iput-object v0, p0, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    .line 22
    .line 23
    return-void
.end method

.method public final B(Landroid/app/Activity;Lcom/winemu/core/gamepad/GamepadManager;)V
    .locals 1

    .line 1
    new-instance v0, Lcom/winemu/ui/X11View;

    .line 2
    .line 3
    invoke-direct {v0, p1}, Lcom/winemu/ui/X11View;-><init>(Landroid/content/Context;)V

    .line 4
    .line 5
    .line 6
    iput-object v0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 7
    .line 8
    invoke-virtual {v0, p2}, Lcom/winemu/ui/X11View;->b(Lcom/winemu/core/gamepad/GamepadManager;)V

    .line 9
    .line 10
    .line 11
    new-instance p1, Lcom/winemu/core/controller/X11Controller$setupX11View$1$1;

    .line 12
    .line 13
    invoke-direct {p1, p0}, Lcom/winemu/core/controller/X11Controller$setupX11View$1$1;-><init>(Lcom/winemu/core/controller/X11Controller;)V

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0, p1}, Lcom/winemu/ui/X11View;->setSurfaceChangeListener(Lcom/winemu/ui/X11View$SurfaceChangeListener;)V

    .line 17
    .line 18
    .line 19
    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    .line 20
    .line 21
    .line 22
    move-result-object p1

    .line 23
    new-instance p2, Lcom/winemu/core/controller/m;

    .line 24
    .line 25
    invoke-direct {p2, v0, p0}, Lcom/winemu/core/controller/m;-><init>(Lcom/winemu/ui/X11View;Lcom/winemu/core/controller/X11Controller;)V

    .line 26
    .line 27
    .line 28
    invoke-virtual {p1, p2}, Landroid/view/ViewTreeObserver;->addOnWindowFocusChangeListener(Landroid/view/ViewTreeObserver$OnWindowFocusChangeListener;)V

    .line 29
    .line 30
    .line 31
    return-void
.end method

.method public final E(Lcom/winemu/openapi/Config$SurfaceFormat;Ljava/lang/String;)V
    .locals 2

    .line 1
    const-string v0, "format"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    const-string v0, "rootPath"

    .line 7
    .line 8
    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    sget-object v0, Lcom/winemu/core/server/XServer;->INSTANCE:Lcom/winemu/core/server/XServer;

    .line 12
    .line 13
    new-instance v1, Lcom/winemu/core/controller/X11Controller$startX11Server$1;

    .line 14
    .line 15
    invoke-direct {v1, p0}, Lcom/winemu/core/controller/X11Controller$startX11Server$1;-><init>(Ljava/lang/Object;)V

    .line 16
    .line 17
    .line 18
    invoke-virtual {v0, v1}, Lcom/winemu/core/server/XServer;->setOnWindowRealized(Lkotlin/jvm/functions/Function0;)V

    .line 19
    .line 20
    .line 21
    new-instance v1, Lcom/winemu/core/controller/X11Controller$startX11Server$2;

    .line 22
    .line 23
    invoke-direct {v1, p0}, Lcom/winemu/core/controller/X11Controller$startX11Server$2;-><init>(Ljava/lang/Object;)V

    .line 24
    .line 25
    .line 26
    invoke-virtual {v0, v1}, Lcom/winemu/core/server/XServer;->setOnWindowUnrealized(Lkotlin/jvm/functions/Function0;)V

    .line 27
    .line 28
    .line 29
    invoke-virtual {p1}, Lcom/winemu/openapi/Config$SurfaceFormat;->getValue()I

    .line 30
    .line 31
    .line 32
    move-result p0

    .line 33
    invoke-virtual {v0, p0}, Lcom/winemu/core/server/XServer;->setSurfaceFormat(I)V

    .line 34
    .line 35
    .line 36
    const/4 p0, 0x0

    .line 37
    new-array p0, p0, [Ljava/lang/String;

    .line 38
    .line 39
    invoke-virtual {v0, p2, p0}, Lcom/winemu/core/server/XServer;->start(Ljava/lang/String;[Ljava/lang/String;)Z

    .line 40
    .line 41
    .line 42
    return-void
.end method

.method public final F()V
    .locals 0

    .line 1
    sget-object p0, Lcom/winemu/core/server/XServer;->INSTANCE:Lcom/winemu/core/server/XServer;

    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/winemu/core/server/XServer;->startUI()V

    .line 4
    .line 5
    .line 6
    return-void
.end method

.method public final G()V
    .locals 0

    .line 1
    sget-object p0, Lcom/winemu/core/server/XServer;->INSTANCE:Lcom/winemu/core/server/XServer;

    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/winemu/core/server/XServer;->stop()V

    .line 4
    .line 5
    .line 6
    return-void
.end method

.method public final i(Landroid/view/ViewGroup;)V
    .locals 1

    .line 1
    const-string v0, "x11ContainerView"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    iput-object p1, p0, Lcom/winemu/core/controller/X11Controller;->c:Landroid/view/ViewGroup;

    .line 7
    .line 8
    invoke-virtual {p0}, Lcom/winemu/core/controller/X11Controller;->w()V

    .line 9
    .line 10
    .line 11
    return-void
.end method

.method public final j()Landroid/graphics/Point;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "x11View"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0}, Lcom/winemu/ui/X11View;->getScreenSize()Landroid/graphics/Point;

    .line 12
    .line 13
    .line 14
    move-result-object p0

    .line 15
    return-object p0
.end method

.method public final k(Landroid/view/MotionEvent;)Z
    .locals 4

    .line 1
    const-string v0, "event"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 7
    .line 8
    const-string v1, "x11View"

    .line 9
    .line 10
    const/4 v2, 0x0

    .line 11
    if-nez v0, :cond_0

    .line 12
    .line 13
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 14
    .line 15
    .line 16
    move-object v0, v2

    .line 17
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->hasPointerCapture()Z

    .line 18
    .line 19
    .line 20
    move-result v0

    .line 21
    if-eqz v0, :cond_3

    .line 22
    .line 23
    iget-object v0, p0, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    .line 24
    .line 25
    if-nez v0, :cond_1

    .line 26
    .line 27
    const-string v0, "inputManager"

    .line 28
    .line 29
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 30
    .line 31
    .line 32
    move-object v0, v2

    .line 33
    :cond_1
    iget-object v3, p0, Lcom/winemu/core/controller/X11Controller;->c:Landroid/view/ViewGroup;

    .line 34
    .line 35
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 36
    .line 37
    .line 38
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 39
    .line 40
    if-nez p0, :cond_2

    .line 41
    .line 42
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 43
    .line 44
    .line 45
    goto :goto_0

    .line 46
    :cond_2
    move-object v2, p0

    .line 47
    :goto_0
    invoke-virtual {v0, v3, v2, p1}, Lcom/winemu/core/input/TouchInputManager;->u(Landroid/view/View;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 48
    .line 49
    .line 50
    move-result p0

    .line 51
    return p0

    .line 52
    :cond_3
    const/4 p0, 0x0

    .line 53
    return p0
.end method

.method public final l(Landroid/app/Activity;IILcom/winemu/core/gamepad/GamepadManager;)V
    .locals 1

    .line 1
    const-string v0, "activity"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    const-string v0, "gamepadManager"

    .line 7
    .line 8
    invoke-static {p4, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    iput-object p1, p0, Lcom/winemu/core/controller/X11Controller;->d:Landroid/app/Activity;

    .line 12
    .line 13
    invoke-virtual {p0, p1, p4}, Lcom/winemu/core/controller/X11Controller;->B(Landroid/app/Activity;Lcom/winemu/core/gamepad/GamepadManager;)V

    .line 14
    .line 15
    .line 16
    invoke-virtual {p0, p1}, Lcom/winemu/core/controller/X11Controller;->A(Landroid/app/Activity;)V

    .line 17
    .line 18
    .line 19
    invoke-virtual {p0, p2, p3}, Lcom/winemu/core/controller/X11Controller;->s(II)V

    .line 20
    .line 21
    .line 22
    return-void
.end method

.method public final m()V
    .locals 2

    .line 1
    const-string v0, "X11Controller"

    .line 2
    .line 3
    const-string v1, "Window Realized"

    .line 4
    .line 5
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 6
    .line 7
    .line 8
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->e:Lcom/winemu/core/controller/X11Controller$WindowEventCallback;

    .line 9
    .line 10
    if-eqz p0, :cond_0

    .line 11
    .line 12
    invoke-interface {p0}, Lcom/winemu/core/controller/X11Controller$WindowEventCallback;->b()V

    .line 13
    .line 14
    .line 15
    :cond_0
    return-void
.end method

.method public final n()V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->e:Lcom/winemu/core/controller/X11Controller$WindowEventCallback;

    .line 2
    .line 3
    if-eqz p0, :cond_0

    .line 4
    .line 5
    invoke-interface {p0}, Lcom/winemu/core/controller/X11Controller$WindowEventCallback;->a()V

    .line 6
    .line 7
    .line 8
    :cond_0
    return-void
.end method

.method public final o()V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "x11View"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->requestFocus()Z

    .line 12
    .line 13
    .line 14
    return-void
.end method

.method public final p(IIZ)V
    .locals 0

    .line 1
    sget-object p0, Lcom/winemu/core/server/XServer;->INSTANCE:Lcom/winemu/core/server/XServer;

    .line 2
    .line 3
    invoke-virtual {p0, p1, p2, p3}, Lcom/winemu/core/server/XServer;->sendKeyEvent(IIZ)Z

    .line 4
    .line 5
    .line 6
    return-void
.end method

.method public final q(FFIZZ)V
    .locals 0

    .line 1
    sget-object p0, Lcom/winemu/core/server/XServer;->INSTANCE:Lcom/winemu/core/server/XServer;

    .line 2
    .line 3
    invoke-virtual/range {p0 .. p5}, Lcom/winemu/core/server/XServer;->sendMouseEvent(FFIZZ)V

    .line 4
    .line 5
    .line 6
    return-void
.end method

.method public final r(Z)V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "x11View"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0, p1}, Lcom/winemu/ui/X11View;->setFullScreenMode(Z)V

    .line 12
    .line 13
    .line 14
    return-void
.end method

.method public final s(II)V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "x11View"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/winemu/ui/X11View;->h(II)V

    .line 12
    .line 13
    .line 14
    return-void
.end method

.method public final t(Ljava/lang/String;)V
    .locals 0

    .line 1
    const-string p0, "shmPath"

    .line 2
    .line 3
    invoke-static {p1, p0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    sget-object p0, Lcom/winemu/core/server/XServer;->INSTANCE:Lcom/winemu/core/server/XServer;

    .line 7
    .line 8
    invoke-virtual {p0, p1}, Lcom/winemu/core/server/XServer;->setShmPath(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    return-void
.end method

.method public final u(Z)V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "inputManager"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0, p1}, Lcom/winemu/core/input/TouchInputManager;->B(Z)V

    .line 12
    .line 13
    .line 14
    return-void
.end method

.method public final v(Lcom/winemu/core/controller/X11Controller$WindowEventCallback;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/winemu/core/controller/X11Controller;->e:Lcom/winemu/core/controller/X11Controller$WindowEventCallback;

    .line 2
    .line 3
    return-void
.end method

.method public final w()V
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/winemu/core/controller/X11Controller;->c:Landroid/view/ViewGroup;

    .line 2
    .line 3
    if-eqz v0, :cond_1

    .line 4
    .line 5
    iget-object v1, p0, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;

    .line 6
    .line 7
    if-nez v1, :cond_0

    .line 8
    .line 9
    const-string v1, "x11View"

    .line 10
    .line 11
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 12
    .line 13
    .line 14
    const/4 v1, 0x0

    .line 15
    :cond_0
    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 16
    .line 17
    .line 18
    new-instance v1, Lcom/winemu/core/controller/j;

    .line 19
    .line 20
    invoke-direct {v1, p0, v0}, Lcom/winemu/core/controller/j;-><init>(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;)V

    .line 21
    .line 22
    .line 23
    invoke-virtual {v0, v1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 24
    .line 25
    .line 26
    new-instance v1, Lcom/winemu/core/controller/k;

    .line 27
    .line 28
    invoke-direct {v1, p0, v0}, Lcom/winemu/core/controller/k;-><init>(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;)V

    .line 29
    .line 30
    .line 31
    invoke-virtual {v0, v1}, Landroid/view/View;->setOnHoverListener(Landroid/view/View$OnHoverListener;)V

    .line 32
    .line 33
    .line 34
    new-instance v1, Lcom/winemu/core/controller/l;

    .line 35
    .line 36
    invoke-direct {v1, p0, v0}, Lcom/winemu/core/controller/l;-><init>(Lcom/winemu/core/controller/X11Controller;Landroid/view/ViewGroup;)V

    .line 37
    .line 38
    .line 39
    invoke-virtual {v0, v1}, Landroid/view/View;->setOnGenericMotionListener(Landroid/view/View$OnGenericMotionListener;)V

    .line 40
    .line 41
    .line 42
    :cond_1
    return-void
.end method

.method public final setTrackpadInputMode(I)V
    .locals 1

    iget-object v0, p0, Lcom/winemu/core/controller/X11Controller;->b:Lcom/winemu/core/input/TouchInputManager;

    if-eqz v0, :cond_end

    invoke-virtual {v0, p1}, Lcom/winemu/core/input/TouchInputManager;->A(I)V

    :cond_end
    return-void
.end method
