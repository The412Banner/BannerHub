# BannerHub Progress Log

Tracks every commit, patch, and change applied to the GameHub 5.3.5 ReVanced APK rebuild.

---

## [ci] — post-v2.3.0 — CI fixes + CrossFire variant + pre/beta isolation (2026-03-15)
**Commits:** `78c6aae` (manifest fix), `ce0dcda` (CrossFire + workflow), `f12ea94` (pre/beta package)

### What changed
- **Manifest package conflict fix** — replaced two targeted seds with a single global `sed -i "s/gamehub\.lite/$PKG/g"` on AndroidManifest.xml for all non-Normal variants in `build.yml`. Fixes install conflicts with GameHub Lite 5.1.4 caused by `gamehub.lite.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` custom permission declaration colliding with differently-signed installs
- **8th APK variant added** — `Bannerhub-5.3.5-Revanced-PuBG-CrossFire.apk` (`com.tencent.tmgp.cf`, label "GameHub Revanced PuBG CrossFire") added to `build.yml` matrix; enables frame generation on Vivo phones running OriginOS 6 China ROM
- **`build-crossfire.yml`** — new standalone `workflow_dispatch` workflow that builds only the CrossFire APK and uploads it directly to the v2.3.0 release
- **Pre/beta package isolation** — `build-quick.yml` now patches package name to `banner.hub` for all pre-release and beta builds, preventing accidental overwrites of stable installs
- **v2.3.0 APKs rebuilt** — all 7 (now 8) APKs re-uploaded to v2.3.0 release with the manifest fix applied; release description updated with CrossFire entry and Vivo OriginOS 6 framegen note

### Files touched
- `.github/workflows/build.yml` — global manifest sed + CrossFire matrix entry
- `.github/workflows/build-crossfire.yml` (new)
- `.github/workflows/build-quick.yml` — banner.hub package for pre/beta

---

## [beta] — v2.3.1-beta1 — In-app component downloader (2026-03-15)
**Commit:** `1cdc468`  |  **Tag:** v2.3.1-beta1  |  **CI run:** `23120730562` (Normal APK only)

### What changed
- "↓ Download from Nightlies" entry added to Component Manager type-selection menu (Add New Component flow)
- Tapping it opens ComponentDownloadActivity: fetches GitHub Releases API, lists latest nightly .wcp/.zip/.xz assets
- Tap any asset → downloads to cacheDir → calls ComponentInjectorHelper.injectComponent → toast result + finish
- Type auto-detected from filename: box64→94, fex→95, vkd3d→13, turnip/adreno/driver→10, default=dxvk→12

### Files touched
- `patches/smali_classes16/.../ComponentManagerActivity.smali` — showTypeSelection (6→7 items), onItemClick mode=2 (position 0 launches downloader)
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` (new)
- `patches/smali_classes16/.../ComponentDownloadActivity$1.smali` (new — FetchRunnable)
- `patches/smali_classes16/.../ComponentDownloadActivity$2.smali` (new — ShowListRunnable)
- `patches/smali_classes16/.../ComponentDownloadActivity$3.smali` (new — DownloadRunnable)
- `patches/smali_classes16/.../ComponentDownloadActivity$4.smali` (new — CompleteRunnable)
- `patches/AndroidManifest.xml` — registered ComponentDownloadActivity

---

## [stable] — v2.3.0 — Stable release (2026-03-15)
**Commit:** `cdb1f06`  |  **Tag:** v2.3.0  |  **CI run:** `23118528237` (~22min ✓)

### What changed (new since v2.2.4)
- True component injection into GameHub menus (Add New Component flow)
- FEXCore resilience on missing/corrupt profile.json
- ZIP injection: folder name + libraryName fixes
- Remove option in Component Manager
- RTS gesture dialog shrunk ~20%, close button fixed (nav bar overlap)
- EmuReady API toggle defaults to off
- 7th APK variant: Bannerhub-5.3.5-Revanced-Original.apk (com.xiaoji.egggame)
- README rewritten with full feature set and 7-variant install table

### Files touched
- All patches from v2.2.5-pre through v2.2.11-pre
- `.github/workflows/build.yml` (7th variant)
- `README.md`

---

## [pre] — v2.2.11-pre — Default EmuReady API toggle to off (2026-03-15)
**Commit:** `bc457d8`  |  **Tag:** v2.2.11-pre  |  **CI run:** `67140309487` (3m42s ✓)

### What changed
- `GameHubPrefs.isExternalAPI()` called `getBoolean("use_external_api", true)` — default was `true`
- Changed default to `false` (`0x1` → `0x0`) so the EmuReady API toggle is off on fresh installs
- Users who already have a saved value in SharedPrefs are unaffected

### Files touched
- `patches/smali_classes6/app/revanced/extension/gamehub/prefs/GameHubPrefs.smali` (new)

---

## [pre] — v2.2.10-pre — Fix Close button unreachable behind nav bar (2026-03-15)
**Commit:** `626c9d0`  |  **Tag:** v2.2.10-pre  |  **CI run:** `23115230824` (3m45s ✓)

### What changed
- Added `android:paddingBottom="56dp"` to the root `FrameLayout` in `rts_gesture_config_dialog.xml`
- Root cause: GameHub runs in immersive mode (window extends behind nav bar); `layout_gravity="center"` was centering the dialog in the full window area, placing the Close button behind the navigation bar where touches are intercepted by the system
- Fix ensures the dialog centers within the usable screen area, keeping the Close button tappable

### Files touched
- `patches/res/layout/rts_gesture_config_dialog.xml`

---

## [pre] — v2.2.9-pre — Shrink RTS gesture settings dialog ~20% (2026-03-15)
**Commit:** `bb3d420`  |  **Tag:** v2.2.9-pre  |  **CI run:** `23114552262` (3m41s ✓)

### What changed
- All 6 gesture rows: 48dp → 38dp height
- Close button: 44dp → 35dp height
- Top margins and bottom padding trimmed proportionally (14→11dp, 16→12dp)
- Fixes navigation bar and status bar overlapping the dialog and blocking buttons

### Files touched
- `patches/res/layout/rts_gesture_config_dialog.xml`

---

## [pre] — v2.2.8-pre — Add Remove option to Component Manager (2026-03-15)
**Commit:** `5b39138`  |  **Tag:** v2.2.8-pre  |  **CI run:** `23114139058` (3m41s ✓)

### What changed
- Added "Remove" to the per-component options menu (between Backup and Back)
- Tapping Remove unregisters the component from `EmuComponents` in-memory HashMap, recursively deletes its folder from `components/`, shows "Removed: <name>" toast, returns to list
- New `removeComponent()V` method and `deleteDir(File)V` static recursive helper

### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

---

## [pre] — v2.2.7-pre — ZIP injection fixes: name/dir mismatch + libraryName rename (2026-03-15)
**Commit:** `fd5e176`  |  **Tag:** v2.2.7-pre  |  **CI:** ✅

### What changed
- ZIP name/dir mismatch fixed: folder name is always the ZIP filename, `meta.json["name"]` no longer overwrites it
- Wrong `.so` name fixed: reads `meta.json["libraryName"]` after extraction and renames to `libvulkan_freedreno.so` if different
- Title TextView and system bar padding confirmed working

### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali`
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

---

## [pre] — v2.2.6-pre — Component menu visibility + FEXCore resilience (2026-03-15)
**Commit:** `00a324a`  |  **Tag:** v2.2.6-pre  |  **CI run:** `23102478881` (3m37s ✓)

### What changed
- **ComponentInjectorHelper — FEXCore fallback**: When `readWcpProfile` returns null
  (XZ decompression fails or no `profile.json`), injection no longer aborts. Instead
  falls back to filename-derived name and continues to folder creation + extraction.
- **ComponentInjectorHelper — state fix**: `registerComponent` now uses
  `LState;->Extracted:LState;` instead of `LState;->INSTALLED:LState;`. This makes
  `EmuComponents.isComponentNeed2Download()` return false immediately so GameHub won't
  try to re-download the component from an empty URL.
- **ComponentInjectorHelper — appendLocalComponents**: New static method
  `appendLocalComponents(List<DialogSettingListItemEntity>, int contentType)` that
  iterates the EmuComponents HashMap and appends locally installed components matching
  the queried content type. `TRANSLATOR(32)` also matches `BOX64(94)` and `FEXCORE(95)`.
- **GameSettingViewModel$fetchList$1 — inject call**: Two lines added just before the
  server callback is invoked — reads `$contentType` from the coroutine state, calls
  `appendLocalComponents(v7, contentType)`. Injected DXVK/VKD3D/GPU/Box64/FEXCore
  components now appear alongside server results in every selection dialog.

### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali`
- `patches/smali_classes3/com/xj/winemu/settings/GameSettingViewModel$fetchList$1.smali` (new)

---

## [pre] — v2.2.5-pre — True component injection into GameHub menus (2026-03-14)
**Commit:** `e7dd944`  |  **Tag:** v2.2.5-pre

### What changed
- **ComponentManagerActivity**: prepended "+ Add New Component" at index 0 of the
  component list. Added `selectedType:I` field. New mode=2 type-selection screen shows
  DXVK / VKD3D-Proton / Box64 / FEXCore / GPU Driver Turnip / ← Back. mode=3 launches
  file picker for the new inject flow. `onActivityResult` branches mode=3 →
  ComponentInjectorHelper (new inject), mode=1 → existing replace flow unchanged.
- **ComponentInjectorHelper** (new file): static helper class. Detects WCP (Zstd
  magic 0x28 / XZ magic 0xFD) or ZIP (0x50) from first byte. For WCP: reads
  `profile.json` in a first pass to get `versionName`; creates a new folder under
  `components/` named after versionName; extracts files (FEXCore: flat extraction;
  all others: preserve `system32/`/`syswow64/` structure). For ZIP: flat extraction +
  parses `meta.json` for name/description. Constructs `EnvLayerEntity` + `ComponentRepo`
  with `state=INSTALLED` and registers via `EmuComponents.D()` so the component
  appears in GameHub's in-app selection menus immediately — no existing component replaced.

### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali` (new)

---

## v2.2.4 — stable release (2026-03-15)
**Commit:** `1968948` | **Tag:** `v2.2.4`

### What changed
- Promoted v2.2.4-pre to stable.
- Added 6th APK variant: `Bannerhub-5.3.5-Revanced-alt-AnTuTu.apk` (`com.antutu.benchmark.full`)
- Release description covers new since v2.2.3 + full feature set + installation table (6 APKs).
- README updated: alt-AnTuTu row added to install table, Offline Steam Launch section added.

### Files touched
- `.github/workflows/build.yml`
- `README.md`
- `PROGRESS_LOG.md`

---

## ci — add quick build workflow for pre/beta tags (2026-03-14)
**Commit:** `4e0e510` | **Tag:** none

### What changed
- Added `.github/workflows/build-quick.yml`: triggers on `v*-pre*` and `v*-beta*` tags;
  builds only the Normal (gamehub.lite) APK — 1 build instead of 5.
- Updated `build.yml` to exclude `v*-pre*` and `v*-beta*` tags so both workflows
  don't run simultaneously on pre/beta pushes. Stable `v*` tags still build all 5 APKs.

### Files touched
- `.github/workflows/build-quick.yml` (new)
- `.github/workflows/build.yml` (tag filter updated)

---

## v2.2.4-pre — feat: skip Steam login screen when offline at cold start (2026-03-14)
**Commit:** `b16848f` | **Tag:** `v2.2.4-pre`

### What changed
- Patched `SteamGameByPcEmuLaunchStrategy$execute$3.smali` to skip the Steam login
  screen when there is no network connection at cold start.
- When autoLogin fails AND network is unavailable (`NetworkUtils.r()` == false),
  the login screen is bypassed and the game launch pipeline proceeds with cached config.
- When autoLogin fails AND network IS available, login screen shown as normal.
- Developed on `beta` branch as `v2.2.4-beta1`, confirmed working, merged to main.

### Files touched
- `patches/smali_classes10/com/xj/landscape/launcher/launcher/strategy/SteamGameByPcEmuLaunchStrategy$execute$3.smali` (new)

---

## v2.2.3 — stable release (2026-03-14)
**Commit:** `580fb60` | **Tag:** `v2.2.3`

### What changed
- Promoted v2.2.3-pre to stable.
- Release description covers new fixes since v2.2.2 + full feature set + installation table.

---

## v2.2.3-pre — fix: RTS gesture settings dialog crash + cog icon (2026-03-14)
**Commit:** `580fb60` | **Tag:** `v2.2.3-pre`

### What changed
- `rts_gesture_config_dialog.xml`: replaced all 3 `com.hjq.shape.view.ShapeTextView` elements
  with plain `TextView` using `android:background` inline colors.
  ShapeTextView is from the HJQ library, which is not in GameHub 5.3.5 — caused
  `ClassNotFoundException` at inflate time → app crash on every cog tap.
  Spinners (`rts_gesture_pinch_spinner`, `rts_gesture_two_finger_spinner`): `android:background="#1affffff"`.
  Close button (`tvClose`): `android:background="#ff3b82f6"`.
- `winemu_sidebar_controls_fragment.xml`: replaced `@drawable/ic_settings` with
  `@drawable/winemu_ic_setting_focus_white` so the gear button is visibly white on the dark sidebar.

### Files touched
- `patches/res/layout/rts_gesture_config_dialog.xml`
- `patches/res/layout/winemu_sidebar_controls_fragment.xml`

---

## v2.2.2 — feat: per-variant display labels + full release notes (2026-03-14)
**Commit:** `8f435ce` (code), `cc06d32` (docs) | **Tag:** `v2.2.2`

### What changed
- Each APK variant now sets its own `android:label` in AndroidManifest before rebuild
  - Normal → "GameHub Revanced", PuBG → "GameHub Revanced PuBG", AnTuTu → "GameHub Revanced AnTuTu", Ludashi → "GameHub Revanced Ludashi", Genshin → "GameHub Revanced Genshin"
- Release description updated with full app feature set + credits to @Nightwalker743 for RTS controls
- README updated: credit link, display name column in install table, asterisk note on configurable gestures

### Files touched
- `.github/workflows/build.yml`
- `README.md`
- `PROGRESS_LOG.md`

---

## v2.2.1 — feat: RTS touch controls (2026-03-14)
**Commit:** `b1a0945` | **Tag:** `v2.2.1`

### What changed
- Ported RTS touch controls from gamehub-lite PR #73 (Nightwalker743) to bannerhub's 5.3.5 ReVanced base
- All smali class numbers corrected (5.1.0 classes4/5 → 5.3.5 classes9/14/15/16)
- Obfuscated method names hand-mapped for 5.3.5 throughout
- `shape_radius`/`shape_solidColor` XML attributes renamed to `xj_shape_radius`/`xj_shape_solidColor` for 5.3.5 compat
- Added `CloudProgressStyle` stub to satisfy aapt2 strict link validation triggered by new layout files
- Removed WinUIBridge.smali replacement to avoid classes9.dex 65535 reference overflow
- New files placed in smali_classes16 (free slot)

### Features added
- Tap to click, drag for box selection, long press right-click, double-tap double-click
- Two-finger pan for camera, pinch-to-zoom (mouse wheel)
- Toggle switch in Settings > Controls tab (in-game sidebar)
- Gesture settings dialog with configurable action picker

### Files touched
- `patches/smali_classes14/com/xj/winemu/sidebar/SidebarControlsFragment.smali`
- `patches/smali_classes15/com/xj/winemu/WineActivity.smali`
- `patches/smali_classes15/com/xj/pcvirtualbtn/inputcontrols/InputControlsManager.smali`
- `patches/smali_classes15/com/winemu/core/controller/X11Controller.smali`
- `patches/smali_classes16/` — 16 new RTS smali files
- `patches/res/layout/` — 4 layout files (winemu_sidebar_controls_fragment + 3 RTS dialogs)
- `patches/res/drawable/`, `patches/res/color/` — RTS checkbox/dialog drawables
- `patches/res/values/ids.xml`, `strings.xml`, `styles.xml`, `public.xml`
- `README.md`

---

## Session 6 — 2026-03-13

### [planned] — Backlog / Upcoming Work
Items identified from code review — prioritized by impact:

#### 1. Confirm before inject ⚠️ (high priority — data safety)
- `injectFile()` wipes the entire component folder before extracting — no warning given
- Add an `AlertDialog` on "Inject file..." tap: "Replace contents of [component]? This cannot be undone."
- Only proceed to `pickFile()` if user confirms

#### 2. Back + Exit buttons (pending from previous session)
- Add a horizontal button row below the title header, above the ListView
- **Back** — navigates up one level (options → components) or closes the activity if already at root
- **Exit** — always calls `finish()` to close the activity immediately
- Buttons should be outside the list, not list items

#### 3. "Injecting..." progress toast at thread start
- Currently no visual feedback between file pick and success/fail toast
- Post a "Injecting, please wait..." toast to the UI thread at the top of `$1.run()` before calling `WcpExtractor.extract()`
- Prevents users from thinking the app froze on large WCP files

#### 4. Sort components alphabetically
- `listFiles()` returns folders in filesystem order (non-deterministic)
- Add `Arrays.sort()` on the components `File[]` before building the display name array
- One-line change in `showComponents()`

#### 5. Clear label option in options menu
- No way to remove a `[-> filename]` SharedPreferences label once set
- Add a 4th item "Clear label" to `showOptions()` that removes the key from `bh_injected` SharedPreferences
- Handle `pswitch_3` in `onItemClick()` packed-switch

#### 6. Component count in title
- Update the title `TextView` text after components are loaded: "Banners Component Injector (N)"
- Requires storing a reference to the title `TextView` as an activity field so `showComponents()` can update it

---

## Session 5 — 2026-03-12

### [stable] — v2.2.0 — Stable release: Multi-APK Builds & AOSP Testkeys (2026-03-12)
**Tag:** `v2.2.0`
#### What changed
- Promoted v2.1.2-pre fixes to stable.
- Build workflow updated to sign all APKs using standard AOSP `testkey` (v1, v2, and v3 signatures enabled) instead of the local debug keystore.
- Build workflow now automatically builds 5 separate APKs per run, each with a unique package name injected into its `AndroidManifest.xml` and `android:authorities` to prevent conflicts.
- Available APKs/Packages:
  - `Bannerhub-5.3.5-Revanced-Normal.apk` (`gamehub.lite`)
  - `Bannerhub-5.3.5-Revanced-PuBG.apk` (`com.tencent.ig`)
  - `Bannerhub-5.3.5-Revanced-AnTuTu.apk` (`com.antutu.ABenchMark`)
  - `Bannerhub-5.3.5-Revanced-Ludashi.apk` (`com.ludashi.aibench`)
  - `Bannerhub-5.3.5-Revanced-Genshin.apk` (`com.mihoyo.genshinimpact`)
#### Files touched
- `.github/workflows/build.yml`
- `testkey.pk8`, `testkey.x509.pem` (added)

---

## Session 4 — 2026-03-12

### [patch] — v2.1.2-pre — Show last injected filename per component (2026-03-12)
**Commit:** `cc31765` (fix) / `0070548` (initial, failed build) | **Tag:** v2.1.2-pre ✅
#### What changed
- After a successful inject, the component list row shows `"ComponentName [-> filename.wcp]"`
- Label persists across app restarts via SharedPreferences (`"bh_injected"` prefs file, keyed by component folder name)
- Updates each time a new file is injected into that component
#### Implementation
- New `getFileName(Uri)String` method on activity — queries `_display_name` via `ContentResolver` using `invoke-virtual/range` for the 6-register query call
- `$1.run()` calls `this$0.getFileName(val$uri)` on extract success, then saves `componentDir.getName() → filename` to SharedPreferences before posting the success runnable
- `showComponents()` reads SharedPreferences before the name loop; builds `"name [-> filename]"` string with StringBuilder if key is present, plain name otherwise. `.locals 9` → `.locals 11`
#### Build notes
- First attempt (`0070548`) failed: `invoke-direct {v1, p0, p1, v0, v2, v4}` — 6 registers exceeds invoke-direct max of 5. Fixed by keeping $1 constructor at 4 args and calling `getFileName()` from inside `$1.run()` instead.
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1.smali`

---

## Session 3 — 2026-03-12

### [revert] — Reverted to v2.1.1; removed v2.1.2 release and tag
**Commit:** `6b9195d` | **Tag:** v2.1.1 (current stable)
#### What changed
- v2.1.2 patch (inject label display) reverted — hard reset to `6b9195d`
- v2.1.2 GitHub release deleted, remote and local tag removed
- Repo back to v2.1.1 as latest

---

### [patch] — Add "Banners Component Injector" title header to all Component Manager menus
**Commit:** `6b9195d` | **Tag:** v2.1.1 ✅
#### What changed
- Users were having trouble tapping top list items in the Component Manager — the list started at the very top of the screen
- Wrapped the raw `ListView` content view in a vertical `LinearLayout`
- Added a `TextView` at the top: text "Banners Component Injector", 20sp, centered, 48px padding all sides
- `ListView` given `LinearLayout.LayoutParams(MATCH_PARENT, 0dp, weight=1)` so it fills remaining space
- Title persists across both the components list view and the options menu (Inject / Backup / Back) — no changes needed to `showComponents()` or `showOptions()`
- `onCreate` `.locals` bumped from 2 to 6 for the new registers
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

---

## Session 2 — 2026-03-12

### [stable] — v2.1.0 — Stable release: WCP extraction fully working (2026-03-12)
**Commit:** `de48d63` (README) | **Tag:** `v2.1.0`
#### What changed
- Promoted v2.0.6-pre fixes to stable
- All three injection paths now work: ZIP (Turnip/adrenotools), zstd WCP (DXVK/VKD3D/Box64/FEXCore), XZ WCP (FEXCore nightlies)
- README rewritten to accurately describe all features, installation, and architecture
#### Files touched
- `README.md`

---

## Session 1 — 2026-03-12

### [init] — Initial repo setup
**Commit:** `78c525c` | **Tag:** none
#### What changed
- Created GitHub repo `The412Banner/bannerhub`
- Built apktool-based rebuild workflow: downloads base APK → decompile → overlay `patches/` → rebuild → sign → release
- Generated debug keystore (`keystore.jks`, alias: `bannerhub`, pw: `bannerhub123`)
- Uploaded original `Gamehub-5.3.5-Revanced-Normal.apk` as `base-apk` release asset (136MB)
- `.gitignore` excludes `apktool_out/`, `jadx_out/`, `base/`, rebuilt APKs
#### Files touched
- `.github/workflows/build.yml`
- `keystore.jks`
- `patches/.gitkeep`
- `.gitignore`, `README.md`

---

### [fix] — Workflow: apktool permission denied
**Commit:** `0068e4e` | **Tag:** v1.0.1 (failed build)
#### What changed
- apktool jar was being written to `/usr/local/lib/` which is read-only on GitHub runners
- Changed to `$HOME/bin/` for both the jar and wrapper script
- Switched from `apktool` wrapper to `java -jar apktool.jar` calls directly
#### Files touched
- `.github/workflows/build.yml`

---

### [fix] — Workflow: raws.xml aapt2 compile error
**Commit:** `fb55474` | **Tag:** v1.0.2 (failed build)
#### What changed
- `res/values/raws.xml` contains Firebase boolean entries (`firebase_common_keep`, `firebase_crashlytics_keep`) that aapt2 rejects — expects file references, not boolean values
- Added workflow step to `rm -f apktool_out/res/values/raws.xml` after decompile
#### Files touched
- `.github/workflows/build.yml`

---

### [fix] — Workflow: dangling public.xml firebase symbols
**Commit:** `415a2b1` | **Tag:** v1.0.3 ✅ **FIRST SUCCESSFUL BUILD**
#### What changed
- Deleting `raws.xml` left `public.xml` declaring those symbols → aapt2 "no definition for declared symbol" error
- Added `sed -i '/firebase_common_keep\|firebase_crashlytics_keep/d' apktool_out/res/values/public.xml` to workflow after the raws.xml deletion
- **Build succeeded** — `Gamehub-rebuilt.apk` produced and uploaded to v1.0.3 release
#### Files touched
- `.github/workflows/build.yml`

---

### [patch] — Rename "My" tab to "My Games"
**Commit:** `6433837` | **Tag:** v1.0.0 (preceded fix commits, rolled into v1.0.3 build)
#### What changed
- String key `llauncher_main_page_title_my` changed from `"My"` to `"My Games"`
- Affects the top toolbar tab label in the main launcher screen
#### Files touched
- `patches/res/values/strings.xml` (line 1410)

---

### [patch] — Add BCI launcher button to top bar
**Commit:** `b148ee2` | **Tag:** v1.0.4 (failed — firebase regression)
#### What changed
- Added a small "open in new" icon button (`iv_bci_launcher`) to the top-right toolbar, after the search icon
- Tapping it launches BannersComponentInjector (`com.banner.inject`) if installed
- If BCI is not installed, shows a Toast: "BannersComponentInjector is not installed"
- New smali class `BciLauncherClickListener` handles the click logic
- Button wired in `LandscapeLauncherMainActivity.initView()` via `findViewById` + `setOnClickListener`
- New resource ID `iv_bci_launcher` = `0x7f0a0ef9`
#### Files touched
- `patches/res/layout/llauncher_activity_new_launcher_main.xml` — added ImageView
- `patches/res/values/ids.xml` — added `iv_bci_launcher` entry
- `patches/res/values/public.xml` — added public ID `0x7f0a0ef9`
- `patches/smali_classes9/com/xj/landscape/launcher/R$id.smali` — added field
- `patches/smali_classes11/com/xj/landscape/launcher/ui/main/BciLauncherClickListener.smali` — new file
- `patches/smali_classes11/com/xj/landscape/launcher/ui/main/LandscapeLauncherMainActivity.smali` — initView hook

---

### [fix] — patches/public.xml reintroduced firebase symbols
**Commit:** `c30103f` | **Tag:** v1.0.5 (in progress)
#### What changed
- The `patches/res/values/public.xml` overlay was overwriting the workflow-cleaned version, putting firebase entries back
- Removed `firebase_common_keep` and `firebase_crashlytics_keep` lines from `patches/public.xml`
- **Rule going forward:** Any patch that includes `public.xml` or touches resource files must also not contain the two firebase raw entries
#### Files touched
- `patches/res/values/public.xml`

---

## Known Issues / Notes

- **firebase raws rule:** Never include `firebase_common_keep` or `firebase_crashlytics_keep` entries in any patched `public.xml` — they have no corresponding raw file and aapt2 will reject the build
- **Signing:** Debug key only (`keystore.jks`). Must uninstall existing GameHub before sideloading rebuilt APK (signature mismatch)
- **Base APK:** `Gamehub-5.3.5-Revanced-Normal.apk` stored in `base-apk` release — do not delete
- **apktool version:** 2.9.3 (pinned in workflow)
- **DataBinding note:** The main launcher uses DataBinding. New views added via layout XML patches can be wired via `getMDataBind().getRoot().findViewById()` in `initView` without touching the binding impl classes

### [release] — v1.0.5 marked as stable release
**Commit:** `dad069f` | **Tag:** v1.0.5 ✅ **STABLE**
#### What changed
- v1.0.5 build succeeded and promoted to stable release
- Release description written covering all applied patches: "My Games" tab rename + BCI launcher button
- Progress log added to repo

---

### [patch] — Option B: Embedded Component Manager in side menu
**Commit:** `d2f17e9` | **Tag:** v1.0.6 (failed — dex index overflow)
#### What changed
- Added "Components" item (ID=9) to `HomeLeftMenuDialog` side nav menu
- Extended packed-switch table in `HomeLeftMenuDialog.o1()` to handle ID 9 → launches `ComponentManagerActivity`
- New `ComponentManagerActivity` (pure smali, no Kotlin compile needed):
  - Extends `AppCompatActivity`, implements `AdapterView$OnItemClickListener`
  - Lists GameHub component folders from `getFilesDir()/usr/home/components/` in a ListView
  - Per-component options: Inject file (SAF `ACTION_OPEN_DOCUMENT`), Backup to `Downloads/BannerHub/{name}/`
  - Backup uses recursive `copyDir()` — no root required
  - Back press from options list returns to component list
- `AndroidManifest.xml`: declared `ComponentManagerActivity` with `sensorLandscape` orientation
#### Build failure
- Adding ComponentManagerActivity to smali_classes11 pushed the dex string/type index over the 65535 unsigned short limit → `DexIndexOverflowException` during apktool rebuild
#### Files touched
- `patches/smali_classes5/com/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog.smali` — MenuItem add + pswitch_9 + table extension
- `patches/smali_classes11/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali` — new file (later moved)
- `patches/AndroidManifest.xml` — activity declaration

---

### [fix] — Move ComponentManagerActivity to smali_classes16
**Commit:** (part of v1.0.7 push) | **Tag:** v1.0.7 ✅
#### What changed
- smali_classes11 was near the 65535 dex index limit; ComponentManagerActivity pushed it over
- smali_classes16 only has ~100 classes — plenty of headroom
- Moved `ComponentManagerActivity.smali` to `patches/smali_classes16/` directory
- **Build succeeded** — Components item visible in side menu, activity launches
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali` — moved from classes11

---

### [fix] — VerifyError crashes on launch
**Commit:** (part of v1.0.8 push) | **Tag:** v1.0.8 ✅
#### What changed
- `backupComponent()` called `invoke-static {}` with no arguments on `getExternalStoragePublicDirectory(String)` — fixed to use `sget-object Landroid/os/Environment;->DIRECTORY_DOWNLOADS:Ljava/lang/String;` then `invoke-static {v}`
- `copyDir()` had `new-array v8, v8, [B` before v8 was initialized (duplicate line) — removed
- ART's verifier rejects methods with uninitialized register use → `VerifyError` at class load time, crashing the app before the activity even appears
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

---

### [fix] — ArrayAdapter crash on component list display
**Commit:** (part of v1.0.9 push) | **Tag:** v1.0.9 ✅
#### What changed
- Hardcoded layout resource ID `0x01090001` was passed to `ArrayAdapter` constructor — on this Android version it resolved to an `ExpandableListView` layout, not a simple text item → crash
- Fixed to use `sget Landroid/R$layout;->simple_list_item_1:I` to resolve the ID at runtime from the Android framework
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

---

### [fix] — invoke-virtual 6-register overflow
**Commit:** (part of v1.0.10 push) | **Tag:** v1.0.10 ✅
#### What changed
- `ContentResolver.query()` takes 5 parameters (+ instance = 6 registers total) — `invoke-virtual` max is 5 registers; 6+ requires `invoke-virtual/range`
- Rewrote the `_display_name` query in `getFileName()` to use `invoke-virtual/range {v3 .. v8}` with consecutive registers (moved `p1` ContentResolver into `v4` first)
- This was needed to read the human-readable filename from a SAF content:// URI
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

---

### [fix] — "Inject failed" with path string as error message
**Commit:** (part of v1.0.11 push) | **Tag:** v1.0.11 ✅
#### What changed
- `getLastPathSegment()` on a SAF `content://` document URI returns `primary:Download/file.wcp` (the path segment from the tree URI), not the filename
- Replaced with `ContentResolver.query()` using `OpenableColumns._DISPLAY_NAME` to get the actual filename
- Raw file copy injection now correctly names the destination file
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

---

### [release] — v2.0.0 stable: working component manager
**Commit:** (stable tag) | **Tag:** v2.0.0 ✅ **STABLE**
#### What changed
- Promoted to stable after verifying: component list displays, backup works, raw file inject works
- Release description covers all features: "My Games" tab, BCI launcher button, Components side menu (list, backup, inject)
- All prior pre-release tags left intact

---

### [patch] — WCP/ZIP proper extraction pipeline (attempt 1: baksmali)
**Commit:** (v2.0.1-pre) | **Tag:** v2.0.1-pre (failed build)
#### What changed
- Plan: decompile library JARs to smali with baksmali, merge into patches, rebuild with apktool
- `baksmali` download via GitHub releases URL returned 404 (no assets on google/smali releases)
#### Build failure
- `wget` 404 on baksmali JAR URL

---

### [patch] — WCP/ZIP extraction pipeline (attempt 2: Maven baksmali)
**Commit:** (v2.0.2-pre) | **Tag:** v2.0.2-pre (failed build)
#### What changed
- Tried `org.smali:baksmali:2.5.2` from Maven Central — the Maven artifact is a library-only JAR with no `Main-Class` manifest entry
- Abandoned baksmali entirely
- **New approach:** download commons-compress, aircompressor, xz JARs and convert directly to dex via Android SDK `d8` tool, then inject dex files into the rebuilt APK using `zip`
#### Build failure
- `java -jar baksmali.jar` → "no main manifest attribute"

---

### [patch] — WCP/ZIP extraction pipeline (attempt 3: d8 dex injection) + WcpExtractor
**Commit:** (v2.0.3-pre) | **Tag:** v2.0.3-pre ✅ build succeeded, runtime crash
#### What changed
- `.github/workflows/build.yml`: added two new steps:
  1. **"Convert extraction libraries to dex"**: downloads `commons-compress-1.26.2.jar`, `aircompressor-0.27.jar`, `xz-1.9.jar` from Maven Central; converts all three to dex via `d8 --release --min-api 29 --output lib_dex/`
  2. **"Inject library dex files into APK"**: zips `lib_dex/classes*.dex` into rebuilt APK as `classes18.dex`, `classes19.dex`, etc. (apktool already packed classes1-17)
- `WcpExtractor.smali` (new): detects file format by magic bytes, routes to extractZip() or extractTar()
  - ZIP (magic `50 4B 03 04`) → `java.util.zip.ZipInputStream`, flat extraction (basename only)
  - zstd tar (magic `28 B5 2F FD`) → `io.airlift.compress.zstd.ZstdInputStream` + `TarArchiveInputStream`
  - XZ tar (magic `FD 37 7A 58`) → `org.tukaani.xz.XZInputStream` + `TarArchiveInputStream`
  - Reads `profile.json` from tar to detect FEXCore type → `flattenToRoot=true`; all others preserve system32/syswow64 structure
- `ComponentManagerActivity.injectFile()`: replaced raw file copy with `WcpExtractor.extract(cr, uri, componentDir)`
#### Runtime crash
- FATAL EXCEPTION in `WcpExtractor.extract()` not caught by `catch Ljava/lang/Exception;` in `injectFile()` — `Error` subclasses (`NoClassDefFoundError`, `OutOfMemoryError`) are not `Exception` subclasses, they bypass the catch block and crash the app

---

### [fix] — Background thread + Throwable catch for WCP extraction
**Commit:** `7ad71f4` | **Tag:** v2.0.4-pre ✅
#### What changed
- `injectFile()` now spawns a `java.lang.Thread` — extraction runs off the main thread (fixes long black screen while processing large WCP files)
- `ComponentManagerActivity$1.smali` (new): background Runnable
  - Calls `WcpExtractor.extract()`, catches `Throwable` (catches all Error subclasses, not just Exception)
  - Posts result to main thread via `Handler(Looper.getMainLooper())`
- `ComponentManagerActivity$2.smali` (new): UI Runnable
  - null result → shows "Injected successfully" toast + refreshes list
  - non-null result → shows "Inject failed: <message>" toast + refreshes list
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali` — injectFile() rewritten
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1.smali` — new
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2.smali` — new

---

### [fix] — XZ constructor NoSuchMethodError + clear before inject
**Commit:** `fb5592d` | **Tag:** v2.0.5-pre ✅
#### What changed
- **XZ fix:** `org.tukaani.xz.XZInputStream` constructor `<init>(Ljava/io/InputStream;)V` was not found at runtime after d8 conversion of xz-1.9.jar (`NoSuchMethodError: No direct method <init>(InputStream)V in class Lorg/tukaani/xz/XZInputStream`). Root cause: d8 processes the xz JAR in a way that makes the constructor unreachable under ART's direct-method lookup. Fix: replaced with `org.apache.commons.compress.compressors.xz.XZCompressorInputStream` (from commons-compress, which wraps tukaani internally and has a working constructor in the d8-compiled dex)
- **Clear before inject:** added `clearDir(File)` static method to WcpExtractor — recursively deletes all files and subdirs inside destDir before extraction. Called at start of `extract()`. Fixes stale files being left from previous inject (e.g. old system32/ contents when replacing a WCP component)
- ZIP injection confirmed working. WCP (XZ) confirmed error is now surfaced as a toast (Throwable catch from v2.0.4-pre). ZstdInputStream (aircompressor) not yet confirmed — needs test with DXVK/VKD3D WCP.
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/WcpExtractor.smali`

---

### [fix] — Use GameHub's own built-in classes, remove d8 injection entirely
**Commit:** `b52055c` | **Tag:** v2.0.6-pre
#### Root cause discovered
GameHub's APK already contains `commons-compress`, `zstd-jni` (`libzstd-jni-1.5.7-4.so`), and `org.tukaani.xz` as part of its normal dependencies. However, `commons-compress` is fully obfuscated by ProGuard — `TarArchiveInputStream.getNextTarEntry()` renamed to `s()`, `isDirectory()` renamed to unknown single-letter. When we injected d8-converted JARs (classes18+), Android's class loader used GameHub's obfuscated copy first (earlier dex wins), so `getNextTarEntry()` was not found. For aircompressor: `sun.misc.Unsafe.ARRAY_BYTE_BASE_OFFSET` does not exist as a static field on Android ART.
#### What changed
- **`WcpExtractor.smali`**: Rewritten to use GameHub's built-in classes with their actual runtime signatures:
  - ZIP: `java.util.zip.ZipInputStream`, flat extraction (basename only) — unchanged
  - zstd tar: `Lcom/github/luben/zstd/ZstdInputStreamNoFinalizer;` (JNI class, NOT obfuscated) → `<init>(Ljava/io/InputStream;)V`
  - XZ tar: `Lorg/tukaani/xz/XZInputStream;` (NOT obfuscated) → `<init>(Ljava/io/InputStream;I)V` (-1 = unlimited)
  - Tar: `TarArchiveInputStream.<init>(InputStream)V` + `s()` for `getNextTarEntry()` (obfuscated name, confirmed via bridge)
  - Directory detection: `getName().endsWith("/")` — `getName()` is kept (ArchiveEntry interface); `isDirectory()` is not
  - Format detection: `BufferedInputStream.mark(4)/reset()` — single open, no double open
- **`build.yml`**: Removed "Convert libraries to dex" + "Inject dex into APK" steps — GameHub already has everything needed
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/WcpExtractor.smali`
- `.github/workflows/build.yml`

---

## Planned Work

- [ ] Confirm v2.0.6-pre: ZIP (flat) works, WCP zstd (DXVK/VKD3D) works, WCP XZ (FEX) works
- [ ] Once all three confirmed working, cut stable v2.1.0 release
- [ ] Explore contributing functional patches to `playday3008/gamehub-patches` PR #13
