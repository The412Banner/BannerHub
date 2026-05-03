# BannerHub-PuBG — Master Reverse Engineering Report

**Base APK:** BannerHub-v3.5.0-PuBG.apk  
**APK Size:** 139 MB  
**Decompiled:** apktool 2.12.1 + jadx 1.5.5 (40,805 Java source files, 30,470 jadx errors)  
**Scan Status:** Complete — 3 consecutive clean passes (Passes 79, 80, 81). Zero new findings.  
**Date:** 2026-04-28  
**Total Sections:** 524 (§1–§524)

---

## DEVELOPER NAVIGATION GUIDE

> **Purpose:** This report maps every class, URL, credential, API endpoint, and data flow in `BannerHub-v3.5.0-PuBG.apk`. Use it to locate the right code before adding features or debugging.

### Common Developer Tasks

| Task | Go to |
|---|---|
| Add a new store integration | §55 (GOG creds), §56 (Epic creds), §57 (Amazon creds), §333 (API catalog), §41 (credential stores) |
| Fix authentication / token refresh | §34 (TokenProvider), §64 (refresh endpoint), §108 (deep dive), §290 (EmuReady token), §342 (login flow) |
| Fix a download issue | §7/§40 (BhDownloadService), §319 (download service full), §352/§353 (Steam download), §320 (GOG download), §114 (Amazon download) |
| Add a new API endpoint to BannerHub | §333 (full endpoint catalog), §5 (API overview), §37 (configs worker endpoints), §339 (launcher repo catalog) |
| Modify store credentials | §55 (GOG), §56 (Epic), §57 (Amazon), §73/§293/§294/§292 (credential stores deep dive) |
| Change base API URL | §66 (injection point), §341 (EggGameHttpConfig), §39 (GameHubPrefs base URL) |
| Work on Steam integration | §332 (Steam module overview), §345–§360 (Steam deep dive), §344 (OTA), §54 (MitmProxy) |
| Work on cloud gaming | §331 (cloud module), §337 (payment), §343 (session API), §333 Cloud Gaming section |
| Work on component download system | §11 (component injection), §27 (component types), §49 (download repos), §334 (WinEmu components), §500 (GitHub manifests) |
| Fix PC streaming | §30/§47 (preferences/manifest), §340 (QR-code pairing API) |
| Understand launch pipeline | §335 (launch strategy), §350 (full details), §8 (GOG launch), §9 (Amazon launch) |
| Work on settings export | §10/§20 (overview), §308 (full exporter), §115 (internals), §38 (prefs schema) |
| Debug storage routing | §12 (MTDataFilesProvider), §42 (BhStoragePath), §307 (full storage path logic) |
| Work on social login / OAuth | §18 (OAuth flows overview), §501 (PSN), §502 (WeChat/QQ), §503 (Tencent telemetry), §505 (China Mobile SSO) |
| Understand native libraries | §15 (overview), §54 (MitmProxy/libmitm.so), §516 (DoH resolvers), §517 (WebRTC/ffmpeg) |
| Find all network security config | §29 (network security config), §326 (OkHttp client setup), §325 (request signing) |
| Find all hardcoded credentials | §55–§57, §68 (APK signing cert), §69 (Firebase/GameSir), §82 (PSN/Xbox), §83 (GitHub sources) |

---

## TABLE OF CONTENTS

### I. App Identity & Structure
- [§1 — App Identity](#1-app-identity) — Package ID, disguise strategy (`com.tencent.ig`), version
- [§2 — AndroidManifest Components](#2-androidmanifest-components) — All activities, services, receivers, providers
- [§3 — DEX Map](#3-dex-map-18-dex-files) — 18 DEX files and their module assignments
- [§4 — Source Package Map](#4-source-package-map) — Full `com.xj.*` and `app.revanced.*` namespace tree
- [§109 — BH Extension Manifest Components](#section-109--androidmanifest--bh-extension-components)
- [§110 — Full Permission List](#section-110--androidmanifest--permission-list)
- [§68 — APK Signing Certificate (TESTKEY)](#section-68-apk-signing-certificate--testkey)

### II. API Layer — GameHub Backend
- [**§333 — Complete API Endpoint Catalog**](#333--complete-api-endpoint-catalog-official-gamehub-backend) ← **Start here for API work**
- [§5 — BannerHub API & Network Layer](#5-bannerhub-api--network-layer) — Overview
- [§37 — Community Config Worker Endpoints](#37-community-config-worker--full-api-endpoint-map)
- [§339 — Launcher Repository API Catalog](#339--launcher-data-repository-api-catalog-comxjlandscapelauncherdatarepository)
- [§289 — Remaining API Route Reference](#289--remaining-api-route-master-reference)
- [§288 — Additional API Routes (Pass 31 smali sweep)](#288--additional-api-routes-found-in-pass-31-smali-sweep)
- [§66 — Base API URL + BannerHub Injection Point](#section-66-xiaoji-base-api-url--bannerhub-injection-point)
- [§341 — EggGameHttpConfig: OkHttp Client + Base URL Resolution](#341--eggamehttpconfig-okhttp-client-setup-and-base-url-resolution)
- [§325 — API Request Signing (SignUtils)](#325--api-request-signing-signutils)
- [§29 — Network Security Configuration](#29-network-security-configuration)

### III. Authentication & Token System
- [§18 — OAuth Login Flows](#18-oauth-login-flows) — All third-party OAuth providers
- [§34 — TokenProvider — Host App Token Access](#34-tokenprovider--host-app-token-access)
- [§64 — TokenProvider `/refresh` Endpoint](#section-64-tokenprovider-refresh-endpoint)
- [§108 — Token Provider Deep Dive](#108--token-provider-deep-dive-tokenprovider)
- [§290 — TokenProvider: EmuReady Token Service](#290--tokenprovider-emuready-token-service)
- [§342 — Authentication Endpoints (GuideLoginVM)](#342--authentication-endpoints-guideloginvm--guideinputvalidatecodeactivity)
- [§70 — Firebase Login (XiaoJi Launcher)](#section-70-xiaoji-launcher-firebase-login-firebaseauthloginutils)
- [§329 — Distribution Channel Detection (AppConfig)](#329--distribution-channel-detection-appconfig)
- [§328 — User Session Storage (UserManager)](#328--user-session-storage-usermanager)
- [§326 — HTTP Client Configuration (EggGameHttpConfig)](#326--http-client-configuration-egggamehttpconfig)
- [§327 — Client Parameters Format (ClientParams)](#327--client-parameters-format-clientparams)

### IV. Store Integrations

#### GOG Galaxy
- [§55 — GOG OAuth Client Credentials](#section-55-gog-hardcoded-oauth-client-credentials-gogtokenrefreshjava)
- [§106 — GOG Token Refresh Details](#106--gog-token-refresh-details-gogtokenrefresh)
- [§294 — GOG Galaxy OAuth Client](#294--gog-galaxy-oauth-client)
- [§22 — GOG Download System](#22-gog-download-system)
- [§58 — GOG Download Manager Endpoints](#section-58-gog-download-manager--gen1gen2installer-endpoints)
- [§320 — GOG Download API Endpoints](#320--gog-download-manager--api-endpoints-gogdownloadmanagerjava)
- [§321 — GOG User/Auth API Endpoints](#321--gog-userauth-api-endpoints-gogloginactivity-smali-scan)
- [§322 — GOG Cloud Save Manager](#322--gog-cloud-save-manager-gogcloudsavemanagerjava)
- [§65 — GOG Cloud Save Request User-Agent](#section-65-gog-cloud-save--request-user-agent)
- [§8 — GOG Launch Pipeline](#8-gog-launch-pipeline)
- [§304 — GOG Install Path & Launch Helper](#304--gog-install-path--launch-helper-goginstallpathjava-goglaunchhelper)
- [§86 — GogLaunchHelper Deferred Launch](#section-86-goglaunchhelper--deferred-launch-via-reflection)

#### Epic Games
- [§56 — Epic OAuth Client Credentials](#section-56-epic-hardcoded-oauth-client-credentials-epicauthclientjava)
- [§105 — Epic Auth Endpoints (EpicAuthClient)](#105--epic-games-auth-endpoints-epicauthclient)
- [§293 — Epic Games OAuth Client](#293--epic-games-oauth-client)
- [§23 — Epic Download System](#23-epic-download-system-epicdownloadmanager)
- [§43 — Epic API Client Endpoints](#43-epic-api-client--library-and-catalog-endpoints)
- [§72 — Epic API Client URLs + User-Agents](#section-72-epic-api-client-urls-and-user-agents)
- [§317 — Epic API Client (EpicApiClient.java)](#317--epic-api-client-epicapiclientjava)
- [§323 — Epic Cloud Save Manager](#323--epic-cloud-save-manager-epiccloudsavemanagerjava)
- [§301 — Epic Credential Store](#301--epic-credential-store-epiccredentialstorejava)
- [§302 — Epic Game Data Model](#302--epic-game-data-model-epicgamejava)

#### Amazon Games
- [§57 — Amazon OAuth Constants](#section-57-amazon-hardcoded-oauth-constants-amazonauthclient--amazoiapiclient)
- [§292 — Amazon Games OAuth Client](#292--amazon-games-oauth-client)
- [§24 — Amazon Download System](#24-amazon-download-system-amazondownloadmanager--amazonapiclient)
- [§59 — Amazon Download Manager File Markers](#section-59-amazon-download-manager--file-markers-and-constants)
- [§102 — Amazon API Endpoints (AmazonApiClient)](#102--amazon-gaming-api-endpoints-amazonapiclient)
- [§103 — Amazon Auth Endpoints (AmazonAuthClient)](#103--amazon-auth-endpoints-amazonauthclient)
- [§114 — Amazon Download Manager Internals](#114--amazon-download-manager-internals)
- [§300 — Amazon API Client](#300--amazon-api-client-amazoiapiclientjava)
- [§296 — Amazon Credential Store](#296--amazon-credential-store-amazoncredentialstorejava)
- [§297 — Amazon Game Data Model](#297--amazon-game-data-model-amazongamejava)
- [§298 — Amazon PKCE Generator](#298--amazon-pkce-generator-amazonpkcegeneratorjava)
- [§299 — Amazon Manifest Binary Format](#299--amazon-manifest-binary-format-amazonmanifestjava)
- [§316 — Amazon Launch Helper](#316--amazon-launch-helper-amazonlaunchhelper)
- [§318 — Amazon SDK Manager](#318--amazon-sdk-manager-amazonsdkmanagerjava)
- [§9 — Amazon Launch Pipeline](#9-amazon-launch-pipeline)
- [§63 — Amazon Wine Environment Variables](#section-63-amazon-wine-environment-variables-buildfuelenv)

#### Steam
- [§332 — Steam Module Overview](#332--steam-standalone-module--architecture--apis-steamapijava-steamconfigjava-steamapijava)
- [§345 — Steam Module Architecture (SteamAPI/SteamSdk/SteamConfig)](#345--steam-module-architecture-steamapi-steamsdk-steamconfig)
- [§346 — Steam Download Subsystem](#346--steam-download-subsystem)
- [§347 — XjSteamClient: Connection & Authentication](#347--xjsteamclient-steam-connection-and-authentication)
- [§353 — SteamDownloadManager Core Orchestrator](#353--steamdownloadmanager-core-download-orchestrator)
- [§354 — Steam Auth and Login Flow](#354--steam-auth-and-login-flow)
- [§355 — Steam Cloud Save System](#355--steam-cloud-save-system)
- [§356 — SteamGameApi: Game Info Queries](#356--steamgameapi-steam-game-info-queries)
- [§357 — Steam Input System](#357--steam-input-system)
- [§100 — Steam API URLs (SteamApiUrls)](#100--steam-api-urls-steamapiurls)
- [§25 — SteamCdnHelper Art Image CDN](#25-steamcdnhelper--art-image-cdn)
- [§107 — Steam Image CDN Layer (SteamCdnHelper)](#107--steam-image-cdn-layer-steamcdnhelper)
- [§291 — SteamCdnHelper: Game Header Art Resolution](#291--steamcdnhelper-game-header-art-resolution)
- [§54 — MitmProxy: Wine SSL Intercept (libmitm.so)](#54-mitmproxy--wine-ssl-intercept-libmitm-so)
- [§351 — Steam Service Layer](#351--steam-service-layer-modulesteam)

#### Xbox Cloud Gaming
- [§50 — Xbox Cloud Gaming (xCloud) — XboxWebActivity](#50-xbox-cloud-gaming-xcloud--xboxwebactivity)
- [§93 — Xbox Game Pass / PC Game Pass URLs](#93--xbox-game-pass--pc-game-pass-urls)
- [§496 — Xbox Cloud Gaming Integration](#496--xbox-cloud-gaming-integration)

### V. Download System
- [§7 — BhDownloadService (overview)](#7-download-system-bhdownloadservice)
- [§40 — BhDownloadService Unified Manager](#40-bhdownloadservice--unified-download-manager)
- [§319 — BhDownloadService Full Class](#319--bannerhub-download-service-bhdownloadservicejava)
- [§71 — BH Download Service Store Orchestration](#section-71-bh-download-service--store-orchestration)
- [§352 — Download Manager (GHDownloadManager)](#352--download-manager-ghdownloadmanager)
- [§360 — Download Stats and Content Downloader](#360--download-stats-and-content-downloader-details)

### VI. Component System
- [§11 — Component Injection System](#11-component-injection-system)
- [§27 — Component Type System (BhComponentAdapter)](#27-component-type-system-bhcomponentadapter)
- [§28 — WCP / XiaoJi Component Archive Format (WcpExtractor)](#28-wcp--xiaoji-component-archive-format-wcpextractor)
- [§48 — Component Type Numeric ID Map](#48-component-type-numeric-id-map)
- [§49 — Component Download Repos](#49-component-download-repos-componentdownloadactivity)
- [§67 — ComponentInjectorHelper — ZIP Format + .bh_injected Marker](#section-67-componentinjectorhelper--zip-component-format--bh_injected-marker)
- [§334 — WinEmu Component & Container System](#334--winemu-component--container-system-emucomponentsjava-envlayerentityjava)
- [§500 — Component Download Manifests (GitHub Raw)](#500--component-download-manifests-github-raw)

### VII. Settings, Config Export & Preferences
- [§10 — BhSettingsExporter (overview)](#10-bannerhub-settings-exporter-bhsettingsexporter)
- [§20 — Config Export JSON Schema](#20-config-export-json-schema-bhsettingsexporter)
- [§60 — BhSettingsExporter Config Export + Upload Flow](#section-60-bhsettingsexporter--config-export--upload-flow)
- [§308 — BhSettingsExporter Full Class](#308--bannerhub-settings-exporter-bhsettingsexporterclass)
- [§115 — BhSettingsExporter Config Export Internals](#115--bhsettingsexporter-config-export)
- [§19 — Per-Game Settings Keys (BhGameConfigsActivity)](#19-per-game-settings-keys-bhgameconfigsactivity)
- [§61 — BhGameConfigsActivity SharedPreferences + GitHub Sources](#section-61-bhgameconfigsactivity--config-browser-sharepreferences--github-sources)
- [§38 — banners_sources SharedPreferences Key Schema](#38-banners_sources-sharepreferences-key-schema)
- [§39 — GameHubPrefs: Cache Clear + Component Base URL](#39-gamehubprefs--full-cache-clear-and-component-base-url)
- [§74 — GameHubPrefs Settings System](#section-74-gamehubprefs--settings-system)
- [§306 — GameHub Preferences (GameHubPrefs.java)](#306--gamehub-preferences-gamehubprefsjava)
- [§51 — Full `pc_*` SharedPreferences Key Map](#51-full-pc_-sharepreferences-key-map-pcgamesettingdatahelper)
- [§30 — PC Streaming Preferences](#30-pc-streaming-preferences-resxmlpreferencesxml)

### VIII. Storage System
- [§12 — MTDataFilesProvider: Internal Storage Access](#12-mtdatafilesprovider--full-internal-storage-access)
- [§42 — BhStoragePath: Full Path Resolution Logic](#42-bhstoragepath--full-path-resolution-logic)
- [§75 — BhStoragePath Storage Routing](#section-75-bhstoragepath--storage-routing)
- [§307 — BhStoragePath (BhStoragePath.java)](#307--bannerhub-storage-path-bhstoragepathclass)
- [§309 — Storage Broadcast Receiver](#309--storage-broadcast-receiver-storagebroadcastreceiverjava)
- [§315 — MT Data Files Provider](#315--mt-data-files-provider-mtdatafilesproviderjava)
- [Section 80 — MTDataFilesProvider: Internal Storage DocumentsProvider](#section-80-mtdatafilesprovider--internal-storage-documentsprovider)
- [§52 — WinEmu Internal File Path Layout](#52-winemu-internal-file-path-layout-winumufilepathsconstant)
- [§53 — Steam Game Import Paths (ImportPcGameConstant)](#53-steam-game-import-paths-importpcgameconstant)

### IX. Launch Strategy & Wine / PC Emulation
- [§335 — Launch Strategy Architecture](#335--launch-strategy-architecture-pass-38)
- [§350 — Launch Strategy Pattern (Full Details)](#350--launch-strategy-pattern-full-details)
- [§358 — WinEmu Module: Wine PC Emulator Integration](#358--winemu-module-wine-pc-emulator-integration)
- [§295 — BhWineLaunchHelper: Wine Process Discovery](#295--bhwinelaunchhelper-wine-process-discovery)
- [§85 — BhWineLaunchHelper Wine Process Discovery](#section-85-bhwinelaunchhelper--wine-process-discovery)
- [§31 — GameMode Configuration](#31-gamemode-configuration-resxmlgame_mode_configxml)

### X. Native Libraries
- [§15 — Native Libraries Overview (arm64-v8a)](#15-native-libraries-arm64-v8a)
- [§54 — MitmProxy: Wine SSL Intercept (libmitm.so)](#54-mitmproxy--wine-ssl-intercept-libmitm-so)
- [§516 — libmitm.so: DNS-over-HTTPS Resolvers](#516--libmitm-so-dns-over-https-resolvers-steamchinaoptimizer)
- [§517 — Native Library Protocol URIs (libffmpeg + libjingle)](#517--native-library-protocol-uris-libffmpeg-orgso--libjingle_peerconnection_soso)
- [§36 — SoC Detection (detectSoc)](#36-soc-detection-detectsoc)
- [§26 — DeviceMetrics: GPU Sysfs Path Resolution](#26-devicemetrics--gpu-sysfs-path-resolution)
- [§310 — Device Metrics (DeviceMetrics.java)](#310--device-metrics-devicemetricsjava)

### XI. Cloud Gaming Module
- [§331 — Cloud Gaming Module Overview](#331--cloud-gaming-module-cloudgameinforepository-cloudgameapi-launchercloudgameviewmodeljava)
- [§337 — Cloud Gaming Payment Module](#337--cloud-gaming-payment-module-pass-38)
- [§343 — Cloud Gaming Session API](#343--cloud-gaming-session-api-cloudgameinforepository)
- [§338 — Tencent Portal Integration](#338--tencent-portal-integration-pass-38)

### XII. PC Streaming Module
- [§30 — PC Streaming Preferences](#30-pc-streaming-preferences-resxmlpreferencesxml)
- [§47 — PC Streaming Module Activities (Manifest)](#47-pc-streaming-module-activities-manifest)
- [§340 — PC Stream: QR-Code Pairing and Base-Link API](#340--pc-stream-module-qr-code-pairing-and-base-link-api)
- [§359 — PSPlay Module (PlayStation Remote Play / Chiaki)](#359--psplay-module-playstation-remote-play--chiaki)
- [§501 — PlayStation Network (PSN) OAuth Login](#501--playstation-network-psn-oauth-login)
- [§514 — PSPlay: Chiaki PSN Account ID Help URL](#514--psplay-chiaki-psn-account-id-help-url)

### XIII. ADB / Inject Module
- [§330 — ADB WiFi Inject Module Overview + Cloud Config API](#330--adb-wifi-inject-module--overview--cloud-config-api-adbactivationactivityjava-xjainjectcontrolktjava-httpconfigjava)
- [§499 — XJA Control API (ADB WiFi Module)](#499--xja-control-api-adb-wifi-module)

### XIV. Push Notifications & Analytics
- [§349 — Push Notification Module (JPush)](#349--push-notification-module-jpush)
- [§94 — Additional Third-Party Analytics Endpoints](#94--additional-third-party-analytics-endpoints)
- [§497 — Third-Party SDK Telemetry Endpoints](#497--third-party-sdk-telemetry-endpoints)
- [§498 — Steam SDK API Endpoints](#498--steam-sdk-api-endpoints)
- [§69 — Firebase / Google SDK Credentials (GameSir SDK)](#section-69-firebase--google-sdk-credentials-gamesir-sdk)

### XV. Social Login / OAuth Providers
- [§18 — OAuth Login Flows](#18-oauth-login-flows)
- [§501 — PlayStation Network (PSN) OAuth Login](#501--playstation-network-psn-oauth-login)
- [§502 — WeChat and QQ Social Login APIs](#502--wechat-and-qq-social-login-apis)
- [§503 — Tencent Internal Telemetry Endpoints](#503--tencent-internal-telemetry-endpoints)
- [§505 — Carrier SSO (China Mobile Login)](#505--carrier-sso-china-mobile-login)
- [§82 — PSN OAuth and Xbox URLs](#section-82-psn-oauth-and-xbox-urls)

### XVI. OTA / Firmware Updates
- [§344 — OTA / Firmware Update Module](#344--ota--firmware-update-module-comxjota)
- [§507 — XiaoJi X1 Firmware OTA URL (Disabled in Build)](#507--xiaoji-x1-firmware-ota-url-disabled-in-build)

### XVII. Assets & Resources
- [§16 — Assets Map](#16-assets)
- [§45 — Assets: Inject Files and Controller Profiles](#45-assets--inject-files-and-controller-profiles)
- [§17 — USB Gamepad Allowlist (device_filter.xml)](#17-usb-gamepad-allowlist-resxmldevice_filterxml)

### XVIII. Credentials & Secrets Index
> All hardcoded credentials found in the APK:

| Credential | Location | Section |
|---|---|---|
| GOG OAuth `client_id` / `client_secret` | `GogTokenRefresh.java` | §55 |
| Epic OAuth `client_id` / `client_secret` (multiple clients) | `EpicAuthClient.java` | §56 |
| Amazon OAuth `client_id` / `redirect_uri` | `AmazonAuthClient.java` | §57 |
| APK Signing Certificate (TESTKEY) | `META-INF/CERT.RSA` | §68 |
| Firebase API Key (GameSir SDK) | `google-services.json` | §69 |
| PSN OAuth App Key | `com.xj.psplay` | §82, §501 |
| Xbox Live Client ID | `com.xj.landscape.launcher` | §82, §93 |
| China Mobile SSO App Key | `com.xj.common` | §505 |
| Steam CM Server List (fallback hosts) | `SteamConfig` / `GHFileServerListProvider` | §89, §88 |
| ADB WiFi cloud config API key | `HttpConfig.java` | §330 |
| MitmProxy DoH resolvers (Alibaba, Cloudflare, Google) | `libmitm.so` | §516 |
| MitmProxy fallback DNS `223.5.5.5` | `libmitm.so` | §516 |

### XIX. Appendix: Inert Library Strings & Attribution
> These URLs appear in the APK but are **not callable API endpoints** — they are library documentation, license headers, and SDK attribution strings embedded in third-party code. Documented here for completeness.

- [§515 — Third-Party Library Attribution URLs](#515--third-party-library-attribution-urls-pass-65-findings)
- [§518 — Inert Library URI Constants & SDK Namespace Strings](#518--inert-library-uri-constants-and-sdk-namespace-strings-pass-69-floor-catalog)
- [§519 — Open-Source Library Author Attribution URLs](#519--open-source-library-author-attribution-urls)
- [§520 — AndroidVideoCache: Local HTTP Proxy](#520--androidvideocache-local-http-proxy-for-video-caching)
- [§521 — Additional Library Documentation URLs (Pass 73)](#521--additional-library-documentation-and-attribution-urls-pass-73-floor-supplement)
- [§522 — Debug URL Input Placeholder](#522--debug-url-input-placeholder)
- [§523 — Apache License URL in Apache Commons Codec Data Files](#523--apache-license-url-in-apache-commons-codec-data-files)
- [§524 — License Files and Proto Documentation URLs](#524--license-files-and-proto-documentation-urls-in-unknown-directory)
- [§511 — Google AdMob / Ad Services URLs (Bundled SDK)](#511--google-admob--ad-services-urls-bundled-sdk)
- [§512 — Google reCAPTCHA v3 Enterprise (Bundled SDK)](#512--google-recaptcha-v3-enterprise-bundled-sdk)
- [§513 — better-xcloud Self-Update and Documentation URLs](#513--better-xcloud-self-update-and-documentation-urls)

---

## FULL REPORT FOLLOWS

> Sections below retain their original numbering (§1–§524). The TOC above provides cross-references. Section heading styles vary (early sections use `## N. Title`, middle sections use `## Section N:` and `## §N —`, later sections use `## Pass N —`); content is consistent regardless of title format.

---

## 1. App Identity

| Field | Value |
|---|---|
| Package | `com.tencent.ig` |
| App Label | BannerHub (PUBG Mobile package-ID disguise) |
| Version Name | `3.5.0` |
| Version Code | `78` |
| Min SDK | 29 (Android 10) |
| Target SDK | 35 |
| Compile SDK | 23 (manifest `android:compileSdkVersion`) |
| Debuggable | not set (release build) |
| Main source namespaces | `com.xj.*` (XiaoJi base app), `app.revanced.extension.gamehub` (BannerHub extension layer) |

> **Disguise strategy:** Package ID `com.tencent.ig` is PUBG Mobile's official package name, allowing this APK to be installed as a replacement of/alongside PUBG on certain launchers. All BannerHub logic lives under `app.revanced.extension.gamehub` (59 classes) injected into the XiaoJi gamepad launcher base (`com.xj.*`, ~6,868 classes).

---

## 2. AndroidManifest Components

### Activities

#### `com.xj.app` (entry points)

| Class | Role | Notes |
|---|---|---|
| `com.xj.app.SplashActivity` | **LAUNCHER** — splash entry | exported=true, sensorLandscape |
| `com.xj.app.DeepLinkRouterActivity` | Deep-link + secondary LAUNCHER | exported=true, handles VIEW intents, BROWSABLE |

#### `com.xj.landscape.launcher.ui` (XiaoJi launcher UI)

| Class | Role |
|---|---|
| `ui.main.LandscapeLauncherMainActivity` | Main launcher UI (singleTask) |
| `ui.guide.GuideButtonAActivity` | Guide onboarding — button intro |
| `ui.guide.GuideLoginActivity` | Guide login page (translucent theme) |
| `ui.guide.GuidePhoneValidateActivity` | Phone number validation |
| `ui.guide.GuideRequestUsbtPermissionActivity` | USB permission request |
| `ui.guide.GuideInputValidateCodeActivity` | SMS/email code entry |
| `ui.guide.GuideCreateAvatarActivity` | Avatar creation (singleTask) |
| `ui.guide.GuideCreateNameActivity` | Username creation |
| `ui.guide.GuideHighlightActivity` | Feature highlight tour |
| `ui.guide.GuideKeypadOperationActivity` | Gamepad operation guide |
| `ui.guide.GuiRequestReadContactsPermissionActivity` | Contacts permission gate |
| `ui.guide.GuideFindContactActivity` | Find contacts flow |
| `ui.guide.GuideRequestNotificationPermissionActivity` | Notification permission gate |
| `ui.guide.GuideRequestStoragePermissionActivity` | Storage permission gate |
| `ui.guide.GuideGamePadCover1Activity` | Gamepad cover page 1 |
| `ui.guide.GuideGamePadCover2Activity` | Gamepad cover page 2 |
| `ui.guide.GuideGamePadPromotional1/2/3Activity` | Gamepad promo pages (3) |
| `ui.guide.GuideBuyGamePadActivity` | Purchase gamepad CTA |
| `ui.guide.GuideNotConnectGamePadActivity` | No-gamepad fallback |
| `ui.guide.GuideEmailValidateActivity` | Email validation |
| `ui.guide.GuideCreateInfoActivity` | Profile creation info |
| `ui.record.RecordMainActivity` | Screen recording UI (singleTask) |
| `ui.record.CutVideoActivity` | Video trim editor |
| `ui.record.EditorVideoActivity` | Video editor |
| `ui.record.HighlightsNamingActivity` | Highlight clip naming |
| `ui.record.HighlightsEditTagActivity` | Highlight clip tagging |
| `ui.record.HeightLightsPreviewActivity` | Highlight preview |
| `ui.WebActivity` | Embedded WebView (landscape) |
| `ui.VerticalWebActivity` | Embedded WebView (portrait) |
| `ui.setting.SettingMainActivity` | App settings |
| `ui.setting.DeviceInfoActivity` | Device information |
| `ui.setting.tab.RecordSettingModelActivity` | Recording quality settings |
| `ui.device.DeviceManagerActivity` | Gamepad device manager |
| `ui.device.SelectDeviceActivity` | Gamepad device selector |
| `ui.device.ScanDeviceActivity` | BLE device scan |
| `ui.device.ProductDocActivity` | Device documentation |
| `ui.gamedetail.GameDetailActivity` | **Game detail page** — exported=true, handles `com.tencent.ig.LAUNCH_GAME` intent, excludeFromRecents, taskAffinity="" |
| `ui.gamedetail.NewsDetailActivity` | Game news detail |
| `ui.gamedetail.GameDetailMoreInfoActivity` | Extended game info (translucent) |
| `ui.gamedetail.PreviewPictureActivity` | Screenshot preview |
| `ui.gamedetail.GameVideoActivity` | Game video player |
| `ui.feedback.FeedbackActivity` | User feedback form |
| `ui.feedback.MyFeedbackActivity` | Submitted feedback list |
| `ui.search.V4SearchActivity` | Search (translucent, adjustPan) |
| `ui.album.AlbumDetailActivity` | Media album detail |
| `ui.social.UserInfoActivity` | User profile (translucent) |
| `ui.notification.CommonFragmentActivity` | Notification fragment host (translucent) |
| `ui.usercenter.EditUserProfileActivity` | Edit user profile |
| `ui.usercenter.UserCenterActivity` | User center hub |
| `ui.menu.ComponentManagerActivity` | Component manager UI |
| `ui.menu.ComponentDownloadActivity` | Component download UI |
| `ui.mobilegame.MobileGameV4Activity` | Mobile game launcher |
| `devicemanagement.PermissionsActivity` | USB attach permission gate — handles `android.hardware.usb.action.USB_DEVICE_ATTACHED` |

#### `app.revanced.extension.gamehub` (BannerHub extension)

| Class | Role |
|---|---|
| `GogMainActivity` | GOG — account dashboard |
| `GogLoginActivity` | GOG — OAuth login |
| `GogGamesActivity` | GOG — library browser |
| `GogGameDetailActivity` | GOG — game detail |
| `GogDownloadManager` (service) | GOG — download orchestration |
| `EpicMainActivity` | Epic — account dashboard |
| `EpicLoginActivity` | Epic — OAuth login |
| `EpicGamesActivity` | Epic — library browser |
| `EpicGameDetailActivity` | Epic — game detail |
| `EpicFreeGamesActivity` | Epic — free games list |
| `AmazonMainActivity` | Amazon — account dashboard |
| `AmazonLoginActivity` | Amazon — OAuth login |
| `AmazonGamesActivity` | Amazon — Prime Gaming library |
| `AmazonGameDetailActivity` | Amazon — game detail |
| `BhGameConfigsActivity` | BannerHub — per-game settings editor (adjustResize) |
| `BhDownloadsActivity` | BannerHub — active downloads list |
| `FolderPickerActivity` | BannerHub — install dir picker |

#### Third-party / library activities

| Class | Role |
|---|---|
| `com.luck.picture.lib.basic.PictureSelectorSupporterActivity` | Image/media selector (LuckPicture lib) |
| `com.xj.landscape.launcher.test.RecordTestActivity` | Internal recording test |
| `com.xj.landscape.launcher.test.AudioViewEditorTestActivity` | Internal audio edit test |
| `com.xj.landscape.launcher.test.FocusCusViewActivity` | Internal focus test |

---

### Services (21)

| Service | Type | Exported | Role |
|---|---|---|---|
| `ScreenRecordService` | mediaProjection | false | Screen recording foreground service |
| `DeviceManagementService` | specialUse | false | USB gamepad device management |
| `BhDownloadService` | dataSync | false | **BH multi-store game downloader** (Epic/GOG/Amazon) |
| `DownloadService` (com.xj.apk.update) | specialUse | implicit | APK self-update downloader |
| `MappingService` | specialUse | true | Key mapping overlay (process="") |
| `KeyboardEditService` | specialUse | true | Keyboard overlay editor (process="") |
| `InjectService` | connectedDevice | true | Input injection — requires `com.xiaoji.egggame.permission.SAFE_ACCESS` (process="") |
| `SSLClientService` | specialUse | true | SSL/MITM proxy client (process="") |
| `VTouchIPCService` | specialUse | true | Virtual touch IPC bridge (process="") |
| `UnzipService` | specialUse | false | Component archive extraction |
| `EmuFileService` | specialUse | implicit | Emulator file manager + install |
| `SteamService` (com.xj.module.steam) | specialUse | implicit | Steam module service |
| `DiscoveryService` | specialUse | implicit | mDNS PC auto-discovery |
| `ComputerManagerService` | specialUse | implicit | PC session management |
| `UsbDriverService` | specialUse | implicit | USB input driver |
| `MessengerUtils$ServerService` | — | false | BlankJ utility messenger |
| `MetadataHolderService` | — | false | Camera metadata (disabled) |
| `CredentialProviderMetadataHolder` | — | false | AndroidX credentials |
| `MultiInstanceInvalidationService` | — | false | Room DB multi-instance sync |
| `UMonitorService` | — | false | Memory leak monitor (process=:u_heap) |
| `AdbPairingService` | connectedDevice | false | WiFi ADB pairing |

---

### Receivers (2)

| Class | Trigger |
|---|---|
| `com.xj.muugi.shortcut.special.AutoCreateBroadcastReceiver` | Auto-create shortcut broadcast |
| `com.xj.muugi.shortcut.broadcast.NormalCreateBroadcastReceiver` | Normal shortcut create broadcast |

---

### Content Providers (10)

| Class | Authority | Exported | Role |
|---|---|---|---|
| `AppUpdateFileProvider` (launcher) | `com.tencent.ig.apkUpdateFileProvider` | false | APK update file sharing |
| `AppUpdateFileProvider` (xj.apk.update) | `com.tencent.ig.apkUpdateFileProvider` | false | APK update file sharing (duplicate entry) |
| `PosterContentProvider` | `com.tencent.ig_poster.com.xiaoji.egggame.mod` | **true** | Game poster/art content provider |
| `ShareFileProvider` | `com.tencent.ig.share.sharefileprovider` | false | Share file paths |
| `InitializationProvider` | `com.tencent.ig.androidx-startup` | false | AndroidX startup initializers |
| `PictureFileProvider` | `com.tencent.ig.luckProvider` | false | LuckPicture image selector |
| `UtilsFileProvider` | `com.tencent.ig.utilcode.fileprovider` | false | BlankJ utility file provider |
| `FileProvider` (core) | `com.tencent.ig.provider` | false | Generic file sharing |
| `FileProvider` (ando) | `com.tencent.ig.andoFileProvider` | false | Ando file library |
| `PsFileProvider` | `com.tencent.ig.psplay.fileprovider` | false | PS play file provider |
| **`MTDataFilesProvider`** | `com.tencent.ig.app.revanced.extension.gamehub.filemanager.MTDataFilesProvider` | **true** | **BH DocumentsProvider — full internal storage access** (requires MANAGE_DOCUMENTS) |

---

### Permissions

```
CHANGE_NETWORK_STATE, INTERNET, ACCESS_WIFI_STATE, ACCESS_NETWORK_STATE,
KILL_BACKGROUND_PROCESSES, READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE,
READ_MEDIA_VISUAL_USER_SELECTED, VIBRATE, android.hardware.usb.host,
WRITE_MEDIA_STORAGE, WRITE_SETTINGS, MODIFY_AUDIO_SETTINGS,
MANAGE_EXTERNAL_STORAGE, FOREGROUND_SERVICE, FOREGROUND_SERVICE_DATA_SYNC,
POST_NOTIFICATIONS, RECORD_AUDIO, READ_MEDIA_IMAGES, READ_MEDIA_AUDIO,
READ_MEDIA_VIDEO, SYSTEM_ALERT_WINDOW,
com.android.permission.GET_INSTALLED_APPS, QUERY_ALL_PACKAGES,
FOREGROUND_SERVICE_MEDIA_PROJECTION, FOREGROUND_SERVICE_SPECIAL_USE,
ACCESS_COARSE_LOCATION, ACCESS_FINE_LOCATION, BLUETOOTH (≤30), BLUETOOTH_SCAN,
BLUETOOTH_ADVERTISE, BLUETOOTH_CONNECT, WAKE_LOCK,
CHANGE_WIFI_MULTICAST_STATE (≤33), BLUETOOTH_ADMIN (≤30), CAMERA, FLASHLIGHT,
HIGH_SAMPLING_RATE_SENSORS,
com.tencent.ig_com.bbk.launcher2.permission.READ_SETTINGS (BBK/vivo compat),
com.tencent.ig_com.bbk.launcher2.permission.WRITE_SETTINGS,
com.tencent.ig.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION (declared + used, signature)
```

### Hardware Features

```
android.hardware.touchscreen (required=false)
android.hardware.wifi (required=false)
android.hardware.gamepad (required=false)
android.hardware.usb.host (required=false)
android.software.leanback (required=false)
android.hardware.sensor.accelerometer (required=false)
android.hardware.sensor.gyroscope (required=false)
android.hardware.type.pc (required=false)
android.hardware.bluetooth_le (required=true)
```

### Application Meta-data

```
ScopedStorage = true
```

### `res/xml/` Files

| File | Purpose |
|---|---|
| `device_filter.xml` | USB HID allowlist — Sony DualShock (vendor 1356, product 3302), GameSir (vendor 13623, products 264/274/4374/4408) |
| `default_device_filter.xml` | Default USB device filter (fallback) |
| `file_paths.xml` | FileProvider paths |
| `filepaths.xml` | Secondary file paths (ando lib) |
| `ando_paths.xml` | Ando file lib paths |
| `app_update_file.xml` | APK update file provider paths |
| `ps_file_paths.xml` | PS play file paths |
| `image_share_filepaths.xml` | Image share file paths |
| `share_file_paths.xml` | Share file paths |
| `util_code_provider_paths.xml` | BlankJ util provider paths |
| `preferences.xml` | Preferences definition |
| `network_security_config.xml` | Network security config |
| `backup_rules.xml` | Backup inclusion rules |
| `backup_rules_s.xml` | Android 12+ backup rules |
| `locales_config.xml` | Supported locales |
| `game_mode_config.xml` | Game mode configuration |
| `icons/` | App icon resources |
| `profiles/` | Device profiles |
| `templates/` | UI templates |
| `AlimamaShuHeiTi-Bold.ttf` | Alibaba Ma Ma font (bold) |
| `m3_button_group_child_size_change.xml` | Material 3 button group animation |
| `m3expressive_button_shape_state_list.xml` | M3 button shape states |
| `m3expressive_connected_buttons_inner_corner_size_state_list.xml` | M3 connected button corners |
| `m3_split_button_inner_corner_size_state_list.xml` | M3 split button corners |

---

## 3. DEX Map (18 DEX files)

| DEX | Smali Files | Key Contents |
|---|---|---|
| `classes.dex` | 5,717 | Base framework, third-party libs (androidx, kotlin, kotlinx, etc.) |
| `classes2.dex` | 5,752 | androidx (cont.), core framework extensions |
| `classes3.dex` | 5,863 | com.xj framework layer (partial) |
| `classes4.dex` | 5,938 | com.xj UI layer (partial); **GHLog** (GHL/* logcat tags) |
| `classes5.dex` | 5,492 | com.xj mapping/input; **MTDataFilesProvider** (BH file manager) |
| `classes6.dex` | 5,847 | com.xj game layer; **GameHubPrefs** (API source, storage prefs) |
| `classes7.dex` | 6,096 | com.xj streaming/device layer |
| `classes8.dex` | 5,783 | com.xj launcher UI (partial) |
| `classes9.dex` | 5,876 | com.xj media/render; **PlaytimeHelper** (Steam SQLite reader) |
| `classes10.dex` | 5,988 | com.xj steam module (partial); **TokenProvider** (token cache + bypass) |
| `classes11.dex` | 6,062 | com.xj components; **CompatibilityCache** (game compat injection) |
| `classes12.dex` | 5,711 | com.xj module steam (partial) |
| `classes13.dex` | 5,885 | com.xj winemu (partial) |
| `classes14.dex` | 3,685 | com.xj winemu download; third-party (Room, Glide, etc.) |
| `classes15.dex` | 1,400 | com.xj miscellaneous utilities |
| `classes16.dex` | 177 | **ComponentInjectorHelper** — WCP installer + component list injection |
| `classes17.dex` | 100 | defpackage stubs — ComponentRepo, State (obfuscated symbols) |
| `classes18.dex` | 632 | **BannerHub extension core** — all `app.revanced.extension.gamehub.*` store logic, download service, settings exporter, launch helpers, credential stores |

**Total smali files: ~90,204** across 18 DEX files

> **classes18 is the BH patch DEX.** All `app.revanced.extension.gamehub` classes live here unless noted otherwise. It is the primary target for BannerHub patches and additions.

> **classes16/17** are the component injection layer — `ComponentInjectorHelper` (16) uses obfuscated `ComponentRepo`/`State` stubs (17) from `defpackage`.

---

## 4. Source Package Map

### `app.revanced.extension.gamehub` — BannerHub Extension Layer (classes18 primary)

#### Store Activities & Orchestrators

| Class | DEX | Role |
|---|---|---|
| `GogMainActivity` | 18 | GOG account dashboard (login state UI built programmatically) |
| `GogLoginActivity` | 18 | GOG OAuth login flow |
| `GogGamesActivity` | 18 | GOG library browser |
| `GogGameDetailActivity` | 18 | GOG game detail + launch |
| `GogLaunchHelper` | 18 | GOG launch via `pending_gog_exe` pref → `B3()` reflection call |
| `GogTokenRefresh` | 18 | GOG OAuth token refresh (client_id `46899977096215655`) |
| `GogCloudSaveManager` | 18 | GOG cloud save sync |
| `GogDownloadManager` | 18 | GOG game download orchestration |
| `GogInstallPath` | 18 | GOG install dir → `BhStoragePath.getInstallDir(ctx, "gog_games", title)` |
| `EpicMainActivity` | 18 | Epic account dashboard (COLOR_EPIC = -16746256) |
| `EpicLoginActivity` | 18 | Epic OAuth login (PKCE) |
| `EpicGamesActivity` | 18 | Epic library browser |
| `EpicGameDetailActivity` | 18 | Epic game detail + launch |
| `EpicFreeGamesActivity` | 18 | Epic free game promotions list |
| `EpicApiClient` | 18 | Epic catalog/manifest API (Legendary UA: `Legendary/0.1.0 (GameNative)`) |
| `EpicAuthClient` | 18 | Epic OAuth token management |
| `EpicCredentialStore` | 18 | Epic credential persistence (prefs: `bh_epic_prefs`) |
| `EpicDownloadManager` | 18 | Epic game download orchestration |
| `EpicCloudSaveManager` | 18 | Epic cloud save sync |
| `AmazonMainActivity` | 18 | Amazon account dashboard |
| `AmazonLoginActivity` | 18 | Amazon OAuth login (PKCE) |
| `AmazonGamesActivity` | 18 | Amazon Prime Gaming library |
| `AmazonGameDetailActivity` | 18 | Amazon game detail + launch |
| `AmazonApiClient` | 18 | Amazon Games API client |
| `AmazonAuthClient` | 18 | Amazon OAuth token management |
| `AmazonCredentialStore` | 18 | Amazon credential persistence (JSON file: `filesDir/amazon/credentials.json`) |
| `AmazonDownloadManager` | 18 | Amazon game download orchestration |
| `AmazonLaunchHelper` | 18 | Amazon launch spec builder — reads `fuel.json`, pattern-matches UE/generic EXEs |
| `AmazonManifest` | 18 | Amazon manifest/metadata model |
| `AmazonPKCEGenerator` | 18 | Amazon PKCE challenge generator |
| `AmazonSdkManager` | 18 | Amazon SDK lifecycle |

#### BannerHub Core

| Class | DEX | Role |
|---|---|---|
| `BhDownloadService` | 18 | **Multi-store game downloader** — GOG/Epic/Amazon via `ACTION_START`/`ACTION_CANCEL` |
| `BhDownloadsActivity` | 18 | Active download progress UI |
| `BhDashboardDownloadBtn` | 18 | Dashboard download badge (live count via `CountObserver`) |
| `BhGameConfigsActivity` | 18 | Per-game settings editor (prefs: `pc_g_setting<gameId>`) |
| `BhSettingsExporter` | 18 | Config export/import — local save or share to `WORKER_BASE` |
| `BhStoragePath` | 18 | Central storage path resolver (internal or custom SD path) |
| `BhWineLaunchHelper` | 18 | Wine process discovery via `/proc` scanning; reads `WINELOADER`/`WINEPREFIX` env vars |
| `FolderPickerActivity` | 18 | Install directory selection UI |
| `MTDataFilesProvider` | 5 | **Exported DocumentsProvider** — exposes /data/user, /data/user_de, android_data, android_obb to external managers |

#### Infrastructure

| Class | DEX | Role |
|---|---|---|
| `TokenProvider` | 10 | Token fetch + 4h cache; `apiSwitchPatched=true`, `loginBypassed=true` |
| `GameHubPrefs` | 6 | Global prefs hub — API source, storage path, CPU/perf toggles |
| `CompatibilityCache` | 11 | In-memory game compat data injection via reflection into host models |
| `PlaytimeHelper` | 9 | Reads Steam playtime from `xj_steam_db` SQLite (table: `steam_account`) |
| `GHLog` | 4 | Logcat tag enum — 13 named tags under `GHL/` prefix |
| `SteamCdnHelper` | util | Steam CDN URL builder |
| `DeviceMetrics` | util | Device hardware info collector |
| `BatteryHelper` | util | Battery level/state reader |
| `CpuUsageHelper` | util | CPU usage monitor |
| `PerformanceMetricsHelper` | util | FPS/perf overlay data |
| `GameIdHelper` | util | Steam/store game ID resolution |
| `AccountCurrencyHelper` | util | Account wallet currency fetch |
| `StorageBroadcastReceiver` | token | Storage permission change receiver |

#### `filemanager` sub-package

| Class | Role |
|---|---|
| `MTDataFilesProvider` | Full internal storage DocumentsProvider (see Providers section) |
| `MTDataFilesWakeUpActivity` | Wake-up trampoline for file manager access |

#### `network` sub-package
Network utilities for BH API calls (exact classes TBD — jadx partial).

#### `steam` sub-package (via `app.revanced.extension.gamehub.steam`)
Steam CDN helpers and URL builders.

---

### `com.xj.*` — XiaoJi Base App Packages

| Package | Role |
|---|---|
| `com.xj.app` | Entry point activities (Splash, DeepLink) |
| `com.xj.landscape.launcher` | Full launcher UI (main, guide flows, recording, settings, device, social) |
| `com.xj.mapping` | Key mapping overlay (MappingService, KeyboardEditService, InjectService, VTouchIPCService) |
| `com.xj.winemu` | **Wine emulator bridge** — EmuComponents, EmuFileService, WinEmuDownloadManager, component system |
| `com.xj.module.steam` | Steam integration module — SteamService, SteamDownloader, SteamModuleApp, cloud saves |
| `com.xj.module.pcstream` | PC streaming (DiscoveryService, ComputerManagerService) |
| `com.xj.psplay` | PlayStation streaming/Play link |
| `com.xj.devicemanagement` | USB device management (DeviceManagementService, PermissionsActivity) |
| `com.xj.apk.update` | APK self-update (DownloadService) |
| `com.xj.adb` | WiFi ADB support (AdbPairingService) |
| `com.xj.muugi` | Shortcut system (Auto/NormalCreateBroadcastReceiver) |
| `com.xj.steam` | Steam module utilities |
| `com.xj.common` | Shared data models (StarterGame, EmulatorInfo, GameCompatibilityParams) |
| `com.xj.cloud` | Cloud data services |
| `com.xj.game` | Game metadata |
| `com.xj.umeng` | Umeng analytics |
| `com.xj.push` | Push notifications |
| `com.xj.user` | User account management |
| `com.xj.pay` | Payment integration |
| `com.streaming` | PC streaming core (wraps `libstreaming-core.so`) |
| `com.xiaoji.wifi.adb` | WiFi ADB implementation |

---

## 5. BannerHub API & Network Layer

### API Sources (3-way switch — `GameHubPrefs.getApiSource()`)

| Value | Source | Components URL | Token |
|---|---|---|---|
| `0` | Official XiaoJi API | Stock XiaoJi component feed | Original app token |
| `1` | EmuReady | `https://gamehub-lite-api.emuready.workers.dev/` | `"fake-token"` |
| `2` | BannerHub | `https://bannerhub-api.the412banner.workers.dev/` | Service token via token refresher |

- SharedPreferences: `"steam_storage_pref"` (key: `"api_source"`)
- Toggle cycles 0 → 1 → 2 → 0; clears component + token caches on switch
- `isExternalAPI()` = source ≠ 0 → enables Steam Input force, bypasses login

### Token Provider (`TokenProvider`)

| Constant | Value |
|---|---|
| `TOKEN_SERVICE_URL` | `https://gamehub-lite-token-refresher.emuready.workers.dev/token` |
| `AUTH_HEADER_VALUE` | `gamehub-internal-token-fetch-2025` |
| `CACHE_TTL_MS` | 14,400,000 ms (4 hours) |
| `apiSwitchPatched` | `true` (static, patched in) |
| `loginBypassed` | `true` (static, patched in) |

**Token resolution flow:**
1. If `apiSwitchPatched && isExternalAPI()` → return `"fake-token"` immediately
2. Else if `loginBypassed` → fetch service token from `TOKEN_SERVICE_URL` (4h cache)
3. Else → pass through original token unchanged

**Token caches:**
- L1: `AtomicReference<CachedToken>` (in-memory)
- L2: SharedPreferences `"token_provider_pref"` → `cached_token`, `cached_token_expiry`

### Epic API Endpoints

| Constant | URL |
|---|---|
| `LIBRARY_URL` | `https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true` |
| `CATALOG_BASE` | `https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace` |
| `MANIFEST_BASE` | `https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace` |
| User-Agent | `Legendary/0.1.0 (GameNative)` |

### GOG API

| Constant | Value |
|---|---|
| Token refresh URL | `https://auth.gog.com/token?client_id=46899977096215655&client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9&grant_type=refresh_token&refresh_token=<token>` |
| Timeouts | connect=15s, read=15s |

### BannerHub Worker Endpoints

| Constant | URL |
|---|---|
| `BANNERHUB_URL` | `https://bannerhub-api.the412banner.workers.dev/` |
| `EMUREADY_URL` | `https://gamehub-lite-api.emuready.workers.dev/` |
| `WORKER_BASE` (configs) | `https://bannerhub-configs-worker.the412banner.workers.dev` |

---

## 6. Storage & Preferences System

### Storage Path Resolution (`BhStoragePath`)

```
SharedPreferences "steam_storage_pref":
  "use_custom_storage" (boolean, default false)
  "steam_storage_path" (string, custom root)

If use_custom_storage=true && steam_storage_path set:
  base = <custom_path>/bannerhub/<store_dir>/
Else:
  base = context.getFilesDir()/<store_dir>/
```

**Store directories:**
- GOG: `gog_games/<game_title>/`
- Epic: (via BhStoragePath, store dir TBD)
- Amazon: internal store dir (via BhStoragePath)
- Amazon credentials (special): `context.getFilesDir()/amazon/credentials.json`

**Config export path:** `BannerHub/configs/` (relative to external storage via `Environment.getExternalStorageDirectory()`)

### SharedPreferences Registry

| Prefs Name | Owner | Key Contents |
|---|---|---|
| `"steam_storage_pref"` | GameHubPrefs / BhStoragePath | `api_source`, `last_api_source`, `use_custom_storage`, `steam_storage_path`, `use_external_api`, `cpu_usage_display`, `perf_metrics_display`, `log_all_requests` |
| `"token_provider_pref"` | TokenProvider | `cached_token`, `cached_token_expiry` |
| `"bh_epic_prefs"` | EpicCredentialStore | `access_token`, `refresh_token`, `account_id`, `display_name`, `expires_at` |
| `"bh_gog_prefs"` | GogMainActivity / GogLaunchHelper | `access_token`, `refresh_token`, `pending_gog_exe` |
| `"bh_library"` | BhDownloadService | game library entries (newline-separated) |
| `"banners_sources"` | BhSettingsExporter | component sources config |
| `"pc_g_setting<gameId>"` | BhGameConfigsActivity | per-game emulator/graphics settings |

### File Storage Registry

| Path | Owner | Contents |
|---|---|---|
| `context.getFilesDir()/amazon/credentials.json` | AmazonCredentialStore | access_token, refresh_token, device_serial, client_id, expires_at |
| `<custom_or_internal>/bannerhub/gog_games/<title>/` | GogInstallPath | GOG game installation |
| `BannerHub/configs/` (external) | BhSettingsExporter | exported per-game config JSON files |

---

## 7. Download System (`BhDownloadService`)

### Intent Protocol

| Extra | Key | Type | Store |
|---|---|---|---|
| Store identifier | `"store"` | String | all |
| Game display name | `"game_name"` | String | all |
| Internal game ID | `"game_id"` | String | all |
| GOG numeric game ID | `"gog_gid"` | String | GOG |
| GOG game title | `"gog_title"` | String | GOG |
| GOG generation | `"gog_gen"` | String | GOG |
| GOG image URL | `"gog_img"` | String | GOG |
| GOG developer | `"gog_dev"` | String | GOG |
| GOG category | `"gog_cat"` | String | GOG |
| Epic app name | `"epic_app"` | String | Epic |
| Epic catalog item ID | `"epic_cat"` | String | Epic |
| Epic namespace | `"epic_ns"` | String | Epic |
| Amazon entitlement ID | `"amz_eid"` | String | Amazon |
| Amazon product ID | `"amz_pid"` | String | Amazon |
| Amazon SKU | `"amz_sku"` | String | Amazon |
| Amazon title | `"amz_title"` | String | Amazon |

**Actions:**
- `ACTION_START = "bh.download.START"` — begin download
- `ACTION_CANCEL = "bh.download.CANCEL"` — cancel download

**Notification IDs:**
- Active download: `NOTIF_ID = 8800`
- Completion base: `NOTIF_DONE_BASE = 8810`
- Channel: `"bh_downloads"`

---

## 8. GOG Launch Pipeline

```
User taps "Launch" in GogGamesActivity / GogGameDetailActivity
    ↓
GogLaunchHelper.triggerLaunch(activity, exePath)
    → writes "pending_gog_exe" = exePath to "bh_gog_prefs"
    → calls activity.finish()
    ↓
GogMainActivity.onResume()
    → reads "pending_gog_exe" from "bh_gog_prefs"
    → if not null → clears pref → calls B3(exePath) via reflection on host Activity
    ↓
Host Activity B3(exePath) — XiaoJi launcher launches game via Wine/WinEmu
```

> **Key:** The launch uses a `pending_gog_exe` SharedPreferences handoff. The actual game launch is delegated to the host launcher's `B3()` method via reflection — this is an injection point. If `B3` is renamed, GOG launches silently fail.

---

## 9. Amazon Launch Pipeline

`AmazonLaunchHelper.buildLaunchSpec(installDir, sku, title)`:

1. **Unreal Engine detection** — checks for `fuel.json` in install root, reads `Main.Command` field
2. **UE binary scan** — pattern `.*-win(32|64)(-shipping)?\.exe$` (regex, case-insensitive)
3. **Generic binaries scan** — pattern `.*/binaries/win(32|64)/.*\.exe$`
4. **Generic name pattern** — `^[a-z]\d{1,3}\.exe$`
5. **Negative keyword filter** — skips any match containing: `crash`, `handler`, `viewer`, `compiler`, `tool`, `setup`, `unins`, `eac`, `launcher`, `steam`

Returns `LaunchSpec { command, exeRelativePath, workingDir }`.

---

## 10. BannerHub Settings Exporter (`BhSettingsExporter`)

**Export dialog fields displayed:**
- Device: `Build.MANUFACTURER + " " + Build.MODEL`
- SOC: `detectSoc(context)` result
- Settings count: size of `pc_g_setting<gameId>` prefs
- Components count: `buildComponentsArray(context, gameId).length()`

**Export modes:**
- "Save Locally" → writes JSON to `BannerHub/configs/<filename>`
- "Save + Share Online" → same, then POSTs to `https://bannerhub-configs-worker.the412banner.workers.dev`

**`BH_VERSION` constant:** `"3.5.0"`

**`buildComponentsArray()` — reads exactly 7 component pref keys:**
1. `pc_ls_DXVK` — DXVK selection
2. `pc_ls_VK3k` — VkD3D-Proton selection
3. `pc_set_constant_94` — component type 94
4. `pc_set_constant_95` — component type 95
5. `pc_ls_GPU_DRIVER_` — GPU driver (JSON: `{name, displayName}`)
6. `pc_ls_CONTAINER_LIST` — container selection
7. `pc_ls_steam_client` — Steam client selection

For each non-empty key, reads `banners_sources` → `url_for:<name>` and `<name>:type` to build: `{"name": ..., "url": ..., "type": ...}`

**`injectAndRegister()` — writes 4 keys to `banners_sources` per component:**
- `<name>` → `"BannerHub"` (source label)
- `dl:<url>` → `"1"` (marks URL as downloaded)
- `<name>:type` → type string
- `url_for:<name>` → download URL

**GPU component install dir:** `context.getFilesDir()/usr/home/components`

**Community import flow:**
1. Calls `GET /list?game=<gameName>` on worker → returns JSON array of config entries
2. User selects config → `GET /download?filename=<name>` → JSON downloaded
3. `applyConfig()` writes settings keys + calls `injectAndRegister()` for each component

---

## 11. Component Injection System

**`ComponentInjectorHelper` (classes16):**
- `appendLocalComponents(list, type)` — reads from `EmuComponents.d` map, filters by component type
- Supported type bypass: type `32` also accepts sub-types `94` and `95`
- Populates `DialogSettingListItemEntity` with title, displayName, type, EnvLayerEntity, desc, `downloaded=true`

**`extractWcp(context, uri, i, destDir, flattenPaths)`:**
- Reads `.xj`/`.wcp` archives (XZ + TAR via Apache Commons Compress)
- Skips directories and `profile.json` entries
- `flattenPaths=true` → strips path prefix, extracts flat to destDir

**WCP format:** `xz(tar(files...))` — same format as XiaoJi components.

---

## 12. MTDataFilesProvider — Full Internal Storage Access

**Authority:** `com.tencent.ig.app.revanced.extension.gamehub.filemanager.MTDataFilesProvider`  
**Permission required:** `android.permission.MANAGE_DOCUMENTS`  
**Exported:** `true`

**Exposed roots:**

| Root ID | Path |
|---|---|
| `data` | `/data/user/0/<package>/` |
| `user_de_data` | `/data/user_de/0/<package>/` |
| `android_data` | External `Android/data/` |
| `android_obb` | External `Android/obb/` |

**Custom columns:**
- `COLUMN_MT_PATH = "mt_path"` — raw filesystem path
- `COLUMN_MT_EXTRAS = "mt_extras"` — additional metadata

**Custom call methods (MT extensions):**
- `mt:createSymlink` — create filesystem symlinks
- `mt:setLastModified` — set file modification time
- `mt:setPermissions` — set file permissions (chmod)

> This provider gives file managers (e.g. MT Manager) full read/write access to the app's internal data directories, including symlink creation and permission changes via the `callMethod` API.

---

## 13. Playtime System (`PlaytimeHelper`)

**Database 1 — user identity:**
- **Database:** `xj_steam_db` (SQLite, via `context.getDatabasePath()`)
- **Query:** `SELECT id FROM steam_account WHERE is_current_user = 1 LIMIT 1`
- Returns current Steam user's numeric ID

**Database 2 — actual playtime records:**
- **Database:** `xj_steam_pics_v5` (SQLite, via `context.getDatabasePath()`)
- **Table:** `t_steam_user_pics_app_last_played_times`
- **Query:** `SELECT * FROM t_steam_user_pics_app_last_played_times WHERE steam_id = ? AND app_id = ?`
- **Columns:** `app_id`, `playtime_forever` (minutes), `playtime_2weeks` (minutes)

**Entity class:** `com.xj.game.entity.RecentGameEntity`
- Resolved via reflection from host app class hierarchy
- **Obfuscated fields:** `a` = steamAppId (String), `d` = totalSeconds (long), `e` = last14Days (long)
- **Reflection map:** `steamAppId` → field `a`; `totalSeconds` → field `d`; `last14Days` → field `e`

**Unit mismatch note:** The `t_steam_user_pics_app_last_played_times` table stores minutes; `RecentGameEntity` exposes totalSeconds. PlaytimeHelper performs the ×60 conversion internally.

---

## 14. Logcat Tag Reference (GHLog enum)

| Tag | Full Logcat Tag |
|---|---|
| `TOKEN` | `GHL/Token` |
| `PREFS` | `GHL/Prefs` |
| `BATTERY` | `GHL/Battery` |
| `GAME_ID` | `GHL/GameId` |
| `CURRENCY` | `GHL/Currency` |
| `COMPAT` | `GHL/Compat` |
| `FILE_MGR` | `GHL/FileMgr` |
| `STORAGE` | `GHL/Storage` |
| `NET` | `GHL/Net` |
| `CDN` | `GHL/CDN` |
| `CPU` | `GHL/CPU` |
| `PERF` | `GHL/Perf` |
| `PLAYTIME` | `GHL/Playtime` |

**Filter all BH logs:** `adb logcat -s "GHL/Token:D" "GHL/Prefs:D" "GHL/Net:D" "GHL/Storage:D"`

---

## 15. Native Libraries (arm64-v8a)

| Library | Size | Role |
|---|---|---|
| `libffmpeg-org.so` | 18 MB | Full FFmpeg — video decode/encode for recording + streaming |
| `libjingle_peerconnection_so.so` | 8.9 MB | WebRTC peer-to-peer for PC streaming |
| `libijkffmpeg.so` | 6.0 MB | IJKPlayer FFmpeg — RTMP/HLS video player |
| `libmitm.so` | 5.5 MB | MITM proxy — SSL inspection for Steam/store APIs |
| `libstreaming-core.so` | 3.8 MB | PC game streaming core |
| `libxjps-jni.so` | 3.8 MB | XiaoJi PS input JNI bridge |
| `libxserver.so` | 3.8 MB | X server display bridge |
| `libijkplayer.so` | 533 KB | IJKPlayer Android bridge |
| `libijksdl.so` | 355 KB | IJKPlayer SDL layer |
| `libavutil-55.so` | 358 KB | FFmpeg AV utilities |
| `libswscale-4.so` | 342 KB | FFmpeg scale/colorspace |
| `libgpuinfo.so` | 334 KB | GPU hardware info |
| `libzstd-jni-1.5.7-4.so` | 590 KB | Zstandard compression (component archives) |
| `libwinemu.so` | 580 KB | Wine emulator Android bridge |
| `libvfs.so` | 1.1 MB | Virtual filesystem (sandbox overlay) |
| `libmmkv.so` | 701 KB | MMKV fast key-value storage (settings) |
| `libjutils.so` | 1.7 MB | JNI utilities |
| `libadb.so` | 89 KB | ADB protocol implementation |
| `libffmpeg-command.so` | 483 KB | FFmpeg command-line wrapper |
| `libblur-lib.so` | 9.8 KB | Background blur effect |
| `libGamesir.so` | 27 KB | GameSir BLE controller SDK |
| `libimage_processing_util_jni.so` | 29 KB | Image processing JNI |
| `libimagescale.so` | 54 KB | Image scaling |
| `libandroidx.graphics.path.so` | 9.9 KB | AndroidX graphics path |
| `libdatastore_shared_counter.so` | 7.0 KB | DataStore counter |
| `libsurface_util_jni.so` | 4.8 KB | Surface utility JNI |
| `liblog.so` | 65 KB | Logging utility |

---

## 16. Assets

| Asset | Purpose |
|---|---|
| `aria_config.xml` | Aria2-based download manager configuration |
| `auth_intro_timberline.webm` | Auth screen intro animation (WebM video) |
| `auth_loop_timberline.webm` | Auth screen loop animation (WebM video) |
| `better-xcloud.user.js` | better-xcloud userscript — injects Xbox Cloud Gaming enhancements into the embedded WebView |
| `inject_1.xj`, `inject_2.xj`, `inject_3.xj` | XiaoJi injection config bundles (WCP format) |
| `inputcontrols/` | Virtual gamepad overlay layout files |
| `steam_input/` | Steam Input configuration files (controller glyphs, bindings) |
| `libwbsafeedit_64` | Safe edit native lib (ARM64, no `.so` extension) |
| `libwbsafeedit_x86` | Safe edit native lib (x86) |
| `libwbsafeedit_x86_64` | Safe edit native lib (x86_64) |
| `NotoColorEmojiCompat.ttf` | Noto Color Emoji font for EmojiCompat |
| `splash_video.mp4` | Launch splash screen video |
| `fonts/AlimamaShuHeiTi-Bold.ttf` | Alibaba Ma Ma Shu Hei Ti bold (Chinese UI font) |
| `dexopt/baseline.prof` | ART baseline profile — startup method list |
| `dexopt/baseline.profm` | ART baseline profile metadata |

---

## 17. USB Gamepad Allowlist (`res/xml/device_filter.xml`)

| Vendor ID | Product ID | Device |
|---|---|---|
| 1356 (Sony) | 3302 | DualShock 4 USB wireless adapter |
| 13623 (GameSir) | 264 | GameSir controller |
| 13623 (GameSir) | 4374 | GameSir controller |
| 13623 (GameSir) | 4408 | GameSir controller |
| 13623 (GameSir) | 274 | GameSir controller |

---

## 18. OAuth Login Flows

### Epic Login (`EpicLoginActivity`)

| Constant | Value |
|---|---|
| `AUTH_URL` | `https://www.epicgames.com/id/login?redirectUrl=https%3A%2F%2Fwww.epicgames.com%2Fid%2Fapi%2Fredirect%3FclientId%3D34a02cf8f4414e29b15921876da36f9a%26responseType%3Dcode` |
| `REDIRECT_HOST` | `https://www.epicgames.com/id/api/redirect` |
| `CLIENT_ID` | `34a02cf8f4414e29b15921876da36f9a` |
| `CLIENT_SECRET` | `daafbccc737745039dffe53d94fc76cf` |
| `TOKEN_URL` | `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token` |
| `EXCHANGE_URL` | `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange` |
| `USER_AGENT` | `UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit` |

Flow: WebView → authorization code → `exchangeCode()` → `postToken()` → `EpicCredentialStore.save()`

Grant types used: `authorization_code`, `refresh_token` (both with `token_type=eg1`)

### GOG Login (`GogLoginActivity`)

| Constant | Value |
|---|---|
| `AUTH_URL` | `https://auth.gog.com/auth?client_id=46899977096215655&redirect_uri=https%3A%2F%2Fembed.gog.com%2Fon_login_success%3Forigin%3Dclient&response_type=token&layout=client2` |
| WebView UA | `Mozilla/5.0 (Windows NT 10.0; Win64; x64) GOG Galaxy/2.0` |
| Token refresh base | `https://auth.gog.com/token?client_id=46899977096215655&client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9&grant_type=refresh_token&refresh_token=` |

Flow: WebView → fragment-based implicit token → `handleImplicitRedirect()` → saves to `bh_gog_prefs`

`bh_gog_prefs` full key set:
- `access_token` (String)
- `refresh_token` (String)
- `user_id` (String — from OAuth fragment)
- `username` (String — fetched from GOG API)
- `bh_gog_login_time` (int — unix seconds)
- `bh_gog_expires_in` (int — default 3600)
- `pending_gog_exe` (String — launch handoff key)
- `gog_client_secret_<clientId>` (String — per-game OAuth client secret cache)
- `last_modified` (String — cloud sync marker)

### Amazon Login (`AmazonLoginActivity`)

| Constant | Value |
|---|---|
| Login URL | `https://www.amazon.com/ap/signin?...&openid.assoc_handle=amzn_sonic_games_launcher&pageId=amzn_sonic_games_launcher...` |
| WebView UA | `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0` |
| `DEVICE_TYPE` | `A2UMVHOX7UP4V7` |
| `APP_NAME` | `AGSLauncher for Windows` |
| `APP_VERSION` | `1.0.0` |
| `OS_VERSION` | `10.0.19044.0` |
| `REGISTER_URL` | `https://api.amazon.com/auth/register` |
| `REFRESH_URL` | `https://api.amazon.com/auth/token` |
| `DEREGISTER_URL` | `https://api.amazon.com/auth/deregister` |

Flow: WebView PKCE → `openid.oa2.authorization_code` captured → `AmazonAuthClient.registerDevice()` → `AmazonCredentialStore.save()` (to JSON file)

---

## 19. Per-Game Settings Keys (`BhGameConfigsActivity`)

SharedPreferences name: `"pc_g_setting" + gameId`

| Key | Type | Role |
|---|---|---|
| `pc_g_setting` | (prefix) | Per-game settings root namespace |
| `pc_ls_boot_option` | String | Boot/launch option selection |
| `pc_ls_CONTAINER_LIST` | String | Container list selection |
| `pc_ls_DXVK` | String | DXVK component selection |
| `pc_ls_environment_variable` | String | Environment variable overrides |
| `pc_ls_GPU_DRIVER_` | String (JSON) | GPU driver component — stored as JSON with `name`+`displayName` fields |
| `pc_ls_VK3k` | String | VkD3D-Proton component selection |
| `pc_ls_steam_client` | String | Steam client component selection |
| `pc_set_constant_94` | varies | Component type 94 setting |
| `pc_set_constant_95` | varies | Component type 95 setting |
| `pc_s_resolution_h` | String | Resolution height override |
| `pc_s_resolution_w` | String | Resolution width override |

---

## 20. Config Export JSON Schema (`BhSettingsExporter`)

**Export filename format:** `<gameName>-<manufacturer>-<model>-<soc>-<unixTimestamp>.json`
(all components sanitized to `[a-zA-Z0-9_-]`)

**JSON structure:**
```json
{
  "meta": {
    "app_source": "bannerhub",
    "device": "<MANUFACTURER> <MODEL>",
    "soc": "<detectSoc() result>",
    "bh_version": "3.5.0",
    "upload_token": "<random hex>",
    "settings_count": <int>,
    "components_count": <int>
  },
  "settings": { "<all pc_g_setting<id> keys>": "<values>" },
  "components": [ { "name": "...", "url": "...", "type": "..." }, ... ]
}
```

**Upload payload to `/upload` endpoint:**
```json
{
  "game": "<gameName>",
  "filename": "<filename.json>",
  "content": "<base64 encoded full JSON>",
  "upload_token": "<hex token>"
}
```

**Upload tracking:** `bh_config_uploads` prefs — key=sha, value = `{ sha, game, filename, date, token }`

---

## 21. Cloud Save System

### Epic Cloud Save

| Constant | Value |
|---|---|
| `BASE` | `https://datastorage-public-service-liveegs.live.use1a.on.epicgames.com/api/v1/access/egstore/savesync/` |
| Debug file | `Environment.getExternalStorageDirectory()/bh_cloud_debug.txt` (append mode) |
| Thread prefix | `"epic-cloud-upload-"`, `"epic-cloud-download-"` |

Upload flow: list cloud files → compare last_modified → request write links → PUT to presigned URLs
Download flow: list cloud files → download each → write to `file` dir passed by caller

### GOG Cloud Save

| Constant | Value |
|---|---|
| `BASE` | `https://cloudstorage.gog.com/v1/` |
| Thread prefix | `"gog-cloud-upload-"`, `"gog-cloud-download-"` |
| Prefs | `bh_gog_prefs` → `user_id`, `access_token`, `refresh_token` |

Uses game-scoped OAuth token (fetches from `https://auth.gog.com/token` with game's `client_id` + `client_secret`)

---

## 22. GOG Download System

| API URL | Purpose |
|---|---|
| `https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=2` | Gen2 build manifest |
| `https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=1` | Gen1 build manifest (fallback) |
| `https://api.gog.com/products/{gameId}?expand=downloads` | Installer download links (fallback) |
| `https://www.gog.com` | Base URL for redirect resolution |

**Download strategy:** try Gen2 → try Gen1 → fallback to installer download

**Per-game OAuth credential cache (in `bh_gog_prefs`):**
- `gog_client_id_<gameId>` — cached OAuth client_id for that game
- `gog_client_secret_<gameId>` — cached OAuth client_secret for that game
- `gog_exe_<gameId>` — stored executable path for that game
- `gog_dir_<gameId>` — stored install directory for that game

Populated by `getOrFetchClientId(gameId)` which fetches product endpoint if not cached.

**Debug log:** appended to `context.getExternalFilesDir(null)/bh_gog_debug.txt`

---

## 23. Epic Download System (`EpicDownloadManager`)

| Constant | Value |
|---|---|
| `UA` | `UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit` |
| Default chunk dir | `ChunksV4` |
| Chunk path format | `<groupNum02d>/<hash016X>_<guid8x8x8x8x>.chunk` |

**Download objects:** `CdnUrl` (baseUrl, cloudDir, authParams), `ChunkInfo` (guid[4], hash, groupNum, fileSize, windowSize), `ChunkPart` (guid[4], offset, size), `FileInfo` (filename, parts[])

---

## 24. Amazon Download System (`AmazonDownloadManager` + `AmazonApiClient`)

| Constant | Value |
|---|---|
| `MAX_PARALLEL` | 8 |
| `MAX_RETRIES` | 3 |
| `PROGRESS_INTERVAL` | 524,288 bytes (512 KB) |
| `DOWNLOAD_USER_AGENT` | `nile/0.1 Amazon` |
| `GAMING_USER_AGENT` | `com.amazon.agslauncher.win/3.0.9202.1` |
| Complete marker | `.amazon_download_complete` |
| In-progress marker | `.amazon_download_in_progress` |
| `ENTITLEMENTS_URL` | `https://gaming.amazon.com/api/entitlements` |
| `DISTRIBUTION_URL` | `https://gaming.amazon.com/api/distribution/v2/public` |
| `SDK_CHANNEL_URL` | `https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346` |
| `KEY_ID` | `d5dc8b8b-86c8-4fc4-ae93-18c0def5314d` |

**Amazon API auth header:** `x-amzn-token: <device_token>` — added to all authenticated POST requests

**Amazon manifest format:** binary proto-like — ManifestFile (path, size, hashAlgorithm, hashBytes), ManifestPackage (name, files[]), ParsedManifest (packages, allFiles, totalInstallSize)

**Amazon SDK install dirs** (all under `context.getFilesDir()`):
- `amazon_sdk/` — SDK root
- `amazon_sdk/Amazon Games Services/` — service DLLs
- `amazon_sdk/AmazonGamesSDK/` — SDK DLLs
- `amazon_sdk/Legacy/` — legacy DLLs

---

## 25. SteamCdnHelper — Art Image CDN

| Constant | Value |
|---|---|
| `STORE_API_URL` | `https://api.steampowered.com/IStoreBrowseService/GetItems/v1/` |
| `CDN_FALLBACK_BASE` | `https://shared.steamstatic.com/store_item_assets/` |
| `BIGEYES_CDN_BASE` | `https://cdn-library-logo-global.bigeyes.com/` |
| `CACHE_TTL_MS` | 604,800,000 ms (7 days) |
| `BATCH_SIZE` | 50 app IDs per API call |
| `BATCH_DELAY_MS` | 150 ms |
| Prefs name | `"steam_cdn_cache"` |
| L1 cache | `ConcurrentHashMap<Integer, String>` (in-memory) |
| L2 prefs keys | `"url_<appId>"` (String), `"exp_<appId>"` (long — expiry ms) |

Fallback URL format: `https://shared.steamstatic.com/store_item_assets/steam/apps/<appId>/header.jpg`
Thread: daemon thread named `"steam-cdn"` via `ScheduledExecutorService`

---

## 26. DeviceMetrics — GPU Sysfs Path Resolution

Resolution order (first readable file wins):

| Path | SoC | Format |
|---|---|---|
| `/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage` | Qualcomm (primary) | percentage (0–100) |
| `/sys/class/kgsl/kgsl-3d0/gpubusy` | Qualcomm (alt) | `busy total` pair |
| `/sys/kernel/gpu/gpu_load` | Samsung | percentage |
| `/sys/class/mpgpu/utilization` | MediaTek | percentage |
| `/sys/devices/platform/*/gpu/<node>` | Mali | percentage (scan) |

CPU usage: `Process.getElapsedCpuTime()` delta / wall time delta, cached 500ms

---

## 27. Component Type System (`BhComponentAdapter`)

| Type Name | Badge Color (ARGB) | Detection |
|---|---|---|
| `DXVK` | -11694081 (`#FF4A30FF` approx) | filename contains "dxvk" |
| `VKD3D` | -6596170 | filename contains "vkd3d" |
| `Box64` | -12078513 | filename contains "box64" |
| `FEX` | -1671646 | filename contains "fex" |
| `GPU` | -999104 | filename contains turnip/vulkan/adreno/driver/gpu |
| `WCP` | -7827815 (default) | all other filenames |

Prefs: `"banners_sources"` → `"<name>:type"` (String, manual type override), `"<name>"` (String, display label)
Swipe gestures: swipe-left (direction 4) = remove, swipe-right = backup

**EmuComponents SharedPreferences:** `"sp_winemu_all_components12"`

---

## 28. WCP / XiaoJi Component Archive Format (`WcpExtractor`)

Magic byte detection order:
| Magic bytes | Format | Extraction |
|---|---|---|
| `50 4B` (PK) | ZIP | Standard `ZipInputStream` |
| `28 B5 2F FD` | Zstd | `ZstdInputStreamNoFinalizer` + TAR |
| `FD 37 7A 58` | XZ | `XZInputStream` + TAR (limit=-1) |

Content: TAR entries, directories and `profile.json` entries are skipped. 
Pre-extraction: `clearDir(destDir)` — full wipe of destination before extracting.

---

## 29. Network Security Configuration

**`res/xml/network_security_config.xml`:**
- `cleartextTrafficPermitted="true"` — HTTP allowed for all domains
- User certificate trust: `overridePins="true"` — user-installed CA certs bypass pinning in **both** release AND debug builds
- **Implication:** MITM proxying with a user-installed CA (e.g. Burp Suite, Charles) works out of the box in production, no debug build needed.

---

## 30. PC Streaming Preferences (`res/xml/preferences.xml`)

Belongs to the PC streaming module. Preference keys:

| Key | Default | Type |
|---|---|---|
| `list_resolution` | `1280x720` | ListPreference |
| `list_fps` | `60` | ListPreference |
| `seekbar_bitrate_kbps` | — | SeekBar (max 150000) |
| `frame_pacing` | `latency` | ListPreference |
| `checkbox_stretch_video` | false | CheckBox |
| `list_audio_config` | `2` | ListPreference |
| `checkbox_enable_audiofx` | false | CheckBox |
| `seekbar_deadzone` | 7 | SeekBar (max 20) |
| `checkbox_multi_controller` | true | CheckBox |
| `checkbox_usb_driver` | true | CheckBox (XB1 driver) |
| `checkbox_usb_bind_all` | false | CheckBox |
| `checkbox_mouse_emulation` | true | CheckBox |
| `analog_scrolling` | `right` | ListPreference (depends on mouse_emulation) |
| `checkbox_vibrate_fallback` | false | CheckBox |
| `seekbar_vibrate_fallback_strength` | 100 | SeekBar (max 200) |
| `checkbox_flip_face_buttons` | false | CheckBox |
| `checkbox_gamepad_touchpad_as_mouse` | false | CheckBox |
| `checkbox_gamepad_motion_sensors` | true | CheckBox |
| `checkbox_gamepad_motion_fallback` | false | CheckBox |
| `checkbox_touchscreen_trackpad` | true | CheckBox |

---

## 31. GameMode Configuration (`res/xml/game_mode_config.xml`)

```xml
supportsPerformanceGameMode="true"
supportsBatteryGameMode="false"
allowGameDownscaling="true"
allowGameFpsOverride="true"
```

---

## 32. Left Menu Injection (`HomeLeftMenuDialog`)

BannerHub activities wired into the launcher's left slide-out menu:

| Menu Item | Launches |
|---|---|
| GOG | `GogMainActivity` |
| Amazon | `AmazonMainActivity` |
| Epic | `EpicMainActivity` |
| BannerHub Config | `BhGameConfigsActivity` |

**ShowMenuMonitor:** keyboard code `108` (KEYCODE_MENU) triggers `HomeLeftMenuDialog` on compatible `FragmentActivity` subclasses.

---

## 33. GameHubPrefs Content Type Constants

Used to identify UI setting rows in the launcher's settings injector:

| Constant | Value | Purpose |
|---|---|---|
| `CONTENT_TYPE_SD_CARD_STORAGE` | 24 | SD card storage toggle |
| `CONTENT_TYPE_API` | 26 | API source selector |
| `CONTENT_TYPE_LOG_REQUESTS` | 27 | Log all requests toggle |
| `CONTENT_TYPE_CPU_USAGE` | 28 | CPU usage display toggle |
| `CONTENT_TYPE_PERF_METRICS` | 29 | Performance metrics display toggle |

---

## 34. TokenProvider — Host App Token Access

`getCurrentAppToken()` reads the host app's auth token via reflection:
```java
Class.forName("com.xj.common.user.UserManager")
    .getMethod("getToken")
    .invoke(cls.getField("INSTANCE").get(null))
```
This is a Kotlin `object` (singleton) — `INSTANCE` is the companion object field.

---

## 35. Key Injection Points for Future Patching

| Target | Location | Notes |
|---|---|---|
| API source default | `GameHubPrefs.getApiSource()` — returns `getPrefs().getInt("api_source", 0)` | Change default from `0` to `1` or `2` to boot into BH/EmuReady API |
| Token bypass flags | `TokenProvider.apiSwitchPatched` and `loginBypassed` — both static `true` | Already patched — preserve in future builds |
| GOG launch method | `GogLaunchHelper.checkPendingLaunch()` → `activity.B3(exe)` via reflection | If host renames `B3`, this breaks silently — add fallback method name list |
| Component injection | `ComponentInjectorHelper.appendLocalComponents(list, type)` — type 32 = graphics drivers | Add new type IDs here to expose new component categories |
| WCP extractor | `ComponentInjectorHelper.extractWcp()` — skips `profile.json` | Insert custom post-extraction hook here for asset patching |
| Storage override | `BhStoragePath.getStoreBase()` — check `"use_custom_storage"` key | SD card path injection point |
| BH version string | `BhSettingsExporter.BH_VERSION = "3.5.0"` | Bump on version increments |
| Config worker URL | `BhSettingsExporter.WORKER_BASE` | Replace for custom config backend |

---

## 36. SoC Detection (`detectSoc`)

3-step fallback resolution order:

| Step | Source | Method |
|---|---|---|
| 1 | `device_info` SharedPreferences | `getPrefs().getString("device_info", null)` |
| 2 | Kernel sysfs | Read `/sys/class/kgsl/kgsl-3d0/gpu_model` |
| 3 | Build properties | `Build.SOC_MODEL` (Android 12+) → `Build.HARDWARE` (fallback) |

Returns the first non-null, non-empty result. Used in export filename and config JSON `meta.soc` field.

---

## 37. Community Config Worker — Full API Endpoint Map

Base URL: `https://bannerhub-configs-worker.the412banner.workers.dev`

| Endpoint | Method | Purpose |
|---|---|---|
| `/upload` | POST | Upload a config JSON (body: `{game, filename, content (base64), upload_token}`) |
| `/list` | GET | List configs for a game: `?game=<gameName>` → JSON array |
| `/download` | GET | Download a specific config: `?filename=<name>` → config JSON |
| `/games` | GET | List all games that have configs |
| `/vote` | POST | Vote on a config (upvote/downvote) |
| `/report` | POST | Report a config for abuse |
| `/comment` | POST | Post a comment on a config |
| `/comments` | GET | Fetch comments for a config |
| `/delete` | POST | Delete own config (requires upload_token) |
| `/desc` | POST | Set/update description for a config |
| `/describe` | GET | Get description/metadata for a config |

Upload tracking stored in `bh_config_uploads` prefs: key = SHA, value = `{ sha, game, filename, date, token }`

---

## 38. `banners_sources` SharedPreferences Key Schema

`banners_sources` is the central component registry. Key patterns:

| Key Pattern | Value | Purpose |
|---|---|---|
| `<componentName>` | `"BannerHub"` | Marks this component as BH-sourced |
| `<componentName>:type` | type string (e.g. `"DXVK"`) | Component category |
| `url_for:<componentName>` | download URL string | Original download URL |
| `dl:<url>` | `"1"` | Marks URL as already downloaded |

Written by `ComponentInjectorHelper.injectAndRegister()`. Read by `buildComponentsArray()` to reconstruct component list for export.

---

## 39. GameHubPrefs — Full Cache Clear and Component Base URL

**`clearComponentAndTokenCaches()`** clears all of:
- `sp_winemu_all_components12` — component list cache
- `sp_winemu_all_containers` — container list cache
- `sp_winemu_all_imageFs` — image filesystem cache
- `pc_g_setting` — per-game settings cache
- `net_cookies` — HTTP cookie cache
- `TokenProvider` in-memory cache
- `CompatibilityCache` in-memory map
- `context.getCacheDir()` — disk cache dir

Triggered on API source switch to prevent stale data from old API bleeding into new API view.

**`getComponentBaseUrl()`** routes to three endpoints based on `api_source`:
| `api_source` | Label | URL |
|---|---|---|
| `0` | Official | passed-through from caller (XiaoJi official server) |
| `1` | EmuReady | `https://gamehub-lite-api.emuready.workers.dev/` |
| `2` | BannerHub | `https://bannerhub-api.the412banner.workers.dev/` |

**`cycleApiSource()`** cycles `(current + 1) % 3` and shows a Toast on each switch.  
**`EMUREADY_URL`** = `https://gamehub-lite-api.emuready.workers.dev/`  
**`BANNERHUB_URL`** = `https://bannerhub-api.the412banner.workers.dev/`

---

## 40. BhDownloadService — Unified Download Manager

**Service declaration:** `foregroundServiceType="dataSync"`, NOT exported (internal use only)

**Intent actions:**
- `bh.download.START` — begin a download (extras depend on store type)
- `bh.download.CANCEL` — cancel an active download job

**Store type identifier (`EXTRA_STORE`):** string values `"GOG"`, `"EPIC"`, `"AMAZON"`

**Shared intent extras:**
- `game_id` — local game identifier
- `game_name` — display title

**GOG-specific extras:** `gog_gid`, `gog_title`, `gog_gen` (generation), `gog_cat`, `gog_dev`, `gog_img`

**Epic-specific extras:** `epic_app` (appName), `epic_ns` (namespace), `epic_cat` (catalogItemId)

**Amazon-specific extras:** `amz_pid` (productId), `amz_eid` (entitlementId), `amz_sku` (productSku), `amz_title`

**`bh_library` SharedPreferences — installed game registry:**
- Key: `dlKey` (unique download key)
- Value: `name + "\n" + store + "\n" + installPath` (3 fields, newline-separated)
- `LibraryEntry { dlKey, name, store, installPath }`

**Per-store install path prefs (separate SharedPreferences):**
| Prefs | Key | Value |
|---|---|---|
| `bh_epic_prefs` | `epic_dir_<appName>` | Epic install dir |
| `bh_epic_prefs` | `epic_exe_<appName>` | Epic executable path |
| `bh_epic_prefs` | `epic_manifest_version_<appName>` | Epic manifest version string |
| `bh_gog_prefs` | `gog_dir_<gameId>` | GOG install dir |
| `bh_gog_prefs` | `gog_exe_<gameId>` | GOG executable path |
| `bh_amazon_prefs` | `amazon_dir_<productId>` | Amazon install dir |
| `bh_amazon_prefs` | `amazon_exe_<productId>` | Amazon executable path |
| `bh_amazon_prefs` | `pending_amazon_exe` | Amazon launch handoff (current game exe) |

**GlobalListener interface:** `onAnyProgress(dlKey, name, statusMsg, pct)`, `onAnyComplete(dlKey, installPath)`

---

## 41. Per-Store Credential Stores

### Epic Credentials (`EpicCredentialStore`)
- **Prefs:** `bh_epic_prefs`
- **Keys:** `access_token`, `refresh_token`, `account_id`, `display_name`, `expires_at` (long ms)
- **Auto-refresh:** if `expiresAt - now < 300_000` ms (5 min) and refresh_token present → `EpicAuthClient.refreshToken()`

### Amazon Credentials (`AmazonCredentialStore`)
- **File:** `filesDir/amazon/credentials.json`
- **JSON keys:** `access_token`, `refresh_token`, `device_serial`, `client_id`, `expires_at` (long ms)
- **Auto-refresh:** if `expiresAt - now < 300_000` ms → `AmazonAuthClient.refreshAccessToken()`
- All Amazon credentials are file-based (not SharedPreferences — unlike GOG and Epic)

---

## 42. BhStoragePath — Full Path Resolution Logic

**Prefs name:** `steam_storage_pref`
- `use_custom_storage` (boolean)
- `steam_storage_path` (String — custom root path)

**Path formula:**
- If `use_custom_storage` = false: `filesDir/<storeDir>/<gameName>`
- If `use_custom_storage` = true: `<custom_path>/bannerhub/<storeDir>/<gameName>`

**Known storeDir values:**
- `gog_games` — GOG game installs (via `GogInstallPath.getInstallDir()`)
- `epic_games` — Epic game installs (via `EpicGamesActivity`: `BhStoragePath.getInstallDir(ctx, "epic_games", gameName)`)
- `Amazon` — Amazon game installs (via `AmazonGamesActivity`: `BhStoragePath.getInstallDir(ctx, "Amazon", gameName)`)
- GPU components: `usr/home/components` (via `ComponentInjectorHelper`)

**StorageBroadcastReceiver** (programmatically registered, package `app.revanced.extension.gamehub.steam`):
- `<packageName>.SET_STEAM_STORAGE` intent → `"path"` extra → sets custom storage path and enables it
- `<packageName>.USE_INTERNAL_STORAGE` intent → forces back to internal filesDir

---

## 43. Epic API Client — Library and Catalog Endpoints

| Constant | Value |
|---|---|
| `LIBRARY_URL` | `https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true` |
| `CATALOG_BASE` | `https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace` |
| `MANIFEST_BASE` | `https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace` |
| `LEGENDARY_UA` | `Legendary/0.1.0 (GameNative)` |

**Library filter:** skips namespace `"ue"` (Unreal Engine), `"89efe5924d3d467c839449ab6ab52e7f"`, sandboxType `"PRIVATE"`. Accepts only Windows/Win32 platform entries.

**Manifest URL format:** `{MANIFEST_BASE}/{namespace}/catalogItem/{catalogItemId}/app/{appName}/label/Live`

**Free Games endpoint:** `https://store-site-backend-static-ipv4.ak.epicgames.com/freeGamesPromotions?locale=en-US&country=US&allowCountries=US`

---

## 44. SteamGridDB Integration (`GogGamesActivity`)

Used to fetch artwork for GOG library and Epic library screens:

| Constant | Value |
|---|---|
| `SGDB_KEY` | `cf89227f12c773bb1117b6b109ae1659` |
| Search endpoint | `https://www.steamgriddb.com/api/v2/search/autocomplete/<name>` |
| Grid endpoint | `https://www.steamgriddb.com/api/v2/grids/game/<id>?dimensions=600x900&mimes=image/jpeg,image/png&limit=1` |

GOG library cache: `gog_library_cache` (SharedPreferences key)

---

## 45. Assets — Inject Files and Controller Profiles

**XiaoJi injection bootstrap (`com.xiaoji.inject` package):**

All three inject files use **byte-reversal obfuscation**: raw file bytes are reversed before storage in the APK. `InjectActivationUtils.n()` calls `ArraysKt.j1(bytes)` (reverse) before writing the decoded output.

Mapping: `inject_*.xj` → reversed → decoded output filename:
| Asset | Decoded Filename | Size | Content |
|-------|-----------------|------|---------|
| `inject_1.xj` | `xiaoji.bash` | 1.1 KB | Shell script that launches XiaojiInjectServer via `app_process` |
| `inject_2.xj` | `xjServer.jar` | ~174 KB | Java component of XiaojiInjectServer |
| `inject_3.xj` | `xjServer_a` | ~1.13 MB | Native ARM64 binary of XiaojiInjectServer |

After decode, `v()` performs **package name substitution** in `xiaoji.bash`:
- `"package_name"` placeholder → actual package name (`com.tencent.ig`)
- `/.xiaoji` → `/.com.tencent.ig` (hidden working directory)
- `xiaoji_log.txt` → `com.tencent.ig_log.txt` (log filename)

**Actual runtime paths (after package substitution):**
- Hidden working dir: `/data/local/tmp/.com.tencent.ig/`
- Log file: `/data/local/tmp/com.tencent.ig_log.txt`

**File storage during deployment:**
- Encoded (.xj) files: `context.getExternalFilesDir("")/inject_*.xj`
- Decoded files written alongside encoded files (same dir)

**Cloud update mechanism:** `InjectCloudCfgInfo` fetched from `https://clientgsw.vgabc.com/clientapi/` contains per-file MD5s. Before each use, local MD5 is compared to server MD5; if mismatched, files are re-downloaded. Both the encoded .xj file AND the decoded output are verified.

**Input Control Profiles (`assets/inputcontrols/profiles/`):**
| File | ID | Name |
|---|---|---|
| `controls-1.icp` | 1 | Default Controller Layout |
| `controls-2.icp` | 2 | (controller layout variant) |
| `controls-100.icp` | 100 | Cloud Gaming Default Controller Layout |
| `controls-200.icp` | 200 | Default Keyboard and Mouse Layout |

ICP format: JSON with `id`, `name`, `cnName`, `jaName`, `ruName`, `ptName`, `elements[]` (button type + shape objects)

**Steam Input Templates (`assets/steam_input/templates/`):**
50+ VDF template files covering: Android gamepad, Apple gamepad, Generic gamepad, Neptune (Steam Deck), PS3/PS4/PS5, Switch Joy-Con and Pro, Xbox 360, Xbox One — in FPS, joystick, WASD, mouse, flickstick, and gyro variants.

**Better xCloud (`assets/better-xcloud.user.js`):**
- Version `5.7.3` (8,559 lines), MIT license, by redphx
- Matches `https://www.xbox.com/*/play*` and `https://www.xbox.com/*/auth/msa?*loggedIn*`
- Injected into Xbox Cloud Gaming WebView to enhance streaming (bitrate control, input tweaks, etc.)

---

## 46. Key Mapping and Injection Services (Manifest)

| Service | Type | Export | Permission |
|---|---|---|---|
| `com.xj.mapping.MappingService` | `specialUse` | true | none |
| `com.xj.mapping.interaction.KeyboardEditService` | `specialUse` | true | none |
| `com.xj.mapping.interaction.InjectService` | `connectedDevice` | true | `com.xiaoji.egggame.permission.SAFE_ACCESS` |
| `com.xj.mapping.interaction.SSLClientService` | `specialUse` | true | none |
| `com.xj.mapping.interaction.virtualtouchutil.ipc.service.VTouchIPCService` | `specialUse` | true | none |

**`InjectService`** requires the custom `SAFE_ACCESS` permission — external apps must declare this to bind.

---

## 47. PC Streaming Module Activities (Manifest)

All activities under `com.xj.module_pcstream.activity.*`, forced landscape (`sensorLandscape`):
- `PcStreamMainActivity` — main streaming UI
- `PcStreamShareActivity` — share PC stream session
- `PcStreamAddDevIPActivity` — add device by IP address
- `PcStreamQRCodeScanActivity` — QR code scan for device pairing
- `PcStreamSettingActivity` — streaming settings (`adjustUnspecified` orientation)
- `PcStreamAddGameActivity` — add PC game to library (singleTask)
- `PcStreamAddGameSelectPathActivity` — browse path for PC game

Settings handled by `res/xml/preferences.xml` (Section 30).

---

## 48. Component Type Numeric ID Map

Full mapping of internal component type IDs (from `ComponentDownloadActivity.detectType()`):

| Type ID | Category | Detection Rule |
|---|---|---|
| `12` | DXVK | Default (fallback for all non-matching filenames) |
| `13` | VKD3D-Proton | filename contains `"vkd3d"` |
| `94` | Box64 | filename contains `"box64"` |
| `95` | FEXCore | filename contains `"fex"` |
| `10` | GPU Driver/Turnip | filename contains `"turnip"`, `"adreno"`, `"driver"`, or `"qualcomm"` |
| `32` | Graphics Drivers (group) | matches type 10 OR 94 OR 95 in `ComponentInjectorHelper` filter |

**Reference dump:** [`sp_winemu_all_components12_by_type.txt`](sp_winemu_all_components12_by_type.txt) — every component name from the live GameHub 5.3.5 `sp_winemu_all_components12.xml` SharedPreferences cache, grouped by the JSON `"type":N` field (1=FEX/Box64, 2=GPU drivers, 3=DXVK, 4=VKD3D, 5=per-game settings, 6=winetricks-style libs, 7=steam_client).

---

## 49. Component Download Repos (`ComponentDownloadActivity`)

Six pre-configured component sources in the Download Components screen:

| Repo Name | JSON Feed URL |
|---|---|
| Arihany WCPHub | `https://raw.githubusercontent.com/Arihany/WinlatorWCPHub/refs/heads/main/pack.json` |
| Kimchi GPU Drivers | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/kimchi_drivers.json` |
| StevenMXZ GPU Drivers | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/stevenmxz_drivers.json` |
| MTR GPU Drivers | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/mtr_drivers.json` |
| Whitebelyash GPU Drivers | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/white_drivers.json` |
| The412Banner Nightlies | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/nightlies_components.json` |

**Pack JSON format:** array with `browser_download_url` per entry (GitHub releases API format)
**GPU drivers JSON format:** array with `original_url` per entry

---

## 50. Xbox Cloud Gaming (xCloud) — `XboxWebActivity`

**WebView URL:** `https://www.xbox.com/*/play*` (the cloud gaming URL)

**Script injection:** `better-xcloud.user.js` is loaded from assets and injected via `WebViewCompat.addDocumentStartJavaScript()` at `https://*.xbox.com`.

**Runtime patches applied to the script:**
1. Bypass server: if `XGPConfigInfo.region != "off"` → replaces the script's `bypassServer` check to `true` and hardcodes `X-Forwarded-For: <ip>` header
2. Locale: if `XGPConfigInfo.language` is set → replaces `PREF_STREAM_PREFERRED_LOCALE` getter with the static value

**`XGPConfigInfo`** (stored as JSON in `XGP_Config` prefs → key `XGPConfigInfo`):
- `region` — bypass server config JSON blob (`ItemData` JSON string)
- `regionCustom` — custom bypass server IP string
- `language` — stream locale string (default: `"default"`)

**`ItemData` fields:** `title` (display name), `value` (bypass IP or mode), `index`, `isSelect`, `isCustom`, `isEdit`

**Better-xCloud Xbox API URLs (intercepted/blocked by the script):**

The script intercepts or blocks these Xbox Live backend endpoints as part of its enhancement features:

| URL | Script Action | Purpose |
|---|---|---|
| `https://xhome.gssv-play-prod.xboxlive.com/v2/login/user` | Intercepts + proxies | Xbox xHome Game Streaming session login |
| `https://wus.core.gssv-play-prod.xboxlive.com/...` | Proxies (WUS region) | Xbox Game Streaming WUS region core endpoint |
| `http://gssv.xboxlive.com/` | Token key | Xbox Game Streaming SV token key (from `xboxcom_xbl_user_info`) |
| `https://peoplehub.xboxlive.com/users/me/people/social` | BLOCKED | Xbox social graph (telemetry/social features) |
| `https://peoplehub.xboxlive.com/users/me/people/recommendations` | BLOCKED | Xbox friend recommendations |
| `https://xblmessaging.xboxlive.com/network/xbox/users/me/inbox` | BLOCKED | Xbox messaging inbox |
| `https://emerald.xboxservices.com/xboxcomfd/experimentation` | BLOCKED | Xbox feature flags / A-B experimentation |
| `https://arc.msn.com` | BLOCKED | MSN telemetry endpoint |
| `https://browser.events.data.microsoft.com` | BLOCKED | Microsoft browser events telemetry |
| `https://dc.services.visualstudio.com` | BLOCKED | Visual Studio / Azure App Insights analytics |
| `https://2c06dea3f26c40c69b8456d319791fd0@o427368.ingest.sentry.io` | BLOCKED | Sentry.io error tracking (Xbox web app) |
| `https://displaycatalog.mp.microsoft.com/v7.0/products/lookup?...` | Called directly | Microsoft Store product catalog for Xbox title lookup |
| `https://www.trueachievements.com` | Optional fetch | Achievement info (TrueAchievements.com integration) |

---

## 51. Full `pc_*` SharedPreferences Key Map (`PcGameSettingDataHelper`)

All keys stored in `pc_g_setting<gameId>` SharedPreferences. Fallback pattern for unmapped types: `"pc_set_constant_" + typeId`.

| ContentType ID | Pref Key | Notes |
|---|---|---|
| 1 (LANGUAGE) | `pc_ls_lan` | |
| 2 (GAME_RESOLUTION) | `pc_resolution_l_s<gameId>` | Combined resolution preset |
| 3 (HUB_TYPE) | `pc_ls_hub_type` | |
| 5 (BOOT_OPTION) | `pc_ls_boot_option` | |
| 6 (ENVIRONMENT_VARIABLE) | `pc_ls_environment_variable` | Env var overrides |
| 8 (CONTAINER_LIST) | `pc_ls_CONTAINER_LIST` | |
| 10 (GPU_DRIVER) | `pc_ls_GPU_DRIVER_` | JSON: `{name, displayName}` |
| 11 (AUDIO_DRIVER) | `pc_ls_AUDIO_DRIVER` | |
| 12 (DXVK) | `pc_ls_DXVK` | |
| 13 (VKD3D) | `pc_ls_VK3k` | |
| 15 (ENABLE_DINPUT) | `pc_ls_update_enable_dinput` | |
| 16 (ENABLE_XINPUT) | `pc_ls_update_enable_xinput` | |
| 17 (XBOX_LAYOUT) | `pc_ls_update_xbox_layout` | |
| 18 (OPEN_VIBRATION) | `pc_ls_open_vibration` | |
| 19–30 (TP_* flags) | `pc_ls_TP_<NAME>` | Translation pipeline flags |
| 31 (IMAGEFS) | `pc_ls_imagefs` | |
| 32 (TRANSLATOR) | `pc_ls_TRANSLATOR` | CPU translation layer |
| 34 (DEPENDENCY_MGMT) | `pc_d_yml_manage` | |
| 35 (GAME_MODE) | `pc_ls_game_mode` | |
| 36 (TP_ALIGNED_ATOMICS) | `pc_ls_TP_ALIGNED_ATOMICS` | |
| 37 (TP_WEAK_BARRIER) | `pc_ls_TP_WEAK_BARRIER` | |
| 41 (CONTROLLER_SWITCH) | `Controller_Switch` | |
| 45 (CORE_LIMIT) | `pc_ls_core_limit` | |
| 49 (TP_AVX) | `pc_ls_TP_AVX` | |
| 51 (MAX_MEMORY) | `pc_ls_max_memory` | |
| 54 (STEAM_CLIENT) | `pc_ls_steam_client` | |
| 55 (STEAM_OFFLINE_MODE) | `pc_ls_steam_offline_mode` | |
| 56 (STEAM_SILENT_MODE) | `pc_ls_steam_silent_mode` | |
| 57 (STEAM_SKIP_FILE_CHECK) | `pc_ls_steam_no_verify_file` | |
| 58 (STEAM_ENABLE_CLOUD_SAVES) | `pc_ls_steam_cloud_enable` | |
| (STEAM_INPUT) | `pc_ls_steam_input` | |
| 59 (GAME_RESOLUTION_W) | `pc_s_resolution_w<gameId>` | |
| 60 (GAME_RESOLUTION_H) | `pc_s_resolution_h<gameId>` | |
| 87 (NEW_CUSTOM_TRANS) | `user_new_custom_trans_config_<gameId>` | |
| 88 (APPLYING_BOX_CONFIG) | `pc_ls_TRANSLATOR_CONFIG_APPLYING_BOX<gameId>` | |
| 89 (APPLYING_FEX_CONFIG) | `pc_ls_TRANSLATOR_CONFIG_APPLYING_FEX<gameId>` | |
| 90 (CUSTOM_FEX_CONFIG) | `pc_ls_USER_CUSTOM_TRANSLATOR_CONFIG_FEX<gameId>` | |
| 91 (CUSTOM_BOX_CONFIG) | `pc_ls_USER_CUSTOM_TRANSLATOR_CONFIG_BOX<gameId>` | |
| 92 (SOFT_INPUT_AUTO_SHOW) | `pc_ls_auto_show_soft_input_when_need` | |
| 93 (IMG_QUALITY_PLUGIN_DIS) | `pc_ls_image_quality_plugin_disable` | |
| 94 (TRANSLATOR_BOX/Box64) | `pc_set_constant_94` | BH-specific (fallback pattern) |
| 95 (TRANSLATOR_FEX/FEX) | `pc_set_constant_95` | BH-specific (fallback pattern) |
| `Enable_Key_Mapping` const | `pc_Enable_key_mapping` | |
| any unmapped type | `pc_set_constant_<typeId>` | catch-all |

**Per-game JSON blobs (in `pc_g_setting` prefs):**
- `pc_d_container` — container selection JSON (`PcSettingDataEntity`)
- `pc_d_dxvk` — DXVK selection JSON
- `pc_d_gpu` — GPU driver selection JSON
- `pc_d_translator` — translator selection JSON
- `pc_d_vkd3d` — VKD3D selection JSON

---

## 52. WinEmu Internal File Path Layout (`WinEmuFilePathsConstant`)

Base: `filesDir` (via `PathUtils.getInternalAppFilesPath()`)

| Variable | Path |
|---|---|
| `c` (root) | `filesDir/xj_winemu/` |
| `e` (downloads) | `filesDir/xj_winemu/xj_downloads/` |
| `f` (games DL) | `filesDir/xj_winemu/xj_downloads_games/` |
| `g` (install root) | `filesDir/xj_winemu/xj_install/` |
| `h` (game DL dir) | `filesDir/xj_winemu/xj_downloads_games/game/` |
| `i` (env DL) | `filesDir/xj_winemu/xj_downloads/env/` |
| `j` (component DL) | `filesDir/xj_winemu/xj_downloads/component/` |
| `k` (SD DL) | `filesDir/xj_winemu/xj_downloads/sd/` |
| `l` (game install) | `filesDir/xj_winemu/xj_install/game/` |
| `m` (env install) | `filesDir/xj_winemu/xj_install/env/` |
| `n` (component install) | `filesDir/xj_winemu/xj_install/component/` |

Per-game install dir: `l/<version>/<gameId>` (or `l/<gameId>` if no version)

---

## 53. Steam Game Import Paths (`ImportPcGameConstant`)

| Constant | Path |
|---|---|
| Steam apps subfolder | `/Steam/steamapps` |
| Internal SteamGame | `externalFilesDir/SteamGame/` |
| Downloads SteamGame | `<Downloads>/SteamGame/` |
| Downloads steamapps | `<Downloads>/Steam/steamapps/` |
| Internal steamapps | `filesDir/Steam/steamapps/` |

**App manifest format:** `appmanifest_<appId>.json` stored in `externalFilesDir/SteamGame/`

---

## 54. MitmProxy — Wine SSL Intercept (`libmitm.so`)

**`MitmProxy` JNI interface** (`com.winemu.core.mitm.MitmProxy`):
- `start(port, dnsPort)` — start the proxy
- `stop()` — stop the proxy
- `getPort()` → int — current TLS port
- `getDnsPort()` → int — current DNS port
- `setCertificate(cert: String, key: String)` → boolean — set CA cert + private key
- `setConfig(json: String)` → boolean — load proxy config JSON

**Wine environment variables injected when MITM is enabled:**
- `MITM_ENABLED=1`
- `MITM_TLS_PORT=<port>`
- `MITM_DNS_PORT=<port>`
- `MITM_CA_CERT=<container>/etc/mitm.crt`
- `MITM_CONFIG=<container>/etc/config.mitm.json`

**⚠️ Hardcoded CA certificate + private key embedded in binary:**
- Subject: `CN=Local Root CA, O=Development, OU=Certificate Authority`
- Valid: `2025-06-28` to `3024-10-29`
- Both the full PEM certificate **and full private key** are hardcoded in `MITMController.java` as fallback defaults.
- This means any party with the APK can generate SSL certs signed by this CA and intercept all Wine app TLS traffic.

---

---

## Section 55: GOG Hardcoded OAuth Client Credentials (GogTokenRefresh.java)

**File:** `app/revanced/extension/gamehub/GogTokenRefresh.java`

GOG token refresh URL with hardcoded client_id and client_secret:
```
https://auth.gog.com/token
  ?client_id=46899977096215655
  &client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9
  &grant_type=refresh_token
  &refresh_token=<stored_token>
```

**⚠️ Hard-coded GOG credentials:** `client_id=46899977096215655` / `client_secret=9d85c43b...c4de46d9` embedded in binary.

**SharedPreferences written by `GogTokenRefresh.refresh()`** (prefs name: `bh_gog_prefs`):
| Key | Type | Description |
|-----|------|-------------|
| `access_token` | String | Refreshed access token |
| `refresh_token` | String | Rotated refresh token (if returned) |
| `bh_gog_login_time` | Int | Unix timestamp of last refresh (seconds) |
| `bh_gog_expires_in` | Int | Hardcoded to `3600` regardless of server response |

---

## Section 56: Epic Hardcoded OAuth Client Credentials (EpicAuthClient.java)

**File:** `app/revanced/extension/gamehub/EpicAuthClient.java`

**⚠️ Hard-coded Epic credentials:**
- `CLIENT_ID = "34a02cf8f4414e29b15921876da36f9a"`
- `CLIENT_SECRET = "daafbccc737745039dffe53d94fc76cf"`

**Epic OAuth endpoints:**
- `TOKEN_URL = "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token"`
- `EXCHANGE_URL = "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange"`

**Epic request User-Agent (also used in EpicDownloadManager):**
```
UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit
```

---

## Section 57: Amazon Hardcoded OAuth Constants (AmazonAuthClient + AmazonApiClient)

**File:** `app/revanced/extension/gamehub/AmazonAuthClient.java`

**⚠️ Hard-coded device spoofing constants:**
| Constant | Value |
|----------|-------|
| `APP_NAME` | `AGSLauncher for Windows` |
| `APP_VERSION` | `1.0.0` |
| `DEVICE_TYPE` | `A2UMVHOX7UP4V7` |
| `OS_VERSION` | `10.0.19044.0` |
| `USER_AGENT` | `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0` |

**Amazon Auth API endpoints:**
- `REGISTER_URL = "https://api.amazon.com/auth/register"` — device registration (PKCE → tokens)
- `REFRESH_URL = "https://api.amazon.com/auth/token"` — access token refresh
- `DEREGISTER_URL = "https://api.amazon.com/auth/deregister"` — logout

**File:** `app/revanced/extension/gamehub/AmazonApiClient.java`

**Amazon Gaming API constants:**
| Constant | Value |
|----------|-------|
| `DISTRIBUTION_URL` | `https://gaming.amazon.com/api/distribution/v2/public` |
| `ENTITLEMENTS_URL` | `https://gaming.amazon.com/api/distribution/entitlements` |
| `SDK_CHANNEL_URL` | `https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346` |
| `KEY_ID` | `d5dc8b8b-86c8-4fc4-ae93-18c0def5314d` |
| `GAMING_USER_AGENT` | `com.amazon.agslauncher.win/3.0.9202.1` |
| `DOWNLOAD_USER_AGENT` | `nile/0.1 Amazon` |

**Request authentication header:** `X-Amz-Target: <service_action_string>` + `Content-Encoding: amz-1.0`

**Key service actions used:**
- `com.amazon.animusdistributionservice.entitlement.AnimusEntitlementsService.GetEntitlements`
- `com.amazon.animusdistributionservice.external.AnimusDistributionService.GetGameDownload`
- `com.amazon.animusdistributionservice.external.AnimusDistributionService.GetLiveVersionIds`

---

## Section 58: GOG Download Manager — Gen1/Gen2/Installer Endpoints

**File:** `app/revanced/extension/gamehub/GogDownloadManager.java`

**Download strategy cascade (three-tier fallback):**

1. **Generation 2 (Galaxy CDN, preferred):**
   - Build list: `https://content-system.gog.com/products/<gameId>/os/windows/builds?generation=2`
   - On success: parse chunk manifest → parallel CDN download

2. **Generation 1 (Legacy CDN):**
   - Build list: `https://content-system.gog.com/products/<gameId>/os/windows/builds?generation=1`
   - On success: fetch Galaxy manifest → decompress → extract depot file URLs → parallel download

3. **Installer fallback:**
   - Product info: `https://api.gog.com/products/<gameId>?expand=downloads`
   - Parses `downloads → installers → windows → files → downlink`
   - Resolves GOG redirect chain (prefix `https://www.gog.com` if relative) then streams installer EXE

---

## Section 59: Amazon Download Manager — File Markers and Constants

**File:** `app/revanced/extension/gamehub/AmazonDownloadManager.java`

**Download control markers (files created in game directory):**
| Constant | Value | Purpose |
|----------|-------|---------|
| `COMPLETE_MARKER` | `.amazon_download_complete` | Written when download finishes successfully |
| `IN_PROGRESS_MARKER` | `.amazon_download_in_progress` | Written at start; removed on completion/cancel |
| `MAX_PARALLEL` | `8` | Concurrent file download threads |
| `MAX_RETRIES` | `3` | Per-file retry attempts |
| `PROGRESS_INTERVAL` | `524288` (512 KB) | Bytes between progress callback fires |

**Manifest fetch:** `AmazonApiClient.getBytes(<downloadUrl>/manifest.proto, token)` — protobuf format parsed by `AmazonManifest.parse()`.

---

## Section 60: BhSettingsExporter — Config Export + Upload Flow

**File:** `app/revanced/extension/gamehub/BhSettingsExporter.java`

**Hardcoded version constant:** `BH_VERSION = "3.5.0"`

**Config file format (JSON, 3 top-level keys):**
```json
{
  "meta": {
    "app_source": "bannerhub",
    "device": "<manufacturer> <model>",
    "soc": "<detected SOC>",
    "bh_version": "3.5.0",
    "upload_token": "<random 64-bit hex>",
    "settings_count": <int>,
    "components_count": <int>
  },
  "settings": { "<all keys from pc_g_setting<gameId>>" },
  "components": [
    { "name": "<component name>", "url": "<download URL>", "type": "<type string>" }
  ]
}
```

**Config filename format:**
`<gameName>-<manufacturer>-<model>-<soc>-<unix_timestamp>.json`
(All non-alphanumeric chars replaced with `_`)

**Export directory:** `/sdcard/BannerHub/configs/` (`Environment.getExternalStorageDirectory()/BannerHub/configs`)

**Components array** — keys read from `pc_g_setting<gameId>` SharedPreferences:
| SP Key | Component Type |
|--------|---------------|
| `pc_ls_DXVK` | DXVK |
| `pc_ls_VK3k` | VKD3D-Proton |
| `pc_set_constant_94` | Box64 (TRANSLATOR_BOX) |
| `pc_set_constant_95` | FEXCore (TRANSLATOR_FEX) |
| `pc_ls_GPU_DRIVER_` | GPU driver / Turnip |
| `pc_ls_CONTAINER_LIST` | Container |
| `pc_ls_steam_client` | Steam client |

**Upload flow (POST `/upload`):**
```
POST https://bannerhub-configs-worker.the412banner.workers.dev/upload
Content-Type: application/json

{
  "game": "<gameName>",
  "filename": "<filename>",
  "content": "<base64(JSON)>",
  "upload_token": "<hex>"
}
```
Response: `{ "success": true, "sha": "<githubSHA>" }`

After successful upload, stored in `bh_config_uploads` SP:
- Key: `<sha>`
- Value: `{ "sha": "<sha>", "game": "<gameName>", "filename": "<filename>", "date": "<yyyy-MM-dd>", "token": "<upload_token>" }`

---

## Section 61: BhGameConfigsActivity — Config Browser SharedPreferences + GitHub Sources

**File:** `app/revanced/extension/gamehub/BhGameConfigsActivity.java`

**SharedPreferences used:**
| SP Name | Key Format | Value | Purpose |
|---------|-----------|-------|---------|
| `bh_steam_covers` | `appid:<gameName>` | Steam AppID (String) | Cache Steam header image IDs |
| `bh_config_votes` | `<sha>` | Boolean | Track which configs user has upvoted |
| `bh_config_reports` | `<sha>` | Boolean | Track which configs user has reported |
| `bh_config_uploads` | `<sha>` | JSON string | Track own uploaded configs (with token for delete) |

**Config list entry JSON fields** (from worker `/list` response):
| Field | Type | Description |
|-------|------|-------------|
| `device` | String | Uploader device model |
| `soc` | String | Uploader SOC/GPU model |
| `date` | String | Upload date |
| `sha` | String | GitHub blob SHA (unique identifier) |
| `game_folder` | String | Game folder name in repo |
| `filename` | String | Config JSON filename |
| `votes` | Int | Upvote count |
| `downloads` | Int | Download count |
| `timestamp` | Long | Unix timestamp (entries >180 days old flagged "may be outdated") |

**GitHub config raw file URL:**
```
https://raw.githubusercontent.com/The412Banner/bannerhub-game-configs/main/configs/<URLencoded gameFolder>/<URLencoded filename>
```

**GitHub devices compatibility map:**
```
https://the412banner.github.io/bannerhub-game-configs/devices.json
```

**Steam cover art lookup (for game list thumbnails):**
1. Search: `https://store.steampowered.com/api/storesearch/?l=english&cc=us&term=<gameName>` → extract `items[0].id`
2. CDN: `https://cdn.akamai.steamstatic.com/steam/apps/<appId>/header.jpg`

**ux_db SQLite database** (XiaoJi internal game DB, read-only):
- Path: `getDatabasePath("ux_db")` 
- Table: `StarterGame.TABLE_NAME`
- Columns queried: `gameId`, `gameName` (used to map game IDs to display names in "Apply to Game" dialog)

---

---

## Section 62: Store Game Data Models (EpicGame / GogGame / AmazonGame)

**`EpicGame` fields:**
```
appName, namespace, catalogItemId, title, developer, description,
artCover, artSquare, version, isInstalled, installPath, installSize (long),
canRunOffline (bool), isDLC (bool), baseGameCatalogItemId, releaseDate
```

**`GogGame` fields:**
```
gameId, title, imageUrl, description, developer, category, generation (int)
```

**`AmazonGame` fields:**
```
productId, entitlementId, title, artUrl, heroUrl, developer, publisher,
productSku, isInstalled, installPath, versionId, downloadSize (long),
installSize (long), isDLC (bool), parentProductId
```
- `shortId()` → last component of `productId` after the final `.`

---

## Section 63: Amazon Wine Environment Variables (`buildFuelEnv()`)

**File:** `app/revanced/extension/gamehub/AmazonLaunchHelper.java`

Wine environment variables injected when launching an Amazon game (`AmazonLaunchHelper.buildFuelEnv(amazonGame)`):

```
FUEL_DIR=C:\ProgramData\Amazon Games Services\Legacy
AMAZON_GAMES_SDK_PATH=C:\ProgramData\Amazon Games Services\AmazonGamesSDK
AMAZON_GAMES_FUEL_ENTITLEMENT_ID=<amazonGame.entitlementId>
AMAZON_GAMES_FUEL_PRODUCT_SKU=<amazonGame.productSku>
AMAZON_GAMES_FUEL_DISPLAY_NAME=Player
```

These match the path layout under `filesDir/amazon_sdk/Amazon Games Services/` installed by `AmazonSdkManager`.

---

## Section 64: TokenProvider `/refresh` Endpoint

**File:** `app/revanced/extension/gamehub/token/TokenProvider.java`

In addition to the standard `/token` fetch, TokenProvider has a forced-refresh method that POSTs to:
```
https://gamehub-lite-token-refresher.emuready.workers.dev/refresh
```
Same `X-Worker-Auth: gamehub-internal-token-fetch-2025` header; same JSON response format. Called when an L1/L2 cache hit exists but a force-refresh is explicitly requested.

---

## Section 65: GOG Cloud Save — Request User-Agent

**File:** `app/revanced/extension/gamehub/GogCloudSaveManager.java`

GOG cloud save API calls use: `User-Agent: GOG Galaxy`

(Distinct from the GOG login WebView UA `Mozilla/5.0 ... GOG Galaxy/2.0` — the cloud save HTTP client uses the shorter form.)

---

---

## Section 66: XiaoJi Base API URL + BannerHub Injection Point

**File:** `com/xj/common/http/EggGameHttpConfig.java`

**Official XiaoJi/EggGame server environments:**
| Environment | Base URL |
|-------------|---------|
| TEST | `https://test-landscape-api.vgabc.com/` |
| PRODUCT | `https://landscape-api.vgabc.com/` |
| BETA | `https://landscape-api-beta.vgabc.com/` |
| DEV | `https://dev-gamehub-api.vgabc.com/` |

The APK ships as PRODUCT environment — base URL = `https://landscape-api.vgabc.com/`.

**The injection point:**
```java
b = GameHubPrefs.getEffectiveApiUrl("https://landscape-api.vgabc.com/")
```
`getEffectiveApiUrl()` returns:
- The original URL if api_source=0 (Official XiaoJi)
- `https://gamehub-lite-api.emuready.workers.dev/` if api_source=1 (EmuReady)
- `https://bannerhub-api.the412banner.workers.dev/` if api_source=2 (BannerHub)

This single static initializer in `EggGameHttpConfig` redirects **all** XiaoJi REST API traffic to the chosen backend. BannerHub intercepts calls at the Retrofit/OkHttp layer before they reach XiaoJi's servers.

**Startup behavior:** On first call, if `api_source` changed since last run, `clearComponentAndTokenCaches()` is triggered automatically.

**OkHttp configuration:**
- Connect/Read/Write timeout: 30s each
- On-disk cache: 128MB
- Interceptors: `EggGameTokenInterceptor`, `TokenRefreshInterceptor`, `OfflineCacheInterceptor`, `LogRecordInterceptor`, `RemoveExtraSlashInterceptor`
- Cookie jar: `PersistentCookieJar`

**Additional XiaoJi service endpoints** (not redirected through `getEffectiveApiUrl`):
| URL | Purpose |
|-----|---------|
| `https://clientgsw.vgabc.com/clientapi/` | Client gateway API (ADB inject update check, config fetch) |
| `https://clientegg.vgabc.com/uxapi/` | UX API (download task failure reporting) |
| `https://statistic-gamehub-api.vgabc.com/events` | Analytics/event tracking |
| `https://hubble.movingcloudgame.com/` | PC streaming / cloud gaming WebSocket server |
| `https://www.xiaoji.com/url/gsw-app-rules` | Privacy policy + terms URL |

**QQ/Tencent telemetry endpoints** (not redirected by BannerHub — excluded in `Companion.b()`):
- `test.nj.qq.com`
- `release.nj.qq.com`
- `trace.inlong.qq.com`

---

## Section 67: ComponentInjectorHelper — ZIP Component Format + .bh_injected Marker

**File:** `com/xj/landscape/launcher/ui/menu/ComponentInjectorHelper.java`

**ZIP GPU driver format (magic byte 0x50 = `P` = PK header):**
When the file is a ZIP archive, `injectComponent()`:
1. Strips extension for initial name
2. Extracts ZIP contents to `filesDir/usr/home/components/<name>/`
3. Reads embedded metadata JSON (extracted from ZIP as `strExtractZip`):
   - `driverVersion` → used as component display version (overrides filename-derived name)
   - `description` → component description  
   - `libraryName` → if non-empty and not already `"libvulkan_freedreno.so"`, renames file to `libvulkan_freedreno.so`
4. Calls `registerComponent(context, name, version, description, typeId)`

**Post-injection marker:**
After any successful injection (ZIP or WCP):
```
filesDir/usr/home/components/<componentName>/.bh_injected
```
This empty file marks the component as BannerHub-injected (vs stock XiaoJi components).

---

---

## Section 68: APK Signing Certificate — TESTKEY

**File:** `META-INF/TESTKEY.RSA`

**⚠️ APK is signed with the public AOSP debug/test key:**
| Field | Value |
|-------|-------|
| CN | Android |
| Org | Android (Mountain View, CA, US) |
| Email | `android@android.com` |
| Valid | 2008-02-29 → 2035-07-17 |
| Algorithm | SHA1withRSA (weak) |
| SHA1 | `61:ED:37:7E:85:D3:86:A8:DF:EE:6B:86:4B:D8:5B:0B:FA:A5:AF:81` |
| SHA256 | `A4:0D:A8:0A:59:D1:70:CA:A9:50:CF:15:C1:8C:45:4D:47:A3:9B:26:98:9D:8B:64:0E:CD:74:5B:A7:1B:F5:DC` |

This key is publicly available in AOSP; any party can create a new APK signed with an identical-looking certificate. Signature alone provides no authenticity guarantee.

---

## Section 69: Firebase / Google SDK Credentials (GameSir SDK)

**Source:** `res/values/strings.xml`

The APK includes the GameSir BLE controller SDK, which embeds Firebase/Google project credentials:
| Key | Value |
|-----|-------|
| Firebase project ID | `gamesir-8c76b` |
| Google App ID | `1:304891727788:android:e27ed4a7a22bdbc9adb409` |
| GCM Sender ID | `304891727788` |
| Google API Key | `AIzaSyD2bJl2Lh1TLgbvZHpA7GsquBg5Eko3X7g` |
| OAuth Web Client ID | `304891727788-1lqj59qoj25o37viksnkuacccc6jhgg8.apps.googleusercontent.com` |

These belong to GameSir's Firebase project, inherited by the XiaoJi launcher base and carried through the PUBG-disguised BannerHub distribution.

---

## Section 70: XiaoJi Launcher Firebase Login (`FirebaseAuthLoginUtils`)

**File:** `com/xj/landscape/launcher/firebase/FirebaseAuthLoginUtils.java`

The launcher supports Firebase phone number and generic identity provider (IdP) login:
- `FirebaseAuthLoginUtils` — general-purpose Firebase auth helper
- `FirebaseGenericIdpLogin` — IdP (Google/etc.) sign-in flow
- `FirebaseGoogleLogin` — Google Sign-In specific flow

These are used for the XiaoJi account system (not BannerHub-specific) but carry the GameSir Firebase project credentials above.

---

## Section 71: BH Download Service — Store Orchestration

**File:** `app/revanced/extension/gamehub/BhDownloadService.java` (classes18.dex)

A foreground Android `Service` that orchestrates game downloads from all three stores.

**Store constants:**
- `"EPIC"`, `"GOG"`, `"AMAZON"`

**Intent actions:**
- `bh.download.START` — start a download
- `bh.download.CANCEL` — cancel active download

**Notification channel:** `bh_downloads` ("BannerHub Downloads")  
**Notification IDs:** 8800 (progress), 8810+ (done/error)

**Library persistence (SharedPrefs `bh_library`):**
- Key = game_id; value = `"<gameName>\n<store>\n<installPath>"`
- `bh_library` is the installed games catalog for BannerHub downloads

**Per-store install state (in respective SPs):**

| Store | SP | Key | Value |
|-------|----|-----|-------|
| Epic | `bh_epic_prefs` | `epic_dir_<appName>` | install path |
| Epic | `bh_epic_prefs` | `epic_manifest_version_<appName>` | version string |
| Epic | `bh_epic_prefs` | `epic_exe_<appName>` | detected exe path |
| GOG | `bh_gog_prefs` | `gog_exe_<gameId>` | selected exe path |
| GOG | `bh_gog_prefs` | `gog_dir_<gameId>` | install dir |
| Amazon | `bh_amazon_prefs` | `amazon_dir_<productId>` | install path |
| Amazon | `bh_amazon_prefs` | `amazon_exe_<productId>` | detected exe path |

**Install directories:**
- Epic: `filesDir/epic_games/<sanitizedTitle>/`
- Amazon: `filesDir/Amazon/<sanitizedTitle>/`
- GOG: via `BhStoragePath` → `filesDir/gog_games/<sanitizedTitle>/` (or SD card equivalent)

**Title sanitization:** `title.replaceAll("[^a-zA-Z0-9 \\-_]", "").trim()`

---

## Section 72: Epic API Client URLs and User-Agents

**File:** `app/revanced/extension/gamehub/EpicApiClient.java`

| Constant | Value |
|----------|-------|
| `LIBRARY_URL` | `https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true` |
| `CATALOG_BASE` | `https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace` |
| `MANIFEST_BASE` | `https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace` |
| `LEGENDARY_UA` | `Legendary/0.1.0 (GameNative)` |

**Manifest API URL pattern:**
```
MANIFEST_BASE/<namespace>/catalogItem/<catalogItemId>/app/<appName>/label/Live
```

**Library pagination:** Supports cursor-based pagination via `?cursor=<value>` appended to LIBRARY_URL.

**Namespace blacklist** (filtered from library):
- `"ue"` — Unreal Engine namespace
- `"89efe5924d3d467c839449ab6ab52e7f"` — internal Unreal namespace
- SandboxType `"PRIVATE"` — private items excluded

**Platform filter:** Windows/Win32 only.

**Cloud save user-agent** (`EpicCloudSaveManager`): `EpicGamesLauncher/15.17.1-22692490`

**Debug log file:** Both Epic and GOG cloud save managers append to `bh_cloud_debug.txt` on `Environment.getExternalStorageDirectory()`.

---

## Section 73: Credential Stores — Persistence Details

**Amazon (`AmazonCredentialStore`):**
- File: `filesDir/amazon/credentials.json`
- Fields: `access_token`, `refresh_token`, `device_serial`, `client_id`, `expires_at`
- Auto-refresh if `expires_at - now < 300,000ms` (5 minutes)

**Epic (`EpicCredentialStore`):**
- SharedPrefs: `bh_epic_prefs`
- Fields: `access_token`, `refresh_token`, `account_id`, `display_name`, `expires_at`
- Auto-refresh if `expires_at - now < 300,000ms`

**GOG (`bh_gog_prefs`):**
- Fields: `access_token`, `refresh_token`, `user_id`, `bh_gog_login_time`, `bh_gog_expires_in`
- Additional: `gog_client_secret_<gameId>` — per-game client secret for game-scoped tokens
- Pending launch: `pending_gog_exe` — exe path deferred until Wine prefix is ready
- `GogLaunchHelper.checkPendingLaunch()` calls host activity method `B3(String)` via reflection to launch

---

## Section 74: GameHubPrefs — Settings System

**File:** `app/revanced/extension/gamehub/prefs/GameHubPrefs.java`
**SharedPrefs:** `steam_storage_pref`

**BH-specific setting IDs and names:**
| ID | Name | Default |
|----|------|---------|
| 24 | "Save Store Games to External Storage (SD Card)" | false |
| 26 | "Compatibility API" | 0 (Official) |
| 27 | "Log All Requests" | false |
| 28 | "CPU Usage Display" | true |
| 29 | "Performance Metrics" | true |

**API source values:**
- `0` = Official (`https://landscape-api.vgabc.com/`)
- `1` = EmuReady (`https://gamehub-lite-api.emuready.workers.dev/`)
- `2` = BannerHub (`https://bannerhub-api.the412banner.workers.dev/`)

**Cache wipe on API switch** (clears all of these SharedPrefs + cache dir):
- `sp_winemu_all_components12`
- `sp_winemu_all_containers`
- `sp_winemu_all_imageFs`
- `pc_g_setting`
- `net_cookies`
- `TokenProvider` in-memory cache
- `CompatibilityCache` in-memory cache
- `getCacheDir()` recursive delete

**Compatibility request headers added via reflection:**
```
User-Agent: Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36
Accept: application/json, text/plain, */*
Accept-Language: en-US,en;q=0.9
Connection: keep-alive
```

**SD card auto-detection:** Looks for a directory named `GHL` on external storage paths; if writable, uses that SD card path.

**Storage broadcast actions** (received by `StorageBroadcastReceiver`):
- `<packageName>.SET_STEAM_STORAGE` + extra `"path"` — sets custom storage path
- `<packageName>.USE_INTERNAL_STORAGE` — reverts to internal storage

---

## Section 75: BhStoragePath — Storage Routing

**File:** `app/revanced/extension/gamehub/BhStoragePath.java`
**SharedPrefs:** `steam_storage_pref`
- `use_custom_storage` (bool) — whether SD card mode is active
- `steam_storage_path` (String) — custom storage root path

**Routing logic:**
```
if (use_custom_storage && steam_storage_path != null):
    base = <steam_storage_path>/bannerhub/<storeName>/
else:
    base = filesDir/<storeName>/
```

**Store names:** `"gog_games"` (GOG), `"epic_games"` (Epic), `"Amazon"` (Amazon)

---

## Section 76: Performance / Device Metrics

**File:** `app/revanced/extension/gamehub/util/DeviceMetrics.java`  
**File:** `app/revanced/extension/gamehub/ui/PerformanceMetricsHelper.java`

**CPU:** `Process.getElapsedCpuTime()` vs wall time, 500ms cache, normalized by processor count.

**GPU sysfs path resolution (in priority order):**
1. `/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage` — Qualcomm (percentage format)
2. `/sys/class/kgsl/kgsl-3d0/gpubusy` — Qualcomm (busy/total format)
3. `/sys/kernel/gpu/gpu_load` — Samsung (percentage format)
4. `/sys/devices/platform/*/gpu/utilisation` or `.../utilization` — Mali
5. `/sys/class/mpgpu/utilization` — Amlogic

**RAM:** `ActivityManager.MemoryInfo.totalMem` vs `availMem`, displayed as `"RAM: X.X / Y.Y GB (Z%)"`.

**Refresh interval:** 1000ms.

**GHLog tag prefix:** `GHL/<category>` (e.g., `GHL/Token`, `GHL/Net`, `GHL/Playtime`, `GHL/Perf`, etc.)

---

## Section 77: Playtime Helper — SQLite DBs

**File:** `app/revanced/extension/gamehub/playtime/PlaytimeHelper.java`

Two SQLite databases queried to read local Steam playtime:

**Database 1: `xj_steam_db`**
```sql
SELECT id FROM steam_account WHERE is_current_user = 1 LIMIT 1
```
Returns the current Steam user ID.

**Database 2: `xj_steam_pics_v5`**
```sql
SELECT app_id, playtime_forever, playtime2weeks
FROM t_steam_user_pics_app_last_played_times
WHERE user_id = ? AND playtime_forever > 0
ORDER BY playtime2weeks DESC, playtime_forever DESC
```
Returns play times in minutes; multiplied by 60 to get seconds.

**Reflected class:** `com.xj.game.entity.RecentGameEntity` (fields: `a`=steamAppId, `d`=totalSeconds, `e`=last14Days).

---

## Section 78: Amazon SDK Manager — DLL Deployment

**File:** `app/revanced/extension/gamehub/AmazonSdkManager.java`

Amazon Games Services requires two DLLs deployed to the Wine prefix:
1. `FuelSDK_x64.dll` → installed to `C:\ProgramData\Amazon Games Services\Legacy\`
2. `AmazonGamesSDK*.dll` → installed to `C:\ProgramData\Amazon Games Services\AmazonGamesSDK\`

**SDK cache location:** `filesDir/amazon_sdk/Amazon Games Services/`  
**Version file:** `filesDir/amazon_sdk/.sdk_version`

**SDK manifest download:** `GET <channelDownloadUrl>/manifest.proto`  
**DLL download:** `GET <channelDownloadUrl>/files/<fileHashHex>`  
**Header for downloads:** `User-Agent: nile/0.1 Amazon` + `x-amzn-token: <accessToken>`

**Manifest format:** Custom protobuf (4-byte BE header size + proto header + XZ/LZMA-compressed payload).

---

## Section 79: Amazon Manifest Parsing

**File:** `app/revanced/extension/gamehub/AmazonManifest.java`

Custom binary protobuf manifest for Amazon game packages:
- Header: 4-byte big-endian `headerSize`, followed by proto header with compression algorithm field
- Payload: `headerSize` bytes skipped, remainder is XZ (`0xFD37`) or LZMA compressed
- Proto field `field 1, field 2 (bytes)` = header containing `field 1 (varint)` = compressionAlgo
- CompressionAlgo 1 = XZ, 0 = LZMA (via `org.tukaani.xz.XZInputStream` or `LZMAInputStream`)

**ParsedManifest** contains `allFiles[]` (ManifestFile) with fields: `path`, `size`, `hashAlgorithm`, `hashBytes`.  
`ManifestFile.unixPath()` replaces `\\` with `/`.  
`ManifestFile.hashHex()` = hex of `hashBytes`.

---

## Section 80: MTDataFilesProvider — Internal Storage DocumentsProvider

**File:** `app/revanced/extension/gamehub/filemanager/MTDataFilesProvider.java`

A `DocumentsProvider` exposing the app's internal storage to file managers:
- Reflectively nulls out `mReadPermission` and `mWritePermission` to bypass permission enforcement
- Root segments: `data` (filesDir parent), `android_data` (external files), `android_obb`, `user_de_data` (credential-encrypted storage)

**Custom methods** (via `call()`):
- `mt:createSymlink` — creates a symlink
- `mt:setLastModified` — sets file modification time
- `mt:setPermissions` — changes file permissions

**Symlink detection:** `Os.lstat()` checking `st_mode & 0xF000 == 0xA000`.

---

## Section 81: SDK Credentials — Chinese Third-Party SDKs

**File:** `com/xj/common/config/SdkConfig.java`

Third-party SDK credentials embedded in XiaoJi base:

**JPush (极光推送) push notifications:**
- Key: `fdeb83da9ad2f3e16b983fde`

**QQ OAuth (Tencent):**
- Normal APK: AppID=`102667728`, AppKey=`jQt9D4i8ICrKZbQA`
- RedMagic variant: AppID=`102797136`, AppKey=`73rTt8A4lCOYWIp9`

**WeChat OAuth:**
- Normal: AppID=`wx2075ef952b9b60c4`, Secret=`e7c8b599ef6eacd44857a83d15c81f63`
- RedMagic: AppID=`wxf9d9756e4f820261`, Secret=`9481ffd7ce2ca099f224a17c67bda414`

**Umeng analytics:**
- Normal: `667a6196cac2a664de54975a`
- RedMagic: `6853d7ff79267e02108beb2c`
- Test: `682a95e6bc47b67d83695f07`

**Firebase OAuth Web Client ID:**
- Normal: `304891727788-1lqj59qoj25o37viksnkuacccc6jhgg8.apps.googleusercontent.com`
- RedMagic: `464226359755-hd93lt0ad68vaoqj9u6hteg97r6ij8gl.apps.googleusercontent.com`

**Distribution channels** (via Tencent Vasdolly): `"360"`, `"samsung"`, `"google"`, `"realme"`, `"Official"`

**App flavors:** `"googlePlay"`, `"logitech"`, `"realme"`, `"redmagic"`, default=`"gamehub_android"`

---

## Section 82: PSN OAuth and Xbox URLs

**PSN (PlayStation Network) OAuth:**
```
https://auth.api.sonyentertainmentnetwork.com/2.0/oauth/authorize
  ?service_entity=urn:service-entity:psn
  &response_type=code
  &client_id=ba495a24-818c-472b-b12d-ff231c1b5745
  &redirect_uri=https://remoteplay.dl.playstation.net/remoteplay/redirect
  &scope=psn:clientapp
  &request_locale=<locale>
```
- PSN OAuth client_id: `ba495a24-818c-472b-b12d-ff231c1b5745`
- Connects to `com.playstation.remoteplay` (PS Remote Play Android app) via the `psplay` module

**Xbox Game Pass:**
- `https://www.xbox.com/play/` and `https://www.xbox.com/en-AU/play/`
- WebView-based Game Pass streaming integration
- Origin allowlist: `https://*.xbox.com`

---

## Section 83: BannerHub GitHub Component Sources

**Confirmed GitHub raw URLs embedded in the APK:**

| Repository | File | Purpose |
|------------|------|---------|
| `The412Banner/Nightlies` | `nightlies_components.json` | BH nightly build components |
| `The412Banner/Nightlies` | `kimchi_drivers.json` | Kimchi GPU driver releases |
| `The412Banner/Nightlies` | `mtr_drivers.json` | MTR GPU driver releases |
| `The412Banner/Nightlies` | `stevenmxz_drivers.json` | StevenMXZ driver builds |
| `The412Banner/Nightlies` | `white_drivers.json` | White driver builds |
| `The412Banner/bannerhub-game-configs` | `configs/<folder>/<file>` | Community game configs |
| `Arihany/WinlatorWCPHub` | `pack.json` | WCPHub component pack index |

---

## Section 84: XiaoJi CDN and Steam Mirror URLs

**XiaoJi game image CDN:**
- Base: `https://uxdl.bigeyes.com/ux-landscape/`
- Game images: `.../game-image/<hash>.{png,jpeg,webp}`
- Store images: `.../st/en/image/<hash>.webp`

**XiaoJi Steam mirror CDN:**
- Base: `https://shared.cdn.queniuqe.com/`
- Steam headers: `.../store_item_assets/steam/apps/<appId>/header.jpg?t=<timestamp>`

**XiaoJi website URLs:**
- Help: `https://doc.xiaoji.com/help.html?lang=<lang>`
- Device selector: `https://doc.xiaoji.com/selectdevice.html?lang=<lang>`
- Main: `https://gamehub.xiaoji.com`
- App rules: `https://www.xiaoji.com/url/gsw-app-rules`

**Steam API URLs:**
- Player count: `https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1?appid=<id>`
- App details: `https://store.steampowered.com/api/appdetails/?appids=<ids>`
- Events: `https://store.steampowered.com/events/ajaxgetadjacentpartnerevents/?appid=<id>`
- Steam China: `https://store.steamchina.com`

---

## Section 85: BhWineLaunchHelper — Wine Process Discovery

**File:** `app/revanced/extension/gamehub/BhWineLaunchHelper.java`

Finds the Wine binary by scanning `/proc/<pid>/comm` for running processes:

**Process name patterns recognized:**
- `wineserver` — Wine server process
- `wine64-preload*` — 64-bit Wine pre-loader
- `wineloader` — Wine loader
- `*.exe` — any Windows executable (for env reading)

**Binary search order** (once Wine dir found):
1. `wine64`
2. `wine`
3. `wineloader`
4. `wine64-preloader`

**Environment reading:** Reads `/proc/<pid>/environ` (null-byte separated) for `WINELOADER` and `WINEPREFIX` env vars.

**Launchable file extensions:** `.exe`, `.msi`, `.bat`, `.cmd`

**Exe launch:** `Runtime.getRuntime().exec([wineLoader, exePath], wineEnviron, null)`

---

## Section 86: GogLaunchHelper — Deferred Launch via Reflection

**File:** `app/revanced/extension/gamehub/GogLaunchHelper.java`

GOG game launch is deferred to the XiaoJi launcher via reflection:

1. `triggerLaunch(activity, exePath)` → stores `pending_gog_exe` in `bh_gog_prefs` → finishes the BH overlay activity
2. `checkPendingLaunch(activity)` → reads `pending_gog_exe` → calls `activity.B3(exePath)` via reflection

This `B3` method is on the obfuscated XiaoJi `PCEmuActivity`; it accepts a Windows EXE path and launches it in the Wine environment.

---

## 19. Architecture Summary

```
com.tencent.ig (PUBG package ID)
├── com.xj.app.SplashActivity  ← LAUNCHER entry
├── XiaoJi Launcher Base (com.xj.landscape.launcher.*)
│   ├── Main launcher UI (games, recording, social, settings)
│   ├── Key Mapping Overlay (MappingService, InjectService, VTouchIPCService)
│   ├── PC Streaming (libstreaming-core.so, WebRTC, mDNS discovery)
│   ├── Steam Module (SteamService, SteamDownloader, xj_steam_db)
│   ├── Wine/WinEmu bridge (libwinemu.so, EmuComponents, EmuFileService)
│   └── Component Manager (ComponentInjectorHelper → WCP format)
│
└── BannerHub Extension Layer (app.revanced.extension.gamehub.*)  ← classes18
    ├── Store Integrations
    │   ├── GOG   (OAuth, library, download, cloud save, GOG CDN)
    │   ├── Epic  (Legendary-compatible API, PKCE, library, manifest)
    │   └── Amazon (PKCE, Prime Gaming, fuel.json launch)
    ├── Core Infrastructure
    │   ├── TokenProvider (4h cache, fake-token for EmuReady path)
    │   ├── GameHubPrefs (3-way API switch: Official / EmuReady / BannerHub)
    │   ├── BhStoragePath (internal or custom SD card root)
    │   └── BhDownloadService (unified multi-store downloader)
    ├── Config System
    │   ├── BhGameConfigsActivity (per-game prefs: pc_g_setting<id>)
    │   └── BhSettingsExporter (export to local + cloud worker)
    ├── Wine Launch Bridge
    │   └── BhWineLaunchHelper (/proc scan for WINELOADER/WINEPREFIX)
    ├── File System Access
    │   └── MTDataFilesProvider (exported DocumentsProvider, full /data access)
    └── Diagnostics
        ├── GHLog (13 logcat tags under GHL/ prefix)
        ├── PlaytimeHelper (xj_steam_db SQLite reader)
        ├── CpuUsageHelper, PerformanceMetricsHelper, BatteryHelper
        └── CompatibilityCache (game compat data injection via reflection)
```

---

## §87–§96: Third-Party Stores, CDN, Analytics (Pass 8 Additions)

---

### §87 — Steam Directory Layout (SteamFilePaths)

`com/xj/standalone/steam/core/SteamFilePaths.java` (static initializer)

All paths are relative to `context.getFilesDir()`:

| Path | Purpose |
|------|---------|
| `filesDir/Steam/` | Steam root (`j`) |
| `filesDir/Steam/steamapps/` | App library root (`k`) |
| `filesDir/Steam/steamapps/common/` | Game install parent (`l`) |
| `filesDir/Steam/steamapps/config/` | Steam config directory (`m`) |
| `filesDir/Steam/steamapps/config/steam_input/` | Steam Input parent (`n`) |
| `filesDir/Steam/steamapps/config/steam_input/config/` | VDF controller configs (`o`) |
| `filesDir/Steam/steamapps/app_info/` | Per-app info cache (`p`) |
| `filesDir/steam_download_cache/` | Download staging root (`h`) |
| `filesDir/steam_download_cache/manifest/` | Manifest cache dir (`i`) |
| `filesDir/steam_games/` | Separate Steam game directory (`r`) |

Controller config VDF filenames:
- Per-app: `<appId>_<configName>.vdf`
- Workshop: `workshop_<manifestId>.vdf`

Manifest cache filenames:
- Active: `<manifestId>` (no extension)
- In-progress: `<manifestId>.tmp`

Cleanup method `c(long manifestId)` deletes both active and `.tmp` files for a given manifest ID.

---

### §88 — Steam CM Server List Persistence (GHFileServerListProvider)

`com/xj/standalone/steam/core/GHFileServerListProvider.java`

Implements JavaSteam's `IServerListProvider` interface. Persists the Steam CM server list across sessions.

**File**: `filesDir/server_list.bin` (protobuf `BasicServerListProtos.BasicServerList`)

**Key behaviour**:
- `fetchServerList()` — parses `BasicServerList` from file; if missing returns empty list; logs first server host on success
- `getLastServerListRefresh()` — returns file's `lastModifiedTime` as `Instant`; returns `Instant.MIN` on any error
- `updateServerList(endpoints)` — serializes list of `ServerRecord` objects to protobuf `BasicServer` entries (host, port, protocol code), writes to file

Each `BasicServer` entry stores:
- `address` = `serverRecord.getHost()`
- `port` = `serverRecord.getPort()`
- `protocol` = `ProtocolTypes.code(serverRecord.getProtocolTypes())`

Log tag: `GHFileServerListProvide`

---

### §89 — Steam Download Constants (SteamConfig)

`com/xj/standalone/steam/SteamConfig.java`

| Field | Value | Meaning |
|-------|-------|---------|
| `b` | `88` | Configurable constant (likely chunk size or connection limit) |
| `k` | `24` | Unknown constant |
| `l` | `20` | Unknown constant |
| `m` | `60L` | Timeout in seconds |
| `n` | `availableProcessors()` (fallback 8) | Max parallel download threads |

---

### §90 — App Flavor and Channel System (AppConfig / Constants)

`com/xj/common/config/AppConfig.java`

**Build flavors** (Gradle productFlavors):
- `googlePlay` — Standard Google Play release
- `logitech` — Logitech GameHub OEM variant
- `realme` — Realme device OEM variant
- `redmagic` — RedMagic GameHub OEM variant

**Distribution channels** (Tencent Vasdolly multi-channel):
- `"360"`, `"samsung"`, `"google"`, `"realme"`, `"Official"`

**Server environments** (from `AppPreferences.getServerEnv()`):
- `"release"` — production
- `"pre"` — pre-release / staging
- `"test"` — internal test

`com/xj/common/config/Constants.java`:
- `a()` returns analytics source string:
  - `com.xiaoji.egggame.redmagic` → `"gamehub_redmagic"`
  - `com.xiaoji.egggame.logitech` → `"gamehub_logitech"`
  - else → `"gamehub_android"`

---

### §91 — Amazon PKCE Client Identity Generation (AmazonPKCEGenerator)

`app/revanced/extension/gamehub/AmazonPKCEGenerator.java`

**Device serial generation**:
```
UUID.randomUUID().toString().replace("-","").toUpperCase()
```
→ 32-char uppercase hex string

**Client ID derivation**:
```
clientId = hex( bytes(deviceSerial + "#A2UMVHOX7UP4V7") )
```
- Concatenate device serial with `#A2UMVHOX7UP4V7`
- Encode UTF-8 bytes to lowercase hex
- Result is the OAuth `client_id` sent to Amazon

**PKCE Code Verifier**:
```
verifier = Base64URL_nopad( SecureRandom(32 bytes) )
```

**PKCE Code Challenge**:
```
challenge = Base64URL_nopad( SHA-256( UTF-8(verifier) ) )
```
Method: `S256`

Fixed constants:
- `DEVICE_TYPE = "A2UMVHOX7UP4V7"` (AGS Windows device type)
- `APP_NAME = "AGSLauncher for Windows"` (impersonates official AGS launcher)

---

### §92 — BannerHub Configs Worker — Full Endpoint Map

Base URL: `https://bannerhub-configs-worker.the412banner.workers.dev`

All endpoints confirmed from `BhGameConfigsActivity.java`:

| Method | Path | Query Params | Purpose |
|--------|------|-------------|---------|
| GET | `/games` | `refresh=1` (optional) | List all supported games |
| GET | `/list` | `game=<game>`, `refresh=1` (opt) | List configs for one game |
| GET | `/download` | `game=<game>`, `file=<file>`, `sha=<sha>` (opt) | Download config file |
| GET | `/comments` | `game=<game>`, `file=<file>` | Get comments for a config |
| GET | `/desc` | `sha=<sha>` | Get description for a config version |
| POST | `/vote` | — | Vote on a config |
| POST | `/report` | — | Report a config |
| POST | `/comment` | — | Add a comment |
| POST | `/delete` | — | Delete a config |
| POST | `/describe` | — | Set description for a config |
| POST | `/upload` | — | Upload a new config |

All POST requests are presumably JSON-body with auth token from the BannerHub API token system.

---

### §93 — Xbox Game Pass / PC Game Pass URLs

From `grep -rh "https://" com/xj` on base XiaoJi sources:

Xbox/Microsoft-related endpoints found in source tree:
- `https://displaycatalog.mp.microsoft.com/` — MS Store catalog API (game listings)
- `https://accounts.xbox.com/` — Xbox account auth base
- `https://xsts.auth.xboxlive.com/` — Xbox STS (Security Token Service)
- `https://usher.twitchapps.com/` — Twitch streaming (referenced but likely unused)

Microsoft OAuth redirect flow references (Xbox Live integration):
- `AUTH_URL` base: `https://login.live.com/oauth20_authorize.srf`
- `TOKEN_URL`: `https://login.live.com/oauth20_token.srf`
- `XBOX_AUTH_URL`: `https://user.auth.xboxlive.com/user/authenticate`
- `XSTS_URL`: `https://xsts.auth.xboxlive.com/xsts/authorize`

These are part of the XiaoJi base cloud gaming / PC streaming module, not BannerHub-specific.

---

### §94 — Additional Third-Party Analytics Endpoints

From URL grep:

**Umeng Analytics**:
- `https://alog.umeng.com/app_logs` — event log upload
- `https://elog.umeng.com/app_logs` — error log upload
- `https://ulogs.umeng.com/` — unified log endpoint

**QQ Graph API**:
- `https://graph.qq.com/oauth2.0/authorize` — QQ OAuth authorize
- `https://graph.qq.com/oauth2.0/token` — QQ OAuth token
- `https://graph.qq.com/user/get_user_info` — QQ user info

**XiaoJi CDN / Update**:
- `https://landscape-api.vgabc.com/` — XiaoJi official API (confirmed main base)
- `https://static.vgabc.com/` — static assets / CDN
- `https://update.vgabc.com/` — app update check

---

### §95 — Storage Broadcast Receiver (StorageBroadcastReceiver)

`app/revanced/extension/gamehub/steam/StorageBroadcastReceiver.java`

Receives two broadcast actions (both prefixed with the app's package name):
- `<packageName>.SET_STEAM_STORAGE` — sets custom storage path (extra: `"path"`)
- `<packageName>.USE_INTERNAL_STORAGE` — reverts to internal storage

Since the APK uses package `com.tencent.ig` (PUBG Mobile disguise):
- Effective action 1: `com.tencent.ig.SET_STEAM_STORAGE`
- Effective action 2: `com.tencent.ig.USE_INTERNAL_STORAGE`

Any app with `BROADCAST_PERMISSION` (or if unprotected) could trigger these to reroute where BannerHub stores games — a potential attack surface if broadcasts are not signature-protected.

---

### §96 — Download Badge Tag / UI Constants

`app/revanced/extension/gamehub/BhDashboardDownloadBtn.java`

- Download badge view tag: `"bh_dl_badge"` (used to locate the progress badge view via `view.findViewWithTag()`)
- Progress UI updates via `Handler(Looper.getMainLooper())`
- Integrates with `BhDownloadService` intent protocol

`app/revanced/extension/gamehub/BhDashboardDownloadBtn` is the composite button widget that shows download progress inline on game cards in the BannerHub dashboard.

---

*[Pass 8 complete — 10 new sections (87–96) added]*

---

## §97–§112: Steam API, Amazon/Epic/GOG Auth, CDN, Token, Cloud Save (Pass 9 Additions)

---

### §97 — Steam API Public Interface (SteamAPI)

`com/xj/standalone/steam/SteamAPI.java`

Singleton `SteamAPI.a`. Key coroutine methods:

| Method | Purpose |
|--------|---------|
| `autoLogin()` | Logs in with saved `accountName` + `refreshToken` from `SteamUserTable` |
| `isSteamGamePurchased(appId)` | Checks if current user owns the app ID |
| `requestFreeLicense(appIds)` | Claims free game licenses via SteamSdk |
| `getAppInfoByOnline(appId)` | Fetches `SteamPicsAppInfo` online via `SteamSdk.p()` |
| `getCurCellId()` | Returns Steam cell ID; cached per-user in map `f`; falls back to network |
| `getUserAvatarUrl()` | Gets user avatar URL via `XjSteamClient.K()` |
| `changeAccount(accountName)` | Switches to a different account |
| `removeAccount(steamUserTable)` | Removes account from DB |
| `getLicenseOwnerId(appId)` | Checks `SteamPackageLicense.getOwnerId()` for family sharing detection |
| `n()` | Creates `DepotContentDownloader(accountName, refreshToken)` |

Internal maps:
- `f` — `Map<Long userId, Integer cellId>` (per-user cell ID cache)
- `g` — `Map<Long userId, Long steamId64>` (per-user Steam ID)
- `h` — `Map<Long userId, XjSteamClient>` (active Steam clients by user)

`z(maxConns, chinaBool, debugBool, getDnsIpPool, isChinaIP, onLoggedOn, onConnectChanged, onSteamLicenseAppRefresh)` — configures `SteamConfig` with all callbacks. Default `maxConns=88`.

---

### §98 — Steam Depot Download Protocol (SteamDownloader)

`com/xj/standalone/steam/SteamDownloader.java`

Singleton `SteamDownloader.a`.

Key methods:

| Method | Parameters | Purpose |
|--------|-----------|---------|
| `g(appId, depotId, manifestId, branchName, password)` | appId, depotId, manifestId=long, branch=String?, pwd=String? | Main manifest download |
| `b(appId, depotId, manifestId, depotKey, chunkData, CDNClientPool)` | byte[] depotKey, byte[] chunkData | Download one depot chunk |
| `c(appId, depotId, manifestId, manifestRequestCode, chunkData, CDNClientPool)` | long requestCode | Download manifest v2 format |
| `d()` | — | Gets JavaSteam `ContentServerDirectory` service (via `SteamUnifiedMessages.createService()`) |
| `e(appId, depotId)` | — | Gets depot decryption key |
| `i()` | — | Gets current `XjSteamClient` (throws `XjSteamException` if null) |

IO scope: `Dispatchers.IO + SupervisorJob + CoroutineExceptionHandler`

---

### §99 — Steam IP Pool and DNS Rotation (SteamIPs)

`com/xj/standalone/steam/SteamIPs.java`

**Hardcoded fallback IP**: `"23.46.197.62"` (Steam CDN Akamai IP)

**Custom DNS pool**: Parsed from API response JSON path `data.dns_pool` as list of `DnsEntry(url_address, ip_address[])`.

**IP tracking**: `ConcurrentHashMap<String host, ConcurrentHashMap<String ip, Integer failureCount>>`

**`SteamIpStateInterceptor`**: OkHttp interceptor that:
- Tracks `SocketTimeoutException` per IP, increments failure counter
- Logs Chinese: "超时，超时次数：N" (timeout, count N)

**IP selection** (`e(host)`):
1. Returns IP with lowest failure count
2. If lowest count > `a=5` → resets pool (`k()`)
3. Reset is retried up to `b=3` times

**China IP routing**: `l(host)` checks if server host contains `-hkg` (Hong Kong) or `-tyo` (Tokyo) → used by `FastestHostFinder` to filter for Chinese users.

**Monitored hosts**: `api.steampowered.com`, `store.steampowered.com`

---

### §100 — Steam API URLs (SteamApiUrls)

`com/xj/standalone/steam/sdk/SteamApiUrls.java`

| URL Pattern | Purpose |
|------------|---------|
| `https://store.steampowered.com/events/ajaxgetadjacentpartnerevents/?appid=N&count_before=0&count_after=N` | Game news/events |
| `https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1?appid=N` | Current player count |
| `f()/api/appdetails?appids=N&filters=ratings` | App store ratings |

`f()` returns `https://store.steampowered.com` normally, or `https://store.steamchina.com` for Chinese locale.

For Chinese events: appends `&lang_list=6_0`

---

### §101 — Fastest CM Server Finder (FastestHostFinder)

`com/xj/standalone/steam/hostport/FastestHostFinder.java`

Finds the fastest Steam CM server by parallel TCP probing:

- Max 20 concurrent threads (`Executors.newFixedThreadPool(min(20, serverCount))`)
- Connection timeout set by `SteamConfig.a.b` (=88ms?)
- Failed hosts are blacklisted for 60 seconds in `b` (ConcurrentHashMap)
- First successful TCP connect wins via `AtomicReference` + `CountDownLatch`

`e(serverList)` — pre-filters servers: if Chinese user (`SteamConfig.a.m()` = isChinaIP returns true), keeps only `-hkg`/`-tyo` servers; else excludes them.

`h(SmartCMServerList)` — main entry; filters then parallel-pings, returns fastest `HostPort`.

---

### §102 — Amazon Gaming API Endpoints (AmazonApiClient)

`app/revanced/extension/gamehub/AmazonApiClient.java`

All requests use `X-Amz-Target` header (Amazon RPC-style):

| Endpoint | X-Amz-Target | Purpose |
|---------|-------------|---------|
| `https://gaming.amazon.com/api/distribution/entitlements` | `...GetEntitlements` | Paginated game library (50/page) |
| `https://gaming.amazon.com/api/distribution/v2/public` | `...GetGameDownload` | Get `downloadUrl` + `versionId` |
| `https://gaming.amazon.com/api/distribution/v2/public` | `...GetLiveVersionIds` | Check live version for product IDs |
| `https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346` | — | Amazon Games SDK update channel |

Headers:
- Gaming requests: `User-Agent: com.amazon.agslauncher.win/3.0.9202.1` + `Content-Encoding: amz-1.0`
- Download requests: `User-Agent: nile/0.1 Amazon`

Entitlements body fields:
- `clientId = "Sonic"` (hardcoded)
- `keyId = "d5dc8b8b-86c8-4fc4-ae93-18c0def5314d"` (hardcoded)
- `hardwareHash = SHA-256(deviceSerial).toUpperCase()`
- `maxResults = 50`

---

### §103 — Amazon Auth Endpoints (AmazonAuthClient)

`app/revanced/extension/gamehub/AmazonAuthClient.java`

| Endpoint | Purpose |
|---------|---------|
| `https://api.amazon.com/auth/register` | Register new device (gets bearer + mac_dms tokens) |
| `https://api.amazon.com/auth/token` | Refresh access token |
| `https://api.amazon.com/auth/deregister` | Revoke device registration |

Device registration body fields:
- `app_name = "AGSLauncher for Windows"`, `app_version = "1.0.0"`
- `device_model = "Windows"`, `device_type = "A2UMVHOX7UP4V7"`
- `os_version = "10.0.19044.0"` (Windows 10 21H2)
- `domain = "Device"`, `use_global_authentication = false`
- `requested_token_type = ["bearer", "mac_dms"]`
- `requested_extensions = ["customer_info", "device_info"]`

Auth user agent: `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0` (Windows Firefox impersonation)

Refresh adds: `x-amzn-identity-auth-domain: api.amazon.com`

---

### §104 — Amazon Game Launch (AmazonLaunchHelper)

`app/revanced/extension/gamehub/AmazonLaunchHelper.java`

**Launch spec construction**:
1. Reads `fuel.json` at game install root: `Main.Command`, `Main.WorkingSubdirOverride`, `Main.Args[]`
2. If no `fuel.json`, heuristically selects primary EXE via scoring
3. Final Wine command: `winhandler.exe "A:\<exe_path>"` + args

**EXE scoring heuristics** (`scoreExe(file, gameTitle)`):
- Base score: 50
- UE Shipping pattern (`*-win32/64(-shipping)?.exe`): +350
- UE Binaries pattern (`*/binaries/win32/64/*.exe`): +250
- Root-level EXE (no `/`): +200
- Name matches game title prefix (5+ chars): +100
- Contains negative keyword (crash/handler/viewer/compiler/tool/setup/unins/eac/launcher/steam): −150
- GENERIC_NAME pattern (`^[a-z]\d{1,3}\.exe$`): −200 (also stubs if <1MB)

**Wine environment variables injected** by `buildFuelEnv(game)`:
```
FUEL_DIR=C:\ProgramData\Amazon Games Services\Legacy
AMAZON_GAMES_SDK_PATH=C:\ProgramData\Amazon Games Services\AmazonGamesSDK
AMAZON_GAMES_FUEL_ENTITLEMENT_ID=<entitlementId>
AMAZON_GAMES_FUEL_PRODUCT_SKU=<productSku>
AMAZON_GAMES_FUEL_DISPLAY_NAME=Player
```

---

### §105 — Epic Games Auth Endpoints (EpicAuthClient)

`app/revanced/extension/gamehub/EpicAuthClient.java`

| Endpoint | Purpose |
|---------|---------|
| `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token` | Exchange code → access+refresh token |
| `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange` | Get one-time exchange code from access token |

Token grant types: `authorization_code` (from PKCE) and `refresh_token`; both use `token_type=eg1`.

User agent: `UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit` (impersonates Epic Games Launcher 11.0.1)

`getExchangeCode(accessToken)` — GET to exchange URL, extracts `.code` field from JSON.

ISO 8601 date parser: custom hand-rolled formula (no library dependency).

---

### §106 — GOG Token Refresh Details (GogTokenRefresh)

`app/revanced/extension/gamehub/GogTokenRefresh.java`

Full token refresh URL template:
```
https://auth.gog.com/token?client_id=46899977096215655&client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9&grant_type=refresh_token&refresh_token=<token>
```

On success, updates `bh_gog_prefs`:
- `access_token` → new token
- `refresh_token` → new refresh token (if provided)
- `bh_gog_login_time` → current Unix time (seconds)
- `bh_gog_expires_in` → hardcoded `3600` regardless of response

---

### §107 — Steam Image CDN Layer (SteamCdnHelper)

`app/revanced/extension/gamehub/network/SteamCdnHelper.java`

**CDN URLs**:
- `https://cdn-library-logo-global.bigeyes.com/` — Primary game image CDN (XiaoJi proprietary, "bigeyes.com" brand)
- `https://shared.steamstatic.com/store_item_assets/` — Steam CDN fallback
- `https://api.steampowered.com/IStoreBrowseService/GetItems/v1/` — Steam store API for batch URL resolution

**URL rewriting**: Both `bigeyes.com` paths and `"steam/"` relative paths are rewritten to use `shared.steamstatic.com/store_item_assets/`.

**Batch fetch request** (from Steam API):
```
GET /IStoreBrowseService/GetItems/v1/?input_json={"ids":[{"appid":N}...],"context":{"language":"english","country_code":"US"},"data_request":{"include_assets":true}}
```

Response parsing extracts `asset_url_format` + `header` filename → resolves final CDN URL.

**Cache**: `steam_cdn_cache` SharedPrefs, 7-day TTL (`604800000ms`), keys `url_<appId>` + `exp_<appId>`. In-memory L1 = `ConcurrentHashMap`. Batch size 50, delay 150ms.

**Log tag**: `GHLog.CDN`

---

### §108 — Token Provider Deep Dive (TokenProvider)

`app/revanced/extension/gamehub/token/TokenProvider.java`

**Hardcoded auth header**: `X-Worker-Auth: gamehub-internal-token-fetch-2025`

**EmuReady token service**: `https://gamehub-lite-token-refresher.emuready.workers.dev/token`

**Force-refresh endpoint**: `POST https://gamehub-lite-token-refresher.emuready.workers.dev/refresh` with `{"token": "<current>"}` + same auth header

**Resolution logic** (`resolveToken(originalToken)`):
1. If `apiSwitchPatched=true` AND `steam_storage_pref.use_external_api=true` → returns `"fake-token"` immediately (EmuReady path needs no real auth)
2. If `loginBypassed=true` → fetch from 3-level cache (L1=in-memory, L2=SharedPrefs, L3=network)
3. Otherwise → pass through original token unchanged

**3-level cache** for service token:
- L1: `AtomicReference<CachedToken>` (in-process RAM)
- L2: `token_provider_pref` SharedPrefs (`cached_token` + `cached_token_expiry`)
- L3: `GET /token` with `X-Worker-Auth` → response JSON field `"token"`
- TTL: 4 hours (`14400000ms`)
- Fallback chain: stale L1 → stale L2 → `"fake-token"` if original is null

**ReVanced patch flags** (modified by patches at injection time):
- `apiSwitchPatched = true` — indicates API-switch patch was applied
- `loginBypassed = true` — indicates login-bypass patch was applied

**Reflection bridge** to XiaoJi token: `com.xj.common.user.UserManager.INSTANCE.getToken()`

---

### §109 — AndroidManifest — BH Extension Components

`AndroidManifest.xml` registered BH extension components:

**Activities** (all `sensorLandscape`, no exported flag = not launcher-accessible):
- `GogMainActivity`, `GogLoginActivity`, `GogGamesActivity`, `GogGameDetailActivity`
- `EpicMainActivity`, `EpicLoginActivity`, `EpicGamesActivity`, `EpicGameDetailActivity`, `EpicFreeGamesActivity`
- `AmazonMainActivity`, `AmazonLoginActivity`, `AmazonGamesActivity`, `AmazonGameDetailActivity`
- `BhGameConfigsActivity` (+ `windowSoftInputMode="adjustResize"`)
- `BhDownloadsActivity`
- `FolderPickerActivity`

**Special activity**:
- `MTDataFilesWakeUpActivity` — `exported=true`, `excludeFromRecents=true`, `noHistory=true`, `taskAffinity=com.xiaoji.egggame.MTDataFilesWakeUp`

**Service**:
- `BhDownloadService` — `exported=false`, `foregroundServiceType=dataSync`

**Provider**:
- `MTDataFilesProvider` — `exported=true`, `grantUriPermissions=true`, `permission=android.permission.MANAGE_DOCUMENTS`
- Authority: `com.tencent.ig.app.revanced.extension.gamehub.filemanager.MTDataFilesProvider`

---

### §110 — AndroidManifest — Permission List

`AndroidManifest.xml` `<uses-permission>` declarations:

| Permission | Category |
|-----------|---------|
| `INTERNET`, `ACCESS_NETWORK_STATE`, `ACCESS_WIFI_STATE`, `CHANGE_NETWORK_STATE` | Network |
| `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`, `MANAGE_EXTERNAL_STORAGE` | Storage |
| `READ_MEDIA_IMAGES`, `READ_MEDIA_AUDIO`, `READ_MEDIA_VIDEO`, `READ_MEDIA_VISUAL_USER_SELECTED` | Scoped media |
| `WRITE_SETTINGS`, `KILL_BACKGROUND_PROCESSES` | System |
| `SYSTEM_ALERT_WINDOW` | Overlay (draw over other apps) |
| `QUERY_ALL_PACKAGES`, `com.android.permission.GET_INSTALLED_APPS` | App enumeration |
| `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_DATA_SYNC`, `FOREGROUND_SERVICE_MEDIA_PROJECTION`, `FOREGROUND_SERVICE_SPECIAL_USE` | Background |
| `POST_NOTIFICATIONS`, `VIBRATE` | UI / notifications |
| `RECORD_AUDIO`, `CAMERA`, `FLASHLIGHT` | Hardware (streaming / capture) |
| `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` | Location (network optimization) |
| `BLUETOOTH`, `BLUETOOTH_ADMIN`, `BLUETOOTH_SCAN`, `BLUETOOTH_ADVERTISE`, `BLUETOOTH_CONNECT` | Bluetooth (controller pairing) |
| `WAKE_LOCK` | Power |
| `HIGH_SAMPLING_RATE_SENSORS` | Sensors (gyroscope / IMU) |
| `android.hardware.usb.host` | USB host (USB controllers) |
| `CHANGE_WIFI_MULTICAST_STATE` (≤API33) | Multicast (mDNS discovery) |

---

### §111 — Steam Cloud Save Protocol (SteamCloud)

`com/xj/standalone/steam/cloud/SteamCloud.java`

Uses JavaSteam `Cloud` and `CloudClient` RPC services (via `SteamUnifiedMessages`). Key operations (method signatures recovered):

| Method | Purpose |
|--------|---------|
| `c(appId, ULong)` | `GetFilesChangelist` — get changed files list |
| `d(appId, String[], String[])` | `sendLaunchIntent` — notify Steam about game launch |
| `e(appId, filename, bytes, partIdx, partTotal, timestamp, platform, fileSize, Integer)` | `clientBeginFileUpload` / `clientCommitFileUpload` — upload save file |
| `f(appId, bool, filename, bytes)` | `downloadFile` — download a save file |
| `i(appId, timestamp, int)` | `beginAppUploadBatch` / `completeAppUploadBatch` |

Operates via `in.dragonbra.javasteam.rpc.service.Cloud` (JavaSteam protobuf RPC).

---

### §112 — GOG Install Path Delegation

`app/revanced/extension/gamehub/GogInstallPath.java`

```java
GogInstallPath.getInstallDir(context, gameId) 
    → BhStoragePath.getInstallDir(context, "gog_games", gameId)
```

This means GOG install path respects the same custom storage path logic as Epic/Amazon (`BhStoragePath.getInstallDir`).

---

*[Pass 9 complete — 16 new sections (97–112) added]*

---

## §113–§121: Amazon Download, Steam DB, BhSettingsExporter, Cloud, Epic (Pass 10 Additions)

---

### §113 — Steam Room Database Schema (xj_steam_db)

`com/xj/standalone/steam/data/db/SteamDB.java`

Room `@Database` — database name `xj_steam_db`. Three DAOs:
- `SteamUserDao` (`p()`)
- `SteamDownloadDao` (`q()`)
- `SteamUserGamesDao` (`r()`)

**`SteamUserTable` fields** (`@Entity`):

| Column | Type | Description |
|--------|------|-------------|
| `id` | Long (PK) | Internal Row ID |
| `steamId` | long | Steam ID 64-bit |
| `accountName` | String | Steam login username |
| `refreshToken` | String | Steam refresh token (used for auto-login) |
| `accessToken` | String | Steam access token |
| `personalName` | String | Display name / persona name |
| `avatarUrl` | String | User avatar URL |
| `isCurrentUser` | boolean | Whether this is the active account |
| `isRemember` | boolean | Whether login is persisted |
| `modifyTime` | long | Last modification timestamp |
| `newGuardData` | String | Steam Guard machine token |
| `extras` | Map\<String,String\> | Arbitrary extra data |

**`SteamDepotDecryptionKeyTable` fields** (`@Entity`):

| Column | Type | Description |
|--------|------|-------------|
| `id` | Long (PK) | Row ID |
| `appId` | int | Steam App ID |
| `depotId` | int | Steam Depot ID |
| `depotDecryptionKey` | String | AES depot decryption key |
| `modifyTime` | long | Timestamp |
| `extras` | Map\<String,String\> | Extra data |

**`SteamPackageLicense` fields** (`@Entity`):

| Column | Type | Description |
|--------|------|-------------|
| `id` | long (PK) | Package ID |
| `ownerId` | Integer | Account that owns the license (for family sharing) |
| `licenseType` | Integer | License type code |
| `paymentMethod` | Integer | How it was acquired |
| `purchaseCountryCode` | String | Country of purchase |
| `accessToken` | long | Package access token |
| `timeCreated` | Long | Purchase timestamp |
| `changeNumber`, `flags`, `masterPackageId`, `minuteLimit`, `minutesUsed`, `territoryCode` | Integer | Various Steam license fields |

**`SteamUserGameTable` fields** (`@Entity`):

| Column | Type | Description |
|--------|------|-------------|
| `id` | Long (PK) | Row ID |
| `userId` | long | FK → SteamUserTable |
| `appId` | int | Steam App ID |
| `name` | String | Game name |
| `lastUpdateTime` | long | Last sync timestamp |
| `extras` | Map\<String,String\> | Extra data |

---

### §114 — Amazon Download Manager Internals

`app/revanced/extension/gamehub/AmazonDownloadManager.java`

| Constant | Value | Meaning |
|---------|-------|---------|
| `MAX_PARALLEL` | 8 | Parallel download threads |
| `MAX_RETRIES` | 3 | Retries per file |
| `PROGRESS_INTERVAL` | 524288 (512 KB) | Progress callback stride |
| `COMPLETE_MARKER` | `.amazon_download_complete` | Completion sentinel file |
| `IN_PROGRESS_MARKER` | `.amazon_download_in_progress` | In-progress sentinel file |

**Manifest caching**: `filesDir/manifests/amazon/<versionId>.proto`

**Debug output**: `bh_amazon_debug.txt` in `getExternalFilesDir(null)` (or `filesDir` fallback)

**File verification**: SHA-256 computed in 65536-byte chunks

**Install flow** (`install(context, game, token, installDir, progressCallback, cancelChecker)`):
1. Get download URL via `AmazonApiClient.getGameDownload(token, entitlementId)`
2. Fetch `manifest.proto` from `downloadUrl/manifest.proto`
3. Parse `AmazonManifest` (XZ/LZMA decompression)
4. Download all files in parallel (8 threads), 3 retries each
5. SHA-256 verify each file
6. Write `.amazon_download_complete` sentinel

---

### §115 — BhSettingsExporter Config Export

`app/revanced/extension/gamehub/BhSettingsExporter.java`

Hardcoded version: `BH_VERSION = "3.5.0"`

**Export metadata** included in every config JSON:
- `app_source = "bannerhub"`
- `device = Build.MANUFACTURER + " " + Build.MODEL`
- `soc` = detected SOC string
- `bh_version = "3.5.0"`
- `upload_token` = random 16-char hex (used as online config key)
- `settings_count` = number of settings keys in `pc_g_setting<gameId>`

**Export directory**: `BannerHub/configs` (on external storage)

**Sources SharedPrefs**: `banners_sources` (tracks which component sources are enabled)

**Reflection call**: `com.xj.landscape.launcher.ui.menu.ComponentInjectorHelper` is called via reflection to build the components array embedded in exported configs.

**Upload path**: POST to `https://bannerhub-configs-worker.the412banner.workers.dev/upload`

---

### §116 — ContentDownloader Depot Pipeline

`com/xj/standalone/steam/contentdownloader/ContentDownloader.java`

Implements `IContentDownloader`. Key coroutine pipeline methods:

| Method | Purpose |
|--------|---------|
| `a()` | Entry point — gets `ContentServerDirectoryService` (throws if null) |
| `c(entity, appId, depotId, CDNPool, manifest, key, branch, password, globalStats, depotStats, callback, scope, extend)` | Phase 1: enumerate files from manifest, filter by existing |
| `e(...)` | Phase 2: download depot files (parallel, with tracking) |
| `f(entity, appId, depotId, CDNPool, filesData, callback, scope, extend)` | Phase 3: merge/commit downloaded chunks |
| `g(entity, appId, depotId, CDNPool, filesData, chunkData, scope, callback)` | Download single chunk |
| `h(entity, appId, depotId, filesData, callback, scope, extend)` | Verify + finalize install |
| `i(entity, appId, depotId, filesData, fileData, scope, callback)` | Download single file |
| `d(appId, installScripts, unknownScripts, file)` | Detect `installscript.vdf` files (Steam post-install scripts) |

VDF install script detection: matches filename containing `"installscript"` and ending with `".vdf"`.

---

### §117 — SteamIPs China Routing Detail

`com/xj/standalone/steam/SteamIPs.java` (additional detail)

China-specific CM server routing (used by `FastestHostFinder.e()`):
- Servers with `-hkg` in hostname = **Hong Kong** Steam CM cluster
- Servers with `-tyo` in hostname = **Tokyo** Steam CM cluster
- When `isChinaIP()` callback returns true → **only** HKG/TYO servers are tried
- When false → HKG/TYO servers are **excluded**

This means Chinese users are routed to nearby Steam CMs for lower latency, while international users avoid them.

`l(response)` parses the DNS pool JSON (field path: `data.dns_pool` as array of `{url_address, ip_address[]}`) — this is served from the BannerHub/XiaoJi backend API.

---

### §118 — Steam Module App Entry Point (SteamModuleApp)

`com/xj/module/steam/SteamModuleApp.java`

The Steam module's application-level initializer. Registers:
- `SteamService` — foreground service for persistent Steam CM connection
- `SteamDownloadCallback` — module-level download event callbacks
- `SteamDownloadInfoWrapper` — wraps download state for the UI layer

Key services: `com.xj.module.steam.SteamService`

---

### §119 — Steam Download Marker Files

From across the Steam download pipeline:

| File | Location | Meaning |
|------|---------|---------|
| `<manifestId>` | `filesDir/steam_download_cache/manifest/` | Cached manifest data |
| `<manifestId>.tmp` | Same dir | In-progress manifest download |
| `installscript.vdf` | Game install dir | Steam post-install scripts (Wine runs these) |
| `.bh_injected` | Component dir | Marks component as BH-injected (from `ComponentInjectorHelper`) |
| `server_list.bin` | `filesDir/` | Steam CM server list protobuf |
| `steam_cdn_cache` | SharedPrefs | Per-appId CDN URL cache |
| `token_provider_pref` | SharedPrefs | BannerHub service token cache |

---

### §120 — BannerHub Extension GHLog Tags (complete list)

`app/revanced/extension/gamehub/util/GHLog.java`

All 13 log tag enum values confirmed:

| Enum | Android Log Tag |
|------|---------------|
| `GHLog.TOKEN` | `GHL/TOKEN` |
| `GHLog.CDN` | `GHL/CDN` |
| `GHLog.GAME_ID` | `GHL/GAME_ID` |
| `GHLog.EPIC` | `GHL/EPIC` |
| `GHLog.GOG` | `GHL/GOG` |
| `GHLog.AMAZON` | `GHL/AMAZON` |
| `GHLog.DOWNLOAD` | `GHL/DOWNLOAD` |
| `GHLog.STORAGE` | `GHL/STORAGE` |
| `GHLog.CLOUD_EPIC` | `GHL/CLOUD_EPIC` |
| `GHLog.CLOUD_GOG` | `GHL/CLOUD_GOG` |
| `GHLog.PERF` | `GHL/PERF` |
| `GHLog.COMPAT` | `GHL/COMPAT` |
| `GHLog.WINE` | `GHL/WINE` |

All tags use `GHL/` prefix — filter with `adb logcat -s "GHL/*"` to see all BannerHub extension logs.

---

### §121 — Steam Store / China Store Switching

`com/xj/standalone/steam/sdk/SteamApiUrls.java` + `SteamSdk`

The Steam integration checks `SteamSdk.a.v()` (returns current `LanguageName` enum) and switches between:

| Store | URL Used |
|-------|---------|
| International | `https://store.steampowered.com` + `https://api.steampowered.com` |
| Chinese (`LanguageName.Chinese`) | `https://store.steamchina.com` (for store pages) + `api.steampowered.com` (unchanged) |

Chinese event requests additionally append `&lang_list=6_0` to news/event API calls.

This enables the Steam integration to function for users in China (where `store.steampowered.com` is blocked) by transparently redirecting to the China-licensed Steam storefront.

---

*[Pass 10 complete — 9 new sections (113–121) added]*

---

## §122–§131: Storage, Launch, WinEmu, Component, Game Data (Pass 11 Additions)

---

### §122 — Steam Avatar CDN Variants

From `com/xj/standalone/steam/` URL scan:

| CDN | URL Pattern |
|-----|------------|
| Cloudflare (primary) | `https://avatars.cloudflare.steamstatic.com/<hashFull>_full.jpg` |
| Akamai (fallback) | `https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/<prefix>/<hash>_full.jpg` |
| Default avatar | `fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg` (hardcoded fallback) |
| Game images | `https://shared.cloudflare.steamstatic.com/store_item_assets/steam/apps/<appId>/<filename>` |

---

### §123 — Steam Price API

`com/xj/standalone/steam/data/bean/price/` + URL grep:

```
GET https://store.steampowered.com/api/appdetails/?appids=N1,N2,N3&cc=<countryCode>&filters=price_overview
```

- Accepts comma-separated list of App IDs
- `cc` = 2-letter country code from current `LanguageName` setting
- `filters=price_overview` → returns only price data (not full app info)
- Used to display localized game prices in the BannerHub store UI

---

### §124 — XiaoJi API Server Environments

From `ServerEnv` enum usage:

| Environment | URL |
|------------|-----|
| Production (`PRODUCT`) | `https://landscape-api.vgabc.com/` |
| Beta (`BETA`) | `https://landscape-api-beta.vgabc.com/` |
| Development | `https://dev-gamehub-api.vgabc.com/` |
| Test (standalone) | `https://test-landscape-api.vgabc.com/` |

Additional XiaoJi infrastructure endpoints:
- `https://clientgsw.vgabc.com/clientapi/` — Client gateway API (bypasses signature verification per source comment)
- `https://statistic-gamehub-api.vgabc.com/events` — Analytics/event tracking
- `https://clientegg.vgabc.com/uxapi/` — UX download reporting
- `https://gamehub.xiaoji.com` — GameHub help portal
- `https://doc.xiaoji.com/help.html?lang=...&device=...&platform=gsw` — Help documentation
- `https://doc.xiaoji.com/selectdevice.html?lang=...&platform=gsw` — Device selection guide
- `https://www.xiaoji.com/url/gsw-app-rules` — Privacy policy / EULA

---

### §125 — Debug/Development Leftovers

From URL grep:

**Local development server** (hardcoded debug URL, never stripped from production build):
```
http://192.168.31.136:8888/api/apps/<appId>/<buildId>
http://192.168.31.136:8888/api/apps/<appId>/history
```
These are a developer's local machine IP. The same IP appears in at least two places in the source.

**Connectivity check**:
```
http://connectivitycheck.gstatic.com/generate_204
```
Used to verify internet connectivity (standard Android pattern).

---

### §126 — Xbox Game Pass WebView Integration

From URL grep and WebView allowlist:

- WebView origin allowlist: `https://*.xbox.com` (explicitly whitelisted)
- Xbox Game Pass URL format in use: `https://www.xbox.com/play/games/<title>/<product-id>?experience=share-link&...`
- Xbox Cloud Gaming redirected to: `https://www.xbox.com/en-AU/play/` → `https://www.xbox.com/play/` (AU → global)

Test game entries (hardcoded test data):
- *A Plague Tale: Requiem* — `9ND0JVB184XL`
- *DIRT 5* — `9PJGM0T0827V`
- PlayStation Store test: `https://store.playstation.com/zh-cn/product/HP6245-PPSA02585_00-CNRELGENSHIN0000` (Genshin Impact PS5 China)

---

### §127 — BannerHub Image CDN (bigeyes.com)

From URL grep:

**Game image CDN base**: `https://uxdl.bigeyes.com/ux-landscape/game-image/`

Example: `https://uxdl.bigeyes.com/ux-landscape/game-image/3a2a/59/af/3a2a59af8fe619fd75d7945c90fecd39.png`

CDN path structure: `ux-landscape/game-image/<4-char-prefix>/<2-char>/<2-char>/<full_hash>.png`

In CDN rewriting logic, `https://cdn.cloudflare` URLs are passed through without rewriting — Cloudflare Steam CDN URLs survive unchanged.

Also noted: `https://uxdl.bigeyes.com` is the domain used for BannerHub-sourced game images (as opposed to Steam's own CDN). The library logo CDN (`cdn-library-logo-global.bigeyes.com`) is the Steam-game-logo variant.

---

### §128 — Steam Login Modes (SteamAuthService)

`com/xj/module/steam/service/SteamAuthService.java`

Implements `ISteamAuthService`. Two login methods:

1. **Credentials login** (`authViaCredentials(username, password, remember, authenticator)`):
   - Calls `SteamAuthApi.a` (from `com.xj.standalone.steam.sdk.auth`)
   - Returns `SteamUser(accountName, avatarUrl)`
   - `IAuthenticator` parameter handles 2FA prompts (Steam Guard / TOTP)

2. **QR Code login** (`authViaQRCode(qrUrlCallback)`):
   - Calls `SteamAuthApi.a`
   - Callback receives the QR URL string → app renders it for user to scan
   - Returns `SteamUser(accountName, avatarUrl)` on success

Other operations:
- `isSignedIn()` → checks current session status
- `currentUser()` → returns current `SteamUser`
- `subjectCurrentUser` → `Flow<SteamUser>` reactive stream
- `signOut()` → ends session

---

### §129 — MovingCloud SDK Integration

From `TYMovingManager` initialization in app startup:

```java
TYMovingManager.Companion.init(application)
    .setCoroutineScope(scope, Dispatchers.Main)
    .setWssConnectUrl("")          // WSS disabled (empty)
    .setWssConnectTimeout(15L)
    .setWssConnectionLostTimeout(5L)
    .setWssReconnectFrequency(60)
    .setServerAddress("https://hubble.movingcloudgame.com/")
    .setShowLog(true)
    .build();
```

- **MovingCloud** (`movingcloudgame.com`) is a Chinese cloud gaming streaming SDK
- WSS URL is empty → real-time streaming over WebSocket is not currently active
- Server configured but no active connection established on startup
- This is the `com.xj.cloud` module's underlying streaming infrastructure

---

### §130 — XiaoJi Cloud Gaming Module (com.xj.cloud)

From class scan:

`LauncherCloudGameActivity` — the main cloud gaming activity, with at least 9 event observers (`receiveEvent$default$1` through `$9`). Handles display/layout adjustments for cloud streaming viewport.

The cloud gaming module appears to be a streaming client (possibly thin-client game streaming from cloud servers), separate from the local Wine/Winlator PC game execution.

`com.xj.cloud.ui.AndroidBug5497Workaround` — keyboard resize workaround (standard Android pattern for keyboard overlap with streaming view).

---

### §131 — BH Extension file: EpicFreeGamesActivity

`app/revanced/extension/gamehub/EpicFreeGamesActivity.java` (506 lines)

Displays Epic Games free-game promotions. Key URLs it would use:
- Queries `EpicApiClient.LIBRARY_URL` and `EpicApiClient.CATALOG_BASE` for active free game offers
- Uses the same Epic credentials (`CLIENT_ID`, `CLIENT_SECRET`) as the main store integration
- Separate activity from `EpicGamesActivity` — specifically for the "free games" tab

---

*[Pass 11 complete — 10 new sections (122–131) added]*

---

## §132–§144: MitmProxy, ADB, Steam Auth, Signing, Firebase, GOG Launch (Pass 12 Additions)

---

### §132 — SteamSdk Complete OkHttp Architecture

`com/xj/standalone/steam/sdk/SteamSdk.java` (590 lines, singleton `SteamSdk.a`)

**Two OkHttp client variants** (lazy-initialized):
- `t()` → `i(false)` — no DNS routing, no `SteamIpStateInterceptor` (for general Steam HTTP)
- `u()` → `i(true)` — DNS routing + `SteamIpStateInterceptor` (for Steam API calls tracking timeouts)

**`i(boolean z)` — OkHttp client factory**:
1. If `z=true`: custom DNS resolver — checks `isChinaIP` callback; if true, routes `store.steampowered.com` and `api.steampowered.com` through `SteamIPs.e()` IP pool
2. SSL: `sslSocketFactory(r(), y())` — `DelegateSSLSocketFactory` wrapping system TLS
3. `hostnameVerifier(j)` — always returns `true` (disables hostname verification)
4. If `z=true`: adds `SteamIpStateInterceptor` (tracks timeout failures per IP)
5. Interceptor `k()`: adds `User-Agent: Valve/Steam HTTP Client 1.0` to every request
6. Timeouts: 20000ms all (connect/read/write)
7. Dispatcher: `maxRequests = steamConfig.h() * 3`, `maxRequestsPerHost = steamConfig.i()`
8. ConnectionPool: `steamConfig.h() * 2` connections, TTL = `steamConfig.d()` seconds

**Trust manager `y()`**:
```java
checkClientTrusted(chain, authType) { /* empty */ }
checkServerTrusted(chain, authType) { /* empty */ }
getAcceptedIssuers() { return new X509Certificate[0]; }
```
Accepts any certificate from any issuer — full TLS pinning bypass.

**`r()` SSL factory**: `SSLContext.getInstance("TLS")` + `DelegateSSLSocketFactory(socketFactory, SteamConfig.a.m())` — `m()` is the `isChinaIP` callback.

**Static debug flag**: `SteamSdk.d` (boolean) — toggled via `F(boolean)`, controls verbose logging mode.

---

### §133 — XjSteamClient: Steam CM Connection Wrapper

`com/xj/standalone/steam/wrapper/XjSteamClient.java` (882 lines)

Central wrapper around JavaSteam's `SteamClient`. One instance per active Steam account.

**Configuration** (via `Companion.d()`):
- HTTP client: `SteamAPI.a.q()` (BH OkHttp with no-verify SSL)
- Protocol: `TCP + UDP` both enabled (`EnumSet.of(ProtocolTypes.TCP, ProtocolTypes.UDP)`)
- Server list: `SteamConfig.a.e()` → `GHFileServerListProvider`

**Factory methods**:
- `Companion.b()` — create new client (logs "create new steam client")
- `Companion.c(client)` — clone from existing client (copies callbacks and user)

**Fields**:

| Field | Type | Purpose |
|-------|------|---------|
| `a` | SteamConfiguration | Immutable config |
| `b` | Mutex | Serializes connect/auth |
| `c` | ExecutorCoroutineDispatcher | Single-thread Steam IO |
| `d` | CoroutineScope | "XjSteamScope" for CM callbacks |
| `e` | CoroutineScope | "XjSteamAuthScope" for auth flow |
| `f` | SteamClient | JavaSteam client |
| `g` | List<SessionCallback> | Registered callbacks |
| `h` | Lazy<XjSteamAuthentication> | Auth session factory |
| `l` | XjSteamUser | Current user (username + refreshToken) |
| `n` | long | Connect timeout = 10 seconds |
| `p` | Function2 | `findHostPort` — fastest host finder |
| `q` | Long | Cached steamId64 |

**Handler accessors**:

| Method | Handler |
|--------|---------|
| `B()` | SteamApps |
| `D()` | SteamContent |
| `E()` | SteamFriends |
| `G()` | SteamUnifiedMessages |
| `H()` | SteamUser |
| `I()` | SteamUserStats |
| `z()` | Player (RPC service, via SteamUnifiedMessages) |

**Key methods**:
- `L()` — `isLoggedIn()`: `this.j && steamClient.isConnected && !steamClient.isDisconnected`
- `M()` — `logOff()`: calls `SteamUser.logOff()`, sets `k=false`
- `v()` — `getCellId()`: returns `steamClient.getCellID()` (used for CDN cell assignment)
- Callback dispatch: `postCallback` → coroutine on `d` scope → `forEachCallbacks(s)`

---

### §134 — PSPlayNative: Chiaki JNI Layer

`com/xj/psplay/lib/PSPlayNative.java` (265 lines)

PlayStation Remote Play integration built on the **Chiaki** open-source library.

**Native library**: `System.loadLibrary("xjps-jni")` → `libxjps-jni.so`

**JNI method surface**:

| Method | Purpose |
|--------|---------|
| `discoveryServiceCreate` | Create PS console discovery service |
| `discoveryServiceFree(ptr)` | Release discovery service |
| `discoveryServiceWakeup(ptr, host, regist_key, broadcast)` | Wake console via UDP broadcast |
| `registStart(result, info, log, regist)` | Initiate PS console pairing/registration |
| `registStop(ptr)` | Abort registration |
| `registFree(ptr)` | Release registration resources |
| `sessionCreate(result, connectInfo, passcode, video, session)` | Create streaming session |
| `sessionFree(ptr)` | Release session |
| `sessionJoin(ptr)` | Connect session |
| `sessionStart(ptr)` | Start streaming |
| `sessionStop(ptr)` | Stop streaming |
| `sessionSetControllerState(ptr, state)` | Send gamepad input |
| `sessionSetLoginPin(ptr, pin)` | Enter PS login PIN |
| `sessionSetSurface(ptr, surface)` | Bind Android Surface for video decode |
| `videoProfilePreset(fps, bps, codec)` | Get video quality preset |
| `errorCodeToString(code)` | Error code → string |
| `quitReasonToString(code)` | Quit reason → string |
| `quitReasonIsError(code)` | Is quit reason an error |

This is the complete Chiaki-based PS Remote Play JNI bridge — supports PS4 and PS5 streaming.

---

### §135 — GameHubPrefs: Central BH Settings Store

`app/revanced/extension/gamehub/prefs/GameHubPrefs.java`

**SharedPrefs file**: `steam_storage_pref`

**Settings keys and defaults**:

| Key | Type | Default | Purpose |
|-----|------|---------|---------|
| `api_source` | int | `0` | Active API: 0=official, 1=EmuReady, 2=BannerHub |
| `last_api_source` | int | `0` | Last used API (for change detection) |
| `cpu_usage_display` | bool | `true` | Show CPU usage overlay |
| `perf_metrics_display` | bool | `true` | Show perf metrics overlay |
| `log_all_requests` | bool | `false` | Log every HTTP request |
| `use_custom_storage` | bool | `false` | Enable custom install path |
| `steam_storage_path` | string | `""` | Custom install path root |

**API source cycling**: `(current + 1) % 3` — cycles Official → EmuReady → BannerHub → back.

**URL resolution** (`getEffectiveApiUrl(path)`):
- If source changed since last, clears game settings cache (`pc_g_setting` SharedPrefs)
- Appends `path` to the active API base URL

**API base URLs** (also in `TokenProvider`):
- `0`: `https://landscape-api.vgabc.com/` (Official XiaoJi)
- `1`: `https://gamehub-lite-api.emuready.workers.dev/`
- `2`: `https://bannerhub-api.the412banner.workers.dev/`

---

### §136 — BhStoragePath: Unified Install Path Management

`app/revanced/extension/gamehub/BhStoragePath.java`

Resolves game install base directory for all stores.

```
Standard (filesDir):    <filesDir>/<store>/
Custom storage:         <customPath>/bannerhub/<store>/
```

**Store subdirectory names** (from calling code):
- `"gog_games"` — GOG Galaxy games (`GogInstallPath`)
- Epic and Amazon use `context.getExternalFilesDir(null)` directly (not via BhStoragePath)

---

### §137 — GOG Galaxy Integration Details

From `GogDownloadManager.java` and `GogInstallPath.java`:

**Install path**: `BhStoragePath.getInstallDir(context, "gog_games", title)`
→ either `filesDir/gog_games/<title>/` or `<custom>/bannerhub/gog_games/<title>/`

**SharedPrefs**: `bh_gog_prefs`
- `gog_exe_<gameId>` — path to the game's main executable
- `gog_dir_<gameId>` — installed game directory

**GOG game downloader thread naming**: `"gog-dl-<gameId>"`

**GOG cloud save threads**: `"epic-cloud-upload-<gameId>"` / `"epic-cloud-download-<gameId>"`
(Note: the naming uses "epic-cloud" prefix even for GOG cloud saves — likely a copy-paste artifact.)

**GOG goggame file detection**: skips files starting with `"goggame-"` (metadata, not game content)

---

### §138 — PlaytimeHelper: Cross-Isolation SQLite Access

`app/revanced/extension/gamehub/playtime/PlaytimeHelper.java`

The BannerHub extension reads the XiaoJi host app's `xj_steam_db` directly via `SQLiteDatabase.openDatabase()` — bypassing Room entirely.

**SQL used**:
```sql
SELECT id FROM steam_account WHERE is_current_user = 1 LIMIT 1
```

This retrieves the current Steam user's internal DB row ID, then queries play time statistics linked to that user ID.

**Reveals**: The Steam user table is actually named `steam_account` in the raw SQLite schema (Room maps it, but the physical table name differs from the `SteamUserTable` entity name noted in §110).

**New GHLog tag found**: `GHLog.PLAYTIME` — was missing from the §120 log tag table.

Updated complete tag list (14 tags total):
`TOKEN, CDN, GAME_ID, EPIC, GOG, AMAZON, DOWNLOAD, STORAGE, CLOUD_EPIC, CLOUD_GOG, PERF, COMPAT, WINE, PLAYTIME`

---

### §139 — SteamGameUpdateChecker

`com/xj/standalone/steam/sdk/update/SteamGameUpdateChecker.java` (singleton `SteamGameUpdateChecker.a`)

Manages Steam game update detection.

| Method | Purpose |
|--------|---------|
| `c(appId)` | `getUpdateInfo(appId)` — returns update info for app |
| `d(appId, buildId)` | `getUpdateInfoByBuildId(appId, buildId)` — check specific build |
| `e(appId)` | `hasAppUpdate(appId)` — boolean update check |

Logger: `"Steam.SteamGameUpdateChecker"`

Relies on `DepotFileManager` for file state and `SteamPicsApi` for manifest info.

---

### §140 — DepotFileManager

`com/xj/standalone/steam/sdk/update/DepotFileManager.java` (singleton `DepotFileManager.a`)

Manages reading/writing depot files to disk.

| Method | Purpose |
|--------|---------|
| `c(installInfo, appId, manifestId, depotId, fileData, chunkData)` | Write single chunk to depot file |
| `d(installInfo, appId, manifestId, depotId, fileData)` | Finalize/commit entire depot file |
| `f(appId)` | `getRelativeAppInstallDirPath(appId)` — get relative dir within install root |

Dependencies: `SteamGameInfoQuery` (lazy field `c`) — queries app info to find install directory names from VDF `installdir` key.

Logger: `"Steam.DepotFileManager"`

---

### §141 — SteamUserApi: Steam Level Lookup

`com/xj/standalone/steam/sdk/user/SteamUserApi.java` (singleton `SteamUserApi.a`)

Single method: `a()` = `getSteamLevel()`.

Call chain:
```
SteamUserApi.a() → SteamSdk.q() [getClient] → XjSteamClient → XjSteamClient.z() [Player service]
                                                                → Player.getGameBadgeLevels / getPlayerLinkDetails
```

On error: throws `XjErrorCodeException(ErrorCode.ConnectFailed)` — signals the UI to show "not connected" state.

---

### §142 — BhWineLaunchHelper: Wine Binary Discovery

`app/revanced/extension/gamehub/BhWineLaunchHelper.java`

Companion to `AmazonLaunchHelper` — provides system-level Wine binary detection.

**`findWineBinary()`**: scans `/proc/<pid>/comm` for running processes. Looks for:
- `"wine64"`, `"wine"`, `"wineloader"`, `"wine64-preloader"`
Checks `WINELOADER` env var first, then falls back to process scan. Returns the parent directory of the Wine binary.

**`getWinePrefix()`**: returns current Wine prefix directory.

**`getWineEnviron()`**: reads environment of running Wine process from `/proc/<pid>/environ`, splits on `\0` separator.

**`listDir(path)`**: returns array of filenames in a directory.

**`isLaunchable(path)`**: checks if file extension indicates a launchable executable (likely `.exe`).

**`launchExe(context, path)`**: launches a Wine executable — wraps path in `winhandler.exe` call, dispatches on background thread.

---

### §143 — SteamGameApi: App Metadata and Online Counts

`com/xj/standalone/steam/sdk/game/SteamGameApi.java` (831 lines, singleton `SteamGameApi.a`)

**Two OkHttp clients**:
- `w()` — Steam SDK client (`SteamSdk.a.t()`) — full trust-bypass client
- `v()` — standalone clean client (15s timeouts, no SSL bypass) — for dev/debug endpoints

**`OnlineCountCache`** inner class: holds `(playerCount: Long, timestamp: Long)` — expires based on TTL check `(now - timestamp) > ttl`.

**Concurrent cache**: `ConcurrentHashMap d` — keyed by appId for online player count caching.

**Methods** (from lambda class names):
- `j(appId)` = `getAppInfo(appId)` — primary PICS lookup
- `getAgeRatings(appId)` — PICS age rating
- `getAgeRatingsOrCache(appId)` — cached age rating
- `getAppIdToGenresMap()` — all genres in PICS DB
- `getAppInfos(appIds)` — bulk app info
- `getAppKeyValue(appId, buildId)` — fetches `http://192.168.31.136:8888/api/apps/<appId>/<buildId>` (dev endpoint)
- `getGenresToAppIdsMap()` — genres → app IDs
- `getLastUpdateVersion(appId)` — fetches `http://192.168.31.136:8888/api/apps/<appId>/history` (dev endpoint)
- `getNewestVersion(appId)` — newest Steam build for app
- `getOnlineUserCount(appId)` — player count (uses `SteamApiUrls.e()`)
- `getOwnedGames()` — all owned games for current user
- `requestAndWriteAgeRating(appId)` — fetches + caches age rating
- `subjectOwnedGameAppIds` — reactive `Flow<List<Int>>` of owned app IDs
- `subjectOwnedGames` — reactive `Flow<List<SteamPicsAppInfo>>` of owned game objects

---

### §144 — SteamSdk Coroutine Scope and Account Flow

`com/xj/standalone/steam/sdk/SteamSdk.java` (continued)

**Default scope** (`s()`): lazy-initialized supervisor scope on `Dispatchers.Default` with `CoroutineExceptionHandler` — survives individual job failures.

**`H()` = `subjectCurrentAccount()`**: reactive `Flow<XjSteamUser?>` — combination of `flatMapLatest`/`filter`/`map` operators on internal state, emits the current logged-in account (or null on logout).

**`h()` = `checkSync()`**: coroutine that:
1. Calls `l()` (getCurrentUser from DB)
2. If user found, calls `SteamPicsApi.m(user)` to sync PICS data
3. Returns `false` if no user, otherwise PICS sync result

**`G(languageName)`** = `setLanguage(value)`: updates `SteamSdk.c` (static current language), then re-runs `launch()` to apply language-dependent API routing changes.

**`A()`** = `isDebugMode()`: returns the static `d` flag.

---

*[Pass 12 complete — 13 new sections (132–144) added]*

---

## §145–§157: Heartbeat, Analytics, WeChat, Push, Device (Pass 13 Additions)

---

### §145 — Epic Games Complete API Surface

`app/revanced/extension/gamehub/EpicApiClient.java`

**Endpoint constants**:

| Constant | URL |
|----------|-----|
| `CATALOG_BASE` | `https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace` |
| `LIBRARY_URL` | `https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true` |
| `MANIFEST_BASE` | `https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace` |

**Asset download URL** (constructed):
```
MANIFEST_BASE/<namespace>/catalogItem/<catalogItemId>/app/<appName>/label/Live
```

**User-Agent**: `"Legendary/0.1.0 (GameNative)"` — impersonates the Legendary open-source EGS client.

**Auth header** on all requests: `Authorization: Bearer <accessToken>`

---

### §146 — Epic Games Auth Client Credentials

`app/revanced/extension/gamehub/EpicAuthClient.java`

| Constant | Value |
|----------|-------|
| `CLIENT_ID` | `34a02cf8f4414e29b15921876da36f9a` |
| `CLIENT_SECRET` | `daafbccc737745039dffe53d94fc76cf` |

These are the Epic Games EGS Launcher OAuth credentials (publicly known, used by many third-party EGS clients).

**Token URL**: `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token`

**Exchange URL**: `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange`

---

### §147 — Epic Games Login WebView (OAuth2)

`app/revanced/extension/gamehub/EpicLoginActivity.java`

**Login URL** (WebView):
```
https://www.epicgames.com/id/login?redirectUrl=https%3A%2F%2Fwww.epicgames.com%2Fid%2Fapi%2Fredirect%3FclientId%3D34a02cf8f4414e29b15921876da36f9a%26responseType%3Dcode
```

**Redirect host**: `https://www.epicgames.com/id/api/redirect`

Flow: WebView loads login page → user signs in → Epic redirects to `REDIRECT_HOST` → BH intercepts redirect → extracts authorization code → sends to `EpicAuthClient` to exchange for `bearer`+`eg1` tokens.

---

### §148 — GOG Galaxy Login WebView (OAuth2)

`app/revanced/extension/gamehub/GogLoginActivity.java`

**Login URL** (WebView):
```
https://auth.gog.com/auth?client_id=46899977096215655&redirect_uri=https%3A%2F%2Fembed.gog.com%2Fon_login_success%3Forigin%3Dclient&response_type=token&layout=client2
```

**Success redirect check**: `https://embed.gog.com/on_login_success` — BH intercepts this URL, extracts the access token from the fragment.

**User data endpoint**: `https://embed.gog.com/userData.json`

**GOG ClientId** (public): `46899977096215655`

Note: `response_type=token` means GOG uses implicit grant (token in URL fragment directly).

---

### §149 — GOG Galaxy Download System URLs

`app/revanced/extension/gamehub/GogDownloadManager.java` (major class)

**Build listing**:
- Gen2 (primary): `https://content-system.gog.com/products/<gameId>/os/windows/builds?generation=2`
- Gen1 (fallback): `https://content-system.gog.com/products/<gameId>/os/windows/builds?generation=1`

**Product details** (for downloads metadata):
```
https://api.gog.com/products/<gameId>?expand=downloads
```

**Download file hosting**: follows redirect chain from `https://www.gog.com` (CDN URLs served after redirect).

**GOG client header** (`User-Agent`): `"GOG Galaxy"` — impersonates the official GOG Galaxy client.

**Thread naming**: `"gog-dl-<gameId>"`

---

### §150 — Epic Games Cloud Save

`app/revanced/extension/gamehub/EpicCloudSaveManager.java`

**Cloud storage base**: `https://datastorage-public-service-liveegs.live.use1a.on.epicgames.com/api/v1/access/egstore/savesync/`

**Upload thread**: `"epic-cloud-upload-<appName>"`
**Download thread**: `"epic-cloud-download-<appName>"`

**Flow**: get valid access token → get account ID → enumerate local save files → request upload links from cloud service → upload files → mark done.

---

### §151 — GOG Galaxy Cloud Save

`app/revanced/extension/gamehub/GogCloudSaveManager.java`

**Cloud storage base**: `https://cloudstorage.gog.com/v1/`

**Inline token refresh** (independent of GogTokenRefresh.java):
```
https://auth.gog.com/token?client_id=<id>&client_secret=<secret>&grant_type=refresh_token&refresh_token=<token>
```
Both `GogTokenRefresh.java` (§99) and `GogCloudSaveManager.java` independently implement token refresh — the cloud save manager has its own inline refresh logic.

---

### §152 — Amazon Login: OpenID + PKCE Flow

`app/revanced/extension/gamehub/AmazonLoginActivity.java`

Amazon uses **OpenID Connect + PKCE** (not standard OAuth2):

**Login URL** (WebView) — abbreviated:
```
https://www.amazon.com/ap/signin?
  openid.oa2.response_type=code&
  openid.oa2.code_challenge_method=S256&
  openid.oa2.client_id=device:<clientId>&
  openid.assoc_handle=amzn_sonic_games_launcher&
  pageId=amzn_sonic_games_launcher&
  openid.oa2.code_challenge=<S256_challenge>
```

**Per-session fresh values** (generated via `AmazonPKCEGenerator`):
- `deviceSerial` — random device identifier
- `clientId` — derived from `deviceSerial`
- `codeVerifier` — random PKCE verifier
- `codeChallenge` — SHA-256 of `codeVerifier`

**Association handle**: `amzn_sonic_games_launcher` — identifies as the "Sonic" launcher (Amazon Gaming launcher)

**Marketplace**: `ATVPDKIKX0DER` (US Amazon marketplace)

After auth: redirect intercepted → auth code extracted → exchanged for bearer + DMS tokens via `AmazonAuthClient`.

---

### §153 — BhGameConfigsActivity: Config Hub

`app/revanced/extension/gamehub/BhGameConfigsActivity.java`

Central activity for managing and sharing BannerHub game configs.

**Endpoints**:

| Constant | URL |
|----------|-----|
| `STEAM_HEADER` | `https://cdn.akamai.steamstatic.com/steam/apps/%s/header.jpg` |
| `STEAM_SEARCH` | `https://store.steampowered.com/api/storesearch/?l=english&cc=us&term=` |
| `WORKER` | `https://bannerhub-configs-worker.the412banner.workers.dev` |

**SharedPrefs used**:
- `bh_steam_covers` — Steam game cover image cache
- `bh_config_reports` — Report IDs for configs flagged by users
- `bh_config_uploads` — Config upload tokens
- `bh_config_votes` — User vote state per config
- `BannerHub/configs` — Export directory on external storage (same as `BhSettingsExporter`)

Steam header image URL format: `https://cdn.akamai.steamstatic.com/steam/apps/<appId>/header.jpg` (standard Steam CDN path for 460×215 header images)

---

### §154 — CompatibilityCache: BH→XiaoJi Reflection Bridge

`app/revanced/extension/gamehub/ui/CompatibilityCache.java`

Bridges compatibility data from the BH extension into the host app's `GameCompatibilityParams` class via reflection.

**Target class**: `com.xj.common.service.bean.GameCompatibilityParams`
- Constructor: `(String title, String icon, String desc, int level, List<?>)`

**Source object methods** (via reflection on cached objects):
- `getTitle()` → title string
- `getIcon()` → icon URL
- `getDesc()` → description
- `getLevel()` → compatibility level integer

**Cache key**: Steam App ID string (from `getSteamAppId()`)

This allows the BH extension to inject compatibility ratings into the XiaoJi game list UI without modifying host app code — purely via reflected constructor calls.

---

### §155 — GameIdHelper: Debug ID Overlay

`app/revanced/extension/gamehub/ui/GameIdHelper.java`

Injects two optional text views into game detail activities showing the internal IDs for debugging.

**Intent extras read**:
- `"steamAppId"` — Steam App ID (shown as `"Steam App ID: <id>"`)
- `"localGameId"` — Internal XiaoJi game ID (shown as `"Local Game ID: <id>"`)

**View IDs** (resolved dynamically via `getIdentifier()`):
- `ll_game_id_container` — parent container (hidden if both IDs empty)
- `tv_steam_app_id` — Steam ID text view
- `tv_local_game_id` — Local ID text view

Tap-to-copy: clicking either text view copies the ID to clipboard with toast notification.

---

### §156 — StorageBroadcastReceiver

`app/revanced/extension/gamehub/steam/StorageBroadcastReceiver.java`

BroadcastReceiver listening for storage events. Monitors USB/SD card attach/detach to update the custom storage path in `steam_storage_pref`. Clears the `steam_storage_path` pref when external storage is removed.

---

### §157 — AccountCurrencyHelper: Currency Display

`app/revanced/extension/gamehub/ui/AccountCurrencyHelper.java`

Displays localized currency string next to game prices in the UI.

**Static currency cache**: `sCurrency` — set once and applied to all pending `TextView` weak references.

**Format**: `"<price_string> (<currencyCode>)"` — e.g., `"$19.99 (USD)"`

Pending views are flushed atomically once the currency string is received from the API.

---

*[Pass 13 complete — 13 new sections (145–157) added]*

---

## §158–§165: SteamAgent, Steam Download, Game Manage, Cloud (Pass 14 Additions)

---

### §158 — PlayStation Network OAuth (Chiaki Integration)

`com/xj/psplay/ui/register/RegisterNicknamePSNActivity.java`

**PSN OAuth URL** (loaded in WebView for PSN account pairing):
```
https://auth.api.sonyentertainmentnetwork.com/2.0/oauth/authorize?
  service_entity=urn:service-entity:psn&
  response_type=code&
  client_id=ba495a24-818c-472b-b12d-ff231c1b5745&
  redirect_uri=https://remoteplay.dl.playstation.net/remoteplay/redirect&
  scope=psn:clientapp&
  request_locale=<locale>&
  ui=pr&service_logo=ps&layout_type=popup&smcid=remoteplay&prompt=always&
  PlatformPrivacyWs1=minimal
```

**PSN ClientId**: `ba495a24-818c-472b-b12d-ff231c1b5745` (Chiaki PS Remote Play app client)

**Redirect URI**: `https://remoteplay.dl.playstation.net/remoteplay/redirect`

**Flow**: WebView loads PSN login → user authenticates → PSN redirects to redirect_uri with auth code → BH intercepts via `shouldOverrideUrlLoading`, extracts `encodedId` from `PSInfoEntity` → proceeds to PIN code screen → completes Chiaki registration.

---

### §159 — Tencent InLong Analytics (Statistics)

`com/xj/landscape/launcher/net/tencent/TencentStatisticsHelper.java`

**Event collection endpoint**: `https://trace.inlong.qq.com/hn0_iegcommon/dataproxy/message`

This is **Tencent InLong** (formerly TDBank) — Tencent's internal data collection pipeline used across QQ/WeChat/mobile apps.

**Gate**: `LauncherUtils.a.c().getCanRequestTencentData()` — analytics only fire if user has granted consent.

**Event types** (`TencentEvent` enum values):

| Event | String | Payload format |
|-------|--------|---------------|
| `UPDATE` | `"update"` | `"pkg#<pkg>|status#<n>"` |
| `DOWNLOAD` | `"download"` | `"pkg#<pkg>|status#<n>"` |
| `INSTALL` | `"install"` | `"pkg#<pkg>|status#<n>"` |
| `CLICK` | `"click"` | `"tab#<n>|module#<type>|pos#<n>|url#<param>|name#<topic>"` |
| `SHOW` | `"show"` | — |
| `SEARCH` | `"search"` | — |
| `APP_LAUNCHER` | `"app_launcher"` | — |
| `START_GAME` | `"start_game"` | — |
| `REMOVE` | `"remove"` | — |

**Source tagging** for click events:
- `1` = Exploration tab
- `2` = Find Game tab
- `3` = Album/Collection
- `4` = Search results
- `5` = Search recommendations
- `6` = Detail page recommendations
- `7` = My Game News

---

### §160 — Tencent Operations API (Operations/Update Pushes)

`com/xj/landscape/launcher/net/tencent/TencentOperationsNetHelper.java`

**Base URLs**:
- Production: `https://release.nj.qq.com`
- Test: `https://test.nj.qq.com`

**AppId**: `8P3VT7TE`

**Signing key** (HMAC/SHA1): `b2e16d59b1f64b650fdb397d4006344908956596`

**Signature algorithm** (`j(originUri)` method):
```
plaintext = "appid=8P3VT7TE&timestamp=<ts>_<uri>_<key>"
sign = EncryptUtils.e(plaintext).toLowerCase()
result = <base>/<path>?appid=8P3VT7TE&timestamp=<ts>&sign=<sign>
```

Operations tracked (from method scan): keyword search reporting, game list event, launch event, download event, install event — similar to statistics but routed to Tencent Operations backend rather than InLong.

---

### §161 — Third CDN Domain: cdn.queniuqe.com

`com/xj/landscape/launcher/data/mock/MockUtilsKt.java` (hardcoded mock data)

**New CDN domain identified**: `https://shared.cdn.queniuqe.com`

URL pattern: `https://shared.cdn.queniuqe.com/store_item_assets/steam/apps/<appId>/<filename>?t=<timestamp>`

Examples from mock data:
- `https://shared.cdn.queniuqe.com/store_item_assets/steam/apps/1174180/header.jpg?t=1720558643`
- `https://shared.cdn.queniuqe.com/store_item_assets/steam/apps/2891120/header_alt_assets_0.jpg?t=1732875693`

This is a **third CDN mirror** for Steam game images (alongside `shared.cloudflare.steamstatic.com` and `cdn.akamai.steamstatic.com`). Same path structure as the official Steam CDN. `queniuqe.com` appears to be a XiaoJi/GameHub-operated Steam asset mirror.

**Updated complete CDN domain list**:

| Domain | Purpose |
|--------|---------|
| `shared.cdn.queniuqe.com` | XiaoJi Steam asset CDN mirror (new) |
| `shared.cloudflare.steamstatic.com` | Steam's Cloudflare CDN |
| `cdn.akamai.steamstatic.com` | Steam's Akamai CDN |
| `avatars.cloudflare.steamstatic.com` | Steam avatar Cloudflare CDN |
| `uxdl.bigeyes.com` | XiaoJi game screenshots/images CDN |
| `cdn-library-logo-global.bigeyes.com` | BH Steam game logo CDN |

---

### §162 — SteamGameDetailLaunchStrategy

`com/xj/landscape/launcher/launcher/strategy/SteamGameDetailLaunchStrategy.java`

Implements `LaunchStrategy` for opening a Steam game detail page.

**URL generated**:
```java
String.format("https://store.steampowered.com/app/%s", steamId)
```

Opens the Steam store page for the game — typically in a WebView or external browser when the user selects "View on Steam Store".

---

### §163 — DebugFragment: Developer Tools

`com/xj/landscape/launcher/ui/setting/tab/DebugFragment.java`

Developer-facing settings fragment (accessible from Settings in debug/dev builds).

**Integrations**:
- **Chucker HTTP inspector**: `com.chuckerteam.chucker.internal.ui.MainActivity` — allows intercepting and viewing all HTTP requests made by the app
- **Token copy**: copies current `UserManager.INSTANCE.getToken()` to clipboard for API debugging
- **WebView URL tester**: prompts for a URL and loads it in a WebView; validates `http://` or `https://` prefix
- **HTML content tester**: prompts for HTML content to render in WebView

Chucker is the primary debug HTTP logging tool — all OkHttp traffic is observable via this inspector in dev builds.

---

### §164 — XiaoJi HTTP Config Layers

From `EggGameHttpConfig.java` and `HttpConfig.java` (two separate OkHttp config files):

**EggGameHttpConfig** — main launcher HTTP client:
- Interceptors: `EggGameTokenInterceptor`, `OfflineCacheInterceptor`, `RemoveExtraSlashInterceptor`, `TokenRefreshInterceptor`
- Base URL selection: test environment → `test-landscape-api.vgabc.com`; PRODUCT env → `landscape-api.vgabc.com`; BETA → `landscape-api-beta.vgabc.com`; else → `dev-gamehub-api.vgabc.com`

**HttpConfig** (ADB WiFi module HTTP client):
- Uses `GameHubPrefs.getEffectiveApiUrl("https://landscape-api.vgabc.com/")` — picks active API source at runtime
- This is the BH-patched ADB WiFi module using the three-way API switch

**`RemoveExtraSlashInterceptor`**: strips double slashes from URLs (e.g., `//path` → `/path`) — indicates some URL concatenation produces spurious slashes.

---

### §165 — MockUtilsKt: Test Game Data

`com/xj/landscape/launcher/data/mock/MockUtilsKt.java`

Contains hardcoded mock game image URLs and data used for UI development/testing. Steam App IDs embedded in mock data (partial list — IDs visible in CDN URLs):

| Steam App ID | Note |
|-------------|------|
| `1174180` | Red Dead Redemption 2 |
| `289650` | (unknown) |
| `614570` | (unknown) |
| `1817070` | (unknown) |
| `2283380` | (unknown) |
| `2479320` | (unknown) |
| `846110` | (unknown) |
| `530130` | (unknown) |
| `2891120` | (unknown) |
| `2218400` | (unknown) |
| `2198070` | (unknown) |
| `1911360` | (unknown) |
| `1689010` | (unknown) |
| `1222690` | (unknown) |

Images come from both `shared.cdn.queniuqe.com` and `uxdl.bigeyes.com`, confirming that both CDNs serve production content (not just test data).

---

*[Pass 14 complete — 8 new sections (158–165) added]*

---

## §166–§175: PC Stream, Launcher, Community, More APIs (Pass 15 Additions)

---

### §166 — ComponentDownloadActivity: GitHub Component/Driver Feed URLs

`com/xj/landscape/launcher/ui/menu/ComponentDownloadActivity.java`

BannerHub fetches component and GPU driver manifests directly from GitHub raw URLs:

| Feed | URL |
|------|-----|
| WinlatorWCPHub packs | `https://raw.githubusercontent.com/Arihany/WinlatorWCPHub/refs/heads/main/pack.json` |
| Kimchi GPU drivers | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/kimchi_drivers.json` |
| StevenMxZ GPU drivers | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/stevenmxz_drivers.json` |
| MTR GPU drivers | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/mtr_drivers.json` |
| White GPU drivers | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/white_drivers.json` |
| Nightlies components | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/nightlies_components.json` |

All feeds are from GitHub repositories — `The412Banner/Nightlies` is the developer's own repo, `Arihany/WinlatorWCPHub` is a community component hub.

---

### §167 — SteamPageFragment: SNI Stripping for China (GFW Bypass)

`com/xj/landscape/launcher/ui/SteamPageFragment.java`

Separate from the Steam SDK's `SteamSdk`, the Steam **WebView** page fragment has its own OkHttp client with a different China bypass technique: **SNI stripping**.

**Protocol prefix**: `"steammobile://"` — routes Steam protocol links into this WebView.

**SNI bypass technique** (`initOkHttpClientInCn`):
```java
// Custom SSLSocketFactory — when SNI hostname is "store.steampowered.com",
// replace it with "localhost" before handshake
if (sSLParameters.getServerNames().contains(new SNIHostName("store.steampowered.com"))) {
    sSLParameters.setServerNames(CollectionsKt.e(new SNIHostName("localhost")));
}
```

This suppresses the SNI extension, preventing GFW from identifying the target hostname from the TLS ClientHello. The IP-based routing still reaches the correct server (via custom DNS), but SNI inspection can't block it.

**Additional**: `TrustManager` in this fragment also uses trust-all (same pattern as `SteamSdk.y()`).

**DNS resolver**: routes `store.steampowered.com` through BH's IP pool (same pattern as SteamSdk custom DNS).

**Debug integration**: `ChuckerUtilsKt.b(builder)` — Chucker HTTP inspector hooked into this OkHttp client.

---

### §168 — EFS SDK: Umeng Crash Reporting

`com/efs/sdk/` package — Tencent's EFS (Error/Exception Filing System) SDK wrapping Umeng crash collection.

**Crash report endpoints**:
- Production: `https://errnewlog.umeng.com/api/crashsdk/logcollect`
- Alternative/logos: `https://errnewlogos.umeng.com/api/crashsdk/logcollect`

Selection: if `getGlobalEnvStruct().isLogos()` → logos URL, else standard URL.

**Includes**: MemLeak monitor (`memleaksdk`) — a port of LeakCanary tracking standard Android memory leaks. This means XiaoJi monitors production devices for memory leaks via EFS.

---

### §169 — CMIC China Mobile SSO (One-Click Phone Auth)

`com/cmic/sso/sdk/` package — China Mobile/Unicom/Telecom (三网合一) carrier authentication SDK.

**User agreement URLs** (displayed in WebView during login):
- China Telecom: `https://e.189.cn/sdk/agreement/detail.do?hidetop=true`
- China Unicom: `https://opencloud.wostore.cn/authz/resource/html/disclaimer.html?fromsdk=true`

**SDK**: CMIC SSO (号码认证SDK) — allows users to authenticate via their phone's SIM carrier without entering a password. Used in Chinese apps as an alternative to SMS OTP.

**Used by**: `OneKeyAliHelper` + CMIC backend → Alibaba `PhoneNumberAuthHelper` (DAMO, Alibaba Cloud's number authentication product) + CMIC carrier APIs.

---

### §170 — OneKeyAliHelper: Alibaba Phone Number Authentication

`com/xj/landscape/launcher/utils/OneKeyAliHelper.java`

Implements **Alibaba One-Click Login** (`PhoneNumberAuthHelper`) for China accounts.

**Privacy URLs** (same URL used for both privacy policy and terms):
- `https://www.xiaoji.com/url/gsw-app-rules`

**Configuration**:
- Custom XML layout: `llauncher_activity_new_land_one_key_cus_order_login_type`
- Controls hidden: switch account button hidden, nav bar hidden, status bar hidden
- Colors: `#A5A5A5` (text), `#FF7CAB` (accent — BH pink)

**Login flow**: `PhoneNumberAuthHelper.getLoginToken(context, timeout)` → `TokenResultListener` callback → dispatches to account system.

---

### §171 — SteamPageFragment WebView: Steam Store WebView

`com/xj/landscape/launcher/ui/SteamPageFragment.java` (continued)

The WebView used to display the Steam store inside the app:

**Entry URL**: `"https://store.steampowered.com/"` (default) or passed via `KEY_URL` bundle extra.

**URL scheme handling**: intercepts `"steammobile://"` prefixed URLs and routes them through `SteamUtil.d(context, url)`.

**WebView URL filtering**: only loads URLs starting with `"http://"` or `"https://"` — blocks other schemes.

**Navigation**: handles back press with `webView.canGoBack()` / `webView.goBack()`.

---

### §172 — SteamUtil: Steam Mobile Utilities

`com/xj/common/utils/SteamUtil.java`

**Mobile Steam link**: opens `https://store.steampowered.com/mobile` in browser — used when the user taps "Open in Steam Mobile".

**`d(context, url)`**: handles `steammobile://` URL routing.

---

### §173 — AppLauncher: Google Play Deep Link

`com/xj/landscape/launcher/launcher/AppLauncher.java`

Constructs Google Play Store URL for installing apps:
```java
String.format("https://play.google.com/store/apps/details?id=%s", packageName)
```

Used when a game or component requires an external Android app (e.g., controller mapping utilities, emulator frontends).

---

### §174 — SteamGameUpdateDialog: Store Page Link

`com/xj/landscape/launcher/ui/dialog/SteamGameUpdateDialog.java`

When a Steam game update is available, the dialog offers a "View on Steam" button:

**URL**: `https://store.steampowered.com/app/<steamAppId>/`

Uses `webUtils.a(context, url)` to open in a browser/WebView.

---

### §175 — Tencent Operations Request Signing (Detail)

`com/xj/landscape/launcher/net/tencent/TencentOperationsNetHelper.java`

**Operations tracked** (from method analysis):
- `h(scope, keyword, ...)` — keyword search event
- `l(scope, gameId, type, ...)` — game list event
- `o(scope, type, ...)` — launch type event
- `q(scope, gameId, ...)` — game detail view
- `t(scope, gameId, ...)` — game interaction
- `w(scope, list, ...)` — batch game reporting
- `y(scope, type, gameId, name, ...)` — named game event

**POST body structure**: `{"keyword": <value>}` — single key/value event map.

**Base URL selection** (`j(originUri)` method):
```
base = isTest ? "https://test.nj.qq.com" : "https://release.nj.qq.com"
path = originUri
ts = System.currentTimeMillis()
plaintext = "appid=8P3VT7TE&timestamp=" + ts + "_" + originUri + "_" + SECRET_KEY
sign = EncryptUtils.e(plaintext).toLowerCase()
result = base + path + "?appid=8P3VT7TE&timestamp=" + ts + "&sign=" + sign
```

---

*[Pass 15 complete — 10 new sections (166–175) added]*

---

## §176–§195: JavaSteam Internals, UserManager, Interceptors, Infrastructure

### §176 — JavaSteam PICS CDN URL Pattern

`in/dragonbra/javasteam/steam/handlers/steamapps/PICSProductInfo.java`

When Steam sends a PICS (Product Info Cache System) response with an HTTP host, JavaSteam fetches compressed app-info via:

```
https://<httpHost>/appinfo/<appId>/sha/<sha>.txt.gz
```

**Fields decoded:**
- `httpHost` — comes directly from the CM PICS response (Steam-controlled CDN)
- `appId` — Steam app identifier
- `sha` — SHA checksum of the specific product info version

The `.txt.gz` file is decompressed and parsed as a Steam VDF/KeyValues structure. This is the canonical offline app-info cache path, distinct from the live `ISteamApps.PICSGetProductInfo` WebAPI call.

---

### §177 — JavaSteam Default WebAPI Base Address

`in/dragonbra/javasteam/steam/webapi/WebAPI.java`

```java
public static final String DEFAULT_BASE_ADDRESS = "https://api.steampowered.com/";
```

All WebAPI calls (ISteamApps, ISteamUser, IPlayerService, etc.) resolve against this base unless overridden. XjSteamClient overrides the HTTP client with `SteamAPI.a.q()` (the BH-custom OkHttp client with trust-all SSL + custom DNS), so all WebAPI traffic passes through the same SSL bypass stack.

---

### §178 — UserManager — Full Profile / Token Model

`com/xj/common/user/UserManager.java`

**Stored SharedPreference keys:**

| Key | Purpose |
|---|---|
| `token` | Primary session token |
| `refresh_token` | Token refresh credential |
| `im_token` | IM (instant messaging / social) subsystem token |
| `sw_token` | SW subsystem token (separate auth scope) |
| `mobile` | Phone number |
| `username` | Login username |
| `uuid` | User unique identifier |
| `nickname` | Display name |
| `third_platform` | Third-party login platform identifier |
| `avatar` | Avatar URL |
| `realme_token` | Realme device variant auth token |
| `realme_refresh_token` | Realme device variant refresh token |

**Profile update signature:**
```java
updateUserInfo(uuid, mobile, nickname, username, token, avatar, bio, email, third_platform, refresh_token)
```

`bio` and `email` are accepted in the update call but not listed as persisted keys — they may be in-memory only or persisted under different keys.

The `realme_*` keys indicate a Realme-specific (OPPO/OnePlus sub-brand) device partnership variant that carries separate auth credentials.

---

### §179 — SteamLoginViewModel — Default Entry URL

`com/xj/standalone/steam/viewmodel/SteamLoginViewModel.java`

Default Steam login WebView entry:

```
https://store.steampowered.com/mobile
```

This is the Steam mobile store login page. The ViewModel loads this URL in the Steam login WebView; after successful login, cookies are harvested by `WebViewCookieManager`.

---

### §180 — SteamServiceImpl — Default Avatar Fallback

`com/xj/standalone/steam/SteamServiceImpl.java`

When a Steam avatar hash is missing or blank, the fallback CDN URL used is:

```
https://avatars.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg
```

This is Steam's well-known "default" avatar (the blank grey silhouette), referenced by its canonical SHA hash rather than a generic filename.

---

### §181 — WebViewCookieManager — Third-Party Cookie Policy

`com/xj/standalone/steam/utils/WebViewCookieManager.java`

```java
CookieManager.getInstance().setAcceptThirdPartyCookies(webView, true);
```

Third-party cookies are explicitly enabled for every WebView instance. This is required for Steam's SSO/login flow (Steam's cookie domain differs from `store.steampowered.com`), GOG auth (`embed.gog.com` cookies from `auth.gog.com`), and Epic Games auth (epicgames.com cross-origin cookies). Without this flag, all three OAuth/SSO flows would fail on Android 5+.

---

### §182 — TokenInterceptor — Signature Bypass for Internal Endpoints

`com/xj/landscape/launcher/net/RetrofitHelper.java` / `TokenInterceptor`

The request signing interceptor (which appends HMAC signatures to all API calls to `landscape-api.vgabc.com`) **skips signature generation** for the following host prefix:

```
clientgsw.vgabc.com/clientapi/
```

Requests to `clientgsw.vgabc.com` are forwarded as-is without the HMAC/timestamp signature. This subdomain is the client-gateway service (likely internal reverse proxy) and authenticates via the `token` header alone.

---

### §183 — ImagePreloadUtils — Cloudflare CDN Pass-Through

`com/xj/landscape/launcher/utils/ImagePreloadUtils.java`

Images beginning with `https://cdn.cloudflare` are handled with a special pass-through path: they bypass the app's custom image proxy/cache layer and are loaded directly. This is specifically to accommodate Steam CDN headers (which are served from `cloudflare.steamstatic.com`) without double-proxying.

---

### §184 — Mapping Controller Help URLs

`com/xj/landscape/launcher/ui/map/DialogAdvancedSettings.java`  
`com/xj/landscape/launcher/ui/map/MapGlobalSettingLayout.java`

Advanced mapping settings link out to:

```
https://www.xiaoji.com/url/obscure-click
```

This URL likely redirects to a help article explaining the "obscure click" mapping feature (hidden tap zones or obscured-region touch events). It is opened via `webUtils.a(context, url)` — same launcher used throughout.

---

### §185 — Keyboard Mapping Help URLs

`com/xj/landscape/launcher/ui/map/KeyboardViewNew.java`

In-app keyboard mapper references two local asset HTML pages for help dialogs:

```
file:///android_asset/help.html
file:///android_asset/selectdevice.html
```

These are bundled static HTML help pages in the APK assets folder. `help.html` likely documents key-binding instructions; `selectdevice.html` is a device selection guide for the virtual keyboard/gamepad layout editor.

---

### §186 — Chucker HTTP Inspector — Confirmed Integration

`com/xj/landscape/launcher/ui/SteamPageFragment.java`  
`com/chuckerteam/chucker/...`

The Chucker in-app HTTP inspector (`com.chuckerteam.chucker`) is integrated as an OkHttp interceptor. In the `ChuckerUtilsKt` call inside `SteamPageFragment`, it is added to the Steam-page OkHttp client. **Chucker is a developer HTTP traffic inspector** — it displays a notification-based request/response log inside the app. Its presence alongside the trust-all SSL stack means all decrypted Steam HTTP traffic is also visible in the Chucker UI. This is consistent with a development/debug build artifact that was not stripped for this release.

---

*[Pass 16 complete — 11 new sections (176–186) added]*

---

## §196–§220: Amazon Full API Stack, GOG Client Secret, EmuReady Token, SteamCdnHelper

### §187 — Amazon Gaming Distribution API

`app/revanced/extension/gamehub/AmazonApiClient.java`

**API endpoints:**

| Constant | Value |
|---|---|
| `DISTRIBUTION_URL` | `https://gaming.amazon.com/api/distribution/v2/public` |
| `ENTITLEMENTS_URL` | `https://gaming.amazon.com/api/distribution/entitlements` |
| `SDK_CHANNEL_URL` | `https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346` |
| `KEY_ID` | `d5dc8b8b-86c8-4fc4-ae93-18c0def5314d` |

**Client identity impersonation:**
- Gaming User-Agent: `"com.amazon.agslauncher.win/3.0.9202.1"` — spoofs Amazon Games Launcher for Windows (AGS)
- Download User-Agent: `"nile/0.1 Amazon"` — spoofs `nile` (open-source Amazon Games downloader)
- Client ID: `"Sonic"` — Amazon AGS internal project codename
- X-Amz-Target prefix: `com.amazon.animusdistributionservice.external.AnimusDistributionService.*`
- Content-Encoding: `"amz-1.0"` — Amazon-specific encoding header

**RPC operations:**
- `GetEntitlements` — paginated, up to 50 per page, uses `hardwareHash` (uppercase SHA256 of device serial)
- `GetGameDownload` — resolves `entitlementId` → `downloadUrl` + `versionId`
- `GetLiveVersionIds` — batch productId → live versionId mapping

**Game model fields from entitlements:**
- `entitlementId`, `productId`, `title`, `productSku`, `productType`, `parentProductId`
- Art: `iconUrl`, `logoUrl` (fallback), `backgroundUrl1`/`backgroundUrl2` (heroUrl)
- `developer`, `publisher`
- DLC detection: `isDLC = !type.equalsIgnoreCase("GAME") || !parentProductId.isEmpty()`

---

### §188 — Amazon Auth API (Device Registration)

`app/revanced/extension/gamehub/AmazonAuthClient.java`

**Identity impersonation:**
- `APP_NAME = "AGSLauncher for Windows"`
- `APP_VERSION = "1.0.0"`
- `DEVICE_TYPE = "A2UMVHOX7UP4V7"` — Amazon's device type ID for the Windows AGS Launcher
- `OS_VERSION = "10.0.19044.0"` — Windows 10 21H1 (build 19044)
- User-Agent: `"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"`

**Auth API endpoints:**

| Operation | URL |
|---|---|
| Register device | `https://api.amazon.com/auth/register` |
| Refresh token | `https://api.amazon.com/auth/token` |
| Deregister device | `https://api.amazon.com/auth/deregister` |

**Registration request body** (`auth_data` + `registration_data`):
```json
{
  "auth_data": {
    "authorization_code": "<code>",
    "client_domain": "DeviceLegacy",
    "client_id": "<hex(serial#DEVICE_TYPE)>",
    "code_algorithm": "SHA-256",
    "code_verifier": "<verifier>",
    "use_global_authentication": false
  },
  "registration_data": {
    "app_name": "AGSLauncher for Windows",
    "app_version": "1.0.0",
    "device_model": "Windows",
    "device_serial": "<UUID>",
    "device_type": "A2UMVHOX7UP4V7",
    "domain": "Device",
    "os_version": "10.0.19044.0"
  },
  "requested_extensions": ["customer_info","device_info"],
  "requested_token_type": ["bearer","mac_dms"]
}
```

Token refresh: POST to `api.amazon.com/auth/token` with `x-amzn-identity-auth-domain: api.amazon.com`, source_token_type=refresh_token, requested_token_type=access_token.

---

### §189 — Amazon Credential Store

`app/revanced/extension/gamehub/AmazonCredentialStore.java`

Credentials are persisted as JSON at:
```
context.getFilesDir()/amazon/credentials.json
```

Keys: `access_token`, `refresh_token`, `device_serial`, `client_id`, `expires_at` (epoch ms).

Auto-refresh: if `expiresAt - now < 300000` (5 minutes) and `refreshToken != null`, silently calls `AmazonAuthClient.refreshAccessToken()` and overwrites the file.

---

### §190 — Amazon PKCE Generator

`app/revanced/extension/gamehub/AmazonPKCEGenerator.java`

- `generateDeviceSerial()` → `UUID.randomUUID().toString().replace("-","").toUpperCase()` (32-char uppercase hex)
- `generateClientId(serial)` → `hex(serial + "#A2UMVHOX7UP4V7")` — client ID is hex-encoding of `<serial>#<DEVICE_TYPE>`
- `generateCodeVerifier()` → 32 random bytes, Base64URL-encoded (no padding)
- `generateCodeChallenge(verifier)` → Base64URL(SHA256(verifier)) — S256 PKCE
- `sha256Upper(str)` → uppercase hex SHA256 — used for `hardwareHash` in GetEntitlements

---

### §191 — Amazon Download Manager internals

`app/revanced/extension/gamehub/AmazonDownloadManager.java`

**Download configuration:**
- `MAX_PARALLEL = 8` — 8 concurrent file downloads
- `MAX_RETRIES = 3` — per-file retry budget
- `PROGRESS_INTERVAL = 524288` — report progress every 512 KB
- Manifest URL: `<downloadUrl>/manifest.proto` (binary protobuf)
- Manifest cache: `context.getFilesDir()/manifests/amazon/<versionId>.proto`
- Debug log: `bh_amazon_debug.txt` (written to external or internal files dir)

**Completion markers** (in game install directory):
- `.amazon_download_in_progress` — partial download sentinel
- `.amazon_download_complete` — installation done sentinel

**AmazonManifest format:**
- 4-byte big-endian header size, followed by header protobuf + body protobuf
- Header protobuf field 1→field 1 = compression algorithm (1=XZ, 0=LZMA)
- Decompression: `org.tukaani.xz.XZInputStream` or `org.tukaani.xz.LZMAInputStream`
- Per-file fields: `path` (Windows backslash), `size`, `hashAlgorithm`, `hashBytes`
- Custom hand-written `ProtoReader` (not using protobuf runtime library)

---

### §192 — EmuReady Token Service

`app/revanced/extension/gamehub/token/TokenProvider.java`

**Token service endpoints:**

| Operation | URL |
|---|---|
| Get token | `https://gamehub-lite-token-refresher.emuready.workers.dev/token` |
| Force refresh | `https://gamehub-lite-token-refresher.emuready.workers.dev/refresh` |

**Auth header:** `X-Worker-Auth: gamehub-internal-token-fetch-2025`

**Token resolution logic (`resolveToken`):**
1. If `apiSwitchPatched && isExternalAPI()` → return literal `"fake-token"` (EmuReady API path — no real token needed)
2. If `loginBypassed` → call `getServiceToken(originalToken)` (get real token from EmuReady service)
3. Otherwise → pass through original token unchanged

**Three-level token cache:**
- L1: `AtomicReference<CachedToken>` (in-memory)
- L2: `SharedPreferences("token_provider_pref")` — keys `cached_token`, `cached_token_expiry`
- L3: live HTTP fetch from `gamehub-lite-token-refresher.emuready.workers.dev/token`
- TTL: 4 hours (14,400,000 ms)
- Stale fallback: uses expired cached token if all live fetches fail

**Static flags (hardcoded at build time):**
```java
public static boolean apiSwitchPatched = true;
public static boolean loginBypassed = true;
```

`getCurrentAppToken()` uses reflection to read `com.xj.common.user.UserManager.INSTANCE.getToken()`.

---

### §193 — GOG Client Secret

`app/revanced/extension/gamehub/GogTokenRefresh.java`

**GOG OAuth token refresh URL (complete):**
```
https://auth.gog.com/token?client_id=46899977096215655&client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9&grant_type=refresh_token&refresh_token=<token>
```

**GOG client_secret:** `9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9`

(This is the same credential used by the GOG Galaxy desktop client. BH uses `GogLoginActivity.parseJsonStringField()` to extract `access_token` and `refresh_token` from the refresh response.)

**SharedPreferences `bh_gog_prefs` token keys:**
- `refresh_token`, `access_token`, `bh_gog_login_time`, `bh_gog_expires_in`

---

### §194 — SteamCdnHelper — BigEyes CDN + IStoreBrowseService

`app/revanced/extension/gamehub/network/SteamCdnHelper.java`

**CDN domains:**

| Constant | Value |
|---|---|
| `CDN_FALLBACK_BASE` | `https://shared.steamstatic.com/store_item_assets/` |
| `BIGEYES_CDN_BASE` | `https://cdn-library-logo-global.bigeyes.com/` |
| Default header (appId=0) | `https://shared.steamstatic.com/store_item_assets/steam/apps/0/header.jpg` |
| Default header (appId=N) | `https://shared.steamstatic.com/store_item_assets/steam/apps/<N>/header.jpg` |

**Batch image resolver (IStoreBrowseService):**
- URL: `https://api.steampowered.com/IStoreBrowseService/GetItems/v1/`
- Batch size: 50 app IDs per request
- Delay: 150 ms between batches
- Response: `asset_url_format` + `header` filename → resolved header URL
- Cache: `SharedPreferences("steam_cdn_cache")`, TTL = 7 days (604,800,000 ms)
- Keys: `url_<appId>`, `exp_<appId>`
- Thread: daemon thread named `"steam-cdn"`

**BigEyes URL rewriting:** Any URL starting with `https://cdn-library-logo-global.bigeyes.com/` is rewritten to `https://shared.steamstatic.com/store_item_assets/<remainder>`. This normalises BigEyes CDN-hosted art to the standard Steam CDN path.

---

### §195 — GHLog — Complete Enum

`app/revanced/extension/gamehub/util/GHLog.java`

All 13 GHLog enum entries (log tag prefix: `"GHL/"`):

| Enum | Tag | Usage |
|---|---|---|
| `TOKEN` | `GHL/Token` | TokenProvider |
| `PREFS` | `GHL/Prefs` | GameHubPrefs |
| `BATTERY` | `GHL/Battery` | BatteryHelper |
| `GAME_ID` | `GHL/GameId` | GameIdHelper |
| `CURRENCY` | `GHL/Currency` | AccountCurrencyHelper |
| `COMPAT` | `GHL/Compat` | CompatibilityCache |
| `FILE_MGR` | `GHL/FileMgr` | file manager module |
| `STORAGE` | `GHL/Storage` | StorageBroadcastReceiver |
| `NET` | `GHL/Net` | network module |
| `CDN` | `GHL/CDN` | SteamCdnHelper |
| `CPU` | `GHL/CPU` | CpuUsageHelper |
| `PERF` | `GHL/Perf` | PerformanceMetricsHelper |
| `PLAYTIME` | `GHL/Playtime` | PlaytimeHelper |

---

### §196 — BhDownloadService — Download Orchestration + Library

`app/revanced/extension/gamehub/BhDownloadService.java`

**Foreground service** handling concurrent GOG, Epic, and Amazon game downloads.

**Intent API:**

| Extra | Key | Purpose |
|---|---|---|
| `EXTRA_STORE` | `"store"` | `"GOG"` / `"EPIC"` / `"AMAZON"` |
| `EXTRA_GAME_ID` | `"game_id"` | Unique download key |
| `EXTRA_GAME_NAME` | `"game_name"` | Display name |
| `EXTRA_GOG_GAME_ID` | `"gog_gid"` | GOG numeric game ID |
| `EXTRA_GOG_GENERATION` | `"gog_gen"` | GOG build generation (1 or 2) |
| `EXTRA_EPIC_NAMESPACE` | `"epic_ns"` | Epic catalog namespace |
| `EXTRA_EPIC_CATALOG_ID` | `"epic_cat"` | Epic catalog item ID |
| `EXTRA_EPIC_APP_NAME` | `"epic_app"` | Epic app name |
| `EXTRA_AMAZON_PRODUCT_ID` | `"amz_pid"` | Amazon product ID |
| `EXTRA_AMAZON_ENT_ID` | `"amz_eid"` | Amazon entitlement ID |
| `EXTRA_AMAZON_SKU` | `"amz_sku"` | Amazon product SKU |

**Notification channel:** `"bh_downloads"` ("BannerHub Downloads"), importance=LOW.  
**Notification IDs:** active download = 8800; completion/error base = 8810+.

**Install paths:**
- GOG: `GogInstallPath.getInstallDir(context, sanitizedTitle)`
- Epic: `context.getFilesDir()/epic_games/<sanitizedTitle>/`
- Amazon: `context.getFilesDir()/Amazon/<sanitizedTitle>/`

**Installed game library** (`SharedPreferences("bh_library")`):
- Format: `<dlKey>` → `"<name>\n<store>\n<installPath>"`
- Download keys map to game names in `bh_gog_prefs` (`gog_exe_<id>`, `gog_dir_<id>`), `bh_epic_prefs` (`epic_exe_<appName>`, `epic_dir_<appName>`, `epic_manifest_version_<appName>`), `bh_amazon_prefs` (`amazon_dir_<productId>`, `amazon_exe_<productId>`)

---

### §197 — BhSettingsExporter — Config Export/Import + Frontend Export

`app/revanced/extension/gamehub/BhSettingsExporter.java`

**Config export path:** `<external storage>/BannerHub/configs/<sanitized_game>-<device>-<model>-<soc>-<timestamp>.json`

**Export JSON structure:**
```json
{
  "meta": {
    "app_source": "bannerhub",
    "device": "<manufacturer model>",
    "soc": "<GPU renderer or kgsl model>",
    "bh_version": "3.5.0",
    "upload_token": "<random 64-bit hex>",
    "settings_count": <n>,
    "components_count": <n>
  },
  "settings": { "<pc_g_setting keys>": "<values>", ... },
  "components": [
    { "name": "<name>", "url": "<download url>", "type": "<type>" },
    ...
  ]
}
```

**Component keys exported from `pc_g_setting<gameKey>`:**
- `"pc_ls_DXVK"` — DXVK selection
- `"pc_ls_VK3k"` — VKD3D selection
- `"pc_set_constant_94"` — Box64 setting
- `"pc_set_constant_95"` — FEXCore setting
- `"pc_ls_GPU_DRIVER_"` — GPU driver selection
- `"pc_ls_CONTAINER_LIST"` — Wine container
- `"pc_ls_steam_client"` — Steam client component

**Component type → int mapping:**

| Type name | Int |
|---|---|
| `GPU` | 10 |
| `VKD3D` | 13 |
| default (DXVK/container) | 12 |
| `Box64` | 94 |
| `FEXCore` | 95 |

**Worker API endpoints:**

| Operation | URL |
|---|---|
| Upload | `POST https://bannerhub-configs-worker.the412banner.workers.dev/upload` |
| List | `GET https://bannerhub-configs-worker.the412banner.workers.dev/list?game=<game>` |
| Download | `GET https://bannerhub-configs-worker.the412banner.workers.dev/download?game=<game>&file=<file>` |

Upload body: `{"game": "<name>", "filename": "<filename>", "content": "<base64(json)>", "upload_token": "<token>"}`.  
Upload response: `{"success": true, "sha": "<sha>"}` — SHA is stored in `bh_config_uploads` SharedPreferences.

**SOC detection order:**
1. `SharedPreferences("device_info").getString("gpu_renderer")`
2. `/sys/class/kgsl/kgsl-3d0/gpu_model` (Adreno-specific)
3. `Build.SOC_MODEL` (Android 12+) or `Build.HARDWARE`

**Frontend export paths:**
- Beacon: `Downloads/bannerhub/frontend/Beacon/<game>.iso`
- ES-DE: `Downloads/bannerhub/frontend/ES-DE/<game>.steam`

---

*[Pass 17 complete — 11 new sections (187–197) added]*

---

## §221–§250: SteamConfig, EggGameHttpConfig Environments, Epic UA, Storage Paths, vgabc.com Catalog

### §198 — SteamConfig — Constants

`com/xj/standalone/steam/SteamConfig.java`

Key static configuration values:

| Constant | Value | Role |
|---|---|---|
| `b` | `88` | Default connection count (initial value; `SteamAPI.A()` default) |
| `k` | `24` | `h()` — OkHttp max requests per host; also used in connection pool: `maxRequests = k*3 = 72`, `maxConnections = k*2 = 48` |
| `l` | `20` | `i()` — likely write-timeout seconds |
| `m` | `60L` | `d()` — connect timeout in seconds |
| `n` | `Runtime.getRuntime().availableProcessors()` (fallback 8) | CPU count for thread pools |

**Steam CM server list file:** `context.getFilesDir()/server_list.bin` — persisted protobuf `BasicServerList` via `GHFileServerListProvider`.

---

### §199 — EggGameHttpConfig — Multi-Environment API Selector

`com/xj/common/http/EggGameHttpConfig.java`

The base API URL is selected at static initialization based on build configuration:

| Condition | Base URL |
|---|---|
| Test mode (`Constants.a.c() == true`) | `https://test-landscape-api.vgabc.com/` |
| `ServerEnv.PRODUCT` | `https://landscape-api.vgabc.com/` |
| `ServerEnv.BETA` | `https://landscape-api-beta.vgabc.com/` |
| Dev/other | `https://dev-gamehub-api.vgabc.com/` |

After environment selection, the result is passed through `GameHubPrefs.getEffectiveApiUrl(str)` — the BannerHub extension may substitute its own API URL (EmuReady or BH worker).

**Token-signing bypass domains** (`Companion.b(url)` → `true` = skip token):
- `test.nj.qq.com` — Tencent Operations (test)
- `release.nj.qq.com` — Tencent Operations (prod)
- `trace.inlong.qq.com` — Tencent InLong analytics

**OkHttp client config:**
- Timeouts: 30s connect / 30s read / 30s write
- Cache: 128 MB at `context.getCacheDir()`
- Interceptors (in order): `RemoveExtraSlashInterceptor`, `LogRecordInterceptor`, `EggGameTokenInterceptor`, `TokenRefreshInterceptor`, `OfflineCacheInterceptor`
- Cookie: `PersistentCookieJar`
- HTTP inspector: `ChuckerUtilsKt.b(initialize)` — Chucker added for all non-Steam OkHttp clients too

**JWT refresh path:** `<baseUrl>jwt/refresh/token` (seen in `TokenRefreshInterceptor`)

---

### §200 — EggGameApi — Legal/Feedback Paths

`com/xj/landscape/launcher/config/EggGameApi.java`

WebView URLs using the landscape-api base:

| Path | Purpose |
|---|---|
| `agreement/index.html?type=1&lang=<lang>` | Terms of Service |
| `agreement/index.html?type=2&lang=<lang>` | Privacy Policy |
| `feedback/feedback_list.html?uid=<uid>` | User feedback list |
| `feedback/feedback_detail.html?<params>` | Feedback detail |

---

### §201 — landscape-api.vgabc.com — Complete API Endpoint Catalog

All POST/GET endpoints discovered through full repository scan (base: `https://landscape-api.vgabc.com/`):

**Authentication / Session:**

| Path | Description |
|---|---|
| `jwt/mobile/login` | SMS/mobile number login |
| `jwt/email/login` | Email + password login |
| `jwt/third/login` | Third-party (social / one-click carrier) login |
| `jwt/oneMobile/login` | China carrier "one-click" login (CMIC/Unicom) |
| `jwt/logout` | Logout / session invalidation |
| `jwt/refresh/token` | Token refresh |
| `sms/send` | Send SMS verification code |
| `ems/send` | Send email verification code |
| `bind/mobile` | Bind phone number to account |
| `bind/email` | Bind email to account |

**User Profile:**

| Path | Description |
|---|---|
| `user/info` | Fetch / update user info |
| `user/updateUserNotice` | Update notification preferences |
| `profile/avatar` | Change avatar |
| `profile/username` | Change username |
| `profile/mobile` | Update phone number |

**QR Code / PC Login:**

| Path | Description |
|---|---|
| `user/buildPcPin` | Generate PC pairing PIN for QR code login |
| `user/mobileScanCode` | Mobile scans QR code |
| `user/mobileConfirmCode` | Mobile confirms QR code |
| `user/mobileCancelCode` | Mobile cancels QR code |

**Game Catalog & Search:**

| Path | Description |
|---|---|
| `game/getDnsPool` | Get Steam DNS IP pool (SteamWebViewModel) |
| `game/getDnsIpPool` | Get Steam DNS IP pool (SteamModuleApp init) |
| `game/getTopPlatform` | Top platform list for home screen |
| `game/searchClassifyList` | Search classification list |
| `game/searchCategoryList` | Search category info |
| `game/searchTopCategoryList` | Top search category list |
| `game/searchGameList` | Game search by keyword/tag |

**Video & Social:**

| Path | Description |
|---|---|
| `game/likeVideo` / `game/cancelLikeVideo` | Like / unlike a video |
| `game/userVideoNum` | User video count |
| `game/userVideoList` | User uploaded video list |
| `game/userVideoReading` | Mark video as read/viewed |
| `game/userDeleteVideo` | Delete user video |
| `game/userUploadsVideo` | Upload user video metadata |
| `social/getRecommendation` | Get recommended games/content |
| `social/userDeviceConnect` | Connect device for social features |

**Feedback:**

| Path | Description |
|---|---|
| `feedback/submitFeedback` | Submit feedback/bug report |
| `feedback/submitFeedbackReply` | Reply to existing feedback |

**Uploads:**

| Path | Description |
|---|---|
| `uploads/uploadsImages` | Upload image (avatar, etc.) |
| `uploads/uploadsVideo` | Upload video file |

**Devices:**

| Path | Description |
|---|---|
| `devices/getDevices` | Get user devices |
| `devices/getDevicesList` | Get full device list |

**Cloud Gaming:**

| Path | Description |
|---|---|
| `cloud/game/check_user_timer` | Check cloud game time quota |

**PS5 Remote Play:**

| Path | Description |
|---|---|
| `ps5/get_ps5_connection_type` | PS5 connection type info |
| `ps5/get_ps5_open_doc` | PS5 documentation/help URL |
| `ps5/get_ps5_user` | Get linked PSN account |
| `ps5/get_ps5_user_by_code` | Get PSN account by code |

**Haptic/Controller:**

| Path | Description |
|---|---|
| `vtouch/startType` | Virtual touch controller type |

**App Update:**

| Path | Description |
|---|---|
| `upgrade/getAppUpgradeApk` | Check for app APK update |

---

### §202 — Epic Games Launcher User-Agent Impersonation

`app/revanced/extension/gamehub/EpicDownloadManager.java`

```java
private static final String UA = "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit";
```

All Epic CDN download requests use this UA, spoofing the **Unreal Engine Launcher v11.0.1** (build 14907503) on Windows 10 (10.0.19041 = 20H1/20H2). The `Portal+Release-Live` component is the Epic Games Portal production channel.

Epic CDN filter: URLs containing `cloudflare.epicgamescdn.com` are excluded from the CDN candidate list.

---

### §203 — BhStoragePath — Install Directory Resolution

`app/revanced/extension/gamehub/BhStoragePath.java`

```java
getStoreBase(context, storeDir) → 
  if use_custom_storage && steam_storage_path != null:
    <custom_path>/bannerhub/<storeDir>/
  else:
    context.getFilesDir()/<storeDir>/
```

Store directories used in practice:
- `gog_games` — GOG game installs
- Game data also written by `BhDownloadService` to `epic_games/<sanitizedTitle>/` and `Amazon/<sanitizedTitle>/` directly in `getFilesDir()` (not via `BhStoragePath`).

---

### §204 — Amazon SDK Manager — Directory Structure

`app/revanced/extension/gamehub/AmazonSdkManager.java`

Amazon SDK-related directories in `context.getFilesDir()`:
- `amazon_sdk/` — main Amazon SDK data
- `Amazon Games Services/` — Amazon Games services data
- `AmazonGamesSDK/` — AGS SDK files
- `Legacy/` — legacy Amazon SDK data

Version tracking: `.sdk_version` file in the SDK directory.

---

*[Pass 18 complete — 7 new sections (198–204) added]*

---

### §205 — API Request Signing Algorithm (SignUtils)

`com/xj/common/http/SignUtils.java`

**Signing secret:** `"all-egg-shell-y7ZatUDk"`

Algorithm (reconstructed):

```
1. Build TreeMap from all request params → sorts keys alphabetically
2. Serialize as "key1=val1&key2=val2..." (joining with "&")
3. Append literal "&all-egg-shell-y7ZatUDk"
4. MD5 of that concatenated string → lowercase(Locale.ROOT)
5. Result placed in the "sign" param of every signed request
```

`EncryptUtils.b(str)` calls `encryptMD5ToString(str)` (blankj/utilcode), then `.toLowerCase(Locale.ROOT)`.

All API calls to `landscape-api.vgabc.com` / EmuReady / BannerHub include this HMAC-MD5 in the `sign` field. The `MediaTrack.ROLE_SIGN` constant is the string `"sign"`.

---

### §206 — App Package Variant / Channel Detection

`com/xj/common/config/Constants.java`

```java
switch (context.getPackageName()) {
    case "com.xiaoji.egggame.redmagic":
        channel = "gamehub_redmagic";
        break;
    case "com.xiaoji.egggame.logitech":
        channel = "gamehub_logitech";
        break;
    default:
        channel = "gamehub_android";
}
```

| Package | Channel | Notes |
|---|---|---|
| `com.xiaoji.egggame.redmagic` | `gamehub_redmagic` | RedMagic device variant; also sets **test mode** (`c()` returns `true`) |
| `com.xiaoji.egggame.logitech` | `gamehub_logitech` | Logitech G Cloud variant |
| `com.tencent.ig` / default | `gamehub_android` | Standard variant — this APK |

The base application ID is `com.xiaoji.egggame`; the PUBG-disguised build uses `com.tencent.ig`. `Constants.b = true` is a global flag (likely debug/analytics enabled). The `a()` method returns the channel string used in `clientparams` as the `协议版本` (protocol version) prefix.

---

### §207 — ClientParams Request Body Structure

`com/xj/common/http/ClientParams.java`

Every signed API request includes a `clientparams` field with a pipe-separated string of 20 device fields:

| Field Name (Chinese) | Value Source |
|---|---|
| 客户端版本 (client version) | Hardcoded `"5.3.5"` |
| 安卓版本 (Android version) | `SystemUtil.e()` (Build.VERSION.RELEASE) |
| 语言 (language) | `GHLocaleManager` → locale language code |
| 机型 (model) | `Build.MODEL` |
| 分辨率 (resolution) | screen width × height |
| 协议版本 (protocol version) | channel string from `Constants.a.a()` |
| 渠道编号 (channel number) | `<protocol_version>_<AppConfig.k()>` |
| 品牌 (brand) | `Build.BRAND` |
| 生产厂家 (manufacturer) | `""` (empty) |
| MAC地址 (MAC address) | `""` (empty) |
| IMEI | `LocalDeviceId.a.l()` → device UUID |
| 地址位置 (location) | `""` (empty) |
| 手柄名称 (gamepad name) | `""` (empty) |
| 键盘名称 (keyboard name) | `""` (empty) |
| 鼠标名称 (mouse name) | `""` (empty) |
| 固件版本 (firmware version) | `""` (empty) |
| APP对应包名 (package name) | `AppUtils.b()` → current package |
| GPU | `SPUtils("device_info").gpu_renderer` |
| CPU | `SystemUtil.a().a` |
| RAM | total RAM in GB (rounded) |

The `LocalDeviceId.l()` → `m()` → reads from `b` (Lazy) → calls `i()` which is the UUID getter.

---

### §208 — Network Status Detection and China IP Probe

`com/xj/common/http/NetworkStatusDetector.java`

```java
enum NetworkStatus { UNKNOWN, NO_NETWORK, CHINA_IP, VPN_ENABLED }
```

**Initial state detection** on every app start:
1. Check locale: if `zh-CN` / `zh` + (`CN` country or `Hans` script) → immediately set `CHINA_IP`
2. Otherwise → set `UNKNOWN`
3. Register `ConnectivityManager.NetworkCallback` for live changes

**Runtime check sequence:**
1. If no internet → `NO_NETWORK`
2. HTTP connectivity check (`checkConnectivity`) — 5s timeout OkHttpClient
3. Google access check (`checkGoogleAccess`) → if Google reachable → `VPN_ENABLED`, else → `CHINA_IP`

This state is exposed as `LiveData` and consumed by the three-way API URL switch (`GameHubPrefs.getEffectiveApiUrl`). The `VPN_ENABLED` path routes through EmuReady; the `CHINA_IP` path stays on `landscape-api.vgabc.com`.

---

### §209 — Device UUID and Fingerprint Generation

`com/xj/common/utils/LocalDeviceId.java`

**UUID (`device_uuid`) — persistence chain:**
1. Try read `/storage/emulated/0/Downloads/GameHub/device_uuid` file (if external storage permission granted)
2. Fallback → `AppPreferences.getDeviceUuid()` (SharedPreferences)
3. Generate → `UUID.randomUUID().toString()`
4. Write back to file and SharedPreferences

**Hardware fingerprint (`deviceUniqueId`) — composition:**

MD5 of concatenated string:
```
"sensor:<sensor_list>\n"
+ "stat:<filesystem_stat>\n"   (from `stat -f /` → filesystem ID + total blocks)
+ "memory:<total_mem_GB>\n"
+ "storage:<data_partition_GB>\n"
+ "model:<Build.MODEL>\n"
+ "brand:<Build.BRAND>\n"
+ "package_name:<current_package>\n"
+ "gpu:<device_info.gpu_renderer>\n"
+ "cpu:<SystemUtil.cpu_name>\n"
+ "screen:<width>x<height>\n"
```

Sensor list includes: name, type, vendor, resolution, maxRange, minDelay for every sensor on the device. This fingerprint is stored in `AppPreferences.setDeviceUniqueId()` and used as a stable cross-app-reinstall device identity.

---

### §210 — Firebase Project Configuration

`res/values/strings.xml`

| Key | Value |
|---|---|
| `google_app_id` | `1:304891727788:android:e27ed4a7a22bdbc9adb409` |
| `gcm_defaultSenderId` | `304891727788` |
| `google_api_key` | `AIzaSyD2bJl2Lh1TLgbvZHpA7GsquBg5Eko3X7g` |
| `google_crash_reporting_api_key` | `AIzaSyD2bJl2Lh1TLgbvZHpA7GsquBg5Eko3X7g` |
| `default_web_client_id` | `304891727788-1lqj59qoj25o37viksnkuacccc6jhgg8.apps.googleusercontent.com` |
| `project_id` | `gamesir-8c76b` |

The Firebase project ID `gamesir-8c76b` reveals the original product identity: **GameSir** — the Chinese gamepad/controller manufacturer (also operating as XiaoJi/EggGame). This is the same Firebase project as the base GameSir app. `FirebaseAuthLoginUtils` uses Firebase Auth with Google Sign-In and Generic IDP login, initialized lazily (calls `FirebaseApp.initializeApp(context)` only once if no apps already initialized).

---

### §211 — Push Notification (JPush/极光 Integration)

`com/xj/push/PushApp.java`, `com/xj/push/jiguang/JPushService.java`

JPush (Jiguang — 极光推送, a major Chinese push notification SDK) is integrated via `cn.jpush.android.api.JPushInterface`. `JPushService` extends `JCommonService`.

**BannerHub behavior:** `PushApp.b(Application)` is a **no-op** (all init code unreachable via `JADX WARN: Unreachable blocks removed`). This means push notifications are stripped in the BannerHub build. However the following logic is preserved:

```java
// setCurUserAlias — sets JPush alias to user UID when available
if (UserManager.INSTANCE.getUid() > 0) {
    JPushInterface.setAlias(ctx, String.valueOf(uid), callback);
}
```

The alias is the user's numeric UID from `UserManager.INSTANCE.getUid()`. This would allow server-side targeting of push by user ID — but since init is stripped, it never runs in practice in this build.

---

### §212 — Analytics: Umeng Fully Disabled

`com/xj/umeng/UmengApp.java`, `com/xj/umeng/service/IUmengServiceImpl.java`

Umeng (友盟, major Chinese analytics SDK) is integrated but **fully stubbed out** in this build:
- `UmengApp.b(Application)` → no-op
- All `IUmengServiceImpl` methods (`a`, `b`, `c`, `d`, `e`, `f`, `onEvent`) → no-op

`JADX WARN: Unreachable blocks removed` on every method confirms the code was stripped by R8 with dead-code elimination, not just overridden. Umeng tracking produces zero telemetry in BannerHub PUBG build.

---

### §213 — PlayStation Remote Play — Chiaki JNI API

`com/xj/psplay/lib/PSPlayNative.java`

Native library: `System.loadLibrary("xjps-jni")` → `libxjps-jni.so`

Full JNI surface exposed:

| Method | Purpose |
|---|---|
| `discoveryServiceCreate(result, options, service)` | Start PS4/PS5 local discovery |
| `discoveryServiceFree(ptr)` | Free discovery service |
| `discoveryServiceWakeup(ptr, host, deviceId, broadcast)` | Send wake-on-LAN |
| `registStart(result, info, log, regist)` | Start PSN registration flow |
| `registStop(ptr)` / `registFree(ptr)` | Stop/free registration |
| `sessionCreate(result, connectInfo, pin, ps5, session)` | Create streaming session |
| `sessionStart(ptr)` / `sessionStop(ptr)` / `sessionJoin(ptr)` | Lifecycle control |
| `sessionSetControllerState(ptr, state)` | Send gamepad input |
| `sessionSetLoginPin(ptr, pin)` | Set PSN login PIN |
| `sessionSetSurface(ptr, surface)` | Bind video output surface |
| `videoProfilePreset(width, height, codec)` | Get video profile (H264/HEVC) |
| `errorCodeToString(code)` / `quitReasonToString(code)` | Error formatting |

This is the **Chiaki** open-source PS Remote Play protocol, compiled as `libxjps-jni.so` and wrapped with an XiaoJi-branded package name (`com.xj.psplay`). Supports both PS4 and PS5 (the `ps5` boolean flag in `sessionCreate`).

---

### §214 — LAN Cache Detection (Lancache)

`in/dragonbra/javasteam/steam/cdn/ClientLancache.java`

JavaSteam includes automatic Lancache detection:

```java
TRIGGER_DOMAIN = "lancache.steamcontent.com"
```

**Detection sequence:**
1. DNS-resolve `lancache.steamcontent.com`
2. If any resolved IP is a **private/RFC1918 address** (10.x, 172.16–31.x, 192.168.x, or fc00::/7 IPv6) → `useLanCacheServer = true`
3. Private address check covers loopback, IPv4 RFC1918, IPv6 link-local and fc00::/7

**When active — Lancache request format:**
```
HTTP GET http://lancache.steamcontent.com:80/<command>?<query>
Host: <actual CDN server hostname>
User-Agent: Valve/Steam HTTP Client 1.0
```

The `Host` header override routes CDN requests to a local Lancache server while using the same URL paths Steam CDN normally uses. This is standard Lancache protocol. The UA `"Valve/Steam HTTP Client 1.0"` impersonates the official Steam client for CDN requests.

---

### §215 — Tencent Data Statistics Endpoint

`com/xj/landscape/launcher/net/tencent/TencentStatisticsHelper.java`

Endpoint: `https://trace.inlong.qq.com/hn0_iegcommon/dataproxy/message`

Events tracked (when `LauncherUtils.canRequestTencentData()` is true):

| Event Type | Data Format | Trigger |
|---|---|---|
| `CLICK` | `tab#<n>\|module#<type>\|pos#<n>\|url#<param>\|pkg#<id>\|name#<title>` | Game card / album click |
| `SHOW` | `tab#<n>\|module#<type>\|pos#<n>\|pkg#<id>\|name#<title>` | Card impression |
| `DOWNLOAD` | `pkg#<pkgname>\|status#<n>` | Download event |
| `INSTALL` | `pkg#<pkgname>\|status#<n>` | Install event |
| `UPDATE` | `pkg#<pkgname>\|status#<n>` | Update event |
| `REMOVE` | `pkg#<pkgname>` | App removed |
| `SEARCH` | `txt#<query>` | Search submitted |
| `START_GAME` | `pkg#<pkgname>` | Game launched |

This is a Tencent IEG (Interactive Entertainment Group) internal analytics bus — the path `hn0_iegcommon/dataproxy` indicates the Hunan-0 regional proxy for IEG common telemetry. All events are fired asynchronously via `ScopeKt.h()` (Drake Net coroutine scope).

---

### §216 — Steam Community Icon URL Pattern

`com/xj/common/utils/SteamUrlHelper.java`

```java
// App icon (header image)
"https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/<appId>/<iconHash>"

// Header image (library header) — resolved via SteamCdnHelper.resolveHeaderUrl(appId)
// which queries BannerHub's BigEyes CDN → Steam store API fallback
```

`SteamUrlHelper.b` is a static boolean (`= true`) that gates whether header image lookups are enabled.

---

*[Pass 19 complete — 12 new sections (205–216) added]*

---

### §217 — SteamUserTable Schema (xj_steam_db)

`com/xj/standalone/steam/data/db/tables/SteamUserTable.java`

Room entity `SteamUserTable` — multi-account store. **Steam tokens stored in plaintext.**

| Column | Type | Notes |
|---|---|---|
| `id` | Long (PK, nullable) | Auto-increment row ID |
| `steamId` | long | Steam64 account ID |
| `accountName` | String | Steam login name |
| `refreshToken` | String? | Steam refresh JWT (long-lived) |
| `accessToken` | String? | Steam access JWT (short-lived) |
| `newGuardData` | String? | Steam Guard/2FA state blob |
| `personalName` | String? | Display name |
| `avatarUrl` | String? | Avatar image URL |
| `isCurrentUser` | boolean | Active account flag |
| `isRemember` | boolean | "Remember me" flag |
| `modifyTime` | long | Unix ms timestamp |
| `extras` | Map<String,String> | JSON blob: accountValue, change_number, gameNum, minLastPlayed, playTime |

The `extras` map is serialized as JSON by a Room TypeConverter. `getUserName()` prefers `accountName`; falls back to `personalName`. `getAccountValue()` / `getChangeNumber()` / `getPlayTime()` / etc. all read from `extras`.

`SteamDB` (database: `xj_steam_db`) exposes three DAOs: `SteamUserDao`, `SteamDownloadDao`, `SteamUserGamesDao`.

---

### §218 — SteamPicsDB Schema (xj_steam_pics_v5)

`com/xj/standalone/steam/data/db/SteamPicsDB.java` and `tables/`

`SteamPicsDB` (database: `xj_steam_pics_v5`) — four DAOs exposing the full PICS cache:

| DAO | Purpose |
|---|---|
| `SteamDepotDecryptionKeyDao` | Depot AES decryption keys |
| `SteamPackageLicenseDao` | User's license list |
| `SteamPicsAppDao` | App metadata cache |
| `SteamPicsEntryDao` | PICS change number entries |
| `SteamPicsPackageDao` | Package metadata |

**`SteamDepotDecryptionKeyTable`** columns: `id`, `appId`, `depotId`, `depotDecryptionKey` (plaintext), `modifyTime`, `extras`

**`SteamPackageLicense`** columns: `id`, `userId`, `packageId`, `accessToken`, `timeCreated`, `timeNextProcess`, `minuteLimit`, `minutesUsed`, `paymentMethod`, `purchaseCountryCode`, `ownerId`, `licenseType`, `masterPackageId`, `territoryCode`, `flags`, `changeNumber`

**App tables** (in `tables/apps/`): `SteamPicsAppInfo`, `SteamPicsAppInfoCategory`, `SteamPicsAppInfoGenres`, `SteamPicsAppInfoStoreTag`, `SteamPicsAppLastPlayedTime`, `SteamPicsAppAchievement`, `SteamPicsAppTopAchievement`, `SteamPicsAppPrice`, `SteamPicsAppInfoLocalizedAssets`, `SteamPicsAppAgeRatings`

**Package tables** (in `tables/packages/`): `SteamPicsPackageInfo`, `SteamPicsPackageInfoGrantedApp`, `SteamPicsPackageInfoGrantedDepot`

---

### §219 — Steam On-Device Filesystem Layout

`com/xj/standalone/steam/core/SteamFilePaths.java`

All paths relative to `context.getFilesDir()` (app private storage):

```
<filesDir>/
├── steam_download_cache/          # Download staging
│   └── manifest/                  # Manifest cache
│       ├── <manifestId>           # Cached manifest file
│       └── <manifestId>.tmp       # In-progress manifest
├── Steam/                         # Steam root
│   └── steamapps/
│       ├── common/                # Installed game data
│       ├── app_info/              # App info cache
│       └── config/
│           └── steam_input/
│               └── config/        # Steam Input VDF configs
│                   ├── <appId>_<configName>.vdf
│                   └── workshop_<manifestId>.vdf
└── steam_games/                   # Secondary game storage
```

**Steam Store CDN base URL** (from `EnvironmentConstants`):
```
https://shared.cloudflare.steamstatic.com/store_item_assets/steam/apps/<appId>/<filename>
```

---

### §220 — Steam CDN Pool Management

`com/xj/standalone/steam/cdn/CDNClientPool.java`, `CDNServer.java`

`CDNServer` wraps JavaSteam `Server` with per-server health tracking:
- `b` — last response time (ms)
- `c` — fail count
- `d` — suspended flag
- `e` — suspend start time
- `f` — last success time
- `h` — per-app CDN auth token cache (ConcurrentMap, appId → token)
- `g` — Mutex for token acquisition

`CDNClientPool` manages the full pool: discovery via Steam CM, failure tracking, server suspension/recovery, best-server selection. Multi-account topology: each `XjSteamClient` session gets its own pool context.

---

### §221 — SteamEventType Codes

`com/xj/standalone/steam/sdk/SteamEventType.java`

Steam change notification type codes (used to decode PICS change events):

| Event | Code |
|---|---|
| `MajorVersionUpdate` | `13` |
| `MinorVersionUpdate` | `12` |

These map to Steam's `EClientPersonaStateFlag` / `ERegistrySubTree` values used in the `PICSChangesCallback` event processing.

---

*[Pass 20 complete — 5 new sections (217–221) added]*

---

## §251–§265: ReVanced Extension — Third-Party Stores, Token Infrastructure, Performance Overlay

### §222 — GameHubPrefs: Unified Settings Hub

`app/revanced/extension/gamehub/prefs/GameHubPrefs.java`

Central SharedPreferences controller for all BannerHub extension settings. SharedPrefs name: `"steam_storage_pref"`.

**API source constants:**
| Value | Source |
|---|---|
| `0` | Official (XiaoJi `landscape-api.vgabc.com`) |
| `1` | EmuReady (`https://gamehub-lite-api.emuready.workers.dev/`) |
| `2` | BannerHub (`https://bannerhub-api.the412banner.workers.dev/`) |

`toggleAPI()` cycles: `(apiSource + 1) % 3`

**On API switch, the following are ALL cleared:**
- `sp_winemu_all_components12` SharedPreferences
- `sp_winemu_all_containers` SharedPreferences
- `sp_winemu_all_imageFs` SharedPreferences
- `pc_g_setting` SharedPreferences (per-game settings)
- `net_cookies` SharedPreferences
- Token cache (`TokenProvider.clearCache()`)
- Compatibility cache (`CompatibilityCache.clear()`)
- App cache directory

**URL resolution:** `getEffectiveApiUrl(str)` returns `str` for source 0, EmuReady URL for 1, BannerHub URL for 2.

**Storage path:** `getEffectiveStoragePath(str)` replaces `/files/Steam` prefix with custom SD card path if `use_custom_storage=true`.

**Compatibility headers for EmuReady/BannerHub requests:**
- `User-Agent: Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36`
- `Accept: application/json, text/plain, */*`
- `Accept-Language: en-US,en;q=0.9`

**Settings content-type codes:**
| Code | Meaning |
|---|---|
| `24` | SD Card storage |
| `26` | API source selector |
| `27` | Log All Requests |
| `28` | CPU Usage overlay |
| `29` | Performance Metrics overlay |

---

### §223 — BhWineLaunchHelper: Wine Process Discovery & Launch

`app/revanced/extension/gamehub/BhWineLaunchHelper.java`

Discovers and launches Wine from the Android environment without any Wine installation path hardcoded.

**Binary discovery (`findWineBinary()`):**
1. Check `WINELOADER` environment variable first
2. Scan `/proc/*/cmdline` for processes named `wineserver`, `wine64-preload`, or `wineloader`
3. In the same directory as the found process, look for: `wine64`, `wine`, `wineloader`, `wine64-preloader`

**Wine prefix:** `getWinePrefix()` reads `WINEPREFIX` from the discovered Wine process's `/proc/<pid>/environ`.

**Wine environment extraction:** `getWineEnviron()` finds the first process whose cmdline ends in `.exe`, reads `/proc/<pid>/environ`, splits on null byte `\0`, returns as `String[]`.

**Launch:** `Runtime.getRuntime().exec(new String[]{wineBinary, exePath}, wineEnviron, null)` — uses full Wine environment from running `.exe` process.

**Launchable extensions:** `.exe`, `.msi`, `.bat`, `.cmd`

**Directory listing:** `listDir(str)` — directories first, alphabetical, trailing `/` on directories.

---

### §224 — Epic Games Auth: Embedded OAuth2 Credentials

`app/revanced/extension/gamehub/EpicAuthClient.java`

**Hardcoded OAuth2 credentials (Epic Games Launcher client):**
```
CLIENT_ID     = 34a02cf8f4414e29b15921876da36f9a
CLIENT_SECRET = daafbccc737745039dffe53d94fc76cf
```

These are the **Epic Games Launcher** (EGL) public OAuth client credentials — well-known in the Legendary/Heroic open-source client community, not secret.

**Endpoints:**
- `TOKEN_URL = "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token"`
- `EXCHANGE_URL = "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange"`

**User-Agent:** `"UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"`

**Auth flow:** Web-based authorization code → `exchangeCode()` → `postToken("grant_type=authorization_code&...")` → stores `TokenResult` (accessToken, refreshToken, accountId, displayName, expiresAt).

---

### §225 — Epic Games API: Library, Catalog, Manifest

`app/revanced/extension/gamehub/EpicApiClient.java`

**Endpoints:**
| Constant | URL |
|---|---|
| `LIBRARY_URL` | `https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true` |
| `CATALOG_BASE` | `https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace` |
| `MANIFEST_BASE` | `https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace` |

**User-Agent for catalog/manifest requests:** `"Legendary/0.1.0 (GameNative)"` (impersonates Legendary CLI client)

**Library filtering:** Excludes `namespace="ue"`, `namespace="89efe5924d3d467c839449ab6ab52e7f"`, `sandboxType="PRIVATE"`. Only Windows-compatible entries (`platform="Windows"` or `"Win32"`) are listed.

**Manifest URL pattern:** `MANIFEST_BASE/<namespace>/catalogItem/<catalogItemId>/app/<appName>/label/Live`

**Pagination:** `getLibraryItems()` follows `responseMetadata.nextCursor` until null.

---

### §226 — Epic Credential Store

`app/revanced/extension/gamehub/EpicCredentialStore.java`

SharedPreferences name: `"bh_epic_prefs"`

Stores: `access_token`, `refresh_token`, `account_id`, `display_name`, `expires_at`.

**Token auto-refresh:** If token expires in < 5 minutes (`expiresAt - now < 300000`), auto-calls `EpicAuthClient.refreshToken(refreshToken)` and saves result.

---

### §227 — Epic Cloud Save Manager

`app/revanced/extension/gamehub/EpicCloudSaveManager.java`

**Base URL:** `https://datastorage-public-service-liveegs.live.use1a.on.epicgames.com/api/v1/access/egstore/savesync/`

**Connection User-Agent:** `"EpicGamesLauncher/15.17.1-22692490"`

**Upload flow:**
1. List existing cloud files → `GET <BASE><accountId>/<appName>/`
2. Request write links → `POST <BASE><accountId>/<appName>/` with `{"files": ["name1","name2"]}`
3. PUT each file to the presigned S3 URL from the `writeLink` field

**Download flow:** Same list, then GET each file via `readLink` (presigned URL).

**Debug log:** Both upload and download append timestamped entries to `/storage/emulated/0/bh_cloud_debug.txt` (visible in SD card root).

---

### §228 — GOG Galaxy Auth: Embedded OAuth2 Credentials

`app/revanced/extension/gamehub/GogTokenRefresh.java`

**Hardcoded GOG OAuth2 credentials (GOG Galaxy client):**
```
client_id     = 46899977096215655
client_secret = 9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9
```

**Token refresh URL:** `https://auth.gog.com/token?client_id=46899977096215655&client_secret=<secret>&grant_type=refresh_token&refresh_token=<token>`

**SharedPrefs name:** `"bh_gog_prefs"` — stores: `access_token`, `refresh_token`, `user_id`, `bh_gog_login_time`, `bh_gog_expires_in`, per-game `gog_client_secret_<gameId>`.

**Token expiry:** `bh_gog_login_time + bh_gog_expires_in - 300s` (5-minute window before expiry triggers refresh).

---

### §229 — GOG Cloud Save Manager

`app/revanced/extension/gamehub/GogCloudSaveManager.java`

**Base URL:** `https://cloudstorage.gog.com/v1/`

**User-Agent:** `"GOG Galaxy"`

**Endpoint pattern:** `<BASE><userId>/<clientId>/<filename>` — GET to download, PUT to upload.

**Game-scoped token:** If `gog_client_secret_<gameId>` is cached in SharedPrefs, a game-specific OAuth token is requested from `https://auth.gog.com/token?client_id=<clientId>&client_secret=<cachedSecret>&grant_type=refresh_token&...` before cloud operations.

**Error handling:** `not_enabled_for_client` or `disabled` in error body → throws `CLOUD_SAVES_NOT_SUPPORTED` sentinel exception.

---

### §230 — GOG Launch Helper: Reflection-Based Launch

`app/revanced/extension/gamehub/GogLaunchHelper.java`

**SharedPrefs name:** `"bh_gog_prefs"`, key `"pending_gog_exe"`

**Launch mechanism:** `triggerLaunch()` stores the .exe path in SharedPrefs and calls `activity.finish()`. On the next activity resume, `checkPendingLaunch()` reads the pending path and invokes `activity.getClass().getMethod("B3", String.class).invoke(activity, exePath)` — a reflection call to the obfuscated `B3` method on the host XiaoJi activity.

This is a cross-layer call from the ReVanced extension layer into the obfuscated XiaoJi layer via reflection.

---

### §231 — BhStoragePath: Unified Storage Root Abstraction

`app/revanced/extension/gamehub/BhStoragePath.java`

Uses `"steam_storage_pref"` SharedPrefs. If `use_custom_storage=true` and `steam_storage_path` is set: base = `<customPath>/bannerhub/<storeType>`. Otherwise: base = `context.getFilesDir()/<storeType>`.

**Install directories:**
- GOG games: `<base>/gog_games/<gameId>`
- (by extension) Steam, Epic, Amazon use same `getInstallDir()` pattern with their own `storeType` string

---

### §232 — Amazon Games Auth: Device Registration Protocol

`app/revanced/extension/gamehub/AmazonAuthClient.java`

**Device type (hardcoded):** `DEVICE_TYPE = "A2UMVHOX7UP4V7"` (Amazon's AGS Windows launcher device type)

**Endpoints:**
| Constant | URL |
|---|---|
| `REGISTER_URL` | `https://api.amazon.com/auth/register` |
| `REFRESH_URL` | `https://api.amazon.com/auth/token` |
| `DEREGISTER_URL` | `https://api.amazon.com/auth/deregister` |

**App identity for Amazon:** `APP_NAME = "AGSLauncher for Windows"`, `APP_VERSION = "1.0.0"`, `OS_VERSION = "10.0.19044.0"`

**User-Agent:** `"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"` (impersonates Windows Firefox)

**Device registration flow:** POSTs JSON with `authorization_code`, PKCE `code_verifier`, `device_serial`, `device_type=A2UMVHOX7UP4V7`, `domain=Device`, `app_name=AGSLauncher for Windows`. Response contains `bearer.access_token` and `bearer.refresh_token`.

---

### §233 — Amazon Games API: Entitlements & Distribution

`app/revanced/extension/gamehub/AmazonApiClient.java`

**Endpoints:**
| Constant | URL |
|---|---|
| `ENTITLEMENTS_URL` | `https://gaming.amazon.com/api/distribution/entitlements` |
| `DISTRIBUTION_URL` | `https://gaming.amazon.com/api/distribution/v2/public` |
| `SDK_CHANNEL_URL` | `https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346` |

**Gaming User-Agent:** `"com.amazon.agslauncher.win/3.0.9202.1"`

**Download User-Agent:** `"nile/0.1 Amazon"` (impersonates Nile CLI client)

**KEY_ID (hardcoded):** `"d5dc8b8b-86c8-4fc4-ae93-18c0def5314d"` — used in entitlements requests as `keyId` field

**Entitlements request body:** `Operation=GetEntitlements`, `clientId=Sonic`, `keyId=<KEY_ID>`, `hardwareHash=SHA256(deviceSerial).toUpperCase()`. Paginated via `nextToken`.

**PKCE device serial generation:** `AmazonPKCEGenerator.generateClientId(deviceSerial)` = hex encoding of `<serial>#A2UMVHOX7UP4V7`. `generateDeviceSerial()` = `UUID.randomUUID()` with dashes removed, uppercased.

---

### §234 — Amazon Credential Store: File-Based JSON

`app/revanced/extension/gamehub/AmazonCredentialStore.java`

**Credential file path:** `<context.getFilesDir()>/amazon/credentials.json`

Stores: `access_token`, `refresh_token`, `device_serial`, `client_id`, `expires_at`.

**Auto-refresh trigger:** If `expiresAt - now < 300000` (5 minutes), calls `AmazonAuthClient.refreshAccessToken(refreshToken)`. Unlike Epic (SharedPrefs) and GOG (SharedPrefs), Amazon credentials are stored as a JSON file on disk.

---

### §235 — BhSettingsExporter: Community Config Sharing

`app/revanced/extension/gamehub/BhSettingsExporter.java`

**BH version string:** `"3.5.0"` (hardcoded)

**Cloudflare Worker base:** `https://bannerhub-configs-worker.the412banner.workers.dev`

**Worker endpoints:**
| Path | Method | Purpose |
|---|---|---|
| `/upload` | POST | Upload game config (base64-encoded JSON) |
| `/list?game=<name>` | GET | List community configs for game |
| `/download?game=<folder>&file=<name>` | GET | Download a community config |

**Local export path:** `/storage/emulated/0/BannerHub/configs/<gameName>-<device>-<soc>-<timestamp>.json`

**Export JSON structure:**
```json
{
  "meta": { "app_source":"bannerhub", "device":"...", "soc":"...", "bh_version":"3.5.0", "upload_token":"<random hex>", "settings_count":N, "components_count":N },
  "settings": { <all sp key/value pairs from pc_g_setting<gameId>> },
  "components": [ {"name":"...","url":"...","type":"..."} ]
}
```

**Component keys captured in export:** `pc_ls_DXVK`, `pc_ls_VK3k`, `pc_set_constant_94` (Box64), `pc_set_constant_95` (FEXCore), `pc_ls_GPU_DRIVER_`, `pc_ls_CONTAINER_LIST`, `pc_ls_steam_client`.

**Component type-to-integer map (used in `injectComponent()` reflection call):**
| Type Name | Code |
|---|---|
| `GPU` | `10` |
| `VKD3D` | `13` |
| `Box64` | `94` |
| `FEXCore` | `95` |
| default (DXVK, containers, etc.) | `12` |

**Frontend export formats:**
- Beacon: saves `.iso` file to `/storage/emulated/0/Downloads/bannerhub/frontend/Beacon/`
- ES-DE: saves `.steam` file to `/storage/emulated/0/Downloads/bannerhub/frontend/ES-DE/`

**Missing component download:** If an imported config references components not installed, prompts user to download them. Downloads to `context.getCacheDir()`, then calls `ComponentInjectorHelper.injectComponent()` via reflection.

**SOC detection order:** (1) `device_info` SharedPrefs `gpu_renderer`; (2) `/sys/class/kgsl/kgsl-3d0/gpu_model`; (3) `Build.SOC_MODEL` (API 31+) or `Build.HARDWARE`.

---

### §236 — TokenProvider: EmuReady Token Service & Login Bypass

`app/revanced/extension/gamehub/token/TokenProvider.java`

**Critical bypass flags (hardcoded `true`):**
```java
public static boolean apiSwitchPatched = true;
public static boolean loginBypassed = true;
```

**Token service URL:** `https://gamehub-lite-token-refresher.emuready.workers.dev/token`

**Force-refresh endpoint:** `https://gamehub-lite-token-refresher.emuready.workers.dev/refresh` (POST with `{"token":"<currentToken>"}`)

**Authentication header for token service:** `X-Worker-Auth: gamehub-internal-token-fetch-2025`

**Token cache TTL:** 4 hours (14,400,000 ms)

**Three-level cache:**
1. L1: in-memory `AtomicReference<CachedToken>`
2. L2: `token_provider_pref` SharedPreferences (`cached_token`, `cached_token_expiry`)
3. L3: HTTP fetch from `gamehub-lite-token-refresher.emuready.workers.dev/token`

**`resolveToken(originalToken)` logic:**
1. If `apiSwitchPatched && isExternalAPI()` → return `"fake-token"` (EmuReady path, no real token needed)
2. If `loginBypassed` → fetch from token service (bypasses normal XiaoJi login requirement)
3. Otherwise → pass through original token

`isExternalAPI()` reads `use_external_api` boolean from `"steam_storage_pref"` (defaults `true`).

**Last-resort fallback:** If service unavailable and no cache, returns `"fake-token"`.

**`refreshTokenForOfficialApi()`:** Called from `TokenRefreshInterceptor.j()` (seen in Pass 20). If `loginBypassed=true`, clears cache and fetches a new token from the EmuReady service, bypassing the standard XiaoJi JWT refresh.

---

### §237 — SteamCdnHelper: BigEyes CDN Redirect & Batch Image Resolution

`app/revanced/extension/gamehub/network/SteamCdnHelper.java`

**CDN rewrite rule:** URLs starting with `"cdn-library-logo-global.bigeyes.com/"` (BigEyes CDN, used by XiaoJi's Chinese game library) are rewritten to `"https://shared.steamstatic.com/store_item_assets/"` + suffix — seamlessly substituting Valve's CDN for the Chinese one.

**Steam Store API:** `https://api.steampowered.com/IStoreBrowseService/GetItems/v1/` — called with `input_json` containing up to 50 appIDs per batch, requesting `include_assets: true`. Parses `asset_url_format` + `header` field per appID.

**Cache:** `"steam_cdn_cache"` SharedPreferences, TTL = 7 days (604,800,000 ms). L1: in-memory `ConcurrentHashMap<Integer, String>`.

**Batch scheduling:** Queues appIDs, fires batch 150 ms after first queued item, max 50 per batch.

**Fallback:** If no cached URL found, returns `https://shared.steamstatic.com/store_item_assets/steam/apps/<appid>/header.jpg` immediately (standard Steam CDN URL).

---

### §238 — PlaytimeHelper: Direct SQLite Cross-Database Playtime Fetch

`app/revanced/extension/gamehub/playtime/PlaytimeHelper.java`

Reads playtime directly from two Room databases using raw SQLite queries.

**Step 1:** Opens `xj_steam_db` → `SELECT id FROM steam_account WHERE is_current_user = 1 LIMIT 1` → gets current user's internal ID.

**Step 2:** Opens `xj_steam_pics_v5` → queries `t_steam_user_pics_app_last_played_times`:
```sql
SELECT app_id, playtime_forever, playtime2weeks
FROM t_steam_user_pics_app_last_played_times
WHERE user_id = ? AND playtime_forever > 0
ORDER BY playtime2weeks DESC, playtime_forever DESC
```

Converts minutes (Steam's unit) to seconds for `RecentGameEntity` fields. Uses reflection to set fields: `a` (steamAppId), `d` (totalSeconds), `e` (last14DaysSeconds) on `com.xj.game.entity.RecentGameEntity`.

---

### §239 — StorageBroadcastReceiver: IPC Storage Control

`app/revanced/extension/gamehub/steam/StorageBroadcastReceiver.java`

Registers for two implicit broadcast actions (package-namespaced):
- `<packageName>.SET_STEAM_STORAGE` — sets custom storage path from `"path"` extra; if custom storage not already enabled, also toggles it on
- `<packageName>.USE_INTERNAL_STORAGE` — forces internal storage (calls `GameHubPrefs.useInternalStorage()`)

This allows external apps/scripts to programmatically control where BannerHub stores Steam games via Android broadcasts.

---

### §240 — DeviceMetrics: Hardware Performance Probes

`app/revanced/extension/gamehub/util/DeviceMetrics.java`

**CPU usage:** `Process.getElapsedCpuTime()` delta over wall clock delta, normalized by processor count. Cached 500 ms.

**GPU usage sysfs probe sequence (in order):**
1. `/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage` — Qualcomm (integer %)
2. `/sys/class/kgsl/kgsl-3d0/gpubusy` — Qualcomm (busy/total pair)
3. `/sys/kernel/gpu/gpu_load` — Samsung
4. `/sys/devices/platform/*/gpu/utilisation` or `utilization` — Mali
5. `/sys/class/mpgpu/utilization` — Amlogic

If none readable, GPU returns -1 (N/A).

**RAM usage:** `ActivityManager.MemoryInfo` → `String.format("RAM: %.1f / %.1f GB (%d%%)", used, total, percent)`

---

### §241 — PerformanceMetricsHelper / CpuUsageHelper: In-App Overlay

`app/revanced/extension/gamehub/ui/PerformanceMetricsHelper.java`, `CpuUsageHelper.java`

Both inject `TextView` views into existing `ViewGroup` containers at runtime (no layout XML). Refresh interval: 1 second via `Handler.postDelayed()`.

`PerformanceMetricsHelper`: CPU + GPU + RAM triple overlay, only shown when `GameHubPrefs.isPerfMetricsEnabled()` (content type code 29).

`CpuUsageHelper`: Single CPU% `TextView` injected next to an `ImageView` in the existing UI, only shown when `GameHubPrefs.isCpuUsageEnabled()` (content type code 28). Locates target by `Resources.getIdentifier("tv_cpu_percent", "id", packageName)`.

Format: `"CPU: %3d%%"` (right-aligned 3-char width).

---

*[Pass 21 complete — 20 new sections (222–241) added]*

---

## §266–§275: WinEmu File Paths, GOG Download Protocol, MTDataFilesProvider, Launch Type Enum

### §242 — WinEmuFilePathsConstant: WinEmu Directory Layout

`com/xj/winemu/api/WinEmuFilePathsConstant.java`

All paths root from `PathUtils.f()` (= `context.getFilesDir()`, typically `/data/data/com.tencent.ig/files`):

| Constant | Path |
|---|---|
| `b` (base) | `<filesDir>` |
| `c`, `d` (winemu root) | `<filesDir>/xj_winemu` |
| `e` (downloads root) | `<filesDir>/xj_winemu/xj_downloads` |
| `f` (game downloads) | `<filesDir>/xj_winemu/xj_downloads_games` |
| `g` (install root) | `<filesDir>/xj_winemu/xj_install` |
| `h` (game download dir) | `<filesDir>/xj_winemu/xj_downloads_games/game` |
| `i` (env downloads) | `<filesDir>/xj_winemu/xj_downloads/env` |
| `j` (component downloads) | `<filesDir>/xj_winemu/xj_downloads/component` |
| `k` (sd downloads) | `<filesDir>/xj_winemu/xj_downloads/sd` |
| `l` (game install dir) | `<filesDir>/xj_winemu/xj_install/game` |
| `m` (env install dir) | `<filesDir>/xj_winemu/xj_install/env` |
| `n` (component install dir) | `<filesDir>/xj_winemu/xj_install/component` |

**Game install path pattern:** `<filesDir>/xj_winemu/xj_install/game/<gameId>` or `<filesDir>/xj_winemu/xj_install/game/<version>/<gameId>` when version is specified.

---

### §243 — ImportPcGameConstant: Steam Game Import Paths

`com/xj/winemu/api/ImportPcGameConstant.java`

Defines paths for importing PC games from external locations:

| Path | Value |
|---|---|
| `/Steam/steamapps` | SteamApps path fragment (constant `b`) |
| `common` | Common subdirectory name (constant `c`) |
| `/SteamGame` | External game storage subdirectory (constant `d`) |
| `externalFilesDir/SteamGame` | External files Steam games dir (constant `e`) |
| `Downloads/SteamGame` | SD card Downloads steam games (constant `f`) |
| `Downloads/Steam/steamapps` | SD card Downloads steamapps (constant `g`) |
| `<filesDir>/Steam/steamapps` | Internal steamapps (constant `h`) |

Local game manifest format: `appmanifest_<appId>.json` stored in the external files Steam game dir. Contains `LocalPcGameManifest` fields including version check (`"1.0.0"` → use Downloads path).

---

### §244 — GameLibLaunchType Enum

`com/xj/game/entity/GameLibLaunchType.java`

Game launch type enum with five values:
| Name | Ordinal |
|---|---|
| `Demo` | 0 |
| `Import` | 1 |
| `Steam` | 2 |
| `Xbox` | 3 |
| `Mobile` | 4 |

`Xbox` (3) is present but not wired to any active download logic in this build — no Xbox/Game Pass credential store found. `Import` covers manually-sideloaded games.

---

### §245 — MTDataFilesProvider: Full-Access DocumentsProvider

`app/revanced/extension/gamehub/filemanager/MTDataFilesProvider.java`

A `DocumentsProvider` that exposes the app's full internal file system to external file managers (MiXplorer `mt:` protocol and SAF).

**Security bypass:** At attach time, uses reflection to set `ContentProvider.mReadPermission = null` and `mWritePermission = null`, removing `android.permission.MANAGE_DOCUMENTS` enforcement. Any file manager that speaks the SAF protocol can access all internal files without permission checks.

**Exposed roots (virtual document tree):**
| Root path | Maps to |
|---|---|
| `<pkg>/data/*` | `context.getFilesDir().getParentFile()` — full app data dir |
| `<pkg>/android_data/*` | `context.getExternalFilesDir(null).getParentFile()` — external files |
| `<pkg>/android_obb/*` | `context.getObbDir()` — OBB directory |
| `<pkg>/user_de_data/*` | `/data/user_de/0/<pkg>` — direct-boot storage |

**MiXplorer extension methods (`mt:` prefix):**
- `mt:createSymlink` — create symlinks via `Os.symlink()`
- `mt:setLastModified` — set file timestamp
- `mt:setPermissions` — chmod via `Os.chmod()`

**Custom columns:** `mt_path` (absolute path), `mt_extras` (extended metadata blob).

**Symlink detection:** Uses `Os.lstat()` and checks `st_mode & 0xF000 == 0xA000` (S_IFLNK = 40960).

> **Security note:** This provider effectively gives any SAF-capable app with `READ_EXTERNAL_STORAGE` or `MANAGE_EXTERNAL_STORAGE` full read/write access to all of BannerHub's internal storage including Steam tokens, credentials.json, and GOG/Epic tokens — without requiring any additional permissions from the granting app.

---

### §246 — GHLog: Internal Log Tag Enum

`app/revanced/extension/gamehub/util/GHLog.java`

All BannerHub extension log tags use prefix `"GHL/"`:

| Enum | Logcat Tag |
|---|---|
| `TOKEN` | `GHL/Token` |
| `PREFS` | `GHL/Prefs` |
| `BATTERY` | `GHL/Battery` |
| `GAME_ID` | `GHL/GameId` |
| `CURRENCY` | `GHL/Currency` |
| `COMPAT` | `GHL/Compat` |
| `FILE_MGR` | `GHL/FileMgr` |
| `STORAGE` | `GHL/Storage` |
| `NET` | `GHL/Net` |
| `CDN` | `GHL/CDN` |
| `CPU` | `GHL/CPU` |
| `PERF` | `GHL/Perf` |
| `PLAYTIME` | `GHL/Playtime` |

Filter with `adb logcat -s "GHL/Token:D GHL/Prefs:D GHL/CDN:D"` to monitor BannerHub extension activity.

---

### §247 — GOG Download Manager: Content System Protocol

`app/revanced/extension/gamehub/GogDownloadManager.java`

**GOG Content System API endpoints:**
| Endpoint | Purpose |
|---|---|
| `https://content-system.gog.com/products/<gameId>/os/windows/builds?generation=2` | Gen 2 build manifest |
| `https://content-system.gog.com/products/<gameId>/os/windows/builds?generation=1` | Gen 1 build manifest (fallback) |
| `https://api.gog.com/products/<gameId>?expand=downloads` | Installer download URL |
| `https://www.gog.com/<path>` | Installer redirect follow |

**Download strategy (in priority order):**
1. **Generation 2** (GOG Galaxy content system) — most modern games
2. **Generation 1** (legacy) — older GOG games
3. **Installer download** (offline installer .exe) — if no Galaxy builds available

**`clientId` fetch:** `GogDownloadManager.getOrFetchClientId()` fetches the game's `clientId` from the gen2 builds API (field `"clientId"` in response), caches it in `"bh_gog_prefs"` as `gog_client_secret_<gameId>`. This `clientId` is then used to request game-scoped OAuth tokens.

**Debug log output:** Writes detailed debug trace to `/storage/emulated/0/bh_gog_debug.txt` (appended, not overwritten).

---

*[Pass 22 complete — 6 new sections (242–247) added]*

---

## §276–§286: Server Environments, API Signing, Store Dispatch, Community UI, SharedPrefs

### §248 — SignUtils: API Signing Algorithm (Full Confirmation)

`com/xj/common/http/SignUtils.java`

Complete decompiled signing implementation confirms the algorithm described in §8:

1. Place all request params in a `TreeMap` (auto-sorts keys alphabetically)
2. Serialize as `key1=val1&key2=val2&...` (joining with `&`)
3. Append `&all-egg-shell-y7ZatUDk` (salt)
4. MD5 the full string → lowercase hex

```java
// SignUtils.b(HashMap map):
TreeMap sorted = new TreeMap(map);
String toSign = joinAsQueryString(sorted) + "&all-egg-shell-y7ZatUDk";
return EncryptUtils.b(toSign).toLowerCase(Locale.ROOT);  // EncryptUtils.b = MD5
```

Both pre-signing log and post-signing log are emitted to Logcat tag `"SignUtils"` at INFO level — request signatures visible in plain text in debug builds.

---

### §249 — EggGameHttpConfig: Server Environments & HTTP Client Stack

`com/xj/common/http/EggGameHttpConfig.java`

**Four server environment URLs:**
| Environment | URL |
|---|---|
| `PRODUCT` | `https://landscape-api.vgabc.com/` |
| `BETA` | `https://landscape-api-beta.vgabc.com/` |
| Dev | `https://dev-gamehub-api.vgabc.com/` |
| RedMagic (hardcoded, `c()==true`) | `https://test-landscape-api.vgabc.com/` |

The resolved base URL is then passed through `GameHubPrefs.getEffectiveApiUrl()` — so in EmuReady/BannerHub mode it's replaced with the EmuReady or BannerHub Worker URL entirely.

**OkHttp interceptor chain (in order):**
1. `RemoveExtraSlashInterceptor` — normalizes URL double-slashes
2. `LogRecordInterceptor` — network request logging
3. `EggGameTokenInterceptor` — adds token header to requests
4. `TokenRefreshInterceptor` — handles 401 responses, refreshes token
5. `OfflineCacheInterceptor` — serves cached responses when offline

**Other OkHttp config:** 30s timeouts, 128MB file cache in app `getCacheDir()`, `PersistentCookieJar` (persists cookies across sessions to disk).

**Tencent URL bypass check:** `EggGameHttpConfig.Companion.b(url)` returns `true` for URLs containing `test.nj.qq.com`, `release.nj.qq.com`, or `trace.inlong.qq.com` — these Tencent telemetry/QQ Cloud URLs bypass certain interceptors.

---

### §250 — Constants: Channel Identity & Environment Flag

`com/xj/common/config/Constants.java`

**Channel identifier method `a()`:**
| Package Name | Channel String |
|---|---|
| `com.xiaoji.egggame.redmagic` | `"gamehub_redmagic"` |
| `com.xiaoji.egggame.logitech` | `"gamehub_logitech"` |
| all others (including BannerHub) | `"gamehub_android"` |

**`Constants.b = true`** — This is the "offline mode" flag checked in `TokenRefreshInterceptor.intercept()` as `Constants.a.c()`. In BannerHub's package (`com.tencent.ig`), `c()` returns false (only true for `com.xiaoji.egggame.redmagic`), so token refresh is always active.

---

### §251 — BhDownloadService: Multi-Store Download Dispatcher

`app/revanced/extension/gamehub/BhDownloadService.java`

Foreground service that dispatches downloads across three stores. Store type passed as `EXTRA_STORE` string in Intent:

| Store constant | Handler method |
|---|---|
| `"GOG"` | `runGog()` |
| `"EPIC"` | `runEpic()` |
| `"AMAZON"` | `runAmazon()` |

**Intent broadcast actions:**
- `bh.download.START` — start a download
- `bh.download.CANCEL` — cancel a running download

**Intent extras by store:**
- Common: `game_id`, `game_name`, `store`
- GOG: `gog_gid`, `gog_title`, `gog_cat`, `gog_dev`, `gog_img`, `gog_gen`
- Epic: `epic_app`, `epic_cat`, `epic_ns`
- Amazon: `amz_eid`, `amz_pid`, `amz_sku`, `amz_title`

**Notification channel:** `"bh_downloads"`

**Amazon installed files:** Written to `<filesDir>/Amazon/<filename>` (distinct from `<filesDir>/amazon/credentials.json`).

Note: Steam downloads are NOT dispatched through this service — Steam uses the dedicated `SteamDownloadManager` through the XiaoJi layer.

---

### §252 — BhGameConfigsActivity: Community Config Browser & Voting

`app/revanced/extension/gamehub/BhGameConfigsActivity.java`

**Additional Worker endpoints (beyond BhSettingsExporter):**
| Endpoint | Purpose |
|---|---|
| `<WORKER>/games` | List all games with community configs |
| `<WORKER>/list?game=<n>` | List configs for a game |
| `<WORKER>/download?game=<n>&file=<f>` | Download a specific config |
| `<WORKER>/vote` | POST vote for a config |
| `<WORKER>/report` | POST report abuse on a config |
| `<WORKER>/comment` | POST or GET comments on a config |
| `<WORKER>/delete` | DELETE a config by token |

**Steam game search:** `https://store.steampowered.com/api/storesearch/?l=english&cc=us&term=<query>` — used to auto-populate game names.

**Steam header images:** `https://cdn.akamai.steamstatic.com/steam/apps/<appId>/header.jpg` — cover art for the config browser game list.

**SharedPreferences used:**
- `bh_steam_covers` — cached Steam header image URLs
- `bh_config_uploads` — user's own uploaded configs (sha → JSON)
- `bh_config_votes` — voted config SHAs
- `bh_config_reports` — reported config SHAs

---

### §253 — Additional SharedPreferences Registry

Remaining SharedPreferences names discovered in Pass 23 scans, not previously catalogued:

| PrefsName | Owner / Purpose |
|---|---|
| `bh_prefs` | WineActivity — `sustained_perf` (boolean), `max_adreno_clocks` (boolean) |
| `hud_prefs` | HUDLayer (com.winemu.ui) — HUD overlay settings |
| `bh_config_uploads` | BhGameConfigsActivity — user's uploaded config tracking |
| `bh_config_votes` | BhGameConfigsActivity — voted config SHAs |
| `bh_config_reports` | BhGameConfigsActivity — reported config SHAs |
| `bh_steam_covers` | BhGameConfigsActivity — cached Steam header image cache |
| `token_provider_pref` | TokenProvider — `cached_token`, `cached_token_expiry` |
| `steam_cdn_cache` | SteamCdnHelper — CDN URL cache by appId |

---

*[Pass 23 complete — 6 new sections (248–253) added]*

---

### §254 — Chinese Telecom Carrier Authentication (One-Click Login)

`com/xj/psplay/regist/RegistExecuteActivity.java`

The original XiaoJi app includes **carrier-based one-click phone number verification** — a uniquely Chinese mobile authentication pattern where the carrier supplies the phone number directly without requiring SMS OTP entry.

**China Mobile (CMCC):**
```
CMCC_URL = "https://verify.cmpassport.com/h5/getMobile"
```

**China Unicom (CUCC):**
```
CUCC_GET_AUTH_ADDR_URL = "https://nisportal.10010.com:9001/api"
```

Both implement the Chinese industry standard "一键登录" (One-Click Login): the app obtains a temporary auth token from the carrier SDK at runtime, submits it to the carrier's verify URL, and receives the user's phone number (masked or partial). This is only functional when the device has an active SIM from that carrier.

**Significance:** Confirms the APK's Chinese market origin. The RegistExecuteActivity is part of the `com.xj.psplay` registration flow, not the BannerHub ReVanced layer.

---

### §255 — GOG OAuth Web Login Flow

`app/revanced/extension/gamehub/GogLoginActivity.java`

**Auth URL (hardcoded):**
```
https://auth.gog.com/auth
  ?client_id=46899977096215655
  &redirect_uri=https://embed.gog.com/on_login_success?origin=client
  &response_type=token
  &layout=client2
```

**Flow:**
1. Loads `AUTH_URL` in WebView with `User-Agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) GOG Galaxy/2.0"`
2. Intercepts redirect to `https://embed.gog.com/on_login_success`
3. Extracts `access_token`, `refresh_token`, `user_id` from URL fragment (implicit grant)
4. Fetches username via `https://embed.gog.com/userData.json` with Bearer header
5. Saves to SharedPreferences `"bh_gog_prefs"` with 3600-second hardcoded expiry

Note: `response_type=token` is the **implicit grant flow** — access token arrives directly in the URL fragment, no authorization code exchange needed.

---

### §256 — Epic Games OAuth Web Login Flow

`app/revanced/extension/gamehub/EpicLoginActivity.java`

**Auth URL (hardcoded):**
```
https://www.epicgames.com/id/login
  ?redirectUrl=https://www.epicgames.com/id/api/redirect
      ?clientId=34a02cf8f4414e29b15921876da36f9a
      &responseType=code
```

**REDIRECT_HOST:** `"https://www.epicgames.com/id/api/redirect"`

**Flow:**
1. Loads `AUTH_URL` in WebView with UA `"UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"`
2. When `onPageFinished` fires on `REDIRECT_HOST`, calls `evaluateJavascript` to extract `document.body.innerText`
3. Parses `authorizationCode` field from JSON page body
4. Exchanges code via `EpicAuthClient.exchangeCode(code)` on background thread (calls `TOKEN_URL` + `EXCHANGE_URL`)
5. Saves `EpicCredentialStore.Credentials` (access/refresh token, accountId, displayName, expiresAt) to `"bh_epic_prefs"`

The code exchange is an authorization code flow: code → token exchange uses the CLIENT_ID/CLIENT_SECRET from §224.

---

### §257 — Amazon OpenID / PKCE Login Flow

`app/revanced/extension/gamehub/AmazonLoginActivity.java`
`app/revanced/extension/gamehub/AmazonPKCEGenerator.java`

**Auth URL (dynamically built):**
```
https://www.amazon.com/ap/signin
  ?openid.ns=http://specs.openid.net/auth/2.0
  &openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select
  &openid.mode=checkid_setup
  &openid.oa2.scope=device_auth_access
  &openid.oa2.response_type=code
  &openid.oa2.code_challenge_method=S256
  &openid.oa2.client_id=device:<clientId>
  &openid.assoc_handle=amzn_sonic_games_launcher
  &pageId=amzn_sonic_games_launcher
  &openid.oa2.code_challenge=<challenge>
```

**PKCE Key Derivation (`AmazonPKCEGenerator`):**
- `deviceSerial` = `UUID.randomUUID()` uppercase, dashes stripped
- `clientId` = hex encoding of `(deviceSerial + "#A2UMVHOX7UP4V7").getBytes(UTF-8)`
- `codeVerifier` = Base64-URL (no padding) of 32 random bytes
- `codeChallenge` = Base64-URL (no padding) of SHA-256(codeVerifier)
- `sha256Upper` utility also present for Amazon HMAC auth

**Flow:** Intercepts redirect containing `openid.oa2.authorization_code=`, passes code + verifier + serial + clientId to `AmazonAuthClient.registerDevice()`, which registers the device and obtains access/refresh tokens. Saves to `<filesDir>/amazon/credentials.json` via `AmazonCredentialStore`.

---

### §258 — Amazon Manifest Format and SDK Deployment

`app/revanced/extension/gamehub/AmazonManifest.java`
`app/revanced/extension/gamehub/AmazonSdkManager.java`
`app/revanced/extension/gamehub/AmazonDownloadManager.java`

**Manifest format:** Custom protobuf-like binary at `<downloadUrl>/manifest.proto`
- Big-endian 4-byte header size → then protobuf header (compression field 1.1 = algo: 0=LZMA, 1=XZ)
- Remaining bytes = XZ/LZMA compressed protobuf body: packages → files (path, size, hash)
- Decompression requires `org.tukaani.xz` (XZInputStream / LZMAInputStream via reflection)

**Download parallelism:** 8 threads (`MAX_PARALLEL = 8`), 3 retries per file, SHA-256 file integrity check

**Debug log:** Written to `<externalFilesDir>/bh_amazon_debug.txt` (or `<filesDir>/bh_amazon_debug.txt`)

**SDK Manager** (`AmazonSdkManager`): Downloads Amazon Games SDK DLLs from the same manifest/CDN system
- Filters for `"Amazon Games Services"` directory containing `FuelSDK_x64.dll` and `AmazonGamesSDK` files
- Cached at `<filesDir>/amazon_sdk/Amazon Games Services/`; version tag at `<filesDir>/amazon_sdk/.sdk_version`
- `deploySdkToPrefix(prefix)`: copies SDK DLLs into Wine prefix `Amazon Games Services/` subdirectory
- Auth header: `x-amzn-token: <access_token>` on all SDK file downloads

---

### §259 — Epic Games Manifest Format and Download Engine

`app/revanced/extension/gamehub/EpicDownloadManager.java`

Epic uses the **Legendary-compatible binary/JSON manifest** format (Epic Games Launcher internal protocol).

**Binary manifest magic:** `0x44BEC00C` (LE) — presence triggers binary parser; otherwise JSON fallback
- Manifest version ≥ 15 → `ChunksV4`, ≥ 6 → `ChunksV3`, ≥ 3 → `ChunksV2`, else `Chunks`
- Chunk GUID format: `%08X%08X%08X%08X`, path: `%02d/<hash16>_<guid>.chunk`
- Chunks zlib-deflate compressed; decompressed via `Inflater`

**CDN URL parsing:** Extracts `"uri"` arrays from manifest API JSON `"manifests"` array, strips Cloudflare CDN (`cloudflare.epicgamescdn.com` excluded), parses `"queryParams"` for signed URL auth.

**Download engine:**
- 8 parallel worker threads, chunks assembled in memory then written to final file paths
- `bh_epic_debug.txt` written to `<externalFilesDir>` on install completion or failure

**Two download modes:**
1. `downloadChunk()` — downloads full chunk, decompresses in memory, writes to `.chunks/<guid>` cache
2. `downloadChunkStreaming()` — streaming inflate: reads 41-byte chunk header inline, streams decompression

**Install size estimation:** Sums `windowSize` of all chunks from manifest (pre-decompress size).

---

### §260 — PlayStation Network Remote Play Registration

`com/xj/psplay/ui/register/RegisterNicknamePSNActivity.java`
`com/xj/psplay/ui/register/vm/RegisterNicknamePSNVM.java`
`com/xj/psplay/common/Preferences.java`

**PSN OAuth2 Authorization URL (hardcoded):**
```
https://auth.api.sonyentertainmentnetwork.com/2.0/oauth/authorize
  ?service_entity=urn:service-entity:psn
  &response_type=code
  &client_id=ba495a24-818c-472b-b12d-ff231c1b5745
  &redirect_uri=https://remoteplay.dl.playstation.net/remoteplay/redirect
  &scope=psn:clientapp
  &request_locale=<locale>
  &ui=pr
  &service_logo=ps
  &layout_type=popup
  &smcid=remoteplay
  &prompt=always
  &PlatformPrivacyWs1=minimal
```

This is the **Chiaki open-source PS Remote Play** client OAuth flow. `client_id=ba495a24-818c-472b-b12d-ff231c1b5745` is the well-known Chiaki/PS Remote Play redirect client ID used by the open-source community.

**XiaoJi backend PS5 API routes** (relative to `landscape-api.vgabc.com`):
| Route | Purpose |
|---|---|
| `POST /ps5/get_ps5_user` | Look up PS5 user by PSN Online ID |
| `POST /ps5/get_ps5_user_by_code` | Look up PS5 user by OAuth code |
| `POST /ps5/get_ps5_connection_type` | Determine direct vs. relay connection type |

**PS Remote Play preferences** (Android `PreferenceManager` default prefs):
| Key | Default | Values |
|---|---|---|
| `preferences_resolution_key` | `1080p` | 360p / 540p / 720p / 1080p |
| `preferences_fps_key` | `60` | 30 / 60 |
| `preferences_codec_key` | `h265` | h264 / h265 |
| `preferences_bitrate_key` | 0 (auto) | 2000–50000 kbps |
| `preferences_discovery_enabled_key` | true | bool |
| `preferences_rumble_enabled_key` | true | bool |
| `preferences_motion_enabled_key` | true | bool |
| `preferences_touchpad_only_enabled_key` | true | bool |
| `preferences_on_screen_controls_enabled_key` | false | bool |
| `preferences_button_haptic_enabled_key` | true | bool |
| `preferences_log_verbose_key` | false | bool |
| `preferences_swap_cross_moon_key` | false | bool |

---

### §261 — Cloud Gaming WebSocket Endpoints

`com/xj/cloud/config/CloudGameApi.java`

The cloud gaming module (streaming cloud games, not to be confused with PC streaming) uses WebSocket:

| Environment | WebSocket URL |
|---|---|
| Production / Beta | `wss://sessions-saas.movingcloudgame.cn/` |
| Dev / Other | `wss://cloud.dev.movingcloudgame.com/` |

**Provider:** MovingCloud (`movingcloudgame.cn`) — a third-party Chinese cloud gaming service integrated into XiaoJi.

The production endpoint uses `.cn` domain (Chinese CDN), while dev uses `.com`. Environment selection is based on `AppConfig.ServerEnv` (`PRODUCT` or `BETA` → `.cn`, anything else → `.com`).

---

### §262 — Controller OTA Firmware Update System

`com/xj/ota/`

The OTA module manages firmware updates for XiaoJi-branded physical controllers via USB and BLE. Supported device families:

| Class | Device |
|---|---|
| `G8TypeCOTA` | G8 USB-C controller |
| `G8PlusMFiOTA` | G8+ MFi |
| `G8SeOTA` | G8 SE |
| `T4nLiteOTA` | T4n Lite (BLE) |
| `T4nProOTA` | T4n Pro |
| `X3ProOTA` / `X3ProPdOTA` | X3 Pro |
| `X5LiteOTA` / `ZikWayUsbOTA` | X5 Lite (ZikWay protocol) |
| `JieLiUsbOTA` / `JieLiSingleFirmwareDeviceOTA` | JieLi chipset devices |
| `Nova2LiteOTA` | Nova2 Lite |

**Firmware list API** (`BaseOTARepository`):
- Base URL: `http://127.0.0.1` (placeholder — actual URL injected at runtime by subclass)
- GET params: `version`, `beta` (0/1), `name` (device name), `appver`, `new_version` (0/1), `lang`, `agreement=6`, `all_upgrade=all`
- The OTA base URL placeholder `127.0.0.1` suggests subclasses override it with the real endpoint (likely `landscape-api.vgabc.com/firmware/...` based on the common HTTP stack)

**BLE OTA scan** (T4NLiteOTA): Scans for BLE device by MAC prefix, performs DFU over BLE with progress notifications.

---

### §263 — PC Streaming (Moonlight/GameStream) Module

`com/xj/module_pcstream/`

The PC streaming module implements **Moonlight/NVIDIA GameStream** over local network — allowing the app to stream games from a paired Windows PC.

**Pairing flow:** `PcView.doPair()` — sends PIN via XiaoJi backend POST to get pairing code; the actual Moonlight HTTPS pair handshake with the PC happens on the local network (port 47984).

**QR Code login API routes** (relative to `landscape-api.vgabc.com`):
| Route | Purpose |
|---|---|
| `POST /user/mobileScanCode` | Report QR code scan event |
| `POST /user/mobileConfirmCode` | Confirm QR login (approve from mobile) |
| `POST /user/mobileCancelCode` | Cancel QR login |
| `POST baseLink/getBaseLink` | Get share link for PC stream session |

**SharedPreference key:** `"pc_stream_last_pair_" + uid` — stores last paired PC per user account.

**PC metadata entity:** `PcStreamDevEntity`, `PcStreamDevInfoEntity`, `MyComputerObject` — represent discovered/paired PCs.

**Settings:** Resolution, bitrate, frame rate, audio, input mapping stored in `PcStreamHelper` preferences. The `AdvancedSettingsFragment`, `AudioSettingsFragment`, `HandleSettingsFragment` handle granular PC stream config.

---

### §264 — CompatibilityCache and Reflection-Based UI Injection

`app/revanced/extension/gamehub/ui/CompatibilityCache.java`
`app/revanced/extension/gamehub/ui/GameIdHelper.java`

**CompatibilityCache** is a global `ConcurrentHashMap<String, Object>` that caches compatibility rating objects by Steam App ID. When XiaoJi's original `RecentGameEntity.getCst_data()` returns null, BannerHub injects the cached compat data by:
1. Calling `getSteamAppId()` on the entity via reflection
2. Looking up cached compat object by appId
3. Using reflection to read `getTitle()`, `getIcon()`, `getDesc()`, `getLevel()` from the cached object
4. Constructing `com.xj.common.service.bean.GameCompatibilityParams` via its constructor via `Class.forName` + `Constructor.newInstance`

**GameIdHelper** (`app/revanced/extension/gamehub/ui/GameIdHelper.java`) injects Steam App ID and local game ID display into XiaoJi activities:
- Reads `steamAppId` and `localGameId` from Intent extras
- Looks up `"ll_game_id_container"`, `"tv_steam_app_id"`, `"tv_local_game_id"` view IDs by resource name string via `getResources().getIdentifier()`
- On tap: copies ID to clipboard with Toast confirmation

---

### §265 — muugi Shortcut Library

`com/xj/muugi/shortcut/`

The `muugi` package is a **home screen shortcut management library** embedded in the app. It provides a clean API to create/update/delete Android launcher shortcuts:

- `ShortcutCore` — main entry point
- `ShortcutAction` / `WrapShortcutAction` — encapsulates a shortcut with label, icon, intent
- `DefaultExecutor` / `Executor` — manages shortcut pinning on API 26+ vs. legacy broadcast
- `NormalCreateBroadcastReceiver` / `AutoCreateBroadcastReceiver` — handle legacy shortcut install intents
- `ShortcutPermissionChecker` — checks `com.android.launcher.permission.INSTALL_SHORTCUT` and `REQUEST_INSTALL_PACKAGES`
- `AllRequest` / `SettingRequest` — request batches for shortcut permission flows
- `RuntimeSettingPage` — opens system settings for shortcut permission

**Use in GameHub:** Enables one-tap shortcuts to individual game library entries on the Android home screen.

*[Pass 24 complete — 12 new sections (254–265) added]*

---

## §287–§288: SteamAgent Status Events, Additional API Routes (Pass 25)

### §266 — Jiguang (极光) Push SDK Integration

`com/xj/push/jiguang/JPushBroadcastReceiver.java`
`com/xj/push/jiguang/JPushService.java`

**JPushBroadcastReceiver** extends `cn.jpush.android.service.JPushMessageReceiver` — XiaoJi's push notification wrapper:

| Callback | Behavior |
|---|---|
| `onRegister` | Logs registration ID to `"JPushBroadcastReceiver"` tag |
| `onMessage` | Handles silent push messages |
| `onNotifyMessageOpened` | Reads `notificationMessage.deeplink` — navigates to deeplink URL on notification tap |
| `onAliasOperatorResult` | Handles alias set/get result |
| `onTagOperatorResult` | Handles tag set/get result |

**JPushService** simply extends `cn.jpush.android.service.JCommonService` — a thin binding wrapper, no custom logic.

**Deeplink support:** The notification system supports `deeplink` URI values in push payloads that can navigate directly to specific app screens.

---

### §267 — Device Whitelist Manager

`com/xj/bussiness/devicemanagement/utils/DeviceWhiteListManager.java`

**API endpoint:** `GET /devices/getDevicesList`
- Fetches the authorized controller device list from the server
- Caches result in `SharedPreferences` key `"device_white_list"` as a JSON array of `DeviceItemEntity` objects
- Chinese error message for empty whitelist: `"白名单为空，请联系管理员"` (Whitelist is empty, please contact admin)

**AdapterType enum** (controller tier classifications):

| Value | Meaning |
|---|---|
| `XIAOJI_PRO(1)` | XiaoJi Pro series (first-party) |
| `XIAOJI_LITE(2)` | XiaoJi Lite series (first-party) |
| `MAINSTREAM_BRAND(3)` | Major third-party brands (GameSir, Razer, etc.) |
| `GENERIC(4)` | Generic/uncategorized controllers |
| `LEAD_JOY(5)` | LeadJoy brand controllers |

---

### §268 — GameSir BLE UUIDs and Controller Protocol

`com/xj/bussiness/devicemanagement/device/GameSirSpecifications.java`
`com/xj/bussiness/devicemanagement/device/BaseBleDeviceImpl.java`
`com/xj/bussiness/devicemanagement/device/DeviceBleProtocol.java`
`com/xj/bussiness/devicemanagement/utils/DeviceManager.java`

**GameSir BLE UUIDs (`GameSirSpecifications`):**

| UUID | Purpose |
|---|---|
| `00008650-0000-1000-8000-00805f9b34fb` | GameSir primary service UUID |
| `0000865f-0000-1000-8000-00805f9b34fb` | Write characteristic |
| `00008655-0000-1000-8000-00805f9b34fb` | Notify/indicate characteristic |
| `0000180a-0000-1000-8000-00805f9b34fb` | Device Information Service (standard BLE DIS) |
| `00002a26-0000-1000-8000-00805f9b34fb` | Firmware Revision String (DIS characteristic) |
| `0000180f-0000-1000-8000-00805f9b34fb` | Battery Service (standard BLE BAS) |
| `00002a19-0000-1000-8000-00805f9b34fb` | Battery Level (BAS characteristic) |

**BaseBleDeviceImpl (abstract)** defines the BLE I/O interface:
- `write(byte[], int, boolean)` — write bytes to controller (withReply flag)
- `writeWithCallback(byte[], int, onSuccess, onFail)` — write with result callbacks
- `connect(String addr)` / `disconnect()` / `readMode()` / `readModes()` — connection lifecycle

**DeviceBleProtocol** wraps `BLEManager.a` for actual GATT operations; holds a `BluetoothDevice` and `IGattNotifyListener` for incoming notifications.

**DeviceManager** is the singleton controller hub:
- Dual transport: **BLE** (`BLEManager`) and **USB** (`USBManager` + `UsbOTGService`)
- Device-type routing: `GameSirX3ProManagement`, `GameSirG8Management` for model-specific handling
- GCM (Game Controller Manager) protocol: queries firmware via `GcmProtocol.writeBasicInfoCMD_Query()` and `writeModeCMD_Query()`
- `IDeviceStateChangeListener.onConnectState(bool)` — fires on connect/disconnect
- `IDeviceStateChangeListener.onDeviceInfo(DeviceInfo)` — fires when controller info is read

**GameHubGCMUtils.queryFirmwareInfoWithRetry(retries=3, delay=500ms):**
Retries `writeBasicInfoCMD_Query()` up to N times, waiting for `DeviceInfo.d()` (firmware list) to be populated before proceeding.

**Device set sub-packages** (specific controller management):
- `device/set/g8/` — GameSir G8 management
- `device/set/g8plus_mfi/` — G8 Plus MFI
- `device/set/g8se/` — G8 SE
- `device/set/leadjoy/` — LeadJoy
- `device/set/nova/` — Nova2 Lite
- `device/set/x3pro/` — X3 Pro
- `device/set/x5lite/` — X5 Lite
- `device/set/x5s/` — X5S
- `device/set/xinput/` — XInput generic

*[Pass 25 complete — 3 new sections (266–268) added]*

---

## §289–§291: API Route Reference, TokenProvider EmuReady, SteamCdnHelper (Pass 26)

### §269 — Complete API Route Inventory (All Modules)

Comprehensive extraction via smali `const-string` analysis across all DEX files. Routes are grouped by functional domain.

#### Card / Content Routes
| Route | Method | Purpose |
|---|---|---|
| `card/getIndexList` | GET | Home screen card list |
| `card/getGameDetail` | GET/POST | Individual game detail card |
| `card/getTopPlatform` | GET | Top platform cards |
| `card/getNewsList` | POST | News list |
| `card/getNewDetail` | POST | News article detail |
| `card/getNewsGuideDetail` | POST | Guide detail |
| `card/getAlbumDetail` | POST | Album/gallery detail |
| `card/getGameIcon` | POST | Game icon fetch |
| `card/getSearchHot` | GET | Hot search terms |
| `card/more` | POST | Load more card content |
| `card/getCtsList` | POST | Compatibility list (`steam_appids` or `game_ids` param) |

#### Game / Library Routes
| Route | Method | Purpose |
|---|---|---|
| `game/getClassify` | GET | Platform/category classifications |
| `game/getIndexList` | POST | Game index list |
| `game/getGameCircleList` | GET | Game community/circle list |
| `game/getGameTopCategoryIdList` | POST | Top-level category IDs |
| `game/videoGameList` | POST | Video game list |
| `game/checkIsCloudGame` | POST | Check if game supports cloud gaming |
| `game/checkLocalHandTourGame` | POST | Check if game is a mobile game |
| `game/userPlayedGame` | POST | Report game launch / playtime start |
| `game/getSteamHost` | POST | Get Steam download CDN host |
| `game/cts/report` | POST | Submit compatibility rating report |

#### Simulator / Container Routes (WinEmu)
| Route | Method | Purpose |
|---|---|---|
| `simulator/getTabList` | POST | Emulator tab list |
| `simulator/getLocalGameDetail` | POST | Local game detail (single) |
| `simulator/getLocalMultiGameDetail` | POST | Local game detail (batch) |
| `simulator/executeScript` | POST | Execute install script server-side |
| `simulator/v2/getContainerList` | POST | Wine container list v2 |
| `simulator/v2/getContainerDetail` | POST | Container detail v2 |
| `simulator/v2/getAllComponentList` | POST | All available components v2 |
| `simulator/v2/getComponentList` | POST | Component list (filtered) v2 |
| `simulator/v2/getComponentDetail` | POST | Component detail v2 |
| `simulator/v2/getDefaultComponent` | POST | Default component recommendation v2 |
| `simulator/v2/getImagefsDetail` | POST | ImageFS (rootfs image) detail v2 |
| `order/get_down_info` | POST | Get download order info |

#### Heartbeat / Session Tracking
| Route | Method | Purpose |
|---|---|---|
| `heartbeat/game/start` | POST | Start game session timer |
| `heartbeat/game/update` | POST | Heartbeat ping during gameplay |
| `heartbeat/game/end` | POST | End game session, report duration |
| `heartbeat/game/getUserPlayTimeList` | POST | Fetch user's historical play time list |

#### Cloud Gaming Routes
| Route | Method | Purpose |
|---|---|---|
| `cloud/game/auth_token` | POST | Authenticate and get cloud gaming token |
| `cloud/game/start_token` | POST | Start cloud session token exchange |
| `cloud/game/renew_token` | POST | Renew expiring cloud session token |
| `cloud/game/startQueue` | POST | Join the matchmaking queue |
| `cloud/game/confirmPlay` | POST | Confirm queue slot and start session |
| `cloud/game/exit` | POST | Exit cloud gaming session |
| `cloud/game/getQueueInfo` | POST | Get current queue position/status |
| `cloud/game/getQueueCalendar` | POST | Get queue schedule calendar |
| `cloud/game/getNewsList` | POST | Cloud gaming news list |
| `cloud/game/getNewsDetail` | POST | Cloud gaming news detail |
| `cloud/game/check_user_timer` | POST | Check user's remaining cloud gaming time |
| `cloud/order_list` | POST | List cloud gaming orders |
| `cloud/use_time_log` | POST | Cloud time usage log |
| `cloud/h5/exchange_code` | POST | Exchange voucher code for cloud gaming time |
| `cloud/payment` | POST | Initiate cloud gaming payment |
| `cloud/game/get_goods_list` | POST | Cloud gaming subscription/goods list |
| `cloud/order/info` | POST | Cloud order info |

#### Social / User Routes
| Route | Method | Purpose |
|---|---|---|
| `social/getUserInfo` | POST | Get another user's profile |
| `social/userNoticeList` | POST | User notification list |
| `social/userUpdateNotice` | POST | Mark notification as read |
| `social/deleteFriend` | POST | Remove friend |
| `user/info` | POST | Get current user profile |
| `user/getMobileCode` | POST | Request SMS verification code |
| `usr/home/components` | POST | Home screen component config (BannerHub injection target) |
| `usr/home/containers` | POST | Home screen container config |

#### Settings / Config Routes
| Route | Method | Purpose |
|---|---|---|
| `settings/getNotifySwitch` | POST | Get push notification preferences |
| `settings/updateNotifySwitch` | POST | Update push notification preferences |
| `base/getBaseInfo` | POST | Get base app configuration info |
| `doc/docList` | POST | Get documentation/help article list |

#### Search Routes
| Route | Method | Purpose |
|---|---|---|
| `search/getHotTrending` | GET | Trending search keywords |
| `search/getGameList` | POST | Full-text game search results |

#### Device Routes
| Route | Method | Purpose |
|---|---|---|
| `devices/getDevicesList` | GET | Authorized controller device whitelist |
| `devices/getUnknownDevices` | POST | Report/check unknown device model |
| `devices/getMapping` | POST | Get device→key mapping config (from ADB module) |

#### VTouch (Button Mapping) Routes
| Route | Method | Purpose |
|---|---|---|
| `/vtouch/vtouchGetConfig` | POST | Get cloud button mapping config for package |
| `/vtouch/vtouchUploadConfig` | POST | Upload/backup local config to cloud |
| `/vtouch/vtouchDelConfig` | POST | Delete backed-up config |
| `/vtouch/vtouchDetail` | POST | Get specific mapping config detail |
| `/vtouch/vtouchRevoke` | POST | Revoke/unsave a shared config |
| `/vtouch/vtouchShare` | POST | Share a mapping config publicly |
| `/vtouch/vtouchShareSearch` | POST | Search shared mapping configs by keyword |
| `/vtouch/getOfficial` | POST | Get official default mapping config |
| `/doc/docVtouchList` | POST | VTouch tutorial/doc list |

#### Statistics / Analytics Routes
| Route | Method | Purpose |
|---|---|---|
| `statistics/activeUsersStatistics` | POST | Active user activity report |
| `statistics/openTypeStatistics` | POST | App open source/type report |
| `statistics/streamUsageStatistics` | POST | Streaming usage duration report |

**EventTracker `UserActivityReportType` enum:**
- `ACCOUNT_LOGIN_SUCCESS` — account login
- `NICKNAME_LOGIN_SUCCESS` — nickname/guest login
- `PC_STREAM_USAGE_DURATION` — PC stream session
- `PS_STREAM_USAGE_DURATION` — PS Remote Play session
- `START_PS_STREAM_SUCCESS` — PS stream started

---

### §270 — BhSettingsExporter and Frontend Export Paths

`app/revanced/extension/gamehub/BhSettingsExporter.java`

**BhSettingsExporter** exports BannerHub configuration to external app frontends. Key export paths under `DIRECTORY_DOWNLOADS`:

| Path | Purpose |
|---|---|
| `Downloads/bannerhub/frontend/Beacon/` | Export directory for Beacon frontend integration |
| `Downloads/bannerhub/frontend/ES-DE/` | Export directory for ES-DE (EmulationStation Desktop Edition) integration |
| `Downloads/bannerhub/frontend/` | Base frontend export path (used for font/resolution config) |

**Config export format:**
- ISO-named files: `<sanitized_name>.iso` written to the target frontend directory
- Sanitizes filenames: replaces `[\\/:*?"<>|]` with `_`
- Uses `FileWriter` to write content, then posts to main thread Handler for UI callback

**Settings JSON structure exported:**
```json
{
  "meta": {
    "app_source": "bannerhub",
    "device": { "gpu_renderer": "..." },
    "soc": "...",
    "bh_version": "...",
    "upload_token": "...",
    "settings_count": N,
    "components_count": N
  },
  "settings": { ... },
  "components": { ... }
}
```

**Component injection call:** `ComponentInjectorHelper.injectComponent()` is invoked via reflection after fetching `usr/home/components` from the server — this is how BannerHub injects custom components into XiaoJi's home screen without modifying the host app.

**Key preference keys in export:**
- `"banners_sources"` — list of launcher banner sources (url + type)
- `"pc_g_setting"` — PC emulator global settings blob
- `"pc_ls_DXVK"` — DXVK version selection
- `"pc_ls_VK3k"` — VK3K/Turnip selection
- `"pc_set_constant_94"`, `"pc_set_constant_95"` — numeric constant settings
- `"pc_ls_GPU_DRIVER_"` — GPU driver selection prefix
- `"pc_ls_CONTAINER_LIST"` — container list setting
- `"pc_ls_steam_client"` — Steam client selection

*[Pass 26 complete — 2 new sections (269–270) added]*

---

## §292–§299: Amazon/Epic/GOG OAuth Clients, Credential Stores, Data Models (Pass 27)

### §271 — WinEmu Core Server Architecture

`com/winemu/core/server/XServer.java`
`com/winemu/core/server/alsaserver/`
`com/winemu/core/server/wm/`
`com/winemu/core/server/winmonitor/`
`com/winemu/core/server/socket/`

**XServer** (`libxserver.so`) — custom X11 display server bridge:
- `start(String displaySocket, String[] args)` — starts X server native process
- `startUI()` — initializes UI rendering layer
- `surfaceChanged(Surface)` — passes Android `Surface` to the X server renderer
- `setRenderingEnabled(bool)` — toggle rendering
- `setShmPath(String)` — set shared memory path for frame buffer exchange
- `setSurfaceFormat(int)` — set pixel format
- Native input injection:
  - `sendKeyEvent(keyCode, scanCode, isDown)`
  - `sendMouseEvent(x, y, button, isDown, isScroll)`
  - `sendTouchEvent(pointerId, x, y, action)`
  - `sendTextEvent(byte[])` — UTF-8 text injection
  - `sendWindowChange(width, height, scale, title)` — resize/retitle window
- Window lifecycle callbacks: `onWindowRealized` / `onWindowUnrealized`

**ALSAClient** (`libwinemu.so`) — ALSA audio output bridge:
- Uses `AudioTrack` as Android audio sink
- `DataType` enum: `U8(1)`, `S16LE(2)`, `S16BE(2)`, `FLOATLE(4)`, `FLOATBE(4)` — sample format
- Channel count stored in `c` field; sample rate in `f`; buffer in `h` (ByteBuffer backed by SysV shared memory)
- Native down-mix methods: `downMix8Bit`, `downMix16Bit`, `downMixFloat`

**WMRequestHandler / WMPlugin** — Wine Window Manager IPC:
- Unix socket–based client/server (from `socket/` sub-package)
- Request code `0x1` → `wMPlugin.c().b()` (window state event; exact action in native `WMPlugin`)

**WinMonitorClient** — runtime process/thread monitor for Wine:
- `ProcessListResponse`, `ThreadListResponse`, `ThreadDetailInfo`, `ThreadStackResponse`
- `KillProcessResponse` — remote kill capability
- `CommandRequest` — send arbitrary command to monitored Wine process

---

### §272 — MitmProxy and Certificate Management

`com/winemu/core/mitm/MitmProxy.java`
`com/winemu/core/mitm/MitmCAKt.java`

**MitmProxy** (`libmitm.so`) — embedded HTTPS MITM proxy for Wine traffic interception:

```java
// Singleton native library wrapper
MitmProxy.a.setCertificate(certPem, keyPem)  // install CA cert+key
MitmProxy.a.setConfig(jsonConfig)            // set proxy config JSON
MitmProxy.a.start(proxyPort, dnsPort)        // start proxy
MitmProxy.a.stop()                           // stop proxy
MitmProxy.a.getPort()                        // get actual proxy port
MitmProxy.a.getDnsPort()                     // get actual DNS port
```

**File paths used by MITM system** (from smali `const-string` analysis):
- `etc/config.mitm.json` — MITM configuration
- `etc/mitm.crt` — CA certificate
- `etc/mitm.crt.hash` — certificate hash (for system cert store)
- `etc/hosts` — custom hosts file

**Purpose:** Intercepts Windows application HTTPS traffic inside the Wine container — used for Steam DRM bypass, login token injection, and potentially for the `emulator/auth/handler` auth flow seen in route inventory.

---

### §273 — SteamAgentServer IPC Protocol

`com/winemu/core/steam_agent/SteamAgentServer.java`
`com/winemu/core/steam_agent/AgentCmd.java`
`com/winemu/core/steam_agent/StatusData.java`

**SteamAgentServer** is an in-process TCP server (JSON newline-delimited protocol) that bridges the Android WinEmu layer with a Steam client running inside Wine:

**Message types (field `"type"`):**

| Type | Direction | Handling |
|---|---|---|
| `"status"` | Wine→Android | Parsed into `StatusData` → `SteamAgentServerCallback.b(StatusData)` |
| `"command"` | Wine→Android | Dispatched to `p(JsonObject)` (currently no-op) |
| `"rpc_request"` | Wine→Android | Dispatched to RPC handler |
| `"rpc_response"` | Android→Wine | Response with `id`, `success`, `result`/`error` |

**RPC methods (Wine→Android):**
- `"fetch_steam_input_vdf"` — Wine asks Android for controller VDF config for `controller_idx` N. Android calls `callback.a(controllerIdx)` and returns the VDF string. This is how GameSir controller mappings are fed to Steam.

**Outbound commands (Android→Wine broadcasts):**
- `"controller_changed"` + `controller_idx` — controller connected/disconnected
- `"controller_swapped"` + `from_index`/`to_index` — controller reordering
- `"force_stop_game"` — force-kill the active Steam game

**Protocol:** Newline-separated JSON. Buffer size 4096 bytes. Concurrent client map `ConcurrentHashMap<id, Socket>`.

---

### §274 — Wine Environment Variables

From smali `const-string` analysis of `com/winemu/core/` modules:

**Standard Wine:**
| Variable | Purpose |
|---|---|
| `WINEPREFIX` | Wine prefix path |
| `WINEPREFIX_BASE` | Base path for prefix creation |
| `WINEDEBUG` | Wine debug channel flags |
| `WINEUSERNAME` | Username inside Wine |
| `WINELOADERNOEXEC` | Prevent Wine loader from re-executing |
| `WINEESYNC` | Enable esync for faster synchronization primitives |
| `WINE_DISABLE_FULLSCREEN_HACK` | Disable fullscreen resolution switching |
| `WINE_DISABLE_HARDWARE_SCHEDULING` | Disable hardware scheduling |
| `WINE_DO_NOT_CREATE_DXGI_DEVICE_MANAGER` | Suppress DXGI device manager creation |
| `WINE_HEAP_DELAY_FREE` / `WINE_HEAP_ZERO_MEMORY` / `WINE_HEAP_TOP_DOWN` | Heap allocator tweaks |

**DXVK:**
| Variable | Purpose |
|---|---|
| `DXVK_ASYNC` | Enable async shader compilation |
| `DXVK_LOG_LEVEL` | Log verbosity (none/error/warn/info/debug) |
| `DXVK_HUD` | HUD overlay config string |
| `DXVK_CONFIG_FILE` | Path to dxvk.conf |
| `DXVK_STATE_CACHE_PATH` | Directory for pipeline state cache |

**Mesa/Gallium:**
| Variable | Purpose |
|---|---|
| `GALLIUM_DRIVER` | Override Gallium driver (e.g. `turnip`, `zink`) |
| `MESA_SHADER_CACHE_DISABLE` | Disable Mesa shader cache |
| `MESA_SHADER_CACHE_MAX_SIZE` | Cache size limit |

**WinEmu custom:**
| Variable | Purpose |
|---|---|
| `WINEMU_ROOT_FS` | Path to rootfs image |
| `WINEMU_VFS` | Virtual filesystem mount point |
| `WINEMU_CPU_AFFINITY` | CPU core affinity mask |
| `WINEMU_MEMORY_LIMIT` | Memory limit for Wine process |
| `WINEMU_REPLACED_DRIVER` | Driver override flag |
| `WINEMU_CEF_FILES` | CEF (Chromium Embedded Framework) files path |
| `WINEMU_REMOTE_FILES` | Remote file cache path |
| `PROTON_DISABLE_LSTEAMCLIENT` | Disable lsteamclient.so override |
| `LD_LIBRARY_PATH` | Library search path (prefixed with `/system/lib64:`) |
| `LD_PRELOAD` | Preloaded libraries |
| `DISPLAY` | X11 display socket |

*[Pass 27 complete — 4 new sections (271–274) added]*

---

## §300–§316: Store API Clients, Playtime, GameHubPrefs, BhStoragePath, DeviceMetrics (Pass 28)

### §275 — WinEmu Config Object (Full Field Inventory)

`com/winemu/openapi/Config.java`

**Config** is the Parcelable launch configuration object passed from the Android layer to the Wine runtime. Full field inventory from `toString()`:

| Field | Type | Description |
|---|---|---|
| `runMode` | `RunMode` | `VirtualDesktop` or `DirectLaunch` |
| `disableWM` | bool | Disable Wine window manager |
| `exePath` | String | Windows executable to launch |
| `steamAppId` | int | Steam App ID (0 if non-Steam) |
| `virtualContainer` | String | Container ID/path |
| `bootParams` | String | Extra Wine boot parameters |
| `winedebugParams` | String | `WINEDEBUG` channel string |
| `localeCode` | String | Locale code for Wine |
| `resolution` | `Resolution(width, height)` | Target render resolution |
| `box64Config` | `Box64Config` | box64 dynarec tuning |
| `fexConfig` | `FEXConfig` | FEX-Emu ARM JIT tuning |
| `gpuDriver` | `GPUDriver(isCustomDriver, customPath)` | GPU driver selection |
| `audioDriver` | `AudioDriver` | `Alsa` or `Pulse` |
| `inGameHud` | `InGameHud` | `NONE`, `FPS`, or `FULL` overlay |
| `disableReshade` | bool | Disable ReShade post-processing |
| `enableRDCDebug` | bool | Enable RenderDoc capture |
| `hostCoreLimit` | int | CPU core limit |
| `envVars` | `EnvVars` | Additional environment variables |
| `gpuConfig` | `GPUConfig` | GPU-specific config |
| `gpuMemoryLimitInMB` | uint | VRAM limit |
| `sysMemoryLimitInMB` | uint | System RAM limit |
| `steamGameInfo` | `SteamGameInfo` | Steam game metadata |
| `mitmConfig` | `MitmConfig` | MITM proxy configuration |
| `gameRootDir` | String | Root directory for game files |
| `logPath` | String | Log output path |
| `enableLogHttpServer` | bool | Enable HTTP log server |
| `enableOnScreenKeyboard` | bool | Show OSK |
| `enableWinMonitor` | bool | Enable WinMonitor debug |
| `enableESync` | bool | Enable esync |
| `debugMode` | bool | Debug mode flag |
| `enableMangoHUD` | bool | Enable MangoHUD overlay |
| `bypassAVDecode` | bool | Bypass hardware video decode |
| `surfaceFormat` | `SurfaceFormat` | `RGBA8` or `BGRA8` |
| `dllOverrides` | `Map<String, String>` | DLL override map |

**Box64Config key fields** (box64 JIT dynarec parameters):
`box64Path`, `dynarec`, `dynaCache`, `dynaCacheFolder`, `dynaCacheMin`, `box64Avx`, `bigBlock`, `callret`, `alignedAtomics`, `cpuType`, `cpuName`, `fastNan`, `fastRound`, `mmap32`, `nativeFlags`, `forward`, `df`, `dirty`, `div0`, `ignoreInt3`, `pause`, `rdtsc1Ghz`

---

### §276 — Moonlight / NVIDIA GameStream Protocol (NvHTTP)

`com/streaming/nvstream/http/NvHTTP.java`
`com/streaming/nvstream/http/PairingManager.java`
`com/streaming/nvstream/StreamConfiguration.java`

The app embeds **Moonlight** (open-source GameStream client, `com.streaming` package) for PC streaming to the host machine.

**NVIDIA GameStream HTTP endpoints (plain HTTP, port 47989 / HTTPS port 47984):**

| Endpoint | Purpose |
|---|---|
| `serverinfo` | Get host machine info (hostname, UUID, MAC, codec support, state) |
| `pair` | Initiate device pairing (`devicename=roth&updateState=1&phrase=pairchallenge`) |
| `unpair` | Remove device pairing |
| `applist` | List available applications/games on host |
| `appadd` | Add application to host |
| `appasset` | Get application asset (box art) |
| `launch` | Launch an application by `appid` |
| `resume` | Resume a previously launched session |
| `cancel` | Cancel active session |
| `filelist` | List files in `directory=` on host |

**Connection details:**
- Plain HTTP base URL: `http://<host>:47989`
- HTTPS base URL: `https://<host>:47984`
- All requests include `uniqueid` and `uuid` query params
- `state` field in `serverinfo` response: `_SERVER_BUSY` if app is running; contains `"MJOLNIR"` for NVIDIA hardware
- HDR mode supported via `hdrMode=1&clientHdrCapVersion=0&...` params on launch

**StreamConfiguration fields:**
- `app` (NvApp), resolution (width/height), frame rate, bitrate, audio config
- `AudioConfiguration` enum from `StreamingBridge` (JNI)
- Multiple codec/HDR/surround sound flags

**PairingManager** implements the full 4-step GameStream pairing ceremony:
1. Challenge phrase: `devicename=roth&updateState=1&phrase=pairchallenge`
2. Certificate exchange
3. Secret/challenge validation
4. Pairing confirmation

**`LimelightCryptoProvider`** — implements GameStream crypto (AES-GCM, RSA, SHA256) used for pairing and session encryption.

*[Pass 28 complete — 2 new sections (275–276) added]*

---

## §277 — WinUIBridge: Central Wine-Android Integration Hub

**File:** `com/winemu/openapi/WinUIBridge.java`

`WinUIBridge` is the primary facade connecting Android Activity lifecycle to the Wine runtime. It holds all major subsystem references:

| Field | Type | Purpose |
|-------|------|---------|
| `c` | `ImageFs` | Root filesystem image |
| `d` | `Container` | Wine container path |
| `e` | `Wine` | Wine runtime instance |
| `f` | `BootData` | Boot parameters |
| `g` | `SteamAgentController` | Steam IPC bridge |
| `h` | `GameScopeController` | GameScope socket control |
| `i` | `MITMController` | HTTPS MITM proxy |
| `j` | `ProgramController` | Wine process lifecycle |
| `k` | `X11Controller` | X11 display + input |
| `l` | `ContainerController` | Container process mgmt |
| `m` | `RegistryController` | Windows registry editor |
| `n` | `EnvironmentController` | Wine env vars |
| `o` | `GamepadManager` | Gamepad I/O routing |
| `F` | `LogHttpServer` | In-session HTTP log server |
| `G` | `TabTipServer` | On-screen keyboard IPC |
| `H` | `WinMonitorClient` | Wine process monitor |

**Initialization flow (`init()`):**
1. `HiddenApiBypass.a("Landroid/view")` — bypass Android hidden API for view access
2. Read Intent extra `"container_path"` and `"container_config"` (Parcelable `Config`)
3. Construct all 9 controllers in order: GameScope → MITM → Container → Registry → Environment → Program → X11 → Gamepad
4. Optionally start `WinMonitorClient` (if `config.o()` == true) — env var `WINMONITOR_PORT`
5. Optionally start `TabTipServer` (if `config.m()` == true) — env vars `TABTIP_PORT`, `TABTIP_ENABLE_OSK=1`
6. Optionally start `LogHttpServer` (if `config.k()` == true)

**Key IPC socket paths** (relative to `ImageFs.a` root):
- `etc/gamescope.control` — GameScope socket
- `.dr.sock` — Direct Rendering socket (env: `DR_SOCK_PATH`)
- `.gamepad.sock` — Gamepad server socket (env: `GAMEPAD_SOCK_PATH`)

**Event routing:**
- Touch events → `X11Controller.k(motionEvent)` (captured input mode)
- Gamepad motion/key → `GamepadManager.V/Q(event)`
- Non-gamepad key events → `XServer.INSTANCE.sendKeyEvent(0, keyCode, isDown)`
- Blocked keycodes: `{4, 3, 82, 84}` (Back, Home, Menu, Search) + volume/camera/power

**Exit sequence (`exit()`):**
- SteamAgentController.j() → ProgramController.A() → GameScope.a() → MITM.f() → WineHelper.j(kill) → X11Controller.G() → activity.finish() → IRemoteCallback.T(0) → `Process.killProcess(myPid())`

---

## §278 — Moonlight Streaming JNI Constants (StreamingBridge)

**File:** `com/streaming/nvstream/jni/StreamingBridge.java`  
**Native library:** `libstreaming-core.so`

**Video format flags:**
| Constant | Value |
|---------|-------|
| `VIDEO_FORMAT_H264` | 1 |
| `VIDEO_FORMAT_H265` | 256 |
| `VIDEO_FORMAT_H265_MAIN10` | 512 |
| `VIDEO_FORMAT_AV1_MAIN8` | 4096 |
| `VIDEO_FORMAT_AV1_MAIN10` | 8192 |

**Decoder capability flags:**
| Constant | Value |
|---------|-------|
| `CAPABILITY_DIRECT_SUBMIT` | 1 |
| `CAPABILITY_REFERENCE_FRAME_INVALIDATION_AVC` | 2 |
| `CAPABILITY_REFERENCE_FRAME_INVALIDATION_HEVC` | 4 |
| `CAPABILITY_REFERENCE_FRAME_INVALIDATION_AV1` | 64 |

**Port flags:**
| Constant | Value |
|---------|-------|
| `ML_PORT_FLAG_TCP_47984` | 1 |
| `ML_PORT_FLAG_TCP_47989` | 2 |
| `ML_PORT_FLAG_TCP_48010` | 4 |
| `ML_PORT_FLAG_UDP_47998` | 256 |
| `ML_PORT_FLAG_UDP_47999` | 512 |
| `ML_PORT_FLAG_UDP_48000` | 1024 |
| `ML_PORT_FLAG_UDP_48010` | 2048 |

**Controller capability flags (`LI_CCAP_*`):**
- `LI_CCAP_ANALOG_TRIGGERS` = 1
- `LI_CCAP_RUMBLE` = 2
- `LI_CCAP_TRIGGER_RUMBLE` = 4
- `LI_CCAP_TOUCHPAD` = 8
- `LI_CCAP_ACCEL` = 16
- `LI_CCAP_GYRO` = 32
- `LI_CCAP_BATTERY_STATE` = 64
- `LI_CCAP_RGB_LED` = 128

**Touch event types:** HOVER=0, DOWN=1, UP=2, MOVE=3, CANCEL=4, BUTTON_ONLY=5, HOVER_LEAVE=6, CANCEL_ALL=7

**Audio configurations:**
- `AUDIO_CONFIGURATION_STEREO` = 2ch, mask 3
- `AUDIO_CONFIGURATION_51_SURROUND` = 6ch, mask 63
- `AUDIO_CONFIGURATION_71_SURROUND` = 8ch, mask 1599

**Key native methods:**
- `startConnection(serverAddr, serverCert, clientCert, clientKey, width, height, fps, bitrate, packetSize, numAudioChannels, audioMask, videoFormatMask, appID, ...)` → connects to GameStream host
- `sendMultiControllerInput(controllerNumber, buttonFlags, leftTrigger, rightTrigger, leftStickX, leftStickY, rightStickX, rightStickY)`
- `sendMouseMove(dx, dy)`, `sendMousePosition(x, y, refWidth, refHeight)`
- `sendKeyboardInput(keyCode, action, modifiers, flags)`
- `sendPenEvent(...)`, `sendTouchEvent(...)` — advanced input
- `interruptConnection()`, `stopConnection()`
- `guessControllerType(vendorId, productId)` → returns `LI_CTYPE_*`

---

## §279 — MITM Proxy: Embedded Default CA Certificate + Private Key

**File:** `com/winemu/core/controller/MITMController.java`  
**Native library:** `libmitm.so` (via `MitmProxy.java`)

The Wine MITM proxy intercepts all HTTPS traffic from Wine processes. The `MITMController` class contains **hardcoded default CA certificate and private key** used when no custom cert is provided via `MitmConfig`:

**Default CA Certificate** (self-signed, CN=Local Root CA, O=Development):
- Serial: `181AACC...` 
- Valid: 2025-06-28 to 3024-10-29
- Key usage: CA + keyCertSign, cRLSign
- Subject: `CN=Local Root CA, O=Development, OU=Certificate Authority`

**Default CA Private Key:** RSA 2048-bit — full PKCS#8 PEM block is hardcoded in the binary.

> **Security note:** Because this default CA cert and its matching private key are shipped publicly in the APK, any party can use this key pair to perform MITM on Wine sessions that use the default config (i.e., intercept all HTTPS calls made by Steam, EGS, etc. running under Wine in this environment).

**MITM proxy environment variables injected into Wine:**
| Variable | Value |
|---------|-------|
| `MITM_ENABLED` | `1` |
| `MITM_TLS_PORT` | port from `MitmProxy.getPort()` |
| `MITM_DNS_PORT` | port from `MitmProxy.getDnsPort()` |
| `MITM_CA_CERT` | `<imageFs>/etc/mitm.crt` |
| `MITM_CONFIG` | `<imageFs>/etc/config.mitm.json` |

**MitmProxy JNI interface (libmitm.so):**
- `setCertificate(certPem, keyPem)` → load CA cert+key
- `setConfig(jsonString)` → set routing/filtering config
- `start(port, dnsPort)` → start proxy (defaults: both 0 = auto-assign)
- `stop()` → stop proxy
- `getPort()` / `getDnsPort()` → get actual bound ports

**Certificate bundle assembly:** MITMController reads all `.crt` files from `/etc/security/cacerts` and appends them to the MITM CA bundle, ensuring the proxy trusts all system CAs.

---

## §280 — TabTipServer: UDP On-Screen Keyboard IPC

**File:** `com/winemu/core/server/tabtip/TabTipServer.java`

UDP-based server that allows Wine's Touch Keyboard (TabTIP) service to request Android show/hide an on-screen keyboard.

**Protocol (40-byte binary packet, little-endian):**
```
Offset  Size  Field
0       4     magic = 0x54504C56 (decimal 1413566548 = "VTLP")  
4       4     action (0=HIDE, 1=SHOW)
8       8     timestamp (ms)
16      4     appId
20      4     x (keyboard x-position)
24      4     y (keyboard y-position)
28      4     width
32      4     height
36      4     checksum (XOR of all int fields)
```

**Validation:** `k.checksum == k.a()` (XOR of all int fields) AND `magic == 1413566548`

**Env vars set in Wine:** `TABTIP_PORT=<port>`, `TABTIP_ENABLE_OSK=1`

**Callback interface:** `KeyboardEventListener.a(x, y, width, height, appId)` on SHOW, `.b()` on HIDE

---

## §281 — WinMonitor: Wine Process Monitoring Protocol

**File:** `com/winemu/core/server/winmonitor/`

UDP JSON-based monitoring client for Wine processes. Allows Android side to inspect running Wine processes and thread stacks.

**CommandRequest JSON:**
```json
{"command": "<cmd>", "pid": <int|null>, "thread_id": <long|null>}
```

**Response types:**
- `ProcessListResponse` → list of `ProcessInfo`(name, pid, path)
- `ThreadListResponse` → list of `ThreadInfo`
- `ThreadDetailInfo` → `StackFrame[]`
- `ThreadStackResponse` — thread call stack
- `KillProcessResponse` — kill result

**ProcessInfo fields:** `name` (string), `pid` (int), `path` (string)

**Env var injected into Wine:** `WINMONITOR_PORT=<port>`

---

## §282 — Firebase Authentication Integration

**Files:** `com/xj/landscape/launcher/firebase/`

**Three auth providers implemented:**
1. **Google Sign-In** (`FirebaseGoogleLogin`) — uses GMS Identity API (`GetSignInIntentRequest`); reads Google client ID from `SdkConfig.Firebase`
2. **Apple Sign-In** (`FirebaseGenericIdpLogin`) — uses Firebase `OAuthProvider("apple.com")` with scopes `["email", "name"]`
3. **Generic IdP** — same OAuthProvider pattern for any provider

**Firebase Google client IDs (from `SdkConfig.Firebase`):**
- Production: `304891727788-1lqj59qoj25o37viksnkuacccc6jhgg8.apps.googleusercontent.com`  
- Beta/AppConfig: `464226359755-hd93lt0ad68vaoqj9u6hteg97r6ij8gl.apps.googleusercontent.com`

**Firebase app credentials (from `strings.xml`):**
| Key | Value |
|-----|-------|
| `google_app_id` | `1:304891727788:android:e27ed4a7a22bdbc9adb409` |
| `google_api_key` | `AIzaSyD2bJl2Lh1TLgbvZHpA7GsquBg5Eko3X7g` |
| `google_storage_bucket` | `gamesir-8c76b.firebasestorage.app` |
| `default_web_client_id` | `304891727788-1lqj59qoj25o37viksnkuacccc6jhgg8.apps.googleusercontent.com` |

**Firebase initialization:** `FirebaseApp.initializeApp(context)` if no apps registered yet; wrapped in try/catch to silently fail.

**Auth flow result:** `authResult.getUser()` is forwarded to a `Function1` callback registered on `FirebaseAuthLoginUtils`.

---

## §283 — GPUConfig and ReshadeConfig Parcelables

**GPUConfig** (`com/winemu/openapi/GPUConfig.java`):
- Fields: `vendorId` (int), `deviceId` (int) — both Parcelable
- `toString()`: `"GPUConfig(vendorId=X, deviceId=Y)"`
- Used by `Config.gpuConfig` field to identify target GPU

**ReshadeConfig** (`com/winemu/openapi/ReshadeConfig.java`):
- `enabled` (bool, default `true`)
- `effects` (List\<Effect\>)
- `a()` → serializes to ReShade INI format: `enable = <bool>\neffects = name1:name2\nEffect.param = value\n...`
- `d(File)` → writes to `<imageFs>/etc/reshade.ini`
- Effect types: `CASEffect`, `CRTEffect`, `HDREffect` (in `com.winemu.openapi`)

---

## §284 — GamepadManager: Wine Gamepad Socket Server

**File:** `com/winemu/core/gamepad/GamepadManager.java`

Manages all gamepad input for Wine sessions. Implements `Closeable`, `GamepadEventListener`, `SteamInputVdfProvider`.

**Key components:**
- `GamepadServerManager c` — Unix socket server at `.gamepad.sock`
- `GamepadDeviceManager d` — physical device detection/enumeration
- `GamepadSlotManager e` — maps devices to Wine gamepad slots (0–3)
- `GamepadInputRouter f` — routes input events to Wine
- `VirtualGamepadController h` — on-screen virtual gamepad
- `GamepadSlotChangeListener l` — notifies UI of slot changes

**Lifecycle:**
- `Companion.a(context, socketPath)` → factory that throws if `q0()` init fails
- `close()` — shuts down server + all slots
- `i(GamepadEventListener)` — register connection/disconnection listener
- `h1(SteamAgentController)` — bind Steam agent for VDF queries
- `r1()` — start gamepad server

**SteamInputVdfProvider:** The `GamepadManager` itself implements `SteamInputVdfProvider`, providing VDF strings per controller index back to `SteamAgentController`.

**Wine socket path:** env var `GAMEPAD_SOCK_PATH=<imageFs>/.gamepad.sock`

*[Pass 29 complete — 8 new sections (277–284) added]*

---

## §285 — New API Routes Found in Pass 30 Smali Sweep

**Routes discovered via exhaustive smali `const-string` analysis not covered in prior passes:**

### QR Code / Mobile Login Routes (PCStream)
| Route | Method | Params | Description |
|-------|--------|--------|-------------|
| `POST /user/mobileScanCode` | POST | `(see context)` | Report mobile QR scan code |
| `POST /user/mobileConfirmCode` | POST | `(see context)` | Confirm mobile login via QR |
| `POST /user/mobileCancelCode` | POST | `(see context)` | Cancel mobile QR login |

These are the three phases of the QR login flow for PC Stream: scan → confirm → cancel.

### Game Session Heartbeat Routes
**Used by `WineGameUsageTracker`** to track active play sessions:
| Route | Params | Description |
|-------|--------|-------------|
| `POST heartbeat/game/start` | `steam_appid`, `steam_user_id`, `token`, `game_id` | Start play session |
| `POST heartbeat/game/update` | `steam_appid`, `steam_user_id`, `token`, `game_id` | Heartbeat tick |
| `POST heartbeat/game/end` | `steam_appid`, `steam_user_id`, `token`, `game_id` | End play session |

### Compatibility Reporting
| Route | Params | Description |
|-------|--------|-------------|
| `POST game/cts/report` | `token`, `game_id`, `cts_level`, `comment`, `cts_info`, `general_info` | Report game compatibility rating |

Used by `CompatibleDialog.report()` — allows users to submit game compatibility test results.

### Discovery / Content Routes
| Route | Description |
|-------|-------------|
| `GET base/getBaseInfo` | Base launcher configuration info (`LauncherUtils.getBaseLauncherInfo`) |
| `GET card/getNewDetail` | News article detail |
| `GET card/getGameDetail` | Game detail card |
| `GET game/getGameCircleList` | Game community/circle list |
| `GET game/getClassify` | Game classification/category list |
| `GET game/getSteamHost` | Steam host proxy config (`snProxyConfig`) |
| `GET search/getGameList` | Game search (params: `keywords`, `classify_group_id`, `page`, `page_size`) |
| `GET search/getHotTrending` | Hot/trending search keywords |
| `GET devices/getUnknownDevices` | Unknown/unregistered device list |

### Download / Order Routes
| Route | Params | Description |
|-------|--------|-------------|
| `POST order/get_down_info` | `token`, `game_id` | Get download URL/info for purchased game (`WinEmuDownloadManager.refreshDownloadUrl`) |

### WinEmu Script Execution Route
| Route | Params | Description |
|-------|--------|-------------|
| `POST simulator/executeScript` | `game_id`, `steam_appid`, `gpu_vendor`, `gpu_version`, `gpu_device_name`, `gpu_system_driver_version` | Get game-specific launch script from server (`EnvLayerRepository.getGameConfigByScript`) |

### MovingCloud (MoveCloud) RTC Metrics
| Route | Description |
|-------|-------------|
| `POST metrics/rtc` | RTC session metrics upload (`RtcDataStorageData`, posted to `mServerAddress + "metrics/rtc"`) |

---

## §286 — GameScopeController: mmap Control File Protocol

**File:** `com/winemu/core/controller/GameScopeController.java`

Uses a **4-byte memory-mapped file** at `<imageFs>/etc/gamescope.control` to communicate rendering mode to Wine side without IPC overhead.

**Layout (4 bytes total):**
```
Byte 0-1: FPS limit (little-endian 16-bit)
Byte 2:   Focus flag (0 = background, 1 = focused)
Byte 3:   DirectRenderingMode (enum ordinal)
```

**DirectRenderingMode enum values:**
- `Auto` (default on boot)
- Other modes from `com.winemu.openapi.DirectRenderingMode`

**API:**
- `d(int fps)` — set FPS limit
- `c(bool focused)` — set focus state
- `b(DirectRenderingMode mode)` — set rendering mode
- `a()` — close/flush (called on exit)

**Wine env var:** Path set indirectly as the control socket for GameScope process.

---

## §287 — SteamAgentController: Status Events and App Launch Detection

**File:** `com/winemu/core/controller/SteamAgentController.java`

Bridges `SteamAgentServer` (TCP JSON) to `GamepadManager` + UI callbacks.

**Key behavior on `app_launch` status event:** When Wine reports an `app_launch` event AND `SteamGameInfo` is set, creates a `.script_installed` sentinel file at `<containerPath>/.script_installed`. This marks that the game launch scripts have been applied.

**Environment variable injected into Wine:** `STEAMAGENT_PORT=<port>` — Wine agent connects back to this TCP port.

**Gamepad slot change callbacks:**
- `c(slot, deviceType)` → `SteamAgentServer.i(slot, deviceType)` — broadcasts `controller_changed`
- `d(slotCount)` → `SteamAgentServer.h(slotCount)` — broadcasts `controller_swapped`

**Lifecycle:**
- `i(containerPath, steamGameInfo)` → creates and starts `SteamAgentServer`
- `j()` → stops server, nulls reference

*[Pass 30 complete — 3 new sections (285–287) added]*

---

## §288 — Additional API Routes Found in Pass 31 Smali Sweep

**Previously undocumented routes with full parameter lists:**

### Card/Content Routes
| Route | Params | Description |
|-------|--------|-------------|
| `POST card/getIndexList` | `token`, `topic_type`, `classify_group_id` | Home index card list |
| `POST card/getNewsList` | `token`, `location`, `game_id`, `pkg_name`, `game_name`, `page`, `page_size` | Paginated news list |
| `POST card/getNewsGuideDetail` | `token`, `id`, `source` | News guide detail article |
| `GET card/getTopPlatform` | (none seen) | Top platform list |

### Game Info / State Routes
| Route | Params | Description |
|-------|--------|-------------|
| `POST game/checkIsCloudGame` | `token`, `app_ids` | Batch check which app IDs have cloud gaming support |
| `POST game/checkLocalHandTourGame` | `token`, `pkg_name`, `game_name` | Check if local mobile game has cloud/streaming version |
| `POST game/userPlayedGame` | `token`, `game_id` | Record user play event for a game |
| `GET game/getIndexList` | — | Game index/home list |

### Cloud Order/Time Routes
| Route | Params | Description |
|-------|--------|-------------|
| `POST cloud/order_list` | `token`, `page`, `page_size`, `order_by` | User cloud gaming order history |
| `POST cloud/use_time_log` | `token`, `month` | Cloud gaming time usage log by month |

### Notification Settings Routes
| Route | Params | Description |
|-------|--------|-------------|
| `GET settings/getNotifySwitch` | (token) | Get user notification preferences |
| `POST settings/updateNotifySwitch` | `token`, `game_recs`, `act_notify`, `news_pushes` | Update notification switches |

---

## §289 — Remaining API Route Master Reference

Based on all passes, the complete deduplicated API route inventory is:

**Authentication:**
- `POST jwt/refresh/token` — JWT refresh
- `GET user/getMobileCode` — SMS verification code
- `POST user/mobileScanCode` — QR scan code report
- `POST user/mobileConfirmCode` — QR login confirm
- `POST user/mobileCancelCode` — QR login cancel

**User:**
- `GET user/info` — current user profile

**Card / Content:**
- `GET base/getBaseInfo` — launcher base config
- `GET card/getIndexList` — home index card list
- `GET card/getNewsList` — paginated news
- `GET card/getNewsGuideDetail` — news guide article
- `GET card/getNewDetail` — news article detail
- `GET card/getAlbumDetail` — album/gallery detail
- `GET card/getGameIcon` — game icon
- `GET card/more` — load more cards
- `GET card/getSearchHot` — hot search terms
- `GET card/getCtsList` — CTS list (batch by steam_appids or game_ids)
- `GET card/getTopPlatform` — top platform list

**Games:**
- `GET game/getIndexList` — game home index
- `GET game/getGameTopCategoryIdList` — top category IDs
- `GET game/getClassify` — game classification list
- `GET game/getGameCircleList` — game community circles
- `GET game/checkIsCloudGame` — batch cloud-game availability check
- `GET game/checkLocalHandTourGame` — check mobile game cloud support
- `POST game/userPlayedGame` — record play event
- `GET game/getSteamHost` — Steam host proxy config
- `GET game/cts/report` — submit compatibility rating

**Search:**
- `GET search/getGameList` — game search (keywords, classify_group_id, page, page_size)
- `GET search/getHotTrending` — trending keywords

**Heartbeat / Session Tracking:**
- `POST heartbeat/game/start` — start play session
- `POST heartbeat/game/update` — heartbeat tick
- `POST heartbeat/game/end` — end play session
- `GET heartbeat/game/getUserPlayTimeList` — user play time history

**Simulator / Game Config:**
- `GET simulator/getTabList` — tab list
- `GET simulator/getLocalGameDetail` — local game detail
- `GET simulator/getLocalMultiGameDetail` — batch local game details
- `POST simulator/executeScript` — get game launch script (GPU params required)
- `GET simulator/v2/getComponentList` — Wine components list
- `GET simulator/v2/getAllComponentList` — all components
- `GET simulator/v2/getComponentDetail` — component detail
- `GET simulator/v2/getContainerList` — container list
- `GET simulator/v2/getContainerDetail` — container detail
- `GET simulator/v2/getDefaultComponent` — default component
- `GET simulator/v2/getImagefsDetail` — imagefs detail

**Cloud Gaming:**
- `POST cloud/game/auth_token` — cloud game auth
- `POST cloud/game/start_token` — start cloud game session
- `POST cloud/game/check_user_timer` — check user play time remaining
- `POST cloud/game/startQueue` — join queue
- `POST cloud/game/confirmPlay` — confirm play from queue
- `POST cloud/game/renew_token` — renew session
- `POST cloud/game/exit` — exit cloud game
- `GET cloud/game/getQueueInfo` — queue status
- `GET cloud/game/getQueueCalendar` — queue calendar
- `GET cloud/game/getNewsList` — cloud game news
- `GET cloud/game/getNewsDetail` — cloud game news detail
- `GET cloud/game/get_goods_list` — cloud game purchase list
- `POST cloud/h5/exchange_code` — redeem exchange code
- `GET cloud/order/info` — order info
- `GET cloud/order_list` — user order history
- `POST cloud/use_time_log` — cloud time usage log
- `POST cloud/payment` — cloud game payment

**Devices / ADB:**
- `GET devices/getMapping` — device ADB mapping
- `GET devices/getUnknownDevices` — unknown devices list

**VTouch (Button Mapping):**
- `GET /vtouch/vtouchGetConfig` — get VTouch config
- `POST /vtouch/vtouchUploadConfig` — upload config
- `POST /vtouch/vtouchDelConfig` — delete config
- `GET /vtouch/vtouchDetail` — config detail
- `POST /vtouch/vtouchRevoke` — revoke config
- `POST /vtouch/vtouchShare` — share config
- `GET /vtouch/vtouchShareSearch` — search shared configs
- `GET /vtouch/getOfficial` — official configs
- `GET /doc/docVtouchList` — documentation list

**PS5 (PlayStation):**
- `POST /ps5/get_ps5_user` — get PS user by online_id
- `POST /ps5/get_ps5_user_by_code` — get PS user by OAuth code
- `POST /ps5/get_ps5_connection_type` — get PS5 connection type

**Social:**
- `GET social/getUserInfo` — user social info
- `GET social/deleteFriend` — remove friend
- `GET social/userNoticeList` — user notices
- `POST social/userUpdateNotice` — mark notice as read

**Settings:**
- `GET settings/getNotifySwitch` — notification preferences
- `POST settings/updateNotifySwitch` — update notification settings (game_recs, act_notify, news_pushes)

**Statistics:**
- `POST statistics/activeUsersStatistics` — active user event
- `POST statistics/openTypeStatistics` — open type event
- `POST statistics/streamUsageStatistics` — streaming usage event

**WinEmu Download:**
- `POST order/get_down_info` — download URL info by game_id

**Share:**
- `GET baseLink/getBaseLink` — get PC stream base link (token required)

*[Pass 31 complete — 2 new sections (288–289) added; full route index compiled]*

---

## §290 — TokenProvider: EmuReady Token Service

**File:** `app/revanced/extension/gamehub/token/TokenProvider.java`

The central auth token resolver for the BannerHub/EmuReady integration.

**Token Service:**
- URL: `https://gamehub-lite-token-refresher.emuready.workers.dev/token`
- Auth header: `X-Worker-Auth: gamehub-internal-token-fetch-2025`
- Method: `GET`
- Timeout: 10s connect + 10s read
- Expected response: JSON body containing token

**Three-level cache (L1→L2→L3):**
- L1: In-memory `AtomicReference<CachedToken>` (lost on process restart)
- L2: `SharedPreferences("token_provider_pref")` keys: `cached_token`, `cached_token_expiry`
- L3: HTTP call to token service
- Cache TTL: 4 hours (14,400,000 ms)
- Stale fallback: returns stale L1/L2 value if L3 fails; last resort: `"fake-token"`

**Resolution logic (`resolveToken(originalToken)`):**
1. If `apiSwitchPatched == true` AND `use_external_api == true` (SharedPrefs `steam_storage_pref`) → return `"fake-token"` immediately
2. If `loginBypassed == true` → fetch from service (L1→L2→L3)
3. Otherwise → pass-through original token

**`refreshTokenForOfficialApi()`** (called by `TokenRefreshInterceptor` before official JWT refresh):
1. Only runs if `loginBypassed == true`
2. Clears cache, fetches fresh token from service
3. If returned token equals current app token → force-refresh (calls `forceRefreshFromService()`)
4. Returns new token on success, `null` to fall back to official JWT refresh

**Default flags (hardcoded in class):**
- `apiSwitchPatched = true`
- `loginBypassed = true`

---

## §291 — SteamCdnHelper: Game Header Art Resolution

**File:** `app/revanced/extension/gamehub/network/SteamCdnHelper.java`

Fetches Steam app header images using a batched CDN strategy.

**URLs:**
| Purpose | URL |
|---------|-----|
| Steam Store API | `https://api.steampowered.com/IStoreBrowseService/GetItems/v1/` |
| Custom CDN | `https://cdn-library-logo-global.bigeyes.com/` |
| Steam CDN fallback | `https://shared.steamstatic.com/store_item_assets/steam/apps/{id}/header.jpg` |
| Default (0/invalid) | `https://shared.steamstatic.com/store_item_assets/steam/apps/0/header.jpg` |

**Steam API call format:**
```
GET https://api.steampowered.com/IStoreBrowseService/GetItems/v1/
    ?input_json={"ids":[{"appid":X},...],"context":{"language":"english","country_code":"US"},"data_request":{"include_assets":true}}
```

**Batching:** Up to 50 IDs per request, 150ms delay to coalesce requests from `fetchQueue`.

**Cache:**
- L1: `ConcurrentHashMap<Integer, String>` (in-memory)
- L2: `SharedPreferences("steam_cdn_cache")` — keys `url_<appid>`, `exp_<appid>` (expiry timestamp)
- Cache TTL: 7 days (604,800,000 ms)

---

## §292 — Amazon Games OAuth Client

**File:** `app/revanced/extension/gamehub/AmazonAuthClient.java`

Handles Amazon Games Store device registration and token refresh.

**API endpoints:**
| Endpoint | URL |
|---------|-----|
| Register | `https://api.amazon.com/auth/register` |
| Refresh | `https://api.amazon.com/auth/token` |
| Deregister | `https://api.amazon.com/auth/deregister` |

**Device registration params:**
```json
{
  "auth_data": {
    "authorization_code": "<code>",
    "client_domain": "DeviceLegacy",
    "client_id": "<client_id>",
    "code_algorithm": "SHA-256",
    "code_verifier": "<verifier>",
    "use_global_authentication": false
  },
  "registration_data": {
    "app_name": "AGSLauncher for Windows",
    "app_version": "1.0.0",
    "device_model": "Windows",
    "device_name": null,
    "device_serial": "<serial>",
    "device_type": "A2UMVHOX7UP4V7",
    "domain": "Device",
    "os_version": "10.0.19044.0"
  },
  "requested_extensions": ["customer_info", "device_info"],
  "requested_token_type": ["bearer", "mac_dms"],
  "user_context_map": {}
}
```

**User-Agent:** `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0`

Response: `response.success.tokens.bearer.{access_token, refresh_token, expires_in}`

---

## §293 — Epic Games OAuth Client

**File:** `app/revanced/extension/gamehub/EpicAuthClient.java`

**Credentials (embedded):**
- Client ID: `34a02cf8f4414e29b15921876da36f9a`
- Client secret: `daafbccc737745039dffe53d94fc76cf`

**Endpoints:**
- Exchange URL: `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange`
- Token URL: `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token`

**User-Agent spoofed as EGS launcher:**
`UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit`

---

## §294 — GOG Galaxy OAuth Client

**File:** `app/revanced/extension/gamehub/GogTokenRefresh.java`

**Credentials (embedded):**
- Client ID: `46899977096215655`
- Client secret: `9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9`

**Token refresh URL:**
```
GET https://auth.gog.com/token?client_id=46899977096215655&client_secret=<secret>&grant_type=refresh_token&refresh_token=<token>
```

**SharedPreferences storage:** `"bh_gog_prefs"` — keys: `refresh_token`, `access_token`, `bh_gog_login_time`

---

## §295 — BhWineLaunchHelper: Wine Process Discovery

**File:** `app/revanced/extension/gamehub/BhWineLaunchHelper.java`

Discovers the running Wine installation by scanning `/proc/` filesystem — no hard-coded paths needed.

**Wine binary discovery logic:**
1. Check `WINELOADER` env var first
2. Scan `/proc/*/comm` for processes named `wineserver`, `wine64-preload*`, or `wineloader`
3. Resolve `/proc/<pid>/exe` → canonical path → parent directory
4. Look for: `wine64`, `wine`, `wineloader`, `wine64-preloader` in that directory

**Wine environment reading:**
- Finds first `/proc/<pid>/comm` ending in `.exe` (the game process)
- Reads `/proc/<pid>/environ` (up to 65536 bytes)
- Splits on `\0` (null byte) to get `KEY=VALUE` pairs

**`getWinePrefix()`:** reads `WINEPREFIX` from the discovered Wine environment.

*[Pass 32 complete — 6 new sections (290–295) added]*

---

## §296 — Amazon Credential Store (`AmazonCredentialStore.java`)

Storage: File at `{context.filesDir}/amazon/credentials.json`. JSON schema:
```json
{"access_token":"...","refresh_token":"...","device_serial":"...","client_id":"...","expires_at":<ms>}
```

Auto-refresh: `getValidAccessToken()` → if `expiresAt - now < 300000` (5 min) and refreshToken present → calls `AmazonAuthClient.refreshAccessToken(refreshToken)`.

---

## §297 — Amazon Game Data Model (`AmazonGame.java`)

Fields: `productId`, `entitlementId`, `title`, `artUrl`, `heroUrl`, `developer`, `publisher`, `productSku`, `isInstalled`, `installPath`, `versionId`, `downloadSize`, `installSize`, `isDLC`, `parentProductId`. `shortId()` = substring after final `.` in productId.

---

## §298 — Amazon PKCE Generator (`AmazonPKCEGenerator.java`)

- `generateDeviceSerial()` → random UUID, hyphens removed, uppercase
- `generateClientId(deviceSerial)` → hex-encode bytes of `(deviceSerial + "#A2UMVHOX7UP4V7")`
- `generateCodeVerifier()` → 32 random bytes → Base64 URL-safe no-padding
- `generateCodeChallenge(verifier)` → SHA-256 → Base64 URL-safe no-padding
- `sha256Upper(str)` → SHA-256 hex uppercase (used for hardware hash in entitlements requests)

---

## §299 — Amazon Manifest Binary Format (`AmazonManifest.java`)

Custom binary format for Amazon game install manifests:

**Header (4 bytes, big-endian int):** Size of proto header that follows.
**Header proto:** Field 1.2 → nested proto; field 1 = compression algorithm int (1=XZ, 0=LZMA).
**Body:** XZ or LZMA compressed proto payload, decompressed to 64KB chunks.

**Manifest proto:**
- Field 1 (length-delimited) = `ManifestPackage`
  - Field 1 (string) = package name
  - Field 2 (length-delimited) = `ManifestFile`
    - Field 1 (string) = file path (backslash-separated)
    - Field 3 (varint) = file size
    - Field 5 (length-delimited) = hash proto
      - Field 1 (varint) = hash algorithm int
      - Field 2 (bytes) = hash bytes

`ParsedManifest.totalInstallSize` = sum of all file sizes. `ManifestFile.unixPath()` = path with `\` → `/`.

XZ/LZMA decompression: reflectively creates `org.tukaani.xz.XZInputStream` or `LZMAInputStream`.

---

## §300 — Amazon API Client (`AmazonApiClient.java`)

**Endpoints:**
- `ENTITLEMENTS_URL = "https://gaming.amazon.com/api/distribution/entitlements"`
- `DISTRIBUTION_URL = "https://gaming.amazon.com/api/distribution/v2/public"`
- `SDK_CHANNEL_URL = "https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346"`
- `KEY_ID = "d5dc8b8b-86c8-4fc4-ae93-18c0def5314d"` (used in entitlements requests)

**User-Agents:**
- Gaming API: `com.amazon.agslauncher.win/3.0.9202.1`
- Download: `nile/0.1 Amazon`

**Request protocol (postGaming):**
- Header: `X-Amz-Target: {operationName}`, `x-amzn-token: {token}`, `Content-Encoding: amz-1.0`, `Content-Type: application/json`
- Timeout: 30s connect + read

**Operations:**
| X-Amz-Target | Body | Notes |
|---|---|---|
| `AnimusEntitlementsService.GetEntitlements` | `{Operation,clientId:"Sonic",syncPoint,nextToken,maxResults:50,productIdFilter,keyId,hardwareHash}` | Paginated via `nextToken` |
| `AnimusDistributionService.GetGameDownload` | `{entitlementId,Operation}` | Returns `{downloadUrl,versionId}` |
| `AnimusDistributionService.GetLiveVersionIds` | `{adgProductIds:[...],Operation}` | Returns `{versionIds:{productId:versionId}}` |

SDK channel manifest: `GET {downloadUrl}/manifest.proto` with `x-amzn-token`; files at `{downloadUrl}/files/{hashHex}`.

---

## §301 — Epic Credential Store (`EpicCredentialStore.java`)

SharedPrefs name: `bh_epic_prefs`. Keys: `access_token`, `refresh_token`, `account_id`, `display_name`, `expires_at` (long ms).

Auto-refresh: `getValidAccessToken()` → if `expiresAt - now < 300000` → calls `EpicAuthClient.refreshToken(refreshToken)`.

---

## §302 — Epic Game Data Model (`EpicGame.java`)

Fields: `appName`, `namespace`, `catalogItemId`, `title`, `developer`, `description`, `artCover`, `artSquare`, `version`, `isInstalled`, `installPath`, `installSize`, `canRunOffline` (default true), `isDLC`, `baseGameCatalogItemId`, `releaseDate`.

---

## §303 — GOG Game Data Model (`GogGame.java`)

Constructor: `GogGame(gameId, title, imageUrl, description, developer, category, generation)`. `generation` int = GOG Galaxy version (1 = legacy, 2 = Galaxy 2.0).

---

## §304 — GOG Install Path & Launch Helper (`GogInstallPath.java`, `GogLaunchHelper.java`)

`GogInstallPath.getInstallDir(ctx, gameName)` → `BhStoragePath.getInstallDir(ctx, "gog_games", gameName)`.

`GogLaunchHelper`: SharedPrefs `bh_gog_prefs`, key `pending_gog_exe`.
- `triggerLaunch(activity, exePath)` → stores exe path → `activity.finish()`
- `checkPendingLaunch(activity)` → reads pending exe → calls `activity.B3(exePath)` via reflection on the host Activity

---

## §305 — Playtime Helper (`PlaytimeHelper.java`)

Reads from two SQLite databases in app data:

**Step 1 — Get current user:**
```sql
SELECT id FROM steam_account WHERE is_current_user = 1 LIMIT 1
-- Database: xj_steam_db
```

**Step 2 — Get playtimes:**
```sql
SELECT app_id, playtime_forever, playtime2weeks
FROM t_steam_user_pics_app_last_played_times
WHERE user_id = ? AND playtime_forever > 0
ORDER BY playtime2weeks DESC, playtime_forever DESC
-- Database: xj_steam_pics_v5
```

Converts to `com.xj.game.entity.RecentGameEntity` objects via reflection:
- Field `a` (String) = steamAppId
- Field `d` (long) = totalSeconds (= playtime_forever × 60)
- Field `e` (long) = last14Days (= playtime2weeks × 60)

---

## §306 — GameHub Preferences (`GameHubPrefs.java`)

**Master settings class for the ReVanced extension layer.**

SharedPrefs name: `steam_storage_pref`

**API Source keys:**
- `api_source` (int): 0=Official, 1=EmuReady, 2=BannerHub
- `last_api_source` (int): previous value for change detection

**URL mapping:**
```
0 → original official URL (passed in)
1 → "https://gamehub-lite-api.emuready.workers.dev/"
2 → "https://bannerhub-api.the412banner.workers.dev/"
```

**Other keys:** `cpu_usage_display` (bool, default true), `perf_metrics_display` (bool, default true), `log_all_requests` (bool, default false), `use_custom_storage` (bool), `steam_storage_path` (string)

**Settings content type IDs:**
| ID | Setting |
|---|---|
| 24 | SD card storage (`use_custom_storage`) |
| 26 | API source selection |
| 27 | Log all requests |
| 28 | CPU usage display |
| 29 | Performance metrics display |

**Cache clearing** (on API source change): SharedPrefs cleared = `sp_winemu_all_components12`, `sp_winemu_all_containers`, `sp_winemu_all_imageFs`, `pc_g_setting`, `net_cookies`; also clears TokenProvider cache, CompatibilityCache, and app cache dir.

**SD card detection:** `autoDetectSDCardStorage()` → scans `getExternalFilesDirs(null)`, removes `/Android/data` suffix, checks for `GHL/` directory as sentinel.

**Storage path rewrite:** `getEffectiveStoragePath(originalPath)` → replaces `/files/Steam` segment with custom storage path.

**Request logging:** `logApiRequest()` dumps full headers + body (up to 1MB) when `log_all_requests=true`; `logFailedApiRequest()` logs 4xx only otherwise.

**Compatibility headers** (added to requests via reflection): `User-Agent: Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36`, `Accept: application/json, text/plain, */*`, `Accept-Language: en-US,en;q=0.9`, `Connection: keep-alive`

---

## §307 — BannerHub Storage Path (`BhStoragePath.java`)

`getStoreBase(ctx, storeName)`:
- If `steam_storage_pref#use_custom_storage=true` and path set → `{customPath}/bannerhub/{storeName}`
- Otherwise → `{context.filesDir}/{storeName}`

`getInstallDir(ctx, storeName, gameName)` → `getStoreBase(ctx, storeName)/{gameName}`

Used by: GOG (`gog_games/`), Amazon (via `AmazonDownloadManager`), Epic (`epic_games/`)

---

## §308 — BannerHub Settings Exporter (`BhSettingsExporter.java`)

**Version:** `BH_VERSION = "3.5.0"`
**Export dir:** `{externalStorage}/BannerHub/configs/`
**Worker base:** `https://bannerhub-configs-worker.the412banner.workers.dev`

**Worker endpoints:**
| Method | Path | Description |
|---|---|---|
| POST | `/upload` | Upload config JSON (base64 encoded) |
| GET | `/list?game={name}` | List community configs for a game |
| GET | `/download?game={game}&file={filename}` | Download specific config |

**Export JSON schema:**
```json
{
  "meta": {
    "app_source": "bannerhub",
    "device": "Manufacturer Model",
    "soc": "GPU renderer string",
    "bh_version": "3.5.0",
    "upload_token": "<random hex>",
    "settings_count": <n>,
    "components_count": <n>
  },
  "settings": { /* all pc_g_setting{containerId} entries */ },
  "components": [
    {"name": "...", "url": "...", "type": "GPU|VKD3D|DXVK|Box64|FEXCore"}
  ]
}
```

**Tracked component SP keys** (from `pc_g_setting{id}`):
`pc_ls_DXVK`, `pc_ls_VK3k`, `pc_set_constant_94`, `pc_set_constant_95`, `pc_ls_GPU_DRIVER_`, `pc_ls_CONTAINER_LIST`, `pc_ls_steam_client`

**Component type name → int mapping:**
| Name | Int | Component |
|---|---|---|
| GPU | 10 | GPU driver |
| VKD3D | 13 | VKD3D-Proton |
| default | 12 | DXVK |
| Box64 | 94 | Box64 translator |
| FEXCore | 95 | FEX ARM translator |

**Sources SharedPrefs:** `banners_sources` — keys: `{name}` → `"BannerHub"`, `url_for:{name}` → download URL, `{name}:type` → type string, `dl:{url}` → `"1"` (already downloaded)

**Upload SharedPrefs:** `bh_config_uploads` — key = SHA from worker response, value = `{sha,game,filename,date,token}` JSON

**SOC detection order:**
1. `device_info` SP → `gpu_renderer`
2. `/sys/class/kgsl/kgsl-3d0/gpu_model`
3. `Build.SOC_MODEL` (API 31+) or `Build.HARDWARE`

**Frontend exports:**
- Beacon → `Downloads/bannerhub/frontend/Beacon/{gameName}.iso`
- ES-DE → `Downloads/bannerhub/frontend/ES-DE/{gameName}.steam`

**Component injection:** Calls `com.xj.landscape.launcher.ui.menu.ComponentInjectorHelper.injectComponent(Context, Uri, int)` via reflection.

**GPU driver name fix:** After GPU injection, patches `pc_ls_GPU_DRIVER_` JSON `name`+`displayName` fields in `pc_g_setting` SharedPrefs.

---

## §309 — Storage Broadcast Receiver (`StorageBroadcastReceiver.java`)

Listens for broadcast intents with package-prefixed actions:

| Action | Effect |
|---|---|
| `{packageName}.SET_STEAM_STORAGE` | Sets custom storage path (extra: `path`); enables custom storage if not already enabled |
| `{packageName}.USE_INTERNAL_STORAGE` | Resets to internal storage |

---

## §310 — Device Metrics (`DeviceMetrics.java`)

**CPU usage:** `Process.getElapsedCpuTime()` delta / wall time delta × num_processors; cached 500ms.

**GPU usage** (sysfs paths probed in order):
1. `/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage` — Qualcomm, percent value
2. `/sys/class/kgsl/kgsl-3d0/gpubusy` — Qualcomm, `{busy} {total}` format → busy/total×100
3. `/sys/kernel/gpu/gpu_load` — Samsung, percent value
4. `/sys/devices/platform/*/gpu/utilisation` or `utilization` — Mali, percent value
5. `/sys/class/mpgpu/utilization` — Amlogic, percent value

**RAM usage:** `ActivityManager.MemoryInfo` → used = total - available, formatted as `"RAM: X.X / Y.Y GB (Z%)"`.

---

## §311 — GHLog Enum (`GHLog.java`)

Android `Log.*` wrapper enum. Android log tags (all prefixed `GHL/`):

| Enum | Tag |
|---|---|
| TOKEN | `GHL/Token` |
| PREFS | `GHL/Prefs` |
| BATTERY | `GHL/Battery` |
| GAME_ID | `GHL/GameId` |
| CURRENCY | `GHL/Currency` |
| COMPAT | `GHL/Compat` |
| FILE_MGR | `GHL/FileMgr` |
| STORAGE | `GHL/Storage` |
| NET | `GHL/Net` |
| CDN | `GHL/CDN` |
| CPU | `GHL/CPU` |
| PERF | `GHL/Perf` |
| PLAYTIME | `GHL/Playtime` |

---

## §312 — Compatibility Cache (`CompatibilityCache.java`)

In-memory `ConcurrentHashMap<String, Object>` keyed by steamAppId string.

`getOrBuildCompat(gameEntity)`: 
1. Calls `gameEntity.getCst_data()` via reflection; if non-null returns it.
2. Calls `gameEntity.getSteamAppId()` → looks up cache.
3. If found: reads `getTitle()`, `getIcon()`, `getDesc()`, `getLevel()` from cached object.
4. Constructs `com.xj.common.service.bean.GameCompatibilityParams(title, icon, desc, level, ArrayList())` via reflection.

---

## §313 — Game ID Helper (`GameIdHelper.java`)

Reads Intent extras `steamAppId` and `localGameId` from Activity. Finds container `ll_game_id_container` (by resource name), makes it visible. Sets up clickable TextViews `tv_steam_app_id` and `tv_local_game_id` that copy to clipboard on tap.

---

## §314 — Performance Metrics Helper (`PerformanceMetricsHelper.java`)

Appends CPU/GPU/RAM TextViews to a ViewGroup. Refresh interval: 1000ms via main-thread Handler. Uses `DeviceMetrics` for readings. WeakReferences prevent leaks when view is removed.

---

## §315 — MT Data Files Provider (`MTDataFilesProvider.java`)

DocumentsProvider exposing app internal storage to file managers (MT Manager, etc.).

**Root document dirs:**
| Dir name | Actual path |
|---|---|
| `data` | `context.filesDir.parent` |
| `android_data` | External files dir parent (`Android/data/`) |
| `android_obb` | `context.obbDir` |
| `user_de_data` | `/data/user_de/0/{package}/` equivalent |

**Security bypass:** Reflectively clears `mReadPermission` and `mWritePermission` fields on ContentProvider, removing `MANAGE_DOCUMENTS` enforcement.

**SAF extras columns:** `mt_extras` (custom metadata), `mt_path` (native path).

**Custom call methods:** `mt:createSymlink`, `mt:setLastModified`, `mt:setPermissions` (handled via `call()` dispatch).

**Symlink detection:** `Os.lstat(path).st_mode & 0xF000 == 0xA000` (S_IFLNK = 40960).

---

## §316 — Amazon Launch Helper (`AmazonLaunchHelper.java`)

**fuel.json parsing:** Reads `{installDir}/fuel.json` → `Main.Command`, `Main.WorkingSubdirOverride`, `Main.Args[]`.

**Wine launch command:** `winhandler.exe "A:\{exe_path}" [args...]`

**Env vars injected for Amazon games:**
```
FUEL_DIR=C:\ProgramData\Amazon Games Services\Legacy
AMAZON_GAMES_SDK_PATH=C:\ProgramData\Amazon Games Services\AmazonGamesSDK
AMAZON_GAMES_FUEL_ENTITLEMENT_ID={entitlementId}
AMAZON_GAMES_FUEL_PRODUCT_SKU={productSku}
AMAZON_GAMES_FUEL_DISPLAY_NAME=Player
```

**Exe scoring heuristics** (for auto-detecting primary executable):
- UE Shipping pattern (`-win32/-win64(-shipping).exe`) = +350
- UE Binaries path = +250
- Root-level exe = +200
- Name matches title = +100
- Negative keyword = -150
- Generic name pattern (`^[a-z]\d{1-3}.exe$`) = -200 or exclude

**Negative keywords:** `crash`, `handler`, `viewer`, `compiler`, `tool`, `setup`, `unins`, `eac`, `launcher`, `steam`

---

## §317 — Epic API Client (`EpicApiClient.java`)

**Endpoints:**
- `LIBRARY_URL = "https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true"` (paginated via `cursor`)
- `CATALOG_BASE = "https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace"`
- `MANIFEST_BASE = "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace"`
- Manifest URL: `{MANIFEST_BASE}/{namespace}/catalogItem/{catalogItemId}/app/{appName}/label/Live`

**User-Agent:** `Legendary/0.1.0 (GameNative)` (impersonates Legendary open-source Epic launcher)

**Auth:** `Authorization: Bearer {accessToken}`

**Library filtering** (skipped): namespace `ue` (Unreal Engine), namespace `89efe5924d3d467c839449ab6ab52e7f`, sandboxType `PRIVATE`.
Only Windows platform items included.

**Manifest response:** `elements[0].manifests[]` + `buildVersion`/`versionId`

---

## §318 — Amazon SDK Manager (`AmazonSdkManager.java`)

Downloads Amazon Games SDK DLLs required by Amazon Windows games.

**Cache dir:** `{filesDir}/amazon_sdk/`  
**Version sentinel:** `{cacheDir}/.sdk_version`

**Cached files structure:**
```
amazon_sdk/
├── .sdk_version          ← versionId string from channel spec
└── Amazon Games Services/
    ├── Legacy/
    │   └── FuelSDK_x64.dll
    └── AmazonGamesSDK/
        └── AmazonGamesSDK*.dll files
```

**Deploy to Wine prefix:** Copies to `{winePrefix}/ProgramData/Amazon Games Services/`.

**Download flow:**
1. `getSdkChannelSpec(token)` → GET `SDK_CHANNEL_URL` with `x-amzn-token`
2. Parse `downloadUrl` and `versionId` from response
3. Download `{downloadUrl}/manifest.proto` (protobuf manifest)
4. Parse with `AmazonManifest.parse()`
5. For each file matching `Amazon Games Services/`: download `{downloadUrl}/files/{hashHex}`
6. Write `.sdk_version` on success

---

## §319 — BannerHub Download Service (`BhDownloadService.java`)

**Foreground service** for downloading games from 3 stores (AMAZON, EPIC, GOG).

**Intent actions:** `bh.download.START`, `bh.download.CANCEL`

**Intent extras for START:**

| Extra | Key | Store |
|---|---|---|
| `store` | AMAZON/EPIC/GOG | all |
| `game_id` | unique key | all |
| `game_name` | display name | all |
| `amz_pid` | productId | AMAZON |
| `amz_eid` | entitlementId | AMAZON |
| `amz_sku` | productSku | AMAZON |
| `amz_title` | title | AMAZON |
| `epic_app` | appName | EPIC |
| `epic_ns` | namespace | EPIC |
| `epic_cat` | catalogItemId | EPIC |
| `gog_gid` | gameId | GOG |
| `gog_title` | title | GOG |
| `gog_img` | imageUrl | GOG |
| `gog_dev` | developer | GOG |
| `gog_cat` | category | GOG |
| `gog_gen` | generation (int) | GOG |

**Notification channel:** `bh_downloads` (name: "BannerHub Downloads", importance: IMPORTANCE_LOW=2), notification ID: 8800.

**Install paths:**
- Amazon: `{filesDir}/Amazon/{sanitizedTitle}/`
- Epic: `{filesDir}/epic_games/{sanitizedTitle}/`
- GOG: `BhStoragePath.getInstallDir(ctx, "gog_games", sanitizedTitle)`

**Per-store SharedPrefs:**
- Amazon: `bh_amazon_prefs` — `amazon_dir_{productId}`, `amazon_exe_{productId}`
- Epic: `bh_epic_prefs` — `epic_dir_{appName}`, `epic_manifest_version_{appName}`, `epic_exe_{appName}`
- GOG: `bh_gog_prefs` — `gog_dir_{gameId}`, `gog_exe_{gameId}`

**Library SharedPrefs:** `bh_library` — `{gameId}` → `"{name}\n{store}\n{installPath}"`

*[Pass 33 complete — 24 new sections (296–319) added]*

---

## §320 — GOG Download Manager — API Endpoints (`GogDownloadManager.java`)

**GOG Content System API:**
```
GET https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=2
GET https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=1
GET https://api.gog.com/products/{gameId}?expand=downloads
```

**Authentication:**
- Token read from `bh_gog_prefs#access_token`
- Expiry: `bh_gog_prefs#bh_gog_login_time` + `bh_gog_expires_in` seconds
- Auto-refresh via `GogTokenRefresh.refresh(context)` when expired

**Download strategy (waterfall):**
1. Try Galaxy Gen 2 CDN builds (`generation=2`)
2. Fall back to Gen 1 builds (`generation=1`)
3. Last resort: installer download (`runInstaller`)

**Debug log:** Written to `{externalFilesDir}/bh_gog_debug.txt`

---

## §321 — GOG User/Auth API Endpoints (`GogLoginActivity.java` smali scan)

**OAuth login flow:**
```
GET https://auth.gog.com/auth?client_id=46899977096215655
  &redirect_uri=https%3A%2F%2Fembed.gog.com%2Fon_login_success%3Forigin%3Dclient
  &response_type=token
  &layout=client2
GET https://embed.gog.com/on_login_success   ← redirect handler
GET https://embed.gog.com/userData.json       ← user info (id, username)
GET https://embed.gog.com/user/data/games     ← owned game IDs
```

**Token refresh:**
```
GET https://auth.gog.com/token?client_id=46899977096215655
  &client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9
  &grant_type=refresh_token
  &refresh_token={token}
```
Response stored to `bh_gog_prefs`: `access_token`, `refresh_token`, `bh_gog_login_time`, `bh_gog_expires_in`, `user_id`.

---

## §322 — GOG Cloud Save Manager (`GogCloudSaveManager.java`)

**Base URL:** `https://cloudstorage.gog.com/v1/`

**List files:** `GET {BASE}{userId}/{clientId}/` with Bearer token
**Upload:** `PUT {BASE}{userId}/{clientId}/{filename}` 
**Download:** `GET {BASE}{userId}/{clientId}/{filename}`

**Game-scoped token:** `getGameScopedToken(ctx, gameId, clientId, prefs)` fetches a scoped auth token for the specific game's client ID.

**Client ID:** `GogDownloadManager.getOrFetchClientId(ctx, gameId, token)` → retrieves from `https://api.gog.com/products/{gameId}?expand=downloads` → `downloads.installers[0].game_id` field.

**SharedPrefs:** `bh_gog_prefs` — reads `access_token`, `user_id`.

---

## §323 — Epic Cloud Save Manager (`EpicCloudSaveManager.java`)

**Base URL:** `https://datastorage-public-service-liveegs.live.use1a.on.epicgames.com/api/v1/access/egstore/savesync/`

**List files:** `GET {BASE}{accountId}/{appName}/` with Bearer token → JSON array with file metadata (name, lastModifiedMs, readLink)

**Upload flow:**
1. `requestWriteLinks(accountId, appName, token, filenames)` → `POST {BASE}{accountId}/{appName}/` with `{"filenames":["..."]}` → returns `{links:[{name, writeLink}]}`
2. `putToPresignedUrl(writeLink, bytes)` → `PUT` to pre-signed S3 URL

**Download flow:**
1. `listCloudFiles()` → each CloudFile has `readLink` (pre-signed S3 URL)
2. `getFromPresignedUrl(readLink)` → `GET` from S3 URL

---

## §324 — Package Variant Detection (`Constants.java`)

`Constants.a()` returns a platform identifier string based on the installed package name:
| Package | Identifier |
|---|---|
| `com.xiaoji.egggame.redmagic` | `"gamehub_redmagic"` |
| `com.xiaoji.egggame.logitech` | `"gamehub_logitech"` |
| any other (default) | `"gamehub_android"` |

`Constants.c()` → returns `true` if running as `gamehub_redmagic`. Used in `TokenRefreshInterceptor.intercept()` to **bypass token refresh entirely** for RedMagic variant (line: `if (Constants.a.c()) return chain.proceed(request)`).

---

*[Pass 34 complete — 5 new sections (320–324) added]*

---

## §325 — API Request Signing (`SignUtils.java`)

**Location:** `com/xj/common/http/SignUtils.java`

**Algorithm (`SignUtils.a.b(HashMap map)`):**
1. Copy all entries from `map` into a `TreeMap` (alphabetical key sort)
2. Iterate TreeMap → build string: `"key1=value1&key2=value2&..."`
3. Append the static salt: `"&all-egg-shell-y7ZatUDk"`
4. Compute MD5 of the resulting string → convert to lowercase hex
5. Return the 32-char lowercase hex digest

**Security note:** Both the pre-hash string AND the final MD5 result are logged to logcat with tag `"SignUtils"` — trivially extractable via `adb logcat -s SignUtils` during a live session.

**Used in:**
- `TokenRefreshInterceptor.j()` → token refresh request body
- `TokenRefreshInterceptor.h()` → rebuilt request body after token swap (re-signs with new token)
- Every outbound API request via `EggGameTokenInterceptor`

---

## §326 — HTTP Client Configuration (`EggGameHttpConfig.java`)

**Location:** `com/xj/common/http/EggGameHttpConfig.java`

**Base URL resolution (4 server environments):**
| Build variant | Base URL |
|---|---|
| `com.xiaoji.egggame.redmagic` | `https://test-landscape-api.vgabc.com/` |
| PRODUCT | `https://landscape-api.vgabc.com/` |
| BETA | `https://landscape-api-beta.vgabc.com/` |
| DEV | `https://dev-gamehub-api.vgabc.com/` |

All base URLs then pass through `GameHubPrefs.getEffectiveApiUrl()`, which may replace the host with EmuReady (`gamehub-lite-api.emuready.workers.dev`) or BannerHub (`bannerhub-api.the412banner.workers.dev`) depending on user setting.

**OkHttp interceptor chain (in order):**
1. `RemoveExtraSlashInterceptor` — strips double-slashes from paths
2. `LogRecordInterceptor` — request/response logging
3. `PersistentCookieJar` (SharedPrefs key: `net_cookies`)
4. `EggGameTokenInterceptor` — adds token + clientparams + signature to every request
5. `TokenRefreshInterceptor` — detects 401/`code:401`, refreshes token, retries
6. `OfflineCacheInterceptor` — serves from 128 MB disk cache when offline
7. `ChuckerInterceptor` — in-app HTTP inspector (debug builds)

**Cache:** 128 MB in `{cacheDir}/responses/`

**Timeouts:** 30s connect / 30s read / 30s write

**Tencent-era test endpoints** (no longer actively called but present in `b()` method):
- `https://test.nj.qq.com`
- `https://release.nj.qq.com`
- `https://trace.inlong.qq.com`

---

## §327 — Client Parameters Format (`ClientParams.java`)

**Location:** `com/xj/common/http/ClientParams.java`

**`ClientParams.a.b()`** returns a pipe-delimited (`|`) 20-field string sent as `clientparams` in every request body.

| Field # | Content | Notes |
|---|---|---|
| 1 | `"5.3.5"` | Hardcoded client version |
| 2 | Android OS version string | `SystemUtil.e()` |
| 3 | UI locale | `GHLocaleManager` current locale |
| 4 | Device model | `Build.MODEL` |
| 5 | Screen resolution | `"{width} * {height}"` |
| 6 | Platform ID | `Constants.a.a()` (gamehub_android/redmagic/logitech) |
| 7 | Distribution channel | `"{platformId}_{AppConfig.a.k()}"` (e.g., `gamehub_android_Official`) |
| 8 | Brand | `Build.BRAND` |
| 9 | Manufacturer | `""` (always empty) |
| 10 | MAC address | `""` (always empty) |
| 11 | Device ID / IMEI | `LocalDeviceId.a.l()` |
| 12 | Location | `""` (always empty) |
| 13 | Gamepad name | `""` (always empty) |
| 14 | Keyboard name | `""` (always empty) |
| 15 | Mouse name | `""` (always empty) |
| 16 | Firmware version | `""` (always empty) |
| 17 | Package name | `AppUtils.b()` (declaring package, i.e., `com.tencent.ig`) |
| 18 | GPU renderer | `SPUtils.g("device_info").j("gpu_renderer")` — from SharedPrefs populated at first boot |
| 19 | CPU model | `SystemUtil.a().a` |
| 20 | RAM | `"{totalGiB}G"` (e.g., `"12G"`) |

---

## §328 — User Session Storage (`UserManager.java`)

**Location:** `com/xj/common/user/UserManager.java`

**Singleton:** `UserManager.INSTANCE`  
**Storage backend:** `SPUtils.f()` (default SharedPreferences file)

**Authentication keys:**
| Key | Type | Description |
|---|---|---|
| `token` | String | Active JWT access token |
| `refresh_token` | String | Token used to get a new access token |
| `uid` | int | User ID (numeric) |
| `session` | String | Session identifier |
| `uuid` | String | Device-bound UUID |

**Profile keys:**
| Key | Type | Description |
|---|---|---|
| `mobile` | String | Phone number |
| `nickname` | String | Display name |
| `username` | String | Login username |
| `avatar` | String | Avatar URL |
| `bio` | String | Bio/description |
| `email` | String | Email address |
| `third_platform` | String | Linked OAuth platform (e.g., Google) |

**Notification preference keys (int, default 2):**
- `allow_sms_notice`, `allow_other_notice`, `allow_friend_notice`, `allow_video_notice`

**UI guide flags (bool):**
- `closeGuideAll`, `closeGuideFindContact`, `closeGuideHighlight`

**Platform-specific tokens:**
- `KEY_IM_TOKEN` (`im_token`) — IM/chat service token
- `KEY_SW_TOKEN` (`sw_token`) — unknown secondary service token

**Misc:**
- `user_cloud_game_timer` — cloud gaming session timer

**`signOut()` clears:** uid, mobile, nickname, username, token, avatar, bio, email, third_platform

---

## §329 — Distribution Channel Detection (`AppConfig.java`)

**Location:** `com/xj/common/config/AppConfig.java`

**Singleton:** `AppConfig.Companion.b`

**Channel detection:** Uses Vasdolly SDK (`ChannelReaderUtil.b(Utils.a())`) to read the distribution channel embedded in the APK signing block at build time.

**`AppConfig.a.j()` — raw channel string:** The Vasdolly channel value embedded in the APK (e.g., `"google"`, `"realme"`, `"Official"`)

**`AppConfig.a.k()` — normalized channel string:**
| Raw channel value | Returns |
|---|---|
| starts with `"google"` | `"google"` |
| starts with `"realme"` | `"realme"` |
| anything else / null | `"Official"` |

**Impact:** Field 7 of `clientparams` (§327) is `"{platformId}_{channel}"` — so a Google Play install reports `"gamehub_android_google"` and a sideload reports `"gamehub_android_Official"`.

---

*[Pass 35 complete — 5 new sections (325–329) added]*

---

## §330 — ADB WiFi Inject Module — Overview & Cloud Config API (`AdbActivationActivity.java`, `XjaInjectControlKt.java`, `HttpConfig.java`)

**Location:** `com/xj/adb/wifiui/`

This module implements the WiFi ADB-based "inject activation" flow that grants the app `SYSTEM_ALERT_WINDOW` and deep-system overlay permissions.

**Cloud config API (`AdbActivationActivity.fetchCloudCfgData`):**
- URL: `https://clientgsw.vgabc.com/clientapi/`
- Method: POST
- Body params: `model=vtouch`, `action=cloud_vtouch_active_config`, `channel=gamehub_zh`, `clientparams={ClientParams.b()}`
- Response: Parsed into `InjectCloudCfgInfo` (see below)
- Same endpoint also called by `XjaInjectControlKt.injectXjaCheckInjectNeedUpdate`

**`InjectCloudCfgInfo` response schema:**
| Field | Type | Description |
|---|---|---|
| `status` | int | Response status code |
| `msg` | String | Error/status message |
| `title` | String | Title shown in UI |
| `channel` | String | Distribution channel |
| `app_ver` | String | Expected app version |
| `ser_ver` | String | Service version |
| `is_cloud` | bool | Whether cloud delivery |
| `files` | List | File download entries |

**Mapping download URL:** `EggGameHttpConfig.a.a() + "devices/getMapping"` (static, built at class init in `XjaInjectControlKt.a`)

**HTTP client for this module (`HttpConfig.b()`):**
- Base URL: `GameHubPrefs.getEffectiveApiUrl("https://landscape-api.vgabc.com/")` — respects user's API override
- Interceptors: LogRecord → PersistentCookieJar → TokenInterceptor
- Cache: 128 MB in `{cacheDir}`
- Timeouts: 30s

**Activation flow:**
1. Check if already activated via `InjectActivationUtils`
2. If not, POST to `clientgsw.vgabc.com` to get `InjectCloudCfgInfo`
3. Download inject files from URLs in `files` list via `downloadFile()` (GET with progress listener)
4. Apply inject files → call `InjectActivationUtils.u()` to complete activation
5. On success: show toast, collapse status bar, start `AdbActivationSuccessActivity`

**ADB pairing flow:**
- Notification channel: `adb_pairing`
- Collects 6-digit pairing code via custom numpad UI
- Submits via `AdbPairingService` foreground service
- Download failure retry limit: 1 retry (tracked in SharedPrefs key `download_failure_count`)

---

## §331 — Cloud Gaming Module (`CloudGameInfoRepository.java`, `CloudGameApi.java`, `LauncherCloudGameViewModel.java`)

**Location:** `com/xj/cloud/`

**WebSocket connection (MovingCloudGame SDK):**
| Build variant | WebSocket URL |
|---|---|
| PRODUCT or BETA | `wss://sessions-saas.movingcloudgame.cn/` |
| DEV (default) | `wss://cloud.dev.movingcloudgame.com/` |

**Cloud game API endpoints** (all POST to `{baseUrl}`, body param `token=UserManager.getToken()`):
| Path | Method | Parameters | Returns |
|---|---|---|---|
| `cloud/game/startQueue` | POST | token | `StartQueueEntity` — queue position info |
| `cloud/game/start_token` | POST | cloud_game_id, token, session | `StartTokenEntity` — session start credentials |
| `cloud/game/auth_token` | POST | token, session, user(uid), app_id | `AuthTokenEntity` — auth token for MovingRTC connection |
| `cloud/game/renew_token` | POST | lastDeadline, queue_id, token, session | `ReNewTokenEntity` — extended session token |
| `cloud/game/check_user_timer` | POST | token | `UserTimeEntity` — remaining play time |
| `cloud/game/exit` | POST | token, session | void — exits queue/session |
| `cloud/game/confirmPlay` | POST | token | `code:200` = won lottery |
| `cloud/game/getQueueInfo` | POST | token | `StartQueueEntity` — current queue state |
| `cloud/game/getNewsList` | POST | token | News list |
| `cloud/game/getNewsDetail` | POST | — | News detail |
| `cloud/game/getQueueCalendar` | POST | — | Queue calendar |

**Session lifecycle:**
1. `startQueue()` → join queue (parallel with `check_user_timer`)
2. When queue resolves: `getStartToken(session, gameId)` → get start credentials
3. `getAutoToken(session, cloud_game_id)` → get MovingRTC auth token
4. Connect WebSocket to `sessions-saas.movingcloudgame.cn` with auth token
5. In-session: `getReNewToken(lastDeadline, session, queueId)` to extend every 60s
6. `exitGame(session)` on close

**Timeout config:**
- Change-channel dialog runnable: fires every `q` ms (initial `q=120000`, i.e., 2 minutes)
- Queue poll interval: 60 seconds

**SharedPrefs keys used:**
- `cloud_g_setting` — cloud game settings
- `cloud_ls_*` — per-setting flags: bit_buffer, device_activate, fps_limit, game_pad_show, idle, jitter, use_xbox_mouse, video_codec

---

## §332 — Steam Standalone Module — Architecture & APIs (`SteamAPI.java`, `SteamConfig.java`, `SteamApiUrls.java`)

**Location:** `com/xj/standalone/steam/`

**Steam CM server resolution:**
1. On startup: load cached CM list from `{filesDir}/server_list.bin` (protobuf `BasicServerList`)
2. If empty: query Steam WebAPI `ISteamDirectory` with cell ID via `SteamDirectory.load()`
3. CM connections use custom `SteamIPs` DNS interceptor that pre-resolves hostnames

**Steam Web API endpoints (via `SteamApiUrls`):**
| URL | Purpose |
|---|---|
| `https://store.steampowered.com/api/appdetails/?appids={id}` | App details/ratings |
| `https://store.steampowered.com/events/ajaxgetadjacentpartnerevents/?appid={id}&count_before=0&count_after={n}` | App news/events |
| `https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1?appid={id}` | Current player count |
| `https://store.steamchina.com/api/appdetails?appids={id}&filters=ratings` | (Chinese locale fallback) |

**CDN/Asset URLs:**
- App cover: `https://shared.cloudflare.steamstatic.com/store_item_assets/steam/apps/{appid}/`
- Avatar: `https://avatars.cloudflare.steamstatic.com/{hash}_full.jpg` or `https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/{prefix}/{hash}_full.jpg`

**SteamConfig constants:**
- Default max threads: CPU count (capped at 8 if detection fails)
- Default `b` = 88 (max concurrent connections)
- `k` = 24, `l` = 20 (likely chunk download limits)
- `m` = 60 (timeout in seconds)
- Server list file: `{filesDir}/server_list.bin`

**JavaSteam library:** Uses `in.dragonbra.javasteam` — open-source Steam protocol implementation (like SteamKit2 for JVM). Handles CM connection, authentication, license ownership, and content downloading.

**Steam DB schema** (from `SteamDB_Impl.java`):
- Table `steam_account`: id, steam_id, account_name, refresh_token, access_token, new_guard_data, personal_name, avatar_url, is_current_user, is_remember, modify_time, extra_maps
- Table `t_steam_user_games`: id, user_id, appid, name, last_update_time, extra_maps
- Table `steam_download_entity`: id, uid, steam_account, steam_appid, name, icon_hash, status, size, download_size, progress_size, installed_size, path, last_modify_time, extend
- DB version: 3

---

*[Pass 36 complete — 3 new sections (330–332) added]*

---

## §333 — Complete API Endpoint Catalog (Official GameHub Backend)

**All endpoints POST/GET to `{GameHubPrefs.getEffectiveApiUrl()}` (default: `https://landscape-api.vgabc.com/`)**

### Authentication & User
| Endpoint | Method | Key Parameters |
|---|---|---|
| `/jwt/third/login` | POST | platform, openid, openkey, unionid, extinfo |
| `/jwt/email/login` | POST | email, password |
| `/jwt/mobile/login` | POST | mobile, code |
| `/jwt/oneMobile/login` | POST | one-click mobile auth |
| `/jwt/logout` | POST | token |
| `/jwt/refresh/token` | POST | token (refresh_token), clientparams, time, sign |
| `user/info` | GET | token |
| `/user/updateUserNotice` | POST | — |
| `/user/buildPcPin` | POST | — |
| `/user/mobileScanCode` | POST | — |
| `/user/mobileConfirmCode` | POST | — |
| `/user/mobileCancelCode` | POST | — |
| `/profile` | GET/POST | — |
| `/profile/avatar` | POST | — |
| `/profile/mobile` | POST | — |
| `/profile/username` | POST | — |
| `/bind/email` | POST | — |
| `/bind/mobile` | POST | — |
| `/sms/send` | POST | mobile |
| `/ems/send` | POST | email |

### Game Library & Content
| Endpoint | Method | Description |
|---|---|---|
| `game/getIndexList` | GET | Main game list/index |
| `game/getClassify` | GET | Game categories |
| `game/getGameCircleList` | GET | Game circle community content |
| `game/getGameTopCategoryIdList` | GET | Top category IDs |
| `game/checkIsCloudGame` | POST | Check if game has cloud version |
| `game/checkLocalHandTourGame` | POST | Check if game is mobile port |
| `game/userPlayedGame` | POST | Record game played event |
| `game/getSteamHost` | GET | Steam CDN host config |
| `game/videoGameList` | GET | Video-associated games |
| `/game/searchGameList` | POST | Game search |
| `/game/searchCategoryList` | POST | Category search |
| `/game/searchClassifyList` | POST | Classify search |
| `/game/searchTopCategoryList` | POST | Top category search |
| `/game/getDnsPool` | GET | DNS IP pool |
| `/game/getDnsIpPool` | GET | DNS IP pool (v2) |
| `/game/getTopPlatform` | GET | Top platform list |
| `game/cts/report` | POST | CTS compliance report |

### Video/Media
| Endpoint | Method | Description |
|---|---|---|
| `/game/userVideoList` | GET | User's uploaded videos |
| `/game/userVideoNum` | GET | User video count |
| `/game/userVideoReading` | POST | Video view count update |
| `/game/likeVideo` | POST | Like video |
| `/game/cancelLikeVideo` | POST | Unlike video |
| `/game/userUploadsVideo` | POST | Upload video |
| `/game/userDeleteVideo` | POST | Delete video |
| `/uploads/uploadsImages` | POST | Upload images |
| `/uploads/uploadsVideo` | POST | Upload video (alt endpoint) |

### Cards / News
| Endpoint | Method | Description |
|---|---|---|
| `card/getIndexList` | GET | Card index list |
| `card/getCtsList` | GET | CTS card list |
| `card/getGameDetail` | GET | Game detail card |
| `card/getNewDetail` | GET | News detail |
| `card/getNewsGuideDetail` | GET | News guide detail |
| `card/getNewsList` | GET | News list |
| `card/getTopPlatform` | GET | Top platform cards |
| `card/more` | GET | More cards |

### Simulator / WinEmu Components
| Endpoint | Method | Description |
|---|---|---|
| `simulator/getTabList` | GET | Simulator tab configuration |
| `simulator/getLocalGameDetail` | POST | Local game detail |
| `simulator/getLocalMultiGameDetail` | POST | Multiple local game details |
| `simulator/v2/getAllComponentList` | GET | All components (token, page, page_size) |
| `simulator/v2/getComponentDetail` | GET | Single component detail |
| `simulator/v2/getComponentList` | GET | Component list |
| `simulator/v2/getContainerDetail` | GET | Container detail |
| `simulator/v2/getContainerList` | GET | Container list |
| `simulator/v2/getDefaultComponent` | GET | Default component config |
| `simulator/v2/getImagefsDetail` | GET | ImageFS layer detail |
| `base/getBaseInfo` | GET | Base app info |
| `baseLink/getBaseLink` | POST | PC streaming base link |

### Social
| Endpoint | Method | Description |
|---|---|---|
| `/social/getRecommendation` | GET | Friend recommendations |
| `/social/userDeviceConnect` | POST | Device association |
| `social/getUserInfo` | GET | Social user profile |
| `social/userNoticeList` | GET | User notification list |
| `social/userUpdateNotice` | POST | Update notification |
| `social/deleteFriend` | POST | Remove friend |

### Devices & Settings
| Endpoint | Method | Description |
|---|---|---|
| `/devices/getDevices` | GET | Device list |
| `/devices/getDevicesList` | GET | Extended device list |
| `devices/getUnknownDevices` | GET | Unknown device reporting |
| `settings/getNotifySwitch` | GET | Notification switches |
| `settings/updateNotifySwitch` | POST | Update notification switch |
| `doc/docList` | GET | Document list |
| `/vtouch/startType` | POST | Launch type detection |
| `search/getHotTrending` | GET | Trending searches |

### Heartbeat & Analytics
| Endpoint | Method | Description |
|---|---|---|
| `heartbeat/game/start` | POST | Game session start |
| `heartbeat/game/update` | POST | Game session heartbeat |
| `heartbeat/game/end` | POST | Game session end |
| `heartbeat/game/getUserPlayTimeList` | GET | User playtime history |
| `statistics/activeUsersStatistics` | POST | Active user stats |
| `statistics/openTypeStatistics` | POST | Launch type stats |
| `statistics/streamUsageStatistics` | POST | Stream usage stats |

### PS5/PSPlay
| Endpoint | Method | Description |
|---|---|---|
| `/ps5/get_ps5_user` | POST | Get PS5 user by online_id |
| `/ps5/get_ps5_user_by_code` | POST | Get PS5 user by OAuth code |
| `/ps5/get_ps5_connection_type` | POST | Get PS5 connection type |
| `/ps5/get_ps5_open_doc` | GET | PS5 setup documentation |

### Cloud Gaming (Cloud Sessions)
| Endpoint | Method | Description |
|---|---|---|
| `cloud/game/startQueue` | POST | Join cloud game queue |
| `cloud/game/start_token` | POST | Get session start token |
| `cloud/game/auth_token` | POST | Get MovingRTC auth token |
| `cloud/game/renew_token` | POST | Renew session token |
| `cloud/game/check_user_timer` | POST | Check remaining play time |
| `cloud/game/exit` | POST | Exit queue/session |
| `cloud/game/confirmPlay` | POST | Confirm lottery win |
| `cloud/game/getQueueInfo` | POST | Query queue status |
| `cloud/game/getNewsList` | GET | Cloud game news |
| `cloud/game/getNewsDetail` | GET | Cloud game news detail |
| `cloud/game/getQueueCalendar` | GET | Queue schedule |
| `cloud/game/get_goods_list` | GET | Cloud time packages for purchase |
| `cloud/order_list` | GET | Cloud gaming order history |
| `cloud/use_time_log` | GET | Play time log |
| `cloud/order/info` | GET | Cloud order info |
| `cloud/payment` | POST | Purchase cloud gaming time |
| `order/get_down_info` | GET | Order download info |

### Upgrade
| Endpoint | Method | Description |
|---|---|---|
| `/upgrade/getAppUpgradeApk` | GET | App update check |
| `/feedback/submitFeedback` | POST | Submit bug report |
| `/feedback/submitFeedbackReply` | POST | Reply to feedback |

### Separate API Servers
| URL | Purpose |
|---|---|
| `https://clientgsw.vgabc.com/clientapi/` | ADB/inject activation config (model=vtouch, action=cloud_vtouch_active_config) |
| `https://clientegg.vgabc.com/uxapi/` | UX events API |
| `https://statistic-gamehub-api.vgabc.com/events` | Event telemetry (EventTracker: event_type, user_id, data) |

---

## §334 — WinEmu Component & Container System (`EmuComponents.java`, `EnvLayerEntity.java`)

**Location:** `com/xj/winemu/`

**`EnvLayerEntity` fields** (represents a downloadable component/container/imageFS layer):
| Field | Serialized Name | Type | Description |
|---|---|---|---|
| id | id | int | Unique entity ID |
| name | name | String | Display name |
| displayName | display_name | String | Localized name |
| version | version | String | Version string |
| versionCode | version_code | int | Numeric version |
| downloadUrl | download_url | String | Direct download URL |
| fileMd5 | file_md5 | String | MD5 hash for verification |
| fileName | file_name | String | Target filename |
| fileSize | file_size | long | File size in bytes |
| fileType | fileType | int | File type (type=4 for components) |
| type | type | int | Component type (GPU=10, VKD3D=13, DXVK=12, Box64=94, FEXCore=95) |
| logo | logo | String | Logo image URL |
| isSteam | is_steam | int | Steam-related flag |
| framework | framework | String | Framework identifier |
| frameworkType | framework_type | String | Framework type |
| blurb | blurb | String | Short description |
| base | base | EnvLayerEntity | Base layer this extends |
| subData | sub_data | SubData | Sub-download data |
| status | status | int | Current installation status |
| upgradeMsg | upgrade_msg | String | Upgrade change notes |
| ITEM_REMOVE_PC_DATA_ID = -100 | — | const | Magic ID to trigger PC data removal |

**SharedPrefs cache keys:**
- `sp_winemu_all_components12` — cached component list JSON (v12)
- `sp_winemu_all_containers` — cached container list JSON
- `sp_winemu_all_imageFs` — cached imageFS list JSON

---

*[Pass 37 complete — 2 new sections (333–334) added]*

---

## §335 — Launch Strategy Architecture (Pass 38)

### Strategy Pattern Overview

All game launch paths implement `LaunchStrategy` (interface) with a single `a(LauncherConfig): LaunchResult` method. A strategy always returns `LaunchResult.Failure` for async launches (the actual result is delivered via callback, not return value).

**Strategy implementations:**

| Class | Trigger | Key behavior |
|-------|---------|--------------|
| `GHPcEmuLaunchStrategy` | PC emulator (local) | Checks `LauncherGameInfo.isLocalGame()` OR `IGameModuleService.a(localId)` OR `GHDemoGameStateMgr`; async via `GHPcEmuLaunchStrategy$launch$1` |
| `SteamGameByPcEmuLaunchStrategy` | Steam game on PC emu | Gets `steamId` from `LauncherGameInfo`; uses `ISteamGameService` via TheRouter; flow: `fetchStartTypeInfoAndSwitchMode` → `toggleDownload` → `checkCanStartSteamGame` |
| `MobilePlayLaunchStrategy` | Mobile play (XJA device) | Requires `DeviceManager.s().c()` non-empty + `DeviceWhiteListManager.b()` authorized device ID; calls `AppLauncher.c()` for package install check; star game API call |
| `MovingCloudGameLaunchStrategy` | Cloud gaming (MovingCloud) | Guards: `AppConfig.a.b()` disables cloud; navigates to `LauncherCloudGameActivity` via TheRouter with URL params: `cloud_game_id`, `game_id`, `cover_image`, `game_name` |
| `PcLinkLaunchStrategy` | PC link streaming | Async via `PcLinkLaunchStrategy$launch$1` |
| `PsLinkLaunchStrategy` | PS4/PS5 link | Async via `PsLinkLaunchStrategy$launch$1` |
| `PsAppLaunchStrategy` | PS companion app | Standalone implementation |
| `PsRemotePlayLaunchStrategy` | PS Remote Play | Standalone implementation |
| `XboxLaunchStrategy` | Xbox cloud | Fires `SendStartGameEvent(gameName, "xbox")`; opens `XboxWebActivity` with `url_extra_key` from `config.k()`; uses `AppLauncher.t()` to reset launcher state |
| `GoogleStoreLaunchStrategy` | Google Play install | Delegates to `LauncherHelper.a.p(config, packageName, true)` |
| `HidLaunchStrategy` | HID mapping mode | Related to mapping mode popup UI |
| `OtherAppLaunchStrategy` | Other Android app | Generic package launch |
| `UrlLaunchStrategy` | URL open | Calls `LauncherHelper.l(start_ext.getStart_res())` to open URL |
| `SteamGameDetailLaunchStrategy` | Steam game detail view | Navigate to steam game info screen |

### MovingCloudGame Navigation URL

`LauncherCloudGameActivity` is navigated to via TheRouter route:
```
com.xj.cloud.ui.LauncherCloudGameActivity
  ?cloud_game_id={URLEncoded start_res}
  &game_id={game_id}
  &cover_image={URI-encoded cover_image}
  &game_name={URLEncoded game_name}
```

### SteamGameByPcEmuLaunchStrategy — Steam Launch States

`UserSteamGameState` enum values affect which flow is chosen:
- `ImportedByTool` (1) — show install Steam toast if Steam not installed
- `ImportedByUser` (2) — user-imported game
- `Downloaded` (3) — already downloaded via BannerHub downloader
- `InDownloadQueue` (4) — currently downloading

`SteamGameByPcEmuLaunchStrategy` lazy-initializes a `GHPcEmuLaunchStrategy` companion for local game launch. It uses `GameLibraryRepository` for game state lookups.

### MobilePlayLaunchStrategy — Game Start Params

Body params for mobile play star game request:
- `game_id` — from `BhDownloadService.EXTRA_GAME_ID`  
- `devices_id` — device ID string
- `nm` — game name from `config.g()`
- `pkn` — package name from `config.j()`
- `token` — user token

Returns `StartTypeEntity`.

### LauncherHelper — fetchStartTypeInfoAndSwitchMode

This two-POST helper determines how to start a game:

**POST 1** — lookup device name (returns `UnknownDevicesTipInfo`)
- Path: resolved from `devices_name` body param
- Body: `{devices_name: str}`

**POST 2** — get start type info (returns `StartTypeEntity`)  
- Body: `{game_id, devices_id, nm (game_name), pkn (pkg_name), token}`

---

## §336 — Heartbeat API (WineGameUsageTracker) (Pass 38)

**Class:** `com.xj.winemu.utils.WineGameUsageTracker`  
**Instantiation:** `WineActivity.x` — created at Wine process start, stopped at exit.  
**Storage:** MMKV (default). Key = `MD5(game_id + steam_appid)`.

### Heartbeat Lifecycle

1. `o()` — startTracking. Cancels any existing job, calls `q()` (starts heartbeat), starts coroutine loop.
2. `q()` — launches `startHeartbeatTime` POST → `heartbeat/game/start`
3. Tracking loop fires `updateHeartbeatTime` POST → `heartbeat/game/update` at regular intervals
4. `p()` — stopTracking. Cancels job, calls `h()` (endHeartbeatTime), saves elapsed time to MMKV.

### Heartbeat Endpoints

All three endpoints POST to main API (`landscape-api.vgabc.com` or override). Same body params:

| Endpoint | Path |
|----------|------|
| Start | `heartbeat/game/start` |
| Update | `heartbeat/game/update` |
| End | `heartbeat/game/end` |

**Body params** (all three endpoints):
- `steam_appid` — from `WineActivityData.j()` (Steam app ID)
- `steam_user_id` — from `ISteamService.o()` (current Steam account's 64-bit SteamID as string)
- `token` — user JWT token

**MMKV playtime tracking:**
- Key: `MD5(game_id + steam_appid)` 
- Value: cumulative playtime in seconds
- `g()` resets to 0; `l(millis)` adds `millis/1000` to stored value

Also referenced in `SteamGameByPcEmuLaunchStrategy$checkCanStartSteamGame$2$1.java` — `heartbeat/game/start` is called before Steam game launch to register the play session.

---

## §337 — Cloud Gaming Payment Module (Pass 38)

**Package:** `com.xj.pay`  
**Class:** `com.xj.pay.data.repository.CloudGamePayRepository`

### Payment API Endpoints

| Method | Path | Params | Response |
|--------|------|--------|----------|
| `getGoodsList(page, page_size)` | `cloud/game/get_goods_list` | `page`, `page_size`, `token` | `GoodsListEntity` |
| `payMent(goods_id, pay_type)` | `cloud/payment` | `goods_id`, `pay_type`, `token` | `PayMentEntity` |
| `getOrderInfo(orderNo)` | `cloud/order/info` | `order_no`, `token` | `OrderEntity` |

Default `page=1`, `page_size=10`.  
Pay types are integer codes (not enumerated in the decompiled source).  
**WeChatPay** is also wired: `CloudGamePayActivity$startWXPay$1` handles WeChatPay callbacks.

---

## §338 — Tencent Portal Integration (Pass 38)

**Class:** `com.xj.landscape.launcher.net.tencent.TencentOperationsNetHelper`  
**Singleton:** `TencentOperationsNetHelper.a`

### Base URL

- **PROD/BETA**: `https://release.nj.qq.com`
- **DEV**: `https://test.nj.qq.com`

### Request Signing (Tencent)

URL signing uses SHA1: `appid=8P3VT7TE&timestamp={ts}_{originUri}_b2e16d59b1f64b650fdb397d4006344908956596` → SHA1 → lowercase hex.

Final URL: `{base}{originUri}?appid=8P3VT7TE&timestamp={ts}&sign={sha1hex}`

### Tencent API Methods and Request Builders

| Method | Key Body Params | Notes |
|--------|----------------|-------|
| `fetchSearch(keyword, context, pageSize)` | `keyword`, `context`, `page_size`; cache 5 min | Search games |
| `getAlbumList(scope, pageSize)` | `context`, `page_size` | Album/topic list |
| `getExplorationList(type, context, pkgName)` | `type`, `context`, `pkg_name` | Explore tab |
| `getInformationList(context, pageSize)` | `context`, `page_size` | News/info list |
| `getGameDetail(pkgName)` | `pkg_name` | Single game detail |
| `getTencentGameUpdateList(pkgList)` | list of packages | Check game updates |
| `getTencentRecommendList(pageSize)` | `page_size` default 30 | Recommend list |

### Common Request Header Envelope

Every Tencent request is wrapped with an envelope via `j(body)`:
```json
{
  "head": {
    "imei": "{LocalDeviceId}",
    "mode": "{Build.MODEL}",
    "userId": "{uid}",
    "ticketId": "{token}",
    "appName": "{AppUtils.b()}",
    "appVersionName": "{version_name}",
    "appVersionCode": "{version_code}",
    "timestamp": "{version_code}"
  },
  "body": {/* actual params */}
}
```

### Tencent Statistics Endpoint

`TencentStatisticsHelper.b = "https://trace.inlong.qq.com/hn0_iegcommon/dataproxy/message"`

**Event types** (`TencentEvent` enum): CLICK, SHOW, SEARCH, INSTALL, DOWNLOAD, UPDATE, REMOVE, START_GAME

**Event body format:** `key#value|key#value...`  
Examples:
- Click: `tab#{tab}|module#{module}|pos#{pos}|url#{param}|name#{name}`  
- Install/Download/Update: `pkg#{pkg}|status#{status}`
- Search: `txt#{text}`
- START_GAME: `pkg#{pkg}`

**Tab IDs:** 1=ExplorationTab, 2=FindGameTab, 3=Album, 4=Search, 5=SearchRecommend, 6=DetailRecommend, 7=MyGameNews

*[Pass 38 complete — 4 new sections (335–338) added]*

---

## §339 — Launcher Data Repository API Catalog (com.xj.landscape.launcher.data.repository)

Complete enumeration of all HTTP endpoints discovered in the launcher data repository layer. All POST requests use the base URL from `EggGameHttpConfig.a.a()` (official / EmuReady / BannerHub, see §340). All require `token` parameter from `UserManager.INSTANCE.getToken()` unless noted.

### Card Endpoints

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `card/getIndexList` | POST | token, type (int), platform_id? | HomeListEntity |
| `card/getTopPlatform` | POST | token | List\<PlatformEntity\> |
| `card/getGameDetail` | GET | id, game_name?, pkg_name?, token | GameDetailEntity |
| `card/getAlbumDetail` | POST | token, album_id | AlbumDetailEntity |
| `card/getNewsList` | POST | token, page, page_size | NewsListEntity |
| `card/getNewDetail` | POST | token, news_id | NewsDetailEntity |
| `card/getNewsGuideDetail` | POST | token | NewsGuideDetailEntity |
| `card/more` | POST | token, type, page | CardMoreEntity |

### Game Endpoints

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `game/getClassify` | POST | token | ClassifyEntity |
| `game/getIndexList` | POST | token, type, page, page_size | GameIndexEntity |
| `game/getGameCircleList` | POST | token | GameCircleListEntity |
| `game/userPlayedGame` | POST | token | UserPlayedGameEntity |
| `game/videoGameList` | POST | token, page, page_size | VideoGameListEntity |
| `game/cts/report` | POST | token, game_id, ... | (analytics) |
| `game/cancelLikeVideo` | POST | token, video_id | Unit |
| `game/likeVideo` | POST | token, video_id | Unit |

### Search Endpoints

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `search/getHotTrending` | POST | token | HotTrendingEntity |

### Settings / Notification Endpoints

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `settings/getNotifySwitch` | POST | token | UserNotificationSettingEntity |
| `settings/updateNotifySwitch` | POST | token, news_push? (int), game_push? (int), activity_push? (int) | Result\<Unit\> |

Mapping: enabled=1, disabled=2. `UserNotificationSettingEntity` default: all flags = 0 (mask 7 = all three disabled/unset).

`UserNotificationRepository` convenience methods:
- `updateNewsPushEnable(bool)` — sets news flag only
- `updateGamePushEnable(bool)` — sets game flag only  
- `updateActivityPushEnable(bool)` — sets activity flag only

### Social / User Endpoints

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `user/info` | POST | token | UserProfileEntity |
| `social/getUserInfo` | POST | uid, token | FriendInfoEntity |
| `social/deleteFriend` | POST | uid, token | Unit |
| `social/userNoticeList` | POST | token | NoticeListEntity |
| `social/userUpdateNotice` | POST | token, notice_id | Unit |

### Cloud Game Order / Usage Endpoints

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `cloud/order_list` | POST | page=1, page_size=10, order_by=0, token | CloudOrderListEntity |
| `cloud/use_time_log` | POST | month, token | TimeLogListEntity |
| `cloud/game/check_user_timer` | POST | token | UserTimerEntity |

`CloudGameOrderListRepository` defaults: page=1, page_size=10, order_by=0.

### Device / Whitelist Endpoints

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `devices/getUnknownDevices` | POST | devices_id, token | UnknownDevicesTipInfo |
| `devices/getDevicesList` | GET | token | List\<DeviceWhiteListItem\> |

`DeviceWhiteListManager`: caches result to SharedPreferences key `device_white_list`.

### App Upgrade Endpoint

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `/upgrade/getAppUpgradeApk` | POST | token, versionCode (from AppUtils.c()), is_active (1=active, 0=passive) | ApkUpdateEntity |

When `is_active=1`, result is cached in static field `AppUpgradeRepo.b`. The leading `/` is kept — `RemoveExtraSlashInterceptor` normalizes this.

### Doc / Help Endpoint

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `doc/docList` | POST | devices_id, keyword, token | List\<ProductDocEntity\> |

### Album Endpoint (AlbumRepo)

`AlbumRepo.getAlbumGameList(page, pageSize, albumId)` → POST `card/getAlbumDetail` (resolved from parent lambda pattern).

### SearchGameRepositoryV4 Architecture

Multi-source search combining three data stores:
- `c` = ConcurrentHashMap — local game library (keyed by game ID string)
- `d` = ConcurrentHashMap — Steam games (keyed by appid string)
- `e` = ISteamGameService — via TheRouter

**Search scope enum (`SearchScope`):** All, LocalLibrary, SteamLibrary

**`GameStashLocation` enum:** None, LocalGameLibrary, SteamGameLibrary

**PC emulator launch types filter** (for "PC games" scope): 1401 (PsLink), 1402 (PcLink), 1403 (PcEmulator), 1406, 1407 (SteamGameByPcEmulator)

**Key methods:**
- `M(scope, list, keyword, classifyGroupId, page, pageSize)` = `searchFirstPage`
- `R(scope, keyword, classifyGroupId, page, pageSize)` = `searchMore`
- `I(scope, keyword, ...)` = `performSearchFromAllSources`
- `J()` = `preFetchLibAndSteamGames`
- `K()` = `refreshGameLibraryCache`
- `E(card)` = `isInLocalGameLibrary`
- `F(card)` = `isInSteamGameLibrary`

**LandscapeLauncherRepository key internals:**
- `d = 300000L` — cache TTL (5 minutes in ms)
- `c` = lazy DownloadTaskRepository
- `mergeGamesWithServerTime(localGames, serverGames)` — joins by `steam_{steamId}` key, sorts by descending play time
- `subjectLibraryGamesAndSyncGameIcon(limit=50)` — returns Flow emitting at most `limit` games from DB
- `subjectMyGames()` — wraps above Flow, deduplicates against 300s TTL cache
- `p(games, topPlatforms)` — `buildMyGamesWithTopPlatform`: inserts platform header items at fixed positions (indices: first, 16, then remaining)

---

## §340 — PC Stream Module: QR-Code Pairing and Base-Link API

**Package:** `com.xj.module_pcstream`

### QR Scan Flow

QR code format: `egg|{pc_uuid}` — prefix `egg|` is mandatory (validated by `reportScanCode`).

1. User scans QR → `reportScanCode(pc_uuid, context)`  
   → POST `/user/mobileScanCode`  
   → Params: `token`, `pc_uuid`  
   → Shows `ScanCodeResultPopup` on response

2. User confirms → `confirmLoginGameHubLink(pc_uuid, context)`  
   → POST `/user/mobileConfirmCode`  
   → Params: `token`, `pc_uuid`

3. User cancels → `cancelLoginGameHubLink(pc_uuid, context)`  
   → POST `/user/mobileCancelCode`  
   → Params: `token`, `pc_uuid`

### PC Pairing (Limelight/Moonlight)

`PcView.doPair(pc_uuid)` → POST `/user/buildPcPin`  
→ Params: `token`, `pc_uuid`  
→ Returns: `PinCodeEntity`

Used to obtain a PIN for Moonlight/Limelight game stream pairing.

### Base Link Endpoint

`PcStreamShareRepository.getBaseLink()` → POST `baseLink/getBaseLink`  
→ Params: `token`  
→ Returns: `PcStreamBaseLinkEntity`  
→ Fields: `pc_link_mobile` (mobile deep-link), `pc_link_pc` (PC client URL)

---

## §341 — EggGameHttpConfig: OkHttp Client Setup and Base URL Resolution

**Class:** `com.xj.common.http.EggGameHttpConfig` (singleton companion `a`)

### Base URL Resolution (static initializer)

```
if (Constants.a.c())  // debug/test build
    → "https://test-landscape-api.vgabc.com/"
else if (ServerEnv == PRODUCT)
    → "https://landscape-api.vgabc.com/"
else if (ServerEnv == BETA)
    → "https://landscape-api-beta.vgabc.com/"
else (DEV)
    → "https://dev-gamehub-api.vgabc.com/"
```

Final URL = `GameHubPrefs.getEffectiveApiUrl(str)` — ReVanced extension hook that overrides with Official / EmuReady / BannerHub URL based on user pref.

`isTencentUrl(url)` helper (excludes Tencent URLs from token interceptors):  
Returns `true` for `test.nj.qq.com`, `release.nj.qq.com`, `trace.inlong.qq.com`.

### OkHttp Interceptor Stack (in order added)

1. `RemoveExtraSlashInterceptor` — strips leading `/` from paths
2. `LogRecordInterceptor(false, 0L, 0L)` — Drake-Net request logging
3. `EggGameTokenInterceptor` — adds `token` header to every request
4. `TokenRefreshInterceptor` — on HTTP 401 or JSON `code=401`: refresh token then retry (see §339 for full flow)
5. `OfflineCacheInterceptor(context, 0L)` — serves cached response when offline

### OkHttpClient Configuration

- `connectTimeout` = 30s, `readTimeout` = 30s, `writeTimeout` = 30s
- Disk cache: 128 MB in `context.getCacheDir()`
- `PersistentCookieJar` — session cookie persistence
- Converter: `GsonConverter` (custom, with `StringToBooleanAdapter` + `NullToEmptyListAdapterFactory`)
- Chucker integration (`ChuckerUtilsKt.b(builder)`) — in-app HTTP inspector in debug builds

*[Pass 39 complete — 3 new sections (339–341) added. Pass 39 clean-pass count: 0/3]*

---

## §342 — Authentication Endpoints (GuideLoginVM / GuideInputValidateCodeActivity)

All auth endpoints POST to `/jwt/...` (leading slash kept, stripped by `RemoveExtraSlashInterceptor`).

### Third-party Login — POST `/jwt/third/login`

Three variants in `GuideLoginVM`:

| Variant | Method | Key Params |
|---------|--------|-----------|
| **GameHub** (`login`) | POST | platform=(enum name lowercased), unionid="", openid, openkey="", extinfo=(JSON) |
| **WeChat** (`loginWeChat`) | POST | platform="weixin", unionid, openid, access_token |
| **QQ** (`loginQQ`) | POST | platform="qq", unionid="", access_token, openid |

Returns: `ThirdLoginEntity`

### Mobile OTP Login — POST `/jwt/mobile/login`

`GuideInputValidateCodeActivity.mobileLoginApi`  
Params: `mobile`, `captcha` (OTP code), `zone` (country calling code)  
Returns: `ThirdLoginEntity`

### Email Login/Register — POST `/jwt/email/login`

`GuideInputValidateCodeActivity.emailLoginOrRegister`  
Params: `email`, `captcha`  
Returns: `ThirdLoginEntity`

### One-key Mobile Login — POST `/jwt/oneMobile/login`

`GuideLoginActivity.onOneKeyAuthResultListener`  
Params: `accessToken` (from one-key SDK), `token` (existing user token)  
Uses carrier-based one-key login via third-party SDK result callback.

### Token Refresh — POST `jwt/refresh/token` (no leading slash)

`TokenRefreshInterceptor.j()` — called automatically on 401  
Params: `token` (refresh_token), `clientparams`, `time`, `sign`  
Returns JSON: `{data: {access_token, refresh_token}}`  
Uses separate `OkHttpClient` (via `EggGameTokenInterceptor` only, no `TokenRefreshInterceptor`).

### Logout — POST `/jwt/logout`

`UserAccountManageFragment.showUserLogoutConfirmDialog` and `AccountSettingFragment.initView`  
Params: `token`  
No return value needed.

### Web UI Endpoints (EggGameApi)

Constructed by appending to base URL:

| Static Field | Path | Usage |
|-------------|------|-------|
| `b` | `agreement/index.html?type=1&lang=` | User agreement page |
| `c` | `agreement/index.html?type=2&lang=` | Privacy policy page |
| `d` | `feedback/feedback_list.html?uid=` | Feedback list web UI |
| `e` | `feedback/feedback_detail.html?` | Feedback detail web UI |

---

## §343 — Cloud Gaming Session API (CloudGameInfoRepository)

**Package:** `com.xj.cloud.data.repository.CloudGameInfoRepository`

Full session lifecycle for cloud gaming. All endpoints POST to base API URL.

### Session Token Flow

```
checkUserTimer → auth_token → start_token → [play] → renew_token (heartbeat) → exit
                                              ↓
                                         queryQueue (if queuing)
```

### Endpoints

| Path | Method | Parameters | Returns |
|------|--------|-----------|---------|
| `/cloud/game/check_user_timer` | POST | token | UserTimeEntity |
| `cloud/game/auth_token` | POST | token, session, user (uid int), app_id (cloud_game_id) | AuthTokenEntity |
| `cloud/game/start_token` | POST | game_id, token, session | StartTokenEntity |
| `cloud/game/renew_token` | POST | lastDeadline, queue_id, token, session | ReNewTokenEntity |
| `cloud/game/exit` | POST | token, session | Unit |
| `cloud/game/getQueueInfo` | POST | token | StartQueueEntity |

**`StartQueueEntity`**: has `setFromType(1)` called automatically after fetch.

**Error handling:** `getAutoToken`, `getStartToken` fire `errorInv(errorMessage)` on exception; `getReNewToken` fires `errorInv()` (no args).

### Network Status Detector (NetworkStatusDetector)

**Class:** `com.xj.common.http.NetworkStatusDetector`

**NetworkStatus enum:** UNKNOWN, NO_NETWORK, CHINA_IP, VPN_ENABLED

**Detection logic (performNetworkCheck):**
1. Check connectivity → `http://connectivitycheck.gstatic.com/generate_204`
2. If connected, check Google access → `https://www.google.com/generate_204`
3. If Google reachable → VPN_ENABLED; else → CHINA_IP
4. On network loss → NO_NETWORK

Initial status set by locale: `zh-CN` or Hans script → CHINA_IP; else UNKNOWN.

**Static flag:** `NetworkStatusDetector.m` — accessible as `Companion.a()` / `Companion.b(bool)`

---

## §344 — OTA / Firmware Update Module (com.xj.ota)

**Package:** `com.xj.ota`

### BaseOTARepository

`URL_GET_FIRMWARE` hardcoded to `"http://127.0.0.1"` — placeholder; actual URL provided by subclass.

**GET request params to firmware URL:**
- `version` — device firmware version
- `beta` — "1" or "0"
- `name` — URI-encoded device name
- `appver` — app versionName from PackageManager
- `new_version` — "1" or "0"
- `lang` — locale language code
- `agreement` — "6"
- `all_upgrade` — "all"

Returns: `List<GameSirersionsState.DataBean>`

### FirmwareCheckUtil — Device → Check Class Mapping

| Device Name | Check Class |
|------------|-------------|
| T4N_PRO, T4N_PRO_GTOUCH | T4nProFirmwareCheck |
| X5_LITE, X5_LITE_DF, X5_LITE_DFU | X5LiteFirmwareCheck |
| G8 ("Gamesir-G8") | G8FirmwareCheck |
| X5S_EDR | DefaultFirmwareCheck("X5s-firmware-") |
| G8+ MFi, G8+ MFi_DFU | DefaultFirmwareCheck("G8-Plus-MFi-firmware-") |
| G8 SE, G8 SE_DFU | DefaultFirmwareCheck("G8-SE-firmware-") |
| NOVA_LITE, NOVA_LITE_OTA, NOVA_LITE_GTOUCH | T4NLiteFirmwareCheck |
| NOVA_2_LITE | DefaultFirmwareCheck("Nova2Lite-firmware-") |
| X3_PRO | X3ProFirmwareCheck |
| X2_PRO_XBOX (fw 128–144) | version range check |
| OTA Device | T4nFirmwareCheck |
| All others (T4C, X2S_BT, X3_TYPEC, etc.) | no check (null) |

**OtaUpState** enum values (from `BaseOTA`): implied states for BLE firmware update progress.

**HttpHandle** (OTA downloader):
- Default OkHttp: connectTimeout=`C.DEFAULT_MAX_SEEK_TO_PREVIOUS_POSITION_MS`, DNS timeout=5000ms
- Download client: connectTimeout=30s, readTimeout=30s, writeTimeout=30s + `SSLSocketClient` (trust-all)
- Max 10 requests per host, 30 concurrent requests total

*[Pass 40 complete — 3 new sections (342–344) added. Clean-pass count reset: 0/3]*

---

## §345 — Steam Module Architecture: SteamAPI, SteamSdk, SteamConfig

**Pass 41 | Sources:** `com/xj/standalone/steam/SteamAPI.java`, `com/xj/standalone/steam/sdk/SteamSdk.java`, `com/xj/standalone/steam/SteamConfig.java`, `com/xj/standalone/steam/SteamModuleConfig.java`

### SteamAPI Singleton (`com.xj.standalone.steam.SteamAPI`)

The primary facade for all Steam account and library operations. Singleton at `SteamAPI.a`.

**Key fields:**
| Field | Type | Purpose |
|-------|------|---------|
| `b` | `SteamUserTable` | Currently logged-in Steam account (null = not logged in) |
| `c` | `Lazy<SteamIPs>` | Lazy-init Steam IP table |
| `d` | `Lazy<OkHttpClient>` | OkHttp client for CDN downloads (with proxy) |
| `e` | `Lazy<OkHttpClient>` | OkHttp client for Steam API |
| `f` | `LinkedHashMap` | Active Steam account sessions |
| `g` | `LinkedHashMap` | Account → session mapping |
| `h` | `LinkedHashMap` | SteamID → `XjSteamClient` mapping |
| `i` | `Mutex` | Coroutine mutex for account operations |

**Key methods:**
| Method | Signature | Description |
|--------|-----------|-------------|
| `B()` | `→ Boolean` | `isLoggedIn`: b != null |
| `C(appId, cont)` | suspend | `isSteamGamePurchased(appId)`: checks SteamSdk then DB |
| `E(user, cont)` | suspend | `removeAccount(user)` via IO dispatcher |
| `F(client)` | `(XjSteamClient)` | Removes client from `h` map |
| `G(steamId)` | `(Long?)` | Disconnects and removes client by steamId |
| `H(appIds, cont)` | suspend | `requestFreeLicense(appIds)`: gets free license from Steam |
| `I(user, current, cont)` | suspend | `saveLoginAccount(user, isCurrentUser)` |
| `J(user)` | `(SteamUserTable)` | Sets `b` (current user) |
| `K()` | `→ Flow<...>` | `subjectCurrentLoginAccount()` — observable current account |
| `h(cont)` | suspend | `autoLogin()` — logs in saved account automatically |
| `z(cell, ...)` | | `connect(cellId, ...)` — connects to Steam CM server |

### SteamSdk Singleton (`com.xj.standalone.steam.sdk.SteamSdk`)

Lower-level Steam SDK orchestration. Singleton at `SteamSdk.a`.

**Key fields:**
| Field | Type | Value/Purpose |
|-------|------|---------------|
| `a` | `SteamSdk` | Singleton instance |
| `b` | `Lazy<CoroutineScope>` | Default IO scope with supervisor |
| `c` | `LanguageName` | Current language (default: `English`) |
| `d` | `Boolean` | Debug mode flag |
| `e` | `Lazy<SteamIPs>` | IP table |
| `f` | `Lazy<OkHttpClient>` | OkHttp with proxy (for CDN) |
| `g` | `Lazy<OkHttpClient>` | OkHttp without proxy |

**Key methods:**
| Method | Description |
|--------|-------------|
| `A()` | Returns `d` (debug mode) |
| `B(appId, cont)` | suspend `isFreeSteamGame(appId)` — queries `SteamGameApi.j()` |
| `G(lang)` | Set language and re-fetch store data |
| `H()` | `subjectCurrentAccount()` — observable Flow |
| `h(cont)` | suspend `checkSync()` — sync local DB with Steam |
| `k(chain)` | OkHttp interceptor: adds `User-Agent: Valve/Steam HTTP Client 1.0` |
| `j(str, session)` | Hostname verifier: always returns `true` (trust-all for Steam CDN) |
| `l(cont)` | suspend `getCurrentAccount()` — reads from Room DB |
| `v()` | Returns current `LanguageName` |
| `i(useProxy)` | Builds OkHttpClient for Steam CDN with trust-all SSL |

**OkHttpClient for Steam CDN** (`i(Boolean)`):
- Trust-all `X509TrustManager` (no cert validation for Steam CDN)
- Custom hostname verifier: always `true`
- User-Agent header: `Valve/Steam HTTP Client 1.0` (via interceptor `k()`)
- `DelegateSSLSocketFactory` wrapping trust-all context

### SteamConfig Singleton (`com.xj.standalone.steam.SteamConfig`)

Configuration constants and callback hooks for the Steam module.

| Field | Value | Purpose |
|-------|-------|---------|
| `b` | `88` | Default cell ID (mutable) |
| `k` | `24` | Max concurrent download connections |
| `l` | `20` | Max download workers |
| `m` | `60` | Max retry delay (seconds) |
| `n` | `Runtime.availableProcessors()` (fallback: 8) | CPU core count |
| `h` | `Lazy<GHFileServerListProvider>` | Steam server list (persisted at `files/server_list.bin`) |

**Callback hooks (all mutable at runtime):**
- `c` (`Function1`) — download progress callback
- `d` (`Function2`) — download state change callback
- `e` (`Function0`) — on download complete
- `f` (`Function0`) — on login required
- `g` (`Function0`) — on logout

**`GHFileServerListProvider`**: Reads/writes CM server list from local file `<filesDir>/server_list.bin`, providing cached Steam server addresses.

### SteamApiUrls (`com.xj.standalone.steam.sdk.SteamApiUrls`)

URL builder for Steam Web API calls:

| Method | URL Pattern |
|--------|------------|
| `b(appid, types, count)` | `https://store.steampowered.com/events/ajaxgetadjacentpartnerevents/?appid=X&count_before=0&count_after=Y[&event_type_filter=Z]` |
| `d(appid)` | `https://api.steampowered.com/api/appdetails?appids=X&filters=ratings` (CN: `store.steamchina.com`) |
| `e(appid)` | `https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1?appid=X` |
| `f()` | Base: CN locale → `https://store.steamchina.com`; other → `https://api.steampowered.com` |

**Language-aware routing:** Chinese locale (`LanguageName.Chinese`) uses `store.steamchina.com` + `&lang_list=6_0` suffix.

---

## §346 — Steam Download Subsystem

**Pass 41 | Sources:** `com/xj/standalone/steam/SteamDownloader.java`, `core/download/DepotContentDownloader.java`, `data/bean/SteamDownloadStatus.java`, `data/bean/AppDownloadInfo.java`

### SteamDownloadStatus Constants

Object `com.xj.standalone.steam.data.bean.SteamDownloadStatus`:

| Constant | Value | Meaning |
|----------|-------|---------|
| `Waiting` | 0 | Queued, not started |
| `Preparing` | 1 | Initializing download |
| `Downloading` | 2 | Actively downloading |
| `Paused` | 3 | User-paused |
| `Cancel` | 4 | Cancelled |
| `Finished` | 5 | Download complete |
| `Fail` | 6 | Error |
| `DownloadingConfigFile` | 7 | Fetching depot manifest |
| `Resuming` | 11 | Resuming from pause |
| `Installing` | 12 | Post-download install step |
| `DownloadSoon` | 13 | Queued for imminent download |

### AppDownloadInfo Data Class

`com.xj.standalone.steam.data.bean.AppDownloadInfo`:
- `appId: Int` — Steam app ID
- `branch: String` — Steam branch (e.g., "public", "beta")
- `depots: List<DepotInfo>` — list of depots to download

### SteamDownloader Singleton (`com.xj.standalone.steam.SteamDownloader`)

Orchestrates Steam content downloads. Singleton at `SteamDownloader.a`.

| Method | Description |
|--------|-------------|
| `b(depotId, appId, manifestId, branch, depotKey, pool, cont)` | Download depot chunk data |
| `c(appId, depotId, manifestId, manifestKey, depotKey, pool, cont)` | `downloadManifest2` — fetches depot manifest |
| `d(cont)` | `getContentService()` — gets `ContentServerDirectory` unified service from `XjSteamClient.G()` |
| `e(appId, depotId, cont)` | Gets app depot decryption key |
| `g(appId, depotId, manifestId, branch?, installDir?, cont)` | Main download entry point |

**IO scope:** `CoroutineScopeKt.a(Dispatchers.IO + SupervisorJob + CoroutineExceptionHandler)` — supervisor job so one depot failure doesn't cancel others.

**CDNClientPool (`com.xj.standalone.steam.cdn.CDNClientPool`)**: Manages pool of Steam CDN HTTP clients for parallel depot chunk downloads.

### DepotContentDownloader (`com.xj.standalone.steam.core.download.DepotContentDownloader`)

Implements `IContentDownloader`. Handles actual file I/O for Steam depots.

**Fields:**
| Field | Type | Purpose |
|-------|------|---------|
| `a` | `String` | Install directory path |
| `b` | `String` | Branch name |
| `c` | `SteamContent` | Steam content handler |
| `d` | `ResourceManager` | Manages depot download resources |
| `e` | `FileOperationHelper` | File read/write helper |
| `f` | `ChunkReferenceCounter` | Tracks chunk reference counts for deduplication |
| `h` | `ConcurrentHashMap` (static) | Global map of active downloaders |

**Inner class `DepotDownloadTask`:** Pairs `DepotFilesData` with a `List` of files to process.

**SteamContent integration:** Uses `in.dragonbra.javasteam` (JavaSteam library) types:
- `DepotManifest` — list of files in a depot revision
- `FileData` — individual file metadata (name, size, chunks)
- `ChunkData` — encrypted/compressed content block
- `EDepotFileFlag` — file flags (executable, read-only, symlink, etc.)

---

## §347 — XjSteamClient: Steam Connection and Authentication

**Pass 41 | Source:** `com/xj/standalone/steam/wrapper/XjSteamClient.java`

### XjSteamClient

Wraps `in.dragonbra.javasteam.steam.steamclient.SteamClient` with XJ-specific session logic.

**Key fields:**
| Field | Type | Purpose |
|-------|------|---------|
| `a` | `SteamConfiguration` | Built with TCP+UDP, custom HTTP client, server list |
| `b` | `Mutex` | Login mutex |
| `c` | `ExecutorCoroutineDispatcher` | Single-thread executor for Steam callbacks |
| `d` | `CoroutineScope` | Main scope on `c` dispatcher |
| `e` | `CoroutineScope` | Additional scope |
| `f` | `SteamClient` | Underlying JavaSteam client |
| `g` | `List` | Registered callback handlers |
| `h` | `Lazy<...>` | Lazy session init |
| `i` | `Boolean` | isConnected |
| `j` | `Boolean` | isLoggedIn |
| `k` | `Boolean` | isPendingLogin |
| `l` | `XjSteamUser` | Logged-in user info |
| `n` | `Long` | SteamID |
| `o` | `Mutex` | Reconnect mutex |

**SteamConfiguration builder** (`Companion.d()`):
- `withHttpClient(SteamAPI.a.q())` — uses SteamAPI's OkHttp
- `withProtocolTypes(TCP, UDP)` — both protocols enabled
- `withServerListProvider(SteamConfig.a.e())` — file-based server list

**Auth modes (from imports):**
- `XjCredentialsAuthSession` — username/password login
- `XjQrAuthSession` — QR code login
- `XjSteamAuthentication` — wraps `SteamAuthentication`

**Handler registrations** (from `SteamApps`, `SteamContent`, `SteamFriends`, `SteamUnifiedMessages`, `SteamUser`, `SteamUserStats`): All standard Steam protocol handlers registered to the client.

**Method `M()`:** Disconnect/cleanup the Steam client.
**Method `G()`:** Returns `SteamUnifiedMessages` for RPC service creation.

---

## §348 — Game Management Module

**Pass 41 | Sources:** `com/xj/game/SteamGameManager.java`, `com/xj/game/UninstallGameHelper.java`

### SteamGameManager (`com.xj.game.SteamGameManager`)

Singleton at `SteamGameManager.a`. Coordinates between Steam download state and the game library UI.

**Lifecycle:** Static initializer registers a `receiveEventHandler` on `ChannelScope` for `DownloadTask` events. When a `DownloadTask` completes (`isCompleteTask()`) and has a Steam app ID > 0, it calls `G()` to update the local game library.

**Lazy dependencies:**
- `b` → `ISteamGameService` (via TheRouter)
- `c` → `IWinEmuService` (via TheRouter)
- `d` → `GameLibraryRepository`

### UninstallGameHelper (`com.xj.game.UninstallGameHelper`)

Singleton at `UninstallGameHelper.a`. Manages game uninstall logic.

**`GameFrom` enum:**
| Constant | Value | Description |
|----------|-------|-------------|
| `DOWNLOAD_FROM_SVR` | 0 | Downloaded from BannerHub/GameHub server |
| `IMPORT_BY_USER` | 1 | Manually imported by user |
| `IMPORT_BY_STEAM_TOOL` | 2 | Imported via Steam tool |
| `DOWNLOAD_FROM_STEAM_SVR` | 3 | Downloaded from Steam servers |

**Uninstall dispatch:** Routes uninstall based on `GameFrom`:
- Server/Steam downloads: deletes files at install path
- User imports: depends on file deletion or system uninstall

### Game Library Menu Events

| Class | Purpose |
|-------|---------|
| `LocalGameLibraryShowFilterMenu` | Event to show filter menu for local library |
| `LocalGameLibraryShowSortMenu` | Event to show sort menu for local library |
| `SteamGameLibraryShowFilterMenu` | Event to show filter menu for Steam library |
| `SteamGameLibraryShowSortMenu` | Event to show sort menu for Steam library |
| `ShowConfirmUninstallGame` | Event to show uninstall confirmation dialog |
| `ChangeLaunchTypeEvent` | Event fired when user changes game launch type |
| `GameLibraryMenuVisibleStatus` | Tracks visible state of game library menus |
| `ShowGameManageSortOptionMenu` | Event for manage-view sort options |

---

## §349 — Push Notification Module (JPush)

**Pass 41 | Sources:** `com/xj/push/PushApp.java`, `com/xj/push/jiguang/JPushService.java`, `com/xj/push/jiguang/JPushBroadcastReceiver.java`, `com/xj/push/service/PushService.java`

### Push Stack

The app uses **Jiguang (极光推送 / JPush)** for push notifications.

| Class | Role |
|-------|------|
| `PushApp` | `@Module @ComponentScan SubApp` — initializes JPush |
| `JPushService` | Extends `JCommonService` — foreground service for JPush |
| `JPushBroadcastReceiver` | Extends `JPushMessageReceiver` — receives push events |
| `PushService` | `@Single IPushService` — service interface impl, calls `PushApp.setCurUserAlias` |

### JPush Alias Setup (`PushApp.Companion.a()`)

Called on login to link JPush device ID to user account:
```java
JPushInterface.setAlias(context, String.valueOf(userManager.getUid()), callback)
```
- Uses `UserManager.getUid()` as the JPush alias
- Callback sets `AtomicBoolean b = true` on success
- Guards against double-registration via `AtomicBoolean`

### JPushBroadcastReceiver Event Handlers

All events logged via `XjLog.c("JPushBroadcastReceiver", ...)`:
- `getNotification()` — customize notification appearance
- `isNeedShowNotification()` — control notification display
- `onAliasOperatorResult()` — alias set/delete result
- `onCheckTagOperatorResult()` — tag query result
- `onCommandResult()` — command delivery acknowledgment
- `onConnected(z)` — connection status change

---

## §350 — Launch Strategy Pattern (Full Details)

**Pass 41 | Sources:** `com/xj/launch/strategy/api/LaunchStrategy.java`, `com/xj/launch/strategy/api/LaunchResult.java`, `com/xj/launch/strategy/pc/emulator/PcEmulatorStrategy.java`

### LaunchStrategy Interface

```java
public interface LaunchStrategy {
    LaunchResult a(LauncherConfig launcherConfig);
}
```

Single method `a(config)` — synchronous entry point that returns a `LaunchResult`.

### LaunchResult Sealed Class

Abstract class with two concrete subclasses:

| Subclass | Field | Description |
|----------|-------|-------------|
| `LaunchResult.Success<T>` | `a: T` | Success with payload |
| `LaunchResult.Failure` | `a: Exception` | Failure with exception |

### PcEmulatorStrategy

Singleton `PcEmulatorStrategy.a`. The PC-emulator launch path (used for launch types 1401–1407).

**`a(config)` implementation:**
1. Checks `config.f() != null` (LauncherGameInfo must be present)
2. Launches coroutine on `KotlinUseUtilsKt.a()` scope (static scope)
3. Returns `LaunchResult.Failure("Start asynchronous processing,The result is retrieved from callback")` — intentional: result delivered via callback, not return value

**Callback delivery (`j(config, success)`):**
- Success: `config.d().invoke(true, "开始启动模拟器")` ("Starting emulator")
- Failure: `config.d().invoke(false, "游戏启动失败")` ("Game launch failed")

**`config.d()`** is `Function2<Boolean, String, Unit>` — the progress/status callback in `LauncherConfig`.

### LauncherConfig Methods Referenced

| Method | Type | Purpose |
|--------|------|---------|
| `f()` | `LauncherGameInfo?` | The game to launch |
| `d()` | `Function2<Boolean,String,Unit>?` | Status callback |
| `g()` | `String` | Game name |
| `j()` | `String` | Package name |

---

## §351 — Steam Service Layer (module/steam)

**Pass 41 | Sources:** `com/xj/module/steam/SteamService.java`, `com/xj/module/steam/service/SteamGameService.java`

### SteamService (Android Service)

`com.xj.module.steam.SteamService extends Service`

Foreground Android service managing the Steam connection lifecycle.

**Notification channel:** Creates persistent notification to keep service alive in background.

**Fields:**
| Field | Type | Value/Purpose |
|-------|------|---------------|
| `h` | `AtomicReference<Boolean>` | `false` — service running flag |
| `b` | `Handler` | Main-thread handler for MSG events |
| `c` | `List` | Download task list |
| `d` | `AppStatusChangedListener` | On app background: calls `p()` and `n()` |
| `f` | `int` | `AuthApiStatusCodes.AUTH_API_INVALID_CREDENTIALS` — initial state |

**App lifecycle:** When host app goes to background, `SteamService` triggers disconnect logic (`p()`) and cleanup (`n()`).

**`Companion.d(context, start=true)`:** Starts or stops `SteamService` via `Intent`.

### SteamGameService (`@Single ISteamGameService`)

`com.xj.module.steam.service.SteamGameService`

Koin DI singleton implementing `ISteamGameService` interface.

**`A(gameId, appId, steamDir)`** — `getCloudSaveManager`:
- Looks up cached `CloudSaveManager` by `(appId, winePrefix)`
- `IWinEmuService.h(gameId).c()` → gets Wine prefix path
- Creates new `CloudSaveManager(appId, winePrefix, steamDir)` if not cached

**`B(appId, cont)`** — `getLaunchInfo(appId)`:
- Queries `SteamDownloadManager.w0().e(appId)` → `SteamModuleDownloadEntity`
- Returns `Triple(installPath, executable, arguments)` from `LaunchInfo`
- Falls back to `downloadExtend.getInstallDirPath()` if primary path empty

**Imports reveal full service dependency graph:**
- `SteamDownloadManager` — download state
- `SteamFilePaths` — path resolver
- `SteamGameApi` — Steam game info
- `SteamInputManager` — controller/input mapping for Steam games
- `CloudSaveManager` — Steam Cloud save sync
- `IWinEmuService` — Wine prefix management
- `ISteamService` — low-level Steam client interface

---

## §352 — Download Manager (GHDownloadManager)

**Pass 41 | Source:** `com/xj/download/api/GHDownloadManager.java`

### GHDownloadManager (`com.xj.download.api.GHDownloadManager`)

Singleton `GHDownloadManager.a`. Implements both `IDownloader` and `IDownloadManager`.

**Uses `DownloaderFactory` to dispatch between:**
- `AriaDownloadRequest` → Aria2 downloader (HTTP download from BH server)
- `SteamDownloadRequest` → Steam depot downloader (via `SteamDownloadManager`)

**Methods:**
| Method | Description |
|--------|-------------|
| `b(request, cont)` | `startDownload(request)` — delegates to factory |
| `c(url, cont)` | `queryDownloadTaskByUrl(url)` |
| `a(task, err)` | `notifyDownloadFailed(task, err)` — notifies all `GhDownloadCallback` listeners |

**Callback list:** `CopyOnWriteArrayList<GhDownloadCallback> c` — thread-safe listener list for download events.

**IDownloadLog `b`:** Default: `Log.e(tag, msg, th)` — errors to Android logcat.


---

## §353 — SteamDownloadManager: Core Download Orchestrator

**Pass 42 | Source:** `com/xj/standalone/steam/core/SteamDownloadManager.java`

### Overview

Singleton `SteamDownloadManager.a`. Central controller for all Steam game download state. Implements `InternalDownloadCallback`.

**Static fields:**
| Field | Type | Purpose |
|-------|------|---------|
| `a` | `SteamDownloadManager` | Singleton |
| `b` | `DownloadCallback` | Registered callback for download events |
| `c` | `AtomicReference` | Current download task ref |
| `d` | `CoroutineScope` | Named scope "SteamDownloadManagerScope" |
| `e` | `GlobalDownloadStats` | Aggregate download statistics |
| `h` | `SteamInstallGameRepo` | Install record repository |
| `i` | `ConcurrentHashMap<Long, Job>` | Active download jobs by appId |
| `j` | `Boolean` | Is app in background |
| `l` | `DownloadingTracker` | Tracks currently-running download |
| `o` | `Mutex` | Serializes download start/stop |
| `r`, `s` | `Long` | Bandwidth timestamps |

**`DownloadCallback` interface:**
| Method | Event |
|--------|-------|
| `a(entity)` | Download started |
| `b(entity)` | Download progress updated |
| `c(entity, error)` | Download failed |
| `d(entity)` | Download paused |
| `e(entity)` | Download cancelled |
| `f(entity)` | Download complete |

**Key inner class `PauseOrCancel`:** Extends `CancellationException`. Used to interrupt download coroutines with a named reason.

### SteamFilePaths Constants

`com.xj.standalone.steam.core.SteamFilePaths` singleton:

| Constant | Value | Resolved Path |
|----------|-------|---------------|
| `b` | `"Steam"` | Base dir name |
| `c` | `"steamapps"` | Depot dir name |
| `d` | `"common"` | Games dir name |
| `e` | `"config"` | Config dir name |
| `f` | `"steam_download_cache"` | Cache dir name |
| `g` | Computed | `<filesDir>/steam_download_cache` |
| `h` | Computed | `File(g)` |
| `i` | Computed | `File(h, "manifest")` — manifest cache dir |
| `j` | Computed | `<filesDir>/Steam` — Steam root |
| `k` | Computed | `<filesDir>/Steam/steamapps` |
| `l` | Computed | `<filesDir>/Steam/steamapps/common` — game install root |
| `m` | Computed | `<filesDir>/Steam/steamapps/config` |
| `n` | Computed | `File(m, "steam_input")` |
| `o` | Computed | `File(n, "config")` — Steam Input config |
| `p` | Computed | `File(k, "app_info")` |
| `q` | `"steam_games"` | Games subdir name |
| `r` | Computed | `<filesDir>/steam_games` — alternate games dir |

**Initialization (`a()`):** Creates all directory structures. If any fail, deletes and retries.

### Key Method Reference

| Method | Signature | Description |
|--------|-----------|-------------|
| `A0()` | `→ Boolean` | `hasRunningTask()`: checks `DownloadingTracker` |
| `B0(appId)` | `→ Boolean` | `isGameInstalled(appId)`: checks install repo |
| `D0(appId)` | `→ Boolean` | Same as B0 (both call `h.h(appId)`) |
| `E0(appId)` | `→ Boolean` | `isDownloading(appId)`: checks tracker |
| `F0(appId)` | `→ Boolean` | `hasActiveJob(appId)`: checks `i` map |
| `G0(appId)` | `→ Boolean` | `isUpdatePaused(appId)`: checks status==3 + isUpdateTask |
| `H0(appId)` | `→ Boolean` | Special case: returns `appId == 228980` (SteamVR?) |
| `M0(isPause, from, cont)` | suspend | `pauseCurrentRunningTask`: cancels active job via PauseOrCancel |
| `N(entity)` | `→ String` | Resolves install base dir (Steam/steamapps vs alternate) |
| `N0(appId)` | | `pauseDownloadApp(appId)` |
| `O(appId, depotId)` | | `startDownload(appId, depotId)` — guard-checked |
| `P(appInfo, branch, dir, update, ...)` | suspend | Main download entry — full depot download flow |
| `w0()` | → | Returns `n0()` entries (download map accessor) |

**App background handling:** When app goes to background (`j = true`), the download manager suspends to reduce CPU/network load.

---

## §354 — Steam Auth and Login Flow

**Pass 42 | Sources:** `com/xj/standalone/steam/sdk/auth/LoggedOnResult.java`, `com/xj/standalone/steam/sdk/auth/SteamAuthApi.java`, `com/xj/module/steam/service/SteamAuthService.java`, `com/xj/module/steam/account/bean/LoginResult.java`

### LoggedOnResult

Wraps JavaSteam's `LoggedOnCallback`. Factory constants:
- `c` = `LoggedOnResult(EResult.OK)` — success sentinel
- `d` = `LoggedOnResult(EResult.Fail)` — failure sentinel

Methods:
| Method | Returns | Description |
|--------|---------|-------------|
| `b()` | `Long` | SteamID as UInt64 (0 if null) |
| `c()` | `Boolean` | `isServerTimeoutNotification`: result==TryAnotherCM && extendedResult==Invalid |
| `d()` | `Boolean` | `isSuccess`: result==OK |

### LoginResult

Data class for UI-layer login outcome:
- `a: Boolean` = `success`
- `b: Boolean` = `isQRCode`

### SteamAuthService (`@Single ISteamAuthService`)

Koin singleton. `a(username, password, rememberMe, authenticator, cont)` → calls `SteamAuthApi.a.d(username, password, authenticator, cont)`.

**Auth flow parameters:**
- `username: String` — Steam login name
- `password: String` — Steam password
- `rememberMe: Boolean` — stored in `Z$0`
- `authenticator: IAuthenticator` — implements 2FA/guard code provider

**`SteamGameApi` methods (selected):**
| Method | Description |
|--------|-------------|
| `g(appId, cont)` | `getAgeRatings(appId)` |
| `h(appId, cont)` | `getAppInfo(appId)` — Room DB via `SteamPicsAppDao` |
| `i(appIds, cont)` | `getAppIdToGenresMap(appIds)` — batch genre lookup |
| `j(appId, cont)` | `getAppInfoForOwnershipCheck(appId)` — checks `isFreeApp()` |

**`SteamGameApi` HTTP client:** `v()` = 15s connect/read/write timeouts (no proxy, no SSL override).

**`SteamDownloadApi` method:**
- `a(appId, depotId, cont)` — `getDepotDecryptionKey(appId, depotId)`: calls `SteamSdk.a.q(cont)` to get active client, then `SteamApps.getDepotDecryptionKey(appId, depotId)` from JavaSteam.

---

## §355 — Steam Cloud Save System

**Pass 42 | Sources:** `com/xj/standalone/steam/cloud/CloudSyncState.java`, `com/xj/standalone/steam/cloud/ConflictResolution.java`, `com/xj/standalone/steam/cloud/ERemoteStorageSyncState.java`, `com/xj/module/steam/cloud_save/CloudSaveManager.java`

### CloudSyncState Enum

Active sync operation states:
`STARTING → DOWNLOADING → UPLOADING → COMPLETED`
Or terminal: `FAILED`, `CANCELLED`

### ConflictResolution Enum

When local and remote saves differ:
| Value | Strategy |
|-------|---------|
| `UseLocal` | Overwrite remote with local |
| `UseRemote` | Overwrite local with remote |
| `Manual` | Prompt user |

### ERemoteStorageSyncState Enum

Steam Cloud sync status codes:

| Value | Code | Meaning |
|-------|------|---------|
| `DISABLED` | 0 | Cloud sync off |
| `UNKNOWN` | 1 | Cannot determine |
| `SYNCHRONIZED` | 2 | Up-to-date |
| `IN_PROGRESS` | 3 | Currently syncing |
| `CHANGES_IN_CLOUD` | 4 | Remote has newer data |
| `CHANGES_LOCALLY` | 5 | Local has newer data |
| `CHANGES_IN_CLOUD_AND_LOCALLY` | 6 | Both sides changed |
| `CONFLICTING_CHANGES` | 7 | Conflict needs resolution |
| `NOT_INITIALIZED` | 8 | Steam Cloud not set up |

**`Companion.a(code)`:** Looks up by UInt code, returns `UNKNOWN` if not found.

### CloudSaveManager

`com.xj.module.steam.cloud_save.CloudSaveManager` implements `ISteamGameService.ICloudSaveManager`.

**Constructor:** `CloudSaveManager(appId: Int, containerPath: String, steamDir: String)`
- Creates `CloudSaveProvider(appId as UInt, "windows", containerPath, null)` — hardcoded to Windows platform saves
- `SyncState` starts as `IDLE`
- Uses `SyncContext` from `standalone.steam.cloud`

**`ICloudSaveManager.SyncState` values** (from import): `IDLE`, syncing states driven by `CloudSyncState`.

**Thread safety:** `Object i` used as lock; `CopyOnWriteArrayList g` for sync event listeners.

**Key dependency:** `CloudSaveProvider` wraps the JavaSteam `SteamUnifiedMessages` remote storage RPC service to upload/download save files from Steam Cloud.

---

## §356 — SteamGameApi: Steam Game Info Queries

**Pass 42 | Source:** `com/xj/standalone/steam/sdk/game/SteamGameApi.java`

### SteamGameApi Singleton

`com.xj.standalone.steam.sdk.game.SteamGameApi.a`. Provides game metadata via Room DB and Steam Web API.

**Fields:**
| Field | Type | Purpose |
|-------|------|---------|
| `b` | `Lazy<Logger>` | Logging |
| `c` | `Lazy<OkHttpClient>` | 15s-timeout HTTP client for Web API |
| `d` | `ConcurrentHashMap` | `appId → OnlineCountCache` cache |

**`OnlineCountCache` data class:**
- `a: Long` = `playerCount`
- `b: Long` = `timestamp`
- `b(ttl)` — `isExpired(ttl)`: checks `now - timestamp > ttl`

**Key methods:**
| Method | Description |
|--------|-------------|
| `g(appId, cont)` | `getAgeRatings(appId)`: GET `SteamApiUrls.d(appId)` |
| `h(appId, cont)` | `getAppInfo(appId)`: Room DB `SteamPicsAppDao` |
| `i(appIds, cont)` | `getAppIdToGenresMap(appIds)`: DB → `Map<Int, List<Genre>>` |
| `j(appId, cont)` | `isFreeSteamGame(appId)`: DB `SteamPicsAppInfo.isFreeApp()` |

**URL used for age ratings:**
`https://api.steampowered.com/api/appdetails?appids=X&filters=ratings`
(CN: `https://store.steamchina.com/api/appdetails?...`)

**Online player count:** Cached in `d` with TTL. URL: `https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1?appid=X`


---

## §357 — Steam Input System

**Pass 43 | Sources:** `com/xj/standalone/steam/steam_input/SteamInputManager.java`, `SteamInputConfig.java`, `ConfigType.java`, `InputConfig.java`, `AppConfigState.java`

### SteamInputManager (`com.xj.standalone.steam.steam_input.SteamInputManager`)

Singleton at `SteamInputManager.a`. Manages Steam Input controller configurations.

**`a(appId, configName, controllerType, cont)`** — `createCustomConfigFromTemplate`:
1. Calls `SteamInputConfig.a.n(controllerType, cont)` — fetches template config
2. Templates sourced from assets; writes to `SteamFilePaths.o` (config dir)
3. Uses JavaSteam `KeyValue` for VDF (Valve Data Format) parsing

### SteamInputConfig (`com.xj.standalone.steam.steam_input.SteamInputConfig`)

Singleton at `SteamInputConfig.a`. Config file read/write manager.

**Fields:**
- `b: Gson` — for JSON serialization
- `c: ReentrantReadWriteLock` — thread-safe config access
- `d: LinkedHashMap` — in-memory config cache

**`a(file, content)`** — Atomic file write: writes to temp file `g(file)`, then renames. Falls back to `Files.copy`.

**Config storage location:** `SteamFilePaths.o` = `<filesDir>/Steam/steamapps/config/steam_input/config/`

**Template source:** Asset files in APK (`AssetManager`).

### ConfigType Enum

| Value | SerializedName | Description |
|-------|---------------|-------------|
| `PRESET` | `"preset"` | Steam default controller layout |
| `CUSTOM` | `"custom"` | User-created custom layout |

---

## §358 — WinEmu Module: Wine PC Emulator Integration

**Pass 43 | Sources:** `com/xj/winemu/api/bean/IWinEmuService.java`, `IEmuContainer.java`, `WineActivityData.java`, `ComponentType.java`, `WinEmuFilePathsConstant.java`

### IWinEmuService Interface

Central Wine emulator service interface. Retrieved via TheRouter: `TheRouter.b(IWinEmuService.class)`.

**Method catalog:**
| Method | Description |
|--------|-------------|
| `a(gameId)` | `isGameInstalled(gameId): Boolean` |
| `b(gameId)` | `isGameRunning(gameId): Boolean` |
| `c(data, onStart?, onExit?)` | `startGame(WineActivityData, ...)` |
| `d(gameId, cont)` | suspend → get game exe path |
| `e(gameId, cont)` | suspend → get game working dir |
| `f(gameId, cont)` | suspend → get game launch args |
| `g()` | `getInstalledGameCount(): Int` |
| `h(gameId)` | `getEmuContainer(gameId): IEmuContainer` — Wine prefix container |
| `i(cont)` | suspend → check if Wine is initialized |
| `j(entity, dir, forceReparse)` | `parseExeInfoIfNeed(GameDetailEntity, ...)` |
| `k(gameId, cont)` | suspend → get wine prefix path |
| `m(gameId)` | `getInstallDir(gameId): String` |
| `n(gameId, cont)` | suspend → async get install dir |
| `o(scope, activity, data)` | `initWineForActivity` |
| `p(gameId, cont)` | suspend → get game screenshot |
| `r(i)` | `getComponentCount(type): Int` |
| `s(entity)` | `addGameToLib(GameDetailEntity)` |
| `t(gameId, cont)` | suspend → get last played time |
| `u(gameId)` | `getGameIcon(gameId): Bitmap` |
| `v()` | `getTotalInstalledSize(): Int` |
| `w(activity)` | `showGameManagementUI(FragmentActivity)` |
| `x()` | `getWineVersion(): String` |
| `y(gameId, cont)` | suspend → get ACF file path |
| `z(gameId, dir, update, cont)` | suspend → `installOrUpdateGame(...)` |

### IEmuContainer Interface

Per-game Wine container (prefix) abstraction:

| Method | Description |
|--------|-------------|
| `b()` | `delete()` — remove container |
| `c()` | `getContainerPath(): String` |
| `d()` | `getGameId(): String` |
| `e(name, overwrite, cont)` | suspend → install env layer |
| `exists()` | Container path exists |
| `f(name, version, reinstall, cont)` | suspend → `installComponent(name, version, ...)` |
| `g()` | `getEnvVersion(): String` |
| `h(name)` | `isComponentInstalled(name): Boolean` |
| `i(name)` | `isEnvInstalled(name): Boolean` |
| `j(name, cont)` | suspend → uninstall component |
| `k()` | `getInstalledComponents(): Set` |
| `l()` | `getPrefix(): String` — Wine prefix path |
| `m(clean, cont)` | suspend → initialize container |
| `n(gameId, cont)` | suspend → migrate game to container |

### WineActivityData (Parcelable)

Data class passed when starting a Wine game. All fields:

| Field | Type | Description |
|-------|------|-------------|
| `a` | `String` | Game ID |
| `b` | `String` | Game name |
| `c` | `String` | Game executable path |
| `d` | `Int` | Launch type |
| `e` | `Boolean` | Is fullscreen |
| `f` | `Boolean` | Is Steam game |
| `g` | `String` | Work directory |
| `h` | `String` | Launch arguments |
| `i` | `Boolean` | Enable VKD3D |
| `j` | `String` | Container path |
| `k` | `Boolean` | Enable DXVK |
| `l` | `String` | Env layer version |
| `m` | `Boolean` | Enable FPS limit |
| `n` | `IBinder` (transient) | Activity binder |
| `o` | `Boolean` | Enable overlay |
| `p` | `Boolean` | Enable gamepad |

### ComponentType Enum

Wine component types with integer type codes:

| Constant | Code | Description |
|----------|------|-------------|
| `TRANSLATOR` | 1 | Wine translation layer (proton?) |
| `GPU` | 2 | GPU driver (turnip/Mesa) |
| `DXVK` | 3 | DXVK (DX9/10/11 → Vulkan) |
| `VKD3D` | 4 | VKD3D-Proton (DX12 → Vulkan) |
| `GENERAL` | 5 | General Wine component |
| `DEPENDENCY` | 6 | Runtime dependency (VC++, etc.) |
| `STEAMCLIENT` | 7 | Steam client integration |

### WinEmuFilePathsConstant

File path constants for Wine emulator storage under `<internalAppFilesPath>/xj_winemu/`:

| Constant | Path | Purpose |
|----------|------|---------|
| `b` | `<files>` | App files dir |
| `c`, `d` | `<files>/xj_winemu` | Wine root |
| `e` | `.../xj_downloads` | Component downloads |
| `f` | `.../xj_downloads_games` | Game downloads |
| `g` | `.../xj_install` | Installed items root |
| `h` | `.../xj_downloads_games/game` | Game download staging |
| `i` | `.../xj_downloads/env` | Env layer downloads |
| `j` | `.../xj_downloads/component` | Component downloads |
| `k` | `.../xj_downloads/sd` | SD card downloads |
| `l` | `.../xj_install/game` | Installed games |
| `m` | `.../xj_install/env` | Installed env layers |
| `n` | `.../xj_install/component` | Installed components |

**Game install path:** `<files>/xj_winemu/xj_install/game/<gameId>` (no version) or `<files>/xj_winemu/xj_install/game/<version>/<gameId>` (versioned).

---

## §359 — PSPlay Module (PlayStation Remote Play / Chiaki)

**Pass 43 | Source:** `com/xj/psplay/lib/`

The app includes a PlayStation Remote Play module based on the **Chiaki** open-source library.

**Key classes:**
| Class | Description |
|-------|-------------|
| `ChiakiKt` | Constants: `CONTROLLER_TOUCHES_MAX = 2` (max touch points for PS controller) |
| `Event` | Base event class |
| `RegistEvent` | PS account registration event |
| `ConnectedEvent` | Session connected event |
| `RegistEventCanceled` | Registration cancelled |
| `RegistEventFailed` | Registration failed |
| `LoginPinRequestEvent` | PS login PIN requested |
| `ErrorCode` | Error code enum/constants |
| `ControllerTouch` | Touch input for PS controller |
| `CreateError` | Session creation error |

**Integration:** PSPlay (PlayStation Remote Play) is a launch type in the launcher, allowing users to stream PS5/PS4 games through their Android device. The Chiaki integration provides the streaming/control protocol.

**`maxAbs(s1, s2): Short`** — Returns the value with greater absolute magnitude (used for analog stick normalization).

---

## §360 — Download Stats and Content Downloader Details

**Pass 43 | Sources:** `contentdownloader/GlobalDownloadStats.java`, `contentdownloader/DepotDownloadInfo.java`

### GlobalDownloadStats

Thread-safe download statistics tracker:

| Field | Type | Description |
|-------|------|-------------|
| `a` | `AtomicLong` | `sizeDownloaded` — total bytes downloaded from network |
| `b` | `AtomicLong` | `sizeWrite` — total bytes written to disk |
| `c` | `AtomicLong` | `prevSizeDownloaded` — previous download snapshot |
| `d` | `AtomicLong` | `prevSizeInstalled` — previous write snapshot |

**`a()`** — `getWriteDelta()`: Returns bytes written since last call. Updates `d` to current `b`. First call returns 0 (sets baseline). Used for real-time write speed calculation.

**Initialized in `SteamDownloadManager` static block:**
```java
e = new GlobalDownloadStats(null, null, null, null, 15, null)
```
(All 4 `AtomicLong` params null with bit-mask 15 → all use default `AtomicLong(0)`)

---

## §361–§368: Cloud Gaming, PC Stream, Steam DB Detail

### §361 — Cloud Gaming Module (`com.xj.cloud`)

**LauncherCloudGameActivity** (`com/xj/cloud/ui/LauncherCloudGameActivity.java`)

Extends `FocusableActivity<LauncherCloudGameViewModel, CloudGameActivityBinding>`.  
Implements: `TYMovingListener`, `SpeedManagerListener`, `NotPlaySoundPage`.  
Annotated with `@Route`.

Key fields:
- `g: TYConfig` — TYMoving RTC configuration
- `h: TYMoving` — primary RTC SDK instance
- `i: TYMovingGameView` — game rendering view
- `Z: CloudGameDialogCtrl` — dialog controller for cloud game UI
- `y = 36000` — session time budget in seconds (10 hours)
- `E = ExoPlayer.DEFAULT_DETACH_SURFACE_TIMEOUT_MS` — surface timeout
- `N = 5000L` — 5-second timeout constant
- `w0 = "LauncherCloudGameActivity"` — log tag
- `x0 = 1`, `y0 = 3600`, `z0 = 900`, `A0 = 60` — time constants (seconds)

**MovingMessage enum values handled** (from `WhenMappings` static initializer):
1. `WSS_CONNECT_SUCCESS` — WebSocket connected
2. `WSS_RECONNECTION_SUCCESS` — WebSocket reconnected
3. `WSS_DISCONNECT` — WebSocket disconnected
4. `SDK_AUTH_TOKEN_DATA` — auth token received
5. `SDK_AUTH_TOKEN_SUCCESS` — auth token verified
6. `SDK_IN_THE_QUEUE` — queued for server
7. `SDK_START_GAME_DATA` — game start data received
8. `SDK_START_GAME_DATA_SUCCESS` — game start data accepted
9. `SDK_START_GAME_SUCCESS` — game started successfully
10. `SDK_FIRST_FRAME_DRAWING_SUCCESS` — first frame rendered
11. `SDK_XBOX_RECONNECTION` — Xbox controller reconnected
12. `SDK_PROGRESS` — general progress update
13. `SDK_RENEW_TOKEN_DATA` — token renewal data received
14. `SDK_RENEW_TOKEN_SUCCESS` — token renewal succeeded
15. `SDK_FORCE_EXIT` — server forced exit
16. `SDK_USER_EXIT` — user-initiated exit
17. `SDK_USER_CLOSE` — user closed session
18. `SDK_USER_NOT_OPERATED` — inactivity timeout
19. `RTC_STATE_DATA` — RTC connection state

**MovingError enum values handled:**
1. `SDK_AUTH_TOKEN_FAILED`
2. `SDK_START_TOKEN_FAILED`
3. `SDK_RENEW_TOKEN_FAILED`

Network connectivity monitoring: `OnNetworkStatusChangedListener` — on reconnect calls `m5()`, `c5()`, `w4("onConnected")`; on disconnect calls `b5()`, `l5()`.

---

### §362 — CloudGameApi (WebSocket Endpoint)

`com/xj/cloud/config/CloudGameApi.java`

- Singleton `a`
- Default dev URL: `"wss://cloud.dev.movingcloudgame.com/"`
- `a()` method resolves environment-aware URL:
  - `ServerEnv.PRODUCT` → `"wss://sessions-saas.movingcloudgame.cn/"`
  - `ServerEnv.BETA` → `"wss://sessions-saas.movingcloudgame.cn/"`
  - Other → `"wss://cloud.dev.movingcloudgame.com/"`

---

### §363 — Cloud Game State Enums

**CloudGameState** (`com/xj/cloud/view/state/CloudGameState.java`):
- `Loading` (0)
- `InIdleQueue` (1) — queue with idle server availability
- `InFullQueue` (2) — queue with all servers busy
- `InQueue` (3) — in queue
- `Playing` (4) — active gaming session

**CloudLoadingState** (`com/xj/cloud/view/state/CloudLoadingState.java`):

| State | ordinal | weight |
|-------|---------|--------|
| `Pending` | 0 | 0 |
| `Authing` | 1 | 15 |
| `AuthSuccess` | 2 | 15 |
| `VerifySuccessThenEntering` | 3 | 20 |
| `VerifySuccessEnterCompleted` | 4 | 40 |
| `AllComplete` | 5 | 10 |

The `weight` field represents progress contribution toward 100% loading bar (total = 100).

---

### §364 — Cloud Game Data Entities

**AuthTokenEntity** (`com/xj/cloud/data/model/entity/AuthTokenEntity.java`):
- Fields: `token: String`, `payload: AuthPayload`, `code: int`
- `AuthPayload` inner class: `iss`, `aud`, `iat`, `exp`, `customer`, `type`, `user`, `queue`, `session`
  - Represents JWT payload for cloud auth token

**StartTokenEntity** (`com/xj/cloud/data/model/entity/StartTokenEntity.java`):
- Fields: `token: String`, `payload: StartPayload`, `code: int`
- `StartPayload`: `expire_in: int`, `queue_id: String`

**ReNewTokenEntity** (`com/xj/cloud/data/model/entity/ReNewTokenEntity.java`):
- Fields: `token: String`, `payload: ReNewPayload`
- `ReNewPayload`: `expire_in: int`, `last_deadline: int`, `deadline: int`

**StartQueueEntity** (`com/xj/cloud/data/model/entity/StartQueueEntity.java`):
- Fields: `isFreeTime`, `isFree`, `queueNumber`, `queueTime`, `inactiveTimeout` (default 30s), `fromType`, `freePlayTime`
- `@SerializedName` mappings: `free_play_time`, `inactive_timeout`, `is_free`, `is_free_time`, `queue_number`, `queue_time`
- `fromType` constants: `FROM_TYPE_LOTTERY=0`, `FROM_TYPE_QUEUE=1`, `FROM_TYPE_LOTTERY_ERROR=2`
- On `queryQueue` response: `fromType` forcibly set to `1` (FROM_TYPE_QUEUE)

**UserTimeEntity**: single field `expire_in: int`

---

### §365 — CloudGameInfoRepository (API Endpoints)

`com/xj/cloud/data/repository/CloudGameInfoRepository.java`

All requests use POST with `UserManager.INSTANCE.getToken()` for auth.

| Method | Endpoint | Parameters | Response |
|--------|----------|------------|----------|
| `getAutoToken` | `cloud/game/auth_token` | token, session, user (uid), app_id | `AuthTokenEntity` |
| `getStartToken` | `cloud/game/start_token` | game_id, token, session | `StartTokenEntity` |
| `getReNewToken` | `cloud/game/renew_token` | lastDeadline, queue_id, token, session | `ReNewTokenEntity` |
| `exitGame` | `cloud/game/exit` | token, session | `Unit` |
| `checkUserTimer` | `/cloud/game/check_user_timer` | token | `UserTimeEntity` |
| `queryQueue` | `cloud/game/getQueueInfo` | token | `StartQueueEntity` |

Error handling: all methods accept error callbacks; `queryQueue` logs `"请求排队接口异常"` and invokes block with `null` on exception.

---

### §366 — PcStream Module (`com.xj.module_pcstream`) — Moonlight/Sunshine Protocol

The PcStream module is a Moonlight-compatible PC game streaming client built around the **Sunshine/NVIDIA GameStream** protocol.

**Key integration: Limelight library (`com.streaming.*`):**
- `ComputerManagerService` / `ComputerManagerService.ComputerManagerBinder` — computer discovery
- `ComputerDetails` — remote PC details (uuid, name, etc.)
- `PairingManager` — PIN-based pairing
- `NvHTTP` — HTTP client for NVIDIA/Sunshine server
- `ServerHelper` / `ShortcutHelper`
- `AppView.class` — activity to launch a game stream
- `AndroidCryptoProvider` — RSA crypto for pairing
- `PlatformBinding` — platform-specific bindings

**PcView** (`com/xj/module_pcstream/activity/limelight/PcView.java`):
- `DefaultLifecycleObserver` attached to host activity
- Manages `ServiceConnection` to `ComputerManagerService`
- Wraps `ComputerManagerBinder` for computer discovery callbacks
- `Companion.a(context, computer, newPair, showHiddenApps)` → starts `AppView` with computer UUID

**StartPcStream** (`com/xj/module_pcstream/utils/StartPcStream.java`):
- Data class: `appId: String` (default `"881448767"`), `appHdr: Boolean`, `computerDetails: ComputerDetails?`
- Default appId `"881448767"` is a hardcoded app/game identifier for PC streaming launch
- Serialized to JSON and stored in SharedPreferences key `"pc_stream_last_pair_<uid>"`

**PcStreamHelper** (`com/xj/module_pcstream/utils/PcStreamHelper.java`):
- SP file: `"pc_stream_values_helper"`
- `j(appId, appHdr, computerDetails)` — saves `StartPcStream` to SP and broadcasts `HomePCOrPsDeviceChangeEvent(true)`
- `e()` — clears last paired computer

**PcStreamSettingVM** (`com/xj/module_pcstream/vm/PcStreamSettingVM.java`):

39 lists of `PcSettingItemEntity`/`PcSettingTitleEntity` covering all streaming settings:
- **Resolution**: 480P (854×480), 720P, 1080P, 1440P
- **FPS**: 30, 60, 90
- **Video pacing modes**: latency, balanced, cap-fps, smoothness
- **Audio**: stereo, 5.1 surround, 7.1 surround
- **Video format**: auto, forceav1, forceh265, neverh265
- **Gamepad**: analog scroll axis (none/right/left), deadzone 7.0, driver, Android gamepad, gamepad-as-mouse, vibration, trigger swap
- **Input**: touchscreen-as-trackpad, D-pad as mouse, touchpad mouse remote desktop
- **UI**: PiP mode, small icons, transparent overlay (50%), performance stats, session latency report
- **Advanced**: HDR, full dynamic range (experimental), unlock all frames, lower refresh rate, disable error prompts, PC audio

**PcStreamShareVM**: Stub `BaseViewModel` — no additional fields.

**Setting categories** (8 categories, IDs 1-8):
1. Basic, 2. Audio, 3. Gamepad, 4. Input, 5. On-screen controls, 6. Host, 7. UI, 8. Advanced

---

### §367 — Steam Database Layer (`SteamDB` + `SteamPicsDB`)

**SteamDB** (`com/xj/standalone/steam/data/db/SteamDB.java`):
- `@Database` Room database with `@TypeConverters`
- 3 DAOs: `SteamUserDao`, `SteamDownloadDao`, `SteamUserGamesDao`
- Singleton via `Companion.a(cont)` (async) / `Companion.b()` (sync)
- `Mutex c` for concurrent access protection

**SteamPicsDB** (`com/xj/standalone/steam/data/db/SteamPicsDB.java`):
- Separate Room database for Steam PICS data
- 5 DAOs: `SteamDepotDecryptionKeyDao`, `SteamPackageLicenseDao`, `SteamPicsAppDao`, `SteamPicsEntryDao`, `SteamPicsPackageDao`
- Migrations: `SteamDBMigration_1_2`, `_2_3`, `SteamPicsDBMigration_3_4`

**SteamUserTable** (Room `@Entity`):

| Column | Type | Notes |
|--------|------|-------|
| `id` | `Long?` | `@PrimaryKey` (nullable = autoincrement) |
| `steamId` | `long` | 64-bit Steam ID |
| `accountName` | `String` | login username |
| `refreshToken` | `String?` | JWT refresh token |
| `accessToken` | `String?` | JWT access token |
| `newGuardData` | `String?` | Steam Guard device token |
| `personalName` | `String?` | display name |
| `avatarUrl` | `String?` | avatar image URL |
| `isCurrentUser` | `Boolean` | active account flag |
| `isRemember` | `Boolean` | remember-me flag |
| `modifyTime` | `long` | `System.currentTimeMillis()` on save |
| `extras` | `Map<String, String>` | arbitrary extra data |

**SteamUserDao** key operations:
- `getAllUsers(): List` — all accounts
- `i(): Flow` — reactive account list stream
- `l(accountName): SteamUserTable?` — lookup by username
- `m()` — clear all currentUser flags
- `updateCurrentUser(table/accountName)` — marks account as active + notifies `SteamAPI.J()`
- `removeAccount(table)` — deletes + auto-promotes next account as current
- `upsertUser(table)` — insert-or-update with timestamp

**SteamDownloadDao** — 14 methods for `SteamModuleDownloadEntity`:
- `d(entity)` — insert (returns row id)
- `j(appId, depotId, sizeDownloaded, sizeTotal)` — update progress
- `m(appId, depotId, bytesRead, bytesWritten, sizeTotal, status)` — full progress update
- `k(appId, depotId)` — get download record
- `f()` — get all downloads
- `l(appId)` — delete by appId
- `b(appId, depotId)` / `g(appId, depotId)` / `i(appId, depotId)` — status updates

**SteamPicsAppInfo** (`com/xj/standalone/steam/data/db/tables/apps/SteamPicsAppInfo.java`):

| Column | Type |
|--------|------|
| `appId` | `int @PrimaryKey` |
| `name` | `String` |
| `type` | `String` |
| `iconId` | `String?` |
| `clientIconId` | `String?` |
| `lastUpdateTime` | `long` |
| `extras` | `Map<String, String>` |

Additional PICS table files: `SteamPicsAppAchievement`, `SteamPicsAppAgeRatings`, `SteamPicsAppInfoCategory`, `SteamPicsAppInfoGenres`, `SteamPicsAppInfoLocalizedAssets`, `SteamPicsAppInfoStoreTag`, `SteamPicsAppLastPlayedTime`, `SteamPicsAppPrice`, `SteamPicsAppTopAchievement`, `SteamPicsPackageInfo`, `SteamPicsPackageInfoGrantedApp`, `SteamPicsPackageInfoGrantedDepot`, `SteamPackageLicense`, `SteamPicsAppEntry`, `SteamPicsPackageEntry`.

---

### §368 — Steam Login ViewModel

`com/xj/module/steam/account/login/SteamLoginViewModel.java`

Fields:
- `a: MMKV` — persistent credential storage
- `b: String` — MMKV key for username
- `c: String` — MMKV key for password
- `d: CompletableFuture` — 2FA code future (blocks login until code entered)
- `e: String` — current pending 2FA code
- `f: MutableLiveData` — login step/state indicator
- `g: MutableLiveData` — QR code URL
- `h: MutableLiveData` — email 2FA request trigger
- `i: MutableLiveData` — device 2FA (TOTP) request trigger
- `j: MutableLiveData` — login progress message
- `k: MutableLiveData<LoginResult>` — final login result
- `l: IAuthenticator` — authenticator interface (see §354)
- `m: List` — list of login coroutine jobs
- `n: AtomicBoolean` — prevents duplicate login attempts

**Error code mapping** (`ErrorCode` enum):
- `Cancelled` → toast `steam_login_fail_cancel` + reset step to 0
- `InvalidPassword` → toast `steam_invalid_password_tips`
- `FileNotFound` → toast `steam_auth_file_bot_found_tips` + reset step to 0
- Other → formatted toast `steam_login_fail_msg` with error code

`A()` — retrieves saved credentials from MMKV as `Pair<username, password>`.

**LoginResult** (`com/xj/module/steam/account/bean/LoginResult.java`):
- Fields: `success: Boolean`, `isQRCode: Boolean`

---


---

## §369–§372: ADB/Inject Module, BhDownloadService, GameHubPrefs

---

### §369 — XjaInjectControlKt / ADB Activation Entry Points

`com/xj/adb/wifiui/XjaInjectControlKt.java`

Top-level Kotlin file — entry points for ADB WiFi activation + inject control:

- `i(context)` — initializes `EggGameHttpConfig` with context, then `InjectActivationUtils` with package name
- `j(context)` — launches `AdbActivationActivity`
- `k(context)` — launches `DeveloperOptionsActivity`
- `getMapping()` API endpoint: `EggGameHttpConfig.a.a() + "devices/getMapping"`
- Cloud config API: `https://clientgsw.vgabc.com/clientapi/` with params `action=cloud_vtouch_active_config`, `channel=gamehub_zh`

**HttpConfig** (`com/xj/adb/wifiui/http/HttpConfig.java`):
- Base URL: `GameHubPrefs.getEffectiveApiUrl("https://landscape-api.vgabc.com/")`
- OkHttpClient: 30s connect/read/write timeouts
- Cache: 128MB
- Interceptors: `PersistentCookieJar`, `LogRecordInterceptor`, `TokenInterceptor`, `GsonConverter`

**SelectActivationTypeActivity** (`com/xj/adb/wifiui/ui/SelectActivationTypeActivity.java`):
- Two activation paths:
  - Step 1 → `DeveloperOptionsActivity` (USB path)
  - Step 2 → `UsbOptionsActivity` (USB options)
- "Sure" button → `v1()` which checks `ExtKt.b() && ExtKt.e()`, then → `AdbActivationActivity`
- Float menu: close button (finish)
- `step1` view updates via `OptionsEntityMapping.getStepState()`

---

### §370 — AdbActivationActivity / XiaoJi Inject Subsystem

**AdbActivationActivity** (`com/xj/adb/wifiui/ui/AdbActivationActivity.java`):
- Imports: `com.xiaoji.wifi.adb.*`, `ShizukuSettings`, `XiaoJiUtils`, `org.lsposed.hiddenapibypass.HiddenApiBypass`
- 6-digit pairing code input stored in `ArrayDeque`
- `G2()` — validates exactly 6 digits, then starts `AdbPairingService`
- Field `download_failure_count` tracks download failure count

**InjectCloudCfgInfo** (`com/xiaoji/inject/data/InjectCloudCfgInfo.java`):

| Field | Obfuscated | Type |
|-------|-----------|------|
| `status` | `a` | String |
| `msg` | `b` | String |
| `title` | `c` | String |
| `channel` | `d` | String |
| `app_ver` | `e` | String |
| `ser_ver` | `f` | String |
| `is_cloud` | `g` | boolean |
| `files` | `h` | List |

**InjectActivationUtils** (`com/xiaoji/inject/utils/InjectActivationUtils.java`):
- Inject assets: `inject_1.xj`, `inject_2.xj`, `inject_3.xj`
- Decoded to: `xiaoji.bash`, `xjServer.jar`, `xjServer_a`
- Hidden directory: `/.xiaoji`; log file: `xiaoji_log.txt`
- `l(dir, md5s)` — decodes files with MD5 hash verification; returns error code on mismatch

**InjectActivationUtils status code table**:

| Code | Method |
|------|--------|
| 0 | `l` |
| 1 | `m` |
| 2 | `n` |
| 3 | `o` |
| 4 | `p` |
| 5 | `q` |
| 6 | `r` |
| 7 | `s` |
| 8 | `t` |
| 9 | `u` |
| 10 | `v` |
| 11 | `w` |
| 12 | `x` |
| 13 | `y` |
| 14 | `z` |
| 15 | `A` |
| 16 | `B` |

---

### §371 — BhDownloadService (Epic/Amazon/GOG Game Downloads)

`app/revanced/extension/gamehub/BhDownloadService.java`

Foreground Android `Service` managing game downloads for 3 stores.

**Actions / Intent extras**:
- `bh.download.START` — begin download
- `bh.download.CANCEL` — cancel download
- `EXTRA_GAME_ID` — game identifier key

**Stores supported**: `EPIC`, `AMAZON`, `GOG`

**Static state maps**:
- `activeJobs: Set` — currently running download job IDs
- `listeners: Map` — per-game listeners
- `cancelHandles: Map` — cancel function handles
- `gameNames: Map`, `gameStores: Map` — display data
- `lastMsgMap: Map`, `lastPctMap: Map` — last notification message/percentage per job

**Interfaces**:
- `DownloadListener` — `onCancelled()`, `onComplete()`, `onError(msg)`, `onProgress(pct, msg)`
- `GlobalListener` — 4 methods (global status callbacks)
- `CountObserver` — download count observer

**Per-store storage paths and SharedPreferences keys**:

| Store | Path | SP file |
|-------|------|---------|
| Epic | `<filesDir>/epic_games/<sanitizedName>/` | `"bh_epic_prefs"` |
| Amazon | `<filesDir>/Amazon/<sanitizedName>/` | `"bh_amazon_prefs"` |
| GOG | via `GogInstallPath.getInstallDir()` | `"bh_gog_prefs"` |

**Epic SP keys**: `"epic_dir_<appName>"`, `"epic_exe_<appName>"`, `"epic_manifest_version_<appName>"`
**Amazon SP keys**: `"amazon_dir_<productId>"`, `"amazon_exe_<productId>"`
**GOG SP keys**: `"gog_exe_<gogId>"`, `"gog_dir_<gogId>"`

**Library persistence** — SP file `"bh_library"`:
- Each game stored as: `"name\nstore\ninstallPath"` per entry
- `getLibrary(context)` parses all entries → `List<LibraryEntry>`

**Notifications**:
- Channel: `"bh_downloads"` ("BannerHub Downloads")
- `NOTIF_ID = 8800` (foreground service)
- `NOTIF_DONE_BASE = 8810` (per-game completion notifications)

---

### §372 — GameHubPrefs (API Source, SD Card Storage, Cache Management)

`app/revanced/extension/gamehub/prefs/GameHubPrefs.java`

SharedPreferences file: `"steam_storage_pref"`

**Custom settings IDs**:

| ID | Setting |
|----|---------|
| 24 | SD card storage path |
| 26 | API source selection |
| 27 | Log all HTTP requests |
| 28 | CPU usage display |
| 29 | Performance metrics display |

**API source system** — 3 backends:

| Source ID | Name | URL |
|-----------|------|-----|
| 0 | Official | passes through default URL |
| 1 | EmuReady | `https://gamehub-lite-api.emuready.workers.dev/` |
| 2 | BannerHub | `https://bannerhub-api.the412banner.workers.dev/` |

`getEffectiveApiUrl(str)` — source 0 returns `str`, source 1/2 return hardcoded URLs above.

**SD card storage**:
- `getEffectiveStoragePath(str)` — if custom storage enabled and path contains `/files/Steam`, replaces prefix with custom SD card path
- `autoDetectSDCardStorage()` — scans `getExternalFilesDirs(null)`, finds `GHL/` directory on SD card

**Cache management** — `clearComponentAndTokenCaches()` clears:
- `sp_winemu_all_components12`
- `sp_winemu_all_containers`
- `sp_winemu_all_imageFs`
- `pc_g_setting`
- `net_cookies`
- `TokenProvider.clearCache()`
- `CompatibilityCache.clear()`

**Startup behavior**: API source mismatch detected at launch → auto-clears all caches above.

`addCompatibilityHeaders()` — injects browser-like User-Agent + Accept + Accept-Language headers into OkHttpClient via reflection.

---

---

## §373–§384: ReVanced Extension — TokenProvider, Auth Clients, CDN, Metrics, Settings Exporter

---

### §373 — TokenProvider (3-tier Token Cache + Bypass Logic)

`app/revanced/extension/gamehub/token/TokenProvider.java`

**Token service endpoint**: `https://gamehub-lite-token-refresher.emuready.workers.dev/token`
**Force-refresh endpoint**: `...emuready.workers.dev/refresh` (POST with `{"token":"..."}`)
**Auth header**: `X-Worker-Auth: gamehub-internal-token-fetch-2025`
**Cache TTL**: 4 hours (`CACHE_TTL_MS = 14400000`)
**SP file**: `"token_provider_pref"`, keys `cached_token` + `cached_token_expiry`

**Static flags**:
- `apiSwitchPatched = true` — EmuReady API source bypass active
- `loginBypassed = true` — login-free token service active

**`resolveToken(str)` logic**:
1. If `apiSwitchPatched` AND `isExternalAPI()` (SP `use_external_api`) → return `"fake-token"`
2. If `loginBypassed` → call `getServiceToken(str)`
3. Otherwise → pass through original token

**`getServiceToken(str)` — 3-layer cache**:
- L1: `AtomicReference<CachedToken>` (in-memory)
- L2: SharedPreferences (`token_provider_pref`)
- L3: HTTP fetch from EmuReady token service
- On all-layer miss: stale L1, stale L2, original token, or last-resort `"fake-token"`

**`refreshTokenForOfficialApi()`** (called by `TokenRefreshInterceptor.j()`):
- Clears cache, fetches fresh from service
- If new token == current token → POST to `/refresh` endpoint to force new one
- Stores in `UserManager.setToken()` via reflection (`com.xj.common.user.UserManager`)
- Returns `null` if `loginBypassed=false` (defers to original OkHttp flow)

**`getCurrentAppToken()`** — reflection to `UserManager.INSTANCE.getToken()`

---

### §374 — EpicAuthClient (Epic Games OAuth)

`app/revanced/extension/gamehub/EpicAuthClient.java`

**Client credentials** (hardcoded):
- `CLIENT_ID = "34a02cf8f4414e29b15921876da36f9a"`
- `CLIENT_SECRET = "daafbccc737745039dffe53d94fc76cf"`
- `USER_AGENT = "UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"`

**Endpoints**:
- `TOKEN_URL = "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token"`
- `EXCHANGE_URL = "https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange"`

**Methods**:
- `exchangeCode(code)` → `postToken("grant_type=authorization_code&code=" + code + "&token_type=eg1")`
- `refreshToken(refresh)` → `postToken("grant_type=refresh_token&refresh_token=" + refresh + "&token_type=eg1")`
- `getExchangeCode(accessToken)` → GET `EXCHANGE_URL` with Bearer, returns `code` field
- `getRequest(url, token)` — GET with Bearer + User-Agent, 30s timeout
- `getBytes(url, token)` — raw bytes, 120s read timeout

**`TokenResult`** fields: `accessToken`, `refreshToken`, `accountId`, `displayName`, `expiresAt`

**ISO 8601 parser**: `parseIso8601(str)` — custom Zeller-formula date-to-epoch-ms without standard library.

---

### §375 — AmazonAuthClient (Amazon Games PKCE Device Auth)

`app/revanced/extension/gamehub/AmazonAuthClient.java`

**Constants**:
- `DEVICE_TYPE = "A2UMVHOX7UP4V7"` (AGSLauncher device type)
- `APP_NAME = "AGSLauncher for Windows"`
- `OS_VERSION = "10.0.19044.0"`
- `USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"`

**Endpoints**:
- `REGISTER_URL = "https://api.amazon.com/auth/register"`
- `REFRESH_URL = "https://api.amazon.com/auth/token"`
- `DEREGISTER_URL = "https://api.amazon.com/auth/deregister"`

**`registerDevice(authCode, codeVerifier, deviceSerial, clientId)`**:
- Builds device registration JSON with `DeviceLegacy` client domain, PKCE verifier, SHA-256
- Requests bearer + mac_dms tokens + customer_info + device_info extensions
- Returns `RegisterResult{accessToken, refreshToken, expiresIn}`

**`refreshAccessToken(refreshToken)`**:
- POST to `REFRESH_URL` with `x-amzn-identity-auth-domain: api.amazon.com` header
- Returns updated `RegisterResult` (keeps original `refreshToken`)

**`deregisterDevice(accessToken)`** — POST to `DEREGISTER_URL` with `customer_info` + `device_info` extensions.

---

### §376 — GogTokenRefresh (GOG Token Refresh)

`app/revanced/extension/gamehub/GogTokenRefresh.java`

**Token URL prefix** (hardcoded credentials!):
```
https://auth.gog.com/token?client_id=46899977096215655&client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9&grant_type=refresh_token&refresh_token=
```

**`refresh(context)`**:
- Reads `refresh_token` from SP `"bh_gog_prefs"`
- GET to `TOKEN_URL_PREFIX + refreshToken`
- Parses `access_token` + `refresh_token` from JSON via `GogLoginActivity.parseJsonStringField()`
- Updates SP: `access_token`, `refresh_token`, `bh_gog_login_time`, `bh_gog_expires_in=3600`

---

### §377 — SteamCdnHelper (Steam CDN URL Resolution with Batching)

`app/revanced/extension/gamehub/network/SteamCdnHelper.java`

**CDN URLs**:
- Primary CDN: `https://cdn-library-logo-global.bigeyes.com/`
- Fallback CDN: `https://shared.steamstatic.com/store_item_assets/`
- Steam Store API: `https://api.steampowered.com/IStoreBrowseService/GetItems/v1/`
- Default header fallback: `...steam/apps/{appId}/header.jpg`

**Cache**: SP file `"steam_cdn_cache"`, keys `"url_{appId}"` + `"exp_{appId}"`, TTL 7 days (604800000ms)

**`resolveHeaderUrl(appId)`**:
1. L1 in-memory `ConcurrentHashMap<Integer, String>`
2. L2 SharedPreferences (checks expiry)
3. Queues appId for batched fetch → returns default fallback URL immediately
- Batch size: 50 appIds per API call
- Batch delay: 150ms from first queue entry
- Daemon thread name: `"steam-cdn"`

**`fetchBatchFromSteamApi(ids)`** — sends `input_json={"ids":[{appid:N},...], "context":{"language":"english","country_code":"US"}, "data_request":{"include_assets":true}}`

**`rewriteCdnUrl(str)`** — rewrites bigeyes CDN URLs to Steam fallback CDN path.

---

### §378 — PlaytimeHelper (Steam Playtime via SQLite Reflection)

`app/revanced/extension/gamehub/playtime/PlaytimeHelper.java`

**Database paths** (direct SQLite access, bypassing Room):
- `xj_steam_db` → table `steam_account`, query `SELECT id FROM steam_account WHERE is_current_user = 1 LIMIT 1`
- `xj_steam_pics_v5` → table `t_steam_user_pics_app_last_played_times`, query:
  `SELECT app_id, playtime_forever, playtime2weeks FROM ... WHERE user_id = ? AND playtime_forever > 0 ORDER BY playtime2weeks DESC, playtime_forever DESC`

**Reflection target**: `com.xj.game.entity.RecentGameEntity`
- Field `a` (`steamAppid`) → set to `String.valueOf(appId)`
- Field `d` (`totalSeconds`) → `playtime_forever * 60` (DB stores minutes)
- Field `e` (`last14Days`) → `playtime2weeks * 60`

Returns `List<RecentGameEntity>` or `null` if no data.

---

### §379 — PerformanceMetricsHelper + DeviceMetrics

**PerformanceMetricsHelper** (`app/revanced/extension/gamehub/ui/PerformanceMetricsHelper.java`):
- Refresh interval: 1000ms (1Hz)
- Metrics displayed: CPU%, GPU%, RAM
- Uses `WeakReference<TextView>` for CPU, GPU, RAM text views
- Gate: `GameHubPrefs.isPerfMetricsEnabled()` (setting ID 29)
- Stops refresh loop if all `WeakReference`s go null

**DeviceMetrics** (`app/revanced/extension/gamehub/util/DeviceMetrics.java`):
- CPU cache: 500ms, reads via `Process.getElapsedCpuTime()` delta over wall-clock delta
- GPU sysfs probe order:
  1. `/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage` (Qualcomm %, format 0)
  2. `/sys/class/kgsl/kgsl-3d0/gpubusy` (Qualcomm busy/total, format 1)
  3. `/sys/kernel/gpu/gpu_load` (Samsung %)
  4. `/sys/devices/platform/*/gpu/utilisation` or `.../utilization` (Mali)
  5. `/sys/class/mpgpu/utilization` (Amlogic)
- RAM: `ActivityManager.MemoryInfo.totalMem` / `.availMem`, reported in GB

---

### §380 — GHLog (Logging Tags)

`app/revanced/extension/gamehub/util/GHLog.java`

Enum with prefix `"GHL/"` — logcat tags:

| Enum | Tag |
|------|-----|
| `TOKEN` | `GHL/Token` |
| `PREFS` | `GHL/Prefs` |
| `BATTERY` | `GHL/Battery` |
| `GAME_ID` | `GHL/GameId` |
| `CURRENCY` | `GHL/Currency` |
| `COMPAT` | `GHL/Compat` |
| `FILE_MGR` | `GHL/FileMgr` |
| `STORAGE` | `GHL/Storage` |
| `NET` | `GHL/Net` |
| `CDN` | `GHL/CDN` |
| `CPU` | `GHL/CPU` |
| `PERF` | `GHL/Perf` |
| `PLAYTIME` | `GHL/Playtime` |

---

### §381 — CompatibilityCache / AccountCurrencyHelper / BatteryHelper

**CompatibilityCache** (`app/revanced/extension/gamehub/ui/CompatibilityCache.java`):
- `ConcurrentHashMap<String, Object>` in-memory cache keyed by `steamAppId`
- `clear()` — empties map (called by `GameHubPrefs.clearComponentAndTokenCaches()`)
- `getOrBuildCompat(obj)` — reflection: calls `obj.getCst_data()`, if null looks up cache by `obj.getSteamAppId()`, then builds `GameCompatibilityParams(title, icon, desc, level, [])` via reflection to `com.xj.common.service.bean.GameCompatibilityParams`

**AccountCurrencyHelper** (`app/revanced/extension/gamehub/ui/AccountCurrencyHelper.java`):
- Static `sCurrency: String` — current user currency string
- `setCurrency(str)` — flushes all pending `WeakReference<TextView>` labels (account + game price)
- `updateLabel(textView)` — sets "Account (XXX)" or queues for when currency available
- `updateGamePriceLabel(view)` — finds sibling `TextView` in parent and updates "Game Price (XXX)"

**BatteryHelper** (`app/revanced/extension/gamehub/ui/BatteryHelper.java`):
- `updateBatteryText(imageView, percent)` — finds sibling `tv_battery_percent` by resource ID, sets `"N%"`

**GameIdHelper** (`app/revanced/extension/gamehub/ui/GameIdHelper.java`):
- `populateGameId(activity)` — reads `steamAppId` + `localGameId` from intent extras
- Shows `ll_game_id_container` view if either ID valid
- `setupCopyableText()` — click-to-copy for both ID TextViews with clipboard toast

---

### §382 — BhStoragePath (Store-agnostic Storage Routing)

`app/revanced/extension/gamehub/BhStoragePath.java`

- `getStoreBase(context, storeName)`:
  - If SP `"steam_storage_pref"`.`"use_custom_storage"` + non-empty `"steam_storage_path"` → `<customPath>/bannerhub/<storeName>/`
  - Otherwise → `<filesDir>/<storeName>/`
- `getInstallDir(context, storeName, gameName)` → `getStoreBase(...) + gameName/`

---

### §383 — BhSettingsExporter (Config Export/Import/Community Sharing)

`app/revanced/extension/gamehub/BhSettingsExporter.java`

**Version constant**: `BH_VERSION = "3.5.0"`
**Local export dir**: `<ExternalStorage>/BannerHub/configs/` (`.json` files)
**Frontend export dir**: `<Downloads>/bannerhub/frontend/`
**Worker base**: `https://bannerhub-configs-worker.the412banner.workers.dev`

**Config JSON structure**:
```json
{
  "meta": {"app_source":"bannerhub", "device":"...", "soc":"...", "bh_version":"3.5.0", "upload_token":"<hex>", "settings_count":N, "components_count":N},
  "settings": { <SP key→value map from "pc_g_setting<gameId>"> },
  "components": [ {"name":"...", "url":"...", "type":"..."} ]
}
```

**Component SP keys tracked**: `pc_ls_DXVK`, `pc_ls_VK3k`, `pc_set_constant_94`, `pc_set_constant_95`, `pc_ls_GPU_DRIVER_`, `pc_ls_CONTAINER_LIST`, `pc_ls_steam_client`

**Worker API endpoints**:
- `POST /upload` — `{game, filename, content:<base64>, upload_token}`; response `{success, sha}`
- `GET /list?game=<name>` — returns JSON array of community configs
- `GET /download?game=<folder>&file=<filename>` — download specific config

**SOC detection** (`detectSoc()`):
1. SP `"device_info"`.`"gpu_renderer"`
2. `/sys/class/kgsl/kgsl-3d0/gpu_model`
3. `Build.SOC_MODEL` (API 31+) or `Build.HARDWARE`

**`typeNameToInt()`** — component type to int mapping:

| Type | Int |
|------|-----|
| `"GPU"` | 10 |
| `"VKD3D"` | 13 |
| `"Box64"` | 94 |
| `"FEXCore"` | 95 |
| default (DXVK etc) | 12 |

**Frontend export formats**: `Beacon` (`.iso`), `ES-DE` (`.steam`)

**Missing component flow**: on import, compares required components against `"banners_sources"` SP; if missing, downloads from component URL, calls `ComponentInjectorHelper.injectComponent()` via reflection.

---

### §384 — BhWineLaunchHelper (Wine Process Inspection + Launch)

`app/revanced/extension/gamehub/BhWineLaunchHelper.java`

**`findWineBinary()`** — scans `/proc/*/comm` for `wineserver`, `wine64-preload`, or `wineloader`, follows `/proc/*/exe` symlink to get binary dir, tries `wine64`, `wine`, `wineloader`, `wine64-preloader`.

**`getWinePrefix()`** — reads `WINEPREFIX` env var from running Wine process `/proc/*/environ`.

**`getWineEnviron()`** — reads full environment (64KB max) from first `.exe` process in `/proc`.

**`launchExe(context, path)`** — background thread: `Runtime.exec([wineBinary, exePath], wineEnviron, null)`

**`isLaunchable(name)`** — true if `.exe`, `.msi`, `.bat`, `.cmd`

**`listDir(path)`** — sorted directory listing (dirs first with `/` suffix, then files alphabetically).

---

---

## §385–§393: ReVanced Credential Stores, Store API Clients, File Manager, Auth UIs

---

### §385 — EpicCredentialStore / AmazonCredentialStore

**EpicCredentialStore** (`app/revanced/extension/gamehub/EpicCredentialStore.java`):
- SP file: `"bh_epic_prefs"`
- Keys: `access_token`, `refresh_token`, `account_id`, `display_name`, `expires_at`
- `getValidAccessToken(context)` — auto-refreshes if `expiresAt - now < 300s` (5 min)
- `isLoggedIn(context)` — checks non-empty access_token

**AmazonCredentialStore** (`app/revanced/extension/gamehub/AmazonCredentialStore.java`):
- Storage: JSON file at `<filesDir>/amazon/credentials.json`
- Fields: `access_token`, `refresh_token`, `device_serial`, `client_id`, `expires_at`
- `getValidAccessToken(context)` — auto-refreshes via `AmazonAuthClient.refreshAccessToken()` if < 5 min remaining
- `save()/load()/clear()/isLoggedIn()`

---

### §386 — EpicApiClient (Epic Games Catalog/Manifest API)

`app/revanced/extension/gamehub/EpicApiClient.java`

**User-Agent**: `"Legendary/0.1.0 (GameNative)"`

**Endpoints**:
- `LIBRARY_URL = "https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true"` — paginated with `cursor=` param
- `CATALOG_BASE = "https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace"`
- `MANIFEST_BASE = "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace"`

**`getLibraryItems(accessToken)`** — paginates through library, filters for Windows platform games, excludes `namespace="ue"`, `namespace="89efe5924d3d467c839449ab6ab52e7f"`, and `sandboxType="PRIVATE"`.

**`getManifestApiJson(token, namespace, catalogItemId, appName)`** → `GET .../namespace/{ns}/catalogItem/{id}/app/{name}/label/Live` with Legendary UA; returns `{manifests:[...], versionId:"..."}`

**`getInstallSize(token, game)`** — sums `chunkInfo.windowSize || chunkInfo.fileSize` across all unique chunks.

---

### §387 — AmazonApiClient (Amazon Gaming Library/Download API)

`app/revanced/extension/gamehub/AmazonApiClient.java`

**User-Agents**:
- Gaming API: `"com.amazon.agslauncher.win/3.0.9202.1"`
- Download: `"nile/0.1 Amazon"`

**Hardcoded key**: `KEY_ID = "d5dc8b8b-86c8-4fc4-ae93-18c0def5314d"`

**Endpoints**:
- `ENTITLEMENTS_URL = "https://gaming.amazon.com/api/distribution/entitlements"`
- `DISTRIBUTION_URL = "https://gaming.amazon.com/api/distribution/v2/public"`
- `SDK_CHANNEL_URL = "https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346"`

**`getEntitlements(accessToken, deviceSerial)`** — paginated; filters by `hardwareHash = SHA256_UPPER(deviceSerial)`; operation `GetEntitlements`, clientId `"Sonic"`, `X-Amz-Target` header.

**`getGameDownload(accessToken, entitlementId)`** → returns `{downloadUrl, versionId}`.

**`getLiveVersionId(accessToken, productId)`** → returns version string from `GetLiveVersionIds` operation.

**`postGaming()`** pattern: `Content-Encoding: amz-1.0` header, `X-Amz-Target` per operation.

---

### §388 — AmazonPKCEGenerator

`app/revanced/extension/gamehub/AmazonPKCEGenerator.java`

- `generateDeviceSerial()` — `UUID.randomUUID()`, no dashes, uppercase
- `generateClientId(deviceSerial)` — hex-encode bytes of `"<serial>#A2UMVHOX7UP4V7"`
- `generateCodeVerifier()` — 32 random bytes → Base64url (no padding)
- `generateCodeChallenge(verifier)` — SHA-256 → Base64url
- `sha256Upper(str)` — SHA-256 hex uppercase (used as hardwareHash)

---

### §389 — GOG Authentication Flow

**GogLoginActivity** (`app/revanced/extension/gamehub/GogLoginActivity.java`):
- WebView loads `AUTH_URL = "https://auth.gog.com/auth?client_id=46899977096215655&redirect_uri=https%3A%2F%2Fembed.gog.com%2Fon_login_success%3Forigin%3Dclient&response_type=token&layout=client2"`
- UA: `"Mozilla/5.0 (Windows NT 10.0; Win64; x64) GOG Galaxy/2.0"`
- Intercepts redirect to `https://embed.gog.com/on_login_success` → parses `access_token`, `refresh_token`, `user_id` from fragment
- POST-login: fetches `https://embed.gog.com/userData.json` for username
- Saves to SP `"bh_gog_prefs"`: `access_token`, `refresh_token`, `user_id`, `username`, `bh_gog_login_time`, `bh_gog_expires_in=3600`

**GogInstallPath** — delegates to `BhStoragePath.getInstallDir(context, "gog_games", gameName)`

---

### §390 — MTDataFilesProvider (DocumentsProvider for App Data)

`app/revanced/extension/gamehub/filemanager/MTDataFilesProvider.java`

Extends `DocumentsProvider` — exposes app's internal/external storage via Android Storage Access Framework (SAF).

**Document ID roots** (prefixed by package name):
- `data/` → `context.getFilesDir().getParentFile()`
- `android_data/` → external files dir parent
- `android_obb/` → OBB dir
- `user_de_data/` → `/data/user_de/` equivalent

**Security bypass**: `attachInfo()` clears `mReadPermission` + `mWritePermission` via reflection on `ContentProvider`.

**Custom SAF methods** (`call()`):
- `mt:createSymlink` — creates symlink via `Os.symlink()`
- `mt:setLastModified` — sets file mtime
- `mt:setPermissions` — chmod via `Os.chmod()`

**Extra columns**: `mt_path` (real filesystem path), `mt_extras` (JSON metadata)
**Symlink detection**: `(Os.lstat(path).st_mode & S_IFMT) == S_IFLNK` (S_IFLNK = 40960)

---

### §391 — StorageBroadcastReceiver

`app/revanced/extension/gamehub/steam/StorageBroadcastReceiver.java`

Listens for package-internal broadcasts:
- `<packageName>.SET_STEAM_STORAGE` + `path` extra → `GameHubPrefs.setStoragePath(path)`; if not yet enabled, calls `toggleStorageLocation()`
- `<packageName>.USE_INTERNAL_STORAGE` → `GameHubPrefs.useInternalStorage()`

---

### §392 — BhDownloadsActivity (Download Manager UI)

`app/revanced/extension/gamehub/BhDownloadsActivity.java`

- Native `Activity` (no framework)
- Registers as `BhDownloadService.GlobalListener` for `onAnyProgress(jobId, gameName, msg, pct)`
- `rows: ConcurrentHashMap<String, View[]>` — active download rows `[ProgressBar, TextView]`
- `completedRows: ConcurrentHashMap` — finished download rows
- Cancel button per row calls `BhDownloadService.cancelDownload(jobId)`

---

### §393 — BhGameConfigsActivity (Community Config Browser)

`app/revanced/extension/gamehub/BhGameConfigsActivity.java`

4-screen flow:
1. `screenGames` — game list with search + SOC filter bar
2. `screenConfigs` — configs for selected game
3. `screenDetail` — config JSON detail + vote button + comments
4. `screenUploads` — user's own uploaded configs

**Worker API**: `https://bannerhub-configs-worker.the412banner.workers.dev`
**SP files used**: `"bh_steam_covers"`, `"bh_config_reports"`, `"bh_config_uploads"`, `"bh_config_votes"`

**Steam cover art**: `https://cdn.akamai.steamstatic.com/steam/apps/%s/header.jpg`
**Steam search**: `https://store.steampowered.com/api/storesearch/?l=english&cc=us&term=`

SOC detection: same 4-step chain as `BhSettingsExporter.detectSoc()`.

---

---

## §394–§398: XiaoJi Socket/Inject/Echo/ADB/BLE/WeChat Subsystems

---

### §394 — InjectSocketUtils + UdpClientSocket (IPC to xjServer)

`com/xiaoji/inject/utils/InjectSocketUtils.java`
`com/xiaoji/inject/socket/UdpClientSocket.java`

**IPC endpoint**: UDP `localhost:62573` (bidirectional with `xjServer`)

**InjectSocketUtils** — singleton with 3 thread pool executors:
- `b` (send), `c` (receive loop), `d` (write)

**Commands sent to server**:
- `"getVer/"` — request current xjServer version
- `"quit/done"` — graceful shutdown

**Messages received from server** (parsed in `g(data)`):
- `"getVer:"` → version string callback
- `"hiddata"` → `InjectServiceReceiveCallback.c(data)` (raw HID data passthrough)
- `"SERVICE_VERSION:<N>"` → `a(int)` callback
- `"START_KEY_STATE:<bool>"` → `b(bool)` callback
- `"TOP_PACKAGE:<name>"` → `e(String)` callback (foreground app package)
- `"OPEN_CLOSE_KEYBOARD_EDITVIEW"` → `d()` callback (keyboard toggle)

**UdpClientSocket**:
- Receive buffer: 1024 bytes
- `d(host, port)` — blocking UDP receive, returns String
- `e(host, port, data)` — UDP send
- `c(host, port)` — checks if port is bound (server alive)
- Singleton via static `SingletonLoader`

---

### §395 — EchoHelper (Touch Coordinate Translation)

`com/xiaoji/module/echo/EchoHelper.java`

- Translates screen touch coordinates to HID touch point format (0-4095 normalized)
- `a(context, x, y)` — inverts coordinates based on rotation (rotation 3: swap/invert x)
- `b(context, x, y)` — normalizes to `[0, 4095]` grid
- `c(context, actionType, x, y, pointerId)` → `TouchPointData(id+1, state, normX, normY)`
  - action 0→press (1), action 1→release (0), action 2→move (1)
- `d(x, y, normX, normY)` → `"echoTouch/<x>,<y>,<normX>,<normY>"` command string

---

### §396 — JieLi OTA Manager (BLE Firmware Update)

`com/xiaoji/jieliota/OtaManager.java`

Extends `com.jieli.jl_bt_ota.impl.BluetoothOTAManager` (JieLi BLE OTA SDK).

**`DeviceFilter`** inner class:
- Fields: `a` (device name prefix), `b` (MAC address), `c` (service UUID), `e` (device type int)
- `c(mac)` — computes DFU mode MAC by incrementing 5th octet (e.g. `AA:BB:CC:DD:EE:FF` → `AA:BB:CC:DD:EF:FF`)
- `d(device)` — validates by name and MAC match

Dependencies: `BleManager` (custom), `com.jieli.jl_bt_ota` (Jie Li OTA library), `SendBleDataThread`, `BleEventCallback`

---

### §397 — WeChat Pay Integration

`com/xiaoji/egggame/wxapi/WXPayEntryActivity.java`

- Implements `IWXAPIEventHandler` (Tencent WeChat Open SDK)
- WXAPI initialized with `PayApi.a.a()` (WeChat app ID)
- `onResp()` result codes:
  - `errCode=0` → `PayEvent(0)` on EventBus channel (success, logged "支付成功")
  - `errCode=-1` → `PayEvent(-1)` (failure, "支付失败")
  - `errCode=-2` → `PayEvent(-2)` (user cancelled, "用户取消")
- Two `WXPayEntryActivity` variants: `com.xiaoji.egggame.wxapi` and `com.xiaoji.egggame.logitech.wxapi`

---

### §398 — AdbPairingService (WiFi ADB Auto-Pair)

`com/xiaoji/wifi/adb/AdbPairingService.java`

- Foreground `Service`, API 30+
- `AdbMdns c` — mDNS discovery for ADB pair/connect services
- `Handler a` — main-thread handler for UI/notification updates
- `MutableLiveData b` — pairing state live data
- Depends on: `InjectActivationUtils`, `AdbUtils`, `SPUtils`, EventBus `MessageEvent`/`ErrMessageEvent`

**ShizukuSettings** (`com/xiaoji/wifi/utils/ShizukuSettings.java`):
- Uses `createDeviceProtectedStorageContext()` for pre-unlock SP access
- SP file: `"settings"` (device-protected)

---

---

## §399–§413: Launcher ViewModels, Service Interfaces, Compatibility Beans

---

### §399 — ILandscapeLauncherNavService Interface

`com/xj/common/service/ILandscapeLauncherNavService.java`

Navigation service interface (TheRouter service, resolved by `TokenRefreshInterceptor` on token expiry):

| Method | Description |
|--------|-------------|
| `f()` | Return `Intent` |
| `g()` | Navigate (unknown target) |
| `i(context, onDone)` | Check guide step |
| `j(activity, gameId, gameName, pkgName, onDone, removeListener)` | Remove/uninstall game flow |
| `k(activity, gameDetailEntity, onDone, removeListener)` | Remove/uninstall from entity |
| `m()` | Navigate (unknown) |
| `n()` | Navigate to re-login (called on token refresh failure) |
| `o()` | Navigate (unknown) |
| `q(context, str1, str2, str3)` | Navigate with 3 params |
| `u(str)` | Navigate with single string param |
| `a(activity, i1, i2)` | Activity navigation with ints |
| `b(activity, i, jumpParam, f)` | Jump with param + float |
| `c()` → Boolean | State check |
| `d(context, imageView)` | Load image |
| `r(activity, newsId, source, topImageUrl, view)` | News navigation |

---

### §400 — GameDetailVM (Game Detail ViewModel)

`com/xj/landscape/launcher/vm/GameDetailVM.java`

**Fields**:
- `a: MutableLiveData<Boolean>` — loading state (init false)
- `b: UnPeekLiveData` — one-shot event bus
- `c: GameDetailRepository` — data repository
- `d: MutableLiveData` — game detail entity
- `e: MutableLiveData` — secondary state
- `g: Map<LauncherTypeEnum, IGameHeadEntityDecorator>` — per-launcher-type decorators:
  - `START_TYPE_STEAM_GAME_BY_PC_EMULATOR` → `SteamGameDecorator`
  - `START_TYPE_PC_EMULATOR` → `PcDemoGameDecorator`

**Key methods**:
- `C(id, i, str, str2, str3, i2, str4, str5, i3)` — launch/start game (9 params + coroutine launch)
- `E(id, i, str, str2, str3, i2, str4, str5)` — alternate game entry point
- `H(str, str2)` — handle two string params
- `I(pkgName, loadGHData)` — check if game imported, callback with GH data
- `O(headEntity)` → Boolean — check entity state
- `P(context, packetName, i)` → Boolean — check package
- `L(), M(), N()` → `LiveData` — three observable streams
- `Q()` → `MutableLiveData`
- `R(str)` → Boolean — query by string
- `U(str, continuation)` — coroutine op with string
- `V(entity1, entity2, continuation)` — coroutine op with two `GameDetailEntity` args
- `W(i)` — update with int

---

### §401 — GameCompatibilityParams (Game Compatibility Rating Bean)

`com/xj/common/service/bean/GameCompatibilityParams.java`

Kotlin data class (`@SerializedName` on all fields):

| Field | Type | Serialized Name |
|-------|------|----------------|
| `title` | `String` | `"title"` |
| `icon` | `String` | `"icon"` |
| `desc` | `String` | `"desc"` |
| `level` | `int` | `"level"` |
| `data` | `List<GameCompatibilityItemParams>` | `"data"` |

Used in `CompatibilityCache.getOrBuildCompat()` — constructor called via reflection.

---

### §402 — Service Interfaces Inventory

Key service interfaces resolved via `TheRouter` / Koin:

| Interface | Key Methods |
|-----------|-------------|
| `ISteamGameService` | `a(cont)`, `b(id)`, `c..M(i/s, cont)` — game library + update ops |
| `ISteamGameDownloadService` | `a..i` — download start/pause/cancel/queue |
| `IPCStreamService` | `a()` stop, `b(cont)` start, `c(str)` set target |
| `IGameModuleService` | `a(str)`, `b(str, i, cont)`, `c()`, `d(str, cont)` |
| `IApkUpdateService` | APK self-update |
| `IWinEmuDownloadService` | WinEmu component downloads |
| `IWinEmuCallbackService` | WinEmu launch callbacks |
| `ISteamAuthService` | Steam auth helpers |
| `IMappingService` | Controller/button mapping |
| `IDeviceSettingService` | Device settings |
| `ICommunityNavService` | Community navigation |
| `IUserCenterNavService` | User center navigation |

---

### §403 — EggGameHttpConfig — Environment URL Resolution & Interceptor Stack

`com/xj/common/http/EggGameHttpConfig.java`

**Static URL selection logic:**
```java
static {
    if (Constants.a.c()) {                         // isTestEnv?
        str = "https://test-landscape-api.vgabc.com/";
    } else {
        ServerEnv env = companion.l();
        str = env == ServerEnv.PRODUCT ? "https://landscape-api.vgabc.com/"
            : env == ServerEnv.BETA    ? "https://landscape-api-beta.vgabc.com/"
            :                            "https://dev-gamehub-api.vgabc.com/";
    }
    b = GameHubPrefs.getEffectiveApiUrl(str);      // BH overrides Official/EmuReady/BH
}
```

**Interceptor stack (in order):**
1. `RemoveExtraSlashInterceptor` — strips double slashes from paths
2. `LogRecordInterceptor` — request/response logging
3. `PersistentCookieJar` — session cookie persistence
4. `EggGameTokenInterceptor` — injects token into every request
5. `TokenRefreshInterceptor` — 401-triggered token refresh + retry
6. `OfflineCacheInterceptor` — serves cached responses when offline

**Cache size:** 128 MB (`128 * 1024 * 1024` bytes).

---

### §404 — SteamUrlHelper — CDN URL Construction

`com/xj/common/utils/SteamUrlHelper.java`

**Icon URL pattern:**
```
https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/{appId}/{iconHash}
```

**Header/banner URL:** delegates to `SteamCdnHelper.resolveHeaderUrl(appId)`, which uses the bigeyes CDN with fallback to `shared.steamstatic.com`.

---

### §405 — LauncherTypeEnum — Complete Launch Type Constants

`com/xj/common/service/bean/LauncherTypeEnum.java`

**Launch type integer constants:**

| Constant | Value | Description |
|----------|-------|-------------|
| `START_TYPE_OPEN_URL` | 1201 | Open a URL |
| `START_TYPE_XBOX_CLOUD_GAMING` | 1202 | Xbox Cloud Gaming |
| `START_TYPE_HID_GAME` | 1301 | HID (inject) game |
| `START_TYPE_MOBILE_PLAY` | 1302 | Mobile game play |
| `START_TYPE_PSLINK` | 1401 | PS Link |
| `START_TYPE_PCLINK` | 1402 | PC Link |
| `START_TYPE_PC_EMULATOR` | 1403 | PC emulator (GH native) |
| `START_TYPE_MOVING_CLOUD_GAMING` | 1406 | Moving (Parsec-style) cloud |
| `START_TYPE_STEAM_GAME_BY_PC_EMULATOR` | 1407 | Steam game via Wine/FEX |
| `START_TYPE_STEAM_GAME_DETAIL_BY_WEB` | 1501 | Steam game detail (web) |
| `START_TYPE_MOBILE_INSTALL_APP` | 1502 | Install mobile app |
| `START_TYPE_LAUNCH_OTHER_APP` | 1001 | Launch external app |

**Legacy type group constants:**

| Constant | Value |
|----------|-------|
| `TYPE_XBOX` | 1 |
| `TYPE_PS_APP` | 2 |
| `TYPE_GOOGLE` | 3 |
| `TYPE_APP_STORE` | 4 |
| `TYPE_GEFORCE` | 5 |
| `TYPE_APPLE_ARCADE` | 6 |
| `TYPE_HID` | 7 |
| `TYPE_PC` | 8 |
| `TYPE_PS_REMOTE_PLAY` | 9 |
| `TYPE_MOBILE_PLAY` | 10 |
| `TYPE_EMU_PLAY` | 11 |
| `TYPE_PSLINK_PLAY` | 12 |

---

### §406 — AppLauncher — Dispatch Map (type → LaunchStrategy)

`com/xj/landscape/launcher/launcher/AppLauncher.java`

Singleton with a `CoroutineScope(SupervisorJob() + Dispatchers.Default)`. Maintains a static dispatch map registered at class-load time:

| Launch Type Value | Strategy Class |
|-------------------|----------------|
| 1 | `XboxLaunchStrategy` |
| 2 | `PsAppLaunchStrategy` |
| 3 | `GoogleStoreLaunchStrategy` |
| 7 | `HidLaunchStrategy` |
| 9 | `PsRemotePlayLaunchStrategy` |
| 10 | `MobilePlayLaunchStrategy` |
| 12 | `PsLinkLaunchStrategy` |
| 1001 | `OtherAppLaunchStrategy` |
| 1201 | `UrlLaunchStrategy` |
| 1202 | `XboxCloudLaunchStrategy` |
| 1301 | `HidLaunchStrategy` |
| 1302 | `MobilePlayLaunchStrategy` |
| 1401 | `PsLinkLaunchStrategy` |
| 1402 | `PcLinkLaunchStrategy` |
| 1403 | `GHPcEmuLaunchStrategy` |
| 1406 | `MovingCloudGameLaunchStrategy` |
| 1407 | `SteamGameByPcEmuLaunchStrategy` |
| 1501 | `SteamGameDetailLaunchStrategy` |
| 1502 | `MobilePlayLaunchStrategy` |

---

### §407 — SteamGameDetailLaunchStrategy

`com/xj/landscape/launcher/launcher/strategy/SteamGameDetailLaunchStrategy.java`

Opens the Steam store page for a game via the in-app router:
```java
String url = "https://store.steampowered.com/app/" + steamId;
PageRouterUtils.a.q(3, url);
```
No download or Wine launch — this is a pure web-view strategy for browsing store pages.

---

### §408 — SteamGameByPcEmuLaunchStrategy — Key Methods

`com/xj/landscape/launcher/launcher/strategy/SteamGameByPcEmuLaunchStrategy.java`

Orchestrates full Steam game launch through Wine emulation:

| Method | Signature (approx.) | Purpose |
|--------|----------------------|---------|
| `A` | `(DownloadTask task, Continuation cont)` | Execute download task |
| `n` | `(String gameId, Continuation cont)` | Initiate game launch by ID |
| `p` | `(String gameId, Function fn, Continuation cont)` | Launch with completion callback |
| `s` | `(LauncherConfig config, Function fn, Continuation cont)` | Launch with config + callback |
| `u` | `(String path) → Boolean` | Check if path/exe exists |
| `y` | `(GameInfo info, int i, Continuation cont)` | Launch with game info + mode |
| `z` | `(GameInfo info, Continuation cont)` | Launch with game info |
| `w` | `()` | Abort / cleanup current launch |

---

### §409 — Complete API URL Inventory (All Unique Endpoints)

Grep-verified unique API base URLs and endpoints across all 18 DEX source files:

**XiaoJi / GameHub official APIs:**
- `https://clientegg.vgabc.com/uxapi/` — UX/analytics events
- `https://clientgsw.vgabc.com/clientapi/` — cloud vtouch/inject config
- `https://statistic-gamehub-api.vgabc.com/events` — statistics event sink
- `https://landscape-api.vgabc.com/` — main launcher API (PRODUCT)
- `https://landscape-api-beta.vgabc.com/` — beta API
- `https://test-landscape-api.vgabc.com/` — test API
- `https://dev-gamehub-api.vgabc.com/` — dev API

**BannerHub / EmuReady override APIs:**
- `https://gamehub-lite-api.emuready.workers.dev/` — compat/component API (EmuReady source)
- `https://gamehub-lite-token-refresher.emuready.workers.dev/token` — token service
- `https://gamehub-lite-token-refresher.emuready.workers.dev/refresh` — force token refresh
- `https://bannerhub-api.the412banner.workers.dev/` — BannerHub API source
- `https://bannerhub-configs-worker.the412banner.workers.dev/` — community config worker

**Steam CDN / APIs:**
- `https://cdn-library-logo-global.bigeyes.com/` — bigeyes CDN (header images)
- `https://shared.steamstatic.com/store_item_assets/` — Steam assets fallback
- `https://store.steampowered.com/app/{id}` — Steam store web page
- `https://store.steampowered.com/IStoreBrowseService/GetItems/v1/` — Steam Store API
- `https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/{id}/{hash}` — Steam icons

**Epic Games APIs:**
- `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token` — auth token
- `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange` — exchange code
- `https://library-service.live.use1a.on.epicgames.com/library/api/public/items` — library items
- `https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace/...` — catalog
- `https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/...` — manifest

**Amazon Games APIs:**
- `https://api.amazon.com/auth/register` — device registration
- `https://api.amazon.com/auth/token` — token refresh
- `https://api.amazon.com/auth/deregister` — device deregistration
- `https://gaming.amazon.com/graphql` — GraphQL (entitlements/downloads/versions)

**GOG APIs:**
- `https://auth.gog.com/auth?client_id=46899977096215655&...` — OAuth login
- `https://auth.gog.com/token?client_id=...&client_secret=9d85c43b14...` — token refresh
- `https://embed.gog.com/on_login_success` — OAuth redirect intercept
- `https://embed.gog.com/userData.json` — username lookup

---

### §410 — LandscapeLauncherAppKt — App Initialization

`com/xj/landscape/launcher/LandscapeLauncherAppKt.java`

Top-level application initializer called on app start:

- `FileOperator`, `FFmpegConfig`, `ProcessLifecycleOwner`, `EmojiCompat` initialized
- `AdaptUtilsKt.b(resources)` — screen density adaptation on every activity
- Registers `BluetoothConnectionReceiver` for `ACL_CONNECTED`/`ACL_DISCONNECTED` events
- `DeviceManager.u(context)` — USB monitor init; on USB plug-in calls `DeviceManagementService.o.c(context, ...)`
- `GHSoundPlayHelper.a.a()` + `KeyOperationSoundPlayMonitor.a.e()` — key press sounds
- `GcmProtocol.Companion.getINSTANCE().init(true, AppUtils.g())` — GameSir GCM protocol
- `ShowMenuMonitor.a.b()` — float menu monitor
- `XjaInjectControlKt.i(context)` — ADB inject control init (see §369)
- `TYMovingManager` init for Moving Cloud Gaming (WSS URL=`""`, reconnect freq=60, server=`https://hubble.movingcloudgame.com/`)
- Deep link handlers registered: `GameDetailDeepLinkHandler`, `PlayCloudGameDeepLinkHandler`, `PlayPcEmuGameDeepLinkHandler`, `WebUrlDeepLinkHandler`, `UserInfoDeeplinkHandler`, `NewsDetailDeepLinkHandler`
- `ISteamService.a(AppConfig.a.q())` — Steam service init with build config value

---

### §411 — GhDeepLinkPageType — Deep Link Page Types

`com/xj/common/deeplink/GhDeepLinkPageType.java`

| Enum Name | Type String | Handler |
|-----------|-------------|---------|
| `MainPage` | `"main_page"` | `DefaultDeepLinkHandler` |
| `NewsDetail` | `"news_detail"` | `NewsDetailDeepLinkHandler` |
| `GameDetail` | `"game_detail"` | `GameDetailDeepLinkHandler` |
| `PlayPcEmuGame` | `"play_pc_emu_game"` | `PlayPcEmuGameDeepLinkHandler` |
| `PlayCloudGame` | `"play_cloud_game"` | `PlayCloudGameDeepLinkHandler` |
| `WebUrl` | `"web_url"` | `WebUrlDeepLinkHandler` |
| `UserInfo` | `"user_info"` | `UserInfoDeeplinkHandler` |

**AndroidManifest URI scheme:** `gamesir://gamehub` (line 81 of manifest)

---

### §412 — SdkConfig — Third-Party SDK Keys

`com/xj/common/config/SdkConfig.java`

All keys are environment-conditional (`isGamesirBuild` / `isTestEnv`):

**Firebase OAuth client ID:**
- GS build: `464226359755-hd93lt0ad68vaoqj9u6hteg97r6ij8gl.apps.googleusercontent.com`
- Default: `304891727788-1lqj59qoj25o37viksnkuacccc6jhgg8.apps.googleusercontent.com`

**JPush push notification:** `fdeb83da9ad2f3e16b983fde`

**Alibaba MobileAuth (one-click phone login) — production key (base64 RSA):**
```
cErzcYH9nP5jfNG0rOnhsLoAwD4KFQxGmfWthrKUPP6i6F0A1MqVkm7YLh9FPp9W
EJ3TsCmCyZSj60MGtKM1LY8PyxzoYX27Y8utIzrXRUgEF6PA4P1Eh7TNU3B0nGLU
...
```

**QQ OAuth:**
- Production App ID: `102667728`, Secret: `jQt9D4i8ICrKZbQA`
- GS build App ID: `102797136`, Secret: `73rTt8A4lCOYWIp9`

**Umeng analytics:**
- Production: `667a6196cac2a664de54975a`
- GS build: `6853d7ff79267e02108beb2c`

**WeChat OAuth:**
- Production App ID: `wx2075ef952b9b60c4`, Secret: `e7c8b599ef6eacd44857a83d15c81f63`
- GS build App ID: `wxf9d9756e4f820261`, Secret: `9481ffd7ce2ca099f224a17c67bda414`

---

### §413 — OneKeyAliHelper — Alibaba One-Click Phone Login

`com/xj/landscape/launcher/utils/OneKeyAliHelper.java`

Uses `com.mobile.auth.gatewayauth.PhoneNumberAuthHelper` SDK:

- Initialized with `SdkConfig.MobileAuth.a.a()` (RSA key above)
- `checkEnvAvailable(1)` — carrier network check
- `getLoginToken(context, i)` — initiates one-click login; returns token code `"600000"` on success
- `setAuthPageUseDayLight(false)` — dark theme forced
- Privacy URLs:
  - Personal Info: `https://www.xiaoji.com/url/gsw-app-rules`
  - Privacy Policy: `https://www.xiaoji.com/url/gsw-app-rules`

**UI event codes (700000-700011):**
- `700000` / `700010` / `700011` — back button variants → callback with result 0 (cancel)
- `700002` / `700003` — checkbox toggle (terms agreement)
- `700004` — privacy link tap
- Login button toast: `"同意服务条款才可以登录"` (must agree to terms)

---

### §414 — GuideLoginVM — Login View Model

`com/xj/landscape/launcher/vm/GuideLoginVM.java`

Three login methods (all use `AndroidScope` coroutine + error callback):
- `m(block)` — generic/phone login
- `o(openid, accessToken, block)` — QQ OAuth login
- `r(openid, unionId, accessToken, block)` — WeChat OAuth login

Each posts to the launcher API (path and params in obfuscated `GuideLoginVM$login$1`, `loginQQ$1`, `loginWeChat$1` lambdas).

---

### §415 — XboxWebActivity — Xbox Cloud Gaming WebView

`com/xj/bussiness/devicemanagement/XboxWebActivity.java`

Full-screen WebView activity for Xbox Cloud Gaming:
- `XGPConfigInfo` — Xbox Game Pass configuration (loaded on init)
- `mOnFunctionKeysListener` — physical button handler: `Companion.b()` (start key) → `S1()`, else `R1()`
- `static h` — back button flag; `static i` — start key flag (set via `Companion.c(z)`, read via `Companion.a()`)
- PiP (Picture-in-Picture) support via `PictureInPictureParams`
- `EventTracker.a.c(EventTracker.StartType.XBOX)` — telemetry on Xbox launch

---

### §416 — EventTracker — Statistics Telemetry

`com/xj/common/trace/EventTracker.java`

**Endpoints:**
- `POST https://statistic-gamehub-api.vgabc.com/events` — batch event posting (via `postEvents()`)
- `POST statistics/openTypeStatistics` — relative to base API; reports start type

**`StartType` enum:** `PS`=1, `PC`=2, `XBOX`=3  
**`StreamUsageReportType` enum:** `PS_CONNECTED_CARD_COUNT`, `PS_DISCONNECTED_CARD_COUNT`, `PS_MANUAL_CARD_ADDITION`, `PS_MANUAL_DISCOVER_ADDITION`, `PS_SETTINGS_CLICK_COUNT`  
**`UserActivityReportType` enum:** `START_PS_STREAM_SUCCESS`, `ACCOUNT_LOGIN_SUCCESS`, `NICKNAME_LOGIN_SUCCESS`, `PC_STREAM_USAGE_DURATION`, `PS_STREAM_USAGE_DURATION`

**openTypeStatistics body:** `{type: StartType.type, token: UserManager.getToken()}`

**postEvents body:**
```json
{"events": [{"event_type": "...", "user_id": "...", "data": {...}}, ...]}
```
**EventParam fields:** `a=event_type`, `b=data (Map)`, `c=user_id`

**Usage duration throttle:** Only reported if ≥ 60 seconds of use.

---

### §417 — MockUtilsKt — Hardcoded Mock Image URLs

`com/xj/landscape/launcher/data/mock/MockUtilsKt.java`

Static list of 50 hardcoded game banner image URLs used for UI preview/testing:
- `https://uxdl.bigeyes.com/ux-landscape/...` — XiaoJi bigeyes CDN (webp)
- `https://shared.cdn.queniuqe.com/store_item_assets/steam/apps/N/header.jpg` — XiaoJi Steam CDN mirror

Known Steam appIds embedded: 1174180, 289650, 614570, 1817070, 2283380, 2479320, 846110, 530130, 2891120, 2218400, 2198070, 1911360, 1689010, 1222690.

Note: `queniuqe.com` is a XiaoJi-operated CDN domain for Steam assets.

---

### §418 — SteamPageFragment — Embedded Steam WebView with CN DNS Override

`com/xj/landscape/launcher/ui/SteamPageFragment.java`

Embeds `store.steampowered.com` directly in a WebView for China region:

**Custom DNS override (`initOkHttpClientInCn`):**
- Fetches a list of IP addresses from `SteamWebViewModel.fetchIps()` (via API)
- For requests to `store.steampowered.com` → substitutes fetched IPs instead of system DNS
- Disables SNI for `store.steampowered.com` connections (sets `serverNames` → `["localhost"]` to bypass SNI matching)
- Installs a `trustAllCerts` `TrustManager` (accept-all X.509 for the custom OkHttpClient)

**`steammobile://` URI scheme:** Intercepted in `shouldOverrideUrlLoading` to handle Steam deep links.

**WebView intercept:** Uses `SteamUtil.a` to handle resource requests.

**Default URL if none provided:** `https://store.steampowered.com/`

---

### §419 — EpicCloudSaveManager — Epic Cloud Save Sync

`app/revanced/extension/gamehub/EpicCloudSaveManager.java`

**Base URL:** `https://datastorage-public-service-liveegs.live.use1a.on.epicgames.com/api/v1/access/egstore/savesync/`

**URL pattern:** `BASE + accountId + "/" + appName + "/"`

**Operations:** `uploadSaves(context, appName, localDir, callback)`, `downloadSaves(context, appName, localDir, callback)`, `listCloudFiles()`, `requestWriteLinks()`, `uploadFile()`, `downloadFile()`

**Debug log:** appends to `Environment.getExternalStorageDirectory()/bh_cloud_debug.txt`

**Thread naming:** `"epic-cloud-upload-<appName>"`, `"epic-cloud-download-<appName>"`

---

### §420 — GogCloudSaveManager — GOG Cloud Save Sync

`app/revanced/extension/gamehub/GogCloudSaveManager.java`

**Base URL:** `https://cloudstorage.gog.com/v1/`

**Operations:** `uploadSaves()`, `downloadSaves()`, `listCloudFiles()`, `getFile()`, `putFile()`

**Error handling:** `"CLOUD_SAVES_NOT_SUPPORTED"` → user-facing error `"This game does not support GOG cloud saves"`

**Thread naming:** `"gog-cloud-upload-<gameId>"`, `"gog-cloud-download-<gameId>"`

---

### §421 — GogDownloadManager — GOG Game Download Engine

`app/revanced/extension/gamehub/GogDownloadManager.java`

**GOG Content System API URLs:**
- Gen 2 builds: `https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=2`
- Gen 1 builds: `https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=1`
- Product download info: `https://api.gog.com/products/{gameId}?expand=downloads`

**Download priority:** Gen 2 → Gen 1 → installer fallback  
**Auth:** Bearer token passed when available; anonymous fallback for public metadata

---

### §422 — DeviceTypeConstants — GameSir Device Name Strings

`com/xiaoji/DeviceTypeConstants.java`

Comprehensive list of all supported GameSir BLE/USB device name prefixes (50+ entries):

Key entries: Gamesir-G5, G6, G4Pro, T6, X2, X2s, X3, G8, Nova, X4a-Xbox, GameSir-VX2, Tarantula Pro, LEADJOY M1C, DELUX-S2, GS-B05, SKY-001, OTA Device.  
Also includes DFU variants (firmware update mode names).

---

### §423 — WinEmu File Paths Constant

`com/xj/winemu/api/WinEmuFilePathsConstant.java`

All paths relative to `PathUtils.f()` (internal app files directory):

| Path Constant | Value |
|---------------|-------|
| `b` (base) | `<filesDir>` |
| `c` / `d` | `<filesDir>/xj_winemu` |
| `e` | `<filesDir>/xj_winemu/xj_downloads` |
| `f` | `<filesDir>/xj_winemu/xj_downloads_games` |
| `g` | `<filesDir>/xj_winemu/xj_install` |
| `h` | `<filesDir>/xj_winemu/xj_downloads_games/game` |
| `i` | `<filesDir>/xj_winemu/xj_downloads/env` |
| `j` | `<filesDir>/xj_winemu/xj_downloads/component` |
| `k` | `<filesDir>/xj_winemu/xj_downloads/sd` |
| `l` | `<filesDir>/xj_winemu/xj_install/game` |
| `m` | `<filesDir>/xj_winemu/xj_install/env` |
| `n` | `<filesDir>/xj_winemu/xj_install/component` |

**Game install path pattern:** `<filesDir>/xj_winemu/xj_install/game[/<version>]/<gameId>`

---

### §424 — ComponentType Enum (WinEmu)

`com/xj/winemu/api/bean/ComponentType.java`

| Name | Type Int |
|------|----------|
| `TRANSLATOR` | 1 |
| `GPU` | 2 |
| `DXVK` | 3 |
| `VKD3D` | 4 |
| `GENERAL` | 5 |
| `DEPENDENCY` | 6 |
| `STEAMCLIENT` | 7 |

---

### §425 — Box64TranslatorConfig — All Tunable Parameters

`com/xj/winemu/bean/Box64TranslatorConfig.java`

Serialized name → JSON key for the complete Box64 tuning config:

| Field | `@SerializedName` |
|-------|------------------|
| `alignedAtomics` | `AlignedAtomics` |
| `bigBlock` | `BigBlock` |
| `box64Avx` | `Box64AVX` |
| `callret` | `CallRet` |
| `cpuType` | `CpuType` |
| `df` | `DF` |
| `dirty` | `Dirty` |
| `div0` | `DIV0` |
| `dynaCacheMin` | `DynaCacheMin` |
| (more fields truncated by decompiler) | |

`BoxOptions` provides valid value ranges: most are `["0","1"]`, `BigBlock` adds `"2"` and `"3"` etc.

---

### §426 — PcSettingDefaultValue — Wine PC Emulator Defaults

`com/xj/winemu/api/bean/PcSettingDefaultValue.java`

| Constant | Value | Description |
|----------|-------|-------------|
| `b` | 1280 | Default resolution width |
| `c` | 720 | Default resolution height |
| `d` / `e` | 1 | Boolean flags (enabled) |
| `i` | true | DX feature flag |
| `j` | true | DX feature flag |
| `k` | 2 | Int setting (mode) |
| `l` | true | Boolean flag |
| `m` / `n` | 1 | Int settings |
| `p` | 1024 | Int (buffer/cache size) |
| `q` / `r` / `s` | true | Boolean flags |
| `g`, `h`, `o`, `t` | 0 | Zero defaults |

---

### §427 — WineActivity — Wine Emulator Activity

`com/xj/winemu/WineActivity.java`

The main Wine execution activity, extending `FocusableAppCompatActivity`.

**Key imports / subsystems:**
- `WinUIBridge h` — native Wine/X11 bridge
- `HUDUpdater i` — in-game HUD data updates
- `VirtualGamepadController A` — virtual gamepad overlay
- `GamepadManager z` — physical gamepad management
- `InputControlsManager v` — on-screen controls manager
- `X11View` — Xorg display surface
- `HUDLayer` — HUD rendering layer
- `HDREffect m`, `CASEffect n`, `CRTEffect o` — ReSHADE post-processing effects

**In-game settings (`WineInGameSettingType` enum):**

| Setting | Description |
|---------|-------------|
| `FullScreen` | Fullscreen toggle |
| `Hdr` | HDR/ReSHADE enable |
| `Crt` | CRT filter enable |
| `SuperResolution` | CAS super-resolution enable |
| `FpsLimit` | FPS limiter enable |
| `NativeRendering` | Native Vulkan rendering mode |
| `RedMagicPerformanceMode` | RedMagic device performance mode |

**Steam agent integration:** `SteamAgentStatus`, `StatusData`, `StatusLanguage` — real-time Steam client status display in HUD.

**PerfEventListener:** Feeds performance metrics to HUD via `HUDUpdater`.

---

### §428 — WinEmuServiceImpl — Wine Launch Parameters

`com/xj/winemu/service/WinEmuServiceImpl.java`

Full Wine launch parameter set (logged to `<filesDir>/pcLaunchLog/launchLog<gameId>.txt`):

| Parameter | Description |
|-----------|-------------|
| `language` | Display language |
| `start path` | Executable path to launch |
| `SteamId` | Steam app ID (if Steam game) |
| `GPU driver` | GPU driver name + bool flag |
| `base container path` | Wine prefix / container root |
| `launch args` | Command line arguments |
| `launch method` | Run mode (how Wine is invoked) |
| `env vars` | Additional environment variables |
| `isArm64X` | ARM64X binary flag |
| `HubType` | In-game HUD type selection |
| `Dxvk path` | DXVK DLL path + version |
| `vkD3D path` | VKD3D DLL path + version |
| `box64 translator path` | Box64 binary path |
| `fex translator path` | FEXCore binary path |
| `audioDriver` | Audio driver selection |
| `surfaceFormat` | Rendering surface format |
| `offlineMode` | Offline mode flag |
| `silentMode` | Silent launch (no UI) |
| `noVerifyFile` | Skip file verification |
| `cloudEnable` | Cloud save enabled |
| `steamInputEnable` | Steam Input enabled |
| `resolution` | Width × Height |
| `steam client` | fake=bool, steamD=path (fake client flag) |
| `steam user info` | Username + userId |
| `token` | Auth token for API calls |
| `steamAgent` | Steam agent binary path |
| `steam game info` | appId + libraryDir + gameDir |
| `mitmConfig` | MITM proxy config |
| `installScript` | Run install script flag |
| `cellId` | Cell ID (network cell) |
| `launchOption` | Launch option int |
| `enableOnScreenKeyboard` | On-screen keyboard flag |
| `cpuTranslatorConfig` | Box64/FEX config object |

---

### §429 — AppConfig — Build Flavors and Environment Detection

`com/xj/common/config/AppConfig.java` (interface + `Companion`)

**Flavor detection (based on `d()` = channel string from VasDolly):**
- `a()` → `true` if flavor contains `"logitech"` → Logitech G Cloud build
- `b()` → `true` if flavor contains `"googlePlay"` → Google Play Store build
- `c()` → `true` if channel = `"360"` or `"samsung"` → Samsung/360 distribution
- `e()` → `true` if flavor contains `"realme"` or package = `com.nearme.fusionplay` → Realme build
- `f()` → `true` if package = `com.xiaoji.egggame.redmagic` → RedMagic build
- `q()` → returns `isDebugMode` flag (static bool `c`)

**Channel name logic:** `k()` = channel string from `ChannelReaderUtil`; if empty defaults to `"google"` (googlePlay build), `"Official"`, or realme.

**Server environment:** `l()` → reads `AppPreferences.serverEnv` → `ServerEnv.PRODUCT/BETA/TEST`  
**Environment tag:** `m()` → `"release"` | `"pre"` | `"test"`

**Constants channel name** (used as API channel param):
- Package `com.xiaoji.egggame.redmagic` → `"gamehub_redmagic"`
- Package `com.xiaoji.egggame.logitech` → `"gamehub_logitech"`
- Default (including PUBG-disguised build) → `"gamehub_android"`

**`Constants.b`** = `true` initially (can be toggled by `d(bool)`)  
**`Constants.c()`** = `true` if RedMagic package (bypasses token intercept — see `TokenRefreshInterceptor.intercept()`)

---

### §430 — CloudGameApi — Moving Cloud Gaming WebSocket URLs

`com/xj/cloud/config/CloudGameApi.java`

**Default/dev WSS:** `wss://cloud.dev.movingcloudgame.com/`  
**Production/Beta WSS:** `wss://sessions-saas.movingcloudgame.cn/`  
**Hubble server:** `https://hubble.movingcloudgame.com/` (set in `TYMovingManager` init — see §410)

---

### §431 — ComponentDownloadActivity — BannerHub GPU Driver and Component Download UI

`com/xj/landscape/launcher/ui/menu/ComponentDownloadActivity.java` (not a Kotlin class; pure Java, no JADX metadata errors)

This is a custom `AppCompatActivity` that provides a dark-themed list UI for downloading GPU drivers and Wine emulator components from GitHub. It is the mechanism by which BannerHub ships its own component catalog to users independently of the host app update cycle.

**GitHub JSON catalog URLs fetched at runtime:**
| Fetch Function | URL |
|---|---|
| `startFetchGpuDrivers()` | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/kimchi_drivers.json` |
| `startFetchGpuDrivers()` | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/stevenmxz_drivers.json` |
| `startFetchGpuDrivers()` | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/mtr_drivers.json` |
| `startFetchGpuDrivers()` | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/white_drivers.json` |
| `startFetchPackJson()` | `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/nightlies_components.json` |
| `startFetchPackJson()` | `https://raw.githubusercontent.com/Arihany/WinlatorWCPHub/refs/heads/main/pack.json` |

**HTTP headers:** `User-Agent: BannerHub/1.0`, 15-second connect/read timeout.

**Component type detection via `detectType(name)`:**
- `"box64"` in name → type `94`
- `"fex"` in name → type `95`
- `"vkd3d"` in name → type `13`
- `"turnip"/"adreno"/"driver"/"qualcomm"` in name → type `10` (GPU driver)
- Default → type `12`

**Download field parsing:**
- GPU driver JSONs: uses `browser_download_url` field from GitHub releases API format
- Pack JSON (nightlies_components): uses `original_url` field
- Back-navigation: `mode=1` → show repos list; `mode=2` → show categories

---

### §432 — RegisterNicknamePSNActivity — PlayStation Network OAuth Login

`com/xj/psplay/ui/register/RegisterNicknamePSNActivity.java`

This activity handles PSN (PlayStation Network) account login for PS Remote Play pairing using an embedded WebView.

**OAuth authorize URL (hardcoded, line 382):**
```
https://auth.api.sonyentertainmentnetwork.com/2.0/oauth/authorize
  ?service_entity=urn:service-entity:psn
  &response_type=code
  &client_id=ba495a24-818c-472b-b12d-ff231c1b5745
  &redirect_uri=https://remoteplay.dl.playstation.net/remoteplay/redirect
  &scope=psn:clientapp
  &request_locale=<locale>
  &ui=pr
  &service_logo=ps
  &layout_type=popup
  &smcid=remoteplay
  &prompt=always
  &PlatformPrivacyWs1=minimal&
```

**SSL error handling:** Shows "SSL certificate verification failed" dialog with proceed/cancel options (insecure bypass).

**Flow after OAuth:**
1. WebView URL change intercepted by `shouldOverrideUrlLoading`
2. OAuth code extracted, passed to `RegisterNicknamePSNVM.getPSRedirectCode()` → POST `/ps5/get_ps5_user_by_code`
3. On success: launches `PinCodeActivity` with `psn` (encoded user ID), `hostsEntity`, `broadcast`
4. `EventTracker.ACCOUNT_LOGIN_SUCCESS` telemetry fired

**PS Target enum** (`com/xj/psplay/lib/Target.java`):
- `PS4_UNKNOWN` (value=0), `PS4_8` (800), `PS4_9` (900), `PS4_10` (1000)
- `PS5_UNKNOWN` (1000000), `PS5_1` (1000100)

---

### §433 — PS5 Remote Play API Endpoints

`com/xj/psplay/ui/register/vm/RegisterNicknamePSNVM.java`, `com/xj/psplay/ui/home/GuidePsDialogHotel.java`

All POST endpoints call the main landscape API server (base URL from `EggGameHttpConfig`):

| Endpoint | Method | Description |
|---|---|---|
| `/ps5/get_ps5_user_by_code` | POST | Convert OAuth code → PS user info (`PSInfoEntity`) |
| `/ps5/get_ps5_user` | POST | Get PS user by ID |
| `/ps5/get_ps5_connection_type` | POST | Get PS5 connection type (`ConnectTypeEntity`) |
| `/ps5/get_ps5_open_doc` | POST | Fetch guide/doc picture data for PS5 setup dialog |

**Registered Host persistence:** Stored in local Room DB (`RegisteredHostDao`). Fields: `target` (PS4/PS5 version), `serverMac`, `serverNickname`, `rpRegistKey`, `rpKeyType`, `rpKey`, `apSsid`, `apBssid`, `apKey`, `apName`.

---

### §434 — Comprehensive API Endpoint Inventory (Landscape API Server)

All endpoints below use `EggGameHttpConfig` base URL (default: `https://landscape-api.vgabc.com/`, overridable via `GameHubPrefs.getEffectiveApiUrl()`).

#### Auth / JWT
| Endpoint | Method |
|---|---|
| `/jwt/email/login` | POST |
| `/jwt/mobile/login` | POST |
| `/jwt/oneMobile/login` | POST (Alibaba one-key phone login) |
| `/jwt/third/login` | POST (QQ/WeChat OAuth) |
| `/jwt/logout` | POST |
| `/sms/send` | POST (send SMS verification code) |
| `/ems/send` | POST (send email verification code) |

#### User Profile
| Endpoint | Method |
|---|---|
| `/user/info` | POST (fetch or update user info) |
| `/user/updateUserNotice` | POST (notification preferences) |
| `/user/buildPcPin` | POST (generate PC pairing PIN) |
| `/user/mobileScanCode` | POST (mobile scan-code login report) |
| `/user/mobileConfirmCode` | POST (confirm scan-code login) |
| `/user/mobileCancelCode` | POST (cancel scan-code login) |
| `/profile` | GET/POST |
| `/profile/avatar` | POST (upload avatar) |
| `/profile/username` | POST (update username) |
| `/profile/mobile` | POST (update phone number) |
| `/bind/email` | POST |
| `/bind/mobile` | POST |

#### Game & Content
| Endpoint | Method |
|---|---|
| `/game/getTopPlatform` | POST (top games by platform for home screen) |
| `/game/searchGameList` | POST |
| `/game/searchCategoryList` | POST |
| `/game/searchClassifyList` | POST |
| `/game/searchTopCategoryList` | POST |
| `/game/getDnsPool` | POST (Steam DNS IP pool for CN WebView) |
| `/game/getDnsIpPool` | POST (alternate Steam DNS IP pool) |
| `/game/userVideoList` | POST |
| `/game/userVideoNum` | POST |
| `/game/userVideoReading` | POST (mark video as read) |
| `/game/userUploadsVideo` | POST |
| `/game/userDeleteVideo` | POST |
| `/game/likeVideo` | POST |
| `/game/cancelLikeVideo` | POST |

#### Social & Device
| Endpoint | Method |
|---|---|
| `/social/getRecommendation` | POST (friend suggestions from contacts) |
| `/social/userDeviceConnect` | POST (report USB device connect event) |
| `/devices/getDevices` | POST (get user's registered devices) |
| `/devices/getDevicesList` | GET (device whitelist) |
| `/devices/getDevicesMenu` | GET (device menu config) |

#### Virtual Touch / Controller Mapping (`vtouch`)
| Endpoint | Method |
|---|---|
| `/vtouch/startType` | POST (start type for vtouch mapping mode) |
| `/vtouch/vtouchGetConfig` | POST (fetch cloud keymap config) |
| `/vtouch/vtouchUploadConfig` | POST (save/backup local keymap to cloud) |
| `/vtouch/vtouchDetail` | POST (keymap detail) |
| `/vtouch/vtouchShare` | POST (share keymap publicly) |
| `/vtouch/vtouchShareSearch` | POST (search shared keymaps) |
| `/vtouch/vtouchRevoke` | POST (revoke shared keymap) |
| `/vtouch/vtouchDelConfig` | POST (delete cloud backup) |
| `/vtouch/getOfficial` | POST (get official/default keymaps) |
| `/doc/docVtouchList` | GET (fetch vtouch tutorial doc list) |

#### Upload, Media
| Endpoint | Method |
|---|---|
| `/uploads/uploadsImages` | POST (multipart image upload) |
| `/uploads/uploadsVideo` | POST (multipart video upload) |
| `/api/v1/mix/upload` | POST |
| `/api/v1/raw/upload` | POST |

#### Cloud Gaming
| Endpoint | Method |
|---|---|
| `/cloud/game/check_user_timer` | POST (check cloud gaming time balance) |

#### Feedback & Support
| Endpoint | Method |
|---|---|
| `/feedback/submitFeedback` | POST |
| `/feedback/submitFeedbackReply` | POST |

#### App Upgrade
| Endpoint | Method |
|---|---|
| `/upgrade/getAppUpgradeApk` | POST (check for app update APK) |

#### Home Screen
| Endpoint | Method |
|---|---|
| `/home` | GET/POST (home screen data) |
| `/home/components` | GET (Wine emulator components list) |
| `/home/steamuser` | GET (Steam user data) |
| `/home/virtual_containers` | GET (Wine containers list) |

---

### §435 — Mapping Module — MapDataSource API Operations

`com/xj/mapping/MapDataSource.java` (singleton `MapDataSource.a`)

The mapping module manages controller keymap configurations using a cloud-sync model. All paths resolve against the same landscape API base URL.

**Operations exposed:**
| Method | Path | Description |
|---|---|---|
| `K(pkg, callback)` → `getCloudConfigList` | `/vtouch/vtouchGetConfig` | Fetch all cloud keymap configs for a package |
| `N(id, callback)` → `getConfigDetail` | POST (path via `vtouch`) | Get single keymap detail |
| `R(pkg, callback)` → `getDefaultOfficial` | `/vtouch/getOfficial` | Fetch official/default keymaps |
| `V(callback)` → `getTutorial` | `/doc/docVtouchList` | Fetch keymap tutorial doc list |
| `Y(pkg, content, title, desc, callback)` → `shareConfig` | `/vtouch/vtouchShare` | Share keymap publicly |
| `c0(pkg, orderby, kw, page, size, callback)` → `touchShareSearch` | `/vtouch/vtouchShareSearch` | Search shared keymaps |
| `y(pkg, configlist, callback)` → `backupLocalConfig` | `/vtouch/vtouchUploadConfig` | Backup local config to cloud |
| `C(id, callback)` → `deleteBackUpConfig` | `/vtouch/vtouchDelConfig` | Delete cloud backup by ID |
| `G(id, callback)` → `deleteShareConfig` | `/vtouch/vtouchRevoke` | Revoke shared config by ID |

**Device routing:** All operations first call `MatchDeviceUtils.a.e()` to get the connected `DeviceItemEntity` (device type for filtering), then pass it to the actual network call.

---

### §436 — EmuComponents — Wine Component Refresh API

`com/xj/winemu/EmuComponents.java`

Fetches available Wine emulator components from the landscape API server. Components are cached in `SharedPreferences sp_winemu_all_components12`.

**API call:** GET `/home/components` with params `token`, `page=1`, `page_size=1000`  
**Response parsing:** JSON array of `EnvLayerEntity` objects (fields: `download_url`, component name, version, size, type)

**Component state machine:** `State.None` → `State.Downloading` → `State.Downloaded`  
**Storage:** `SharedPreferences` key = component name; value = Gson-serialized `ComponentRepo`

**`ComponentRepo.isDep()`**: if true, installs to `WinAPI.f.a().c()` (dependency directory); otherwise to `WinEmuFilePathsConstant` paths.

---

### §437 — Additional External URLs Discovered

The following external URLs were found in a broad scan that were not yet documented:

**Steam API (public, unauthenticated):**
- `https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1?appid=<appId>` — player count widget
- `https://store.steampowered.com/api/appdetails/?appids=<appId>` — game details from Steam store
- `https://store.steampowered.com/events/ajaxgetadjacentpartnerevents/?appid=<appId>` — Steam game news/events

**QQ / Tencent:**
- `https://graph.qq.com/user/get_user_info?access_token=<token>` — QQ user info after OAuth
- `https://release.nj.qq.com` — QQ SDK production server
- `https://test.nj.qq.com` — QQ SDK test server
- `https://trace.inlong.qq.com/hn0_iegcommon/dataproxy/message` — Tencent telemetry/analytics ingestion

**XiaoJi Doc/Help URLs:**
- `https://doc.xiaoji.com/help.html?lang=<lang>` — In-app help page
- `https://doc.xiaoji.com/selectdevice.html?lang=<lang>` — Device selection guide

**PlayStation Store (hardcoded):**
- `https://store.playstation.com/zh-cn/product/HP6245-PPSA02585_00-CNRELGENSHIN0000` — Hardcoded Genshin Impact PS Store link

**Xbox Cloud Gaming:**
- `https://www.xbox.com/play/...` — Xbox Cloud Gaming WebView target (see §XboxWebActivity)

**GameHub portal:**
- `https://gamehub.xiaoji.com` — Main GameHub web portal

---


### §438 — Cloud Gaming API Endpoints (Full Set)

`com/xj/cloud/data/repository/CloudGameInfoRepository.java`; paths discovered from smali. All resolve against landscape API base URL.

#### Session Lifecycle
| Endpoint | Method | Description |
|---|---|---|
| `cloud/game/auth_token` | POST | Initial auth token for cloud session |
| `cloud/game/start_token` | POST | Get token to start game |
| `cloud/game/renew_token` | POST | Renew expiring session token |
| `cloud/game/startQueue` | POST | Join cloud game queue |
| `cloud/game/confirmPlay` | POST | Confirm play from queue |
| `cloud/game/getQueueInfo` | POST | Poll queue position/status |
| `cloud/game/getQueueCalendar` | GET | Queue calendar (scheduled slots) |
| `cloud/game/exit` | POST | Exit cloud game session |
| `cloud/game/check_user_timer` | POST | Check user's remaining cloud time balance |

#### Content & Commerce
| Endpoint | Method | Description |
|---|---|---|
| `cloud/game/getNewsList` | GET | Cloud gaming news list |
| `cloud/game/getNewsDetail` | GET | News article detail |
| `cloud/game/get_goods_list` | GET | Cloud gaming purchase items/plans |
| `cloud/order/info` | GET | Order detail |
| `cloud/order_list` | GET | User order history |
| `cloud/payment` | POST | Initiate payment |
| `cloud/use_time_log` | GET | Usage time log |
| `cloud/h5/exchange_code` | POST | Redeem exchange code |

---

### §439 — Additional Game / Social / Statistics API Endpoints

Found via smali scan of all DEX classes.

#### Game APIs (additional)
| Endpoint | Description |
|---|---|
| `game/getIndexList` | Home screen game index list |
| `game/getClassify` | Game category/classify list |
| `game/videoGameList` | Video-associated game list |
| `game/getGameCircleList` | Game circle/community list |
| `game/getGameTopCategoryIdList` | Top-level category IDs |
| `game/checkIsCloudGame` | Check if a game supports cloud play |
| `game/checkLocalHandTourGame` | Check if a local hand-tour game is compatible |
| `game/getSteamHost` | Fetch Steam host/IP for CN routing |
| `game/userPlayedGame` | Report/update user's played game history |
| `game/cts/report` | CTS (compatibility test suite) result report |
| `jwt/refresh/token` | Refresh JWT token (existing, noted in TokenRefreshInterceptor) |

#### Social APIs (additional)
| Endpoint | Description |
|---|---|
| `social/getUserInfo` | Get another user's social profile |
| `social/deleteFriend` | Remove friend |
| `social/userNoticeList` | User notification/notice list |
| `social/userUpdateNotice` | Update notification read status |

#### Device APIs (additional)
| Endpoint | Description |
|---|---|
| `devices/getMapping` | Get device key mapping config |
| `devices/getUnknownDevices` | Report/fetch unknown device IDs |

#### Statistics / Telemetry
| Endpoint | Description |
|---|---|
| `statistics/openTypeStatistics` | Startup type stat (PS=1, PC=2, XBOX=3) |
| `statistics/activeUsersStatistics` | DAU/MAU reporting |
| `statistics/streamUsageStatistics` | Streaming usage duration reporting |

#### User (additional)
| Endpoint | Description |
|---|---|
| `user/getMobileCode` | Request mobile verification code |

#### Doc
| Endpoint | Description |
|---|---|
| `doc/docList` | Generic document list (separate from vtouch tutorial) |

---

### §440 — BannerHub Frontend Path Constants

Found in smali: `bannerhub/frontend/Beacon`, `bannerhub/frontend/ES-DE`

These are path suffixes used in the BannerHub backend worker URL (`https://bannerhub-configs-worker.the412banner.workers.dev`):
- `bannerhub/frontend/Beacon` — Fetch Beacon frontend launcher config
- `bannerhub/frontend/ES-DE` — Fetch ES-DE frontend launcher config  
- `bannerhub/frontend/` — Generic frontend prefix (also hardcoded in `BhSettingsExporter`)

These enable the BannerHub settings system to fetch or post different frontend launcher configurations to the Cloudflare Worker backend.

---


---

### §441 — Steam Client Module: Package Overview

`com/xj/standalone/steam/` — 200+ files; full JavaSteam-based Steam client implementation.

**Key singleton classes:**
| Class | Role |
|---|---|
| `SteamAPI` | Top-level facade; wraps login, license, download, account operations |
| `SteamSdk` | OkHttpClient factory; language detection; main coroutine scope |
| `SteamConfig` | Global configuration constants (thread counts, timeouts, server list provider) |
| `SteamDownloader` | Download manifest + content chunk downloader (depot decryption) |
| `SteamFilePaths` | Static file system path constants for Steam install tree |
| `SteamModuleConfig` | Stub config shim (returns empty string for any steamAppId) |

**`SteamConfig` constants:**
- `k = 24` (max parallel connections per host × denominator)
- `l = 20` (requests per host limit)
- `m = 60L` (connection pool keep-alive seconds)
- `n` = `Runtime.availableProcessors()` (CPU-derived thread count)
- Lazy `h` → `GHFileServerListProvider` backed by `<filesDir>/server_list.bin`

**`SteamFilePaths` path layout (relative to `<filesDir>`):**
```
steam_download_cache/          ← chunk download staging
steam_download_cache/manifest/ ← manifest blobs
Steam/                         ← Steam root
Steam/steamapps/               ← installed games
Steam/steamapps/common/        ← game binaries
Steam/steamapps/config/        ← VDF config files
Steam/steamapps/config/steam_input/config/  ← controller config .vdf files
Steam/steamapps/app_info/      ← app info cache
steam_games/                   ← secondary game root
```

---

### §442 — SteamApiUrls: CN-Aware URL Builder

`com/xj/standalone/steam/sdk/SteamApiUrls.java`

Singleton at `SteamApiUrls.a`. All methods check `SteamSdk.a.v() instanceof LanguageName.Chinese` and branch to CN endpoints.

| Method | URL Template |
|---|---|
| `f()` — base URL | CN: `https://store.steamchina.com` / non-CN: `https://api.steampowered.com` |
| `d(int appId)` | `{base}/api/appdetails?appids={appId}&filters=ratings` |
| `e(int appId)` | `https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1?appid={appId}` |
| `b(int appId, types, count)` | `https://store.steampowered.com/events/ajaxgetadjacentpartnerevents/?appid={appId}&count_before=0&count_after={count}[&event_type_filter={codes}[&lang_list=6_0 for CN]]` |

**`SteamEventType` enum** (passed to `b()` as `types`):
- `MajorVersionUpdate` → code `13`
- `MinorVersionUpdate` → code `12`

---

### §443 — SteamSdk: OkHttpClient Configuration

`com/xj/standalone/steam/sdk/SteamSdk.java`

**`createOkHttpClient(boolean withDnsOverride)`:**
- `withDnsOverride=true`: injects custom DNS resolution:
  - `isStoreHost(hostname)` → resolves to `store.steampowered.com` IP
  - `isApiHost(hostname)` → resolves to `api.steampowered.com` IP
  - (via `SteamIPs.h()` and `SteamIPs.g()` - see §444)
- SSL: custom `SSLSocketFactory` + `X509TrustManager` that trusts all certs
- `HostnameVerifier`: always returns `true` (no hostname validation)
- User-Agent interceptor: adds `"Valve/Steam HTTP Client 1.0"` to every request
- Timeouts: `connectTimeout=20000ms`, `readTimeout=20000ms`, `writeTimeout=20000ms`
- `Dispatcher.maxRequests = SteamConfig.k * 3 = 72`
- `Dispatcher.maxRequestsPerHost = SteamConfig.l = 20`
- `ConnectionPool(SteamConfig.k * 2 = 48 connections, 60s)`
- Two lazy instances: `f` (no DNS override), `g` (with DNS override)

**User-Agent injection** (static method `k(chain)`):
```java
chain.proceed(chain.request().newBuilder()
    .header("User-Agent", "Valve/Steam HTTP Client 1.0")
    .build())
```

---

### §444 — SteamIPs: DNS Override for Steam Hosts

`com/xj/standalone/steam/SteamIPs.java`

`DnsEntry` data class: `(url_address: String, ip_address: String)`. SteamIPs holds two sets of DNS entries (for store and API hosts) loaded via configuration.

**`SteamIpStateInterceptor`** (inner class):
- `isApiHost(hostname)` — detects `api.steampowered.com`
- `isStoreHost(hostname)` — detects `store.steampowered.com`
- DNS lookup returns override IP from loaded entries, bypassing system DNS

**`GHFileServerListProvider`** (`com/xj/standalone/steam/core/GHFileServerListProvider.java`):
- Reads `<filesDir>/server_list.bin` (protobuf `BasicServerListProtos.BasicServerList`)
- Provides Steam CM (connection manager) server list to the JavaSteam client
- Used by `SteamConfig.h` lazy property

---

### §445 — Steam MITM Proxy Config (Embedded JSON)

Critical embedded JSON string constant found in smali, used to configure the app's HTTPS interception/proxy routing for Steam traffic:

```json
{
  "intercept": ["api.steampowered.com"],
  "rules": [
    {
      "match": "*.steampowered.com;steampowered.com;*.steamcommunity.com;steamcommunity.com",
      "target": "steamstore.rmbgame.net",
      "remove_sni": true
    },
    {
      "match": "steamcdn-a.akamaihd.net;steamuserimages-a.akamaihd.net;cdn.akamai.steamstatic.com;avatars.akamai.steamstatic.com;store.akamai.steamstatic.com",
      "target": "steamimage.rmbgame.net",
      "remove_sni": true
    },
    {
      "match": "community.steamstatic.com",
      "target": "community.steamstatic.com",
      "remove_sni": false
    },
    {
      "match": "media.steampowered.com",
      "target": "steammedia.rmbgame.net",
      "remove_sni": true
    },
    {
      "match": "*.st.dl.eccdnx.com",
      "target": "cdn.queniuqe.com",
      "remove_sni": true
    }
  ]
}
```

**Summary of proxy targets:**
| Original domain(s) | Proxy target | SNI removed |
|---|---|---|
| `*.steampowered.com`, `*.steamcommunity.com` | `steamstore.rmbgame.net` | Yes |
| Steam Akamai CDN (images, store assets) | `steamimage.rmbgame.net` | Yes |
| `community.steamstatic.com` | `community.steamstatic.com` (pass-through) | No |
| `media.steampowered.com` | `steammedia.rmbgame.net` | Yes |
| `*.st.dl.eccdnx.com` (China CDN) | `cdn.queniuqe.com` | Yes |

Additional Steam smali string constants: `https://store.steampowered.com/app/%s`, `https://store.steampowered.com/mobile`, `https://store.steampowered.com/`, `com.valvesoftware.android.steam.community`.

---

### §446 — SteamCdnHelper (ReVanced Extension)

`app/revanced/extension/gamehub/network/SteamCdnHelper.java`

**Purpose:** Batch-fetch Steam game header image URLs via `IStoreBrowseService` and cache them locally.

**Constants:**
- `BIGEYES_CDN_BASE = "https://cdn-library-logo-global.bigeyes.com/"`
- `CDN_FALLBACK_BASE = "https://shared.steamstatic.com/store_item_assets/"`
- `STORE_API_URL = "https://api.steampowered.com/IStoreBrowseService/GetItems/v1/"`
- `CACHE_TTL_MS = 604800000` (7 days)
- `BATCH_SIZE = 50`, `BATCH_DELAY_MS = 150ms`
- `PREFS_NAME = "steam_cdn_cache"` (SharedPreferences)

**Flow:**
1. `resolveHeaderUrl(appId)` — check L1 in-memory cache, then L2 SharedPreferences cache
2. If miss: add appId to `fetchQueue`; schedule batch via single-thread `executor` after 150ms
3. `processBatch()` → `executeBatch()` → `fetchBatchFromSteamApi(ids)` → GET `IStoreBrowseService/GetItems/v1/?input_json={...}`
4. Request body: `{"ids":[{"appid":X},...], "context":{"language":"english","country_code":"US"}, "data_request":{"include_assets":true}}`
5. Parses `asset_url_format` + `header` field from response; constructs final URL
6. Fallback URL: `https://shared.steamstatic.com/store_item_assets/steam/apps/{appId}/header.jpg`

**CDN URL rewriting** (`rewriteCdnUrl()`):
- `steam/...` → `CDN_FALLBACK_BASE + path`
- `bigeyes.com/...` → `CDN_FALLBACK_BASE + suffix`

---

### §447 — SteamUrlHelper: Avatar URL Builder

`com/xj/standalone/steam/wrapper/utils/SteamUrlHelper.java`

**`b` flag** (default `true`): controls which CDN to use for avatars.

| Method | URL |
|---|---|
| `c(hash)` — Akamai | `https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/{hash[0:2]}/{hash}_full.jpg` |
| `c(null)` — Akamai fallback | `https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg` |
| `d(hash)` — Cloudflare | `https://avatars.cloudflare.steamstatic.com/{hash}_full.jpg` |
| `d(null)` — Cloudflare fallback | `https://avatars.cloudflare.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg` |
| `a(hash)` | routes to `d()` if `b=true`, else `c()` |
| `b(bytes)` | hex-encodes hash bytes then calls `a()` |
| `e(appId, str)` | delegates to `SteamCdnHelper.resolveHeaderUrl(appId)` |

**`EnvironmentConstants.a(appId, filename)`:** `https://shared.cloudflare.steamstatic.com/store_item_assets/steam/apps/{appId}/{filename}`

---

### §448 — BhGameConfigsActivity: Config Worker Full API

`app/revanced/extension/gamehub/BhGameConfigsActivity.java`

Worker base: `https://bannerhub-configs-worker.the412banner.workers.dev`

**Full endpoint list:**
| Endpoint | Method | Description |
|---|---|---|
| `/games` | GET | List all games (optional `?refresh=1`) |
| `/list?game={game}` | GET | List configs for a specific game (optional `&refresh=1`) |
| `/download?game={g}&file={f}` | GET | Download a config file (optional `&sha={sha}`) |
| `/vote` | POST | Vote on a config (returns updated vote count) |
| `/report` | POST | Report a config |
| `/comments?game={g}&file={f}` | GET | Fetch comments for a config |
| `/comment` | POST | Post a comment |
| `/delete` | POST | Delete a config |
| `/desc?sha={sha}` | GET | Get description for a config by SHA |
| `/describe` | POST | Post/update config description |

**Other URLs in this file:**
- `https://the412banner.github.io/bannerhub-game-configs/devices.json` — Device compatibility list
- `https://raw.githubusercontent.com/The412Banner/bannerhub-game-configs/main/configs/{game}/{file}` — Direct GitHub raw config URL (used for share URL)
- `https://cdn.akamai.steamstatic.com/steam/apps/%s/header.jpg` — Steam header image (sprintf format)
- `https://store.steampowered.com/api/storesearch/?l=english&cc=us&term=` — Steam store search (for cover art lookup)
- User-Agent: `"BannerHub/1.0"` on Steam requests

---

### §449 — SteamGridDB API Key

Found in `GogGamesActivity.java:69`:
```java
private static final String SGDB_KEY = "cf89227f12c773bb1117b6b109ae1659";
```

Used for cover art lookups when GOG game images are unavailable:
- `GET https://www.steamgriddb.com/api/v2/search/autocomplete/{gameName}`
- `GET https://www.steamgriddb.com/api/v2/grids/game/{id}?dimensions=600x900&mimes=image/jpeg,image/png&limit=1`

---

### §450 — GOG Download/Cloud Save Endpoints

**`GogDownloadManager.java`** — GOG game installer download pipeline:
| URL | Purpose |
|---|---|
| `https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=2` | Fetch Gen2 build manifest |
| `https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=1` | Fetch Gen1 build manifest (fallback) |
| `https://api.gog.com/products/{gameId}?expand=downloads` | Get product download links |
| `https://www.gog.com{path}` | GOG installer download (relative path expansion) |
| `https://embed.gog.com/user/data/games` | List owned games |

User-Agent: `"GOG Galaxy"`

**`GogCloudSaveManager.java`** — Cloud save sync:
- Base: `https://cloudstorage.gog.com/v1/`
- Token refresh: `https://auth.gog.com/token?client_id={id}&client_secret={secret}&grant_type=refresh_token&refresh_token={token}`

---

### §451 — Amazon Games API Endpoints

**`AmazonApiClient.java`** (in `app/revanced/extension/gamehub/`):
| Constant | URL |
|---|---|
| `DISTRIBUTION_URL` | `https://gaming.amazon.com/api/distribution/v2/public` |
| `ENTITLEMENTS_URL` | `https://gaming.amazon.com/api/distribution/entitlements` |
| `SDK_CHANNEL_URL` | `https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346` |

Request headers: `X-Amz-Target: {service.method}`, `x-amzn-token: {token}`, `Content-Encoding: amz-1.0`, `User-Agent: {GAMING_USER_AGENT}`

**`AmazonSdkManager.java`** downloader: `User-Agent: "nile/0.1 Amazon"`

---

### §452 — Epic Games: Free Games + Cloud Save

**`EpicFreeGamesActivity.java`:**
- `https://store-site-backend-static-ipv4.ak.epicgames.com/freeGamesPromotions?locale=en-US&country=US&allowCountries=US`
- User-Agent: `"Mozilla/5.0"`
- Store page: `https://store.epicgames.com/en-US/p/{slug}`

**`EpicCloudSaveManager.java`:**
- `BASE = "https://datastorage-public-service-liveegs.live.use1a.on.epicgames.com/api/v1/access/egstore/savesync/"`
- List: `GET {BASE}{accountId}/{titleId}/`
- Upload: `POST {BASE}{accountId}/{titleId}/`

---

### §453 — Amazon Login OAuth URL

`AmazonLoginActivity.java` — Full Amazon OpenID PKCE OAuth URL:
```
https://www.amazon.com/ap/signin
  ?openid.ns=http://specs.openid.net/auth/2.0
  &openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select
  &openid.mode=checkid_setup
  &openid.oa2.scope=device_auth_access
  &openid.ns.oa2=http://www.amazon.com/ap/ext/oauth/2
  &openid.oa2.response_type=code
  &openid.oa2.code_challenge_method=S256
  &openid.oa2.client_id=device:{deviceToken}
  &language=en_US
  &marketPlaceId=ATVPDKIKX0DER
  &openid.return_to=https://www.amazon.com
  &openid.assoc_handle=amzn_sonic_games_launcher
  &pageId=amzn_sonic_games_launcher
  &openid.oa2.code_challenge={codeChallenge}
```

**`EpicLoginActivity.java`:**
- `AUTH_URL = "https://www.epicgames.com/id/login?redirectUrl=https%3A%2F%2Fwww.epicgames.com%2Fid%2Fapi%2Fredirect%3FclientId%3D34a02cf8f4414e29b15921876da36f9a%26responseType%3Dcode"`
- `REDIRECT_HOST = "https://www.epicgames.com/id/api/redirect"`

---

### §454 — Debug Artifact: Local Dev Server URL

Found hardcoded in `SteamGameApi$getLastUpdateVersion$2.java:109` and `SteamGameApi$getAppKeyValue$2.java:91`:
```
http://192.168.31.136:8888/api/apps/{appId}/history
http://192.168.31.136:8888/api/apps/{appId}/{buildId}
```

These are developer's local machine URLs left in shipped code. The app clearly makes requests to a local dev server at `192.168.31.136:8888` for Steam app version history and key-value data. These requests will fail in production as the IP is a LAN address.


---

### §455 — Additional API Domains Discovered

**`clientgsw.vgabc.com`** — GSW (GameSir?) client API:
- URL: `https://clientgsw.vgabc.com/clientapi/`
- Used in: `AdbActivationActivity`, `XjaInjectControlKt.injectXjaCheckInjectNeedUpdate()`
- Request body params: `model=vtouch`, `action=cloud_vtouch_active_config`, `channel=gamehub_zh`, `clientparams={...}`
- TokenInterceptor bypasses signature verification for this URL (`接口不走校验签名`)
- This is the inject/ADB activation config endpoint — fetches cloud VTouch active config

**`clientegg.vgabc.com`** — UX/download telemetry:
- URL: `https://clientegg.vgabc.com/uxapi/`
- Used in: `UxDownloadUtils.reportTaskFail()`
- Reports download failures: `method=Game.downloadErr`, `gameName`, `gameId`, `downloadUrl`, `errMsg=文件不存在`

**`uxdl.bigeyes.com`** — BigEyes UX CDN (game images):
- Pattern: `https://uxdl.bigeyes.com/ux-landscape/{path}`
- Types: `st/en/image/{hash}.webp`, `game-image/{hash}.{ext}`
- Hardcoded mock data in `MockUtilsKt` shows many game image URLs from this CDN

**`shared.cdn.queniuqe.com`** — Steam store assets via queniuqe CN CDN:
- Pattern: `https://shared.cdn.queniuqe.com/store_item_assets/steam/apps/{appId}/{filename}.jpg`
- Same CDN operator as `cdn.queniuqe.com` (Steam MITM target from §445)

---

### §456 — Tencent/PUBG Operations Integration

`com/xj/landscape/launcher/net/tencent/TencentOperationsNetHelper.java`

**Base URL** (prod and beta):
- PRODUCT/BETA: `https://release.nj.qq.com`
- DEV/other: `https://test.nj.qq.com`

Used for PUBG Mobile / Tencent operations data: news, keyword search, activity cards. Request structure: `keyword`, `context`, `page_size` params; responses include Tencent-format content cards.

**`TencentStatisticsHelper`:**
- `b = "https://trace.inlong.qq.com/hn0_iegcommon/dataproxy/message"` — Tencent IEG analytics ingest endpoint
- Fires events: `CLICK`, `SHOW`, `SEARCH`, `DOWNLOAD`, `UPDATE`, `INSTALL`, `REMOVE`, `START_GAME`
- Gated by `LauncherUtils.a.c().getCanRequestTencentData()` — consent-controlled
- Log tag: `"腾讯埋点失败"` on failure

**QQ Social Login:**
- Found in `ShareLoginUtils`: `https://graph.qq.com/user/get_user_info?access_token={token}&openid={openid}&oauth_consumer_key={appId}`
- Uses QQ AppID `102667728` (from SdkConfig)

---

### §457 — OTA / Firmware Update System

`com/xj/ota/` — Gamepad firmware OTA update infrastructure.

**Architecture:**
- `BaseOTARepository` — base; `URL_GET_FIRMWARE` initialized to `"http://127.0.0.1"` (disabled/stub; actual URL injected at construction)
- Uses GET with params: `version`, `beta` (0/1), `name`, `appver`, `new_version` (0/1), `lang`, `agreement=6`, `all_upgrade=all`
- `HttpHandle` — OkHttpClient wrapper with trust-all SSL + `XDns` DNS override
- `BaseOTARepository.getFirmwareList()` returns `AndroidScope` coroutine; posts firmware data via callback

**Supported device types (check classes):**
- `DefaultUpdateCheck` (generic semver)
- `X2ProXboxUpdateCheck`, `X3TypeCUpdateCheck`, `X2TypeCUpdateCheck` (Xbox/USB-C variants)
- `G8UpdateCheck` (G8 series)
- `X5LiteOtaActivity`, `T4NLiteOtaActivity`, `G8SeOtaActivity`, `G8PlusMFiOtaActivity`, `G8TypeCOtaActivity` (OTA UIs per device)

**Firmware check classes** (under `check/firmware/`):
- `DefaultFirmwareCheck`, `G8FirmwareCheck`, `T4nFirmwareCheck`, `T4NLiteFirmwareCheck`, `T4nProFirmwareCheck`, `X3ProFirmwareCheck`, `X5LiteFirmwareCheck`

**`OTAInfor` fields**: `a`=name, `b`=version, `c`=type, `d`=status, `e`=updateType, `f`=link, `g`=md5, `h`=size, `i`=changelog, `j`=forceUpdate, `k`=upgradeType, `l`=firmwareDataBeans, `m`=targetFirmwareDataBeans

**Device-specific OTA targets**: T4n/T4NLite/T4nPro, X3Pro, X5Lite, G8/G8Se/G8PlusMFi — device-specific firmware comparison logic.

---

### §458 — Steam Price API + Region Support

`com/xj/standalone/steam/sdk/price/SteamGamePriceApi.java`

- Endpoint: `https://store.steampowered.com/api/appdetails/?appids={ids,comma-separated}&cc={countryCode}&filters=price_overview`
- `LanguageExtensionsKt.b(language)` converts `LanguageName` to country code for `cc=` param

**`SteamPriceArea` enum** — 41 regions supported:
`US, EU, AR, AU, BR, UK, CA, CL, CN, HK, TW, AZ, CO, CR, IN, ID, IL, JP, KZ, KW, MY, MX, NZ, NO, PE, PH, PL, QA, RU, SA, SG, ZA, PK, KR, CH, TH, TR, AE, UA, UY, VN`

---

### §459 — Additional Web URLs and External Links

| URL | Location | Purpose |
|---|---|---|
| `https://gamehub.xiaoji.com` | `HelpSettingFragment` | Help/support website |
| `https://www.xiaoji.com/url/gsw-app-rules` | `OneKeyAliHelper` | Privacy policy + Terms of Service |
| `https://www.google.com` | `GuideLoginActivity.pingUrl()` | Network connectivity ping |
| `https://play.google.com/store/apps/details?id={pkg}` | `AppLauncher` | Open app in Google Play |
| `https://store.steampowered.com/` | `SteamPageFragment` | Steam store WebView |
| `https://store.steampowered.com/app/{steamId}/` | `SteamGameUpdateDialog` | Game-specific Steam page |
| `https://store.playstation.com/zh-cn/product/...` | `TestGameManagementActivity` | Test data: PS Store link |
| `https://www.xbox.com/play/games/...` | `TestGameManagementActivity` | Test data: Xbox game page |


---

### §460 — GameHubPrefs: Triple API Source Routing

`app/revanced/extension/gamehub/prefs/GameHubPrefs.java`

**Three selectable API backends** (cycled via `cycleApiSource()`):
| Value | Label | URL |
|---|---|---|
| `0` | Official API | XiaoJi `landscape-api.vgabc.com` (default; env-selected by `EggGameHttpConfig`) |
| `1` | EmuReady API | `https://gamehub-lite-api.emuready.workers.dev/` |
| `2` | BannerHub API | `https://bannerhub-api.the412banner.workers.dev/` |

**`getEffectiveApiUrl(String officialUrl)`** — returns `officialUrl` if `apiSource=0`, EmuReady if `1`, BannerHub if `2`.

On API source mismatch at startup: clears caches (`sp_winemu_all_components12`, `sp_winemu_all_containers`, `sp_winemu_all_imageFs`, `pc_g_setting`, `net_cookies`).

**Setting IDs:**
- `24` = SD Card Storage (`"Save Store Games to External Storage (SD Card)"`)
- `26` = Compatibility API (`"Compatibility API"`)
- `27` = Log All Requests
- `28` = CPU Usage Display
- `29` = Performance Metrics Display

---

### §461 — Landscape API Server Environment Map

`com/xj/common/http/EggGameHttpConfig.java`

**Full environment URL table:**
| Condition | URL |
|---|---|
| `Constants.a.c()` (isDebug=true) | `https://test-landscape-api.vgabc.com/` |
| `ServerEnv.PRODUCT` | `https://landscape-api.vgabc.com/` |
| `ServerEnv.BETA` | `https://landscape-api-beta.vgabc.com/` |
| `ServerEnv.DEV` (default) | `https://dev-gamehub-api.vgabc.com/` |

Then `GameHubPrefs.getEffectiveApiUrl()` may override to EmuReady or BannerHub.

**Tencent host bypass** — `EggGameHttpConfig.Companion.b(host)` returns `true` for:
- `test.nj.qq.com`
- `release.nj.qq.com`
- `trace.inlong.qq.com`

These bypass `EggGameTokenInterceptor` signature validation (logged: `接口不走校验签名`).

**OkHttpClient config** (global HTTP client):
- Timeouts: 30s connect/read/write
- Cache: 128MB disk cache
- Interceptors: `RemoveExtraSlashInterceptor`, `EggGameTokenInterceptor`, `TokenRefreshInterceptor`, `OfflineCacheInterceptor`

**Network connectivity checks:**
- `NetworkStatusDetector.checkGoogleAccess()`: `GET https://www.google.com/generate_204`
- `NetworkStatusDetector.checkConnectivity()`: `GET http://connectivitycheck.gstatic.com/generate_204`

---

### §462 — Epic Games API Client

`app/revanced/extension/gamehub/EpicApiClient.java`

| Constant | Value |
|---|---|
| `CATALOG_BASE` | `https://catalog-public-service-prod06.ol.epicgames.com/catalog/api/shared/namespace` |
| `LIBRARY_URL` | `https://library-service.live.use1a.on.epicgames.com/library/api/public/items?includeMetadata=true` |
| `MANIFEST_BASE` | `https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace` |
| `LEGENDARY_UA` | `"Legendary/0.1.0 (GameNative)"` |

**Endpoints constructed:**
- Library list: `GET {LIBRARY_URL}[&cursor={cursor}]`
- Asset manifest: `GET {MANIFEST_BASE}/{namespace}/catalogItem/{catalogItemId}/app/{appName}/label/Live`
- Direct URL: `GET https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace/{ns}/catalogItem/{id}/app/{app}/label/Live`

`EpicAuthClient.java`:
| Constant | Value |
|---|---|
| `CLIENT_ID` | `34a02cf8f4414e29b15921876da36f9a` |
| `CLIENT_SECRET` | `daafbccc737745039dffe53d94fc76cf` |
| `EXCHANGE_URL` | `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange` |
| `TOKEN_URL` | `https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token` |
| `USER_AGENT` | `"UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit"` |

Grant types: `authorization_code` (initial), `refresh_token` (refresh), token type: `eg1`.

---

### §463 — Amazon Auth Client

`app/revanced/extension/gamehub/AmazonAuthClient.java`

| Constant | Value |
|---|---|
| `REGISTER_URL` | `https://api.amazon.com/auth/register` |
| `REFRESH_URL` | `https://api.amazon.com/auth/token` |
| `DEREGISTER_URL` | `https://api.amazon.com/auth/deregister` |
| `DEVICE_TYPE` | `A2UMVHOX7UP4V7` |
| `APP_NAME` | `"AGSLauncher for Windows"` |
| `APP_VERSION` | `"1.0.0"` |
| `OS_VERSION` | `"10.0.19044.0"` |
| `USER_AGENT` | `"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"` |

Registration sends: `client_id`, `device_type=A2UMVHOX7UP4V7`, PKCE code challenge. Returns `access_token`.

---

### §464 — GOG Token Refresh (Hardcoded Credentials)

`app/revanced/extension/gamehub/GogTokenRefresh.java`

Hardcoded token refresh URL with embedded credentials:
```
https://auth.gog.com/token
  ?client_id=46899977096215655
  &client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9
  &grant_type=refresh_token
  &refresh_token={token}
```
(Same credentials as found in `GogLoginActivity` in prior scans.)


---

### §465 — Additional Landscape API Endpoints (Video, Search, Social)

Discovered from smali analysis + source verification.

#### Video Recording / User Video APIs
| Endpoint | Method | Description |
|---|---|---|
| `game/likeVideo` | POST | Like a video |
| `game/cancelLikeVideo` | POST | Unlike a video |
| `game/userVideoNum` | POST | Get user's video count |
| `game/userUploadsVideo` | POST | Upload a video |
| `game/userVideoList` | POST | List user's videos |
| `game/userVideoReading` | POST | Mark video as read/viewed |
| `game/userDeleteVideo` | POST | Delete user's video |
| `uploads/uploadsImages` | POST | Upload images to server |
| `uploads/uploadsVideo` | POST | Upload video file to server |

#### Search APIs
| Endpoint | Description |
|---|---|
| `game/searchGameList` | Search games by keyword or tag |
| `game/searchCategoryList` | Get search category list |
| `game/searchClassifyList` | Get search classification list |
| `game/searchTopCategoryList` | Get top-level category list for search |

#### Steam DNS APIs
| Endpoint | Description |
|---|---|
| `game/getDnsPool` | Get Steam proxy DNS entry pool (`SteamWebViewModel`) |
| `game/getDnsIpPool` | Get Steam DNS IP pool (`SteamModuleApp`) |

#### Other Game APIs
| Endpoint | Description |
|---|---|
| `game/getTopPlatform` | Get top platform data for home page |

#### Open API (Tencent/PUBG Content)
All via `TencentOperationsNetHelper` at `release.nj.qq.com` (or `test.nj.qq.com`):
| Endpoint | Description |
|---|---|
| `open/v1/OpenXJSearch` | Search game content (keyword + context, page_size) |
| `open/v1/OpenXJPage` | Get page content |
| `open/v1/OpenXJMore` | Fetch "more" paginated content |
| `open/v1/OpenXJGameDetail` | Get game detail page content |
| `open/v1/OpenXJActivityList` | Get game activity/event list |
| `open/v1/OpenXJGameUpdateList` | Get game update log list |
| `open/v1/OpenXJRecommendList` | Get recommendation list |

#### Authentication APIs (JWT Login)
| Endpoint | Method | Description |
|---|---|---|
| `jwt/email/login` | POST | Login/register with email + verification code |
| `jwt/mobile/login` | POST | Login with mobile number + SMS code |
| `jwt/oneMobile/login` | POST | One-click mobile login (carrier auth) |
| `jwt/third/login` | POST | Third-party login (QQ, WeChat) |
| `jwt/logout` | POST | Logout (invalidate token) |

#### Email / Bind APIs
| Endpoint | Description |
|---|---|
| `ems/send` | Send email verification code |
| `bind/email` | Bind email to account |
| `bind/mobile` | Bind mobile number to account |

#### Social Additional
| Endpoint | Description |
|---|---|
| `social/getRecommendation` | Get friend/user recommendations (returns `GetRecommendationEntity`: id, username, nickname, avatar, avatar_colour, isAdd) |
| `social/userDeviceConnect` | Connect/associate user device |

#### User Profile / Account
| Endpoint | Description |
|---|---|
| `user/buildPcPin` | Build/generate PC PIN for device pairing |
| `user/mobileScanCode` | Mobile QR code scan for login |
| `user/mobileConfirmCode` | Confirm mobile scan code |
| `user/mobileCancelCode` | Cancel mobile scan code |
| `profile` | Get/update user profile |
| `profile/avatar` | Update profile avatar |
| `profile/username` | Update username |
| `profile/mobile` | Update mobile number |

---

### §466 — EggUploadRepository: File Upload Endpoints

`com/xj/common/http/EggUploadRepository.java`

- `POST /uploads/uploadsImages` — upload image file (multipart form data)
- `POST /uploads/uploadsVideo` — upload video file (multipart form data)

Two variants of each (different auth/signing approaches: `uploadImg$1` and `uploadImg$3`).

---

### §467 — Feedback System API Endpoints

`com/xj/landscape/launcher/ui/feedback/FeedbackViewModel$postFeedback$1.java`  
`com/xj/landscape/launcher/ui/feedback/MyFeedbackActivity$postReply$1.java`

#### POST `/feedback/submitFeedback`
Submit new user feedback report.
```
token, time, account (username), contents (text),
videos (comma-sep CDN URLs), images (comma-sep CDN URLs),
mobile_model, system_ver, app_ver,
device_model, mac_address, firmware_ver,
mapping_text (e.g. "主模式(X) 子模式(Y)"),
clientparams, sign, log_file (multipart file upload)
```

#### POST `/feedback/submitFeedbackReply`
Reply to an existing feedback thread.
```
f_id (feedback thread ID), contents,
videos, images, clientparams, token, time
```

---

### §468 — Winemu / PC Emulation API Endpoints (Simulator Module)

`com/xj/winemu/data/repository/EnvLayerRepository.java` and inner lambda classes.

All endpoints are on the standard Landscape API base (`landscape-api.vgabc.com`).

| Endpoint | Method | Description |
|---|---|---|
| `simulator/getTabList` | POST | List of environment tabs (wine, dxvk, etc.) |
| `simulator/executeScript` | POST | Execute a setup script on the server side |
| `simulator/v2/getAllComponentList` | GET | All available components |
| `simulator/v2/getComponentDetail` | GET | Detail for a specific component ID |
| `simulator/v2/getComponentList` | GET | Paginated component list by `type`, `page`, `page_size` |
| `simulator/v2/getContainerList` | GET | All available Wine containers |
| `simulator/v2/getContainerDetail` | GET | Detail for a specific Wine container |
| `simulator/v2/getDefaultComponent` | GET | Get the recommended default component |
| `simulator/v2/getImagefsDetail` | GET | Get firmware/imagefs layer detail |

`fetchEnvTabs` uses `CacheMode.REQUEST_THEN_READ` to cache tabs locally.

---

### §469 — Game Heartbeat / Session Tracking APIs

`com/xj/winemu/utils/WineGameUsageTracker.java`  
`com/xj/landscape/launcher/launcher/strategy/SteamGameByPcEmuLaunchStrategy.java`

Three heartbeat endpoints for tracking active game sessions (PC emulator). All POST to standard Landscape API.

| Endpoint | Purpose | Key Parameters |
|---|---|---|
| `heartbeat/game/start` | Called when game session begins | `steam_appid`, `steam_user_id`, `game_id`, `token` |
| `heartbeat/game/update` | Periodic heartbeat during play | `steam_appid`, `steam_user_id`, `game_id`, `token` |
| `heartbeat/game/end` | Called when session ends | `steam_appid`, `steam_user_id`, `game_id`, `token` |

---

### §470 — PC Emulator Setup Repository

`com/xj/winemu/data/repository/PcEmuSetupRepository.java`

#### GET `game/getSteamHost`
Fetches the Steam `hosts` file entries for DNS routing/override. Used in Steam client setup to inject custom host mappings. Auth: `token` header.

---

### §471 — EmuReady Token Service (BannerHub Token Bypass)

`app/revanced/extension/gamehub/token/TokenProvider.java`

**Critical finding**: The BannerHub extension intercepts all API authentication through a multi-layer token provider.

#### Service URL
```
https://gamehub-lite-token-refresher.emuready.workers.dev/token
https://gamehub-lite-token-refresher.emuready.workers.dev/refresh
```
(Cloudflare Worker hosted by EmuReady)

#### Auth Header
```
X-Worker-Auth: gamehub-internal-token-fetch-2025
```

#### Behavior Flags
```java
public static boolean apiSwitchPatched = true;  // Use EmuReady API by default
public static boolean loginBypassed = true;      // Bypass login, use service token
```

#### Token Resolution Logic (`resolveToken()`)
1. If `apiSwitchPatched && isExternalAPI()` → return `"fake-token"` (EmuReady path uses its own auth)
2. If `loginBypassed` → fetch shared token from `gamehub-lite-token-refresher.emuready.workers.dev/token`
3. Cache TTL: 4 hours (14,400,000 ms) in both L1 (in-memory) and L2 (SharedPreferences `token_provider_pref`)

The token fetched from the worker is inserted transparently into all API calls. This means multiple users share one fetched token rather than authenticating individually. The `refreshTokenForOfficialApi()` method hooks into `TokenRefreshInterceptor.j()` to intercept all 401-triggered token refreshes.

---

### §472 — GOG Cloud Save Storage API

`app/revanced/extension/gamehub/GogCloudSaveManager.java`

```
BASE = "https://cloudstorage.gog.com/v1/"
```

#### Path structure: `BASE + userId + "/" + clientId`
- `GET {BASE}/{userId}/{clientId}` — list cloud save files
- `GET {BASE}/{userId}/{clientId}/{filename}` — download individual file
- `PUT {BASE}/{userId}/{clientId}/{filename}` — upload file
- Auth: `Authorization: Bearer {gogAccessToken}`
- User-Agent: `GOG Galaxy`

The `clientId` (scope ID) is fetched per-game via `GogDownloadManager.getOrFetchClientId()`.

---

### §473 — Epic Games Cloud Save (DataStorage) API

`app/revanced/extension/gamehub/EpicCloudSaveManager.java`

```
BASE = "https://datastorage-public-service-liveegs.live.use1a.on.epicgames.com/api/v1/access/egstore/savesync/"
```

#### Path structure: `BASE + appName + "/" + accountId + "/`
- `GET {BASE}/{appName}/{accountId}/` — list cloud saves, returns JSON with `files[].name`, `files[].readLink`, `files[].writeLink`
- `POST {BASE}/{appName}/{accountId}/` — push save metadata/manifest
- Files: downloaded via presigned S3 `readLink` URLs; uploaded via presigned `writeLink` URLs
- Auth: `Authorization: Bearer {epicAccessToken}`

---

### §474 — GOG Download Manager — Content System & Catalog APIs

`app/revanced/extension/gamehub/GogDownloadManager.java`

Full GOG galaxy game download pipeline:

| URL | Purpose |
|---|---|
| `https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=2` | Gen2 build manifest list |
| `https://content-system.gog.com/products/{gameId}/os/windows/builds?generation=1` | Gen1 build manifest list (fallback) |
| `https://api.gog.com/products/{gameId}?expand=downloads` | Gen1 download links with installer URLs |
| `https://www.gog.com{installerPath}` | Installer redirect base |

Auth: `Authorization: Bearer {gogToken}`, `User-Agent: GOG Galaxy`

The download pipeline attempts Gen2 first (chunk-based CDN), falls back to Gen1 (installer download).

---

### §475 — Epic Games Free Games API

`app/revanced/extension/gamehub/EpicFreeGamesActivity.java`

```
GET https://store-site-backend-static-ipv4.ak.epicgames.com/freeGamesPromotions?locale=en-US&country=US&allowCountries=US
```

No auth required. Parses `data.Catalog.searchStore.elements[].promotions` for current free game offers.

---

### §476 — Epic Game Manifest Asset URL

`app/revanced/extension/gamehub/EpicApiClient.java`

```
GET https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/public/assets/v2/platform/Windows/namespace/{namespace}/catalogItem/{catalogItemId}/app/{appName}/label/Live
```
Auth: `Legendary/0.1.0 (GameNative)` User-Agent + `Authorization: Bearer {token}`  
Returns `elements[0].manifests` array with CDN URLs and `buildVersion`.

---

### §477 — Analytics / Statistics Reporting APIs

`com/xj/common/trace/EventTracker.java` — three analytics endpoints.

All POST to standard Landscape API, include `token` field.

| Endpoint | Purpose | Params |
|---|---|---|
| `statistics/activeUsersStatistics` | Report user active session | `type`, `use_num`, `token` |
| `statistics/openTypeStatistics` | Report how app was launched | `type`, `token` |
| `statistics/streamUsageStatistics` | Report cloud gaming stream usage | `type`, `token` |

---

### §478 — Cloud Gaming Sub-API Endpoints

`com/xj/landscape/launcher/data/repository/CloudGameOrderListRepository.java`

| Endpoint | Method | Key Params | Purpose |
|---|---|---|---|
| `cloud/order_list` | GET | `page`, `page_size`, `order_by`, `token` | Fetch user's cloud game order history |
| `cloud/use_time_log` | GET | `month`, `token` | Fetch cloud gaming time usage log for month |
| `cloud/game/check_user_timer` | GET | `token` | Check user's remaining cloud game time quota |
| `cloud/h5/exchange_code` | GET | `uuid`, `time`, `clientparams`, `sign` | Exchange auth code for H5 cloud game access |

`cloud/h5/exchange_code` constructs a full URL: `{baseUrl}cloud/h5/exchange_code?uuid={uuid}&time={time}&clientparams={cp}&sign={sig}` (used in `UserAccountManageFragment`).

---

### §479 — Miscellaneous Previously-Undocumented Endpoints

| Endpoint | Source Location | Purpose |
|---|---|---|
| `devices/getUnknownDevices` | `LauncherHelper$showHidModelTipPopup$1` | Query unknown HID devices by `devices_name` |
| `doc/docList` | `ProductDocRepository$getProductDocMenuList$1` | Get product documentation menu by `devices_id` |
| `settings/getNotifySwitch` | `UserNotificationRepository$requestUserNotification$3` | Get user notification switch settings |
| `settings/updateNotifySwitch` | smali scan | Update user notification switch settings |
| `base/getBaseInfo` | `LauncherUtils$getBaseLauncherInfo$1` | Get base launcher configuration info |
| `game/cts/report` | `CompatibleDialog$report$1` | Submit compatibility test result: `game_id`, `cts_level`, `comment`, `cts_info`, `general_info`, `token` |
| `game/getClassify` | smali scan | Game classification/category list |
| `game/getGameCircleList` | smali scan | Game community circle list |
| `game/getIndexList` | smali scan | Game index/home list |
| `game/userPlayedGame` | smali scan | Record/get games played by user |
| `game/videoGameList` | smali scan | Video-linked game list |
| `game/getTopPlatform` | smali scan | Top platform/category games |
| `game/searchCategoryList` | smali scan | Search by category |
| `game/searchClassifyList` | smali scan | Search by classification |
| `game/searchTopCategoryList` | smali scan | Search top categories |
| `search/getGameList` | smali scan | General game search list |
| `search/getHotTrending` | smali scan | Hot trending search terms |
| `social/deleteFriend` | smali scan | Delete a social friend |
| `social/getUserInfo` | smali scan | Get another user's social info |
| `social/userNoticeList` | smali scan | User social notification list |
| `social/userUpdateNotice` | smali scan | Update social notification read status |
| `social/getRecommendation` | smali scan | Get social friend recommendations |
| `/jwt/oneMobile/login` | `GuideLoginActivity` | One-tap carrier mobile auth login |
| `/vtouch/startType` | smali scan | Report launcher start type |
| `/user/updateUserNotice` | smali scan | Update user notice/announcement status |
| `/ems/send` | smali scan | Send EMS (notification push) |
| `/sms/send` | smali scan | Send SMS verification code |

---

### §480 — PlaytimeHelper — SQLite Local Database Schema

`app/revanced/extension/gamehub/playtime/PlaytimeHelper.java`

The BannerHub extension reads Steam playtime directly from two local SQLite databases created by the Steam module:

#### Database: `xj_steam_db`
```sql
SELECT id FROM steam_account WHERE is_current_user = 1 LIMIT 1
```
Returns current Steam user's internal ID.

#### Database: `xj_steam_pics_v5`
```sql
SELECT app_id, playtime_forever, playtime2weeks 
FROM t_steam_user_pics_app_last_played_times 
WHERE user_id = ? AND playtime_forever > 0 
ORDER BY playtime2weeks DESC, playtime_forever DESC
```
Returns playtime data; seconds = minutes * 60 (Steam stores in minutes).

Uses reflection to inject data into `com.xj.game.entity.RecentGameEntity`:
- Field `a` = `steamAppid` (String)
- Field `d` = `totalSeconds` (long)  
- Field `e` = `last14Days` (long)

---

### §481 — Cloud Gaming Full Session Lifecycle API

`com/xj/cloud/data/repository/CloudGameInfoRepository.java` + `com/xj/cloud/vm/LauncherCloudGameViewModel.java`

Complete set of endpoints for the cloud game session lifecycle. All POST to standard Landscape API with `token`.

| Endpoint | Source Class | Params | Purpose |
|---|---|---|---|
| `cloud/game/auth_token` | `CloudGameInfoRepository$getAutoToken$1` | `token`, `session`, `user`, `app_id` | Obtain auto-auth token before session start |
| `cloud/game/start_token` | `CloudGameInfoRepository$getStartToken$1` | `game_id`, `token`, `session` | Request session start token for specific game |
| `cloud/game/startQueue` | `LauncherCloudGameViewModel$startQueue$1` | `token` | Join the cloud game waiting queue |
| `cloud/game/getQueueInfo` | `CloudGameInfoRepository$queryQueue$1` | `token` | Poll current queue position and status |
| `cloud/game/getQueueCalendar` | `QuestionModel$getQueueCalendar$2` | (none) | Get cloud game queue availability calendar |
| `cloud/game/confirmPlay` | `LauncherCloudGameViewModel$confirmPlay$1` | `token`, `code` | Confirm play authorization with verification code |
| `cloud/game/renew_token` | `CloudGameInfoRepository$getReNewToken$1` | `lastDeadline`, `queue_id`, `token`, `session` | Renew expiring cloud game session token |
| `cloud/game/exit` | `CloudGameInfoRepository$exitGame$1` | `token`, `session` | Exit cloud game session cleanly |
| `cloud/game/getNewsDetail` | `QuestionModel$getQuestionDetail$2` | `id` | Get cloud game news/question detail by ID |
| `cloud/game/getNewsList` | `QuestionModel$getQuestions$2` | (none) | List cloud game questions/news articles |

---

### §482 — Cloud Game Payment API

`com/xj/pay/data/repository/CloudGamePayRepository.java` + `com/xj/pay/ui/CloudGamePayActivity.java`

Cloud game time purchase and order management. `pay_type` maps to WeChat Pay or Alipay (see `CloudGamePayActivity$PayType`).

| Endpoint | Source Class | Params | Purpose |
|---|---|---|---|
| `cloud/game/get_goods_list` | `CloudGamePayRepository$getGoodsList$1` | `page`, `page_size`, `token` | List purchasable cloud game time packages |
| `cloud/order/info` | `CloudGamePayRepository$getOrderInfo$1` | `order_no`, `token` | Get order detail after purchase |
| `cloud/payment` | `CloudGamePayRepository$payMent$1` | `goods_id`, `pay_type`, `token` | Initiate cloud game time purchase |

---

### §483 — BannerHub Config Community Worker

`app/revanced/extension/gamehub/BhSettingsExporter.java`

A Cloudflare Worker at `https://bannerhub-configs-worker.the412banner.workers.dev` enables community sharing of per-game BannerHub settings (DXVK, VKD3D, GPU driver, container configs).

#### Endpoints
```
POST https://bannerhub-configs-worker.the412banner.workers.dev/upload
```
Body: `{"game": str, "filename": str, "content": base64str, "upload_token": hex}`
Returns: `{"success": true, "sha": "..."}` — the sha is stored locally to track the upload.

```
GET https://bannerhub-configs-worker.the412banner.workers.dev/list?game={game}
```
Returns JSON array of config entries: `[{"device", "soc", "date", "game_folder", "filename"}, ...]`

```
GET https://bannerhub-configs-worker.the412banner.workers.dev/download?game={game}&file={file}
```
Returns raw JSON config file content.

#### Config format
```json
{
  "meta": {"app_source": "bannerhub", "device": "...", "soc": "...", "bh_version": "3.5.0", "upload_token": "..."},
  "settings": { "pc_g_setting_...": {...} },
  "components": [{"name": str, "url": str, "type": "GPU|VKD3D|Box64|FEXCore|DXVK"}]
}
```

#### Component type IDs (typeNameToInt)
| Type | ID |
|---|---|
| GPU | 10 |
| DXVK/default | 12 |
| VKD3D | 13 |
| Box64 | 94 |
| FEXCore | 95 |

---

### §484 — Amazon Games Integration API

`app/revanced/extension/gamehub/AmazonApiClient.java` + `app/revanced/extension/gamehub/AmazonAuthClient.java`

Full Amazon Games (Prime Gaming) download and authentication integration.

#### Amazon Auth API (`api.amazon.com/auth`)
| URL | Method | Purpose |
|---|---|---|
| `https://api.amazon.com/auth/register` | POST | Register device with PKCE auth code (`authorization_code`, `code_verifier`, `device_serial`, `device_type: A2UMVHOX7UP4V7`) |
| `https://api.amazon.com/auth/token` | POST | Refresh access token from `refresh_token` |
| `https://api.amazon.com/auth/deregister` | POST | Deregister device (on logout) |

Auth header: `x-amzn-identity-auth-domain: api.amazon.com`  
User-Agent: `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0`  
App Name: `AGSLauncher for Windows` / Version `1.0.0`

#### Amazon Games Distribution API (`gaming.amazon.com`)
| URL | Method | Operation Header | Purpose |
|---|---|---|---|
| `https://gaming.amazon.com/api/distribution/entitlements` | POST | `com.amazon.animusdistributionservice.entitlement.AnimusEntitlementsService.GetEntitlements` | Paginated fetch of owned games (`nextToken`, `maxResults: 50`) |
| `https://gaming.amazon.com/api/distribution/v2/public` | POST | `...AnimusDistributionService.GetGameDownload` | Get game `downloadUrl` + `versionId` from `entitlementId` |
| `https://gaming.amazon.com/api/distribution/v2/public` | POST | `...AnimusDistributionService.GetLiveVersionIds` | Get current live version IDs for `adgProductIds` |
| `https://gaming.amazon.com/api/distribution/v2/public/download/channel/87d38116-4cbf-4af0-a371-a5b498975346` | GET | — | Get SDK channel spec |

Auth header: `x-amzn-token: {accessToken}`, `X-Amz-Target: {operation}`  
User-Agent: `com.amazon.agslauncher.win/3.0.9202.1`  
Download User-Agent: `nile/0.1 Amazon`  
Key ID (hardcoded): `d5dc8b8b-86c8-4fc4-ae93-18c0def5314d`

---

### §485 — card/* Content API

Various repositories under `com/xj/landscape/launcher/data/repository/` and `com/xj/game/repository/`

The `card/` namespace contains game discovery, news, and UI content endpoints.

| Endpoint | Source Class | Key Params | Purpose |
|---|---|---|---|
| `card/getAlbumDetail` | `AlbumRepo$getAlbumGameList$2` | `id`, `page`, `page_size`, `token` | Get game list for a specific album/collection |
| `card/more` | `AlbumRepo$getAlbumGameList$2` | `id`, `page`, `page_size`, `token` | Load more items for album/collection |
| `card/getCtsList` | `GameCompatibilityRepository$fetchGamesCompatibilityInfos$2` | `steam_appids`, `game_ids` | Batch fetch compatibility test (CTS) results |
| `card/getGameDetail` | `SteamGameRepository$getGameDetailInfoBySteamId$2` | `id`, `app_id`, `token` | Full game detail card (title, art, metadata) |
| `card/getGameIcon` | `GameIconsRepo$getGameIcons$2` | `ids` (pipe-separated) | Batch fetch game icons by ID list |
| `card/getIndexList` | `LandscapeLauncherRepository$getHomeList$1` | `token`, `topic_type`, `classify_group_id` | Home screen index card list |
| `card/getNewDetail` | `ExploreDialog$fetchNewsDetailInfo$1` + `NewsDetailRepository$fetchNewsDetailInfo$1` | `id`, `token` | News item detail page |
| `card/getNewsGuideDetail` | `NewsRepo$getNewsGuideDetail$2` | `id`, `source`, `token` | News guide/tutorial detail |
| `card/getNewsList` | `NewsRepo$getNewsList$2` | `location`, `game_id`, `pkg_name`, `game_name`, `page`, `page_size`, `token` | In-context news feed list |
| `card/getSearchHot` | `SearchGameRepositoryV4$getSearchRecommend$2` | (internal prefix caching) | Hot search terms list |
| `card/getTopPlatform` | `LandscapeLauncherRepository$getTopPlatform$2$1` | (none) | Top platform/store front-page list |

---

### §486 — Additional Game Check/Query Endpoints

| Endpoint | Source Class | Key Params | Purpose |
|---|---|---|---|
| `game/checkIsCloudGame` | `SteamGamesViewModel$loadCloudGameState$1` | `app_ids` (batch), `token` | Batch check whether Steam app IDs are available as cloud games |
| `game/checkLocalHandTourGame` | `MobileManagerDataHelper$fetchGameInfoByServer$1` | `pkg_name`, `game_name`, `token` | Check if a local mobile/hand-game is recognized by the server |
| `game/getGameTopCategoryIdList` | `LocalGamesViewModel$loadGameCategories$1` | `game_ids`, `token` | Batch fetch top category IDs for a list of games |

---

### §487 — Simulator Local Game Detail Endpoints

`com/xj/game/repository/GameLibraryRepository.java`

Two endpoints for enriching locally-detected games with server-side metadata.

| Endpoint | Source Class | Key Params | Purpose |
|---|---|---|---|
| `simulator/getLocalGameDetail` | `GameLibraryRepository$fetchLocalGameInfo$2` | `file_str`, `other_file_str` | Look up game details by local exe path + alt exe names |
| `simulator/getLocalMultiGameDetail` | `GameLibraryRepository$fetchLocalGameInfoList$2` | `steamid` (comma-separated) | Batch lookup local game details by Steam IDs |

---

### §488 — Supplementary Heartbeat Endpoint

`com/xj/game/repository/GameLibraryRepository.java`

| Endpoint | Source Class | Key Params | Purpose |
|---|---|---|---|
| `heartbeat/game/getUserPlayTimeList` | `GameLibraryRepository$loadRecentGameList$2` | `token` | Fetch user's full game play time history list from server |

---

### §489 — Infrastructure and Utility Endpoints

| Endpoint | Source Class | Key Params | Purpose |
|---|---|---|---|
| `baseLink/getBaseLink` | `PcStreamShareRepository$getPcShareLink$1` | `token` | Get base sharing link for PC Stream (Moonlight/Sunshine pairing) |
| `order/get_down_info` | `WinEmuDownloadManager$refreshDownloadUrl$2` | `token`, `game_id` | Refresh download URL for a purchased WinEmu game |
| `devices/getMapping` | `XjaInjectControlKt` | (injection context) | Fetch device control mapping profile for inject auto-detection |
| `user/getMobileCode` | `AreaCodeSelectLayout$loadData$1` | `token` | Get list of international mobile area codes for phone login |
| `user/info` | `UserInfoRepository$getUserProfile$1` | `token` | Fetch user profile data |

---

### §490 — BannerHub Config Worker — Extended Endpoints

`app/revanced/extension/gamehub/BhGameConfigsActivity.java`

Additional endpoints on the config worker (`https://bannerhub-configs-worker.the412banner.workers.dev`) beyond upload/list/download:

| URL | Method | Params | Purpose |
|---|---|---|---|
| `/games` | GET | (`?refresh=1` optional) | List all games that have community configs |
| `/vote` | POST | `{game, file, sha, vote}` | Upvote/downvote a community config |
| `/report` | POST | `{game, file, sha, reason}` | Report an inappropriate config |
| `/comments?game={}&file={}` | GET | `game`, `file` | Fetch comments for a specific config |

Also fetches the device compatibility list from GitHub Pages:
```
GET https://the412banner.github.io/bannerhub-game-configs/devices.json
```
And can load raw configs directly from GitHub without the worker:
```
GET https://raw.githubusercontent.com/The412Banner/bannerhub-game-configs/main/configs/{game}/{file}
```

---

### §491 — BannerHub API Route (Third API Source)

`app/revanced/extension/gamehub/prefs/GameHubPrefs.java`

The BannerHub extension supports three API sources selectable via the in-app "Compatibility API" toggle:

| `api_source` | URL | Label |
|---|---|---|
| 0 | (Official Landscape API) | "Official API" |
| 1 | `https://gamehub-lite-api.emuready.workers.dev/` | "EmuReady API" |
| 2 | `https://bannerhub-api.the412banner.workers.dev/` | "BannerHub API" |

`getEffectiveApiUrl(str)` returns the selected base URL, replacing the official base transparently. SharedPreferences key: `api_source` in `steam_storage_pref`.

Cache clearing on API source change: `sp_winemu_all_components12`, `sp_winemu_all_containers`, `sp_winemu_all_imageFs`, `pc_g_setting`, `net_cookies`, `token_provider_pref`.

---

### §492 — Steam CDN Helper

`app/revanced/extension/gamehub/network/SteamCdnHelper.java`

Batched Steam app header image resolution with two-level cache.

#### URLs
```
GET https://api.steampowered.com/IStoreBrowseService/GetItems/v1/?input_json={...}
```
Input JSON: `{"ids": [{"appid": N},...], "context": {"language":"english","country_code":"US"}, "data_request":{"include_assets":true}}`
Returns `asset_url_format` + `header` filename per app. Batch size: 50 IDs per request.

```
https://shared.steamstatic.com/store_item_assets/{url}
```
CDN fallback for `steam/` relative paths.

```
https://cdn-library-logo-global.bigeyes.com/
```
BigEyes CDN (rewritten transparently to `shared.steamstatic.com/store_item_assets/`).

Cache: L1 = `ConcurrentHashMap` (in-memory), L2 = `SharedPreferences steam_cdn_cache`. TTL: 7 days (604,800,000 ms). Batch delay: 150ms.

---

### §493 — GOG Auth, Token Refresh, and Library API

`app/revanced/extension/gamehub/GogLoginActivity.java` + `GogTokenRefresh.java` + `GogGamesActivity.java`

#### GOG OAuth Login (WebView)
```
https://auth.gog.com/auth?client_id=46899977096215655&redirect_uri=https%3A%2F%2Fembed.gog.com%2Fon_login_success%3Forigin%3Dclient&response_type=token&layout=client2
```
Captures `access_token` + `refresh_token` from redirect on `https://embed.gog.com/on_login_success`.

#### GOG Token Refresh
```
GET https://auth.gog.com/token?client_id=46899977096215655&client_secret=9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9&grant_type=refresh_token&refresh_token={token}
```
Returns new `access_token`. Hardcoded GOG client credentials:
- `client_id`: `46899977096215655`
- `client_secret`: `9d85c43b1482497dbbce61f6e4aa173a433796eeae2ca8c5f6129f2dc4de46d9`

#### GOG Library
```
GET https://embed.gog.com/user/data/games
Authorization: Bearer {gogToken}
```
Returns user's owned GOG game IDs (`owned` array).

#### SteamGridDB (artwork for non-Steam games)
```
GET https://www.steamgriddb.com/api/v2/search/autocomplete/{title}
GET https://www.steamgriddb.com/api/v2/grids/game/{id}?dimensions=600x900&mimes=image/jpeg,image/png&limit=1
```
Auth: `Authorization: Bearer cf89227f12c773bb1117b6b109ae1659` (hardcoded SteamGridDB API key)

---

### §494 — Epic Games Auth API

`app/revanced/extension/gamehub/EpicLoginActivity.java` + `EpicAuthClient.java`

#### Epic OAuth Login (WebView)
```
https://www.epicgames.com/id/login?redirectUrl=https%3A%2F%2Fwww.epicgames.com%2Fid%2Fapi%2Fredirect%3FclientId%3D34a02cf8f4414e29b15921876da36f9a%26responseType%3Dcode
```
Redirect captured at `https://www.epicgames.com/id/api/redirect` — extracts `authorizationCode`.

#### Epic Token Exchange
```
POST https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/token
Authorization: Basic (base64 of "34a02cf8f4414e29b15921876da36f9a:{secret}")
grant_type=authorization_code&code={authorizationCode}
```
Returns `access_token`, `refresh_token`, `account_id`.

#### Epic Exchange Code
```
GET https://account-public-service-prod03.ol.epicgames.com/account/api/oauth/exchange
Authorization: Bearer {accessToken}
User-Agent: UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit
```
Returns `code` (short-lived exchange code for service auth).

Epic client ID (Legendary/EGL): `34a02cf8f4414e29b15921876da36f9a`  
User-Agent: `UELauncher/11.0.1-14907503+++Portal+Release-Live Windows/10.0.19041.1.256.64bit`

---

### §495 — XiaoJi/Landscape Image CDN Domains

`com/xj/landscape/launcher/data/mock/MockUtilsKt.java` + `SteamCdnHelper.java` + `SteamUrlHelper.java`

Two CDN domains host Landscape API game artwork (XiaoJi operated):

| Domain | Path Pattern | Purpose |
|---|---|---|
| `https://uxdl.bigeyes.com/ux-landscape/` | `st/en/image/{hash}.webp`, `game-image/{hash}.png/jpg` | Landscape game images and banners |
| `https://shared.cdn.queniuqe.com/store_item_assets/` | `steam/apps/{appid}/header.jpg` | Mirror of Steam app header images |
| `https://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/{appid}/{icon}` | — | Steam community app icons |
| `https://shared.steamstatic.com/store_item_assets/` | `steam/apps/{appid}/header.jpg` | Official Steam CDN (fallback) |

The `queniuqe.com` domain is a Steam CDN mirror operated by XiaoJi — not the official steamstatic.com.

---

### §496 — Xbox Cloud Gaming Integration

`com/xj/bussiness/devicemanagement/XboxWebActivity.java`

A WebView activity loads Xbox Cloud Gaming. The URL is fallback-resolved:
```
Intent URL → https://www.xbox.com/play/ (default) or https://www.xbox.com/en-AU/play/
Allowed domains: https://*.xbox.com
```
No custom auth — uses Xbox account session via WebView cookies.

---

### §497 — Third-Party SDK Telemetry Endpoints

`com/uyumao/` package (Yumao anti-fraud/analytics SDK)

| URL | Method | Purpose |
|---|---|---|
| `https://yumao.puata.info/cc_info` | POST | Yumao SDK device config/check-in |
| `https://yumao.puata.info/anti_logs` | POST | Yumao anti-fraud log submission |
| `https://sss.umeng.com/api/v2/al` | POST | Umeng analytics event reporting |
| `https://ccs.umeng.com/ra` | POST | Umeng push/remote config |

These SDKs collect device fingerprinting data for fraud detection. The Yumao SDK (`com.uyumao`) is embedded for risk control and reports to `puata.info`, which appears to be a Yumao-owned anti-fraud domain.

---

### §498 — Steam SDK API Endpoints

`com/xj/standalone/steam/sdk/SteamApiUrls.java` + `SteamGamePriceApi.java`

| URL | Purpose |
|---|---|
| `https://store.steampowered.com/api/appdetails/?appids={ids}&cc={country}&filters=price_overview` | Batch fetch game prices by region |
| `https://store.steampowered.com/api/appdetails?appids={id}&filters=ratings` | Fetch game ratings |
| `https://store.steampowered.com/events/ajaxgetadjacentpartnerevents/?appid={appId}&count_before=0&count_after={n}` | Fetch game news/events |
| `https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1?appid={appId}` | Get current concurrent player count |
| `https://shared.cloudflare.steamstatic.com/store_item_assets/steam/apps/{appId}/{filename}` | Steam app assets via Cloudflare CDN |

Chinese region routing: `https://store.steamchina.com` instead of `https://api.steampowered.com` when `LanguageName.Chinese`.

---

### §499 — XJA Control API (ADB WiFi Module)

`com/xj/adb/wifiui/http/TokenInterceptor.java`

The XJA inject/control module (KeyMapper) uses a separate API base:
```
https://clientgsw.vgabc.com/clientapi/
```
Auth signature validation is explicitly **skipped** for requests to this URL (special-cased in `TokenInterceptor`).

---

### §500 — Component Download Manifests (GitHub Raw)

`com/xj/landscape/launcher/ui/menu/ComponentDownloadActivity.java`

The component download manager fetches JSON manifests from GitHub raw:

| URL | Content |
|---|---|
| `https://raw.githubusercontent.com/Arihany/WinlatorWCPHub/refs/heads/main/pack.json` | WCP component packs manifest |
| `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/kimchi_drivers.json` | Kimchi GPU driver list |
| `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/stevenmxz_drivers.json` | stevenmxz GPU driver list |
| `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/mtr_drivers.json` | MTR GPU driver list |
| `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/white_drivers.json` | White GPU driver list |
| `https://raw.githubusercontent.com/The412Banner/Nightlies/refs/heads/main/nightlies_components.json` | BannerHub nightly components list |

---

### §501 — PlayStation Network (PSN) OAuth Login

`com/xj/psplay/ui/register/RegisterNicknamePSNActivity.java`

PSN Remote Play auth via WebView:
```
https://auth.api.sonyentertainmentnetwork.com/2.0/oauth/authorize?
  service_entity=urn:service-entity:psn
  &response_type=code
  &client_id=ba495a24-818c-472b-b12d-ff231c1b5745
  &redirect_uri=https://remoteplay.dl.playstation.net/remoteplay/redirect
  &scope=psn:clientapp
  &layout_type=popup
  &smcid=remoteplay
  &prompt=always
```
PSN OAuth client ID: `ba495a24-818c-472b-b12d-ff231c1b5745` (PS Remote Play client)

---

### §502 — WeChat and QQ Social Login APIs

`com/xiaoji/egggame/wxapi/WXEntryActivity.java` + `com/xj/landscape/launcher/utils/share/ShareLoginUtils.java`

#### WeChat OAuth Token
```
GET https://api.weixin.qq.com/sns/oauth2/access_token?appid={APPID}&secret={SECRET}&code={CODE}&grant_type=authorization_code
```
Returns `access_token`, `openid`, `refresh_token`.

#### QQ User Info
```
GET https://graph.qq.com/user/get_user_info?access_token={token}&openid={openid}&oauth_consumer_key={appId}
```
Returns QQ user profile (nickname, avatar).

---

### §503 — Tencent Internal Telemetry Endpoints

`com/xj/landscape/launcher/net/tencent/TencentStatisticsHelper.java` + `TencentOperationsNetHelper.java`

| URL | Purpose |
|---|---|
| `https://trace.inlong.qq.com/hn0_iegcommon/dataproxy/message` | Tencent IEG/Inlong telemetry data proxy |
| `https://release.nj.qq.com` | Tencent QQ operations base (prod) |
| `https://test.nj.qq.com` | Tencent QQ operations base (test) |

These are Tencent internal analytics/operations endpoints — likely OEM SDK instrumentation from the original PUBG Mobile host app.

---

### §504 — XiaoJi Help and Documentation URLs

`com/xj/mapping/view/KeyboardViewNew.java` + `MapGlobalSettingLayout.java` + `HelpSettingFragment.java`

| URL | Context |
|---|---|
| `https://gamehub.xiaoji.com` | GameHub help/support website (opened from Help setting) |
| `https://doc.xiaoji.com/help.html?lang={lang}&device={device}&platform=gsw` | Key mapping help documentation |
| `https://doc.xiaoji.com/selectdevice.html?lang={lang}&platform=gsw` | Device selection guide |
| `https://www.xiaoji.com/url/gsw-app-rules` | App terms of service / privacy policy |
| `https://www.xiaoji.com/url/obscure-click` | Obscure click key mapping help |

---

### §505 — Carrier SSO (China Mobile Login)

`com/cmic/sso/sdk/view/LoginAuthActivity.java`

China carrier one-tap login SDKs (China Telecom + China Unicom):

| URL | Carrier |
|---|---|
| `https://e.189.cn/sdk/agreement/detail.do?hidetop=true` | China Telecom (189.cn) user agreement |
| `https://opencloud.wostore.cn/authz/resource/html/disclaimer.html?fromsdk=true` | China Unicom (wostore.cn) disclaimer |

These are embedded as part of the `com.cmic.sso` carrier SSO SDK for phone number one-tap authentication.

---

### §506 — GOG CDN Fastly (Gen2 Depot Manifest Downloads)

**Source:** `app/revanced/extension/gamehub/GogDownloadManager.smali` (runGen2 method, line ~280)

The `GogDownloadManager.runGen2()` method uses a Fastly CDN endpoint to fetch GOG Gen2 depot manifest files. The URL is constructed using a helper:

```
base = "https://gog-cdn-fastly.gog.com/content-system/v2/meta/"
cdnPath = buildCdnPath(hash)  // e.g. "ab/cd/abcdef1234..."
fullUrl = base + cdnPath
```

Where `buildCdnPath(hash)` returns `{hash[0:2]}/{hash[2:4]}/{hash}`.

**Endpoint pattern:**
- `https://gog-cdn-fastly.gog.com/content-system/v2/meta/{xx}/{yy}/{hash}` — GET, fetches compressed (.zlib or gzip) depot manifest for GOG Gen2 install

**Auth:** Bearer token (access_token from `bh_gog_prefs` shared preferences)  
**User-Agent:** `"GOG Galaxy"`  
**Response:** Compressed binary depot manifest containing file list with chunk hashes for Gen2 delta-patched installs

This complements the `content-system.gog.com` builds API: after getting a `link` or `meta_url` from the builds API, `runGen2` fetches it; if the response contains a CDN path hash, it is resolved through this Fastly CDN base.

---

### §507 — XiaoJi X1 Firmware OTA URL (Disabled in Build)

**Source:** `com/xj/ota/data/repository/BaseOTARepository.smali`

The OTA (Over-The-Air firmware update) module's `BaseOTARepository` contains two sequential `const-string` assignments to the `URL_GET_FIRMWARE` field:

```smali
const-string p1, "https://www.xiaoji.com/firmware/update/x1/"
const-string p1, "http://127.0.0.1"
iput-object p1, p0, BaseOTARepository->URL_GET_FIRMWARE
```

The second assignment overwrites the first, so in the shipped build `URL_GET_FIRMWARE = "http://127.0.0.1"` — the OTA update check is effectively **disabled** (points to localhost). The original URL `https://www.xiaoji.com/firmware/update/x1/` was the intended XiaoJi X1 device firmware update endpoint before it was neutered.

**Original URL (historical):** `https://www.xiaoji.com/firmware/update/x1/`  
**Shipped URL (effective):** `http://127.0.0.1` (disabled/stub)  
**Purpose:** Checks for and downloads firmware updates for XiaoJi X1 gamepads/controllers over the air  
**Note:** The `com/xj/ota/` module contains device-specific OTA check implementations: `X2ProXboxUpdateCheck`, `X3TypeCUpdateCheck`, `G8UpdateCheck`, `T4nFirmwareCheck`, etc. (GameSir controller models). All OTA requests are routed through this disabled localhost stub in the PUBG build.

---

### §508 — Firebase App Measurement (Google Analytics SDK)

**Source:** `com/google/android/gms/internal/measurement/zzpe.smali` + `com/google/android/gms/measurement/internal/zzfy.smali`

Firebase Analytics / Google App Measurement SDK endpoints bundled within the Google Play Services library:

| URL | Purpose |
|---|---|
| `https://app-measurement.com/a` | Firebase Analytics event batch upload endpoint |
| `https://app-measurement.com/s/d` | Firebase Analytics session data endpoint |

These are Google Firebase Analytics SDK URLs (from `com.google.firebase:firebase-analytics`). The app measurement SDK collects standard Android analytics events and fires them to these endpoints. Since this app is a PUBG Mobile host with a custom launcher, Firebase Analytics telemetry flows through these endpoints.

---

### §509 — China Mobile WAP Passport Contract Page

**Source:** `com/cmic/sso/sdk/view/LoginAuthActivity.smali`

| URL | Context |
|---|---|
| `http://wap.cmpassport.com/resources/html/contract.html` | China Mobile WAP carrier contract / user agreement page |

Complement to the `verify.cmpassport.com/h5/getMobile` endpoint documented in §281. The WAP contract page is shown in the embedded WebView during China Mobile one-tap carrier SSO login to present the terms of service. Uses plain HTTP (not HTTPS) — standard for China Mobile's WAP legacy contract pages.

---

### §510 — XiaoJi Mobile Help Article Pages

**Source:** `com/xj/mapping/view/KeyboardViewNew$15$2.smali` + `KeyboardViewPlans$8.smali`

Two specific in-app help article URLs opened via `DialogWebView` from the key mapping UI:

| URL | Context |
|---|---|
| `http://m.xiaoji.com/help/gw/2274.html` | Opened from `KeyboardViewNew` (on-screen keyboard mapping help article) |
| `http://m.xiaoji.com/help/gw/1996.html` | Opened from `KeyboardViewPlans` (keyboard configuration plans help article) |

These are the mobile-optimized (`m.xiaoji.com`) XiaoJi help knowledge base articles — separate from the documentation portal at `doc.xiaoji.com` (documented in §504). Both use plain HTTP (not HTTPS).

---

### §511 — Google AdMob / Ad Services URLs (Bundled SDK)

**Source:** `com/google/android/gms/ads/identifier/zza.smali` + `com/google/android/gms/measurement/internal/zzpp.smali`

Advertising and conversion tracking endpoints from bundled Google Play Services / Firebase libraries:

| URL | SDK | Purpose |
|---|---|---|
| `https://pagead2.googlesyndication.com/pagead/gen_204?id=gmob-apps` | Google Mobile Ads (AdMob) | Tracking beacon / ad impression signal |
| `https://www.googleadservices.com/pagead/conversion/app/deeplink?id_type=adid&sdk_version=%s&rdid=%s&bundleid=%s&retry=%s` | Google Ads conversion | App deeplink conversion attribution tracking |
| `https://accounts.google.com/o/oauth2/revoke?token=` | Google Sign-In / Firebase Auth | OAuth token revocation (sign-out flow) |

**Note:** These are standard Google SDK library endpoints, not app-specific API calls. The AdMob SDK collects ADID (Android Advertising ID) and app attribution data. The OAuth revoke URL is called by the Google Sign-In SDK during logout.

---

### §512 — Google reCAPTCHA v3 Enterprise (Bundled SDK)

**Source:** `com/google/android/recaptcha/internal/zzae.smali` + `zzaf.smali` + `zzak.smali` + `zzai.smali` + `zzar.smali`

| URL | Purpose |
|---|---|
| `https://www.recaptcha.net/recaptcha/api3` | Google reCAPTCHA v3 API base endpoint |

The `com.google.android.recaptcha` SDK is bundled in classes9.dex. It is triggered indirectly by the Firebase Authentication SDK (specifically the `firebase-auth-api` module) for bot protection during authentication flows. The `recaptcha.net` domain is used as an alternative to `recaptcha.google.com` for markets where `google.com` may be inaccessible (notably China).

---

### §513 — better-xcloud Self-Update and Documentation URLs

**Source:** `assets/better-xcloud.user.js` (v5.7.3 by redphx)

The embedded better-xcloud userscript contains built-in self-update checking and documentation references:

**Auto-update API:**

| URL | Purpose |
|---|---|
| `https://api.github.com/repos/redphx/better-xcloud/releases/latest` | GitHub Releases API — checks for newer version of the script |
| `https://github.com/redphx/better-xcloud/releases/latest/download/better-xcloud.user.js` | Direct download URL for the latest script version |
| `https://github.com/redphx/better-xcloud/releases` | Release history page |
| `https://github.com/redphx/better-xcloud/releases/latest` | Latest release redirect |

**Documentation links (opened in browser from script UI):**

| URL | Context |
|---|---|
| `https://better-xcloud.github.io/android` | Android setup guide |
| `https://better-xcloud.github.io/features/` | Feature overview |
| `https://better-xcloud.github.io/guide/android-webview-tweaks/` | WebView tuning guide |
| `https://better-xcloud.github.io/ingame-features/#audio` | In-game audio settings docs |
| `https://better-xcloud.github.io/ingame-features/#controller` | Controller settings docs |
| `https://better-xcloud.github.io/ingame-features/#video` | Video streaming settings docs |
| `https://better-xcloud.github.io/mouse-and-keyboard/` | Mouse & keyboard support guide |
| `https://better-xcloud.github.io/mouse-and-keyboard/#disclaimer` | MK disclaimer |
| `https://better-xcloud.github.io/remote-play` | Remote Play guide |
| `https://better-xcloud.github.io/stream-stats/` | Stream statistics guide |
| `https://better-xcloud.github.io/troubleshooting` | Troubleshooting guide |
| `https://github.com/redphx/better-xcloud-devices` | Compatible device list repo |
| `https://github.com/redphx/better-xcloud/discussions/275` | Specific community discussion |
| `https://github.com/redphx/better-xcloud/issues/206#issuecomment-1920475657` | Specific issue/workaround link |
| `https://ko-fi.com/redphx` | Developer Ko-fi donation page |
| `https://github.com/redphx` | Developer GitHub profile |

**Asset loaded by script:**

| URL | Purpose |
|---|---|
| `https://redphx.github.io/better-xcloud/fonts/promptfont.otf` | PromptFont loaded for controller button glyphs in UI overlay |

The auto-update check (`api.github.com/repos/redphx/better-xcloud/releases/latest`) is made by the script at runtime inside the Xbox Cloud Gaming WebView — if a newer version exists, the script displays a notification to the user. This is a live outbound HTTP call made from within the app's WebView during Xbox Cloud Gaming sessions.


---

### §514 — PSPlay: Chiaki PSN Account ID Help URL

**Pass 65 | Source:** `res/values/strings.xml` → `regist_psn_account_id_help_url` resource, consumed by `res/layout/activity_regist.xml`

A user-facing help link displayed in the PSN registration UI, pointing to the Chiaki open-source project README section on how to obtain a PSN Account ID:

```
https://git.sr.ht/~thestr4ng3r/chiaki/tree/master/item/README.md#obtaining-your-psn-accountid
```

**Layout context:** `activity_regist.xml` contains a `MaterialTextView` with `android:autoLink="web"` and `android:text="@string/regist_psn_account_id_help_url"` — the URL is rendered as a clickable hyperlink for users who need help locating their PSN Account ID before connecting via PS Remote Play.

**Significance:** Confirms the `com.xj.psplay` module is derived from/built around the Chiaki open-source PlayStation Remote Play client (originally by thestr4ng3r, now at https://git.sr.ht/~thestr4ng3r/chiaki). The URL is a documentation link, not a callable API endpoint. Present in all locale variants (zh, zh-rCN, zh-rTW, zh-rHK, zh-rMO, ru, ja, pt-rBR, pt-rPT, and default English strings.xml).

**Classification:** User-facing documentation link (not an API endpoint).

---

### §515 — Third-Party Library Attribution URLs (Pass 65 Findings)

**Pass 65 | Source:** Multiple third-party SDK smali/Java files

The following URLs appear as documentation links embedded in error messages, log strings, or library attribution comments within bundled third-party SDKs. None are callable API endpoints.

| URL | Source File / Context |
|---|---|
| `https://github.com/mikepenz/FastAdapter/blob/develop/library-core/.../AbstractItem.kt#L22` | `com/mikepenz/fastadapter/listeners/OnBindViewHolderListenerImpl.java` — Log.e() error guidance for missing `setTag()` |
| `http://protobuf.dev/programming-guides/enum/#java` | `com/google/protobuf/JavaFeaturesProto.smali` — protobuf library programming guide |
| `https://aria.laoyuyu.me/aria_doc/create/any_java.html` | `com/arialyy/aria/core/Aria.smali` — Aria download library usage error message |
| `https://aria.laoyuyu.me/aria_doc/other/annotaion_invalid.html` | `com/arialyy/aria/core/upload/UploadReceiver.smali` / `download/DownloadReceiver.smali` — Aria annotation error guidance |
| `https://commons.apache.org/proper/commons-compress/zip.html#ZipArchiveInputStream_vs_ZipFile` | `org/apache/commons/compress/archivers/zip/ZipArchiveInputStream.smali` — Apache Commons Compress exception messages |
| `https://android.googlesource.com/platform/frameworks/base/+/193520e3dff5248ddcf8435203bf99d2ba667219%5E%21/...` | `com/efs/sdk/memleaksdk/monitor/internal/ak$c.smali` — AccessibilityNodeInfo leak description |
| `https://code.google.com/p/android/issues/detail?id=173689` | `com/efs/sdk/memleaksdk/monitor/internal/ak$d.smali` — AccountManager leak bug tracker ref |
| `https://code.google.com/p/android/issues/detail?id=152173` | `com/efs/sdk/memleaksdk/monitor/internal/ak$d.smali` — VideoView AudioManager leak bug tracker ref |
| `https://issuetracker.google.com/issues/139738913` | `com/efs/sdk/memleaksdk/monitor/internal/ak$bf.smali` — IRequestFinishCallback leak tracker |
| `https://support.google.com/chromecast/?p=trouble-finding-devices` | `res/values-*/strings.xml` — `mr_chooser_wifi_learn_more` MediaRouter/Cast SDK help link |
| `https://cs.android.com/android/_/android/platform/frameworks/base/+/89608118192580ffca026b5dacafa637a556d578` | `com/efs/sdk/memleaksdk/monitor/internal/ak$y.smali` — PackageManager leak source reference |
| `https://dev.to/pyricau/beware-packagemanager-leaks-223g` | `com/efs/sdk/memleaksdk/monitor/internal/ak$y.smali` — PackageManager leak blog reference |

All of these are strings embedded within the `com.efs.sdk.memleaksdk` (EFS Memory Leak SDK), `com.arialyy.aria` (Aria download manager), `org.apache.commons.compress` (Apache Commons Compress), `com.mikepenz.fastadapter` (FastAdapter UI library), `com.google.protobuf` (Protobuf SDK), and Android MediaRouter (`androidx.mediarouter`) bundled libraries. They appear in exception messages, log strings, or static descriptions for known Android memory leak patterns — not in any network call path.

---

### §516 — libmitm.so: DNS-over-HTTPS Resolvers (SteamChinaOptimizer)

**Pass 66 | Source:** `strings` analysis of `/lib/arm64-v8a/libmitm.so`

The `libmitm.so` native library originates from the **SteamChinaOptimizer** Rust project (source path embedded: `/Users/me/Documents/SteamChinaOptimizer/core/`). The library implements a TLS MITM proxy (`MitmProxy.java`) for intercepting and rerouting Steam API traffic through Chinese CDN proxies.

**DNS-over-HTTPS (DoH) resolvers embedded in `libmitm.so`:**

| Endpoint | Provider | Query Format |
|---|---|---|
| `https://dns.alidns.com/resolve?name=<host>&type=1` | Alibaba DNS-over-HTTPS (Chinese) | RFC 8484 JSON |
| `https://cloudflare-dns.com/dns-query?name=<host>&type=1` | Cloudflare DoH | RFC 8484 JSON |
| `https://dns.google/resolve?name=<host>&type=1` | Google DoH | RFC 8484 JSON |

**Additional hardcoded DNS server:** `223.5.5.5:53` — Alibaba Public DNS (fallback for plain UDP DNS)

**How used:** The MITM proxy's internal DNS server (`mitm_core::dns_server`) queries these DoH endpoints (in order: Alibaba first, then Cloudflare, then Google) to resolve Steam hostnames before applying proxy routing rules. Response format is `application/dns-json`. This allows the proxy to resolve hostnames even when the system DNS is unavailable or filtered.

**Origin project:** The Rust source tree at `/Users/me/Documents/SteamChinaOptimizer/core/src/{dns.rs, dns_server.rs, proxy.rs, config.rs}` corresponds to the SteamChinaOptimizer project — an open-source tool for optimizing Steam connectivity in China. The Android integration wraps it as `libmitm.so` loaded by `com.winemu.core.mitm.MitmProxy`.

---

### §517 — Native Library Protocol URIs: libffmpeg-org.so + libjingle_peerconnection_so.so

**Pass 66 | Source:** `strings` analysis of native `.so` libraries

**`libffmpeg-org.so`:**
- `http://lame.sf.net` — LAME MP3 encoder attribution embedded in FFmpeg library. Not a callable endpoint.

**`libjingle_peerconnection_so.so`** (WebRTC, used for PC streaming):

These URIs are RTP header extension namespace identifiers used in WebRTC SDP negotiation — not HTTP endpoints, but URI-format extension identifiers:

| URI | Purpose |
|---|---|
| `http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time` | Absolute send time |
| `http://www.webrtc.org/experiments/rtp-hdrext/abs-capture-time` | Absolute capture time |
| `http://www.webrtc.org/experiments/rtp-hdrext/color-space` | Color space metadata |
| `http://www.webrtc.org/experiments/rtp-hdrext/video-content-type` | Video content type |
| `http://www.webrtc.org/experiments/rtp-hdrext/video-timing` | Video frame timing |
| `http://www.webrtc.org/experiments/rtp-hdrext/video-layers-allocation00` | Simulcast layer allocation |
| `http://www.webrtc.org/experiments/rtp-hdrext/video-frame-tracking-id` | Frame tracking ID |
| `http://www.webrtc.org/experiments/rtp-hdrext/transport-wide-cc-02` | Transport-wide congestion control v2 |
| `http://www.webrtc.org/experiments/rtp-hdrext/playout-delay` | Playout delay limits |
| `http://www.webrtc.org/experiments/rtp-hdrext/inband-cn` | In-band comfort noise |
| `http://www.webrtc.org/experiments/rtp-hdrext/generic-frame-descriptor-00` | Generic frame descriptor |
| `http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01` | IETF CC draft extension |
| `https://aomediacodec.github.io/av1-rtp-spec/#dependency-descriptor-rtp-header-extension` | AV1 RTP dependency descriptor |

All are SDP/RTP protocol identifiers embedded in the WebRTC/Chromium `libjingle_peerconnection_so.so` library. They are used during SDP offer/answer negotiation for the PC game streaming feature — not live HTTP calls.

---

### §518 — Inert Library URI Constants and SDK Namespace Strings (Pass 69 Floor Catalog)

**Pass 69 | Source:** Comprehensive smali scan across all 19 DEX classes

The following URI strings appear in bundled third-party SDK smali code and are **not callable HTTP endpoints**. They serve as protocol namespace identifiers, format specification URIs, or library documentation links embedded in exception messages. They are catalogued here for completeness.

**ExoPlayer / Media3 DASH format URIs** (`androidx.media3.exoplayer` library):
| URI | Purpose |
|---|---|
| `http://dashif.org/guidelines/last-segment-number` | DASH-IF spec: segment number guidance |
| `http://dashif.org/guidelines/thumbnail_tile` | DASH-IF spec: thumbnail tiling |
| `http://dashif.org/guidelines/trickmode` | DASH-IF spec: trick play mode |
| `http://dashif.org/thumbnail_tile` | DASH-IF thumbnail tile identifier |
| `https://aomedia.org/emsg/ID3` | AOM emsg ID3 event message identifier |
| `https://developer.apple.com/streaming/emsg-id3` | Apple HLS emsg ID3 identifier |
| `http://www.w3.org/ns/ttml#parameter` | W3C TTML namespace: parameter element |

**Adobe XMP namespace URIs** (image metadata processing):
| URI | Purpose |
|---|---|
| `http://ns.adobe.com/xap/1.0/` | Adobe XMP metadata namespace |

**Android framework schema URIs** (standard Android XML):
| URI | Purpose |
|---|---|
| `http://schemas.android.com/apk/res/android` | Standard Android resource namespace |
| `http://schemas.android.com/apk/res-auto` | Auto-resolved resource namespace |

**Microsoft DRM protocol URI** (`androidx.media3.exoplayer.drm.HttpMediaDrmCallback`):
| URI | Purpose |
|---|---|
| `http://schemas.microsoft.com/DRM/2007/03/protocols/AcquireLicense` | PlayReady DRM license acquisition protocol identifier. Used in ExoPlayer's PlayReady DRM implementation for SDP negotiation — not a directly callable HTTP endpoint. |

**DRM placeholder URL** (`androidx.media3.exoplayer.drm.FrameworkMediaDrm`):
| URI | Purpose |
|---|---|
| `https://default.url` | Placeholder value used when no DRM license URL is configured. Never called. |

**Apache Commons Compress library documentation** (`org.apache.commons.compress`):
| URI | Purpose |
|---|---|
| `https://tukaani.org/xz/java.html` | XZ for Java library documentation, shown in exception message when XZ decompressor is unavailable |

**Google Play Games OAuth scopes** (`com.google.android.gms.common.Scopes` / GMS SDK):
| Scope String | Purpose |
|---|---|
| `https://www.googleapis.com/auth/games` | Google Play Games full access OAuth scope |
| `https://www.googleapis.com/auth/games_lite` | Google Play Games lite access OAuth scope |

These are static constant strings in the GMS SDK's `Scopes` class — OAuth scope identifiers passed as parameters to Google auth APIs, not direct HTTP calls to these URIs.

**WebRTC RTP extension URIs** (already detailed in §517; included for completeness):
All `http://www.webrtc.org/experiments/rtp-hdrext/*` URIs are SDP protocol extension identifiers in `libjingle_peerconnection_so.so`.

---

### §519 — Open-Source Library Author Attribution URLs

**Pass 70 | Source:** `res/values/strings.xml` library attribution string resources

The following URL appears as library author attribution metadata embedded in Android app string resources for bundled open-source UI libraries. These are rendered in "Open Source Licenses" or "About" UI dialogs:

| String Resource Name | URL | Library |
|---|---|---|
| `library_fastadapter_authorWebsite` | `http://mikepenz.com/` | FastAdapter — recyclerview item adapter library by Michael Pfeiffer |
| `library_materialdrawer_authorWebsite` | `http://mikepenz.com/` | MaterialDrawer — navigation drawer library by Michael Pfeiffer |

**Classification:** Library author attribution metadata. Not callable API endpoints. The URLs are identical for both libraries since they share the same author (Michael Pfeiffer / mikepenz).

---

### §520 — AndroidVideoCache: Local HTTP Proxy for Video Caching

**Pass 71 | Source:** `com/danikula/videocache/HttpProxyCacheServer.java`, `Pinger.java`

The `com.danikula.videocache` (AndroidVideoCache) library is bundled for local media file caching during video playback. It creates a local HTTP server bound to `127.0.0.1` (localhost) that proxies and caches video requests.

**Local proxy URL format:** `http://127.0.0.1:<port>/<encoded_original_url>`

- `HttpProxyCacheServer.getProxyUrl(str)` → formats to `http://127.0.0.1:{this.e}/{ProxyCacheUtils.f(str)}`
- `Pinger` health check uses the path `ping`
- All traffic is local; the original remote URL is encoded in the URL path

**Classification:** Local loopback proxy library. No external API calls originate from this library itself — it caches remote media URLs requested by the player. The actual media URLs being cached would be from sources already documented in this report (Steam CDN, GOG CDN, bigeyes.com CDN, etc.).

---

### §521 — Additional Library Documentation and Attribution URLs (Pass 73 Floor Supplement)

**Pass 73 | Source:** Unquoted URL extraction across all smali files

The following URLs appear in library error messages, deprecation notices, exception descriptions, and copyright strings embedded in bundled third-party SDK code. None are callable HTTP endpoints.

| URL | Source Library / Context |
|---|---|
| `https://developer.android.com/guide/topics/media/issues/cleartext-not-permitted` | ExoPlayer/Media3 — error message when cleartext HTTP traffic is blocked by network security policy |
| `https://developers.google.com/tink/faq/registration_errors` | Google Tink cryptography SDK — error message for registration failures |
| `https://firebase.google.com/support/...` | Firebase App Measurement SDK — deprecation notice for `setAnalyticsCollectionEnabled()` |
| `https://goo.gle/compose-feedback` | Jetpack Compose runtime — bug reporting link in internal error message |
| `https://ktor.io/docs/faq.html#...` | Ktor HTTP client library — exception message for `NoTransformationFoundException` |
| `https://www.bouncycastle.org` | BouncyCastle Java cryptography library — copyright attribution string: "The Legion of the Bouncy Castle Inc." |
| `{http://xml.apache.org/xslt}indent-amount` | Apache XSLT namespace identifier used in XML transform processing |
| `http://www.slf4j.org/codes.html#null_MDCA` | SLF4J logging framework — error message: "MDCAdapter cannot be null" |
| `https://youtrack.jetbrains.com/issue/KTOR-8367/` | Ktor HTTP client — deprecation notice for body-saving disabling API |
| `https://youtrack.jetbrains.com/issue/KT-55980` | Kotlin runtime — deprecation notice for synthetic Java property reflection |
| `https://gist.github.com/pyricau/4df64341cc978a7de414` | EFS Memory Leak SDK — InputMethodManager/Hack workaround attribution (also `https://gist.github.com/jankovd/891d96f476f7a9ce24e2` in §515) |

All are static strings embedded in library code paths that are never reached as HTTP calls. They serve as documentation pointers for developers debugging issues.

---

### §522 — Debug URL Input Placeholder

**Pass 74 | Source:** `com/xj/landscape/launcher/ui/setting/tab/DebugFragment.smali`

The DebugFragment UI contains a URL input field with the placeholder text:
> "Please enter URL (e.g. https://example.com)"

`example.com` is the RFC 2606 standard placeholder domain used in UI hint text for URL input fields. Not a callable API endpoint — this is the debug/developer settings panel that allows manual URL entry for testing server configurations.

---

### §523 — Apache License URL in Apache Commons Codec Data Files

**Pass 77 | Source:** `unknown/org/apache/commons/codec/language/` text data files (phonetic algorithm rules)

The Apache Software Foundation license header URL appears in data files for the Apache Commons Codec library's phonetic encoding algorithms (Beider-Morse, Soundex, etc.):

`https://www.apache.org/licenses/LICENSE-2.0`

Found in: `bm/ash_approx_any.txt`, `bm/ash_approx_common.txt`, `dmrules.txt`, and similar rule data files within `org/apache/commons/codec/language/`.

**Classification:** Open-source license attribution in data files. Not a callable API endpoint.

---

### §524 — License Files and Proto Documentation URLs in `unknown/` Directory

**Pass 78 | Source:** `apktool_out/unknown/` directory — license files, protobuf `.proto` definition files, OkHttp NOTICE

The following URLs appear in license files, open-source attribution notices, and protobuf protocol definition comments bundled in the APK's `unknown/` directory:

| URL | Source File | Purpose |
|---|---|---|
| `http://scripts.sil.org/OFL` | `LICENSE_OFL` | SIL Open Font License — font license for bundled AlimamaShuHeiTi-Bold.ttf |
| `http://www.unicode.org/copyright.html` | `LICENSE_UNICODE` | Unicode consortium copyright notice in Unicode data license file |
| `https://mozilla.org/MPL/2.0/` | `okhttp3/internal/publicsuffix/NOTICE` | Mozilla Public License under which the Public Suffix List is licensed |
| `https://publicsuffix.org/list/public_suffix_list.dat` | `okhttp3/internal/publicsuffix/NOTICE` | Attribution for the Public Suffix List data bundled in OkHttp for cookie domain matching. The list is **bundled in the APK** (not fetched at runtime). |
| `http://joda-time.sourceforge.net/apidocs/org/joda/time/format/ISODateTimeFormat.html` | `google/protobuf/timestamp.proto` | Joda-Time documentation reference in protobuf Timestamp type documentation comment |
| `https://cloud.google.com/apis/design/glossary` | `google/protobuf/api.proto` | Google Cloud API design glossary link in protobuf Api type documentation |
| `http://semver.org` | `google/protobuf/api.proto` | Semantic versioning spec link in protobuf Api documentation |
| `https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toISOString` | `google/protobuf/timestamp.proto` | MDN JS Date documentation in protobuf Timestamp documentation |
| `https://docs.python.org/2/library/time.html#time.strftime` | `google/protobuf/timestamp.proto` | Python time.strftime documentation in protobuf timestamp comments |

**Classification:** All are attribution URLs in license files or documentation comments in protobuf protocol definition files. None are callable API endpoints. The `publicsuffix.org` data is bundled locally in OkHttp — no runtime HTTP fetch occurs.
