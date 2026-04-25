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

/**
 * Full-screen game detail view for an Amazon Games library entry.
 *
 * Extras: product_id, entitlement_id, title, developer, publisher,
 *         art_url(String), product_sku
 * Result codes:
 *   RESULT_CANCELED — nothing changed
 *   RESULT_REFRESH  — install state changed
 */
public class AmazonGameDetailActivity extends Activity {

    public static final int RESULT_REFRESH = 100;
    private static final String TAG = "BH_AMAZON_DETAIL";

    private final Handler uiHandler = new Handler(Looper.getMainLooper());
    private SharedPreferences prefs;

    private String productId, entitlementId, title, developer, publisher, artUrl, productSku;

    private Button launchBtn, installBtn, setExeBtn, uninstallBtn;
    private TextView exeNameTV, sizeTV;
    private ProgressBar progressBar;
    private TextView progressLabel;
    private Runnable cancelDownload;

    // Updates section views
    private TextView updateStatusTV;
    private Button checkUpdatesBtn, updateBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs = getSharedPreferences("bh_amazon_prefs", 0);

        Intent i = getIntent();
        productId     = i.getStringExtra("product_id");
        entitlementId = i.getStringExtra("entitlement_id");
        title         = i.getStringExtra("title");
        developer     = i.getStringExtra("developer");
        publisher     = i.getStringExtra("publisher");
        artUrl        = i.getStringExtra("art_url");
        productSku    = i.getStringExtra("product_sku");

        if (productId == null) { finish(); return; }
        buildUi();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (productId == null) return;
        String dlKey = "amazon_" + productId;
        if (BhDownloadService.isActive(dlKey)) {
            installBtn.setText("Cancel");
            installBtn.setBackgroundColor(0xFFCC3333);
            progressBar.setVisibility(View.VISIBLE);
            progressLabel.setVisibility(View.VISIBLE);
            launchBtn.setEnabled(false);
            setExeBtn.setEnabled(false);
            cancelDownload = () -> BhDownloadService.cancel(this, dlKey);
            attachDownloadListener(dlKey);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (productId != null) BhDownloadService.removeListener("amazon_" + productId);
    }

    // ── UI ────────────────────────────────────────────────────────────────────

    private void buildUi() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0D0D0D);

        // Header
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.HORIZONTAL);
        header.setBackgroundColor(0xFF1A1000);
        header.setGravity(Gravity.CENTER_VERTICAL);
        header.setPadding(dp(8), dp(8), dp(8), dp(8));

        Button backBtn = makeBtn("←", 0xFF2A2000);
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
        if (artUrl != null && !artUrl.isEmpty()) {
            android.widget.ImageView coverIV = new android.widget.ImageView(this);
            coverIV.setScaleType(android.widget.ImageView.ScaleType.CENTER_CROP);
            coverIV.setBackgroundColor(0xFF1A1000);
            body.addView(coverIV, new LinearLayout.LayoutParams(-1, dp(200)));
            loadImage(artUrl, coverIV);
        }

        // Info
        body.addView(makeSectionHeader("GAME INFO"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeInfoCard(), new LinearLayout.LayoutParams(-1, -2));

        // Actions
        body.addView(makeSectionHeader("ACTIONS"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeActionsCard(), new LinearLayout.LayoutParams(-1, -2));

        // Updates
        body.addView(makeSectionHeader("UPDATES"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeUpdatesCard(), new LinearLayout.LayoutParams(-1, -2));

        body.addView(makeSectionHeader("DLC"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeDlcCard(), new LinearLayout.LayoutParams(-1, -2));

        scroll.addView(body);
        root.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1f));
        setContentView(root);

        refreshActionState();
        loadInstallSize();
    }

    private View makeInfoCard() {
        LinearLayout card = makeCard();
        if (developer != null && !developer.isEmpty()) card.addView(makeInfoRow("Developer", developer));
        if (publisher != null && !publisher.isEmpty())  card.addView(makeInfoRow("Publisher", publisher));
        if (productId != null) {
            int dot = productId.lastIndexOf('.');
            String shortId = (dot >= 0 && dot < productId.length() - 1)
                    ? productId.substring(dot + 1) : productId;
            card.addView(makeInfoRow("ID", shortId));
        }

        // Install size row (value updated async)
        sizeTV = new TextView(this);
        sizeTV.setTextColor(0xFFCCCCCC);
        sizeTV.setTextSize(13f);
        sizeTV.setText("Fetching…");
        card.addView(makeInfoRowWithRef("Install size", sizeTV));

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
            String exe = prefs.getString("amazon_exe_" + productId, null);
            if (exe != null) pendingLaunchExe(exe);
        });
        card.addView(launchBtn, btnLp());

        installBtn = makeBtn("Install", 0xFFFF9900);
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
            String dir = prefs.getString("amazon_dir_" + productId, null);
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
                        prefs.edit().putString("amazon_exe_" + productId, selected).apply();
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
        if (android.os.Build.VERSION.SDK_INT >= 33 &&
                checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.POST_NOTIFICATIONS}, 0);
        }
        String dlKey = "amazon_" + productId;
        installBtn.setText("Cancel");
        installBtn.setBackgroundColor(0xFFCC3333);
        progressBar.setVisibility(View.VISIBLE);
        progressLabel.setVisibility(View.VISIBLE);
        launchBtn.setEnabled(false);
        setExeBtn.setEnabled(false);

        cancelDownload = () -> BhDownloadService.cancel(this, dlKey);
        attachDownloadListener(dlKey);

        Intent svc = new Intent(this, BhDownloadService.class);
        svc.setAction(BhDownloadService.ACTION_START);
        svc.putExtra(BhDownloadService.EXTRA_STORE, "AMAZON");
        svc.putExtra(BhDownloadService.EXTRA_GAME_ID, dlKey);
        svc.putExtra(BhDownloadService.EXTRA_GAME_NAME, title != null ? title : productId);
        svc.putExtra(BhDownloadService.EXTRA_AMAZON_PRODUCT_ID, productId);
        svc.putExtra(BhDownloadService.EXTRA_AMAZON_ENT_ID, entitlementId);
        svc.putExtra(BhDownloadService.EXTRA_AMAZON_SKU, productSku);
        svc.putExtra(BhDownloadService.EXTRA_AMAZON_TITLE, title);
        startForegroundService(svc);
    }

    private void attachDownloadListener(String dlKey) {
        BhDownloadService.addListener(dlKey, new BhDownloadService.DownloadListener() {
            @Override public void onProgress(String msg, int pct) {
                uiHandler.post(() -> { progressBar.setProgress(pct); progressLabel.setText(msg); });
            }
            @Override public void onComplete(String installDir) {
                uiHandler.post(AmazonGameDetailActivity.this::onInstallComplete);
            }
            @Override public void onError(String msg) {
                uiHandler.post(() -> onInstallError(msg));
            }
            @Override public void onCancelled() {
                uiHandler.post(AmazonGameDetailActivity.this::onInstallCancelled);
            }
        });
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
            installBtn.setBackgroundColor(0xFFFF9900);
            refreshActionState();
            Toast.makeText(this, "Error: " + msg, Toast.LENGTH_LONG).show();
        });
    }

    private void onInstallCancelled() {
        cancelDownload = null;
        uiHandler.post(() -> {
            progressBar.setVisibility(View.GONE);
            progressLabel.setVisibility(View.GONE);
            installBtn.setBackgroundColor(0xFFFF9900);
            refreshActionState();
        });
    }

    // ── Uninstall ─────────────────────────────────────────────────────────────

    private void confirmUninstall() {
        new AlertDialog.Builder(this)
            .setTitle("Uninstall " + title + "?")
            .setMessage("This will delete all installed game files.")
            .setPositiveButton("Uninstall", (d, w) -> {
                String dir = prefs.getString("amazon_dir_" + productId, null);
                if (dir == null) return;
                new Thread(() -> {
                    deleteDir(new File(dir));
                    prefs.edit()
                        .remove("amazon_exe_" + productId)
                        .remove("amazon_dir_" + productId)
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
        String exe = prefs.getString("amazon_exe_" + productId, null);
        String dir = prefs.getString("amazon_dir_" + productId, null);
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
        prefs.edit().putString("pending_amazon_exe", absPath).apply();
        Intent intent = new Intent();
        intent.setClassName(getPackageName(),
                "com.xj.landscape.launcher.ui.main.LandscapeLauncherMainActivity");
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intent);
    }

    private void loadImage(String url, android.widget.ImageView iv) {
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
        }, "amazon-detail-cover").start();
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
        long cached = prefs.getLong("amazon_size_" + productId, -1);
        if (cached > 0) {
            if (sizeTV != null) sizeTV.setText(formatBytes(cached));
            return;
        }
        new Thread(() -> {
            String token = AmazonCredentialStore.getValidAccessToken(this);
            long size = (token != null && entitlementId != null && !entitlementId.isEmpty())
                    ? AmazonDownloadManager.fetchInstallSizeBytes(token, entitlementId)
                    : -1;
            if (size > 0) prefs.edit().putLong("amazon_size_" + productId, size).apply();
            uiHandler.post(() -> {
                if (sizeTV != null) sizeTV.setText(size > 0 ? formatBytes(size) : "Unknown");
            });
        }, "amazon-size-" + productId).start();
    }

    private static String formatBytes(long bytes) {
        if (bytes >= 1_073_741_824L) return String.format("%.1f GB", bytes / 1_073_741_824.0);
        return String.format("%.0f MB", bytes / 1_048_576.0);
    }

    // ── Updates card (AMAZON-1) ───────────────────────────────────────────────

    private View makeUpdatesCard() {
        LinearLayout card = makeCard();

        boolean installed = prefs.getString("amazon_exe_" + productId, null) != null;
        if (!installed) {
            TextView tv = new TextView(this);
            tv.setText("Install the game first to check for updates.");
            tv.setTextColor(0xFF554400);
            tv.setTextSize(13f);
            card.addView(tv);
            return card;
        }

        updateStatusTV = new TextView(this);
        updateStatusTV.setTextColor(0xFFCCCCCC);
        updateStatusTV.setTextSize(13f);
        String storedVer = prefs.getString("amazon_manifest_version_" + productId, null);
        updateStatusTV.setText(storedVer != null
                ? "Installed: v" + storedVer.substring(0, Math.min(12, storedVer.length())) + "…"
                : "Version not recorded — tap Check to verify");
        LinearLayout.LayoutParams stLp = new LinearLayout.LayoutParams(-1, -2);
        stLp.bottomMargin = dp(8);
        card.addView(updateStatusTV, stLp);

        updateBtn = makeBtn("Update Now", 0xFFCC7700);
        updateBtn.setVisibility(View.GONE);
        updateBtn.setOnClickListener(v -> {
            updateBtn.setVisibility(View.GONE);
            updateStatusTV.setText("Updating…");
            startInstall();
        });
        card.addView(updateBtn, btnLp());

        checkUpdatesBtn = makeBtn("Check for Updates", 0xFF332200);
        checkUpdatesBtn.setOnClickListener(v -> doCheckUpdate());
        card.addView(checkUpdatesBtn, btnLp());

        return card;
    }

    private void doCheckUpdate() {
        if (updateStatusTV == null) return;
        updateStatusTV.setText("Checking…");
        if (checkUpdatesBtn != null) checkUpdatesBtn.setEnabled(false);

        new Thread(() -> {
            try {
                String token = AmazonCredentialStore.getValidAccessToken(this);
                if (token == null) {
                    uiHandler.post(() -> {
                        if (checkUpdatesBtn != null) checkUpdatesBtn.setEnabled(true);
                        if (updateStatusTV != null) updateStatusTV.setText("Login required.");
                    });
                    return;
                }
                // Use getGameDownload (same call as install) — getLiveVersionIds is unreliable
                AmazonApiClient.GameDownloadSpec spec =
                        AmazonApiClient.getGameDownload(token, entitlementId);
                String latestVer = (spec != null) ? spec.versionId : null;
                uiHandler.post(() -> {
                    if (checkUpdatesBtn != null) checkUpdatesBtn.setEnabled(true);
                    if (updateStatusTV == null) return;
                    if (latestVer == null || latestVer.isEmpty()) {
                        updateStatusTV.setText("Could not reach update server.");
                        return;
                    }
                    String stored = prefs.getString("amazon_manifest_version_" + productId, null);
                    if (stored == null) {
                        prefs.edit().putString("amazon_manifest_version_" + productId, latestVer).apply();
                        updateStatusTV.setText("Up to date ✓");
                        if (updateBtn != null) updateBtn.setVisibility(View.GONE);
                    } else if (stored.equals(latestVer)) {
                        updateStatusTV.setText("Up to date ✓");
                        if (updateBtn != null) updateBtn.setVisibility(View.GONE);
                    } else {
                        updateStatusTV.setText("Update available!\nInstalled: v"
                                + stored.substring(0, Math.min(12, stored.length()))
                                + "…  →  Latest: v"
                                + latestVer.substring(0, Math.min(12, latestVer.length())) + "…");
                        if (updateBtn != null) updateBtn.setVisibility(View.VISIBLE);
                    }
                });
            } catch (Exception e) {
                uiHandler.post(() -> {
                    if (checkUpdatesBtn != null) checkUpdatesBtn.setEnabled(true);
                    if (updateStatusTV != null) updateStatusTV.setText("Check failed: " + e.getMessage());
                });
            }
        }, "amazon-update-check-" + productId).start();
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
        bg.setColor(0xFF1A1200);
        bg.setCornerRadius(dp(8));
        bg.setStroke(dp(1), 0xFF2A2000);
        card.setBackground(bg);
        return card;
    }

    private View makeSectionHeader(String text) {
        TextView tv = new TextView(this);
        tv.setText(text);
        tv.setTextColor(0xFFAA8844);
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

    // ── DLC card (AMAZON-2) ───────────────────────────────────────────────────

    private LinearLayout makeDlcCard() {
        LinearLayout card = makeCard();
        String json = productId != null ? prefs.getString("amazon_dlcs_" + productId, null) : null;
        if (json == null || json.equals("[]") || json.isEmpty()) {
            TextView tv = new TextView(this);
            tv.setText("No DLCs in your library for this game");
            tv.setTextColor(0xFF554400);
            tv.setTextSize(13f);
            card.addView(tv);
            return card;
        }
        try {
            org.json.JSONArray arr = new org.json.JSONArray(json);
            if (arr.length() == 0) {
                TextView tv = new TextView(this);
                tv.setText("No DLCs in your library for this game");
                tv.setTextColor(0xFF554400);
                tv.setTextSize(13f);
                card.addView(tv);
                return card;
            }

            TextView countTV = new TextView(this);
            countTV.setText(arr.length() + " DLC" + (arr.length() == 1 ? "" : "s") + " owned");
            countTV.setTextColor(0xFF888888);
            countTV.setTextSize(12f);
            countTV.setTypeface(null, android.graphics.Typeface.BOLD);
            card.addView(countTV, new LinearLayout.LayoutParams(-1, -2));

            for (int i = 0; i < arr.length(); i++) {
                org.json.JSONObject dlc = arr.optJSONObject(i);
                if (dlc == null) continue;
                String dlcEid   = dlc.optString("eid", "");
                String dlcPid   = dlc.optString("pid", "");
                String dlcTitle = dlc.optString("title", "Unknown DLC");

                boolean dlcInstalled = !dlcPid.isEmpty()
                        && prefs.getString("amazon_exe_" + dlcPid, null) != null;

                LinearLayout row = new LinearLayout(this);
                row.setOrientation(LinearLayout.VERTICAL);
                row.setPadding(dp(8), dp(6), dp(8), dp(6));
                GradientDrawable rowBg = new GradientDrawable();
                rowBg.setColor(0xFF1A1200);
                rowBg.setCornerRadius(dp(4));
                row.setBackground(rowBg);
                LinearLayout.LayoutParams rowLp = new LinearLayout.LayoutParams(-1, -2);
                rowLp.topMargin = dp(6);
                card.addView(row, rowLp);

                LinearLayout titleRow = new LinearLayout(this);
                titleRow.setOrientation(LinearLayout.HORIZONTAL);
                titleRow.setGravity(android.view.Gravity.CENTER_VERTICAL);
                TextView dlcTV = new TextView(this);
                dlcTV.setText(dlcTitle);
                dlcTV.setTextColor(0xFFDDDDDD);
                dlcTV.setTextSize(13f);
                titleRow.addView(dlcTV, new LinearLayout.LayoutParams(0, -2, 1f));
                if (dlcInstalled) {
                    TextView ckTV = new TextView(this);
                    ckTV.setText("✓");
                    ckTV.setTextColor(0xFF4CAF50);
                    ckTV.setTextSize(13f);
                    ckTV.setTypeface(null, android.graphics.Typeface.BOLD);
                    titleRow.addView(ckTV, new LinearLayout.LayoutParams(-2, -2));
                }
                row.addView(titleRow, new LinearLayout.LayoutParams(-1, -2));

                TextView dlcStatusTV = new TextView(this);
                dlcStatusTV.setTextColor(0xFF886600);
                dlcStatusTV.setTextSize(11f);
                dlcStatusTV.setVisibility(View.GONE);
                LinearLayout.LayoutParams statusLp = new LinearLayout.LayoutParams(-1, -2);
                statusLp.topMargin = dp(3);
                row.addView(dlcStatusTV, statusLp);

                if (!dlcEid.isEmpty()) {
                    Button dlcInstBtn = makeBtn(
                            dlcInstalled ? "Reinstall" : "Install",
                            dlcInstalled ? 0xFF2A3A00 : 0xFFCC7700);
                    LinearLayout.LayoutParams btnLp = new LinearLayout.LayoutParams(-1, dp(36));
                    btnLp.topMargin = dp(4);
                    row.addView(dlcInstBtn, btnLp);

                    final String fEid = dlcEid, fPid = dlcPid, fTitle = dlcTitle;
                    final Button finalBtn = dlcInstBtn;
                    dlcInstBtn.setOnClickListener(v -> {
                        if ("Downloading…".equals(finalBtn.getText())) return;
                        startDlcInstall(fEid, fPid, fTitle, dlcStatusTV, finalBtn);
                    });
                }
            }
        } catch (Exception e) {
            TextView tv = new TextView(this);
            tv.setText("Error reading DLC data");
            tv.setTextColor(0xFF554400);
            tv.setTextSize(13f);
            card.addView(tv);
        }
        return card;
    }

    private void startDlcInstall(String dlcEid, String dlcPid, String dlcTitle,
                                  TextView statusTV, Button installBtn) {
        uiHandler.post(() -> {
            installBtn.setText("Downloading…");
            installBtn.setBackgroundColor(0xFF444444);
            statusTV.setText("Starting…");
            statusTV.setVisibility(View.VISIBLE);
        });

        AmazonGame dlcGame = new AmazonGame();
        dlcGame.entitlementId = dlcEid;
        dlcGame.productId     = dlcPid.isEmpty() ? dlcEid : dlcPid;
        dlcGame.title         = dlcTitle;

        new Thread(() -> {
            try {
                String token = AmazonCredentialStore.getValidAccessToken(this);
                if (token == null) {
                    uiHandler.post(() -> {
                        statusTV.setText("Login required");
                        installBtn.setText("Install");
                        installBtn.setBackgroundColor(0xFFCC7700);
                    });
                    return;
                }
                String sanitized = dlcTitle.replaceAll("[^a-zA-Z0-9 \\-_]", "").trim();
                if (sanitized.isEmpty()) sanitized = "dlc_" + dlcEid.hashCode();
                File installDir = new File(new File(getFilesDir(), "Amazon"), sanitized);
                final String pidKey = dlcGame.productId;
                prefs.edit().putString("amazon_dir_" + pidKey, installDir.getAbsolutePath()).apply();

                boolean ok = AmazonDownloadManager.install(this, dlcGame, token, installDir,
                        (dl, total, file) -> {
                            int pct = (total > 0) ? (int) (dl * 100L / total) : 0;
                            String nm = (file != null && !file.isEmpty()) ? file : "Downloading…";
                            uiHandler.post(() -> statusTV.setText(nm + " (" + pct + "%)"));
                        },
                        () -> false);

                if (!ok) {
                    uiHandler.post(() -> {
                        statusTV.setText("Download failed");
                        installBtn.setText("Install");
                        installBtn.setBackgroundColor(0xFFCC7700);
                    });
                    return;
                }
                List<File> exeFiles = new ArrayList<>();
                AmazonLaunchHelper.collectExe(installDir, exeFiles);
                if (!exeFiles.isEmpty()) {
                    String lowerT = dlcTitle.toLowerCase();
                    Collections.sort(exeFiles, (a, b) ->
                            AmazonLaunchHelper.scoreExe(b, lowerT) - AmazonLaunchHelper.scoreExe(a, lowerT));
                    prefs.edit().putString("amazon_exe_" + pidKey,
                            exeFiles.get(0).getAbsolutePath()).apply();
                }
                uiHandler.post(() -> {
                    statusTV.setText("Installed");
                    installBtn.setText("Reinstall");
                    installBtn.setBackgroundColor(0xFF2A3A00);
                });
            } catch (Exception e) {
                uiHandler.post(() -> {
                    statusTV.setText("Error: " + (e.getMessage() != null ? e.getMessage() : "unknown"));
                    installBtn.setText("Install");
                    installBtn.setBackgroundColor(0xFFCC7700);
                });
            }
        }, "amazon-dlc-" + dlcEid).start();
    }

    private View makeStubCard(String msg) {
        LinearLayout card = makeCard();
        TextView tv = new TextView(this);
        tv.setText(msg);
        tv.setTextColor(0xFF554400);
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
