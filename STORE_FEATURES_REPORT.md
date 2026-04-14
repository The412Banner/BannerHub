# BannerHub Store Features — Planning Report & Progress Log

**Created:** 2026-04-14  
**Purpose:** Track all planned store feature additions across GOG, Epic, and Amazon. When complete, confirmed working features will be ported to BannerHub Lite.

---

## Status Key

| Symbol | Meaning |
|--------|---------|
| ⬜ | Not started |
| 🔵 | Next up / in progress |
| ✅ | Complete + CI passing |
| ❌ | Attempted — not working / abandoned |
| ⚠️ | Partial — works with caveats |
| 🔄 | Complete — needs BH-Lite port |

---

## Session Resume (update this block every session)

**Current stable:** v3.0.0 (commit `19c6092d8`)
**Active pre:** v3.0.1-pre (commit `d9d595f37`) — CI triggered

**Last completed:** D-5 release dates + GOG-2/EPIC-3/AMAZON-1 update checkers (all confirmed working)
**Next job:** GOG-3 DLC Management → EPIC-4 DLC → AMAZON-2 DLC → then cloud saves

---

## Master Job List

### Detail Page Foundation (all stores)
| # | Job | Status | Notes |
|---|-----|--------|-------|
| D-1 | Full-screen detail activities (GOG/Epic/Amazon) | ✅ v3.0.1-pre | Header, cover art, GAME INFO, ACTIONS, stubs |
| D-2 | Strip HTML from descriptions | ✅ v3.0.1-pre | `Html.fromHtml()` in GOG + Epic detail |
| D-3 | Install size in GAME INFO | ✅ v3.0.1-pre | GOG: sync-time; Epic/Amazon: lazy+cached |
| D-5 | Release date in GAME INFO | ✅ v3.0.1-pre | GOG+Epic synced to SP; Amazon skipped (no API source) |
| D-6 | Ratings / score in GAME INFO | ⬜ | GOG critic score; Epic/Amazon limited |

### GOG
| # | Job | Status | Notes |
|---|-----|--------|-------|
| GOG-1 | Cloud Saves | ⬜ | After GOG-3; `api.gog.com/userData/{uid}/games/{gid}/saves` |
| GOG-2 | Update Checker | ✅ v3.0.1-pre | `content-system.gog.com/products/{id}/os/windows/builds`; compare `gog_build_{id}` |
| GOG-3 | DLC Management | ⬜ | After GOG-2; DLCs in library response, same content-system pipeline |
| GOG-4 | GOG Connect | ⬜ | Low priority — requires Steam session |

### Epic Games
| # | Job | Status | Notes |
|---|-----|--------|-------|
| EPIC-1 | Free Games section (library page) | ⬜ | No auth needed for list; lives in EpicGamesActivity |
| EPIC-2 | Cloud Saves | ⬜ | After EPIC-4; `cloudsave-public-service-prod06.ol.epicgames.com` |
| EPIC-3 | Update Checker | ✅ v3.0.1-pre | Re-fetch manifest, compare `buildVersion`; store `epic_manifest_version_{appName}` |
| EPIC-4 | DLC / Add-on Management | ⬜ | After EPIC-3; catalog API, mainGameItem filter |

### Amazon Games
| # | Job | Status | Notes |
|---|-----|--------|-------|
| AMAZON-1 | Update Checker | ✅ v3.0.1-pre | getGameDownload().versionId vs stored `amazon_manifest_version_{productId}` |
| AMAZON-2 | DLC Management | ⬜ | After AMAZON-1; soften GAME type filter in GetEntitlements |

### General / Cross-Store
| # | Job | Status | Notes |
|---|-----|--------|-------|
| GEN-1 | Auto-suggest Community Config on first launch | ⬜ | Check SP on launch, query worker `/list?game=` |
| GEN-2 | Backup all configs as ZIP | ⬜ | ZIP all `pc_g_setting*.xml` → `/sdcard/BannerHub/backup/` |
| GEN-3 | Component Update Checker | ⬜ | Compare installed vs API component versions |
| GEN-4 | Config profiles per game | ⬜ | Multiple named profiles per game in SP |
| GEN-5 | Playtime tracker | ⬜ | Log launch/close timestamps, show cumulative time |

### BH-Lite Port Tracker
| Job | BH Status | BH-Lite |
|-----|-----------|---------|
| D-1 Full-screen detail pages | ✅ | ⬜ |
| D-2 HTML description strip | ✅ | ⬜ |
| D-3 Install size | ✅ | ⬜ |
| D-5 Release date | ✅ | ⬜ |
| GOG-2 Update Checker | ✅ | ⬜ |
| GOG-3 DLC | ⬜ | — |
| GOG-1 Cloud Saves | ⬜ | — |
| EPIC-3 Update Checker | ✅ | ⬜ |
| EPIC-4 DLC | ⬜ | — |
| EPIC-2 Cloud Saves | ⬜ | — |
| EPIC-1 Free Games | ⬜ | — |
| AMAZON-1 Update Checker | ✅ | ⬜ |
| AMAZON-2 DLC | ⬜ | — |
| GEN-1–5 | ⬜ | — |

---

## GOG

### GOG-1: Cloud Saves
**Status:** ⬜ Not started — after GOG-3  
**Description:** Upload and download save files between the Wine prefix and GOG's cloud save service per game.  
**API:** GOG Galaxy cloud saves API (`api.gog.com/userData/{userId}/games/{gameId}/saves`)  
**Notes:**
- Need to identify save file locations per game (from Wine prefix or user-specified path)
- Upload: POST file → GOG cloud
- Download/restore: fetch → write to Wine prefix path
- Show last synced timestamp per game in library

**Progress Log:**
- 2026-04-14: `GogGameDetailActivity` scaffolding complete (v3.0.1-pre). CLOUD SAVES section exists as stub at line 145–146. Replace with upload/download UI once GOG-2 and GOG-3 are done.

---

### GOG-2: Game Update Checker
**Status:** ✅ v3.0.1-pre — confirmed working  
**Description:** Compare installed build ID against latest available on content-system. Show "Update available" badge and allow download.  
**API:** `content-system.gog.com/products/{gameId}/os/windows/builds`  
**Notes:**
- Installed build ID is stored at download time — need to persist it to SP
- Fetch latest build from content-system, compare
- If newer: show badge on game card + "Update" button in detail dialog
- Update = re-run existing download pipeline with latest manifest

**Progress Log:**
- 2026-04-14: `GogGameDetailActivity` scaffolding complete (v3.0.1-pre, commit `53a38f663`). UPDATES section exists as stub at line 137–138 (`makeStubCard("Update checker coming soon")`). Replace stub with real implementation: fetch builds endpoint, compare build ID stored in `bh_gog_prefs` as `gog_build_{gameId}`, show "Up to date" or "Update available" + Update button.

---

### GOG-3: DLC Management
**Status:** ⬜ Not started — after GOG-2  
**Description:** List owned DLCs per game and allow separate download + install.  
**API:** GOG library endpoint already returns DLC entries — currently filtered out  
**Notes:**
- DLCs are in the same library response, identified by `dlcs` array on parent product
- Show DLC list in game detail dialog with install status
- Download uses same content-system pipeline as base game

**Progress Log:**
- 2026-04-14: `GogGameDetailActivity` scaffolding complete (v3.0.1-pre). DLC section exists as stub at line 141–142. Replace with DLC list once GOG-2 is done.

---

### GOG-4: GOG Connect
**Status:** ⬜ Not started  
**Description:** Show Steam games the user owns that are claimable for free on GOG. Claim them with one tap.  
**API:** `api.gog.com/connect` — requires Steam session ticket + GOG auth  
**Notes:**
- Requires Steam login on device (complex dependency)
- Lower priority than other GOG features
- May not be feasible without Steam integration

**Progress Log:**
_(empty)_

---

## Epic Games

### EPIC-1: Free Games Section
**Status:** ⬜ Not started — separate from detail page work  
**Description:** Show current free games at top of Epic tab. Claim button adds to library using existing session.  
**API:** `store-site-backend-static-ipv4.ak.epicgames.com/freeGamesPromotions` (no auth needed for list)  
**Notes:**
- Fetch free games list on Epic tab open (or cache with TTL)
- Show as a "Free This Week" card row above the library
- Claim: POST to Epic's order endpoint using existing OAuth token
- Next free games (upcoming) can also be shown
- Lives in `EpicGamesActivity`, not the detail activity

**Progress Log:**
_(empty)_

---

### EPIC-2: Cloud Saves
**Status:** ⬜ Not started — after EPIC-3 and EPIC-4  
**Description:** Upload/download save files between Wine prefix and Epic cloud save service per game.  
**API:** Epic cloud saves via `cloudsave-public-service-prod06.ol.epicgames.com`  
**Notes:**
- Each game has a `cloudSaveFolder` defined in its manifest/catalog metadata
- Need to map Windows save path to Wine prefix equivalent
- Upload: PUT file to cloud save endpoint
- Download: GET + write to Wine prefix

**Progress Log:**
- 2026-04-14: `EpicGameDetailActivity` scaffolding complete (v3.0.1-pre, commit `53a38f663`). CLOUD SAVES stub at line 138–139. Replace once EPIC-3 and EPIC-4 are done.

---

### EPIC-3: Game Update Checker
**Status:** ✅ v3.0.1-pre — confirmed working  
**Description:** Compare installed manifest version against latest. Show update badge and allow download.  
**API:** Same manifest endpoint used during install — re-fetch and compare version field  
**Notes:**
- Store installed manifest version to SP at download time
- Re-fetch manifest on library sync and compare
- Update = re-run existing chunked download pipeline with new manifest

**Progress Log:**
- 2026-04-14: `EpicGameDetailActivity` scaffolding complete (v3.0.1-pre). UPDATES stub at line 132–133 (`makeStubCard("Update checker coming soon")`). SP key to store installed version: `epic_manifest_version_{appName}`. Re-fetch via `EpicApiClient.getManifestApiJson()`, parse version field, compare.

---

### EPIC-4: DLC / Add-on Management
**Status:** ⬜ Not started — after EPIC-3  
**Description:** List and install owned DLC separately from base game.  
**API:** Epic catalog API — DLCs are separate catalog items linked to base game  
**Notes:**
- Query catalog for items where `mainGameItem` matches the base game
- Filter to owned items only using existing entitlements check
- Download uses same chunked manifest pipeline

**Progress Log:**
- 2026-04-14: `EpicGameDetailActivity` scaffolding complete (v3.0.1-pre). DLC stub at line 135–136. Replace once EPIC-3 is done.

---

## Amazon Games

### AMAZON-1: Game Update Checker
**Status:** ✅ v3.0.1-pre — confirmed working  
**Description:** Compare installed manifest version against latest from Amazon. Show update badge and allow download.  
**API:** Same manifest.proto endpoint used during install  
**Notes:**
- Store installed manifest version to SP at download time
- Re-fetch on library sync and compare version field
- Update = re-run existing manifest + LZMA download pipeline

**Progress Log:**
- 2026-04-14: `AmazonGameDetailActivity` scaffolding complete (v3.0.1-pre, commit `53a38f663`). UPDATES stub at line 132–133 (`makeStubCard("Update checker coming soon")`). SP key to store installed version: `amazon_manifest_version_{productId}`. Re-fetch via `AmazonApiClient`, parse version from manifest proto, compare. No CLOUD SAVES section for Amazon (not supported).

---

### AMAZON-2: DLC Management
**Status:** ⬜ Not started — after AMAZON-1  
**Description:** Surface DLC entitlements per game and allow separate download + install.  
**API:** `GetEntitlements` already returns DLC — currently filtered out by `GAME` type check  
**Notes:**
- Remove or soften the type filter to also capture DLC entitlements
- Group DLCs under their parent game in the UI
- Download uses same manifest pipeline as base game

**Progress Log:**
- 2026-04-14: `AmazonGameDetailActivity` scaffolding complete (v3.0.1-pre). DLC stub at line 135–136. Replace once AMAZON-1 is done.

---

## General / Cross-Store

### GEN-1: Auto-suggest Community Config on First Launch
**Status:** ⬜ Not started  
**Description:** When a game has no config and community configs exist for it, prompt user to browse/apply one before launching.  
**Notes:**
- Check `pc_g_setting{gameId}` SP on launch — if empty/minimal, query worker `/list?game=`
- If results exist: show "Community configs available" dialog with count + Browse/Skip
- Skip: remember choice in SP so it doesn't prompt again

**Progress Log:**
_(empty)_

---

### GEN-2: Backup All Configs as ZIP
**Status:** ⬜ Not started  
**Description:** One-tap export of every game's config as a single ZIP to `/sdcard/BannerHub/backup/`. Restore from ZIP.  
**Notes:**
- Enumerate all `pc_g_setting*.xml` SP files
- ZIP them into `/sdcard/BannerHub/backup/bh_configs_YYYYMMDD.zip`
- Restore: unzip + write back to SP via existing `applyConfig()` logic

**Progress Log:**
_(empty)_

---

### GEN-3: Component Update Checker
**Status:** ⬜ Not started  
**Description:** Scan installed components against latest versions in component list. Show "X updates available" badge or prompt.  
**Notes:**
- Compare installed component version strings against latest in `getComponentList` API response
- Show indicator in Component Manager
- One-tap "Update all" or per-component update button

**Progress Log:**
_(empty)_

---

### GEN-4: Config Profiles Per Game
**Status:** ⬜ Not started  
**Description:** Multiple named profiles per game (e.g. "Performance", "Battery Saver"). Switch without re-importing.  
**Notes:**
- Store as `pc_g_setting{gameId}_profile_{name}` in SP
- Profile switcher in game settings sidebar
- Default profile = current unnamed settings (backwards compatible)

**Progress Log:**
_(empty)_

---

### GEN-5: Playtime Tracker
**Status:** ⬜ Not started  
**Description:** Log how long each game has been running. Show total playtime per game in library.  
**Notes:**
- Record start timestamp on game launch, compute delta on Wine activity close
- Store as `pc_playtime_{gameId}` in SP (cumulative seconds)
- Show formatted (e.g. "14h 32m") in game card or detail dialog

**Progress Log:**
_(empty)_

---

## BannerHub Lite Port Tracker

Once a feature is confirmed working in BannerHub (✅), it becomes a candidate for BH-Lite port. Record port status here.

| Feature | BH Status | BH-Lite Port Status | Notes |
|---------|-----------|---------------------|-------|
| GOG-1: Cloud Saves | ⬜ | — | |
| GOG-2: Update Checker | ⬜ | — | |
| GOG-3: DLC Management | ⬜ | — | |
| GOG-4: GOG Connect | ⬜ | — | Complex Steam dep |
| EPIC-1: Free Games | ⬜ | — | |
| EPIC-2: Cloud Saves | ⬜ | — | |
| EPIC-3: Update Checker | ⬜ | — | |
| EPIC-4: DLC Management | ⬜ | — | |
| AMAZON-1: Update Checker | ⬜ | — | |
| AMAZON-2: DLC Management | ⬜ | — | |
| GEN-1: Auto-suggest Config | ⬜ | — | |
| GEN-2: Config ZIP Backup | ⬜ | — | |
| GEN-3: Component Updates | ⬜ | — | |
| GEN-4: Config Profiles | ⬜ | — | |
| GEN-5: Playtime Tracker | ⬜ | — | |

---

## Completed Features Log

| Feature | Version | Date | Notes |
|---------|---------|------|-------|
| D-1 Full-screen detail pages (GOG/Epic/Amazon) | v3.0.1-pre | 2026-04-14 | Header, cover art, GAME INFO, ACTIONS, stubs |
| D-2 Strip HTML from descriptions | v3.0.1-pre | 2026-04-14 | `Html.fromHtml()` GOG+Epic |
| D-3 Install size in GAME INFO | v3.0.1-pre | 2026-04-14 | GOG: sync-time cache; Epic/Amazon: lazy+cached |
| D-5 Release date in GAME INFO | v3.0.1-pre | 2026-04-14 | GOG+Epic only; Amazon has no API source |
| GOG-2 Update Checker | v3.0.1-pre | 2026-04-14 | content-system builds endpoint; confirmed working |
| EPIC-3 Update Checker | v3.0.1-pre | 2026-04-14 | manifest buildVersion field; confirmed working |
| AMAZON-1 Update Checker | v3.0.1-pre | 2026-04-14 | getGameDownload versionId; confirmed working |

---
