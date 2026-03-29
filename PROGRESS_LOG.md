# BannerHub Progress Log

Tracks every commit, patch, and change applied to the GameHub 5.3.5 ReVanced APK rebuild.

---

## [ci] — amazon-integration branch — artifact-only workflow added (2026-03-29)
**Branch:** `amazon-integration`  |  **Commit:** `aa7413f35`
**CI:** run 23705798906 (in progress)
**What changed:** Added build-amazon.yml — triggers on push to amazon-integration; builds BannerHub-amazon-{SHA}.apk; uploads as Actions artifact (30-day retention); no release created.
#### Files touched
- `.github/workflows/build-amazon.yml`

---

## [fix] — v2.7.6-pre — offline component picker fix (2026-03-29)
**Branch:** `main`  |  **Tag:** v2.7.6-pre
**Commit:** `8e0160aa9`  |  **CI:** ✅ run 23697679345 (Quick — Normal only)
**What changed:** appendLocalComponents: lazily init EmuComponents via Companion.b(Application) if singleton is null — fixes empty component list when offline/before first game launch.
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali`

---

## [stable] — v2.7.5 — Winlator HUD overlay + opacity slider (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5
**Commit:** `2a4bae8a7`  |  **CI:** ✅ run 23695765757 (9 APKs)
**What changed:** Full Winlator HUD overlay: live stats, tap H/V toggle, drag reposition, opacity slider, text outline at low opacity. See release notes for full feature list.

---

## [fix] — v2.7.5-pre30 — combine stroke + shadow below 10% opacity (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre30
**Commit:** `cfe330d31`  |  **CI:** queued
**What changed:** Shadow 4f now applies for all opacity<30 (including <10 where stroke outline is also active). Three tiers: <10% stroke+shadow, 10-29% shadow only, ≥30% clear.
#### Files touched
- `extension/BhFrameRating.java`

---

## [feat] — v2.7.5-pre29 — OutlinedTextView stroke outline below 10% opacity (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre29
**Commit:** `2b9a3dd4c`  |  **CI:** queued
**What changed:** OutlinedTextView inner class draws STROKE pass then fill pass in onDraw(). Three tiers in applyBackgroundOpacity: <10% stroke outline, 10-29% shadow 4f, ≥30% clear.
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre28 — text outline radius 2.5f→4f (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre28
**Commit:** `059dc9a7e`  |  **CI:** queued
**What changed:** Shadow radius 2.5f→4f — full black halo around text below 30% opacity.
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre27 — text outline radius 1.5f→2.5f (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre27
**Commit:** `016883bb9`  |  **CI:** queued
**What changed:** Shadow radius increased from 1.5f to 2.5f.
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre26 — tighten text outline radius 3f→1.5f (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre26
**Commit:** `a3e84a87c`  |  **CI:** queued
**What changed:** Shadow radius reduced from 3f to 1.5f — denser, sharper black outline below 30% opacity.
#### Files touched
- `extension/BhFrameRating.java`

---

## [feat] — v2.7.5-pre25 — black text outline below 30% opacity (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre25
**Commit:** `e788691bb`  |  **CI:** queued
**What changed:** applyBackgroundOpacity() calls setShadowLayer(3f,0,0,black) on all TextViews when opacity<30, clears otherwise. BhHudOpacityListener simplified to delegate to this method.
#### Files touched
- `extension/BhFrameRating.java`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhHudOpacityListener.smali`

---

## [feat] — v2.7.5-pre24 — solid text; bg-only transparency; persist position+orientation (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre24
**Commit:** `8f1884660`  |  **CI:** queued
**What changed:** applyBackgroundOpacity() changes background alpha only (text stays opaque). HUD persists hud_vertical, hud_pos_x, hud_pos_y to bh_prefs and restores on attach. BhHudOpacityListener uses Color.argb + setBackgroundColor.
#### Files touched
- `extension/BhFrameRating.java`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhHudOpacityListener.smali`

---

## [feat] — v2.7.5-pre23 — HUD Opacity slider in Performance sidebar (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre23
**Commit:** `f56405f9c`  |  **CI:** queued
**What changed:** "HUD Opacity" label + SeekBar (0-100, default 80) added below Extra Detailed checkbox. BhHudOpacityListener saves pref + sets alpha on BhFrameRating. BhFrameRating.onAttachedToWindow restores opacity.
#### Files touched
- `patches/smali_classes16/com/xj/winemu/sidebar/BhHudOpacityListener.smali` (new)
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre22 — gray out Extra Detailed checkbox (coming soon) (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre22
**Commit:** `e373e10b7`  |  **CI:** queued
**What changed:** Extra Detailed checkbox: text → "Extra Detailed (coming soon)", color gray (0xFF888888), force-unchecked, setEnabled(false), listener removed.
#### Files touched
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`

---

## [fix] — v2.7.5-pre21 — remove tvTimeH; time after API in both modes (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre21
**Commit:** `fa3f53960`  |  **CI:** queued
**What changed:** Removed duplicate tvTimeH field and all references. tvTimeV (placed after API | sep in constructor) now handles time display in both horizontal and vertical modes.
#### Files touched
- `extension/BhFrameRating.java`

---

## [feat] — v2.7.5-pre20 — time in main bar + fonts +1sp (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre20
**Commit:** `378390d90`  |  **CI:** queued
**What changed:** tvTimeH after graph (horizontal); tvTimeV under API (vertical); both update every second; main font 8→9sp; extra detail 7→8sp
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre19 — translationY replaces topMargin, eliminates height constraint (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre19
**Commit:** `45c267b03`  |  **CI:** queued
**What changed:**
- Root fix for vertical+detailed clipping: topMargin stays 0; vertical position uses setTranslationY(). FrameLayout always measures with AT_MOST screenH. Drag and reclampPosition both updated to use translationY.
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre18 — fonts 9→8sp / 8→7sp; FPS graph 40→20dp (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre18
**Commit:** `88fcc90f8`  |  **CI:** queued
**What changed:** Main labels 9→8sp; extra detail 8→7sp; FPS graph vertical height 40→20dp
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre17 — remove MHz from cores, font 10→9sp / 9→8sp (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre17
**Commit:** `fff0fd2de`  |  **CI:** queued
**What changed:** CPU core values no longer append MHz; main labels 10→9sp; extra detail 9→8sp
#### Files touched
- `extension/BhFrameRating.java`

---

## [feat] — v2.7.5-pre16 — cores MHz, GPU label+value rows, remove model/temp (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre16
**Commit:** `a6e71d4e1`  |  **CI:** queued
**What changed:** Cores show MHz per row; GPU: label + MHz value on separate rows; removed GPU model, GPU temp, readGpuModel(), readGpuThermal(), readThermalZone()
#### Files touched
- `extension/BhFrameRating.java`

---

## [feat] — v2.7.5-pre15 — remove RAM detail and swap from extra detail (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre15
**Commit:** `d2b07e051`  |  **CI:** queued
**What changed:** Removed tvRamDetail, tvSwap, readRamDetail(), readSwap(), parseMemInfoKb(). Extra detail now: TIME, C0–C7, GPU model/MHz, GPU temp.
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre14 — CPU cores 1 per row (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre14
**Commit:** `7770c98b8`  |  **CI:** queued
**What changed:** CPU cores changed from 2-per-row to 1-per-row (C0–C7 each on own line)
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre13 — synchronous reclamp before layout pass (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre13
**Commit:** `cf275a55d`  |  **CI:** queued
**What changed:**
- `reclampPosition()` now synchronous: measures unconstrained immediately after orientation/visibility changes, fixes topMargin before FrameLayout layout pass runs — no more clip flash
- Pref-change path uses `handler.post` (one frame) then synchronous reclamp
- Removed `postDelayed(32ms)`
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre12 — reclampPosition unconstrained height measure (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre12
**Commit:** `62a577644`  |  **CI:** queued
**What changed:**
- `reclampPosition()` calls `measure(AT_MOST screenW, UNSPECIFIED)` to get natural height before clamping `topMargin` — fixes overlay clipping below CPU cores when positioned low on screen in vertical+extra-detail mode
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre11 — tall-narrow vertical: WRAP_CONTENT, 2-per-row cores, trimmed labels (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre11
**Commit:** `02a31c689`  |  **CI:** queued
**What changed:**
- Removed 220dp fixed width; WRAP_CONTENT in both modes — vertical overlay width driven by content
- CPU cores: 4+4 → 2+2+2+2 (C0/C1, C2/C3, C4/C5, C6/C7)
- GPU info: model and MHz split to two lines; "GPU TMP" → "TMP"; SWAP → "SW --/--G"; RAM format tightened
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre10 — font sizes, fixed vertical width, postDelayed reclamp (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre10
**Commit:** `656ca8a4b`  |  **CI:** queued
**What changed:**
- Main stat labels: 11sp → 10sp; extra detail labels: 10sp → 9sp
- `toggleOrientation()` sets FrameLayout.LayoutParams.width = 220dp in vertical mode (WRAP_CONTENT in horizontal) — fixes extra detail rows being narrow/clipped when overlay is on left side of screen
- `reclampPosition()` switched from OnGlobalLayoutListener to `postDelayed(32ms)` — ensures `getHeight()` reflects the fully settled vertical layout before clamping
#### Files touched
- `extension/BhFrameRating.java`

---

## [fix] — v2.7.5-pre9 — overlay clamp after toggle + TIME at top (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre9
**Commit:** `5d8c8a579`  |  **CI:** ✅ run 23690564881
**What changed:**
- Root cause of left-side clip: clamping only ran during `ACTION_MOVE`. After tapping to toggle vertical mode (overlay grows tall) or after extra detail first appears, no re-clamp fired → overlay extended below screen bottom.
- Fix: `reclampPosition()` method added; uses `OnGlobalLayoutListener` (one-shot, self-removing) to re-clamp after layout settles. Called from `toggleOrientation()` and after extra detail visibility change.
- TIME row moved to first position in `extraDetailGroup` (right after divider) — immediately visible without scrolling past CPU cores / GPU stats.
#### Files touched
- `extension/BhFrameRating.java`

---

## [pre] — v2.7.5-pre9 — fix: clamp overlay to screen edges during drag (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre9
**Commit:** `a94c37c0f`  |  **CI:** ✅ run 23690132917
**What changed:**
- `ACTION_MOVE` now clamps leftMargin/topMargin after each drag step using `v.getRootView()` dimensions
- All four edges clamped: left/top ≥ 0; right: leftMargin + width ≤ screenW; bottom: topMargin + height ≤ screenH
- Deleted pre1–pre7 releases and tags from GitHub
#### Files touched
- `extension/BhFrameRating.java`

---

## [pre] — v2.7.5-pre8 — refactor: pre6 vertical layout restored, BAT%/SKN/FAN removed (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre8
**Commit:** `2937d8939`  |  **CI:** ✅ run 23689895717
**What changed:**
- BhFrameRating reverted to pre6 structure (toggles H↔V on self, original MATCH_PARENT extraDetailGroup)
- Extra detail only visible in vertical mode (`isVertical` guard restored)
- Removed: `tvBatPct`, `tvSkn`, `tvFan` fields, constructor rows, data reads, setText calls
- Removed methods: `readBatPercent()`, `readSkinTemp()`, `readFanSpeed()`
- Extra detail fields remaining: CPU cores, GPU info, GPU temp, RAM GB, SWAP, TIME
#### Files touched
- `extension/BhFrameRating.java`

---

## [pre] — v2.7.5-pre7 — fix: widen overlay + show extra detail in horizontal mode (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre7
**Commit:** `aaeab7e32`  |  **CI:** ✅ run 23689573696
**What changed:**
- Outer BhFrameRating is now always VERTICAL; inner `mainRow` LinearLayout holds stats and toggles H↔V on tap — extra detail block sits below in both orientations
- Extra detail labels (except tvCpuCores) use `setSingleLine(true)` + `setEllipsize(END)`: no wrapping, container naturally grows to fit the longest line
- Removed all `isVertical` guards from extraDetailGroup visibility — extra detail shows in both modes
- `extraDetailGroup` LayoutParams: WRAP_CONTENT (was MATCH_PARENT, broken under new outer layout)
#### Files touched
- `extension/BhFrameRating.java`

---

## [pre] — v2.7.5-pre6 — fix: VerifyError crash opening Performance tab (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre6
**Commit:** `bc18a57c9`  |  **CI:** ✅ run 23689336694
**What changed:**
- Root cause: `:cond_hud_switch_exists` is a join point reached by paths both with and without `check-cast v0, ViewGroup`. Verifier merges to common supertype `View`. My `addView()` on `ViewGroup` with a `View`-typed register → VerifyError crash when opening the Performance sidebar
- Fix: `check-cast v0, Landroid/view/ViewGroup;` added immediately before the checkbox `addView()` call
#### Files touched
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`

---

## [pre] — v2.7.5-pre5 — feat: Extra Detailed checkbox for Winlator HUD (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre5
**Commit:** `3efcb78ad`  |  **CI:** ✅ run 23689179502
**What changed:**
- "Extra Detailed" CheckBox added below Winlator HUD Style switch in Performance sidebar
- In vertical mode with checkbox on: shows per-core MHz (C0–C7), GPU model+clock, GPU temp, RAM GB, SWAP GB, BAT%, skin temp, fan speed, current time
- `extraDetailGroup` (vertical LinearLayout) appended to BhFrameRating — always GONE in horizontal mode
- `BhHudExtraDetailListener` saves `hud_extra_detail` pref; BhFrameRating reads it each 1s cycle
- `BhPerfSetupDelegate` creates CheckBox tagged `"bh_hud_extra_cb"` with 4dp top margin
#### Files touched
- `extension/BhFrameRating.java`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhHudExtraDetailListener.smali` (new)
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`

---

## [pre] — v2.7.5-pre4 — feat: tap-to-toggle vertical/horizontal FPS overlay (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre4
**Commit:** `1b7994096`  |  **CI:** ✅ run 23688722622
**What changed:**
- Single tap on the overlay (no drag, < 10px movement) toggles between horizontal bar mode and vertical column mode
- `toggleOrientation()`: flips `LinearLayout` orientation, hides `" | "` separators (GONE) in vertical mode, updates `FpsGraphView` LayoutParams, re-centers label gravity
- `sepViews` List populated during construction to track all separator views
- Drag-to-reposition unchanged; `dragMoved` flag prevents tap/drag conflict
#### Files touched
- `extension/BhFrameRating.java`

---

## [pre] — v2.7.5-pre3 — FPS overlay: fix API label reading runtime engine name (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre3
**Commit:** `62aa09c68`  |  **CI:** ✅ run 23687466600
**What changed:**
- Root cause: readApiName() read SP (configured renderer) — game had both DXVK and VKD3D set; DXVK key checked first so always showed DXVK regardless of actual renderer
- Fix: reflect into WineActivity.g → ActivityWineBinding.hudLayer → HUDLayer.b → UnifiedHUDView.a — exact same field original HUD renders; set by Wine at runtime via perf socket callback on first frame
- Shows "API" when field is "N/A" (before first frame presented)
- SharedPreferences import removed
#### Files touched
- `extension/BhFrameRating.java`

---

## [pre] — v2.7.5-pre2 — FPS overlay: CHRG label when charging, strip API version (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre2
**Commit:** `57de19552`  |  **CI:** ✅ run 23687095100
**What changed:**
- BAT label shows "CHRG" when charging/full instead of disappearing; separator always visible
- API label stripped to type-only: "DXVK", "VKD3D", "WineD3D" — no version appended
- Removed `sepBat` field, `showName()` method, and `org.json.JSONObject` import
#### Files touched
- `extension/BhFrameRating.java`

---

## [pre] — v2.7.5-pre1 — FPS overlay: API label, FPS graph, charging detection (2026-03-28)
**Branch:** `main`  |  **Tag:** v2.7.5-pre1
**Commit:** `ffefa9c32`  |  **CI:** ✅ run 23686862934 (3m46s)
**What changed:**
- `tvApi` TextView at far left: reads active renderer from `pc_g_setting{gameId}` SP (same source as GameHub) — `pc_ls_DXVK` → "DXVK name", `pc_ls_VK3k` → "VKD3D name", fallback "WineD3D"; mirrors PcSettingDataEntity.getShowName() logic
- `FpsGraphView` inner class at far right: 30-sample ring buffer, Canvas bar chart, bars shift green→red relative to max FPS in window
- `isCharging()` via ACTION_BATTERY_CHANGED sticky broadcast (same method as HudDataProvider.b()): hides sepBat + tvBat entirely when device is charging or full
#### Files touched
- `extension/BhFrameRating.java`

---

## [pre] — v2.7.4-pre6 — fix: VRam Limit from SharedPreferences (2026-03-27)
**Branch:** `main`  |  **Tag:** v2.7.4-pre6
**Commit:** `2a51abc2b`  |  **CI:** ✅ run 23668107295
**What changed:**
- VRam Limit: switched from readWineEnv("WINEMU_MEMORY_LIMIT") to SharedPreferences — WINEMU_MEMORY_LIMIT not reliably in wine child /proc/environ
- New method getContainerVramInfo(Context): casts to WineActivity → WineActivityData.a (gameId) → SharedPreferences "pc_g_setting"+gameId → getInt("pc_ls_max_memory", 0)
- Returns "XXXX MB", "Unlimited" (0), or "N/A" (exception)
#### Files touched
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTaskManagerFragment.smali`

---

## [pre] — v2.7.4-pre5 — VRam Limit row + Sys RAM rename in Container Info (2026-03-27)
**Branch:** `main`  |  **Tag:** v2.7.4-pre5
**Commit:** `0371035de`  |  **CI:** ✅ run 23667070420
**What changed:**
- Added "VRam Limit:" row to Container Info: reads WINEMU_MEMORY_LIMIT from wine child /proc/pid/environ via readWineEnv(); shows "512 MB" or "Unlimited"
- Renamed "RAM:" label to "Sys RAM:" to clearly distinguish system RAM from VRam
- Container Info order: CPU Cores / Sys RAM / VRam Limit / Device / Android
#### Files touched
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTaskManagerFragment.smali`

---

## [pre] — v2.7.4-pre4 — fix: smali if-ltz for readWineEnv zero comparisons (2026-03-27)
**Branch:** `main`  |  **Tag:** v2.7.4-pre4
**Commit:** `b258d3848`  |  **CI:** ✅ run 23666627847
**What changed:**
- Fixed two invalid smali instructions in `readWineEnv()`: `if-lt vX, 0, :label` → `if-ltz vX, :label`
- `if-lt` requires two register operands; literal `0` is not a register — caused "mismatched input '0' expecting REGISTER" CI failure
- `readWineEnv()` now correctly reads WINEMU_CPU_AFFINITY from Wine child `/proc/<pid>/environ`
#### Files touched
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTaskManagerFragment.smali`

---

## [pre] — v2.7.4-pre4 — Wine Task Manager: container-accurate CPU + RAM (2026-03-27)
**Branch:** `main`  |  **Tag:** v2.7.4-pre4
**Commit:** `3e444a792`  |  **CI:** ✅ run 23664109023
**What changed:**
- `getContainerCpuInfo()`: reads `WINEMU_CPU_AFFINITY` bitmask → `Integer.bitCount()` for assigned cores; falls back to `/proc/stat` count if unset/0; shows "CPU Cores: X / Y total"
- `getContainerRamInfo()`: reads `/proc/meminfo` for used MB + `WINEMU_MEMORY_LIMIT` env var for limit; shows "X MB used / Y MB limit" or "X MB used / Y MB total"
- Removed `getRamInfo()` (replaced)
- `onCreateView` CPU row: replaced 14-line inline StringBuilder block with single `invoke-static getContainerCpuInfo()`
- `onCreateView` RAM row: calls `getContainerRamInfo()` instead of `getRamInfo()`

---

## [pre] — v2.7.4-pre4 — Wine Task Manager: always-visible Container Info + two tabs (2026-03-27)
**Branch:** `main`  |  **Tag:** v2.7.4-pre4 (earlier commits)
**What changed:**
- Wine Task Manager: Container Info (CPU/RAM/VRAM) always visible at top of panel
- Two tabs below: Applications (Wine infra non-.exe) + Processes (Windows .exe)
- Performance tab removed; Container Info built directly into root layout
- Applications/Processes routing fixed (was backwards vs Wine task manager convention)
- 10sp mixed-case button text so labels fit in tab bar width
#### Files touched
- `patches/res/drawable/sidebar_taskmanager.xml` (new)
- `patches/res/layout/winemu_activitiy_settings_layout.xml` (new tab item)
- `patches/res/values/public.xml` (2 new IDs)
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTabListener.smali` (new)
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTaskClickListener.smali` (new)
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTaskManagerFragment.smali` (new)
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTaskManagerFragment$KillListener.smali` (new)
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTaskManagerFragment$RefreshListener.smali` (new)
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTaskManagerFragment$ScanRunnable.smali` (new)
- `patches/smali_classes16/com/xj/winemu/sidebar/BhTaskManagerFragment$UpdateRunnable.smali` (new)
- `patches/smali_classes3/com/xj/winemu/sidebar/WineActivityDrawerContent.smali` (constructor + U() patched)

---

## [pre] — v2.7.7-pre — 3-way API selector AlertDialog (2026-03-27)
**Branch:** `main`  |  **Tag:** v2.7.7-pre
**Commit:** `526ad99f9`
**What changed:**
- Replaced cycle-tap EmuReady toggle with AlertDialog showing all 3 API options as radio buttons
- `GameHubPrefs.setApiSource(I)V`: saves api_source + last_api_source prefs, clears caches, shows toast
- `BhApiSelectorListener` (new): `DialogInterface.OnClickListener` — calls setApiSource, dismisses dialog, updates switch visual
- `SettingSwitchHolder.w()` patched: bumped `.locals 5→9`, intercepts CONTENT_TYPE_API (0x1a), builds AlertDialog with 3 options pre-selected from getApiSource(), shows dialog, returns Unit early
**Files touched:** `patches/smali_classes6/…/GameHubPrefs.smali`, `patches/smali_classes16/…/BhApiSelectorListener.smali` (new), `patches/smali_classes10/…/SettingSwitchHolder.smali` (new)
**CI result:** ✅ run 23652279209

---

## [stable] — v2.7.3 — Cancel download, exe picker, Set .exe in detail dialog (2026-03-26)
**Branch:** `main`  |  **Tag:** v2.7.3
**Commit:** `b0445ba48`
**What changed:**
- Install confirmation dialog (size + free storage) before any GOG download
- Cancel download button: red Cancel during download, stops thread + deletes partial files
- Exe picker dialog post-install: auto-select if 1 candidate; dialog if 2+
- Set .exe button in game detail dialog: re-scan install dir, pick, save, label updates live
- README updated for all 4 features
**Files touched:** `extension/GogDownloadManager.java`, `extension/GogGamesActivity.java`, `README.md`
**CI result:** ✅ run 23600668664 (9 APKs)

---

## [pre] — v2.7.3-pre — Set .exe button in GOG game detail dialog (2026-03-26)
**Branch:** `main`  |  **Tag:** v2.7.3-pre (retagged)
**Commit:** `b0445ba48`
**What changed:**
- showDetailDialog replaced setMessage with custom LinearLayout view
- When installed: shows current .exe filename label + "Set .exe…" button
- Button scans install dir via GogDownloadManager.collectExeCandidates(), shows showExePicker()
- On selection: saves new path to gog_exe_{gameId} prefs, updates .exe label live, shows Toast
- Handles empty candidate list gracefully with Toast error
- Uninstall + Copy to Downloads buttons unchanged
**Files touched:** `extension/GogGamesActivity.java`
**CI result:** queued run 23600303291

---

## [pre] — v2.7.3-pre — GOG exe picker dialog (2026-03-26)
**Branch:** `main`  |  **Tag:** v2.7.3-pre (retagged)
**Commit:** `f16603864`
**What changed:**
- collectExeCandidates() gathers all qualifying .exes (excludes redist/unins/setup/crash/report/helper/dotnet/vcredist/directx), shallowest first
- Callback.onSelectExe() default method added; 1 candidate → auto; 2+ → showExePicker() AlertDialog
- showExePicker() shows parent/filename label for each; user pick resumes on bg thread
- All 3 Callback instances in GogGamesActivity override onSelectExe
**Files touched:** `extension/GogDownloadManager.java`, `extension/GogGamesActivity.java`
**CI result:** ✅ (rerun after transient apktool download failure)

---

## [pre] — v2.7.3-pre — GOG cancel download button (2026-03-26)
**Branch:** `main`  |  **Tag:** v2.7.3-pre (retagged)
**Commit:** `6f277b670`
**What changed:**
- Pre-install confirmation dialog (added in prior commit): shows game size (async-fetched) and available storage before download starts
- Cancel download button: Install button turns red and becomes Cancel during download; pressing it stops thread + deletes partial files from GOG install dir + resets to Install
- Works in all 3 GOG install UI surfaces (list view inline, grid tile action row, grid/poster dialog)
**Files touched:** `extension/GogDownloadManager.java`, `extension/GogGamesActivity.java`
**CI result:** ✅ run 23595376744

---

## [stable] — v2.7.1 — Restore Steam card, standalone Normal variant, Normal(GHL) (2026-03-24)
**Branch:** `main`  |  **Tag:** v2.7.1
**Commit:** `029ae6b`
**What changed:**
- Steam card restored: removed versionName CI patch (kept 5.3.5) — was breaking My Games tab on all fresh installs
- Normal variant standalone (banner.hub), Normal(GHL) variant added (gamehub.lite)
- README rewrite, build-crossfire.yml removed, .gitignore added
**Files touched:** `.github/workflows/build.yml`, `README.md`, `.gitignore`
**CI result:** ✅ 9 APKs built

---

## [fix] — v2.7.1-pre2 — Remove versionName patch to restore Steam card (2026-03-24)
**Branch:** `main`  |  **Tag:** v2.7.1-pre2 (retagged)
**Commit:** `029ae6b`
**What changed:**
- Removed "Patch versionName" step from `build.yml`. Root cause: CI was patching `apktool.yml` versionName from `5.3.5` → release tag (e.g. `2.7.0`). GameHub sends versionName in server API calls (`SignUtils clientparams`). With `2.7.0` instead of `5.3.5`, a server/internal version gate suppressed the Steam card in My Games tab on fresh installs. Fix: keep original `5.3.5` from base APK decompile. BannerHub version is visible from the GitHub release tag.
**Files touched:** `.github/workflows/build.yml`
**CI result:** ✅ run 23518106008 (APK uploaded; release published manually after duplicate-release conflict)

---

## [fix] — v2.7.0 — Patch versionName, BannerHub labels, dynamic APK naming (2026-03-24)
**Branch:** `main`  |  **Tag:** v2.7.0 (retagged — CI rebuild)
**Commit:** `5dd70e0`
**What changed:**
- Added "Patch versionName" step in prepare job: strips `v` from tag, sets correct versionName in apktool.yml so APK reports e.g. `2.7.0` internally
- Renamed all variant app labels from "GameHub Revanced ..." to "BannerHub ..." (Normal→BannerHub, PuBG→BannerHub PuBG, AnTuTu→BannerHub AnTuTu, alt-AnTuTu→BannerHub AnTuTu, PuBG-CrossFire→BannerHub PuBG CrossFire, Ludashi→BannerHub Ludashi, Genshin→BannerHub Genshin, Original→BannerHub Original)
- Sign step now uses `id: sign` + `$GITHUB_OUTPUT` to pass `apk_name` dynamically; upload step uses `steps.sign.outputs.apk_name`
- v2.7.0 release APKs rebuilt and re-uploaded; release description restored after CI

---

## [docs] — v2.7.1-pre — Thorough README rewrite (2026-03-23)
**Branch:** `main`  |  **Tag:** v2.7.1-pre (no new CI — docs only)
**Commit:** `3e62286`
**What changed:** Full README rewrite. Added Table of Contents. Every feature section expanded with technical depth: GOG tab covers auth flow, all three download pipelines (Gen 2 / Gen 1 / installer fallback), install flow, copy to downloads, uninstall. Component Manager covers card UI, all CRUD actions, format support table. Performance toggles section explains sysfs KGSL min_freq lock vs setSustainedPerformanceMode, CPU governor paths, and why root is required for the sysfs approach vs ioctl. Added gesture map table for RTS controls, core label table for CPU affinity, expanded Advanced tab and offline mode docs. Added FAQ (6 questions), expanded How It Works with classes12 bypass note.
**Files touched:** `README.md`
**CI result:** N/A (docs-only commit, no tag pushed)

---

## [beta] — v2.7.0-beta69 — feat(gog): rename Launch button to Add on GOG game cards (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta69
**Commit:** `def0813`
**What changed:** `GogGamesFragment$2` line 393: `const-string v14, "Launch"` → `"Add"`. The button after install now reads "Add" to better reflect that it opens EditImportedGameInfoDialog to register the game with the launcher.
**Files touched:** `GogGamesFragment$2`
**CI result:** ✅ run 23412435537

---

## [beta] — v2.7.0-beta68 — fix(gog): fix v16 register error in checkmark propagation (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta68
**Commit:** `9d881a2`
**What changed:** beta67 failed because `v16` was used in non-range instructions (4-bit limit is v0-v15). Fix: create/setup checkmark in v13 (4-bit), persist to v16 via `move-object/from16 v16, v13` (8-bit dest OK), reload via `move-object/from16 v13, v16` when setting VISIBLE. v16 only appears in valid 8-bit/range contexts.
**Files touched:** `GogGamesFragment$2` only
**CI result:** ✅ run 23411891622

---

## [beta] — v2.7.0-beta67 — fix(gog): show ✓ Installed checkmark immediately when download completes (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta67
**Commit:** `3743330`
**What changed:** Checkmark "✓ Installed" now appears on the game card immediately when download finishes — no app restart required. Approach: checkmark TextView always created as GONE in `$2`, initial visibility set from gog_exe_ pref. Reference propagated through 5 levels: `$2`→`$6`→`$8`→`GogDownloadManager`→`$1`→`$3`. At progress=100 in `$3.run()`, `setVisibility(VISIBLE)` called on the checkmark ref. Root cause was that `$3` had no way to trigger UI update; this avoids a full card rebuild.
**Files touched:** `GogGamesFragment$2`, `GogGamesFragment$6`, `GogGamesFragment$8`, `GogDownloadManager`, `GogDownloadManager$1`, `GogDownloadManager$3`
**CI result:** ❌ smali v16 register error (fixed in beta68)

---

## [beta] — v2.7.0-beta66 — fix(gog): card layout, uninstall path, post-uninstall refresh (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta66
**Commit:** `4540dc8`
**What changed:** (1) `$2` right-column LP height MATCH_PARENT→WRAP_CONTENT — cards grow to fit all content. (2) `$10` field `a` changed Context→GogGamesFragment; full install path built via `getFilesDir()/gog_games/{dirName}` (gog_dir_ stores name only, not path); after prefs clear, reads `access_token` and starts new `GogGamesFragment$1` thread to re-sync+rebuild cards. (3) `$3` passes fragment ref to `$10` constructor via `iget-object v10, p0, $3->a`.
**Files touched:** `GogGamesFragment$2`, `GogGamesFragment$3`, `GogGamesFragment$10`
**CI result:** ✅ run 23411207426

---

## [beta] — v2.7.0-beta65 — feat(gog): Uninstall button in game detail dialog (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta65
**Commit:** `7214d44`
**What changed:** New `GogGamesFragment$10` (DialogInterface$OnClickListener): reads `gog_dir_{gameId}`, recursively deletes install dir via `deleteRecursive(File)`, removes prefs keys `gog_dir_`, `gog_exe_`, `gog_cover_`, `gog_gen_`, shows Toast "Uninstalled". `GogGamesFragment$3` wired up with `setNegativeButton("Uninstall", $10)` before `show()`.
**Files touched:** `GogGamesFragment$3` (modified), `GogGamesFragment$10` (new)
**CI result:** ✅ run 23410775545

---

## [beta] — v2.7.0-beta64 — feat(gog): Gen 1 / Gen 2 badge on each game card (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta64
**Commit:** `0a10b89`
**What changed:** Library sync ($1) now probes `builds?generation=2&system=windows` per game after adding it to the list. Stores `gog_gen_{gameId}=2` or `1` in bh_gog_prefs. HTTP/JSON errors silently caught (inner try_gen → :gen_check_done). Card builder ($2) reads the pref and adds a 10sp badge TextView: "Gen 2" (light blue 0xFF4FC3F7) or "Gen 1" (orange 0xFFFF9800). Skipped if value is 0.
**Files touched:** `GogGamesFragment$1`, `GogGamesFragment$2`
**CI result:** ✅ run 23410601968

---

## [beta] — v2.7.0-beta63 — feat(gog): ✓ Installed checkmark on game card (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta63
**Commit:** `ee5173d`
**What changed:** After a game is installed, a green "✓ Installed" TextView (0xFF4CAF50, 10sp) appears on the card between the meta line and Install button. Reads gog_exe_{gameId} from bh_gog_prefs — only created and added if non-empty. Registers v11/v13/v14/v15 used as scratch at insertion point.
**Files touched:** `GogGamesFragment$2`
**CI result:** ✅ run 23410432005

---

## [beta] — v2.7.0-beta62 — feat(gog): Gen 1 legacy download fallback (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta62
**Commit:** `d096da0`
**What changed:** Added Gen 1 download fallback when no Gen 2 build is found. New methods: `runGen1(token, gameId)` (8-step pipeline: builds?generation=1 → manifest → depot manifests → secure_link → downloadRange per file → finalize), `processGen1DepotManifest(json, list)` (parses depot.files[], skips support=true), `downloadRange(url, offset, size, outFile)` (Range: bytes=N-M HTTP download with 32KB buffer). :err_gen1 in run() now calls runGen1() instead of showing a toast. Finalize identical to Gen 2 (manifest json, prefs, exe stored, 100% Complete).
**Files touched:** `GogDownloadManager$1` (modified: :err_gen1 branch + 3 new private methods)
**CI result:** ✅

---

## [beta] — v2.7.0-beta61 — revert: roll back cover art preview to beta59 (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta61
**Commit:** `3cedaec`
**What changed:** Reverted beta60 cover art changes. Restored GogDownloadManager$1 and GogGamesFragment$7 to beta59 state. Removed GogGamesFragment$9.
**Files touched:** `GogDownloadManager$1`, `GogGamesFragment$7`, `GogGamesFragment$9` (deleted)
**CI result:** ✅ run 23409452782

---

## [beta] — v2.7.0-beta60 — feat(gog): cover art preview dialog before launch (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta60
**Commit:** `9e717d3`
**What changed:** Tapping Launch now shows a cover-art preview AlertDialog (game title + cover image + Launch/Cancel) before handing off to B3(). During install, cover image is fetched from GogGame.imageUrl → saved as installDir/cover.jpg; path stored as gog_cover_{gameId} in bh_gog_prefs. GogGamesFragment$7 rewritten to load bitmap via BitmapFactory.decodeFile() and show dialog. New GogGamesFragment$9: DialogInterface$OnClickListener that calls B3(exePath).
**Files touched:** `GogDownloadManager$1`, `GogGamesFragment$7` (rewrite), `GogGamesFragment$9` (new)
**CI result:** ✅ run 23409333203

---

## [beta] — v2.7.0-beta59 — fix: use mul-int/lit8 for download percentage calc (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta59
**Commit:** `66f569b`
**What changed:** Fixed smali error in beta58: `mul-int vA, vB, imm` is not a valid opcode — corrected to `mul-int/lit8 vA, vB, imm`.
**Files touched:** `GogDownloadManager$1`
**CI result:** ✅ run 23408923443

---

## [beta] — v2.7.0-beta58 — feat(gog): per-file download percentage in status text (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta58
**Commit:** `bf16ee5`
**What changed:** During the file download loop (45%→85%), status text now updates after each file: "Downloading files... X%" using `pct = fileIndex * 40 / totalFiles + 45`. Uses v3/v13/v14 (all scratch within loop). beta58 failed CI due to invalid `mul-int vA, vB, imm` opcode — fixed in beta59.
**Files touched:** `GogDownloadManager$1`
**CI result:** ❌ run 23408885820 — mul-int does not accept immediate

---

## [beta] — v2.7.0-beta54 — fix: Install/Launch button 0dp height (setMinimumHeight 40dp) (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta54
**Commit:** `bf5e521`
**What changed:** Added `setMinimumHeight(40dp)` on both Install (v8) and Launch (v12) buttons using the existing density float `v2`. Programmatic Buttons in GameHub's theme collapse to ~0dp height with WRAP_CONTENT because no default minHeight is applied.
**Files touched:** `GogGamesFragment$2`
**CI result:** ✅ run 23407752284

---

## [beta] — v2.7.0-beta53 — fix: smali register errors in $1/$6/$2 from beta50 redesign (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta53
**Commit:** `d30bfaf`
**What changed:** Three consecutive register-encoding fixes: (1) GogDownloadManager$1.postProgress() bumped to .locals 6 so {v0..v5} are all free locals for invoke-direct/range to GogDownloadManager$3.<init>; (2) GogGamesFragment$6.onClick() reduced to .locals 15 (p0=v15 stays in 4-bit range), range shifted {v9..v15}→{v8..v14}, p1 copied via move-object/from16; (3) GogGamesFragment$2 line 335 saved bar/statusTV/launchBtn to v13-v15 before new-instance at v10, enabling invoke-direct/range {v10..v15} for $6 constructor.
**Files touched:** `GogDownloadManager$1`, `GogGamesFragment$6`, `GogGamesFragment$2`
**CI result:** ✅ run 23407620772

---

## [beta] — v2.7.0-beta50 — feat(gog): Install button → size dialog → ProgressBar+statusTV flow (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta50
**Commit:** `3b45dd1`
**What changed:** Full card UI redesign: single Install button per card → tapping opens AlertDialog showing download size (MB) and available space (GB) with Cancel/Download buttons. Download confirm: Install hides (GONE), ProgressBar appears with statusTV below it showing step text (Fetching build info… → Fetching manifest… → Getting CDN link… → Downloading files… → Assembling… → Finishing up… → ✓ Complete). At 100%: bar+statusTV GONE, Launch button VISIBLE+enabled. If game already installed at card render: Install GONE, Launch shown immediately. fileSize:J field added to GogGame and populated from products/{id}?expand=downloads API.
**Files touched:** `GogGame`, `GogGamesFragment$1`, `GogGamesFragment$2`, `GogGamesFragment$6` (rewrite), `GogGamesFragment$8` (new), `GogDownloadManager`, `GogDownloadManager$1`, `GogDownloadManager$3` (rewrite)
**CI result:** ❌ run 23407367959 — postProgress invoke-direct 6-register limit

---

## [beta] — v2.7.0-beta49 — feat: readable Download/Launch buttons + percentage progress (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta49
**Commit:** `6a8b336`
**What changed:** Button labels changed from symbol "↓"/"▶" to text "Download"/"Launch". Button LP widened from 40×40dp to 90×40dp so text fits. ProgressBar replaced with a percentage TextView throughout the entire download chain — on click shows "0%", GogDownloadManager$3.run() builds "X%" string via Integer.toString+StringBuilder and calls setText; at progress≥100 TextView is hidden (GONE) and Launch button enabled.
**Files touched:** `GogGamesFragment$2`, `GogGamesFragment$6`, `GogDownloadManager`, `GogDownloadManager$1`, `GogDownloadManager$3`
**CI result:** ✅ run 23397855382

---

## [beta] — v2.7.0-beta48 — fix: square ↓/▶ buttons at far right of card (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta48
**Commit:** `6508495`
**What changed:** Replace wide weight=1 button row (rendered as thin unreadable strips) with a vertical column of two 40dp×40dp square buttons pinned to the card's far right. ProgressBar now spans full width between thumbnail and button column. Buttons use ↓/▶ symbols with white text. .locals 17→16.
**Files touched:** `GogGamesFragment$2.smali`
**CI result:** ✅ run 23397624611

---

## [beta] — v2.7.0-beta47 — feat: Download+Launch buttons on game card (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta47
**Commit:** `89f26e0`
**What changed:** Moved Download and Launch buttons from the detail dialog to each game card. Card shows [Download][Launch] row + ProgressBar (GONE until download starts). Launch is disabled until GogDownloadManager$3 enables it at progress=100. Dialog simplified to info-only (Close only). GogGamesFragment$7 changed to View$OnClickListener. GogDownloadManager chain: TextView→Button for launch ref.
**Files touched:** `GogGamesFragment$2`, `$3`, `$6`, `$7`, `GogDownloadManager`, `GogDownloadManager$1`, `GogDownloadManager$3`
**CI result:** ✅ run 23397440034

---

## [beta] — v2.7.0-beta46 — fix: manifest link URL clobbered by const/4 v4 null arg (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta46
**Commit:** `05ab138`
**What changed:** In `GogDownloadManager$1.run()`, Step 2 posted a 20% progress update using `const/4 v4, 0x0` as the null message argument — but v4 held the build manifest link URL from Step 1. The URL was silently overwritten with null before `fetchBytes(v4, v1)` was called, so `fetchBytes` returned null every time → "GOG: failed to read build manifest". Fix: use `v3` (free after JSONObject consumed) for the null message instead of `v4`.
**Files touched:** `GogDownloadManager$1.smali` (modified)
**CI result:** ✅ run 23397124795

---

## [beta] — v2.7.0-beta35 — fix: VerifyError in assembleFile — use v6 not v11 for size int (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta35
**Commit:** `6a12617`
**What changed:** `assembleFile()` used `move-result v11` to store the `size` optInt, but v11=p0=this. On the second loop iteration, verifier sees v11 as Conflict (reference on loop-entry vs int in body) → rejects `invoke-direct {p0,...}` at offset 0x5C. Fix: use v6 (free after cdnPath consumed) instead of v11. Update `if-eq v10,v11` → `if-eq v10,v6`.
**Files touched:** `GogDownloadManager$1.smali` (modified)
**CI result:** ✅ run 23393056199

---

## [beta] — v2.7.0-beta34 — fix: VerifyError in assembleFile (long-to-int before if-nez) (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta34
**Commit:** `5c76246`
**What changed:** `assembleFile()` had `move-result-wide v9` (from `File.length()J`) followed immediately by `if-nez v9`. Dalvik verifier rejects if-nez on `Long (Low Half)`: `[0x7E] type Long (Low Half) unexpected as arg to if-eqz/if-nez`. Fix: `long-to-int v9, v9` inserted between the two instructions.
**Files touched:** `GogDownloadManager$1.smali` (modified)
**CI result:** ✅ run 23392891841

---

## [beta] — v2.7.0-beta33 — fix: Install button placement + Toast crash fix (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta33
**Commit:** `45f1f3a`
**What changed:** Install button moved from embedded scroll content to `setNegativeButton()` in standard AlertDialog button bar (always visible across from "Close"). Fixed crash when tapping Install: `showToast()` was calling `Toast.show()` from background thread (RuntimeException: Can't create handler inside thread that has not called Looper.prepare()); now posts via `Handler(Looper.getMainLooper())`. New `GogDownloadManager$2.smali` Toast Runnable. `GogGamesFragment$6` changed to `DialogInterface$OnClickListener`.
**Files touched:** `GogGamesFragment$3.smali` (modified), `GogGamesFragment$6.smali` (modified), `GogDownloadManager$1.smali` (modified), `GogDownloadManager$2.smali` (new)
**CI result:** ✅ run 23392758366

---

## [beta] — v2.7.0-beta32 — fix: register range errors + Task #6 Gen 2 GOG download pipeline (2026-03-22)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta32
**Commit:** `14c4dcb` (beta32) / `04d994d` (beta31) / `8de2765` (beta30)
**What changed:** Full Gen 2 GOG download pipeline (beta30) + assembler fixes (beta31/32). `GogDownloadManager.smali` static entry, `GogDownloadManager$1.smali` 7-step Runnable (builds API → gzip/zlib/plain manifest → depot manifests language filter → secure CDN link → chunk download 3-retry → zlib Inflater assembly → finalize), `GogGamesFragment$6.smali` Install click listener. Install button (dark green) added to game detail dialog. Fixes: cmpg-long→cmp-long; run() .locals 16→15 (p0=v15 in range); assembleFile() .locals 14→11 (p0-p4=v11-v15 in range).
**Files touched:** `GogDownloadManager.smali` (new), `GogDownloadManager$1.smali` (new), `GogGamesFragment$3.smali` (modified), `GogGamesFragment$6.smali` (new)
**CI result:** ✅ run 23392542553

---

## [beta] — v2.7.0-beta29 — feat: Task #5 define GOG install path files/gog_games/{installDirectory}/ (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta29
**Commit:** `d4a887f`
**What changed:** New `GogInstallPath.smali` — static `getInstallDir(Context, String) -> File` returning `{filesDir}/gog_games/{installDirectory}`. Sibling to `files/Steam/`. Called by Task #6 download pipeline.
**Files touched:** `GogInstallPath.smali` (new)
**CI result:** ✅ run 23391795871

---

## [beta] — v2.7.0-beta28 — feat: Task #4 proactive token expiry check before library fetch (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta28
**Commit:** `36d724d`
**What changed:** At start of `GogGamesFragment$1.run()`, read `bh_gog_login_time`+`bh_gog_expires_in` from SP; if `currentTime >= loginTime+expiresIn`, call `GogTokenRefresh.refresh()` proactively; use fresh token for all subsequent calls. loginTime=0 treated as expired → one-time refresh for pre-beta23 sessions. On refresh failure, proceeds with old token (401 retry handles it).
**Files touched:** `GogGamesFragment$1.smali`
**CI result:** ✅ run 23391595779

---

## [beta] — v2.7.0-beta27 — fix: NoSuchFieldError crash — $2 still referenced removed rating/dlcCount fields (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta27
**Commit:** `812f17d`
**What changed:** `GogGamesFragment$2` card meta line still accessed `GogGame.rating` and `GogGame.dlcCount` which were removed in beta26. Caused `NoSuchFieldError` crash on GOG tab open. Replaced with `GogGame.developer` — card subtitle now shows "Category · Developer".
**Files touched:** `GogGamesFragment$2.smali`
**CI result:** ✅ run 23391493572

---

## [beta] — v2.7.0-beta26 — feat: Task #3 two-step GOG library sync with org.json + description/developer (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta26
**Commit:** `9774025`
**What changed:** Replaced single `getFilteredProducts` call + manual indexOf parsing with proper two-step fetch: Step 1 `GET embed.gog.com/user/data/games` → owned ID list; Step 2 per-ID `GET api.gog.com/products/{id}?expand=downloads,description` → full product JSON parsed via `org.json.JSONObject/JSONArray`. `GogGame` now has `description`/`developer` fields (removed `rating`/`dlcCount`). Dialog shows Genre+Developer in info TV and a new description TV (Html.fromHtml, max 5 lines). Inner per-product try/catch skips one bad product without bailing the whole loop.
**Files touched:** `GogGame.smali`, `GogGamesFragment$1.smali`, `GogGamesFragment$3.smali`
**CI result:** ✅ run 23391361724

---

## [beta] — v2.7.0-beta25 — fix: request focus on first card for D-pad/controller nav (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta25
**What changed:** `ScrollView.arrowScroll()` only moves focus when `findFocus()` returns a non-null anchor. With no view focused after list load, the first D-pad press just scrolled instead of selecting a card. Fix: after the card loop, `requestFocus()` called on `getChildAt(0)` so first card is focused on load. `setFocusable(true)` (beta24) was necessary but not sufficient — this completes the fix.
**Files touched:** `GogGamesFragment$2.smali`
**CI result:** ✅ run 23391012847

---

## [beta] — v2.7.0-beta24 — fix: GOG game cards focusable for controller/D-pad navigation (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta24
**What changed:** `setFocusable(true)` added to each card view in `GogGamesFragment$2` immediately after `setClickable(true)`. Without `setFocusable`, Android's focus system had no targets to traverse and controller up/down did nothing. `v14` already held `true` from the preceding `setClickable` call — zero extra registers needed.
**Files touched:** `GogGamesFragment$2.smali`
**CI result:** ✅ run 23390886239

---

## [beta] — v2.7.0-beta23 — feat: store loginTime + expires_in in bh_gog_prefs (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta23
**What changed:** Both initial login (`GogLoginActivity$2`) and silent refresh (`GogTokenRefresh`) now write `bh_gog_login_time` (int, unix seconds) and `bh_gog_expires_in` (int, 3600) to `bh_gog_prefs`. Enables upcoming proactive expiry check: `currentTimeMillis()/1000 >= loginTime + expiresIn`. `.locals` bumped in both files to accommodate wide long registers for `System.currentTimeMillis()` division.
**Files touched:** `GogLoginActivity$2.smali`, `GogTokenRefresh.smali`
**CI result:** ✅ run 23390773183

---

## [beta] — v2.7.0-beta22 — fix: GOG token refresh GET not POST, fix full client_secret (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta22
**What changed:** `GogTokenRefresh.smali` was sending the refresh grant as a POST with a form body. The GOG token endpoint uses GET with query params. Fix: remove `setDoOutput`, `Content-Type` header, `getOutputStream`/write; build full URL with params as query string. Also fixed truncated `client_secret` (last 32 hex chars were missing). `.locals` reduced 12→11.
**Files touched:** `GogTokenRefresh.smali`
**CI result:** ✅ run 23390629182

---

## [beta] — v2.7.0-beta21 — fix: crash Resources$NotFoundException from ripple code (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta21
**What changed:** `resolveAttribute(selectableItemBackground)` returned `resourceId=0` on the device theme (attribute resolves to a color/data value, not a drawable resource ID). `Context.getDrawable(0)` threw `Resources$NotFoundException` crashing the app. Fix: check `resolveAttribute()` return value (Z) and guard `tv.resourceId != 0` before calling `getDrawable()`. Ripple silently skipped if not a drawable resource on this theme.
**Files touched:** `GogGamesFragment$2.smali`
**CI result:** ✅ run 23389889405

---

## [beta] — v2.7.0-beta20 — polish: card ripple, dialog title, store URL link, rating unit (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta20
**What changed:** (1) Card touch ripple — selectableItemBackground resolved from theme set as card foreground. (2) Thumbnail placeholder `#262626` → `#333333`. (3) Title moved into dark custom view (bold 18sp, 16dp padding); `setTitle()` removed so no system title bar clash. (4) Store URL TextView now tappable via new `GogGamesFragment$5` OnClickListener firing `Intent.ACTION_VIEW`. (5) Rating unit `"/100"` → `"%"` to match card list.
**Files touched:** `GogGamesFragment$2.smali`, `GogGamesFragment$3.smali`, `GogGamesFragment$5.smali` (new)
**CI result:** ✅ run pending

---

## [beta] — v2.7.0-beta19 — feat: silent GOG token refresh on 401 (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta19
**What changed:** When the GOG library fetch returns non-200 (expired access_token), silently try a refresh_token grant before clearing the session. New `GogTokenRefresh.smali` static helper POSTs `grant_type=refresh_token` to `auth.gog.com/token`, saves the new `access_token` + `refresh_token` to SP, and returns the new token. `GogGamesFragment$1.smali` updated: on non-200, call `GogTokenRefresh.refresh(ctx)`, retry the library fetch with the new token if successful, otherwise clear both tokens and show the "Session expired" prompt. Also clears `refresh_token` from SP on full session expiry (previously only `access_token` was removed).
**Files touched:** `GogTokenRefresh.smali` (new), `GogGamesFragment$1.smali`
**CI result:** ✅ run 23389889405 — Normal APK built successfully

---

## [beta] — v2.7.0-beta18 — Fix: GOG cover art blank (JSON escaping + missing CDN suffix) (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta18
**What changed:** Cover art thumbnails (card list + dialog) showed blank placeholders. Two silent root causes: (1) GOG API may return image paths with JSON-escaped slashes (`\/\/images-4.gog.com\/hash`) → `MalformedURLException` in `java.net.URL` constructor, caught by `$4` catch-all. Fix: `String.replace("\\/", "/")` before URL assembly. (2) GOG CDN base hash paths have no extension and may not serve an image without a format suffix. Fix: append `_product_card_v2_mobile_slider_639.jpg` when no `.jpg`/`.webp`/`.png` extension present.
**Files touched:** `GogGamesFragment$1.smali`
**CI result:** ✅ run 23389506174 — Normal APK built successfully

---

## [beta] — v2.7.0-beta17 — Fix crash: GradientDrawable wrong package path (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta17
**What changed:** `NoClassDefFoundError: android.graphics.GradientDrawable` — class does not exist at that path. Correct package is `android.graphics.drawable.GradientDrawable`. Replaced all 4 occurrences in `GogGamesFragment$2.smali`.
**Files touched:** `GogGamesFragment$2.smali`
**CI result:** ✅ run 23389246633 — Normal APK built successfully

---

## [beta] — v2.7.0-beta14 — GOG game detail dialog + cover art + card list (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta14
**What changed:** Full game detail experience on tap. (1) `$2.run()` rewritten: plain TextView list replaced with styled card rows — horizontal LinearLayout per game with 60dp ImageView thumbnail (async-loaded by new `$4`), title TextView (white 15sp bold), meta TextView (grey 13sp: "Category · rating% · DLC: N"), dark rounded GradientDrawable bg (10dp radius, #1A1A1A), 12/6dp margins. `$3` click listener now receives the full `GogGame` object. (2) `$3.onClick()` rewritten: replaces Toast with AlertDialog using `setView()` — custom view has 200dp cover art ImageView (async-loaded by `$4`), info TextView (Genre/Rating/DLC), blue store URL TextView. Dialog title = game title. (3) New `GogGamesFragment$4`: bg Runnable fetching Bitmap via HttpURLConnection + BitmapFactory, posts `$4$1` via `View.post()`. (4) New `GogGamesFragment$4$1`: UI-thread Runnable calling `setImageBitmap()`.
**Files touched:** `GogGamesFragment$2.smali` (rewrite), `GogGamesFragment$3.smali` (rewrite), `GogGamesFragment$4.smali` (new), `GogGamesFragment$4$1.smali` (new)
**CI result:** beta14/beta15 failed (move-object/from16 fix needed for p0→v16 in $1 and $2); ✅ v2.7.0-beta16 run 23389111217

---

## [beta] — v2.7.0-beta13 — Fix: check-cast v8 to String in $2, dex verifier crash (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta13
**What changed:** VerifyError crash on GOG Games tab selection. `GogGamesFragment$2.run()` rejected by verifier at the `GogGamesFragment$3.<init>` call: v8 had static type `Object` (from `ArrayList.get()` → `move-object v8, v6`) but `$3` constructor declares `Ljava/lang/String;`. Fix: add `check-cast v8, Ljava/lang/String;` immediately after `move-object v8, v6`.
**Files touched:** `GogGamesFragment$2.smali`
**CI result:** ✅ run 23387811737 — Normal APK built successfully

---

## [beta] — v2.7.0-beta12 — Fix: top padding clears tab bar; game titles tappable (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta12
**What changed:** (1) Game list overlapped the tab bar — root FrameLayout starts at y=0 with FocusTabLayout overlaying on top; first game title was hidden behind the tab strip. Fix: compute 56dp via DisplayMetrics.density, call setPadding(0, topPad, 0, 0) on the root FrameLayout in onCreateView. (2) Game titles had no click listener — plain TextViews are not tappable. Fix: new GogGamesFragment$3 (View.OnClickListener) created per item in $2's loop; tap shows a Toast with the game title. Saved title to v8 before v6 was reused; increased $2 .locals 8→9.
**Files touched:** `GogGamesFragment.smali`, `GogGamesFragment$2.smali`, `GogGamesFragment$3.smali` (new)
**CI result:** ✅ run 23387644699 — Normal APK built successfully

---

## [beta] — v2.7.0-beta11 — Fix: detect expired GOG token, clear SP, show re-login prompt (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta11
**What changed:** Previously an expired `access_token` caused `GogGamesFragment$1` to get a non-200 response (HTTP 401) which was treated identically to an empty game library — UI showed "No GOG games found" with no indication of why. Fix: `$1.run()` now calls `getResponseCode()` after connecting; on non-200, clears `access_token` from `bh_gog_prefs` SharedPreferences and posts `null` to UI instead of an empty ArrayList. `$2.run()` null-checks the list before calling `size()`: null → "Session expired - sign in again via the GOG side menu"; empty ArrayList → "No GOG games found" (unchanged).
**Files touched:** `GogGamesFragment$1.smali`, `GogGamesFragment$2.smali`
**CI result:** ✅ run 23387323126 — Normal APK built successfully

---

## [beta] — v2.7.0-beta10 — Fix GOG Games tab: extend LazyFragment so show/hide works (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta10
**What changed:** Root cause of beta9 bug: `k3()`'s show/hide loop only processes `LazyFragment` instances. `GogGamesFragment` extended plain `Fragment`, so it was never hidden when switching back to My Games — its full-screen dark FrameLayout (MATCH_PARENT) covered all content permanently. Fix: change `.super` to `LazyFragment`, implement abstract `V()` = `refreshContent()` (initial load when tab first becomes visible), update `onResume()` super call. Removed premature `refreshContent()` from `onCreateView` (now handled by `V()` + `onResume()`).
**Files touched:** `GogGamesFragment.smali`
**CI result:** ✅ run 23387054135 — Normal APK built successfully

---

## [beta] — v2.7.0-beta9 — GOG Games tab: GogGamesFragment + live game library from getFilteredProducts (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta9
**What changed:** Login confirmed working (beta8). Implemented GOG Games tab next to "My Games". New `GogGamesFragment` (Fragment subclass) fetches `embed.gog.com/account/getFilteredProducts?mediaType=1&sortBy=title` on background thread using stored access_token, parses all `"title":"…"` entries, and populates a ScrollView list on the main thread. If not logged in shows "Sign in via the GOG option in the side menu". Tab injected via `TabItemData.<init>(ILjava/lang/String;Function0)V` with title "GOG Games" after the "My Games" add in `LandscapeLauncherMainActivity.initView()`.
**Files touched:** `GogGamesFragment.smali`, `GogGamesFragment$TabFactory.smali`, `GogGamesFragment$1.smali`, `GogGamesFragment$2.smali`, `LandscapeLauncherMainActivity.smali`
**CI result:** ✅ run 23386451735 — Normal APK built successfully (3m32s). (First attempt run 23386175453 failed with DEX overflow in classes11; fixed using reflection.)

---

## [beta] — v2.7.0-beta8 — Fix VerifyError: invoke-direct for String overload of shouldOverrideUrlLoading (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta8
**What changed:** beta7 `replace_all` matched `invoke-virtual {p0, v0}` and fixed the WebResourceRequest overload, but the String overload uses `invoke-direct {p0, v1}` — different register. Logcat confirmed only String variant still failing. Fixed: `invoke-virtual {p0, v1}` → `invoke-direct {p0, v1}` at line 162.
**Files touched:** `GogLoginActivity$1.smali`
**CI result:** ✅ run 23385707562 — Normal APK built successfully (3m38s)

---

## [beta] — v2.7.0-beta7 — Fix VerifyError: invoke-direct for private handleImplicitRedirect (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta7
**What changed:** VerifyError on `GogLoginActivity$1`: private method `handleImplicitRedirect(Uri)` was called with `invoke-virtual` — ART rejects this. Private methods must use `invoke-direct`. Changed both call sites (`replace_all`).
**Files touched:** `GogLoginActivity$1.smali`
**CI result:** ✅ run 23385551233 — Normal APK built successfully (3m31s)

---

## [beta] — v2.7.0-beta6 — GOG implicit flow: bypass revoked client_secret (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta6
**What changed:** beta5 logcat confirmed `HTTP 400: {"error":"invalid_client","error_description":"The client credentials are invalid"}`. GOG has revoked `client_secret=9d85c43b1482497dbbce61f6e4aa173a` for third-party token exchanges. Fix: switch to OAuth2 implicit flow (`response_type=token`). Tokens arrive directly in the redirect URL fragment — no token exchange, no client_secret. `$1` now parses `#access_token=TOKEN&refresh_token=R&user_id=U` from the fragment using `Uri.parse("x://x?"+fragment)`. `$2` rewritten to 4-field constructor (activity, accessToken, refreshToken, userId); run() only fetches userData.json for username then saves all to SP. `$1` also extracted a `handleImplicitRedirect(Uri)` private helper to share logic between WebResourceRequest and deprecated String variants cleanly.
**Files touched:** `GogLoginActivity.smali`, `GogLoginActivity$1.smali`, `GogLoginActivity$2.smali`
**CI result:** ✅ run 23385389863 — Normal APK built successfully (3m32s)

---

## [beta] — v2.7.0-beta5 — Fix GOG login: handle HTTP error responses (getErrorStream) (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta5
**What changed:** Logcat from beta4 showed the GOG auth page reloading only 2 seconds after form submission — meaning the token exchange in $2 ran and failed almost immediately. Root cause: `readHttpResponse` called `getInputStream()` which throws `IOException` for HTTP 4xx/5xx responses; this jumped to catch_all → $4 error toast before we ever read the error body. Fix: check `getResponseCode()` first; if ≥ 400, use `getErrorStream()` to read the error body. Also added `Log.d("BH_GOG", "HTTP NNN: <body>")` so the next logcat will show exactly what GOG's token endpoint is returning, enabling final diagnosis.
**Files touched:** `GogLoginActivity$2.smali`
**CI result:** ✅ run 23385165117 — Normal APK built successfully (3m41s)

---

## [beta] — v2.7.0-beta4 — Fix GOG login: timeouts, retry on fail, loading feedback (2026-03-21)
**Branch:** `gog-beta`  |  **Tag:** v2.7.0-beta4
**What changed:** Four GOG login fixes based on logcat analysis (43s hang, blank screen after intercept, no retry on failure, UA mismatch).
- `GogLoginActivity$2`: `setConnectTimeout(15000)` + `setReadTimeout(15000)` on both HTTP connections (token POST + userData GET) — stops 43-second hang
- `GogLoginActivity$1`: after intercepting the redirect and starting the token thread, calls `webView.loadData(...)` to show "Logging in to GOG..." instead of blank/spinning page. Also added the deprecated `shouldOverrideUrlLoading(WebView,String)` override for Android < 8.0 compatibility (same logic as the `WebResourceRequest` variant)
- `GogLoginActivity$4`: fixed `.locals 2→3` (was referencing undeclared v2); added `webView.loadUrl(buildAuthUrl())` after the error toast so the login form reloads for a clean retry instead of leaving a blank screen
- `GogLoginActivity`: added `setUserAgentString("Mozilla/5.0 ... GOG Galaxy/2.0")` so GOG's server treats the WebView as Galaxy client
**Files touched:** `GogLoginActivity.smali`, `GogLoginActivity$1.smali`, `GogLoginActivity$2.smali`, `GogLoginActivity$4.smali`
**CI result:** ✅ run 23384952359 — Normal APK built successfully (3m33s)

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

### [pre] — v2.7.0-beta36 — GOG game launch: save exe path + Launch button (2026-03-21)
**Commit:** pending  |  **Tag:** v2.7.0-beta36
#### What changed
- `GogDownloadManager$1.smali`: added field `c` (String) to hold temp_executable; in Step 2 extracts `products[0].temp_executable` from build manifest and stores it; in Step 7 after install, saves full exe path to `bh_gog_prefs` as `gog_exe_{gameId}`
- `GogGamesFragment$3.smali`: detail dialog now checks `bh_gog_prefs` for `gog_exe_{gameId}` — shows "Launch" button (GogGamesFragment$7) if installed, "Install" button (GogGamesFragment$6) if not
- `GogGamesFragment$7.smali`: new DialogInterface$OnClickListener; reads stored exe path, normalizes backslashes, builds WineActivityData(gameId, exePath, isLocalGame=true, gameName), starts PcGameSetupActivity with wine_data Parcelable + FLAG_ACTIVITY_NEW_TASK
#### Files touched
- `patches/smali_classes16/.../GogDownloadManager$1.smali`
- `patches/smali_classes16/.../GogGamesFragment$3.smali`
- `patches/smali_classes16/.../GogGamesFragment$7.smali` (new)

### [pre] — v2.7.0-beta37 — fix: const/16 for v16/v17 in GogGamesFragment$7 (2026-03-21)
**Commit:** `a84fe6a`  |  **Tag:** v2.7.0-beta37
#### What changed
- `GogGamesFragment$7.smali`: changed `const/4 v16/v17, 0x0` → `const/16 v16/v17, 0x0`; const/4 only supports v0-v15 (4-bit register field)
#### Files touched
- `patches/smali_classes16/.../GogGamesFragment$7.smali`

### [pre] — v2.7.0-beta38 — GOG: always show Install+Launch buttons; toast when no exe path (2026-03-21)
**Commit:** pending  |  **Tag:** v2.7.0-beta38
#### What changed
- `GogGamesFragment$3.smali`: removed conditional SP check; always shows both Install (setNegativeButton) and Launch (setNeutralButton) — dialog now has [Launch] [Install] [Close]
- `GogGamesFragment$7.smali`: if gog_exe_ SP key empty, shows Toast "Reinstall game to enable launch" instead of silently doing nothing
- `GogDownloadManager$1.smali`: SP write now always runs (no early exit on missing exe); always writes gog_dir_{gameId}=installDir.getName(); only writes gog_exe_{gameId} if temp_executable was in manifest
#### Files touched
- `patches/smali_classes16/.../GogGamesFragment$3.smali`
- `patches/smali_classes16/.../GogGamesFragment$7.smali`
- `patches/smali_classes16/.../GogDownloadManager$1.smali`

### [fix] — v2.7.0-beta39 — fix IncompatibleClassChangeError crash on install SP write (2026-03-22)
**Commit:** `0abd6bc`  |  **Tag:** v2.7.0-beta39
#### What changed
- `GogDownloadManager$1.smali` line 1113: `invoke-virtual` → `invoke-interface` for `SharedPreferences.edit()`
- SharedPreferences is a Java interface; invoke-virtual caused IncompatibleClassChangeError at runtime on every install completion
#### Files touched
- `patches/smali_classes16/.../GogDownloadManager$1.smali`

### [fix] — v2.7.0-beta40 — exe fallback scan when temp_executable absent (2026-03-22)
**Commit:** `0c07c55`  |  **Tag:** v2.7.0-beta40
#### What changed
- `GogDownloadManager$1.smali`: after depot_loop_done, if field c (temp_executable) is still null, scan all DepotFile JSONObjects for first path ending in `.exe` not containing `redist`; normalize backslashes; store in field c so SP write can record gog_exe_
#### Files touched
- `patches/smali_classes16/.../GogDownloadManager$1.smali`

### [test] — v2.7.0-beta41 — option 1: Z: drive path for Wine exe launch (2026-03-22)
**Commit:** `ba7f9dd`  |  **Tag:** v2.7.0-beta41
#### What changed
- `GogGamesFragment$7.smali`: convert Android absolute path to Z: drive format before passing to WineActivityData exePath
#### Files touched
- `patches/smali_classes16/.../GogGamesFragment$7.smali`

### [feat] — v2.7.0-beta42 — GOG launch: use built-in Import Game flow (2026-03-22)
**Commit:** `9362545`  |  **Tag:** v2.7.0-beta42
#### What changed
- `GogGamesFragment$7.smali`: replaced WineActivityData + PcGameSetupActivity launch with `LandscapeLauncherMainActivity.B3(exePath)` call, which triggers the built-in `EditImportedGameInfoDialog` (Import Game flow). Uses the full absolute exe path stored in `gog_exe_` SP key.
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogGamesFragment$7.smali`

### [feat] — v2.7.0-beta43/44 — In-dialog download progress bar (2026-03-22)
**Commit:** `030cc9b` (beta43 — CI fail) → `c274659` (beta44 — CI ✅)  |  **Tag:** v2.7.0-beta44
#### What changed
- Install button moved from AlertDialog negative button into content LinearLayout — dialog stays open during download
- `GogDownloadManager$3.smali` (new): UI-thread Runnable updates ProgressBar + status TextView; hides bar at 100%
- `GogDownloadManager$1.smali`: added d/e/f fields (ProgressBar, TextView, Handler); added `postProgress()` helper; replaced 6 progress/completion showToast calls with postProgress calls (5%→20%→40%→45%→85%→90%→100%+checkmark)
- `GogDownloadManager.smali`: updated startDownload() signature to `(Context, GogGame, ProgressBar, TextView)`
- `GogGamesFragment$6.smali`: now View.OnClickListener; shows ProgressBar, disables button, calls updated startDownload()
- `GogGamesFragment$3.smali`: Install button in content, ProgressBar + status TextView added; setNegativeButton removed; dialog now [Launch][Close] only
- **Fix:** `const/4 v9, 0x8` → `const/16` — View.GONE=8 is out of const/4 range (-8 to 7)
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogDownloadManager$3.smali` (new)
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogDownloadManager$1.smali`
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogDownloadManager.smali`
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogGamesFragment$6.smali`
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogGamesFragment$3.smali`

### [fix] — v2.7.0-beta45 — Install button back in button bar; progress at top of dialog (2026-03-22)
**Commit:** `d7f6a3a`  |  **Tag:** v2.7.0-beta45
#### What changed
- Install button restored to AlertDialog button bar (setNegativeButton). Dialog stays open because after show() we call getButton(BUTTON_NEGATIVE) and set a new View.OnClickListener — this replaces AlertDialog's internal dismiss handler
- ProgressBar + status text inserted at indices 1 and 2 in content LinearLayout via addView(view, index) — always visible just below the title without scrolling
- GogGamesFragment$6 simplified: Button field removed (button is p1 in onClick), constructor is now (Context, GogGame, ProgressBar, TextView)
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogGamesFragment$3.smali`
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogGamesFragment$6.smali`

### [fix] — v2.7.1-pre-beta44 — Fix CDN manifest URL & separator; show appName on screen (2026-03-23)
**Commit:** `f49e8cc`  |  **Tag:** v2.7.1-pre-beta44  |  **Branch:** epic-integration (bannerhub-testing)
#### What changed
- `EpicInstallHelper.parseManifestDownloadUrl`: fixed inverted `if-nez` → `if-eqz` — first CDN query param no longer gets spurious `&` prefix, subsequent params now correctly separated with `&`. Was producing `?&Policy=XXXSignature=YYYKey-Pair-Id=ZZZ` (malformed CloudFront signed URL), causing Samorost 3 binary manifest download to fail with HTTP 0.
- `EpicMainActivity$7`: progress text changed from generic `"Fetching manifest info..."` to `"Fetching: {appName}"` — shows on screen whether catalog artifact name resolved (e.g. `Samorost3Game`) or is still library UUID.
#### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/EpicInstallHelper.smali`
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/EpicMainActivity$7.smali`

### [ci+docs] — v2.7.1-pre — Add Normal(GHL) variant, fix Normal package, fix README (2026-03-24)
**Commit:** `fd39656`  |  **Tag:** v2.7.1-pre (retagged)
#### What changed
- Normal variant package changed from `gamehub.lite` → `banner.hub` (installs alongside official GameHub Lite)
- New `Normal(GHL)` variant added (`gamehub.lite`) for users replacing official GameHub Lite
- APK: `BannerHub-vX.Y.Z-Normal(GHL).apk`
- README: added Normal(GHL) row, added missing PuBG-CrossFire row, updated count 7→9, updated Which APK / FAQ
- CI: build-quick.yml unaffected (pre-release Normal already used banner.hub)

## v2.7.2-pre — GOG ported to side menu with bh-lite UI (2026-03-25)
- GOG tab removed from bottom navigation
- GOG now launches from side menu as a full Activity (identical to bh-lite)
- List / Grid / Poster 3-way view toggle
- SteamGridDB 600×900 cover art with GOG icon fallback
- Long-press on grid/poster tiles → detail dialog with HTML description
- GogGamesActivity, GogMainActivity, GogLoginActivity, GogDownloadManager, GogLaunchHelper compiled as Java (classes18.dex)
- All 29 GOG smali files removed
- CI: build-quick.yml (pre-release, Normal APK)

### [feat] — v2.7.3-pre — GOG install confirmation dialog with game size + free storage (2026-03-26)
**Commit:** `e13536c`  |  **Tag:** v2.7.3-pre  |  **CI:** ✅
#### What changed
- All 3 GOG install buttons (list inline, grid tile action row, grid/poster dialog) now show a confirmation dialog before starting any download
- Dialog shows: game title, game size (async-fetched), available storage on install path, Install / Cancel buttons
- Game size fetched in background: Gen 2 → builds → manifest → sum `depots[].size`; Gen 1 → `items[].total_size`; shows "Unknown" if unavailable
- ⚠ warning + red text if game size exceeds available storage
- `GogDownloadManager.fetchGameSize(ctx, game)` — 2 HTTP calls (builds + manifest), returns bytes or -1
- `GogDownloadManager.formatBytes(bytes)` — formats as KB / MB / GB
- `GogGamesActivity.showInstallConfirm(game, onConfirm)` — wraps all 3 install handlers
#### Files touched
- `extension/GogDownloadManager.java`
- `extension/GogGamesActivity.java`

### [feat] — v2.7.4-pre — Winlator HUD Style toggle in performance sidebar (2026-03-27)
**Commit:** `f2bd3a51c`  |  **Tag:** v2.7.4-pre  |  **CI:** ✅ run 23647642646
#### What changed
- `BhFrameRating.java` (new): compact horizontal HUD bar — GPU% | CPU% | RAM% | BAT watts | TMP °C | FPS
  - GPU: kgsl/gpu_busy_percentage (Adreno) + Mali fallback
  - CPU: /proc/stat diff
  - RAM: ActivityManager.MemoryInfo
  - BAT: BatteryManager current × sysfs voltage
  - TMP: battery/thermal sysfs
  - FPS: ProfilePuller.a.a().c() via reflection
  - Injected into DecorView (TOP|RIGHT), tag "bh_frame_rating"; background thread, stops on detach
- `BhHudStyleSwitchListener.smali` (new): click handler — toggles BhFrameRating, hides GameHub hudLayer when Winlator HUD on
- `BhPerfSetupDelegate.smali` (updated): adds "Winlator HUD Style" SidebarSwitchItemView programmatically below Max Adreno Clocks; injects BhFrameRating into DecorView on first sidebar open
#### Files touched
- `extension/BhFrameRating.java`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhHudStyleSwitchListener.smali`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`

### [fix] — v2.7.5-pre — Winlator HUD: root cache, real FPS, drag (2026-03-27)
**Commit:** `b2500486d`  |  **Tag:** v2.7.5-pre
#### What changed
- Root dialog: `isRootAvailable()` now caches in static fields — su only runs once, no Magisk dialog on every sidebar open
- FPS was stuck at 1: `ProfilePuller.c()` returns GPU ratio (0-1), not FPS. Fixed to use `WineActivity.h.M()` (WinUIBridge) via reflection
- Drag support added to BhFrameRating via OnTouchListener — matches built-in HUD behaviour
- GPU: switched to `gpubusy` (busy/total format) as primary source — same path GameHub uses
#### Files touched
- `extension/BhFrameRating.java`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`

### [fix] — v2.7.5-pre (retag) — Root call removed, real FPS, drag (2026-03-27)
**Commit:** `bbe96a63d`  |  **Tag:** v2.7.5-pre (force-pushed)
#### What changed
- Sidebar never calls su again — reads `root_granted` from bh_prefs instead
- FPS source corrected: `WineActivity.j` (HudDataProvider) → `a()` — same data as GameHub HUD
- Drag support via OnTouchListener
- GPU reads `gpubusy` first
#### Files touched
- `extension/BhFrameRating.java`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`

### [feat] — v2.7.6-pre — 3-way API selector: GameHub / EmuReady / BannerHub (2026-03-27)
**Commit:** `70376313a`  |  **Tag:** v2.7.6-pre
#### What changed
- Settings "Compatibility API" row cycles: GameHub (0) → EmuReady (1) → BannerHub (2) → back
- api_source int pref replaces use_external_api boolean
- BannerHub URL: `https://bannerhub-api.the412banner.workers.dev/`
- All isExternalAPI() call sites unchanged
#### Files touched
- `patches/smali_classes6/app/revanced/extension/gamehub/prefs/GameHubPrefs.smali`

### [feat] — amazon-integration branch — Phase 1: Amazon auth skeleton (2026-03-29)
**Commit:** (pending)  |  **Branch:** amazon-integration
#### What changed
- Amazon Games integration Phase 1: PKCE auth flow, credential storage, WebView login, main entry point
- AmazonPKCEGenerator.java: device serial (UUID), clientId (hex of serial#DEVICE_TYPE), code verifier (32 random bytes), code challenge (SHA-256 S256), sha256Upper for hardwareHash
- AmazonCredentialStore.java: persist credentials to filesDir/amazon/credentials.json, load/save/clear, isLoggedIn(), getValidAccessToken() with auto-refresh 5min before expiry
- AmazonAuthClient.java: registerDevice (PKCE exchange → bearer tokens), refreshAccessToken (reuses refresh token), deregisterDevice (non-fatal), postJson/getRequest helpers
- AmazonLoginActivity.java: PKCE WebView login, 3-hook redirect capture (shouldOverrideUrlLoading×2 + onPageStarted), AtomicBoolean double-fire guard, background thread for registerDevice, saves credentials on success
- AmazonMainActivity.java: entry point (ID=11), login card / logged-in card toggle, sign out (deregister + clear), launches AmazonGamesActivity
- AmazonGamesActivity.java: Phase 1 stub (placeholder screen)
- HomeLeftMenuDialog.smali: added pswitch_11 (AmazonMainActivity), Amazon menu item ID=0xb, extended packed-switch to include :pswitch_11
- AndroidManifest.xml: registered AmazonMainActivity, AmazonLoginActivity, AmazonGamesActivity
#### Files touched
- `extension/AmazonPKCEGenerator.java` (new)
- `extension/AmazonCredentialStore.java` (new)
- `extension/AmazonAuthClient.java` (new)
- `extension/AmazonLoginActivity.java` (new)
- `extension/AmazonMainActivity.java` (new)
- `extension/AmazonGamesActivity.java` (new)
- `patches/smali_classes5/.../HomeLeftMenuDialog.smali`
- `patches/AndroidManifest.xml`
**Commit:** `75c8ede78`  |  **CI:** ✅ run 23707207001 — artifact: BannerHub-amazon-75c8ede

### [feat] — amazon-integration branch — Phase 2: Library sync + game cards (2026-03-29)
**Commit:** (pending)  |  **Branch:** amazon-integration
#### What changed
- AmazonGame.java: data class (productId, entitlementId, title, artUrl, heroUrl, developer, publisher, productSku, isInstalled, installPath, versionId, downloadSize, installSize)
- AmazonApiClient.java: GetEntitlements (paginated, dedup by productId), GetGameDownload, GetLiveVersionIds, getSdkChannelSpec, appendPath helper, postGaming (amz-1.0 headers), getBytes
- AmazonGamesActivity.java (full): library list with collapsible cards, cover art async load, cache in bh_amazon_prefs SP, Install/Launch stubs, token auto-refresh
#### Files touched
- `extension/AmazonGame.java` (new)
- `extension/AmazonApiClient.java` (new)
- `extension/AmazonGamesActivity.java` (replaced stub with full impl)

### [feat] — amazon-integration branch — Phase 3: Manifest parser + download pipeline (2026-03-29)
**Commit:** (pending)  |  **Branch:** amazon-integration
#### What changed
- AmazonManifest.java: binary protobuf manifest parser (4-byte big-endian headerSize + ManifestHeader + LZMA/XZ body); minimal ProtoReader varint decoder; extracts packages/files/hashes; uses org.tukaani.xz (XZInputStream + LZMAInputStream)
- AmazonDownloadManager.java: 6-parallel file downloads with 3-retry backoff (1s/2s/4s); SHA-256 verify; resume support (skip file if destFile.length()==file.size); progress callback every 512KB; cancellation check per batch + in read loop; IN_PROGRESS/COMPLETE markers; manifest cache at filesDir/manifests/amazon/
- AmazonGamesActivity.java: Install button wired to real AmazonDownloadManager.install(); progress shown on button ("Installing… N%"); Uninstall with confirmation dialog + recursive delete; install state persisted to bh_amazon_prefs cache
#### Files touched
- `extension/AmazonManifest.java` (new)
- `extension/AmazonDownloadManager.java` (new)
- `extension/AmazonGamesActivity.java` (install + uninstall wired)

### [feat] — amazon-integration branch — Phase 4: Launch pipeline (2026-03-29)
**Commit:** (pending)  |  **Branch:** amazon-integration
#### What changed
- AmazonLaunchHelper.java: fuel.json parser (Main.Command/WorkingSubdirOverride/Args), exe scoring heuristic (Java port of ExecutableSelectionUtils.kt: UE shipping +300, UE Binaries/ +250, root-level +200, name match +100, negative keywords -150, generic -200, tiebreak by file size), build "winhandler.exe \"A:\\path.exe\" [args]" command, buildFuelEnv() 5 env vars
- LandscapeLauncherMainActivity.smali: Amazon pending launch check mirrors GOG pattern; reads pending_amazon_exe from bh_amazon_prefs → calls B3(exePath)
- AmazonGamesActivity.java: Launch button wired to launchGame() → AmazonLaunchHelper.buildLaunchSpec() → stores pending_amazon_exe → finish()
#### Files touched
- `extension/AmazonLaunchHelper.java` (new)
- `patches/smali_classes11/.../LandscapeLauncherMainActivity.smali`
- `extension/AmazonGamesActivity.java` (Launch wired)

### [feat] — amazon-integration branch — Phase 5: SDK DLL manager (2026-03-29)
**Commit:** (pending)  |  **Branch:** amazon-integration
#### What changed
- AmazonSdkManager.java: GET SDK channel spec → downloadUrl; parse manifest.proto (same pipeline as game); filter "Amazon Games Services" files; FuelSDK_x64.dll → Legacy/; AmazonGamesSDK_* → AmazonGamesSDK/; cache at filesDir/amazon_sdk/ + .sdk_version sentinel; deploySdkToPrefix() idempotent copy to Wine prefix ProgramData; isSdkCached() checks VERSION_FILE + hasAnyFile in Amazon Games Services/
- AmazonGamesActivity.java: call ensureSdkFiles() after successful game install
#### Files touched
- `extension/AmazonSdkManager.java` (new)
- `extension/AmazonGamesActivity.java` (ensureSdkFiles after install)

### [feat] — amazon-integration branch — Phase 6: Polish + update check (2026-03-29)
**Commit:** (pending)  |  **Branch:** amazon-integration
#### What changed
- checkForUpdates(): GetLiveVersionIds per installed game in sync thread; marks versionId+_UPDATE_AVAILABLE; card shows "Update Available" in orange
- launchGame(): now runs on background thread, calls ensureSdkFiles before building launch spec
- Update Available indicator on installed game cards
#### Files touched
- `extension/AmazonGamesActivity.java`
- `COMPONENT_MANAGER_BUILD_LOG.md`
