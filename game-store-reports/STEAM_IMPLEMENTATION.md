# Steam Integration — Implementation Report

**Last updated:** 2026-04-16
**Applies to:** Star Plus (`com.winlator.star`) / Ludashi Plus (`com.winlator.cmod`)
**Source base:** `extension/steam/` (Star Plus) | `app/src/main/java/com/winlator/cmod/store/` (Ludashi Plus)

---

> **Credit:** The Steam integration documented here is based on work from [JoshuaTram/JavaSteam](https://github.com/JoshuaTram/JavaSteam) and pipeline patterns from [GameNative](https://gamenative.app/). Ported to Star Bionic and Ludashi Plus beginning April 2026.

> **Also ported to:** This Steam integration was also ported to [Star Bionic v1.1](https://github.com/jacojayy/star) by the same author.

---

## Table of Contents

1. [File Structure](#1-file-structure)
2. [Dependencies](#2-dependencies)
3. [Data Models](#3-data-models)
4. [SharedPreferences (SteamPrefs)](#4-sharedpreferences-steamprefs)
5. [Event Bus (SteamEvent)](#5-event-bus-steamevent)
6. [Database Schema (SteamDatabase)](#6-database-schema-steamdatabase)
7. [Authentication — Credential Login](#7-authentication--credential-login)
8. [Authentication — QR Login](#8-authentication--qr-login)
9. [Connection Lifecycle (SteamRepository)](#9-connection-lifecycle-steamrepository)
10. [Library Sync — PICS Protocol](#10-library-sync--pics-protocol)
11. [Depot Download Pipeline (SteamDepotDownloader)](#11-depot-download-pipeline-steamdepotdownloader)
12. [Launch Pipeline](#12-launch-pipeline)
13. [Cover Art (SteamGridDB)](#13-cover-art-steamgriddb)
14. [Foreground Service](#14-foreground-service)
15. [UI Screens](#15-ui-screens)
16. [Image URL Patterns](#16-image-url-patterns)
17. [Key Constants](#17-key-constants)
18. [Critical Gotchas](#18-critical-gotchas)

---

## 1. File Structure

```
extension/steam/
├── SteamAuthManager.java          # Credential login (username + password + Steam Guard)
├── SteamQrAuthManager.java        # QR code login (poll for confirmation)
├── SteamRepository.java           # Singleton SteamClient lifecycle, PICS sync, caches
├── SteamDepotDownloader.kt        # JavaSteam DepotDownloader integration, pause/resume
├── SteamDatabase.java             # SQLite v3, 5 tables
├── SteamGame.kt                   # Game data class + derived URL helpers
├── SteamPrefs.kt                  # SharedPreferences wrapper ("steam_prefs")
├── SteamEvent.kt                  # Sealed class event bus
├── SteamForegroundService.kt      # START_STICKY foreground service for CM connection
├── SteamMainActivity.kt           # Entry point, POST_NOTIFICATIONS permission
├── SteamLoginActivity.kt          # Credential login UI + connection wait
├── SteamGamesActivity.kt          # Library list with art loading
├── SteamGameDetailActivity.kt     # Detail + Install/Pause/Resume/Cancel/Launch
└── SteamGridDBApi.java            # Retrofit interface for SteamGridDB cover art
```

---

## 2. Dependencies

| Library | Purpose |
|---|---|
| `in.dragonbra.javasteam` | Steam CM protocol, PICS, DepotDownloader |
| `retrofit2` | SteamGridDB REST API |
| `okhttp3` | HTTP client backing Retrofit |
| `com.google.zxing` | QR code rendering in SteamLoginActivity |

### Critical dependency note

JavaSteam is compiled with **Kotlin 2.2.0** metadata. The base APK ships **Kotlin 1.9.24**. Mixing Kotlin source files that import JavaSteam classes causes a `KotlinReflectionInternalError` / metadata version mismatch at runtime.

**Rule:** All files that directly import `in.dragonbra.javasteam.*` classes **must be written in Java**, not Kotlin. `SteamDepotDownloader.kt` is the sole Kotlin exception because it uses only `DepotDownloader` (a Kotlin class with `@JvmOverloads`) and wraps all JavaSteam access through the `SteamRepository` singleton.

---

## 3. Data Models

### SteamGame.kt

```kotlin
data class SteamGame(
    val appId: Int,
    val name: String,
    val installDir: String,
    val iconHash: String = "",
    val sizeBytes: Long = 0L,
    val depotIds: List<Int> = emptyList(),
    val type: String = "game",          // "game" | "dlc" | "tool" | "demo"
    val isInstalled: Boolean = false,
    val developer: String = "",
    val metacriticScore: Int = 0,
    val genres: String = "",
)
```

Derived URL helpers (no network calls):

```kotlin
val headerUrl = "https://shared.steamstatic.com/store_item_assets/steam/apps/$appId/header.jpg"
val iconUrl   = "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/apps/$appId/$iconHash.jpg"
```

---

## 4. SharedPreferences (SteamPrefs)

File: `SteamPrefs.kt`
Prefs file name: `"steam_prefs"`

| Key | Type | Description |
|---|---|---|
| `username` | String | Steam account username |
| `refresh_token` | String | JavaSteam refresh token; **also used as accessToken** (`getAccessToken()` returns this) |
| `steam_id_64` | String | 64-bit Steam ID |
| `account_id` | String | 32-bit account ID (derived from steam_id_64) |
| `display_name` | String | Steam persona name |
| `cell_id` | Int | Steam cell/region ID for CDN routing |
| `last_pics_change` | Long | PICS change number; used to detect if library sync is needed |

> **Note:** `refresh_token` doubling as `accessToken` is intentional — JavaSteam's access token is derived from the refresh token and the `SteamPrefs.getAccessToken()` method simply returns `pGet("refresh_token", "")`.

---

## 5. Event Bus (SteamEvent)

File: `SteamEvent.kt`
Delivered via `SteamRepository`'s listener interface.

```kotlin
sealed class SteamEvent {
    object Connected : SteamEvent()
    object Disconnected : SteamEvent()
    object LoggedIn : SteamEvent()
    object LoggedOut : SteamEvent()
    data class LoginFailed(val reason: String) : SteamEvent()
    object SteamGuardEmailRequired : SteamEvent()
    object SteamGuardTwoFactorRequired : SteamEvent()
    data class QrChallengeReceived(val url: String) : SteamEvent()
    object QrExpired : SteamEvent()
    data class LibraryProgress(val synced: Int, val total: Int) : SteamEvent()
    object LibrarySynced : SteamEvent()
    data class DownloadProgress(val appId: Int, val bytesDownloaded: Long, val bytesTotal: Long, val speedBps: Long) : SteamEvent()
    data class DownloadComplete(val appId: Int) : SteamEvent()
    data class DownloadFailed(val appId: Int, val error: String) : SteamEvent()
}
```

---

## 6. Database Schema (SteamDatabase)

File: `SteamDatabase.java`
DB version: 3 | DB name: `steam.db`

```sql
CREATE TABLE steam_games (
    app_id          INTEGER PRIMARY KEY,
    name            TEXT,
    install_dir     TEXT,
    icon_hash       TEXT,
    size_bytes      INTEGER DEFAULT 0,
    depot_ids       TEXT,        -- JSON array "[123, 456]"
    type            TEXT,        -- "game" | "dlc" | "tool" | "demo"
    is_installed    INTEGER DEFAULT 0,
    last_updated    INTEGER,     -- Unix epoch ms
    developer       TEXT,
    metacritic_score INTEGER DEFAULT 0,
    genres          TEXT         -- comma-separated names
);

CREATE TABLE steam_licenses (
    package_id      INTEGER PRIMARY KEY,
    time_created    INTEGER,
    flags           INTEGER,
    license_type    INTEGER
);

CREATE TABLE steam_license_apps (
    package_id      INTEGER,
    app_id          INTEGER,
    PRIMARY KEY (package_id, app_id)
);

CREATE TABLE steam_downloads (
    app_id          INTEGER PRIMARY KEY,
    status          TEXT,        -- "queued"|"downloading"|"paused"|"resuming"|"complete"|"failed"
    bytes_downloaded INTEGER DEFAULT 0,
    bytes_total      INTEGER DEFAULT 0,
    install_dir      TEXT,
    error_msg        TEXT,
    added_at         INTEGER
);

CREATE TABLE depot_manifests (
    app_id          INTEGER,
    depot_id        INTEGER,
    manifest_id     INTEGER,
    size_bytes      INTEGER DEFAULT 0,
    PRIMARY KEY (app_id, depot_id)
);
```

---

## 7. Authentication — Credential Login

File: `SteamAuthManager.java`

### Flow

1. `SteamAuthManager.beginLogin(username, password)` — called after CM `Connected` event
2. Calls `SteamAuthentication.beginAuthSessionViaCredentials(steamClient, details)`
3. `AuthSessionDetails` parameters:
   - `username` / `password` from UI
   - `clientOSType = EOSType.AndroidUnknown`
   - `deviceFriendlyName = "Android Device"`
   - `persistentSession = true`
4. `IAuthenticator` callbacks:
   - `getEmailCode()` → returns `CompletableFuture<String>` completed by `submitGuardCode(code)` from UI
   - `getDeviceCode()` → same pattern (TOTP authenticator app code)
   - `acceptDeviceConfirmation()` → returns `CompletableFuture.completedFuture(true)` immediately (mobile confirmation)
5. On success: tokens saved to `SteamPrefs`; `SteamEvent.LoggedIn` fired
6. On failure: `SteamEvent.LoginFailed(reason)` fired with human-readable reason string

### Steam Guard handling

UI receives `SteamGuardEmailRequired` or `SteamGuardTwoFactorRequired` → shows a code entry dialog → calls `SteamAuthManager.submitGuardCode(code)` → completes the pending `CompletableFuture`.

---

## 8. Authentication — QR Login

File: `SteamQrAuthManager.java`

### Flow

1. `SteamQrAuthManager.beginQrLogin()` — called as alternative to credential login
2. Calls `SteamAuthentication.beginAuthSessionViaQR(steamClient, details)`
3. Background thread polls `session.getChallengeUrl()` every **3 seconds**
4. When URL changes (every ~30 seconds), fires `SteamEvent.QrChallengeReceived(newUrl)`
5. UI renders the URL as a QR code using ZXing `BarcodeEncoder`
6. Blocks on `session.pollingWaitForResult().get()` — unblocks when user approves on Steam mobile app
7. On approval: tokens saved to `SteamPrefs`; `SteamEvent.LoggedIn` fired
8. On timeout: `SteamEvent.QrExpired` fired; UI shows "QR code expired, try again"

---

## 9. Connection Lifecycle (SteamRepository)

File: `SteamRepository.java` (797 lines)

### Singleton initialization

```java
SteamRepository repo = SteamRepository.getInstance();
repo.initialize(context);  // sets up callbacks, creates SteamClient
repo.connect();            // starts CM server list fetch + TCP connect
```

### CM configuration

```java
SteamConfiguration config = SteamConfiguration.create(b -> {
    b.withProtocolTypes(EnumSet.of(ProtocolTypes.TCP));  // TCP-only — see §18
    b.withDirectoryFetch(true);                          // CRITICAL — see §18
    b.withCellId(prefs.getCellId());
});
```

### Pump thread

`HandlerThread` named `"SteamPump"` runs:
```java
manager.runWaitCallbacks(500L);  // loop every 500ms
```

### Auto-reconnect

5 attempts with escalating delays: 2s → 4s → 6s → 8s → 10s.
Resets on successful `LoggedOn`.

### Caches (thread-safe)

| Cache | Type | Key | Value |
|---|---|---|---|
| Depot keys | `ConcurrentHashMap<Integer, byte[]>` | depotId | AES-256 key |
| Manifest codes | `ConcurrentHashMap<String, Long>` | `"depotId:manifestId"` | manifest code |
| CDN tokens | `ConcurrentHashMap<String, String>` | cdnHost | auth token |

### Genre ID mapping

Stored in a `HashMap<String, String>` inside `SteamRepository`:

```
"1" → "Action"   "2" → "Strategy"   "3" → "RPG"
"4" → "Casual"   "5" → "Simulation" "6" → "Racing"
"7" → "Sports"   "8" → "Adventure"  "9" → "Indie"
"25" → "Puzzle"  "28" → "Shooter"   ...
```

---

## 10. Library Sync — PICS Protocol

PICS (Product Information and Content System) is Steam's two-phase library data system.

### Phase 1 — syncPackages()

1. `SteamApps.PICSGetAccessTokens(packageIds)` → get access tokens for owned packages
2. `SteamApps.PICSGetProductInfo(apps=[], packages=[...])` → get package metadata (which appIds each package grants)
3. Store all `(packageId, appId)` pairs in `steam_license_apps`

### Phase 2 — syncApps()

1. Collect all unique appIds from `steam_license_apps`
2. `SteamApps.PICSGetProductInfo(apps=[...], packages=[])` in batches of 200
3. For each app: extract `name`, `type`, `developer`, `depots`, `metacritic.score`, `genres`
4. Filter: only type `"game"` shown in `SteamGamesActivity`
5. Store in `steam_games`; fire `LibraryProgress` events during batching
6. Save current PICS change number to `SteamPrefs.last_pics_change`
7. Fire `LibrarySynced` when done

### Change detection

On reconnect/re-login, `SteamApps.PICSGetChangesSince(lastChangeNumber)` checks if `last_pics_change` is current. If up to date, skip full PICS sync.

---

## 11. Depot Download Pipeline (SteamDepotDownloader)

File: `SteamDepotDownloader.kt`

### DepotDownloader configuration

```kotlin
val downloader = DepotDownloader(
    steamClient = steamClient,
    licenses = licenses,            // from SteamRepository
    debug = true,
    androidEmulation = true,        // forces Windows OS filter — see §18
    maxDownloads = threads,         // 4, 8, or 16 (user selectable in detail screen)
    maxDecompress = threads,
    autoStartDownload = false,
)
val item = AppItem(
    appId = appId,
    installDirectory = installDir.absolutePath,
    branch = "public",
    os = "windows",
    downloadAllArchs = true,        // skip arch filter — Wine/Box64 handles x86_64
)
```

### Install path

```
{context.filesDir}/imagefs/steam_games/{sanitizedGameName}/
```

`sanitizedGameName` = game name with characters outside `[A-Za-z0-9_-]` replaced with `_`.

### Progress tracking

`AtomicLong bytesDownloaded` incremented in `onChunkCompleted` callback.
When PICS `size_bytes = 0` (some games), total is back-calculated from manifest depot sizes once they resolve.

### Pause and resume

**Pause:**
```kotlin
downloader.close()
db.markDownloadPaused(appId)
```

**Resume:**
```kotlin
resumeApp(appId)              // calls buildControl(isResume = true)
db.markDownloadResuming(appId)
// DepotDownloader resumes from written file offsets automatically
```

### Debug log

On download failure, the debug log path `{externalFilesDir}/steam_debug.txt` is shown in the UI.

---

## 12. Launch Pipeline

File: `SteamGameDetailActivity.kt`

```java
// 1. Collect candidate executables from install dir
List<File> candidates = AmazonLaunchHelper.collectExe(installDir);

// 2. Score and pick best match
File bestExe = AmazonLaunchHelper.scoreExe(candidates, game.getName());

// 3. Add to launcher (Star-only: writes shortcut entry)
StarLaunchBridge.addToLauncher(
    context,
    game.getName(),
    bestExe.getAbsolutePath(),
    coverArtUrl        // library_600x900.jpg or SteamGridDB URL
);
```

`AmazonLaunchHelper.scoreExe()` is the shared heuristic reused across Amazon, Steam, and any other store. It prefers:
1. EXE name contains the game name (normalized, case-insensitive)
2. EXE is in root of install dir (not a subdirectory)
3. EXE size > 1 MB (filters out launchers/crash reporters)
4. Deprioritizes names matching: `uninstall`, `setup`, `redist`, `vcredist`, `directx`, `dotnet`

---

## 13. Cover Art (SteamGridDB)

File: `SteamGridDBApi.java`

Retrofit interface:

```java
@GET("search/autocomplete/{query}")
Call<JsonObject> searchGame(@Path("query") String query);

@GET("grids/game/{gameId}")
Call<JsonObject> getGridsByGameId(
    @Path("gameId") int gameId,
    @Query("styles") String styles,       // "alternate,blurred,material,no_logo"
    @Query("dimensions") String dimensions, // "600x900"
    @Query("types") String types          // "static"
);
```

Used in `SteamGamesActivity` and `SteamGameDetailActivity` as a fallback when the built-in Steam cover art (`library_600x900.jpg`) returns a 404 or for portrait art display.

Base URL: `https://www.steamgriddb.com/api/v2/`
Auth: `Authorization: Bearer {STEAMGRIDDB_API_KEY}` (stored in app resources, not version-controlled)

---

## 14. Foreground Service

File: `SteamForegroundService.kt`

- Type: `START_STICKY` (auto-restarts if killed by OS)
- Notification channel ID: `"steam_connection_channel"`
- `onStartCommand`: calls `SteamRepository.initialize(this)` then `connect()`
- `onDestroy`: calls `SteamRepository.disconnect()`

The service keeps the CM TCP connection alive across activity lifecycle transitions. Activities bind to `SteamRepository` directly (it's a singleton) rather than binding to the service.

---

## 15. UI Screens

### SteamMainActivity

Entry point. On API 33+, requests `POST_NOTIFICATIONS` permission before proceeding. Navigates to `SteamLoginActivity` if not logged in, otherwise to `SteamGamesActivity`.

### SteamLoginActivity

- Waits for CM `Connected` event with **15-second timeout**
- Reachability states tracked:
  - `NoInternet` — no network connectivity
  - `SteamBlocked` — network available but CM unreachable (firewall/region block)
  - `Reachable` — CM connected successfully
  - `unknown` — initial state
- Shows specific error per state (e.g., "Steam is blocked on this network" vs "No internet connection")
- Two login modes: **Credential** (username + password fields) and **QR** (tap toggle)
- QR mode: renders rotating QR codes via ZXing, refreshes on `QrChallengeReceived`
- Steam Guard: shows inline code input field on `SteamGuardEmailRequired` / `SteamGuardTwoFactorRequired`

### SteamGamesActivity

- Shows only `type = "game"` entries from `steam_games`
- Art: portrait `library_600x900.jpg` (600×900) with `header.jpg` fallback
- Image loading: `LruCache` + `Executor` thread pool (no external image library)
- Auto-syncs library on open if `last_pics_change` is stale (based on CM PICS change number)
- Long-press context menu: Install / Uninstall / Details

### SteamGameDetailActivity

- Header: `library_600x900.jpg` or SteamGridDB art (600×900 portrait)
- Metadata row: developer, metacritic score, genres
- Install button row: **Install / Pause / Resume / Cancel / Launch** (mutually exclusive visibility)
- Thread count picker: `4 / 8 / 16` parallel download streams
- Real-time progress bar + `"X.X MB / X.X GB (X.X MB/s)"` label
- On launch: runs exe scoring → `StarLaunchBridge.addToLauncher()`
- On failure: shows debug log path in a copyable text field

---

## 16. Image URL Patterns

| Art type | URL pattern |
|---|---|
| Header (460×215) | `https://shared.steamstatic.com/store_item_assets/steam/apps/{appId}/header.jpg` |
| Portrait / Library (600×900) | `https://shared.steamstatic.com/store_item_assets/steam/apps/{appId}/library_600x900.jpg` |
| Capsule (231×87) | `https://shared.steamstatic.com/store_item_assets/steam/apps/{appId}/capsule_231x87.jpg` |
| Icon | `https://steamcdn-a.akamaihd.net/steamcommunity/public/images/apps/{appId}/{iconHash}.jpg` |

---

## 17. Key Constants

| Constant | Value | Location |
|---|---|---|
| Prefs file name | `"steam_prefs"` | `SteamPrefs.kt` |
| DB name | `"steam.db"` | `SteamDatabase.java` |
| DB version | `3` | `SteamDatabase.java` |
| Notification channel | `"steam_connection_channel"` | `SteamForegroundService.kt` |
| Max reconnect attempts | `5` | `SteamRepository.java` |
| Reconnect delays (ms) | `2000, 4000, 6000, 8000, 10000` | `SteamRepository.java` |
| Login timeout (ms) | `15000` | `SteamLoginActivity.kt` |
| QR poll interval (ms) | `3000` | `SteamQrAuthManager.java` |
| Pump interval (ms) | `500` | `SteamRepository.java` |
| PICS batch size | `200` | `SteamRepository.java` |
| Install base path | `{filesDir}/imagefs/steam_games/` | `SteamDepotDownloader.kt` |
| Debug log | `{externalFilesDir}/steam_debug.txt` | `SteamDepotDownloader.kt` |

---

## 18. Critical Gotchas

### 1. TCP-only protocol — no WebSocket

```java
b.withProtocolTypes(EnumSet.of(ProtocolTypes.TCP));
```

The Ktor CIO HTTP client (required for WebSocket) is **not bundled** in the base APK. Using `ProtocolTypes.WEBSOCKET` (the JavaSteam default) will throw a `ClassNotFoundException` at runtime. Always force TCP.

### 2. withDirectoryFetch(true) is mandatory

```java
b.withDirectoryFetch(true);
```

Without this flag, the CM server list API returns `null` and `connect()` fires `Disconnected` immediately. This is not documented in JavaSteam's README.

### 3. Kotlin 2.2.0 metadata incompatibility

JavaSteam is compiled with Kotlin 2.2.0. The base APK ships Kotlin 1.9.24. Any `.kt` file that directly imports `in.dragonbra.javasteam.*` classes will crash at runtime with a `KotlinReflectionInternalError`. **Write all JavaSteam-touching files in Java.**

### 4. androidEmulation = true is required

```kotlin
androidEmulation = true,
```

This flag instructs DepotDownloader to apply the Windows OS filter when selecting depots. Without it, the downloader may select Linux-only depots that do not run under Wine.

### 5. downloadAllArchs = true

```kotlin
downloadAllArchs = true,
```

Prevents the arch filter from skipping `x86_64` depots. Since Wine + Box64 translates x86_64 instructions, we always want the x86_64 Windows build.

### 6. refreshToken doubles as accessToken

`SteamPrefs.getAccessToken()` returns the value stored under key `"refresh_token"`. This is not a bug — JavaSteam's access token is derived from the refresh token and the distinction is not meaningful for the use cases in this app.

### 7. PICS size_bytes may be 0

Some games report `size_bytes = 0` in their depot manifest entries. In this case, `SteamDepotDownloader` back-calculates the total size once all manifest depot sizes resolve from the DepotDownloader callbacks.

### 8. Game library only shows type="game"

`SteamGamesActivity` filters `WHERE type = 'game'`. Tools, demos, DLC, and soundtracks are stored in the DB but not displayed. This is intentional — tools and DLC cannot be launched independently.
