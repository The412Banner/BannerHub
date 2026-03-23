.class public Lcom/xj/landscape/launcher/ui/menu/EpicGame;
.super Ljava/lang/Object;

# BannerHub: Data holder for a single Epic Games Store game.
# Populated from EGS library API + catalog API.
# catalogId  = primary lookup key from library API
# appName    = EGS app identifier (UUID-like string)
# namespace  = EGS namespace — used in all API calls + -epicsandboxid launch arg
# artCover   = DieselGameBoxTall image URL (preferred cover)
# artSquare  = DieselGameBox fallback
# canRunOffline / requiresOT / isDLC from catalog custom attributes.

.field public catalogId:Ljava/lang/String;
.field public appName:Ljava/lang/String;
.field public title:Ljava/lang/String;
.field public namespace:Ljava/lang/String;
.field public artCover:Ljava/lang/String;
.field public artSquare:Ljava/lang/String;
.field public developer:Ljava/lang/String;
.field public description:Ljava/lang/String;
.field public downloadSize:J
.field public canRunOffline:Z
.field public requiresOT:Z
.field public isDLC:Z
.field public baseGameAppName:Ljava/lang/String;
.field public thirdPartyManagedApp:Ljava/lang/String;


.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method
