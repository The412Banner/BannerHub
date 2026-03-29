# BannerHub — Epic Games Integration Reference

Extracted from `bannerhub-testing` repo (epic-integration branch) before deletion.
Last commit: `9e1796e` (beta67) — 2026-03-25.

---

## Status at deletion

- **UI:** Complete — login, library sync, GOG-style collapsible cards, cover art, Install/Launch/Uninstall/Add (.exe picker)
- **Download pipeline:** Java-ported (`EpicDownloader.java`) — CDN rotation, per-CDN auth tokens, binary + JSON manifest parse, chunk decompression
- **Last tested:** Samorost 3 ✅ confirmed working end-to-end as of beta62 (smali version)
- **Beta64-67:** Java port + debug logging + manifest download token fix — **NOT device-tested** (committed but no test result recorded)
- **Open issue:** Fortnite (namespace `fn`) returns 404 on manifest URL — catalog `appId` lookup fails for that namespace

---

## Architecture

### Smali files (all in `smali_classes16/com/xj/landscape/launcher/ui/menu/`)

| File | Role |
|------|------|
| `EpicLoginActivity.smali` + `$1–$5` | WebView OAuth2 login, token exchange, store to `bh_epic_prefs` |
| `EpicCredentials.smali` | Data class: accessToken, accountId, displayName |
| `EpicCredentialStore.smali` | SharedPreferences helper — read/write `bh_epic_prefs` |
| `EpicTokenRefresh.smali` | Refresh access token using refreshToken from prefs |
| `EpicGame.smali` | Data class: appName, title, namespace, catalogItemId, installDir |
| `EpicMainActivity.smali` + `$1–$17` | Main activity: library sync, card UI, install/launch/uninstall |
| `EpicDownloader.smali` + inner classes | Java-compiled download pipeline (see below) |
| `EpicManifestData.smali` | (old smali version — superseded by EpicDownloader) |
| `EpicInstallHelper.smali` | (old smali version — superseded by EpicDownloader) |

### Java source (keep in bannerhub repo if/when porting)
- `java_src/com/xj/landscape/launcher/ui/menu/EpicDownloader.java` — 873 lines
- `java_stubs/` — android.util.Log, android.content.Context, org.json.* stubs for javac

### Compilation pipeline
```
javac --release 8 \
  -classpath java_stubs:/data/data/com.termux/files/usr/share/aapt/android.jar \
  -d java_classes java_src/**/*.java
dx --dex --output epic_downloader.dex java_classes/
cp epic_downloader.dex classes.dex && zip epic_downloader.zip classes.dex
java -jar ~/apktool.jar d -o epic_ds epic_downloader.zip
# copy epic_ds/smali/com/xj/... → patches/smali_classes16/com/xj/...
```

---

## EpicMainActivity inner classes

| Class | Role |
|-------|------|
| `$1` | Library sync Runnable — calls Epic account service, paginates with stateToken, parses appName/namespace/catalogItemId, fetches catalog title, posts $2 to UI |
| `$2` | Card builder Runnable — creates collapsible capsule card per game (topRow: cover+title+checkmark+arrow; expandSection: subtitle+progress+buttons) |
| `$3` | Cover art loader |
| `$4` | Cover art UI poster |
| `$5` | Install button onClick — shows confirm dialog |
| `$6` | Cover art HTTP Runnable |
| `$7` | Install Runnable — calls token refresh, hits manifest API, calls `EpicDownloader.install()` |
| `$8` | Launch onClick |
| `$9` | Confirm dialog onClick — starts install |
| `$10` | Expand/collapse + detail dialog on card click |
| `$11` | Install success UI — show checkmark, enable Launch |
| `$12` | Install failure UI — show "Install failed" in red |
| `$13` | Add button onClick — scan installDir for first .exe (skip redist) |
| `$14` | Card click listener (expand/collapse + detail dialog) |
| `$15` | Arrow click listener (collapse) |
| `$16` | Uninstall handler (DialogInterface + Runnable, recursive deleteDir) |
| `$17` | Post-uninstall UI Runnable |

---

## EpicDownloader.java — API summary

```java
// Main entry point — call from EpicMainActivity$7
boolean install(String manifestApiJson, String bearerToken, String installDir, ProgressCallback cb)

// CDN parsing
List<CdnUrl> parseCdnUrls(String json)
  // Skips cloudflare.epicgamescdn.com entries
  // Extracts per-CDN baseUrl, cloudDir, authParams from queryParams array

// Manifest
byte[] downloadManifest(List<CdnUrl> cdns, String bearerToken)
  // Uses firstUri (path only) + cdn.baseUrl + cdn.cloudDir + cdn.authParams
  // Removes Authorization header (CDN auth is via URL query param only)
ParsedManifest parseManifest(byte[] data)
  // First byte 0x1F or 0x28 → binary; byte 0x7B ('{') → JSON
ParsedManifest parseJsonManifest(byte[] data)
  // Uses org.json to parse ChunkHashList/DataGroupList/ChunkFilesizeList + FileManifestList

// Binary manifest format:
//   Bytes 0-3:   magic = 0x44BEC00C
//   Bytes 4-7:   headerSize
//   Bytes 8-11:  storedAs (bit 0 = zlib compressed)
//   Bytes 12-19: dataSize (uncompressed) / storedDataSize (compressed)
//   After header: zlib data if storedAs&1, else raw
//   ManifestMeta section: skip (read sectionSize, seek past)
//   ChunkDataList: GUIDs (4×int each) | SHA256 hashes | SHA1 hashes | groupNums | windowSizes | fileSizes
//   FileManifestList: columnar — ALL filenames, ALL symlinks, ALL SHA1+flags, ALL install tags, ALL chunk parts

// Chunks
byte[] downloadChunk(List<CdnUrl> cdns, ParsedManifest mf, ChunkInfo chunk)
  // Rotates ALL CDNs per chunk until one succeeds
  // URL = cdn.baseUrl + cdn.cloudDir + "/" + chunkPath  (NO authParams on chunk URLs)
  // chunkPath = groupNum_decimal_2digits + "/" + GUID_reversed_hex + "_" + hash + ".chunk"

byte[] decompressChunk(byte[] raw, int expectedSize)
  // Epic chunk container: magic 0xB1FE3AA2 at offset 0
  //   headerSize at offset 8 (int, little-endian)
  //   storedAs at offset 40 (byte, bit 0 = zlib compressed)
  //   payload starts at headerSize offset
  // If storedAs&1: inflate with ByteArrayOutputStream loop (no fixed output size)
  // Else: return payload as-is
```

---

## Key bugs fixed (history)

| Beta | Bug | Fix |
|------|-----|-----|
| beta37 | Manifest 404 — markers had space before `:` | Remove space from JSON markers |
| beta38 | Regression — spaces needed back; lastIndexOf vs indexOf | Restore spaces; use indexOf for namespace/catalogItemId (they come AFTER appName in JSON) |
| beta41 | Library UUID used as appId | Use releaseInfo appId from catalog API |
| beta51 | OOM on large manifests (Deus Ex) | FileManifestList is columnar, not interleaved — read all filenames first, then symlinks, then SHA1/flags bulk skip, then chunk parts |
| beta56 | 0-byte downloads | No token on chunk URLs; Cloudflare-gated CDN rejected them; append manifest query string |
| beta58 | parseCdnBase returned "" | Was looking for "cdnList" (absent in v2 API); now scans "manifests" array |
| beta59 | MalformedURLException | parseCdnBase required Akamai (empty queryParams); most games only have Fastly → use first non-cloudflare.epicgamescdn.com CDN |
| beta60 | 403 on Deus Ex | download.epicgames.com picked first; it's Cloudflare-gated; prefer Fastly/Akamai (two-pass) |
| beta61 | Wrong chunk subfolder | Was hex (toHex2); GameNative uses decimal "%02d" — 94 not "5e" |
| beta62 | ART VerifyError crash | Fallback CDN string init was inside try block below early-exit branches; v8 uninit on those paths |
| beta63 | Fastly 403 | f_token was being cleared after extraction; preserved it → chunks passed |
| beta64 | CDN rotation + silent skips | Java port; rotates all CDNs per chunk; explicit abort on failure; per-CDN authParams |
| beta65 | Fastly 403 again (Java) | authParams on chunk URLs = Fastly signature mismatch; Fastly/Akamai chunks are PUBLIC — never append authParams to chunk URLs |
| beta65 | JSON manifest crash | First byte '{' = JSON manifest; added parseJsonManifest() via org.json |
| beta66 | Debug instrumentation | Added Context param + writeDebug() → bh_epic_debug.txt |
| beta67 | Manifest 403 | downloadManifest was using raw `uri` field (no token); token is in queryParams → use cdn.baseUrl + cdn.cloudDir + filename + cdn.authParams |

---

## Critical CDN rule (confirmed from GameNative source)

```
Manifest download:  cdn.baseUrl + cdn.cloudDir + "/" + filename + cdn.authParams  ← token required
Chunk download:     cdn.baseUrl + cdn.cloudDir + "/" + chunkPath                  ← NO token, chunks are public
```
Fastly/Akamai CDN: chunks publicly accessible, no auth.
`download.epicgames.com` (Cloudflare): last-resort fallback only — may still 403 on chunks.

---

## Storage layout

```
getFilesDir()/epic_games/{appName}/   ← install directory
bh_epic_prefs SharedPreferences:
  epic_access_token    — OAuth2 bearer token
  epic_refresh_token   — for refresh
  epic_account_id      — account ID
  epic_display_name    — display name
  epic_exe_{appName}   — path to .exe for Launch
```

---

## Open issues at deletion

1. **Fortnite (namespace `fn`)** — catalog `appId` lookup fails; manifest URL built with empty appId → 404. Epic uses a different catalog path for `fn` namespace.
2. **beta67 device test** — Java port (EpicDownloader) + manifest token fix were NOT confirmed on-device. Last device-confirmed working build: beta62 (smali version, Samorost 3).
3. **LandscapeMenuActivity patch** — needs `ID=11` menu item → `EpicMainActivity`. Not present in main bannerhub. Look at GOG menu item (ID=10) as template.

---

## To port into main bannerhub

1. Copy all `Epic*.smali` files from testing → `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/`
2. Copy `java_src/EpicDownloader.java` and `java_stubs/` for future recompilation
3. Patch `LandscapeMenuActivity` to add menu item ID=11 → `EpicLoginActivity` (mirror GOG ID=10 patch)
4. Patch `AndroidManifest.xml` to register `EpicLoginActivity` and `EpicMainActivity`
5. Add `bh_epic_prefs` to SharedPreferences whitelist if needed
6. Rebuild EpicDownloader smali if Java source was modified: run compilation pipeline above

---

*Document created 2026-03-29. Repo deleted after this document was written.*
