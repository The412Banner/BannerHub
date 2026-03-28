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

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * Winlator-style compact HUD overlay bar.
 * Shows: API | GPU | CPU | RAM | BAT (hidden when charging) | TMP | FPS [graph]
 * API name read from same SharedPreferences GameHub uses (pc_g_setting{gameId}).
 * FPS via WineActivity.j (HudDataProvider) field → a() method.
 * Charging detection via ACTION_BATTERY_CHANGED, same as HudDataProvider.b().
 * Tag: "bh_frame_rating"
 */
public class BhFrameRating extends LinearLayout implements Runnable {

    private final TextView tvApi, tvGpu, tvCpu, tvRam, tvBat, tvTmp, tvFps;
    private final View sepBat; // separator before BAT — hidden when charging
    private final FpsGraphView fpsGraph;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final Activity activity;

    // CPU stat tracking across samples
    private long prevTotal = 0, prevIdle = 0;

    private volatile boolean running = false;

    // Drag state
    private float dragLastX, dragLastY;

    public BhFrameRating(Context ctx) {
        super(ctx);
        this.activity = ctx instanceof Activity ? (Activity) ctx : null;
        setOrientation(HORIZONTAL);
        setBackgroundColor(0xCC000000); // semi-transparent black
        setPadding(16, 8, 16, 8);

        // API name at far left (purple)
        tvApi = addLabel(ctx, "API", 0xFFCE93D8);
        addSep(ctx);
        tvGpu = addLabel(ctx, "GPU --%", 0xFFFFAB91);
        addSep(ctx);
        tvCpu = addLabel(ctx, "CPU --%", 0xFFFFFFFF);
        addSep(ctx);
        tvRam = addLabel(ctx, "RAM --%", 0xFF90CAF9);
        // separator before BAT — saved so it can be hidden together with tvBat
        sepBat = addSep(ctx);
        tvBat = addLabel(ctx, "BAT --W", 0xFFFFD54F);
        addSep(ctx);
        tvTmp = addLabel(ctx, "TMP --\u00b0C", 0xFFEF9A9A);
        addSep(ctx);
        tvFps = addLabel(ctx, "FPS --", 0xFF76FF03);

        // FPS graph at far right
        fpsGraph = new FpsGraphView(ctx);
        LinearLayout.LayoutParams gp = new LinearLayout.LayoutParams(
                dpToPx(ctx, 60), ViewGroup.LayoutParams.MATCH_PARENT);
        gp.gravity = Gravity.CENTER_VERTICAL;
        gp.leftMargin = dpToPx(ctx, 6);
        addView(fpsGraph, gp);

        // Drag to reposition
        setOnTouchListener(new OnTouchListener() {
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
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        int dx = (int) (event.getRawX() - dragLastX);
                        int dy = (int) (event.getRawY() - dragLastY);
                        lp.leftMargin += dx;
                        lp.topMargin += dy;
                        v.setLayoutParams(lp);
                        dragLastX = event.getRawX();
                        dragLastY = event.getRawY();
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
        tv.setTextSize(11f);
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
        tv.setTextSize(11f);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_VERTICAL;
        addView(tv, lp);
        return tv;
    }

    private int dpToPx(Context ctx, int dp) {
        return Math.round(dp * ctx.getResources().getDisplayMetrics().density);
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
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

                handler.post(new Runnable() {
                    @Override public void run() {
                        if (!isAttachedToWindow()) return;
                        tvApi.setText(api);
                        tvGpu.setText("GPU " + gpu + "%");
                        tvCpu.setText("CPU " + cpu + "%");
                        tvRam.setText("RAM " + ram + "%");
                        if (charging) {
                            sepBat.setVisibility(GONE);
                            tvBat.setVisibility(GONE);
                        } else {
                            sepBat.setVisibility(VISIBLE);
                            tvBat.setVisibility(VISIBLE);
                            tvBat.setText(String.format("BAT %.1fW", bat));
                        }
                        tvTmp.setText("TMP " + tmp + "\u00b0C");
                        tvFps.setText(fps > 0 ? String.format("FPS %.0f", fps) : "FPS --");
                        fpsGraph.push(fps);
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
    // Reads from pc_g_setting{gameId} SharedPreferences, same source GameHub uses.
    // Keys: "pc_ls_DXVK" for DXVK, "pc_ls_VK3k" for VKD3D.
    // JSON structure mirrors PcSettingDataEntity — uses "displayName" if set, else "name".
    // Falls back to "WineD3D" when neither key is populated.

    private String readApiName() {
        if (activity == null) return "API";
        try {
            // WineActivity.u = WineActivityData; WineActivityData.a = gameId
            Field uField = activity.getClass().getDeclaredField("u");
            uField.setAccessible(true);
            Object wineData = uField.get(activity);
            if (wineData == null) return "API";
            Field aField = wineData.getClass().getDeclaredField("a");
            aField.setAccessible(true);
            Object gameIdObj = aField.get(wineData);
            if (gameIdObj == null) return "API";
            String gameId = gameIdObj.toString();

            SharedPreferences sp = activity.getSharedPreferences("pc_g_setting" + gameId, 0);

            // DXVK (key: "pc_ls_DXVK")
            String dxvkJson = sp.getString("pc_ls_DXVK", null);
            if (dxvkJson != null && !dxvkJson.isEmpty()) {
                String label = showName(dxvkJson);
                return label.isEmpty() ? "DXVK" : "DXVK " + label;
            }

            // VKD3D (key: "pc_ls_VK3k")
            String vkd3dJson = sp.getString("pc_ls_VK3k", null);
            if (vkd3dJson != null && !vkd3dJson.isEmpty()) {
                String label = showName(vkd3dJson);
                return label.isEmpty() ? "VKD3D" : "VKD3D " + label;
            }

            // Neither set — WineD3D (software renderer)
            return "WineD3D";
        } catch (Exception e) {
            return "API";
        }
    }

    /** Mirrors PcSettingDataEntity.getShowName(): displayName if non-empty, else name. */
    private String showName(String json) {
        try {
            JSONObject obj = new JSONObject(json);
            String display = obj.optString("displayName", "").trim();
            if (!display.isEmpty()) return display;
            return obj.optString("name", "").trim();
        } catch (Exception e) {
            return "";
        }
    }

    // ── Charging detection ────────────────────────────────────────────────
    // Uses ACTION_BATTERY_CHANGED sticky broadcast — same method as HudDataProvider.b().
    // Returns true when CHARGING or FULL so the BAT watts label is hidden.

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
        // Adreno: gpubusy format "busy total"
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
        // Adreno: gpu_busy_percentage
        v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage");
        if (v != null) {
            try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); }
            catch (NumberFormatException ignored) {}
        }
        // Mali
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

            // Voltage from sysfs (µV → V)
            float voltage = 3.7f;
            String voltStr = readSysfsLine("/sys/class/power_supply/battery/voltage_now");
            if (voltStr != null) {
                try { voltage = Float.parseFloat(voltStr.trim()) / 1_000_000f; }
                catch (NumberFormatException ignored) {}
            }

            // currentNow may be µA or mA depending on device
            float currentA = Math.abs(currentNow) / 1_000_000f; // assume µA
            if (currentA < 0.01f) currentA = Math.abs(currentNow) / 1_000f; // mA fallback
            return voltage * currentA;
        } catch (Exception e) {
            return 0f;
        }
    }

    private int readTemp() {
        // Battery temp (tenths of °C)
        String v = readSysfsLine("/sys/class/power_supply/battery/temp");
        if (v != null) {
            try { return Integer.parseInt(v.trim()) / 10; }
            catch (NumberFormatException ignored) {}
        }
        // CPU thermal zone0
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

    private String readSysfsLine(String path) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            return br.readLine();
        } catch (IOException e) {
            return null;
        }
    }

    // ── FPS Graph ─────────────────────────────────────────────────────────
    // 30-sample ring buffer, rendered as a bar chart.
    // Bar color shifts green → red based on how each sample compares to the
    // highest FPS seen in the current window (green = at max, red = near 0).

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

        /** Called from the update loop on the main thread. */
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

            // Scale bars relative to the max sample in the current window
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
                // green at max FPS, red near zero
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
