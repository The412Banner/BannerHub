.class public final Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;
.super Lcom/xj/common/view/focus/focus/app/FocusableActivity;
.source "r8-map-id-712846b76e3224c0169ce621759774aea144e14d75c3fb3c733f7f2b03c1bb19"

# interfaces
.implements Lcom/xj/common/view/focus/focus/FocusableRoot;


# annotations
.annotation runtime Lcom/therouter/router/Route;
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$Companion;,
        Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$WhenMappings;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/xj/common/view/focus/focus/app/FocusableActivity<",
        "Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;",
        "Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;",
        ">;",
        "Lcom/xj/common/view/focus/focus/FocusableRoot;"
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
.end annotation

.annotation build Lkotlin/jvm/internal/SourceDebugExtension;
.end annotation


# static fields
.field public static final q:Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$Companion;

.field public static r:Z

.field public static s:I

.field public static t:Z


# instance fields
.field public final g:Ljava/util/List;

.field public h:Lcom/xj/common/http/NetworkStatusDetector;

.field public i:Z

.field public j:Z

.field public final k:Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$mIDeviceStateChangeListener$1;

.field public final l:J

.field public m:Landroid/animation/ValueAnimator;

.field public n:Lkotlinx/coroutines/Job;

.field public o:J

.field public p:Landroidx/activity/result/ActivityResultLauncher;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    .line 2
    new-instance v0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$Companion;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    .line 6
    invoke-direct {v0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 7
    .line 8
    sput-object v0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->q:Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$Companion;

    .line 9
    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-direct {p0}, Lcom/xj/common/view/focus/focus/app/FocusableActivity;-><init>()V

    .line 4
    .line 5
    new-instance v0, Ljava/util/ArrayList;

    .line 6
    .line 7
    .line 8
    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 9
    .line 10
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->g:Ljava/util/List;

    .line 11
    .line 12
    new-instance v0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$mIDeviceStateChangeListener$1;

    .line 13
    .line 14
    .line 15
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$mIDeviceStateChangeListener$1;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 16
    .line 17
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->k:Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$mIDeviceStateChangeListener$1;

    .line 18
    .line 19
    const-wide/16 v0, 0x12c

    .line 20
    .line 21
    iput-wide v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->l:J

    .line 22
    return-void
.end method

.method public static final synthetic A2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0, p1}, Lcom/xj/base/base/activity/BaseVmActivity;->setThisTimeNotReCreate(Z)V

    .line 4
    return-void
.end method

.method private final A3()V
    .locals 9

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->n:Lkotlinx/coroutines/Job;

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
    .line 12
    :cond_0
    invoke-static {p0}, Landroidx/lifecycle/LifecycleOwnerKt;->a(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 13
    move-result-object v3

    .line 14
    .line 15
    new-instance v6, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$showDelayMenuFloatView$1;

    .line 16
    .line 17
    .line 18
    invoke-direct {v6, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$showDelayMenuFloatView$1;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/coroutines/Continuation;)V

    .line 19
    const/4 v7, 0x3

    .line 20
    const/4 v8, 0x0

    .line 21
    const/4 v4, 0x0

    .line 22
    const/4 v5, 0x0

    .line 23
    .line 24
    .line 25
    invoke-static/range {v3 .. v8}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 26
    move-result-object v0

    .line 27
    .line 28
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->n:Lkotlinx/coroutines/Job;

    .line 29
    return-void
.end method

.method public static final synthetic B2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/animation/ValueAnimator;)V
    .locals 0

    .line 1
    .line 2
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->m:Landroid/animation/ValueAnimator;

    .line 3
    return-void
.end method

.method public static final synthetic C2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-direct {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->A3()V

    .line 4
    return-void
.end method

.method public static final synthetic D2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;F)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F3(F)V

    .line 4
    return-void
.end method

.method public static final H3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/animation/ValueAnimator;)V
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
    .line 8
    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    .line 9
    move-result-object p1

    .line 10
    .line 11
    const-string v0, "null cannot be cast to non-null type kotlin.Float"

    .line 12
    .line 13
    .line 14
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 15
    .line 16
    check-cast p1, Ljava/lang/Float;

    .line 17
    .line 18
    .line 19
    invoke-virtual {p1}, Ljava/lang/Float;->floatValue()F

    .line 20
    move-result p1

    .line 21
    .line 22
    .line 23
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->I3(F)V

    .line 24
    return-void
.end method

.method public static synthetic I2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/content/Intent;JILjava/lang/Object;)V
    .locals 0

    .line 1
    .line 2
    and-int/lit8 p4, p4, 0x2

    .line 3
    .line 4
    if-eqz p4, :cond_0

    .line 5
    .line 6
    const-wide/16 p2, 0xbb8

    .line 7
    .line 8
    .line 9
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->H2(Landroid/content/Intent;J)V

    .line 10
    return-void
.end method

.method public static final J2(ZLjava/lang/String;)V
    .locals 31

    .line 1
    .line 2
    new-instance v0, Lorg/json/JSONObject;

    .line 3
    .line 4
    .line 5
    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 6
    .line 7
    const-string v1, "isShortcut"

    .line 8
    .line 9
    move/from16 v2, p0

    .line 10
    .line 11
    .line 12
    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 13
    .line 14
    const-string v1, "id"

    .line 15
    .line 16
    move-object/from16 v2, p1

    .line 17
    .line 18
    .line 19
    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 20
    .line 21
    .line 22
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    .line 23
    move-result-object v7

    .line 24
    .line 25
    const-string v0, "toString(...)"

    .line 26
    .line 27
    .line 28
    invoke-static {v7, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 29
    .line 30
    new-instance v2, Lcom/xj/launch/strategy/api/LauncherConfig;

    .line 31
    .line 32
    new-instance v4, Lcom/xj/common/service/bean/GameStartupParams;

    .line 33
    .line 34
    .line 35
    const v29, 0x3ffff

    .line 36
    .line 37
    const/16 v30, 0x0

    .line 38
    const/4 v9, 0x0

    .line 39
    const/4 v10, 0x0

    .line 40
    const/4 v11, 0x0

    .line 41
    const/4 v12, 0x0

    .line 42
    const/4 v13, 0x0

    .line 43
    const/4 v14, 0x0

    .line 44
    const/4 v15, 0x0

    .line 45
    .line 46
    const/16 v16, 0x0

    .line 47
    .line 48
    const/16 v17, 0x0

    .line 49
    .line 50
    const/16 v18, 0x0

    .line 51
    .line 52
    const/16 v19, 0x0

    .line 53
    .line 54
    const/16 v20, 0x0

    .line 55
    .line 56
    const/16 v21, 0x0

    .line 57
    .line 58
    const/16 v22, 0x0

    .line 59
    .line 60
    const/16 v23, 0x0

    .line 61
    .line 62
    const-wide/16 v24, 0x0

    .line 63
    .line 64
    const-wide/16 v26, 0x0

    .line 65
    .line 66
    const/16 v28, 0x0

    .line 67
    move-object v8, v4

    .line 68
    .line 69
    .line 70
    invoke-direct/range {v8 .. v30}, Lcom/xj/common/service/bean/GameStartupParams;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILcom/xj/common/service/bean/StartExt;Ljava/lang/Integer;Ljava/lang/Integer;ZZILjava/lang/String;Ljava/lang/String;Ljava/lang/String;JJIILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 71
    .line 72
    const/16 v15, 0xfe0

    .line 73
    .line 74
    const/16 v3, 0xc

    .line 75
    .line 76
    const-string v5, "12"

    .line 77
    .line 78
    const-string v6, ""

    .line 79
    const/4 v8, 0x0

    .line 80
    const/4 v13, 0x0

    .line 81
    .line 82
    .line 83
    invoke-direct/range {v2 .. v16}, Lcom/xj/launch/strategy/api/LauncherConfig;-><init>(ILcom/xj/common/service/bean/GameStartupParams;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Ljava/util/List;Lcom/xj/common/data/gameinfo/LauncherGameInfo;Lcom/xj/common/bean/SteamGamePriceEntity;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function0;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 84
    .line 85
    sget-object v0, Lcom/xj/landscape/launcher/launcher/AppLauncher;->a:Lcom/xj/landscape/launcher/launcher/AppLauncher;

    .line 86
    .line 87
    .line 88
    invoke-virtual {v0, v2}, Lcom/xj/landscape/launcher/launcher/AppLauncher;->k(Lcom/xj/launch/strategy/api/LauncherConfig;)Lcom/xj/launch/strategy/api/LaunchResult;

    .line 89
    return-void
.end method

.method private final L2()V
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/common/view/floatview/MenuFloatView;->o:Lcom/xj/common/view/floatview/MenuFloatView$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0, p0}, Lcom/xj/common/view/floatview/MenuFloatView$Companion;->c(Landroid/app/Activity;)Lcom/xj/common/view/floatview/MenuFloatView;

    .line 6
    move-result-object p0

    .line 7
    const/4 v0, 0x1

    .line 8
    .line 9
    .line 10
    invoke-virtual {p0, v0}, Lcom/xj/common/view/floatview/MenuFloatView;->t(Z)V

    .line 11
    return-void
.end method

.method public static final M2(Ljava/lang/Boolean;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 4
    .line 5
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 6
    return-object p0
.end method

.method public static synthetic N1(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lcom/xj/lib/shape/view/ShapeTextView;Lcom/xj/landscape/launcher/ui/main/TabItemData;I)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2, p3}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->Q2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lcom/xj/lib/shape/view/ShapeTextView;Lcom/xj/landscape/launcher/ui/main/TabItemData;I)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final N2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/Pair;)Lkotlin/Unit;
    .locals 4

    .line 1
    .line 2
    .line 3
    invoke-virtual {p1}, Lkotlin/Pair;->component1()Ljava/lang/Object;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    check-cast v0, Ljava/lang/Number;

    .line 7
    .line 8
    .line 9
    invoke-virtual {v0}, Ljava/lang/Number;->intValue()I

    .line 10
    move-result v0

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1}, Lkotlin/Pair;->component2()Ljava/lang/Object;

    .line 14
    move-result-object p1

    .line 15
    .line 16
    check-cast p1, Ljava/lang/Boolean;

    .line 17
    .line 18
    .line 19
    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    .line 20
    move-result p1

    .line 21
    .line 22
    .line 23
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 24
    move-result-object v1

    .line 25
    .line 26
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 27
    .line 28
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 29
    .line 30
    .line 31
    invoke-virtual {v1, v0}, Lcom/xj/common/view/focus/focus/view/FocusTabLayout;->setSelectedTab(I)V

    .line 32
    .line 33
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->g:Ljava/util/List;

    .line 34
    .line 35
    .line 36
    invoke-static {v1, v0}, Lkotlin/collections/CollectionsKt;->v0(Ljava/util/List;I)Ljava/lang/Object;

    .line 37
    move-result-object v1

    .line 38
    .line 39
    check-cast v1, Lcom/xj/landscape/launcher/ui/main/TabItemData;

    .line 40
    .line 41
    if-eqz v1, :cond_0

    .line 42
    .line 43
    .line 44
    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/main/TabItemData;->c()Ljava/lang/String;

    .line 45
    move-result-object v1

    .line 46
    goto :goto_0

    .line 47
    :cond_0
    const/4 v1, 0x0

    .line 48
    .line 49
    :goto_0
    sget v2, Lcom/xj/language/R$string;->llauncher_play_in_second:I

    .line 50
    .line 51
    .line 52
    invoke-static {v2}, Lcom/xj/winemu/ext/IntExtKt;->a(I)Ljava/lang/String;

    .line 53
    move-result-object v2

    .line 54
    .line 55
    .line 56
    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 57
    move-result v1

    .line 58
    .line 59
    .line 60
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 61
    move-result-object v2

    .line 62
    .line 63
    check-cast v2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 64
    .line 65
    iget-object v2, v2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rightUserAvatarView:Lcom/xj/user/view/UserAvatarView;

    .line 66
    .line 67
    const-string v3, "rightUserAvatarView"

    .line 68
    .line 69
    .line 70
    invoke-static {v2, v3}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 71
    .line 72
    if-eqz v1, :cond_1

    .line 73
    const/4 v1, 0x0

    .line 74
    goto :goto_1

    .line 75
    .line 76
    :cond_1
    const/16 v1, 0x8

    .line 77
    .line 78
    .line 79
    :goto_1
    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V

    .line 80
    .line 81
    .line 82
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 83
    move-result-object v1

    .line 84
    .line 85
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 86
    .line 87
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rightUserAvatarView:Lcom/xj/user/view/UserAvatarView;

    .line 88
    .line 89
    sget-object v2, Lcom/xj/common/user/UserManager;->INSTANCE:Lcom/xj/common/user/UserManager;

    .line 90
    .line 91
    .line 92
    invoke-virtual {v2}, Lcom/xj/common/user/UserManager;->getAvatar()Ljava/lang/String;

    .line 93
    move-result-object v2

    .line 94
    .line 95
    sget-object v3, Lcom/xj/landscape/launcher/utils/AvatarBgUtils;->a:Lcom/xj/landscape/launcher/utils/AvatarBgUtils;

    .line 96
    .line 97
    .line 98
    invoke-virtual {v3}, Lcom/xj/landscape/launcher/utils/AvatarBgUtils;->c()Ljava/lang/String;

    .line 99
    move-result-object v3

    .line 100
    .line 101
    .line 102
    invoke-virtual {v1, v2, v3}, Lcom/xj/user/view/UserAvatarView;->v(Ljava/lang/String;Ljava/lang/String;)V

    .line 103
    .line 104
    .line 105
    invoke-virtual {p0, v0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->k3(IZ)V

    .line 106
    .line 107
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 108
    return-object p0
.end method

.method public static synthetic O1(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->y3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final O2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lcom/blankj/utilcode/util/NetworkUtils$NetworkType;)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    if-nez p1, :cond_0

    .line 3
    const/4 p1, -0x1

    .line 4
    goto :goto_0

    .line 5
    .line 6
    :cond_0
    sget-object v0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$WhenMappings;->a:[I

    .line 7
    .line 8
    .line 9
    invoke-virtual {p1}, Ljava/lang/Enum;->ordinal()I

    .line 10
    move-result p1

    .line 11
    .line 12
    aget p1, v0, p1

    .line 13
    .line 14
    .line 15
    :goto_0
    packed-switch p1, :pswitch_data_0

    .line 16
    .line 17
    new-instance p0, Lkotlin/NoWhenBranchMatchedException;

    .line 18
    .line 19
    .line 20
    invoke-direct {p0}, Lkotlin/NoWhenBranchMatchedException;-><init>()V

    .line 21
    throw p0

    .line 22
    .line 23
    .line 24
    :pswitch_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 25
    move-result-object p0

    .line 26
    .line 27
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 28
    .line 29
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSignalLevel:Landroid/widget/ImageView;

    .line 30
    .line 31
    sget p1, Lcom/xj/common/R$drawable;->llanuncher_icon_main_white_no_network:I

    .line 32
    .line 33
    .line 34
    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setImageResource(I)V

    .line 35
    goto :goto_1

    .line 36
    .line 37
    .line 38
    :pswitch_1
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 39
    move-result-object p0

    .line 40
    .line 41
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 42
    .line 43
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSignalLevel:Landroid/widget/ImageView;

    .line 44
    .line 45
    sget p1, Lcom/xj/common/R$drawable;->llanuncher_icon_main_white_signal:I

    .line 46
    .line 47
    .line 48
    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setImageResource(I)V

    .line 49
    goto :goto_1

    .line 50
    .line 51
    .line 52
    :pswitch_2
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 53
    move-result-object p0

    .line 54
    .line 55
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 56
    .line 57
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSignalLevel:Landroid/widget/ImageView;

    .line 58
    .line 59
    sget p1, Lcom/xj/common/R$drawable;->llanuncher_icon_main_white_wifi:I

    .line 60
    .line 61
    .line 62
    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setImageResource(I)V

    .line 63
    .line 64
    :goto_1
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 65
    return-object p0

    .line 66
    nop

    .line 67
    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_2
        :pswitch_2
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static synthetic P1(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2, p3}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->P2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final P2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    const-string p2, "key"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, p2}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    const-string p2, "tencentOperatesDataHandleType"

    .line 8
    .line 9
    .line 10
    invoke-static {p1, p2}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 11
    move-result p1

    .line 12
    .line 13
    if-eqz p1, :cond_0

    .line 14
    .line 15
    iget-boolean p1, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->j:Z

    .line 16
    .line 17
    if-nez p1, :cond_0

    .line 18
    const/4 p1, 0x1

    .line 19
    .line 20
    iput-boolean p1, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->j:Z

    .line 21
    .line 22
    sget-object p1, Lcom/xj/landscape/launcher/net/tencent/TencentStatisticsHelper;->a:Lcom/xj/landscape/launcher/net/tencent/TencentStatisticsHelper;

    .line 23
    .line 24
    .line 25
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    .line 26
    move-result-object p0

    .line 27
    .line 28
    new-instance p2, Ljava/lang/StringBuilder;

    .line 29
    .line 30
    .line 31
    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    .line 32
    .line 33
    const-string p3, "pkg#"

    .line 34
    .line 35
    .line 36
    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 37
    .line 38
    .line 39
    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 40
    .line 41
    .line 42
    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 43
    move-result-object p0

    .line 44
    .line 45
    const-string p2, "app_launcher"

    .line 46
    .line 47
    .line 48
    invoke-virtual {p1, p2, p0}, Lcom/xj/landscape/launcher/net/tencent/TencentStatisticsHelper;->h(Ljava/lang/String;Ljava/lang/String;)V

    .line 49
    .line 50
    :cond_0
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 51
    return-object p0
.end method

.method public static synthetic Q1(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->T2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final Q2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lcom/xj/lib/shape/view/ShapeTextView;Lcom/xj/landscape/launcher/ui/main/TabItemData;I)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    const-string v0, "tabView"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    const-string p1, "fragment"

    .line 8
    .line 9
    .line 10
    invoke-static {p2, p1}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 11
    .line 12
    .line 13
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMViewModel()Lcom/xj/base/base/viewmodel/BaseViewModel;

    .line 14
    move-result-object p0

    .line 15
    .line 16
    check-cast p0, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;

    .line 17
    const/4 p1, 0x2

    .line 18
    const/4 p2, 0x0

    .line 19
    const/4 v0, 0x0

    .line 20
    .line 21
    .line 22
    invoke-static {p0, p3, v0, p1, p2}, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;->p(Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;IZILjava/lang/Object;)V

    .line 23
    .line 24
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 25
    return-object p0
.end method

.method public static synthetic R1(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lcom/blankj/utilcode/util/NetworkUtils$NetworkType;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->O2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lcom/blankj/utilcode/util/NetworkUtils$NetworkType;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final R2()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/ui/main/me/MyFragment;->y:Lcom/xj/landscape/launcher/ui/main/me/MyFragment$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/main/me/MyFragment$Companion;->a()Lcom/xj/landscape/launcher/ui/main/me/MyFragment;

    .line 6
    move-result-object v0

    .line 7
    return-object v0
.end method

.method public static synthetic S1()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->R2()Landroidx/fragment/app/Fragment;

    .line 4
    move-result-object v0

    .line 5
    return-object v0
.end method

.method public static final S2()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/ui/main/cloudplay/CloudPlayFragment;->p:Lcom/xj/landscape/launcher/ui/main/cloudplay/CloudPlayFragment$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/main/cloudplay/CloudPlayFragment$Companion;->a()Lcom/xj/landscape/launcher/ui/main/cloudplay/CloudPlayFragment;

    .line 6
    move-result-object v0

    .line 7
    return-object v0
.end method

.method public static synthetic T1(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Ljava/util/List;ZZ)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2, p3}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->e3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Ljava/util/List;ZZ)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final T2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;)Lkotlin/Unit;
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
    .line 8
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->n3()V

    .line 9
    .line 10
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 11
    return-object p0
.end method

.method public static synthetic U1(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->X2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final U2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 6

    .line 1
    .line 2
    const-string p1, "ivSearch"

    .line 3
    .line 4
    if-eqz p2, :cond_0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 8
    move-result-object p0

    .line 9
    .line 10
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 11
    .line 12
    iget-object v0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSearch:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 13
    .line 14
    .line 15
    invoke-static {v0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 16
    const/4 p0, 0x6

    .line 17
    .line 18
    .line 19
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 20
    move-result-object p0

    .line 21
    .line 22
    .line 23
    invoke-static {p0}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 24
    move-result-object p0

    .line 25
    .line 26
    .line 27
    invoke-virtual {p0}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 28
    move-result v1

    .line 29
    const/4 v4, 0x6

    .line 30
    const/4 v5, 0x0

    .line 31
    const/4 v2, 0x0

    .line 32
    const/4 v3, 0x0

    .line 33
    .line 34
    .line 35
    invoke-static/range {v0 .. v5}, Lcom/xj/common/utils/FocusableBorderExtKt;->g(Landroid/view/View;IIIILjava/lang/Object;)V

    .line 36
    return-void

    .line 37
    .line 38
    .line 39
    :cond_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 40
    move-result-object p0

    .line 41
    .line 42
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 43
    .line 44
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSearch:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 45
    .line 46
    .line 47
    invoke-static {p0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 48
    .line 49
    .line 50
    invoke-static {p0}, Lcom/xj/common/utils/FocusableBorderExtKt;->b(Landroid/view/View;)V

    .line 51
    return-void
.end method

.method public static synthetic V1(Lcom/xj/landscape/launcher/ui/main/viewholders/FixedCardView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->u3(Lcom/xj/landscape/launcher/ui/main/viewholders/FixedCardView;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final V2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;)Lkotlin/Unit;
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
    .line 8
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->l3()V

    .line 9
    .line 10
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 11
    return-object p0
.end method

.method public static synthetic W1()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->i3()Landroidx/fragment/app/Fragment;

    .line 4
    move-result-object v0

    .line 5
    return-object v0
.end method

.method public static final W2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 6

    .line 1
    .line 2
    const-string p1, "flOpenNav"

    .line 3
    .line 4
    if-eqz p2, :cond_0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 8
    move-result-object p2

    .line 9
    .line 10
    check-cast p2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 11
    .line 12
    iget-object v0, p2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->flOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 13
    .line 14
    .line 15
    invoke-static {v0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 16
    const/4 p1, 0x6

    .line 17
    .line 18
    .line 19
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 20
    move-result-object p1

    .line 21
    .line 22
    .line 23
    invoke-static {p1}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 24
    move-result-object p1

    .line 25
    .line 26
    .line 27
    invoke-virtual {p1}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 28
    move-result v1

    .line 29
    const/4 v4, 0x6

    .line 30
    const/4 v5, 0x0

    .line 31
    const/4 v2, 0x0

    .line 32
    const/4 v3, 0x0

    .line 33
    .line 34
    .line 35
    invoke-static/range {v0 .. v5}, Lcom/xj/common/utils/FocusableBorderExtKt;->g(Landroid/view/View;IIIILjava/lang/Object;)V

    .line 36
    .line 37
    .line 38
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 39
    move-result-object p0

    .line 40
    .line 41
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 42
    .line 43
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 44
    .line 45
    sget p1, Lcom/xj/landscape/launcher/R$drawable;->llauncher_ic_launcher_main_nav_focused:I

    .line 46
    .line 47
    .line 48
    invoke-virtual {p0, p1}, Landroidx/appcompat/widget/AppCompatImageView;->setImageResource(I)V

    .line 49
    return-void

    .line 50
    .line 51
    .line 52
    :cond_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 53
    move-result-object p2

    .line 54
    .line 55
    check-cast p2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 56
    .line 57
    iget-object p2, p2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->flOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 58
    .line 59
    .line 60
    invoke-static {p2, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 61
    .line 62
    .line 63
    invoke-static {p2}, Lcom/xj/common/utils/FocusableBorderExtKt;->b(Landroid/view/View;)V

    .line 64
    .line 65
    .line 66
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 67
    move-result-object p0

    .line 68
    .line 69
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 70
    .line 71
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 72
    .line 73
    sget p1, Lcom/xj/landscape/launcher/R$drawable;->llauncher_ic_launcher_main_nav_normal:I

    .line 74
    .line 75
    .line 76
    invoke-virtual {p0, p1}, Landroidx/appcompat/widget/AppCompatImageView;->setImageResource(I)V

    .line 77
    return-void
.end method

.method public static synthetic X1(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/animation/ValueAnimator;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->H3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/animation/ValueAnimator;)V

    .line 4
    return-void
.end method

.method public static final X2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;)Lkotlin/Unit;
    .locals 6

    .line 1
    .line 2
    const-string v0, "it"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    sget-object p1, Lcom/xj/common/config/AppConfig;->a:Lcom/xj/common/config/AppConfig$Companion;

    .line 8
    .line 9
    .line 10
    invoke-virtual {p1}, Lcom/xj/common/config/AppConfig$Companion;->a()Z

    .line 11
    move-result p1

    .line 12
    .line 13
    if-nez p1, :cond_0

    .line 14
    .line 15
    sget-object v0, Lcom/xj/common/utils/ActivityBlurBgUtils;->a:Lcom/xj/common/utils/ActivityBlurBgUtils;

    .line 16
    const/4 v4, 0x4

    .line 17
    const/4 v5, 0x0

    .line 18
    .line 19
    const-class v2, Lcom/xj/landscape/launcher/ui/device/DeviceManagerActivity;

    .line 20
    const/4 v3, 0x0

    .line 21
    move-object v1, p0

    .line 22
    .line 23
    .line 24
    invoke-static/range {v0 .. v5}, Lcom/xj/common/utils/ActivityBlurBgUtils;->f(Lcom/xj/common/utils/ActivityBlurBgUtils;Landroid/content/Context;Ljava/lang/Class;Landroid/os/Bundle;ILjava/lang/Object;)V

    .line 25
    .line 26
    :cond_0
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 27
    return-object p0
.end method

.method public static synthetic Y1(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->b3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V

    .line 4
    return-void
.end method

.method public static final Y2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 6

    .line 1
    .line 2
    const-string p1, "ivDeviceOnline"

    .line 3
    .line 4
    if-eqz p2, :cond_0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 8
    move-result-object p0

    .line 9
    .line 10
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 11
    .line 12
    iget-object v0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDeviceOnline:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 13
    .line 14
    .line 15
    invoke-static {v0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 16
    const/4 p0, 0x6

    .line 17
    .line 18
    .line 19
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 20
    move-result-object p0

    .line 21
    .line 22
    .line 23
    invoke-static {p0}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 24
    move-result-object p0

    .line 25
    .line 26
    .line 27
    invoke-virtual {p0}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 28
    move-result v1

    .line 29
    const/4 v4, 0x6

    .line 30
    const/4 v5, 0x0

    .line 31
    const/4 v2, 0x0

    .line 32
    const/4 v3, 0x0

    .line 33
    .line 34
    .line 35
    invoke-static/range {v0 .. v5}, Lcom/xj/common/utils/FocusableBorderExtKt;->g(Landroid/view/View;IIIILjava/lang/Object;)V

    .line 36
    return-void

    .line 37
    .line 38
    .line 39
    :cond_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 40
    move-result-object p0

    .line 41
    .line 42
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 43
    .line 44
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDeviceOnline:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 45
    .line 46
    .line 47
    invoke-static {p0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 48
    .line 49
    .line 50
    invoke-static {p0}, Lcom/xj/common/utils/FocusableBorderExtKt;->b(Landroid/view/View;)V

    .line 51
    return-void
.end method

.method public static synthetic Z1(ZLjava/lang/String;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->J2(ZLjava/lang/String;)V

    .line 4
    return-void
.end method

.method public static final Z2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;I)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    if-eqz p1, :cond_1

    .line 3
    .line 4
    .line 5
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 6
    move-result-object p1

    .line 7
    .line 8
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 9
    .line 10
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDownloading:Lcom/xj/common/view/DownloadProgressIconView;

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/view/FocusableImageView;->p()Z

    .line 14
    move-result p1

    .line 15
    .line 16
    if-eqz p1, :cond_1

    .line 17
    .line 18
    .line 19
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 20
    move-result-object p1

    .line 21
    .line 22
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 23
    .line 24
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSearch:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 25
    .line 26
    const-string v0, "ivSearch"

    .line 27
    .line 28
    .line 29
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 30
    .line 31
    .line 32
    invoke-virtual {p1}, Landroid/view/View;->getVisibility()I

    .line 33
    move-result p1

    .line 34
    .line 35
    if-nez p1, :cond_0

    .line 36
    .line 37
    .line 38
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 39
    move-result-object p1

    .line 40
    .line 41
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 42
    .line 43
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSearch:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 44
    .line 45
    .line 46
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/view/FocusableImageView;->y()V

    .line 47
    .line 48
    .line 49
    :cond_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 50
    move-result-object p0

    .line 51
    .line 52
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 53
    .line 54
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDownloading:Lcom/xj/common/view/DownloadProgressIconView;

    .line 55
    .line 56
    const-string p1, "ivDownloading"

    .line 57
    .line 58
    .line 59
    invoke-static {p0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 60
    .line 61
    .line 62
    invoke-static {p0}, Lcom/xj/common/utils/FocusableBorderExtKt;->b(Landroid/view/View;)V

    .line 63
    .line 64
    :cond_1
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 65
    return-object p0
.end method

.method public static synthetic a2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->a3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V

    .line 4
    return-void
.end method

.method public static final a3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 6

    .line 1
    .line 2
    const-string p1, "ivDownloading"

    .line 3
    .line 4
    if-eqz p2, :cond_0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 8
    move-result-object p0

    .line 9
    .line 10
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 11
    .line 12
    iget-object v0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDownloading:Lcom/xj/common/view/DownloadProgressIconView;

    .line 13
    .line 14
    .line 15
    invoke-static {v0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 16
    const/4 p0, 0x6

    .line 17
    .line 18
    .line 19
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 20
    move-result-object p0

    .line 21
    .line 22
    .line 23
    invoke-static {p0}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 24
    move-result-object p0

    .line 25
    .line 26
    .line 27
    invoke-virtual {p0}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 28
    move-result v1

    .line 29
    const/4 v4, 0x6

    .line 30
    const/4 v5, 0x0

    .line 31
    const/4 v2, 0x0

    .line 32
    const/4 v3, 0x0

    .line 33
    .line 34
    .line 35
    invoke-static/range {v0 .. v5}, Lcom/xj/common/utils/FocusableBorderExtKt;->g(Landroid/view/View;IIIILjava/lang/Object;)V

    .line 36
    return-void

    .line 37
    .line 38
    .line 39
    :cond_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 40
    move-result-object p0

    .line 41
    .line 42
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 43
    .line 44
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDownloading:Lcom/xj/common/view/DownloadProgressIconView;

    .line 45
    .line 46
    .line 47
    invoke-static {p0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 48
    .line 49
    .line 50
    invoke-static {p0}, Lcom/xj/common/utils/FocusableBorderExtKt;->b(Landroid/view/View;)V

    .line 51
    return-void
.end method

.method public static synthetic b2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->W2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V

    .line 4
    return-void
.end method

.method public static final b3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 6

    .line 1
    .line 2
    const-string p1, "rightUserAvatarView"

    .line 3
    .line 4
    if-eqz p2, :cond_0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 8
    move-result-object p0

    .line 9
    .line 10
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 11
    .line 12
    iget-object v0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rightUserAvatarView:Lcom/xj/user/view/UserAvatarView;

    .line 13
    .line 14
    .line 15
    invoke-static {v0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 16
    .line 17
    const/16 p0, 0x1e

    .line 18
    .line 19
    .line 20
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 21
    move-result-object p0

    .line 22
    .line 23
    .line 24
    invoke-static {p0}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 25
    move-result-object p0

    .line 26
    .line 27
    .line 28
    invoke-virtual {p0}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 29
    move-result v1

    .line 30
    const/4 v4, 0x6

    .line 31
    const/4 v5, 0x0

    .line 32
    const/4 v2, 0x0

    .line 33
    const/4 v3, 0x0

    .line 34
    .line 35
    .line 36
    invoke-static/range {v0 .. v5}, Lcom/xj/common/utils/FocusableBorderExtKt;->g(Landroid/view/View;IIIILjava/lang/Object;)V

    .line 37
    return-void

    .line 38
    .line 39
    .line 40
    :cond_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 41
    move-result-object p0

    .line 42
    .line 43
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 44
    .line 45
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rightUserAvatarView:Lcom/xj/user/view/UserAvatarView;

    .line 46
    .line 47
    .line 48
    invoke-static {p0, p1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 49
    .line 50
    .line 51
    invoke-static {p0}, Lcom/xj/common/utils/FocusableBorderExtKt;->b(Landroid/view/View;)V

    .line 52
    return-void
.end method

.method public static synthetic c2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;I)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->Z2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;I)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final c3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 1

    .line 1
    const/4 p1, 0x2

    .line 2
    const/4 v0, 0x0

    .line 3
    .line 4
    if-eqz p2, :cond_0

    .line 5
    .line 6
    new-instance p0, Lcom/xj/landscape/launcher/event/ToggleTabEvent;

    .line 7
    const/4 p2, 0x1

    .line 8
    .line 9
    .line 10
    invoke-direct {p0, p2}, Lcom/xj/landscape/launcher/event/ToggleTabEvent;-><init>(I)V

    .line 11
    .line 12
    .line 13
    invoke-static {p0, v0, p1, v0}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 14
    return-void

    .line 15
    .line 16
    .line 17
    :cond_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 18
    move-result-object p0

    .line 19
    .line 20
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 21
    .line 22
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 23
    .line 24
    .line 25
    invoke-virtual {p0}, Lcom/xj/common/view/focus/focus/view/FocusTabLayout;->getSelectedTab()I

    .line 26
    move-result p0

    .line 27
    .line 28
    if-ne p0, p1, :cond_1

    .line 29
    .line 30
    new-instance p0, Lcom/xj/landscape/launcher/event/ToggleTabEvent;

    .line 31
    .line 32
    .line 33
    invoke-direct {p0, p1}, Lcom/xj/landscape/launcher/event/ToggleTabEvent;-><init>(I)V

    .line 34
    .line 35
    .line 36
    invoke-static {p0, v0, p1, v0}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 37
    :cond_1
    return-void
.end method

.method public static synthetic d2()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->g3()Landroidx/fragment/app/Fragment;

    .line 4
    move-result-object v0

    .line 5
    return-object v0
.end method

.method public static final d3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;)Lkotlin/Unit;
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
    new-instance p1, Landroid/content/Intent;

    .line 8
    .line 9
    const-class v0, Lcom/xj/landscape/launcher/ui/usercenter/UserCenterActivity;

    .line 10
    .line 11
    .line 12
    invoke-direct {p1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 13
    .line 14
    .line 15
    invoke-virtual {p0, p1}, Lcom/xj/base/base/activity/BaseVmActivity;->startActivity(Landroid/content/Intent;)V

    .line 16
    .line 17
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 18
    return-object p0
.end method

.method public static synthetic e2()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->h3()Landroidx/fragment/app/Fragment;

    .line 4
    move-result-object v0

    .line 5
    return-object v0
.end method

.method public static final e3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Ljava/util/List;ZZ)Lkotlin/Unit;
    .locals 2

    .line 1
    .line 2
    const-string p3, "<unused var>"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, p3}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    sget-object p1, Lcom/xj/bussiness/devicemanagement/utils/HandleHelper;->a:Lcom/xj/bussiness/devicemanagement/utils/HandleHelper;

    .line 8
    .line 9
    .line 10
    invoke-virtual {p1, p0}, Lcom/xj/bussiness/devicemanagement/utils/HandleHelper;->c(Landroid/content/Context;)Z

    .line 11
    move-result p1

    .line 12
    .line 13
    sget-object p3, Lcom/xj/common/utils/PermissionUtils;->a:Lcom/xj/common/utils/PermissionUtils;

    .line 14
    .line 15
    const-string v0, "DeviceManagementService"

    .line 16
    .line 17
    .line 18
    invoke-virtual {p3, v0}, Lcom/xj/common/utils/PermissionUtils;->z(Ljava/lang/String;)Z

    .line 19
    move-result p3

    .line 20
    .line 21
    new-instance v0, Ljava/lang/StringBuilder;

    .line 22
    .line 23
    .line 24
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 25
    .line 26
    const-string v1, "notification enable:"

    .line 27
    .line 28
    .line 29
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 30
    .line 31
    .line 32
    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 33
    .line 34
    const-string v1, " ,isAllGranted:"

    .line 35
    .line 36
    .line 37
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 38
    .line 39
    .line 40
    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 41
    .line 42
    const-string v1, " ,isConnectDevice:"

    .line 43
    .line 44
    .line 45
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 46
    .line 47
    .line 48
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 49
    .line 50
    .line 51
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 52
    move-result-object v0

    .line 53
    .line 54
    const-string v1, "LandscapeLauncherMainActivity"

    .line 55
    .line 56
    .line 57
    invoke-static {v1, v0}, Lcom/xj/common/utils/XjLog;->h(Ljava/lang/String;Ljava/lang/String;)V

    .line 58
    .line 59
    if-eqz p1, :cond_0

    .line 60
    .line 61
    if-eqz p3, :cond_0

    .line 62
    .line 63
    if-eqz p2, :cond_0

    .line 64
    .line 65
    sget-object p1, Lcom/xj/landscape/launcher/devicemanagement/DeviceManagementService;->o:Lcom/xj/landscape/launcher/devicemanagement/DeviceManagementService$Companion;

    .line 66
    .line 67
    const-string p2, "hasConnectedDevice check"

    .line 68
    .line 69
    .line 70
    invoke-virtual {p1, p0, p2}, Lcom/xj/landscape/launcher/devicemanagement/DeviceManagementService$Companion;->c(Landroid/content/Context;Ljava/lang/String;)V

    .line 71
    .line 72
    :cond_0
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 73
    return-object p0
.end method

.method public static synthetic f2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->U2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V

    .line 4
    return-void
.end method

.method public static final f3()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/ui/main/me/MyFragment;->y:Lcom/xj/landscape/launcher/ui/main/me/MyFragment$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/main/me/MyFragment$Companion;->a()Lcom/xj/landscape/launcher/ui/main/me/MyFragment;

    .line 6
    move-result-object v0

    .line 7
    return-object v0
.end method

.method public static synthetic g2()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->f3()Landroidx/fragment/app/Fragment;

    .line 4
    move-result-object v0

    .line 5
    return-object v0
.end method

.method public static final g3()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/ui/main/cloudplay/CloudPlayFragment;->p:Lcom/xj/landscape/launcher/ui/main/cloudplay/CloudPlayFragment$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/main/cloudplay/CloudPlayFragment$Companion;->a()Lcom/xj/landscape/launcher/ui/main/cloudplay/CloudPlayFragment;

    .line 6
    move-result-object v0

    .line 7
    return-object v0
.end method

.method public static synthetic h2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Ljava/io/File;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->q3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Ljava/io/File;)V

    .line 4
    return-void
.end method

.method public static final h3()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/ui/main/explore/ExploreFragment;->q:Lcom/xj/landscape/launcher/ui/main/explore/ExploreFragment$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/main/explore/ExploreFragment$Companion;->a()Lcom/xj/landscape/launcher/ui/main/explore/ExploreFragment;

    .line 6
    move-result-object v0

    .line 7
    return-object v0
.end method

.method public static synthetic i2(Ljava/lang/Boolean;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->M2(Ljava/lang/Boolean;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final i3()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/ui/main/platform/PlatformFragment;->r:Lcom/xj/landscape/launcher/ui/main/platform/PlatformFragment$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/main/platform/PlatformFragment$Companion;->a()Lcom/xj/landscape/launcher/ui/main/platform/PlatformFragment;

    .line 6
    move-result-object v0

    .line 7
    return-object v0
.end method

.method public static synthetic j2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->Y2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V

    .line 4
    return-void
.end method

.method public static synthetic k2()Landroidx/fragment/app/Fragment;
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->S2()Landroidx/fragment/app/Fragment;

    .line 4
    move-result-object v0

    .line 5
    return-object v0
.end method

.method public static synthetic l2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/Pair;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->N2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/Pair;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic m2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->v3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic n2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->d3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic o2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->c3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/view/View;Z)V

    .line 4
    return-void
.end method

.method public static synthetic p2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->z3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic q2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->w3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final q3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Ljava/io/File;)V
    .locals 4

    .line 1
    .line 2
    sget-object v0, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 3
    .line 4
    if-eqz p1, :cond_0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    .line 8
    move-result-object v1

    .line 9
    goto :goto_0

    .line 10
    :cond_0
    const/4 v1, 0x0

    .line 11
    .line 12
    :goto_0
    new-instance v2, Ljava/lang/StringBuilder;

    .line 13
    .line 14
    .line 15
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 16
    .line 17
    const-string v3, "PCEmulatorInfoView selectFileLauncher ,selected -> "

    .line 18
    .line 19
    .line 20
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 21
    .line 22
    .line 23
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 24
    .line 25
    .line 26
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 27
    move-result-object v1

    .line 28
    .line 29
    .line 30
    invoke-virtual {v0, v1}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 31
    .line 32
    if-eqz p1, :cond_1

    .line 33
    .line 34
    .line 35
    invoke-virtual {p1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    .line 36
    move-result-object p1

    .line 37
    .line 38
    const-string v0, "getAbsolutePath(...)"

    .line 39
    .line 40
    .line 41
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 42
    .line 43
    .line 44
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->B3(Ljava/lang/String;)V

    .line 45
    :cond_1
    return-void
.end method

.method public static synthetic r2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->V2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final synthetic s2()I
    .locals 1

    .line 1
    .line 2
    sget v0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->s:I

    .line 3
    return v0
.end method

.method public static final synthetic t2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Landroidx/activity/result/ActivityResultLauncher;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->p:Landroidx/activity/result/ActivityResultLauncher;

    .line 3
    return-object p0
.end method

.method public static final synthetic u2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-direct {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->L2()V

    .line 4
    return-void
.end method

.method public static final u3(Lcom/xj/landscape/launcher/ui/main/viewholders/FixedCardView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/viewholders/FixedCardView;->d0()V

    .line 4
    .line 5
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 6
    return-object p0
.end method

.method public static final synthetic v2()Z
    .locals 1

    .line 1
    .line 2
    sget-boolean v0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->r:Z

    .line 3
    return v0
.end method

.method public static final v3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->n3()V

    .line 4
    .line 5
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 6
    return-object p0
.end method

.method public static final synthetic w2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->m3()V

    .line 4
    return-void
.end method

.method public static final w3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->l3()V

    .line 4
    .line 5
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 6
    return-object p0
.end method

.method public static final synthetic x2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->o3(Z)V

    .line 4
    return-void
.end method

.method public static final synthetic y2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->r3()V

    .line 4
    return-void
.end method

.method public static final y3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->n3()V

    .line 4
    .line 5
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 6
    return-object p0
.end method

.method public static final synthetic z2(Z)V
    .locals 0

    .line 1
    .line 2
    sput-boolean p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->t:Z

    .line 3
    return-void
.end method

.method public static final z3(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->l3()V

    .line 4
    .line 5
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 6
    return-object p0
.end method


# virtual methods
.method public final B3(Ljava/lang/String;)V
    .locals 6

    .line 1
    .line 2
    sget-object v0, Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog;->s:Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog$Companion;

    .line 3
    const/4 v4, 0x4

    .line 4
    const/4 v5, 0x0

    .line 5
    const/4 v3, 0x0

    .line 6
    move-object v1, p0

    .line 7
    move-object v2, p1

    .line 8
    .line 9
    .line 10
    invoke-static/range {v0 .. v5}, Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog$Companion;->c(Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog$Companion;Landroidx/fragment/app/FragmentActivity;Ljava/lang/String;Lkotlin/jvm/functions/Function1;ILjava/lang/Object;)Lcom/xj/winemu/ui/dialog/EditImportedGameInfoDialog;

    .line 11
    return-void
.end method

.method public final C3()V
    .locals 1

    .line 1
    .line 2
    const/high16 v0, 0x3f800000    # 1.0f

    .line 3
    .line 4
    .line 5
    invoke-virtual {p0, v0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F3(F)V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F2()Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 9
    move-result-object p0

    .line 10
    .line 11
    if-eqz p0, :cond_0

    .line 12
    .line 13
    .line 14
    invoke-interface {p0}, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;->n()V

    .line 15
    :cond_0
    return-void
.end method

.method public final D3()V
    .locals 2

    .line 1
    .line 2
    new-instance p0, Lcom/xj/landscape/launcher/event/ToggleTabEvent;

    .line 3
    const/4 v0, 0x1

    .line 4
    .line 5
    .line 6
    invoke-direct {p0, v0}, Lcom/xj/landscape/launcher/event/ToggleTabEvent;-><init>(I)V

    .line 7
    const/4 v0, 0x0

    .line 8
    const/4 v1, 0x2

    .line 9
    .line 10
    .line 11
    invoke-static {p0, v0, v1, v0}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 12
    return-void
.end method

.method public final E2()V
    .locals 3

    .line 1
    .line 2
    sget-object v0, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->a:Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;

    .line 3
    .line 4
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->k:Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$mIDeviceStateChangeListener$1;

    .line 5
    .line 6
    .line 7
    invoke-virtual {v0, v1}, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->L(Lcom/xj/bussiness/devicemanagement/utils/DeviceManager$IDeviceStateChangeListener;)V

    .line 8
    .line 9
    sget-object v1, Lcom/xiaoji/sdk/gcm/GcmProtocol;->Companion:Lcom/xiaoji/sdk/gcm/GcmProtocol$Companion;

    .line 10
    .line 11
    .line 12
    invoke-virtual {v1}, Lcom/xiaoji/sdk/gcm/GcmProtocol$Companion;->getINSTANCE()Lcom/xiaoji/sdk/gcm/GcmProtocol;

    .line 13
    move-result-object v1

    .line 14
    .line 15
    new-instance v2, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$deviceState$1;

    .line 16
    .line 17
    .line 18
    invoke-direct {v2, p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$deviceState$1;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 19
    .line 20
    .line 21
    invoke-virtual {v1, v2}, Lcom/xiaoji/sdk/gcm/GcmProtocol;->addDevModeCallback(Lcom/xiaoji/sdk/callback/v2/DevModeCallbackV2;)V

    .line 22
    .line 23
    .line 24
    invoke-virtual {v0}, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->x()Z

    .line 25
    move-result v0

    .line 26
    .line 27
    .line 28
    invoke-virtual {p0, v0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->o3(Z)V

    .line 29
    return-void
.end method

.method public final E3()V
    .locals 1

    .line 1
    .line 2
    new-instance v0, Lcom/xj/common/http/NetworkStatusDetector;

    .line 3
    .line 4
    .line 5
    invoke-direct {v0, p0}, Lcom/xj/common/http/NetworkStatusDetector;-><init>(Landroid/content/Context;)V

    .line 6
    .line 7
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->h:Lcom/xj/common/http/NetworkStatusDetector;

    .line 8
    .line 9
    .line 10
    invoke-virtual {v0}, Lcom/xj/common/http/NetworkStatusDetector;->p()V

    .line 11
    return-void
.end method

.method public final F2()Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;
    .locals 4

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/safely/SafelyActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    .line 4
    move-result-object p0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Landroidx/fragment/app/FragmentManager;->D0()Ljava/util/List;

    .line 8
    move-result-object p0

    .line 9
    .line 10
    const-string v0, "getFragments(...)"

    .line 11
    .line 12
    .line 13
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 14
    .line 15
    new-instance v0, Ljava/util/ArrayList;

    .line 16
    .line 17
    .line 18
    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 19
    .line 20
    .line 21
    invoke-interface {p0}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 22
    move-result-object p0

    .line 23
    .line 24
    .line 25
    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    .line 26
    move-result v1

    .line 27
    .line 28
    if-eqz v1, :cond_1

    .line 29
    .line 30
    .line 31
    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 32
    move-result-object v1

    .line 33
    move-object v2, v1

    .line 34
    .line 35
    check-cast v2, Landroidx/fragment/app/Fragment;

    .line 36
    .line 37
    .line 38
    invoke-virtual {v2}, Landroidx/fragment/app/Fragment;->isVisible()Z

    .line 39
    move-result v3

    .line 40
    .line 41
    if-eqz v3, :cond_0

    .line 42
    .line 43
    .line 44
    invoke-virtual {v2}, Landroidx/fragment/app/Fragment;->isAdded()Z

    .line 45
    move-result v2

    .line 46
    .line 47
    if-eqz v2, :cond_0

    .line 48
    .line 49
    .line 50
    invoke-interface {v0, v1}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z

    .line 51
    goto :goto_0

    .line 52
    .line 53
    :cond_1
    new-instance p0, Ljava/util/ArrayList;

    .line 54
    .line 55
    .line 56
    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    .line 57
    .line 58
    .line 59
    invoke-interface {v0}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 60
    move-result-object v0

    .line 61
    .line 62
    .line 63
    :cond_2
    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    .line 64
    move-result v1

    .line 65
    .line 66
    if-eqz v1, :cond_3

    .line 67
    .line 68
    .line 69
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 70
    move-result-object v1

    .line 71
    .line 72
    instance-of v2, v1, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 73
    .line 74
    if-eqz v2, :cond_2

    .line 75
    .line 76
    .line 77
    invoke-interface {p0, v1}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z

    .line 78
    goto :goto_1

    .line 79
    .line 80
    .line 81
    :cond_3
    invoke-static {p0}, Lkotlin/collections/CollectionsKt;->u0(Ljava/util/List;)Ljava/lang/Object;

    .line 82
    move-result-object p0

    .line 83
    .line 84
    check-cast p0, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 85
    return-object p0
.end method

.method public final F3(F)V
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    check-cast v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 7
    .line 8
    iget-object v0, v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 9
    .line 10
    const-string v1, "mainTabView"

    .line 11
    .line 12
    .line 13
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    .line 17
    move-result-object v0

    .line 18
    .line 19
    instance-of v1, v0, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 20
    .line 21
    if-eqz v1, :cond_0

    .line 22
    .line 23
    check-cast v0, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 24
    .line 25
    .line 26
    invoke-virtual {v0}, Landroid/view/ViewGroup$MarginLayoutParams;->getMarginStart()I

    .line 27
    move-result v0

    .line 28
    goto :goto_0

    .line 29
    :cond_0
    const/4 v0, 0x0

    .line 30
    .line 31
    :goto_0
    const/16 v1, 0x14

    .line 32
    .line 33
    .line 34
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 35
    move-result-object v1

    .line 36
    .line 37
    .line 38
    invoke-static {v1}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 39
    move-result-object v1

    .line 40
    .line 41
    .line 42
    invoke-virtual {v1}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 43
    move-result v1

    .line 44
    sub-int/2addr v0, v1

    .line 45
    .line 46
    .line 47
    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    .line 48
    move-result v0

    .line 49
    int-to-float v0, v0

    .line 50
    .line 51
    const/high16 v1, 0x3f800000    # 1.0f

    .line 52
    mul-float/2addr v0, v1

    .line 53
    .line 54
    const/16 v1, 0x1c

    .line 55
    .line 56
    .line 57
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 58
    move-result-object v1

    .line 59
    .line 60
    .line 61
    invoke-static {v1}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 62
    move-result-object v1

    .line 63
    .line 64
    .line 65
    invoke-virtual {v1}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 66
    move-result v1

    .line 67
    int-to-float v1, v1

    .line 68
    div-float/2addr v0, v1

    .line 69
    .line 70
    .line 71
    invoke-virtual {p0, v0, p1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->G3(FF)V

    .line 72
    return-void
.end method

.method public final G2()V
    .locals 6

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Landroidx/lifecycle/LifecycleOwnerKt;->a(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    new-instance v3, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$handleDeepLinks$1;

    .line 7
    const/4 p0, 0x0

    .line 8
    .line 9
    .line 10
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$handleDeepLinks$1;-><init>(Lkotlin/coroutines/Continuation;)V

    .line 11
    const/4 v4, 0x3

    .line 12
    const/4 v5, 0x0

    .line 13
    const/4 v1, 0x0

    .line 14
    const/4 v2, 0x0

    .line 15
    .line 16
    .line 17
    invoke-static/range {v0 .. v5}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 18
    return-void
.end method

.method public final G3(FF)V
    .locals 4

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->m:Landroid/animation/ValueAnimator;

    .line 3
    .line 4
    if-eqz v0, :cond_0

    .line 5
    .line 6
    .line 7
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->removeAllUpdateListeners()V

    .line 8
    .line 9
    :cond_0
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->m:Landroid/animation/ValueAnimator;

    .line 10
    .line 11
    if-eqz v0, :cond_1

    .line 12
    .line 13
    .line 14
    invoke-virtual {v0}, Landroid/animation/Animator;->removeAllListeners()V

    .line 15
    .line 16
    :cond_1
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->m:Landroid/animation/ValueAnimator;

    .line 17
    .line 18
    if-eqz v0, :cond_2

    .line 19
    .line 20
    .line 21
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    .line 22
    .line 23
    :cond_2
    cmpg-float v0, p1, p2

    .line 24
    .line 25
    if-nez v0, :cond_3

    .line 26
    return-void

    .line 27
    .line 28
    :cond_3
    sub-float v0, p2, p1

    .line 29
    .line 30
    .line 31
    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    .line 32
    move-result v0

    .line 33
    float-to-long v0, v0

    .line 34
    .line 35
    iget-wide v2, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->l:J

    .line 36
    mul-long/2addr v0, v2

    .line 37
    .line 38
    const-wide/16 v2, 0x64

    .line 39
    .line 40
    .line 41
    invoke-static {v0, v1, v2, v3}, Ljava/lang/Math;->max(JJ)J

    .line 42
    move-result-wide v0

    .line 43
    const/4 v2, 0x2

    .line 44
    .line 45
    new-array v2, v2, [F

    .line 46
    const/4 v3, 0x0

    .line 47
    .line 48
    aput p1, v2, v3

    .line 49
    const/4 p1, 0x1

    .line 50
    .line 51
    aput p2, v2, p1

    .line 52
    .line 53
    .line 54
    invoke-static {v2}, Landroid/animation/ValueAnimator;->ofFloat([F)Landroid/animation/ValueAnimator;

    .line 55
    move-result-object p1

    .line 56
    .line 57
    new-instance p2, Landroid/view/animation/LinearInterpolator;

    .line 58
    .line 59
    .line 60
    invoke-direct {p2}, Landroid/view/animation/LinearInterpolator;-><init>()V

    .line 61
    .line 62
    .line 63
    invoke-virtual {p1, p2}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    .line 64
    .line 65
    .line 66
    invoke-virtual {p1, v0, v1}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;

    .line 67
    .line 68
    .line 69
    invoke-virtual {p1, v3}, Landroid/animation/ValueAnimator;->setRepeatCount(I)V

    .line 70
    .line 71
    new-instance p2, Lcom/xj/landscape/launcher/ui/main/i;

    .line 72
    .line 73
    .line 74
    invoke-direct {p2, p0}, Lcom/xj/landscape/launcher/ui/main/i;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 75
    .line 76
    .line 77
    invoke-virtual {p1, p2}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V

    .line 78
    .line 79
    new-instance p2, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$startToggleTabAnimator$1$2;

    .line 80
    .line 81
    .line 82
    invoke-direct {p2, p1, p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$startToggleTabAnimator$1$2;-><init>(Landroid/animation/ValueAnimator;Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 83
    .line 84
    .line 85
    invoke-virtual {p1, p2}, Landroid/animation/Animator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    .line 86
    .line 87
    .line 88
    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->start()V

    .line 89
    .line 90
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->m:Landroid/animation/ValueAnimator;

    .line 91
    return-void
.end method

.method public final H2(Landroid/content/Intent;J)V
    .locals 35

    .line 1
    .line 2
    move-object/from16 v0, p1

    .line 3
    .line 4
    .line 5
    invoke-virtual/range {p0 .. p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->G2()V

    .line 6
    .line 7
    const-string v1, "isShortcut"

    .line 8
    const/4 v2, 0x0

    .line 9
    .line 10
    .line 11
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    .line 12
    move-result v3

    .line 13
    const/4 v4, -0x1

    .line 14
    .line 15
    if-eqz v3, :cond_3

    .line 16
    .line 17
    const-string v5, "startup_type"

    .line 18
    .line 19
    .line 20
    invoke-virtual {v0, v5, v4}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    .line 21
    move-result v4

    .line 22
    .line 23
    const/16 v5, 0x579

    .line 24
    .line 25
    if-eq v4, v5, :cond_1

    .line 26
    .line 27
    const/16 v3, 0x57a

    .line 28
    .line 29
    if-eq v4, v3, :cond_0

    .line 30
    .line 31
    goto/16 :goto_0

    .line 32
    .line 33
    :cond_0
    new-instance v3, Lorg/json/JSONObject;

    .line 34
    .line 35
    .line 36
    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    .line 37
    .line 38
    const-string v4, "coverImage"

    .line 39
    .line 40
    const-string v5, ""

    .line 41
    .line 42
    .line 43
    invoke-virtual {v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 44
    .line 45
    new-instance v4, Lorg/json/JSONObject;

    .line 46
    .line 47
    .line 48
    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    .line 49
    .line 50
    const-string v5, "Name"

    .line 51
    .line 52
    .line 53
    invoke-virtual {v0, v5}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    .line 54
    move-result-object v6

    .line 55
    .line 56
    .line 57
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 58
    .line 59
    const-string v5, "UUID"

    .line 60
    .line 61
    .line 62
    invoke-virtual {v0, v5}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    .line 63
    move-result-object v6

    .line 64
    .line 65
    .line 66
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 67
    .line 68
    const-string v5, "AppName"

    .line 69
    .line 70
    .line 71
    invoke-virtual {v0, v5}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    .line 72
    move-result-object v6

    .line 73
    .line 74
    .line 75
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 76
    .line 77
    const-string v5, "AppId"

    .line 78
    .line 79
    .line 80
    invoke-virtual {v0, v5}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    .line 81
    move-result-object v6

    .line 82
    .line 83
    .line 84
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 85
    .line 86
    const-string v5, "HDR"

    .line 87
    .line 88
    .line 89
    invoke-virtual {v0, v5, v2}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    .line 90
    move-result v6

    .line 91
    .line 92
    .line 93
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 94
    .line 95
    const-string v5, "pcStreamParamsJson"

    .line 96
    .line 97
    .line 98
    invoke-virtual {v3, v5, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 99
    .line 100
    .line 101
    invoke-virtual {v3}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    .line 102
    move-result-object v11

    .line 103
    .line 104
    const-string v3, "toString(...)"

    .line 105
    .line 106
    .line 107
    invoke-static {v11, v3}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 108
    .line 109
    new-instance v6, Lcom/xj/launch/strategy/api/LauncherConfig;

    .line 110
    .line 111
    new-instance v12, Lcom/xj/common/service/bean/GameStartupParams;

    .line 112
    .line 113
    .line 114
    const v33, 0x3ffff

    .line 115
    .line 116
    const/16 v34, 0x0

    .line 117
    const/4 v13, 0x0

    .line 118
    const/4 v14, 0x0

    .line 119
    const/4 v15, 0x0

    .line 120
    .line 121
    const/16 v16, 0x0

    .line 122
    .line 123
    const/16 v17, 0x0

    .line 124
    .line 125
    const/16 v18, 0x0

    .line 126
    .line 127
    const/16 v19, 0x0

    .line 128
    .line 129
    const/16 v20, 0x0

    .line 130
    .line 131
    const/16 v21, 0x0

    .line 132
    .line 133
    const/16 v22, 0x0

    .line 134
    .line 135
    const/16 v23, 0x0

    .line 136
    .line 137
    const/16 v24, 0x0

    .line 138
    .line 139
    const/16 v25, 0x0

    .line 140
    .line 141
    const/16 v26, 0x0

    .line 142
    .line 143
    const/16 v27, 0x0

    .line 144
    .line 145
    const-wide/16 v28, 0x0

    .line 146
    .line 147
    const-wide/16 v30, 0x0

    .line 148
    .line 149
    const/16 v32, 0x0

    .line 150
    .line 151
    .line 152
    invoke-direct/range {v12 .. v34}, Lcom/xj/common/service/bean/GameStartupParams;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILcom/xj/common/service/bean/StartExt;Ljava/lang/Integer;Ljava/lang/Integer;ZZILjava/lang/String;Ljava/lang/String;Ljava/lang/String;JJIILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 153
    .line 154
    const/16 v19, 0xfe0

    .line 155
    .line 156
    const/16 v7, 0x57a

    .line 157
    .line 158
    const-string v9, "1402"

    .line 159
    .line 160
    const-string v10, ""

    .line 161
    move-object v8, v12

    .line 162
    const/4 v12, 0x0

    .line 163
    .line 164
    const/16 v17, 0x0

    .line 165
    .line 166
    .line 167
    invoke-direct/range {v6 .. v20}, Lcom/xj/launch/strategy/api/LauncherConfig;-><init>(ILcom/xj/common/service/bean/GameStartupParams;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Ljava/util/List;Lcom/xj/common/data/gameinfo/LauncherGameInfo;Lcom/xj/common/bean/SteamGamePriceEntity;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function0;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 168
    .line 169
    sget-object v3, Lcom/xj/landscape/launcher/launcher/AppLauncher;->a:Lcom/xj/landscape/launcher/launcher/AppLauncher;

    .line 170
    .line 171
    .line 172
    invoke-virtual {v3, v6}, Lcom/xj/landscape/launcher/launcher/AppLauncher;->k(Lcom/xj/launch/strategy/api/LauncherConfig;)Lcom/xj/launch/strategy/api/LaunchResult;

    .line 173
    goto :goto_0

    .line 174
    .line 175
    :cond_1
    const-string v4, "id"

    .line 176
    .line 177
    .line 178
    invoke-virtual {v0, v4}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    .line 179
    move-result-object v4

    .line 180
    .line 181
    if-eqz v4, :cond_2

    .line 182
    .line 183
    new-instance v5, Lcom/xj/landscape/launcher/ui/main/t;

    .line 184
    .line 185
    .line 186
    invoke-direct {v5, v3, v4}, Lcom/xj/landscape/launcher/ui/main/t;-><init>(ZLjava/lang/String;)V

    .line 187
    .line 188
    move-wide/from16 v3, p2

    .line 189
    .line 190
    .line 191
    invoke-static {v3, v4, v5}, Lcom/xj/common/utils/VUiKit;->f(JLjava/lang/Runnable;)V

    .line 192
    .line 193
    .line 194
    :cond_2
    :goto_0
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 195
    move-result-object v0

    .line 196
    .line 197
    .line 198
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 199
    return-void

    .line 200
    .line 201
    :cond_3
    const-string v1, "Force_Firmware_Upgrade"

    .line 202
    .line 203
    .line 204
    invoke-virtual {v0, v1, v4}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    .line 205
    move-result v0

    .line 206
    .line 207
    sget-object v1, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 208
    .line 209
    new-instance v2, Ljava/lang/StringBuilder;

    .line 210
    .line 211
    .line 212
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 213
    .line 214
    const-string v3, "handleIntent: forceFirmwareUpgradeType="

    .line 215
    .line 216
    .line 217
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 218
    .line 219
    .line 220
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 221
    .line 222
    .line 223
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 224
    move-result-object v2

    .line 225
    .line 226
    .line 227
    invoke-virtual {v1, v2}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 228
    const/4 v1, 0x1

    .line 229
    .line 230
    if-eq v0, v1, :cond_5

    .line 231
    const/4 v1, 0x2

    .line 232
    .line 233
    if-eq v0, v1, :cond_4

    .line 234
    return-void

    .line 235
    .line 236
    :cond_4
    sget-object v0, Lcom/xj/landscape/launcher/ui/device/comfig/DeviceEventNav;->a:Lcom/xj/landscape/launcher/ui/device/comfig/DeviceEventNav;

    .line 237
    .line 238
    .line 239
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/device/comfig/DeviceEventNav;->a()V

    .line 240
    return-void

    .line 241
    .line 242
    :cond_5
    sget-object v0, Lcom/xj/landscape/launcher/ui/device/comfig/DeviceEventNav;->a:Lcom/xj/landscape/launcher/ui/device/comfig/DeviceEventNav;

    .line 243
    .line 244
    .line 245
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/device/comfig/DeviceEventNav;->b()V

    .line 246
    return-void
.end method

.method public final I3(F)V
    .locals 4

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    check-cast v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 7
    .line 8
    iget-object v0, v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 9
    .line 10
    const-string v1, "mainTabView"

    .line 11
    .line 12
    .line 13
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    .line 17
    move-result-object v1

    .line 18
    .line 19
    if-eqz v1, :cond_0

    .line 20
    .line 21
    check-cast v1, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 22
    .line 23
    const/16 v2, 0x14

    .line 24
    .line 25
    .line 26
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 27
    move-result-object v2

    .line 28
    .line 29
    .line 30
    invoke-static {v2}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 31
    move-result-object v2

    .line 32
    .line 33
    .line 34
    invoke-virtual {v2}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 35
    move-result v2

    .line 36
    .line 37
    const/16 v3, 0x1c

    .line 38
    .line 39
    .line 40
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 41
    move-result-object v3

    .line 42
    .line 43
    .line 44
    invoke-static {v3}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 45
    move-result-object v3

    .line 46
    .line 47
    .line 48
    invoke-virtual {v3}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 49
    move-result v3

    .line 50
    int-to-float v3, v3

    .line 51
    mul-float/2addr v3, p1

    .line 52
    float-to-int v3, v3

    .line 53
    add-int/2addr v2, v3

    .line 54
    .line 55
    .line 56
    invoke-virtual {v1, v2}, Landroid/view/ViewGroup$MarginLayoutParams;->setMarginStart(I)V

    .line 57
    .line 58
    .line 59
    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 60
    .line 61
    .line 62
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 63
    move-result-object v0

    .line 64
    .line 65
    check-cast v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 66
    .line 67
    iget-object v0, v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivTipsLb:Landroid/widget/ImageView;

    .line 68
    .line 69
    .line 70
    const v1, 0x3f4ccccd    # 0.8f

    .line 71
    mul-float/2addr p1, v1

    .line 72
    .line 73
    .line 74
    invoke-virtual {v0, p1}, Landroid/view/View;->setAlpha(F)V

    .line 75
    .line 76
    .line 77
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 78
    move-result-object p0

    .line 79
    .line 80
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 81
    .line 82
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivTipsRb:Landroid/widget/ImageView;

    .line 83
    .line 84
    .line 85
    invoke-virtual {p0, p1}, Landroid/view/View;->setAlpha(F)V

    .line 86
    return-void

    .line 87
    .line 88
    :cond_0
    new-instance p0, Ljava/lang/NullPointerException;

    .line 89
    .line 90
    const-string p1, "null cannot be cast to non-null type android.view.ViewGroup.MarginLayoutParams"

    .line 91
    .line 92
    .line 93
    invoke-direct {p0, p1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    .line 94
    throw p0
.end method

.method public final K2()V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    .line 3
    .line 4
    invoke-virtual {p0, v0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F3(F)V

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F2()Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 8
    move-result-object p0

    .line 9
    .line 10
    if-eqz p0, :cond_0

    .line 11
    .line 12
    .line 13
    invoke-interface {p0}, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;->r()V

    .line 14
    :cond_0
    return-void
.end method

.method public L1()V
    .locals 3

    .line 1
    const/4 v0, 0x0

    .line 2
    const/4 v1, 0x0

    .line 3
    const/4 v2, 0x1

    .line 4
    .line 5
    .line 6
    invoke-static {p0, v1, v2, v0}, Lcom/xj/common/view/focus/focus/FocusableRoot;->z(Lcom/xj/common/view/focus/focus/FocusableRoot;ZILjava/lang/Object;)Lcom/xj/common/view/focus/focus/FocusableView;

    .line 7
    move-result-object v0

    .line 8
    .line 9
    if-eqz v0, :cond_0

    .line 10
    .line 11
    .line 12
    invoke-interface {v0}, Lcom/xj/common/view/focus/focus/FocusableView;->getOnShowFloatMenu()Lkotlin/jvm/functions/Function1;

    .line 13
    move-result-object v0

    .line 14
    .line 15
    if-eqz v0, :cond_0

    .line 16
    .line 17
    .line 18
    invoke-interface {v0, p0}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    .line 19
    move-result-object v0

    .line 20
    .line 21
    check-cast v0, Ljava/lang/Boolean;

    .line 22
    .line 23
    .line 24
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    .line 25
    move-result v0

    .line 26
    .line 27
    if-ne v0, v2, :cond_0

    .line 28
    return-void

    .line 29
    .line 30
    .line 31
    :cond_0
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->x3()V

    .line 32
    return-void
.end method

.method public b(Lcom/xj/common/view/focus/focus/FocusEvent;)Z
    .locals 3

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
    invoke-super {p0, p1}, Lcom/xj/common/view/focus/focus/app/FocusableActivity;->b(Lcom/xj/common/view/focus/focus/FocusEvent;)Z

    .line 9
    move-result v0

    .line 10
    .line 11
    if-eqz v0, :cond_0

    .line 12
    const/4 p0, 0x1

    .line 13
    return p0

    .line 14
    .line 15
    .line 16
    :cond_0
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->j3()Z

    .line 17
    move-result v0

    .line 18
    const/4 v1, 0x0

    .line 19
    .line 20
    if-eqz v0, :cond_2

    .line 21
    .line 22
    .line 23
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 24
    move-result-object v0

    .line 25
    .line 26
    sget-object v2, Lcom/xj/common/view/focus/focus/FocusDirection;->L1:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 27
    .line 28
    if-ne v0, v2, :cond_1

    .line 29
    .line 30
    .line 31
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 32
    move-result-object p0

    .line 33
    .line 34
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 35
    .line 36
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 37
    .line 38
    sget-object p1, Lcom/xj/common/view/focus/focus/FocusDirection;->LEFT:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 39
    .line 40
    .line 41
    invoke-virtual {p0, p1}, Lcom/xj/common/view/focus/focus/view/FocusTabLayout;->P(Lcom/xj/common/view/focus/focus/FocusDirection;)Z

    .line 42
    move-result p0

    .line 43
    return p0

    .line 44
    .line 45
    .line 46
    :cond_1
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 47
    move-result-object p1

    .line 48
    .line 49
    sget-object v0, Lcom/xj/common/view/focus/focus/FocusDirection;->R1:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 50
    .line 51
    if-ne p1, v0, :cond_3

    .line 52
    .line 53
    .line 54
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 55
    move-result-object p0

    .line 56
    .line 57
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 58
    .line 59
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 60
    .line 61
    sget-object p1, Lcom/xj/common/view/focus/focus/FocusDirection;->RIGHT:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 62
    .line 63
    .line 64
    invoke-virtual {p0, p1}, Lcom/xj/common/view/focus/focus/view/FocusTabLayout;->P(Lcom/xj/common/view/focus/focus/FocusDirection;)Z

    .line 65
    move-result p0

    .line 66
    return p0

    .line 67
    .line 68
    .line 69
    :cond_2
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 70
    move-result-object v0

    .line 71
    .line 72
    sget-object v2, Lcom/xj/common/view/focus/focus/FocusDirection;->L1:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 73
    .line 74
    if-eq v0, v2, :cond_4

    .line 75
    .line 76
    .line 77
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 78
    move-result-object v0

    .line 79
    .line 80
    sget-object v2, Lcom/xj/common/view/focus/focus/FocusDirection;->R1:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 81
    .line 82
    if-ne v0, v2, :cond_3

    .line 83
    goto :goto_0

    .line 84
    :cond_3
    return v1

    .line 85
    .line 86
    .line 87
    :cond_4
    :goto_0
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F2()Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 88
    move-result-object p0

    .line 89
    .line 90
    if-eqz p0, :cond_5

    .line 91
    .line 92
    .line 93
    invoke-interface {p0, p1}, Lcom/xj/common/view/focus/focus/FocusableView;->b(Lcom/xj/common/view/focus/focus/FocusEvent;)Z

    .line 94
    move-result p0

    .line 95
    return p0

    .line 96
    :cond_5
    return v1
.end method

.method public e(Lcom/xj/common/view/focus/focus/FocusEvent;Lcom/xj/common/view/focus/focus/FocusableView;)Lcom/xj/common/view/focus/focus/FocusableView;
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
    const-string v0, "lastFocusedView"

    .line 8
    .line 9
    .line 10
    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 14
    move-result-object v0

    .line 15
    .line 16
    sget-object v1, Lcom/xj/common/view/focus/focus/FocusDirection;->UP:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 17
    .line 18
    if-ne v0, v1, :cond_0

    .line 19
    .line 20
    .line 21
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F2()Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 22
    move-result-object v0

    .line 23
    .line 24
    .line 25
    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 26
    move-result v0

    .line 27
    .line 28
    if-eqz v0, :cond_0

    .line 29
    .line 30
    .line 31
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->D3()V

    .line 32
    .line 33
    .line 34
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 35
    move-result-object p0

    .line 36
    .line 37
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 38
    .line 39
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 40
    return-object p0

    .line 41
    .line 42
    .line 43
    :cond_0
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 44
    move-result-object v0

    .line 45
    .line 46
    sget-object v1, Lcom/xj/common/view/focus/focus/FocusDirection;->DOWN:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 47
    .line 48
    if-ne v0, v1, :cond_2

    .line 49
    .line 50
    .line 51
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F2()Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 52
    move-result-object p0

    .line 53
    .line 54
    if-eqz p0, :cond_1

    .line 55
    return-object p0

    .line 56
    :cond_1
    return-object p2

    .line 57
    .line 58
    .line 59
    :cond_2
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 60
    move-result-object v0

    .line 61
    .line 62
    sget-object v1, Lcom/xj/common/view/focus/focus/FocusDirection;->LEFT:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 63
    .line 64
    if-ne v0, v1, :cond_5

    .line 65
    .line 66
    .line 67
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 68
    move-result-object p1

    .line 69
    .line 70
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 71
    .line 72
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->flOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 73
    .line 74
    .line 75
    invoke-static {p2, p1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 76
    move-result p1

    .line 77
    .line 78
    if-eqz p1, :cond_3

    .line 79
    .line 80
    .line 81
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 82
    move-result-object p0

    .line 83
    .line 84
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 85
    .line 86
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->flOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 87
    return-object p0

    .line 88
    .line 89
    .line 90
    :cond_3
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 91
    move-result-object p1

    .line 92
    .line 93
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 94
    .line 95
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 96
    .line 97
    .line 98
    invoke-static {p2, p1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 99
    move-result p1

    .line 100
    .line 101
    if-eqz p1, :cond_4

    .line 102
    .line 103
    .line 104
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 105
    move-result-object p0

    .line 106
    .line 107
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 108
    .line 109
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->flOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 110
    return-object p0

    .line 111
    .line 112
    .line 113
    :cond_4
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 114
    move-result-object p1

    .line 115
    .line 116
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 117
    .line 118
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->llRightTopStatus:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 119
    .line 120
    .line 121
    invoke-static {p2, p1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 122
    move-result p1

    .line 123
    .line 124
    if-eqz p1, :cond_7

    .line 125
    .line 126
    .line 127
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 128
    move-result-object p0

    .line 129
    .line 130
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 131
    .line 132
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 133
    return-object p0

    .line 134
    .line 135
    .line 136
    :cond_5
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 137
    move-result-object p1

    .line 138
    .line 139
    sget-object v0, Lcom/xj/common/view/focus/focus/FocusDirection;->RIGHT:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 140
    .line 141
    if-ne p1, v0, :cond_7

    .line 142
    .line 143
    .line 144
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 145
    move-result-object p1

    .line 146
    .line 147
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 148
    .line 149
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->flOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 150
    .line 151
    .line 152
    invoke-static {p2, p1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 153
    move-result p1

    .line 154
    .line 155
    if-eqz p1, :cond_6

    .line 156
    .line 157
    .line 158
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 159
    move-result-object p0

    .line 160
    .line 161
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 162
    .line 163
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 164
    return-object p0

    .line 165
    .line 166
    .line 167
    :cond_6
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 168
    move-result-object p1

    .line 169
    .line 170
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 171
    .line 172
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 173
    .line 174
    .line 175
    invoke-static {p2, p1}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 176
    move-result p1

    .line 177
    .line 178
    if-eqz p1, :cond_7

    .line 179
    .line 180
    .line 181
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 182
    move-result-object p0

    .line 183
    .line 184
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 185
    .line 186
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->llRightTopStatus:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 187
    return-object p0

    .line 188
    :cond_7
    const/4 p0, 0x0

    .line 189
    return-object p0
.end method

.method public initObserver()V
    .locals 11

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    .line 4
    move-result-object v1

    .line 5
    .line 6
    const-string v0, "getIntent(...)"

    .line 7
    .line 8
    .line 9
    invoke-static {v1, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 10
    const/4 v4, 0x2

    .line 11
    const/4 v5, 0x0

    .line 12
    .line 13
    const-wide/16 v2, 0x0

    .line 14
    move-object v0, p0

    .line 15
    .line 16
    .line 17
    invoke-static/range {v0 .. v5}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->I2(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Landroid/content/Intent;JILjava/lang/Object;)V

    .line 18
    .line 19
    .line 20
    invoke-virtual {v0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMViewModel()Lcom/xj/base/base/viewmodel/BaseViewModel;

    .line 21
    move-result-object p0

    .line 22
    .line 23
    check-cast p0, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;

    .line 24
    .line 25
    .line 26
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;->u()Landroidx/lifecycle/LiveData;

    .line 27
    move-result-object p0

    .line 28
    .line 29
    new-instance v1, Lcom/xj/landscape/launcher/ui/main/b0;

    .line 30
    .line 31
    .line 32
    invoke-direct {v1}, Lcom/xj/landscape/launcher/ui/main/b0;-><init>()V

    .line 33
    .line 34
    new-instance v2, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$sam$androidx_lifecycle_Observer$0;

    .line 35
    .line 36
    .line 37
    invoke-direct {v2, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$sam$androidx_lifecycle_Observer$0;-><init>(Lkotlin/jvm/functions/Function1;)V

    .line 38
    .line 39
    .line 40
    invoke-virtual {p0, v0, v2}, Landroidx/lifecycle/LiveData;->i(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Observer;)V

    .line 41
    .line 42
    .line 43
    invoke-virtual {v0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMViewModel()Lcom/xj/base/base/viewmodel/BaseViewModel;

    .line 44
    move-result-object p0

    .line 45
    .line 46
    check-cast p0, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;

    .line 47
    .line 48
    .line 49
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;->t()Landroidx/lifecycle/LiveData;

    .line 50
    move-result-object p0

    .line 51
    .line 52
    new-instance v1, Lcom/xj/landscape/launcher/ui/main/c0;

    .line 53
    .line 54
    .line 55
    invoke-direct {v1, v0}, Lcom/xj/landscape/launcher/ui/main/c0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 56
    .line 57
    new-instance v2, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$sam$androidx_lifecycle_Observer$0;

    .line 58
    .line 59
    .line 60
    invoke-direct {v2, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$sam$androidx_lifecycle_Observer$0;-><init>(Lkotlin/jvm/functions/Function1;)V

    .line 61
    .line 62
    .line 63
    invoke-virtual {p0, v0, v2}, Landroidx/lifecycle/LiveData;->i(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Observer;)V

    .line 64
    .line 65
    .line 66
    invoke-virtual {v0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMViewModel()Lcom/xj/base/base/viewmodel/BaseViewModel;

    .line 67
    move-result-object p0

    .line 68
    .line 69
    check-cast p0, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;

    .line 70
    .line 71
    .line 72
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;->v()Landroidx/lifecycle/LiveData;

    .line 73
    move-result-object p0

    .line 74
    .line 75
    new-instance v1, Lcom/xj/landscape/launcher/ui/main/d0;

    .line 76
    .line 77
    .line 78
    invoke-direct {v1, v0}, Lcom/xj/landscape/launcher/ui/main/d0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 79
    .line 80
    new-instance v2, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$sam$androidx_lifecycle_Observer$0;

    .line 81
    .line 82
    .line 83
    invoke-direct {v2, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$sam$androidx_lifecycle_Observer$0;-><init>(Lkotlin/jvm/functions/Function1;)V

    .line 84
    .line 85
    .line 86
    invoke-virtual {p0, v0, v2}, Landroidx/lifecycle/LiveData;->i(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Observer;)V

    .line 87
    .line 88
    new-instance p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$4;

    .line 89
    const/4 v1, 0x0

    .line 90
    .line 91
    .line 92
    invoke-direct {p0, v0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$4;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/coroutines/Continuation;)V

    .line 93
    const/4 v2, 0x0

    .line 94
    .line 95
    new-array v3, v2, [Ljava/lang/String;

    .line 96
    .line 97
    sget-object v4, Landroidx/lifecycle/Lifecycle$Event;->ON_DESTROY:Landroidx/lifecycle/Lifecycle$Event;

    .line 98
    .line 99
    new-instance v5, Lcom/drake/channel/ChannelScope;

    .line 100
    .line 101
    .line 102
    invoke-direct {v5, v0, v4}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 103
    .line 104
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$1;

    .line 105
    .line 106
    .line 107
    invoke-direct {v8, v3, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$1;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 108
    const/4 v9, 0x3

    .line 109
    const/4 v10, 0x0

    .line 110
    const/4 v6, 0x0

    .line 111
    const/4 v7, 0x0

    .line 112
    .line 113
    .line 114
    invoke-static/range {v5 .. v10}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 115
    .line 116
    new-instance p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$5;

    .line 117
    .line 118
    .line 119
    invoke-direct {p0, v0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$5;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/coroutines/Continuation;)V

    .line 120
    .line 121
    new-array v3, v2, [Ljava/lang/String;

    .line 122
    .line 123
    new-instance v5, Lcom/drake/channel/ChannelScope;

    .line 124
    .line 125
    .line 126
    invoke-direct {v5, v0, v4}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 127
    .line 128
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$2;

    .line 129
    .line 130
    .line 131
    invoke-direct {v8, v3, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$2;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 132
    .line 133
    .line 134
    invoke-static/range {v5 .. v10}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 135
    .line 136
    new-instance p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$6;

    .line 137
    .line 138
    .line 139
    invoke-direct {p0, v0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$6;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/coroutines/Continuation;)V

    .line 140
    .line 141
    new-array v3, v2, [Ljava/lang/String;

    .line 142
    .line 143
    new-instance v5, Lcom/drake/channel/ChannelScope;

    .line 144
    .line 145
    .line 146
    invoke-direct {v5, v0, v4}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 147
    .line 148
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$3;

    .line 149
    .line 150
    .line 151
    invoke-direct {v8, v3, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$3;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 152
    .line 153
    .line 154
    invoke-static/range {v5 .. v10}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 155
    .line 156
    new-instance p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$7;

    .line 157
    .line 158
    .line 159
    invoke-direct {p0, v0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$7;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/coroutines/Continuation;)V

    .line 160
    .line 161
    new-array v3, v2, [Ljava/lang/String;

    .line 162
    .line 163
    new-instance v5, Lcom/drake/channel/ChannelScope;

    .line 164
    .line 165
    .line 166
    invoke-direct {v5, v0, v4}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 167
    .line 168
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$4;

    .line 169
    .line 170
    .line 171
    invoke-direct {v8, v3, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$4;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 172
    .line 173
    .line 174
    invoke-static/range {v5 .. v10}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 175
    .line 176
    new-instance p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$8;

    .line 177
    .line 178
    .line 179
    invoke-direct {p0, v0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$8;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/coroutines/Continuation;)V

    .line 180
    .line 181
    new-array v3, v2, [Ljava/lang/String;

    .line 182
    .line 183
    new-instance v5, Lcom/drake/channel/ChannelScope;

    .line 184
    .line 185
    .line 186
    invoke-direct {v5, v0, v4}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 187
    .line 188
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$5;

    .line 189
    .line 190
    .line 191
    invoke-direct {v8, v3, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$5;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 192
    .line 193
    .line 194
    invoke-static/range {v5 .. v10}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 195
    .line 196
    new-instance p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$9;

    .line 197
    .line 198
    .line 199
    invoke-direct {p0, v0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$9;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/coroutines/Continuation;)V

    .line 200
    .line 201
    new-array v3, v2, [Ljava/lang/String;

    .line 202
    .line 203
    new-instance v5, Lcom/drake/channel/ChannelScope;

    .line 204
    .line 205
    .line 206
    invoke-direct {v5, v0, v4}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 207
    .line 208
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$6;

    .line 209
    .line 210
    .line 211
    invoke-direct {v8, v3, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$6;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 212
    .line 213
    .line 214
    invoke-static/range {v5 .. v10}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 215
    .line 216
    new-instance p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$10;

    .line 217
    .line 218
    .line 219
    invoke-direct {p0, v0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$10;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/coroutines/Continuation;)V

    .line 220
    .line 221
    new-array v3, v2, [Ljava/lang/String;

    .line 222
    .line 223
    new-instance v5, Lcom/drake/channel/ChannelScope;

    .line 224
    .line 225
    .line 226
    invoke-direct {v5, v0, v4}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 227
    .line 228
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$7;

    .line 229
    .line 230
    .line 231
    invoke-direct {v8, v3, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$7;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 232
    .line 233
    .line 234
    invoke-static/range {v5 .. v10}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 235
    .line 236
    new-instance p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$11;

    .line 237
    .line 238
    .line 239
    invoke-direct {p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$11;-><init>(Lkotlin/coroutines/Continuation;)V

    .line 240
    .line 241
    new-array v3, v2, [Ljava/lang/String;

    .line 242
    .line 243
    new-instance v5, Lcom/drake/channel/ChannelScope;

    .line 244
    .line 245
    .line 246
    invoke-direct {v5, v0, v4}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 247
    .line 248
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$8;

    .line 249
    .line 250
    .line 251
    invoke-direct {v8, v3, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$8;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 252
    .line 253
    .line 254
    invoke-static/range {v5 .. v10}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 255
    .line 256
    new-instance p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$12;

    .line 257
    .line 258
    .line 259
    invoke-direct {p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$12;-><init>(Lkotlin/coroutines/Continuation;)V

    .line 260
    .line 261
    new-array v2, v2, [Ljava/lang/String;

    .line 262
    .line 263
    new-instance v5, Lcom/drake/channel/ChannelScope;

    .line 264
    .line 265
    .line 266
    invoke-direct {v5, v0, v4}, Lcom/drake/channel/ChannelScope;-><init>(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Lifecycle$Event;)V

    .line 267
    .line 268
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$9;

    .line 269
    .line 270
    .line 271
    invoke-direct {v8, v2, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initObserver$$inlined$receiveEvent$default$9;-><init>([Ljava/lang/String;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)V

    .line 272
    .line 273
    .line 274
    invoke-static/range {v5 .. v10}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 275
    return-void
.end method

.method public initView(Landroid/os/Bundle;)V
    .locals 12

    .line 1
    const/4 p1, 0x3

    .line 2
    const/4 v0, 0x0

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    .line 6
    invoke-static {p0, v0, v1, p1, v1}, Lcom/xj/base/base/activity/BaseVmActivity;->enableImmersionBar$default(Lcom/xj/base/base/activity/BaseVmActivity;ZLcom/gyf/immersionbar/BarHide;ILjava/lang/Object;)V

    .line 7
    .line 8
    .line 9
    invoke-static {p0}, Landroidx/lifecycle/LifecycleOwnerKt;->a(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 10
    move-result-object v2

    .line 11
    .line 12
    .line 13
    invoke-static {}, Lkotlinx/coroutines/Dispatchers;->b()Lkotlinx/coroutines/CoroutineDispatcher;

    .line 14
    move-result-object v3

    .line 15
    .line 16
    new-instance v5, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initView$1;

    .line 17
    .line 18
    .line 19
    invoke-direct {v5, p0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$initView$1;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;Lkotlin/coroutines/Continuation;)V

    .line 20
    const/4 v6, 0x2

    .line 21
    const/4 v7, 0x0

    .line 22
    const/4 v4, 0x0

    .line 23
    .line 24
    .line 25
    invoke-static/range {v2 .. v7}, Lkotlinx/coroutines/BuildersKt;->d(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 26
    .line 27
    sget-object p1, Lcom/xj/common/utils/GetGpuInfo;->a:Lcom/xj/common/utils/GetGpuInfo;

    .line 28
    .line 29
    .line 30
    invoke-virtual {p1}, Lcom/xj/common/utils/GetGpuInfo;->a()Z

    .line 31
    .line 32
    .line 33
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->E2()V

    .line 34
    .line 35
    sget-object p1, Lcom/xj/common/utils/LauncherUtils;->a:Lcom/xj/common/utils/LauncherUtils;

    .line 36
    .line 37
    .line 38
    invoke-virtual {p1}, Lcom/xj/common/utils/LauncherUtils;->b()V

    .line 39
    .line 40
    .line 41
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->E3()V

    .line 42
    .line 43
    .line 44
    invoke-virtual {p1}, Lcom/xj/common/utils/LauncherUtils;->c()Lcom/xj/common/data/model/ObservableLauncherEntity;

    .line 45
    move-result-object p1

    .line 46
    .line 47
    new-instance v2, Lcom/xj/landscape/launcher/ui/main/k0;

    .line 48
    .line 49
    .line 50
    invoke-direct {v2, p0}, Lcom/xj/landscape/launcher/ui/main/k0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 51
    .line 52
    .line 53
    invoke-virtual {p1, v2}, Lcom/xj/common/data/model/ObservableLauncherEntity;->addPropertyChangedListener(Lkotlin/jvm/functions/Function3;)V

    .line 54
    .line 55
    .line 56
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 57
    move-result-object p1

    .line 58
    .line 59
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 60
    .line 61
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 62
    .line 63
    new-instance v2, Lcom/xj/landscape/launcher/ui/main/r;

    .line 64
    .line 65
    .line 66
    invoke-direct {v2, p0}, Lcom/xj/landscape/launcher/ui/main/r;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 67
    .line 68
    .line 69
    invoke-virtual {p1, v2}, Lcom/xj/common/view/focus/focus/view/FocusTabLayout;->setOnTabSelectChanged(Lkotlin/jvm/functions/Function3;)V

    .line 70
    .line 71
    .line 72
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 73
    move-result-object p1

    .line 74
    .line 75
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 76
    .line 77
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 78
    .line 79
    new-instance v2, Lcom/xj/landscape/launcher/ui/main/s;

    .line 80
    .line 81
    .line 82
    invoke-direct {v2, p0}, Lcom/xj/landscape/launcher/ui/main/s;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 83
    .line 84
    .line 85
    invoke-virtual {p1, v2}, Landroid/view/View;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 86
    .line 87
    sget-object p1, Lcom/xj/common/config/AppConfig;->a:Lcom/xj/common/config/AppConfig$Companion;

    .line 88
    .line 89
    .line 90
    invoke-virtual {p1}, Lcom/xj/common/config/AppConfig$Companion;->a()Z

    .line 91
    move-result v2

    .line 92
    .line 93
    if-nez v2, :cond_1

    .line 94
    .line 95
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->g:Ljava/util/List;

    .line 96
    .line 97
    new-instance v3, Lcom/xj/landscape/launcher/ui/main/TabItemData;

    .line 98
    .line 99
    sget v5, Lcom/xj/language/R$string;->llauncher_main_page_title_my:I

    .line 100
    .line 101
    new-instance v6, Lcom/xj/landscape/launcher/ui/main/u;

    .line 102
    .line 103
    .line 104
    invoke-direct {v6}, Lcom/xj/landscape/launcher/ui/main/u;-><init>()V

    .line 105
    const/4 v7, 0x1

    .line 106
    const/4 v8, 0x0

    .line 107
    const/4 v4, 0x0

    .line 108
    .line 109
    .line 110
    invoke-direct/range {v3 .. v8}, Lcom/xj/landscape/launcher/ui/main/TabItemData;-><init>(IILkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 111
    .line 112
    .line 113
    invoke-interface {v2, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z


    .line 114
    .line 115
    sget-object v3, Lcom/xj/base/language/GHLocaleManager;->a:Lcom/xj/base/language/GHLocaleManager;

    .line 116
    .line 117
    .line 118
    invoke-virtual {v3, p0}, Lcom/xj/base/language/GHLocaleManager;->p(Landroid/content/Context;)Z

    .line 119
    move-result v3

    .line 120
    .line 121
    if-eqz v3, :cond_0

    .line 122
    .line 123
    .line 124
    invoke-virtual {p1}, Lcom/xj/common/config/AppConfig$Companion;->b()Z

    .line 125
    move-result v3

    .line 126
    .line 127
    if-nez v3, :cond_0

    .line 128
    .line 129
    .line 130
    invoke-virtual {p1}, Lcom/xj/common/config/AppConfig$Companion;->c()Z

    .line 131
    move-result v3

    .line 132
    .line 133
    if-nez v3, :cond_0

    .line 134
    .line 135
    new-instance v4, Lcom/xj/landscape/launcher/ui/main/TabItemData;

    .line 136
    .line 137
    sget v6, Lcom/xj/language/R$string;->llauncher_play_in_second:I

    .line 138
    .line 139
    sget-object v3, Lcom/xj/common/data/preferences/AppPreferences;->INSTANCE:Lcom/xj/common/data/preferences/AppPreferences;

    .line 140
    .line 141
    .line 142
    invoke-virtual {v3}, Lcom/xj/common/data/preferences/AppPreferences;->isFirstShowPlayInSecondsTab()Z

    .line 143
    move-result v7

    .line 144
    .line 145
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/v;

    .line 146
    .line 147
    .line 148
    invoke-direct {v8}, Lcom/xj/landscape/launcher/ui/main/v;-><init>()V

    .line 149
    const/4 v9, 0x1

    .line 150
    const/4 v10, 0x0

    .line 151
    const/4 v5, 0x0

    .line 152
    .line 153
    .line 154
    invoke-direct/range {v4 .. v10}, Lcom/xj/landscape/launcher/ui/main/TabItemData;-><init>(IIZLkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 155
    .line 156
    .line 157
    invoke-interface {v2, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 158
    .line 159
    :cond_0
    new-instance v5, Lcom/xj/landscape/launcher/ui/main/TabItemData;

    .line 160
    .line 161
    sget v7, Lcom/xj/language/R$string;->llauncher_main_page_title_explore:I

    .line 162
    .line 163
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/w;

    .line 164
    .line 165
    .line 166
    invoke-direct {v8}, Lcom/xj/landscape/launcher/ui/main/w;-><init>()V

    .line 167
    const/4 v9, 0x1

    .line 168
    const/4 v10, 0x0

    .line 169
    const/4 v6, 0x0

    .line 170
    .line 171
    .line 172
    invoke-direct/range {v5 .. v10}, Lcom/xj/landscape/launcher/ui/main/TabItemData;-><init>(IILkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 173
    .line 174
    .line 175
    .line 176
    .line 177
    new-instance v6, Lcom/xj/landscape/launcher/ui/main/TabItemData;

    .line 178
    .line 179
    sget v8, Lcom/xj/language/R$string;->llauncher_main_page_title_platform:I

    .line 180
    .line 181
    new-instance v9, Lcom/xj/landscape/launcher/ui/main/x;

    .line 182
    .line 183
    .line 184
    invoke-direct {v9}, Lcom/xj/landscape/launcher/ui/main/x;-><init>()V

    .line 185
    const/4 v10, 0x1

    .line 186
    const/4 v11, 0x0

    .line 187
    const/4 v7, 0x0

    .line 188
    .line 189
    .line 190
    invoke-direct/range {v6 .. v11}, Lcom/xj/landscape/launcher/ui/main/TabItemData;-><init>(IILkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 191
    .line 192
    .line 193
    .line 194
    goto :goto_0

    .line 195
    .line 196
    :cond_1
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->g:Ljava/util/List;

    .line 197
    .line 198
    new-instance v3, Lcom/xj/landscape/launcher/ui/main/TabItemData;

    .line 199
    .line 200
    sget v5, Lcom/xj/language/R$string;->llauncher_main_page_title_my:I

    .line 201
    .line 202
    new-instance v6, Lcom/xj/landscape/launcher/ui/main/y;

    .line 203
    .line 204
    .line 205
    invoke-direct {v6}, Lcom/xj/landscape/launcher/ui/main/y;-><init>()V

    .line 206
    const/4 v7, 0x1

    .line 207
    const/4 v8, 0x0

    .line 208
    const/4 v4, 0x0

    .line 209
    .line 210
    .line 211
    invoke-direct/range {v3 .. v8}, Lcom/xj/landscape/launcher/ui/main/TabItemData;-><init>(IILkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 212
    .line 213
    .line 214
    invoke-interface {v2, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z


    .line 215
    .line 216
    new-instance v4, Lcom/xj/landscape/launcher/ui/main/TabItemData;

    .line 217
    .line 218
    sget v6, Lcom/xj/language/R$string;->llauncher_play_in_second:I

    .line 219
    .line 220
    new-instance v7, Lcom/xj/landscape/launcher/ui/main/z;

    .line 221
    .line 222
    .line 223
    invoke-direct {v7}, Lcom/xj/landscape/launcher/ui/main/z;-><init>()V

    .line 224
    const/4 v8, 0x1

    .line 225
    const/4 v9, 0x0

    .line 226
    const/4 v5, 0x0

    .line 227
    .line 228
    .line 229
    invoke-direct/range {v4 .. v9}, Lcom/xj/landscape/launcher/ui/main/TabItemData;-><init>(IILkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 230
    .line 231
    .line 232
    invoke-interface {v2, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 233
    .line 234
    .line 235
    :goto_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 236
    move-result-object v2

    .line 237
    .line 238
    check-cast v2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 239
    .line 240
    iget-object v2, v2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 241
    .line 242
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->g:Ljava/util/List;

    .line 243
    const/4 v4, 0x2

    .line 244
    .line 245
    .line 246
    invoke-static {v2, v3, v0, v4, v1}, Lcom/xj/common/view/focus/focus/view/FocusTabLayout;->N(Lcom/xj/common/view/focus/focus/view/FocusTabLayout;Ljava/util/List;IILjava/lang/Object;)V

    .line 247
    .line 248
    .line 249
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 250
    move-result-object v2

    .line 251
    .line 252
    check-cast v2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 253
    .line 254
    iget-object v2, v2, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->tvSystemTime:Landroid/widget/TextClock;

    .line 255
    .line 256
    .line 257
    invoke-virtual {v2, v1}, Landroid/widget/TextClock;->setFormat12Hour(Ljava/lang/CharSequence;)V

    .line 258
    .line 259
    .line 260
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 261
    move-result-object v1

    .line 262
    .line 263
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 264
    .line 265
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->tvSystemTime:Landroid/widget/TextClock;

    .line 266
    .line 267
    const-string v2, "HH:mm"

    .line 268
    .line 269
    .line 270
    invoke-virtual {v1, v2}, Landroid/widget/TextClock;->setFormat24Hour(Ljava/lang/CharSequence;)V

    .line 271
    .line 272
    .line 273
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 274
    move-result-object v1

    .line 275
    .line 276
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 277
    .line 278
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSearch:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 279
    .line 280
    const-string v2, "ivSearch"

    .line 281
    .line 282
    .line 283
    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 284
    .line 285
    new-instance v3, Lcom/xj/landscape/launcher/ui/main/a0;

    .line 286
    .line 287
    .line 288
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/main/a0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 289
    .line 290
    .line 291
    invoke-static {v1, v3}, Lcom/xj/common/utils/ClickUtilsKt;->i(Landroid/view/View;Lkotlin/jvm/functions/Function1;)V

    .line 292
    .line 293
    .line 294
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 295
    move-result-object v1

    .line 296
    .line 297
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 298
    .line 299
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSearch:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 300
    .line 301
    new-instance v3, Lcom/xj/landscape/launcher/ui/main/l0;

    .line 302
    .line 303
    .line 304
    invoke-direct {v3, p0}, Lcom/xj/landscape/launcher/ui/main/l0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 305
    .line 306
    .line 307
    invoke-virtual {v1, v3}, Landroid/view/View;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 308
    .line 309
    .line 310
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 311
    move-result-object v1

    .line 312
    .line 313
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 314
    .line 315
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivSearch:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 316
    .line 317
    .line 318
    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 319
    .line 320
    .line 321
    invoke-static {v1}, Lcom/xj/common/view/focus/focus/view/FocusViewsExtKt;->b(Landroid/view/View;)V

    .line 322
    .line 323
    .line 324
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 325
    move-result-object v1

    .line 326
    .line 327
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 328
    .line 329
    iget-object v2, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->flOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 330
    .line 331
    new-instance v6, Lcom/xj/landscape/launcher/ui/main/m0;

    .line 332
    .line 333
    .line 334
    invoke-direct {v6, p0}, Lcom/xj/landscape/launcher/ui/main/m0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 335
    const/4 v7, 0x1

    .line 336
    const/4 v8, 0x0

    .line 337
    .line 338
    const-wide/16 v3, 0x0

    .line 339
    const/4 v5, 0x0

    .line 340
    .line 341
    .line 342
    invoke-static/range {v2 .. v8}, Lcom/xj/common/utils/ClickUtilsKt;->l(Landroid/view/View;JZLkotlin/jvm/functions/Function1;ILjava/lang/Object;)V

    .line 343
    .line 344
    .line 345
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 346
    move-result-object v1

    .line 347
    .line 348
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 349
    .line 350
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->flOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 351
    .line 352
    new-instance v2, Lcom/xj/landscape/launcher/ui/main/j;

    .line 353
    .line 354
    .line 355
    invoke-direct {v2, p0}, Lcom/xj/landscape/launcher/ui/main/j;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 356
    .line 357
    .line 358
    invoke-virtual {v1, v2}, Landroid/view/View;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 359
    .line 360
    .line 361
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 362
    move-result-object v1

    .line 363
    .line 364
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 365
    .line 366
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->flOpenNav:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 367
    .line 368
    const-string v2, "flOpenNav"

    .line 369
    .line 370
    .line 371
    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 372
    .line 373
    .line 374
    invoke-static {v1}, Lcom/xj/common/view/focus/focus/view/FocusViewsExtKt;->b(Landroid/view/View;)V

    .line 375
    .line 376
    .line 377
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 378
    move-result-object v1

    .line 379
    .line 380
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 381
    .line 382
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDeviceOnline:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 383
    .line 384
    const-string v2, "ivDeviceOnline"

    .line 385
    .line 386
    .line 387
    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 388
    .line 389
    .line 390
    invoke-virtual {p1}, Lcom/xj/common/config/AppConfig$Companion;->a()Z

    .line 391
    move-result p1

    .line 392
    .line 393
    if-nez p1, :cond_2

    .line 394
    move p1, v0

    .line 395
    goto :goto_1

    .line 396
    .line 397
    :cond_2
    const/16 p1, 0x8

    .line 398
    .line 399
    .line 400
    :goto_1
    invoke-virtual {v1, p1}, Landroid/view/View;->setVisibility(I)V

    .line 401
    .line 402
    .line 403
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 404
    move-result-object p1

    .line 405
    .line 406
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 407
    .line 408
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDeviceOnline:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 409
    .line 410
    .line 411
    invoke-static {p1, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 412
    .line 413
    new-instance v1, Lcom/xj/landscape/launcher/ui/main/k;

    .line 414
    .line 415
    .line 416
    invoke-direct {v1, p0}, Lcom/xj/landscape/launcher/ui/main/k;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 417
    .line 418
    .line 419
    invoke-static {p1, v1}, Lcom/xj/common/utils/ClickUtilsKt;->i(Landroid/view/View;Lkotlin/jvm/functions/Function1;)V

    .line 420
    .line 421
    .line 422
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 423
    move-result-object p1

    .line 424
    .line 425
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 426
    .line 427
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDeviceOnline:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 428
    .line 429
    new-instance v1, Lcom/xj/landscape/launcher/ui/main/l;

    .line 430
    .line 431
    .line 432
    invoke-direct {v1, p0}, Lcom/xj/landscape/launcher/ui/main/l;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 433
    .line 434
    .line 435
    invoke-virtual {p1, v1}, Landroid/view/View;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 436
    .line 437
    .line 438
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 439
    move-result-object p1

    .line 440
    .line 441
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 442
    .line 443
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDeviceOnline:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 444
    .line 445
    .line 446
    invoke-static {p1, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 447
    .line 448
    .line 449
    invoke-static {p1}, Lcom/xj/common/view/focus/focus/view/FocusViewsExtKt;->b(Landroid/view/View;)V

    .line 450
    .line 451
    .line 452
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 453
    move-result-object p1

    .line 454
    .line 455
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 456
    .line 457
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDownloading:Lcom/xj/common/view/DownloadProgressIconView;

    .line 458
    .line 459
    .line 460
    invoke-virtual {p1, v0}, Lcom/xj/common/view/DownloadProgressIconView;->setAutoHandleFocusUi(Z)V

    .line 461
    .line 462
    .line 463
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 464
    move-result-object p1

    .line 465
    .line 466
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 467
    .line 468
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDownloading:Lcom/xj/common/view/DownloadProgressIconView;

    .line 469
    .line 470
    new-instance v0, Lcom/xj/landscape/launcher/ui/main/m;

    .line 471
    .line 472
    .line 473
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/main/m;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 474
    .line 475
    .line 476
    invoke-virtual {p1, v0}, Lcom/xj/common/view/DownloadProgressIconView;->setOnVisibilityChangedListener(Lkotlin/jvm/functions/Function1;)V

    .line 477
    .line 478
    .line 479
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 480
    move-result-object p1

    .line 481
    .line 482
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 483
    .line 484
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDownloading:Lcom/xj/common/view/DownloadProgressIconView;

    .line 485
    .line 486
    new-instance v0, Lcom/xj/landscape/launcher/ui/main/n;

    .line 487
    .line 488
    .line 489
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/main/n;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 490
    .line 491
    .line 492
    invoke-virtual {p1, v0}, Landroid/view/View;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 493
    .line 494
    .line 495
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 496
    move-result-object p1

    .line 497
    .line 498
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 499
    .line 500
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDownloading:Lcom/xj/common/view/DownloadProgressIconView;

    .line 501
    .line 502
    const-string v0, "ivDownloading"

    .line 503
    .line 504
    .line 505
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 506
    .line 507
    .line 508
    invoke-static {p1}, Lcom/xj/common/view/focus/focus/view/FocusViewsExtKt;->b(Landroid/view/View;)V

    .line 509
    .line 510
    .line 511
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 512
    move-result-object p1

    .line 513
    .line 514
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 515
    .line 516
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rightUserAvatarView:Lcom/xj/user/view/UserAvatarView;

    .line 517
    const/4 v0, 0x1

    .line 518
    .line 519
    .line 520
    invoke-virtual {p1, v0}, Lcom/xj/user/view/UserAvatarView;->x(Z)Lcom/xj/user/view/UserAvatarView;

    .line 521
    .line 522
    .line 523
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 524
    move-result-object p1

    .line 525
    .line 526
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 527
    .line 528
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rightUserAvatarView:Lcom/xj/user/view/UserAvatarView;

    .line 529
    .line 530
    new-instance v0, Lcom/xj/landscape/launcher/ui/main/o;

    .line 531
    .line 532
    .line 533
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/main/o;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 534
    .line 535
    .line 536
    invoke-virtual {p1, v0}, Landroid/view/View;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 537
    .line 538
    .line 539
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 540
    move-result-object p1

    .line 541
    .line 542
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 543
    .line 544
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rightUserAvatarView:Lcom/xj/user/view/UserAvatarView;

    .line 545
    .line 546
    const-string v0, "rightUserAvatarView"

    .line 547
    .line 548
    .line 549
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 550
    .line 551
    .line 552
    invoke-static {p1}, Lcom/xj/common/view/focus/focus/view/FocusViewsExtKt;->b(Landroid/view/View;)V

    .line 553
    .line 554
    .line 555
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 556
    move-result-object p1

    .line 557
    .line 558
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 559
    .line 560
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rightUserAvatarView:Lcom/xj/user/view/UserAvatarView;

    .line 561
    .line 562
    .line 563
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 564
    .line 565
    new-instance v0, Lcom/xj/landscape/launcher/ui/main/p;

    .line 566
    .line 567
    .line 568
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/main/p;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 569
    .line 570
    .line 571
    invoke-static {p1, v0}, Lcom/xj/common/utils/ClickUtilsKt;->i(Landroid/view/View;Lkotlin/jvm/functions/Function1;)V

    .line 572
    .line 573
    sget-object p1, Lcom/xj/steam/api/ISteamService;->a:Lcom/xj/steam/api/ISteamService$Companion;

    .line 574
    .line 575
    .line 576
    invoke-virtual {p1}, Lcom/xj/steam/api/ISteamService$Companion;->a()Lcom/xj/steam/api/ISteamService;

    .line 577
    move-result-object p1

    .line 578
    .line 579
    if-eqz p1, :cond_3

    .line 580
    .line 581
    .line 582
    invoke-interface {p1}, Lcom/xj/steam/api/ISteamService;->l()V

    .line 583
    .line 584
    .line 585
    :cond_3
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 586
    move-result-object p1

    .line 587
    .line 588
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 589
    .line 590
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rootView:Lcom/xj/common/view/focus/InterceptFocusEventConstraintLayout;

    .line 591
    .line 592
    const-string v0, "rootView"

    .line 593
    .line 594
    .line 595
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 596
    .line 597
    .line 598
    invoke-virtual {p0, p1}, Lcom/xj/common/view/focus/focus/app/FocusableActivity;->k(Lcom/xj/common/view/focus/InterceptFocusEventConstraintLayout;)V

    .line 599
    .line 600
    .line 601
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->p3()V

    .line 602
    .line 603
    .line 604
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 605
    move-result-object p1

    .line 606
    .line 607
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 608
    .line 609
    iget-object p1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 610
    .line 611
    .line 612
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/view/FocusTabLayout;->y()V

    .line 613
    .line 614
    sget-object v0, Lcom/xj/common/utils/PermissionUtils;->a:Lcom/xj/common/utils/PermissionUtils;

    .line 615
    .line 616
    new-instance v4, Lcom/xj/landscape/launcher/ui/main/q;

    .line 617
    .line 618
    .line 619
    invoke-direct {v4, p0}, Lcom/xj/landscape/launcher/ui/main/q;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 620
    const/4 v5, 0x6

    .line 621
    const/4 v6, 0x0

    .line 622
    const/4 v2, 0x0

    .line 623
    const/4 v3, 0x0

    .line 624
    move-object v1, p0

    .line 625
    .line 626
    .line 627
    invoke-static/range {v0 .. v6}, Lcom/xj/common/utils/PermissionUtils;->J(Lcom/xj/common/utils/PermissionUtils;Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lkotlin/jvm/functions/Function3;ILjava/lang/Object;)V

    .line 628
    .line 629
    .line 630
    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->G2()V

    .line 631
    .line 632
    .line 633
    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->s3()V

    .line 634

    # BCI launcher button wiring
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    move-result-object v0

    invoke-virtual {v0}, Landroidx/databinding/ViewDataBinding;->getRoot()Landroid/view/View;

    move-result-object v0

    sget v1, Lcom/xj/landscape/launcher/R$id;->iv_bci_launcher:I

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :skip_bci

    new-instance v1, Lcom/xj/landscape/launcher/ui/main/BciLauncherClickListener;

    invoke-direct {v1, p0}, Lcom/xj/landscape/launcher/ui/main/BciLauncherClickListener;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :skip_bci

    return-void
.end method

.method public final j3()Z
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    check-cast v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 7
    .line 8
    iget-object v0, v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivTipsLb:Landroid/widget/ImageView;

    .line 9
    .line 10
    const-string v1, "ivTipsLb"

    .line 11
    .line 12
    .line 13
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    .line 17
    move-result v0

    .line 18
    .line 19
    if-nez v0, :cond_1

    .line 20
    .line 21
    .line 22
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 23
    move-result-object p0

    .line 24
    .line 25
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 26
    .line 27
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivTipsLb:Landroid/widget/ImageView;

    .line 28
    .line 29
    .line 30
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F

    .line 31
    move-result p0

    .line 32
    const/4 v0, 0x0

    .line 33
    .line 34
    cmpg-float p0, p0, v0

    .line 35
    .line 36
    if-nez p0, :cond_0

    .line 37
    goto :goto_0

    .line 38
    :cond_0
    const/4 p0, 0x1

    .line 39
    return p0

    .line 40
    :cond_1
    :goto_0
    const/4 p0, 0x0

    .line 41
    return p0
.end method

.method public final k3(IZ)V
    .locals 6

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->g:Ljava/util/List;

    .line 3
    .line 4
    .line 5
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    .line 6
    move-result-object v0

    .line 7
    const/4 v1, 0x0

    .line 8
    move v2, v1

    .line 9
    .line 10
    .line 11
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    .line 12
    move-result v3

    .line 13
    .line 14
    if-eqz v3, :cond_1

    .line 15
    .line 16
    .line 17
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 18
    move-result-object v3

    .line 19
    .line 20
    check-cast v3, Lcom/xj/landscape/launcher/ui/main/TabItemData;

    .line 21
    .line 22
    .line 23
    invoke-virtual {v3}, Lcom/xj/landscape/launcher/ui/main/TabItemData;->c()Ljava/lang/String;

    .line 24
    move-result-object v3

    .line 25
    .line 26
    sget v4, Lcom/xj/language/R$string;->llauncher_main_page_title_platform:I

    .line 27
    .line 28
    .line 29
    invoke-static {v4}, Lcom/xj/winemu/ext/IntExtKt;->a(I)Ljava/lang/String;

    .line 30
    move-result-object v4

    .line 31
    .line 32
    .line 33
    invoke-static {v3, v4}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 34
    move-result v3

    .line 35
    .line 36
    if-nez v3, :cond_0

    .line 37
    goto :goto_1

    .line 38
    .line 39
    :cond_0
    add-int/lit8 v2, v2, 0x1

    .line 40
    goto :goto_0

    .line 41
    :cond_1
    const/4 v2, -0x1

    .line 42
    .line 43
    :goto_1
    if-eq p1, v2, :cond_2

    .line 44
    .line 45
    .line 46
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->D3()V

    .line 47
    .line 48
    :cond_2
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->g:Ljava/util/List;

    .line 49
    .line 50
    .line 51
    invoke-static {v0, p1}, Lkotlin/collections/CollectionsKt;->v0(Ljava/util/List;I)Ljava/lang/Object;

    .line 52
    move-result-object v0

    .line 53
    .line 54
    check-cast v0, Lcom/xj/landscape/launcher/ui/main/TabItemData;

    .line 55
    .line 56
    if-nez v0, :cond_3

    .line 57
    return-void

    .line 58
    .line 59
    :cond_3
    sget v2, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->s:I

    .line 60
    const/4 v3, 0x1

    .line 61
    .line 62
    if-eq p1, v2, :cond_4

    .line 63
    move v1, v3

    .line 64
    .line 65
    .line 66
    :cond_4
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/safely/SafelyActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    .line 67
    move-result-object v2

    .line 68
    .line 69
    .line 70
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/main/TabItemData;->c()Ljava/lang/String;

    .line 71
    move-result-object v4

    .line 72
    .line 73
    .line 74
    invoke-virtual {v2, v4}, Landroidx/fragment/app/FragmentManager;->n0(Ljava/lang/String;)Landroidx/fragment/app/Fragment;

    .line 75
    move-result-object v2

    .line 76
    const/4 v4, 0x0

    .line 77
    .line 78
    if-nez v2, :cond_6

    .line 79
    .line 80
    .line 81
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/main/TabItemData;->a()Lkotlin/jvm/functions/Function0;

    .line 82
    move-result-object v1

    .line 83
    .line 84
    if-eqz v1, :cond_5

    .line 85
    .line 86
    .line 87
    invoke-interface {v1}, Lkotlin/jvm/functions/Function0;->invoke()Ljava/lang/Object;

    .line 88
    move-result-object v1

    .line 89
    .line 90
    check-cast v1, Landroidx/fragment/app/Fragment;

    .line 91
    move-object v2, v1

    .line 92
    goto :goto_2

    .line 93
    :cond_5
    move-object v2, v4

    .line 94
    .line 95
    .line 96
    :goto_2
    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 97
    .line 98
    .line 99
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/safely/SafelyActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    .line 100
    move-result-object v1

    .line 101
    .line 102
    .line 103
    invoke-virtual {v1}, Landroidx/fragment/app/FragmentManager;->q()Landroidx/fragment/app/FragmentTransaction;

    .line 104
    move-result-object v1

    .line 105
    .line 106
    sget v5, Lcom/xj/landscape/launcher/R$id;->page_container:I

    .line 107
    .line 108
    .line 109
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/main/TabItemData;->c()Ljava/lang/String;

    .line 110
    move-result-object v0

    .line 111
    .line 112
    .line 113
    invoke-virtual {v1, v5, v2, v0}, Landroidx/fragment/app/FragmentTransaction;->c(ILandroidx/fragment/app/Fragment;Ljava/lang/String;)Landroidx/fragment/app/FragmentTransaction;

    .line 114
    .line 115
    .line 116
    invoke-virtual {v1}, Landroidx/fragment/app/FragmentTransaction;->k()V

    .line 117
    goto :goto_3

    .line 118
    :cond_6
    move v3, v1

    .line 119
    .line 120
    :goto_3
    sput p1, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->s:I

    .line 121
    .line 122
    if-eqz v3, :cond_a

    .line 123
    .line 124
    sget-object p1, Lcom/xj/common/utils/GHSoundPlayHelper;->a:Lcom/xj/common/utils/GHSoundPlayHelper;

    .line 125
    .line 126
    .line 127
    invoke-virtual {p1}, Lcom/xj/common/utils/GHSoundPlayHelper;->g()V

    .line 128
    .line 129
    .line 130
    invoke-static {}, Lcom/shuyu/gsyvideoplayer/GSYVideoManager;->r()V

    .line 131
    .line 132
    .line 133
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/safely/SafelyActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    .line 134
    move-result-object p1

    .line 135
    .line 136
    .line 137
    invoke-virtual {p1}, Landroidx/fragment/app/FragmentManager;->q()Landroidx/fragment/app/FragmentTransaction;

    .line 138
    move-result-object p1

    .line 139
    .line 140
    const/high16 v0, 0x10a0000

    .line 141
    .line 142
    .line 143
    const v1, 0x10a0001

    .line 144
    .line 145
    .line 146
    invoke-virtual {p1, v0, v1}, Landroidx/fragment/app/FragmentTransaction;->v(II)Landroidx/fragment/app/FragmentTransaction;

    .line 147
    .line 148
    .line 149
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/safely/SafelyActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    .line 150
    move-result-object v0

    .line 151
    .line 152
    .line 153
    invoke-virtual {v0}, Landroidx/fragment/app/FragmentManager;->D0()Ljava/util/List;

    .line 154
    move-result-object v0

    .line 155
    .line 156
    .line 157
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    .line 158
    move-result-object v0

    .line 159
    .line 160
    .line 161
    :cond_7
    :goto_4
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    .line 162
    move-result v1

    .line 163
    .line 164
    if-eqz v1, :cond_9

    .line 165
    .line 166
    .line 167
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 168
    move-result-object v1

    .line 169
    .line 170
    check-cast v1, Landroidx/fragment/app/Fragment;

    .line 171
    .line 172
    .line 173
    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 174
    move-result v3

    .line 175
    .line 176
    if-eqz v3, :cond_8

    .line 177
    .line 178
    instance-of v3, v1, Lcom/xj/base/base/fragment/LazyFragment;

    .line 179
    .line 180
    if-eqz v3, :cond_7

    .line 181
    move-object v3, v1

    .line 182
    .line 183
    check-cast v3, Lcom/xj/base/base/fragment/LazyFragment;

    .line 184
    .line 185
    .line 186
    invoke-virtual {v3}, Landroidx/fragment/app/Fragment;->isVisible()Z

    .line 187
    move-result v5

    .line 188
    .line 189
    if-nez v5, :cond_7

    .line 190
    .line 191
    .line 192
    invoke-virtual {v3}, Landroidx/fragment/app/Fragment;->isAdded()Z

    .line 193
    move-result v3

    .line 194
    .line 195
    if-eqz v3, :cond_7

    .line 196
    .line 197
    .line 198
    invoke-virtual {p1, v1}, Landroidx/fragment/app/FragmentTransaction;->B(Landroidx/fragment/app/Fragment;)Landroidx/fragment/app/FragmentTransaction;

    .line 199
    .line 200
    sget-object v3, Landroidx/lifecycle/Lifecycle$State;->RESUMED:Landroidx/lifecycle/Lifecycle$State;

    .line 201
    .line 202
    .line 203
    invoke-virtual {p1, v1, v3}, Landroidx/fragment/app/FragmentTransaction;->x(Landroidx/fragment/app/Fragment;Landroidx/lifecycle/Lifecycle$State;)Landroidx/fragment/app/FragmentTransaction;

    .line 204
    goto :goto_4

    .line 205
    .line 206
    :cond_8
    instance-of v3, v1, Lcom/xj/base/base/fragment/LazyFragment;

    .line 207
    .line 208
    if-eqz v3, :cond_7

    .line 209
    move-object v3, v1

    .line 210
    .line 211
    check-cast v3, Lcom/xj/base/base/fragment/LazyFragment;

    .line 212
    .line 213
    .line 214
    invoke-virtual {v3}, Landroidx/fragment/app/Fragment;->isVisible()Z

    .line 215
    move-result v5

    .line 216
    .line 217
    if-eqz v5, :cond_7

    .line 218
    .line 219
    .line 220
    invoke-virtual {v3}, Landroidx/fragment/app/Fragment;->isAdded()Z

    .line 221
    move-result v3

    .line 222
    .line 223
    if-eqz v3, :cond_7

    .line 224
    .line 225
    .line 226
    invoke-virtual {p1, v1}, Landroidx/fragment/app/FragmentTransaction;->p(Landroidx/fragment/app/Fragment;)Landroidx/fragment/app/FragmentTransaction;

    .line 227
    .line 228
    sget-object v3, Landroidx/lifecycle/Lifecycle$State;->STARTED:Landroidx/lifecycle/Lifecycle$State;

    .line 229
    .line 230
    .line 231
    invoke-virtual {p1, v1, v3}, Landroidx/fragment/app/FragmentTransaction;->x(Landroidx/fragment/app/Fragment;Landroidx/lifecycle/Lifecycle$State;)Landroidx/fragment/app/FragmentTransaction;

    .line 232
    goto :goto_4

    .line 233
    .line 234
    .line 235
    :cond_9
    invoke-virtual {p1}, Landroidx/fragment/app/FragmentTransaction;->k()V

    .line 236
    .line 237
    :cond_a
    instance-of p1, v2, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 238
    .line 239
    if-eqz p1, :cond_b

    .line 240
    move-object v0, v2

    .line 241
    .line 242
    check-cast v0, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 243
    goto :goto_5

    .line 244
    :cond_b
    move-object v0, v4

    .line 245
    .line 246
    :goto_5
    if-eqz v0, :cond_c

    .line 247
    .line 248
    .line 249
    invoke-interface {v0}, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;->C()V

    .line 250
    .line 251
    :cond_c
    if-eqz p2, :cond_e

    .line 252
    .line 253
    if-eqz p1, :cond_d

    .line 254
    move-object v4, v2

    .line 255
    .line 256
    check-cast v4, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 257
    .line 258
    :cond_d
    if-eqz v4, :cond_e

    .line 259
    .line 260
    .line 261
    invoke-interface {v4}, Lcom/xj/common/view/focus/focus/FocusableView;->y()V

    .line 262
    .line 263
    .line 264
    :cond_e
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->x3()V

    .line 265
    return-void
.end method

.method public final l3()V
    .locals 1

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->r:Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0, p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$Companion;->c(Landroidx/fragment/app/FragmentActivity;)V

    .line 6
    return-void
.end method

.method public layoutId()I
    .locals 0

    .line 1
    .line 2
    sget p0, Lcom/xj/landscape/launcher/R$layout;->llauncher_activity_new_launcher_main:I

    .line 3
    return p0
.end method

.method public final m3()V
    .locals 3

    .line 1
    .line 2
    sget-object p0, Lcom/xj/common/router/PageRouterUtils;->a:Lcom/xj/common/router/PageRouterUtils;

    .line 3
    const/4 v0, 0x0

    .line 4
    const/4 v1, 0x2

    .line 5
    const/4 v2, 0x1

    .line 6
    .line 7
    .line 8
    invoke-static {p0, v2, v0, v1, v0}, Lcom/xj/common/router/PageRouterUtils;->r(Lcom/xj/common/router/PageRouterUtils;ILjava/lang/String;ILjava/lang/Object;)V

    .line 9
    return-void
.end method

.method public final n3()V
    .locals 4

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F2()Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 4
    move-result-object p0

    .line 5
    .line 6
    if-eqz p0, :cond_0

    .line 7
    .line 8
    .line 9
    invoke-interface {p0}, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;->u()I

    .line 10
    move-result p0

    .line 11
    goto :goto_0

    .line 12
    :cond_0
    const/4 p0, -0x1

    .line 13
    .line 14
    :goto_0
    sget-object v0, Lcom/xj/common/router/PageRouterUtils;->a:Lcom/xj/common/router/PageRouterUtils;

    .line 15
    const/4 v1, 0x2

    .line 16
    const/4 v2, 0x0

    .line 17
    const/4 v3, 0x0

    .line 18
    .line 19
    .line 20
    invoke-static {v0, p0, v3, v1, v2}, Lcom/xj/common/router/PageRouterUtils;->D(Lcom/xj/common/router/PageRouterUtils;IIILjava/lang/Object;)V

    .line 21
    return-void
.end method

.method public final o3(Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 4
    move-result-object p0

    .line 5
    .line 6
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 7
    .line 8
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivDeviceOnline:Lcom/xj/common/view/focus/focus/view/FocusableImageView;

    .line 9
    .line 10
    if-eqz p1, :cond_0

    .line 11
    .line 12
    sget p1, Lcom/xj/common/R$drawable;->comm_ic_main_device_online:I

    .line 13
    goto :goto_0

    .line 14
    .line 15
    :cond_0
    sget p1, Lcom/xj/common/R$drawable;->comm_ic_main_device_offline:I

    .line 16
    .line 17
    .line 18
    :goto_0
    invoke-virtual {p0, p1}, Landroidx/appcompat/widget/AppCompatImageView;->setImageResource(I)V

    .line 19
    return-void
.end method

.method public onBackPressed()V
    .locals 4

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/safely/SafelyActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    .line 7
    invoke-virtual {v0}, Landroidx/fragment/app/FragmentManager;->w0()I

    .line 8
    move-result v0

    .line 9
    .line 10
    if-lez v0, :cond_0

    .line 11
    .line 12
    .line 13
    invoke-super {p0}, Lcom/xj/base/base/fragment/safely/SafelyActivity;->onBackPressed()V

    .line 14
    return-void

    .line 15
    .line 16
    .line 17
    :cond_0
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 18
    move-result-object v0

    .line 19
    .line 20
    check-cast v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 21
    .line 22
    iget-object v0, v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 23
    .line 24
    .line 25
    invoke-virtual {v0}, Lcom/xj/common/view/focus/focus/view/scrollable/FocusableHorizontalScrollView;->p()Z

    .line 26
    move-result v0

    .line 27
    .line 28
    if-nez v0, :cond_3

    .line 29
    .line 30
    .line 31
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->F2()Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;

    .line 32
    move-result-object v0

    .line 33
    .line 34
    if-eqz v0, :cond_1

    .line 35
    .line 36
    .line 37
    invoke-interface {v0}, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;->onBackPressed()Z

    .line 38
    move-result v1

    .line 39
    .line 40
    if-eqz v1, :cond_1

    .line 41
    goto :goto_0

    .line 42
    .line 43
    .line 44
    :cond_1
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->D3()V

    .line 45
    .line 46
    .line 47
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 48
    move-result-object p0

    .line 49
    .line 50
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 51
    .line 52
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->mainTabView:Lcom/xj/landscape/launcher/ui/main/LauncherTabLayout;

    .line 53
    .line 54
    .line 55
    invoke-virtual {p0}, Lcom/xj/common/view/focus/focus/view/FocusTabLayout;->y()V

    .line 56
    .line 57
    if-eqz v0, :cond_2

    .line 58
    .line 59
    .line 60
    invoke-interface {v0}, Lcom/xj/landscape/launcher/ui/main/LauncherMainChildFragment;->C()V

    .line 61
    :cond_2
    :goto_0
    return-void

    .line 62
    .line 63
    .line 64
    :cond_3
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    .line 65
    move-result-wide v0

    .line 66
    .line 67
    iget-wide v2, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->o:J

    .line 68
    sub-long/2addr v0, v2

    .line 69
    .line 70
    const-wide/16 v2, 0x7d0

    .line 71
    .line 72
    cmp-long v0, v0, v2

    .line 73
    .line 74
    if-lez v0, :cond_4

    .line 75
    .line 76
    .line 77
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    .line 78
    move-result-wide v0

    .line 79
    .line 80
    iput-wide v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->o:J

    .line 81
    .line 82
    sget-object v0, Lcom/xj/common/utils/toast/Toaster;->a:Lcom/xj/common/utils/toast/Toaster;

    .line 83
    .line 84
    sget v1, Lcom/xj/language/R$string;->llauncher_main_page_close_app_hint:I

    .line 85
    .line 86
    .line 87
    invoke-virtual {p0, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 88
    move-result-object p0

    .line 89
    .line 90
    .line 91
    invoke-virtual {v0, p0}, Lcom/xj/common/utils/toast/Toaster;->h(Ljava/lang/String;)V

    .line 92
    return-void

    .line 93
    .line 94
    :cond_4
    new-instance v0, Landroid/content/Intent;

    .line 95
    .line 96
    const-string v1, "android.intent.action.MAIN"

    .line 97
    .line 98
    .line 99
    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 100
    .line 101
    const-string v1, "android.intent.category.HOME"

    .line 102
    .line 103
    .line 104
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    .line 105
    .line 106
    const/high16 v1, 0x10000000

    .line 107
    .line 108
    .line 109
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setFlags(I)Landroid/content/Intent;

    .line 110
    .line 111
    .line 112
    :try_start_0
    invoke-virtual {p0, v0}, Lcom/xj/base/base/activity/BaseVmActivity;->startActivity(Landroid/content/Intent;)V

    .line 113
    .line 114
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;
    :try_end_0
    .catch Landroid/content/ActivityNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    .line 115
    return-void

    .line 116
    :catch_0
    const/4 v0, 0x1

    .line 117
    .line 118
    .line 119
    invoke-virtual {p0, v0}, Landroid/app/Activity;->moveTaskToBack(Z)Z

    .line 120
    return-void
.end method

.method public onDestroy()V
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-super {p0}, Lcom/xj/common/view/focus/focus/app/FocusableActivity;->onDestroy()V

    .line 4
    .line 5
    sget-object v0, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->a:Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;

    .line 6
    .line 7
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->k:Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity$mIDeviceStateChangeListener$1;

    .line 8
    .line 9
    .line 10
    invoke-virtual {v0, v1}, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->g0(Lcom/xj/bussiness/devicemanagement/utils/DeviceManager$IDeviceStateChangeListener;)V

    .line 11
    .line 12
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->p:Landroidx/activity/result/ActivityResultLauncher;

    .line 13
    .line 14
    if-eqz v0, :cond_0

    .line 15
    .line 16
    .line 17
    invoke-virtual {v0}, Landroidx/activity/result/ActivityResultLauncher;->c()V

    .line 18
    .line 19
    :cond_0
    iget-object p0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->h:Lcom/xj/common/http/NetworkStatusDetector;

    .line 20
    .line 21
    if-nez p0, :cond_1

    .line 22
    .line 23
    const-string p0, "networkDetector"

    .line 24
    .line 25
    .line 26
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 27
    const/4 p0, 0x0

    .line 28
    .line 29
    .line 30
    :cond_1
    invoke-virtual {p0}, Lcom/xj/common/http/NetworkStatusDetector;->k()V

    .line 31
    return-void
.end method

.method public onInterceptKeyEvent(Landroid/view/KeyEvent;)Z
    .locals 3

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
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 9
    move-result-object v0

    .line 10
    .line 11
    check-cast v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 12
    .line 13
    iget-object v0, v0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->layoutUpdateData:Landroid/widget/FrameLayout;

    .line 14
    .line 15
    const-string v1, "layoutUpdateData"

    .line 16
    .line 17
    .line 18
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 19
    .line 20
    .line 21
    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    .line 22
    move-result v0

    .line 23
    const/4 v1, 0x1

    .line 24
    .line 25
    if-nez v0, :cond_0

    .line 26
    return v1

    .line 27
    .line 28
    .line 29
    :cond_0
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    .line 30
    move-result v0

    .line 31
    .line 32
    if-nez v0, :cond_1

    .line 33
    .line 34
    .line 35
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 36
    move-result v0

    .line 37
    .line 38
    const/16 v2, 0x64

    .line 39
    .line 40
    if-ne v0, v2, :cond_1

    .line 41
    .line 42
    .line 43
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->n3()V

    .line 44
    return v1

    .line 45
    .line 46
    .line 47
    :cond_1
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    .line 48
    move-result v0

    .line 49
    .line 50
    if-ne v0, v1, :cond_2

    .line 51
    .line 52
    .line 53
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 54
    move-result v0

    .line 55
    .line 56
    const/16 v2, 0x6c

    .line 57
    .line 58
    if-ne v0, v2, :cond_2

    .line 59
    .line 60
    .line 61
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->l3()V

    .line 62
    return v1

    .line 63
    .line 64
    .line 65
    :cond_2
    invoke-super {p0, p1}, Lcom/xj/base/base/activity/BaseVmActivity;->onInterceptKeyEvent(Landroid/view/KeyEvent;)Z

    .line 66
    move-result p0

    .line 67
    return p0
.end method

.method public onNewIntent(Landroid/content/Intent;)V
    .locals 2

    .line 1
    .line 2
    const-string v0, "intent"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-super {p0, p1}, Landroidx/activity/ComponentActivity;->onNewIntent(Landroid/content/Intent;)V

    .line 9
    .line 10
    const-wide/16 v0, 0x0

    .line 11
    .line 12
    .line 13
    invoke-virtual {p0, p1, v0, v1}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->H2(Landroid/content/Intent;J)V

    .line 14
    return-void
.end method

.method public onPause()V
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-super {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->onPause()V

    .line 4
    .line 5
    .line 6
    invoke-static {}, Lcom/shuyu/gsyvideoplayer/GSYVideoManager;->r()V

    .line 7
    const/4 v0, 0x0

    .line 8
    .line 9
    iput-boolean v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->i:Z

    .line 10
    .line 11
    sput-boolean v0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->r:Z

    .line 12
    return-void
.end method

.method public onResume()V
    .locals 6

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/utils/ApkUpdateUtils;->a:Lcom/xj/landscape/launcher/utils/ApkUpdateUtils;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0, p0}, Lcom/xj/landscape/launcher/utils/ApkUpdateUtils;->c(Landroidx/appcompat/app/AppCompatActivity;)V

    .line 6
    .line 7
    .line 8
    invoke-super {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->onResume()V

    # BannerHub: GOG pending launch check — p0 = this (Activity) here, before any p0 reassignment
    const-string v3, "bh_gog_prefs"
    const/4 v4, 0x0
    invoke-virtual {p0, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3
    const-string v4, "pending_gog_exe"
    const/4 v5, 0x0
    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :bh_no_gog_launch
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    const-string v5, "pending_gog_exe"
    invoke-interface {v3, v5}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V
    invoke-virtual {p0, v4}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->B3(Ljava/lang/String;)V
    :bh_no_gog_launch

    # BannerHub: Amazon pending launch check
    const-string v3, "bh_amazon_prefs"
    const/4 v4, 0x0
    invoke-virtual {p0, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3
    const-string v4, "pending_amazon_exe"
    const/4 v5, 0x0
    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :bh_no_amazon_launch
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    const-string v5, "pending_amazon_exe"
    invoke-interface {v3, v5}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V
    invoke-virtual {p0, v4}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->B3(Ljava/lang/String;)V
    :bh_no_amazon_launch

    # BannerHub: Epic pending launch check
    const-string v3, "bh_epic_prefs"
    const/4 v4, 0x0
    invoke-virtual {p0, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v3
    const-string v4, "pending_epic_exe"
    const/4 v5, 0x0
    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4
    if-eqz v4, :bh_no_epic_launch
    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    const-string v5, "pending_epic_exe"
    invoke-interface {v3, v5}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v3
    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V
    invoke-virtual {p0, v4}, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->B3(Ljava/lang/String;)V
    :bh_no_epic_launch

    .line 9
    const/4 v0, 0x1

    .line 10
    .line 11
    iput-boolean v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->i:Z

    .line 12
    .line 13
    sput-boolean v0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->r:Z

    .line 14
    .line 15
    .line 16
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMViewModel()Lcom/xj/base/base/viewmodel/BaseViewModel;

    .line 17
    move-result-object v0

    .line 18
    .line 19
    check-cast v0, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;

    .line 20
    .line 21
    .line 22
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/vm/NewLandscapeLauncherMainVM;->r()V

    .line 23
    .line 24
    sget-object v0, Lcom/xj/common/utils/BatteryUtil;->a:Lcom/xj/common/utils/BatteryUtil;

    .line 25
    .line 26
    .line 27
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 28
    move-result-object v1

    .line 29
    .line 30
    check-cast v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 31
    .line 32
    iget-object v1, v1, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->ivBatteryLevel:Landroid/widget/ImageView;

    .line 33
    .line 34
    const-string v2, "ivBatteryLevel"

    .line 35
    .line 36
    .line 37
    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 38
    .line 39
    .line 40
    invoke-virtual {v0, p0, v1}, Lcom/xj/common/utils/BatteryUtil;->a(Landroid/content/Context;Landroid/widget/ImageView;)V

    .line 41
    .line 42
    .line 43
    invoke-virtual {p0}, Lcom/xj/base/base/activity/BaseVmActivity;->getMDataBind()Landroidx/databinding/ViewDataBinding;

    .line 44
    move-result-object p0

    .line 45
    .line 46
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;

    .line 47
    .line 48
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherActivityNewLauncherMainBinding;->rightUserAvatarView:Lcom/xj/user/view/UserAvatarView;

    .line 49
    .line 50
    sget-object v0, Lcom/xj/common/user/UserManager;->INSTANCE:Lcom/xj/common/user/UserManager;

    .line 51
    .line 52
    .line 53
    invoke-virtual {v0}, Lcom/xj/common/user/UserManager;->getAvatar()Ljava/lang/String;

    .line 54
    move-result-object v0

    .line 55
    .line 56
    sget-object v1, Lcom/xj/landscape/launcher/utils/AvatarBgUtils;->a:Lcom/xj/landscape/launcher/utils/AvatarBgUtils;

    .line 57
    .line 58
    .line 59
    invoke-virtual {v1}, Lcom/xj/landscape/launcher/utils/AvatarBgUtils;->c()Ljava/lang/String;

    .line 60
    move-result-object v1

    .line 61
    .line 62
    .line 63
    invoke-virtual {p0, v0, v1}, Lcom/xj/user/view/UserAvatarView;->v(Ljava/lang/String;Ljava/lang/String;)V

    .line 64
    .line 65
    sget-object p0, Lcom/xj/common/trace/collectors/SteamEventCollector;->a:Lcom/xj/common/trace/collectors/SteamEventCollector;

    .line 66
    .line 67
    .line 68
    invoke-virtual {p0}, Lcom/xj/common/trace/collectors/SteamEventCollector;->k()V

    .line 69
    .line 70
    sget-object p0, Lcom/xj/common/trace/collectors/HudEventCollector;->a:Lcom/xj/common/trace/collectors/HudEventCollector;

    .line 71
    .line 72
    .line 73
    invoke-virtual {p0}, Lcom/xj/common/trace/collectors/HudEventCollector;->j()V

    .line 74
    return-void
.end method

.method public final p3()V
    .locals 2

    .line 1
    .line 2
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->p:Landroidx/activity/result/ActivityResultLauncher;

    .line 3
    .line 4
    if-eqz v0, :cond_0

    .line 5
    .line 6
    sget-object p0, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 7
    .line 8
    const-string v0, "no need registerSelectFileResult again"

    .line 9
    .line 10
    .line 11
    invoke-virtual {p0, v0}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 12
    return-void

    .line 13
    .line 14
    :cond_0
    new-instance v0, Lcom/xj/winemu/ui/fselector/WinEmuFileSelectorActivity$SelectFileActivityContract;

    .line 15
    .line 16
    .line 17
    invoke-direct {v0}, Lcom/xj/winemu/ui/fselector/WinEmuFileSelectorActivity$SelectFileActivityContract;-><init>()V

    .line 18
    .line 19
    new-instance v1, Lcom/xj/landscape/launcher/ui/main/f0;

    .line 20
    .line 21
    .line 22
    invoke-direct {v1, p0}, Lcom/xj/landscape/launcher/ui/main/f0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 23
    .line 24
    .line 25
    invoke-virtual {p0, v0, v1}, Landroidx/activity/ComponentActivity;->registerForActivityResult(Landroidx/activity/result/contract/ActivityResultContract;Landroidx/activity/result/ActivityResultCallback;)Landroidx/activity/result/ActivityResultLauncher;

    .line 26
    move-result-object v0

    .line 27
    .line 28
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;->p:Landroidx/activity/result/ActivityResultLauncher;

    .line 29
    return-void
.end method

.method public final r3()V
    .locals 17

    .line 1
    .line 2
    sget-object v0, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 3
    .line 4
    sget-object v1, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->a:Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;

    .line 5
    .line 6
    .line 7
    invoke-virtual {v1}, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->x()Z

    .line 8
    move-result v2

    .line 9
    .line 10
    .line 11
    invoke-virtual {v1}, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->s()Lcom/xj/bussiness/devicemanagement/entity/DeviceInfo;

    .line 12
    move-result-object v3

    .line 13
    .line 14
    new-instance v4, Ljava/lang/StringBuilder;

    .line 15
    .line 16
    .line 17
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    .line 18
    .line 19
    const-string v5, "retryLaunchGame: "

    .line 20
    .line 21
    .line 22
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 23
    .line 24
    .line 25
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 26
    .line 27
    const-string v2, " "

    .line 28
    .line 29
    .line 30
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 31
    .line 32
    .line 33
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 34
    .line 35
    .line 36
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 37
    move-result-object v2

    .line 38
    .line 39
    .line 40
    invoke-virtual {v0, v2}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 41
    .line 42
    .line 43
    invoke-virtual {v1}, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->t()I

    .line 44
    move-result v0

    .line 45
    .line 46
    if-nez v0, :cond_1

    .line 47
    .line 48
    .line 49
    invoke-virtual {v1}, Lcom/xj/bussiness/devicemanagement/utils/DeviceManager;->x()Z

    .line 50
    move-result v0

    .line 51
    .line 52
    if-eqz v0, :cond_1

    .line 53
    .line 54
    sget-object v0, Lcom/xj/landscape/launcher/launcher/AppLauncher;->a:Lcom/xj/landscape/launcher/launcher/AppLauncher;

    .line 55
    .line 56
    .line 57
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/launcher/AppLauncher;->j()Z

    .line 58
    move-result v1

    .line 59
    .line 60
    if-eqz v1, :cond_1

    .line 61
    const/4 v1, 0x0

    .line 62
    .line 63
    .line 64
    invoke-virtual {v0, v1}, Lcom/xj/landscape/launcher/launcher/AppLauncher;->r(Z)V

    .line 65
    .line 66
    .line 67
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/launcher/AppLauncher;->f()Lcom/xj/launch/strategy/api/LauncherConfig;

    .line 68
    move-result-object v1

    .line 69
    .line 70
    if-eqz v1, :cond_1

    .line 71
    .line 72
    new-instance v2, Lcom/xj/launch/strategy/api/LauncherConfig;

    .line 73
    .line 74
    .line 75
    invoke-virtual {v1}, Lcom/xj/launch/strategy/api/LauncherConfig;->h()I

    .line 76
    move-result v3

    .line 77
    .line 78
    .line 79
    invoke-virtual {v1}, Lcom/xj/launch/strategy/api/LauncherConfig;->i()Lcom/xj/common/service/bean/GameStartupParams;

    .line 80
    move-result-object v4

    .line 81
    .line 82
    .line 83
    invoke-virtual {v1}, Lcom/xj/launch/strategy/api/LauncherConfig;->j()Ljava/lang/String;

    .line 84
    move-result-object v5

    .line 85
    .line 86
    .line 87
    invoke-virtual {v1}, Lcom/xj/launch/strategy/api/LauncherConfig;->g()Ljava/lang/String;

    .line 88
    move-result-object v6

    .line 89
    .line 90
    .line 91
    invoke-virtual {v1}, Lcom/xj/launch/strategy/api/LauncherConfig;->k()Ljava/lang/String;

    .line 92
    move-result-object v7

    .line 93
    .line 94
    .line 95
    invoke-virtual {v1}, Lcom/xj/launch/strategy/api/LauncherConfig;->n()Ljava/util/List;

    .line 96
    move-result-object v8

    .line 97
    .line 98
    .line 99
    invoke-virtual {v1}, Lcom/xj/launch/strategy/api/LauncherConfig;->e()Ljava/util/List;

    .line 100
    move-result-object v9

    .line 101
    .line 102
    .line 103
    invoke-virtual {v1}, Lcom/xj/launch/strategy/api/LauncherConfig;->f()Lcom/xj/common/data/gameinfo/LauncherGameInfo;

    .line 104
    move-result-object v10

    .line 105
    .line 106
    const/16 v15, 0xf00

    .line 107
    .line 108
    const/16 v16, 0x0

    .line 109
    const/4 v11, 0x0

    .line 110
    const/4 v12, 0x0

    .line 111
    const/4 v13, 0x0

    .line 112
    const/4 v14, 0x0

    .line 113
    .line 114
    .line 115
    invoke-direct/range {v2 .. v16}, Lcom/xj/launch/strategy/api/LauncherConfig;-><init>(ILcom/xj/common/service/bean/GameStartupParams;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Ljava/util/List;Lcom/xj/common/data/gameinfo/LauncherGameInfo;Lcom/xj/common/bean/SteamGamePriceEntity;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function0;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 116
    .line 117
    .line 118
    invoke-virtual {v0, v2}, Lcom/xj/landscape/launcher/launcher/AppLauncher;->k(Lcom/xj/launch/strategy/api/LauncherConfig;)Lcom/xj/launch/strategy/api/LaunchResult;

    .line 119
    .line 120
    .line 121
    invoke-static {}, Lcom/blankj/utilcode/util/ActivityUtils;->h()Ljava/util/List;

    .line 122
    move-result-object v0

    .line 123
    .line 124
    const-string v1, "getActivityList(...)"

    .line 125
    .line 126
    .line 127
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 128
    .line 129
    .line 130
    invoke-interface {v0}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 131
    move-result-object v0

    .line 132
    .line 133
    .line 134
    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    .line 135
    move-result v1

    .line 136
    .line 137
    if-eqz v1, :cond_1

    .line 138
    .line 139
    .line 140
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 141
    move-result-object v1

    .line 142
    .line 143
    check-cast v1, Landroid/app/Activity;

    .line 144
    .line 145
    instance-of v2, v1, Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailActivity;

    .line 146
    .line 147
    if-eqz v2, :cond_0

    .line 148
    .line 149
    check-cast v1, Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailActivity;

    .line 150
    .line 151
    .line 152
    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailActivity;->t4()V

    .line 153
    goto :goto_0

    .line 154
    :cond_1
    return-void
.end method

.method public final s3()V
    .locals 0

    .line 1
    .line 2
    const-class p0, Lcom/xj/common/service/IPushService;

    .line 3
    .line 4
    .line 5
    invoke-static {p0}, Lcom/therouter/TheRouter;->b(Ljava/lang/Class;)Ljava/lang/Object;

    .line 6
    move-result-object p0

    .line 7
    .line 8
    check-cast p0, Lcom/xj/common/service/IPushService;

    .line 9
    .line 10
    if-eqz p0, :cond_0

    .line 11
    .line 12
    .line 13
    invoke-interface {p0}, Lcom/xj/common/service/IPushService;->a()V

    .line 14
    :cond_0
    return-void
.end method

.method public setVariableId()I
    .locals 0

    .line 1
    .line 2
    sget p0, Lcom/xj/landscape/launcher/BR;->c:I

    .line 3
    return p0
.end method

.method public final t3(Lcom/xj/landscape/launcher/ui/main/viewholders/FixedCardView;)V
    .locals 12

    .line 1
    .line 2
    const-string v0, "focusedView"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    sget-object v0, Lcom/xj/common/view/floatview/MenuFloatView;->o:Lcom/xj/common/view/floatview/MenuFloatView$Companion;

    .line 8
    .line 9
    .line 10
    invoke-virtual {v0, p0}, Lcom/xj/common/view/floatview/MenuFloatView$Companion;->c(Landroid/app/Activity;)Lcom/xj/common/view/floatview/MenuFloatView;

    .line 11
    move-result-object v0

    .line 12
    .line 13
    new-instance v1, Lcom/xj/common/view/floatview/MenuItem;

    .line 14
    .line 15
    sget-object v2, Lcom/xj/common/view/floatview/MenuIcon;->X:Lcom/xj/common/view/floatview/MenuIcon;

    .line 16
    .line 17
    sget v3, Lcom/xj/language/R$string;->llauncher_play_in_second:I

    .line 18
    .line 19
    new-instance v4, Lcom/xj/landscape/launcher/ui/main/h0;

    .line 20
    .line 21
    .line 22
    invoke-direct {v4, p1}, Lcom/xj/landscape/launcher/ui/main/h0;-><init>(Lcom/xj/landscape/launcher/ui/main/viewholders/FixedCardView;)V

    .line 23
    .line 24
    .line 25
    invoke-direct {v1, v2, v3, v4}, Lcom/xj/common/view/floatview/MenuItem;-><init>(Lcom/xj/common/view/floatview/MenuIcon;ILkotlin/jvm/functions/Function0;)V

    .line 26
    .line 27
    new-instance v5, Lcom/xj/common/view/floatview/MenuItem;

    .line 28
    .line 29
    sget-object v6, Lcom/xj/common/view/floatview/MenuIcon;->Y:Lcom/xj/common/view/floatview/MenuIcon;

    .line 30
    .line 31
    new-instance v8, Lcom/xj/landscape/launcher/ui/main/i0;

    .line 32
    .line 33
    .line 34
    invoke-direct {v8, p0}, Lcom/xj/landscape/launcher/ui/main/i0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 35
    const/4 v9, 0x2

    .line 36
    const/4 v10, 0x0

    .line 37
    const/4 v7, 0x0

    .line 38
    .line 39
    .line 40
    invoke-direct/range {v5 .. v10}, Lcom/xj/common/view/floatview/MenuItem;-><init>(Lcom/xj/common/view/floatview/MenuIcon;Ljava/lang/String;Lkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 41
    .line 42
    new-instance v6, Lcom/xj/common/view/floatview/MenuItem;

    .line 43
    .line 44
    sget-object v7, Lcom/xj/common/view/floatview/MenuIcon;->MENU:Lcom/xj/common/view/floatview/MenuIcon;

    .line 45
    .line 46
    new-instance v9, Lcom/xj/landscape/launcher/ui/main/j0;

    .line 47
    .line 48
    .line 49
    invoke-direct {v9, p0}, Lcom/xj/landscape/launcher/ui/main/j0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 50
    const/4 v10, 0x2

    .line 51
    const/4 v11, 0x0

    .line 52
    const/4 v8, 0x0

    .line 53
    .line 54
    .line 55
    invoke-direct/range {v6 .. v11}, Lcom/xj/common/view/floatview/MenuItem;-><init>(Lcom/xj/common/view/floatview/MenuIcon;Ljava/lang/String;Lkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 56
    .line 57
    .line 58
    filled-new-array {v1, v5, v6}, [Lcom/xj/common/view/floatview/MenuItem;

    .line 59
    move-result-object p0

    .line 60
    .line 61
    .line 62
    invoke-virtual {v0, p0}, Lcom/xj/common/view/floatview/MenuFloatView;->E([Lcom/xj/common/view/floatview/MenuItem;)Lcom/xj/common/view/floatview/MenuFloatView;

    .line 63
    return-void
.end method

.method public final x3()V
    .locals 8

    .line 1
    .line 2
    sget-object v0, Lcom/xj/common/view/floatview/MenuFloatView;->o:Lcom/xj/common/view/floatview/MenuFloatView$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0, p0}, Lcom/xj/common/view/floatview/MenuFloatView$Companion;->c(Landroid/app/Activity;)Lcom/xj/common/view/floatview/MenuFloatView;

    .line 6
    move-result-object v0

    .line 7
    .line 8
    new-instance v1, Lcom/xj/common/view/floatview/MenuItem;

    .line 9
    .line 10
    sget-object v2, Lcom/xj/common/view/floatview/MenuIcon;->Y:Lcom/xj/common/view/floatview/MenuIcon;

    .line 11
    .line 12
    new-instance v4, Lcom/xj/landscape/launcher/ui/main/e0;

    .line 13
    .line 14
    .line 15
    invoke-direct {v4, p0}, Lcom/xj/landscape/launcher/ui/main/e0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 16
    const/4 v5, 0x2

    .line 17
    const/4 v6, 0x0

    .line 18
    const/4 v3, 0x0

    .line 19
    .line 20
    .line 21
    invoke-direct/range {v1 .. v6}, Lcom/xj/common/view/floatview/MenuItem;-><init>(Lcom/xj/common/view/floatview/MenuIcon;Ljava/lang/String;Lkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 22
    .line 23
    new-instance v2, Lcom/xj/common/view/floatview/MenuItem;

    .line 24
    .line 25
    sget-object v3, Lcom/xj/common/view/floatview/MenuIcon;->MENU:Lcom/xj/common/view/floatview/MenuIcon;

    .line 26
    .line 27
    new-instance v5, Lcom/xj/landscape/launcher/ui/main/g0;

    .line 28
    .line 29
    .line 30
    invoke-direct {v5, p0}, Lcom/xj/landscape/launcher/ui/main/g0;-><init>(Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;)V

    .line 31
    const/4 v6, 0x2

    .line 32
    const/4 v7, 0x0

    .line 33
    const/4 v4, 0x0

    .line 34
    .line 35
    .line 36
    invoke-direct/range {v2 .. v7}, Lcom/xj/common/view/floatview/MenuItem;-><init>(Lcom/xj/common/view/floatview/MenuIcon;Ljava/lang/String;Lkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 37
    .line 38
    .line 39
    filled-new-array {v1, v2}, [Lcom/xj/common/view/floatview/MenuItem;

    .line 40
    move-result-object p0

    .line 41
    .line 42
    .line 43
    invoke-virtual {v0, p0}, Lcom/xj/common/view/floatview/MenuFloatView;->E([Lcom/xj/common/view/floatview/MenuItem;)Lcom/xj/common/view/floatview/MenuFloatView;

    .line 44
    return-void
.end method
