package app.revanced.extension.gamehub;

import android.app.Activity;
import android.content.SharedPreferences;
import android.util.Log;

/**
 * Bridges GogGamesActivity (separate Activity) back to LandscapeLauncherMainActivity
 * so that EditImportedGameInfoDialog is fired automatically after a GOG game installs.
 *
 * Flow:
 *   1. GogGamesActivity.onComplete() calls triggerLaunch(activity, exePath)
 *      → saves pending_gog_exe to SharedPrefs + calls activity.finish()
 *   2. LandscapeLauncherMainActivity.onResume() calls checkPendingLaunch(activity)
 *      → reads pending_gog_exe, invokes g3(exePath) via reflection, clears pref
 *      → g3() opens EditImportedGameInfoDialog with the exe path pre-filled
 */
public final class GogLaunchHelper {

    private static final String TAG = "BannerHub";
    private static final String PREF_PENDING = "pending_gog_exe";

    private GogLaunchHelper() {}

    /**
     * Called from GogGamesActivity when a game finishes installing.
     * Stores the exe path for pickup by LandscapeLauncherMainActivity.onResume()
     * and returns to the main activity.
     */
    public static void triggerLaunch(Activity activity, String exePath) {
        activity.getSharedPreferences("bh_gog_prefs", 0)
                .edit()
                .putString(PREF_PENDING, exePath)
                .apply();
        activity.finish();
    }

    /**
     * Called from LandscapeLauncherMainActivity.onResume() via smali injection.
     * If a pending exe path is stored, invokes g3(exePath) to open
     * EditImportedGameInfoDialog with the path pre-filled, then clears the pref.
     */
    public static void checkPendingLaunch(Activity activity) {
        SharedPreferences prefs = activity.getSharedPreferences("bh_gog_prefs", 0);
        String exe = prefs.getString(PREF_PENDING, null);
        if (exe == null || exe.isEmpty()) return;

        prefs.edit().remove(PREF_PENDING).apply();
        try {
            activity.getClass().getMethod("B3", String.class).invoke(activity, exe);
            Log.d(TAG, "GogLaunchHelper: B3 called with " + exe);
        } catch (Exception e) {
            Log.e(TAG, "GogLaunchHelper: B3 call failed", e);
        }
    }
}
