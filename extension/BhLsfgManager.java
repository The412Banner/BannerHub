package app.revanced.extension.gamehub;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Manages LSFG-VK (Lossless Scaling Frame Generation) Vulkan implicit layer
 * for Wine containers in BannerHub.
 *
 * The layer intercepts vkQueuePresentKHR inside the Wine process and runs
 * frame generation transparently — no overlay or MediaProjection needed.
 *
 * Flow:
 *   1. User configures settings in BhLsfgSettingsActivity (saved to prefs).
 *   2. At Wine launch time (smali injection in WinEmuServiceImpl), call
 *      ensureRuntimeInstalled() + writeConfig() with the container path.
 *   3. The Vulkan loader finds the implicit layer manifest and loads the .so.
 *   4. The layer reads conf.toml from ~/.config/lsfg-vk/ and activates.
 *
 * Asset layout (bundled in APK):
 *   assets/lsfg_vk/liblsfg-vk-layer.so
 *   assets/lsfg_vk/VkLayer_LS_frame_generation.json
 */
public class BhLsfgManager {

    public static final String PREFS = "bh_lsfg_prefs";

    public static final String KEY_ENABLED      = "lsfg_enabled";
    public static final String KEY_DLL_PATH     = "lsfg_dll_path";
    public static final String KEY_MULTIPLIER   = "lsfg_multiplier";   // 0=off, 2, 3, or 4
    public static final String KEY_FLOW_SCALE   = "lsfg_flow_scale";   // "1.00", "0.75", etc.
    public static final String KEY_PERF_MODE    = "lsfg_perf_mode";

    // Asset paths (relative to assets/)
    private static final String ASSET_MANIFEST = "lsfg_vk/VkLayer_LS_frame_generation.json";

    // The .so is packaged in lib/arm64-v8a/ and extracted by Android to nativeLibraryDir.
    private static final String LIB_FILENAME    = "liblsfg-vk-layer.so";
    private static final String MANIFEST_SUBDIR = ".local/share/vulkan/implicit_layer.d";
    private static final String MANIFEST_FILE   = "VkLayer_LS_frame_generation.json";
    private static final String CONFIG_SUBDIR   = ".config/lsfg-vk";
    private static final String CONFIG_FILE     = "conf.toml";
    private static final String VERSION_FILE    = ".lsfg_vk_version";

    // SharedPreferences key used by GameHub to pass env vars into the Wine process.
    private static final String ENV_PREFS_KEY  = "pc_ls_environment_variable";
    private static final String ENV_LAYER_PATH = "VK_LAYER_PATH=";
    private static final String ENV_LAYER_NAME = "VK_INSTANCE_LAYERS=";

    // Bump this whenever the bundled .so changes so containers auto-reinstall.
    private static final String RUNTIME_VERSION = "v1.4.0-android-arm64-v8a-ahb";

    private static final String TAG = "BhLsfg";

    // Wine process exe names the layer config will match.
    // wine64-preloader is the standard loader; wineloader is the Bionic variant.
    private static final String[] WINE_EXE_NAMES = { "wine64-preloader", "wineloader", "wine64" };

    // ── Prefs accessors ──────────────────────────────────────────────────────

    public static boolean isEnabled(Context ctx) {
        return prefs(ctx).getBoolean(KEY_ENABLED, false);
    }

    public static String getDllPath(Context ctx) {
        return prefs(ctx).getString(KEY_DLL_PATH, "");
    }

    public static int getMultiplier(Context ctx) {
        int m = prefs(ctx).getInt(KEY_MULTIPLIER, 2);
        return (m == 0) ? 0 : Math.max(2, Math.min(4, m));
    }

    public static String getFlowScale(Context ctx) {
        return prefs(ctx).getString(KEY_FLOW_SCALE, "1.00");
    }

    public static boolean getPerfMode(Context ctx) {
        return prefs(ctx).getBoolean(KEY_PERF_MODE, false);
    }

    /** True when enabled, multiplier > 0, and Lossless.dll exists at the stored path. */
    public static boolean isArmed(Context ctx) {
        if (!isEnabled(ctx)) return false;
        if (getMultiplier(ctx) == 0) return false;
        String dll = resolveDll(ctx);
        return dll != null;
    }

    // ── DLL discovery ────────────────────────────────────────────────────────

    /**
     * Returns the Lossless.dll path to use. Checks:
     *   1. Stored user path (browsed or previously auto-detected).
     *   2. Auto-scan of Wine game install directories.
     * Returns null if not found.
     */
    public static String resolveDll(Context ctx) {
        String stored = getDllPath(ctx);
        if (!stored.isEmpty() && new File(stored).isFile()) return stored;
        return autoDiscoverDll(ctx);
    }

    /**
     * Scans Wine container home dirs for Lossless.dll.
     * Containers live at <filesDir>/usr/home/virtual_containers/<id>/.
     */
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

    /** Recursive DFS search for Lossless.dll, limited to maxDepth levels. */
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

    // ── Bulk container operations ────────────────────────────────────────────

    /**
     * Applies the current LSFG settings to every Wine container on the device.
     * Call this after the user saves settings in BhLsfgSettingsActivity.
     * Runs the install/delete on the calling thread — invoke from a background thread.
     *
     * @return number of containers successfully updated
     */
    public static int applyToAllContainers(Context ctx) {
        File gameRoot = new File(ctx.getFilesDir(), "usr/home/virtual_containers");
        if (!gameRoot.isDirectory()) return 0;

        File[] containers = gameRoot.listFiles();
        if (containers == null) return 0;

        boolean enabled   = isEnabled(ctx);
        String  dllPath   = resolveDll(ctx);
        int     mult      = getMultiplier(ctx);
        String  flow      = getFlowScale(ctx);
        boolean perf      = getPerfMode(ctx);

        Log.d(TAG, "applyToAllContainers: enabled=" + enabled + " mult=" + mult + " dll=" + dllPath);
        int updated = 0;
        for (File c : containers) {
            if (!c.isDirectory()) continue;
            String cPath   = c.getAbsolutePath();
            String gameId  = c.getName();
            String manifestDir = new File(c, MANIFEST_SUBDIR).getAbsolutePath();
            if (enabled && mult > 0) {
                if (ensureRuntimeInstalled(ctx, cPath)) {
                    writeConfig(cPath, dllPath, mult, flow, perf);
                    injectVkLayerEnv(ctx, gameId, manifestDir);
                    updated++;
                }
            } else {
                removeManifest(cPath);
                removeVkLayerEnv(ctx, gameId);
                updated++;
            }
        }
        Log.d(TAG, "applyToAllContainers: updated " + updated + "/" + containers.length + " containers");
        return updated;
    }

    /** Deletes the Vulkan implicit layer manifest from a container, disabling the layer. */
    public static void removeManifest(String containerPath) {
        new File(containerPath, MANIFEST_SUBDIR + "/" + MANIFEST_FILE).delete();
    }

    // ── Runtime installation ─────────────────────────────────────────────────

    /**
     * Copies the prebuilt liblsfg-vk-layer.so and manifest into the container.
     * Skips if already up-to-date (version stamp matches).
     *
     * @param containerPath  result of IEmuContainer.c() / IWinEmuService.h(gameId).c()
     * @return true if installed/already current; false on failure
     */
    public static boolean ensureRuntimeInstalled(Context ctx, String containerPath) {
        File root     = new File(containerPath);
        File layerDir = new File(root, MANIFEST_SUBDIR);
        File manifest = new File(layerDir, MANIFEST_FILE);
        File stamp    = new File(layerDir, VERSION_FILE);

        // The .so is extracted by Android's package manager to nativeLibraryDir.
        String soAbsPath = ctx.getApplicationInfo().nativeLibraryDir + "/" + LIB_FILENAME;

        String installed = stamp.exists() ? readText(stamp).trim() : "";
        if (RUNTIME_VERSION.equals(installed) && manifest.isFile()) {
            return true; // already current
        }

        try {
            layerDir.mkdirs();

            // Rewrite library_path to the absolute APK native-lib path so Android's
            // Vulkan loader can dlopen it from a non-debuggable process.
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

    // ── conf.toml generation ─────────────────────────────────────────────────

    /**
     * Writes (or overwrites) conf.toml into the container's ~/.config/lsfg-vk/.
     * The Vulkan loader finds the manifest automatically; the layer then reads
     * this config from the default $HOME/.config/lsfg-vk/ path.
     *
     * @param containerPath  result of IEmuContainer.c()
     * @param dllPath        absolute path to Lossless.dll; null disables the layer
     * @param multiplier     2, 3, or 4 (0 means disabled)
     * @param flowScale      "1.00", "0.75", "0.50", or "0.25"
     * @param perfMode       true = performance quality mode
     * @return true on success
     */
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
            // Write one [[game]] entry per known Wine exe name so the layer
            // activates regardless of which Wine variant the container uses.
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

    // ── Env-var injection ────────────────────────────────────────────────────

    /**
     * Writes VK_LAYER_PATH + VK_INSTANCE_LAYERS into the per-game GameHub prefs so
     * Android's libvulkan.so finds and loads the LSFG implicit layer inside the Wine
     * process at game launch. Preserves any other env vars the user has set.
     */
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

    /** Strips LSFG env vars from per-game prefs, leaving any other user env vars intact. */
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

    // ── Helpers ──────────────────────────────────────────────────────────────

    private static SharedPreferences prefs(Context ctx) {
        return ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
    }

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
