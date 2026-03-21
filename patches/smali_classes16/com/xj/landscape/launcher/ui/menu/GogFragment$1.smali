.class public final Lcom/xj/landscape/launcher/ui/menu/GogFragment$1;
.super Ljava/lang/Object;

# BannerHub: OnClickListener for the "Login with GOG" button in GogFragment
.implements Landroid/view/View$OnClickListener;


.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogFragment;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogFragment;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogFragment;

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 3

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogFragment;

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1  # Activity context

    if-eqz v1, :skip

    new-instance v2, Landroid/content/Intent;

    const-class v0, Lcom/xj/landscape/launcher/ui/menu/GogLoginActivity;

    invoke-direct {v2, v1, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    :skip

    return-void
.end method
