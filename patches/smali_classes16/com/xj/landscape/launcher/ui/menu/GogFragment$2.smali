.class public final Lcom/xj/landscape/launcher/ui/menu/GogFragment$2;
.super Ljava/lang/Object;

# BannerHub: OnClickListener for the "Sign Out" button in GogFragment
.implements Landroid/view/View$OnClickListener;


.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogFragment;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogFragment;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogFragment;

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 4

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogFragment$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogFragment;

    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->getContext()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :skip

    # Clear SharedPreferences
    const-string v2, "bh_gog_prefs"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Refresh the fragment UI
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;->refreshView()V

    :skip

    return-void
.end method
