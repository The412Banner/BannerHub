/*
 * Epic Games integration for BannerHub
 *
 * Credits: The Epic Games Store API pipeline, OAuth flow, manifest download
 * architecture, CDN selection logic, chunk decompression, and launch arguments
 * are based on the research and implementation of The GameNative Team.
 * https://github.com/utkarshdalal/GameNative
 */
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
import java.util.HashMap;
import java.util.Map;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Epic Games library screen — mirrors AmazonGamesActivity structure.
 *
 * View modes: LIST (collapsible cards) · GRID · POSTER
 * Install: manifest fetch → chunk download → file assembly → exe scan
 * Launch:  store pending_epic_exe → start LandscapeLauncherMainActivity
 *
 * Storage in bh_epic_prefs:
 *   epic_exe_{appName}  — abs path to selected .exe
 *   epic_dir_{appName}  — abs path to install directory
 *   epic_cache          — JSON array of library cache
 *   epic_view_mode      — "list" / "grid" / "poster"
 */
public class EpicGamesActivity extends Activity {

    private static final String TAG           = "BH_EPIC";
    private static final String PREFS_NAME    = "bh_epic_prefs";
    private static final String CACHE_KEY     = "epic_cache";
    private static final String VIEW_MODE_KEY = "epic_view_mode";
    private static final int REQ_GAME_DETAIL  = 1001;
    private static final int REQ_DOWNLOADS    = 1002;

    // Epic brand colours
    private static final int COLOR_ACCENT  = 0xFF0078F0;  // Epic blue — install btn / title
    private static final int COLOR_ADD     = 0xFF2E7D32;  // green  — Add to Launcher btn
    private static final int COLOR_CANCEL  = 0xFFCC3333;  // red    — cancel btn
    private static final int COLOR_CARD_BG = 0xFF0F1117;  // dark card background
    private static final int COLOR_HDR_BG  = 0xFF0F1117;
    private static final int COLOR_ROOT_BG = 0xFF0D0D0D;

    private final Handler uiHandler = new Handler(Looper.getMainLooper());

    private SharedPreferences prefs;
    private TextView     syncText;
    private LinearLayout gameListLayout;
    private ScrollView   scrollView;
    private Button       refreshBtn;
    private Button       viewToggleBtn;
    private EditText     searchBar;
    private List<EpicGame> allGames    = new ArrayList<>();
    private View         expandedSection = null;
    private TextView     expandedArrow   = null;
    private String       viewMode;

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs    = getSharedPreferences(PREFS_NAME, 0);
        viewMode = prefs.getString(VIEW_MODE_KEY, "list");
        buildUi();
        List<EpicGame> cached = loadCachedGames();
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
        titleTV.setText("Epic Games");
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
            if ("list".equals(viewMode))       viewMode = "grid";
            else if ("grid".equals(viewMode))  viewMode = "poster";
            else                               viewMode = "list";
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

        Button freeBtn = new Button(this);
        freeBtn.setText("FREE");
        freeBtn.setTextColor(0xFF00C853);
        GradientDrawable freeBtnBg = new GradientDrawable();
        freeBtnBg.setColor(0xFF00330F);
        freeBtnBg.setCornerRadius(dp(4));
        freeBtnBg.setStroke(dp(1), 0xFF00C853);
        freeBtn.setBackground(freeBtnBg);
        freeBtn.setTextSize(11f);
        freeBtn.setTypeface(null, android.graphics.Typeface.BOLD);
        freeBtn.setPadding(dp(10), 0, dp(10), 0);
        LinearLayout.LayoutParams freeBtnLp = new LinearLayout.LayoutParams(-2, dp(40));
        freeBtnLp.leftMargin = dp(4);
        freeBtn.setOnFocusChangeListener((v, hasFocus) -> {
            freeBtnBg.setColor(hasFocus ? 0xFF005518 : 0xFF00330F);
            freeBtnBg.setStroke(hasFocus ? dp(2) : dp(1), hasFocus ? 0xFFFFD700 : 0xFF00C853);
        });
        freeBtn.setOnClickListener(v -> startActivity(new Intent(this, EpicFreeGamesActivity.class)));
        header.addView(freeBtn, freeBtnLp);

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
        dlBtn.setOnClickListener(v -> startActivityForResult(new Intent(this, BhDownloadsActivity.class), REQ_DOWNLOADS));
        LinearLayout.LayoutParams dlLp = new LinearLayout.LayoutParams(-2, dp(40));
        dlLp.leftMargin = dp(4);
        header.addView(dlBtn, dlLp);

        root.addView(header, new LinearLayout.LayoutParams(-1, -2));

        // Search bar
        searchBar = new EditText(this);
        searchBar.setHint("Search games…");
        searchBar.setHintTextColor(0xFF666666);
        searchBar.setTextColor(0xFFFFFFFF);
        searchBar.setTextSize(14f);
        searchBar.setBackgroundColor(0xFF141820);
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
        syncText.setText("Loading Epic library…");
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
            if (showProgress) setSync("Loading Epic library…");
        });
        new Thread(() -> syncLibrary(showProgress), "epic-sync").start();
    }

    private void syncLibrary(boolean showProgress) {
        try {
            if (showProgress) setSync("Checking credentials…");
            String token = EpicCredentialStore.getValidAccessToken(this);
            if (token == null) {
                setSync("Not logged in");
                enableRefresh();
                uiHandler.post(() -> {
                    Toast.makeText(this, "Please log in to Epic Games first",
                            Toast.LENGTH_SHORT).show();
                    finish();
                });
                return;
            }

            if (showProgress) setSync("Fetching game list…");
            List<EpicGame> games = EpicApiClient.getLibraryItems(token);

            if (games == null || games.isEmpty()) {
                setSync("No games found in Epic library");
                enableRefresh();
                return;
            }

            // Enrich each game with catalog details (title, art, developer)
            if (showProgress) setSync("Loading game details…");
            int total = games.size();
            int done  = 0;
            for (EpicGame game : games) {
                EpicApiClient.enrichFromCatalog(token, game);
                // Cache release date
                if (!game.releaseDate.isEmpty()) {
                    prefs.edit().putString("epic_release_" + game.appName, game.releaseDate).apply();
                }
                done++;
                if (done % 5 == 0) {
                    final int d = done;
                    setSync("Loading game details… (" + d + "/" + total + ")");
                }
            }

            // Filter: skip DLC from top-level display; store DLC→base associations in prefs
            List<EpicGame> mainGames = new ArrayList<>();
            Map<String, JSONArray> epicDlcMap = new HashMap<>();
            for (EpicGame g : games) {
                if (!g.isDLC) {
                    mainGames.add(g);
                } else if (!g.baseGameCatalogItemId.isEmpty()) {
                    JSONArray arr = epicDlcMap.get(g.baseGameCatalogItemId);
                    if (arr == null) { arr = new JSONArray(); epicDlcMap.put(g.baseGameCatalogItemId, arr); }
                    try {
                        JSONObject dlcObj = new JSONObject();
                        dlcObj.put("app",   g.appName);
                        dlcObj.put("ns",    g.namespace);
                        dlcObj.put("cat",   g.catalogItemId);
                        dlcObj.put("title", g.title);
                        arr.put(dlcObj);
                    } catch (Exception ignored) {}
                }
            }
            // Write DLC lists to prefs (overwrite each time so lists stay fresh)
            SharedPreferences.Editor dlcEd = prefs.edit();
            for (Map.Entry<String, JSONArray> e : epicDlcMap.entrySet()) {
                dlcEd.putString("epic_dlcs_" + e.getKey(), e.getValue().toString());
            }
            dlcEd.apply();
            if (mainGames.isEmpty()) mainGames = games;

            Collections.sort(mainGames, (a, b) -> a.title.compareToIgnoreCase(b.title));

            // Restore install state from cache
            List<EpicGame> cached = loadCachedGames();
            if (cached != null) {
                for (EpicGame fresh : mainGames) {
                    for (EpicGame old : cached) {
                        if (old.appName.equals(fresh.appName)) {
                            fresh.isInstalled = old.isInstalled;
                            fresh.installPath = old.installPath;
                            fresh.version     = old.version;
                            fresh.installSize = old.installSize;
                            break;
                        }
                    }
                }
            }

            saveCachedGames(mainGames);

            final List<EpicGame> finalGames = mainGames;
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

    private void showGames(List<EpicGame> games) {
        allGames = games;
        applyFilter(searchBar != null ? searchBar.getText().toString() : "");
        scrollView.setVisibility(View.VISIBLE);
    }

    private void applyFilter(String query) {
        List<EpicGame> filtered;
        if (query == null || query.trim().isEmpty()) {
            filtered = allGames;
        } else {
            String q = query.trim().toLowerCase();
            filtered = new ArrayList<>();
            for (EpicGame g : allGames)
                if (g.title.toLowerCase().contains(q)) filtered.add(g);
        }
        final List<EpicGame> result = filtered;
        uiHandler.post(() -> {
            gameListLayout.removeAllViews();
            if (result.isEmpty()) {
                gameListLayout.setPadding(dp(8), dp(8), dp(8), dp(8));
                TextView emptyTV = new TextView(EpicGamesActivity.this);
                String q2 = query == null ? "" : query.trim();
                emptyTV.setText(q2.isEmpty() ? "Your Epic library is empty"
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
                for (EpicGame g : result) addGameCard(g);
            }
            scrollView.setVisibility(View.VISIBLE);
        });
    }

    private void enableRefresh() {
        uiHandler.post(() -> { if (refreshBtn != null) refreshBtn.setEnabled(true); });
    }

    // ── LIST view: collapsible game cards ─────────────────────────────────────

    private void addGameCard(EpicGame game) {
        boolean isInstalled = prefs.getString("epic_exe_" + game.appName, null) != null;

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
            cardBg.setColor(hasFocus ? 0xFF1B1F2A : COLOR_CARD_BG);
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
        coverBg.setColor(0xFF141820);
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

        // ── Subtitle (developer) shown while collapsed ─────────────────────────
        LinearLayout infoCol = new LinearLayout(this);
        infoCol.setOrientation(LinearLayout.VERTICAL);
        infoCol.setGravity(Gravity.CENTER_VERTICAL);
        infoCol.addView(titleRow, new LinearLayout.LayoutParams(-1, -2));
        if (!game.developer.isEmpty()) {
            TextView subTV = new TextView(this);
            subTV.setText(game.developer);
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

        if (!game.developer.isEmpty()) {
            TextView metaTV = new TextView(this);
            metaTV.setText(game.developer);
            metaTV.setTextColor(0xFF888888);
            metaTV.setTextSize(11f);
            LinearLayout.LayoutParams metaLp = new LinearLayout.LayoutParams(-1, -2);
            metaLp.topMargin = dp(6);
            expandSection.addView(metaTV, metaLp);
        }

        TextView checkmark = new TextView(this);
        checkmark.setText("✓ Installed");
        checkmark.setTextColor(0xFF4CAF50);
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
                String exe = prefs.getString("epic_exe_" + game.appName, null);
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

                cancelRef[0] = startViaServiceEpic(game, new DownloadCallback() {
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
                            Toast.makeText(EpicGamesActivity.this,
                                    "Error: " + msg, Toast.LENGTH_LONG).show();
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

    private void addGamesAsGrid(List<EpicGame> games, int artHeightDp,
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

    private View makeGridTile(EpicGame game, int artHeightDp) {
        boolean isInstalled = prefs.getString("epic_exe_" + game.appName, null) != null;

        LinearLayout tile = new LinearLayout(this);
        tile.setOrientation(LinearLayout.VERTICAL);
        GradientDrawable tileBg = new GradientDrawable();
        tileBg.setColor(0xFF141820);
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
            tileBg.setColor(hasFocus ? 0xFF1E2330 : 0xFF141820);
            focusBorder.setStroke(hasFocus ? dp(3) : 0, hasFocus ? 0xFFFFD700 : 0x00000000);
        });
        focusWrapper.setOnClickListener(v -> tile.performClick());
        focusWrapper.setOnLongClickListener(v -> tile.performLongClick());

        FrameLayout artFrame = new FrameLayout(this);

        ImageView coverIV = new ImageView(this);
        coverIV.setScaleType(ImageView.ScaleType.CENTER_CROP);
        coverIV.setBackgroundColor(0xFF0F1117);
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

        // Action row (shown on tap)
        LinearLayout actionRow = new LinearLayout(this);
        actionRow.setOrientation(LinearLayout.VERTICAL);
        actionRow.setVisibility(View.GONE);
        actionRow.setBackgroundColor(0xFF0F1117);
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
                String exe = prefs.getString("epic_exe_" + game.appName, null);
                if (exe != null) pendingLaunchExe(exe);
                return;
            }
            showInstallConfirm(game, () -> {
                cancelRef[0] = null;
                actionBtn.setEnabled(true);
                actionBtn.setText("Cancel");
                actionBtn.setBackgroundColor(COLOR_CANCEL);
                progressBar.setVisibility(View.VISIBLE);

                cancelRef[0] = startViaServiceEpic(game, new DownloadCallback() {
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
                            Toast.makeText(EpicGamesActivity.this,
                                    "Error: " + msg, Toast.LENGTH_LONG).show();
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

    private Runnable startViaServiceEpic(EpicGame game, DownloadCallback cb) {
        String dlKey = "epic_" + game.appName;
        if (android.os.Build.VERSION.SDK_INT >= 33 &&
                checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.POST_NOTIFICATIONS}, 0);
        }
        Intent svc = new Intent(this, BhDownloadService.class);
        svc.setAction(BhDownloadService.ACTION_START);
        svc.putExtra(BhDownloadService.EXTRA_STORE, "EPIC");
        svc.putExtra(BhDownloadService.EXTRA_GAME_ID, dlKey);
        svc.putExtra(BhDownloadService.EXTRA_GAME_NAME, game.title);
        svc.putExtra(BhDownloadService.EXTRA_EPIC_NAMESPACE, game.namespace);
        svc.putExtra(BhDownloadService.EXTRA_EPIC_CATALOG_ID, game.catalogItemId);
        svc.putExtra(BhDownloadService.EXTRA_EPIC_APP_NAME, game.appName);
        startForegroundService(svc);
        BhDownloadService.addListener(dlKey, new BhDownloadService.DownloadListener() {
            @Override public void onProgress(String msg, int pct) { cb.onProgress(msg, pct); }
            @Override public void onComplete(String installDir)   { cb.onComplete(installDir); }
            @Override public void onError(String msg)             { cb.onError(msg); }
            @Override public void onCancelled()                   { cb.onCancelled(); }
        });
        return () -> BhDownloadService.cancel(EpicGamesActivity.this, dlKey);
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

    private Runnable startEpicDownload(EpicGame game, DownloadCallback cb) {
        AtomicBoolean cancelled = new AtomicBoolean(false);

        new Thread(() -> {
            try {
                String token = EpicCredentialStore.getValidAccessToken(this);
                if (token == null) { cb.onError("Login required"); return; }

                // Fetch manifest API JSON
                cb.onProgress("Fetching manifest…", 0);
                String manifestJson = EpicApiClient.getManifestApiJson(
                        token, game.namespace, game.catalogItemId, game.appName);
                if (manifestJson == null) {
                    cb.onError("Failed to fetch manifest. If this is Fortnite, it is not supported.");
                    return;
                }

                // Install directory: getFilesDir()/epic_games/{sanitized title}
                String sanitized = game.title.replaceAll("[^a-zA-Z0-9 \\-_]", "").trim();
                if (sanitized.isEmpty()) sanitized = "epic_" + game.appName.hashCode();
                File installDir = new File(new File(getFilesDir(), "epic_games"), sanitized);
                prefs.edit().putString("epic_dir_" + game.appName,
                        installDir.getAbsolutePath()).apply();

                // Run download pipeline
                final String finalToken = token;
                boolean ok = EpicDownloadManager.install(
                        EpicGamesActivity.this,
                        manifestJson,
                        finalToken,
                        installDir.getAbsolutePath(),
                        (msg, pct) -> {
                            if (cancelled.get()) return;
                            cb.onProgress(msg, pct);
                        });

                if (cancelled.get()) { cb.onCancelled(); return; }
                if (!ok) { cb.onError("Download failed"); return; }

                // Scan for Windows .exe files
                List<File> exeFiles = new ArrayList<>();
                AmazonLaunchHelper.collectExe(installDir, exeFiles);

                if (exeFiles.isEmpty()) {
                    cb.onError("No executable found after install");
                    return;
                }

                // Sort best-scored first
                String lowerTitle = game.title.toLowerCase();
                Collections.sort(exeFiles, (a, b) ->
                        AmazonLaunchHelper.scoreExe(b, lowerTitle)
                        - AmazonLaunchHelper.scoreExe(a, lowerTitle));

                if (exeFiles.size() == 1) {
                    String path = exeFiles.get(0).getAbsolutePath();
                    prefs.edit().putString("epic_exe_" + game.appName, path).apply();
                    cb.onComplete(path);
                    return;
                }

                // Multiple exes → ask user
                List<String> candidates = new ArrayList<>();
                for (File f : exeFiles) candidates.add(f.getAbsolutePath());
                cb.onSelectExe(candidates, selected -> {
                    String chosen = (selected != null && !selected.isEmpty())
                            ? selected : exeFiles.get(0).getAbsolutePath();
                    prefs.edit().putString("epic_exe_" + game.appName, chosen).apply();
                    cb.onComplete(chosen);
                });

            } catch (Exception e) {
                Log.e(TAG, "startEpicDownload failed", e);
                if (!cancelled.get()) cb.onError(e.getMessage() != null ? e.getMessage() : "Unknown error");
            }
        }, "epic-dl-" + game.appName).start();

        return () -> cancelled.set(true);
    }

    // ── Dialogs ───────────────────────────────────────────────────────────────

    private void showInstallConfirm(EpicGame game, Runnable onConfirm) {
        long freeBytes = -1;
        try {
            File base   = new File(new File(getFilesDir(), "epic_games"), "_check");
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
        sizeTV.setText("Download size:  Fetching…");
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

        // Fetch download size in background
        if (game.installSize > 0) {
            sizeTV.setText("Download size:  " + formatBytes(game.installSize));
        } else {
            new Thread(() -> {
                long size = 0;
                try {
                    String token = EpicCredentialStore.getValidAccessToken(this);
                    if (token != null) {
                        size = EpicApiClient.getInstallSize(token, game);
                        game.installSize = size;
                    }
                } catch (Exception ignored) {}
                final long finalSize = size;
                uiHandler.post(() -> {
                    if (dialog.isShowing()) {
                        sizeTV.setText("Download size:  "
                                + (finalSize > 0 ? formatBytes(finalSize) : "Unknown"));
                    }
                });
            }, "epic-size-" + game.appName).start();
        }
    }

    // ── Full-screen detail ────────────────────────────────────────────────────

    private void openDetailScreen(EpicGame game) {
        Intent intent = new Intent(this, EpicGameDetailActivity.class);
        intent.putExtra("app_name",        game.appName);
        intent.putExtra("title",           game.title);
        intent.putExtra("description",     game.description);
        intent.putExtra("developer",       game.developer);
        intent.putExtra("art_cover",       game.artCover);
        intent.putExtra("namespace",       game.namespace);
        intent.putExtra("catalog_item_id", game.catalogItemId);
        startActivityForResult(intent, REQ_GAME_DETAIL);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQ_GAME_DETAIL && resultCode == EpicGameDetailActivity.RESULT_REFRESH) {
            applyFilter(searchBar != null ? searchBar.getText().toString() : "");
        } else if (requestCode == REQ_DOWNLOADS) {
            applyFilter(searchBar != null ? searchBar.getText().toString() : "");
        }
    }

    private void showDetailDialog(EpicGame game, View checkmark, Button actionBtn, Runnable onUninstalled) {
        LinearLayout container = new LinearLayout(this);
        container.setOrientation(LinearLayout.VERTICAL);
        container.setPadding(dp(20), dp(8), dp(20), dp(4));

        StringBuilder msg = new StringBuilder();
        if (!game.developer.isEmpty()) msg.append("Developer: ").append(game.developer).append("\n");
        if (!game.description.isEmpty()) {
            String desc = game.description.length() > 200
                    ? game.description.substring(0, 200) + "…" : game.description;
            msg.append("\n").append(desc);
        }
        msg.append("\nApp: ").append(game.appName);

        TextView msgView = new TextView(this);
        msgView.setText(msg.toString().trim());
        msgView.setTextColor(0xFFCCCCCC);
        container.addView(msgView);

        String installedExe = prefs.getString("epic_exe_" + game.appName, null);
        String installedDir = prefs.getString("epic_dir_" + game.appName, null);

        if (installedExe != null) {
            TextView exeView = new TextView(this);
            exeView.setText("\n.exe: " + new File(installedExe).getName());
            exeView.setTextColor(0xFF888888);
            exeView.setTextSize(12f);
            container.addView(exeView);

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
                            prefs.edit().putString("epic_exe_" + game.appName, selected).apply();
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
                            .remove("epic_exe_" + game.appName)
                            .remove("epic_dir_" + game.appName)
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
            labels[i]   = (parent != null)
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
        prefs.edit().putString("pending_epic_exe", absPath).apply();
        android.content.Intent intent = new android.content.Intent();
        intent.setClassName(getPackageName(),
                "com.xj.landscape.launcher.ui.main.LandscapeLauncherMainActivity");
        intent.addFlags(android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP
                | android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intent);
    }

    // ── Cache ─────────────────────────────────────────────────────────────────

    private void saveCachedGames(List<EpicGame> games) {
        try {
            JSONArray arr = new JSONArray();
            for (EpicGame g : games) {
                JSONObject j = new JSONObject();
                j.put("appName",       g.appName);
                j.put("namespace",     g.namespace);
                j.put("catalogItemId", g.catalogItemId);
                j.put("title",         g.title);
                j.put("artCover",      g.artCover);
                j.put("artSquare",     g.artSquare);
                j.put("developer",     g.developer);
                j.put("description",   g.description);
                j.put("version",       g.version);
                j.put("isInstalled",   g.isInstalled);
                j.put("installPath",   g.installPath);
                j.put("installSize",   g.installSize);
                j.put("canRunOffline", g.canRunOffline);
                arr.put(j);
            }
            prefs.edit().putString(CACHE_KEY, arr.toString()).apply();
        } catch (Exception e) { Log.e(TAG, "saveCachedGames failed", e); }
    }

    private List<EpicGame> loadCachedGames() {
        try {
            String json = prefs.getString(CACHE_KEY, null);
            if (json == null) return null;
            JSONArray arr = new JSONArray(json);
            List<EpicGame> games = new ArrayList<>();
            for (int i = 0; i < arr.length(); i++) {
                JSONObject j = arr.getJSONObject(i);
                EpicGame g = new EpicGame();
                g.appName       = j.optString("appName",       "");
                g.namespace     = j.optString("namespace",     "");
                g.catalogItemId = j.optString("catalogItemId", "");
                g.title         = j.optString("title",         "");
                g.artCover      = j.optString("artCover",      "");
                g.artSquare     = j.optString("artSquare",     "");
                g.developer     = j.optString("developer",     "");
                g.description   = j.optString("description",   "");
                g.version       = j.optString("version",       "");
                g.isInstalled   = j.optBoolean("isInstalled",  false);
                g.installPath   = j.optString("installPath",   "");
                long cachedSize = j.optLong("installSize", 0L);
                // Sanity-check: discard absurd cached values (> 1 TB = corrupt/stale cache)
                g.installSize   = (cachedSize > 1_099_511_627_776L) ? 0L : cachedSize;
                g.canRunOffline = j.optBoolean("canRunOffline", true);
                games.add(g);
            }
            return games;
        } catch (Exception e) { Log.e(TAG, "loadCachedGames failed", e); return null; }
    }

    // ── Image loading ─────────────────────────────────────────────────────────

    private void loadImage(EpicGame game, ImageView iv) {
        String url = game.artCover;
        if (url == null || url.isEmpty()) url = game.artSquare;
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
        }, "epic-cover-" + game.appName).start();
    }

    // ── Utilities ─────────────────────────────────────────────────────────────

    private void setSync(String msg) {
        uiHandler.post(() -> {
            if (syncText == null) return;
            syncText.setText(msg);
            if (msg.startsWith("Error") || msg.startsWith("Not logged in")
                    || msg.startsWith("No games")) {
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
