.class final Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;
.super Ljava/lang/Object;
.implements Landroid/content/DialogInterface$OnClickListener;

.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/xj/winemu/settings/CpuMultiSelectHelper;->show(Landroid/view/View;Ljava/lang/String;ILkotlin/jvm/functions/Function1;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

# Negative button ("No Limit") — saves 0, fires callback with
# DialogSettingListItemEntity(id=0, isSelected=true).
.field final synthetic a:Lcom/blankj/utilcode/util/SPUtils;
.field final synthetic b:Ljava/lang/String;
.field final synthetic c:Lkotlin/jvm/functions/Function1;

.method constructor <init>(Lcom/blankj/utilcode/util/SPUtils;Ljava/lang/String;Lkotlin/jvm/functions/Function1;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;->a:Lcom/blankj/utilcode/util/SPUtils;
    iput-object p2, p0, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;->b:Ljava/lang/String;
    iput-object p3, p0, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;->c:Lkotlin/jvm/functions/Function1;
    return-void
.end method

# onClick(DialogInterface dialog, int which)
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 3

    # Save 0 (No Limit — no CPU affinity)
    iget-object v0, p0, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;->a:Lcom/blankj/utilcode/util/SPUtils;
    iget-object v1, p0, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;->b:Ljava/lang/String;
    const/4 p2, 0x0
    invoke-virtual {v0, v1, p2}, Lcom/blankj/utilcode/util/SPUtils;->m(Ljava/lang/String;I)V

    # Fire UI refresh: callback.invoke(new DialogSettingListItemEntity{id=0, isSelected=true})
    iget-object v0, p0, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;->c:Lkotlin/jvm/functions/Function1;
    if-eqz v0, :cond_nocb
    new-instance v1, Lcom/xj/winemu/bean/DialogSettingListItemEntity;
    invoke-direct {v1}, Lcom/xj/winemu/bean/DialogSettingListItemEntity;-><init>()V
    # id=0 already by default
    const/4 v2, 0x1
    iput-boolean v2, v1, Lcom/xj/winemu/bean/DialogSettingListItemEntity;->isSelected:Z
    invoke-interface {v0, v1}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;
    :cond_nocb

    return-void
.end method
