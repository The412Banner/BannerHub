/*
 * libevshim.so — guest-side SDL rumble keepalive for BannerHub
 *
 * Adapted from GameNative PR #1214 (TideGear) for BannerHub's GameHub bridge.
 *
 * Why:
 *   Wine games' rumble path is: XInput → winebus.so → SDL_JoystickRumble →
 *   libvfs.so's registered VirtualJoystick.Rumble callback → AF_UNIX IPC →
 *   GameHub host → Android Vibrator. SDL2 internally auto-expires rumble
 *   ~1000 ms after each SDL_JoystickRumble call by invoking the Rumble
 *   callback again with (0, 0). The host treats that as "rumble stopped"
 *   and cancels the motors; the rumble cuts out at exactly 1 second on
 *   what should be sustained vibration.
 *
 * What this shim does:
 *   Interposes SDL_JoystickRumble via LD_PRELOAD. Records the last (low,
 *   high) per joystick. A background thread re-issues those values every
 *   500 ms with a 2000 ms duration so SDL's internal expiry is reset
 *   before it can fire. When (0, 0) arrives (real game-driven stop),
 *   the slot is cleared so keepalive stops re-firing.
 *
 *   Also wraps SDL_JoystickClose to evict slot entries when a game
 *   closes a controller — prevents keepalive from calling a stale
 *   joystick handle.
 *
 * Why this design (vs PR #1214's evshim):
 *   GameHub already has the SDL VirtualJoystick + IPC bridge wired up in
 *   libvfs.so's gamepad_manager — we don't need to register a new
 *   VirtualJoystickDesc.Rumble callback or write to gamepad.mem. We
 *   only need to keep SDL's timer from expiring.
 */

#define _GNU_SOURCE

#include <android/log.h>
#include <dlfcn.h>
#include <elf.h>
#include <errno.h>
#include <fcntl.h>
#include <link.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

/* Opaque SDL2 type — we never dereference, just pass through. */
typedef struct SDL_Joystick SDL_Joystick;

#define MAX_SLOTS              4
#define KEEPALIVE_INTERVAL_US  (500 * 1000)   /* 500 ms */
#define KEEPALIVE_DURATION_MS  2000           /* must exceed SDL's ~1 s expiry */

/* EVSHIM_DIAG=1 enables on-event diagnostic logs (first-call trace, GOT
 * patcher progress lines, winebus map dumps). EVSHIM_DIAG=0 strips them
 * at compile time for release builds. Override via -DEVSHIM_DIAG=0 in
 * CMake. Default 1 — these are cheap and have repeatedly proven useful
 * when chasing patcher-vs-loader interactions. */
#ifndef EVSHIM_DIAG
#define EVSHIM_DIAG 1
#endif

/* Log volume guideline: keep startup output to ~3 lines per Wine
 * subprocess + on-event lines only. High-frequency logging during init
 * (e.g. per-tick polling output) has previously starved Java's
 * processExited() pipe-drainer and tripped BannerHub's startup watchdog,
 * resulting in SIGKILL of the whole Wine tree. */
#define LOG(fmt, ...) __android_log_print(ANDROID_LOG_INFO, "evshim", fmt, ##__VA_ARGS__)
#define LOGE(fmt, ...) __android_log_print(ANDROID_LOG_ERROR, "evshim", fmt, ##__VA_ARGS__)

static int  (*real_SDL_JoystickRumble)(SDL_Joystick *, uint16_t, uint16_t, uint32_t) = NULL;
static void (*real_SDL_JoystickClose)(SDL_Joystick *) = NULL;

struct slot {
    SDL_Joystick *js;   /* NULL when free */
    uint16_t      low;
    uint16_t      high;
};

static struct slot g_slots[MAX_SLOTS];
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;
static pthread_once_t  g_keepalive_once = PTHREAD_ONCE_INIT;
static pthread_t       g_keepalive_tid;

static void resolve_real(void)
{
    if (!real_SDL_JoystickRumble) {
        real_SDL_JoystickRumble = dlsym(RTLD_NEXT, "SDL_JoystickRumble");
    }
    if (!real_SDL_JoystickClose) {
        real_SDL_JoystickClose = dlsym(RTLD_NEXT, "SDL_JoystickClose");
    }
}

/* Caller must hold g_lock. */
static int find_or_alloc_slot(SDL_Joystick *js)
{
    int free_idx = -1;
    for (int i = 0; i < MAX_SLOTS; i++) {
        if (g_slots[i].js == js) return i;
        if (g_slots[i].js == NULL && free_idx < 0) free_idx = i;
    }
    if (free_idx >= 0) {
        g_slots[free_idx].js = js;
        g_slots[free_idx].low = 0;
        g_slots[free_idx].high = 0;
    }
    return free_idx;
}

/* Caller must hold g_lock. */
static void free_slot_for(SDL_Joystick *js)
{
    for (int i = 0; i < MAX_SLOTS; i++) {
        if (g_slots[i].js == js) {
            g_slots[i].js = NULL;
            g_slots[i].low = 0;
            g_slots[i].high = 0;
            return;
        }
    }
}

static void *keepalive_thread(void *arg)
{
    (void)arg;
    LOG("keepalive thread running\n");

    for (;;) {
        usleep(KEEPALIVE_INTERVAL_US);

        /* Snapshot under the lock to keep the real SDL call outside the
         * critical section. Race window with a stop arriving mid-snapshot
         * is bounded to one keepalive tick — host will see one extra
         * (low, high) frame followed by the legitimate (0, 0). */
        struct slot snap[MAX_SLOTS];
        int snap_n = 0;
        pthread_mutex_lock(&g_lock);
        for (int i = 0; i < MAX_SLOTS; i++) {
            if (g_slots[i].js && (g_slots[i].low | g_slots[i].high)) {
                snap[snap_n++] = g_slots[i];
            }
        }
        pthread_mutex_unlock(&g_lock);

        if (!real_SDL_JoystickRumble) continue;

        for (int i = 0; i < snap_n; i++) {
            (void)real_SDL_JoystickRumble(snap[i].js, snap[i].low, snap[i].high,
                                          KEEPALIVE_DURATION_MS);
        }
    }
    return NULL;
}

static void start_keepalive(void)
{
    int rc = pthread_create(&g_keepalive_tid, NULL, keepalive_thread, NULL);
    LOG("pthread_create rc=%d (0=ok)\n", rc);
    if (rc == 0) {
        pthread_detach(g_keepalive_tid);
    } else {
        LOG("pthread_create failed: %s\n", strerror(errno));
    }
}

/* ─── interposed symbols ──────────────────────────────────────────────── */

int SDL_JoystickRumble(SDL_Joystick *js, uint16_t low_freq, uint16_t high_freq,
                       uint32_t duration_ms)
{
#if EVSHIM_DIAG
    /* Trace the first few calls so we can prove interposition is happening
     * (and via which thread). */
    static int s_diag_count = 0;
    if (s_diag_count < 6) {
        LOG("SDL_JoystickRumble call#%d: js=%p low=%u high=%u dur=%ums\n",
            s_diag_count, (void *)js, low_freq, high_freq, duration_ms);
        s_diag_count++;
    }
#endif

    resolve_real();
    if (!real_SDL_JoystickRumble) {
        LOG("real SDL_JoystickRumble not found via dlsym(RTLD_NEXT)\n");
        return -1;
    }

    /* Lazy-start the keepalive thread on the first rumble call so the
     * thread doesn't run in Wine processes that never touch a controller. */
    pthread_once(&g_keepalive_once, start_keepalive);

    pthread_mutex_lock(&g_lock);
    int idx = find_or_alloc_slot(js);
    if (idx >= 0) {
        if (low_freq == 0 && high_freq == 0) {
            /* Real game-driven stop — clear the slot so keepalive doesn't
             * keep firing. (SDL's auto-expiry never reaches us because the
             * keepalive resets SDL's internal timer well before the 1 s
             * mark; only the game's own SDL_JoystickRumble(_,0,0,_) call
             * gets here with zeros.) */
            g_slots[idx].js = NULL;
            g_slots[idx].low = 0;
            g_slots[idx].high = 0;
        } else {
            g_slots[idx].low = low_freq;
            g_slots[idx].high = high_freq;
        }
    }
    pthread_mutex_unlock(&g_lock);

    return real_SDL_JoystickRumble(js, low_freq, high_freq, duration_ms);
}

void SDL_JoystickClose(SDL_Joystick *js)
{
    resolve_real();

    pthread_mutex_lock(&g_lock);
    free_slot_for(js);
    pthread_mutex_unlock(&g_lock);

    if (real_SDL_JoystickClose) {
        real_SDL_JoystickClose(js);
    }
}

/* ─── GOT/.bss patcher for winebus.so ─────────────────────────────────────
 *
 * Linker-free: bionic's loader interacts poorly with Wine's, so we avoid
 * dl_iterate_phdr / dlopen interpose / dlsym during init. Instead:
 *   - Read /proc/self/maps to find winebus.so's load address (just file
 *     I/O, no locks held).
 *   - Walk the in-memory ELF directly via e_phoff → PT_LOAD program
 *     headers, scanning writable segments for the dlsym'd pSDL_*
 *     function pointers (winebus uses dlopen+dlsym, not static linking).
 *   - mprotect the page writable, overwrite each match.
 *
 * Single one-shot attempt 5 seconds after libevshim's constructor on a
 * detached thread that exits immediately after attempting. No periodic
 * activity, no dl_iterate_phdr, no dlopen interpose, no ongoing thread.
 * Empirically winebus.so loads ~62 ms after evshim's ctor in
 * winedevice.exe, so 5 s is generous.
 */

static int s_winebus_patched = 0;

/* Find the ELF base address (lowest mapping) of winebus.so in /proc/self/maps.
 * Returns 1 with *out_base set on success, 0 if not found. No locks.
 *
 * Why lowest, not r-xp: bionic mmaps the .so as multiple PT_LOAD
 * segments; the first segment (lowest address) contains the ELF header
 * (file offset 0), typically mapped r--p. The r-xp mapping is the
 * .text segment, which lives at a higher address and starts partway
 * into the file — its first bytes are code, not ELFMAG.
 *
 * Diagnostics: log every winebus.so candidate line (capped at 6) so we
 * can see whether the lib is loaded and which mapping perms appear. */
static int find_winebus_base(uintptr_t *out_base)
{
    FILE *f = fopen("/proc/self/maps", "r");
    if (!f) return 0;
    char line[1024];
    uintptr_t lowest = 0;
    int found = 0;
    int candidates = 0;
    while (fgets(line, sizeof(line), f)) {
        /* Format: "start-end perms offset dev inode pathname" */
        if (!strstr(line, "winebus.so")) continue;
        unsigned long start, end;
        if (sscanf(line, "%lx-%lx", &start, &end) != 2) continue;
        if (candidates < 6) {
            /* Strip trailing newline for cleaner log output. */
            size_t L = strlen(line);
            if (L > 0 && line[L - 1] == '\n') line[L - 1] = '\0';
            LOG("winebus map: %s", line);
            candidates++;
        }
        if (!found || (uintptr_t)start < lowest) {
            lowest = (uintptr_t)start;
            found = 1;
        }
    }
    fclose(f);
    if (found) *out_base = lowest;
    return found;
}

/* Read /proc/self/cmdline and copy the basename of argv[0] into `out` for
 * diagnostic logging. This lets us correlate which Wine PE module each
 * patcher firing corresponds to (services.exe, winedevice.exe, etc.). */
static void read_self_cmdline(char *out, size_t out_size)
{
    out[0] = '\0';
    FILE *f = fopen("/proc/self/cmdline", "r");
    if (!f) return;
    char buf[512];
    size_t n = fread(buf, 1, sizeof(buf) - 1, f);
    fclose(f);
    if (n == 0) return;
    buf[n] = '\0';
    /* cmdline uses NUL separators; we just want enough to identify. Replace
     * NULs with spaces for readability, capped at out_size. */
    for (size_t i = 0; i < n && i + 1 < out_size; i++) {
        out[i] = buf[i] ? buf[i] : ' ';
        out[i + 1] = '\0';
    }
}

/* Patch winebus.so so its calls to SDL_JoystickRumble (and
 * SDL_JoystickClose) go through our wrappers.
 *
 * winebus.so doesn't link against libSDL2-2.0.so directly (no NEEDED entry,
 * no relocation for SDL_JoystickRumble in DT_JMPREL or DT_RELA). Instead
 * sdl_bus_init dlopens libSDL2 and dlsym's each function name into a
 * static `pSDL_*` table in .bss; call sites do `(*pSDL_JoystickRumble)(...)`.
 * So there's no GOT entry to patch via relocations — we patch the
 * function-pointer table directly after winebus has populated it.
 *
 * Strategy:
 *   1. Walk PT_LOAD program headers in memory; find writable segments.
 *   2. Scan each writable segment 8-byte-aligned for any qword matching
 *      one of our targets (libSDL2's exported symbol addresses — what
 *      winebus's dlsym call returned for the same names).
 *   3. mprotect, overwrite each match with our corresponding wrapper.
 *
 * Targets: SDL_JoystickRumble (always — primary purpose) and
 * SDL_JoystickClose (so g_slots entries get evicted when winebus closes
 * a joystick — without this our slot table can hold stale js pointers).
 *
 * Why scanning is safe: each target address is a 64-bit value. False
 * positives in random data are ~1/2^64 — effectively impossible. We also
 * confine the scan to winebus.so's own writable segments, so we never
 * touch other libraries' data. */
static int patch_winebus_at_base(uintptr_t base)
{
    const ElfW(Ehdr) *eh = (const ElfW(Ehdr) *)base;
    if (eh->e_ident[EI_MAG0] != ELFMAG0 || eh->e_ident[EI_MAG1] != ELFMAG1 ||
        eh->e_ident[EI_MAG2] != ELFMAG2 || eh->e_ident[EI_MAG3] != ELFMAG3) {
        LOGE("winebus base=%p not ELF", (void *)base);
        return 0;
    }
    if (!real_SDL_JoystickRumble) {
        LOG("winebus: real_SDL_JoystickRumble unresolved — skipping scan");
        return 0;
    }

    /* Build target table: (target_addr, replacement_addr, name).
     * SDL_JoystickClose is best-effort — if dlsym(RTLD_NEXT) didn't find
     * it (e.g. older SDL2), skip that target rather than failing the
     * whole patch. */
    struct {
        uintptr_t target;
        uintptr_t replacement;
        const char *name;
    } targets[2];
    int target_n = 0;
    targets[target_n].target      = (uintptr_t)real_SDL_JoystickRumble;
    targets[target_n].replacement = (uintptr_t)&SDL_JoystickRumble;
    targets[target_n].name        = "pSDL_JoystickRumble";
    target_n++;
    if (real_SDL_JoystickClose) {
        targets[target_n].target      = (uintptr_t)real_SDL_JoystickClose;
        targets[target_n].replacement = (uintptr_t)&SDL_JoystickClose;
        targets[target_n].name        = "pSDL_JoystickClose";
        target_n++;
    }

    const ElfW(Phdr) *ph = (const ElfW(Phdr) *)(base + eh->e_phoff);
    long page_size = sysconf(_SC_PAGESIZE);
    int total_segments = 0;
    size_t total_bytes = 0;
    int patched = 0;

    /* Locate PT_GNU_RELRO ranges first. A writable PT_LOAD covered (in whole
     * or part) by PT_GNU_RELRO is downgraded to PROT_READ after relocation
     * processing — that's where .data.rel.ro / .got / .got.plt live. We
     * MUST NOT scan or modify those pages: they hold relocated immutable
     * pointers, not dlsym'd ones, and degrading their RO permanently would
     * weaken the binary's exploit mitigations for the lifetime of the
     * process. pSDL_* lives in .bss which is in a separate non-RELRO
     * writable PT_LOAD. */
    uintptr_t relro_starts[4];
    uintptr_t relro_ends[4];
    int relro_n = 0;
    for (int i = 0; i < eh->e_phnum && relro_n < 4; i++) {
        if (ph[i].p_type != PT_GNU_RELRO) continue;
        relro_starts[relro_n] = base + ph[i].p_vaddr;
        relro_ends[relro_n]   = base + ph[i].p_vaddr + ph[i].p_memsz;
        relro_n++;
    }

    for (int i = 0; i < eh->e_phnum; i++) {
        if (ph[i].p_type != PT_LOAD) continue;
        if (!(ph[i].p_flags & PF_W)) continue;

        uintptr_t seg_start = base + ph[i].p_vaddr;
        size_t    seg_size  = ph[i].p_memsz;
        if (seg_size < sizeof(uintptr_t)) continue;
        total_segments++;
        total_bytes += seg_size;

        /* Scan 8-byte aligned. seg_start is page-aligned by ELF rules so
         * already qword-aligned, but be defensive. */
        uintptr_t scan_start = (seg_start + 7) & ~(uintptr_t)7;
        uintptr_t scan_end   = seg_start + seg_size - sizeof(uintptr_t);

        for (uintptr_t p = scan_start; p <= scan_end; p += sizeof(uintptr_t)) {
            uintptr_t *slot = (uintptr_t *)p;
            uintptr_t value = *slot;

            /* Match against any target. */
            int t_idx = -1;
            for (int t = 0; t < target_n; t++) {
                if (value == targets[t].target) { t_idx = t; break; }
            }
            if (t_idx < 0) continue;

            /* Skip if this slot falls inside a RELRO range. */
            int in_relro = 0;
            for (int r = 0; r < relro_n; r++) {
                if (p >= relro_starts[r] && p < relro_ends[r]) {
                    in_relro = 1;
                    break;
                }
            }
            if (in_relro) {
                LOG("winebus scan: skipping match at %p — inside PT_GNU_RELRO",
                    (void *)slot);
                continue;
            }

            uintptr_t page_addr = p & ~((uintptr_t)page_size - 1);
            /* Page is in a non-RELRO writable PT_LOAD (.data or .bss),
             * already PROT_READ|PROT_WRITE. mprotect-to-RW is a no-op for
             * normal pages and acts as a belt-and-suspenders. */
            if (mprotect((void *)page_addr, (size_t)page_size,
                         PROT_READ | PROT_WRITE) != 0) {
                LOGE("winebus scan: mprotect rw failed at %p: %s",
                     (void *)page_addr, strerror(errno));
                continue;
            }
            *slot = targets[t_idx].replacement;
            /* No mprotect-back: the page's natural state is RW (it's .data
             * or .bss, not RELRO'd). winebus may legitimately rewrite its
             * own pSDL table during shutdown — re-applying PROT_READ would
             * crash it. Pages we'd be tempted to restore-to-RO are skipped
             * by the relro_starts[] check above. */

            LOG("got_patch winebus.so: %s slot=%p old=0x%lx new=0x%lx",
                targets[t_idx].name, (void *)slot,
                (unsigned long)targets[t_idx].target,
                (unsigned long)targets[t_idx].replacement);
            patched++;
        }
    }

    LOG("winebus scan: %d writable segments, %zu bytes, %d slots patched",
        total_segments, total_bytes, patched);
    return patched > 0;
}

/* Write a "winedevice ready" marker file so BannerHub Java side knows
 * libvfs-client has finished initializing in this winedevice process and
 * is ready to receive GamepadState writes. BhVibrationController watches
 * for this marker (FileObserver) and then fires its synthetic axis-flicker
 * wake-up — replacing the previous fragile multi-shot timing approach.
 *
 * Path: ${BH_FILES_DIR}/.bh_winedevice_ready (BH_FILES_DIR set by Tencent's
 * launch code, == /data/user/0/<pkg>/files). Falls back to deriving from
 * WINEMU_ROOT_FS, then to a hardcoded com.tencent.ig path. unlink+create
 * to guarantee a fresh CREATE inotify event on respawns where the marker
 * already exists from the previous winedevice incarnation. */
static void write_ready_marker(void)
{
    char path[512];
    const char *root = getenv("BH_FILES_DIR");
    if (root && *root) {
        snprintf(path, sizeof(path), "%s/.bh_winedevice_ready", root);
    } else if ((root = getenv("WINEMU_ROOT_FS")) != NULL && *root) {
        snprintf(path, sizeof(path), "%s/files/.bh_winedevice_ready", root);
    } else {
        snprintf(path, sizeof(path),
                 "/data/user/0/com.tencent.ig/files/.bh_winedevice_ready");
    }
    /* Force a fresh CREATE event even if a stale marker exists. */
    unlink(path);
    int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd < 0) {
        LOGE("ready marker open failed: %s (errno=%d, %s)",
             path, errno, strerror(errno));
        return;
    }
    char buf[64];
    int n = snprintf(buf, sizeof(buf), "pid=%d\n", (int)getpid());
    if (n > 0) (void)write(fd, buf, (size_t)n);
    close(fd);
    LOG("wrote ready marker: %s", path);
}

/* One-shot patcher thread. Runs exactly once, 5 seconds after spawn,
 * then exits. No polling, no periodic activity. */
static void *one_shot_patcher_thread(void *arg)
{
    (void)arg;
    sleep(5);
    if (s_winebus_patched) return NULL;

    char cmd[256];
    read_self_cmdline(cmd, sizeof(cmd));
    LOG("patcher fire pid=%d cmd=%s", (int)getpid(), cmd);

    uintptr_t base = 0;
    if (!find_winebus_base(&base)) {
        LOG("patcher: winebus.so not loaded in pid=%d", (int)getpid());
        return NULL;
    }
    LOG("patcher: winebus.so base=0x%lx pid=%d", (unsigned long)base, (int)getpid());
    if (patch_winebus_at_base(base)) {
        s_winebus_patched = 1;
        /* Patch landed → libvfs-client is fully initialized in this
         * winedevice process (winebus.so is loaded after libvfs init).
         * Tell Java side the shared GamepadState buffer is now safe to
         * write to. */
        write_ready_marker();
        /* NOTE: SDL_PushEvent(SDL_JOYDEVICEADDED) wake-up was tried here
         * (commit c6028a7) but reverted — winebus's sdl_add_device does
         * NOT dedupe on instance id, so re-emitting JOYDEVICEADDED for
         * already-opened slots caused the tester to see 4+ controllers
         * in a 2-controller setup. Multi-controller users currently need
         * to press one button per controller on first use to trigger
         * Wine's HID re-enumeration; single-controller works without. */
    }
    return NULL;
}

/* Heuristic: does this Wine subprocess plausibly need SDL2 loaded into
 * the global namespace? We use the /proc/self/cmdline contents to skip
 * obvious system services (wineserver, services.exe, plugplay.exe,
 * svchost.exe, explorer.exe, rpcss.exe, tabtip.exe, jwm) that never
 * touch HID/gamepad input. winedevice.exe DOES need SDL2 (it loads
 * winebus.so which dlopens SDL2), and so do the actual game .exe's,
 * which we accept as the default-true case.
 *
 * Skipping the preload in ~7 of ~10 Wine subprocesses avoids loading
 * libSDL2 + transitives (libpulse, libasound, libdbus, etc.) into
 * processes that will never use them. */
static int proc_needs_sdl(void)
{
    char cmd[256];
    read_self_cmdline(cmd, sizeof(cmd));
    /* Process-name suffixes we know don't use SDL — match case-insensitively
     * since Windows-side paths can be either. */
    static const char * const skip_markers[] = {
        "wineserver",
        "services.exe",
        "plugplay.exe",
        "svchost.exe",
        "explorer.exe",
        "rpcss.exe",
        "tabtip.exe",
        "/jwm ",
        "/jwm",
        NULL,
    };
    for (int i = 0; skip_markers[i]; i++) {
        if (strstr(cmd, skip_markers[i])) {
            return 0;
        }
    }
    return 1;
}

/* Force libSDL2-2.0.so into the global linker namespace before libvfs.so
 * gets a chance to dlopen it RTLD_LOCAL. Without this, libvfs.so's later
 * dlopen with default flags creates a private namespace; winebus.so's
 * NEEDED libSDL2 dependency then reuses that private instance and winebus's
 * SDL_JoystickRumble lookups never reach our LD_PRELOAD'd shim.
 *
 * We try the unqualified name first (relying on the linker's search path)
 * then fall back to an absolute path derived from WINEMU_ROOT_FS env var. */
static void preload_sdl_global(void)
{
    void *h = dlopen("libSDL2-2.0.so", RTLD_NOW | RTLD_GLOBAL);
    if (h) {
        LOG("preload: dlopen libSDL2-2.0.so RTLD_GLOBAL ok h=%p\n", h);
        return;
    }
    const char *err1 = dlerror();
    const char *root = getenv("WINEMU_ROOT_FS");
    if (root && *root) {
        char path[512];
        snprintf(path, sizeof(path), "%s/files/usr/lib/libSDL2-2.0.so", root);
        h = dlopen(path, RTLD_NOW | RTLD_GLOBAL);
        if (h) {
            LOG("preload: dlopen %s RTLD_GLOBAL ok h=%p\n", path, h);
            return;
        }
        LOG("preload: both dlopens failed (1) %s (2) %s\n", err1 ? err1 : "?", dlerror());
    } else {
        LOG("preload: dlopen libSDL2-2.0.so failed (%s) and WINEMU_ROOT_FS not set\n",
            err1 ? err1 : "?");
    }
}

/* Spawn the one-shot patcher thread. Pulled out of the ctor so the
 * pthread_atfork child handler can re-arm it after a fork()-without-exec
 * (POSIX kills all threads but the caller in the child, so the patch
 * never runs in a forked Wine subprocess otherwise). */
static void spawn_patcher_thread(void)
{
    pthread_t tid;
    if (pthread_create(&tid, NULL, one_shot_patcher_thread, NULL) == 0) {
        pthread_detach(tid);
    } else {
        LOGE("spawn_patcher: pthread_create failed: %s", strerror(errno));
    }
}

/* Called in the child after fork() returns. POSIX wipes all non-caller
 * threads, so any keepalive thread already-started in the parent is gone
 * — pthread_once still thinks start_keepalive ran though, so the keepalive
 * is silently dead in the child. Reset the once-control AND re-spawn the
 * patcher thread (the patch state is also gone in the child since memory
 * was COW'd before fork — actually s_winebus_patched IS preserved across
 * fork because it's set after the patch lands; if the parent already
 * patched, the child inherits the patched memory, so we shouldn't re-patch.
 * We DO need to re-arm the keepalive on first rumble though). */
static void evshim_atfork_child(void)
{
    /* Reset keepalive once-control so the next SDL_JoystickRumble call
     * re-spawns the keepalive thread in the child. */
    pthread_once_t fresh = PTHREAD_ONCE_INIT;
    g_keepalive_once = fresh;
    /* If winebus wasn't patched in the parent at fork time, the parent's
     * patcher thread is gone in the child — re-spawn so we still get a
     * shot at patching post-fork. If the parent DID patch, the patched
     * .bss memory is COW-inherited, so the child's calls already go
     * through our wrapper; the re-spawned thread will scan, find the
     * already-replaced pointer (== our wrapper, not the libSDL2 target),
     * fail to match, and exit harmlessly. */
    if (!s_winebus_patched) {
        spawn_patcher_thread();
    }
}

__attribute__((constructor))
static void evshim_ctor(void)
{
    LOG("loaded pid=%d", (int)getpid());
    if (!proc_needs_sdl()) {
        LOG("ctor: skipping SDL preload + patcher — process doesn't need it");
        return;
    }
    /* Promote libSDL2 to global scope BEFORE resolve_real so dlsym(RTLD_NEXT)
     * has something to find. */
    preload_sdl_global();
    resolve_real();
    LOG("ctor resolved real_SDL_JoystickRumble=%p", (void *)real_SDL_JoystickRumble);

    /* Register child-side fork handler before spawning any threads so a
     * fork-no-exec child can re-arm the keepalive. */
    if (pthread_atfork(NULL, NULL, evshim_atfork_child) != 0) {
        LOGE("ctor: pthread_atfork failed: %s", strerror(errno));
    }

    /* Spawn the one-shot patcher thread. Sleeps 5 s, reads /proc/self/maps
     * to find winebus.so, walks its in-memory ELF, patches the .bss slot
     * for pSDL_JoystickRumble. Single attempt. Thread exits after one try.
     *
     * In Wine subprocesses that don't load winebus.so (most of them),
     * find_winebus_base returns 0 and the thread quietly exits. Only
     * winedevice.exe will actually patch.
     */
    spawn_patcher_thread();
}
