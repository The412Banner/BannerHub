package com.xj.winemu.vibration;

import android.content.Context;
import android.content.SharedPreferences;
import android.media.AudioAttributes;
import android.os.Build;
import android.os.CombinedVibration;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.SystemClock;
import android.os.VibrationAttributes;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.os.VibratorManager;
import android.util.Log;
import android.view.InputDevice;

import android.os.FileObserver;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicIntegerArray;
import java.util.concurrent.atomic.AtomicLongArray;

/**
 * BhVibrationController — PC-accurate XInput rumble dispatcher.
 *
 * Ported from GameNative PR #1214 (Fix-Vibration, TideGear).
 *
 * Pipeline entry points (called from smali patches):
 *   - onRumble(slot, low, high): rumble callback from the native gamepad server,
 *     invoked by GamepadServerManager$onRumble(III)V.
 *   - dispatchToController(deviceId, low, high): per-device dispatch, invoked at
 *     the head of GamepadDevice$Physical.h(II)V. Returns true to short-circuit
 *     the stock dispatch (which lacks amplitude-control checks, VibrationAttributes,
 *     and CombinedVibration.startParallel).
 *   - scheduleWakeup(serverManager, slot): post-connect wake-up, invoked at the
 *     head of GamepadManager.B0(GamepadConnectionEvent)V. Queues a synthetic
 *     button-14 press/release on the slot's GamepadState — libvfs's poller
 *     sees the button-byte change and emits SDL_JOYDEVICEADDED, which lets
 *     winebus open the joystick BEFORE the user has pressed anything
 *     (otherwise rumble silently no-ops on freshly-connected controllers in
 *     multi-controller setups until each is "activated" by an input event).
 *     Wake-ups are gated on a winedevice readiness marker written by libevshim
 *     and staggered 200 ms per slot ascending so libvfs has time to register
 *     each before the next stimulus arrives.
 *
 * Modes:
 *   0 = Off         — no rumble anywhere
 *   1 = Controller  — dispatch to controller vibrator only (stock GameHub behaviour+)
 *   2 = Device      — dispatch aggregated rumble to phone's built-in vibrator
 *   3 = Both        — dispatch to both controller and device
 */
public final class BhVibrationController {

    private static final String TAG = "BhVibration";

    public static final int MODE_OFF = 0;
    public static final int MODE_CONTROLLER = 1;
    public static final int MODE_DEVICE = 2;
    public static final int MODE_BOTH = 3;

    // Storage scheme:
    //   - Per-game settings live in stock GameHub's pc_g_setting<gameId>
    //     SharedPreferences file under PER_GAME_KEY_* keys. This is the
    //     same file BhSettingsExporter reads/writes during Export Config /
    //     Import Config, so per-game vibration settings round-trip
    //     automatically with no exporter changes. gameId here is the
    //     same string GameDetailEntity exposes to the rest of the
    //     codebase (numeric catalog id like "271590", or "local_<uuid>"
    //     for locally-added games).
    //   - Global defaults live in our own bh_vibration_prefs file under
    //     GLOBAL_KEY_*. Used when a per-game value is absent (older
    //     pc_g_setting files lacking our keys, or when running outside
    //     a Wine session). New keys default to DEFAULT_MODE/INTENSITY,
    //     so older imports without bh_vibration_* keys behave exactly
    //     as before.
    public static final String GLOBAL_PREFS_FILE  = "bh_vibration_prefs";
    public static final String PER_GAME_PREFS_FMT = "pc_g_setting%s";
    public static final String PER_GAME_KEY_MODE      = "bh_vibration_mode";
    public static final String PER_GAME_KEY_INTENSITY = "bh_vibration_intensity";
    public static final String GLOBAL_KEY_MODE      = "mode";
    public static final String GLOBAL_KEY_INTENSITY = "intensity";

    // Legacy. Older builds wrote per-container settings to
    // bh_vibration_prefs with these prefixed keys (e.g. "mode_271590").
    // We still READ them as a one-time fallback when the new pc_g_setting
    // location has no value, but never write to them again.
    private static final String LEGACY_MODE_PREFIX      = "mode_";
    private static final String LEGACY_INTENSITY_PREFIX = "intensity_";

    // Stock behaviour: controller-on, full intensity. User can disable per container.
    private static final int DEFAULT_MODE = MODE_CONTROLLER;
    private static final int DEFAULT_INTENSITY = 100;

    // Compile-time flag: when false, R8 strips logGuestTransition's body
    // and the diagPrev* arrays drop to dead state. Multi-controller +
    // 3+ slot wake-up validated, so default to false for ship builds —
    // flip back to true if reproducing a regression locally.
    private static final boolean DIAG = false;

    /** Per-dispatch / per-state-change diagnostic log. Compiled out when
     *  DIAG is false (R8 inlines and dead-codes the body). Use this for
     *  logs that fire at gameplay rate — keep Log.i for one-shot lifecycle
     *  events (controller connect, settings change, etc.) so support still
     *  has visibility on those even in stripped release builds. */
    private static void dlog(String msg) {
        if (DIAG) Log.i(TAG, msg);
    }

    // XInput slots count (matches GamepadServerManager's slot range 0..3)
    private static final int MAX_SLOTS = 4;

    // Duration constants (ms). Controller effects are long enough that keepalive
    // refresh doesn't produce audible seams; device effects are shorter so the
    // phone's haptic feedback stays crisp.
    private static final long CONTROLLER_RUMBLE_MS = 2000L;
    private static final long DEVICE_RUMBLE_MS = 180L;
    private static final long DEVICE_RUMBLE_REFRESH_MS = 140L; // < DEVICE_RUMBLE_MS
    private static final long RUMBLE_KEEPALIVE_MS = 1500L;     // refresh controller before 2s expiry

    private static volatile BhVibrationController INSTANCE;

    public static BhVibrationController getInstance() {
        BhVibrationController local = INSTANCE;
        if (local == null) {
            synchronized (BhVibrationController.class) {
                local = INSTANCE;
                if (local == null) {
                    local = new BhVibrationController();
                    INSTANCE = local;
                }
            }
        }
        return local;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // State
    // ─────────────────────────────────────────────────────────────────────────

    private volatile Context appContext;
    /** String game identifier matching what GameDetailEntity exposes
     *  ({@code "271590"} for catalog games, {@code "local_<uuid>"} for
     *  locally-added games). null = no Wine session resolved yet, use
     *  global defaults. */
    private volatile String containerGameId = null;
    private volatile int cachedMode = DEFAULT_MODE;
    private volatile int cachedIntensity = DEFAULT_INTENSITY;

    private final HandlerThread workerThread;
    private final Handler worker;

    // Device-side (phone) aggregation: per-slot last rumble amplitudes.
    //
    // These are written on the gameplay/dispatch thread (handleRumble) and
    // read on the worker thread (dispatchDevice, refreshDeviceRumble,
    // keepaliveRunnable). Plain int[]/long[] don't guarantee visibility
    // across threads on the JVM, and long[] reads/writes can tear on 32-bit
    // ARM. Atomic{Integer,Long}Array gives us per-slot volatile semantics
    // without coarse-grained locking.
    private final AtomicIntegerArray slotLow = new AtomicIntegerArray(MAX_SLOTS);
    private final AtomicIntegerArray slotHigh = new AtomicIntegerArray(MAX_SLOTS);
    private final AtomicLongArray slotStamp = new AtomicLongArray(MAX_SLOTS);

    // Diagnostic-only state: tracks the LAST guest frame regardless of mode so
    // the auto-expiry trace works in any mode and isn't perturbed by MODE_OFF
    // skipping the dispatch-state update. See logGuestTransition. Single-thread
    // (dispatch thread only) so plain arrays are fine here.
    private final int[] diagPrevLow = new int[MAX_SLOTS];
    private final int[] diagPrevHigh = new int[MAX_SLOTS];
    private final long[] diagPrevWhen = new long[MAX_SLOTS];

    // Controller keepalive state: per deviceId, last dispatched (low, high, when).
    private final Map<Integer, long[]> controllerKeepalive = new HashMap<>();

    // PHANTOM SUPPRESSION REMOVED.
    //
    // Earlier builds of this controller suppressed any (0,0) arriving in a
    // [950, 1050] ms window after the previous non-zero — the signature of
    // SDL2's internal 1 s rumble auto-expiry. With the libevshim guest-side
    // shim now patching winebus.so's pSDL_JoystickRumble pointer to our
    // wrapper, the keepalive thread re-issues the active rumble every 500 ms
    // with a 2 s duration, which resets SDL2's internal rumble_expiration on
    // every call (SDL2 updates the timer even when low/high are unchanged).
    // The phantom can no longer fire, so suppressing in this window only
    // produced false positives on legitimate ~1 s game-driven holds (e.g.
    // a 1.05 s press registered as gap=1050 ms → host suppresses for another
    // 1 s = ~2 s of rumble for a 1 s press). PC-accurate behavior is to
    // trust every (0,0) as a real game release and stop instantly.
    //
    // The DIAG line still tags the [900, 1200] ms window as
    // "[SDL_AUTO_EXPIRY?]" for telemetry — useful if the keepalive ever
    // breaks again — but no functional path branches on it.

    // Last device-effect time so we don't overwhelm phone vibrator.
    private volatile long lastDeviceDispatch = 0L;
    private volatile boolean deviceActive = false;

    private final Runnable keepaliveRunnable = new Runnable() {
        @Override
        public void run() {
            try {
                long now = SystemClock.uptimeMillis();

                // Controller side: refresh any active controller whose last dispatch
                // is older than KEEPALIVE threshold and whose amplitude is non-zero.
                //
                // Snapshot the entries that need refreshing under the lock, then
                // release the lock before issuing dispatchControllerInternal — the
                // underlying VibratorManager.vibrate() is a binder call (~ms IPC
                // latency) and holding the keepalive lock across it would block
                // the gameplay-thread recordKeepalive() calls.
                java.util.ArrayList<int[]> refresh = null;
                synchronized (controllerKeepalive) {
                    for (Map.Entry<Integer, long[]> e : controllerKeepalive.entrySet()) {
                        long[] st = e.getValue();
                        int low = (int) st[0];
                        int high = (int) st[1];
                        long when = st[2];
                        if ((low > 0 || high > 0) && (now - when) >= RUMBLE_KEEPALIVE_MS) {
                            if (refresh == null) refresh = new java.util.ArrayList<>(2);
                            refresh.add(new int[] { e.getKey(), low, high });
                            st[2] = now;
                        }
                    }
                }
                if (refresh != null) {
                    for (int[] r : refresh) {
                        InputDevice dev = InputDevice.getDevice(r[0]);
                        if (dev != null) {
                            dispatchControllerInternal(dev, r[1], r[2], /*log*/ false);
                        }
                    }
                }
                // Device side: if any slot has amplitude and refresh interval elapsed, re-arm.
                if (deviceActive && (now - lastDeviceDispatch) >= DEVICE_RUMBLE_REFRESH_MS) {
                    refreshDeviceRumble(now);
                }
            } catch (Throwable t) {
                Log.w(TAG, "keepalive tick failed", t);
            } finally {
                worker.postDelayed(this, 60L);
            }
        }
    };

    private BhVibrationController() {
        workerThread = new HandlerThread("BhVibWorker");
        workerThread.start();
        worker = new Handler(workerThread.getLooper());
        worker.post(keepaliveRunnable);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Public API
    // ─────────────────────────────────────────────────────────────────────────

    public void init(Context ctx) {
        if (ctx != null && this.appContext == null) {
            this.appContext = ctx.getApplicationContext();
        }
        reloadSettings();
    }

    /** Set per-game scope explicitly. Called from BhVibrationSettingsActivity
     *  with the gameId carried in via Intent from the per-game settings menu. */
    public void setContainerForSettings(String gameId) {
        if (gameId == null || gameId.isEmpty()) {
            this.containerGameId = null;
        } else {
            this.containerGameId = gameId;
        }
        reloadSettings();
        Log.i(TAG, "container=" + (containerGameId != null ? containerGameId : "(global)")
                + " mode=" + cachedMode + " intensity=" + cachedIntensity);
    }

    /**
     * Walks the live-activity table for any running WineActivity and extracts
     * its "gameId" Intent extra. Lets us scope prefs per-container at dispatch
     * time without requiring a smali patch to WineActivity.onCreate.
     *
     * Called opportunistically from handleRumble — if nothing resolves yet,
     * we stay on global defaults until the user enters a Wine session.
     */
    private void maybeResolveContainerFromActivityStack() {
        if (containerGameId != null) return;
        try {
            Class<?> atCls = Class.forName("android.app.ActivityThread");
            Method cur = atCls.getMethod("currentActivityThread");
            Object at = cur.invoke(null);
            if (at == null) return;
            java.lang.reflect.Field fActs = atCls.getDeclaredField("mActivities");
            fActs.setAccessible(true);
            Object acts = fActs.get(at);
            if (!(acts instanceof Map)) return;
            for (Object recordObj : ((Map<?, ?>) acts).values()) {
                if (recordObj == null) continue;
                java.lang.reflect.Field fAct = recordObj.getClass().getDeclaredField("activity");
                fAct.setAccessible(true);
                Object activity = fAct.get(recordObj);
                if (!(activity instanceof android.app.Activity)) continue;
                String clsName = activity.getClass().getName();
                if (!clsName.endsWith(".WineActivity")) continue;
                android.content.Intent it = ((android.app.Activity) activity).getIntent();
                if (it == null) continue;
                String gid = it.getStringExtra("gameId");
                if (gid == null || gid.isEmpty()) continue;
                this.containerGameId = gid;
                reloadSettings();
                Log.i(TAG, "container=" + gid + " mode=" + cachedMode + " intensity=" + cachedIntensity);
                return;
            }
        } catch (Throwable ignored) { }
    }

    /** Invoked from the settings UI when the user adjusts mode (0..3).
     *  When a game is in scope, writes go to that game's pc_g_setting<gameId>
     *  file (so Export Config picks them up). Always also updates the
     *  global default in bh_vibration_prefs. */
    public void setMode(int mode) {
        if (mode < 0 || mode > 3) return;
        this.cachedMode = mode;
        writeIntGlobal(GLOBAL_KEY_MODE, mode);
        if (containerGameId != null) {
            writeIntPerGame(containerGameId, PER_GAME_KEY_MODE, mode);
        }
    }

    /** Invoked from the settings UI when the user adjusts intensity (0..100). */
    public void setIntensity(int pct) {
        if (pct < 0) pct = 0;
        if (pct > 100) pct = 100;
        this.cachedIntensity = pct;
        writeIntGlobal(GLOBAL_KEY_INTENSITY, pct);
        if (containerGameId != null) {
            writeIntPerGame(containerGameId, PER_GAME_KEY_INTENSITY, pct);
        }
    }

    public int getMode() { return cachedMode; }
    public int getIntensity() { return cachedIntensity; }

    // ─────────────────────────────────────────────────────────────────────────
    // Smali entry 1: GamepadServerManager.onRumble(slot, low, high)
    //   Return true  → caller short-circuits (device-only or off).
    //   Return false → caller falls through to stock controller dispatch.
    // ─────────────────────────────────────────────────────────────────────────
    public static boolean onRumble(int slot, int low, int high) {
        try {
            return getInstance().handleRumble(slot, low, high);
        } catch (Throwable t) {
            Log.w(TAG, "onRumble failed", t);
            return false;
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Smali entry 2: GamepadDevice$Physical.h(lowRaw, highRaw)
    //   Return true  → caller short-circuits (controller handled, or mode excludes it).
    //   Return false → caller falls through to stock per-vibrator dispatch.
    // ─────────────────────────────────────────────────────────────────────────
    public static boolean dispatchToController(int deviceId, int lowRaw, int highRaw) {
        try {
            return getInstance().handleControllerDispatch(deviceId, lowRaw, highRaw);
        } catch (Throwable t) {
            Log.w(TAG, "dispatchToController failed", t);
            return false;
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Smali entry 3: GamepadDevice$Physical.g(). Stock GameHub's
    // GamepadDevice.f(II)V routes (0,0) -> g() (stop) and non-zero -> h(II)V
    // (dispatch). Our Patch 2 hooks h(II)V only, so without Patch 7 the (0,0)
    // would bypass our handler and our keepalive map would never clear.
    //
    // Patch 7 hooks g()V to call onStop(deviceId), which always issues our
    // pre-cancel supersede pattern (Samsung-HAL workaround) and falls through
    // to stock g() afterwards. Returns void — the previous boolean return
    // (for SDL phantom suppression) became vestigial when libevshim's
    // keepalive made phantom suppression unnecessary; the smali patch no
    // longer branches on the result.
    // ─────────────────────────────────────────────────────────────────────────
    public static void onStop(int deviceId) {
        try {
            getInstance().handleStop(deviceId);
        } catch (Throwable t) {
            Log.w(TAG, "onStop failed", t);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Smali entry 4: GamepadManager.B0(GamepadConnectionEvent)V — connect hook.
    //
    // When a controller connects, libvfs.so creates a virtual SDL joystick for
    // the slot but does NOT emit SDL_JOYDEVICEADDED until first input arrives.
    // winebus.so therefore never calls SDL_JoystickOpen on the slot, and the
    // game's XInputSetState dispatch ends up writing rumble to a slot winebus
    // hasn't registered — silent no-op. Multi-controller users see the second
    // (and Nth) controller's rumble fail until they press any button on it.
    //
    // This hook fires once per connect with the GamepadServerManager + slot
    // available. We queue a wake-up gated on a winedevice readiness marker
    // written by libevshim; once the marker fires, drainPendingWakeups()
    // staggers each slot's button-14 press/release through the slot's
    // GamepadState (200 ms apart, ascending). libvfs's poller sees the
    // button-byte change → emits SDL_JOYDEVICEADDED → winebus opens the
    // joystick → rumble dispatch works without user input.
    //
    // Reflection-based to avoid compile-time dependency on Tencent's
    // gamepad classes.
    // ─────────────────────────────────────────────────────────────────────────
    public static void scheduleWakeup(Object serverManager, int slot) {
        try {
            getInstance().handleScheduleWakeup(serverManager, slot);
        } catch (Throwable t) {
            Log.w(TAG, "scheduleWakeup failed", t);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Core logic
    // ─────────────────────────────────────────────────────────────────────────

    private boolean handleRumble(int slot, int low, int high) {
        if (slot < 0 || slot >= MAX_SLOTS) return false;
        ensureContext();
        maybeResolveContainerFromActivityStack();

        // Diagnostic: log every state change from the guest with a timestamp delta.
        // Flags non-zero -> (0,0) arrivals around 1 s as suspected SDL auto-expiry,
        // which is the bug GameNative PR #1214's evshim keepalive fixes. Read prev
        // state BEFORE the OFF early-return so the trace stays accurate across modes.
        logGuestTransition(slot, low & 0xFFFF, high & 0xFFFF);

        int mode = cachedMode;
        if (mode == MODE_OFF) return true; // swallow everything

        // Store per-slot raw values for device aggregation.
        slotLow.set(slot, low & 0xFFFF);
        slotHigh.set(slot, high & 0xFFFF);
        slotStamp.set(slot, SystemClock.uptimeMillis());

        if (mode == MODE_DEVICE || mode == MODE_BOTH) {
            worker.post(new Runnable() {
                @Override public void run() { dispatchDevice(); }
            });
        }

        // If mode is Device or Off, skip the stock controller dispatch entirely.
        return mode == MODE_DEVICE;
    }

    private boolean handleControllerDispatch(int deviceId, int lowRaw, int highRaw) {
        int mode = cachedMode;
        int low = lowRaw & 0xFFFF;
        int high = highRaw & 0xFFFF;
        dlog("DISPATCH dev=" + deviceId + " mode=" + mode
                + " low=" + low + " high=" + high);

        if (mode == MODE_OFF || mode == MODE_DEVICE) {
            // Controller should stay silent. Stop any active rumble on this device.
            stopController(deviceId);
            return true;
        }

        InputDevice dev = InputDevice.getDevice(deviceId);
        if (dev == null) {
            dlog("DISPATCH dev=" + deviceId + " InputDevice.getDevice -> null, fallthrough");
            return false; // let stock code try (won't find anything, but no harm)
        }

        if (low == 0 && high == 0) {
            stopController(deviceId);
            recordKeepalive(deviceId, 0, 0);
            return true;
        }

        dispatchControllerInternal(dev, low, high, /*log*/ true);
        recordKeepalive(deviceId, low, high);
        return true;
    }

    /**
     * Called from the smali patch on GamepadDevice$Physical.g()V — fires
     * whenever stock GameHub's GamepadDevice.f(II)V routes a (0, 0) rumble
     * to the stop path. We issue our supersede pattern (1 ms minimum-
     * amplitude vm.vibrate()) ahead of stock g() because on Samsung's
     * Vibrator HAL for InputDevice vibrators, Vibrator.cancel() doesn't
     * reliably halt BT-HID effects already uploaded to the controller.
     * Stock g() runs after us and iterates the vibrator list canceling
     * each.
     */
    private void handleStop(int deviceId) {
        dlog("STOP-G dev=" + deviceId);
        recordKeepalive(deviceId, 0, 0);
        // Don't touch slotLow[]/slotHigh[]/deviceActive here — those are
        // indexed by *guest XInput slot*, not Android deviceId, so we have
        // no way to know which slot belongs to the stopping controller.
        // handleRumble already cleared this controller's slot when the (0,0)
        // arrived (it precedes stock f()→g()→handleStop), and dispatchDevice
        // recomputes deviceActive from the aggregate. Wiping all slots here
        // would silence the phone vibrator and other controllers' rumble
        // when ANY controller stops in a multi-controller session.
        // Supersede AHEAD of stock g()'s per-vibrator cancel.
        stopController(deviceId);
    }

    /**
     * Wake up libvfs's lazily-registered virtual joystick by toggling a
     * button bit in the slot's GamepadState, which triggers libvfs-client
     * (in winedevice.exe) to emit SDL_JOYDEVICEADDED so winebus.so can
     * open the joystick before the user provides input.
     *
     * Detection-driven, not timing-driven: connects are queued in
     * pendingWakeups and fired only when libevshim writes the
     * .bh_winedevice_ready marker file from inside winedevice.exe (after
     * its winebus GOT patch lands, which by construction is AFTER libvfs-
     * client has fully initialized its mmap'd shared buffer). A FileObserver
     * on the marker drains the queue. Eliminates the timing guess of the
     * earlier multi-shot approach.
     *
     * Stimulus is a button-14 press/release (50 ms apart) via
     * GamepadState.b(int, boolean). Index 14 is the highest the
     * range check `p1 < 0xf` accepts (storage offset = 12 + index → byte
     * 26, well past the axis bytes at 0..11) and is unmapped by every
     * common XInput-targeting game (XInput defines 14 buttons, indices
     * 0..13). Empirically axis flicker failed for slot >=1 in multi-
     * controller setups; button flicker works because libvfs's poller
     * checks button bytes for the lazy-attach trigger.
     *
     * All Tencent class access via reflection because GamepadServerManager
     * and GamepadState aren't on our compile classpath. Field/method names:
     *   GamepadServerManager.g(int)        → GamepadState
     *   GamepadState.b(int, boolean)       → write button byte
     */
    private static final String READY_MARKER_NAME = ".bh_winedevice_ready";

    private final Map<Integer, Object> pendingWakeups = new ConcurrentHashMap<>();
    private final AtomicBoolean readinessWatcherStarted = new AtomicBoolean(false);
    private volatile FileObserver readinessObserver;
    // Cache reflection lookups — the GamepadServerManager and GamepadState
    // classes are the same across every wake-up. Volatile so the
    // benign-race "look up twice" on first cold start is safe.
    private volatile Method cachedGetStateMethod;
    private volatile Method cachedWriteButtonMethod;

    private void handleScheduleWakeup(final Object serverManager, final int slot) {
        if (serverManager == null || slot < 0 || slot >= MAX_SLOTS) {
            return;
        }
        // Resolve the application Context first — without it we can't find
        // getFilesDir() to register the FileObserver. handleScheduleWakeup
        // is sometimes the FIRST entry point hit on cold start (before any
        // rumble dispatch has called ensureContext for us).
        ensureContext();
        maybeResolveContainerFromActivityStack();

        ensureReadinessWatcher();
        pendingWakeups.put(slot, serverManager);
        Log.i(TAG, "wake-up queued slot=" + slot + " (awaiting winedevice ready marker)");

        // If the marker already exists from an earlier patcher run, the
        // FileObserver won't fire — drain immediately.
        File marker = readyMarkerFile();
        if (marker != null && marker.exists()) {
            Log.i(TAG, "wake-up: marker already exists, firing immediately");
            drainPendingWakeups();
        }
    }

    private File readyMarkerFile() {
        Context ctx = appContext;
        if (ctx == null) return null;
        File dir = ctx.getFilesDir();
        if (dir == null) return null;
        return new File(dir, READY_MARKER_NAME);
    }

    private void ensureReadinessWatcher() {
        if (readinessWatcherStarted.get()) return;
        Context ctx = appContext;
        if (ctx == null) return;
        File dir = ctx.getFilesDir();
        if (dir == null) return;
        if (!readinessWatcherStarted.compareAndSet(false, true)) return;

        // Delete any stale marker left over from a previous app session.
        // The marker indicates "winedevice's libvfs is ready" but it's
        // valid only for the *current* winedevice process. On a fresh
        // BannerHub launch, the previous marker is meaningless — if we
        // saw it, we'd fire the wake-up before the new winedevice's
        // libvfs has come up. Force evshim's next write to be a fresh
        // CREATE event we can trust.
        File staleMarker = new File(dir, READY_MARKER_NAME);
        if (staleMarker.exists()) {
            boolean deleted = staleMarker.delete();
            Log.i(TAG, "deleted stale ready marker (deleted=" + deleted + ")");
        }

        // Watch CREATE (fresh marker after a winedevice respawn — evshim
        // unlinks before recreating to guarantee this fires) and MODIFY
        // (in case the unlink races with FileObserver registration).
        FileObserver fo = new FileObserver(dir.getAbsolutePath(),
                FileObserver.CREATE | FileObserver.MODIFY | FileObserver.MOVED_TO) {
            @Override public void onEvent(int event, String path) {
                if (path == null) return;
                if (!READY_MARKER_NAME.equals(path)) return;
                Log.i(TAG, "winedevice ready marker observed (event=0x" + Integer.toHexString(event) + ")");
                worker.post(new Runnable() {
                    @Override public void run() { drainPendingWakeups(); }
                });
            }
        };
        fo.startWatching();
        readinessObserver = fo;
        Log.i(TAG, "readiness watcher started on " + dir.getAbsolutePath());
    }

    private void drainPendingWakeups() {
        if (pendingWakeups.isEmpty()) return;

        // Stagger wake-ups across slots in ascending order. With a third
        // controller in the mix, libvfs's SDL_GameController vs. raw
        // SDL_Joystick split (the "SDL B / SDL A" distinction Wine joystick
        // testers expose) seems to depend on lower slots being fully
        // SDL-registered before higher slots' button events trigger
        // SDL_JOYDEVICEADDED. Empirically: pressing real buttons on slots
        // 0+1 also unsticks slot 2's rumble — so slot 2's button-flicker
        // *did* land in shared memory, libvfs just hadn't started watching
        // it yet. Firing in ascending order, ~200 ms apart, gives each
        // slot time to register before the next stimulus arrives.
        List<Integer> slots = new ArrayList<>(pendingWakeups.keySet());
        Collections.sort(slots);
        long delayMs = 0L;
        for (final int slot : slots) {
            final Object serverManager = pendingWakeups.get(slot);
            if (serverManager == null) continue;
            if (delayMs == 0L) {
                fireWakeup(serverManager, slot);
            } else {
                worker.postDelayed(new Runnable() {
                    @Override public void run() { fireWakeup(serverManager, slot); }
                }, delayMs);
            }
            delayMs += 200L;
        }
        pendingWakeups.clear();
    }

    private void fireWakeup(Object serverManager, final int slot) {
        try {
            Method getState = cachedGetStateMethod;
            if (getState == null) {
                getState = serverManager.getClass()
                        .getDeclaredMethod("g", int.class);
                getState.setAccessible(true);
                cachedGetStateMethod = getState;
            }
            final Object state = getState.invoke(serverManager, slot);
            if (state == null) {
                Log.i(TAG, "wake-up: no GamepadState for slot " + slot);
                return;
            }
            // Wake-up via button-press flicker on a high button index that
            // no real game maps. Wine's bus_sdl.c process_device_event
            // *drops* button events on unregistered SDL_JoystickIDs (just
            // logs a WARN — confirmed reading wine-10.0 source), so a
            // button event on the SDL queue isn't what wakes things. The
            // real wake-up comes from libvfs lazily emitting
            // SDL_JOYDEVICEADDED on first-input. Empirically axis flicker
            // failed for some slots in multi-controller setups but button
            // flicker works (libvfs's poller appears to check button
            // bytes for the lazy-attach trigger).
            //
            // Use button index 14 — outermost reachable via GamepadState.b
            // (range check is `p1 < 0xf`, i.e. < 15) and unmapped by every
            // XInput game (XInput defines 14 buttons, indices 0..13).
            // Sequence: press, then release 50 ms later. If the user is
            // genuinely chording button 14 mid-flicker the natural-input
            // pipeline overwrites within ~16 ms; net effect is still a
            // state change libvfs notices.
            final Method writeButton;
            Method cached = cachedWriteButtonMethod;
            if (cached == null) {
                cached = state.getClass()
                        .getDeclaredMethod("b", int.class, boolean.class);
                cached.setAccessible(true);
                cachedWriteButtonMethod = cached;
            }
            writeButton = cached;
            final int wakeButton = 14;
            writeButton.invoke(state, wakeButton, true);
            Log.i(TAG, "wake-up fired slot=" + slot
                    + " button[" + wakeButton + "] press");
            worker.postDelayed(new Runnable() {
                @Override public void run() {
                    try {
                        writeButton.invoke(state, wakeButton, false);
                        Log.i(TAG, "wake-up complete slot=" + slot);
                    } catch (Throwable t) {
                        Log.w(TAG, "wake-up release failed slot=" + slot, t);
                    }
                }
            }, 50L);
        } catch (Throwable t) {
            Log.w(TAG, "wake-up failed slot=" + slot, t);
        }
    }

    /**
     * Diagnostic logger for guest-side rumble events arriving via
     * GamepadServerManager.onRumble. Logs only meaningful state transitions
     * (skips repeated same-value frames). Tags non-zero -> (0,0) arrivals in
     * the 900-1200 ms window as suspected SDL auto-expiry — the trigger for
     * deciding whether to port GameNative PR #1214's evshim keepalive.
     *
     * Reads previous state from slotLow/slotHigh/slotStamp BEFORE handleRumble
     * overwrites them, so each log line shows the actual delta from the last
     * frame. Filter logcat with `BhVibration` and grep "DIAG ".
     */
    private void logGuestTransition(int slot, int newLow, int newHigh) {
        if (!DIAG) return;
        int prevLow = diagPrevLow[slot];
        int prevHigh = diagPrevHigh[slot];
        long prevWhen = diagPrevWhen[slot];
        long now = SystemClock.uptimeMillis();

        // Always update the diagnostic state, even on idle frames, so the next
        // transition's gap measures from the most recent non-update event too.
        diagPrevLow[slot] = newLow;
        diagPrevHigh[slot] = newHigh;
        diagPrevWhen[slot] = now;

        if (prevLow == newLow && prevHigh == newHigh) return; // idle frame, no log

        long gap = (prevWhen > 0) ? (now - prevWhen) : -1L;
        boolean wasNonZero = (prevLow | prevHigh) != 0;
        boolean isZero = (newLow | newHigh) == 0;
        String tag = "";
        if (wasNonZero && isZero && gap >= 900L && gap <= 1200L) {
            tag = "  [SDL_AUTO_EXPIRY?]";
        }
        Log.i(TAG, "DIAG slot=" + slot
                + "  " + prevLow + "," + prevHigh
                + " -> " + newLow + "," + newHigh
                + "  gap=" + gap + "ms" + tag);
    }

    /**
     * Per-controller dispatch. Uses CombinedVibration.startParallel when the
     * device exposes a VibratorManager with ≥2 motors; otherwise falls back to
     * a single-vibrator blend (low*0.8 + high*0.33) that matches GameNative PR.
     *
     * Amplitude is scaled by the user's intensity percentage and floored at 1
     * so non-zero XInput values never get quantised away to silence.
     */
    private void dispatchControllerInternal(InputDevice dev, int low, int high, boolean logMotors) {
        int intensity = cachedIntensity;
        int lowAmp = scaleAmplitude(low, intensity);
        int highAmp = scaleAmplitude(high, intensity);
        if (lowAmp == 0 && highAmp == 0) return;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            VibratorManager vm = dev.getVibratorManager();
            if (vm != null && tryCombinedDispatch(vm, lowAmp, highAmp, logMotors)) {
                return;
            }
        }

        // Fallback path: single-vibrator blend of low + high.
        Vibrator v = dev.getVibrator();
        if (v == null || !v.hasVibrator()) return;
        vibrateSafe(v, blendLowHigh(lowAmp, highAmp), CONTROLLER_RUMBLE_MS, /*haptic*/ true);
    }

    private boolean tryCombinedDispatch(VibratorManager vm, int lowAmp, int highAmp, boolean logMotors) {
        int[] ids = vm.getVibratorIds();
        if (ids == null || ids.length == 0) return false;

        // Sort ascending to give us a deterministic "low motor = ids[0]" assignment.
        int[] sortedIds = ids.clone();
        java.util.Arrays.sort(sortedIds);

        if (sortedIds.length == 1) {
            Vibrator only = vm.getVibrator(sortedIds[0]);
            if (only == null) return false;
            vibrateSafe(only, blendLowHigh(lowAmp, highAmp), CONTROLLER_RUMBLE_MS, /*haptic*/ true);
            return true;
        }

        Vibrator lowMotor = vm.getVibrator(sortedIds[0]);
        Vibrator highMotor = vm.getVibrator(sortedIds[1]);
        if (lowMotor == null || highMotor == null) return false;

        int effLow = clampAmplitude(lowAmp, lowMotor);
        int effHigh = clampAmplitude(highAmp, highMotor);

        CombinedVibration.ParallelCombination p = CombinedVibration.startParallel();
        if (effLow > 0) p.addVibrator(sortedIds[0], VibrationEffect.createOneShot(CONTROLLER_RUMBLE_MS, effLow));
        if (effHigh > 0) p.addVibrator(sortedIds[1], VibrationEffect.createOneShot(CONTROLLER_RUMBLE_MS, effHigh));

        CombinedVibration combined = p.combine();
        VibrationAttributes attrs = buildAttrs();
        if (attrs != null) {
            vm.vibrate(combined, attrs);
        } else {
            vm.vibrate(combined);
        }

        if (logMotors && DIAG) {
            Log.i(TAG, "combined dispatch ids=" + java.util.Arrays.toString(sortedIds)
                    + " lowAmp=" + effLow + " highAmp=" + effHigh);
        }
        return true;
    }

    private int clampAmplitude(int amp, Vibrator v) {
        if (amp <= 0) return 0;
        if (v != null && !v.hasAmplitudeControl()) {
            // No amplitude support: any non-zero value = full strength pulse.
            return amp > 0 ? 255 : 0;
        }
        return Math.min(255, Math.max(1, amp));
    }

    private void stopController(int deviceId) {
        InputDevice dev = InputDevice.getDevice(deviceId);
        if (dev == null) {
            dlog("STOP dev=" + deviceId + " InputDevice null");
            return;
        }
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                VibratorManager vm = dev.getVibratorManager();
                if (vm != null) {
                    int[] ids = vm.getVibratorIds();
                    if (ids != null && ids.length > 0) {
                        // Force-stop pattern: vm.cancel() alone does NOT reliably
                        // halt in-flight BT-HID rumble on Samsung's Vibrator HAL
                        // for InputDevice vibrators. But vibrate() always supersedes
                        // (proven empirically: tapping a different motor halts the
                        // previous one). Issue a 1ms minimum-amplitude pulse on
                        // every motor to replace whatever's running, then cancel
                        // for belt-and-suspenders.
                        CombinedVibration.ParallelCombination p = CombinedVibration.startParallel();
                        for (int id : ids) {
                            p.addVibrator(id, VibrationEffect.createOneShot(1L, 1));
                        }
                        VibrationAttributes attrs = buildAttrs();
                        if (attrs != null) {
                            vm.vibrate(p.combine(), attrs);
                        } else {
                            vm.vibrate(p.combine());
                        }
                        vm.cancel();
                        if (DIAG) {
                            Log.i(TAG, "STOP dev=" + deviceId + " supersede+cancel ids="
                                    + java.util.Arrays.toString(ids));
                        }
                        return;
                    }
                    dlog("STOP dev=" + deviceId + " vm has no vibrator ids; cancel()");
                    vm.cancel();
                    return;
                }
            }
            Vibrator v = dev.getVibrator();
            if (v != null) {
                dlog("STOP dev=" + deviceId + " single-vibrator supersede+cancel");
                try { v.vibrate(VibrationEffect.createOneShot(1L, 1)); } catch (Throwable ignored) {}
                v.cancel();
            } else {
                dlog("STOP dev=" + deviceId + " no Vibrator/VibratorManager");
            }
        } catch (Throwable t) {
            Log.w(TAG, "STOP dev=" + deviceId + " threw", t);
        }
    }

    private void recordKeepalive(int deviceId, int low, int high) {
        long now = SystemClock.uptimeMillis();
        synchronized (controllerKeepalive) {
            long[] st = controllerKeepalive.get(deviceId);
            if (st == null) {
                st = new long[3];
                controllerKeepalive.put(deviceId, st);
            }
            st[0] = low;
            st[1] = high;
            st[2] = now;
        }
    }

    /**
     * Phone (device) dispatch: aggregate across all active slots using MAX
     * of each motor, then blend and apply a haptic curve so low-end bias
     * doesn't make weak rumbles imperceptible.
     */
    private void dispatchDevice() {
        ensureContext();
        Context ctx = appContext;
        if (ctx == null) return;

        int maxLow = 0, maxHigh = 0;
        long now = SystemClock.uptimeMillis();
        for (int i = 0; i < MAX_SLOTS; i++) {
            if (now - slotStamp.get(i) > 1500L) {
                slotLow.set(i, 0);
                slotHigh.set(i, 0);
                continue;
            }
            int l = slotLow.get(i);
            int h = slotHigh.get(i);
            if (l > maxLow) maxLow = l;
            if (h > maxHigh) maxHigh = h;
        }
        if (maxLow == 0 && maxHigh == 0) { deviceActive = false; return; }

        int intensity = cachedIntensity;
        int lowAmp = scaleAmplitude(maxLow, intensity);
        int highAmp = scaleAmplitude(maxHigh, intensity);
        int blended = blendLowHigh(lowAmp, highAmp);

        // Haptic curve pow(x, 0.6) — makes small values more perceptible on the phone.
        double norm = blended / 255.0;
        int shaped = (int) Math.min(255, Math.max(1, Math.round(Math.pow(norm, 0.6) * 255.0)));

        Vibrator v = resolveDeviceVibrator(ctx);
        if (v == null) return;
        vibrateSafe(v, shaped, DEVICE_RUMBLE_MS, /*haptic*/ false);
        lastDeviceDispatch = now;
        deviceActive = true;
    }

    private void refreshDeviceRumble(long now) {
        // Recompute from last known slot values and re-dispatch if still active.
        int maxLow = 0, maxHigh = 0;
        for (int i = 0; i < MAX_SLOTS; i++) {
            if (now - slotStamp.get(i) > 1500L) {
                slotLow.set(i, 0);
                slotHigh.set(i, 0);
                continue;
            }
            int l = slotLow.get(i);
            int h = slotHigh.get(i);
            if (l > maxLow) maxLow = l;
            if (h > maxHigh) maxHigh = h;
        }
        if (maxLow == 0 && maxHigh == 0) {
            deviceActive = false;
            return;
        }
        dispatchDevice();
    }

    /**
     * Single-vibrator blend of XInput's two motor amplitudes onto one motor.
     * Per GameNative PR #1214: low rumble (heavy) gets 0.80 weighting and
     * high rumble (light) gets 0.33, clamped to [1, 255] so non-zero input
     * never quantises away to silence on phones with weak vibrators. Used
     * by both controller fallback dispatch (single-motor controllers) and
     * device-mode dispatch (phone vibrator). Magic constants live in one
     * place so they can be tuned consistently.
     */
    private static int blendLowHigh(int lowAmp, int highAmp) {
        long blended = Math.round(lowAmp * 0.80 + highAmp * 0.33);
        if (blended < 1) blended = 1;
        if (blended > 255) blended = 255;
        return (int) blended;
    }

    private Vibrator resolveDeviceVibrator(Context ctx) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                VibratorManager vm = (VibratorManager) ctx.getSystemService(Context.VIBRATOR_MANAGER_SERVICE);
                if (vm != null) return vm.getDefaultVibrator();
            }
            return (Vibrator) ctx.getSystemService(Context.VIBRATOR_SERVICE);
        } catch (Throwable t) {
            return null;
        }
    }

    private void vibrateSafe(Vibrator v, int amplitude, long durationMs, boolean haptic) {
        try {
            if (v == null || !v.hasVibrator()) return;
            int amp = amplitude;
            if (!v.hasAmplitudeControl()) amp = VibrationEffect.DEFAULT_AMPLITUDE;
            VibrationEffect eff = VibrationEffect.createOneShot(durationMs, amp);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                VibrationAttributes attrs = buildAttrs();
                if (attrs != null) { v.vibrate(eff, attrs); return; }
            }
            AudioAttributes audio = new AudioAttributes.Builder()
                    .setUsage(haptic ? AudioAttributes.USAGE_GAME : AudioAttributes.USAGE_UNKNOWN)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build();
            v.vibrate(eff, audio);
        } catch (Throwable ignored) { }
    }

    private VibrationAttributes buildAttrs() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return null;
        try {
            return new VibrationAttributes.Builder()
                    .setUsage(VibrationAttributes.USAGE_MEDIA)
                    .build();
        } catch (Throwable t) {
            return null;
        }
    }

    /**
     * XInput rumble is 16-bit unsigned. Scale to 0..255 and apply user intensity.
     * Amplitude is floored at 1 (not 0) so barely-perceptible values don't vanish
     * entirely due to integer truncation.
     */
    public static int scaleAmplitude(int rawFreq, int intensityPercent) {
        int unsigned = rawFreq & 0xFFFF;
        if (unsigned == 0 || intensityPercent == 0) return 0;
        int base = (int) Math.round(unsigned * 255.0 / 65535.0);
        int scaled = (base * intensityPercent) / 100;
        return Math.min(255, Math.max(1, scaled));
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Settings I/O
    // ─────────────────────────────────────────────────────────────────────────

    private void reloadSettings() {
        ensureContext();
        Context ctx = appContext;
        if (ctx == null) return;

        // Resolve global defaults first.
        SharedPreferences gp = ctx.getSharedPreferences(GLOBAL_PREFS_FILE, Context.MODE_PRIVATE);
        int globalMode = gp.getInt(GLOBAL_KEY_MODE, DEFAULT_MODE);
        int globalIntensity = gp.getInt(GLOBAL_KEY_INTENSITY, DEFAULT_INTENSITY);

        if (containerGameId == null) {
            cachedMode = globalMode;
            cachedIntensity = globalIntensity;
            return;
        }

        // Per-game: prefer pc_g_setting<gameId> values. Fall back to legacy
        // bh_vibration_prefs entries (older builds wrote there) so users
        // upgrading don't lose their per-container preferences. Final
        // fallback is the global default. Older imported pc_g_setting
        // files lacking our keys naturally end up at the global default.
        SharedPreferences pgp = ctx.getSharedPreferences(
                String.format(PER_GAME_PREFS_FMT, containerGameId), Context.MODE_PRIVATE);

        int legacyMode = gp.getInt(LEGACY_MODE_PREFIX + containerGameId, globalMode);
        int legacyIntensity = gp.getInt(LEGACY_INTENSITY_PREFIX + containerGameId, globalIntensity);

        cachedMode = pgp.getInt(PER_GAME_KEY_MODE, legacyMode);
        cachedIntensity = pgp.getInt(PER_GAME_KEY_INTENSITY, legacyIntensity);
    }

    private void writeIntGlobal(String key, int val) {
        ensureContext();
        Context ctx = appContext;
        if (ctx == null) return;
        ctx.getSharedPreferences(GLOBAL_PREFS_FILE, Context.MODE_PRIVATE)
                .edit().putInt(key, val).apply();
    }

    private void writeIntPerGame(String gameId, String key, int val) {
        ensureContext();
        Context ctx = appContext;
        if (ctx == null || gameId == null || gameId.isEmpty()) return;
        ctx.getSharedPreferences(String.format(PER_GAME_PREFS_FMT, gameId),
                                  Context.MODE_PRIVATE)
                .edit().putInt(key, val).apply();
    }

    /**
     * ActivityThread.currentApplication() gives us a Context without needing
     * any caller to pass one in. Works from any thread after app initialisation.
     */
    private void ensureContext() {
        if (appContext != null) return;
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Method m = at.getMethod("currentApplication");
            Object app = m.invoke(null);
            if (app instanceof Context) {
                appContext = ((Context) app).getApplicationContext();
                reloadSettings();
            }
        } catch (Throwable t) {
            Log.w(TAG, "ensureContext failed", t);
        }
    }
}
