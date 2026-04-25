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
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.List;

/**
 * Full-screen game detail view for a GOG library entry.
 *
 * Launched via startActivityForResult() from GogGamesActivity.
 * Extras (all Strings / int):
 *   game_id, title, image_url, description, developer, category, generation(int)
 *
 * Result codes:
 *   RESULT_CANCELED  — nothing changed
 *   RESULT_REFRESH   — install state changed (uninstall, exe set); caller should refresh card
 */
public class GogGameDetailActivity extends Activity {

    public static final int RESULT_REFRESH = 100;

    private static final String TAG = "BH_GOG_DETAIL";

    private final Handler uiHandler = new Handler(Looper.getMainLooper());
    private SharedPreferences prefs;

    private static final int REQUEST_FOLDER_PICKER = 200;

    private String gameId, title, imageUrl, description, developer, category;
    private int generation;

    // Action section views (need refs for live updates)
    private Button launchBtn, installBtn, setExeBtn, uninstallBtn, copyBtn;
    private TextView exeNameTV, sizeTV;
    private ProgressBar progressBar;
    private TextView progressLabel;
    private Runnable cancelDownload;

    // Updates section views
    private TextView updateStatusTV;
    private Button checkUpdatesBtn, updateBtn;

    // Cloud saves section views
    private TextView cloudSaveDirTV, cloudSaveStatusTV;
    private Button cloudBrowseBtn, cloudUploadBtn, cloudDownloadBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs = getSharedPreferences("bh_gog_prefs", 0);

        Intent i = getIntent();
        gameId      = i.getStringExtra("game_id");
        title       = i.getStringExtra("title");
        imageUrl    = i.getStringExtra("image_url");
        description = i.getStringExtra("description");
        developer   = i.getStringExtra("developer");
        category    = i.getStringExtra("category");
        generation  = i.getIntExtra("generation", 0);

        if (gameId == null) { finish(); return; }

        buildUi();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (gameId == null) return;
        String dlKey = "gog_" + gameId;
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
        if (gameId != null) BhDownloadService.removeListener("gog_" + gameId);
    }

    // ── UI ────────────────────────────────────────────────────────────────────

    private void buildUi() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0D0D0D);

        // ── Fixed header bar ──────────────────────────────────────────────────
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.HORIZONTAL);
        header.setBackgroundColor(0xFF1A1A2E);
        header.setGravity(Gravity.CENTER_VERTICAL);
        header.setPadding(dp(8), dp(8), dp(8), dp(8));

        Button backBtn = makeBtn("←", 0xFF333333);
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

        // ── Scrollable body ───────────────────────────────────────────────────
        ScrollView scroll = new ScrollView(this);
        LinearLayout body = new LinearLayout(this);
        body.setOrientation(LinearLayout.VERTICAL);
        body.setPadding(dp(12), dp(12), dp(12), dp(24));

        // Cover art
        ImageView coverIV = new ImageView(this);
        coverIV.setScaleType(ImageView.ScaleType.CENTER_CROP);
        coverIV.setBackgroundColor(0xFF111122);
        body.addView(coverIV, new LinearLayout.LayoutParams(-1, dp(200)));
        loadImage(coverIV);

        // Info section
        body.addView(makeSectionHeader("GAME INFO"), sectionHeaderLp());
        body.addView(makeInfoCard(), new LinearLayout.LayoutParams(-1, -2));

        // Actions section
        body.addView(makeSectionHeader("ACTIONS"), sectionHeaderLp());
        body.addView(makeActionsCard(), new LinearLayout.LayoutParams(-1, -2));

        // Updates
        body.addView(makeSectionHeader("UPDATES"), sectionHeaderLp());
        body.addView(makeUpdatesCard(), new LinearLayout.LayoutParams(-1, -2));

        body.addView(makeSectionHeader("DLC"), sectionHeaderLp());
        body.addView(makeDlcCard(), new LinearLayout.LayoutParams(-1, -2));

        // Cloud Saves
        body.addView(makeSectionHeader("CLOUD SAVES"), sectionHeaderLp());
        body.addView(makeCloudSavesCard(), new LinearLayout.LayoutParams(-1, -2));

        scroll.addView(body);
        root.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1f));
        setContentView(root);

        refreshActionState();
        loadInstallSize();
    }

    private View makeInfoCard() {
        LinearLayout card = makeCard();

        if (generation > 0) {
            TextView genTV = new TextView(this);
            genTV.setText("Gen " + generation);
            genTV.setTextSize(11f);
            genTV.setTextColor(0xFFFFFFFF);
            genTV.setPadding(dp(8), dp(3), dp(8), dp(3));
            GradientDrawable bg = new GradientDrawable();
            bg.setColor(generation == 2 ? 0xFF0277BD : 0xFFE65100);
            bg.setCornerRadius(dp(4));
            genTV.setBackground(bg);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, -2);
            lp.bottomMargin = dp(8);
            card.addView(genTV, lp);
        }

        if (developer != null && !developer.isEmpty()) {
            card.addView(makeInfoRow("Developer", developer));
        }
        if (category != null && !category.isEmpty()) {
            card.addView(makeInfoRow("Genre", category));
        }
        String releaseDate = prefs.getString("gog_release_" + gameId, null);
        if (releaseDate != null && !releaseDate.isEmpty()) {
            card.addView(makeInfoRow("Released", formatDate(releaseDate)));
        }
        int rating = prefs.getInt("gog_rating_" + gameId, -1);
        if (rating >= 0) {
            float stars = rating / 100f;
            String ratingStr = rating == 0 ? "Not rated"
                    : String.format("%.1f / 5 ★", stars);
            card.addView(makeInfoRow("Rating", ratingStr));
        }
        // Install size row (value updated async)
        sizeTV = new TextView(this);
        sizeTV.setTextColor(0xFFCCCCCC);
        sizeTV.setTextSize(13f);
        sizeTV.setText("Fetching…");
        card.addView(makeInfoRowWithRef("Install size", sizeTV));

        if (description != null && !description.isEmpty()) {
            TextView descTV = new TextView(this);
            descTV.setText(Html.fromHtml(description, Html.FROM_HTML_MODE_COMPACT));
            descTV.setTextColor(0xFFCCCCCC);
            descTV.setTextSize(13f);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, -2);
            lp.topMargin = dp(8);
            card.addView(descTV, lp);
        }
        return card;
    }

    private View makeActionsCard() {
        LinearLayout card = makeCard();

        // .exe name row
        exeNameTV = new TextView(this);
        exeNameTV.setTextColor(0xFF888888);
        exeNameTV.setTextSize(12f);
        exeNameTV.setPadding(0, 0, 0, dp(8));
        card.addView(exeNameTV);

        // Progress bar + label
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

        // Launch button
        launchBtn = makeBtn("Launch", 0xFF2E7D32);
        launchBtn.setOnClickListener(v -> {
            String exe = prefs.getString("gog_exe_" + gameId, null);
            if (exe != null) GogLaunchHelper.triggerLaunch(this, exe);
        });
        card.addView(launchBtn, btnLp());

        // Install button
        installBtn = makeBtn("Install", 0xFF5533CC);
        installBtn.setOnClickListener(v -> {
            String lbl = installBtn.getText().toString();
            if ("Cancel".equals(lbl)) {
                if (cancelDownload != null) { cancelDownload.run(); cancelDownload = null; }
                return;
            }
            startInstall();
        });
        card.addView(installBtn, btnLp());

        // Set .exe button
        setExeBtn = makeBtn("Set .exe…", 0xFF444444);
        setExeBtn.setOnClickListener(v -> {
            String dir = prefs.getString("gog_dir_" + gameId, null);
            if (dir == null) return;
            File installPath = GogInstallPath.getInstallDir(this, dir);
            new Thread(() -> {
                List<String> candidates = GogDownloadManager.collectExeCandidates(installPath);
                if (candidates.isEmpty()) {
                    uiHandler.post(() -> Toast.makeText(this, "No .exe files found", Toast.LENGTH_SHORT).show());
                    return;
                }
                showExePicker(candidates, selected -> {
                    if (selected != null && !selected.isEmpty()) {
                        prefs.edit().putString("gog_exe_" + gameId, selected).apply();
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

        // Uninstall button
        uninstallBtn = makeBtn("Uninstall", 0xFF8B0000);
        uninstallBtn.setOnClickListener(v -> confirmUninstall());
        card.addView(uninstallBtn, btnLp());

        // Copy to Downloads button
        copyBtn = makeBtn("Copy to Downloads", 0xFF333333);
        copyBtn.setOnClickListener(v -> {
            Toast.makeText(this, "Copying…", Toast.LENGTH_SHORT).show();
            new Thread(() -> {
                String dest = GogDownloadManager.copyToDownloads(this, gameId);
                uiHandler.post(() -> {
                    if (dest != null) Toast.makeText(this, "Copied to: " + dest, Toast.LENGTH_LONG).show();
                    else Toast.makeText(this, "Copy failed — check storage permission", Toast.LENGTH_SHORT).show();
                });
            }).start();
        });
        card.addView(copyBtn, btnLp());

        return card;
    }

    // ── Install flow ──────────────────────────────────────────────────────────

    private void startInstall() {
        if (android.os.Build.VERSION.SDK_INT >= 33 &&
                checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.POST_NOTIFICATIONS}, 0);
        }
        String dlKey = "gog_" + gameId;
        installBtn.setText("Cancel");
        installBtn.setBackgroundColor(0xFFCC3333);
        progressBar.setVisibility(View.VISIBLE);
        progressLabel.setVisibility(View.VISIBLE);
        launchBtn.setEnabled(false);
        setExeBtn.setEnabled(false);

        cancelDownload = () -> BhDownloadService.cancel(this, dlKey);
        attachDownloadListener(dlKey);

        GogGame game = makeGogGame();
        Intent svc = new Intent(this, BhDownloadService.class);
        svc.setAction(BhDownloadService.ACTION_START);
        svc.putExtra(BhDownloadService.EXTRA_STORE, "GOG");
        svc.putExtra(BhDownloadService.EXTRA_GAME_ID, dlKey);
        svc.putExtra(BhDownloadService.EXTRA_GAME_NAME, title != null ? title : gameId);
        svc.putExtra(BhDownloadService.EXTRA_GOG_GAME_ID, game.gameId);
        svc.putExtra(BhDownloadService.EXTRA_GOG_TITLE, game.title);
        svc.putExtra(BhDownloadService.EXTRA_GOG_IMAGE_URL, game.imageUrl);
        svc.putExtra(BhDownloadService.EXTRA_GOG_DEVELOPER, game.developer);
        svc.putExtra(BhDownloadService.EXTRA_GOG_CATEGORY, game.category);
        svc.putExtra(BhDownloadService.EXTRA_GOG_GENERATION, game.generation);
        startForegroundService(svc);
    }

    private void attachDownloadListener(String dlKey) {
        BhDownloadService.addListener(dlKey, new BhDownloadService.DownloadListener() {
            @Override public void onProgress(String msg, int pct) {
                uiHandler.post(() -> { progressBar.setProgress(pct); progressLabel.setText(msg); });
            }
            @Override public void onComplete(String installDir) {
                cancelDownload = null;
                uiHandler.post(() -> {
                    progressBar.setVisibility(View.GONE);
                    progressLabel.setVisibility(View.GONE);
                    setResult(RESULT_REFRESH);
                    refreshActionState();
                });
            }
            @Override public void onError(String msg) {
                cancelDownload = null;
                uiHandler.post(() -> {
                    progressBar.setVisibility(View.GONE);
                    progressLabel.setVisibility(View.GONE);
                    installBtn.setBackgroundColor(0xFF5533CC);
                    refreshActionState();
                    Toast.makeText(GogGameDetailActivity.this, "Error: " + msg, Toast.LENGTH_LONG).show();
                });
            }
            @Override public void onCancelled() {
                cancelDownload = null;
                uiHandler.post(() -> {
                    progressBar.setVisibility(View.GONE);
                    progressLabel.setVisibility(View.GONE);
                    installBtn.setBackgroundColor(0xFF5533CC);
                    refreshActionState();
                });
            }
        });
    }

    // ── Uninstall ─────────────────────────────────────────────────────────────

    private void confirmUninstall() {
        new AlertDialog.Builder(this)
            .setTitle("Uninstall " + title + "?")
            .setMessage("This will delete all installed game files.")
            .setPositiveButton("Uninstall", (d, w) -> doUninstall())
            .setNegativeButton("Cancel", null)
            .show();
    }

    private void doUninstall() {
        String dirName = prefs.getString("gog_dir_" + gameId, null);
        if (dirName == null) return;
        new Thread(() -> {
            File installPath = GogInstallPath.getInstallDir(this, dirName);
            deleteDir(installPath);
            prefs.edit()
                .remove("gog_dir_" + gameId)
                .remove("gog_exe_" + gameId)
                .remove("gog_cover_" + gameId)
                .apply();
            uiHandler.post(() -> {
                setResult(RESULT_REFRESH);
                refreshActionState();
                Toast.makeText(this, title + " uninstalled", Toast.LENGTH_SHORT).show();
            });
        }).start();
    }

    // ── State refresh ─────────────────────────────────────────────────────────

    private void refreshActionState() {
        if (exeNameTV == null) return;
        String exe = prefs.getString("gog_exe_" + gameId, null);
        String dir = prefs.getString("gog_dir_" + gameId, null);
        boolean installed = (exe != null && dir != null);

        if (installed) {
            exeNameTV.setText(".exe: " + new File(exe).getName());
            exeNameTV.setVisibility(View.VISIBLE);
        } else {
            exeNameTV.setVisibility(View.GONE);
        }

        launchBtn.setVisibility(installed ? View.VISIBLE : View.GONE);
        installBtn.setVisibility(installed ? View.GONE : View.VISIBLE);
        if (!installed) installBtn.setText("Install");
        setExeBtn.setVisibility(installed ? View.VISIBLE : View.GONE);
        uninstallBtn.setVisibility(installed ? View.VISIBLE : View.GONE);
        copyBtn.setVisibility(installed ? View.VISIBLE : View.GONE);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private GogGame makeGogGame() {
        return new GogGame(gameId,
            title != null ? title : "",
            imageUrl != null ? imageUrl : "",
            description != null ? description : "",
            developer != null ? developer : "",
            category != null ? category : "",
            generation);
    }

    private void loadImage(ImageView iv) {
        if (imageUrl == null || imageUrl.isEmpty()) return;
        String url = imageUrl.startsWith("//") ? "https:" + imageUrl : imageUrl;
        new Thread(() -> {
            try {
                java.net.HttpURLConnection conn =
                    (java.net.HttpURLConnection) new java.net.URL(url).openConnection();
                conn.setConnectTimeout(10000);
                conn.setReadTimeout(10000);
                conn.setRequestProperty("User-Agent", "GOG Galaxy");
                if (conn.getResponseCode() == 200) {
                    Bitmap bmp = BitmapFactory.decodeStream(conn.getInputStream());
                    if (bmp != null) uiHandler.post(() -> iv.setImageBitmap(bmp));
                }
                conn.disconnect();
            } catch (Exception ignored) {}
        }, "gog-detail-cover").start();
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
        long cached = prefs.getLong("gog_size_" + gameId, -1);
        if (cached > 0) {
            if (sizeTV != null) sizeTV.setText(formatBytes(cached));
            return;
        }
        new Thread(() -> {
            String token = prefs.getString("access_token", null);
            long size = GogDownloadManager.fetchInstallSizeBytes(gameId, token);
            if (size > 0) prefs.edit().putLong("gog_size_" + gameId, size).apply();
            uiHandler.post(() -> {
                if (sizeTV != null) sizeTV.setText(size > 0 ? formatBytes(size) : "Unknown");
            });
        }, "gog-size-" + gameId).start();
    }

    private static String formatBytes(long bytes) {
        if (bytes >= 1_073_741_824L) return String.format("%.1f GB", bytes / 1_073_741_824.0);
        return String.format("%.0f MB", bytes / 1_048_576.0);
    }

    // ── Updates card (GOG-2) ──────────────────────────────────────────────────

    private View makeUpdatesCard() {
        LinearLayout card = makeCard();

        boolean installed = prefs.getString("gog_exe_" + gameId, null) != null;

        if (!installed) {
            TextView tv = new TextView(this);
            tv.setText("Install the game first to check for updates.");
            tv.setTextColor(0xFF555577);
            tv.setTextSize(13f);
            card.addView(tv);
            return card;
        }

        // Status text
        updateStatusTV = new TextView(this);
        updateStatusTV.setTextColor(0xFFCCCCCC);
        updateStatusTV.setTextSize(13f);
        String storedBuild = prefs.getString("gog_build_" + gameId, null);
        updateStatusTV.setText(storedBuild != null
                ? "Installed build: " + storedBuild.substring(0, Math.min(12, storedBuild.length())) + "…"
                : "Build ID not recorded — tap Check to verify");
        LinearLayout.LayoutParams stLp = new LinearLayout.LayoutParams(-1, -2);
        stLp.bottomMargin = dp(8);
        card.addView(updateStatusTV, stLp);

        // "Update available" button (hidden initially)
        updateBtn = makeBtn("Update Now", 0xFF0277BD);
        updateBtn.setVisibility(View.GONE);
        updateBtn.setOnClickListener(v -> {
            updateBtn.setVisibility(View.GONE);
            updateStatusTV.setText("Updating…");
            startInstall();
        });
        card.addView(updateBtn, btnLp());

        // Check button
        checkUpdatesBtn = makeBtn("Check for Updates", 0xFF333355);
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
                String token = prefs.getString("access_token", null);
                String url = "https://content-system.gog.com/products/" + gameId
                        + "/os/windows/builds?generation=2";
                java.net.HttpURLConnection conn =
                        (java.net.HttpURLConnection) new java.net.URL(url).openConnection();
                conn.setConnectTimeout(15000);
                conn.setReadTimeout(15000);
                conn.setRequestProperty("User-Agent", "GOG Galaxy");
                if (token != null) conn.setRequestProperty("Authorization", "Bearer " + token);

                String body = "";
                if (conn.getResponseCode() == 200) {
                    java.io.BufferedReader br = new java.io.BufferedReader(
                            new java.io.InputStreamReader(conn.getInputStream()));
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) sb.append(line);
                    body = sb.toString();
                }
                conn.disconnect();

                String latestBuild = null;
                if (!body.isEmpty()) {
                    org.json.JSONObject j = new org.json.JSONObject(body);
                    org.json.JSONArray items = j.optJSONArray("items");
                    if (items != null) {
                        for (int i = 0; i < items.length(); i++) {
                            org.json.JSONObject item = items.getJSONObject(i);
                            if ("windows".equals(item.optString("os"))) {
                                latestBuild = item.optString("build_id");
                                break;
                            }
                        }
                    }
                }

                final String latest = latestBuild;
                uiHandler.post(() -> {
                    if (checkUpdatesBtn != null) checkUpdatesBtn.setEnabled(true);
                    if (updateStatusTV == null) return;
                    if (latest == null) {
                        updateStatusTV.setText("Could not reach update server.");
                        return;
                    }
                    String stored = prefs.getString("gog_build_" + gameId, null);
                    if (stored == null) {
                        // First check — store as baseline
                        prefs.edit().putString("gog_build_" + gameId, latest).apply();
                        updateStatusTV.setText("Up to date (build " + latest.substring(0, Math.min(12, latest.length())) + "…)");
                        if (updateBtn != null) updateBtn.setVisibility(View.GONE);
                    } else if (stored.equals(latest)) {
                        updateStatusTV.setText("Up to date ✓");
                        if (updateBtn != null) updateBtn.setVisibility(View.GONE);
                    } else {
                        updateStatusTV.setText("Update available!\nInstalled: "
                                + stored.substring(0, Math.min(10, stored.length())) + "…"
                                + "  →  Latest: " + latest.substring(0, Math.min(10, latest.length())) + "…");
                        if (updateBtn != null) updateBtn.setVisibility(View.VISIBLE);
                    }
                });
            } catch (Exception e) {
                uiHandler.post(() -> {
                    if (checkUpdatesBtn != null) checkUpdatesBtn.setEnabled(true);
                    if (updateStatusTV != null) updateStatusTV.setText("Check failed: " + e.getMessage());
                });
            }
        }, "gog-update-check-" + gameId).start();
    }

    private static String formatDate(String iso) {
        if (iso == null || iso.length() < 10) return iso != null ? iso : "";
        String[] parts = iso.substring(0, 10).split("-");
        if (parts.length != 3) return iso.substring(0, 10);
        try {
            int year  = Integer.parseInt(parts[0]);
            int month = Integer.parseInt(parts[1]);
            int day   = Integer.parseInt(parts[2]);
            String[] months = {"Jan","Feb","Mar","Apr","May","Jun",
                               "Jul","Aug","Sep","Oct","Nov","Dec"};
            if (month < 1 || month > 12) return iso.substring(0, 10);
            return months[month - 1] + " " + day + ", " + year;
        } catch (Exception e) {
            return iso.substring(0, 10);
        }
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
        bg.setColor(0xFF161622);
        bg.setCornerRadius(dp(8));
        bg.setStroke(dp(1), 0xFF2A2A3A);
        card.setBackground(bg);
        return card;
    }

    private View makeSectionHeader(String text) {
        TextView tv = new TextView(this);
        tv.setText(text);
        tv.setTextColor(0xFF8888AA);
        tv.setTextSize(11f);
        tv.setTypeface(null, Typeface.BOLD);
        tv.setLetterSpacing(0.08f);
        tv.setPadding(dp(2), dp(16), 0, dp(6));
        return tv;
    }

    private LinearLayout.LayoutParams sectionHeaderLp() {
        return new LinearLayout.LayoutParams(-1, -2);
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

    // ── DLC card (GOG-3) ──────────────────────────────────────────────────────

    private LinearLayout makeDlcCard() {
        LinearLayout card = makeCard();
        String json = prefs.getString("gog_dlcs_" + gameId, null);
        if (json == null || json.equals("[]") || json.isEmpty()) {
            TextView tv = new TextView(this);
            tv.setText("No DLCs in your library for this game");
            tv.setTextColor(0xFF555577);
            tv.setTextSize(13f);
            card.addView(tv);
            return card;
        }
        try {
            JSONArray arr = new JSONArray(json);
            if (arr.length() == 0) {
                TextView tv = new TextView(this);
                tv.setText("No DLCs in your library for this game");
                tv.setTextColor(0xFF555577);
                tv.setTextSize(13f);
                card.addView(tv);
                return card;
            }

            TextView countTV = new TextView(this);
            countTV.setText(arr.length() + " DLC" + (arr.length() == 1 ? "" : "s") + " owned");
            countTV.setTextColor(0xFF888888);
            countTV.setTextSize(12f);
            countTV.setTypeface(null, Typeface.BOLD);
            card.addView(countTV, new LinearLayout.LayoutParams(-1, -2));

            TextView noteTV = new TextView(this);
            noteTV.setText("DLC content is included in gen2 game installs.");
            noteTV.setTextColor(0xFF555577);
            noteTV.setTextSize(11f);
            LinearLayout.LayoutParams noteLp = new LinearLayout.LayoutParams(-1, -2);
            noteLp.topMargin = dp(3);
            noteLp.bottomMargin = dp(6);
            card.addView(noteTV, noteLp);

            for (int i = 0; i < arr.length(); i++) {
                JSONObject dlc = arr.optJSONObject(i);
                if (dlc == null) continue;
                String dlcTitle = dlc.optString("title", "Unknown DLC");

                LinearLayout row = new LinearLayout(this);
                row.setOrientation(LinearLayout.HORIZONTAL);
                row.setGravity(Gravity.CENTER_VERTICAL);
                row.setPadding(0, dp(5), 0, dp(5));

                GradientDrawable rowBg = new GradientDrawable();
                rowBg.setColor(0xFF1E1E2E);
                rowBg.setCornerRadius(dp(4));
                row.setBackground(rowBg);

                TextView dlcTV = new TextView(this);
                dlcTV.setText(dlcTitle);
                dlcTV.setTextColor(0xFFDDDDDD);
                dlcTV.setTextSize(13f);
                dlcTV.setPadding(dp(8), 0, 0, 0);
                row.addView(dlcTV, new LinearLayout.LayoutParams(0, -2, 1f));

                TextView ownedTV = new TextView(this);
                ownedTV.setText("Owned");
                ownedTV.setTextColor(0xFF4CAF50);
                ownedTV.setTextSize(11f);
                ownedTV.setTypeface(null, Typeface.BOLD);
                ownedTV.setPadding(0, 0, dp(8), 0);
                row.addView(ownedTV, new LinearLayout.LayoutParams(-2, -2));

                LinearLayout.LayoutParams rowLp = new LinearLayout.LayoutParams(-1, -2);
                rowLp.topMargin = dp(4);
                card.addView(row, rowLp);
            }
        } catch (Exception e) {
            TextView tv = new TextView(this);
            tv.setText("Error reading DLC data");
            tv.setTextColor(0xFF555577);
            tv.setTextSize(13f);
            card.addView(tv);
        }
        return card;
    }

    // ── Cloud Saves card (GOG-1) ──────────────────────────────────────────────

    private View makeCloudSavesCard() {
        LinearLayout card = makeCard();

        // Save folder row
        LinearLayout folderRow = new LinearLayout(this);
        folderRow.setOrientation(LinearLayout.HORIZONTAL);
        folderRow.setGravity(android.view.Gravity.CENTER_VERTICAL);

        cloudSaveDirTV = new TextView(this);
        String savedDir = prefs.getString("gog_save_dir_" + gameId, null);
        cloudSaveDirTV.setText(savedDir != null ? shortenPath(savedDir) : "No save folder set");
        cloudSaveDirTV.setTextColor(savedDir != null ? 0xFFCCCCCC : 0xFF555577);
        cloudSaveDirTV.setTextSize(12f);
        cloudSaveDirTV.setMaxLines(2);
        folderRow.addView(cloudSaveDirTV, new LinearLayout.LayoutParams(0, -2, 1f));

        cloudBrowseBtn = makeBtn("Browse", 0xFF333355);
        cloudBrowseBtn.setOnClickListener(v -> {
            Intent intent = new Intent(this, FolderPickerActivity.class);
            startActivityForResult(intent, REQUEST_FOLDER_PICKER);
        });
        LinearLayout.LayoutParams browseLp = new LinearLayout.LayoutParams(-2, dp(36));
        browseLp.leftMargin = dp(8);
        folderRow.addView(cloudBrowseBtn, browseLp);

        LinearLayout.LayoutParams folderRowLp = new LinearLayout.LayoutParams(-1, -2);
        folderRowLp.bottomMargin = dp(10);
        card.addView(folderRow, folderRowLp);

        // Status line
        cloudSaveStatusTV = new TextView(this);
        cloudSaveStatusTV.setTextColor(0xFF8888AA);
        cloudSaveStatusTV.setTextSize(12f);
        cloudSaveStatusTV.setVisibility(android.view.View.GONE);
        LinearLayout.LayoutParams statusLp = new LinearLayout.LayoutParams(-1, -2);
        statusLp.bottomMargin = dp(8);
        card.addView(cloudSaveStatusTV, statusLp);

        // Upload / Download buttons
        cloudUploadBtn = makeBtn("Upload Saves", 0xFF0277BD);
        cloudUploadBtn.setEnabled(savedDir != null);
        cloudUploadBtn.setOnClickListener(v -> {
            String dir = prefs.getString("gog_save_dir_" + gameId, null);
            if (dir == null) { Toast.makeText(this, "Set a save folder first", Toast.LENGTH_SHORT).show(); return; }
            cloudUploadBtn.setEnabled(false);
            cloudDownloadBtn.setEnabled(false);
            showCloudStatus("Preparing upload…");
            GogCloudSaveManager.uploadSaves(this, gameId, new java.io.File(dir),
                new GogCloudSaveManager.Callback() {
                    @Override public void onStatus(String msg) { uiHandler.post(() -> showCloudStatus(msg)); }
                    @Override public void onDone(String msg)   { uiHandler.post(() -> { showCloudStatus(msg); enableCloudBtns(true); }); }
                    @Override public void onError(String msg)  { uiHandler.post(() -> { showCloudStatus("Error: " + msg); enableCloudBtns(true); }); }
                });
        });
        card.addView(cloudUploadBtn, btnLp());

        cloudDownloadBtn = makeBtn("Download Saves", 0xFF2E7D32);
        cloudDownloadBtn.setEnabled(savedDir != null);
        cloudDownloadBtn.setOnClickListener(v -> {
            String dir = prefs.getString("gog_save_dir_" + gameId, null);
            if (dir == null) { Toast.makeText(this, "Set a save folder first", Toast.LENGTH_SHORT).show(); return; }
            cloudUploadBtn.setEnabled(false);
            cloudDownloadBtn.setEnabled(false);
            showCloudStatus("Preparing download…");
            GogCloudSaveManager.downloadSaves(this, gameId, new java.io.File(dir),
                new GogCloudSaveManager.Callback() {
                    @Override public void onStatus(String msg) { uiHandler.post(() -> showCloudStatus(msg)); }
                    @Override public void onDone(String msg)   { uiHandler.post(() -> { showCloudStatus(msg); enableCloudBtns(true); }); }
                    @Override public void onError(String msg)  { uiHandler.post(() -> { showCloudStatus("Error: " + msg); enableCloudBtns(true); }); }
                });
        });
        card.addView(cloudDownloadBtn, btnLp());

        return card;
    }

    private void showCloudStatus(String msg) {
        if (cloudSaveStatusTV == null) return;
        cloudSaveStatusTV.setText(msg);
        cloudSaveStatusTV.setVisibility(android.view.View.VISIBLE);
    }

    private void enableCloudBtns(boolean enabled) {
        if (cloudUploadBtn != null) cloudUploadBtn.setEnabled(enabled);
        if (cloudDownloadBtn != null) cloudDownloadBtn.setEnabled(enabled);
    }

    private static String shortenPath(String path) {
        String[] parts = path.split("/");
        if (parts.length <= 3) return path;
        return "…/" + parts[parts.length - 2] + "/" + parts[parts.length - 1];
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_FOLDER_PICKER && resultCode == RESULT_OK && data != null) {
            String selectedPath = data.getStringExtra("path");
            if (selectedPath != null && !selectedPath.isEmpty()) {
                prefs.edit().putString("gog_save_dir_" + gameId, selectedPath).apply();
                if (cloudSaveDirTV != null) {
                    cloudSaveDirTV.setText(shortenPath(selectedPath));
                    cloudSaveDirTV.setTextColor(0xFFCCCCCC);
                }
                enableCloudBtns(true);
                Toast.makeText(this, "Save folder set", Toast.LENGTH_SHORT).show();
            }
        }
    }

    private View makeStubCard(String msg) {
        LinearLayout card = makeCard();
        TextView tv = new TextView(this);
        tv.setText(msg);
        tv.setTextColor(0xFF555577);
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
