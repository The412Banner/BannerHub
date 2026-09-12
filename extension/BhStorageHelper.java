package app.revanced.extension.gamehub;

import android.content.Context;
import android.content.SharedPreferences;
import android.widget.Toast;

import java.io.File;

/**
 * BannerHub-only storage prefs. Decoupled from GameHub's native steam_storage_pref so
 * that the "Save Store Games to External Storage (SD Card)" toggle only affects
 * GOG/Epic/Amazon, never Steam.
 */
public final class BhStorageHelper {

    public static final String PREFS = "bh_storage_pref";
    public static final String KEY_USE_CUSTOM = "bh_use_custom_storage";
    public static final String KEY_PATH = "bh_storage_path";
    public static final String KEY_DIALOG_SHOWN = "bh_storage_migration_dialog_shown";

    private BhStorageHelper() {}

    /**
     * Apply the toggle. Returns the actual on/off state after applying — when enabling
     * with no SD card available, falls back to off and shows a toast (mirrors the
     * behavior the user got from GameHub's native handler before).
     */
    public static boolean applyToggle(Context ctx, boolean enable) {
        SharedPreferences prefs = ctx.getSharedPreferences(PREFS, 0);
        if (!enable) {
            prefs.edit()
                    .putBoolean(KEY_USE_CUSTOM, false)
                    .remove(KEY_PATH)
                    .apply();
            return false;
        }
        String sdRoot = autoDetectSDCardRoot(ctx);
        if (sdRoot == null) {
            Toast.makeText(ctx, "No SD card found", Toast.LENGTH_SHORT).show();
            return false;
        }
        prefs.edit()
                .putBoolean(KEY_USE_CUSTOM, true)
                .putString(KEY_PATH, sdRoot)
                .apply();
        return true;
    }

    /**
     * Walk all app-specific external directories, skip primary shared storage, and
     * derive the removable-volume root by stripping the /Android/data suffix.
     * Accept the card when its bannerhub directory is writable, creating that
     * directory when necessary so detection does not depend on a GHL marker.
     */
    private static String autoDetectSDCardRoot(Context ctx) {
        try {
            File[] dirs = ctx.getExternalFilesDirs(null);
            if (dirs == null) return null;
            for (File d : dirs) {
                if (d == null) continue;
                String abs = d.getAbsolutePath();
                int idx = abs.indexOf("/Android/data");
                if (idx < 0) continue;
                String root = abs.substring(0, idx);
                File rootDir = new File(root);
                File primaryDir = ctx.getExternalFilesDir(null);
                if (!rootDir.exists() || !rootDir.isDirectory()) continue;
                if (primaryDir != null
                        && abs.equals(primaryDir.getAbsolutePath())) continue;

                File bannerHubDir = new File(rootDir, "bannerhub");
                if ((bannerHubDir.exists()
                        && bannerHubDir.isDirectory()
                        && bannerHubDir.canWrite())
                        || (!bannerHubDir.exists() && bannerHubDir.mkdirs())) {
                    return root;
                }
            }
        } catch (Exception ignored) {}
        return null;
    }
}
