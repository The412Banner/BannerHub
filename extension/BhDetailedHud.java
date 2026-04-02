package com.xj.winemu.sidebar;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.os.BatteryManager;
import android.os.Handler;
import android.os.Looper;
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
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Detailed HUD overlay — shown when both "Winlator HUD" and "Extra Detailed" are enabled.
 *
 * Horizontal (default): two-row layout
 *   Row 1: TIME | CPU%/CPU°C | C0 | C2 | C4 | C6 | BAT W/BAT°C
 *   Row 2: API  | GPU%/GPU°C | C1 | C3 | C5 | C7 | RAM%        | FPS (spans rows) [graph]
 *
 * Vertical (tap to toggle):
 *   API | TIME
 *   BAT W | BAT°C
 *   CPU% | CPU°C
 *   GPU% | GPU°C
 *   GPU MHz
 *   C0 | C1 ... C6 | C7
 *   RAM%
 *   SWAP used/total GB
 *   FPS [graph]
 *
 * Drag to reposition. Position and orientation persist in bh_prefs.
 * Background opacity shared with normal HUD (hud_opacity).
 */
public class BhDetailedHud extends LinearLayout implements Runnable {

    private final Activity activity;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private volatile boolean running = false;
    private boolean isVertical = false;

    // Stat TextViews — rebuilt on orientation toggle; null-checked in update loop
    private TextView tvApi, tvTime, tvCpu, tvCpuTmp, tvGpu, tvGpuTmp, tvGpuMhz;
    private TextView tvBat, tvBatTmp, tvRam, tvSwap, tvFps;
    private TextView[] tvCores;
    private FpsGraphView fpsGraph;

    // CPU stat tracking across 1-second samples
    private long prevTotal = 0, prevIdle = 0;

    // Drag state
    private float dragLastX, dragLastY, dragStartX, dragStartY;
    private boolean dragMoved;

    public BhDetailedHud(Context ctx) {
        super(ctx);
        this.activity = ctx instanceof Activity ? (Activity) ctx : null;
        setBackgroundColor(0xCC000000);
        setPadding(6, 4, 6, 4);
        buildLayout();
        setOnTouchListener(makeDragListener());
    }

    // ── Layout builders ───────────────────────────────────────────────────────

    private void buildLayout() {
        removeAllViews();
        // Null all refs so update loop doesn't use stale views after a rebuild
        tvApi = tvTime = tvCpu = tvCpuTmp = tvGpu = tvGpuTmp = tvGpuMhz = null;
        tvBat = tvBatTmp = tvRam = tvSwap = tvFps = null;
        tvCores = new TextView[8];
        fpsGraph = null;
        if (!isVertical) buildHorizontal();
        else buildVertical();
        // Re-apply opacity rules to freshly created TextViews (covers orientation toggles)
        try {
            int opacity = getContext().getSharedPreferences("bh_prefs", 0)
                    .getInt("hud_opacity", 80);
            applyBackgroundOpacity(opacity);
        } catch (Exception ignored) {}
    }

    /**
     * Two-row horizontal layout built as vertical column groups so separators
     * align perfectly between row 1 and row 2.
     *
     * Each "column" is a VERTICAL LinearLayout:  [row1 cell]
     *                                             [row2 cell]
     * Android auto-sizes each column to the wider of its two cells, so the
     * "|" separator columns line up as a solid vertical divider between rows.
     */
    private void buildHorizontal() {
        setOrientation(HORIZONTAL);
        setPadding(6, 4, 6, 4);

        // Create all TextViews first
        tvTime   = makeLabel("--:--",    0xFFFFFFFF);
        tvApi    = makeLabel("API",      0xFFCE93D8);

        tvCpu    = makeLabel("CPU --%",  0xFFFFFFFF);
        tvCpuTmp = makeLabel("/--°C",    0xFFEF9A9A);
        tvGpu    = makeLabel("GPU --%",  0xFFFFAB91);
        tvGpuTmp = makeLabel("/--°C",    0xFFEF9A9A);

        for (int i = 0; i < 8; i++)
            tvCores[i] = makeLabel("C" + i + ":----", 0xFFCCCCCC);

        tvBat    = makeLabel("BAT --W",  0xFFFFD54F);
        tvBatTmp = makeLabel("/--°C",    0xFFEF9A9A);
        tvRam    = makeLabel("RAM --%",  0xFF90CAF9);

        // Col 0: TIME / API
        addColGroup(tvTime, tvApi);
        addSepCol();

        // Col 1: CPU%/TMP (inline) / GPU%/TMP (inline)
        addColGroup(inlineRow(tvCpu, tvCpuTmp), inlineRow(tvGpu, tvGpuTmp));
        addSepCol();

        // Cols 2-5: paired cores C0/C1, C2/C3, C4/C5, C6/C7
        for (int i = 0; i < 8; i += 2) {
            addColGroup(tvCores[i], tvCores[i + 1]);
            addSepCol();
        }

        // Col 6: BAT W/TMP (inline) / RAM%
        addColGroup(inlineRow(tvBat, tvBatTmp), tvRam);

        // FPS block: label (row1) + graph (row2), spans full height via MATCH_PARENT
        LinearLayout fpsBlock = new LinearLayout(getContext());
        fpsBlock.setOrientation(VERTICAL);
        fpsBlock.setPadding(dp(6), 0, 0, 0);

        tvFps = makeLabel("FPS --", 0xFF76FF03);
        LinearLayout.LayoutParams fpsLabelLp = new LinearLayout.LayoutParams(-2, -2);
        fpsLabelLp.gravity = Gravity.CENTER_HORIZONTAL;
        fpsBlock.addView(tvFps, fpsLabelLp);

        fpsGraph = new FpsGraphView(getContext());
        LinearLayout.LayoutParams graphLp = new LinearLayout.LayoutParams(dp(56), 0, 1f);
        graphLp.topMargin = dp(1);
        fpsBlock.addView(fpsGraph, graphLp);

        addView(fpsBlock, new LinearLayout.LayoutParams(-2, -1)); // MATCH_PARENT height
    }

    /** Wraps two views in a VERTICAL LinearLayout (one column, two rows). */
    private void addColGroup(View top, View bottom) {
        LinearLayout col = new LinearLayout(getContext());
        col.setOrientation(VERTICAL);
        col.addView(top,    new LinearLayout.LayoutParams(-2, -2));
        col.addView(bottom, new LinearLayout.LayoutParams(-2, -2));
        addView(col, new LinearLayout.LayoutParams(-2, -2));
    }

    /** Adds a separator column — two stacked "|" chars, one per row. */
    private void addSepCol() {
        LinearLayout col = new LinearLayout(getContext());
        col.setOrientation(VERTICAL);
        col.addView(sep(), new LinearLayout.LayoutParams(-2, -2));
        col.addView(sep(), new LinearLayout.LayoutParams(-2, -2));
        addView(col, new LinearLayout.LayoutParams(-2, -2));
    }

    /** Wraps two views side-by-side in a HORIZONTAL LinearLayout (for inline stat+temp). */
    private LinearLayout inlineRow(View a, View b) {
        LinearLayout ll = new LinearLayout(getContext());
        ll.setOrientation(HORIZONTAL);
        ll.addView(a, new LinearLayout.LayoutParams(-2, -2));
        ll.addView(b, new LinearLayout.LayoutParams(-2, -2));
        return ll;
    }

    /** Single-column vertical layout. */
    private void buildVertical() {
        setOrientation(VERTICAL);

        // API | TIME
        LinearLayout rowApiTime = row();
        tvApi  = makeLabel("API",    0xFFCE93D8);
        tvTime = makeLabel("--:--",  0xFFFFFFFF);
        rowApiTime.addView(tvApi); rowApiTime.addView(sep()); rowApiTime.addView(tvTime);
        addRow(rowApiTime);

        // BAT W | BAT°C
        LinearLayout rowBat = row();
        tvBat    = makeLabel("BAT --W", 0xFFFFD54F);
        tvBatTmp = makeLabel("/--°C",   0xFFEF9A9A);
        rowBat.addView(tvBat); rowBat.addView(tvBatTmp);
        addRow(rowBat);

        // CPU% | CPU°C
        LinearLayout rowCpu = row();
        tvCpu    = makeLabel("CPU --%", 0xFFFFFFFF);
        tvCpuTmp = makeLabel("/--°C",   0xFFEF9A9A);
        rowCpu.addView(tvCpu); rowCpu.addView(tvCpuTmp);
        addRow(rowCpu);

        // GPU% | GPU°C
        LinearLayout rowGpu = row();
        tvGpu    = makeLabel("GPU --%", 0xFFFFAB91);
        tvGpuTmp = makeLabel("/--°C",   0xFFEF9A9A);
        rowGpu.addView(tvGpu); rowGpu.addView(tvGpuTmp);
        addRow(rowGpu);

        // GPU MHz (only shown in vertical mode)
        tvGpuMhz = makeLabel("GPU --MHz", 0xFFFFAB91);
        addView(tvGpuMhz, wrapLp());

        // C0|C1, C2|C3, C4|C5, C6|C7
        for (int i = 0; i < 8; i += 2) {
            LinearLayout rowCore = row();
            tvCores[i]   = makeLabel("C" + i + ":----",     0xFFCCCCCC);
            tvCores[i+1] = makeLabel("C" + (i+1) + ":----", 0xFFCCCCCC);
            rowCore.addView(tvCores[i]); rowCore.addView(sep()); rowCore.addView(tvCores[i+1]);
            addRow(rowCore);
        }

        // RAM%
        tvRam = makeLabel("RAM --%", 0xFF90CAF9);
        addView(tvRam, wrapLp());

        // SWAP used / total GB
        tvSwap = makeLabel("SWP --/-- GB", 0xFF90CAF9);
        addView(tvSwap, wrapLp());

        // FPS label
        tvFps = makeLabel("FPS --", 0xFF76FF03);
        addView(tvFps, wrapLp());

        // Graph full width, fixed height
        fpsGraph = new FpsGraphView(getContext());
        LinearLayout.LayoutParams graphLp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, dp(20));
        graphLp.topMargin = dp(2);
        addView(fpsGraph, graphLp);
    }

    // ── Layout helpers ─────────────────────────────────────────────────────

    private TextView makeLabel(String text, int color) {
        TextView tv = new TextView(getContext());
        tv.setText(text);
        tv.setTextColor(color);
        tv.setTextSize(8f);
        tv.setPadding(3, 0, 3, 0);
        tv.setTypeface(Typeface.MONOSPACE);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_VERTICAL;
        tv.setLayoutParams(lp);
        return tv;
    }

    private View sep() {
        TextView tv = new TextView(getContext());
        tv.setText("|");
        tv.setTextColor(0xFF444444);
        tv.setTextSize(7.5f);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_VERTICAL;
        tv.setLayoutParams(lp);
        return tv;
    }

    private LinearLayout row() {
        LinearLayout ll = new LinearLayout(getContext());
        ll.setOrientation(LinearLayout.HORIZONTAL);
        return ll;
    }

    private void addRow(LinearLayout row) {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(1);
        addView(row, lp);
    }

    private LinearLayout.LayoutParams wrapLp() {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(1);
        return lp;
    }

    private int dp(int v) {
        return Math.round(v * getResources().getDisplayMetrics().density);
    }

    // ── Orientation toggle ─────────────────────────────────────────────────

    private void toggleOrientation() {
        isVertical = !isVertical;
        try {
            getContext().getSharedPreferences("bh_prefs", 0).edit()
                    .putBoolean("hud_detail_vertical", isVertical).apply();
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
        measure(
                View.MeasureSpec.makeMeasureSpec(screenW, View.MeasureSpec.AT_MOST),
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

    // ── Drag + tap touch listener ──────────────────────────────────────────

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
                        int screenW = v.getRootView().getWidth();
                        int screenH = v.getRootView().getHeight();
                        lp.leftMargin = Math.max(0, Math.min(lp.leftMargin + dx, screenW - v.getWidth()));
                        v.setLayoutParams(lp);
                        float newTy = Math.max(0, Math.min(v.getTranslationY() + dy, screenH - v.getHeight()));
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
                                        .putInt("hud_detail_pos_x", slp.leftMargin)
                                        .putInt("hud_detail_pos_y", (int) v.getTranslationY())
                                        .apply();
                            } catch (Exception ignored) {}
                        }
                        return true;
                }
                return false;
            }
        };
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        try {
            SharedPreferences sp = getContext().getSharedPreferences("bh_prefs", 0);
            applyBackgroundOpacity(sp.getInt("hud_opacity", 80));
            final boolean savedVertical = sp.getBoolean("hud_detail_vertical", false);
            final int savedX = sp.getInt("hud_detail_pos_x", -1);
            final int savedY = sp.getInt("hud_detail_pos_y", -1);
            handler.post(new Runnable() {
                @Override public void run() {
                    if (!isAttachedToWindow()) return;
                    if (savedVertical && !isVertical) toggleOrientation();
                    if (savedX >= 0 || savedY >= 0) {
                        ViewGroup.LayoutParams vlp = getLayoutParams();
                        if (vlp instanceof FrameLayout.LayoutParams) {
                            FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) vlp;
                            lp.gravity = 0;
                            lp.topMargin = 0;
                            if (savedX >= 0) lp.leftMargin = savedX;
                            setLayoutParams(lp);
                            if (savedY >= 0) setTranslationY(savedY);
                        }
                    }
                }
            });
        } catch (Exception ignored) {}
        running = true;
        Thread t = new Thread(this, "BhDetailedHud");
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
        // Mirror BhFrameRating rules:
        //   < 10% → tight shadow (simulates text outline when background is transparent)
        //  10-29% → blurred shadow halo
        //  ≥ 30%  → no shadow
        float shadowRadius = opacity0to100 < 10 ? 3f : (opacity0to100 < 30 ? 4f : 0f);
        int shadowColor = shadowRadius > 0 ? 0xFF000000 : 0;
        for (TextView tv : allTextViews()) {
            tv.setShadowLayer(shadowRadius, 0f, 0f, shadowColor);
        }
    }

    /** Collects all non-null TextViews currently in the layout for batch styling. */
    private TextView[] allTextViews() {
        java.util.ArrayList<TextView> list = new java.util.ArrayList<>();
        TextView[] fixed = { tvApi, tvTime, tvCpu, tvCpuTmp, tvGpu, tvGpuTmp, tvGpuMhz,
                             tvBat, tvBatTmp, tvRam, tvSwap, tvFps };
        for (TextView tv : fixed) if (tv != null) list.add(tv);
        if (tvCores != null) for (TextView tv : tvCores) if (tv != null) list.add(tv);
        return list.toArray(new TextView[0]);
    }

    // ── Update loop ───────────────────────────────────────────────────────

    @Override
    public void run() {
        while (running) {
            try {
                final String api      = readApiName();
                final String timeStr  = new SimpleDateFormat("HH:mm", Locale.getDefault()).format(new Date());
                final int cpu         = readCpu();
                final int cpuTmp      = readCpuTemp();
                final int gpu         = readGpu();
                final int gpuTmp      = readGpuTemp();
                final int gpuMhz      = readGpuMhz();
                final int ram         = readRam();
                final float[] swap    = readSwap();
                final boolean chrg    = isCharging();
                final float bat       = chrg ? 0f : readBattery();
                final int batTmp      = readBatTemp();
                final float fps       = readFps();
                final int[] coreMhz   = readCoreMhz();

                handler.post(new Runnable() {
                    @Override public void run() {
                        if (!isAttachedToWindow()) return;
                        if (tvApi != null)    tvApi.setText(api);
                        if (tvTime != null)   tvTime.setText(timeStr);
                        if (tvCpu != null)    tvCpu.setText("CPU " + cpu + "%");
                        if (tvCpuTmp != null) tvCpuTmp.setText("/" + cpuTmp + "°C");
                        if (tvGpu != null)    tvGpu.setText("GPU " + gpu + "%");
                        if (tvGpuTmp != null) tvGpuTmp.setText("/" + gpuTmp + "°C");
                        if (tvGpuMhz != null) tvGpuMhz.setText("GPU " + gpuMhz + "MHz");
                        if (tvRam != null)    tvRam.setText("RAM " + ram + "%");
                        if (tvSwap != null)   tvSwap.setText(
                                String.format("SWP %.1f/%.1fG", swap[0], swap[1]));
                        if (tvBat != null) {
                            tvBat.setText(chrg ? "CHRG" : String.format("BAT %.1fW", bat));
                        }
                        if (tvBatTmp != null) tvBatTmp.setText("/" + batTmp + "°C");
                        if (tvFps != null)    tvFps.setText(
                                fps > 0 ? String.format("FPS %.0f", fps) : "FPS --");
                        if (fpsGraph != null) fpsGraph.push(fps);
                        if (tvCores != null && coreMhz != null) {
                            for (int i = 0; i < 8 && i < coreMhz.length; i++) {
                                if (tvCores[i] != null)
                                    tvCores[i].setText(
                                            String.format("C%d:%4d", i, coreMhz[i]));
                            }
                        }
                    }
                });

                Thread.sleep(1000);
            } catch (InterruptedException e) {
                break;
            } catch (Exception ignored) {}
        }
    }

    // ── Stat readers ──────────────────────────────────────────────────────

    private String readApiName() {
        if (activity == null) return "API";
        try {
            Field gField = activity.getClass().getDeclaredField("g");
            gField.setAccessible(true);
            Object binding = gField.get(activity);
            if (binding == null) return "API";
            Field hudLayerField = binding.getClass().getDeclaredField("hudLayer");
            hudLayerField.setAccessible(true);
            Object hudLayer = hudLayerField.get(binding);
            if (hudLayer == null) return "API";
            Field bField = hudLayer.getClass().getDeclaredField("b");
            bField.setAccessible(true);
            Object unifiedHud = bField.get(hudLayer);
            if (unifiedHud == null) return "API";
            Field aField = unifiedHud.getClass().getDeclaredField("a");
            aField.setAccessible(true);
            Object nameObj = aField.get(unifiedHud);
            if (nameObj == null) return "API";
            String name = nameObj.toString().trim();
            return name.isEmpty() || name.equals("N/A") ? "API" : name;
        } catch (Exception e) { return "API"; }
    }

    private float readFps() {
        if (activity == null) return 0f;
        try {
            Field jField = activity.getClass().getField("j");
            Object provider = jField.get(activity);
            if (provider == null) return 0f;
            Method getA = provider.getClass().getMethod("a");
            Object result = getA.invoke(provider);
            return result == null ? 0f : (float) result;
        } catch (Exception e) { return 0f; }
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
        if (v != null) {
            try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); }
            catch (NumberFormatException ignored) {}
        }
        v = readSysfsLine("/sys/class/misc/mali0/device/utilisation");
        if (v != null) {
            try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); }
            catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    private int readCpu() {
        String line = readSysfsLine("/proc/stat");
        if (line == null || !line.startsWith("cpu ")) return 0;
        String[] parts = line.trim().split("\\s+");
        if (parts.length < 5) return 0;
        try {
            long user = Long.parseLong(parts[1]), nice = Long.parseLong(parts[2]);
            long sys  = Long.parseLong(parts[3]), idle = Long.parseLong(parts[4]);
            long iowait = parts.length > 5 ? Long.parseLong(parts[5]) : 0;
            long total = user + nice + sys + idle + iowait;
            long diffTotal = total - prevTotal, diffIdle = (idle + iowait) - prevIdle;
            prevTotal = total; prevIdle = idle + iowait;
            return diffTotal <= 0 ? 0 : (int)(100L * (diffTotal - diffIdle) / diffTotal);
        } catch (NumberFormatException e) { return 0; }
    }

    private int readRam() {
        ActivityManager am = (ActivityManager)
                getContext().getSystemService(Context.ACTIVITY_SERVICE);
        if (am == null) return 0;
        ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();
        am.getMemoryInfo(mi);
        return mi.totalMem <= 0 ? 0 : (int)(100L * (mi.totalMem - mi.availMem) / mi.totalMem);
    }

    /** Returns [usedGB, totalGB] from /proc/meminfo SwapTotal/SwapFree. */
    private float[] readSwap() {
        long swapTotal = 0, swapFree = 0;
        try (BufferedReader br = new BufferedReader(new FileReader("/proc/meminfo"))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith("SwapTotal:"))      swapTotal = parseMeminfoKb(line);
                else if (line.startsWith("SwapFree:"))  swapFree  = parseMeminfoKb(line);
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

    private boolean isCharging() {
        try {
            Intent intent = getContext().registerReceiver(
                    null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            if (intent == null) return false;
            int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
            return status == BatteryManager.BATTERY_STATUS_CHARGING
                    || status == BatteryManager.BATTERY_STATUS_FULL;
        } catch (Exception e) { return false; }
    }

    private float readBattery() {
        try {
            BatteryManager bm = (BatteryManager)
                    getContext().getSystemService(Context.BATTERY_SERVICE);
            if (bm == null) return 0f;
            long currentNow = bm.getLongProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW);
            if (currentNow == Long.MIN_VALUE) return 0f;
            float voltage = 3.7f;
            String voltStr = readSysfsLine("/sys/class/power_supply/battery/voltage_now");
            if (voltStr != null) {
                try { voltage = Float.parseFloat(voltStr.trim()) / 1_000_000f; }
                catch (NumberFormatException ignored) {}
            }
            float currentA = Math.abs(currentNow) / 1_000_000f;
            if (currentA < 0.01f) currentA = Math.abs(currentNow) / 1_000f;
            return voltage * currentA;
        } catch (Exception e) { return 0f; }
    }

    private int readBatTemp() {
        String v = readSysfsLine("/sys/class/power_supply/battery/temp");
        if (v != null) {
            try { return Integer.parseInt(v.trim()) / 10; }
            catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    private int readCpuTemp() {
        // Scan thermal zones for CPU cluster
        String[] cpuTypes = {"cpu-cluster0", "cpu0-thermal", "cpu-thermal", "cpucluster", "cpu"};
        for (int z = 0; z < 20; z++) {
            String type = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/type");
            if (type == null) continue;
            String tl = type.trim().toLowerCase();
            for (String t : cpuTypes) {
                if (tl.contains(t)) {
                    String temp = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/temp");
                    if (temp != null) {
                        try {
                            int val = Integer.parseInt(temp.trim());
                            return val > 1000 ? val / 1000 : val;
                        } catch (NumberFormatException ignored) {}
                    }
                }
            }
        }
        // Fallback: thermal_zone0
        String v = readSysfsLine("/sys/class/thermal/thermal_zone0/temp");
        if (v != null) {
            try { int t = Integer.parseInt(v.trim()); return t > 1000 ? t / 1000 : t; }
            catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    private int readGpuTemp() {
        // Adreno direct sysfs
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/temp");
        if (v != null) {
            try {
                int t = Integer.parseInt(v.trim());
                return t > 1000 ? t / 1000 : t;
            } catch (NumberFormatException ignored) {}
        }
        // Scan thermal zones for GPU type
        String[] gpuTypes = {"gpuss-0", "gpuss", "gpu-thermal", "gpu"};
        for (int z = 0; z < 20; z++) {
            String type = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/type");
            if (type == null) continue;
            String tl = type.trim().toLowerCase();
            for (String t : gpuTypes) {
                if (tl.contains(t)) {
                    String temp = readSysfsLine("/sys/class/thermal/thermal_zone" + z + "/temp");
                    if (temp != null) {
                        try {
                            int val = Integer.parseInt(temp.trim());
                            return val > 1000 ? val / 1000 : val;
                        } catch (NumberFormatException ignored) {}
                    }
                }
            }
        }
        return 0;
    }

    private int readGpuMhz() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpuclk");
        if (v != null) {
            try { return (int)(Long.parseLong(v.trim()) / 1_000_000L); }
            catch (NumberFormatException ignored) {}
        }
        v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/clock_mhz");
        if (v != null) {
            try { return Integer.parseInt(v.trim()); }
            catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    private int[] readCoreMhz() {
        int[] result = new int[8];
        for (int i = 0; i < 8; i++) {
            String v = readSysfsLine(
                    "/sys/devices/system/cpu/cpu" + i + "/cpufreq/scaling_cur_freq");
            if (v != null) {
                try { result[i] = Integer.parseInt(v.trim()) / 1000; }
                catch (NumberFormatException ignored) {}
            }
        }
        return result;
    }

    private String readSysfsLine(String path) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            return br.readLine();
        } catch (IOException e) { return null; }
    }

    // ── FPS Graph ─────────────────────────────────────────────────────────

    private static class FpsGraphView extends View {
        private static final int HISTORY = 30;
        private final float[] samples = new float[HISTORY];
        private int head = 0, count = 0;
        private final Paint barPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        private final Paint bgPaint  = new Paint();

        public FpsGraphView(Context ctx) {
            super(ctx);
            bgPaint.setColor(0x44000000);
        }

        public void push(float fps) {
            samples[head] = fps;
            head = (head + 1) % HISTORY;
            if (count < HISTORY) count++;
            invalidate();
        }

        @Override
        protected void onDraw(Canvas canvas) {
            int w = getWidth(), h = getHeight();
            canvas.drawRect(0, 0, w, h, bgPaint);
            if (count == 0) return;
            float max = 1f;
            for (int i = 0; i < count; i++) if (samples[i] > max) max = samples[i];
            float barW = (float) w / HISTORY;
            for (int i = 0; i < count; i++) {
                int idx = (head - count + i + HISTORY) % HISTORY;
                float fps = samples[idx], barH = (fps / max) * h, ratio = fps / max;
                barPaint.setColor(Color.rgb(
                        (int)(255 * (1f - ratio)), (int)(255 * ratio), 0));
                canvas.drawRect(i * barW, h - barH, (i + 1) * barW - 1f, h, barPaint);
            }
        }
    }
}
