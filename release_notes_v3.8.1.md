> [!WARNING]
> **Only install official stable releases** (like this one). Do NOT install pre-releases or raw CI artifacts — pre-release builds use a different package name (`com.tencent.ig`) and cannot be upgraded to stable without uninstalling first.

> [!IMPORTANT]
> **Microphone permission required for Voice Chat.** When you activate voice chat (dashboard → Game Configs → Voice Chat), BannerHub will prompt for the **Microphone** permission. You must allow it for in-game calls to work — without it the call falls back to opening in your browser.

> [!IMPORTANT]
> **Notification permission required.** BannerHub will prompt for the **Post Notifications** permission when you start your first Epic, GOG, or Amazon download. You must allow it to receive download progress and completion notifications.

> [!IMPORTANT]
> **Files access required for SD card storage.** To save games to your SD card, BannerHub must be granted the **Files and Media** permission (Android Settings → Apps → BannerHub → Permissions → Files and media → Allow management of all files). Without it the SD card toggle has no effect.

## 🛠️ Games work on the new GameHub firmware (1.4.8 / 1.4.9)

With the **GameHub** API source, a fresh install downloads GameHub's newest firmware (1.4.8 or 1.4.9). That firmware **removes `libGameScopeVK.so`**. BannerHub points games at that graphics library, and the AI Frame Generation engine lives in it. On v3.8.0 **every game closed a few seconds after launching** (OpenGL titles crashed outright), and AI Frame Generation was gone.

- **Automatic restore.** BannerHub now carries its own copy of the library (the one shipped in firmware 1.3.7 – 1.4.2) and puts it back before each game launch whenever it's missing. Games start again and **AI Frame Generation keeps working**, with the same engine as before.
- **Future-proof.** If a later firmware removes or renames the library again, BannerHub restores it the same way. A library the firmware provides itself is never replaced.
- **Nothing to do.** No reinstall and no settings change: update, then launch a game.

**Validation:** fresh install on firmware 1.4.9 with the GameHub API source. BannerHub restored the library on the first launch, games ran, and AI Frame Generation worked.

## 💾 SD card toggle works without a GHL folder

**Save Store Games to External Storage (SD Card)** used to say *"No SD card found"* unless the card already had a `GHL` folder at its root (an old GameHub convention). BannerHub now accepts any writable SD card and creates the `bannerhub/` folder itself. That's the folder GOG, Epic and Amazon games install into (`{SD card}/bannerhub/{store}/{game}/`). Internal storage is never mistaken for the SD card, and Steam storage is unaffected.

## 🧩 Component Manager: removed components stay removed

Removing a component (single remove or **Remove All**) now also clears it from GameHub's saved component registry, so it no longer comes back after the app restarts.

## Credits

- **SD card detection fix:** **[tirsomb](https://github.com/tirsomb)** via [PR #108 "fix: detect writable SD card without GHL marker"](https://github.com/The412Banner/BannerHub/pull/108), found and tested on an LG V60.
- AI Frame Generation engine by the **GameHub team**. All v3.8.0 features (in-game voice chat, per-game PC Audio Settings) remain active.

### Tracking BannerHub updates

- **This repo's [Releases page](https://github.com/The412Banner/BannerHub/releases)** — watch the repo to get notified.
- **[Obtainium](https://github.com/ImranR98/Obtainium)** — add `https://github.com/The412Banner/BannerHub` as an app source with **"Reconcile version string with version detected from OS"** enabled.

### Upgrading

- **v3.8.0 → v3.8.1:** install the matching variant directly over your existing install. No certificate change, no data loss.
- **v3.7.0 or earlier → v3.8.1:** install normally. If the signing certificate differs, uninstall first.

---

For the in-game voice chat and per-game PC Audio Settings added in v3.8.0, see the [v3.8.0 release notes](https://github.com/The412Banner/BannerHub/releases/tag/v3.8.0).
