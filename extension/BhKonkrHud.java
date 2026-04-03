package com.xj.winemu.sidebar;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.BatteryManager;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Konkr-style HUD overlay.
 *
 * Vertical (default): 2-column table — bold left label, right-aligned value.
 *   FPS (large) / CPU%+temp / CPU0-7 MHz / GPU%+temp / GPU name+MHz+res /
 *   MODE / FAN / SKN / PWR / RAM(brown bar) / SWAP(gray bar) / BAT(blue fill) / TIME
 *
 * Horizontal (tap to toggle): multi-column compact strip —
 *   [FPS block] | [CPU 8-core 2x4] | [GPU block] | [MODE/FAN/SKN/PWR] | [RAM/SWAP/BAT/TIME]
 *
 * Drag to reposition. Orientation + position saved in bh_prefs.
 */
public class BhKonkrHud extends LinearLayout implements Runnable {

    private static final int COL_WHITE  = 0xFFFFFFFF;
    private static final int COL_ORANGE = 0xFFFF9800;
    private static final int COL_GRAY   = 0xFFAAAAAA;
    private static final int COL_RED    = 0xFFFF4444;
    private static final int COL_DIM    = 0xFF666666;
    private static final int BG_RAM     = 0xFF5D4037; // dark brown / copper
    private static final int BG_SWAP    = 0xFF455A64; // dark blue-gray
    private static final int BG_BAT     = 0xFF1565C0; // blue

    private final Activity activity;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private volatile boolean running = false;
    private boolean isVertical = true; // konkr default = vertical

    // CPU delta tracking
    private long prevTotal = 0, prevIdle = 0;
    private long prevProcCpuTime = -1, prevProcWallTime = -1;

    // FPS min tracking (reset every 60 samples)
    private float fpsMin = 9999f;
    private int fpsMinSamples = 0;

    // TextViews (nulled on each rebuild)
    private TextView tvFpsVal, tvFpsMin, tvFpsCpuTmp;
    private TextView tvCpuPct, tvCpuTemp;
    private TextView[] tvCores = new TextView[8];
    private TextView tvGpuPct, tvGpuTemp, tvGpuName, tvGpuFreq, tvGpuRes;
    private TextView tvModeVal, tvSknVal, tvPwrVal;
    private TextView tvRamVal, tvSwapVal, tvBatPct, tvTimeVal;

    // (no weighted BAT fill — BAT row uses solid blue background like RAM/SWAP)

    // Drag state
    private float dragLastX, dragLastY, dragStartX, dragStartY;
    private boolean dragMoved;

    public BhKonkrHud(Context ctx) {
        super(ctx);
        this.activity = ctx instanceof Activity ? (Activity) ctx : null;
        setBackgroundColor(0xCC000000);
        setPadding(dp(6), dp(4), dp(6), dp(4));
        setClipChildren(false);
        setClipToPadding(false);
        buildLayout();
        setOnTouchListener(makeDragListener());
    }

    // ── Layout ────────────────────────────────────────────────────────────────

    private void buildLayout() {
        removeAllViews();
        nullRefs();
        if (isVertical) buildVertical();
        else buildHorizontal();
        try {
            int op = getContext().getSharedPreferences("bh_prefs", 0).getInt("hud_opacity", 80);
            applyBackgroundOpacity(op);
        } catch (Exception ignored) {}
    }

    private void nullRefs() {
        tvFpsVal = tvFpsMin = tvFpsCpuTmp = null;
        tvCpuPct = tvCpuTemp = null;
        tvCores = new TextView[8];
        tvGpuPct = tvGpuTemp = tvGpuName = tvGpuFreq = tvGpuRes = null;
        tvModeVal = tvSknVal = tvPwrVal = null;
        tvRamVal = tvSwapVal = tvBatPct = tvTimeVal = null;
    }

    // ── VERTICAL layout ───────────────────────────────────────────────────────

    private void buildVertical() {
        setOrientation(VERTICAL);

        // ── FPS section ──────────────────────────────────────────────────────
        tvFpsVal = makeBigVal("--");
        addView(makeTwoColRow("FPS", COL_WHITE, 0, false, tvFpsVal), rowLp());
        addView(makeDivider());

        // ── CPU section ───────────────────────────────────────────────────────
        tvCpuPct  = makeVal("--%", COL_WHITE);
        tvCpuTemp = makeVal("--\u00b0C", COL_ORANGE);
        addView(makeInlineRow("CPU", tvCpuPct, tvCpuTemp), rowLp());

        for (int i = 0; i < 8; i++) {
            tvCores[i] = makeVal("----MHz", COL_GRAY);
            addView(makeTwoColRow("CPU" + i, COL_GRAY, 0, true, tvCores[i]), rowLp());
        }
        addView(makeDivider());

        // ── GPU section ───────────────────────────────────────────────────────
        tvGpuPct  = makeVal("--%", COL_WHITE);
        tvGpuTemp = makeVal("--\u00b0C", COL_ORANGE);
        addView(makeInlineRow("GPU", tvGpuPct, tvGpuTemp), rowLp());

        // GPU name (left) + MHz (right) on same row — no indent
        tvGpuName = makeVal("Adreno", COL_GRAY);
        tvGpuFreq = makeVal("--MHz", COL_GRAY);
        addView(makeTwoColRow2(tvGpuName, tvGpuFreq), rowLp());

        // Resolution on its own row, right-aligned
        tvGpuRes = makeVal("----x----", COL_GRAY);
        LinearLayout resRow = makeFullRow();
        View resSpacer = new View(getContext());
        resRow.addView(resSpacer, new LinearLayout.LayoutParams(0, 1, 1f));
        resRow.addView(tvGpuRes, new LinearLayout.LayoutParams(-2, -2));
        addView(resRow, rowLp());
        addView(makeDivider());

        // ── Thermal / Power section ───────────────────────────────────────────
        tvModeVal = makeVal("NORM", COL_WHITE);
        addView(makeTwoColRow("MODE", COL_WHITE, 0, false, tvModeVal), rowLp());


        tvSknVal = makeVal("--\u00b0C", COL_ORANGE);
        addView(makeTwoColRow("SKN", COL_WHITE, 0, false, tvSknVal), rowLp());

        tvPwrVal = makeVal("--W", COL_WHITE);
        addView(makeTwoColRow("PWR", COL_WHITE, 0, false, tvPwrVal), rowLp());
        addView(makeDivider());

        // ── Memory section ────────────────────────────────────────────────────
        // RAM — entire row has brown background
        tvRamVal = makeVal("--G/--G", COL_WHITE);
        LinearLayout ramRow = makeTwoColRow("RAM", COL_WHITE, 0, false, tvRamVal);
        ramRow.setBackgroundColor(BG_RAM);
        addView(ramRow, rowLp());

        // SWAP — entire row has gray background
        tvSwapVal = makeVal("--G/--G", COL_WHITE);
        LinearLayout swapRow = makeTwoColRow("SWAP", COL_WHITE, 0, false, tvSwapVal);
        swapRow.setBackgroundColor(BG_SWAP);
        addView(swapRow, rowLp());

        // BAT — blue proportional fill spanning full row width
        tvBatPct = makeVal("--%", COL_WHITE);
        addView(makeBatRowView(), rowLp());

        addView(makeDivider());

        // TIME
        tvTimeVal = makeVal("--:--", COL_WHITE);
        addView(makeTwoColRow("TIME", COL_WHITE, 0, false, tvTimeVal), rowLp());
    }

    /** Two-column row: [label (min width)] [spacer] [value (right-aligned)] */
    private LinearLayout makeTwoColRow(String label, int labelColor, int labelBg,
                                        boolean small, TextView valueTV) {
        LinearLayout row = makeFullRow();
        TextView tvLabel = makeLabel(label, labelColor);
        if (small) tvLabel.setTextSize(8f);
        if (labelBg != 0) tvLabel.setBackgroundColor(labelBg);
        tvLabel.setMinWidth(dp(small ? 36 : 46));

        View spacer = new View(getContext());
        LinearLayout.LayoutParams sLp = new LinearLayout.LayoutParams(0, 1, 1f);
        spacer.setLayoutParams(sLp);

        LinearLayout.LayoutParams vLp = new LinearLayout.LayoutParams(-2, -2);
        vLp.gravity = Gravity.CENTER_VERTICAL | Gravity.END;

        row.addView(tvLabel);
        row.addView(spacer);
        row.addView(valueTV, vLp);
        return row;
    }

    /** Two-value row: [val1 (left)] [spacer] [val2 (right)] — no bold label */
    private LinearLayout makeTwoColRow2(TextView left, TextView right) {
        LinearLayout row = makeFullRow();
        row.addView(left, new LinearLayout.LayoutParams(-2, -2));
        View spacer = new View(getContext());
        row.addView(spacer, new LinearLayout.LayoutParams(0, 1, 1f));
        LinearLayout.LayoutParams rLp = new LinearLayout.LayoutParams(-2, -2);
        rLp.gravity = Gravity.CENTER_VERTICAL | Gravity.END;
        row.addView(right, rLp);
        return row;
    }

    /** Inline row: [label min width] [val1] [sep] [val2] with spacer at end for alignment */
    private LinearLayout makeInlineRow(String label, TextView val1, TextView val2) {
        LinearLayout row = makeFullRow();
        TextView tvLabel = makeLabel(label, COL_WHITE);
        tvLabel.setMinWidth(dp(46));
        row.addView(tvLabel);
        row.addView(val1);
        row.addView(makeSepView());
        row.addView(val2);
        View spacer = new View(getContext());
        row.addView(spacer, new LinearLayout.LayoutParams(0, 1, 1f));
        return row;
    }

    /** Thin horizontal section divider */
    private View makeDivider() {
        View v = new View(getContext());
        v.setBackgroundColor(0x44FFFFFF);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, dp(1));
        lp.topMargin = dp(1);
        lp.bottomMargin = dp(1);
        v.setLayoutParams(lp);
        return v;
    }

    /** BAT row: solid blue full-row (same pattern as RAM/SWAP) */
    private LinearLayout makeBatRowView() {
        tvBatPct = makeVal("--%", COL_WHITE);
        LinearLayout row = makeTwoColRow("BAT", COL_WHITE, 0, false, tvBatPct);
        row.setBackgroundColor(BG_BAT);
        return row;
    }

    // ── HORIZONTAL layout ─────────────────────────────────────────────────────

    private void buildHorizontal() {
        setOrientation(HORIZONTAL);

        // ── Col 0: FPS block ── (label + big number only, matching original)
        LinearLayout fpsCol = makeVCol();

        TextView fpsHeader = makeLabel("FPS", COL_WHITE);
        fpsCol.addView(fpsHeader, wrapLp());

        tvFpsVal = makeBigVal("--");
        LinearLayout.LayoutParams bigLp = new LinearLayout.LayoutParams(-2, -2);
        bigLp.gravity = Gravity.CENTER_HORIZONTAL;
        fpsCol.addView(tvFpsVal, bigLp);

        addView(fpsCol, new LinearLayout.LayoutParams(-2, -2)); // WRAP_CONTENT height — drives HUD height
        addView(makeSepCol());

        // ── Col 1: CPU block ── (label / % / temp stacked, matching original)
        LinearLayout cpuCol = makeVCol();

        cpuCol.addView(makeLabel("CPU", COL_WHITE), wrapLp());

        tvCpuPct = makeVal("--%", COL_WHITE);
        cpuCol.addView(tvCpuPct, wrapLp());

        tvCpuTemp = makeVal("--\u00b0C", COL_ORANGE);
        cpuCol.addView(tvCpuTemp, wrapLp());

        addView(cpuCol, new LinearLayout.LayoutParams(-2, -1));
        addView(makeSepCol());

        // ── Col 2: CPU cores ── (2 rows of 4, matching original)
        LinearLayout coreCol = makeVCol();

        // 8 cores in 2 rows of 4
        LinearLayout coreRow1 = makeHRow();
        LinearLayout coreRow2 = makeHRow();
        for (int i = 0; i < 8; i++) {
            tvCores[i] = makeVal("C" + i + ":----", COL_GRAY);
            tvCores[i].setPadding(dp(2), 0, dp(4), 0);
            if (i < 4) coreRow1.addView(tvCores[i], wrapLp());
            else        coreRow2.addView(tvCores[i], wrapLp());
        }
        coreCol.addView(coreRow1, wrapLp());
        coreCol.addView(coreRow2, wrapLp());

        addView(coreCol, new LinearLayout.LayoutParams(-2, -1));
        addView(makeSepCol());

        // ── Col 2: GPU block ──
        LinearLayout gpuCol = makeVCol();

        tvGpuName = makeVal("Adreno", COL_GRAY);
        LinearLayout gpuR1 = makeHRow();
        gpuR1.addView(makeLabel("GPU", COL_WHITE));
        gpuR1.addView(makeSepView());
        gpuR1.addView(tvGpuName);
        gpuCol.addView(gpuR1, wrapLp());

        tvGpuPct  = makeVal("--%", COL_WHITE);
        tvGpuFreq = makeVal("--MHz", COL_GRAY);
        LinearLayout gpuR2 = makeHRow();
        gpuR2.addView(tvGpuPct);
        gpuR2.addView(makeSepView());
        gpuR2.addView(tvGpuFreq);
        gpuCol.addView(gpuR2, wrapLp());

        tvGpuRes = makeVal("----x----", COL_GRAY);
        gpuCol.addView(tvGpuRes, wrapLp());

        tvGpuTemp = makeVal("--\u00b0C", COL_ORANGE);
        gpuCol.addView(tvGpuTemp, wrapLp());

        addView(gpuCol, new LinearLayout.LayoutParams(-2, -1));
        addView(makeSepCol());

        // ── Col 3: Thermal labels ──
        LinearLayout thermLabelCol = makeVCol();
        thermLabelCol.addView(makeLabel("MODE", COL_WHITE), wrapLp());
        thermLabelCol.addView(makeLabel("SKN",  COL_WHITE), wrapLp());
        thermLabelCol.addView(makeLabel("PWR",  COL_WHITE), wrapLp());
        addView(thermLabelCol, new LinearLayout.LayoutParams(-2, -1));

        // ── Col 4: Thermal values ──
        LinearLayout thermValCol = makeVCol();
        tvModeVal = makeVal("NORM", COL_WHITE);
        tvSknVal  = makeVal("--\u00b0C", COL_ORANGE);
        tvPwrVal  = makeVal("--W", COL_WHITE);
        thermValCol.addView(tvModeVal, wrapLp());
        thermValCol.addView(tvSknVal,  wrapLp());
        thermValCol.addView(tvPwrVal,  wrapLp());
        addView(thermValCol, new LinearLayout.LayoutParams(-2, -1));
        addView(makeSepCol());

        // ── Col 5: Memory labels (with colored backgrounds) ──
        LinearLayout memLabelCol = makeVCol();

        TextView ramLbl = makeLabel("RAM",  COL_WHITE);
        ramLbl.setBackgroundColor(BG_RAM);
        ramLbl.setPadding(dp(3), 0, dp(3), 0);
        memLabelCol.addView(ramLbl, wrapLp());

        TextView swapLbl = makeLabel("SWAP", COL_WHITE);
        swapLbl.setBackgroundColor(BG_SWAP);
        swapLbl.setPadding(dp(3), 0, dp(3), 0);
        memLabelCol.addView(swapLbl, wrapLp());

        // BAT label with blue bg (in horizontal: just colored label, no proportional fill)
        TextView batLbl = makeLabel("BAT", COL_WHITE);
        batLbl.setBackgroundColor(BG_BAT);
        batLbl.setPadding(dp(3), 0, dp(3), 0);
        memLabelCol.addView(batLbl, wrapLp());

        memLabelCol.addView(makeLabel("TIME", COL_WHITE), wrapLp());
        addView(memLabelCol, new LinearLayout.LayoutParams(-2, -1));

        // ── Col 6: Memory values ──
        LinearLayout memValCol = makeVCol();
        tvRamVal  = makeVal("--G/--G",  COL_WHITE);
        tvSwapVal = makeVal("--G/--G",  COL_WHITE);
        tvBatPct  = makeVal("--%",       COL_WHITE);
        tvTimeVal = makeVal("--:--",     COL_WHITE);
        memValCol.addView(tvRamVal,  wrapLp());
        memValCol.addView(tvSwapVal, wrapLp());
        memValCol.addView(tvBatPct,  wrapLp());
        memValCol.addView(tvTimeVal, wrapLp());
        addView(memValCol, new LinearLayout.LayoutParams(-2, -1));
    }

    // ── View helpers ──────────────────────────────────────────────────────────

    private LinearLayout makeFullRow() {
        LinearLayout ll = new LinearLayout(getContext());
        ll.setOrientation(HORIZONTAL);
        ll.setClipChildren(false);
        ll.setClipToPadding(false);
        return ll;
    }

    private LinearLayout makeVCol() {
        LinearLayout ll = new LinearLayout(getContext());
        ll.setOrientation(VERTICAL);
        ll.setClipChildren(false);
        ll.setClipToPadding(false);
        ll.setPadding(dp(4), 0, dp(4), 0);
        return ll;
    }

    private LinearLayout makeHRow() {
        LinearLayout ll = new LinearLayout(getContext());
        ll.setOrientation(HORIZONTAL);
        ll.setClipChildren(false);
        return ll;
    }

    private LinearLayout makeSepCol() {
        LinearLayout col = new LinearLayout(getContext());
        col.setOrientation(VERTICAL);
        for (int i = 0; i < 4; i++) col.addView(makeSepView(), wrapLp());
        return col;
    }

    /** Bold label — left column of each row */
    private TextView makeLabel(String text, int color) {
        TextView tv = new TextView(getContext());
        tv.setText(text);
        tv.setTextColor(color);
        tv.setTextSize(9f);
        tv.setPadding(dp(3), 0, dp(3), 0);
        tv.setTypeface(Typeface.MONOSPACE, Typeface.BOLD);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, -2);
        lp.gravity = Gravity.CENTER_VERTICAL;
        tv.setLayoutParams(lp);
        return tv;
    }

    /** Normal value — right column */
    private TextView makeVal(String text, int color) {
        TextView tv = new TextView(getContext());
        tv.setText(text);
        tv.setTextColor(color);
        tv.setTextSize(9f);
        tv.setPadding(dp(3), 0, dp(3), 0);
        tv.setTypeface(Typeface.MONOSPACE);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, -2);
        lp.gravity = Gravity.CENTER_VERTICAL;
        tv.setLayoutParams(lp);
        return tv;
    }

    /** Large FPS value */
    private TextView makeBigVal(String text) {
        TextView tv = new TextView(getContext());
        tv.setText(text);
        tv.setTextColor(COL_WHITE);
        tv.setTextSize(16f);
        tv.setPadding(dp(3), 0, dp(3), 0);
        tv.setTypeface(Typeface.MONOSPACE, Typeface.BOLD);
        return tv;
    }

    private TextView makeSepView() {
        TextView tv = new TextView(getContext());
        tv.setText("|");
        tv.setTextColor(COL_DIM);
        tv.setTextSize(8f);
        tv.setPadding(dp(2), 0, dp(2), 0);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, -2);
        lp.gravity = Gravity.CENTER_VERTICAL;
        tv.setLayoutParams(lp);
        return tv;
    }

    private LinearLayout.LayoutParams rowLp() {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, -2);
        lp.bottomMargin = dp(1);
        return lp;
    }

    private LinearLayout.LayoutParams wrapLp() {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, -2);
        lp.bottomMargin = dp(1);
        return lp;
    }

    private int dp(int v) {
        return Math.round(v * getResources().getDisplayMetrics().density);
    }

    // ── Measure override ─────────────────────────────────────────────────────

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        // Cap vertical mode width at 200dp so MATCH_PARENT rows don't snap to full screen width.
        // Horizontal mode uses natural width (the strip spans content columns).
        if (isVertical) {
            widthMeasureSpec = MeasureSpec.makeMeasureSpec(dp(120), MeasureSpec.EXACTLY);
        }
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    // ── Orientation toggle ────────────────────────────────────────────────────

    private void toggleOrientation() {
        isVertical = !isVertical;
        try {
            getContext().getSharedPreferences("bh_prefs", 0).edit()
                    .putBoolean("konkr_hud_vertical", isVertical).apply();
        } catch (Exception ignored) {}
        buildLayout();
        post(new Runnable() {
            @Override public void run() { reclampPosition(); }
        });
    }

    private void reclampPosition() {
        ViewGroup.LayoutParams vlp = getLayoutParams();
        if (!(vlp instanceof FrameLayout.LayoutParams)) { requestLayout(); return; }
        FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) vlp;
        int screenW = getRootView().getWidth();
        int screenH = getRootView().getHeight();
        if (screenW == 0 || screenH == 0) { requestLayout(); return; }
        measure(View.MeasureSpec.makeMeasureSpec(screenW, View.MeasureSpec.AT_MOST),
                View.MeasureSpec.makeMeasureSpec(screenH, View.MeasureSpec.AT_MOST));
        int nW = getMeasuredWidth(), nH = getMeasuredHeight();
        if (lp.leftMargin < 0) lp.leftMargin = 0;
        if (lp.leftMargin + nW > screenW) lp.leftMargin = screenW - nW;
        float ty = getTranslationY();
        if (ty < 0) ty = 0;
        if (ty + nH > screenH) ty = screenH - nH;
        setTranslationY(ty);
        setLayoutParams(lp);
    }

    // ── Drag + tap ────────────────────────────────────────────────────────────

    private OnTouchListener makeDragListener() {
        return new OnTouchListener() {
            private static final int TAP_SLOP = 10;
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) v.getLayoutParams();
                if (lp == null) return false;
                switch (event.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        if (lp.gravity != 0) {
                            lp.gravity = 0;
                            lp.leftMargin = v.getLeft();
                            lp.topMargin = 0;
                            v.setTranslationY(v.getTop());
                            v.setLayoutParams(lp);
                        }
                        dragLastX = event.getRawX(); dragLastY = event.getRawY();
                        dragStartX = event.getRawX(); dragStartY = event.getRawY();
                        dragMoved = false;
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        float mx = event.getRawX() - dragStartX;
                        float my = event.getRawY() - dragStartY;
                        if (!dragMoved && (Math.abs(mx) > TAP_SLOP || Math.abs(my) > TAP_SLOP))
                            dragMoved = true;
                        int dx = (int)(event.getRawX() - dragLastX);
                        int dy = (int)(event.getRawY() - dragLastY);
                        int sw = v.getRootView().getWidth();
                        int sh = v.getRootView().getHeight();
                        lp.leftMargin = Math.max(0, Math.min(lp.leftMargin + dx, sw - v.getWidth()));
                        v.setLayoutParams(lp);
                        float newTy = Math.max(0, Math.min(v.getTranslationY() + dy, sh - v.getHeight()));
                        v.setTranslationY(newTy);
                        dragLastX = event.getRawX(); dragLastY = event.getRawY();
                        return true;
                    case MotionEvent.ACTION_UP:
                        if (!dragMoved) {
                            toggleOrientation();
                        } else {
                            try {
                                FrameLayout.LayoutParams slp = (FrameLayout.LayoutParams) v.getLayoutParams();
                                getContext().getSharedPreferences("bh_prefs", 0).edit()
                                        .putInt("konkr_hud_pos_x", slp.leftMargin)
                                        .putInt("konkr_hud_pos_y", (int) v.getTranslationY())
                                        .apply();
                            } catch (Exception ignored) {}
                        }
                        return true;
                }
                return false;
            }
        };
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        try {
            SharedPreferences sp = getContext().getSharedPreferences("bh_prefs", 0);
            applyBackgroundOpacity(sp.getInt("hud_opacity", 80));
            final boolean savedVert = sp.getBoolean("konkr_hud_vertical", true);
            final int savedX = sp.getInt("konkr_hud_pos_x", -1);
            final int savedY = sp.getInt("konkr_hud_pos_y", -1);
            handler.post(new Runnable() {
                @Override public void run() {
                    if (!isAttachedToWindow()) return;
                    if (savedVert != isVertical) toggleOrientation();
                    if (savedX >= 0 || savedY >= 0) {
                        ViewGroup.LayoutParams vlp = getLayoutParams();
                        if (vlp instanceof FrameLayout.LayoutParams) {
                            FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) vlp;
                            lp.gravity = 0; lp.topMargin = 0;
                            if (savedX >= 0) lp.leftMargin = savedX;
                            setLayoutParams(lp);
                            if (savedY >= 0) setTranslationY(savedY);
                        }
                    }
                }
            });
        } catch (Exception ignored) {}
        running = true;
        Thread t = new Thread(this, "BhKonkrHud");
        t.setDaemon(true);
        t.start();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        running = false;
    }

    public void applyBackgroundOpacity(int opacity0to100) {
        int alpha = opacity0to100 * 255 / 100;
        setBackgroundColor(Color.argb(alpha, 0, 0, 0));
        float sr = opacity0to100 < 10 ? 3f : (opacity0to100 < 30 ? 4f : 0f);
        int sc = sr > 0 ? 0xFF000000 : 0;
        for (TextView tv : allTextViews()) if (tv != null) tv.setShadowLayer(sr, 0f, 0f, sc);
    }

    private TextView[] allTextViews() {
        java.util.ArrayList<TextView> list = new java.util.ArrayList<>();
        TextView[] fixed = { tvFpsVal, tvFpsMin, tvFpsCpuTmp, tvCpuPct, tvCpuTemp,
                tvGpuPct, tvGpuTemp, tvGpuName, tvGpuFreq, tvGpuRes,
                tvModeVal, tvSknVal, tvPwrVal,
                tvRamVal, tvSwapVal, tvBatPct, tvTimeVal };
        for (TextView tv : fixed) if (tv != null) list.add(tv);
        for (TextView tv : tvCores) if (tv != null) list.add(tv);
        return list.toArray(new TextView[0]);
    }

    // ── Update loop ───────────────────────────────────────────────────────────

    @Override
    public void run() {
        // Read GPU name + res once (static data)
        final String gpuModelName = readGpuName();
        final String gpuResStr    = readGpuRes();

        while (running) {
            try {
                final String timeStr = new SimpleDateFormat("HH:mm", Locale.getDefault()).format(new Date());
                final int cpu     = readCpu();
                final int cpuTmp  = readCpuTemp();
                final int gpu     = readGpu();
                final int gpuTmp  = readGpuTemp();
                final int gpuMhz  = readGpuMhz();
                final int skn     = readSkinTemp();
                final float pwr   = readPwr();
                final float[] ram  = readRamGb();
                final float[] swap = readSwapGb();
                final int batPct  = readBatPct();
                final float fps   = readFps();
                final int[] cores = readCoreMhz();
                final String mode = readMode();

                // Update min FPS (reset every 60 samples)
                if (fps > 0) {
                    if (fps < fpsMin) fpsMin = fps;
                }
                fpsMinSamples++;
                if (fpsMinSamples >= 60) {
                    fpsMin = fps > 0 ? fps : 9999f;
                    fpsMinSamples = 0;
                }
                final float minFps = fpsMin >= 9999f ? 0f : fpsMin;

                handler.post(new Runnable() {
                    @Override public void run() {
                        if (!isAttachedToWindow()) return;

                        // FPS
                        if (tvFpsVal != null)
                            tvFpsVal.setText(fps > 0 ? String.format("%.0f", fps) : "--");
                        if (tvFpsMin != null)
                            tvFpsMin.setText(minFps > 0 ? String.format("%.0f", minFps) : "--");
                        if (tvFpsCpuTmp != null)
                            tvFpsCpuTmp.setText(cpuTmp + "\u00b0C");

                        // CPU
                        if (tvCpuPct != null)  tvCpuPct.setText(cpu + "%");
                        if (tvCpuTemp != null)  tvCpuTemp.setText(cpuTmp + "\u00b0C");

                        // Cores
                        if (tvCores != null && cores != null) {
                            for (int i = 0; i < 8 && i < cores.length; i++) {
                                if (tvCores[i] == null) continue;
                                if (isVertical) {
                                    tvCores[i].setText(String.format("%4dMHz", cores[i]));
                                } else {
                                    tvCores[i].setText(String.format("C%d:%4d", i, cores[i]));
                                }
                            }
                        }

                        // GPU
                        if (tvGpuPct != null)  tvGpuPct.setText(gpu + "%");
                        if (tvGpuTemp != null)  tvGpuTemp.setText(gpuTmp + "\u00b0C");
                        if (tvGpuName != null)  tvGpuName.setText(gpuModelName);
                        if (tvGpuFreq != null)  tvGpuFreq.setText(gpuMhz + "MHz");
                        if (tvGpuRes != null)   tvGpuRes.setText(gpuResStr);

                        // Thermal / power
                        if (tvModeVal != null) {
                            tvModeVal.setText(mode);
                            tvModeVal.setTextColor(
                                    "MAX".equals(mode)  ? COL_RED :
                                    "SUST".equals(mode) ? COL_ORANGE : COL_WHITE);
                        }
                        if (tvSknVal != null) tvSknVal.setText(skn > 0 ? skn + "\u00b0C" : "--\u00b0C");
                        if (tvPwrVal != null) tvPwrVal.setText(
                                pwr > 0 ? String.format("%.1fW", pwr) : "--W");

                        // RAM / SWAP
                        if (tvRamVal != null)
                            tvRamVal.setText(String.format("%.0fG/%.0fG", ram[0], ram[1]));
                        if (tvSwapVal != null)
                            tvSwapVal.setText(String.format("%.1fG/%.0fG", swap[0], swap[1]));

                        // BAT
                        if (tvBatPct != null) tvBatPct.setText(batPct + "%");

                        // TIME
                        if (tvTimeVal != null) tvTimeVal.setText(timeStr);
                    }
                });

                Thread.sleep(1000);
            } catch (InterruptedException e) {
                break;
            } catch (Exception ignored) {}
        }
    }

    // ── Stat readers ──────────────────────────────────────────────────────────

    private int readCpu() {
        String line = readSysfsLine("/proc/stat");
        if (line != null && line.startsWith("cpu ")) {
            String[] parts = line.trim().split("\\s+");
            if (parts.length >= 5) {
                try {
                    long user = Long.parseLong(parts[1]), nice = Long.parseLong(parts[2]);
                    long sys  = Long.parseLong(parts[3]), idle = Long.parseLong(parts[4]);
                    long iow  = parts.length > 5 ? Long.parseLong(parts[5]) : 0;
                    long total = user + nice + sys + idle + iow;
                    long dTotal = total - prevTotal, dIdle = (idle + iow) - prevIdle;
                    prevTotal = total; prevIdle = idle + iow;
                    if (dTotal > 0) return (int)(100L * (dTotal - dIdle) / dTotal);
                } catch (NumberFormatException ignored) {}
            }
        }
        // Fallback: process CPU time via Android API (same method as GameHub DeviceMetrics)
        long cpuTime  = android.os.Process.getElapsedCpuTime();
        long wallTime = android.os.SystemClock.elapsedRealtime();
        if (prevProcCpuTime >= 0) {
            long dCpu  = cpuTime  - prevProcCpuTime;
            long dWall = wallTime - prevProcWallTime;
            int cores  = Runtime.getRuntime().availableProcessors();
            prevProcCpuTime  = cpuTime;
            prevProcWallTime = wallTime;
            if (dWall > 0) return Math.min(100, (int)(dCpu * 100L / (dWall * cores)));
        }
        prevProcCpuTime  = cpuTime;
        prevProcWallTime = wallTime;
        return 0;
    }

    private int readCpuTemp() {
        String[] types = {"cpu-cluster0", "cpu0-thermal", "cpu-thermal", "cpucluster", "cpu"};
        for (int z = 0; z < 20; z++) {
            String type = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/type");
            if (type == null) continue;
            String tl = type.trim().toLowerCase();
            for (String t : types) {
                if (tl.contains(t)) {
                    String temp = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/temp");
                    if (temp != null) {
                        try { int v = Integer.parseInt(temp.trim()); return v > 1000 ? v / 1000 : v; }
                        catch (NumberFormatException ignored) {}
                    }
                }
            }
        }
        String v = readSysfsLine("/sys/class/thermal/thermal_zone0/temp");
        if (v != null) { try { int t = Integer.parseInt(v.trim()); return t > 1000 ? t / 1000 : t; } catch (NumberFormatException ignored) {} }
        return 0;
    }

    private int readGpu() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpubusy");
        if (v != null) {
            try {
                String[] p = v.trim().split("\\s+");
                if (p.length >= 2) {
                    long busy = Long.parseLong(p[0]), total = Long.parseLong(p[1]);
                    if (total > 0) return (int)(100L * busy / total);
                }
            } catch (NumberFormatException ignored) {}
        }
        v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage");
        if (v != null) { try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); } catch (NumberFormatException ignored) {} }
        v = readSysfsLine("/sys/kernel/gpu/gpu_busy");
        if (v != null) { try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); } catch (NumberFormatException ignored) {} }
        v = readSysfsLine("/sys/class/misc/mali0/device/utilisation");
        if (v != null) { try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); } catch (NumberFormatException ignored) {} }
        return 0;
    }

    private int readGpuTemp() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/temp");
        if (v != null) { try { int t = Integer.parseInt(v.trim()); return t > 1000 ? t / 1000 : t; } catch (NumberFormatException ignored) {} }
        v = readSysfsLine("/sys/kernel/gpu/gpu_tmu");
        if (v != null) { try { int t = Integer.parseInt(v.trim()); return t > 1000 ? t / 1000 : t; } catch (NumberFormatException ignored) {} }
        String[] types = {"gpuss-0", "gpuss", "gpu-thermal", "gpu"};
        for (int z = 0; z < 80; z++) {
            String type = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/type");
            if (type == null) continue;
            String tl = type.trim().toLowerCase();
            for (String t : types) {
                if (tl.contains(t)) {
                    String temp = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/temp");
                    if (temp != null) { try { int val = Integer.parseInt(temp.trim()); return val > 1000 ? val / 1000 : val; } catch (NumberFormatException ignored) {} }
                }
            }
        }
        return 0;
    }

    private int readGpuMhz() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpuclk");
        if (v != null) { try { return (int)(Long.parseLong(v.trim()) / 1_000_000L); } catch (NumberFormatException ignored) {} }
        v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/clock_mhz");
        if (v != null) { try { return Integer.parseInt(v.trim()); } catch (NumberFormatException ignored) {} }
        return 0;
    }

    private String readGpuName() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpu_model");
        if (v != null && !v.trim().isEmpty()) return v.trim();
        return "Adreno";
    }

    private String readGpuRes() {
        try {
            DisplayMetrics dm = getContext().getResources().getDisplayMetrics();
            return dm.widthPixels + "x" + dm.heightPixels;
        } catch (Exception e) { return ""; }
    }

    private int[] readCoreMhz() {
        int[] result = new int[8];
        for (int i = 0; i < 8; i++) {
            String v = readSysfsLine("/sys/devices/system/cpu/cpu" + i + "/cpufreq/scaling_cur_freq");
            if (v != null) { try { result[i] = Integer.parseInt(v.trim()) / 1000; } catch (NumberFormatException ignored) {} }
        }
        return result;
    }


    private int readSkinTemp() {
        String[] types = {"skin", "tskin", "surface", "xo-therm", "xo_therm"};
        for (int z = 0; z < 80; z++) {
            String type = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/type");
            if (type == null) continue;
            String tl = type.trim().toLowerCase();
            for (String t : types) {
                if (tl.contains(t)) {
                    String temp = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/temp");
                    if (temp != null) { try { int v = Integer.parseInt(temp.trim()); return v > 1000 ? v / 1000 : v; } catch (NumberFormatException ignored) {} }
                }
            }
        }
        return 0;
    }

    private float[] readRamGb() {
        long memTotal = 0, memAvail = 0;
        try (BufferedReader br = new BufferedReader(new FileReader("/proc/meminfo"))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith("MemTotal:"))     memTotal = parseMeminfoKb(line);
                else if (line.startsWith("MemAvailable:")) memAvail = parseMeminfoKb(line);
            }
        } catch (IOException ignored) {}
        float total = memTotal / (1024f * 1024f);
        float used  = (memTotal - memAvail) / (1024f * 1024f);
        return new float[]{used, total};
    }

    private float[] readSwapGb() {
        long swapTotal = 0, swapFree = 0;
        try (BufferedReader br = new BufferedReader(new FileReader("/proc/meminfo"))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith("SwapTotal:"))    swapTotal = parseMeminfoKb(line);
                else if (line.startsWith("SwapFree:")) swapFree  = parseMeminfoKb(line);
            }
        } catch (IOException ignored) {}
        float used  = (swapTotal - swapFree) / (1024f * 1024f);
        float total = swapTotal / (1024f * 1024f);
        return new float[]{used, total};
    }

    private long parseMeminfoKb(String line) {
        try {
            String[] parts = line.trim().split("\\s+");
            return parts.length >= 2 ? Long.parseLong(parts[1]) : 0;
        } catch (NumberFormatException e) { return 0; }
    }

    private int readBatPct() {
        try {
            BatteryManager bm = (BatteryManager) getContext().getSystemService(Context.BATTERY_SERVICE);
            if (bm == null) return 0;
            int pct = (int) bm.getLongProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
            return (pct < 0 || pct > 100) ? 0 : pct;
        } catch (Exception e) { return 0; }
    }

    private float readPwr() {
        try {
            BatteryManager bm = (BatteryManager) getContext().getSystemService(Context.BATTERY_SERVICE);
            if (bm == null) return 0f;
            long currentNow = bm.getLongProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW);
            if (currentNow == Long.MIN_VALUE) return 0f;
            float voltage = 3.7f;
            String voltStr = readSysfsLine("/sys/class/power_supply/battery/voltage_now");
            if (voltStr != null) {
                try { voltage = Float.parseFloat(voltStr.trim()) / 1_000_000f; } catch (NumberFormatException ignored) {}
            }
            float currentA = Math.abs(currentNow) / 1_000_000f;
            if (currentA < 0.01f) currentA = Math.abs(currentNow) / 1_000f;
            return voltage * currentA;
        } catch (Exception e) { return 0f; }
    }

    private String readMode() {
        try {
            SharedPreferences sp = getContext().getSharedPreferences("bh_prefs", 0);
            if (sp.getBoolean("max_adreno_clocks", false)) return "MAX";
            if (sp.getBoolean("sustained_perf", false))    return "SUST";
        } catch (Exception ignored) {}
        return "NORM";
    }

    private float readFps() {
        if (activity == null) return 0f;
        try {
            java.lang.reflect.Field jField = activity.getClass().getField("j");
            Object provider = jField.get(activity);
            if (provider == null) return 0f;
            java.lang.reflect.Method getA = provider.getClass().getMethod("a");
            Object result = getA.invoke(provider);
            return result == null ? 0f : (float) result;
        } catch (Exception e) { return 0f; }
    }

    private String readSysfsLine(String path) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            return br.readLine();
        } catch (IOException e) { return null; }
    }
}
