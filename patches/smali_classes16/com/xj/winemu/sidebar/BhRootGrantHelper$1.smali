.class public Lcom/xj/winemu/sidebar/BhRootGrantHelper$1;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;
.source "SourceFile"

# "Revoke Access" button listener — stores root_granted=false, shows toast.

.field final a:Landroid/content/Context;
.field final b:Landroid/content/SharedPreferences;


.method public constructor <init>(Landroid/content/Context;Landroid/content/SharedPreferences;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$1;->a:Landroid/content/Context;

    iput-object p2, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$1;->b:Landroid/content/SharedPreferences;

    return-void
.end method


.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 3

    # prefs.edit().putBoolean("root_granted", false).apply();
    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$1;->b:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "root_granted"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Toast.makeText(ctx, "...", LENGTH_LONG).show();
    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhRootGrantHelper$1;->a:Landroid/content/Context;

    const-string v1, "Root access revoked. Performance controls are now disabled."

    const/4 v2, 0x1

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method
