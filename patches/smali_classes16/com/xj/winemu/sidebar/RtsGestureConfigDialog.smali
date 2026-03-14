.class public Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;
.super Ljava/lang/Object;
.source "RtsGestureConfigDialog.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;
.implements Landroid/view/View$OnClickListener;

# instance fields
.field private context:Landroid/content/Context;
.field public dialog:Landroid/app/Dialog;
.field private dialogView:Landroid/view/View;
.field private isInitializing:Z
.field private pendingKey:Ljava/lang/String;
.field private pendingIndex:I

# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->context:Landroid/content/Context;
    
    const/4 v0, 0x1
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->isInitializing:Z

    return-void
.end method

.method public show()V
    .locals 6

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->context:Landroid/content/Context;
    
    if-nez v0, :cond_context_ok
    return-void
    :cond_context_ok

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;
    move-result-object v1
    
    if-nez v1, :cond_inflater_ok
    return-void
    :cond_inflater_ok
    
    const v2, 0x7f0d040c
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;
    move-result-object v1
    iput-object v1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->dialogView:Landroid/view/View;

    # Use plain Dialog with transparent theme (not AlertDialog which forces layout constraints)
    new-instance v2, Landroid/app/Dialog;
    const v3, 0x7f14051c
    invoke-direct {v2, v0, v3}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V
    
    invoke-virtual {v2, v1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V
    
    iput-object v2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->dialog:Landroid/app/Dialog;

    invoke-direct {p0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->setupCheckboxes()V
    
    invoke-direct {p0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->showActionLabels()V
    
    # Setup close button click listener - try both btnClose and tvClose
    :try_start_close
    iget-object v3, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->dialogView:Landroid/view/View;
    if-eqz v3, :cond_no_close_btn
    
    # Try btnClose (outer container)
    const v4, 0x7f0a0e8b
    invoke-virtual {v3, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    if-eqz v4, :try_tv_close
    new-instance v5, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$CloseClickListener;
    invoke-direct {v5, p0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$CloseClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;)V
    invoke-virtual {v4, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    
    :try_tv_close
    # Also try tvClose (inner text view)
    const v4, 0x7f0a0e8c
    invoke-virtual {v3, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    if-eqz v4, :cond_no_close_btn
    new-instance v5, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$CloseClickListener;
    invoke-direct {v5, p0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$CloseClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;)V
    invoke-virtual {v4, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    :cond_no_close_btn
    :try_end_close
    .catch Ljava/lang/Throwable; {:try_start_close .. :try_end_close} :catch_close
    :catch_close
    
    const/4 v1, 0x0
    iput-boolean v1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->isInitializing:Z

    invoke-virtual {v2}, Landroid/app/Dialog;->show()V

    # Configure window for full screen overlay AFTER showing (window is guaranteed)
    :try_start_window
    invoke-virtual {v2}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
    move-result-object v3
    if-eqz v3, :cond_end

    # Set transparent background
    new-instance v4, Landroid/graphics/drawable/ColorDrawable;
    const/4 v5, 0x0
    invoke-direct {v4, v5}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    # Force full-screen window so FrameLayout can center its child
    const/4 v4, -0x1
    const/4 v5, -0x1
    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V

    # Force gravity center
    const/16 v5, 0x11
    invoke-virtual {v3, v5}, Landroid/view/Window;->setGravity(I)V

    # Also set LayoutParams (some devices ignore setGravity)
    invoke-virtual {v3}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;
    move-result-object v4
    if-eqz v4, :skip_gravity
    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->gravity:I
    const/4 v5, 0x0
    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->dimAmount:F
    invoke-virtual {v3, v4}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V
    :skip_gravity
    :try_end_window
    .catch Ljava/lang/Throwable; {:try_start_window .. :try_end_window} :catch_window
    :catch_window
    :cond_end

    return-void
.end method

.method private showActionLabels()V
    .locals 5

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->dialogView:Landroid/view/View;
    if-nez v0, :cond_start
    return-void
    :cond_start
    
    # Show PINCH action label
    const v1, 0x7f0a0f02
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :cond_pinch_done
    
    const/4 v2, 0x0
    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V
    
    instance-of v2, v1, Landroid/widget/TextView;
    if-eqz v2, :cond_pinch_done
    
    check-cast v1, Landroid/widget/TextView;
    const-string v3, "PINCH"
    invoke-virtual {v1, v3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    const-string v2, "PINCH"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v2
    
    if-nez v2, :cond_p1
    # Scroll Wheel ▼
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Scroll Wheel"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    goto :cond_pinch_done
    :cond_p1
    const/4 v3, 0x1
    if-ne v2, v3, :cond_p2
    # +/- Keys ▼
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "+/- Keys"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    goto :cond_pinch_done
    :cond_p2
    # Page Up/Down ▼
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Page Up/Down"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    
    :cond_pinch_done
    
    # Show TWO_FINGER_DRAG action label
    const v1, 0x7f0a0f04
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :cond_done
    
    const/4 v2, 0x0
    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V
    
    instance-of v2, v1, Landroid/widget/TextView;
    if-eqz v2, :cond_done
    
    check-cast v1, Landroid/widget/TextView;
    const-string v3, "TWO_FINGER_DRAG"
    invoke-virtual {v1, v3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    invoke-virtual {v1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    const-string v2, "TWO_FINGER_DRAG"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v2
    
    if-nez v2, :cond_t1
    # Middle Mouse Pan ▼
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Middle Mouse Pan"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    goto :cond_done
    :cond_t1
    const/4 v3, 0x1
    if-ne v2, v3, :cond_t2
    # WASD Keys ▼
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "WASD Keys"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    goto :cond_done
    :cond_t2
    # Arrow Keys ▼
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Arrow Keys"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_done
    return-void
.end method

.method private setupCheckboxes()V
    .locals 4

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->dialogView:Landroid/view/View;
    if-nez v0, :cond_start
    return-void
    :cond_start

    const v1, 0x7f0a0efd
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/CheckBox;
    if-eqz v1, :cond_tap_done
    const-string v2, "TAP"
    invoke-virtual {v1, v2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    const-string v2, "TAP"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v2
    invoke-virtual {v1, v2}, Landroid/widget/CheckBox;->setChecked(Z)V
    invoke-virtual {v1, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    :cond_tap_done

    const v1, 0x7f0a0efe
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/CheckBox;
    if-eqz v1, :cond_lp_done
    const-string v2, "LONG_PRESS"
    invoke-virtual {v1, v2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    const-string v2, "LONG_PRESS"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v2
    invoke-virtual {v1, v2}, Landroid/widget/CheckBox;->setChecked(Z)V
    invoke-virtual {v1, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    :cond_lp_done

    const v1, 0x7f0a0eff
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/CheckBox;
    if-eqz v1, :cond_dt_done
    const-string v2, "DOUBLE_TAP"
    invoke-virtual {v1, v2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    const-string v2, "DOUBLE_TAP"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v2
    invoke-virtual {v1, v2}, Landroid/widget/CheckBox;->setChecked(Z)V
    invoke-virtual {v1, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    :cond_dt_done

    const v1, 0x7f0a0f00
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/CheckBox;
    if-eqz v1, :cond_drag_done
    const-string v2, "DRAG"
    invoke-virtual {v1, v2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    const-string v2, "DRAG"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v2
    invoke-virtual {v1, v2}, Landroid/widget/CheckBox;->setChecked(Z)V
    invoke-virtual {v1, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    :cond_drag_done

    const v1, 0x7f0a0f01
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/CheckBox;
    if-eqz v1, :cond_pinch_done
    const-string v2, "PINCH"
    invoke-virtual {v1, v2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    const-string v2, "PINCH"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v2
    invoke-virtual {v1, v2}, Landroid/widget/CheckBox;->setChecked(Z)V
    invoke-virtual {v1, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    :cond_pinch_done

    const v1, 0x7f0a0f03
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/CheckBox;
    if-eqz v1, :cond_twofinger_done
    const-string v2, "TWO_FINGER_DRAG"
    invoke-virtual {v1, v2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V
    const-string v2, "TWO_FINGER_DRAG"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v2
    invoke-virtual {v1, v2}, Landroid/widget/CheckBox;->setChecked(Z)V
    invoke-virtual {v1, p0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    :cond_twofinger_done

    return-void
.end method

.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 1

    iget-boolean v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->isInitializing:Z
    if-eqz v0, :cond_not_init
    return-void
    :cond_not_init

    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    if-eqz v0, :cond_done
    check-cast v0, Ljava/lang/String;
    
    invoke-static {v0, p2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->setRtsGestureEnabled(Ljava/lang/String;Z)V
    
    :cond_done
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2

    :try_start
    if-eqz p1, :cond_end
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;
    move-result-object v0
    if-eqz v0, :cond_end
    check-cast v0, Ljava/lang/String;
    # Use dialog-only picker for stability
    invoke-direct {p0, v0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->showActionDialog(Ljava/lang/String;)V
    :cond_end
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch_err
    return-void

    :catch_err
    const/4 v1, 0x0
    return-void
.end method

.method private showPinchPicker()V
    .locals 10

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->context:Landroid/content/Context;
    if-eqz v0, :cond_end

    # Get LayoutInflater
    const-string v1, "layout_inflater"
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/view/LayoutInflater;
    if-eqz v1, :cond_end

    # Inflate custom picker layout (0x7f0d040d = rts_action_picker_dialog)
    const v2, 0x7f0d040d
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;
    move-result-object v1

    # Create Dialog with transparent theme
    new-instance v2, Landroid/app/Dialog;
    const v3, 0x7f14051c
    invoke-direct {v2, v0, v3}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V

    invoke-virtual {v2, v1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    # Set option texts
    # Option 0 text (0x7f0a0f06 = rts_action_option_0_text)
    const v3, 0x7f0a0f06
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    check-cast v3, Landroid/widget/TextView;
    const-string v4, "Scroll Wheel"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Option 1 text (0x7f0a0f09 = rts_action_option_1_text)
    const v3, 0x7f0a0f09
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    check-cast v3, Landroid/widget/TextView;
    const-string v4, "+/- Keys"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Option 2 text (0x7f0a0f0c = rts_action_option_2_text)
    const v3, 0x7f0a0f0c
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    check-cast v3, Landroid/widget/TextView;
    const-string v4, "Page Up/Down"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Get current selection from MMKV
    const-string v5, "PINCH"
    const/4 v6, 0x0
    invoke-static {v5, v6}, Lcom/xj/winemu/mapping/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;I)I
    move-result v6

    # Show checkmark for current selection
    const/4 v7, 0x0
    # Check option 0 (0x7f0a0f07 = rts_action_option_0_check)
    const v3, 0x7f0a0f07
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    if-ne v6, v7, :cond_hide_0
    const/4 v8, 0x0
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V
    goto :cond_check_1
    :cond_hide_0
    const/16 v8, 0x8
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_check_1
    # Check option 1 (0x7f0a0f0a = rts_action_option_1_check)
    const v3, 0x7f0a0f0a
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    const/4 v7, 0x1
    if-ne v6, v7, :cond_hide_1
    const/4 v8, 0x0
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V
    goto :cond_check_2
    :cond_hide_1
    const/16 v8, 0x8
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_check_2
    # Check option 2 (0x7f0a0f0d = rts_action_option_2_check)
    const v3, 0x7f0a0f0d
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    const/4 v7, 0x2
    if-ne v6, v7, :cond_hide_2
    const/4 v8, 0x0
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V
    goto :cond_setup_clicks
    :cond_hide_2
    const/16 v8, 0x8
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_setup_clicks
    # Set click listeners
    const-string v9, "PINCH"
    
    # Option 0 click (0x7f0a0f05 = rts_action_option_0)
    const v3, 0x7f0a0f05
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    new-instance v4, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
    const/4 v7, 0x0
    invoke-direct {v4, p0, v9, v7, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Option 1 click (0x7f0a0f08 = rts_action_option_1)
    const v3, 0x7f0a0f08
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    new-instance v4, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
    const/4 v7, 0x1
    invoke-direct {v4, p0, v9, v7, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Option 2 click (0x7f0a0f0b = rts_action_option_2)
    const v3, 0x7f0a0f0b
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    new-instance v4, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
    const/4 v7, 0x2
    invoke-direct {v4, p0, v9, v7, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Set dismiss listener
    new-instance v5, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$DismissListener;
    invoke-direct {v5, p0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$DismissListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;)V
    invoke-virtual {v2, v5}, Landroid/app/Dialog;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)V

    # Show dialog
    invoke-virtual {v2}, Landroid/app/Dialog;->show()V

    :cond_end
    return-void
.end method

.method private showTwoFingerPicker()V
    .locals 10

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->context:Landroid/content/Context;
    if-eqz v0, :cond_end

    # Get LayoutInflater
    const-string v1, "layout_inflater"
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/view/LayoutInflater;
    if-eqz v1, :cond_end

    # Inflate custom picker layout (0x7f0d040d = rts_action_picker_dialog)
    const v2, 0x7f0d040d
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;
    move-result-object v1

    # Create Dialog with transparent theme
    new-instance v2, Landroid/app/Dialog;
    const v3, 0x7f14051c
    invoke-direct {v2, v0, v3}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V

    invoke-virtual {v2, v1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    # Set option texts
    # Option 0 text (0x7f0a0f06 = rts_action_option_0_text)
    const v3, 0x7f0a0f06
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    check-cast v3, Landroid/widget/TextView;
    const-string v4, "Middle Mouse Pan"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Option 1 text (0x7f0a0f09 = rts_action_option_1_text)
    const v3, 0x7f0a0f09
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    check-cast v3, Landroid/widget/TextView;
    const-string v4, "WASD Keys"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Option 2 text (0x7f0a0f0c = rts_action_option_2_text)
    const v3, 0x7f0a0f0c
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    check-cast v3, Landroid/widget/TextView;
    const-string v4, "Arrow Keys"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Get current selection from MMKV
    const-string v5, "TWO_FINGER_DRAG"
    const/4 v6, 0x0
    invoke-static {v5, v6}, Lcom/xj/winemu/mapping/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;I)I
    move-result v6

    # Show checkmark for current selection
    const/4 v7, 0x0
    # Check option 0 (0x7f0a0f07 = rts_action_option_0_check)
    const v3, 0x7f0a0f07
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    if-ne v6, v7, :cond_hide_0
    const/4 v8, 0x0
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V
    goto :cond_check_1
    :cond_hide_0
    const/16 v8, 0x8
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_check_1
    # Check option 1 (0x7f0a0f0a = rts_action_option_1_check)
    const v3, 0x7f0a0f0a
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    const/4 v7, 0x1
    if-ne v6, v7, :cond_hide_1
    const/4 v8, 0x0
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V
    goto :cond_check_2
    :cond_hide_1
    const/16 v8, 0x8
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_check_2
    # Check option 2 (0x7f0a0f0d = rts_action_option_2_check)
    const v3, 0x7f0a0f0d
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    const/4 v7, 0x2
    if-ne v6, v7, :cond_hide_2
    const/4 v8, 0x0
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V
    goto :cond_setup_clicks
    :cond_hide_2
    const/16 v8, 0x8
    invoke-virtual {v3, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_setup_clicks
    # Set click listeners
    const-string v9, "TWO_FINGER_DRAG"
    
    # Option 0 click (0x7f0a0f05 = rts_action_option_0)
    const v3, 0x7f0a0f05
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    new-instance v4, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
    const/4 v7, 0x0
    invoke-direct {v4, p0, v9, v7, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Option 1 click (0x7f0a0f08 = rts_action_option_1)
    const v3, 0x7f0a0f08
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    new-instance v4, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
    const/4 v7, 0x1
    invoke-direct {v4, p0, v9, v7, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Option 2 click (0x7f0a0f0b = rts_action_option_2)
    const v3, 0x7f0a0f0b
    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    new-instance v4, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
    const/4 v7, 0x2
    invoke-direct {v4, p0, v9, v7, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Set dismiss listener
    new-instance v5, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$DismissListener;
    invoke-direct {v5, p0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$DismissListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;)V
    invoke-virtual {v2, v5}, Landroid/app/Dialog;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)V

    # Show dialog
    invoke-virtual {v2}, Landroid/app/Dialog;->show()V

    :cond_end
    return-void
.end method

.method public updateActionLabelForKey(Ljava/lang/String;)V
    .locals 6

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->dialogView:Landroid/view/View;
    if-eqz v0, :cond_end

    const-string v1, "PINCH"
    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :cond_check_two
    const v1, 0x7f0a0f02
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :cond_end
    instance-of v2, v1, Landroid/widget/TextView;
    if-eqz v2, :cond_end
    check-cast v1, Landroid/widget/TextView;
    const-string v2, "PINCH"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v2
    if-nez v2, :cond_p1
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Scroll Wheel"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v5, " \u25BC"
    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    goto :cond_end
    :cond_p1
    const/4 v3, 0x1
    if-ne v2, v3, :cond_p2
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "+/- Keys"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    goto :cond_end
    :cond_p2
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Page Up/Down"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    goto :cond_end

    :cond_check_two
    const-string v1, "TWO_FINGER_DRAG"
    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :cond_end
    const v1, 0x7f0a0f04
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :cond_end
    instance-of v2, v1, Landroid/widget/TextView;
    if-eqz v2, :cond_end
    check-cast v1, Landroid/widget/TextView;
    const-string v2, "TWO_FINGER_DRAG"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v2
    if-nez v2, :cond_t1
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Middle Mouse Pan"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    goto :cond_end
    :cond_t1
    const/4 v3, 0x1
    if-ne v2, v3, :cond_t2
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "WASD Keys"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    goto :cond_end
    :cond_t2
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "Arrow Keys"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v4, " \u25BC"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_end
    return-void
.end method

.method private showActionMenu(Landroid/view/View;Ljava/lang/String;)V
    .locals 1

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->context:Landroid/content/Context;
    if-eqz v0, :cond_end
    if-eqz p2, :cond_end

    # Use the stable dialog picker for all selections to avoid popup crashes/dupes
    invoke-direct {p0, p2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->showActionDialog(Ljava/lang/String;)V

    :cond_end
    return-void
.end method

.method private showActionDialog(Ljava/lang/String;)V
    .locals 12

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->context:Landroid/content/Context;
    if-eqz v0, :cond_end
    if-eqz p1, :cond_end

    :try_start
    # Get LayoutInflater
    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;
    move-result-object v1
    if-eqz v1, :cond_end

    # Inflate custom picker layout (0x7f0d040d = rts_action_picker_dialog)
    const v2, 0x7f0d040d
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :cond_end

    # Create Dialog with transparent theme (0x7f14051c = _XPopup_TransparentDialog)
    new-instance v2, Landroid/app/Dialog;
    const v3, 0x7f14051c
    invoke-direct {v2, v0, v3}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V

    invoke-virtual {v2, v1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    # Check if PINCH or TWO_FINGER_DRAG
    const-string v3, "PINCH"
    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3

    # Set option texts based on gesture type
    # Option 0 text (0x7f0a0f06 = rts_action_option_0_text)
    const v4, 0x7f0a0f06
    invoke-virtual {v1, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    check-cast v4, Landroid/widget/TextView;
    if-eqz v3, :cond_two_text0
    const-string v5, "Scroll Wheel"
    goto :cond_set_text0
    :cond_two_text0
    const-string v5, "Middle Mouse Pan"
    :cond_set_text0
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Option 1 text (0x7f0a0f09 = rts_action_option_1_text)
    const v4, 0x7f0a0f09
    invoke-virtual {v1, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    check-cast v4, Landroid/widget/TextView;
    if-eqz v3, :cond_two_text1
    const-string v5, "+/- Keys"
    goto :cond_set_text1
    :cond_two_text1
    const-string v5, "WASD Keys"
    :cond_set_text1
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Option 2 text (0x7f0a0f0c = rts_action_option_2_text)
    const v4, 0x7f0a0f0c
    invoke-virtual {v1, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    check-cast v4, Landroid/widget/TextView;
    if-eqz v3, :cond_two_text2
    const-string v5, "Page Up/Down"
    goto :cond_set_text2
    :cond_two_text2
    const-string v5, "Arrow Keys"
    :cond_set_text2
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # Get current selection from MMKV
    invoke-static {p1}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v6

    # Show checkmark for current selection
    # Check option 0 (0x7f0a0f07 = rts_action_option_0_check)
    const v4, 0x7f0a0f07
    invoke-virtual {v1, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    const/4 v7, 0x0
    if-ne v6, v7, :cond_hide_0
    const/4 v8, 0x0
    invoke-virtual {v4, v8}, Landroid/view/View;->setVisibility(I)V
    goto :cond_check_1
    :cond_hide_0
    const/16 v8, 0x8
    invoke-virtual {v4, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_check_1
    # Check option 1 (0x7f0a0f0a = rts_action_option_1_check)
    const v4, 0x7f0a0f0a
    invoke-virtual {v1, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    const/4 v7, 0x1
    if-ne v6, v7, :cond_hide_1
    const/4 v8, 0x0
    invoke-virtual {v4, v8}, Landroid/view/View;->setVisibility(I)V
    goto :cond_check_2
    :cond_hide_1
    const/16 v8, 0x8
    invoke-virtual {v4, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_check_2
    # Check option 2 (0x7f0a0f0d = rts_action_option_2_check)
    const v4, 0x7f0a0f0d
    invoke-virtual {v1, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    const/4 v7, 0x2
    if-ne v6, v7, :cond_hide_2
    const/4 v8, 0x0
    invoke-virtual {v4, v8}, Landroid/view/View;->setVisibility(I)V
    goto :cond_setup_clicks
    :cond_hide_2
    const/16 v8, 0x8
    invoke-virtual {v4, v8}, Landroid/view/View;->setVisibility(I)V

    :cond_setup_clicks
    # Set click listeners
    # Option 0 click (0x7f0a0f05 = rts_action_option_0)
    const v4, 0x7f0a0f05
    invoke-virtual {v1, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    new-instance v5, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
    const/4 v7, 0x0
    invoke-direct {v5, p0, p1, v7, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    invoke-virtual {v4, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Option 1 click (0x7f0a0f08 = rts_action_option_1)
    const v4, 0x7f0a0f08
    invoke-virtual {v1, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    new-instance v5, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
    const/4 v7, 0x1
    invoke-direct {v5, p0, p1, v7, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    invoke-virtual {v4, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Option 2 click (0x7f0a0f0b = rts_action_option_2)
    const v4, 0x7f0a0f0b
    invoke-virtual {v1, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    new-instance v5, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;
    const/4 v7, 0x2
    invoke-direct {v5, p0, p1, v7, v2}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$PickerOptionClickListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;Ljava/lang/String;ILandroid/app/Dialog;)V
    invoke-virtual {v4, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # Set dismiss listener
    new-instance v9, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$DismissListener;
    invoke-direct {v9, p0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog$DismissListener;-><init>(Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;)V
    invoke-virtual {v2, v9}, Landroid/app/Dialog;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)V

    # Show dialog
    invoke-virtual {v2}, Landroid/app/Dialog;->show()V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch_err_dialog

    :catch_err_dialog
    nop

    :cond_end
    return-void
.end method

.method public setPendingSelection(Ljava/lang/String;I)V
    .locals 0

    iput-object p1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->pendingKey:Ljava/lang/String;
    iput p2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->pendingIndex:I
    return-void
.end method

.method public applyPendingSelectionIfAny()V
    .locals 4

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->pendingKey:Ljava/lang/String;
    if-eqz v0, :cond_end

    :try_start
    iget v1, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->pendingIndex:I
    invoke-static {v0, v1}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->setRtsGestureAction(Ljava/lang/String;I)V
    invoke-virtual {p0, v0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->updateActionLabelForKey(Ljava/lang/String;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch_err

    :catch_err
    # swallow errors and continue
    nop

    const/4 v2, 0x0
    iput-object v2, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->pendingKey:Ljava/lang/String;
    const/4 v3, 0x0
    iput v3, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->pendingIndex:I

    :cond_end
    return-void
.end method

.method public dismiss()V
    .locals 1

    iget-object v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->dialog:Landroid/app/Dialog;
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :cond_0
    return-void
.end method

.method public refreshUI()V
    .locals 1
    
    const/4 v0, 0x1
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->isInitializing:Z
    
    invoke-direct {p0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->setupCheckboxes()V
    invoke-direct {p0}, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->showActionLabels()V
    
    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/RtsGestureConfigDialog;->isInitializing:Z
    
    return-void
.end method


