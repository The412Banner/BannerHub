package app.revanced.extension.gamehub;

import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
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

    // ─── Export entry point ──────────────────────────────────────────────────

    public static void showExportDialog(Context ctx, int gameId, String gameName) {
        new AlertDialog.Builder(ctx)
                .setTitle("Export Config — " + gameName)
                .setItems(new String[]{"Save Locally", "Save Locally + Share Online"},
                        (dialog, which) -> {
                            boolean share = (which == 1);
                            doExport(ctx, gameId, gameName, share);
                        })
                .setNegativeButton("Cancel", null)
                .show();
    }

    // kept for backward compatibility (called from existing smali injection)
    public static void exportConfig(Context ctx, int gameId, String gameName) {
        showExportDialog(ctx, gameId, gameName);
    }

    private static void doExport(Context ctx, int gameId, String gameName, boolean share) {
        try {
            // Game settings
            SharedPreferences sp = ctx.getSharedPreferences(SP_PREFIX + gameId, Context.MODE_PRIVATE);
            JSONObject settings = new JSONObject();
            for (Map.Entry<String, ?> e : sp.getAll().entrySet()) {
                settings.put(e.getKey(), e.getValue());
            }

            // Installed custom components (those that have a download URL tracked)
            JSONArray components = buildComponentsArray(ctx);

            // Meta block — parsed and shown in BhGameConfigsActivity detail view
            JSONObject meta = new JSONObject();
            meta.put("device",           Build.MANUFACTURER + " " + Build.MODEL);
            meta.put("soc",              detectSoc(ctx));
            meta.put("bh_version",       "2.8.8");
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

            // Save locally
            File dir = new File(Environment.getExternalStorageDirectory(), EXPORT_DIR);
            dir.mkdirs();
            File localFile = new File(dir, fileName);
            FileWriter fw = new FileWriter(localFile);
            fw.write(json.toString(2));
            fw.close();
            Toast.makeText(ctx, "Saved: " + fileName, Toast.LENGTH_LONG).show();

            if (share) {
                // Upload in background
                String jsonStr = json.toString();
                // Generate a random token so the uploader can later edit the description
                String uploadToken = Long.toHexString(new Random().nextLong() & Long.MAX_VALUE);
                String uploadDate  = new java.text.SimpleDateFormat("yyyy-MM-dd",
                        java.util.Locale.US).format(new java.util.Date());

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

    /** Read installed components from banners_sources SP into a JSON array. */
    private static JSONArray buildComponentsArray(Context ctx) throws Exception {
        SharedPreferences sp = ctx.getSharedPreferences(SOURCES_SP, Context.MODE_PRIVATE);
        JSONArray arr = new JSONArray();
        for (Map.Entry<String, ?> e : sp.getAll().entrySet()) {
            String key = e.getKey();
            if (key.startsWith("dl:") || key.startsWith("url_for:") || key.endsWith(":type")) continue;
            String name = key;
            String url  = sp.getString("url_for:" + name, "");
            if (url.isEmpty()) continue;
            String type = sp.getString(name + ":type", "");
            JSONObject comp = new JSONObject();
            comp.put("name", name);
            comp.put("url",  url);
            comp.put("type", type);
            arr.put(comp);
        }
        return arr;
    }

    // ─── Import entry point ──────────────────────────────────────────────────

    public static void showImportDialog(final Context ctx, final int gameId, final String gameName) {
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

    private static void showLocalImportDialog(Context ctx, int gameId, String gameName) {
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
                            applyConfig(ctx, gameId, gameName, finalFiles[which]))
                    .setNegativeButton("Cancel", null)
                    .show();
        } catch (Exception e) {
            Toast.makeText(ctx, "Import error: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    // ─── Community import ────────────────────────────────────────────────────

    private static void showCommunityImportDialog(Context ctx, int gameId, String gameName) {
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

    private static void downloadAndImport(Context ctx, int gameId, String gameName,
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

    static void applyConfig(Context ctx, int gameId, String gameName, File configFile) {
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
                            downloadMissingComponents(ctx, missing, applySettings))
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
                                                   Runnable onComplete) {
        Toast.makeText(ctx, "Downloading " + components.size() + " component(s)...", Toast.LENGTH_LONG).show();
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
                    ui.post(() -> injectAndRegister(ctx, fn, fu, ft, fd, uri, contentType));
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
                onComplete.run();
            });
        }).start();
    }

    private static void injectAndRegister(Context ctx, String name, String url,
                                          String type, File dest, Uri uri, int contentType) {
        try {
            Class<?> cls = Class.forName(INJECTOR_CLS);
            Method m = cls.getMethod("injectComponent", Context.class, Uri.class, int.class);
            m.invoke(null, ctx, uri, contentType);

            SharedPreferences.Editor ed = ctx.getSharedPreferences(SOURCES_SP, Context.MODE_PRIVATE).edit();
            ed.putString(name, "BannerHub");
            ed.putString("dl:" + url, "1");
            if (!type.isEmpty()) ed.putString(name + ":type", type);
            ed.putString("url_for:" + name, url);
            ed.apply();

            dest.delete();
        } catch (Exception e) {
            Toast.makeText(ctx, "Inject failed: " + name + " — " + e.getMessage(), Toast.LENGTH_LONG).show();
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
}
