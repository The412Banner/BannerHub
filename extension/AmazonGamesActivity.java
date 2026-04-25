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
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Amazon Games library screen — UI mirrors GogGamesActivity.
 *
 * View modes: LIST (collapsible cards) · GRID · POSTER
 * Install flow: Install → progress bar → Cancel → Add to Launcher
 * Exe picker shown on install complete if multiple .exe files found.
 * Installed state stored in bh_amazon_prefs: amazon_exe_{productId}.
 */
public class AmazonGamesActivity extends Activity {

    private static final String TAG          = "BH_AMAZON";
    private static final String PREFS_NAME   = "bh_amazon_prefs";
    private static final String CACHE_KEY    = "amazon_library_cache";
    private static final String VIEW_MODE_KEY = "amazon_view_mode";
    private static final int REQ_GAME_DETAIL  = 1001;
    private static final int REQ_DOWNLOADS    = 1002;

    // Amazon brand colours
    private static final int COLOR_ACCENT   = 0xFFFF9900;   // orange — install btn / title
    private static final int COLOR_ADD      = 0xFF2E7D32;   // green  — Add to Launcher btn
    private static final int COLOR_CANCEL   = 0xFFCC3333;   // red    — cancel btn
    private static final int COLOR_CARD_BG  = 0xFF1A1410;   // dark brownish card background
    private static final int COLOR_HDR_BG   = 0xFF1A1410;
    private static final int COLOR_ROOT_BG  = 0xFF0D0D0D;

    private final Handler uiHandler = new Handler(Looper.getMainLooper());

    private SharedPreferences prefs;
    private TextView    syncText;
    private LinearLayout gameListLayout;
    private ScrollView  scrollView;
    private Button      refreshBtn;
    private Button      viewToggleBtn;
    private EditText    searchBar;
    private List<AmazonGame> allGames = new ArrayList<>();
    private View        expandedSection = null;
    private TextView    expandedArrow   = null;
    private String      viewMode;

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs    = getSharedPreferences(PREFS_NAME, 0);
        viewMode = prefs.getString(VIEW_MODE_KEY, "list");
        buildUi();
        List<AmazonGame> cached = loadCachedGames();
        if (cached != null && !cached.isEmpty()) {
            showGames(cached);
            int cn = cached.size(); setSync(cn + (cn == 1 ? " game" : " games") + " — cached  •  tap ↺ to refresh");
        }
        startSync(cached == null || cached.isEmpty());
    }

    // ── UI construction ───────────────────────────────────────────────────────

    private void buildUi() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(COLOR_ROOT_BG);

        // Header
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.HORIZONTAL);
        header.setBackgroundColor(COLOR_HDR_BG);
        header.setGravity(Gravity.CENTER_VERTICAL);
        header.setPadding(dp(8), dp(8), dp(8), dp(8));

        Button backBtn = new Button(this);
        backBtn.setText("←");
        backBtn.setTextColor(0xFFFFFFFF);
        GradientDrawable backBtnBg = new GradientDrawable();
        backBtnBg.setColor(0xFF333333);
        backBtnBg.setCornerRadius(dp(4));
        backBtn.setBackground(backBtnBg);
        backBtn.setTextSize(16f);
        backBtn.setPadding(dp(12), 0, dp(12), 0);
        backBtn.setOnFocusChangeListener((v, hasFocus) -> {
            backBtnBg.setColor(hasFocus ? 0xFF555555 : 0xFF333333);
            backBtnBg.setStroke(hasFocus ? dp(2) : 0, hasFocus ? 0xFFFFD700 : 0x00000000);
        });
        backBtn.setOnClickListener(v -> finish());
        header.addView(backBtn, new LinearLayout.LayoutParams(-2, dp(40)));

        TextView titleTV = new TextView(this);
        titleTV.setText("Amazon Games");
        titleTV.setTextColor(COLOR_ACCENT);
        titleTV.setTextSize(18f);
        titleTV.setTypeface(null, Typeface.BOLD);
        titleTV.setPadding(dp(12), 0, 0, 0);
        header.addView(titleTV, new LinearLayout.LayoutParams(0, -2, 1f));

        viewToggleBtn = new Button(this);
        viewToggleBtn.setText(viewModeIcon(viewMode));
        viewToggleBtn.setTextColor(0xFFFFFFFF);
        GradientDrawable viewToggleBtnBg = new GradientDrawable();
        viewToggleBtnBg.setColor(0xFF333333);
        viewToggleBtnBg.setCornerRadius(dp(4));
        viewToggleBtn.setBackground(viewToggleBtnBg);
        viewToggleBtn.setTextSize(16f);
        viewToggleBtn.setPadding(dp(12), 0, dp(12), 0);
        viewToggleBtn.setOnFocusChangeListener((v, hasFocus) -> {
            viewToggleBtnBg.setColor(hasFocus ? 0xFF555555 : 0xFF333333);
            viewToggleBtnBg.setStroke(hasFocus ? dp(2) : 0, hasFocus ? 0xFFFFD700 : 0x00000000);
        });
        viewToggleBtn.setOnClickListener(v -> {
            if ("list".equals(viewMode))        viewMode = "grid";
            else if ("grid".equals(viewMode))   viewMode = "poster";
            else                                viewMode = "list";
            prefs.edit().putString(VIEW_MODE_KEY, viewMode).apply();
            viewToggleBtn.setText(viewModeIcon(viewMode));
            expandedSection = null;
            expandedArrow   = null;
            applyFilter(searchBar != null ? searchBar.getText().toString() : "");
        });
        header.addView(viewToggleBtn, new LinearLayout.LayoutParams(-2, dp(40)));

        refreshBtn = new Button(this);
        refreshBtn.setText("↺");
        refreshBtn.setTextColor(0xFFFFFFFF);
        GradientDrawable refreshBtnBg = new GradientDrawable();
        refreshBtnBg.setColor(0xFF333333);
        refreshBtnBg.setCornerRadius(dp(4));
        refreshBtn.setBackground(refreshBtnBg);
        refreshBtn.setTextSize(16f);
        refreshBtn.setPadding(dp(12), 0, dp(12), 0);
        refreshBtn.setOnFocusChangeListener((v, hasFocus) -> {
            refreshBtnBg.setColor(hasFocus ? 0xFF555555 : 0xFF333333);
            refreshBtnBg.setStroke(hasFocus ? dp(2) : 0, hasFocus ? 0xFFFFD700 : 0x00000000);
        });
        refreshBtn.setOnClickListener(v -> startSync(true));
        header.addView(refreshBtn, new LinearLayout.LayoutParams(-2, dp(40)));

        Button dlBtn = new Button(this);
        dlBtn.setText("⬇");
        dlBtn.setTextColor(0xFFFFFFFF);
        GradientDrawable dlBtnBg = new GradientDrawable();
        dlBtnBg.setColor(0xFF333333);
        dlBtnBg.setCornerRadius(dp(4));
        dlBtn.setBackground(dlBtnBg);
        dlBtn.setTextSize(16f);
        dlBtn.setPadding(dp(12), 0, dp(12), 0);
        dlBtn.setOnFocusChangeListener((v, hasFocus) -> {
            dlBtnBg.setColor(hasFocus ? 0xFF555555 : 0xFF333333);
            dlBtnBg.setStroke(hasFocus ? dp(2) : 0, hasFocus ? 0xFFFFD700 : 0x00000000);
        });
        dlBtn.setOnClickListener(v -> startActivityForResult(
                new android.content.Intent(this, BhDownloadsActivity.class), REQ_DOWNLOADS));
        LinearLayout.LayoutParams dlLp = new LinearLayout.LayoutParams(-2, dp(40));
        dlLp.setMargins(dp(4), 0, 0, 0);
        header.addView(dlBtn, dlLp);

        root.addView(header, new LinearLayout.LayoutParams(-1, -2));

        // Search bar
        searchBar = new EditText(this);
        searchBar.setHint("Search games…");
        searchBar.setHintTextColor(0xFF666666);
        searchBar.setTextColor(0xFFFFFFFF);
        searchBar.setTextSize(14f);
        searchBar.setBackgroundColor(0xFF221A10);
        searchBar.setPadding(dp(12), dp(8), dp(12), dp(8));
        searchBar.setSingleLine(true);
        searchBar.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int st, int c, int a) {}
            @Override public void onTextChanged(CharSequence s, int st, int b, int c) {
                applyFilter(s.toString());
            }
            @Override public void afterTextChanged(Editable s) {}
        });
        root.addView(searchBar, new LinearLayout.LayoutParams(-1, -2));

        // Sync status
        syncText = new TextView(this);
        syncText.setText("Loading Amazon library…");
        syncText.setTextColor(0xFFCCCCCC);
        syncText.setTextSize(13f);
        syncText.setPadding(dp(12), dp(6), dp(12), dp(6));
        syncText.setBackgroundColor(0xFF111111);
        root.addView(syncText, new LinearLayout.LayoutParams(-1, -2));

        // Scrollable game list
        scrollView = new ScrollView(this);
        scrollView.setBackgroundColor(COLOR_ROOT_BG);
        scrollView.setVisibility(View.GONE);

        gameListLayout = new LinearLayout(this);
        gameListLayout.setOrientation(LinearLayout.VERTICAL);
        gameListLayout.setPadding(dp(8), dp(8), dp(8), dp(8));
        scrollView.addView(gameListLayout, new FrameLayout.LayoutParams(-1, -2));

        root.addView(scrollView, new LinearLayout.LayoutParams(-1, 0, 1f));
        setContentView(root);
    }

    // ── Library sync ──────────────────────────────────────────────────────────

    private void startSync(boolean showProgress) {
        uiHandler.post(() -> {
            if (refreshBtn != null) refreshBtn.setEnabled(false);
            if (showProgress) setSync("Loading Amazon library…");
        });
        new Thread(() -> syncLibrary(showProgress), "amazon-sync").start();
    }

    private void syncLibrary(boolean showProgress) {
        try {
            if (showProgress) setSync("Checking credentials…");
            AmazonCredentialStore.Credentials creds =
                    AmazonCredentialStore.load(AmazonGamesActivity.this);
            if (creds == null || creds.accessToken == null) {
                setSync("Not logged in");
                enableRefresh();
                uiHandler.post(() -> {
                    Toast.makeText(this, "Please log in to Amazon Games first",
                            Toast.LENGTH_SHORT).show();
                    finish();
                });
                return;
            }

            if (showProgress) setSync("Refreshing token…");
            String token = AmazonCredentialStore.getValidAccessToken(this);
            if (token == null) { setSync("Token refresh failed"); enableRefresh(); return; }

            if (showProgress) setSync("Fetching game list…");
            List<AmazonGame> allEntitlements = AmazonApiClient.getEntitlements(token, creds.deviceSerial);

            if (allEntitlements == null || allEntitlements.isEmpty()) {
                setSync("No games found in Amazon library");
                enableRefresh();
                return;
            }

            // Separate DLCs from base games; store DLC→base associations in prefs
            List<AmazonGame> games = new ArrayList<>();
            Map<String, JSONArray> amazonDlcMap = new HashMap<>();
            for (AmazonGame g : allEntitlements) {
                if (g.isDLC && !g.parentProductId.isEmpty()) {
                    JSONArray arr = amazonDlcMap.get(g.parentProductId);
                    if (arr == null) { arr = new JSONArray(); amazonDlcMap.put(g.parentProductId, arr); }
                    try {
                        JSONObject dlcObj = new JSONObject();
                        dlcObj.put("eid",   g.entitlementId);
                        dlcObj.put("pid",   g.productId);
                        dlcObj.put("title", g.title);
                        arr.put(dlcObj);
                    } catch (Exception ignored) {}
                } else {
                    games.add(g);
                }
            }
            SharedPreferences.Editor dlcEd = prefs.edit();
            for (Map.Entry<String, JSONArray> e : amazonDlcMap.entrySet()) {
                dlcEd.putString("amazon_dlcs_" + e.getKey(), e.getValue().toString());
            }
            dlcEd.apply();

            if (games.isEmpty()) games = allEntitlements; // fallback: show everything if no base games detected

            Collections.sort(games, (a, b) -> a.title.compareToIgnoreCase(b.title));

            // Restore install state from cache
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

            // Check for updates on installed games
            checkForUpdates(token, games);

            saveCachedGames(games);

            final List<AmazonGame> finalGames = games;
            uiHandler.post(() -> {
                showGames(finalGames);
                int fn = finalGames.size(); setSync(fn + (fn == 1 ? " game" : " games") + " — tap a card to install");
                enableRefresh();
            });
        } catch (Exception e) {
            Log.e(TAG, "syncLibrary error", e);
            setSync("Error: " + e.getMessage());
            enableRefresh();
        }
    }

    private void showGames(List<AmazonGame> games) {
        allGames = games;
        String q = searchBar != null ? searchBar.getText().toString() : "";
        applyFilter(q);
        scrollView.setVisibility(View.VISIBLE);
    }

    private void applyFilter(String query) {
        List<AmazonGame> filtered;
        if (query == null || query.trim().isEmpty()) {
            filtered = allGames;
        } else {
            String q = query.trim().toLowerCase();
            filtered = new ArrayList<>();
            for (AmazonGame g : allGames)
                if (g.title.toLowerCase().contains(q)) filtered.add(g);
        }
        final List<AmazonGame> result = filtered;
        uiHandler.post(() -> {
            gameListLayout.removeAllViews();
            if (result.isEmpty()) {
                gameListLayout.setPadding(dp(8), dp(8), dp(8), dp(8));
                TextView emptyTV = new TextView(AmazonGamesActivity.this);
                String q2 = query == null ? "" : query.trim();
                emptyTV.setText(q2.isEmpty() ? "Your Amazon library is empty"
                                             : "No results for \u201c" + q2 + "\u201d");
                emptyTV.setTextColor(0xFF666666);
                emptyTV.setTextSize(14f);
                emptyTV.setGravity(Gravity.CENTER);
                LinearLayout.LayoutParams emLp = new LinearLayout.LayoutParams(-1, -2);
                emLp.topMargin = dp(32);
                gameListLayout.addView(emptyTV, emLp);
            } else if ("grid".equals(viewMode)) {
                gameListLayout.setPadding(dp(4), dp(4), dp(4), dp(4));
                addGamesAsGrid(result, 105, dp(3), dp(6));
            } else if ("poster".equals(viewMode)) {
                gameListLayout.setPadding(dp(4), dp(4), dp(4), dp(4));
                addGamesAsGrid(result, 176, dp(10), dp(10));
            } else {
                gameListLayout.setPadding(dp(8), dp(8), dp(8), dp(8));
                for (AmazonGame g : result) addGameCard(g);
            }
            scrollView.setVisibility(View.VISIBLE);
        });
    }

    private void checkForUpdates(String token, List<AmazonGame> games) {
        for (AmazonGame game : games) {
            String installedExe = prefs.getString("amazon_exe_" + game.productId, null);
            if (installedExe == null || game.productId.isEmpty()) continue;
            try {
                String liveVersion = AmazonApiClient.getLiveVersionId(token, game.productId);
                if (liveVersion != null && !liveVersion.isEmpty()
                        && !liveVersion.equals(game.versionId)) {
                    Log.d(TAG, "Update available: " + game.title
                            + " (" + game.versionId + " → " + liveVersion + ")");
                    game.versionId = liveVersion + "_UPDATE_AVAILABLE";
                }
            } catch (Exception e) {
                Log.w(TAG, "Update check failed for: " + game.title, e);
            }
        }
    }

    private void enableRefresh() {
        uiHandler.post(() -> { if (refreshBtn != null) refreshBtn.setEnabled(true); });
    }

    // ── LIST view: collapsible game cards ─────────────────────────────────────

    private void addGameCard(AmazonGame game) {
        boolean isInstalled = prefs.getString("amazon_exe_" + game.productId, null) != null;

        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(10), dp(10), dp(10), dp(10));
        GradientDrawable cardBg = new GradientDrawable();
        cardBg.setColor(COLOR_CARD_BG);
        cardBg.setCornerRadius(dp(6));
        card.setBackground(cardBg);
        card.setFocusable(true);
        card.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);
        card.setOnFocusChangeListener((v, hasFocus) -> {
            cardBg.setColor(hasFocus ? 0xFF2B251A : COLOR_CARD_BG);
            cardBg.setStroke(hasFocus ? dp(3) : 0, hasFocus ? 0xFFFFD700 : 0x00000000);
        });
        LinearLayout.LayoutParams cardLp = new LinearLayout.LayoutParams(-1, -2);
        cardLp.bottomMargin = dp(8);

        // ── Collapsed header row ───────────────────────────────────────────────
        LinearLayout topRow = new LinearLayout(this);
        topRow.setOrientation(LinearLayout.HORIZONTAL);
        topRow.setGravity(Gravity.CENTER_VERTICAL);

        ImageView coverIV = new ImageView(this);
        coverIV.setScaleType(ImageView.ScaleType.CENTER_CROP);
        GradientDrawable coverBg = new GradientDrawable();
        coverBg.setColor(0xFF221A10);
        coverBg.setCornerRadius(dp(4));
        coverIV.setBackground(coverBg);
        LinearLayout.LayoutParams coverLp = new LinearLayout.LayoutParams(dp(60), dp(60));
        coverLp.rightMargin = dp(10);
        topRow.addView(coverIV, coverLp);
        loadImage(game, coverIV);

        LinearLayout titleRow = new LinearLayout(this);
        titleRow.setOrientation(LinearLayout.HORIZONTAL);
        titleRow.setGravity(Gravity.CENTER_VERTICAL);

        TextView titleTV = new TextView(this);
        titleTV.setText(game.title);
        titleTV.setTextColor(0xFFFFFFFF);
        titleTV.setTextSize(15f);
        titleTV.setTypeface(null, Typeface.BOLD);
        titleTV.setMaxLines(1);
        titleTV.setEllipsize(android.text.TextUtils.TruncateAt.END);
        titleRow.addView(titleTV, new LinearLayout.LayoutParams(-2, -2));

        TextView collapsedCheckTV = new TextView(this);
        collapsedCheckTV.setText(" ✓");
        collapsedCheckTV.setTextColor(0xFF4CAF50);
        collapsedCheckTV.setTextSize(14f);
        collapsedCheckTV.setTypeface(null, Typeface.BOLD);
        collapsedCheckTV.setVisibility(isInstalled ? View.VISIBLE : View.GONE);
        titleRow.addView(collapsedCheckTV, new LinearLayout.LayoutParams(-2, -2));

        titleRow.addView(new View(this), new LinearLayout.LayoutParams(0, 0, 1f));

        // ── Subtitle (developer · publisher) shown while collapsed ─────────────
        LinearLayout infoCol = new LinearLayout(this);
        infoCol.setOrientation(LinearLayout.VERTICAL);
        infoCol.setGravity(Gravity.CENTER_VERTICAL);
        infoCol.addView(titleRow, new LinearLayout.LayoutParams(-1, -2));
        if (!game.developer.isEmpty() || !game.publisher.isEmpty()) {
            String sub = game.developer.isEmpty() ? game.publisher
                       : game.publisher.isEmpty()  ? game.developer
                       : game.developer + "  ·  " + game.publisher;
            TextView subTV = new TextView(this);
            subTV.setText(sub);
            subTV.setTextColor(0xFF888888);
            subTV.setTextSize(11f);
            subTV.setMaxLines(1);
            subTV.setEllipsize(android.text.TextUtils.TruncateAt.END);
            infoCol.addView(subTV, new LinearLayout.LayoutParams(-1, -2));
        }
        topRow.addView(infoCol, new LinearLayout.LayoutParams(0, -2, 1f));

        TextView arrowTV = new TextView(this);
        arrowTV.setText("▼");
        arrowTV.setTextColor(0xFF888888);
        arrowTV.setTextSize(14f);
        arrowTV.setPadding(dp(8), 0, 0, 0);
        topRow.addView(arrowTV, new LinearLayout.LayoutParams(-2, -2));

        card.addView(topRow, new LinearLayout.LayoutParams(-1, -2));

        // ── Expandable section ─────────────────────────────────────────────────
        LinearLayout expandSection = new LinearLayout(this);
        expandSection.setOrientation(LinearLayout.VERTICAL);
        expandSection.setVisibility(View.GONE);

        if (!game.developer.isEmpty() || !game.publisher.isEmpty()) {
            String meta = game.developer.isEmpty() ? game.publisher
                        : game.publisher.isEmpty() ? game.developer
                        : game.developer + " · " + game.publisher;
            TextView metaTV = new TextView(this);
            metaTV.setText(meta);
            metaTV.setTextColor(0xFF888888);
            metaTV.setTextSize(11f);
            LinearLayout.LayoutParams metaLp = new LinearLayout.LayoutParams(-1, -2);
            metaLp.topMargin = dp(6);
            expandSection.addView(metaTV, metaLp);
        }

        boolean updateAvailable = isInstalled
                && game.versionId != null && game.versionId.endsWith("_UPDATE_AVAILABLE");
        TextView checkmark = new TextView(this);
        checkmark.setText(updateAvailable ? "✓ Installed — Update Available" : "✓ Installed");
        checkmark.setTextColor(updateAvailable ? 0xFFFFAA00 : 0xFF4CAF50);
        checkmark.setTextSize(10f);
        checkmark.setVisibility(isInstalled ? View.VISIBLE : View.GONE);
        LinearLayout.LayoutParams ckLp = new LinearLayout.LayoutParams(-1, -2);
        ckLp.topMargin = dp(4);
        expandSection.addView(checkmark, ckLp);

        ProgressBar progressBar = new ProgressBar(this, null,
                android.R.attr.progressBarStyleHorizontal);
        progressBar.setMax(100);
        progressBar.setProgress(0);
        progressBar.setVisibility(View.GONE);
        progressBar.getProgressDrawable().setColorFilter(COLOR_ACCENT,
                android.graphics.PorterDuff.Mode.SRC_IN);
        LinearLayout.LayoutParams pbLp = new LinearLayout.LayoutParams(-1, dp(6));
        pbLp.topMargin = dp(6);
        expandSection.addView(progressBar, pbLp);

        TextView pctTV = new TextView(this);
        pctTV.setTextColor(COLOR_ACCENT);
        pctTV.setTextSize(12f);
        pctTV.setTypeface(null, Typeface.BOLD);
        pctTV.setVisibility(View.GONE);
        expandSection.addView(pctTV, new LinearLayout.LayoutParams(-2, -2));

        TextView statusTV = new TextView(this);
        statusTV.setTextColor(0xFFAAAAAA);
        statusTV.setTextSize(11f);
        statusTV.setVisibility(View.GONE);
        LinearLayout.LayoutParams stLp = new LinearLayout.LayoutParams(-1, -2);
        stLp.topMargin = dp(2);
        expandSection.addView(statusTV, stLp);

        Button actionBtn = new Button(this);
        actionBtn.setText(isInstalled ? "Add to Launcher" : "Install");
        actionBtn.setTextColor(0xFFFFFFFF);
        actionBtn.setBackgroundColor(isInstalled ? COLOR_ADD : COLOR_ACCENT);
        actionBtn.setTextSize(13f);
        LinearLayout.LayoutParams abLp = new LinearLayout.LayoutParams(-1, dp(40));
        abLp.topMargin = dp(8);
        expandSection.addView(actionBtn, abLp);

        card.addView(expandSection, new LinearLayout.LayoutParams(-1, -2));

        // ── Button click logic ─────────────────────────────────────────────────
        final Runnable[] cancelRef = {null};
        actionBtn.setOnClickListener(v -> {
            String lbl = actionBtn.getText().toString();

            if ("Cancel".equals(lbl)) {
                if (cancelRef[0] != null) cancelRef[0].run();
                return;
            }
            if ("Add to Launcher".equals(lbl) || "Add Game".equals(lbl)) {
                String exe = prefs.getString("amazon_exe_" + game.productId, null);
                if (exe != null) pendingLaunchExe(exe);
                return;
            }

            showInstallConfirm(game, () -> {
                cancelRef[0] = null;
                actionBtn.setEnabled(true);
                actionBtn.setText("Cancel");
                actionBtn.setBackgroundColor(COLOR_CANCEL);
                progressBar.setVisibility(View.VISIBLE);
                statusTV.setVisibility(View.VISIBLE);
                pctTV.setText("0%");
                pctTV.setVisibility(View.VISIBLE);

                cancelRef[0] = startViaServiceAmazon(game, new DownloadCallback() {
                    @Override public void onProgress(String msg, int pct) {
                        uiHandler.post(() -> {
                            statusTV.setText(msg);
                            progressBar.setProgress(pct);
                            pctTV.setText(pct + "%");
                        });
                    }
                    @Override public void onComplete(String exePath) {
                        uiHandler.post(() -> {
                            cancelRef[0] = null;
                            progressBar.setProgress(100);
                            pctTV.setVisibility(View.GONE);
                            checkmark.setVisibility(View.VISIBLE);
                            collapsedCheckTV.setVisibility(View.VISIBLE);
                            statusTV.setText("Installed");
                            actionBtn.setText("Add to Launcher");
                            actionBtn.setBackgroundColor(COLOR_ADD);
                            actionBtn.setEnabled(true);
                        });
                    }
                    @Override public void onError(String msg) {
                        uiHandler.post(() -> {
                            cancelRef[0] = null;
                            pctTV.setVisibility(View.GONE);
                            statusTV.setText("Error: " + msg);
                            actionBtn.setText("Install");
                            actionBtn.setBackgroundColor(COLOR_ACCENT);
                            actionBtn.setEnabled(true);
                            Toast.makeText(AmazonGamesActivity.this, "Error: " + msg,
                                    Toast.LENGTH_LONG).show();
                        });
                    }
                    @Override public void onCancelled() {
                        uiHandler.post(() -> {
                            cancelRef[0] = null;
                            progressBar.setProgress(0);
                            progressBar.setVisibility(View.GONE);
                            pctTV.setVisibility(View.GONE);
                            statusTV.setText("");
                            actionBtn.setText("Install");
                            actionBtn.setBackgroundColor(COLOR_ACCENT);
                            actionBtn.setEnabled(true);
                        });
                    }
                    @Override public void onSelectExe(List<String> candidates,
                                                      java.util.function.Consumer<String> onSelected) {
                        showExePicker(candidates, onSelected);
                    }
                });
            });
        });

        arrowTV.setOnClickListener(v -> {
            if (expandSection.getVisibility() == View.VISIBLE) {
                expandSection.setVisibility(View.GONE);
                arrowTV.setText("▼");
                expandedSection = null;
                expandedArrow   = null;
            }
        });

        card.setOnClickListener(v -> {
            if (expandSection.getVisibility() == View.VISIBLE) {
                openDetailScreen(game);
            } else {
                if (expandedSection != null) {
                    expandedSection.setVisibility(View.GONE);
                    if (expandedArrow != null) expandedArrow.setText("▼");
                }
                expandSection.setVisibility(View.VISIBLE);
                arrowTV.setText("▲");
                expandedSection = expandSection;
                expandedArrow   = arrowTV;
            }
        });

        gameListLayout.addView(card, cardLp);
    }

    // ── GRID / POSTER view ────────────────────────────────────────────────────

    private void addGamesAsGrid(List<AmazonGame> games, int artHeightDp,
                                 int tileHMargin, int rowBottomMargin) {
        int cols = 5;
        int rows = (games.size() + cols - 1) / cols;
        for (int row = 0; row < rows; row++) {
            LinearLayout rowLayout = new LinearLayout(this);
            rowLayout.setOrientation(LinearLayout.HORIZONTAL);
            rowLayout.setWeightSum(cols);
            LinearLayout.LayoutParams rowLp = new LinearLayout.LayoutParams(-1, -2);
            rowLp.bottomMargin = rowBottomMargin;
            for (int col = 0; col < cols; col++) {
                int idx = row * cols + col;
                if (idx < games.size()) {
                    rowLayout.addView(makeGridTile(games.get(idx), artHeightDp),
                            makeGridTileLp(tileHMargin));
                } else {
                    rowLayout.addView(new View(this), makeGridTileLp(tileHMargin));
                }
            }
            gameListLayout.addView(rowLayout, rowLp);
        }
    }

    private View makeGridTile(AmazonGame game, int artHeightDp) {
        boolean isInstalled = prefs.getString("amazon_exe_" + game.productId, null) != null;

        LinearLayout tile = new LinearLayout(this);
        tile.setOrientation(LinearLayout.VERTICAL);
        GradientDrawable tileBg = new GradientDrawable();
        tileBg.setColor(0xFF221A10);
        tileBg.setCornerRadius(dp(5));
        tile.setBackground(tileBg);
        tile.setClipToOutline(true);

        // Wrapper handles focus border via foreground (drawn over tile, not hidden by it)
        FrameLayout focusWrapper = new FrameLayout(this);
        GradientDrawable focusBorder = new GradientDrawable();
        focusBorder.setColor(0x00000000);
        focusBorder.setCornerRadius(dp(5));
        focusWrapper.setForeground(focusBorder);
        focusWrapper.setFocusable(true);
        focusWrapper.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);
        focusWrapper.setOnFocusChangeListener((v, hasFocus) -> {
            tileBg.setColor(hasFocus ? 0xFF321F10 : 0xFF221A10);
            focusBorder.setStroke(hasFocus ? dp(3) : 0, hasFocus ? 0xFFFFD700 : 0x00000000);
        });
        focusWrapper.setOnClickListener(v -> tile.performClick());
        focusWrapper.setOnLongClickListener(v -> tile.performLongClick());

        FrameLayout artFrame = new FrameLayout(this);

        ImageView coverIV = new ImageView(this);
        coverIV.setScaleType(ImageView.ScaleType.CENTER_CROP);
        coverIV.setBackgroundColor(0xFF1A1208);
        artFrame.addView(coverIV, new FrameLayout.LayoutParams(-1, dp(artHeightDp)));
        loadImage(game, coverIV);

        // Title + ✓ bar pinned to bottom of art
        LinearLayout titleBar = new LinearLayout(this);
        titleBar.setOrientation(LinearLayout.HORIZONTAL);
        titleBar.setGravity(Gravity.CENTER_VERTICAL);
        titleBar.setPadding(dp(4), dp(3), dp(4), dp(3));
        GradientDrawable titleBarBg = new GradientDrawable(
                GradientDrawable.Orientation.BOTTOM_TOP,
                new int[]{0xEE000000, 0x44000000});
        titleBar.setBackground(titleBarBg);

        TextView titleTV = new TextView(this);
        titleTV.setText(game.title);
        titleTV.setTextColor(0xFFFFFFFF);
        titleTV.setTextSize(9f);
        titleTV.setTypeface(null, Typeface.BOLD);
        titleTV.setMaxLines(1);
        titleTV.setEllipsize(android.text.TextUtils.TruncateAt.END);
        titleBar.addView(titleTV, new LinearLayout.LayoutParams(0, -2, 1f));

        TextView checkTV = new TextView(this);
        checkTV.setText(" ✓");
        checkTV.setTextColor(0xFF66BB6A);
        checkTV.setTextSize(10f);
        checkTV.setTypeface(null, Typeface.BOLD);
        checkTV.setVisibility(isInstalled ? View.VISIBLE : View.GONE);
        titleBar.addView(checkTV, new LinearLayout.LayoutParams(-2, -2));

        FrameLayout.LayoutParams titleBarLp = new FrameLayout.LayoutParams(-1, -2);
        titleBarLp.gravity = Gravity.BOTTOM;
        artFrame.addView(titleBar, titleBarLp);

        tile.addView(artFrame, new LinearLayout.LayoutParams(-1, -2));

        // Action row (hidden until tapped)
        LinearLayout actionRow = new LinearLayout(this);
        actionRow.setOrientation(LinearLayout.VERTICAL);
        actionRow.setVisibility(View.GONE);
        actionRow.setBackgroundColor(0xFF1A1208);
        actionRow.setPadding(dp(4), dp(3), dp(4), dp(4));

        ProgressBar progressBar = new ProgressBar(this, null,
                android.R.attr.progressBarStyleHorizontal);
        progressBar.setMax(100);
        progressBar.setProgress(0);
        progressBar.setVisibility(View.GONE);
        actionRow.addView(progressBar, new LinearLayout.LayoutParams(-1, dp(3)));

        Button actionBtn = new Button(this);
        actionBtn.setText(isInstalled ? "Add to Launcher" : "Install");
        actionBtn.setTextColor(0xFFFFFFFF);
        actionBtn.setBackgroundColor(isInstalled ? COLOR_ADD : COLOR_ACCENT);
        actionBtn.setTextSize(10f);
        actionBtn.setPadding(0, 0, 0, 0);
        LinearLayout.LayoutParams abLp = new LinearLayout.LayoutParams(-1, dp(30));
        abLp.topMargin = dp(2);
        actionRow.addView(actionBtn, abLp);

        tile.addView(actionRow, new LinearLayout.LayoutParams(-1, -2));

        final Runnable[] cancelRef = {null};
        actionBtn.setOnClickListener(v -> {
            String lbl = actionBtn.getText().toString();
            if ("Cancel".equals(lbl)) {
                if (cancelRef[0] != null) cancelRef[0].run();
                return;
            }
            if ("Add to Launcher".equals(lbl) || "Add Game".equals(lbl)) {
                String exe = prefs.getString("amazon_exe_" + game.productId, null);
                if (exe != null) pendingLaunchExe(exe);
                return;
            }
            showInstallConfirm(game, () -> {
                cancelRef[0] = null;
                actionBtn.setEnabled(true);
                actionBtn.setText("Cancel");
                actionBtn.setBackgroundColor(COLOR_CANCEL);
                progressBar.setVisibility(View.VISIBLE);

                cancelRef[0] = startViaServiceAmazon(game, new DownloadCallback() {
                    @Override public void onProgress(String msg, int pct) {
                        uiHandler.post(() -> progressBar.setProgress(pct));
                    }
                    @Override public void onComplete(String exePath) {
                        uiHandler.post(() -> {
                            cancelRef[0] = null;
                            progressBar.setProgress(100);
                            progressBar.setVisibility(View.GONE);
                            checkTV.setVisibility(View.VISIBLE);
                            actionBtn.setText("Add to Launcher");
                            actionBtn.setBackgroundColor(COLOR_ADD);
                            actionBtn.setEnabled(true);
                        });
                    }
                    @Override public void onError(String msg) {
                        uiHandler.post(() -> {
                            cancelRef[0] = null;
                            progressBar.setVisibility(View.GONE);
                            actionBtn.setText("Install");
                            actionBtn.setBackgroundColor(COLOR_ACCENT);
                            actionBtn.setEnabled(true);
                            Toast.makeText(AmazonGamesActivity.this, "Error: " + msg,
                                    Toast.LENGTH_LONG).show();
                        });
                    }
                    @Override public void onCancelled() {
                        uiHandler.post(() -> {
                            cancelRef[0] = null;
                            progressBar.setProgress(0);
                            progressBar.setVisibility(View.GONE);
                            actionBtn.setText("Install");
                            actionBtn.setBackgroundColor(COLOR_ACCENT);
                            actionBtn.setEnabled(true);
                        });
                    }
                    @Override public void onSelectExe(List<String> candidates,
                                                      java.util.function.Consumer<String> onSelected) {
                        showExePicker(candidates, onSelected);
                    }
                });
            });
        });

        tile.setOnClickListener(v -> {
            if (actionRow.getVisibility() == View.VISIBLE) {
                actionRow.setVisibility(View.GONE);
                expandedSection = null;
            } else {
                if (expandedSection != null) expandedSection.setVisibility(View.GONE);
                actionRow.setVisibility(View.VISIBLE);
                expandedSection = actionRow;
                expandedArrow   = null;
            }
        });

        tile.setOnLongClickListener(v -> {
            openDetailScreen(game);
            return true;
        });

        focusWrapper.addView(tile, new FrameLayout.LayoutParams(-1, -1));
        return focusWrapper;
    }

    private LinearLayout.LayoutParams makeGridTileLp(int hMargin) {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, -2, 1f);
        lp.leftMargin  = hMargin;
        lp.rightMargin = hMargin;
        return lp;
    }

    // ── Service-backed download (routes through BhDownloadService) ───────────

    private Runnable startViaServiceAmazon(AmazonGame game, DownloadCallback cb) {
        String dlKey = "amazon_" + game.productId;
        if (android.os.Build.VERSION.SDK_INT >= 33 &&
                checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.POST_NOTIFICATIONS}, 0);
        }
        Intent svc = new Intent(this, BhDownloadService.class);
        svc.setAction(BhDownloadService.ACTION_START);
        svc.putExtra(BhDownloadService.EXTRA_STORE, "AMAZON");
        svc.putExtra(BhDownloadService.EXTRA_GAME_ID, dlKey);
        svc.putExtra(BhDownloadService.EXTRA_GAME_NAME, game.title);
        svc.putExtra(BhDownloadService.EXTRA_AMAZON_PRODUCT_ID, game.productId);
        svc.putExtra(BhDownloadService.EXTRA_AMAZON_ENT_ID, game.entitlementId);
        svc.putExtra(BhDownloadService.EXTRA_AMAZON_SKU, game.productSku);
        svc.putExtra(BhDownloadService.EXTRA_AMAZON_TITLE, game.title);
        startForegroundService(svc);
        BhDownloadService.addListener(dlKey, new BhDownloadService.DownloadListener() {
            @Override public void onProgress(String msg, int pct) { cb.onProgress(msg, pct); }
            @Override public void onComplete(String installDir)   { cb.onComplete(installDir); }
            @Override public void onError(String msg)             { cb.onError(msg); }
            @Override public void onCancelled()                   { cb.onCancelled(); }
        });
        return () -> BhDownloadService.cancel(AmazonGamesActivity.this, dlKey);
    }

    // ── Download wrapper ──────────────────────────────────────────────────────

    private interface DownloadCallback {
        void onProgress(String msg, int pct);
        void onComplete(String exePath);
        void onError(String msg);
        void onCancelled();
        void onSelectExe(List<String> candidates,
                         java.util.function.Consumer<String> onSelected);
    }

    /**
     * Starts an Amazon game download on a background thread.
     * Returns a Runnable cancel token (same pattern as GogDownloadManager.startDownload).
     */
    private Runnable startAmazonDownload(AmazonGame game, DownloadCallback cb) {
        AtomicBoolean cancelled = new AtomicBoolean(false);

        new Thread(() -> {
            String token = AmazonCredentialStore.getValidAccessToken(this);
            if (token == null) { cb.onError("Login required"); return; }

            String sanitized = game.title.replaceAll("[^a-zA-Z0-9 \\-_]", "").trim();
            if (sanitized.isEmpty()) sanitized = "game_" + game.productId.hashCode();
            File installDir = new File(new File(getFilesDir(), "Amazon"), sanitized);

            // Store install dir in prefs for uninstall
            prefs.edit().putString("amazon_dir_" + game.productId,
                    installDir.getAbsolutePath()).apply();

            boolean ok = AmazonDownloadManager.install(this, game, token, installDir,
                (dl, total, file) -> {
                    if (cancelled.get()) return;
                    int pct = (total > 0) ? (int) (dl * 100L / total) : 0;
                    String name = (file != null && !file.isEmpty()) ? file : "Downloading…";
                    cb.onProgress(name, pct);
                },
                cancelled::get
            );

            if (cancelled.get()) { cb.onCancelled(); return; }
            if (!ok) { cb.onError("Download failed"); return; }

            // Scan for executables
            List<File> exeFiles = new ArrayList<>();
            AmazonLaunchHelper.collectExe(installDir, exeFiles);

            if (exeFiles.isEmpty()) {
                cb.onError("No executable found after install");
                return;
            }

            // Sort: best scored first
            String lowerTitle = game.title.toLowerCase();
            Collections.sort(exeFiles, (a, b) ->
                    AmazonLaunchHelper.scoreExe(b, lowerTitle)
                    - AmazonLaunchHelper.scoreExe(a, lowerTitle));

            if (exeFiles.size() == 1) {
                String path = exeFiles.get(0).getAbsolutePath();
                prefs.edit().putString("amazon_exe_" + game.productId, path).apply();
                cb.onComplete(path);
                return;
            }

            // Multiple exes → ask user
            List<String> candidates = new ArrayList<>();
            for (File f : exeFiles) candidates.add(f.getAbsolutePath());

            cb.onSelectExe(candidates, selected -> {
                String chosen = (selected != null && !selected.isEmpty())
                        ? selected
                        : exeFiles.get(0).getAbsolutePath(); // default: best scored
                prefs.edit().putString("amazon_exe_" + game.productId, chosen).apply();
                cb.onComplete(chosen);
            });

        }, "amazon-dl-" + game.productId).start();

        return () -> cancelled.set(true);
    }

    // ── Dialogs ───────────────────────────────────────────────────────────────

    private void showInstallConfirm(AmazonGame game, Runnable onConfirm) {
        long freeBytes = -1;
        try {
            File base = new File(new File(getFilesDir(), "Amazon"), "_check");
            File parent = base.getParentFile();
            if (parent != null) parent.mkdirs();
            android.os.StatFs sf = new android.os.StatFs(
                    parent != null ? parent.getAbsolutePath()
                            : getCacheDir().getAbsolutePath());
            freeBytes = sf.getAvailableBlocksLong() * sf.getBlockSizeLong();
        } catch (Exception ignored) {}

        final long freeBytesF = freeBytes;

        LinearLayout content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(dp(20), dp(8), dp(20), dp(8));

        TextView sizeTV = new TextView(this);
        sizeTV.setText("Game size:  Fetching…");
        sizeTV.setTextColor(0xFFCCCCCC);
        sizeTV.setTextSize(14f);
        content.addView(sizeTV);

        TextView freeTV = new TextView(this);
        freeTV.setText("Available storage:  " + formatBytes(freeBytesF));
        freeTV.setTextColor(0xFF88CC88);
        freeTV.setTextSize(14f);
        content.addView(freeTV);

        AlertDialog dialog = new AlertDialog.Builder(this)
                .setTitle("Install " + game.title + "?")
                .setView(content)
                .setPositiveButton("Install", null)
                .setNegativeButton("Cancel", null)
                .create();
        dialog.show();

        dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener(v -> {
            dialog.dismiss();
            onConfirm.run();
        });

        // Fetch game size in background and update label
        if (game.installSize > 0) {
            sizeTV.setText("Game size:  " + formatBytes(game.installSize));
        } else {
            new Thread(() -> {
                long size = 0;
                try {
                    String token = AmazonCredentialStore.getValidAccessToken(this);
                    if (token != null) {
                        AmazonApiClient.GameDownloadSpec spec =
                                AmazonApiClient.getGameDownload(token, game.entitlementId);
                        if (spec != null && !spec.downloadUrl.isEmpty()) {
                            String manifestUrl = AmazonApiClient.appendPath(
                                    spec.downloadUrl, "manifest.proto");
                            byte[] manifestBytes = AmazonApiClient.getBytes(
                                    manifestUrl, token);
                            if (manifestBytes != null) {
                                AmazonManifest.ParsedManifest manifest =
                                        AmazonManifest.parse(manifestBytes);
                                size = manifest.totalInstallSize;
                                game.installSize = size;
                            }
                        }
                    }
                } catch (Exception ignored) {}
                final long finalSize = size;
                uiHandler.post(() -> {
                    if (dialog.isShowing()) {
                        sizeTV.setText("Game size:  "
                                + (finalSize > 0 ? formatBytes(finalSize) : "Unknown"));
                    }
                });
            }, "amazon-size-" + game.productId).start();
        }
    }

    // ── Full-screen detail ────────────────────────────────────────────────────

    private void openDetailScreen(AmazonGame game) {
        Intent intent = new Intent(this, AmazonGameDetailActivity.class);
        intent.putExtra("product_id",    game.productId);
        intent.putExtra("entitlement_id", game.entitlementId);
        intent.putExtra("title",         game.title);
        intent.putExtra("developer",     game.developer);
        intent.putExtra("publisher",     game.publisher);
        intent.putExtra("art_url",       game.artUrl);
        intent.putExtra("product_sku",   game.productSku);
        startActivityForResult(intent, REQ_GAME_DETAIL);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQ_GAME_DETAIL && resultCode == AmazonGameDetailActivity.RESULT_REFRESH) {
            applyFilter(searchBar != null ? searchBar.getText().toString() : "");
        } else if (requestCode == REQ_DOWNLOADS) {
            applyFilter(searchBar != null ? searchBar.getText().toString() : "");
        }
    }

    private void showDetailDialog(AmazonGame game, View checkmark, Button actionBtn, Runnable onUninstalled) {
        LinearLayout container = new LinearLayout(this);
        container.setOrientation(LinearLayout.VERTICAL);
        container.setPadding(dp(20), dp(8), dp(20), dp(4));

        StringBuilder msg = new StringBuilder();
        if (!game.developer.isEmpty()) msg.append("Developer: ").append(game.developer).append("\n");
        if (!game.publisher.isEmpty()) msg.append("Publisher: ").append(game.publisher).append("\n");
        msg.append("ID: ").append(game.shortId());

        TextView msgView = new TextView(this);
        msgView.setText(msg.toString().trim());
        msgView.setTextColor(0xFFCCCCCC);
        container.addView(msgView);

        String installedExe = prefs.getString("amazon_exe_" + game.productId, null);
        String installedDir = prefs.getString("amazon_dir_" + game.productId, null);

        if (installedExe != null) {
            TextView exeView = new TextView(this);
            exeView.setText("\n.exe: " + new File(installedExe).getName());
            exeView.setTextColor(0xFF888888);
            exeView.setTextSize(12f);
            container.addView(exeView);

            // Set .exe button
            Button setExeBtn = new Button(this);
            setExeBtn.setText("Set .exe…");
            setExeBtn.setTextColor(0xFFFFFFFF);
            setExeBtn.setBackgroundColor(0xFF444444);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, -2);
            lp.topMargin = dp(10);
            setExeBtn.setOnClickListener(v -> {
                File dir = installedDir != null ? new File(installedDir) : null;
                if (dir == null || !dir.isDirectory()) {
                    Toast.makeText(this, "Install directory not found", Toast.LENGTH_SHORT).show();
                    return;
                }
                new Thread(() -> {
                    List<File> exeFiles = new ArrayList<>();
                    AmazonLaunchHelper.collectExe(dir, exeFiles);
                    if (exeFiles.isEmpty()) {
                        uiHandler.post(() -> Toast.makeText(this,
                                "No .exe files found", Toast.LENGTH_SHORT).show());
                        return;
                    }
                    List<String> candidates = new ArrayList<>();
                    for (File f : exeFiles) candidates.add(f.getAbsolutePath());
                    showExePicker(candidates, selected -> {
                        if (selected != null && !selected.isEmpty()) {
                            prefs.edit().putString("amazon_exe_" + game.productId, selected).apply();
                            uiHandler.post(() -> {
                                exeView.setText("\n.exe: " + new File(selected).getName());
                                Toast.makeText(this,
                                        "Exe set: " + new File(selected).getName(),
                                        Toast.LENGTH_SHORT).show();
                            });
                        }
                    });
                }).start();
            });
            container.addView(setExeBtn, lp);
        }

        AlertDialog.Builder b = new AlertDialog.Builder(this)
                .setTitle(game.title)
                .setView(container)
                .setPositiveButton("Close", null);

        if (installedDir != null) {
            b.setNegativeButton("Uninstall", (d, w) -> {
                new Thread(() -> {
                    deleteDir(new File(installedDir));
                    prefs.edit()
                            .remove("amazon_exe_" + game.productId)
                            .remove("amazon_dir_" + game.productId)
                            .apply();
                    uiHandler.post(() -> {
                        onUninstalled.run();
                        actionBtn.setEnabled(true);
                        Toast.makeText(this, game.title + " uninstalled",
                                Toast.LENGTH_SHORT).show();
                    });
                }).start();
            });
        }

        b.show();
    }

    private void showExePicker(List<String> candidates,
                                java.util.function.Consumer<String> onSelected) {
        String[] labels = new String[candidates.size()];
        for (int i = 0; i < candidates.size(); i++) {
            File f      = new File(candidates.get(i));
            File parent = f.getParentFile();
            labels[i] = (parent != null)
                    ? parent.getName() + "/" + f.getName()
                    : f.getName();
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

    // ── Launch ────────────────────────────────────────────────────────────────

    private void pendingLaunchExe(String absPath) {
        prefs.edit().putString("pending_amazon_exe", absPath).apply();
        android.content.Intent intent = new android.content.Intent();
        intent.setClassName(getPackageName(),
                "com.xj.landscape.launcher.ui.main.LandscapeLauncherMainActivity");
        intent.addFlags(android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP
                | android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intent);
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
            prefs.edit().putString(CACHE_KEY, arr.toString()).apply();
        } catch (Exception e) { Log.e(TAG, "saveCachedGames failed", e); }
    }

    private List<AmazonGame> loadCachedGames() {
        try {
            String json = prefs.getString(CACHE_KEY, null);
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
        } catch (Exception e) { Log.e(TAG, "loadCachedGames failed", e); return null; }
    }

    // ── Image loading ─────────────────────────────────────────────────────────

    private void loadImage(AmazonGame game, ImageView iv) {
        String url = game.artUrl;
        if (url == null || url.isEmpty()) url = game.heroUrl;
        if (url == null || url.isEmpty()) return;
        final String finalUrl = url;
        new Thread(() -> {
            try {
                java.net.HttpURLConnection conn =
                        (java.net.HttpURLConnection) new java.net.URL(finalUrl).openConnection();
                conn.setConnectTimeout(10000);
                conn.setReadTimeout(10000);
                if (conn.getResponseCode() == 200) {
                    Bitmap bmp = BitmapFactory.decodeStream(conn.getInputStream());
                    if (bmp != null) uiHandler.post(() -> iv.setImageBitmap(bmp));
                }
                conn.disconnect();
            } catch (Exception ignored) {}
        }, "amazon-cover-" + game.productId).start();
    }

    // ── Utilities ─────────────────────────────────────────────────────────────

    private void setSync(String msg) {
        uiHandler.post(() -> {
            if (syncText == null) return;
            syncText.setText(msg);
            if (msg.startsWith("Error") || msg.startsWith("Not logged in")
                    || msg.startsWith("Token refresh") || msg.startsWith("No games")) {
                syncText.setTextColor(0xFFFF6B6B);
            } else if (msg.contains("game") && (msg.contains("tap") || msg.contains("cached"))) {
                syncText.setTextColor(0xFF81C784);
            } else {
                syncText.setTextColor(0xFFCCCCCC);
            }
        });
    }

    private static String viewModeIcon(String mode) {
        if ("grid".equals(mode))   return "▦";
        if ("poster".equals(mode)) return "☰";
        return "⊞";
    }

    private static String formatBytes(long bytes) {
        if (bytes < 0) return "Unknown";
        if (bytes < 1024L)            return bytes + " B";
        if (bytes < 1024L * 1024L)    return (bytes / 1024L) + " KB";
        if (bytes < 1024L * 1024L * 1024L)
            return String.format("%.1f MB", bytes / (1024.0 * 1024.0));
        return String.format("%.2f GB", bytes / (1024.0 * 1024.0 * 1024.0));
    }

    private static void deleteDir(File dir) {
        if (dir == null || !dir.exists()) return;
        File[] children = dir.listFiles();
        if (children != null) for (File c : children) deleteDir(c);
        dir.delete();
    }

    private int dp(int v) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v,
                getResources().getDisplayMetrics());
    }
}
