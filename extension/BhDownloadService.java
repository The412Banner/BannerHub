package app.revanced.extension.gamehub;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Foreground service that runs Epic/GOG/Amazon downloads in the background.
 *
 * Activities register a DownloadListener for live UI updates while visible.
 * When the activity is gone the service continues, updating a progress
 * notification. A cancel action in the notification stops the download.
 *
 * Usage from an activity:
 *   BhDownloadService.addListener(gameId, listener);
 *   startForegroundService(BhDownloadService.startIntent(ctx, ...));
 *
 * In onPause:
 *   BhDownloadService.removeListener(gameId);
 *
 * In onResume (reconnect if in progress):
 *   if (BhDownloadService.isActive(gameId)) { ... re-register listener ... }
 */
public class BhDownloadService extends Service {

    private static final String TAG = "BH_DL_SVC";
    private static final String CHANNEL_ID      = "bh_downloads";
    private static final int    NOTIF_ID         = 8800;
    private static final int    NOTIF_DONE_BASE  = 8810;
    private static final String PREFS_LIBRARY    = "bh_library";
    private static final String LIB_SEP          = "\n";

    public static final String ACTION_START  = "bh.download.START";
    public static final String ACTION_CANCEL = "bh.download.CANCEL";

    // Common extras
    public static final String EXTRA_STORE     = "store";
    public static final String EXTRA_GAME_ID   = "game_id";
    public static final String EXTRA_GAME_NAME = "game_name";
    // Epic extras
    public static final String EXTRA_EPIC_NAMESPACE  = "epic_ns";
    public static final String EXTRA_EPIC_CATALOG_ID = "epic_cat";
    public static final String EXTRA_EPIC_APP_NAME   = "epic_app";
    // GOG extras
    public static final String EXTRA_GOG_GAME_ID    = "gog_gid";
    public static final String EXTRA_GOG_TITLE      = "gog_title";
    public static final String EXTRA_GOG_IMAGE_URL  = "gog_img";
    public static final String EXTRA_GOG_DEVELOPER  = "gog_dev";
    public static final String EXTRA_GOG_CATEGORY   = "gog_cat";
    public static final String EXTRA_GOG_GENERATION = "gog_gen";
    // Amazon extras
    public static final String EXTRA_AMAZON_PRODUCT_ID = "amz_pid";
    public static final String EXTRA_AMAZON_ENT_ID     = "amz_eid";
    public static final String EXTRA_AMAZON_SKU        = "amz_sku";
    public static final String EXTRA_AMAZON_TITLE      = "amz_title";

    // ── Public listener interfaces ────────────────────────────────────────────

    public interface DownloadListener {
        void onProgress(String msg, int pct);
        void onComplete(String installDir);
        void onError(String msg);
        void onCancelled();
    }

    public interface GlobalListener {
        void onAnyProgress(String gameId, String gameName, String msg, int pct);
        void onAnyComplete(String gameId, String gameName);
        void onAnyError(String gameId, String msg);
        void onAnyCancelled(String gameId);
    }

    // ── Library entry ─────────────────────────────────────────────────────────

    public static class LibraryEntry {
        public final String dlKey;
        public final String name;
        public final String store;
        public final String installPath;
        LibraryEntry(String dlKey, String name, String store, String installPath) {
            this.dlKey = dlKey; this.name = name;
            this.store = store; this.installPath = installPath;
        }
    }

    public static List<LibraryEntry> getLibrary(Context ctx) {
        android.content.SharedPreferences p = ctx.getSharedPreferences(PREFS_LIBRARY, 0);
        List<LibraryEntry> list = new ArrayList<>();
        for (Map.Entry<String, ?> e : p.getAll().entrySet()) {
            String[] parts = e.getValue().toString().split(LIB_SEP, 3);
            list.add(new LibraryEntry(e.getKey(),
                    parts.length > 0 ? parts[0] : "",
                    parts.length > 1 ? parts[1] : "",
                    parts.length > 2 ? parts[2] : ""));
        }
        return list;
    }

    public static LibraryEntry getLibraryEntry(Context ctx, String dlKey) {
        String val = ctx.getSharedPreferences(PREFS_LIBRARY, 0).getString(dlKey, null);
        if (val == null) return null;
        String[] parts = val.split(LIB_SEP, 3);
        return new LibraryEntry(dlKey,
                parts.length > 0 ? parts[0] : "",
                parts.length > 1 ? parts[1] : "",
                parts.length > 2 ? parts[2] : "");
    }

    public static void removeLibraryEntry(Context ctx, String dlKey) {
        ctx.getSharedPreferences(PREFS_LIBRARY, 0).edit().remove(dlKey).apply();
    }

    public static void clearLibrary(Context ctx) {
        ctx.getSharedPreferences(PREFS_LIBRARY, 0).edit().clear().apply();
    }

    // Static registry — no binding needed; activities register/unregister directly
    private static final Set<String>                    activeJobs     = ConcurrentHashMap.newKeySet();
    private static final Map<String, DownloadListener>  listeners      = new ConcurrentHashMap<>();
    private static final Map<String, Runnable>          cancelHandles  = new ConcurrentHashMap<>();
    private static final Map<String, String>            gameNames      = new ConcurrentHashMap<>();
    private static final Map<String, String>            gameStores     = new ConcurrentHashMap<>();
    private static final Map<String, String>            lastMsgMap     = new ConcurrentHashMap<>();
    private static final Map<String, Integer>           lastPctMap     = new ConcurrentHashMap<>();
    private static final List<GlobalListener>           globalListeners = new CopyOnWriteArrayList<>();

    public interface CountObserver { void onCountChanged(int count); }
    private static volatile CountObserver sCountObserver;

    public static void setCountObserver(CountObserver o) { sCountObserver = o; }
    public static void clearCountObserver()              { sCountObserver = null; }
    public static int  getActiveCount()                  { return activeJobs.size(); }

    public static void addListener(String gameId, DownloadListener l) {
        listeners.put(gameId, l);
    }

    public static void removeListener(String gameId) {
        listeners.remove(gameId);
    }

    public static void addGlobalListener(GlobalListener l) {
        globalListeners.add(l);
    }

    public static void removeGlobalListener(GlobalListener l) {
        globalListeners.remove(l);
    }

    public static boolean isActive(String gameId) {
        return activeJobs.contains(gameId);
    }

    public static Set<String> getActiveJobs() {
        return java.util.Collections.unmodifiableSet(activeJobs);
    }

    public static String getGameName(String gameId) {
        return gameNames.getOrDefault(gameId, gameId);
    }

    public static String getLastMsg(String gameId) {
        return lastMsgMap.getOrDefault(gameId, "");
    }

    public static int getLastPct(String gameId) {
        Integer v = lastPctMap.get(gameId);
        return v != null ? v : 0;
    }

    public static void cancel(Context ctx, String gameId) {
        Intent i = new Intent(ctx, BhDownloadService.class);
        i.setAction(ACTION_CANCEL);
        i.putExtra(EXTRA_GAME_ID, gameId);
        ctx.startService(i);
    }

    // ── Service lifecycle ─────────────────────────────────────────────────────

    private NotificationManager notifMgr;
    private final AtomicInteger doneCounter = new AtomicInteger(0);

    @Override
    public void onCreate() {
        super.onCreate();
        notifMgr = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        createChannel();
    }

    @Override
    public IBinder onBind(Intent intent) { return null; }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent == null) return START_NOT_STICKY;
        String action = intent.getAction();

        if (ACTION_CANCEL.equals(action)) {
            String gameId = intent.getStringExtra(EXTRA_GAME_ID);
            if (gameId != null) {
                Runnable h = cancelHandles.get(gameId);
                if (h != null) h.run();
            }
            return START_NOT_STICKY;
        }

        if (!ACTION_START.equals(action)) return START_NOT_STICKY;

        String store    = intent.getStringExtra(EXTRA_STORE);
        String gameId   = intent.getStringExtra(EXTRA_GAME_ID);
        String gameName = intent.getStringExtra(EXTRA_GAME_NAME);
        if (gameId == null || store == null) return START_NOT_STICKY;
        if (activeJobs.contains(gameId)) return START_NOT_STICKY;

        activeJobs.add(gameId);
        fireCountObserver();
        gameNames.put(gameId, gameName != null ? gameName : "");
        gameStores.put(gameId, store);
        startForeground(NOTIF_ID, buildProgressNotif(gameName != null ? gameName : "", "Starting…", 0, gameId));

        ExecutorService exec = Executors.newSingleThreadExecutor();
        final Intent savedIntent = intent;
        exec.submit(() -> {
            try {
                switch (store) {
                    case "EPIC":   runEpic(savedIntent, gameId, gameName);   break;
                    case "GOG":    runGog(savedIntent, gameId, gameName);    break;
                    case "AMAZON": runAmazon(savedIntent, gameId, gameName); break;
                    default:       notifyError(gameId, "Unknown store: " + store);
                }
            } finally {
                exec.shutdown();
            }
        });

        return START_NOT_STICKY;
    }

    // ── Epic download ─────────────────────────────────────────────────────────

    private void runEpic(Intent intent, String gameId, String gameName) {
        String namespace = intent.getStringExtra(EXTRA_EPIC_NAMESPACE);
        String catalogId = intent.getStringExtra(EXTRA_EPIC_CATALOG_ID);
        String appName   = intent.getStringExtra(EXTRA_EPIC_APP_NAME);

        AtomicBoolean cancelled = new AtomicBoolean(false);
        cancelHandles.put(gameId, () -> cancelled.set(true));

        try {
            notifyProgress(gameId, "Fetching credentials…", 0);
            String token = EpicCredentialStore.getValidAccessToken(this);
            if (token == null) { notifyError(gameId, "Epic login required"); return; }

            if (cancelled.get()) { notifyCancelled(gameId); return; }
            notifyProgress(gameId, "Fetching manifest…", 1);
            String manifestJson = EpicApiClient.getManifestApiJson(token, namespace, catalogId, appName);
            if (manifestJson == null) { notifyError(gameId, "Failed to fetch manifest"); return; }

            String sanitized = gameName != null ? gameName.replaceAll("[^a-zA-Z0-9 \\-_]", "").trim() : "";
            if (sanitized.isEmpty()) sanitized = "epic_" + appName.hashCode();
            File installDir = new File(new File(getFilesDir(), "epic_games"), sanitized);
            getSharedPreferences("bh_epic_prefs", 0)
                    .edit().putString("epic_dir_" + appName, installDir.getAbsolutePath()).apply();

            final String finalToken = token;
            boolean ok = EpicDownloadManager.install(this, manifestJson, finalToken,
                    installDir.getAbsolutePath(), (msg, pct) -> {
                        if (!cancelled.get()) notifyProgress(gameId, msg, pct);
                    });

            if (cancelled.get()) { notifyCancelled(gameId); return; }
            if (!ok) { notifyError(gameId, "Download failed"); return; }

            // Store manifest version for update checker
            try {
                String vid = new org.json.JSONObject(manifestJson).optString("versionId", "");
                if (!vid.isEmpty()) {
                    getSharedPreferences("bh_epic_prefs", 0)
                            .edit().putString("epic_manifest_version_" + appName, vid).apply();
                }
            } catch (Exception ignored) {}

            // Auto-pick best exe
            List<File> exeFiles = new ArrayList<>();
            AmazonLaunchHelper.collectExe(installDir, exeFiles);
            if (exeFiles.isEmpty()) { notifyError(gameId, "No executable found"); return; }
            String lowerTitle = gameName != null ? gameName.toLowerCase() : "";
            Collections.sort(exeFiles, (a, b) ->
                    AmazonLaunchHelper.scoreExe(b, lowerTitle) - AmazonLaunchHelper.scoreExe(a, lowerTitle));
            getSharedPreferences("bh_epic_prefs", 0)
                    .edit().putString("epic_exe_" + appName, exeFiles.get(0).getAbsolutePath()).apply();

            notifyComplete(gameId, installDir.getAbsolutePath());

        } catch (Exception e) {
            notifyError(gameId, e.getMessage() != null ? e.getMessage() : "Unknown error");
        } finally {
            cancelHandles.remove(gameId);
        }
    }

    // ── GOG download ──────────────────────────────────────────────────────────

    private void runGog(Intent intent, String gameId, String gameName) {
        String gogGameId  = intent.getStringExtra(EXTRA_GOG_GAME_ID);
        String title      = intent.getStringExtra(EXTRA_GOG_TITLE);
        String imageUrl   = intent.getStringExtra(EXTRA_GOG_IMAGE_URL);
        String developer  = intent.getStringExtra(EXTRA_GOG_DEVELOPER);
        String category   = intent.getStringExtra(EXTRA_GOG_CATEGORY);
        int    generation = intent.getIntExtra(EXTRA_GOG_GENERATION, 0);

        GogGame game = new GogGame(
                gogGameId  != null ? gogGameId  : "",
                title      != null ? title      : "",
                imageUrl   != null ? imageUrl   : "",
                "",
                developer  != null ? developer  : "",
                category   != null ? category   : "",
                generation);

        CountDownLatch latch = new CountDownLatch(1);

        Runnable cancelHandle = GogDownloadManager.startDownload(this, game,
                new GogDownloadManager.Callback() {
            @Override public void onProgress(String msg, int pct) {
                notifyProgress(gameId, msg, pct);
            }
            @Override public void onComplete(String exePath) {
                if (exePath != null && !exePath.isEmpty()) {
                    getSharedPreferences("bh_gog_prefs", 0)
                            .edit().putString("gog_exe_" + gogGameId, exePath).apply();
                }
                // Resolve and store install dir (used by library/uninstall)
                String installDirPath = "";
                String sanitized = (title != null ? title : "").replaceAll("[^a-zA-Z0-9 \\-_]", "").trim();
                if (sanitized.isEmpty()) sanitized = "game_" + (gogGameId != null ? gogGameId.hashCode() : 0);
                File gogDir = GogInstallPath.getInstallDir(BhDownloadService.this, sanitized);
                if (gogDir != null) {
                    installDirPath = gogDir.getAbsolutePath();
                    getSharedPreferences("bh_gog_prefs", 0)
                            .edit().putString("gog_dir_" + gogGameId, installDirPath).apply();
                }
                notifyComplete(gameId, installDirPath);
                latch.countDown();
            }
            @Override public void onError(String msg) {
                notifyError(gameId, msg);
                latch.countDown();
            }
            @Override public void onCancelled() {
                notifyCancelled(gameId);
                latch.countDown();
            }
            @Override public void onSelectExe(List<String> candidates,
                                               java.util.function.Consumer<String> onSelected) {
                onSelected.accept(candidates.isEmpty() ? null : candidates.get(0));
            }
        });

        cancelHandles.put(gameId, cancelHandle);
        try {
            latch.await();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            notifyError(gameId, "Download interrupted");
        } finally {
            cancelHandles.remove(gameId);
        }
    }

    // ── Amazon download ───────────────────────────────────────────────────────

    private void runAmazon(Intent intent, String gameId, String gameName) {
        String productId     = intent.getStringExtra(EXTRA_AMAZON_PRODUCT_ID);
        String entitlementId = intent.getStringExtra(EXTRA_AMAZON_ENT_ID);
        String productSku    = intent.getStringExtra(EXTRA_AMAZON_SKU);
        String title         = intent.getStringExtra(EXTRA_AMAZON_TITLE);

        AtomicBoolean cancelled = new AtomicBoolean(false);
        cancelHandles.put(gameId, () -> cancelled.set(true));

        try {
            notifyProgress(gameId, "Fetching credentials…", 0);
            String token = AmazonCredentialStore.getValidAccessToken(this);
            if (token == null) { notifyError(gameId, "Amazon login required"); return; }

            AmazonGame game = new AmazonGame();
            game.productId     = productId;
            game.entitlementId = entitlementId != null ? entitlementId : "";
            game.title         = title != null ? title : "";
            game.productSku    = productSku != null ? productSku : "";

            String sanitized = title != null ? title.replaceAll("[^a-zA-Z0-9 \\-_]", "").trim() : "";
            if (sanitized.isEmpty()) sanitized = "game_" + productId.hashCode();
            File installDir = new File(new File(getFilesDir(), "Amazon"), sanitized);
            getSharedPreferences("bh_amazon_prefs", 0)
                    .edit().putString("amazon_dir_" + productId, installDir.getAbsolutePath()).apply();

            boolean ok = AmazonDownloadManager.install(this, game, token, installDir,
                    (dl, total, file) -> {
                        if (!cancelled.get()) {
                            int pct = (total > 0) ? (int) (dl * 100L / total) : 0;
                            notifyProgress(gameId, file != null && !file.isEmpty() ? file : "Downloading…", pct);
                        }
                    },
                    cancelled::get);

            if (cancelled.get()) { notifyCancelled(gameId); return; }
            if (!ok) { notifyError(gameId, "Download failed"); return; }

            // Auto-pick best exe
            List<File> exeFiles = new ArrayList<>();
            AmazonLaunchHelper.collectExe(installDir, exeFiles);
            if (exeFiles.isEmpty()) { notifyError(gameId, "No executable found"); return; }
            String lowerTitle = title != null ? title.toLowerCase() : "";
            Collections.sort(exeFiles, (a, b) ->
                    AmazonLaunchHelper.scoreExe(b, lowerTitle) - AmazonLaunchHelper.scoreExe(a, lowerTitle));
            getSharedPreferences("bh_amazon_prefs", 0)
                    .edit().putString("amazon_exe_" + productId, exeFiles.get(0).getAbsolutePath()).apply();

            notifyComplete(gameId, installDir.getAbsolutePath());

        } catch (Exception e) {
            notifyError(gameId, e.getMessage() != null ? e.getMessage() : "Unknown error");
        } finally {
            cancelHandles.remove(gameId);
        }
    }

    // ── Notify helpers ────────────────────────────────────────────────────────

    private void notifyProgress(String gameId, String msg, int pct) {
        String name = gameNames.getOrDefault(gameId, "");
        lastMsgMap.put(gameId, msg);
        lastPctMap.put(gameId, pct);
        updateProgressNotif(name, msg, pct, gameId);
        DownloadListener l = listeners.get(gameId);
        if (l != null) l.onProgress(msg, pct);
        for (GlobalListener gl : globalListeners) gl.onAnyProgress(gameId, name, msg, pct);
    }

    private void notifyComplete(String gameId, String installDir) {
        Log.i(TAG, "[" + gameId + "] complete");
        activeJobs.remove(gameId);
        fireCountObserver();
        lastMsgMap.remove(gameId);
        lastPctMap.remove(gameId);
        String name  = gameNames.remove(gameId);
        String store = gameStores.remove(gameId);
        // Persist to library before notifying listeners (so onAnyComplete can read it)
        if (name != null && store != null) {
            saveLibraryEntry(gameId, name, store, installDir != null ? installDir : "");
        }
        DownloadListener l = listeners.remove(gameId);
        if (l != null) {
            l.onComplete(installDir);
        } else {
            notifMgr.notify(NOTIF_DONE_BASE + doneCounter.getAndIncrement(),
                    buildDoneNotif(name != null ? name : "Game"));
        }
        for (GlobalListener gl : globalListeners) gl.onAnyComplete(gameId, name != null ? name : "");
        if (activeJobs.isEmpty()) {
            stopForeground(true);
            stopSelf();
        }
    }

    private void saveLibraryEntry(String dlKey, String name, String store, String installPath) {
        String val = name + LIB_SEP + store + LIB_SEP + installPath;
        getSharedPreferences(PREFS_LIBRARY, 0).edit().putString(dlKey, val).apply();
    }

    private void notifyError(String gameId, String msg) {
        Log.e(TAG, "[" + gameId + "] error: " + msg);
        activeJobs.remove(gameId);
        fireCountObserver();
        lastMsgMap.remove(gameId);
        lastPctMap.remove(gameId);
        gameStores.remove(gameId);
        String name = gameNames.remove(gameId);
        DownloadListener l = listeners.remove(gameId);
        if (l != null) {
            l.onError(msg);
        } else {
            Notification.Builder b = notifBuilder();
            b.setContentTitle((name != null ? name : "Game") + " — download failed")
             .setContentText(msg)
             .setSmallIcon(android.R.drawable.stat_notify_error)
             .setAutoCancel(true);
            notifMgr.notify(NOTIF_DONE_BASE + doneCounter.getAndIncrement(), b.build());
        }
        for (GlobalListener gl : globalListeners) gl.onAnyError(gameId, msg);
        if (activeJobs.isEmpty()) {
            stopForeground(true);
            stopSelf();
        }
    }

    private void notifyCancelled(String gameId) {
        Log.i(TAG, "[" + gameId + "] cancelled");
        activeJobs.remove(gameId);
        fireCountObserver();
        lastMsgMap.remove(gameId);
        lastPctMap.remove(gameId);
        gameNames.remove(gameId);
        gameStores.remove(gameId);
        DownloadListener l = listeners.remove(gameId);
        if (l != null) l.onCancelled();
        for (GlobalListener gl : globalListeners) gl.onAnyCancelled(gameId);
        if (activeJobs.isEmpty()) {
            stopForeground(true);
            stopSelf();
        }
    }

    private static void fireCountObserver() {
        CountObserver o = sCountObserver;
        if (o != null) o.onCountChanged(activeJobs.size());
    }

    // ── Notification helpers ──────────────────────────────────────────────────

    private void createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel ch = new NotificationChannel(
                    CHANNEL_ID, "BannerHub Downloads",
                    NotificationManager.IMPORTANCE_LOW);
            ch.setDescription("Game download progress");
            notifMgr.createNotificationChannel(ch);
        }
    }

    @SuppressWarnings("deprecation")
    private Notification.Builder notifBuilder() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            return new Notification.Builder(this, CHANNEL_ID);
        } else {
            return new Notification.Builder(this);
        }
    }

    private Notification buildProgressNotif(String name, String msg, int pct, String gameId) {
        Intent cancelIntent = new Intent(this, BhDownloadService.class);
        cancelIntent.setAction(ACTION_CANCEL);
        cancelIntent.putExtra(EXTRA_GAME_ID, gameId);
        PendingIntent cancelPI = PendingIntent.getService(this, gameId.hashCode(),
                cancelIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        return notifBuilder()
                .setContentTitle(name)
                .setContentText(msg)
                .setSmallIcon(android.R.drawable.stat_sys_download)
                .setOngoing(true)
                .setProgress(100, pct, pct == 0)
                .addAction(android.R.drawable.ic_menu_close_clear_cancel, "Cancel", cancelPI)
                .build();
    }

    private void updateProgressNotif(String name, String msg, int pct, String gameId) {
        notifMgr.notify(NOTIF_ID, buildProgressNotif(name, msg, pct, gameId));
    }

    private Notification buildDoneNotif(String name) {
        Intent launchIntent = getPackageManager().getLaunchIntentForPackage(getPackageName());
        if (launchIntent == null) launchIntent = new Intent();
        PendingIntent launchPI = PendingIntent.getActivity(this, 0,
                launchIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        return notifBuilder()
                .setContentTitle(name + " — installed")
                .setContentText("Tap to open BannerHub")
                .setSmallIcon(android.R.drawable.stat_sys_download_done)
                .setAutoCancel(true)
                .setContentIntent(launchPI)
                .build();
    }
}
