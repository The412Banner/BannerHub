.class public final Lcom/winemu/openapi/WinUIBridge;
.super Ljava/lang/Object;
.source "r8-map-id-712846b76e3224c0169ce621759774aea144e14d75c3fb3c733f7f2b03c1bb19"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/winemu/openapi/WinUIBridge$Companion;,
        Lcom/winemu/openapi/WinUIBridge$KeyboardEventListener;,
        Lcom/winemu/openapi/WinUIBridge$StdCallback;
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
.end annotation

.annotation build Lkotlin/jvm/internal/SourceDebugExtension;
.end annotation


# static fields
.field public static final J:Lcom/winemu/openapi/WinUIBridge$Companion;


# instance fields
.field public A:Landroid/view/ViewGroup;

.field public B:Z

.field public C:Lcom/winemu/core/server/perf/PerfEventListener;

.field public D:Lkotlin/jvm/functions/Function0;

.field public E:Ljava/io/FileWriter;

.field public F:Lcom/winemu/core/server/log/LogHttpServer;

.field public G:Lcom/winemu/core/server/tabtip/TabTipServer;

.field public H:Lcom/winemu/core/server/winmonitor/WinMonitorClient;

.field public I:Z

.field public final a:Lkotlin/Lazy;

.field public final b:Lkotlinx/coroutines/CoroutineScope;

.field public c:Lcom/winemu/core/server/environment/ImageFs;

.field public d:Lcom/winemu/core/Container;

.field public e:Lcom/winemu/core/Wine;

.field public final f:Lcom/winemu/core/BootData;

.field public final g:Lcom/winemu/core/controller/SteamAgentController;

.field public h:Lcom/winemu/core/controller/GameScopeController;

.field public i:Lcom/winemu/core/controller/MITMController;

.field public j:Lcom/winemu/core/controller/ProgramController;

.field public k:Lcom/winemu/core/controller/X11Controller;

.field public l:Lcom/winemu/core/controller/ContainerController;

.field public m:Lcom/winemu/core/controller/RegistryController;

.field public n:Lcom/winemu/core/controller/EnvironmentController;

.field public o:Lcom/winemu/core/gamepad/GamepadManager;

.field public p:Lkotlinx/coroutines/Job;

.field public q:Lcom/winemu/openapi/Config;

.field public r:Landroid/app/Activity;

.field public s:Z

.field public final t:Lcom/winemu/core/utils/Callback;

.field public final u:Lcom/winemu/core/utils/Callback;

.field public v:Z

.field public w:Lcom/winemu/openapi/WinUIBridge$StdCallback;

.field public x:Lcom/winemu/openapi/WinUIBridge$KeyboardEventListener;

.field public y:Lkotlin/jvm/functions/Function0;

.field public z:Lcom/winemu/core/IRemoteCallback;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    new-instance v0, Lcom/winemu/openapi/WinUIBridge$Companion;

    .line 2
    .line 3
    const/4 v1, 0x0

    .line 4
    invoke-direct {v0, v1}, Lcom/winemu/openapi/WinUIBridge$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 5
    .line 6
    .line 7
    sput-object v0, Lcom/winemu/openapi/WinUIBridge;->J:Lcom/winemu/openapi/WinUIBridge$Companion;

    .line 8
    .line 9
    return-void
.end method

.method public constructor <init>()V
    .locals 3

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 2
    .line 3
    .line 4
    new-instance v0, Lcom/winemu/openapi/d;

    .line 5
    .line 6
    invoke-direct {v0, p0}, Lcom/winemu/openapi/d;-><init>(Lcom/winemu/openapi/WinUIBridge;)V

    .line 7
    .line 8
    .line 9
    invoke-static {v0}, Lkotlin/LazyKt;->b(Lkotlin/jvm/functions/Function0;)Lkotlin/Lazy;

    .line 10
    .line 11
    .line 12
    move-result-object v0

    .line 13
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->a:Lkotlin/Lazy;

    .line 14
    .line 15
    invoke-static {}, Lkotlinx/coroutines/Dispatchers;->b()Lkotlinx/coroutines/CoroutineDispatcher;

    .line 16
    .line 17
    .line 18
    move-result-object v0

    .line 19
    const/4 v1, 0x0

    .line 20
    const/4 v2, 0x1

    .line 21
    invoke-static {v1, v2, v1}, Lkotlinx/coroutines/SupervisorKt;->b(Lkotlinx/coroutines/Job;ILjava/lang/Object;)Lkotlinx/coroutines/CompletableJob;

    .line 22
    .line 23
    .line 24
    move-result-object v1

    .line 25
    invoke-virtual {v0, v1}, Lkotlin/coroutines/AbstractCoroutineContextElement;->plus(Lkotlin/coroutines/CoroutineContext;)Lkotlin/coroutines/CoroutineContext;

    .line 26
    .line 27
    .line 28
    move-result-object v0

    .line 29
    invoke-static {v0}, Lkotlinx/coroutines/CoroutineScopeKt;->a(Lkotlin/coroutines/CoroutineContext;)Lkotlinx/coroutines/CoroutineScope;

    .line 30
    .line 31
    .line 32
    move-result-object v0

    .line 33
    new-instance v1, Lkotlinx/coroutines/CoroutineName;

    .line 34
    .line 35
    const-string v2, "WinUIBridgeScope"

    .line 36
    .line 37
    invoke-direct {v1, v2}, Lkotlinx/coroutines/CoroutineName;-><init>(Ljava/lang/String;)V

    .line 38
    .line 39
    .line 40
    invoke-static {v0, v1}, Lkotlinx/coroutines/CoroutineScopeKt;->j(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;)Lkotlinx/coroutines/CoroutineScope;

    .line 41
    .line 42
    .line 43
    move-result-object v0

    .line 44
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->b:Lkotlinx/coroutines/CoroutineScope;

    .line 45
    .line 46
    new-instance v0, Lcom/winemu/core/BootData;

    .line 47
    .line 48
    invoke-direct {v0}, Lcom/winemu/core/BootData;-><init>()V

    .line 49
    .line 50
    .line 51
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->f:Lcom/winemu/core/BootData;

    .line 52
    .line 53
    new-instance v0, Lcom/winemu/core/controller/SteamAgentController;

    .line 54
    .line 55
    invoke-direct {v0}, Lcom/winemu/core/controller/SteamAgentController;-><init>()V

    .line 56
    .line 57
    .line 58
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->g:Lcom/winemu/core/controller/SteamAgentController;

    .line 59
    .line 60
    new-instance v0, Lcom/winemu/openapi/e;

    .line 61
    .line 62
    invoke-direct {v0, p0}, Lcom/winemu/openapi/e;-><init>(Lcom/winemu/openapi/WinUIBridge;)V

    .line 63
    .line 64
    .line 65
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->t:Lcom/winemu/core/utils/Callback;

    .line 66
    .line 67
    new-instance v0, Lcom/winemu/openapi/f;

    .line 68
    .line 69
    invoke-direct {v0, p0}, Lcom/winemu/openapi/f;-><init>(Lcom/winemu/openapi/WinUIBridge;)V

    .line 70
    .line 71
    .line 72
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->u:Lcom/winemu/core/utils/Callback;

    .line 73
    .line 74
    return-void
.end method

.method public static final synthetic A(Lcom/winemu/openapi/WinUIBridge;)V
    .locals 0

    .line 1
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->r0()V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static final synthetic B(Lcom/winemu/openapi/WinUIBridge;)V
    .locals 0

    .line 1
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->w0()V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static final C(Lcom/winemu/openapi/WinUIBridge;)Landroid/app/ActivityManager;
    .locals 1

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->r:Landroid/app/Activity;

    .line 2
    .line 3
    const-string v0, "activity"

    .line 4
    .line 5
    if-nez p0, :cond_0

    .line 6
    .line 7
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    .line 12
    .line 13
    .line 14
    move-result-object p0

    .line 15
    const-string v0, "null cannot be cast to non-null type android.app.ActivityManager"

    .line 16
    .line 17
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 18
    .line 19
    .line 20
    check-cast p0, Landroid/app/ActivityManager;

    .line 21
    .line 22
    return-object p0
.end method

.method public static synthetic a(Lcom/winemu/openapi/WinUIBridge;Ljava/lang/String;)V
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->u0(Lcom/winemu/openapi/WinUIBridge;Ljava/lang/String;)V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static synthetic b(Lcom/winemu/openapi/WinUIBridge;)Landroid/app/ActivityManager;
    .locals 0

    .line 1
    invoke-static {p0}, Lcom/winemu/openapi/WinUIBridge;->C(Lcom/winemu/openapi/WinUIBridge;)Landroid/app/ActivityManager;

    .line 2
    .line 3
    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic c(Landroid/view/ViewGroup;Lcom/winemu/ui/DirectRenderingActivationView;)Lkotlin/Unit;
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->t0(Landroid/view/ViewGroup;Lcom/winemu/ui/DirectRenderingActivationView;)Lkotlin/Unit;

    .line 2
    .line 3
    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic d(Lcom/winemu/openapi/WinUIBridge;Ljava/lang/String;)V
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->v0(Lcom/winemu/openapi/WinUIBridge;Ljava/lang/String;)V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static synthetic e(Landroid/view/ViewGroup;Lcom/winemu/openapi/WinUIBridge;)V
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->s0(Landroid/view/ViewGroup;Lcom/winemu/openapi/WinUIBridge;)V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static final synthetic f(Lcom/winemu/openapi/WinUIBridge;)Landroid/app/Activity;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->r:Landroid/app/Activity;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic g(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/openapi/Config;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic h(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/Container;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->d:Lcom/winemu/core/Container;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic i(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/controller/ContainerController;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->l:Lcom/winemu/core/controller/ContainerController;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic j(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/BootData;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->f:Lcom/winemu/core/BootData;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic k(Lcom/winemu/openapi/WinUIBridge;)Lkotlinx/coroutines/Job;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->p:Lkotlinx/coroutines/Job;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic l(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/controller/EnvironmentController;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->n:Lcom/winemu/core/controller/EnvironmentController;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic m(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/server/environment/ImageFs;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic n(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/openapi/WinUIBridge$KeyboardEventListener;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->x:Lcom/winemu/openapi/WinUIBridge$KeyboardEventListener;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic o(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/controller/MITMController;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->i:Lcom/winemu/core/controller/MITMController;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic p(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/controller/ProgramController;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->j:Lcom/winemu/core/controller/ProgramController;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic q(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/controller/RegistryController;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->m:Lcom/winemu/core/controller/RegistryController;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic r(Lcom/winemu/openapi/WinUIBridge;)Lkotlinx/coroutines/CoroutineScope;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->b:Lkotlinx/coroutines/CoroutineScope;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic s(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/controller/SteamAgentController;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->g:Lcom/winemu/core/controller/SteamAgentController;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final s0(Landroid/view/ViewGroup;Lcom/winemu/openapi/WinUIBridge;)V
    .locals 7

    .line 1
    instance-of v0, p0, Landroid/widget/FrameLayout;

    .line 2
    .line 3
    if-eqz v0, :cond_1

    .line 4
    .line 5
    new-instance v1, Lcom/winemu/ui/DirectRenderingActivationView;

    .line 6
    .line 7
    iget-object p1, p1, Lcom/winemu/openapi/WinUIBridge;->r:Landroid/app/Activity;

    .line 8
    .line 9
    if-nez p1, :cond_0

    .line 10
    .line 11
    const-string p1, "activity"

    .line 12
    .line 13
    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 14
    .line 15
    .line 16
    const/4 p1, 0x0

    .line 17
    :cond_0
    move-object v2, p1

    .line 18
    const/4 v5, 0x6

    .line 19
    const/4 v6, 0x0

    .line 20
    const/4 v3, 0x0

    .line 21
    const/4 v4, 0x0

    .line 22
    invoke-direct/range {v1 .. v6}, Lcom/winemu/ui/DirectRenderingActivationView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;IILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 23
    .line 24
    .line 25
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    .line 26
    .line 27
    const/4 v0, -0x1

    .line 28
    invoke-direct {p1, v0, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 29
    .line 30
    .line 31
    invoke-virtual {v1, p1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 32
    .line 33
    .line 34
    const/4 p1, 0x0

    .line 35
    invoke-virtual {v1, p1}, Landroid/view/View;->setClickable(Z)V

    .line 36
    .line 37
    .line 38
    invoke-virtual {v1, p1}, Landroid/view/View;->setFocusable(Z)V

    .line 39
    .line 40
    .line 41
    new-instance p1, Lcom/winemu/openapi/c;

    .line 42
    .line 43
    invoke-direct {p1, p0, v1}, Lcom/winemu/openapi/c;-><init>(Landroid/view/ViewGroup;Lcom/winemu/ui/DirectRenderingActivationView;)V

    .line 44
    .line 45
    .line 46
    invoke-virtual {v1, p1}, Lcom/winemu/ui/DirectRenderingActivationView;->setOnActivationCompleteListener(Lkotlin/jvm/functions/Function0;)V

    .line 47
    .line 48
    .line 49
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 50
    .line 51
    .line 52
    invoke-virtual {v1}, Lcom/winemu/ui/DirectRenderingActivationView;->s()V

    .line 53
    .line 54
    .line 55
    :cond_1
    return-void
.end method

.method public static final synthetic t(Lcom/winemu/openapi/WinUIBridge;)Lkotlin/jvm/functions/Function0;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->D:Lkotlin/jvm/functions/Function0;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final t0(Landroid/view/ViewGroup;Lcom/winemu/ui/DirectRenderingActivationView;)Lkotlin/Unit;
    .locals 0

    .line 1
    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 2
    .line 3
    .line 4
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 5
    .line 6
    return-object p0
.end method

.method public static final synthetic u(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/Wine;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->e:Lcom/winemu/core/Wine;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final u0(Lcom/winemu/openapi/WinUIBridge;Ljava/lang/String;)V
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->w:Lcom/winemu/openapi/WinUIBridge$StdCallback;

    .line 2
    .line 3
    if-eqz v0, :cond_0

    .line 4
    .line 5
    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 6
    .line 7
    .line 8
    invoke-interface {v0, p1}, Lcom/winemu/openapi/WinUIBridge$StdCallback;->b(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    :cond_0
    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 12
    .line 13
    .line 14
    invoke-virtual {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->x0(Ljava/lang/String;)V

    .line 15
    .line 16
    .line 17
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->F:Lcom/winemu/core/server/log/LogHttpServer;

    .line 18
    .line 19
    if-eqz p0, :cond_1

    .line 20
    .line 21
    const/4 v0, 0x1

    .line 22
    invoke-virtual {p0, p1, v0}, Lcom/winemu/core/server/log/LogHttpServer;->c(Ljava/lang/String;Z)V

    .line 23
    .line 24
    .line 25
    :cond_1
    return-void
.end method

.method public static final synthetic v(Lcom/winemu/openapi/WinUIBridge;)Z
    .locals 0

    .line 1
    iget-boolean p0, p0, Lcom/winemu/openapi/WinUIBridge;->s:Z

    .line 2
    .line 3
    return p0
.end method

.method public static final v0(Lcom/winemu/openapi/WinUIBridge;Ljava/lang/String;)V
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->w:Lcom/winemu/openapi/WinUIBridge$StdCallback;

    .line 2
    .line 3
    if-eqz v0, :cond_0

    .line 4
    .line 5
    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 6
    .line 7
    .line 8
    invoke-interface {v0, p1}, Lcom/winemu/openapi/WinUIBridge$StdCallback;->a(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    :cond_0
    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 12
    .line 13
    .line 14
    invoke-virtual {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->x0(Ljava/lang/String;)V

    .line 15
    .line 16
    .line 17
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->F:Lcom/winemu/core/server/log/LogHttpServer;

    .line 18
    .line 19
    if-eqz p0, :cond_1

    .line 20
    .line 21
    const/4 v0, 0x0

    .line 22
    invoke-virtual {p0, p1, v0}, Lcom/winemu/core/server/log/LogHttpServer;->c(Ljava/lang/String;Z)V

    .line 23
    .line 24
    .line 25
    :cond_1
    return-void
.end method

.method public static final synthetic w(Lcom/winemu/openapi/WinUIBridge;)Lcom/winemu/core/controller/X11Controller;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 2
    .line 3
    return-object p0
.end method

.method public static final synthetic x(Lcom/winemu/openapi/WinUIBridge;Lkotlinx/coroutines/Job;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->p:Lkotlinx/coroutines/Job;

    .line 2
    .line 3
    return-void
.end method

.method public static final synthetic y(Lcom/winemu/openapi/WinUIBridge;Z)V
    .locals 0

    .line 1
    iput-boolean p1, p0, Lcom/winemu/openapi/WinUIBridge;->I:Z

    .line 2
    .line 3
    return-void
.end method

.method public static final synthetic z(Lcom/winemu/openapi/WinUIBridge;Z)V
    .locals 0

    .line 1
    iput-boolean p1, p0, Lcom/winemu/openapi/WinUIBridge;->s:Z

    .line 2
    .line 3
    return-void
.end method


# virtual methods
.method public final D(Lcom/winemu/openapi/ReshadeConfig;)V
    .locals 2

    .line 1
    const-string v0, "reshadeConfig"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    new-instance v0, Ljava/io/File;

    .line 7
    .line 8
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 9
    .line 10
    if-nez p0, :cond_0

    .line 11
    .line 12
    const-string p0, "fs"

    .line 13
    .line 14
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 15
    .line 16
    .line 17
    const/4 p0, 0x0

    .line 18
    :cond_0
    iget-object p0, p0, Lcom/winemu/core/server/environment/ImageFs;->a:Ljava/io/File;

    .line 19
    .line 20
    const-string v1, "etc/reshade.ini"

    .line 21
    .line 22
    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 23
    .line 24
    .line 25
    invoke-virtual {p1, v0}, Lcom/winemu/openapi/ReshadeConfig;->d(Ljava/io/File;)V

    .line 26
    .line 27
    .line 28
    return-void
.end method

.method public final E(Landroid/view/ViewGroup;)V
    .locals 1

    .line 1
    const-string v0, "x11ContainerView"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->r:Landroid/app/Activity;

    .line 7
    .line 8
    if-eqz v0, :cond_1

    .line 9
    .line 10
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->A:Landroid/view/ViewGroup;

    .line 11
    .line 12
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 13
    .line 14
    if-nez p0, :cond_0

    .line 15
    .line 16
    const-string p0, "x11Controller"

    .line 17
    .line 18
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 19
    .line 20
    .line 21
    const/4 p0, 0x0

    .line 22
    :cond_0
    invoke-virtual {p0, p1}, Lcom/winemu/core/controller/X11Controller;->i(Landroid/view/ViewGroup;)V

    .line 23
    .line 24
    .line 25
    return-void

    .line 26
    :cond_1
    new-instance p0, Ljava/lang/IllegalStateException;

    .line 27
    .line 28
    const-string p1, "Must call init() before attach()"

    .line 29
    .line 30
    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    .line 31
    .line 32
    .line 33
    throw p0
.end method

.method public final F()Lkotlinx/coroutines/Job;
    .locals 6

    .line 1
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->b:Lkotlinx/coroutines/CoroutineScope;

    .line 2
    .line 3
    new-instance v3, Lcom/winemu/openapi/WinUIBridge$boot$1;

    .line 4
    .line 5
    const/4 v1, 0x0

    .line 6
    invoke-direct {v3, p0, v1}, Lcom/winemu/openapi/WinUIBridge$boot$1;-><init>(Lcom/winemu/openapi/WinUIBridge;Lkotlin/coroutines/Continuation;)V

    .line 7
    .line 8
    .line 9
    const/4 v4, 0x3

    .line 10
    const/4 v5, 0x0

    .line 11
    const/4 v2, 0x0

    .line 12
    invoke-static/range {v0 .. v5}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 13
    .line 14
    .line 15
    move-result-object p0

    .line 16
    return-object p0
.end method

.method public final G(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    if-eqz p1, :cond_1

    .line 2
    .line 3
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->o:Lcom/winemu/core/gamepad/GamepadManager;

    .line 4
    .line 5
    if-eqz p0, :cond_0

    .line 6
    .line 7
    invoke-virtual {p0, p1}, Lcom/winemu/core/gamepad/GamepadManager;->V(Landroid/view/MotionEvent;)Z

    .line 8
    .line 9
    .line 10
    move-result p0

    .line 11
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 12
    .line 13
    .line 14
    move-result-object p0

    .line 15
    goto :goto_0

    .line 16
    :cond_0
    const/4 p0, 0x0

    .line 17
    :goto_0
    if-eqz p0, :cond_1

    .line 18
    .line 19
    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    .line 20
    .line 21
    .line 22
    move-result p0

    .line 23
    return p0

    .line 24
    :cond_1
    const/4 p0, 0x0

    .line 25
    return p0
.end method

.method public final H(Landroid/view/KeyEvent;)Z
    .locals 2

    .line 1
    const-string v0, "event"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->o:Lcom/winemu/core/gamepad/GamepadManager;

    .line 7
    .line 8
    const/4 v1, 0x1

    .line 9
    if-eqz v0, :cond_0

    .line 10
    .line 11
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 12
    .line 13
    .line 14
    invoke-virtual {v0, p1}, Lcom/winemu/core/gamepad/GamepadManager;->Q(Landroid/view/KeyEvent;)Z

    .line 15
    .line 16
    .line 17
    move-result v0

    .line 18
    if-eqz v0, :cond_0

    .line 19
    .line 20
    return v1

    .line 21
    :cond_0
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 22
    .line 23
    .line 24
    move-result v0

    .line 25
    invoke-virtual {p0, v0}, Lcom/winemu/openapi/WinUIBridge;->Y(I)Z

    .line 26
    .line 27
    .line 28
    move-result v0

    .line 29
    if-nez v0, :cond_2

    .line 30
    .line 31
    invoke-virtual {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->q0(Landroid/view/KeyEvent;)Z

    .line 32
    .line 33
    .line 34
    move-result v0

    .line 35
    if-eqz v0, :cond_2

    .line 36
    .line 37
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 38
    .line 39
    .line 40
    move-result v0

    .line 41
    invoke-static {v0}, Landroid/view/KeyEvent;->isGamepadButton(I)Z

    .line 42
    .line 43
    .line 44
    move-result v0

    .line 45
    if-nez v0, :cond_1

    .line 46
    .line 47
    invoke-virtual {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->e0(Landroid/view/KeyEvent;)V

    .line 48
    .line 49
    .line 50
    :cond_1
    return v1

    .line 51
    :cond_2
    const/4 p0, 0x0

    .line 52
    return p0
.end method

.method public final I(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    if-eqz p1, :cond_1

    .line 2
    .line 3
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 4
    .line 5
    if-nez p0, :cond_0

    .line 6
    .line 7
    const-string p0, "x11Controller"

    .line 8
    .line 9
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 10
    .line 11
    .line 12
    const/4 p0, 0x0

    .line 13
    :cond_0
    invoke-virtual {p0, p1}, Lcom/winemu/core/controller/X11Controller;->k(Landroid/view/MotionEvent;)Z

    .line 14
    .line 15
    .line 16
    move-result p0

    .line 17
    return p0

    .line 18
    :cond_1
    const/4 p0, 0x0

    .line 19
    return p0
.end method

.method public final J()V
    .locals 7

    .line 1
    const-string v0, "EmuWindowContext"

    .line 2
    .line 3
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->y:Lkotlin/jvm/functions/Function0;

    .line 4
    .line 5
    const/4 v2, 0x0

    .line 6
    if-eqz v1, :cond_0

    .line 7
    .line 8
    invoke-static {}, Lkotlinx/coroutines/Dispatchers;->c()Lkotlinx/coroutines/MainCoroutineDispatcher;

    .line 9
    .line 10
    .line 11
    move-result-object v3

    .line 12
    new-instance v4, Lcom/winemu/openapi/WinUIBridge$exit$1$1;

    .line 13
    .line 14
    invoke-direct {v4, v1, v2}, Lcom/winemu/openapi/WinUIBridge$exit$1$1;-><init>(Lkotlin/jvm/functions/Function0;Lkotlin/coroutines/Continuation;)V

    .line 15
    .line 16
    .line 17
    invoke-static {v3, v4}, Lkotlinx/coroutines/BuildersKt;->e(Lkotlin/coroutines/CoroutineContext;Lkotlin/jvm/functions/Function2;)Ljava/lang/Object;

    .line 18
    .line 19
    .line 20
    :cond_0
    :try_start_0
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->E:Ljava/io/FileWriter;

    .line 21
    .line 22
    if-eqz v1, :cond_1

    .line 23
    .line 24
    invoke-virtual {v1}, Ljava/io/Writer;->close()V

    .line 25
    .line 26
    .line 27
    goto :goto_0

    .line 28
    :catch_0
    move-exception v1

    .line 29
    goto :goto_1

    .line 30
    :cond_1
    :goto_0
    iput-object v2, p0, Lcom/winemu/openapi/WinUIBridge;->E:Ljava/io/FileWriter;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 31
    .line 32
    goto :goto_2

    .line 33
    :goto_1
    invoke-virtual {v1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    .line 34
    .line 35
    .line 36
    move-result-object v1

    .line 37
    new-instance v3, Ljava/lang/StringBuilder;

    .line 38
    .line 39
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    .line 40
    .line 41
    .line 42
    const-string v4, "Failed to close log file: "

    .line 43
    .line 44
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 45
    .line 46
    .line 47
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 48
    .line 49
    .line 50
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 51
    .line 52
    .line 53
    move-result-object v1

    .line 54
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 55
    .line 56
    .line 57
    :goto_2
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->F:Lcom/winemu/core/server/log/LogHttpServer;

    .line 58
    .line 59
    if-eqz v1, :cond_2

    .line 60
    .line 61
    invoke-virtual {v1}, Lcom/winemu/core/server/log/LogHttpServer;->p()V

    .line 62
    .line 63
    .line 64
    :cond_2
    iput-object v2, p0, Lcom/winemu/openapi/WinUIBridge;->F:Lcom/winemu/core/server/log/LogHttpServer;

    .line 65
    .line 66
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->g:Lcom/winemu/core/controller/SteamAgentController;

    .line 67
    .line 68
    invoke-virtual {v1}, Lcom/winemu/core/controller/SteamAgentController;->j()V

    .line 69
    .line 70
    .line 71
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->j:Lcom/winemu/core/controller/ProgramController;

    .line 72
    .line 73
    if-nez v1, :cond_3

    .line 74
    .line 75
    const-string v1, "programController"

    .line 76
    .line 77
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 78
    .line 79
    .line 80
    move-object v1, v2

    .line 81
    :cond_3
    invoke-virtual {v1}, Lcom/winemu/core/controller/ProgramController;->A()V

    .line 82
    .line 83
    .line 84
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->h:Lcom/winemu/core/controller/GameScopeController;

    .line 85
    .line 86
    if-eqz v1, :cond_4

    .line 87
    .line 88
    invoke-virtual {v1}, Lcom/winemu/core/controller/GameScopeController;->a()V

    .line 89
    .line 90
    .line 91
    :cond_4
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->i:Lcom/winemu/core/controller/MITMController;

    .line 92
    .line 93
    if-eqz v1, :cond_5

    .line 94
    .line 95
    invoke-virtual {v1}, Lcom/winemu/core/controller/MITMController;->f()V

    .line 96
    .line 97
    .line 98
    :cond_5
    sget-object v1, Lcom/winemu/core/WineHelper;->b:Lcom/winemu/core/WineHelper$Companion;

    .line 99
    .line 100
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->e:Lcom/winemu/core/Wine;

    .line 101
    .line 102
    if-nez v3, :cond_6

    .line 103
    .line 104
    const-string v3, "wine"

    .line 105
    .line 106
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 107
    .line 108
    .line 109
    move-object v3, v2

    .line 110
    :cond_6
    invoke-virtual {v1, v3}, Lcom/winemu/core/WineHelper$Companion;->a(Lcom/winemu/core/Wine;)Lcom/winemu/core/WineHelper;

    .line 111
    .line 112
    .line 113
    move-result-object v1

    .line 114
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->r:Landroid/app/Activity;

    .line 115
    .line 116
    const-string v4, "activity"

    .line 117
    .line 118
    if-nez v3, :cond_7

    .line 119
    .line 120
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 121
    .line 122
    .line 123
    move-object v3, v2

    .line 124
    :cond_7
    iget-object v5, p0, Lcom/winemu/openapi/WinUIBridge;->d:Lcom/winemu/core/Container;

    .line 125
    .line 126
    if-nez v5, :cond_8

    .line 127
    .line 128
    const-string v5, "container"

    .line 129
    .line 130
    invoke-static {v5}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 131
    .line 132
    .line 133
    move-object v5, v2

    .line 134
    :cond_8
    invoke-virtual {v5}, Lcom/winemu/core/Container;->a()Ljava/lang/String;

    .line 135
    .line 136
    .line 137
    move-result-object v5

    .line 138
    iget-object v6, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 139
    .line 140
    if-nez v6, :cond_9

    .line 141
    .line 142
    const-string v6, "config"

    .line 143
    .line 144
    invoke-static {v6}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 145
    .line 146
    .line 147
    move-object v6, v2

    .line 148
    :cond_9
    invoke-virtual {v6}, Lcom/winemu/openapi/Config;->I()Ljava/lang/String;

    .line 149
    .line 150
    .line 151
    move-result-object v6

    .line 152
    invoke-virtual {v1, v3, v5, v6}, Lcom/winemu/core/WineHelper;->j(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 153
    .line 154
    .line 155
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->l:Lcom/winemu/core/controller/ContainerController;

    .line 156
    .line 157
    if-nez v1, :cond_a

    .line 158
    .line 159
    const-string v1, "containerController"

    .line 160
    .line 161
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 162
    .line 163
    .line 164
    move-object v1, v2

    .line 165
    :cond_a
    const/4 v3, 0x0

    .line 166
    invoke-virtual {v1, v3}, Lcom/winemu/core/controller/ContainerController;->g(Z)Ljava/util/List;

    .line 167
    .line 168
    .line 169
    move-result-object v1

    .line 170
    invoke-interface {v1}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 171
    .line 172
    .line 173
    move-result-object v1

    .line 174
    :goto_3
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    .line 175
    .line 176
    .line 177
    move-result v5

    .line 178
    if-eqz v5, :cond_b

    .line 179
    .line 180
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 181
    .line 182
    .line 183
    move-result-object v5

    .line 184
    check-cast v5, Ljava/lang/Number;

    .line 185
    .line 186
    invoke-virtual {v5}, Ljava/lang/Number;->intValue()I

    .line 187
    .line 188
    .line 189
    move-result v5

    .line 190
    invoke-static {v5}, Landroid/os/Process;->killProcess(I)V

    .line 191
    .line 192
    .line 193
    goto :goto_3

    .line 194
    :cond_b
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 195
    .line 196
    if-nez v1, :cond_c

    .line 197
    .line 198
    const-string v1, "x11Controller"

    .line 199
    .line 200
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 201
    .line 202
    .line 203
    move-object v1, v2

    .line 204
    :cond_c
    invoke-virtual {v1}, Lcom/winemu/core/controller/X11Controller;->G()V

    .line 205
    .line 206
    .line 207
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->r:Landroid/app/Activity;

    .line 208
    .line 209
    if-nez v1, :cond_d

    .line 210
    .line 211
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 212
    .line 213
    .line 214
    goto :goto_4

    .line 215
    :cond_d
    move-object v2, v1

    .line 216
    :goto_4
    invoke-virtual {v2}, Landroid/app/Activity;->finish()V

    .line 217
    .line 218
    .line 219
    const-string v1, "Bye!"

    .line 220
    .line 221
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 222
    .line 223
    .line 224
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->z:Lcom/winemu/core/IRemoteCallback;

    .line 225
    .line 226
    if-eqz p0, :cond_e

    .line 227
    .line 228
    if-eqz p0, :cond_e

    .line 229
    .line 230
    :try_start_1
    invoke-interface {p0, v3}, Lcom/winemu/core/IRemoteCallback;->T(I)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 231
    .line 232
    .line 233
    goto :goto_5

    .line 234
    :catch_1
    move-exception p0

    .line 235
    const-string v1, "Error completing remote callback"

    .line 236
    .line 237
    invoke-static {v0, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 238
    .line 239
    .line 240
    :cond_e
    :goto_5
    invoke-static {}, Landroid/os/Process;->myPid()I

    .line 241
    .line 242
    .line 243
    move-result p0

    .line 244
    invoke-static {p0}, Landroid/os/Process;->killProcess(I)V

    .line 245
    .line 246
    .line 247
    return-void
.end method

.method public final K()Landroid/app/ActivityManager;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->a:Lkotlin/Lazy;

    .line 2
    .line 3
    invoke-interface {p0}, Lkotlin/Lazy;->getValue()Ljava/lang/Object;

    .line 4
    .line 5
    .line 6
    move-result-object p0

    .line 7
    check-cast p0, Landroid/app/ActivityManager;

    .line 8
    .line 9
    return-object p0
.end method

.method public final L()Lcom/winemu/openapi/Config;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "config"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    return-object p0
.end method

.method public final M()F
    .locals 0

    .line 1
    sget-object p0, Lcom/winemu/core/utils/ProfilePuller;->a:Lcom/winemu/core/utils/ProfilePuller$Companion;

    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/winemu/core/utils/ProfilePuller$Companion;->a()Lcom/winemu/core/utils/ProfilePuller;

    .line 4
    .line 5
    .line 6
    move-result-object p0

    .line 7
    invoke-virtual {p0}, Lcom/winemu/core/utils/ProfilePuller;->c()F

    .line 8
    .line 9
    .line 10
    move-result p0

    .line 11
    return p0
.end method

.method public final N()Lcom/winemu/core/gamepad/GamepadManager;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->o:Lcom/winemu/core/gamepad/GamepadManager;

    .line 2
    .line 3
    return-object p0
.end method

.method public final O()Ljava/lang/String;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->F:Lcom/winemu/core/server/log/LogHttpServer;

    .line 2
    .line 3
    if-eqz p0, :cond_0

    .line 4
    .line 5
    invoke-virtual {p0}, Lcom/winemu/core/server/log/LogHttpServer;->h()Ljava/lang/String;

    .line 6
    .line 7
    .line 8
    move-result-object p0

    .line 9
    return-object p0

    .line 10
    :cond_0
    const/4 p0, 0x0

    .line 11
    return-object p0
.end method

.method public final P()Lcom/winemu/core/controller/SteamAgentController;
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->g:Lcom/winemu/core/controller/SteamAgentController;

    .line 2
    .line 3
    return-object p0
.end method

.method public final Q(Landroid/app/Activity;)V
    .locals 14

    .line 1
    const-string v0, "activity"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->R()V

    .line 7
    .line 8
    .line 9
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->r:Landroid/app/Activity;

    .line 10
    .line 11
    invoke-virtual {p1}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    .line 12
    .line 13
    .line 14
    move-result-object v0

    .line 15
    const-string v1, "container_path"

    .line 16
    .line 17
    invoke-virtual {v0, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    .line 18
    .line 19
    .line 20
    move-result-object v1

    .line 21
    if-eqz v1, :cond_1f

    .line 22
    .line 23
    invoke-interface {v1}, Ljava/lang/CharSequence;->length()I

    .line 24
    .line 25
    .line 26
    move-result v2

    .line 27
    if-eqz v2, :cond_1f

    .line 28
    .line 29
    sget-object v2, Lcom/winemu/core/server/environment/ImageFs;->b:Lcom/winemu/core/server/environment/ImageFs$Companion;

    .line 30
    .line 31
    invoke-virtual {v2, p1}, Lcom/winemu/core/server/environment/ImageFs$Companion;->a(Landroid/content/Context;)Lcom/winemu/core/server/environment/ImageFs;

    .line 32
    .line 33
    .line 34
    move-result-object v2

    .line 35
    iput-object v2, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 36
    .line 37
    new-instance v2, Lcom/winemu/core/Container;

    .line 38
    .line 39
    invoke-direct {v2, v1}, Lcom/winemu/core/Container;-><init>(Ljava/lang/String;)V

    .line 40
    .line 41
    .line 42
    iput-object v2, p0, Lcom/winemu/openapi/WinUIBridge;->d:Lcom/winemu/core/Container;

    .line 43
    .line 44
    invoke-virtual {v2}, Lcom/winemu/core/Container;->e()Lcom/winemu/core/Container;

    .line 45
    .line 46
    .line 47
    sget-object v2, Lcom/winemu/openapi/WinAPI;->f:Lcom/winemu/openapi/WinAPI$Companion;

    .line 48
    .line 49
    invoke-virtual {v2}, Lcom/winemu/openapi/WinAPI$Companion;->a()Lcom/winemu/openapi/WinAPI;

    .line 50
    .line 51
    .line 52
    move-result-object v2

    .line 53
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->d:Lcom/winemu/core/Container;

    .line 54
    .line 55
    const-string v4, "container"

    .line 56
    .line 57
    const/4 v5, 0x0

    .line 58
    if-nez v3, :cond_0

    .line 59
    .line 60
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 61
    .line 62
    .line 63
    move-object v3, v5

    .line 64
    :cond_0
    invoke-virtual {v2, v3}, Lcom/winemu/openapi/WinAPI;->v(Lcom/winemu/core/Container;)Lcom/winemu/core/Wine;

    .line 65
    .line 66
    .line 67
    move-result-object v2

    .line 68
    if-eqz v2, :cond_1e

    .line 69
    .line 70
    iput-object v2, p0, Lcom/winemu/openapi/WinUIBridge;->e:Lcom/winemu/core/Wine;

    .line 71
    .line 72
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    .line 73
    .line 74
    const/16 v3, 0x21

    .line 75
    .line 76
    const-string v6, "container_config"

    .line 77
    .line 78
    if-lt v2, v3, :cond_1

    .line 79
    .line 80
    const-class v2, Lcom/winemu/openapi/Config;

    .line 81
    .line 82
    invoke-static {v0, v6, v2}, Lcom/hjq/permissions/a;->a(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;

    .line 83
    .line 84
    .line 85
    move-result-object v2

    .line 86
    check-cast v2, Lcom/winemu/openapi/Config;

    .line 87
    .line 88
    goto :goto_0

    .line 89
    :cond_1
    invoke-virtual {v0, v6}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    .line 90
    .line 91
    .line 92
    move-result-object v2

    .line 93
    check-cast v2, Lcom/winemu/openapi/Config;

    .line 94
    .line 95
    :goto_0
    if-eqz v2, :cond_1d

    .line 96
    .line 97
    iput-object v2, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 98
    .line 99
    const-string v2, "is_dependency_installer"

    .line 100
    .line 101
    const/4 v3, 0x0

    .line 102
    invoke-virtual {v0, v2, v3}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    .line 103
    .line 104
    .line 105
    move-result v2

    .line 106
    iput-boolean v2, p0, Lcom/winemu/openapi/WinUIBridge;->v:Z

    .line 107
    .line 108
    invoke-static {v0}, Lcom/winemu/core/utils/RemoteFeature;->Z(Landroid/content/Intent;)Lcom/winemu/core/IRemoteCallback;

    .line 109
    .line 110
    .line 111
    move-result-object v0

    .line 112
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->z:Lcom/winemu/core/IRemoteCallback;

    .line 113
    .line 114
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 115
    .line 116
    const-string v2, "config"

    .line 117
    .line 118
    if-nez v0, :cond_2

    .line 119
    .line 120
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 121
    .line 122
    .line 123
    move-object v0, v5

    .line 124
    :cond_2
    invoke-virtual {v0}, Lcom/winemu/openapi/Config;->D()Lcom/winemu/openapi/Config$RunMode;

    .line 125
    .line 126
    .line 127
    move-result-object v0

    .line 128
    new-instance v3, Ljava/lang/StringBuilder;

    .line 129
    .line 130
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    .line 131
    .line 132
    .line 133
    const-string v6, "Init container: "

    .line 134
    .line 135
    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 136
    .line 137
    .line 138
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 139
    .line 140
    .line 141
    const-string v1, ", runMode: "

    .line 142
    .line 143
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 144
    .line 145
    .line 146
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 147
    .line 148
    .line 149
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 150
    .line 151
    .line 152
    move-result-object v0

    .line 153
    const-string v1, "EmuWindowContext"

    .line 154
    .line 155
    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 156
    .line 157
    .line 158
    sget-object v0, Lcom/winemu/core/Tricks;->a:Lcom/winemu/core/Tricks;

    .line 159
    .line 160
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 161
    .line 162
    if-nez v1, :cond_3

    .line 163
    .line 164
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 165
    .line 166
    .line 167
    move-object v1, v5

    .line 168
    :cond_3
    invoke-virtual {v0, v1}, Lcom/winemu/core/Tricks;->a(Lcom/winemu/openapi/Config;)V

    .line 169
    .line 170
    .line 171
    new-instance v0, Lcom/winemu/core/controller/GameScopeController;

    .line 172
    .line 173
    new-instance v1, Ljava/io/File;

    .line 174
    .line 175
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 176
    .line 177
    const-string v6, "fs"

    .line 178
    .line 179
    if-nez v3, :cond_4

    .line 180
    .line 181
    invoke-static {v6}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 182
    .line 183
    .line 184
    move-object v3, v5

    .line 185
    :cond_4
    iget-object v3, v3, Lcom/winemu/core/server/environment/ImageFs;->a:Ljava/io/File;

    .line 186
    .line 187
    const-string v7, "etc/gamescope.control"

    .line 188
    .line 189
    invoke-direct {v1, v3, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 190
    .line 191
    .line 192
    invoke-direct {v0, v1}, Lcom/winemu/core/controller/GameScopeController;-><init>(Ljava/io/File;)V

    .line 193
    .line 194
    .line 195
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->h:Lcom/winemu/core/controller/GameScopeController;

    .line 196
    .line 197
    new-instance v0, Lcom/winemu/core/controller/MITMController;

    .line 198
    .line 199
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 200
    .line 201
    if-nez v1, :cond_5

    .line 202
    .line 203
    invoke-static {v6}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 204
    .line 205
    .line 206
    move-object v1, v5

    .line 207
    :cond_5
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 208
    .line 209
    if-nez v3, :cond_6

    .line 210
    .line 211
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 212
    .line 213
    .line 214
    move-object v3, v5

    .line 215
    :cond_6
    invoke-direct {v0, p1, v1, v3}, Lcom/winemu/core/controller/MITMController;-><init>(Landroid/content/Context;Lcom/winemu/core/server/environment/ImageFs;Lcom/winemu/openapi/Config;)V

    .line 216
    .line 217
    .line 218
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->i:Lcom/winemu/core/controller/MITMController;

    .line 219
    .line 220
    new-instance v7, Lcom/winemu/core/controller/ContainerController;

    .line 221
    .line 222
    iget-object v8, p0, Lcom/winemu/openapi/WinUIBridge;->f:Lcom/winemu/core/BootData;

    .line 223
    .line 224
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 225
    .line 226
    if-nez v0, :cond_7

    .line 227
    .line 228
    invoke-static {v6}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 229
    .line 230
    .line 231
    move-object v9, v5

    .line 232
    goto :goto_1

    .line 233
    :cond_7
    move-object v9, v0

    .line 234
    :goto_1
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->K()Landroid/app/ActivityManager;

    .line 235
    .line 236
    .line 237
    move-result-object v10

    .line 238
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 239
    .line 240
    if-nez v0, :cond_8

    .line 241
    .line 242
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 243
    .line 244
    .line 245
    move-object v11, v5

    .line 246
    goto :goto_2

    .line 247
    :cond_8
    move-object v11, v0

    .line 248
    :goto_2
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->d:Lcom/winemu/core/Container;

    .line 249
    .line 250
    if-nez v0, :cond_9

    .line 251
    .line 252
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 253
    .line 254
    .line 255
    move-object v12, v5

    .line 256
    goto :goto_3

    .line 257
    :cond_9
    move-object v12, v0

    .line 258
    :goto_3
    invoke-direct/range {v7 .. v12}, Lcom/winemu/core/controller/ContainerController;-><init>(Lcom/winemu/core/BootData;Lcom/winemu/core/server/environment/ImageFs;Landroid/app/ActivityManager;Lcom/winemu/openapi/Config;Lcom/winemu/core/Container;)V

    .line 259
    .line 260
    .line 261
    iput-object v7, p0, Lcom/winemu/openapi/WinUIBridge;->l:Lcom/winemu/core/controller/ContainerController;

    .line 262
    .line 263
    new-instance v0, Lcom/winemu/core/controller/RegistryController;

    .line 264
    .line 265
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->f:Lcom/winemu/core/BootData;

    .line 266
    .line 267
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 268
    .line 269
    if-nez v3, :cond_a

    .line 270
    .line 271
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 272
    .line 273
    .line 274
    move-object v3, v5

    .line 275
    :cond_a
    iget-object v7, p0, Lcom/winemu/openapi/WinUIBridge;->d:Lcom/winemu/core/Container;

    .line 276
    .line 277
    if-nez v7, :cond_b

    .line 278
    .line 279
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 280
    .line 281
    .line 282
    move-object v7, v5

    .line 283
    :cond_b
    invoke-direct {v0, v1, v3, v7}, Lcom/winemu/core/controller/RegistryController;-><init>(Lcom/winemu/core/BootData;Lcom/winemu/openapi/Config;Lcom/winemu/core/Container;)V

    .line 284
    .line 285
    .line 286
    iput-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->m:Lcom/winemu/core/controller/RegistryController;

    .line 287
    .line 288
    new-instance v8, Lcom/winemu/core/controller/EnvironmentController;

    .line 289
    .line 290
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 291
    .line 292
    if-nez v0, :cond_c

    .line 293
    .line 294
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 295
    .line 296
    .line 297
    move-object v10, v5

    .line 298
    goto :goto_4

    .line 299
    :cond_c
    move-object v10, v0

    .line 300
    :goto_4
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->d:Lcom/winemu/core/Container;

    .line 301
    .line 302
    if-nez v0, :cond_d

    .line 303
    .line 304
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 305
    .line 306
    .line 307
    move-object v11, v5

    .line 308
    goto :goto_5

    .line 309
    :cond_d
    move-object v11, v0

    .line 310
    :goto_5
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 311
    .line 312
    if-nez v0, :cond_e

    .line 313
    .line 314
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 315
    .line 316
    .line 317
    move-object v0, v5

    .line 318
    :cond_e
    invoke-virtual {v0}, Lcom/winemu/openapi/Config;->I()Ljava/lang/String;

    .line 319
    .line 320
    .line 321
    move-result-object v12

    .line 322
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 323
    .line 324
    if-nez v0, :cond_f

    .line 325
    .line 326
    invoke-static {v6}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 327
    .line 328
    .line 329
    move-object v13, v5

    .line 330
    :goto_6
    move-object v9, p1

    .line 331
    goto :goto_7

    .line 332
    :cond_f
    move-object v13, v0

    .line 333
    goto :goto_6

    .line 334
    :goto_7
    invoke-direct/range {v8 .. v13}, Lcom/winemu/core/controller/EnvironmentController;-><init>(Landroid/content/Context;Lcom/winemu/openapi/Config;Lcom/winemu/core/Container;Ljava/lang/String;Lcom/winemu/core/server/environment/ImageFs;)V

    .line 335
    .line 336
    .line 337
    iput-object v8, p0, Lcom/winemu/openapi/WinUIBridge;->n:Lcom/winemu/core/controller/EnvironmentController;

    .line 338
    .line 339
    new-instance p1, Lcom/winemu/core/controller/ProgramController;

    .line 340
    .line 341
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->b:Lkotlinx/coroutines/CoroutineScope;

    .line 342
    .line 343
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 344
    .line 345
    if-nez v1, :cond_10

    .line 346
    .line 347
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 348
    .line 349
    .line 350
    move-object v1, v5

    .line 351
    :cond_10
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 352
    .line 353
    if-nez v3, :cond_11

    .line 354
    .line 355
    invoke-static {v6}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 356
    .line 357
    .line 358
    move-object v3, v5

    .line 359
    :cond_11
    iget-object v6, p0, Lcom/winemu/openapi/WinUIBridge;->d:Lcom/winemu/core/Container;

    .line 360
    .line 361
    if-nez v6, :cond_12

    .line 362
    .line 363
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 364
    .line 365
    .line 366
    move-object v6, v5

    .line 367
    :cond_12
    invoke-virtual {v6}, Lcom/winemu/core/Container;->a()Ljava/lang/String;

    .line 368
    .line 369
    .line 370
    move-result-object v4

    .line 371
    invoke-direct {p1, v0, v1, v3, v4}, Lcom/winemu/core/controller/ProgramController;-><init>(Lkotlinx/coroutines/CoroutineScope;Lcom/winemu/openapi/Config;Lcom/winemu/core/server/environment/ImageFs;Ljava/lang/String;)V

    .line 372
    .line 373
    .line 374
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->j:Lcom/winemu/core/controller/ProgramController;

    .line 375
    .line 376
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->T()V

    .line 377
    .line 378
    .line 379
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->S()V

    .line 380
    .line 381
    .line 382
    iget-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->j:Lcom/winemu/core/controller/ProgramController;

    .line 383
    .line 384
    const-string v0, "programController"

    .line 385
    .line 386
    if-nez p1, :cond_13

    .line 387
    .line 388
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 389
    .line 390
    .line 391
    move-object p1, v5

    .line 392
    :cond_13
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->t:Lcom/winemu/core/utils/Callback;

    .line 393
    .line 394
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->u:Lcom/winemu/core/utils/Callback;

    .line 395
    .line 396
    invoke-virtual {p1, v1, v3}, Lcom/winemu/core/controller/ProgramController;->l(Lcom/winemu/core/utils/Callback;Lcom/winemu/core/utils/Callback;)V

    .line 397
    .line 398
    .line 399
    iget-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->j:Lcom/winemu/core/controller/ProgramController;

    .line 400
    .line 401
    if-nez p1, :cond_14

    .line 402
    .line 403
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 404
    .line 405
    .line 406
    move-object p1, v5

    .line 407
    :cond_14
    new-instance v0, Lcom/winemu/openapi/WinUIBridge$init$1;

    .line 408
    .line 409
    invoke-direct {v0, p0}, Lcom/winemu/openapi/WinUIBridge$init$1;-><init>(Lcom/winemu/openapi/WinUIBridge;)V

    .line 410
    .line 411
    .line 412
    invoke-virtual {p1, v0}, Lcom/winemu/core/controller/ProgramController;->u(Lcom/winemu/core/server/wm/WMCallback;)V

    .line 413
    .line 414
    .line 415
    new-instance p1, Lcom/winemu/core/controller/X11Controller;

    .line 416
    .line 417
    invoke-direct {p1}, Lcom/winemu/core/controller/X11Controller;-><init>()V

    .line 418
    .line 419
    .line 420
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 421
    .line 422
    if-nez v0, :cond_15

    .line 423
    .line 424
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 425
    .line 426
    .line 427
    move-object v0, v5

    .line 428
    :cond_15
    invoke-virtual {v0}, Lcom/winemu/openapi/Config;->B()Lcom/winemu/openapi/Config$Resolution;

    .line 429
    .line 430
    .line 431
    move-result-object v0

    .line 432
    invoke-virtual {v0}, Lcom/winemu/openapi/Config$Resolution;->getWidth()I

    .line 433
    .line 434
    .line 435
    move-result v0

    .line 436
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 437
    .line 438
    if-nez v1, :cond_16

    .line 439
    .line 440
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 441
    .line 442
    .line 443
    move-object v1, v5

    .line 444
    :cond_16
    invoke-virtual {v1}, Lcom/winemu/openapi/Config;->B()Lcom/winemu/openapi/Config$Resolution;

    .line 445
    .line 446
    .line 447
    move-result-object v1

    .line 448
    invoke-virtual {v1}, Lcom/winemu/openapi/Config$Resolution;->getHeight()I

    .line 449
    .line 450
    .line 451
    move-result v1

    .line 452
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->o:Lcom/winemu/core/gamepad/GamepadManager;

    .line 453
    .line 454
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 455
    .line 456
    .line 457
    invoke-virtual {p1, v9, v0, v1, v3}, Lcom/winemu/core/controller/X11Controller;->l(Landroid/app/Activity;IILcom/winemu/core/gamepad/GamepadManager;)V

    .line 458
    .line 459
    .line 460
    new-instance v0, Lcom/winemu/openapi/WinUIBridge$init$2$1;

    .line 461
    .line 462
    invoke-direct {v0, p0}, Lcom/winemu/openapi/WinUIBridge$init$2$1;-><init>(Lcom/winemu/openapi/WinUIBridge;)V

    .line 463
    .line 464
    .line 465
    invoke-virtual {p1, v0}, Lcom/winemu/core/controller/X11Controller;->v(Lcom/winemu/core/controller/X11Controller$WindowEventCallback;)V

    .line 466
    .line 467
    .line 468
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 469
    .line 470
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->U()V

    .line 471
    .line 472
    .line 473
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->V()V

    .line 474
    .line 475
    .line 476
    iget-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 477
    .line 478
    if-nez p1, :cond_17

    .line 479
    .line 480
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 481
    .line 482
    .line 483
    move-object p1, v5

    .line 484
    :cond_17
    invoke-virtual {p1}, Lcom/winemu/openapi/Config;->o()Z

    .line 485
    .line 486
    .line 487
    move-result p1

    .line 488
    const-string v0, "environmentController"

    .line 489
    .line 490
    if-eqz p1, :cond_19

    .line 491
    .line 492
    new-instance p1, Lcom/winemu/core/server/winmonitor/WinMonitorClient;

    .line 493
    .line 494
    sget-object v1, Lcom/winemu/core/utils/PortUtils;->a:Lcom/winemu/core/utils/PortUtils;

    .line 495
    .line 496
    invoke-virtual {v1}, Lcom/winemu/core/utils/PortUtils;->a()I

    .line 497
    .line 498
    .line 499
    move-result v1

    .line 500
    invoke-direct {p1, v1}, Lcom/winemu/core/server/winmonitor/WinMonitorClient;-><init>(I)V

    .line 501
    .line 502
    .line 503
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->n:Lcom/winemu/core/controller/EnvironmentController;

    .line 504
    .line 505
    if-nez v1, :cond_18

    .line 506
    .line 507
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 508
    .line 509
    .line 510
    move-object v1, v5

    .line 511
    :cond_18
    invoke-virtual {v1}, Lcom/winemu/core/controller/EnvironmentController;->a()Lcom/winemu/core/utils/EnvVars;

    .line 512
    .line 513
    .line 514
    move-result-object v1

    .line 515
    invoke-virtual {p1}, Lcom/winemu/core/server/winmonitor/WinMonitorClient;->a()I

    .line 516
    .line 517
    .line 518
    move-result v3

    .line 519
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 520
    .line 521
    .line 522
    move-result-object v3

    .line 523
    const-string v4, "WINMONITOR_PORT"

    .line 524
    .line 525
    invoke-virtual {v1, v4, v3}, Lcom/winemu/core/utils/EnvVars;->d(Ljava/lang/String;Ljava/lang/Object;)V

    .line 526
    .line 527
    .line 528
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->H:Lcom/winemu/core/server/winmonitor/WinMonitorClient;

    .line 529
    .line 530
    :cond_19
    iget-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 531
    .line 532
    if-nez p1, :cond_1a

    .line 533
    .line 534
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 535
    .line 536
    .line 537
    move-object p1, v5

    .line 538
    :cond_1a
    invoke-virtual {p1}, Lcom/winemu/openapi/Config;->m()Z

    .line 539
    .line 540
    .line 541
    move-result p1

    .line 542
    if-eqz p1, :cond_1c

    .line 543
    .line 544
    new-instance p1, Lcom/winemu/core/server/tabtip/TabTipServer;

    .line 545
    .line 546
    sget-object v1, Lcom/winemu/core/utils/PortUtils;->a:Lcom/winemu/core/utils/PortUtils;

    .line 547
    .line 548
    invoke-virtual {v1}, Lcom/winemu/core/utils/PortUtils;->a()I

    .line 549
    .line 550
    .line 551
    move-result v1

    .line 552
    invoke-direct {p1, v1}, Lcom/winemu/core/server/tabtip/TabTipServer;-><init>(I)V

    .line 553
    .line 554
    .line 555
    new-instance v1, Lcom/winemu/openapi/WinUIBridge$init$4$1;

    .line 556
    .line 557
    invoke-direct {v1, p0}, Lcom/winemu/openapi/WinUIBridge$init$4$1;-><init>(Lcom/winemu/openapi/WinUIBridge;)V

    .line 558
    .line 559
    .line 560
    invoke-virtual {p1, v1}, Lcom/winemu/core/server/tabtip/TabTipServer;->k(Lcom/winemu/core/server/tabtip/TabTipServer$KeyboardEventListener;)V

    .line 561
    .line 562
    .line 563
    invoke-virtual {p1}, Lcom/winemu/core/server/tabtip/TabTipServer;->l()Z

    .line 564
    .line 565
    .line 566
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->n:Lcom/winemu/core/controller/EnvironmentController;

    .line 567
    .line 568
    if-nez v1, :cond_1b

    .line 569
    .line 570
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 571
    .line 572
    .line 573
    goto :goto_8

    .line 574
    :cond_1b
    move-object v5, v1

    .line 575
    :goto_8
    invoke-virtual {v5}, Lcom/winemu/core/controller/EnvironmentController;->a()Lcom/winemu/core/utils/EnvVars;

    .line 576
    .line 577
    .line 578
    move-result-object v0

    .line 579
    invoke-virtual {p1}, Lcom/winemu/core/server/tabtip/TabTipServer;->e()I

    .line 580
    .line 581
    .line 582
    move-result v1

    .line 583
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 584
    .line 585
    .line 586
    move-result-object v1

    .line 587
    const-string v2, "TABTIP_PORT"

    .line 588
    .line 589
    invoke-virtual {v0, v2, v1}, Lcom/winemu/core/utils/EnvVars;->d(Ljava/lang/String;Ljava/lang/Object;)V

    .line 590
    .line 591
    .line 592
    const-string v1, "TABTIP_ENABLE_OSK"

    .line 593
    .line 594
    const-string v2, "1"

    .line 595
    .line 596
    invoke-virtual {v0, v1, v2}, Lcom/winemu/core/utils/EnvVars;->d(Ljava/lang/String;Ljava/lang/Object;)V

    .line 597
    .line 598
    .line 599
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->G:Lcom/winemu/core/server/tabtip/TabTipServer;

    .line 600
    .line 601
    :cond_1c
    return-void

    .line 602
    :cond_1d
    new-instance p0, Ljava/lang/IllegalArgumentException;

    .line 603
    .line 604
    const-string p1, "Config must not be null"

    .line 605
    .line 606
    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    .line 607
    .line 608
    .line 609
    throw p0

    .line 610
    :cond_1e
    new-instance p0, Ljava/lang/IllegalArgumentException;

    .line 611
    .line 612
    const-string p1, "Wine instance not found for container"

    .line 613
    .line 614
    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    .line 615
    .line 616
    .line 617
    throw p0

    .line 618
    :cond_1f
    new-instance p0, Ljava/lang/IllegalArgumentException;

    .line 619
    .line 620
    const-string p1, "Container path must not be null or empty"

    .line 621
    .line 622
    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    .line 623
    .line 624
    .line 625
    throw p0
.end method

.method public final R()V
    .locals 0

    .line 1
    const-string p0, "Landroid/view"

    .line 2
    .line 3
    filled-new-array {p0}, [Ljava/lang/String;

    .line 4
    .line 5
    .line 6
    move-result-object p0

    .line 7
    invoke-static {p0}, Lorg/lsposed/hiddenapibypass/HiddenApiBypass;->a([Ljava/lang/String;)Z

    .line 8
    .line 9
    .line 10
    return-void
.end method

.method public final S()V
    .locals 7

    .line 1
    new-instance v0, Ljava/io/File;

    .line 2
    .line 3
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 4
    .line 5
    const/4 v2, 0x0

    .line 6
    if-nez v1, :cond_0

    .line 7
    .line 8
    const-string v1, "fs"

    .line 9
    .line 10
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 11
    .line 12
    .line 13
    move-object v1, v2

    .line 14
    :cond_0
    iget-object v1, v1, Lcom/winemu/core/server/environment/ImageFs;->a:Ljava/io/File;

    .line 15
    .line 16
    const-string v3, ".dr.sock"

    .line 17
    .line 18
    invoke-direct {v0, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 19
    .line 20
    .line 21
    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    .line 22
    .line 23
    .line 24
    move-result-object v0

    .line 25
    sget-object v1, Lcom/winemu/core/DirectRendering;->e:Lcom/winemu/core/DirectRendering$Companion;

    .line 26
    .line 27
    invoke-virtual {v1}, Lcom/winemu/core/DirectRendering$Companion;->b()Lcom/winemu/core/DirectRendering;

    .line 28
    .line 29
    .line 30
    move-result-object v3

    .line 31
    iget-object v4, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 32
    .line 33
    const-string v5, "config"

    .line 34
    .line 35
    if-nez v4, :cond_1

    .line 36
    .line 37
    invoke-static {v5}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 38
    .line 39
    .line 40
    move-object v4, v2

    .line 41
    :cond_1
    invoke-virtual {v4}, Lcom/winemu/openapi/Config;->G()Lcom/winemu/openapi/Config$SurfaceFormat;

    .line 42
    .line 43
    .line 44
    move-result-object v4

    .line 45
    invoke-virtual {v3, v4}, Lcom/winemu/core/DirectRendering;->j(Lcom/winemu/openapi/Config$SurfaceFormat;)V

    .line 46
    .line 47
    .line 48
    invoke-virtual {v1}, Lcom/winemu/core/DirectRendering$Companion;->b()Lcom/winemu/core/DirectRendering;

    .line 49
    .line 50
    .line 51
    move-result-object v3

    .line 52
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 53
    .line 54
    .line 55
    iget-object v4, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 56
    .line 57
    if-nez v4, :cond_2

    .line 58
    .line 59
    invoke-static {v5}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 60
    .line 61
    .line 62
    move-object v4, v2

    .line 63
    :cond_2
    invoke-virtual {v4}, Lcom/winemu/openapi/Config;->B()Lcom/winemu/openapi/Config$Resolution;

    .line 64
    .line 65
    .line 66
    move-result-object v4

    .line 67
    invoke-virtual {v4}, Lcom/winemu/openapi/Config$Resolution;->getWidth()I

    .line 68
    .line 69
    .line 70
    move-result v4

    .line 71
    iget-object v6, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 72
    .line 73
    if-nez v6, :cond_3

    .line 74
    .line 75
    invoke-static {v5}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 76
    .line 77
    .line 78
    move-object v6, v2

    .line 79
    :cond_3
    invoke-virtual {v6}, Lcom/winemu/openapi/Config;->B()Lcom/winemu/openapi/Config$Resolution;

    .line 80
    .line 81
    .line 82
    move-result-object v5

    .line 83
    invoke-virtual {v5}, Lcom/winemu/openapi/Config$Resolution;->getHeight()I

    .line 84
    .line 85
    .line 86
    move-result v5

    .line 87
    invoke-virtual {v3, v0, v4, v5}, Lcom/winemu/core/DirectRendering;->f(Ljava/lang/String;II)V

    .line 88
    .line 89
    .line 90
    new-instance v3, Lcom/winemu/openapi/WinUIBridge$initializeDirectRendering$1;

    .line 91
    .line 92
    invoke-direct {v3, p0}, Lcom/winemu/openapi/WinUIBridge$initializeDirectRendering$1;-><init>(Lcom/winemu/openapi/WinUIBridge;)V

    .line 93
    .line 94
    .line 95
    invoke-virtual {v1, v3}, Lcom/winemu/core/DirectRendering$Companion;->a(Lcom/winemu/core/DirectRenderingStateListener;)V

    .line 96
    .line 97
    .line 98
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->n:Lcom/winemu/core/controller/EnvironmentController;

    .line 99
    .line 100
    if-nez p0, :cond_4

    .line 101
    .line 102
    const-string p0, "environmentController"

    .line 103
    .line 104
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 105
    .line 106
    .line 107
    goto :goto_0

    .line 108
    :cond_4
    move-object v2, p0

    .line 109
    :goto_0
    invoke-virtual {v2}, Lcom/winemu/core/controller/EnvironmentController;->a()Lcom/winemu/core/utils/EnvVars;

    .line 110
    .line 111
    .line 112
    move-result-object p0

    .line 113
    const-string v1, "DR_SOCK_PATH"

    .line 114
    .line 115
    invoke-virtual {p0, v1, v0}, Lcom/winemu/core/utils/EnvVars;->d(Ljava/lang/String;Ljava/lang/Object;)V

    .line 116
    .line 117
    .line 118
    return-void
.end method

.method public final T()V
    .locals 4

    .line 1
    new-instance v0, Ljava/io/File;

    .line 2
    .line 3
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->c:Lcom/winemu/core/server/environment/ImageFs;

    .line 4
    .line 5
    const/4 v2, 0x0

    .line 6
    if-nez v1, :cond_0

    .line 7
    .line 8
    const-string v1, "fs"

    .line 9
    .line 10
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 11
    .line 12
    .line 13
    move-object v1, v2

    .line 14
    :cond_0
    iget-object v1, v1, Lcom/winemu/core/server/environment/ImageFs;->a:Ljava/io/File;

    .line 15
    .line 16
    const-string v3, ".gamepad.sock"

    .line 17
    .line 18
    invoke-direct {v0, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 19
    .line 20
    .line 21
    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    .line 22
    .line 23
    .line 24
    move-result-object v0

    .line 25
    sget-object v1, Lcom/winemu/core/gamepad/GamepadManager;->o:Lcom/winemu/core/gamepad/GamepadManager$Companion;

    .line 26
    .line 27
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->r:Landroid/app/Activity;

    .line 28
    .line 29
    if-nez v3, :cond_1

    .line 30
    .line 31
    const-string v3, "activity"

    .line 32
    .line 33
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 34
    .line 35
    .line 36
    move-object v3, v2

    .line 37
    :cond_1
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 38
    .line 39
    .line 40
    invoke-virtual {v1, v3, v0}, Lcom/winemu/core/gamepad/GamepadManager$Companion;->a(Landroid/content/Context;Ljava/lang/String;)Lcom/winemu/core/gamepad/GamepadManager;

    .line 41
    .line 42
    .line 43
    move-result-object v1

    .line 44
    iput-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->o:Lcom/winemu/core/gamepad/GamepadManager;

    .line 45
    .line 46
    if-eqz v1, :cond_2

    .line 47
    .line 48
    new-instance v3, Lcom/winemu/openapi/WinUIBridge$initializeGamepadManager$1$1;

    .line 49
    .line 50
    invoke-direct {v3}, Lcom/winemu/openapi/WinUIBridge$initializeGamepadManager$1$1;-><init>()V

    .line 51
    .line 52
    .line 53
    invoke-virtual {v1, v3}, Lcom/winemu/core/gamepad/GamepadManager;->i(Lcom/winemu/core/gamepad/GamepadEventListener;)V

    .line 54
    .line 55
    .line 56
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->g:Lcom/winemu/core/controller/SteamAgentController;

    .line 57
    .line 58
    invoke-virtual {v1, v3}, Lcom/winemu/core/gamepad/GamepadManager;->h1(Lcom/winemu/core/gamepad/GamepadSlotChangeListener;)V

    .line 59
    .line 60
    .line 61
    invoke-virtual {v1}, Lcom/winemu/core/gamepad/GamepadManager;->r1()V

    .line 62
    .line 63
    .line 64
    :cond_2
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->g:Lcom/winemu/core/controller/SteamAgentController;

    .line 65
    .line 66
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->o:Lcom/winemu/core/gamepad/GamepadManager;

    .line 67
    .line 68
    invoke-virtual {v1, v3}, Lcom/winemu/core/controller/SteamAgentController;->h(Lcom/winemu/core/gamepad/SteamInputVdfProvider;)V

    .line 69
    .line 70
    .line 71
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->n:Lcom/winemu/core/controller/EnvironmentController;

    .line 72
    .line 73
    if-nez p0, :cond_3

    .line 74
    .line 75
    const-string p0, "environmentController"

    .line 76
    .line 77
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 78
    .line 79
    .line 80
    goto :goto_0

    .line 81
    :cond_3
    move-object v2, p0

    .line 82
    :goto_0
    invoke-virtual {v2}, Lcom/winemu/core/controller/EnvironmentController;->a()Lcom/winemu/core/utils/EnvVars;

    .line 83
    .line 84
    .line 85
    move-result-object p0

    .line 86
    const-string v1, "GAMEPAD_SOCK_PATH"

    .line 87
    .line 88
    invoke-virtual {p0, v1, v0}, Lcom/winemu/core/utils/EnvVars;->d(Ljava/lang/String;Ljava/lang/Object;)V

    .line 89
    .line 90
    .line 91
    return-void
.end method

.method public final U()V
    .locals 4

    .line 1
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 2
    .line 3
    const/4 v1, 0x0

    .line 4
    const-string v2, "config"

    .line 5
    .line 6
    if-nez v0, :cond_0

    .line 7
    .line 8
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    move-object v0, v1

    .line 12
    :cond_0
    invoke-virtual {v0}, Lcom/winemu/openapi/Config;->z()Ljava/lang/String;

    .line 13
    .line 14
    .line 15
    move-result-object v0

    .line 16
    invoke-interface {v0}, Ljava/lang/CharSequence;->length()I

    .line 17
    .line 18
    .line 19
    move-result v0

    .line 20
    if-lez v0, :cond_4

    .line 21
    .line 22
    :try_start_0
    new-instance v0, Ljava/io/File;

    .line 23
    .line 24
    iget-object v3, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 25
    .line 26
    if-nez v3, :cond_1

    .line 27
    .line 28
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 29
    .line 30
    .line 31
    goto :goto_0

    .line 32
    :cond_1
    move-object v1, v3

    .line 33
    :goto_0
    invoke-virtual {v1}, Lcom/winemu/openapi/Config;->z()Ljava/lang/String;

    .line 34
    .line 35
    .line 36
    move-result-object v1

    .line 37
    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 38
    .line 39
    .line 40
    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    .line 41
    .line 42
    .line 43
    move-result v1

    .line 44
    if-eqz v1, :cond_2

    .line 45
    .line 46
    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    .line 47
    .line 48
    .line 49
    :cond_2
    invoke-virtual {v0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    .line 50
    .line 51
    .line 52
    move-result-object v1

    .line 53
    if-eqz v1, :cond_3

    .line 54
    .line 55
    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    .line 56
    .line 57
    .line 58
    :cond_3
    new-instance v1, Ljava/io/FileWriter;

    .line 59
    .line 60
    const/4 v2, 0x1

    .line 61
    invoke-direct {v1, v0, v2}, Ljava/io/FileWriter;-><init>(Ljava/io/File;Z)V

    .line 62
    .line 63
    .line 64
    iput-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->E:Ljava/io/FileWriter;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 65
    .line 66
    return-void

    .line 67
    :catch_0
    move-exception p0

    .line 68
    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    .line 69
    .line 70
    .line 71
    move-result-object p0

    .line 72
    new-instance v0, Ljava/lang/StringBuilder;

    .line 73
    .line 74
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 75
    .line 76
    .line 77
    const-string v1, "Failed to initialize log file: "

    .line 78
    .line 79
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 80
    .line 81
    .line 82
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 83
    .line 84
    .line 85
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 86
    .line 87
    .line 88
    move-result-object p0

    .line 89
    const-string v0, "EmuWindowContext"

    .line 90
    .line 91
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 92
    .line 93
    .line 94
    :cond_4
    return-void
.end method

.method public final V()V
    .locals 5

    .line 1
    const-string v0, "EmuWindowContext"

    .line 2
    .line 3
    iget-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 4
    .line 5
    const/4 v2, 0x0

    .line 6
    if-nez v1, :cond_0

    .line 7
    .line 8
    const-string v1, "config"

    .line 9
    .line 10
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 11
    .line 12
    .line 13
    move-object v1, v2

    .line 14
    :cond_0
    invoke-virtual {v1}, Lcom/winemu/openapi/Config;->k()Z

    .line 15
    .line 16
    .line 17
    move-result v1

    .line 18
    if-eqz v1, :cond_2

    .line 19
    .line 20
    :try_start_0
    new-instance v1, Lcom/winemu/core/server/log/LogHttpServer;

    .line 21
    .line 22
    const/4 v3, 0x0

    .line 23
    const/4 v4, 0x1

    .line 24
    invoke-direct {v1, v3, v4, v2}, Lcom/winemu/core/server/log/LogHttpServer;-><init>(IILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 25
    .line 26
    .line 27
    iput-object v1, p0, Lcom/winemu/openapi/WinUIBridge;->F:Lcom/winemu/core/server/log/LogHttpServer;

    .line 28
    .line 29
    invoke-virtual {v1}, Lcom/winemu/core/server/log/LogHttpServer;->m()V

    .line 30
    .line 31
    .line 32
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->F:Lcom/winemu/core/server/log/LogHttpServer;

    .line 33
    .line 34
    if-eqz p0, :cond_1

    .line 35
    .line 36
    invoke-virtual {p0}, Lcom/winemu/core/server/log/LogHttpServer;->h()Ljava/lang/String;

    .line 37
    .line 38
    .line 39
    move-result-object v2

    .line 40
    goto :goto_0

    .line 41
    :catch_0
    move-exception p0

    .line 42
    goto :goto_1

    .line 43
    :cond_1
    :goto_0
    new-instance p0, Ljava/lang/StringBuilder;

    .line 44
    .line 45
    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    .line 46
    .line 47
    .line 48
    const-string v1, "Log HTTP server started: "

    .line 49
    .line 50
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 51
    .line 52
    .line 53
    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 54
    .line 55
    .line 56
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 57
    .line 58
    .line 59
    move-result-object p0

    .line 60
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 61
    .line 62
    .line 63
    return-void

    .line 64
    :goto_1
    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    .line 65
    .line 66
    .line 67
    move-result-object p0

    .line 68
    new-instance v1, Ljava/lang/StringBuilder;

    .line 69
    .line 70
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 71
    .line 72
    .line 73
    const-string v2, "Failed to start log HTTP server: "

    .line 74
    .line 75
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 76
    .line 77
    .line 78
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 79
    .line 80
    .line 81
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 82
    .line 83
    .line 84
    move-result-object p0

    .line 85
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 86
    .line 87
    .line 88
    :cond_2
    return-void
.end method

.method public final W()Z
    .locals 0

    .line 1
    iget-boolean p0, p0, Lcom/winemu/openapi/WinUIBridge;->v:Z

    .line 2
    .line 3
    return p0
.end method

.method public final X()Z
    .locals 0

    .line 1
    iget-boolean p0, p0, Lcom/winemu/openapi/WinUIBridge;->I:Z

    .line 2
    .line 3
    return p0
.end method

.method public final Y(I)Z
    .locals 3

    .line 1
    const/4 p0, 0x4

    .line 2
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 3
    .line 4
    .line 5
    move-result-object p0

    .line 6
    const/4 v0, 0x3

    .line 7
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 8
    .line 9
    .line 10
    move-result-object v0

    .line 11
    const/16 v1, 0x52

    .line 12
    .line 13
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 14
    .line 15
    .line 16
    move-result-object v1

    .line 17
    const/16 v2, 0x54

    .line 18
    .line 19
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 20
    .line 21
    .line 22
    move-result-object v2

    .line 23
    filled-new-array {p0, v0, v1, v2}, [Ljava/lang/Integer;

    .line 24
    .line 25
    .line 26
    move-result-object p0

    .line 27
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 28
    .line 29
    .line 30
    move-result-object p1

    .line 31
    invoke-static {p0, p1}, Lkotlin/collections/ArraysKt;->W([Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 32
    .line 33
    .line 34
    move-result p0

    .line 35
    return p0
.end method

.method public final Z()V
    .locals 3

    .line 1
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->p:Lkotlinx/coroutines/Job;

    .line 2
    .line 3
    if-eqz v0, :cond_0

    .line 4
    .line 5
    const/4 v1, 0x1

    .line 6
    const/4 v2, 0x0

    .line 7
    invoke-static {v0, v2, v1, v2}, Lkotlinx/coroutines/Job$DefaultImpls;->b(Lkotlinx/coroutines/Job;Ljava/util/concurrent/CancellationException;ILjava/lang/Object;)V

    .line 8
    .line 9
    .line 10
    :cond_0
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->o:Lcom/winemu/core/gamepad/GamepadManager;

    .line 11
    .line 12
    if-eqz p0, :cond_1

    .line 13
    .line 14
    invoke-virtual {p0}, Lcom/winemu/core/gamepad/GamepadManager;->close()V

    .line 15
    .line 16
    .line 17
    :cond_1
    return-void
.end method

.method public final a0()V
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->j:Lcom/winemu/core/controller/ProgramController;

    .line 2
    .line 3
    const/4 v1, 0x0

    .line 4
    if-nez v0, :cond_0

    .line 5
    .line 6
    const-string v0, "programController"

    .line 7
    .line 8
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    move-object v0, v1

    .line 12
    :cond_0
    invoke-virtual {v0}, Lcom/winemu/core/controller/ProgramController;->q()V

    .line 13
    .line 14
    .line 15
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->l:Lcom/winemu/core/controller/ContainerController;

    .line 16
    .line 17
    if-nez p0, :cond_1

    .line 18
    .line 19
    const-string p0, "containerController"

    .line 20
    .line 21
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 22
    .line 23
    .line 24
    goto :goto_0

    .line 25
    :cond_1
    move-object v1, p0

    .line 26
    :goto_0
    invoke-virtual {v1}, Lcom/winemu/core/controller/ContainerController;->q()V

    .line 27
    .line 28
    .line 29
    return-void
.end method

.method public final b0()V
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->j:Lcom/winemu/core/controller/ProgramController;

    .line 2
    .line 3
    const/4 v1, 0x0

    .line 4
    if-nez v0, :cond_0

    .line 5
    .line 6
    const-string v0, "programController"

    .line 7
    .line 8
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    move-object v0, v1

    .line 12
    :cond_0
    invoke-virtual {v0}, Lcom/winemu/core/controller/ProgramController;->r()V

    .line 13
    .line 14
    .line 15
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->l:Lcom/winemu/core/controller/ContainerController;

    .line 16
    .line 17
    if-nez p0, :cond_1

    .line 18
    .line 19
    const-string p0, "containerController"

    .line 20
    .line 21
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 22
    .line 23
    .line 24
    goto :goto_0

    .line 25
    :cond_1
    move-object v1, p0

    .line 26
    :goto_0
    invoke-virtual {v1}, Lcom/winemu/core/controller/ContainerController;->r()V

    .line 27
    .line 28
    .line 29
    return-void
.end method

.method public final c0()V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "x11Controller"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0}, Lcom/winemu/core/controller/X11Controller;->o()V

    .line 12
    .line 13
    .line 14
    return-void
.end method

.method public final d0(IIZ)V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "x11Controller"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Lcom/winemu/core/controller/X11Controller;->p(IIZ)V

    .line 12
    .line 13
    .line 14
    return-void
.end method

.method public final e0(Landroid/view/KeyEvent;)V
    .locals 2

    .line 1
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    .line 2
    .line 3
    .line 4
    move-result p0

    .line 5
    const/4 v0, 0x1

    .line 6
    const/4 v1, 0x0

    .line 7
    if-eqz p0, :cond_1

    .line 8
    .line 9
    if-eq p0, v0, :cond_0

    .line 10
    .line 11
    return-void

    .line 12
    :cond_0
    sget-object p0, Lcom/winemu/core/server/XServer;->INSTANCE:Lcom/winemu/core/server/XServer;

    .line 13
    .line 14
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 15
    .line 16
    .line 17
    move-result p1

    .line 18
    invoke-virtual {p0, v1, p1, v1}, Lcom/winemu/core/server/XServer;->sendKeyEvent(IIZ)Z

    .line 19
    .line 20
    .line 21
    return-void

    .line 22
    :cond_1
    sget-object p0, Lcom/winemu/core/server/XServer;->INSTANCE:Lcom/winemu/core/server/XServer;

    .line 23
    .line 24
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 25
    .line 26
    .line 27
    move-result p1

    .line 28
    invoke-virtual {p0, v1, p1, v0}, Lcom/winemu/core/server/XServer;->sendKeyEvent(IIZ)Z

    .line 29
    .line 30
    .line 31
    return-void
.end method

.method public final f0(FFIZZ)V
    .locals 6

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 2
    .line 3
    if-nez p0, :cond_0

    # X11Controller is null - just return silently instead of throwing
    return-void

    :cond_0
    move-object v0, p0

    .line 12
    move v1, p1

    .line 13
    move v2, p2

    .line 14
    move v3, p3

    .line 15
    move v4, p4

    .line 16
    move v5, p5

    .line 17
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/core/controller/X11Controller;->q(FFIZZ)V

    .line 18
    .line 19
    .line 20
    return-void
.end method

.method public final g0(Lcom/winemu/openapi/DirectRenderingMode;)V
    .locals 1

    .line 1
    const-string v0, "mode"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->h:Lcom/winemu/core/controller/GameScopeController;

    .line 7
    .line 8
    if-eqz p0, :cond_0

    .line 9
    .line 10
    invoke-virtual {p0, p1}, Lcom/winemu/core/controller/GameScopeController;->b(Lcom/winemu/openapi/DirectRenderingMode;)V

    .line 11
    .line 12
    .line 13
    :cond_0
    return-void
.end method

.method public final h0(Lkotlin/jvm/functions/Function0;)V
    .locals 1

    .line 1
    const-string v0, "callback"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->y:Lkotlin/jvm/functions/Function0;

    .line 7
    .line 8
    return-void
.end method

.method public final i0(Z)V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "x11Controller"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0, p1}, Lcom/winemu/core/controller/X11Controller;->r(Z)V

    .line 12
    .line 13
    .line 14
    return-void
.end method

.method public final j0(Lcom/winemu/openapi/WinUIBridge$KeyboardEventListener;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->x:Lcom/winemu/openapi/WinUIBridge$KeyboardEventListener;

    .line 2
    .line 3
    return-void
.end method

.method public final k0(I)V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->h:Lcom/winemu/core/controller/GameScopeController;

    .line 2
    .line 3
    if-eqz p0, :cond_0

    .line 4
    .line 5
    invoke-virtual {p0, p1}, Lcom/winemu/core/controller/GameScopeController;->d(I)V

    .line 6
    .line 7
    .line 8
    :cond_0
    return-void
.end method

.method public final l0(Lcom/winemu/core/server/perf/PerfEventListener;)V
    .locals 1

    .line 1
    const-string v0, "listener"

    .line 2
    .line 3
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->C:Lcom/winemu/core/server/perf/PerfEventListener;

    .line 7
    .line 8
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->j:Lcom/winemu/core/controller/ProgramController;

    .line 9
    .line 10
    if-nez p0, :cond_0

    .line 11
    .line 12
    const-string p0, "programController"

    .line 13
    .line 14
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 15
    .line 16
    .line 17
    const/4 p0, 0x0

    .line 18
    :cond_0
    invoke-virtual {p0, p1}, Lcom/winemu/core/controller/ProgramController;->t(Lcom/winemu/core/server/perf/PerfEventListener;)V

    .line 19
    .line 20
    .line 21
    return-void
.end method

.method public final m0(ILjava/lang/String;)V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->o:Lcom/winemu/core/gamepad/GamepadManager;

    .line 2
    .line 3
    if-eqz p0, :cond_0

    .line 4
    .line 5
    invoke-virtual {p0, p1, p2}, Lcom/winemu/core/gamepad/GamepadManager;->q1(ILjava/lang/String;)V

    .line 6
    .line 7
    .line 8
    :cond_0
    return-void
.end method

.method public final n0(Lkotlin/jvm/functions/Function1;)V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->g:Lcom/winemu/core/controller/SteamAgentController;

    .line 2
    .line 3
    invoke-virtual {p0, p1}, Lcom/winemu/core/controller/SteamAgentController;->g(Lkotlin/jvm/functions/Function1;)V

    .line 4
    .line 5
    .line 6
    return-void
.end method

.method public final o0(Z)V
    .locals 0

    .line 1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    .line 2
    .line 3
    if-nez p0, :cond_0

    .line 4
    .line 5
    const-string p0, "x11Controller"

    .line 6
    .line 7
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 p0, 0x0

    .line 11
    :cond_0
    invoke-virtual {p0, p1}, Lcom/winemu/core/controller/X11Controller;->u(Z)V

    .line 12
    .line 13
    .line 14
    return-void
.end method

.method public final p0(Lkotlin/jvm/functions/Function0;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/winemu/openapi/WinUIBridge;->D:Lkotlin/jvm/functions/Function0;

    .line 2
    .line 3
    return-void
.end method

.method public final q0(Landroid/view/KeyEvent;)Z
    .locals 16

    .line 1
    invoke-virtual/range {p1 .. p1}, Landroid/view/KeyEvent;->isMetaPressed()Z

    .line 2
    .line 3
    .line 4
    move-result v0

    .line 5
    if-eqz v0, :cond_0

    .line 6
    .line 7
    const/4 v0, 0x0

    .line 8
    return v0

    .line 9
    :cond_0
    const/4 v0, 0x4

    .line 10
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 11
    .line 12
    .line 13
    move-result-object v1

    .line 14
    const/4 v0, 0x3

    .line 15
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 16
    .line 17
    .line 18
    move-result-object v2

    .line 19
    const/16 v0, 0x52

    .line 20
    .line 21
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 22
    .line 23
    .line 24
    move-result-object v3

    .line 25
    const/16 v0, 0x54

    .line 26
    .line 27
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 28
    .line 29
    .line 30
    move-result-object v4

    .line 31
    const/16 v0, 0x18

    .line 32
    .line 33
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 34
    .line 35
    .line 36
    move-result-object v5

    .line 37
    const/16 v0, 0x19

    .line 38
    .line 39
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 40
    .line 41
    .line 42
    move-result-object v6

    .line 43
    const/16 v0, 0xa4

    .line 44
    .line 45
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 46
    .line 47
    .line 48
    move-result-object v7

    .line 49
    const/16 v0, 0x1a

    .line 50
    .line 51
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 52
    .line 53
    .line 54
    move-result-object v8

    .line 55
    const/16 v0, 0x1b

    .line 56
    .line 57
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 58
    .line 59
    .line 60
    move-result-object v9

    .line 61
    const/16 v0, 0x50

    .line 62
    .line 63
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 64
    .line 65
    .line 66
    move-result-object v10

    .line 67
    const/4 v0, 0x5

    .line 68
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 69
    .line 70
    .line 71
    move-result-object v11

    .line 72
    const/4 v0, 0x6

    .line 73
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 74
    .line 75
    .line 76
    move-result-object v12

    .line 77
    const/16 v0, 0x53

    .line 78
    .line 79
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 80
    .line 81
    .line 82
    move-result-object v13

    .line 83
    const/16 v0, 0x5b

    .line 84
    .line 85
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 86
    .line 87
    .line 88
    move-result-object v14

    .line 89
    const/16 v0, 0x4f

    .line 90
    .line 91
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 92
    .line 93
    .line 94
    move-result-object v15

    .line 95
    filled-new-array/range {v1 .. v15}, [Ljava/lang/Integer;

    .line 96
    .line 97
    .line 98
    move-result-object v0

    .line 99
    invoke-virtual/range {p1 .. p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 100
    .line 101
    .line 102
    move-result v1

    .line 103
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 104
    .line 105
    .line 106
    move-result-object v1

    .line 107
    invoke-static {v0, v1}, Lkotlin/collections/ArraysKt;->W([Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 108
    .line 109
    .line 110
    move-result v0

    .line 111
    xor-int/lit8 v0, v0, 0x1

    .line 112
    .line 113
    return v0
.end method

.method public final r0()V
    .locals 2

    .line 1
    iget-boolean v0, p0, Lcom/winemu/openapi/WinUIBridge;->B:Z

    .line 2
    .line 3
    if-eqz v0, :cond_0

    .line 4
    .line 5
    goto :goto_0

    .line 6
    :cond_0
    const/4 v0, 0x1

    .line 7
    iput-boolean v0, p0, Lcom/winemu/openapi/WinUIBridge;->B:Z

    .line 8
    .line 9
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->A:Landroid/view/ViewGroup;

    .line 10
    .line 11
    if-eqz v0, :cond_1

    .line 12
    .line 13
    new-instance v1, Lcom/winemu/openapi/b;

    .line 14
    .line 15
    invoke-direct {v1, v0, p0}, Lcom/winemu/openapi/b;-><init>(Landroid/view/ViewGroup;Lcom/winemu/openapi/WinUIBridge;)V

    .line 16
    .line 17
    .line 18
    invoke-virtual {v0, v1}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 19
    .line 20
    .line 21
    :cond_1
    :goto_0
    return-void
.end method

.method public final w0()V
    .locals 6

    .line 1
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->b:Lkotlinx/coroutines/CoroutineScope;

    .line 2
    .line 3
    new-instance v3, Lcom/winemu/openapi/WinUIBridge$watchWineServerProcess$1;

    .line 4
    .line 5
    const/4 v1, 0x0

    .line 6
    invoke-direct {v3, p0, v1}, Lcom/winemu/openapi/WinUIBridge$watchWineServerProcess$1;-><init>(Lcom/winemu/openapi/WinUIBridge;Lkotlin/coroutines/Continuation;)V

    .line 7
    .line 8
    .line 9
    const/4 v4, 0x3

    .line 10
    const/4 v5, 0x0

    .line 11
    const/4 v2, 0x0

    .line 12
    invoke-static/range {v0 .. v5}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 13
    .line 14
    .line 15
    return-void
.end method

.method public final x0(Ljava/lang/String;)V
    .locals 4

    .line 1
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->q:Lcom/winemu/openapi/Config;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    const-string v0, "config"

    .line 6
    .line 7
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    const/4 v0, 0x0

    .line 11
    :cond_0
    invoke-virtual {v0}, Lcom/winemu/openapi/Config;->z()Ljava/lang/String;

    .line 12
    .line 13
    .line 14
    move-result-object v0

    .line 15
    invoke-interface {v0}, Ljava/lang/CharSequence;->length()I

    .line 16
    .line 17
    .line 18
    move-result v0

    .line 19
    if-lez v0, :cond_2

    .line 20
    .line 21
    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->E:Ljava/io/FileWriter;

    .line 22
    .line 23
    if-eqz v0, :cond_2

    .line 24
    .line 25
    if-eqz v0, :cond_1

    .line 26
    .line 27
    :try_start_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    .line 28
    .line 29
    .line 30
    move-result-wide v1

    .line 31
    new-instance v3, Ljava/lang/StringBuilder;

    .line 32
    .line 33
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    .line 34
    .line 35
    .line 36
    invoke-virtual {v3, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    .line 37
    .line 38
    .line 39
    const-string v1, ": "

    .line 40
    .line 41
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 42
    .line 43
    .line 44
    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 45
    .line 46
    .line 47
    const-string p1, "\n"

    .line 48
    .line 49
    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 50
    .line 51
    .line 52
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 53
    .line 54
    .line 55
    move-result-object p1

    .line 56
    invoke-virtual {v0, p1}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    .line 57
    .line 58
    .line 59
    :cond_1
    iget-object p0, p0, Lcom/winemu/openapi/WinUIBridge;->E:Ljava/io/FileWriter;

    .line 60
    .line 61
    if-eqz p0, :cond_2

    .line 62
    .line 63
    invoke-virtual {p0}, Ljava/io/Writer;->flush()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 64
    .line 65
    .line 66
    return-void

    .line 67
    :catch_0
    move-exception p0

    .line 68
    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    .line 69
    .line 70
    .line 71
    move-result-object p0

    .line 72
    new-instance p1, Ljava/lang/StringBuilder;

    .line 73
    .line 74
    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    .line 75
    .line 76
    .line 77
    const-string v0, "Failed to write to log file: "

    .line 78
    .line 79
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 80
    .line 81
    .line 82
    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 83
    .line 84
    .line 85
    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 86
    .line 87
    .line 88
    move-result-object p0

    .line 89
    const-string p1, "EmuWindowContext"

    .line 90
    .line 91
    invoke-static {p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 92
    .line 93
    .line 94
    :cond_2
    return-void
.end method

.method public final setTrackpadInputMode(I)V
    .locals 1

    iget-object v0, p0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;

    if-eqz v0, :cond_end

    invoke-virtual {v0, p1}, Lcom/winemu/core/controller/X11Controller;->setTrackpadInputMode(I)V

    :cond_end
    return-void
.end method
