.class public final Lcom/xj/landscape/launcher/ui/main/BhGogTabCallback;
.super Ljava/lang/Object;

# BannerHub: Function0 callback for the GOG tab — returns a new GogFragment
.implements Lkotlin/jvm/functions/Function0;


.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


.method public final invoke()Ljava/lang/Object;
    .locals 1

    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/GogFragment;

    invoke-direct {v0}, Lcom/xj/landscape/launcher/ui/menu/GogFragment;-><init>()V

    return-object v0
.end method
