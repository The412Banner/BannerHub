# Epic Games Store Integration — Full Technical Report
**Source:** https://github.com/utkarshdalal/GameNative
**Generated:** 2026-03-29
**Purpose:** Porting reference for BannerHub Android app

---

## Table of Contents
1. [File Structure Overview](#1-file-structure-overview)
2. [Data Models](#2-data-models)
3. [Authentication Flow](#3-authentication-flow)
4. [Library Sync](#4-library-sync)
5. [Download Pipeline](#5-download-pipeline)
6. [Manifest Format](#6-manifest-format)
7. [CDN Selection Logic](#7-cdn-selection-logic)
8. [Chunk Download and Decompression](#8-chunk-download-and-decompression)
9. [File Assembly](#9-file-assembly)
10. [Launch Arguments](#10-launch-arguments)
11. [Cloud Saves](#11-cloud-saves)
12. [Game Fixes / Registry Patches](#12-game-fixes--registry-patches)
13. [Service Coordinator](#13-service-coordinator)
14. [Helper Utilities](#14-helper-utilities)
15. [Notable Commits and PRs](#15-notable-commits-and-prs)
16. [BannerHub Port Notes](#16-bannerhub-port-notes)

---

## 1. File Structure Overview

All Epic source files live at `app/src/main/java/app/gamenative/service/epic/`.

```
service/epic/
  EpicConstants.kt          — All hardcoded values: client ID/secret, URLs, paths
  EpicAuthClient.kt         — Low-level HTTP: token exchange, refresh, exchange code, OT
  EpicAuthManager.kt        — Credential storage (JSON file), auto-refresh, launch tokens
  EpicManager.kt            — Library sync, catalog API, manifest fetch, DB operations
  EpicDownloadManager.kt    — Full download pipeline: chunks, decompression, assembly
  EpicGameLauncher.kt       — Build Wine launch args, save/clean ownership tokens
  EpicCloudSavesManager.kt  — Cloud save sync (download/upload/conflict resolution)
  EpicService.kt            — Android Service coordinator, download tracking
  manifest/
    EpicManifest.kt         — Binary + JSON manifest parser/serializer, all data classes
    JsonManifestParser.kt   — JSON format manifest parser (older games)
    ManifestUtils.kt        — Utilities: getFilesForTags, getRequiredChunks, compare
data/
  EpicGame.kt               — Room entity, EpicCredentials, EpicGameToken, EpicDLCInfo
db/dao/
  EpicGameDao.kt            — Room DAO for epic_games table
gamefixes/
  EPIC_59a0c86d02da42e8ba6444cb171e61bf.kt  — Oblivion registry fix
  EPIC_b1b4e0b67a044575820cb5e63028dcae.kt  — Fallout 3 registry fix
  EPIC_dabb52e328834da7bbe99691e374cb84.kt  — Fallout: New Vegas registry fix
ui/
  EpicOAuthActivity.kt      — WebView OAuth login screen
  EpicAppScreen.kt          — Compose library screen for Epic games
  EpicGameManagerDialog.kt  — Game management dialog
androidTest/
  manifest/test/
    ManifestParseTest.kt
    ManifestParseValidationTest.kt
    ManifestTestSerializer.kt
test/resources/epic/
  darksiders_catalog.json   — Sample catalog API response
  dragonage_catalog.json
  library_items.json        — Sample library API response
  watchdogs_catalog.json
```

---

## 2. Data Models

### `EpicGame` (Room entity, table: `epic_games`)

```kotlin
data class EpicGame(
    val id: Int,                    // Auto-generated Room PK — used as GameNative game ID
    val catalogId: String,          // Epic catalog item ID (UUID or short string like "Quail")
    val appName: String,            // Legendary/Epic app name (UUID or slug)
    val title: String,
    val namespace: String,          // Required for manifest and catalog API calls
    val developer: String,
    val publisher: String,
    val isInstalled: Boolean,
    val installPath: String,
    val platform: String,           // Always "Windows"
    val version: String,
    val executable: String,         // From customAttributes.MainWindowProcessName
    val installSize: Long,
    val downloadSize: Long,
    val artCover: String,           // DieselGameBoxTall — tall cover art URL
    val artSquare: String,          // DieselGameBox — square box art URL
    val artLogo: String,            // DieselGameBoxLogo
    val artPortrait: String,        // DieselStoreFrontWide
    val canRunOffline: Boolean,
    val requiresOT: Boolean,        // true = Denuvo DRM, needs ownership token
    val cloudSaveEnabled: Boolean,
    val saveFolder: String,         // e.g. "{AppData}/LocalLow/GameName/{EpicId}"
    val thirdPartyManagedApp: String, // "The EA App", "Origin", "Ubisoft Connect"
    val isEAManaged: Boolean,
    val isDLC: Boolean,
    val baseGameAppName: String,    // catalogId of base game (NOT appName, despite the field name)
    val description: String,
    val releaseDate: String,
    val genres: List<String>,
    val tags: List<String>,
    val lastPlayed: Long,
    val playTime: Long,
    val eosCatalogItemId: String,
    val eosAppId: String,
)
```

### `EpicCredentials`
```kotlin
data class EpicCredentials(
    val accessToken: String,
    val refreshToken: String,
    val accountId: String,
    val displayName: String,
    val expiresAt: Long,            // epoch ms
)
```

### `EpicGameToken`
```kotlin
data class EpicGameToken(
    val authCode: String,           // Exchange code -> -AUTH_PASSWORD
    val accountId: String,          // -> -epicuserid
    val ownershipToken: String?,    // hex string -> write to .ovt file -> -epicovt
)
```

---

## 3. Authentication Flow

### OAuth Credentials (hardcoded — Legendary's official client)
```
EPIC_CLIENT_ID     = "34a02cf8f4414e29b15921876da36f9a"
EPIC_CLIENT_SECRET = "daafbccc737745039dffe53d94fc76cf"
```
These are the same credentials used by the Legendary CLI and are public knowledge.

### Step 1: Get Authorization Code

User opens a WebView/browser to this URL:
```
https://www.epicgames.com/id/login
  ?redirectUrl=https://www.epicgames.com/id/api/redirect
  %3FclientId%3D34a02cf8f4414e29b15921876da36f9a
  %26responseType%3Dcode
  &state=<random 64 hex chars>
```

The redirect `https://www.epicgames.com/id/api/redirect?clientId=...&responseType=code` returns a page containing the authorization code. Extract via URL param `?code=<authcode>`.

The `state` param is for CSRF protection — generate fresh per login attempt via `EpicConstants.LoginUrlWithState()` which returns `(url, state)` pair.

### Step 2: Exchange Code for Tokens

**Endpoint:** `POST https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token`

**Headers:**
```
Authorization: Basic <base64(clientId:clientSecret)>
User-Agent: UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit
Content-Type: application/x-www-form-urlencoded
```

**Body (form-encoded):**
```
grant_type=authorization_code
code=<authorizationCode>
token_type=eg1
```

**Response:**
```json
{
  "access_token": "eg1~...",
  "refresh_token": "eg1~...",
  "account_id": "abc123...",
  "displayName": "Username",
  "expires_in": 7200,
  "expires_at": "2026-03-29T12:00:00.000Z"
}
```

`expires_at` can be ISO 8601 string or epoch ms. `parseExpiresAt()` handles both, with fallback to `now + expires_in * 1000`.

### Step 3: Token Refresh

**Same endpoint:** `POST https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token`

**Body:**
```
grant_type=refresh_token
refresh_token=<refreshToken>
token_type=eg1
```

`EpicAuthManager.getStoredCredentials()` auto-refreshes if `now + 5min >= expiresAt`.

### Step 4: Get Exchange Code (for game launch)

**Endpoint:** `GET https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange`

**Headers:**
```
Authorization: Bearer <accessToken>
User-Agent: UELauncher/...
```

**Response:**
```json
{ "code": "<short-lived exchange code>" }
```

This exchange code is passed as `-AUTH_PASSWORD` when launching the game executable.

### Step 5: Get Ownership Token (Denuvo DRM only)

Only required when `game.requiresOT == true`.

**Endpoint:** `POST https://ecommerceintegration-public-service-ecomprod02.ol.epicgames.com/ecommerceintegration/api/public/platforms/EPIC/identities/<accountId>/ownershipToken`

**Headers:**
```
Authorization: Bearer <accessToken>
Content-Type: application/x-www-form-urlencoded
```

**Body:**
```
nsCatalogItemId=<namespace>:<catalogItemId>
```

**Response:** Raw binary bytes (NOT JSON). Stored as hex string, written to `.ovt` file, passed as `-epicovt=<path>`.

### Credential Storage

Credentials are persisted as JSON to `context.filesDir/epic/credentials.json`:
```json
{
  "access_token": "...",
  "refresh_token": "...",
  "account_id": "...",
  "display_name": "...",
  "expires_at": 1234567890000
}
```

For BannerHub: store in SharedPreferences key `bh_epic_prefs` instead of a file.

---

## 4. Library Sync

### Step 1: Fetch Library Items (paginated)

**Endpoint:** `GET https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true[&cursor=<cursor>]`

**Headers:**
```
Authorization: Bearer <accessToken>
User-Agent: Legendary/0.1.0 (GameNative)
```

**Response (per page):**
```json
{
  "records": [
    {
      "appName": "<UUID or slug>",
      "namespace": "<namespace>",
      "catalogItemId": "<UUID>",
      "sandboxType": "PUBLICGAME",
      "country": "US",
      "platform": ["Windows", "Win32"],
      "productId": "...",
      "acquisitionDate": "...",
      ...
    }
  ],
  "responseMetadata": {
    "nextCursor": "<cursor or null>",
    "stateToken": null
  }
}
```

**Filtering rules applied during parse:**
- Skip if no `appName` field
- Skip if `namespace == "ue"` (Unreal Engine assets)
- Skip if `namespace == "89efe5924d3d467c839449ab6ab52e7f"` (UE tools — from DAO query)
- Skip if `sandboxType == "PRIVATE"`
- Skip if `appName == "1"` (broken entries)
- Skip if `platform` array is non-empty AND contains neither `"Win32"` nor `"Windows"` (Android-only games)

Pagination: Fetch with `cursor` until `nextCursor` is null or same as previous cursor.

### Step 2: Fetch Catalog Item Details (bulk endpoint)

For each new game not already in DB:

**Endpoint:** `GET https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace/<namespace>/bulk/items?id=<catalogItemId>&includeDLCDetails=true&includeMainGameDetails=true&country=<country>`

**Headers:**
```
Authorization: Bearer <accessToken>
User-Agent: Legendary/0.1.0 (GameNative)
```

**Response:**
```json
{
  "<catalogItemId>": {
    "id": "<catalogItemId>",
    "namespace": "<namespace>",
    "title": "Game Title",
    "description": "...",
    "developer": "Developer Name",
    "keyImages": [
      { "type": "DieselGameBoxTall", "url": "https://cdn.epik.com/..." },
      { "type": "DieselGameBox", "url": "https://..." },
      { "type": "DieselGameBoxLogo", "url": "https://..." },
      { "type": "DieselStoreFrontWide", "url": "https://..." },
      { "type": "Thumbnail", "url": "https://..." }
    ],
    "categories": [
      { "path": "games/action" },
      { "path": "mods" }
    ],
    "releaseInfo": [
      { "id": "...", "appId": "...", "platform": ["Windows"], "dateAdded": "2019-..." }
    ],
    "mainGameItem": { "id": "<catalogId>", "namespace": "<ns>" },
    "customAttributes": {
      "CanRunOffline":             { "type": "STRING", "value": "true" },
      "CloudSaveFolder":           { "type": "STRING", "value": "{AppData}/LocalLow/..." },
      "CloudIncludeList":          { "type": "STRING", "value": "..." },
      "MainWindowProcessName":     { "type": "STRING", "value": "game.exe" },
      "ThirdPartyManagedApp":      { "type": "STRING", "value": "The EA App" },
      "ThirdPartyManagedProvider": { "type": "STRING", "value": "UbisoftConnect" },
      "partnerLinkType":           { "type": "STRING", "value": "..." },
      "FolderName":                { "type": "STRING", "value": "..." },
      "PresenceId":                { "type": "STRING", "value": "..." },
      "UseAccessControl":          { "type": "STRING", "value": "false" },
      "AdditionalCommandline":     { "type": "STRING", "value": "..." }
    }
  }
}
```

**Key image type mapping:**
- `DieselGameBoxTall` -> `artCover` (tall portrait art)
- `DieselGameBox` -> `artSquare` (square box art)
- `DieselGameBoxLogo` -> `artLogo`
- `DieselStoreFrontWide` -> `artPortrait` (wide banner)
- `Thumbnail` -> fallback for `artSquare`

**DLC detection:** Game is DLC if `"mainGameItem"` key is present. `baseGameAppName` stores the `id` (catalogId) of the base game item.

**customAttributes format:** Each attribute is `{ "type": "STRING", "value": "..." }` object, accessed by name.

**Batch insert strategy:** Insert new games in batches of 10, preserving `isInstalled`, `installPath`, `installSize`, `lastPlayed`, `playTime` for games already in DB (`upsertPreservingInstallStatus`).

---

## 5. Download Pipeline

The full download flow in `EpicDownloadManager.downloadGame()`:

1. `fetchManifestFromEpic()` — Get manifest URL list and download binary manifest
2. Filter CDN URLs to exclude `cloudflare.epicgamescdn.com`
3. `EpicManifest.readAll()` — Parse binary/JSON manifest
4. `ManifestUtils.getFilesForSelectedInstallTags()` — Filter files by language
5. `ManifestUtils.getRequiredChunksForFileList()` — Get unique chunks needed
6. Fetch DLC manifests for size calculation (if DLC IDs passed)
7. Download chunks in parallel batches of 6 (`MAX_PARALLEL_DOWNLOADS`)
   - Each chunk: try up to 3 CDN URLs, retry up to 3 times with exp backoff
   - Stream download -> temp file -> decompress to final file
   - Verify SHA-1 hash after decompression
8. Assemble files from chunks in parallel batches of 4
   - Each file: for each ChunkPart, read `size` bytes at `offset` from decompressed chunk file
9. Clean up `.chunks/` temp directory
10. Download DLCs into same installPath using pre-fetched manifests
11. Update DB: `isInstalled = true`, `installPath`, `installSize`
12. Write `DOWNLOAD_COMPLETE_MARKER`, remove `DOWNLOAD_IN_PROGRESS_MARKER`

### Parallel Configuration
```
MAX_PARALLEL_DOWNLOADS = 6     // chunk download goroutines
file assembly batch     = 4    // file assembly coroutines
MAX_CHUNK_RETRIES       = 3    // per chunk
RETRY_DELAY_MS          = 1000 // initial, doubles each retry
ConnectionPool          = 32 connections, 5 min TTL
```

---

## 6. Manifest Format

### Fetching the Manifest URL

**Endpoint:** `GET https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace/<namespace>/catalogItem/<catalogItemId>/app/<appName>/label/Live`

**Headers:**
```
Authorization: Bearer <accessToken>
User-Agent: Legendary/0.1.0 (GameNative)
```

**Response:**
```json
{
  "elements": [
    {
      "manifests": [
        {
          "uri": "https://fastly-download.epicgames.com/Builds/Org/abc/def/default/SomeName.manifest?t=TOKEN",
          "queryParams": [
            { "name": "t", "value": "<cdn-auth-token>" }
          ]
        },
        {
          "uri": "https://epicgames-download1.akamaized.net/Builds/Org/abc/def/default/SomeName.manifest",
          "queryParams": []
        },
        {
          "uri": "https://cloudflare.epicgamescdn.com/Builds/Org/abc/def/default/SomeName.manifest?t=TOKEN",
          "queryParams": [...]
        }
      ]
    }
  ]
}
```

Each entry in `manifests` is the same manifest available on a different CDN.

**CDN URL extraction:**
```kotlin
baseUrl  = uri.substringBefore("/Builds")
           // e.g. "https://fastly-download.epicgames.com"
cloudDir = afterBase.substringBefore("/" + manifestFilename)
           // e.g. "/Builds/Org/abc/def/default"
authParams = "?" + queryParams joined with "&"  // empty if no queryParams
```

### Downloading the Manifest Binary

Built from first `manifests` entry with query params appended. NO Authorization header:
```kotlin
Request.Builder()
    .url(manifestUri + queryParamsString)
    .header("User-Agent", EPIC_USER_AGENT)
    .get()
    .build()
```
Uses a dedicated `cdnClient` with `followRedirects(true)`.

### Binary Manifest Format

Detection: first 4 bytes LE == `0x44BEC00C` -> binary; otherwise JSON.

**Fixed header (41 bytes, little-endian):**
```
magic           : 4 bytes  = 0x44BEC00C (uint)
headerSize      : 4 bytes  (always 41)
sizeUncompressed: 4 bytes
sizeCompressed  : 4 bytes
shaHash         : 20 bytes (SHA-1 of uncompressed body)
storedAs        : 1 byte   (bit 0 = zlib compressed)
version         : 4 bytes  (manifest feature level, typically 17-21)
```

Body starts at `headerSize`. If `storedAs & 0x1 == 1`, body is zlib-compressed; inflate to `sizeUncompressed`. SHA-1 of inflated body MUST match header `shaHash`.

**Body sections (in strict order, all little-endian):**

#### Section 1: ManifestMeta
Each section starts with its own 4-byte `size` field:
```
metaSize       : 4 bytes (total size of section including this field)
dataVersion    : 1 byte
featureLevel   : 4 bytes
isFileData     : 1 byte (0 or 1)
appId          : 4 bytes
appName        : FString
buildVersion   : FString
launchExe      : FString  <- relative path to main executable
launchCommand  : FString  <- additional launch args from Epic
prereqCount    : 4 bytes
prereqIds      : N FStrings
prereqName     : FString
prereqPath     : FString
prereqArgs     : FString
-- if dataVersion >= 1: --
buildId        : FString
-- if dataVersion >= 2: --
uninstallActionPath : FString
uninstallActionArgs : FString
```

#### Section 2: ChunkDataList (columnar format)
```
size           : 4 bytes
version        : 1 byte
count          : 4 bytes
-- then N GUIDs (4x int32 each = 128 bits) --
-- then N hashes (uint64 each) --
-- then N shaHashes (20 bytes each) --
-- then N groupNums (uint8 each) --
-- then N windowSizes (int32 each = uncompressed chunk size in bytes) --
-- then N fileSizes (int64 each = compressed download size in bytes) --
```

#### Section 3: FileManifestList (columnar format)
```
size           : 4 bytes
version        : 1 byte
count          : 4 bytes
-- then N filenames (FString each) --
-- then N symlinkTargets (FString each) --
-- then N SHA-1 hashes (20 bytes each) --
-- then N flags (uint8 each):
     bit 0 = isReadOnly
     bit 1 = isCompressed
     bit 2 = isExecutable --
-- then N install tag lists:
     tagCount (4 bytes) + N FStrings per file --
-- then N chunk part lists:
     partCount (4 bytes), then for each part:
       partSize (4 bytes = total size of this part record)
       guid     (4x int32 = 16 bytes)
       offset   (int32 = byte offset into decompressed chunk)
       size     (int32 = bytes to copy from chunk to file)
-- if version >= 1: N MD5 hashes (has_md5 int32 flag + 16 bytes if nonzero) + N mimeType FStrings --
-- if version >= 2: N SHA-256 hashes (32 bytes each) --
```

#### Section 4: CustomFields
```
size           : 4 bytes
version        : 1 byte
count          : 4 bytes
-- all keys first (N FStrings) --
-- all values next (N FStrings) --
```

**FString format:**
```
length : int32 (signed)
  if length > 0 : (length-1) ASCII bytes + 1 null byte
  if length < 0 : abs(length)*2-2 UTF-16LE bytes + 2 null bytes
  if length == 0: empty string (no data)
```

### JSON Manifest Format

Older format (detected when magic != `0x44BEC00C`):

```json
{
  "ManifestFileVersion": "013000000000",
  "bIsFileData": false,
  "AppID": "000000000000",
  "AppNameString": "...",
  "BuildVersionString": "...",
  "LaunchExeString": "...",
  "LaunchCommand": "...",
  "PrereqIds": [],
  "ChunkFilesizeList": { "<guid-hex>": "<blob-long>", ... },
  "ChunkHashList":     { "<guid-hex>": "<blob-ulong>", ... },
  "ChunkShaList":      { "<guid-hex>": "<sha-hex>", ... },
  "DataGroupList":     { "<guid-hex>": "<blob-int>", ... },
  "FileManifestList": [
    {
      "Filename": "some/path/file.exe",
      "FileHash": "<blob-bytes>",
      "bIsReadOnly": false,
      "bIsCompressed": false,
      "bIsUnixExecutable": false,
      "InstallTags": ["English"],
      "FileChunkParts": [
        { "Guid": "<32-char hex>", "Offset": "<blob-int>", "Size": "<blob-int>" }
      ]
    }
  ],
  "CustomFields": {}
}
```

**Blob number format** (used throughout JSON manifests):
- Each 3 decimal digits = one byte value (000-255), little-endian assembly
- Example: `"013000000000"` = bytes [13, 0, 0, 0] = integer 13

---

## 7. CDN Selection Logic

All CDN entries from `manifests[]` array are extracted into `List<CdnUrl>`. **Before any chunk download:**

```kotlin
val cdnUrls = manifestData.cdnUrls.filter {
    !it.baseUrl.startsWith("https://cloudflare.epicgamescdn.com")
}
```

**Cloudflare is always excluded** — causes inconsistent 403 errors on chunks.

**Typical CDN base URLs:**
- `https://fastly-download.epicgames.com` — Fastly (preferred, no auth tokens on chunks)
- `https://epicgames-download1.akamaized.net` — Akamai (no auth tokens on chunks)
- `https://download.epicgames.com` — Epic CDN (may have auth tokens)
- `https://cloudflare.epicgamescdn.com` — **EXCLUDED**

**Auth token usage:**
- Query params in manifest response: used ONLY for downloading the manifest binary itself
- Chunk downloads: NO auth tokens, NO Authorization header — only User-Agent
- Fastly and Akamai serve chunks publicly without authentication

**CDN fallback:** If a chunk download fails on one CDN URL, the next CDN in the list is tried. All CDNs serve the same chunks.

---

## 8. Chunk Download and Decompression

### Chunk URL Construction

```kotlin
fun ChunkInfo.getPath(chunkDir: String): String {
    val guidHex = guid.joinToString("") { "%08X".format(it) }   // 32 uppercase HEX chars
    val hashHex = hash.toString(16).uppercase().padStart(16, '0')
    val subfolder = "%02d".format(groupNum)  // DECIMAL, zero-padded to 2 digits
    return "$chunkDir/$subfolder/${hashHex}_$guidHex.chunk"
}
```

**ChunkDir version mapping:**
```
manifest version >= 15 -> "ChunksV4"
manifest version >= 6  -> "ChunksV3"
manifest version >= 3  -> "ChunksV2"
else                   -> "Chunks"
```

**Full chunk URL:**
```
${cdnUrl.baseUrl}${cdnUrl.cloudDir}/ChunksV4/00/AABBCCDD00112233_11223344556677880011223344556677.chunk
```

**CRITICAL — subfolder is DECIMAL not hex:**
`groupNum = 94` -> subfolder = `"94"` (decimal), NOT `"5e"` (hex). Small games only use group 0 so `"00"` is identical. This masked the bug until larger games were tested.

### HTTP Request for Chunk

```kotlin
Request.Builder()
    .url("${cdnUrl.baseUrl}${cdnUrl.cloudDir}/$chunkPath")
    .header("User-Agent", "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit")
    .build()
// NO Authorization header
// NO CDN auth tokens
```

Download streamed to temp file `{guidStr}.tmp`, then decompressed to `{guidStr}` in `.chunks/` dir.

### Chunk File Format (Binary, little-endian)

**Header — version 2 = 62 bytes, version 3 = 66 bytes:**
```
magic           : 4 bytes  = 0xB1FE3AA2
headerVersion   : 4 bytes  (2 or 3)
headerSize      : 4 bytes  (62 or 66)
compressedSize  : 4 bytes
guid            : 16 bytes (4 x int32 LE, same as manifest GUID)
hash            : 8 bytes  (rolling hash, uint64 LE)
storedAs        : 1 byte   (bit 0 = zlib compressed)
shaHash         : 20 bytes (SHA-1 of uncompressed chunk data)
hashType        : 1 byte   (0x3 = both rolling + SHA) [v2+]
uncompressedSize: 4 bytes  [v3 only]
```

Data starts at `headerSize` bytes from file start.

**Decompression:** If `storedAs & 0x1 == 1`, payload is zlib-deflate compressed. Use Java `Inflater`. Streaming decompression is used to avoid OOM on large chunks.

**Verification:** SHA-1 of decompressed data must match `shaHash` from chunk header (also equals `ChunkInfo.shaHash` from manifest).

**Size after decompression** = `windowSize` from manifest (stored as `uncompressedSize` in v3 headers, or passed as parameter for v2).

### Streaming Decompression (avoids OOM)

`decompressStreamingChunkToFile()`:
1. Read 12-byte header start (magic, headerVersion, headerSize)
2. Read remaining header bytes
3. Parse headerVersion to know layout
4. Stream decompress using `Inflater` with 64 KB input/output buffers
5. Compute SHA-1 on the fly while writing output
6. Verify total bytes == expectedSize
7. Verify SHA-1 matches

---

## 9. File Assembly

After all chunks downloaded and decompressed in `.chunks/`:

```kotlin
for each FileManifest:
    outputFile = File(installDir, fileManifest.filename)
    outputFile.parentFile.mkdirs()
    outputFile.outputStream().use { output ->
        for each ChunkPart in fileManifest.chunkParts:
            chunkFile = File(chunkCacheDir, chunkPart.guidStr)
            chunkFile.inputStream().use { input ->
                input.skip(chunkPart.offset.toLong())   // byte offset within decompressed chunk
                copy chunkPart.size bytes to output     // using 64KB buffer
            }
    }
```

Files assembled in parallel batches of 4. `.chunks/` dir deleted after all files complete.

### Install Tags (Language Selection)

Files with empty `installTags` are ALWAYS required (base game files). Files with tags are optional.

```kotlin
fun getFilesForSelectedInstallTags(manifest, selectedTags):
    val all = manifest.fileManifestList.elements
    if (selectedTags.isEmpty()) return files where installTags.isEmpty()
    val withLanguage = all.filter { file ->
        file.installTags.isEmpty() || file.installTags.any { it in selectedTags }
    }
    // If no files matched the language tags, fall back to required-only
    return if (withLanguage.isEmpty()) required_files else withLanguage
```

**Container language to Epic install tag mapping** (key = BH/Steam container language):
```
"english"    -> ["English", "en-US", "en"]
"german"     -> ["German", "de-DE", "de"]
"french"     -> ["French", "fr-FR", "fr"]
"russian"    -> ["Russian", "ru-RU", "ru"]
"schinese"   -> ["Chinese", "ChineseSimplified", "zh-Hans", "zh_Hans", "zh"]
"tchinese"   -> ["ChineseTraditional", "zh-Hant", "zh_Hant"]
"brazilian"  -> ["PortugueseBrazilian", "Brazilian", "pt-BR", "br"]
"latam"      -> ["SpanishLatinAmerica", "Latam", "es-MX", "es_mx"]
"japanese"   -> ["Japanese", "ja-JP", "ja"]
"koreana"    -> ["Korean", "ko-KR", "ko"]
"polish"     -> ["Polish", "pl-PL", "pl"]
"turkish"    -> ["Turkish", "tr-TR", "tr"]
"arabic"     -> ["Arabic", "ar"]
... (full 29-language table in EpicConstants.CONTAINER_LANGUAGE_TO_EPIC_INSTALL_TAGS)
```

---

## 10. Launch Arguments

Built by `EpicGameLauncher.buildLaunchParameters()`, these are passed as command-line args to the game `.exe` under Wine:

```
-AUTH_LOGIN=unused
-AUTH_PASSWORD=<exchange code from /oauth/exchange>
-AUTH_TYPE=exchangecode
-epicapp=<game.appName>
-epicenv=Prod
-EpicPortal
-epicusername=<displayName>
-epicuserid=<accountId>
-epiclocale=en-US            (or locale matching container language)
-epicsandboxid=<namespace>
-epicovt=<path to .ovt file> (only if game.requiresOT == true)
```

**Offline mode:** If `game.canRunOffline == true`, pass no auth args at all (empty list).

**Ownership token file:**
- Location: `context.cacheDir/epic_tokens/<sanitizedNamespace><sanitizedCatalogId>.ovt`
- Content: binary bytes (raw ownership token, not hex)
- Cleanup: `EpicGameLauncher.cleanupOwnershipTokens()` deletes all `.ovt` files after game exits

**Exe detection** (when manifest `launchExe` not used):
```kotlin
installDir.walk()
    .filter { it.extension == "exe" }
    .filter { !"UnityCrashHandler" in it.name }
    .filter { !"UnrealCEFSubProcess" in it.name }
    .sortedBy { it.absolutePath.length }  // shortest path = main exe
    .firstOrNull()
```

**Container ID:** `"EPIC_${game.id}"` where `game.id` is the auto-generated Room integer PK.
- Do NOT use `game.appName` (UUID) — this was a bug that caused orphaned containers (PR #806 area).

---

## 11. Cloud Saves

### Base URL
```
https://datastorage-public-service-liveegs.live.use1a.on.epicgames.com
```

### API Calls

**List cloud files:**
```
GET /api/v1/access/egstore/savesync/<accountId>/<appName>/
Authorization: Bearer <accessToken>
```

Response:
```json
{
  "files": {
    "manifests/2026.03.29-10.00.00.manifest": {
      "hash": "...",
      "lastModified": "2026-03-29T10:00:00.000Z",
      "readLink": "https://...",
      "writeLink": null
    },
    "ChunksV4/00/AABB..._.chunk": {
      "hash": "...",
      "lastModified": "...",
      "readLink": "https://...",
      "writeLink": null
    }
  }
}
```

**Request write links:**
```
POST /api/v1/access/egstore/savesync/<accountId>/<appName>/
Authorization: Bearer <accessToken>
Content-Type: application/json

{ "files": ["manifests/2026.03.29-10.00.00.manifest", "ChunksV4/00/...chunk"] }
```

Response: same structure with `writeLink` populated for each requested file.

**Upload file:**
```
PUT <writeLink>
Content-Type: application/octet-stream
<binary data>
```

### Sync Decision Logic

1. `preferredAction == "download"` -> force DOWNLOAD
2. `preferredAction == "upload"` -> force UPLOAD
3. `"auto"`:
   - No local + has cloud -> DOWNLOAD
   - Has local + no cloud -> UPLOAD
   - No local + no cloud -> NONE
   - Both exist -> compare `lastModified` of latest cloud manifest vs local file timestamps -> DOWNLOAD/UPLOAD/CONFLICT

### Save Directory Path Resolution

`game.saveFolder` from catalog API has Windows-style variables, resolved against Wine prefix:

| Epic variable | Wine prefix path |
|---|---|
| `{AppData}` or `{LocalAppData}` | `drive_c/users/xuser/AppData/Local` |
| `{RoamingAppData}` | `drive_c/users/xuser/AppData/Roaming` |
| `{UserDir}` | `drive_c/users/xuser/Documents` |
| `{UserSavedGames}` | `drive_c/users/xuser/Saved Games` |
| `{UserProfile}` | `drive_c/users/xuser` |
| `{EpicId}` | accountId |
| `{InstallDir}` | game.installPath |
| `{AppName}` | game.appName |

- Replacement is case-insensitive
- Path segments are resolved case-insensitively on disk (PR #701 fix) to avoid `LocalLow` vs `locallow` duplicates
- Path traversal guard: resolved path must start with winePrefix or installDir

### Cloud Save Packaging (for upload)

Files split into 1 MB chunks:
1. Generate random GUID (4 x `SecureRandom().nextInt()`)
2. `groupNum = CRC32(guid as 16 LE bytes) % 100`
3. `rollingHash` = Epic CRC-64-ECMA hash (see Section 14)
4. `shaHash` = SHA-1 of padded (1 MB) data
5. Write 66-byte chunk header (version 3, `storedAs=0x1`, `hashType=0x3`)
6. zlib-compress data
7. Store at `ChunksV4/<groupNum>/<hashHex>_<guidHex>.chunk`

Manifest filename: `manifests/<UTC timestamp>.manifest` (e.g. `manifests/2026.03.29-10.00.00.manifest`)

Manifest `meta.appName` = `"${game.appName}${accountId}"`

---

## 12. Game Fixes / Registry Patches

Some games require Wine registry keys pointing to the install path.

| catalogId | Game | Registry Key | Value |
|---|---|---|---|
| `59a0c86d02da42e8ba6444cb171e61bf` | Oblivion | `Software\Wow6432Node\Bethesda Softworks\Oblivion` | `Installed Path` = installPath |
| `b1b4e0b67a044575820cb5e63028dcae` | Fallout 3 | `Software\Wow6432Node\Bethesda Softworks\Fallout3` | `Installed Path` = installPath |
| `dabb52e328834da7bbe99691e374cb84` | Fallout: New Vegas | `Software\Wow6432Node\Bethesda Softworks\FalloutNV` | `Installed Path` = installPath |

Note: `gameId` in fix files = `catalogItemId` (UUID), not `appName`.

---

## 13. Service Coordinator

`EpicService` is an Android foreground `Service`:

- **Sync throttle:** 15 minutes between auto-syncs; manual sync bypasses throttle
- **Actions:** `EPIC_SYNC_LIBRARY` (throttled), `EPIC_MANUAL_SYNC` (unthrottled)
- **Active downloads:** `ConcurrentHashMap<Int, DownloadInfo>` — key is `game.id` (Room PK)
- **Returns `DownloadInfo` immediately** from `downloadGame()` so UI can track progress
- **Persistence:** bytes downloaded persisted to disk at `installPath/.bytes_downloaded` for resume support

**Container ID format:** `"EPIC_${game.id}"` — game.id is the auto-generated integer Room PK, NOT appName/catalogId. Using appName was a bug that caused orphaned containers on uninstall.

**Marker files in install directory:**
- `.download_in_progress` — written at start, removed on finish
- `.download_complete` — written on successful completion

---

## 14. Helper Utilities

### GUID Format
- Binary: 4 × int32 little-endian
- `guidStr` (for file names, cache keys): `"%08x-%08x-%08x-%08x"` (lowercase with dashes)
- `guidHex` (for chunk URLs): `"%08X%08X%08X%08X"` (uppercase, no dashes, 32 chars)
- JSON manifest GUID: 32-char hex string parsed as big-endian int array

### Rolling Hash (Legendary-compatible CRC-64-ECMA)
```
Polynomial: 0xC96C5795D7870F42
Table: for i in 0..255:
         v = i.toULong()
         repeat(8): v = if (v & 1) then (v >> 1) XOR poly else v >> 1
         table[i] = v

Algorithm:
  h = 0uL
  for each byte b in data:
      h = ((h << 1) | (h >> 63)) XOR table[b.toInt() and 0xFF]
  return h
```

### groupNum Calculation
```
groupNum = CRC32(guid as 16 bytes, little-endian int32 order) % 100
```

### SHA-1 Hash Usages
- Manifest body: SHA-1(uncompressed body) == header.shaHash (integrity check on manifest download)
- Chunk data: SHA-1(decompressed chunk) == ChunkInfo.shaHash == chunk_header.shaHash (integrity check on each chunk)
- File assembly: each FileManifest has a SHA-1 of the complete assembled file

### OkHttp Clients Used
- `Net.http` (shared instance): API calls to Epic endpoints
- `cdnClient` (local, followRedirects=true): manifest binary download
- Download client (local, ConnectionPool(32)): chunk downloads with parallel connection pool

---

## 15. Notable Commits and PRs

| Ref | Description |
|---|---|
| `a6e1499cf0` | **#431** Initial Epic integration: auth, library sync, download, launch |
| `12d9117a26` | **#461** Fix exe paths with spaces under Wine |
| `af4cec05b6` | **#462** Filter out Unreal Engine apps (namespace="ue") |
| `1a5d2d02fd` | **#480** WebView OAuth — no more manual code pasting |
| `24d81e6711` | **#483** Fix header version parsing for older manifests (critical for pre-v3 chunks) |
| `4210e1b924` | **#494** Epic Token Launcher — exchange code via /oauth/exchange |
| `a1f3fd3d71` | **#495** Fix working directory — set to installDir before launch |
| `6e2c030426` | **#510** Filter invalid platforms (skip Android-only games) |
| `73f77abaaa` | **#509** Logout preserves installed games, deletes non-installed from DB |
| `e062230a96` | **#589** Cloud saves major fix: manifest creation, parsing, game ID matching |
| `c83c7e2179` | **#754** Language support via install tags (reduces download size) |
| `f2e8791e67` | Fix container ID bug: use `game.id` not `game.appName` for container name |
| `fe682992da` | **#987** Defer intent launches until Epic service is ready |

---

## 16. BannerHub Port Notes

### What to Port (in order)

1. `EpicConstants.kt` — copy directly, adapt `PrefManager` references to BH SharedPreferences
2. `EpicAuthClient.kt` — copy directly (standard OkHttp + org.json, no Kotlin coroutines needed)
3. `EpicAuthManager.kt` — port to SharedPreferences (`bh_epic_prefs`) instead of file
4. `EpicManager.kt` (library sync + manifest fetch) — port to Java; main complexity is pagination and catalog parsing
5. `EpicManifest.kt` + `JsonManifestParser.kt` — port binary/JSON parsers; all ByteBuffer operations are standard Java
6. `ManifestUtils.kt` — utility methods, straightforward port
7. `EpicDownloadManager.kt` — most complex; especially streaming chunk decompression
8. `EpicGameLauncher.kt` — port launch args; integrate with BH's existing launch mechanism

### Critical Gotchas

1. **Chunk subfolder is DECIMAL:** `"%02d".format(groupNum)` NOT hex. Confirmed in `ChunkInfo.getPath()`. Deus Ex Mankind Divided uses group 94 -> subfolder `"94"` (decimal), NOT `"5e"` (hex).

2. **Exclude Cloudflare:** Always filter `cloudflare.epicgamescdn.com` before any chunk download.

3. **No auth on chunks:** Only `User-Agent` header. No tokens. Fastly/Akamai are public.

4. **Container ID = EPIC_{game.id}:** Use the auto-generated integer DB PK, not appName or catalogId.

5. **appName for -epicapp:** Use exact Legendary app name from library API (UUID or slug). Do not sanitize.

6. **baseGameAppName stores catalogId:** Despite the field name saying "app_name", it actually stores the `id` (catalogId) of the base game. Required for DLC detection query.

7. **Library pagination:** Must follow nextCursor until null. Large libraries need multiple pages.

8. **Platform filter:** Skip if `platform` non-empty AND contains neither "Win32" nor "Windows".

9. **Namespace filter:** Skip `"ue"` and `"89efe5924d3d467c839449ab6ab52e7f"`.

10. **Token refresh:** Check `now + 5min >= expiresAt` before API calls. On refresh failure, require re-login.

11. **Working directory:** Set game's install directory as working directory before Wine launch.

12. **FString null terminators:** ASCII strings have 1 null byte, UTF-16 strings have 2 null bytes. Read length includes the null terminator.

### All Endpoints at a Glance

| Purpose | Method | URL |
|---|---|---|
| Get/refresh auth token | POST | `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token` |
| Get exchange code | GET | `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange` |
| Get ownership token (Denuvo) | POST | `https://ecommerceintegration-public-service-ecomprod02.ol.epicgames.com/ecommerceintegration/api/public/platforms/EPIC/identities/<accountId>/ownershipToken` |
| Library items | GET | `https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true` |
| Catalog bulk item details | GET | `https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace/<ns>/bulk/items?id=<id>&includeDLCDetails=true&includeMainGameDetails=true` |
| Manifest URL list | GET | `https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace/<ns>/catalogItem/<id>/app/<appName>/label/Live` |
| Manifest binary | GET | `<uri from above>?<queryParams>` (no auth header) |
| Chunk download | GET | `<cdnBase><cloudDir>/ChunksV4/<groupDecimal>/<hash16>_<guid32>.chunk` (no auth header) |
| Cloud save list | GET | `https://datastorage-public-service-liveegs.live.use1a.on.epicgames.com/api/v1/access/egstore/savesync/<accountId>/<appName>/` |
| Cloud save upload links | POST | same URL |

### Test Fixtures

`app/src/test/resources/epic/` contains real API response JSON:
- `library_items.json` — library API paginated response
- `darksiders_catalog.json`, `dragonage_catalog.json`, `watchdogs_catalog.json` — catalog API responses

Use these to test parser without hitting live API.

### Android Manifest Test Assets

`app/src/androidTest/assets/`:
- `binary-control-file.manifest` + `.expected.json` — binary manifest parse test
- `test-manifest.json` + `.expected.json` — JSON manifest parse test
- `test-v3-manifest.json` + `.expected.json` — v3 binary manifest parse test
