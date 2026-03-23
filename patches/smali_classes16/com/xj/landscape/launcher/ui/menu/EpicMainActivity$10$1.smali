.class public final Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10$1;
.super Ljava/lang/Object;

# BannerHub: UI-thread Runnable created by EpicMainActivity$10.
# Called via View.post() after a bitmap is decoded on the background thread.
# Sets the bitmap on the target ImageView.

.implements Ljava/lang/Runnable;

.field public final a:Landroid/widget/ImageView;
.field public final b:Landroid/graphics/Bitmap;


.method public constructor <init>(Landroid/widget/ImageView;Landroid/graphics/Bitmap;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10$1;->a:Landroid/widget/ImageView;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10$1;->b:Landroid/graphics/Bitmap;

    return-void
.end method


.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10$1;->a:Landroid/widget/ImageView;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/EpicMainActivity$10$1;->b:Landroid/graphics/Bitmap;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    return-void
.end method
