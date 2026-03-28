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
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Winlator-style compact HUD overlay bar.
 * Shows: API | GPU | CPU | RAM | BAT (hidden when charging) | TMP | FPS [graph]
 * Tap to toggle between horizontal bar and vertical column.
 * "Extra Detailed" pref (hud_extra_detail) adds per-core MHz, GPU model/freq/temp,
 * RAM GB, SWAP, and TIME — only visible in vertical mode.
 */
public class BhFrameRating extends LinearLayout implements Runnable {

    private final TextView tvApi, tvGpu, tvCpu, tvRam, tvBat, tvTmp, tvFps;
    private final FpsGraphView fpsGraph;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final Activity activity;
    private final List<View> sepViews = new ArrayList<>();

    // Extra detail group
    private final LinearLayout extraDetailGroup;
    private final TextView tvCpuCores, tvGpuInfo, tvGpuTemp, tvRamDetail, tvSwap, tvTime;
    private boolean extraDetail = false;

    // CPU stat tracking across samples
    private long prevTotal = 0, prevIdle = 0;

    private volatile boolean running = false;

    // Drag state
    private float dragLastX, dragLastY;
    private float dragStartX, dragStartY;
    private boolean dragMoved;

    // Orientation toggle
    private boolean isVertical = false;

    public BhFrameRating(Context ctx) {
        super(ctx);
        this.activity = ctx instanceof Activity ? (Activity) ctx : null;
        setOrientation(HORIZONTAL);
        setBackgroundColor(0xCC000000); // semi-transparent black
        setPadding(16, 8, 16, 8);

        // API name at far left (purple)
        tvApi = addLabel(ctx, "API", 0xFFCE93D8);
        sepViews.add(addSep(ctx));
        tvGpu = addLabel(ctx, "GPU --%", 0xFFFFAB91);
        sepViews.add(addSep(ctx));
        tvCpu = addLabel(ctx, "CPU --%", 0xFFFFFFFF);
        sepViews.add(addSep(ctx));
        tvRam = addLabel(ctx, "RAM --%", 0xFF90CAF9);
        sepViews.add(addSep(ctx));
        tvBat = addLabel(ctx, "BAT --W", 0xFFFFD54F);
        sepViews.add(addSep(ctx));
        tvTmp = addLabel(ctx, "TMP --\u00b0C", 0xFFEF9A9A);
        sepViews.add(addSep(ctx));
        tvFps = addLabel(ctx, "FPS --", 0xFF76FF03);

        // FPS graph at far right
        fpsGraph = new FpsGraphView(ctx);
        LinearLayout.LayoutParams gp = new LinearLayout.LayoutParams(
                dpToPx(ctx, 60), ViewGroup.LayoutParams.MATCH_PARENT);
        gp.gravity = Gravity.CENTER_VERTICAL;
        gp.leftMargin = dpToPx(ctx, 6);
        addView(fpsGraph, gp);

        // Extra detail group — vertical sub-layout, shown only in vertical mode when pref is on
        extraDetailGroup = new LinearLayout(ctx);
        extraDetailGroup.setOrientation(VERTICAL);
        extraDetailGroup.setVisibility(GONE);

        // Thin divider between main stats and extra detail
        View divider = new View(ctx);
        divider.setBackgroundColor(0xFF333333);
        LinearLayout.LayoutParams divLp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, dpToPx(ctx, 1));
        divLp.topMargin = dpToPx(ctx, 4);
        divLp.bottomMargin = dpToPx(ctx, 4);
        extraDetailGroup.addView(divider, divLp);

        tvTime     = addExtraLabel(ctx, "TIME --:--", 0xFFFFFFFF);
        tvCpuCores = addExtraLabel(ctx, "C0:--\nC1:--\nC2:--\nC3:--\nC4:--\nC5:--\nC6:--\nC7:--", 0xFFFFFFFF);
        tvGpuInfo  = addExtraLabel(ctx, "--\n--MHz", 0xFFFFAB91);
        tvGpuTemp  = addExtraLabel(ctx, "TMP --\u00b0C", 0xFFEF9A9A);
        tvRamDetail= addExtraLabel(ctx, "RAM --G / --G", 0xFF90CAF9);
        tvSwap     = addExtraLabel(ctx, "SW --/--G", 0xFFB39DDB);

        LinearLayout.LayoutParams egLp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        addView(extraDetailGroup, egLp);

        // Drag to reposition; tap (no significant move) to toggle orientation
        setOnTouchListener(new OnTouchListener() {
            private static final int TAP_SLOP = 10; // px
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) v.getLayoutParams();
                if (lp == null) return false;
                switch (event.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        if (lp.gravity != 0) {
                            lp.gravity = 0;
                            lp.leftMargin = v.getLeft();
                            lp.topMargin = v.getTop();
                            v.setLayoutParams(lp);
                        }
                        dragLastX = event.getRawX();
                        dragLastY = event.getRawY();
                        dragStartX = event.getRawX();
                        dragStartY = event.getRawY();
                        dragMoved = false;
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        float mx = event.getRawX() - dragStartX;
                        float my = event.getRawY() - dragStartY;
                        if (!dragMoved && (Math.abs(mx) > TAP_SLOP || Math.abs(my) > TAP_SLOP)) {
                            dragMoved = true;
                        }
                        int dx = (int) (event.getRawX() - dragLastX);
                        int dy = (int) (event.getRawY() - dragLastY);
                        lp.leftMargin += dx;
                        lp.topMargin += dy;
                        // Clamp so overlay never overflows screen edges
                        int screenW = v.getRootView().getWidth();
                        int screenH = v.getRootView().getHeight();
                        if (lp.leftMargin < 0) lp.leftMargin = 0;
                        if (lp.topMargin < 0) lp.topMargin = 0;
                        if (lp.leftMargin + v.getWidth() > screenW)
                            lp.leftMargin = screenW - v.getWidth();
                        if (lp.topMargin + v.getHeight() > screenH)
                            lp.topMargin = screenH - v.getHeight();
                        v.setLayoutParams(lp);
                        dragLastX = event.getRawX();
                        dragLastY = event.getRawY();
                        return true;
                    case MotionEvent.ACTION_UP:
                        if (!dragMoved) {
                            toggleOrientation();
                        }
                        return true;
                }
                return false;
            }
        });
    }

    private TextView addLabel(Context ctx, String text, int color) {
        TextView tv = new TextView(ctx);
        tv.setText(text);
        tv.setTextColor(color);
        tv.setTextSize(10f);
        tv.setPadding(4, 0, 4, 0);
        tv.setTypeface(Typeface.MONOSPACE);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_VERTICAL;
        addView(tv, lp);
        return tv;
    }

    /** Returns the separator view so callers can save a reference if needed. */
    private View addSep(Context ctx) {
        TextView tv = new TextView(ctx);
        tv.setText(" | ");
        tv.setTextColor(0xFF555555);
        tv.setTextSize(10f);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_VERTICAL;
        addView(tv, lp);
        return tv;
    }

    /** Adds a label row to the extra detail group. */
    private TextView addExtraLabel(Context ctx, String text, int color) {
        TextView tv = new TextView(ctx);
        tv.setText(text);
        tv.setTextColor(color);
        tv.setTextSize(9f);
        tv.setPadding(4, 2, 4, 2);
        tv.setTypeface(Typeface.MONOSPACE);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);
        extraDetailGroup.addView(tv, lp);
        return tv;
    }

    private int dpToPx(Context ctx, int dp) {
        return Math.round(dp * ctx.getResources().getDisplayMetrics().density);
    }

    private void toggleOrientation() {
        isVertical = !isVertical;
        setOrientation(isVertical ? VERTICAL : HORIZONTAL);

        // Restore WRAP_CONTENT width in both modes — vertical content (2-per-row cores,
        // trimmed labels) naturally sets the narrow width we want.
        ViewGroup.LayoutParams flp = getLayoutParams();
        if (flp != null) {
            flp.width = ViewGroup.LayoutParams.WRAP_CONTENT;
            setLayoutParams(flp);
        }

        // Show/hide " | " separators
        int sepVis = isVertical ? GONE : VISIBLE;
        for (View sep : sepViews) {
            sep.setVisibility(sepVis);
        }

        // Resize FPS graph: horizontal = (60dp wide, MATCH_PARENT tall)
        //                   vertical   = (MATCH_PARENT wide, 40dp tall)
        LinearLayout.LayoutParams gp;
        if (isVertical) {
            gp = new LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, dpToPx(getContext(), 40));
            gp.topMargin = dpToPx(getContext(), 4);
        } else {
            gp = new LinearLayout.LayoutParams(
                    dpToPx(getContext(), 60), ViewGroup.LayoutParams.MATCH_PARENT);
            gp.gravity = Gravity.CENTER_VERTICAL;
            gp.leftMargin = dpToPx(getContext(), 6);
        }
        fpsGraph.setLayoutParams(gp);

        // Center labels in vertical mode
        int labelGravity = isVertical ? Gravity.CENTER_HORIZONTAL : Gravity.CENTER_VERTICAL;
        for (TextView tv : new TextView[]{tvApi, tvGpu, tvCpu, tvRam, tvBat, tvTmp, tvFps}) {
            LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) tv.getLayoutParams();
            lp.gravity = labelGravity;
            tv.setLayoutParams(lp);
        }

        // Extra detail group only visible in vertical mode when pref is on
        extraDetailGroup.setVisibility(extraDetail && isVertical ? VISIBLE : GONE);

        // Measure unconstrained NOW (all orientation/visibility changes already applied)
        // then fix margins before triggering layout — so FrameLayout's AT_MOST constraint
        // never clips the overlay.
        reclampPosition();
    }

    /** Measures unconstrained, corrects margins, then triggers a single layout pass. */
    private void reclampPosition() {
        ViewGroup.LayoutParams vlp = getLayoutParams();
        if (!(vlp instanceof FrameLayout.LayoutParams)) {
            requestLayout();
            return;
        }
        FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) vlp;
        int screenW = getRootView().getWidth();
        int screenH = getRootView().getHeight();
        if (screenW == 0 || screenH == 0) { requestLayout(); return; }
        // Measure with unconstrained height to get true natural dimensions.
        measure(
            MeasureSpec.makeMeasureSpec(screenW, MeasureSpec.AT_MOST),
            MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED)
        );
        int naturalW = getMeasuredWidth();
        int naturalH = getMeasuredHeight();
        if (lp.leftMargin < 0) lp.leftMargin = 0;
        if (lp.topMargin  < 0) lp.topMargin  = 0;
        if (lp.leftMargin + naturalW > screenW) lp.leftMargin = screenW - naturalW;
        if (lp.topMargin  + naturalH > screenH) lp.topMargin  = screenH - naturalH;
        setLayoutParams(lp); // triggers requestLayout internally
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        // Restore extra detail state from pref
        try {
            SharedPreferences sp = getContext().getSharedPreferences("bh_prefs", 0);
            extraDetail = sp.getBoolean("hud_extra_detail", false);
            extraDetailGroup.setVisibility(extraDetail && isVertical ? VISIBLE : GONE);
        } catch (Exception ignored) {}
        running = true;
        Thread t = new Thread(this, "BhFrameRating");
        t.setDaemon(true);
        t.start();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        running = false;
    }

    @Override
    public void run() {
        while (running) {
            try {
                final String api      = readApiName();
                final int gpu         = readGpu();
                final int cpu         = readCpu();
                final int ram         = readRam();
                final boolean charging = isCharging();
                final float bat        = charging ? 0f : readBattery();
                final int tmp         = readTemp();
                final float fps       = readFps();

                // Extra detail — only read when pref is on
                final boolean newExtra = getContext()
                        .getSharedPreferences("bh_prefs", 0)
                        .getBoolean("hud_extra_detail", false);
                final int[] coreMhz     = newExtra ? readCoreMhz() : null;
                final String gpuModel   = newExtra ? readGpuModel() : null;
                final int gpuMhz        = newExtra ? readGpuMhz() : 0;
                final int gpuThermal    = newExtra ? readGpuThermal() : 0;
                final float[] ramDetail = newExtra ? readRamDetail() : null;
                final String swapStr    = newExtra ? readSwap() : null;
                final String timeStr    = newExtra ? readTime() : null;

                handler.post(new Runnable() {
                    @Override public void run() {
                        if (!isAttachedToWindow()) return;

                        tvApi.setText(api);
                        tvGpu.setText("GPU " + gpu + "%");
                        tvCpu.setText("CPU " + cpu + "%");
                        tvRam.setText("RAM " + ram + "%");
                        if (charging) {
                            tvBat.setText("CHRG");
                        } else {
                            tvBat.setText(String.format("BAT %.1fW", bat));
                        }
                        tvTmp.setText("TMP " + tmp + "\u00b0C");
                        tvFps.setText(fps > 0 ? String.format("FPS %.0f", fps) : "FPS --");
                        fpsGraph.push(fps);

                        // Sync extra detail visibility if pref changed
                        if (newExtra != extraDetail) {
                            extraDetail = newExtra;
                            extraDetailGroup.setVisibility(
                                    extraDetail && isVertical ? VISIBLE : GONE);
                            // post so the visibility change is committed before we measure
                            handler.post(new Runnable() {
                                @Override public void run() { reclampPosition(); }
                            });
                        }

                        // Update extra detail rows (vertical mode only)
                        if (extraDetail && isVertical) {
                            if (coreMhz != null && coreMhz.length >= 8) {
                                tvCpuCores.setText(String.format(
                                        "C0:%4d\nC1:%4d\nC2:%4d\nC3:%4d\n" +
                                        "C4:%4d\nC5:%4d\nC6:%4d\nC7:%4d",
                                        coreMhz[0], coreMhz[1], coreMhz[2], coreMhz[3],
                                        coreMhz[4], coreMhz[5], coreMhz[6], coreMhz[7]));
                            }
                            String model = gpuModel != null ? gpuModel : "--";
                            tvGpuInfo.setText(model + "\n" + gpuMhz + "MHz");
                            tvGpuTemp.setText("TMP " + gpuThermal + "\u00b0C");
                            if (ramDetail != null && ramDetail.length >= 2) {
                                tvRamDetail.setText(String.format(
                                        "RAM %.1f/%.1fG", ramDetail[0], ramDetail[1]));
                            }
                            if (swapStr != null) tvSwap.setText(swapStr);
                            if (timeStr != null) tvTime.setText("TIME " + timeStr);
                        }
                    }
                });

                Thread.sleep(1000);
            } catch (InterruptedException e) {
                break;
            } catch (Exception ignored) {
            }
        }
    }

    // ── API name ─────────────────────────────────────────────────────────
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
            if (name.isEmpty() || name.equals("N/A")) return "API";
            return name;
        } catch (Exception e) {
            return "API";
        }
    }

    // ── Charging detection ────────────────────────────────────────────────
    private boolean isCharging() {
        try {
            Intent intent = getContext().registerReceiver(
                    null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            if (intent == null) return false;
            int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
            return status == BatteryManager.BATTERY_STATUS_CHARGING
                    || status == BatteryManager.BATTERY_STATUS_FULL;
        } catch (Exception e) {
            return false;
        }
    }

    // ── Data readers ─────────────────────────────────────────────────────

    private int readGpu() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpubusy");
        if (v != null) {
            try {
                String[] parts = v.trim().split("\\s+");
                if (parts.length >= 2) {
                    long busy  = Long.parseLong(parts[0]);
                    long total = Long.parseLong(parts[1]);
                    if (total > 0) return (int) (100L * busy / total);
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
            long user   = Long.parseLong(parts[1]);
            long nice   = Long.parseLong(parts[2]);
            long sys    = Long.parseLong(parts[3]);
            long idle   = Long.parseLong(parts[4]);
            long iowait = parts.length > 5 ? Long.parseLong(parts[5]) : 0;
            long total  = user + nice + sys + idle + iowait;
            long diffTotal = total - prevTotal;
            long diffIdle  = (idle + iowait) - prevIdle;
            prevTotal = total;
            prevIdle  = idle + iowait;
            if (diffTotal <= 0) return 0;
            return (int) (100L * (diffTotal - diffIdle) / diffTotal);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private int readRam() {
        ActivityManager am = (ActivityManager)
                getContext().getSystemService(Context.ACTIVITY_SERVICE);
        if (am == null) return 0;
        ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();
        am.getMemoryInfo(mi);
        if (mi.totalMem <= 0) return 0;
        return (int) (100L * (mi.totalMem - mi.availMem) / mi.totalMem);
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
        } catch (Exception e) {
            return 0f;
        }
    }

    private int readTemp() {
        String v = readSysfsLine("/sys/class/power_supply/battery/temp");
        if (v != null) {
            try { return Integer.parseInt(v.trim()) / 10; }
            catch (NumberFormatException ignored) {}
        }
        v = readSysfsLine("/sys/class/thermal/thermal_zone0/temp");
        if (v != null) {
            try {
                int t = Integer.parseInt(v.trim());
                return t > 1000 ? t / 1000 : t;
            } catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    /** Reads FPS via WineActivity.j (HudDataProvider) field → a() method. */
    private float readFps() {
        if (activity == null) return 0f;
        try {
            Field jField = activity.getClass().getField("j");
            Object provider = jField.get(activity);
            if (provider == null) return 0f;
            Method getA = provider.getClass().getMethod("a");
            Object result = getA.invoke(provider);
            return result == null ? 0f : (float) result;
        } catch (Exception e) {
            return 0f;
        }
    }

    // ── Extra detail readers ──────────────────────────────────────────────

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

    private int readGpuMhz() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpuclk");
        if (v != null) {
            try { return (int) (Long.parseLong(v.trim()) / 1_000_000L); }
            catch (NumberFormatException ignored) {}
        }
        v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/clock_mhz");
        if (v != null) {
            try { return Integer.parseInt(v.trim()); }
            catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    private String readGpuModel() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpu_model");
        if (v != null) {
            return v.trim().replace("(TM)", "").replaceAll("\\s+", " ").trim();
        }
        return null;
    }

    private int readGpuThermal() {
        return readThermalZone("gpu");
    }

    private int readThermalZone(String typeName) {
        for (int i = 0; i < 30; i++) {
            String type = readSysfsLine("/sys/class/thermal/thermal_zone" + i + "/type");
            if (type != null && type.trim().equalsIgnoreCase(typeName)) {
                String temp = readSysfsLine("/sys/class/thermal/thermal_zone" + i + "/temp");
                if (temp != null) {
                    try {
                        int t = Integer.parseInt(temp.trim());
                        return t > 1000 ? t / 1000 : t;
                    } catch (NumberFormatException ignored) {}
                }
            }
        }
        return 0;
    }

    private float[] readRamDetail() {
        ActivityManager am = (ActivityManager)
                getContext().getSystemService(Context.ACTIVITY_SERVICE);
        if (am == null) return null;
        ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();
        am.getMemoryInfo(mi);
        float total = mi.totalMem / 1_073_741_824f;
        float used  = (mi.totalMem - mi.availMem) / 1_073_741_824f;
        return new float[]{used, total};
    }

    private String readSwap() {
        long swapTotal = 0, swapFree = 0;
        try (BufferedReader br = new BufferedReader(new FileReader("/proc/meminfo"))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith("SwapTotal:")) {
                    swapTotal = parseMemInfoKb(line);
                } else if (line.startsWith("SwapFree:")) {
                    swapFree = parseMemInfoKb(line);
                    break;
                }
            }
        } catch (IOException ignored) {}
        float total = swapTotal / (1024f * 1024f);
        float used  = (swapTotal - swapFree) / (1024f * 1024f);
        return String.format("SW %.1f/%.1fG", used, total);
    }

    private long parseMemInfoKb(String line) {
        try {
            String[] parts = line.trim().split("\\s+");
            return Long.parseLong(parts[1]);
        } catch (Exception e) {
            return 0;
        }
    }

    private String readTime() {
        return new SimpleDateFormat("HH:mm", Locale.getDefault()).format(new Date());
    }

    private String readSysfsLine(String path) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            return br.readLine();
        } catch (IOException e) {
            return null;
        }
    }

    // ── FPS Graph ─────────────────────────────────────────────────────────

    private static class FpsGraphView extends View {
        private static final int HISTORY = 30;
        private final float[] samples = new float[HISTORY];
        private int head = 0;
        private int count = 0;

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
            int w = getWidth();
            int h = getHeight();
            canvas.drawRect(0, 0, w, h, bgPaint);
            if (count == 0) return;

            float max = 1f;
            for (int i = 0; i < count; i++) {
                if (samples[i] > max) max = samples[i];
            }

            float barW = (float) w / HISTORY;
            for (int i = 0; i < count; i++) {
                int idx = (head - count + i + HISTORY) % HISTORY;
                float fps  = samples[idx];
                float barH = (fps / max) * h;
                float left = i * barW;
                float top  = h - barH;
                float ratio = fps / max;
                barPaint.setColor(Color.rgb(
                        (int) (255 * (1f - ratio)),
                        (int) (255 * ratio),
                        0));
                canvas.drawRect(left, top, left + barW - 1f, h, barPaint);
            }
        }
    }
}
