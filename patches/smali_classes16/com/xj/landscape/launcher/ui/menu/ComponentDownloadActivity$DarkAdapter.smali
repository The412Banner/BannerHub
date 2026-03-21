.class public Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$DarkAdapter;
.super Landroid/widget/ArrayAdapter;

# Constructor takes (Context, Object[]) — layout resource is unused since getView is overridden
.method public constructor <init>(Landroid/content/Context;[Ljava/lang/Object;)V
    .locals 1
    # .locals 1 → p0=v1, p1=v2, p2=v3; v0 is the dummy layout int
    const/4 v0, 0x0
    invoke-direct {p0, p1, v0, p2}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;I[Ljava/lang/Object;)V
    return-void
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 7
    # .locals 7 → v0-v6 locals; p0=v7(this), p1=v8(pos), p2=v9(convertView), p3=v10(parent)

    # get item string
    invoke-virtual {p0, p1}, Landroid/widget/ArrayAdapter;->getItem(I)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;

    # get context
    invoke-virtual {p0}, Landroid/widget/ArrayAdapter;->getContext()Landroid/content/Context;
    move-result-object v1

    # create TextView
    new-instance v2, Landroid/widget/TextView;
    invoke-direct {v2, v1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v2, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # text size 16sp
    const/high16 v3, 0x41800000
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    # color: orange for ← Back items, white otherwise
    const-string v3, "\u2190"
    invoke-virtual {v0, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v3
    if-eqz v3, :white
    const v3, 0xFFFF9800
    goto :setcolor
    :white
    const v3, 0xFFF0F0F0
    :setcolor
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    # padding: left=48px, top=24px, right=48px, bottom=24px
    const/16 v3, 0x30
    const/16 v1, 0x18
    invoke-virtual {v2, v3, v1, v3, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    # StateListDrawable: pressed=darker, selected(D-pad)=orange tint, default=dark
    new-instance v3, Landroid/graphics/drawable/StateListDrawable;
    invoke-direct {v3}, Landroid/graphics/drawable/StateListDrawable;-><init>()V

    # pressed → very dark
    const/4 v6, 0x1
    new-array v4, v6, [I
    const v5, 0x010100a7
    const/4 v6, 0x0
    aput v5, v4, v6
    new-instance v5, Landroid/graphics/drawable/ColorDrawable;
    const v6, 0xFF090909
    invoke-direct {v5, v6}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v3, v4, v5}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    # focused (D-pad/controller) → vivid amber
    const/4 v6, 0x1
    new-array v4, v6, [I
    const v5, 0x0101009c
    const/4 v6, 0x0
    aput v5, v4, v6
    new-instance v5, Landroid/graphics/drawable/ColorDrawable;
    const v6, 0xFF3D2800
    invoke-direct {v5, v6}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v3, v4, v5}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    # selected (D-pad/controller) → vivid amber
    const/4 v6, 0x1
    new-array v4, v6, [I
    const v5, 0x010100a1
    const/4 v6, 0x0
    aput v5, v4, v6
    new-instance v5, Landroid/graphics/drawable/ColorDrawable;
    const v6, 0xFF3D2800
    invoke-direct {v5, v6}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v3, v4, v5}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    # default → near-black
    const/4 v6, 0x0
    new-array v4, v6, [I
    new-instance v5, Landroid/graphics/drawable/ColorDrawable;
    const v6, 0xFF1A1A1A
    invoke-direct {v5, v6}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V
    invoke-virtual {v3, v4, v5}, Landroid/graphics/drawable/StateListDrawable;->addState([ILandroid/graphics/drawable/Drawable;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    return-object v2
.end method
