> [!WARNING]
> **Only install official stable releases** (like this one). Do NOT install pre-releases or raw CI artifacts — pre-release builds use a different package name (`com.tencent.ig`) and cannot be upgraded to stable without uninstalling first.

> [!IMPORTANT]
> **Notification permission required.** BannerHub will prompt for the **Post Notifications** permission when you start your first Epic, GOG, or Amazon download. You must allow it to receive download progress and completion notifications. Without it, you will not be notified when downloads finish or fail.

> [!IMPORTANT]
> **Files access required for SD card storage.** To save games to your SD card, BannerHub must be granted the **Files and Media** permission. Go to **Android Settings → Apps → BannerHub → Permissions → Files and media** and set it to **Allow management of all files** (or equivalent on your device). Without this permission the SD card toggle will have no effect.

## Offline launch for imported PC games

**Imported PC games (and any non-Steam game source) now launch offline.**

Pre-3.7.5, putting the device in airplane mode or on a network without internet and tapping an imported PC game would abort the launch with `Game configuration file download failed`. Steam library games had a partial offline bypass already; the other four game source types (imported via the PC Game Manager, local-file import, server-downloaded, and unknown) did not.

v3.7.5 adds a no-network skip on the three setup tasks that previously required a network call: `GameConfigDownloadTask` (fetches per-game env config from the server), `SetGameRecommConfigTask` (applies server-pushed recommendations), and `DependencyInstallTask` (checks the server for new dep versions). When `NetworkUtils.r()` reports no network, those tasks are skipped and the launch proceeds with whatever components, container, and Wine version were set up the last time the game launched online.

In practice:

- **Any game that has launched online at least once will now launch offline.** Wine boots, the game runs, the previously-applied container settings persist.
- **Steam library games unaffected.** Their existing offline support is unchanged.
- **Self-healing on reconnect.** When you come back online, the next launch hits the full pipeline and re-syncs any server-pushed recommendations or dep updates. The offline window doesn't accumulate drift.
- **No behavior change online.** All three patches are pure additions wrapped in `if no network: skip; else: original code`. The online path runs the original 3.7.4 logic byte-for-byte. Verified by code review and pre1→pre4 device iteration.

### Known limitations

1. **First-ever launches still require network** — if a game has never been set up at all, no components/container are on disk to fall back to. This release only fixes the second-and-later offline launches.
2. **Stale per-game settings** — if you change a per-game setting (Box64 variant, container, etc.) and then go offline before the next launch, the offline launch uses the previous on-disk setup. Workaround: relaunch once online after changing settings, then go offline.
3. **Server-pushed component recommendations skipped offline** — practical impact nil for games already working; deferred to the next online launch.

### Tracking BannerHub updates

- **This GitHub repo's [Releases page](https://github.com/The412Banner/BannerHub/releases)** — watch the repo to get notified
- **[Obtainium](https://github.com/ImranR98/Obtainium)** — add `https://github.com/The412Banner/BannerHub` as an app source with **"Reconcile version string with version detected from OS"** enabled

### Upgrading

- v3.7.4 → v3.7.5: install the matching variant directly over your existing install. No certificate change, no data loss.
- v3.7.0 or earlier → v3.7.5: install normally. If the signing certificate differs, uninstall first.
