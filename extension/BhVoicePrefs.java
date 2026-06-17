package com.xj.winemu.sidebar;

import android.content.Context;
import android.os.Environment;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Properties;
import java.util.UUID;

/**
 * Cross-process state + identity for the BannerHub voice-chat feature.
 *
 * <p>The activation toggle and nickname are set from the dashboard "Voice Chat"
 * screen (main launcher process) but read in-game by the pill overlay (the
 * {@code :wine} process). SharedPreferences is unreliable here: Android caches
 * one instance per file name and ignores the mode on later opens, so once
 * {@code BhHudInjector} opens {@code bh_prefs} with {@code MODE_PRIVATE} in the
 * {@code :wine} process, a later {@code MODE_MULTI_PROCESS} open returns that
 * cached instance and never reloads the other process's write.
 *
 * <p>So we keep voice state in a plain {@link Properties} file under
 * {@link Context#getFilesDir()} (one path shared by all processes of the app)
 * and read it <b>fresh on every call</b> — no caching, always current across
 * processes. Identity is a stable local {@code voice_client_id} (a UUID), NOT a
 * SteamID; voice chat here does not depend on Steam at all.
 */
public final class BhVoicePrefs {

    private BhVoicePrefs() {}

    private static final String TAG = "BhVoice";
    private static final String FILE = "bh_voice_state.properties";

    private static final String KEY_NICK    = "voice_nickname";
    private static final String KEY_CLIENT  = "voice_client_id";
    private static final String KEY_ENABLED = "voice_pill_enabled";
    private static final String KEY_PILL_Y  = "voice_pill_y";
    private static final String KEY_PILL_X  = "voice_pill_x";
    private static final String KEY_OPACITY = "voice_pill_opacity";

    /** bannerhub-api worker base — same worker that powers v6 voice. */
    public static final String WORKER = "https://bannerhub-api.the412banner.workers.dev";

    private static File stateFile(Context ctx) {
        return new File(ctx.getFilesDir(), FILE);
    }

    private static synchronized Properties load(Context ctx) {
        Properties p = new Properties();
        File f = stateFile(ctx);
        if (f.exists()) {
            FileInputStream in = null;
            try { in = new FileInputStream(f); p.load(in); }
            catch (Throwable t) { Log.w(TAG, "voice state load failed", t); }
            finally { if (in != null) try { in.close(); } catch (Throwable ignored) {} }
        }
        return p;
    }

    private static synchronized void save(Context ctx, Properties p) {
        FileOutputStream out = null;
        try { out = new FileOutputStream(stateFile(ctx)); p.store(out, "BannerHub voice state"); }
        catch (Throwable t) { Log.w(TAG, "voice state save failed", t); }
        finally { if (out != null) try { out.close(); } catch (Throwable ignored) {} }
    }

    /** Stable per-device client id. Stored in PUBLIC storage
     *  ({@code /sdcard/BannerHub/voice_id.txt}) so it survives uninstall / clear
     *  data / APK swaps — which is what previously orphaned a claimed nickname.
     *  Falls back to the app-private file if public storage isn't writable. */
    public static String clientId(Context ctx) {
        // 1. Public storage wins — survives reinstall on this device.
        String pub = readPublicId();
        if (!pub.isEmpty()) {
            Properties p = load(ctx);
            if (!pub.equals(p.getProperty(KEY_CLIENT, ""))) { p.setProperty(KEY_CLIENT, pub); save(ctx, p); }
            return pub;
        }
        // 2. App-private file (may carry an id from a prior build).
        Properties p = load(ctx);
        String id = p.getProperty(KEY_CLIENT, "");
        if (id.isEmpty()) {
            id = "bh-" + UUID.randomUUID().toString().replace("-", "").substring(0, 16);
            p.setProperty(KEY_CLIENT, id);
            save(ctx, p);
        }
        // 3. Promote to public storage so it persists across future reinstalls.
        writePublicId(id);
        return id;
    }

    private static File publicIdFile() {
        return new File(new File(Environment.getExternalStorageDirectory(), "BannerHub"), "voice_id.txt");
    }

    private static String readPublicId() {
        FileInputStream in = null;
        try {
            File f = publicIdFile();
            if (!f.exists()) return "";
            in = new FileInputStream(f);
            byte[] buf = new byte[64];
            int n = in.read(buf);
            return n > 0 ? new String(buf, 0, n, "UTF-8").trim() : "";
        } catch (Throwable t) { return ""; }
        finally { if (in != null) try { in.close(); } catch (Throwable ignored) {} }
    }

    private static void writePublicId(String id) {
        FileOutputStream out = null;
        try {
            File dir = new File(Environment.getExternalStorageDirectory(), "BannerHub");
            if (!dir.exists()) dir.mkdirs();
            out = new FileOutputStream(new File(dir, "voice_id.txt"));
            out.write(id.getBytes("UTF-8"));
        } catch (Throwable t) { Log.w(TAG, "voice public id write failed", t); }
        finally { if (out != null) try { out.close(); } catch (Throwable ignored) {} }
    }

    public static String nickname(Context ctx) {
        return load(ctx).getProperty(KEY_NICK, "");
    }

    public static void setNickname(Context ctx, String name) {
        Properties p = load(ctx);
        p.setProperty(KEY_NICK, name == null ? "" : name);
        save(ctx, p);
    }

    public static boolean activated(Context ctx) {
        return "true".equals(load(ctx).getProperty(KEY_ENABLED, "false"));
    }

    public static void setActivated(Context ctx, boolean on) {
        Properties p = load(ctx);
        p.setProperty(KEY_ENABLED, on ? "true" : "false");
        save(ctx, p);
    }

    public static int getPillY(Context ctx, int def) { return getInt(ctx, KEY_PILL_Y, def); }
    public static void setPillY(Context ctx, int y) { setInt(ctx, KEY_PILL_Y, y); }
    public static int getPillX(Context ctx, int def) { return getInt(ctx, KEY_PILL_X, def); }
    public static void setPillX(Context ctx, int x) { setInt(ctx, KEY_PILL_X, x); }
    /** Pill/box opacity 20–100 (%), default 92. */
    public static int getOpacity(Context ctx) { return getInt(ctx, KEY_OPACITY, 92); }
    public static void setOpacity(Context ctx, int pct) { setInt(ctx, KEY_OPACITY, pct); }

    private static int getInt(Context ctx, String key, int def) {
        try { return Integer.parseInt(load(ctx).getProperty(key, String.valueOf(def))); }
        catch (Throwable t) { return def; }
    }

    private static void setInt(Context ctx, String key, int v) {
        Properties p = load(ctx);
        p.setProperty(key, String.valueOf(v));
        save(ctx, p);
    }

    /** The pill shows in-game only when activated AND a nickname is claimed. */
    public static boolean pillEnabled(Context ctx) {
        Properties p = load(ctx);
        String n = p.getProperty(KEY_NICK, "");
        boolean on = "true".equals(p.getProperty(KEY_ENABLED, "false"));
        return on && n != null && !n.trim().isEmpty();
    }
}
