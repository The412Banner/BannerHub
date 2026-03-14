.class public final synthetic Lcom/xj/winemu/sidebar/RtsGestureSettingsClickListener;
.super Ljava/lang/Object;
.source "RtsGestureSettingsClickListener.java"

# interfaces
.implements Landroid/view/View$OnClickListener;

# instance fields
.field public final synthetic fragment:Lcom/xj/winemu/sidebar/SidebarControlsFragment;

# direct methods
.method public synthetic constructor <init>(Lcom/xj/winemu/sidebar/SidebarControlsFragment;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureSettingsClickListener;->fragment:Lcom/xj/winemu/sidebar/SidebarControlsFragment;

    return-void
.end method

# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2

    # Get context from fragment
    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureSettingsClickListener;->fragment:Lcom/xj/winemu/sidebar/SidebarControlsFragment;
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v0

    if-eqz v0, :cond_0

    # Create and show the dialog
    new-instance v1, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
    invoke-direct {v1, v0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;-><init>(Landroid/content/Context;)V
    invoke-virtual {v1}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->show()V

    :cond_0
    return-void
.end method
