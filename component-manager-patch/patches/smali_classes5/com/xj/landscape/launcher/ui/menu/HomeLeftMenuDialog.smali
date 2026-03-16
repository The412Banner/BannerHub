.class public final Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;
.super Lcom/xj/common/dialog/BaseDialogFragment;
.source "r8-map-id-712846b76e3224c0169ce621759774aea144e14d75c3fb3c733f7f2b03c1bb19"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$Companion;,
        Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/xj/common/dialog/BaseDialogFragment<",
        "Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;",
        ">;"
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
.end annotation

.annotation build Lkotlin/jvm/internal/SourceDebugExtension;
.end annotation


# static fields
.field public static final r:Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$Companion;

.field public static s:Z


# instance fields
.field public final k:I

.field public final l:J

.field public m:Z

.field public final n:Ljava/util/List;

.field public final o:Lkotlin/Lazy;

.field public p:Lkotlinx/coroutines/Job;

.field public final q:Lkotlin/jvm/functions/Function1;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    .line 2
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$Companion;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    .line 6
    invoke-direct {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 7
    .line 8
    sput-object v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->r:Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$Companion;

    .line 9
    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-direct {p0}, Lcom/xj/common/dialog/BaseDialogFragment;-><init>()V

    .line 4
    .line 5
    .line 6
    const v0, 0x800033

    .line 7
    .line 8
    iput v0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->k:I

    .line 9
    .line 10
    const-wide/16 v0, 0x96

    .line 11
    .line 12
    iput-wide v0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->l:J

    .line 13
    .line 14
    new-instance v0, Ljava/util/ArrayList;

    .line 15
    .line 16
    .line 17
    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 18
    .line 19
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->n:Ljava/util/List;

    .line 20
    .line 21
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/k;

    .line 22
    .line 23
    .line 24
    invoke-direct {v0}, Lcom/xj/landscape/launcher/ui/menu/k;-><init>()V

    .line 25
    .line 26
    .line 27
    invoke-static {v0}, Lkotlin/LazyKt;->b(Lkotlin/jvm/functions/Function0;)Lkotlin/Lazy;

    .line 28
    move-result-object v0

    .line 29
    .line 30
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->o:Lkotlin/Lazy;

    .line 31
    .line 32
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/l;

    .line 33
    .line 34
    .line 35
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/menu/l;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 36
    .line 37
    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->q:Lkotlin/jvm/functions/Function1;

    .line 38
    return-void
.end method

.method public static synthetic C0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroidx/fragment/app/FragmentActivity;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->n1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroidx/fragment/app/FragmentActivity;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic D0(Lcom/drake/brv/DefaultDecoration;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->t1(Lcom/drake/brv/DefaultDecoration;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic E0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;I)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->p1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;I)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic F0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroid/content/DialogInterface;ILandroid/view/KeyEvent;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2, p3}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->w1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroid/content/DialogInterface;ILandroid/view/KeyEvent;)Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic G0(Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->q1(Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;)V

    .line 4
    return-void
.end method

.method public static synthetic H0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->k1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic I0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->m1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic J0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->j1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic K0(Landroidx/fragment/app/FragmentActivity;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->l1(Landroidx/fragment/app/FragmentActivity;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic L0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->x1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic M0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;Landroidx/fragment/app/FragmentActivity;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->o1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;Landroidx/fragment/app/FragmentActivity;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic N0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->f1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 4
    return-void
.end method

.method public static synthetic O0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;I)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->v1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;I)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic P0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroidx/fragment/app/FragmentActivity;Lkotlin/reflect/KClass;)Lcom/xj/common/view/adapter/VBViewHolder;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->i1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroidx/fragment/app/FragmentActivity;Lkotlin/reflect/KClass;)Lcom/xj/common/view/adapter/VBViewHolder;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic Q0()I
    .locals 1

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->b1()I

    .line 4
    move-result v0

    .line 5
    return v0
.end method

.method public static synthetic R0(Ljava/lang/String;)Lkotlin/reflect/KClass;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->h1(Ljava/lang/String;)Lkotlin/reflect/KClass;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic S0(ILjava/lang/Object;)Ljava/lang/String;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->g1(ILjava/lang/Object;)Ljava/lang/String;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic T0(Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->r1(Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;)V

    .line 4
    return-void
.end method

.method public static synthetic U0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroid/view/View;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->s1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroid/view/View;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final synthetic V0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->a1()V

    .line 4
    return-void
.end method

.method public static final synthetic W0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->p0()Landroidx/databinding/ViewDataBinding;

    .line 4
    move-result-object p0

    .line 5
    .line 6
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;

    .line 7
    return-object p0
.end method

.method public static final synthetic X0(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Ljava/util/List;
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->n:Ljava/util/List;

    .line 3
    return-object p0
.end method

.method public static final synthetic Y0()Z
    .locals 1

    .line 1
    .line 2
    sget-boolean v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->s:Z

    .line 3
    return v0
.end method

.method public static final synthetic Z0(Z)V
    .locals 0

    .line 1
    .line 2
    sput-boolean p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->s:Z

    .line 3
    return-void
.end method

.method public static final b1()I
    .locals 5

    .line 1
    .line 2
    sget-object v0, Lcom/xj/common/CommonApp;->b:Lcom/xj/common/CommonApp$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/common/CommonApp$Companion;->d()Ljava/lang/ref/WeakReference;

    .line 6
    move-result-object v0

    .line 7
    .line 8
    if-eqz v0, :cond_0

    .line 9
    .line 10
    .line 11
    invoke-virtual {v0}, Ljava/lang/ref/Reference;->get()Ljava/lang/Object;

    .line 12
    move-result-object v0

    .line 13
    .line 14
    check-cast v0, Landroid/app/Activity;

    .line 15
    .line 16
    if-eqz v0, :cond_0

    .line 17
    .line 18
    .line 19
    invoke-virtual {v0}, Landroid/app/Activity;->getLocalClassName()Ljava/lang/String;

    .line 20
    move-result-object v0

    .line 21
    .line 22
    if-nez v0, :cond_1

    .line 23
    .line 24
    :cond_0
    const-string v0, ""

    .line 25
    .line 26
    :cond_1
    const-string v1, "LandscapeLauncherMainActivity"

    .line 27
    const/4 v2, 0x0

    .line 28
    const/4 v3, 0x2

    .line 29
    const/4 v4, 0x0

    .line 30
    .line 31
    .line 32
    invoke-static {v0, v1, v2, v3, v4}, Lkotlin/text/StringsKt;->m0(Ljava/lang/CharSequence;Ljava/lang/CharSequence;ZILjava/lang/Object;)Z

    .line 33
    move-result v1

    .line 34
    .line 35
    if-eqz v1, :cond_2

    .line 36
    return v2

    .line 37
    .line 38
    :cond_2
    const-string v1, "GameLibraryActivity"

    .line 39
    .line 40
    .line 41
    invoke-static {v0, v1, v2, v3, v4}, Lkotlin/text/StringsKt;->m0(Ljava/lang/CharSequence;Ljava/lang/CharSequence;ZILjava/lang/Object;)Z

    .line 42
    move-result v1

    .line 43
    .line 44
    if-eqz v1, :cond_3

    .line 45
    const/4 v0, 0x1

    .line 46
    return v0

    .line 47
    .line 48
    :cond_3
    const-string v1, "DeviceManagerActivity"

    .line 49
    .line 50
    .line 51
    invoke-static {v0, v1, v2, v3, v4}, Lkotlin/text/StringsKt;->m0(Ljava/lang/CharSequence;Ljava/lang/CharSequence;ZILjava/lang/Object;)Z

    .line 52
    move-result v1

    .line 53
    .line 54
    if-eqz v1, :cond_4

    .line 55
    return v3

    .line 56
    .line 57
    :cond_4
    const-string v1, "RecordMainActivity"

    .line 58
    .line 59
    .line 60
    invoke-static {v0, v1, v2, v3, v4}, Lkotlin/text/StringsKt;->m0(Ljava/lang/CharSequence;Ljava/lang/CharSequence;ZILjava/lang/Object;)Z

    .line 61
    move-result v1

    .line 62
    .line 63
    if-eqz v1, :cond_5

    .line 64
    const/4 v0, 0x4

    .line 65
    return v0

    .line 66
    .line 67
    :cond_5
    const-string v1, "UserCenterActivity"

    .line 68
    .line 69
    .line 70
    invoke-static {v0, v1, v2, v3, v4}, Lkotlin/text/StringsKt;->m0(Ljava/lang/CharSequence;Ljava/lang/CharSequence;ZILjava/lang/Object;)Z

    .line 71
    move-result v1

    .line 72
    .line 73
    if-eqz v1, :cond_6

    .line 74
    const/4 v0, 0x5

    .line 75
    return v0

    .line 76
    .line 77
    :cond_6
    const-string v1, "DownloadManageActivity"

    .line 78
    .line 79
    .line 80
    invoke-static {v0, v1, v2, v3, v4}, Lkotlin/text/StringsKt;->m0(Ljava/lang/CharSequence;Ljava/lang/CharSequence;ZILjava/lang/Object;)Z

    .line 81
    move-result v1

    .line 82
    .line 83
    if-eqz v1, :cond_7

    .line 84
    const/4 v0, 0x6

    .line 85
    return v0

    .line 86
    .line 87
    :cond_7
    const-string v1, "SettingMainActivity"

    .line 88
    .line 89
    .line 90
    invoke-static {v0, v1, v2, v3, v4}, Lkotlin/text/StringsKt;->m0(Ljava/lang/CharSequence;Ljava/lang/CharSequence;ZILjava/lang/Object;)Z

    .line 91
    move-result v0

    .line 92
    .line 93
    if-eqz v0, :cond_8

    .line 94
    const/4 v0, 0x7

    .line 95
    return v0

    .line 96
    :cond_8
    const/4 v0, -0x1

    .line 97
    return v0
.end method

.method public static final f1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->dismiss()V

    .line 4
    return-void
.end method

.method public static final g1(ILjava/lang/Object;)Ljava/lang/String;
    .locals 0

    .line 1
    .line 2
    const-string p0, "data"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, p0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    instance-of p0, p1, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 8
    .line 9
    if-eqz p0, :cond_1

    .line 10
    .line 11
    check-cast p1, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 12
    .line 13
    .line 14
    invoke-virtual {p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;->e()Z

    .line 15
    move-result p0

    .line 16
    .line 17
    if-eqz p0, :cond_0

    .line 18
    .line 19
    const-string p0, "user_header"

    .line 20
    return-object p0

    .line 21
    .line 22
    :cond_0
    const-string p0, "menu_item"

    .line 23
    return-object p0

    .line 24
    :cond_1
    const/4 p0, 0x0

    .line 25
    return-object p0
.end method

.method public static final h1(Ljava/lang/String;)Lkotlin/reflect/KClass;
    .locals 1

    .line 1
    .line 2
    const-string v0, "viewType"

    .line 3
    .line 4
    .line 5
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    const-string v0, "user_header"

    .line 8
    .line 9
    .line 10
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 11
    move-result v0

    .line 12
    .line 13
    if-eqz v0, :cond_0

    .line 14
    .line 15
    const-class p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuUserHeaderViewHolder;

    .line 16
    .line 17
    .line 18
    invoke-static {p0}, Lkotlin/jvm/internal/Reflection;->b(Ljava/lang/Class;)Lkotlin/reflect/KClass;

    .line 19
    move-result-object p0

    .line 20
    return-object p0

    .line 21
    .line 22
    :cond_0
    const-string v0, "menu_item"

    .line 23
    .line 24
    .line 25
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 26
    move-result p0

    .line 27
    .line 28
    if-eqz p0, :cond_1

    .line 29
    .line 30
    const-class p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder;

    .line 31
    .line 32
    .line 33
    invoke-static {p0}, Lkotlin/jvm/internal/Reflection;->b(Ljava/lang/Class;)Lkotlin/reflect/KClass;

    .line 34
    move-result-object p0

    .line 35
    return-object p0

    .line 36
    :cond_1
    const/4 p0, 0x0

    .line 37
    return-object p0
.end method

.method public static final i1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroidx/fragment/app/FragmentActivity;Lkotlin/reflect/KClass;)Lcom/xj/common/view/adapter/VBViewHolder;
    .locals 3

    .line 1
    .line 2
    const-string v0, "clazz"

    .line 3
    .line 4
    .line 5
    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    const-class v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuUserHeaderViewHolder;

    .line 8
    .line 9
    .line 10
    invoke-static {v0}, Lkotlin/jvm/internal/Reflection;->b(Ljava/lang/Class;)Lkotlin/reflect/KClass;

    .line 11
    move-result-object v0

    .line 12
    .line 13
    .line 14
    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 15
    move-result v0

    .line 16
    .line 17
    if-eqz v0, :cond_0

    .line 18
    .line 19
    new-instance p2, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuUserHeaderViewHolder;

    .line 20
    .line 21
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/e;

    .line 22
    .line 23
    .line 24
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/menu/e;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 25
    .line 26
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/f;

    .line 27
    .line 28
    .line 29
    invoke-direct {v1, p0}, Lcom/xj/landscape/launcher/ui/menu/f;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 30
    .line 31
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/g;

    .line 32
    .line 33
    .line 34
    invoke-direct {v2, p1, p0}, Lcom/xj/landscape/launcher/ui/menu/g;-><init>(Landroidx/fragment/app/FragmentActivity;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 35
    .line 36
    .line 37
    invoke-direct {p2, v0, v1, v2}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuUserHeaderViewHolder;-><init>(Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function0;)V

    .line 38
    return-object p2

    .line 39
    .line 40
    :cond_0
    const-class v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder;

    .line 41
    .line 42
    .line 43
    invoke-static {v0}, Lkotlin/jvm/internal/Reflection;->b(Ljava/lang/Class;)Lkotlin/reflect/KClass;

    .line 44
    move-result-object v0

    .line 45
    .line 46
    .line 47
    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->b(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 48
    move-result p2

    .line 49
    .line 50
    if-eqz p2, :cond_1

    .line 51
    .line 52
    new-instance p2, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder;

    .line 53
    .line 54
    .line 55
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->d1()I

    .line 56
    move-result v0

    .line 57
    .line 58
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/h;

    .line 59
    .line 60
    .line 61
    invoke-direct {v1, p0}, Lcom/xj/landscape/launcher/ui/menu/h;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 62
    .line 63
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/i;

    .line 64
    .line 65
    .line 66
    invoke-direct {v2, p0, p1}, Lcom/xj/landscape/launcher/ui/menu/i;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroidx/fragment/app/FragmentActivity;)V

    .line 67
    .line 68
    .line 69
    invoke-direct {p2, v0, v1, v2}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder;-><init>(ILkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;)V

    .line 70
    return-object p2

    .line 71
    :cond_1
    const/4 p0, 0x0

    .line 72
    return-object p0
.end method

.method public static final j1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-direct {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->y1()V

    .line 4
    .line 5
    .line 6
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->dismiss()V

    .line 7
    .line 8
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 9
    return-object p0
.end method

.method public static final k1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;
    .locals 3

    .line 1
    .line 2
    new-instance v0, Lcom/xj/landscape/launcher/event/OpenNotificationEvent;

    .line 3
    .line 4
    .line 5
    invoke-direct {v0}, Lcom/xj/landscape/launcher/event/OpenNotificationEvent;-><init>()V

    .line 6
    const/4 v1, 0x0

    .line 7
    const/4 v2, 0x2

    .line 8
    .line 9
    .line 10
    invoke-static {v0, v1, v2, v1}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 11
    .line 12
    .line 13
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->dismiss()V

    .line 14
    .line 15
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 16
    return-object p0
.end method

.method public static final l1(Landroidx/fragment/app/FragmentActivity;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;
    .locals 2

    .line 1
    .line 2
    .line 3
    .line 4
    .line 5
    .line 6
    .line 7
    .line 8
    .line 9
    .line 10
    .line 11
    .line 12
    .line 13
    invoke-virtual {p1}, Lcom/xj/common/dialog/BaseDialogFragment;->dismiss()V

    .line 14
    .line 15
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 16
    return-object p0
.end method

.method public static final m1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;)Lkotlin/Unit;
    .locals 2

    .line 1
    .line 2
    const-string v0, "entity"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->p0()Landroidx/databinding/ViewDataBinding;

    .line 9
    move-result-object p0

    .line 10
    .line 11
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;

    .line 12
    .line 13
    if-eqz p0, :cond_1

    .line 14
    .line 15
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    .line 16
    .line 17
    if-eqz p0, :cond_1

    .line 18
    .line 19
    .line 20
    invoke-virtual {p0}, Landroidx/recyclerview/widget/RecyclerView;->getLayoutManager()Landroidx/recyclerview/widget/RecyclerView$LayoutManager;

    .line 21
    move-result-object v0

    .line 22
    .line 23
    instance-of v1, v0, Landroidx/recyclerview/widget/LinearLayoutManager;

    .line 24
    .line 25
    if-eqz v1, :cond_0

    .line 26
    .line 27
    check-cast v0, Landroidx/recyclerview/widget/LinearLayoutManager;

    .line 28
    goto :goto_0

    .line 29
    :cond_0
    const/4 v0, 0x0

    .line 30
    .line 31
    :goto_0
    if-eqz v0, :cond_1

    .line 32
    .line 33
    .line 34
    invoke-virtual {v0}, Landroidx/recyclerview/widget/LinearLayoutManager;->findLastVisibleItemPosition()I

    .line 35
    move-result v0

    .line 36
    .line 37
    .line 38
    invoke-virtual {p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;->a()I

    .line 39
    move-result p1

    .line 40
    .line 41
    add-int/lit8 v0, v0, -0x1

    .line 42
    .line 43
    if-lt p1, v0, :cond_1

    .line 44
    .line 45
    const/16 p1, 0x70

    .line 46
    .line 47
    .line 48
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 49
    move-result-object p1

    .line 50
    .line 51
    .line 52
    invoke-static {p1}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 53
    move-result-object p1

    .line 54
    .line 55
    .line 56
    invoke-virtual {p1}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 57
    move-result p1

    .line 58
    const/4 v0, 0x0

    .line 59
    .line 60
    .line 61
    invoke-virtual {p0, v0, p1}, Landroidx/recyclerview/widget/RecyclerView;->smoothScrollBy(II)V

    .line 62
    .line 63
    :cond_1
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 64
    return-object p0
.end method

.method public static final n1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroidx/fragment/app/FragmentActivity;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;)Lkotlin/Unit;
    .locals 2

    .line 1
    .line 2
    const-string v0, "entity"

    .line 3
    .line 4
    .line 5
    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    sget-object v0, Lcom/xj/common/utils/GHSoundPlayHelper;->a:Lcom/xj/common/utils/GHSoundPlayHelper;

    .line 8
    .line 9
    .line 10
    invoke-virtual {v0}, Lcom/xj/common/utils/GHSoundPlayHelper;->d()V

    .line 11
    .line 12
    .line 13
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->d1()I

    .line 14
    move-result v0

    .line 15
    .line 16
    .line 17
    invoke-virtual {p2}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;->a()I

    .line 18
    move-result v1

    .line 19
    .line 20
    if-ne v0, v1, :cond_0

    .line 21
    .line 22
    .line 23
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->e1()V

    .line 24
    .line 25
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 26
    return-object p0

    .line 27
    .line 28
    :cond_0
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/j;

    .line 29
    .line 30
    .line 31
    invoke-direct {v0, p0, p2, p1}, Lcom/xj/landscape/launcher/ui/menu/j;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;Landroidx/fragment/app/FragmentActivity;)V

    .line 32
    .line 33
    .line 34
    invoke-virtual {p0, v0}, Lcom/xj/common/dialog/BaseDialogFragment;->y0(Lkotlin/jvm/functions/Function0;)V

    .line 35
    .line 36
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 37
    return-object p0
.end method

.method public static final o1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;Landroidx/fragment/app/FragmentActivity;)Lkotlin/Unit;
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-super {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->dismiss()V

    .line 4
    .line 5
    .line 6
    invoke-virtual {p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;->a()I

    .line 7
    move-result p0

    .line 8
    const/4 p1, 0x0

    .line 9
    const/4 v0, 0x0

    .line 10
    .line 11
    .line 12
    packed-switch p0, :pswitch_data_0

    .line 13
    .line 14
    goto/16 :goto_1

    .line 15
    .line 16
    :pswitch_0
    sget-object p0, Lcom/xj/common/trace/TraceEvent;->a:Lcom/xj/common/trace/TraceEvent;

    .line 17
    .line 18
    const-string p2, "sidebar_steam_click"

    .line 19
    .line 20
    .line 21
    invoke-virtual {p0, p2}, Lcom/xj/common/trace/TraceEvent;->onEvent(Ljava/lang/String;)V

    .line 22
    .line 23
    const-class p0, Lcom/xj/steam/api/ISteamService;

    .line 24
    .line 25
    .line 26
    invoke-static {p0}, Lcom/therouter/TheRouter;->b(Ljava/lang/Class;)Ljava/lang/Object;

    .line 27
    move-result-object p2

    .line 28
    .line 29
    check-cast p2, Lcom/xj/steam/api/ISteamService;

    .line 30
    .line 31
    if-eqz p2, :cond_0

    .line 32
    .line 33
    .line 34
    invoke-interface {p2}, Lcom/xj/steam/api/ISteamService;->c()Z

    .line 35
    move-result p2

    .line 36
    goto :goto_0

    .line 37
    :cond_0
    move p2, v0

    .line 38
    .line 39
    :goto_0
    if-eqz p2, :cond_1

    .line 40
    .line 41
    sget-object p0, Lcom/xj/common/router/PageRouterUtils;->a:Lcom/xj/common/router/PageRouterUtils;

    .line 42
    .line 43
    .line 44
    invoke-virtual {p0}, Lcom/xj/common/router/PageRouterUtils;->m()V

    .line 45
    goto :goto_1

    .line 46
    .line 47
    .line 48
    :cond_1
    invoke-static {p0}, Lcom/therouter/TheRouter;->b(Ljava/lang/Class;)Ljava/lang/Object;

    .line 49
    move-result-object p0

    .line 50
    .line 51
    check-cast p0, Lcom/xj/steam/api/ISteamService;

    .line 52
    .line 53
    if-eqz p0, :cond_2

    .line 54
    const/4 p2, 0x1

    .line 55
    .line 56
    .line 57
    invoke-static {p0, v0, p2, p1}, Lcom/xj/steam/api/ISteamService;->e(Lcom/xj/steam/api/ISteamService;ZILjava/lang/Object;)V

    .line 58
    goto :goto_1

    .line 59
    .line 60
    :pswitch_1
    const-class p0, Lcom/xj/landscape/launcher/ui/setting/SettingMainActivity;

    .line 61
    .line 62
    .line 63
    invoke-static {p0}, Lcom/blankj/utilcode/util/ActivityUtils;->q(Ljava/lang/Class;)V

    .line 64
    goto :goto_1

    .line 65
    .line 66
    :pswitch_2
    sget-object p0, Lcom/xj/common/router/PageRouterUtils;->a:Lcom/xj/common/router/PageRouterUtils;

    .line 67
    .line 68
    .line 69
    invoke-virtual {p0, p2}, Lcom/xj/common/router/PageRouterUtils;->e(Landroid/app/Activity;)V

    .line 70
    goto :goto_1

    .line 71
    .line 72
    :pswitch_3
    new-instance p0, Landroid/content/Intent;

    .line 73
    .line 74
    const-class p1, Lcom/xj/landscape/launcher/ui/usercenter/UserCenterActivity;

    .line 75
    .line 76
    .line 77
    invoke-direct {p0, p2, p1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 78
    .line 79
    .line 80
    invoke-virtual {p2, p0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    .line 81
    goto :goto_1

    .line 82
    .line 83
    :pswitch_4
    const-class p0, Lcom/xj/landscape/launcher/ui/record/RecordMainActivity;

    .line 84
    .line 85
    .line 86
    invoke-static {p0}, Lcom/blankj/utilcode/util/ActivityUtils;->q(Ljava/lang/Class;)V

    .line 87
    goto :goto_1

    .line 88
    .line 89
    :pswitch_5
    sget-object p0, Lcom/xj/common/service/IMService;->a:Lcom/xj/common/service/IMService$Companion;

    .line 90
    .line 91
    .line 92
    invoke-virtual {p0}, Lcom/xj/common/service/IMService$Companion;->a()Lcom/xj/common/service/IMService;

    .line 93
    move-result-object p0

    .line 94
    .line 95
    if-eqz p0, :cond_2

    .line 96
    .line 97
    .line 98
    invoke-interface {p0}, Lcom/xj/common/service/IMService;->a()V

    .line 99
    goto :goto_1

    .line 100
    .line 101
    :pswitch_6
    sget-object p0, Lcom/xj/common/utils/ActivityBlurBgUtils;->a:Lcom/xj/common/utils/ActivityBlurBgUtils;

    .line 102
    .line 103
    new-instance p1, Landroid/os/Bundle;

    .line 104
    .line 105
    .line 106
    invoke-direct {p1}, Landroid/os/Bundle;-><init>()V

    .line 107
    .line 108
    const-class v0, Lcom/xj/landscape/launcher/ui/device/DeviceManagerActivity;

    .line 109
    .line 110
    .line 111
    invoke-virtual {p0, p2, v0, p1}, Lcom/xj/common/utils/ActivityBlurBgUtils;->e(Landroid/content/Context;Ljava/lang/Class;Landroid/os/Bundle;)V

    .line 112
    goto :goto_1

    .line 113
    .line 114
    :pswitch_7
    sget-object p0, Lcom/xj/common/router/PageRouterUtils;->a:Lcom/xj/common/router/PageRouterUtils;

    .line 115
    const/4 v1, 0x2

    .line 116
    .line 117
    .line 118
    invoke-static {p0, p2, v0, v1, p1}, Lcom/xj/common/router/PageRouterUtils;->g(Lcom/xj/common/router/PageRouterUtils;Landroid/app/Activity;IILjava/lang/Object;)V

    .line 119
    goto :goto_1

    .line 120
    .line 121
    :pswitch_8
    const-class p0, Lcom/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity;

    .line 122
    .line 123
    .line 124
    invoke-static {p0}, Lcom/blankj/utilcode/util/ActivityUtils;->f(Ljava/lang/Class;)V

    .line 125
    .line 126
    :pswitch_9
    new-instance p0, Landroid/content/Intent;
    const-class p1, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
    invoke-direct {p0, p2, p1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p2, p0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    goto :goto_1

    :cond_2
    :goto_1
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 127
    return-object p0

    .line 128
    nop

    .line 129
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_9
    .end packed-switch
.end method

.method public static final p1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;I)Lkotlin/Unit;
    .locals 3

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder;->Companion:Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0, p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder$Companion;->a(I)V

    .line 6
    .line 7
    iget-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->n:Ljava/util/List;

    .line 8
    .line 9
    .line 10
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    .line 11
    move-result-object p1

    .line 12
    const/4 v0, 0x0

    .line 13
    .line 14
    .line 15
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 16
    move-result v1

    .line 17
    .line 18
    if-eqz v1, :cond_1

    .line 19
    .line 20
    .line 21
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 22
    move-result-object v1

    .line 23
    .line 24
    check-cast v1, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 25
    .line 26
    .line 27
    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;->a()I

    .line 28
    move-result v1

    .line 29
    const/4 v2, 0x4

    .line 30
    .line 31
    if-ne v1, v2, :cond_0

    .line 32
    goto :goto_1

    .line 33
    .line 34
    :cond_0
    add-int/lit8 v0, v0, 0x1

    .line 35
    goto :goto_0

    .line 36
    :cond_1
    const/4 v0, -0x1

    .line 37
    .line 38
    :goto_1
    if-ltz v0, :cond_2

    .line 39
    .line 40
    .line 41
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->p0()Landroidx/databinding/ViewDataBinding;

    .line 42
    move-result-object p0

    .line 43
    .line 44
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;

    .line 45
    .line 46
    if-eqz p0, :cond_2

    .line 47
    .line 48
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    .line 49
    .line 50
    if-eqz p0, :cond_2

    .line 51
    .line 52
    .line 53
    invoke-virtual {p0}, Landroidx/recyclerview/widget/RecyclerView;->getAdapter()Landroidx/recyclerview/widget/RecyclerView$Adapter;

    .line 54
    move-result-object p0

    .line 55
    .line 56
    if-eqz p0, :cond_2

    .line 57
    .line 58
    .line 59
    invoke-virtual {p0, v0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;->notifyItemChanged(I)V

    .line 60
    .line 61
    :cond_2
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 62
    return-object p0
.end method

.method public static final q1(Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;)V
    .locals 1

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->layoutContent:Landroid/widget/LinearLayout;

    .line 3
    const/4 v0, 0x0

    .line 4
    .line 5
    .line 6
    invoke-virtual {p0, v0}, Landroid/view/View;->setTranslationX(F)V

    .line 7
    return-void
.end method

.method public static final r1(Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;)V
    .locals 1

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->ivBg:Landroid/widget/ImageView;

    .line 3
    .line 4
    const/high16 v0, 0x3f800000    # 1.0f

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0, v0}, Landroid/view/View;->setAlpha(F)V

    .line 8
    return-void
.end method

.method public static final s1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroid/view/View;)Lkotlin/Unit;
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
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->e1()V

    .line 9
    .line 10
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 11
    return-object p0
.end method

.method public static final t1(Lcom/drake/brv/DefaultDecoration;)Lkotlin/Unit;
    .locals 2

    .line 1
    .line 2
    const-string v0, "$this$divider"

    .line 3
    .line 4
    .line 5
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    const/4 v0, 0x4

    .line 7
    .line 8
    .line 9
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 10
    move-result-object v0

    .line 11
    .line 12
    .line 13
    invoke-static {v0}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 14
    move-result-object v0

    .line 15
    .line 16
    .line 17
    invoke-virtual {v0}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 18
    move-result v0

    .line 19
    const/4 v1, 0x0

    .line 20
    .line 21
    .line 22
    invoke-virtual {p0, v0, v1}, Lcom/drake/brv/DefaultDecoration;->k(IZ)V

    .line 23
    .line 24
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 25
    return-object p0
.end method

.method public static final v1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;I)Lkotlin/Unit;
    .locals 3

    .line 1
    .line 2
    sget-object v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder;->Companion:Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0, p1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuViewHolder$Companion;->b(I)V

    .line 6
    .line 7
    iget-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->n:Ljava/util/List;

    .line 8
    .line 9
    .line 10
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    .line 11
    move-result-object p1

    .line 12
    const/4 v0, 0x0

    .line 13
    .line 14
    .line 15
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 16
    move-result v1

    .line 17
    .line 18
    if-eqz v1, :cond_1

    .line 19
    .line 20
    .line 21
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 22
    move-result-object v1

    .line 23
    .line 24
    check-cast v1, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 25
    .line 26
    .line 27
    invoke-virtual {v1}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;->a()I

    .line 28
    move-result v1

    .line 29
    const/4 v2, 0x3

    .line 30
    .line 31
    if-ne v1, v2, :cond_0

    .line 32
    goto :goto_1

    .line 33
    .line 34
    :cond_0
    add-int/lit8 v0, v0, 0x1

    .line 35
    goto :goto_0

    .line 36
    :cond_1
    const/4 v0, -0x1

    .line 37
    .line 38
    :goto_1
    if-ltz v0, :cond_2

    .line 39
    .line 40
    iget-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->n:Ljava/util/List;

    .line 41
    .line 42
    .line 43
    invoke-interface {p1}, Ljava/util/List;->size()I

    .line 44
    move-result p1

    .line 45
    .line 46
    if-ge v0, p1, :cond_2

    .line 47
    .line 48
    .line 49
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->p0()Landroidx/databinding/ViewDataBinding;

    .line 50
    move-result-object p0

    .line 51
    .line 52
    check-cast p0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;

    .line 53
    .line 54
    if-eqz p0, :cond_2

    .line 55
    .line 56
    iget-object p0, p0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    .line 57
    .line 58
    if-eqz p0, :cond_2

    .line 59
    .line 60
    .line 61
    invoke-virtual {p0}, Landroidx/recyclerview/widget/RecyclerView;->getAdapter()Landroidx/recyclerview/widget/RecyclerView$Adapter;

    .line 62
    move-result-object p0

    .line 63
    .line 64
    if-eqz p0, :cond_2

    .line 65
    .line 66
    .line 67
    invoke-virtual {p0, v0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;->notifyItemChanged(I)V

    .line 68
    .line 69
    :cond_2
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 70
    return-object p0
.end method

.method public static final w1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroid/content/DialogInterface;ILandroid/view/KeyEvent;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p3}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 4
    .line 5
    .line 6
    invoke-virtual {p0, p3}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->c1(Landroid/view/KeyEvent;)Z

    .line 7
    move-result p0

    .line 8
    return p0
.end method

.method public static final x1(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->e1()V

    .line 4
    .line 5
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 6
    return-object p0
.end method

.method private final y1()V
    .locals 1

    .line 1
    .line 2
    const-string p0, "com.xj.pay.ui.CloudGamePayActivity"

    .line 3
    .line 4
    .line 5
    invoke-static {p0}, Lcom/therouter/TheRouter;->a(Ljava/lang/String;)Lcom/therouter/Navigator;

    .line 6
    move-result-object p0

    .line 7
    .line 8
    .line 9
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;

    .line 10
    move-result-object v0

    .line 11
    .line 12
    .line 13
    invoke-virtual {p0, v0}, Lcom/therouter/Navigator;->b(Landroid/content/Context;)V

    .line 14
    return-void
.end method


# virtual methods
.method public final a1()V
    .locals 3

    .line 1
    .line 2
    sget-boolean v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->s:Z

    .line 3
    .line 4
    if-nez v0, :cond_0

    .line 5
    goto :goto_0

    .line 6
    .line 7
    .line 8
    :cond_0
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->p0()Landroidx/databinding/ViewDataBinding;

    .line 9
    move-result-object v0

    .line 10
    .line 11
    check-cast v0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;

    .line 12
    .line 13
    if-eqz v0, :cond_1

    .line 14
    .line 15
    iget-object v0, v0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    .line 16
    .line 17
    if-eqz v0, :cond_1

    .line 18
    .line 19
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$checkDownloadTaskSize$1;

    .line 20
    const/4 v2, 0x0

    .line 21
    .line 22
    .line 23
    invoke-direct {v1, p0, v2}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$checkDownloadTaskSize$1;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Lkotlin/coroutines/Continuation;)V

    .line 24
    const/4 p0, 0x1

    .line 25
    .line 26
    .line 27
    invoke-static {v0, v2, v1, p0, v2}, Lcom/drake/net/utils/ScopeKt;->n(Landroid/view/View;Lkotlinx/coroutines/CoroutineDispatcher;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lcom/drake/net/scope/ViewCoroutineScope;

    .line 28
    :cond_1
    :goto_0
    return-void
.end method

.method public final c1(Landroid/view/KeyEvent;)Z
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
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getAction()I

    .line 9
    move-result v0

    .line 10
    const/4 v1, 0x1

    .line 11
    .line 12
    if-ne v0, v1, :cond_1

    .line 13
    .line 14
    .line 15
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 16
    move-result v0

    .line 17
    const/4 v2, 0x4

    .line 18
    .line 19
    if-eq v0, v2, :cond_0

    .line 20
    .line 21
    .line 22
    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    .line 23
    move-result p1

    .line 24
    .line 25
    const/16 v0, 0x6c

    .line 26
    .line 27
    if-ne p1, v0, :cond_1

    .line 28
    .line 29
    .line 30
    :cond_0
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->e1()V

    .line 31
    return v1

    .line 32
    :cond_1
    const/4 p0, 0x0

    .line 33
    return p0
.end method

.method public final d1()I
    .locals 0

    .line 1
    .line 2
    iget-object p0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->o:Lkotlin/Lazy;

    .line 3
    .line 4
    .line 5
    invoke-interface {p0}, Lkotlin/Lazy;->getValue()Ljava/lang/Object;

    .line 6
    move-result-object p0

    .line 7
    .line 8
    check-cast p0, Ljava/lang/Number;

    .line 9
    .line 10
    .line 11
    invoke-virtual {p0}, Ljava/lang/Number;->intValue()I

    .line 12
    move-result p0

    .line 13
    return p0
.end method

.method public final e1()V
    .locals 4

    .line 1
    .line 2
    iget-boolean v0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->m:Z

    .line 3
    .line 4
    if-eqz v0, :cond_0

    .line 5
    goto :goto_0

    .line 6
    :cond_0
    const/4 v0, 0x0

    .line 7
    .line 8
    sput-boolean v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->s:Z

    .line 9
    const/4 v0, 0x1

    .line 10
    .line 11
    iput-boolean v0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->m:Z

    .line 12
    .line 13
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->p:Lkotlinx/coroutines/Job;

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
    iput-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->p:Lkotlinx/coroutines/Job;

    .line 22
    .line 23
    .line 24
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->p0()Landroidx/databinding/ViewDataBinding;

    .line 25
    move-result-object v0

    .line 26
    .line 27
    check-cast v0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;

    .line 28
    .line 29
    if-eqz v0, :cond_2

    .line 30
    .line 31
    iget-object v1, v0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->layoutContent:Landroid/widget/LinearLayout;

    .line 32
    .line 33
    .line 34
    invoke-virtual {v1}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    .line 35
    move-result-object v1

    .line 36
    .line 37
    iget-object v2, v0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->layoutContent:Landroid/widget/LinearLayout;

    .line 38
    .line 39
    .line 40
    invoke-virtual {v2}, Landroid/view/View;->getWidth()I

    .line 41
    move-result v2

    .line 42
    int-to-float v2, v2

    .line 43
    neg-float v2, v2

    .line 44
    .line 45
    .line 46
    invoke-virtual {v1, v2}, Landroid/view/ViewPropertyAnimator;->translationX(F)Landroid/view/ViewPropertyAnimator;

    .line 47
    move-result-object v1

    .line 48
    .line 49
    iget-wide v2, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->l:J

    .line 50
    .line 51
    .line 52
    invoke-virtual {v1, v2, v3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    .line 53
    move-result-object v1

    .line 54
    .line 55
    .line 56
    invoke-virtual {v1}, Landroid/view/ViewPropertyAnimator;->start()V

    .line 57
    .line 58
    iget-object v0, v0, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->ivBg:Landroid/widget/ImageView;

    .line 59
    .line 60
    .line 61
    invoke-virtual {v0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    .line 62
    move-result-object v0

    .line 63
    const/4 v1, 0x0

    .line 64
    .line 65
    .line 66
    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    .line 67
    move-result-object v0

    .line 68
    .line 69
    iget-wide v1, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->l:J

    .line 70
    .line 71
    .line 72
    invoke-virtual {v0, v1, v2}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    .line 73
    move-result-object v0

    .line 74
    .line 75
    .line 76
    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->start()V

    .line 77
    .line 78
    iget-wide v0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->l:J

    .line 79
    .line 80
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/n;

    .line 81
    .line 82
    .line 83
    invoke-direct {v2, p0}, Lcom/xj/landscape/launcher/ui/menu/n;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 84
    .line 85
    .line 86
    invoke-static {v0, v1, v2}, Lcom/xj/common/utils/VUiKit;->f(JLjava/lang/Runnable;)V

    .line 87
    :cond_2
    :goto_0
    return-void
.end method

.method public i0()I
    .locals 0

    .line 1
    .line 2
    iget p0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->k:I

    .line 3
    return p0
.end method

.method public k0()I
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/base/util/ScreenUtils;->f()Lcom/xj/base/util/ScreenSize;

    .line 4
    move-result-object p0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Lcom/xj/base/util/ScreenSize;->b()I

    .line 8
    move-result p0

    .line 9
    return p0
.end method

.method public l0()I
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {}, Lcom/xj/base/util/ScreenUtils;->f()Lcom/xj/base/util/ScreenSize;

    .line 4
    move-result-object p0

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Lcom/xj/base/util/ScreenSize;->d()I

    .line 8
    move-result p0

    .line 9
    return p0
.end method

.method public onCreateDialog(Landroid/os/Bundle;)Landroid/app/Dialog;
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-super {p0, p1}, Landroidx/fragment/app/DialogFragment;->onCreateDialog(Landroid/os/Bundle;)Landroid/app/Dialog;

    .line 4
    move-result-object p1

    .line 5
    .line 6
    const-string v0, "onCreateDialog(...)"

    .line 7
    .line 8
    .line 9
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 10
    .line 11
    .line 12
    invoke-virtual {p1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    .line 13
    move-result-object v0

    .line 14
    .line 15
    if-eqz v0, :cond_0

    .line 16
    const/4 v1, 0x2

    .line 17
    .line 18
    .line 19
    invoke-virtual {v0, v1}, Landroid/view/Window;->clearFlags(I)V

    .line 20
    const/4 v1, 0x0

    .line 21
    .line 22
    .line 23
    invoke-virtual {v0, v1}, Landroid/view/Window;->setDimAmount(F)V

    .line 24
    .line 25
    :cond_0
    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/m;

    .line 26
    .line 27
    .line 28
    invoke-direct {v0, p0}, Lcom/xj/landscape/launcher/ui/menu/m;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 29
    .line 30
    .line 31
    invoke-virtual {p1, v0}, Landroid/app/Dialog;->setOnKeyListener(Landroid/content/DialogInterface$OnKeyListener;)V

    .line 32
    return-object p1
.end method

.method public onDismiss(Landroid/content/DialogInterface;)V
    .locals 4

    .line 1
    .line 2
    const-string v0, "dialog"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    const/4 v0, 0x0

    .line 7
    .line 8
    sput-boolean v0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->s:Z

    .line 9
    .line 10
    sget-object v1, Lcom/xj/common/view/floatview/MenuFloatView;->o:Lcom/xj/common/view/floatview/MenuFloatView$Companion;

    .line 11
    .line 12
    .line 13
    invoke-virtual {v1, p0}, Lcom/xj/common/view/floatview/MenuFloatView$Companion;->h(Lcom/xj/common/dialog/BaseDialogFragment;)Lcom/xj/common/view/floatview/MenuFloatView;

    .line 14
    move-result-object v1

    .line 15
    const/4 v2, 0x0

    .line 16
    .line 17
    if-eqz v1, :cond_0

    .line 18
    const/4 v3, 0x1

    .line 19
    .line 20
    .line 21
    invoke-static {v1, v0, v3, v2}, Lcom/xj/common/view/floatview/MenuFloatView;->u(Lcom/xj/common/view/floatview/MenuFloatView;ZILjava/lang/Object;)V

    .line 22
    .line 23
    .line 24
    :cond_0
    invoke-super {p0, p1}, Lcom/xj/common/dialog/BaseDialogFragment;->onDismiss(Landroid/content/DialogInterface;)V

    .line 25
    .line 26
    new-instance p1, Lcom/xj/landscape/launcher/event/NavDialogVisibleChangedEvent;

    .line 27
    .line 28
    .line 29
    invoke-direct {p1, v0}, Lcom/xj/landscape/launcher/event/NavDialogVisibleChangedEvent;-><init>(Z)V

    .line 30
    const/4 v0, 0x2

    .line 31
    .line 32
    .line 33
    invoke-static {p1, v2, v0, v2}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 34
    .line 35
    sget-object p1, Lcom/xj/common/service/IMService;->a:Lcom/xj/common/service/IMService$Companion;

    .line 36
    .line 37
    .line 38
    invoke-virtual {p1}, Lcom/xj/common/service/IMService$Companion;->a()Lcom/xj/common/service/IMService;

    .line 39
    move-result-object p1

    .line 40
    .line 41
    if-eqz p1, :cond_1

    .line 42
    .line 43
    iget-object p0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->q:Lkotlin/jvm/functions/Function1;

    .line 44
    .line 45
    .line 46
    invoke-interface {p1, p0}, Lcom/xj/common/service/IMService;->k(Lkotlin/jvm/functions/Function1;)V

    .line 47
    :cond_1
    return-void
.end method

.method public onResume()V
    .locals 10

    .line 1
    .line 2
    .line 3
    invoke-super {p0}, Lcom/xj/base/base/fragment/safely/SafelyDialogFragment;->onResume()V

    .line 4
    .line 5
    new-instance v0, Lcom/xj/landscape/launcher/event/NavDialogVisibleChangedEvent;

    .line 6
    const/4 v1, 0x1

    .line 7
    .line 8
    .line 9
    invoke-direct {v0, v1}, Lcom/xj/landscape/launcher/event/NavDialogVisibleChangedEvent;-><init>(Z)V

    .line 10
    const/4 v2, 0x2

    .line 11
    const/4 v3, 0x0

    .line 12
    .line 13
    .line 14
    invoke-static {v0, v3, v2, v3}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 15
    .line 16
    sget-object v0, Lcom/xj/common/view/floatview/MenuFloatView;->o:Lcom/xj/common/view/floatview/MenuFloatView$Companion;

    .line 17
    .line 18
    .line 19
    invoke-virtual {v0, p0}, Lcom/xj/common/view/floatview/MenuFloatView$Companion;->h(Lcom/xj/common/dialog/BaseDialogFragment;)Lcom/xj/common/view/floatview/MenuFloatView;

    .line 20
    move-result-object v0

    .line 21
    .line 22
    if-eqz v0, :cond_0

    .line 23
    .line 24
    new-instance v4, Lcom/xj/common/view/floatview/MenuItem;

    .line 25
    .line 26
    sget-object v5, Lcom/xj/common/view/floatview/MenuIcon;->B:Lcom/xj/common/view/floatview/MenuIcon;

    .line 27
    .line 28
    new-instance v7, Lcom/xj/landscape/launcher/ui/menu/a;

    .line 29
    .line 30
    .line 31
    invoke-direct {v7, p0}, Lcom/xj/landscape/launcher/ui/menu/a;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 32
    const/4 v8, 0x2

    .line 33
    const/4 v9, 0x0

    .line 34
    const/4 v6, 0x0

    .line 35
    .line 36
    .line 37
    invoke-direct/range {v4 .. v9}, Lcom/xj/common/view/floatview/MenuItem;-><init>(Lcom/xj/common/view/floatview/MenuIcon;Ljava/lang/String;Lkotlin/jvm/functions/Function0;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 38
    .line 39
    .line 40
    filled-new-array {v4}, [Lcom/xj/common/view/floatview/MenuItem;

    .line 41
    move-result-object p0

    .line 42
    .line 43
    .line 44
    invoke-virtual {v0, p0}, Lcom/xj/common/view/floatview/MenuFloatView;->E([Lcom/xj/common/view/floatview/MenuItem;)Lcom/xj/common/view/floatview/MenuFloatView;

    .line 45
    move-result-object p0

    .line 46
    .line 47
    if-eqz p0, :cond_0

    .line 48
    const/4 v0, 0x0

    .line 49
    .line 50
    .line 51
    invoke-static {p0, v0, v1, v3}, Lcom/xj/common/view/floatview/MenuFloatView;->I(Lcom/xj/common/view/floatview/MenuFloatView;ZILjava/lang/Object;)V

    .line 52
    :cond_0
    return-void
.end method

.method public r0(Landroid/os/Bundle;)V
    .locals 9

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->u1()V

    .line 4
    .line 5
    .line 6
    invoke-virtual {p0}, Lcom/xj/common/dialog/BaseDialogFragment;->p0()Landroidx/databinding/ViewDataBinding;

    .line 7
    move-result-object p1

    .line 8
    .line 9
    check-cast p1, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;

    .line 10
    .line 11
    if-eqz p1, :cond_a

    .line 12
    .line 13
    iget-object v0, p1, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->ivBg:Landroid/widget/ImageView;

    .line 14
    const/4 v1, 0x0

    .line 15
    .line 16
    .line 17
    invoke-virtual {v0, v1}, Landroid/view/View;->setAlpha(F)V

    .line 18
    .line 19
    iget-object v0, p1, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->layoutContent:Landroid/widget/LinearLayout;

    .line 20
    .line 21
    const/16 v2, 0x168

    .line 22
    .line 23
    .line 24
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 25
    move-result-object v2

    .line 26
    .line 27
    .line 28
    invoke-static {v2}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 29
    move-result-object v2

    .line 30
    .line 31
    .line 32
    invoke-virtual {v2}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 33
    move-result v2

    .line 34
    int-to-float v2, v2

    .line 35
    neg-float v2, v2

    .line 36
    .line 37
    .line 38
    invoke-virtual {v0, v2}, Landroid/view/View;->setTranslationX(F)V

    .line 39
    .line 40
    iget-object v0, p1, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->layoutContent:Landroid/widget/LinearLayout;

    .line 41
    .line 42
    .line 43
    invoke-virtual {v0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    .line 44
    move-result-object v0

    .line 45
    .line 46
    .line 47
    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->translationX(F)Landroid/view/ViewPropertyAnimator;

    .line 48
    move-result-object v0

    .line 49
    .line 50
    iget-wide v1, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->l:J

    .line 51
    .line 52
    .line 53
    invoke-virtual {v0, v1, v2}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    .line 54
    move-result-object v0

    .line 55
    .line 56
    new-instance v1, Landroid/view/animation/AccelerateInterpolator;

    .line 57
    .line 58
    .line 59
    invoke-direct {v1}, Landroid/view/animation/AccelerateInterpolator;-><init>()V

    .line 60
    .line 61
    .line 62
    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)Landroid/view/ViewPropertyAnimator;

    .line 63
    move-result-object v0

    .line 64
    .line 65
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/o;

    .line 66
    .line 67
    .line 68
    invoke-direct {v1, p1}, Lcom/xj/landscape/launcher/ui/menu/o;-><init>(Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;)V

    .line 69
    .line 70
    .line 71
    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->withEndAction(Ljava/lang/Runnable;)Landroid/view/ViewPropertyAnimator;

    .line 72
    move-result-object v0

    .line 73
    .line 74
    .line 75
    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->start()V

    .line 76
    .line 77
    iget-object v0, p1, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->ivBg:Landroid/widget/ImageView;

    .line 78
    .line 79
    .line 80
    invoke-virtual {v0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    .line 81
    move-result-object v0

    .line 82
    .line 83
    const/high16 v1, 0x3f800000    # 1.0f

    .line 84
    .line 85
    .line 86
    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    .line 87
    move-result-object v0

    .line 88
    .line 89
    iget-wide v1, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->l:J

    .line 90
    .line 91
    .line 92
    invoke-virtual {v0, v1, v2}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    .line 93
    move-result-object v0

    .line 94
    .line 95
    new-instance v1, Landroid/view/animation/AccelerateInterpolator;

    .line 96
    .line 97
    .line 98
    invoke-direct {v1}, Landroid/view/animation/AccelerateInterpolator;-><init>()V

    .line 99
    .line 100
    .line 101
    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)Landroid/view/ViewPropertyAnimator;

    .line 102
    move-result-object v0

    .line 103
    .line 104
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/p;

    .line 105
    .line 106
    .line 107
    invoke-direct {v1, p1}, Lcom/xj/landscape/launcher/ui/menu/p;-><init>(Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;)V

    .line 108
    .line 109
    .line 110
    invoke-virtual {v0, v1}, Landroid/view/ViewPropertyAnimator;->withEndAction(Ljava/lang/Runnable;)Landroid/view/ViewPropertyAnimator;

    .line 111
    move-result-object v0

    .line 112
    .line 113
    .line 114
    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->start()V

    .line 115
    .line 116
    iget-object v0, p1, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->ivBg:Landroid/widget/ImageView;

    .line 117
    .line 118
    const-string v1, "ivBg"

    .line 119
    .line 120
    .line 121
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 122
    .line 123
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/q;

    .line 124
    .line 125
    .line 126
    invoke-direct {v1, p0}, Lcom/xj/landscape/launcher/ui/menu/q;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 127
    .line 128
    .line 129
    invoke-static {v0, v1}, Lcom/xj/common/utils/ClickUtilsKt;->i(Landroid/view/View;Lkotlin/jvm/functions/Function1;)V

    .line 130
    .line 131
    iget-object v2, p1, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    .line 132
    .line 133
    const-string v0, "recyclerView"

    .line 134
    .line 135
    .line 136
    invoke-static {v2, v0}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 137
    .line 138
    const/16 v7, 0xf

    .line 139
    const/4 v8, 0x0

    .line 140
    const/4 v3, 0x0

    .line 141
    const/4 v4, 0x0

    .line 142
    const/4 v5, 0x0

    .line 143
    const/4 v6, 0x0

    .line 144
    .line 145
    .line 146
    invoke-static/range {v2 .. v8}, Lcom/drake/brv/utils/RecyclerUtilsKt;->k(Landroidx/recyclerview/widget/RecyclerView;IZZZILjava/lang/Object;)Landroidx/recyclerview/widget/RecyclerView;

    .line 147
    move-result-object v0

    .line 148
    .line 149
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/r;

    .line 150
    .line 151
    .line 152
    invoke-direct {v1}, Lcom/xj/landscape/launcher/ui/menu/r;-><init>()V

    .line 153
    .line 154
    .line 155
    invoke-static {v0, v1}, Lcom/drake/brv/utils/RecyclerUtilsKt;->c(Landroidx/recyclerview/widget/RecyclerView;Lkotlin/jvm/functions/Function1;)Landroidx/recyclerview/widget/RecyclerView;

    .line 156
    .line 157
    .line 158
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    .line 159
    move-result-object v0

    .line 160
    .line 161
    if-nez v0, :cond_0

    .line 162
    .line 163
    goto/16 :goto_4

    .line 164
    .line 165
    :cond_0
    iget-object v1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    .line 166
    .line 167
    sget-object v2, Lcom/xj/common/view/adapter/MultiTypeAdapter;->h:Lcom/xj/common/view/adapter/MultiTypeAdapter$Companion;

    .line 168
    .line 169
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/s;

    .line 170
    .line 171
    .line 172
    invoke-direct {v3}, Lcom/xj/landscape/launcher/ui/menu/s;-><init>()V

    .line 173
    .line 174
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/b;

    .line 175
    .line 176
    .line 177
    invoke-direct {v4}, Lcom/xj/landscape/launcher/ui/menu/b;-><init>()V

    .line 178
    .line 179
    new-instance v5, Lcom/xj/landscape/launcher/ui/menu/c;

    .line 180
    .line 181
    .line 182
    invoke-direct {v5, p0, v0}, Lcom/xj/landscape/launcher/ui/menu/c;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Landroidx/fragment/app/FragmentActivity;)V

    .line 183
    .line 184
    .line 185
    invoke-virtual {v2, v3, v4, v5}, Lcom/xj/common/view/adapter/MultiTypeAdapter$Companion;->h(Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;)Lcom/xj/common/view/adapter/MultiTypeAdapter;

    .line 186
    move-result-object v2

    .line 187
    .line 188
    .line 189
    invoke-virtual {v1, v2}, Landroidx/recyclerview/widget/RecyclerView;->setAdapter(Landroidx/recyclerview/widget/RecyclerView$Adapter;)V

    .line 190
    .line 191
    iget-object v1, p1, Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    .line 192
    .line 193
    .line 194
    invoke-virtual {v1}, Landroidx/recyclerview/widget/RecyclerView;->getAdapter()Landroidx/recyclerview/widget/RecyclerView$Adapter;

    .line 195
    move-result-object v1

    .line 196
    .line 197
    if-eqz v1, :cond_1

    .line 198
    .line 199
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->n:Ljava/util/List;

    .line 200
    .line 201
    .line 202
    invoke-static {v1, v2}, Lcom/xj/common/view/adapter/MultiViewHolderAdapterKt;->e(Landroidx/recyclerview/widget/RecyclerView$Adapter;Ljava/util/List;)V

    .line 203
    .line 204
    :cond_1
    sget-object v1, Lcom/xj/common/service/IMService;->a:Lcom/xj/common/service/IMService$Companion;

    .line 205
    .line 206
    .line 207
    invoke-virtual {v1}, Lcom/xj/common/service/IMService$Companion;->a()Lcom/xj/common/service/IMService;

    .line 208
    move-result-object v1

    .line 209
    .line 210
    if-eqz v1, :cond_2

    .line 211
    .line 212
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->q:Lkotlin/jvm/functions/Function1;

    .line 213
    .line 214
    .line 215
    invoke-interface {v1, v2}, Lcom/xj/common/service/IMService;->l(Lkotlin/jvm/functions/Function1;)V

    .line 216
    .line 217
    :cond_2
    sget-object v1, Lcom/xj/common/config/AppConfig;->a:Lcom/xj/common/config/AppConfig$Companion;

    .line 218
    .line 219
    .line 220
    invoke-virtual {v1}, Lcom/xj/common/config/AppConfig$Companion;->a()Z

    .line 221
    move-result v1

    .line 222
    .line 223
    if-nez v1, :cond_3

    .line 224
    .line 225
    new-instance v1, Lcom/xj/landscape/launcher/utils/RecordCountUtil;

    .line 226
    .line 227
    const-string v2, "null cannot be cast to non-null type androidx.appcompat.app.AppCompatActivity"

    .line 228
    .line 229
    .line 230
    invoke-static {v0, v2}, Lkotlin/jvm/internal/Intrinsics;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 231
    .line 232
    check-cast v0, Landroidx/appcompat/app/AppCompatActivity;

    .line 233
    .line 234
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/d;

    .line 235
    .line 236
    .line 237
    invoke-direct {v2, p0}, Lcom/xj/landscape/launcher/ui/menu/d;-><init>(Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;)V

    .line 238
    .line 239
    .line 240
    invoke-direct {v1, v0, v2}, Lcom/xj/landscape/launcher/utils/RecordCountUtil;-><init>(Landroidx/appcompat/app/AppCompatActivity;Lkotlin/jvm/functions/Function1;)V

    .line 241
    .line 242
    .line 243
    invoke-virtual {v1}, Lcom/xj/landscape/launcher/utils/RecordCountUtil;->j()V

    .line 244
    .line 245
    .line 246
    :cond_3
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->d1()I

    .line 247
    move-result v0

    .line 248
    const/4 v1, -0x1

    .line 249
    const/4 v2, 0x0

    .line 250
    const/4 v3, 0x1

    .line 251
    .line 252
    if-ne v0, v1, :cond_5

    .line 253
    :cond_4
    move v0, v3

    .line 254
    goto :goto_3

    .line 255
    .line 256
    :cond_5
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->n:Ljava/util/List;

    .line 257
    .line 258
    .line 259
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    .line 260
    move-result-object v0

    .line 261
    const/4 v4, 0x0

    .line 262
    .line 263
    .line 264
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    .line 265
    move-result v5

    .line 266
    .line 267
    if-eqz v5, :cond_7

    .line 268
    .line 269
    .line 270
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 271
    move-result-object v5

    .line 272
    .line 273
    check-cast v5, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 274
    .line 275
    .line 276
    invoke-virtual {v5}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;->a()I

    .line 277
    move-result v5

    .line 278
    .line 279
    .line 280
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->d1()I

    .line 281
    move-result v6

    .line 282
    .line 283
    if-ne v5, v6, :cond_6

    .line 284
    move v1, v4

    .line 285
    goto :goto_1

    .line 286
    .line 287
    :cond_6
    add-int/lit8 v4, v4, 0x1

    .line 288
    goto :goto_0

    .line 289
    .line 290
    .line 291
    :cond_7
    :goto_1
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 292
    move-result-object v0

    .line 293
    .line 294
    .line 295
    invoke-virtual {v0}, Ljava/lang/Number;->intValue()I

    .line 296
    move-result v1

    .line 297
    .line 298
    if-ltz v1, :cond_8

    .line 299
    goto :goto_2

    .line 300
    :cond_8
    move-object v0, v2

    .line 301
    .line 302
    :goto_2
    if-eqz v0, :cond_4

    .line 303
    .line 304
    .line 305
    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    .line 306
    move-result v0

    .line 307
    .line 308
    :goto_3
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->p:Lkotlinx/coroutines/Job;

    .line 309
    .line 310
    if-eqz v1, :cond_9

    .line 311
    .line 312
    .line 313
    invoke-static {v1, v2, v3, v2}, Lkotlinx/coroutines/Job$DefaultImpls;->b(Lkotlinx/coroutines/Job;Ljava/util/concurrent/CancellationException;ILjava/lang/Object;)V

    .line 314
    .line 315
    :cond_9
    sget-object v1, Lcom/xj/common/concurrent/ExecutorUtils;->a:Lcom/xj/common/concurrent/ExecutorUtils;

    .line 316
    .line 317
    .line 318
    invoke-static {}, Lkotlinx/coroutines/Dispatchers;->c()Lkotlinx/coroutines/MainCoroutineDispatcher;

    .line 319
    move-result-object v3

    .line 320
    .line 321
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$init$1$9;

    .line 322
    .line 323
    .line 324
    invoke-direct {v4, p1, v0, p0, v2}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$init$1$9;-><init>(Lcom/xj/landscape/launcher/databinding/LlauncherPageMenuBinding;ILcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;Lkotlin/coroutines/Continuation;)V

    .line 325
    .line 326
    .line 327
    invoke-virtual {v1, v3, v4}, Lcom/xj/common/concurrent/ExecutorUtils;->f(Lkotlin/coroutines/CoroutineContext;Lkotlin/jvm/functions/Function2;)Lkotlinx/coroutines/Job;

    .line 328
    move-result-object p1

    .line 329
    .line 330
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->p:Lkotlinx/coroutines/Job;

    .line 331
    :cond_a
    :goto_4
    return-void
.end method

.method public final u1()V
    .locals 13

    .line 1
    .line 2
    .line 3
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    .line 4
    move-result-object v0

    .line 5
    .line 6
    if-nez v0, :cond_0

    .line 7
    return-void

    .line 8
    .line 9
    :cond_0
    iget-object p0, p0, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog;->n:Ljava/util/List;

    .line 10
    .line 11
    new-instance v1, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 12
    .line 13
    const/16 v7, 0xe

    .line 14
    const/4 v8, 0x0

    .line 15
    const/4 v2, -0x1

    .line 16
    const/4 v3, 0x0

    .line 17
    const/4 v4, 0x0

    .line 18
    const/4 v5, 0x0

    .line 19
    const/4 v6, 0x1

    .line 20
    .line 21
    .line 22
    invoke-direct/range {v1 .. v8}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;-><init>(IILjava/lang/String;Ljava/lang/String;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 23
    .line 24
    .line 25
    invoke-interface {p0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 26
    .line 27
    new-instance v2, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 28
    .line 29
    sget v4, Lcom/xj/landscape/launcher/R$drawable;->menu_home_normal:I

    .line 30
    .line 31
    sget v1, Lcom/xj/language/R$string;->llauncher_home:I

    .line 32
    .line 33
    .line 34
    invoke-virtual {v0, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 35
    move-result-object v5

    .line 36
    .line 37
    const-string v1, "getString(...)"

    .line 38
    .line 39
    .line 40
    invoke-static {v5, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 41
    .line 42
    const/16 v8, 0x18

    .line 43
    const/4 v9, 0x0

    .line 44
    const/4 v6, 0x0

    .line 45
    const/4 v7, 0x0

    .line 46
    .line 47
    .line 48
    invoke-direct/range {v2 .. v9}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;-><init>(IILjava/lang/String;Ljava/lang/String;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 49
    .line 50
    .line 51
    invoke-interface {p0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 52
    .line 53
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 54
    .line 55
    sget v5, Lcom/xj/landscape/launcher/R$drawable;->menu_game_normal:I

    .line 56
    .line 57
    sget v2, Lcom/xj/language/R$string;->llauncher_game:I

    .line 58
    .line 59
    .line 60
    invoke-virtual {v0, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 61
    move-result-object v6

    .line 62
    .line 63
    .line 64
    invoke-static {v6, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 65
    .line 66
    const/16 v9, 0x18

    .line 67
    const/4 v10, 0x0

    .line 68
    const/4 v4, 0x1

    .line 69
    const/4 v7, 0x0

    .line 70
    const/4 v8, 0x0

    .line 71
    .line 72
    .line 73
    invoke-direct/range {v3 .. v10}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;-><init>(IILjava/lang/String;Ljava/lang/String;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 74
    .line 75
    .line 76
    invoke-interface {p0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 77
    .line 78
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 79
    .line 80
    sget v6, Lcom/xj/game/R$drawable;->game_ic_steam:I

    .line 81
    .line 82
    sget v2, Lcom/xj/language/R$string;->steam_account_management:I

    .line 83
    .line 84
    .line 85
    invoke-virtual {v0, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 86
    move-result-object v7

    .line 87
    .line 88
    .line 89
    invoke-static {v7, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 90
    .line 91
    const/16 v10, 0x18

    .line 92
    const/4 v11, 0x0

    .line 93
    .line 94
    const/16 v5, 0x8

    .line 95
    const/4 v8, 0x0

    .line 96
    const/4 v9, 0x0

    .line 97
    .line 98
    .line 99
    invoke-direct/range {v4 .. v11}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;-><init>(IILjava/lang/String;Ljava/lang/String;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 100
    .line 101
    .line 102
    invoke-interface {p0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 103
    .line 104
    sget-object v2, Lcom/xj/common/config/AppConfig;->a:Lcom/xj/common/config/AppConfig$Companion;

    .line 105
    .line 106
    .line 107
    invoke-virtual {v2}, Lcom/xj/common/config/AppConfig$Companion;->a()Z

    .line 108
    move-result v3

    .line 109
    .line 110
    if-nez v3, :cond_1

    .line 111
    .line 112
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 113
    .line 114
    sget v6, Lcom/xj/landscape/launcher/R$drawable;->menu_device_normal:I

    .line 115
    .line 116
    sget v3, Lcom/xj/language/R$string;->llauncher_device:I

    .line 117
    .line 118
    .line 119
    invoke-virtual {v0, v3}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 120
    move-result-object v7

    .line 121
    .line 122
    .line 123
    invoke-static {v7, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 124
    .line 125
    const/16 v10, 0x18

    .line 126
    const/4 v11, 0x0

    .line 127
    const/4 v5, 0x2

    .line 128
    const/4 v8, 0x0

    .line 129
    const/4 v9, 0x0

    .line 130
    .line 131
    .line 132
    invoke-direct/range {v4 .. v11}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;-><init>(IILjava/lang/String;Ljava/lang/String;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 133
    .line 134
    .line 135
    invoke-interface {p0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 136
    .line 137
    .line 138
    .line 139
    .line 140
    .line 141
    .line 142
    .line 143
    .line 144
    .line 145
    .line 146
    .line 147
    .line 148
    .line 149
    .line 150
    .line 151
    .line 152
    .line 153
    .line 154
    .line 155
    .line 156
    .line 157
    .line 158
    .line 159
    .line 160
    .line 161
    .line 162
    .line 163
    :cond_1
    invoke-virtual {v2}, Lcom/xj/common/config/AppConfig$Companion;->a()Z

    .line 164
    move-result v2

    .line 165
    .line 166
    if-nez v2, :cond_2

    .line 167
    .line 168
    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 169
    .line 170
    sget v5, Lcom/xj/landscape/launcher/R$drawable;->menu_download_normal:I

    .line 171
    .line 172
    sget v2, Lcom/xj/language/R$string;->llauncher_download:I

    .line 173
    .line 174
    .line 175
    invoke-virtual {v0, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 176
    move-result-object v6

    .line 177
    .line 178
    .line 179
    invoke-static {v6, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 180
    .line 181
    const/16 v9, 0x18

    .line 182
    const/4 v10, 0x0

    .line 183
    const/4 v4, 0x6

    .line 184
    const/4 v7, 0x0

    .line 185
    const/4 v8, 0x0

    .line 186
    .line 187
    .line 188
    invoke-direct/range {v3 .. v10}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;-><init>(IILjava/lang/String;Ljava/lang/String;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 189
    .line 190
    .line 191
    invoke-interface {p0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 192
    .line 193
    :cond_2
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;

    .line 194
    .line 195
    sget v6, Lcom/xj/landscape/launcher/R$drawable;->menu_setting_normal:I

    .line 196
    .line 197
    sget v2, Lcom/xj/language/R$string;->llauncher_setting:I

    .line 198
    .line 199
    .line 200
    invoke-virtual {v0, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 201
    move-result-object v7

    .line 202
    .line 203
    .line 204
    invoke-static {v7, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 205
    .line 206
    const/16 v10, 0x18

    .line 207
    const/4 v11, 0x0

    .line 208
    const/4 v5, 0x7

    .line 209
    const/4 v8, 0x0

    .line 210
    const/4 v9, 0x0

    .line 211
    .line 212
    .line 213
    invoke-direct/range {v4 .. v11}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;-><init>(IILjava/lang/String;Ljava/lang/String;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 214
    .line 215
    .line 216
    invoke-interface {p0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 217

    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;
    sget v6, Lcom/xj/landscape/launcher/R$drawable;->menu_setting_normal:I
    const-string v7, "Components"
    const/16 v10, 0x18
    const/4 v11, 0x0
    const/16 v5, 0x9
    const/4 v8, 0x0
    const/4 v9, 0x0
    invoke-direct/range {v4 .. v11}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;-><init>(IILjava/lang/String;Ljava/lang/String;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V
    invoke-interface {p0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public w0()I
    .locals 0

    .line 1
    .line 2
    sget p0, Lcom/xj/landscape/launcher/R$layout;->llauncher_page_menu:I

    .line 3
    return p0
.end method
