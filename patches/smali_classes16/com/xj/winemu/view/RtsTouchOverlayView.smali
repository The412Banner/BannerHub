.class public Lcom/xj/winemu/view/RtsTouchOverlayView;
.super Landroid/view/View;
.source "RtsTouchOverlayView.kt"


# instance fields
.field public a:Lcom/winemu/openapi/WinUIBridge;
.field public b:Landroid/view/View;
.field public lastTouchX:F
.field public lastTouchY:F
.field public lastGameX:F
.field public lastGameY:F
.field public tracking:Z
.field public dragging:Z
.field public downTime:J
.field public startX:F
.field public startY:F
# Two-finger pan fields
.field public twoFingerPanning:Z
.field public twoFingerStartX:F
.field public twoFingerStartY:F
.field public twoFingerLastX:F
.field public twoFingerLastY:F
.field public panLeft:Z
.field public panRight:Z
.field public panUp:Z
.field public panDown:Z
# Pinch-to-zoom fields
.field public pinching:Z
.field public initialPinchDistance:F
.field public lastPinchDistance:F
.field public accumulatedZoom:F
# Double-tap detection fields
.field public lastTapTime:J
.field public lastTapX:F
.field public lastTapY:F
.field public doubleTapCandidate:Z
.field public doubleTapDelivered:Z
.field public forwardingButtons:Z


.method public constructor <init>(Landroid/content/Context;)V
    .locals 2

    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    
    # Initialize tracking fields
    const/4 v0, 0x0
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchX:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchY:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastGameX:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastGameY:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->startX:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->startY:F
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->tracking:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->dragging:Z
    # Initialize two-finger pan fields
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerPanning:Z
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerStartX:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerStartY:F
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerLastX:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerLastY:F
    # Initialize pinch-to-zoom fields
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->pinching:Z
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->initialPinchDistance:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastPinchDistance:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->accumulatedZoom:F
    # Initialize double-tap fields
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapX:F
    iput v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapY:F
    const-wide/16 v0, 0x0
    iput-wide v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->downTime:J
    iput-wide v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapTime:J
    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapCandidate:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapDelivered:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->forwardingButtons:Z

    return-void
.end method


.method public setWinUIBridge(Lcom/winemu/openapi/WinUIBridge;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    return-void
.end method


.method public setButtonsView(Landroid/view/View;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->b:Landroid/view/View;
    return-void
.end method


.method public dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 13

    # Check if RTS controls enabled
    invoke-static {}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsTouchControlsEnabled()Z
    move-result v0
    if-nez v0, :cond_enabled
    
    # Not enabled - return false to pass event to underlying views
    const/4 v0, 0x0
    return v0

    :cond_enabled
    # Get action and pointer count
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I
    move-result v0
    
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getPointerCount()I
    move-result v1
    
    # If already forwarding to GameHub buttons, keep passing events through and skip RTS handling
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->forwardingButtons:Z
    if-eqz v2, :cond_check_button_down
    
    iget-object v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->b:Landroid/view/View;
    if-eqz v2, :cond_forward_return
    invoke-virtual {v2, p1}, Landroid/view/View;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    :cond_forward_return
    
    # Reset forwarding when the gesture ends
    const/4 v2, 0x1
    if-eq v0, v2, :cond_reset_forwarding
    const/4 v2, 0x3
    if-eq v0, v2, :cond_reset_forwarding
    const/4 v2, 0x6
    if-ne v0, v2, :cond_forward_return_true
    
    :cond_reset_forwarding
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->forwardingButtons:Z
    
    :cond_forward_return_true
    const/4 v0, 0x1
    return v0
    
    :cond_check_button_down
    # On down events, see if touch hits a GameHub control; if so, forward only to buttons
    const/4 v2, 0x0
    if-eq v0, v2, :cond_maybe_forward_buttons
    const/4 v3, 0x5
    if-ne v0, v3, :cond_after_button_check
    
    :cond_maybe_forward_buttons
    iget-object v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->b:Landroid/view/View;
    if-eqz v2, :cond_after_button_check
    instance-of v3, v2, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;
    if-eqz v3, :cond_after_button_check
    
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I
    move-result v3
    invoke-virtual {p1, v3}, Landroid/view/MotionEvent;->getX(I)F
    move-result v4
    invoke-virtual {p1, v3}, Landroid/view/MotionEvent;->getY(I)F
    move-result v3
    
    check-cast v2, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;
    invoke-virtual {v2, v4, v3}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsView;->w(FF)Lcom/xj/pcvirtualbtn/inputcontrols/ControlElement;
    move-result-object v3
    if-eqz v3, :cond_after_button_check
    
    const/4 v3, 0x1
    iput-boolean v3, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->forwardingButtons:Z
    invoke-virtual {v2, p1}, Landroid/view/View;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    const/4 v0, 0x1
    return v0
    
    :cond_after_button_check
    
    # Check for two-finger gestures (pointer count >= 2)
    const/4 v9, 0x2
    if-lt v1, v9, :cond_single_finger
    
    # === TWO FINGER HANDLING ===
    # Get center point of two fingers
    const/4 v2, 0x0
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F
    move-result v3
    const/4 v2, 0x1
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F
    move-result v4
    add-float v5, v3, v4
    const/high16 v6, 0x40000000  # 2.0f
    div-float/2addr v5, v6  # centerX
    
    const/4 v2, 0x0
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F
    move-result v3
    const/4 v2, 0x1
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F
    move-result v4
    add-float v6, v3, v4
    const/high16 v7, 0x40000000  # 2.0f
    div-float/2addr v6, v7  # centerY
    
    # Check if this is start of two-finger gesture (POINTER_DOWN = 5)
    const/4 v2, 0x5
    if-ne v0, v2, :cond_not_pointer_down
    
    # Cancel any single-finger tracking and ensure left is released
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseLeftButton()V
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->tracking:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->dragging:Z
    
    # Calculate initial distance between two fingers for pinch detection
    # Get finger positions again (already calculated v3,v4 as X coords above)
    const/4 v2, 0x0
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F
    move-result v7
    const/4 v2, 0x1
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F
    move-result v8
    const/4 v2, 0x0
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F
    move-result v9
    const/4 v2, 0x1
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F
    move-result v10
    
    # Calculate distance: sqrt((x2-x1)^2 + (y2-y1)^2)
    sub-float v11, v8, v7  # deltaX
    sub-float v0, v10, v9  # deltaY
    mul-float v11, v11, v11  # deltaX^2
    mul-float v0, v0, v0  # deltaY^2
    add-float v11, v11, v0  # deltaX^2 + deltaY^2
    float-to-double v0, v11
    invoke-static {v0, v1}, Ljava/lang/Math;->sqrt(D)D
    move-result-wide v0
    double-to-float v11, v0  # distance
    
    # Start two-finger pan (will switch to pinch if distance changes)
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerPanning:Z
    iput v5, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerStartX:F
    iput v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerStartY:F
    iput v5, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerLastX:F
    iput v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerLastY:F
    
    # Check TWO_FINGER_DRAG action - only press middle mouse if action is 0
    const-string v2, "TWO_FINGER_DRAG"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v2
    if-nez v2, :cond_skip_middle_press
    # Action 0: Press middle mouse to initiate camera pan
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressMiddleButton()V
    :cond_skip_middle_press
    
    # Store initial pinch distance
    iput v11, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->initialPinchDistance:F
    iput v11, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastPinchDistance:F
    # Clear pinch flag and accumulated zoom
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->pinching:Z
    iput v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->accumulatedZoom:F
    # Clear pan direction flags
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    goto :cond_return
    
    :cond_not_pointer_down
    # Check for two-finger move (ACTION_MOVE = 2) while panning or pinching
    const/4 v2, 0x2
    if-ne v0, v2, :cond_not_two_move
    
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerPanning:Z
    if-nez v2, :cond_check_pan_or_pinch
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->pinching:Z
    if-eqz v2, :cond_return
    
    :cond_check_pan_or_pinch
    # Calculate current distance between fingers
    const/4 v2, 0x0
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F
    move-result v7
    const/4 v2, 0x1
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F
    move-result v8
    const/4 v2, 0x0
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F
    move-result v9
    const/4 v2, 0x1
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F
    move-result v10
    
    # Calculate distance: sqrt((x2-x1)^2 + (y2-y1)^2)
    sub-float v11, v8, v7  # deltaX
    sub-float v0, v10, v9  # deltaY
    mul-float v11, v11, v11  # deltaX^2
    mul-float v0, v0, v0  # deltaY^2
    add-float v11, v11, v0  # deltaX^2 + deltaY^2
    float-to-double v0, v11
    invoke-static {v0, v1}, Ljava/lang/Math;->sqrt(D)D
    move-result-wide v0
    double-to-float v11, v0  # currentDistance
    
    # Check if we should switch to pinch mode (distance changed by 50+ pixels)
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->pinching:Z
    if-nez v2, :cond_already_pinching
    
    # Not pinching yet - check if distance changed enough
    iget v7, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->initialPinchDistance:F
    sub-float v8, v11, v7  # distanceChange
    invoke-static {v8}, Ljava/lang/Math;->abs(F)F
    move-result v8
    const/high16 v9, 0x42480000  # 50.0f threshold
    cmpl-float v8, v8, v9
    if-lez v8, :cond_do_panning
    
    # Distance changed by 50+ pixels - switch to pinch mode
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->pinching:Z
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerPanning:Z
    # End any active panning
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->endTwoFingerPan()V
    # Release middle button so pinch does not continue to pan
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseMiddleButton()V
    # Ensure left button is not held during pinch
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseLeftButton()V
    # Update lastPinchDistance for continuous zooming
    iput v11, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastPinchDistance:F
    goto :cond_return
    
    :cond_already_pinching
    # Already pinching - handle zoom
    # First check if PINCH gesture is enabled
    const-string v0, "PINCH"
    invoke-static {v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v0
    if-eqz v0, :cond_scroll_done  # Skip if disabled
    
    iget v7, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastPinchDistance:F
    sub-float v8, v11, v7  # distanceDelta = current - last
    
    # Add to accumulated zoom
    iget v9, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->accumulatedZoom:F
    add-float v9, v9, v8
    iput v9, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->accumulatedZoom:F
    
    # Send scroll events for every 5 pixels of accumulated zoom (very aggressive)
    const/high16 v10, 0x40a00000  # 5.0f (sensitivity - very responsive)
    
    # Get the configured action for PINCH (0=scroll, 1=plus/minus, 2=page up/down)
    const-string v0, "PINCH"
    invoke-static {v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v12  # v12 = pinch action
    
    :loop_scroll_events
    invoke-static {v9}, Ljava/lang/Math;->abs(F)F
    move-result v0
    cmpl-float v0, v0, v10
    if-ltz v0, :cond_scroll_done
    
    # Determine scroll direction (zoom in or out)
    const/4 v0, 0x0
    cmpl-float v0, v9, v0
    if-lez v0, :cond_zoom_out
    
    # Zoom out (pinch outward = fingers spreading)
    const/4 v0, 0x1  # direction = +1
    
    # Check action type and call appropriate method
    if-nez v12, :cond_zoom_out_check_action1
    # Action 0: Mouse Wheel (default)
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    goto :cond_zoom_out_done
    
    :cond_zoom_out_check_action1
    const/4 v1, 0x1
    if-ne v12, v1, :cond_zoom_out_action2
    # Action 1: Plus/Minus Keys
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendPlusMinusKey(I)V
    goto :cond_zoom_out_done
    
    :cond_zoom_out_action2
    # Action 2: Page Up/Down
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendPageUpDownKey(I)V
    
    :cond_zoom_out_done
    sub-float v9, v9, v10
    goto :loop_scroll_continue
    
    :cond_zoom_out
    # Zoom in (pinch inward = fingers coming together)
    const/4 v0, -0x1  # direction = -1
    
    # Check action type and call appropriate method
    if-nez v12, :cond_zoom_in_check_action1
    # Action 0: Mouse Wheel (default)
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendScrollWheel(I)V
    goto :cond_zoom_in_done
    
    :cond_zoom_in_check_action1
    const/4 v1, 0x1
    if-ne v12, v1, :cond_zoom_in_action2
    # Action 1: Plus/Minus Keys
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendPlusMinusKey(I)V
    goto :cond_zoom_in_done
    
    :cond_zoom_in_action2
    # Action 2: Page Up/Down
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->sendPageUpDownKey(I)V
    
    :cond_zoom_in_done
    add-float v9, v9, v10
    
    :loop_scroll_continue
    iput v9, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->accumulatedZoom:F
    goto :loop_scroll_events
    
    :cond_scroll_done
    # Update last pinch distance
    iput v11, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastPinchDistance:F
    goto :cond_return
    
    :cond_do_panning
    # Not pinching - do panning based on configured action
    # First check if TWO_FINGER_DRAG gesture is enabled
    const-string v0, "TWO_FINGER_DRAG"
    invoke-static {v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v0
    if-eqz v0, :cond_pan_update_pos  # Skip action if disabled, just update position
    
    # Get the configured action (0=middle mouse, 1=WASD, 2=arrow keys)
    const-string v0, "TWO_FINGER_DRAG"
    invoke-static {v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v12  # v12 = pan action
    
    # Calculate delta from last center position for relative movement
    iget v7, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerLastX:F
    sub-float v7, v5, v7  # deltaX = centerX - lastX
    
    iget v8, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerLastY:F
    sub-float v8, v6, v8  # deltaY = centerY - lastY
    
    # Branch based on action
    if-nez v12, :cond_pan_check_wasd
    
    # Action 0: Middle mouse drag (default)
    # Apply sensitivity scaling, inversion, and deadzone
    const/high16 v0, 0x3e800000  # 0.25f
    mul-float v7, v7, v0
    mul-float v8, v8, v0
    # invert so map moves with fingers
    const/high16 v1, 0xbf800000  # -1.0f
    mul-float v7, v7, v1
    mul-float v8, v8, v1
    # Send relative mouse movement while middle button is held
    invoke-virtual {p0, v7, v8}, Lcom/xj/winemu/view/RtsTouchOverlayView;->moveCursorBy(FF)V
    goto :cond_pan_update_pos
    
    :cond_pan_check_wasd
    const/4 v1, 0x1
    if-ne v12, v1, :cond_pan_arrows
    
    # Action 1: WASD keys - use direction-based key press/release
    # Threshold for direction detection (50 pixels from start)
    iget v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerStartX:F
    sub-float v7, v5, v0  # deltaX from start
    iget v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerStartY:F
    sub-float v8, v6, v0  # deltaY from start
    
    const/high16 v10, 0x42480000  # 50.0f threshold
    const/high16 v11, 0xc2480000  # -50.0f
    
    # Horizontal: left (A) / right (D)
    cmpg-float v2, v7, v11
    if-gez v2, :cond_wasd_check_right
    # deltaX < -50, press A (left)
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    if-nez v2, :cond_wasd_check_vertical
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressWasdKey(I)V
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    if-eqz v2, :cond_wasd_check_vertical
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    const/4 v2, 0x2
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    goto :cond_wasd_check_vertical
    
    :cond_wasd_check_right
    cmpl-float v2, v7, v10
    if-lez v2, :cond_wasd_center_h
    # deltaX > 50, press D (right)
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    if-nez v2, :cond_wasd_check_vertical
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    const/4 v2, 0x2
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressWasdKey(I)V
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    if-eqz v2, :cond_wasd_check_vertical
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    const/4 v2, 0x1
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    goto :cond_wasd_check_vertical
    
    :cond_wasd_center_h
    # Release both A and D
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    if-eqz v2, :cond_wasd_release_right
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    const/4 v2, 0x1
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    :cond_wasd_release_right
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    if-eqz v2, :cond_wasd_check_vertical
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    const/4 v2, 0x2
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    
    :cond_wasd_check_vertical
    # Vertical: up (W) / down (S)
    cmpg-float v2, v8, v11
    if-gez v2, :cond_wasd_check_down
    # deltaY < -50, press W (up)
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    if-nez v2, :cond_pan_update_pos
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    const/4 v2, 0x3
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressWasdKey(I)V
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    if-eqz v2, :cond_pan_update_pos
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    const/4 v2, 0x4
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    goto :cond_pan_update_pos
    
    :cond_wasd_check_down
    cmpl-float v2, v8, v10
    if-lez v2, :cond_wasd_center_v
    # deltaY > 50, press S (down)
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    if-nez v2, :cond_pan_update_pos
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    const/4 v2, 0x4
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressWasdKey(I)V
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    if-eqz v2, :cond_pan_update_pos
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    const/4 v2, 0x3
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    goto :cond_pan_update_pos
    
    :cond_wasd_center_v
    # Release both W and S
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    if-eqz v2, :cond_wasd_release_down
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    const/4 v2, 0x3
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    :cond_wasd_release_down
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    if-eqz v2, :cond_pan_update_pos
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    const/4 v2, 0x4
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    goto :cond_pan_update_pos
    
    :cond_pan_arrows
    # Action 2: Arrow keys - use direction-based key press/release
    # Threshold for direction detection (50 pixels from start)
    iget v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerStartX:F
    sub-float v7, v5, v0  # deltaX from start
    iget v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerStartY:F
    sub-float v8, v6, v0  # deltaY from start
    
    const/high16 v10, 0x42480000  # 50.0f
    const/high16 v11, 0xc2480000  # -50.0f
    
    # Check horizontal direction (left/right)
    # If deltaX < -50 and not already pressing left, press left arrow
    cmpg-float v2, v7, v11
    if-gez v2, :cond_check_right
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    if-nez v2, :cond_check_vertical
    # Start pressing left
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressArrowKey(I)V
    # Release right if pressed
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    if-eqz v2, :cond_check_vertical
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    const/4 v2, 0x2
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    goto :cond_check_vertical
    
    :cond_check_right
    # If deltaX > 50 and not already pressing right, press right arrow
    cmpl-float v2, v7, v10
    if-lez v2, :cond_check_center_h
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    if-nez v2, :cond_check_vertical
    # Start pressing right
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    const/4 v2, 0x2
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressArrowKey(I)V
    # Release left if pressed
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    if-eqz v2, :cond_check_vertical
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    const/4 v2, 0x1
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    goto :cond_check_vertical
    
    :cond_check_center_h
    # If deltaX is between -50 and 50, release both left and right
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    if-eqz v2, :cond_check_release_right
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    const/4 v2, 0x1
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    :cond_check_release_right
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    if-eqz v2, :cond_check_vertical
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    const/4 v2, 0x2
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    
    :cond_check_vertical
    # Check vertical direction (up/down)
    # If deltaY < -50 and not already pressing up, press up arrow
    cmpg-float v2, v8, v11
    if-gez v2, :cond_check_down
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    if-nez v2, :cond_return
    # Start pressing up
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    const/4 v2, 0x3
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressArrowKey(I)V
    # Release down if pressed
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    if-eqz v2, :cond_return
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    const/4 v2, 0x4
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    goto :cond_return
    
    :cond_check_down
    # If deltaY > 50 and not already pressing down, press down arrow
    cmpl-float v2, v8, v10
    if-lez v2, :cond_check_center_v
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    if-nez v2, :cond_return
    # Start pressing down
    const/4 v2, 0x1
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    const/4 v2, 0x4
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressArrowKey(I)V
    # Release up if pressed
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    if-eqz v2, :cond_return
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    const/4 v2, 0x3
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    goto :cond_return
    
    :cond_check_center_v
    # If deltaY is between -50 and 50, release both up and down
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    if-eqz v2, :cond_check_release_down
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    const/4 v2, 0x3
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    :cond_check_release_down
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    if-eqz v2, :cond_pan_update_pos
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    const/4 v2, 0x4
    invoke-virtual {p0, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    
    :cond_pan_update_pos
    # Update last center position for all pan methods
    iput v5, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerLastX:F
    iput v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerLastY:F
    goto :cond_return
    
    :cond_not_two_move
    # Check for pointer up (POINTER_UP = 6) - second finger lifted
    const/4 v2, 0x6
    if-ne v0, v2, :cond_return
    
    # End two-finger pan - release keys based on configured action
    # Get action to know which keys to release
    const-string v2, "TWO_FINGER_DRAG"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v2
    
    if-nez v2, :cond_end_check_wasd
    # Action 0: Release middle mouse
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseMiddleButton()V
    goto :cond_end_cleanup
    
    :cond_end_check_wasd
    const/4 v3, 0x1
    if-ne v2, v3, :cond_end_arrows
    # Action 1: Release WASD keys
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->endWasdPan()V
    goto :cond_end_cleanup
    
    :cond_end_arrows
    # Action 2: Release arrow keys
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->endTwoFingerPan()V
    
    :cond_end_cleanup
    # Ensure left button is not held after two-finger end
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseLeftButton()V
    # Clear pinching state
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->pinching:Z
    iput v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->accumulatedZoom:F
    # Clear pan direction flags
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerPanning:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    goto :cond_return
    
    # === SINGLE FINGER HANDLING ===
    :cond_single_finger
    # Check if we were two-finger panning/pinching and now only have one finger
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerPanning:Z
    if-nez v2, :cond_was_two_finger
    iget-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->pinching:Z
    if-eqz v2, :cond_normal_single
    
    :cond_was_two_finger
    # End two-finger pan - release keys based on configured action
    const-string v2, "TWO_FINGER_DRAG"
    invoke-static {v2}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureAction(Ljava/lang/String;)I
    move-result v2
    
    if-nez v2, :cond_was_check_wasd
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseMiddleButton()V
    goto :cond_was_cleanup
    
    :cond_was_check_wasd
    const/4 v3, 0x1
    if-ne v2, v3, :cond_was_arrows
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->endWasdPan()V
    goto :cond_was_cleanup
    
    :cond_was_arrows
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->endTwoFingerPan()V
    
    :cond_was_cleanup
    # Clear pinching state
    const/4 v2, 0x0
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->pinching:Z
    iput v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->accumulatedZoom:F
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerPanning:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    iput-boolean v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    # Don't process this touch as single finger, let user lift completely
    goto :cond_return
    
    :cond_normal_single
    # Get touch coordinates for single finger
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F
    move-result v2
    
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F
    move-result v3
    
    # On ACTION_DOWN (0), warp cursor to touch position and start tracking
    if-nez v0, :cond_not_down
    
    # Start tracking, not dragging yet
    const/4 v1, 0x1
    iput-boolean v1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->tracking:Z
    const/4 v1, 0x0
    iput-boolean v1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->dragging:Z
    
    # Store initial touch position for movement threshold check
    iput v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchX:F
    iput v3, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchY:F
    iput v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->startX:F
    iput v3, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->startY:F
    
    # Store down time for long press detection
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v4
    iput-wide v4, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->downTime:J

    # Evaluate if this down could be a double-tap based on last tap time and distance
    iget-wide v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapTime:J
    const-wide/16 v8, 0x0
    cmp-long v10, v6, v8
    if-nez v10, :cond_check_double_window
    const/4 v6, 0x0
    iput-boolean v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapCandidate:Z
    iput-boolean v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapDelivered:Z
    goto :cond_after_double_check

    :cond_check_double_window
    sub-long/2addr v4, v6  # reuse v4 as elapsed since last tap
    const-wide/16 v8, 0xfa  # 250ms window
    cmp-long v10, v4, v8
    if-gez v10, :cond_no_double_tap

    iget v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapX:F
    sub-float v6, v2, v6
    invoke-static {v6}, Ljava/lang/Math;->abs(F)F
    move-result v6
    iget v7, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapY:F
    sub-float v7, v3, v7
    invoke-static {v7}, Ljava/lang/Math;->abs(F)F
    move-result v7
    const/high16 v8, 0x42480000  # 50.0f distance window
    cmpg-float v9, v6, v8
    if-gtz v9, :cond_no_double_tap
    cmpg-float v6, v7, v8
    if-gtz v6, :cond_no_double_tap

    const/4 v6, 0x1
    iput-boolean v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapCandidate:Z
    iput-boolean v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapDelivered:Z
    goto :cond_after_double_check

    :cond_no_double_tap
    const/4 v6, 0x0
    iput-boolean v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapCandidate:Z
    iput-boolean v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapDelivered:Z

    :cond_after_double_check
    
    # Warp cursor to touch position
    invoke-virtual {p0, v2, v3}, Lcom/xj/winemu/view/RtsTouchOverlayView;->warpCursorTo(FF)V

    # If this is the second tap in the window, emit TWO clicks (double-click) immediately
    iget-boolean v10, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapCandidate:Z
    if-eqz v10, :cond_no_double_action_down
    iget-boolean v10, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapDelivered:Z
    if-eqz v10, :cond_no_double_action_down
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->doClick()V
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->doClick()V
    goto :cond_return

    :cond_no_double_action_down
    # Don't press anything on ACTION_DOWN - wait to see what gesture unfolds
    # This prevents interfering left-clicks when user is doing a long-press for right-click
    
    goto :cond_return

    :cond_not_down
    # On ACTION_MOVE (2)
    const/4 v1, 0x2
    if-ne v0, v1, :cond_not_move
    
    # Check if we're tracking
    iget-boolean v1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->tracking:Z
    if-eqz v1, :cond_return
    
    # Check if finger moved significantly from last position (threshold = 5 pixels for flicker fix)
    iget v4, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchX:F
    sub-float v4, v2, v4
    invoke-static {v4}, Ljava/lang/Math;->abs(F)F
    move-result v4
    
    iget v5, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchY:F
    sub-float v5, v3, v5
    invoke-static {v5}, Ljava/lang/Math;->abs(F)F
    move-result v5
    
    # Only update cursor if moved more than 5 pixels (reduces flicker)
    const/high16 v6, 0x40a00000  # 5.0f
    cmpg-float v7, v4, v6
    if-gtz v7, :cond_do_move
    cmpg-float v7, v5, v6
    if-lez v7, :cond_return  # Skip if barely moved
    
    :cond_do_move
    # Update last touch position
    iput v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchX:F
    iput v3, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchY:F
    
    # Check if this is start of drag (moved > 20 pixels from start)
    iget-boolean v4, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->dragging:Z
    if-nez v4, :cond_already_dragging
    
    # Check distance from start
    iget v4, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->startX:F
    sub-float v4, v2, v4
    invoke-static {v4}, Ljava/lang/Math;->abs(F)F
    move-result v4
    
    iget v5, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->startY:F
    sub-float v5, v3, v5
    invoke-static {v5}, Ljava/lang/Math;->abs(F)F
    move-result v5
    
    const/high16 v6, 0x41200000  # 10.0f (drag threshold - reduced for better button clicks)
    cmpg-float v7, v4, v6
    if-gtz v7, :cond_start_drag
    cmpg-float v7, v5, v6
    if-lez v7, :cond_already_dragging
    
    :cond_start_drag
    # Check if DRAG gesture is enabled before starting drag
    const-string v4, "DRAG"
    invoke-static {v4}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v4
    if-eqz v4, :cond_already_dragging  # Skip drag initiation if disabled
    
    # Start dragging - press left button and hold
    const/4 v4, 0x1
    iput-boolean v4, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->dragging:Z
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->pressLeftButton()V
    
    :cond_already_dragging
    # Use warp for all movement - cursor stays exactly under finger
    invoke-virtual {p0, v2, v3}, Lcom/xj/winemu/view/RtsTouchOverlayView;->warpCursorTo(FF)V
    
    goto :cond_return

    :cond_not_move
    # On ACTION_UP (1)
    const/4 v1, 0x1
    if-ne v0, v1, :cond_return
    
    # Check if we were tracking at all (skip if not - e.g. after two-finger pan)
    iget-boolean v4, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->tracking:Z
    if-eqz v4, :cond_cleanup
    
    # Check if we were dragging
    iget-boolean v4, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->dragging:Z
    if-eqz v4, :cond_not_dragging
    
    # Was dragging - release left button
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseLeftButton()V
    goto :cond_cleanup
    
    :cond_not_dragging
    # Not dragging - check for long press (right click) vs tap (left click)
    # Calculate touch duration
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v4
    iget-wide v6, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->downTime:J
    sub-long/2addr v4, v6  # v4 = elapsed time in ms

    # If this was flagged as a double tap and already delivered on ACTION_DOWN, just clean up
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapCandidate:Z
    if-eqz v0, :cond_check_longpress
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapDelivered:Z
    if-eqz v0, :cond_check_longpress
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseLeftButton()V
    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapCandidate:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapDelivered:Z
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v4
    iput-wide v4, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapTime:J
    iput v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapX:F
    iput v3, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapY:F
    goto :cond_cleanup

    :cond_check_longpress
    
    # Check duration: >= 300ms = long press = right click
    const-wide/16 v6, 0x12c  # 300ms
    cmp-long v0, v4, v6
    if-ltz v0, :cond_left_click
    
    # Long press - check if LONG_PRESS gesture is enabled
    const-string v0, "LONG_PRESS"
    invoke-static {v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v0
    if-eqz v0, :cond_cleanup  # Skip right click if disabled
    
    # Long press - do right click only (no left button involved)
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->doRightClick()V
    goto :cond_cleanup
    
    :cond_left_click
    # Normal tap - check if TAP gesture is enabled
    const-string v0, "TAP"
    invoke-static {v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->getRtsGestureEnabled(Ljava/lang/String;)Z
    move-result v0
    if-eqz v0, :cond_skip_tap  # Skip tap action if disabled
    
    # Normal tap: do a complete click (press + release)
    invoke-virtual {p0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->doClick()V
    
    # Save tap time and position (still tracked for future heuristics)
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v4
    iput-wide v4, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapTime:J
    iput v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapX:F
    iput v3, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTapY:F
    goto :cond_cleanup
    
    :cond_skip_tap
    # Tap disabled - no action needed

    :cond_cleanup
    # Stop tracking
    const/4 v1, 0x0
    iput-boolean v1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->tracking:Z
    iput-boolean v1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->dragging:Z
    iput-boolean v1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapCandidate:Z
    iput-boolean v1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->doubleTapDelivered:Z

    :cond_return
    # Forward touch to buttons at end (for all events)
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->b:Landroid/view/View;
    if-eqz v0, :cond_no_buttons
    invoke-virtual {v0, p1}, Landroid/view/View;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    :cond_no_buttons
    
    # When RTS enabled, consume the event (return true)
    const/4 v0, 0x1
    return v0
.end method


# Warp cursor to absolute position using absolute coordinates (no reset needed)
# Parameters: p1 = targetX, p2 = targetY (screen coordinates)
# Maps touch on overlay to game coordinates using X11View's actual screen bounds
# Also saves the game coordinates to lastGameX/Y for delta tracking
.method public warpCursorTo(FF)V
    .locals 12
    
    # Get WinUIBridge from our field
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    # Check X11Controller is ready
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Get X11View from X11Controller
    iget-object v2, v1, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;
    if-eqz v2, :cond_no_scale
    
    # Get game screen size from X11View (actual game resolution, e.g. 1600x1200)
    invoke-virtual {v2}, Lcom/winemu/ui/X11View;->getScreenSize()Landroid/graphics/Point;
    move-result-object v3
    if-eqz v3, :cond_no_scale
    
    # Get game dimensions from Point
    iget v4, v3, Landroid/graphics/Point;->x:I  # gameWidth (e.g. 1600)
    iget v5, v3, Landroid/graphics/Point;->y:I  # gameHeight (e.g. 1200)
    int-to-float v4, v4
    int-to-float v5, v5
    
    # Get X11View's position on screen (where the game view starts)
    invoke-virtual {v2}, Landroid/view/View;->getX()F
    move-result v6  # viewX (left edge of game on screen)
    
    invoke-virtual {v2}, Landroid/view/View;->getY()F
    move-result v7  # viewY (top edge of game on screen)
    
    # Get X11View's size on screen (how big the game appears, may be letterboxed)
    invoke-virtual {v2}, Landroid/view/View;->getWidth()I
    move-result v8
    int-to-float v8, v8  # viewWidth on screen
    
    invoke-virtual {v2}, Landroid/view/View;->getHeight()I
    move-result v9
    int-to-float v9, v9  # viewHeight on screen
    
    # Avoid division by zero
    const/4 v10, 0x0
    cmpg-float v11, v8, v10
    if-lez v11, :cond_no_scale
    cmpg-float v11, v9, v10
    if-lez v11, :cond_no_scale
    
    # Convert touch coordinates to be relative to X11View position
    # relativeX = touchX - viewX
    # relativeY = touchY - viewY
    sub-float p1, p1, v6  # relativeX = touchX - viewX
    sub-float p2, p2, v7  # relativeY = touchY - viewY
    
    # Scale from X11View screen size to game resolution
    # scaledX = relativeX * (gameWidth / viewWidth)
    # scaledY = relativeY * (gameHeight / viewHeight)
    div-float v10, v4, v8  # scaleX = gameWidth / viewWidth
    div-float v11, v5, v9  # scaleY = gameHeight / viewHeight
    
    mul-float p1, p1, v10  # scaledX = relativeX * scaleX
    mul-float p2, p2, v11  # scaledY = relativeY * scaleY
    
    # Clamp to game bounds (0 to gameWidth/gameHeight)
    const/4 v6, 0x0
    
    # Clamp X: max(0, min(scaledX, gameWidth))
    invoke-static {p1, v6}, Ljava/lang/Math;->max(FF)F
    move-result p1
    invoke-static {p1, v4}, Ljava/lang/Math;->min(FF)F
    move-result p1
    
    # Clamp Y: max(0, min(scaledY, gameHeight))
    invoke-static {p2, v6}, Ljava/lang/Math;->max(FF)F
    move-result p2
    invoke-static {p2, v5}, Ljava/lang/Math;->min(FF)F
    move-result p2
    
    # Save game coordinates for delta tracking
    iput p1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastGameX:F
    iput p2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastGameY:F
    
    :cond_no_scale
    # Use absolute positioning (isRelative=false) - single call, no flicker
    move v1, p1  # absX = scaledX
    move v2, p2  # absY = scaledY
    const/4 v3, 0x0  # button = 0 (move only)
    const/4 v4, 0x0  # isDown = false
    const/4 v5, 0x0  # isRelative = false (absolute positioning!)
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    :cond_end
    return-void
.end method


# Convert touch coordinates to game coordinates (without moving cursor)
# Returns float array [gameX, gameY] or null if can't convert
.method public touchToGameCoords(FF)[F
    .locals 12
    
    # Get WinUIBridge from our field
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_fail
    
    # Check X11Controller is ready
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_fail
    
    # Get X11View from X11Controller
    iget-object v2, v1, Lcom/winemu/core/controller/X11Controller;->a:Lcom/winemu/ui/X11View;
    if-eqz v2, :cond_fail
    
    # Get game screen size from X11View
    invoke-virtual {v2}, Lcom/winemu/ui/X11View;->getScreenSize()Landroid/graphics/Point;
    move-result-object v3
    if-eqz v3, :cond_fail
    
    # Get game dimensions from Point
    iget v4, v3, Landroid/graphics/Point;->x:I  # gameWidth
    iget v5, v3, Landroid/graphics/Point;->y:I  # gameHeight
    int-to-float v4, v4
    int-to-float v5, v5
    
    # Get X11View's position on screen
    invoke-virtual {v2}, Landroid/view/View;->getX()F
    move-result v6  # viewX
    
    invoke-virtual {v2}, Landroid/view/View;->getY()F
    move-result v7  # viewY
    
    # Get X11View's size on screen
    invoke-virtual {v2}, Landroid/view/View;->getWidth()I
    move-result v8
    int-to-float v8, v8  # viewWidth
    
    invoke-virtual {v2}, Landroid/view/View;->getHeight()I
    move-result v9
    int-to-float v9, v9  # viewHeight
    
    # Avoid division by zero
    const/4 v10, 0x0
    cmpg-float v11, v8, v10
    if-lez v11, :cond_fail
    cmpg-float v11, v9, v10
    if-lez v11, :cond_fail
    
    # Convert touch to relative
    sub-float p1, p1, v6  # relativeX = touchX - viewX
    sub-float p2, p2, v7  # relativeY = touchY - viewY
    
    # Scale to game coordinates
    div-float v10, v4, v8  # scaleX = gameWidth / viewWidth
    div-float v11, v5, v9  # scaleY = gameHeight / viewHeight
    
    mul-float p1, p1, v10  # gameX = relativeX * scaleX
    mul-float p2, p2, v11  # gameY = relativeY * scaleY
    
    # Clamp to game bounds
    const/4 v6, 0x0
    
    invoke-static {p1, v6}, Ljava/lang/Math;->max(FF)F
    move-result p1
    invoke-static {p1, v4}, Ljava/lang/Math;->min(FF)F
    move-result p1
    
    invoke-static {p2, v6}, Ljava/lang/Math;->max(FF)F
    move-result p2
    invoke-static {p2, v5}, Ljava/lang/Math;->min(FF)F
    move-result p2
    
    # Create float array with results
    const/4 v0, 0x2
    new-array v0, v0, [F
    const/4 v1, 0x0
    aput p1, v0, v1
    const/4 v1, 0x1
    aput p2, v0, v1
    return-object v0
    
    :cond_fail
    const/4 v0, 0x0
    return-object v0
.end method


# Move cursor by delta (relative movement)
# Parameters: p1 = deltaX, p2 = deltaY
.method public moveCursorBy(FF)V
    .locals 6
    
    # Get WinUIBridge from our field
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    # Check X11Controller is ready
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Use raw delta coordinates - no scaling
    move v1, p1  # deltaX
    move v2, p2  # deltaY
    const/4 v3, 0x0  # button = 0 (move only)
    const/4 v4, 0x0  # isDown = false
    const/4 v5, 0x1  # isRelative = true
    
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    :cond_end
    return-void
.end method


# Do a simple click (press + release)
.method public doClick()V
    .locals 8
    
    # Get WinUIBridge from our field
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    # Check X11Controller is ready
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Absolute warp back to last touch to guarantee position before click
    iget v1, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchX:F
    iget v2, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->lastTouchY:F
    invoke-virtual {p0, v1, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->warpCursorTo(FF)V

    # Absolute nudge: warp to a nearby offset then back to force hover/move without drift
    const/high16 v3, 0x3f800000  # 1.0f
    add-float v4, v1, v3
    add-float v5, v2, v3
    invoke-virtual {p0, v4, v5}, Lcom/xj/winemu/view/RtsTouchOverlayView;->warpCursorTo(FF)V
    invoke-virtual {p0, v1, v2}, Lcom/xj/winemu/view/RtsTouchOverlayView;->warpCursorTo(FF)V
    
    # Press: c0(0, 0, button=1, isDown=true, isRelative=true)
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x1
    const/4 v4, 0x1
    const/4 v5, 0x1
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    # Release: c0(0, 0, button=1, isDown=false, isRelative=true)
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x1
    const/4 v4, 0x0
    const/4 v5, 0x1
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    :cond_end
    return-void
.end method


# Do a right click (press + release with button 3)
# Note: Unlike left click, we don't warp cursor here - assume it's already positioned
.method public doRightClick()V
    .locals 6
    
    # Get WinUIBridge from our field
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    # Check X11Controller is ready
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Press: c0(0, 0, button=3, isDown=true, isRelative=true)
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x3  # button 3 = right click
    const/4 v4, 0x1
    const/4 v5, 0x1
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    # Release: c0(0, 0, button=3, isDown=false, isRelative=true)
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x3  # button 3 = right click
    const/4 v4, 0x0
    const/4 v5, 0x1
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    :cond_end
    return-void
.end method


# Press left button (for drag start)
.method public pressLeftButton()V
    .locals 6
    
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Press: c0(0, 0, button=1, isDown=true, isRelative=true)
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x1  # button 1 = left click
    const/4 v4, 0x1  # isDown = true
    const/4 v5, 0x1
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    :cond_end
    return-void
.end method


# Release left button (for drag end)
.method public releaseLeftButton()V
    .locals 6
    
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Release: c0(0, 0, button=1, isDown=false, isRelative=true)
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x1  # button 1 = left click
    const/4 v4, 0x0  # isDown = false
    const/4 v5, 0x1
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    :cond_end
    return-void
.end method


# Press an arrow key
# p1 = direction: 1=left, 2=right, 3=up, 4=down
.method public pressArrowKey(I)V
    .locals 4
    
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Convert direction to Android keycode
    # 1=left -> KEYCODE_DPAD_LEFT (21)
    # 2=right -> KEYCODE_DPAD_RIGHT (22)
    # 3=up -> KEYCODE_DPAD_UP (19)
    # 4=down -> KEYCODE_DPAD_DOWN (20)
    const/4 v2, 0x1
    if-ne p1, v2, :cond_not_left
    const/16 p1, 0x15  # 21 = DPAD_LEFT
    goto :cond_send
    
    :cond_not_left
    const/4 v2, 0x2
    if-ne p1, v2, :cond_not_right
    const/16 p1, 0x16  # 22 = DPAD_RIGHT
    goto :cond_send
    
    :cond_not_right
    const/4 v2, 0x3
    if-ne p1, v2, :cond_not_up
    const/16 p1, 0x13  # 19 = DPAD_UP
    goto :cond_send
    
    :cond_not_up
    const/4 v2, 0x4
    if-ne p1, v2, :cond_end
    const/16 p1, 0x14  # 20 = DPAD_DOWN
    
    :cond_send
    # Send key press via X11Controller.p(modifiers, keyCode, isDown)
    const/4 v2, 0x0  # modifiers = 0
    const/4 v3, 0x1  # isDown = true
    invoke-virtual {v1, v2, p1, v3}, Lcom/winemu/core/controller/X11Controller;->p(IIZ)V
    
    :cond_end
    return-void
.end method


# Release an arrow key
# p1 = direction: 1=left, 2=right, 3=up, 4=down
.method public releaseArrowKey(I)V
    .locals 4
    
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Convert direction to Android keycode
    const/4 v2, 0x1
    if-ne p1, v2, :cond_not_left
    const/16 p1, 0x15  # 21 = DPAD_LEFT
    goto :cond_send
    
    :cond_not_left
    const/4 v2, 0x2
    if-ne p1, v2, :cond_not_right
    const/16 p1, 0x16  # 22 = DPAD_RIGHT
    goto :cond_send
    
    :cond_not_right
    const/4 v2, 0x3
    if-ne p1, v2, :cond_not_up
    const/16 p1, 0x13  # 19 = DPAD_UP
    goto :cond_send
    
    :cond_not_up
    const/4 v2, 0x4
    if-ne p1, v2, :cond_end
    const/16 p1, 0x14  # 20 = DPAD_DOWN
    
    :cond_send
    # Send key release via X11Controller.p(modifiers, keyCode, isDown)
    const/4 v2, 0x0  # modifiers = 0
    const/4 v3, 0x0  # isDown = false
    invoke-virtual {v1, v2, p1, v3}, Lcom/winemu/core/controller/X11Controller;->p(IIZ)V
    
    :cond_end
    return-void
.end method


# End two-finger pan - release all arrow keys that are pressed
.method public endTwoFingerPan()V
    .locals 2
    
    # Release all pressed arrow keys
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    if-eqz v0, :cond_check_right
    const/4 v0, 0x1
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    
    :cond_check_right
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    if-eqz v0, :cond_check_up
    const/4 v0, 0x2
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    
    :cond_check_up
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    if-eqz v0, :cond_check_down
    const/4 v0, 0x3
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    
    :cond_check_down
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    if-eqz v0, :cond_reset
    const/4 v0, 0x4
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseArrowKey(I)V
    
    :cond_reset
    # Reset all flags
    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->twoFingerPanning:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    iput-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    
    return-void
.end method


# Send mouse wheel scroll event
# Parameter: p1 = button code (4 = scroll up/zoom in, 5 = scroll down/zoom out)
# Mouse wheel is implemented as button press+release events in X11
.method public sendScrollWheel(I)V
    .locals 6
    
    # Get WinUIBridge from our field
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    # GameHub uses button 4 with Y coordinate for scroll direction
    # direction: -1 = zoom in (scroll up, negative Y), +1 = zoom out (scroll down, positive Y)
    # Calculate Y value: direction * -2.0f (much lower sensitivity)
    int-to-float v1, p1
    const/high16 v2, 0xc0000000    # -2.0f
    mul-float v2, v1, v2
    
    # Send scroll event: c0(x=0, y=calculated, button=4, isDown=false, isRelative=true)
    const/4 v1, 0x0      # x = 0
    # v2 already has Y value
    const/4 v3, 0x4      # button = 4 (scroll)
    const/4 v4, 0x0      # isDown = false
    const/4 v5, 0x1      # isRelative = true
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    
    :cond_end
    return-void
.end method


# Press middle mouse button (button=2)
.method public pressMiddleButton()V
    .locals 6
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x2
    const/4 v4, 0x1
    const/4 v5, 0x1
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    :cond_end
    return-void
.end method

# Release middle mouse button (button=2)
.method public releaseMiddleButton()V
    .locals 6
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x2
    const/4 v4, 0x0
    const/4 v5, 0x1
    invoke-virtual/range {v0 .. v5}, Lcom/winemu/openapi/WinUIBridge;->f0(FFIZZ)V
    :cond_end
    return-void
.end method


# Send plus or minus key for pinch zoom (action 1)
# p1 = direction: 1 = plus (zoom out/spread), -1 = minus (zoom in/pinch)
.method public sendPlusMinusKey(I)V
    .locals 4
    
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Determine keycode: plus = KEYCODE_NUMPAD_ADD (157), minus = KEYCODE_MINUS (69)
    const/4 v2, 0x1
    if-ne p1, v2, :cond_minus
    # Plus key (KEYCODE_NUMPAD_ADD = 157, always emits +)
    const/16 v2, 0x9d  # 157 = KEYCODE_NUMPAD_ADD
    goto :cond_send
    
    :cond_minus
    # Minus key (KEYCODE_MINUS = 69)
    const/16 v2, 0x45  # 69 = KEYCODE_MINUS
    
    :cond_send
    # Send key press
    const/4 v3, 0x0  # modifiers = 0
    const/4 p1, 0x1  # isDown = true
    invoke-virtual {v1, v3, v2, p1}, Lcom/winemu/core/controller/X11Controller;->p(IIZ)V
    
    # Send key release
    const/4 p1, 0x0  # isDown = false
    invoke-virtual {v1, v3, v2, p1}, Lcom/winemu/core/controller/X11Controller;->p(IIZ)V
    
    :cond_end
    return-void
.end method


# Send Page Up or Page Down key for pinch zoom (action 2)
# p1 = direction: 1 = page down (zoom out/spread), -1 = page up (zoom in/pinch)
.method public sendPageUpDownKey(I)V
    .locals 4
    
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Determine keycode: PageUp = 92, PageDown = 93
    const/4 v2, 0x1
    if-ne p1, v2, :cond_pageup
    # Page Down (KEYCODE_PAGE_DOWN = 93)
    const/16 v2, 0x5d  # 93 = KEYCODE_PAGE_DOWN
    goto :cond_send
    
    :cond_pageup
    # Page Up (KEYCODE_PAGE_UP = 92)
    const/16 v2, 0x5c  # 92 = KEYCODE_PAGE_UP
    
    :cond_send
    # Send key press
    const/4 v3, 0x0  # modifiers = 0
    const/4 p1, 0x1  # isDown = true
    invoke-virtual {v1, v3, v2, p1}, Lcom/winemu/core/controller/X11Controller;->p(IIZ)V
    
    # Send key release
    const/4 p1, 0x0  # isDown = false
    invoke-virtual {v1, v3, v2, p1}, Lcom/winemu/core/controller/X11Controller;->p(IIZ)V
    
    :cond_end
    return-void
.end method


# Press WASD key for two-finger pan (action 1)
# p1 = direction: 1=left(A), 2=right(D), 3=up(W), 4=down(S)
.method public pressWasdKey(I)V
    .locals 4
    
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Convert direction to WASD keycode
    # 1=left -> A (29), 2=right -> D (32), 3=up -> W (51), 4=down -> S (47)
    const/4 v2, 0x1
    if-ne p1, v2, :cond_not_left
    const/16 p1, 0x1d  # 29 = KEYCODE_A
    goto :cond_send
    
    :cond_not_left
    const/4 v2, 0x2
    if-ne p1, v2, :cond_not_right
    const/16 p1, 0x20  # 32 = KEYCODE_D
    goto :cond_send
    
    :cond_not_right
    const/4 v2, 0x3
    if-ne p1, v2, :cond_not_up
    const/16 p1, 0x33  # 51 = KEYCODE_W
    goto :cond_send
    
    :cond_not_up
    const/4 v2, 0x4
    if-ne p1, v2, :cond_end
    const/16 p1, 0x2f  # 47 = KEYCODE_S
    
    :cond_send
    # Send key press via X11Controller.p(modifiers, keyCode, isDown)
    const/4 v2, 0x0  # modifiers = 0
    const/4 v3, 0x1  # isDown = true
    invoke-virtual {v1, v2, p1, v3}, Lcom/winemu/core/controller/X11Controller;->p(IIZ)V
    
    :cond_end
    return-void
.end method


# Release WASD key for two-finger pan
# p1 = direction: 1=left(A), 2=right(D), 3=up(W), 4=down(S)
.method public releaseWasdKey(I)V
    .locals 4
    
    iget-object v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->a:Lcom/winemu/openapi/WinUIBridge;
    if-eqz v0, :cond_end
    
    iget-object v1, v0, Lcom/winemu/openapi/WinUIBridge;->k:Lcom/winemu/core/controller/X11Controller;
    if-eqz v1, :cond_end
    
    # Convert direction to WASD keycode
    const/4 v2, 0x1
    if-ne p1, v2, :cond_not_left
    const/16 p1, 0x1d  # 29 = KEYCODE_A
    goto :cond_send
    
    :cond_not_left
    const/4 v2, 0x2
    if-ne p1, v2, :cond_not_right
    const/16 p1, 0x20  # 32 = KEYCODE_D
    goto :cond_send
    
    :cond_not_right
    const/4 v2, 0x3
    if-ne p1, v2, :cond_not_up
    const/16 p1, 0x33  # 51 = KEYCODE_W
    goto :cond_send
    
    :cond_not_up
    const/4 v2, 0x4
    if-ne p1, v2, :cond_end
    const/16 p1, 0x2f  # 47 = KEYCODE_S
    
    :cond_send
    # Send key release via X11Controller.p(modifiers, keyCode, isDown)
    const/4 v2, 0x0  # modifiers = 0
    const/4 v3, 0x0  # isDown = false
    invoke-virtual {v1, v2, p1, v3}, Lcom/winemu/core/controller/X11Controller;->p(IIZ)V
    
    :cond_end
    return-void
.end method


# End WASD pan - release all WASD keys that might be pressed
.method public endWasdPan()V
    .locals 2
    
    # Release all WASD keys
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panLeft:Z
    if-eqz v0, :cond_check_right
    const/4 v0, 0x1
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    
    :cond_check_right
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panRight:Z
    if-eqz v0, :cond_check_up
    const/4 v0, 0x2
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    
    :cond_check_up
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panUp:Z
    if-eqz v0, :cond_check_down
    const/4 v0, 0x3
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    
    :cond_check_down
    iget-boolean v0, p0, Lcom/xj/winemu/view/RtsTouchOverlayView;->panDown:Z
    if-eqz v0, :cond_end
    const/4 v0, 0x4
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/RtsTouchOverlayView;->releaseWasdKey(I)V
    
    :cond_end
    return-void
.end method
