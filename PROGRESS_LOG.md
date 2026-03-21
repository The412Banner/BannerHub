# BannerHub Progress Log

Tracks every commit, patch, and change applied to the GameHub 5.3.5 ReVanced APK rebuild.

---

## [beta] — v2.7.0-beta3 — GOG via side menu (DEX overflow fix) (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta3
**What changed:** Moved GOG from the main tab bar (classes11, at DEX limit) to the left side menu (classes5, safe). beta1/beta2 failed: tab approach pushed classes11 to 65536 pool entries (unsigned short overflow). New approach: "GOG" item added as id=10 in HomeLeftMenuDialog side menu; clicking it opens new GogMainActivity (Activity, not Fragment). GogMainActivity shows login card or signed-in card; login opens WebView OAuth2 via GogLoginActivity.
**New files:** `GogMainActivity` (+$1 login, +$2 sign-out), `GogLoginActivity` (+$1 WebViewClient, +$2 TokenExchange, +$3 Finish, +$4 ErrorToast)
**Removed:** `BhGogTabCallback`, `GogFragment` (+$1 +$2) — no longer needed
**Patched:** `HomeLeftMenuDialog` (id=10 menu item + pswitch_10 → start GogMainActivity), `AndroidManifest.xml` (+GogMainActivity)
**Reverted:** `LandscapeLauncherMainActivity` — GOG tab injection removed (classes11 overflow risk)
**CI result:** ✅ run 23384471808 — Normal APK built successfully

---

## [ci] — Dynamic APK filenames (2026-03-21)
**Commit:** `f238e3a`
**What changed:** All 3 CI workflows now produce `BannerHub-<tag>-<variant>.apk` instead of hardcoded `Bannerhub-5.3.5-Revanced-*.apk`. Matrix `apk:` field replaced with `variant:` (Normal/PuBG/AnTuTu/alt-AnTuTu/PuBG-CrossFire/Ludashi/Genshin/Original). Filename built from `${{ github.ref_name }}` + variant at sign time.
**Files touched:** `.github/workflows/build.yml`, `.github/workflows/build-quick.yml`, `.github/workflows/build-crossfire.yml`

---

## [stable] — v2.6.3 — Stable release (2026-03-21)
**Commit:** `18b36ed` (code) / `9dda08f` (README)  |  **Tag:** v2.6.3
**What changed:** Stable release of v2.6.2-pre3 through v2.6.2-pre7 line. New since v2.6.1: Component Manager UI rebuilt as card-based RecyclerView (search, swipe, source/type badges, count badge, empty state, auto-refresh); ✓ downloaded indicator in online repo lists (clears on removal); Remove All counts only BannerHub-managed components; compact cards (~20% smaller).
**CI result:** ✅ run 23381119419 — 8 APKs built successfully

---

## [pre] — v2.6.2-pre7 — Fix Remove All count + clear SP on component removal (2026-03-21)
**Commit:** `18b36ed`  |  **Tag:** v2.6.2-pre7  |  **CI:** run 23380984014 (queued)
**What changed:** Bug A: `confirmRemoveAll()` now counts only `.bh_injected` components for the dialog message. Bug B: `$5.run()` writes a reverse key `"url_for:"+dirName → url` at injection time. `removeComponent()` and `removeAllComponents()` read this reverse key on removal to clear all 4 SP entries (`dirName`, `dirName:type`, `dl:url`, `url_for:dirName`) — clears the ✓ downloaded indicator in the online repo list.
**Files touched:** `ComponentDownloadActivity$5.smali` [ADD url_for reverse key write]; `ComponentManagerActivity.smali` [FIX confirmRemoveAll count; ADD SP cleanup in removeComponent + removeAllComponents]

---

## [pre] — v2.6.2-pre6 — Shrink component cards ~20% (2026-03-21)
**Commit:** `af5a813`  |  **Tag:** v2.6.2-pre6  |  **CI:** ✅ run 23380774414
**What changed:** All dp values and text sizes in BhComponentAdapter.onCreateViewHolder scaled to ~80%. dp precomputations: 4→3, 8→6, 12→10, 36→29. Badge padding: 6→5dp. Text sizes: 15→12sp, 11→9sp, 20→16sp. No layout or logic changes.
**Files touched:** `BhComponentAdapter.smali` [SCALE dp + sp constants in onCreateViewHolder]

---

## [pre] — v2.6.2-pre5 — Fix source badge + refresh + type badge for Arihany items (2026-03-21)
**Commit:** `26f5af5`  |  **Tag:** v2.6.2-pre5a  |  **CI:** ✅ run 23380498933
**What changed:** Four fixes: (1) Bug #1: Added onResume() to ComponentManagerActivity → list now refreshes immediately when returning from ComponentDownloadActivity. (2) Bug #2a: setMaxLines(1) changed to setMaxLines(2) on nameText in onCreateViewHolder → source badge (appended as \n+repo) is now visible. (3) Bug #2b: $5 now scans components dir post-injection using System.currentTimeMillis() timestamp to find newly created dir → correct SP key regardless of filename format; falls back to filename-based key if scan finds nothing. (4) Type badge fix: $5 writes dirName+":type" → type string (FEXCore/Box64/VKD3D/GPU/DXVK); adapter reads SP type override before keyword detection → Arihany FEXCore/DXVK show correct badge. (5) Double-extension bug fixed in onItemClick: endsWith check prevents appending ".wcp" if filename already ends in ".wcp".
**Files touched:** `ComponentManagerActivity.smali` [ADD onResume]; `BhComponentAdapter.smali` [setMaxLines 1→2, ADD type SP override in onBindViewHolder]; `ComponentDownloadActivity.smali` [ADD endsWith check in onItemClick]; `ComponentDownloadActivity$5.smali` [REWRITE run() with timestamp+scan+type]

---

## [pre] — v2.6.2-pre4 — Source tracking + ✓ installed indicator (2026-03-21)
**Commit:** `11a6490`  |  **Tag:** v2.6.2-pre4  |  **CI:** ✅
**What changed:** SharedPreferences `"banners_sources"` added. ComponentDownloadActivity tracks which repo was selected (mCurrentRepo field, set in each sw0_N case). After successful injection in $5, writes baseName→repoName and "dl:url"→"1". showAssets() reads SP to prefix already-downloaded assets with ✓. BhComponentAdapter reads SP in onBindViewHolder to show "name\nrepoName" for BannerHub-downloaded components. pre3 kept as rollback baseline release.
**Files touched:** `ComponentDownloadActivity.smali` [ADD field mCurrentRepo; SET in sw0_N; ADD ✓ loop in showAssets]; `ComponentDownloadActivity$5.smali` [WRITE to SP after injection]; `BhComponentAdapter.smali` [ADD prefs field; LOAD in ctor; SHOW source in onBindViewHolder]

---

## [pre] — v2.7.9-pre — Rollback to v2.7.0-pre state (2026-03-21)
**Commit:** `6eed029`  |  **Tag:** v2.7.9-pre  |  **CI:** ✅
**What changed:** Reverted ComponentManagerActivity.smali and BhComponentAdapter.smali to v2.7.0-pre state. Drops all button-to-header changes (v2.7.5–v2.7.8). Restores bottom bar with Add New + Download buttons.
**Files touched:** `patches/smali_classes16/.../ComponentManagerActivity.smali` [REVERT]; `patches/smali_classes16/.../BhComponentAdapter.smali` [REVERT]

---

## [pre] — v2.7.8-pre — Fix header centering: switch root to RelativeLayout (2026-03-21)
**Commit:** `473955a`  |  **Tag:** v2.7.8-pre  |  **CI:** ✅ run 67991306650
**What changed:** Root layout changed from LinearLayout (weight=1 pattern) to RelativeLayout. LinearLayout weight distribution requires an EXACTLY MeasureSpec from the AppCompat subDecor; if AT_MOST is provided, the weight=1 content FrameLayout collapses to 0px and AppCompat centers the wrapper at the vertical middle of the window. RelativeLayout uses constraint-based geometry: header gets ALIGN_PARENT_TOP + setId(1), content gets BELOW(1) + ALIGN_PARENT_BOTTOM + MATCH_PARENT×MATCH_PARENT. No MeasureSpec dependency.
**Files touched:** `patches/smali_classes16/.../ComponentManagerActivity.smali` [MOD — buildUI() switched from LinearLayout to RelativeLayout root]

---

## [pre] — v2.7.7-pre — Fix header stuck at vertical center of screen (2026-03-21)
**Commit:** `6266731`  |  **Tag:** v2.7.7-pre  |  **CI:** ✅ run 23369636270
**What changed:** buildUI() layout fix. Removed setFitsSystemWindows(true) from root LinearLayout — was interfering with AppCompat subDecor's insets handling, offsetting the view to center. Changed setContentView(View) → setContentView(View, ViewGroup.LayoutParams(MATCH_PARENT, MATCH_PARENT)) to guarantee root fills window regardless of MeasureSpec from subDecor.
**Files touched:** `patches/smali_classes16/.../ComponentManagerActivity.smali` [MOD — removed setFitsSystemWindows call; setContentView now passes MATCH_PARENT×MATCH_PARENT LayoutParams]

---

## [pre] — v2.6.6-pre — Fix VerifyError crash on Component Manager open (2026-03-20)
**Commit:** `495a264`  |  **Tag:** v2.6.6-pre  |  **CI:** ✅ run 23365366484 (3m34s)
**What changed:** ART VerifyError crash fixed (from logcat). Two causes: (1) helper methods declared private but called via invoke-virtual — changed to public; (2) getFileName() overwrote Uri register with String[] before ContentResolver.query range call — fixed register ordering with move-object v1, p1 before array allocation.
**Files touched:** `patches/smali_classes16/.../ComponentManagerActivity.smali` [MOD — private→public on 7 methods; getFileName register fix]

---

## [pre] — v2.6.5-pre — Component Manager UI redesign: RecyclerView cards + search + swipe (2026-03-20)
**Commit:** `7b6284f`  |  **Tag:** v2.6.5-pre  |  **CI:** ✅ run 23365002056 (3m28s)
**Fix commits:** `924c5ef` (register overflow), `a272740` (literal in invoke), `7b6284f` (const/4 range)

## [pre] — v2.6.2-pre — Component Manager UI redesign: RecyclerView cards + search + swipe (2026-03-20)
**Commit:** `56851cd`  |  **Tag:** v2.6.2-pre  |  **CI:** ❌ (register v16/v17 overflow in BhComponentAdapter)
**What changed:** Complete overhaul of ComponentManagerActivity UI. Replaces basic ListView with card-based RecyclerView. Each card shows component name + color-coded type badge (DXVK/VKD3D/Box64/FEX/GPU/WCP) with colored left accent strip. Live search bar (TextWatcher) filters cards in real time. Swipe LEFT removes, Swipe RIGHT backs up (ItemTouchHelper). Header has ← back, title, install count badge, "✕ All" remove-all. Bottom bar has "+ Add New" (blue) and "↓ Download" (green) buttons. Empty state shows 📦 emoji + help text when no components installed. Fully programmatic UI (no XML layouts).
**Files touched:**
- `patches/smali_classes16/.../ComponentManagerActivity.smali` [REWRITE — new fields: recyclerView, adapter, emptyState, countBadge; new methods: dp(), buildUI(), buildHeader(), buildSearchBar(), buildContent(), buildEmptyState(), buildBottomBar(), makeBtn(), showComponents(), updateEmptyState(), onSearchChanged(), showOptionsDialog(), showTypeDialog(), removeFiltered(), backupFiltered(), getFileName()]
- `patches/smali_classes16/.../BhComponentAdapter.smali` [NEW — RecyclerView.Adapter: updateComponents(), filter(), getFiltered(), onItemTapped(), getTypeName(), getTypeColor(), onCreateViewHolder(), onBindViewHolder(), getItemCount()]
- `patches/smali_classes16/.../BhComponentAdapter$ViewHolder.smali` [NEW — ViewHolder with onClick delegation to adapter.onItemTapped()]
- `patches/smali_classes16/.../BhSwipeCallback.smali` [NEW — ItemTouchHelper.SimpleCallback(0,12): LEFT→removeFiltered, RIGHT→backupFiltered]
- `patches/smali_classes16/.../ComponentManagerActivity$5.smali` [NEW — options dialog: Inject/Backup/Remove]
- `patches/smali_classes16/.../ComponentManagerActivity$6.smali` [NEW — type dialog: DXVK/VKD3D/Box64/FEX/GPU]
- `patches/smali_classes16/.../ComponentManagerActivity$7.smali` [NEW — TextWatcher → onSearchChanged()]
- `patches/smali_classes16/.../ComponentManagerActivity$BhBackListener.smali` [NEW — finish()]
- `patches/smali_classes16/.../ComponentManagerActivity$BhRemoveAllListener.smali` [NEW — confirmRemoveAll()]
- `patches/smali_classes16/.../ComponentManagerActivity$BhAddListener.smali` [NEW — showTypeDialog()]
- `patches/smali_classes16/.../ComponentManagerActivity$BhDownloadListener.smali` [NEW — start ComponentDownloadActivity]

---

## [stable] — v2.6.0 — Stable release (2026-03-20)
**Commit:** `1fc4505` (code) / `4948e7b` (README)  |  **Tag:** v2.6.0
**What changed:** Stable release of v2.5.2-pre through v2.5.6-pre line. Grant Root Access (Settings → Advanced); fix VerifyError on root grant; fix perf toggles staying grey after root grant; component descriptions in game settings picker; download progress indicator in ComponentDownloadActivity.
**CI result:** ✅ run 23347015897 — 8 APKs built successfully

---

## [pre] — v2.5.6-pre — Download progress indicator in ComponentDownloadActivity (2026-03-20)
**Commit:** `1fc4505`  |  **Tag:** v2.5.6-pre  |  **CI:** ✅ run 23346364788 (3m~)
**What changed:** Added `mProgressBar` (indeterminate) to ComponentDownloadActivity. Shown during repo fetching ("Fetching X...") and file download ("Downloading: `<filename>`"). Hidden on `showRepos()`, `showCategories()`, `showAssets()`. Status text during download now shows "Downloading: `<filename>`" instead of just "Downloading...". Matches bh-lite behaviour.
**Files touched:** `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentDownloadActivity.smali` [MOD — +56 lines: field, onCreate setup, visibility toggling in 6 fetch cases + download start + 3 nav methods]
**CI result:** ✅ passed

---

## [pre] — v2.5.5-pre — Show component description in game settings picker (2026-03-20)
**Commit:** `d8ae34f`  |  **Tag:** v2.5.5-pre  |  **CI:** ✅ run 23345802544 (3m30s)
**What changed:** `appendLocalComponents()` now calls `entity.getBlurb()` and passes the result to `DialogSettingListItemEntity.setDesc()`. Locally installed components now show their description text under the component name in the game settings component picker. `EnvLayerEntity.getBlurb()` is not obfuscated in 5.3.5. Blurb value comes from `profile.json` `"description"` field stored at inject time.
**Files touched:** `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali` [MOD — +5 lines in appendLocalComponents after setDownloaded]
**CI result:** ✅ passed

---

## [pre] — v2.5.3-pre — Fix: Grant Root Access patches missing from build-quick.yml (2026-03-20)
**Commit:** `c7ecc4d`  |  **Tag:** v2.5.3-pre  |  **CI:** ✅ run 23339561713 (3m38s)
**What changed:** Pre-releases use build-quick.yml but the 3 Grant Root Access Python smali patches were only added to build.yml. As a result the button was never added to the settings list and getContentName() never returned "Grant Root Access". Added the identical Python patch step to build-quick.yml targeting apktool_out/ instead of apktool_out_base/.
**CI result:** ✅ passed

---

## [pre] — v2.5.2-pre — Settings: Grant Root Access button (port from bh-lite) (2026-03-20)
**Commit:** `493f9ae`  |  **Tag:** v2.5.2-pre  |  **CI:** ✅ run 23338789938 (3m38s)
**What changed:** Ported the explicit root-grant dialog from BannerHub Lite. Added "Grant Root Access" button to Settings → Advanced (contentType=0x64). Shows a full warning dialog; on confirmation runs `su -c id` via a background thread and stores `root_granted` in `bh_prefs`. BhPerfSetupDelegate now reads this pref instead of running a live `isRootAvailable()` check on every sidebar open. 5 new inner-class smali files in patches/smali_classes16. 3 Python string patches added to build.yml CI for SettingBtnHolder.w(), SettingItemEntity.getContentName(), SettingItemViewModel.k(). NOTE: patches were missing from build-quick.yml — fixed in v2.5.3-pre.
**CI result:** ✅ passed (but missing build-quick.yml patches — see v2.5.3-pre)

---

## [stable] — v2.5.1 — Perf crash guard + root-gated toggles (2026-03-18)
**Commit:** `d0a6fcb`  |  **Tag:** v2.5.1
**What changed:** (A) try/catch guard on both BH on-launch perf re-apply blocks — prevents `setSustainedPerformanceMode()` crash on unsupported devices. (C) `BhPerfSetupDelegate` root check via `isRootAvailable()` — no-root devices see perf toggles at 0.5f alpha, non-interactive. Float literal bug fixed (`const/high16` → `const 0x3f000000`).
**CI result:** ✅ build.yml run 23276212704 — 8 APKs built successfully

---

## [pre] — v2.5.1-pre — Fix: perf launch crash guard + grey out without root (2026-03-18)
**Commit:** `d0a6fcb`  |  **Tag:** v2.5.1-pre
**What changed:** (A) Wrapped both BannerHub on-launch re-apply blocks (Sustained Perf + Max Adreno) in try/catch — `setSustainedPerformanceMode()` throws on unsupported devices, previously crashing container launch. (C) Fixed `BhPerfSetupDelegate` float literal bug (`const/high16` → `const 0x3f000000`); added `isRootAvailable()` root check; no-root devices see both performance toggles at 0.5f alpha with no click listener.
**Files touched:** `patches/smali_classes15/com/xj/winemu/WineActivity.smali` [MOD — try/catch around BH re-apply blocks]; `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali` [MOD — isRootAvailable()Z, float fix, root guard]
**CI result:** ✅ build-quick.yml run 23275952622 (3m 35s)

---

## [stable] — v2.5.0 — Stable release (2026-03-18)
**Commit:** `9b25f1a` (README) / tag on `8e78d4f`  |  **Tag:** v2.5.0
**What changed:** Stable release of v2.4.6-pre through v2.4.9-pre line. Includes Sustained Perf (Root+) + Max Adreno Clocks toggles in Performance sidebar. README rewritten to reflect full feature set including performance toggle comparison table.
**CI result:** ✅ build.yml — 8 APKs built successfully (run 23271051752)

---

## [pre] — v2.4.9-pre — Sustained Perf: renamed + dual no-root/root approach (2026-03-18)
**Commit:** `8e78d4f`  |  **Tag:** v2.4.9-pre
**What changed:** Renamed toggle to "Sustained Perf (Root+)". Now calls `Window.setSustainedPerformanceMode()` first (no-root, silent if device doesn't support it), then always attempts CPU governor via `su -c` (root users get guaranteed visible effect). onCreate re-apply block updated identically.
**Files touched:** `patches/smali_classes15/com/xj/winemu/WineActivity.smali` [MOD], `patches/res/values/strings.xml` [MOD]
**CI result:** ✅ build-quick.yml run 23269055800

---

## [pre] — v2.4.8-pre — Fix: su -c flag missing — root toggles had no effect (2026-03-18)
**Commit:** `0016e60`  |  **Tag:** v2.4.8-pre
**What changed:** Both Sustained Performance and Max Adreno Clocks toggles silently did nothing. Root cause: all su commands used a 2-element array `["su", "command"]` which passes the shell script as a username to su rather than as a shell command to execute. Fixed to 3-element `["su", "-c", "command"]`. Also replaced `Window.setSustainedPerformanceMode()` (silently a no-op on most Android devices — requires OEM enablement) with a CPU governor approach: sets all CPU cores to `performance` governor on enable, `schedutil` on disable. Max Adreno enable command simplified from `MAX=$(cat ...)` variable expansion to `cat max_freq > min_freq` (direct redirection, no variable needed). All four locations patched: `toggleSustainedPerf()`, `toggleMaxAdreno()`, and both re-apply blocks in `o2()` (onCreate).
**Root cause analysis:** `Runtime.exec(String[])` takes program + args; `["su", "cmd"]` = `su "cmd"` (username lookup, fails silently). Must be `["su", "-c", "cmd"]`. `setSustainedPerformanceMode` additionally requires OEM HAL support and is a no-op on most devices.
**Files touched:** `patches/smali_classes15/com/xj/winemu/WineActivity.smali` [MOD]
**CI result:** ✅ build-quick.yml run 23268380757 — Normal APK built successfully

---

## [pre] — v2.4.7-pre — Fix: restore R$id.smali (iv_bci_launcher) (2026-03-18)
**Commit:** `cbf3efa`  |  **Tag:** v2.4.7-pre
**What changed:** App crashed on launch with `java.lang.NoSuchFieldError: No field iv_bci_launcher of type I in class Lcom/xj/landscape/launcher/R$id`. Caused by `rm -rf patches/smali_classes9/` (intended to remove failed SidebarPerformanceFragment patch) which also deleted `R$id.smali` — the patch that adds `iv_bci_launcher` to the R$id class, required by BciLauncherClickListener and LandscapeLauncherMainActivity. Restored from git history (commit `4fbf4d9`).
**Root cause analysis:** `rm -rf` on smali_classes9 removed both the bad SidebarPerformanceFragment patch AND the critical R$id patch. Should have removed only the specific file.
**Files touched:** `patches/smali_classes9/com/xj/landscape/launcher/R$id.smali` [RESTORED]
**CI result:** ✅ build-quick.yml run 23267370887 — Normal APK built successfully

---

## [pre] — v2.4.6-pre — Sustained Perf + Max Adreno Clocks toggles in Performance sidebar (2026-03-18)
**Commit:** `5835d3c`  |  **Tag:** v2.4.6-pre
**What changed:** Moved Sustained Performance toggle from ComponentManagerActivity to the in-game Performance sidebar tab. Added Max Adreno Clocks (Root) toggle below it. Both use BhPerfSetupDelegate pattern (self-wiring View in layout XML, wires siblings in onAttachedToWindow) to avoid touching smali_classes9 (at dex limit). WineActivity gains toggleSustainedPerf() and toggleMaxAdreno() static methods. Max adreno command: locks kgsl-3d0 min_freq = max_freq via su.
**Root cause analysis:** smali_classes9 is at 65535 method reference limit — adding any new methods causes build failure. BhPerfSetupDelegate puts all new code in smali_classes16 with zero additions to classes9.
**Files touched:** `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali` [NEW], `patches/smali_classes16/com/xj/winemu/sidebar/MaxAdrenoClickListener.smali` [NEW], `patches/smali_classes16/com/xj/winemu/sidebar/SustainedPerfSwitchClickListener.smali` [NEW], `patches/smali_classes15/com/xj/winemu/WineActivity.smali` [MOD], `patches/res/layout/winemu_sidebar_hub_type_fragment.xml` [NEW patch], `patches/res/values/strings.xml` [MOD], `patches/res/values/ids.xml` [MOD], `patches/res/values/public.xml` [MOD]
**CI result:** ✅ build-quick.yml — Normal APK built successfully

---

## [beta] — v2.4.2-beta6b — Fix IllegalAccessError on Apply/No Limit (2026-03-17)
**Commit:** `41deadb`  |  **Tag:** v2.4.2-beta6b
**What changed:** Crash: `IllegalAccessError: Field 'id' is inaccessible` — private backing fields on `DialogSettingListItemEntity` (classes12) cannot be set via `iput` from classes16 on ART 14. Fix: use the full Kotlin defaults constructor `invoke-direct/range {v7..v32}` with bitmask `0x3ffffa` (provide id+isSelected, default rest) — same pattern as PcGameSettingOperations. Also add `move-object/from16 v3/v6, p0` at method start: with `.locals 33`, p0=v33 which exceeds the 4-bit iget-object limit.
**Root cause analysis:** Cross-dex private field access blocked by ART 14. Must use constructor or public setter — no public setters exist (Kotlin val/var with private backing), so full defaults ctor is the only option.
**Files touched:** `patches/smali_classes16/.../CpuMultiSelectHelper{$2,$3}.smali` [MOD]

---

## [beta] — v2.4.2-beta5 — Immediate UI refresh via DialogSettingListItemEntity (2026-03-17)
**Commit:** `77c6cf2`  |  **Tag:** v2.4.2-beta5
**What changed:** After saving, construct `new DialogSettingListItemEntity{id=newMask, isSelected=true}` and call `callback.invoke(entity)`. This matches the type the original `e()` passes to `u0.invoke()`. Settings row label now refreshes immediately after Apply/No Limit — no back-out required.
**Files touched:** `patches/smali_classes16/.../CpuMultiSelectHelper{,$2,$3}.smali` [MOD]

---

## [beta] — v2.4.2-beta4 — Remove callback invocation to fix j3 NPE crash; 80% height; smaller text (2026-03-17)
**Commit:** `401e43b`  |  **Tag:** v2.4.2-beta4
**What changed:** Root cause of NPE: `u0` lambda (UI refresh callback) expects `DialogSettingListItemEntity`, not `View` — passing View caused `j3.checkNotNullParameter` on a null intermediate. Fix: removed `callback.invoke()` from $2 and $3 entirely; value is still saved via `SPUtils.m()`. Also: height raised to 80% (`heightPixels * 4/5`); labels wrapped in `Html.fromHtml("<small>...</small>")` for smaller text. $2/$3 constructors simplified (no View/Function1 fields, no invoke-direct/range).
**Files touched:** `patches/smali_classes16/.../CpuMultiSelectHelper{,$2,$3}.smali` [MOD]

---

## [beta] — v2.4.2-beta3 — Fix invoke-direct/range for $2 6-arg constructor (2026-03-17)
**Commit:** `48aac66`  |  **Tag:** v2.4.2-beta3
**What changed:** Fixed CI failure from beta2 — Dalvik non-range `invoke-direct` max 5 registers; `CpuMultiSelectHelper$2.<init>` takes 6. Rewrote register layout: move args into contiguous v7..v11, new-instance at v6, call `invoke-direct/range {v6 .. v11}`. `$3` (5 regs) kept as regular invoke-direct.
**Files touched:** `patches/smali_classes16/.../CpuMultiSelectHelper.smali` [MOD]

---

## [beta] — v2.4.2-beta2 — Fix NPE crash + dialog height limit (2026-03-17)
**Commit:** `249c1c1`  |  **Tag:** v2.4.2-beta2  |  **CI:** ❌ (smali 5-reg limit)
**What changed:** (1) NPE fix: `j3` callback expects non-null `android.view.View`; changed `show()` signature to `(View, ...)` and pass anchor View from `SelectAndSingleInputDialog$Companion.d()` through $2/$3 as callback argument. (2) Height limit: after `builder.show()` get `AlertDialog.getWindow()`, call `setLayout(WRAP_CONTENT, heightPixels * 70%)` via `mul-int/lit16`/`div-int/lit16`. CI failed due to invoke-direct 6-register limit (fixed in beta3).
**Files touched:** `patches/smali_classes16/.../CpuMultiSelectHelper{,$2,$3}.smali` [MOD], `patches/smali_classes2/.../SelectAndSingleInputDialog$Companion.smali` [MOD]

---

## [beta] — v2.4.2-beta1 — Multi-select CPU core dialog (2026-03-17)
**Commit:** `fe2e2a1`  |  **Tag:** v2.4.2-beta1
**What changed:** Replaced single-select CPU core preset list with a multi-select checkbox dialog (`AlertDialog.setMultiChoiceItems()`). Intercept added to `SelectAndSingleInputDialog$Companion.d()` for `CONTENT_TYPE_CORE_LIMIT` — calls `CpuMultiSelectHelper.show()` instead of OptionsPopup. Helper reads current mask, pre-checks boxes accordingly, shows 8 individual core checkboxes (Core 0-7). "Apply" saves OR-combined bitmask; "No Limit" saves 0. `D(I)` updated to dynamically build label (e.g. "Core 4 + Core 7 (Prime)") for custom combinations.
**Files touched:** `patches/smali_classes16/.../CpuMultiSelectHelper{,$1,$2,$3}.smali` [NEW], `patches/smali_classes2/.../SelectAndSingleInputDialog$Companion.smali` [NEW PATCH], `patches/smali_classes4/.../PcGameSettingOperations.smali`

---

## [beta] — v2.4.1-beta2 — CPU core selector: fix const/4 range error for Core 3 (2026-03-17)
**Commit:** `c657566`  |  **Tag:** v2.4.1-beta2
**What changed:** Fixed smali assembler error — `const/4` only holds -8 to 7; value 8 (Core 3 id) requires `const/16`. Two occurrences fixed: in A() (Core 3 entry, v8) and in D(I) (Core 3 match, v0). CI now passes.
**Files touched:** `patches/smali_classes4/.../PcGameSettingOperations.smali`

---

## [beta] — v2.4.1-beta1 — CPU core selector: bitmask-based specific core selection (2026-03-17)
**Commit:** `eb55f63`  |  **Tag:** v2.4.1-beta1
**What changed:** Replaced count-based CPU core limit with bitmask-based specific core selection. EnvironmentController.d() patched to pass stored value directly as WINEMU_CPU_AFFINITY (bypasses (1<<count)-1 formula). A() replaced with 11-entry fixed list: No Limit, Cores 4-7 (Performance), Cores 0-3 (Efficiency), Core 0–Core 7 (Prime). D(I) returns correct display label per bitmask value.
**Files touched:** `patches/smali_classes4/.../PcGameSettingOperations.smali`, `patches/smali_classes6/.../EnvironmentController.smali` [NEW]

---

## [stable] — v2.4.0 — In-app downloader, VRAM unlock, offline PC settings (2026-03-17)
**Commit:** `9fa49f1`  |  **Tag:** v2.4.0
**What changed:** Stable release packaging all pre-releases since v2.3.5. Features: in-app component downloader (The412Banner Nightlies + Arihany WCPHub), VRAM limit unlock (6/8/12/16 GB) with correct display and checkmark, offline PC game settings fix. README rewritten to reflect full feature set.
**Files touched:** README.md (rewrite)

---

## [fix] — v2.3.10-pre — Fix VRAM display string and isSelected checkmark (2026-03-17)
**Commit:** `86207ca`  |  **Tag:** v2.3.10-pre
**What changed:** Selecting 6/8/12/16 GB VRAM appeared to revert to "Unlimited" due to two display bugs. (1) `F0()` had no if-eq branches for values > 4096, returning the "No Limit" string — fixed by adding cases for 0x1800/0x2000/0x3000/0x4000. (2) `l0()` always set `isSelected=false` for the new entries — fixed by calling `G0()` once into v3 (int) and comparing v3 against each MB value via v4. The value was already being saved correctly to MMKV; these were purely display bugs.
**Files touched:** `patches/smali_classes4/com/xj/winemu/settings/PcGameSettingOperations.smali`

---

## [fix] — v2.3.9-pre — Fix VerifyError crash from invalid if-ne in VRAM l0() (2026-03-17)
**Commit:** `c83dcb0`  |  **Tag:** v2.3.9-pre
**What changed:** v2.3.8-pre caused a VerifyError that crashed PC game settings and uninstall. The new VRAM entries used `if-ne v0, vN` where v0 was a DialogSettingListItemEntity ref (clobbered) vs integer — invalid in Dalvik. Fixed by removing the selected-state check for new entries (always false/not selected). No functional impact on the VRAM options themselves.
**Files touched:** `patches/smali_classes4/com/xj/winemu/settings/PcGameSettingOperations.smali`

---

## [feat] — v2.3.8-pre — Unlock higher VRAM limits in PC game settings (2026-03-17)
**Commit:** `cb56d1b`  |  **Tag:** v2.3.8-pre
**What changed:** VRam Limit dropdown was capped at 4 GB. Added 6 GB, 8 GB, 12 GB, and 16 GB options by appending new `DialogSettingListItemEntity` entries to `PcGameSettingOperations.l0()` in a new patch file.
**Files touched:** `patches/smali_classes4/com/xj/winemu/settings/PcGameSettingOperations.smali` [NEW]

---

## [fix] — v2.3.7-pre — Offline mode: catch NoCacheException in PC game settings (2026-03-17)
**Commit:** `36e0180`  |  **Tag:** v2.3.7-pre
**What changed:** When offline, opening PC game settings crashed with `NoCacheException` from `landscape-api.vgabc.com` (getContainerList + getComponentList), making menus non-interactive. Fixed by wrapping `ResultKt.throwOnFailure()` in try-catch at the two coroutine resume points (pswitch_8 for getContainerList, pswitch_6 for getComponentList) with empty fallbacks (ArrayList / `"{}"`). Settings menus now open and remain interactive offline.
**Files touched:** `patches/smali_classes3/com/xj/winemu/settings/GameSettingViewModel$fetchList$1.smali`

---

## [fix] — no tag — Restore patches/ to v2.3.5 + classes12 bypass all workflows (2026-03-17)
**Commits:** `b42c452` (patches fix), `f66a6a4` (crossfire bypass), `5875eb8` (build.yml bypass), `9b4f0f5` (build-quick.yml bypass)
**What changed:** GitHub Actions environment changed overnight causing smali reassembly failures (dex index limit). Fixed by:
1. Extracting original `classes12.dex` from base APK and injecting it post-rebuild, bypassing smali reassembly for that dex — applied to all 3 workflows (build.yml ✅ passed, build-quick.yml, build-crossfire.yml)
2. Removed 5 extra smali files from patches/ that were left by the bad revert of bbf4d43 (duplicate injection points in wrong dex locations for new APK experiment)
3. Saved `apktool_out_base` artifact from v2.3.5 CI run as permanent release `apktool-out-base-v2.3.5` (219MB) before it expired
**Files touched:** `.github/workflows/build.yml`, `.github/workflows/build-quick.yml`, `.github/workflows/build-crossfire.yml`, `patches/smali_classes4/`, `patches/smali_classes7/`, `patches/smali_classes11/`, `patches/smali_classes12/`, `patches/smali_classes14/`

---

## [ci] — no tag — Add workflow_dispatch to build-quick.yml (2026-03-17)
**Commit:** `ff9267d`
**What changed:** Added `workflow_dispatch` trigger to `build-quick.yml` so the quick CI build (Normal APK only) can be run manually without a tag. Triggered immediately to verify base APK integrity (CI run `23188227052`, in progress).
**Files touched:** `.github/workflows/build-quick.yml`

---

## [feat] — v2.3.5 (docs) — Standalone Component Manager patch + build guide (2026-03-16)
**Commit:** `d71bfc7`
**What changed:** Added `component-manager-patch/` — a self-contained patch directory for applying ONLY the Component Manager feature to GameHub 5.3.5 ReVanced (no RTS controls, no BCI button, no other BannerHub changes).
- `patches/` — 15 new smali files (ComponentManagerActivity, ComponentInjectorHelper, WcpExtractor, ComponentDownloadActivity $1-$9) + 2 modified originals (HomeLeftMenuDialog, GameSettingViewModel$fetchList$1)
- `build.yml` — full GitHub Actions CI workflow (decompile → patch → Python manifest injection → rebuild → sign → release)
- `BUILD_GUIDE.md` — features overview, repo structure, quick start, manual build steps, exact injection diffs for both modified original files, AndroidManifest additions, key constraints table
**Files touched:** `component-manager-patch/` (19 files created)

---

## [docs] — v2.3.5 (stable) — Triple-check build log corrections (2026-03-16)
**Commit:** `362ef4d`
**What changed:** Corrected three errors in COMPONENT_MANAGER_BUILD_LOG.md identified during triple-check:
1. Entry 021 commit hash: `5808a2a` → `d6d9965` (first title/padding attempt was not the built commit)
2. Entry 023/024 ordering: entries were written in wrong order; 023 (v2.2.8-pre Remove option) now precedes 024 (v2.2.9-pre RTS shrink)
3. Entries 019/020: gap note added — these numbers were never assigned (no feature commits between v2.2.6-pre and v2.2.7-pre)
**Files touched:** `COMPONENT_MANAGER_BUILD_LOG.md`

---

## SESSION SUMMARY — 2026-03-16
Implemented in-app component downloader. Full journey: initial fetch (Nightlies only) → Looper crash fix ($5 InjectRunnable) → multi-repo/category redesign → Arihany added (Releases API failed, switched to pack.json via $6) → cleaned to Arihany-only → promoted to v2.3.1-pre.

**Architecture:**
- `ComponentDownloadActivity` — 3-mode Activity (0=repos, 1=categories, 2=assets); mode-driven ListView; `onBackPressed()` navigates backwards
- `$1` — FetchRunnable: GitHub Releases API (finds first `nightly-*` tag); used by Nightlies-style repos
- `$2` — ShowCategoriesRunnable: posts `showCategories()` to UI thread after fetch
- `$3` — DownloadRunnable: streams file to cacheDir, posts `$5`
- `$4` — CompleteRunnable: shows Toast + finish()
- `$5` — InjectRunnable: calls `ComponentInjectorHelper.injectComponent()` on UI thread (Looper fix)
- `$6` — PackJsonFetchRunnable: fetches flat JSON array (type/verName/remoteUrl), skips Wine/Proton, extracts filename from URL last segment; used by Arihany/StevenMXZ-style repos
- `detectType(String)I` — case-insensitive (toLowerCase first); box64→94, fex→95, vkd3d→13, turnip/adreno/driver→10, default DXVK→12
- `startFetch(String)` — spawns $1 thread (GitHub Releases API format)
- `startFetchPackJson(String)` — spawns $6 thread (flat JSON array format)

**Key lessons:**
- Arihany has no `nightly-*` tags — Releases API returns empty; must use pack.json
- Wine/Proton type ints unknown in GameHub — skip to avoid wrong-type injection
- `injectComponent()` calls Toast internally → must run on UI thread (Looper requirement)
- `val$type:I` primitive fields must NOT have trailing `;` in smali type descriptors

---

## [feat] — v2.3.4-pre — Add The412Banner Nightlies repo (2026-03-16)
**Commit:** `babe5f9`  |  **Tag:** v2.3.4-pre  |  **CI:** ✓ (run `23151833249`, 3m36s)

### What changed
- Added "The412Banner Nightlies" at index 5 in showRepos() (Back shifted to index 6)
- `sw0_5` handler: clears lists, sets status text, calls `startFetchPackJson("https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/nightlies_components.json")`
- Uses `$6` PackJsonFetchRunnable (flat JSON array: type/verName/remoteUrl) — same as Arihany
- `showRepos()` array size 6→7; `sw0_data` packed-switch extended to 6 entries

### Files changed
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentDownloadActivity.smali` [MOD]

---

## [fix] — v2.3.3-pre — Fix: GPU driver variants with same version collide on install (2026-03-16)
**Commit:** `a80947d`  |  **Tag:** v2.3.3-pre  |  **CI:** ✓ (run `23149773741`, 3m41s)

### What changed
- `ComponentDownloadActivity.onItemClick()` mode=2: after storing `mDownloadUrl`, parse URL last path segment to extract extension (e.g. `.zip`) and append to `mDownloadFilename`
- **Bug fixed:** `Turnip_MTR_v2.0.0-b_Axxx` and `Turnip_MTR_v2.0.0-p_Axxx` both stripped to `Turnip_MTR_v2.0` by `stripExt()` because the cache filename had no real extension — `stripExt()` found the last `.` inside the version number instead
- **Fix:** cache file now saved as `Turnip_MTR_v2.0.0-b_Axxx.zip`; `stripExt()` correctly strips `.zip`; both variants get distinct names and coexist in GameHub menus
- `.locals 2` → `.locals 4` in `onItemClick` to accommodate v2/v3 used for extension extraction

### Files changed
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentDownloadActivity.smali` [MOD]

---

## [pre] — v2.3.2-pre — Roll-up pre-release: all changes since v2.3.0 stable (2026-03-16)
**Commit:** `9849bd9`  |  **Tag:** v2.3.2-pre  |  **CI:** ✓ (run `23145292442`)
> **All v2.3.1-pre* releases and tags (pre through pre11) deleted from GitHub — superseded by this release.**

### What this release contains (all changes since v2.3.0)
- In-app Component Downloader (ComponentDownloadActivity) — 3-level nav: repo → category → asset
- 5 GPU driver repos + Arihany WCPHub: Kimchi / StevenMXZ / MTR / Whitebelyash (all via $9 flat JSON array)
- Fix: blank component name after ZIP inject (`getDisplayName` fallback to `Uri.getLastPathSegment` for file:// URIs)
- `$7` KimchiDriversRunnable (releases[] format), `$8` SingleReleaseRunnable (tags API), `$9` GpuDriversFetchRunnable (flat array)
- `detectType()` +qualcomm keyword → GPU type (0xa)

---

## ~~[feat] — v2.3.1-pre11 — Rename MTR Drivers; add Whitebelyash GPU Drivers (2026-03-16)~~
**Commit:** `42b2435`  |  ~~Tag: v2.3.1-pre11~~ DELETED — superseded by v2.3.2-pre

### What changed
- Renamed "MTR Drivers" → "MTR GPU Drivers" (label + status text)
- Added "Whitebelyash GPU Drivers" (sw0_4) → `white_drivers.json` flat array via `$9`
- `showRepos()`: 5→6 items; Back at index 5
- `sw0_data`: extended to 5 entries

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity.smali`

---

## ~~[feat] — v2.3.1-pre10 — Add MTR Drivers repo (2026-03-16)~~
**Commit:** `d2c4ec2`  |  ~~Tag: v2.3.1-pre10~~ DELETED

### What changed
- Added "MTR Drivers" (sw0_3) → `mtr_drivers.json` flat array via `$9` GpuDriversFetchRunnable
- `showRepos()`: 4→5 items; Back at index 4
- `sw0_data`: extended to 4 entries

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity.smali`

---

## ~~[feat] — v2.3.1-pre9 — Split GPU Drivers into Kimchi and StevenMXZ repos (2026-03-16)~~
**Commit:** `5989ef4`  |  ~~Tag: v2.3.1-pre9~~ DELETED

### What changed
- Removed combined "GPU Drivers (Kimchi+StevenMXZ)" repo
- Added "Kimchi GPU Drivers" (sw0_1) → `kimchi_drivers.json` flat array
- Added "StevenMXZ GPU Drivers" (sw0_2) → `stevenmxz_drivers.json` flat array
- Both use `startFetchGpuDrivers()` / `$9` GpuDriversFetchRunnable (same flat JSON array format)
- `showRepos()`: 3→4 items; Back now at index 3
- `sw0_data`: extended from 2→3 entries

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` — showRepos(), sw0_1, new sw0_2, sw0_data

---

## ~~[fix] — v2.3.1-pre8 — Fix blank component name after ZIP inject (2026-03-16)~~
**Commit:** `a893204`  |  ~~Tag: v2.3.1-pre8~~ DELETED

### Root cause
`getDisplayName(ctx, uri)` queries ContentResolver `_display_name`. For `file://` URIs created by `Uri.fromFile()` (used by $3 DownloadRunnable after caching to cacheDir), ContentResolver returns null cursor → `v7 = ""` → `stripExt("") = ""` → blank name in toast and GameHub's component list.

### Fix
Modified `getDisplayName` to fall back to `uri.getLastPathSegment()` when ContentResolver returns empty. This returns the cached filename (e.g. `"v840 — Qualcomm_840_adpkg.zip"`) for file:// URIs. `stripExt()` then gives `"v840 — Qualcomm_840_adpkg"` as the component name. Also fixed the exception handler path (same fallback applied when ContentResolver throws).

### Files touched
- `patches/smali_classes16/.../ComponentInjectorHelper.smali` — `getDisplayName()`: fallback to `Uri.getLastPathSegment()` at `:ret` and `:dn_err`

---

## ~~[pre] — v2.3.1-pre3 — Switch Kimchi to Nightlies drivers.json mirror (2026-03-16)~~
**Commit:** `2b7c3a5`  |  ~~Tag: v2.3.1-pre3~~ DELETED

### What changed
- `$7` now fetches `Nightlies/kimchi/drivers.json` instead of GitHub Releases API
- JSON format: root JSONObject → `releases[]`, each with `tag` + `assets[]` with `mirror_url`
- Repo label: "Kimchi GPU Drivers"; status: "Fetching Kimchi GPU Drivers..."
- 154 releases / 200 assets, served from Nightlies mirror (no API rate limits)

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity$7.smali` — KimchiDriversRunnable (parse JSONObject root, `tag`/`mirror_url` fields)
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` — repo label + URL in sw0_1

---

## ~~[pre] — v2.3.1-pre2 — Fix $7 register limit (2026-03-16)~~
**Commit:** `07aa664`  |  ~~Tag: v2.3.1-pre2~~ DELETED

### What changed
- `.locals 15` (not 16) so p0 maps to v15 within 4-bit instruction range
- v5 reused as asset url after responseStr consumed into JSONArray

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity$7.smali`

---

## [beta] — v2.3.1-beta7 — Add K11MCH1 AdrenoToolsDrivers repo (2026-03-16)
**Commit:** `07e0583`  |  **Tag:** v2.3.1-beta7

### What changed
- Added K11MCH1 AdrenoToolsDrivers as 2nd repo in component downloader
- New `$7` (AllReleasesRunnable): fetches all GitHub releases (`?per_page=100`), iterates every release's assets array, labels each entry as `"tagName / assetName"`, accepts `.wcp`/`.zip`/`.xz`
- Added `startFetchAllReleases(String)` method wiring to `$7`
- `showRepos()` expanded 2→3 items: Arihany WCPHub / K11MCH1 AdrenoToolsDrivers / ← Back
- `sw0_1` handler + `sw0_data` packed-switch extended to 2 entries
- Assets appear under "GPU Driver / Turnip" category (detectType matches "adreno" in filename)

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` — showRepos(), sw0_1 handler, sw0_data, startFetchAllReleases()
- `patches/smali_classes16/.../ComponentDownloadActivity$7.smali` (new — AllReleasesRunnable)

---

## [beta] — v2.3.1-beta6 — Add StevenMXZ repo (2026-03-16)
**Commit:** `1f4a628`  |  **Tag:** v2.3.1-beta6  |  **CI run:** `23123530054` (✓, Normal APK, package=`banner.hub`)

### What changed
- StevenMXZ added as second repo (contents.json — same flat array format as Arihany pack.json)
- Repo list: Arihany WCPHub / StevenMXZ / ← Back

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` — showRepos() 2→3 items, sw0_1 added, sw0_data extended

---

## ~~[pre] — v2.3.1-pre — Promote to pre-release (2026-03-16)~~
**Commit:** `3afd2c2`  |  ~~Tag: v2.3.1-pre~~ DELETED

### What changed
- beta5 deleted and retagged as v2.3.1-pre
- Release description lists all changes since v2.3.0 stable

---

## [beta] — v2.3.1-beta5 — Remove Nightlies repo, Arihany only (2026-03-16)
**Commit:** `b0cf210`  |  **Tag:** v2.3.1-beta5  |  **CI run:** `23123388373` (✓, Normal APK, package=`banner.hub`)

### What changed
- Removed "Nightlies by The412Banner" from showRepos() array and sw0 switch (array 3→2, sw0_1 deleted, sw0_0 now = Arihany)
- Deleted GitHub releases for beta1/beta2/beta3 (tags already removed)

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` — showRepos() + sw0 switch table

---

## [beta] — v2.3.1-beta4 — Fix Arihany: switch to pack.json format (2026-03-16)
**Commit:** `71f74fd`  |  **Tag:** v2.3.1-beta4  |  **CI run:** `23123229797` (✓, Normal APK, package=`banner.hub`)

### What changed
- Arihany WCPHub had no `nightly-*` tagged releases, so `$1` (GitHub Releases API fetch) returned nothing
- New `$6` (PackJsonFetchRunnable): fetches `https://raw.githubusercontent.com/Arihany/WinlatorWCPHub/refs/heads/main/pack.json` (flat JSONArray with type/verName/remoteUrl fields)
- Skips entries where `type` = "Wine" or "Proton" (no known GameHub type int for these)
- Extracts filename from last URL path segment (e.g., "box64-bionic-0.3.8.wcp") for detectType compatibility
- Added `startFetchPackJson(String)` method to ComponentDownloadActivity; sw0_1 now calls it

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` — added startFetchPackJson() + updated sw0_1 URL and method call
- `patches/smali_classes16/.../ComponentDownloadActivity$6.smali` (new — PackJsonFetchRunnable)

---

## [beta] — v2.3.1-beta3 — Add Arihany WCPHub repo (2026-03-16)
**Commit:** `8b9e920`  |  **Tag:** v2.3.1-beta3  |  **CI run:** `23122849126` (✓ 3m35s, Normal APK, package=`banner.hub`)

### What changed
- Arihany WCPHub added as second repo option in Download from Online Repos screen (`https://api.github.com/repos/Arihany/WinlatorWCPHub/releases`)
- Repo array size 2→3; `sw0_1` switch case added; `sw0_data` packed-switch extended to 2 entries

### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` — showRepos() + onItemClick sw0_1 + sw0_data

---

## [beta] — v2.3.1-beta2 — Case-insensitive detectType (2026-03-16)
**Commit:** `e2887e1`  |  **Tag:** v2.3.1-beta2  |  **CI run:** `23122723773` (✓ 3m54s, Normal APK, package=`banner.hub`)

### What changed
- `detectType()` already had `toLowerCase()` from commit `14a9471` — confirmed correct. Tagged beta2 as clean release separate from beta1 iterations.
- No code changes from beta1; this tag exists to give users a stable, clearly-named release to test.

### Files touched
- `PROGRESS_LOG.md` only

---

## [beta] — v2.3.1-beta1 — Multi-repo/category component downloader (2026-03-15)
**Commit:** `14a9471`  |  **Tag:** v2.3.1-beta1 (retagged)  |  **CI run:** `23122285193` (✓ 3m42s, Normal APK, package=`banner.hub`)

### What changed
- "↓ Download from Online Repos" replaces the old single-repo entry — launches ComponentDownloadActivity with a 3-level navigation flow
- **Level 1 — Repo selection:** "Nightlies by The412Banner" → fetches `https://api.github.com/repos/The412Banner/Nightlies/releases`
- **Level 2 — Category selection:** DXVK / VKD3D-Proton / Box64 / FEXCore / GPU Driver / Turnip (with ← Back)
- **Level 3 — Asset list:** filtered by `detectType()` match; tap to download and inject; empty category shows toast and stays on category screen
- `$1` FetchRunnable parameterized with `val$url` — passes URL from `startFetch(String)` instead of hardcoding
- `$2` ShowCategoriesRunnable now just calls `showCategories()` (moved ArrayAdapter setup inside the method)
- `$5` InjectRunnable created to run `injectComponent` on UI thread (Looper crash fix from prior commit preserved)
- `onBackPressed()`: mode 2 → showCategories, mode 1 → showRepos, mode 0 → super

### Files touched
- `patches/smali_classes16/.../ComponentManagerActivity.smali` — showTypeSelection 6→7 items + "Download from Online Repos" label
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` — full rewrite: 3-mode navigation, showRepos/showCategories/showAssets, startFetch(String)
- `patches/smali_classes16/.../ComponentDownloadActivity$1.smali` — parameterized with val$url field
- `patches/smali_classes16/.../ComponentDownloadActivity$2.smali` — simplified to call showCategories()

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
**Commit:** `1cdc468`  |  **Tag:** v2.3.1-beta1 (retagged at `407bedf`)  |  **CI run:** `23121795097` (Normal APK, package=`banner.hub`)

### Bug fixes
- `$3` (DownloadRunnable): moved `injectComponent` call out of background thread into new `$5` (InjectRunnable) posted via `runOnUiThread` — fixes "Can't toast on a thread that has not called Looper.prepare()" crash
- `$5.smali`: fixed trailing `;` on primitive `iput`/`iget` type descriptor (smali parse error)

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

### [feat] — CPU core dialog: 2×4 grid (TableLayout, row 0=Eff, row 1=Perf/Prime) — v2.4.2-beta9 (2026-03-17)
**Commit:** `158d98c`  |  **Tag:** v2.4.2-beta9  |  **CI:** ✅
#### What changed
- **`CpuMultiSelectHelper.smali`**: Replaced `setMultiChoiceItems` (vertical list) with `setView(tableLayout)`. TableLayout has 2 TableRows of 4 CheckBoxes. `setStretchAllColumns(true)` for equal column widths. Each CheckBox inits from `checked[]` and gets a `$4` listener.
- **`CpuMultiSelectHelper$4.smali`** (new): `CompoundButton.OnCheckedChangeListener` capturing `(boolean[], int)`. `onCheckedChanged` stores the new boolean into `a[b]` — keeps `checked[]` in sync for `$2` Apply to read.
#### Files touched
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali`
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$4.smali` (new)

---

### [feat] — CPU core dialog: warn if no cores selected on Apply — v2.4.2-beta8c (2026-03-17)
**Commit:** `23e8470`  |  **Tag:** v2.4.2-beta8c  |  **CI:** ✅
#### What changed
- **`CpuMultiSelectHelper$2.smali`**: If all checkboxes are unchecked when Apply is tapped, shows Toast "Select at least one core" and returns without saving. Uses `move-object/from16 v4, p1` to get the dialog's Context (p1=v34 with `.locals 33`, out of 4-bit range for regular `move-object`).
#### Files touched
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali`

---

### [fix] — CPU core dialog: half-width, 90% height, all-cores = No Limit — v2.4.2-beta7 (2026-03-17)
**Commit:** `3fab423`  |  **Tag:** v2.4.2-beta7  |  **CI:** ✅ run 23353066650
#### What changed
- **`CpuMultiSelectHelper.smali`**: `Window.setLayout()` now uses `widthPixels / 2` (half-wide) and `heightPixels * 9/10` (90% tall). Was `WRAP_CONTENT` wide and 80% tall.
- **`CpuMultiSelectHelper$2.smali`**: After bitmask fold, if all 8 cores are checked (mask=0xFF), saves 0 (No Limit) instead of 0xFF. Semantically identical behavior to the "No Limit" button.
#### Files touched
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali`
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali`

---

### [fix] — Fix IllegalAccessError: use Kotlin defaults ctor + move-object/from16 — v2.4.2-beta6b (2026-03-17)
**Commit:** `e8e41a8`  |  **Tag:** v2.4.2-beta6b  |  **CI:** ✅
#### What changed
- **`CpuMultiSelectHelper$2.smali`**: Replaced `iput id/isSelected` with full Kotlin defaults constructor (`invoke-direct/range {v7..v32}`, bitmask `0x3ffffa`). Added `move-object/from16 v3, p0` — required because `.locals 33` pushes `p0` to `v33` (out of 4-bit range for `iget-object`).
- **`CpuMultiSelectHelper$3.smali`**: Same fix, `move-object/from16 v6, p0`, `id=0` for No Limit.
#### Root cause
ART 14 blocks cross-dex private field access. `DialogSettingListItemEntity` is in classes12 (bypassed dex); our code is in classes16. Direct `iput` on private backing fields threw `IllegalAccessError`. Fix: use the public Kotlin defaults constructor.
#### Files touched
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali`
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$3.smali`

---

### [stable] — v2.4.3 — Per-game CPU core affinity + VRAM unlock + offline fixes (2026-03-17)
**Commit:** `77d3a9a`  |  **Tag:** v2.4.3  |  **CI:** ✅ build.yml — 8 APKs
#### What's new since v2.4.0
- Per-game CPU Core Affinity multi-select dialog (setMultiChoiceItems, Html small labels, half-width, 90% height)
  - Apply saves bitmask; No Limit saves 0; Cancel discards
  - All cores checked = No Limit; no cores = Toast warning
  - Immediate UI refresh via Kotlin defaults constructor
- VRAM unlock: 6/8/12/16 GB options with display text + checkmark fix
- Offline PC game settings: catches NoCacheException, loads from cache
#### All beta tags deleted after stable build (v2.4.2-beta1 through beta12)

---

## Planned Work

- [ ] Confirm v2.0.6-pre: ZIP (flat) works, WCP zstd (DXVK/VKD3D) works, WCP XZ (FEX) works
- [ ] Once all three confirmed working, cut stable v2.1.0 release
- [ ] Explore contributing functional patches to `playday3008/gamehub-patches` PR #13

---

### [pre] — v2.4.4-pre — Sustained Performance Mode toggle (2026-03-18)
**Commit:** TBD  |  **Tag:** v2.4.4-pre  |  **Branch:** main
**What changed:** Added ⚡ Sustained Perf: ON/OFF toggle as first item in ComponentManagerActivity list. Tapping toggles `sustained_perf` in `bh_prefs` SharedPreferences and shows a toast. WineActivity.onCreate() reads the flag (after :cond_perf_1) and calls `window.setSustainedPerformanceMode(true)` if enabled.
**Files touched:** `patches/smali_classes16/.../ComponentManagerActivity.smali`, `patches/smali_classes15/.../WineActivity.smali`, `COMPONENT_MANAGER_BUILD_LOG.md`, `PROGRESS_LOG.md`

### v2.4.6-pre — 2026-03-18
**Commit:** `60cafd9` | **CI:** ✅
- Moved Sustained Performance Mode toggle from Components menu to in-game sidebar (Controls tab)
- Takes effect immediately while in-game; saves to bh_prefs/sustained_perf
- ComponentManagerActivity list offsets corrected (Add New = pos 0, dirs = 1+, Remove All = last)

### v2.4.7-pre — 2026-03-18
**Commit:** `2ab8f7a` | **CI:** ✅
- Moved Sustained Performance + added Max Adreno Clocks to Performance sidebar tab
- Max Adreno Clocks: root-only, locks kgsl-3d0 min_freq = max_freq; persists across launches
- Used BhPerfSetupDelegate (smali_classes16 view) to avoid classes9 dex limit

### [fix] — v2.5.4-pre — VerifyError crash + perf toggles activate after root grant (2026-03-20)
**Commit:** `5182488` | **Tag:** v2.5.4-pre | **CI:** ✅ run 23342648406 — PASSED
#### What changed
- **`BhRootGrantHelper$2$1$1.smali`**: `iput` → `iput-boolean` for boolean field `b:Z` in constructor.
  ART's verifier rejected the class at load time — VerifyError crashed the app on the grant thread.
- **`BhPerfSetupDelegate.smali`**: Added `onVisibilityChanged(View, int)`. Fires every time the
  Performance sidebar tab becomes visible. Re-reads `root_granted` from bh_prefs and either:
  - Grants: restores alpha to 1.0f, wires SustainedPerfSwitchClickListener + MaxAdrenoClickListener
  - Denied: greys out at 0.5f, no listeners set
  Previously `onAttachedToWindow()` ran only once — root granted later never updated the UI.
#### Files touched
- `patches/smali_classes16/com/xj/winemu/sidebar/BhRootGrantHelper$2$1$1.smali`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`

### [stable] — v2.6.1 — Fix perf toggle visual state persistence (2026-03-20)
**Commit:** `c8ebfdc` | **Tag:** v2.6.1 | **CI:** ✅
- Promotes v2.6.1-pre to stable
- Fix: Sustained Perf + Max Adreno Clocks toggles now persist visual state across sidebar open/close
- Pref save moved into click listeners so SharedPreferences is always accessible
- Credits section added to README; repo links for Arihany and Nightlies sources added

### [fix] — v2.6.1-pre — Fix perf toggles not persisting visual state (2026-03-20)
**Commit:** `4fd439d` | **Tag:** v2.6.1-pre | **CI:** ✅ run 23353066650
- Performance toggles (Sustained Perf, Max Adreno Clocks) showed as OFF when Performance sidebar was reopened, even though the system effects were actually applied
- Root cause: WineActivity.toggleSustainedPerf/toggleMaxAdreno only saved bh_prefs when WineActivity.t1 was non-null; t1 is set in i2(Z)V which isn't guaranteed to have run when the toggle fires
- Fix: moved pref saving into SustainedPerfSwitchClickListener and MaxAdrenoClickListener — both have a View with context, so getSharedPreferences always works
- WineActivity.toggleSustainedPerf now only calls setSustainedPerformanceMode (still needs Window from t1); toggleMaxAdreno goes straight to su root command
- **Logcat verified:** `logcat-2026-03-20_12-58-55.txt` — no errors from v2.6.1-pre; fix confirmed working by user

---

### [pre] — v2.6.7-pre — Fix buildUI() VerifyError: .locals 5 p0=v5 collision (2026-03-20)
**Commit:** `18268e5`  |  **Tag:** v2.6.7-pre
#### What changed
- buildUI() crashed with VerifyError at offset [0x32]: "tried to get class from non-reference register v5 (type=IntegerConstant)"
- Root cause: `.locals 5` made p0 (this) map to v5. `const/high16 v5, 0x3f800000` (1.0f for LayoutParams weight) overwrote p0/v5 with an integer constant, corrupting the `this` reference for all subsequent p0 uses
- Fix: `.locals 5` → `.locals 6` in buildUI(); p0 now maps to v6 (never written), v5 is a proper local register
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali` — `.locals 5` → `.locals 6` in buildUI()
- `PROGRESS_LOG.md` — this entry

---

### [pre] — v2.6.8-pre — Fix IllegalAccessError: private fields inaccessible to inner classes (2026-03-20)
**Commit:** `5258d1c`  |  **Tag:** v2.6.8-pre
#### What changed
- Inject flow crashed: IllegalAccessError: Field 'ComponentManagerActivity.selectedType' is inaccessible to class 'ComponentManagerActivity$6'
- Root cause: inner classes $4/$5/$6 use iget/iput to access outer-class fields (pendingUri, pendingType, mode, selectedType) which were declared .field private. ART enforces Java access rules — private fields require synthetic accessor methods, not direct iget/iput from inner classes
- Fix: changed all 9 fields from .field private to .field public
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali` — 9 fields private→public
- `PROGRESS_LOG.md` — this entry

---

### [pre] — v2.6.9-pre — Dark navy UI for ComponentDownloadActivity (2026-03-20)
**Commit:** `581eb9a`  |  **Tag:** v2.6.9-pre
#### What changed
- ComponentDownloadActivity (download flow: repo → category → asset) redesigned to match dark navy theme
- Root: 0xFF1A1A2E bg, fitsSystemWindows; header bar 0xFF16213E with ← back btn (orange, onBackPressed) + title (white, weight=1)
- Status text: gray 0xFFAAAAAA, 14sp; ListView: dark bg; items via DarkAdapter (0xFF1E1E35 bg, white text, orange ← Back)
- New: ComponentDownloadActivity$DarkAdapter, ComponentDownloadActivity$BhBackBtn
- Added dp(I)I helper to ComponentDownloadActivity
#### Files touched
- `patches/smali_classes16/.../ComponentDownloadActivity.smali` — new onCreate UI, DarkAdapter swap in showRepos/showCategories/showAssets, dp() added
- `patches/smali_classes16/.../ComponentDownloadActivity$DarkAdapter.smali` — new
- `patches/smali_classes16/.../ComponentDownloadActivity$BhBackBtn.smali` — new
- `PROGRESS_LOG.md` — this entry

### v2.7.0-pre — Black dark mode UI redesign (2026-03-20)
**Commit:** `51fbaf9` | **Tag:** v2.7.0-pre

**What changed:**
- Root/RecyclerView/ListView background: deep black `0xFF0D0D0D` (was dark navy)
- Header/bottom bar background: dark grey `0xFF161616` (was blue-tinted dark)
- Title text ("Component Manager", "Download Components"): orange `0xFFFF9800`
- Status/hint text: darker grey `0xFF888888` (was `0xFFAAAAAA`)
- Item text: off-white `0xFFF0F0F0` (was `0xFFFFFFFF`)
- Removed search bar from ComponentManagerActivity
- Blue + green buttons unified to orange, 48dp → 32dp height, weight → WRAP_CONTENT (left-aligned)
- Buttons have 16dp H / 8dp V padding via makeBtn()
- DarkAdapter item background: StateListDrawable (pressed=`0xFF090909`, D-pad selected=`0xFF241A06`, default=`0xFF1A1A1A`)
- ListView selector: semi-transparent orange `0x40FF9800` for D-pad/controller navigation highlight

### v2.7.1-pre — Buttons to header, D-pad selection fix (2026-03-20)
**Commit:** `1a85189` | **Tag:** v2.7.1-pre

**What changed:**
- Removed bottom bar from ComponentManagerActivity entirely
- "+ Add" and "↓ DL" buttons moved into the header bar, right side (before ✕ All)
- makeBtn() padding: 16dp H/8dp V → 8dp H/4dp V (compact for header)
- BhComponentAdapter cards: setFocusable(true) + StateListDrawable foreground (focused=orange overlay 0x60FF9800, pressed=dark overlay, default=transparent) — D-pad navigation now shows clear orange highlight on RecyclerView cards
- DarkAdapter: added state_focused entry, changed selected/focused color from 0xFF241A06 → 0xFF3D2800 (visible amber for D-pad on ListView)

---

### v2.7.2-pre — Header button shift center-right + card outline dividers (2026-03-20)
**Commit:** `6b46084` | **Tag:** v2.7.2-pre | **CI:** ✅ Normal APK built

**What changed:**
- ComponentManagerActivity.buildHeader(): added weight=0.5 flex spacer View between "↓ DL" button and "✕ All" button — shifts "+" and "↓" from hard-right to approx 67% from left (center-right)
- BhComponentAdapter.onCreateViewHolder(): increased .locals 13→14; added GradientDrawable.setStroke(1dp, 0xFF2E2E45) on each card background — very thin rounded outline acting as visual separator between cards

**Files touched:**
- `patches/smali_classes16/.../ComponentManagerActivity.smali`
- `patches/smali_classes16/.../BhComponentAdapter.smali`

---

### v2.7.3-pre — Fix broken card rendering; 8dp margin card separation (2026-03-20)
**Commit:** `faf7704` | **Tag:** v2.7.3-pre | **CI:** ✅ Normal APK built

**Root cause:** setStroke(II)V call in onCreateViewHolder caused a silent exception caught by RecyclerView, resulting in zero items rendered (all 8 cards invisible). `.locals 14` change was also unnecessary.

**What changed:**
- BhComponentAdapter: reverted `.locals 14` → `.locals 13`
- Removed `GradientDrawable.setStroke()` call (caused silent card rendering failure)
- Card margin changed from 12/4/12/4 → 12/8/12/8 dp (8dp top+bottom gives clear visual gap between cards without setStroke)

**Files touched:**
- `patches/smali_classes16/.../BhComponentAdapter.smali`

---

### v2.7.4-pre — Rollback to v2.7.0-pre UI state (2026-03-20)
**Commit:** `b9e2fc4` | **Tag:** v2.7.4-pre | **CI:** ✅ Normal APK built

**What changed:** Reverted ComponentManagerActivity, BhComponentAdapter, ComponentDownloadActivity$DarkAdapter back to v2.7.0-pre baseline. All v2.7.1/2.7.2/2.7.3 changes removed.

---

### v2.7.5-pre — Buttons to header center-right + card outline border (2026-03-20)
**Commit:** `f6ab3e3` | **Tag:** v2.7.5-pre | **CI:** ✅ Normal APK built

**What changed:**
- buildUI(): bottom bar removed
- buildHeader(): + Add and ↓ DL buttons inserted before ✕ All; weight=0.5 flex spacer between ↓ DL and ✕ All → buttons sit center-right
- makeBtn(): compact padding 16/8dp → 8/4dp (fits in header)
- BhComponentAdapter.onCreateViewHolder: setStroke(1dp, 0xFF3A3A55) using v8 as temp register (v8 is unassigned at that point — no .locals change, no register collision)

---

### v2.7.6-pre — Fix: remove setStroke, 8dp card margins (2026-03-21)
**Commit:** `f0d8fe4` | **Tag:** v2.7.6-pre | **CI:** ✅ run 23369306581

**What changed:**
- BhComponentAdapter.onCreateViewHolder: removed the 6-line setStroke block (dp(1) + const color + setStroke call)
- Card margins changed from 12/4/12/4 → 12/8/12/8 dp (v3→v4 for top/bottom)

**Root cause:** Same failure as v2.7.2/v2.7.3: GradientDrawable.setStroke(II)V in onCreateViewHolder is silently caught by RecyclerView in this GameHub version, causing 0 cards rendered. setStroke on a card GradientDrawable inside onCreateViewHolder must not be used here.
