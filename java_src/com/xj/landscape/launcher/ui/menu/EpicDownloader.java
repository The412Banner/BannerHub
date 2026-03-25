package com.xj.landscape.launcher.ui.menu;

import android.util.Log;

import android.content.Context;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.Inflater;

/**
 * Epic Games download pipeline — ported from GameNative EpicDownloadManager + EpicManifest.
 * Handles manifest parsing, chunk downloads with CDN rotation, and file assembly.
 * All methods are static; called from EpicMainActivity$7.
 */
public class EpicDownloader {

    private static final String TAG = "EpicDownloader";
    private static final String UA = "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit";

    // ── Data classes ─────────────────────────────────────────────────────────

    /** One CDN entry from the manifest API response. */
    public static class CdnUrl {
        public final String baseUrl;       // e.g. "https://egdownload.fastly-edge.com"
        public final String cloudDir;      // e.g. "/Builds/Org/o-xxx/yyy/default"
        public final String authParams;    // e.g. "?f_token=..." or ""

        public CdnUrl(String baseUrl, String cloudDir, String authParams) {
            this.baseUrl = baseUrl;
            this.cloudDir = cloudDir;
            this.authParams = authParams;
        }
    }

    /** Chunk info from ChunkDataList section. */
    public static class ChunkInfo {
        public int[] guid = new int[4]; // 4 uint32, stored in binary read order
        public long hash;               // uint64 stored as signed long
        public int groupNum;            // uint8 subfolder (decimal)
        public int windowSize;          // uncompressed size
        public long fileSize;           // compressed download size

        /** Hex string used for chunk cache filename and URL. Matches GameNative guidHex. */
        public String guidStr() {
            return String.format("%08X%08X%08X%08X", guid[0], guid[1], guid[2], guid[3]);
        }

        /** Full chunk path relative to cloudDir, e.g. "ChunksV4/94/HASH_GUID.chunk". */
        public String getPath(String chunkDir) {
            String sub = String.format("%02d", groupNum);
            String hashHex = String.format("%016X", hash);
            return chunkDir + "/" + sub + "/" + hashHex + "_" + guidStr() + ".chunk";
        }
    }

    /** One part of a file, sourced from a specific chunk. */
    public static class ChunkPart {
        public int[] guid = new int[4]; // matches ChunkInfo.guid
        public int offset;              // byte offset within decompressed chunk data
        public int size;                // number of bytes to copy

        public String guidStr() {
            return String.format("%08X%08X%08X%08X", guid[0], guid[1], guid[2], guid[3]);
        }
    }

    /** One file from FileManifestList section. */
    public static class FileInfo {
        public String filename = "";
        public List<ChunkPart> parts = new ArrayList<>();
    }

    /** Parsed manifest result. */
    public static class ParsedManifest {
        public String chunkDir = "ChunksV4";
        public List<ChunkInfo> uniqueChunks = new ArrayList<>();  // deduplicated
        public List<FileInfo> files = new ArrayList<>();
    }

    // ── Main entry point ─────────────────────────────────────────────────────

    /**
     * Download and install an Epic game.
     *
     * @param manifestApiJson  Raw JSON string from the Epic manifest API response
     * @param bearerToken      "Bearer <token>" for API/manifest auth (not used on chunk URLs)
     * @param installDirPath   Absolute path where game files should be written
     * @param progressCallback Optional callback for progress strings (may be null)
     * @return true on success, false on any failure
     */
    public static boolean install(
            String manifestApiJson,
            String bearerToken,
            String installDirPath,
            ProgressCallback progressCallback,
            Context ctx) {
        try {
            dbg(ctx, "install() entered");
            progress(progressCallback, "Parsing CDN URLs...");

            // 1. Parse all CDN entries from the API response.
            List<CdnUrl> cdnUrls = parseCdnUrls(manifestApiJson);
            dbg(ctx, "parseCdnUrls: " + cdnUrls.size() + " CDNs");
            if (cdnUrls.isEmpty()) {
                dbg(ctx, "ERROR: no CDN URLs in API response");
                Log.e(TAG, "No CDN URLs in manifest API response");
                return false;
            }
            for (CdnUrl c : cdnUrls) {
                dbg(ctx, "  CDN: " + c.baseUrl);
                Log.i(TAG, "  CDN: " + c.baseUrl + "  auth: " + (c.authParams.isEmpty() ? "(none)" : "YES"));
            }

            // 2. Download manifest binary.
            progress(progressCallback, "Downloading manifest...");
            byte[] manifestBytes = downloadManifest(manifestApiJson, bearerToken, cdnUrls);
            if (manifestBytes == null) {
                dbg(ctx, "ERROR: manifest download failed");
                Log.e(TAG, "Failed to download manifest binary");
                return false;
            }
            dbg(ctx, "manifest bytes: " + manifestBytes.length + " first=" + (manifestBytes[0] & 0xFF));
            Log.i(TAG, "Manifest bytes: " + manifestBytes.length);

            // 3. Parse manifest → chunk list + file list.
            progress(progressCallback, "Parsing manifest...");
            ParsedManifest manifest = parseManifest(manifestBytes);
            if (manifest == null) {
                dbg(ctx, "ERROR: manifest parse failed");
                Log.e(TAG, "Failed to parse manifest");
                return false;
            }
            dbg(ctx, "manifest parsed: chunkDir=" + manifest.chunkDir
                    + " chunks=" + manifest.uniqueChunks.size()
                    + " files=" + manifest.files.size());
            Log.i(TAG, "Manifest: chunkDir=" + manifest.chunkDir
                    + " chunks=" + manifest.uniqueChunks.size()
                    + " files=" + manifest.files.size());

            // 4. Download unique chunks to .chunks/ cache directory.
            File installDir = new File(installDirPath);
            installDir.mkdirs();
            File chunkCacheDir = new File(installDir, ".chunks");
            chunkCacheDir.mkdirs();

            int totalChunks = manifest.uniqueChunks.size();
            int doneChunks = 0;
            for (ChunkInfo chunk : manifest.uniqueChunks) {
                File cachedFile = new File(chunkCacheDir, chunk.guidStr());
                if (!cachedFile.exists()) {
                    if (doneChunks == 0) {
                        // Log first chunk URL for diagnosis
                        String firstChunkPath = chunk.getPath(manifest.chunkDir);
                        String firstCdnBase = cdnUrls.get(0).baseUrl + cdnUrls.get(0).cloudDir;
                        dbg(ctx, "first chunk: " + firstCdnBase + "/" + firstChunkPath);
                    }
                    if (!downloadChunk(chunk, manifest.chunkDir, cdnUrls, cachedFile)) {
                        dbg(ctx, "ERROR: chunk download failed: " + chunk.guidStr());
                        Log.e(TAG, "Failed to download chunk " + chunk.guidStr());
                        return false;
                    }
                }
                doneChunks++;
                if (doneChunks % 500 == 0 || doneChunks == totalChunks) {
                    progress(progressCallback, "Downloading chunks (" + doneChunks + "/" + totalChunks + ")");
                }
            }

            // 5. Assemble files from cached chunk data.
            progress(progressCallback, "Assembling files...");
            int totalFiles = manifest.files.size();
            int doneFiles = 0;
            for (FileInfo file : manifest.files) {
                // Normalise path separator (Windows backslash → Unix slash)
                String relPath = file.filename.replace("\\", "/");
                File outFile = new File(installDir, relPath);
                File parent = outFile.getParentFile();
                if (parent != null) parent.mkdirs();

                FileOutputStream fos = new FileOutputStream(outFile);
                BufferedOutputStream bos = new BufferedOutputStream(fos, 65536);
                try {
                    for (ChunkPart part : file.parts) {
                        File cachedChunk = new File(chunkCacheDir, part.guidStr());
                        if (!cachedChunk.exists()) {
                            bos.close();
                            Log.e(TAG, "Missing cached chunk " + part.guidStr() + " for file " + relPath);
                            return false;
                        }
                        byte[] chunkData = readFile(cachedChunk);
                        bos.write(chunkData, part.offset, part.size);
                    }
                } finally {
                    bos.close();
                }

                doneFiles++;
                if (doneFiles % 200 == 0 || doneFiles == totalFiles) {
                    progress(progressCallback, "Assembling files (" + doneFiles + "/" + totalFiles + ")");
                }
            }

            // 6. Clean up chunk cache.
            deleteDir(chunkCacheDir);

            Log.i(TAG, "Install complete!");
            return true;

        } catch (Exception e) {
            Log.e(TAG, "Install failed: " + e.getMessage(), e);
            return false;
        }
    }

    // ── CDN URL parsing ───────────────────────────────────────────────────────

    /**
     * Extract all CDN entries from the manifest API JSON.
     * Skips cloudflare.epicgamescdn.com — keeps Fastly, Akamai, download.epicgames.com.
     * Each entry includes the authParams (queryParams) for that CDN.
     */
    public static List<CdnUrl> parseCdnUrls(String json) {
        List<CdnUrl> result = new ArrayList<>();
        try {
            int manifestsIdx = json.indexOf("\"manifests\"");
            if (manifestsIdx < 0) return result;
            int arrStart = json.indexOf("[", manifestsIdx);
            if (arrStart < 0) return result;

            // Each "manifests" array element contains "uri" and "queryParams".
            // We iterate by finding each "uri" key.
            int cursor = arrStart + 1;
            while (true) {
                // Find next object boundary (entries are separated by "},{")
                int objStart = cursor;

                // Find "uri" key
                int uriKeyIdx = json.indexOf("\"uri\"", cursor);
                if (uriKeyIdx < 0) break;

                // Value: first quote after the colon
                int colon = json.indexOf(":", uriKeyIdx + 5);
                if (colon < 0) break;
                int q1 = json.indexOf("\"", colon + 1);
                if (q1 < 0) break;
                int q2 = json.indexOf("\"", q1 + 1);
                if (q2 < 0) break;
                String uri = json.substring(q1 + 1, q2);
                cursor = q2 + 1;

                // Find /Builds boundary
                int buildsIdx = uri.indexOf("/Builds");
                if (buildsIdx < 0) continue;

                String baseUrl = uri.substring(0, buildsIdx);
                if (!baseUrl.startsWith("http")) continue;

                // Skip broken Cloudflare CDN
                if (baseUrl.contains("cloudflare.epicgamescdn.com")) continue;

                // Extract cloudDir: path from /Builds up to (but not including) manifest filename
                String afterBase = uri.substring(buildsIdx);
                // Strip any query string from the URI path
                int qMark = afterBase.indexOf("?");
                if (qMark >= 0) afterBase = afterBase.substring(0, qMark);
                int lastSlash = afterBase.lastIndexOf("/");
                if (lastSlash < 0) continue;
                String cloudDir = afterBase.substring(0, lastSlash);

                // Extract queryParams for this CDN entry.
                // "queryParams": [{"name":"f_token","value":"..."}]
                String authParams = extractQueryParams(json, uriKeyIdx);

                result.add(new CdnUrl(baseUrl, cloudDir, authParams));
            }
        } catch (Exception e) {
            Log.e(TAG, "parseCdnUrls error: " + e.getMessage());
        }
        return result;
    }

    /**
     * Extract queryParams array near the given position and build "?name=value&..." string.
     * Returns "" if no queryParams found.
     */
    private static String extractQueryParams(String json, int nearPos) {
        try {
            // Find "queryParams" key within the same object (within ~2000 chars)
            int end = Math.min(json.length(), nearPos + 2000);
            int qpIdx = json.indexOf("\"queryParams\"", nearPos);
            if (qpIdx < 0 || qpIdx > end) return "";
            int arrOpen = json.indexOf("[", qpIdx);
            if (arrOpen < 0) return "";
            int arrClose = json.indexOf("]", arrOpen);
            if (arrClose < 0) return "";
            String arrContent = json.substring(arrOpen + 1, arrClose).trim();
            if (arrContent.isEmpty()) return "";

            StringBuilder sb = new StringBuilder("?");
            boolean first = true;
            int pos = 0;
            while (pos < arrContent.length()) {
                // Find "name"
                int nameIdx = arrContent.indexOf("\"name\"", pos);
                if (nameIdx < 0) break;
                int nColon = arrContent.indexOf(":", nameIdx + 6);
                if (nColon < 0) break;
                int nq1 = arrContent.indexOf("\"", nColon + 1);
                if (nq1 < 0) break;
                int nq2 = arrContent.indexOf("\"", nq1 + 1);
                if (nq2 < 0) break;
                String name = arrContent.substring(nq1 + 1, nq2);

                // Find "value" after "name"
                int valIdx = arrContent.indexOf("\"value\"", nq2);
                if (valIdx < 0) break;
                int vColon = arrContent.indexOf(":", valIdx + 7);
                if (vColon < 0) break;
                int vq1 = arrContent.indexOf("\"", vColon + 1);
                if (vq1 < 0) break;
                int vq2 = arrContent.indexOf("\"", vq1 + 1);
                if (vq2 < 0) break;
                String value = arrContent.substring(vq1 + 1, vq2);

                if (!first) sb.append("&");
                sb.append(name).append("=").append(value);
                first = false;
                pos = vq2 + 1;
            }
            return first ? "" : sb.toString();
        } catch (Exception e) {
            return "";
        }
    }

    // ── Manifest download ─────────────────────────────────────────────────────

    /**
     * Download the manifest binary. Uses the full URI from the first manifest entry
     * (which already includes the auth token in the URL). Falls back to other CDNs.
     */
    public static byte[] downloadManifest(String json, String bearerToken, List<CdnUrl> cdnUrls) {
        try {
            // The first URI in the manifests array already has the full signed URL.
            int manifestsIdx = json.indexOf("\"manifests\"");
            if (manifestsIdx < 0) return null;
            int uriIdx = json.indexOf("\"uri\"", manifestsIdx);
            if (uriIdx < 0) return null;
            int colon = json.indexOf(":", uriIdx + 5);
            if (colon < 0) return null;
            int q1 = json.indexOf("\"", colon + 1);
            if (q1 < 0) return null;
            int q2 = json.indexOf("\"", q1 + 1);
            if (q2 < 0) return null;
            String firstUri = json.substring(q1 + 1, q2);

            Log.i(TAG, "Manifest URI: " + firstUri);
            byte[] bytes = downloadBytes(firstUri, bearerToken);
            if (bytes != null && bytes.length > 4) return bytes;

            // Fallback: try each CDN with the same path+auth
            int buildsIdx = firstUri.indexOf("/Builds");
            if (buildsIdx < 0) return null;
            String manifestPath = firstUri.substring(buildsIdx); // includes ?token

            for (CdnUrl cdn : cdnUrls) {
                String url = cdn.baseUrl + manifestPath;
                Log.i(TAG, "Manifest fallback: " + url);
                bytes = downloadBytes(url, bearerToken);
                if (bytes != null && bytes.length > 4) return bytes;
            }
        } catch (Exception e) {
            Log.e(TAG, "downloadManifest error: " + e.getMessage());
        }
        return null;
    }

    // ── Manifest parsing ──────────────────────────────────────────────────────

    /**
     * Parse a binary Epic manifest.
     * Format mirrors GameNative BinaryManifest / ChunkDataList / FileManifestList.
     * Returns null on parse error or unsupported format.
     */
    public static ParsedManifest parseManifest(byte[] bytes) {
        try {
            ByteBuffer buf = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN);

            // ── Header (41 bytes) ────────────────────────────────────────────
            int magic = buf.getInt();          // offset 0
            if (magic != 0x44BEC00C) {
                // JSON manifest
                Log.w(TAG, "Non-binary manifest, trying JSON parser");
                return parseJsonManifest(bytes);
            }
            int headerSize       = buf.getInt();   // offset 4
            int sizeUncompressed = buf.getInt();   // offset 8
            int sizeCompressed   = buf.getInt();   // offset 12
            buf.position(buf.position() + 20);     // skip SHA-1 (20 bytes)
            int storedAs = buf.get() & 0xFF;       // offset 36
            int version  = buf.getInt();           // offset 37

            // Determine chunk directory from manifest feature level
            String chunkDir;
            if      (version >= 15) chunkDir = "ChunksV4";
            else if (version >= 6)  chunkDir = "ChunksV3";
            else if (version >= 3)  chunkDir = "ChunksV2";
            else                    chunkDir = "Chunks";

            // ── Body ─────────────────────────────────────────────────────────
            buf.position(headerSize);
            byte[] bodyBytes = new byte[buf.remaining()];
            buf.get(bodyBytes);

            // Decompress if storedAs & 1
            if ((storedAs & 1) != 0) {
                Inflater inflater = new Inflater();
                inflater.setInput(bodyBytes);
                byte[] decomp = new byte[sizeUncompressed];
                int got = inflater.inflate(decomp);
                inflater.end();
                if (got != sizeUncompressed) {
                    Log.e(TAG, "Decomp size mismatch: expected " + sizeUncompressed + " got " + got);
                    return null;
                }
                bodyBytes = decomp;
            }

            ByteBuffer body = ByteBuffer.wrap(bodyBytes).order(ByteOrder.LITTLE_ENDIAN);

            // ── ManifestMeta section — skip by reading declared size ──────────
            int metaSize = body.getInt();
            body.position(body.position() - 4 + metaSize);

            // ── ChunkDataList section ─────────────────────────────────────────
            int cdlStart = body.position();
            int cdlSize  = body.getInt();
            body.get();                    // version byte
            int chunkCount = body.getInt();

            List<ChunkInfo> chunks = new ArrayList<>(chunkCount);
            for (int i = 0; i < chunkCount; i++) chunks.add(new ChunkInfo());

            // Columnar layout: all GUIDs, then all hashes, then SHA1s, groupNums, windowSizes, fileSizes
            for (ChunkInfo c : chunks) {
                c.guid[0] = body.getInt();
                c.guid[1] = body.getInt();
                c.guid[2] = body.getInt();
                c.guid[3] = body.getInt();
            }
            for (ChunkInfo c : chunks) c.hash = body.getLong();
            // SHA1 hashes (20 bytes each) — skip
            body.position(body.position() + 20 * chunkCount);
            for (ChunkInfo c : chunks) c.groupNum  = body.get() & 0xFF;
            for (ChunkInfo c : chunks) c.windowSize = body.getInt();
            for (ChunkInfo c : chunks) c.fileSize   = body.getLong();

            // Seek to end of CDL section
            body.position(cdlStart + cdlSize);

            // Build GUID-string → ChunkInfo map for part lookups
            Map<String, ChunkInfo> chunkMap = new LinkedHashMap<>(chunkCount * 2);
            for (ChunkInfo c : chunks) chunkMap.put(c.guidStr(), c);

            // ── FileManifestList section ──────────────────────────────────────
            int fmlStart = body.position();
            int fmlSize  = body.getInt();
            body.get();                    // version byte
            int fileCount = body.getInt();

            List<FileInfo> files = new ArrayList<>(fileCount);
            for (int i = 0; i < fileCount; i++) files.add(new FileInfo());

            // Filenames (columnar)
            for (FileInfo f : files) f.filename = readFString(body);
            // Symlink targets — skip (columnar)
            for (int i = 0; i < fileCount; i++) readFString(body);
            // SHA1 hashes (20 bytes each) — skip
            body.position(body.position() + 20 * fileCount);
            // Flags — skip
            body.position(body.position() + fileCount);
            // Install tags — skip (columnar, variable length)
            for (int i = 0; i < fileCount; i++) {
                int tagCount = body.getInt();
                for (int j = 0; j < tagCount; j++) readFString(body);
            }
            // Chunk parts (columnar)
            for (FileInfo f : files) {
                int partCount = body.getInt();
                for (int j = 0; j < partCount; j++) {
                    int partStart = body.position();
                    int partStructSize = body.getInt(); // size of this ChunkPart struct
                    ChunkPart part = new ChunkPart();
                    part.guid[0] = body.getInt();
                    part.guid[1] = body.getInt();
                    part.guid[2] = body.getInt();
                    part.guid[3] = body.getInt();
                    part.offset = body.getInt();
                    part.size   = body.getInt();
                    f.parts.add(part);
                    // Seek past any extra bytes in the struct
                    body.position(partStart + partStructSize);
                }
            }

            // Seek to end of FML section
            body.position(fmlStart + fmlSize);

            // Deduplicate chunks — preserve insertion order for download ordering
            Map<String, ChunkInfo> seenMap = new LinkedHashMap<>(chunkCount * 2);
            for (ChunkInfo c : chunks) seenMap.put(c.guidStr(), c);
            List<ChunkInfo> uniqueChunks = new ArrayList<>(seenMap.values());

            ParsedManifest result = new ParsedManifest();
            result.chunkDir     = chunkDir;
            result.uniqueChunks = uniqueChunks;
            result.files        = files;
            return result;

        } catch (Exception e) {
            Log.e(TAG, "parseManifest error: " + e.getMessage(), e);
            return null;
        }
    }

    // ── Chunk download ────────────────────────────────────────────────────────

    /**
     * Download one chunk, trying each CDN in order.
     * URL = baseUrl + cloudDir + "/" + chunkPath + authParams
     * The authParams (e.g. ?f_token=...) are included per-CDN so each CDN gets its own token.
     * Decompresses the Epic chunk container, writes raw data to outFile.
     */
    public static boolean downloadChunk(
            ChunkInfo chunk,
            String chunkDir,
            List<CdnUrl> cdnUrls,
            File outFile) {
        String chunkPath = chunk.getPath(chunkDir);

        for (CdnUrl cdn : cdnUrls) {
            // authParams (f_token/cf_token) are path-scoped to the manifest URI — DO NOT append to chunk URLs.
            // Fastly will 403 if the token's signed path doesn't match the chunk path.
            // Fastly/Akamai chunks are publicly accessible; download.epicgames.com is the token-gated fallback.
            String url = cdn.baseUrl + cdn.cloudDir + "/" + chunkPath;
            try {
                byte[] raw = downloadBytes(url, null);
                if (raw == null) continue;

                byte[] data = decompressChunk(raw, chunk.windowSize);
                if (data == null) {
                    Log.w(TAG, "Decompress failed for chunk from " + cdn.baseUrl);
                    continue;
                }

                FileOutputStream fos = new FileOutputStream(outFile);
                try { fos.write(data); } finally { fos.close(); }
                return true;

            } catch (Exception e) {
                Log.w(TAG, "CDN " + cdn.baseUrl + " failed for " + chunk.guidStr() + ": " + e.getMessage());
            }
        }
        Log.e(TAG, "All CDNs failed for chunk " + chunk.guidStr());
        return false;
    }

    /**
     * Parse Epic chunk container and decompress body.
     * Header layout (from legendary/models/chunk.py):
     *   magic(4) version(4) headerSize(4) compressedSize(4) guid(16) hash(8)
     *   storedAs(1) SHA(20) hashType(1) uncompressedSize(4) = 66 bytes
     */
    public static byte[] decompressChunk(byte[] raw, int expectedSize) {
        try {
            ByteBuffer buf = ByteBuffer.wrap(raw).order(ByteOrder.LITTLE_ENDIAN);
            int magic = buf.getInt();
            if (magic != 0xB1FE3AA2) {
                Log.e(TAG, "Bad chunk magic: 0x" + Integer.toHexString(magic));
                return null;
            }
            buf.getInt();                   // headerVersion
            int headerSize     = buf.getInt();
            int compressedSize = buf.getInt();
            buf.position(buf.position() + 16); // skip GUID
            buf.position(buf.position() + 8);  // skip hash
            int storedAs = buf.get() & 0xFF;

            // Data starts at headerSize
            if (headerSize < 0 || headerSize >= raw.length) {
                Log.e(TAG, "Bad chunk headerSize: " + headerSize);
                return null;
            }
            byte[] data = new byte[compressedSize];
            System.arraycopy(raw, headerSize, data, 0, compressedSize);

            if ((storedAs & 1) != 0) {
                // Zlib compressed — inflate into dynamic buffer (handles any chunk size)
                Inflater inflater = new Inflater();
                inflater.setInput(data);
                ByteArrayOutputStream baos = new ByteArrayOutputStream(
                        expectedSize > 0 ? expectedSize : 1048576);
                byte[] ibuf = new byte[65536];
                int n;
                while ((n = inflater.inflate(ibuf)) > 0) baos.write(ibuf, 0, n);
                inflater.end();
                byte[] result = baos.toByteArray();
                if (result.length == 0) {
                    Log.e(TAG, "Chunk inflate produced 0 bytes");
                    return null;
                }
                return result;
            }
            // Uncompressed
            return data;
        } catch (Exception e) {
            Log.e(TAG, "decompressChunk error: " + e.getMessage());
            return null;
        }
    }

    // ── JSON manifest ─────────────────────────────────────────────────────────

    /**
     * Parse an Epic JSON-format manifest.
     * Fields: ManifestFileVersion, ChunkHashList, DataGroupList, ChunkFilesizeList,
     * FileManifestList[].{Filename, FileChunkParts[].{Guid, Offset, Size}}
     */
    private static ParsedManifest parseJsonManifest(byte[] bytes) {
        try {
            String jsonStr = new String(bytes, StandardCharsets.UTF_8);
            JSONObject root = new JSONObject(jsonStr);

            // Manifest version → chunk directory name
            int manifestVersion = 0;
            try { manifestVersion = Integer.parseInt(root.optString("ManifestFileVersion", "0")); }
            catch (NumberFormatException e) { manifestVersion = 0; }
            String chunkDir;
            if      (manifestVersion >= 15) chunkDir = "ChunksV4";
            else if (manifestVersion >= 6)  chunkDir = "ChunksV3";
            else if (manifestVersion >= 3)  chunkDir = "ChunksV2";
            else                            chunkDir = "ChunksV4"; // default for modern games

            JSONObject chunkHashList     = root.optJSONObject("ChunkHashList");
            JSONObject dataGroupList     = root.optJSONObject("DataGroupList");
            JSONObject chunkFilesizeList = root.optJSONObject("ChunkFilesizeList");

            if (chunkHashList == null) {
                Log.e(TAG, "JSON manifest: no ChunkHashList");
                return null;
            }

            // Build ChunkInfo map keyed by GUID hex (32 uppercase chars)
            Map<String, ChunkInfo> chunkMap = new LinkedHashMap<>();
            Iterator<String> keys = chunkHashList.keys();
            while (keys.hasNext()) {
                String guidHex = keys.next();
                if (guidHex.length() < 32) continue;
                String hashHex = chunkHashList.getString(guidHex);

                ChunkInfo c = new ChunkInfo();
                c.guid[0] = (int) Long.parseLong(guidHex.substring(0, 8), 16);
                c.guid[1] = (int) Long.parseLong(guidHex.substring(8, 16), 16);
                c.guid[2] = (int) Long.parseLong(guidHex.substring(16, 24), 16);
                c.guid[3] = (int) Long.parseLong(guidHex.substring(24, 32), 16);

                // Hash is 16 hex chars = uint64; may exceed Long.MAX_VALUE → parse unsigned
                if (hashHex != null && hashHex.length() >= 16) {
                    try {
                        c.hash = Long.parseUnsignedLong(hashHex.substring(0, 16), 16);
                    } catch (Exception e) { c.hash = 0; }
                }

                if (dataGroupList != null) {
                    try { c.groupNum = Integer.parseInt(dataGroupList.optString(guidHex, "0")); }
                    catch (NumberFormatException e) { c.groupNum = 0; }
                }
                if (chunkFilesizeList != null) {
                    try { c.fileSize = Long.parseLong(chunkFilesizeList.optString(guidHex, "0")); }
                    catch (NumberFormatException e) { c.fileSize = 0; }
                }
                // windowSize unknown in JSON format — set 0 to trigger dynamic inflate
                c.windowSize = 0;

                chunkMap.put(guidHex, c);
            }

            // Parse FileManifestList
            JSONArray fileList = root.optJSONArray("FileManifestList");
            if (fileList == null) {
                Log.e(TAG, "JSON manifest: no FileManifestList");
                return null;
            }

            List<FileInfo> files = new ArrayList<>(fileList.length());
            for (int i = 0; i < fileList.length(); i++) {
                JSONObject fileObj = fileList.getJSONObject(i);
                FileInfo fi = new FileInfo();
                fi.filename = fileObj.optString("Filename", "");

                JSONArray chunkParts = fileObj.optJSONArray("FileChunkParts");
                if (chunkParts != null) {
                    for (int j = 0; j < chunkParts.length(); j++) {
                        JSONObject partObj = chunkParts.getJSONObject(j);
                        ChunkPart part = new ChunkPart();
                        String partGuid = partObj.optString("Guid", "");
                        if (partGuid.length() >= 32) {
                            part.guid[0] = (int) Long.parseLong(partGuid.substring(0, 8), 16);
                            part.guid[1] = (int) Long.parseLong(partGuid.substring(8, 16), 16);
                            part.guid[2] = (int) Long.parseLong(partGuid.substring(16, 24), 16);
                            part.guid[3] = (int) Long.parseLong(partGuid.substring(24, 32), 16);
                        }
                        try { part.offset = Integer.parseInt(partObj.optString("Offset", "0")); }
                        catch (NumberFormatException e) { part.offset = 0; }
                        try { part.size = Integer.parseInt(partObj.optString("Size", "0")); }
                        catch (NumberFormatException e) { part.size = 0; }
                        fi.parts.add(part);
                    }
                }
                files.add(fi);
            }

            ParsedManifest result = new ParsedManifest();
            result.chunkDir     = chunkDir;
            result.uniqueChunks = new ArrayList<>(chunkMap.values());
            result.files        = files;
            Log.i(TAG, "JSON manifest: chunkDir=" + chunkDir
                    + " chunks=" + result.uniqueChunks.size()
                    + " files=" + files.size());
            return result;

        } catch (Exception e) {
            Log.e(TAG, "parseJsonManifest error: " + e.getMessage(), e);
            return null;
        }
    }

    // ── HTTP ──────────────────────────────────────────────────────────────────

    /** HTTP GET — returns null on non-200 or exception. */
    public static byte[] downloadBytes(String urlStr, String bearerToken) {
        HttpURLConnection conn = null;
        try {
            conn = (HttpURLConnection) new URL(urlStr).openConnection();
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(60000);
            conn.setRequestMethod("GET");
            conn.setRequestProperty("User-Agent", UA);
            if (bearerToken != null && !bearerToken.isEmpty()) {
                conn.setRequestProperty("Authorization", bearerToken);
            }
            int code = conn.getResponseCode();
            if (code != 200) {
                Log.w(TAG, "HTTP " + code + " for " + urlStr);
                return null;
            }
            InputStream in = conn.getInputStream();
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] buf = new byte[8192];
            int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
            in.close();
            return out.toByteArray();
        } catch (Exception e) {
            Log.w(TAG, "downloadBytes error [" + urlStr + "]: " + e.getMessage());
            return null;
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    // ── FString ───────────────────────────────────────────────────────────────

    /**
     * Read an Epic FString from a ByteBuffer.
     * length > 0 → ASCII (includes null terminator in count)
     * length < 0 → UTF-16LE (abs(length) chars including null terminator)
     * length == 0 → empty string
     */
    public static String readFString(ByteBuffer buf) {
        int length = buf.getInt();
        if (length == 0) return "";
        if (length < 0) {
            int chars = (-length) - 1;
            byte[] bytes = new byte[chars * 2];
            buf.get(bytes);
            buf.getShort(); // null terminator (2 bytes UTF-16)
            return new String(bytes, StandardCharsets.UTF_16LE);
        } else {
            byte[] bytes = new byte[length - 1];
            buf.get(bytes);
            buf.get(); // null terminator (1 byte)
            return new String(bytes, StandardCharsets.US_ASCII);
        }
    }

    // ── Utilities ─────────────────────────────────────────────────────────────

    public static byte[] readFile(File f) throws Exception {
        FileInputStream fis = new FileInputStream(f);
        byte[] data = new byte[(int) f.length()];
        int off = 0;
        while (off < data.length) {
            int r = fis.read(data, off, data.length - off);
            if (r < 0) break;
            off += r;
        }
        fis.close();
        return data;
    }

    public static void deleteDir(File dir) {
        if (!dir.exists()) return;
        File[] files = dir.listFiles();
        if (files != null) {
            for (File f : files) {
                if (f.isDirectory()) deleteDir(f);
                else f.delete();
            }
        }
        dir.delete();
    }

    /** Append a line to the app's bh_epic_debug.txt for diagnosis. */
    static void dbg(Context ctx, String msg) {
        Log.i(TAG, "[DBG] " + msg);
        if (ctx == null) return;
        try {
            File dir = ctx.getExternalFilesDir(null);
            if (dir == null) return;
            File f = new File(dir, "bh_epic_debug.txt");
            FileWriter fw = new FileWriter(f, true);
            fw.write(msg + "\n");
            fw.close();
        } catch (Exception e) { /* ignore */ }
    }

    private static void progress(ProgressCallback cb, String msg) {
        if (cb != null) cb.onProgress(msg);
        Log.i(TAG, msg);
    }

    /** Callback interface for progress messages. */
    public interface ProgressCallback {
        void onProgress(String message);
    }
}
