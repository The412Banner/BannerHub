package app.revanced.extension.gamehub;

import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.util.TypedValue;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Method;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

/**
 * BhSettingsExporter — per-game settings import/export with component bundling.
 *
 * Export: reads pc_g_setting<gameId> SharedPreferences + installed custom components
 *         → JSON saved locally and/or uploaded to community backend
 *
 * Import: from local file or community download → applies settings,
 *         detects missing components, offers to download+inject them.
 */
public class BhSettingsExporter {
    private static final String SP_PREFIX    = "pc_g_setting";
    private static final String EXPORT_DIR   = "BannerHub/configs";
    private static final String SOURCES_SP   = "banners_sources";
    private static final String INJECTOR_CLS =
            "com.xj.landscape.launcher.ui.menu.ComponentInjectorHelper";

    private static final String WORKER_BASE  =
            "https://bannerhub-configs-worker.the412banner.workers.dev";

    static final String BH_VERSION = "3.3.0";

    // ─── Export entry point ──────────────────────────────────────────────────

    public static void showExportDialog(Context ctx, String gameId, String gameName) {
        // Build preview counts synchronously (just reading, not saving)
        int settingsCount = 0;
        int componentsCount = 0;
        try {
            settingsCount = ctx.getSharedPreferences(SP_PREFIX + gameId, Context.MODE_PRIVATE)
                    .getAll().size();
        } catch (Exception ignored) {}
        try { componentsCount = buildComponentsArray(ctx, gameId).length(); } catch (Exception ignored) {}
        String soc    = detectSoc(ctx);
        String device = Build.MANUFACTURER + " " + Build.MODEL;

        String preview = "Device:      " + device
                + "\nSOC:         " + soc
                + "\nSettings:    " + settingsCount
                + "\nComponents:  " + componentsCount;

        new AlertDialog.Builder(ctx)
                .setTitle("Export Config — " + gameName)
                .setMessage(preview)
                .setPositiveButton("Save Locally",         (d, w) -> doExport(ctx, gameId, gameName, false))
                .setNeutralButton("Save + Share Online",   (d, w) -> doExport(ctx, gameId, gameName, true))
                .setNegativeButton("Cancel", null)
                .show();
    }

    // kept for backward compatibility (called from existing smali injection)
    public static void exportConfig(Context ctx, String gameId, String gameName) {
        showExportDialog(ctx, gameId, gameName);
    }

    private static void doExport(Context ctx, String gameId, String gameName, boolean share) {
        try {
            // Generate token early so it's embedded in both local file and upload
            // This enables token recovery from local file if SP is lost (reinstall/clear data)
            String uploadToken = Long.toHexString(new Random().nextLong() & Long.MAX_VALUE);
            String uploadDate  = new java.text.SimpleDateFormat("yyyy-MM-dd",
                    java.util.Locale.US).format(new java.util.Date());

            // Game settings
            SharedPreferences sp = ctx.getSharedPreferences(SP_PREFIX + gameId, Context.MODE_PRIVATE);
            JSONObject settings = new JSONObject();
            for (Map.Entry<String, ?> e : sp.getAll().entrySet()) {
                settings.put(e.getKey(), e.getValue());
            }

            // Installed custom components (those that have a download URL tracked)
            JSONArray components = buildComponentsArray(ctx, gameId);

            // Meta block — parsed and shown in BhGameConfigsActivity detail view
            JSONObject meta = new JSONObject();
            meta.put("app_source",       "bannerhub");
            meta.put("device",           Build.MANUFACTURER + " " + Build.MODEL);
            meta.put("soc",              detectSoc(ctx));
            meta.put("bh_version",       BH_VERSION);
            meta.put("upload_token",     uploadToken);
            meta.put("settings_count",   settings.length());
            meta.put("components_count", components.length());

            JSONObject json = new JSONObject();
            json.put("meta", meta);
            json.put("settings", settings);
            json.put("components", components);

            String safeName     = gameName.replaceAll("[^a-zA-Z0-9_\\-]", "_");
            String manufacturer = Build.MANUFACTURER.replaceAll("[^a-zA-Z0-9_\\-]", "_");
            String deviceName   = Build.MODEL.replaceAll("[^a-zA-Z0-9_\\-]", "_");
            String socModel     = detectSoc(ctx).replaceAll("[^a-zA-Z0-9_\\-]", "_");
            long   ts           = System.currentTimeMillis() / 1000;
            String fileName     = safeName + "-" + manufacturer + "-" + deviceName + "-" + socModel + "-" + ts + ".json";

            // Save locally (token embedded — survives app reinstall via external storage)
            File dir = new File(Environment.getExternalStorageDirectory(), EXPORT_DIR);
            dir.mkdirs();
            File localFile = new File(dir, fileName);
            FileWriter fw = new FileWriter(localFile);
            fw.write(json.toString(2));
            fw.close();
            Toast.makeText(ctx, "Saved: " + fileName, Toast.LENGTH_LONG).show();

            if (share) {
                // Upload in background — json already has upload_token in meta
                String jsonStr = json.toString();

                new Thread(() -> {
                    Handler ui = new Handler(Looper.getMainLooper());
                    try {
                        // base64-encode content
                        byte[] bytes = jsonStr.getBytes("UTF-8");
                        String b64 = android.util.Base64.encodeToString(bytes, android.util.Base64.NO_WRAP);

                        JSONObject body = new JSONObject();
                        body.put("game",         safeName);
                        body.put("filename",     fileName);
                        body.put("content",      b64);
                        body.put("upload_token", uploadToken);

                        HttpURLConnection conn = (HttpURLConnection)
                                new URL(WORKER_BASE + "/upload").openConnection();
                        conn.setRequestMethod("POST");
                        conn.setDoOutput(true);
                        conn.setConnectTimeout(20000);
                        conn.setReadTimeout(20000);
                        conn.setRequestProperty("Content-Type", "application/json");

                        byte[] bodyBytes = body.toString().getBytes("UTF-8");
                        conn.getOutputStream().write(bodyBytes);

                        int code = conn.getResponseCode();
                        InputStream is = (code >= 200 && code < 300)
                                ? conn.getInputStream() : conn.getErrorStream();
                        BufferedReader br = new BufferedReader(new InputStreamReader(is));
                        StringBuilder sb2 = new StringBuilder();
                        String line;
                        while ((line = br.readLine()) != null) sb2.append(line);
                        br.close();

                        JSONObject resp = new JSONObject(sb2.toString());
                        boolean ok = resp.optBoolean("success", false);

                        if (ok) {
                            // Save upload record so user can find it in My Uploads
                            String sha = resp.optString("sha", "");
                            if (!sha.isEmpty()) {
                                JSONObject record = new JSONObject();
                                record.put("sha",      sha);
                                record.put("game",     safeName);
                                record.put("filename", fileName);
                                record.put("date",     uploadDate);
                                record.put("token",    uploadToken);
                                ctx.getSharedPreferences("bh_config_uploads", Context.MODE_PRIVATE)
                                   .edit().putString(sha, record.toString()).apply();
                            }
                        }

                        ui.post(() -> Toast.makeText(ctx,
                                ok ? "Shared online: " + fileName : "Upload failed: " + resp.optString("error"),
                                Toast.LENGTH_LONG).show());
                    } catch (Exception e) {
                        ui.post(() -> Toast.makeText(ctx,
                                "Upload error: " + e.getMessage(), Toast.LENGTH_LONG).show());
                    }
                }).start();
            }
        } catch (Exception e) {
            Toast.makeText(ctx, "Export failed: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }

    /**
     * Build components array from the game's own settings SP.
     *
     * Reads the known component keys from pc_g_setting{gameId} to find exactly
     * which components are active for this game, then cross-references banners_sources
     * to get the download URL — only included if it's a BannerHub-injected component.
     * Stock GameHub components (no URL in banners_sources) are intentionally excluded
     * since they need no download; their selection is already captured in the settings block.
     */
    private static JSONArray buildComponentsArray(Context ctx, String gameId) throws Exception {
        SharedPreferences gameSp    = ctx.getSharedPreferences(SP_PREFIX + gameId, Context.MODE_PRIVATE);
        SharedPreferences sourcesSp = ctx.getSharedPreferences(SOURCES_SP, Context.MODE_PRIVATE);
        JSONArray arr = new JSONArray();

        // Keys in pc_g_setting{gameId} that hold active component JSON objects
        // Each value is a JSON string with at minimum a "name" field
        String[] componentKeys = {
            "pc_ls_DXVK",          // DXVK
            "pc_ls_VK3k",          // VKD3D
            "pc_set_constant_94",  // Box64
            "pc_set_constant_95",  // FEXCore
            "pc_ls_GPU_DRIVER_",   // GPU driver
            "pc_ls_CONTAINER_LIST",// Wine container
            "pc_ls_steam_client",  // Steam client
        };

        for (String key : componentKeys) {
            String raw = gameSp.getString(key, "");
            if (raw.isEmpty()) continue;
            try {
                JSONObject obj  = new JSONObject(raw);
                String name     = obj.optString("name", "");
                if (name.isEmpty()) continue;

                // Only include if this is a BannerHub-injected component (has a URL in banners_sources)
                String url  = sourcesSp.getString("url_for:" + name, "");
                if (url.isEmpty()) continue;
                String type = sourcesSp.getString(name + ":type", "");

                JSONObject comp = new JSONObject();
                comp.put("name", name);
                comp.put("url",  url);
                comp.put("type", type);
                arr.put(comp);
            } catch (Exception ignored) {}
        }
        return arr;
    }

    // ─── Import entry point ──────────────────────────────────────────────────

    public static void showImportDialog(final Context ctx, final String gameId, final String gameName) {
        new AlertDialog.Builder(ctx)
                .setTitle("Import Config — " + gameName)
                .setItems(new String[]{"My Device", "Browse Community"},
                        (dialog, which) -> {
                            if (which == 0) showLocalImportDialog(ctx, gameId, gameName);
                            else            showCommunityImportDialog(ctx, gameId, gameName);
                        })
                .setNegativeButton("Cancel", null)
                .show();
    }

    // ─── Local import ────────────────────────────────────────────────────────

    private static void showLocalImportDialog(Context ctx, String gameId, String gameName) {
        try {
            File dir = new File(Environment.getExternalStorageDirectory(), EXPORT_DIR);
            if (!dir.exists()) {
                Toast.makeText(ctx, "No configs folder — export one first", Toast.LENGTH_SHORT).show();
                return;
            }
            File[] files = dir.listFiles((d, n) -> n.endsWith(".json"));
            if (files == null || files.length == 0) {
                Toast.makeText(ctx, "No .json configs found in BannerHub/configs/", Toast.LENGTH_SHORT).show();
                return;
            }
            String[] names = new String[files.length];
            for (int i = 0; i < files.length; i++) names[i] = files[i].getName();
            final File[] finalFiles = files;

            new AlertDialog.Builder(ctx)
                    .setTitle("Device Configs for " + gameName)
                    .setItems(names, (dialog, which) ->
                            showLocalImportPreview(ctx, gameId, gameName, finalFiles[which]))
                    .setNegativeButton("Cancel", null)
                    .show();
        } catch (Exception e) {
            Toast.makeText(ctx, "Import error: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    private static void showLocalImportPreview(Context ctx, String gameId, String gameName, File configFile) {
        try {
            char[] buf = new char[(int) configFile.length()];
            FileReader fr = new FileReader(configFile);
            int n = fr.read(buf);
            fr.close();
            JSONObject json = new JSONObject(new String(buf, 0, n));

            JSONObject meta        = json.optJSONObject("meta");
            String previewDevice   = meta != null ? meta.optString("device", "Unknown") : "Unknown";
            String previewSoc      = meta != null ? meta.optString("soc", "") : "";
            int previewSettings    = meta != null ? meta.optInt("settings_count", 0)
                    : (json.has("settings") ? json.getJSONObject("settings").length() : json.length());
            int previewComponents  = meta != null ? meta.optInt("components_count", 0) : 0;

            StringBuilder msg = new StringBuilder();
            msg.append("Device:      ").append(previewDevice.replace("_", " ")).append("\n");
            if (!previewSoc.isEmpty())
                msg.append("SOC:         ").append(previewSoc.replace("_", " ")).append("\n");
            msg.append("Settings:    ").append(previewSettings).append("\n");
            msg.append("Components:  ").append(previewComponents);

            String deviceSoc = detectSoc(ctx);
            if (!previewSoc.isEmpty() && !previewSoc.replace("_", " ").equalsIgnoreCase(deviceSoc)) {
                msg.append("\n\n⚠ SOC mismatch\nConfig: ").append(previewSoc.replace("_", " "))
                   .append("\nYours:  ").append(deviceSoc)
                   .append("\nResults may vary.");
            }

            new AlertDialog.Builder(ctx)
                    .setTitle(configFile.getName())
                    .setMessage(msg.toString())
                    .setPositiveButton("Apply", (d, w) -> applyConfig(ctx, gameId, gameName, configFile))
                    .setNegativeButton("Cancel", null)
                    .show();
        } catch (Exception e) {
            // Can't parse preview — fall through to direct apply
            applyConfig(ctx, gameId, gameName, configFile);
        }
    }

    // ─── Community import ────────────────────────────────────────────────────

    private static void showCommunityImportDialog(Context ctx, String gameId, String gameName) {
        Toast.makeText(ctx, "Fetching community configs...", Toast.LENGTH_SHORT).show();
        String safeName = gameName.replaceAll("[^a-zA-Z0-9_\\-]", "_");

        new Thread(() -> {
            Handler ui = new Handler(Looper.getMainLooper());
            try {
                String listUrl = WORKER_BASE + "/list?game=" + android.net.Uri.encode(safeName);
                HttpURLConnection conn = (HttpURLConnection) new URL(listUrl).openConnection();
                conn.setConnectTimeout(15000);
                conn.setReadTimeout(15000);
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                br.close();

                JSONArray arr = new JSONArray(sb.toString());
                if (arr.length() == 0) {
                    ui.post(() -> Toast.makeText(ctx,
                            "No community configs for " + gameName, Toast.LENGTH_LONG).show());
                    return;
                }

                // Build display labels: "Device [SOC] (Date)"
                String[] labels = new String[arr.length()];
                String[] dlUrls = new String[arr.length()];
                String[] fnames = new String[arr.length()];
                for (int i = 0; i < arr.length(); i++) {
                    JSONObject entry = arr.getJSONObject(i);
                    String device   = entry.optString("device", "Unknown");
                    String soc      = entry.optString("soc", "");
                    String date     = entry.optString("date", "");
                    String gameFld  = entry.optString("game_folder", safeName);
                    String fname    = entry.optString("filename", "config.json");
                    labels[i] = device
                            + (soc.isEmpty() ? "" : " [" + soc + "]")
                            + (date.isEmpty() ? "" : "  (" + date + ")");
                    dlUrls[i] = WORKER_BASE + "/download?game="
                            + android.net.Uri.encode(gameFld)
                            + "&file=" + android.net.Uri.encode(fname);
                    fnames[i] = fname;
                }

                ui.post(() -> new AlertDialog.Builder(ctx)
                        .setTitle("Community Configs — " + gameName)
                        .setItems(labels, (dialog, which) ->
                                downloadAndImport(ctx, gameId, gameName, dlUrls[which], fnames[which]))
                        .setNegativeButton("Cancel", null)
                        .show());

            } catch (Exception e) {
                ui.post(() -> Toast.makeText(ctx,
                        "Fetch error: " + e.getMessage(), Toast.LENGTH_LONG).show());
            }
        }).start();
    }

    private static void downloadAndImport(Context ctx, String gameId, String gameName,
                                          String downloadUrl, String filename) {
        Toast.makeText(ctx, "Downloading config...", Toast.LENGTH_SHORT).show();
        new Thread(() -> {
            Handler ui = new Handler(Looper.getMainLooper());
            try {
                HttpURLConnection conn = (HttpURLConnection) new URL(downloadUrl).openConnection();
                conn.setConnectTimeout(15000);
                conn.setReadTimeout(15000);
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                br.close();

                // Save to local cache then apply
                File dir = new File(Environment.getExternalStorageDirectory(), EXPORT_DIR);
                dir.mkdirs();
                File localFile = new File(dir, filename);
                FileWriter fw = new FileWriter(localFile);
                fw.write(sb.toString());
                fw.close();

                ui.post(() -> applyConfig(ctx, gameId, gameName, localFile));
            } catch (Exception e) {
                ui.post(() -> Toast.makeText(ctx,
                        "Download failed: " + e.getMessage(), Toast.LENGTH_LONG).show());
            }
        }).start();
    }

    // ─── Apply config ────────────────────────────────────────────────────────

    static void applyConfig(Context ctx, String gameId, String gameName, File configFile) {
        try {
            char[] buf = new char[(int) configFile.length()];
            FileReader fr = new FileReader(configFile);
            int n = fr.read(buf);
            fr.close();

            JSONObject json = new JSONObject(new String(buf, 0, n));

            // Support both old flat format and new {settings, components} format
            JSONObject settings = json.has("settings") ? json.getJSONObject("settings") : json;

            // Build editor but don't apply yet — apply after component choice
            SharedPreferences.Editor editor = ctx.getSharedPreferences(
                    SP_PREFIX + gameId, Context.MODE_PRIVATE).edit();
            Iterator<String> keys = settings.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                Object val = settings.get(key);
                if      (val instanceof Boolean) editor.putBoolean(key, (Boolean) val);
                else if (val instanceof Integer) editor.putInt(key, (Integer) val);
                else if (val instanceof Long)    editor.putLong(key, (Long) val);
                else if (val instanceof Double)  editor.putFloat(key, ((Double) val).floatValue());
                else if (val instanceof String)  editor.putString(key, (String) val);
            }

            final String fileName = configFile.getName();
            Runnable applySettings = () -> {
                editor.apply();
                Toast.makeText(ctx, "Config applied from " + fileName, Toast.LENGTH_LONG).show();
            };

            // No components section — apply immediately
            if (!json.has("components")) {
                applySettings.run();
                return;
            }
            JSONArray components = json.getJSONArray("components");
            List<String[]> missing = findMissingComponents(ctx, components);

            // No missing components — apply immediately
            if (missing.isEmpty()) {
                applySettings.run();
                return;
            }

            // Show dialog — apply after user choice
            StringBuilder sb = new StringBuilder("This config requires ")
                    .append(missing.size()).append(" component(s) not installed:\n\n");
            for (String[] c : missing) {
                sb.append("• ").append(c[0]);
                if (!c[2].isEmpty()) sb.append(" (").append(c[2]).append(")");
                sb.append("\n");
            }
            sb.append("\nDownload and install them now?");

            new AlertDialog.Builder(ctx)
                    .setTitle("Missing Components")
                    .setMessage(sb.toString())
                    .setPositiveButton("Download All", (d, w) ->
                            downloadMissingComponents(ctx, missing, applySettings, gameId))
                    .setNegativeButton("Skip", (d, w) -> applySettings.run())
                    .show();

        } catch (Exception e) {
            Toast.makeText(ctx, "Apply failed: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    /** Returns list of {name, url, type} entries not present in banners_sources SP. */
    private static List<String[]> findMissingComponents(Context ctx, JSONArray components) throws Exception {
        SharedPreferences sp = ctx.getSharedPreferences(SOURCES_SP, Context.MODE_PRIVATE);
        List<String[]> missing = new ArrayList<>();
        for (int i = 0; i < components.length(); i++) {
            JSONObject c = components.getJSONObject(i);
            String name = c.optString("name", "");
            String url  = c.optString("url",  "");
            String type = c.optString("type", "");
            if (name.isEmpty() || url.isEmpty()) continue;
            if (!sp.contains(name)) missing.add(new String[]{name, url, type});
        }
        return missing;
    }

    // ─── Download + Inject ───────────────────────────────────────────────────

    private static void downloadMissingComponents(Context ctx, List<String[]> components,
                                                   Runnable onComplete, String gameId) {
        Toast.makeText(ctx, "Downloading " + components.size() + " component(s)...", Toast.LENGTH_LONG).show();
        // Captures the actual EmuComponents-registered name for the GPU driver if it
        // differs from the (potentially display-label-polluted) name in the config file.
        final String[] gpuActualName = {null};
        new Thread(() -> {
            Handler ui = new Handler(Looper.getMainLooper());
            int success = 0;
            for (String[] comp : components) {
                String name = comp[0];
                String url  = comp[1];
                String type = comp[2];
                try {
                    String filename = url.substring(url.lastIndexOf('/') + 1);
                    if (filename.isEmpty()) filename = name + ".zip";

                    File dest = new File(ctx.getCacheDir(), filename);
                    HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
                    conn.setConnectTimeout(30000);
                    conn.setReadTimeout(30000);
                    InputStream in = conn.getInputStream();
                    FileOutputStream fos = new FileOutputStream(dest);
                    byte[] buf = new byte[8192];
                    int read;
                    while ((read = in.read(buf)) != -1) fos.write(buf, 0, read);
                    in.close();
                    fos.close();

                    Uri uri = Uri.fromFile(dest);
                    int contentType = typeNameToInt(type);
                    final String fn = name;
                    final String fu = url;
                    final String ft = type;
                    final File   fd = dest;
                    ui.post(() -> {
                        String actual = injectAndRegister(ctx, fn, fu, ft, fd, uri, contentType);
                        if ("GPU".equals(ft) && actual != null && !actual.equals(fn)) {
                            gpuActualName[0] = actual;
                        }
                    });
                    success++;

                    Thread.sleep(600);
                } catch (Exception e) {
                    final String msg = e.getMessage();
                    ui.post(() -> Toast.makeText(ctx,
                            "Failed to download: " + name + (msg != null ? " — " + msg : ""),
                            Toast.LENGTH_LONG).show());
                }
            }
            final int done = success;
            ui.post(() -> {
                Toast.makeText(ctx,
                        done + "/" + components.size() + " component(s) installed",
                        Toast.LENGTH_SHORT).show();
                // Apply settings first (may write broken GPU driver name from config file)
                onComplete.run();
                // Then overwrite pc_ls_GPU_DRIVER_ with the actual registered name
                if (gpuActualName[0] != null && gameId != null && !gameId.isEmpty()) {
                    fixGpuDriverName(ctx, gameId, gpuActualName[0]);
                }
            });
        }).start();
    }

    /**
     * Injects a component and registers it in banners_sources.
     *
     * For GPU components, detects the actual name registered in EmuComponents
     * (the versionName from profile.json inside the .tzst) by comparing the
     * components directory before and after injection. Returns the actual name.
     */
    private static String injectAndRegister(Context ctx, String name, String url,
                                            String type, File dest, Uri uri, int contentType) {
        try {
            // Snapshot component dirs before injection to detect the newly registered name
            File componentsDir = new File(ctx.getFilesDir(), "usr/home/components");
            java.util.Set<String> before = new java.util.HashSet<>();
            if ("GPU".equals(type) && componentsDir.exists()) {
                String[] listing = componentsDir.list();
                if (listing != null) java.util.Collections.addAll(before, listing);
            }

            Class<?> cls = Class.forName(INJECTOR_CLS);
            Method m = cls.getMethod("injectComponent", Context.class, Uri.class, int.class);
            m.invoke(null, ctx, uri, contentType);

            // For GPU: find what name was actually registered (versionName from profile.json)
            String actualName = name;
            if ("GPU".equals(type) && componentsDir.exists()) {
                String[] after = componentsDir.list();
                if (after != null) {
                    for (String n2 : after) {
                        if (!before.contains(n2)) { actualName = n2; break; }
                    }
                }
            }

            SharedPreferences.Editor ed = ctx.getSharedPreferences(SOURCES_SP, Context.MODE_PRIVATE).edit();
            ed.putString(actualName, "BannerHub");
            ed.putString("dl:" + url, "1");
            if (!type.isEmpty()) ed.putString(actualName + ":type", type);
            ed.putString("url_for:" + actualName, url);
            ed.apply();

            dest.delete();
            return actualName;
        } catch (Exception e) {
            Toast.makeText(ctx, "Inject failed: " + name + " — " + e.getMessage(), Toast.LENGTH_LONG).show();
            return name;
        }
    }

    /**
     * Overwrites the name/displayName fields in pc_ls_GPU_DRIVER_ with the actual
     * EmuComponents registry key. Called after applySettings to fix any display-label
     * pollution copied verbatim from the imported config file.
     */
    private static void fixGpuDriverName(Context ctx, String gameId, String actualName) {
        SharedPreferences gameSp = ctx.getSharedPreferences(SP_PREFIX + gameId, Context.MODE_PRIVATE);
        String current = gameSp.getString("pc_ls_GPU_DRIVER_", "");
        if (current.isEmpty()) return;
        try {
            JSONObject obj = new JSONObject(current);
            obj.put("name", actualName);
            obj.put("displayName", actualName);
            gameSp.edit().putString("pc_ls_GPU_DRIVER_", obj.toString()).commit();
        } catch (Exception ignored) {}
    }

    /**
     * Recovers the upload token from a locally saved config file on external storage.
     * Used when the SP record is missing (app reinstall / clear data) but the
     * JSON file still exists in /sdcard/BannerHub/configs/.
     */
    public static String recoverTokenFromFile(Context ctx, String filename) {
        try {
            File f = new File(new File(Environment.getExternalStorageDirectory(), EXPORT_DIR), filename);
            if (!f.exists()) return null;
            char[] buf = new char[(int) f.length()];
            java.io.FileReader fr = new java.io.FileReader(f);
            int n = fr.read(buf); fr.close();
            JSONObject json = new JSONObject(new String(buf, 0, n));
            JSONObject meta = json.optJSONObject("meta");
            if (meta == null) return null;
            String token = meta.optString("upload_token", "");
            return token.isEmpty() ? null : token;
        } catch (Exception ignored) {
            return null;
        }
    }

    private static String detectSoc(Context ctx) {
        // Primary: GameHub's own cached OpenGL renderer string in device_info.xml SP
        try {
            android.content.SharedPreferences sp =
                    ctx.getSharedPreferences("device_info", android.content.Context.MODE_PRIVATE);
            String gpu = sp.getString("gpu_renderer", "");
            if (!gpu.isEmpty()) return gpu;
        } catch (Exception ignored) {}
        // Fallback: kernel sysfs kgsl node
        try {
            BufferedReader br = new BufferedReader(new FileReader("/sys/class/kgsl/kgsl-3d0/gpu_model"));
            String line = br.readLine();
            br.close();
            if (line != null) {
                line = line.trim();
                if (!line.isEmpty()) return line;
            }
        } catch (Exception ignored) {}
        if (Build.VERSION.SDK_INT >= 31 && !Build.SOC_MODEL.equals("unknown")) return Build.SOC_MODEL;
        return Build.HARDWARE;
    }

    private static int typeNameToInt(String type) {
        switch (type) {
            case "DXVK":    return 12;
            case "VKD3D":   return 13;
            case "Box64":   return 94;
            case "FEXCore": return 95;
            case "GPU":     return 10;
            default:        return 12;
        }
    }

    // ─── Frontend Export ─────────────────────────────────────────────────────

    public static void showFrontendExportDialog(Context ctx, String gameId, String gameName) {
        String[] frontends = {"Beacon", "ES-DE"};
        String basePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                .getAbsolutePath() + "/bannerhub/frontend/";

        int px16 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 16, ctx.getResources().getDisplayMetrics());
        int px8  = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,  8, ctx.getResources().getDisplayMetrics());

        LinearLayout titleLayout = new LinearLayout(ctx);
        titleLayout.setOrientation(LinearLayout.VERTICAL);
        titleLayout.setPadding(px16, px16, px16, px8);

        TextView titleTV = new TextView(ctx);
        titleTV.setText("Frontend Export — " + gameName);
        titleTV.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18);
        titleTV.setTypeface(titleTV.getTypeface(), android.graphics.Typeface.BOLD);
        titleLayout.addView(titleTV);

        TextView msgTV = new TextView(ctx);
        msgTV.setText("Select a frontend. The output file will be saved to:\n\n" + basePath);
        msgTV.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
        msgTV.setPadding(0, px8, 0, 0);
        titleLayout.addView(msgTV);

        new AlertDialog.Builder(ctx)
                .setCustomTitle(titleLayout)
                .setItems(frontends, (dialog, which) -> {
                    if (which == 0) exportForBeacon(ctx, gameId, gameName);
                    else if (which == 1) exportForEsde(ctx, gameId, gameName);
                })
                .setNegativeButton("Cancel", null)
                .show();
    }

    private static void exportForBeacon(Context ctx, String gameId, String gameName) {
        try {
            File dir = new File(
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                    "bannerhub/frontend/Beacon");
            dir.mkdirs();
            String safeName = gameName.replaceAll("[\\\\/:*?\"<>|]", "_");
            File out = new File(dir, safeName + ".iso");
            FileWriter fw = new FileWriter(out);
            fw.write(gameId);
            fw.close();
            new Handler(Looper.getMainLooper()).post(() ->
                    Toast.makeText(ctx, "Beacon: saved " + out.getName(), Toast.LENGTH_SHORT).show());
        } catch (Exception e) {
            new Handler(Looper.getMainLooper()).post(() ->
                    Toast.makeText(ctx, "Frontend export failed: " + e.getMessage(), Toast.LENGTH_LONG).show());
        }
    }

    private static void exportForEsde(Context ctx, String gameId, String gameName) {
        try {
            File dir = new File(
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                    "bannerhub/frontend/ES-DE");
            dir.mkdirs();
            String safeName = gameName.replaceAll("[\\\\/:*?\"<>|]", "_");
            File out = new File(dir, safeName + ".steam");
            FileWriter fw = new FileWriter(out);
            fw.write(gameId);
            fw.close();
            new Handler(Looper.getMainLooper()).post(() ->
                    Toast.makeText(ctx, "ES-DE: saved " + out.getName(), Toast.LENGTH_SHORT).show());
        } catch (Exception e) {
            new Handler(Looper.getMainLooper()).post(() ->
                    Toast.makeText(ctx, "Frontend export failed: " + e.getMessage(), Toast.LENGTH_LONG).show());
        }
    }
}
