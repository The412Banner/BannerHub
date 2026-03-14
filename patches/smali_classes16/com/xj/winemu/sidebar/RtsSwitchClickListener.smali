.class public final synthetic Lcom/xj/winemu/sidebar/RtsSwitchClickListener;
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
.field public final synthetic a:Lcom/xj/winemu/sidebar/SidebarControlsFragment;

.field public final synthetic b:Lcom/xj/winemu/view/SidebarSwitchItemView;


# direct methods
.method public synthetic constructor <init>(Lcom/xj/winemu/sidebar/SidebarControlsFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsSwitchClickListener;->a:Lcom/xj/winemu/sidebar/SidebarControlsFragment;

    iput-object p2, p0, Lcom/xj/winemu/sidebar/RtsSwitchClickListener;->b:Lcom/xj/winemu/view/SidebarSwitchItemView;

    return-void
.end method


# virtual methods
.method public final invoke()Ljava/lang/Object;
    .locals 3

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsSwitchClickListener;->b:Lcom/xj/winemu/view/SidebarSwitchItemView;

    # Toggle the switch state
    invoke-virtual {v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z
    move-result v1

    xor-int/lit8 v1, v1, 0x1

    invoke-virtual {v0, v1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    # Save to preferences
    invoke-static {v1}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->setRtsTouchControlsEnabled(Z)V

    # Immediately toggle overlay state in the running activity
    invoke-static {v1}, Lcom/xj/winemu/WineActivity;->toggleRtsTouchOverlay(Z)V
    
    # Update gear button visibility
    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsSwitchClickListener;->a:Lcom/xj/winemu/sidebar/SidebarControlsFragment;
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getView()Landroid/view/View;
    move-result-object v0
    if-eqz v0, :cond_skip_gear
    
    const v2, 0x7f0a0efc
    invoke-virtual {v0, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v0
    if-eqz v0, :cond_skip_gear
    
    if-eqz v1, :cond_gear_gone
    
    # RTS enabled - show gear button
    const/4 v2, 0x0
    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V
    goto :cond_skip_gear
    
    :cond_gear_gone
    # RTS disabled - hide gear button
    const/16 v2, 0x8
    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V
    
    :cond_skip_gear
    sget-object v0, Lkotlin/Unit;->a:Lkotlin/Unit;

    return-object v0
.end method
