.class public Lcom/xj/pcvirtualbtn/inputcontrols/RangeScrollerRtsTask;
.super Ljava/util/TimerTask;
.source "RangeScrollerRtsTask.kt"


# instance fields
.field public final a:Lcom/xj/pcvirtualbtn/inputcontrols/RangeScroller;


# direct methods
.method public constructor <init>(Lcom/xj/pcvirtualbtn/inputcontrols/RangeScroller;)V
    .locals 0

    invoke-direct {p0}, Ljava/util/TimerTask;-><init>()V

    iput-object p1, p0, Lcom/xj/pcvirtualbtn/inputcontrols/RangeScrollerRtsTask;->a:Lcom/xj/pcvirtualbtn/inputcontrols/RangeScroller;

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    # Set rtslongPress flag to true (held for 200ms)
    iget-object v0, p0, Lcom/xj/pcvirtualbtn/inputcontrols/RangeScrollerRtsTask;->a:Lcom/xj/pcvirtualbtn/inputcontrols/RangeScroller;

    const/4 v1, 0x1

    iput-boolean v1, v0, Lcom/xj/pcvirtualbtn/inputcontrols/RangeScroller;->rtslongPress:Z

    return-void
.end method
