package com.xj.winemu.sidebar;

import android.content.Context;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.nio.ByteOrder;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.charset.StandardCharsets;

/**
 * Writes AI Frame Generation settings to the 10-byte mmap file at
 * <imageFs>/etc/gamescope.control. Mirrors GameHub 6.0.1 IPC layout per
 * GAMEHUB_600_MASTER_MAP § 26.8.3.
 *
 * Byte layout (LE):
 *   0-1: uint16 FPS limit            — owned by separate sidebar control, NOT touched here
 *   2:   enabled flag (0/1)
 *   3:   NativeRenderingMode         — owned by host launcher, NOT touched here
 *   4-7: float flowScale (clamped 0.2..1.0)
 *   8:   AI model byte (0=standard, 1=clear)
 *   9:   AI multiplier byte (always 2x)
 */
public class BhFrameGenWriter {

    /** Apply persisted settings to the gamescope.control file. Call right before the
     *  Wine container reads the file (e.g. just before launch). Also rewrites the
     *  Vulkan ICD JSON so libGameScopeVK.so resolves under the actually-installed
     *  package (upstream firmware ships a hardcoded /data/data/com.winemu/... path). */
    public static void applyFromPrefs(Context ctx) {
        BhFrameGenSettings s = BhFrameGenSettings.load(ctx);
        write(resolveControlPath(ctx), s);
        ensureIcdJsonForCurrentPackage(ctx);
    }

    /** Apply settings without requiring a Context from the caller — looks up the app
     *  context via ActivityThread reflection. Used by the launch-time smali hook. */
    public static void applyFromPrefsNoContext() {
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Object app = at.getMethod("currentApplication").invoke(null);
            if (app instanceof Context) {
                applyFromPrefs((Context) app);
            }
        } catch (Exception ignored) {}
    }

    /** Write our owned bytes (2, 4-7, 8, 9) to gamescope.control. Bytes 0-1 (FPS limit)
     *  and byte 3 (NativeRenderingMode) are owned by other components and left alone. */
    public static void write(String controlPath, BhFrameGenSettings s) {
        if (controlPath == null || controlPath.isEmpty() || s == null) return;
        try {
            File f = new File(controlPath);
            File parent = f.getParentFile();
            if (parent != null) parent.mkdirs();
            try (RandomAccessFile raf = new RandomAccessFile(f, "rw")) {
                if (raf.length() < 10) raf.setLength(10);
                FileChannel ch = raf.getChannel();
                MappedByteBuffer buf = ch.map(FileChannel.MapMode.READ_WRITE, 0, 10);
                buf.order(ByteOrder.LITTLE_ENDIAN);

                buf.put(2, (byte) (s.enabled ? 1 : 0));
                buf.putFloat(4, clampFloat(s.flowScale, 0.2f, 1.0f));
                buf.put(8, (byte) (s.model & 0x01));
                buf.put(9, (byte) 2);  // multiplier always 2x
                buf.force();
            }
        } catch (Exception ignored) {}
    }

    /** Write only the enabled byte (byte 2). */
    public static void writeEnabled(String controlPath, boolean enabled) {
        writeByteAt(controlPath, 2, (byte) (enabled ? 1 : 0));
    }

    /** Write only the AI model byte (byte 8). */
    public static void writeModel(String controlPath, int model) {
        writeByteAt(controlPath, 8, (byte) (model & 0x01));
    }

    /** Write only the flowScale float (bytes 4-7). */
    public static void writeFlowScale(String controlPath, float flowScale) {
        try (RandomAccessFile raf = new RandomAccessFile(controlPath, "rw")) {
            if (raf.length() < 10) raf.setLength(10);
            MappedByteBuffer buf = raf.getChannel().map(FileChannel.MapMode.READ_WRITE, 0, 10);
            buf.order(ByteOrder.LITTLE_ENDIAN);
            buf.putFloat(4, clampFloat(flowScale, 0.2f, 1.0f));
            buf.force();
        } catch (Exception ignored) {}
    }

    /** Resolve the gamescope.control path for the running BannerHub install. */
    public static String resolveControlPath(Context ctx) {
        String pkg = ctx.getPackageName();
        return "/data/data/" + pkg + "/files/usr/etc/gamescope.control";
    }

    /** Resolve the GameScopeVK_icd.json path for the running BannerHub install. */
    public static String resolveIcdJsonPath(Context ctx) {
        String pkg = ctx.getPackageName();
        return "/data/data/" + pkg
                + "/files/usr/home/steamuser/.config/vulkan/icd.d/GameScopeVK_icd.json";
    }

    /** Resolve the libGameScopeVK.so path for the running BannerHub install. */
    public static String resolveIcdLibraryPath(Context ctx) {
        String pkg = ctx.getPackageName();
        return "/data/data/" + pkg + "/files/usr/lib/libGameScopeVK.so";
    }

    /** Rewrite the Vulkan ICD JSON so library_path points at libGameScopeVK.so under
     *  the running package. Upstream firmware ships /data/data/com.winemu/... which
     *  doesn't exist on real installs (BannerHub forks use varying package IDs).
     *  Idempotent: only writes if contents differ. */
    public static void ensureIcdJsonForCurrentPackage(Context ctx) {
        ensureGameScopeVkLib(ctx);
        try {
            String libPath = resolveIcdLibraryPath(ctx);
            File so = new File(libPath);
            if (!so.exists()) return;
            String desired =
                    "{\n"
                  + "  \"file_format_version\": \"1.0.0\",\n"
                  + "  \"ICD\": {\n"
                  + "    \"library_path\": \"" + libPath + "\",\n"
                  + "    \"api_version\": \"1.3.216\"\n"
                  + "  }\n"
                  + "}\n";
            File icd = new File(resolveIcdJsonPath(ctx));
            File parent = icd.getParentFile();
            if (parent != null) parent.mkdirs();
            if (icd.exists() && icd.length() == desired.getBytes(StandardCharsets.UTF_8).length) {
                byte[] cur = new byte[(int) icd.length()];
                try (java.io.FileInputStream fis = new java.io.FileInputStream(icd)) {
                    int read = 0, n;
                    while (read < cur.length
                            && (n = fis.read(cur, read, cur.length - read)) > 0) {
                        read += n;
                    }
                }
                if (new String(cur, StandardCharsets.UTF_8).equals(desired)) return;
            }
            try (FileOutputStream fos = new FileOutputStream(icd)) {
                fos.write(desired.getBytes(StandardCharsets.UTF_8));
            }
        } catch (Exception ignored) {}
    }

    /** Bundled copy of the firmware 1.3.7–1.4.2 libGameScopeVK.so (md5 9447d8df…). */
    static final String BUNDLED_VK_ASSET = "bannerhub/libGameScopeVK.so";

    /** Firmware 1.4.8+ deletes usr/lib/libGameScopeVK.so but still ships the steamuser
     *  Vulkan ICD JSON pointing at it, so every game starts with no Vulkan driver (and
     *  the AI frame-gen engine that lives in that lib is gone). Put our bundled copy back
     *  whenever it is missing. Never replaces a lib the firmware itself provides. */
    public static void ensureGameScopeVkLib(Context ctx) {
        try {
            File so = new File(resolveIcdLibraryPath(ctx));
            if (so.isFile() && so.length() > 0) return;
            File libDir = so.getParentFile();
            if (libDir == null || !libDir.isDirectory()) return;   // firmware not installed yet
            File tmp = new File(libDir, so.getName() + ".bhtmp");
            try (InputStream in = ctx.getAssets().open(BUNDLED_VK_ASSET);
                 FileOutputStream out = new FileOutputStream(tmp)) {
                byte[] buf = new byte[64 * 1024];
                int n;
                while ((n = in.read(buf)) > 0) out.write(buf, 0, n);
            }
            tmp.setReadable(true, false);
            tmp.setExecutable(true, false);
            if (!tmp.renameTo(so)) tmp.delete();
        } catch (Exception ignored) {}
    }

    private static void writeByteAt(String controlPath, int offset, byte value) {
        try (RandomAccessFile raf = new RandomAccessFile(controlPath, "rw")) {
            if (raf.length() < 10) raf.setLength(10);
            MappedByteBuffer buf = raf.getChannel().map(FileChannel.MapMode.READ_WRITE, 0, 10);
            buf.put(offset, value);
            buf.force();
        } catch (Exception ignored) {}
    }

    private static int clampInt(int v, int lo, int hi) {
        return Math.max(lo, Math.min(hi, v));
    }

    private static float clampFloat(float v, float lo, float hi) {
        return Math.max(lo, Math.min(hi, v));
    }
}
