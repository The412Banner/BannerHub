package com.xj.winemu.audio;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;

/**
 * BhAudioController — per-game PulseAudio recording-compatible mode.
 *
 * Problem: GameHub's pulse sink (module-aaudio-sink) is loaded with no pm=
 * argument, so it opens its AAudio stream as LOW_LATENCY. On devices where
 * the framework grants that as an exclusive MMAP stream, playback bypasses
 * the AudioFlinger mixer entirely — and MediaProjection's
 * AudioPlaybackCapture taps the mixer, so Android screen recordings get
 * video but silent audio whenever the in-game audio driver is PulseAudio
 * (ALSA uses a legacy mixed AudioTrack and records fine).
 *
 * Fix: pass "pm=0" to module-aaudio-sink. The module computes
 * setPerformanceMode(pm + 10), so 0 → PERFORMANCE_MODE_NONE (10): the
 * stream stays on the normal mixer and becomes capturable, at a small
 * latency cost. NOTE the value is 0, not 10 — the module adds the 10.
 *
 * Wiring:
 *   - {@link #sinkLine()} is called from a smali patch in
 *     PulseAudioPlugin (com.winemu.core.server.environment.plugins) in
 *     place of the hardcoded "load-module module-aaudio-sink" line while
 *     the plugin generates pulseaudio's default.pa at container boot.
 *   - The per-game value lives in the stock pc_g_setting&lt;gameId&gt;
 *     SharedPreferences under {@link #KEY_RECORDING_MODE}, so
 *     BhSettingsExporter's Export/Import Config bundles carry it
 *     automatically (same trick as bh_vibration_*).
 *   - PulseAudioPlugin runs in the :wine process. The active gameId is
 *     recovered the same way BhVibrationController does it: walk
 *     ActivityThread.mActivities for the live WineActivity and read its
 *     "gameId" Intent extra (WineActivity runs in :wine too and is created
 *     before the container environment boots).
 *   - The pref is read straight from the shared_prefs XML file on disk
 *     rather than via getSharedPreferences(): the :wine process can
 *     outlive a launch, and a process-cached SharedPreferences would go
 *     stale when the user flips the toggle from the main process between
 *     launches.
 *
 * Any failure anywhere falls back to the stock line — worst case is stock
 * GameHub behavior, never a broken audio boot.
 */
public final class BhAudioController {

    private static final String TAG = "BhAudio";

    /** Stock default.pa sink line as built by PulseAudioPlugin. */
    public static final String STOCK_SINK_LINE = "load-module module-aaudio-sink";

    /** Recording-compatible variant (module adds +10 → PERFORMANCE_MODE_NONE). */
    public static final String RECORDING_SINK_LINE = "load-module module-aaudio-sink pm=0";

    /** Boolean key inside pc_g_setting<gameId>; exported/imported with the game config. */
    public static final String KEY_RECORDING_MODE = "bh_audio_recording_mode";

    private static final String PER_GAME_PREFS_FMT = "pc_g_setting%s";

    private BhAudioController() { }

    // ────────────────────────────────────────────────────────────────────
    // :wine-process side — called from the PulseAudioPlugin smali patch
    // ────────────────────────────────────────────────────────────────────

    /**
     * Returns the default.pa line to use for the AAudio sink. Called once
     * per PulseAudio boot. Never throws.
     */
    public static String sinkLine() {
        try {
            String gameId = resolveActiveGameId();
            if (gameId == null || gameId.isEmpty()) {
                Log.i(TAG, "sinkLine: no active gameId resolved, using stock sink line");
                return STOCK_SINK_LINE;
            }
            boolean recording = readRecordingModeFromDisk(gameId);
            Log.i(TAG, "sinkLine: gameId=" + gameId + " recordingMode=" + recording);
            return recording ? RECORDING_SINK_LINE : STOCK_SINK_LINE;
        } catch (Throwable t) {
            Log.w(TAG, "sinkLine: falling back to stock sink line", t);
            return STOCK_SINK_LINE;
        }
    }

    /**
     * Walks the live-activity table for the running WineActivity and pulls
     * its "gameId" Intent extra (same technique as
     * BhVibrationController.maybeResolveContainerFromActivityStack — proven
     * on-device). WineActivity.onCreate runs well before the container
     * environment (and thus PulseAudioPlugin) boots, so by the time
     * sinkLine() is called the activity is in mActivities.
     */
    private static String resolveActiveGameId() {
        try {
            Class<?> atCls = Class.forName("android.app.ActivityThread");
            Method cur = atCls.getMethod("currentActivityThread");
            Object at = cur.invoke(null);
            if (at == null) return null;
            Field fActs = atCls.getDeclaredField("mActivities");
            fActs.setAccessible(true);
            Object acts = fActs.get(at);
            if (!(acts instanceof Map)) return null;
            for (Object recordObj : ((Map<?, ?>) acts).values()) {
                if (recordObj == null) continue;
                Field fAct = recordObj.getClass().getDeclaredField("activity");
                fAct.setAccessible(true);
                Object activity = fAct.get(recordObj);
                if (!(activity instanceof Activity)) continue;
                if (!activity.getClass().getName().endsWith(".WineActivity")) continue;
                Intent it = ((Activity) activity).getIntent();
                if (it == null) continue;
                String gid = it.getStringExtra("gameId");
                if (gid != null && !gid.isEmpty()) return gid;
            }
        } catch (Throwable ignored) { }
        return null;
    }

    /**
     * Reads KEY_RECORDING_MODE for a game directly from the shared_prefs
     * XML on disk so the value is always fresh across processes. The file
     * is written by the settings dialog in the main process with commit().
     */
    private static boolean readRecordingModeFromDisk(String gameId) {
        Context ctx = currentApplication();
        if (ctx == null) return false;
        File f = new File(ctx.getApplicationInfo().dataDir,
                "shared_prefs/" + String.format(PER_GAME_PREFS_FMT, gameId) + ".xml");
        if (!f.isFile()) return false;
        BufferedReader r = null;
        try {
            r = new BufferedReader(new InputStreamReader(new FileInputStream(f), "UTF-8"));
            String line;
            while ((line = r.readLine()) != null) {
                if (line.contains("\"" + KEY_RECORDING_MODE + "\"")) {
                    return line.contains("value=\"true\"");
                }
            }
        } catch (Throwable ignored) {
        } finally {
            if (r != null) try { r.close(); } catch (Throwable ignored) { }
        }
        return false;
    }

    private static Context currentApplication() {
        try {
            Class<?> atCls = Class.forName("android.app.ActivityThread");
            Method m = atCls.getMethod("currentApplication");
            Object app = m.invoke(null);
            if (app instanceof Application) return (Application) app;
        } catch (Throwable ignored) { }
        return null;
    }

    // ────────────────────────────────────────────────────────────────────
    // Main-process side — used by BhAudioSettingsActivity
    // ────────────────────────────────────────────────────────────────────

    public static boolean isRecordingMode(Context ctx, String gameId) {
        if (ctx == null || gameId == null || gameId.isEmpty()) return false;
        SharedPreferences sp = ctx.getSharedPreferences(
                String.format(PER_GAME_PREFS_FMT, gameId), Context.MODE_PRIVATE);
        return sp.getBoolean(KEY_RECORDING_MODE, false);
    }

    /** commit() (not apply()) so the XML hits disk before any game launch. */
    public static void setRecordingMode(Context ctx, String gameId, boolean recording) {
        if (ctx == null || gameId == null || gameId.isEmpty()) return;
        ctx.getSharedPreferences(String.format(PER_GAME_PREFS_FMT, gameId), Context.MODE_PRIVATE)
                .edit()
                .putBoolean(KEY_RECORDING_MODE, recording)
                .commit();
        Log.i(TAG, "setRecordingMode: gameId=" + gameId + " → " + recording);
    }
}
