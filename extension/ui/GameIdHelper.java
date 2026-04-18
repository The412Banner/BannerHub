package app.revanced.extension.gamehub.ui;

import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;
import app.revanced.extension.gamehub.util.GHLog;

public class GameIdHelper {

    public static void populateGameId(Activity activity) {
        try {
            Bundle extras = activity.getIntent().getExtras();
            if (extras == null) return;

            String steamAppId = extras.getString("steamAppId", "");
            String localGameId = extras.getString("localGameId", "");

            // Resolve the actual settings key — mirrors BhExportLambda logic:
            // catalog games store settings under the numeric "id" extra (same as getId() > 0 path),
            // locally-added games use localGameId.
            // Showing the correct key here means users configure Beacon with the right value.
            String intentId = extras.getString("id", "0");
            String bhId = (!intentId.isEmpty() && !"0".equals(intentId)) ? intentId : localGameId;

            boolean hasSteamId = !steamAppId.isEmpty() && !"0".equals(steamAppId);
            boolean hasBhId    = !bhId.isEmpty()       && !"0".equals(bhId);

            if (!hasSteamId && !hasBhId) return;

            int containerId = resolveId(activity, "ll_game_id_container");
            if (containerId == 0) return;
            View container = activity.findViewById(containerId);
            if (container == null) return;
            container.setVisibility(View.VISIBLE);

            if (hasSteamId) {
                setupCopyableText(activity, "tv_steam_app_id",
                        "Steam App ID: " + steamAppId, steamAppId, "Steam App ID");
            }
            if (hasBhId) {
                setupCopyableText(activity, "tv_local_game_id",
                        "Launcher ID: " + bhId, bhId, "Launcher ID");
            }
        } catch (Exception e) {
            GHLog.GAME_ID.w("populateGameId failed", e);
        }
    }

    private static void setupCopyableText(final Activity activity, String viewName,
            String displayText, final String copyValue, final String label) {
        int id = resolveId(activity, viewName);
        if (id == 0) return;
        TextView tv = (TextView) activity.findViewById(id);
        if (tv == null) return;
        tv.setText(displayText);
        tv.setVisibility(View.VISIBLE);
        tv.setOnClickListener(view -> {
            ClipboardManager cm = (ClipboardManager) activity.getSystemService("clipboard");
            if (cm != null) {
                cm.setPrimaryClip(ClipData.newPlainText(label, copyValue));
                Toast.makeText(activity, label + " copied!", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private static int resolveId(Activity activity, String name) {
        return activity.getResources().getIdentifier(name, "id", activity.getPackageName());
    }
}
