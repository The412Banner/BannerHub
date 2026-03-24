# BannerHub

**GameHub 5.3.5 ReVanced** — extended with a full Component Manager, in-app component downloader, GOG Games tab, in-game performance toggles, RTS touch controls, VRAM unlock, per-game CPU core affinity, root access management, offline Steam launch, and more. Built entirely with apktool smali patching — no source code, no external library injection.

## Video — Installation & Feature Showcase

[![BannerHub Installation & Features](https://img.youtube.com/vi/Vwv8YNnWWdg/maxresdefault.jpg)](https://youtu.be/Vwv8YNnWWdg?si=Ypz66yMU8ZQUngU9)

*Installing the app, installing games, and showcasing all features.*

---

## Table of Contents

- [Installation](#installation)
- [Features](#features)
  - [GOG Games Tab](#gog-games-tab)
  - [Component Manager](#component-manager)
  - [In-App Component Downloader](#in-app-component-downloader)
  - [BCI Launcher Button](#bci-launcher-button)
  - [Performance Sidebar Toggles](#performance-sidebar-toggles)
  - [RTS Touch Controls](#rts-touch-controls)
  - [VRAM Limit Unlock](#vram-limit-unlock)
  - [Per-Game CPU Core Affinity](#per-game-cpu-core-affinity)
  - [PC Game Settings: Offline Mode](#pc-game-settings-offline-mode)
  - [Offline Steam Launch](#offline-steam-launch)
  - [Settings: Advanced Tab](#settings-advanced-tab)
  - [Component Descriptions in Game Settings](#component-descriptions-in-game-settings)
  - [UI Tweaks](#ui-tweaks)
- [How It Works](#how-it-works)
- [FAQ](#faq)
- [Credits](#credits)
- [Signing](#signing)

---

## Installation

Download the APK that matches your existing GameHub package name from the [latest release](https://github.com/The412Banner/bannerhub/releases/latest):

| APK | Package | App Label |
|-----|---------|-----------|
| `BannerHub-vX.Y.Z-Normal.apk` | `banner.hub` | BannerHub |
| `BannerHub-vX.Y.Z-Normal(GHL).apk` | `gamehub.lite` | BannerHub |
| `BannerHub-vX.Y.Z-PuBG.apk` | `com.tencent.ig` | BannerHub PuBG |
| `BannerHub-vX.Y.Z-AnTuTu.apk` | `com.antutu.ABenchMark` | BannerHub AnTuTu |
| `BannerHub-vX.Y.Z-alt-AnTuTu.apk` | `com.antutu.benchmark.full` | BannerHub AnTuTu |
| `BannerHub-vX.Y.Z-PuBG-CrossFire.apk` | `com.tencent.tmgp.cf` | BannerHub PuBG CrossFire |
| `BannerHub-vX.Y.Z-Ludashi.apk` | `com.ludashi.aibench` | BannerHub Ludashi |
| `BannerHub-vX.Y.Z-Genshin.apk` | `com.mihoyo.genshinimpact` | BannerHub Genshin |
| `BannerHub-vX.Y.Z-Original.apk` | `com.xiaoji.egggame` | BannerHub Original |

**Which APK do I need?**

If you do not already have any GameHub variant installed, use the **Normal APK** (`banner.hub`). It installs as a completely separate app alongside the official GameHub Lite — both can coexist. If you already have the official GameHub Lite (`gamehub.lite`) installed and want BannerHub to replace it, use **Normal(GHL)**. If you use a specific GameHub variant for a particular game (e.g. PuBG or Genshin), pick the matching APK so BannerHub replaces that variant's slot.

All 9 variants can be installed simultaneously. All APKs are signed with AOSP testkey (v1/v2/v3).

> **Note:** You must uninstall your existing BannerHub build before installing a new release if the signing certificate changed. Data is not preserved across uninstall.

---

## Features

### GOG Games Tab

Accessible via the left side menu → **GOG**.

For the complete technical implementation breakdown, see [GOG_IMPLEMENTATION.md](GOG_IMPLEMENTATION.md).

#### Authentication

- **OAuth2 login** — a WebView opens GOG's standard OAuth2 authorization page. After you log in, BannerHub captures the authorization code from the redirect URL and exchanges it for an access token + refresh token. Both tokens are stored in the `bh_gog_prefs` SharedPreferences file.
- **Auto token refresh** — before every API call, BannerHub checks the token expiry timestamp. If the token has expired (or will expire within the margin), it silently issues a refresh request using the stored refresh token. You never need to log in again unless you explicitly log out.
- **Login persistence** — your session survives app restarts and device reboots. The token is only cleared if you uninstall or use the Uninstall button.

#### Library

- **Library sync** — on login or manual refresh, BannerHub fetches your full GOG library using the authenticated account API. Both Generation 1 (pre-Galaxy era) and Generation 2 (Galaxy) games are included.
- **Metadata per game** — each library entry includes: title, developer name, description (from the product page), cover image URL, download size, and whether it is a Gen 1 or Gen 2 game.
- **Game cards** — your library is displayed as a scrollable card list. Each card shows:
  - Cover art thumbnail (loaded asynchronously)
  - Game title and developer
  - Gen 1 / Gen 2 badge (orange / light blue)
  - Download size
  - Install / progress / Add button depending on install state

#### Download Pipeline

BannerHub supports both GOG's current and legacy download systems:

**Generation 2 (Galaxy-era games):**

1. Fetches the build manifest from `content-system.gog.com/products/{id}/os/windows/builds`
2. Reads the depot manifest URL from the build record
3. Downloads and parses the depot manifest to get the full file list with CDN paths
4. Downloads each file individually, writing to `filesDir/gog_games/{title}/`
5. Per-file download progress is shown in real time (filename + percentage)

**Generation 1 (pre-Galaxy legacy games):**

1. Fetches builds with `generation=1` parameter
2. Reads the depot manifest, parses `depot.files[]`, skips support-only files
3. Downloads each file using `Range` HTTP requests (byte-range resumable download)
4. Assembles files into the install directory

**Installer fallback (old pre-Galaxy games with no content-system builds):**

Some very old GOG titles pre-date the content-system entirely and return `total_count: 0` for both Gen 1 and Gen 2 builds. For these, BannerHub falls back to the legacy installer download:

1. Calls `api.gog.com/products/{id}?expand=downloads`
2. Reads the `downlink` or `manualUrl` from the downloads object
3. Follows redirects to the final CDN URL
4. Downloads the Windows installer `.exe` directly

#### Install Flow

- Tapping **Install** on a card opens a confirmation dialog showing the download size and available storage — nothing downloads until you confirm.
- A `ProgressBar` + status text replaces the Install button during download, showing the current step (Fetching build info → Fetching manifest → Getting CDN link → Downloading files X% → Assembling → Finishing up → Complete).
- On completion, the progress bar is hidden and an **Add** button appears. Tapping **Add** opens GameHub's `EditImportedGameInfoDialog`, pre-populated with the game's executable path, so you can register it with the launcher in one tap.
- A green **"Installed"** checkmark appears on the card immediately when the download finishes — no app restart needed.

#### Post-Install

- **Persistent install state** — on every app open, BannerHub reads `bh_gog_prefs` for each game card. Cards for already-installed games show the checkmark and Add button automatically, without re-downloading anything.
- **Launch** — the Add button reads the stored executable path from prefs and passes it directly to GameHub's `EditImportedGameInfoDialog`, where you can verify the path and launch the game.
- **Copy to Downloads** — the game detail dialog includes a **Copy to Downloads** button. This recursively copies the entire install directory from `filesDir/gog_games/{dirName}/` to `Downloads/{dirName}/` so the files are accessible from any file manager without root.
- **Uninstall** — the game detail dialog includes an **Uninstall** button. This recursively deletes the install directory, removes all associated prefs keys (`gog_dir_`, `gog_exe_`, `gog_cover_`, `gog_gen_`), and resets the card to its default state. A library re-sync runs automatically after uninstall to rebuild the card list.

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
| **Remove All** | Tap "Remove All" | Removes only BannerHub-managed components (those injected or downloaded via the Component Manager). The confirmation dialog shows the exact count. Stock GameHub components are never touched |

#### Format Support

| Format | Used by | Extraction |
|--------|---------|-----------|
| ZIP (PK magic) | Turnip, adrenotools GPU drivers | Flat extraction — `meta.json` + `.so` files land directly in the component root |
| Zstd-compressed tar (`.wcp`) | DXVK, VKD3D, Box64 | Preserves `system32/` + `syswow64/` internal structure |
| XZ-compressed tar (`.wcp`) | FEXCore nightlies | Flat extraction to component root — FEXCore does not use a `system32/` layout |

BannerHub uses GameHub's own bundled libraries (`commons-compress`, `zstd-jni`, `tukaani xz`) for extraction — no external dependencies are injected, so there are no class loader conflicts.

Before every extraction, the component's destination folder is fully cleared so partial or previous installs cannot corrupt the new one. Extraction always runs on a background thread.

---

### In-App Component Downloader

Inside the Component Manager, tap **Download** at the bottom of the screen to open the **Download Components** browser and install components directly from GitHub without leaving the app.

#### Navigation

Three-level navigation: **Repo** → **Category** → **Asset list**

- **Repo list** — all built-in sources are shown as selectable entries
- **Category list** — after selecting a repo, choose from DXVK, VKD3D, Box64, FEXCore, or GPU Driver
- **Asset list** — shows all available assets for that type in the chosen repo, with file size where available. Assets already installed via BannerHub show a checkmark; the mark clears when the component is removed

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

### BCI Launcher Button

A shortcut button appears in GameHub's **top-right toolbar**. Tapping it opens [BannersComponentInjector](https://github.com/The412Banner/BannersComponentInjector) (`com.banner.inject`) directly from inside BannerHub. If BCI is not installed, a toast message is shown instead.

BCI is a companion app that provides SAF-based component management without root — useful for managing virtual containers, accessing Steam shadercache, and injecting components from your local storage.

---

### Performance Sidebar Toggles

Located in the in-game **Performance sidebar tab**, above the Dual Battery Mode toggle. Both toggles persist their state in `bh_prefs` SharedPreferences and are re-applied automatically every time the Performance sidebar is opened.

Both toggles require root and are greyed out on non-rooted devices. Root access is checked once when you grant it in **Settings → Advanced**. The toggles read that stored result — there is no root permission popup every time the sidebar opens.

> **WARNING — USE AT YOUR OWN RISK**
>
> These toggles override your device's thermal management. Forcing the CPU and GPU to run at maximum frequency continuously generates significantly more heat than normal operation. Sustained high temperatures can cause permanent damage to your device's processor, battery, and other components. Device manufacturers do not support or warrant against damage caused by overriding performance governors. By using these toggles you accept full responsibility for any damage, data loss, throttling, unexpected shutdowns, or reduced component lifespan that results. **Do not leave these enabled unattended. Monitor your device temperature. Disable them immediately if your device becomes uncomfortably hot.**

Both toggles require root. Without root, both are greyed out at 50% opacity and have no click listener — tapping them does nothing.

#### Sustained Performance Mode

**Requires root.**

| | Without root | With root |
|---|---|---|
| **Behavior** | Greyed out, non-interactive | Sets all CPU cores to `performance` governor via `su` |
| **Disable** | N/A | Reverts all CPU cores to `schedutil` governor |

The CPU frequency governor controls how the kernel selects a clock speed for each core. The `performance` governor always selects the maximum available frequency regardless of load, eliminating all downclocking while the toggle is on. On disable, `schedutil` is restored — a load-tracking governor that scales frequency dynamically.

Shell commands issued (with `su`):
```
# Enable
for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo performance > "$f"; done

# Disable
for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo schedutil > "$f"; done
```

#### Max Adreno Clocks

**Requires root.**

| | Without root | With root |
|---|---|---|
| **Behavior** | Greyed out, non-interactive | Locks GPU clock floor = GPU clock ceiling |
| **Disable** | N/A | Removes the floor — DVFS returns to normal |

**What it does (root only):**

Qualcomm Adreno GPUs are managed by the **KGSL** (Kernel Graphics Support Layer) kernel driver. The driver exposes a devfreq interface at `/sys/class/kgsl/kgsl-3d0/devfreq/` that controls dynamic voltage and frequency scaling (DVFS) for the GPU.

BannerHub sets the DVFS **minimum frequency** equal to the current **maximum frequency**, so the GPU has no lower clock level to fall back to:

```sh
# Enable — read max_freq and write it to min_freq
cat /sys/class/kgsl/kgsl-3d0/devfreq/max_freq > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq

# Disable — remove the floor (0 = no minimum constraint)
echo 0 > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
```

This is a **hard kernel-level lock** on the GPU clock floor. Writing to `/sys/class/kgsl/` is a privileged operation — it requires root. This is different from the KGSL ioctl power-constraint approach used by some emulators (e.g. Eden), which is accessible to unprivileged apps but is a hint the driver can override under thermal pressure. BannerHub's sysfs approach sets the floor at the driver level directly — the GPU physically cannot clock below max unless the kernel thermal governor intervenes at an emergency level.

**Why this matters for gaming:**

GPU DVFS is designed for general-use workloads where the GPU idles between frames. In a continuously-rendered 3D game, the DVFS governor can lag behind sudden load spikes — the clock dips, the frame takes longer, you see a stutter. Locking `min_freq = max_freq` eliminates that reaction lag entirely. The tradeoff is increased heat and battery draw since the GPU never idles.

**Use both toggles together** for maximum sustained CPU + GPU performance (requires root on both).

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

#### Gesture Settings

Tap the **gear icon** in the Controls tab to open the gesture settings dialog. From here you can configure the two-finger pan behavior and the pinch-to-zoom scroll direction.

---

### VRAM Limit Unlock

PC game settings → **VRAM Limit** now includes **6 GB, 8 GB, 12 GB, and 16 GB** options in addition to the original GameHub range of 512 MB through 4 GB.

This is useful for games or translation layers (DXVK, VKD3D) that check reported VRAM at startup and limit texture quality or refuse to run if the value is too low for their built-in presets.

---

### Per-Game CPU Core Affinity

PC game settings → **Core Count** has been replaced with a multi-select dialog that lets you choose exactly which CPU cores the game process is pinned to.

#### Core Labels

| Core(s) | Label |
|---------|-------|
| Core 0–3 | Efficiency |
| Core 4–6 | Performance |
| Core 7 | Prime |

Labels reflect the typical cluster naming on Snapdragon SoCs. The exact physical frequency of each core depends on your device.

#### Behavior

- **Apply** — saves the selected core bitmask and updates the settings row label immediately
- **No Limit** — clears affinity, the game process can use any core
- **Cancel** — discards all changes
- Selecting all 8 cores is equivalent to No Limit
- Selecting zero cores shows a warning toast and does not save

This is useful for reserving your high-frequency Performance / Prime cores for the game process and keeping background system load on the Efficiency cores, or vice versa for thermal management.

---

### PC Game Settings: Offline Mode

Opening PC game settings while offline (no network, or airplane mode) no longer blocks the settings menus with a spinner or error screen. Container and component lists fall back to empty data, and all settings rows remain fully accessible and editable without a network connection.

---

### Offline Steam Launch

When the Steam auto-login request fails at cold start and no network is available, BannerHub detects the condition and skips the Steam login screen entirely. The launch pipeline proceeds using the locally cached Steam configuration. This allows you to continue playing your installed Steam library without an internet connection.

---

### Settings: Advanced Tab

The Advanced tab (Settings → Advanced) consolidates several toggles and system-level controls:

| Setting | What it does |
|---------|-------------|
| **EmuReady API** | Toggle EmuReady compatibility checks. Defaults to off on fresh installs to avoid unnecessary network calls |
| **CPU Usage Display** | Show/hide the CPU usage overlay during gameplay |
| **Performance Metrics** | Show/hide the full performance metrics overlay |
| **Sustained Performance Mode** | Toggle for the Sustained Perf feature (same as the sidebar toggle — kept here for convenience outside of a running game) |
| **Grant Root Access** | Opens a 5-point warning dialog explaining what root access is used for. On confirmation, runs `su -c id` on a background thread and stores the result in `bh_prefs`. The Performance sidebar reads this pref to decide whether to enable or grey out the root-dependent toggles — there is no unsolicited root popup every time you open the Performance tab |

---

### Component Descriptions in Game Settings

When selecting a component in per-game settings (DXVK, VKD3D, Box64, FEXCore, or GPU Driver picker), components that were installed via BannerHub now show their **description text** below the component name.

The description is read from `profile.json`'s `"description"` field (WCP files) or `meta.json`'s `"description"` field (ZIP / adrenotools driver packs) at inject time and stored alongside the component. This lets you see version notes, changelog text, or compatibility info directly in the picker without having to look it up externally.

---

### UI Tweaks

- The **"My"** tab in the bottom navigation bar is renamed to **"My Games"** for clarity.

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

Most features work without root. The only features that require root are the two Performance sidebar toggles (Sustained Performance Mode and Max Adreno Clocks) — both are greyed out and non-interactive on non-rooted devices. All other features — the GOG tab, Component Manager, downloader, RTS controls, VRAM unlock, core affinity, offline modes, and settings — work on any non-rooted Android device.

**Q: Will this replace my existing GameHub install?**

Only if you choose a matching package APK. The **Normal APK** (`banner.hub`) installs as a completely separate app alongside the official GameHub Lite. The **Normal(GHL) APK** (`gamehub.lite`) will replace the official GameHub Lite slot — uninstall it first. All other variant APKs replace their respective GameHub variant slots.

**Q: Can I use BCI (BannersComponentInjector) with BannerHub?**

Yes. BCI grants SAF (Storage Access Framework) access to any GameHub package, including `banner.hub`. The BCI launcher button in BannerHub's toolbar opens BCI directly. Components injected via BCI are visible in BannerHub's Component Manager and vice versa.

**Q: Why does the Max Adreno Clocks toggle require root while some other apps can do it without root?**

BannerHub uses a direct sysfs write to `/sys/class/kgsl/kgsl-3d0/devfreq/min_freq` which is a privileged operation. Some emulators use the KGSL ioctl interface (`/dev/kgsl-3d0`) instead, which is accessible to unprivileged apps — but that interface issues a performance hint that the driver scheduler can still override under thermal pressure. The sysfs approach is a harder lock that the GPU cannot override short of a kernel thermal emergency, at the cost of requiring root.

**Q: My GOG game says "Generation 1" — will it still download?**

Yes. BannerHub supports Gen 1 downloads via the legacy byte-range download pipeline. If your game is so old that it has no content-system builds at all (pre-Galaxy era titles), the installer fallback will download the Windows `.exe` installer directly.

**Q: Where are GOG games installed?**

Inside the app's private storage: `Android/data/<package>/files/gog_games/<dirName>/`. The **Copy to Downloads** button in the game detail dialog copies the files to `Downloads/<dirName>/` if you need to access them from a file manager.

---

## Credits

- **GOG Games integration** — [The GameNative Team](https://github.com/utkarshdalal/GameNative). The GOG API pipeline, authentication flow, download architecture, and library sync in BannerHub are based on their research and implementation.
- **RTS Touch Controls** — [@Nightwalker743](https://github.com/Nightwalker743)
- **GameHub ReVanced patches** — [@playday3008](https://github.com/playday3008/gamehub-patches)
- **Component sources** — [Arihany WCPHub](https://github.com/Arihany/WinlatorWCPHub), [The412Banner Nightlies](https://github.com/The412Banner/Nightlies), Kimchi, StevenMXZ, MaxesTechReview, Whitebelyash

---

## Signing

All APKs are signed with AOSP testkey (`testkey.pk8` / `testkey.x509.pem`), v1 + v2 + v3 signatures via apksigner. The testkey is committed to this repository and is the same key used across all builds and all variants.

---

<sub>☕ [Support on Ko-fi](https://ko-fi.com/the412banner)</sub>
