.class public final synthetic Lcom/xj/winemu/sidebar/SustainedPerfSwitchClickListener;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Lkotlin/jvm/functions/Function0;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lkotlin/jvm/functions/Function0<",
        "Lkotlin/Unit;",
        ">;"
    }
.end annotation


# instance fields
.field public final synthetic a:Lcom/xj/winemu/view/SidebarSwitchItemView;


# direct methods
.method public synthetic constructor <init>(Lcom/xj/winemu/view/SidebarSwitchItemView;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/SustainedPerfSwitchClickListener;->a:Lcom/xj/winemu/view/SidebarSwitchItemView;

    return-void
.end method


# virtual methods
.method public final invoke()Ljava/lang/Object;
    .locals 2

    # Get current switch state and toggle it
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SustainedPerfSwitchClickListener;->a:Lcom/xj/winemu/view/SidebarSwitchItemView;

    invoke-virtual {v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z
    move-result v1

    xor-int/lit8 v1, v1, 0x1

    # Update switch UI
    invoke-virtual {v0, v1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    # Save pref and apply to window
    invoke-static {v1}, Lcom/xj/winemu/WineActivity;->toggleSustainedPerf(Z)V

    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    return-object v0
.end method
