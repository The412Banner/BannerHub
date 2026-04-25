package app.revanced.extension.gamehub;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.TextView;

public class BhDashboardDownloadBtn
        implements View.OnClickListener, BhDownloadService.CountObserver {

    private final Context ctx;
    private final View    container;
    private final Handler handler = new Handler(Looper.getMainLooper());

    public BhDashboardDownloadBtn(Context ctx, View container) {
        this.ctx       = ctx;
        this.container = container;
        BhDownloadService.setCountObserver(this);
        onCountChanged(BhDownloadService.getActiveCount());
    }

    @Override
    public void onClick(View v) {
        Intent i = new Intent(ctx, BhDownloadsActivity.class);
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        ctx.startActivity(i);
    }

    @Override
    public void onCountChanged(int count) {
        handler.post(() -> {
            View raw = container.findViewWithTag("bh_dl_badge");
            if (!(raw instanceof TextView)) return;
            TextView badge = (TextView) raw;
            if (count > 0) {
                badge.setText(String.valueOf(count));
                badge.setVisibility(View.VISIBLE);
            } else {
                badge.setVisibility(View.GONE);
            }
        });
    }
}
