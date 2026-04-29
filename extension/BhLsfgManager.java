package app.revanced.extension.gamehub;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class BhLsfgManager {

    public static final String EXTRA_GAME_ID = "bh_lsfg_game_id";

    public static final String KEY_ENABLED    = "lsfg_enabled";
    public static final String KEY_MULTIPLIER = "lsfg_multiplier";  // 0=off, 2, 3, or 4
    public static final String KEY_FLOW_SCALE = "lsfg_flow_scale";  // "1.00", "0.75", etc.
    public static final String KEY_PERF_MODE  = "lsfg_perf_mode";

    private static final String PREFS_PREFIX = "bh_lsfg_";

    // Shared DLL stored once in app files; all games read from here
    private static final String SHARED_DLL_DIR  = "lsfg";
    private static final String SHARED_DLL_NAME = "Lossless.dll";

    // Asset paths (relative to assets/)
    private static final String ASSET_MANIFEST = "lsfg_vk/VkLayer_LS_frame_generation.json";

    private static final String LIB_FILENAME    = "liblsfg-vk-layer.so";
    private static final String MANIFEST_SUBDIR = ".local/share/vulkan/implicit_layer.d";
    private static final String MANIFEST_FILE   = "VkLayer_LS_frame_generation.json";
    private static final String CONFIG_SUBDIR   = ".config/lsfg-vk";
    private static final String CONFIG_FILE     = "conf.toml";
    private static final String VERSION_FILE    = ".lsfg_vk_version";

    private static final String ENV_PREFS_KEY  = "pc_ls_environment_variable";
    private static final String ENV_LAYER_PATH = "VK_LAYER_PATH=";
    private static final String ENV_LAYER_NAME = "VK_INSTANCE_LAYERS=";

    private static final String RUNTIME_VERSION = "v1.4.0-android-arm64-v8a-ahb";

    private static final String[] WINE_EXE_NAMES = { "wine64-preloader", "wineloader", "wine64" };

    private static final String TAG = "BhLsfg";

    // ── Shared DLL ────────────────────────────────────────────────────────────

    public static File getSharedDllFile(Context ctx) {
        return new File(ctx.getFilesDir(), SHARED_DLL_DIR + "/" + SHARED_DLL_NAME);
    }

    /**
     * Copies a user-picked Lossless.dll to the shared app-internal location so every
     * game can find it automatically without per-game configuration.
     */
    public static boolean copyDllToShared(Context ctx, String sourcePath) {
        File src = new File(sourcePath);
        if (!src.isFile()) return false;
        File dst = getSharedDllFile(ctx);
        dst.getParentFile().mkdirs();
        try (java.io.FileInputStream in = new java.io.FileInputStream(src);
             FileOutputStream out = new FileOutputStream(dst)) {
            byte[] buf = new byte[65536];
            int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
            dst.setReadable(true, false);
            Log.d(TAG, "DLL copied to shared: " + dst.getAbsolutePath());
            return true;
        } catch (IOException e) {
            Log.e(TAG, "copyDllToShared failed: " + e.getMessage());
            return false;
        }
    }

    /** Returns the Lossless.dll path to use: shared copy first, then container auto-discover. */
    public static String resolveDll(Context ctx) {
        File shared = getSharedDllFile(ctx);
        if (shared.isFile()) return shared.getAbsolutePath();
        return autoDiscoverDll(ctx);
    }

    // ── Per-game prefs accessors ──────────────────────────────────────────────

    private static SharedPreferences gamePrefs(Context ctx, String gameId) {
        return ctx.getSharedPreferences(PREFS_PREFIX + gameId, Context.MODE_PRIVATE);
    }

    public static boolean isEnabled(Context ctx, String gameId) {
        return gamePrefs(ctx, gameId).getBoolean(KEY_ENABLED, false);
    }

    public static int getMultiplier(Context ctx, String gameId) {
        int m = gamePrefs(ctx, gameId).getInt(KEY_MULTIPLIER, 2);
        return (m == 0) ? 0 : Math.max(2, Math.min(4, m));
    }

    public static String getFlowScale(Context ctx, String gameId) {
        return gamePrefs(ctx, gameId).getString(KEY_FLOW_SCALE, "1.00");
    }

    public static boolean getPerfMode(Context ctx, String gameId) {
        return gamePrefs(ctx, gameId).getBoolean(KEY_PERF_MODE, false);
    }

    /** True when enabled, multiplier > 0, and Lossless.dll is available. */
    public static boolean isArmed(Context ctx, String gameId) {
        if (!isEnabled(ctx, gameId)) return false;
        if (getMultiplier(ctx, gameId) == 0) return false;
        return resolveDll(ctx) != null;
    }

    // ── DLL discovery ─────────────────────────────────────────────────────────

    public static String autoDiscoverDll(Context ctx) {
        File gameRoot = new File(ctx.getFilesDir(), "usr/home/virtual_containers");
        if (!gameRoot.isDirectory()) return null;

        File[] gameDirs = gameRoot.listFiles();
        if (gameDirs == null) return null;

        for (File gameDir : gameDirs) {
            String found = findDll(gameDir, 5);
            if (found != null) return found;
        }
        return null;
    }

    private static String findDll(File dir, int maxDepth) {
        if (!dir.isDirectory() || maxDepth <= 0) return null;
        File[] entries = dir.listFiles();
        if (entries == null) return null;
        for (File f : entries) {
            if (f.isFile() && f.getName().equalsIgnoreCase("Lossless.dll")) {
                return f.getAbsolutePath();
            }
        }
        for (File f : entries) {
            if (f.isDirectory()) {
                String found = findDll(f, maxDepth - 1);
                if (found != null) return found;
            }
        }
        return null;
    }

    // ── Single container apply ────────────────────────────────────────────────

    /**
     * Installs or removes the LSFG layer for one specific game container.
     * Call this after the user saves settings in BhLsfgSettingsActivity.
     * Runs synchronously — invoke from a background thread.
     */
    public static boolean applyToContainer(Context ctx, String gameId) {
        File containerRoot = new File(ctx.getFilesDir(), "usr/home/virtual_containers/" + gameId);
        if (!containerRoot.isDirectory()) {
            Log.e(TAG, "container not found: " + containerRoot.getAbsolutePath());
            return false;
        }
        String containerPath = containerRoot.getAbsolutePath();
        String manifestDir   = new File(containerRoot, MANIFEST_SUBDIR).getAbsolutePath();

        boolean enabled = isEnabled(ctx, gameId);
        int     mult    = getMultiplier(ctx, gameId);
        String  flow    = getFlowScale(ctx, gameId);
        boolean perf    = getPerfMode(ctx, gameId);
        String  dllPath = resolveDll(ctx);

        Log.d(TAG, "applyToContainer: game=" + gameId + " enabled=" + enabled
                + " mult=" + mult + " dll=" + dllPath);

        if (enabled && mult > 0) {
            if (ensureRuntimeInstalled(ctx, containerPath)) {
                writeConfig(containerPath, dllPath, mult, flow, perf);
                injectVkLayerEnv(ctx, gameId, manifestDir);
                Log.d(TAG, "applyToContainer: LSFG armed for game=" + gameId);
                return true;
            }
            return false;
        } else {
            removeManifest(containerPath);
            removeVkLayerEnv(ctx, gameId);
            Log.d(TAG, "applyToContainer: LSFG removed for game=" + gameId);
            return true;
        }
    }

    public static void removeManifest(String containerPath) {
        new File(containerPath, MANIFEST_SUBDIR + "/" + MANIFEST_FILE).delete();
    }

    // ── Runtime installation ──────────────────────────────────────────────────

    public static boolean ensureRuntimeInstalled(Context ctx, String containerPath) {
        File root     = new File(containerPath);
        File layerDir = new File(root, MANIFEST_SUBDIR);
        File manifest = new File(layerDir, MANIFEST_FILE);
        File stamp    = new File(layerDir, VERSION_FILE);

        String soAbsPath = ctx.getApplicationInfo().nativeLibraryDir + "/" + LIB_FILENAME;

        String installed = stamp.exists() ? readText(stamp).trim() : "";
        if (RUNTIME_VERSION.equals(installed) && manifest.isFile()) {
            return true;
        }

        try {
            layerDir.mkdirs();

            String manifestText = readAsset(ctx, ASSET_MANIFEST)
                    .replaceAll("\"library_path\":\\s*\"[^\"]*\"",
                                "\"library_path\": \"" + soAbsPath + "\"");
            writeText(manifest, manifestText);
            manifest.setReadable(true, false);

            writeText(stamp, RUNTIME_VERSION);
            Log.d(TAG, "manifest written: " + manifest.getAbsolutePath() + " | so: " + soAbsPath);
            return manifest.isFile();
        } catch (IOException e) {
            Log.e(TAG, "ensureRuntimeInstalled failed for " + containerPath + ": " + e.getMessage());
            return false;
        }
    }

    // ── conf.toml generation ──────────────────────────────────────────────────

    public static boolean writeConfig(String containerPath, String dllPath,
                                      int multiplier, String flowScale, boolean perfMode) {
        File configDir  = new File(containerPath, CONFIG_SUBDIR);
        File configFile = new File(configDir, CONFIG_FILE);
        configDir.mkdirs();

        boolean armed = multiplier > 0 && dllPath != null && !dllPath.isEmpty()
                && new File(dllPath).isFile();

        StringBuilder sb = new StringBuilder();
        sb.append("version = 1\n\n");
        sb.append("[global]\n");
        if (dllPath != null && !dllPath.isEmpty()) {
            sb.append("dll = ").append(tomlStr(dllPath)).append("\n");
        }
        sb.append("no_fp16 = false\n");

        if (armed) {
            for (String exe : WINE_EXE_NAMES) {
                sb.append("\n[[game]]\n");
                sb.append("exe = ").append(tomlStr(exe)).append("\n");
                sb.append("multiplier = ").append(multiplier).append("\n");
                sb.append("flow_scale = ").append(flowScale).append("\n");
                sb.append("performance_mode = ").append(perfMode).append("\n");
                sb.append("hdr_mode = false\n");
                sb.append("experimental_present_mode = \"fifo\"\n");
            }
        }

        try {
            writeText(configFile, sb.toString());
            configFile.setReadable(true, false);
            return true;
        } catch (IOException e) {
            return false;
        }
    }

    // ── Env-var injection ─────────────────────────────────────────────────────

    private static void injectVkLayerEnv(Context ctx, String gameId, String manifestDir) {
        SharedPreferences sp = ctx.getSharedPreferences("pc_g_setting" + gameId, Context.MODE_PRIVATE);
        String current = sp.getString(ENV_PREFS_KEY, "").trim();
        StringBuilder kept = new StringBuilder();
        for (String part : current.split(",")) {
            String t = part.trim();
            if (!t.isEmpty() && !t.startsWith(ENV_LAYER_PATH) && !t.startsWith(ENV_LAYER_NAME)) {
                if (kept.length() > 0) kept.append(",");
                kept.append(t);
            }
        }
        if (kept.length() > 0) kept.append(",");
        kept.append(ENV_LAYER_PATH).append(manifestDir);
        kept.append(",").append(ENV_LAYER_NAME).append("VK_LAYER_LS_frame_generation");
        String envValue = kept.toString();
        sp.edit().putString(ENV_PREFS_KEY, envValue).apply();
        Log.d(TAG, "env injected game=" + gameId + " | " + envValue);
    }

    private static void removeVkLayerEnv(Context ctx, String gameId) {
        SharedPreferences sp = ctx.getSharedPreferences("pc_g_setting" + gameId, Context.MODE_PRIVATE);
        String current = sp.getString(ENV_PREFS_KEY, "").trim();
        if (current.isEmpty()) return;
        StringBuilder kept = new StringBuilder();
        for (String part : current.split(",")) {
            String t = part.trim();
            if (!t.isEmpty() && !t.startsWith(ENV_LAYER_PATH) && !t.startsWith(ENV_LAYER_NAME)) {
                if (kept.length() > 0) kept.append(",");
                kept.append(t);
            }
        }
        sp.edit().putString(ENV_PREFS_KEY, kept.toString()).apply();
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private static String tomlStr(String value) {
        return "\"" + value.replace("\\", "\\\\").replace("\"", "\\\"") + "\"";
    }

    private static String readAsset(Context ctx, String assetPath) throws IOException {
        try (InputStream in = ctx.getAssets().open(assetPath)) {
            byte[] bytes = new byte[in.available()];
            //noinspection ResultOfMethodCallIgnored
            in.read(bytes);
            return new String(bytes, "UTF-8");
        }
    }

    private static String readText(File f) {
        try (java.io.FileInputStream fis = new java.io.FileInputStream(f)) {
            byte[] bytes = new byte[(int) f.length()];
            //noinspection ResultOfMethodCallIgnored
            fis.read(bytes);
            return new String(bytes, "UTF-8");
        } catch (IOException e) {
            return "";
        }
    }

    private static void writeText(File f, String text) throws IOException {
        try (FileOutputStream out = new FileOutputStream(f)) {
            out.write(text.getBytes("UTF-8"));
        }
    }
}
