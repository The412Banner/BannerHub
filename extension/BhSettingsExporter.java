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

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * BhSettingsExporter — per-game settings import/export with component bundling.
 *
 * Export: reads pc_g_setting<gameId> SharedPreferences + installed custom components
 *         → JSON saved as /sdcard/BannerHub/configs/<gamename>-<model>.json
 *
 * Import: applies settings, detects missing components, offers to download+inject them.
 */
public class BhSettingsExporter {
    private static final String SP_PREFIX    = "pc_g_setting";
    private static final String EXPORT_DIR   = "BannerHub/configs";
    private static final String SOURCES_SP   = "banners_sources";
    private static final String INJECTOR_CLS =
            "com.xj.landscape.launcher.ui.menu.ComponentInjectorHelper";

    // ─── Export ──────────────────────────────────────────────────────────────

    public static void exportConfig(Context ctx, int gameId, String gameName) {
        try {
            // Game settings
            SharedPreferences sp = ctx.getSharedPreferences(SP_PREFIX + gameId, Context.MODE_PRIVATE);
            JSONObject settings = new JSONObject();
            for (Map.Entry<String, ?> e : sp.getAll().entrySet()) {
                settings.put(e.getKey(), e.getValue());
            }

            // Installed custom components (those that have a download URL tracked)
            JSONArray components = buildComponentsArray(ctx);

            JSONObject json = new JSONObject();
            json.put("settings", settings);
            json.put("components", components);

            String safeName   = gameName.replaceAll("[^a-zA-Z0-9_\\-]", "_");
            String deviceName = Build.MODEL.replaceAll("[^a-zA-Z0-9_\\-]", "_");
            String fileName   = safeName + "-" + deviceName + ".json";

            File dir = new File(Environment.getExternalStorageDirectory(), EXPORT_DIR);
            dir.mkdirs();
            FileWriter fw = new FileWriter(new File(dir, fileName));
            fw.write(json.toString(2));
            fw.close();

            Toast.makeText(ctx, "Exported: " + fileName, Toast.LENGTH_LONG).show();
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
            // Component name keys are plain strings (no prefix/suffix markers)
            if (key.startsWith("dl:") || key.startsWith("url_for:") || key.endsWith(":type")) continue;
            String name = key;
            String url  = sp.getString("url_for:" + name, "");
            if (url.isEmpty()) continue;  // no tracked URL → skip (manually imported)
            String type = sp.getString(name + ":type", "");
            JSONObject comp = new JSONObject();
            comp.put("name", name);
            comp.put("url",  url);
            comp.put("type", type);
            arr.put(comp);
        }
        return arr;
    }

    // ─── Import ──────────────────────────────────────────────────────────────

    public static void showImportDialog(final Context ctx, final int gameId, final String gameName) {
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
                    .setTitle("Import Config for " + gameName)
                    .setItems(names, (dialog, which) -> applyConfig(ctx, gameId, gameName, finalFiles[which]))
                    .setNegativeButton("Cancel", null)
                    .show();
        } catch (Exception e) {
            Toast.makeText(ctx, "Import error: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    private static void applyConfig(Context ctx, int gameId, String gameName, File configFile) {
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

                    // Inject on UI thread (injectComponent shows Toast — needs UI thread)
                    Uri uri = Uri.fromFile(dest);
                    int contentType = typeNameToInt(type);
                    final String fn = name;
                    final String fu = url;
                    final String ft = type;
                    final File   fd = dest;
                    ui.post(() -> injectAndRegister(ctx, fn, fu, ft, fd, uri, contentType));
                    success++;

                    Thread.sleep(600); // let UI thread process between components
                } catch (Exception e) {
                    final String msg = e.getMessage();
                    ui.post(() -> Toast.makeText(ctx,
                            "Failed to download: " + name + (msg != null ? " — " + msg : ""),
                            Toast.LENGTH_LONG).show());
                }
            }
            // All injectAndRegister posts are already queued before this post,
            // so onComplete runs after all injections complete on the UI thread
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
            // Call ComponentInjectorHelper.injectComponent via reflection
            // (it lives in smali_classes16, not available at javac compile time)
            Class<?> cls = Class.forName(INJECTOR_CLS);
            Method m = cls.getMethod("injectComponent", Context.class, Uri.class, int.class);
            m.invoke(null, ctx, uri, contentType);

            // Register in banners_sources SP (same keys ComponentDownloadActivity$5 writes)
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
