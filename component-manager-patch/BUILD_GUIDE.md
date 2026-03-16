# Component Manager Patch — Build Guide

A standalone smali patch that adds a full **Component Manager** to GameHub Lite 5.3.5 ReVanced.
No other BannerHub modifications are included — this is the Component Manager feature in isolation.

---

## What this patch adds

### Side-navigation "Components" entry
A new **Components** item appears at the bottom of GameHub's left-side drawer menu (below Settings).
Tapping it opens the Component Manager activity.

### Component Manager (3-mode ListView)
- **Component list** — shows every folder inside `files/usr/home/components/`, plus a
  `+ Add New Component` header at the top.
- **Options menu** — tap an existing component to get: Inject/Replace file, Backup, Remove, Back.
- **Type-selection menu** — tap `+ Add New Component` to choose:
  `↓ Download from Online Repos`, DXVK, VKD3D-Proton, Box64, FEXCore, GPU Driver / Turnip, Back.

### In-app component downloader
- **6 online repos**: Arihany WCPHub, Kimchi GPU Drivers, StevenMXZ GPU Drivers, MTR GPU Drivers,
  Whitebelyash GPU Drivers, The412Banner Nightlies.
- 3-level navigation: **repo → category (DXVK / VKD3D / Box64 / FEXCore / GPU Driver) → asset list**.
- Tap an asset to download and inject it directly — no PC required.

### Inject from local file
- Pick any `.wcp`, `.xz`, or `.zip` file from your device storage.
- Automatically extracts to the correct component folder and registers in GameHub.
- Backup copies any component folder to `Downloads/BannerHub/<name>/`.
- Remove deletes the folder and unregisters the component from GameHub's selection menus.

### Local components visible in GameHub menus
Injected components appear immediately in GameHub's GPU driver / DXVK / VKD3D / Box64 / FEXCore
selection menus — no restart required.

---

## Repository structure

```
component-manager-patch/
├── patches/                          ← Copy over the decompiled APK tree
│   ├── smali_classes16/
│   │   └── com/xj/landscape/launcher/ui/menu/
│   │       ├── ComponentManagerActivity.smali        NEW — main activity
│   │       ├── ComponentManagerActivity$1.smali      NEW — background inject thread
│   │       ├── ComponentManagerActivity$2.smali      NEW — UI result runnable
│   │       ├── ComponentInjectorHelper.smali         NEW — extraction + registration logic
│   │       ├── WcpExtractor.smali                   NEW — WCP/ZIP extraction (local inject)
│   │       ├── ComponentDownloadActivity.smali       NEW — 3-mode download activity
│   │       ├── ComponentDownloadActivity$1.smali     NEW — GitHub Releases API fetch
│   │       ├── ComponentDownloadActivity$2.smali     NEW — ShowCategories UI runnable
│   │       ├── ComponentDownloadActivity$3.smali     NEW — download-to-cache runnable
│   │       ├── ComponentDownloadActivity$4.smali     NEW — complete (toast + finish) runnable
│   │       ├── ComponentDownloadActivity$5.smali     NEW — inject on UI thread (Looper fix)
│   │       ├── ComponentDownloadActivity$6.smali     NEW — pack.json fetch runnable (Arihany / Nightlies)
│   │       ├── ComponentDownloadActivity$7.smali     NEW — Kimchi JSON fetch (superseded, still present)
│   │       ├── ComponentDownloadActivity$8.smali     NEW — single-release fetch (superseded, still present)
│   │       └── ComponentDownloadActivity$9.smali     NEW — flat GPU drivers JSON fetch
│   ├── smali_classes3/
│   │   └── com/xj/winemu/settings/
│   │       └── GameSettingViewModel$fetchList$1.smali   MODIFIED — 2 lines injected
│   └── smali_classes5/
│       └── com/xj/landscape/launcher/ui/menu/
│           └── HomeLeftMenuDialog.smali              MODIFIED — Components menu item added
├── build.yml                         ← GitHub Actions workflow
└── BUILD_GUIDE.md                    ← This file
```

The `smali_classes16/` files are written from scratch — they contain no original GameHub code.
The `smali_classes3/` and `smali_classes5/` files are modified copies of original GameHub smali
with 2–20 lines injected. See **Injection point reference** below for the exact diffs.

---

## Quick start — GitHub Actions (recommended)

### Prerequisites
- A GitHub account with Actions enabled
- The base GameHub 5.3.5 ReVanced APK accessible as a release asset
  (the workflow downloads it from `The412Banner/bannerhub` release `base-apk` by default)
- AOSP test signing keys committed to your repo (`testkey.pk8` + `testkey.x509.pem`)

### Steps

1. **Create a new GitHub repo** and push the contents of `component-manager-patch/` as the root.

2. **Copy signing keys** from the BannerHub repo into your new repo root:
   ```bash
   # From bannerhub/:
   cp testkey.pk8 testkey.x509.pem /path/to/your-new-repo/
   ```

3. **Place the workflow** at `.github/workflows/build.yml`:
   ```bash
   mkdir -p .github/workflows
   mv build.yml .github/workflows/build.yml
   ```

4. **Configure the base APK source** (optional).
   By default the workflow fetches from `The412Banner/bannerhub` (public, no token needed).
   To host your own base APK, create a release tagged `base-apk` in your repo with the APK
   as an asset, then remove `-R The412Banner/bannerhub` from the download step.

5. **Push a tag** to trigger a build:
   ```bash
   git tag v1.0.0
   git push origin refs/tags/v1.0.0
   ```
   The workflow will build and upload `GameHub-ComponentManager.apk` as a GitHub release.

---

## Manual build (no CI)

### Requirements
- Java 11+
- Android SDK Build Tools (for `zipalign` and `apksigner`)
- apktool 2.9.3+

### Steps

```bash
# 1. Get the base APK (GameHub 5.3.5 ReVanced, ~136 MB)
#    Download from: https://github.com/The412Banner/bannerhub/releases/tag/base-apk

# 2. Decompile
java -jar apktool.jar d GameHub-5.3.5.apk -o apktool_out -f

# 3. Remove uncompilable apktool artifacts
rm -f apktool_out/res/values/raws.xml
sed -i '/firebase_common_keep\|firebase_crashlytics_keep/d' \
    apktool_out/res/values/public.xml

# 4. Apply patches
cp -r patches/. apktool_out/

# 5. Inject activity declarations into AndroidManifest.xml
#    Add these two lines inside <application> before </application>:
#
#    <activity
#        android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|screenSize|smallestScreenSize"
#        android:name="com.xj.landscape.launcher.ui.menu.ComponentManagerActivity"
#        android:screenOrientation="sensorLandscape"/>
#    <activity
#        android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|screenSize|smallestScreenSize"
#        android:name="com.xj.landscape.launcher.ui.menu.ComponentDownloadActivity"
#        android:screenOrientation="sensorLandscape"/>

# 6. Rebuild
java -jar apktool.jar b apktool_out -o rebuilt-unsigned.apk

# 7. Align
zipalign -f -v 4 rebuilt-unsigned.apk rebuilt-aligned.apk

# 8. Sign (AOSP test key)
apksigner sign \
  --key testkey.pk8 \
  --cert testkey.x509.pem \
  --v1-signing-enabled true \
  --v2-signing-enabled true \
  --v3-signing-enabled true \
  --out GameHub-ComponentManager.apk \
  rebuilt-aligned.apk
```

---

## Injection point reference

This section documents the exact changes made to the two original GameHub files.
Use this if you want to reproduce the patch against a different APK version.

---

### File 1 — `smali_classes5/com/xj/landscape/launcher/ui/menu/HomeLeftMenuDialog.smali`

**Purpose:** Adds the "Components" item to GameHub's left-side navigation drawer.

There are two injection sites in this file.

#### Site 1 — Menu item builder

Find the method that builds the side menu item list.
It ends with a `return-void` preceded by this line:

```smali
    invoke-interface {p0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z
```

Insert the following block **before** `return-void`:

```smali
    # ── INJECTION: Components menu item (ID=9) ──────────────────────────
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
    # ── END INJECTION ────────────────────────────────────────────────────
```

Parameters: `id=9`, `iconRes=menu_setting_normal`, `name="Components"`,
`rightContent=""` (v8=null), `mask=0x18`, `DefaultConstructorMarker=null`.

#### Site 2 — Click handler packed-switch

Find the `invoke` method (click handler) that dispatches menu item taps via packed-switch.

Extend the switch table from 9 → 10 entries by adding `:pswitch_9`:

```smali
    # BEFORE:
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

    # AFTER:
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

Add the handler block **before** `:pswitch_data_0`:

```smali
    # ── INJECTION: Components click handler ─────────────────────────────
    :pswitch_9
    new-instance p0, Landroid/content/Intent;
    const-class p1, Lcom/xj/landscape/launcher/ui/menu/ComponentManagerActivity;
    invoke-direct {p0, p2, p1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p2, p0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    goto :goto_1
    # ── END INJECTION ────────────────────────────────────────────────────
```

`p2` is the `Context` parameter of the lambda (the activity context passed into the click handler).
`:goto_1` is the label at the very end of the method body (before `:pswitch_data_0`).

---

### File 2 — `smali_classes3/com/xj/winemu/settings/GameSettingViewModel$fetchList$1.smali`

**Purpose:** Makes locally injected components appear in GameHub's GPU driver / DXVK / VKD3D / Box64 /
FEXCore selection menus by appending them to the server list before the callback fires.

Find the block around lines 2942–2954 that looks like this:

```smali
    # BEFORE:
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;
    invoke-virtual {v0, v7}, Lcom/xj/common/data/model/CommResultEntity;->setData(Ljava/lang/Object;)V

    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$callback:Lkotlin/jvm/functions/Function1;
    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;
    invoke-interface {v0, v1}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;
```

Insert two lines between `setData` and the callback:

```smali
    # AFTER:
    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;
    invoke-virtual {v0, v7}, Lcom/xj/common/data/model/CommResultEntity;->setData(Ljava/lang/Object;)V

    # ── INJECTION: append local components before callback ───────────────
    iget v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$contentType:I
    invoke-static {v7, v0}, Lcom/xj/landscape/launcher/ui/menu/ComponentInjectorHelper;->appendLocalComponents(Ljava/util/List;I)V
    # ── END INJECTION ────────────────────────────────────────────────────

    iget-object v0, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$callback:Lkotlin/jvm/functions/Function1;
    iget-object v1, v5, Lcom/xj/winemu/settings/GameSettingViewModel$fetchList$1;->$result:Lcom/xj/common/data/model/CommResultEntity;
    invoke-interface {v0, v1}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;
```

`v7` = the `List<DialogSettingListItemEntity>` from the server.
`$contentType` = component type int: DXVK=12, VKD3D=13, Box64=94, FEXCore=95, GPU=10.

> **Note:** This file may have multiple branches (success + various error/empty paths). Find
> every `setData(v7)` call that is immediately followed by a `$callback` invocation and
> apply the same two-line injection to each one.

---

### File 3 — `AndroidManifest.xml`

Add inside `<application>` before `</application>`:

```xml
<activity
    android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|screenSize|smallestScreenSize"
    android:name="com.xj.landscape.launcher.ui.menu.ComponentManagerActivity"
    android:screenOrientation="sensorLandscape"/>
<activity
    android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|screenSize|smallestScreenSize"
    android:name="com.xj.landscape.launcher.ui.menu.ComponentDownloadActivity"
    android:screenOrientation="sensorLandscape"/>
```

> `android:exported="false"` is implied when no `<intent-filter>` is present on API 30+.
> Adding it explicitly is optional but harmless.

---

## Key constraints to know

| Constraint | Detail |
|------------|--------|
| Target APK | GameHub Lite 5.3.5 (ReVanced) — `gamehub.lite` package |
| smali_classes11 is full | At/near 65535 dex index limit — all new smali goes to `smali_classes16` |
| No external dex injection | GameHub's class loader finds its own commons-compress/zstd/xz copies first; injected dex loses |
| `TarArchiveInputStream.getNextTarEntry()` | Obfuscated to `s()` in GameHub's ProGuard output |
| `XZInputStream` constructor | `<init>(InputStream, int)V` only; second arg = `-1` for unlimited |
| `invoke-virtual` max 5 args | `ContentResolver.query()` (6 args) requires `invoke-virtual/range` |
| `const/4` max v15 | v16+ destinations need `const/16` |
| `Toast` requires main thread | `ComponentInjectorHelper.injectComponent()` calls `Toast.makeText()` internally — must be called on UI thread via `runOnUiThread()` |
| firebase aapt2 rule | Never include `firebase_common_keep` or `firebase_crashlytics_keep` in `public.xml` — they break aapt2 link |
| `.locals` max for inner classes | `.locals 15` maximum when `p0` is used as 4-bit-range operand (`p0=v15`); `.locals 16` pushes `p0` to `v16`, out of 4-bit range |

---

## Signing keys

The AOSP test key pair (`testkey.pk8` / `testkey.x509.pem`) is committed to the
[BannerHub repo](https://github.com/The412Banner/bannerhub). Copy both files to the
root of any repo using this workflow.

These keys are public domain and well-known. They are suitable for sideloading and
development only — do not use them for Play Store distribution.

---

## Credits

- Component Manager, ComponentInjectorHelper, ComponentDownloadActivity — The412Banner
- RTS touch controls (not included in this patch) — @Nightwalker743
- Base patching workflow — BannerHub (https://github.com/The412Banner/bannerhub)
