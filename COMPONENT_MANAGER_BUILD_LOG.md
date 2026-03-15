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
- `.locals 4`
- `ContentResolver.query(uri, [DISPLAY_NAME], null, null, null)` via `invoke-virtual/range {v0..v5}`
- Moves cursor to first row, reads column 0
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
**Date:** 2026-03-15  |  **Commit:** `5808a2a`  |  **Tag:** v2.2.7-pre

### Changes
- **Title:** `"Component Manager"` → `"Banners Component Manager"`
- **`setFitsSystemWindows(true)`** on ListView: system automatically applies insets for status bar (top) and navigation bar (bottom)
- **`setClipToPadding(false)`** on ListView: list scrolls behind the padding area so no items are permanently hidden

### Root cause
ListView was set as the raw content view with no inset handling. GameHub's theme hides the ActionBar entirely, so `setTitle()` had no visible effect. On devices with on-screen navigation buttons, the last few list items were obscured and untappable.

### Files touched
- `patches/smali_classes16/com/xj/landscape/launcher/ui/menu/ComponentManagerActivity.smali`

### CI result
✅ Passed (d6d9965)

---

# Appendix C — Known constraints

| Constraint | Detail |
|------------|--------|
| smali_classes11 full | At/near 65535 dex index limit — all new classes go to smali_classes16 |
| No external dex inject | GameHub class loader finds its own copies first; injected dex loses |
| TarArchiveInputStream obfuscated | `getNextTarEntry()` = `s()`, `isDirectory()` missing → use `getName().endsWith("/")` |
| XZInputStream constructor | `<init>(InputStream, int)V` only; second arg = -1 for unlimited |
| invoke-virtual max 5 regs | ContentResolver.query() needs `invoke-virtual/range` |
| const/4 max v15 | v16+ destinations need `const/16` or `sget-object` |
| EnvLayerEntity 18-param ctor | Needs `invoke-direct/range {v0..v19}` — 20 consecutive regs |
| firebase raws rule | Never include `firebase_common_keep`/`firebase_crashlytics_keep` in public.xml |
