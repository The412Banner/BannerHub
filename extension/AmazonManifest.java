package app.revanced.extension.gamehub;

import android.util.Log;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Amazon Games manifest.proto parser.
 *
 * Binary wire format:
 *   Bytes 0-3:      big-endian uint32 = headerSize
 *   Bytes 4..4+headerSize-1: ManifestHeader protobuf
 *   Bytes 4+headerSize..:   body bytes (LZMA or XZ compressed)
 *
 * ManifestHeader:      field 1 = CompressionSettings (len-delimited)
 * CompressionSettings: field 1 = algorithm (varint; 0=none, 1=LZMA)
 *
 * Body decompression:
 *   First two bytes 0xFD 0x37 → XZInputStream(body, -1)
 *   Otherwise                 → LZMAInputStream(body, -1)
 *
 * Decompressed body is a Manifest protobuf:
 *   Manifest:  field 1 = repeated Package (len-delimited)
 *   Package:   field 1 = name (string), field 2 = repeated File (len-delimited)
 *   File:      field 1 = path (Windows backslash string), field 3 = size (varint int64),
 *              field 5 = Hash (len-delimited)
 *   Hash:      field 1 = algorithm (varint, 0=SHA-256), field 2 = value (bytes)
 *
 * Note: org.tukaani.xz is built into GameHub and not obfuscated.
 */
public class AmazonManifest {

    private static final String TAG = "BH_AMAZON";

    // ── Data classes ──────────────────────────────────────────────────────────

    public static class ManifestFile {
        public final String path;           // original (may have backslashes)
        public final long   size;
        public final int    hashAlgorithm;  // 0 = SHA-256
        public final byte[] hashBytes;

        ManifestFile(String path, long size, int hashAlgorithm, byte[] hashBytes) {
            this.path          = path;
            this.size          = size;
            this.hashAlgorithm = hashAlgorithm;
            this.hashBytes     = hashBytes;
        }

        /** Unix path — backslashes replaced with forward slashes */
        public String unixPath() {
            return path.replace('\\', '/');
        }

        /** Lowercase hex of hash bytes (unsigned, and 0xFF applied per byte) */
        public String hashHex() {
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b & 0xFF));
            }
            return sb.toString();
        }
    }

    public static class ManifestPackage {
        public final String           name;
        public final List<ManifestFile> files;

        ManifestPackage(String name, List<ManifestFile> files) {
            this.name  = name;
            this.files = files;
        }
    }

    public static class ParsedManifest {
        public final List<ManifestPackage> packages;
        public final List<ManifestFile>    allFiles;
        public final long                  totalInstallSize;

        ParsedManifest(List<ManifestPackage> packages) {
            this.packages = packages;
            List<ManifestFile> all = new ArrayList<>();
            long total = 0;
            for (ManifestPackage pkg : packages) {
                all.addAll(pkg.files);
                for (ManifestFile f : pkg.files) total += f.size;
            }
            this.allFiles         = all;
            this.totalInstallSize = total;
        }
    }

    // ── Public entry point ────────────────────────────────────────────────────

    public static ParsedManifest parse(byte[] data) throws IOException {
        if (data == null || data.length < 4) {
            throw new IOException("Manifest too short: " + (data == null ? 0 : data.length));
        }

        // 4-byte big-endian headerSize
        int headerSize = ByteBuffer.wrap(data, 0, 4).order(ByteOrder.BIG_ENDIAN).getInt();
        if (headerSize < 0 || 4 + headerSize > data.length) {
            throw new IOException("Invalid headerSize: " + headerSize);
        }

        // Parse ManifestHeader (just need compression algorithm)
        byte[] headerBytes = Arrays.copyOfRange(data, 4, 4 + headerSize);
        int compressionAlgo = parseCompressionAlgo(headerBytes);

        // Decompress body
        byte[] bodyBytes = Arrays.copyOfRange(data, 4 + headerSize, data.length);
        byte[] manifestBytes = decompress(bodyBytes, compressionAlgo);

        // Parse Manifest protobuf
        return parseManifest(manifestBytes);
    }

    // ── Manifest header: extract compression algorithm ────────────────────────

    private static int parseCompressionAlgo(byte[] bytes) {
        // ManifestHeader: field 1 (wire type 2) = CompressionSettings
        // CompressionSettings: field 1 (wire type 0) = algorithm varint
        ProtoReader header = new ProtoReader(bytes);
        while (header.hasMore()) {
            int tag = (int) header.readVarint();
            int field = tag >>> 3;
            int wire  = tag & 0x7;
            if (field == 1 && wire == 2) {
                byte[] csBytes = header.readBytes();
                ProtoReader cs = new ProtoReader(csBytes);
                while (cs.hasMore()) {
                    int t2 = (int) cs.readVarint();
                    int f2 = t2 >>> 3;
                    int w2 = t2 & 0x7;
                    if (f2 == 1 && w2 == 0) {
                        return (int) cs.readVarint(); // algorithm
                    } else {
                        cs.skip(w2);
                    }
                }
            } else {
                header.skip(wire);
            }
        }
        return 1; // default: LZMA
    }

    // ── Decompression ─────────────────────────────────────────────────────────
    //
    // org.tukaani.xz (XZInputStream, LZMAInputStream) is built into GameHub
    // but NOT in the compile-time classpath (only android.jar is available to
    // javac in CI). Access via reflection so the class compiles with javac.

    private static byte[] decompress(byte[] body, int algo) throws IOException {
        if (body.length < 2) return body;

        // XZ magic: 0xFD 0x37
        boolean isXz = ((body[0] & 0xFF) == 0xFD) && ((body[1] & 0xFF) == 0x37);

        InputStream decompressed = createDecompressStream(body, isXz);

        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        byte[] buf = new byte[65536];
        int n;
        while ((n = decompressed.read(buf)) >= 0) {
            bos.write(buf, 0, n);
        }
        decompressed.close();
        return bos.toByteArray();
    }

    private static InputStream createDecompressStream(byte[] body, boolean isXz)
            throws IOException {
        String className = isXz
                ? "org.tukaani.xz.XZInputStream"
                : "org.tukaani.xz.LZMAInputStream";
        try {
            Class<?> cls  = Class.forName(className);
            java.lang.reflect.Constructor<?> ctor =
                    cls.getConstructor(InputStream.class, int.class);
            return (InputStream) ctor.newInstance(
                    new ByteArrayInputStream(body), -1);
        } catch (Exception e) {
            throw new IOException("Cannot create " + className
                    + " (org.tukaani.xz not available?): " + e.getMessage(), e);
        }
    }

    // ── Manifest protobuf parser ──────────────────────────────────────────────

    private static ParsedManifest parseManifest(byte[] bytes) {
        List<ManifestPackage> packages = new ArrayList<>();
        ProtoReader r = new ProtoReader(bytes);
        while (r.hasMore()) {
            int tag   = (int) r.readVarint();
            int field = tag >>> 3;
            int wire  = tag & 0x7;
            if (field == 1 && wire == 2) {
                byte[] pkgBytes = r.readBytes();
                ManifestPackage pkg = parsePackage(pkgBytes);
                if (pkg != null) packages.add(pkg);
            } else {
                r.skip(wire);
            }
        }
        return new ParsedManifest(packages);
    }

    private static ManifestPackage parsePackage(byte[] bytes) {
        String name = "";
        List<ManifestFile> files = new ArrayList<>();
        ProtoReader r = new ProtoReader(bytes);
        while (r.hasMore()) {
            int tag   = (int) r.readVarint();
            int field = tag >>> 3;
            int wire  = tag & 0x7;
            if (field == 1 && wire == 2) {
                name = r.readString();
            } else if (field == 2 && wire == 2) {
                byte[] fileBytes = r.readBytes();
                ManifestFile f = parseFile(fileBytes);
                if (f != null) files.add(f);
            } else {
                r.skip(wire); // field 3 = Dir (ignored)
            }
        }
        return new ManifestPackage(name, files);
    }

    private static ManifestFile parseFile(byte[] bytes) {
        String path = "";
        long   size = 0L;
        int    hashAlgo  = 0;
        byte[] hashValue = new byte[0];

        ProtoReader r = new ProtoReader(bytes);
        while (r.hasMore()) {
            int tag   = (int) r.readVarint();
            int field = tag >>> 3;
            int wire  = tag & 0x7;
            if (field == 1 && wire == 2) {
                path = r.readString();
            } else if (field == 3 && wire == 0) {
                size = r.readVarint();
            } else if (field == 5 && wire == 2) {
                byte[] hashBytes = r.readBytes();
                int[] ha = parseHash(hashBytes);
                hashAlgo  = ha[0];
                // hash value bytes already in out[1..] — re-read
                ProtoReader hr = new ProtoReader(hashBytes);
                while (hr.hasMore()) {
                    int ht = (int) hr.readVarint();
                    int hf = ht >>> 3;
                    int hw = ht & 0x7;
                    if (hf == 2 && hw == 2) {
                        hashValue = hr.readBytes();
                    } else {
                        hr.skip(hw);
                    }
                }
            } else {
                r.skip(wire);
            }
        }

        if (path.isEmpty()) return null;
        return new ManifestFile(path, size, hashAlgo, hashValue);
    }

    private static int[] parseHash(byte[] bytes) {
        int algo = 0;
        ProtoReader r = new ProtoReader(bytes);
        while (r.hasMore()) {
            int tag   = (int) r.readVarint();
            int field = tag >>> 3;
            int wire  = tag & 0x7;
            if (field == 1 && wire == 0) {
                algo = (int) r.readVarint();
            } else {
                r.skip(wire);
            }
        }
        return new int[]{algo};
    }

    // ── Minimal protobuf reader ───────────────────────────────────────────────

    private static final class ProtoReader {
        private final byte[] buf;
        private int pos;

        ProtoReader(byte[] buf) { this.buf = buf; this.pos = 0; }

        boolean hasMore() { return pos < buf.length; }

        long readVarint() {
            long result = 0;
            int shift = 0;
            while (pos < buf.length) {
                int b = buf[pos++] & 0xFF;
                result |= (long) (b & 0x7F) << shift;
                if ((b & 0x80) == 0) break;
                shift += 7;
            }
            return result;
        }

        byte[] readBytes() {
            int len = (int) readVarint();
            if (len < 0 || pos + len > buf.length) return new byte[0];
            byte[] out = Arrays.copyOfRange(buf, pos, pos + len);
            pos += len;
            return out;
        }

        String readString() {
            return new String(readBytes(), java.nio.charset.StandardCharsets.UTF_8);
        }

        void skip(int wireType) {
            switch (wireType) {
                case 0: readVarint();          break; // varint
                case 1: pos += 8;              break; // 64-bit
                case 2: readBytes();           break; // length-delimited
                case 5: pos += 4;              break; // 32-bit
                default: pos = buf.length;     break; // unknown — abort
            }
        }
    }
}
