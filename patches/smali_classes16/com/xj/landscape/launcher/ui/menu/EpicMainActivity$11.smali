.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$11;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

# BannerHub: UI success Runnable for Epic install pipeline.
# Posted by $7 (install thread) on "Install complete!" to update card widgets:
#   progressBar GONE, statusTV GONE, checkmarkTV VISIBLE,
#   addBtn GONE, launchBtn VISIBLE+enabled.
# Also saves epic_installed_{appName}=installDir to bh_epic_prefs.

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
.field final synthetic val$installDir:Ljava/lang/String;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;Ljava/lang/String;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$11;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$11;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$11;->val$installDir:Ljava/lang/String;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public run()V
    .locals 8

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$11;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$11;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$11;->val$installDir:Ljava/lang/String;

    # progressBar → GONE
    iget-object v3, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$progressBar:Landroid/widget/ProgressBar;
    const/16 v4, 0x8
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    # statusTV → GONE
    iget-object v3, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$statusTV:Landroid/widget/TextView;
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    # addBtn → GONE
    iget-object v3, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$addBtn:Landroid/widget/Button;
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    # checkTV → VISIBLE
    iget-object v3, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$checkTV:Landroid/widget/TextView;
    const/4 v4, 0x0
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    # launchBtn → VISIBLE + enabled
    iget-object v3, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->val$launchBtn:Landroid/widget/Button;
    const/4 v4, 0x0
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V
    const/4 v4, 0x1
    invoke-virtual {v3, v4}, Landroid/view/View;->setEnabled(Z)V

    # Save bh_epic_prefs epic_installed_{appName}=installDir
    iget-object v3, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->appName:Ljava/lang/String;

    const-string v4, "bh_epic_prefs"
    const/4 v5, 0x0
    invoke-virtual {v0, v4, v5}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v4   # SharedPreferences

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v5   # Editor

    # Build key "epic_installed_{appName}"
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "epic_installed_"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6   # key

    invoke-interface {v5, v6, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method
