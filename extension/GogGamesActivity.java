package app.revanced.extension.gamehub;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
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

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * Displays the signed-in user's GOG library as scrollable game cards.
 *
 * View modes (toggle button in header):
 *   LIST — collapsible cards with 60×60 cover icon, inline install controls
 *   GRID — 3-column tile grid, square art, tap → install dialog
 *
 * Library sync flow:
 *   1. Proactive token expiry check → refresh if needed
 *   2. GET user/data/games → owned game IDs
 *   3. Per ID: GET products/{id}?expand=downloads,description → metadata
 *   4. Check builds?generation=2 → store gog_gen_{id}
 *   5. Build card views on main thread
 */
public class GogGamesActivity extends Activity {

    private static final String TAG = "BH_GOG";
    private static final String CACHE_KEY = "gog_library_cache";
    private static final String VIEW_MODE_KEY = "view_mode";
    private static final int REQ_GAME_DETAIL = 1001;
    private static final int REQ_DOWNLOADS   = 1002;

    private final Handler uiHandler = new Handler(Looper.getMainLooper());
    private TextView syncText;
    private LinearLayout gameListLayout;
    private ScrollView scrollView;
    private SharedPreferences prefs;
    private Button refreshBtn;
    private Button viewToggleBtn;
    private EditText searchBar;
    private List<GogGame> allGames = new ArrayList<>();
    private View expandedSection = null;
    private TextView expandedArrow = null;
    private String viewMode; // "list" or "grid"
    // DLC accumulator — written to prefs after sync completes
    private final Map<String, List<String[]>> gogDlcBuffer = new HashMap<>();

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs = getSharedPreferences("bh_gog_prefs", 0);
        viewMode = prefs.getString(VIEW_MODE_KEY, "list");
        buildUi();
        List<GogGame> cached = loadCachedGames();
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
        root.setBackgroundColor(0xFF0D0D0D);

        // Header
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.HORIZONTAL);
        header.setBackgroundColor(0xFF1A1A2E);
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
        titleTV.setText("GOG Library");
        titleTV.setTextColor(0xFFFF9800);
        titleTV.setTextSize(18f);
        titleTV.setTypeface(null, Typeface.BOLD);
        titleTV.setPadding(dp(12), 0, 0, 0);
        header.addView(titleTV, new LinearLayout.LayoutParams(0, -2, 1f));

        // View toggle button — shows icon for mode you'll switch TO
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
            if ("list".equals(viewMode)) viewMode = "grid";
            else if ("grid".equals(viewMode)) viewMode = "poster";
            else viewMode = "list";
            prefs.edit().putString(VIEW_MODE_KEY, viewMode).apply();
            viewToggleBtn.setText(viewModeIcon(viewMode));
            expandedSection = null;
            expandedArrow = null;
            String q = searchBar != null ? searchBar.getText().toString() : "";
            applyFilter(q);
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
        searchBar.setBackgroundColor(0xFF222233);
        searchBar.setPadding(dp(12), dp(8), dp(12), dp(8));
        searchBar.setSingleLine(true);
        searchBar.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
            @Override public void onTextChanged(CharSequence s, int start, int before, int count) {
                applyFilter(s.toString());
            }
            @Override public void afterTextChanged(Editable s) {}
        });
        root.addView(searchBar, new LinearLayout.LayoutParams(-1, -2));

        // Sync status
        syncText = new TextView(this);
        syncText.setText("Loading GOG library…");
        syncText.setTextColor(0xFFCCCCCC);
        syncText.setTextSize(13f);
        syncText.setPadding(dp(12), dp(6), dp(12), dp(6));
        syncText.setBackgroundColor(0xFF111111);
        root.addView(syncText, new LinearLayout.LayoutParams(-1, -2));

        // Scrollable game list
        scrollView = new ScrollView(this);
        scrollView.setBackgroundColor(0xFF0D0D0D);
        scrollView.setVisibility(View.GONE);

        gameListLayout = new LinearLayout(this);
        gameListLayout.setOrientation(LinearLayout.VERTICAL);
        gameListLayout.setPadding(dp(8), dp(8), dp(8), dp(8));
        scrollView.addView(gameListLayout, new FrameLayout.LayoutParams(-1, -2));

        root.addView(scrollView, new LinearLayout.LayoutParams(-1, 0, 1f));
        setContentView(root);
    }

    // ── Library sync (background thread) ─────────────────────────────────────

    private void startSync(boolean showProgress) {
        uiHandler.post(() -> {
            if (refreshBtn != null) refreshBtn.setEnabled(false);
            if (showProgress) setSync("Loading GOG library…");
        });
        new Thread(() -> syncLibrary(showProgress), "gog-sync").start();
    }

    private void syncLibrary(boolean showProgress) {
        try {
            if (showProgress) setSync("Checking token…");

            String token = prefs.getString("access_token", null);
            if (token == null) { setSync("Not logged in"); enableRefresh(); return; }

            int loginTime = prefs.getInt("bh_gog_login_time", 0);
            int expiresIn = prefs.getInt("bh_gog_expires_in", 3600);
            int nowSec    = (int) (System.currentTimeMillis() / 1000L);
            if (loginTime == 0 || nowSec >= loginTime + expiresIn) {
                if (showProgress) setSync("Refreshing token…");
                String newToken = GogTokenRefresh.refresh(this);
                if (newToken == null) { setSync("Session expired — please sign in again"); enableRefresh(); return; }
                token = newToken;
            }

            if (showProgress) setSync("Fetching game list…");

            String gamesJson = httpGet("https://embed.gog.com/user/data/games", token);
            if (gamesJson == null) { setSync("Failed to fetch library"); enableRefresh(); return; }

            List<String> ids = new ArrayList<>();
            try {
                JSONObject obj = new JSONObject(gamesJson);
                JSONArray ownedArr = obj.optJSONArray("owned");
                if (ownedArr != null) {
                    for (int i = 0; i < ownedArr.length(); i++) {
                        String id = String.valueOf(ownedArr.getLong(i));
                        if (!"1801418160".equals(id)) ids.add(id);
                    }
                }
            } catch (Exception e) {
                setSync("Error parsing library"); enableRefresh(); return;
            }

            if (ids.isEmpty()) { setSync("No games found in library"); enableRefresh(); return; }

            if (showProgress) setSync("Syncing " + ids.size() + " games…");

            final String finalToken = token;
            ExecutorService pool = Executors.newFixedThreadPool(5);
            List<Future<GogGame>> futures = new ArrayList<>();
            for (String id : ids) {
                futures.add(pool.submit(() -> fetchGame(id, finalToken)));
            }
            pool.shutdown();

            List<GogGame> games = new ArrayList<>();
            for (Future<GogGame> f : futures) {
                try {
                    GogGame g = f.get();
                    if (g != null) games.add(g);
                } catch (Exception ignored) {}
            }

            // Write DLC associations collected during parallel fetch
            saveDlcBuffer();

            saveCachedGames(games);

            final List<GogGame> finalGames = games;
            uiHandler.post(() -> {
                if (finalGames.isEmpty()) {
                    setSync("No compatible games found");
                } else {
                    showGames(finalGames);
                    int fn = finalGames.size(); setSync(fn + (fn == 1 ? " game" : " games") + " — tap a card to install");
                }
                enableRefresh();
            });
        } catch (Exception e) {
            Log.e(TAG, "syncLibrary error", e);
            setSync("Error: " + e.getMessage());
            enableRefresh();
        }
    }

    /** Fetches metadata + generation for a single game ID. Returns null to skip. */
    private GogGame fetchGame(String id, String token) {
        try {
            String productJson = httpGet(
                    "https://api.gog.com/products/" + id + "?expand=downloads,description", token);
            if (productJson == null) return null;

            JSONObject prod = new JSONObject(productJson);
            if (prod.optBoolean("is_secret", false)) return null;
            if ("dlc".equals(prod.optString("game_type"))) {
                storeDlcInBuffer(id, prod);
                return null;
            }

            JSONObject titleObj = prod.optJSONObject("title");
            String titleStr = titleObj != null ? titleObj.optString("*") : null;
            if (titleStr == null) titleStr = prod.optString("title");
            if (titleStr == null || titleStr.isEmpty()) return null;

            // Try SteamGridDB first for vivid portrait cover art
            String imageUrl = sgdbFetchCover(titleStr);
            if (imageUrl.isEmpty()) {
                JSONObject images = prod.optJSONObject("images");
                imageUrl = images != null ? images.optString("icon", "") : "";
                if (imageUrl == null || imageUrl.isEmpty())
                    imageUrl = images != null ? images.optString("background", "") : "";
                if (imageUrl == null) imageUrl = "";
            }

            JSONObject descObj = prod.optJSONObject("description");
            String desc = descObj != null ? descObj.optString("lead", "") : "";
            if (desc == null) desc = "";

            JSONObject company = prod.optJSONObject("developers");
            String developer = company != null ? company.optString("name", "") : prod.optString("developer", "");
            if (developer == null) developer = "";

            JSONArray genres = prod.optJSONArray("genres");
            String category = "";
            if (genres != null && genres.length() > 0) {
                JSONObject g = genres.optJSONObject(0);
                if (g != null) category = g.optString("name", "");
            }

            int generation = 1;
            try {
                String buildsJson = httpGet(
                        "https://api.gog.com/products/" + id + "/os/windows/builds?generation=2", token);
                if (buildsJson != null) {
                    JSONObject bObj = new JSONObject(buildsJson);
                    JSONArray bitems = bObj.optJSONArray("items");
                    if (bitems != null && bitems.length() > 0) generation = 2;
                }
            } catch (Exception ignored) {}

            prefs.edit().putInt("gog_gen_" + id, generation).apply();

            // Cache release date + rating
            String releaseDate = prod.optString("release_date", "");
            if (releaseDate != null && !releaseDate.isEmpty()) {
                prefs.edit().putString("gog_release_" + id, releaseDate).apply();
            }
            int rating = prod.optInt("rating", -1);
            if (rating >= 0) {
                prefs.edit().putInt("gog_rating_" + id, rating).apply();
            }

            // Cache install size if not already stored
            if (prefs.getLong("gog_size_" + id, -1) <= 0) {
                long size = GogDownloadManager.fetchInstallSizeBytes(id, token);
                if (size > 0) prefs.edit().putLong("gog_size_" + id, size).apply();
            }

            return new GogGame(id, titleStr, imageUrl, desc, developer, category, generation);
        } catch (Exception e) {
            Log.w(TAG, "fetchGame " + id + " error: " + e.getMessage());
            return null;
        }
    }

    /** Called from fetchGame() when game_type == "dlc". Thread-safe via synchronized. */
    private synchronized void storeDlcInBuffer(String dlcId, JSONObject prod) {
        try {
            String dlcTitle = "";
            JSONObject titleObj = prod.optJSONObject("title");
            if (titleObj != null) dlcTitle = titleObj.optString("*", "");
            if (dlcTitle.isEmpty()) dlcTitle = prod.optString("title", "");
            if (dlcTitle.isEmpty()) dlcTitle = "Unknown DLC";

            // Resolve base game ID from required_game or requiredGames
            String baseId = "";
            JSONObject reqGame = prod.optJSONObject("required_game");
            if (reqGame != null) baseId = reqGame.optString("id", "");
            if (baseId.isEmpty()) {
                JSONArray reqArr = prod.optJSONArray("requiredGames");
                if (reqArr != null && reqArr.length() > 0)
                    baseId = reqArr.optString(0, "");
            }
            if (baseId.isEmpty()) return; // can't associate without a base game

            List<String[]> list = gogDlcBuffer.get(baseId);
            if (list == null) { list = new ArrayList<>(); gogDlcBuffer.put(baseId, list); }
            list.add(new String[]{dlcId, dlcTitle});
        } catch (Exception e) {
            Log.w(TAG, "storeDlcInBuffer failed: " + e.getMessage());
        }
    }

    /** Write all accumulated DLC associations to prefs, then clear the buffer. */
    private synchronized void saveDlcBuffer() {
        for (Map.Entry<String, List<String[]>> entry : gogDlcBuffer.entrySet()) {
            try {
                JSONArray arr = new JSONArray();
                for (String[] dlc : entry.getValue()) {
                    JSONObject obj = new JSONObject();
                    obj.put("id",    dlc[0]);
                    obj.put("title", dlc[1]);
                    arr.put(obj);
                }
                prefs.edit().putString("gog_dlcs_" + entry.getKey(), arr.toString()).apply();
            } catch (Exception ignored) {}
        }
        gogDlcBuffer.clear();
    }

    private void showGames(List<GogGame> games) {
        Collections.sort(games, (a, b) -> a.title.compareToIgnoreCase(b.title));
        allGames = games;
        String query = searchBar != null ? searchBar.getText().toString() : "";
        applyFilter(query);
        scrollView.setVisibility(View.VISIBLE);
    }

    private void applyFilter(String query) {
        List<GogGame> filtered;
        if (query == null || query.trim().isEmpty()) {
            filtered = allGames;
        } else {
            String q = query.trim().toLowerCase();
            filtered = new ArrayList<>();
            for (GogGame g : allGames) {
                if (g.title.toLowerCase().contains(q)) filtered.add(g);
            }
        }
        final List<GogGame> result = filtered;
        uiHandler.post(() -> {
            gameListLayout.removeAllViews();
            if (result.isEmpty()) {
                gameListLayout.setPadding(dp(8), dp(8), dp(8), dp(8));
                TextView emptyTV = new TextView(GogGamesActivity.this);
                String q2 = query == null ? "" : query.trim();
                emptyTV.setText(q2.isEmpty() ? "Your GOG library is empty"
                                             : "No results for \u201c" + q2 + "\u201d");
                emptyTV.setTextColor(0xFF666666);
                emptyTV.setTextSize(14f);
                emptyTV.setGravity(Gravity.CENTER);
                LinearLayout.LayoutParams emLp = new LinearLayout.LayoutParams(-1, -2);
                emLp.topMargin = dp(32);
                gameListLayout.addView(emptyTV, emLp);
            } else if ("grid".equals(viewMode)) {
                gameListLayout.setPadding(dp(4), dp(4), dp(4), dp(4));
                addGamesAsGrid(result);
            } else if ("poster".equals(viewMode)) {
                gameListLayout.setPadding(dp(4), dp(4), dp(4), dp(4));
                addGamesAsPoster(result);
            } else {
                gameListLayout.setPadding(dp(8), dp(8), dp(8), dp(8));
                for (GogGame g : result) addGameCard(g);
            }
            scrollView.setVisibility(View.VISIBLE);
        });
    }

    private void enableRefresh() {
        uiHandler.post(() -> { if (refreshBtn != null) refreshBtn.setEnabled(true); });
    }

    private List<GogGame> loadCachedGames() {
        String json = prefs.getString(CACHE_KEY, null);
        if (json == null) return null;
        try {
            JSONArray arr = new JSONArray(json);
            List<GogGame> games = new ArrayList<>();
            for (int i = 0; i < arr.length(); i++) {
                JSONObject o = arr.getJSONObject(i);
                games.add(new GogGame(
                        o.getString("gameId"),
                        o.getString("title"),
                        o.optString("imageUrl", ""),
                        o.optString("description", ""),
                        o.optString("developer", ""),
                        o.optString("category", ""),
                        o.optInt("generation", 1)));
            }
            return games;
        } catch (Exception e) { return null; }
    }

    private void saveCachedGames(List<GogGame> games) {
        try {
            JSONArray arr = new JSONArray();
            for (GogGame g : games) {
                JSONObject o = new JSONObject();
                o.put("gameId", g.gameId);
                o.put("title", g.title);
                o.put("imageUrl", g.imageUrl);
                o.put("description", g.description);
                o.put("developer", g.developer);
                o.put("category", g.category);
                o.put("generation", g.generation);
                arr.put(o);
            }
            prefs.edit().putString(CACHE_KEY, arr.toString()).apply();
        } catch (Exception ignored) {}
    }

    // ── LIST view: collapsible game cards (v0.3.4 style) ─────────────────────

    private void addGameCard(GogGame game) {
        boolean isInstalled = prefs.getString("gog_exe_" + game.gameId, null) != null;

        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(10), dp(10), dp(10), dp(10));
        GradientDrawable cardBg = new GradientDrawable();
        cardBg.setColor(0xFF1A1A2E);
        cardBg.setCornerRadius(dp(6));
        card.setBackground(cardBg);
        card.setFocusable(true);
        card.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);
        card.setOnFocusChangeListener((v, hasFocus) -> {
            cardBg.setColor(hasFocus ? 0xFF2A2A4E : 0xFF1A1A2E);
            cardBg.setStroke(hasFocus ? dp(3) : 0, hasFocus ? 0xFFFFD700 : 0x00000000);
        });
        LinearLayout.LayoutParams cardLp = new LinearLayout.LayoutParams(-1, -2);
        cardLp.bottomMargin = dp(8);

        // ── Collapsed header ──────────────────────────────────────────────────
        LinearLayout topRow = new LinearLayout(this);
        topRow.setOrientation(LinearLayout.HORIZONTAL);
        topRow.setGravity(Gravity.CENTER_VERTICAL);

        ImageView coverIV = new ImageView(this);
        coverIV.setScaleType(ImageView.ScaleType.CENTER_CROP);
        GradientDrawable coverBg = new GradientDrawable();
        coverBg.setColor(0xFF111122);
        coverBg.setCornerRadius(dp(4));
        coverIV.setBackground(coverBg);
        LinearLayout.LayoutParams coverLp = new LinearLayout.LayoutParams(dp(60), dp(60));
        coverLp.rightMargin = dp(10);
        topRow.addView(coverIV, coverLp);
        loadImage(game, coverIV);

        LinearLayout titleRow = new LinearLayout(this);
        titleRow.setOrientation(LinearLayout.HORIZONTAL);
        titleRow.setGravity(Gravity.CENTER_VERTICAL);

        if (game.generation > 0) {
            titleRow.addView(makeGenBadge(game.generation), makeGenBadgeLp());
        }

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

        View titleSpacer = new View(this);
        titleRow.addView(titleSpacer, new LinearLayout.LayoutParams(0, 0, 1f));

        // ── Subtitle (developer · genre) shown while collapsed ────────────────
        LinearLayout infoCol = new LinearLayout(this);
        infoCol.setOrientation(LinearLayout.VERTICAL);
        infoCol.setGravity(Gravity.CENTER_VERTICAL);
        infoCol.addView(titleRow, new LinearLayout.LayoutParams(-1, -2));
        if (!game.developer.isEmpty() || !game.category.isEmpty()) {
            String sub = game.developer.isEmpty() ? game.category
                       : game.category.isEmpty()  ? game.developer
                       : game.developer + "  ·  " + game.category;
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

        // ── Expandable section ────────────────────────────────────────────────
        LinearLayout expandSection = new LinearLayout(this);
        expandSection.setOrientation(LinearLayout.VERTICAL);
        expandSection.setVisibility(View.GONE);

        if (!game.category.isEmpty() || !game.developer.isEmpty()) {
            String meta = game.category.isEmpty() ? game.developer
                        : game.developer.isEmpty() ? game.category
                        : game.category + " · " + game.developer;
            TextView metaTV = new TextView(this);
            metaTV.setText(meta);
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
        progressBar.getProgressDrawable().setColorFilter(0xFFFF9800,
                android.graphics.PorterDuff.Mode.SRC_IN);
        LinearLayout.LayoutParams pbLp = new LinearLayout.LayoutParams(-1, dp(6));
        pbLp.topMargin = dp(6);
        expandSection.addView(progressBar, pbLp);

        TextView pctTV = new TextView(this);
        pctTV.setTextColor(0xFFFF9800);
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
        actionBtn.setBackgroundColor(isInstalled ? 0xFF2E7D32 : 0xFF7033FF);
        actionBtn.setTextSize(13f);
        LinearLayout.LayoutParams abLp = new LinearLayout.LayoutParams(-1, dp(40));
        abLp.topMargin = dp(8);
        expandSection.addView(actionBtn, abLp);

        card.addView(expandSection, new LinearLayout.LayoutParams(-1, -2));

        // Button click
        final Runnable[] cancelRef1 = {null};
        actionBtn.setOnClickListener(v -> {
            String btnLabel = actionBtn.getText().toString();
            if ("Cancel".equals(btnLabel)) {
                if (cancelRef1[0] != null) cancelRef1[0].run();
                return;
            }
            if ("Add Game".equals(btnLabel) || "Add to Launcher".equals(btnLabel)) {
                String exePath = prefs.getString("gog_exe_" + game.gameId, null);
                if (exePath != null) GogLaunchHelper.triggerLaunch(this, exePath);
                return;
            }
            showInstallConfirm(game, () -> {
                cancelRef1[0] = null;
                actionBtn.setEnabled(true);
                actionBtn.setText("Cancel");
                actionBtn.setBackgroundColor(0xFFCC3333);
                progressBar.setVisibility(View.VISIBLE);
                statusTV.setVisibility(View.VISIBLE);
                pctTV.setText("0%");
                pctTV.setVisibility(View.VISIBLE);

                cancelRef1[0] = startViaServiceGog(game, new GogDownloadManager.Callback() {
                    @Override public void onProgress(String msg, int pct) {
                        uiHandler.post(() -> {
                            statusTV.setText(msg);
                            progressBar.setProgress(pct);
                            pctTV.setText(pct + "%");
                        });
                    }
                    @Override public void onComplete(String exePath) {
                        uiHandler.post(() -> {
                            cancelRef1[0] = null;
                            progressBar.setProgress(100);
                            pctTV.setVisibility(View.GONE);
                            checkmark.setVisibility(View.VISIBLE);
                            collapsedCheckTV.setVisibility(View.VISIBLE);
                            statusTV.setText("Installed");
                            actionBtn.setText("Add Game");
                            actionBtn.setBackgroundColor(0xFF2E7D32);
                            actionBtn.setEnabled(true);
                        });
                    }
                    @Override public void onError(String msg) {
                        uiHandler.post(() -> {
                            cancelRef1[0] = null;
                            pctTV.setVisibility(View.GONE);
                            statusTV.setText("Error: " + msg);
                            actionBtn.setText("Install");
                            actionBtn.setBackgroundColor(0xFF7033FF);
                            actionBtn.setEnabled(true);
                            Toast.makeText(GogGamesActivity.this, "Error: " + msg,
                                    Toast.LENGTH_LONG).show();
                        });
                    }
                    @Override public void onCancelled() {
                        uiHandler.post(() -> {
                            cancelRef1[0] = null;
                            progressBar.setProgress(0);
                            progressBar.setVisibility(View.GONE);
                            pctTV.setVisibility(View.GONE);
                            statusTV.setText("");
                            actionBtn.setText("Install");
                            actionBtn.setBackgroundColor(0xFF7033FF);
                            actionBtn.setEnabled(true);
                        });
                    }
                    @Override public void onSelectExe(java.util.List<String> candidates,
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
                expandedArrow = null;
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
                expandedArrow = arrowTV;
            }
        });

        gameListLayout.addView(card, cardLp);
    }

    private static String viewModeIcon(String mode) {
        if ("grid".equals(mode)) return "▦";
        if ("poster".equals(mode)) return "☰";
        return "⊞";
    }

    // ── GRID view ─────────────────────────────────────────────────────────────

    private void addGamesAsGrid(List<GogGame> games) {
        addGamesAsGrid(games, 105);
    }

    // ── POSTER view (same grid, taller portrait cards) ────────────────────────

    private void addGamesAsPoster(List<GogGame> games) {
        addGamesAsGrid(games, 176, dp(16), dp(10));
    }

    private void addGamesAsGrid(List<GogGame> games, int artHeightDp) {
        addGamesAsGrid(games, artHeightDp, dp(3), dp(6));
    }

    private void addGamesAsGrid(List<GogGame> games, int artHeightDp, int tileHMargin, int rowBottomMargin) {
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
                    rowLayout.addView(makeGridTile(games.get(idx), artHeightDp), makeGridTileLp(tileHMargin));
                } else {
                    View spacer = new View(this);
                    rowLayout.addView(spacer, makeGridTileLp(tileHMargin));
                }
            }
            gameListLayout.addView(rowLayout, rowLp);
        }
    }

    private View makeGridTile(GogGame game) { return makeGridTile(game, 105); }

    private View makeGridTile(GogGame game, int artHeightDp) {
        boolean isInstalled = prefs.getString("gog_exe_" + game.gameId, null) != null;

        LinearLayout tile = new LinearLayout(this);
        tile.setOrientation(LinearLayout.VERTICAL);
        GradientDrawable tileBg = new GradientDrawable();
        tileBg.setColor(0xFF111122);
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
            tileBg.setColor(hasFocus ? 0xFF1D1D3A : 0xFF111122);
            focusBorder.setStroke(hasFocus ? dp(3) : 0, hasFocus ? 0xFFFFD700 : 0x00000000);
        });
        focusWrapper.setOnClickListener(v -> tile.performClick());
        focusWrapper.setOnLongClickListener(v -> tile.performLongClick());

        // ── Art area (FrameLayout so badges/title can overlay) ─────────────────
        FrameLayout artFrame = new FrameLayout(this);

        ImageView coverIV = new ImageView(this);
        coverIV.setScaleType(ImageView.ScaleType.CENTER_CROP);
        coverIV.setBackgroundColor(0xFF0D0D1A);
        artFrame.addView(coverIV, new FrameLayout.LayoutParams(-1, dp(artHeightDp)));
        loadImage(game, coverIV);

        // Gen badge — top-left corner
        if (game.generation > 0) {
            TextView genTV = new TextView(this);
            genTV.setText("Gen " + game.generation);
            genTV.setTextSize(8f);
            genTV.setTextColor(0xFFFFFFFF);
            genTV.setPadding(dp(4), dp(2), dp(4), dp(2));
            GradientDrawable genBg = new GradientDrawable();
            genBg.setColor(game.generation == 2 ? 0xCC0277BD : 0xCCE65100);
            genBg.setCornerRadius(dp(3));
            genTV.setBackground(genBg);
            FrameLayout.LayoutParams genLp = new FrameLayout.LayoutParams(-2, -2);
            genLp.gravity = Gravity.TOP | Gravity.START;
            genLp.leftMargin = dp(4);
            genLp.topMargin = dp(4);
            artFrame.addView(genTV, genLp);
        }

        // Title + ✓ bar — pinned to bottom of art
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

        // ── Action row (hidden until tapped) ─────────────────────────────────
        LinearLayout actionRow = new LinearLayout(this);
        actionRow.setOrientation(LinearLayout.VERTICAL);
        actionRow.setVisibility(View.GONE);
        actionRow.setBackgroundColor(0xFF0D0D1A);
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
        actionBtn.setBackgroundColor(isInstalled ? 0xFF2E7D32 : 0xFF5533CC);
        actionBtn.setTextSize(10f);
        actionBtn.setPadding(0, 0, 0, 0);
        LinearLayout.LayoutParams abLp = new LinearLayout.LayoutParams(-1, dp(30));
        abLp.topMargin = dp(2);
        actionRow.addView(actionBtn, abLp);

        tile.addView(actionRow, new LinearLayout.LayoutParams(-1, -2));

        // Button click
        final Runnable[] cancelRef2 = {null};
        actionBtn.setOnClickListener(v -> {
            String lbl = actionBtn.getText().toString();
            if ("Cancel".equals(lbl)) {
                if (cancelRef2[0] != null) cancelRef2[0].run();
                return;
            }
            if ("Add Game".equals(lbl) || "Add to Launcher".equals(lbl)) {
                String exe = prefs.getString("gog_exe_" + game.gameId, null);
                if (exe != null) GogLaunchHelper.triggerLaunch(this, exe);
                return;
            }
            showInstallConfirm(game, () -> {
                cancelRef2[0] = null;
                actionBtn.setEnabled(true);
                actionBtn.setText("Cancel");
                actionBtn.setBackgroundColor(0xFFCC3333);
                progressBar.setVisibility(View.VISIBLE);

                cancelRef2[0] = startViaServiceGog(game, new GogDownloadManager.Callback() {
                    @Override public void onProgress(String msg, int pct) {
                        uiHandler.post(() -> {
                            progressBar.setProgress(pct);
                        });
                    }
                    @Override public void onComplete(String exePath) {
                        uiHandler.post(() -> {
                            cancelRef2[0] = null;
                            progressBar.setProgress(100);
                            progressBar.setVisibility(View.GONE);
                            checkTV.setVisibility(View.VISIBLE);
                            actionBtn.setText("Add Game");
                            actionBtn.setBackgroundColor(0xFF2E7D32);
                            actionBtn.setEnabled(true);
                        });
                    }
                    @Override public void onError(String msg) {
                        uiHandler.post(() -> {
                            cancelRef2[0] = null;
                            progressBar.setVisibility(View.GONE);
                            actionBtn.setText("Install");
                            actionBtn.setBackgroundColor(0xFF5533CC);
                            actionBtn.setEnabled(true);
                            Toast.makeText(GogGamesActivity.this, "Error: " + msg,
                                    Toast.LENGTH_LONG).show();
                        });
                    }
                    @Override public void onCancelled() {
                        uiHandler.post(() -> {
                            cancelRef2[0] = null;
                            progressBar.setProgress(0);
                            progressBar.setVisibility(View.GONE);
                            actionBtn.setText("Install");
                            actionBtn.setBackgroundColor(0xFF5533CC);
                            actionBtn.setEnabled(true);
                        });
                    }
                    @Override public void onSelectExe(java.util.List<String> candidates,
                                                       java.util.function.Consumer<String> onSelected) {
                        showExePicker(candidates, onSelected);
                    }
                });
            });
        });

        // Tile tap: toggle action row; auto-collapse previous
        tile.setOnClickListener(v -> {
            if (actionRow.getVisibility() == View.VISIBLE) {
                actionRow.setVisibility(View.GONE);
                expandedSection = null;
            } else {
                if (expandedSection != null) {
                    expandedSection.setVisibility(View.GONE);
                }
                actionRow.setVisibility(View.VISIBLE);
                expandedSection = actionRow;
                expandedArrow = null;
            }
        });

        tile.setOnLongClickListener(v -> {
            openDetailScreen(game);
            return true;
        });

        focusWrapper.addView(tile, new FrameLayout.LayoutParams(-1, -1));
        return focusWrapper;
    }

    private LinearLayout.LayoutParams makeGridTileLp() { return makeGridTileLp(dp(3)); }

    private LinearLayout.LayoutParams makeGridTileLp(int hMargin) {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, -2, 1f);
        lp.leftMargin = hMargin;
        lp.rightMargin = hMargin;
        return lp;
    }

    /** Full install/launch dialog for grid tile taps. */
    private void showGridInstallDialog(GogGame game) {
        boolean isInstalled = prefs.getString("gog_exe_" + game.gameId, null) != null;

        LinearLayout content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(dp(16), dp(8), dp(16), dp(4));

        // Description / meta
        StringBuilder sb = new StringBuilder();
        if (!game.developer.isEmpty()) sb.append("Developer: ").append(game.developer).append("\n");
        if (!game.category.isEmpty())  sb.append("Genre: ").append(game.category).append("\n");
        TextView descTV = new TextView(this);
        String metaText = sb.toString().trim();
        String descHtml = game.description.isEmpty() ? "" : game.description;
        CharSequence descParsed = android.text.Html.fromHtml(
                metaText.isEmpty() ? descHtml : metaText + "\n\n" + descHtml,
                android.text.Html.FROM_HTML_MODE_COMPACT);
        descTV.setText(descParsed);
        descTV.setTextColor(0xFFCCCCCC);
        descTV.setTextSize(12f);
        content.addView(descTV, new LinearLayout.LayoutParams(-1, -2));

        // ProgressBar + status (shown during download)
        ProgressBar progressBar = new ProgressBar(this, null,
                android.R.attr.progressBarStyleHorizontal);
        progressBar.setMax(100);
        progressBar.setVisibility(View.GONE);
        LinearLayout.LayoutParams pbLp = new LinearLayout.LayoutParams(-1, dp(6));
        pbLp.topMargin = dp(12);
        content.addView(progressBar, pbLp);

        TextView statusTV = new TextView(this);
        statusTV.setTextColor(0xFFFF9800);
        statusTV.setTextSize(11f);
        statusTV.setVisibility(View.GONE);
        LinearLayout.LayoutParams stLp = new LinearLayout.LayoutParams(-1, -2);
        stLp.topMargin = dp(4);
        content.addView(statusTV, stLp);

        AlertDialog.Builder b = new AlertDialog.Builder(this);
        b.setTitle(game.title);
        b.setView(content);

        if (isInstalled) {
            b.setPositiveButton("Add to Launcher", (d, w) -> {
                String exe = prefs.getString("gog_exe_" + game.gameId, null);
                if (exe != null) GogLaunchHelper.triggerLaunch(this, exe);
            });
            b.setNeutralButton("Uninstall", (d, w) -> {
                String dirName = prefs.getString("gog_dir_" + game.gameId, null);
                if (dirName != null) {
                    new Thread(() -> {
                        java.io.File dir = GogInstallPath.getInstallDir(this, dirName);
                        deleteDir(dir);
                        prefs.edit()
                                .remove("gog_dir_" + game.gameId)
                                .remove("gog_exe_" + game.gameId)
                                .remove("gog_cover_" + game.gameId)
                                .apply();
                        uiHandler.post(() -> {
                            applyFilter(searchBar != null ? searchBar.getText().toString() : "");
                            Toast.makeText(this, game.title + " uninstalled", Toast.LENGTH_SHORT).show();
                        });
                    }).start();
                }
            });
            b.setNegativeButton("Close", null);
        } else {
            b.setNegativeButton("Close", null);
            AlertDialog dialog = b.create();
            dialog.show();

            // Replace positive button with Install — prevents auto-dismiss during download
            Button installBtn = dialog.getButton(AlertDialog.BUTTON_NEGATIVE);
            // Reuse negative slot for close; add custom Install button in content
            Button customInstall = new Button(this);
            customInstall.setText("Install");
            customInstall.setTextColor(0xFFFFFFFF);
            customInstall.setBackgroundColor(0xFF7033FF);
            customInstall.setTextSize(13f);
            LinearLayout.LayoutParams btnLp = new LinearLayout.LayoutParams(-1, dp(44));
            btnLp.topMargin = dp(12);
            content.addView(customInstall, btnLp);

            final Runnable[] cancelRef3 = {null};
            customInstall.setOnClickListener(v -> {
                if ("Cancel".equals(customInstall.getText().toString())) {
                    if (cancelRef3[0] != null) cancelRef3[0].run();
                    return;
                }
                showInstallConfirm(game, () -> {
                cancelRef3[0] = null;
                customInstall.setEnabled(true);
                customInstall.setText("Cancel");
                customInstall.setBackgroundColor(0xFFCC3333);
                progressBar.setVisibility(View.VISIBLE);
                statusTV.setVisibility(View.VISIBLE);
                statusTV.setText("0%  Starting…");
                dialog.setCancelable(false);

                cancelRef3[0] = startViaServiceGog(game, new GogDownloadManager.Callback() {
                    @Override public void onProgress(String msg, int pct) {
                        uiHandler.post(() -> {
                            progressBar.setProgress(pct);
                            statusTV.setText(pct + "%  " + msg);
                        });
                    }
                    @Override public void onComplete(String installDir) {
                        uiHandler.post(() -> {
                            cancelRef3[0] = null;
                            progressBar.setProgress(100);
                            statusTV.setText("✓ Installed");
                            customInstall.setText("Add to Launcher");
                            customInstall.setBackgroundColor(0xFF2E7D32);
                            customInstall.setEnabled(true);
                            dialog.setCancelable(true);
                            customInstall.setOnClickListener(vv -> {
                                String exe = prefs.getString("gog_exe_" + game.gameId, null);
                                if (exe != null) GogLaunchHelper.triggerLaunch(GogGamesActivity.this, exe);
                                dialog.dismiss();
                            });
                            // Rebuild grid to show ✓ on tile
                            applyFilter(searchBar != null ? searchBar.getText().toString() : "");
                        });
                    }
                    @Override public void onError(String msg) {
                        uiHandler.post(() -> {
                            cancelRef3[0] = null;
                            progressBar.setVisibility(View.GONE);
                            statusTV.setText("Error: " + msg);
                            customInstall.setText("Install");
                            customInstall.setBackgroundColor(0xFF7033FF);
                            customInstall.setEnabled(true);
                            dialog.setCancelable(true);
                        });
                    }
                    @Override public void onCancelled() {
                        uiHandler.post(() -> {
                            cancelRef3[0] = null;
                            progressBar.setProgress(0);
                            progressBar.setVisibility(View.GONE);
                            statusTV.setText("");
                            customInstall.setText("Install");
                            customInstall.setBackgroundColor(0xFF7033FF);
                            customInstall.setEnabled(true);
                            dialog.setCancelable(true);
                        });
                    }
                    @Override public void onSelectExe(java.util.List<String> candidates,
                                                       java.util.function.Consumer<String> onSelected) {
                        showExePicker(candidates, onSelected);
                    }
                });
                }); // end showInstallConfirm
            });
            return; // dialog already shown above
        }

        b.show();
    }

    // ── Service-backed download (routes through BhDownloadService) ───────────

    private Runnable startViaServiceGog(GogGame game, GogDownloadManager.Callback cb) {
        String dlKey = "gog_" + game.gameId;
        if (android.os.Build.VERSION.SDK_INT >= 33 &&
                checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.POST_NOTIFICATIONS}, 0);
        }
        Intent svc = new Intent(this, BhDownloadService.class);
        svc.setAction(BhDownloadService.ACTION_START);
        svc.putExtra(BhDownloadService.EXTRA_STORE, "GOG");
        svc.putExtra(BhDownloadService.EXTRA_GAME_ID, dlKey);
        svc.putExtra(BhDownloadService.EXTRA_GAME_NAME, game.title);
        svc.putExtra(BhDownloadService.EXTRA_GOG_GAME_ID, game.gameId);
        svc.putExtra(BhDownloadService.EXTRA_GOG_TITLE, game.title);
        svc.putExtra(BhDownloadService.EXTRA_GOG_IMAGE_URL, game.imageUrl);
        svc.putExtra(BhDownloadService.EXTRA_GOG_DEVELOPER, game.developer);
        svc.putExtra(BhDownloadService.EXTRA_GOG_CATEGORY, game.category);
        svc.putExtra(BhDownloadService.EXTRA_GOG_GENERATION, game.generation);
        startForegroundService(svc);
        BhDownloadService.addListener(dlKey, new BhDownloadService.DownloadListener() {
            @Override public void onProgress(String msg, int pct) { cb.onProgress(msg, pct); }
            @Override public void onComplete(String installDir)   { cb.onComplete(installDir); }
            @Override public void onError(String msg)             { cb.onError(msg); }
            @Override public void onCancelled()                   { cb.onCancelled(); }
        });
        return () -> BhDownloadService.cancel(GogGamesActivity.this, dlKey);
    }

    // ── Full-screen detail ────────────────────────────────────────────────────

    private void openDetailScreen(GogGame game) {
        Intent intent = new Intent(this, GogGameDetailActivity.class);
        intent.putExtra("game_id",     game.gameId);
        intent.putExtra("title",       game.title);
        intent.putExtra("image_url",   game.imageUrl);
        intent.putExtra("description", game.description);
        intent.putExtra("developer",   game.developer);
        intent.putExtra("category",    game.category);
        intent.putExtra("generation",  game.generation);
        startActivityForResult(intent, REQ_GAME_DETAIL);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQ_GAME_DETAIL && resultCode == GogGameDetailActivity.RESULT_REFRESH) {
            applyFilter(searchBar != null ? searchBar.getText().toString() : "");
        } else if (requestCode == REQ_DOWNLOADS) {
            applyFilter(searchBar != null ? searchBar.getText().toString() : "");
        }
    }

    // ── Dialogs (list view detail) ────────────────────────────────────────────

    private void showDetailDialog(GogGame game, View checkmark, Button actionBtn, Runnable onUninstalled) {
        AlertDialog.Builder b = new AlertDialog.Builder(this);
        b.setTitle(game.title);

        // Custom view: message text + optional Set .exe button
        android.widget.LinearLayout container = new android.widget.LinearLayout(this);
        container.setOrientation(android.widget.LinearLayout.VERTICAL);
        int pad = dp(20);
        container.setPadding(pad, dp(8), pad, dp(4));

        StringBuilder msg = new StringBuilder();
        if (!game.developer.isEmpty()) msg.append("Developer: ").append(game.developer).append("\n");
        if (!game.category.isEmpty())  msg.append("Genre: ").append(game.category).append("\n");
        if (!game.description.isEmpty()) msg.append("\n").append(game.description);

        android.widget.TextView msgView = new android.widget.TextView(this);
        msgView.setText(msg.toString().trim());
        msgView.setTextColor(0xFFCCCCCC);
        container.addView(msgView);

        String installedExe = prefs.getString("gog_exe_" + game.gameId, null);
        String dirName      = prefs.getString("gog_dir_" + game.gameId, null);

        if (installedExe != null && dirName != null) {
            android.widget.TextView exeView = new android.widget.TextView(this);
            exeView.setText("\n.exe: " + new java.io.File(installedExe).getName());
            exeView.setTextColor(0xFF888888);
            exeView.setTextSize(12f);
            container.addView(exeView);

            Button setExeBtn = new Button(this);
            setExeBtn.setText("Set .exe\u2026");
            setExeBtn.setTextColor(0xFFFFFFFF);
            setExeBtn.setBackgroundColor(0xFF444444);
            android.widget.LinearLayout.LayoutParams lp =
                    new android.widget.LinearLayout.LayoutParams(-2, -2);
            lp.topMargin = dp(10);
            setExeBtn.setOnClickListener(v -> {
                java.io.File installPath = GogInstallPath.getInstallDir(this, dirName);
                new Thread(() -> {
                    java.util.List<String> candidates =
                            GogDownloadManager.collectExeCandidates(installPath);
                    if (candidates.isEmpty()) {
                        uiHandler.post(() -> Toast.makeText(this,
                                "No .exe files found in install directory",
                                Toast.LENGTH_SHORT).show());
                        return;
                    }
                    showExePicker(candidates, selected -> {
                        if (selected != null && !selected.isEmpty()) {
                            prefs.edit().putString("gog_exe_" + game.gameId, selected).apply();
                            uiHandler.post(() -> {
                                exeView.setText("\n.exe: " + new java.io.File(selected).getName());
                                Toast.makeText(this,
                                        "Exe set to: " + new java.io.File(selected).getName(),
                                        Toast.LENGTH_SHORT).show();
                            });
                        }
                    });
                }).start();
            });
            container.addView(setExeBtn, lp);

            b.setNegativeButton("Uninstall", (dialog, which) -> uninstall(game, onUninstalled));
            b.setNeutralButton("Copy to Downloads", (dialog, which) -> copyToDownloads(game));
        }

        b.setView(container);
        b.setPositiveButton("Close", null);
        b.show();
    }

    private void uninstall(GogGame game, Runnable onUninstalled) {
        String dirName = prefs.getString("gog_dir_" + game.gameId, null);
        if (dirName != null) {
            new Thread(() -> {
                java.io.File installPath = GogInstallPath.getInstallDir(this, dirName);
                deleteDir(installPath);
                prefs.edit()
                        .remove("gog_dir_" + game.gameId)
                        .remove("gog_exe_" + game.gameId)
                        .remove("gog_cover_" + game.gameId)
                        .apply();
                uiHandler.post(() -> {
                    onUninstalled.run();
                    Toast.makeText(this, game.title + " uninstalled", Toast.LENGTH_SHORT).show();
                });
            }).start();
        }
    }

    private void copyToDownloads(GogGame game) {
        Toast.makeText(this, "Copying to Downloads…", Toast.LENGTH_SHORT).show();
        new Thread(() -> {
            String dest = GogDownloadManager.copyToDownloads(this, game.gameId);
            uiHandler.post(() -> {
                if (dest != null) {
                    Toast.makeText(this, "Copied to: " + dest, Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(this, "Copy failed — check storage permission",
                            Toast.LENGTH_SHORT).show();
                }
            });
        }).start();
    }

    // ── Shared helpers ────────────────────────────────────────────────────────

    private TextView makeGenBadge(int generation) {
        TextView badge = new TextView(this);
        badge.setText("Gen " + generation);
        badge.setTextSize(10f);
        badge.setTextColor(0xFFFFFFFF);
        badge.setPadding(dp(5), dp(2), dp(5), dp(2));
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(generation == 2 ? 0xFF4FC3F7 : 0xFFFF9800);
        bg.setCornerRadius(dp(3));
        badge.setBackground(bg);
        return badge;
    }

    private LinearLayout.LayoutParams makeGenBadgeLp() {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, -2);
        lp.rightMargin = dp(6);
        return lp;
    }

    private void loadImage(GogGame game, ImageView iv) {
        if (game.imageUrl == null || game.imageUrl.isEmpty()) return;
        String url = game.imageUrl.startsWith("//") ? "https:" + game.imageUrl : game.imageUrl;
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
        }, "gog-cover-" + game.gameId).start();
    }

    // ── Utilities ─────────────────────────────────────────────────────────────

    private void setSync(String msg) {
        uiHandler.post(() -> {
            syncText.setText(msg);
            if (msg.startsWith("Error") || msg.startsWith("Session expired")
                    || msg.startsWith("Failed") || msg.startsWith("Not logged in")) {
                syncText.setTextColor(0xFFFF6B6B);
            } else if (msg.contains("game") && (msg.contains("tap") || msg.contains("cached"))) {
                syncText.setTextColor(0xFF81C784);
            } else {
                syncText.setTextColor(0xFFCCCCCC);
            }
        });
    }

    /** Shows a pre-install confirmation dialog with game size (async-fetched) and available storage. */
    private void showInstallConfirm(GogGame game, Runnable onConfirm) {
        long freeBytes = -1;
        try {
            java.io.File installBase = GogInstallPath.getInstallDir(this, "_check");
            java.io.File parent = installBase.getParentFile();
            if (parent != null) parent.mkdirs();
            android.os.StatFs sf = new android.os.StatFs(
                    parent != null ? parent.getAbsolutePath() : getCacheDir().getAbsolutePath());
            freeBytes = sf.getAvailableBlocksLong() * sf.getBlockSizeLong();
        } catch (Exception ignored) {}

        final long finalFree = freeBytes;

        LinearLayout content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(dp(20), dp(8), dp(20), dp(8));

        TextView gameSizeTV = new TextView(this);
        gameSizeTV.setText("Game size:  Fetching…");
        gameSizeTV.setTextColor(0xFFCCCCCC);
        gameSizeTV.setTextSize(14f);
        content.addView(gameSizeTV);

        TextView freeTV = new TextView(this);
        freeTV.setText("Available storage:  " + GogDownloadManager.formatBytes(finalFree));
        freeTV.setTextColor(0xFF88CC88);
        freeTV.setTextSize(14f);
        LinearLayout.LayoutParams tvLp = new LinearLayout.LayoutParams(-2, -2);
        tvLp.topMargin = dp(6);
        content.addView(freeTV, tvLp);

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

        new Thread(() -> {
            long size = GogDownloadManager.fetchGameSize(this, game);
            runOnUiThread(() -> {
                if (!dialog.isShowing()) return;
                gameSizeTV.setText("Game size:  " + GogDownloadManager.formatBytes(size));
                if (size > 0 && finalFree > 0 && size > finalFree) {
                    gameSizeTV.setTextColor(0xFFFF5252);
                    gameSizeTV.setText("Game size:  " + GogDownloadManager.formatBytes(size)
                            + "  ⚠ Not enough space");
                    freeTV.setTextColor(0xFFFF5252);
                }
            });
        }).start();
    }

    /**
     * Shows a dialog letting the user pick from multiple exe candidates.
     * {@code candidates} contains absolute paths; display name is the last 2 path segments.
     * Calls {@code onSelected} with the chosen absolute path on the background thread.
     */
    private void showExePicker(java.util.List<String> candidates,
                                java.util.function.Consumer<String> onSelected) {
        String[] labels = new String[candidates.size()];
        for (int i = 0; i < candidates.size(); i++) {
            java.io.File f = new java.io.File(candidates.get(i));
            java.io.File parent = f.getParentFile();
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

    private int dp(int v) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v,
                getResources().getDisplayMetrics());
    }

    private static String httpGet(String url, String token) {
        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setConnectTimeout(20000);
            conn.setReadTimeout(20000);
            if (token != null) conn.setRequestProperty("Authorization", "Bearer " + token);
            if (conn.getResponseCode() != 200) { conn.disconnect(); return null; }
            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            conn.disconnect();
            return sb.toString();
        } catch (Exception e) { return null; }
    }

    private static final String SGDB_KEY = "cf89227f12c773bb1117b6b109ae1659";

    /** Returns the first SteamGridDB 600x900 cover URL for the given game title, or "" on failure. */
    private static String sgdbFetchCover(String title) {
        try {
            String encoded = java.net.URLEncoder.encode(title, "UTF-8");
            String searchJson = httpGet(
                    "https://www.steamgriddb.com/api/v2/search/autocomplete/" + encoded, SGDB_KEY);
            if (searchJson == null) return "";
            JSONArray results = new JSONObject(searchJson).optJSONArray("data");
            if (results == null || results.length() == 0) return "";
            int gameId = results.getJSONObject(0).getInt("id");

            String gridsJson = httpGet(
                    "https://www.steamgriddb.com/api/v2/grids/game/" + gameId
                            + "?dimensions=600x900&mimes=image/jpeg,image/png&limit=1",
                    SGDB_KEY);
            if (gridsJson == null) return "";
            JSONArray grids = new JSONObject(gridsJson).optJSONArray("data");
            if (grids == null || grids.length() == 0) return "";
            return grids.getJSONObject(0).optString("url", "");
        } catch (Exception e) { return ""; }
    }

    private static void deleteDir(java.io.File dir) {
        if (dir == null || !dir.exists()) return;
        java.io.File[] children = dir.listFiles();
        if (children != null) for (java.io.File c : children) deleteDir(c);
        dir.delete();
    }
}
