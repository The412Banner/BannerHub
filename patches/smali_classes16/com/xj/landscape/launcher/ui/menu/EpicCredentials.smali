.class public Lcom/xj/landscape/launcher/ui/menu/EpicCredentials;
.super Ljava/lang/Object;

# BannerHub: Epic OAuth credential holder.
# Stored as plain JSON at {filesDir}/epic/credentials.json.
# expiresAt = epoch millis (long) parsed from "expires_at" field.

.field public accessToken:Ljava/lang/String;
.field public refreshToken:Ljava/lang/String;
.field public accountId:Ljava/lang/String;
.field public displayName:Ljava/lang/String;
.field public expiresAt:J


.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method
