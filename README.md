# BannerHub

**GameHub 5.3.5 ReVanced** — enhanced with a full Component Manager, in-app component downloader with source tracking, in-game Performance toggles, RTS touch controls, VRAM unlock, per-game CPU core affinity, root access management, Steam offline launch, and more. Built with apktool — no root required for most features.

## Video — Installation & Feature Showcase

[![BannerHub Installation & Features](https://img.youtube.com/vi/Vwv8YNnWWdg/maxresdefault.jpg)](https://youtu.be/Vwv8YNnWWdg?si=Ypz66yMU8ZQUngU9)

*Installing the app, installing games, and showcasing all features.*

---

## Features

### Component Manager
Accessible via GameHub's left side menu → **Components**.

- **Card-based RecyclerView UI** — each installed component shown as a compact card with:
  - Color-coded type badge (DXVK / VKD3D / Box64 / FEXCore / GPU Driver / WCP) with matching left accent strip
  - Source badge — components downloaded via BannerHub show the repo name they came from (e.g. "Arihany WCPHub", "Nightlies")
  - Install count badge in the header
- **Live search** — type to filter component cards in real time
- **Swipe LEFT** to remove a component; **Swipe RIGHT** to back it up
- **Add New Component** — inject a WCP or ZIP file as a brand new component slot; it appears in GameHub's DXVK / VKD3D / Box64 / FEXCore / GPU Driver selection menus immediately and persists across restarts
- **Inject file** — replace an existing component's contents with a new WCP or ZIP file
- **Backup** — copies a component folder to `Downloads/BannerHub/{name}/`
- **Remove** — unregisters the component from GameHub's in-memory map and deletes the folder; clears the ✓ downloaded indicator in the online repo list
- **Remove All** — removes only BannerHub-managed components (those injected or downloaded via the Component Manager); shows the correct count in the confirmation dialog
- Supports ZIP (Turnip / adrenotools GPU drivers), zstd tar (DXVK, VKD3D, Box64), and XZ tar (FEXCore nightlies)
- FEXCore: flat extraction to component root; all other types preserve `system32/` + `syswow64/` structure
- Component folder cleared before every inject (no stale files); extraction runs on a background thread

### In-App Component Downloader
Inside the Component Manager, tap **↓ Download from Online Repos** to browse and download components directly from GitHub without leaving GameHub.

- **3-level navigation:** repo → category (DXVK / VKD3D / Box64 / FEXCore / GPU Driver) → filtered asset list
- **✓ downloaded indicator** — assets already installed via BannerHub are marked ✓ in the asset list; the mark clears when the component is removed
- **6 sources built-in:**

| Source | What it provides |
|---|---|
| [**Arihany WCPHub**](https://github.com/Arihany/WinlatorWCPHub) | Curated WCP pack — DXVK, VKD3D, Box64, FEXCore, GPU Drivers |
| [**The412Banner Nightlies**](https://github.com/The412Banner/Nightlies) | Nightly builds — DXVK, VKD3D-Proton, Box64, FEXCore, GPU Drivers |
| **Kimchi GPU Drivers** | GPU Drivers only |
| **StevenMXZ GPU Drivers** | GPU Drivers only |
| **MTR GPU Drivers** | GPU Drivers only (MaxesTechReview) |
| **Whitebelyash GPU Drivers** | GPU Drivers only |

- Tap any asset to download it to cache and inject it as a new component automatically
- **Download progress screen** — while fetching repo metadata or downloading a file, an indeterminate spinner is shown with "Downloading: `<filename>`" status text

### BCI Launcher Button
Tap the icon in GameHub's top-right toolbar to open **BannersComponentInjector** (`com.banner.inject`) directly from inside GameHub. Shows a toast if it is not installed.

### Performance Sidebar Toggles
Two toggles in the in-game **Performance sidebar tab** (above Dual Battery Mode). Both states persist across launches and are re-applied on startup.

| | Sustained Perf (Root+) | Max Adreno Clocks (Root) |
|---|---|---|
| **What it targets** | CPU performance governor | GPU (Adreno/kgsl-3d0) clock speed |
| **No-root support** | ✅ Partial — tries `Window.setSustainedPerformanceMode()` | ❌ None — sysfs write requires root |
| **Root effect** | Sets all CPU cores to `performance` governor | Locks GPU `min_freq = max_freq` (no downclocking) |
| **Disable effect** | Reverts CPU governor to `schedutil` | Resets GPU `min_freq` to 0 |
| **Best for** | CPU-heavy workloads, frame time spikes | GPU-heavy games, GPU clock dips |
| **Without root** | Greyed out — non-interactive | Greyed out — non-interactive |

Use both together for maximum sustained performance (requires root).

### RTS Touch Controls
*Thanks to [@Nightwalker743](https://github.com/Nightwalker743) for making this possible!*

Enable via **Settings → Controls tab** in the in-game sidebar. Adds a full gesture overlay for PC and RTS games:

- **Tap to click** — moves cursor and left-clicks at tap position
- **Drag for box selection** — holds LMB while dragging to draw a selection box
- **Long press for right-click** — 300ms hold triggers right-click
- **Double-tap for double-click** — two taps within 250ms / 50px
- **Two-finger pan** — camera pan (configurable)
- **Pinch-to-zoom** — mouse wheel scroll (configurable)
- **Gesture settings dialog** — tap the gear icon in the Controls tab to customize two-finger and pinch actions

### VRAM Limit Unlock
PC game settings → **VRAM Limit** now includes 6 GB, 8 GB, 12 GB, and 16 GB options in addition to the original 512 MB–4 GB range.

### Per-Game CPU Core Affinity
PC game settings → **Core Count** opens a multi-select dialog to choose exactly which CPU cores a game may use.

- 8 cores listed individually: Core 0–3 (Efficiency), Core 4–6 (Performance), Core 7 (Prime)
- **Apply** saves the selected core bitmask; **No Limit** clears affinity; **Cancel** discards
- Selecting all 8 cores = No Limit; selecting none shows a warning toast
- Settings row label refreshes immediately after any change

### PC Game Settings: Offline Mode
Opening PC game settings while offline no longer blocks the menus. Container and component lists fall back to empty data so the UI remains fully usable without a network connection.

### Offline Steam Launch
When autoLogin fails and no network is available at cold start, the Steam login screen is skipped and the launch pipeline proceeds using cached config.

### Settings → Advanced
- EmuReady API toggle (defaults off on fresh installs)
- CPU Usage display toggle
- Performance Metrics toggle
- Sustained Performance Mode toggle
- **Grant Root Access** — tapping this button shows a 5-point warning dialog; on confirmation it runs `su -c id` on a background thread and stores the result in `bh_prefs`. Performance toggles read this preference on sidebar open — no more unsolicited root popup every time the Performance tab is opened.

### Component Descriptions in Game Settings Picker
When selecting a component (DXVK / VKD3D / Box64 / FEXCore / GPU Driver) in per-game settings, locally installed components now show their description text below the name. The description comes from `profile.json`'s `"description"` field (WCP) or `meta.json`'s `"description"` field (ZIP / adrenotools), stored at inject time.

### UI Tweaks
- "My" tab renamed to **"My Games"**

---

## Installation

Download the APK matching your existing GameHub package from the [latest release](https://github.com/The412Banner/bannerhub/releases/latest):

| APK | Package | App Label |
|-----|---------|-----------|
| `BannerHub-vX.Y.Z-Normal.apk` | `banner.hub` | BannerHub |
| `BannerHub-vX.Y.Z-PuBG.apk` | `com.tencent.ig` | BannerHub PuBG |
| `BannerHub-vX.Y.Z-AnTuTu.apk` | `com.antutu.ABenchMark` | BannerHub AnTuTu |
| `BannerHub-vX.Y.Z-alt-AnTuTu.apk` | `com.antutu.benchmark.full` | BannerHub AnTuTu |
| `BannerHub-vX.Y.Z-Ludashi.apk` | `com.ludashi.aibench` | BannerHub Ludashi |
| `BannerHub-vX.Y.Z-Genshin.apk` | `com.mihoyo.genshinimpact` | BannerHub Genshin |
| `BannerHub-vX.Y.Z-Original.apk` | `com.xiaoji.egggame` | BannerHub Original |

The **Normal APK** uses package `banner.hub` — it installs alongside the original GameHub without replacing it. All 7 variants can be installed simultaneously without conflicts. All APKs are signed with AOSP testkey (v1/v2/v3).

> **Note:** You must uninstall any previous BannerHub build before installing a new one if the signing certificate changed.

---

## Credits

- **RTS Touch Controls** — [@Nightwalker743](https://github.com/Nightwalker743)
- **GameHub ReVanced patches** — [@playday3008](https://github.com/playday3008/gamehub-patches)
- **Component sources** — [Arihany WCPHub](https://github.com/Arihany/WinlatorWCPHub), [The412Banner Nightlies](https://github.com/The412Banner/Nightlies), Kimchi, StevenMXZ, MaxesTechReview, Whitebelyash *(links TBD)*

---

## How It Works

1. The original GameHub 5.3.5 ReVanced APK (patched by [@playday3008](https://github.com/playday3008/gamehub-patches)) is stored as a release asset under the `base-apk` tag (136 MB).
2. CI downloads it, decompiles with apktool, overlays everything in `patches/`, rebuilds, zipaligns, and signs.
3. The rebuilt APKs are uploaded as GitHub Release assets.

No external library injection — the Component Manager uses GameHub's own bundled libraries (commons-compress, zstd-jni, tukaani xz) via their runtime signatures.

---

## Signing

Signed with AOSP testkey (`testkey.pk8` / `testkey.x509.pem`), v1 + v2 + v3 signatures.

---
<sub>☕ [Support on Ko-fi](https://ko-fi.com/the412banner)</sub>
