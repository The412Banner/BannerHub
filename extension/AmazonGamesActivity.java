package app.revanced.extension.gamehub;

import android.app.Activity;
import android.app.AlertDialog;
import android.graphics.Bitmap;
import java.io.File;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
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

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Amazon Games library screen.
 *
 * Shows all owned games as collapsible cards.
 * Each card: cover art | title | developer | Install/Launch buttons
 *
 * Library sync: GetEntitlements (paginated) → cache in SharedPreferences JSON.
 * Install/Launch: Phase 3/4 (stub buttons for now).
 */
public class AmazonGamesActivity extends Activity {

    private static final String TAG        = "BH_AMAZON";
    private static final String PREFS_NAME = "bh_amazon_prefs";
    private static final String CACHE_KEY  = "amazon_library_cache";

    private final Handler uiHandler = new Handler(Looper.getMainLooper());

    private TextView     syncText;
    private LinearLayout gameListLayout;
    private ScrollView   scrollView;
    private ProgressBar  loadingBar;

    private List<AmazonGame> allGames       = new ArrayList<>();
    private View             expandedCard   = null;
    private TextView         expandedArrow  = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        buildUi();

        List<AmazonGame> cached = loadCachedGames();
        if (cached != null && !cached.isEmpty()) {
            showGames(cached);
            setSyncText(cached.size() + " game(s) — cached  •  tap ↺ to refresh");
        }
        startSync(cached == null || cached.isEmpty());
    }

    // ── UI ────────────────────────────────────────────────────────────────────

    private void buildUi() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0D0D0D);

        // Header
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.HORIZONTAL);
        header.setBackgroundColor(0xFF1A1410);
        header.setGravity(Gravity.CENTER_VERTICAL);
        header.setPadding(dp(8), dp(8), dp(8), dp(8));

        Button backBtn = new Button(this);
        backBtn.setText("←");
        backBtn.setTextColor(0xFFFFFFFF);
        backBtn.setBackgroundColor(0xFF333333);
        backBtn.setTextSize(16f);
        backBtn.setPadding(dp(12), 0, dp(12), 0);
        backBtn.setOnClickListener(v -> finish());
        header.addView(backBtn, new LinearLayout.LayoutParams(-2, dp(40)));

        TextView titleTV = new TextView(this);
        titleTV.setText("Amazon Games");
        titleTV.setTextColor(0xFFFF9900);
        titleTV.setTextSize(18f);
        titleTV.setTypeface(null, Typeface.BOLD);
        titleTV.setPadding(dp(12), 0, 0, 0);
        header.addView(titleTV, new LinearLayout.LayoutParams(0, -2, 1f));

        Button refreshBtn = new Button(this);
        refreshBtn.setText("↺");
        refreshBtn.setTextColor(0xFFFFFFFF);
        refreshBtn.setBackgroundColor(0xFF333333);
        refreshBtn.setTextSize(16f);
        refreshBtn.setPadding(dp(12), 0, dp(12), 0);
        refreshBtn.setOnClickListener(v -> startSync(true));
        header.addView(refreshBtn, new LinearLayout.LayoutParams(-2, dp(40)));

        root.addView(header, new LinearLayout.LayoutParams(-1, -2));

        // Sync status
        syncText = new TextView(this);
        syncText.setText("Loading Amazon library…");
        syncText.setTextColor(0xFFCCCCCC);
        syncText.setTextSize(13f);
        syncText.setPadding(dp(12), dp(6), dp(12), dp(6));
        root.addView(syncText, new LinearLayout.LayoutParams(-1, -2));

        // Loading bar
        loadingBar = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        loadingBar.setIndeterminate(true);
        loadingBar.setVisibility(View.GONE);
        root.addView(loadingBar, new LinearLayout.LayoutParams(-1, dp(4)));

        // Game list
        scrollView = new ScrollView(this);
        gameListLayout = new LinearLayout(this);
        gameListLayout.setOrientation(LinearLayout.VERTICAL);
        gameListLayout.setPadding(dp(8), dp(4), dp(8), dp(8));
        scrollView.addView(gameListLayout);
        root.addView(scrollView, new LinearLayout.LayoutParams(-1, 0, 1f));

        setContentView(root);
    }

    // ── Library sync ──────────────────────────────────────────────────────────

    private void startSync(boolean forceRefresh) {
        if (!forceRefresh) return;

        uiHandler.post(() -> {
            setSyncText("Fetching Amazon library…");
            loadingBar.setVisibility(View.VISIBLE);
        });

        new Thread(() -> {
            AmazonCredentialStore.Credentials creds = AmazonCredentialStore.load(AmazonGamesActivity.this);
            if (creds == null || creds.accessToken == null) {
                uiHandler.post(() -> {
                    loadingBar.setVisibility(View.GONE);
                    setSyncText("Not logged in");
                    Toast.makeText(AmazonGamesActivity.this,
                            "Please log in to Amazon Games first", Toast.LENGTH_SHORT).show();
                    finish();
                });
                return;
            }

            // Auto-refresh token if near expiry
            String token = AmazonCredentialStore.getValidAccessToken(AmazonGamesActivity.this);
            if (token == null) {
                uiHandler.post(() -> {
                    loadingBar.setVisibility(View.GONE);
                    setSyncText("Token refresh failed");
                });
                return;
            }

            Log.d(TAG, "Fetching Amazon entitlements...");
            List<AmazonGame> games = AmazonApiClient.getEntitlements(token, creds.deviceSerial);

            if (games == null || games.isEmpty()) {
                uiHandler.post(() -> {
                    loadingBar.setVisibility(View.GONE);
                    setSyncText("No games found in Amazon library");
                });
                return;
            }

            // Sort by title
            Collections.sort(games, Comparator.comparing(g -> g.title.toLowerCase()));

            // Preserve install state from cache
            List<AmazonGame> cached = loadCachedGames();
            if (cached != null) {
                for (AmazonGame fresh : games) {
                    for (AmazonGame old : cached) {
                        if (old.productId.equals(fresh.productId)) {
                            fresh.isInstalled  = old.isInstalled;
                            fresh.installPath  = old.installPath;
                            fresh.versionId    = old.versionId;
                            fresh.downloadSize = old.downloadSize;
                            fresh.installSize  = old.installSize;
                            break;
                        }
                    }
                }
            }

            saveCachedGames(games);

            uiHandler.post(() -> {
                loadingBar.setVisibility(View.GONE);
                setSyncText(games.size() + " game(s) in library");
                showGames(games);
            });

        }).start();
    }

    // ── Render game cards ─────────────────────────────────────────────────────

    private void showGames(List<AmazonGame> games) {
        allGames = games;
        gameListLayout.removeAllViews();
        expandedCard  = null;
        expandedArrow = null;
        for (AmazonGame game : games) {
            gameListLayout.addView(buildCard(game));
        }
    }

    private View buildCard(AmazonGame game) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundColor(0xFF1A1410);
        LinearLayout.LayoutParams cardLp = new LinearLayout.LayoutParams(-1, -2);
        cardLp.topMargin = dp(6);
        card.setLayoutParams(cardLp);

        // ── Top row ────────────────────────────────────────────────────────
        LinearLayout topRow = new LinearLayout(this);
        topRow.setOrientation(LinearLayout.HORIZONTAL);
        topRow.setGravity(Gravity.CENTER_VERTICAL);
        topRow.setPadding(dp(8), dp(8), dp(8), dp(8));
        topRow.setClickable(true);
        topRow.setFocusable(true);

        // Cover art (60×60)
        ImageView cover = new ImageView(this);
        cover.setBackgroundColor(0xFF2A2018);
        cover.setScaleType(ImageView.ScaleType.CENTER_CROP);
        LinearLayout.LayoutParams coverLp = new LinearLayout.LayoutParams(dp(60), dp(60));
        coverLp.rightMargin = dp(10);
        topRow.addView(cover, coverLp);

        if (!game.artUrl.isEmpty()) {
            loadCoverAsync(cover, game.artUrl);
        }

        // Title + developer
        LinearLayout info = new LinearLayout(this);
        info.setOrientation(LinearLayout.VERTICAL);
        info.setGravity(Gravity.CENTER_VERTICAL);

        TextView titleTV = new TextView(this);
        titleTV.setText(game.title);
        titleTV.setTextColor(0xFFFFFFFF);
        titleTV.setTextSize(14f);
        titleTV.setTypeface(null, Typeface.BOLD);
        titleTV.setSingleLine(true);
        info.addView(titleTV, new LinearLayout.LayoutParams(-1, -2));

        if (!game.developer.isEmpty()) {
            TextView devTV = new TextView(this);
            devTV.setText(game.developer);
            devTV.setTextColor(0xFF888888);
            devTV.setTextSize(11f);
            devTV.setSingleLine(true);
            info.addView(devTV, new LinearLayout.LayoutParams(-1, -2));
        }

        if (game.isInstalled) {
            TextView instTV = new TextView(this);
            instTV.setText("✓ Installed");
            instTV.setTextColor(0xFF44CC44);
            instTV.setTextSize(11f);
            info.addView(instTV, new LinearLayout.LayoutParams(-1, -2));
        }

        topRow.addView(info, new LinearLayout.LayoutParams(0, -2, 1f));

        // Expand arrow
        TextView arrow = new TextView(this);
        arrow.setText("▼");
        arrow.setTextColor(0xFF888888);
        arrow.setTextSize(14f);
        arrow.setPadding(dp(8), 0, dp(4), 0);
        topRow.addView(arrow, new LinearLayout.LayoutParams(-2, -2));

        card.addView(topRow, new LinearLayout.LayoutParams(-1, -2));

        // ── Expand section ─────────────────────────────────────────────────
        LinearLayout expandSection = buildExpandSection(game);
        expandSection.setVisibility(View.GONE);
        card.addView(expandSection, new LinearLayout.LayoutParams(-1, -2));

        // Toggle on card click
        topRow.setOnClickListener(v -> {
            boolean isExpanded = expandSection.getVisibility() == View.VISIBLE;

            // Collapse previously expanded card
            if (expandedCard != null && expandedCard != expandSection) {
                expandedCard.setVisibility(View.GONE);
                if (expandedArrow != null) expandedArrow.setText("▼");
            }

            if (isExpanded) {
                expandSection.setVisibility(View.GONE);
                arrow.setText("▼");
                expandedCard  = null;
                expandedArrow = null;
            } else {
                expandSection.setVisibility(View.VISIBLE);
                arrow.setText("▲");
                expandedCard  = expandSection;
                expandedArrow = arrow;
            }
        });

        return card;
    }

    private LinearLayout buildExpandSection(AmazonGame game) {
        LinearLayout section = new LinearLayout(this);
        section.setOrientation(LinearLayout.VERTICAL);
        section.setBackgroundColor(0xFF111009);
        section.setPadding(dp(12), dp(8), dp(12), dp(12));

        // Publisher
        if (!game.publisher.isEmpty()) {
            TextView pub = new TextView(this);
            pub.setText("Publisher: " + game.publisher);
            pub.setTextColor(0xFF999999);
            pub.setTextSize(12f);
            section.addView(pub, new LinearLayout.LayoutParams(-1, -2));
        }

        // Product ID
        TextView pid = new TextView(this);
        pid.setText("ID: " + game.shortId());
        pid.setTextColor(0xFF666666);
        pid.setTextSize(11f);
        LinearLayout.LayoutParams pidLp = new LinearLayout.LayoutParams(-1, -2);
        pidLp.topMargin = dp(4);
        section.addView(pid, pidLp);

        // Button row
        LinearLayout btnRow = new LinearLayout(this);
        btnRow.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams btnRowLp = new LinearLayout.LayoutParams(-1, -2);
        btnRowLp.topMargin = dp(10);
        section.addView(btnRow, btnRowLp);

        if (!game.isInstalled) {
            // Install button
            Button installBtn = new Button(this);
            installBtn.setText("Install");
            installBtn.setBackgroundColor(0xFFFF9900);
            installBtn.setTextColor(0xFF000000);
            installBtn.setTextSize(13f);
            installBtn.setOnClickListener(v -> startInstall(game, installBtn));
            btnRow.addView(installBtn, new LinearLayout.LayoutParams(-2, dp(40)));
        } else {
            // Launch button
            Button launchBtn = new Button(this);
            launchBtn.setText("Launch");
            launchBtn.setBackgroundColor(0xFFFF9900);
            launchBtn.setTextColor(0xFF000000);
            launchBtn.setTextSize(13f);
            launchBtn.setOnClickListener(v ->
                    Toast.makeText(this,
                            "Launch coming in Phase 4: " + game.title, Toast.LENGTH_SHORT).show());
            btnRow.addView(launchBtn, new LinearLayout.LayoutParams(-2, dp(40)));

            // Uninstall button
            Button unBtn = new Button(this);
            unBtn.setText("Uninstall");
            unBtn.setBackgroundColor(0xFF444444);
            unBtn.setTextColor(0xFFFFFFFF);
            unBtn.setTextSize(13f);
            LinearLayout.LayoutParams unLp = new LinearLayout.LayoutParams(-2, dp(40));
            unLp.leftMargin = dp(8);
            unBtn.setOnClickListener(v -> confirmUninstall(game));
            btnRow.addView(unBtn, unLp);
        }

        return section;
    }

    // ── Install / Uninstall ───────────────────────────────────────────────────

    private void startInstall(AmazonGame game, Button installBtn) {
        installBtn.setEnabled(false);
        installBtn.setText("Installing…");

        new Thread(() -> {
            String token = AmazonCredentialStore.getValidAccessToken(this);
            if (token == null) {
                uiHandler.post(() -> {
                    installBtn.setEnabled(true);
                    installBtn.setText("Install");
                    Toast.makeText(this, "Login required", Toast.LENGTH_SHORT).show();
                });
                return;
            }

            // Install dir: filesDir/Amazon/{title sanitized}
            String sanitized = game.title.replaceAll("[^a-zA-Z0-9 \\-_]", "").trim();
            if (sanitized.isEmpty()) sanitized = "game_" + game.productId.hashCode();
            File installDir = new File(new File(getFilesDir(), "Amazon"), sanitized);

            AmazonDownloadManager.ProgressCallback cb = (dl, total, file) -> {
                int pct = (total > 0) ? (int) (dl * 100 / total) : -1;
                String label = pct >= 0 ? "Installing… " + pct + "%" : "Installing…";
                uiHandler.post(() -> installBtn.setText(label));
            };

            boolean ok = AmazonDownloadManager.install(
                    this, game, token, installDir, cb, null);

            if (ok) {
                game.isInstalled = true;
                game.installPath  = installDir.getAbsolutePath();
                // Update cache with install status
                List<AmazonGame> cached = loadCachedGames();
                if (cached != null) {
                    for (AmazonGame c : cached) {
                        if (c.productId.equals(game.productId)) {
                            c.isInstalled = true;
                            c.installPath = game.installPath;
                            break;
                        }
                    }
                    saveCachedGames(cached);
                }
                uiHandler.post(() -> {
                    Toast.makeText(this, game.title + " installed!", Toast.LENGTH_SHORT).show();
                    // Refresh the card list to show Launch button
                    showGames(allGames);
                });
            } else {
                uiHandler.post(() -> {
                    installBtn.setEnabled(true);
                    installBtn.setText("Install");
                    Toast.makeText(this, "Install failed: " + game.title, Toast.LENGTH_SHORT).show();
                });
            }
        }).start();
    }

    private void confirmUninstall(AmazonGame game) {
        new android.app.AlertDialog.Builder(this)
            .setTitle("Uninstall " + game.title)
            .setMessage("This will delete all installed game files. Continue?")
            .setPositiveButton("Uninstall", (d, w) -> uninstallGame(game))
            .setNegativeButton("Cancel", null)
            .show();
    }

    private void uninstallGame(AmazonGame game) {
        new Thread(() -> {
            if (!game.installPath.isEmpty()) {
                deleteDir(new File(game.installPath));
            }
            game.isInstalled = true; // will be set false below
            game.isInstalled = false;
            game.installPath  = "";

            List<AmazonGame> cached = loadCachedGames();
            if (cached != null) {
                for (AmazonGame c : cached) {
                    if (c.productId.equals(game.productId)) {
                        c.isInstalled = false;
                        c.installPath  = "";
                        break;
                    }
                }
                saveCachedGames(cached);
            }
            uiHandler.post(() -> {
                Toast.makeText(this, game.title + " uninstalled", Toast.LENGTH_SHORT).show();
                showGames(allGames);
            });
        }).start();
    }

    private static void deleteDir(File dir) {
        if (dir == null || !dir.exists()) return;
        if (dir.isDirectory()) {
            File[] children = dir.listFiles();
            if (children != null) {
                for (File child : children) deleteDir(child);
            }
        }
        dir.delete();
    }

    // ── Cover art async loader ────────────────────────────────────────────────

    private void loadCoverAsync(ImageView view, String url) {
        new Thread(() -> {
            try {
                HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
                conn.setConnectTimeout(10000);
                conn.setReadTimeout(15000);
                conn.setRequestProperty("User-Agent", AmazonAuthClient.USER_AGENT);
                conn.connect();
                if (conn.getResponseCode() == 200) {
                    Bitmap bmp = BitmapFactory.decodeStream(conn.getInputStream());
                    if (bmp != null) uiHandler.post(() -> view.setImageBitmap(bmp));
                }
                conn.disconnect();
            } catch (Exception ignored) {}
        }).start();
    }

    // ── Cache ─────────────────────────────────────────────────────────────────

    private void saveCachedGames(List<AmazonGame> games) {
        try {
            JSONArray arr = new JSONArray();
            for (AmazonGame g : games) {
                JSONObject j = new JSONObject();
                j.put("productId",     g.productId);
                j.put("entitlementId", g.entitlementId);
                j.put("title",         g.title);
                j.put("artUrl",        g.artUrl);
                j.put("heroUrl",       g.heroUrl);
                j.put("developer",     g.developer);
                j.put("publisher",     g.publisher);
                j.put("productSku",    g.productSku);
                j.put("isInstalled",   g.isInstalled);
                j.put("installPath",   g.installPath);
                j.put("versionId",     g.versionId);
                j.put("downloadSize",  g.downloadSize);
                j.put("installSize",   g.installSize);
                arr.put(j);
            }
            getSharedPreferences(PREFS_NAME, 0).edit()
                    .putString(CACHE_KEY, arr.toString()).apply();
        } catch (Exception e) {
            Log.e(TAG, "saveCachedGames failed", e);
        }
    }

    private List<AmazonGame> loadCachedGames() {
        try {
            String json = getSharedPreferences(PREFS_NAME, 0)
                    .getString(CACHE_KEY, null);
            if (json == null) return null;

            JSONArray arr = new JSONArray(json);
            List<AmazonGame> games = new ArrayList<>();
            for (int i = 0; i < arr.length(); i++) {
                JSONObject j = arr.getJSONObject(i);
                AmazonGame g = new AmazonGame();
                g.productId     = j.optString("productId", "");
                g.entitlementId = j.optString("entitlementId", "");
                g.title         = j.optString("title", "");
                g.artUrl        = j.optString("artUrl", "");
                g.heroUrl       = j.optString("heroUrl", "");
                g.developer     = j.optString("developer", "");
                g.publisher     = j.optString("publisher", "");
                g.productSku    = j.optString("productSku", "");
                g.isInstalled   = j.optBoolean("isInstalled", false);
                g.installPath   = j.optString("installPath", "");
                g.versionId     = j.optString("versionId", "");
                g.downloadSize  = j.optLong("downloadSize", 0L);
                g.installSize   = j.optLong("installSize", 0L);
                games.add(g);
            }
            return games;
        } catch (Exception e) {
            Log.e(TAG, "loadCachedGames failed", e);
            return null;
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private void setSyncText(String text) {
        if (syncText != null) syncText.setText(text);
    }

    private int dp(int v) {
        return (int) (v * getResources().getDisplayMetrics().density);
    }
}
