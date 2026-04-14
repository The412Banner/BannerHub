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
import java.util.concurrent.atomic.AtomicBoolean;

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

        // Stubs
        body.addView(makeSectionHeader("UPDATES"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeStubCard("Update checker coming soon"), new LinearLayout.LayoutParams(-1, -2));

        body.addView(makeSectionHeader("DLC"), new LinearLayout.LayoutParams(-1, -2));
        body.addView(makeStubCard("DLC management coming soon"), new LinearLayout.LayoutParams(-1, -2));

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
        installBtn.setText("Cancel");
        installBtn.setBackgroundColor(0xFFCC3333);
        progressBar.setVisibility(View.VISIBLE);
        progressLabel.setVisibility(View.VISIBLE);
        launchBtn.setEnabled(false);
        setExeBtn.setEnabled(false);

        AtomicBoolean cancelled = new AtomicBoolean(false);
        cancelDownload = () -> cancelled.set(true);

        AmazonGame game = new AmazonGame();
        game.productId     = productId;
        game.entitlementId = entitlementId != null ? entitlementId : "";
        game.title         = title != null ? title : "";
        game.productSku    = productSku != null ? productSku : "";

        new Thread(() -> {
            String token = AmazonCredentialStore.getValidAccessToken(this);
            if (token == null) { onInstallError("Login required"); return; }

            String sanitized = title != null
                    ? title.replaceAll("[^a-zA-Z0-9 \\-_]", "").trim() : "";
            if (sanitized.isEmpty()) sanitized = "game_" + productId.hashCode();
            File installDir = new File(new File(getFilesDir(), "Amazon"), sanitized);
            prefs.edit().putString("amazon_dir_" + productId, installDir.getAbsolutePath()).apply();

            boolean ok = AmazonDownloadManager.install(this, game, token, installDir,
                (dl, total, file) -> {
                    if (cancelled.get()) return;
                    int pct = (total > 0) ? (int) (dl * 100L / total) : 0;
                    String name = (file != null && !file.isEmpty()) ? file : "Downloading…";
                    uiHandler.post(() -> {
                        progressBar.setProgress(pct);
                        progressLabel.setText(name);
                    });
                },
                cancelled::get
            );

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
                prefs.edit().putString("amazon_exe_" + productId,
                        exeFiles.get(0).getAbsolutePath()).apply();
                onInstallComplete();
            } else {
                List<String> candidates = new ArrayList<>();
                for (File f : exeFiles) candidates.add(f.getAbsolutePath());
                showExePicker(candidates, selected -> {
                    String chosen = (selected != null && !selected.isEmpty())
                            ? selected : exeFiles.get(0).getAbsolutePath();
                    prefs.edit().putString("amazon_exe_" + productId, chosen).apply();
                    onInstallComplete();
                });
            }
        }, "amazon-detail-dl-" + productId).start();
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
            installBtn.setBackgroundColor(0xFFFF9900);
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
            installBtn.setBackgroundColor(0xFFFF9900);
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
