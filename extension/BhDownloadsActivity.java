package app.revanced.extension.gamehub;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/** In-progress downloads and persistent installed-game library across all three stores. */
public class BhDownloadsActivity extends Activity {

    private final Handler uiHandler = new Handler(Looper.getMainLooper());
    private LinearLayout listLayout;
    private TextView emptyTV;
    // rows[0]=card, rows[1]=ProgressBar, rows[2]=labelTV
    private final Map<String, View[]> rows          = new ConcurrentHashMap<>();
    // completedRows[0]=card only
    private final Map<String, View[]> completedRows = new ConcurrentHashMap<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        buildUi();
    }

    @Override
    protected void onResume() {
        super.onResume();
        // Load persisted completed library entries
        for (BhDownloadService.LibraryEntry entry : BhDownloadService.getLibrary(this)) {
            if (!completedRows.containsKey(entry.dlKey) && !rows.containsKey(entry.dlKey)) {
                addCompletedRow(entry);
            }
        }
        // Reconnect any already-running downloads
        for (String gameId : BhDownloadService.getActiveJobs()) {
            if (!rows.containsKey(gameId)) {
                String name = BhDownloadService.getGameName(gameId);
                String msg  = BhDownloadService.getLastMsg(gameId);
                int    pct  = BhDownloadService.getLastPct(gameId);
                addRow(gameId, name, msg, pct);
            }
        }
        updateEmptyState();
        BhDownloadService.addGlobalListener(globalListener);
    }

    @Override
    protected void onPause() {
        super.onPause();
        BhDownloadService.removeGlobalListener(globalListener);
    }

    private final BhDownloadService.GlobalListener globalListener = new BhDownloadService.GlobalListener() {
        @Override public void onAnyProgress(String gameId, String gameName, String msg, int pct) {
            uiHandler.post(() -> {
                if (!rows.containsKey(gameId)) {
                    addRow(gameId, gameName, msg, pct);
                    updateEmptyState();
                } else {
                    View[] row = rows.get(gameId);
                    ((ProgressBar) row[1]).setProgress(pct);
                    ((TextView)    row[2]).setText(msg);
                }
            });
        }
        @Override public void onAnyComplete(String gameId, String gameName) {
            uiHandler.post(() -> {
                removeRow(gameId);
                BhDownloadService.LibraryEntry entry =
                        BhDownloadService.getLibraryEntry(BhDownloadsActivity.this, gameId);
                if (entry != null && !completedRows.containsKey(gameId)) {
                    addCompletedRow(entry);
                }
                updateEmptyState();
            });
        }
        @Override public void onAnyError(String gameId, String msg) {
            uiHandler.post(() -> {
                View[] row = rows.get(gameId);
                if (row != null) ((TextView) row[2]).setText("Error: " + msg);
                uiHandler.postDelayed(() -> { removeRow(gameId); updateEmptyState(); }, 3000);
            });
        }
        @Override public void onAnyCancelled(String gameId) {
            uiHandler.post(() -> { removeRow(gameId); updateEmptyState(); });
        }
    };

    // ── UI ────────────────────────────────────────────────────────────────────

    private void buildUi() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0D0D0D);

        // Header
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.HORIZONTAL);
        header.setBackgroundColor(0xFF1A1A2E);
        header.setGravity(Gravity.CENTER_VERTICAL);
        header.setPadding(dp(8), dp(8), dp(8), dp(8));

        Button backBtn = makeBtn("←", 0xFF333333);
        backBtn.setOnClickListener(v -> finish());
        header.addView(backBtn, new LinearLayout.LayoutParams(-2, dp(40)));

        TextView titleTV = new TextView(this);
        titleTV.setText("Downloads & Library");
        titleTV.setTextColor(0xFFFFFFFF);
        titleTV.setTextSize(16f);
        titleTV.setTypeface(null, Typeface.BOLD);
        titleTV.setPadding(dp(12), 0, 0, 0);
        header.addView(titleTV, new LinearLayout.LayoutParams(0, -2, 1f));

        Button clearBtn = makeBtn("Clear ✓", 0xFF333333);
        clearBtn.setTextSize(11f);
        clearBtn.setOnClickListener(v -> clearCompleted());
        LinearLayout.LayoutParams clearLp = new LinearLayout.LayoutParams(-2, dp(40));
        clearLp.leftMargin = dp(6);
        header.addView(clearBtn, clearLp);

        root.addView(header, new LinearLayout.LayoutParams(-1, -2));

        // List
        ScrollView scrollView = new ScrollView(this);
        listLayout = new LinearLayout(this);
        listLayout.setOrientation(LinearLayout.VERTICAL);
        listLayout.setPadding(dp(8), dp(8), dp(8), dp(8));

        emptyTV = new TextView(this);
        emptyTV.setText("No downloads or installed games");
        emptyTV.setTextColor(0xFF888888);
        emptyTV.setTextSize(16f);
        emptyTV.setGravity(Gravity.CENTER);
        emptyTV.setPadding(dp(16), dp(40), dp(16), dp(40));
        listLayout.addView(emptyTV, new LinearLayout.LayoutParams(-1, -2));

        scrollView.addView(listLayout, new LinearLayout.LayoutParams(-1, -2));
        root.addView(scrollView, new LinearLayout.LayoutParams(-1, 0, 1f));
        setContentView(root);
    }

    // ── Active download row ───────────────────────────────────────────────────

    private void addRow(String gameId, String gameName, String msg, int pct) {
        if (rows.containsKey(gameId)) return;

        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        GradientDrawable cardBg = new GradientDrawable();
        cardBg.setColor(0xFF1A1A2E);
        cardBg.setCornerRadius(dp(8));
        card.setBackground(cardBg);
        card.setPadding(dp(14), dp(12), dp(14), dp(12));

        LinearLayout.LayoutParams cardLp = new LinearLayout.LayoutParams(-1, -2);
        cardLp.setMargins(0, 0, 0, dp(10));

        LinearLayout titleRow = new LinearLayout(this);
        titleRow.setOrientation(LinearLayout.HORIZONTAL);
        titleRow.setGravity(Gravity.CENTER_VERTICAL);

        TextView nameTV = new TextView(this);
        nameTV.setText(gameName);
        nameTV.setTextColor(0xFFFFFFFF);
        nameTV.setTextSize(15f);
        nameTV.setTypeface(null, Typeface.BOLD);
        titleRow.addView(nameTV, new LinearLayout.LayoutParams(0, -2, 1f));

        Button cancelBtn = makeBtn("Cancel", 0xFF8B0000);
        cancelBtn.setTextSize(12f);
        cancelBtn.setOnClickListener(v -> BhDownloadService.cancel(this, gameId));
        titleRow.addView(cancelBtn, new LinearLayout.LayoutParams(-2, dp(34)));
        card.addView(titleRow, new LinearLayout.LayoutParams(-1, -2));

        ProgressBar progressBar = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        progressBar.setMax(100);
        progressBar.setProgress(pct);
        LinearLayout.LayoutParams pbLp = new LinearLayout.LayoutParams(-1, dp(8));
        pbLp.setMargins(0, dp(10), 0, dp(4));
        card.addView(progressBar, pbLp);

        TextView labelTV = new TextView(this);
        labelTV.setText(msg);
        labelTV.setTextColor(0xFFAAAAAA);
        labelTV.setTextSize(12f);
        card.addView(labelTV, new LinearLayout.LayoutParams(-1, -2));

        rows.put(gameId, new View[]{card, progressBar, labelTV});
        listLayout.addView(card, cardLp);
    }

    private void removeRow(String gameId) {
        View[] row = rows.remove(gameId);
        if (row != null) listLayout.removeView(row[0]);
    }

    // ── Completed / installed row ─────────────────────────────────────────────

    private void addCompletedRow(BhDownloadService.LibraryEntry entry) {
        if (completedRows.containsKey(entry.dlKey)) return;

        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        GradientDrawable cardBg = new GradientDrawable();
        cardBg.setColor(0xFF111F11);
        cardBg.setCornerRadius(dp(8));
        cardBg.setStroke(dp(1), 0xFF2A4A2A);
        card.setBackground(cardBg);
        card.setPadding(dp(14), dp(12), dp(14), dp(12));

        LinearLayout.LayoutParams cardLp = new LinearLayout.LayoutParams(-1, -2);
        cardLp.setMargins(0, 0, 0, dp(10));

        // Title row: name + store badge + × remove
        LinearLayout titleRow = new LinearLayout(this);
        titleRow.setOrientation(LinearLayout.HORIZONTAL);
        titleRow.setGravity(Gravity.CENTER_VERTICAL);

        TextView nameTV = new TextView(this);
        nameTV.setText(entry.name);
        nameTV.setTextColor(0xFFFFFFFF);
        nameTV.setTextSize(15f);
        nameTV.setTypeface(null, Typeface.BOLD);
        nameTV.setMaxLines(1);
        nameTV.setEllipsize(android.text.TextUtils.TruncateAt.END);
        titleRow.addView(nameTV, new LinearLayout.LayoutParams(0, -2, 1f));

        TextView storeBadge = new TextView(this);
        storeBadge.setText(entry.store);
        storeBadge.setTextColor(0xFFFFFFFF);
        storeBadge.setTextSize(9f);
        storeBadge.setTypeface(null, Typeface.BOLD);
        storeBadge.setPadding(dp(6), dp(2), dp(6), dp(2));
        GradientDrawable badgeBg = new GradientDrawable();
        badgeBg.setCornerRadius(dp(10));
        badgeBg.setColor(storeColor(entry.store));
        storeBadge.setBackground(badgeBg);
        LinearLayout.LayoutParams badgeLp = new LinearLayout.LayoutParams(-2, -2);
        badgeLp.leftMargin = dp(6);
        badgeLp.rightMargin = dp(4);
        titleRow.addView(storeBadge, badgeLp);

        Button removeBtn = makeBtn("×", 0xFF333333);
        removeBtn.setTextSize(14f);
        final String dlKeyCopy = entry.dlKey;
        removeBtn.setOnClickListener(v -> {
            BhDownloadService.removeLibraryEntry(this, dlKeyCopy);
            View[] cr = completedRows.remove(dlKeyCopy);
            if (cr != null) listLayout.removeView(cr[0]);
            updateEmptyState();
        });
        titleRow.addView(removeBtn, new LinearLayout.LayoutParams(-2, dp(34)));
        card.addView(titleRow, new LinearLayout.LayoutParams(-1, -2));

        // Action row: Launch + Uninstall
        LinearLayout actionRow = new LinearLayout(this);
        actionRow.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams arLp = new LinearLayout.LayoutParams(-1, -2);
        arLp.topMargin = dp(10);

        Button launchBtn = makeBtn("▶  Launch", 0xFF2E7D32);
        launchBtn.setOnClickListener(v -> launchGame(entry.dlKey, entry.store));
        LinearLayout.LayoutParams launchLp = new LinearLayout.LayoutParams(0, dp(40), 1f);
        launchLp.rightMargin = dp(6);
        actionRow.addView(launchBtn, launchLp);

        Button uninstallBtn = makeBtn("Uninstall", 0xFF8B0000);
        final View cardFinal = card;
        uninstallBtn.setOnClickListener(v -> confirmUninstall(entry, cardFinal));
        actionRow.addView(uninstallBtn, new LinearLayout.LayoutParams(0, dp(40), 1f));

        card.addView(actionRow, arLp);

        completedRows.put(entry.dlKey, new View[]{card});
        listLayout.addView(card, cardLp);
    }

    // ── Actions ───────────────────────────────────────────────────────────────

    private void launchGame(String dlKey, String store) {
        if ("GOG".equals(store)) {
            String gameId = dlKey.substring("gog_".length());
            String exe = getSharedPreferences("bh_gog_prefs", 0)
                    .getString("gog_exe_" + gameId, null);
            if (exe != null) pendingLaunchExe("bh_gog_prefs", "pending_gog_exe", exe);
            else Toast.makeText(this, "Executable not found — try launching from the GOG store", Toast.LENGTH_LONG).show();
        } else if ("EPIC".equals(store)) {
            String appName = dlKey.substring("epic_".length());
            String exe = getSharedPreferences("bh_epic_prefs", 0)
                    .getString("epic_exe_" + appName, null);
            if (exe != null) pendingLaunchExe("bh_epic_prefs", "pending_epic_exe", exe);
            else Toast.makeText(this, "Executable not found — try launching from the Epic store", Toast.LENGTH_LONG).show();
        } else if ("AMAZON".equals(store)) {
            String productId = dlKey.substring("amazon_".length());
            String exe = getSharedPreferences("bh_amazon_prefs", 0)
                    .getString("amazon_exe_" + productId, null);
            if (exe != null) pendingLaunchExe("bh_amazon_prefs", "pending_amazon_exe", exe);
            else Toast.makeText(this, "Executable not found — try launching from the Amazon store", Toast.LENGTH_LONG).show();
        }
    }

    private void pendingLaunchExe(String prefsName, String prefKey, String exe) {
        getSharedPreferences(prefsName, 0).edit().putString(prefKey, exe).apply();
        Intent intent = new Intent();
        intent.setClassName(getPackageName(),
                "com.xj.landscape.launcher.ui.main.LandscapeLauncherMainActivity");
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intent);
    }

    private void confirmUninstall(BhDownloadService.LibraryEntry entry, View card) {
        new AlertDialog.Builder(this)
                .setTitle("Uninstall " + entry.name + "?")
                .setMessage("This will delete all installed game files.")
                .setPositiveButton("Uninstall", (d, w) -> new Thread(() -> {
                    doUninstall(entry);
                    uiHandler.post(() -> {
                        View[] cr = completedRows.remove(entry.dlKey);
                        if (cr != null) listLayout.removeView(cr[0]);
                        updateEmptyState();
                        Toast.makeText(this, entry.name + " uninstalled", Toast.LENGTH_SHORT).show();
                    });
                }).start())
                .setNegativeButton("Cancel", null)
                .show();
    }

    private void doUninstall(BhDownloadService.LibraryEntry entry) {
        String store       = entry.store;
        String dlKey       = entry.dlKey;
        String installPath = entry.installPath;
        File   installDir  = null;

        if ("EPIC".equals(store)) {
            String appName = dlKey.substring("epic_".length());
            String dir = getSharedPreferences("bh_epic_prefs", 0)
                    .getString("epic_dir_" + appName, null);
            installDir = dir != null ? new File(dir)
                    : (installPath != null && !installPath.isEmpty() ? new File(installPath) : null);
            getSharedPreferences("bh_epic_prefs", 0).edit()
                    .remove("epic_exe_" + appName).remove("epic_dir_" + appName).apply();
        } else if ("GOG".equals(store)) {
            String gameId = dlKey.substring("gog_".length());
            String dir = getSharedPreferences("bh_gog_prefs", 0)
                    .getString("gog_dir_" + gameId, null);
            installDir = dir != null ? new File(dir)
                    : (installPath != null && !installPath.isEmpty() ? new File(installPath) : null);
            getSharedPreferences("bh_gog_prefs", 0).edit()
                    .remove("gog_exe_" + gameId).remove("gog_dir_" + gameId).apply();
        } else if ("AMAZON".equals(store)) {
            String productId = dlKey.substring("amazon_".length());
            String dir = getSharedPreferences("bh_amazon_prefs", 0)
                    .getString("amazon_dir_" + productId, null);
            installDir = dir != null ? new File(dir)
                    : (installPath != null && !installPath.isEmpty() ? new File(installPath) : null);
            getSharedPreferences("bh_amazon_prefs", 0).edit()
                    .remove("amazon_exe_" + productId).remove("amazon_dir_" + productId).apply();
        }

        if (installDir != null && installDir.exists()) deleteDir(installDir);
        BhDownloadService.removeLibraryEntry(this, dlKey);
    }

    private void clearCompleted() {
        for (View[] cr : completedRows.values()) listLayout.removeView(cr[0]);
        completedRows.clear();
        BhDownloadService.clearLibrary(this);
        updateEmptyState();
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private void updateEmptyState() {
        emptyTV.setVisibility((rows.isEmpty() && completedRows.isEmpty()) ? View.VISIBLE : View.GONE);
    }

    private void deleteDir(File dir) {
        if (dir == null || !dir.exists()) return;
        File[] files = dir.listFiles();
        if (files != null) for (File f : files) {
            if (f.isDirectory()) deleteDir(f); else f.delete();
        }
        dir.delete();
    }

    private Button makeBtn(String text, int color) {
        Button btn = new Button(this);
        btn.setText(text);
        btn.setTextColor(0xFFFFFFFF);
        btn.setTextSize(13f);
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(color);
        bg.setCornerRadius(dp(4));
        btn.setBackground(bg);
        btn.setPadding(dp(10), 0, dp(10), 0);
        return btn;
    }

    private static int storeColor(String store) {
        if ("EPIC".equals(store))   return 0xFF0078F0;
        if ("GOG".equals(store))    return 0xFF7033FF;
        if ("AMAZON".equals(store)) return 0xFFFF9900;
        return 0xFF555555;
    }

    private int dp(int value) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value,
                getResources().getDisplayMetrics());
    }
}
