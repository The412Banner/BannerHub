.class public Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;
.super Ljava/lang/Object;
.source "EpicDownloader.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/xj/landscape/launcher/ui/menu/EpicDownloader;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "CdnUrl"
.end annotation


# instance fields
.field public final authParams:Ljava/lang/String;

.field public final baseUrl:Ljava/lang/String;

.field public final cloudDir:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 48
    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->baseUrl:Ljava/lang/String;

    .line 49
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->cloudDir:Ljava/lang/String;

    .line 50
    iput-object p3, p0, Lcom/xj/landscape/launcher/ui/menu/EpicDownloader$CdnUrl;->authParams:Ljava/lang/String;

    .line 51
    return-void
.end method
