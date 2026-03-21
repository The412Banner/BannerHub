.class public final Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$3;
.super Ljava/lang/Object;

# BannerHub: UI-thread Runnable — finish GogLoginActivity after successful login.

.implements Ljava/lang/Runnable;


.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$3;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    return-void
.end method


.method public run()V
    .locals 0

    iget-object p0, p0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity$3;->a:Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    return-void
.end method
