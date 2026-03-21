# Component Manager — Full Build Log

Tracks every file created, modified, moved, or deleted in the BannerHub Component Manager
feature set. Includes exact methods added/changed, register details, commit hashes, CI
outcomes, and push records for every build.

---

## How this log works

Each entry covers one logical change unit (commit or closely related set of commits):
- **Files created / moved / deleted** — exact paths, how the operation was performed
- **Methods added / changed** — method signature, register count, what was changed
- **Commit** — hash, message, branch
- **Push** — `git push origin refs/heads/main` / `git push origin refs/tags/<tag>`
- **CI result** — workflow, run ID, pass/fail, duration

---

## Legend

| Symbol | Meaning |
|--------|---------|
| `[NEW]` | File created for the first time |
| `[MOD]` | Existing file modified |
| `[DEL]` | File deleted |
| `[MOV]` | File moved / renamed |
| `[CI✅]` | CI build passed |
| `[CI❌]` | CI build failed |

---

## Entry 077 — GOG via side menu (DEX overflow fix) (v2.7.0-beta3, gog-beta)
**Date:** 2026-03-21
**Branch:** gog-beta  |  **Tag:** v2.7.0-beta3

### Root-cause analysis
beta1 and beta2 failed with `Unsigned short value out of range: 65536` from dexlib2. `smali_classes11` was already at exactly 65535 pool entries (unsigned short max). Adding even 1 new type/string/method ref pushes it over. New pool entries from the tab approach: type ref `BhGogTabCallback`, method ref `BhGogTabCallback.<init>`, method ref `TabItemData.<init>(I,String,Function0)`, string `"GOG"` = 4 new entries (65539 → fail). Reflection approach also fails: even 1 new class-name string overflows. Solution: move GOG to the side menu (HomeLeftMenuDialog, classes5, no overflow risk).

### Files created
| Path | Description |
|------|-------------|
| `[NEW]` `patches/smali_classes16/…/GogMainActivity.smali` | Activity: login/signed-in UI, dp(), isLoggedIn(), buildLoginCard(), buildLoggedInCard(), onCreate(), onResume(), refreshView() |
| `[NEW]` `patches/smali_classes16/…/GogMainActivity$1.smali` | OnClickListener: login button → startActivity(GogLoginActivity) |
| `[NEW]` `patches/smali_classes16/…/GogMainActivity$2.smali` | OnClickListener: sign out → clear bh_gog_prefs SP, refreshView() |

### Files deleted
| Path | Reason |
|------|--------|
| `[DEL]` `patches/smali_classes16/…/BhGogTabCallback.smali` | Tab approach abandoned |
| `[DEL]` `patches/smali_classes16/…/GogFragment.smali` | Replaced by GogMainActivity |
| `[DEL]` `patches/smali_classes16/…/GogFragment$1.smali` | Replaced by GogMainActivity$1 |
| `[DEL]` `patches/smali_classes16/…/GogFragment$2.smali` | Replaced by GogMainActivity$2 |

### Files modified
| Path | Change |
|------|--------|
| `[MOD]` `patches/smali_classes5/…/HomeLeftMenuDialog.smali` | Add GOG MenuItem (id=10, icon=menu_setting_normal, title="GOG") at end of menu list; add :pswitch_10 case in o1() → startActivity(GogMainActivity); extend packed-switch data to include :pswitch_10 |
| `[MOD]` `patches/smali_classes11/…/LandscapeLauncherMainActivity.smali` | Removed GOG tab injection from both branches (classes11 overflow fix) |
| `[MOD]` `patches/AndroidManifest.xml` | Added GogMainActivity declaration |

### Key methods
- `GogMainActivity.onCreate(Bundle)` — .locals 4; builds FrameLayout, adds loginCard+loggedInCard, setContentView, calls refreshView
- `GogMainActivity.onResume()` — .locals 0; super.onResume, refreshView
- `GogMainActivity.refreshView()` — .locals 5; toggles card visibility based on bh_gog_prefs/access_token; updates usernameView text
- `HomeLeftMenuDialog.o1()` — packed-switch extended from 10 to 11 entries (0x0–0xa)

### CI result
✅ run 23384471808 — Normal APK built in 3m43s

---

## Entry 076 — GOG tab Phase 1: login + token exchange (v2.7.0-beta1, gog-beta)
**Date:** 2026-03-21
**Branch:** gog-beta  |  **Tag:** v2.7.0-beta1

### Files created
| Path | Description |
|------|-------------|
| `[NEW]` `patches/smali_classes16/com/xj/landscape/launcher/ui/main/BhGogTabCallback.smali` | Function0 → returns new GogFragment |
| `[NEW]` `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogFragment.smali` | Fragment: login card / signed-in card, refreshView(), onResume |
| `[NEW]` `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogFragment$1.smali` | OnClickListener: login button → start GogLoginActivity |
| `[NEW]` `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogFragment$2.smali` | OnClickListener: sign out → clear SP, refreshView |
| `[NEW]` `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogLoginActivity.smali` | Activity: WebView OAuth2, buildAuthUrl(), parseJsonStringField() |
| `[NEW]` `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogLoginActivity$1.smali` | WebViewClient: intercept on_login_success, extract code, start $2 thread |
| `[NEW]` `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogLoginActivity$2.smali` | Runnable: POST token exchange, GET userData.json, save SP, finish via $3 |
| `[NEW]` `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogLoginActivity$3.smali` | Runnable (UI thread): finish() activity after successful login |
| `[NEW]` `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/GogLoginActivity$4.smali` | Runnable (UI thread): show error toast on login failure |

### Files modified
| Path | Change |
|------|--------|
| `[MOD]` `patches/smali_classes11/…/LandscapeLauncherMainActivity.smali` | Inject GOG TabItemData after "My Games" in both tab-list branches (branch 1 line ~5904, branch 2 line ~6105); uses TabItemData(I, String, Function0) constructor with "GOG" literal |
| `[MOD]` `patches/AndroidManifest.xml` | Added GogLoginActivity declaration |

### Key methods
- `BhGogTabCallback.invoke()` — .locals 1; new GogFragment; return
- `GogFragment.buildLoginCard(Context)` — .locals 4; builds dark card with GOG title, subtitle, login button ($1 listener)
- `GogFragment.buildLoggedInCard(Context)` — .locals 4; builds signed-in card with usernameView + sign-out button ($2 listener)
- `GogFragment.onCreateView(...)` — .locals 4; FrameLayout root, both cards added MATCH_PARENT, refreshView()
- `GogFragment.refreshView()` — .locals 5; toggle login/loggedIn card visibility; update usernameView from SP
- `GogLoginActivity$1.shouldOverrideUrlLoading(WebView, WebResourceRequest)` — .locals 5; getUrl().toString(), startsWith("embed.gog.com/on_login_success"), getQueryParameter("code"), start $2 thread
- `GogLoginActivity$2.run()` — .locals 11; POST auth.gog.com/token, GET embed.gog.com/userData.json, parseJsonStringField, save to bh_gog_prefs, runOnUiThread($3)
- `GogLoginActivity.parseJsonStringField(String, String)` — static; manual "key":"value" extraction via indexOf/substring

### Token exchange notes
- Endpoint: `https://auth.gog.com/token`
- Credentials: public GOG embedded client (`client_id=46899977096215655`, `client_secret=9d85c43b1482497dbbce61f6e4aa173a`)
- Redirect URI: `https://embed.gog.com/on_login_success?origin=client`
- Username source: `https://embed.gog.com/userData.json` with Bearer token

**CI result:** [pending]

---

## Entry 073 — Source badge + refresh + type badge fixes (v2.6.2-pre5)
**Date:** 2026-03-21
**Commit:** `26f5af5`  |  **Tag:** v2.6.2-pre5a  |  **CI:** ✅ run 23380498933

### Root cause analysis
**Bug #1 (no refresh):** `ComponentManagerActivity` had no `onResume()` override. When `ComponentDownloadActivity.finish()` brought the manager to front, the adapter was never refreshed — new dirs invisible until full activity recreation.

**Bug #2 (source badge invisible):** Two stacked issues:
- `setMaxLines(1)` on nameText cut off the `"\n"+repo` second line entirely.
- SP key mismatch: `$6` added URL filename ("FEXCore-2603.wcp") to `mAllNames`, not verName. Then `onItemClick` appended extension again → "FEXCore-2603.wcp.wcp". After stripping in `$5`, baseName = "FEXCore-2603.wcp" ≠ actual directory "2603" (from WCP profile.json).

**Type badge "WCP":** Adapter's `getTypeName(dirName)` keyword-matched on "2603"/"2.4.1-..." — neither contains type keywords → "WCP" fallback.

### Fixes applied

**`ComponentManagerActivity.smali`** `[MOD]`
- Added `onResume()` → calls `showComponents()` — list refreshes on return from download activity.

**`BhComponentAdapter.smali`** `[MOD]`
- `onCreateViewHolder`: `setMaxLines(1)` → `setMaxLines(2)` — source badge now visible.
- `onBindViewHolder`: after `getTypeName()`/`getTypeColor()`, look up `dirName+":type"` in SP; if found, override typeName and recompute color.

**`ComponentDownloadActivity.smali`** `[MOD]`
- `onItemClick`: added `endsWith()` check before appending URL extension → prevents "FEXCore-2603.wcp.wcp" double extension.

**`ComponentDownloadActivity$5.smali`** `[MOD — full rewrite]`
- Records `System.currentTimeMillis()` before `injectComponent()`.
- After injection: scans `getFilesDir()/usr/home/components` for dirs with `lastModified() > timestamp`. Uses newest dir's name as SP key (correct regardless of WCP profile.json naming).
- Falls back to filename-based baseName if scan finds no new dir.
- Maps `val$type` int → type name string (0x5f=FEXCore, 0x5e=Box64, 0xd=VKD3D, 0xa=GPU, 0xc=DXVK); writes `dirName+":type"` → type name to SP.

### Methods modified
- `ComponentManagerActivity.onResume()V` — new, `.locals 0`
- `BhComponentAdapter.onCreateViewHolder()` — setMaxLines changed
- `BhComponentAdapter.onBindViewHolder()` — type SP override added before badge display
- `ComponentDownloadActivity.onItemClick()` — endsWith check added
- `ComponentDownloadActivity$5.run()V` — full rewrite, `.locals 7` → `.locals 12`

---

# PHASE 1 — Core Component Manager (v1.0.6 → v2.1.1)

---

## Entry 001 — Initial Component Manager in smali_classes11
**Date:** 2026-03-12
**Commit:** `d2f17e9`  |  **Tag:** `v1.0.6` `[CI❌]`

### What was done
Added "Components" (ID=9) to GameHub's side nav and created `ComponentManagerActivity`
from scratch in pure smali. Build failed: `DexIndexOverflowException` — smali_classes11
was already near the 65535 dex index limit and the new class pushed it over.

### Files — created / placed
```
METHOD: created by hand-writing smali directly (no Kotlin/Java source)
PLACED: patches/smali_classes11/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali [NEW]
```

### Files — modified
```
patches/smali_classes5/com/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog.smali  [MOD]
patches/AndroidManifest.xml  [MOD]
```

### Method-level changes

**`HomeLeftMenuDialog.smali`**
- `o1()V` — extended packed-switch table from max ID 8 → 9; added `pswitch_9` branch
  that calls `startActivity(new Intent(this, ComponentManagerActivity.class))`
- Switch data table at end of method updated

**`ComponentManagerActivity.smali`** (new file, ~200 lines)
- `.class public final Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;`
- `.super Landroidx/appcompat/app/AppCompatActivity;`
- `.implements Landroid/widget/AdapterView$OnItemClickListener;`
- Fields: `listView:ListView`, `components:[File`, `selectedIndex:I`, `mode:I`
- `onCreate(Bundle)V` — `.locals 2`; creates `ListView`, sets content view, calls `showComponents()`
- `showComponents()V` — `.locals 7`; scans `getFilesDir()/usr/home/components/`, builds `String[]`, sets `ArrayAdapter`
- `showOptions()V` — `.locals 5`; shows ["Inject file...", "Backup", "Back"] list
- `onItemClick(AdapterView;View;II)V` — packed-switch on mode: mode=0 sets `selectedIndex=p3`, calls `showOptions()`; mode=1 item 0 → `pickFile()`, item 1 → `backupComponent()`, item 2 → `showComponents()`
- `pickFile()V` — fires `ACTION_OPEN_DOCUMENT` with `*/*` MIME, request code 42
- `onActivityResult(IIIntent)V` — result OK + request 42 → `injectFile(data.getData())`
- `injectFile(Uri)V` — opens InputStream via ContentResolver, reads bytes, writes to `components[selectedIndex]/filename`
- `backupComponent()V` — recursive `copyDir()` to `Environment.DIRECTORY_DOWNLOADS/BannerHub/<name>/`
- `copyDir(File;File)V` — iterates `listFiles()`, mkdir for dirs, stream copy for files

**`AndroidManifest.xml`**
- Added `<activity android:name=".launcher.ui.menu.ComponentManagerActivity" android:screenOrientation="sensorLandscape" />`

### CI run
- Run ID: (not recorded) | Workflow: `build.yml` | **FAILED** — `DexIndexOverflowException` in smali_classes11

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v1.0.6
```

---

## Entry 002 — Move ComponentManagerActivity to smali_classes16
**Date:** 2026-03-12
**Commit:** part of v1.0.7 push  |  **Tag:** `v1.0.7` `[CI✅]`

### What was done
smali_classes16 had only ~100 classes (plenty of headroom under 65535). Moved the new
activity out of the full classes11 dex bucket.

### Files — moved
```
METHOD: cp then rm (manual copy + delete from old location)
FROM: patches/smali_classes11/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali
TO:   patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali
[MOV]
```

### CI run
- Workflow: `build.yml` | **PASSED** | Components item appears in side menu, activity launches

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v1.0.7
```

---

## Entry 003 — Fix VerifyError crashes on launch
**Date:** 2026-03-12
**Commit:** part of v1.0.8  |  **Tag:** `v1.0.8` `[CI✅]`

### Root cause
ART verifier rejected the class at load time due to two malformed instructions:
1. `invoke-static {}` on `Environment.getExternalStoragePublicDirectory(String)` — omitted the required `String` argument register
2. `new-array v8, v8, [B` appeared before v8 was initialised (duplicated line)

### Files — modified
```
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali  [MOD]
```

### Method-level changes

**`backupComponent()V`**
- Replaced `invoke-static {}` with:
  ```smali
  sget-object v0, Landroid/os/Environment;->DIRECTORY_DOWNLOADS:Ljava/lang/String;
  invoke-static {v0}, Landroid/os/Environment;->getExternalStoragePublicDirectory(Ljava/lang/String;)Ljava/io/File;
  ```

**`copyDir(File;File)V`**
- Removed duplicate `new-array v8, v8, [B` line (first occurrence was dead code before array size was set)

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v1.0.8
```

---

## Entry 004 — Fix ArrayAdapter crash (wrong layout resource ID)
**Date:** 2026-03-12
**Commit:** part of v1.0.9  |  **Tag:** `v1.0.9` `[CI✅]`

### Root cause
Hardcoded `0x01090001` resolved to an `ExpandableListView` row layout on this Android
version, not a simple text item → crash when ListView tried to inflate rows.

### Files — modified
```
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali  [MOD]
```

### Method-level changes

**`showComponents()V`** and **`showOptions()V`**
- Replaced `const v0, 0x01090001` with:
  ```smali
  sget v0, Landroid/R$layout;->simple_list_item_1:I
  ```
  Runtime resolves the Android framework's built-in single-text-line list item layout.

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v1.0.9
```

---

## Entry 005 — Fix invoke-virtual 6-register overflow in getFileName
**Date:** 2026-03-12
**Commit:** part of v1.0.10  |  **Tag:** `v1.0.10` `[CI✅]`

### Root cause
`ContentResolver.query(Uri, String[], String, String[], String)` takes 5 parameters +
the instance receiver = 6 registers total. `invoke-virtual` max is 5; 6+ requires
`invoke-virtual/range` with consecutive registers.

### Files — modified
```
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali  [MOD]
```

### Method-level changes

**`getFileName(Uri)String`** (added in this build)
- `.locals 6`
- Moved `ContentResolver` ref to `v4` so registers v3..v8 are consecutive for `invoke-virtual/range`
- Call: `invoke-virtual/range {v3 .. v8}, Landroid/content/ContentResolver;->query(...)Landroid/database/Cursor;`
- Reads `OpenableColumns.DISPLAY_NAME` (column index 0) via `cursor.getString(0)`

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v1.0.10
```

---

## Entry 006 — Fix "Inject failed" / wrong filename from getLastPathSegment
**Date:** 2026-03-12
**Commit:** part of v1.0.11  |  **Tag:** `v1.0.11` `[CI✅]`

### Root cause
`Uri.getLastPathSegment()` on a SAF `content://` URI returns the tree-path segment
(e.g. `primary:Download/file.wcp`), not the display filename. Replaced with a proper
`ContentResolver.query(DISPLAY_NAME)` lookup.

### Files — modified
```
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali  [MOD]
```

### Method-level changes

**`injectFile(Uri)V`**
- Removed `invoke-virtual {v0}, Landroid/net/Uri;->getLastPathSegment()Ljava/lang/String;`
- Added call to `this.getFileName(uri)` (the new `getFileName` method from Entry 005)
- Destination file in component folder now named correctly

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v1.0.11
```

---

## Entry 007 — Stable v2.0.0: working component manager
**Date:** 2026-03-12
**Commit:** (stable tag push)  |  **Tag:** `v2.0.0` `[CI✅]`

### What was done
- Promoted to stable after confirming: component list displays, backup works, raw file inject works
- GitHub release description written covering all features

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.0.0
```

---

---

# PHASE 2 — WCP / ZIP Extraction Pipeline (v2.0.1-pre → v2.0.6-pre)

---

## Entry 008 — WCP/ZIP extraction attempt 1: baksmali (failed)
**Date:** 2026-03-12
**Commit:** (v2.0.1-pre)  |  **Tag:** `v2.0.1-pre` `[CI❌]`

### What was done
- Plan: decompile library JARs to smali via baksmali, merge into patches
- `.github/workflows/build.yml`: added `wget` step for `baksmali.jar` from google/smali GitHub Releases
- **Failure:** GitHub Releases URL for `google/smali` returned 404 — no binary assets

### Files — modified
```
.github/workflows/build.yml  [MOD]
```

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.0.1-pre
```

---

## Entry 009 — WCP/ZIP extraction attempt 2: Maven baksmali (failed)
**Date:** 2026-03-12
**Commit:** (v2.0.2-pre)  |  **Tag:** `v2.0.2-pre` `[CI❌]`

### What was done
- Switched to `org.smali:baksmali:2.5.2` from Maven Central
- **Failure:** Maven artifact is a library-only JAR — `java -jar baksmali.jar` → "no main manifest attribute"
- **Decision:** Abandon baksmali entirely. New approach: download commons-compress + zstd + xz JARs,
  compile to dex via Android SDK `d8`, inject dex into APK via `zip`

### Files — modified
```
.github/workflows/build.yml  [MOD]
```

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.0.2-pre
```

---

## Entry 010 — WCP/ZIP extraction attempt 3: d8 dex injection + WcpExtractor (CI pass, runtime crash)
**Date:** 2026-03-12
**Commit:** (v2.0.3-pre)  |  **Tag:** `v2.0.3-pre` `[CI✅ build, ❌ runtime]`

### What was done
Rewrote WCP/ZIP injection to do real extraction. Created `WcpExtractor.smali`. Build
succeeded. Runtime crash: `Error` subclasses (e.g. `NoClassDefFoundError`) not caught
by `catch Ljava/lang/Exception;` — escaped and killed the app.

### Files — created / placed
```
METHOD: hand-written smali; placed directly into patches directory
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/WcpExtractor.smali  [NEW]
```

### Files — modified
```
.github/workflows/build.yml  [MOD]
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali  [MOD]
```

### build.yml changes (2 new steps added)
1. **"Convert extraction libraries to dex"**
   - `wget` from Maven Central: `commons-compress-1.26.2.jar`, `aircompressor-0.27.jar`, `xz-1.9.jar`
   - `d8 --release --min-api 29 --output lib_dex/ *.jar`
2. **"Inject library dex files into APK"**
   - `zip rebuilt-apk.apk lib_dex/classes*.dex` — appended as `classes18.dex`, `classes19.dex`, etc.

### WcpExtractor.smali — methods (new file)
| Method | Sig | Locals | What it does |
|--------|-----|--------|--------------|
| `extract` | `(ContentResolver;Uri;File;)V` | 12 | Entry point; reads 4-byte magic; routes to extractZip/extractTar |
| `extractZip` | `(InputStream;File;)V` | 6 | `ZipInputStream`, flat extraction (basename only) |
| `extractTar` | `(InputStream;File;Z)V` | 8 | Wraps in `ZstdInputStream` or `XZInputStream`, then `TarArchiveInputStream`; `s()` for `getNextTarEntry()`; flatten flag for FEXCore |
| `readProfile` | `(TarArchiveInputStream;)String` | 6 | Reads `profile.json` from tar, returns UTF-8 string |
| `clearDir` | `(File;)V` | 4 | Recursively deletes all files/dirs inside target dir |

### ComponentManagerActivity.smali changes
**`injectFile(Uri)V`**
- Replaced raw file copy body with: `invoke-static {cr, uri, componentDir}, WcpExtractor;->extract(...)V`

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.0.3-pre
```

---

## Entry 011 — Background thread + Throwable catch
**Date:** 2026-03-12
**Commit:** `7ad71f4`  |  **Tag:** `v2.0.4-pre` `[CI✅]`

### What was done
Moved extraction off the main thread (fixes freeze on large WCP files). Changed `catch`
from `Ljava/lang/Exception;` to `Ljava/lang/Throwable;` so `Error` subclasses are
caught and shown as toasts instead of crashing the app.

### Files — created / placed
```
METHOD: hand-written smali; placed directly into patches directory
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1.smali  [NEW]
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity$2.smali  [NEW]
```

### Files — modified
```
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali  [MOD]
```

### ComponentManagerActivity$1.smali (background Runnable, new file)
- `.class …ComponentManagerActivity$1;`
- `.super Ljava/lang/Object;`
- `.implements Ljava/lang/Runnable;`
- Fields: `this$0:ComponentManagerActivity`, `val$uri:Uri`, `val$componentDir:File`
- `run()V` — `.locals 5`; calls `WcpExtractor.extract(cr, uri, componentDir)` inside
  `:try_start` / `:try_end`; catch `Ljava/lang/Throwable;` saves message; constructs
  `ComponentManagerActivity$2` handler message; posts via `Handler(Looper.getMainLooper())`

### ComponentManagerActivity$2.smali (UI Runnable, new file)
- `.class …ComponentManagerActivity$2;`
- `.super Ljava/lang/Object;`
- `.implements Ljava/lang/Runnable;`
- Fields: `this$0:ComponentManagerActivity`, `val$error:String`
- `run()V` — `.locals 3`; if `val$error == null` → "Injected successfully" Toast; else
  → "Inject failed: <error>" Toast; both call `this$0.showComponents()` after

### ComponentManagerActivity.smali changes
**`injectFile(Uri)V`**
- `.locals 4` → `.locals 5`
- Replaced synchronous `WcpExtractor.extract()` call with:
  ```smali
  new-instance v0, Lcom/…/ComponentManagerActivity$1;
  invoke-direct {v0, p0, p1, v_componentDir}, Lcom/…/ComponentManagerActivity$1;-><init>(...)V
  new-instance v1, Ljava/lang/Thread;
  invoke-direct {v1, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
  invoke-virtual {v1}, Ljava/lang/Thread;->start()V
  ```

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.0.4-pre
```

---

## Entry 012 — XZ constructor fix + clear-before-inject
**Date:** 2026-03-12
**Commit:** `fb5592d`  |  **Tag:** `v2.0.5-pre` `[CI✅]`

### Root cause (XZ)
`XZInputStream(InputStream)V` was not found at runtime after d8 conversion of `xz-1.9.jar`.
`commons-compress` includes `XZCompressorInputStream` which wraps tukaani internally and
had a working constructor in the d8-compiled dex.

### Files — modified
```
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/WcpExtractor.smali  [MOD]
```

### Method-level changes

**`extractTar(InputStream;File;Z)V`**
- Replaced `new-instance …XZInputStream; invoke-direct {v0, stream}` with:
  ```smali
  new-instance v0, Lorg/apache/commons/compress/compressors/xz/XZCompressorInputStream;
  invoke-direct {v0, stream}, Lorg/apache/commons/compress/compressors/xz/XZCompressorInputStream;-><init>(Ljava/io/InputStream;)V
  ```
- Added `clearDir(destDir)` call at very start of `extract()` entry point — removes stale
  files from a previous inject before writing new ones

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.0.5-pre
```

---

## Entry 013 — CRITICAL FIX: Use GameHub built-in classes, remove d8 injection
**Date:** 2026-03-12
**Commit:** `b52055c`  |  **Tag:** `v2.0.6-pre` `[CI✅]`

### Root cause discovered
GameHub's APK already contains:
- `commons-compress` (obfuscated by ProGuard — method names mangled)
- `com.github.luben.zstd.ZstdInputStreamNoFinalizer` (JNI class — NOT obfuscated)
- `org.tukaani.xz.XZInputStream` (NOT obfuscated)

When we injected d8-converted JARs as extra dex files (classes18+), Android's class loader
found GameHub's obfuscated copy first (earlier dex index wins). So calling `getNextTarEntry()`
failed because it was renamed to `s()` in the obfuscated copy. For aircompressor:
`sun.misc.Unsafe.ARRAY_BYTE_BASE_OFFSET` doesn't exist on Android ART.

### Decision
Abandon all d8 injection. Use GameHub's built-in classes with their actual obfuscated
method names. Map each method by hand via jadx output.

### Obfuscated method map (commons-compress TarArchiveInputStream)
| Real method | Obfuscated name | Notes |
|-------------|-----------------|-------|
| `getNextTarEntry()` | `s()` | Returns `TarArchiveEntry` |
| `getName()` | kept | Via ArchiveEntry interface |
| `isDirectory()` | stripped | Use `getName().endsWith("/")` instead |
| `read(byte[],int,int)` | kept | 3-arg variant |

### Constructors confirmed working
| Class | Constructor |
|-------|-------------|
| `ZstdInputStreamNoFinalizer` | `<init>(Ljava/io/InputStream;)V` |
| `XZInputStream` | `<init>(Ljava/io/InputStream;I)V` (second arg: -1 = unlimited) |
| `TarArchiveInputStream` | `<init>(Ljava/io/InputStream;)V` |

### Files — modified
```
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/WcpExtractor.smali  [MOD]
.github/workflows/build.yml  [MOD]
```

### WcpExtractor.smali — full rewrite

**`extract(ContentResolver;Uri;File;)V`**
- `.locals 8`
- Opens URI via `cr.openInputStream(uri)` → wraps in `BufferedInputStream(stream, 8)`
- Calls `bis.mark(4)` then reads 4 bytes for magic detection
- Calls `bis.reset()` to rewind
- Routes: magic `50 4B` (ZIP) → `extractZip(bis, destDir)`; else → `extractTar(bis, destDir)`
- Calls `clearDir(destDir)` before routing

**`extractTar(InputStream;File;)V`** (signature changed — removed flatten param, auto-detect instead)
- `.locals 10`
- Reads first byte: `0x28` → `ZstdInputStreamNoFinalizer`; `0xFD` → `XZInputStream(-1)`
- Wraps result in `TarArchiveInputStream`
- Calls `readProfile(tar)` first pass to get type field
- Detects `FEXCore` → `flatten=true`; all others → `flatten=false`
- Second iteration (re-open): extracts files; if `flatten` strips to `basename`; else preserves path

**`readProfile(TarArchiveInputStream;)String`**
- `.locals 7`
- Loop via `invoke-virtual {v_tar}, Lorg/apache/…/TarArchiveInputStream;->s()Lorg/apache/…/TarArchiveEntry;`
- Finds entry whose `getName()` ends with `profile.json`
- Reads all bytes into `ByteArrayOutputStream`, returns `new String(bytes, "UTF-8")`

### build.yml changes
- Removed step "Convert extraction libraries to dex"
- Removed step "Inject library dex files into APK"

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.0.6-pre
```

---

---

# PHASE 3 — Polish (v2.1.0 → v2.2.0)

---

## Entry 014 — Stable v2.1.0: all three extraction paths confirmed working
**Date:** 2026-03-12
**Commit:** `de48d63`  |  **Tag:** `v2.1.0` `[CI✅]`

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.1.0
```

---

## Entry 015 — Add title header to all Component Manager views
**Date:** 2026-03-12
**Commit:** `6b9195d`  |  **Tag:** `v2.1.1` `[CI✅]`

### What was done
Users were tapping the wrong top-of-screen list item because the ListView started at y=0.
Wrapped content view in a `LinearLayout` with a `TextView` title above the `ListView`.

### Files — modified
```
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali  [MOD]
```

### Method-level changes

**`onCreate(Bundle)V`** — `.locals 2` → `.locals 6`
```
New code path:
  new-instance v0, LinearLayout
  invoke-direct {v0, p0}, LinearLayout::<init>(Context)V
  const/4 v1, 0x1  (VERTICAL)
  invoke-virtual {v0, v1}, LinearLayout::setOrientation(I)V

  new-instance v1, TextView
  invoke-direct {v1, p0}, TextView::<init>(Context)V
  const-string v2, "Banners Component Injector"
  invoke-virtual {v1, v2}, TextView::setText(CharSequence)V
  const/4 v2, 0x2  (TYPE_FLOAT for setTextSize first arg)
  const/high16 v3, 0x41A00000  (float 20.0)
  invoke-virtual {v1, v2, v3}, TextView::setTextSize(IF)V
  const/16 v2, 0x11  (CENTER_HORIZONTAL | CENTER_VERTICAL = 17)
  invoke-virtual {v1, v2}, TextView::setGravity(I)V
  const/16 v2, 0x30  (48 px padding)
  invoke-virtual {v1, v2, v2, v2, v2}, TextView::setPadding(IIII)V
  invoke-virtual {v0, v1}, ViewGroup::addView(View)V

  new-instance v1, ListView
  invoke-direct {v1, p0}
  iput-object v1, p0, …->listView
  new-instance v2, LinearLayout$LayoutParams
  const/4 v3, -1  (MATCH_PARENT width)
  const/4 v4, 0   (0 height — weight fills rest)
  const v5, 0x3f800000  (float 1.0 weight)
  invoke-direct {v2, v3, v4, v5}, LayoutParams::<init>(IIF)V
  invoke-virtual {v1, v2}, View::setLayoutParams(LayoutParams)V
  invoke-virtual {v0, v1}, ViewGroup::addView(View)V

  invoke-virtual {p0, v0}, Activity::setContentView(View)V
```

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.1.1
```

---

## Entry 016 — Show last injected filename per component (v2.1.2-pre)
**Date:** 2026-03-12
**Commit:** `cc31765` (fix) / `0070548` (initial, failed)  |  **Tag:** `v2.1.2-pre` `[CI✅]`

### What was done
After a successful inject, the component list row shows `"ComponentName [-> filename.wcp]"`.
Label persists across restarts via SharedPreferences (`bh_injected` prefs, keyed by folder name).

### Initial attempt failure
`invoke-direct` with 6 register args (instance + 5 params) is not valid — max 5 for
non-range. Fixed by restructuring: `getFileName()` is called inside `$1.run()` rather
than being passed as a constructor argument.

### Files — modified
```
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali  [MOD]
patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity$1.smali  [MOD]
```

### Method-level changes

**`ComponentManagerActivity.smali`**
- `showComponents()V` — `.locals 9` → `.locals 11`; added SharedPreferences open before name loop:
  ```smali
  const-string v9, "bh_injected"
  const/4 v10, 0x0
  invoke-virtual {p0, v9, v10}, Context::getSharedPreferences(String;I)SharedPreferences
  move-result-object v9
  ```
  In each loop iteration: `invoke-interface {v9, name}, SharedPreferences::getString(String;String)String`;
  if result non-null: builds `"name [-> filename]"` via `StringBuilder`

**`ComponentManagerActivity$1.smali`** (run()V)
- Added after successful extract:
  ```smali
  invoke-direct {v_this0, val$uri}, ComponentManagerActivity::getFileName(Uri)String  # gets display name
  move-result-object v_fname
  invoke-virtual {p0}, ComponentManagerActivity::getSharedPreferences(...)
  move-result-object v_prefs
  invoke-interface {v_prefs}, SharedPreferences::edit()Editor
  move-result-object v_edit
  invoke-interface {v_edit, v_compName, v_fname}, Editor::putString(String;String)Editor
  invoke-interface {v_edit}, Editor::apply()V
  ```

### Push
```
git push origin refs/heads/main
git push origin refs/tags/v2.1.2-pre
```

---

---

# PHASE 4 — True Component Injection (v2.2.5-pre)

---

## Entry 017 — Add ComponentInjectorHelper + "Add New Component" flow
**Date:** 2026-03-14
**Commit:** `e7dd944`  |  **Tag:** `v2.2.5-pre` `[CI✅]`
**CI run ID:** `23101614452` | Workflow: `build-quick.yml` | Duration: 3m38s

### Feature summary
Instead of replacing an existing component folder, the user can now pick a component TYPE
(DXVK / VKD3D / Box64 / FEXCore / GPU Driver) then a WCP or ZIP file, and the app:
1. Reads metadata from `profile.json` (WCP) or `meta.json` (ZIP) to get a display name
2. Creates a **new** folder inside `components/`
3. Extracts the file into that folder
4. Constructs a `ComponentRepo(state=INSTALLED)` and calls `EmuComponents.D()` so the
   component appears in GameHub's in-app selection menus immediately — nothing replaced

### Files — created / placed
```
METHOD: hand-written smali; copied from apktool_out/ → patches/ via `cp`
  cp apktool_out/smali_classes16/.../ComponentInjectorHelper.smali \
     patches/smali_classes16/.../ComponentInjectorHelper.smali

patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali  [NEW]
```

### Files — modified
```
METHOD: hand-written smali in apktool_out/; then copied to patches/ via `cp`

patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali  [MOD]
```

---

### ComponentInjectorHelper.smali — full method inventory

**Class declaration**
```smali
.class public final Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;
.super Ljava/lang/Object;
```
No instance fields. All methods are `public static`.

---

#### `getFirstByte(Context;Uri;)I`
- `.locals 2`
- Opens URI via `ContentResolver.openInputStream()`
- Reads 1 byte: `invoke-virtual {v0}, InputStream::read()I`
- AND-masks result: `and-int/lit16 v1, v1, 0xff` (unsigned 0-255)
- Closes stream
- Returns `-1` on any exception
- **Returns:** `0x28`=Zstd-WCP, `0xFD`=XZ-WCP, `0x50`=ZIP

---

#### `getDisplayName(Context;Uri;)String`
- `.locals 9` (v0-v5 must be consecutive for `invoke-virtual/range`, v6=cursor, v7=result, v8=scratch)
- `ContentResolver.query(uri, [DISPLAY_NAME], null, null, null)` via `invoke-virtual/range {v0..v5}`
- Moves cursor to first row, reads column 0
- At `:ret`: if result is empty, falls back to `uri.getLastPathSegment()` (covers `file://` URIs)
- At `:dn_err` (exception path): calls `uri.getLastPathSegment()` directly; returns `""` if null
- Returns display name string or `""` on error

---

#### `stripExt(String;)String`
- `.locals 2`
- `invoke-virtual {p0}, String::lastIndexOf(I)I` with `'.'` (0x2e)
- If index > 0: `invoke-virtual {p0, const/4 0x0, v0}, String::substring(II)String`
- Returns stripped name or original if no dot found

---

#### `makeComponentDir(Context;String;)File`
- `.locals 4`
- `getFilesDir()` → `/data/data/<pkg>/files`
- Appends `/usr/home/components/<name>/` via `new File(base, "usr/home/components/" + name)`
- `invoke-virtual {v0}, File::mkdirs()Z`
- Returns the `File` object

---

#### `readWcpProfile(Context;Uri;Z)String`
- `.locals 11`
- `p2=true` → Zstd path; `p2=false` → XZ path
- Opens URI stream; wraps in `ZstdInputStreamNoFinalizer` or `XZInputStream(-1)`, then `TarArchiveInputStream`
- Iterates via `invoke-virtual {v_tar}, TarArchiveInputStream::s()TarArchiveEntry`
- Finds entry whose `getName()` ends with `profile.json`
- Reads bytes into `ByteArrayOutputStream`
- Returns `new String(bytes, "UTF-8")`
- All wrapped in `:try_start` / `:try_end` / `:catch Ljava/lang/Exception; ... return-object ""`

---

#### `extractWcp(Context;Uri;File;ZZ)V`
- `.locals 12`
- `p3=isZstd`, `p4=flatten`
- Opens stream; wraps appropriately
- Iterates tar via `s()`:
  - Skips entries ending with `profile.json` or `/`
  - If `flatten=true`: strips path to last `/` component (`lastIndexOf('/')`)
  - If `flatten=false`: preserves full path (creates parent dirs as needed)
  - Writes via 4096-byte buffer loop

---

#### `extractZip(Context;Uri;File;)String`
- `.locals 8`
- Opens `ZipInputStream(ContentResolver.openInputStream(uri))`
- Iterates via `invoke-virtual {v_zip}, ZipInputStream::getNextEntry()ZipEntry`
- Checks for `meta.json`: reads into `ByteArrayOutputStream`, stores as `metaContent`
- All other entries: flat extraction (basename only via `lastIndexOf('/')`)
- Writes with 4096-byte buffer loop
- Returns `metaContent` string (or `""` if no `meta.json` found)

---

#### `registerComponent(Context;String;String;String;I)V`
- `.locals 20` — **critical**: with 5 params (p0-p4), they map to v20-v24; all 8-bit range instructions used for params

**EnvLayerEntity construction** — 18-param constructor, requires `invoke-direct/range {v0..v19}`:

| Register | Value | Field mapped to |
|----------|-------|-----------------|
| v0 | `new-instance EnvLayerEntity` | this |
| v1 | `move-object/from16 p3` | blurb (description) |
| v2 | `const-string ""` | fileMd5 |
| v3-v4 | `const-wide/16 0x0` | fileSize (long) |
| v5 | `const/4 0x0` | id (int) |
| v6 | `const-string ""` | logo |
| v7 | `move-object/from16 p1` | displayName |
| v8 | `move-object/from16 p1` | name (unique key) |
| v9 | `const-string ""` | fileName |
| v10 | `move/from16 p4` | type (int = contentType) |
| v11 | `move-object/from16 p2` | version |
| v12 | `const/4 0x0` | versionCode |
| v13 | `const-string ""` | downloadUrl |
| v14 | `const-string ""` | upgradeMsg |
| v15 | `const/4 0x0` | subData (null) |
| v16 | `const/16 0x0` | base (null) |
| v17 | `const/16 0x0` | framework (null) |
| v18 | `const/16 0x0` | frameworkType (null) |
| v19 | `const/16 0x0` | isSteam (int) |

```smali
invoke-direct/range {v0 .. v19}, Lcom/xj/winemu/api/bean/EnvLayerEntity;-><init>(
    Ljava/lang/String;Ljava/lang/String;JILjava/lang/String;Ljava/lang/String;
    Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;ILjava/lang/String;
    Ljava/lang/String;Lcom/xj/common/download/bean/SubData;
    Lcom/xj/winemu/api/bean/EnvLayerEntity;Ljava/lang/String;Ljava/lang/String;I)V
```

After `invoke-direct/range`: `move-object v8, v0` — saves entity into v8 (reuses v0-v7 for ComponentRepo)

**ComponentRepo construction** — 7-param constructor, `invoke-direct/range {v0..v7}`:

| Register | Value | Field |
|----------|-------|-------|
| v0 | `new-instance ComponentRepo` | this |
| v1 | `move-object/from16 p1` | name |
| v2 | `move-object/from16 p2` | version |
| v3 | `sget-object State->INSTALLED` | state |
| v4 | `move-object v8` | entity |
| v5 | `const/4 0x0` | isDep |
| v6 | `const/4 0x0` | isBase |
| v7 | `const/4 0x0` | depInfo (null) |

```smali
invoke-direct/range {v0 .. v7}, Lcom/winemu/core/ComponentRepo;-><init>(
    Ljava/lang/String;Ljava/lang/String;Lcom/winemu/core/State;
    Lcom/xj/winemu/api/bean/EnvLayerEntity;ZZLcom/winemu/core/DependencyManager$Companion$Info;)V
```

**EmuComponents registration:**
```smali
sget-object v1, Lcom/xj/winemu/EmuComponents;->c:Lcom/xj/winemu/EmuComponents$Companion;
invoke-virtual {v1}, Lcom/xj/winemu/EmuComponents$Companion;->a()Lcom/xj/winemu/EmuComponents;
move-result-object v1
invoke-virtual {v1, v0}, Lcom/xj/winemu/EmuComponents;->D(Lcom/winemu/core/ComponentRepo;)V
```

---

#### `injectComponent(Context;Uri;I)V`
- `.locals 12`
- Calls `getFirstByte(ctx, uri)` to determine format
- **ZIP path (`0x50`):**
  1. `getDisplayName(ctx, uri)` → `stripExt(name)` for folder name (fallback: `"driver_<timestamp>"`)
  2. `makeComponentDir(ctx, name)` → creates `components/<name>/`
  3. `extractZip(ctx, uri, dir)` → returns `metaContent` string
  4. Parse `metaContent` for `"name"` and `"description"` JSON fields (simple `indexOf`/`substring`, no Gson)
  5. `registerComponent(ctx, name, version, desc, 10)` (type 10 = GPU_DRIVER)
  6. Toast: `"Injected: <name>"`
- **WCP path (Zstd `0x28` or XZ `0xFD`):**
  1. `isZstd = (firstByte == 0x28)`
  2. First pass: `readWcpProfile(ctx, uri, isZstd)` → JSON string
  3. Parse `versionName` and `description` from JSON
  4. `makeComponentDir(ctx, versionName)` → creates `components/<versionName>/`
  5. Detect `flatten`: `contentType == 95` (FEXCore) → `true`; else `false`
  6. `extractWcp(ctx, uri, dir, isZstd, flatten)`
  7. Map contentType to version prefix string (DXVK/VKD3D/Box64/FEXCore/GPU)
  8. `registerComponent(ctx, versionName, versionName, desc, contentType)`
  9. Toast: `"Injected: <versionName>"`
- Whole body wrapped in `:try_start / :try_end / :catch Exception → Toast error message`

---

### CONTENT_TYPE integer constants (from PcSettingItemEntity.smali)
| Type | Int | Hex |
|------|-----|-----|
| GPU_DRIVER / Turnip | 10 | 0xa |
| DXVK | 12 | 0xc |
| VKD3D | 13 | 0xd |
| Box64 / TRANSLATOR_BOX | 94 | 0x5e |
| FEXCore / TRANSLATOR_FEX | 95 | 0x5f |

---

### ComponentManagerActivity.smali — method-level changes

**New field added:**
```smali
.field private selectedType:I
```

**`onCreate(Bundle)V`** — no change (`.locals 2` preserved)

**`showComponents()V`** — prepend `"+ Add New Component"` at index 0
- `.locals 11` → `.locals 11` (unchanged count)
- Before building display name array, insert at index 0:
  ```smali
  const-string v8, "+ Add New Component"
  aput-object v8, v_displayArray, const/4 0x0
  ```
- All existing component names shifted by +1 in the array
- `files[]` stored with a `null` slot at index 0 (no corresponding File)

**`showOptions()`** — label change only
- `"Inject file..."` → `"Inject/Replace file..."` (to distinguish from new inject flow)

**`showTypeSelection()V`** (NEW method)
- `.locals 5`
- Sets `iput p0, mode, 0x2`
- Creates `String[]` with 6 items:
  ```
  "DXVK"
  "VKD3D-Proton"
  "Box64"
  "FEXCore"
  "GPU Driver / Turnip"
  "← Back"
  ```
- Sets ArrayAdapter on listView with these items
- `setOnItemClickListener(this)` (already set in `onCreate`)

**`onItemClick(AdapterView;View;II)V`** — packed-switch updated for modes 0, 1, 2
- **Mode 0 (component list):**
  - `p3 == 0` → `showTypeSelection()` (new "Add New Component" header)
  - `p3 > 0` → `selectedIndex = p3 - 1`, `showOptions()` (offset by 1 due to header)
- **Mode 1 (options for existing component):**
  - item 0 → `pickFile()` (inject/replace)
  - item 1 → `backupComponent()`
  - item 2 → `showComponents()`
- **Mode 2 (type selection):**
  - item 0 → `iput 12, selectedType`; mode=3; `pickFile()`
  - item 1 → `iput 13, selectedType`; mode=3; `pickFile()`
  - item 2 → `iput 94, selectedType`; mode=3; `pickFile()`
  - item 3 → `iput 95, selectedType`; mode=3; `pickFile()`
  - item 4 → `iput 10, selectedType`; mode=3; `pickFile()`
  - item 5 → `showComponents()` (Back)

**`onActivityResult(IIIntent)V`** — branch on mode
- **mode == 3** (new inject):
  ```smali
  iget v1, p0, …->selectedType:I
  invoke-static {p0, v0, v1}, ComponentInjectorHelper::injectComponent(Context;Uri;I)V
  invoke-direct {p0}, ComponentManagerActivity::showComponents()V
  ```
- **mode == 1** (original replace): unchanged, calls `injectFile(uri)`

---

### Register constraint notes (applied in this build)
| Problem | Solution |
|---------|----------|
| `const/4` only supports 4-bit dest (v0-v15) | Used `const/16` for v16+ destinations |
| `move-object vX, pY` where pY > v15 | Used `move-object/from16 vX, pY` |
| `move vX, pY` where pY > v15 | Used `move/from16 vX, pY` |
| 20-register range for EnvLayerEntity ctor | Used `invoke-direct/range {v0..v19}` |
| Need v0-v7 for ComponentRepo after using v0-v19 | Saved entity to v8 first, then rebuilt v0-v7 |

---

### CI outcome
```
Run ID:   23101614452
Workflow: build-quick.yml (v*-pre* tag → Normal APK only)
Steps:    Setup → Checkout → Download APK → Install apktool → Decompile →
          Remove artifacts → Apply patches → Rebuild+Sign → Upload release
Result:   ✅ PASSED (3m 38s)
APK:      Bannerhub-5.3.5-Revanced-Normal.apk
```

### Commits and pushes (in order)
```
# Feature commit
git add patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali
git add patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali
git commit -m "feat: true component injection — add new components to GameHub menus"
git push origin refs/heads/main

# Tag push (triggers CI)
git tag v2.2.5-pre
git push origin refs/tags/v2.2.5-pre

# Docs commit (after CI passed)
git add PROGRESS_LOG.md
git commit -m "docs: update PROGRESS_LOG for v2.2.5-pre"
git push origin refs/heads/main

# Release description set (after CI completed)
gh release edit v2.2.5-pre --repo The412Banner/bannerhub --notes "..."
```

---

## Entry 018 — Menu visibility + FEXCore resilience (v2.2.6-pre)
**Date:** 2026-03-15  |  **Commit:** `00a324a`  |  **Tag:** v2.2.6-pre

### Problem diagnosed
Two bugs reported after v2.2.5-pre:
1. **DXVK folder created but not selectable in menu** — `SelectAndDownloadDialog` is
   100% server-driven. `EmuComponents.D()` writes to SharedPrefs, but `fetchList$1`
   only converts server-returned `EnvLayerEntity` objects into `DialogSettingListItemEntity`.
   Local components never reached the dialog list.
2. **FEXCore no folder created** — `readWcpProfile` returns null when XZ decompression
   fails or profile.json is absent. Previous code showed "No profile.json found in WCP"
   toast and returned without calling `makeComponentDir`.
3. **Bonus: State.INSTALLED triggers re-download** — `isComponentNeed2Download` only
   short-circuits on `Extracted` (and `Downloaded`). INSTALLED falls through, causing
   GameHub to attempt a re-download from the empty URL.

### Root cause analysis path
- Read `SelectAndDownloadDialog.smali` → confirmed `fetchList.invoke(type, callback)`
  is the only data source; `isInstalled$1` only marks server items as installed by name
- Read `GameSettingViewModel.n()` (smali_classes10) → maps content types to subtypes,
  launches `fetchList$1` coroutine, sends server call
- Read `GameSettingViewModel$fetchList$1.smali` (2971 lines) → found callback invocation
  at line 2951: `iget $callback; invoke-interface {callback, list}` — v7=list, v5=state obj
- Read `PcSettingItemEntity.smali` → confirmed constants:
  `CONTENT_TYPE_TRANSLATOR=0x20=32`, `TRANSLATOR_BOX=0x5e=94`, `TRANSLATOR_FEX=0x5f=95`
- Read `EmuComponents$Companion.smali` → `a()` calls `EmuComponents.e()` (no Context needed)
- Read `State.smali` → confirmed `LState;->Extracted:LState;` exists (obfuscated root class)
- Read `DialogSettingListItemEntity.smali` → no-arg constructor at line 91;
  setters: `setTitle`, `setDisplayName`, `setType`, `setEnvLayerEntity`, `setDownloaded`

### Files created
```
[NEW] patches/smali_classes3/com/xj/winemu/settings/
      GameSettingViewModel$fetchList$1.smali
      — copied from apktool_out/, 2 lines added before callback invocation
      — method: cp apktool_out/... patches/...
```

### Files modified
```
[MOD] patches/smali_classes16/com/xj/landscape/launcher/ui/menu/
      ComponentInjectorHelper.smali

Change A — injectComponent (WCP branch, null profile fallback):
  OLD: if-nez v1, :have_profile
       const-string v8, "No profile.json found in WCP"
       goto :toast_and_return

  NEW: if-nez v1, :have_profile
       # fall back to filename
       invoke-static getDisplayName(p0, p1) → v3
       invoke-static stripExt(v3) → v3
       move-object v4, v3; const-string v5, ""; goto :have_name

Change B — registerComponent (State fix):
  OLD: sget-object v3, LState;->INSTALLED:LState;
  NEW: sget-object v3, LState;->Extracted:LState;

Change C — new method appendLocalComponents(List<DSLIE>, int):
  .locals 9; try-catch wraps entire method
  1. EmuComponents.e() → check null
  2. iget HashMap a → values() → iterator()
  3. For each ComponentRepo: getEntry() → getType()
  4. if type==p1 OR (p1==32 AND type in {94,95}): type_match
  5. Build DialogSettingListItemEntity via <init>() + setTitle/setDisplayName/
     setType(p1)/setEnvLayerEntity/setDownloaded(true)
  6. list.add(item)
```

```
[MOD] patches/smali_classes3/com/xj/winemu/settings/
      GameSettingViewModel$fetchList$1.smali

Change D — inject appendLocalComponents call (2 lines before callback):
  Original line 2944: invoke-virtual setData(v7)
  Original line 2947: iget-object $callback

  Inserted between:
    iget v0, v5, ...->$contentType:I
    invoke-static ComponentInjectorHelper;->appendLocalComponents(v7, v0)
```

### CI
```
Workflow:   build-quick.yml (v*-pre* tag → Normal APK only)
Run ID:     23102478881
Steps:      Setup → Checkout → Download APK → Install apktool → Decompile →
            Remove artifacts → Apply patches → Rebuild+Sign → Upload release
Result:     ✅ PASSED (3m 37s)
APK:        Bannerhub-5.3.5-Revanced-Normal.apk
```

### Commits and pushes
```
git add patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali
git add "patches/smali_classes3/com/xj/winemu/settings/GameSettingViewModel$fetchList$1.smali"
git commit -m "fix: component injection — menu visibility + FEX resilience"
git push origin refs/heads/main
git tag v2.2.6-pre
git push origin refs/tags/v2.2.6-pre
gh release edit v2.2.6-pre --notes "..."
```

---

## Entry 019 — [not recorded]
## Entry 020 — [not recorded]
> **Gap note:** Entries 019 and 020 were never written. There were no feature commits between
> v2.2.6-pre (`00a324a`) and v2.2.7-pre (`d6d9965` / `fd5e176`) aside from a docs update
> (`441a132` — update PROGRESS_LOG for v2.2.6-pre). The session that produced these entries
> did not assign these numbers to any work unit. Numbering continues at Entry 021.

---

---

# Appendix A — EmuComponents API

| Item | Value |
|------|-------|
| Singleton class | `Lcom/xj/winemu/EmuComponents;` |
| Companion field | `->c:Lcom/xj/winemu/EmuComponents$Companion;` |
| Instance getter | `Companion->a()Lcom/xj/winemu/EmuComponents;` |
| Register method | `EmuComponents->D(LComponentRepo;)V` (keyed by `ComponentRepo.getName()`) |
| SharedPrefs key | `sp_winemu_all_components12` |
| Note | Use `D()` directly — `C()` forces state=Downloaded, overrides INSTALLED |

---

# Appendix B — File locations reference

| Logical path | Actual path |
|--------------|-------------|
| patches dir | `bannerhub/patches/` |
| classes16 menu | `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/` |
| apktool_out mirror | `apktool_out/smali_classes16/com/xj/landscape/launcher/ui/menu/` |
| components dir (runtime) | `<getFilesDir()>/usr/home/components/` |
| bh_injected prefs | SharedPreferences file `bh_injected` in app's prefs dir |

---

---

## Entry 021 — Title + system bar padding (v2.2.7-pre)
**Date:** 2026-03-15  |  **Commit:** `d6d9965`  |  **Tag:** v2.2.7-pre

### Changes
- **Title:** `"Component Manager"` → `"Banners Component Manager"`
- **`setFitsSystemWindows(true)`** on ListView: system automatically applies insets for status bar (top) and navigation bar (bottom)
- **`setClipToPadding(false)`** on ListView: list scrolls behind the padding area so no items are permanently hidden

### Root cause
ListView was set as the raw content view with no inset handling. GameHub's theme hides the ActionBar entirely, so `setTitle()` had no visible effect. On devices with on-screen navigation buttons, the last few list items were obscured and untappable.

### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

### CI result
✅ Passed — run ID not recorded (shared CI run with Entry 022 under v2.2.7-pre tag at `fd5e176`)

---

## Entry 022 — ZIP injection: name/dir mismatch + libraryName rename (v2.2.7-pre)
**Date:** 2026-03-15  |  **Commit:** `fd5e176`  |  **Tag:** v2.2.7-pre

### Changes

**Fix 1 — directory/name mismatch**
Root cause: `makeComponentDir` was called with the ZIP filename before `meta.json` was read. The `meta.json["name"]` field then overwrote `v3` (the component name) for registration but the files were already extracted to the filename-based directory. GameHub looked up the component path by registered name → found an empty/missing folder → `enabled=false` → "Illegal driver dir!". Fix: `meta.json["name"]` is never used. ZIP filename is always both the directory name and the registered name. `meta.json["driverVersion"]` is now used as the version string (fallback to filename).

**Fix 2 — wrong .so filename**
Root cause: Some ZIPs (e.g. StevenMX `Turnip_v26.1.0_R4.zip`) contain `vulkan.ad07XX.so` instead of `libvulkan_freedreno.so`. GameHub's `launchContainer$1` checks for `libvulkan_freedreno.so` at component root only. Fix: after extraction, read `meta.json["libraryName"]`; if non-empty and ≠ `libvulkan_freedreno.so`, call `File.renameTo()` to rename it.

### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali`

### CI result
✅ Passed

---

## Entry 023 — Remove component option (v2.2.8-pre)
**Date:** 2026-03-15  |  **Commit:** `5b39138`  |  **Tag:** v2.2.8-pre

### Changes

**New feature — Remove option in component options menu**
Added "Remove" as a third option in the per-component options menu (Inject/Replace, Backup, **Remove**, Back).

- `showOptions()`: expanded array from 3 → 4 items; "Remove" at index 2; "← Back" shifted to index 3.
- `onItemClick()` mode=1 packed-switch: added `:sw1_2` → `removeComponent()`; renamed old `:sw1_2` (Back) to `:sw1_3`; packed-switch table updated to 4 entries.
- New `removeComponent()V`: gets selected component folder + name, calls `EmuComponents.e().a.remove(name)` to unregister from in-memory HashMap (component disappears from GameHub selection menus immediately), calls `deleteDir()` to recursively delete the folder, shows "Removed: <name>" toast, refreshes component list.
- New `deleteDir(File)V` static: recursive file/folder deleter — `listFiles()` → recurse into subdirs → `File.delete()` on each file → `File.delete()` on dir itself.

### Root cause / design note
`EmuComponents.a` (HashMap) is the runtime component registry. Removing from it causes the component to vanish from all selection menus for the current session. The folder deletion ensures the component cannot be re-injected without going through the normal inject flow. SharedPrefs (`sp_winemu_all_components12`) is not directly manipulated — GameHub validates file existence before using a component path, so a missing folder renders any persisted entry inert.

### Files touched
- `[MOD]` `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`
  - `showOptions()` — +1 array item, new "Remove" entry
  - `onItemClick()` — new `:sw1_2` + `:sw1_3` labels; packed-switch extended
  - `removeComponent()V` — new method, .locals 6
  - `deleteDir(File)V` — new static method, .locals 5

### CI result
✅ Passed — run `23114139058` (3m41s)

---

## Entry 024 — Shrink RTS gesture settings dialog ~20% (v2.2.9-pre)
**Date:** 2026-03-15  |  **Commit:** `bb3d420`  |  **Tag:** v2.2.9-pre

### Changes
Navigation bar and status bar were overlapping the RTS gesture settings dialog, blocking users from tapping buttons (especially Close).

- All 6 gesture row heights: `@dimen/dp_48` → `38dp` inline (21% reduction per row)
- Close button height: `@dimen/mw_44dp` → `35dp` (20% reduction)
- Dialog `paddingBottom`: `@dimen/mw_16dp` → `12dp`
- Title `marginTop`: `@dimen/mw_14dp` → `11dp`
- ScrollView `marginTop`: `@dimen/mw_16dp` → `12dp`
- Close button `marginTop`: `@dimen/mw_16dp` → `12dp`

Uses inline dp values — no patches/dimens.xml exists, so new dimen references would require adding one.

Total height reduction: 6×(48−38) + (44−35) + margin savings ≈ 75dp+ freed.

### Files touched
- `[MOD]` `patches/res/layout/rts_gesture_config_dialog.xml`

### CI result
✅ Passed — run `23114552262` (3m41s)

---

## Entry 025 — In-app Component Downloader (v2.3.2-pre)
**Date:** 2026-03-16  |  **Commit:** `9849bd9`  |  **Tag:** v2.3.2-pre

### Changes

**New feature — "↓ Download from Online Repos" in component type-selection menu**

New `ComponentDownloadActivity` (3-mode ListView): repo list → category → asset list → download + inject.

**Architecture:**
- `mode` field (0=repos, 1=categories, 2=assets) drives all ListView state
- `mAllNames`/`mAllUrls` — full list from fetch; `mCurrentNames`/`mCurrentUrls` — filtered by category
- `mDownloadFilename` / `mDownloadUrl` — set on asset tap, consumed by `$3` DownloadRunnable
- `detectType(String)I` — toLowerCase, checks: box64→94, fex→95, vkd3d→13, turnip/adreno/driver/qualcomm→10, default DXVK→12
- `onBackPressed()`: mode2→showCategories(), mode1→showRepos(), mode0→super (finish)

**Inner classes:**
- `$1` — FetchRunnable: GitHub Releases API, finds first `nightly-*` tag, collects .wcp/.zip/.xz assets
- `$2` — ShowCategoriesRunnable: posts `showCategories()` to UI thread after fetch
- `$3` — DownloadRunnable: streams file from URL to `cacheDir/mDownloadFilename`, posts `$5`
- `$4` — CompleteRunnable: shows Toast + `finish()`
- `$5` — InjectRunnable: calls `ComponentInjectorHelper.injectComponent()` on UI thread (Looper fix — Toast inside injectComponent requires main thread)
- `$6` — PackJsonFetchRunnable: GET flat JSON array (type/verName/remoteUrl), skips Wine/Proton, uses verName as display name; used by Arihany WCPHub
- `$7` — KimchiDriversRunnable: GET JSONObject root → releases[] → assets[], reads `tag`+`original_url`; `.locals 15` max (p0=v15, 4-bit register limit) **[DEAD CODE — superseded by $9; still present in smali but no longer called]**
- `$8` — SingleReleaseRunnable: GET GitHub Releases tags endpoint → single JSONObject → assets[]; strips `tmp[random]_` prefix from asset names **[DEAD CODE — superseded by $9; still present in smali but no longer called]**
- `$9` — GpuDriversFetchRunnable: GET flat JSON array (type/verName/remoteUrl), skips Wine/Proton, uses verName as display name; used by all 4 GPU driver repos; `.locals 12` (p0=v12)

**Repos (5 GPU + 1 WCP):**
- Arihany WCPHub — `pack.json` flat array via `$6`/`startFetchPackJson()`
- Kimchi GPU Drivers — `kimchi_drivers.json` flat array via `$9`/`startFetchGpuDrivers()`
- StevenMXZ GPU Drivers — `stevenmxz_drivers.json` flat array via `$9`
- MTR GPU Drivers — `mtr_drivers.json` flat array via `$9`
- Whitebelyash GPU Drivers — `white_drivers.json` flat array via `$9`

**Key smali constraints encountered:**
- `.locals 16` makes p0=v16, out of 4-bit register range for iget-object/invoke-virtual → max `.locals 15`
- Register reuse: v5 (StringBuilder/responseStr) freed after JSON parse, reused as asset URL in inner loop
- `mAllNames.clear()` / `mAllUrls.clear()` required before each new repo fetch to prevent list mixing on back+reselect

### Root cause / design note
`ComponentInjectorHelper.injectComponent()` calls `Toast.makeText()` internally, which requires the main (Looper) thread. A naive background thread call crashes with "Can't create handler inside thread that has not called Looper.prepare()". Fix: `$5` InjectRunnable posts the inject call via `runOnUiThread()`.

### Files touched
- `[MOD]` `patches/smali_classes16/.../ComponentManagerActivity.smali`
  - `showTypeSelection()` — added "↓ Download from Online Repos" at index 0 of type array (array size 6→7); all other types shifted up by 1
  - `onItemClick()` mode=2 — added `if-nez p3, :not_download` branch: position 0 starts ComponentDownloadActivity, positions 1–5 feed `sw2_data` (subtract 1 to re-index)
- `[NEW]` `patches/smali_classes16/.../ComponentDownloadActivity.smali`
- `[NEW]` `patches/smali_classes16/.../ComponentDownloadActivity$1.smali` through `$9.smali` (9 inner classes)

### CI result
✅ Passed — run `23145292442` (3m45s, v2.3.2-pre)

---

## Entry 026 — Fix blank component name after ZIP inject (v2.3.2-pre)
**Date:** 2026-03-16  |  **Commit:** `a893204`  |  **Tag:** (included in v2.3.2-pre roll-up)

### Changes

**Bug fix — downloaded ZIP components injected with blank name**

### Root cause
`ComponentInjectorHelper.injectComponent()` ZIP branch calls `getDisplayName(ctx, uri)` which queries ContentResolver for `_display_name`. For `file://` URIs created by `Uri.fromFile(cacheFile)` (the download cache path used by `$3` DownloadRunnable), ContentResolver returns a null cursor → `v7 = ""` → `stripExt("") = ""` → component registered with blank `displayName`/`name` → appears blank in GameHub's GPU driver selection list and in the inject success toast.

### Fix
In `getDisplayName()`: after the try block, at `:ret`, check if `v7.isEmpty()` and if so call `uri.getLastPathSegment()` as fallback. For `file://` URIs this returns the filename (e.g. `"v840 — Qualcomm_840_adpkg.zip"`). `stripExt()` then gives a proper component name. Same fallback applied in the `:dn_err` exception-handler path for robustness.

### Files touched
- `[MOD]` `patches/smali_classes16/.../ComponentInjectorHelper.smali`
  - `getDisplayName()` — added isEmpty check + `Uri.getLastPathSegment()` fallback at `:ret` and `:dn_err`

### CI result
✅ Passed — included in v2.3.2-pre build (run `23145292442`)

---

## Entry 027 — Fix: same-version driver variants collide on install (v2.3.3-pre)
**Date:** 2026-03-16  |  **Commit:** `a80947d`  |  **Tag:** `v2.3.3-pre` `[CI✅ 23149773741, 3m41s]`

### Root cause
`mDownloadFilename` is set to `verName` from the JSON (e.g. `Turnip_MTR_v2.0.0-b_Axxx`) with **no file extension**. After download, the cache file URI is `file://.../Turnip_MTR_v2.0.0-b_Axxx`. `injectComponent()` calls `getLastPathSegment()` → returns bare name → `stripExt()` calls `lastIndexOf('.')` → finds the last `.` inside the version number (`v2.0.`**`0`**`-b`) → returns `Turnip_MTR_v2.0`. Both the `-b` and `-p` variants strip to the same name → second install overwrites first in GameHub's component registry and on disk.

### Fix
In `onItemClick()` mode=2, after storing `mDownloadUrl` (v1), parse the URL with `Uri.parse()`, call `getLastPathSegment()` to get the URL filename (e.g. `Turnip_MTR_v2.0.0-b_Axxx.zip`), find `lastIndexOf('.')` to extract the extension (`.zip`), and `concat()` it onto `mDownloadFilename`. The cache file is now `Turnip_MTR_v2.0.0-b_Axxx.zip`; `stripExt()` correctly strips `.zip`; both variants get distinct names.

`.locals 2` → `.locals 4` (v2=Uri/segment/ext string, v3=lastIndexOf result/filename).

### Files touched
- `[MOD]` `patches/smali_classes16/.../ComponentDownloadActivity.smali`
  - `onItemClick()` — `.locals 2` → `.locals 4`; 15-line extension-extraction block inserted after `iput mDownloadUrl`

### CI result
✅ Passed — run `23149773741` (3m41s)

---

## Entry 028 — Add The412Banner Nightlies repo (v2.3.4-pre)
**Date:** 2026-03-16  |  **Commit:** `babe5f9`  |  **Tag:** `v2.3.4-pre` `[CI✅ 23151833249, 3m41s]`

### What was added
Added The412Banner Nightlies as a 6th repo option in `ComponentDownloadActivity`. Uses `startFetchPackJson()` → `$6` PackJsonFetchRunnable (flat JSON array format — same as Arihany WCPHub). Array size bumped 6 → 7; "Back" entry shifted from index 5 → 6; new `sw0_5` packed-switch handler added.

### Files touched
- `[MOD]` `patches/smali_classes16/.../ComponentDownloadActivity.smali`
  - `onItemClick()` mode=0 — array size 6→7, new `sw0_5` handler block; packed-switch table extended by one entry
  - New handler: `invoke-virtual {p0, v3}, ComponentDownloadActivity.startFetchPackJson(String)V` with Nightlies pack.json URL

### CI result
✅ Passed — run `23151833249` (3m41s)

---

## Entry 029 — Stable release v2.3.5
**Date:** 2026-03-16  |  **Commit:** `948e1ef`  |  **Tag:** `v2.3.5` `[CI✅ 23155662795, 6m9s — 8 APKs]`

### What this release includes (cumulative since v2.3.0)
All Component Manager and Component Downloader work promoted to stable:

- In-app component downloader (`ComponentDownloadActivity`) — Entries 025–028:
  - 3-mode ListView: repos → categories → assets
  - GitHub Releases API fetch (`$1`/`$2`) for Nightlies-style repos (finds first `nightly-*` tag)
  - pack.json fetch (`$6`) for flat JSON array repos (Arihany WCPHub, The412Banner Nightlies)
  - Download → inject pipeline with Looper fix (`$5` InjectRunnable)
  - Back navigation between modes; "Back" entry as last list item
  - Two repos: Arihany WCPHub + The412Banner Nightlies
- GPU driver variant collision fix (Entry 027) — URL extension appended to `mDownloadFilename`
- All prior Component Manager features from PHASE 1–4 (Entries 001–023)

### CI result
✅ Passed — `build.yml` (stable tag) — run `23155662795` (6m9s) — 8 APKs built (Normal, CrossFire, PuBG, AnTuTu, AnTuTu-full, Ludashi, Genshin, SteamOnly)

---

## Entry 030 — Add workflow_dispatch to build-quick.yml (CI verification)
**Date:** 2026-03-17  |  **Commit:** `ff9267d`  |  **Tag:** none  |  **CI:** `23188227052` (in progress)

### Files created / moved / deleted
- `.github/workflows/build-quick.yml` [MOD] — added `workflow_dispatch:` trigger

### Methods added / changed
None — CI workflow change only.

### Root cause / rationale
Base APK asset was re-uploaded on 2026-03-17; needed a way to verify integrity via a full CI build without pushing a placeholder pre-release tag. Added `workflow_dispatch` so the quick build (Normal APK only) can be triggered manually at any time.

### CI result
❌ Failed — `build-quick.yml` run `23188227052` — classes12 dex index limit (65546 > 65535)

---

## Entry 047 — CPU core dialog: inline labels, column divider, WRAP_CONTENT height (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `f96f8df`  |  **Tag:** v2.4.2-beta10  |  **CI:** ✅

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali` [MOD]

### Methods added / changed
**`CpuMultiSelectHelper.show()`** — (1) All CheckBox labels changed from `"Core N\n(Type)"` to `"Core N (Type)"` — single line. (2) After each left CheckBox `addView`, adds a `View` with `setBackgroundColor(0xFF808080)` and `addView(row, view, 2, -1)` (2px wide, MATCH_PARENT height) as a column divider. (3) `Window.setLayout()` now uses `WRAP_CONTENT (-2)` for height instead of `heightPixels * 9/10` — dialog snaps to content with no empty space.

### Root cause / rationale
UX cleanup: two-line labels wasted vertical space; no visual separation between columns made the grid hard to read; WRAP_CONTENT height removes the large gap below the 4 rows that the 90% calculation produced.

---

## Entry 046 — CPU core dialog: fix grid to 4×2 vertical (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `b6cfda4`  |  **Tag:** v2.4.2-beta9b  |  **CI:** ✅

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali` [MOD]

### Methods added / changed
**`CpuMultiSelectHelper.show()`** — Grid layout changed from 2 rows × 4 cols to 4 rows × 2 cols. Each row has left=Efficiency core (0-3), right=Perf/Prime core (4-7). Same TableLayout/TableRow/$4 pattern.

---

## Entry 045 — CPU core dialog: 2×4 grid layout (TableLayout + $4 CheckBox listener) (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `158d98c`  |  **Tag:** v2.4.2-beta9  |  **CI:** ✅ build-quick.yml — success

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali` [MOD]
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$4.smali` [NEW]

### Methods added / changed
**`CpuMultiSelectHelper.show()`** — Replaced `CharSequence[8]` labels + `$1` + `setMultiChoiceItems()` with a `TableLayout` containing 2 `TableRow`s of 4 `CheckBox` each. `setView(tableLayout)` used instead of `setMultiChoiceItems`. `setStretchAllColumns(true)` distributes columns equally. Each CheckBox initialized from `checked[]`, gets a `$4` listener. `$2` (Apply) and `$3` (No Limit) still read from the shared `checked[]` reference — updated live by $4.
**`CpuMultiSelectHelper$4.onCheckedChanged()`** — New class. Captures `a:[Z` (checked array) and `b:I` (index). `onCheckedChanged` does `aput-boolean p2, v0, v1` — stores the new boolean state into the array at the stored index.

### Root cause / rationale
`setMultiChoiceItems` produces a ListView — one item per row. User requested 2 rows of 4 checkboxes (Efficiency cores / Performance+Prime cores). `TableLayout` with `TableRow` is the natural Android view for fixed grids and requires no RecyclerView/GridView adapter complexity. The `$4` listener pattern uses a single reusable class (one instance per checkbox, different index captured in constructor) rather than 8 separate inner classes.

---

## Entry 044 — CPU core dialog: warn if no cores selected on Apply (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `23e8470`  |  **Tag:** v2.4.2-beta8c  |  **CI:** ✅ build-quick.yml — success

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali` [MOD]

### Methods added / changed
**`CpuMultiSelectHelper$2.onClick()`** — After bitmask fold (before all-cores check): `if-nez v1, :cond_hasmask` — if mask=0 (no cores checked), calls `Toast.makeText(ctx, "Select at least one core", LENGTH_SHORT).show()` and returns without saving. Context obtained via `move-object/from16 v4, p1` + `check-cast v4, Dialog` + `getContext()`. `move-object/from16` required because p1=v34 with `.locals 33` (exceeds 4-bit range of regular `move-object`).

### Root cause / rationale
Without this guard, unchecking all cores and hitting Apply silently saves mask=0 (No Limit) — same as the "No Limit" button — which could confuse a user who thought they were cancelling. The Toast makes the no-selection state explicit.

### CI notes
beta8 failed: used `move-object v4, p1` — p1=v34 exceeds 4-bit src limit of `move-object` (format 12x). beta8b failed: same — fix used `check-cast v4` but smali reported error at check-cast line. beta8c: corrected to `move-object/from16 v4, p1` — passes.

---

## Entry 043 — CPU core dialog: half-width, 90% height, all-cores = No Limit (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `3fab423`  |  **Tag:** v2.4.2-beta7  |  **CI:** pending

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali` [MOD]
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali` [MOD]

### Methods added / changed
**`CpuMultiSelectHelper.show()`** — `Window.setLayout()` now uses `widthPixels / 2` (was `WRAP_CONTENT`) and `heightPixels * 9/10` (was 80%). `iget v4, v3, ...->widthPixels:I` + `div-int/lit8 v4, v4, 0x2`; `iget v3, v3, ...->heightPixels:I` + `mul-int/lit16 v3, v3, 0x9` + `div-int/lit16 v3, v3, 0xa`.
**`CpuMultiSelectHelper$2.onClick()`** — After folding 8-core bitmask into `v1`, added all-cores check: `const/16 v2, 0xff` / `if-ne v1, v2, :cond_notmax` / `const/4 v1, 0x0` / `:cond_notmax`. If all 8 cores are checked, the saved mask is 0 (No Limit) instead of 0xFF.

### Root cause / rationale
UX: A half-width dialog is better for the 8-item checkbox list on a wide landscape screen. 90% height allows more rows visible without being too tall. All-8-cores selected is semantically identical to "No Limit" (unrestricted affinity), so the mask is normalized to 0.

---

## Entry 042 — Fix IllegalAccessError: use Kotlin defaults ctor + move-object/from16 (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `e8e41a8`  |  **Tag:** v2.4.2-beta6b  |  **CI:** ✅ build-quick.yml run 23221056206 — 3m38s

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali` [MOD]
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$3.smali` [MOD]

### Methods added / changed
**`CpuMultiSelectHelper$2.onClick()`** — Replaced `iput id` + `iput-boolean isSelected` with full Kotlin defaults constructor `invoke-direct/range {v7 .. v32}`. Bitmask `0x3ffffa`: bit0=0 (provide id at v8), bit2=0 (provide isSelected at v10), all other bits=1 (use defaults). Added `move-object/from16 v3, p0` at start (`.locals 33` pushes p0 to v33, out of 4-bit range).
**`CpuMultiSelectHelper$3.onClick()`** — Same fix. `move-object/from16 v6, p0`. `id=0` (No Limit). Same 26-register defaults ctor pattern.

### Root cause / rationale
`IllegalAccessError` on Apply/No Limit: ART 14 blocks cross-dex private field access. `DialogSettingListItemEntity` is in classes12 (bypassed dex); our code is in classes16. `iput` on private backing fields (`id`, `isSelected`) threw `Field 'id' is inaccessible`. Fix: use the public Kotlin defaults constructor which goes through normal method dispatch rather than direct field access. The defaults bitmask pattern was already established in `PcGameSettingOperations` calls in the same codebase.

---

## Entry 041 — Immediate UI refresh via DialogSettingListItemEntity (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `77c6cf2`  |  **Tag:** v2.4.2-beta5  |  **CI:** ✅ build-quick.yml run 23205026060 — 3m40s

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali` [MOD]
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali` [MOD]
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$3.smali` [MOD]

### Methods added / changed
**`CpuMultiSelectHelper.show()`** — $2 constructor updated to `([ZSPUtilsStringFunction1)V` (5 args, non-range). $3 to `(SPUtilsStringFunction1)V` (4 args). Both now receive `p3` (callback).
**`CpuMultiSelectHelper$2.onClick()`** — After `SPUtils.m()`, constructs `new DialogSettingListItemEntity()`, sets `id=newMask` via `iput`, `isSelected=true` via `iput-boolean`, calls `callback.invoke(entity)`.
**`CpuMultiSelectHelper$3.onClick()`** — Same pattern with `id=0`.

### Root cause / rationale
beta4 removed callback invocation entirely — the row label only refreshed on back-out/re-enter. The original `e()` calls `callback.invoke(entity)` where entity is `DialogSettingListItemEntity`. `u0.invoke(entity)` uses the entity type correctly; when passed the wrong type (View) it crashed because Q() received something it couldn't use and produced null for j3. Fix: create a minimal entity with `id=newMask, isSelected=true` and pass it. `DialogSettingListItemEntity.<init>()V` initializes all fields to zero/null/false, so only `id` and `isSelected` need to be set.

---

## Entry 040 — Remove callback invocation to fix j3 NPE crash; 80% height; smaller text (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `401e43b`  |  **Tag:** v2.4.2-beta4  |  **CI:** ✅ build-quick.yml run 23204360488 — 3m51s

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali` [MOD]
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali` [MOD]
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$3.smali` [MOD]

### Methods added / changed
**`CpuMultiSelectHelper.show()`** — Labels now built with `Html.fromHtml("<small>Core N (Type)</small>", 0)` for smaller text. $2 constructor call: `invoke-direct {v6, v2, v3, v4}` (4 args — no range). $3: `invoke-direct {v7, v3, v4}` (3 args). Height: `heightPixels * 4/5` (80%).
**`CpuMultiSelectHelper$2.onClick()`** — Removed `callback.invoke(anchorView)` block. Now only folds bitmask and calls `SPUtils.m(key, mask)`.
**`CpuMultiSelectHelper$3.onClick()`** — Removed `callback.invoke(anchorView)` block. Now only calls `SPUtils.m(key, 0)`.
**`CpuMultiSelectHelper$2.<init>`** — Signature simplified to `([ZLcom/blankj/utilcode/util/SPUtils;Ljava/lang/String;)V`. Removed `Function1 d` and `View e` fields.
**`CpuMultiSelectHelper$3.<init>`** — Signature simplified to `(Lcom/blankj/utilcode/util/SPUtils;Ljava/lang/String;)V`. Removed `Function1 c` and `View d` fields.

### Root cause / rationale
NPE crash: `j3, parameter it is null`. Traced call chain: our `$2/$3.onClick()` called `callback.invoke(anchorView)` → `u0.invoke(view)` → `PcGameSettingsKt.Q(...)` → `j3(null)`. Root cause: `u0` is a lambda that expects to receive a `DialogSettingListItemEntity` (as in the original `e()` code at line 127 of SelectAndSingleInputDialog$Companion.smali). When we passed a View instead, some intermediate step in Q() produced null and passed it to j3, which checks `checkNotNullParameter(it, "it")` → NPE. Fix: don't call the callback at all. The value is saved by SPUtils regardless; the row label refreshes on next page navigation.

---

## Entry 039 — Fix invoke-direct/range for CpuMultiSelectHelper$2 6-arg constructor (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `48aac66`  |  **Tag:** v2.4.2-beta3  |  **CI:** pending

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali` [MOD]

### Methods added / changed
**`CpuMultiSelectHelper.show(View, String, int, Function1)V`** — Rewrote `$2` construction to use `invoke-direct/range {v6..v11}`. Dalvik non-range `invoke-direct` supports max 5 registers; `$2.<init>` takes 6 args (this + [Z + SPUtils + String + Function1 + View). Fix: move all args into contiguous block v7..v11 via `move-object`, place new-instance target at v6, call `invoke-direct/range {v6 .. v11}`. `$3` needs only 5 regs — kept as regular `invoke-direct {v7, v8, v9, v10, v11}`.

### Root cause / rationale
v2.4.2-beta2 CI failed: `CpuMultiSelectHelper.smali[183,19] A list of registers can only have a maximum of 5 registers. Use the <op>/range alternate opcode instead.` The original `invoke-direct {v6, v2, v3, v4, p3, p0}` had 6 regs. Register layout rewritten to move all $2 args into contiguous v7-v11 before the range call.

### CI result
✅ build-quick.yml run 23203222010 — 3m33s

---

## Entry 038 — Fix NPE crash + dialog height limit (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `249c1c1`  |  **Tag:** v2.4.2-beta2  |  **CI:** ❌ (smali register error)

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali` [MOD]
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali` [MOD]
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$3.smali` [MOD]
- `patches/smali_classes2/com/xj/winemu/settings/SelectAndSingleInputDialog$Companion.smali` [MOD]

### Methods added / changed
**`CpuMultiSelectHelper.show()`** — Signature changed from `(Context, ...)` to `(View, ...)`. Anchor View `p1` from `SelectAndSingleInputDialog$Companion.d()` passed directly into `$2` (field `e`) and `$3` (field `d`). After `builder.show()`, gets `AlertDialog.getWindow()`, null-checks, then calls `Window.setLayout(WRAP_CONTENT=-2, heightPixels * 7 / 10)` using `mul-int/lit16` / `div-int/lit16`. Also added `if-eqz` null guards before `callback.invoke()`.

**`SelectAndSingleInputDialog$Companion.d()`** — Changed intercept: passes `p1` (View) directly to `CpuMultiSelectHelper.show()`; removed the `getContext()` call that was in beta1.

### Root cause / rationale
1. **NPE crash**: `j3.invoke()` in `smali_classes11` does `check-cast p1, android.view.View` — the callback expects a non-null View anchor, not null. Our beta1 code passed `null`; fix passes the anchor View from the intercepted `d()` method.
2. **Dialog too tall**: Added `Window.setLayout(WRAP_CONTENT, heightPixels * 70%)` so dialog fits between notification bar and navigation buttons.
CI failed: `invoke-direct` 6-register limit hit (fixed in entry 039).

---

## Entry 037 — Multi-select CPU core dialog (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `fe2e2a1`  |  **Tag:** v2.4.2-beta1  |  **CI:** ✅ build-quick.yml run 23201415726 — 3m50s

### Files created / moved / deleted
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper.smali` [NEW] — static `show()`: reads current mask, builds CharSequence[8] labels + boolean[8] checked, creates $1/$2/$3 listeners, shows `AlertDialog.setMultiChoiceItems()`
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$1.smali` [NEW] — `OnMultiChoiceClickListener`: updates `checked[which] = isChecked`
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$2.smali` [NEW] — PositiveButton "Apply": loops checked[], computes OR bitmask, calls `SPUtils.m(key, mask)`, fires callback
- `patches/smali_classes16/com/xj/winemu/settings/CpuMultiSelectHelper$3.smali` [NEW] — NegativeButton "No Limit": saves 0 to SPUtils, fires callback
- `patches/smali_classes2/com/xj/winemu/settings/SelectAndSingleInputDialog$Companion.smali` [NEW PATCH] — intercepts `d()` for `CONTENT_TYPE_CORE_LIMIT`: calls `CpuMultiSelectHelper.show()` and returns early; all other types fall through to original logic
- `patches/smali_classes4/com/xj/winemu/settings/PcGameSettingOperations.smali` [MOD] — `D(I)`: replaced `cond_bh_dfb` "No Limit" fallback with dynamic StringBuilder label (e.g. "Core 4 + Core 7 (Prime)" for mask=0x90)

### Methods added / changed
- **`CpuMultiSelectHelper.show(Context, String, int, Function1)V`** — `.locals 12`. Gets helper singleton → ops → SPUtils → key via `PcGameSettingDataHelper.A()` → current mask via `PcGameSettingOperations.C()`. Builds `CharSequence[8]` labels and `boolean[8]` checked array with `and-int/2addr` per-bit checks. Instantiates $1/$2/$3. Creates `AlertDialog.Builder` with `setMultiChoiceItems`, "Apply", "No Limit", "Cancel" buttons.
- **`SelectAndSingleInputDialog$Companion.d()V`** — Added 10-line intercept block before original `b()` call: `getCONTENT_TYPE_CORE_LIMIT()`, `if-ne p3, v0 → :cond_bh_not_cpu`, `View.getContext()`, `CpuMultiSelectHelper.show()`, `return-void`. Non-CPU types continue unchanged.
- **`PcGameSettingOperations.D(I)Ljava/lang/String;`** — `cond_bh_dfb` fallback replaced with `StringBuilder` loop checking 8 bits of mask, appending " + " separators and core names. Returns dynamic label for any custom combination.

### Root-cause / rationale
`SelectAndSingleInputDialog` is single-select only (radio buttons via `OptionsPopup`). To support arbitrary core combinations, we intercept before the popup is created and replace with `AlertDialog.setMultiChoiceItems()` which natively supports checkboxes. The shared `boolean[]` array is passed to both the `OnMultiChoiceClickListener` ($1) and the "Apply" button ($2), ensuring checkbox state is captured correctly.

---

## Entry 036 — CPU core selector: bitmask-based specific core selection (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `eb55f63`  |  **Tag:** v2.4.1-beta1  |  **CI:** pending

### Files created / moved / deleted
- `patches/smali_classes6/com/winemu/core/controller/EnvironmentController.smali` [NEW] — full copy with patched `d()` method
- `patches/smali_classes4/com/xj/winemu/settings/PcGameSettingOperations.smali` [MOD] — `A()` and `D(I)` replaced

### Methods added / changed
**`EnvironmentController.d()`** — removed the `(1 << count) - 1` bit-shift formula and the CpuInfoCollector guard (which rejected valid bitmasks ≥ deviceCoreCount). Now: single `Config.w()` call → `if-lez v0, :cond_1` (0 = no limit / skip) → set `WINEMU_CPU_AFFINITY = v0` directly. `libvfs.so` reads this env var and calls `sched_setaffinity()` with the bitmask.

**`PcGameSettingOperations.A()`** — replaced the dynamic loop ("1 core, 2 cores…") with a fixed 11-entry list: No Limit (0), Cores 4–7 Performance (0xF0=240), Cores 0–3 Efficiency (0x0F=15), Core 0 (1), Core 1 (2), Core 2 (4), Core 3 (8), Core 4 (16), Core 5 (32), Core 6 (64), Core 7/Prime (128). All constant constructor fields pre-initialized once. isSelected uses `if-ne v0, v8` (both int registers) to compare stored bitmask against each entry's id.

**`PcGameSettingOperations.D(I)`** — replaced "N cores" format string with bitmask-to-label if-eq chain matching same 11 values. Falls back to "No Limit" for unrecognized stored values.

### Root cause / rationale
Original formula `(1 << count) - 1` always mapped to the lowest N consecutive cores (e.g. "4 cores" = cores 0–3). Research confirmed the full pipeline: stored count → EnvironmentController formula → WINEMU_CPU_AFFINITY env var → libvfs.so → sched_setaffinity(). By patching the formula to use raw bitmask, each option id IS the affinity mask: bitmask 0xF0 pins to cores 4–7, 0x80 pins to core 7 (Prime), etc. This allows targeting specific SoC clusters (big/efficiency/prime cores).

### CI result
Pending — v2.4.1-beta1 tag triggers build-quick.yml (Normal APK only)

---

## Entry 035 — Fix VRAM display string and isSelected checkmark for 6/8/12/16 GB (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `86207ca`  |  **Tag:** v2.3.10-pre  |  **CI:** pending

### Files created / moved / deleted
- `patches/smali_classes4/com/xj/winemu/settings/PcGameSettingOperations.smali` [MOD]

### Methods added / changed
**`PcGameSettingOperations.F0()`** — added `if-eq` branches for `0x1800` (6 GB), `0x2000` (8 GB), `0x3000` (12 GB), `0x4000` (16 GB) before the fallthrough to the "Unlimited" string. Without these, any stored value > 4096 was unrecognized and F0() returned the "No Limit" string, making it appear selection reverted to Unlimited.

**`PcGameSettingOperations.l0()`** — replaced hardcoded `move/from16 v33, v2` (always false) for all 4 new VRAM entries with proper isSelected logic. Calls `G0()` once before the new entries (stores result in `v3` as int), then for each entry: loads the MB constant into `v4` (int), does `if-ne v3, v4` and sets v33 to v29 (1=selected) or v2 (0=not selected). Labels: `:cond_bh6ns`/`:goto_bh6` through `:cond_bh16ns`/`:goto_bh16`.

### Root cause / rationale
After selecting 6/8/12/16 GB: the value was actually saved to MMKV correctly via `E()` → `entity.getId()` → `SPUtils.m("pc_ls_max_memory", value)`. The bugs were purely display:
1. `F0()` (summary label builder) had no cases for values > 4096 → showed "Unlimited"
2. `l0()` (dropdown list builder) always set `isSelected=false` for new entries → no checkmark shown

Both bugs made it appear the selection wasn't saving when in fact it was.

### CI result
Pending — v2.3.10-pre tag triggers build-quick.yml (Normal APK only)

---

## Entry 034 — Fix VerifyError from invalid if-ne in VRAM l0() (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `c83dcb0`  |  **Tag:** v2.3.9-pre  |  **CI:** pending

### Files created / moved / deleted
- `patches/smali_classes4/com/xj/winemu/settings/PcGameSettingOperations.smali` [MOD]

### Methods added / changed
**`PcGameSettingOperations.l0()`** — removed 4 invalid selected-state checks (`:cond_6`-`:cond_9`, `:goto_6`-`:goto_9`, `if-ne` blocks) from the 4 new VRAM entries added in Entry 033. Replaced with direct `move/from16 v33, v2` (always not-selected). No other changes.

### Root cause / rationale
Logcat (logcat_2026-03-17_08-50-54.txt): `VerifyError` at bytecode offset `0x191` in `l0()` — `args to if-eq/if-ne (Reference: DialogSettingListItemEntity, PositiveShortConstant) must both be references or integral`. After the 4 GB entry's `move-object/from16 v0, v30`, v0 holds a reference type. Comparing it with a short integer constant via `if-ne` is illegal. Both PC game settings open and uninstall were broken because PcGameSettingOperations class was rejected entirely by ART.

### CI result
Pending — v2.3.9-pre tag triggers build-quick.yml

---

## Entry 033 — Unlock higher VRAM limits in PC game settings (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `cb56d1b`  |  **Tag:** v2.3.8-pre  |  **CI:** pending

### Files created / moved / deleted
- `patches/smali_classes4/com/xj/winemu/settings/PcGameSettingOperations.smali` [NEW] — full copy of apktool_out version with VRAM entries appended

### Methods added / changed
**`PcGameSettingOperations.l0()`** — method that builds the VRAM limit dropdown options list. Added 4 new `DialogSettingListItemEntity` entries at the end of the method (before `return-object v1`), each following the exact constructor pattern of existing entries (`const v54, 0x3ffff2` mask, all secondary fields = 0):
- 6 GB: `v31=0x1800`, `v34="6 GB"`, labels `:cond_6`/`:goto_6`
- 8 GB: `v31=0x2000`, `v34="8 GB"`, labels `:cond_7`/`:goto_7`
- 12 GB: `v31=0x3000`, `v34="12 GB"`, labels `:cond_8`/`:goto_8`
- 16 GB: `v31=0x4000`, `v34="16 GB"`, labels `:cond_9`/`:goto_9`

### Root cause / rationale
VRAM options were hardcoded in `l0()` with a maximum of 4 GB (0x1000). High-end devices (12-16 GB RAM) need higher VRAM allocation for memory-intensive Windows games. The selected-state check for new entries is non-functional (v0 was clobbered by the final 4 GB entry's `move-object/from16 v0, v30`) but this only affects the checkmark display, not actual selection/storage of the value.

### CI result
Pending — v2.3.8-pre tag triggers build-quick.yml (Normal APK only)

---

## Entry 032 — Offline fix: catch NoCacheException in GameSettingViewModel.fetchList (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `36e0180`  |  **Tag:** v2.3.7-pre  |  **CI:** pending

### Files created / moved / deleted
- `patches/smali_classes3/com/xj/winemu/settings/GameSettingViewModel$fetchList$1.smali` [MOD]

### Methods added / changed
**`GameSettingViewModel$fetchList$1.invokeSuspend`** — modified two coroutine resume points:
- `:pswitch_8` (packed-switch label=1, getContainerList resume): wrapped `invoke-static/range {p1..p1}, Lkotlin/ResultKt;->b(Ljava/lang/Object;)V` in `:try_start_ps8` / `:try_end_ps8` / `.catch Ljava/lang/Exception; ... :catch_ps8`. Catch handler: `move-exception v8` + `new-instance v4, ArrayList; invoke-direct {v4}, ...<init>()V` + `goto :goto_0`. Fallback: empty ArrayList.
- `:pswitch_6` (packed-switch label=3, getComponentList resume): same pattern with `:try_start_ps6` / `:try_end_ps6` / `:catch_ps6`. Catch handler: `move-exception v8` + `const-string v4, "{}"` + `goto/16 :goto_8`. Fallback: empty JSON object string.

### Root cause / rationale
Logcat analysis (logcat_2026-03-17_07-33-27.txt): When offline, `landscape-api.vgabc.com` DNS resolution fails. Both `getContainerList` and `getComponentList` throw `NoCacheException` from `OfflineCacheInterceptor` (no prior cached response). The exception escaped `invokeSuspend` via `ResultKt.throwOnFailure()` (uncaught), propagated to the ViewModel's coroutine error handler, which showed a blocking error UI rendering all PC game settings menus non-interactive. Note: packed-switch table is REVERSED — label N maps to `:pswitch_{9-N}`, so label=1 → pswitch_8 and label=3 → pswitch_6.

### CI result
✅ Passed — `build-quick.yml` — run `23192702967` — Normal APK built. App tested and confirmed working offline.

---

## Entry 031 — classes12 dex bypass + patches/ restore (2026-03-17 session)
**Date:** 2026-03-17  |  **Commits:** `9b4f0f5` `5875eb8` `f66a6a4` `b42c452` `3ca4a9c`  |  **Tag:** none  |  **CI:** `23190604565` ✅ (build.yml, 8 APKs)

### Files created / moved / deleted
- `.github/workflows/build-quick.yml` [MOD] — classes12 bypass + pin ubuntu-22.04
- `.github/workflows/build.yml` [MOD] — classes12 bypass
- `.github/workflows/build-crossfire.yml` [MOD] — classes12 bypass
- `patches/smali_classes4/GameSettingViewModel$fetchList$1.smali` [DEL] — dup from bad revert
- `patches/smali_classes7/HomeLeftMenuDialog.smali` [DEL] — dup from bad revert
- `patches/smali_classes11/.../SteamGameByPcEmuLaunchStrategy$execute$3.smali` [DEL] — dup
- `patches/smali_classes12/InputControlsManager.smali` [DEL] — dup from bad revert
- `patches/smali_classes14/X11Controller.smali` [DEL] — dup from bad revert

### Root cause / rationale
GitHub Actions environment changed overnight (2026-03-16 → 2026-03-17) causing smali to be stricter about dex index limits. `classes12` in the original base APK is at 65535+11 references — previously assembled fine, now fails. Fix: extract original `classes12.dex` from base APK zip, delete `smali_classes12/` from decompiled output so apktool skips it, inject original dex back after rebuild via `zip`. Applied to all 3 workflows.

Also discovered patches/ had 5 duplicate smali files in wrong dex locations — remnant of bad revert of `bbf4d43` (new base APK experiment). Removed all duplicates; patches/ now matches v2.3.5 exactly.

Additionally saved `apktool_out_base` artifact from v2.3.5 CI run as permanent release `apktool-out-base-v2.3.5` (219MB) before it expired.

### CI result
✅ Passed — `build.yml` (manual dispatch) — run `23190604565` — 8 APKs built. App tested and confirmed working.

---

# Appendix C — Known constraints

| Constraint | Detail |
|------------|--------|
| smali_classes11 full | At/near 65535 dex index limit — all new classes go to smali_classes16 |
| smali_classes12 bypassed | Over dex index limit (65546) — original classes12.dex injected directly, smali reassembly skipped in all 3 workflows |
| No external dex inject | GameHub class loader finds its own copies first; injected dex loses |
| TarArchiveInputStream obfuscated | `getNextTarEntry()` = `s()`, `isDirectory()` missing → use `getName().endsWith("/")` |
| XZInputStream constructor | `<init>(InputStream, int)V` only; second arg = -1 for unlimited |
| invoke-virtual max 5 regs | ContentResolver.query() needs `invoke-virtual/range` |
| const/4 max v15 | v16+ destinations need `const/16` or `sget-object` |
| EnvLayerEntity 18-param ctor | Needs `invoke-direct/range {v0..v19}` — 20 consecutive regs |
| firebase raws rule | Never include `firebase_common_keep`/`firebase_crashlytics_keep` in public.xml |
| .locals max for inner classes | `.locals 15` maximum when p0 is used in 4-bit-range instructions (p0=v15); `.locals 16` makes p0=v16, out of range |
| Toast requires main thread | `ComponentInjectorHelper.injectComponent()` calls Toast internally — must be called on UI thread via `runOnUiThread()` |

---

# Appendix D — Injection Point Diffs (Reproduction Guide)

This appendix documents every location in **original GameHub smali** that must be modified to reproduce the Component Manager + Component Downloader patches. All new class files go in `smali_classes16/` — only the diffs below touch original GameHub files.

---

## D.1 — Side menu "Components" entry

**File:** `smali_classes5/com/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog.smali`

This file has two injection sites: the menu item builder method and the click handler.

### Site 1 — Menu item builder (adds "Components" as the last item before `return-void`)

Find the method that builds the side menu item list. It ends with a `return-void` preceded by `invoke-interface {p0, v4}, java/util/List;->add`. Append the following block **before** the `return-void`:

```smali
    # INJECTION: add "Components" menu item (ID=9)
    new-instance v4, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;
    sget v6, Lcom/xj/landscape/launcher/R$drawable;->menu_setting_normal:I
    const-string v7, "Components"
    const/16 v10, 0x18
    const/4 v11, 0x0
    const/16 v5, 0x9
    const/4 v8, 0x0
    const/4 v9, 0x0
    invoke-direct/range {v4 .. v11}, Lcom/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog$MenuItem;-><init>(IILjava/lang/String;Ljava/lang/String;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V
    invoke-interface {p0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    # END INJECTION
```

The `MenuItem` constructor signature is `<init>(I I Ljava/lang/String; Ljava/lang/String; Z I Lkotlin/jvm/internal/DefaultConstructorMarker;)V`. Parameters: `id=9`, `iconRes=menu_setting_normal`, `name="Components"`, `rightContent=""` (v8=null), `mask=0x18`, `DefaultConstructorMarker=null`.

### Site 2 — Click handler packed-switch (adds `:pswitch_9` case + extends switch table)

Find the `invoke` method that handles menu item clicks via packed-switch. Add the new handler block and extend the switch table:

**Before** (switch table ends at position 8, i.e. 9 entries `pswitch_8` through `pswitch_0`):
```smali
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
```

**After** (add `:pswitch_9` as 10th entry):
```smali
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_9
    .end packed-switch
```

Add the handler block **before** the switch table (anywhere before `:pswitch_data_0`):
```smali
    # INJECTION: Components menu item handler
    :pswitch_9
    new-instance p0, Landroid/content/Intent;
    const-class p1, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
    invoke-direct {p0, p2, p1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p2, p0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    goto :goto_1
    # END INJECTION
```

Where `p2` is the `Context` parameter of the lambda (the activity context passed into the click handler).

---

## D.2 — Append local components to GameHub's component lists

**File:** `smali_classes3/com/xj/winemu/settings/GameSettingViewModel$fetchList$1.smali`

This is the coroutine continuation that receives the remote component list from the server and calls back into the UI. We append locally injected components to the list before the callback fires.

**Before** (lines ~2942-2954, original):
```smali
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;
    invoke-virtual {v0, v7}, Lcom/xj/common/data/model/CommResultEntity;->setData(Ljava/lang/Object;)V

    # (callback invoked immediately after)
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$callback:Lkotlin/jvm/functions/Function1;
    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;
    invoke-interface {v0, v1}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;
```

**After** (insert 2 lines between `setData` and the callback):
```smali
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;
    invoke-virtual {v0, v7}, Lcom/xj/common/data/model/CommResultEntity;->setData(Ljava/lang/Object;)V

    # INJECTION: append locally installed components to list before callback
    iget v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I
    invoke-static {v7, v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->appendLocalComponents(Ljava/util/List;I)V
    # END INJECTION

    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$callback:Lkotlin/jvm/functions/Function1;
    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;
    invoke-interface {v0, v1}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;
```

`v7` is the `List<DialogSettingListItemEntity>` populated by the server response. `$contentType` is the component type int (DXVK=12, VKD3D=13, Box64=94, FEXCore=95, GPU=10). This injection must occur at **every** `setData(v7)` site in this file that is followed by a `$callback` invocation — there may be multiple branches (success path and each error/empty path); check all of them.

---

## D.3 — ComponentDownloadActivity launch from ComponentManagerActivity

**File:** `smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali` (our own file — not original GameHub)

In `onItemClick()`, the mode=2 (type-selection) handler: position 0 is "↓ Download from Online Repos". When `p3 == 0`, start `ComponentDownloadActivity`:

```smali
    # mode=2 type selection
    :not1
    const/4 v1, 0x2
    if-ne v0, v1, :default_back
    # position 0 = Download from Online Repos
    if-nez p3, :not_download
    const-class v0, Lcom/xj/landscape/launcher/ui/menu/ComponentDownloadActivity;
    new-instance v1, Landroid/content/Intent;
    invoke-direct {v1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    return-void
    :not_download
    add-int/lit8 v1, p3, -0x1      # shift index down by 1 (skip slot 0) for sw2
    packed-switch v1, :sw2_data
    invoke-virtual {p0}, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;->showComponents()V
    return-void
```

In `showTypeSelection()`, "↓ Download from Online Repos" is at index 0 of the array, before DXVK/VKD3D/Box64/FEXCore/GPU Driver/Back. The `sw2_data` packed-switch handles positions 1–5 (subtract 1 first) for the five inject-type handlers.

---

## D.4 — New files required (smali_classes16)

All of the following must be created from scratch in `smali_classes16/com/xj/landscape/launcher/ui/menu/`. They contain no original GameHub code — copy directly from the repo's `patches/smali_classes16/` directory:

| File | Purpose |
|------|---------|
| `ComponentManagerActivity.smali` | Main component manager ListView activity (3 modes) |
| `ComponentManagerActivity$1.smali` | Background inject Runnable (WCP/ZIP extraction off main thread) |
| `ComponentManagerActivity$2.smali` | UI result Runnable (toast + list refresh) |
| `ComponentInjectorHelper.smali` | Static helper: getFirstByte, getDisplayName, stripExt, makeComponentDir, openTar, readWcpProfile, extractWcp, extractZip, registerComponent, injectComponent, appendLocalComponents |
| `WcpExtractor.smali` | WCP/ZIP extraction helper used by ComponentManagerActivity$1 (background injection from local file picker) |
| `ComponentDownloadActivity.smali` | 3-mode download activity (repo→category→asset) |
| `ComponentDownloadActivity$1.smali` | GitHub Releases API fetch Runnable |
| `ComponentDownloadActivity$2.smali` | ShowCategories UI Runnable |
| `ComponentDownloadActivity$3.smali` | Download Runnable (stream to cacheDir) |
| `ComponentDownloadActivity$4.smali` | Complete Runnable (Toast + finish) |
| `ComponentDownloadActivity$5.smali` | Inject Runnable (UI thread, Looper fix) |
| `ComponentDownloadActivity$6.smali` | PackJsonFetchRunnable (flat JSON array: type/verName/remoteUrl) |
| `ComponentDownloadActivity$7.smali` | KimchiDriversRunnable (JSONObject root → releases[]) |
| `ComponentDownloadActivity$8.smali` | SingleReleaseRunnable (GitHub releases/tags API) |
| `ComponentDownloadActivity$9.smali` | GpuDriversFetchRunnable (flat JSON array, Wine/Proton skip) |

---

## D.5 — AndroidManifest.xml additions

Add `ComponentManagerActivity` and `ComponentDownloadActivity` to the manifest so Android registers them:

```xml
<activity android:name="com.xj.landscape.launcher.ui.menu.ComponentManagerActivity"
    android:exported="false" />
<activity android:name="com.xj.landscape.launcher.ui.menu.ComponentDownloadActivity"
    android:exported="false" />
```

Insert inside the existing `<application>` block alongside the other activity declarations.

---

## D.6 — Resource additions

### `res/values/ids.xml` — add the ListView ID used by ComponentManagerActivity:
```xml
<item name="component_list_view" type="id" />
```

### `res/values/public.xml` — add the corresponding public ID entry. Use a free ID in the `0x7f09xxxx` range that does not conflict with existing entries. Check the highest existing `0x7f09` entry and increment. **Do not include** `firebase_common_keep` or `firebase_crashlytics_keep` — these break aapt2.

### No layout XML files needed — ComponentManagerActivity and ComponentDownloadActivity build their UI entirely in code (programmatic LinearLayout + ListView).

---

## D.7 — Build process

```bash
# 1. Decompile base APK
apktool d GameHub-5.3.5-ReVanced.apk -o apktool_out --no-src

# 2. Apply all patches from patches/ directory
cp -r patches/smali_classes16 apktool_out/
cp patches/AndroidManifest.xml apktool_out/
# merge res/ additions into apktool_out/res/

# 3. Rebuild
apktool b apktool_out -o unsigned.apk

# 4. Sign (v1/v2/v3)
apksigner sign --key testkey.pk8 --cert testkey.x509.pem \
    --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true \
    --out signed.apk unsigned.apk
```
## Entry 049 — CPU core dialog: revert to beta8c style (setMultiChoiceItems) (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `991d0ef`  |  **Tag:** v2.4.2-beta12  |  **CI:** ✅

Restored Html.fromHtml `<small>` labels, $1 OnMultiChoiceClickListener, setMultiChoiceItems, half-width, 90% height. $4 class left as unused dead code.

---

## Entry 048 — CPU core dialog: no divider, centered title, right-aligned right col, buttons L/C/R (2026-03-17)
**Date:** 2026-03-17  |  **Commit:** `6150954`  |  **Tag:** v2.4.2-beta11  |  **CI:** ✅

---

## Entry 049 — Sustained Performance Mode toggle (ComponentManagerActivity + WineActivity) (2026-03-18)
**Date:** 2026-03-18  |  **Commit:** TBD  |  **Tag:** v2.4.4-pre  |  **CI:** pending

### Files modified
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`
- `patches/smali_classes15/com/xj/winemu/WineActivity.smali`

### What changed
- `ComponentManagerActivity.showComponents()`: added `⚡ Sustained Perf: ON/OFF` as index-0 item in the component list; all existing items shifted by 1. Reads `bh_prefs` SharedPreferences key `sustained_perf` to display current state.
- `ComponentManagerActivity.onItemClick()` mode=0: position 0 toggles `sustained_perf` boolean in `bh_prefs`, shows Toast ("Sustained Performance: ON/OFF"), refreshes list; position 1 now maps to Add New Component (was 0); position 2+ maps to existing component (selectedIndex = position−2).
- `WineActivity.onCreate()`: injected after `:cond_perf_1` (existing perf block); checks SDK_INT ≥ 24, reads `bh_prefs/sustained_perf` boolean, calls `getWindow().setSustainedPerformanceMode(true)` if enabled.

### Root cause / rationale
`Window.setSustainedPerformanceMode(true)` prevents thermal throttling from dropping GPU/CPU clocks mid-session. Non-root approach — no sysfs writes. OEM decides the actual clock floor but sustained mode ensures clocks don't drop below the "gaming" tier during prolonged load.

### CI result
Pending

---

### Entry 051 — Remove All + Duplicate Prevention (2026-03-18)

**Files changed:**
- `patches/smali_classes16/.../ComponentManagerActivity.smali` — 2 new fields (pendingUri, pendingType); showComponents() list grows by 1 ("✕ Remove All" at bottom when components exist); onItemClick mode=0 checks if tapped index == components.length → confirmRemoveAll(); onActivityResult mode=3 now calls checkDuplicate() instead of injectComponent() directly; added methods: checkDuplicate, confirmRemoveAll, removeAllComponents
- `patches/smali_classes16/.../ComponentInjectorHelper.smali` — new getComponentName(Context, Uri, int) static method (mirrors name-resolution logic of injectComponent without extracting)
- `patches/smali_classes16/.../ComponentManagerActivity$3.smali` [NEW] — DialogInterface.OnClickListener for Remove All confirm → calls removeAllComponents()
- `patches/smali_classes16/.../ComponentManagerActivity$4.smali` [NEW] — DialogInterface.OnClickListener for Replace dup confirm → reads pendingUri/pendingType, calls injectComponent() + showComponents()

**Root cause / design:**
- Remove All: iterates components[], unregisters each from EmuComponents.a HashMap, calls deleteDir(), shows "All components removed" toast
- Dup prevention: getComponentName() peeks at first byte to detect ZIP vs WCP, reads name from meta.json driverVersion (ZIP) or profile.json versionName (WCP), falls back to display name minus extension; if filesDir/usr/home/components/<name>/ exists → AlertDialog "Already Installed — Replace / Cancel"

**CI:** pending

---

### Entry 052 — Remove All: skip app-API components via .bh_injected marker (2026-03-18)

**Files changed:**
- `ComponentInjectorHelper.smali` — At `:show_success` in `injectComponent()`, writes a zero-byte `.bh_injected` marker file into the component dir (best-effort inner try/catch, failure silently ignored). v6 holds the dir at that point in both ZIP and WCP paths.
- `ComponentManagerActivity.smali` — `removeAllComponents()` now checks for `.bh_injected` in each dir before removing it; dirs without the marker (app-API-installed components) are skipped. Bumped .locals 7→8. Toast changed to "BannerHub components removed".

**Root cause / design:**
- App-installed components and BannerHub-injected components share the same `components/` folder. Need to distinguish them. Marker file approach: stamp every BannerHub-injected dir at injection time; Remove All only deletes stamped dirs.

**CI:** pending

---

## Entry 051 — Fix: perf re-apply crash guard + grey out toggles without root (2026-03-18)
**Date:** 2026-03-18  |  **Commit:** `d0a6fcb`  |  **Tag:** v2.5.1-pre  |  **CI:** pending

### Files modified
- `patches/smali_classes15/com/xj/winemu/WineActivity.smali`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`

### Methods added / changed
- **WineActivity** (unnamed on-resume method) [MOD] — added `:try_start_bh_perf` before the Sustained Perf re-apply block and `:try_end_bh_perf` + `.catch Ljava/lang/Exception;` + `:catch_bh_perf` label after `:cond_bh_adreno_skip`. Both re-apply blocks are now inside a single try/catch. Exception swallowed silently.
- **BhPerfSetupDelegate.isRootAvailable()Z** [NEW static] — runs `{"su", "-c", "id"}` via Runtime.exec, calls waitFor(), returns true if exit == 0. Returns false on any Exception.
- **BhPerfSetupDelegate.onAttachedToWindow()V** [MOD] — `.locals 5→6`; added `isRootAvailable()` check into v5; for each switch: if no root → `setAlpha(0x3f000000 / 0.5f)` + no click listener; if root → unchanged behaviour. Fixed float literal from `const/high16 v3, 0x3f00` (assembler error: low 16 bits not zeroed) to `const v3, 0x3f000000`.

### Root cause / design
- `setSustainedPerformanceMode()` is not supported on all OEMs — throws instead of silently failing on some devices; without a guard, enabling the pref + relaunching container crashed on launch.
- `const/high16` smali instruction requires low 16 bits to be zero in the immediate; 0x3f00 only has 14 significant bits, which assembled to an invalid literal. `const v, 0x3f000000` is the correct form for 0.5f.
- Root check in BhPerfSetupDelegate prevents non-root users from accidentally toggling features that do nothing (or prompt for root) on their device.

---

## Entry 051 — v2.5.1 STABLE: CI confirmed (2026-03-18)
**Date:** 2026-03-18  |  **Commit:** `d0a6fcb`  |  **Tag:** v2.5.1  |  **CI:** ✅ build.yml run 23276212704 — 8 APKs (6m 17s)

---

## Entry 053 — v2.5.3-pre: fix Grant Root Access missing from build-quick.yml (2026-03-20)
**Date:** 2026-03-20  |  **Commit:** `c7ecc4d`  |  **Tag:** v2.5.3-pre  |  **CI:** ✅ run 23339561713

### What was changed
Pre-releases use `build-quick.yml`, but the 3 Grant Root Access Python smali patches (SettingBtnHolder.w, SettingItemEntity.getContentName, SettingItemViewModel.k) were only in `build.yml`. Result: button was never inserted in the settings list, getContentName returned "" for contentType=0x64.

### Root cause
`build.yml` — used for stable tags — had the Python patch step. `build-quick.yml` — used for `-pre` and `-beta` tags — did not.

### Fix
Added identical Python patch step to `build-quick.yml` before the "Patch package name" step, with paths targeting `apktool_out/` (quick workflow uses single-job layout, no `apktool_out_base/` intermediate).

### Files modified
- `.github/workflows/build-quick.yml` — +103 lines (Python patch step for all 3 Grant Root Access smali patches)

### CI result
✅ Passed — run 23339561713, 3m38s

---

## Entry 052 — v2.5.2-pre: Grant Root Access button (port from bh-lite) (2026-03-20)
**Date:** 2026-03-20  |  **Commit:** `493f9ae`  |  **Tag:** v2.5.2-pre  |  **CI:** ✅ run 23338789938

### What was changed
Port of the "Grant Root Access" dialog from BannerHub Lite to original BannerHub (5.3.5).

Previously, `BhPerfSetupDelegate.isRootAvailable()` ran `su -c id` synchronously on every Performance sidebar open. Now root status is stored in `bh_prefs["root_granted"]` via an explicit user-initiated dialog in Settings → Advanced.

### Files added (patches/smali_classes16/com/xj/winemu/sidebar/)
- `BhRootGrantHelper.smali` — `requestRoot(Context)V`: shows dialog, branches on alreadyGranted; calls $1/$2 inner classes
- `BhRootGrantHelper$1.smali` — "Revoke Access" DialogInterface.OnClickListener: stores root_granted=false, shows Toast
- `BhRootGrantHelper$2.smali` — "Grant Access" DialogInterface.OnClickListener: starts Thread(BhRootGrantHelper$2$1)
- `BhRootGrantHelper$2$1.smali` — Thread Runnable: runs su -c id, stores result, posts Handler(BhRootGrantHelper$2$1$1)
- `BhRootGrantHelper$2$1$1.smali` — Handler.post Runnable: shows granted/denied Toast on main thread

### Files modified
- `BhPerfSetupDelegate.smali` — replaced `invoke-static isRootAvailable()Z` with `prefs.getBoolean("root_granted", false)` using v2 (SharedPreferences already in scope)
- `build.yml` — added "Apply Grant Root Access smali patches" step (Python string patches):
  - `SettingBtnHolder.w()` (smali_classes6): inject after `move-result p0` while p2=FocusableConstraintLayout, call BhRootGrantHelper.requestRoot(context), return Unit
  - `SettingItemEntity.getContentName()` (smali_classes13): inject before :cond_15, return "Grant Root Access" for 0x64
  - `SettingItemViewModel.k()` (smali_classes3): append TYPE_BTN(0x64) after Clear Cache before return

### Method: SettingItemEntity constructor signature (5.3.5)
`<init>(IILandroid/util/SparseArray;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V`
- v0=this, v1=type(TYPE_BTN), v2=contentType(0x64), v3=null, v4=false, v5=0xc, v6=null
- v1/v3/v4/v5/v6 reused from the Clear Cache item directly above (still valid at injection point)

### CI result
Pending — run 23338789938

## Entry 054 — v2.5.4-pre: VerifyError crash fix + perf toggles activate after root grant (2026-03-20)

### Files changed
- `patches/smali_classes16/com/xj/winemu/sidebar/BhRootGrantHelper$2$1$1.smali`
- `patches/smali_classes16/com/xj/winemu/sidebar/BhPerfSetupDelegate.smali`

### Methods changed
- `BhRootGrantHelper$2$1$1.<init>(Context, boolean)` — iput → iput-boolean for field b:Z
- `BhPerfSetupDelegate.onVisibilityChanged(View, int)` — new method added

### Root-cause analysis
**Bug 1 (crash):** ART's verifier rejected `BhRootGrantHelper$2$1$1` at class load time because
the constructor used `iput` (integer put) to write to field `b:Z` (boolean). ART requires
`iput-boolean` for Z-typed fields. This caused a VerifyError on the root grant worker thread,
crashing the app immediately after the grant dialog was confirmed.

**Bug 2 (perf not activating):** `BhPerfSetupDelegate.onAttachedToWindow()` runs exactly once
when the view is first added to the window. If root was not granted at that moment, the toggles
were greyed out and no click listeners were set. Granting root later updated `bh_prefs/root_granted`
but `onAttachedToWindow` never re-ran — UI stayed grey forever. Fix: added `onVisibilityChanged()`
which fires every time the Performance sidebar tab becomes visible. It re-reads `root_granted`,
restores alpha to 1.0f and wires listeners if granted, or greys out if not.

### CI result
✅ run 23342648406 — PASSED

---

## Entry 56 — v2.5.5-pre — Component description in game settings picker (2026-03-20)

### Files modified
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.smali`
  - Method: `appendLocalComponents(List, int)`
  - Added 3 instructions after `setDownloaded(true)`: `invoke-virtual {v4} getBlurb()`, `move-result-object v7`, `invoke-virtual {v6, v7} setDesc(String)`

### Methods involved
- `ComponentInjectorHelper.appendLocalComponents()` — the injection point
- `EnvLayerEntity.getBlurb()Ljava/lang/String;` — **not obfuscated** in 5.3.5 (confirmed at line 1511 of EnvLayerEntity.smali)
- `DialogSettingListItemEntity.setDesc(String)V` — confirmed present (smali_classes12)

### Root-cause analysis
`appendLocalComponents()` built each `DialogSettingListItemEntity` via the no-arg constructor then called setTitle/setDisplayName/setType/setEnvLayerEntity/setDownloaded — but never called `setDesc()`. The blurb string was already stored in the `EnvLayerEntity` (it is written there by `registerComponent()` via the 19-param constructor param 1). Only needed to read it back and forward it to setDesc.

### CI result
✅ run 23345802544 — PASSED (3m30s)

---

## Entry 57 — v2.5.6-pre — Download progress indicator in ComponentDownloadActivity (2026-03-20)

### Files modified
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentDownloadActivity.smali`
  - Field added: `mProgressBar:Landroid/widget/ProgressBar;`
  - `onCreate`: create ProgressBar, set GONE, add to layout between status text and ListView
  - `showRepos()`, `showCategories()`, `showAssets()`: set ProgressBar GONE at start
  - `onItemClick` mode=2 `:no_ext`: set ProgressBar VISIBLE; status text changed from "Downloading..." to "Downloading: <mDownloadFilename>"
  - All 6 `sw0_*` repo-fetch cases: set ProgressBar VISIBLE after setText, before startFetch*()

### Root-cause analysis
No visual feedback existed during repo metadata fetch or file download — the list was cleared and the status text changed but no spinner was shown. bh-lite shows an indeterminate ProgressBar during both phases. Added the same behaviour to BannerHub by storing a ProgressBar in a field and toggling visibility at the right transition points. No new layout files needed (all programmatic).

### CI result
✅ run 23346364788 — PASSED

---

## Entry 58 — v2.6.0 stable — Stable release (2026-03-20)

### Summary
Stable release of the v2.5.2-pre → v2.5.6-pre line. 8 APKs built successfully.

### What was included
- Entry 53: Grant Root Access button (Settings → Advanced)
- Entry 54: Fix build-quick.yml missing patches
- Entry 55: Fix VerifyError crash on root grant (iput → iput-boolean)
- Entry 56: Component description in game settings picker (getBlurb → setDesc)
- Entry 57: Download progress indicator in ComponentDownloadActivity

### CI result
✅ run 23347015897 — PASSED (8 APKs)

---

## Entry 59 — v2.6.1-pre — Fix perf toggles not persisting visual state (2026-03-20)

### Summary
Performance toggles (Sustained Perf, Max Adreno Clocks) appeared OFF when the Performance sidebar was reopened after being turned on.

### Root-cause analysis
`WineActivity.toggleSustainedPerf(Z)` and `toggleMaxAdreno(Z)` only saved the bh_prefs boolean when `WineActivity.t1` was non-null. `t1` is a static field set in `i2(Z)V` (the "game ready" callback) and cleared in `onDestroy`. When the user taps the toggle, `t1` may not yet be set — in that case the root su command still fires (toggle WORKS) but the pref is never written. On next `onVisibilityChanged(VISIBLE)`, `getBoolean("sustained_perf", false)` returns `false` and `setSwitch(false)` is called → toggles appear unchecked.

### Fix
Moved pref saving from `WineActivity` into the click listeners:
- `SustainedPerfSwitchClickListener.invoke()`: calls `v0.getContext().getSharedPreferences("bh_prefs", 0).edit().putBoolean("sustained_perf", v1).apply()` before `toggleSustainedPerf`
- `MaxAdrenoClickListener.invoke()`: same pattern, key `"max_adreno_clocks"`
Click listeners always have a `SidebarSwitchItemView` reference (`field a`) which always has a Context — no `t1` dependency.

`WineActivity.toggleSustainedPerf`: kept `setSustainedPerformanceMode` call (needs Window, still gated on t1), removed pref save.
`WineActivity.toggleMaxAdreno`: removed pref save entirely (max adreno is root-only, no window API needed).

### Files modified
- `patches/smali_classes16/com/xj/winemu/sidebar/SustainedPerfSwitchClickListener.smali`
  - `.locals 2` → `.locals 5` (need v2=context, v3=pref key, v4=mode)
  - Added: getContext → getSharedPreferences → edit → putBoolean("sustained_perf") → apply
- `patches/smali_classes16/com/xj/winemu/sidebar/MaxAdrenoClickListener.smali`
  - `.locals 3` → `.locals 5`
  - Added: getContext → getSharedPreferences → edit → putBoolean("max_adreno_clocks") → apply
- `patches/smali_classes15/com/xj/winemu/WineActivity.smali`
  - `toggleSustainedPerf`: removed 8-line pref-save block (getSharedPreferences + edit + putBoolean + apply)
  - `toggleMaxAdreno`: removed 10-line pref-save block + t1 null check

### CI result

 → ✅ run 23353066650 — PASSED

### Logcat verification
✅ `logcat-2026-03-20_12-58-55.txt` — no errors from v2.6.1-pre. Old VerifyError entries (08:16/08:43) are from pre-v2.6.0 APK installs, already fixed. Post-12:45 log is clean — only `qti.diagservices` system noise and DisplayRotation messages.

---

## Entry 61 — v2.6.2-pre — Component Manager UI redesign: RecyclerView cards + search + swipe (2026-03-20)

**Commit:** `56851cd` | **Tag:** v2.6.2-pre | **CI:** pending

### Summary
Complete overhaul of ComponentManagerActivity from a basic ListView to a modern card-based RecyclerView UI. 11 smali files added or rewritten. Swipe gestures, live search, type badges, empty state — all programmatic (no XML).

### Root cause / motivation
Old UI was a plain ListView with no search, no visual distinction between component types, no swipe-to-remove. User requested a modern redesign.

### Files created [NEW]
- `patches/smali_classes16/.../BhComponentAdapter.smali` — RecyclerView.Adapter: updateComponents(), filter(), getFiltered(), onItemTapped(), getTypeName(), getTypeColor(), onCreateViewHolder(), onBindViewHolder(), getItemCount()
- `patches/smali_classes16/.../BhComponentAdapter$ViewHolder.smali` — ViewHolder extends RecyclerView$ViewHolder, implements View$OnClickListener; onClick → adapter.onItemTapped()
- `patches/smali_classes16/.../BhSwipeCallback.smali` — extends ItemTouchHelper$SimpleCallback(0, 12); LEFT(4)→removeFiltered; RIGHT(8)→backupFiltered
- `patches/smali_classes16/.../ComponentManagerActivity$5.smali` — options dialog listener: which=0→inject, 1→backup, 2→remove
- `patches/smali_classes16/.../ComponentManagerActivity$6.smali` — type dialog listener: maps which 0-4 to type ints (DXVK/VKD3D/Box64/FEX/GPU)
- `patches/smali_classes16/.../ComponentManagerActivity$7.smali` — TextWatcher: afterTextChanged → onSearchChanged()
- `patches/smali_classes16/.../ComponentManagerActivity$BhBackListener.smali` — onClick → activity.finish()
- `patches/smali_classes16/.../ComponentManagerActivity$BhRemoveAllListener.smali` — onClick → activity.confirmRemoveAll()
- `patches/smali_classes16/.../ComponentManagerActivity$BhAddListener.smali` — onClick → activity.showTypeDialog()
- `patches/smali_classes16/.../ComponentManagerActivity$BhDownloadListener.smali` — onClick → startActivity(ComponentDownloadActivity)

### Files modified [MOD]
- `patches/smali_classes16/.../ComponentManagerActivity.smali` — complete rewrite; new fields: recyclerView, adapter, emptyState, countBadge; new methods: dp(I)I, buildUI(), buildHeader(), buildSearchBar(), buildContent(), buildEmptyState(), buildBottomBar(), makeBtn(String,int), showComponents(), updateEmptyState(), onSearchChanged(), showOptionsDialog(I), showTypeDialog(), removeFiltered(I), backupFiltered(I), getFileName(Uri); bug fixed: spurious makeBtn() call without args removed from buildBottomBar()

### CI result (v2.6.6-pre)
→ ✅ run 23365366484 — PASSED — Normal APK built (3m34s)

### Runtime VerifyError fixes (v2.6.6-pre)
After CI passed, user reported app crashed on Component Manager open. Logcat showed VerifyError:
1. private helper methods called via invoke-virtual → ART verifier rejects; fixed: changed buildUI/Header/SearchBar/Content/EmptyState/BottomBar/makeBtn from private to public
2. getFileName(Uri): v1 overwritten with String[] before Uri range call; fixed: move-object v1, p1 (Uri) before new-array v2 (projection)

### CI result (v2.6.5-pre smali fixes)
→ ✅ run 23365002056 — PASSED — Normal APK built (3m28s)

### Smali errors encountered and fixed
1. `BhComponentAdapter.smali`: `.locals 15` in `onCreateViewHolder` → p1=v16, p2=v17 out of range. Fixed: `.locals 13` + full register remap using stable refs v7-v11, temp v12, final move-object to v0..v6 for range call.
2. `BhComponentAdapter.smali`: `const/4 v14, 0x8` → literal 8 out of const/4 range. Fixed: `const/16`.
3. `ComponentManagerActivity.smali`: `{v2, v3, v0, 0x1}` in addView invoke — literal 0x1 in register list. Fixed: `const/4 v4, 0x1` then `v4`.
4. `ComponentManagerActivity.smali`: `const/4 v*, 0x8` (6 occurrences) → literal 8 out of range. Fixed: all to `const/16`.

---

## Entry 60 — v2.6.1 stable — Promote perf toggle fix to stable (2026-03-20)

**Commit:** `f334a2f` | **Tag:** v2.6.1 | **CI:** ✅ run 23361933312

### Summary
Stable promotion of v2.6.1-pre. No new code changes — tags HEAD (c8ebfdc) as v2.6.1.

### What changed since v2.6.0
- Fix: perf toggles (Sustained Perf, Max Adreno Clocks) persist visual ON/OFF state across sidebar open/close
- Root cause: pref save was inside WineActivity methods gated on t1 null-check; moved into click listeners where context is always available
- Credits section + Arihany/Nightlies repo links added to README

### Files touched
- `PROGRESS_LOG.md` — stable entry added
- `COMPONENT_MANAGER_BUILD_LOG.md` — this entry

### CI result
→ ✅ run 23361933312 — PASSED — 8 APKs built

---

## Entry 62 — v2.6.7-pre — Fix buildUI() VerifyError: .locals 5 p0=v5 register collision (2026-03-20)

**Commit:** `18268e5` | **Tag:** v2.6.7-pre | **CI:** ⏳ pending

### Root Cause
With `.locals 5`, Dalvik register layout is:
- v0–v4: 5 local registers
- v5: p0 (the `this` reference = ComponentManagerActivity)

Inside `buildUI()`, the line:
```
const/high16 v5, 0x3f800000  # 1.0f for LinearLayout$LayoutParams weight
```
wrote an IntegerConstant into v5, silently overwriting `this` (p0). ART's verifier then rejected the method at bytecode offset [0x32] with:
```
tried to get class from non-reference register v5 (type=IntegerConstant)
```

This was the THIRD VerifyError in v2.6.x — after (1) private method invoke-virtual and (2) getFileName Uri register collision.

### Fix
- `ComponentManagerActivity.smali` line 52: `.locals 5` → `.locals 6`
- With `.locals 6`: v0–v5 are locals, p0 maps to v6 (never overwritten)
- `const/high16 v5` now writes to a proper local register; p0 stays a valid reference throughout

### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

### Lesson
Always verify `.locals N` so that no `const*` instruction targets the register that p0 maps to (vN). This is a silent register alias — smali assemblers do not warn about it.

### CI result
→ ✅ run 23365752576 — PASSED — Normal APK built

---

## Entry 63 — v2.6.8-pre — Fix IllegalAccessError: private fields inaccessible to inner classes (2026-03-20)

**Commit:** `5258d1c` | **Tag:** v2.6.8-pre | **CI:** ✅ run 23366067758

### Root Cause
Inner classes `$4`, `$5`, `$6` use direct `iget`/`iput` bytecode to access ComponentManagerActivity fields:
- `$4`: reads `pendingUri` (iget-object) + `pendingType` (iget)
- `$5`: writes `mode` (iput)
- `$6`: writes `selectedType` (iput) + `mode` (iput)

ART enforces Java visibility at runtime. All 9 fields were declared `.field private`. When an inner class tries to access a private field of another class (even its outer class) via raw iget/iput, ART throws `IllegalAccessError`. In Java this is handled by synthetic `access$000()` methods — but our smali code did not generate those.

### Fix
Changed all 9 fields from `.field private` to `.field public`:
- recyclerView, adapter, emptyState, countBadge, components, selectedIndex, selectedType, pendingUri, pendingType, mode

### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

### Lesson
In smali, inner classes accessing outer-class fields must use `public` (or package-private) fields — or generate synthetic accessor methods. Private fields accessed cross-class via iget/iput will always throw IllegalAccessError at runtime.

### CI result
→ ✅ run 23366067758 — PASSED — Normal APK built

---

## Entry 64 — v2.7.0-pre — Black dark mode UI redesign (2026-03-20)

### Files changed
- `patches/smali_classes16/.../ComponentManagerActivity.smali`
- `patches/smali_classes16/.../ComponentDownloadActivity.smali`
- `patches/smali_classes16/.../ComponentDownloadActivity$DarkAdapter.smali`

### Methods / sections changed
- `ComponentManagerActivity.buildUI()` — removed search bar call; root bg → black
- `ComponentManagerActivity.buildHeader()` — header bg → dark grey; title → orange
- `ComponentManagerActivity.buildContent()` — RecyclerView bg → black
- `ComponentManagerActivity.buildBottomBar()` — bar bg → dark grey; blue/green buttons → orange, 48dp→32dp, weight→WRAP_CONTENT left-aligned
- `ComponentManagerActivity.makeBtn()` — added 16dp H / 8dp V padding
- `ComponentDownloadActivity.onCreate()` — root bg → black; header bg → dark grey; title → orange; status text → darker grey; ListView bg → black; added ListView.setSelector() with semi-transparent orange
- `ComponentDownloadActivity$DarkAdapter.getView()` — .locals 4→7; white→off-white text; solid bg → StateListDrawable (pressed=darker, selected=orange tint, default=dark)

### Root-cause / design rationale
User requested full black/dark mode with orange accent titles, off-white body text, darker grey hints, unified buttons, and visual feedback for touch/D-pad navigation. StateListDrawable on adapter items handles both pressed (touch) and state_selected (D-pad/controller) states natively. ListView selector adds a semi-transparent orange overlay for controller focus.

### CI result
→ ✅ run 23367550267 — PASSED — Normal APK built

---

## Entry 65 — v2.7.1-pre — Buttons to header, D-pad selection fix (2026-03-20)

### Files changed
- `patches/smali_classes16/.../ComponentManagerActivity.smali`
- `patches/smali_classes16/.../BhComponentAdapter.smali`
- `patches/smali_classes16/.../ComponentDownloadActivity$DarkAdapter.smali`

### Methods changed
- `ComponentManagerActivity.buildUI()` — removed bottom bar section
- `ComponentManagerActivity.buildHeader()` — inserted BhAddListener + BhDownloadListener buttons before ✕ All
- `ComponentManagerActivity.makeBtn()` — reduced padding 16/8dp → 8/4dp
- `BhComponentAdapter.onCreateViewHolder()` — added setFocusable(true) + StateListDrawable foreground (focused=0x60FF9800 orange, pressed=0x40000000 dark, default=transparent) on card
- `DarkAdapter.getView()` — added state_focused entry, changed selection color to 0xFF3D2800

### Root-cause / design
ListView/RecyclerView D-pad highlight was invisible: old colors too subtle + RecyclerView cards not focusable. Fix: foreground StateListDrawable on RecyclerView cards (doesn't affect rounded corner background). ListView items: brighter amber state_focused + state_selected colors.

### CI result
→ ✅ run 23367802578 — PASSED — Normal APK built

---

## Entry 66 — v2.7.2-pre — Header button shift center-right + card outline dividers (2026-03-20)

### Files changed
- `patches/smali_classes16/.../ComponentManagerActivity.smali`
- `patches/smali_classes16/.../BhComponentAdapter.smali`

### Methods changed
- `ComponentManagerActivity.buildHeader()` — added weight=0.5 flex spacer View (WRAP_CONTENT x MATCH_PARENT, weight=0.5f) between "↓ DL" addView and "✕ All" addView; shifts the two action buttons from hard-right edge to approximately center-right (~67% from left)
- `BhComponentAdapter.onCreateViewHolder()` — increased `.locals 13` → `.locals 14`; after `setCornerRadius`, added `dp(1)` stroke in `0xFF2E2E45` (subtle dark lavender) via `GradientDrawable.setStroke(I I)V`; v13 used for stroke color constant

### Root-cause / design
User feedback: buttons were flush against the right edge (visually cramped), and individual component cards had no visual separator (list appeared as one continuous block). Fix 1: flex spacer pushes buttons toward center while keeping them right of center. Fix 2: 1dp stroke on each card's GradientDrawable provides a thin rounded outline that matches the card shape exactly — more elegant than a divider View.

### CI result
→ ✅ — Normal APK built

---

## Entry 67 — v2.7.3-pre — Fix broken card rendering; 8dp margin card separation (2026-03-20)

### Files changed
- `patches/smali_classes16/.../BhComponentAdapter.smali`

### Methods changed
- `BhComponentAdapter.onCreateViewHolder()` — `.locals 14` → `.locals 13` (reverted); removed `GradientDrawable.setStroke(II)V` call; changed `setMargins(v5, v3, v5, v3)` → `setMargins(v5, v4, v5, v4)` (12dp/8dp/12dp/8dp — v4=8dp instead of v3=4dp)

### Root-cause / design
`GradientDrawable.setStroke(II)V` in `onCreateViewHolder` threw a silent exception. RecyclerView's internal recycler catches exceptions during view holder creation (in some versions) and renders nothing — giving "8 installed" in the badge but zero visible cards. The `.locals 14` change was also unnecessary (created extra complexity). Fix: revert to `.locals 13`, drop setStroke entirely. Card visual separation now uses 8dp top+bottom margin instead of stroke — no GradientDrawable mutation after setBackground is needed.

### CI result
→ ✅ — Normal APK built

---

## Entry 68 — v2.7.4-pre — Rollback to v2.7.0-pre UI state (2026-03-20)

### Files changed
- `patches/smali_classes16/.../ComponentManagerActivity.smali`
- `patches/smali_classes16/.../BhComponentAdapter.smali`
- `patches/smali_classes16/.../ComponentDownloadActivity$DarkAdapter.smali`

### Methods changed
- All three files reverted to v2.7.0-pre baseline — all v2.7.1/2.7.2/2.7.3 changes removed

### Root-cause / design
v2.7.1/2.7.2/2.7.3 accumulated inconsistent state (D-pad foreground, weight spacer, setStroke removed, margin fix). Cleanest path forward: roll back to last known-good baseline (v2.7.0-pre) and re-apply only the desired changes cleanly in v2.7.5-pre.

### CI result
→ ✅ run 23368449300 — Normal APK built

---

## Entry 69 — v2.7.5-pre — Buttons to header center-right + card outline (2026-03-21)

### Files changed
- `patches/smali_classes16/.../ComponentManagerActivity.smali`
- `patches/smali_classes16/.../BhComponentAdapter.smali`

### Methods changed
- `ComponentManagerActivity.buildUI()` — removed `buildBottomBar()` call; buttons now live in header
- `ComponentManagerActivity.buildHeader()` — added "+ Add" and "↓ DL" buttons before "✕ All"; added weight=0.5 flex spacer between "↓ DL" and "✕ All" to shift buttons to center-right; `makeBtn()` padding changed 16/8dp → 8/4dp (compact for header)
- `BhComponentAdapter.onCreateViewHolder()` — re-added `GradientDrawable.setStroke(1dp, 0xFF3A3A55)` using v8 as temp register

### Root-cause / design
Buttons moved from bottom bar to header for a cleaner single-bar layout. setStroke re-added thinking v8 was a safe free temp — but the same silent RecyclerView failure from Entry 66 recurred at runtime (not caught by CI). Lesson: setStroke(II)V on GradientDrawable in onCreateViewHolder is fundamentally unreliable in this RecyclerView version regardless of register choice.

### CI result
→ ✅ run 23368769317 — Normal APK built (cards broken at runtime — see Entry 70)

---

## Entry 70 — v2.7.6-pre — Fix: remove setStroke again; 8dp card margins (2026-03-21)

### Files changed
- `patches/smali_classes16/.../BhComponentAdapter.smali`

### Methods changed
- `BhComponentAdapter.onCreateViewHolder()` — removed setStroke block (6 lines: `const/4 v2 0x1`, `invoke dp`, `move-result v2`, `const v8 color`, `invoke setStroke`, comment line); changed `setMargins(v5, v3, v5, v3)` → `setMargins(v5, v4, v5, v4)` (12/8/12/8 dp)

### Root-cause / design
Same root cause as Entry 67: `GradientDrawable.setStroke(II)V` in `onCreateViewHolder` causes silent RecyclerView failure (0 cards rendered). This is a hard rule: do NOT call setStroke on card GradientDrawable in onCreateViewHolder in this GameHub RecyclerView version. Card separation achieved via 8dp top+bottom margin only.

### CI result
→ ✅ run 23369306581 — Normal APK built

---

## Entry 71 — v2.7.7-pre — Fix header stuck at vertical center of screen (2026-03-21)

### Files changed
- `patches/smali_classes16/.../ComponentManagerActivity.smali`

### Methods changed
- `ComponentManagerActivity.buildUI()` — (1) removed `invoke-virtual {v0, v1}, Landroid/view/View;->setFitsSystemWindows(Z)V`; (2) changed final `setContentView(View)` → `setContentView(View, ViewGroup.LayoutParams(MATCH_PARENT, MATCH_PARENT))` (3 new lines: new-instance v1, const/4 v2 -0x1, invoke-direct v1 v2 v2, invoke-virtual p0 v0 v1)

### Root-cause / design
`setFitsSystemWindows(true)` on the root LinearLayout was interacting with AppCompat's subDecor insets pass, offsetting content to the vertical center of the window instead of the top. Additionally, `setContentView(View)` without explicit LayoutParams leaves sizing to the subDecor; if the subDecor provides WRAP_CONTENT MeasureSpec the weight=1 content won't expand. Fix: remove setFitsSystemWindows; pass MATCH_PARENT×MATCH_PARENT LayoutParams to guarantee root fills the window.

### CI result
→ ✅ run 23369636270 — Normal APK built

---

## Entry 73 — v2.6.2-pre7 — Fix Remove All count + clear SP entries on removal (2026-03-21)

### Files changed
- `[MOD] patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentDownloadActivity$5.smali`
- `[MOD] patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

### Methods changed
- `ComponentDownloadActivity$5.run()` — added `"url_for:"+dirName → mDownloadUrl` SP write before `apply()`. Enables reverse lookup of the download URL by dir name for removal cleanup. `.locals` stays at 12; uses existing v6/v7 (freed after scan loop).
- `ComponentManagerActivity.confirmRemoveAll()` — `.locals 5→7`; added counting loop before the dialog build that iterates `components[]` and counts only dirs where `new File(dir, ".bh_injected").exists()` is true. Dialog message now shows the BannerHub-managed count instead of all installed components.
- `ComponentManagerActivity.removeComponent()` — `.locals 6→10`; after `deleteDir`, reads SP "banners_sources", looks up `"url_for:"+dirName`, if non-null opens an editor and removes 4 keys: `dirName`, `dirName+":type"`, `"dl:"+url`, `"url_for:"+dirName`. Clears the ✓ downloaded indicator in the repo list when a component is removed.
- `ComponentManagerActivity.removeAllComponents()` — `.locals 8→12`; gets SP before loop (v8); inside loop per `.bh_injected` component, does same 4-key SP cleanup using v9 (editor), v10 (url), v11 (key temp). Each component's editor is opened fresh and `apply()`d immediately.

### Root-cause / design
- Bug A: `confirmRemoveAll` previously used raw `array-length` on `components[]` which includes all GameHub-installed components, not just BannerHub-injected ones. Fix: count `.bh_injected` marker files.
- Bug B: On removal, the `"dl:"+url → "1"` SP key was never cleared, so the ✓ icon persisted in the online repo download list. Fix: `$5` writes a reverse key `"url_for:"+dirName` at injection time; removal methods read it to get the URL, then delete all 4 related SP entries.

### CI result
→ run 23380984014 — queued

## Entry 72 — v2.7.8-pre — Fix header centering: root switched to RelativeLayout (2026-03-21)

### Files changed
- `patches/smali_classes16/.../ComponentManagerActivity.smali`

### Methods changed
- `ComponentManagerActivity.buildUI()` — replaced root `LinearLayout` + `weight=1` pattern with `RelativeLayout`. Header gets `setId(1)` + `addRule(ALIGN_PARENT_TOP, TRUE)` + `LayoutParams(MATCH_PARENT, WRAP_CONTENT)`. Content gets `LayoutParams(MATCH_PARENT, MATCH_PARENT)` + `addRule(BELOW, 1)` + `addRule(ALIGN_PARENT_BOTTOM, TRUE)`. `.locals` stays at 6.

### Root-cause / design
LinearLayout weight=1 (height=0dp child) requires EXACTLY MeasureSpec on the weight axis from the parent. AppCompat's ContentFrameLayout (subDecor content area) may provide AT_MOST instead. When AT_MOST is received, LinearLayout skips weight distribution entirely, and the weight=1 child stays at 0dp. Root LinearLayout ends up WRAP_CONTENT height = header height only. AppCompat then places this narrow root at the vertical center of the window. Two prior fixes (removing setFitsSystemWindows, explicit MATCH_PARENT LayoutParams) did not resolve it, indicating the MeasureSpec issue is in AppCompat internals. RelativeLayout constraint geometry bypasses MeasureSpec entirely.

### CI result
→ ✅ run 67991306650 — Normal APK built
