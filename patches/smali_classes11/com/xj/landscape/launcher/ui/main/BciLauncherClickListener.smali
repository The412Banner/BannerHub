.class public final Lcom/xj/landscape/launcher/ui/main/BciLauncherClickListener;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

.field private final btn:Lapp/revanced/extension/gamehub/BhDashboardDownloadBtn;

.method public constructor <init>(Landroid/content/Context;Landroid/view/View;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    new-instance v0, Lapp/revanced/extension/gamehub/BhDashboardDownloadBtn;

    invoke-direct {v0, p1, p2}, Lapp/revanced/extension/gamehub/BhDashboardDownloadBtn;-><init>(Landroid/content/Context;Landroid/view/View;)V

    iput-object v0, p0, Lcom/xj/landscape/launcher/ui/main/BciLauncherClickListener;->btn:Lapp/revanced/extension/gamehub/BhDashboardDownloadBtn;

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 1

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/main/BciLauncherClickListener;->btn:Lapp/revanced/extension/gamehub/BhDashboardDownloadBtn;

    invoke-virtual {v0, p1}, Lapp/revanced/extension/gamehub/BhDashboardDownloadBtn;->onClick(Landroid/view/View;)V

    return-void
.end method
