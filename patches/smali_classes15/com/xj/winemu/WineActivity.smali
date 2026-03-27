.class public final Lcom/xj/winemu/WineActivity;
.super Lcom/xj/common/view/focus/focus/app/FocusableAppCompatActivity;
.source "r8-map-id-712846b76e3224c0169ce621759774aea144e14d75c3fb3c733f7f2b03c1bb19"

# interfaces
.implements Lcom/winemu/core/gamepad/GamepadEventListener;
.implements Lcom/xj/winemu/iterface/IGamePadManagerOwner;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/xj/winemu/WineActivity$Companion;
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
.end annotation

.annotation build Lkotlin/jvm/internal/SourceDebugExtension;
.end annotation


# static fields
.field public static final O:Lcom/xj/winemu/WineActivity$Companion;


# instance fields
.field public A:Lcom/winemu/core/gamepad/VirtualGamepadController;

.field public B:Lcom/xj/winemu/utils/WineInGameSettings;

.field public C:Lcom/lxj/xpopup/impl/LoadingPopupView;

.field public D:Lkotlinx/coroutines/Job;

.field public final E:Lkotlin/Lazy;

.field public final F:Lkotlin/Lazy;

.field public G:Lkotlinx/coroutines/Job;

.field public H:Lkotlinx/coroutines/Job;

.field public I:Z

.field public J:Z

.field public K:Ljava/lang/String;

.field public final L:Lcom/xj/winemu/WineActivity$mDeviceConnectReceiver$1;

.field public M:Z

.field public N:Z

.field public g:Lcom/xj/winemu/databinding/ActivityWineBinding;

.field public h:Lcom/winemu/openapi/WinUIBridge;

.field public i:Lcom/winemu/ui/HUDUpdater;

.field public j:Lcom/xj/winemu/utils/HudDataProvider;

.field public k:Lcom/xj/winemu/ui/WineUIContainerManager;

.field public final l:Ljava/util/Map;

.field public final m:Lcom/winemu/openapi/HDREffect;

.field public final n:Lcom/winemu/openapi/CASEffect;

.field public final o:Lcom/winemu/openapi/CRTEffect;

.field public p:Z

.field public q:Z

.field public r:Ljava/lang/Integer;

.field public s:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

.field public final t:Lcom/tencent/mmkv/MMKV;

.field public u:Lcom/xj/winemu/api/bean/WineActivityData;

.field public v:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;

.field public w:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;

.field public x:Lcom/xj/winemu/utils/WineGameUsageTracker;

.field public final y:F

.field public z:Lcom/winemu/core/gamepad/GamepadManager;

.field public t0:Lcom/xj/winemu/view/RtsTouchOverlayView;

.field public static t1:Lcom/xj/winemu/WineActivity;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    .line 2
    new-instance v0, Lcom/xj/winemu/WineActivity$Companion;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    .line 6
    invoke-direct {v0, v1}, Lcom/xj/winemu/WineActivity$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 7
    .line 8
    sput-object v0, Lcom/xj/winemu/WineActivity;->O:Lcom/xj/winemu/WineActivity$Companion;

    .line 9
    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-direct {p0}, Lcom/xj/common/view/focus/focus/app/FocusableAppCompatActivity;-><init>()V

    .line 4
    .line 5
    new-instance v0, Ljava/util/LinkedHashMap;

    .line 6
    .line 7
    .line 8
    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    .line 9
    .line 10
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->l:Ljava/util/Map;

    .line 11
    .line 12
    new-instance v0, Lcom/winemu/openapi/HDREffect;

    .line 13
    .line 14
    .line 15
    invoke-direct {v0}, Lcom/winemu/openapi/HDREffect;-><init>()V

    .line 16
    .line 17
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->m:Lcom/winemu/openapi/HDREffect;

    .line 18
    .line 19
    new-instance v0, Lcom/winemu/openapi/CASEffect;

    .line 20
    .line 21
    .line 22
    invoke-direct {v0}, Lcom/winemu/openapi/CASEffect;-><init>()V

    .line 23
    .line 24
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->n:Lcom/winemu/openapi/CASEffect;

    .line 25
    .line 26
    new-instance v0, Lcom/winemu/openapi/CRTEffect;

    .line 27
    .line 28
    .line 29
    invoke-direct {v0}, Lcom/winemu/openapi/CRTEffect;-><init>()V

    .line 30
    .line 31
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->o:Lcom/winemu/openapi/CRTEffect;

    .line 32
    .line 33
    sget-object v0, Lcom/xj/winemu/sidebar/PcEmuGameLocalConfigHelper;->a:Lcom/xj/winemu/sidebar/PcEmuGameLocalConfigHelper;

    .line 34
    .line 35
    .line 36
    invoke-virtual {v0}, Lcom/xj/winemu/sidebar/PcEmuGameLocalConfigHelper;->a()Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 37
    move-result-object v0

    .line 38
    .line 39
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->s:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 40
    .line 41
    const-string v0, "WineFile"

    .line 42
    const/4 v1, 0x2

    .line 43
    .line 44
    .line 45
    invoke-static {v0, v1}, Lcom/tencent/mmkv/MMKV;->F(Ljava/lang/String;I)Lcom/tencent/mmkv/MMKV;

    .line 46
    move-result-object v0

    .line 47
    .line 48
    const-string v1, "mmkvWithID(...)"

    .line 49
    .line 50
    .line 51
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 52
    .line 53
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->t:Lcom/tencent/mmkv/MMKV;

    .line 54
    .line 55
    sget v0, Lcom/xj/common/R$dimen;->dp_372:I

    .line 56
    .line 57
    .line 58
    invoke-static {v0}, Lcom/xj/common/utils/DimensionExtKt;->c(I)F

    .line 59
    move-result v0

    .line 60
    .line 61
    iput v0, p0, Lcom/xj/winemu/WineActivity;->y:F

    .line 62
    .line 63
    new-instance v0, Lcom/xj/winemu/w;

    .line 64
    .line 65
    .line 66
    invoke-direct {v0, p0}, Lcom/xj/winemu/w;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 67
    .line 68
    .line 69
    invoke-static {v0}, Lkotlin/LazyKt;->b(Lkotlin/jvm/functions/Function0;)Lkotlin/Lazy;

    .line 70
    move-result-object v0

    .line 71
    .line 72
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->E:Lkotlin/Lazy;

    .line 73
    .line 74
    new-instance v0, Lcom/xj/winemu/x;

    .line 75
    .line 76
    .line 77
    invoke-direct {v0}, Lcom/xj/winemu/x;-><init>()V

    .line 78
    .line 79
    .line 80
    invoke-static {v0}, Lkotlin/LazyKt;->b(Lkotlin/jvm/functions/Function0;)Lkotlin/Lazy;

    .line 81
    move-result-object v0

    .line 82
    .line 83
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->F:Lkotlin/Lazy;

    .line 84
    .line 85
    const-string v0, ""

    .line 86
    .line 87
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->K:Ljava/lang/String;

    .line 88
    .line 89
    new-instance v0, Lcom/xj/winemu/WineActivity$mDeviceConnectReceiver$1;

    .line 90
    .line 91
    .line 92
    invoke-direct {v0, p0}, Lcom/xj/winemu/WineActivity$mDeviceConnectReceiver$1;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 93
    .line 94
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->L:Lcom/xj/winemu/WineActivity$mDeviceConnectReceiver$1;

    .line 95
    return-void
.end method

.method public static final synthetic A1(Lcom/xj/winemu/WineActivity;)Ljava/lang/String;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->t2()Ljava/lang/String;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final synthetic B1(Lcom/xj/winemu/WineActivity;)Ljava/util/Map;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->l:Ljava/util/Map;

    .line 3
    return-object p0
.end method

.method public static final synthetic C1(Lcom/xj/winemu/WineActivity;)Lcom/lxj/xpopup/impl/LoadingPopupView;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->C:Lcom/lxj/xpopup/impl/LoadingPopupView;

    .line 3
    return-object p0
.end method

.method public static final C2(Lcom/xj/winemu/databinding/ItemGamePadListBinding;Lcom/xj/winemu/bean/GamePad;)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    const-string v0, "binding"

    .line 3
    .line 4
    .line 5
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    const-string v0, "data"

    .line 8
    .line 9
    .line 10
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 11
    .line 12
    iget-object p0, p0, Lcom/xj/winemu/databinding/ItemGamePadListBinding;->tvTitle:Lcom/luck/picture/lib/widget/MarqueeTextView;

    .line 13
    .line 14
    instance-of v0, p1, Lcom/xj/winemu/bean/GamePad$Virtual;

    .line 15
    .line 16
    if-eqz v0, :cond_0

    .line 17
    .line 18
    sget p1, Lcom/xj/language/R$string;->winemu_controller_virtual_gamepad:I

    .line 19
    .line 20
    .line 21
    invoke-static {p1}, Lcom/xj/common/utils/LLExtKt;->j(I)Ljava/lang/String;

    .line 22
    move-result-object p1

    .line 23
    goto :goto_0

    .line 24
    .line 25
    .line 26
    :cond_0
    invoke-virtual {p1}, Lcom/xj/winemu/bean/GamePad;->getName()Ljava/lang/String;

    .line 27
    move-result-object p1

    .line 28
    .line 29
    if-nez p1, :cond_1

    .line 30
    .line 31
    const-string p1, ""

    .line 32
    .line 33
    .line 34
    :cond_1
    :goto_0
    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 35
    .line 36
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 37
    return-object p0
.end method

.method public static final synthetic D1(Lcom/xj/winemu/WineActivity;)Lcom/winemu/openapi/HDREffect;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->m:Lcom/winemu/openapi/HDREffect;

    .line 3
    return-object p0
.end method

.method public static final synthetic E1(Lcom/xj/winemu/WineActivity;)Lcom/xj/winemu/utils/HudDataProvider;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->j:Lcom/xj/winemu/utils/HudDataProvider;

    .line 3
    return-object p0
.end method

.method public static final synthetic F1(Lcom/xj/winemu/WineActivity;)Lcom/winemu/ui/HUDUpdater;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->i:Lcom/winemu/ui/HUDUpdater;

    .line 3
    return-object p0
.end method

.method public static final F2(Lcom/xj/winemu/WineActivity;)Z
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 3
    .line 4
    if-nez p0, :cond_0

    .line 5
    .line 6
    const-string p0, "winuiBridge"

    .line 7
    .line 8
    .line 9
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 10
    const/4 p0, 0x0

    .line 11
    .line 12
    .line 13
    :cond_0
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->L()Lcom/winemu/openapi/Config;

    .line 14
    move-result-object p0

    .line 15
    .line 16
    .line 17
    invoke-virtual {p0}, Lcom/winemu/openapi/Config;->F()Lcom/winemu/openapi/Config$SteamGameInfo;

    .line 18
    move-result-object p0

    .line 19
    .line 20
    if-eqz p0, :cond_1

    .line 21
    .line 22
    .line 23
    invoke-virtual {p0}, Lcom/winemu/openapi/Config$SteamGameInfo;->c()Z

    .line 24
    move-result p0

    .line 25
    .line 26
    if-eqz p0, :cond_1

    .line 27
    const/4 p0, 0x1

    .line 28
    return p0

    .line 29
    :cond_1
    const/4 p0, 0x0

    .line 30
    return p0
.end method

.method public static final synthetic G1(Lcom/xj/winemu/WineActivity;)Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->w:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;

    .line 3
    return-object p0
.end method

.method public static final synthetic H1(Lcom/xj/winemu/WineActivity;)Lcom/xj/winemu/bean/PcEmuGameLocalConfig;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->s:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 3
    return-object p0
.end method

.method public static final synthetic I1(Lcom/xj/winemu/WineActivity;)Lcom/xj/winemu/api/bean/WineActivityData;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 3
    return-object p0
.end method

.method public static final I2(Lcom/xj/winemu/WineActivity;)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    new-instance v0, Lcom/xj/winemu/k;

    .line 3
    .line 4
    .line 5
    invoke-direct {v0, p0}, Lcom/xj/winemu/k;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 9
    .line 10
    .line 11
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->x2()V

    .line 12
    .line 13
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 14
    return-object p0
.end method

.method public static final synthetic J1(Lcom/xj/winemu/WineActivity;)Ljava/lang/Integer;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->r:Ljava/lang/Integer;

    .line 3
    return-object p0
.end method

.method public static final J2(Lcom/xj/winemu/WineActivity;)V
    .locals 3

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->D:Lkotlinx/coroutines/Job;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    if-eqz v0, :cond_0

    .line 6
    const/4 v2, 0x1

    .line 7
    .line 8
    .line 9
    invoke-static {v0, v1, v2, v1}, Lkotlinx/coroutines/Job$DefaultImpls;->b(Lkotlinx/coroutines/Job;Ljava/util/concurrent/CancellationException;ILjava/lang/Object;)V

    .line 10
    .line 11
    :cond_0
    iput-object v1, p0, Lcom/xj/winemu/WineActivity;->D:Lkotlinx/coroutines/Job;

    .line 12
    .line 13
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->C:Lcom/lxj/xpopup/impl/LoadingPopupView;

    .line 14
    .line 15
    if-eqz v0, :cond_1

    .line 16
    .line 17
    .line 18
    invoke-virtual {v0}, Lcom/lxj/xpopup/core/BasePopupView;->z()V

    .line 19
    .line 20
    :cond_1
    iput-object v1, p0, Lcom/xj/winemu/WineActivity;->C:Lcom/lxj/xpopup/impl/LoadingPopupView;

    .line 21
    return-void
.end method

.method public static final synthetic K1(Lcom/xj/winemu/WineActivity;)Lkotlinx/coroutines/Job;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->H:Lkotlinx/coroutines/Job;

    .line 3
    return-object p0
.end method

.method public static final K2(Lcom/xj/winemu/WineActivity;)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    new-instance v0, Lcom/xj/winemu/j;

    .line 3
    .line 4
    .line 5
    invoke-direct {v0, p0}, Lcom/xj/winemu/j;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 9
    .line 10
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 11
    return-object p0
.end method

.method public static final synthetic L1(Lcom/xj/winemu/WineActivity;)Lkotlinx/coroutines/Job;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->G:Lkotlinx/coroutines/Job;

    .line 3
    return-object p0
.end method

.method public static final L2(Lcom/xj/winemu/WineActivity;)V
    .locals 4

    .line 1
    .line 2
    sget-object v0, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 3
    .line 4
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->K:Ljava/lang/String;

    .line 5
    .line 6
    new-instance v2, Ljava/lang/StringBuilder;

    .line 7
    .line 8
    .line 9
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 10
    .line 11
    const-string v3, "WindowRealizedCallback - "

    .line 12
    .line 13
    .line 14
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 15
    .line 16
    .line 17
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 18
    .line 19
    .line 20
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 21
    move-result-object v1

    .line 22
    .line 23
    .line 24
    invoke-virtual {v0, v1}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 25
    .line 26
    iget-boolean v0, p0, Lcom/xj/winemu/WineActivity;->I:Z

    .line 27
    .line 28
    if-eqz v0, :cond_4

    .line 29
    .line 30
    .line 31
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->E2()Z

    .line 32
    move-result v0

    .line 33
    .line 34
    if-nez v0, :cond_4

    .line 35
    .line 36
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->K:Ljava/lang/String;

    .line 37
    .line 38
    const-string v1, "app_launch"

    .line 39
    .line 40
    .line 41
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 42
    move-result v0

    .line 43
    .line 44
    if-eqz v0, :cond_0

    .line 45
    .line 46
    .line 47
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->p2()V

    .line 48
    goto :goto_1

    .line 49
    .line 50
    :cond_0
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->K:Ljava/lang/String;

    .line 51
    .line 52
    const-string v1, "sync_apps_complete"

    .line 53
    .line 54
    .line 55
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 56
    move-result v0

    .line 57
    const/4 v1, 0x0

    .line 58
    .line 59
    const-string v2, "winuiBridge"

    .line 60
    .line 61
    if-eqz v0, :cond_2

    .line 62
    .line 63
    sget-object v0, Lcom/winemu/openapi/WinAPI;->f:Lcom/winemu/openapi/WinAPI$Companion;

    .line 64
    .line 65
    .line 66
    invoke-virtual {v0}, Lcom/winemu/openapi/WinAPI$Companion;->a()Lcom/winemu/openapi/WinAPI;

    .line 67
    move-result-object v0

    .line 68
    .line 69
    iget-object v3, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 70
    .line 71
    if-nez v3, :cond_1

    .line 72
    .line 73
    .line 74
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 75
    move-object v3, v1

    .line 76
    .line 77
    .line 78
    :cond_1
    invoke-virtual {v3}, Lcom/winemu/openapi/WinUIBridge;->L()Lcom/winemu/openapi/Config;

    .line 79
    move-result-object v3

    .line 80
    .line 81
    .line 82
    invoke-virtual {v3}, Lcom/winemu/openapi/Config;->I()Ljava/lang/String;

    .line 83
    move-result-object v3

    .line 84
    .line 85
    .line 86
    invoke-virtual {v0, v3}, Lcom/winemu/openapi/WinAPI;->B(Ljava/lang/String;)Z

    .line 87
    move-result v0

    .line 88
    .line 89
    if-nez v0, :cond_2

    .line 90
    .line 91
    .line 92
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->p2()V

    .line 93
    goto :goto_1

    .line 94
    .line 95
    :cond_2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 96
    .line 97
    if-nez v0, :cond_3

    .line 98
    .line 99
    .line 100
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 101
    goto :goto_0

    .line 102
    :cond_3
    move-object v1, v0

    .line 103
    .line 104
    .line 105
    :goto_0
    invoke-virtual {v1}, Lcom/winemu/openapi/WinUIBridge;->W()Z

    .line 106
    move-result v0

    .line 107
    .line 108
    if-eqz v0, :cond_5

    .line 109
    .line 110
    .line 111
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->p2()V

    .line 112
    goto :goto_1

    .line 113
    .line 114
    .line 115
    :cond_4
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->p2()V

    .line 116
    .line 117
    :cond_5
    :goto_1
    sget-object p0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 118
    .line 119
    .line 120
    invoke-virtual {p0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->l()V

    .line 121
    return-void
.end method

.method public static final synthetic M1(Lcom/xj/winemu/WineActivity;)Lcom/xj/winemu/ui/WineUIContainerManager;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 3
    return-object p0
.end method

.method public static final M2(Lcom/xj/winemu/WineActivity;Lcom/winemu/core/steam_agent/StatusData;)Lkotlin/Unit;
    .locals 6

    .line 1
    .line 2
    const-string v0, "data"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    sget-object v0, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 8
    .line 9
    .line 10
    invoke-virtual {p1}, Lcom/winemu/core/steam_agent/StatusData;->getEvent()Ljava/lang/String;

    .line 11
    move-result-object v1

    .line 12
    .line 13
    new-instance v2, Ljava/lang/StringBuilder;

    .line 14
    .line 15
    .line 16
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 17
    .line 18
    const-string v3, "SteamStatus event= "

    .line 19
    .line 20
    .line 21
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 22
    .line 23
    .line 24
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 25
    .line 26
    .line 27
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 28
    move-result-object v1

    .line 29
    .line 30
    .line 31
    invoke-virtual {v0, v1}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 32
    .line 33
    .line 34
    invoke-virtual {p1}, Lcom/winemu/core/steam_agent/StatusData;->getDetails()Ljava/lang/String;

    .line 35
    move-result-object v1

    .line 36
    .line 37
    sget-object v2, Lcom/winemu/core/steam_agent/SteamAgentStatus;->a:Lcom/winemu/core/steam_agent/SteamAgentStatus$Companion;

    .line 38
    .line 39
    .line 40
    invoke-virtual {p1}, Lcom/winemu/core/steam_agent/StatusData;->getEvent()Ljava/lang/String;

    .line 41
    move-result-object v3

    .line 42
    .line 43
    const-string v4, ""

    .line 44
    .line 45
    if-nez v3, :cond_0

    .line 46
    move-object v3, v4

    .line 47
    .line 48
    .line 49
    :cond_0
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->u2()Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 50
    move-result-object v5

    .line 51
    .line 52
    .line 53
    invoke-virtual {v2, v3, v5}, Lcom/winemu/core/steam_agent/SteamAgentStatus$Companion;->b(Ljava/lang/String;Lcom/winemu/core/steam_agent/StatusLanguage;)Ljava/lang/String;

    .line 54
    move-result-object v3

    .line 55
    .line 56
    .line 57
    invoke-virtual {p1}, Lcom/winemu/core/steam_agent/StatusData;->getEvent()Ljava/lang/String;

    .line 58
    move-result-object v5

    .line 59
    .line 60
    if-nez v5, :cond_1

    .line 61
    goto :goto_0

    .line 62
    :cond_1
    move-object v4, v5

    .line 63
    .line 64
    .line 65
    :goto_0
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->u2()Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 66
    move-result-object v5

    .line 67
    .line 68
    .line 69
    invoke-virtual {v2, v4, v5}, Lcom/winemu/core/steam_agent/SteamAgentStatus$Companion;->a(Ljava/lang/String;Lcom/winemu/core/steam_agent/StatusLanguage;)Ljava/lang/String;

    .line 70
    move-result-object v2

    .line 71
    .line 72
    new-instance v4, Ljava/lang/StringBuilder;

    .line 73
    .line 74
    .line 75
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    .line 76
    .line 77
    const-string v5, "details= "

    .line 78
    .line 79
    .line 80
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 81
    .line 82
    .line 83
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 84
    .line 85
    const-string v1, " desc="

    .line 86
    .line 87
    .line 88
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 89
    .line 90
    .line 91
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 92
    .line 93
    const-string v1, " , errorDesc="

    .line 94
    .line 95
    .line 96
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 97
    .line 98
    .line 99
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 100
    .line 101
    .line 102
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 103
    move-result-object v1

    .line 104
    .line 105
    .line 106
    invoke-virtual {v0, v1}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 107
    .line 108
    new-instance v0, Lcom/xj/winemu/l;

    .line 109
    .line 110
    .line 111
    invoke-direct {v0, p0, p1}, Lcom/xj/winemu/l;-><init>(Lcom/xj/winemu/WineActivity;Lcom/winemu/core/steam_agent/StatusData;)V

    .line 112
    .line 113
    .line 114
    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 115
    .line 116
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 117
    return-object p0
.end method

.method public static final synthetic N1(Lcom/xj/winemu/WineActivity;)Lcom/winemu/core/gamepad/VirtualGamepadController;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->A:Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 3
    return-object p0
.end method

.method public static final N2(Lcom/xj/winemu/WineActivity;Lcom/winemu/core/steam_agent/StatusData;)V
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-virtual {p1}, Lcom/winemu/core/steam_agent/StatusData;->getEvent()Ljava/lang/String;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->K:Ljava/lang/String;

    .line 7
    .line 8
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 9
    .line 10
    if-nez v0, :cond_0

    .line 11
    .line 12
    const-string v0, "uiContainerManager"

    .line 13
    .line 14
    .line 15
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 16
    const/4 v0, 0x0

    .line 17
    .line 18
    .line 19
    :cond_0
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->u2()Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 20
    move-result-object p0

    .line 21
    .line 22
    .line 23
    invoke-virtual {v0, p1, p0}, Lcom/xj/winemu/ui/WineUIContainerManager;->m(Lcom/winemu/core/steam_agent/StatusData;Lcom/winemu/core/steam_agent/StatusLanguage;)V

    .line 24
    return-void
.end method

.method public static final synthetic O1(Lcom/xj/winemu/WineActivity;)Lcom/xj/winemu/utils/WineInGameSettings;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->B:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 3
    return-object p0
.end method

.method public static final O2(Lcom/xj/winemu/WineActivity;Z)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0, p1}, Lcom/xj/winemu/WineActivity;->S2(Z)V

    .line 4
    .line 5
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 6
    return-object p0
.end method

.method public static final synthetic P1(Lcom/xj/winemu/WineActivity;)Lcom/winemu/openapi/WinUIBridge;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 3
    return-object p0
.end method

.method public static final synthetic Q1(Lcom/xj/winemu/WineActivity;)Lcom/xj/winemu/databinding/ActivityWineBinding;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->w2()Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final synthetic R1(Lcom/xj/winemu/WineActivity;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->E2()Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static final synthetic S1(Lcom/xj/winemu/WineActivity;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->G2()Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static final synthetic T1(Lcom/xj/winemu/WineActivity;)Z
    .locals 0

    .line 1
    .line 2
    iget-boolean p0, p0, Lcom/xj/winemu/WineActivity;->I:Z

    .line 3
    return p0
.end method

.method public static final synthetic U1(Lcom/xj/winemu/WineActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->Q2()V

    .line 4
    return-void
.end method

.method private final U2()V
    .locals 5

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->m:Lcom/winemu/openapi/HDREffect;

    .line 3
    .line 4
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->B:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 5
    .line 6
    const-string v2, "wineInGameSettingsSaver"

    .line 7
    const/4 v3, 0x0

    .line 8
    .line 9
    if-nez v1, :cond_0

    .line 10
    .line 11
    .line 12
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 13
    move-object v1, v3

    .line 14
    .line 15
    .line 16
    :cond_0
    invoke-virtual {v1}, Lcom/xj/winemu/utils/WineInGameSettings;->h()Z

    .line 17
    move-result v1

    .line 18
    .line 19
    .line 20
    invoke-virtual {v0, v1}, Lcom/winemu/openapi/Effect;->setEnabled(Z)V

    .line 21
    .line 22
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->n:Lcom/winemu/openapi/CASEffect;

    .line 23
    .line 24
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->B:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 25
    .line 26
    if-nez v1, :cond_1

    .line 27
    .line 28
    .line 29
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 30
    move-object v1, v3

    .line 31
    .line 32
    .line 33
    :cond_1
    invoke-virtual {v1}, Lcom/xj/winemu/utils/WineInGameSettings;->p()Z

    .line 34
    move-result v1

    .line 35
    .line 36
    .line 37
    invoke-virtual {v0, v1}, Lcom/winemu/openapi/Effect;->setEnabled(Z)V

    .line 38
    .line 39
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->o:Lcom/winemu/openapi/CRTEffect;

    .line 40
    .line 41
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->B:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 42
    .line 43
    if-nez v1, :cond_2

    .line 44
    .line 45
    .line 46
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 47
    move-object v1, v3

    .line 48
    .line 49
    .line 50
    :cond_2
    invoke-virtual {v1}, Lcom/xj/winemu/utils/WineInGameSettings;->c()Z

    .line 51
    move-result v1

    .line 52
    .line 53
    .line 54
    invoke-virtual {v0, v1}, Lcom/winemu/openapi/Effect;->setEnabled(Z)V

    .line 55
    .line 56
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->n:Lcom/winemu/openapi/CASEffect;

    .line 57
    .line 58
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->B:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 59
    .line 60
    if-nez v1, :cond_3

    .line 61
    .line 62
    .line 63
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 64
    move-object v1, v3

    .line 65
    .line 66
    .line 67
    :cond_3
    invoke-virtual {v1}, Lcom/xj/winemu/utils/WineInGameSettings;->o()Lcom/xj/winemu/bean/SuperResolution;

    .line 68
    move-result-object v1

    .line 69
    .line 70
    .line 71
    invoke-virtual {v1}, Lcom/xj/winemu/bean/SuperResolution;->getSharpness()F

    .line 72
    move-result v1

    .line 73
    .line 74
    .line 75
    invoke-virtual {v0, v1}, Lcom/winemu/openapi/CASEffect;->setSharpness(F)V

    .line 76
    .line 77
    .line 78
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->e3()V

    .line 79
    .line 80
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->B:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 81
    .line 82
    if-nez v0, :cond_4

    .line 83
    .line 84
    .line 85
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 86
    move-object v0, v3

    .line 87
    .line 88
    .line 89
    :cond_4
    invoke-virtual {v0}, Lcom/xj/winemu/utils/WineInGameSettings;->j()Lcom/xj/winemu/bean/NativeRenderingMode;

    .line 90
    move-result-object v0

    .line 91
    .line 92
    .line 93
    invoke-virtual {p0, v0}, Lcom/xj/winemu/WineActivity;->d3(Lcom/xj/winemu/bean/NativeRenderingMode;)V

    .line 94
    .line 95
    new-instance v0, Lcom/mikepenz/materialdrawer/model/SectionDrawerItem;

    .line 96
    .line 97
    .line 98
    invoke-direct {v0}, Lcom/mikepenz/materialdrawer/model/SectionDrawerItem;-><init>()V

    .line 99
    const/4 v1, 0x0

    .line 100
    .line 101
    .line 102
    invoke-virtual {v0, v1}, Lcom/mikepenz/materialdrawer/model/SectionDrawerItem;->L(Z)V

    .line 103
    .line 104
    new-instance v1, Lcom/mikepenz/materialdrawer/holder/StringHolder;

    .line 105
    .line 106
    .line 107
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    .line 108
    move-result-object v2

    .line 109
    .line 110
    sget v4, Lcom/xj/language/R$string;->llauncher_pc_graphics:I

    .line 111
    .line 112
    .line 113
    invoke-virtual {v2, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 114
    move-result-object v2

    .line 115
    .line 116
    .line 117
    invoke-direct {v1, v2}, Lcom/mikepenz/materialdrawer/holder/StringHolder;-><init>(Ljava/lang/CharSequence;)V

    .line 118
    .line 119
    .line 120
    invoke-virtual {v0, v1}, Lcom/mikepenz/materialdrawer/model/SectionDrawerItem;->M(Lcom/mikepenz/materialdrawer/holder/StringHolder;)V

    .line 121
    .line 122
    new-instance v0, Lcom/xj/winemu/WineActivity$setupUI$iHudDataProvider$1;

    .line 123
    .line 124
    .line 125
    invoke-direct {v0, p0}, Lcom/xj/winemu/WineActivity$setupUI$iHudDataProvider$1;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 126
    .line 127
    new-instance v1, Lcom/winemu/ui/HUDUpdater;

    .line 128
    .line 129
    iget-object v2, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 130
    .line 131
    if-nez v2, :cond_5

    .line 132
    .line 133
    const-string v2, "binding"

    .line 134
    .line 135
    .line 136
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 137
    goto :goto_0

    .line 138
    :cond_5
    move-object v3, v2

    .line 139
    .line 140
    :goto_0
    iget-object v2, v3, Lcom/xj/winemu/databinding/ActivityWineBinding;->hudLayer:Lcom/winemu/ui/HUDLayer;

    .line 141
    .line 142
    const-string v3, "hudLayer"

    .line 143
    .line 144
    .line 145
    invoke-static {v2, v3}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 146
    .line 147
    .line 148
    invoke-static {p0}, Landroidx/lifecycle/LifecycleOwnerKt;->a(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 149
    move-result-object v3

    .line 150
    .line 151
    .line 152
    invoke-direct {v1, v2, v0, v3}, Lcom/winemu/ui/HUDUpdater;-><init>(Lcom/winemu/ui/HUDLayer;Lcom/winemu/ui/IHudDataProvider;Lkotlinx/coroutines/CoroutineScope;)V

    .line 153
    .line 154
    iput-object v1, p0, Lcom/xj/winemu/WineActivity;->i:Lcom/winemu/ui/HUDUpdater;

    .line 155
    .line 156
    iget-object v2, p0, Lcom/xj/winemu/WineActivity;->s:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 157
    .line 158
    .line 159
    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 160
    move-result-object v2

    .line 161
    .line 162
    .line 163
    invoke-virtual {v1, v2}, Lcom/winemu/ui/HUDUpdater;->i(Lcom/winemu/ui/HUDConfig;)V

    .line 164
    .line 165
    new-instance v1, Lcom/xj/winemu/utils/HudDataProvider;

    .line 166
    .line 167
    .line 168
    invoke-direct {v1, p0, v0}, Lcom/xj/winemu/utils/HudDataProvider;-><init>(Landroid/content/Context;Lcom/winemu/ui/IHudDataProvider;)V

    .line 169
    .line 170
    iput-object v1, p0, Lcom/xj/winemu/WineActivity;->j:Lcom/xj/winemu/utils/HudDataProvider;

    .line 171
    .line 172
    .line 173
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->b3()V

    .line 174
    return-void
.end method

.method public static final synthetic V1(Lcom/xj/winemu/WineActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->R2()V

    .line 4
    return-void
.end method

.method public static final synthetic W1(Lcom/xj/winemu/WineActivity;Lcom/lxj/xpopup/impl/LoadingPopupView;)V
    .locals 0

    .line 1
    .line 2
    iput-object p1, p0, Lcom/xj/winemu/WineActivity;->C:Lcom/lxj/xpopup/impl/LoadingPopupView;

    .line 3
    return-void
.end method

.method public static final synthetic X1(Lcom/xj/winemu/WineActivity;Lkotlinx/coroutines/Job;)V
    .locals 0

    .line 1
    .line 2
    iput-object p1, p0, Lcom/xj/winemu/WineActivity;->D:Lkotlinx/coroutines/Job;

    .line 3
    return-void
.end method

.method private final X2(Lcom/xj/pcvirtualbtn/inputcontrols/ControlsProfile;)V
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->d()Z

    .line 6
    move-result v0

    .line 7
    .line 8
    if-nez v0, :cond_0

    .line 9
    .line 10
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->w:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;

    .line 11
    .line 12
    if-eqz p0, :cond_0

    .line 13
    const/4 v0, 0x0

    .line 14
    .line 15
    .line 16
    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    .line 17
    .line 18
    .line 19
    invoke-virtual {p0, p1}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;->setProfile(Lcom/xj/pcvirtualbtn/inputcontrols/ControlsProfile;)V

    .line 20
    .line 21
    .line 22
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    .line 23
    :cond_0
    return-void
.end method

.method public static final synthetic Y1(Lcom/xj/winemu/WineActivity;Z)V
    .locals 0

    .line 1
    .line 2
    iput-boolean p1, p0, Lcom/xj/winemu/WineActivity;->q:Z

    .line 3
    return-void
.end method

.method public static final synthetic Z1(Lcom/xj/winemu/WineActivity;Ljava/lang/Integer;)V
    .locals 0

    .line 1
    .line 2
    iput-object p1, p0, Lcom/xj/winemu/WineActivity;->r:Ljava/lang/Integer;

    .line 3
    return-void
.end method

.method public static final Z2(Lcom/xj/winemu/WineActivity;Ljava/lang/String;I)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0, p1}, Lcom/xj/winemu/WineActivity;->l2(Ljava/lang/String;)V

    .line 4
    .line 5
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 6
    return-object p0
.end method

.method public static final synthetic a2(Lcom/xj/winemu/WineActivity;Lkotlinx/coroutines/Job;)V
    .locals 0

    .line 1
    .line 2
    iput-object p1, p0, Lcom/xj/winemu/WineActivity;->H:Lkotlinx/coroutines/Job;

    .line 3
    return-void
.end method

.method public static final synthetic b2(Lcom/xj/winemu/WineActivity;Lkotlinx/coroutines/Job;)V
    .locals 0

    .line 1
    .line 2
    iput-object p1, p0, Lcom/xj/winemu/WineActivity;->G:Lkotlinx/coroutines/Job;

    .line 3
    return-void
.end method

.method public static final synthetic c2(Lcom/xj/winemu/WineActivity;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0, p1}, Lcom/xj/winemu/WineActivity;->S2(Z)V

    .line 4
    return-void
.end method

.method public static final synthetic d2(Lcom/xj/winemu/WineActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->T2()V

    .line 4
    return-void
.end method

.method public static final synthetic e2(Lcom/xj/winemu/WineActivity;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0, p1}, Lcom/xj/winemu/WineActivity;->a3(Z)V

    .line 4
    return-void
.end method

.method public static final synthetic f2(Lcom/xj/winemu/WineActivity;ZF)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0, p1, p2}, Lcom/xj/winemu/WineActivity;->c3(ZF)V

    .line 4
    return-void
.end method

.method public static synthetic g1(Lcom/xj/winemu/WineActivity;Ljava/lang/String;I)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/winemu/WineActivity;->Z2(Lcom/xj/winemu/WineActivity;Ljava/lang/String;I)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final synthetic g2(Lcom/xj/winemu/WineActivity;Lcom/xj/winemu/bean/NativeRenderingMode;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0, p1}, Lcom/xj/winemu/WineActivity;->d3(Lcom/xj/winemu/bean/NativeRenderingMode;)V

    .line 4
    return-void
.end method

.method public static synthetic h1(Lcom/xj/winemu/WineActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/winemu/WineActivity;->J2(Lcom/xj/winemu/WineActivity;)V

    .line 4
    return-void
.end method

.method public static final synthetic h2(Lcom/xj/winemu/WineActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->e3()V

    .line 4
    return-void
.end method

.method public static synthetic i1(Lcom/xj/winemu/WineActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/winemu/WineActivity;->q2(Lcom/xj/winemu/WineActivity;)V

    .line 4
    return-void
.end method

.method public static synthetic j1(Lcom/xj/winemu/WineActivity;Z)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/WineActivity;->O2(Lcom/xj/winemu/WineActivity;Z)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final j2(Lcom/xj/winemu/WineActivity;Landroid/view/View;Landroid/view/MotionEvent;)V
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 3
    .line 4
    if-nez p0, :cond_0

    .line 5
    .line 6
    const-string p0, "binding"

    .line 7
    .line 8
    .line 9
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 10
    const/4 p0, 0x0

    .line 11
    .line 12
    :cond_0
    iget-object p0, p0, Lcom/xj/winemu/databinding/ActivityWineBinding;->layoutXContainer:Landroid/widget/FrameLayout;

    .line 13
    .line 14
    .line 15
    invoke-virtual {p0, p2}, Landroid/view/View;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    .line 16
    return-void
.end method

.method public static synthetic k1(Lcom/xj/winemu/WineActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/winemu/WineActivity;->I2(Lcom/xj/winemu/WineActivity;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final k2(Lcom/xj/winemu/WineActivity;)Lcom/winemu/core/gamepad/VirtualGamepadController;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->A:Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 3
    return-object p0
.end method

.method public static synthetic l1(Lcom/xj/winemu/WineActivity;Lcom/winemu/core/steam_agent/StatusData;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/WineActivity;->M2(Lcom/xj/winemu/WineActivity;Lcom/winemu/core/steam_agent/StatusData;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic m1(Lcom/xj/winemu/WineActivity;)Lcom/winemu/core/gamepad/VirtualGamepadController;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/winemu/WineActivity;->k2(Lcom/xj/winemu/WineActivity;)Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic n1(Lcom/xj/winemu/WineActivity;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/winemu/WineActivity;->F2(Lcom/xj/winemu/WineActivity;)Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static final n2()Ljava/lang/String;
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    .line 7
    invoke-virtual {v0}, Ljava/util/UUID;->toString()Ljava/lang/String;

    .line 8
    move-result-object v0

    .line 9
    return-object v0
.end method

.method public static synthetic o1(Lcom/xj/winemu/WineActivity;Lcom/winemu/core/steam_agent/StatusData;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/WineActivity;->N2(Lcom/xj/winemu/WineActivity;Lcom/winemu/core/steam_agent/StatusData;)V

    .line 4
    return-void
.end method

.method public static synthetic p1(Ljava/lang/String;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/winemu/WineActivity;->r2(Ljava/lang/String;)Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic q1(Lcom/xj/winemu/WineActivity;Ljava/lang/String;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/WineActivity;->s2(Lcom/xj/winemu/WineActivity;Ljava/lang/String;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final q2(Lcom/xj/winemu/WineActivity;)V
    .locals 6

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    const-string v2, "winuiBridge"

    .line 6
    .line 7
    if-nez v0, :cond_0

    .line 8
    .line 9
    .line 10
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 11
    move-object v0, v1

    .line 12
    :cond_0
    const/4 v3, 0x1

    .line 13
    const/4 v4, 0x0

    .line 14
    .line 15
    const/16 v5, 0x8f

    .line 16
    .line 17
    .line 18
    invoke-virtual {v0, v4, v5, v3}, Lcom/winemu/openapi/WinUIBridge;->d0(IIZ)V

    .line 19
    .line 20
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 21
    .line 22
    if-nez p0, :cond_1

    .line 23
    .line 24
    .line 25
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 26
    goto :goto_0

    .line 27
    :cond_1
    move-object v1, p0

    .line 28
    .line 29
    .line 30
    :goto_0
    invoke-virtual {v1, v4, v5, v4}, Lcom/winemu/openapi/WinUIBridge;->d0(IIZ)V

    .line 31
    return-void
.end method

.method public static synthetic r1(Lcom/xj/winemu/WineActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/winemu/WineActivity;->L2(Lcom/xj/winemu/WineActivity;)V

    .line 4
    return-void
.end method

.method public static final r2(Ljava/lang/String;)Z
    .locals 1

    .line 1
    .line 2
    const-string v0, "$this$isTrue"

    .line 3
    .line 4
    .line 5
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-interface {p0}, Ljava/lang/CharSequence;->length()I

    .line 9
    move-result p0

    .line 10
    const/4 v0, 0x1

    .line 11
    .line 12
    if-nez p0, :cond_0

    .line 13
    move p0, v0

    .line 14
    goto :goto_0

    .line 15
    :cond_0
    const/4 p0, 0x0

    .line 16
    :goto_0
    xor-int/2addr p0, v0

    .line 17
    return p0
.end method

.method public static synthetic s1(Lcom/xj/winemu/databinding/ItemGamePadListBinding;Lcom/xj/winemu/bean/GamePad;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/WineActivity;->C2(Lcom/xj/winemu/databinding/ItemGamePadListBinding;Lcom/xj/winemu/bean/GamePad;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final s2(Lcom/xj/winemu/WineActivity;Ljava/lang/String;)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    const-string v0, "it"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 8
    .line 9
    if-nez p0, :cond_0

    .line 10
    .line 11
    const-string p0, "uiContainerManager"

    .line 12
    .line 13
    .line 14
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 15
    const/4 p0, 0x0

    .line 16
    .line 17
    .line 18
    :cond_0
    invoke-static {p1}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->v(Ljava/lang/String;)F

    .line 19
    move-result p1

    .line 20
    .line 21
    .line 22
    invoke-virtual {p0, p1}, Lcom/xj/winemu/ui/WineUIContainerManager;->k(F)V

    .line 23
    .line 24
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 25
    return-object p0
.end method

.method public static synthetic t1()Ljava/lang/String;
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/winemu/WineActivity;->n2()Ljava/lang/String;

    .line 4
    move-result-object v0

    .line 5
    return-object v0
.end method

.method public static synthetic u1(Lcom/xj/winemu/WineActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/winemu/WineActivity;->K2(Lcom/xj/winemu/WineActivity;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic v1(Lcom/xj/winemu/WineActivity;Landroid/view/View;Landroid/view/MotionEvent;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/winemu/WineActivity;->j2(Lcom/xj/winemu/WineActivity;Landroid/view/View;Landroid/view/MotionEvent;)V

    .line 4
    return-void
.end method

.method public static final synthetic w1(Lcom/xj/winemu/WineActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->o2()V

    .line 4
    return-void
.end method

.method public static final synthetic x1(Lcom/xj/winemu/WineActivity;)Lcom/xj/winemu/databinding/ActivityWineBinding;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 3
    return-object p0
.end method

.method public static final synthetic y1(Lcom/xj/winemu/WineActivity;)Lcom/winemu/openapi/CASEffect;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->n:Lcom/winemu/openapi/CASEffect;

    .line 3
    return-object p0
.end method

.method public static final synthetic z1(Lcom/xj/winemu/WineActivity;)Lcom/winemu/openapi/CRTEffect;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->o:Lcom/winemu/openapi/CRTEffect;

    .line 3
    return-object p0
.end method

.method private final z2()V
    .locals 1

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->w:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;

    .line 3
    .line 4
    if-eqz p0, :cond_0

    .line 5
    const/4 v0, 0x1

    .line 6
    .line 7
    .line 8
    invoke-virtual {p0, v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;->setShowTouchscreenControls(Z)V

    .line 9
    .line 10
    const/16 v0, 0x8

    .line 11
    .line 12
    .line 13
    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    .line 14
    const/4 v0, 0x0

    .line 15
    .line 16
    .line 17
    invoke-virtual {p0, v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;->setProfile(Lcom/xj/pcvirtualbtn/inputcontrols/ControlsProfile;)V

    .line 18
    .line 19
    .line 20
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    .line 21
    :cond_0
    return-void
.end method


# virtual methods
.method public final A2()V
    .locals 8

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->B:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    if-nez v0, :cond_0

    .line 6
    .line 7
    const-string v0, "wineInGameSettingsSaver"

    .line 8
    .line 9
    .line 10
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 11
    move-object v0, v1

    .line 12
    .line 13
    .line 14
    :cond_0
    invoke-virtual {v0}, Lcom/xj/winemu/utils/WineInGameSettings;->d()Lcom/xj/winemu/bean/FpsLimit;

    .line 15
    move-result-object v0

    .line 16
    .line 17
    .line 18
    invoke-static {p0}, Landroidx/lifecycle/LifecycleOwnerKt;->a(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 19
    move-result-object v2

    .line 20
    .line 21
    new-instance v5, Lcom/xj/winemu/WineActivity$initFpsLimit$1;

    .line 22
    .line 23
    .line 24
    invoke-direct {v5, v0, p0, v1}, Lcom/xj/winemu/WineActivity$initFpsLimit$1;-><init>(Lcom/xj/winemu/bean/FpsLimit;Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 25
    const/4 v6, 0x3

    .line 26
    const/4 v7, 0x0

    .line 27
    const/4 v3, 0x0

    .line 28
    const/4 v4, 0x0

    .line 29
    .line 30
    .line 31
    invoke-static/range {v2 .. v7}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 32
    return-void
.end method

.method public B0(Lcom/winemu/core/gamepad/GamepadConnectionEvent;)V
    .locals 4

    .line 1
    .line 2
    const-string v0, "event"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-static {p0, p1}, Lcom/winemu/core/gamepad/GamepadEventListener$DefaultImpls;->a(Lcom/winemu/core/gamepad/GamepadEventListener;Lcom/winemu/core/gamepad/GamepadConnectionEvent;)V

    .line 9
    .line 10
    sget-object v0, Lcom/xj/winemu/bean/GamePad;->Companion:Lcom/xj/winemu/bean/GamePad$Companion;

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1}, Lcom/winemu/core/gamepad/GamepadConnectionEvent;->a()Lcom/winemu/core/gamepad/GamepadDevice;

    .line 14
    move-result-object p1

    .line 15
    const/4 v1, 0x0

    .line 16
    const/4 v2, 0x2

    .line 17
    const/4 v3, 0x0

    .line 18
    .line 19
    .line 20
    invoke-static {v0, p1, v1, v2, v3}, Lcom/xj/winemu/bean/GamePad$Companion;->from$default(Lcom/xj/winemu/bean/GamePad$Companion;Lcom/winemu/core/gamepad/GamepadDevice;ZILjava/lang/Object;)Lcom/xj/winemu/bean/GamePad;

    .line 21
    move-result-object p1

    .line 22
    .line 23
    .line 24
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->y2()Z

    .line 25
    move-result v0

    .line 26
    .line 27
    sget-object v2, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 28
    .line 29
    .line 30
    invoke-virtual {v2, p1, v0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->f(Lcom/xj/winemu/bean/GamePad;Z)V

    .line 31
    .line 32
    if-eqz v0, :cond_0

    .line 33
    .line 34
    iget-boolean v0, p0, Lcom/xj/winemu/WineActivity;->q:Z

    .line 35
    .line 36
    if-nez v0, :cond_0

    .line 37
    .line 38
    .line 39
    invoke-virtual {p0, v1}, Lcom/xj/winemu/WineActivity;->S(Z)V

    .line 40
    goto :goto_0

    .line 41
    .line 42
    :cond_0
    iput-boolean v1, p0, Lcom/xj/winemu/WineActivity;->q:Z

    .line 43
    .line 44
    :goto_0
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 45
    .line 46
    if-nez v0, :cond_1

    .line 47
    .line 48
    const-string v0, "winuiBridge"

    .line 49
    .line 50
    .line 51
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 52
    move-object v0, v3

    .line 53
    .line 54
    .line 55
    :cond_1
    invoke-virtual {v0}, Lcom/winemu/openapi/WinUIBridge;->W()Z

    .line 56
    move-result v0

    .line 57
    .line 58
    if-eqz v0, :cond_2

    .line 59
    goto :goto_1

    .line 60
    .line 61
    :cond_2
    sget-object v0, Lcom/xj/winemu/ui/dialog/GamePadManagerDialog;->t:Lcom/xj/winemu/ui/dialog/GamePadManagerDialog$Companion;

    .line 62
    .line 63
    .line 64
    invoke-virtual {v0}, Lcom/xj/winemu/ui/dialog/GamePadManagerDialog$Companion;->a()Z

    .line 65
    move-result v0

    .line 66
    .line 67
    if-eqz v0, :cond_3

    .line 68
    :goto_1
    return-void

    .line 69
    .line 70
    :cond_3
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 71
    .line 72
    if-nez p0, :cond_4

    .line 73
    .line 74
    const-string p0, "uiContainerManager"

    .line 75
    .line 76
    .line 77
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 78
    goto :goto_2

    .line 79
    :cond_4
    move-object v3, p0

    .line 80
    :goto_2
    const/4 p0, 0x1

    .line 81
    .line 82
    .line 83
    invoke-virtual {v3, p1, p0}, Lcom/xj/winemu/ui/WineUIContainerManager;->g(Lcom/xj/winemu/bean/GamePad;Z)V

    .line 84
    return-void
.end method

.method public final B2()V
    .locals 2

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    if-nez v0, :cond_0

    .line 6
    .line 7
    const-string v0, "winuiBridge"

    .line 8
    .line 9
    .line 10
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 11
    move-object v0, v1

    .line 12
    .line 13
    .line 14
    :cond_0
    invoke-virtual {v0}, Lcom/winemu/openapi/WinUIBridge;->W()Z

    .line 15
    move-result v0

    .line 16
    .line 17
    if-eqz v0, :cond_1

    .line 18
    return-void

    .line 19
    .line 20
    :cond_1
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 21
    .line 22
    if-nez p0, :cond_2

    .line 23
    .line 24
    const-string p0, "binding"

    .line 25
    .line 26
    .line 27
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 28
    goto :goto_0

    .line 29
    :cond_2
    move-object v1, p0

    .line 30
    .line 31
    :goto_0
    iget-object p0, v1, Lcom/xj/winemu/databinding/ActivityWineBinding;->gamePadConnectTipsView:Lcom/xj/winemu/view/GamePadConnectTipsView;

    .line 32
    .line 33
    new-instance v0, Lcom/xj/winemu/i;

    .line 34
    .line 35
    .line 36
    invoke-direct {v0}, Lcom/xj/winemu/i;-><init>()V

    .line 37
    .line 38
    .line 39
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/GamePadConnectTipsView;->setOnBindItem(Lkotlin/jvm/functions/Function2;)V

    .line 40
    return-void
.end method

.method public final D2()V
    .locals 5

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    const-string v2, "winuiBridge"

    .line 6
    .line 7
    if-nez v0, :cond_0

    .line 8
    .line 9
    .line 10
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 11
    move-object v0, v1

    .line 12
    .line 13
    .line 14
    :cond_0
    invoke-virtual {v0}, Lcom/winemu/openapi/WinUIBridge;->L()Lcom/winemu/openapi/Config;

    .line 15
    move-result-object v0

    .line 16
    .line 17
    .line 18
    invoke-virtual {v0}, Lcom/winemu/openapi/Config;->F()Lcom/winemu/openapi/Config$SteamGameInfo;

    .line 19
    move-result-object v0

    .line 20
    .line 21
    if-eqz v0, :cond_4

    .line 22
    .line 23
    .line 24
    invoke-virtual {v0}, Lcom/winemu/openapi/Config$SteamGameInfo;->c()Z

    .line 25
    move-result v3

    .line 26
    .line 27
    if-eqz v3, :cond_1

    .line 28
    goto :goto_1

    .line 29
    .line 30
    .line 31
    :cond_1
    invoke-virtual {v0}, Lcom/winemu/openapi/Config$SteamGameInfo;->m()I

    .line 32
    move-result v0

    .line 33
    .line 34
    const-class v3, Lcom/xj/common/service/ISteamGameService;

    .line 35
    .line 36
    .line 37
    invoke-static {v3}, Lcom/therouter/TheRouter;->b(Ljava/lang/Class;)Ljava/lang/Object;

    .line 38
    move-result-object v3

    .line 39
    .line 40
    .line 41
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 42
    .line 43
    check-cast v3, Lcom/xj/common/service/ISteamGameService;

    .line 44
    .line 45
    .line 46
    invoke-interface {v3, v0}, Lcom/xj/common/service/ISteamGameService;->b(I)Z

    .line 47
    move-result v4

    .line 48
    .line 49
    if-nez v4, :cond_2

    .line 50
    goto :goto_1

    .line 51
    .line 52
    .line 53
    :cond_2
    invoke-interface {v3, v0}, Lcom/xj/common/service/ISteamGameService;->Q(I)Ljava/lang/String;

    .line 54
    move-result-object v0

    .line 55
    const/4 v3, 0x0

    .line 56
    :goto_0
    const/4 v4, 0x4

    .line 57
    .line 58
    if-ge v3, v4, :cond_4

    .line 59
    .line 60
    iget-object v4, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 61
    .line 62
    if-nez v4, :cond_3

    .line 63
    .line 64
    .line 65
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 66
    move-object v4, v1

    .line 67
    .line 68
    .line 69
    :cond_3
    invoke-virtual {v4, v3, v0}, Lcom/winemu/openapi/WinUIBridge;->m0(ILjava/lang/String;)V

    .line 70
    .line 71
    add-int/lit8 v3, v3, 0x1

    .line 72
    goto :goto_0

    .line 73
    :cond_4
    :goto_1
    return-void
.end method

.method public final E2()Z
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->E:Lkotlin/Lazy;

    .line 3
    .line 4
    .line 5
    invoke-interface {p0}, Lkotlin/Lazy;->getValue()Ljava/lang/Object;

    .line 6
    move-result-object p0

    .line 7
    .line 8
    check-cast p0, Ljava/lang/Boolean;

    .line 9
    .line 10
    .line 11
    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    .line 12
    move-result p0

    .line 13
    return p0
.end method

.method public final G2()Z
    .locals 2

    .line 1
    .line 2
    :try_start_0
    const-string v0, "connectivity"

    .line 3
    .line 4
    .line 5
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    .line 6
    move-result-object p0

    .line 7
    .line 8
    const-string v0, "null cannot be cast to non-null type android.net.ConnectivityManager"

    .line 9
    .line 10
    .line 11
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 12
    .line 13
    check-cast p0, Landroid/net/ConnectivityManager;

    .line 14
    .line 15
    .line 16
    invoke-virtual {p0}, Landroid/net/ConnectivityManager;->getActiveNetwork()Landroid/net/Network;

    .line 17
    move-result-object v0

    .line 18
    const/4 v1, 0x0

    .line 19
    .line 20
    if-nez v0, :cond_0

    .line 21
    return v1

    .line 22
    .line 23
    .line 24
    :cond_0
    invoke-virtual {p0, v0}, Landroid/net/ConnectivityManager;->getNetworkCapabilities(Landroid/net/Network;)Landroid/net/NetworkCapabilities;

    .line 25
    move-result-object p0

    .line 26
    .line 27
    if-nez p0, :cond_1

    .line 28
    return v1

    .line 29
    .line 30
    :cond_1
    const/16 v0, 0xc

    .line 31
    .line 32
    .line 33
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    .line 34
    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 35
    return p0

    .line 36
    :catch_0
    move-exception p0

    .line 37
    .line 38
    .line 39
    invoke-virtual {p0}, Ljava/lang/Throwable;->printStackTrace()V

    .line 40
    const/4 p0, 0x1

    .line 41
    return p0
.end method

.method public final H2()V
    .locals 4

    .line 1
    .line 2
    new-instance v0, Landroid/content/Intent;

    .line 3
    .line 4
    const-string v1, "com.wine.game.exit"

    .line 5
    .line 6
    .line 7
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 8
    .line 9
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 10
    const/4 v2, 0x0

    .line 11
    .line 12
    if-eqz v1, :cond_0

    .line 13
    .line 14
    .line 15
    invoke-virtual {v1}, Lcom/xj/winemu/api/bean/WineActivityData;->f()Ljava/lang/String;

    .line 16
    move-result-object v1

    .line 17
    goto :goto_0

    .line 18
    :cond_0
    move-object v1, v2

    .line 19
    .line 20
    :goto_0
    const-string v3, "gameName"

    .line 21
    .line 22
    .line 23
    invoke-virtual {v0, v3, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 24
    .line 25
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 26
    .line 27
    if-eqz v1, :cond_1

    .line 28
    .line 29
    .line 30
    invoke-virtual {v1}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 31
    move-result-object v2

    .line 32
    .line 33
    :cond_1
    const-string v1, "gameId"

    .line 34
    .line 35
    .line 36
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 37
    .line 38
    .line 39
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    .line 40
    move-result-object v1

    .line 41
    .line 42
    .line 43
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    .line 44
    .line 45
    const/16 v1, 0x20

    .line 46
    .line 47
    .line 48
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 49
    .line 50
    .line 51
    invoke-virtual {p0, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    .line 52
    return-void
.end method

.method public K()Lcom/winemu/core/gamepad/GamepadManager;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 3
    return-object p0
.end method

.method public final P2()V
    .locals 2

    .line 1
    .line 2
    new-instance v0, Landroid/content/IntentFilter;

    .line 3
    .line 4
    .line 5
    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    .line 6
    .line 7
    const-string v1, "android.hardware.usb.action.USB_DEVICE_ATTACHED"

    .line 8
    .line 9
    .line 10
    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 11
    .line 12
    const-string v1, "android.hardware.usb.action.USB_DEVICE_DETACHED"

    .line 13
    .line 14
    .line 15
    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 16
    .line 17
    const-string v1, "android.bluetooth.device.action.ACL_CONNECTED"

    .line 18
    .line 19
    .line 20
    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 21
    .line 22
    const-string v1, "android.bluetooth.device.action.ACL_DISCONNECTED"

    .line 23
    .line 24
    .line 25
    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 26
    .line 27
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->L:Lcom/xj/winemu/WineActivity$mDeviceConnectReceiver$1;

    .line 28
    .line 29
    .line 30
    invoke-virtual {p0, v1, v0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 31
    return-void
.end method

.method public final Q2()V
    .locals 1

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->A:Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 3
    .line 4
    if-eqz v0, :cond_0

    .line 5
    .line 6
    .line 7
    invoke-virtual {v0}, Lcom/winemu/core/gamepad/VirtualGamepadController;->k()V

    .line 8
    .line 9
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 10
    .line 11
    if-eqz v0, :cond_0

    .line 12
    .line 13
    .line 14
    invoke-virtual {v0}, Lcom/winemu/core/gamepad/GamepadManager;->s()V

    .line 15
    :cond_0
    const/4 v0, 0x0

    .line 16
    .line 17
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->A:Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 18
    return-void
.end method

.method public final R2()V
    .locals 3

    .line 1
    .line 2
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    .line 3
    .line 4
    .line 5
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    .line 6
    move-result-object v1

    .line 7
    .line 8
    .line 9
    invoke-virtual {v1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    .line 10
    move-result-object v1

    .line 11
    const/4 v2, 0x1

    .line 12
    .line 13
    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->layoutInDisplayCutoutMode:I

    .line 14
    .line 15
    const/16 v1, 0x1e

    .line 16
    .line 17
    if-lt v0, v1, :cond_0

    .line 18
    .line 19
    .line 20
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    .line 21
    move-result-object v0

    .line 22
    const/4 v1, 0x0

    .line 23
    .line 24
    .line 25
    invoke-static {v0, v1}, Lcom/xj/pcvirtualbtn/math/a;->a(Landroid/view/Window;Z)V

    .line 26
    .line 27
    .line 28
    :cond_0
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    .line 29
    move-result-object p0

    .line 30
    .line 31
    .line 32
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    .line 33
    move-result-object p0

    .line 34
    .line 35
    const/16 v0, 0x1506

    .line 36
    .line 37
    .line 38
    invoke-virtual {p0, v0}, Landroid/view/View;->setSystemUiVisibility(I)V

    .line 39
    return-void
.end method

.method public S(Z)V
    .locals 3

    .line 1
    .line 2
    const-string v0, ""

    .line 3
    .line 4
    if-eqz p1, :cond_3

    .line 5
    const/4 v1, 0x1

    .line 6
    .line 7
    iput-boolean v1, p0, Lcom/xj/winemu/WineActivity;->p:Z

    .line 8
    .line 9
    .line 10
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->y2()Z

    .line 11
    move-result v2

    .line 12
    .line 13
    if-nez v2, :cond_2

    .line 14
    .line 15
    iget-object v2, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 16
    .line 17
    if-eqz v2, :cond_1

    .line 18
    .line 19
    .line 20
    invoke-virtual {v2}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 21
    move-result-object v2

    .line 22
    .line 23
    if-nez v2, :cond_0

    .line 24
    goto :goto_0

    .line 25
    :cond_0
    move-object v0, v2

    .line 26
    .line 27
    .line 28
    :cond_1
    :goto_0
    invoke-static {v1, v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->g(ZLjava/lang/String;)V

    .line 29
    .line 30
    .line 31
    :cond_2
    invoke-virtual {p0, v1}, Lcom/xj/winemu/WineActivity;->i2(Z)V

    .line 32
    goto :goto_2

    .line 33
    :cond_3
    const/4 v1, 0x0

    .line 34
    .line 35
    iput-boolean v1, p0, Lcom/xj/winemu/WineActivity;->p:Z

    .line 36
    .line 37
    .line 38
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->y2()Z

    .line 39
    move-result v2

    .line 40
    .line 41
    if-nez v2, :cond_6

    .line 42
    .line 43
    iget-object v2, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 44
    .line 45
    if-eqz v2, :cond_5

    .line 46
    .line 47
    .line 48
    invoke-virtual {v2}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 49
    move-result-object v2

    .line 50
    .line 51
    if-nez v2, :cond_4

    .line 52
    goto :goto_1

    .line 53
    :cond_4
    move-object v0, v2

    .line 54
    .line 55
    .line 56
    :cond_5
    :goto_1
    invoke-static {v1, v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->g(ZLjava/lang/String;)V

    .line 57
    .line 58
    .line 59
    :cond_6
    invoke-virtual {p0, v1}, Lcom/xj/winemu/WineActivity;->i2(Z)V

    .line 60
    .line 61
    .line 62
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->Q2()V

    .line 63
    .line 64
    :goto_2
    new-instance p0, Lcom/xj/winemu/ToggleVirtualGamePadEvent;

    .line 65
    .line 66
    sget-object v0, Lcom/xj/winemu/ToggleVirtualGamePadPage;->WineActivity:Lcom/xj/winemu/ToggleVirtualGamePadPage;

    .line 67
    .line 68
    .line 69
    invoke-direct {p0, p1, v0}, Lcom/xj/winemu/ToggleVirtualGamePadEvent;-><init>(ZLcom/xj/winemu/ToggleVirtualGamePadPage;)V

    .line 70
    const/4 p1, 0x2

    .line 71
    const/4 v0, 0x0

    .line 72
    .line 73
    .line 74
    invoke-static {p0, v0, p1, v0}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 75
    return-void
.end method

.method public final S2(Z)V
    .locals 4

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 3
    .line 4
    if-nez p0, :cond_0

    .line 5
    .line 6
    const-string p0, "binding"

    .line 7
    .line 8
    .line 9
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 10
    const/4 p0, 0x0

    .line 11
    .line 12
    :cond_0
    iget-object p0, p0, Lcom/xj/winemu/databinding/ActivityWineBinding;->layoutXContainer:Landroid/widget/FrameLayout;

    .line 13
    .line 14
    const-string v0, "layoutXContainer"

    .line 15
    .line 16
    .line 17
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 18
    .line 19
    .line 20
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    .line 21
    move-result v0

    .line 22
    const/4 v1, 0x0

    .line 23
    .line 24
    :goto_0
    if-ge v1, v0, :cond_2

    .line 25
    .line 26
    .line 27
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    .line 28
    move-result-object v2

    .line 29
    .line 30
    instance-of v3, v2, Lcom/winemu/ui/X11View;

    .line 31
    .line 32
    if-eqz v3, :cond_1

    .line 33
    .line 34
    check-cast v2, Lcom/winemu/ui/X11View;

    .line 35
    .line 36
    .line 37
    invoke-virtual {v2, p1}, Landroid/view/View;->setFocusable(Z)V

    .line 38
    .line 39
    .line 40
    invoke-virtual {v2, p1}, Landroid/view/View;->setFocusableInTouchMode(Z)V

    .line 41
    .line 42
    :cond_1
    add-int/lit8 v1, v1, 0x1

    .line 43
    goto :goto_0

    .line 44
    :cond_2
    return-void
.end method

.method public final T2()V
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->d()Z

    .line 6
    move-result v0

    .line 7
    .line 8
    if-eqz v0, :cond_0

    .line 9
    .line 10
    .line 11
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->m2()V

    .line 12
    return-void

    .line 13
    .line 14
    .line 15
    :cond_0
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->y2()Z

    .line 16
    move-result v0

    .line 17
    .line 18
    if-nez v0, :cond_1

    .line 19
    .line 20
    .line 21
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->m2()V

    .line 22
    :cond_1
    return-void
.end method

.method public final V2()V
    .locals 2

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->v:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;

    .line 3
    .line 4
    if-eqz v0, :cond_2

    .line 5
    const/4 v1, 0x0

    .line 6
    .line 7
    .line 8
    invoke-virtual {v0, v1}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->N(Z)V

    .line 9
    .line 10
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 11
    .line 12
    if-eqz v1, :cond_0

    .line 13
    .line 14
    .line 15
    invoke-virtual {v1}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 16
    move-result-object v1

    .line 17
    .line 18
    if-nez v1, :cond_1

    .line 19
    .line 20
    :cond_0
    const-string v1, ""

    .line 21
    .line 22
    .line 23
    :cond_1
    invoke-static {v1}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->r(Ljava/lang/String;)I

    .line 24
    move-result v1

    .line 25
    .line 26
    .line 27
    invoke-virtual {v0, v1}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->w(I)Lcom/xj/pcvirtualbtn/inputcontrols/ControlsProfile;

    .line 28
    move-result-object v0

    .line 29
    .line 30
    if-eqz v0, :cond_2

    .line 31
    .line 32
    .line 33
    invoke-direct {p0, v0}, Lcom/xj/winemu/WineActivity;->X2(Lcom/xj/pcvirtualbtn/inputcontrols/ControlsProfile;)V

    .line 34
    :cond_2
    return-void
.end method

.method public final W2()V
    .locals 6

    .line 1
    .line 2
    new-instance v3, Lcom/xj/winemu/WineActivity$showDelayAnimation$1;

    .line 3
    const/4 v0, 0x0

    .line 4
    .line 5
    .line 6
    invoke-direct {v3, p0, v0}, Lcom/xj/winemu/WineActivity$showDelayAnimation$1;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 7
    const/4 v4, 0x3

    .line 8
    const/4 v5, 0x0

    .line 9
    const/4 v1, 0x0

    .line 10
    const/4 v2, 0x0

    .line 11
    move-object v0, p0

    .line 12
    .line 13
    .line 14
    invoke-static/range {v0 .. v5}, Lcom/drake/net/utils/ScopeKt;->f(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;Lkotlinx/coroutines/CoroutineDispatcher;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lcom/drake/net/scope/AndroidScope;

    .line 15
    return-void
.end method

.method public final Y2()V
    .locals 14

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 3
    .line 4
    if-eqz v0, :cond_3

    .line 5
    .line 6
    .line 7
    invoke-virtual {v0}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 8
    move-result-object v0

    .line 9
    .line 10
    if-nez v0, :cond_0

    .line 11
    goto :goto_0

    .line 12
    .line 13
    :cond_0
    sget-object v1, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->a:Lcom/xj/winemu/settings/PcGameSettingDataHelper;

    .line 14
    .line 15
    .line 16
    invoke-virtual {v1, v0}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->v(Ljava/lang/String;)Lcom/xj/winemu/settings/PcGameSettingOperations;

    .line 17
    move-result-object v0

    .line 18
    .line 19
    .line 20
    invoke-virtual {v0}, Lcom/xj/winemu/settings/PcGameSettingOperations;->j1()Z

    .line 21
    move-result v0

    .line 22
    .line 23
    if-eqz v0, :cond_3

    .line 24
    .line 25
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 26
    .line 27
    if-nez v0, :cond_1

    .line 28
    .line 29
    const-string v0, "winuiBridge"

    .line 30
    .line 31
    .line 32
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 33
    const/4 v0, 0x0

    .line 34
    .line 35
    .line 36
    :cond_1
    invoke-virtual {v0}, Lcom/winemu/openapi/WinUIBridge;->O()Ljava/lang/String;

    .line 37
    move-result-object v0

    .line 38
    .line 39
    if-eqz v0, :cond_3

    .line 40
    .line 41
    .line 42
    invoke-interface {v0}, Ljava/lang/CharSequence;->length()I

    .line 43
    move-result v1

    .line 44
    .line 45
    if-nez v1, :cond_2

    .line 46
    goto :goto_0

    .line 47
    .line 48
    :cond_2
    sget-object v2, Lcom/xj/common/view/dialog/CommDialogFragment;->w:Lcom/xj/common/view/dialog/CommDialogFragment$Companion;

    .line 49
    .line 50
    sget v1, Lcom/xj/language/R$string;->winemu_log_server_dialog_title:I

    .line 51
    .line 52
    .line 53
    invoke-virtual {p0, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 54
    move-result-object v3

    .line 55
    .line 56
    const-string v1, "getString(...)"

    .line 57
    .line 58
    .line 59
    invoke-static {v3, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 60
    .line 61
    sget v4, Lcom/xj/language/R$string;->winemu_log_server_dialog_message:I

    .line 62
    .line 63
    .line 64
    invoke-virtual {p0, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 65
    move-result-object v4

    .line 66
    .line 67
    .line 68
    invoke-static {v4, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 69
    const/4 v5, 0x1

    .line 70
    .line 71
    .line 72
    filled-new-array {v0}, [Ljava/lang/Object;

    .line 73
    move-result-object v6

    .line 74
    .line 75
    .line 76
    invoke-static {v6, v5}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    .line 77
    move-result-object v5

    .line 78
    .line 79
    .line 80
    invoke-static {v4, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    .line 81
    move-result-object v4

    .line 82
    .line 83
    const-string v5, "format(...)"

    .line 84
    .line 85
    .line 86
    invoke-static {v4, v5}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 87
    .line 88
    sget v5, Lcom/xj/language/R$string;->winemu_copy_log_server_url:I

    .line 89
    .line 90
    .line 91
    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 92
    move-result-object v5

    .line 93
    .line 94
    .line 95
    invoke-static {v5, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 96
    .line 97
    new-instance v11, Lcom/xj/winemu/y;

    .line 98
    .line 99
    .line 100
    invoke-direct {v11, p0, v0}, Lcom/xj/winemu/y;-><init>(Lcom/xj/winemu/WineActivity;Ljava/lang/String;)V

    .line 101
    .line 102
    const/16 v12, 0x78

    .line 103
    const/4 v13, 0x0

    .line 104
    const/4 v6, 0x0

    .line 105
    const/4 v7, 0x0

    .line 106
    const/4 v8, 0x0

    .line 107
    const/4 v9, 0x0

    .line 108
    const/4 v10, 0x1

    .line 109
    .line 110
    .line 111
    invoke-static/range {v2 .. v13}, Lcom/xj/common/view/dialog/CommDialogFragment$Companion;->g(Lcom/xj/common/view/dialog/CommDialogFragment$Companion;Ljava/lang/String;Ljava/lang/CharSequence;Ljava/lang/String;Ljava/lang/String;[ILjava/lang/Integer;Ljava/lang/Integer;ZLkotlin/jvm/functions/Function1;ILjava/lang/Object;)Lcom/xj/common/view/dialog/CommDialogFragment;

    .line 112
    move-result-object v0

    .line 113
    const/4 v1, 0x0

    .line 114
    .line 115
    .line 116
    invoke-virtual {v0, v1}, Lcom/xj/common/view/dialog/CommDialogFragment;->a1(Z)V

    .line 117
    .line 118
    .line 119
    invoke-virtual {v0, v1}, Lcom/xj/common/view/dialog/CommDialogFragment;->c1(Z)V

    .line 120
    .line 121
    .line 122
    invoke-virtual {p0}, Landroidx/fragment/app/FragmentActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    .line 123
    move-result-object p0

    .line 124
    .line 125
    const-string v1, "LogServerInfoDialog"

    .line 126
    .line 127
    .line 128
    invoke-virtual {v0, p0, v1}, Landroidx/fragment/app/DialogFragment;->show(Landroidx/fragment/app/FragmentManager;Ljava/lang/String;)V

    .line 129
    :cond_3
    :goto_0
    return-void
.end method

.method public final a3(Z)V
    .locals 3

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 3
    .line 4
    const-string v1, "binding"

    .line 5
    const/4 v2, 0x0

    .line 6
    .line 7
    if-nez v0, :cond_0

    .line 8
    .line 9
    .line 10
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 11
    move-object v0, v2

    .line 12
    .line 13
    :cond_0
    iget-object v0, v0, Lcom/xj/winemu/databinding/ActivityWineBinding;->layoutXContainer:Landroid/widget/FrameLayout;

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0}, Landroid/view/View;->requestFocus()Z

    .line 17
    .line 18
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 19
    .line 20
    if-nez v0, :cond_1

    .line 21
    .line 22
    .line 23
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 24
    move-object v0, v2

    .line 25
    .line 26
    :cond_1
    iget-object v0, v0, Lcom/xj/winemu/databinding/ActivityWineBinding;->layoutXContainer:Landroid/widget/FrameLayout;

    .line 27
    .line 28
    const-string v1, "layoutXContainer"

    .line 29
    .line 30
    .line 31
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 32
    .line 33
    new-instance v1, Lcom/xj/winemu/WineActivity$toggleSoftKeyboard$1;

    .line 34
    .line 35
    .line 36
    invoke-direct {v1, p0, p1, v2}, Lcom/xj/winemu/WineActivity$toggleSoftKeyboard$1;-><init>(Lcom/xj/winemu/WineActivity;ZLkotlin/coroutines/Continuation;)V

    .line 37
    const/4 p0, 0x1

    .line 38
    .line 39
    .line 40
    invoke-static {v0, v2, v1, p0, v2}, Lcom/drake/net/utils/ScopeKt;->n(Landroid/view/View;Lkotlinx/coroutines/CoroutineDispatcher;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lcom/drake/net/scope/ViewCoroutineScope;

    .line 41
    return-void
.end method

.method public attachBaseContext(Landroid/content/Context;)V
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/base/language/GHLocaleManager;->a:Lcom/xj/base/language/GHLocaleManager;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0, p1}, Lcom/xj/base/language/GHLocaleManager;->d(Landroid/content/Context;)Landroid/content/Context;

    .line 6
    move-result-object p1

    .line 7
    .line 8
    .line 9
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->attachBaseContext(Landroid/content/Context;)V

    .line 10
    return-void
.end method

.method public final b3()V
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->p()F

    .line 4
    move-result v0

    .line 5
    const/4 v1, 0x0

    .line 6
    .line 7
    .line 8
    invoke-virtual {p0, v1, v0}, Lcom/xj/winemu/WineActivity;->c3(ZF)V

    .line 9
    const/4 v1, 0x1

    .line 10
    .line 11
    .line 12
    invoke-virtual {p0, v1, v0}, Lcom/xj/winemu/WineActivity;->c3(ZF)V

    .line 13
    return-void
.end method

.method public final c3(ZF)V
    .locals 1

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 3
    .line 4
    if-eqz p0, :cond_0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0, p1, p2}, Lcom/winemu/core/gamepad/GamepadManager;->u1(ZF)V

    .line 8
    .line 9
    :cond_0
    new-instance p0, Ljava/lang/StringBuilder;

    .line 10
    .line 11
    .line 12
    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    .line 13
    .line 14
    const-string v0, "isRightStick = "

    .line 15
    .line 16
    .line 17
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 18
    .line 19
    .line 20
    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 21
    .line 22
    const-string p1, ", scale = "

    .line 23
    .line 24
    .line 25
    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 26
    .line 27
    .line 28
    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    .line 29
    .line 30
    .line 31
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 32
    move-result-object p0

    .line 33
    .line 34
    const-string p1, "updateGamepadSensitivity"

    .line 35
    .line 36
    .line 37
    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 38
    return-void
.end method

.method public final d3(Lcom/xj/winemu/bean/NativeRenderingMode;)V
    .locals 2

    .line 1
    .line 2
    sget-object v0, Lcom/xj/winemu/bean/NativeRendering;->Companion:Lcom/xj/winemu/bean/NativeRendering$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0, p1}, Lcom/xj/winemu/bean/NativeRendering$Companion;->trans2NativeRenderingMode(Lcom/xj/winemu/bean/NativeRenderingMode;)Lcom/winemu/openapi/DirectRenderingMode;

    .line 6
    move-result-object p1

    .line 7
    .line 8
    new-instance v0, Ljava/lang/StringBuilder;

    .line 9
    .line 10
    .line 11
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 12
    .line 13
    const-string v1, "updateNativeRenderingMode = "

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 17
    .line 18
    .line 19
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 20
    .line 21
    .line 22
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 23
    move-result-object v0

    .line 24
    .line 25
    const-string v1, "WineActivity"

    .line 26
    .line 27
    .line 28
    invoke-static {v1, v0}, Lcom/xj/common/utils/XjLog;->c(Ljava/lang/String;Ljava/lang/String;)V

    .line 29
    .line 30
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 31
    .line 32
    if-nez p0, :cond_0

    .line 33
    .line 34
    const-string p0, "winuiBridge"

    .line 35
    .line 36
    .line 37
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 38
    const/4 p0, 0x0

    .line 39
    .line 40
    .line 41
    :cond_0
    invoke-virtual {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->g0(Lcom/winemu/openapi/DirectRenderingMode;)V

    .line 42
    return-void
.end method

.method public dispatchGenericMotionEvent(Landroid/view/MotionEvent;)Z
    .locals 2

    .line 1
    .line 2
    const-string v0, "event"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 8
    const/4 v1, 0x0

    .line 9
    .line 10
    if-nez v0, :cond_0

    .line 11
    .line 12
    const-string v0, "uiContainerManager"

    .line 13
    .line 14
    .line 15
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 16
    move-object v0, v1

    .line 17
    .line 18
    .line 19
    :cond_0
    invoke-virtual {v0}, Lcom/xj/winemu/ui/WineUIContainerManager;->d()Z

    .line 20
    move-result v0

    .line 21
    .line 22
    if-eqz v0, :cond_1

    .line 23
    .line 24
    .line 25
    invoke-super {p0, p1}, Landroid/app/Activity;->dispatchGenericMotionEvent(Landroid/view/MotionEvent;)Z

    .line 26
    move-result p0

    .line 27
    return p0

    .line 28
    .line 29
    :cond_1
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 30
    .line 31
    if-nez v0, :cond_2

    .line 32
    .line 33
    const-string v0, "winuiBridge"

    .line 34
    .line 35
    .line 36
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 37
    goto :goto_0

    .line 38
    :cond_2
    move-object v1, v0

    .line 39
    .line 40
    .line 41
    :goto_0
    invoke-virtual {v1, p1}, Lcom/winemu/openapi/WinUIBridge;->G(Landroid/view/MotionEvent;)Z

    .line 42
    move-result v0

    .line 43
    .line 44
    if-nez v0, :cond_4

    .line 45
    .line 46
    .line 47
    invoke-super {p0, p1}, Landroid/app/Activity;->dispatchGenericMotionEvent(Landroid/view/MotionEvent;)Z

    .line 48
    move-result p0

    .line 49
    .line 50
    if-eqz p0, :cond_3

    .line 51
    goto :goto_1

    .line 52
    :cond_3
    const/4 p0, 0x0

    .line 53
    return p0

    .line 54
    :cond_4
    :goto_1
    const/4 p0, 0x1

    .line 55
    return p0
.end method

.method public dispatchKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 6

    .line 1
    .line 2
    const-string v0, "event"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    .line 9
    move-result v0

    .line 10
    const/4 v1, 0x1

    .line 11
    .line 12
    const-string v2, "winuiBridge"

    .line 13
    .line 14
    const-string v3, "uiContainerManager"

    .line 15
    const/4 v4, 0x0

    .line 16
    .line 17
    if-nez v0, :cond_8

    .line 18
    .line 19
    .line 20
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 21
    move-result v0

    .line 22
    const/4 v5, 0x4

    .line 23
    .line 24
    if-eq v0, v5, :cond_0

    .line 25
    .line 26
    .line 27
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 28
    move-result v0

    .line 29
    .line 30
    const/16 v5, 0x6e

    .line 31
    .line 32
    if-ne v0, v5, :cond_8

    .line 33
    .line 34
    :cond_0
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 35
    .line 36
    if-nez v0, :cond_1

    .line 37
    .line 38
    .line 39
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 40
    move-object v0, v4

    .line 41
    .line 42
    .line 43
    :cond_1
    invoke-virtual {v0}, Lcom/winemu/openapi/WinUIBridge;->W()Z

    .line 44
    move-result v0

    .line 45
    .line 46
    if-nez v0, :cond_7

    .line 47
    .line 48
    sget-object v0, Lcom/xj/common/config/AppConfig;->a:Lcom/xj/common/config/AppConfig$Companion;

    .line 49
    .line 50
    .line 51
    invoke-virtual {v0}, Lcom/xj/common/config/AppConfig$Companion;->e()Z

    .line 52
    move-result v0

    .line 53
    .line 54
    if-eqz v0, :cond_2

    .line 55
    .line 56
    sget-object v0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 57
    .line 58
    .line 59
    invoke-virtual {v0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->c()Z

    .line 60
    move-result v0

    .line 61
    .line 62
    if-eqz v0, :cond_2

    .line 63
    .line 64
    .line 65
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z

    .line 66
    move-result p0

    .line 67
    return p0

    .line 68
    .line 69
    :cond_2
    iget-object p1, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 70
    .line 71
    if-nez p1, :cond_3

    .line 72
    .line 73
    .line 74
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 75
    move-object p1, v4

    .line 76
    .line 77
    .line 78
    :cond_3
    invoke-virtual {p1}, Lcom/xj/winemu/ui/WineUIContainerManager;->d()Z

    .line 79
    move-result p1

    .line 80
    .line 81
    if-eqz p1, :cond_5

    .line 82
    .line 83
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 84
    .line 85
    if-nez p0, :cond_4

    .line 86
    .line 87
    .line 88
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 89
    goto :goto_0

    .line 90
    :cond_4
    move-object v4, p0

    .line 91
    .line 92
    .line 93
    :goto_0
    invoke-virtual {v4}, Lcom/xj/winemu/ui/WineUIContainerManager;->b()V

    .line 94
    goto :goto_2

    .line 95
    .line 96
    :cond_5
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 97
    .line 98
    if-nez p0, :cond_6

    .line 99
    .line 100
    .line 101
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 102
    goto :goto_1

    .line 103
    :cond_6
    move-object v4, p0

    .line 104
    .line 105
    .line 106
    :goto_1
    invoke-virtual {v4}, Lcom/xj/winemu/ui/WineUIContainerManager;->e()V

    .line 107
    :cond_7
    :goto_2
    return v1

    .line 108
    .line 109
    :cond_8
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 110
    .line 111
    if-nez v0, :cond_9

    .line 112
    .line 113
    .line 114
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 115
    move-object v0, v4

    .line 116
    .line 117
    .line 118
    :cond_9
    invoke-virtual {v0}, Lcom/xj/winemu/ui/WineUIContainerManager;->d()Z

    .line 119
    move-result v0

    .line 120
    .line 121
    if-eqz v0, :cond_a

    .line 122
    .line 123
    .line 124
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z

    .line 125
    move-result p0

    .line 126
    return p0

    .line 127
    .line 128
    :cond_a
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 129
    .line 130
    if-nez v0, :cond_b

    .line 131
    .line 132
    .line 133
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 134
    goto :goto_3

    .line 135
    :cond_b
    move-object v4, v0

    .line 136
    .line 137
    .line 138
    :goto_3
    invoke-virtual {v4, p1}, Lcom/winemu/openapi/WinUIBridge;->H(Landroid/view/KeyEvent;)Z

    .line 139
    move-result v0

    .line 140
    .line 141
    if-nez v0, :cond_d

    .line 142
    .line 143
    .line 144
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z

    .line 145
    move-result p0

    .line 146
    .line 147
    if-eqz p0, :cond_c

    .line 148
    goto :goto_4

    .line 149
    :cond_c
    const/4 p0, 0x0

    .line 150
    return p0

    .line 151
    :cond_d
    :goto_4
    return v1
.end method

.method public dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-super {p0, p1}, Landroid/app/Activity;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public final e3()V
    .locals 8

    .line 1
    .line 2
    new-instance v0, Lcom/winemu/openapi/ReshadeConfig;

    .line 3
    .line 4
    .line 5
    invoke-direct {v0}, Lcom/winemu/openapi/ReshadeConfig;-><init>()V

    .line 6
    .line 7
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 8
    const/4 v2, 0x0

    .line 9
    .line 10
    if-eqz v1, :cond_0

    .line 11
    .line 12
    .line 13
    invoke-virtual {v1}, Lcom/xj/winemu/api/bean/WineActivityData;->c()Z

    .line 14
    move-result v1

    .line 15
    .line 16
    .line 17
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 18
    move-result-object v1

    .line 19
    goto :goto_0

    .line 20
    :cond_0
    move-object v1, v2

    .line 21
    :goto_0
    const/4 v3, 0x0

    .line 22
    .line 23
    if-eqz v1, :cond_1

    .line 24
    .line 25
    .line 26
    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    .line 27
    move-result v1

    .line 28
    goto :goto_1

    .line 29
    :cond_1
    move v1, v3

    .line 30
    :goto_1
    const/4 v4, 0x1

    .line 31
    xor-int/2addr v1, v4

    .line 32
    .line 33
    .line 34
    invoke-virtual {v0, v1}, Lcom/winemu/openapi/ReshadeConfig;->c(Z)V

    .line 35
    .line 36
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->n:Lcom/winemu/openapi/CASEffect;

    .line 37
    .line 38
    iget-object v5, p0, Lcom/xj/winemu/WineActivity;->m:Lcom/winemu/openapi/HDREffect;

    .line 39
    .line 40
    iget-object v6, p0, Lcom/xj/winemu/WineActivity;->o:Lcom/winemu/openapi/CRTEffect;

    .line 41
    const/4 v7, 0x3

    .line 42
    .line 43
    new-array v7, v7, [Lcom/winemu/openapi/Effect;

    .line 44
    .line 45
    aput-object v1, v7, v3

    .line 46
    .line 47
    aput-object v5, v7, v4

    .line 48
    const/4 v1, 0x2

    .line 49
    .line 50
    aput-object v6, v7, v1

    .line 51
    .line 52
    .line 53
    invoke-static {v7}, Lkotlin/collections/CollectionsKt;->s([Ljava/lang/Object;)Ljava/util/List;

    .line 54
    move-result-object v1

    .line 55
    .line 56
    .line 57
    invoke-virtual {v0, v1}, Lcom/winemu/openapi/ReshadeConfig;->b(Ljava/util/List;)V

    .line 58
    .line 59
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 60
    .line 61
    if-nez p0, :cond_2

    .line 62
    .line 63
    const-string p0, "winuiBridge"

    .line 64
    .line 65
    .line 66
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 67
    goto :goto_2

    .line 68
    :cond_2
    move-object v2, p0

    .line 69
    .line 70
    .line 71
    :goto_2
    invoke-virtual {v2, v0}, Lcom/winemu/openapi/WinUIBridge;->D(Lcom/winemu/openapi/ReshadeConfig;)V

    .line 72
    return-void
.end method

.method public f0(Lcom/winemu/core/gamepad/GamepadDisconnectionEvent;)V
    .locals 4

    .line 1
    .line 2
    const-string v0, "event"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-static {p0, p1}, Lcom/winemu/core/gamepad/GamepadEventListener$DefaultImpls;->b(Lcom/winemu/core/gamepad/GamepadEventListener;Lcom/winemu/core/gamepad/GamepadDisconnectionEvent;)V

    .line 9
    .line 10
    sget-object v0, Lcom/xj/winemu/bean/GamePad;->Companion:Lcom/xj/winemu/bean/GamePad$Companion;

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1}, Lcom/winemu/core/gamepad/GamepadDisconnectionEvent;->a()Lcom/winemu/core/gamepad/GamepadDevice;

    .line 14
    move-result-object p1

    .line 15
    const/4 v1, 0x0

    .line 16
    const/4 v2, 0x2

    .line 17
    const/4 v3, 0x0

    .line 18
    .line 19
    .line 20
    invoke-static {v0, p1, v1, v2, v3}, Lcom/xj/winemu/bean/GamePad$Companion;->from$default(Lcom/xj/winemu/bean/GamePad$Companion;Lcom/winemu/core/gamepad/GamepadDevice;ZILjava/lang/Object;)Lcom/xj/winemu/bean/GamePad;

    .line 21
    move-result-object p1

    .line 22
    .line 23
    .line 24
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->y2()Z

    .line 25
    move-result v0

    .line 26
    .line 27
    sget-object v2, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 28
    .line 29
    .line 30
    invoke-virtual {v2, p1, v0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->g(Lcom/xj/winemu/bean/GamePad;Z)V

    .line 31
    .line 32
    if-nez v0, :cond_0

    .line 33
    .line 34
    iget-boolean v0, p0, Lcom/xj/winemu/WineActivity;->q:Z

    .line 35
    .line 36
    if-nez v0, :cond_0

    .line 37
    const/4 v0, 0x1

    .line 38
    .line 39
    .line 40
    invoke-virtual {p0, v0}, Lcom/xj/winemu/WineActivity;->S(Z)V

    .line 41
    goto :goto_0

    .line 42
    .line 43
    :cond_0
    iput-boolean v1, p0, Lcom/xj/winemu/WineActivity;->q:Z

    .line 44
    .line 45
    :goto_0
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 46
    .line 47
    if-nez v0, :cond_1

    .line 48
    .line 49
    const-string v0, "winuiBridge"

    .line 50
    .line 51
    .line 52
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 53
    move-object v0, v3

    .line 54
    .line 55
    .line 56
    :cond_1
    invoke-virtual {v0}, Lcom/winemu/openapi/WinUIBridge;->W()Z

    .line 57
    move-result v0

    .line 58
    .line 59
    if-eqz v0, :cond_2

    .line 60
    goto :goto_1

    .line 61
    .line 62
    :cond_2
    sget-object v0, Lcom/xj/winemu/ui/dialog/GamePadManagerDialog;->t:Lcom/xj/winemu/ui/dialog/GamePadManagerDialog$Companion;

    .line 63
    .line 64
    .line 65
    invoke-virtual {v0}, Lcom/xj/winemu/ui/dialog/GamePadManagerDialog$Companion;->a()Z

    .line 66
    move-result v0

    .line 67
    .line 68
    if-eqz v0, :cond_3

    .line 69
    :goto_1
    return-void

    .line 70
    .line 71
    :cond_3
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 72
    .line 73
    if-nez p0, :cond_4

    .line 74
    .line 75
    const-string p0, "uiContainerManager"

    .line 76
    .line 77
    .line 78
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 79
    goto :goto_2

    .line 80
    :cond_4
    move-object v3, p0

    .line 81
    .line 82
    .line 83
    :goto_2
    invoke-virtual {v3, p1, v1}, Lcom/xj/winemu/ui/WineUIContainerManager;->g(Lcom/xj/winemu/bean/GamePad;Z)V

    .line 84
    return-void
.end method

.method public getResources()Landroid/content/res/Resources;
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    .line 4
    move-result-object p0

    .line 5
    .line 6
    const-string v0, "getResources(...)"

    .line 7
    .line 8
    .line 9
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 10
    const/4 v0, 0x0

    .line 11
    const/4 v1, 0x1

    .line 12
    .line 13
    .line 14
    invoke-static {p0, v0, v1, v0}, Lcom/xj/base/adaptscreen/AdaptUtilsKt;->b(Landroid/content/res/Resources;Landroid/content/Context;ILjava/lang/Object;)Landroid/content/res/Resources;

    .line 15
    move-result-object p0

    .line 16
    return-object p0
.end method

.method public final i2(Z)V
    .locals 6

    .line 1
    .line 2
    if-eqz p1, :cond_4

    .line 3
    .line 4
    .line 5
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->m2()V

    .line 6
    .line 7
    iget-object p1, p0, Lcom/xj/winemu/WineActivity;->v:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;

    .line 8
    .line 9
    if-nez p1, :cond_3

    .line 10
    .line 11
    sget-object p1, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 12
    .line 13
    .line 14
    invoke-virtual {p1}, Lcom/xj/winemu/external/PcInGameDelegateManager;->d()Z

    .line 15
    move-result p1

    .line 16
    .line 17
    if-nez p1, :cond_3

    .line 18
    .line 19
    new-instance p1, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;

    .line 20
    .line 21
    .line 22
    invoke-direct {p1, p0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;-><init>(Landroid/content/Context;)V

    .line 23
    .line 24
    iput-object p1, p0, Lcom/xj/winemu/WineActivity;->v:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;

    .line 25
    .line 26
    new-instance p1, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;

    .line 27
    .line 28
    .line 29
    invoke-direct {p1, p0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;-><init>(Landroid/content/Context;)V

    .line 30
    .line 31
    new-instance v0, Lcom/xj/winemu/u;

    .line 32
    .line 33
    .line 34
    invoke-direct {v0, p0}, Lcom/xj/winemu/u;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 35
    .line 36
    .line 37
    invoke-virtual {p1, v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;->setStreamView(Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView$MoveEvent;)V

    .line 38
    .line 39
    new-instance v0, Lcom/xj/winemu/WineVirtualGamePadInputCallback;

    .line 40
    .line 41
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 42
    const/4 v2, 0x0

    .line 43
    .line 44
    if-nez v1, :cond_0

    .line 45
    .line 46
    const-string v1, "winuiBridge"

    .line 47
    .line 48
    .line 49
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 50
    move-object v1, v2

    .line 51
    .line 52
    :cond_0
    new-instance v3, Lcom/xj/winemu/v;

    .line 53
    .line 54
    .line 55
    invoke-direct {v3, p0}, Lcom/xj/winemu/v;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 56
    .line 57
    .line 58
    invoke-direct {v0, v1, v3}, Lcom/xj/winemu/WineVirtualGamePadInputCallback;-><init>(Lcom/winemu/openapi/WinUIBridge;Lkotlin/jvm/functions/Function0;)V

    .line 59
    .line 60
    .line 61
    invoke-virtual {p1, v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;->setInputCallBack(Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView$InputCallBack;)V

    .line 62
    .line 63
    iput-object p1, p0, Lcom/xj/winemu/WineActivity;->w:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;

    .line 64
    const/4 v0, 0x0

    .line 65
    .line 66
    .line 67
    invoke-virtual {p1, v0}, Landroid/view/View;->setFocusable(Z)V

    .line 68
    .line 69
    iget-object p1, p0, Lcom/xj/winemu/WineActivity;->w:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;

    .line 70
    .line 71
    if-eqz p1, :cond_1

    .line 72
    .line 73
    .line 74
    invoke-virtual {p1, v0}, Landroid/view/View;->setFocusableInTouchMode(Z)V

    .line 75
    .line 76
    :cond_1
    iget-object p1, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 77
    .line 78
    if-nez p1, :cond_2

    .line 79
    .line 80
    const-string p1, "binding"

    .line 81
    .line 82
    .line 83
    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 84
    goto :goto_0

    .line 85
    :cond_2
    move-object v2, p1

    .line 86
    .line 87
    :goto_0
    iget-object p1, v2, Lcom/xj/winemu/databinding/ActivityWineBinding;->btnLayout:Landroid/widget/FrameLayout;

    .line 88
    .line 89
    # Add InputControlsView (buttons) FIRST
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->w:Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;

    .line 90
    .line 91
    .line 92
    invoke-virtual {p1, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    # Create and add RtsTouchOverlayView ON TOP (after buttons)
    new-instance v1, Lcom/xj/winemu/view/RtsTouchOverlayView;

    invoke-direct {v1, p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;-><init>(Landroid/content/Context;)V

    # Set the WinUIBridge on the overlay
    iget-object v2, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    iput-object v2, v1, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;

    # Set the buttons view reference so overlay can forward touches
    iput-object v0, v1, Lcom/xj/winemu/view/RtsTouchOverlayView;->b:Landroid/view/View;

    # Make the overlay clickable so it receives touch events
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/view/View;->setClickable(Z)V

    # Store the overlay in the field
    iput-object v1, p0, Lcom/xj/winemu/WineActivity;->t0:Lcom/xj/winemu/view/RtsTouchOverlayView;

    # Create MATCH_PARENT layout params (-1 = MATCH_PARENT)
    new-instance v2, Landroid/view/ViewGroup$LayoutParams;
    const/4 v3, -0x1
    invoke-direct {v2, v3, v3}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    # Add overlay to btnLayout ON TOP (buttons already added)
    invoke-virtual {p1, v1, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Check saved setting and set initial visibility
    invoke-static {}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsTouchControlsEnabled()Z

    move-result v2
    move v4, v2

    if-eqz v2, :cond_rts_hide

    # RTS enabled - set visibility VISIBLE (0)
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    goto :goto_rts_done

    :cond_rts_hide
    # RTS disabled - set visibility GONE (8)
    const/16 v2, 0x8

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    :goto_rts_done
    # If RTS is enabled on startup, disable Screen Trackpad input immediately
    if-eqz v4, :cond_after_init_trackpad
    iget-object v2, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v2, :cond_after_init_trackpad
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Lcom/winemu/openapi/WinUIBridge;->o0(Z)V
    # Persistently turn off Screen Trackpad for current profile when RTS starts enabled
    iget-object v2, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;
    if-eqz v2, :cond_profile_null_init
    invoke-virtual {v2}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;
    move-result-object v2
    if-nez v2, :cond_have_profile_init

    :cond_profile_null_init
    const/4 v2, 0x0

    :cond_have_profile_init
    const/4 v5, 0x0
    invoke-static {v5, v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->h(ZLjava/lang/String;)V

    :cond_after_init_trackpad
    # Store this activity instance to static field for toggle access
    sput-object p0, Lcom/xj/winemu/WineActivity;->t1:Lcom/xj/winemu/WineActivity;

    .line 93
    .line 94
    .line 95
    :cond_3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->V2()V

    .line 96
    return-void

    .line 97
    .line 98
    .line 99
    :cond_4
    invoke-direct {p0}, Lcom/xj/winemu/WineActivity;->z2()V

    .line 100
    return-void
.end method

.method public static toggleRtsTouchOverlay(Z)V
    .locals 6

    # Get the static activity instance
    sget-object v0, Lcom/xj/winemu/WineActivity;->t1:Lcom/xj/winemu/WineActivity;

    if-eqz v0, :cond_end

    # Get the overlay view
    iget-object v1, v0, Lcom/xj/winemu/WineActivity;->t0:Lcom/xj/winemu/view/RtsTouchOverlayView;

    if-eqz v1, :cond_end

    # Check if enabling or disabling
    if-eqz p0, :cond_hide

    # Enable - set VISIBLE (0), ENABLED, and CLICKABLE
    const/4 v4, 0x0
    invoke-virtual {v1, v4}, Landroid/view/View;->setVisibility(I)V
    const/4 v4, 0x1
    invoke-virtual {v1, v4}, Landroid/view/View;->setEnabled(Z)V
    invoke-virtual {v1, v4}, Landroid/view/View;->setClickable(Z)V

    # Disable Screen Trackpad input while RTS overlay is enabled
    iget-object v2, v0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v2, :cond_after_enable
    const/4 v3, 0x0
    invoke-virtual {v2, v3}, Lcom/winemu/openapi/WinUIBridge;->o0(Z)V

    :cond_after_enable
    # Persistently turn off Screen Trackpad for current profile while RTS is active
    iget-object v2, v0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;
    if-eqz v2, :cond_profile_null_enable
    invoke-virtual {v2}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;
    move-result-object v2
    if-nez v2, :cond_have_profile_enable

    :cond_profile_null_enable
    const/4 v2, 0x0

    :cond_have_profile_enable
    const/4 v5, 0x0
    invoke-static {v5, v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->h(ZLjava/lang/String;)V

    goto :cond_end

    :cond_hide
    # Disable - set INVISIBLE (4), DISABLED, and non-CLICKABLE so normal trackpad works
    const/4 v4, 0x4
    invoke-virtual {v1, v4}, Landroid/view/View;->setVisibility(I)V
    const/4 v4, 0x0
    invoke-virtual {v1, v4}, Landroid/view/View;->setEnabled(Z)V
    invoke-virtual {v1, v4}, Landroid/view/View;->setClickable(Z)V

    # Restore Screen Trackpad input based on current profile when RTS overlay is disabled
    iget-object v2, v0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v2, :cond_end

    # Get current profile id
    iget-object v3, v0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;
    if-eqz v3, :cond_profile_null
    invoke-virtual {v3}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;
    move-result-object v3
    if-nez v3, :cond_have_profile

    :cond_profile_null
    const/4 v3, 0x0

    :cond_have_profile
    invoke-static {v3}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->B(Ljava/lang/String;)Z
    move-result v4
    invoke-virtual {v2, v4}, Lcom/winemu/openapi/WinUIBridge;->o0(Z)V

    :cond_end
    return-void
.end method

# --- BannerHub: toggle Sustained Performance Mode at runtime ---
.method public static toggleSustainedPerf(Z)V
    .locals 4

    # Try setSustainedPerformanceMode (no-root, works if OEM supports it)
    # Pref save is handled in SustainedPerfSwitchClickListener (always has view context)
    sget-object v0, Lcom/xj/winemu/WineActivity;->t1:Lcom/xj/winemu/WineActivity;
    if-eqz v0, :cond_spm_exec

    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v1
    invoke-virtual {v1, p0}, Landroid/view/Window;->setSustainedPerformanceMode(Z)V

    :cond_spm_exec
    # Also try CPU governor via su -c (root users get guaranteed effect)
    const/4 v0, 0x3
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "su"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "-c"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    if-eqz p0, :cond_spm_gov_off
    const-string v2, "for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo performance > $f; done"
    goto :cond_spm_gov_set
    :cond_spm_gov_off
    const-string v2, "for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo schedutil > $f; done"
    :cond_spm_gov_set
    aput-object v2, v0, v1
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v1
    invoke-virtual {v1, v0}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;

    :cond_spm_end
    return-void
.end method
# --- end BannerHub toggleSustainedPerf ---

# --- BannerHub: toggle Max Adreno Clocks at runtime (root) ---
.method public static toggleMaxAdreno(Z)V
    .locals 4

    # Pref save is handled in MaxAdrenoClickListener (always has view context)
    # Execute root command via su -c
    const/4 v0, 0x3
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "su"
    aput-object v2, v0, v1
    const/4 v1, 0x1
    const-string v2, "-c"
    aput-object v2, v0, v1
    const/4 v1, 0x2
    if-eqz p0, :cond_adreno_disable
    # Enable: lock GPU min_freq = max_freq
    const-string v2, "cat /sys/class/kgsl/kgsl-3d0/devfreq/max_freq > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq"
    goto :cond_adreno_cmd_set
    :cond_adreno_disable
    # Disable: reset min_freq to 0
    const-string v2, "echo 0 > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq"
    :cond_adreno_cmd_set
    aput-object v2, v0, v1
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v1
    invoke-virtual {v1, v0}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;

    :cond_adreno_end
    return-void
.end method
# --- end BannerHub toggleMaxAdreno ---

.method public final l2(Ljava/lang/String;)V
    .locals 1

    .line 1
    .line 2
    const-string v0, "clipboard"

    .line 3
    .line 4
    .line 5
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    .line 6
    move-result-object p0

    .line 7
    .line 8
    const-string v0, "null cannot be cast to non-null type android.content.ClipboardManager"

    .line 9
    .line 10
    .line 11
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 12
    .line 13
    check-cast p0, Landroid/content/ClipboardManager;

    .line 14
    .line 15
    const-string v0, "Log Server URL"

    .line 16
    .line 17
    .line 18
    invoke-static {v0, p1}, Landroid/content/ClipData;->newPlainText(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Landroid/content/ClipData;

    .line 19
    move-result-object p1

    .line 20
    .line 21
    .line 22
    invoke-virtual {p0, p1}, Landroid/content/ClipboardManager;->setPrimaryClip(Landroid/content/ClipData;)V

    .line 23
    .line 24
    sget-object p0, Lcom/xj/common/utils/toast/CustomToastUtils;->a:Lcom/xj/common/utils/toast/CustomToastUtils;

    .line 25
    .line 26
    const-string p1, "Link copied to clipboard"

    .line 27
    .line 28
    .line 29
    invoke-virtual {p0, p1}, Lcom/xj/common/utils/toast/CustomToastUtils;->b(Ljava/lang/String;)V

    .line 30
    return-void
.end method

.method public final m2()V
    .locals 3

    .line 1
    .line 2
    sget-object v0, Lcom/xj/common/utils/XjLog;->a:Lcom/xj/common/utils/XjLog;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/common/utils/XjLog;->j()Z

    .line 6
    move-result v0

    .line 7
    .line 8
    if-eqz v0, :cond_1

    .line 9
    .line 10
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->A:Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 11
    .line 12
    if-nez v0, :cond_0

    .line 13
    const/4 v0, 0x1

    .line 14
    goto :goto_0

    .line 15
    :cond_0
    const/4 v0, 0x0

    .line 16
    .line 17
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    .line 18
    .line 19
    .line 20
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 21
    .line 22
    const-string v2, "createVirtualGamePadController ? "

    .line 23
    .line 24
    .line 25
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 26
    .line 27
    .line 28
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 29
    .line 30
    .line 31
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 32
    move-result-object v0

    .line 33
    .line 34
    const-string v1, "WineActivity"

    .line 35
    .line 36
    .line 37
    invoke-static {v1, v0}, Lcom/xj/common/utils/XjLog;->c(Ljava/lang/String;Ljava/lang/String;)V

    .line 38
    .line 39
    :cond_1
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->A:Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 40
    .line 41
    if-eqz v0, :cond_2

    .line 42
    goto :goto_2

    .line 43
    .line 44
    :cond_2
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 45
    .line 46
    if-eqz v0, :cond_3

    .line 47
    .line 48
    .line 49
    invoke-virtual {v0}, Lcom/winemu/core/gamepad/GamepadManager;->B()Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 50
    move-result-object v0

    .line 51
    goto :goto_1

    .line 52
    :cond_3
    const/4 v0, 0x0

    .line 53
    .line 54
    :goto_1
    iput-object v0, p0, Lcom/xj/winemu/WineActivity;->A:Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 55
    .line 56
    if-eqz v0, :cond_6

    .line 57
    .line 58
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 59
    .line 60
    if-eqz p0, :cond_4

    .line 61
    .line 62
    .line 63
    invoke-virtual {p0}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 64
    move-result-object p0

    .line 65
    .line 66
    if-nez p0, :cond_5

    .line 67
    .line 68
    :cond_4
    const-string p0, ""

    .line 69
    .line 70
    .line 71
    :cond_5
    invoke-static {p0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->C(Ljava/lang/String;)Z

    .line 72
    move-result p0

    .line 73
    .line 74
    .line 75
    invoke-virtual {v0, p0}, Lcom/winemu/core/gamepad/VirtualGamepadController;->w(Z)V

    .line 76
    :cond_6
    :goto_2
    return-void
.end method

.method public final o2()V
    .locals 6

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Landroidx/lifecycle/LifecycleOwnerKt;->a(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    .line 7
    invoke-static {}, Lkotlinx/coroutines/Dispatchers;->c()Lkotlinx/coroutines/MainCoroutineDispatcher;

    .line 8
    move-result-object v1

    .line 9
    .line 10
    new-instance v3, Lcom/xj/winemu/WineActivity$delaySetupGamePad$1;

    .line 11
    const/4 v2, 0x0

    .line 12
    .line 13
    .line 14
    invoke-direct {v3, p0, v2}, Lcom/xj/winemu/WineActivity$delaySetupGamePad$1;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 15
    const/4 v4, 0x2

    .line 16
    const/4 v5, 0x0

    .line 17
    .line 18
    .line 19
    invoke-static/range {v0 .. v5}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 20
    return-void
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 1

    .line 1
    .line 2
    const-string v0, "newConfig"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 9
    .line 10
    iget p1, p1, Landroid/content/res/Configuration;->screenLayout:I

    .line 11
    .line 12
    and-int/lit8 p1, p1, 0xf

    .line 13
    .line 14
    if-eqz p1, :cond_0

    .line 15
    .line 16
    sget-object p1, Lcom/xj/base/util/RefreshRateHelper;->a:Lcom/xj/base/util/RefreshRateHelper;

    .line 17
    .line 18
    .line 19
    invoke-virtual {p1, p0}, Lcom/xj/base/util/RefreshRateHelper;->a(Landroid/app/Activity;)V

    .line 20
    :cond_0
    return-void
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 16

    .line 1
    .line 2
    move-object/from16 v1, p0

    .line 3
    .line 4
    .line 5
    invoke-super/range {p0 .. p1}, Lcom/xj/common/view/focus/focus/app/FocusableAppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x1e

    if-lt v2, v3, :cond_perf_0

    const-string v2, "power"

    invoke-virtual {v1, v2}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/PowerManager;

    const/4 v3, 0x5

    invoke-virtual {v2, v3}, Landroid/os/PowerManager;->getThermalHeadroom(I)F

    :cond_perf_0
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x1f

    if-lt v2, v3, :cond_perf_1

    const-class v2, Landroid/os/PerformanceHintManager;

    invoke-virtual {v1, v2}, Landroid/app/Activity;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/PerformanceHintManager;

    if-eqz v2, :cond_perf_1

    const/4 v3, 0x1

    new-array v4, v3, [I

    const/4 v5, 0x0

    invoke-static {}, Landroid/os/Process;->myTid()I

    move-result v6

    aput v6, v4, v5

    const-wide/32 v5, 0xf4240

    invoke-virtual {v2, v4, v5, v6}, Landroid/os/PerformanceHintManager;->createHintSession([IJ)Landroid/os/PerformanceHintManager$Session;

    move-result-object v3

    if-eqz v3, :cond_perf_1

    const-wide/16 v4, 0x3e8

    invoke-virtual {v3, v4, v5}, Landroid/os/PerformanceHintManager$Session;->reportActualWorkDuration(J)V

    :cond_perf_1
    # --- BannerHub: Sustained Performance Mode (no-root API + root governor) ---
    :try_start_bh_perf
    const-string v2, "bh_prefs"
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    const-string v3, "sustained_perf"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    if-eqz v2, :cond_bh_spm_skip
    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
    move-result-object v2
    const/4 v3, 0x1
    invoke-virtual {v2, v3}, Landroid/view/Window;->setSustainedPerformanceMode(Z)V
    const/4 v2, 0x3
    new-array v2, v2, [Ljava/lang/String;
    const/4 v3, 0x0
    const-string v4, "su"
    aput-object v4, v2, v3
    const/4 v3, 0x1
    const-string v4, "-c"
    aput-object v4, v2, v3
    const/4 v3, 0x2
    const-string v4, "for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo performance > $f; done"
    aput-object v4, v2, v3
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v3
    invoke-virtual {v3, v2}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;
    :cond_bh_spm_skip
    # --- end BannerHub Sustained Performance Mode ---

    # --- BannerHub: re-apply Max Adreno Clocks on launch ---
    const-string v2, "bh_prefs"
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2
    const-string v3, "max_adreno_clocks"
    const/4 v4, 0x0
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v2
    if-eqz v2, :cond_bh_adreno_skip
    const/4 v2, 0x3
    new-array v2, v2, [Ljava/lang/String;
    const/4 v3, 0x0
    const-string v4, "su"
    aput-object v4, v2, v3
    const/4 v3, 0x1
    const-string v4, "-c"
    aput-object v4, v2, v3
    const/4 v3, 0x2
    const-string v4, "cat /sys/class/kgsl/kgsl-3d0/devfreq/max_freq > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq"
    aput-object v4, v2, v3
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v3
    invoke-virtual {v3, v2}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;
    :cond_bh_adreno_skip
    # --- end BannerHub Max Adreno on launch ---
    :try_end_bh_perf
    .catch Ljava/lang/Exception; {:try_start_bh_perf .. :try_end_bh_perf} :catch_bh_perf
    :catch_bh_perf
    # BannerHub: exception swallowed — unsupported device or no root; container launch continues
    .line 6
    .line 7
    .line 8
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->R2()V

    .line 9
    .line 10
    .line 11
    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    .line 12
    move-result-object v0

    .line 13
    .line 14
    const/16 v2, 0x80

    .line 15
    .line 16
    .line 17
    invoke-virtual {v0, v2}, Landroid/view/Window;->addFlags(I)V

    .line 18
    .line 19
    sget-object v0, Lcom/xj/base/util/RefreshRateHelper;->a:Lcom/xj/base/util/RefreshRateHelper;

    .line 20
    .line 21
    .line 22
    invoke-virtual {v0, v1}, Lcom/xj/base/util/RefreshRateHelper;->a(Landroid/app/Activity;)V

    .line 23
    .line 24
    .line 25
    invoke-virtual {v1}, Landroid/app/Activity;->getLayoutInflater()Landroid/view/LayoutInflater;

    .line 26
    move-result-object v0

    .line 27
    .line 28
    .line 29
    invoke-static {v0}, Lcom/xj/winemu/databinding/ActivityWineBinding;->inflate(Landroid/view/LayoutInflater;)Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 30
    move-result-object v0

    .line 31
    .line 32
    const-string v2, "inflate(...)"

    .line 33
    .line 34
    .line 35
    invoke-static {v0, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 36
    .line 37
    iput-object v0, v1, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 38
    .line 39
    const-string v10, "binding"

    .line 40
    const/4 v11, 0x0

    .line 41
    .line 42
    if-nez v0, :cond_0

    .line 43
    .line 44
    .line 45
    invoke-static {v10}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 46
    move-object v0, v11

    .line 47
    .line 48
    .line 49
    :cond_0
    invoke-virtual {v0}, Lcom/xj/winemu/databinding/ActivityWineBinding;->getRoot()Lcom/xj/common/view/focus/InterceptFocusEventConstraintLayout;

    .line 50
    move-result-object v0

    .line 51
    .line 52
    .line 53
    invoke-virtual {v1, v0}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(Landroid/view/View;)V

    .line 54
    .line 55
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 56
    .line 57
    if-nez v0, :cond_1

    .line 58
    .line 59
    .line 60
    invoke-static {v10}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 61
    move-object v0, v11

    .line 62
    .line 63
    :cond_1
    iget-object v0, v0, Lcom/xj/winemu/databinding/ActivityWineBinding;->rootView:Lcom/xj/common/view/focus/InterceptFocusEventConstraintLayout;

    .line 64
    .line 65
    const-string v2, "rootView"

    .line 66
    .line 67
    .line 68
    invoke-static {v0, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 69
    .line 70
    .line 71
    invoke-virtual {v1, v0}, Lcom/xj/common/view/focus/focus/app/FocusableAppCompatActivity;->k(Lcom/xj/common/view/focus/InterceptFocusEventConstraintLayout;)V

    .line 72
    .line 73
    .line 74
    invoke-virtual {v1}, Landroidx/activity/ComponentActivity;->getOnBackPressedDispatcher()Landroidx/activity/OnBackPressedDispatcher;

    .line 75
    move-result-object v0

    .line 76
    .line 77
    new-instance v2, Lcom/xj/winemu/WineActivity$onCreate$1;

    .line 78
    .line 79
    .line 80
    invoke-direct {v2, v1}, Lcom/xj/winemu/WineActivity$onCreate$1;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 81
    .line 82
    .line 83
    invoke-virtual {v0, v2}, Landroidx/activity/OnBackPressedDispatcher;->h(Landroidx/activity/OnBackPressedCallback;)V

    .line 84
    .line 85
    .line 86
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->P2()V

    .line 87
    .line 88
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->t:Lcom/tencent/mmkv/MMKV;

    .line 89
    .line 90
    const-string v2, "curWineData"

    .line 91
    .line 92
    const-string v12, ""

    .line 93
    .line 94
    .line 95
    invoke-virtual {v0, v2, v12}, Lcom/tencent/mmkv/MMKV;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 96
    move-result-object v0

    .line 97
    .line 98
    const-class v2, Lcom/xj/winemu/api/bean/WineActivityData;

    .line 99
    .line 100
    .line 101
    invoke-static {v0, v2}, Lcom/blankj/utilcode/util/GsonUtils;->d(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;

    .line 102
    move-result-object v0

    .line 103
    .line 104
    check-cast v0, Lcom/xj/winemu/api/bean/WineActivityData;

    .line 105
    .line 106
    iput-object v0, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 107
    .line 108
    if-eqz v0, :cond_2

    .line 109
    .line 110
    sget-object v2, Lcom/xj/winemu/utils/RedMagicRelatedUtils;->a:Lcom/xj/winemu/utils/RedMagicRelatedUtils;

    .line 111
    .line 112
    .line 113
    invoke-virtual {v1}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    .line 114
    move-result-object v3

    .line 115
    .line 116
    const-string v4, "getIntent(...)"

    .line 117
    .line 118
    .line 119
    invoke-static {v3, v4}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 120
    .line 121
    .line 122
    invoke-virtual {v2, v3}, Lcom/xj/winemu/utils/RedMagicRelatedUtils;->c(Landroid/content/Intent;)Landroid/os/IBinder;

    .line 123
    move-result-object v2

    .line 124
    .line 125
    .line 126
    invoke-virtual {v0, v2}, Lcom/xj/winemu/api/bean/WineActivityData;->u(Landroid/os/IBinder;)V

    .line 127
    .line 128
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 129
    .line 130
    :cond_2
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 131
    .line 132
    if-eqz v0, :cond_3

    .line 133
    .line 134
    new-instance v2, Lcom/xj/winemu/utils/WineGameUsageTracker;

    .line 135
    .line 136
    .line 137
    invoke-direct {v2, v0}, Lcom/xj/winemu/utils/WineGameUsageTracker;-><init>(Lcom/xj/winemu/api/bean/WineActivityData;)V

    .line 138
    .line 139
    iput-object v2, v1, Lcom/xj/winemu/WineActivity;->x:Lcom/xj/winemu/utils/WineGameUsageTracker;

    .line 140
    .line 141
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 142
    .line 143
    :cond_3
    sget-object v0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 144
    .line 145
    move-object/from16 v2, p1

    .line 146
    .line 147
    .line 148
    invoke-virtual {v0, v2}, Lcom/xj/winemu/external/PcInGameDelegateManager;->onCreate(Landroid/os/Bundle;)V

    .line 149
    .line 150
    new-instance v0, Lcom/xj/winemu/utils/WineInGameSettings;

    .line 151
    .line 152
    iget-object v2, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 153
    .line 154
    if-eqz v2, :cond_4

    .line 155
    .line 156
    .line 157
    invoke-virtual {v2}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 158
    move-result-object v2

    .line 159
    .line 160
    if-nez v2, :cond_5

    .line 161
    :cond_4
    move-object v2, v12

    .line 162
    .line 163
    .line 164
    :cond_5
    invoke-direct {v0, v2}, Lcom/xj/winemu/utils/WineInGameSettings;-><init>(Ljava/lang/String;)V

    .line 165
    .line 166
    iput-object v0, v1, Lcom/xj/winemu/WineActivity;->B:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 167
    .line 168
    sget-object v2, Lcom/xj/winemu/utils/RedMagicRelatedUtils;->a:Lcom/xj/winemu/utils/RedMagicRelatedUtils;

    .line 169
    .line 170
    iget-object v3, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 171
    .line 172
    if-eqz v3, :cond_6

    .line 173
    .line 174
    .line 175
    invoke-virtual {v3}, Lcom/xj/winemu/api/bean/WineActivityData;->g()Landroid/os/IBinder;

    .line 176
    move-result-object v3

    .line 177
    goto :goto_0

    .line 178
    :cond_6
    move-object v3, v11

    .line 179
    .line 180
    .line 181
    :goto_0
    invoke-virtual {v2, v0, v3}, Lcom/xj/winemu/utils/RedMagicRelatedUtils;->a(Lcom/xj/winemu/utils/WineInGameSettings;Landroid/os/IBinder;)V

    .line 182
    .line 183
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 184
    .line 185
    if-eqz v0, :cond_7

    .line 186
    .line 187
    .line 188
    invoke-virtual {v0}, Lcom/xj/winemu/api/bean/WineActivityData;->d()Ljava/lang/String;

    .line 189
    move-result-object v0

    .line 190
    .line 191
    if-eqz v0, :cond_7

    .line 192
    .line 193
    .line 194
    invoke-static {v1}, Landroidx/lifecycle/LifecycleOwnerKt;->a(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 195
    move-result-object v2

    .line 196
    .line 197
    new-instance v5, Lcom/xj/winemu/WineActivity$onCreate$3$1;

    .line 198
    .line 199
    .line 200
    invoke-direct {v5, v1, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$3$1;-><init>(Lcom/xj/winemu/WineActivity;Ljava/lang/String;Lkotlin/coroutines/Continuation;)V

    .line 201
    const/4 v6, 0x3

    .line 202
    const/4 v7, 0x0

    .line 203
    const/4 v3, 0x0

    .line 204
    const/4 v4, 0x0

    .line 205
    .line 206
    .line 207
    invoke-static/range {v2 .. v7}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 208
    move-result-object v0

    .line 209
    .line 210
    if-nez v0, :cond_9

    .line 211
    .line 212
    :cond_7
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 213
    .line 214
    if-nez v0, :cond_8

    .line 215
    .line 216
    .line 217
    invoke-static {v10}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 218
    move-object v0, v11

    .line 219
    .line 220
    :cond_8
    iget-object v0, v0, Lcom/xj/winemu/databinding/ActivityWineBinding;->ivGameLogo:Lcom/xj/base/view/RoundedImageView;

    .line 221
    .line 222
    sget v2, Lcom/xj/winemu/R$drawable;->wine_default_exe_icon:I

    .line 223
    .line 224
    .line 225
    invoke-virtual {v0, v2}, Landroidx/appcompat/widget/AppCompatImageView;->setImageResource(I)V

    .line 226
    .line 227
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 228
    .line 229
    :cond_9
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 230
    const/4 v13, 0x1

    .line 231
    const/4 v14, 0x0

    .line 232
    .line 233
    if-eqz v0, :cond_e

    .line 234
    .line 235
    .line 236
    invoke-virtual {v0}, Lcom/xj/winemu/api/bean/WineActivityData;->j()Ljava/lang/String;

    .line 237
    move-result-object v0

    .line 238
    .line 239
    if-eqz v0, :cond_e

    .line 240
    .line 241
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 242
    .line 243
    if-eqz v0, :cond_a

    .line 244
    .line 245
    .line 246
    invoke-virtual {v0}, Lcom/xj/winemu/api/bean/WineActivityData;->b()Z

    .line 247
    move-result v0

    .line 248
    .line 249
    if-ne v0, v13, :cond_a

    .line 250
    move v0, v13

    .line 251
    goto :goto_1

    .line 252
    :cond_a
    move v0, v14

    .line 253
    .line 254
    :goto_1
    iput-boolean v0, v1, Lcom/xj/winemu/WineActivity;->I:Z

    .line 255
    .line 256
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 257
    .line 258
    if-eqz v0, :cond_b

    .line 259
    .line 260
    .line 261
    invoke-virtual {v0}, Lcom/xj/winemu/api/bean/WineActivityData;->k()Ljava/lang/String;

    .line 262
    move-result-object v0

    .line 263
    goto :goto_2

    .line 264
    :cond_b
    move-object v0, v11

    .line 265
    .line 266
    :goto_2
    if-eqz v0, :cond_d

    .line 267
    .line 268
    .line 269
    invoke-interface {v0}, Ljava/lang/CharSequence;->length()I

    .line 270
    move-result v0

    .line 271
    .line 272
    if-nez v0, :cond_c

    .line 273
    goto :goto_3

    .line 274
    :cond_c
    move v0, v14

    .line 275
    goto :goto_4

    .line 276
    :cond_d
    :goto_3
    move v0, v13

    .line 277
    :goto_4
    xor-int/2addr v0, v13

    .line 278
    .line 279
    iput-boolean v0, v1, Lcom/xj/winemu/WineActivity;->J:Z

    .line 280
    .line 281
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 282
    .line 283
    :cond_e
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 284
    .line 285
    if-nez v0, :cond_f

    .line 286
    .line 287
    .line 288
    invoke-static {v10}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 289
    move-object v0, v11

    .line 290
    .line 291
    :cond_f
    iget-object v0, v0, Lcom/xj/winemu/databinding/ActivityWineBinding;->drawerWineSlider:Lcom/xj/winemu/sidebar/WineActivityDrawerContent;

    .line 292
    .line 293
    iget-object v2, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 294
    .line 295
    .line 296
    invoke-virtual {v0, v2}, Lcom/xj/winemu/sidebar/WineActivityDrawerContent;->setWineData(Lcom/xj/winemu/api/bean/WineActivityData;)V

    .line 297
    .line 298
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 299
    .line 300
    if-nez v0, :cond_10

    .line 301
    .line 302
    .line 303
    invoke-static {v10}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 304
    move-object v0, v11

    .line 305
    .line 306
    :cond_10
    iget-object v0, v0, Lcom/xj/winemu/databinding/ActivityWineBinding;->drawerWineSlider:Lcom/xj/winemu/sidebar/WineActivityDrawerContent;

    .line 307
    .line 308
    iget v2, v1, Lcom/xj/winemu/WineActivity;->y:F

    .line 309
    .line 310
    .line 311
    invoke-virtual {v0, v2}, Landroid/view/View;->setTranslationX(F)V

    .line 312
    .line 313
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 314
    .line 315
    if-nez v0, :cond_11

    .line 316
    .line 317
    .line 318
    invoke-static {v10}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 319
    move-object v0, v11

    .line 320
    .line 321
    :cond_11
    iget-object v0, v0, Lcom/xj/winemu/databinding/ActivityWineBinding;->layoutXContainer:Landroid/widget/FrameLayout;

    .line 322
    .line 323
    const-string v2, "layoutXContainer"

    .line 324
    .line 325
    .line 326
    invoke-static {v0, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 327
    .line 328
    .line 329
    invoke-static {v0}, Lcom/xj/base/ext/BaseViewExtKt;->d(Landroid/view/View;)V

    .line 330
    .line 331
    new-instance v0, Lcom/winemu/openapi/WinUIBridge;

    .line 332
    .line 333
    .line 334
    invoke-direct {v0}, Lcom/winemu/openapi/WinUIBridge;-><init>()V

    .line 335
    .line 336
    iput-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 337
    .line 338
    sget-object v0, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 339
    .line 340
    iget-object v3, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 341
    .line 342
    if-eqz v3, :cond_12

    .line 343
    .line 344
    .line 345
    invoke-virtual {v3}, Lcom/xj/winemu/api/bean/WineActivityData;->j()Ljava/lang/String;

    .line 346
    move-result-object v3

    .line 347
    goto :goto_5

    .line 348
    :cond_12
    move-object v3, v11

    .line 349
    .line 350
    :goto_5
    iget-boolean v4, v1, Lcom/xj/winemu/WineActivity;->I:Z

    .line 351
    .line 352
    iget-object v5, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 353
    .line 354
    if-eqz v5, :cond_13

    .line 355
    .line 356
    .line 357
    invoke-virtual {v5}, Lcom/xj/winemu/api/bean/WineActivityData;->b()Z

    .line 358
    move-result v5

    .line 359
    .line 360
    .line 361
    invoke-static {v5}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 362
    move-result-object v5

    .line 363
    goto :goto_6

    .line 364
    :cond_13
    move-object v5, v11

    .line 365
    .line 366
    :goto_6
    iget-object v6, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 367
    .line 368
    new-instance v7, Ljava/lang/StringBuilder;

    .line 369
    .line 370
    .line 371
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    .line 372
    .line 373
    const-string v8, "Wine page "

    .line 374
    .line 375
    .line 376
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 377
    .line 378
    .line 379
    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 380
    .line 381
    const-string v3, " - is Steam game="

    .line 382
    .line 383
    .line 384
    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 385
    .line 386
    .line 387
    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 388
    .line 389
    const-string v3, " - has Steam client="

    .line 390
    .line 391
    .line 392
    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 393
    .line 394
    .line 395
    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 396
    .line 397
    const-string v3, ", wineData="

    .line 398
    .line 399
    .line 400
    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 401
    .line 402
    .line 403
    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 404
    .line 405
    .line 406
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 407
    move-result-object v3

    .line 408
    .line 409
    .line 410
    invoke-virtual {v0, v3}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 411
    .line 412
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 413
    .line 414
    const-string v15, "winuiBridge"

    .line 415
    .line 416
    if-nez v0, :cond_14

    .line 417
    .line 418
    .line 419
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 420
    move-object v0, v11

    .line 421
    .line 422
    :cond_14
    new-instance v3, Lcom/xj/winemu/p;

    .line 423
    .line 424
    .line 425
    invoke-direct {v3, v1}, Lcom/xj/winemu/p;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 426
    .line 427
    .line 428
    invoke-virtual {v0, v3}, Lcom/winemu/openapi/WinUIBridge;->h0(Lkotlin/jvm/functions/Function0;)V

    .line 429
    .line 430
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 431
    .line 432
    if-nez v0, :cond_15

    .line 433
    .line 434
    .line 435
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 436
    move-object v0, v11

    .line 437
    .line 438
    :cond_15
    new-instance v3, Lcom/xj/winemu/q;

    .line 439
    .line 440
    .line 441
    invoke-direct {v3, v1}, Lcom/xj/winemu/q;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 442
    .line 443
    .line 444
    invoke-virtual {v0, v3}, Lcom/winemu/openapi/WinUIBridge;->p0(Lkotlin/jvm/functions/Function0;)V

    .line 445
    .line 446
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 447
    .line 448
    if-nez v0, :cond_16

    .line 449
    .line 450
    .line 451
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 452
    move-object v0, v11

    .line 453
    .line 454
    :cond_16
    new-instance v3, Lcom/xj/winemu/s;

    .line 455
    .line 456
    .line 457
    invoke-direct {v3, v1}, Lcom/xj/winemu/s;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 458
    .line 459
    .line 460
    invoke-virtual {v0, v3}, Lcom/winemu/openapi/WinUIBridge;->n0(Lkotlin/jvm/functions/Function1;)V

    .line 461
    .line 462
    :try_start_0
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 463
    .line 464
    if-nez v0, :cond_17

    .line 465
    .line 466
    .line 467
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 468
    move-object v0, v11

    .line 469
    goto :goto_7

    .line 470
    :catch_0
    move-exception v0

    .line 471
    .line 472
    goto/16 :goto_8

    .line 473
    .line 474
    .line 475
    :cond_17
    :goto_7
    invoke-virtual {v0, v1}, Lcom/winemu/openapi/WinUIBridge;->Q(Landroid/app/Activity;)V

    .line 476
    .line 477
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 478
    .line 479
    if-nez v0, :cond_18

    .line 480
    .line 481
    .line 482
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 483
    move-object v0, v11

    .line 484
    .line 485
    :cond_18
    iget-object v3, v1, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 486
    .line 487
    if-nez v3, :cond_19

    .line 488
    .line 489
    .line 490
    invoke-static {v10}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 491
    move-object v3, v11

    .line 492
    .line 493
    :cond_19
    iget-object v3, v3, Lcom/xj/winemu/databinding/ActivityWineBinding;->layoutXContainer:Landroid/widget/FrameLayout;

    .line 494
    .line 495
    .line 496
    invoke-static {v3, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 497
    .line 498
    .line 499
    invoke-virtual {v0, v3}, Lcom/winemu/openapi/WinUIBridge;->E(Landroid/view/ViewGroup;)V

    .line 500
    .line 501
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 502
    .line 503
    if-nez v0, :cond_1a

    .line 504
    .line 505
    .line 506
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 507
    move-object v0, v11

    .line 508
    .line 509
    .line 510
    :cond_1a
    invoke-virtual {v0}, Lcom/winemu/openapi/WinUIBridge;->N()Lcom/winemu/core/gamepad/GamepadManager;

    .line 511
    move-result-object v0

    .line 512
    .line 513
    iput-object v0, v1, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 514
    .line 515
    if-eqz v0, :cond_1b

    .line 516
    .line 517
    .line 518
    invoke-virtual {v0, v1}, Lcom/winemu/core/gamepad/GamepadManager;->i(Lcom/winemu/core/gamepad/GamepadEventListener;)V

    .line 519
    .line 520
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 521
    .line 522
    :cond_1b
    new-instance v0, Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 523
    .line 524
    iget-object v2, v1, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 525
    .line 526
    if-nez v2, :cond_1c

    .line 527
    .line 528
    .line 529
    invoke-static {v10}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 530
    move-object v2, v11

    .line 531
    .line 532
    .line 533
    :cond_1c
    invoke-static {v1}, Landroidx/lifecycle/LifecycleOwnerKt;->a(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 534
    move-result-object v3

    .line 535
    .line 536
    iget-object v4, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 537
    .line 538
    iget-object v5, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 539
    .line 540
    if-nez v5, :cond_1d

    .line 541
    .line 542
    .line 543
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 544
    move-object v5, v11

    .line 545
    .line 546
    :cond_1d
    iget-object v6, v1, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 547
    .line 548
    iget-boolean v7, v1, Lcom/xj/winemu/WineActivity;->I:Z

    .line 549
    .line 550
    .line 551
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->E2()Z

    .line 552
    move-result v8

    .line 553
    .line 554
    new-instance v9, Lcom/xj/winemu/t;

    .line 555
    .line 556
    .line 557
    invoke-direct {v9, v1}, Lcom/xj/winemu/t;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 558
    .line 559
    .line 560
    invoke-direct/range {v0 .. v9}, Lcom/xj/winemu/ui/WineUIContainerManager;-><init>(Landroid/app/Activity;Lcom/xj/winemu/databinding/ActivityWineBinding;Landroidx/lifecycle/LifecycleCoroutineScope;Lcom/xj/winemu/api/bean/WineActivityData;Lcom/winemu/openapi/WinUIBridge;Lcom/winemu/core/gamepad/GamepadManager;ZZLkotlin/jvm/functions/Function1;)V

    .line 561
    .line 562
    iput-object v0, v1, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 563
    .line 564
    .line 565
    invoke-virtual {v0}, Lcom/xj/winemu/ui/WineUIContainerManager;->i()V

    .line 566
    .line 567
    .line 568
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->D2()V

    .line 569
    .line 570
    .line 571
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->B2()V

    .line 572
    .line 573
    .line 574
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->W2()V

    .line 575
    .line 576
    .line 577
    invoke-static {}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->p()F

    .line 578
    move-result v0

    .line 579
    .line 580
    iget-object v2, v1, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 581
    .line 582
    if-eqz v2, :cond_1e

    .line 583
    .line 584
    .line 585
    invoke-virtual {v2, v14, v0}, Lcom/winemu/core/gamepad/GamepadManager;->u1(ZF)V

    .line 586
    .line 587
    sget-object v2, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 588
    .line 589
    :cond_1e
    iget-object v2, v1, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 590
    .line 591
    if-eqz v2, :cond_1f

    .line 592
    .line 593
    .line 594
    invoke-virtual {v2, v13, v0}, Lcom/winemu/core/gamepad/GamepadManager;->u1(ZF)V

    .line 595
    .line 596
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 597
    goto :goto_9

    .line 598
    .line 599
    :goto_8
    sget-object v2, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 600
    .line 601
    .line 602
    invoke-virtual {v0}, Ljava/lang/Throwable;->getLocalizedMessage()Ljava/lang/String;

    .line 603
    move-result-object v3

    .line 604
    .line 605
    new-instance v4, Ljava/lang/StringBuilder;

    .line 606
    .line 607
    .line 608
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    .line 609
    .line 610
    const-string v5, "winuiBridge attach failed "

    .line 611
    .line 612
    .line 613
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 614
    .line 615
    .line 616
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 617
    .line 618
    .line 619
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 620
    move-result-object v3

    .line 621
    .line 622
    .line 623
    invoke-virtual {v2, v3}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 624
    .line 625
    .line 626
    invoke-virtual {v0}, Ljava/lang/Throwable;->printStackTrace()V

    .line 627
    .line 628
    .line 629
    invoke-virtual {v1}, Landroid/app/Activity;->finish()V

    .line 630
    .line 631
    :cond_1f
    :goto_9
    :try_start_1
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 632
    .line 633
    if-nez v0, :cond_20

    .line 634
    .line 635
    .line 636
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 637
    move-object v0, v11

    .line 638
    .line 639
    .line 640
    :cond_20
    invoke-virtual {v0}, Lcom/winemu/openapi/WinUIBridge;->F()Lkotlinx/coroutines/Job;

    .line 641
    .line 642
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 643
    .line 644
    if-nez v0, :cond_21

    .line 645
    .line 646
    .line 647
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 648
    move-object v0, v11

    .line 649
    .line 650
    :cond_21
    new-instance v2, Lcom/xj/winemu/WineActivity$onCreate$11;

    .line 651
    .line 652
    .line 653
    invoke-direct {v2, v1}, Lcom/xj/winemu/WineActivity$onCreate$11;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 654
    .line 655
    .line 656
    invoke-virtual {v0, v2}, Lcom/winemu/openapi/WinUIBridge;->l0(Lcom/winemu/core/server/perf/PerfEventListener;)V

    .line 657
    .line 658
    iget-object v0, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 659
    .line 660
    if-nez v0, :cond_22

    .line 661
    .line 662
    .line 663
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 664
    move-object v0, v11

    .line 665
    .line 666
    :cond_22
    new-instance v2, Lcom/xj/winemu/WineActivity$onCreate$12;

    .line 667
    .line 668
    .line 669
    invoke-direct {v2, v1}, Lcom/xj/winemu/WineActivity$onCreate$12;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 670
    .line 671
    .line 672
    invoke-virtual {v0, v2}, Lcom/winemu/openapi/WinUIBridge;->j0(Lcom/winemu/openapi/WinUIBridge$KeyboardEventListener;)V

    .line 673
    .line 674
    .line 675
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->A2()V

    .line 676
    .line 677
    sget-object v0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 678
    .line 679
    iget-object v2, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 680
    .line 681
    if-nez v2, :cond_23

    .line 682
    .line 683
    .line 684
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 685
    move-object v2, v11

    .line 686
    .line 687
    .line 688
    :cond_23
    invoke-virtual {v0, v2}, Lcom/xj/winemu/external/PcInGameDelegateManager;->a(Lcom/winemu/openapi/WinUIBridge;)V

    .line 689
    .line 690
    iget-object v2, v1, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 691
    .line 692
    if-nez v2, :cond_24

    .line 693
    .line 694
    .line 695
    invoke-static {v15}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 696
    move-object v2, v11

    .line 697
    .line 698
    :cond_24
    iget-object v3, v1, Lcom/xj/winemu/WineActivity;->B:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 699
    .line 700
    if-nez v3, :cond_25

    .line 701
    .line 702
    const-string v3, "wineInGameSettingsSaver"

    .line 703
    .line 704
    .line 705
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 706
    move-object v3, v11

    .line 707
    .line 708
    .line 709
    :cond_25
    invoke-virtual {v3}, Lcom/xj/winemu/utils/WineInGameSettings;->e()Z

    .line 710
    move-result v3

    .line 711
    .line 712
    .line 713
    invoke-virtual {v2, v3}, Lcom/winemu/openapi/WinUIBridge;->i0(Z)V

    .line 714
    .line 715
    .line 716
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->T2()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 717
    .line 718
    .line 719
    invoke-direct {v1}, Lcom/xj/winemu/WineActivity;->U2()V

    .line 720
    .line 721
    .line 722
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->Y2()V

    .line 723
    .line 724
    iget-object v2, v1, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 725
    .line 726
    if-nez v2, :cond_26

    .line 727
    .line 728
    .line 729
    invoke-static {v10}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 730
    move-object v2, v11

    .line 731
    .line 732
    :cond_26
    iget-object v2, v2, Lcom/xj/winemu/databinding/ActivityWineBinding;->flExternalVirtualBtnContainer:Landroid/widget/FrameLayout;

    .line 733
    .line 734
    const-string v3, "flExternalVirtualBtnContainer"

    .line 735
    .line 736
    .line 737
    invoke-static {v2, v3}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 738
    .line 739
    iget-object v3, v1, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 740
    .line 741
    if-eqz v3, :cond_28

    .line 742
    .line 743
    .line 744
    invoke-virtual {v3}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 745
    move-result-object v3

    .line 746
    .line 747
    if-nez v3, :cond_27

    .line 748
    goto :goto_a

    .line 749
    :cond_27
    move-object v12, v3

    .line 750
    .line 751
    .line 752
    :cond_28
    :goto_a
    invoke-virtual {v1}, Lcom/xj/winemu/WineActivity;->y2()Z

    .line 753
    move-result v3

    .line 754
    .line 755
    .line 756
    invoke-virtual {v0, v2, v12, v3}, Lcom/xj/winemu/external/PcInGameDelegateManager;->h(Landroid/widget/FrameLayout;Ljava/lang/String;Z)V

    .line 757
    .line 758
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$13;

    .line 759
    .line 760
    .line 761
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$13;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 762
    .line 763
    new-array v2, v14, [Ljava/lang/String;

    .line 764
    .line 765
    sget-object v3, Landroidx/lifecycle/Lifecycle$Event;->ON_DESTROY:Landroidx/lifecycle/Lifecycle$Event;

    .line 766
    .line 767
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 768
    .line 769
    .line 770
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 771
    .line 772
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$1;

    .line 773
    .line 774
    .line 775
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$1;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 776
    const/4 v8, 0x3

    .line 777
    const/4 v9, 0x0

    .line 778
    const/4 v5, 0x0

    .line 779
    const/4 v6, 0x0

    .line 780
    .line 781
    .line 782
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 783
    .line 784
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$14;

    .line 785
    .line 786
    .line 787
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$14;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 788
    .line 789
    new-array v2, v14, [Ljava/lang/String;

    .line 790
    .line 791
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 792
    .line 793
    .line 794
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 795
    .line 796
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$2;

    .line 797
    .line 798
    .line 799
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$2;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 800
    .line 801
    .line 802
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 803
    .line 804
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$15;

    .line 805
    .line 806
    .line 807
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$15;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 808
    .line 809
    new-array v2, v14, [Ljava/lang/String;

    .line 810
    .line 811
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 812
    .line 813
    .line 814
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 815
    .line 816
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$3;

    .line 817
    .line 818
    .line 819
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$3;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 820
    .line 821
    .line 822
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 823
    .line 824
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$16;

    .line 825
    .line 826
    .line 827
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$16;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 828
    .line 829
    new-array v2, v14, [Ljava/lang/String;

    .line 830
    .line 831
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 832
    .line 833
    .line 834
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 835
    .line 836
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$4;

    .line 837
    .line 838
    .line 839
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$4;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 840
    .line 841
    .line 842
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 843
    .line 844
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$17;

    .line 845
    .line 846
    .line 847
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$17;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 848
    .line 849
    new-array v2, v14, [Ljava/lang/String;

    .line 850
    .line 851
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 852
    .line 853
    .line 854
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 855
    .line 856
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$5;

    .line 857
    .line 858
    .line 859
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$5;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 860
    .line 861
    .line 862
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 863
    .line 864
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$18;

    .line 865
    .line 866
    .line 867
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$18;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 868
    .line 869
    new-array v2, v14, [Ljava/lang/String;

    .line 870
    .line 871
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 872
    .line 873
    .line 874
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 875
    .line 876
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$6;

    .line 877
    .line 878
    .line 879
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$6;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 880
    .line 881
    .line 882
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 883
    .line 884
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$19;

    .line 885
    .line 886
    .line 887
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$19;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 888
    .line 889
    new-array v2, v14, [Ljava/lang/String;

    .line 890
    .line 891
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 892
    .line 893
    .line 894
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 895
    .line 896
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$7;

    .line 897
    .line 898
    .line 899
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$7;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 900
    .line 901
    .line 902
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 903
    .line 904
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$20;

    .line 905
    .line 906
    .line 907
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$20;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 908
    .line 909
    new-array v2, v14, [Ljava/lang/String;

    .line 910
    .line 911
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 912
    .line 913
    .line 914
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 915
    .line 916
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$8;

    .line 917
    .line 918
    .line 919
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$8;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 920
    .line 921
    .line 922
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 923
    .line 924
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$21;

    .line 925
    .line 926
    .line 927
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$21;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 928
    .line 929
    new-array v2, v14, [Ljava/lang/String;

    .line 930
    .line 931
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 932
    .line 933
    .line 934
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 935
    .line 936
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$9;

    .line 937
    .line 938
    .line 939
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$9;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 940
    .line 941
    .line 942
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 943
    .line 944
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$22;

    .line 945
    .line 946
    .line 947
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$22;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 948
    .line 949
    new-array v2, v14, [Ljava/lang/String;

    .line 950
    .line 951
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 952
    .line 953
    .line 954
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 955
    .line 956
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$10;

    .line 957
    .line 958
    .line 959
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$10;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 960
    .line 961
    .line 962
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 963
    .line 964
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$23;

    .line 965
    .line 966
    .line 967
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$23;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 968
    .line 969
    new-array v2, v14, [Ljava/lang/String;

    .line 970
    .line 971
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 972
    .line 973
    .line 974
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 975
    .line 976
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$11;

    .line 977
    .line 978
    .line 979
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$11;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 980
    .line 981
    .line 982
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 983
    .line 984
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$24;

    .line 985
    .line 986
    .line 987
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$24;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 988
    .line 989
    new-array v2, v14, [Ljava/lang/String;

    .line 990
    .line 991
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 992
    .line 993
    .line 994
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 995
    .line 996
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$12;

    .line 997
    .line 998
    .line 999
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$12;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1000
    .line 1001
    .line 1002
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1003
    .line 1004
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$25;

    .line 1005
    .line 1006
    .line 1007
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$25;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1008
    .line 1009
    new-array v2, v14, [Ljava/lang/String;

    .line 1010
    .line 1011
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1012
    .line 1013
    .line 1014
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1015
    .line 1016
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$13;

    .line 1017
    .line 1018
    .line 1019
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$13;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1020
    .line 1021
    .line 1022
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1023
    .line 1024
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$26;

    .line 1025
    .line 1026
    .line 1027
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$26;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1028
    .line 1029
    new-array v2, v14, [Ljava/lang/String;

    .line 1030
    .line 1031
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1032
    .line 1033
    .line 1034
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1035
    .line 1036
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$14;

    .line 1037
    .line 1038
    .line 1039
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$14;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1040
    .line 1041
    .line 1042
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1043
    .line 1044
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$27;

    .line 1045
    .line 1046
    .line 1047
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$27;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1048
    .line 1049
    new-array v2, v14, [Ljava/lang/String;

    .line 1050
    .line 1051
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1052
    .line 1053
    .line 1054
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1055
    .line 1056
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$15;

    .line 1057
    .line 1058
    .line 1059
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$15;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1060
    .line 1061
    .line 1062
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1063
    .line 1064
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$28;

    .line 1065
    .line 1066
    .line 1067
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$28;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1068
    .line 1069
    new-array v2, v14, [Ljava/lang/String;

    .line 1070
    .line 1071
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1072
    .line 1073
    .line 1074
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1075
    .line 1076
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$16;

    .line 1077
    .line 1078
    .line 1079
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$16;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1080
    .line 1081
    .line 1082
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1083
    .line 1084
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$29;

    .line 1085
    .line 1086
    .line 1087
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$29;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1088
    .line 1089
    new-array v2, v14, [Ljava/lang/String;

    .line 1090
    .line 1091
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1092
    .line 1093
    .line 1094
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1095
    .line 1096
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$17;

    .line 1097
    .line 1098
    .line 1099
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$17;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1100
    .line 1101
    .line 1102
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1103
    .line 1104
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$30;

    .line 1105
    .line 1106
    .line 1107
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$30;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1108
    .line 1109
    new-array v2, v14, [Ljava/lang/String;

    .line 1110
    .line 1111
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1112
    .line 1113
    .line 1114
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1115
    .line 1116
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$18;

    .line 1117
    .line 1118
    .line 1119
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$18;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1120
    .line 1121
    .line 1122
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1123
    .line 1124
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$31;

    .line 1125
    .line 1126
    .line 1127
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$31;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1128
    .line 1129
    new-array v2, v14, [Ljava/lang/String;

    .line 1130
    .line 1131
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1132
    .line 1133
    .line 1134
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1135
    .line 1136
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$19;

    .line 1137
    .line 1138
    .line 1139
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$19;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1140
    .line 1141
    .line 1142
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1143
    .line 1144
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$32;

    .line 1145
    .line 1146
    .line 1147
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$32;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1148
    .line 1149
    new-array v2, v14, [Ljava/lang/String;

    .line 1150
    .line 1151
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1152
    .line 1153
    .line 1154
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1155
    .line 1156
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$20;

    .line 1157
    .line 1158
    .line 1159
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$20;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1160
    .line 1161
    .line 1162
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1163
    .line 1164
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$33;

    .line 1165
    .line 1166
    .line 1167
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$33;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1168
    .line 1169
    new-array v2, v14, [Ljava/lang/String;

    .line 1170
    .line 1171
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1172
    .line 1173
    .line 1174
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1175
    .line 1176
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$21;

    .line 1177
    .line 1178
    .line 1179
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$21;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1180
    .line 1181
    .line 1182
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1183
    .line 1184
    new-instance v0, Lcom/xj/winemu/WineActivity$onCreate$34;

    .line 1185
    .line 1186
    .line 1187
    invoke-direct {v0, v1, v11}, Lcom/xj/winemu/WineActivity$onCreate$34;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 1188
    .line 1189
    new-array v2, v14, [Ljava/lang/String;

    .line 1190
    .line 1191
    new-instance v4, Lcom/drake/channel/ChannelScope;

    .line 1192
    .line 1193
    .line 1194
    invoke-direct {v4, v1, v3}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 1195
    .line 1196
    new-instance v7, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$22;

    .line 1197
    .line 1198
    .line 1199
    invoke-direct {v7, v2, v0, v11}, Lcom/xj/winemu/WineActivity$onCreate$$inlined$receiveEvent$default$22;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 1200
    .line 1201
    .line 1202
    invoke-static/range {v4 .. v9}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 1203
    return-void

    .line 1204
    :catch_1
    move-exception v0

    .line 1205
    .line 1206
    .line 1207
    invoke-virtual {v0}, Ljava/lang/Throwable;->printStackTrace()V

    .line 1208
    return-void
.end method

.method public onDestroy()V
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->x2()V

    const/4 v0, 0x0

    sput-object v0, Lcom/xj/winemu/WineActivity;->t1:Lcom/xj/winemu/WineActivity;

    .line 4
    .line 5
    :try_start_0
    sget-object v0, Lcom/xj/winemu/utils/GameVirtualButtonHelper;->a:Lcom/xj/winemu/utils/GameVirtualButtonHelper;

    .line 6
    .line 7
    .line 8
    invoke-virtual {v0}, Lcom/xj/winemu/utils/GameVirtualButtonHelper;->b()V

    .line 9
    .line 10
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 11
    const/4 v1, 0x0

    .line 12
    .line 13
    if-nez v0, :cond_0

    .line 14
    .line 15
    const-string v0, "uiContainerManager"

    .line 16
    .line 17
    .line 18
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 19
    move-object v0, v1

    .line 20
    .line 21
    .line 22
    :cond_0
    invoke-virtual {v0}, Lcom/xj/winemu/ui/WineUIContainerManager;->a()V

    .line 23
    .line 24
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 25
    .line 26
    if-nez v0, :cond_1

    .line 27
    .line 28
    const-string v0, "winuiBridge"

    .line 29
    .line 30
    .line 31
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 32
    goto :goto_0

    .line 33
    :cond_1
    move-object v1, v0

    .line 34
    .line 35
    .line 36
    :goto_0
    invoke-virtual {v1}, Lcom/winemu/openapi/WinUIBridge;->Z()V

    .line 37
    .line 38
    sget-object v0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 39
    .line 40
    .line 41
    invoke-virtual {v0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->onDestroy()V

    .line 42
    .line 43
    .line 44
    invoke-super {p0}, Lcom/xj/common/view/focus/focus/app/FocusableAppCompatActivity;->onDestroy()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 45
    :catch_0
    return-void
.end method

.method public onPause()V
    .locals 0

    .line 1
    .line 2
    .line 3
    :try_start_0
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onPause()V

    .line 4
    .line 5
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 6
    .line 7
    if-nez p0, :cond_0

    .line 8
    .line 9
    const-string p0, "winuiBridge"

    .line 10
    .line 11
    .line 12
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 13
    const/4 p0, 0x0

    .line 14
    .line 15
    .line 16
    :cond_0
    invoke-virtual {p0}, Lcom/winemu/openapi/WinUIBridge;->a0()V

    .line 17
    .line 18
    sget-object p0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 19
    .line 20
    .line 21
    invoke-virtual {p0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->onPause()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 22
    :catch_0
    return-void
.end method

.method public onResume()V
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onResume()V

    .line 4
    .line 5
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 6
    .line 7
    if-nez v0, :cond_0

    .line 8
    .line 9
    const-string v0, "winuiBridge"

    .line 10
    .line 11
    .line 12
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 13
    const/4 v0, 0x0

    .line 14
    .line 15
    .line 16
    :cond_0
    invoke-virtual {v0}, Lcom/winemu/openapi/WinUIBridge;->b0()V

    .line 17
    .line 18
    iget-boolean v0, p0, Lcom/xj/winemu/WineActivity;->p:Z

    .line 19
    .line 20
    if-eqz v0, :cond_1

    .line 21
    .line 22
    .line 23
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->V2()V

    .line 24
    .line 25
    :cond_1
    # ── BannerHub: inject/sync HUD overlay on every resume ──
    invoke-static {p0}, Lcom/xj/winemu/sidebar/BhHudInjector;->injectOrUpdate(Landroid/app/Activity;)V

    sget-object p0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 26
    .line 27
    .line 28
    invoke-virtual {p0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->onResume()V

    .line 29
    return-void
.end method

.method public onStop()V
    .locals 0

    .line 1
    .line 2
    .line 3
    :try_start_0
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onStop()V

    .line 4
    .line 5
    sget-object p0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 6
    .line 7
    .line 8
    invoke-virtual {p0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->onStop()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 9
    :catch_0
    return-void
.end method

.method public onTrackballEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 3
    .line 4
    if-nez p0, :cond_0

    .line 5
    .line 6
    const-string p0, "winuiBridge"

    .line 7
    .line 8
    .line 9
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 10
    const/4 p0, 0x0

    .line 11
    .line 12
    .line 13
    :cond_0
    invoke-virtual {p0, p1}, Lcom/winemu/openapi/WinUIBridge;->I(Landroid/view/MotionEvent;)Z

    .line 14
    move-result p0

    .line 15
    return p0
.end method

.method public onWindowAttributesChanged(Landroid/view/WindowManager$LayoutParams;)V
    .locals 3

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->getResources()Landroid/content/res/Resources;

    .line 4
    move-result-object v0

    .line 5
    const/4 v1, 0x0

    .line 6
    const/4 v2, 0x1

    .line 7
    .line 8
    .line 9
    invoke-static {v0, v1, v2, v1}, Lcom/xj/base/adaptscreen/AdaptUtilsKt;->b(Landroid/content/res/Resources;Landroid/content/Context;ILjava/lang/Object;)Landroid/content/res/Resources;

    .line 10
    .line 11
    sget-object v0, Lcom/xj/base/language/GHLocaleManager;->a:Lcom/xj/base/language/GHLocaleManager;

    .line 12
    .line 13
    .line 14
    invoke-virtual {v0}, Lcom/xj/base/language/GHLocaleManager;->e()V

    .line 15
    .line 16
    .line 17
    invoke-super {p0, p1}, Landroid/app/Activity;->onWindowAttributesChanged(Landroid/view/WindowManager$LayoutParams;)V

    .line 18
    return-void
.end method

.method public final p2()V
    .locals 13

    .line 1
    .line 2
    iget-boolean v0, p0, Lcom/xj/winemu/WineActivity;->M:Z

    .line 3
    .line 4
    if-eqz v0, :cond_0

    .line 5
    .line 6
    goto/16 :goto_3

    .line 7
    :cond_0
    const/4 v0, 0x1

    .line 8
    .line 9
    iput-boolean v0, p0, Lcom/xj/winemu/WineActivity;->M:Z

    .line 10
    .line 11
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 12
    .line 13
    const-string v2, "winuiBridge"

    .line 14
    const/4 v3, 0x0

    .line 15
    .line 16
    if-nez v1, :cond_1

    .line 17
    .line 18
    .line 19
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 20
    move-object v1, v3

    .line 21
    .line 22
    .line 23
    :cond_1
    invoke-virtual {v1}, Lcom/winemu/openapi/WinUIBridge;->W()Z

    .line 24
    move-result v1

    .line 25
    .line 26
    const-string v4, "binding"

    .line 27
    .line 28
    const-string v5, ""

    .line 29
    .line 30
    if-nez v1, :cond_6

    .line 31
    .line 32
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->x:Lcom/xj/winemu/utils/WineGameUsageTracker;

    .line 33
    .line 34
    if-eqz v1, :cond_4

    .line 35
    .line 36
    .line 37
    invoke-virtual {v1}, Lcom/xj/winemu/utils/WineGameUsageTracker;->k()J

    .line 38
    move-result-wide v9

    .line 39
    .line 40
    const-wide/16 v6, 0x0

    .line 41
    .line 42
    cmp-long v6, v9, v6

    .line 43
    .line 44
    if-eqz v6, :cond_3

    .line 45
    .line 46
    sget-object v6, Lcom/xj/common/trace/PcEmuGameTraceEvent;->a:Lcom/xj/common/trace/PcEmuGameTraceEvent;

    .line 47
    .line 48
    iget-object v7, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 49
    .line 50
    .line 51
    invoke-static {v7}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 52
    .line 53
    .line 54
    invoke-virtual {v7}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 55
    move-result-object v7

    .line 56
    .line 57
    iget-object v8, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 58
    .line 59
    .line 60
    invoke-static {v8}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 61
    .line 62
    .line 63
    invoke-virtual {v8}, Lcom/xj/winemu/api/bean/WineActivityData;->j()Ljava/lang/String;

    .line 64
    move-result-object v8

    .line 65
    .line 66
    if-nez v8, :cond_2

    .line 67
    move-object v8, v5

    .line 68
    .line 69
    :cond_2
    iget-object v11, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 70
    .line 71
    .line 72
    invoke-static {v11}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 73
    .line 74
    .line 75
    invoke-virtual {v11}, Lcom/xj/winemu/api/bean/WineActivityData;->d()Ljava/lang/String;

    .line 76
    move-result-object v11

    .line 77
    .line 78
    .line 79
    invoke-virtual/range {v6 .. v11}, Lcom/xj/common/trace/PcEmuGameTraceEvent;->b(Ljava/lang/String;Ljava/lang/String;JLjava/lang/String;)V

    .line 80
    .line 81
    .line 82
    invoke-virtual {v1}, Lcom/xj/winemu/utils/WineGameUsageTracker;->g()V

    .line 83
    .line 84
    .line 85
    :cond_3
    invoke-virtual {v1}, Lcom/xj/winemu/utils/WineGameUsageTracker;->o()V

    .line 86
    .line 87
    :cond_4
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 88
    .line 89
    if-nez v1, :cond_5

    .line 90
    .line 91
    .line 92
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 93
    move-object v1, v3

    .line 94
    .line 95
    .line 96
    :cond_5
    invoke-virtual {v1}, Lcom/xj/winemu/databinding/ActivityWineBinding;->getRoot()Lcom/xj/common/view/focus/InterceptFocusEventConstraintLayout;

    .line 97
    move-result-object v1

    .line 98
    .line 99
    new-instance v6, Lcom/xj/winemu/m;

    .line 100
    .line 101
    .line 102
    invoke-direct {v6, p0}, Lcom/xj/winemu/m;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 103
    .line 104
    const-wide/16 v7, 0x3e8

    .line 105
    .line 106
    .line 107
    invoke-virtual {v1, v6, v7, v8}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 108
    .line 109
    :cond_6
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 110
    .line 111
    if-nez v1, :cond_7

    .line 112
    .line 113
    .line 114
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 115
    move-object v1, v3

    .line 116
    .line 117
    :cond_7
    iget-object v1, v1, Lcom/xj/winemu/databinding/ActivityWineBinding;->layoutXContainer:Landroid/widget/FrameLayout;

    .line 118
    .line 119
    const-string v6, "layoutXContainer"

    .line 120
    .line 121
    .line 122
    invoke-static {v1, v6}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 123
    .line 124
    .line 125
    invoke-static {v1}, Lcom/xj/base/ext/BaseViewExtKt;->d(Landroid/view/View;)V

    .line 126
    .line 127
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 128
    .line 129
    const-string v7, "uiContainerManager"

    .line 130
    .line 131
    if-nez v1, :cond_8

    .line 132
    .line 133
    .line 134
    invoke-static {v7}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 135
    move-object v1, v3

    .line 136
    .line 137
    .line 138
    :cond_8
    invoke-virtual {v1}, Lcom/xj/winemu/ui/WineUIContainerManager;->j()V

    .line 139
    .line 140
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->k:Lcom/xj/winemu/ui/WineUIContainerManager;

    .line 141
    .line 142
    if-nez v1, :cond_9

    .line 143
    .line 144
    .line 145
    invoke-static {v7}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 146
    move-object v1, v3

    .line 147
    .line 148
    .line 149
    :cond_9
    invoke-virtual {v1}, Lcom/xj/winemu/ui/WineUIContainerManager;->c()V

    .line 150
    .line 151
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 152
    .line 153
    if-eqz v1, :cond_a

    .line 154
    .line 155
    .line 156
    invoke-virtual {v1}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 157
    move-result-object v1

    .line 158
    .line 159
    if-eqz v1, :cond_a

    .line 160
    .line 161
    new-instance v7, Lcom/xj/winemu/n;

    .line 162
    .line 163
    .line 164
    invoke-direct {v7}, Lcom/xj/winemu/n;-><init>()V

    .line 165
    .line 166
    new-instance v8, Lcom/xj/winemu/o;

    .line 167
    .line 168
    .line 169
    invoke-direct {v8, p0}, Lcom/xj/winemu/o;-><init>(Lcom/xj/winemu/WineActivity;)V

    .line 170
    .line 171
    .line 172
    invoke-static {v1, v7, v8}, Lcom/xj/common/utils/KotlinUseUtilsKt;->b(Ljava/lang/Object;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;)V

    .line 173
    .line 174
    :cond_a
    sget-object v1, Lcom/xj/common/config/Constants;->a:Lcom/xj/common/config/Constants;

    .line 175
    .line 176
    .line 177
    invoke-virtual {v1}, Lcom/xj/common/config/Constants;->c()Z

    .line 178
    move-result v1

    .line 179
    .line 180
    if-eqz v1, :cond_b

    .line 181
    .line 182
    .line 183
    invoke-static {p0}, Lcom/xj/winemu/h;->a(Lcom/xj/winemu/WineActivity;)Landroid/view/Display;

    .line 184
    move-result-object v1

    .line 185
    .line 186
    .line 187
    invoke-virtual {v1}, Landroid/view/Display;->getDisplayId()I

    .line 188
    move-result v1

    .line 189
    .line 190
    if-eqz v1, :cond_b

    .line 191
    .line 192
    .line 193
    invoke-static {p0}, Landroidx/lifecycle/LifecycleOwnerKt;->a(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 194
    move-result-object v7

    .line 195
    .line 196
    new-instance v10, Lcom/xj/winemu/WineActivity$gameLoadComplete$5;

    .line 197
    .line 198
    .line 199
    invoke-direct {v10, p0, v3}, Lcom/xj/winemu/WineActivity$gameLoadComplete$5;-><init>(Lcom/xj/winemu/WineActivity;Lkotlin/coroutines/Continuation;)V

    .line 200
    const/4 v11, 0x3

    .line 201
    const/4 v12, 0x0

    .line 202
    const/4 v8, 0x0

    .line 203
    const/4 v9, 0x0

    .line 204
    .line 205
    .line 206
    invoke-static/range {v7 .. v12}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 207
    goto :goto_0

    .line 208
    .line 209
    .line 210
    :cond_b
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->y2()Z

    .line 211
    move-result v1

    .line 212
    .line 213
    if-nez v1, :cond_c

    .line 214
    .line 215
    iput-boolean v0, p0, Lcom/xj/winemu/WineActivity;->p:Z

    .line 216
    .line 217
    .line 218
    invoke-virtual {p0, v0}, Lcom/xj/winemu/WineActivity;->i2(Z)V

    .line 219
    .line 220
    :cond_c
    :goto_0
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 221
    .line 222
    if-nez v0, :cond_d

    .line 223
    .line 224
    .line 225
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 226
    move-object v0, v3

    .line 227
    .line 228
    :cond_d
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 229
    .line 230
    if-eqz v1, :cond_e

    .line 231
    .line 232
    .line 233
    invoke-virtual {v1}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 234
    move-result-object v1

    .line 235
    .line 236
    if-nez v1, :cond_f

    .line 237
    :cond_e
    move-object v1, v5

    .line 238
    .line 239
    .line 240
    :cond_f
    invoke-static {v1}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->B(Ljava/lang/String;)Z

    .line 241
    move-result v1

    .line 242
    .line 243
    .line 244
    invoke-virtual {v0, v1}, Lcom/winemu/openapi/WinUIBridge;->o0(Z)V

    .line 245
    .line 246
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->A:Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 247
    .line 248
    if-eqz v0, :cond_12

    .line 249
    .line 250
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 251
    .line 252
    if-eqz v1, :cond_11

    .line 253
    .line 254
    .line 255
    invoke-virtual {v1}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 256
    move-result-object v1

    .line 257
    .line 258
    if-nez v1, :cond_10

    .line 259
    goto :goto_1

    .line 260
    :cond_10
    move-object v5, v1

    .line 261
    .line 262
    .line 263
    :cond_11
    :goto_1
    invoke-static {v5}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->C(Ljava/lang/String;)Z

    .line 264
    move-result v1

    .line 265
    .line 266
    .line 267
    invoke-virtual {v0, v1}, Lcom/winemu/core/gamepad/VirtualGamepadController;->w(Z)V

    .line 268
    .line 269
    :cond_12
    sget-object v0, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 270
    .line 271
    .line 272
    invoke-virtual {v0}, Lcom/xj/winemu/external/PcInGameDelegateManager;->d()Z

    .line 273
    move-result v0

    .line 274
    .line 275
    if-eqz v0, :cond_15

    .line 276
    .line 277
    sget-object v0, Lcom/xj/winemu/utils/GameVirtualButtonHelper;->a:Lcom/xj/winemu/utils/GameVirtualButtonHelper;

    .line 278
    .line 279
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->h:Lcom/winemu/openapi/WinUIBridge;

    .line 280
    .line 281
    if-nez v1, :cond_13

    .line 282
    .line 283
    .line 284
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 285
    move-object v1, v3

    .line 286
    .line 287
    .line 288
    :cond_13
    invoke-virtual {v0, v1}, Lcom/xj/winemu/utils/GameVirtualButtonHelper;->a(Lcom/winemu/openapi/WinUIBridge;)V

    .line 289
    .line 290
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 291
    .line 292
    .line 293
    invoke-virtual {v0, v1}, Lcom/xj/winemu/utils/GameVirtualButtonHelper;->c(Lcom/winemu/core/gamepad/GamepadManager;)V

    .line 294
    .line 295
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->A:Lcom/winemu/core/gamepad/VirtualGamepadController;

    .line 296
    .line 297
    .line 298
    invoke-virtual {v0, v1}, Lcom/xj/winemu/utils/GameVirtualButtonHelper;->e(Lcom/winemu/core/gamepad/VirtualGamepadController;)V

    .line 299
    .line 300
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 301
    .line 302
    if-nez p0, :cond_14

    .line 303
    .line 304
    .line 305
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 306
    goto :goto_2

    .line 307
    :cond_14
    move-object v3, p0

    .line 308
    .line 309
    :goto_2
    iget-object p0, v3, Lcom/xj/winemu/databinding/ActivityWineBinding;->layoutXContainer:Landroid/widget/FrameLayout;

    .line 310
    .line 311
    .line 312
    invoke-static {p0, v6}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 313
    .line 314
    .line 315
    invoke-virtual {v0, p0}, Lcom/xj/winemu/utils/GameVirtualButtonHelper;->d(Landroid/widget/FrameLayout;)V

    .line 316
    :cond_15
    :goto_3
    return-void
.end method

.method public final t2()Ljava/lang/String;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->F:Lkotlin/Lazy;

    .line 3
    .line 4
    .line 5
    invoke-interface {p0}, Lkotlin/Lazy;->getValue()Ljava/lang/Object;

    .line 6
    move-result-object p0

    .line 7
    .line 8
    check-cast p0, Ljava/lang/String;

    .line 9
    return-object p0
.end method

.method public final u2()Lcom/winemu/core/steam_agent/StatusLanguage;
    .locals 2

    .line 1
    .line 2
    sget-object v0, Lcom/xj/base/language/GHLocaleManager;->a:Lcom/xj/base/language/GHLocaleManager;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0, p0}, Lcom/xj/base/language/GHLocaleManager;->j(Landroid/content/Context;)Ljava/util/Locale;

    .line 6
    move-result-object p0

    .line 7
    .line 8
    sget-object v1, Ljava/util/Locale;->SIMPLIFIED_CHINESE:Ljava/util/Locale;

    .line 9
    .line 10
    .line 11
    invoke-static {p0, v1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 12
    move-result v1

    .line 13
    .line 14
    if-eqz v1, :cond_0

    .line 15
    .line 16
    sget-object p0, Lcom/winemu/core/steam_agent/StatusLanguage;->CHINESE:Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 17
    return-object p0

    .line 18
    .line 19
    :cond_0
    sget-object v1, Ljava/util/Locale;->US:Ljava/util/Locale;

    .line 20
    .line 21
    .line 22
    invoke-static {p0, v1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 23
    move-result v1

    .line 24
    .line 25
    if-eqz v1, :cond_1

    .line 26
    .line 27
    sget-object p0, Lcom/winemu/core/steam_agent/StatusLanguage;->ENGLISH:Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 28
    return-object p0

    .line 29
    .line 30
    :cond_1
    sget-object v1, Ljava/util/Locale;->JAPAN:Ljava/util/Locale;

    .line 31
    .line 32
    .line 33
    invoke-static {p0, v1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 34
    move-result v1

    .line 35
    .line 36
    if-eqz v1, :cond_2

    .line 37
    .line 38
    sget-object p0, Lcom/winemu/core/steam_agent/StatusLanguage;->JAPANESE:Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 39
    return-object p0

    .line 40
    .line 41
    .line 42
    :cond_2
    invoke-virtual {v0}, Lcom/xj/base/language/GHLocaleManager;->m()Ljava/util/Locale;

    .line 43
    move-result-object v1

    .line 44
    .line 45
    .line 46
    invoke-static {p0, v1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 47
    move-result v1

    .line 48
    .line 49
    if-eqz v1, :cond_3

    .line 50
    .line 51
    sget-object p0, Lcom/winemu/core/steam_agent/StatusLanguage;->RUSSIAN:Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 52
    return-object p0

    .line 53
    .line 54
    .line 55
    :cond_3
    invoke-virtual {v0}, Lcom/xj/base/language/GHLocaleManager;->k()Ljava/util/Locale;

    .line 56
    move-result-object v1

    .line 57
    .line 58
    .line 59
    invoke-static {p0, v1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 60
    move-result v1

    .line 61
    .line 62
    if-eqz v1, :cond_4

    .line 63
    .line 64
    sget-object p0, Lcom/winemu/core/steam_agent/StatusLanguage;->PORTUGUESE:Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 65
    return-object p0

    .line 66
    .line 67
    .line 68
    :cond_4
    invoke-virtual {v0}, Lcom/xj/base/language/GHLocaleManager;->l()Ljava/util/Locale;

    .line 69
    move-result-object v0

    .line 70
    .line 71
    .line 72
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 73
    move-result p0

    .line 74
    .line 75
    if-eqz p0, :cond_5

    .line 76
    .line 77
    sget-object p0, Lcom/winemu/core/steam_agent/StatusLanguage;->PORTUGUESE_EUROPEAN:Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 78
    return-object p0

    .line 79
    .line 80
    .line 81
    :cond_5
    invoke-static {}, Landroid/content/res/Resources;->getSystem()Landroid/content/res/Resources;

    .line 82
    move-result-object p0

    .line 83
    .line 84
    .line 85
    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    .line 86
    move-result-object p0

    .line 87
    .line 88
    .line 89
    invoke-virtual {p0}, Landroid/content/res/Configuration;->getLocales()Landroid/os/LocaleList;

    .line 90
    move-result-object p0

    .line 91
    const/4 v0, 0x0

    .line 92
    .line 93
    .line 94
    invoke-virtual {p0, v0}, Landroid/os/LocaleList;->get(I)Ljava/util/Locale;

    .line 95
    move-result-object p0

    .line 96
    .line 97
    .line 98
    invoke-virtual {p0}, Ljava/util/Locale;->getLanguage()Ljava/lang/String;

    .line 99
    move-result-object v0

    .line 100
    .line 101
    const-string v1, "getLanguage(...)"

    .line 102
    .line 103
    .line 104
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 105
    .line 106
    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    .line 107
    .line 108
    .line 109
    invoke-virtual {v0, v1}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    .line 110
    move-result-object v0

    .line 111
    .line 112
    const-string v1, "toLowerCase(...)"

    .line 113
    .line 114
    .line 115
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 116
    .line 117
    const-string v1, "zh"

    .line 118
    .line 119
    .line 120
    invoke-static {v1, v0}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 121
    move-result v0

    .line 122
    .line 123
    if-eqz v0, :cond_6

    .line 124
    .line 125
    const-string v0, "CN"

    .line 126
    .line 127
    .line 128
    invoke-virtual {p0}, Ljava/util/Locale;->getCountry()Ljava/lang/String;

    .line 129
    move-result-object p0

    .line 130
    .line 131
    .line 132
    invoke-static {v0, p0}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 133
    move-result p0

    .line 134
    .line 135
    if-eqz p0, :cond_6

    .line 136
    .line 137
    sget-object p0, Lcom/winemu/core/steam_agent/StatusLanguage;->CHINESE:Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 138
    return-object p0

    .line 139
    .line 140
    :cond_6
    sget-object p0, Lcom/winemu/core/steam_agent/StatusLanguage;->ENGLISH:Lcom/winemu/core/steam_agent/StatusLanguage;

    .line 141
    return-object p0
.end method

.method public final v2()Z
    .locals 0

    .line 1
    .line 2
    iget-boolean p0, p0, Lcom/xj/winemu/WineActivity;->M:Z

    .line 3
    return p0
.end method

.method public final w2()Lcom/xj/winemu/databinding/ActivityWineBinding;
    .locals 1

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->g:Lcom/xj/winemu/databinding/ActivityWineBinding;

    .line 3
    const/4 v0, 0x0

    .line 4
    .line 5
    if-eqz p0, :cond_1

    .line 6
    .line 7
    if-nez p0, :cond_0

    .line 8
    .line 9
    const-string p0, "binding"

    .line 10
    .line 11
    .line 12
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 13
    return-object v0

    .line 14
    :cond_0
    return-object p0

    .line 15
    :cond_1
    return-object v0
.end method

.method public final x2()V
    .locals 10

    .line 1
    .line 2
    iget-boolean v0, p0, Lcom/xj/winemu/WineActivity;->N:Z

    .line 3
    .line 4
    if-eqz v0, :cond_0

    .line 5
    return-void

    .line 6
    :cond_0
    const/4 v0, 0x1

    .line 7
    .line 8
    iput-boolean v0, p0, Lcom/xj/winemu/WineActivity;->N:Z

    .line 9
    .line 10
    .line 11
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->H2()V

    .line 12
    .line 13
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->D:Lkotlinx/coroutines/Job;

    .line 14
    const/4 v2, 0x0

    .line 15
    .line 16
    if-eqz v1, :cond_1

    .line 17
    .line 18
    .line 19
    invoke-static {v1, v2, v0, v2}, Lkotlinx/coroutines/Job$DefaultImpls;->b(Lkotlinx/coroutines/Job;Ljava/util/concurrent/CancellationException;ILjava/lang/Object;)V

    .line 20
    .line 21
    :cond_1
    iput-object v2, p0, Lcom/xj/winemu/WineActivity;->D:Lkotlinx/coroutines/Job;

    .line 22
    .line 23
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->C:Lcom/lxj/xpopup/impl/LoadingPopupView;

    .line 24
    .line 25
    if-eqz v1, :cond_2

    .line 26
    .line 27
    .line 28
    invoke-virtual {v1}, Lcom/lxj/xpopup/core/BasePopupView;->z()V

    .line 29
    .line 30
    :cond_2
    iput-object v2, p0, Lcom/xj/winemu/WineActivity;->C:Lcom/lxj/xpopup/impl/LoadingPopupView;

    .line 31
    .line 32
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->G:Lkotlinx/coroutines/Job;

    .line 33
    .line 34
    if-eqz v1, :cond_3

    .line 35
    .line 36
    .line 37
    invoke-static {v1, v2, v0, v2}, Lkotlinx/coroutines/Job$DefaultImpls;->b(Lkotlinx/coroutines/Job;Ljava/util/concurrent/CancellationException;ILjava/lang/Object;)V

    .line 38
    .line 39
    :cond_3
    iput-object v2, p0, Lcom/xj/winemu/WineActivity;->G:Lkotlinx/coroutines/Job;

    .line 40
    .line 41
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->H:Lkotlinx/coroutines/Job;

    .line 42
    .line 43
    if-eqz v1, :cond_4

    .line 44
    .line 45
    .line 46
    invoke-static {v1, v2, v0, v2}, Lkotlinx/coroutines/Job$DefaultImpls;->b(Lkotlinx/coroutines/Job;Ljava/util/concurrent/CancellationException;ILjava/lang/Object;)V

    .line 47
    .line 48
    :cond_4
    iput-object v2, p0, Lcom/xj/winemu/WineActivity;->H:Lkotlinx/coroutines/Job;

    .line 49
    .line 50
    sget-object v1, Lcom/xj/winemu/external/PcInGameDelegateManager;->a:Lcom/xj/winemu/external/PcInGameDelegateManager;

    .line 51
    .line 52
    .line 53
    invoke-virtual {v1}, Lcom/xj/winemu/external/PcInGameDelegateManager;->i()V

    .line 54
    .line 55
    sget-object v1, Lcom/xj/common/trace/collectors/SteamEventCollector;->a:Lcom/xj/common/trace/collectors/SteamEventCollector;

    .line 56
    .line 57
    .line 58
    invoke-virtual {p0}, Lcom/xj/winemu/WineActivity;->t2()Ljava/lang/String;

    .line 59
    move-result-object v2

    .line 60
    .line 61
    .line 62
    invoke-virtual {v1, v2}, Lcom/xj/common/trace/collectors/SteamEventCollector;->i(Ljava/lang/String;)V

    .line 63
    .line 64
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 65
    .line 66
    if-eqz v1, :cond_5

    .line 67
    .line 68
    .line 69
    invoke-virtual {v1, p0}, Lcom/winemu/core/gamepad/GamepadManager;->e1(Lcom/winemu/core/gamepad/GamepadEventListener;)V

    .line 70
    .line 71
    :cond_5
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->L:Lcom/xj/winemu/WineActivity$mDeviceConnectReceiver$1;

    .line 72
    .line 73
    .line 74
    invoke-virtual {p0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 75
    .line 76
    iget-object v1, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 77
    .line 78
    const-string v2, ""

    .line 79
    .line 80
    if-eqz v1, :cond_b

    .line 81
    .line 82
    iget-object v3, p0, Lcom/xj/winemu/WineActivity;->x:Lcom/xj/winemu/utils/WineGameUsageTracker;

    .line 83
    .line 84
    if-eqz v3, :cond_a

    .line 85
    .line 86
    if-eqz v1, :cond_7

    .line 87
    .line 88
    .line 89
    invoke-virtual {v1}, Lcom/xj/winemu/api/bean/WineActivityData;->b()Z

    .line 90
    move-result v1

    .line 91
    .line 92
    if-ne v1, v0, :cond_7

    .line 93
    .line 94
    iget-boolean v0, p0, Lcom/xj/winemu/WineActivity;->M:Z

    .line 95
    .line 96
    if-eqz v0, :cond_6

    .line 97
    .line 98
    .line 99
    invoke-virtual {v3}, Lcom/xj/winemu/utils/WineGameUsageTracker;->p()V

    .line 100
    goto :goto_0

    .line 101
    .line 102
    .line 103
    :cond_6
    invoke-virtual {v3}, Lcom/xj/winemu/utils/WineGameUsageTracker;->h()V

    .line 104
    goto :goto_0

    .line 105
    .line 106
    :cond_7
    iget-boolean v0, p0, Lcom/xj/winemu/WineActivity;->M:Z

    .line 107
    .line 108
    if-eqz v0, :cond_8

    .line 109
    .line 110
    .line 111
    invoke-virtual {v3}, Lcom/xj/winemu/utils/WineGameUsageTracker;->p()V

    .line 112
    .line 113
    :cond_8
    :goto_0
    sget-object v4, Lcom/xj/common/trace/PcEmuGameTraceEvent;->a:Lcom/xj/common/trace/PcEmuGameTraceEvent;

    .line 114
    .line 115
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 116
    .line 117
    .line 118
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 119
    .line 120
    .line 121
    invoke-virtual {v0}, Lcom/xj/winemu/api/bean/WineActivityData;->e()Ljava/lang/String;

    .line 122
    move-result-object v5

    .line 123
    .line 124
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 125
    .line 126
    .line 127
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 128
    .line 129
    .line 130
    invoke-virtual {v0}, Lcom/xj/winemu/api/bean/WineActivityData;->j()Ljava/lang/String;

    .line 131
    move-result-object v0

    .line 132
    .line 133
    if-nez v0, :cond_9

    .line 134
    move-object v6, v2

    .line 135
    goto :goto_1

    .line 136
    :cond_9
    move-object v6, v0

    .line 137
    .line 138
    .line 139
    :goto_1
    invoke-virtual {v3}, Lcom/xj/winemu/utils/WineGameUsageTracker;->k()J

    .line 140
    move-result-wide v7

    .line 141
    .line 142
    iget-object v0, p0, Lcom/xj/winemu/WineActivity;->u:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 143
    .line 144
    .line 145
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 146
    .line 147
    .line 148
    invoke-virtual {v0}, Lcom/xj/winemu/api/bean/WineActivityData;->d()Ljava/lang/String;

    .line 149
    move-result-object v9

    .line 150
    .line 151
    .line 152
    invoke-virtual/range {v4 .. v9}, Lcom/xj/common/trace/PcEmuGameTraceEvent;->b(Ljava/lang/String;Ljava/lang/String;JLjava/lang/String;)V

    .line 153
    .line 154
    .line 155
    invoke-virtual {v3}, Lcom/xj/winemu/utils/WineGameUsageTracker;->g()V

    .line 156
    .line 157
    :cond_a
    const-class v0, Lcom/xj/common/service/IUmengService;

    .line 158
    .line 159
    .line 160
    invoke-static {v0}, Lcom/therouter/TheRouter;->b(Ljava/lang/Class;)Ljava/lang/Object;

    .line 161
    move-result-object v0

    .line 162
    .line 163
    check-cast v0, Lcom/xj/common/service/IUmengService;

    .line 164
    .line 165
    if-eqz v0, :cond_b

    .line 166
    .line 167
    .line 168
    invoke-interface {v0}, Lcom/xj/common/service/IUmengService;->b()V

    .line 169
    .line 170
    :cond_b
    iget-object p0, p0, Lcom/xj/winemu/WineActivity;->t:Lcom/tencent/mmkv/MMKV;

    .line 171
    .line 172
    const-string v0, "curWineData"

    .line 173
    .line 174
    .line 175
    invoke-virtual {p0, v0, v2}, Lcom/tencent/mmkv/MMKV;->w(Ljava/lang/String;Ljava/lang/String;)Z

    .line 176
    return-void
.end method

.method public final y2()Z
    .locals 4

    .line 1
    .line 2
    sget-object v0, Lcom/xj/winemu/bean/GamePad;->Companion:Lcom/xj/winemu/bean/GamePad$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/winemu/bean/GamePad$Companion;->getSlotIndexIndices()Lkotlin/ranges/IntRange;

    .line 6
    move-result-object v0

    .line 7
    .line 8
    instance-of v1, v0, Ljava/util/Collection;

    .line 9
    const/4 v2, 0x0

    .line 10
    .line 11
    if-eqz v1, :cond_0

    .line 12
    move-object v1, v0

    .line 13
    .line 14
    check-cast v1, Ljava/util/Collection;

    .line 15
    .line 16
    .line 17
    invoke-interface {v1}, Ljava/util/Collection;->isEmpty()Z

    .line 18
    move-result v1

    .line 19
    .line 20
    if-eqz v1, :cond_0

    .line 21
    return v2

    .line 22
    .line 23
    .line 24
    :cond_0
    invoke-interface {v0}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 25
    move-result-object v0

    .line 26
    .line 27
    .line 28
    :cond_1
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    .line 29
    move-result v1

    .line 30
    .line 31
    if-eqz v1, :cond_4

    .line 32
    move-object v1, v0

    .line 33
    .line 34
    check-cast v1, Lkotlin/collections/IntIterator;

    .line 35
    .line 36
    .line 37
    invoke-virtual {v1}, Lkotlin/collections/IntIterator;->nextInt()I

    .line 38
    move-result v1

    .line 39
    .line 40
    iget-object v3, p0, Lcom/xj/winemu/WineActivity;->z:Lcom/winemu/core/gamepad/GamepadManager;

    .line 41
    .line 42
    if-eqz v3, :cond_1

    .line 43
    .line 44
    .line 45
    invoke-virtual {v3, v1}, Lcom/winemu/core/gamepad/GamepadManager;->J(I)Ljava/util/List;

    .line 46
    move-result-object v1

    .line 47
    .line 48
    if-eqz v1, :cond_1

    .line 49
    .line 50
    .line 51
    invoke-interface {v1}, Ljava/util/Collection;->isEmpty()Z

    .line 52
    move-result v3

    .line 53
    .line 54
    if-eqz v3, :cond_2

    .line 55
    goto :goto_0

    .line 56
    .line 57
    .line 58
    :cond_2
    invoke-interface {v1}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 59
    move-result-object v1

    .line 60
    .line 61
    .line 62
    :cond_3
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    .line 63
    move-result v3

    .line 64
    .line 65
    if-eqz v3, :cond_1

    .line 66
    .line 67
    .line 68
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 69
    move-result-object v3

    .line 70
    .line 71
    check-cast v3, Lcom/winemu/core/gamepad/GamepadDevice;

    .line 72
    .line 73
    instance-of v3, v3, Lcom/winemu/core/gamepad/GamepadDevice$Physical;

    .line 74
    .line 75
    if-eqz v3, :cond_3

    .line 76
    const/4 p0, 0x1

    .line 77
    return p0

    .line 78
    :cond_4
    return v2
.end method
