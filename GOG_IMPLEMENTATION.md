# GameNative GOG Integration — Full Technical Report

Source repository: https://github.com/utkarshdalal/GameNative
Report date: 2026-03-21

---

## Table of Contents

1. [Authentication](#1-authentication)
2. [Game Library — Discovery and Metadata](#2-game-library--discovery-and-metadata)
3. [Data Model and Local Storage](#3-data-model-and-local-storage)
4. [Images and Media](#4-images-and-media)
5. [UI Display](#5-ui-display)
6. [Download Pipeline — Gen 2 (Modern)](#6-download-pipeline--gen-2-modern)
7. [Download Pipeline — Gen 1 (Legacy)](#7-download-pipeline--gen-1-legacy)
8. [Dependencies Pipeline](#8-dependencies-pipeline)
9. [API Reference Summary](#9-api-reference-summary)
10. [Key Constants and Configuration](#10-key-constants-and-configuration)
11. [Service Layer — GOGService](#11-service-layer--gogservice)
12. [Game Launch — Executable Discovery and Wine Command](#12-game-launch--executable-discovery-and-wine-command)
13. [Post-Install Steps — Script Interpreter and Dependencies](#13-post-install-steps--script-interpreter-and-dependencies)
14. [Uninstall / Delete](#14-uninstall--delete)
15. [Installation Verification](#15-installation-verification)
16. [Game Fixes (Per-Title Overrides)](#16-game-fixes-per-title-overrides)
17. [BannerHub Integration Guide](#17-bannerhub-integration-guide)

---

## 1. Authentication

### OAuth2 Flow

File: `GOGOAuthActivity.kt`, `GOGAuthManager.kt`

Authentication uses GOG Galaxy's standard OAuth2 authorization-code flow:

1. A per-session `state` parameter (32 random bytes, hex-encoded) is generated for CSRF protection.
2. A `GOGOAuthActivity` opens an in-app WebView (`AuthWebViewDialog`) loaded with:
   ```
   https://auth.gog.com/auth
     ?client_id=46899977096215655
     &redirect_uri=https://embed.gog.com/on_login_success?origin=client
     &response_type=code
     &layout=galaxy
     &state={randomState}
   ```
3. On every URL change in the WebView, the activity checks:
   - Whether the URL matches the redirect URI (`embed.gog.com/on_login_success`)
   - Whether the `state` query param matches the stored value (CSRF check — mismatches are silently dropped)
   - Extracts `code=` query param from the redirect URL
4. The extracted code is passed back via `Activity.RESULT_OK` intent extra `auth_code`.

### Token Exchange

```
GET https://auth.gog.com/token
  ?client_id=46899977096215655
  &client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9
  &grant_type=authorization_code
  &code={authCode}
  &redirect_uri=https://embed.gog.com/on_login_success?origin=client
```

Note: The `client_id` and `client_secret` are the public GOG Galaxy app credentials — they are
intentionally public and widely known (same ones used by heroic-gogdl, Heroic Games Launcher, etc.).

Response fields used:
- `access_token` — used as Bearer token for all API calls
- `refresh_token` — used to obtain new access tokens when expired
- `user_id` — stored for later use
- `expires_in` — seconds until token expires

### Credential Storage

Credentials are stored as JSON in `{filesDir}/gog_auth.json`:
```json
{
  "46899977096215655": {
    "access_token": "...",
    "refresh_token": "...",
    "user_id": "...",
    "expires_in": 3600,
    "loginTime": 1711234567.0
  }
}
```

The file is keyed by `client_id`. Multiple entries are possible — one for the Galaxy app
credentials and additional entries for per-game credentials (used by cloud saves).

### Token Refresh

On every call to `getStoredCredentials()`:
- Checks `System.currentTimeMillis()/1000 >= loginTime + expiresIn`
- If expired, calls:
  ```
  GET https://auth.gog.com/token
    ?client_id={clientId}
    &client_secret={clientSecret}
    &grant_type=refresh_token
    &refresh_token={refreshToken}
  ```
- Updates `gog_auth.json` with fresh tokens and new `loginTime`
- Recursively re-reads the file

### Per-Game Credentials (Cloud Saves)

GOG cloud saves require a game-specific access token. The flow:
1. Fetch the game's build manifest to extract `clientSecret`
2. Call token endpoint with `grant_type=refresh_token` using the Galaxy app's refresh token,
   but `client_id`/`client_secret` of the game
3. Store the result under the game's `clientId` key in `gog_auth.json`
4. This scoped token is what GOG's cloud save API requires

### Logout

Deletes `gog_auth.json` entirely.

---

## 2. Game Library — Discovery and Metadata

### Step 1 — Fetch Owned Game IDs

File: `GOGApiClient.kt` (`getGameIds`)

```
GET https://embed.gog.com/user/data/games
Authorization: Bearer {accessToken}
User-Agent: GameNative/1.0
```

Response:
```json
{ "owned": [1234567890, 9876543210, ...] }
```

Returns all numeric GOG product IDs owned by the account. The `owned` array contains integers
which are converted to strings.

### Step 2 — Skip Already-Known Games

`GOGManager.refreshLibrary()` fetches all IDs from the local Room database
(`gogGameDao.getAllGameIdsIncludingExcluded()`) and only fetches details for IDs not already stored.
This avoids re-fetching on every sync.

ID `1801418160` (GOG Galaxy itself) is explicitly ignored.

### Step 3 — Fetch Game Details

File: `GOGApiClient.kt` (`getGameById`)

```
GET https://api.gog.com/products/{gameId}?expand=downloads,description,screenshots
Authorization: Bearer {accessToken}
User-Agent: GameNative/1.0
```

Raw response fields used:

| Field | Usage |
|---|---|
| `title` | Game name |
| `slug` | URL-friendly name |
| `images.logo2x` / `images.logo` | Box art / hero image URL (protocol-relative `//` → prefixed with `https:`) |
| `images.icon` | Small icon URL |
| `developers[0].name` | Developer string |
| `publisher.name` or `publisher` (string) | Publisher (handles both object and plain string) |
| `genres[].name` | Genre list |
| `languages` (object, keys only) | Language code list |
| `description.lead` | Short description text |
| `release_date` | ISO 8601 date string (e.g. `"2022-08-18T17:50:00+0300"`) |
| `downloads.installers[0].total_size` | Download size in bytes |
| `is_secret` | Boolean — hides the game if true (Amazon Prime entitlements etc.) |
| `game_type` | `"dlc"` causes the game to be excluded from the library |

### Filtering / Exclusion Rules

A game is marked `exclude=true` (stored in DB but not shown) if any of:
- `title == "Unknown Game"` or starts with `"product_title_"` or is `"Unknown"`
- `downloadSize == 0`
- `isSecret == true`
- `title` ends with `"Amazon Prime"`
- `isDlc == true`

DLCs are excluded from the main library display but kept in the DB so their depots can be
recognized during ownership checks at download time.

### Batch Processing

Games are upserted in batches of 10 (`REFRESH_BATCH_SIZE = 10`) to avoid holding large
in-memory lists. After each batch, `gogGameDao.upsertPreservingInstallStatus()` is called, which
preserves `isInstalled`, `installPath`, `installSize`, `lastPlayed`, `playTime` for games that
already exist in the DB.

### Installation Detection on Sync

After library sync, `detectAndUpdateExistingInstallations()` scans:
- `{dataDir}/GOG/games/common/` (internal storage)
- `{externalStoragePath}/GOG/games/common/` (external storage, if enabled)

For each subdirectory it finds `.info` files containing JSON with a `gameId` field,
cross-references against the DB, and marks the game as installed if found.

---

## 3. Data Model and Local Storage

### `GOGGame` Entity (Room database table `gog_games`)

File: `GOGGame.kt`

| Column | Type | Notes |
|---|---|---|
| `id` | String (PK) | Numeric GOG product ID as string |
| `title` | String | Display name |
| `slug` | String | URL slug |
| `download_size` | Long | Bytes, from `installers[0].total_size` |
| `install_size` | Long | Bytes, calculated from filesystem after install |
| `is_installed` | Boolean | Updated after successful download |
| `install_path` | String | Absolute path to install directory |
| `image_url` | String | Box art / hero URL (logo2x preferred) |
| `icon_url` | String | Small icon URL |
| `description` | String | Short lead description |
| `release_date` | String | Raw ISO 8601 string from GOG API |
| `developer` | String | First developer name |
| `publisher` | String | Publisher name |
| `genres` | List<String> | Stored via Room TypeConverter |
| `languages` | List<String> | Language code list |
| `last_played` | Long | Unix timestamp ms |
| `play_time` | Long | Seconds |
| `type` | AppType | Enum, defaults to `game` |
| `exclude` | Boolean | Hidden from UI if true |

### DAO Queries (`GOGGameDao`)

| Method | Query |
|---|---|
| `getAll()` | All non-excluded games, alphabetical, as `Flow` |
| `getByInstallStatus(bool)` | Filter by `is_installed`, as `Flow` |
| `searchByTitle(query)` | `LIKE '%query%'` search, as `Flow` |
| `getAllGameIdsIncludingExcluded()` | All IDs regardless of exclude flag (for ownership checks) |
| `deleteAllNonInstalledGames()` | Clears uninstalled games from DB on re-sync |
| `upsertPreservingInstallStatus()` | @Transaction — inserts new, preserves install fields for existing |

### `GOGCredentials`

Transient data class (not persisted by Room, only used in-memory):
- `accessToken`, `refreshToken`, `userId`, `username`

### Manifest File (`_gog_manifest.json`)

Written to the game's install directory after a successful download:
```json
{
  "version": 2,
  "baseProductId": "1234567890",
  "scriptInterpreter": false,
  "products": [
    { "productId": "1234567890", "name": "Game Title",
      "temp_executable": "", "temp_arguments": "" }
  ],
  "buildId": "...",
  "versionName": "1.0.0",
  "language": "en-US"
}
```

Used on first launch to decide post-install steps (run GOG's script interpreter or a
`temp_executable` installer).

---

## 4. Images and Media

### Sources

All image URLs come from the `GET /products/{id}?expand=...` response:

- **Hero/box art** — `images.logo2x` (preferred) or `images.logo`. Protocol-relative URLs
  (`//images.gog.com/...`) are corrected to `https://images.gog.com/...` during parsing.
- **Icon** — `images.icon`, same protocol-relative fixup applied.

There is no secondary screenshot or background art fetched during library sync — only
`logo2x`, `logo`, and `icon`.

### Storage

Image URLs are stored as plain strings in the `gog_games` table (`image_url`, `icon_url`).
Images are **not** downloaded or cached locally by the sync process — they remain remote URLs.

### Display / Loading

File: `GOGAppScreen.kt`

The UI uses `GameDisplayInfo`:
```kotlin
GameDisplayInfo(
    iconUrl  = game?.iconUrl  ?: libraryItem.iconHash,
    heroImageUrl = game?.imageUrl ?: game?.iconUrl ?: libraryItem.iconHash,
    ...
)
```

The `heroImageUrl` falls back from `imageUrl` → `iconUrl` → the generic `libraryItem.iconHash`
so something is always displayed. Image loading itself is handled by Coil (used elsewhere in the
project) via Compose's `AsyncImage` components in the shared library UI layer.

Images are loaded on demand from the remote GOG CDN each time they are displayed — no local
caching layer is implemented in the GOG path specifically.

---

## 5. UI Display

### `GOGAppScreen`

File: `GOGAppScreen.kt`

Extends `BaseAppScreen` — a shared Compose screen base used by all store integrations (Steam,
Epic, GOG, Amazon). GOG-specific overrides:

**`getGameDisplayInfo()`**
- Calls `GOGService.getGOGGameOf(gameId)` (async, on `LaunchedEffect`)
- Listens for `AndroidEvent.LibraryInstallStatusChanged` events to re-fetch and refresh display
  when install state changes
- Parses `releaseDate` from GOG's ISO 8601 format (`"yyyy-MM-dd'T'HH:mm:ssZ"`) to Unix timestamp
  seconds for the shared `GameDisplayInfo` struct
- Formats `downloadSize` and `installSize` into human-readable strings (`KB`/`MB`/`GB`) at
  `1024` base

**`isInstalled()`** — delegates to `GOGService.isGameInstalled(gameId)`

**`isDownloading()`** — checks `GOGService.getDownloadInfo(gameId)` for an active, incomplete
download (`isActive() == true && progress < 1.0f`)

**`getDownloadProgress()`** — returns `downloadInfo.getProgress()` as `Float` 0–1

**Uninstall Dialog** — static `mutableStateListOf<String>` shared across all instances;
`showUninstallDialog(appId)` / `hideUninstallDialog(appId)` / `shouldShowUninstallDialog(appId)`
control visibility

**Menu options** — built from `AppMenuOption` enum; available options depend on install/download
state (Install, Uninstall, Play, etc.) — implementation deferred to `BaseAppScreen`

---

## 6. Download Pipeline — Gen 2 (Modern)

File: `GOGDownloadManager.kt`, `GOGApiClient.kt` (api package), `GOGManifestParser.kt`

The Gen 2 (Galaxy) format uses a chunked, content-addressed CDN. Almost all modern GOG games
use Gen 2.

### Step 1 — Select Build

```
GET https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=2
Authorization: Bearer {accessToken}
```

Response: `{ "total_count": N, "count": N, "items": [ { "build_id", "product_id", "os",
"generation", "version_name", "branch", "link", "legacy_build_id" }, ... ] }`

Strategy: try Gen 2 first (`generation=2`), fall back to Gen 1 (`generation=1`). Within each
generation, pick the first item matching `os == "windows"`.

### Step 2 — Fetch Build Manifest

```
GET {build.link}
Authorization: Bearer {accessToken}
```

Response is **zlib or gzip compressed JSON** — detected by magic bytes:
- `0x1F 0x8B` = gzip → `GZIPInputStream`
- `0x78 0x9C` / `0x78 0x01` / `0x78 0xDA` = zlib → `java.util.zip.Inflater`
- Otherwise treated as plain UTF-8

Decompressed JSON structure (Gen 2):
```json
{
  "baseProductId": "1234567890",
  "installDirectory": "GameTitle",
  "depots": [
    {
      "productId": "1234567890",
      "languages": ["en-US", "*"],
      "manifest": "abcdef1234...",
      "compressedSize": 1234567,
      "size": 9876543,
      "osBitness": ["64"]
    }
  ],
  "dependencies": ["MSVC2017", "ISI"],
  "products": [
    { "productId": "1234567890", "name": "Game Title",
      "temp_executable": "", "temp_arguments": "" }
  ],
  "scriptInterpreter": false
}
```

### Step 3 — Filter Depots by Language

`GOGManifestParser.filterDepotsByLanguage()`:
1. Maps container language name (e.g. `"german"`) to an ordered list of GOG codes via
   `GOGConstants.CONTAINER_LANGUAGE_TO_GOG_CODES`:
   - `"german"` → `["german", "de-DE", "de"]`
2. Tries each code in order; uses the first that matches any depot's `languages[]`
3. Depots with language `"*"` are always included (language-neutral content)
4. If no match, falls back to English codes: `["english", "en-US", "en"]`
5. Ownership filter: drops depots whose `productId` is not in `gogGameDao.getAllGameIdsIncludingExcluded()`
   — this silently excludes unowned DLC depots

### Step 4 — Fetch Depot Manifests (Gen 2)

For each depot's `manifest` hash:

CDN path format (GOG Galaxy path):
```
hash "abcdef1234..." -> "ab/cd/abcdef1234..."
```

```
GET https://gog-cdn-fastly.gog.com/content-system/v2/meta/{AA}/{BB}/{fullHash}
Authorization: Bearer {accessToken}
```

Response: same zlib/gzip-compressed JSON. Decompressed structure:
```json
{
  "depot": {
    "items": [
      {
        "type": "DepotFile",
        "path": "Binaries\\Win64\\Game.exe",
        "md5": "abc123...",
        "sha256": "...",
        "flags": [],
        "productId": "1234567890",
        "chunks": [
          {
            "compressedMd5": "deadbeef...",
            "md5": "cafebabe...",
            "size": 1048576,
            "compressedSize": 524288
          }
        ]
      },
      { "type": "DepotDirectory", "path": "Binaries\\Win64" },
      { "type": "DepotLink", "path": "link", "target": "target" }
    ]
  }
}
```

Path separators: backslashes are normalized to forward slashes; leading `/` is stripped.

Support files (redistributables) are identified by `flags: ["support"]`.

### Step 5 — Separate and Filter Files

- **Base vs DLC**: files with `productId == null` or `productId == baseProductId` are base game;
  others are DLC (included only if `withDlcs=true`)
- **Support files**: `flags.contains("support")` — separated; installed to `supportDir` if provided
- **Incremental**: files already on disk with matching size AND MD5 are skipped
- **Placeholder productId**: `productId == "2147483047"` is treated as a placeholder and replaced
  with the depot's own `productId`

### Step 6 — Get Secure CDN Links

One call per owned product ID (base game + each owned DLC):

```
GET https://content-system.gog.com/products/{productId}/secure_link
  ?_version=2&generation=2&path=/
Authorization: Bearer {accessToken}
```

Response:
```json
{
  "urls": [
    {
      "url_format": "https://gog-cdn-fastly.gog.com/token=nva={expires}&.../{path}",
      "parameters": { "expires_at": "...", ... }
    }
  ]
}
```

URL construction: replace all `{param}` placeholders with values from `parameters`, unescape `\/` → `/`.

These are time-limited CDN base URLs. The first URL in the array is used as the CDN base.

### Step 7 — Build Chunk URL Map

For each chunk's `compressedMd5` hash:
```
chunkUrl = "{secureBaseUrl}/{hash[0..1]}/{hash[2..3]}/{fullHash}"
```

Each chunk is mapped to the CDN URL of its owning product (base game or DLC), using
`chunkToProductMap` built in step 6 mapping.

### Step 8 — Download Chunks

Parallel downloads, 4 at a time (`MAX_PARALLEL_DOWNLOADS = 4`).
Chunks are cached in `{installPath}/.gog_chunks/` as `{compressedMd5}.chunk`.

Per chunk:
1. Check if `{hash}.chunk` already exists and MD5 of its contents matches `compressedMd5` — skip if so
2. `GET {chunkUrl}` with `User-Agent: GOG Galaxy`
3. Verify `MD5(responseBytes) == compressedMd5` (compressed-data integrity check)
4. Write raw compressed bytes to `.chunk` file
5. Update `DownloadInfo.bytesDownloaded`

**Retry logic**: up to 3 attempts (`MAX_CHUNK_RETRIES`) with exponential backoff (1s, 2s, 4s).

**Expired link detection**: if any chunk in a batch fails with HTTP 401/403/404, the secure links
for all products are refreshed (re-calling `getSecureLink` for each product) and the entire
failing batch is retried with new URLs. This is transparent to the caller.

**Download in-progress marker**: `DOWNLOAD_IN_PROGRESS_MARKER` is written to the install
directory before chunk downloading begins and removed on success or failure. This lets
reinstall/verification logic detect partial installs.

### Step 9 — Assemble Files

For each `DepotFile`:
1. Create output file at `{installDir}/{file.path}` (parent dirs created as needed)
2. For each chunk in `file.chunks` (in order):
   a. Read `{hash}.chunk` from cache dir
   b. If `chunk.compressedSize == null`: data is uncompressed, write directly
   c. Otherwise: zlib-decompress using `java.util.zip.Inflater`
   d. Verify `MD5(decompressedBytes) == chunk.md5`
   e. Write decompressed bytes to output file
3. Optionally verify `MD5(outputFile) == file.md5` — mismatch logs a warning but does NOT fail
   (some GOG games ship incorrect MD5s in their manifests)

### Step 10 — Finalize

1. Clean up `.gog_chunks/` cache directory
2. Write `_gog_manifest.json` to install directory
3. Update DB: `isInstalled=true`, `installPath`, `installSize` (calculated by recursive dir walk)
4. Remove `DOWNLOAD_IN_PROGRESS_MARKER`, add `DOWNLOAD_COMPLETE_MARKER`
5. Emit `AndroidEvent.DownloadStatusChanged(gameId, false)`
6. Emit `AndroidEvent.LibraryInstallStatusChanged(gameId)` (triggers UI refresh)

---

## 7. Download Pipeline — Gen 1 (Legacy)

For older games. Detected when `selectedBuild.generation == 1` and
`gameManifest.productTimestamp != null`.

### Key Differences from Gen 2

| | Gen 1 | Gen 2 |
|---|---|---|
| Files | Direct byte-range reads from one `main.bin` | Chunked, content-addressed |
| Manifest | `product.depots[]` with `manifest` hash + `timestamp` | `depots[]` with `manifest` hash only |
| CDN path | `/content-system/v1/manifests/{productId}/{platform}/{timestamp}/{hash}` | `/content-system/v2/meta/{AA}/{BB}/{hash}` |
| Secure link path | `/{platform}/{timestamp}/` | `/` |
| Download | `Range: bytes={offset}-{offset+size-1}` on `main.bin` | Separate chunk files |
| Compression | None (raw bytes) | zlib per chunk |
| Verification | MD5 of full file | MD5 per chunk (compressed + decompressed) |

### Gen 1 Flow

1. Build manifest has `product.productTimestamp` (used in all CDN paths)
2. Depot manifest URL:
   ```
   GET https://gog-cdn-fastly.gog.com/content-system/v1/manifests
     /{productId}/{platform}/{timestamp}/{manifestHash}
   Authorization: Bearer {accessToken}
   ```
   Response: plain JSON with `depot.files[]`:
   ```json
   {
     "depot": {
       "files": [
         { "path": "Bin/game.exe", "size": 12345, "hash": "abc...",
           "offset": 0, "support": false }
       ]
     }
   }
   ```
3. Secure link uses path `/{platform}/{timestamp}/` (generation=1):
   ```
   GET https://content-system.gog.com/products/{productId}/secure_link
     ?_version=2&type=depot&path=/{platform}/{timestamp}/
   ```
4. Append `/main.bin` to secure CDN base URL → `{secureBase}/main.bin`
5. Per file: `GET {main.bin url}` with `Range: bytes={offset}-{offset+size-1}`
6. Stream response directly to output file using `DigestOutputStream` (MD5 computed on-the-fly)
7. Verify `MD5(file) == file.hash` and `file.length() == file.size`
8. Progress reported every 512KB

Files with `support: true` go to `supportDir` instead of `installPath`.

---

## 8. Dependencies Pipeline

GOG games declare runtime dependencies (MSVC, DirectX, GOG Script Interpreter, etc.) in the
build manifest's `dependencies[]` array. These are downloaded separately after game files.

### Step 1 — Fetch Dependency Repository

```
GET https://content-system.gog.com/dependencies/repository?generation=2
Authorization: Bearer {accessToken}
```

Response: `{ "repository_manifest": "https://...", "generation": 2, "build_id": "..." }`

The `repository_manifest` URL points to a compressed JSON listing all known dependencies.

### Step 2 — Fetch Dependency Manifest

```
GET {repositoryManifest}
Authorization: Bearer {accessToken}
```

Response: zlib/gzip compressed JSON. Decompressed:
```json
{
  "depots": [
    {
      "dependencyId": "MSVC2017",
      "readableName": "Microsoft Visual C++ 2017 Redistributable",
      "manifest": "abcdef...",
      "compressedSize": 1234,
      "size": 5678,
      "languages": ["*"],
      "osBitness": ["32", "64"],
      "signature": "...",
      "executable": { "path": "__redist/MSVC2017/VC_redist.x86.exe", "arguments": "/q" },
      "internal": false
    }
  ]
}
```

Filtered to only the `dependencyId` values listed in the game manifest's `dependencies[]`.

### Step 3 — Get Open Links (No Auth Required)

```
GET https://content-system.gog.com/open_link
  ?generation=2&_version=2&path=/dependencies/store/
Authorization: Bearer {accessToken}
```

Returns the same `url_format` + `parameters` structure as `getSecureLink`. Constructed URLs
are used as CDN base for dependency chunk downloads — no per-request auth needed.

### Step 4 — Fetch Dependency Depot Manifests

```
GET https://gog-cdn-fastly.gog.com/content-system/v2/dependencies/meta/{AA}/{BB}/{hash}
(no auth header — uses open link)
```

Same format as game depot manifests.

### Step 5 — Download and Assemble

Same chunk download and assembly process as Gen 2 game files, but:
- Simpler `downloadChunksSimple()` — no expired-link retry (open links don't expire the same way)
- Install target: if `depot.executable.path` starts with `"__redist"` → goes to `supportDir`;
  otherwise → goes to `gameDir`
- Paths prefixed with `__redist/` are stripped when installing to `supportDir`

---

## 9. API Reference Summary

| Purpose | Method | URL |
|---|---|---|
| OAuth login page | WebView | `https://auth.gog.com/auth?client_id=...&layout=galaxy` |
| Exchange auth code | GET | `https://auth.gog.com/token?grant_type=authorization_code&code=...` |
| Refresh token | GET | `https://auth.gog.com/token?grant_type=refresh_token&refresh_token=...` |
| Owned game IDs | GET | `https://embed.gog.com/user/data/games` |
| Game metadata | GET | `https://api.gog.com/products/{id}?expand=downloads,description,screenshots` |
| Available builds | GET | `https://content-system.gog.com/products/{id}/os/windows/builds?generation=2` |
| Build manifest | GET | `{build.link}` (URL from builds response) |
| Gen 2 depot manifest | GET | `https://gog-cdn-fastly.gog.com/content-system/v2/meta/{AA}/{BB}/{hash}` |
| Gen 1 depot manifest | GET | `https://gog-cdn-fastly.gog.com/content-system/v1/manifests/{id}/{platform}/{ts}/{hash}` |
| Secure CDN links (Gen 2) | GET | `https://content-system.gog.com/products/{id}/secure_link?_version=2&generation=2&path=/` |
| Secure CDN links (Gen 1) | GET | `https://content-system.gog.com/products/{id}/secure_link?_version=2&type=depot&path=/{platform}/{ts}/` |
| Chunk download | GET | `{secureBaseUrl}/{AA}/{BB}/{compressedMd5}` |
| Gen 1 file download | GET | `{secureBaseUrl}/main.bin` with `Range:` header |
| Dependency repository | GET | `https://content-system.gog.com/dependencies/repository?generation=2` |
| Dependency manifest | GET | `{repositoryManifest}` |
| Dependency open links | GET | `https://content-system.gog.com/open_link?generation=2&_version=2&path=/dependencies/store/` |
| Dependency depot manifest | GET | `https://gog-cdn-fastly.gog.com/content-system/v2/dependencies/meta/{AA}/{BB}/{hash}` |

All requests except dependency chunk downloads use `Authorization: Bearer {accessToken}`.

---

## 10. Key Constants and Configuration

| Constant | Value | Notes |
|---|---|---|
| `GOG_CLIENT_ID` | `46899977096215655` | Public Galaxy app client ID |
| `GOG_CLIENT_SECRET` | `9d85c43b1482497...` | Public Galaxy app secret (same as heroic-gogdl) |
| `GOG_REDIRECT_URI` | `https://embed.gog.com/on_login_success?origin=client` | OAuth redirect |
| `GOG_BASE_API_URL` | `https://api.gog.com` | Game metadata API |
| `GOG_EMBED_URL` | `https://embed.gog.com` | Owned games list |
| `GOG_AUTH_URL` | `https://auth.gog.com` | Authentication |
| `GOG_CDN` | `https://gog-cdn-fastly.gog.com` | Content delivery |
| `GOG_CONTENT_SYSTEM` | `https://content-system.gog.com` | Build/depot metadata |
| `MAX_PARALLEL_DOWNLOADS` | `4` | Concurrent chunk downloads |
| `MAX_CHUNK_RETRIES` | `3` | Per-chunk retry attempts |
| `RETRY_DELAY_MS` | `1000` ms (exponential) | 1s, 2s, 4s |
| `CHUNK_BUFFER_SIZE` | `1 MB` | Read buffer for assembly |
| `REFRESH_BATCH_SIZE` | `10` | Library sync DB batch size |
| Internal games path | `{dataDir}/GOG/games/common/` | Default install location |
| External games path | `{externalStoragePath}/GOG/games/common/` | External SD card path |
| Auth file | `{filesDir}/gog_auth.json` | Token storage |
| Manifest file | `{installDir}/_gog_manifest.json` | Post-install launch metadata |
| Chunk cache | `{installDir}/.gog_chunks/` | Temp, deleted after assembly |

### CDN Path Format

```
hash "abcdef1234abcdef..." -> "ab/cd/abcdef1234abcdef..."
                               ^^  ^^  ^^^^^^^^^^^^^^^^
                           [0..1] [2..3] [full hash]
```

Used for both manifests and chunk files.

### Language Code Mapping (selected)

Container language → GOG manifest codes (tried in order):
```
"english"  -> ["english",  "en-US", "en"]
"german"   -> ["german",   "de-DE", "de"]
"french"   -> ["french",   "fr-FR", "fr"]
"russian"  -> ["russian",  "ru-RU", "ru"]
"schinese" -> ["schinese", "zh-Hans", "zh_Hans", "zh", "cn"]
```
Unknown language → falls back to English codes.
Depots with `"*"` language are always included regardless of language selection.

---

## Notes on Known Issues (from source code comments)

1. **Secure link expiry during download** — the code explicitly handles 401/403/404 mid-download
   and refreshes links, but the comment in `downloadGame()` states "We have issues here" at steps
   3 and 4, suggesting this is still an area of active work.

2. **Incorrect MD5s in manifests** — file-level MD5 mismatches after assembly are logged as
   warnings but not treated as errors, because some GOG titles ship broken MD5 values in their
   depot manifests.

3. **Placeholder productId `2147483047`** — a known placeholder value used in some depot files.
   Code TODO notes this logic should eventually always use `depotProductId` instead.

4. **Library refresh is sequential** — the comment in `refreshLibrary()` explicitly notes that
   parallel fetching was considered but not implemented to avoid GOG API rate limiting.

---

## 11. Service Layer — GOGService

File: `GOGService.kt`

`GOGService` is an Android foreground `Service` that acts as the single entry point for all GOG
operations from the UI layer. Everything is exposed as `companion object` static methods so the UI
never needs a bound service reference — it calls `GOGService.someMethod(context)` directly.

### Lifecycle

- Started via `GOGService.start(context)` — calls `startForegroundService`
- Runs as a sticky foreground service (returns `START_STICKY`) — Android restarts it if killed
- Holds a `CoroutineScope(Dispatchers.IO + SupervisorJob())` for all async work
- Stores singleton instance in `private var instance: GOGService?` — accessed via `getInstance()`
- Destroyed on `AndroidEvent.EndProcess` (app exit)

### Sync Throttling

- First start always syncs immediately
- Subsequent starts check `timeSinceLastSync >= 15 minutes` before triggering sync
- `triggerLibrarySync(context)` bypasses throttle (manual user refresh)
- Sync state tracked with `syncInProgress: Boolean` and `backgroundSyncJob: Job?`

### Download Tracking

Downloads are tracked in a `ConcurrentHashMap<String, DownloadInfo>` keyed by `gameId`. Key methods:

| Method | What it does |
|---|---|
| `downloadGame(context, gameId, installPath, containerLanguage)` | Creates `DownloadInfo`, launches download coroutine in service scope, returns `DownloadInfo` immediately |
| `getDownloadInfo(gameId)` | Returns live `DownloadInfo` for progress polling |
| `cancelDownload(gameId)` | Calls `downloadInfo.cancel()` and removes from map |
| `hasActiveDownload()` | True if any download is running |
| `getCurrentlyDownloadingGame()` | Returns first active `gameId` |
| `cleanupDownload(gameId)` | Removes stale entry after completion |

`downloadGame()` always passes `withDlcs=true` and `commonRedist` (`{installPath}/_CommonRedist`)
as `supportDir` — meaning dependencies always go to `_CommonRedist` in the game folder.

### Static Delegate Methods

Every manager method is re-exposed as a static companion method:

```
GOGService.authenticateWithCode()    -> GOGAuthManager.authenticateWithCode()
GOGService.hasStoredCredentials()    -> GOGAuthManager.hasStoredCredentials()
GOGService.refreshLibrary()          -> GOGManager.refreshLibrary()
GOGService.isGameInstalled()         -> GOGManager.verifyInstallation() [also checks DB]
GOGService.getInstallPath()          -> GOGManager.getGameFromDbById().installPath
GOGService.getInstalledExe()         -> GOGManager.getInstalledExe()
GOGService.getLaunchExecutable()     -> GOGManager.getLaunchExecutable()
GOGService.getGogWineStartCommand()  -> GOGManager.getGogWineStartCommand()
GOGService.deleteGame()              -> GOGManager.deleteGame()
GOGService.syncCloudSaves()          -> GOGCloudSavesManager.syncSaves()
GOGService.logout()                  -> clears credentials + DB + stops service
```

### Logout

`GOGService.logout()`:
1. Calls `GOGAuthManager.clearStoredCredentials()` — deletes `gog_auth.json`
2. Calls `GOGManager.deleteAllNonInstalledGames()` — removes uninstalled game records from DB
   (installed games are kept so the user keeps their data)
3. Stops the service

---

## 12. Game Launch — Executable Discovery and Wine Command

File: `GOGManager.kt`

### Executable Discovery (`getInstalledExe`)

GOG games ship a `goggame-{gameId}.info` JSON file inside the install directory. This file
contains a `playTasks` array:

```json
{
  "playTasks": [
    {
      "isPrimary": true,
      "path": "Bin\\Game.exe",
      "workingDir": ""
    }
  ]
}
```

Discovery strategy:
1. Look for `goggame-*.info` in the game directory (recursive, up to 3 levels deep)
2. Parse `playTasks`, find the entry with `isPrimary: true`
3. Resolve the `path` relative to the game dir using case-insensitive file search
   (`FileUtils.findFileCaseInsensitive`) — important because Windows paths are case-insensitive
   but Android's filesystem is not
4. Return the path **relative to the install root** (not absolute)

Two install directory structures are checked:
- **V2** — `game_{gameId}/` subdirectory inside the install root
- **V1** — install root itself, then top-level subdirectories (excluding `saves/` and `_CommonRedist/`)

If no `.info` file or no primary task is found, returns empty string and Wine opens `explorer.exe`
as fallback.

### Wine Launch Command (`getGogWineStartCommand`)

Steps:
1. Verify installation (`verifyInstallation` — checks DB + directory exists + non-empty)
2. Use `container.executablePath` if already configured, otherwise auto-detect via `getInstalledExe`
   and save the result back to the container for future launches
3. Find which Wine drive letter maps to the game's install path by iterating `container.drives`
4. Build the Windows path: `{driveLetter}:\{relativePath}` with forward slashes → backslashes
5. Set `guestProgramLauncherComponent.workingDir` to the exe's parent directory
6. Set `envVars.WINEPATH` to `{driveLetter}:\`

The result is a quoted Windows path string like `"A:\Bin\Game.exe"` passed directly to Wine's
`winestart` command.

### `goggame-*.info` File — Full Structure Used

```json
{
  "gameId": "1234567890",
  "clientId": "...",
  "playTasks": [
    {
      "isPrimary": true,
      "path": "relative\\path\\to\\game.exe",
      "workingDir": ""
    }
  ]
}
```

The `gameId` field is also used during installation detection (`detectGameFromDirectory`) to
match an install directory back to a DB record.

The `clientId` field is used for cloud saves — it is the per-game OAuth client ID needed to
obtain game-scoped credentials.

---

## 13. Post-Install Steps — Script Interpreter and Dependencies

### What is the GOG Script Interpreter?

Some GOG games require a post-install setup step that runs a Windows executable called
`scriptinterpreter.exe` (dependency ID: `"ISI"`). This creates registry keys, sets up game paths,
etc. — essentially the game's own Windows installer. It must run inside Wine on first launch,
before the game itself starts.

### Detection

`GOGManifestUtils.needsScriptInterpreter(installDir)`:
- Reads `{installDir}/_gog_manifest.json`
- Returns `root.optBoolean("scriptInterpreter", false)`

This flag is set during download from `gameManifest.scriptInterpreter` in the build manifest.

### `ISI` Dependency

The script interpreter executable arrives as the `"ISI"` dependency via the dependencies
pipeline (see §8). It is installed to:
```
{installDir}/_CommonRedist/ISI/scriptinterpreter.exe
```

Satisfaction check: `File(gameInstallDir, "_CommonRedist/ISI/scriptinterpreter.exe").exists()`

### `rootdir` Symlink

`ensureScriptInterpreterRootDirSymlink(gameInstallDir)`:
- Creates `{installDir}/_CommonRedist/ISI/rootdir` as a **symlink** pointing to `{installDir}`
- This allows `scriptinterpreter.exe` to reference the game root via a stable Wine path
  (`A:\_CommonRedist\ISI\rootdir`) even though the actual directory is wherever the game is installed

### Launch Command Assembly (`getScriptInterpreterPartsForLaunch`)

For each product in `_gog_manifest.json`, generates a Wine command:
```
A:\_CommonRedist\ISI\scriptinterpreter.exe
  /VERYSILENT
  /DIR=A:\_CommonRedist\ISI\rootdir
  /Language=English
  /LANG=English
  /ProductId={productId}
  /galaxyclient
  /buildId={buildId}
  /versionName={versionName}
  /lang-code={langCode}
  /supportDir=A:\_CommonRedist\ISI\rootdir
  /nodesktopshortcut
```

`lang-code` is normalized: if the stored language is 2 chars (e.g. `"en"`) it becomes `"en-US"`.

These commands are returned as a `List<String>` and joined with `" & "` so multiple products
each run their own setup in sequence within the same Wine session.

### `GogScriptInterpreterDependency` (Launch-time check)

`LaunchDependency` implementation that runs before game launch:
- `appliesTo()`: true if `GameSource.GOG` + container is GLIBC + `needsScriptInterpreter()` is true
- `isSatisfied()`: true if `_CommonRedist/ISI/scriptinterpreter.exe` exists
- `install()`: calls `downloadDependenciesWithProgress(dependencies=["ISI"], ...)` if not present
- Shows loading message: `"Downloading GOG script interpreter"`

### `GogScriptInterpreterStep` (Pre-launch step)

`PreInstallStep` that runs after `LaunchDependency` is satisfied but before the game exe:
- `buildCommand()`: calls `getScriptInterpreterPartsForLaunch(appId)` and joins with `" & "`
- Writes marker `Marker.GOG_SCRIPT_INSTALLED` after running so it only runs once per install

### `GOGDependencyFix` (Per-game dependency injection)

`KeyedGameFix` used to force-download specific dependencies for games that need them but whose
manifest `dependencies[]` array may be incomplete. Constructor takes `dependencyIds: List<String>`.

Satisfaction check per dependency: looks for the sentinel file from
`GOGConstants.GOG_DEPENDENCY_INSTALLED_PATH`:
```kotlin
val pathMap = mapOf(
    "ISI"          to "ISI/scriptinterpreter.exe",
    "MSVC2017"     to "MSVC2017/VC_redist.x86.exe",
    "MSVC2017_x64" to "MSVC2017_x64/VC_redist.x64.exe",
)
// Checked under {installPath}/_CommonRedist/
```

If any dependency is missing, calls `downloadDependenciesWithProgress(...)` at launch time
to fetch and install it on demand.

---

## 14. Uninstall / Delete

File: `GOGManager.deleteGame()`

Steps:
1. Delete manifest file at `{filesDir}/manifests/{gameId}` (if exists)
2. `installDir.deleteRecursively()` — deletes all game files
3. Remove `DOWNLOAD_COMPLETE_MARKER` and `DOWNLOAD_IN_PROGRESS_MARKER` from the install path
4. Update DB: `isInstalled=false`, `installPath=""`
5. `ContainerUtils.deleteContainer(context, libraryItem.appId)` — removes the Wine container
   associated with this game (runs on Main dispatcher)
6. Emit `AndroidEvent.LibraryInstallStatusChanged(gameId)` to trigger UI refresh

The DB record itself is **not deleted** — the game remains in the library as uninstalled,
ready to be downloaded again.

---

## 15. Installation Verification

File: `GOGManager.verifyInstallation(gameId)`

Lightweight check (does not re-read manifests or hash files):
1. Game must be in DB with `isInstalled=true` and non-null `installPath`
2. `File(installPath).exists()` must be true
3. `File(installPath).isDirectory()` must be true
4. `installDir.listFiles()` must be non-null and non-empty

Returns `Pair<Boolean, String?>` — second element is a human-readable error message if false.

`GOGService.isGameInstalled()` calls `verifyInstallation()` and additionally cross-checks with
the DB flag. If verification fails but DB says installed, logs a warning (disk and DB are out
of sync — this happens if files are deleted externally).

**Marker-based approach** (used in `GOGManager.isGameInstalled(context, libraryItem)`):
- `DOWNLOAD_COMPLETE_MARKER` present AND `DOWNLOAD_IN_PROGRESS_MARKER` absent → installed
- Updates DB if the marker state differs from the stored `isInstalled` flag

---

## 16. Game Fixes (Per-Title Overrides)

File: `gamefixes/GOG_*.kt`

GOG games can have per-title launch argument overrides and dependency injections.
The pattern is a `KeyedGameFix` — an interface keyed by `(gameSource, gameId)` that applies
extra configuration at launch time.

### `KeyedLaunchArgFix`

Appends fixed command-line arguments to the game's Wine launch command.

Example — Mars: War Logs (`GOG_1129934535`):
```kotlin
KeyedLaunchArgFix(
    gameSource = GameSource.GOG,
    gameId = "1129934535",
    launchArgs = "-lang=eng",
)
```

All known GOG game fixes in the repo:
| Game ID | Title (approximate) | Fix |
|---|---|---|
| `1129934535` | Mars: War Logs | `-lang=eng` |
| `1141086411` | (unknown) | launch args |
| `1177610018` | (unknown) | launch args |
| `1454315831` | (unknown) | launch args |
| `1454587428` | (unknown) | launch args |
| `1458058109` | (unknown) | launch args |
| `1589319779` | (unknown) | launch args |
| `1635627436` | (unknown) | launch args |
| `1787707874` | (unknown) | launch args |
| `2147483047` | (unknown) | launch args |

### `GOGDependencyFix`

Forces specific runtime dependency download for games that need it.
Applied at launch if the dependency's sentinel file is absent under `_CommonRedist/`.

---

## 17. BannerHub Integration Guide

This section maps what BannerHub already has and what needs to be built, based on everything
above and the current gog-beta branch state.

### What BannerHub Already Has (gog-beta branch)

- `GogMainActivity` — side menu item (ID=10), WebView-based OAuth2 login
- GOG session stored in `bh_gog_prefs` SharedPreferences
- Classes in `smali_classes5` (no DEX overflow)
- Cover art loading fixed (v2.7.0-beta18): JSON escaped slash issue + correct CDN suffix
  `_product_card_v2_mobile_slider_639.jpg`

### Auth — What to Reuse

The existing `GogMainActivity` WebView login can stay as-is. You need to add token exchange
after the redirect is intercepted:

1. Watch for redirect to `embed.gog.com/on_login_success`
2. Extract `?code=` from the URL
3. POST/GET to `https://auth.gog.com/token` with:
   ```
   client_id=46899977096215655
   client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9
   grant_type=authorization_code
   code={extracted_code}
   redirect_uri=https://embed.gog.com/on_login_success?origin=client
   ```
4. Store `access_token`, `refresh_token`, `expires_in`, `loginTime` in `bh_gog_prefs`

Token refresh: check `System.currentTimeMillis()/1000 >= loginTime + expiresIn` before any
API call. If expired, call `grant_type=refresh_token` with the stored `refresh_token`.

### Library Sync — Minimum Steps

1. `GET https://embed.gog.com/user/data/games` → `owned[]` array of game IDs
2. For each ID, `GET https://api.gog.com/products/{id}?expand=downloads,description`
3. Extract: `title`, `images.logo2x`/`images.logo` (prefix `https:` if `//`), `images.icon`,
   `description.lead`, `release_date`, `developers[0].name`, `genres[].name`,
   `downloads.installers[0].total_size`, `is_secret`, `game_type`
4. Skip if `is_secret=true`, `game_type="dlc"`, `total_size=0`, or title is placeholder
5. Store in local DB / SharedPreferences / smali-accessible storage

For BannerHub's smali context: a simple JSON file per game stored in a known directory is
easier than a full Room database. GameNative uses Room but that requires the full Android
architecture library stack.

### Cover Art URL — Correct Format

From GameNative's bug fix (v2.7.0-beta18), the correct image URL construction:

Raw API response `images.logo2x` comes as: `"//images.gog.com/5b2/abc123..."`
- Step 1: Unescape JSON slashes if needed (`\/` → `/`)
- Step 2: Prepend `https:` if starts with `//`
- Result: `https://images.gog.com/5b2/abc123...`

For the card thumbnail specifically, GameNative appends a CDN suffix to get the right size:
```
https://images.gog.com/{path}_product_card_v2_mobile_slider_639.jpg
```

The `logo2x` field from the API is often a bare path without extension. The suffix is what
triggers GOG's image server to return the correctly-sized variant. Without it, you get a blank
or missing image.

Available CDN suffixes (GOG's image server supports these):
- `_product_card_v2_mobile_slider_639.jpg` — card thumbnail (~639px wide)
- `_product_card_v2_mobile_slider_305.jpg` — smaller card
- `_logo2x.png` — full logo (PNG, transparent background)
- `_glx_logo_2x.jpg` — GOG Galaxy logo variant

### Download Pipeline — What to Port

For BannerHub, the full Gen 2 download pipeline is needed. The minimum viable implementation:

**Phase 1 — Get the file list:**
```
1. GET /products/{id}/os/windows/builds?generation=2  →  build.link
2. GET {build.link}                                    →  decompress zlib/gzip  →  manifest JSON
3. For each depot in manifest.depots (language="*" or "en-US"):
     GET gog-cdn-fastly.gog.com/content-system/v2/meta/{AA}/{BB}/{hash}
     →  decompress  →  list of {path, chunks[{compressedMd5, md5, size, compressedSize}]}
```

**Phase 2 — Get CDN access:**
```
4. GET /products/{id}/secure_link?_version=2&generation=2&path=/
   →  construct base CDN URL from url_format + parameters
```

**Phase 3 — Download + assemble:**
```
5. For each chunk:
     GET {baseUrl}/{AA}/{BB}/{compressedMd5}   (User-Agent: GOG Galaxy)
     Verify MD5(response) == compressedMd5
     Cache as {compressedMd5}.chunk
6. For each file:
     Concatenate its chunks in order:
       - Inflate with zlib (java.util.zip.Inflater)
       - Verify MD5(decompressed) == chunk.md5
     Write to {installDir}/{file.path}
```

**Compression detection** (same for manifests and chunks):
```java
byte[] b = ...; // first 2 bytes
boolean isGzip = b[0] == 0x1f && b[1] == (byte)0x8b;
boolean isZlib = b[0] == 0x78 && (b[1] == (byte)0x9c || b[1] == 0x01 || b[1] == (byte)0xda);
// if neither: plain text/JSON
```

### Smali Implementation Notes for BannerHub

Since BannerHub patches smali rather than writing Kotlin source:

1. **HTTP client**: GameHub's obfuscated OkHttp is already available — use the same client
   patterns used elsewhere in the app. Alternatively, `java.net.HttpURLConnection` avoids any
   obfuscation concerns.

2. **JSON parsing**: `org.json.JSONObject` and `JSONArray` are part of the Android framework —
   no extra dependency needed.

3. **Zlib decompression**:
   ```smali
   new-instance v0, Ljava/util/zip/Inflater;
   invoke-direct {v0}, Ljava/util/zip/Inflater;-><init>()V
   invoke-virtual {v0, dataBytes}, Ljava/util/zip/Inflater;->setInput([B)V
   # then loop: inflate into buffer until finished()
   ```
   `java.util.zip.Inflater` is always available on Android.

4. **Gzip decompression**:
   ```smali
   new-instance v0, Ljava/util/zip/GZIPInputStream;
   # wrap ByteArrayInputStream around the bytes
   ```

5. **MD5 verification**:
   ```smali
   invoke-static {v_algo_string}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;
   # "MD5" as string constant
   ```

6. **File I/O**: `java.io.FileOutputStream` for writing chunks and assembled files.
   Create parent dirs with `File.mkdirs()` before writing.

7. **Threading**: Use `AsyncTask` or a `Thread` + `Handler` (simpler for smali than coroutines).
   GameHub's existing download infrastructure (`ComponentDownloadActivity`) already shows this
   pattern with `$3` (download runnable) and `$5` (inject on UI thread via Looper).

8. **Progress**: Reuse the existing `ProgressBar` + status text pattern from
   `ComponentDownloadActivity` — "Downloading: filename" pattern is already proven working.

### DEX Placement

All new GOG download classes should go in `smali_classes16` (the safe overflow DEX):
- `smali_classes9` is at the 65535 limit — do not add
- `smali_classes12` is bypassed entirely — do not add
- `smali_classes16` is used for all new BannerHub additions

### SharedPreferences Key Naming

Follow the existing BannerHub pattern for GOG session data in `bh_gog_prefs`:
```
bh_gog_access_token
bh_gog_refresh_token
bh_gog_user_id
bh_gog_expires_in
bh_gog_login_time
```

### Integration Point with Existing GogMainActivity

The WebView in `GogMainActivity` currently stores the session. The download feature should:
1. Read credentials from `bh_gog_prefs` at download time
2. Refresh the token if `currentTime >= loginTime + expiresIn`
3. Trigger from the GOG game list UI (new Activity or extend `GogMainActivity`)
4. Install games to a predictable path that GameHub can discover — either:
   - The same `files/usr/home/components/` path (if treating GOG game data as a component), or
   - A dedicated `files/usr/home/gog_games/{title}/` directory

### Minimum HTTP Calls for a Working GOG Download

| Call | Purpose |
|---|---|
| `embed.gog.com/user/data/games` | Get owned game IDs |
| `api.gog.com/products/{id}?expand=downloads` | Get title, image, size |
| `content-system.gog.com/products/{id}/os/windows/builds?generation=2` | Get build manifest URL |
| `{build.link}` | Get depot list (zlib/gzip compressed) |
| `gog-cdn-fastly.gog.com/content-system/v2/meta/{AA}/{BB}/{hash}` | Get file+chunk list per depot |
| `content-system.gog.com/products/{id}/secure_link?...` | Get time-limited CDN base URL |
| `{secureBaseUrl}/{AA}/{BB}/{compressedMd5}` | Download each chunk |

That is 6 distinct API call patterns. The secure link and chunk downloads are the most
performance-sensitive. Handle 401/403/404 on chunk downloads by re-calling `secure_link` and
retrying — this is the most common failure mode.
