.class public Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

# BannerHub: Card body OnClickListener for Epic game cards.
# Tapping a collapsed card expands it (collapses any previously expanded card first).
# Tapping an already-expanded card opens the detail dialog:
#   title / "Platform: Epic Games" [+ "✓ Installed" if installed]
#   Close button (always) + Uninstall button (if installed → $16).

.field final synthetic this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
.field final synthetic val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
.field final synthetic val$expandSection:Landroid/widget/LinearLayout;
.field final synthetic val$arrowTV:Landroid/widget/TextView;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;Landroid/widget/LinearLayout;Landroid/widget/TextView;)V
    .locals 0
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;->val$expandSection:Landroid/widget/LinearLayout;
    iput-object p4, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;->val$arrowTV:Landroid/widget/TextView;
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 10

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;->this$0:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;->val$card:Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;->val$expandSection:Landroid/widget/LinearLayout;
    iget-object v3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$14;->val$arrowTV:Landroid/widget/TextView;

    # Check whether this card is expanded (VISIBLE=0) or collapsed (GONE=8)
    invoke-virtual {v2}, Landroid/view/View;->getVisibility()I
    move-result v4
    const/16 v5, 0x8   # GONE
    if-ne v4, v5, :already_expanded

    # ── Collapsed → expand ────────────────────────────────────────────────────
    # Collapse the previously expanded card (if any)
    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->expandedSection:Landroid/widget/LinearLayout;
    if-eqz v4, :no_prev_section
    const/16 v5, 0x8
    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V
    :no_prev_section
    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->expandedArrow:Landroid/widget/TextView;
    if-eqz v4, :no_prev_arrow
    const-string v5, "\u25bc"
    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :no_prev_arrow

    # Expand this card
    const/4 v4, 0x0
    invoke-virtual {v2, v4}, Landroid/view/View;->setVisibility(I)V
    const-string v4, "\u25b2"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    iput-object v2, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->expandedSection:Landroid/widget/LinearLayout;
    iput-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;->expandedArrow:Landroid/widget/TextView;
    goto :done

    # ── Already expanded → show detail dialog ─────────────────────────────────
    :already_expanded
    # Get displayTitle and appName from card
    iget-object v4, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->displayTitle:Ljava/lang/String;
    iget-object v5, v1, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;->appName:Ljava/lang/String;

    # Check installed: read bh_epic_prefs epic_installed_{appName}
    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    const-string v7, "epic_installed_"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v6   # key

    const-string v7, "bh_epic_prefs"
    const/4 v8, 0x0
    invoke-virtual {v0, v7, v8}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v7
    const-string v8, ""
    invoke-interface {v7, v6, v8}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v6   # installDir or ""

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z
    move-result v7   # v7 = 1 if NOT installed, 0 if installed

    # Build dialog message
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V
    const-string v9, "Platform: Epic Games"
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    if-nez v7, :msg_done
    const-string v9, "\n\n\u2713 Installed"
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :msg_done
    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8   # message string

    # Build AlertDialog
    new-instance v9, Landroid/app/AlertDialog$Builder;
    invoke-direct {v9, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    invoke-virtual {v9, v4}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    invoke-virtual {v9, v8}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    # Positive button: "Close" (null listener)
    const-string v8, "Close"
    const/4 v6, 0x0
    invoke-virtual {v9, v8, v6}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    # Negative button: "Uninstall" — only if installed (v7==0)
    if-nez v7, :no_uninstall
    new-instance v6, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;
    invoke-direct {v6, v0, v5, v1}, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$16;-><init>(Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity;Ljava/lang/String;Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$2;)V
    const-string v8, "Uninstall"
    invoke-virtual {v9, v8, v6}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    :no_uninstall

    invoke-virtual {v9}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    :done
    return-void
.end method
