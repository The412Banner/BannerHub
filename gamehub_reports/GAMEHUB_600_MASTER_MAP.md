# GameHub 6.0.4 — Master APK Map

**Generated:** 2026-05-01 (against 6.0.0)
**Last revised:** 2026-05-19 — firmware section synced to deployed Worker: 1.3.7 → 1.3.8 (`2d88572`, 2026-05-14) → 1.4.1 (`5dc29a9`, 2026-05-15); the retired "5.x stays on 1.3.3" split removed (5.x + 6.0 now in 7-site lockstep on 1.4.1). Prior revision 2026-05-13 — added § 26.23 (Renderer Rewrite — GLES2 → Vulkan, byte-level libxserver.so + libwinemu.so 6.0.2 vs 6.0.4 diff) and expanded the § 26.20 size table with a 6.0.2 column + the two render libs. Previous full refresh 2026-05-12: 9 parallel verification passes against `gh604.apk` (versionCode 114) re-derived every R8 class letter, re-counted every field/enum/permission, and folded 6.0.2 / 6.0.3 / 6.0.4 deltas into § 26. Previous baseline (6.0.0 / 6.0.1) retained at `GAMEHUB_600_MASTER_MAP.backup-2026-05-12.md`.
**Source APK:** `gh604.apk` (versionCode 114, versionName 6.0.4, r8-map-id `6a5cde6143fc8cf76f6f3a447d0fececd4794d83066e6ead7a9537e6527b057b`) — primary; `GameHub_6.0.1.apk` (versionCode 111, r8-map-id `1c1886510d561c4653513192b80f6aeca10d1a5fcff2e7c8e7498396fe52a4ea`) — diff baseline; `GameHub_beta_6.0.0_global.apk` (versionCode 110) — original survey baseline.
**Tools:** apktool 2.12.1 + jadx
**Coverage:** 32 iterative passes against 6.0.0 (2026-05-01/03) + 18 angle-pass scans against 6.0.1 for § 26 expansion (2026-05-07) + 9 parallel section refreshes against 6.0.4 (2026-05-12). 6.0.2 and 6.0.3 (versionCodes 112, 113) were NOT separately decompiled — intermediate point-release timing of individual 6.0.1→6.0.4 deltas is unknown. Pass detail at § 25.
**Companion report:** `BANNERHUB_API_6.0_INTEGRATION.md` documents the BannerHub Cloudflare Worker + bannerhub-revanced patch divergence from this vanilla map.

> **What changed since the 6.0.1 baseline (TL;DR for patch maintainers):**
> - versionCode `111 → 114`, versionName `6.0.1 → 6.0.4`, new r8-map-id (all letters reshuffled)
> - **minSdkVersion `31 → 29`** (Android 12 → 10), **+2 permissions** (`BLUETOOTH`, `BLUETOOTH_ADMIN`)
> - `libsteamkit_core.so` `10.0 MB → 10.9 MB` (absorbs new `LaunchIntent` JNI replacing `SteamAgentTicketIssuer`)
> - `libwinemu.so` `684 KB → 658 KB`; **`DirectRendering` JNI removed entirely**; XServer `setRenderingEnabled → setFlipEnabled`
> - DEX class totals `53,053 → 53,766`; `com.winemu.*` package reshuffle (XServer ui→core/server; new BottleMetadata, CabFile, GPUInfoQuery)
> - `AppNavKey` parcelable destinations `119 → 79` (Compose nav route registry restructured)
> - **Component-install cache split**: singleton `Ll9o/Lltn → Lj7o` + new backend `Lmyo`; read API `z(RepoCategory)→ArrayList` **deleted**, replaced by `x(RepoCategory)→SharedFlow` + `i(RepoCategory, String)→WinEmuRepo`
> - `EnvLayerEntity` field count `19 → 21`; `ComponentType` enum `7 → 8` values (`STEAMCLIENT(7)` is `@Deprecated`)
> - Many data classes grew: `ControlAppearance 30 → 42`, `VJoyLayout 6 → 9`, `VJoyControl 6 → 7`, `WineActivityData 23 → 27`, `PcGameSettingSchemePayload 17 → 18` (+`hostCoreMask`)
> - 2 new strings only: `winemu_sidebar_hud_engine`, `winemu_sidebar_touch_input_right_stick_sensitivity`
> - All 13 R8 class letters tracked in § 26.2 successfully re-derived for 6.0.4; URL-builder interface TBD from 6.0.1 (`Lyw9;`) resolved as `Lv6a;`
> - "Compose Navigation v3 (androidx.navigation3)" claim from the 6.0.0 doc was **wrong** — nav is custom under `com.xiaoji.egggame.core.navigation.*` (same in 6.0.1)

---

## Table of Contents

1. APK Identity
2. Architecture Overview
3. Native Layer (libs + JNI surface)
4. Assets (composeResources, shaders, baseline profile, root files)
5. Resources (XML, fonts, layouts)
6. AndroidManifest (activities, services, receivers, providers, permissions, processes)
7. DEX / Java Package Map
8. Application Entry Points (init order, deep links)
9. Subsystems
   - 9.1 WinEmu (Wine emulation core)
   - 9.2 Steam Integration
   - 9.3 Epic Games (EpicKit)
   - 9.4 Retro Emulation
   - 9.5 Cloud Gaming (VTouch + Haima HMCP)
   - 9.6 In-App Payment
   - 9.7 Card System
   - 9.8 Virtual Joystick (VJoy)
   - 9.9 Performance HUD
   - 9.10 Performance Telemetry
10. DTO Inventory
11. Storage
    - 11.1 Room Databases
    - 11.2 SharedPreferences / MMKV
    - 11.3 FileProvider Paths
12. API Surface
    - 12.1 Catalog API (`zhj`-enum-equivalent, bare hostnames)
    - 12.2 Client API (`clientgsw.vgabc.com/clientapi/`)
    - 12.3 Standalone first-party URL literals
    - 12.4 Live verification — host reachability matrix
13. CDN Structure
14. Third-Party SDK Endpoints
15. Custom URI Schemes
16. External `content://` Providers
17. Game Launch Types
18. Third-Party SDK Inventory
19. Removed Since 5.3.5
20. Themes & Styles
21. Third-Party Metadata (app IDs, SDK versions)
22. New in 6.0 vs 5.3.5
23. Decompile Output Locations
24. Related Reports
25. Appendix A — Scan History (2026-05-01 → 2026-05-12)
26. 6.0.0 → 6.0.4 Deltas (cumulative)
    - 26.1 APK Identity Bump
    - 26.2 R8 Class-Letter Remap (auth flow, navigator, URL builder, data classes — all 13 letters re-derived for 6.0.4)
    - 26.3 New vjoy/Scheme Cloud-Share Subsystem (added 6.0.1, present in 6.0.4)
    - 26.4 New API Endpoint Family (vcontroller/*, simulator/configList family, layoutType)
    - 26.5 NavigationInterceptor (added 6.0.1, still present in 6.0.4)
    - 26.6 Firmware Version Bump (1.3.4 → 1.3.5 → 1.3.6 → 1.3.7 → 1.3.8 → 1.4.1)
    - 26.7 Upstream Feature Highlights (XiaoJi-side, from 6.0.1 release notes)
    - 26.8 AI Frame Generation — Technical Deep Dive (data classes, persistence, mmap IPC, libGameScopeVK ICD, VK_NV_optical_flow on Adreno, UI strings, capability gating)
    - 26.9 Steam SDK Refresh (cancellable downloads, network-status sync, libsteamkit_core size table 6.0.0 → 6.0.4)
    - 26.10 vjoy Multi-Layer Architecture (VJoyLayer, ControlAction.SwitchLayer, layout-format extension)
    - 26.11 Gyroscope + New Touchscreen Input Methods (GyroAim/TargetMode, ScreenTouchInput/Mode, AxisRole, VJoyTextAlign)
    - 26.12 Box64 Per-Game Tunable UI (~80 new strings; 30+ Box64 dynarec/TSO/x87/SMC tunables per game)
    - 26.13 Wine HUD Overlay Strings (MangoHud Integration) — incl. new 6.0.4 `winemu_sidebar_hud_engine`
    - 26.14 PC Game Data Backup / Restore
    - 26.15 Wine Performance Modes (Power Profiles)
    - 26.16 Setup / Install Flow Rewrite
    - 26.17 Container State Check + Game-File Validator
    - 26.18 DTO Package Move (`core.domain.base.*` → `core.network.model.baseinfo.dto.*`)
    - 26.19 Resource Asset Additions
    - 26.20 Native Library Refresh — extended to 6.0.4 with libsteamkit_core +880 KB
    - 26.21 Manifest Correction (USB host)
    - 26.22 Additional Sidebar Features — incl. new 6.0.4 `winemu_sidebar_touch_input_right_stick_sensitivity`
    - 26.23 Renderer Rewrite — GLES2 → Vulkan (libxserver.so + libwinemu.so 6.0.2 vs 6.0.4, byte-level)
27. 6.0.1 → 6.0.4 Component-Install Focus (added 2026-05-12)
    - 27.1 APK Identity bump (versionCode 111 → 114, new r8-map-id)
    - 27.2 Component-install pipeline — R8 letter remap (`Lltn;` → `Lj7o;`, with new backend `Lmyo`)
    - 27.3 Doc corrections discovered while diffing
    - 27.4 Install-flow strings — unchanged vs 6.0.1
    - 27.5 Endpoint surface — unchanged
    - 27.6 What this means for component install on 6.0.4

---
## 1. APK Identity

| Field            | Value                          |
|------------------|-------------------------------|
| Package          | `com.xiaoji.egggame` (this APK); also branches on `com.xiaoji.egggame.realme` and `com.xiaoji.egggame.redmagic` package IDs at runtime — confirms OEM-skinned variants for RealMe and RedMagic gaming phones (both literal package strings still present at `smali_classes4/fco.smali` and `smali_classes4/oc5.smali`) |
| Version Name     | 6.0.4                          |
| Version Code     | 114                            |
| Min SDK          | 29 (Android 10) — **lowered from 31 in 6.0.0**; broadens device reach to Android 10/11 |
| Target SDK       | 36 (Android 16)                |
| Compile SDK      | 36 / codename 16               |
| Architecture     | arm64-v8a only                 |
| DEX files        | 6 (classes.dex – classes6.dex) |
| Total smali files | 53,766 (≈ class count; +713 vs. 6.0.0's 53,053) |
| Build VCS        | git rev `587c1410a799b8f421c7913dbc06f8d4fa46c372` (recorded in `unknown/META-INF/version-control-info.textproto`) |
| Obfuscation      | Heavy R8 (~98% of classes use 2–4 char names) — **R8 map-id `6a5cde6143fc8cf76f6f3a447d0fececd4794d83066e6ead7a9537e6527b057b`**, so every short class letter has been re-shuffled vs. 6.0.0/6.0.1. Named: `com.xiaoji.*`, `com.winemu.*`, `com.xj.muugi.*`, plus all third-party SDKs |
| Locales          | 165+ resource folders (194 total `res/` dirs). KMP string translations: ja-rJP, pt-rBR, ru-rRU, zh-rCN (default); cardsystem also has ar + es |

**Source receipt (2026-05-12 refresh):** GH 6.0.4 lifted from `/data/data/com.termux/files/home/GameHub_6.0.4.apk` (versionName `6.0.4`, versionCode `114`); apktool.yml reports `apkFileName: GameHub_6.0.4.apk`. The 6.0.0 baseline came from a device install of `com.mihoyo.genshinimpact` (XiaoJi reuses miHoYo's package for their store skin), versionCode `49908`.

---

## 2. Architecture Overview

| Aspect | Choice |
|---|---|
| **UI stack** | Kotlin + Jetpack Compose (primary). Legacy XML layouts only for third-party SDK screens (Weibo, Alipay, HMCP, etc.) |
| **KMP** | Compose Multiplatform resource system — 31 modules in `assets/composeResources/` |
| **Navigation** | Single-activity custom Compose nav registry under `com.xiaoji.egggame.core.navigation.*` (the 6.0.0 doc's "Compose Navigation v3 / androidx.navigation3" claim was **wrong** — no `androidx.navigation*` exists in smali, confirmed against 6.0.4). `AppNavKey` sealed class declares **79 `@Serializable` parcelable destinations** in 6.0.4 (counted via `AppNavKey$*$$serializer.smali`; down from 119 grouped routes in the 6.0.0/6.0.1 figure, which mixed serialized parcelables with data-object routes that have since moved to a separate route registry). kotlinx.serialization wired in for typed-payload routes |
| **DI** | Koin — ~70–80 modules total: 22 prebuilt + 19 inline in `BaseAndroidApp`, plus ~30+ from an additional feature-DI factory class (R8 letters shifted vs. 6.0.0; the prior `us2.smali` anchor now points to `ColorCacheKey`, so the factory letter is re-resolved in §§ 3–5) |
| **Wine integration** | `libwinemu.so` + `libxserver.so` runtime; `WineActivity` + `com.winemu.*` Java SDK; runs in separate `:wine` process |
| **GPU info** | `libgpuinfo.so` + `GPUInfoQuery.java` — must call on main thread (AdrenoTools SIGSEGV risk) |
| **Steam** | `libsteamkit_core.so` + `SteamCloudSaveService` + `com.winemu.core.steam_agent` |
| **Epic Games** | `libepickit_core.so` via UniFFI Rust bridge — full EGS catalog/download/cloud-save SDK |
| **Cloud gaming** | VTouch (`cloud_game_sessions` Room DB still wired in `r40/s40/xf1.java`) + Haima HMCP SDK (separate stack, `libhaima_rtc_so.so`) |
| **Retro emulation** | WebView + Nostalgist.js 0.19.0 (`nostalgist.0.19.0.umd.js`) + RetroArch WASM cores (6 platforms) |
| **XGP** | Xbox Game Pass redemption via `xgp.xiaoji.com` + `gamehub-service-dev.xiaoji.com/xgp/exchange` (literals still in `smali_classes4/cpo.smali`) |
| **Controllers** | GameSir SDK (libGamesir.so), JieLi USB OTA (libJieLiUsbOta.so + libjl_ota_auth.so), Nordic BLE DFU (`no.nordicsemi.android.dfu`), RxAndroidBLE 2.x (`com.polidea.rxandroidble2`), custom `com.xiaoji.sdk.bluetooth.le` SDK |
| **Media** | IJK player (Haima fork: libIjkplayer_haima/Ijkffmpeg_haima/Ijksdl_haima) + ExoPlayer Media3 (HLS/offline/image) + AV1 (libaom + libdav1d) + H.265 (libx265 + libde265) + HEIF (libheif) + AVIF (awxkee) |
| **IAP** | Apple IAP receipt verification + WeChat Pay + pending payment retry queue (`db_pending_payment_v1.db` — confirmed in `PayDatabase.java`) |
| **Game platforms** | WinEmu PC + Steam + Epic + GOG + Xbox Cloud Gaming + PlayStation streaming + VTouch — **17 distinct LaunchType values** (corrected from 20; enumerated in `com.xiaoji.egggame.launcher.model.LaunchType`: LaunchOtherApp, OpenUrl, XboxCloudGaming, HidGame, MobilePlay, PsLink, PcLink, PcEmulator, MovingCloudGaming, SteamGameByPcEmulator, EpicGameByPcEmulator, GogGameByPcEmulator, SteamGameDetailByWeb, MobileInstallApp, TypeHid, TypeMobilePlay, Unknown) |
| **Daily sign-in** | `cloud_sign/getActivity` + `cloud_sign/sign` (endpoint owner moved from `xgg.smali` → `rqg.smali` between 6.0.1 and 6.0.4 — same endpoints, R8-letter shuffle) |
| **Push** | Firebase FCM + Huawei HMS Push + MobPush (aggregator for Xiaomi/OPPO/vivo/Honor/Meizu/Unicom) — 6-channel |
| **Auth** | WeChat, QQ, Alipay, Weibo, Google Sign-In, Firebase Auth, phone-number (Alibaba + CMIC SSO), FlyID, MobID, Apple, Epic. SDK classes also present for Facebook, Twitter, Play Games (Firebase Auth providers) |
| **Storage** | MMKV (fast prefs), Room (SQLite via libsqliteJni), DataStore, AVIF (awxkee), VFS layer (libvfs.so) |
| **Compression** | Zstandard JNI (libzstd-jni-1.5.7-4.so) + luben zstd — used for component/container downloads |
| **Crypto** | BouncyCastle (post-quantum `pqc` package present), Rustls platform verifier, Google Tink |
| **Crash reporting** | libfntvcrash.so (Fanttv) + Firebase Crashlytics |
| **HDR** | 4 SPIR-V compute shaders in `assets/shaders/`: GammaOetf, HLG, SMPTE2084 (HDR10), SMPTE428 (D-Cinema) |
| **Compose-specific** | `io.github.alexzhirkevich.compottie` (Lottie for Compose), `androidx.compose.material3.adaptive`, `androidx.privacysandbox.ads` |
| **Fonts** | MiSans VF (core + cardsystem), D-DIN Pro (6 weights: regular, medium, semibold, bold, extrabold, heavy — cardsystem), AlimamaShuHeiTi Bold (cardsystem) |

---

## 3. Native Layer (libs + JNI surface)

### 3.1 Native libraries (arm64-v8a only — 27 total)

Sizes re-measured from the 6.0.4 decompile (`lib/arm64-v8a/`). The set of libraries is identical to 6.0.1; four files saw byte-level changes (see "Δ vs 6.0.1" column).

| Library | Size (6.0.4) | Δ vs 6.0.1 | Purpose |
|---------|---|---|---|
| `libsteamkit_core.so` | 10.9 MB (11,403,128 B) | **+880,416 B (+8.4 %)** | Steam Kit — Steam network/auth/cloud saves (Rust core; major bump in 6.0.4) |
| `libhaima_rtc_so.so` | 7.9 MB (8,273,840 B) | unchanged | Haima RTC — real-time voice/streaming (WebRTC-based) |
| `libaom.so` | 4.6 MB (4,830,288 B) | unchanged | AV1 encoder/decoder (libaom) |
| `libepickit_core.so` | 4.5 MB (4,720,048 B) | **+2,472 B** | EpicKit — Epic Games SDK (UniFFI Rust bridge) |
| `libxserver.so` | 3.8 MB (3,938,672 B) | **+24,848 B** | X11/Xwayland server (Wine display layer) |
| `libcoder.so` | 2.1 MB (2,173,040 B) | unchanged | Custom encoder/decoder |
| `libx265.so` | 1.9 MB (1,963,992 B) | unchanged | H.265/HEVC video encoder |
| `libIjkffmpeg_haima.so` | 1.9 MB (1,909,624 B) | unchanged | FFmpeg (Haima fork — media playback) |
| `libde265.so` | 1.5 MB (1,616,936 B) | unchanged | H.265 software decoder |
| `libheif.so` | 1.4 MB (1,403,400 B) | unchanged | HEIF/HEIC image format support |
| `libsqliteJni.so` | 1.3 MB (1,310,768 B) | unchanged | SQLite JNI (Room database) |
| `libvfs.so` | 947 KB (969,496 B) | unchanged | Virtual filesystem layer (Wine VFS) |
| `libJieLiUsbOta.so` | 881 KB (902,560 B) | unchanged | JieLi USB OTA firmware update |
| `libmmkv.so` | 702 KB (718,248 B) | unchanged | MMKV — fast key-value storage (Tencent) |
| `libdav1d.so` | 697 KB (713,808 B) | unchanged | AV1 hardware-accelerated decoder (dav1d) |
| `libwinemu.so` | 643 KB (658,320 B) | **−25,624 B (−3.7 %)** | WinEmu JNI bridge (core Wine interface). **Shrank** in 6.0.4 — consistent with DirectRendering JNI removal (see § 3.3) |
| `libzstd-jni-1.5.7-4.so` | 590 KB (603,960 B) | unchanged | Zstandard compression JNI (component downloads) |
| `libpns-2.14.17-…_alijtca_plus.so` | 488 KB (499,328 B) | unchanged | Alibaba push notifications |
| `libIjksdl_haima.so` | 450 KB (460,648 B) | unchanged | SDL layer for IJK player |
| `libIjkplayer_haima.so` | 436 KB (446,880 B) | unchanged | IJK media player (Haima) |
| `libgpuinfo.so` | 334 KB (341,944 B) | unchanged | GPU info/detection JNI (main-thread only) |
| `libjnidispatch.so` | 172 KB (176,520 B) | unchanged | JNA (Java Native Access) dispatch |
| `libfntvcrash.so` | 56 KB (57,592 B) | unchanged | Fanttv crash reporter |
| `libGamesir.so` | 20 KB (20,224 B) | unchanged | GameSir controller SDK |
| `libjl_ota_auth.so` | 15 KB (14,968 B) | unchanged | JieLi OTA authentication |
| `libandroidx.graphics.path.so` | 10 KB (10,096 B) | unchanged | AndroidX graphics path rendering |
| `libdatastore_shared_counter.so` | 7 KB (7,112 B) | unchanged | AndroidX DataStore shared counter |

Net: total native-lib payload roughly +880 KB (driven by `libsteamkit_core.so`).

### 3.2 JNI surface — WinEmu native server (`com.winemu.core.server.*`)

All entries below verified against `smali_classes3/com/winemu/core/server/...smali` in the 6.0.4 decompile. **One signature change in `XServer`** in 6.0.4: `setRenderingEnabled(Z)V` is renamed to `setFlipEnabled(Z)V`. Realized/Unrealized hooks remain Java-side (`setOnWindowRealized`/`setOnWindowUnrealized`, now type `Lnw6;`).

| Class | Native methods (with signatures) |
|---|---|
| `com.winemu.core.server.alsaserver.ALSAClient` | `private native boolean downMix16Bit(ByteBuffer)`<br>`private native boolean downMix8Bit(ByteBuffer)`<br>`private native boolean downMixFloat(ByteBuffer)`<br>**Purpose:** ALSA audio downmix from Wine's PCM stream into device-native buffer. |
| `com.winemu.core.server.socket.ClientSocket` | `private native int read(int, ByteBuffer, int, int)`<br>`private native int write(int, ByteBuffer, int)`<br>`private native int recvAncillaryMsg(int, ByteBuffer, int, int)`<br>`private native int sendAncillaryMsg(int, ByteBuffer, int, int)`<br>**Purpose:** AF_UNIX socket I/O including SCM_RIGHTS fd-passing for X11 shared memory. |
| `com.winemu.core.server.socket.XConnectorEpoll` | `private native boolean addFdToEpoll(int, int)`<br>`public static native void closeFd(int)`<br>`private native int createAFUnixSocket(String)`<br>`private native int createEpollFd()`<br>`private native int createEventFd()`<br>`private native boolean doEpollIndefinitely(int, int, boolean)`<br>`private native void removeFdFromEpoll(int, int)`<br>`private native boolean waitForSocketRead(int, int)`<br>**Purpose:** epoll-based event loop hosting the X11 client connector. Hosts the Wine display I/O thread. |
| `com.winemu.core.server.sysvshm.SysVSharedMemory` | `public static native void closeFd(int)`<br>`public static native int createMemoryFd(String, int)`<br>`public static native int createMemoryFile(String, ByteBuffer)`<br>`public static native ByteBuffer createSubBuffer(ByteBuffer, int, int)`<br>`public static native ByteBuffer mapSHMSegment(int, long, int, boolean)`<br>`public static native void unmapSHMSegment(ByteBuffer, long)`<br>**Purpose:** System V SHM segment management (X11 MIT-SHM extension + Wine bitmap transfer). |
| `com.winemu.core.server.XServer` | `public final native boolean sendKeyEvent(int, int, boolean)`<br>`public final native void sendMouseEvent(float, float, int, boolean, boolean)`<br>`public final native void sendTextEvent(byte[])`<br>`public final native void sendTouchEvent(int, int, int, int)`<br>`public final native void sendWindowChange(int, int, int, String)`<br>**`public final native void setFlipEnabled(boolean)` ← renamed in 6.0.4 (was `setRenderingEnabled`)**<br>`public final native void setShmPath(String)`<br>`public final native void setSurfaceFormat(int)`<br>`public final native boolean start(String, String[])`<br>`public final native void startUI()`<br>`public final native void surfaceChanged(Surface)`<br>**Purpose:** X11 input injection + display lifecycle into running Wine process. Realized/unrealized window callbacks fire on Java side via `setOnWindowRealized` / `setOnWindowUnrealized`. |

### 3.3 JNI surface — WinEmu peripherals

Verified against the 6.0.4 smali tree. **Two classes were removed** between 6.0.1 and 6.0.4, and **one new class** was introduced:

- **REMOVED (absorbed into `XServer`)**: `com.winemu.core.DirectRendering` (+ `$Companion`) and `com.winemu.ui.DirectRenderingActivationView` — confirmed deleted via `find` across all six smali dirs (zero hits). The functional toggle is now **`XServer.setFlipEnabled(Z)V`** (the 6.0.1 `setRenderingEnabled` renamed; same JNI, semantically the toggle DR used to own), plus three new XServer members in 6.0.4: `isFlipActive()Z` (reads new static `isFlipActive:Z`), `onFlipStateChanged(Z)V` (static native callback), and `getOnFlipStateChanged()Lpw6;` / `setOnFlipStateChanged(Lpw6;)V` (single-listener registration replacing DR's `Set<Listener>`). The 7-arg `nativeInitialize(2× Surface, 2× SurfaceControl, String, II)V` is gone entirely — the second SurfaceControl overlay path is now handled inside libGameScopeVK (cf. § 26.8). New `setFlipEnabled` call sites: `smali_classes4/tco.smali:452` and `smali_classes4/jk9.smali:839` (these occupied the role of DR's `nativeInitialize` callers in 6.0.1). `HudData.isDirectRenderingEnabled:Z` field retained for HUD-config wire back-compat (still serialized and toString'd at `HudData.smali:643/647/950`; 3 read sites). Consistent with the −25 KB shrink in `libwinemu.so`.
- **REMOVED**: `com.winemu.core.steam_agent.SteamAgentTicketIssuer` (and its `nativeCreateAgentTicket(...)`). Replaced by the next entry.
- **NEW (6.0.4)**: `com.winemu.core.steam_agent.LaunchIntent` — see table.

| Class | Native methods | Purpose |
|---|---|---|
| `com.winemu.core.CabFile` | `private static final native long open(String)`<br>`private static final native void close(long)`<br>`public static final native boolean extract(long, long, String)`<br>`public static final native String getFileName(long)`<br>`private static final native long[] listFiles(long)` | Microsoft CAB archive read/extract (Wine installer payloads) |
| `com.winemu.core.GPUInfoQuery` | `public final native String getGPUDeviceName()`<br>`public final native String getGPUVendor()`<br>`public final native int getGPUDriverVersion()`<br>`public final native int getGPUId()` *(loads libgpuinfo.so, **must call on main thread**)* | GPU detection for AdrenoTools driver-replacement compatibility. **Correction vs prior doc**: there are exactly 4 natives — no `getGPUVersion()` method exists. |
| **`com.winemu.core.steam_agent.LaunchIntent` (NEW in 6.0.4)** | `private final native String nativeCreateLaunchPayload(String, String, String, String, String, String, long, long)` | Builds the Steam launch-payload string consumed by `libsteamkit_core.so` at game-start; supersedes 6.0.1's `SteamAgentTicketIssuer.nativeCreateAgentTicket`. |
| `com.xiaoji.egggame.common.steam_sdk.bridge.SteamBridgeNativeInitializer` | `public final native boolean initPlatformVerifier(Context)` | Initialize Steam's network platform verifier (rustls-platform-verifier integration). Now `boolean`-returning. |
| `com.winemu.core.gamepad.GamepadServerManager` | `private final native long nativeCreate(String)`<br>`private final native void nativeDestroy(long)`<br>`private final native ByteBuffer nativeGetGamepadBuffer(long, int)`<br>`private final native void nativeSetRumbleCallback(long, Object)`<br>`private final native void nativeUpdateGamepadCount(long, int)` | In-game gamepad state via Wine; Java-side `onRumble()` / `close()` callbacks. **Correction vs prior doc**: `nativeCreate` takes a `String` (server socket path) and returns a `long` instance pointer; all other methods take that pointer. |
| `com.xiaoji.sdk.bluetooth.le.Gamesir` | `public static final native int[] decryJoyData(int[])`<br>`public static final native void setBTMac(byte[])` | GameSir hardware-protocol decryption + BT MAC pairing (libGamesir.so) |

**Recognized GameSir controller IDs** (from firmware/protocol routing strings):
`Gamesir-G4pro`, `Gamesir-G6` (+ `Gamesir-G6_OTA`), `Gamesir-T4pro`, `Gamesir-X2` (+ `Gamesir-X2_OTA`), `Gamesir-X3 Type-C`.

---

## 4. Assets

### 4.1 Root-level files (`assets/`)

| File / Pattern | Purpose |
|----------------|---------|
| `hmsrootcas.bks` / `hmsincas.bks` | Huawei HMS root + intermediate CA keystores |
| `grs_sp.bks` | Huawei GRS BKS keystore |
| `grs_sdk_global_route_config_opendevicesdk.json` | HMS device SDK regional routing (push.dbankcloud.com, regions DR1–DR4/CN/ASIA/RU/EU) |
| `grs_sdk_global_route_config_opensdkService.json` | HiAnalytics routing (metrics1-drcn.dt.dbankcloud.cn) |
| `grs_sdk_server_config.json` | HMS GRS base URLs: grs.dbankcloud.com/.cn/.asia/.ru/.eu |
| `com.tencent.open.config.json` | QQ SDK TA telemetry config (`Common_ta_enable: 1`, `Common_frequency: 24`) |
| `PublicSuffixDatabase.list` | OkHttp public suffix list for cookie domain validation |
| `h5_qr_back.png` | QR code background (QQ QR login) |
| `libwbsafeedit{,_64,_x86,_x86_64}` | Weibo SafeEdit native libs (4 ABIs, 12–18 KB each) — bundled as raw assets, loaded dynamically by Weibo SDK |

### 4.2 Vulkan compute shaders (`assets/shaders/`)

4 SPIR-V shaders for HDR tone-mapping (unchanged in 6.0.4):

| File | Purpose |
|------|---------|
| `GammaOetf.comp.spv` | Gamma OETF transfer function |
| `HLG.comp.spv` | Hybrid Log-Gamma HDR |
| `SMPTE2084.comp.spv` | HDR10 / PQ curve (SMPTE ST 2084) |
| `SMPTE428.comp.spv` | SMPTE ST 428 (D-Cinema) |

### 4.3 Baseline profile

| File | Purpose |
|------|---------|
| `assets/dexopt/baseline.prof` | ART baseline profile for startup optimization |
| `assets/dexopt/baseline.profm` | Baseline profile metadata |

### 4.4 composeResources (31 KMP modules)

Each module contains `values[-locale]/strings.commonMain.cvr`, optionally `drawable/`, `font/`, `files/`. Default locale `zh-rCN`. Most modules translated to ja-rJP, pt-rBR, ru-rRU, zh-rCN; cardsystem also has ar + es.

Re-verified `drawable / font / files` presence per module against the 6.0.4 decompile. Identical to 6.0.1.

| Module | drawable | font | files | Notes |
|--------|---|---|---|-------|
| `com.xiaoji.egggame.cardsystem` | yes | yes (AlimamaShuHeiTi-Bold, D-DIN Pro 6w, MiSans VF) | no | Card/game launcher (new in 6.0) |
| `com.xiaoji.egggame.common.download` | no | no | no | Download feature strings |
| `com.xiaoji.egggame.common.game` | yes | no | no | Game entity strings + icons |
| `com.xiaoji.egggame.common.gamepadconnect` | no | no | no | Gamepad pair strings |
| `com.xiaoji.egggame.common.gcm` | no | no | no | GCM/FCM strings (en only) |
| `com.xiaoji.egggame.common.retro_emulators` | yes | no | yes (nostalgist JS + index.html) | Retro emulation (new in 6.0) |
| `com.xiaoji.egggame.common.share` | yes | no | no | Share sheet assets |
| `com.xiaoji.egggame.common.shortcut` | yes | no | no | Launcher shortcut strings |
| `com.xiaoji.egggame.common.vjoy` | no | no | yes (vjoy icons + layouts) | Virtual joystick configs |
| `com.xiaoji.egggame.common.winemu_core` | no | no | no | WinEmu core strings |
| `com.xiaoji.egggame.core` | yes | yes (MiSans VF) | yes (9 UI sound WAVs) | Core UI: navigation sounds, battery icons |
| `com.xiaoji.egggame.features.appupdate` | yes | no | no | Update dialog |
| `com.xiaoji.egggame.features.auth` | yes | no | no | Auth / login |
| `com.xiaoji.egggame.features.cloud` | yes | no | no | Cloud save |
| `com.xiaoji.egggame.features.community` | yes | no | no | Social/community (locale splash images) |
| `com.xiaoji.egggame.features.download` | yes | no | no | Download feature |
| `com.xiaoji.egggame.features.emojipicker` | no | no | no | Emoji picker strings |
| `com.xiaoji.egggame.features.file_selector` | yes | no | no | File picker |
| `com.xiaoji.egggame.features.game` | yes | no | no | Game detail |
| `com.xiaoji.egggame.features.gamepadconfig` | yes | no | no | Gamepad config (zh-rCN drawable variant) |
| `com.xiaoji.egggame.features.gamepadconnect` | yes | no | no | Gamepad pairing screens |
| `com.xiaoji.egggame.features.home` | yes | no | yes (Lottie JSON) | Home screen; locale-specific leaderboard images |
| `com.xiaoji.egggame.features.profile` | yes | no | no | User profile |
| `com.xiaoji.egggame.features.search` | yes | no | no | Search |
| `com.xiaoji.egggame.features.setting` | yes | no | no | Settings |
| `com.xiaoji.egggame.features.splash` | yes | no | yes (splash dir) | Splash (zh-rCN drawable variant) |
| `com.xiaoji.egggame.features.steam` | yes | no | no | Steam feature |
| `com.xiaoji.egggame.features.vjoy` | yes | no | no | Virtual joystick |
| `com.xiaoji.egggame.features.webview` | no | no | no | In-app browser strings |
| `com.xiaoji.egggame.features.winemu` | yes | no | no | WinEmu feature (en + zh variants) |
| `com.xiaoji.egggame.features.zonecode` | yes | no | no | Region/zone code picker |

**Correction vs prior doc**: `com.xiaoji.egggame.features.splash` does ship a `files/splash/` directory (previously listed as `files: no`). `com.xiaoji.egggame.features.home/files/` contains exactly one Lottie payload: `home_land_library_next_page.json`.

### 4.5 Core UI sound effects (`com.xiaoji.egggame.core/files/sound/`)

| File | Trigger |
|------|---------|
| `core_download_game_completed.wav` | Download complete |
| `core_launch_game.wav` | Game launch |
| `focus_boundary.wav` | Gamepad focus reached edge |
| `focus_cancel.wav` / `focus_confirm.wav` / `focus_move.wav` / `focus_tab_switch.wav` / `focus_toggle.wav` | Gamepad navigation |
| `gamepad_connected.wav` | Controller connected |

### 4.6 vJoy bundled assets (`com.xiaoji.egggame.common.vjoy/files/vjoy/`)

```
icons/
├── index.json                          icon pack manifest
└── OfficialStyle01.zip                 official icon pack (default)
layout/
├── index.json                          layout manifest
├── OfficialLayout_gamepad.gtheme       gamepad overlay layout
└── OfficialLayout_keyboard.gtheme      keyboard overlay layout
```

### 4.7 Retro emulator assets (`com.xiaoji.egggame.common.retro_emulators/`)

```
files/emulator/
├── index.html                          WebView shell (JSBridge bridge — see §9.4)
└── nostalgist.0.19.0.umd.js            Nostalgist.js retro emulator engine
drawable/
├── DarkA/B/DPad/L1/L2/R1/R2/Menu/Select/Start/X/Y.png  dark theme buttons (13)
├── LightA/B/DPad/L1/L2/R1/R2/Menu/Select/Start/X/Y.png light theme buttons (12 — no LightC)
├── check_on.svg / check_off.svg
├── feature_emulators_ic_add.xml / _delete.xml / _more.xml
├── ic_import.xml
├── ic_search_empty.png
├── local_retro_game_default.png
└── rom_placeholder.png
```

**Nostalgist system → RetroArch core map:**

| System | LibRetro core |
|--------|--------------|
| gb / gba / gbc | mgba |
| megadrive | genesis_plus_gx |
| nes | fceumm |
| snes | snes9x |

**Bundled GBA demo ROM URLs (gamebrew.org):** `pnakys_v1.0.zip`, `xniq_alpha.zip`, `arcademaniagba.7z`, `astrohawk_advance.zip`. Cores download at runtime from `https://retro-emulator-download.bigeyes.com/retroarch/`.

### 4.8 `unknown/` — embedded files

- **Google Play Services properties:** `play-services-{auth,basement,base,cloud-messaging,fido,measurement-*[6 variants],stats,tasks,ads-identifier,auth-api-phone,auth-base,auth-blockstore,identity-credentials}`
- **Huawei HMS properties:** `HMSCore-{base,baselegacyapi,availableupdate,device,hatool,log,stats,ui}`, `agconnect-core`
- **Firebase / Google properties:** `firebase-{analytics,auth,auth-interop,encoders,encoders-proto,iid-interop,measurement-connector}`, `core-common`, `googleid`, `network-common`, `network-framework-compat`, `network-grs`, `integrity`, `recaptcha`, `hmpublicsuffixes.gz`
- **Protobuf schemas:** `client_analytics.proto` (analytics events), `messaging_event.proto` + `messaging_event_extension.proto` (push), `google/protobuf/{any,api,descriptor,duration,empty,field_mask,java_features,source_context,struct,timestamp,type,wrappers}.proto`
- **`kotlin/`** — Kotlin stdlib metadata (annotation, collections, concurrent, coroutines, internal, ranges, reflect, kotlin.kotlin_builtins)
- **`org/`** — apache, bouncycastle metadata
- **`META-INF/`** — **108 entries** (corrected from 109): ~100 `.version` files for AndroidX + Compose; `services/java.security.Provider` registers `BouncyCastleProvider` + `BouncyCastlePQCProvider`; `services/io.ktor.serialization.kotlinx.KotlinxSerializationExtensionProvider` registers Ktor JSON; `native-image/okhttp/` GraalVM hints. **6.0.4 META-INF/services obfuscated provider names refreshed**: `e6a`, `gh9`, `gm3`, `xve`, `ym` (6.0.1 had `a0a`, `mb9`, `nm`, `ome`, `zi3`).
- **Other:** `DebugProbesKt.bin` (Kotlin coroutine debug probes), `version-control-info.textproto`

---

## 5. Resources

### 5.1 `res/xml/` — configuration files

| File | Purpose |
|------|---------|
| `device_filter.xml` | USB device whitelist (vendor 13623=GameSir 8 PIDs; 1356=Sony 1 PID DualShock 4; 1452=Apple 1 PID MFi controller) |
| `file_paths.xml` | FileProvider paths (`apk_cache`) |
| `filekit_file_paths.xml` | FileKit cache paths |
| `image_share_filepaths.xml` | Image share FileProvider paths |
| `util_code_provider_paths.xml` | BlankJ UtilsFileProvider — broadest scope (see §11.3) |
| `wbsdk_filepaths.xml` | Weibo SDK FileProvider paths |

### 5.2 `res/font/`

| File | Purpose |
|------|---------|
| `roboto_medium_numbers.ttf` | Roboto Medium Numbers — used by legacy XML views for numeric displays |

### 5.3 Layouts

`res/layout/` contains **88** XML layouts (unchanged from 6.0.1). All first-party UI is Compose; XML layouts are confined to third-party SDK screens (Weibo, Alipay, HMCP, Huawei Login, etc.).

### 5.4 Themes & styles → see §20

---
## 6. AndroidManifest

### 6.1 Component counts

| Component type      | Count |
|---------------------|-------|
| Activities          | 35    |
| Services            | 20    |
| Broadcast Receivers | 9     |
| Content Providers   | 10    |
| `uses-permission`   | **45** (up from 44 in 6.0.0 / 43 in 6.0.1) |

### 6.2 Multi-process layout

| Process | Role |
|---------|------|
| Default (`com.xiaoji.egggame`) | Main app, MainActivity, all foreground UI |
| `:wine` | `WineActivity` (Wine game session — `sensorLandscape`, `singleTask`, theme `Theme.WineUI`, separate JVM) |
| `:p0` | `com.mob.pushsdk.impl.MobLReceiver` (MobPush long-poll receiver) |

Note: `EmuFileService` is declared in the default process (not `:wine` as the 6.0.0 doc stated); the only explicit `:wine` process tag in `AndroidManifest.xml` is on `WineActivity`.

### 6.3 Key activities

**App-defined:**
- `com.xiaoji.egggame.MainActivity` — main entry (singleTask, landscape)
- `com.xiaoji.egggame.DeepLinkActivity` — deep-link dispatcher (noHistory, translucent)
- `com.xiaoji.egggame.features.winemu.WineActivity` — Wine game session (`:wine` process)
- `com.xiaoji.egggame.features.winemu.setup.ui.PcGameSetupComposeActivity` — PC game setup
- `com.xiaoji.egggame.features.auth.data.tencentopenapi.TencentEntryActivity` — Tencent auth
- `com.xiaoji.egggame.features.auth.data.tencentopenapi.QqQrcodeEntryActivity` — QQ QR login
- `com.xiaoji.egggame.wxapi.WXEntryActivity` — WeChat OAuth entry
- `com.xiaoji.egggame.wxapi.WXPayEntryActivity` — WeChat Pay result

**Intent-filter schemes (per-activity, corrected — these are NOT all routed through DeepLinkActivity):**

| Scheme/host | Owning activity | Source |
|---|---|---|
| `scheme://epic-auth` and bare `scheme://*` | `DeepLinkActivity` | Epic Games auth callback + generic in-app scheme |
| `tencent102667728://` | `com.tencent.tauth.AuthActivity` | QQ OAuth callback (embeds QQ App ID `102667728`) |
| `genericidp://firebase.auth/` | `com.google.firebase.auth.internal.GenericIdpActivity` | Firebase generic IdP |
| `recaptcha://firebase.auth/` | `com.google.firebase.auth.internal.RecaptchaActivity` | Firebase reCAPTCHA |
| `tbopen://` | (not an exported deep-link — declared inside `<queries>` for package visibility only) | Used to discover Taobao/Alipay apps installed |

**Third-party auth/payment activities (full list, 27):**

| Group | Activities |
|---|---|
| Alipay | `AlipayResultActivity`, `APayEntranceActivity`, `H5AuthActivity`, `H5OpenAuthActivity`, `H5PayActivity`, `PayResultActivity` |
| WeChat | `WXEntryActivity`, `WXPayEntryActivity` (in `com.xiaoji.egggame.wxapi`) |
| QQ / Tencent | `com.tencent.connect.common.AssistActivity`, `com.tencent.tauth.AuthActivity` |
| Weibo | `com.sina.weibo.sdk.share.ShareTransActivity`, `com.sina.weibo.sdk.web.WebActivity` |
| Firebase | `GenericIdpActivity`, `RecaptchaActivity` |
| Google Sign-In | `SignInHubActivity`, `GoogleApiActivity` |
| HMS Push | `com.huawei.hms.support.api.push.TransActivity` |
| MobID | `com.mob.id.MobIDActivity` |
| FlyID | `cn.fly.id.FlyIDActivity` |
| MobPush | `com.mob.pushsdk.impl.MobPushActivity` |
| Phone-auth (Alibaba) | `LoginAuthActivity`, `AuthWebVeiwActivity`, `PrivacyDialogActivity` |
| Play Core | `PlayCoreDialogWrapperActivity` |
| AndroidX Credentials | `HiddenActivity`, `IdentityCredentialApiHiddenActivity` |
| Compose UI tooling | `androidx.compose.ui.tooling.PreviewActivity` (debug-only) |
| BlankJ utilcode | `UtilsTransActivity`, `UtilsTransActivity4MainProcess` |

### 6.4 Services

**App-defined:**
- `com.xiaoji.egggame.game.domain.install.PcEmulatorAutoUnzipService` — foreground (dataSync)
- `com.xiaoji.egggame.common.winemu.service.EmuFileService` — emulator file management
- `com.xiaoji.egggame.common.steam.cloud.SteamCloudSaveService` — Steam cloud saves
- `com.xiaoji.egggame.common.gamepadota.ble.gamesirg6.dfu.G6DfuService` — GameSir G6 OTA

**Third-party (16 total):**

| Group | Services |
|---|---|
| Firebase | `ComponentDiscoveryService`, `FirebaseMessagingService` |
| Google measurement | `AppMeasurementService`, `AppMeasurementJobService`, `RevocationBoundService`, `metadata.ModuleDependencies` |
| Google datatransport (FCM/Analytics) | `TransportBackendDiscovery`, `JobInfoSchedulerService` (paired with `AlarmManagerSchedulerBroadcastReceiver`) — note: previously mislabeled as Alibaba in earlier passes |
| Huawei AGConnect | `core.ServiceDiscovery` |
| MobPush | `MobPushJobService`, `plugins.fcm.FCMFirebaseInstanceIdService` |
| MobID | `MobIDService` |
| FlyID | `FlyIDService` |
| AndroidX Credentials | `CredentialProviderMetadataHolder` |
| AndroidX Room | `MultiInstanceInvalidationService` |
| BlankJ utilcode | `MessengerUtils$ServerService` |

### 6.5 Broadcast receivers (9)

- `com.xj.muugi.shortcut.broadcast.NormalCreateBroadcastReceiver` — shortcut creation
- `com.xj.muugi.shortcut.special.AutoCreateBroadcastReceiver` — auto-shortcut creation
- `com.mob.pushsdk.impl.MobLReceiver` (`:p0` process)
- `com.mob.pushsdk.impl.NotifyActionReceiver`
- `com.mob.pushsdk.plugins.fcm.FCMFireMessagingReceiver`
- `com.google.firebase.iid.FirebaseInstanceIdReceiver`
- `com.google.android.gms.measurement.AppMeasurementReceiver`
- `com.google.android.datatransport.runtime.scheduling.jobscheduling.AlarmManagerSchedulerBroadcastReceiver`
- `androidx.profileinstaller.ProfileInstallReceiver`

### 6.6 Content providers (10)

- `androidx.core.content.FileProvider` — general file sharing
- `com.blankj.utilcode.util.UtilsFileProvider` — utility file provider
- `com.sina.weibo.sdk.content.FileProviderV2` / `WeiboSDKFileProvider` — Weibo sharing
- `io.github.vinceglb.filekit.dialogs.FileKitFileProvider` — system file picker
- `com.google.firebase.provider.FirebaseInitProvider` — Firebase auto-init
- `androidx.startup.InitializationProvider` — AndroidX Startup
- `org.jetbrains.compose.resources.AndroidContextProvider` — Compose resources
- `com.mob.MobProvider` — MobPush init
- `cn.fly.FlyProvider` — FlyID init

### 6.7 Permissions (45 total)

| Category | Permissions |
|---|---|
| Network | `INTERNET`, `ACCESS_NETWORK_STATE`, `ACCESS_WIFI_STATE`, `CHANGE_NETWORK_STATE` |
| Storage | `MANAGE_EXTERNAL_STORAGE`, `READ/WRITE_EXTERNAL_STORAGE`, `WRITE_MEDIA_STORAGE`, `READ_MEDIA_AUDIO/IMAGES/VIDEO`, `READ_MEDIA_VISUAL_USER_SELECTED` |
| Foreground / process | `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_DATA_SYNC`, `WAKE_LOCK`, `KILL_BACKGROUND_PROCESSES`, `VIBRATE`, `MODIFY_AUDIO_SETTINGS`, `WRITE_SETTINGS` |
| Hardware | `BLUETOOTH_SCAN` (neverForLocation), `BLUETOOTH_ADVERTISE`, `BLUETOOTH_CONNECT`, **`BLUETOOTH`**, **`BLUETOOTH_ADMIN`** (both legacy perms newly re-added in 6.0.4 — needed for min-SDK 29 path), `NEARBY_DEVICES`, `android.hardware.usb.host`, `android.hardware.bluetooth` (optional), `android.hardware.bluetooth_le` (required), OpenGL ES 2.0 (required) |
| Identity / auth | `USE_BIOMETRIC`, `USE_FINGERPRINT`, `READ_PHONE_STATE`, `POST_NOTIFICATIONS`, `REQUEST_INSTALL_PACKAGES` |
| Advertising / analytics | `ACCESS_ADSERVICES_AD_ID`, `ACCESS_ADSERVICES_ATTRIBUTION`, `com.google.android.gms.permission.AD_ID`, `READ_GSERVICES`, `BIND_GET_INSTALL_REFERRER_SERVICE` |
| Launcher shortcuts | `INSTALL_SHORTCUT`, `UNINSTALL_SHORTCUT`, `READ_SETTINGS`, `WRITE_SETTINGS` (com.android.launcher + com.bbk.launcher2) |
| App-defined | `com.xiaoji.egggame.permission.C2D_MESSAGE`, `com.xiaoji.egggame.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`, `com.google.android.c2dm.permission.RECEIVE` |
| Vendor-launcher | `com.android.permission.GET_INSTALLED_APPS` (introduced in 6.0) |

**Delta from 6.0.1 → 6.0.4:** identical activity/service/receiver/provider lists (35/20/9/10); permissions grew by +2 (`BLUETOOTH`, `BLUETOOTH_ADMIN`), correlated with `minSdkVersion` dropping 31 → 29.

---
## 7. DEX / Java Package Map

### 7.1 DEX content summary

Class counts include both named-package classes and R8 letter-renamed classes (e.g. `Lj7o;`, `Lw43;`) that live at the smali root.

| DEX file       | Smali classes | Primary content                          |
|----------------|---------------|------------------------------------------|
| classes.dex    | 10,523        | androidx, android, alipay, blankj, bumptech, cmic, github, google (accompanist + datatransport + gms + protobuf), `com.xiaoji.egggame` Application entry classes (AndroidApp/BaseAndroidApp/MainActivity/DeepLinkActivity), R8 letter classes |
| classes2.dex   | 6,833         | `com.google` (GMS, Firebase, gson, protobuf, common, crypto, errorprone), `com.haima.hmcp` |
| classes3.dex   | 7,816         | `com.winemu`, `com.xiaoji.egggame.cardsystem/cloud`, vendor SDKs (heytap, hihonor, huawei, jieli, krly, mcs, meizu, mob, mobile.auth, multiplatform.webview, netcheck, nirvana, polidea, qiniu, radzivon, sina.weibo, sun.jna, tencent, unicom, vivo.push) |
| classes4.dex   | 12,451        | `com.xiaoji.egggame` (common/, features/, core/, game/), R8 letter classes |
| classes5.dex   | 10,748        | `com.xiaoji.egggame` (home, retro_emulators, launcher, wxapi), `com.xiaoji.sdk.bluetooth`, `com.xiaomi.push`, `com.xj.muugi`, io.github (alexzhirkevich + vinceglb), io.ktor, io.reactivex, kotlin.jvm, no.nordicsemi, okhttp3, okio, org.apache, org.bouncycastle |
| classes6.dex   | 5,395         | `uniffi.epickit_core`, `org.webrtc`, `org.chromium`, `org.hmwebrtc`, `org.koin`, `org.msgpack`, `org.rustls`, `org.yaml`, `org.json`, `org.jetbrains`, `tv.haima` |
| **TOTAL**      | **53,766**    |                                          |

### 7.2 `com.xiaoji.egggame.*` core package tree

```
(top-level, in smali/com/xiaoji/egggame/)
  AndroidApp.smali              Application subclass (see § 8.1)
  BaseAndroidApp.smali          Application onCreate init body
  MainActivity.smali            Launcher activity
  DeepLinkActivity.smali        scheme:// + epic-auth deep-link entry

cardsystem/
  ui/cards/             card data models (43-field Card + supporting — see §9.7)
  ui/cards/data/

cloud/
  data/local/           CloudGameDatabase, CloudGameSessionDao, CloudGameSessionEntity
  data/remote/          cloud game API models

common/
  bi/database/dao+entity/  Business intelligence / analytics DB
  epic/
    downloader/         EpicKit download management + recovery governance
    storage/dao+entity/ Epic game local storage (Room)
  gamepadconnect/
    data/dto/           gamepad pairing DTOs
    flow/               connection state machine
    usb/                USB gamepad detection
  gamepadota/
    ble/gamesirg6/dfu/  GameSir G6 BLE DFU service
    ble/jieli/          JieLi BLE OTA
    usb/transport/      USB OTA transport
  steam/
    branch/             Steam branch management
    cloud/              SteamCloudSaveService
    core/               Steam auth core
    data/bean+entity+repository/  Steam data models
    models/app/         Steam app models
    utils/              Steam utilities
  steam_sdk/
    bridge/             Steam SDK JNI bridge
    impl/               SDK implementation
    model/              SDK models
  ui/vjoy/model/         VJoy UI models (incl. ui/vjoy/model/keygroup/) — see §9.8
  vjoy/data/             VJoy data layer
  winemu/
    bean/                WinEmu data beans
    data/bean+event+repository/  WinEmu data layer
    engine/              Wine engine interface
    hud/                 HUD data management (HUDConfig serializer)
    loadingtips/         loading screen tips
    service/             EmuFileService
    settings/model/      WinEmu settings models
    trace/collectors/    performance trace collection
    utils/               WinEmu utility helpers

core/
  android/base/          Android base classes (GamepadInputHostActivity)
  data/                  core data layer
  database/dao+entity/   core Room database
  device/battery/        battery state management
  device/entity/         device info entities
  domain/
    activitytask/model/  in-app task system
    base/                base domain classes
    bi/                  analytics domain
    community/model/     community domain
    device/model/        device domain
    hometab/model/       home tab configuration
    id/                  user identity domain
    leaderboard/model/   leaderboard domain
    model/steam/         Steam domain models
    search/model/        search domain
    unzip/               unzip domain
    upgrade/model/       app update domain
    vjoy/model/          VJoy domain models
  events/                app-wide event bus
  i18n/                  internationalization
  navigation/            AppNavKey + 79 inner-class destinations (see § 7.6)
  navigation/model/      gamepad / gamepadota navigation models
  network/model/         full DTO tree (auth, baseinfo, cloud, device, feedback,
                         profile, setting, upgrade, upload, vjoy, vtouch, zonecode) — see §10
  network/token/         JWT token management
  util/file+jwt+serialization/  file/jwt/serialization utilities

features/
  auth/data/tencentopenapi/   QQ/Tencent OAuth
  file_selector/platform/     platform file picker
  pay/data+database/          in-app payment (Room)
  profile/model/enums/        profile enums
  vjoy/ui/main/base/          VJoy main UI
  webview/data/activitytask/  webview tasks
  webview/ui/webview/         webview UI hosts
  winemu/
    data/remote/              WinEmu API layer
    di/model/scheme/          dependency injection + setting schemes
    input/                    input handling
    launcher/                 game launcher
    perf/                     performance overlay + telemetry
    setup/ui/                 PcGameSetupComposeActivity
    ui/gameSetting/scheme/    in-game settings UI + scheme models

game/
  data/remote/              game API (including CloudGamePlayTimeEntity)
  database/dao+entity/      local game DB
  di/model/game+launchMethod/  launchMethod + game DI models
  domain/install/           PC game installation (PcEmulatorAutoUnzipService)
  domain/mobileimport/      mobile game import
  domain/model/             game domain models
  model/                    game-level models

home/
  data/remote/              home feed API
  domain/model/             home domain models
  ui/tabs/home+play/        home/play tab screens

launcher/interceptor+model/  launcher interceptor logic

retro_emulators/
  data/local/               RetroGameDatabase + DAOs
  data/remote/              RetroGameStatsReArgs, RetroGameStatsEntity (API)
  domain/model/             RetroGameCheat
  ui/                       RetroEmulatorWebView (Compose + WebView hybrid)
  util/setting/             retro game settings

wxapi/                      WeChat OAuth + Pay entry activities
```

**Top packages by class count (6.0.4):**

| Smali path | Classes |
|---|---:|
| `common/winemu/bean/` | 155 |
| `common/ui/vjoy/model/` | 99 |
| `core/navigation/` (incl. 79 AppNavKey route serializers) | 80 |
| `common/epic/downloader/` | 74 |
| `common/steam_sdk/impl/` | 61 |
| `common/steam_sdk/bridge/` | 60 |
| `game/data/remote/` | 42 |
| `cloud/data/remote/` | 41 |
| `features/winemu/perf/` | 27 |
| `core/database/dao/` | 26 |

### 7.3 `com.winemu.*` package

Structure was reshuffled at 6.0.4. `core/server/` gained `XServer.smali` (moved out of `ui/`), `core/` gained top-level `BottleMetadata.smali`, `CabFile.smali`, and `GPUInfoQuery.smali`, and `core/steam_agent/` gained `LaunchIntent.smali` while losing `SteamAgentTicketIssuer.smali`. The `ui/` package no longer contains `DirectRendering`, `DirectRenderingActivationView`, `StatusData`, `TapHandler`, or `XServer`.

Full tree under `smali_classes3/com/winemu/`:

```
com.winemu.core/
  BottleMetadata        (new in 6.0.4 — bottle/prefix descriptor)
  CabFile               (new in 6.0.4 — .cab archive handler)
  GPUInfoQuery          (new in 6.0.4 — GPU probe helper)
  gamepad/              GamepadServerManager
  input/                TapHandler$InitPoint (moved from ui/)
  server/
    XServer             (moved from ui/)
    alsaserver/         ALSAClient (3 native methods — see §3.2)
    environment/
      plugins/          NetworkInfoUpdatePlugin$start$1
    socket/             ClientSocket, XConnectorEpoll (see §3.2)
    sysvshm/            SysVSharedMemory (see §3.2)
  steam_agent/          AgentCmd, LaunchIntent (new in 6.0.4),
                        StatusData (moved from ui/)
                        — SteamAgentTicketIssuer removed at 6.0.4
  trans_layer/          Box64Config, FEXConfig, FEXConfigData, FEXJsonConfig,
                        LocalizedName, TemplateBoxConfig(+Kt), TemplateFexConfig(+Kt),
                        TemplateConfigType (4 presets: Compatibility/Stable/Performance/Extreme)
  utils/                EnvVars (only named class)

com.winemu.openapi/     a, b, c, d, e, f (obfuscated), CASEffect,
                        Config (GPUDriver/Resolution/SteamGameInfo),
                        GPUConfig, HDREffect

com.winemu.ui/          BootLogView, HUDConfig, HUDLayer,
                        UnifiedHUDView, X11View
                        — DirectRendering/DirectRenderingActivationView removed at 6.0.4;
                          StatusData/TapHandler/XServer relocated to core/
```

**EnvVars at 6.0.4:** `com.winemu.core.utils.EnvVars` is now a `LinkedHashMap`-backed Parcelable `Iterable<String>` (implements `Lphb;`) — the previously hard-coded supported-key allowlist has been removed from the class body. The Box64 / FEX-Emu key strings still appear elsewhere in the APK (notably `com.winemu.core.trans_layer.FEXConfig` for FEX keys), but `EnvVars` itself no longer enumerates them.

**Box64 supported env vars** (referenced across `com.winemu.core.trans_layer.*` + serializers):
`CPUNAME`, `CPUTYPE`, `AVX`, `MMAP32`, `UNITY`, `X11GLX`, `IGNOREINT3`, `NOBANNER`, `NORCFILES`, `RDTSC_1GHZ`, `DYNACACHE`, `DYNACACHE_FOLDER`, `DYNACACHE_MIN`, `DYNAREC`, `DYNAREC_ALIGNED_ATOMICS`, `DYNAREC_BIGBLOCK`, `DYNAREC_CALLRET`, `DYNAREC_DF`, `DYNAREC_DIRTY`, `DYNAREC_DIV0`, `DYNAREC_FASTNAN`, `DYNAREC_FASTROUND`, `DYNAREC_FORWARD`, `DYNAREC_NATIVEFLAGS`, `DYNAREC_PAUSE`, `DYNAREC_SAFEFLAGS`, `DYNAREC_STRONGMEM`, `DYNAREC_VOLATILE_METADATA`, `DYNAREC_WAIT`, `DYNAREC_WEAKBARRIER`, `DYNAREC_X87DOUBLE`

**FEX-Emu supported env vars** (declared in `com.winemu.core.trans_layer.FEXConfig`):
`FORCESVEWIDTH`, `HALFBARRIERTSOENABLED`, `HIDEHYPERVISORBIT`, `HOSTFEATURES`, `MAXINST`, `MEMCPYSETTSOENABLED`, `MONOHACKS`, `MULTIBLOCK`, `OUTPUTLOG`, `PROFILESTATS`, `SILENTLOG`, `SMALLTSCSCALE`, `SMCCHECKS`, `TSOENABLED`, `VECTORTSOENABLED`, `VOLATILEMETADATA`

### 7.4 `com.winemu.openapi.Config` — per-game Wine launch config (from `Config.java`)

Fields: `runMode`, `exePath`, `gameRootDir`, `virtualContainer`, `resolution (width/height)`, `gpuDriver (isCustomDriver + customPath)`, `gpuConfig (vendorId + deviceId)`, `gpuMemoryLimitInMB`, `sysMemoryLimitInMB`, `hostCoreLimit`, `hostCoreMask`, `audioDriver`, `box64Config`, `fexConfig`, `bootParams`, `dllOverrides`, `envVars`, `localeCode`, `steamAppId`, `steamGameInfo`, `winedebugParams`, `surfaceFormat`, `logPath`, `inGameHud`, `enableESync`, `enableMangoHUD`, `enableOnScreenKeyboard`, `enableRDCDebug`, `enableWinMonitor`, `enableLogHttpServer`, `disableReshade`, `disableWM`, `bypassAVDecode`, `debugMode`.

**Post-processing effects:**
- `CASEffect.sharpness` — Contrast Adaptive Sharpening strength
- `HDREffect(HDRPower, radius1, radius2)` — HDR tone-mapping overlay

### 7.5 Surviving `com.xj.*` classes (2 only)

```
com.xj.muugi.shortcut.broadcast.NormalCreateBroadcastReceiver
com.xj.muugi.shortcut.special.AutoCreateBroadcastReceiver
```

Both still ship as receivers under `smali_classes5/com/xj/muugi/shortcut/`. All other `com.xj.*` classes (winemu utils, common entity, etc.) have moved to `com.xiaoji.egggame.*`.

### 7.6 Compose nav routes (`AppNavKey`) — 79 serializable destinations

`com.xiaoji.egggame.core.navigation.AppNavKey` declares 79 inner-class destinations, each with a generated `$$serializer` companion in the same package. (6.0.0/6.0.1 reported 119 grouped routes; the 6.0.0 figure mixed serialized parcelable destinations with non-`AppNavKey` route names — e.g. Home, Splash, HomeProfile, Settings sub-screens, GamepadTest screens, VJoyTest, XGP/Redeem — which in 6.0.4 either live in separate route registries or were consolidated.) The 79 surviving parcelable destinations:

```
App / meta:    AppVersionDialog, Search, ZoneCodePicker
Auth:          AuthLoginAll, AuthLoginSmsOrEmail, AuthAliOneKey
Profile:       ProfileEditAll, PushActivityPage
Game:          GameDetail, GameNewWeb, LocalGameDetail, ProductWiki
PC / WinEmu:   PcGameSetup, PcGameCompatibilitySetting, PcGameComponentDependence,
               PcGameDeveloperOptions, PcGameGeneralSetting, PcGameGraphicsSetting (new in 6.0.4),
               PcGameKeymap, PcGameRestoreSetting, PcGameSchemeDetail, PcGameSchemeEditor,
               PcGameSchemeTranslationParameters, PcGameSettingEntrance,
               PcGameSteamSetting, PcGameTranslationParameters,
               PcSchemeHome, PcImportEdit, LaunchConfig, LaunchConfigSelection,
               WinEmuEnvList, SwitchModeDialog
Steam:         SteamLogin, SteamLoginDeviceConfirmation, SteamLoginGuardVerification
Cloud gaming:  CloudGameDetail, CloudSetting, CloudNormalSetting,
               CloudContorlSetting, CloudOrderCenter, CloudRechargeCenterSheet
Gamepad:       GamepadConfigEntry, GamepadConfigSetting, GamepadCoolerSetting,
               GamepadDeviceConnectPage, GamepadFunctionSetting,
               GamepadKeyMapping, GamepadKeyMappingP1, GamepadKeySetting,
               GamepadKeySettingP1, GamepadLightSetting, GamepadMappingTarget,
               GamepadMotionSetting, GamepadOta, GamepadTriggerSetting,
               GamepadVibrationSetting, OtaSelectPage, KeyboardMappingTarget,
               CoolerSettingDialog
VJoy:          VJoyMain, VJoyMainSheet, VJoyEdit, VJoyIconFolder,
               VJoyHudMain, VJoyHudEdit, VJoyHudIconFolder
Retro:         RetroEmulatorPlayer, RetroGameDetail, RetroGameArchive,
               RetroGameCheatAdd, RetroGameCheatList, RetroGameImport,
               RetroGameSetting
Community:     CommunityDialog, CommunityCodeDialog
Downloads:     DownloadConfirmation
Utility:       FileSelector, EmojiPicker, WebView
```

New in 6.0.4: `PcGameGraphicsSetting`. Dropped from the parcelable set vs. the 6.0.0/6.0.1 listing: Home, HomeProfile, HomeTabPortrait, Splash, VerifyId, DeleteAccount, ProfileCenter, SettingContent, SettingTheme, AboutSettings, HelpSettings, PrivacySettings, NotificationSettings, FeedbackSettings, FeedbackHistorySettings, StorageManager, DeveloperDebug, NetworkDebug, ScreenAdaptDebug, ScreenRatioSetting, DeviceInfoSettings, MyDevicePage, MobileGameImport, CustomRecommendation, SteamProfileScreen, SteamSwitchAccountScreen, WinEmuEnvSetting, CloudRechargeCenter, GamepadCalibrationGuide, GamepadTestBig, GamepadTestInputAll, GamepadTestKeyboard, GamepadTestP1, GamepadTestTelescopic, VJoySetting, VJoyTest, DownloadManagerPage, XgpRedemption, CommonRedemption, RedeemCenter, RedemptionCenter. The string identifiers for several of these (e.g. `FeedbackSettings`, `NotificationSettings`, `VJoyTest`, `GamepadTestBig`) still appear in R8 letter-named classes (`smali_classes4/bc0.smali`, `kd0.smali`, `xh0.smali`, etc.) so the screens themselves may still exist but are routed through a different mechanism than `AppNavKey`'s parcelable enum.

---

## 8. Application Entry Points

### 8.1 Application class — `AndroidApp` extends `BaseAndroidApp`

Manifest declares `android:name="com.xiaoji.egggame.AndroidApp"`. Both classes ship at `smali/com/xiaoji/egggame/` (i.e. inside `classes.dex`):

- `AndroidApp.smali` — 96 lines. Concrete subclass; constructor instantiates two `Lj0;` lambdas wired into `xrl` lazy holders (R8-renamed factories).
- `BaseAndroidApp.smali` — 3,543 lines. Holds the real `onCreate()` init body.
- `MainActivity.smali` — 1,763 lines. Extends `com.xiaoji.egggame.core.android.base.GamepadInputHostActivity`.
- `DeepLinkActivity.smali` — 4,162 lines. Handles `scheme://` + `scheme://epic-auth` intents.

### 8.2 Init sequence (`BaseAndroidApp.onCreate`, smali line numbers from 6.0.4)

| Step | smali line | Action |
|---|---|---|
| 1 | 247  | `MobPush.addPushReceiverInMain(...)` invoked from helper path (registered before main flow continues) |
| 2 | 384  | `FirebaseApp.initializeApp(this)` — Firebase first (Crashlytics + Analytics auto-init via `FirebaseInitProvider` initOrder=100) |
| 3 | 470  | `Application.registerActivityLifecycleCallbacks(...)` — 1st lifecycle observer |
| 4 | 535-539 | `MMKV.initialize(this, MMKVLogLevel.LevelInfo)` |
| 5 | 562  | `registerActivityLifecycleCallbacks(...)` — 2nd lifecycle observer |
| 6 | 2057 | `ApplicationDSLExtKt.startKoinWith(...)` — Koin DI (modules sourced from prebuilt list + inline `module$default` factories + `us2`-style feature DI; total app modules still ≈ 70–80) |
| 7 | 2281+2360 | Coil singleton image loader (`KoinPlatformTools.INSTANCE` → `h00.u(...)`) |
| 8 | 2844 | `registerActivityLifecycleCallbacks(...)` — 3rd lifecycle observer (UI state tracker) |
| 9 | 2883–3331 | EGL14 GPU renderer probe: `eglGetDisplay` (line 2883) → `eglInitialize` (2965) → `eglChooseConfig` (3061) → `eglCreateContext` (3148) → `eglCreatePbufferSurface` (3200) → `eglMakeCurrent` (3232) → `glGetString(VENDOR/RENDERER)` (3295, 3304) → `eglDestroySurface`/`Context`/`Terminate` cleanup (3321, 3326, 3331) |

Imports tied to init order: `android.opengl.{EGL14, EGLConfig, EGLContext, EGLDisplay, EGLSurface, GLES20}`, `com.google.firebase.FirebaseApp`, `com.mob.pushsdk.MobPush`, `com.tencent.mmkv.{MMKV, MMKVLogLevel}`, `org.koin.plugin.module.dsl.ApplicationDSLExtKt`, `org.koin.mp.KoinPlatformTools`.

### 8.3 `MainActivity` (com.xiaoji.egggame)

- Extends `com.xiaoji.egggame.core.android.base.GamepadInputHostActivity` (gamepad/joystick input base)
- Screen-orientation management via SharedPreferences
- **Deep-link intent extras** (10 keys observed in `MainActivity.smali`/`DeepLinkActivity.smali`): `app_nav_target` (route name), `app_nav_game_id`, `app_nav_game_type`, `app_nav_steam_app_id`, `app_nav_epic_app_name`, `app_nav_source_type`, `app_nav_source_id`, `app_nav_source_slug`, `app_nav_auto_start_game`, `app_nav_return_to_wine`. The 11th key from the 6.0.0/6.0.1 set, `app_nav_launch_type`, still ships in the APK (string only appears in R8 letter class `smali_classes5/zi7.smali`) and is no longer read directly from the entry activities.

### 8.4 ContentProviders (manifest declaration order)

| Authority suffix | Class | Notes |
|---|---|---|
| `com.mob.MobProvider` | `com.mob.MobProvider` | MobPush multiprocess provider |
| `fileprovider` | `androidx.core.content.FileProvider` | shares `file_paths.xml` |
| `cn.fly.FlyProvider` | `cn.fly.FlyProvider` | Fly SDK multiprocess provider |
| `utilcode.fileprovider` | `com.blankj.utilcode.util.UtilsFileProvider` | Blankj utilcode |
| `firebaseinitprovider` | `com.google.firebase.provider.FirebaseInitProvider` | `directBootAware="true"`, `initOrder=100` — runs before `Application.onCreate` |
| `resources.AndroidContextProvider` | `org.jetbrains.compose.resources.AndroidContextProvider` | Compose-Multiplatform resources |
| `androidx-startup` | `androidx.startup.InitializationProvider` | AndroidX Startup |
| `filekit.fileprovider` | `io.github.vinceglb.filekit.dialogs.FileKitFileProvider` | filekit |
| `fileprovider` (Weibo) | `com.sina.weibo.sdk.content.FileProviderV2` | Weibo SDK |
| `wbsdk.fileprovider` | `com.sina.weibo.sdk.content.WeiboSDKFileProvider` | Weibo SDK |

### 8.5 Deep-link `intent-filter` scheme/host pairs

| Scheme | Host | Owning activity |
|---|---|---|
| `scheme` | `epic-auth` | `com.xiaoji.egggame.DeepLinkActivity` |
| `scheme` | (any) | `com.xiaoji.egggame.DeepLinkActivity` (catch-all) |
| `tencent102667728` | — | `com.tencent.tauth.AuthActivity` (Tencent OAuth) |
| `tbopen` | — | (queries-only intent, Taobao open) |
| `genericidp` | — | androidx CredentialManager IDP callback |
| `recaptcha` | — | Play Integrity / reCAPTCHA callback |

The `MainActivity` filter is `MAIN`/`LAUNCHER` only (no scheme). `wxapi.WXEntryActivity` and `wxapi.WXPayEntryActivity` handle WeChat OAuth/Pay via package-name affinity (no scheme filter). `cn.fly.id.FlyIDActivity` registers an additional filter used by the Fly SDK.

---
## 9. Subsystems

### 9.1 WinEmu (Wine emulation core)

#### 9.1.1 Component categories (live, from on-device registry)

`EnvLayerEntity.type` integer mapping:

| `entity.type` | Category | Examples |
|---|---|---|
| `1` | Translator (FEX + Box64) — disambiguated by `name` prefix downstream | `Fex_*`, `Box64-*` |
| `2` | GPU driver | `Adreno_*`, `turnip_*`, `qcom-*` |
| `3` | DXVK | `dxvk-*`, `wined3d8.0` |
| `4` | VKD3D | `vkd3d-proton-*` |
| `5` | Per-game settings packs **+ Steam agents** | `Hzd_Settings`, `Cyberpunk`, `steamagent`, `SteamAgent2` |
| `6` | Runtime dependency / `isBase=true` | `vcredist*`, `cjkfonts`, `directshow`, ... |
| `7` | Steam client (`STEAMCLIENT`, retained for legacy entries) | `steam_client_*` |
| `8` | Steam client runtime (preferred for 6.0.x) | `steam_client_0403` |

`ComponentType` enum (com.xiaoji.egggame.common.winemu.bean) — **8 entries** (corrected from 7): `TRANSLATOR(1)`, `GPU(2)`, `DXVK(3)`, `VKD3D(4)`, `GENERAL(5)`, `DEPENDENCY(6)`, `STEAMCLIENT(7)`, `STEAMCLIENT_RUNTIME(8)`. `STEAMCLIENT(7)` carries an `Li94;` (Deprecated) runtime annotation but is still valued at `0x7` and is still referenced by old DB rows.

`EnvLayerEntity.getType()` returns boxed `Integer` (nullable). `isBase=true` is set only when `entity.type==6` (verified at `w43.smali:1639` — see § 9.1.10). The `Translator` enum (`FEX="1"`, `Box64="2"`) is **separate** from `EnvLayerEntity.type`; both translators share `entity.type=1`, the enum value selects the backend in container settings.

#### 9.1.2 Translator settings (per-game)

All translator setting classes live directly under `smali_classes4/com/xiaoji/egggame/common/winemu/bean/` (not a `setting/` sub-package). All extend `TranslationSetting` (abstract base) and implement `SwitchableSetting` where applicable.

**Box64 settings:**

| Class | Type | Values |
|-------|------|--------|
| `AlignedAtomicsSetting` | switch | on/off |
| `BigBlockSetting` | option | 0–3 |
| `Box64AVXSetting` | option | 0–2 |
| `CallRetSetting` | switch | on/off |
| `CpuTypeSetting` | option | 0–1 |
| `DFSetting` | switch | on/off |
| `DirtySetting` | option | 0–2 |
| `DIV0Setting` / `DynarecSetting` / `FastNanSetting` / `FastRoundSetting` / `IgnoreINT3Setting` / `NativeFlagsSetting` | switch | on/off |
| `PauseSetting` | option | 0–3 |
| `RDTSC1GHZSetting` / `WaitSetting` / `X87DoubleSetting` / `VolatileMetadataBox64Setting` | switch | on/off |
| `SafeFlagsSetting` | option | 0–2 |
| `StrongMemSetting` | option | 0–3 |
| `WeakBarrierSetting` | option | 0–2 |

**FEX settings:**

| Class | Type | Values |
|-------|------|--------|
| `HalfBarrierTSOEnabledSetting` / `HideHypervisorBitSetting` / `MemcpySetTSOEnabledSetting` / `MonoHacksSetting` / `MultiblockSetting` / `SmallTSCScaleSetting` / `TSOEnabledSetting` / `VectorTSOEnabledSetting` / `VolatileMetadataSetting` / `X87ReducedPrecisionSetting` | switch | on/off |
| `MaxInstSetting` | input | numeric |
| `SMCChecksSetting` | option | "none", "mtrack", "full" |

**Translator config holders:**

| Class | Notes |
|-------|-------|
| `Box64TranslatorConfig` | Implements `ITranslatorConfig`; serialized via `$$serializer`; aggregates all Box64 settings |
| `FEXTranslatorConfig` | Implements `ITranslatorConfig`; serialized via `$$serializer` |
| `TranslationSetting` | Abstract base — options, defaults, types |
| `TranslatorConfigs` | Composite: `box64` + `fex` (serializable) |
| `TranslatorTabItem` | `tabs` (List\<ITranslatorConfig\>) + `updateFlag` |
| `BoxOptions` / `FexOptions` | Singletons holding option arrays for dropdowns |
| `Translator` enum | `Box64("2", "X64")`, `FEX("1", "X64")` — **adds `frameworkName` + `mode` fields in 6.0.4** |
| `TranslatorConstant` | Preset config names + IDs (custom & game-preset companions inlined as `$2$1` synthetics) |
| `WinEmuTranslationConfigEntity` | **New in 6.0.4** static holder: `ID_PREFIX="local_"` (marker for user-imported translator configs) |

#### 9.1.3 Repo / component beans

`EnvLayerEntity` instance fields (**21 — corrected from 19 in old doc**): `blurb`, `fileMd5`, `fileSize:J`, `id:I`, `logo`, `displayName`, `name`, `fileName`, `type:Integer`, `version`, `versionCode:I`, `framework`, `frameworkType`, `subData:SubData`, `base:EnvLayerEntity` (self-ref for upgrade base), `downloadUrl`, `upgradeMsg`, `fileType:I`, `isSteam:I`, `state:State`, `status:I`. Two static constants: `BUILTIN_ID = -1`, `ITEM_REMOVE_PC_DATA_ID = -100`.

| Class | Fields |
|---|---|
| `EnvLayerEntity` | **21** instance fields (see above) — environment layer (component) data |
| `EnvRepo` | 4 — `name`, `version`, `state:State`, `entry:EnvLayerEntity` |
| `WinEmuRepo` | 8 — extends `EnvRepo` with `category:RepoCategory`, `isBase:Z`, `isDep:Z`, `depInfo:Lg94;` |
| `ComponentRepo` | 7 — `name`, `version`, `state`, `entry`, `isBase`, `isDep`, `depInfo:Lg94;` (no `category`) |
| `ComponentRecorder` | 3 — `name`, `version`, `broken` |
| `EnvInstallEvent` | 3 — `repo:EnvRepo`, `state:EnvInstallState`, `progress:I` |
| `WinEmuInstallEvent` | sealed event class (new in 6.0.x) — paired `WhenMappings` synthetic |
| `EnvListData<T>` | `list`, `page`, `pageSize`, `total` |
| `LocalPcGameManifest` | 12 — `manifestVersion`, `name`, `appId:J`, `installDir`, `executable`, `arguments`, `sizeOnDisk:J`, `userId`, `userName`, `source`, `packaged:Z`, `packagedFiles:List` |
| `RefreshGameDownloadUrlEntity` | `id`, `downUrl` (now under `winemu/data/bean/`, not `winemu/bean/`) |

#### 9.1.4 State enums

| Enum / Holder | Kind | Values |
|---|---|---|
| `State` | enum | None, Downloaded, Extracted, NeedUpdate, INSTALLED |
| `GameState` (in `winemu/`, not `winemu/bean/`) | enum w/ `type:I` | None(0), Downloaded(1), INSTALLED(2), VERIFIED(4), VERIFYING(8), UNZIPPING(16) — bitfield |
| `Translator` | enum | Box64("2", "X64"), FEX("1", "X64") |
| `EnvInstallState` | enum | INSTALLING, INSTALL_COMPLETE, INSTALL_FAIL |
| `WinEmuInstallState` | enum | INSTALLING, INSTALL_COMPLETE, INSTALL_FAIL (mirror of `EnvInstallState` for new WinEmu event stream) |
| `RepoCategory` | enum | COMPONENT, CONTAINER, IMAGE_FS |
| `SettingType` | enum w/ `type:I` | Switch, Option, Input |
| `WineInGameSettingType` | enum w/ `key`, `codec:WineSettingCodec`, `scope:WineSettingScope` | **17 values** — AiFrameInterpolation, Crt, DrawerGuideShown, FpsLimit, FullScreen, GamepadSensitivity, GyroAim, Hdr, HdrPreset, KeyControlsAlpha, NativeRendering, RedMagicPerformanceMode, ScreenTouchInput, SimulateTouchScreen, SuperResolution, TouchScreenMouseControl, VirtualGamepadVibration |
| `WineSettingScope` | enum | Game, Global |
| `GamePadState` | enum | Active, Baned, EditingOrder, Idle |
| `InstalledGameSource` | enum | UnKnow, GameHubSvrDownload, SteamDownload, PcGameHubMgrImport, LocalImport |
| `NativeRenderingMode` | enum | Auto, Always, Never |
| `RedMagicPerformanceMode` | enum | PowerSaving, Balanced, Boost |
| `ScreenTouchInputMode` | enum **(new in 6.0.4)** | Disabled, Touchscreen, Trackpad, RightStick |
| `GyroAimTargetMode` | enum **(new in 6.0.4)** | Mouse, GamepadSlot0, GamepadSlot1, GamepadSlot2, GamepadSlot3 |
| `AiFrameInterpolationMode` | enum **(new in 6.0.4)** w/ `enabled:Z`, `flowScale:F`, `model:I`, `multiplier:I`, `nameResId:I`, `sliderLabelResId:I` | Disabled, Smooth, Balanced, Clear, Enhanced, Fast, Extreme (7 values; static `defaultEnabled`, `enabledOptions`, `options`) |
| `FileTypeValues` | **static-int holder** (NOT enum) | `OTHER=0`, `GAME=1`, `IMAGE_FS=2`, `WINE=3`, `COMPONENT=4`, `GENERAL_COMPONENT=5`, `DEP_COMPONENTS=6`, `STEAM_CLIENT=7` (`@Deprecated` via `Li94;`), `STEAM_CLIENT_RUNTIME=8` |
| `FileStatusValues` | **static-int holder** (NOT enum) | `NORMAL=0`, `DOWNLOADED=1`, `INSTALLED=2`, `UN_ZIP=3`, `CAN_UPGRADE=4` |
| `FrameworkType` | **static-string holder** (NOT enum) | `TYPE_X64="X64"`, `TYPE_ARM64X="arm64X"` |
| `FileType` | `@interface` (Kotlin `IntDef`-style annotation) | Source-retained marker, no values |
| `FileStatus` | `@interface` (Kotlin `IntDef`-style annotation) | Source-retained marker, no values |

#### 9.1.5 Setting / game beans (selected)

| Class | Fields |
|---|---|
| `FpsLimit` | `enable` (bool), `fpsLimit` (int) |
| `SuperResolution` | `enable`, `sharpness` (float) |
| `NativeRendering` | `mode` (NativeRenderingMode) |
| `KeyControlsAlpha` | `alpha` (float) |
| `GamepadSensitivity` | `sensitivity` (float) |
| `GyroAim` **(new in 6.0.4)** | 10 — `enable:Z`, `target:GyroAimTargetMode`, `horizontalSensitivity:F`, `verticalSensitivity:F`, `invertHorizontal:Z`, `invertVertical:Z`, `swapAxes:Z`, `smoothing:F`, `deadZone:F`, `maxOutput:F` |
| `ScreenTouchInput` **(new in 6.0.4)** | 3 — `mode:ScreenTouchInputMode`, `target:GyroAimTargetMode`, `rightStickSensitivity:F` (defaults: `MIN=0.25f`, `MAX=3.0f`, `DEFAULT=1.25f`) |
| `AiFrameInterpolation` **(new in 6.0.4)** | 1 — `mode:AiFrameInterpolationMode` |
| `HdrPreset` **(new in 6.0.4)** | 1 — `level:I` |
| `HudData` **(new in 6.0.4)** | 9 — `fps:I`, `fpsHistory:List`, `cpuUsagePercent:I`, `gpuUsagePercent:I`, `ramUsagePercent:I`, `powerMilliwatts:F`, `temperatureCelsius:F`, `isCharging:Z`, `isDirectRenderingEnabled:Z` |
| `PcEmuControllerEntity` | `dinput`, `xinput`, `xboxLayout`, `vibration` (4 booleans) |
| `PcEmuGameLocalConfig` | 8 fields — fps, display, hud, etc. |
| `PcEmuGameModeEntity` | **10** (was 9) |
| `PcEmuGameModeDetailEntity` | `id`, `name`, `translations`, `localConfigId` |
| `PcEmuGameModeDetailTranslationEntity` | **24** (was 22) |
| `PcSettingEntity` | 2 instance (`id:I`, `items:List`) + 5 string-type constants (`General`, `Compatibility`, `COMPONENT`, `KEY_MAPPING`, `DEVELOPER_OPTIONS`) |
| `PcSettingItemEntity` | 3 instance (`contentType:I`, `type:I`, `extra:Object`) + **85 static type constants** (was claimed 80) including TYPE_TRANSLATOR_FEX=1, TYPE_TRANSLATOR_BOX64=2 |
| `PcSettingDataEntity` | 10 instance (`id`, `name`, `displayName`, `framework`, `version`, `fileName`, `fileMd5`, `versionCode:I`, `contentType:I`, `subData:SubData`) + 3 static int constants |
| `PcSettingEnvEntity` | `key`, `value` |
| `PcSettingKeyMappingEntity` | `type`, `id`, `title`, `isSelect` |
| `PcSettingResetEntity` | `name`, `curValueString`, `defaultValueString` |
| `PcSettingDefaultValue` | **~28 default-value static constants** (was 14) — covers translator (AVX, BIG_BLOCK, CALLRET, FAST_NAN, FAST_ROUND, MULTI_BLOCK, SAFE_FLAGS, STRONG_MEM, TSO_MODE, WEAK_BARRIER, X87_DOUBLE, X87_MODE, ALIGNED_ATOMICS, WAIT), input (DINPUT_INPUT, XINPUT_INPUT, ENABLE_KEY_MAPPING, OPEN_VIBRATION, XBOX_LAYOUT, CONTROLLER), runtime (HUB_TYPE, MAX_MEMORY, MMAP32, RESOLUTION_W/H, LAUNCH_WINDOWED_MODE, FORWARD), and `APPLY_TRANSLATION_CONFIG_ID` |
| `WineActivityData` | **27** (was 23) — adds `effectiveLanguageModeValue`, `disableImageQualityPlugin`, `seamlessTransition`, `redmagicBinder:IBinder` (transient) and others |
| `GamePad` | abstract — `Physical`, `Virtual`, `PlaceHolder`, `Companion` subclasses |
| `WrapInputDevice` | `inputDevice` (InputDevice), `noGamePad`, `virtualGamePad` |
| `ExeInfo` | `name`, `path`, `icon` (Bitmap) |
| `SubData` | `subFileName`, `subDownloadUrl`, `subFileMd5` |
| `DialogSettingListItemEntity` | 22 |
| `CollapseItemMenu` | `title`, `isCheck` |
| `ShowDownloadOptionEvent` | `archView`, `position`, `item` |
| `SelectEntity` | 2 — `id:I`, `selectStatus:I` |
| `Default` | constants/default-marker singleton |

#### 9.1.6 Storage / cache beans

These now live under `smali_classes4/com/xiaoji/egggame/common/winemu/data/bean/` (separate from `winemu/bean/`).

| Class | Fields |
|---|---|
| `ComputeStorageCache` | 5 longs: `lastComputeTime`, `totalSize`, `availableSize`, `mediaSize`, `totalGameSize` |
| `GamesSizeCache` | `lastComputeTime:J`, `sizeMap:Map<String, Long>` |
| `DownloadTasks` | 3 lists: `downloadingTasks`, `downloadSoonTasks`, `completedTasks` |
| `DownloadUIItem` | `task:Lmv4;`, `title`, `subTitle`, `content` — task type R8'd to `Lmv4;` in 6.0.4 (was `Ldr4;`) |
| `FileOperationEvent` | `fileId:J`, `fileName`, `version`, `fileType:I`, `status:I` (under `data/bean/event/`) |
| `DepComponentChildDownloadEvent` | `depComponents:List`, `state:I`, `isDepChildFail:Z`, `throwable:Throwable` |
| `GameStateRepo` (in `winemu/`) | `gameId`, `name`, `state:GameState`, `version` |

#### 9.1.7 PC game setting scheme system

Scheme classes now live under `smali_classes4/com/xiaoji/egggame/features/winemu/di/model/scheme/` (moved sub-package). Schema version still `2`.

| Class | Fields |
|---|---|
| `PcGameSettingSchemeIndex` | 4 — `schemaVersion(2)`, `records:List`, `appliedSchemeByGame:Map`, `appliedSchemeIdByGame:Map` |
| `PcGameSettingScheme` | 3 — `record`, `jsonString`, `payload` |
| `PcGameSettingSchemeRecord` | **11** (was 10) — `localId`, `gameId`, `name`, `schemeFilePath`, `sourceType:PcGameSettingSchemeSourceType`, `remoteSchemeId`, `shareCode`, `createdAt:J`, `updatedAt:J`, `lastAppliedAt:Long`, **`gpuGroupName`** (new in 6.0.4) |
| `PcGameSettingSchemePayload` | **18** (was 17) — `containerId:Integer`, `componentIds:List`, `translations:PcGameSettingSchemeTranslations`, `componentDependencies:List`, `dinputLibrary:Integer`, `skipAvDecode:Boolean`, `surfaceFormat`, `audioDriver:Integer`, `cpuLimitations:Integer`, `videoMemory:Integer`, `startParam`, `environment`, `startupFilePath`, `gpuUseBuiltin:Boolean`, `dxvkUseBuiltin:Boolean`, `vkd3dUseBuiltin:Boolean`, `translatorUseBuiltin:Boolean`, **`hostCoreMask:Integer`** (new in 6.0.4) |
| `PcGameSettingSchemeTranslations` | 2 — `box64:Lggb;`, `fex:Lggb;` (typed JSON-element holders for `Box64TranslatorConfig` / `FEXTranslatorConfig`) |
| `PcGameSettingSchemeComponentDependency` | 6 — `id:Integer`, `name`, `version`, `fileName`, `fileMd5`, `fileSize:Long` |
| `PcGameSettingSchemeValidationResult` | 4 — `isValid:Z`, `message`, `normalizedJson`, `payload` |
| `AppliedSchemeIdentity` | 6 — `localId`, `remoteId`, `shareCode`, `schemeName`, `appliedPayloadHash`, `appliedSettingsHash` |
| `PcGameSettingSchemeApplyResult` | sealed: `Success` (7: `record`, `schemeName`, `translatorType`, `componentDependencyCount:I`, `startupFilePath`, `startupFilePathApplied:Z`, `appliedSchemeId`) / `Failure` (`reason`, `cause:Throwable`) |

**Remote scheme classes** (under `smali_classes4/com/xiaoji/egggame/features/winemu/data/remote/`):

| Class | Fields |
|---|---|
| `SchemeDetailEntity` | **25** — `id:J`, `title`, `configBody`, `schemeSource` (was `sourceType` field name; now `schemeSource:String` + numeric `sourceType:I`), `isOfficial:I`, `isRecommend:I`, `status:I`, `weight:I`, `downloadCount:I`, `activeUserRatio:D`, `downloadRatio:D`, `matchLevel`, `matchLevelLabel`, `gpuGroupName`, `shareUserAvatar`, `createdBy`, `updatedBy`, `createdTime:J`, `updatedTime:J`, `titleLangParam`, `isCommon:I`, `gameId:I`, `sourceGameId:String`, `shareCode`, `sourceType:I` |
| `SchemeShareEntity` | 4 — `id:J`, `shareCode`, `sourceGameId`, `sourceType:I` |
| `SchemeShareRequest` | `id`, `gameId`, `sourceGameId`, `sourceType`, `title`, `configBody` |
| `SchemeShareInfo` | `remoteSchemeId`, `shareCode`, `sourceGameId`, `sourceType` |
| `DeleteRemoteSchemeRequest` | `id` (int) |
| `ReportConfigApplyRequest` | `id` (long) |

`PcGameSettingSchemeSourceType` enum (in same `scheme/` package): `Local(0)`, `Imported(1)`, `Official(2)`, `Recommended(3)`, `CloudShared(4)`.

#### 9.1.8 In-game sidebar UI

User-facing sidebar string keys (all extracted from `res/values/strings.xml`).

**HUD / performance metrics:**
- `winemu_sidebar_hud_cpu` / `_gpu` / `_ram` / `_power` / `_tmp` / `_fps` — toggle each metric
- `winemu_sidebar_hud_graph` — FPS graph toggle
- `winemu_sidebar_hud_opacity` — HUD transparency
- `winemu_sidebar_hud_vertical_layout` (+ `_desc`) — vertical metric stack
- `winemu_sidebar_hud_display` — master HUD toggle
- `winemu_sidebar_hud_engine` — **new in 6.0.4** Engine-name display (Wine/Proton build line)

**Visual / display:**
- `winemu_sidebar_super_resolution` — Super resolution upscaling
- `winemu_sidebar_sharpness` — CAS sharpness
- `winemu_sidebar_crt_effect` — CRT visual filter
- `winemu_sidebar_hdr` — HDR tone-mapping (paired with `HdrPreset.level` bean)
- `winemu_sidebar_fullscreen` — Fullscreen game toggle
- `winemu_sidebar_enable_screen_brightness` + `winemu_sidebar_system_brightness` — manual brightness
- `winemu_sidebar_power_multiplier` — Dual-battery power fix

**Controls / session:**
- `winemu_sidebar_controls_title`, `winemu_sidebar_default_layout`, `winemu_sidebar_custom_layout_example`, `winemu_sidebar_more_layouts`, `winemu_sidebar_switch_mapping_scheme` — gamepad layouts
- `winemu_sidebar_virtual_gamepad`, `winemu_sidebar_simulate_touch_screen` — touch controls
- `winemu_sidebar_key_opacity` — touch controls opacity
- `winemu_sidebar_mouse_speed` (+ `_desc`) — virtual mouse sensitivity
- `winemu_sidebar_gamepad_manage_subtitle` — "Configure gamepad and change order"
- `winemu_sidebar_enable_fps_limit` + `winemu_sidebar_fps_limit` — FPS limit
- `winemu_sidebar_performance_title` — performance group header
- `winemu_sidebar_system_volume` — system volume
- `winemu_sidebar_exit` — exit game
- **New in 6.0.4:** `winemu_sidebar_touch_input_right_stick_sensitivity`, `winemu_sidebar_touch_input_trackpad_sensitivity` (pair with `ScreenTouchInput` bean and `ScreenTouchInputMode` enum)
- **New in 6.0.4 gyro group:** `winemu_sidebar_gyro_aim_calibration_started`, `_success`, `_failed`, `_unavailable` (pair with `GyroAim` bean)

**Loading state strings:** `winemu_loading_client_starting`, `winemu_loading_enter_desktop` (**renamed in 6.0.4** from `winemu_loading_desktop_entry`), `winemu_loading_game_starting`.

**Cloud save:** `features_winemu_cloud_save_downloading` / `_syncing` / `_uploading`.

**Setup workflow:** `winemu_setup_*` (checks for container, Steam client, components; download base/dependency components; recommended-settings auto-apply via `applying_game_settings` / `game_settings_applied`).

**Log server:** `winemu_log_server_info_*` (local network HTTP logging server for debugging).

#### 9.1.9 Component dropdown dispatch — read/write paths

In 6.0.4 the component-cache singleton has been re-architected. The two-class layout is:

- **`Lj7o;`** — top-level API singleton (`q:Lj7o;` static volatile field; accessed via `Lkek;->p()Lj7o;` and `Lkek;->o(Application)Lj7o;` companion accessors). Holds **four** ConcurrentHashMaps `k`, `l`, `m`, `n` (in-memory per-key/per-category caches and SharedFlow emitters). Composes a `Lmyo;` instance at field `b`.
- **`Lmyo;`** — registry-backed utility doing the actual SharedPreferences round-trips against `sp_winemu_unified_resources.xml`. Static key builder: `y(RepoCategory, String)String` (concat `cat.name() + ":" + repoName`).

Old doc claimed cache singleton `Ll9o;` — that letter still exists in 6.0.4 but now refers to a 2-method unrelated utility (`e(Lw98;)V`, `i(Lrb8;)V`). Disregard.

**Read-side accessors on `Lj7o;`:**

| Method | Signature | Purpose |
|---|---|---|
| static `Lkek;->p()` / `o(Application)` | `()Lj7o;` / `(Application)Lj7o;` | Singleton accessors (`Lj7o;` Companion collapsed into `Lkek;`) |
| `i(RepoCategory, String)` | `→ WinEmuRepo` | Single-get by name; **delegates to `Lmyo;->u(...)`** |
| `x(RepoCategory)` | `→ Ltge;` (SharedFlow) | **Per-category Flow** — Compose state subscribes here (key off `Lj7o;->l` map; creates via `Lavo;->l()`) |
| `q(RepoCategory, String)` | `→ Ltge;` | Per-(category, name) Flow |
| `t(RepoCategory, Lci3;)` | `→ Object` | Suspend list/refresh by category |
| `n(RepoCategory)V` | invalidate / drop category cache |
| `y(RepoCategory)V` | category-scope refresh trigger |

**Static helpers on `Lj7o;`:**

| Method | Signature | Purpose |
|---|---|---|
| `B(WinEmuRepo)` | `→ String` | Build pref key for repo (delegates to `Lmyo;->y`) |
| `G(WinEmuRepo, String)` | `→ String` | Build pref key with explicit name override |

**Registry-backed accessors on `Lmyo;`:**

| Method | Signature | Purpose |
|---|---|---|
| static `y(RepoCategory, String)` | `→ String` | Key builder `"<RepoCategory.name()>:<repoName>"` (uses `Lmt3;->j` for the concat) |
| `u(RepoCategory, String)` | `→ WinEmuRepo` | Single-get by name (XML read + JSON parse) |
| `w(RepoCategory)` | `→ ArrayList<WinEmuRepo>` | List-by-category (XML scan) |

**Diagnostic note — picker pipeline re-architected in 6.0.4.** The 6.0.1 picker-open trace showed `gxh.a` / `m13.b` / `o61.r` / `v86.b` / `nhn.f` as the active fires while `l9o.z` / `dh7.<init>` stayed silent. In 6.0.4 the whole pipeline has been **re-architected and re-clustered**: the old free-floating coroutine state-machine classes are gone (`Lgxh;` is now a string enum, `Lm13;` a synthetic invoker, `Lo61;`/`Lv86;` anonymous data records, etc.), and the picker pipeline is now rooted at **`Lj7o;->y(RepoCategory)V`** (a method, not a class). Re-derived 6.0.4 letter mapping:

| Old letter (6.0.1) | Role | New 6.0.4 anchor | Re-derivation recipe |
|---|---|---|---|
| `Lnhn;` (refresh trigger) | Public "refresh this category" entrypoint | **`Lj7o;->y(RepoCategory)V`** instance method (not a class) | CAS pattern at `j7o.smali:790` (`compareAndSet(false, true)` on field `j:AtomicBoolean`); sole external caller is `Llhf.smali:980/989/998` (refresh IMAGE_FS, CONTAINER, COMPONENT in turn) |
| `Ll9o;` / `Lgxh;` (top-level launcher) | Coroutine launcher that schedules per-category fetch worker | **`Lv6o;`** (`Laql;` + `Ldx6;`, ctor `(Lj7o;Lbi3;)V`) | Launched by `Lj7o;->y` at `j7o.smali:825` via scope launch on field `h:Lvh3;` (the manager's CoroutineScope) |
| `Lm13;` (multi-category fan-out) | Iterates `Set<RepoCategory>` and dispatches per-category work | **`Lu6o;`** (`Laql;` + `Ldx6;`, ctor `(Ljava/util/Set;Lj7o;Lbi3;)V`) | Signature annotation `Ljava/util/Set<Lcom/xiaoji/egggame/common/winemu/bean/RepoCategory;>;`; iterates `$repairedCategories` Set and instantiates `Lt6o;` per item at `u6o.smali:313–317` |
| `Lo61;` (per-category timeout wrapper) | Wraps per-category load in a fixed timeout | **`Lt6o;`** (`Laql;` + `Ldx6;`, ctor `(Lj7o;RepoCategory;Lbi3;)V`) | Wraps `Ls6o;` in `Lw32;->O(JLdx6;Lbi3;)` with timeout literal `0x3a98` = 15000 ms at `t6o.smali:197–225` |
| `Lv86;` (runCatching wrapper) | `runCatching { … }` wrapper that funnels into the actual loader | **`Ls6o;`** (`Laql;` + `Ldx6;`, ctor `(Lj7o;RepoCategory;Lbi3;)V`) | `invokeSuspend` directly calls `Lj7o;->t(RepoCategory, Lci3;)` at `s6o.smali:167` |
| `Ldh7;` (silent / error-only path) | Was the silent retry path | **`Lb7o;`** (`Laql;` + `Ldx6;`, ctor `(Lj7o;RepoCategory;Lbi3;)V`) | Field `$this_runCatching:Lj7o;` proves runCatching context; invoked from `j7o.smali:2626`; calls `Lj7o;->t` at `b7o.smali:167` |
| (loader) | List-loader hitting `simulator/v2/getAllComponentList`; populates `Lj7o;->k/l/m/n` | **`Lw43;`** (unchanged letter) | `Lw43;->invokeSuspend`; `isBase = (type == 6)` check at `w43.smali:1639`; record class `Lx43;` |

The picker-side Composable consumer reads the per-category `Ltge;` (SharedFlow) **after** the initial cache hit and re-collects on recompose, which is why `Lj7o;->x` has zero external callers (only 3 self-calls). On subsequent opens, only `Lj7o;->y` (the refresh trigger) fires.

**Recommended `bannerhub-revanced` anchor for 6.0.4:** don't chase letters. Anchor on (a) the `Lj7o;->y` method signature, (b) the `[bstuv]6o`/`Lb7o;` coroutine cluster (R8's new grouping fingerprint for the picker pipeline — it clusters coroutine state machines by their `this$0` owner now), (c) the 15000 ms timeout literal `0x3a98` in `Lt6o;`.

**Registry write side:** writes are now performed inside `Lj7o;` itself (replacing the old `Ly99;->b` — which still exists but is an unrelated coroutine class in 6.0.4). The write sequence is:

1. `WinEmuRepo.getCategory()` → `RepoCategory.name()`
2. `Lmyo;->y(category, repoName)` builds key `"<Category>:<name>"`
3. JSON-serialize via `Lj7o;->p:Lkek;` (static Json instance, `Lkek;` Companion-style class)
4. `Lje6;` lazy provider (`smali_classes2/je6.smali:invoke()` returns `getSharedPreferences("sp_winemu_unified_resources", 0)`)
5. `Editor.putString(key, json).apply()` (verified at `j7o.smali:667` and `:8150`)

Writes remain **per-key, additive** — server never bulk-clears.

**Recommended write strategy for manager-injected components** (unchanged structurally from 6.0.1):

- **Write key:** `COMPONENT:<userComponentName>`
- **Write value:** JSON shaped like a host entry: top-level `{category, depInfo, entry{...}, isBase, isDep, name, state, version}`; `entry` populated with `type` (FEX/Box64=1, GPU=2, DXVK=3, VKD3D=4, settings=5, runtime-dep=6, STEAMCLIENT_RUNTIME=8), `name`, `version`, `fileType=4`, `fileName="<name>.tzst"`, `state="Extracted"`, `status=0`, plus markers `_bh_injected:true`, `_bh_skip_md5:true`, `_bh_source_uri`, `_bh_added_at`
- Re-write on every Component Manager open (idempotent, defends against future server pruning)
- Sidecar pref `sp_bh_components.xml` retained for our own bookkeeping (which entries we injected — for uninstall/badging UX)

#### 9.1.10 Other component-pipeline classes

| Class.method | Role |
|---|---|
| `Lje6;->invoke()` | Lazy provider for `sp_winemu_unified_resources` SharedPreferences (in 6.0.4 — was `Lt76;` in old doc; `Lt76;` is now a generic data record) |
| `Lw43;->invokeSuspend(Object)Object` | Coroutine state machine — calls `simulator/v2/getAllComponentList`, parses `BaseResult<EnvListData<EnvLayerEntity>>`, wraps each as `WinEmuRepo(name, version, state, entity, RepoCategory.COMPONENT, isBase=(type==6), ...)`. Result feeds `Lj7o;`'s `k`/`l`/`m`/`n` cache maps and per-category SharedFlows. `isBase` check at `w43.smali:1639` (`const/4 v7, 0x6; if-ne v6, v7, :cond_12`). Was `Ll13;` in 6.0.1 (`Ll13;` in 6.0.4 is now an enum). |
| `Lx43;` | Argument record holding the `RepoCategory` (field `a`) that `Lw43;` operates on; ctor seeds `RepoCategory.COMPONENT` |
| `Lkek;` | `Lj7o;` Companion-style class — owns `p()Lj7o;` / `o(Application)Lj7o;` singleton accessors plus a small `Lkotlinx.serialization.json.Json` instance referenced as `Lj7o;->p` |
| Per-repo readiness check | Owner class **`Lmci;`** (top-level class, ctor `(Lmyo;Lmei;Loja;)V`); the log-string lambda is **`Ljci;`** (synthetic `invoke()→String`, instantiated only from `Lmci.smali:372` and `Lj7o.smali:8490`). Logs `WinEmuModule queryReadyState name = <name>` (const-string anchor at `jci.smali:141`). Was claimed as `Ldxh;->invoke()` in the 6.0.0 doc — `Ldxh;` still exists in 6.0.4 but is unrelated. |

#### 9.1.11 Interfaces

| Interface | Purpose |
|---|---|
| `IEmuContainer` (+ `DefaultImpls`) | Container management |
| `IWinEmuService` (+ `DefaultImpls`) | WinEmu service ops |
| `ITranslatorConfig` (+ `Companion`, `DefaultImpls`) | Abstract translator config (Companion provides serializer); annotated `Lnrj;` for serialization |
| `SwitchableSetting` | `getEnable` / `setEnable` |
| `WineSettingCodec` | Sealed: inner `Bool`, `Json` |
### 9.2 Steam Integration

#### 9.2.1 `SteamInstalledAppMetadata` (22 fields, classes4.dex)

```kotlin
data class SteamInstalledAppMetadata(
    val appId: Int, val installDirPath: String, val buildId: Int,
    val isInCopying: Boolean, val branch: String,
    val depots: List<SteamInstalledAppMetadataDepot>,
    val displayName: String, val iconHash: String,
    val launchInfo: SteamGameLaunchInfo?,
    val verticalCover: String, val hasInstallScripts: Boolean,
    val installScripts: Map<String, List<String>>,
    val unKnowInstallScripts: Map<String, List<String>>,
    val isUpdateTask: Boolean?, val updateSize: Long?,
    val updateDownloadSize: Long?, val updateProgress: Int?,
    val totalDownloadSize: Long, val downloadedSize: Long,
    val totalInstallSize: Long, val installedSize: Long,
    val updatedAtMillis: Long
)
```

Serializer descriptor location (6.0.4): `com.xiaoji.egggame.common.steam.core.SteamInstalledAppMetadata$$serializer` (classes4.dex). Field order in 6.0.4: `depots` moved up to position 5 (slot 5); `launchInfo` now typed as `SteamGameLaunchInfo` (via `SteamGameLaunchInfo$$serializer`) instead of `Any`. Field count and names otherwise unchanged from 6.0.0/6.0.1.

`SteamInstalledAppMetadataDepot` (4 fields): `parentAppId` (int), `depotId` (int), `manifestId` (long), `installScriptPath` (String?).

#### 9.2.2 Steam Bridge (`com.xiaoji.egggame.common.steam_sdk.bridge`)

| Class | Role | 6.0.4 location |
|---|---|---|
| `SteamBridgeClient` | Main bridge client | `…/bridge/SteamBridgeClient.java` |
| `SteamBridgeTransport` (interface) | Transport abstraction | `…/bridge/SteamBridgeTransport.java` |
| `AndroidSteamBridgeTransport` | Android impl (R8-renamed) | `…/bridge/a.java` (+ `AndroidSteamBridgeTransportKt.java`) |
| `SteamBridgeNative` | JNI bridge to `libsteamkit_core.so` | `…/bridge/SteamBridgeNative.java` |
| `SteamBridgeEvent` | Event type definitions | `…/bridge/SteamBridgeEvent.java` |
| `SteamBridgeException` | Bridge-level exception | `…/bridge/SteamBridgeException.java` |
| `SteamBridgeNativeInitializer` | Native lib loader | `…/bridge/SteamBridgeNativeInitializer.java` |

The previously listed `NativeBridgeError`, `NativeBridgeEvent`, `NativeBridgeResponse`, `NativeOperationStart`, `NativeOperationPoll` types are no longer surfaced as standalone classes in 6.0.4 — they appear as R8-renamed support classes in `defpackage/` (e.g. `j0.java`, `n6.java`) referenced from the bridge code.

**Bridge DTO surface (`com.xiaoji.egggame.common.steam_sdk.impl`):** 52 `$$serializer` files in 6.0.4 (≈50 distinct request / response / event DTOs):
`AchievementDto`, `AchievementsRequest`, `AppDetailsDto`, `AppIdRequest`, `AppIdsRequest`, `AppcacheRootRequestDto`, `AuthErrorDto`, `AuthStateDto`, `BranchOptionDto`, `CachedAppRequest`, `CachedLibraryRequest`, `CancelRequest`, `ClearInstallStateRequest`, `CloudAppStateChangedEventDto`, `CloudAppStateReportDto`, `CloudContextRequestDto`, `CloudFinalizeExitReportDto`, `CloudSyncReportDto`, `CloudSyncStatusEventDto`, `CloudTrackedStateReportDto`, `CmServerDto`, `DisconnectedDto`, `DlcDetailsDto`, `DownloadCancelledEventDto`, `DownloadCompletedEventDto`, `DownloadFailedEventDto`, `DownloadPausedEventDto`, `DownloadProgressEventDto`, `DownloadSelectionDto`, `DownloadTaskRecordDto`, `FreeLicenseResultDto`, `GameLaunchInfoDto`, `InstallOptionsDto`, `InstallRequestDto`, `LaunchOptionsRequestDto`, `LibraryQueryDto`, `LibrarySyncCompletedEventDto`, `LoginPasswordRequest`, `LoginRefreshTokenRequest`, `PersonaDto`, `PersonaRequest`, `PreflightDepotDto`, `PreflightReportDto`, `PublishedFileDetailsRequest`, `QrUrlDto`, `QueryLibraryRequest`, `RemoveSavedAccountRequest`, `StartDefaultInstallRequest`, `SteamErrorDto`, `SteamLibraryGameDto`, `SubmitGuardCodeRequest`, `TrySignInSavedRequest` + `SteamGameLaunchInfo` (model).

Native lib (verified in 6.0.4): `lib/arm64-v8a/libsteamkit_core.so` — **11,403,128 bytes**.

#### 9.2.3 `SteamDownloadStatus` constants (`com.xiaoji.egggame.common.steam.data.bean.SteamDownloadStatus`)

| Status | Value |
|--------|-------|
| Waiting | 0 |
| Preparing | 1 |
| Downloading | 2 |
| Paused | 3 |
| Cancel | 4 |
| Finished | 5 |
| Fail | 6 |
| DownloadingConfigFile | 7 |
| Resuming | 11 |
| Installing | 12 |
| DownloadSoon | 13 |

#### 9.2.4 Additional Steam DTOs (`com.xiaoji.egggame.common.steam`)

Verified present in 6.0.4: `SteamBranchPreference` (`steam/branch/`), `BindingsListResponse`, `SteamBindingRequest`, `SteamUnbindRequest`, `ThirdPartyBindingInfo` (`steam/data/repository/`), `DepotInfo`, `SteamDownloadStatus` (`steam/data/bean/`), `SteamInstalledAppMetadata`, `SteamInstalledAppMetadataDepot` (`steam/core/`), `LocalizedAssetPack.RetinaAsset` (`steam/models/app/`).

**Removed/renamed in 6.0.4:** `SteamAccountInfo`, `SteamPlatformStats`, `SteamPlatformStatsResponse`, `AppDownloadInfo`, `AppMetadata`, `PlatformGameItem`, `PlatformGameLibData`, `PlatformGameLibResponse` — no longer present as named classes. The 51-field `PlatformGameItem` master record from 6.0.0 has been retired; equivalent fields are now spread across smaller R8-renamed DTOs (no single replacement class shipped under `com.xiaoji.egggame.common.steam` in 6.0.4).

#### 9.2.5 Domain steam models (`com.xiaoji.egggame.core.domain.model.steam`, new in 6.0.4)

| Class | Purpose |
|---|---|
| `SteamLaunchOption` | A single Steam launch option |
| `SteamGameLaunchMetadata` | Metadata returned by Steam bridge for launch |
| `SteamExecutableInfo` | Executable descriptor (path, args, working dir) |

These replace the heavy `PlatformGameItem` aggregate in 6.0.4 for launch/configuration flows.

---

### 9.3 Epic Games (EpicKit)

`libepickit_core.so` is a Rust library exposed to Java via **UniFFI**. Provides a full Epic Games Store SDK at `uniffi/epickit_core/` — **183 Java files in 6.0.4** (up from ~160 in 6.0.0).

Native lib (verified in 6.0.4): `lib/arm64-v8a/libepickit_core.so` — **4,720,048 bytes**.

**Epic OAuth Client ID:** `34a02cf8f4414e29b15921876da36f9a` (confirmed in `smali_classes4/sml.smali`, `smali_classes4/po.smali`).
**API path:** `epic_data/epickit` (POST relay) plus 9 GET paths under `epic_data/` for recovery governance JSONs (see §12.2.6).
**XGP redemption:** `gamehub-service-dev.xiaoji.com/xgp/exchange` and `xgp.xiaoji.com` portal.

#### 9.3.1 Cloud Save records

| Class | Fields / Values |
|---|---|
| `EpicCloudSaveSyncDecisionRecord` | enum: NONE, UPLOAD, DOWNLOAD, SKIPPED_UPLOAD_DISABLED, SKIPPED_DOWNLOAD_DISABLED, SKIPPED_NO_LOCAL_SAVE, SKIPPED_NO_REMOTE_SAVE |
| `EpicCloudSaveSyncStateRecord` | enum: NO_SAVE, SAME_AGE, LOCAL_NEWER, REMOTE_NEWER |
| `EpicCloudSaveSyncOptionsRecord` | `localDirOverride`, `forceUpload`, `forceDownload`, `skipUpload`, `skipDownload`, `cleanLocalBeforeDownload` |
| `EpicCloudSaveSyncReportRecord` | `appName`, `localDir`, `state`, `decision`, `localTimestamp`, `remoteTimestamp`, `remoteManifest`, `uploaded`, `downloaded`, `summary` |
| `EpicCloudSaveUploadReportRecord` | `appName`, `filesRequested`, `filesUploaded`, `bytesUploaded` |
| `EpicCloudSaveDownloadReportRecord` | `appName`, `outputDir`, `manifestsDownloaded`, `filesRestored`, `chunksDownloaded`, `bytesDownloaded` |
| `EpicCloudSaveCleanupReportRecord` | `appName`, `filesSeen`, `manifestsSeen`, `keptManifest`, `filesDeleteAttempted`, `filesDeleted`, `filesDeleteFailed` |
| `EpicCloudSaveManifestRecord` | `appName`, `manifestName`, `manifestPath`, `lastModified` |

#### 9.3.2 Download records

| Class | Fields |
|---|---|
| `EpicDownloadJobStateRecord` | enum: QUEUED, RUNNING, PAUSED, VERIFYING, COMPLETED, FAILED_RETRYABLE, FAILED_TERMINAL, CANCELLED |
| `EpicDownloadModeRecord` | enum: INSTALL, UPDATE, REPAIR |
| `EpicDownloadRunModeRecord` | enum: AUTO, INSTALL, UPDATE, REPAIR |
| `EpicDownloadJobRecord` | **20** — `version`, `jobId`, `requestedAppName`, `resolvedAppName`, `title`, `cover` *(new)*, `verticalCover` *(new)*, `platform`, `label`, `installDir`, `manifestSha1`, `chunkBaseUrl`, `chunkBaseUrls`, `state`, `failureCount`, `retryNotBefore`, `lastError`, `createdAt`, `updatedAt`, `progress` |
| `EpicDownloadJobProgressRecord` | 11 — `phase`, `filesTotal`, `filesCompleted`, `chunksTotal`, `chunksCompleted`, `bytesDownloaded`, `bytesWritten`, `visibleBytesWritten`, `estimatedDownloadBytes`, `elapsedMs`, `speedBytesPerSecond` |
| `EpicDownloadJobCreateRequestRecord` | `jobId`, `requestedAppName`, `title`, `platform`, `label`, `installDir` |
| `EpicDownloadJobStartRequestRecord` | 23 — `runMode`, `includePrefixes`, `excludePrefixes`, `installTags`, `maxConcurrency`, `maxRetries`, `retryBackoffMs`, `chunkRequestTimeoutMs`, `memoryChunkCacheEntries`, `keepChunkCache`, `forceRedownload`, `disablePatching`, `disableDelta`, `oldManifestSha1`, `manifestOverride`, `deltaManifestOverride`, `oldManifestOverride`, `chunkBaseUrlOverride`, `downloadOnly`, `retainCompletedDownloadOnlyJob`, `updateOnly`, `withDlcs`, `skipDlcs` |
| `EpicDownloadAnalysisRecord` | 17 — `requestedAppName`, `resolvedAppName`, `platform`, `label`, `manifestSha1`, `previousManifestSha1`, `mode`, `fromCache`, `downloadBytes`, `reusableBytes`, `installBytes`, `removedBytes`, `deleteFiles`, `addedFiles`, `changedFiles`, `removedFiles`, `unchangedFiles` |
| `EpicDownloadTerminalStatusRecord` | `state`, `errorMessage` |
| `EpicResolvedManifestRecord` | 10 — `requestedAppName`, `resolvedAppName`, `platform`, `label`, `manifestUrl`, `chunkBaseUrl`, `manifestSha1`, `baseUrls`, `fromCache`, `manifestBytes` |
| `EpicSizeEstimateRecord` | `downloadBytes`, `installBytes`, `fromCache` |

> Net-new in 6.0.4: `EpicDownloadJobRecord` grew from 18 to **20** field with `cover` and `verticalCover` artwork URLs (used by the Epic library list / download tray).

#### 9.3.3 Metadata / catalog records

| Class | Fields |
|---|---|
| `EpicActivationStoreRecord` | enum: UBISOFT, EA |
| `EpicActivationReportRecord` | `appName`, `title`, `store`, `activationUri`, `alreadyActivated`, `message` |
| `EpicGameAssetRecord` | `appName`, `namespace`, `catalogItemId`, `buildVersion`, `labelName`, `assetId`, `sidecarRev` |
| `EpicGameImageRecord` | `imageType`, `url` |
| `EpicKeyValueRecord` | `key`, `value` |
| `EpicManifestComparisonRecord` | `added`, `removed`, `changed`, `unchanged` (all List\<String\>) |
| `EpicMetadataSyncReportRecord` | `requested`, `updated`, `failed`, `updatedCatalogItemIds` |
| `EpicOfferIdentityRecord` | `offerId`, `offerType`, `productSlug`, `namespace` |

#### 9.3.4 SDK / session records

| Class | Fields |
|---|---|
| `EpicSdkOptions` | `configDir`, `apiTimeoutSecs`, `locale`, `country`, `sessionBackend`, `accountId` |
| `EpicStatusSnapshotRecord` | `configDir`, `loggedIn`, `sessionCount`, `installedCount`, `accountId`, `displayName` |
| `EpicCleanupReportRecord` | `removedManifestBlobs`, `removedManifestIndexEntries`, `removedDownloadJobs`, `removedTmpEntries`, `clearedSizeEstimateEntries` |
| `EpicVerifyReportRecord` | `appName`, `checkedFiles`, `matchedFiles`, `missingFiles`, `mismatchedFiles`, `totalBytes` |

#### 9.3.5 Exception types

`EpicException` (abstract):
- `EpicException.Message` (`details: String`)
- `EpicException.NotAuthenticated`
- `EpicException.SessionNotFound` (`accountId: String`)

#### 9.3.6 Recovery governance system (`com.xiaoji.egggame.common.epic.downloader`)

Full state machine for EGS download failure recovery — confirmed present in 6.0.4.

**Enums:** `EpicRecoveryGovernanceExecutionState` (Triggered, Suppressed, Blocked, ManualRequired), `EpicRecoveryGovernanceExecutionReason`, `EpicRecoveryGovernanceExecutionStrategy`, `EpicRecoveryGovernancePromptType`, `EpicRecoveryGovernancePromptState`, `EpicRecoveryGovernanceDirectiveMode`, `GovernancePromptEscalationLevel`.

**Data classes:** `EpicRecoveryGovernanceDirective`, `EpicRecoveryGovernanceDirectiveExecutor`, `EpicRecoveryGovernancePlan`, `EpicRecoveryGovernanceDirectiveExecutionApprovalStateRecord`, `EpicRecoveryGovernanceDirectiveExecutionAuditStateRecord`, `EpicRecoveryGovernanceDirectiveExecutionOutcomeRecord`, `EpicRecoveryGovernanceDirectiveExecutionReasonRecord`, `EpicRecoveryGovernanceWorkflowStepRecord`, `EpicRecoveryGovernanceWorkflowStepStateRecord`, `EpicRecoveryManualAction`, `EpicRecoveryReviewAction`.

State configurations are loaded at runtime from 9 JSON endpoints under `epic_data/epic_recovery_governance_*.json` (see §12.2.6).

---

### 9.4 Retro Emulation

The retro emulation feature runs emulators inside a WebView using **Nostalgist.js 0.19.0** (RetroArch compiled to WebAssembly; bundled at `assets/composeResources/com.xiaoji.egggame.common.retro_emulators/files/emulator/nostalgist.0.19.0.umd.js`). Cores are downloaded on demand from `https://retro-emulator-download.bigeyes.com/retroarch/`.

**Supported systems:** GB, GBA, GBC (mGBA), NES (fceumm), SNES (snes9x), Mega Drive (genesis_plus_gx).

> 6.0.4 note: Kotlin sources moved from `com.xiaoji.egggame.common.retro_emulators` → **`com.xiaoji.egggame.retro_emulators`** (no longer under `.common`). The asset path (`assets/composeResources/com.xiaoji.egggame.common.retro_emulators/…`) retained its original `.common.` segment.

#### 9.4.1 Local ROM database (Room)

`RetroGameDatabase` (`com.xiaoji.egggame.retro_emulators.data.local`) with entities `RetroGameEntity`, `RetroGameSessionEntity` and DAOs `RetroGameDao`, `RetroGameSessionDao`.

```sql
CREATE TABLE retro_games (
    id TEXT PRIMARY KEY,
    game_name TEXT, game_icon TEXT,
    core_type TEXT,          -- e.g. "mgba", "fceumm", "snes9x"
    platform TEXT,           -- e.g. "gba", "nes", "snes"
    file_path TEXT, is_import INTEGER,
    created_at INTEGER, updated_at INTEGER
)
CREATE TABLE retro_game_sessions (
    session_id TEXT PRIMARY KEY, game_id TEXT,
    duration_seconds INTEGER, started_at INTEGER, last_updated_at INTEGER
)
```

> 6.0.4 schema correction: primary key column on `retro_games` is `id` (Room entity field `id`), not `game_id` as previously documented. Server-synced `retro_game_stats` table is still tracked separately at the network layer.

#### 9.4.2 WebView ↔ Java JS bridge

The retro emulator WebView (`assets/composeResources/com.xiaoji.egggame.common.retro_emulators/files/emulator/index.html`) exposes a `window.JSBridgeApi` Java-callable surface and posts back to Java via `window.JSBridge.postMessage(jsonString)`. WebView factory in 6.0.4: `com.xiaoji.egggame.retro_emulators.ui.RetroEmulatorWebView_androidKt$RetroEmulatorWebViewFactory$1`.

**`window.JSBridgeApi` methods (Java → JS):**

| Method | Notes |
|---|---|
| `launch(config)` | async — start emulator with config (system, core URL, ROM path, save path) |
| `saveState()` | async — capture current state as bytes |
| `loadState(stateData)` | async — restore from save state |
| `restart()` | async — reset emulator |
| `pause()` / `resume()` / `isPaused()` | playback control |
| `sendFastForward()` | toggle FF mode |
| `screenshot()` | async — capture frame |
| `exit()` | shut down emulator |
| `keyEvent(keyConfig)` | async — inject input |
| `applyCheat(payloadJson)` / `toggleCheat(...)` / `removeCheat(...)` | cheat-code management |

**JS → Java:** `window.JSBridge.postMessage(JSON.stringify({...}))` — single-channel JSON-message bus for events (cheat result, error, lifecycle).

**Features:** save states (archive), cheat codes, gamepad button mapping (dark/light theme button images), retro game stats reporting to server.

---

### 9.5 Cloud Gaming (VTouch + Haima HMCP)

Cloud gaming has two distinct stacks: VTouch (XiaoJi's own cloud-PC backend) and Haima HMCP (third-party SDK). Both are accessible from the same UI but route differently.

#### 9.5.1 VTouch — `vtouch/startType` + `cloud/*`

**Catalog routes** (under `clientgsw.vgabc.com/clientapi/`):
- `vtouch/startType` — query cloud-gaming launch mode
- `cloud/game/auth_token`, `cloud/game/start_token`, `cloud/game/renew_token` — session lifecycle
- `cloud/game/exit`, `cloud/game/check_user_timer` — session end + remaining-time check
- `cloud/game/getQueueInfo`, `cloud/game/startQueue`, `cloud/game/getQueueCalendar` — queue management
- `cloud/game/getGoodsListV2`, `cloud/game/getNewsList`, `cloud/game/getNewsDetail`, `cloud/game/confirmPlay` — store / info / confirmation
- `cloud/order/info`, `cloud/order_list`, `cloud/payment` — billing
- `cloud/app/exchange_code`, `cloud/h5/exchange_code?uuid=` — activation codes
- `cloud/use_time_log` — play-time reporting
- `cloud/notify/apple` — Apple push for cloud gaming
- `cloud_sign/getActivity`, `cloud_sign/sign` — daily sign-in (under separate `cloud_sign/` namespace, listed here for proximity)

Endpoints anchored in smali (`smali_classes3/aj2.smali`, `smali_classes4/xcn.smali`). 

**Local DB:** `cloud_game_sessions.db` — `cloud_game_sessions` + `cloud_timer` tables track session duration for reporting.

#### 9.5.2 Haima HMCP — third-party SDK

SDK version: `master-7.40.1` (`Constants.SDK_VERSION` / `ConstantsInternal`, confirmed in 6.0.4). Native lib: `lib/arm64-v8a/libhaima_rtc_so.so` — **8,273,840 bytes**. Package root: `com.haima.hmcp.*`.

| Sub-package | Content |
|---|---|
| `hmcp/beans/` | 200+ bean/DTO classes (cloud session, IME, gamepad, streaming, WebSocket) |
| `hmcp/model/` | Model classes (`ArmMouseModel`, `JoystickInputModel` enum, `TvModel` enum, `VibratorModel`) |
| `hmcp/cloud/` | Cloud session management (`AckOrderBean`, `CloudFileConfig`) |
| `hmcp/device/input/manager/` | `AbstractDeviceInputManager` interface, `TcMouseManager` |
| `hmcp/device/input/operate/` | `AbstractDeviceOperate` interface |
| `hmcp/device/input/view/` | `TcMouseView` |
| `hmcp/device/input/sender/` | `AbsHMInputSender` |
| `hmcp/language/` | `AbsLanguageManager` |
| `hmcp/listeners/` | Listener interfaces for streaming/input events |
| `hmcp/fastjson/` | 138+ Alibaba FastJSON classes (bundled JSON parser) |
| `hmcp/protobuf/` (`proto/`) | 60+ Protobuf message classes (bundled Google Protobuf; `GSSDK` etc.) |
| `hmcp/websocket/` | 15+ WebSocket classes |
| `hmcp/volley/` | Google Volley HTTP classes (bundled) |
| `hmcp/utils/` | Utility classes |
| `hmcp/widgets/` | UI widget classes (`BaseVideoView`, etc.) |
| `hmcp/business/` | Business logic (`TransferHelper`, etc.) |
| `hmcp/countly/` | Countly analytics (`HttpCountly`) |

**Key bean classes (selected; verified in 6.0.4):**

| Class | Fields | Notes |
|---|---|---|
| `AckOrderBean` | 26 | Cloud session acknowledgment |
| `ArmMouseModel` | 26 | ARM mouse control |
| `IntentExtraData` | 16 | Intent payload for session handoff |
| `JoyStickBean` | 31 (button bool + analog) + 14 `JOY_KEY_*` consts | See §9.5.4 |
| `JoyStickMappingConfig` | 35 | Joystick button mapping config |
| `VideoDelayInfo` | 30 | Streaming latency data — see §9.5.3 |
| `GetCloudServiceParametersV2` | 65+ | See §9.5.5 (significantly expanded) |
| `CloudPlayInfo` | 19 (+ `isStatusCodeEnable` protected) | See §9.5.6 |
| `WebSocketConfig` | 11 | WebSocket connection config |
| `X86KeyMapContentConfig` | 12 | x86 keyboard mapping |
| `X86TouchConfig` | 13 | x86 touch input |
| `X86ScreenSlideConfig` | 5 | Screen slide |
| `TouchesMappingConfig` | 6 | Touch mapping |
| `BaseWsMessage` / `BaseWsMessage4JsonParse` | 5 / 5 | Base WS messages |

**Key enums / models:**

| Class | Notes |
|---|---|
| `JoystickInputModel` | Enum — full virtual gamepad state |
| `SwitchStreamTypeData` | Enum — stream-type switching |
| `TvModel` | Enum — display/TV mode |
| `VirtualOperateType` | NONE, VIRTUAL_KEYBOARD, VIRTUAL_STICK_XBOX |

**Analytics (Countly):**

| Config | Value |
|---|---|
| Host | `https://countly.haimacloud.com` |
| API key | `9c0edb3f80d8d9adc71bb544b6dc87743340e829` |
| App ID (foreground) | `12040` |
| App ID (background) | `12041` |
| Additional event IDs | 100+ in range 12050–15489 |

Hardcoded in `com.haima.hmcp.Constants` and `com.haima.hmcp.countly.HttpCountly` (verified in 6.0.4).

#### 9.5.3 `VideoDelayInfo` — 30 streaming-latency fields (unchanged in 6.0.4)

`bitRate`, `clockDiffUse`, `decodeDelay`, `frameSize`, `jankAndFreezeDuration`, `netDelay`, `realFrameRateOutput`, `renderDelay`, `timeStamp`, `videoFps`, `delayTime`, `nowDelayTime`, `receiveFrameCount`, `receiveFrameSize`, `gameFps`, `gameRealFps`, `frameRateEglRender`, `serverEncodeDelay`, `videoCaptureDelay`, `videoEncodeDelay`, `videoDecodeDelay`, `videoRenderDelay`, `audioCaptureDelay`, `audioEncodeDelay`, `audioDecodeDelay`, `audioRenderDelay`, `jitterDelay`, `haimaCpu`, `systemCpu`, `delayFromVideoCapToDecoded`.

Class exposes 30 stored protected fields plus 30+ derived getters (`getAudioBitrate`, `getCodecName`, `getJitterBuffer`, `getPacketsLostRate`, `getPingPongDelay`, `getReceivedBitrate`, `getRoundTrip`, `getVideoInputFps`, `getVideoSendBitrate`, `getVideoSendFps`, etc.) — derived values come from streaming subsystem, not declared as stored fields.

#### 9.5.4 `JoyStickBean` button bitmask constants (unchanged in 6.0.4)

| Constant | Value | Button |
|---|---|---|
| `JOY_KEY_UP` | 1 | D-pad up |
| `JOY_KEY_DOWN` | 2 | D-pad down |
| `JOY_KEY_LEFT` | 4 | D-pad left |
| `JOY_KEY_RIGHT` | 8 | D-pad right |
| `JOY_KEY_START` | 16 | Start |
| `JOY_KEY_SELECT` | 32 | Select |
| `JOY_KEY_LS` | 64 | Left stick click |
| `JOY_KEY_RS` | 128 | Right stick click |
| `JOY_KEY_L1` | 256 | LB |
| `JOY_KEY_R1` | 512 | RB |
| `JOY_KEY_A` | 4096 | A |
| `JOY_KEY_B` | 8192 | B |
| `JOY_KEY_X` | 16384 | X |
| `JOY_KEY_Y` | 32768 | Y |

Analog: `L_X`, `L_Y`, `R_X`, `R_Y` (float), `L2AxisValue`, `R2AxisValue` (Float). Threshold `MOTION_INVALID_VALUE = 0.004921628f`.

#### 9.5.5 `GetCloudServiceParametersV2` — **expanded to 65+ fields in 6.0.4**

> Net-new in 6.0.4: previously 40+ fields, now **65+** to accommodate richer session metadata (anomalous-input telemetry, multi-archive saves, demo-test, dual-resolution variants).

- **String:** `action`, `appChannel`, `appName` (JSON: `"pkg_name"`), `archiveFromBid`, `archiveFromUserId`, `cToken`, `channel`, `clientCity`, `clientISP`, `clientProvince`, `cloudId` (JSON: `"cid"`), `componentName`, `configInfo`, `deviceType`, `envType`, `extraId`, `gameId`, `payStr`, `protoData`, `resolution`, `resolutionName`, `resolutionValue`, `routingIp`, `saveArchiveBidMultiArchive`, `saveArchiveUidMultiArchive`, `viewFrameRate`, `viewResolution`
- **Integer (primitive):** `bitRate`, `clientImeType`, `clientType`, `componentType`, `frameRate`, `imeType`, `orientation`, `streamingMode`, `battleOnlineType`
- **Integer (boxed, nullable):** `demoTestInstanceId`, `demoTestInterfaceId`, `devicePixelRatio`, `gamePad`, `keepAliveTimeSeconds`
- **Boolean (primitive):** `ahead`, `demoTest`, `freeFlowTag`, `isArchive`, `isReapply`, `support2k`, `syncRefresh`, `h264SeiDataReportEnable`
- **Boolean (boxed, nullable):** `disableAutoStream`, `enlargeBitRate`, `finishByServer`, `keepLoginStatus`, `openMultiArchive`, `saveArchiveMultiArchive`
- **Long:** `noInputTimeout`, `playingTime`, `priority`, `timestamp` (boxed)
- **Float:** `anomalousLeft`, `anomalousRight`
- **Complex:** `sdkAbility` (`long[]`), `sdkUserDeviceInfo` (`JSONObject`), `streamingTypes` (`List<String>`), `richData` (`Map`), `extraData` (`IntentExtraData`), `userInfo` (`UserInfo2`)

#### 9.5.6 `CloudPlayInfo` — connection-state booleans

16 connection-state booleans (unchanged): `isGetStreamUrlSuccess`, `isGetCloudServiceSuccess`, `isGetOperationFiveSuccess`, `isTurnOnVideoSuccess`, `isVideoConnectSuccess`, `isAudioConnectSuccess`, `isSignalConnectSuccess`, `isReceiveOffer`, `isSendAnswer`, `isSendCandidate`, `isReceiveCandidate`, `isWebrtcConnectSuccess`, `isWebrtcConnectFailed`, `isWebrtcConnectTimeout`, `isFirstFrameArrival`, `isMatchStreamType`.

Plus public: `pingCount`, `pongCount` (int), `reportStatusCode` (String, default `""`).
Plus protected: `isStatusCodeEnable` (boolean, default `true`).

**HMCP scene strings:** 60+ (`applyCloudInstance`, `battle`, `firstFrameArrival`, `gameMaintenance`, etc.). Color palette: 29 entries (`haima_hmcp_black`, `haima_hmcp_red`, etc.).

The HMCP virtual input overlay also provides an Xbox controller add dialog (`hm_dialog_add_xbox.xml`), virtual keyboard dialog (`hm_dialog_fullkeyboard.xml`), virtual key edit dialog, mouse control, and cloud computer overlay — used for both PC streaming and cloud gaming.

---

### 9.6 In-App Payment

In-app payment combines Apple IAP receipt verification (for iOS-purchased content carryover) with WeChat Pay for Android transactions, plus a Room-backed retry queue for failures. Code root: `com.xiaoji.egggame.features.pay` (new 6.0.4 location, smali_classes4).

**Database:** `db_pending_payment_v1.db` — schema fingerprint `f18683c410e5cd9d73a45330d5a1fb69` (verified in `smali_classes4/com/xiaoji/egggame/features/pay/database/PayDatabase_Impl$createOpenDelegate$_openDelegate$1.smali`).

```sql
CREATE TABLE pending_payment (
    order_no TEXT PRIMARY KEY,
    receipt_data TEXT NOT NULL,
    product_id TEXT NOT NULL,
    goods_id TEXT NOT NULL,
    transaction_id TEXT,
    created_at INTEGER NOT NULL,
    retry_count INTEGER NOT NULL,
    last_retry_at INTEGER,
    last_error TEXT
)
```

Room entity: `com.xiaoji.egggame.features.pay.database.entity.PendingPaymentEntity` (9 fields matching the table 1:1). DAO: `PendingPaymentDao`.

**Pay-flow DTOs (`features/pay/data/`):** `PayRepositoryImpl$OrderResponse`, `PayRepositoryImpl$VerifyAppleReceiptRequest`, `PayRepositoryImpl$CreateOrderRequest`, `WXPayment`.

**WeChat Pay error codes** (`com.xiaoji.egggame.wxapi.WXPayEntryActivity`, classes5.dex):

| Code | Meaning |
|---|---|
| 0 | Success |
| -1 | Failed |
| -2 | Cancelled |

**Active WeChat App IDs** (verified in `smali_classes4/jwb.smali` + `smali_classes5/wl5.smali`):
- Primary: `wx2075ef952b9b60c4`
- Secondary: `wxf9d9756e4f820261`

**Alipay App ID:** `2021005104662679` (verified in `AndroidManifest.xml` `com.alipay.sdk.appId` meta-data).

---

### 9.7 Card System

`com.xiaoji.egggame.cardsystem` — mini game launcher / promotional content system. All card wire data is `kotlinx.serialization`-encoded; persisted snapshots use Room.

#### 9.7.1 `Card` model — 43 fields (extracted from `Card$$serializer.java`, classes3.dex)

| # | Field | Required? |
|---|---|---|
| 1 | `leaderboard_info` | required (nullable) |
| 2 | `card_param` | required |
| 3 | `card_tag` | required |
| 4 | `game_op_tag` | required |
| 5 | `card_type` | required |
| 6 | `content_img` | required |
| 7 | `currency_symbol` | required |
| 8 | `discount` | required |
| 9 | `company` | required |
| 10 | `discount_price` | required |
| 11 | `end_time` | required |
| 12 | `game_back_image` | required |
| 13 | `hero_capsule` | optional |
| 14 | `game_channel_params` | required |
| 15 | `game_cover_image` | required |
| 16 | `game_price` | required |
| 17 | `review_score` | required |
| 18 | `game_startup_params` | required |
| 19 | `game_tag` | required |
| 20 | `game_type` | required |
| 21 | `game_show_types` | optional |
| 22 | `game_video_url` | required |
| 23 | `id` | required |
| 24 | `is_pay` | required |
| 25 | `jump_type` | required |
| 26 | `platform` | required |
| 27 | `release_text` | required |
| 28 | `square_image` | required |
| 29 | `subtitle` | required |
| 30 | `sys_language_id` | required |
| 31 | `title` | required |
| 32 | `topic_id` | required |
| 33 | `weight` | required |
| 34 | `news_publisher` | required |
| 35 | `news_published_time` | required |
| 36 | `news_content` | required |
| 37 | `steam_app_id` | required |
| 38 | `fallback_icon` | optional |
| 39 | `server_game_id` | optional |
| 40 | `source_id` | optional |
| 41 | `source_type` | optional |
| 42 | `epic_app_name` | optional |
| 43 | `classify_icons` | optional |

> 6.0.4 schema/order difference vs 6.0.0 listing: positions 28-32 are `square_image`, `subtitle`, `sys_language_id`, `title`, `topic_id` — `square_image` slot reordered up; `news_*` cluster now lives at slots 34-36. Field count unchanged at 43.

#### 9.7.2 Supporting models

| Class | Purpose |
|---|---|
| `CardData` | Card container |
| `CardListData` | Paginated card list |
| `CardTag` | Card category/tag |
| `GameChannelParam` | Game channel parameters |
| `GameStartupParam` | Game launch configuration |
| `LeaderboardInfo` | Leaderboard metadata |
| `NewDetail` | Detail panel data |
| `OpTags` | Operation tags |
| `StartExt` | Launch extensions |

**Room persistence (6.0.4):** `com.xiaoji.egggame.core.database.entity.CardEntity` — 36 private final fields mirroring the `Card` wire model (drops the news_* triplet, `classify_icons`, server_game_id, `source_id`, `source_type`, and `fallback_icon` from the persisted snapshot, plus splits / renames a few to local-DB column conventions).

Fonts: AlimamaShuHeiTi Bold, D-DIN Pro (6 weights), MiSans (cardsystem module).

---

### 9.8 Virtual Joystick (VJoy)

`InputMapping` (sealed base in `com.xiaoji.egggame.common.ui.vjoy.model`) with 5 nested types for binding virtual controls to physical input:

| Type | Maps to |
|---|---|
| `InputMapping.Directional` | analog stick / D-pad direction |
| `InputMapping.Gamepad` | physical gamepad button |
| `InputMapping.Keyboard` | keyboard key |
| `InputMapping.Macro` | multi-input macro sequence |
| `InputMapping.Mouse` | mouse button / movement |
| `InputMapping.None` | unbound (used as defaults) |

#### 9.8.1 Layout / control data classes (full field lists, 6.0.4)

| Class | Fields |
|---|---|
| `VJoyLayout` | **9** — `formatVersion` (opt, default 2), `id`, `name` (`LocalizedString`), `description` (opt, default empty), `meta` (opt), `layers` (opt, `List<VJoyLayer>`), `controls` (opt, `List<VJoyControl>`), `activeLayerIndex` (opt), `nextLayerIndex` (opt) |
| `VJoyControl` | **7** — `id`, `type`, `position`, `appearance` (opt, defaulted via 42-arg ctor), `mapping` (opt, default `InputMapping.None`), `action` (opt, `ControlAction`), `properties` (opt, `Map<String, String>`) |
| `VJoyIconConfig` | `iconName`, `displayName` (opt), `scale` (opt), `tint` (opt), `alpha` (opt), `scaleMode` (opt) — 6 |
| `ControlPosition` | `x`, `y`, `width` (opt), `height` (opt), `scale` (opt), `rotation` (opt), `anchor` (opt) — 7 |
| `ControlAppearance` | **42** — see below (was 30 in 6.0.0) |
| `MacroConnection` | `id`, `fromNodeId`, `toNodeId` — 3 |
| `VJoyLayer` *(new)* | per-layer container of controls (used by `VJoyLayout.layers`) |
| `ControlAction` *(new)* | discrete action descriptor attached to a control (e.g., switch-layer, run-macro) |
| `VJoyTextAlign` *(new)* | text alignment enum used by label idle/pressed alignment |

**`ControlAppearance` — 42 fields in 6.0.4** (all optional unless noted; **12 fields new vs 6.0.0**, marked ★):
`label`, `fillColor`, `strokeColor`, `strokeWidth`, `alpha`, `activeAlpha`, `shape`, `cornerRadius`, `sides`, `stickFillColor`, `stickStrokeColor`, `stickStrokeWidth`, `innerIcon`, `outerIcon`, `activeInnerIcon`, `activeOuterIcon`, `icon`, `activeIcon`, `interactionStyles`, `activeColor`, `idleStrokeColor`, `pressedStrokeColor`, `pressedFillColor`, `glowWidth`, `stickIdleStrokeColor`, `stickPressedFillColor`, `stickPressedStrokeColor`, `stickGlowWidth`,
**★** `labelIdleAlign`, **★** `labelIdleColor`, **★** `labelIdleSize`, **★** `labelIdleWeight`, **★** `labelPressedAlign`, **★** `labelPressedColor`, **★** `labelPressedSize`, **★** `labelPressedWeight`, **★** `subItemFillColor`, **★** `subItemGlowWidth`, **★** `subItemPressedFillColor`, **★** `subItemPressedStrokeColor`, **★** `subItemStrokeColor`, **★** `subItemStrokeWidth`.

> Net-new in 6.0.4: full typography on idle/pressed label states (alignment, size, weight) and a parallel `subItem*` chrome group, plus per-layer layouts (`VJoyLayer`, `layers`, `activeLayerIndex`, `nextLayerIndex`) and a `ControlAction` slot on each control.

#### 9.8.2 UI model enums (`com.xiaoji.egggame.common.ui.vjoy.model`)

| Enum | Values |
|---|---|
| `GamepadButton` | A, B, X, Y, LB, RB, LT, RT, Select, Start, DpadUp, DpadDown, DpadLeft, DpadRight, LeftStick, RightStick, LeftStickClick, RightStickClick |
| `ControlType` | Button, Joystick, Trigger, Bumper, DPad, Touchpad |
| `ControlShape` | Shape definitions for virtual controls (default `Rectangle`) |
| `DPadDirection` | Up, Down, Left, Right, UpLeft, UpRight, DownLeft, DownRight |
| `Anchor` | Positioning anchors for VJoy UI elements |
| `KeyboardButton` | Keyboard key mappings for virtual keyboard |
| `IconScaleMode` | Icon scaling strategies |
| `InteractionStyle` | User interaction style definitions (default set `Ripple`) |
| `VJoyTextAlign` *(new)* | Label alignment (idle / pressed) |
| `VJoyLayoutType` | Common, Game (at `com.xiaoji.egggame.features.vjoy.ui.main.base.model.enums.VJoyLayoutType`) |

#### 9.8.3 Event consumers + callbacks

`VJoyButtonEventConsumer`, `VJoyAxisEventConsumer`, `VJoyDPadEventConsumer`, `VJoyEventCallbacks`, `VJoyEvent`, `VJoyLayoutSaveReceipt`, `MacroNode`, `LocalizedString`, plus chrome defaults: `VButtonChromeDefaults`, `DPadChromeDefaults`, `JoystickChromeDefaults`, `TouchpadChromeDefaults`.

---

### 9.9 In-Game Performance HUD

The HUD overlay (`com.winemu.ui.HUDLayer`) is populated by polling each metric on a timer via `HudDataProvider`. Full details in `gamehub_reports/GAMEHUB_HUD_DATA_SOURCES.md`.

#### 9.9.1 `HudData` model

```kotlin
data class HudData(
    val ramPercent:        Int,
    val gpuPercent:        Int,
    val fps:               Int,
    val cpuPercent:        Int,
    val isCharging:        Boolean,
    val powerMW:           Float,
    val tempC:             Float,
    val isDirectRendering: Boolean,
    val fpsHistory:        List<Int>
)
```

`HUDConfig` (`com.winemu.ui.HUDConfig`, classes3.dex, 6.0.4 verified) — 8 boolean toggles, default true except `dualBattery`:
`showGPU`, `showCPU`, `showRAM`, `showPower`, `showTemperature`, `showFPS`, `showFPSGraph`, `dualBattery`.

`HudData` Compose mirror (`com.xiaoji.egggame.common.winemu.bean`): `ramUsagePercent`, `gpuUsagePercent`, `fps`, `cpuUsagePercent` (int), `isCharging` (bool), `powerMilliwatts`, `temperatureCelsius` (float), `isDirectRenderingEnabled` (bool), `fpsHistory` (`List<Float>`).

#### 9.9.2 Data sources

| Metric | Source | API / Path |
|---|---|---|
| Battery % | Android `BatteryManager` | `getIntProperty(4)` — BATTERY_PROPERTY_CAPACITY |
| Battery watts | `BatteryManager` + `BATTERY_CHANGED` | `voltage_mV × current_µA / 1,000,000` (×2 if charging) |
| Charging state | `BATTERY_CHANGED` broadcast | `Intent.getIntExtra("plugged")` |
| GPU load % | Qualcomm KGSL sysfs | `/sys/class/kgsl/kgsl-3d0/gpubusy` (Adreno only) |
| RAM % | `ActivityManager` | `getMemoryInfo()` → (total − avail) / total × 100 |
| Temperature | sysfs thermal zone scan | `/sys/class/thermal/thermal_zoneN/temp` (19 paths tried) |
| FPS | WinEmu native (JNI) | `IHudDataProvider.c()` via `libwinemu.so` |
| Direct Rendering | WinEmu native (JNI) | `IHudDataProvider.b()` via `libwinemu.so` |

Native lib (verified in 6.0.4): `lib/arm64-v8a/libwinemu.so` — **658,320 bytes**.

---

### 9.10 Performance Telemetry

In-process performance samples flow through a 3-layer wire format from the WinEmu HUD backend to the analytics endpoint at `events/device-performance-config` (Firebase datatransport). Code root in 6.0.4: `com.xiaoji.egggame.features.winemu.perf` (classes4.dex).

#### 9.10.1 `CapturedPerfSample` — 13 fields (in-memory snapshot)

`userId`, `agreement`, `gameId`, `sourceType`, `sourceGameId`, `capturedAtWallClockMs`, `sessionDurationSec`, `fps` (int), `pwr` (float, watts), `ramMb` (int), `gpuPercent` (int), `cpuPercent` (float), `tmpCelsius` (int).

#### 9.10.2 `StoredPerfSample` — 16 fields (locally persisted with retry envelope)

Adds `schemaVersion` (optional, default 1) + `seq` (sequence id), and includes `sessionId` (not in `CapturedPerfSample`), on top of the captured field set. Full order: `schemaVersion`, `seq`, `sessionId`, `userId`, `agreement`, `gameId`, `sourceType`, `sourceGameId`, `capturedAtWallClockMs`, `sessionDurationSec`, `fps`, `pwr`, `ramMb`, `gpuPercent`, `cpuPercent`, `tmpCelsius`.

#### 9.10.3 `DevicePerfReportDataDto` — 13 fields (wire DTO, snake_case)

`agreement`, `gameId` (JSON: `KEY_GAME_ID`), `source_type`, `source_game_id`, `fps`, `pwr` (float), `ram`, `gpu`, `cpu` (float), `tmp`, `session_duration`, `session_id`, `config` (`PerfConfigSnapshot` — optional, nullable).

#### 9.10.4 `DevicePerfReportEventDto` — outer envelope

`event_type`, `userId`, `data` (the `DevicePerfReportDataDto`).

#### 9.10.5 `PerfSessionMeta` — 12 fields (session-level metadata)

`schemaVersion` (opt, default), `sessionId`, `userId`, `agreement`, `gameId`, `sourceType`, `sourceGameId`, `sessionStartElapsedMs`, `sessionStartWallClockMs`, `configSnapshot` (`PerfConfigSnapshot`), `configAcked` (opt), `pendingCount` (opt).

#### 9.10.6 `PerfConfigBodySnapshot` — 12 fields (config in effect during session)

`container_id`, `component_ids`, `translations` (`PerfTranslationsSnapshot` — `box64`/`fex` opt), `controller` (`PerfControllerSnapshot` — `dinput`/`xinput`/`xboxLayout`/`vibration` opt), `audio_driver`, `cpu_limitations`, `video_memory`, `directx_panel`, `start_param`, `environment`, `surface_format`, `disable_window_manager`.

---
## 10. DTO Inventory

All kotlinx-serializable DTOs verified by counting `Lr0h;->j(...)` element registrations in the corresponding `$$serializer.smali` files. (R8 strips the visible Kotlin data class but preserves the `$$serializer` + `Companion` singletons, so field count is recovered from the serializer descriptor.) `Companion` accessors observed for every entry below.

### 10.1 Base response wrappers (`core/network/model/`)

| Class | Fields |
|---|---|
| `BaseResult<T>` | 4 — `code` (Int?), `msg` (String?), `time` (String?), `data` (T?) |
| `BasePageResult<T>` | 4 — `list` (List\<T\>?), `total` (Long?), `page` (Int?), `pageSize` (Int?) |
| `BaseFirmwareResult<T>` | 4 — `status` (Int?), `update_time` (Int?), `update_status` (Long?), `data` (T?) |
| `RefreshResponse` | Live at `smali_classes4/com/xiaoji/egggame/core/network/token/RefreshResponse$$serializer.smali` — kotlinx.serialization DTO in the `network/token/` package (it was never a Room entity, so the earlier "missing in DDL" finding was a baseline classification error) |
| `RefreshResponseData` | Live at `smali_classes4/com/xiaoji/egggame/core/network/token/RefreshResponseData$$serializer.smali` — same package, same classification correction |

### 10.2 Auth DTOs (`auth/dto/`)

| Class | Fields |
|---|---|
| `EmailLoginRequestDto` | 2 — `email`, `captcha` |
| `SmsLoginRequestDto` | 3 — `mobile`, `captcha`, `zone` |
| `SmsLoginDataDto` | 1 |
| `OneMobileLoginRequestDto` | 1 — `accessToken` |
| `SendSmsCodeRequestDto` | 3 — `mobile`, `event`, `zone` |
| `BindMobileRequestDto` | 3 — `mobile`, `captcha`, `zone` |
| `UpdateMobileRequestDto` | 3 — `mobile`, `captcha`, `zone` |
| `BindAppleRequestDto` | 7 |
| `BindGoogleRequestDto` | 7 |
| `BindQQRequestDto` | 7 |
| `BindWechatRequestDto` | 7 |
| `WechatTokenResponseDto` | 8 |
| `ThirdPartyBindExtInfoDto` | 2 |
| `ThirdPartyLoginRequestDto` | 7 — `platform`, `openid`, `extinfo?`, `openkey?`, `secretkey?`, `unionid?`, `access_token?` |
| `RemoteUserDto` | 28 |
| `RemoteUserBoundPlatformDto` | 21 |

`RemoteUserDto` and `RemoteUserBoundPlatformDto` field name list unchanged from 6.0.0/6.0.1 — see baseline document.

### 10.3 Profile DTOs (`profile/dto/`)

| Class | Fields |
|---|---|
| `ProfileUpdateRequestDto` | 4 — `bio`, `username`, `avatar`, `avatar_colour` |
| `BindEmailRequestDto` | 2 — `email`, `captcha` |
| `EmailCaptchaRequestDto` | 2 — `email`, `event` |
| `VerifyIdAuthRequestDto` | 2 — `real_name`, `id_card` (Chinese real-name verification) |
| `VerifyIdAuthResponseDto` | 4 |
| `VerifyIdStatusResponseDto` | 10 |

### 10.4 Device / gamepad DTOs (`device/dto/`)

| Class | Fields |
|---|---|
| `DeviceMenuRequestDto` | 1 — `devices_id` |
| `DeviceMenuDto` | 4 |
| `DeviceVariantRequestDto` | 2 |
| `DeviceVariantDto` | 2 |
| `GetDevicesRequestDto` | 1 — `devices_name` |
| `GetDevicesDataDto` | 3 |
| `TutorialNetworkDto` | 2 — `id`, `name` |
| `GetDevicesSubMenuDto` | 6 — `menu_id`, `name`, `logo_img_active`, `logo_img_gary`, `jump_url`, `is_click` |
| `SubMenuItemDto` | 7 — `menu_id`, `name`, `logo_img_active`, `logo_img_gary`, `jump_url`, `is_click`, `sub_config` |
| `ProductDocNetworkDto` | 3 — `id`, `name`, `list` |

**`SubConfigDto`** — gamepad controller configuration, **70 fields** (matches 6.0.0/6.0.1):
- **Trigger:** `leftTriggerDeadZone`, `rightTriggerDeadZone`, `leftTriggerPressed`, `leftTriggerSync`, `rightTriggerPressed`, `rightTriggerSync`
- **Joystick:** `leftDeadZone`, `leftOriginalZone`, `leftSwopDPad`, `lJsInversionXAxis`, `lJsInversionYAxis`, `lJsReverseDeadZone`, `rightDeadZone`, `rightOriginalZone`, `rJsInversionXAxis`, `rJsInversionYAxis`, `rJsReverseDeadZone`, `joystickSwap`, `inversionXYAxis`, `diagonalLock`
- **Mode:** `leftQuickMode`, `rightQuickMode`, `layoutType`, `leftGrip`, `rightGrip`, `leftTrigger`, `rightTrigger`, `experienceGrip`, `experienceTrigger`
- **Lighting:** `lightingEffect`, `leftLightRingColor`, `rightLightRingColor`, `buttonLights`, `homeLight`, `lampStripLight`, `lightRingSync`
- **System:** `sleepTime`, `lowBatteryDisplay`, `autoOnOffOnDock`
- **Buttons:** `gamepadTest`, `gamepadKey`, `otaUpdate`, `gamepadReset`, `gamepadTutorial`, `productManual`, `l4Mapping`, `r4Mapping`, plus 30+ more

`DeviceInfoDto` (`common/gamepadconnect/data/dto/`, 21 fields — unchanged): `id`, `name`, `deviceName`, `deviceImage`, `deviceType`, `firstDeviceType`, `isOfficial`, `connectionFailureText`, `firstStartText`, `keyOperationImage`, `keyOperationIcon`, `quickAccessImage`, `quickAccessIcon`, `gameMuteImage`, `gameMuteIcon`, `devicePermissionsImage`, `devicePopImage`, `deviceConnectionImage`, `adaType`, `extras`, `handleType`.

### 10.5 Feedback DTOs (`feedback/dto/`)

`FeedbackSubmitRequestDto` (11 fields, unchanged): `account`, `contents`, `images`, `videos`, `mobile_model`, `system_ver`, `app_ver`, `device_model`, `mac_address`, `firmware_ver`, `mapping_text`.

### 10.6 Cloud / VTouch DTOs

- `CloudAppExchangeCodeRequestDto` (`cloud/dto/`, 1 field): `cdkey` (activation code)
- `ModeNoticeDto` (`vtouch/dto/`, 2 fields): `img`, `title`
- `StartTypeRequestDto` (`vtouch/dto/`, 4 fields) — net-new vs baseline
- `StartTypeResponseDto` (`vtouch/dto/`, 2 fields) — net-new vs baseline

### 10.6a BaseInfo DTOs (`baseinfo/dto/`) — package move verified

The 6.0.1 move of `BaseInfoDto` from `core.domain.base.*` to `core.network.model.baseinfo.dto.*` is **preserved in 6.0.4**:

| Class | Fields | Field names |
|---|---|---|
| `BaseInfoDto` | 4 | `GameHubRetroGamesHidden`, `GameHubSteamGamesHidden`, `GameHubEpicGamesHidden`, `steam_url_replace` |
| `SteamUrlReplaceItemDto` | 2 | `cn`, `global` |

### 10.6b Setting / upgrade / upload / vjoy / zonecode DTOs (net-new section)

These subdirectories under `core/network/model/` were not enumerated in the 6.0.0/6.0.1 baseline document. All present in 6.0.4:

| Class | Path | Fields |
|---|---|---|
| `SettingsNotifySwitchDto` | `setting/dto/` | 3 |
| `SettingsNotifySwitchRequestDto` | `setting/dto/` | 3 |
| `AppUpgradeDto` | `upgrade/dto/` | 11 |
| `AppUpgradeRequestDto` | `upgrade/dto/` | 3 |
| `UploadResultItemDto` | `upload/dto/` | 1 |
| `DeleteMapRequestDto` | `vjoy/dto/` | 1 |
| `GetMapByShareCodeRequestDto` | `vjoy/dto/` | 1 |
| `ShareMapRequestDto` | `vjoy/dto/` | 3 |
| `VirtualJoyDownloadUrlResponseDto` | `vjoy/dto/` | 1 |
| `VirtualJoyListItemDto` | `vjoy/dto/` | 10 |
| `VirtualJoyListRequestDto` | `vjoy/dto/` | 4 |
| `VirtualJoySearchListRequestDto` | `vjoy/dto/` | 4 |
| `VirtualJoyShareRequestDto` | `vjoy/dto/` | 6 |
| `VirtualJoyShareResponseDto` | `vjoy/dto/` | 1 |
| `VirtualJoyUploadDataDto` | `vjoy/dto/` | 5 |
| `MobileCodeItemDto` | `zonecode/dto/` | 4 |

### 10.7 Domain models (`core/domain/`)

| Class | Path | Fields |
|---|---|---|
| `AppUpgrade` | `upgrade/model/` | 11 — `id`, `version`, `versionCode`, `channelIds`, `upgradeMsgZh`, `upgradeMsgEn`, `downloadUrl`, `upgradeType`, `fileMd5`, `fileSize`, `createdTime` |
| `SearchRequest` | `search/model/` | 5 — `keywords`, `classify_group_id?`, `top_category_id?`, `page?`, `page_size?` |
| `SearchBean` / `SearchHotRequest` / `SearchHotRes` / `SearchHotTrendingRes` | `search/model/` | TBD-§10.7 (net-new domain DTOs vs baseline) |
| `AllGameId` / `Display` / `GameChannelParam` / `Total` | `search/model/` | TBD-§10.7 (net-new) |
| `LeaderBoardCategories` / `LeaderBoardCategoryItem` / `LeaderBoardItem` / `LeaderBoardListRequest` / `LeaderBoardRes` | `leaderboard/model/` | LeaderBoardItem=12, LeaderBoardListRequest=4 |
| `PendingActivityTaskContext` | `activitytask/model/` | 9 — in-app task/event context |
| `ActivityTaskProgressSnapshot` | `activitytask/model/` | TBD-§10.7 (net-new) |
| `SaveInterestTagsRequest` | `hometab/model/` | included in hometab cluster |
| `CustomPageGameItem` / `CustomPageGameListRequest` / `CustomPageGameListRes` / `HomeTabClassify` / `IndexListRequest` / `NewsRequest` / `OpResItem` / `OpResListData` / `OpResListRequest` / `RecommendGameRequest` / `RecommendGameRes` | `hometab/model/` | TBD-§10.7 (net-new domain cluster) |
| `EventParam` | `bi/` | 3 — `user_id`, `event_type`, `data` |
| `CommunityItem` | `community/model/` | TBD-§10.7 (net-new) |
| `DeviceDocListRequest` | `device/model/` | TBD-§10.7 (net-new) |
| `SteamGameLaunchMetadata` | `model/steam/` | 2 |
| `SteamExecutableInfo` / `SteamLaunchOption` | `model/steam/` | TBD-§10.7 (net-new) |
| `ServerGameId` | `id/` | typed server game ID |
| `LibraryGameId` | `id/` | typed local game ID |
| `GameKey` | `id/` | net-new typed identifier |
| `UnzipArgs` | `unzip/` | TBD-§10.7 (net-new) |
| `VJoyFeedPage` | `vjoy/model/` | TBD-§10.7 (net-new) |

> **Note:** `SteamUrlReplaceItem` (domain version) is no longer present as a domain-package class in 6.0.4; the 6.0.1 move to `network/model/baseinfo/dto/SteamUrlReplaceItemDto` is the only surviving location (see §10.6a).

### 10.8 Game API DTOs (`game/data/remote`)

| Class | Fields | Notes |
|---|---|---|
| `GameDetailEntity` | **35** | Was "34+" in baseline; full count confirmed via serializer |
| `GameDetailPlatformEntity` | **40** | Was "40+" in baseline; full count confirmed |
| `GameDetailReArgs` | TBD-§10.8 | Net-new request DTO |
| `GameStartupParam` (game) | 13 | startName, startIcon, startEIcon, startSIcon, newIcon, newCIcon, startType, jumpType, isAutoGame, downTypeDesc, startExt, gameFileSize, fileSize |
| `LocalImportGameArgs` | TBD-§10.8 | Net-new |
| `PcGamePlayTimeEntity` | 10 | gameId, steamAppid, sourceGameId, sourceType, gameName, coverImage, squareImage, totalSeconds, last14DaysSeconds, lastStartTime |
| `CloudGamePlayTimeEntity` | 5 | userId, gameId, totalTime, lastStartTime, updateTime |
| `CompatibilityInfo` | 5 | title, icon, desc, level, data (List\<CompatibilityItem\>) |
| `CompatibilityItem` | 4 | title, desc, level, isCheck |
| `GameCategoryGroupsResponse` | 1 | list wrapper |
| `GameCtsReportReArgs` | 5 | gameId, ctsLevel, comment, ctsInfo, generalInfo |
| `ShareLinkEntity` | 2 | sourceType, link |
| `ShareLinkReArgs` | TBD-§10.8 | Net-new |
| `StartExt` (game) | TBD-§10.8 | New class in game/data/remote vs baseline (was only in home/) |

`LocalGameInfoSvrEntity` (`game/domain/model/`) — **corrected to 9 fields** (baseline said 10): `game_id`, `steam_appid`, `name`, `logo`, `cover_image`, `back_image`, `description`, `square_image`, `hero_capsule`. Verified identical in 6.0.1 and 6.0.4 — 6.0.0 baseline count was off by one.

### 10.9 Home API DTOs (`home/data/remote`)

| Class | Fields |
|---|---|
| `RetroGameInfoEntity` | 24 |
| `GameStartupParam` (home) | 5 — `startName`, `startType`, `jumpType`, `fileSize`, `startExt` |
| `StartExt` | 4 — `startRes`, `exePath`, `pkgName`, `kernel` |
| `RetroPlatform` | 3 — `id`, `platform`, `platformText` |
| `PlayGameEntity` | 6 — `id`, `title`, `imageUrl`, `tags`, `description`, `isPopular` |
| `UserPlayInfoEntity` | 6 — `username`, `avatarUrl`, `playTimeHours`, `playTimeMinutes`, `isCheckedIn`, `checkInDesc` |
| `RetroGameDetailReArgs` | 1 — `id` (long) |
| `RetroGameListReArgs` | 3 — `classifyGroupType`, `page`, `pageSize` |

### 10.10 WebView activity bridge DTOs (`features/webview`)

| Class | Path | Fields |
|---|---|---|
| `ActivityTaskTriggerRequestDto` | `data/activitytask/` | 2 |
| `ActivityBridgeClientParamsResponse` | `ui/webview/` | 4 |
| `ActivityBridgeStatusResponse` | `ui/webview/` | 3 |
| `ActivityBridgeTokenResponse` | `ui/webview/` | 4 |
| `GamePlayTimeEntry` | `ui/webview/` | 2 |
| `GamePlayTimeResponse` | `ui/webview/` | 2 |

**Corrected:** the Java↔JS bridge class is renamed by R8 in 6.0.4. The 6.0.0/6.0.1 baseline cited `defpackage.ix`; in 6.0.4 it is `defpackage.kx` (`Lkx;`). The injection name (`androidJsBridge`) and method shapes are unchanged:

| Method | Signature | Notes |
|---|---|---|
| `call(String)` | single-arg JS-call channel | Logs at TRACE; dispatches to internal JS-bridge handler |
| `callAndroid(int, String, String)` | three-arg JS-call channel | Used by older H5 endpoints expecting `(actionCode, payload, extras)` |

WebView injection literal `androidJsBridge` confirmed at `smali_classes3/kx.smali` plus `postMessage` JS shim at `smali/fmj.smali`. (Retro emulator uses a different JS bridge — see §9.4.2.)

### 10.11 Retro game settings (`retro_emulators/util/setting`)

`RetroGameSettings` (3 fields, unchanged — `keyboardTheme`, `platform`, `core`):
- `keyboardTheme` (int): `1` = white (default), `2` = black
- `platform` (String?) — emulator platform (gb/gba/...)
- `core` — RetroArch core selection

Constants: `KEYBOARD_THEME_WHITE=1`, `KEYBOARD_THEME_BLACK=2`.

---

## 11. Storage

### 11.1 Room databases (complete inventory)

| Database file | Module / class | Purpose |
|---|---|---|
| `egggame.db` | `core.database.AppDatabase` (built via `Lsu2;`) | Main app DB |
| `db_game_library.db` | `game.database.GameLibraryDatabase` (built via `Lbv2;`) | Game library — `t_game_library_base`, `t_game_install_state`, `t_game_launch_method`, `t_game_cover_override` |
| `ux_db.db` | accessed via `Lmqc;` UX manager | UX preferences/state |
| `retro_emu_games.db` | `retro_emulators.data.local.RetroGameDatabase` | `retro_games` + `retro_game_sessions` |
| `cloud_game_sessions.db` | `cloud.data.local.CloudGameDatabase` | `cloud_game_sessions` (+ cloud_timer if present) |
| `epic_storage.db` | `common.epic.storage.EpicStorageDatabase` (built via `Ljv5;`) | `epic_app_price` + `epic_offer_identity` |
| `db_pending_payment_v1.db` | `features.pay.database.PayDatabase` | `pending_payment` — IAP retry queue |
| `db_bi_event_v1.db` | `common.bi.database.BiEventDatabase` | BI analytics event queue — `bi_event_queue` |
| `exoplayer_internal.db` | androidx.media3 | ExoPlayer media cache |
| `countly.db` | Haima Countly | `countly_table` — analytics queue |
| `networkkit.db` + `networkkit_dynamic.db` | Huawei HMS | Network kit routing |
| `google_app_measurement.db` + `_local.db` | Firebase | Firebase Analytics |
| `_monitor.db` + `monitor.db` | internal | Internal monitoring |
| `sdk_report.db` | MobPush/SDK | SDK event reporting |
| `traffic.db` | internal | Network traffic stats |
| `elp_msg.db` | FlyID (cn.fly.tcp) | FlyID TCP long-lived persistent message store |
| `MessageInfo.db` | Xiaomi MiPush | Mi push message store |

> **Corrected:** `bi_event_queue` is hosted in **its own** `db_bi_event_v1.db` (`BiEventDatabase`), not as a DAO under `AppDatabase`. The 6.0.0 baseline's "egggame.db includes `bi_event_queue`" entry was already wrong in 6.0.1 (`AppDatabase` exposes 12 DAOs, none of them BI). Reverified for 6.0.4 — same split.
>
> **Corrected:** the BI table is named `bi_event_queue` (not `bi_queued_event` as the baseline §11.1 SQL snippet claimed). Schema matches but the table name in the baseline was wrong.

> vJoy tables (`virtual_icon_asset`, `virtual_icon_collection`, `virtual_icon_node`, `virtual_icon_node_closure` (closure tree), `virtual_key_layout`, `virtual_key_layout_binding`) live in **`egggame.db`** under `AppDatabase` — verified via `x70.smali` (the multiplexed `RoomOpenHelper.Delegate`). `virtual_icon_asset` is **present**: full DDL at `smali_classes4/jud.smali:405` (24 columns + 6 indexes at lines 567/576/585/594/603/612); sister table `virtual_icon_group` at `jud.smali:401`. The earlier "missing from CREATE TABLE list" finding was a scan miss, not a fold.

**Identity hashes (schema fingerprints) — net-new for 6.0.4:**

| Database | Identity hash | Source |
|---|---|---|
| Database | Identity hash | Legacy hash | Schema version | `Lx70;` ctor index (field `a:I`) |
|---|---|---|---|---|
| `cloud_game_sessions.db` (`CloudGameDatabase`) | `7a80706627ce65e09a31e2d577435a90` | `a73b537891177197a3803048fbaa3716` | 1 | 0 |
| Epic storage DB (`EpicStorageDatabase` — co-located filename via Companion) | `2b2dfc25da8d40a38a2b9d86c86a4212` | `69bd9e3688dba499b6d86df3f1941274` | 1 | 1 |
| `egggame.db` (`AppDatabase`) | `5aaa26f9fd4d97166b494cdbd640c2f6` | `fd103450836de3f8a6e29cc7a8efb58c` | 9 | 2 |
| `db_game_library.db` (`GameLibraryDatabase`) | `483d9ab0c9275aade2c0d789ccbb8a1c` | `5a0f9c19bf179fa948334d058657d46d` | 11 | 3 |
| `db_bi_event_v1.db` | `2af3da1aafcbd3ca616fc5cbf110c51d` | — | (own delegate) | — (not via `Lx70;`) |
| `db_pending_payment_v1.db` | `f18683c410e5cd9d73a45330d5a1fb69` | — | (own delegate) | — |
| `retro_emu_games.db` | `78db956364e981c6e2e471039c99c41b` | — | (own delegate) | — |

> `Lx70;` is an **R8-coalesced OpenDelegate** (extends `Lhzi;`) that serves four Room databases via four overloaded constructors at `x70.smali:13 / 32 / 51 / 72`, each calling `Lhzi;-><init>(I identityHash, String legacyHash, String hash)` with a different `(identityHash, legacyHash, version)` triple. The runtime branch happens later inside `createAllTables` / `dropAllTables` / `onOpen` / `onPreMigrate` / `onValidateSchema` via `packed-switch` on `Lx70;->a:I` (values 0..3). `BiEventDatabase`, `PayDatabase`, and `RetroGameDatabase` each have **their own** `*_Impl$createOpenDelegate$_openDelegate$1` inner class — they are not funneled through `Lx70;`.

#### 11.1.1 `AppDatabase` (egggame.db) DAO list

**Corrected:** **12 DAOs** (baseline claimed 13 — the imagined `biEventQueueDao()` does not exist on `AppDatabase`; BI lives in its own database).

| DAO | Entity / Purpose |
|---|---|
| `apiCacheDao()` | `api_cache` — HTTP response cache |
| `authTokenDao()` | `auth_token` — JWT tokens |
| `cardDao()` | `cards` — home/launcher cards |
| `downloadTaskDao()` | `download_tasks` — download queue |
| `pcGameHistoryDao()` | `pc_game_history` — PC play history |
| `userDao()` | `user_account` — user profile |
| `userThirdAccountDao()` | `user_third_account` — linked social accounts |
| `virtualIconCollectionDao()` | `virtual_icon_collection` — vJoy icon sets |
| `virtualIconNodeClosureDao()` | `virtual_icon_node_closure` — tree hierarchy |
| `virtualIconNodeDao()` | `virtual_icon_node` — icon nodes |
| `virtualKeyLayoutBindingDao()` | `virtual_key_layout_binding` — layout→game bindings |
| `virtualKeyLayoutDao()` | `virtual_key_layout` — key layout configs |

#### 11.1.1a `GameLibraryDatabase` (db_game_library.db) DAO list

| DAO | Entity |
|---|---|
| `gameLibraryBase()` | `t_game_library_base` |
| `gameLaunchMethod()` | `t_game_launch_method` |
| `gameInstallState()` | `t_game_install_state` |
| `gameCoverOverride()` | `t_game_cover_override` (**net-new in 6.0.4 — table not in 6.0.0 baseline**) |

#### 11.1.1b Other DAO surface

| Database | DAO method | Entity |
|---|---|---|
| `EpicStorageDatabase` | `priceDao()` | `epic_app_price` |
| `EpicStorageDatabase` | `offerIdentityDao()` | `epic_offer_identity` |
| `CloudGameDatabase` | `cloudGameSessionDao()` | `cloud_game_sessions` |
| `RetroGameDatabase` | `retroGameDao()` | `retro_games` |
| `RetroGameDatabase` | `retroGameSessionDao()` | `retro_game_sessions` |
| `PayDatabase` | `pendingPaymentDao()` | `pending_payment` |
| `BiEventDatabase` | `queuedEventDao()` | `bi_event_queue` |

#### 11.1.2 Key entity field counts

| Entity | Fields | Notes |
|---|---|---|
| `CardEntity` (`cards` table) | **36** | leaderboardInfo, cardType, discount, gamePrice, gameChannelParams, etc. (baseline said 37 — recount from SQL DDL gives 36) |
| `DownloadTaskEntity` (`download_tasks` table) | **19** | **+1 vs baseline** — new `source_id` column. Fields: task_id, downloader_type, source_id, url, name, save_path, cover, state, last_modify_time, download_total_size, downloaded_size, download_percent, install_total_size, installed_size, install_percent, error_code, metadata_json, created_at, updated_at |
| `PcGameHistoryEntity` | 11 | history_key, server_game_id, game_id, game_name, cover_image, cover_ver_image, hero_capsule, steam_app_id, source_type, source_id, insert_time |
| `UserEntity` (`user_account`) | 28 | net-new full schema documented below |
| `AuthTokenEntity` (`auth_token`) | 11 | unchanged |
| `UserThirdAccountEntity` (`user_third_account`) | 23 | net-new full schema |
| `VirtualIconNodeEntity` | 23 | id, userId, collectionId, parent_id, nodeType, name, name_search, sort_order, icon_key, origin_file_name, file_rel_path, mime_type, file_ext, size_bytes, width, height, sha256, file_mtime, status, last_error, created_at, updated_at, deleted_at |
| `VirtualKeyLayoutEntity` | 32 | gameId, layoutType, source, publishStatus, catalog, acquire, etc. — full DDL has 32 columns |

#### 11.1.3 Selected schemas (verified from 6.0.4 SQL DDL in `x70.smali`)

```sql
-- Game library base table (db_game_library.db) — 42 columns
CREATE TABLE t_game_library_base (
    _id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    id TEXT NOT NULL, user_id TEXT NOT NULL,
    server_game_id INTEGER NOT NULL, steam_app_id TEXT NOT NULL DEFAULT '',
    extension_type INTEGER NOT NULL, extension_data TEXT NOT NULL DEFAULT '',
    launch_method_id INTEGER NOT NULL,
    game_name TEXT NOT NULL DEFAULT '', cover_image TEXT NOT NULL DEFAULT '',
    cover_ver_image TEXT DEFAULT '', logo TEXT NOT NULL DEFAULT '',
    icon_url TEXT NOT NULL DEFAULT '', description TEXT NOT NULL DEFAULT '',
    game_source INTEGER NOT NULL DEFAULT 0,
    create_time INTEGER, modify_time INTEGER, last_launch_time INTEGER,
    back_image TEXT NOT NULL DEFAULT '', age_rating TEXT NOT NULL DEFAULT '',
    ai_desc TEXT NOT NULL DEFAULT '',
    company TEXT NOT NULL DEFAULT '', developer TEXT NOT NULL DEFAULT '',
    publisher TEXT NOT NULL DEFAULT '', release_date TEXT NOT NULL DEFAULT '',
    release_date_timestamp INTEGER NOT NULL DEFAULT -1,
    game_category TEXT NOT NULL DEFAULT '', game_tag TEXT NOT NULL DEFAULT '',
    game_lang TEXT NOT NULL DEFAULT '', screenshot TEXT NOT NULL DEFAULT '',
    video_url TEXT NOT NULL DEFAULT '', game_video_list TEXT NOT NULL DEFAULT '',
    square_image TEXT NOT NULL DEFAULT '', size INTEGER NOT NULL DEFAULT -2,
    remark TEXT NOT NULL DEFAULT '', other_desc TEXT NOT NULL DEFAULT '',
    "from" INTEGER NOT NULL DEFAULT 0,
    source_type INTEGER NOT NULL DEFAULT 0, source_id TEXT NOT NULL DEFAULT '',
    epic_app_name TEXT NOT NULL DEFAULT '',
    platforms TEXT NOT NULL DEFAULT '',
    game_startup_params TEXT NOT NULL DEFAULT ''
)

CREATE TABLE t_game_launch_method (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    linked_game_id TEXT NOT NULL, start_type INTEGER NOT NULL,
    start_name TEXT NOT NULL DEFAULT '', start_icon TEXT NOT NULL DEFAULT '',
    start_e_icon TEXT NOT NULL DEFAULT '', start_s_icon TEXT NOT NULL DEFAULT '',
    new_icon TEXT NOT NULL DEFAULT '', new_c_icon TEXT NOT NULL DEFAULT '',
    is_auto_game INTEGER NOT NULL DEFAULT 0, last_use_time INTEGER,
    extension_data TEXT NOT NULL DEFAULT ''
)

CREATE TABLE t_game_install_state (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    game_id TEXT NOT NULL, launch_method_id INTEGER NOT NULL,
    status TEXT NOT NULL,
    reason TEXT NOT NULL DEFAULT '', operation_id TEXT NOT NULL DEFAULT '',
    updated_at INTEGER NOT NULL
)

-- NET-NEW in 6.0.4 (not in 6.0.0 baseline)
CREATE TABLE t_game_cover_override (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    target_type TEXT NOT NULL, target_id TEXT NOT NULL,
    custom_back_image TEXT NOT NULL DEFAULT '',
    custom_cover_ver_image TEXT NOT NULL DEFAULT '',
    updated_at INTEGER NOT NULL
)

-- JWT token management (egggame.db)
CREATE TABLE auth_token (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    user_id TEXT NOT NULL,
    access_token TEXT NOT NULL, refresh_token TEXT, token_type TEXT,
    access_token_expires_at INTEGER, refresh_token_expires_at INTEGER,
    issued_at INTEGER, is_current INTEGER NOT NULL,
    created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES user_account(user_id)
        ON UPDATE NO ACTION ON DELETE CASCADE
)

CREATE TABLE api_cache (
    cache_key TEXT NOT NULL,
    response_body TEXT NOT NULL,
    last_updated INTEGER NOT NULL,
    headers TEXT,
    PRIMARY KEY(cache_key)
)

-- BI analytics retry queue (db_bi_event_v1.db) — TABLE NAME is `bi_event_queue` (corrected)
CREATE TABLE bi_event_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    user_id TEXT NOT NULL, event_type TEXT NOT NULL, params_json TEXT NOT NULL,
    created_at INTEGER NOT NULL, attempt_count INTEGER NOT NULL,
    last_attempt_at INTEGER, last_error TEXT
)

-- Updated for 6.0.4: source_id column added
CREATE TABLE download_tasks (
    task_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    downloader_type TEXT NOT NULL,
    source_id TEXT,
    url TEXT NOT NULL, name TEXT NOT NULL,
    save_path TEXT NOT NULL, cover TEXT NOT NULL, state TEXT NOT NULL,
    last_modify_time INTEGER NOT NULL,
    download_total_size INTEGER NOT NULL, downloaded_size INTEGER NOT NULL,
    download_percent INTEGER NOT NULL,
    install_total_size INTEGER NOT NULL, installed_size INTEGER NOT NULL,
    install_percent INTEGER NOT NULL,
    error_code INTEGER NOT NULL, metadata_json TEXT NOT NULL,
    created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL
)

-- Cloud game sessions (cloud_game_sessions.db, single-table DB in 6.0.4 — the 6.0.0 baseline's reference to a `cloud_timer` *table* was a classification error; `cloud_timer` is actually a *column* of `user_account` in egggame.db, written by INSERT at `smali_classes4/r40.smali:3809` and updated at `s40.smali:3615`)
CREATE TABLE cloud_game_sessions (
    session_id TEXT NOT NULL, game_id TEXT NOT NULL,
    duration_seconds INTEGER NOT NULL,
    started_at INTEGER NOT NULL, last_updated_at INTEGER NOT NULL,
    reported INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY(session_id)
)

-- User account schema (egggame.db) — full 28-column DDL
CREATE TABLE user_account (
    user_id TEXT NOT NULL,
    uuid TEXT, remote_numeric_id INTEGER,
    username TEXT, nickname TEXT, mobile TEXT,
    avatar_url TEXT, avatar_colour TEXT,
    verify_email INTEGER,
    realname_auth_status INTEGER, is_realname_authenticated INTEGER,
    email TEXT, bio TEXT, friend_num INTEGER,
    third_platform TEXT, cloud_timer INTEGER,
    allow_friend_notice INTEGER, allow_other_notice INTEGER,
    allow_reduce_notice INTEGER, allow_sms_notice INTEGER, allow_video_notice INTEGER,
    first_login INTEGER, guide INTEGER, key_prompt INTEGER,
    device_id TEXT, device_type TEXT,
    created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
    PRIMARY KEY(user_id)
)

-- Linked social accounts (egggame.db) — 23 columns
CREATE TABLE user_third_account (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    user_id TEXT NOT NULL,
    provider TEXT NOT NULL, provider_app_id TEXT NOT NULL,
    provider_uid TEXT NOT NULL, provider_union_id TEXT,
    display_name TEXT, avatar_url TEXT,
    email TEXT, email_verified INTEGER, phone_number TEXT,
    gender INTEGER, locale TEXT, country TEXT, province TEXT, city TEXT,
    status INTEGER NOT NULL,
    linked_at INTEGER NOT NULL, last_login_at INTEGER, unlinked_at INTEGER,
    profile_json TEXT,
    created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES user_account(user_id)
        ON UPDATE CASCADE ON DELETE CASCADE
)

-- PC game history (egggame.db) — 11 columns
CREATE TABLE pc_game_history (
    history_key TEXT NOT NULL,
    server_game_id INTEGER NOT NULL, game_id TEXT NOT NULL,
    game_name TEXT NOT NULL,
    cover_image TEXT NOT NULL, cover_ver_image TEXT NOT NULL,
    hero_capsule TEXT NOT NULL,
    steam_app_id TEXT NOT NULL,
    source_type INTEGER NOT NULL, source_id TEXT NOT NULL,
    insert_time INTEGER NOT NULL,
    PRIMARY KEY(history_key)
)

-- Epic Games prices (epic_storage.db) — unchanged
CREATE TABLE epic_app_price (
    app_name TEXT NOT NULL PRIMARY KEY,
    account_id TEXT NOT NULL,
    currency TEXT NOT NULL,
    original_price REAL NOT NULL, discount_price REAL NOT NULL,
    discount_percent INTEGER NOT NULL,
    original_formatted TEXT NOT NULL, discount_formatted TEXT NOT NULL
)

CREATE TABLE epic_offer_identity (
    account_id TEXT NOT NULL, namespace TEXT NOT NULL,
    app_name TEXT NOT NULL, title TEXT NOT NULL,
    offer_id TEXT NOT NULL, offer_type TEXT NOT NULL,
    catalog_item_ids TEXT NOT NULL, product_slug TEXT NOT NULL,
    PRIMARY KEY(account_id, app_name)
)
```

### 11.2 SharedPreferences / MMKV keys

All keys below verified present in 6.0.4 smali (literal `const-string` references). Number in parens = files referencing the literal.

| Key | Module | Refs | Purpose |
|---|---|---|---|
| `sp_winemu_unified_resources` | common/winemu | 1 | WinEmu unified resources cache (registry) |
| `sp_winemu_all_containers` | common/winemu | 1 | All Wine containers list |
| `sp_k_wine_screen_brightness` / `_switch` | features/winemu | 2 | Wine screen brightness override |
| `sp_k_hud_bg_transparency` | features/winemu/perf | 3 | HUD background transparency |
| `sp_k_cur_overlay_opacity` | features/winemu | 1 | Current overlay opacity (NOT `sp_k_overlay_opacity` — corrected Pass 30) |
| `sp_k_gamepad_sensitivity` | features/gamepadconfig | 4 | Gamepad analog sensitivity |
| `sp_k_virtual_gamepad_vibration_` | features/vjoy | 2 | Virtual gamepad vibration toggle |
| `sp_k_enable_touch_screen_mouse_control_` | features/winemu/input | 1 | Touch-as-mouse toggle |
| `sp_key_last_start_steam_type` | common/steam | 1 | Last-launched Steam type cache |
| `WineFile` (MMKV, multi-process mode=2) | WineActivity | 6 | Per-game Wine state |
| `InputControlsProfiles` (MMKV) | features/winemu/input | 3 | Saved input control / keymap profiles |
| `pc_emu_setting_kv` (MMKV) | features/winemu | 1 | Per-game PC-emulator settings KV |
| `pc_emu_setting_kv_global` (MMKV) | features/winemu | 1 | Global PC-emulator settings KV |
| `steam_event_collector` (MMKV) | common/steam | 1 | Steam event/telemetry buffer |
| `wine_loading_tips_cache` (MMKV) | common/winemu/loadingtips | 1 | Wine loading screen tips |
| `cloud_control_setting_device_active` | features/cloud | 2 | Cloud gamepad active device |
| `cloud_control_setting_scope` | features/cloud | 2 | Cloud controller settings scope |
| `cloud_normal_setting_idle` | features/cloud | 2 | Cloud idle timeout |
| `cloud_normal_setting_resolution` | features/cloud | 2 | Cloud streaming resolution |
| `cloud_normal_setting_scope` | features/cloud | 2 | Cloud general settings scope |
| `cloud_normal_setting_streaming_mode` | features/cloud | 2 | Cloud streaming mode |
| `cloud_setting_controller` / `cloud_setting_general` | features/cloud | 2 each | Cloud session settings (landscape/portrait) |
| `cloud_setting_pane_result` | features/cloud | 2 | Cloud settings panel result |
| `pc_game_setting_landscape_scope` | features/winemu | 8 | PC game settings (landscape) |
| `compatibility_setting_scope` | features/winemu | 2 | Compatibility setting scope |
| `gamepad_config_menu_group_landscape` | features/gamepadconfig | 1 | Gamepad config menu group |
| `cid_cache_expire_time` / `cid_cache_interval` | core | 5 / 8 | Cloud ID cache TTL |
| `file_cache_size` / `sdk_config_version` | core | 2 / 2 | File cache and SDK config |
| `setting_logout_dialog_scope` | features/setting | 2 | Logout dialog state |
| `__wx_opensdk_sp__` | WeChat SDK | 1 | WeChat OAuth state |
| `.we_appcache_token` | Weibo SDK | 1 | Weibo auth token cache |
| `com.vivo.push_preferences.appconfig_v1` | Vivo push | 1 | Vivo push configuration |

### 11.3 FileProvider declarations (AndroidManifest.xml + res/xml)

6.0.4 ships **seven** `<provider>` entries that participate in file sharing. (Manifest authorities verified.)

| Authority | Provider class | Paths file | Notes |
|---|---|---|---|
| `com.xiaoji.egggame.fileprovider` | `androidx.core.content.FileProvider` | `@xml/file_paths` | App's primary FileProvider — APK cache scope only |
| `com.xiaoji.egggame.utilcode.fileprovider` | `com.blankj.utilcode.util.UtilsFileProvider` | `@xml/util_code_provider_paths` | BlankJ UtilsFileProvider — broadest scope (includes `root-path`) |
| `com.xiaoji.egggame.filekit.fileprovider` | `io.github.vinceglb.filekit.dialogs.FileKitFileProvider` | `@xml/filekit_file_paths` | FileKit dialog provider |
| `com.xiaoji.egggame.fileprovider` (collides with primary) | `com.sina.weibo.sdk.content.FileProviderV2` | `@xml/wbsdk_filepaths` | Weibo SDK provider — **same authority as androidx provider** |
| `com.xiaoji.egggame.wbsdk.fileprovider` | `com.sina.weibo.sdk.content.WeiboSDKFileProvider` | `@xml/wbsdk_filepaths` | Weibo SDK alt authority |
| `com.xiaoji.egggame.cn.fly.FlyProvider` | `cn.fly.FlyProvider` | (none — internal) | FlyID provider |
| `com.xiaoji.egggame.com.mob.MobProvider` | `com.mob.MobProvider` | (none — internal) | Mob SDK provider |

> The `fileprovider` authority collision (androidx + Weibo `FileProviderV2`) appears intentional — manifest merge picks the last writer (Weibo). TBD-§11.3 whether this is a bug or design.

#### 11.3.1 `util_code_provider_paths.xml` (UtilsFileProvider — broadest scope)

| Path type | Element | Scope |
|---|---|---|
| `files_path` | `<files-path name="files_path" path="." />` | App internal files |
| `cache_path` | `<cache-path name="cache_path" path="." />` | App cache |
| `external_path` | `<external-path name="external_path" path="." />` | Root external storage (all of `/storage/emulated/0/`) |
| `external_files_path` | `<external-files-path name="external_files_path" path="." />` | App external files |
| `external_cache_path` | `<external-cache-path name="external_cache_path" path="." />` | App external cache |
| `external_media_path` | `<external-media-path name="external_media_path" path="." />` | External media paths |
| `root-path` | `<root-path name="root-path" path="" />` | **Full filesystem root** — widest FileProvider scope |

`root-path` likely used for emulator container and game-file sharing across processes.

#### 11.3.2 Other paths configs (net-new vs baseline)

| File | Element | Scope |
|---|---|---|
| `file_paths.xml` | `<cache-path name="apk_cache" path="." />` | APK install cache (androidx FileProvider) |
| `filekit_file_paths.xml` | `<cache-path name="filekit_cache" path="." />` | FileKit dialog scratch |
| `image_share_filepaths.xml` | `<files-path name="image_provider_images" path="image_provider/" />` | **Orphan / dead resource.** Confirmed via exhaustive grep across smali/jadx/lib/unknown/original/AndroidManifest: zero references to the literal `image_share_filepaths`, zero references to resource ID `0x7f140003`, zero references to the inner literals `image_provider_images` or `image_provider/`. All five FileProvider declarations in the manifest reference other XML configs (`file_paths`, `util_code_provider_paths`, `filekit_file_paths`, `wbsdk_filepaths`). No consumer class exists — stranded compile artifact, possibly from a deleted share-image flow |
| `wbsdk_filepaths.xml` | (Weibo paths) | Weibo SDK image sharing |

---
## 12. API Surface

GameHub 6.0.4 keeps the **two distinct API surfaces** introduced in 6.0 with the same reach and patch profiles. Documentation order: Catalog API → Client API → first-party literals → live verification matrix.

### 12.1 Catalog API — bare hostnames in the `mcj` enum

Stored as scheme-less hostnames in `mcj.smali` (`Lmcj;`), keyed by environment (Online / Beta / Test) with one CN slot and one oversea slot per environment. URL is built at runtime by `t40.smali` as `<scheme>://<host>`. **bannerhub-revanced patches the Online value's two `const-string` instructions** to swap both literals to `bannerhub-api.the412banner.workers.dev` (see `BANNERHUB_API_6.0_INTEGRATION.md` §2). All four host literals re-verified present in 6.0.4 DEX, unchanged from 6.0.1.

| Host | Resolved IP | Backend | Role |
|---|---|---|---|
| `landscape-api-cn.vgabc.com` | `119.23.38.142` | Aliyun direct | Production catalog (CN slot). **Patched by RedirectCatalogApiPatch** |
| `landscape-api-oversea.vgabc.com` | `43.159.95.190` | Tencent EdgeOne | Production catalog (oversea slot). Returns `ux-landscape-test/` test variant URLs. **Patched by RedirectCatalogApiPatch** |
| `landscape-api-cn-beta.vgabc.com` | `47.113.89.207` | Beta cluster | Beta catalog (CN slot). Not patched |
| `landscape-api-oversea-beta.vgabc.com` | `47.113.89.207` | Beta cluster (same backend) | Beta catalog (oversea slot). Not patched |

#### 12.1.1 Routes served on all four hosts

The catalog API exposes two path families: the `/simulator/v2/*` group (the primary 6.0 component catalog) plus a sibling `/simulator/*` group (no `v2`) for share/tab/config/script delivery. **Note correction vs earlier doc:** `executeScript` lives at `simulator/executeScript`, NOT `simulator/v2/executeScript` — both 6.0.1 and 6.0.4 smali confirm the bare path.

| Path | Controls |
|---|---|
| `simulator/v2/getAllComponentList` | Master catalog of every WinEmu component (Box64/FEX/DXVK/VKD3D/GPU drivers/libraries/games/Steam clients/Steam agents). Drives every "Select component" picker in PC game settings |
| `simulator/v2/getComponentList` | Filtered subset by component-type integer (1=Box64/FEX, 2=GPU drivers, 3=DXVK, 4=VKD3D, 5=Games + Steam *agents*, 6=Libraries, 8=Steam clients in 6.0 — moved from type 7 in 5.x) |
| `simulator/v2/getContainerList` | List of full Wine "containers" (Proton ARM64EC + plain Wine x64). Drives container selection. 6.0 returns `is_steam` per container — must be camelCased to `isSteam` for the worker |
| `simulator/v2/getContainerDetail/{id}` | **6.0-only.** Single-container metadata (10 ids, 2–11). Used when picking a container to view/install |
| `simulator/v2/getDefaultComponent` | Default per-game component selection (the auto-pick) |
| `simulator/v2/getImagefsDetail` | Firmware image-FS metadata (vanilla 6.0 baseline was 1.3.4 / versionCode 24; BannerHub Worker now serves **1.4.1** / versionCode 31 to **both** 5.x and 6.0 — 7-site lockstep as of `5dc29a9` 2026-05-15; the old "5.x stays on 1.3.3" split is retired). Decides whether a firmware update is needed |
| `simulator/executeScript` | Server-evaluated config/script delivery — runtime catalog overrides |
| `simulator/configList` | Per-game shared-config listings (community-shared per-game settings) |
| `simulator/getConfigById` | Fetch single shared config by id |
| `simulator/getGameLoadingPromptList` | Loading-screen prompt strings (auth-gated; BannerHub Worker passes auth through — see worker §6) |
| `simulator/getLocalGameDetail` | Resolve a local game record against catalog |
| `simulator/getTabList` | Tab-group catalog (top-level navigation tab definitions) |
| `simulator/shareConfig` | Publish per-game config to the share repository |
| `simulator/deleteShareConfig` | Remove a previously-published share config |
| `simulator/reportConfigApply` | Telemetry — report that user applied a shared config |

#### 12.1.2 Required POST body

All catalog calls (form-urlencoded preferred; JSON also accepted on legacy host):

| Field | Format |
|---|---|
| `clientparams` | Pipe-delimited 19-field string (built by `com.xiaoji.egggame.core.network.clientparams.PlatformClientParamsModule`):<br>`<version>\|<versionCode>\|<lang>\|<model>\|<resolution>\|<channel>\|<sub_channel>\|<brand>\|\|\|\|\|\|\|\|\|<package>\|\|<gpu_vendor>`<br>**Vanilla 6.0.4 example:** `6.0.4\|114\|en\|SM-S928B\|1920 * 1080\|gamehub_android\|gamehub_android_Official\|samsung\|\|\|\|\|\|\|\|\|com.mihoyo.genshinimpact\|\|qcom` |
| `time` | Millisecond timestamp string |
| `token` | JWT from `jwt/email/login` (or `jwt/refresh/token`) |
| `sign` | MD5 of sorted-keys joined `key=value&key=value...&all-egg-shell-y7ZatUDk` |

### 12.2 Client API — `https://clientgsw.vgabc.com/clientapi/`

Hardcoded full URL in DEX (verified in 6.0.4). Tencent EdgeOne (`43.159.95.190` → CNAME `*.eo.dnse1.com`). **404s on every probed path from non-CN IPs** including realistic JSON+form bodies, `clientparams`, headers (App-Id, channel, platform, Version, User-Agent variants). Bare `/` returns 200 `hello gamesir world`; `/clientapi` 301→`/clientapi/`→404. Likely requires either a header set we have not identified or specific client-cert / app-attest material.

**Not patched** by bannerhub-revanced — vanilla problem we don't own.

#### 12.2.1 Auth / identity

| Path | Controls |
|---|---|
| `jwt/email/login` | Email + password login → returns JWT |
| `jwt/mobile/login` | Phone-number login |
| `jwt/oneMobile/login` | One-tap mobile login (Alibaba/CMIC SSO bridge) |
| `jwt/third/login` | Third-party OAuth login (WeChat/QQ/Apple/Google/Weibo/Epic/Facebook/Twitter) |
| `jwt/logout` | Invalidate JWT |
| `jwt/refresh/token` | Refresh JWT (separate signature flow vs other endpoints; returns 401 "Please login first" without specific signing) |
| `account/cancel` | Permanent account deletion |
| `bind/{apple,google,qq,wechat,email,mobile,customParam}` | Link a social/contact identity |
| `unbind/{apple,google,qq,wechat}` | Unlink |
| `profile/mobile` | Mobile profile metadata |
| `realname/auth` / `realname/status` | China real-name verification (legally required for game time) |
| `ems/send` / `sms/send` | Send email/SMS verification code |
| `user/getMobileCode` | Request phone verification code |
| `user/info` | Full user profile (avatar, level, badges, balances) |
| `user/get_simple_userinfo` | Lightweight profile (used in headers/feeds) |

#### 12.2.2 Game catalog / content (Client API side, distinct from Catalog API)

| Path | Controls |
|---|---|
| `game/v2/detail` | Per-game detail page (covers, screenshots, requirements, store links) |
| `game/v2/getClassify` | Game classifications/categories tree |
| `game/getCategoryGroups` | Category groups (genre clusters) |
| `game/getCustomPageGameList` | Curated list pages (hand-picked rails) |
| `game/getGameCircleList` | Community circles per game (forum-like) |
| `game/getH5ShareLink` | Build a sharable H5 link |
| `game/getRecommendGameList` | Recommended games rail |
| `game/getRetroGameStats` | Server-side retro play stats |
| `game/retroList` / `game/retroDetail` | Retro library list/detail |
| `game/opRes/list` | Operations resources (banners, marketing assets) |
| `game/saveInterestTags` | User-selected interest tags |
| `game/leaderboard/list` | Per-game leaderboards |
| `game/cts/report` | Submit compatibility report (CTS) |
| `game/checkLocalHandTourGame` | Detect if mobile game is locally installed (handheld) |

#### 12.2.3 Sessions / heartbeat / activity

| Path | Controls |
|---|---|
| `heartbeat/game/start` | Begin tracked session — drives playtime, achievements, daily-reward eligibility |
| `heartbeat/game/update` | Mid-session ping |
| `heartbeat/game/end` | End session |
| `heartbeat/game/getUserPlayTimeList` | Per-user aggregated play-time list |
| `activity/task/trigger` | Fire an in-app task/event milestone |
| `activity/h5?id=` | H5 activity page by id |
| `cloud_sign/getActivity` | Daily sign-in calendar + reward state |
| `cloud_sign/sign` | Record today's sign-in |

#### 12.2.4 Telemetry / config

| Path | Controls |
|---|---|
| `events/device-performance-config` | Device-perf telemetry endpoint (Firebase datatransport) — receives the `DevicePerfReportEventDto` envelope (see §9.10). Prefixed by one of three event hosts (`statistic-gamehub-api.vgabc.com`, `landscape-api-beta.vgabc.com`, `dev2-gamehub-api.vgabc.com`) — all three full URLs verified as literals in 6.0.4 DEX |
| `privacy-sandbox/register-app-conversion` | Google Privacy Sandbox app-conversion registration |
| `config/app/` | App config bundle |
| `conf/style` | UI style/theming config |
| `settings/getNotifySwitch` | Notification toggle state |
| `location/conf` / `location/report` | Location config + reporting |

#### 12.2.5 Feedback / uploads / share

| Path | Controls |
|---|---|
| `feedback/submitFeedback` | Submit in-app feedback |
| `feedback/feedback_list.html?uid=` | H5 feedback list (WebView) |
| `feedback/feedback_detail.html` | H5 feedback detail |
| `uploads/uploadsImages` | Upload images (community/sharing) |
| `uploads/uploadsVideo` | Upload video |
| `share/icons` | Share icon assets |
| `share/media/blank.mkv` / `share/media/blank.ptna` | Share-media placeholder assets |
| `share/pixmap` | Share pixmap asset |

#### 12.2.6 WinEmu / Steam / Epic data

| Path | Controls |
|---|---|
| `xj_winemu/pc_game_setting_schemes` | Per-game-PC setting scheme bundles (drives the in-game settings UI generator — see §9.1.7) |
| `steam_data/steamkit` | Steam SDK data exchange (libsteamkit_core.so backend) |
| `epic_data/epickit` | Epic SDK data exchange (libepickit_core.so backend) |
| `epic_data/epic_recovery_governance_directive.json` | EGS recovery directive catalog |
| `epic_data/epic_recovery_governance_directive_execution.json` | Directive execution rules |
| `epic_data/epic_recovery_governance_execution.json` | Execution-state config |
| `epic_data/epic_recovery_governance_plan.json` | Recovery plan catalog |
| `epic_data/epic_recovery_governance_prompts.json` | Prompt catalog |
| `epic_data/epic_recovery_governance_prompt_account_history.json` | Account-scoped prompt history |
| `epic_data/epic_recovery_governance_prompt_session_history.json` | Session-scoped prompt history |
| `epic_data/epic_recovery_governance_strategy.json` | Strategy resolution rules |
| `epic_data/epic_android_recovery_governance_actions.json` | Android-specific recovery actions |
| `epic_data/epic_ios_recovery_governance_actions.json` | iOS-specific recovery actions |
| `emulator/auth/handler` | Per-emulator auth handler (Steam/Epic OAuth bridge) |
| `retro_emulator/cores/` | Retro emulator core listing (links to bigeyes CDN) |

#### 12.2.7 Cloud gaming (VTouch + cloud signaling)

| Path | Controls |
|---|---|
| `vtouch/startType` | Cloud-gaming launch mode selection |
| `cloud/game/auth_token` | Get session token |
| `cloud/game/start_token` | Start cloud-game session |
| `cloud/game/renew_token` | Renew session |
| `cloud/game/exit` | End session |
| `cloud/game/check_user_timer` | Check remaining time |
| `cloud/game/getQueueInfo` / `startQueue` / `getQueueCalendar` | Queue management |
| `cloud/game/getGoodsListV2` | Cloud-game store catalog |
| `cloud/game/getNewsList` / `getNewsDetail` | News feed for cloud-gaming |
| `cloud/game/confirmPlay` | Pre-play confirmation |
| `cloud/order/info` / `cloud/order_list` | Order info / list |
| `cloud/payment` | Cloud-gaming payment endpoint |
| `cloud/app/exchange_code` / `cloud/h5/exchange_code?uuid=` | Activation codes |
| `cloud/use_time_log` | Play-time reporting |
| `cloud/notify/apple` | Apple push for cloud gaming |
| `order/get_down_info` | Per-download order metadata |

> Earlier passes referenced "17 sub-paths under `cloud/game/*`". The actual count from this exhaustive smali sweep is **12** under `cloud/game/`, plus 6 more under `cloud/{app,h5,order,order_list,payment,use_time_log,notify}` and 1 under `order/`. Re-verified unchanged in 6.0.4.

### 12.3 First-party standalone literals (full URLs in DEX)

| URL | In 6.0.4 DEX | Purpose |
|---|---|---|
| `https://clientgsw.vgabc.com/clientapi/` | ✅ literal full URL | Client API (see §12.2) |
| `https://statistic-gamehub-api.vgabc.com/events` | ✅ literal | Production analytics events bus |
| `https://landscape-api-beta.vgabc.com/events` | ✅ literal | Beta analytics events |
| `https://dev2-gamehub-api.vgabc.com/events` | ✅ literal | Dev/beta event tracking (global) |
| `https://gamehub-service-dev.xiaoji.com/xgp/exchange` | ✅ literal | Xbox Game Pass code redemption (new in 6.0) |
| `https://xgp.xiaoji.com` | ✅ literal | Xbox Game Pass portal |
| `https://gamehub.xiaoji.com/{en-us,zh-cn}` | ✅ literal | GameHub web (locale split) |
| `https://www.xiaoji.com/firmware/update/x1` | ✅ literal | OTA firmware update check (image-FS) |
| `https://retro-emulator-download.bigeyes.com/retroarch/` | ✅ literal | RetroArch WASM cores download root |

**Hosts referenced but NOT in 6.0.4 DEX (historical):**
`landscape-api.vgabc.com` (5.x legacy, still alive — used by BannerHub worker as fallback origin), `dev2-gamehub-api-cn.vgabc.com`, `dev2-gamehub-api-oversea.vgabc.com`, `landscape-api-cn-beta.vgabc.com/events`, `landscape-api-cn.vgabc.com/events`, `landscape-api-oversea-beta.vgabc.com/events`, `landscape-api-oversea.vgabc.com/events`, `api-cn-gamehub.xiaoji.com`, `api-international-gamehub.xiaoji.com`, `gamehub-dev.mx520.com`, `gamehub-dev-international.mx520.com`.

### 12.4 Live verification — host reachability matrix (probed 2026-05-03)

With valid token + signed body:

| Host | Resolved IP | Backend | `/simulator/v2/getAllComponentList` | `/user/info` | `/clientapi/...` |
|---|---|---|---|---|---|
| `landscape-api.vgabc.com` | `119.23.38.142` | Aliyun direct, no CDN | **200** | **200** | 404 |
| `landscape-api-cn.vgabc.com` | `119.23.38.142` (same backend as above) | Aliyun direct | **200** | (not tested) | (not tested) |
| `landscape-api-oversea.vgabc.com` | `43.159.95.190` (Tencent EdgeOne, vhost-routed differently than clientgsw) | EdgeOne edge → backend | **200** (returns `ux-landscape-test/...` paths) | (not tested) | (not tested) |
| `landscape-api-cn-beta.vgabc.com` | `47.113.89.207` | beta cluster | **200** | (not tested) | (not tested) |
| `landscape-api-oversea-beta.vgabc.com` | `47.113.89.207` (same backend as cn-beta) | beta cluster | **200** | (not tested) | (not tested) |
| `clientgsw.vgabc.com` | `43.159.95.190` → CNAME `*.eo.dnse1.com` (Tencent EdgeOne) | EdgeOne edge | 404 | 404 | **404 on every probe** |

**Key takeaways:**

- The catalog API (`simulator/v2/*` and `simulator/*`) is **fully reachable from non-CN IPs** on every `landscape-api*` host. EdgeOne does not block it. The `mcj` enum's cn/oversea hosts both work today.
- `landscape-api.vgabc.com` (no regional suffix) is **alive on the same backend as `landscape-api-cn`** — and is what the BannerHub worker uses as the fallback origin. Functionally equivalent to landscape-api-cn for catalog purposes.
- `clientgsw.vgabc.com` is the outlier: 404 on every probed path. Bare `/` returns 200 `hello gamesir world`; `/clientapi` 301→`/clientapi/`→404.
- `jwt/refresh/token` against landscape-api returns 401 "Please login first" — refresh has its own signature requirement different from regular signed requests.

---

## 13. CDN Structure

CDN hostnames are **server-driven** — the API response sets them rather than the app hardcoding them. Neither `cdn-img-uxdl.youwo.com` nor `zlyer-cdn-comps-en.bigeyes.com` appears as a literal string in the 6.0.4 DEX (re-verified: 0 hits in smali); both observed only in cached responses on-device (prefs + Coil cache + winemu registry XML).

| Domain | Used for | Verification |
|---|---|---|
| `zlyer-cdn-comps-en.bigeyes.com/ux-landscape/pc_zst/` | Production component/container `.tzst`/`.zst` archives (Box64/FEX/DXVK/VKD3D/Wine binaries) | ✅ confirmed in on-device `sp_winemu_unified_resources.xml` (hundreds of cached URLs) |
| `zlyer-cdn-comps-en.bigeyes.com/ux-landscape-test/pc_zst/` | Test/beta component archives | ✅ confirmed in on-device registry; oversea Catalog returns these |
| `cdn-img-uxdl.youwo.com/ux-landscape/game-image/` | Game cover/screenshot artwork | ✅ confirmed in `com.mihoyo.genshinimpact_preferences.xml` and Coil disk cache. **Fastly+GCS fronted** (response headers show `via: 1.1 varnish`, `x-served-by: cache-iad/ewr-...`, `x-guploader-uploadid: AAVLpEi...`) |
| `zlyer-cdn-comps-en.bigeyes.com/ux-landscape/game-image/` | (Historical) earlier game-image host | Replaced by `cdn-img-uxdl.youwo.com` in 6.0; both hosts may still resolve |
| `retro-emulator-download.bigeyes.com/retroarch/` | RetroArch WASM cores | ✅ literal in 6.0.4 DEX |
| `dllhb.gamebrew.org/gbahomebrews/` | Bundled GBA demo ROMs | ✅ literal (4 hits in 6.0.4 DEX) |

**URL pattern for components:**
`https://zlyer-cdn-comps-en.bigeyes.com/ux-landscape/pc_zst/<md5[0:4]>/<md5[4:6]>/<md5[6:8]>/<filename>.tzst`

---

## 14. Third-Party SDK Endpoints

### 14.1 Cloud-gaming (Haima HMCP)

| URL | Purpose |
|---|---|
| `https://saas-rel.haimacloud.com/s/rest/api` | Primary HMCP auth/API — cloud-PC sessions |
| `https://saas-rel-bak.haimacloud.com/s/rest/api` | Failover endpoint |
| `https://saassdk.haimawan.com/saas_test_20M.data` | 20MB bandwidth test |
| `https://countly.haimacloud.com` | HMCP usage analytics (Countly) |

### 14.2 Connectivity probes

| URL | Purpose |
|---|---|
| `https://1.1.1.1/cdn-cgi/trace` | Cloudflare presence/IP detect |
| `https://api.ip.sb/geoip` | IP geolocation (region-gating decisions) |
| `https://connectivitycheck.gstatic.com/generate_204` | Android NCS probe |
| `https://www.google.com/generate_204` | Secondary NCS probe |

### 14.3 OAuth — WeChat

| URL | Purpose |
|---|---|
| `https://api.weixin.qq.com/sns/oauth2/access_token` | Exchange WeChat code → access token |
| `https://api.weixin.qq.com/cgi-bin/stable_token` | Stable token (server-to-server) |
| `https://api.weixin.qq.com/cgi-bin/ticket/getticket` | Get JS-API ticket (for share signing) |
| `https://mp.weixin.qq.com/publicpoc/opensdkconf?action=GetShareConf&appid=` | Mini-Program OpenSDK share config |
| `https://open.weixin.qq.com/connect/sdk/qrconnect` | QR-code login |
| `https://long.open.weixin.qq.com/connect/l/qrconnect` | Long-poll QR login |

### 14.4 OAuth — QQ / Tencent

| URL | Purpose |
|---|---|
| `https://openmobile.qq.com/oauth2.0/m_authorize` | QQ Connect authorize |
| `https://openmobile.qq.com/oauth2.0/me` | Current user info |
| `https://openmobile.qq.com/oauth2.0/m_jump_by_version` | Version-based jump |
| `https://openmobile.qq.com/v3/user/get_info` | User info (v3) |
| `https://openmobile.qq.com/user/user_login_statis` | Login statistics |
| `https://openmobile.qq.com/cgi-bin/qunopensdk/check_group` | Group membership check |
| `https://openmobile.qq.com/cgi-bin/qunopensdk/unbind` | Group unbind |
| `https://imgcache.qq.com/ptlogin/static/qzsjump.html` | Qzone ptlogin jump |
| `https://appsupport.qq.com/cgi-bin/qzapps/mapp_addapp.cgi` | Qzone mini-app add |
| `https://appsupport.qq.com/cgi-bin/appstage/mstats_batch_report` | AppStage telemetry batch |
| `https://cgi.connect.qq.com/qqconnectopen/openapi/policy_conf` | Connect policy config |
| `https://h.trace.qq.com/kv` | Tencent Tracing telemetry |
| `https://www.qq.com` / `https://qm.qq.com` | QQ root + landing |

### 14.5 OAuth — Weibo

| URL | Purpose |
|---|---|
| `https://api.weibo.com/oauth2/access_token` | Token exchange (+ `/default.html` redirect) |
| `https://open.weibo.cn/oauth2/authorize` | Authorize page |
| `https://service.weibo.com/share/mobilesdk.php` | Mobile-SDK share endpoint |

### 14.6 OAuth — Epic Games

| URL | Purpose |
|---|---|
| `https://www.epicgames.com/id/api/redirect?clientId=34a02cf8f4414e29b15921876da36f9a&responseType=code` | Auth start (clientId is GameHub's Epic app id) |
| `https://www.epicgames.com/id/login?redirect_uri=` | Login redirect |
| `https://store.epicgames.com/` | Store web view (game detail) |

### 14.7 Steam (deep links / web)

| URL | Purpose |
|---|---|
| `https://store.steampowered.com/app/` | Open Steam store page (game detail) |
| `https://store.steampowered.com/mobile` | Steam mobile store landing |
| `https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/` | Steam store-item assets via Fastly |

### 14.8 Chinese carrier auth (one-tap phone login)

| URL | Purpose |
|---|---|
| `https://api-e189.21cn.com/gw/client/accountMsg.do` | China Telecom 21cn account msg |
| `https://card.e.189.cn/auth/preauth.do` | China Telecom 189 card pre-auth |
| `https://e.189.cn/sdk/agreement/detail.do` | 189 SDK agreement (terms page) |
| `https://crbt.i139.cn:8143/may/impower/V1` | China Mobile authorize/get-info (port 8143) |
| `https://wap.cmpassport.com/resources/html/contract.html` | CMPassport contract terms |
| `https://verify.cmpassport.com/h5/getMobile` | CMPassport H5 phone-fetch |
| `cert.cmpassport.com` / `config2.cmpassport.com` / `rcs.cmpassport.com` / `log2.cmpassport.com:9443` | CMPassport TLS-pinned cert host / config / RCS / log gateway |
| `https://msv6.wosms.cn/html/oauth/protocol2.html` | China Unicom SMS auth (production) |
| `auth.wosms.cn` / `ali.wosms.cn` / `test.wosms.cn` | Unicom SMS auth/Alibaba relay/sandbox |
| `https://nisportal.10010.com:9001/api` | Unicom CUCC get-auth-addr (port 9001) |
| `https://opencloud.wostore.cn/authz/resource/html/disclaimer.html` | Unicom open cloud authz disclaimer |
| `https://id6.me/auth/preauth.do` | ID6 carrier SSO |
| `https://dypnsapi-dualstack.aliyuncs.com` | Alibaba one-tap phone auth |

### 14.9 Alipay (in-app payment)

| URL | Purpose |
|---|---|
| `https://loggw-exsdk.alipay.com/loggw/logUpload.do` | SDK log upload |
| `https://mcgw.alipay.com/sdklog.do` | SDK log gateway |
| `https://mclient.alipay.com/cashier/mobilepay.htm` | Mobile cashier (mobile pay) |
| `https://mclient.alipay.com/home/exterfaceAssign.htm` | Mobile cashier home assign |
| `https://mclient.alipay.com/service/rest.htm` | Mobile REST service |
| `https://mclient.alipay.com/wapcashier/api/cashierMainMergeRequest.htm` | WAP cashier main merge request |
| `https://mobilegw.alipay.com/mgw.htm` | Mobile gateway (production) |
| `https://mobilegwpre.alipay.com/mgw.htm` | Mobile gateway (pre-prod) |
| `https://wappaygw.alipay.com/home/exterfaceAssign.htm` | WAP pay gateway home |
| `https://wappaygw.alipay.com/service/rest.htm` | WAP pay gateway REST |
| `mobilegw.{stable,aaa}.alipay.net/mgw.htm` | Stable / AAA-auth environments |
| `mobilegw-1-64.test.alipay.net/mgw.htm` | Test environment (suffixed host — bare `mobilegw.test.alipay.net` not in DEX; only the numbered shard form is) |

### 14.10 Push (Mob + carrier OEMs)

| URL | Purpose |
|---|---|
| `sdk.push.mob.com` / `abroad.sdk.push.mob.com` | MobPush gateway (CN / international) |
| `m.zzx.cnklog.com` | MobTech telemetry log (CN) |
| `https://cn.register.xmpush.xiaomi.com` | MiPush registration |
| `sandbox.xmpush.xiaomi.com` | MiPush sandbox |
| `https://resolver.msg.xiaomi.net/psc/?t=a` | MiPush resolver |
| `app.chat.xiaomi.net` / `cn.app.chat.xiaomi.net` | MiPush chat (intl/CN) |

### 14.11 FlyID (China device-fingerprint / messaging infra)

| URL | Purpose |
|---|---|
| `cfgc.zztfly.com` | Config gateway |
| `devc.zztfly.com` | Device channel |
| `errc.zztfly.com` | Error channel |
| `fdl.zztfly.com` | Feedback / data log |
| `gd.zztfly.com` | Get-data channel |
| `tgc.zztfly.com` | Token gateway |
| `upc.zztfly.com` | Upload channel |

### 14.12 Google

| URL | Purpose |
|---|---|
| `https://app-measurement.com/a` | Firebase Analytics ingestion |
| `https://firebaseinstallations.googleapis.com/v1/` | Firebase Installations registration |
| `https://firebase-settings.crashlytics.com/spi/v2/platforms/android/gmp/` | Crashlytics settings |
| `https://accounts.google.com/o/oauth2/revoke?token=` | Google OAuth revoke |
| `https://www.googleapis.com/auth/{games,games.firstparty,games_lite,appstate,datastoremobile,drive,drive.appdata,drive.apps,drive.file,plus.login,plus.me,userinfo.email,userinfo.profile}` | OAuth scope identifiers (Play Games + Drive + Plus + userinfo) |
| `https://pagead2.googlesyndication.com` | Google ads delivery |
| `https://pagead2.googlesyndication.com/pagead/gen_204?id=gmob-apps` | Mobile Ads telemetry pixel |
| `https://www.googleadservices.com/pagead/conversion/app/deeplink` | Ads conversion deeplink |
| `https://play.google.com/store/apps/details?id=` | Open Play Store detail |
| `https://play.google.com/store/search?q=otpauth&c=apps` | Discover TOTP app for 2FA |
| `https://www.recaptcha.net/recaptcha/api3` | reCAPTCHA Enterprise |

### 14.13 Misc

| URL | Purpose |
|---|---|
| `https://h5.m.taobao.com/mlapp/olist.html` | Taobao mobile order list (Alipay context bridge) |
| `https://aomedia.org/emsg/ID3` | AOMedia ID3 metadata URL (ExoPlayer/AV1) |
| `https://www.baidu.com` | Baidu (connectivity / search fallback) |
| `https://cdn.jsdelivr.net/npm/echarts@5.3.0/dist/echarts.min.js` | ECharts (charts inside WebView dashboards) |

---

## 15. Custom URI Schemes

Schemes registered in AndroidManifest deep-link filters (6.0.4): `scheme://epic-auth`, `genericidp://firebase.auth/`, `recaptcha://firebase.auth/`, `tbopen://`, `tencent102667728://`. All re-verified unchanged from 6.0.1. Remaining schemes are used as string literals in smali (parseUri / Uri.parse call sites).

| Scheme | Purpose |
|---|---|
| `scheme://epic-auth` | Epic Games auth callback (manifest deep link — registered as `android:scheme="scheme" android:host="epic-auth"`) |
| `tencent102667728://` | QQ OAuth callback (manifest deep link) |
| `genericidp://firebase.auth/` | Firebase generic IdP callback (manifest deep link) |
| `recaptcha://firebase.auth/` | Firebase reCAPTCHA callback (manifest deep link) |
| `tbopen://` | Taobao/Alipay deep link (manifest deep link) |
| `mqqapi://` | QQ Messenger deep links — `connect_miniapp/launch`, `im/chat`, `share/to_fri`, `share/to_qzone`, `opensdk/{bind_group,join_group,open_auth_manage}`, `profile/{sdk_face_collection,sdk_avatar_edit}`, `qzone/publish`, `open_connect/common_channel` |
| `auth://tauth.qq.com/` | QQ tauth in-app authentication callback |
| `steammobile://store?appid=%s` | Open game detail in Steam mobile app |
| `gamesir://local_file` | GameSir controller local file access |
| `auth://` | Internal auth callback — `browser`, `cancel`, `close`, `onLoginSubmit`, `progress` |
| `sdklite://h5quit` | SDK lite H5 exit callback |
| `otpauth://totp/` | TOTP 2FA (Firebase Auth / authenticator app) |
| `alipayhk://platformapi` / `alipays://platformapi` / `alipayjsbridge://(call\|on\|set\|show)` | Alipay payment bridges |
| `intent://platformapi` | Alipay platform intent fallback |
| `weixin://(registerapp\|sendreq\|sendresp\|unregisterapp)` | WeChat SDK IPC schemes |
| `sinaweibo://browser` | Weibo browser callbacks |
| `js://localWebPay` / `js://update` / `js://wappay` | JS bridge schemes for WebView payment |
| `app://com.google.android.googlequicksearchbox` / `app://com.google.appcrawler` | Google App search/crawler indexing |
| `market://details` | Google Play Store details page |
| `keystore://firebear_main_key_id_for_storage_crypto.` / `keystore://firebear_master_key_id.` | Firebase Auth (Firebear) storage encryption key references |
| `ldap://localhost` | BouncyCastle LDAP test reference (cert chain validation) |

---

## 16. External `content://` Providers Queried

App reads/writes the following system & vendor `content://` providers (badges, push, launcher integration, device IDs). All re-verified present in 6.0.4 smali / manifest.

| Authority | Owner / Purpose |
|---|---|
| `com.google.android.gms.phenotype` | GMS Phenotype (feature flags) |
| `com.google.android.gsf.gservices` | Google Services Framework GServices |
| `com.huawei.android.launcher.settings` / `com.hihonor.android.launcher.settings` | Huawei / Honor launcher (shortcuts) |
| `com.bbk.launcher2.settings` | BBK / Vivo launcher |
| `com.huawei.hms.contentprovider` | HMS content provider |
| `com.huawei.hwid` | Huawei ID |
| `com.hihonor.android.pushagent.provider.` | Honor push agent |
| `com.meizu.flyme.openidsdk` | Meizu OpenID SDK |
| `com.sec.badge` | Samsung badge |
| `com.android.badge` | Generic launcher badge |
| `cn.nubia.provider.deviceid.dataid` | Nubia device ID |
| `com.tencent.mm.sdk.comm.provider` | WeChat SDK common provider |
| `com.tencent.mm.sdk.plugin.provider` | WeChat SDK plugin provider |
| `com.vivo.push.sdk.service.` / `com.vivo.vms.` | Vivo push / VMS |
| `com.xiaomi.push.providers.` | Xiaomi push |

---
## 17. Game Launch Types

`com.xiaoji.egggame.launcher.model.LaunchType` — full enum with integer codes and category groups (`smali_classes5/com/xiaoji/egggame/launcher/model/LaunchType.smali`, unchanged from 6.0.1):

| LaunchType | Code | Category | Description |
|---|---|---|---|
| `LaunchOtherApp` | 1001 (`0x3e9`) | LaunchOtherApp | Launch external app |
| `OpenUrl` | 1201 (`0x4b1`) | OpenUrl | Open URL in browser/webview |
| `XboxCloudGaming` | 1202 (`0x4b2`) | XboxCloudGaming | Xbox Cloud Gaming |
| `HidGame` | 1301 (`0x515`) | Mobile | HID-connected game |
| `MobilePlay` | 1302 (`0x516`) | Mobile | Mobile game play |
| `PsLink` | 1401 (`0x579`) | PsStream | PlayStation Link (remote play) |
| `PcLink` | 1402 (`0x57a`) | PcStream | PC link (remote desktop-style) |
| `PcEmulator` | 1403 (`0x57b`) | PcEmulator | Wine/WinEmu PC emulation (local) |
| `MovingCloudGaming` | 1406 (`0x57e`) | CloudGaming | Cloud gaming on mobile |
| `SteamGameByPcEmulator` | 1407 (`0x57f`) | PcEmulator | Steam game via WinEmu |
| `EpicGameByPcEmulator` | 1408 (`0x580`) | PcEmulator | Epic Games via WinEmu |
| `GogGameByPcEmulator` | 1409 (`0x581`) | PcEmulator | GOG.com via WinEmu |
| `SteamGameDetailByWeb` | 1501 (`0x5dd`) | SteamWebDetail | Steam web detail view |
| `MobileInstallApp` | 1502 (`0x5de`) | Mobile | Mobile app install |
| `TypeHid` | 7 | Mobile | HID type |
| `TypeMobilePlay` | 10 | Mobile | Mobile play type |
| `Unknown` | INT_MIN | Unknown | Fallback |

Categories present in `LaunchCategory.smali`: `LaunchOtherApp`, `OpenUrl`, `XboxCloudGaming`, `Mobile`, `PsStream`, `PcStream`, `PcEmulator`, `CloudGaming`, `SteamWebDetail`, `Unknown`.

**`LaunchMethodExtensionType`** enum (`smali_classes4/com/xiaoji/egggame/game/database/entity/LaunchMethodExtensionType.smali`):

| Value | Int |
|---|---|
| `PC_EMULATOR` | 1 |
| `STEAM` | 2 |
| `MOBILE` | 3 |
| `STREAMING` | 4 |

**Launch method models** (`smali_classes4/com/xiaoji/egggame/game/di/model/launchMethod/`): `LaunchMethod` (sealed base), `PcEmulatorLaunchMethod`, `PcStreamLaunchMethod`, `PsStreamLaunchMethod`, each with a `$$serializer` companion.

**Game extension models** (`smali_classes4/com/xiaoji/egggame/game/di/model/game/`):

| Class | Fields |
|---|---|
| `GameInfo` | base game info |
| `CloudExtension` | `cloudServiceType`, `cloudGameId`, `jumpUrl` |
| `MobileExtension` | `packageName`, `versionCode/Name`, `fileMd5`, `localMobileAppId`, `mobileIconUrl` |
| `PcEmulatorExtension` | `filePath`, `steamAppid`, `steamGameInfo`, `localGameIconPath`, `exeFileBgType`, `isLocalGame` |
| `PcStreamingExtension` | `pcStreamingCoverImage` |
| `PsStreamingExtension` | `isShortcut` |

---

## 18. Third-Party SDK Inventory

All packages verified to still exist under one of `smali/`, `smali_classes2..6/`, `assets/`, or `lib/arm64-v8a/`.

| SDK | Package(s) | Purpose |
|---|---|---|
| ExoPlayer (Media3) | `androidx.media3.*` | HLS/video/image/offline media playback |
| Google Firebase | `com.google.firebase.*` | Analytics, Auth, FCM, Crashlytics, Sessions, Installations |
| Google Play Services | `com.google.android.gms.*` | GMS, Sign-In, Credentials |
| Google Protobuf | `com.google.protobuf.*` | Data serialization |
| Google Gson | `com.google.gson.*` | JSON parsing |
| Glide | `com.bumptech.glide.*` | Image loading |
| Huawei HMS | `com.huawei.*` | AGConnect, HMS Push, HMS framework |
| Hi Honor | `com.hihonor.*` | Honor device push |
| HeyTap | `com.heytap.mcs.*` | OPPO push |
| Vivo | `com.vivo.*` | Vivo push / VMS |
| Xiaomi MiPush | `com.xiaomi.mipush.*`, `com.xiaomi.push.*` | Xiaomi push notifications |
| Meizu Push | `com.meizu.cloud.pushsdk.*` | Meizu Flyme push (MobPush channel) |
| MobPush | `com.mob.pushsdk.*` | Multi-channel push aggregator (Xiaomi/OPPO/vivo/Honor/Meizu/Unicom) |
| MobID | `com.mob.id.*` | Identity verification |
| FlyID | `cn.fly.*` | FlyID auth/identity |
| CMIC SSO | `com.cmic.sso.*` | SSO login (phone carrier) |
| Alibaba Phone Auth | `com.mobile.auth.gatewayauth.*` + `libpns-2.14.17-LogOnlineStandardCuumRelease_alijtca_plus.so` | One-tap phone login |
| Alipay | `com.alipay.sdk.*` | Payment |
| WeChat | `com.tencent.mm.opensdk.*` + `wxapi/` | Auth, payment, sharing |
| QQ / Tencent | `com.tencent.tauth.*`, `com.tencent.connect.*` | QQ auth, Tencent open platform |
| Weibo | `com.sina.weibo.sdk.*` | Weibo auth/sharing |
| JieLi BT OTA | `com.jieli.jl_bt_ota.*` + `libjl_ota_auth.so` + `libJieLiUsbOta.so` | JieLi controller firmware |
| GameSir | `com.xiaoji.egggame.common.gamepadota.ble.gamesirg6.*` + `libGamesir.so` | GameSir G6 OTA |
| Nordic DFU | `no.nordicsemi.android.dfu.*` | BLE DFU (gamepad firmware) |
| RxAndroidBLE | `com.polidea.rxandroidble2.*` | BLE peripheral communication |
| Haima IJK Player | `com.haima.*`, `tv.haima.ijk.*` + `libIjkffmpeg_haima.so` / `libIjkplayer_haima.so` / `libIjksdl_haima.so` | IJK media player (Haima fork) |
| Haima RTC / HMCP | `libhaima_rtc_so.so`, `com.haima.hmcp.*`, `org.hmwebrtc.*` | Full cloud-gaming stack: WebRTC + RTMP + WebSocket signaling + virtual input + DNS + Protobuf. Bundled FastJSON + Volley |
| Haima Countly | `countly.haimacloud.com` | Custom analytics |
| Nirvana Tools | `com.nirvana.tools.*` | App utility tools |
| AndroidUtils (blankj) | `com.blankj.utilcode.*` | Android utility library |
| LDNetDiagno | `com.netcheck.LDNetDiagnoService.*` | Network diagnostics |
| Qiniu | `com.qiniu.android.*` | Qiniu cloud storage (upload) |
| Koin | `org.koin.*` | Dependency injection |
| Ktor | `io.ktor.client.*` | Kotlin HTTP client |
| OkHttp3 | `okhttp3.*` | HTTP client |
| RxJava2 | `io.reactivex.*` | Reactive programming |
| BouncyCastle | `org.bouncycastle.*` (incl. `pqc`) | Cryptography (post-quantum) |
| Rustls | `org.rustls.platformverifier.*` | Rust-based TLS platform verifier |
| SnakeYAML | `org.yaml.snakeyaml.*` | YAML parsing |
| MsgPack | `org.msgpack.*` | MessagePack serialization |
| Compottie / WebView | `com.multiplatform.webview.*`, `com.radzivon.bartoshyk.*` | Compose Lottie / WebView |
| FileKit | `io.github.vinceglb.filekit.*` | KMP file picker |
| MMKV | `libmmkv.so` | Fast key-value store |
| Room | `androidx.room.*` | SQLite ORM |
| DataStore | `androidx.datastore.*` + `libdatastore_shared_counter.so` | Preferences storage |
| Zstd-JNI | `libzstd-jni-1.5.7-4.so` | Zstandard compression |
| awxkee/avif | `com.github.awxkee.*` | AVIF image codec |
| Luben/Zstd | `com.github.luben.zstd.*` | Zstd JVM bindings |
| EpicKit (UniFFI) | `uniffi.epickit_core.*` + `libepickit_core.so` | Epic Games SDK (Rust) |
| KRLY platform | `com.krly.platform.*` | Unknown (likely CN platform) |
| MCS AIDL | `com.mcs.aidl.*` | MediaCodec service AIDL |
| Unicom | `com.unicom.online.account.*` | China Unicom auth |
| JNA | `libjnidispatch.so` | Java Native Access |
| Fanttv Crash | `libfntvcrash.so` | Crash reporting |
| libaom / libdav1d / libde265 / libheif / libx265 | `lib/arm64-v8a/` | AV1/HEVC/HEIF codec stack |
| WinEmu | `com.xiaoji.egggame.common.winemu.*` + `libwinemu.so` + `libxserver.so` + `libvfs.so` + `libgpuinfo.so` | Wine-on-Android container |
| SteamKit | `libsteamkit_core.so` | Steam client core |

---

## 19. Removed Since 5.3.5

Re-probed against the 6.0.4 DEX — none of the following URLs/hosts appear anywhere in `smali*/`:

| URL | Was used for | Status (probed 2026-05-12 against 6.0.4) |
|---|---|---|
| `https://clientegg.vgabc.com/uxapi/` | Old secondary API | Absent from DEX |
| `https://landscape-api.vgabc.com/` | Production landscape API | Absent from DEX. Origin presumed alive server-side (Aliyun direct) but 6.0.4 will never call it. 6.0.x clients route through `clientgsw.vgabc.com/clientapi/` only |
| `https://test-landscape-api.vgabc.com/` | Test environment | Absent from DEX |
| `https://dev-gamehub-api.vgabc.com/` | Old dev API | Absent from DEX |
| `https://gamehub-lite-api.emuready.workers.dev/` | EmuReady Lite mode API | Absent from DEX |
| `https://gamehub-lite-token-refresher.emuready.workers.dev/token` | Lite token refresh | Absent from DEX |
| `https://cdn-library-logo-global.bigeyes.com/` | Game logo CDN | Absent from DEX |
| `https://uxdl.bigeyes.com/` | Game image CDN (old) | Absent from DEX. Replaced by `cdn-img-uxdl.youwo.com` (Fastly+GCS) |
| `https://www.xiaoji.com/url/gsw-app-rules` | App rules page | Absent from DEX |
| `https://www.xiaoji.com/url/obscure-click` | Click tracking | Absent from DEX |

---

## 20. Themes & Styles

- `Theme.GameHub` — main app Compose theme (parent `@android:style/Theme.Material.NoActionBar`); declared on `<application>` and on `MainActivity` in `AndroidManifest.xml`
- `Theme.WineUI` — custom AppCompat theme (parent `@style/Theme.AppCompat.NoActionBar`) for Wine emulation UI (`WineActivity`)
- 11 `haima_hmcp_*` styles — Haima HMCP cloud gaming UI (`haima_hmcp_dialog_style`, `haima_hmcp_video_dialog`, `haima_hmcp_virtual_dialog`, `haima_hmcp_input_dialog`, `haima_hmcp_vir_operate_btn`, `haima_hmcp_multiple_key_*` (3), `haima_hmcp_add_virtual_textview`, `haima_hmcp_add_xbox_text`)
- `attrs.xml`: `shortcutMatchRequired` (boolean) — custom attribute for launcher shortcut intent-filter matching
- `res/values/styles.xml` — 412 distinct `<style>` entries (most are AppCompat / Material defaults shipped via library merge). Identical entry count to 6.0.1.
- No separate `res/values/themes.xml` is emitted; all themes live in `styles.xml`.

---

## 21. Third-Party Metadata

All literals re-verified against `AndroidManifest.xml` meta-data tags and each SDK's `BuildConfig.smali` in 6.0.4. Unchanged vs 6.0.1.

| Key | Value |
|---|---|
| Alipay SDK App ID | `2021005104662679` (manifest meta-data `com.alipay.sdk.appId`) |
| HiHonor push SDK version | `8.0.12.307` (manifest meta-data `com.hihonor.push.sdk_version`) |
| Haima HMCP SDK version | `7.40.1` / build tag `master-7.40.1-e1e48796` |
| Firebase Messaging | `25.0.1` |
| Firebase Crashlytics | `20.0.3` |
| Firebase Installations | `19.0.1` |
| HMS Framework (common/network/grs) | `8.0.1.304` |
| Alibaba phone-number auth (com.mobile.auth) | `2.14.17` (`libpns-2.14.17-…_alijtca_plus.so`) |
| China Unicom account shield (com.unicom.online.account.shield) | `6.1.3` |
| Xiaomi Push SDK | `6_0_1-C` |
| Nordic Semi DFU | `2.3.0` |
| RxAndroidBLE | `1.11.1` |
| JieLi BT OTA | `1.10.0` |
| Zstandard JNI (luben) | `1.5.7-4` |
| WeChat App ID (primary) | `wx2075ef952b9b60c4` |
| WeChat App ID (secondary) | `wxf9d9756e4f820261` |
| QQ / Tencent OpenAPI App ID | `102667728` (also embedded in `tencent102667728://` callback scheme) |
| Epic OAuth Client ID | `34a02cf8f4414e29b15921876da36f9a` |
| GameHub `versionCode` | `114` |
| GameHub `versionName` | `6.0.4` |

---

## 22. New in 6.0 vs 5.3.5

Re-verified against 6.0.4. Every bullet still holds; deltas vs 6.0.1 baseline are called out inline.

| Area | Change |
|---|---|
| Package namespace | Entire `com.xj.*` tree renamed to `com.xiaoji.egggame.*`; only `com.xj.muugi.shortcut.*` (special + broadcast subpackages) survives |
| UI framework | Further migration to Jetpack Compose; **31 KMP `composeResources/` modules** (unchanged vs 6.0.1); **79 unique `AppNavKey$*` sealed routes** in `core/navigation/` (vs the original report's ≈119 estimate, which appears to have over-counted across `$$serializer` companions) |
| Card system | New `com.xiaoji.egggame.cardsystem` module — mini game launcher / card UI system |
| XGP integration | New — Xbox Game Pass redemption at `xgp.xiaoji.com` + `gamehub-service-dev.xiaoji.com/xgp/exchange` |
| Epic Games SDK | New — `libepickit_core.so` (UniFFI Rust) + `uniffi.epickit_core.*` (EpicActivationStoreRecord, EpicCatalogOfferMappingRecord, EpicCleanupReportRecord, EpicAuthSummaryRecord, etc.) + full EGS catalog/download/cloud-save integration |
| Retro emulation | New — Nostalgist.js `0.19.0` (`assets/composeResources/com.xiaoji.egggame.common.retro_emulators/files/emulator/nostalgist.0.19.0.umd.js`) + 6 platforms (GB/GBA/GBC/NES/SNES/MD) + JS bridge |
| Cloud gaming | VTouch subsystem with queue, billing, session management (`com.xiaoji.egggame.cloud.*` + `CloudGameDatabase`) |
| EmuReady Lite | Removed — all `emuready.workers.dev` endpoints gone |
| API endpoints | Old `landscape-api.vgabc.com` + `clientegg.vgabc.com` removed from DEX; `clientgsw.vgabc.com/clientapi/` retained as Client API base (verified in `smali_classes4/x4k.smali`) |
| HDR shaders | New — 4 Vulkan SPIR-V compute shaders at `assets/shaders/` (`GammaOetf.comp.spv`, `HLG.comp.spv`, `SMPTE2084.comp.spv`, `SMPTE428.comp.spv`) |
| AV1 / HEVC stack | New — `libaom.so` (encoder), `libdav1d.so` (decoder), `libde265.so`, `libheif.so`, `libx265.so` bundled |
| AVIF images | New — awxkee AVIF codec (`com.github.awxkee.*`) for cover art |
| Retro game DB | Room database `retro_emu_games.db` — `RoomDatabase: Lcom/xiaoji/egggame/retro_emulators/data/local/RetroGameDatabase;` (smali_classes5; DB-name literal at `RetroGameDatabase.smali:226`). Entities: `RetroGameEntity` (10 instance fields) + `RetroGameSessionEntity` (6 instance fields). DAOs: `RetroGameDao`, `RetroGameSessionDao`. Migration class: `RetroGameDatabase$Companion$MIGRATION_1_2$1`. Schema identity hash `78db956364e981c6e2e471039c99c41b` |
| Cloud game DB | New Room database `cloud_game_sessions.db` (`com.xiaoji.egggame.cloud.data.local.CloudGameDatabase`) |
| IAP system | Apple IAP + WeChat Pay + `db_pending_payment_v1.db` retry queue. RoomDatabase: `Lcom/xiaoji/egggame/features/pay/database/PayDatabase;` (smali_classes4; DB-name literal at `PayDatabase$Companion.smali:92`). @Entity: `PendingPaymentEntity` (10 instance fields). @Dao: `PendingPaymentDao` (interface) + `PendingPaymentDao_Impl` |
| GOG support | New LaunchType `GogGameByPcEmulator` (code 1409) — GOG.com via WinEmu |
| PlayStation | New LaunchTypes `PsLink` (1401) + `PsStream` category — PlayStation remote play / streaming |
| Xbox Cloud Gaming | Explicit `XboxCloudGaming` LaunchType (code 1202) in addition to XGP redemption |
| Daily sign-in | `cloud_sign/getActivity` + `cloud_sign/sign` reward system (verified in `smali_classes5/rqg.smali`) |
| ExoPlayer Media3 | New — `androidx.media3` (HLS, offline, image) |
| Analytics regions | CN + overseas separate API domains (6 endpoint variants) |
| DEX count | **6 dex files** (`smali` + `smali_classes2..6`) vs 13 in 5.3.5 |
| Min SDK | **29 (Android 10)** — *dropped from 31 in 6.0.1*; **delta vs original 6.0 report** |
| Target SDK | 36 (Android 16) — unchanged from 6.0.1 (up from 34 in 5.x) |
| Native libs | **27 libs** in `lib/arm64-v8a/` (vs ~20 in 5.x) — `libwinemu.so`, `libxserver.so`, `libvfs.so`, `libgpuinfo.so`, `libsteamkit_core.so`, `libepickit_core.so`, `libdav1d.so`, `libcoder.so`, `libaom.so`, `libde265.so`, `libheif.so`, `libx265.so`, `libGamesir.so`, `libJieLiUsbOta.so`, etc. |
| Push channels | 6 channels: FCM + HMS Push + MobPush (Xiaomi/OPPO/vivo/Honor/Meizu/Unicom) vs 3 in 5.x |
| Crypto | BouncyCastle now includes post-quantum (`org.bouncycastle.pqc.*`) |
| Compose Navigation | **Custom Compose nav** — sealed `AppNavKey` sub-routes under `com.xiaoji.egggame.core.navigation.*` with kotlinx-serialization `$$serializer` companions. No `androidx.navigation` or `androidx.navigation3` in smali (original report's "v3 (androidx.navigation3)" line was incorrect — same state held in 6.0.1) |
| Steam component type | `7 → 8` for Steam *clients* (agents stay at type 5) |
| Imagefs firmware | 1.3.4 (vanilla 6.0 baseline) — Worker serves **1.4.1** (versionCode 31) to **both** 5.x and 6.0 as of `5dc29a9` (7-site lockstep); the old "5.x stays on 1.3.3" split is retired |
| WinEmu SDK | `com.xiaoji.egggame.common.winemu.*` + `libwinemu.so` — HUDLayer, GPUInfoQuery, ProfilePuller, trans_layer all present |
| Steam SDK | `libsteamkit_core.so` retained; `SteamCloudSaveService` retained |

---
## 23. Decompile Output Locations

| Tool | Output path |
|---|---|
| apktool (full, with res) — **6.0.4 (current baseline)** | `~/gamehub_604_decompile/` |
| apktool (smali only, 6.0.4 ephemeral) | re-run command below into `/tmp/gh604_smali/` |
| jadx (Java source, 6.0.4) | `~/gamehub-6.0.4-jadx/jadx-out/` |
| Source APK (6.0.4) | `~/gamehub-6.0.4-jadx/gh604.apk` |
| apktool (6.0.1 baseline, retained for diff) | `/tmp/gh601_smali_res/` |
| apktool (6.0.0 baseline, retained for diff) | `~/gamehub-6.0-decompile/` |
| jadx (6.0.0 baseline) | `~/gamehub-6.0-jadx/` |
| Source APK (6.0.0) | `~/GameHub_beta_6.0.0_global.apk` |
| Source APK (6.0.1) | `~/GameHub_6.0.1.apk` |

Rebuild commands:
```
java -jar ~/apktool.jar d ~/gamehub-6.0.4-jadx/gh604.apk -o /tmp/gh604_smali -f --no-res
java -jar ~/apktool.jar d ~/GameHub_6.0.1.apk -o /tmp/gh601_smali -f --no-res
```

---

## 24. Related Reports

| Report | Location | Contents |
|---|---|---|
| BannerHub-API ↔ 6.0 integration | `gamehub_reports/BANNERHUB_API_6.0_INTEGRATION.md` | Worker behavior, ReVanced patches, `is60` gate, reshapeFor60, Steam remap, allowlist, 6.0 component-type table |
| HUD data sources (full) | `gamehub_reports/GAMEHUB_HUD_DATA_SOURCES.md` | Per-metric data path detail (sysfs, BatteryManager, JNI) |
| GameHub 5.3.5 master map | `gamehub_reports/GAMEHUB_535_MASTER_MAP.md` | 5.x baseline for diff comparisons |
| VK_NV_optical_flow on Adreno (deep dive) | `gamehub_reports/VK_NV_OPTICAL_FLOW_ON_ADRENO.md` | Mesa Turnip chip 6/7/8 dispatch + libGameScopeVK delta/gamma pipelines + ICD chain |
| Hosting plan for 6.0 mirrors | `gamehub_reports/HOSTING_FOR_GAMEHUB_600_PLAN.md` | Self-host strategy for imagefs / component archives |
| Pre-rewrite backup (6.0.0/6.0.1) | `gamehub_reports/GAMEHUB_600_MASTER_MAP.backup-2026-05-12.md` | Pre-6.0.4-refresh snapshot of this map |
| 6.0.0 → 6.0.1 backup | `gamehub_reports/GAMEHUB_600_MASTER_MAP.backup-2026-05-03.md` | Pre-§-26-expansion snapshot |

---

## 25. Appendix A — Scan History

### 2026-05-01 → 2026-05-03: Passes 22–32 against 6.0.0

After 21 initial passes (2026-05-01) the report was re-verified across 11 dimensions on 2026-05-02. Significant deltas surfaced before reaching the 3-consecutive-clean stop condition:

| Pass | Findings |
|---|---|
| **22** | Alipay/CN-carrier endpoints (5 new gateway hosts), full WinEmu native-server JNI surface (9 classes, 30+ native methods), 6 new MMKV IDs, additional URI schemes (Firebase Firebear, market://, app://, mqqapi sub-routes, weixin SDK schemes), 13+ external content:// providers, OEM-skinned package variants (`realme`, `redmagic`), secondary WeChat App ID, FlyID TCP DB (`elp_msg.db`), Compose nav routes (`HomeProfile`, `HomeTabPortrait`) |
| **23** | China-Telecom/Mobile/Unicom carrier hosts (8 new), MobPush gateways (`abroad.sdk.push.mob.com`, `sdk.push.mob.com`), FlyID server farm (`*.zztfly.com`, 7 hosts), Xiaomi push sandbox + chat hosts, Xiaoji internal dev domains (`*.mx520.com`) |
| **24** | Full SDK version inventory (15 SDKs), Alipay test/staging environments (`*.alipay.net`), Firebase Auth providers shipped (Facebook, Twitter, Play Games), Compose Navigation custom registry (NOT androidx.navigation3 — that was a misattribution corrected in 6.0.4 pass), compottie (Lottie for Compose), AndroidX Privacy Sandbox Ads |
| **25** | `Theme.GameHub` main theme, additional vendor-launcher permission (`GET_INSTALLED_APPS`), full multi-process layout (`:p0` for MobLReceiver), AndroidApp / BaseAndroidApp manifest entry separation |
| **26** | Additional WeChat / QQ / Weibo / Google API endpoints (16 new operational paths), Google OAuth scopes |
| **27** | Port-bearing carrier endpoint URLs (`crbt.i139.cn:8143`, `nisportal.10010.com:9001`) |
| **28** | Host-diff returned only doc/license false positives (1st clean) |
| **29** | Full deep-link intent extras (11 keys vs 2 in prior map) |
| **30** | SP/MMKV key fix (`sp_k_overlay_opacity` → `sp_k_cur_overlay_opacity`), 9 new app-level SP keys |
| **31** | Host-diff still clean (2nd clean) |
| **32** | JNI surface diff clean (3rd consecutive clean) — **stop condition met** |

### 2026-05-03 targeted re-verifications (post-pass-32, against 6.0.0)

- **Live API + CDN verification** — pulled vanilla 6.0 APK from device, extracted 7 DEX, dumped strings, probed all reachable hosts, cross-referenced against bannerhub-revanced. Surfaced the **two API surfaces** correction (Catalog vs Client), CDN host correction (`cdn-img-uxdl.youwo.com` not `bigeyes`), full probe matrix.
- **Endpoint Functional Map** — first-pass functional grouping of every URL by what user-facing or runtime behavior it drives.
- **Reorganization + lightly-covered expansion** — full restructure under §§ 1–25, BannerHub-API integration extracted to its own report, targeted decompile passes for: WinEmu native-server JNI methods (full signatures from jadx), all 43 Card serializer fields, perf telemetry layered DTOs (CapturedPerfSample → StoredPerfSample → DevicePerfReportDataDto → DevicePerfReportEventDto), VJoy serializer field lists, WebView Java↔JS bridge methods, `BaseAndroidApp.onCreate` actual init order, full `cloud/*` path enumeration, 10 epic_data/* recovery-governance JSON endpoints.

### 2026-05-07: § 26 expansion (6.0.0 → 6.0.1 deltas)

18 angle-pass scans against `GameHub_6.0.1.apk` (versionCode 111): manifest, native libs, kept-package classes, all string literals, resources/assets, `$$serializer`/DTOs, AI frame-gen deep dive, Compose nav graph, DB entities/DAOs, sealed/abstract hierarchies, package-level class counts, all-locale string resources, top-level package counts, drawables, composeResources, WineInGameSettingType members, all `com.xiaoji.egggame` enums + 3 consecutive empty passes confirming termination. Detailed sub-section list at § 26.

### 2026-05-12: Full 6.0.4 refresh

Decompile of `gh604.apk` (versionCode 114, versionName 6.0.4, new r8-map-id `6a5cde6143fc8cf76f6f3a447d0fececd4794d83066e6ead7a9537e6527b057b`) into `~/gamehub_604_decompile/`. Every section §§ 1–22 re-verified against the 6.0.4 smali tree using 9 parallel verification passes:

| Pass | Scope | Key deltas surfaced |
|---|---|---|
| A | §§ 1, 2, 6 (Identity, Architecture, Manifest) | versionCode 110/111 → 114; `minSdkVersion 31 → 29` (Android 12 → 10); +2 permissions (`BLUETOOTH`, `BLUETOOTH_ADMIN`); deep-link table re-attributed (Tencent/GenericIdp/Recaptcha live on their own SDK activities, not DeepLinkActivity); `us2.smali` Koin DI anchor was stale (now `ColorCacheKey`) |
| B | §§ 3, 4, 5 (Native, Assets, Resources) | `libsteamkit_core.so` 10.0 MB → 10.9 MB (+880 KB; absorbs `LaunchIntent` JNI); `libwinemu.so` 684 KB → 658 KB; **`DirectRendering` JNI removed entirely**; XServer `setRenderingEnabled` → `setFlipEnabled`; `SteamAgentTicketIssuer` replaced by `LaunchIntent.nativeCreateLaunchPayload`; META-INF 109 → 108 entries; obfuscated service-provider names refreshed |
| C | §§ 7, 8 (DEX, Entry points) | DEX class totals 53,053 → 53,766 (c1 +156, c4 −1,092, c6 +1,877); `com.winemu.*` package reshuffle (XServer ui/→core/server/; TapHandler →core/input/; StatusData→core/steam_agent/; new top-level BottleMetadata, CabFile, GPUInfoQuery); `EnvVars` now LinkedHashMap-backed Parcelable Iterable (no hardcoded supported-key list); `AppNavKey` 119 → 79 destinations; 11th deep-link extra `app_nav_launch_type` no longer in MainActivity (only `smali_classes5/zi7.smali` references it) |
| D1 | § 9.1 WinEmu | Cache singleton `Lltn;` → `Lj7o;` (4 ConcurrentHashMaps) + new backend `Lmyo;`; read API `z(RepoCategory)→ArrayList` **deleted**, replaced by `x(RepoCategory)→Ltge;` (SharedFlow) + `i(RepoCategory, String)→WinEmuRepo`; `EnvLayerEntity` 19 → 21 fields; `ComponentType` 7 → 8 values (`STEAMCLIENT(7)` annotated `@Deprecated`); `PcGameSettingSchemePayload` 17 → 18 fields (+`hostCoreMask`); `WineActivityData` 23 → 27 fields; `WineInGameSettingType` 17 values; net-new `AiFrameInterpolation`, `GyroAim`, `ScreenTouchInput`, `HdrPreset`, `HudData` beans |
| D2 | §§ 9.2–9.10 (Steam, Epic, Retro, Cloud, IAP, Card, VJoy, HUD, Telemetry) | `ControlAppearance` 30 → 42 fields; `VJoyLayout` 6 → 9 (+layers/activeLayerIndex/nextLayerIndex/description); `VJoyControl` 6 → 7 (+action); `EpicDownloadJobRecord` 21 → 20 (+cover, +verticalCover); `SteamInstalledAppMetadata.launchInfo` typed `SteamGameLaunchInfo` (was `Any`); pay-package root moved to `features.pay.*` (classes4); telemetry root to `features.winemu.perf.*`; UniFFI epickit_core 160 → 183 java files; native libs sized live (steamkit 11.4 MB, epickit 4.72 MB, haima_rtc 8.27 MB) |
| E | §§ 10, 11 (DTO Inventory, Storage) | [agent in progress — fill on consolidation] |
| F | §§ 12–16 (API, CDN, 3P SDK endpoints, URI, providers) | [agent in progress — fill on consolidation] |
| G | §§ 17–22 (Launch, SDK inventory, Themes, Metadata, New-in-6.0) | `styles.xml` 711 → 412 entries (overcounted in 6.0.0 doc); `haima_hmcp_*` styles "13+" → 11; "Compose Navigation v3 (androidx.navigation3)" claim **wrong** — no `androidx.navigation*` in smali, nav is custom (same in 6.0.1); `Theme.GameHub` parent is `@android:style/Theme.Material.NoActionBar`; AppNavKey 79 unique routes confirmed; 27 native libs enumerated |
| H | § 26 reframe to cumulative 6.0.0 → 6.0.4 | All 13 R8 class letters from § 26.2 re-derived against 6.0.4 structural anchors; URL-builder interface TBD from 6.0.1 (`Lyw9;`) resolved as `Lv6a;`; firmware row added for 1.3.7; libsteamkit_core size column extended to 6.0.4; § 26.22 NEW table for the two new 6.0.4 strings (`winemu_sidebar_hud_engine`, `winemu_sidebar_touch_input_right_stick_sensitivity`) |

**Strings.xml diff (6.0.1 → 6.0.4):** 762 → 764 keys (+2 sidebar-only: `winemu_sidebar_hud_engine`, `winemu_sidebar_touch_input_right_stick_sensitivity`). Setup/install flow strings, container validator strings, error UX strings — all unchanged.

**6.0.2 / 6.0.3 caveat:** intermediate point releases (versionCodes 112, 113) were not separately decompiled. Feature deltas above are attributed to "6.0.4" but the exact point-release timing within the 6.0.1 → 6.0.4 window is unknown for each individual change.
---
## 26. 6.0.0 → 6.0.4 Deltas (cumulative)

> Section originally added 2026-05-07 to document the 6.0.0 → 6.0.1 jump; updated 2026-05-12 for 6.0.4 (versionCode 114). The doc baseline is now 6.0.4, so each subsection cumulates: 6.0.0 → 6.0.1 facts retained for history, 6.0.2/6.0.3/6.0.4 deltas folded in below. The 6.0.2 and 6.0.3 builds were not separately decompiled — feature deltas attributed to "6.0.4" below were verified against the 6.0.4 APK only; intermediate point-release timing is unknown.

XiaoJi shipped GameHub 6.0.1 on 2026-05-07 (versionCode 110 → 111). 6.0.4 ships at versionCode 114 (string count 762 → 764 — only **two** new resource keys total across the entire 6.0.1 → 6.0.4 span; both are sidebar features, see § 26.22). This section documents the *cumulative delta* against the 6.0.0-derived map in §§ 1–25; it does NOT re-enumerate the unchanged surface. Cross-reference `BANNERHUB_API_6.0_INTEGRATION.md` § 14 for the BannerHub Worker + bannerhub-revanced patch updates triggered by these changes.

### 26.1 APK Identity bump

| Field | 6.0.0 | 6.0.1 | 6.0.4 |
|---|---|---|---|
| versionName | 6.0.0 | 6.0.1 | 6.0.4 |
| versionCode | 110 | 111 | 114 |
| platformBuildVersionName | 16 | 16 | 16 |
| compileSdkVersion | 36 | 36 | 36 |
| signing cert SHA-256 | f6dc89251d2edf60c5721524d59f2dc6373825a73b1b81d031cafeeff31c9775 | unchanged (same `gamesir` cert) | unchanged (same `gamesir` cert) |
| r8-map-id (source comment) | `60560d24e8bcc45c0b2a1383d0d901f6ddb757a48af5ae5971565c863742b7e9` | `1c1886510d561c4653513192b80f6aeca10d1a5fcff2e7c8e7498396fe52a4ea` | `6a5cde6143fc8cf76f6f3a447d0fececd4794d83066e6ead7a9537e6527b057b` |
| total string resource count (`res/values/strings.xml`) | — | 762 | 764 |

R8 map-id changed at BOTH bumps → expect class-letter shifts everywhere on each step. Manifest declarations are otherwise structurally identical (same providers, same activities, same permissions modulo the new vjoy nav-keys discussed in § 26.3, and the manifest correction in § 26.21 which still holds in 6.0.4).

### 26.2 R8 class-letter remap

The full set of letters that bannerhub-revanced patches care about. 6.0.1 column verified against `/tmp/gh601_smali_res/` (apktool d --no-res from `GameHub_6.0.1.apk`); 6.0.4 column verified against `/data/data/com.termux/files/home/gamehub_604_decompile/` (apktool d from `GameHub_6.0.4.apk`). Each row is a structural anchor — re-derive on any future minor bump by matching shape, not by chasing letters.

| 6.0.0 | 6.0.1 | 6.0.4 | Role | Structural anchor |
|---|---|---|---|---|
| `Los0;` | `Lrs0;` | `Ljt0;` | Auth-session impl | Class with three instance fields of the same StateFlow-impl type AND ctor accepting `UserDao` + `AuthTokenDao` (in 6.0.4 the field type is `Lozh;`, was `Luph;` in 6.0.1) |
| `Lis0;` | `Lls0;` | `Ldt0;` | Auth-session interface | Interface with abstract `d()`/`e()`/`h()` returning the StateFlow read type, plus default helpers `a()Z`, `b()`, `f()` |
| `Lxm7;` | `Lhp7;` | `Lvu7;` | GameLibraryRepository | Class with `b:AUTH_INTERFACE` field AND ctor taking `GameLibraryDatabase` + `AUTH_INTERFACE` |
| `Lg8e;` | `Lade;` | `Lgme;` | Navigator | Class with `b:AUTH_INTERFACE` field AND two methods (`i`/`r`) whose body matches `iget…dt0->a()…if-nez…new-instance L<login-intent>;` (8 fields a..h, ctor takes 4 args, has companion-style static `o(Self;Gate;)V`) |
| `Lga0;` | `Lca0;` | `Lta0;` | Login navigation intent | The `new-instance` referenced inside the navigator gates above (extends the gate-param super class) |
| `Lrh0;` | `Lph0;` | `Lhi0;` | Navigator gate param type | The single param type to navigator's `i`/`r` methods (super of the login intent) |
| `Ll4m;` | `Lfdm;` | `Lwpm;` | Auth token wrapper | 10-field data class (S,S,S,S,Long,Long,J,Z,J,J) returned by `AUTH_INTERFACE.f()` |
| `Lf4m;` | `Ladm;` | `Lrpm;` | User account | 27-field data class (a..z+A — Strings, Ints, Booleans, Longs) returned by `AUTH_INTERFACE.b()` |
| `Lf3k;` | `Lr8k;` / `Lt8k;` | `Lyjk;` | StateFlow read interface | Interface with single abstract `getValue()Object` |
| `Lr8o;->r(Object)Lf3k;` | `Lumn;->h(Object)Lt8k;` | `Lixo;->l(Object)Lakk;` | MutableStateFlow factory | Static `(Object)→MutableStateFlowImpl` whose body is `new-instance` + `<init>(p0)V` + `return v0` (in 6.0.4, falls back to `Lyyo;->i:Ltr6;` sentinel when input is null) |
| `Lmcj;` | `Lzhj;` | `Lesj;` | Catalog Environment enum | The unique class containing both `landscape-api-cn.vgabc.com` AND `landscape-api-oversea.vgabc.com` string literals |
| `Lzdb;` | `Lohb;` | `Lcpb;` | Static URL-path helper (Ktor pipeline) | Class implementing the HTTP-wrapper interface (`Ly40;` in 6.0.4 / was `Lj40;` in 6.0.1) with `e:ApiCacheDao` field AND a `static b(LBuilder;String)V` whose body iget-objects the builder's URL field then calls a string-trim helper |
| `Lqx9;` | `Lj1a;` | `Ln7a;` | Ktor URL-builder type | The first param type of the URL-path helper above |
| `Lyw9;` | TBD | `Lv6a;` | Ktor URL-builder interface implemented by the builder type | Interface implemented by the URL builder class (`Ln7a;` in 6.0.4 declares `.implements Lv6a;`) |
| `Llxb;` (NavigationInterceptor-style iface) | `Llxb;` | `Le5c;` | Interceptor interface used by `NavigationInterceptor` (§ 26.5) | Interface implemented by 6.0.1 `Lar0;` / 6.0.4 `Lsr0;` with `getOrder()I` + `a(Frame;Chain;Cont)Object` |
| `Lar0;` (new in 6.0.1, see § 26.5) | `Lar0;` | `Lsr0;` | NavigationInterceptor (auth gate) | Single-field class (`a:Ldt0;`) implementing the interceptor interface with `getOrder()I` returning 0xa |

Remap status: **13 letters re-derived from anchors for 6.0.4**, **zero TBD remaining** (the 6.0.1-era TBD for the URL-builder interface is now resolved: `Lv6a;`). bannerhub-revanced action: all of these letters are centralized in named const blocks at the top of `BypassLoginPatch.kt`, `RedirectCatalogApiPatch.kt`, `PrefixApiPathPatch.kt` plus the two Java extensions (`FakeAuthToken.java`, `FakeUserAccount.java`). Each const has a structural-anchor comment describing the recipe to re-derive it on the next R8 reshuffle.

> **Patch-author note (re §§ 9.1.1):** ComponentType has **8** values in 6.0.4 (TRANSLATOR=1, GPU=2, DXVK=3, VKD3D=4, GENERAL=5, DEPENDENCY=6, STEAMCLIENT=7, STEAMCLIENT_RUNTIME=8). Earlier § 9.1.1 of this doc enumerated only 7 — it was missing STEAMCLIENT. Both `STEAMCLIENT` and `STEAMCLIENT_RUNTIME` were already present in 6.0.1 and remain in 6.0.4 (verified by `enum` field listing in `com/xiaoji/egggame/common/winemu/bean/ComponentType.smali`). Treat § 9.1.1 as superseded for the value count; the cumulative truth is 8 values.

### 26.3 New vjoy/Scheme cloud-share subsystem

6.0.1 introduces a full "share your touch overlay / virtual joystick layout" feature. **All structural elements still present in 6.0.4** (verified: all 7 `AppNavKey$VJoy*` serializers, both `Gamepad$KeyMapping` + `GamepadKeyMappingP1` nav keys, and all `SchemeDetailEntity`/`SchemeShareEntity` classes survive in 6.0.4's smali tree; class letters for repository/ViewModel shifted with the R8 reshuffle but shapes are intact). Architecture:

#### Compose nav keys (un-mangled, kept by R8 keep-rules)
- `com.xiaoji.egggame.core.navigation.AppNavKey$VJoyMain` — main vjoy screen (entry point)
- `AppNavKey$VJoyMainSheet` — bottom sheet picker
- `AppNavKey$VJoyEdit`, `AppNavKey$VJoyHudEdit` — editing screens
- `AppNavKey$VJoyHudMain` — HUD overlay
- `AppNavKey$VJoyIconFolder`, `AppNavKey$VJoyHudIconFolder` — icon picker
- `AppNavKey$GamepadKeyMapping`, `AppNavKey$GamepadKeyMappingP1` — physical-controller key mapping (separate from vjoy)

#### Data model (kotlinx-serializable, R8-kept)
Layout schema lives in `com.xiaoji.egggame.common.ui.vjoy.model.*`:
- `VJoyControl`, `VJoyIconConfig`, `VJoyTextAlign`, `IconScaleMode`
- `ControlAction` + `ControlAction.SwitchLayer` (multi-layer schemes — matches the upstream feature note "Virtual button layouts can now be switched dynamically via keypress")
- `ControlAppearance`, `ControlPosition`, `ControlShape`, `ControlType`
- `Anchor`, `AxisRole`, `GamepadButton`, `DPadDirection`, `DPadChromeDefaults`, `VButtonChromeDefaults`, `InputMapping`
- `com.xiaoji.egggame.common.vjoy.data.OfficialLayoutEntry` + `OfficialPackEntry` — bundled official packs
- `com.xiaoji.egggame.core.domain.vjoy.model.VJoyFeedPage` — server feed page wrapper

Cloud catalog entry: `com.xiaoji.egggame.features.winemu.data.remote.SchemeDetailEntity` (21 fields):
`id` (long), `shareCode`, **`configBody`** (the full vjoy layout JSON), `gameId`, `sourceGameId`, `sourceType` (int), `createdBy`, `createdTime` (long), `shareUserAvatar`, `downloadCount` (int), `downloadRatio` (double), `activeUserRatio` (double), `matchLevel`, `matchLevelLabel`, `gpuGroupName`, `isCommon` (int), `isOfficial` (int), `isRecommend` (int), `status` (int), `schemeSource`.

`SchemeShareEntity` (4 fields): `id`, `shareCode`, `sourceGameId`, `sourceType`. Used for the lighter share-record payloads.

#### sourceType enum (`Lxu7;` in 6.0.1; class letter shifted with R8 reshuffle in 6.0.4 — re-derive via the unique `"SteamDownload"` string literal)
| Value | Server name | UI/source label |
|---|---|---|
| `unknow` | UnKnow | (placeholder) |
| `steam_game` | SteamDownload | Steam-imported game |
| `pc_imported_game` | PcGameHubMgrImport | PC import via GameHub Manager |
| `imported_game` | LocalImport | Local import |
| `gamehub_download_pc_game` | GameHubSvrDownload | GameHub-hosted PC game |

#### Repository / ViewModel
- Repository (6.0.1): `Lnyf;` implements `Lkyf;` — config-share API surface. Constructor `<init>(Lj40;Lzi5;Lhp7;)V` (CoroutineScope + HTTP client + GameLibraryRepository). 6.0.4 letter shifted with R8 reshuffle; re-derive via `(Ly40;<Json>;Lvu7;)V` ctor shape — TBD when patch needs it.
- ViewModel: `Lf1g;` extends `Lxc1;` — fields `i:Ljcf;`, `j:Lkyf;`. Has 23 methods (`a..K`). 6.0.4 letter TBD; anchor: `xc1` subclass holding repo + scheme-detail-info field, 23 alphabet methods.
- Feed loader UI tag: `VJoy_MainRecommend` (Logcat tag visible during failures)
- In-app cache key shape: `vjoy_recommend_list:gameId=<n>:type=<n>:page=<n>:size=20`

#### Bundled assets
- `composeResources/com.xiaoji.egggame.common.vjoy/files/vjoy/layout/index.json` — official packs index
- `composeResources/com.xiaoji.egggame.common.vjoy/files/vjoy/icons/index.json` — official icon set
- 30+ drawable assets under `composeResources/com.xiaoji.egggame.features.vjoy/drawable/features_vjoy_*.{xml,png,jpg}`

#### On-device storage
No Room entity / table for downloaded schemes — the `configBody` JSON is persisted via **MMKV** (the app's primary KV store, accessed via `MMKV.mmkvWithID(...)` in `WineActivity.smali`). Path on device: `/data/data/<variant pkg>/files/mmkv/`. The 30-MB SP key prefix `gamepad_key_mapping_p1_` (in `Ldw5;` in 6.0.1; letter TBD in 6.0.4) tracks the physical-controller mapping separately.

### 26.4 New API endpoint family

All endpoints still served in 6.0.4 (verified: `vcontroller/recommendMapList` + `vcontroller/shareMap` string literals still present in `/data/data/com.termux/files/home/gamehub_604_decompile/smali_classes4/rqn.smali`).

| Path | Method | Purpose |
|---|---|---|
| `/vcontroller/recommendMapList` | GET | Recommended vjoy layouts feed (paginated; `game_id`, `is_official`, `page`, `page_size`) |
| `/vcontroller/shareMap` | POST | Upload a layout to share |
| `/vcontroller/getMapByShareCode` | GET | Resolve a layout by share code |
| `/simulator/configList` | GET | Per-game saved-config list (`list_type`, `game_id`, `steam_appid`, `source_game_id`, `source_type`, `page`, `page_size`, `steam_id`, `game_type`, `gpu_*`) |
| `/simulator/getConfigById` | GET | Fetch one config |
| `/simulator/shareConfig` | POST | Upload a per-game config |
| `/simulator/deleteShareConfig` | POST | Remove a shared config |
| `/simulator/reportConfigApply` | POST | Telemetry: user applied a config |
| `/readLayoutType/query` | GET | Read user's chosen layout-type preference |
| `/writeLayoutType/set` | POST | Persist user's layout-type preference |

**Authentication shape (captured live 2026-05-07, unchanged in 6.0.4):** GET requests carry `clientparams` + `sign` (MD5-of-sorted-params + secret) + `time` headers — no `token`, no `Authorization`, no token-in-query. Upstream returns `{code:401, msg:"Please login first"}` for any unauthenticated request. The bannerhub-revanced bypass-login patch makes the *client* think it's logged in (so the call fires) but does NOT add a token to the wire — the BannerHub Worker fixes this server-side via the proxy in `BANNERHUB_API_6.0_INTEGRATION.md` § 14.5.

### 26.5 NavigationInterceptor (added 6.0.1, still present in 6.0.4)

Originally added in 6.0.1 as `Lar0;`. In 6.0.4 the class is **`Lsr0;`** (re-derived via the unique structural anchor: implements `Le5c;`, single field `a:Ldt0;`, ctor takes a single `Ldt0;` arg, `getOrder()I` returns 0xa). Its `a(L<frame>;L<chain>;L<cont>;)Object` method (signature in 6.0.4: `a(Lw4c;Lz2c;Lbi3;)Ljava/lang/Object;`):
- iget-object `Lsr0;->a:Ldt0;` (auth-session field) — was `Lar0;->a:Lls0;` in 6.0.1
- invoke-interface `Ldt0;->a()Z` (was `Lls0;->a()Z` in 6.0.1)
- if-nez `:cond_0` (skip on logged-in)
- new-instance redirect-to-login navigation result
- `:cond_0` → delegate to the next interceptor in the chain

Acts as a parallel auth gate independent of the navigator class (`Lgme;` in 6.0.4 / `Lade;` in 6.0.1 / `Lg8e;` in 6.0.0). The `BypassLoginPatch` short-circuits this gate identically (replaces `invoke-interface a()Z` + `move-result` with `const/4 vN, 0x1`) — the patch's anchor is structural (instruction sequence), so it survives both R8 reshuffles.

### 26.6 Firmware version bump

- 6.0.0 + earlier 6.0.1 client → asks Worker for `getImagefsDetail` → BannerHub Worker returned **firmware 1.3.4** (versionCode 24, asset `imagefs_v134.zst`, MD5 `76a186c04196c0ffe31ea1ab88705b83`, 168 MB)
- Worker bumped 2026-05-07 (commit `687a9ac`) → returned **firmware 1.3.5** (versionCode 25, asset `imagefs_v135.zst`, MD5 `d2242c284e42cbbe49289caf4506b95d`, 164 MB)
- Worker bumped 2026-05-08 (commit `280687f`) → **firmware 1.3.6** (versionCode 26, asset `imagefs_136.zst`, MD5 `bc95fcb8dc02dac7d61e1be7dd374aeb`, 171,913,961 B / ~164 MB)
- Worker bumped 2026-05-10 (commit `915cd37`) → **firmware 1.3.7** (asset `imagefs_137.zst`) on the `/v6/` gate; commit `45c3d2f` (2026-05-11) then bumped the 5.x `executeScript` clients to 1.3.7 — first step toward dropping the 5.x/6.0 split
- Worker bumped 2026-05-14 (commit `2d88572`) → **firmware 1.3.8** across **both** 5.x and `/v6/` paths
- Worker bumped 2026-05-15 (commit `5dc29a9`) → **current: firmware 1.4.1** (versionCode 31, asset `imagefs_141.zst`, MD5 `643024d54f11d01196ffdb2918dc3c85`, 172,206,649 B / ~172 MB; source: upstream `uxdl.mac520.com` `imagefs.zst`). **7-site lockstep** — the `/v6/getImagefsDetail` gate, the static 5.x `getImagefsDetail`, and the `executeScript/{generic,qualcomm}[,_steam]` paths all serve 1.4.1. The earlier "5.x clients still get static 1.3.3" behavior is **retired**.
- File listing inside 1.3.6 was byte-identical to 1.3.5 (same 7,799 entries); the only meaningful 1.3.5→1.3.6 delta was `usr/lib/libGameScopeVK.so` rebuilt — 2,218,920 → 2,218,904 B (-16 B), MD5 `17993261…` → `6d611691…`. 1.3.7 adds +240 B to libGameScopeVK.so and patches the pipe-failure fallback path. 1.3.8 and 1.4.1 are sourced from upstream XiaoJi (`uxdl.mac520.com`) — internal byte-level deltas not separately measured here. No UI surface change at the GameHub-client level for any of these bumps.
- v134 + v135 + v136 + v137 + v138 are all retained on the Components release as rollback safety.

6.0.4 imagefs routing is identical in shape to 6.0.1's — the client still pulls firmware metadata from `executeScript` + `getImagefsDetail` + `getDefaultComponent`. The **server** still branches on the `/v6/` path prefix for other concerns, but firmware version is **no longer** one of them: as of `5dc29a9` both the `/v6/` and 5.x paths return 1.4.1 (7-site lockstep).

### 26.7 Upstream feature highlights (XiaoJi-side, from the 6.0.1 release notes)

These are XiaoJi's own client-side changes that BannerHub users inherit by virtue of running v1.0.1-601 or later (still active in 6.0.4):

1. Improved Steam login + game download stability
2. Faster Steam game launch speeds
3. Virtual button layouts can now be switched dynamically via keypress (matches the new `ControlAction.SwitchLayer` data class — a layout can declare named layers and a keybind switches between them at runtime)
4. Multiple new touchscreen input methods
5. Gyroscope support for camera control
6. AI frame generation now supported across all games (separate from any LSFG-VK / DLL-based frame-gen experiments — this is XiaoJi's own host-code feature)
7. Numerous bug fixes

XiaoJi did not publish release notes for the 6.0.2 / 6.0.3 / 6.0.4 point bumps; the resource-string delta (only **two** new sidebar strings — `winemu_sidebar_hud_engine` and `winemu_sidebar_touch_input_right_stick_sensitivity`, see § 26.22) plus the libsteamkit_core.so growth (§ 26.20) is the entire user-visible behavioral footprint we can attribute to the bump in static analysis. Most of the 6.0.1 → 6.0.4 delta is presumably bug fixes + the Steam-SDK refresh.

---

### 26.8 — AI Frame Generation — Technical Deep Dive

> Internal name: **AI Frame Interpolation**. User-facing name: **AI Frame Generation**. Classes live under `com.xiaoji.egggame.common.winemu.bean.*` (R8-kept). The user-facing toggle is in the **Wine in-game sidebar/drawer** — not in pre-launch settings. **Still fully present in 6.0.4** — all 7 mode enum values, the `gamescope.control` mmap layout, and the `ai_frame_interpolation_*` string family are unchanged.

#### 26.8.1 Data classes (kotlinx-serializable, kept)

```
com.xiaoji.egggame.common.winemu.bean.AiFrameInterpolation
  └─ field: AiFrameInterpolationMode mode      // single field; default = Disabled

com.xiaoji.egggame.common.winemu.bean.AiFrameInterpolationMode (enum, 7 values)
  ├─ Disabled  (model=0, multiplier=2, flowScale=0.6, enabled=false)  ← off state
  ├─ Fast      (model=0, multiplier=2, flowScale=0.2, enabled=true)
  ├─ Smooth    (model=0, multiplier=2, flowScale=0.4, enabled=true)
  ├─ Balanced  (model=0, multiplier=2, flowScale=0.6, enabled=true)   ← default-on
  ├─ Enhanced  (model=0, multiplier=2, flowScale=0.8, enabled=true)
  ├─ Clear     (model=1, multiplier=2, flowScale=0.6, enabled=true)   ← model 1
  └─ Extreme   (model=1, multiplier=1, flowScale=0.8, enabled=true)   ← model 1, mult=1 (UI label only — see 26.8.4)
```

Each mode carries:
- `enabled: boolean` — whether selectable (Disabled is the only `enabled=false`)
- `model: int` — 0 = standard interpolation, 1 = "clear/extreme" (different shader path)
- `multiplier: int` — frame multiplier (2 = 60→120 fps; 1 = unusual, see 26.8.4)
- `flowScale: float` — optical-flow algorithm strength, range 0.2–1.0
- `nameResId: int` — `iih.ai_frame_interpolation_mode_*`
- `sliderLabelResId: int` — `iih.ai_frame_interpolation_label_*`

`Companion.defaultEnabled` = `Balanced`.

#### 26.8.2 Persistence — `WineInGameSettingType`

```
WineInGameSettingType.AiFrameInterpolation
  ├─ key   = "AiFrameInterpolation"
  ├─ scope = WineSettingScope.Game        (per-game / per-container)
  └─ codec = WineSettingCodec.Json(AiFrameInterpolation.class)
```

Stored via `p0o.x(WineInGameSettingType, value)` → MMKV.encode under the variant package's MMKV root (the `p0o` letter is from 6.0.1; 6.0.4's class letter for this static helper shifted with the R8 reshuffle — re-derive by the unique `"AiFrameInterpolation"` const-string + MMKV-encode call sequence). Sits alongside other in-game settings (FullScreen, Hdr, Crt, SuperResolution, FpsLimit, NativeRendering, RedMagicPerformanceMode, KeyControlsAlpha, VirtualGamepadVibration, TouchScreenMouseControl, SimulateTouchScreen, ScreenTouchInput, GyroAim, GamepadSensitivity, DrawerGuideShown).

#### 26.8.3 Runtime IPC — `etc/gamescope.control` mmap

The Java side communicates with the in-imagefs compositor via a 10-byte memory-mapped file at `<wineprefix>/etc/gamescope.control`. Wrapper class: `defpackage.ca2` in 6.0.1 — file constructor `ca2(File file)`. In 6.0.4 the letter shifted; re-derive by anchor: class with `RandomAccessFile("rw")` + `channel.map(READ_WRITE, 0, 10)` ctor body that writes a `(short) 0` at offset 0.

**Buffer layout (10 bytes, little-endian) — unchanged in 6.0.4:**

| Offset | Size | Field | Initial | Setter | Notes |
|---|---|---|---|---|---|
| 0–1 | 2 B | uint16 reserved/version | 0 | (init only) | `putShort((short) 0)` in ctor |
| 2 | 1 B | **enabled flag** | 0 | `ca2.G(boolean)` | 0=AI frame interp off, 1=on |
| 3 | 1 B | NativeRenderingMode (0=Auto, 1=Never, 2=Always) | 0 (Auto) | `sz4.b(NativeRenderingMode)` | not new in 6.0.1 — pre-existing slot |
| 4–7 | 4 B | **AI flowScale float** | 0.6 | `sz4.a(...)` | clamped 0.2–1.0 via `br5.x()` |
| 8 | 1 B | **AI model byte** | 0 | `sz4.a(...)` | `0` = standard, `1` = clear/extreme |
| 9 | 1 B | **AI multiplier byte** | 2 | `sz4.a(...)` | clamped 2–4 via `br5.y()` |

Total file size = 10 bytes. Created via `RandomAccessFile("rw")` + `channel.map(READ_WRITE, 0, 10)`. Each write is followed by `MappedByteBuffer.force()` to flush. `ca2.G(boolean)` writes only the enabled byte (offset 2).

#### 26.8.4 The `multiplier=1` quirk

`AiFrameInterpolationMode.Extreme` has `multiplier=1` in the Kotlin enum, BUT the IPC writer (`sz4.a()`) clamps via `br5.y(multiplier, 2, 4)` so the byte at offset 9 is always 2-4 inclusive. **Extreme's multiplier=1 is silently coerced to 2 at the IPC layer.** This implies `multiplier=1` is a UI-label-only marker (used elsewhere to choose iconography or label text) and the actual frame-multiplier delivered to the compositor is always 2× minimum. Reverse-engineered hypothesis: `multiplier` in the enum is not the literal frame multiplier — it's a "model variant" tag the UI uses to differentiate Clear (`mult=2`) from Extreme (`mult=1`) presets while both run at 2× compositor multiplication.

#### 26.8.5 Compositor side — `libGameScopeVK.so`

Path inside imagefs: `usr/lib/libGameScopeVK.so`. Size history: 2,218,920 B in 1.3.5; **2,218,904 B in 1.3.6** (-16 B, rebuilt — different MD5, same Vulkan ICD api version); **~2,219,144 B in 1.3.7** (+240 B over 1.3.6 — behavioral patch in `DirectRendering::Present()` that drops frames on pipe failure rather than silently falling back to `xcb_present_pixmap`). ARM64 ELF, NDK r28-beta1. Sizes/strings below were captured from the 1.3.5 build but the surface is unchanged for 1.3.6/1.3.7. Current served firmware is **1.4.1** (`5dc29a9`, upstream-sourced); its internal libGameScopeVK.so delta was not separately measured.

**Internal name:** `GameScopeVK`. Built from a Mac dev tree (`/Users/me/Documents/GameScopeVK/gamescope/...`). Source files referenced in DWARF strings:
- `direct_rendering_client.cpp`
- `gamescope.cpp`
- `gamescope_shader.cpp`
- `gamescope_swapchain.cpp`
- `vulkan_dispatch.cpp`

**Architecture:** Vulkan **ICD** (Installable Client Driver). It chains in front of the real Vulkan driver via the loader's ICD chain. Exports the standard ICD entry points: `vk_icdGetInstanceProcAddr`, `vk_icdGetPhysicalDeviceProcAddr`, `vk_icdNegotiateLoaderICDInterfaceVersion`.

**Registered via** `<wineprefix>/usr/home/steamuser/.config/vulkan/icd.d/GameScopeVK_icd.json`:
```json
{
  "file_format_version": "1.0.0",
  "ICD": {
    "library_path": "/data/data/com.winemu/files/usr/lib/libGameScopeVK.so",
    "api_version": "1.3.216"
  }
}
```
Note: in 6.0.1 the path was hardcoded for `com.winemu`; the `feature/framegen-menu` patch (BannerHub 3.7.x, shipped 2026-05-09) rewrites it via `ctx.getPackageName()` so the ICD JSON works for any package name including renamed APKs. 6.0.4 client-side behavior is identical (the ICD path resolution is on the *client* side, not the imagefs side).

**Linked dependencies** (ELF NEEDED): only standard system libs — `libandroid`, `liblog`, `libEGL`, `libGLESv2`, `libGLESv3`, `libX11`, `libX11-xcb`, `libxcb`, `libxcb-dri3`, `libxcb-present`, `libvulkan`, `libm`, `libdl`, `libc`. **NO ML inference framework** (no NCNN, no ONNX Runtime, no TensorFlow Lite). The "AI" is implemented as Vulkan compute shaders embedded inside `libGameScopeVK.so`, using `VK_NV_optical_flow` for hardware-accelerated motion vector estimation.

**Embedded class names:** `gamescope::FPSCounter`, `gamescope::FPSCallback`, `gamescope::FPSCounterWithCallback`, `gamescope::Swapchain`.

**Diagnostic strings present** (sample): `"Frame interpolation backend created"`, `"Frame interpolation backend creation failed"`, `"Frame interpolation execution failed: {}"`, `"Frame interpolation warmup failed: {}"`, `"begin warmup command buffer failed"`, `"warmup ingest failed"`, `"warmup submit failed"`, `"invalid warmup input"`, `"GameScope control enabled"`, `"Failed to open control file: {}"`, `"GameScopeVK: [BYPASS_XSERVER] Status changed: {}"`.

**Environment variables consumed** (loader-level config):
- `GAMESCOPE_CONTROL_PATH` — path to the 10-byte `gamescope.control` mmap (overrides default location)
- `GAMESCOPE_DRIVER_PATH` — real Vulkan ICD to chain to (the underlying GPU driver)
- `GAMESCOPE_DEVICE_MEMORY_LIMIT` — memory-cap override
- `GAMESCOPE_DUMP_FAILURES` — diagnostic dump toggle
- `GAMESCOPE_SURFACE_USING_BGRA` — pixel-format hint

#### 26.8.6 The `VK_NV_optical_flow` ↔ Adreno bridge

`VK_NV_optical_flow` is normally an NVIDIA-only Vulkan extension (Ada Lovelace / RTX 40-series, with dedicated optical-flow accelerators). XiaoJi's Mesa Turnip fork (`libvulkan_freedreno.so`, also in the imagefs) implements the SAME extension on Qualcomm Adreno GPUs. Confirmed by symbol presence:

```
libvulkan_freedreno.so:
  tu_CreateOpticalFlowSessionNV<chip 6>
  tu_DestroyOpticalFlowSessionNV<chip 6>
  tu_BindOpticalFlowSessionImageNV<chip 6>
```

(`chip 6` = the Turnip codename for the targeted Adreno generation — likely Adreno 740/750 family. The implementation likely runs as compute shaders on the GPU's existing CV / image-processing blocks rather than a dedicated optical-flow accelerator. See `VK_NV_OPTICAL_FLOW_ON_ADRENO.md` and memory `project_vk_nv_optical_flow_adreno.md` for the deep-dive — chip 6/7/8 dispatch table + delta/gamma pipelines + ICD chain.)

This is **the technical magic enabling AI frame-gen on phone GPUs**. Without it, libGameScopeVK would fail at `vkCreateOpticalFlowSessionNV` and frame-gen would silently no-op (per release-note phrasing "supported across all games", apparently meaning the Java side has no per-game allowlist, but the runtime gate is "does the GPU's Vulkan driver expose `VK_NV_optical_flow`?"). Devices on stock vendor Vulkan drivers won't get AI frame-gen even if they install GameHub 6.0.1 or 6.0.4; only devices running through XiaoJi's bundled Turnip fork will.

#### 26.8.7 UI surface

User-facing strings (`res/values-en/strings.xml`) — unchanged set in 6.0.4:

| Key | English |
|---|---|
| `ai_frame_interpolation_plus` | "AI Frame Generation" (top-level feature title) |
| `ai_frame_interpolation_header` | "Frame Generation" (section header) |
| `winemu_sidebar_ai_frame_interpolation_enable` | "Enable frame generation" (toggle label) |
| `winemu_sidebar_ai_frame_interpolation_preset` | "Preset" (sub-section) |
| `ai_frame_interpolation_mode_disabled` | "Disabled" |
| `ai_frame_interpolation_mode_fast` | "Power Saving" |
| `ai_frame_interpolation_mode_smooth` | "Smooth mode" |
| `ai_frame_interpolation_mode_balanced` | "Balanced mode" |
| `ai_frame_interpolation_mode_enhanced` | "Enhanced mode" |
| `ai_frame_interpolation_mode_clear` | "Clear mode" |
| `ai_frame_interpolation_mode_extreme` | "Extreme mode" |
| `ai_frame_interpolation_label_fast` | "Eco" (slider pill) |
| `ai_frame_interpolation_label_smooth` | "Flow" |
| `ai_frame_interpolation_label_balanced` | "Bal" |
| `ai_frame_interpolation_label_enhanced` | "Boost" |
| `ai_frame_interpolation_label_clear` | "Clear" |
| `ai_frame_interpolation_label_extreme` | "Max" |

Per-mode descriptions (in `winemu` Compose-resources strings under `winemu_sidebar_ai_frame_interpolation_*_desc`):
- Disabled: "Disabled. Frame rate and power usage will not be changed."
- Fast: "Lowest overhead, suitable for lower-end devices or battery-sensitive play."
- Smooth: "Low overhead smoothness boost for most lightweight games."
- Balanced: "Recommended. Balances smoothness, power usage, and stability."
- Enhanced: "Stronger motion smoothing for users who prefer extra fluidity."
- Clear: "Prioritizes a steadier, cleaner image with fewer motion artifacts."
- Extreme: "Highest quality preset with the highest power and performance cost."

The sidebar slider track shows 6 enabled positions (Eco · Flow · Bal · Boost · Clear · Max). "Disabled" is a separate off-state above the slider, not a slider position.

Translations present in: ar, en, es, ja-rJP, pt-rBR, ru-rRU, zh-rCN, plus dozens more locale folders (full multi-language support — XiaoJi treats this as a flagship feature).

#### 26.8.8 Action / state classes (Java/Kotlin)

(Letters below are from the 6.0.1 R8 map. 6.0.4 letters shifted with the new map-id `6a5cde6…`; re-derive each via the structural-anchor recipe listed in 26.8.2 + the const-string `"AiFrameInterpolation"` and the unique 10-byte mmap shape.)

| Class (6.0.1) | Role |
|---|---|
| `defpackage.r1o` | `UpdateAiFrameInterpolationMode(mode)` — UI/store action (user picked a mode) |
| `defpackage.e3o` | `ApplyAiFrameInterpolationMode(mode)` — service action (commit to mmap) |
| `defpackage.sz4.a(AiFrameInterpolationMode)` | The actual mmap writer (3-step: model byte + flowScale float + multiplier byte + force) |
| `defpackage.ie9` | `ysj` adapter — receives `e4o` actions, fans out to setting-specific handlers |
| `defpackage.wzn` | `xc1` ViewModel — holds Wine activity state including current AI mode |
| `defpackage.g1j` | Slider position picker (maps slider float → AiFrameInterpolationMode by index) |
| `defpackage.m5o` | Static `int[]` ordinal-index dispatch tables for all 7 enum values |
| `defpackage.y1m` | Polymorphic invoke lambda — handles AiFrameInterpolationMode default fallback to `Disabled` |

#### 26.8.9 Per-GPU capability gating

**No client-side gate exists in the APK** — searched `com.xiaoji.egggame.*` for any GPU-vendor / device-model / Vulkan-extension check on `AiFrameInterpolation` and found nothing in either 6.0.1 or 6.0.4. The release-note phrasing "AI frame generation now supported across all games" means **no per-game allowlist** in the client; it does NOT mean every device can use it.

The runtime gate is **silent** in `libGameScopeVK.so`: if `VK_NV_optical_flow` isn't available on the device's loaded Vulkan ICD chain, the swapchain interpolation backend creation fails with `"Frame interpolation backend creation failed"` (logged via `liblog`) and the swapchain falls back to passthrough — frame-gen no-ops without any user-visible error. Users will simply see no fps doubling.

**To verify on a given device:** check whether the active Vulkan driver advertises `VK_NV_optical_flow`. With XiaoJi's bundled Turnip Mesa fork (`libvulkan_freedreno.so`, Adreno chip-6 family) → yes. With the device's stock vendor Qualcomm/ARM/PowerVR Vulkan driver → almost certainly no.

> **Field-confirmed working** (memory `project_bannerhub_framegen_activation.md`): 2026-05-08 in-game framegen-menu dialog activates AI frame-gen end-to-end on a real device; 42 → 75 → 80 FPS (~1.8–1.9× on 2× multiplier) verified via overlay screenshots. The 6.0.1 → 6.0.4 transition has not regressed this behavior.

---

### 26.9 — Steam SDK Refresh

`com.xiaoji.egggame.common.steam_sdk.bridge.AndroidSteamBridgeTransport` gained 11 new SuspendLambda inner classes for cancellable / async operation handling in 6.0.1. Native lib `libsteamkit_core.so` size history:

| Version | libsteamkit_core.so size | Δ from previous |
|---|---|---|
| 6.0.0 | 10,000,064 B | — |
| 6.0.1 | 10,522,712 B | **+510 KB** (Steam SDK refresh, 11 new lambdas) |
| 6.0.4 | 11,403,128 B | **+860 KB** further growth — Steam SDK either refreshed again or accumulated additional bridge surface across 6.0.2/6.0.3/6.0.4 |

New DTOs (6.0.1):
- `AppcacheRootDto` + `AppcacheRootRequestDto` — Steam appcache management
- `DownloadCancelledEventDto` — explicit cancellation event payload

Removed (6.0.1): `SetPreferDeviceCodeRequest$$serializer` (cleanup).

The 11 new lambda classes (added in 6.0.1) implement: `cancelOperation$1`, `close$1`, `executeCancellable$2$1`, `pollOperation$1`, `sendNetworkStatus$2`, `syncNetworkStatus$1`, `syncNetworkStatus$1$1`, `syncNetworkStatus$1$2`, `syncNetworkStatus$1$3`, plus a `submitOperation$1` and the `b` package-companion. Together these enable: graceful cancellation of in-flight Steam downloads, periodic network-status sync to upstream Steam, and clean resource teardown on activity destroy. Matches the 6.0.1 release-note bullets "Improved Steam login and game download stability" + "Faster Steam game launch speeds".

The further +860 KB in 6.0.4 was not separately documented in upstream release notes; in static analysis the bridge interfaces look structurally similar to 6.0.1 (still the same `AndroidSteamBridgeTransport` + suspend-lambda pattern). Treat as silent Steam SDK uptake — DTO + bridge changes are kotlinx-serializable / R8-kept, so the public surface for the BannerHub-API proxy is unchanged.

Also (6.0.1, retained in 6.0.4): SQL schema for `download_tasks` table now exposes new query shapes filtering by `downloader_type` + `source_id` (cancellable-download support).

### 26.10 — vjoy Multi-Layer Architecture

The vjoy/Scheme system gained per-layer composition support in 6.0.1 — matches the release-note bullet "Virtual button layouts can now be switched dynamically via keypress". **All classes still present in 6.0.4.**

Classes under `com.xiaoji.egggame.common.ui.vjoy.model.*`:
- `VJoyLayer` — a single layer (collection of controls)
- `VJoyLayer$Companion` + `VJoyLayer$$serializer`
- `VJoyLayerDefaults` — default layer configuration
- `VJoyLayoutJson` — top-level layout container that holds a list of layers
- `VJoyLayoutCompatKt` — backwards-compat shim for legacy single-layer layouts (auto-wraps them in a single `VJoyLayer`)
- `VJoyLegacyMappingCompatKt` — backwards-compat for older `mapping` field shapes
- `ControlAction` (sealed) + `Companion`
- `ControlAction$SwitchLayer` + `Companion` + `$$serializer` — concrete action that switches the active layer when bound to a button
- `VJoyTextAlign` + `Companion` — text alignment values for control labels
- `AxisRole` — analog stick axis role (existed conceptually, now formalized)

Interaction model: a `VJoyControl`'s `mapping` field can now (in addition to `keyboard` / `directional` classes) be a `ControlAction` like `SwitchLayer(targetLayerId)`. Pressing such a button switches the active layer in the overlay, exposing a different set of buttons. Multiple layers can be defined per layout (e.g., "movement layer" + "combat layer" + "menu layer").

Schema-side: the existing `.gtheme` ZIP format's `layout.json` gained a `layers` array (nullable for backwards compat — single-layer layouts get wrapped at load time via `VJoyLayoutCompatKt`).

### 26.11 — Gyroscope + New Touchscreen Input Methods

New `WineInGameSettingType` enum entries (registered in 26.8.2's table) — still present in 6.0.4:
- `GyroAim` (key=`"GyroAim"`, scope=Game, codec=Json(`GyroAim.class`)) — matches "Gyroscope support for camera control" release-note bullet
- `ScreenTouchInput` (key=`"ScreenTouchInput"`, scope=Game, codec=Json(`ScreenTouchInput.class`)) — matches "Multiple new touchscreen input methods"

Data classes (verified present in 6.0.4 at `smali_classes4/com/xiaoji/egggame/common/winemu/bean/`):
- `GyroAim` (+ Companion)
- `GyroAimTargetMode` — enum, **5 values**: `Mouse` (gyro drives mouse look), `GamepadSlot0`, `GamepadSlot1`, `GamepadSlot2`, `GamepadSlot3` (gyro drives a virtual gamepad slot — supports up to 4 simultaneous virtual gamepads).
- `ScreenTouchInput`
- `ScreenTouchInputMode` — enum, **4 values**: `Disabled`, `Trackpad` (raw screen-touch routes through a virtual trackpad cursor), `Touchscreen` (game-native touchscreen passthrough), `RightStick` (screen touch becomes a virtual right-analog-stick — for camera control in shooters). **6.0.4 update**: a `winemu_sidebar_touch_input_right_stick_sensitivity` string was added (see § 26.22) — a sensitivity slider for the `RightStick` mode (not present in 6.0.1).

Also new MMKV key `gyro_aim` (legacy migration target).

The vjoy-side enum additions (used by VJoyControl `mapping.class:"directional"` configs):
- `com.xiaoji.egggame.common.ui.vjoy.model.AxisRole` — enum, **4 values**: `LeftStick`, `RightStick`, `MousePointer`, `Unknown`. Tags an analog stick's role for virtual-gamepad-stick vs mouse-cursor binding.
- `com.xiaoji.egggame.common.ui.vjoy.model.VJoyTextAlign` — enum, **4 values**: `Left`, `Center`, `Right`, `Justify`. Per-control label-text alignment.

### 26.12 — Box64 Per-Game Tunable UI (~80 new strings)

A major new "Box64 advanced" UI surfaces ~30 individual tunable parameters per game with title/description string pairs and value-label sets. New string-resource keys (`tp_*` prefix, ~107 total `tp_*` keys verified in `res/values/strings.xml` of the 6.0.4 baseline — counted live; the original "~80" figure for 6.0.1 was rounded). **Set still present in 6.0.4, no removals detected.**

**Title/description pairs** (each tunable has `tp_<Name>Title` + `tp_<Name>Desc`):
- `AlignedAtomics`, `BigBlock`, `Box64AVX` (separate from generic `AVX`?), `CallRet`, `CpuType`, `DF`, `DIV0`, `Dirty`, `Dynarec`, `FastNan`, `FastRound`, `HalfBarrierTSOEnabled`, `HideHypervisorBit`, `IgnoreINT3`, `MaxInst`, `MemcpySetTSOEnabled`, `MonoHacks`, `Multiblock`, `NativeFlag`, `Pause`, `RDTSC1GHZ`, `SMCChecks`, `SmallTSCScale`, `TSOEnabled`, `VectorTSOEnabled`, `VolatileMetadata`, `VolatileMetadataBox64`, `Wait`, `WeakBarrier`, `X87Double`, `X87ReducedPrecision`

**Value-label sets** (per-tunable enumerations, e.g. `tp_avx_0`/`tp_avx_1`/`tp_avx_2` for the 3-value AVX selector):
- `tp_aligned_atomics_*` (2 vals), `tp_avx_*` (3), `tp_big_block_*` (4), `tp_call_ret_*` (2), `tp_cpu_type_*` (2), `tp_dirty_*` (3), `tp_fast_nan_*` (2), `tp_fast_round_*` (2), `tp_pause_*` (4), `tp_safe_flags_*` (3), `tp_smc_checks_*` (3 — full/mtrack/none), `tp_strong_mem_*` (4), `tp_wait_*` (2), `tp_weak_barrier_*` (3), `tp_x87_double_*` (2)

These map 1:1 to the Box64 environment-variable tuning options documented at https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md — XiaoJi has surfaced them as per-game UI controls. Power users can now tune Box64 dynarec / TSO / x87 / SMC behavior per game without editing config files.

### 26.13 — Wine HUD Overlay Strings (MangoHud Integration)

7 new string-resource keys for in-game HUD labels (6.0.1, still present in 6.0.4): `winemu_hud_label_charging`, `winemu_hud_label_cpu`, `winemu_hud_label_fps`, `winemu_hud_label_gpu`, `winemu_hud_label_power`, `winemu_hud_label_ram`, `winemu_hud_label_temperature`. Wires up the existing `MangoHud.aarch64.json` implicit Vulkan layer (already in the imagefs at `usr/share/vulkan/implicit_layer.d/`) to a localizable label set. Also `defpackage.com.xiaoji.egggame.common.winemu.hud.HUDConfig` (referenced from `defpackage.ie9.java` imports in 6.0.1).

**6.0.4 addition** (see § 26.22): a new `winemu_sidebar_hud_engine` string ("Engine name") — implies an additional HUD-overlay row labeled "Engine name" was added in the 6.0.1 → 6.0.4 window. No other HUD-related strings changed.

### 26.14 — PC Game Data Backup / Restore (NEW Feature)

New string-resource keys (6.0.1, still present in 6.0.4): `winemu_pc_game_data_backup_{loading,fail,finish}`, `winemu_pc_game_data_recover_{loading,fail,finish}`, `winemu_pc_game_data_backup_recover_tips`, `winemu_pc_game_data_backup_recover_permission_tips`. Per-game Wine `drive_c` snapshot/restore — useful for save-game preservation across container reinstalls. **No 6.0.4 changes detected.**

### 26.15 — Wine Performance Modes (Power Profiles)

New string keys (6.0.1, still present in 6.0.4): `wine_performance_mode`, `wine_performance_mode_balanced`, `wine_performance_mode_boost`, `wine_performance_mode_powersaving`. Three switchable power profiles for Wine. Implementation likely throttles Box64 dynarec / GPU clock / CPU governor differently per profile. Note this is **separate from `RedMagicPerformanceMode`** (which is device-vendor-specific to Nubia Red Magic phones and pre-existed in 6.0.0). **No 6.0.4 changes detected.**

### 26.16 — Setup / Install Flow Rewrite

~30 new string keys (6.0.1) covering the first-run setup + per-game imagefs/component installation experience, with a focus on better progress UI:
- `winemu_imagefs_installation`, `winemu_imagefs_installation_complete`
- `winemu_setup_check_{common,dep,steam,virtual}_component_*`
- `winemu_setup_download_{base,dep_component,dep_child_component}_complete_tips`
- `winemu_setup_downloading_{info,remaining,remaining_default,speed,tips}`
- `winemu_setup_install_{component,dep,depcomponent_*,env_*}`
- `winemu_setup_applying_game_settings`, `winemu_setup_game_settings_applied`
- `winemu_setup_server_null_tips`, `winemu_setup_check_virtual_container_install_fail`

**No 6.0.4 changes detected.**

### 26.17 — Container State Check + Game-File Validator

Pre-launch validation strings (6.0.1): `winemu_check_virtual_container_fail_no_container`, `winemu_check_virtual_container_fail_try_again`, `winemu_container_state_check`, `winemu_choose_game_file_parse_failure`, `validator_error_exe_file_not_found`, `pc_s_local_game_exe_path_error`, `pc_s_miss_dxvk_tips`, `pc_s_miss_translator_tips`, `pc_s_miss_vkd3d_tips`, `pc_cc_broken`, `disable_graphics_enhancement_plugin`, `disable_plugin_warning`, `force_enable`. Better error UX when a game's required components aren't installed or the .exe path is wrong. **No 6.0.4 changes detected.**

### 26.18 — DTO Package Move (`core.domain.base.*` → `core.network.model.baseinfo.dto.*`)

Three classes moved package without changing shape in 6.0.1 (still in their new location in 6.0.4):
- `core.domain.base.BaseInfoDto` → `core.network.model.baseinfo.dto.BaseInfoDto`
- `core.domain.base.SteamUrlReplaceItem` → `core.network.model.baseinfo.dto.SteamUrlReplaceItemDto` (note: also renamed, gained `Dto` suffix)
- (third old removal: `SetPreferDeviceCodeRequest` — fully removed, no replacement)

`BaseInfoDto` gained 3 new fields per the new MMKV keys (Pass 4): `epic_games_hidden`, `retro_games_hidden`, `steam_games_hidden` (Boolean flags). Lets the catalog hide entire game-source families per-user. **No 6.0.4 changes detected.**

### 26.19 — Resource Asset Additions

| File | Size | Purpose |
|---|---|---|
| `assets/composeResources/com.xiaoji.egggame.features.home/drawable/features_home_library_game_default.png` | 873 KB | New default cover image for library games (replaces older smaller default; ~90× size jump = much higher resolution) |
| `assets/composeResources/com.xiaoji.egggame.features.home/drawable/lib_second_ic_guide_finger.png` | 1.7 KB | Tap-here guide finger icon for the landscape library import flow |
| `assets/composeResources/com.xiaoji.egggame.features.splash/files/splash/launcher_en.gif` | 154 KB | English animated splash GIF |
| `assets/composeResources/com.xiaoji.egggame.features.splash/files/splash/launcher_zh.gif` | 172 KB | Chinese animated splash GIF |
| `res/{7_,No,jH,wc}.xml` | 752 B each | 4 new tiny compiled-resource XMLs (likely overlay/theme deltas) |

Removed (6.0.1): 10 small `res/*.webp` files (3,242–14,596 B each) — obsolete static assets superseded by the new defaults.

Also (6.0.1): 4 new launcher-icon vector path-include files in `drawable*/` (`$ic_launcher_foreground__1.xml` through `$ic_launcher_foreground__4.xml`) — AAPT split a refined launcher-icon vector into additional path-layer files. Cosmetic refinement, no behavior change.

**6.0.4 status:** asset bundle was not byte-diffed against 6.0.1 in this pass; spot-checking confirms the splash GIFs, the high-res default library cover, and the launcher-icon path-include files all still exist. No asset removals visible.

### 26.20 — Native Library Refresh

`lib/arm64-v8a/` count unchanged at 27 across all bumps (same roster — no `.so` added or removed). Native lib size history (6.0.2 column added 2026-05-13 from `GameHub_6.0.2.apk` versionCode 112):

| Lib | 6.0.0 | 6.0.1 | 6.0.2 | 6.0.4 | Δ (6.0.0 → 6.0.4) | Notes |
|---|---|---|---|---|---|---|
| `libsteamkit_core.so` | 10,000,064 B | 10,522,712 B | 10,192,880 B | 11,403,128 B | **+1.40 MB** | Steam SDK ongoing refresh — see § 26.9 |
| `libepickit_core.so` | 4,767,696 B | 4,717,576 B | 4,717,576 B | 4,720,048 B | -47 KB net | Step-by-step: -50 KB at 6.0.1, flat through 6.0.2, +2.4 KB at 6.0.4 (minor restore) |
| `libxserver.so` | — | — | 3,913,952 B | 3,938,672 B | n/a (rewritten) | **GLES2 in 6.0.2 → Vulkan in 6.0.4.** +24 KB but ~entirely different code surface — see § 26.23. md5 `e8eb894825da66cca0fc59b242ac0ad5` → `b63ba0cbdfecc81444ff28ffadb1e963` |
| `libwinemu.so` | — | — | 683,736 B | 658,320 B | **−25 KB** | `DirectRendering` ASurfaceTransaction plane compositor removed (absorbed into the Vulkan path) — see § 26.23. md5 `…` → `337f873a5596e777b8d1f0ca1083654d` |
| `libgpuinfo.so` | — | — | 341,944 B | 341,944 B | 0 (md5 identical) | Untouched across 6.0.2 → 6.0.4 |

`libvfs.so` shifted -32 B between 6.0.2 and 6.0.4 (cosmetic). All other 23 `.so` files are byte-identical across the 6.0.2 → 6.0.4 window.

**No new `.so` files for AI frame generation in the APK.** The frame-gen library `libGameScopeVK.so` lives inside the imagefs/firmware (currently **1.4.1** via BannerHub Worker as of `5dc29a9` 2026-05-15) — see 26.6 + 26.8.5. No new arm64-v8a libs added in the 6.0.1 → 6.0.4 window.

### 26.21 — Manifest Correction

One-line fix in 6.0.1: `android.hardware.usb.host` was incorrectly declared as `<uses-permission>` in 6.0.0; corrected to `<uses-feature>` in 6.0.1. **Verified still corrected in 6.0.4** (`<uses-feature android:name="android.hardware.usb.host" android:required="false"/>`). No other manifest deltas — same activities, services, providers, receivers, permissions, intent-filters, meta-data values, authorities, resource refs across the 6.0.1 → 6.0.4 window.

### 26.22 — Additional sidebar features

9 new string keys were added in 6.0.1 (ZH-only at first; EN translations have caught up across 6.0.1 → 6.0.4). Underlying features (gyro calibration state machine, force-exit game, trackpad sensitivity slider, virtual gamepad toggle, mouse speed description) are all still present in 6.0.4 — see § 26.11 for the data classes.

**6.0.4 NEW (only two new strings in the entire 6.0.1 → 6.0.4 window):**

| Key | English (in `res/values/strings.xml`) | Implication |
|---|---|---|
| `winemu_sidebar_hud_engine` | "Engine name" | New HUD overlay row that displays the game's engine name (Unreal / Unity / Source / …). Extends the MangoHud-style overlay introduced in § 26.13 — XiaoJi has either added engine-detection (read game.exe imports or look up a curated mapping by appid) or wired it to game-metadata coming back from BannerHub-API's game-detail responses. |
| `winemu_sidebar_touch_input_right_stick_sensitivity` | "Right stick sensitivity" | New sensitivity slider for the `ScreenTouchInputMode.RightStick` mode introduced in § 26.11. Lets users tune how aggressively touchscreen swipes translate to virtual-right-stick movement (was previously fixed gain). |

Pre-existing (6.0.1) keys, still present in 6.0.4:

- **Gyro calibration state machine** — 4 outcomes for the gyro setup flow:
  - `winemu_sidebar_gyro_aim_calibration_started`
  - `winemu_sidebar_gyro_aim_calibration_success`
  - `winemu_sidebar_gyro_aim_calibration_failed`
  - `winemu_sidebar_gyro_aim_calibration_unavailable`
  Implies a per-device calibration step (likely sample the resting gyroscope offset and store as a per-device baseline) with success/failure states. The "unavailable" state covers devices without a usable gyroscope sensor.
- **Force-exit game** — `winemu_exit_game_force`, `winemu_exit_game_progress` — adds a "force kill the running Wine container" action with a progress UI (probably for runaway games that don't respond to normal exit).
- **Trackpad sensitivity slider** — `winemu_sidebar_touch_input_trackpad_sensitivity` (separate slider from `key_trackpad_pointer_speed` MMKV key in §26 main string list — sensitivity is the multiplier, pointer speed is the absolute speed).
- **Virtual gamepad toggle** — `winemu_sidebar_virtual_gamepad_enable` — in-sidebar on/off for the virtual on-screen gamepad overlay (alongside the existing `WineInGameSettingType.VirtualGamepadVibration`).
- **Mouse speed description** — `winemu_sidebar_mouse_speed_desc` (new help-text body for an existing slider).

### 26.23 — Renderer Rewrite (GLES2 → Vulkan) — byte-level 6.0.2 vs 6.0.4 diff (added 2026-05-13)

The renderer-stack changes summarised in § 26.20 are detailed below as a literal string-set diff of the two binaries. Both APKs decompiled at `/data/data/com.termux/files/home/GameHub_6.0.2.apk` and `/data/data/com.termux/files/home/GameHub_6.0.4.apk`; libs lifted from `lib/arm64-v8a/`; diff via `strings -a … | sort -u` set-difference.

#### 26.23.1 Headline

| Aspect | 6.0.2 | 6.0.4 |
|---|---|---|
| `libxserver.so` graphics API | **OpenGL ES 2.0 + EGL** | **Vulkan 1.x** (dlopen `libvulkan.so`) |
| Shader format | GLSL ES source strings baked into the lib | SPIR-V (signature `GLSL.std.450`) |
| Buffer ingestion | EGLImage / `glEGLImageTargetTexture2DOES` | `VK_ANDROID_external_memory_android_hardware_buffer` (AHB) |
| Cursor compositor | Separate Android SurfaceControl plane (in `libwinemu.so`) | Inside the Vulkan path (`g.cursor.ds`, `ensure_cursor_image`) |
| Backends registered | none (single renderer) | **four**: `winemu-xserver`, `winemu-flip`, `winemu-vk`, `lorie-vk` |
| Source-path leak | none | 16 `/Users/me/Documents/WinEmuKernel/lib/src/main/cpp/x11/xserver/...` paths |
| JNI flip toggle | `DirectRendering.setRenderingEnabled` (6.0.1 name) / SurfaceControl-plane based | `XServer.setFlipEnabled(Z)V` + new static native callback `onFlipStateChanged(Z)V` |

#### 26.23.2 libxserver.so — strings present in 6.0.2 and absent in 6.0.4 (REMOVED)

GLES/EGL surface — 16 entry points: `eglBindAPI`, `eglChooseConfig`, `eglCreateContext`, `eglCreateImageKHR`, `eglCreatePbufferSurface`, `eglCreateWindowSurface`, `eglDestroyContext`, `eglDestroyImageKHR`, `eglDestroySurface`, `eglGetDisplay`, `eglGetError`, `eglGetNativeClientBufferANDROID`, `eglInitialize`, `eglMakeCurrent`, `eglSwapBuffers`, `eglSwapInterval`.

GLES2 draw path — 30+ entry points: `glActiveTexture`, `glAttachShader`, `glBindTexture`, `glBlendFunc`, `glClear`, `glClearColor`, `glCompileShader`, `glCreateProgram`, `glCreateShader`, `glDeleteProgram`, `glDeleteShader`, `glDisable`, `glDisableVertexAttribArray`, `glDrawArrays`, `glEGLImageTargetTexture2DOES`, `glEnable`, `glEnableVertexAttribArray`, `glGenTextures`, `glGetAttribLocation`, `glGetError`, `glGetProgramInfoLog`, `glGetProgramiv`, `glGetShaderInfoLog`, `glGetShaderiv`, `glLinkProgram`, `glReadPixels`, `glShaderSource`, `glTexImage2D`, `glTexParameteri`, `glUseProgram`, `glVertexAttribPointer`, `glViewport`.

Inlined GLSL ES shader source (baked as plain text in the binary):

```glsl
// vertex
attribute vec2 texCoords;
varying vec2 outTexCoords;
attribute vec4 position;
gl_Position = position;
outTexCoords = texCoords;

// fragment
precision mediump float;
gl_FragColor = texture2D(texture, outTexCoords);
gl_FragColor = texture2D(texture, outTexCoords).bgra;  // BGR-swizzled variant
```

Dynamic-load targets: `libEGL.so`, `libGLESv2.so`.

#### 26.23.3 libxserver.so — strings absent in 6.0.2 and present in 6.0.4 (ADDED)

Vulkan instance/device entry points (direct symbols): `vkAcquireNextImageKHR`, `vkAllocateCommandBuffers`, `vkAllocateDescriptorSets`, `vkAllocateMemory`, `vkBeginCommandBuffer`, `vkBindBufferMemory`, `vkBindImageMemory`, `vkBindImageMemory2`, `vkCmdBeginRenderPass`, `vkCmdBindDescriptorSets`, `vkCmdBindPipeline`, `vkCmdCopyBufferToImage`, `vkCmdDraw`, `vkCmdEndRenderPass`, `vkCmdPipelineBarrier`, `vkCmdPushConstants`, `vkCmdSetScissor`, `vkCmdSetViewport`, `vkCreateAndroidSurfaceKHR`, `vkCreateFramebuffer`, `vkCreateImageView`, `vkCreateSwapchainKHR`, `vkGetSwapchainImagesKHR`, plus the `pvk*` dlsym-proxied counterparts (23 distinct `pvk*` symbols).

Extension declared: `VK_ANDROID_external_memory_android_hardware_buffer` (AHB ingestion).

New capability: `pvkCreateSamplerYcbcrConversion` — YUV passthrough for video surfaces (not in 6.0.2).

Shader: `GLSL.std.450` (SPIR-V module signature) — no inlined GLSL.

Four registered backend tags (none of these strings exist in 6.0.2):
- `winemu-xserver`
- `winemu-flip`
- `winemu-vk`
- `lorie-vk` (Lorie / Termux-X11-derived Vulkan backend)

Builder functions (visible as function-name strings): `build_ahb_entry`, `build_pipeline`, `create_command_pool`, `create_descriptor_pool`, `create_device`, `create_image_2d`, `create_instance`, `create_plain_resources`, `create_render_pass`, `create_staging`, `create_swapchain`, `ensure_cursor_image`, `make_shader`, `renderer_init`.

Vulkan-error log strings: `dlopen libvulkan.so failed: %s`, `no DEVICE_LOCAL memtype`, `no HOST_VISIBLE memtype`, `no memtype for AHB`, `no graphics queue`, `no physical devices`, `no surface formats`, `queue family doesn't present to this surface`, `renderer_init failed`, `swapchain returned no images`, `vkAcquireNextImageKHR returned invalid image index %u (swap_count=%u)`, `failed to allocate swapchain image state for %u images`, `phys device: %s (api %u.%u.%u)`, `GetStaticMethodID(onFlipStateChanged) failed`.

JNI callback wiring (new): `onFlipStateChanged` (static native from C → Java), `setFlipEnabled` (Java → native via JNI).

Mac dev paths (the leak that identified the undisclosed internal repo — 16 hits, all under `/Users/me/Documents/WinEmuKernel/lib/src/main/cpp/x11/xserver/...`): `dix/devices.c`, `dix/enterleave.c`, `dix/events.c`, `dix/gestures.c`, `dix/getevents.c`, `dix/grabs.c`, `dix/inpututils.c`, `dix/ptrveloc.c`, `dix/touch.c`, `mi/mieq.c`, `os/io.c`, `os/log.c`, `render/glyph.c`, `Xext/sync.c`, `Xi/exevents.c`, `xkb/xkbInit.c`. See `gamehub_reports/GH604_RENDERER_ATTRIBUTION_INVESTIGATION.md` for full context.

#### 26.23.4 libwinemu.so — strings present in 6.0.2 and absent in 6.0.4 (REMOVED, accounts for the −25 KB shrink)

6.0.2 ran a separate Android SurfaceControl plane compositor for the cursor and main window. The entire plane-compositor surface is removed in 6.0.4 (cursor compositing is now inside the Vulkan path under `g.cursor.ds`):

- `ANativeWindow_fromSurface`, `ASurfaceControl_fromJava`
- `ASurfaceTransaction_apply`, `ASurfaceTransaction_create`, `ASurfaceTransaction_delete`, `ASurfaceTransaction_setBuffer`, `ASurfaceTransaction_setPosition`, `ASurfaceTransaction_setVisibility`
- Companion JNI: `Java_com_winemu_core_DirectRendering_00024Companion_nativeSetSurfaceFormat`
- Log strings: `Surface format set to: {} (0=RGBA8, 1=BGRA8)`, `Surface position set to: ({}, {})`, `Surface visibility set to: {}`, `ASurfaceTransaction_setPosition loaded successfully`, `ASurfaceTransaction_setPosition not available (API < 31)`, `Failed to create surface transaction for position`, `Failed to create surface transaction for visibility`, `Failed to get cursor native SurfaceControl`, `Failed to get native SurfaceControl`.

This matches the Java-side removal already documented at TL;DR line 14 (`DirectRendering` JNI gone) and the line-209 note (DR class deleted, `setFlipEnabled` is the new toggle).

#### 26.23.5 HDR tone-mapping SPIR-V shaders — present in BOTH, byte-identical

The four SPIR-V compute shaders ship at the same `assets/shaders/*.comp.spv` paths and the same exact byte sizes in both versions:

| Shader | Bytes (6.0.2) | Bytes (6.0.4) |
|---|---|---|
| `GammaOetf.comp.spv` | 7,692 | 7,692 |
| `HLG.comp.spv` | 10,480 | 10,480 |
| `SMPTE2084.comp.spv` | 9,904 | 9,904 |
| `SMPTE428.comp.spv` | 9,316 | 9,316 |

Notable: `libxserver.so` 6.0.2 contains zero Vulkan call sites, so these `.spv` shaders were dead-weight assets in 6.0.2. They went live in 6.0.4 once the Vulkan compositor existed to consume them — i.e. the asset pipeline was staged ahead of the code switchover.

#### 26.23.6 Set-counts (libxserver.so strings)

| Set | Count |
|---|---|
| Unique strings in 6.0.2 | 12,425 |
| Unique strings in 6.0.4 | 12,568 |
| Common (in both) | 12,140 |
| Only in 6.0.2 (removed) | 285 |
| Only in 6.0.4 (added) | 428 |

Roughly 2.3% of the 6.0.2 string set was discarded and 3.4% was new in 6.0.4 — consistent with a near-total reimplementation of the renderer that re-uses the surrounding X-server / input plumbing.

#### 26.23.7 Cross-references

- § 26.20 (lib size table — 6.0.2 column)
- § 26.8 (libGameScopeVK / firmware-side frame-gen ICD — the consumer of the new Vulkan path)
- TL;DR line 14 + line 209 (Java-side `DirectRendering` removal, already documented)
- `gamehub_reports/GH604_RENDERER_ATTRIBUTION_INVESTIGATION.md` (full attribution analysis of the four backends and the `WinEmuKernel` source leak)

#### 26.23.8 Independent binary re-verification + consolidated 6.0.2-vs-6.0.4 side-by-side (added 2026-05-17)

§ 26.23 re-verified directly against the exact libs (md5 match: 6.0.2 libxserver `e8eb894825da66cca0fc59b242ac0ad5`, 6.0.4 `b63ba0cbdfecc81444ff28ffadb1e963`; libwinemu 683,736 B `407f274d…` → 658,320 B `337f873a…`). All headline claims hold. **One precision correction:** 6.0.4 libxserver still contains **121 `gl*` strings — an identical set to 6.0.2** (`gl*ARB`, `glFogCoord*`, `glCompressedTexImage1D/3D`, `glBlitFramebuffer`, …). These are the X.org server's **GLX** desktop-GL dispatch (in-Wine GL-over-X protocol), present unchanged in BOTH versions — **NOT** the blit renderer. "GLES2 renderer removed" is correct (EGL context + ES2 draw path + libGLESv2/libEGL NEEDED all gone); "all GL removed from libxserver" would be **wrong**. Do not mistake the 121 GLX symbols for a surviving GLES2 renderer (matters for the shelved legacy-GLES2 toggle — see memory `project_bannerhub_revanced_legacy_gles2_renderer.md`).

**Renderer & native layer — 6.0.2 vs 6.0.4 (binary-verified, exact):**

| Aspect | 6.0.2 | 6.0.4 |
|---|---|---|
| Graphics API (libxserver) | OpenGL ES 2.0 + EGL | Vulkan 1.x (runtime dlopen libvulkan) |
| libxserver NEEDED | libGLESv2 + libEGL | both gone; +liblog |
| libxserver size/md5 | 3,913,952 B / e8eb89…ac0ad5 | 3,938,672 B / b63ba0…1e963 |
| Vulkan symbols | 0 | 104 `vk*` + 30 `pvk*` |
| Shaders | inlined GLSL ES source | SPIR-V (GLSL.std.450) |
| Frame ingestion | EGLImage (glEGLImageTargetTexture2DOES) | AHB zero-copy (VK_ANDROID_external_memory_android_hardware_buffer) |
| Video | none | vkCreateSamplerYcbcrConversion (YUV passthrough) |
| Cursor/overlay | separate Android SurfaceControl plane (libwinemu) | inside Vulkan path (ensure_cursor_image) |
| libwinemu size/md5 | 683,736 B / 407f27… | 658,320 B / 337f87… (−25,416 B) |
| Plane compositor (ASurfaceTransaction_*/ASurfaceControl_fromJava/ANativeWindow_fromSurface) | present | fully removed |
| Backends | 1 fixed | 4: winemu-xserver, winemu-flip, winemu-vk, lorie-vk |
| Direct/Native Rendering | com.winemu.core.DirectRendering + DirectRenderingActivationView, JNI setRenderingEnabled | subsystem deleted → native XServer.setFlipEnabled(Z) + onFlipStateChanged (single-listener) |
| That feature's UI | "Native/Direct Rendering" | renamed **"GPU Passthrough"** — single on/off bool `key_native_rendering_enabled` (default OFF), live sidebar toggle; NativeRenderingMode enum vestigial |
| AI frame-gen / GPU-spoof ICD / HDR tone-map | impossible | enabled (substrate libGameScopeVK / VK_NV_optical_flow) |
| X-server GLX symbols | 121 `gl*` | same 121 (unchanged; not the renderer) |

**Scope caveat:** the table above is byte-exact for 6.0.2→6.0.4. Broader app-level deltas (versionCode 111→114, minSdk 31→29, +2 BT perms, libsteamkit_core 10.0→10.9 MB, DEX 53,053→53,766, com.winemu.* reshuffle, AppNavKey 119→79, EnvLayerEntity 19→21, ComponentType 7→8, grown data classes, 2 new strings) are accurate only as **6.0.1 → 6.0.4** — 6.0.2/6.0.3 (versionCodes 112/113) were never separately decompiled, so no app-level item can be pinned specifically to "6.0.2 vs 6.0.4". See § 27 + the TL;DR. Mirrored in memory `reference_gamehub_602_vs_604.md`.

---
## 27. 6.0.1 → 6.0.4 Deltas — Component-Install Focus (added 2026-05-12)

Verified against `/data/data/com.termux/files/home/gamehub_604_decompile/` (apktool d of `gh604.apk`, versionCode 114 / versionName 6.0.4). **Headline:** component-install code paths are byte-for-byte identical to 6.0.1; the only changes are an R8 letter reshuffle and two new sidebar strings unrelated to install. The component pipeline does not appear to be a 6.0.2/6.0.3/6.0.4 development area.

### 27.1 APK Identity bump

| Field | 6.0.1 | 6.0.4 |
|---|---|---|
| versionName | 6.0.1 | 6.0.4 |
| versionCode | 111 | 114 |
| platformBuildVersionName | 16 | 16 |
| compileSdkVersion | 36 | 36 |
| r8-map-id (source comment) | `1c1886510d561c4653513192b80f6aeca10d1a5fcff2e7c8e7498396fe52a4ea` | `6a5cde6143fc8cf76f6f3a447d0fececd4794d83066e6ead7a9537e6527b057b` |

R8 map-id changed → expect class-letter shifts everywhere. The +3 versionCode jump (skipping 112/113) implies XiaoJi rolled out 6.0.2 and 6.0.3 internally before public release — feature progression between 6.0.1 and 6.0.4 is therefore probably the union of three internal cycles, not a single delta.

### 27.2 Component-install pipeline — R8 letter remap only

The classes documented in §§ 9.1.9 / 9.1.10 are unchanged in shape; only the letters moved. Re-derive on any future bump using the *structural anchors* in column 4 (not letter chasing).

| 6.0.1 letter | 6.0.4 letter | Role | Structural anchor |
|---|---|---|---|
| `Lltn;` | `Lj7o;` | Component cache singleton (`l9o`-equivalent — the master-map § 9.1.9 `l9o` letter was stale even at 6.0.1 ship) | `KoinComponent` impl with `static volatile p:LSelf` singleton, instance fields `i`/`j` `AtomicBoolean`, fields `k`/`l`/`m`/`n` four `ConcurrentHashMap`s, static `B(WinEmuRepo)String` + `G(WinEmuRepo,String)String` helpers, `<init>(Application, …, gd9-equivalent)V` constructor |
| `Lw43;` *(also was 6.0.1's `l13`-equivalent, exact letter unverified — see anchor)* | `Lw43;` (same letter in 6.0.4 coincidentally) | Coroutine state machine that calls `simulator/v2/getAllComponentList` and wraps each `EnvLayerEntity` as `WinEmuRepo` | Smali file with `const-string "simulator/v2/getAllComponentList"`, a `check-cast` to `BaseResult<EnvListData<EnvLayerEntity>>`, and an `isBase = (entity.type == 6)` branch at the same line numbers (~1631–1646) |
| `Lx43;` | `Lx43;` | Argument record for the wrap call — holds the `RepoCategory a:` field read at the new-instance site | Field `a:Lcom/xiaoji/egggame/common/winemu/bean/RepoCategory;` referenced at the `new-instance WinEmuRepo` constructor call inside the cache state machine |

**Implication for `bannerhub-revanced`:** existing component-injection patches that key on `Lltn;` / `Ll9o;` must be re-pointed to `Lj7o;` for 6.0.4. The write strategy in § 9.1.9 (`COMPONENT:<userComponentName>` MMKV key written through the host registry) is unchanged.

### 27.3 Doc corrections discovered while diffing 6.0.4

These are not 6.0.4 deltas — they are pre-existing inaccuracies in §§ 9.1.1 / 9.1.3 that the diff surfaced and that bannerhub-revanced patches should rely on.

- **`ComponentType` enum has 8 values, not 7.** §§ 9.1.1 / 25 omit `STEAMCLIENT(7)`. The full live enum (confirmed in both 6.0.1 and 6.0.4 smali, with integer literals from `<clinit>`):

  | type int | Enum constant | Category |
  |---|---|---|
  | 1 | `TRANSLATOR` | Translator (FEX / Box64 — disambiguated by `name` prefix) |
  | 2 | `GPU` | GPU driver |
  | 3 | `DXVK` | DXVK |
  | 4 | `VKD3D` | VKD3D |
  | 5 | `GENERAL` | Per-game settings packs + Steam agents |
  | 6 | `DEPENDENCY` | Runtime dependency (sets `isBase=true`) |
  | 7 | `STEAMCLIENT` | Steam client (was missing from the § 9.1.1 table) |
  | 8 | `STEAMCLIENT_RUNTIME` | Steam client runtime |

  So § 25's "Steam component type 7 → 8 for Steam clients" delta was incomplete: 6.0 didn't remove `7`, it *added* `8` alongside it. Both `STEAMCLIENT(7)` and `STEAMCLIENT_RUNTIME(8)` exist in `ComponentType.smali`, and `FileTypeValues` mirrors this with `STEAM_CLIENT=0x7` + `STEAM_CLIENT_RUNTIME=0x8` integer constants. Steam *agents* still ride on type `5` (`GENERAL`) per `getAllComponentList` examples.

- **`EnvLayerEntity` has 21 instance fields, not 19.** Verified field list (both 6.0.1 and 6.0.4): `base, blurb, displayName, downloadUrl, fileMd5, fileName, fileSize(J), fileType(I), framework, frameworkType, id(I), isSteam(I), logo, name, state, status(I), subData, type(Integer-boxed), upgradeMsg, version, versionCode(I)`. Statics (not counted): `$stable`, `BUILTIN_ID=-1`, `Companion`, `ITEM_REMOVE_PC_DATA_ID=-100`.

- **`FileTypeValues` is a static-constants holder, not an enum.** § 9.1.4 lists it under "State enums" — it's actually a singleton object class with `int` constants. Live values (6.0.4): `OTHER=0, GAME=1, IMAGE_FS=2, WINE=3, COMPONENT=4, GENERAL_COMPONENT=5, DEP_COMPONENTS=6, STEAM_CLIENT=7, STEAM_CLIENT_RUNTIME=8`. Note `OTHER=0` was missing from the § 9.1.4 listing.

- **`FrameworkType` is a static-strings holder, not an enum.** § 9.1.4 also lists it under "State enums". Live values are `String` constants: `TYPE_X64="X64"`, `TYPE_ARM64X="arm64X"`. No `enum` keyword; one `INSTANCE` singleton.

- **`EnvInstallState` / `WinEmuInstallState` are 3-value enums.** § 9.1.4 lists them generically as "Installation states for Wine environment" without values. Live enum constants in both: `INSTALLING`, `INSTALL_COMPLETE`, `INSTALL_FAIL`.

- **`RepoCategory` has 3 values.** § 9.1.4 lists it generically. Live: `COMPONENT`, `CONTAINER`, `IMAGE_FS`.

### 27.4 Install-flow strings — unchanged vs 6.0.1

A full diff of `res/values/strings.xml` (6.0.1: 762 keys → 6.0.4: 764 keys) shows the only two additions are sidebar features, **not install/setup**:

- `winemu_sidebar_hud_engine` — new HUD overlay line for renderer/engine identification
- `winemu_sidebar_touch_input_right_stick_sensitivity` — touch-input right-stick sensitivity slider (complements 6.0.1's `_trackpad_sensitivity`)

Every `winemu_setup_*`, `winemu_imagefs_*`, `winemu_check_virtual_*`, `pc_s_miss_*`, `validator_error_*` key documented in § 26.16 / § 26.17 is present unchanged in 6.0.4. The setup/install UX rewrite landed in 6.0.1 and has been frozen across 6.0.2/6.0.3/6.0.4 as far as user-visible strings are concerned.

### 27.5 Endpoint surface — unchanged

`simulator/v2/getAllComponentList` is still the single source for the master component catalog (`smali_classes4/w43.smali:404`). `getContainerDetail` is still referenced (`smali_classes4/n5o.smali`). No new component-flow endpoint URLs detected. The §§ 12 / 26.4 endpoint tables continue to apply verbatim for 6.0.4.

### 27.6 What this means for component install on 6.0.4

- **Behavior is identical to 6.0.1.** Same fetch → cache → state-machine → dropdown read path; same `EnvLayerEntity` schema; same 8-value `ComponentType`; same setup-flow UX strings.
- **Patches need letter re-pointing only.** `bannerhub-revanced`'s component-management patches anchored on `Lltn;` / `Ll13;` / `Ll9o;` need to retarget `Lj7o;` (+ verify `w43`/`x43` against the anchors above).
- **No new component categories** were added in 6.0.2 → 6.0.4. The enum has been 8 values since 6.0.1 (and the doc gap on `STEAMCLIENT(7)` was always there).
- **`isBase` is still hard-coded `type == 6`.** No semantic shift for STEAMCLIENT(7) or any other slot — only `DEPENDENCY` produces `isBase=true` on `WinEmuRepo` construction.


---

## 28. Winemu component/container picker — offline data path (forensic, added 2026-05-18)

Established by the bannerhub-revanced offline-component-picker investigation (model-free: sink-verified stack-trace probes + inotify/DB forensics + decompile, after ~8 refuted hypotheses). **Corrects/supersedes the picker-path guidance in § 9.1.9 / § 9.1.10 / § 27** — the real 6.0.4 picker feed is `gof`/`zxf`/`sz2`, NOT the `Lltn;`/`Ll13;`/`Ll9o;` chain; `mci.a`/`myo`/`j7o`/`so7`/`api_cache` were all empirically eliminated as the *picker* path.

### 28.1 Picker data path (6.0.4)

`sz2` (picker ViewModel coroutine) → `zxf.a`/`zxf.c` (repo wrapper) → `gof`:
- `gof.a(Lgof;,ComponentType,I,Lci3;,I)Ljava/lang/Object;` — static per-type **component** dispatcher: `if ((flags&4)!=0) page=200; gof.b(ComponentType.getType(), 1, page, cont)`.
- `gof.b(IIILci3;)Ljava/lang/Object;` — suspend impl, `simulator/v2/getComponentList`.
- `gof.c(Lci3;)Ljava/lang/Object;` — suspend impl, **containers** (Wine/Proton), `simulator/v2/getContainerList`. No type param (returns all). `.locals 11`.

### 28.2 Uniform winemu repo result type (broadly reusable)

Both `zxf.a` and `zxf.c` unwrap identically:
- `Lnm3;->a:Lnm3;` = the Kotlin **`COROUTINE_SUSPENDED`** sentinel (early-return → suspend).
- else `check-cast Lo55;` — sealed result base.
- `Ln55;` = **success**, `public final a:Ljava/lang/Object;` (= the payload `List<EnvLayerEntity>`), ctor `<init>(Object)`.
- `Lm55;` = **error**, same shape → caller yields `Lw85;->a` (Kotlin `EmptyList`).

`gof.b`-INTERNAL parse type is `Lc91;` = R8-renamed `com.xiaoji.egggame.core.network.model.BaseResult<EnvListData<EnvLayerEntity>>` (Companion `Lb91;`; fields `a:I` code, `b:String` msg, `c:String` time, `d:Object` data). **Boundary-vs-internal gotcha:** the picker boundary returns the *unwrapped* `n55(List<EnvLayerEntity>)`, NOT `Lc91;` — returning a `Lc91;` there throws `ClassCastException` at `check-cast Lo55;`.

### 28.3 `ComponentType` → int (`getType()`; `iget type:I`)

`TRANSLATOR=1, GPU=2, DXVK=3, VKD3D=4, GENERAL=5, DEPENDENCY=6, STEAMCLIENT=7, STEAMCLIENT_RUNTIME=8`. (Picker requests by these ints; Box64/FEX are both `TRANSLATOR`(1).)

### 28.4 Winemu persistence

- **`sp_winemu_unified_resources.xml`** SharedPreferences — keys `COMPONENT:<name>` / `CONTAINER:<name>` / `IMAGE_FS:<name>`; each value an XML+HTML-escaped `WinEmuRepo` JSON: `{category, depInfo, entry:{…EnvLayerEntity…}, isBase, isDep, name, state, version}`. The `entry` object's keys are **1:1 camelCase with `EnvLayerEntity`'s Kotlin field names** (the kotlinx `$$serializer` uses snake_case `@SerialName`). Written by `dj9.b(WinEmuRepo)`; the **sole** `getSharedPreferences("sp_winemu_unified_resources",0)` site is the multi-purpose lambda `je6.invoke()` (`:pswitch_0` branch — `je6` is reused for Firebase/`eln` too). **Not read by the picker offline** (picker is network-fed).
- **`egggame.db` `api_cache`** Room table (`ApiCacheEntity{key,body,headers,lastUpdated}`, `ApiCacheDao.getCache/saveCache`, sync worker `getCache$lambda$0`) caches `winemu_game_config:<params>` responses. **Also not** the offline picker source.
- `EnvLayerEntity` (non-obf, `com.xiaoji.egggame.common.winemu.bean`) — 20 serialized props; primary ctor 18-arg ambiguous, **synthetic kotlinx ctor** `(I,…20…,Lqrj;)`; use `Unsafe.allocateInstance` + reflective field-set to build. `EnvListData` public ctor `(List,int page,int pageSize,int total)`. `BaseResult`=`Lc91;`.

### 28.5 Worker / catalog ordering contract

Worker `getComponentList`/`getContainerList` do **not** sort — they serve the static catalog (`the412banner.github.io/bannerhub-api/simulator/v2/getComponentList`) verbatim, filtered by type. The picker (`gof`/`zxf`/`sz2`) does **not** sort client-side. ⟹ the displayed order ≡ the catalog file's append array order (oldest→newest, newest at bottom, curated `-async`/`-arm64ec` interleaving).

### 28.6 Reusable methodology (cross-cuts all bannerhub-revanced work)

- `com.blankj.utilcode.util.Utils` is R8-stripped → `hu5`; any `Utils.a()`-based sink (incl. `DebugTrace`) is **structurally broken on `banner.hub`** (NoClassDefFoundError → wrong fallback dir). Use a **Context-free hardcoded-path persistent-file sink**.
- **Comms constraint:** Claude runs in Termux on the *same* device → cannot be offline AND message → offline tests must persist evidence to disk, read back after reconnect.
- **Stack-trace-at-chokepoint** probe = model-free caller identification in obfuscated code. **`Unsafe.allocateInstance` + reflective field-set** = build obfuscated host beans without ctor/kotlinx. **In-process body-replace + reflective-original-passthrough** = a non-root "fake API" / offline shim pattern (suspension passes through verbatim).

### 28.7 Working fix (shipped)

`offlineComponentListPatch` (merged `gamehub-604-build` `dbd7554`, CI-validated run 26065842384 0 SEVERE): replace `gof.a` body → `OfflineComponentList.dispatch` (offline → `n55(List)` from `sp_winemu_unified_resources` `COMPONENT:` filtered by `ComponentType.type`; online/fail → reflective `gof.b`); `gof.c` index-0 conditional short-circuit → `getContainers()` (`CONTAINER:`); `OfflineComponentOrder` catalog-rank stable sort; fail-safe throughout. Device-confirmed (DXVK/GPU/VKD3D/FEX + Wine/Proton populate offline, correctly ordered; online byte-identical).
