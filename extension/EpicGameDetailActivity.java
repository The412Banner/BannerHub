package app.revanced.extension.gamehub;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.Html;
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
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Full-screen game detail view for an Epic Games library entry.
 *
 * Extras: app_name, title, description, developer, art_cover(String URL),
 *         namespace, catalog_item_id
 * Result codes:
 *   RESULT_CANCELED — nothing changed
 *   RESULT_REFRESH  — install state changed
 */
public class EpicGameDetailActivity extends Activity {

    public static final int RESULT_REFRESH = 100;
    private static final String TAG = "BH_EPIC_DETAIL";

    private final Handler uiHandler = new Handler(Looper.getMainLooper());
    private SharedPreferences prefs;

    private String appName, title, description, developer, artCover, namespace, catalogItemId;

    private Button launchBtn, installBtn, setExeBtn, uninstallBtn;
    private TextView exeNameTV, sizeTV;
    private ProgressBar progressBar;
    private TextView progressLabel;
    private Runnable cancelDownload;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs = getSharedPreferences("bh_epic_prefs", 0);

        Intent i = getIntent();
        appName       = i.getStringExtra("app_name");
        title         = i.getStringExtra("title");
        description   = i.getStringExtra("description");
        developer     = i.getStringExtra("developer");
        artCover      = i.getStringExtra("art_cover");
        namespace     = i.getStringExtra("namespace");
        catalogItemId = i.getStringExtra("catalog_item_id");

        if (appName == null) { finish(); return; }
        buildUi();
    }

    @Override
    public void onBackPressed() {
        if (cancelDownload != null) cancelDownload.run();
        super.onBackPressed();
    }

    // ── UI ────────────────────────────────────────────────────────────────────

    private void buildUi() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0D0D0D);

        // Header
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.HORIZONTAL);
        header.setBackgroundColor(0xFF0D2040);
        header.setGravity(Gravity.CENTER_VERTICAL);
        header.setPadding(dp(8), dp(8), dp(8), dp(8));

        Button backBtn = makeBtn("←", 0xFF1A3050);
        backBtn.setOnClickListener(v -> finish());
        header.addView(backBtn, new LinearLayout.LayoutParams(-2, dp(36)));

        TextView titleTV = new TextView(this);
        titleTV.setText(title != null ? title : "");
        titleTV.setTextColor(0xFFFFFFFF);
        titleTV.setTextSize(15f);
        titleTV.setTypeface(null, Typeface.BOLD);
        titleTV.setPadding(dp(12), 0, dp(8), 0);
        titleTV.setMaxLines(1);
        titleTV.setEllipsize(android.text.TextUtils.TruncateAt.END);
        header.addView(titleTV, new LinearLayout.LayoutParams(0, -2, 1f));

        root.addView(header, new LinearLayout.LayoutParams(-1, -2));

        ScrollView scroll = new ScrollView(this);
        LinearLayout body = new LinearLayout(this);
        body.setOrientation(LinearLayout.VERTICAL);
        body.setPadding(dp(12), dp(12), dp(12), dp(24));

        // Cover art
        if (artCover != null && !artCover.isEmpty()) {
            android.widget.ImageView coverIV = new android.widget.ImageView(this);
            coverIV.setScaleType(android.widget.ImageView.ScaleType.CENTER_CROP);
            coverIV.setBackgroundColor(0xFF0D1A2E);
            body.addView(coverIV, new LinearLayout.LayoutParams(-1, dp(200)));
            loadImage(artCover, coverIV);
        }

        // Info
        body.addView(makeSectionHeader("GAME INFO"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeInfoCard(), new LinearLayout.LayoutParams(-1, -2));

        // Actions
        body.addView(makeSectionHeader("ACTIONS"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeActionsCard(), new LinearLayout.LayoutParams(-1, -2));

        // Stubs
        body.addView(makeSectionHeader("UPDATES"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeStubCard("Update checker coming soon"), new LinearLayout.LayoutParams(-1, -2));

        body.addView(makeSectionHeader("DLC"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeStubCard("DLC management coming soon"), new LinearLayout.LayoutParams(-1, -2));

        body.addView(makeSectionHeader("CLOUD SAVES"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeStubCard("Cloud saves coming soon"), new LinearLayout.LayoutParams(-1, -2));

        scroll.addView(body);
        root.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1f));
        setContentView(root);

        refreshActionState();
        loadInstallSize();
    }

    private View makeInfoCard() {
        LinearLayout card = makeCard();
        if (developer != null && !developer.isEmpty()) card.addView(makeInfoRow("Developer", developer));
        if (appName != null && !appName.isEmpty())     card.addView(makeInfoRow("App", appName));
        // Install size row (value updated async)
        sizeTV = new TextView(this);
        sizeTV.setTextColor(0xFFCCCCCC);
        sizeTV.setTextSize(13f);
        sizeTV.setText("Fetching…");
        card.addView(makeInfoRowWithRef("Install size", sizeTV));

        if (description != null && !description.isEmpty()) {
            // Strip HTML tags first, then truncate clean text
            String plain = Html.fromHtml(description, Html.FROM_HTML_MODE_COMPACT).toString().trim();
            String desc = plain.length() > 400 ? plain.substring(0, 400) + "…" : plain;
            TextView tv = new TextView(this);
            tv.setText(desc);
            tv.setTextColor(0xFFCCCCCC);
            tv.setTextSize(13f);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, -2);
            lp.topMargin = dp(8);
            card.addView(tv, lp);
        }
        return card;
    }

    private View makeActionsCard() {
        LinearLayout card = makeCard();

        exeNameTV = new TextView(this);
        exeNameTV.setTextColor(0xFF888888);
        exeNameTV.setTextSize(12f);
        exeNameTV.setPadding(0, 0, 0, dp(8));
        card.addView(exeNameTV);

        progressBar = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        progressBar.setMax(100);
        progressBar.setVisibility(View.GONE);
        LinearLayout.LayoutParams pbLp = new LinearLayout.LayoutParams(-1, dp(4));
        pbLp.bottomMargin = dp(4);
        card.addView(progressBar, pbLp);

        progressLabel = new TextView(this);
        progressLabel.setTextColor(0xFFAAAAAA);
        progressLabel.setTextSize(11f);
        progressLabel.setVisibility(View.GONE);
        LinearLayout.LayoutParams plLp = new LinearLayout.LayoutParams(-1, -2);
        plLp.bottomMargin = dp(8);
        card.addView(progressLabel, plLp);

        launchBtn = makeBtn("Launch", 0xFF2E7D32);
        launchBtn.setOnClickListener(v -> {
            String exe = prefs.getString("epic_exe_" + appName, null);
            if (exe != null) pendingLaunchExe(exe);
        });
        card.addView(launchBtn, btnLp());

        installBtn = makeBtn("Install", 0xFF1A73E8);
        installBtn.setOnClickListener(v -> {
            if ("Cancel".equals(installBtn.getText().toString())) {
                if (cancelDownload != null) { cancelDownload.run(); cancelDownload = null; }
                return;
            }
            startInstall();
        });
        card.addView(installBtn, btnLp());

        setExeBtn = makeBtn("Set .exe…", 0xFF444444);
        setExeBtn.setOnClickListener(v -> {
            String dir = prefs.getString("epic_dir_" + appName, null);
            if (dir == null) return;
            new Thread(() -> {
                List<File> exeFiles = new ArrayList<>();
                AmazonLaunchHelper.collectExe(new File(dir), exeFiles);
                if (exeFiles.isEmpty()) {
                    uiHandler.post(() -> Toast.makeText(this, "No .exe files found", Toast.LENGTH_SHORT).show());
                    return;
                }
                List<String> candidates = new ArrayList<>();
                for (File f : exeFiles) candidates.add(f.getAbsolutePath());
                showExePicker(candidates, selected -> {
                    if (selected != null && !selected.isEmpty()) {
                        prefs.edit().putString("epic_exe_" + appName, selected).apply();
                        uiHandler.post(() -> {
                            refreshActionState();
                            setResult(RESULT_REFRESH);
                            Toast.makeText(this, "Exe set: " + new File(selected).getName(), Toast.LENGTH_SHORT).show();
                        });
                    }
                });
            }).start();
        });
        card.addView(setExeBtn, btnLp());

        uninstallBtn = makeBtn("Uninstall", 0xFF8B0000);
        uninstallBtn.setOnClickListener(v -> confirmUninstall());
        card.addView(uninstallBtn, btnLp());

        return card;
    }

    // ── Install ───────────────────────────────────────────────────────────────

    private void startInstall() {
        installBtn.setText("Cancel");
        installBtn.setBackgroundColor(0xFFCC3333);
        progressBar.setVisibility(View.VISIBLE);
        progressLabel.setVisibility(View.VISIBLE);
        launchBtn.setEnabled(false);
        setExeBtn.setEnabled(false);

        AtomicBoolean cancelled = new AtomicBoolean(false);
        cancelDownload = () -> cancelled.set(true);

        new Thread(() -> {
            try {
                String token = EpicCredentialStore.getValidAccessToken(this);
                if (token == null) { onInstallError("Login required"); return; }

                uiHandler.post(() -> progressLabel.setText("Fetching manifest…"));
                String manifestJson = EpicApiClient.getManifestApiJson(
                        token, namespace, catalogItemId, appName);
                if (manifestJson == null) {
                    onInstallError("Failed to fetch manifest");
                    return;
                }

                String sanitized = title != null
                        ? title.replaceAll("[^a-zA-Z0-9 \\-_]", "").trim() : "";
                if (sanitized.isEmpty()) sanitized = "epic_" + appName.hashCode();
                File installDir = new File(new File(getFilesDir(), "epic_games"), sanitized);
                prefs.edit().putString("epic_dir_" + appName, installDir.getAbsolutePath()).apply();

                final String finalToken = token;
                boolean ok = EpicDownloadManager.install(this, manifestJson, finalToken,
                        installDir.getAbsolutePath(), (msg, pct) -> {
                            if (cancelled.get()) return;
                            uiHandler.post(() -> {
                                progressBar.setProgress(pct);
                                progressLabel.setText(msg);
                            });
                        });

                if (cancelled.get()) { onInstallCancelled(); return; }
                if (!ok) { onInstallError("Download failed"); return; }

                List<File> exeFiles = new ArrayList<>();
                AmazonLaunchHelper.collectExe(installDir, exeFiles);
                if (exeFiles.isEmpty()) { onInstallError("No executable found"); return; }

                String lowerTitle = title != null ? title.toLowerCase() : "";
                Collections.sort(exeFiles, (a, b) ->
                        AmazonLaunchHelper.scoreExe(b, lowerTitle)
                        - AmazonLaunchHelper.scoreExe(a, lowerTitle));

                if (exeFiles.size() == 1) {
                    String path = exeFiles.get(0).getAbsolutePath();
                    prefs.edit().putString("epic_exe_" + appName, path).apply();
                    onInstallComplete();
                } else {
                    List<String> candidates = new ArrayList<>();
                    for (File f : exeFiles) candidates.add(f.getAbsolutePath());
                    showExePicker(candidates, selected -> {
                        String chosen = (selected != null && !selected.isEmpty())
                                ? selected : exeFiles.get(0).getAbsolutePath();
                        prefs.edit().putString("epic_exe_" + appName, chosen).apply();
                        onInstallComplete();
                    });
                }
            } catch (Exception e) {
                if (!cancelled.get()) onInstallError(e.getMessage() != null ? e.getMessage() : "Unknown error");
            }
        }, "epic-detail-dl-" + appName).start();
    }

    private void onInstallComplete() {
        cancelDownload = null;
        uiHandler.post(() -> {
            progressBar.setVisibility(View.GONE);
            progressLabel.setVisibility(View.GONE);
            setResult(RESULT_REFRESH);
            refreshActionState();
        });
    }

    private void onInstallError(String msg) {
        cancelDownload = null;
        uiHandler.post(() -> {
            progressBar.setVisibility(View.GONE);
            progressLabel.setVisibility(View.GONE);
            installBtn.setText("Install");
            installBtn.setBackgroundColor(0xFF1A73E8);
            launchBtn.setEnabled(true);
            setExeBtn.setEnabled(true);
            Toast.makeText(this, "Error: " + msg, Toast.LENGTH_LONG).show();
        });
    }

    private void onInstallCancelled() {
        cancelDownload = null;
        uiHandler.post(() -> {
            progressBar.setVisibility(View.GONE);
            progressLabel.setVisibility(View.GONE);
            installBtn.setText("Install");
            installBtn.setBackgroundColor(0xFF1A73E8);
            launchBtn.setEnabled(true);
            setExeBtn.setEnabled(true);
        });
    }

    // ── Uninstall ─────────────────────────────────────────────────────────────

    private void confirmUninstall() {
        new AlertDialog.Builder(this)
            .setTitle("Uninstall " + title + "?")
            .setMessage("This will delete all installed game files.")
            .setPositiveButton("Uninstall", (d, w) -> {
                String dir = prefs.getString("epic_dir_" + appName, null);
                if (dir == null) return;
                new Thread(() -> {
                    deleteDir(new File(dir));
                    prefs.edit()
                        .remove("epic_exe_" + appName)
                        .remove("epic_dir_" + appName)
                        .apply();
                    uiHandler.post(() -> {
                        setResult(RESULT_REFRESH);
                        refreshActionState();
                        Toast.makeText(this, title + " uninstalled", Toast.LENGTH_SHORT).show();
                    });
                }).start();
            })
            .setNegativeButton("Cancel", null)
            .show();
    }

    // ── State refresh ─────────────────────────────────────────────────────────

    private void refreshActionState() {
        if (exeNameTV == null) return;
        String exe = prefs.getString("epic_exe_" + appName, null);
        String dir = prefs.getString("epic_dir_" + appName, null);
        boolean installed = (exe != null);

        exeNameTV.setVisibility(installed ? View.VISIBLE : View.GONE);
        if (installed) exeNameTV.setText(".exe: " + new File(exe).getName());

        launchBtn.setVisibility(installed ? View.VISIBLE : View.GONE);
        installBtn.setVisibility(installed ? View.GONE : View.VISIBLE);
        if (!installed) installBtn.setText("Install");
        setExeBtn.setVisibility(installed ? View.VISIBLE : View.GONE);
        uninstallBtn.setVisibility(dir != null ? View.VISIBLE : View.GONE);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private void pendingLaunchExe(String absPath) {
        prefs.edit().putString("pending_epic_exe", absPath).apply();
        Intent intent = new Intent();
        intent.setClassName(getPackageName(),
                "com.xj.landscape.launcher.ui.main.LandscapeLauncherMainActivity");
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intent);
    }

    private void loadImage(String url, android.widget.ImageView iv) {
        if (url == null || url.isEmpty()) return;
        new Thread(() -> {
            try {
                java.net.HttpURLConnection conn =
                    (java.net.HttpURLConnection) new java.net.URL(url).openConnection();
                conn.setConnectTimeout(10000);
                conn.setReadTimeout(10000);
                if (conn.getResponseCode() == 200) {
                    Bitmap bmp = BitmapFactory.decodeStream(conn.getInputStream());
                    if (bmp != null) uiHandler.post(() -> iv.setImageBitmap(bmp));
                }
                conn.disconnect();
            } catch (Exception ignored) {}
        }, "epic-detail-cover").start();
    }

    private void showExePicker(List<String> candidates,
                                java.util.function.Consumer<String> onSelected) {
        String[] labels = new String[candidates.size()];
        for (int i = 0; i < candidates.size(); i++) {
            File f = new File(candidates.get(i));
            File parent = f.getParentFile();
            labels[i] = (parent != null) ? parent.getName() + "/" + f.getName() : f.getName();
        }
        uiHandler.post(() ->
            new AlertDialog.Builder(this)
                .setTitle("Select game executable")
                .setItems(labels, (d, which) ->
                    new Thread(() -> onSelected.accept(candidates.get(which))).start())
                .setCancelable(false)
                .show()
        );
    }

    private void loadInstallSize() {
        long cached = prefs.getLong("epic_size_" + appName, -1);
        if (cached > 0) {
            if (sizeTV != null) sizeTV.setText(formatBytes(cached));
            return;
        }
        new Thread(() -> {
            String token = EpicCredentialStore.getValidAccessToken(this);
            long size = (token != null)
                    ? EpicDownloadManager.fetchInstallSizeBytes(token, namespace, catalogItemId, appName)
                    : -1;
            if (size > 0) prefs.edit().putLong("epic_size_" + appName, size).apply();
            uiHandler.post(() -> {
                if (sizeTV != null) sizeTV.setText(size > 0 ? formatBytes(size) : "Unknown");
            });
        }, "epic-size-" + appName).start();
    }

    private static String formatBytes(long bytes) {
        if (bytes >= 1_073_741_824L) return String.format("%.1f GB", bytes / 1_073_741_824.0);
        return String.format("%.0f MB", bytes / 1_048_576.0);
    }

    private View makeInfoRowWithRef(String label, TextView valueTV) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, -2);
        lp.bottomMargin = dp(4);

        TextView labelTV = new TextView(this);
        labelTV.setText(label + ": ");
        labelTV.setTextColor(0xFF888888);
        labelTV.setTextSize(13f);
        row.addView(labelTV, new LinearLayout.LayoutParams(-2, -2));
        row.addView(valueTV, new LinearLayout.LayoutParams(0, -2, 1f));
        return row;
    }

    private void deleteDir(File dir) {
        if (dir == null || !dir.exists()) return;
        File[] files = dir.listFiles();
        if (files != null) for (File f : files) {
            if (f.isDirectory()) deleteDir(f); else f.delete();
        }
        dir.delete();
    }

    // ── View factories ────────────────────────────────────────────────────────

    private LinearLayout makeCard() {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(14), dp(12), dp(14), dp(12));
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(0xFF111A2A);
        bg.setCornerRadius(dp(8));
        bg.setStroke(dp(1), 0xFF1A2A3A);
        card.setBackground(bg);
        return card;
    }

    private View makeSectionHeader(String text) {
        TextView tv = new TextView(this);
        tv.setText(text);
        tv.setTextColor(0xFF6688AA);
        tv.setTextSize(11f);
        tv.setTypeface(null, Typeface.BOLD);
        tv.setLetterSpacing(0.08f);
        tv.setPadding(dp(2), dp(16), 0, dp(6));
        return tv;
    }

    private View makeInfoRow(String label, String value) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, -2);
        lp.bottomMargin = dp(4);

        TextView labelTV = new TextView(this);
        labelTV.setText(label + ": ");
        labelTV.setTextColor(0xFF888888);
        labelTV.setTextSize(13f);
        row.addView(labelTV, new LinearLayout.LayoutParams(-2, -2));

        TextView valueTV = new TextView(this);
        valueTV.setText(value);
        valueTV.setTextColor(0xFFCCCCCC);
        valueTV.setTextSize(13f);
        row.addView(valueTV, new LinearLayout.LayoutParams(0, -2, 1f));

        return row;
    }

    private View makeStubCard(String msg) {
        LinearLayout card = makeCard();
        TextView tv = new TextView(this);
        tv.setText(msg);
        tv.setTextColor(0xFF445566);
        tv.setTextSize(13f);
        card.addView(tv);
        return card;
    }

    private Button makeBtn(String text, int color) {
        Button btn = new Button(this);
        btn.setText(text);
        btn.setTextColor(0xFFFFFFFF);
        btn.setTextSize(13f);
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(color);
        bg.setCornerRadius(dp(6));
        btn.setBackground(bg);
        btn.setPadding(dp(12), dp(8), dp(12), dp(8));
        return btn;
    }

    private LinearLayout.LayoutParams btnLp() {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, dp(42));
        lp.bottomMargin = dp(8);
        return lp;
    }

    private int dp(int v) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v,
            getResources().getDisplayMetrics());
    }
}
