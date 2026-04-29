.class public final synthetic Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;
.super Ljava/lang/Object;

# Opened from the ⚙ LSFG button injected at the top of the Performance panel.
# Creates and shows BhLsfgInGameDialog. GameId is resolved from the context at
# click time via BhLsfgManager.getGameIdFromContext() so we don't need to
# walk the ContextWrapper chain in smali.
.implements Landroid/view/View$OnClickListener;

.field public final context:Landroid/content/Context;

.method public synthetic constructor <init>(Landroid/content/Context;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;->context:Landroid/content/Context;

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 3

    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;->context:Landroid/content/Context;
    if-eqz v0, :done

    invoke-static {v0}, Lapp/revanced/extension/gamehub/BhLsfgManager;->getGameIdFromContext(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :done

    new-instance v2, Lapp/revanced/extension/gamehub/BhLsfgInGameDialog;
    invoke-direct {v2, v0, v1}, Lapp/revanced/extension/gamehub/BhLsfgInGameDialog;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    invoke-virtual {v2}, Lapp/revanced/extension/gamehub/BhLsfgInGameDialog;->show()V

    :done
    return-void
.end method
