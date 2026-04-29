.class public final synthetic Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;
.super Ljava/lang/Object;

# Opened from the ⚙ LSFG button injected at the top of the Performance panel.
# Creates and shows BhLsfgInGameDialog with the game's context and ID.
.implements Landroid/view/View$OnClickListener;

.field public final context:Landroid/content/Context;
.field public final gameId:Ljava/lang/String;

.method public synthetic constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;->context:Landroid/content/Context;
    iput-object p2, p0, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;->gameId:Ljava/lang/String;

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2

    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;->context:Landroid/content/Context;
    if-eqz v0, :done

    iget-object v1, p0, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;->gameId:Ljava/lang/String;
    if-eqz v1, :done

    new-instance v0, Lapp/revanced/extension/gamehub/BhLsfgInGameDialog;
    iget-object v1, p0, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;->context:Landroid/content/Context;
    iget-object v2, p0, Lcom/xj/winemu/sidebar/BhLsfgGearClickListener;->gameId:Ljava/lang/String;
    invoke-direct {v0, v1, v2}, Lapp/revanced/extension/gamehub/BhLsfgInGameDialog;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    invoke-virtual {v0}, Lapp/revanced/extension/gamehub/BhLsfgInGameDialog;->show()V

    :done
    return-void
.end method
