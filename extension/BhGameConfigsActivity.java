package app.revanced.extension.gamehub;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.view.ViewGroup;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * BhGameConfigsActivity — community game config browser.
 *
 * Side menu ID=13. Three-screen flow managed via LinearLayout visibility:
 *   Screen 1: All games (search + list + config count badge)
 *   Screen 2: Configs for selected game (filter + age indicator + verified badge)
 *   Screen 3: Config detail (meta, vote, share, report, download, comments)
 *
 * Backend: bannerhub-configs-worker.the412banner.workers.dev
 *   GET  /games             — list all game folders [{name,count}]
 *   GET  /list?game=X       — list configs for a game (includes votes)
 *   POST /vote              — upvote a config {sha, game, filename}
 *   POST /report            — report a config {sha}
 *   GET  /comments?game=X&file=Y — fetch comments
 *   POST /comment           — add a comment {game, filename, text, device}
 */
public class BhGameConfigsActivity extends Activity {

    // ── Constants ────────────────────────────────────────────────────────────
    private static final String WORKER     = "https://bannerhub-configs-worker.the412banner.workers.dev";
    private static final String VOTES_SP   = "bh_config_votes";
    private static final String COVERS_SP  = "bh_steam_covers";
    private static final String REPORTS_SP = "bh_config_reports";
    private static final String EXPORT_DIR = "BannerHub/configs";
    private static final String STEAM_SEARCH = "https://store.steampowered.com/api/storesearch/?l=english&cc=us&term=";
    private static final String STEAM_HEADER = "https://cdn.akamai.steamstatic.com/steam/apps/%s/header.jpg";

    // ── Colors ───────────────────────────────────────────────────────────────
    private static final int BG      = 0xFF0D0D0D;
    private static final int SURFACE = 0xFF1A1A1A;
    private static final int ACCENT  = 0xFF6C63FF;
    private static final int WHITE   = 0xFFFFFFFF;
    private static final int GREY    = 0xFFAAAAAA;
    private static final int DIVIDER = 0xFF2A2A2A;
    private static final int GREEN   = 0xFF2E7D32;
    private static final int AMBER   = 0xFFFFB300;
    private static final int GOLD    = 0xFFFFD700;

    // ── Views ────────────────────────────────────────────────────────────────
    private LinearLayout screenGames, screenConfigs, screenDetail;
    private TextView     headerTitle;
    private EditText     searchBox;
    private ListView     gamesListView, configsListView;
    private Button       filterToggleBtn;

    // Screen 3 dynamic views
    private LinearLayout commentsContainer;
    private TextView     votesLabel;
    private Button       voteBtn;
    private Button       refreshBtn;

    // ── State ────────────────────────────────────────────────────────────────
    private List<String>     allGames       = new ArrayList<>();
    private List<String>     filteredGames  = new ArrayList<>();
    private List<JSONObject> currentConfigs = new ArrayList<>();  // displayed (may be filtered)
    private List<JSONObject> allConfigs     = new ArrayList<>();  // unfiltered master list
    private Map<String,Integer> gameCounts  = new HashMap<>();
    private String     selectedGame;
    private JSONObject selectedConfig;
    private int        currentScreen = 1; // 1=games, 2=configs, 3=detail
    private boolean    filterByDevice = false;
    private String     currentSoc    = "";

    private final Map<String, Bitmap>     coverCache      = new HashMap<>();
    private final Map<String, JSONObject> configJsonCache = new HashMap<>();

    private Handler ui = new Handler(Looper.getMainLooper());

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Detect device SOC — Build.SOC_MODEL is API 31+
        try {
            if (android.os.Build.VERSION.SDK_INT >= 31) {
                currentSoc = (String) android.os.Build.class.getField("SOC_MODEL").get(null);
            }
        } catch (Exception ignored) {}
        if (currentSoc == null || currentSoc.isEmpty() || "unknown".equalsIgnoreCase(currentSoc)) {
            currentSoc = android.os.Build.HARDWARE;
        }

        FrameLayout root = new FrameLayout(this);
        root.setBackgroundColor(BG);

        LinearLayout wrapper = new LinearLayout(this);
        wrapper.setOrientation(LinearLayout.VERTICAL);
        wrapper.addView(buildHeader());

        View headerDivider = new View(this);
        headerDivider.setBackgroundColor(0xFF3A3A5C);
        wrapper.addView(headerDivider, new LinearLayout.LayoutParams(-1, dp(2)));

        FrameLayout body = new FrameLayout(this);
        screenGames   = buildGamesScreen();
        screenConfigs = buildConfigsScreen();
        screenDetail  = buildDetailScreen();

        body.addView(screenGames,   matchParams());
        body.addView(screenConfigs, matchParams());
        body.addView(screenDetail,  matchParams());

        wrapper.addView(body, new LinearLayout.LayoutParams(-1, 0, 1f));
        root.addView(wrapper, matchParams());
        setContentView(root);

        showScreen(1);
        fetchGames(false);
    }

    @Override
    public void onBackPressed() {
        if (currentScreen == 3) showScreen(2);
        else if (currentScreen == 2) showScreen(1);
        else finish();
    }

    // ── Header ────────────────────────────────────────────────────────────────

    private LinearLayout buildHeader() {
        LinearLayout h = new LinearLayout(this);
        h.setOrientation(LinearLayout.HORIZONTAL);
        h.setBackgroundColor(SURFACE);
        h.setGravity(Gravity.CENTER_VERTICAL);
        h.setPadding(dp(12), dp(10), dp(12), dp(10));

        GradientDrawable backBg = new GradientDrawable();
        backBg.setColor(0x00000000);
        backBg.setCornerRadius(dp(6));
        Button back = new Button(this);
        back.setText("←");
        back.setTextColor(WHITE);
        back.setBackground(backBg);
        back.setTextSize(18f);
        back.setPadding(dp(6), dp(4), dp(10), dp(4));
        back.setFocusable(true);
        back.setOnFocusChangeListener((v, f) -> {
            backBg.setColor(f ? 0xFF2A2A4E : 0x00000000);
            backBg.setStroke(f ? dp(2) : 0, f ? GOLD : 0x00000000);
        });
        back.setOnClickListener(v -> onBackPressed());

        headerTitle = new TextView(this);
        headerTitle.setText("Game Configs");
        headerTitle.setTextColor(WHITE);
        headerTitle.setTextSize(18f);
        headerTitle.setTypeface(null, Typeface.BOLD);
        LinearLayout.LayoutParams titleLp = new LinearLayout.LayoutParams(0, -2, 1f);
        titleLp.leftMargin = dp(4);
        headerTitle.setLayoutParams(titleLp);

        GradientDrawable refreshBg = new GradientDrawable();
        refreshBg.setColor(0xFF2A2A3A);
        refreshBg.setCornerRadius(dp(6));
        refreshBtn = new Button(this);
        refreshBtn.setText("↻");
        refreshBtn.setTextColor(WHITE);
        refreshBtn.setBackground(refreshBg);
        refreshBtn.setTextSize(20f);
        refreshBtn.setPadding(dp(10), dp(4), dp(10), dp(4));
        refreshBtn.setFocusable(true);
        refreshBtn.setOnFocusChangeListener((v, f) -> {
            refreshBg.setColor(f ? 0xFF3A3A6E : 0xFF2A2A3A);
            refreshBg.setStroke(f ? dp(2) : 0, f ? GOLD : 0x00000000);
        });
        refreshBtn.setOnClickListener(v -> {
            if (currentScreen == 1) fetchGames(true);
            else if (currentScreen == 2) fetchConfigs(selectedGame, true);
        });

        h.addView(back);
        h.addView(headerTitle);
        h.addView(refreshBtn);
        return h;
    }

    // ── Screen 1: Games ───────────────────────────────────────────────────────

    private LinearLayout buildGamesScreen() {
        LinearLayout s = new LinearLayout(this);
        s.setOrientation(LinearLayout.VERTICAL);
        s.setBackgroundColor(BG);

        searchBox = new EditText(this);
        searchBox.setHint("Search games...");
        searchBox.setHintTextColor(GREY);
        searchBox.setTextColor(WHITE);
        searchBox.setBackgroundColor(SURFACE);
        searchBox.setPadding(dp(16), dp(12), dp(16), dp(12));
        searchBox.setSingleLine(true);
        searchBox.addTextChangedListener(new TextWatcher() {
            public void beforeTextChanged(CharSequence s, int a, int b, int c) {}
            public void onTextChanged(CharSequence s, int a, int b, int c) { filterGames(s.toString()); }
            public void afterTextChanged(Editable s) {}
        });

        View searchDivider = new View(this);
        searchDivider.setBackgroundColor(DIVIDER);

        gamesListView = new ListView(this);
        gamesListView.setBackgroundColor(BG);
        gamesListView.setDivider(null);
        gamesListView.setDividerHeight(0);
        gamesListView.setPadding(0, dp(4), 0, dp(4));
        gamesListView.setSelector(new ColorDrawable(0));

        s.addView(searchBox, new LinearLayout.LayoutParams(-1, -2));
        s.addView(searchDivider, new LinearLayout.LayoutParams(-1, dp(1)));
        s.addView(gamesListView, new LinearLayout.LayoutParams(-1, 0, 1f));
        return s;
    }

    private void filterGames(String query) {
        filteredGames.clear();
        String q = query.trim().toLowerCase();
        for (String g : allGames) {
            if (q.isEmpty() || g.toLowerCase().contains(q)) filteredGames.add(g);
        }
        refreshGamesList();
    }

    private void refreshGamesList() {
        final List<String> snapshot = new ArrayList<>(filteredGames);
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
                android.R.layout.simple_list_item_1, snapshot) {
            @Override
            public View getView(int pos, View conv, android.view.ViewGroup parent) {
                GradientDrawable normalBg = new GradientDrawable();
                normalBg.setColor(SURFACE);
                normalBg.setCornerRadius(dp(8));

                GradientDrawable activeBg = new GradientDrawable();
                activeBg.setColor(0xFF22223A);
                activeBg.setCornerRadius(dp(8));
                activeBg.setStroke(dp(2), GOLD);

                StateListDrawable sld = new StateListDrawable();
                sld.addState(new int[]{android.R.attr.state_selected}, activeBg);
                sld.addState(new int[]{android.R.attr.state_pressed},  activeBg);
                sld.addState(new int[]{}, normalBg);

                LinearLayout row = new LinearLayout(getContext());
                row.setOrientation(LinearLayout.HORIZONTAL);
                row.setGravity(Gravity.CENTER_VERTICAL);
                row.setBackground(sld);
                row.setPadding(0, dp(4), dp(16), dp(4));
                row.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);

                LinearLayout.LayoutParams rowLp = new LinearLayout.LayoutParams(-1, -2);
                rowLp.setMargins(dp(8), dp(4), dp(8), dp(4));
                row.setLayoutParams(rowLp);

                // Cover art thumbnail
                ImageView cover = new ImageView(getContext());
                cover.setScaleType(ImageView.ScaleType.CENTER_CROP);
                GradientDrawable coverBg = new GradientDrawable();
                coverBg.setColor(0xFF111111);
                coverBg.setCornerRadius(dp(8));
                cover.setBackground(coverBg);
                LinearLayout.LayoutParams imgLp = new LinearLayout.LayoutParams(dp(160), dp(90));
                imgLp.rightMargin = dp(16);
                row.addView(cover, imgLp);

                String game = getItem(pos);

                // Right side: name + count badge
                LinearLayout textCol = new LinearLayout(getContext());
                textCol.setOrientation(LinearLayout.VERTICAL);
                textCol.setGravity(Gravity.CENTER_VERTICAL);
                textCol.setLayoutParams(new LinearLayout.LayoutParams(0, -2, 1f));

                TextView tv = new TextView(getContext());
                tv.setText(game.replace("_", " "));
                tv.setTextColor(WHITE);
                tv.setTextSize(15f);
                tv.setTypeface(null, Typeface.BOLD);
                textCol.addView(tv);

                // Config count badge
                Integer cnt = gameCounts.get(game);
                int count = cnt != null ? cnt : 0;
                if (count > 0) {
                    TextView badge = new TextView(getContext());
                    badge.setText(count + (count == 1 ? " config" : " configs"));
                    badge.setTextColor(ACCENT);
                    badge.setTextSize(11f);
                    LinearLayout.LayoutParams badgeLp = new LinearLayout.LayoutParams(-2, -2);
                    badgeLp.topMargin = dp(3);
                    textCol.addView(badge, badgeLp);
                }

                row.addView(textCol);

                cover.setTag(game);
                loadCover(game, cover);
                return row;
            }
        };
        gamesListView.setAdapter(adapter);
        gamesListView.setOnItemClickListener((parent, view, pos, id) -> {
            selectedGame = snapshot.get(pos);
            filterByDevice = false;
            showScreen(2);
            fetchConfigs(selectedGame, false);
        });
    }

    // ── Cover art loading ─────────────────────────────────────────────────────

    private void loadCover(String game, ImageView iv) {
        Bitmap cached = coverCache.get(game);
        if (cached != null) { iv.setImageBitmap(cached); return; }
        iv.setImageBitmap(null);
        new Thread(() -> {
            try {
                SharedPreferences sp = getSharedPreferences(COVERS_SP, 0);
                String appId = sp.getString("appid:" + game, null);
                if (appId == null) {
                    String query = game.replace("_", " ");
                    HttpURLConnection conn = openGet(STEAM_SEARCH + urlEncode(query));
                    conn.setRequestProperty("User-Agent", "BannerHub/1.0");
                    String body = readResponse(conn);
                    JSONObject json = new JSONObject(body);
                    JSONArray items = json.optJSONArray("items");
                    if (items != null && items.length() > 0) {
                        appId = String.valueOf(items.getJSONObject(0).getInt("id"));
                        sp.edit().putString("appid:" + game, appId).apply();
                    }
                }
                if (appId == null) return;
                String imgUrl = String.format(STEAM_HEADER, appId);
                HttpURLConnection imgConn = openGet(imgUrl);
                imgConn.setRequestProperty("User-Agent", "BannerHub/1.0");
                InputStream in = imgConn.getInputStream();
                Bitmap bmp = BitmapFactory.decodeStream(in);
                in.close();
                if (bmp != null) {
                    coverCache.put(game, bmp);
                    ui.post(() -> { if (game.equals(iv.getTag())) iv.setImageBitmap(bmp); });
                }
            } catch (Exception ignored) {}
        }).start();
    }

    // ── Screen 2: Configs ─────────────────────────────────────────────────────

    private LinearLayout buildConfigsScreen() {
        LinearLayout s = new LinearLayout(this);
        s.setOrientation(LinearLayout.VERTICAL);
        s.setBackgroundColor(BG);

        // Filter toggle bar
        LinearLayout filterBar = new LinearLayout(this);
        filterBar.setOrientation(LinearLayout.HORIZONTAL);
        filterBar.setGravity(Gravity.CENTER_VERTICAL);
        filterBar.setPadding(dp(12), dp(8), dp(12), dp(8));
        filterBar.setBackgroundColor(SURFACE);

        TextView filterLabel = new TextView(this);
        filterLabel.setText("Filter:");
        filterLabel.setTextColor(GREY);
        filterLabel.setTextSize(12f);
        LinearLayout.LayoutParams flLp = new LinearLayout.LayoutParams(-2, -2);
        flLp.rightMargin = dp(8);
        filterBar.addView(filterLabel, flLp);

        GradientDrawable filterBg = new GradientDrawable();
        filterBg.setColor(0xFF2A2A3A);
        filterBg.setCornerRadius(dp(6));
        filterBg.setStroke(dp(1), 0xFF444466);
        filterToggleBtn = new Button(this);
        filterToggleBtn.setText("My Device");
        filterToggleBtn.setTextColor(WHITE);
        filterToggleBtn.setBackground(filterBg);
        filterToggleBtn.setTextSize(12f);
        filterToggleBtn.setPadding(dp(10), dp(4), dp(10), dp(4));
        filterToggleBtn.setFocusable(true);
        filterToggleBtn.setOnFocusChangeListener((v, f) -> {
            filterBg.setStroke(f ? dp(2) : dp(1), f ? GOLD : (filterByDevice ? ACCENT : 0xFF444466));
        });
        filterToggleBtn.setOnClickListener(v -> {
            filterByDevice = !filterByDevice;
            updateFilterToggle();
            applyDeviceFilter();
        });
        filterBar.addView(filterToggleBtn);

        View filterDivider = new View(this);
        filterDivider.setBackgroundColor(DIVIDER);

        configsListView = new ListView(this);
        configsListView.setBackgroundColor(BG);
        configsListView.setDivider(null);
        configsListView.setSelector(new ColorDrawable(0));

        s.addView(filterBar, new LinearLayout.LayoutParams(-1, -2));
        s.addView(filterDivider, new LinearLayout.LayoutParams(-1, dp(1)));
        s.addView(configsListView, new LinearLayout.LayoutParams(-1, 0, 1f));
        return s;
    }

    private void updateFilterToggle() {
        GradientDrawable d = (GradientDrawable) filterToggleBtn.getBackground();
        if (filterByDevice) {
            d.setColor(0xFF1A2A1A);
            d.setStroke(dp(2), 0xFF4CAF50);
            filterToggleBtn.setTextColor(0xFF4CAF50);
        } else {
            d.setColor(0xFF2A2A3A);
            d.setStroke(dp(1), 0xFF444466);
            filterToggleBtn.setTextColor(WHITE);
        }
    }

    private void applyDeviceFilter() {
        currentConfigs.clear();
        if (filterByDevice && !currentSoc.isEmpty()) {
            for (JSONObject c : allConfigs) {
                if (isSOCMatch(c.optString("soc", ""))) currentConfigs.add(c);
            }
            if (currentConfigs.isEmpty()) {
                Toast.makeText(this, "No configs match your SOC (" + currentSoc + ")", Toast.LENGTH_SHORT).show();
            }
        } else {
            currentConfigs.addAll(allConfigs);
        }
        refreshConfigsList();
    }

    private void refreshConfigsList() {
        final long nowSec        = System.currentTimeMillis() / 1000L;
        final long sixMonthsSec  = 15552000L; // 180 days

        ArrayAdapter<JSONObject> adapter = new ArrayAdapter<JSONObject>(this,
                android.R.layout.simple_list_item_1, currentConfigs) {
            @Override
            public View getView(int pos, View conv, android.view.ViewGroup parent) {
                GradientDrawable normalBg = new GradientDrawable();
                normalBg.setColor(SURFACE);
                normalBg.setCornerRadius(dp(8));

                GradientDrawable activeBg = new GradientDrawable();
                activeBg.setColor(0xFF22223A);
                activeBg.setCornerRadius(dp(8));
                activeBg.setStroke(dp(2), GOLD);

                StateListDrawable sld = new StateListDrawable();
                sld.addState(new int[]{android.R.attr.state_selected}, activeBg);
                sld.addState(new int[]{android.R.attr.state_pressed},  activeBg);
                sld.addState(new int[]{}, normalBg);

                LinearLayout row = new LinearLayout(getContext());
                row.setOrientation(LinearLayout.VERTICAL);
                row.setPadding(dp(16), dp(12), dp(16), dp(12));
                row.setBackground(sld);
                row.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);

                LinearLayout.LayoutParams rowLp = new LinearLayout.LayoutParams(-1, -2);
                rowLp.setMargins(dp(8), dp(4), dp(8), dp(4));
                row.setLayoutParams(rowLp);

                JSONObject c = getItem(pos);
                String device = c.optString("device", "Unknown").replace("_", " ");
                String soc    = c.optString("soc", "");
                int    votes  = c.optInt("votes", 0);
                String date   = c.optString("date", "");
                long   ts     = c.optLong("timestamp", 0);

                // Title row: device + soc + verified badge
                LinearLayout titleRow = new LinearLayout(getContext());
                titleRow.setOrientation(LinearLayout.HORIZONTAL);
                titleRow.setGravity(Gravity.CENTER_VERTICAL);

                TextView titleTv = new TextView(getContext());
                titleTv.setText(device);
                titleTv.setTextColor(WHITE);
                titleTv.setTextSize(14f);
                titleTv.setTypeface(null, Typeface.BOLD);
                titleRow.addView(titleTv);

                if (!soc.isEmpty()) {
                    TextView socTv = new TextView(getContext());
                    socTv.setText(" [" + soc.replace("_", " ") + "]");
                    socTv.setTextColor(GREY);
                    socTv.setTextSize(12f);
                    titleRow.addView(socTv);
                }

                if (isSOCMatch(soc)) {
                    TextView verBadge = new TextView(getContext());
                    verBadge.setText("  ✓ My SOC");
                    verBadge.setTextColor(0xFF4CAF50);
                    verBadge.setTextSize(11f);
                    verBadge.setTypeface(null, Typeface.BOLD);
                    titleRow.addView(verBadge);
                }
                row.addView(titleRow);

                // Sub row: date + votes + age indicator
                LinearLayout subRow = new LinearLayout(getContext());
                subRow.setOrientation(LinearLayout.HORIZONTAL);
                subRow.setGravity(Gravity.CENTER_VERTICAL);
                LinearLayout.LayoutParams subLp = new LinearLayout.LayoutParams(-1, -2);
                subLp.topMargin = dp(3);

                TextView sub = new TextView(getContext());
                sub.setText(date + "  ★ " + votes);
                sub.setTextColor(GREY);
                sub.setTextSize(12f);
                subRow.addView(sub);

                if (ts > 0 && (nowSec - ts) > sixMonthsSec) {
                    TextView ageTv = new TextView(getContext());
                    ageTv.setText("  (may be outdated)");
                    ageTv.setTextColor(AMBER);
                    ageTv.setTextSize(11f);
                    subRow.addView(ageTv);
                }
                row.addView(subRow, subLp);
                return row;
            }
        };
        configsListView.setAdapter(adapter);
        configsListView.setOnItemClickListener((parent, view, pos, id) -> {
            selectedConfig = currentConfigs.get(pos);
            populateDetailScreen(selectedConfig);
            showScreen(3);
        });
    }

    /** Returns true if configSoc matches this device's currentSoc (case+separator insensitive). */
    private boolean isSOCMatch(String configSoc) {
        if (currentSoc == null || currentSoc.isEmpty()) return false;
        if (configSoc == null || configSoc.isEmpty()) return false;
        String a = currentSoc.toLowerCase().replace("_", "").replace("-", "");
        String b = configSoc.toLowerCase().replace("_", "").replace("-", "");
        return a.equals(b) || a.contains(b) || b.contains(a);
    }

    // ── Screen 3: Detail ──────────────────────────────────────────────────────

    private LinearLayout buildDetailScreen() {
        LinearLayout s = new LinearLayout(this);
        s.setOrientation(LinearLayout.VERTICAL);
        s.setBackgroundColor(BG);

        ScrollView scroll = new ScrollView(this);
        LinearLayout content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(dp(20), dp(16), dp(20), dp(24));
        content.setTag("detail_content");

        scroll.addView(content, matchParams());
        s.addView(scroll, matchLinearParams());
        return s;
    }

    private void populateDetailScreen(JSONObject config) {
        ScrollView scroll = (ScrollView) screenDetail.getChildAt(0);
        LinearLayout content = (LinearLayout) scroll.getChildAt(0);
        content.removeAllViews();

        String filename = config.optString("filename", "config.json");
        String device   = config.optString("device", "Unknown").replace("_", " ");
        String soc      = config.optString("soc", "");
        String date     = config.optString("date", "");
        String sha      = config.optString("sha", "");
        String game     = config.optString("game_folder", selectedGame);
        int    votes    = config.optInt("votes", 0);

        headerTitle.setText(filename.length() > 30 ? filename.substring(0, 28) + "…" : filename);

        // Device info card
        LinearLayout card = surface();
        card.setPadding(dp(16), dp(14), dp(16), dp(14));
        addInfoRow(card, "Device",  device);
        if (!soc.isEmpty())  addInfoRow(card, "SOC", soc.replace("_", " "));
        if (!date.isEmpty()) addInfoRow(card, "Date", date);

        // Verified SOC badge inside info card
        if (isSOCMatch(soc)) {
            GradientDrawable verBg = new GradientDrawable();
            verBg.setColor(0xFF1A2A1A);
            verBg.setCornerRadius(dp(4));
            verBg.setStroke(dp(1), 0xFF4CAF50);
            TextView verBadge = new TextView(this);
            verBadge.setText("✓ Matches Your SOC (" + currentSoc + ")");
            verBadge.setTextColor(0xFF4CAF50);
            verBadge.setTextSize(12f);
            verBadge.setTypeface(null, Typeface.BOLD);
            verBadge.setBackground(verBg);
            verBadge.setPadding(dp(8), dp(4), dp(8), dp(4));
            LinearLayout.LayoutParams vrp = new LinearLayout.LayoutParams(-2, -2);
            vrp.topMargin = dp(6);
            card.addView(verBadge, vrp);
        }
        content.addView(card, marginParams(0, 0, 0, dp(12)));

        // Meta card
        LinearLayout metaCard = surface();
        metaCard.setPadding(dp(16), dp(14), dp(16), dp(14));
        metaCard.setTag("meta_card");
        content.addView(metaCard, marginParams(0, 0, 0, dp(12)));
        fetchMeta(config, metaCard);

        // Vote row
        LinearLayout voteRow = new LinearLayout(this);
        voteRow.setOrientation(LinearLayout.HORIZONTAL);
        voteRow.setGravity(Gravity.CENTER_VERTICAL);

        votesLabel = new TextView(this);
        votesLabel.setText("★ " + votes + " votes");
        votesLabel.setTextColor(GOLD);
        votesLabel.setTextSize(16f);
        votesLabel.setTypeface(null, Typeface.BOLD);
        voteRow.addView(votesLabel, new LinearLayout.LayoutParams(0, -2, 1f));

        boolean alreadyVoted = getSharedPreferences(VOTES_SP, 0).contains(sha);
        voteBtn = actionBtn(alreadyVoted ? "Voted ✓" : "Upvote ↑",
                alreadyVoted ? SURFACE : ACCENT,
                alreadyVoted ? null : v -> doVote(config));
        voteBtn.setEnabled(!alreadyVoted);
        voteRow.addView(voteBtn);
        content.addView(voteRow, marginParams(0, 0, 0, dp(12)));

        // Download
        content.addView(
            actionBtn("Download to Device", GREEN, v -> downloadConfig(config)),
            marginParams(0, 0, 0, dp(8)));

        // View contents
        Button contentsBtn = actionBtn("View Settings & Components", 0xFF37474F, null);
        contentsBtn.setOnClickListener(v -> {
            JSONObject cached = configJsonCache.get(filename);
            if (cached != null) {
                showConfigContents(cached, filename);
            } else {
                contentsBtn.setEnabled(false);
                contentsBtn.setText("Loading...");
                new Thread(() -> {
                    try {
                        HttpURLConnection c2 = openGet(WORKER + "/download?game="
                                + urlEncode(game) + "&file=" + urlEncode(filename));
                        JSONObject json = new JSONObject(readResponse(c2));
                        configJsonCache.put(filename, json);
                        ui.post(() -> {
                            contentsBtn.setEnabled(true);
                            contentsBtn.setText("View Settings & Components");
                            showConfigContents(json, filename);
                        });
                    } catch (Exception e) {
                        ui.post(() -> {
                            contentsBtn.setEnabled(true);
                            contentsBtn.setText("View Settings & Components");
                            Toast.makeText(this, "Failed: " + e.getMessage(), Toast.LENGTH_SHORT).show();
                        });
                    }
                }).start();
            }
        });
        content.addView(contentsBtn, marginParams(0, 0, 0, dp(8)));

        // Share — copy raw GitHub URL to clipboard
        String rawUrl = "https://raw.githubusercontent.com/The412Banner/bannerhub-game-configs/main/configs/"
                + urlEncode(game) + "/" + urlEncode(filename);
        content.addView(
            actionBtn("Share Config URL", 0xFF1565C0, v -> {
                ClipboardManager cm = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                cm.setPrimaryClip(ClipData.newPlainText("BannerHub Config", rawUrl));
                Toast.makeText(this, "URL copied to clipboard", Toast.LENGTH_SHORT).show();
            }),
            marginParams(0, 0, 0, dp(8)));

        // Report
        boolean alreadyReported = getSharedPreferences(REPORTS_SP, 0).contains(sha);
        Button reportBtn = actionBtn(alreadyReported ? "Reported ✓" : "Report Config",
                0xFF4A1010, null);
        reportBtn.setEnabled(!alreadyReported);
        if (!alreadyReported) reportBtn.setOnClickListener(v -> doReport(config, reportBtn));
        content.addView(reportBtn, marginParams(0, 0, 0, dp(8)));

        TextView applyNote = new TextView(this);
        applyNote.setText("After downloading, use Import Config from a game's settings to apply.");
        applyNote.setTextColor(GREY);
        applyNote.setTextSize(12f);
        content.addView(applyNote, marginParams(0, 0, 0, dp(16)));

        // Divider
        View div = new View(this);
        div.setBackgroundColor(DIVIDER);
        content.addView(div, marginParams(0, 0, 0, dp(16), -1, 1));

        // Comments header
        TextView commentsHeader = new TextView(this);
        commentsHeader.setText("Comments");
        commentsHeader.setTextColor(WHITE);
        commentsHeader.setTextSize(16f);
        commentsHeader.setTypeface(null, Typeface.BOLD);
        content.addView(commentsHeader, marginParams(0, 0, 0, dp(10)));

        commentsContainer = new LinearLayout(this);
        commentsContainer.setOrientation(LinearLayout.VERTICAL);
        content.addView(commentsContainer, matchLinearParams());

        // Comment input
        LinearLayout commentInput = new LinearLayout(this);
        commentInput.setOrientation(LinearLayout.VERTICAL);
        LinearLayout.LayoutParams ciLp = new LinearLayout.LayoutParams(-1, -2);
        ciLp.topMargin = dp(12);

        EditText commentBox = new EditText(this);
        commentBox.setHint("Add a comment...");
        commentBox.setHintTextColor(GREY);
        commentBox.setTextColor(WHITE);
        commentBox.setBackgroundColor(SURFACE);
        commentBox.setPadding(dp(12), dp(10), dp(12), dp(10));
        commentBox.setMinLines(2);
        commentInput.addView(commentBox, matchLinearParams());

        Button submitBtn = actionBtn("Post Comment", ACCENT, v -> {
            String text = commentBox.getText().toString().trim();
            if (!text.isEmpty()) postComment(config, text, commentBox);
        });
        LinearLayout.LayoutParams sbLp = new LinearLayout.LayoutParams(-1, -2);
        sbLp.topMargin = dp(6);
        commentInput.addView(submitBtn, sbLp);
        content.addView(commentInput, ciLp);

        fetchComments(config);
    }

    /**
     * Creates a D-pad-focusable action button with GradientDrawable background.
     * Gold outline + darker bg on focus/press. Pass null listener to attach later.
     */
    private Button actionBtn(String label, int bgColor, View.OnClickListener listener) {
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(bgColor);
        bg.setCornerRadius(dp(6));
        Button btn = new Button(this);
        btn.setText(label);
        btn.setTextColor(WHITE);
        btn.setBackground(bg);
        btn.setFocusable(true);
        btn.setOnFocusChangeListener((v, f) -> {
            bg.setColor(f ? blendDark(bgColor) : bgColor);
            bg.setStroke(f ? dp(2) : 0, f ? GOLD : 0x00000000);
        });
        if (listener != null) btn.setOnClickListener(listener);
        return btn;
    }

    private void setActionBtnColor(Button btn, int color) {
        if (btn.getBackground() instanceof GradientDrawable) {
            ((GradientDrawable) btn.getBackground()).setColor(color);
        } else {
            btn.setBackgroundColor(color);
        }
    }

    /** Darkens a color by ~30% for focus state. */
    private int blendDark(int c) {
        int r = (int) ((c >> 16 & 0xFF) * 0.7f);
        int g = (int) ((c >>  8 & 0xFF) * 0.7f);
        int b = (int) ((c       & 0xFF) * 0.7f);
        return 0xFF000000 | (r << 16) | (g << 8) | b;
    }

    private void addInfoRow(LinearLayout parent, String label, String value) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams rp = new LinearLayout.LayoutParams(-1, -2);
        rp.bottomMargin = dp(4);

        TextView lbl = new TextView(this);
        lbl.setText(label + ": ");
        lbl.setTextColor(GREY);
        lbl.setTextSize(13f);
        lbl.setMinWidth(dp(80));

        TextView val = new TextView(this);
        val.setText(value);
        val.setTextColor(WHITE);
        val.setTextSize(13f);

        row.addView(lbl);
        row.addView(val);
        parent.addView(row, rp);
    }

    // ── Network: Games ────────────────────────────────────────────────────────

    private void fetchGames(boolean refresh) {
        headerTitle.setText("Game Configs");
        if (refreshBtn != null) refreshBtn.setEnabled(false);
        new Thread(() -> {
            try {
                String url = WORKER + "/games" + (refresh ? "?refresh=1" : "");
                HttpURLConnection conn = openGet(url);
                String body = readResponse(conn);
                JSONArray arr = new JSONArray(body);
                List<String> games = new ArrayList<>();
                Map<String,Integer> counts = new HashMap<>();
                for (int i = 0; i < arr.length(); i++) {
                    // Worker returns [{name,count}]; handle legacy [string] gracefully
                    Object item = arr.get(i);
                    if (item instanceof JSONObject) {
                        JSONObject obj = (JSONObject) item;
                        String name = obj.optString("name", "");
                        if (!name.isEmpty()) {
                            games.add(name);
                            counts.put(name, obj.optInt("count", 0));
                        }
                    } else {
                        games.add(String.valueOf(item));
                    }
                }
                ui.post(() -> {
                    allGames.clear(); allGames.addAll(games);
                    filteredGames.clear(); filteredGames.addAll(games);
                    gameCounts.clear(); gameCounts.putAll(counts);
                    refreshGamesList();
                    if (refreshBtn != null) refreshBtn.setEnabled(true);
                    if (games.isEmpty())
                        Toast.makeText(this, "No community configs yet", Toast.LENGTH_SHORT).show();
                });
            } catch (Exception e) {
                ui.post(() -> {
                    if (refreshBtn != null) refreshBtn.setEnabled(true);
                    Toast.makeText(this, "Error loading games: " + e.getMessage(), Toast.LENGTH_LONG).show();
                });
            }
        }).start();
    }

    // ── Network: Configs ──────────────────────────────────────────────────────

    private void fetchConfigs(String game, boolean refresh) {
        String displayName = game.replace("_", " ");
        headerTitle.setText(displayName);
        if (refreshBtn != null) refreshBtn.setEnabled(false);
        allConfigs.clear(); currentConfigs.clear();
        refreshConfigsList();
        new Thread(() -> {
            try {
                String url = WORKER + "/list?game=" + urlEncode(game) + (refresh ? "&refresh=1" : "");
                HttpURLConnection conn = openGet(url);
                String body = readResponse(conn);
                JSONArray arr = new JSONArray(body);
                List<JSONObject> configs = new ArrayList<>();
                for (int i = 0; i < arr.length(); i++) configs.add(arr.getJSONObject(i));
                ui.post(() -> {
                    allConfigs.clear(); allConfigs.addAll(configs);
                    filterByDevice = false;
                    updateFilterToggle();
                    currentConfigs.clear(); currentConfigs.addAll(configs);
                    refreshConfigsList();
                    if (refreshBtn != null) refreshBtn.setEnabled(true);
                    if (configs.isEmpty())
                        Toast.makeText(this, "No configs for " + displayName, Toast.LENGTH_SHORT).show();
                });
            } catch (Exception e) {
                ui.post(() -> {
                    if (refreshBtn != null) refreshBtn.setEnabled(true);
                    Toast.makeText(this, "Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
                });
            }
        }).start();
    }

    // ── Network: Meta ─────────────────────────────────────────────────────────

    private void fetchMeta(JSONObject config, LinearLayout metaCard) {
        String game     = config.optString("game_folder", selectedGame);
        String filename = config.optString("filename", "");
        new Thread(() -> {
            try {
                HttpURLConnection conn = openGet(WORKER + "/download?game="
                        + urlEncode(game) + "&file=" + urlEncode(filename));
                String body = readResponse(conn);
                JSONObject json = new JSONObject(body);
                configJsonCache.put(filename, json);
                JSONObject meta = json.optJSONObject("meta");
                int sc = json.has("settings") ? json.getJSONObject("settings").length() : 0;
                int cc = json.has("components") ? json.getJSONArray("components").length() : 0;
                ui.post(() -> {
                    metaCard.removeAllViews();
                    metaCard.setPadding(dp(16), dp(14), dp(16), dp(14));
                    if (meta != null) {
                        String renderer = meta.optString("renderer", "");
                        String cpu      = meta.optString("cpu", "");
                        String fps      = meta.optString("fps", "");
                        String bhVer    = meta.optString("bh_version", "");
                        if (!renderer.isEmpty()) addInfoRow(metaCard, "Renderer", renderer);
                        if (!cpu.isEmpty())      addInfoRow(metaCard, "CPU", cpu);
                        if (!fps.isEmpty())      addInfoRow(metaCard, "FPS Cap", fps);
                        if (!bhVer.isEmpty())    addInfoRow(metaCard, "BH Version", bhVer);
                    }
                    addInfoRow(metaCard, "Settings", sc + " keys");
                    addInfoRow(metaCard, "Components", cc + " bundled");
                });
            } catch (Exception e) {
                ui.post(() -> {
                    metaCard.removeAllViews();
                    TextView err = new TextView(this);
                    err.setText("(could not load details)");
                    err.setTextColor(GREY);
                    err.setTextSize(12f);
                    metaCard.addView(err);
                });
            }
        }).start();
    }

    // ── Config contents dialog ────────────────────────────────────────────────

    private void showConfigContents(JSONObject json, String filename) {
        ScrollView scroll = new ScrollView(this);
        LinearLayout body = new LinearLayout(this);
        body.setOrientation(LinearLayout.VERTICAL);
        body.setPadding(dp(4), dp(8), dp(4), dp(8));
        scroll.addView(body);

        JSONArray components = json.optJSONArray("components");
        if (components != null && components.length() > 0) {
            body.addView(sectionHeader("Components (" + components.length() + ")"));
            for (int i = 0; i < components.length(); i++) {
                JSONObject c = components.optJSONObject(i);
                if (c == null) continue;
                String name = c.optString("name", "");
                String type = c.optString("type", "");
                String url  = c.optString("url",  "");
                LinearLayout row = new LinearLayout(this);
                row.setOrientation(LinearLayout.VERTICAL);
                row.setPadding(dp(8), dp(6), dp(8), dp(6));
                row.setBackgroundColor(SURFACE);
                LinearLayout.LayoutParams rp = new LinearLayout.LayoutParams(-1, -2);
                rp.setMargins(0, 0, 0, dp(4));
                TextView nameTv = new TextView(this);
                nameTv.setText(name.isEmpty() ? "(unnamed)" : name);
                nameTv.setTextColor(WHITE); nameTv.setTextSize(13f);
                nameTv.setTypeface(null, Typeface.BOLD);
                row.addView(nameTv);
                if (!type.isEmpty()) {
                    TextView typeTv = new TextView(this);
                    typeTv.setText("Type: " + type);
                    typeTv.setTextColor(GREY); typeTv.setTextSize(12f);
                    row.addView(typeTv);
                }
                if (!url.isEmpty()) {
                    String urlShort = url.contains("/") ? url.substring(url.lastIndexOf('/') + 1) : url;
                    TextView urlTv = new TextView(this);
                    urlTv.setText(urlShort);
                    urlTv.setTextColor(0xFF7B8CFF); urlTv.setTextSize(11f);
                    row.addView(urlTv);
                }
                body.addView(row, rp);
            }
        } else {
            body.addView(sectionHeader("Components (none bundled)"));
        }

        JSONObject settings = json.optJSONObject("settings");
        if (settings == null) {
            settings = new JSONObject();
            try {
                Iterator<String> it = json.keys();
                while (it.hasNext()) {
                    String k = it.next();
                    if (!k.equals("meta") && !k.equals("components")) settings.put(k, json.get(k));
                }
            } catch (Exception ignored) {}
        }

        body.addView(sectionHeader("Settings (" + settings.length() + " keys)"));
        if (settings.length() == 0) {
            TextView empty = new TextView(this);
            empty.setText("(no settings)"); empty.setTextColor(GREY); empty.setTextSize(12f);
            empty.setPadding(dp(8), dp(4), dp(8), dp(4));
            body.addView(empty);
        } else {
            List<String> keys = new ArrayList<>();
            Iterator<String> it = settings.keys();
            while (it.hasNext()) keys.add(it.next());
            Collections.sort(keys);
            final JSONObject finalSettings = settings;
            for (String key : keys) {
                String value;
                try { value = String.valueOf(finalSettings.get(key)); }
                catch (Exception e) { value = "?"; }
                LinearLayout row = new LinearLayout(this);
                row.setOrientation(LinearLayout.HORIZONTAL);
                row.setPadding(dp(8), dp(5), dp(8), dp(5));
                LinearLayout.LayoutParams rp = new LinearLayout.LayoutParams(-1, -2);
                rp.setMargins(0, 0, 0, dp(1));
                row.setBackgroundColor(SURFACE);
                TextView keyTv = new TextView(this);
                keyTv.setText(key); keyTv.setTextColor(GREY); keyTv.setTextSize(12f);
                keyTv.setLayoutParams(new LinearLayout.LayoutParams(0, -2, 1f));
                keyTv.setSingleLine(false);
                TextView valTv = new TextView(this);
                valTv.setText(value); valTv.setTextColor(WHITE); valTv.setTextSize(12f);
                valTv.setMaxWidth(dp(160)); valTv.setSingleLine(true);
                valTv.setEllipsize(android.text.TextUtils.TruncateAt.END);
                row.addView(keyTv); row.addView(valTv);
                body.addView(row, rp);
            }
        }

        int maxH = (int) (getResources().getDisplayMetrics().heightPixels * 0.7f);
        scroll.setLayoutParams(new android.widget.FrameLayout.LayoutParams(-1, maxH));
        new AlertDialog.Builder(this)
                .setTitle(filename.length() > 35 ? filename.substring(0, 33) + "…" : filename)
                .setView(scroll).setPositiveButton("Close", null).show();
    }

    private TextView sectionHeader(String text) {
        TextView tv = new TextView(this);
        tv.setText(text); tv.setTextColor(ACCENT); tv.setTextSize(13f);
        tv.setTypeface(null, Typeface.BOLD);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, -2);
        lp.setMargins(dp(4), dp(12), dp(4), dp(6));
        tv.setLayoutParams(lp);
        return tv;
    }

    // ── Network: Vote ─────────────────────────────────────────────────────────

    private void doVote(JSONObject config) {
        String sha = config.optString("sha", "");
        String game = config.optString("game_folder", selectedGame);
        String filename = config.optString("filename", "");
        voteBtn.setEnabled(false); voteBtn.setText("Voting...");
        new Thread(() -> {
            try {
                JSONObject body = new JSONObject();
                body.put("sha", sha); body.put("game", game); body.put("filename", filename);
                HttpURLConnection conn = openPost(WORKER + "/vote", body.toString());
                JSONObject r = new JSONObject(readResponse(conn));
                int newCount = r.optInt("votes", config.optInt("votes", 0) + 1);
                getSharedPreferences(VOTES_SP, 0).edit().putBoolean(sha, true).apply();
                config.put("votes", newCount);
                ui.post(() -> {
                    votesLabel.setText("★ " + newCount + " votes");
                    voteBtn.setText("Voted ✓");
                    setActionBtnColor(voteBtn, SURFACE);
                    refreshConfigsList();
                });
            } catch (Exception e) {
                ui.post(() -> {
                    voteBtn.setEnabled(true); voteBtn.setText("Upvote ↑");
                    Toast.makeText(this, "Vote failed: " + e.getMessage(), Toast.LENGTH_SHORT).show();
                });
            }
        }).start();
    }

    // ── Network: Report ───────────────────────────────────────────────────────

    private void doReport(JSONObject config, Button reportBtn) {
        String sha = config.optString("sha", "");
        reportBtn.setEnabled(false); reportBtn.setText("Reporting...");
        new Thread(() -> {
            try {
                JSONObject body = new JSONObject();
                body.put("sha", sha);
                HttpURLConnection conn = openPost(WORKER + "/report", body.toString());
                JSONObject r = new JSONObject(readResponse(conn));
                if (r.optBoolean("success", false) || r.has("reports")) {
                    getSharedPreferences(REPORTS_SP, 0).edit().putBoolean(sha, true).apply();
                    ui.post(() -> {
                        reportBtn.setText("Reported ✓");
                        Toast.makeText(this, "Config reported. Thank you.", Toast.LENGTH_SHORT).show();
                    });
                } else {
                    throw new Exception(r.optString("error", "Unknown error"));
                }
            } catch (Exception e) {
                ui.post(() -> {
                    reportBtn.setEnabled(true); reportBtn.setText("Report Config");
                    Toast.makeText(this, "Report failed: " + e.getMessage(), Toast.LENGTH_SHORT).show();
                });
            }
        }).start();
    }

    // ── Network: Download ─────────────────────────────────────────────────────

    private void downloadConfig(JSONObject config) {
        String game     = config.optString("game_folder", selectedGame);
        String filename = config.optString("filename", "config.json");
        Toast.makeText(this, "Downloading...", Toast.LENGTH_SHORT).show();
        new Thread(() -> {
            try {
                HttpURLConnection conn = openGet(WORKER + "/download?game="
                        + urlEncode(game) + "&file=" + urlEncode(filename));
                InputStream in = conn.getInputStream();
                File dir = new File(android.os.Environment.getExternalStorageDirectory(), EXPORT_DIR);
                dir.mkdirs();
                FileOutputStream fos = new FileOutputStream(new File(dir, filename));
                byte[] buf = new byte[8192]; int n;
                while ((n = in.read(buf)) != -1) fos.write(buf, 0, n);
                in.close(); fos.close();
                ui.post(() -> Toast.makeText(this,
                        "Saved to BannerHub/configs/\nUse Import Config in-game to apply.",
                        Toast.LENGTH_LONG).show());
            } catch (Exception e) {
                ui.post(() -> Toast.makeText(this, "Download failed: " + e.getMessage(), Toast.LENGTH_LONG).show());
            }
        }).start();
    }

    // ── Network: Comments ─────────────────────────────────────────────────────

    private void fetchComments(JSONObject config) {
        String game     = config.optString("game_folder", selectedGame);
        String filename = config.optString("filename", "");
        new Thread(() -> {
            try {
                HttpURLConnection conn = openGet(WORKER + "/comments?game="
                        + urlEncode(game) + "&file=" + urlEncode(filename));
                JSONArray arr = new JSONArray(readResponse(conn));
                ui.post(() -> renderComments(arr));
            } catch (Exception e) {
                ui.post(() -> {
                    if (commentsContainer != null) {
                        TextView err = new TextView(this);
                        err.setText("Could not load comments"); err.setTextColor(GREY); err.setTextSize(12f);
                        commentsContainer.addView(err);
                    }
                });
            }
        }).start();
    }

    private void renderComments(JSONArray arr) {
        if (commentsContainer == null) return;
        commentsContainer.removeAllViews();
        if (arr.length() == 0) {
            TextView empty = new TextView(this);
            empty.setText("No comments yet — be the first!"); empty.setTextColor(GREY); empty.setTextSize(13f);
            LinearLayout.LayoutParams ep = new LinearLayout.LayoutParams(-1, -2);
            ep.bottomMargin = dp(8);
            commentsContainer.addView(empty, ep);
            return;
        }
        for (int i = 0; i < arr.length(); i++) {
            JSONObject c = arr.optJSONObject(i);
            if (c == null) continue;
            LinearLayout bubble = surface();
            bubble.setPadding(dp(12), dp(10), dp(12), dp(10));
            LinearLayout.LayoutParams bp = new LinearLayout.LayoutParams(-1, -2);
            bp.bottomMargin = dp(8);
            TextView meta = new TextView(this);
            meta.setText(c.optString("device", "Anonymous").replace("_", " ")
                    + (c.optString("date", "").isEmpty() ? "" : "  " + c.optString("date", "")));
            meta.setTextColor(GREY); meta.setTextSize(11f);
            TextView body = new TextView(this);
            body.setText(c.optString("text", "")); body.setTextColor(WHITE); body.setTextSize(13f);
            LinearLayout.LayoutParams tp = new LinearLayout.LayoutParams(-1, -2);
            tp.topMargin = dp(4);
            bubble.addView(meta); bubble.addView(body, tp);
            commentsContainer.addView(bubble, bp);
        }
    }

    private void postComment(JSONObject config, String text, EditText commentBox) {
        String game     = config.optString("game_folder", selectedGame);
        String filename = config.optString("filename", "");
        String device   = android.os.Build.MANUFACTURER + "_" + android.os.Build.MODEL;
        commentBox.setEnabled(false);
        new Thread(() -> {
            try {
                JSONObject body = new JSONObject();
                body.put("game", game); body.put("filename", filename);
                body.put("text", text); body.put("device", device);
                JSONObject r = new JSONObject(readResponse(openPost(WORKER + "/comment", body.toString())));
                if (r.optBoolean("success", false)) {
                    ui.post(() -> {
                        commentBox.setText(""); commentBox.setEnabled(true);
                        Toast.makeText(this, "Comment posted", Toast.LENGTH_SHORT).show();
                        fetchComments(config);
                    });
                } else throw new Exception(r.optString("error", "Unknown error"));
            } catch (Exception e) {
                ui.post(() -> {
                    commentBox.setEnabled(true);
                    Toast.makeText(this, "Failed: " + e.getMessage(), Toast.LENGTH_SHORT).show();
                });
            }
        }).start();
    }

    // ── Screen management ─────────────────────────────────────────────────────

    private void showScreen(int n) {
        currentScreen = n;
        screenGames.setVisibility(n == 1 ? View.VISIBLE : View.GONE);
        screenConfigs.setVisibility(n == 2 ? View.VISIBLE : View.GONE);
        screenDetail.setVisibility(n == 3 ? View.VISIBLE : View.GONE);
        if (refreshBtn != null) refreshBtn.setVisibility(n == 3 ? View.GONE : View.VISIBLE);
        if (n == 1) headerTitle.setText("Game Configs");
    }

    // ── HTTP helpers ──────────────────────────────────────────────────────────

    private HttpURLConnection openGet(String url) throws Exception {
        HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
        c.setConnectTimeout(15000); c.setReadTimeout(15000);
        return c;
    }

    private HttpURLConnection openPost(String url, String jsonBody) throws Exception {
        HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
        c.setRequestMethod("POST"); c.setDoOutput(true);
        c.setConnectTimeout(15000); c.setReadTimeout(15000);
        c.setRequestProperty("Content-Type", "application/json");
        OutputStream os = c.getOutputStream();
        os.write(jsonBody.getBytes("UTF-8")); os.close();
        return c;
    }

    private String readResponse(HttpURLConnection conn) throws Exception {
        InputStream is = conn.getResponseCode() < 400 ? conn.getInputStream() : conn.getErrorStream();
        BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
        StringBuilder sb = new StringBuilder(); String line;
        while ((line = br.readLine()) != null) sb.append(line);
        br.close();
        return sb.toString();
    }

    private String urlEncode(String s) {
        try { return java.net.URLEncoder.encode(s, "UTF-8"); }
        catch (Exception e) { return s; }
    }

    // ── Layout helpers ────────────────────────────────────────────────────────

    private int dp(int v) {
        return (int) (v * getResources().getDisplayMetrics().density);
    }

    private FrameLayout.LayoutParams matchParams() {
        return new FrameLayout.LayoutParams(-1, -1);
    }

    private LinearLayout.LayoutParams matchLinearParams() {
        return new LinearLayout.LayoutParams(-1, -1);
    }

    private LinearLayout.LayoutParams marginParams(int l, int t, int r, int b) {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, -2);
        lp.setMargins(l, t, r, b); return lp;
    }

    private LinearLayout.LayoutParams marginParams(int l, int t, int r, int b, int w, int h) {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(w, h);
        lp.setMargins(l, t, r, b); return lp;
    }

    private LinearLayout surface() {
        LinearLayout ll = new LinearLayout(this);
        ll.setOrientation(LinearLayout.VERTICAL);
        ll.setBackgroundColor(SURFACE);
        return ll;
    }
}
