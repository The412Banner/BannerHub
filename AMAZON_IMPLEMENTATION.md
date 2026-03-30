# Amazon Games Integration Report — GameNative (utkarshdalal/GameNative)
> Source: https://github.com/utkarshdalal/GameNative
> Updated: 2026-03-29 (v5 — COMPLETE: AmazonDownloadManager.kt + AmazonService.kt + AmazonOAuthActivity.kt verbatim; exact download loop, cancellation flow, SHA-256 verify, hashHex encoding note, exact OAuth redirect URL, stopLoading detail)
> Purpose: BannerHub smali integration reference

---

## 1. Status

Amazon Games support is **fully implemented**. Introduced in PR #557 ("Feat/amazon games support"), authored by `xXJSONDeruloXx`, merged by `utkarshdalal` on **2026-02-24**. Lives on branch `feat/amazon-games-support-utkarsh`. Feature labeled **Alpha** in UI. Protocol source: [Nile](https://github.com/imLinguin/nile) open-source client.

### Post-merge commits touching Amazon (chronological)
| SHA | Date | Description |
|---|---|---|
| `12e95f963f0c` | 2026-02-24 | Fix download remaining time calculation; fix custom exe setting for Amazon; fix launching exes for GOG + Epic. Files: `DownloadInfo.kt`, `AmazonDownloadManager.kt`, `EpicManager.kt`, `GOGManager.kt`, `XServerScreen.kt` |
| `2dc7638295d5` | 2026-03-18 | Apply known config on launch for GOG/Epic/Amazon. Files: `BaseAppScreen.kt`, `ContainerUtils.kt` |
| `957ba760ce1a` | 2026-03-24 | Install missing Wine components from known config for all stores (not just Steam). Files: `PluviaMain.kt`, `BaseAppScreen.kt`, `ContainerUtils.kt` |
| `fe682992dafd` | 2026-03-24 | Fix: defer intent launches until GOG/Epic/Amazon service is ready (PR #987). Files: `AndroidEvent.kt`, `AmazonService.kt`, `PluviaMain.kt`, `MainViewModel.kt` |
| `193c451cbf1f` | 2026-03-25 | Fix: restore inbound moves and Amazon download details. Files: `DownloadsViewModel.kt`, `ContainerStorageManagerDialog.kt`, `ContainerStorageManager.kt` |

### Open PR
- **PR #1021 (open)** — "Nicer amazon images": adds `pgCrownImageUrl` from `productJson`; new `AmazonArtwork` helper class; DB schema v16.

---

## 2. File Inventory

### Package: `app.gamenative.service.amazon`

| File | Role |
|---|---|
| `AmazonConstants.kt` | All constants: device type, marketplace ID, app name/version, API URLs, user agents, key IDs |
| `AmazonAuthClient.kt` | Raw HTTP: device registration, token refresh, device deregistration |
| `AmazonAuthManager.kt` | Credential persistence (`amazon/credentials.json`), token refresh logic, PKCE state |
| `AmazonApiClient.kt` | Library sync (GetEntitlements), download spec (GetGameDownload), version check (GetLiveVersionIds), download size, SDK download |
| `AmazonDownloadManager.kt` | Parallel file download (by SHA-256 hash), SHA-256 verify, XZ/LZMA decompression, resume support |
| `AmazonManager.kt` | Library refresh, game DB ops, bearer token helpers |
| `AmazonManifest.kt` | Custom protobuf manifest parser — packages, files, sizes, hashes |
| `AmazonPKCEGenerator.kt` | PKCE: device serial, client ID, code verifier, code challenge |
| `AmazonSdkManager.kt` | Amazon SDK DLL deployment to Wine prefix |
| `AmazonService.kt` | Android foreground Service coordinating all above |

### Data / DB

| File | Role |
|---|---|
| `data/AmazonGame.kt` | Room entity `amazon_games` table + `AmazonCredentials` data class |
| `db/dao/AmazonGameDao.kt` | All DB queries, upsertPreservingInstallStatus |
| DB version | 12 → 13 via `AutoMigration(from=12, to=13)` |

### UI

| File | Role |
|---|---|
| `ui/screen/auth/AmazonOAuthActivity.kt` | WebView OAuth, PKCE code capture, intent result |
| `ui/screen/library/appscreen/AmazonAppScreen.kt` | Platform screen — download, install, verify, uninstall, pause/resume |
| `ui/component/dialog/AmazonInstallDialog.kt` | Full-screen confirmation dialog: download size, install size, available space |

### Modified shared files

- `XServerScreen.kt` — fuel.json parsing → exe heuristic; FuelPump env vars; SDK deploy; launch command
- `ContainerUtils.kt` — `AMAZON_<appId>` container ID; A: drive mapping
- `ContainerStorageManager.kt` — loads installed Amazon games from DAO; move/uninstall via `AmazonService`
- `ExecutableSelectionUtils.kt` — scoring heuristic for exe selection (shared with Epic/GOG)
- `LibraryItem.kt` — `GameSource.AMAZON` enum case
- `PluviaMain.kt` — Amazon pre-launch routing (skips cloud sync); deferred intent launch fix
- `PrefManager.kt` — `show_amazon_in_library`, `amazon_installed_games_count`

### Tests
- `test/java/.../amazon/AmazonManifestTest.kt` — unit tests for protobuf manifest parser

---

## 3. Auth Flow

### Protocol
OAuth 2.0 with **PKCE** (Proof Key for Code Exchange). Amazon login loaded in WebView. **No client secret.**

### Key constants (`AmazonConstants.kt`)
```
DEVICE_TYPE          = "A2UMVHOX7UP4V7"
MARKETPLACE_ID       = "ATVPDKIKX0DER"
APP_NAME             = "AGSLauncher for Windows"
APP_VERSION          = "1.0.0"
OS_VERSION           = "10.0.19044.0"
OA2_SCOPE            = "device_auth_access"
OPENID_ASSOC_HANDLE  = "amzn_sonic_games_launcher"
USER_AGENT           = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"
GAMING_USER_AGENT    = "com.amazon.agslauncher.win/3.0.9202.1"
DOWNLOAD_USER_AGENT  = "nile/0.1 Amazon"
GAMING_KEY_ID        = "d5dc8b8b-86c8-4fc4-ae93-18c0def5314d"
LAUNCHER_CHANNEL_ID  = "87d38116-4cbf-4af0-a371-a5b498975346"
```

### PKCE Generation (`AmazonPKCEGenerator.kt`)
```kotlin
generateDeviceSerial(): String
  → UUID.randomUUID().toString().replace("-","").uppercase()
  → one-time per install, stored in credentials.json

generateClientId(serial): String
  → hex-encode UTF-8 bytes of "$serial#$DEVICE_TYPE"

generateCodeVerifier(): String
  → 32 SecureRandom bytes, Base64 URL_SAFE|NO_PADDING|NO_WRAP

generateCodeChallenge(verifier): String
  → SHA-256(verifier.toByteArray()), same Base64 encoding (S256)
```

### Auth URL (`AmazonConstants.buildAuthUrl`)
```
https://www.amazon.com/ap/signin
  ?openid.ns=http://specs.openid.net/auth/2.0
  &openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select
  &openid.identity=http://specs.openid.net/auth/2.0/identifier_select
  &openid.mode=checkid_setup
  &openid.oa2.scope=device_auth_access
  &openid.ns.oa2=http://www.amazon.com/ap/ext/oauth/2
  &openid.oa2.response_type=code
  &openid.oa2.code_challenge_method=S256
  &openid.oa2.client_id=device:{hex_clientId}
  &language=en_US
  &marketPlaceId=ATVPDKIKX0DER
  &openid.return_to=https://www.amazon.com
  &openid.pape.max_auth_age=0
  &openid.ns.pape=http://specs.openid.net/extensions/pape/1.0
  &openid.assoc_handle=amzn_sonic_games_launcher
  &pageId=amzn_sonic_games_launcher
  &openid.oa2.code_challenge={S256_challenge}
```

### WebView Code Capture (`AmazonOAuthActivity.kt` — exact)
```
Redirect URL format:
  https://www.amazon.com/?openid.assoc_handle=amzn_sonic_games_launcher&openid.oa2.authorization_code=...

isAmazonRedirect(url):
  (url.startsWith("https://www.amazon.com/") || url.startsWith("https://amazon.com/"))
  && url.contains("openid.assoc_handle=amzn_sonic_games_launcher")

extractAuthCode(url):
  Uri.parse(url).getQueryParameter("openid.oa2.authorization_code")
```
- Overrides ALL THREE: `shouldOverrideUrlLoading(WebView, WebResourceRequest)`, legacy `shouldOverrideUrlLoading(WebView, String)`, AND `onPageStarted`
- `AtomicBoolean codeCaptured` → `compareAndSet(false, true)` prevents double-fire
- In `onPageStarted` after capture: calls `view?.stopLoading()` to stop amazon.com loading
- On capture: `setResult(RESULT_OK, Intent().putExtra(EXTRA_AUTH_CODE, code))` + `finish()`
- On dismiss: `setResult(RESULT_CANCELED)` + `finish()`
- `AmazonAuthManager.startAuthFlow()` called in `onCreate()` — generates PKCE state before WebView loads

### Device Registration (`AmazonAuthClient.registerDevice`)
```
POST https://api.amazon.com/auth/register
Headers:
  User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0
  Content-Type: application/json
  Accept: application/json
Body:
{
  "auth_data": {
    "authorization_code": "{code}",
    "client_domain": "DeviceLegacy",
    "client_id": "{hex_clientId}",
    "code_algorithm": "SHA-256",
    "code_verifier": "{verifier}",
    "use_global_authentication": false
  },
  "registration_data": {
    "app_name": "AGSLauncher for Windows",
    "app_version": "1.0.0",
    "device_model": "Windows",
    "device_name": null,
    "device_serial": "{serial}",
    "device_type": "A2UMVHOX7UP4V7",
    "domain": "Device",
    "os_version": "10.0.19044.0"
  },
  "requested_extensions": ["customer_info", "device_info"],
  "requested_token_type": ["bearer", "mac_dms"],
  "user_context_map": {}
}
Response path: json.response.success.tokens.bearer → {access_token, refresh_token, expires_in}
```

### Token Refresh (`AmazonAuthClient.refreshAccessToken`)
```
POST https://api.amazon.com/auth/token
Headers:
  x-amzn-identity-auth-domain: api.amazon.com
Body:
{
  "source_token": "{refresh_token}",
  "source_token_type": "refresh_token",
  "requested_token_type": "access_token",
  "app_name": "AGSLauncher for Windows",
  "app_version": "1.0.0"
}
Response: flat JSON → {access_token, expires_in, token_type}
```
Auto-refresh triggered **5 minutes before expiry** in `AmazonAuthManager.getStoredCredentials()`.

### Logout (`AmazonAuthClient.deregisterDevice`)
```
POST https://api.amazon.com/auth/deregister
Authorization: Bearer {access_token}
Body: {"requested_extensions": ["device_info", "customer_info"]}
```
**Non-fatal** — always returns `Result.success(Unit)` even on failure. Local credentials cleared regardless. Also passes `deviceSerial` and `clientId` as parameters (not in body).

### Refresh token behavior
The refresh token is **NOT returned** in the refresh response. The old refresh token is reused unchanged. Only `access_token` and `expires_in` come back from the refresh endpoint.

### Credential Storage
File: `context.filesDir/amazon/credentials.json` (plain JSON)
```json
{
  "access_token": "...",
  "refresh_token": "...",
  "device_serial": "...",
  "client_id": "...",
  "expires_at": 1234567890000
}
```
Three `@Volatile` PKCE in-flight fields (`pendingCodeVerifier`, `pendingDeviceSerial`, `pendingClientId`) — cleared after auth/logout.

---

## 4. API Endpoints

### Auth

| Method | URL | Purpose |
|---|---|---|
| POST | `https://api.amazon.com/auth/register` | Device registration (PKCE exchange) |
| POST | `https://api.amazon.com/auth/token` | Token refresh |
| POST | `https://api.amazon.com/auth/deregister` | Logout |

### Gaming Distribution

| Method | URL | X-Amz-Target | Purpose |
|---|---|---|---|
| POST | `https://gaming.amazon.com/api/distribution/entitlements` | `...AnimusEntitlementsService.GetEntitlements` | Fetch owned games |
| POST | `https://gaming.amazon.com/api/distribution/v2/public` | `...AnimusDistributionService.GetGameDownload` | Get download spec |
| POST | `https://gaming.amazon.com/api/distribution/v2/public` | `...AnimusDistributionService.GetLiveVersionIds` | Check for updates |
| GET | `https://gaming.amazon.com/api/distribution/v2/public/download/channel/{LAUNCHER_CHANNEL_ID}` | — | SDK download spec |

### Common gaming request headers
```
X-Amz-Target:       <operation>
x-amzn-token:       <accessToken>
User-Agent:         com.amazon.agslauncher.win/3.0.9202.1
Content-Type:       application/json
Content-Encoding:   amz-1.0          ← REQUIRED on all distribution API calls
```

---

## 5. Library Sync

### Flow
`AmazonService.syncLibrary()` → `AmazonManager.refreshLibrary()` → `AmazonApiClient.getEntitlements(bearerToken, deviceSerial)` → `AmazonGameDao.upsertPreservingInstallStatus(games)`

### Throttle
15-minute cooldown. `ACTION_MANUAL_SYNC` bypasses.

### GetEntitlements request
```json
{
  "Operation": "GetEntitlements",
  "clientId": "Sonic",
  "syncPoint": null,
  "nextToken": null,
  "maxResults": 50,
  "productIdFilter": null,
  "keyId": "d5dc8b8b-86c8-4fc4-ae93-18c0def5314d",
  "hardwareHash": "{SHA-256-UPPERCASE of deviceSerial}"
}
```
`hardwareHash` = `sha256Upper(deviceSerial)` = `MessageDigest("SHA-256").digest(serial.toByteArray(UTF_8)).joinToString("") { "%02x".format(it) }.uppercase()`

Paginated: loops while `nextToken` present. Deduplicates by `productId` (Map keyed by productId).

### Field mapping

| AmazonGame field | JSON path |
|---|---|
| `productId` | `product.id` |
| `entitlementId` | top-level `id` |
| `title` | `product.title` |
| `artUrl` | `product.productDetail.iconUrl` (fallback: `details.logoUrl`) |
| `heroUrl` | `product.productDetail.details.backgroundUrl1` (fallback: `backgroundUrl2`) |
| `developer` | `product.productDetail.details.developer` |
| `publisher` | `product.productDetail.details.publisher` |
| `productSku` | `product.sku` |

### Upsert behavior
New API data wins for most fields. Preserved from DB: `appId`, `isInstalled`, `installPath`, `installSize`, `versionId`, `lastPlayed`, `playTimeMinutes`. `productSku` preserved if new API value is empty.

---

## 6. Database Entity (`AmazonGame`)

Table: `amazon_games`, DB version 12 → 13.

```sql
CREATE TABLE amazon_games (
  app_id            INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  product_id        TEXT NOT NULL,          -- "amzn1.adg.product.XXXX"
  entitlement_id    TEXT NOT NULL DEFAULT '',-- UUID for GetGameDownload
  title             TEXT NOT NULL,
  is_installed      INTEGER NOT NULL,
  install_path      TEXT NOT NULL,
  art_url           TEXT NOT NULL,
  hero_url          TEXT NOT NULL DEFAULT '',
  purchased_date    TEXT NOT NULL,
  developer         TEXT NOT NULL DEFAULT '',
  publisher         TEXT NOT NULL DEFAULT '',
  release_date      TEXT NOT NULL DEFAULT '',
  download_size     INTEGER NOT NULL DEFAULT 0,
  install_size      INTEGER NOT NULL DEFAULT 0,
  version_id        TEXT NOT NULL DEFAULT '', -- from GetGameDownload, for update checks
  product_sku       TEXT NOT NULL DEFAULT '', -- FuelPump env var
  last_played       INTEGER NOT NULL DEFAULT 0,
  play_time_minutes INTEGER NOT NULL DEFAULT 0,
  product_json      TEXT NOT NULL
);
CREATE INDEX index_amazon_games_product_id ON amazon_games (product_id);
```

---

## 7. Download Pipeline (`AmazonDownloadManager.kt`)

### Configuration
```
MAX_PARALLEL_DOWNLOADS = 6
MAX_RETRIES = 3
RETRY_DELAY_MS = 1000L  (exponential: 1s → 2s → 4s)
PROGRESS_EMIT_INTERVAL = 512 * 1024L  (512 KB)
connectTimeout = 30s, readTimeout = 120s
connectionPool(16, 5, TimeUnit.MINUTES)
```

### Stages (exact from `AmazonDownloadManager.kt`)
1. Validate `game.entitlementId` non-blank; get `bearerToken` from `amazonManager.getBearerToken()`
2. POST `GetGameDownload` body: `{"entitlementId": "{UUID}", "Operation": "GetGameDownload"}` → `GameDownloadSpec(downloadUrl, versionId)`
   - **Uses `entitlementId` (top-level UUID from GetEntitlements), NOT `productId`**
3. GET `appendPath(downloadUrl, "manifest.proto")` → `manifestBytes`
4. `AmazonManifest.parse(manifestBytes)` → `ParsedManifest`
5. `downloadInfo.setTotalExpectedBytes(manifest.totalInstallSize)`
6. Loop `files.chunked(6)` — each batch: `batch.map { async { downloadFileWithRetry(...) } }.awaitAll()`; first failure aborts entire download
7. Per file — `downloadFileWithRetry` (3 attempts, backoff 1s/2s/4s):
   - Resume check: if `destFile.exists() && destFile.length() == file.size` → skip, count bytes with `trackSpeed=false`
   - `hashHex = file.hashBytes.joinToString("") { "%02x".format(it) }` ← **NOTE: AmazonSdkManager uses `it.toInt() and 0xFF`; for BannerHub use `and 0xFF` to be safe for bytes > 127**
   - URL: `appendPath(baseUrl, "files/$hashHex")`; header `User-Agent: nile/0.1 Amazon`
   - Write to `{unixPath}.tmp`; progress emit every 512KB; cancellation check in read loop
   - SHA-256 verify (`hashAlgorithm == 0`): compute digest of `tmpFile`, `computed.contentEquals(file.hashBytes)` — delete tmp + fail on mismatch
   - On success: delete existing destFile, rename tmp → destFile
   - On `CancellationException`: delete tmp, rethrow
8. Cache manifest: `context.filesDir/manifests/amazon/{productId}.proto`
9. `amazonManager.markInstalled(productId, installPath, manifest.totalInstallSize, spec.versionId)`
10. Remove `DOWNLOAD_IN_PROGRESS_MARKER`, add `DOWNLOAD_COMPLETE_MARKER`; set progress=1.0

### Cancellation flow
- Batch loop checks `downloadInfo.isActive()` before each batch
- Read loop checks `downloadInfo.isActive()` inside byte copy
- On cancel: remove `IN_PROGRESS` marker, call `persistProgressSnapshot()` (for resume), throw `CancellationException`
- On resume: `hasPartialDownloadByAppId()` detects `IN_PROGRESS` marker; `performDownload()` skips dialog, resumes from per-file size check

### File URL construction (`AmazonApiClient.appendPath`)
```kotlin
// Simple string split at '?' — NOT Uri.Builder
// input:  "https://cdn.example.com/v1/data?token=abc&sig=xyz"
// call:   appendPath(url, "files/abcd1234")
// output: "https://cdn.example.com/v1/data/files/abcd1234?token=abc&sig=xyz"
internal fun appendPath(baseUrl: String, segment: String): String {
    val qIdx = baseUrl.indexOf('?')
    return if (qIdx == -1) {
        "$baseUrl/$segment"
    } else {
        val path = baseUrl.substring(0, qIdx)
        val query = baseUrl.substring(qIdx)
        "$path/$segment$query"
    }
}
```
Used for both `manifest.proto` and `files/{hashHex}` appended to the CDN base URL.

### Markers
- `DOWNLOAD_IN_PROGRESS_MARKER` — set at start
- `DOWNLOAD_COMPLETE_MARKER` — set on success

### Path traversal protection
All file paths validated against canonical install dir — paths escaping throw `SecurityException`.

---

## 8. Manifest Format (`AmazonManifest.kt`)

Binary format: **4-byte big-endian uint32 = headerSize** → header bytes → body bytes.

### Data classes
```kotlin
data class ManifestFile(val path: String, val size: Long, val hashAlgorithm: Int, val hashBytes: ByteArray) {
    val unixPath: String get() = path.replace('\\', '/')  // converts Windows backslash paths
}
data class ManifestPackage(val name: String, val files: List<ManifestFile>)
data class ParsedManifest(val packages: List<ManifestPackage>) {
    val allFiles: List<ManifestFile>
    val totalInstallSize: Long
}
```

### Protobuf field numbers
```
ManifestHeader:       field 1 = CompressionSettings
CompressionSettings:  field 1 = algorithm (0=none, 1=LZMA)
Manifest:             field 1 = repeated Package
Package:              field 1 = name, field 2 = repeated File, field 3 = repeated Dir (ignored)
File:                 field 1 = path (Windows backslash), field 2 = mode, field 3 = size (int64),
                      field 4 = created, field 5 = Hash, field 6 = hidden, field 7 = system
Hash:                 field 1 = algorithm (0=sha256, 1=shake128), field 2 = value bytes
```

### Decompression
- First two bytes `0xFD 0x37` → `XZInputStream(input, -1)`
- Otherwise → raw `LZMAInputStream`
- Uses `org.tukaani.xz` (built into GameHub, not obfuscated)

---

## 9. Update Checking — GetLiveVersionIds

```
POST https://gaming.amazon.com/api/distribution/v2/public
X-Amz-Target: com.amazon.animusdistributionservice.external.AnimusDistributionService.GetLiveVersionIds
Body:
{
  "adgProductIds": ["amzn1.adg.product.XXXX", ...],
  "Operation": "GetLiveVersionIds"
}
Response: { "adgProductIdToVersionIdMap": { "productId": "versionId" } }
```

---

## 10. Game Launch Pipeline — XServerScreen.kt (exact code)

### Storage paths (`AmazonConstants.kt`)
```kotlin
// defaultAmazonGamesPath(context):
//   External (if PrefManager.useExternalStorage && path exists):
//     PrefManager.externalStoragePath/Amazon/games/
//   Internal fallback:
//     context.filesDir/Amazon/

// getGameInstallPath(context, gameTitle):
//   sanitized = gameTitle.replace(Regex("[^a-zA-Z0-9 \\-_]"), "").trim()
//   dirName   = sanitized.ifEmpty { "game_${gameTitle.hashCode().toUInt()}" }
//   return    Paths.get(defaultAmazonGamesPath(context), dirName).toString()
```

### Container setup
- Container ID: `AMAZON_<appId>` (Room auto-increment int)
- Drive: game install dir → `A:` in Wine

### Full launch code (from XServerScreen.kt, Amazon branch)
```kotlin
} else if (gameSource == GameSource.AMAZON) {
    val appIdInt = runCatching { ContainerUtils.extractGameIdFromContainerId(appId) }.getOrNull()
    val productId = if (appIdInt != null)
        AmazonService.getProductIdByAppId(appIdInt) else null
    val installPath = if (appIdInt != null)
        AmazonService.getInstallPathByAppId(appIdInt) else null

    if (installPath.isNullOrEmpty()) {
        return "\"explorer.exe\""   // ← fallback if not installed
    }

    // ── Try fuel.json first ───────────────────────────────────────────
    val fuelFile = File(installPath, "fuel.json")
    var fuelCommand: String? = null
    var fuelArgs: List<String> = emptyList()
    var fuelWorkingDir: String? = null

    if (fuelFile.exists()) {
        try {
            val json = org.json.JSONObject(fuelFile.readText())
            val main = json.optJSONObject("Main")
            if (main != null) {
                fuelCommand = main.optString("Command", "").takeIf { it.isNotEmpty() }
                fuelWorkingDir = main.optString("WorkingSubdirOverride", "").takeIf { it.isNotEmpty() }
                val argsArray = main.optJSONArray("Args")
                if (argsArray != null) {
                    fuelArgs = (0 until argsArray.length()).mapNotNull { argsArray.optString(it) }
                }
            }
        } catch (e: Exception) {
            // Failed to parse fuel.json → fall through to heuristic
        }
    }

    // ── Resolve exe path (cached in container.executablePath) ────────
    var resolvedRelativePath = container.executablePath
    if (resolvedRelativePath.isEmpty()) {
        resolvedRelativePath = if (fuelCommand != null) {
            fuelCommand.replace("\\", "/")
        } else {
            val exeFile = ExecutableSelectionUtils.choosePrimaryExeFromDisk(
                installDir = File(installPath),
                gameName = File(installPath).name,
            )
            exeFile.relativeTo(File(installPath)).path
        }
        container.executablePath = resolvedRelativePath   // ← cached for subsequent launches
        container.saveData()
    }

    // ── Build A: drive Wine path ──────────────────────────────────────
    val winPath = resolvedRelativePath.replace("/", "\\")
    val amazonCommand = "A:\\$winPath"

    // ── Working directory ─────────────────────────────────────────────
    val workDir = if (fuelCommand != null && fuelWorkingDir != null &&
            resolvedRelativePath.replace("\\","/") == fuelCommand.replace("\\","/")) {
        installPath + "/" + fuelWorkingDir.replace("\\", "/")
    } else {
        val exeDir = resolvedRelativePath.substringBeforeLast("/", "")
        if (exeDir.isNotEmpty()) installPath + "/" + exeDir else installPath
    }
    guestProgramLauncherComponent.workingDir = File(workDir)

    // ── FuelPump environment variables ────────────────────────────────
    val configPath = "C:\\ProgramData"
    envVars.put("FUEL_DIR", "$configPath\\Amazon Games Services\\Legacy")
    envVars.put("AMAZON_GAMES_SDK_PATH", "$configPath\\Amazon Games Services\\AmazonGamesSDK")
    envVars.put("AMAZON_GAMES_FUEL_ENTITLEMENT_ID", amazonGame.entitlementId)
    envVars.put("AMAZON_GAMES_FUEL_PRODUCT_SKU", amazonGame.productSku)
    envVars.put("AMAZON_GAMES_FUEL_DISPLAY_NAME", "Player")  // Amazon doesn't expose username

    // ── SDK DLL deploy (idempotent) ───────────────────────────────────
    val prefixProgramData = File(container.getRootDir(), ".wine/drive_c/ProgramData")
    File(prefixProgramData, "Amazon Games Services/Legacy").mkdirs()
    File(prefixProgramData, "Amazon Games Services/AmazonGamesSDK").mkdirs()
    val cached = AmazonSdkManager.ensureSdkFiles(context, sdkToken)
    if (cached) {
        AmazonSdkManager.deploySdkToPrefix(context, prefixProgramData)
    }

    // ── Final launch command ──────────────────────────────────────────
    val launchCommand = if (fuelArgs.isNotEmpty()) {
        val argsStr = fuelArgs.joinToString(" ") { arg ->
            if (arg.contains(" ")) "\"$arg\"" else arg
        }
        "winhandler.exe \"$amazonCommand\" $argsStr"
    } else {
        "winhandler.exe \"$amazonCommand\""
    }
    return launchCommand
}
```

### Pre-launch cloud sync bypass (`PluviaMain.kt`)
```kotlin
val isAmazonGame = gameSource == GameSource.AMAZON
if (isAmazonGame) {
    setLoadingDialogVisible(false)
    onSuccess(context, appId)
    return@launch   // skip Steam cloud sync gate entirely
}
```

### Known-config application
Commit `2dc7638295d5` (2026-03-18): Amazon games now have `supportsKnownConfigAutoApply = true` in `ContainerUtils.kt` — Wine config presets applied on launch automatically, same as Steam.

Commit `957ba760ce1a` (2026-03-24): Missing Wine components (from known config) are auto-installed for Amazon/GOG/Epic, not just Steam.

---

## 11. ExecutableSelectionUtils.kt — Full Scoring Algorithm

```kotlin
object ExecutableSelectionUtils {

    // Regexes
    private val ueShipping = Regex(".*-win(32|64)(-shipping)?\\.exe$", RegexOption.IGNORE_CASE)
    private val ueBinaries = Regex(".*/binaries/win(32|64)/.*\\.exe$", RegexOption.IGNORE_CASE)
    private val genericName = Regex("^[a-z]\\d{1,3}\\.exe$", RegexOption.IGNORE_CASE)

    // Negative keyword list (exact strings, checked via `in` on lowercased path)
    private val negativeKeywords = listOf(
        "crash", "handler", "viewer", "compiler", "tool",
        "setup", "unins", "eac", "launcher", "steam",
    )

    // Fuzzy name match — first 5 alphanumeric chars
    private fun fuzzyMatch(a: String, b: String): Boolean {
        val cleanA = a.replace(Regex("[^a-z]"), "")
        val cleanB = b.replace(Regex("[^a-z]"), "")
        return cleanA.take(5) == cleanB.take(5)
    }

    // Stub detection — excluded from pool first; fallback to full pool if all are stubs
    private fun File.isLikelyStubExe(): Boolean {
        val n = name.lowercase()
        return genericName.matches(name)
            || negativeKeywords.any { it in n }
            || length() < 1_000_000L   // < 1 MB
    }

    private fun scoreExeOnDisk(file: File, gameName: String): Int {
        var score = 0
        val path = file.path.replace('\\', '/').lowercase()
        if (ueShipping.matches(path)) score += 300          // UE shipping binary
        if (ueBinaries.containsMatchIn(path)) score += 250  // UE Binaries/ dir
        if (!path.contains('/')) score += 200               // Root-level exe
        if (path.contains(gameName) || fuzzyMatch(path, gameName)) score += 100  // Name match
        if (negativeKeywords.any { it in path }) score -= 150  // Negative keyword
        if (genericName.matches(file.name)) score -= 200    // Generic single-char name
        score += 50  // Base score
        return score
    }

    fun choosePrimaryExeFromDisk(installDir: File, gameName: String = installDir.name): File? {
        if (!installDir.exists() || !installDir.isDirectory) return null
        val allExe = installDir.walk()
            .filter { it.isFile && it.extension.equals("exe", ignoreCase = true) }
            .toList()
        if (allExe.isEmpty()) return null
        val pool = allExe.filterNot { it.isLikelyStubExe() }.ifEmpty { allExe }
        val normalizedGameName = gameName.lowercase()
        return pool.maxWithOrNull { a, b ->
            val sa = scoreExeOnDisk(a, normalizedGameName)
            val sb = scoreExeOnDisk(b, normalizedGameName)
            when {
                sa != sb -> sa - sb
                else -> (a.length() - b.length()).toInt()   // tiebreak: larger file wins
            }
        }
    }
}
```

**Score summary:**

| Signal | Score |
|---|---|
| UE shipping binary (`-Win32/64-Shipping.exe`) | +300 |
| UE Binaries/ path | +250 |
| Root-level exe (no `/`) | +200 |
| Name matches game folder (exact or fuzzy 5-char) | +100 |
| Base | +50 |
| Negative keyword in path | -150 |
| Generic name (`[a-z][0-9]{1,3}.exe`) | -200 |
| Stub filter (< 1 MB OR negative keyword OR generic) | excluded from pool |
| Tiebreak | larger file size |

---

## 12. AmazonManager (`@Singleton` Hilt-injected)

`AmazonManager` is a Hilt `@Singleton` (NOT a static object) injected into `AmazonService`. Methods:
```kotlin
refreshLibrary()                  // getStoredCredentials → getEntitlements → upsertPreservingInstallStatus
getGameById(productId): AmazonGame?
getAllGames(): List<AmazonGame>
markInstalled(productId, installPath, installSize, versionId)
markUninstalled(productId)
updateDownloadSize(productId, size)
getBearerToken(): String?         // getStoredCredentials → accessToken
deleteAllNonInstalledGames()      // DELETE WHERE is_installed = 0
```

---

## 12b. Amazon SDK DRM Files (`AmazonSdkManager.kt`)

### Download spec
```
GET https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346
x-amzn-token: {access_token}
User-Agent: com.amazon.agslauncher.win/3.0.9202.1
Response: { "downloadUrl": "...", "versionId": "..." }
```
Then download + parse `manifest.proto` from that URL — same pipeline as game manifest.

### Files extracted from launcher manifest
Filter: `"Amazon Games Services"` in path
- `FuelSDK_x64.dll` → deployed to `Amazon Games Services/Legacy/`
- `AmazonGamesSDK_*` (any file matching pattern) → deployed to `Amazon Games Services/AmazonGamesSDK/`
- Skips macOS resource forks (`._*`)

### Cache
`filesDir/amazon_sdk/` with `.sdk_version` file. `isSdkCached()` = VERSION_FILE exists AND at least one file in `amazon_sdk/Amazon Games Services/`. **Does NOT re-download if a newer version exists** — only checks presence of version file.

### Deploy to Wine prefix (idempotent — skips if file exists and size matches)
```
src: filesDir/amazon_sdk/Amazon Games Services/**
dst: {wine_prefix}/drive_c/ProgramData/Amazon Games Services/**

Final Wine paths:
  C:\ProgramData\Amazon Games Services\Legacy\FuelSDK_x64.dll
  C:\ProgramData\Amazon Games Services\AmazonGamesSDK\AmazonGamesSDK_*.dll
```

---

## 13. ContainerUtils.kt — Amazon Drive Mapping (exact code)

### On container creation
```kotlin
GameSource.AMAZON -> {
    val appIdInt = runCatching { extractGameIdFromContainerId(appId) }.getOrNull()
    val installPath = if (appIdInt != null)
        AmazonService.getInstallPathByAppId(appIdInt) else null
    if (installPath != null && installPath.isNotEmpty()) {
        val drive: Char = if (defaultDrives.contains("A:")) {
            Container.getNextAvailableDriveLetter(defaultDrives)
        } else { 'A' }
        "$defaultDrives$drive:$installPath"
    } else defaultDrives
}
```

### On existing container (re-open)
Checks if A: is already mapped to the correct path; if not, rebuilds drives string with `A:{gameFolderPath}`.

### DX wrapper behavior
Amazon games do NOT get auto-detected DX wrapper — uses the user's default wrapper preference (unlike Steam which does auto-detection). Added in commit `2dc7638295d5`.

---

## 14. AmazonAppScreen.kt — UI State Machine

### State predicates
```kotlin
isInstalled()         → AmazonService.isGameInstalledByAppId(context, libraryItem.gameId)
isValidToDownload()   → !isInstalled() && AmazonService.getDownloadInfoByAppId(gameId) == null
isDownloading()       → AmazonService.getDownloadInfoByAppId(gameId) != null
getDownloadProgress() → DownloadInfo.getProgress()
hasPartialDownload()  → AmazonService.hasPartialDownloadByAppId(context, gameId)
```

### Button behaviors
**Install/Download click (`onDownloadInstallClick`):**
1. If `isDownloading()` → ignore
2. If `hasPartialDownload()` → `performDownload()` immediately (no dialog)
3. If `isInstalled()` → `onClickPlay(false)`
4. Otherwise → fetch manifest size → show `AmazonInstallDialog` (download size, install size, available space)

**Download:** `AmazonService.downloadGame(context, productId, installPath)` on IO thread

**Pause/Resume (`onPauseResumeClick`):**
- Active download → `AmazonService.cancelDownloadByAppId(appId)`
- No active download → `performDownload()` (resume from partial)

**Uninstall/Cancel (`onDeleteDownloadClick`):**
- If downloading or partial → `CANCEL_APP_DOWNLOAD` dialog (reuses `epic_delete_download_message` string)
- If installed → uninstall confirmation dialog

**Verify:** Source-specific menu → `AmazonService.verifyGame(context, productId)` on IO thread

### Image resolution
- Hero: `game.heroUrl` → fallback `game.artUrl` → fallback `libraryItem.iconHash`
- Icon: `game.artUrl` → fallback `libraryItem.iconHash`
- `downloadSize` proactively fetched from manifest if `<= 0L`

### Events observed
`LibraryInstallStatusChanged`, `DownloadStatusChanged`

---

## 15. Service Public API (`AmazonService` companion object)

```kotlin
isRunning: Boolean
isSyncInProgress(): Boolean
hasActiveOperations(): Boolean
start(context) / stop()
getInstance()
hasStoredCredentials(context)
authenticateWithCode(context, authCode)
logout(context)
isGameInstalled(productId)
isGameInstalledByAppId(context, appId)
getExpectedInstallPathByAppId(appId)
hasPartialDownloadByAppId(appId)
getInstallPath(productId) / getInstallPathByAppId(appId)
getProductIdByAppId(gameId)
getAmazonGameOf(productId)
getLaunchExecutable(containerId)
downloadGame(context, productId, installPath)
cancelDownload(productId) / cancelDownloadByAppId(appId)
getDownloadInfo(productId)
deleteGame(context, productId)
verifyGame(context, productId) -> Result<VerificationResult>
isUpdatePending(productId) / isUpdatePendingByAppId(appId)
```

### Intent launch fix (commit `fe682992dafd`, 2026-03-24)
External intent launches (home screen shortcuts) now defer until `AmazonService` emits `AndroidEvent.ServiceReady` — fixes silent launch failures when service wasn't yet running.

### ACTION constants
- `ACTION_SYNC_LIBRARY = "app.gamenative.AMAZON_SYNC_LIBRARY"`
- `ACTION_MANUAL_SYNC = "app.gamenative.AMAZON_MANUAL_SYNC"`

---

## 16. Verification

```kotlin
data class VerificationResult(
    val totalFiles: Int, val verifiedOk: Int,
    val missingFiles: Int, val sizeMismatch: Int, val hashMismatch: Int,
    val failedFiles: List<String>,
) { val isValid: Boolean get() = failedFiles.isEmpty() }
```
Reads cached manifest proto, checks each file: exists → size → SHA-256 (SHA-256 only; SHAKE128 skipped).

---

## 17. Uninstall

1. Parse `filesDir/manifests/amazon/{productId}.proto`
2. Delete each manifest-listed file
3. Walk directories bottom-up, remove empty ones
4. Remove install dir if empty; fallback to recursive delete if manifest parse fails
5. Remove both markers + `.DownloadInfo/` metadata dir
6. `ContainerUtils.deleteContainer(context, "AMAZON_{appId}")`

---

## 18. Open Issues (relevant)

**#955 (open)** — Library view doesn't update after uninstalling a game: `DownloadService.getDownloadDirectoryApps()` caches with 5s TTL; after delete emits `LibraryInstallStatusChanged`, cache still holds the deleted dir. Affects Amazon uninstall UI.

**#986 (closed → fixed in `fe682992dafd`)** — Intent launches fail for GOG/Epic/Amazon when service isn't ready: fix defers launch until `AndroidEvent.ServiceReady`.

---

## 19. AndroidEvent.kt — Amazon-Relevant Events

```kotlin
// Events that AmazonService emits (shared event bus with Steam/GOG/Epic):
data object ServiceReady : AndroidEvent<Unit>
    // Emitted in AmazonService.onCreate() — deferred intent launches wait for this

data class DownloadStatusChanged(val appId: Int, val isDownloading: Boolean) : AndroidEvent<Unit>
    // appId = AmazonGame.appId (Room integer)

data class LibraryInstallStatusChanged(val appId: Int) : AndroidEvent<Unit>
    // Emitted after install/uninstall — triggers UI refresh

data class ExternalGameLaunch(val appId: String) : AndroidEvent<Unit>
    // appId = "AMAZON_<int>" string — used for home screen shortcut intent launches
```

---

## 20. AndroidManifest.xml Entries

```xml
<!-- AmazonOAuthActivity — not exported (in-app WebView only) -->
<activity
    android:name=".ui.screen.auth.AmazonOAuthActivity"
    android:exported="false"
    android:theme="@style/Theme.Pluvia" />

<!-- AmazonService — foreground service, dataSync type -->
<service
    android:name=".service.amazon.AmazonService"
    android:enabled="true"
    android:exported="false"
    android:foregroundServiceType="dataSync" />
```

---

## 20. String Resources (Amazon)

```xml
<!-- Install/Uninstall dialogs -->
<string name="amazon_uninstall_game_title">Uninstall Game</string>
<string name="amazon_uninstall_confirmation_message">Are you sure you want to uninstall %1$s? This action cannot be undone.</string>
<string name="amazon_install_game_title">Download Game</string>
<string name="amazon_install_confirmation_message">The app being installed has the following space requirements. Would you like to proceed?\n\n\tDownload Size: %1$s\n\tAvailable Space: %2$s</string>

<!-- File verification -->
<string name="amazon_verify_files_title">Verify Files</string>
<string name="amazon_verify_files_message">This will check all installed files against the download manifest to detect missing or corrupted files.\n\nThis may take a while for large games.</string>
<string name="amazon_verify_confirm">Verify</string>
<string name="amazon_verify_in_progress">Verifying files… This may take a while.</string>
<string name="amazon_verify_success">All files verified successfully.\n\n%1$d / %2$d files OK.</string>
<string name="amazon_verify_failed_detail">Verification found issues.\n\n%1$d / %2$d files OK\n%3$d missing\n%4$d size mismatch\n%5$d hash mismatch\n\nReinstall the game to fix corrupted files.</string>
<string name="amazon_verify_error">Verification failed: %1$s</string>

<!-- Settings screen -->
<string name="amazon_integration_title">Amazon Games Integration (Alpha)</string>
<string name="amazon_settings_login_title">Sign in</string>
<string name="amazon_settings_login_subtitle">Sign in to your Amazon Games account</string>
<string name="amazon_login_success_title">Login Successful</string>
<string name="amazon_login_cancel">Cancel</string>
<string name="amazon_settings_logout_title">Logout</string>
<string name="amazon_settings_logout_subtitle">Sign out from your Amazon Games account</string>
<string name="amazon_logout_confirm_title">Logout from Amazon Games?</string>
<string name="amazon_logout_confirm_message">This will remove your Amazon Games credentials and clear your Amazon library from this device. You can sign in again at any time.</string>
<string name="amazon_logout_confirm">Logout</string>
<string name="amazon_logout_success">Logged out from Amazon Games successfully</string>
<string name="amazon_logout_failed">Failed to logout: %s</string>
<string name="amazon_logout_in_progress">Logging out from Amazon Games…</string>
<string name="amazon_service_running">Amazon Games Running</string>
```

---

## 21. LibraryItem / GameSource Integration

```kotlin
// GameSource enum
enum class GameSource { STEAM, CUSTOM_GAME, GOG, EPIC, AMAZON }

// appId format in LibraryItem: "AMAZON_<int>" (string)
// gameId property strips the prefix:
val gameId: Int
    get() = appId.removePrefix("${gameSource.name}_").toIntOrNull() ?: 0
// → for "AMAZON_42", gameId = 42 = Room appId int
```

`AmazonService.getProductIdByAppId(42)` maps Room int → Amazon product UUID.

---

## 22. Preferences (`PrefManager.kt`)
- `show_amazon_in_library` (Boolean, default `true`)
- `amazon_installed_games_count` (Int, default `0`) — skeleton loader count
- `gog_amazon_path_migrated` (Boolean, default `false`) — one-time migration flag
- Uses shared `PrefManager.useExternalStorage` and `PrefManager.externalStoragePath` (same as GOG/Epic)

---

## 23. API Constants Summary

| Constant | Value |
|---|---|
| `DEVICE_TYPE` | `A2UMVHOX7UP4V7` |
| `MARKETPLACE_ID` | `ATVPDKIKX0DER` |
| `APP_NAME` | `AGSLauncher for Windows` |
| `APP_VERSION` | `1.0.0` |
| `OS_VERSION` | `10.0.19044.0` |
| AUTH_REGISTER_URL | `https://api.amazon.com/auth/register` |
| AUTH_TOKEN_URL | `https://api.amazon.com/auth/token` |
| AUTH_DEREGISTER_URL | `https://api.amazon.com/auth/deregister` |
| ENTITLEMENTS_URL | `https://gaming.amazon.com/api/distribution/entitlements` |
| DISTRIBUTION_URL | `https://gaming.amazon.com/api/distribution/v2/public` |
| `GAMING_USER_AGENT` | `com.amazon.agslauncher.win/3.0.9202.1` |
| `DOWNLOAD_USER_AGENT` | `nile/0.1 Amazon` |
| `GAMING_KEY_ID` | `d5dc8b8b-86c8-4fc4-ae93-18c0def5314d` |
| `LAUNCHER_CHANNEL_ID` | `87d38116-4cbf-4af0-a371-a5b498975346` |
| `OPENID_ASSOC_HANDLE` | `amzn_sonic_games_launcher` |
| `OA2_SCOPE` | `device_auth_access` |
| GetEntitlements X-Amz-Target | `com.amazon.animusdistributionservice.entitlement.AnimusEntitlementsService.GetEntitlements` |
| GetGameDownload X-Amz-Target | `com.amazon.animusdistributionservice.external.AnimusDistributionService.GetGameDownload` |
| GetLiveVersionIds X-Amz-Target | `com.amazon.animusdistributionservice.external.AnimusDistributionService.GetLiveVersionIds` |

---

## 24. PR #557 Key Notes

From the full PR body (auto-summarized by cubic + CodeRabbit, plus manual body):

- Protocol follows [Nile](https://github.com/imLinguin/nile) open-source client exactly
- **No CLI binary** — pure Kotlin native implementation
- **`isSdkFile` filter matches Nile's `self_update.py` exactly**: `FuelSDK_x64.dll` + `AmazonGamesSDK_*`
- **`container.executablePath` caching** added to ALL stores (GOG, Epic, Amazon) in this PR — subsequent launches skip exe detection
- **Playtime tracking**: Amazon has full session timing (seconds granularity); GOG + Epic have DB field but no active tracking
- **Update checking**: GOG + Epic are TODO stubs; Amazon implements `GetLiveVersionIds` comparison
- **Verification**: GOG = directory existence only; Epic = none; Amazon = full file-level (existence + size + SHA-256 vs cached manifest)
- **Original `appId` approach**: PR body mentions "hashCode() for gameId compatibility" — this was an early approach, **replaced by Room AUTOINCREMENT** before/at merge (current DB has `INTEGER PRIMARY KEY AUTOINCREMENT`)
- **SDK download**: non-fatal if it fails — `ensureSdkFiles` returns false but launch still proceeds

---

## 25. What Is NOT Implemented

- Delta/patch updates (full re-download; Nile has scaffolding, not wired in GameNative)
- DLC handling
- Cloud saves (no known Amazon API)
- Prime Gaming free game claiming (purchased/owned only)

---

## 26. BannerHub Integration Notes

### Side menu entry
- Add `"Amazon Games"` as side menu item `ID=12` in `LandscapeMenuActivity` smali
- Route to `AmazonMainActivity` in `smali_classes16`
- Mirror GOG menu item (ID=10) as template

### Auth
- WebView to `www.amazon.com/ap/signin`; intercept BOTH `shouldOverrideUrlLoading` and `onPageStarted`
- Extract `openid.oa2.authorization_code` query param
- PKCE: device serial (UUID no-dashes uppercase), clientId (hex of `serial#A2UMVHOX7UP4V7`), code verifier (32 random bytes URL-safe Base64), code challenge (SHA-256 of verifier)
- POST register to `api.amazon.com/auth/register` with full registration body
- Store credentials at `filesDir/amazon/credentials.json`

### Library sync
- POST to `gaming.amazon.com/api/distribution/entitlements` with `X-Amz-Target` + `Content-Encoding: amz-1.0`
- `hardwareHash` = SHA-256 UPPERCASE of deviceSerial
- Paginate with `nextToken`

### Download
- POST `GetGameDownload` with `entitlementId` → `downloadUrl` + `versionId`
- GET `{downloadUrl}/manifest.proto` → parse custom protobuf
- Download each file at `{downloadUrl}/files/{sha256_hex_of_file}` with `nile/0.1 Amazon` UA
- 6 parallel, SHA-256 verify, resume-friendly

### SDK DLLs (required before launch)
- Download SDK manifest from LAUNCHER_CHANNEL_ID channel
- Extract `FuelSDK_x64.dll` → `C:\ProgramData\Amazon Games Services\Legacy\`
- Extract `AmazonGamesSDK_*` → `C:\ProgramData\Amazon Games Services\AmazonGamesSDK\`

### Launch
- Try `fuel.json` at `{installPath}/fuel.json` (keys: `Main.Command`, `Main.WorkingSubdirOverride`, `Main.Args`)
- Fallback: `ExecutableSelectionUtils.choosePrimaryExeFromDisk()`
- Cache resolved exe in `container.executablePath` (skip detection on re-launch)
- Drive: `A:` maps to install path
- Set 5 FuelPump env vars
- Command: `winhandler.exe "A:\path\to\game.exe" [fuel.json args]`
- Skip cloud sync gate at pre-launch

### Key simplification vs Epic
- No exchange token call; no extra launch args
- fuel.json handles most games; heuristic catches rest
- No `-epicapp` style args
