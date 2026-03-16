.class final Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;
.super Lkotlin/coroutines/jvm/internal/SuspendLambda;
.source "r8-map-id-712846b76e3224c0169ce621759774aea144e14d75c3fb3c733f7f2b03c1bb19"

# interfaces
.implements Lkotlin/jvm/functions/Function2;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/xj/winemu/settings/GameSettingViewModel;->n(ILkotlin/jvm/functions/Function1;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = null
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1$WhenMappings;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lkotlin/coroutines/jvm/internal/SuspendLambda;",
        "Lkotlin/jvm/functions/Function2<",
        "Lkotlinx/coroutines/CoroutineScope;",
        "Lkotlin/coroutines/Continuation<",
        "-",
        "Lkotlin/Unit;",
        ">;",
        "Ljava/lang/Object;",
        ">;"
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
.end annotation

.annotation runtime Lkotlin/coroutines/jvm/internal/DebugMetadata;
    c = "com.xj.winemu.settings.GameSettingViewModel$fetchList$1"
    f = "GameSettingViewModel.kt"
    l = {
        0x6a,
        0x6c,
        0xa3,
        0x104,
        0x112,
        0x123,
        0x133,
        0x143,
        0x153
    }
    m = "invokeSuspend"
.end annotation

.annotation build Lkotlin/jvm/internal/SourceDebugExtension;
.end annotation


# instance fields
.field final synthetic $callback:Lkotlin/jvm/functions/Function1;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lkotlin/jvm/functions/Function1<",
            "Lcom/xj/common/data/model/CommResultEntity<",
            "Ljava/util/List<",
            "Lcom/xj/winemu/bean/DialogSettingListItemEntity;",
            ">;>;",
            "Lkotlin/Unit;",
            ">;"
        }
    .end annotation
.end field

.field final synthetic $contentType:I

.field final synthetic $result:Lcom/xj/common/data/model/CommResultEntity;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcom/xj/common/data/model/CommResultEntity<",
            "Ljava/util/List<",
            "Lcom/xj/winemu/bean/DialogSettingListItemEntity;",
            ">;>;"
        }
    .end annotation
.end field

.field final synthetic $type:I

.field final synthetic $url:Lkotlin/jvm/internal/Ref$ObjectRef;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lkotlin/jvm/internal/Ref$ObjectRef<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private synthetic L$0:Ljava/lang/Object;

.field L$1:Ljava/lang/Object;

.field L$2:Ljava/lang/Object;

.field L$3:Ljava/lang/Object;

.field L$4:Ljava/lang/Object;

.field L$5:Ljava/lang/Object;

.field label:I

.field final synthetic this$0:Lcom/xj/winemu/settings/GameSettingViewModel;


# direct methods
.method public constructor <init>(Lkotlin/jvm/internal/Ref$ObjectRef;Lcom/xj/winemu/settings/GameSettingViewModel;IILcom/xj/common/data/model/CommResultEntity;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lkotlin/jvm/internal/Ref$ObjectRef<",
            "Ljava/lang/String;",
            ">;",
            "Lcom/xj/winemu/settings/GameSettingViewModel;",
            "II",
            "Lcom/xj/common/data/model/CommResultEntity<",
            "Ljava/util/List<",
            "Lcom/xj/winemu/bean/DialogSettingListItemEntity;",
            ">;>;",
            "Lkotlin/jvm/functions/Function1<",
            "-",
            "Lcom/xj/common/data/model/CommResultEntity<",
            "Ljava/util/List<",
            "Lcom/xj/winemu/bean/DialogSettingListItemEntity;",
            ">;>;",
            "Lkotlin/Unit;",
            ">;",
            "Lkotlin/coroutines/Continuation<",
            "-",
            "Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;",
            ">;)V"
        }
    .end annotation

    .line 1
    iput-object p1, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$url:Lkotlin/jvm/internal/Ref$ObjectRef;

    .line 2
    .line 3
    iput-object p2, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->this$0:Lcom/xj/winemu/settings/GameSettingViewModel;

    .line 4
    .line 5
    iput p3, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I

    .line 6
    .line 7
    iput p4, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$type:I

    .line 8
    .line 9
    iput-object p5, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;

    .line 10
    .line 11
    iput-object p6, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$callback:Lkotlin/jvm/functions/Function1;

    .line 12
    .line 13
    const/4 p1, 0x2

    .line 14
    invoke-direct {p0, p1, p7}, Lkotlin/coroutines/jvm/internal/SuspendLambda;-><init>(ILkotlin/coroutines/Continuation;)V

    .line 15
    .line 16
    .line 17
    return-void
.end method

.method public static synthetic a(Lcom/xj/winemu/bean/DialogSettingListItemEntity;)Z
    .locals 0

    .line 1
    invoke-static {p0}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->n(Lcom/xj/winemu/bean/DialogSettingListItemEntity;)Z

    .line 2
    .line 3
    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic e(Lcom/drake/net/request/BodyRequest;)Lkotlin/Unit;
    .locals 0

    .line 1
    invoke-static {p0}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->invokeSuspend$lambda$0(Lcom/drake/net/request/BodyRequest;)Lkotlin/Unit;

    .line 2
    .line 3
    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic g(Lcom/xj/winemu/bean/DialogSettingListItemEntity;)Z
    .locals 0

    .line 1
    invoke-static {p0}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->l(Lcom/xj/winemu/bean/DialogSettingListItemEntity;)Z

    .line 2
    .line 3
    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic h(Lkotlin/jvm/functions/Function1;Ljava/lang/Object;)Z
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->o(Lkotlin/jvm/functions/Function1;Ljava/lang/Object;)Z

    .line 2
    .line 3
    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic i(Lkotlin/jvm/functions/Function1;Ljava/lang/Object;)Z
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->m(Lkotlin/jvm/functions/Function1;Ljava/lang/Object;)Z

    .line 2
    .line 3
    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method private static final invokeSuspend$lambda$0(Lcom/drake/net/request/BodyRequest;)Lkotlin/Unit;
    .locals 3

    .line 1
    sget-object v0, Lcom/drake/net/cache/CacheMode;->REQUEST_THEN_READ:Lcom/drake/net/cache/CacheMode;

    .line 2
    .line 3
    invoke-virtual {p0, v0}, Lcom/drake/net/request/BaseRequest;->m(Lcom/drake/net/cache/CacheMode;)V

    .line 4
    .line 5
    .line 6
    new-instance v0, Lkotlin/Pair;

    .line 7
    .line 8
    sget-object v1, Lcom/xj/common/user/UserManager;->INSTANCE:Lcom/xj/common/user/UserManager;

    .line 9
    .line 10
    invoke-virtual {v1}, Lcom/xj/common/user/UserManager;->getToken()Ljava/lang/String;

    .line 11
    .line 12
    .line 13
    move-result-object v1

    .line 14
    const-string v2, "token"

    .line 15
    .line 16
    invoke-direct {v0, v2, v1}, Lkotlin/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 17
    .line 18
    .line 19
    invoke-static {v0}, Lkotlin/collections/MapsKt;->f(Lkotlin/Pair;)Ljava/util/Map;

    .line 20
    .line 21
    .line 22
    move-result-object v0

    .line 23
    invoke-virtual {p0, v0}, Lcom/drake/net/request/BodyRequest;->G(Ljava/util/Map;)V

    .line 24
    .line 25
    .line 26
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 27
    .line 28
    return-object p0
.end method

.method public static synthetic j(ILcom/drake/net/request/BodyRequest;)Lkotlin/Unit;
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->k(ILcom/drake/net/request/BodyRequest;)Lkotlin/Unit;

    .line 2
    .line 3
    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final k(ILcom/drake/net/request/BodyRequest;)Lkotlin/Unit;
    .locals 5

    .line 1
    sget-object v0, Lcom/drake/net/cache/CacheMode;->REQUEST_THEN_READ:Lcom/drake/net/cache/CacheMode;

    .line 2
    .line 3
    invoke-virtual {p1, v0}, Lcom/drake/net/request/BaseRequest;->m(Lcom/drake/net/cache/CacheMode;)V

    .line 4
    .line 5
    .line 6
    new-instance v0, Ljava/lang/StringBuilder;

    .line 7
    .line 8
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 9
    .line 10
    .line 11
    const-string v1, "getComponentList: type="

    .line 12
    .line 13
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 17
    .line 18
    .line 19
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 20
    .line 21
    .line 22
    move-result-object v0

    .line 23
    invoke-virtual {p1, v0}, Lcom/drake/net/request/BaseRequest;->l(Ljava/lang/String;)V

    .line 24
    .line 25
    .line 26
    new-instance v0, Lkotlin/Pair;

    .line 27
    .line 28
    sget-object v1, Lcom/xj/common/user/UserManager;->INSTANCE:Lcom/xj/common/user/UserManager;

    .line 29
    .line 30
    invoke-virtual {v1}, Lcom/xj/common/user/UserManager;->getToken()Ljava/lang/String;

    .line 31
    .line 32
    .line 33
    move-result-object v1

    .line 34
    const-string v2, "token"

    .line 35
    .line 36
    invoke-direct {v0, v2, v1}, Lkotlin/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 37
    .line 38
    .line 39
    new-instance v1, Lkotlin/Pair;

    .line 40
    .line 41
    const-string v2, "type"

    .line 42
    .line 43
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 44
    .line 45
    .line 46
    move-result-object p0

    .line 47
    invoke-direct {v1, v2, p0}, Lkotlin/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 48
    .line 49
    .line 50
    new-instance p0, Lkotlin/Pair;

    .line 51
    .line 52
    const/4 v2, 0x1

    .line 53
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 54
    .line 55
    .line 56
    move-result-object v2

    .line 57
    const-string v3, "page"

    .line 58
    .line 59
    invoke-direct {p0, v3, v2}, Lkotlin/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 60
    .line 61
    .line 62
    new-instance v2, Lkotlin/Pair;

    .line 63
    .line 64
    const/16 v3, 0xc8

    .line 65
    .line 66
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 67
    .line 68
    .line 69
    move-result-object v3

    .line 70
    const-string v4, "page_size"

    .line 71
    .line 72
    invoke-direct {v2, v4, v3}, Lkotlin/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 73
    .line 74
    .line 75
    filled-new-array {v0, v1, p0, v2}, [Lkotlin/Pair;

    .line 76
    .line 77
    .line 78
    move-result-object p0

    .line 79
    invoke-static {p0}, Lkotlin/collections/MapsKt;->l([Lkotlin/Pair;)Ljava/util/Map;

    .line 80
    .line 81
    .line 82
    move-result-object p0

    .line 83
    invoke-virtual {p1, p0}, Lcom/drake/net/request/BodyRequest;->G(Ljava/util/Map;)V

    .line 84
    .line 85
    .line 86
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 87
    .line 88
    return-object p0
.end method

.method public static final l(Lcom/xj/winemu/bean/DialogSettingListItemEntity;)Z
    .locals 4

    .line 1
    invoke-virtual {p0}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->getFileName()Ljava/lang/String;

    .line 2
    .line 3
    .line 4
    move-result-object p0

    .line 5
    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    .line 6
    .line 7
    invoke-virtual {p0, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    .line 8
    .line 9
    .line 10
    move-result-object p0

    .line 11
    const-string v0, "toLowerCase(...)"

    .line 12
    .line 13
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 14
    .line 15
    .line 16
    const/4 v0, 0x2

    .line 17
    const/4 v1, 0x0

    .line 18
    const-string v2, "box"

    .line 19
    .line 20
    const/4 v3, 0x0

    .line 21
    invoke-static {p0, v2, v3, v0, v1}, Lkotlin/text/StringsKt;->f0(Ljava/lang/String;Ljava/lang/String;ZILjava/lang/Object;)Z

    .line 22
    .line 23
    .line 24
    move-result p0

    .line 25
    return p0
.end method

.method public static final m(Lkotlin/jvm/functions/Function1;Ljava/lang/Object;)Z
    .locals 0

    .line 1
    invoke-interface {p0, p1}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    .line 2
    .line 3
    .line 4
    move-result-object p0

    .line 5
    check-cast p0, Ljava/lang/Boolean;

    .line 6
    .line 7
    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    .line 8
    .line 9
    .line 10
    move-result p0

    .line 11
    return p0
.end method

.method public static final n(Lcom/xj/winemu/bean/DialogSettingListItemEntity;)Z
    .locals 4

    .line 1
    invoke-virtual {p0}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->getFileName()Ljava/lang/String;

    .line 2
    .line 3
    .line 4
    move-result-object p0

    .line 5
    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    .line 6
    .line 7
    invoke-virtual {p0, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    .line 8
    .line 9
    .line 10
    move-result-object p0

    .line 11
    const-string v0, "toLowerCase(...)"

    .line 12
    .line 13
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 14
    .line 15
    .line 16
    const/4 v0, 0x2

    .line 17
    const/4 v1, 0x0

    .line 18
    const-string v2, "fex"

    .line 19
    .line 20
    const/4 v3, 0x0

    .line 21
    invoke-static {p0, v2, v3, v0, v1}, Lkotlin/text/StringsKt;->f0(Ljava/lang/String;Ljava/lang/String;ZILjava/lang/Object;)Z

    .line 22
    .line 23
    .line 24
    move-result p0

    .line 25
    return p0
.end method

.method public static final o(Lkotlin/jvm/functions/Function1;Ljava/lang/Object;)Z
    .locals 0

    .line 1
    invoke-interface {p0, p1}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    .line 2
    .line 3
    .line 4
    move-result-object p0

    .line 5
    check-cast p0, Ljava/lang/Boolean;

    .line 6
    .line 7
    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    .line 8
    .line 9
    .line 10
    move-result p0

    .line 11
    return p0
.end method


# virtual methods
.method public final create(Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Lkotlin/coroutines/Continuation;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Lkotlin/coroutines/Continuation<",
            "*>;)",
            "Lkotlin/coroutines/Continuation<",
            "Lkotlin/Unit;",
            ">;"
        }
    .end annotation

    .line 1
    new-instance v0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;

    .line 2
    .line 3
    iget-object v1, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$url:Lkotlin/jvm/internal/Ref$ObjectRef;

    .line 4
    .line 5
    iget-object v2, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->this$0:Lcom/xj/winemu/settings/GameSettingViewModel;

    .line 6
    .line 7
    iget v3, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I

    .line 8
    .line 9
    iget v4, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$type:I

    .line 10
    .line 11
    iget-object v5, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;

    .line 12
    .line 13
    iget-object v6, p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$callback:Lkotlin/jvm/functions/Function1;

    .line 14
    .line 15
    move-object v7, p2

    .line 16
    invoke-direct/range {v0 .. v7}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;-><init>(Lkotlin/jvm/internal/Ref$ObjectRef;Lcom/xj/winemu/settings/GameSettingViewModel;IILcom/xj/common/data/model/CommResultEntity;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)V

    .line 17
    .line 18
    .line 19
    iput-object p1, v0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    .line 20
    .line 21
    return-object v0
.end method

.method public bridge synthetic invoke(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 1
    check-cast p1, Lkotlinx/coroutines/CoroutineScope;

    check-cast p2, Lkotlin/coroutines/Continuation;

    invoke-virtual {p0, p1, p2}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->invoke(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public final invoke(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lkotlinx/coroutines/CoroutineScope;",
            "Lkotlin/coroutines/Continuation<",
            "-",
            "Lkotlin/Unit;",
            ">;)",
            "Ljava/lang/Object;"
        }
    .end annotation

    .line 2
    invoke-virtual {p0, p1, p2}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->create(Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Lkotlin/coroutines/Continuation;

    move-result-object p0

    check-cast p0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;

    sget-object p1, Lkotlin/Unit;->a:Lkotlin/Unit;

    invoke-virtual {p0, p1}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->invokeSuspend(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public final invokeSuspend(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 43

    move-object/from16 v5, p0

    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    move-object v6, v0

    check-cast v6, Lkotlinx/coroutines/CoroutineScope;

    invoke-static {}, Lkotlin/coroutines/intrinsics/IntrinsicsKt;->g()Ljava/lang/Object;

    move-result-object v12

    .line 1
    iget v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    const/4 v1, 0x0

    const/4 v13, 0x2

    const/4 v14, -0x1

    const-string v2, ""

    const/4 v15, 0x1

    const/4 v3, 0x0

    packed-switch v0, :pswitch_data_0

    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "call to \'resume\' before \'invoke\' with coroutine"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    :pswitch_0
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    check-cast v0, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/api/bean/Translator;

    iget-object v2, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    check-cast v2, Lkotlin/jvm/internal/Ref$IntRef;

    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    check-cast v4, Ljava/util/List;

    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    move-object v10, v0

    move-object v11, v3

    move-object/from16 v0, p1

    goto/16 :goto_1a

    :pswitch_1
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    check-cast v0, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/api/bean/Translator;

    iget-object v2, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    check-cast v2, Lkotlin/jvm/internal/Ref$IntRef;

    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    check-cast v4, Ljava/util/List;

    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    move-object v10, v0

    move-object v11, v3

    move-object/from16 v0, p1

    goto/16 :goto_18

    :pswitch_2
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    check-cast v0, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/api/bean/Translator;

    iget-object v2, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    check-cast v2, Lkotlin/jvm/internal/Ref$IntRef;

    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    check-cast v4, Ljava/util/List;

    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    move-object v10, v0

    move-object v11, v3

    move-object/from16 v0, p1

    goto/16 :goto_17

    :pswitch_3
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    check-cast v0, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/api/bean/Translator;

    iget-object v2, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    check-cast v2, Lkotlin/jvm/internal/Ref$IntRef;

    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    check-cast v4, Ljava/util/List;

    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    move-object v10, v0

    move-object v11, v3

    move-object/from16 v0, p1

    goto/16 :goto_16

    :pswitch_4
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    check-cast v0, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/api/bean/Translator;

    iget-object v2, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    check-cast v2, Lkotlin/jvm/internal/Ref$IntRef;

    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    check-cast v4, Ljava/util/List;

    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    move-object v10, v0

    move-object v11, v3

    move-object/from16 v0, p1

    goto/16 :goto_15

    :pswitch_5
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    check-cast v0, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/bean/PcSettingDataEntity;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    check-cast v1, Lcom/xj/winemu/api/bean/Translator;

    iget-object v2, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    check-cast v2, Lkotlin/jvm/internal/Ref$IntRef;

    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    check-cast v4, Ljava/util/List;

    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    move-object v10, v0

    move-object v11, v3

    move-object/from16 v0, p1

    goto/16 :goto_13

    :pswitch_6
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    check-cast v0, Ljava/util/List;

    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    move-object/from16 v4, p1

    goto/16 :goto_8

    :pswitch_7
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    check-cast v0, Ljava/util/List;

    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    check-cast v4, Ljava/util/List;

    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    move-object/from16 v7, p1

    goto/16 :goto_1

    :pswitch_8
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    check-cast v0, Ljava/util/List;

    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    move-object/from16 v4, p1

    goto :goto_0

    :pswitch_9
    invoke-static/range {p1 .. p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V

    .line 2
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 3
    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$url:Lkotlin/jvm/internal/Ref$ObjectRef;

    iget-object v4, v4, Lkotlin/jvm/internal/Ref$ObjectRef;->element:Ljava/lang/Object;

    check-cast v4, Ljava/lang/String;

    .line 4
    const-string v7, "simulator/v2/getContainerList"

    invoke-static {v4, v7}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_b

    .line 5
    new-instance v4, Lcom/xj/winemu/settings/g;

    invoke-direct {v4}, Lcom/xj/winemu/settings/g;-><init>()V

    .line 6
    new-instance v8, Lcom/drake/net/internal/NetDeferred;

    invoke-static {}, Lkotlinx/coroutines/Dispatchers;->b()Lkotlinx/coroutines/CoroutineDispatcher;

    move-result-object v9

    invoke-static {v3, v15, v3}, Lkotlinx/coroutines/SupervisorKt;->b(Lkotlinx/coroutines/Job;ILjava/lang/Object;)Lkotlinx/coroutines/CompletableJob;

    move-result-object v10

    invoke-virtual {v9, v10}, Lkotlin/coroutines/AbstractCoroutineContextElement;->plus(Lkotlin/coroutines/CoroutineContext;)Lkotlin/coroutines/CoroutineContext;

    move-result-object v9

    move-object v10, v9

    new-instance v9, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1$invokeSuspend$$inlined$Post$default$1;

    invoke-direct {v9, v7, v3, v4, v3}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1$invokeSuspend$$inlined$Post$default$1;-><init>(Ljava/lang/String;Ljava/lang/Object;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)V

    move-object v7, v10

    const/4 v10, 0x2

    const/4 v11, 0x0

    move-object v4, v8

    const/4 v8, 0x0

    invoke-static/range {v6 .. v11}, Lkotlinx/coroutines/BuildersKt;->b(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Deferred;

    move-result-object v7

    invoke-direct {v4, v7}, Lcom/drake/net/internal/NetDeferred;-><init>(Lkotlinx/coroutines/Deferred;)V

    .line 7
    invoke-static {v6}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    iput-object v7, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    iput-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    iput v15, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    invoke-interface {v4, v5}, Lkotlinx/coroutines/Deferred;->await(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object v4

    if-ne v4, v12, :cond_0

    goto/16 :goto_19

    .line 8
    :cond_0
    :goto_0
    check-cast v4, Ljava/util/List;

    .line 9
    const-class v7, Lcom/xj/common/service/ISteamGameService;

    invoke-static {v7}, Lcom/therouter/TheRouter;->b(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Lcom/xj/common/service/ISteamGameService;

    if-eqz v7, :cond_3

    .line 10
    iget-object v8, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->this$0:Lcom/xj/winemu/settings/GameSettingViewModel;

    invoke-virtual {v8}, Lcom/xj/winemu/settings/GameSettingViewModel;->t()Ljava/lang/String;

    move-result-object v8

    iget-object v9, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->this$0:Lcom/xj/winemu/settings/GameSettingViewModel;

    invoke-virtual {v9}, Lcom/xj/winemu/settings/GameSettingViewModel;->v()Ljava/lang/String;

    move-result-object v9

    invoke-static {v6}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    iput-object v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    iput-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    iput-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    iput v13, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    invoke-interface {v7, v8, v9, v5}, Lcom/xj/common/service/ISteamGameService;->D(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object v7

    if-ne v7, v12, :cond_1

    goto/16 :goto_19

    :cond_1
    move-object/from16 v42, v4

    move-object v4, v0

    move-object/from16 v0, v42

    :goto_1
    check-cast v7, Ljava/lang/Boolean;

    invoke-virtual {v7}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v7

    if-ne v7, v15, :cond_2

    move-object v7, v4

    move-object v4, v0

    move-object v0, v7

    move v7, v15

    goto :goto_2

    :cond_2
    move-object v7, v4

    move-object v4, v0

    move-object v0, v7

    :cond_3
    move v7, v1

    .line 11
    :goto_2
    invoke-interface {v4}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_3
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v8

    if-eqz v8, :cond_a

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v8

    move-object/from16 v36, v8

    check-cast v36, Lcom/xj/winemu/api/bean/EnvLayerEntity;

    if-eqz v7, :cond_7

    .line 12
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->isSteam()I

    move-result v8

    if-ne v8, v15, :cond_6

    .line 13
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getId()I

    move-result v17

    .line 14
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getName()Ljava/lang/String;

    move-result-object v20

    .line 15
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getFileMd5()Ljava/lang/String;

    move-result-object v26

    .line 16
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getFileSize()J

    move-result-wide v27

    .line 17
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getFileName()Ljava/lang/String;

    move-result-object v8

    if-nez v8, :cond_4

    move-object/from16 v29, v2

    goto :goto_4

    :cond_4
    move-object/from16 v29, v8

    .line 18
    :goto_4
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getDisplayName()Ljava/lang/String;

    move-result-object v8

    if-nez v8, :cond_5

    move-object/from16 v39, v2

    goto :goto_5

    :cond_5
    move-object/from16 v39, v8

    .line 19
    :goto_5
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getDownloadUrl()Ljava/lang/String;

    move-result-object v30

    .line 20
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getVersion()Ljava/lang/String;

    move-result-object v31

    .line 21
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getVersionCode()I

    move-result v32

    .line 22
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getLogo()Ljava/lang/String;

    move-result-object v33

    .line 23
    new-instance v16, Lcom/xj/winemu/bean/DialogSettingListItemEntity;

    const v40, 0x1b01f6

    const/16 v41, 0x0

    const/16 v18, 0x0

    const/16 v19, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    const/16 v23, 0x0

    const/16 v24, 0x0

    const/16 v25, 0x0

    const/16 v34, 0x0

    const/16 v35, 0x0

    const/16 v37, 0x0

    const/16 v38, 0x0

    invoke-direct/range {v16 .. v41}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;-><init>(IIZLjava/lang/String;Ljava/lang/String;IILjava/lang/String;ILjava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;IILcom/xj/winemu/api/bean/EnvLayerEntity;ZILjava/lang/String;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    move-object/from16 v8, v16

    .line 24
    invoke-interface {v0, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    move-result v8

    invoke-static {v8}, Lkotlin/coroutines/jvm/internal/Boxing;->a(Z)Ljava/lang/Boolean;

    goto :goto_3

    :cond_6
    sget-object v8, Lkotlin/Unit;->a:Lkotlin/Unit;

    goto :goto_3

    .line 25
    :cond_7
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getId()I

    move-result v17

    .line 26
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getName()Ljava/lang/String;

    move-result-object v20

    .line 27
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getFileMd5()Ljava/lang/String;

    move-result-object v26

    .line 28
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getFileSize()J

    move-result-wide v27

    .line 29
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getFileName()Ljava/lang/String;

    move-result-object v8

    if-nez v8, :cond_8

    move-object/from16 v29, v2

    goto :goto_6

    :cond_8
    move-object/from16 v29, v8

    .line 30
    :goto_6
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getDisplayName()Ljava/lang/String;

    move-result-object v8

    if-nez v8, :cond_9

    move-object/from16 v39, v2

    goto :goto_7

    :cond_9
    move-object/from16 v39, v8

    .line 31
    :goto_7
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getDownloadUrl()Ljava/lang/String;

    move-result-object v30

    .line 32
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getVersion()Ljava/lang/String;

    move-result-object v31

    .line 33
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getVersionCode()I

    move-result v32

    .line 34
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getLogo()Ljava/lang/String;

    move-result-object v33

    .line 35
    new-instance v16, Lcom/xj/winemu/bean/DialogSettingListItemEntity;

    const v40, 0x1b01f6

    const/16 v41, 0x0

    const/16 v18, 0x0

    const/16 v19, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    const/16 v23, 0x0

    const/16 v24, 0x0

    const/16 v25, 0x0

    const/16 v34, 0x0

    const/16 v35, 0x0

    const/16 v37, 0x0

    const/16 v38, 0x0

    invoke-direct/range {v16 .. v41}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;-><init>(IIZLjava/lang/String;Ljava/lang/String;IILjava/lang/String;ILjava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;IILcom/xj/winemu/api/bean/EnvLayerEntity;ZILjava/lang/String;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    move-object/from16 v8, v16

    .line 36
    invoke-interface {v0, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    move-result v8

    invoke-static {v8}, Lkotlin/coroutines/jvm/internal/Boxing;->a(Z)Ljava/lang/Boolean;

    goto/16 :goto_3

    :catch_0
    :cond_a
    move-object v7, v0

    goto/16 :goto_d

    .line 37
    :cond_b
    const-string v7, "simulator/v2/getComponentList"

    invoke-static {v4, v7}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_a

    .line 38
    iget v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$type:I

    new-instance v8, Lcom/xj/winemu/settings/h;

    invoke-direct {v8, v4}, Lcom/xj/winemu/settings/h;-><init>(I)V

    .line 39
    new-instance v4, Lcom/drake/net/internal/NetDeferred;

    invoke-static {}, Lkotlinx/coroutines/Dispatchers;->b()Lkotlinx/coroutines/CoroutineDispatcher;

    move-result-object v9

    invoke-static {v3, v15, v3}, Lkotlinx/coroutines/SupervisorKt;->b(Lkotlinx/coroutines/Job;ILjava/lang/Object;)Lkotlinx/coroutines/CompletableJob;

    move-result-object v10

    invoke-virtual {v9, v10}, Lkotlin/coroutines/AbstractCoroutineContextElement;->plus(Lkotlin/coroutines/CoroutineContext;)Lkotlin/coroutines/CoroutineContext;

    move-result-object v9

    move-object v10, v9

    new-instance v9, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1$invokeSuspend$$inlined$Post$default$2;

    invoke-direct {v9, v7, v3, v8, v3}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1$invokeSuspend$$inlined$Post$default$2;-><init>(Ljava/lang/String;Ljava/lang/Object;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)V

    move-object v7, v10

    const/4 v10, 0x2

    const/4 v11, 0x0

    const/4 v8, 0x0

    invoke-static/range {v6 .. v11}, Lkotlinx/coroutines/BuildersKt;->b(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Deferred;

    move-result-object v7

    invoke-direct {v4, v7}, Lcom/drake/net/internal/NetDeferred;-><init>(Lkotlinx/coroutines/Deferred;)V

    .line 40
    invoke-static {v6}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    iput-object v7, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    iput-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    const/4 v7, 0x3

    iput v7, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    invoke-interface {v4, v5}, Lkotlinx/coroutines/Deferred;->await(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object v4

    if-ne v4, v12, :cond_c

    goto/16 :goto_19

    .line 41
    :cond_c
    :goto_8
    check-cast v4, Ljava/lang/String;

    .line 42
    :try_start_0
    new-instance v7, Lorg/json/JSONObject;

    invoke-direct {v7, v4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 43
    const-string v4, "data"

    invoke-virtual {v7, v4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v4

    const-string v7, "list"

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 44
    new-instance v7, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1$componentList$2;

    invoke-direct {v7}, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1$componentList$2;-><init>()V

    invoke-virtual {v7}, Lcom/google/gson/reflect/TypeToken;->getType()Ljava/lang/reflect/Type;

    move-result-object v7

    .line 45
    invoke-static {v4, v7}, Lcom/blankj/utilcode/util/GsonUtils;->e(Ljava/lang/String;Ljava/lang/reflect/Type;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/util/List;

    .line 46
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 47
    invoke-interface {v4}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_9
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_a

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    move-object/from16 v36, v7

    check-cast v36, Lcom/xj/winemu/api/bean/EnvLayerEntity;

    .line 48
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getId()I

    move-result v17

    .line 49
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getName()Ljava/lang/String;

    move-result-object v20

    .line 50
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getBlurb()Ljava/lang/String;

    move-result-object v7

    if-nez v7, :cond_d

    move-object/from16 v21, v2

    goto :goto_a

    :cond_d
    move-object/from16 v21, v7

    .line 51
    :goto_a
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getFileMd5()Ljava/lang/String;

    move-result-object v26

    .line 52
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getFileSize()J

    move-result-wide v27

    .line 53
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getFileName()Ljava/lang/String;

    move-result-object v7

    if-nez v7, :cond_e

    move-object/from16 v29, v2

    goto :goto_b

    :cond_e
    move-object/from16 v29, v7

    .line 54
    :goto_b
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getDisplayName()Ljava/lang/String;

    move-result-object v7

    if-nez v7, :cond_f

    move-object/from16 v39, v2

    goto :goto_c

    :cond_f
    move-object/from16 v39, v7

    .line 55
    :goto_c
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getDownloadUrl()Ljava/lang/String;

    move-result-object v30

    .line 56
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getVersion()Ljava/lang/String;

    move-result-object v31

    .line 57
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getVersionCode()I

    move-result v32

    .line 58
    invoke-virtual/range {v36 .. v36}, Lcom/xj/winemu/api/bean/EnvLayerEntity;->getLogo()Ljava/lang/String;

    move-result-object v33

    .line 59
    new-instance v16, Lcom/xj/winemu/bean/DialogSettingListItemEntity;

    const v40, 0x1b01e6

    const/16 v41, 0x0

    const/16 v18, 0x0

    const/16 v19, 0x0

    const/16 v22, 0x0

    const/16 v23, 0x0

    const/16 v24, 0x0

    const/16 v25, 0x0

    const/16 v34, 0x0

    const/16 v35, 0x0

    const/16 v37, 0x0

    const/16 v38, 0x0

    invoke-direct/range {v16 .. v41}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;-><init>(IIZLjava/lang/String;Ljava/lang/String;IILjava/lang/String;ILjava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;IILcom/xj/winemu/api/bean/EnvLayerEntity;ZILjava/lang/String;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    move-object/from16 v7, v16

    .line 60
    invoke-interface {v0, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_9

    .line 61
    :goto_d
    iget v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I

    sget-object v2, Lcom/xj/winemu/bean/PcSettingItemEntity;->Companion:Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;

    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_GPU_DRIVER()I

    move-result v4

    const-string v8, "getString(...)"

    if-ne v0, v4, :cond_10

    .line 62
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object v0

    sget v4, Lcom/xj/language/R$string;->pc_gpu_official_driver:I

    invoke-virtual {v0, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v8}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 63
    new-instance v16, Lcom/xj/winemu/bean/DialogSettingListItemEntity;

    const v40, 0x3ffff2

    const/16 v41, 0x0

    const/16 v17, -0x1

    const/16 v18, 0x0

    const/16 v19, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    const/16 v23, 0x0

    const/16 v24, 0x0

    const/16 v25, 0x0

    const/16 v26, 0x0

    const-wide/16 v27, 0x0

    const/16 v29, 0x0

    const/16 v30, 0x0

    const/16 v31, 0x0

    const/16 v32, 0x0

    const/16 v33, 0x0

    const/16 v34, 0x0

    const/16 v35, 0x0

    const/16 v36, 0x0

    const/16 v37, 0x0

    const/16 v38, 0x0

    const/16 v39, 0x0

    move-object/from16 v20, v0

    invoke-direct/range {v16 .. v41}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;-><init>(IIZLjava/lang/String;Ljava/lang/String;IILjava/lang/String;ILjava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;IILcom/xj/winemu/api/bean/EnvLayerEntity;ZILjava/lang/String;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    move-object/from16 v0, v16

    .line 64
    invoke-interface {v7, v1, v0}, Ljava/util/List;->add(ILjava/lang/Object;)V

    goto :goto_e

    .line 65
    :cond_10
    iget v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I

    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_STEAM_CLIENT()I

    move-result v4

    if-ne v0, v4, :cond_11

    .line 66
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    move-result-object v0

    sget v4, Lcom/xj/language/R$string;->pc_cc_steam_version_default:I

    invoke-virtual {v0, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v8}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 67
    new-instance v16, Lcom/xj/winemu/bean/DialogSettingListItemEntity;

    const v40, 0x3ffff2

    const/16 v41, 0x0

    const/16 v17, -0x1

    const/16 v18, 0x0

    const/16 v19, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    const/16 v23, 0x0

    const/16 v24, 0x0

    const/16 v25, 0x0

    const/16 v26, 0x0

    const-wide/16 v27, 0x0

    const/16 v29, 0x0

    const/16 v30, 0x0

    const/16 v31, 0x0

    const/16 v32, 0x0

    const/16 v33, 0x0

    const/16 v34, 0x0

    const/16 v35, 0x0

    const/16 v36, 0x0

    const/16 v37, 0x0

    const/16 v38, 0x0

    const/16 v39, 0x0

    move-object/from16 v20, v0

    invoke-direct/range {v16 .. v41}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;-><init>(IIZLjava/lang/String;Ljava/lang/String;IILjava/lang/String;ILjava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;IILcom/xj/winemu/api/bean/EnvLayerEntity;ZILjava/lang/String;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    move-object/from16 v0, v16

    .line 68
    invoke-interface {v7, v1, v0}, Ljava/util/List;->add(ILjava/lang/Object;)V

    .line 69
    :cond_11
    :goto_e
    new-instance v8, Lkotlin/jvm/internal/Ref$IntRef;

    invoke-direct {v8}, Lkotlin/jvm/internal/Ref$IntRef;-><init>()V

    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->this$0:Lcom/xj/winemu/settings/GameSettingViewModel;

    iget v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I

    invoke-static {v0, v1}, Lcom/xj/winemu/settings/GameSettingViewModel;->m(Lcom/xj/winemu/settings/GameSettingViewModel;I)Z

    move-result v0

    const/16 v1, -0x63

    if-eqz v0, :cond_13

    :cond_12
    move v0, v1

    goto :goto_f

    .line 70
    :cond_13
    sget-object v0, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->a:Lcom/xj/winemu/settings/PcGameSettingDataHelper;

    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->this$0:Lcom/xj/winemu/settings/GameSettingViewModel;

    invoke-virtual {v4}, Lcom/xj/winemu/settings/GameSettingViewModel;->t()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->q(Ljava/lang/String;)Lcom/blankj/utilcode/util/SPUtils;

    move-result-object v4

    .line 71
    iget v9, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I

    .line 72
    invoke-static {v0, v9, v3, v13, v3}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->A(Lcom/xj/winemu/settings/PcGameSettingDataHelper;ILjava/lang/String;ILjava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 73
    invoke-virtual {v4, v0}, Lcom/blankj/utilcode/util/SPUtils;->j(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 74
    const-class v4, Lcom/xj/winemu/bean/PcSettingDataEntity;

    .line 75
    invoke-static {v0, v4}, Lcom/blankj/utilcode/util/GsonUtils;->d(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/xj/winemu/bean/PcSettingDataEntity;

    if-eqz v0, :cond_12

    .line 76
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v0

    .line 77
    :goto_f
    iput v0, v8, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    .line 78
    sget-object v0, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->a:Lcom/xj/winemu/settings/PcGameSettingDataHelper;

    iget-object v4, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->this$0:Lcom/xj/winemu/settings/GameSettingViewModel;

    invoke-virtual {v4}, Lcom/xj/winemu/settings/GameSettingViewModel;->t()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->v(Ljava/lang/String;)Lcom/xj/winemu/settings/PcGameSettingOperations;

    move-result-object v4

    invoke-virtual {v4}, Lcom/xj/winemu/settings/PcGameSettingOperations;->s0()Lcom/xj/winemu/bean/PcSettingDataEntity;

    move-result-object v4

    if-eqz v4, :cond_15

    .line 79
    const-string v9, "X64"

    invoke-virtual {v4}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getFramework()Ljava/lang/String;

    move-result-object v10

    invoke-static {v9, v10}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v9

    if-eqz v9, :cond_14

    .line 80
    sget-object v9, Lcom/xj/winemu/api/bean/Translator;->Box64:Lcom/xj/winemu/api/bean/Translator;

    goto :goto_10

    .line 81
    :cond_14
    sget-object v9, Lcom/xj/winemu/api/bean/Translator;->FEX:Lcom/xj/winemu/api/bean/Translator;

    goto :goto_10

    :cond_15
    move-object v9, v3

    .line 82
    :goto_10
    iget v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I

    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_TRANSLATOR()I

    move-result v11

    if-ne v10, v11, :cond_1a

    if-nez v9, :cond_16

    move v10, v14

    goto :goto_11

    .line 83
    :cond_16
    sget-object v10, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1$WhenMappings;->a:[I

    invoke-virtual {v9}, Ljava/lang/Enum;->ordinal()I

    move-result v11

    aget v10, v10, v11

    :goto_11
    if-eq v10, v14, :cond_17

    if-eq v10, v15, :cond_19

    if-ne v10, v13, :cond_18

    .line 84
    iget-object v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->this$0:Lcom/xj/winemu/settings/GameSettingViewModel;

    invoke-virtual {v10}, Lcom/xj/winemu/settings/GameSettingViewModel;->t()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->v(Ljava/lang/String;)Lcom/xj/winemu/settings/PcGameSettingOperations;

    move-result-object v10

    invoke-virtual {v10}, Lcom/xj/winemu/settings/PcGameSettingOperations;->r()Lcom/xj/winemu/bean/PcSettingDataEntity;

    move-result-object v10

    if-eqz v10, :cond_17

    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v10

    goto :goto_12

    :cond_17
    move v10, v1

    goto :goto_12

    .line 85
    :cond_18
    new-instance v0, Lkotlin/NoWhenBranchMatchedException;

    invoke-direct {v0}, Lkotlin/NoWhenBranchMatchedException;-><init>()V

    throw v0

    .line 86
    :cond_19
    iget-object v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->this$0:Lcom/xj/winemu/settings/GameSettingViewModel;

    invoke-virtual {v10}, Lcom/xj/winemu/settings/GameSettingViewModel;->t()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->v(Ljava/lang/String;)Lcom/xj/winemu/settings/PcGameSettingOperations;

    move-result-object v10

    invoke-virtual {v10}, Lcom/xj/winemu/settings/PcGameSettingOperations;->Z()Lcom/xj/winemu/bean/PcSettingDataEntity;

    move-result-object v10

    if-eqz v10, :cond_17

    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v10

    .line 87
    :goto_12
    iput v10, v8, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    .line 88
    :cond_1a
    iget v10, v8, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    if-ne v10, v1, :cond_1d

    .line 89
    iget v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I

    .line 90
    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_CONTAINER_LIST()I

    move-result v10

    if-ne v1, v10, :cond_1e

    .line 91
    invoke-virtual {v0}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->i()Lcom/xj/winemu/bean/PcSettingDataEntity;

    move-result-object v10

    if-eqz v10, :cond_1d

    .line 92
    sget-object v0, Lcom/xj/winemu/download/WinEmuFileExplorer;->a:Lcom/xj/winemu/download/WinEmuFileExplorer;

    .line 93
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v1

    .line 94
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getName()Ljava/lang/String;

    move-result-object v2

    move-object v11, v3

    .line 95
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getFileName()Ljava/lang/String;

    move-result-object v3

    move-object/from16 v16, v4

    .line 96
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getVersion()Ljava/lang/String;

    move-result-object v4

    .line 97
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getFileMd5()Ljava/lang/String;

    move-result-object v17

    .line 98
    invoke-static {v6}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    iput-object v7, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    iput-object v8, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    iput-object v9, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    invoke-static/range {v16 .. v16}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    iput-object v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    const/4 v6, 0x4

    iput v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    move-object v6, v5

    move-object/from16 v5, v17

    invoke-virtual/range {v0 .. v6}, Lcom/xj/winemu/download/WinEmuFileExplorer;->C(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object v0

    move-object v5, v6

    if-ne v0, v12, :cond_1b

    goto/16 :goto_19

    :cond_1b
    move-object v4, v7

    move-object v2, v8

    move-object v1, v9

    :goto_13
    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_1c

    .line 99
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v0

    iput v0, v2, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    :cond_1c
    :goto_14
    move-object v9, v1

    move-object v8, v2

    move-object v7, v4

    goto/16 :goto_1b

    :cond_1d
    move-object v11, v3

    goto/16 :goto_1b

    :cond_1e
    move-object v11, v3

    move-object/from16 v16, v4

    .line 100
    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_GPU_DRIVER()I

    move-result v3

    if-ne v1, v3, :cond_22

    .line 101
    invoke-virtual {v0}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->l()Lcom/xj/winemu/bean/PcSettingDataEntity;

    move-result-object v10

    if-eqz v10, :cond_21

    .line 102
    sget-object v0, Lcom/xj/winemu/download/WinEmuFileExplorer;->a:Lcom/xj/winemu/download/WinEmuFileExplorer;

    .line 103
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v1

    .line 104
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getName()Ljava/lang/String;

    move-result-object v2

    .line 105
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getFileName()Ljava/lang/String;

    move-result-object v3

    .line 106
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getVersion()Ljava/lang/String;

    move-result-object v4

    .line 107
    invoke-static {v6}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    iput-object v7, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    iput-object v8, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    iput-object v9, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    invoke-static/range {v16 .. v16}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    iput-object v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    const/4 v6, 0x5

    iput v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    invoke-virtual/range {v0 .. v5}, Lcom/xj/winemu/download/WinEmuFileExplorer;->z(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object v0

    if-ne v0, v12, :cond_1f

    goto/16 :goto_19

    :cond_1f
    move-object v4, v7

    move-object v2, v8

    move-object v1, v9

    :goto_15
    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_20

    .line 108
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v0

    iput v0, v2, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    goto :goto_14

    :cond_20
    move-object v9, v1

    move-object v8, v2

    move-object v7, v4

    .line 109
    :cond_21
    iput v14, v8, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    goto/16 :goto_1b

    .line 110
    :cond_22
    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_STEAM_CLIENT()I

    move-result v3

    if-ne v1, v3, :cond_24

    .line 111
    invoke-virtual {v0}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->m()Lcom/xj/winemu/bean/PcSettingDataEntity;

    move-result-object v10

    if-eqz v10, :cond_2a

    .line 112
    sget-object v0, Lcom/xj/winemu/download/WinEmuFileExplorer;->a:Lcom/xj/winemu/download/WinEmuFileExplorer;

    .line 113
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v1

    .line 114
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getName()Ljava/lang/String;

    move-result-object v2

    .line 115
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getFileName()Ljava/lang/String;

    move-result-object v3

    .line 116
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getVersion()Ljava/lang/String;

    move-result-object v4

    .line 117
    invoke-static {v6}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    iput-object v7, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    iput-object v8, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    iput-object v9, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    invoke-static/range {v16 .. v16}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    iput-object v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    const/4 v6, 0x6

    iput v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    invoke-virtual/range {v0 .. v5}, Lcom/xj/winemu/download/WinEmuFileExplorer;->z(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object v0

    if-ne v0, v12, :cond_23

    goto/16 :goto_19

    :cond_23
    move-object v4, v7

    move-object v2, v8

    move-object v1, v9

    :goto_16
    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_1c

    .line 118
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v0

    iput v0, v2, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    goto/16 :goto_14

    .line 119
    :cond_24
    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_DXVK()I

    move-result v3

    if-ne v1, v3, :cond_26

    .line 120
    invoke-virtual {v0}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->k()Lcom/xj/winemu/bean/PcSettingDataEntity;

    move-result-object v10

    if-eqz v10, :cond_2a

    .line 121
    sget-object v0, Lcom/xj/winemu/download/WinEmuFileExplorer;->a:Lcom/xj/winemu/download/WinEmuFileExplorer;

    .line 122
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v1

    .line 123
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getName()Ljava/lang/String;

    move-result-object v2

    .line 124
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getFileName()Ljava/lang/String;

    move-result-object v3

    .line 125
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getVersion()Ljava/lang/String;

    move-result-object v4

    .line 126
    invoke-static {v6}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    iput-object v7, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    iput-object v8, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    iput-object v9, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    invoke-static/range {v16 .. v16}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    iput-object v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    const/4 v6, 0x7

    iput v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    invoke-virtual/range {v0 .. v5}, Lcom/xj/winemu/download/WinEmuFileExplorer;->z(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object v0

    if-ne v0, v12, :cond_25

    goto/16 :goto_19

    :cond_25
    move-object v4, v7

    move-object v2, v8

    move-object v1, v9

    :goto_17
    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_1c

    .line 127
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v0

    iput v0, v2, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    goto/16 :goto_14

    .line 128
    :cond_26
    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_VKD3D()I

    move-result v3

    if-ne v1, v3, :cond_28

    .line 129
    invoke-virtual {v0}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->p()Lcom/xj/winemu/bean/PcSettingDataEntity;

    move-result-object v10

    if-eqz v10, :cond_2a

    .line 130
    sget-object v0, Lcom/xj/winemu/download/WinEmuFileExplorer;->a:Lcom/xj/winemu/download/WinEmuFileExplorer;

    .line 131
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v1

    .line 132
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getName()Ljava/lang/String;

    move-result-object v2

    .line 133
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getFileName()Ljava/lang/String;

    move-result-object v3

    .line 134
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getVersion()Ljava/lang/String;

    move-result-object v4

    .line 135
    invoke-static {v6}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    iput-object v7, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    iput-object v8, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    iput-object v9, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    invoke-static/range {v16 .. v16}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    iput-object v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    const/16 v6, 0x8

    iput v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    invoke-virtual/range {v0 .. v5}, Lcom/xj/winemu/download/WinEmuFileExplorer;->z(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object v0

    if-ne v0, v12, :cond_27

    goto :goto_19

    :cond_27
    move-object v4, v7

    move-object v2, v8

    move-object v1, v9

    :goto_18
    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_1c

    .line 136
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v0

    iput v0, v2, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    goto/16 :goto_14

    .line 137
    :cond_28
    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_TRANSLATOR()I

    move-result v2

    if-ne v1, v2, :cond_2a

    .line 138
    invoke-virtual {v0}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->o()Lcom/xj/winemu/bean/PcSettingDataEntity;

    move-result-object v10

    if-eqz v10, :cond_2a

    .line 139
    sget-object v0, Lcom/xj/winemu/download/WinEmuFileExplorer;->a:Lcom/xj/winemu/download/WinEmuFileExplorer;

    .line 140
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v1

    .line 141
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getName()Ljava/lang/String;

    move-result-object v2

    .line 142
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getFileName()Ljava/lang/String;

    move-result-object v3

    .line 143
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getVersion()Ljava/lang/String;

    move-result-object v4

    .line 144
    invoke-static {v6}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$0:Ljava/lang/Object;

    iput-object v7, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$1:Ljava/lang/Object;

    iput-object v8, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$2:Ljava/lang/Object;

    iput-object v9, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$3:Ljava/lang/Object;

    invoke-static/range {v16 .. v16}, Lkotlin/coroutines/jvm/internal/SpillingKt;->a(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    iput-object v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$4:Ljava/lang/Object;

    iput-object v10, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->L$5:Ljava/lang/Object;

    const/16 v6, 0x9

    iput v6, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->label:I

    invoke-virtual/range {v0 .. v5}, Lcom/xj/winemu/download/WinEmuFileExplorer;->z(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object v0

    if-ne v0, v12, :cond_29

    :goto_19
    return-object v12

    :cond_29
    move-object v4, v7

    move-object v2, v8

    move-object v1, v9

    :goto_1a
    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eqz v0, :cond_1c

    .line 145
    invoke-virtual {v10}, Lcom/xj/winemu/bean/PcSettingDataEntity;->getId()I

    move-result v0

    iput v0, v2, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    goto/16 :goto_14

    .line 146
    :cond_2a
    :goto_1b
    iget v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I

    sget-object v1, Lcom/xj/winemu/bean/PcSettingItemEntity;->Companion:Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;

    invoke-virtual {v1}, Lcom/xj/winemu/bean/PcSettingItemEntity$Companion;->getCONTENT_TYPE_TRANSLATOR()I

    move-result v1

    if-ne v0, v1, :cond_2f

    if-nez v9, :cond_2b

    move v0, v14

    goto :goto_1c

    .line 147
    :cond_2b
    sget-object v0, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1$WhenMappings;->a:[I

    invoke-virtual {v9}, Ljava/lang/Enum;->ordinal()I

    move-result v1

    aget v0, v0, v1

    :goto_1c
    if-eq v0, v14, :cond_2e

    if-eq v0, v15, :cond_2d

    if-ne v0, v13, :cond_2c

    .line 148
    new-instance v0, Lcom/xj/winemu/settings/k;

    invoke-direct {v0}, Lcom/xj/winemu/settings/k;-><init>()V

    new-instance v1, Lcom/xj/winemu/settings/l;

    invoke-direct {v1, v0}, Lcom/xj/winemu/settings/l;-><init>(Lkotlin/jvm/functions/Function1;)V

    invoke-interface {v7, v1}, Ljava/util/Collection;->removeIf(Ljava/util/function/Predicate;)Z

    move-result v0

    invoke-static {v0}, Lkotlin/coroutines/jvm/internal/Boxing;->a(Z)Ljava/lang/Boolean;

    goto :goto_1d

    .line 149
    :cond_2c
    new-instance v0, Lkotlin/NoWhenBranchMatchedException;

    invoke-direct {v0}, Lkotlin/NoWhenBranchMatchedException;-><init>()V

    throw v0

    .line 150
    :cond_2d
    new-instance v0, Lcom/xj/winemu/settings/i;

    invoke-direct {v0}, Lcom/xj/winemu/settings/i;-><init>()V

    new-instance v1, Lcom/xj/winemu/settings/j;

    invoke-direct {v1, v0}, Lcom/xj/winemu/settings/j;-><init>(Lkotlin/jvm/functions/Function1;)V

    invoke-interface {v7, v1}, Ljava/util/Collection;->removeIf(Ljava/util/function/Predicate;)Z

    .line 151
    invoke-interface {v7}, Ljava/util/List;->size()I

    move-result v0

    new-instance v16, Lcom/xj/winemu/bean/DialogSettingListItemEntity;

    iget v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$type:I

    sget v2, Lcom/xj/language/R$string;->winemu_select_dialog_translator_none:I

    invoke-static {v2}, Lcom/xj/common/utils/LLExtKt;->j(I)Ljava/lang/String;

    move-result-object v20

    const v40, 0x37fff4

    const/16 v41, 0x0

    const/16 v17, -0x1

    const/16 v19, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    const/16 v23, 0x0

    const/16 v24, 0x0

    const/16 v25, 0x0

    const/16 v26, 0x0

    const-wide/16 v27, 0x0

    const/16 v29, 0x0

    const/16 v30, 0x0

    const/16 v31, 0x0

    const/16 v32, 0x0

    const/16 v33, 0x0

    const/16 v34, 0x0

    const/16 v35, 0x0

    const/16 v36, 0x0

    const/16 v37, 0x1

    const/16 v38, 0x0

    const/16 v39, 0x0

    move/from16 v18, v1

    invoke-direct/range {v16 .. v41}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;-><init>(IIZLjava/lang/String;Ljava/lang/String;IILjava/lang/String;ILjava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;IILcom/xj/winemu/api/bean/EnvLayerEntity;ZILjava/lang/String;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    move-object/from16 v1, v16

    invoke-interface {v7, v0, v1}, Ljava/util/List;->add(ILjava/lang/Object;)V

    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    goto :goto_1d

    .line 152
    :cond_2e
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 153
    :cond_2f
    :goto_1d
    invoke-interface {v7}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_30
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_31

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    move-object v1, v3

    check-cast v1, Lcom/xj/winemu/bean/DialogSettingListItemEntity;

    invoke-virtual {v1}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->getId()I

    move-result v1

    iget v2, v8, Lkotlin/jvm/internal/Ref$IntRef;->element:I

    if-ne v1, v2, :cond_30

    goto :goto_1e

    :cond_31
    move-object v3, v11

    :goto_1e
    check-cast v3, Lcom/xj/winemu/bean/DialogSettingListItemEntity;

    if-eqz v3, :cond_32

    invoke-virtual {v3, v15}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->setSelected(Z)V

    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 154
    :cond_32
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;

    invoke-virtual {v0, v7}, Lcom/xj/common/data/model/CommResultEntity;->setData(Ljava/lang/Object;)V

    iget v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I
    invoke-static {v7, v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->appendLocalComponents(Ljava/util/List;I)V

    .line 155
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$callback:Lkotlin/jvm/functions/Function1;

    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;

    invoke-interface {v0, v1}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    .line 156
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    return-object v0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
