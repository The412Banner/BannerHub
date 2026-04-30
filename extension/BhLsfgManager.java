package app.revanced.extension.gamehub;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
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

    // Shared DLL stored once in app files; all games auto-use it
    private static final String SHARED_DLL_DIR  = "lsfg";
    private static final String SHARED_DLL_NAME = "Lossless.dll";

    // Asset paths (relative to assets/)
    private static final String ASSET_MANIFEST = "lsfg_vk/VkLayer_LS_frame_generation.json";

    private static final String LIB_FILENAME = "liblsfg-vk-layer.so";

    // Container-relative paths (all relative to container root)
    // .so lives here so the path is stable across APK reinstalls
    private static final String LIB_SUBDIR      = ".local/lib";
    private static final String MANIFEST_SUBDIR = ".local/share/vulkan/implicit_layer.d";
    private static final String MANIFEST_FILE   = "VkLayer_LS_frame_generation.json";
    // Relative path from manifest dir back to lib dir (3 levels up from implicit_layer.d)
    private static final String MANIFEST_LIB_PATH = "../../../lib/" + LIB_FILENAME;
    private static final String DLL_SUBDIR      = ".local/share/lsfg-vk";
    private static final String CONFIG_SUBDIR   = ".config/lsfg-vk";
    private static final String CONFIG_FILE     = "conf.toml";
    private static final String VERSION_FILE    = ".lsfg_vk_version";

    // Version bump forces manifest + .so to be re-copied whenever this changes
    private static final String RUNTIME_VERSION = "v1.4.0-android-arm64-v8a-ahb-r2";

    // SharedPrefs key used by WinEmu to apply extra env vars at launch
    private static final String ENV_PREFS_KEY  = "pc_ls_environment_variable";
    private static final String ENV_LAYER_PATH = "VK_LAYER_PATH=";
    private static final String ENV_TMPDIR     = "TMPDIR=";

    private static final String TAG = "BhLsfg";

    // ── Shared DLL ────────────────────────────────────────────────────────────

    public static File getSharedDllFile(Context ctx) {
        return new File(ctx.getFilesDir(), SHARED_DLL_DIR + "/" + SHARED_DLL_NAME);
    }

    public static boolean copyDllToShared(Context ctx, String sourcePath) {
        File src = new File(sourcePath);
        if (!src.isFile()) return false;
        File dst = getSharedDllFile(ctx);
        dst.getParentFile().mkdirs();
        try (FileInputStream in = new FileInputStream(src);
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

    public static boolean applyToContainer(Context ctx, String gameId) {
        File containerRoot = new File(ctx.getFilesDir(), "usr/home/virtual_containers/" + gameId);
        if (!containerRoot.isDirectory()) {
            Log.e(TAG, "container not found: " + containerRoot.getAbsolutePath());
            return false;
        }
        String containerPath = containerRoot.getAbsolutePath();

        boolean enabled = isEnabled(ctx, gameId);
        int     mult    = getMultiplier(ctx, gameId);
        String  flow    = getFlowScale(ctx, gameId);
        boolean perf    = getPerfMode(ctx, gameId);
        String  srcDll  = resolveDll(ctx);

        Log.d(TAG, "applyToContainer: game=" + gameId + " enabled=" + enabled
                + " mult=" + mult + " dll=" + srcDll);

        if (enabled && mult > 0) {
            // Copy Lossless.dll into the container so the path is stable
            String containerDll = null;
            if (srcDll != null) {
                containerDll = copyDllToContainer(containerPath, srcDll);
            }
            if (ensureRuntimeInstalled(ctx, containerPath)) {
                writeConfig(containerPath, containerDll, mult, flow, perf);
                injectVkLayerEnv(ctx, gameId, containerPath);
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

    /**
     * Copies Lossless.dll from the Android-side shared location into the container's
     * .local/share/lsfg-vk/ so the LSFG layer can find it via a stable path.
     * Returns the absolute path of the copy, or null on failure.
     */
    private static String copyDllToContainer(String containerPath, String srcDllPath) {
        File src = new File(srcDllPath);
        if (!src.isFile()) return null;
        File dstDir = new File(containerPath, DLL_SUBDIR);
        dstDir.mkdirs();
        File dst = new File(dstDir, SHARED_DLL_NAME);
        try (FileInputStream in = new FileInputStream(src);
             FileOutputStream out = new FileOutputStream(dst)) {
            byte[] buf = new byte[65536];
            int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
            dst.setReadable(true, false);
            Log.d(TAG, "DLL copied to container: " + dst.getAbsolutePath());
            return dst.getAbsolutePath();
        } catch (IOException e) {
            Log.e(TAG, "copyDllToContainer failed: " + e.getMessage());
            return null;
        }
    }

    public static void removeManifest(String containerPath) {
        new File(containerPath, MANIFEST_SUBDIR + "/" + MANIFEST_FILE).delete();
    }

    // ── Runtime installation ──────────────────────────────────────────────────

    /**
     * Installs the Vulkan layer into the container's filesystem:
     *   .so  → <container>/.local/lib/liblsfg-vk-layer.so
     *   JSON → <container>/.local/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json
     *
     * The .so is copied from nativeLibraryDir so the manifest can use a stable relative
     * path (../../../lib/liblsfg-vk-layer.so) that won't break after APK reinstalls.
     * HOME is set to the container root by WinEmu, so Turnip's Vulkan loader finds the
     * manifest automatically via $HOME/.local/share/vulkan/implicit_layer.d/.
     */
    public static boolean ensureRuntimeInstalled(Context ctx, String containerPath) {
        File containerRoot = new File(containerPath);
        File libDir   = new File(containerRoot, LIB_SUBDIR);
        File layerDir = new File(containerRoot, MANIFEST_SUBDIR);
        File soFile   = new File(libDir, LIB_FILENAME);
        File manifest = new File(layerDir, MANIFEST_FILE);
        File stamp    = new File(layerDir, VERSION_FILE);

        String installed = stamp.exists() ? readText(stamp).trim() : "";
        if (RUNTIME_VERSION.equals(installed) && manifest.isFile() && soFile.isFile()) {
            return true;
        }

        try {
            libDir.mkdirs();
            layerDir.mkdirs();

            // Copy .so from nativeLibraryDir into the container's own lib dir
            String nativeLibDir = ctx.getApplicationInfo().nativeLibraryDir;
            File srcSo = new File(nativeLibDir, LIB_FILENAME);
            if (!srcSo.isFile()) {
                Log.e(TAG, "liblsfg-vk-layer.so not found in nativeLibraryDir: " + nativeLibDir);
                return false;
            }
            copyFile(srcSo, soFile);
            soFile.setReadable(true, false);
            soFile.setExecutable(true, false);
            Log.d(TAG, "liblsfg-vk-layer.so copied to: " + soFile.getAbsolutePath());

            // Write manifest with relative library_path so it survives APK reinstalls
            String manifestText = readAsset(ctx, ASSET_MANIFEST)
                    .replaceAll("\"library_path\":\\s*\"[^\"]*\"",
                                "\"library_path\": \"" + MANIFEST_LIB_PATH + "\"");
            writeText(manifest, manifestText);
            manifest.setReadable(true, false);

            writeText(stamp, RUNTIME_VERSION);
            Log.d(TAG, "manifest written: " + manifest.getAbsolutePath()
                    + " | lib_path: " + MANIFEST_LIB_PATH);
            return manifest.isFile();
        } catch (IOException e) {
            Log.e(TAG, "ensureRuntimeInstalled failed for " + containerPath + ": " + e.getMessage());
            return false;
        }
    }

    // ── conf.toml generation ──────────────────────────────────────────────────

    public static boolean writeConfig(String containerPath, String containerDllPath,
                                      int multiplier, String flowScale, boolean perfMode) {
        File configDir  = new File(containerPath, CONFIG_SUBDIR);
        File configFile = new File(configDir, CONFIG_FILE);
        configDir.mkdirs();

        boolean hasDll = containerDllPath != null && !containerDllPath.isEmpty()
                && new File(containerDllPath).isFile();
        boolean armed = multiplier > 0 && hasDll;

        StringBuilder sb = new StringBuilder();
        sb.append("version = 1\n\n");
        sb.append("[global]\n");
        if (hasDll) {
            sb.append("dll = ").append(tomlStr(containerDllPath)).append("\n");
        }
        sb.append("no_fp16 = false\n");

        if (armed) {
            // One entry per Wine process name that may own the Vulkan swapchain
            for (String exe : new String[]{"wine64-preloader", "wine64", "wineloader"}) {
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

    /**
     * Injects LSFG env vars into the per-game SharedPrefs key that WinEmu applies at launch.
     * - VK_LAYER_PATH: points Vulkan loader to our per-game implicit_layer.d
     * - TMPDIR: the layer writes /tmp/lsfg-vk_last; if /tmp is missing it calls exit()
     *
     * We do NOT set LSFG_PROCESS or VK_INSTANCE_LAYERS — the layer activates via
     * implicit layer discovery + conf.toml exe matching, same as GameNative.
     */
    private static void injectVkLayerEnv(Context ctx, String gameId, String containerPath) {
        String manifestDir = new File(containerPath, MANIFEST_SUBDIR).getAbsolutePath();
        File tmpDirFile    = new File(containerPath, "tmp");
        tmpDirFile.mkdirs();
        String tmpDir = tmpDirFile.getAbsolutePath();

        SharedPreferences sp = ctx.getSharedPreferences("pc_g_setting" + gameId, Context.MODE_PRIVATE);
        String current = sp.getString(ENV_PREFS_KEY, "").trim();

        StringBuilder kept = new StringBuilder();
        for (String part : current.split(",")) {
            String t = part.trim();
            if (!t.isEmpty()
                    && !t.startsWith(ENV_LAYER_PATH)
                    && !t.startsWith(ENV_TMPDIR)
                    && !t.startsWith("LSFG_PROCESS=")
                    && !t.startsWith("VK_INSTANCE_LAYERS=")) {
                if (kept.length() > 0) kept.append(",");
                kept.append(t);
            }
        }
        if (kept.length() > 0) kept.append(",");
        kept.append(ENV_LAYER_PATH).append(manifestDir);
        kept.append(",").append(ENV_TMPDIR).append(tmpDir);

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
            if (!t.isEmpty()
                    && !t.startsWith(ENV_LAYER_PATH)
                    && !t.startsWith(ENV_TMPDIR)
                    && !t.startsWith("LSFG_PROCESS=")
                    && !t.startsWith("VK_INSTANCE_LAYERS=")) {
                if (kept.length() > 0) kept.append(",");
                kept.append(t);
            }
        }
        sp.edit().putString(ENV_PREFS_KEY, kept.toString()).apply();
    }

    // ── Context unwrapping ────────────────────────────────────────────────────

    public static String getGameIdFromContext(Context ctx) {
        Context c = ctx;
        while (c != null) {
            try {
                java.lang.reflect.Field uField = c.getClass().getDeclaredField("u");
                uField.setAccessible(true);
                Object data = uField.get(c);
                if (data != null) {
                    java.lang.reflect.Field aField = data.getClass().getDeclaredField("a");
                    aField.setAccessible(true);
                    Object id = aField.get(data);
                    if (id instanceof String && !((String) id).isEmpty()) {
                        Log.d(TAG, "getGameIdFromContext: gameId=" + id);
                        return (String) id;
                    }
                }
            } catch (Exception ignored) {}
            if (c instanceof android.content.ContextWrapper) {
                c = ((android.content.ContextWrapper) c).getBaseContext();
            } else {
                break;
            }
        }
        Log.e(TAG, "getGameIdFromContext: gameId not found");
        return null;
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
        try (FileInputStream fis = new FileInputStream(f)) {
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

    private static void copyFile(File src, File dst) throws IOException {
        try (FileInputStream in = new FileInputStream(src);
             FileOutputStream out = new FileOutputStream(dst)) {
            byte[] buf = new byte[65536];
            int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
        }
    }
}
