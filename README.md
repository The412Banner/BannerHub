<p align="center">
  <img src="assets/bannerhub-logo.jpg" alt="BannerHub" width="200"/>
</p>

# BannerHub

**GameHub 5.3.5 ReVanced** — extended with GOG Games, Amazon Games, and Epic Games Store library tabs, a full Component Manager, in-app component downloader, background download service with in-app cross-store download manager, SD card / external storage routing for store game downloads, Winlator HUD overlay (Normal + Extra Detailed + Konkr style with CPU/GPU/RAM/SWAP/temp/per-core metrics), in-game performance toggles, RTS touch controls, VRAM unlock, per-game CPU core affinity, root access management, offline Steam launch, community game configs browser, per-game config export/import with Frontend Export, Japanese locale, and more. Built entirely with apktool smali patching — no source code, no external library injection.

## AI Disclaimer

All smali edits, patches, and code changes in this project are developed with the assistance of **[Claude AI Sonnet 4.6](https://www.anthropic.com/claude)** by Anthropic. Claude is used to write, review, and modify smali bytecode and Java extension code since this project has no source code to work from — all changes are applied directly to the decompiled APK via apktool.

Before any stable release is published, all changes are manually debugged and tested by me across multiple devices — both rooted and unrooted. Debugging is done using logcat output and in-app debug log files to diagnose and verify behavior before changes are finalized.

---

## Video — Installation & Feature Showcase

[![BannerHub Installation & Features](https://img.youtube.com/vi/Vwv8YNnWWdg/maxresdefault.jpg)](https://youtu.be/Vwv8YNnWWdg?si=Ypz66yMU8ZQUngU9)

*Installing the app, installing games, and showcasing all features.*

---

## Table of Contents

- [Installation](#installation)
- [Keeping BannerHub Updated](#keeping-bannerhub-updated)
- [Features](#features)
  - [GOG Games](#gog-games)
  - [Amazon Games](#amazon-games)
  - [Epic Games Store](#epic-games-store)
  - [Component Manager](#component-manager)
  - [In-App Component Downloader](#in-app-component-downloader)
  - [Download Manager Button](#download-manager-button)
  - [External Storage — SD Card](#external-storage--sd-card)
  - [Winlator HUD Overlay](#winlator-hud-overlay) (Normal + Extra Detailed + Konkr Style)
  - [Performance Sidebar Toggles](#performance-sidebar-toggles)
  - [RTS Touch Controls](#rts-touch-controls)
  - [VRAM Limit Unlock](#vram-limit-unlock)
  - [Community Game Configs](#community-game-configs)
  - [Per-Game Config Export / Import](#per-game-config-export--import)
  - [Per-Game CPU Core Affinity](#per-game-cpu-core-affinity)
  - [PC Game Settings: Offline Mode](#pc-game-settings-offline-mode)
  - [Offline Steam Launch](#offline-steam-launch)
  - [Settings: Advanced Tab](#settings-advanced-tab)
  - [Controller Navigation](#controller-navigation)
  - [Wine Task Manager](#wine-task-manager)
  - [Component Descriptions in Game Settings](#component-descriptions-in-game-settings)
  - [Japanese Locale](#japanese-locale)
  - [Virtual Container Cleanup on Uninstall](#virtual-container-cleanup-on-uninstall)
  - [UI Tweaks](#ui-tweaks)
- [How It Works](#how-it-works)
- [FAQ](#faq)
- [BannerHub Lite](#bannerhub-lite)
- [Implementation Reports](#implementation-reports)
- [Credits](#credits)
- [Signing](#signing)

---

## Installation

Download the APK that matches your existing GameHub package name from the [latest release](https://github.com/The412Banner/bannerhub/releases/latest):

| APK | Package | App Label |
|-----|---------|-----------|
| `BannerHub-vX.Y.Z-Normal.apk` | `banner.hub` | BannerHub |
| `BannerHub-vX.Y.Z-Normal.GHL.apk` | `gamehub.lite` | BannerHub |
| `BannerHub-vX.Y.Z-PuBG.apk` | `com.tencent.ig` | BannerHub PuBG |
| `BannerHub-vX.Y.Z-AnTuTu.apk` | `com.antutu.ABenchMark` | BannerHub AnTuTu |
| `BannerHub-vX.Y.Z-alt-AnTuTu.apk` | `com.antutu.benchmark.full` | BannerHub AnTuTu |
| `BannerHub-vX.Y.Z-PuBG-CrossFire.apk` | `com.tencent.tmgp.cf` | BannerHub PuBG CrossFire |
| `BannerHub-vX.Y.Z-Ludashi.apk` | `com.ludashi.aibench` | BannerHub Ludashi |
| `BannerHub-vX.Y.Z-Genshin.apk` | `com.miHoYo.GenshinImpact` | BannerHub Genshin |
| `BannerHub-vX.Y.Z-Original.apk` | `com.xiaoji.egggame` | BannerHub Original |

**Which APK do I need?**

If you do not already have any GameHub variant installed, use the **Normal APK** (`banner.hub`). It installs as a completely separate app alongside the official GameHub Lite — both can coexist. If you want BannerHub to take over the `gamehub.lite` package slot (e.g. so apps that launch GameHub Lite by package name launch BannerHub instead), use **Normal.GHL** — but you must **uninstall the official GameHub Lite first** since they share the same package name and have different signing certificates. If you want to use a specific GameHub variant for performance spoofing (e.g. PuBG or Genshin), pick the matching APK. **Be aware: performance spoofing variants push your device harder and generate significantly more heat. Do not use these variants without proper cooling and a clear understanding of what you are doing. Use at your own risk.**

All 9 variants can be installed simultaneously. All APKs are signed with AOSP testkey (v1/v2/v3).

> **Note:** You must uninstall your existing BannerHub build before installing a new release if the signing certificate changed. Data is not preserved across uninstall.

---

## Keeping BannerHub Updated

Use **[Obtainium](https://github.com/ImranR98/Obtainium)** to automatically track and install new BannerHub stable releases directly from GitHub — no manual checking required.

Add this repo (`https://github.com/The412Banner/BannerHub`) as an app source in Obtainium. Starting with **v3.4.0**, BannerHub reports its own version number to Android (e.g. `3.4.0`) instead of the base GameHub version, so Obtainium can correctly detect when a new release is available and prompt you to update.

**Required setting:** When adding BannerHub in Obtainium, enable **"Reconcile version string with version detected from OS"**. This tells Obtainium to compare the GitHub release tag against the version installed on your device. Without this, Obtainium may not detect version changes correctly.

> [!WARNING]
> Only track **stable releases** in Obtainium. Pre-release builds use a different package name (`com.tencent.ig`) and cannot be upgraded to stable without uninstalling first — installing a pre-release over a stable build will break your install.

---

## Features

### GOG Games

Accessible via the left side menu → **GOG**.

For the complete technical implementation breakdown, see [GOG_IMPLEMENTATION.md](game-store-reports/GOG_IMPLEMENTATION.md) (API endpoints, auth flow, manifest format, download pipeline, BannerHub integration guide).

#### Authentication

- **OAuth2 login** — a WebView opens GOG's standard OAuth2 authorization page. After you log in, BannerHub captures the authorization code from the redirect URL and exchanges it for an access token + refresh token. Both tokens are stored in the `bh_gog_prefs` SharedPreferences file.
- **Auto token refresh** — before every API call, BannerHub checks the token expiry timestamp. If the token has expired (or will expire within the margin), it silently issues a refresh request using the stored refresh token. You never need to log in again unless you explicitly log out.
- **Login persistence** — your session survives app restarts and device reboots.

#### Library

- **Library sync** — on login or manual refresh, BannerHub fetches your full GOG library. Both Generation 1 (pre-Galaxy era) and Generation 2 (Galaxy) games are included.
- **Metadata per game** — title, developer, description, cover image, download size, Gen 1 / Gen 2 badge.
- **Game cards** — scrollable list and grid view with cover art, title, developer, install state, Install / progress / Add / Launch button.

#### Download Pipeline

BannerHub supports both GOG's current and legacy download systems:

**Generation 2 (Galaxy-era games):**

1. Fetches the build manifest from `content-system.gog.com/products/{id}/os/windows/builds`
2. Reads the depot manifest URL from the build record
3. Downloads and parses the depot manifest to get the full file list with CDN paths
4. Downloads each file individually, writing to `filesDir/gog_games/{title}/`
5. Per-file progress shown in real time — filename + percentage + download speed (MB/s)

**Generation 1 (pre-Galaxy legacy games):**

1. Fetches builds with `generation=1` parameter
2. Reads the depot manifest, parses `depot.files[]`, skips support-only files
3. Downloads each file using `Range` HTTP requests (byte-range resumable download)
4. Assembles files into the install directory

**Installer fallback (very old pre-Galaxy games with no content-system builds):**

1. Calls `api.gog.com/products/{id}?expand=downloads`
2. Reads the `downlink` or `manualUrl` from the downloads object
3. Downloads the Windows installer `.exe` directly

#### Install Flow

- Tapping **Install** opens a confirmation dialog showing download size and available storage — nothing downloads until you confirm.
- Downloads run via the **BhDownloadService foreground service** — a persistent notification with a **Cancel** action appears in the notification tray. The download continues if you leave the screen or switch apps.
- A `ProgressBar` + status text replaces the Install button during download. Live progress is also visible in the [Download Manager](#download-manager-button).
- After install, BannerHub scans for qualifying executables (excluding redist/setup/unins/crash/helper paths). One found → auto-selected. Two or more → exe picker dialog.
- On completion an **Add Game** button appears. Tapping it opens GameHub's `EditImportedGameInfoDialog` pre-populated with the executable path.
- A green ✓ **Installed** checkmark appears on the card immediately — no app restart needed.

#### Post-Install

- **Persistent install state** — `bh_gog_prefs` is read on every app open; already-installed cards show checkmark and Add button automatically.
- **Launch** — Add Game button passes the stored executable path to `EditImportedGameInfoDialog`.
- **Set .exe** — detail dialog shows current executable and a **Set .exe…** button to re-scan and re-pick at any time.
- **Copy to Downloads** — recursively copies `filesDir/gog_games/{dirName}/` to `Downloads/{dirName}/`.
- **Uninstall** — recursively deletes install directory, removes all prefs keys, resets card. Both header ✓ and expanded ✓ disappear immediately.

---

### Amazon Games

Accessible via the left side menu → **Amazon Games**.

For the complete technical implementation breakdown, see [AMAZON_IMPLEMENTATION.md](game-store-reports/AMAZON_IMPLEMENTATION.md) (PKCE auth, GetEntitlements API, manifest.proto format, XZ/LZMA decode, FuelPump env vars, SDK DLL deployment, BannerHub integration guide).

*Pipeline based on research by [The GameNative Team](https://github.com/utkarshdalal/GameNative).*

#### Authentication

- **PKCE OAuth2 login** — a WebView opens Amazon's standard sign-in page. BannerHub intercepts the authorization code directly from the redirect URL — the detection checks for `openid.oa2.authorization_code=` in any redirect URL, so it works correctly through OTP / 2FA intermediate pages without hanging. Tokens are stored in `bh_amazon_prefs`.
- **Auto token refresh** — silently refreshed before expiry. You never need to log in again unless you uninstall.

#### Library

- **Library sync** — fetches your full Amazon Games entitlements list via `GetEntitlements`. Each entry includes title, product SKU, entitlement ID, and cover art.
- **Game cards** — scrollable list and grid view with cover art, title, install state, Install / progress / Launch button.

#### Download Pipeline

1. Calls `GetGameDownload` to retrieve the CDN download URL and version ID
2. Downloads `manifest.proto` — a protobuf manifest listing every file with its CDN hash path, size, and SHA-256 checksum
3. Downloads files in **6 parallel threads** — each file fetched via its hash path, SHA-256 verified, renamed to final path
4. Progress shows current filename and download speed (MB/s)
5. Resumable — already-complete files (matching size) are skipped on retry

Downloads run via the **BhDownloadService foreground service** — a persistent notification with a **Cancel** action appears in the notification tray and the download continues if you leave the screen. Live progress is also visible in the [Download Manager](#download-manager-button).

#### Post-Install

- **Launch** — reads `fuel.json` from the install directory to determine the executable and required FuelPump environment variables, then launches via GameHub's `EditImportedGameInfoDialog`
- **SDK DLLs** — `FuelSDK_x64.dll` and `AmazonGamesSDK_*` DLLs are deployed to the install directory at launch time
- **Set .exe** — detail dialog lets you override the detected executable at any time
- **Update checker** — compares installed version against current CDN version; marks cards with an update badge when newer version is available
- **Uninstall** — removes install directory and all prefs; both header ✓ and expanded ✓ disappear immediately

---

### Epic Games Store

Accessible via the left side menu → **Epic Games**.

For the complete technical implementation breakdown, see [EPIC_IMPLEMENTATION.md](game-store-reports/EPIC_IMPLEMENTATION.md) (OAuth2 auth, library API, manifest format, CDN selection, chunk download pipeline, BannerHub integration guide).

*Pipeline based on research by [The GameNative Team](https://github.com/utkarshdalal/GameNative).*

#### Authentication

- **OAuth2 login** — a WebView opens Epic's login page. After sign-in, BannerHub reads the `authorizationCode` from Epic's JSON redirect response body via `evaluateJavascript`, exchanges it for tokens using the Legendary client credentials, and stores them in `bh_epic_prefs`.
- **Auto token refresh** — silently refreshed before expiry.

#### Library

- **Library sync** — fetches owned games from Epic's library API, enriches each entry with catalog metadata: title, developer, description, cover art, DLC detection, CanRunOffline flag.
- **Game cards** — scrollable list and grid view with cover art, title, developer, and install state.

#### Download Pipeline

1. Fetches the manifest API JSON to locate manifest files on Epic's CDN
2. Downloads the binary or JSON manifest — parses full file list, chunk map, per-chunk SHA-1 hashes
3. Downloads chunks in **6 parallel threads** from Fastly or Akamai CDN (public — no auth token required on chunks)
4. Assembles each game file from its ordered chunks, SHA-1 verified per chunk
5. Progress shows current filename and download speed (MB/s)

Downloads run via the **BhDownloadService foreground service** — a persistent notification with a **Cancel** action appears in the notification tray and the download continues if you leave the screen. Live progress is also visible in the [Download Manager](#download-manager-button).

#### Post-Install

- **Launch** — sets `pending_epic_exe` in SharedPreferences → picked up by the main launcher activity → opens `EditImportedGameInfoDialog`
- **Set .exe** — override the detected executable at any time
- **Uninstall** — removes install directory and prefs; both header ✓ and expanded ✓ disappear immediately

---

### Component Manager

Accessible via the left side menu → **Components**.

The Component Manager gives you full control over the WCP/ZIP components that GameHub uses to run Windows games — the DXVK, VKD3D, Box64, FEXCore, and GPU Driver entries that appear in per-game settings.

#### Card UI

Each installed component is displayed as a compact card with:

- **Color-coded type badge** — DXVK (blue), VKD3D (purple), Box64 (green), FEXCore (orange), GPU Driver (yellow), WCP (grey) — with a matching left accent strip
- **Source badge** — components downloaded via BannerHub show the repo they came from (e.g. "Arihany WCPHub", "Nightlies by The412Banner")
- **Install count** in the header showing total managed components
- **Live search bar** — type any part of a component name to filter cards in real time

#### Actions

| Action | How to trigger | What it does |
|--------|---------------|-------------|
| **Inject file** | Tap a card, select a WCP or ZIP | Replaces the component's contents with the new file. The folder is cleared first — no stale files |
| **Add New Component** | Tap **"+ Add New"** in the bottom bar | Injects a WCP or ZIP as a brand new component slot. It immediately appears in GameHub's DXVK/VKD3D/Box64/FEXCore/GPU Driver selection menus and persists across restarts |
| **Backup** | Swipe RIGHT on a card | Copies the component folder to `Downloads/BannerHub/{name}/` |
| **Remove** | Swipe LEFT on a card | Unregisters the component from GameHub's in-memory map, deletes the folder on disk, and clears its downloaded indicator in the online repo browser |
| **Remove All** | Tap "Remove All" | Removes only BannerHub-managed components. The confirmation dialog shows the exact count. Stock GameHub components are never touched |

#### Format Support

| Format | Used by | Extraction |
|--------|---------|-----------|
| ZIP (PK magic) | Turnip, adrenotools GPU drivers | Flat extraction — `meta.json` + `.so` files land directly in the component root |
| Zstd-compressed tar (`.wcp`) | DXVK, VKD3D, Box64 | Preserves `system32/` + `syswow64/` internal structure |
| XZ-compressed tar (`.wcp`) | FEXCore nightlies | Flat extraction to component root |

BannerHub uses GameHub's own bundled libraries (`commons-compress`, `zstd-jni`, `tukaani xz`) for extraction — no external dependencies are injected, so there are no class loader conflicts.

---

### In-App Component Downloader

Inside the Component Manager, tap **Download** at the bottom of the screen to open the **Download Components** browser and install components directly from GitHub without leaving the app.

#### Navigation

Three-level navigation: **Repo** → **Category** → **Asset list**

- **Repo list** — all built-in sources shown as selectable entries
- **Category list** — choose from DXVK, VKD3D, Box64, FEXCore, or GPU Driver
- **Asset list** — shows all available assets with file size where available. Assets already installed via BannerHub show a checkmark; the mark clears when the component is removed

Tapping any asset downloads it to the cache directory and injects it as a new component automatically, with a progress screen showing "Downloading: `<filename>`" during the fetch.

#### Built-in Sources

| Source | Format | Types available |
|--------|--------|----------------|
| [**Arihany WCPHub**](https://github.com/Arihany/WinlatorWCPHub) | `pack.json` flat manifest | DXVK, VKD3D, Box64, FEXCore, GPU Drivers |
| [**The412Banner Nightlies**](https://github.com/The412Banner/Nightlies) | GitHub Releases API (`nightly-*` tag) | DXVK, VKD3D-Proton, Box64, FEXCore, GPU Drivers |
| **Kimchi GPU Drivers** | GitHub Releases API | GPU Drivers only |
| **StevenMXZ GPU Drivers** | GitHub Releases API | GPU Drivers only |
| **MTR GPU Drivers** (MaxesTechReview) | `rankings.json` | GPU Drivers only |
| **Whitebelyash GPU Drivers** | GitHub Releases API | GPU Drivers only |

---

### Download Manager Button

A **⬇ button** in the launcher dashboard opens the **Download Manager** (BhDownloadsActivity) — a live cross-store download dashboard accessible from anywhere in the app. The button updates in real time: at rest it shows ⬇; when one or more downloads are active it shows a **red count badge** (e.g. ⬇ 2) that increments and decrements as jobs start and finish.

#### Download Manager (BhDownloadsActivity)

A persistent screen showing all active and completed downloads across GOG, Amazon, and Epic simultaneously:

- **Active rows** — each active download shows the game name, current status message, and a live percentage `ProgressBar`. A **Cancel** button stops the download immediately and cleans up partial files.
- **Completed library** — finished downloads persist in `bh_library` SharedPreferences and are shown as completed rows with a color-coded store badge. Each row has:
  - **Launch** — opens `EditImportedGameInfoDialog` pre-populated with the stored executable path
  - **Uninstall** — confirms and deletes the install directory and all associated prefs
  - **×** — removes the entry from the completed list without uninstalling
- **Clear ✓** — header button that removes all completed entries at once
- Active rows convert to completed rows in-place when a download finishes — no need to return to the store screen to see the result

The ⬇ button in each store's header (GOG, Amazon, Epic) also opens the Download Manager directly from within the store view.

All downloads are handled by **BhDownloadService**, an Android foreground service. A persistent notification with a **Cancel** action appears in the notification tray for each active download. Downloads survive leaving the detail screen, switching apps, or navigating elsewhere in BannerHub.

---

### External Storage — SD Card

A **"Save Store Games to External Storage (SD Card)"** toggle in the BannerHub side menu settings controls where GOG, Epic, and Amazon game downloads are saved.

- **Toggle OFF (default):** games install to internal app storage at `Android/data/<package>/files/{store}/{game}/`
- **Toggle ON:** games install to your SD card at `{SD card}/bannerhub/{store}/{game}/` — visible as a `bannerhub/` folder at the root of the SD card with subfolders per store (`gog_games/`, `epic_games/`, `Amazon/`)

**Turning the toggle on or off shows a confirmation dialog** explaining what will change before anything is applied. Pressing Cancel reverts the switch without making any change.

**Install location is locked at install time.** The full absolute path is saved to SharedPreferences the moment a game finishes installing. All uninstall paths (game list, detail page, download manager) read and delete from that stored path directly — the toggle state at uninstall time is irrelevant. Installing with the toggle on, flipping it off, then uninstalling will still correctly remove the game from the SD card.

**Install path display:** each game's detail page shows the full install path in the ACTIONS card when the game is installed, alongside a colored badge indicating the storage location:
- **💾 SD Card** — green pill, game is on the SD card
- **📁 Internal** — grey pill, game is in internal app storage

---

### Winlator HUD Overlay

An in-game heads-up display that shows real-time performance metrics while a game is running. Accessible from the in-game **Performance sidebar**.

Three HUD modes are available (only one active at a time):

#### Normal HUD

- **FPS** — current frames per second with a live frame-time graph
- **Frame time** — milliseconds per frame
- **Resolution** — current render resolution

#### Extra Detailed HUD

A second, expanded overlay that replaces the Normal HUD when the **Extra Detailed** checkbox is enabled. Displays a richer set of metrics:

- **FPS** — current frames per second with frame-time graph (spans both rows in horizontal layout)
- **CPU usage** — overall CPU load percentage
- **GPU usage** — GPU load percentage
- **RAM** — used / total memory
- **SWAP** — swap used / total in GB
- **CPU temperature** — thermal zone reading for the main CPU cluster
- **GPU temperature** — Adreno GPU thermal reading
- **Battery temperature** — battery thermal reading

Available in both **horizontal** (metrics displayed side-by-side in two aligned rows) and **vertical** (one metric per row) layouts — toggled with the same Orientation switch as the Normal HUD.

The *Extra Detailed* checkbox is automatically grayed out and disabled when the Winlator HUD toggle is off.

The Extra Detail HUD is a continuation and extension of the **Winlator HUD by Stevenmxz**. The additional metrics and layout were inspired by the performance HUD built into my personal device — no credit is claimed from any external project.

#### Konkr Style HUD

A third HUD style, mutually exclusive with Extra Detailed. Enable via the **Konkr Style** checkbox in the Performance sidebar. Reproduces the layout of the Konkr strategy game's built-in HUD.

**Vertical (default):** a 2-column table with:
- FPS (large, top row)
- CPU% + CPU temperature
- Per-core MHz for cores C0–C7
- GPU% + GPU temperature + GPU name + current clock + Wine container resolution
- MODE / SKN / PWR readings
- RAM — used / total GB (brown label background)
- SWAP — used / total GB (gray label background)
- BAT — battery % with a blue proportional fill bar
- TIME — current time

**Horizontal:** a compact multi-column strip — FPS block (current/min FPS + CPU temp), CPU 2×4 core grid, GPU block, thermal/power 2-column block, memory block with colored label backgrounds.

Tap anywhere on the HUD to toggle between vertical and horizontal. Drag to reposition. The opacity slider applies to the Konkr HUD.

> **Note:** Not all data collected and displayed will always be correct. Each device detects and reads data differently. Values are read directly from sysfs/proc and may vary in accuracy depending on your device, kernel, and thermal zone mapping.

#### Configuration (all modes)

- **Opacity slider** — adjusts transparency of the active HUD overlay from fully opaque to nearly invisible
- **Text shadow/halo** — a centered shadow is automatically applied to all HUD text when opacity drops below 30% (stronger at <10%), ensuring readability against any background
- **Position** — drag to reposition on screen
- **Orientation** — horizontal or vertical layout

All position, orientation, and opacity settings are persisted in SharedPreferences and restored automatically the next time the Performance sidebar is opened.

---

### Performance Sidebar Toggles

Located in the in-game **Performance sidebar tab**, above the Dual Battery Mode toggle. Both toggles persist their state in `bh_prefs` SharedPreferences and are re-applied automatically every time the Performance sidebar is opened.

> **WARNING — USE AT YOUR OWN RISK**
>
> These toggles override your device's thermal management. Forcing the CPU and GPU to run at maximum frequency continuously generates significantly more heat than normal operation. Sustained high temperatures can cause permanent damage to your device's processor, battery, and other components. Device manufacturers do not support or warrant against damage caused by overriding performance governors. By using these toggles you accept full responsibility for any damage, data loss, throttling, unexpected shutdowns, or reduced component lifespan that results. **Do not leave these enabled unattended. Monitor your device temperature. Disable them immediately if your device becomes uncomfortably hot.**

Both toggles require root. Without root, both are greyed out at 50% opacity and non-interactive. Root access is checked once when you grant it in **Settings → Advanced** — there is no root popup every time the sidebar opens.

#### Sustained Performance Mode

Sets all CPU cores to the `performance` frequency governor via `su`, eliminating all downclocking while the toggle is on. On disable, `schedutil` is restored.

```sh
# Enable
for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo performance > "$f"; done
# Disable
for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo schedutil > "$f"; done
```

#### Max Adreno Clocks

Locks the Qualcomm Adreno GPU clock floor equal to the ceiling via the KGSL devfreq sysfs interface, so the GPU cannot downclock under any load condition short of a kernel thermal emergency.

```sh
# Enable — set min_freq = max_freq
cat /sys/class/kgsl/kgsl-3d0/devfreq/max_freq > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
# Disable — remove floor
echo 0 > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
```

**Use both toggles together** for maximum sustained CPU + GPU performance (root required).

---

### RTS Touch Controls

*Thanks to [@Nightwalker743](https://github.com/Nightwalker743) for making this possible.*

Enable via the **Controls tab** in the in-game sidebar. Adds a full gesture overlay for PC strategy and RTS games that maps touch gestures to mouse inputs inside the Wine environment.

#### Gesture Map

| Gesture | Mouse action |
|---------|-------------|
| Single tap | Move cursor + left-click at tap position |
| Drag | Hold LMB while dragging — draws a box selection |
| Long press (300 ms) | Right-click at press position |
| Double-tap (within 250 ms / 50 px) | Double left-click |
| Two-finger pan | Camera pan (direction configurable) |
| Pinch to zoom | Mouse wheel scroll up/down (configurable) |

Tap the **gear icon** in the Controls tab to configure pan direction and pinch-to-zoom scroll direction.

---

### VRAM Limit Unlock

PC game settings → **VRAM Limit** now includes **6 GB, 8 GB, 12 GB, and 16 GB** options in addition to the original GameHub range of 512 MB through 4 GB.

---

### Community Game Configs

Accessible via the left side menu → **Game Configs**. A four-screen community browser for sharing and downloading per-game Wine/DXVK/component configurations.

#### Games list (Screen 1)

- Searchable list of all games that have community configs — each game shows a config count badge
- Populated from a pre-built `games.json` file refreshed every 30 minutes and on every new upload
- Total game count is shown in the header subtitle next to your device/SOC info (e.g. `Samsung SM-G998B  •  Adreno 750  •  89 games`); updates to `X of Y games` while the search box is active

#### Configs list (Screen 2)

- Lists all shared configs for the selected game — each card shows device model, SOC, upload date, vote count, and download count
- **SOC filter chips** — a scrollable chip bar at the top lets you filter by GPU type (e.g. filter to only configs from Adreno 750 devices). Chips are built from the SOC values present in the loaded configs. "All" chip shows everything. Resets when switching games.
- **✓ My SOC badge** — configs uploaded from a device with the same SOC as yours are tagged in green
- **Age indicator** — configs older than 6 months are labeled "may be outdated"
- **Upvote** — tap to vote for configs you find useful

#### Config detail (Screen 3)

- **Expanded metadata card** — loaded on demand and displays up to 11 rows of actual config values:
  - Device, SOC, Date, Renderer, CPU, FPS Cap, BH Version
  - Wine / Proton, DXVK, VKD3D, GPU Driver, FEXCore, Box64 — component names used by the uploader
  - Resolution, Command Line, Env Vars (if set)
  - Settings key count, bundled component count
- **Uploader description** and **verified SOC badge** (green ✓ if SOC matches yours)
- **Download to Device** — saves the config JSON locally
- **View Settings & Components** — expands the raw settings and component list inline
- **Share Config URL** — copies a direct download link to clipboard
- **Report Config** — flag inappropriate or broken configs
- **Comments** — read and post comments on any config

#### My Uploads (Screen 4)

- Lists all configs you have uploaded in this session
- **Edit Description** — add or update a description visible to other users (token-authenticated, only the original uploader can edit)
- **Delete** — long-press any entry in the list, or tap the **Delete My Upload** button on the config detail screen, to permanently remove your config from the community database. A confirmation dialog is shown before anything is deleted. Token-authenticated — only the original uploader can delete their own config.

#### Backed by

All configs are stored in **[The412Banner/bannerhub-game-configs](https://github.com/The412Banner/bannerhub-game-configs)**. The community is powered by a Cloudflare Worker — votes, downloads, descriptions, and comments are tracked without any account required.

You can also browse, search, filter, and download configs from the web at **[the412banner.github.io/bannerhub-game-configs](https://the412banner.github.io/bannerhub-game-configs/)** — no app required.

> The community database grows through contributions — if you find settings that work well for a game on your device, sharing them helps other users get a working config without trial and error.

---

### Per-Game Config Export / Import

PC game settings include **Export Config**, **Frontend Export**, and **Import Config** options.

#### Export Config

Opens a **preview dialog** showing what will be exported before any file is created:
- Device model, SOC (GPU), settings count, components count

Then choose:
- **Save Locally** — saves to `/sdcard/BannerHub/configs/` on your device
- **Save Locally + Share Online** — saves locally and uploads to the community database

The exported filename embeds the game name, device manufacturer, device model, and SOC (e.g. `GodOfWar-Samsung-SM_S928B-Adreno_750-1234567890.json`).

#### Frontend Export

A separate **Frontend Export** option in the PC game settings popup creates a launcher `.iso` file for use with a supported frontend instead of exporting a BannerHub config JSON.

- Opens a dialog to select the target frontend: **Beacon** or **ES-DE**
- For **Beacon**: creates `Downloads/bannerhub/frontend/Beacon/{gameName}.iso`
- For **ES-DE**: creates `Downloads/bannerhub/frontend/ES-DE/{gameName}.steam`

Both use the same game ID logic — `localGameId` for imported games, `getSteamAppId()` for catalog games.

> **ES-DE note:** If the exported `.steam` file doesn't work for a particular game, [RobZombie9043/steam-files-es-de](https://github.com/RobZombie9043/steam-files-es-de) is a community resource with pre-made `.steam` files for Steam catalog games.

#### Import Config

A dialog lets you choose:
- **My Device** — lists `.json` files saved in `/sdcard/BannerHub/configs/`. Selecting a file shows a **preview card** (device, SOC, settings count, components count) with a **⚠ SOC mismatch warning** if the config was made on a different GPU. Tap Apply to proceed or Cancel.
- **Browse Community** — opens the Community Game Configs browser (see above) filtered to the current game

If a config references components not currently installed, a dialog lists the missing ones and offers to download and install them via the Component Manager before applying.

#### Cross-Compatibility with BannerHub Lite

Configs exported from BannerHub are fully compatible with **[BannerHub Lite](https://github.com/The412Banner/Bannerhub-Lite)**, and vice versa.

Both apps store per-game Wine settings under the same SharedPreferences keys (`pc_g_setting<gameId>`) and export to the same folder (`/sdcard/BannerHub/configs/`). The export format is identical — the app that created the config has no effect on whether it can be imported. The `app_source` field in the JSON (`"bannerhub"` or `"bannerhub_lite"`) is only used by the community config site for filtering and is ignored during import.

---

### Per-Game CPU Core Affinity

PC game settings → **Core Count** is replaced with a multi-select dialog to choose exactly which CPU cores the game process is pinned to.

| Core(s) | Label |
|---------|-------|
| Core 0–3 | Efficiency |
| Core 4–6 | Performance |
| Core 7 | Prime |

- **Apply** — saves the selected core bitmask and updates the settings row label immediately
- **No Limit** — clears affinity, the game process can use any core
- Selecting all 8 cores is equivalent to No Limit

---

### PC Game Settings: Offline Mode

Opening PC game settings while offline no longer blocks with a spinner or error. Container and component lists fall back to empty data, and all settings rows remain fully accessible and editable without a network connection.

---

### Offline Steam Launch

When Steam auto-login fails at cold start with no network, BannerHub detects the condition, skips the Steam login screen, and proceeds using the locally cached Steam configuration. You can continue playing your installed Steam library offline.

---

### Settings: Advanced Tab

| Setting | What it does |
|---------|-------------|
| **EmuReady API** | Toggle EmuReady compatibility checks |
| **CPU Usage Display** | Show/hide CPU usage overlay during gameplay |
| **Performance Metrics** | Show/hide full performance metrics overlay |
| **Sustained Performance Mode** | Same toggle as the Performance sidebar — available here for convenience outside a running game |
| **Grant Root Access** | Opens a warning dialog, then runs `su -c id` on a background thread and stores the result. Performance sidebar reads this pref to enable or grey out the root-dependent toggles — no unsolicited root popup on sidebar open |

---

### Controller Navigation

All three game store activities (GOG, Epic, Amazon) support full D-pad / gamepad controller navigation.

- **Game cards (list view)** — navigate up/down with D-pad; focused card shows a **gold 3dp border** + slightly lighter background; press A to expand/collapse
- **Game tiles (grid/poster view)** — navigate in all four directions; focused tile shows a gold border via a foreground overlay (works correctly with rounded-corner art clipping); press A to expand/select
- **Header buttons** (back ←, view toggle, refresh ↺) — focusable with a gold 2dp border + lighter fill on focus; press A to activate

Focus highlight uses gold (#FFD700) consistently across all stores and view modes.

---

### Wine Task Manager

Accessible from the **in-game sidebar** (three-bar icon) while a game is running. Provides live monitoring and control of the Wine session without leaving the game.

#### Tabs

| Tab | What it shows |
|-----|--------------|
| **Container Info** | CPU cores (WINEMU_CPU_AFFINITY), RAM (/proc/meminfo), VRam (SharedPreferences), device model, Android version |
| **Applications** | All `wine*` host processes with PID — tap any row to kill it |
| **Processes** | All `.exe` guest processes with PID — tap any row to kill it |
| **Launch** | WINEPREFIX file browser — navigate directories (yellow ▶), tap any `.exe / .msi / .bat / .cmd` file (white) to launch it via the Wine binary |

All tabs auto-refresh every 3 seconds. The **Kill** button at the top terminates the selected process immediately.

#### Launch Tab

The Launch tab lets you run additional executables inside an already-running Wine session — useful for launchers, patchers, or tools that the game itself doesn't start. The browser starts at `dosdevices/` in the WINEPREFIX and drills down from there.

A launch guard prevents Wine's "session complete" callback from tearing down the active game session when the secondary executable closes. The guard is released automatically 3 seconds after the secondary process exits.

---

### Component Descriptions in Game Settings

When selecting a component in per-game settings (DXVK, VKD3D, Box64, FEXCore, or GPU Driver picker), components installed via BannerHub show their **description text** below the component name. The description is read from `profile.json` (WCP files) or `meta.json` (ZIP / adrenotools) at inject time and stored alongside the component.

---

### Japanese Locale

BannerHub includes a complete **3,468-string Japanese translation** covering every screen in the app. When your Android system language is set to Japanese, the app displays fully in Japanese. English users are unaffected — Android's locale fallback uses the default English strings automatically.

*Translation contributed by [reindex-ot](https://github.com/reindex-ot) via Crowdin (GameHub's official translation source).*

---

---

### Virtual Container Cleanup on Uninstall

When a game is installed and launched, GameHub creates a Wine virtual container at `virtual_containers/{gameId}/` to hold the game's Windows environment. BannerHub ensures this container directory is fully cleaned up when the game is uninstalled, preventing orphaned containers from accumulating on disk over time.

### UI Tweaks

- The **"My"** tab in the bottom navigation bar is renamed to **"My Games"** for clarity.
- **Beacon launch no longer creates a second app entry in recents** — `GameDetailActivity` is marked `excludeFromRecents`, so Beacon launches do not leave an orphaned BannerHub task in the recent apps list.
- **System bars hidden across all store screens** — the status bar and navigation bar are hidden on all GOG, Epic, and Amazon screens (store lists, detail pages, download manager, Component Manager, Component Download) so they no longer overlap UI buttons.
- **Uninstall spinner** — a "Uninstalling…" spinner dialog appears immediately after confirming an uninstall, covering the file-deletion delay before the completion toast. Applies to all three stores across game lists, detail pages, and the download manager.

---

## How It Works

1. The original GameHub 5.3.5 ReVanced APK (compiled and patched by [@playday3008](https://github.com/playday3008/gamehub-patches)) is stored as a permanent release asset under the `base-apk` tag in this repo (136 MB).
2. CI downloads the base APK, decompiles it with apktool, and overlays everything in the `patches/` directory — new smali classes, modified smali files, new resource files, and layout edits.
3. apktool rebuilds the APK from the merged source tree.
4. The rebuilt APK is zipaligned and signed with AOSP testkey (v1 + v2 + v3 signatures).
5. The CI matrix builds all 9 package variants in parallel and uploads them to the GitHub Release.

All new BannerHub code lives in `smali_classes16/`. Existing GameHub smali files that needed modification are patched in place. No external dex files are injected — GameHub's own bundled `commons-compress`, `zstd-jni`, and `tukaani xz` libraries are used at runtime.

`smali_classes12` is at the dex method index limit and is never reassembled — the original `classes12.dex` is extracted from the base APK and zip-injected directly after the rebuild step to bypass the limit.

---

## FAQ

**Q: Does BannerHub require root?**

Most features work without root. The only features that require root are the two Performance sidebar toggles (Sustained Performance Mode and Max Adreno Clocks) — both are greyed out and non-interactive on non-rooted devices. All other features — the GOG, Amazon, and Epic Games tabs, Component Manager, component downloader, Winlator HUD, RTS controls, VRAM unlock, core affinity, offline modes, and settings — work on any non-rooted Android device.

**Q: Will this replace my existing GameHub install?**

Only if you choose a matching package APK. The **Normal APK** (`banner.hub`) installs as a completely separate app alongside the official GameHub Lite. The **Normal.GHL APK** (`gamehub.lite`) will replace the official GameHub Lite slot — uninstall it first. All other variant APKs replace their respective GameHub variant slots.

**Q: Can I use BCI (BannersComponentInjector) with BannerHub?**

Yes. BCI grants SAF access to any GameHub package, including `banner.hub`. Components injected via BCI are visible in BannerHub's Component Manager and vice versa. Launch BCI as a standalone app from your device's home screen or app drawer.

**Q: Why does the Max Adreno Clocks toggle require root while some other apps can do it without root?**

BannerHub uses a direct sysfs write to `/sys/class/kgsl/kgsl-3d0/devfreq/min_freq` which is a privileged operation. Some emulators use the KGSL ioctl interface instead, which is accessible to unprivileged apps — but that interface issues a performance hint the driver can still override under thermal pressure. The sysfs approach is a harder lock, at the cost of requiring root.

**Q: My GOG game says "Generation 1" — will it still download?**

Yes. BannerHub supports Gen 1 downloads via the legacy byte-range download pipeline. If your game is so old that it has no content-system builds at all, the installer fallback will download the Windows `.exe` installer directly.

**Q: Where are GOG / Amazon / Epic games installed?**

By default, inside the app's private storage: `Android/data/<package>/files/gog_games/<name>/`, `amazon_games/<name>/`, or `epic_games/<name>/` respectively. If the **Save Store Games to External Storage (SD Card)** toggle is enabled in the side menu settings, games install to `{SD card}/bannerhub/{store}/{game}/` instead. The install path is shown on each game's detail page with a badge indicating whether it is on SD card or internal storage. GOG games have a **Copy to Downloads** button in the detail dialog to copy files to `Downloads/<name>/` for access from any file manager.

**Q: Does Amazon login work with two-factor authentication (OTP)?**

Yes. BannerHub detects the authorization code directly in the redirect URL regardless of which intermediate pages Amazon routes through during OTP/2FA, so login completes correctly with or without 2FA enabled on your account.

---

## BannerHub Lite

**[BannerHub Lite](https://github.com/The412Banner/Bannerhub-Lite)** is a companion project that ports the same BannerHub features into **GameHub Lite 5.1.4** (vanilla, non-ReVanced base). If you are running GameHub Lite rather than GameHub 5.3.5 ReVanced, BannerHub Lite is the correct build to use.

| | BannerHub (this) | BannerHub Lite |
|---|---|---|
| **Base app** | GameHub 5.3.5 — ReVanced | GameHub Lite 5.1.4 — vanilla |
| **APK size** | ~138 MB | ~47 MB |
| **GOG / Amazon / Epic tabs** | Yes | Yes |
| **Component Manager + Downloader** | Yes | Yes |
| **Background download service + Download Manager** | Yes | No |
| **Winlator HUD (Normal + Extra Detailed)** | Yes | Yes |
| **Export / Import Config + Frontend Export** | Yes | Yes |
| **Controller D-pad navigation** | Yes | Yes |
| **Community Game Configs browser** | Yes | No |
| **Component descriptions in picker** | Yes | No |
| **Konkr Style HUD** | Yes | No |
| **RTS Touch Controls** | Patched in | Built into base |
| **GPU System Driver default** | No | Yes |
| **Launch fix (hardware whitelist bypass)** | No | Yes |

Game configs exported from either app are cross-compatible — see [Per-Game Config Export / Import](#per-game-config-export--import).

---

## Implementation Reports

Detailed technical breakdowns of each store integration and feature set — API endpoints, auth flows, data models, download pipelines, and known gotchas.

| Report | Description |
|--------|-------------|
| [GOG_IMPLEMENTATION.md](game-store-reports/GOG_IMPLEMENTATION.md) | GOG API, OAuth2 auth, Gen1/Gen2 depot manifests, download pipeline, cloud saves, DLC, update checker |
| [EPIC_IMPLEMENTATION.md](game-store-reports/EPIC_IMPLEMENTATION.md) | Epic Games Store API, OAuth2 auth, chunked manifest download, CDN selection, cloud saves, free games, DLC |
| [AMAZON_IMPLEMENTATION.md](game-store-reports/AMAZON_IMPLEMENTATION.md) | Amazon Games API, PKCE auth, manifest.proto protobuf, XZ/LZMA decode, FuelPump env vars, SDK DLLs |
| [STEAM_IMPLEMENTATION.md](game-store-reports/STEAM_IMPLEMENTATION.md) | JavaSteam integration, PICS library sync, DepotDownloader, credential + QR auth, depot key caches, critical gotchas |
| [STORE_FEATURES_REPORT.md](game-store-reports/STORE_FEATURES_REPORT.md) | Cross-store feature comparison matrix |

---

## Credits

- **GOG Games integration** — [The GameNative Team](https://github.com/utkarshdalal/GameNative). The GOG API pipeline, authentication flow, download architecture, and library sync in BannerHub are based on their research and implementation.
- **Amazon Games integration** — [The GameNative Team](https://github.com/utkarshdalal/GameNative). The Amazon Games API pipeline, PKCE authentication flow, manifest.proto download architecture, exe scoring heuristic, FuelPump environment variables, and SDK DLL deployment in BannerHub are based on their research and implementation.
- **Epic Games Store integration** — [The GameNative Team](https://github.com/utkarshdalal/GameNative). The Epic Games Store API pipeline, OAuth2 authentication flow, chunked manifest download architecture, CDN selection logic, and chunk assembly in BannerHub are based on their research and implementation.
- **Japanese translations** — [reindex-ot](https://github.com/reindex-ot) via Crowdin
- **RTS Touch Controls** — [@Nightwalker743](https://github.com/Nightwalker743)
- **GameHub ReVanced patches** — [@playday3008](https://github.com/playday3008/gamehub-patches)
- **Winlator HUD** — [StevenMXZ](https://github.com/StevenMXZ). The Extra Detail HUD is a continuation and extension of the original Winlator HUD. Additional metrics were inspired by the built-in performance HUD of my personal device.
- **Component sources** — [Arihany WCPHub](https://github.com/Arihany/WinlatorWCPHub), [The412Banner Nightlies](https://github.com/The412Banner/Nightlies), Kimchi, StevenMXZ, MaxesTechReview, Whitebelyash

---

## Signing

All APKs are signed with AOSP testkey (`testkey.pk8` / `testkey.x509.pem`), v1 + v2 + v3 signatures via apksigner. The testkey is committed to this repository and is the same key used across all builds and all variants.

---

<sub>☕ [Support on Ko-fi](https://ko-fi.com/the412banner)</sub>

