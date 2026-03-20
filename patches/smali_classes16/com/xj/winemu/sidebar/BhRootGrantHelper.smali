.class public Lcom/xj/winemu/sidebar/BhRootGrantHelper;
.super Ljava/lang/Object;
.source "SourceFile"


# public static void requestRoot(Context ctx)
# Called from Settings -> Advanced -> "Grant Root Access" button (contentType=0x64).
# Shows a warning dialog; on confirmation runs su -c id to trigger the root manager
# prompt, then stores root_granted in bh_prefs so BhPerfSetupDelegate can enable
# performance toggles without a live root check on every sidebar open.
.method public static requestRoot(Landroid/content/Context;)V
    .locals 5

    if-nez p0, :cond_not_null

    return-void

    :cond_not_null

    # SharedPreferences prefs = ctx.getSharedPreferences("bh_prefs", 0);
    const-string v0, "bh_prefs"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    # boolean alreadyGranted = prefs.getBoolean("root_granted", false);
    const-string v1, "root_granted"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    # AlertDialog.Builder builder = new AlertDialog.Builder(ctx);
    new-instance v2, Landroid/app/AlertDialog$Builder;

    invoke-direct {v2, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    # builder.setCancelable(true);
    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;

    if-eqz v1, :cond_not_granted

    # ---- Already granted: show revoke dialog ----
    const-string v3, "Root Access \u2014 Performance Controls"

    invoke-virtual {v2, v3}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    const-string v3, "Root access is currently GRANTED for BannerHub performance controls.\n\nThis allows the in-game Performance sidebar to:\n  \u2022 Enable Sustained Performance Mode\n  \u2022 Lock Adreno GPU clocks to maximum\n\nTap 'Revoke Access' to withdraw this permission and grey out the performance toggles, or 'Keep' to leave it active."

    invoke-virtual {v2, v3}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    # Positive button: "Revoke Access" — stores root_granted=false
    new-instance v3, Lcom/xj/winemu/sidebar/BhRootGrantHelper$1;

    invoke-direct {v3, p0, v0}, Lcom/xj/winemu/sidebar/BhRootGrantHelper$1;-><init>(Landroid/content/Context;Landroid/content/SharedPreferences;)V

    const-string v4, "Revoke Access"

    invoke-virtual {v2, v4, v3}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    # Negative button: "Keep" — null listener means dialog just dismisses
    const/4 v3, 0x0

    const-string v4, "Keep"

    invoke-virtual {v2, v4, v3}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    goto :do_show

    # ---- Not granted: show grant dialog ----
    :cond_not_granted

    const-string v3, "\u26a0 Grant Root Access \u2014 Read Carefully"

    invoke-virtual {v2, v3}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    const-string v3, "BannerHub can use root (superuser) access to enable advanced performance controls in the in-game Performance sidebar.\n\nOnce granted, you will be able to:\n  \u2022 Sustained Performance Mode \u2014 locks CPU/GPU clocks at a stable level to reduce thermal throttling during long gaming sessions.\n  \u2022 Max Adreno GPU Clocks \u2014 forces the Adreno GPU minimum frequency to its maximum value for peak frame rates.\n\n\u26a0 IMPORTANT WARNINGS:\n\n1. Your root manager (Magisk, KernelSU, etc.) will show a separate permission prompt \u2014 you must tap GRANT there as well.\n\n2. Granting root exposes your device at the superuser level. Only proceed if you trust this application.\n\n3. Max Adreno Clocks requires a Qualcomm Adreno GPU and the kgsl-3d0 sysfs node. On other devices it will silently have no effect.\n\n4. These toggles modify live kernel parameters. Effects are reset on reboot.\n\n5. Sustained Performance Mode increases battery consumption and device temperature.\n\nTap 'Grant Access' to proceed and trigger your root manager's prompt."

    invoke-virtual {v2, v3}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    # Positive button: "Grant Access" — starts thread to run su
    new-instance v3, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2;

    invoke-direct {v3, p0, v0}, Lcom/xj/winemu/sidebar/BhRootGrantHelper$2;-><init>(Landroid/content/Context;Landroid/content/SharedPreferences;)V

    const-string v4, "Grant Access"

    invoke-virtual {v2, v4, v3}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    # Negative button: "Cancel" — null listener means dialog just dismisses
    const/4 v3, 0x0

    const-string v4, "Cancel"

    invoke-virtual {v2, v4, v3}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    :do_show

    invoke-virtual {v2}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method
