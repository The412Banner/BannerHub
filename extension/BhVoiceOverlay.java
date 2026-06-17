package com.xj.winemu.sidebar;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.SystemClock;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Chronometer;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * In-game voice-chat pill for BannerHub (5.3.5 base).
 *
 * <p>A Banner-owned draggable pill on the side of the screen — the same
 * {@link WindowManager} {@code TYPE_APPLICATION_PANEL} technique as the v6
 * overlay — attached over the Wine game surface from
 * {@code WineActivity.onResume()}. Tapping the pill slides out a small panel.
 *
 * <p>Unlike v6 (which called Steam friends and rang them), this is a
 * <b>room model</b>: there is no Steam friends list and no ringing. You set your
 * nickname once in the dashboard "Voice Chat" screen, then in-game you either
 * <b>Create</b> a room (get a short code) or <b>Join</b> one by code, and
 * <b>Share</b> the link so others — including non-app users in a browser — can
 * join the same WebRTC mesh. The actual audio runs in {@link BhVoiceController}
 * (a hidden WebView talking to the bannerhub-api worker), exactly the same
 * engine/worker/TURN as v6.
 *
 * <p>The pill only attaches when the user has claimed a nickname and ticked the
 * activation box ({@link BhVoicePrefs#pillEnabled}); the {@code WineActivity}
 * hook checks that before calling {@link #attach}.
 */
public final class BhVoiceOverlay implements BhVoiceController.Host {

    private static final String TAG = "BhVoice";

    private static final int COL_BG      = 0xF21A1D24;
    private static final int COL_PILL    = 0xF22A2E38;
    private static final int COL_ACCENT  = 0xFF2D6CDF;
    private static final int COL_GREEN   = 0xFF90BA3C;
    private static final int COL_TEXT    = 0xFFEFEFEF;
    private static final int COL_SUBTEXT = 0xFF9AA0AC;
    private static final int COL_RED     = 0xFFE05B5B;

    /** One overlay per game session; replaced on each attach. */
    private static BhVoiceOverlay current;

    /** Attach the pill to {@code act} if voice is enabled. Idempotent per activity. */
    public static void attach(Activity act) {
        try {
            boolean en = act != null && BhVoicePrefs.pillEnabled(act);
            Log.i(TAG, "voice attach() called; pillEnabled=" + en
                    + " nick='" + (act != null ? BhVoicePrefs.nickname(act) : "") + "'");
            if (!en) return;
            if (current != null && current.act == act && current.attached) return;
            detach();
            current = new BhVoiceOverlay(act);
            current.attachInternal();
        } catch (Throwable t) {
            Log.w(TAG, "voice overlay attach failed", t);
        }
    }

    /** Tear down the current overlay (call from WineActivity.onDestroy). */
    public static void detach() {
        try {
            if (current != null) { current.cleanup(); current = null; }
        } catch (Throwable ignored) {}
    }

    private final Activity act;
    private final float density;
    private final String nickname;
    private final String clientId;

    private ViewGroup decor;          // the activity DecorView we attach into
    private LinearLayout container;   // [panel][pill]
    private TextView pill;
    private LinearLayout panel;
    private boolean panelOpen;
    private boolean attached;
    private int opacityPct;            // 20–100; applied to the whole overlay
    private boolean opacityExpanded;   // opacity slider shown under a toggle

    // call state
    private BhVoiceController controller;
    private String roomCode;
    private boolean inCall;         // in a room (box shown), peer may not be connected yet
    private boolean callConnected;  // at least one peer connected → live call + timer
    private boolean muted;
    private boolean timerStarted;
    private final List<String> roster = new ArrayList<>();
    private final java.util.Map<String, String> peerNames = new java.util.HashMap<>();

    // call-view widgets (rebuilt on render)
    private EditText codeField;
    private TextView statusLine;
    private LinearLayout usersList;
    private Chronometer timer;
    private LinearLayout buttons;

    private BhVoiceOverlay(Activity act) {
        this.act = act;
        this.density = act.getResources().getDisplayMetrics().density;
        this.nickname = BhVoicePrefs.nickname(act);
        this.clientId = BhVoicePrefs.clientId(act);
        this.opacityPct = clampOpacity(BhVoicePrefs.getOpacity(act));
    }

    // ── attach / detach ──────────────────────────────────────────────────────
    // Attach into the activity's DecorView (same proven path as BhHudInjector),
    // NOT a separate WindowManager window. On the 5.3.5 :wine WineActivity a
    // TYPE_APPLICATION_PANEL window does not render over the Wine surface, but
    // DecorView child views (the HUD) do.
    private void attachInternal() {
        Window win = act.getWindow();
        decor = win != null ? (ViewGroup) win.getDecorView() : null;
        if (decor == null) { Log.w(TAG, "voice pill: no decor view"); return; }

        container = new LinearLayout(act);
        container.setOrientation(LinearLayout.HORIZONTAL);
        container.setGravity(Gravity.CENTER_VERTICAL);

        buildPill();   // must precede buildPanel() — renderIdle() tints the pill
        buildPanel();
        panel.setVisibility(View.GONE);
        container.addView(panel);
        container.addView(pill);

        FrameLayout.LayoutParams flp = new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        flp.gravity = Gravity.TOP | Gravity.END;
        flp.topMargin = BhVoicePrefs.getPillY(act, dp(180));
        flp.rightMargin = BhVoicePrefs.getPillX(act, 0);
        container.setLayoutParams(flp);
        try {
            decor.addView(container);
            attached = true;
            applyOpacity();
            Log.i(TAG, "voice pill attached to decor (y=" + flp.topMargin + ")");
        } catch (Throwable t) {
            Log.w(TAG, "voice pill addView(decor) failed", t);
        }
    }

    private static int clampOpacity(int p) { return p < 20 ? 20 : (p > 100 ? 100 : p); }

    private void applyOpacity() {
        // Full opacity while the panel is open (so controls stay usable); the
        // chosen fade applies to the collapsed pill during gameplay.
        if (container != null) container.setAlpha(panelOpen ? 1f : clampOpacity(opacityPct) / 100f);
    }

    /** Collapsible opacity control: a tappable toggle that reveals a slider. */
    private void addOpacityRow(LinearLayout panel) {
        final TextView toggle = new TextView(act);
        toggle.setText("Opacity — " + opacityPct + "%   " + (opacityExpanded ? "▾" : "▸"));
        toggle.setTextColor(COL_SUBTEXT);
        toggle.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12);
        LinearLayout.LayoutParams tlp = new LinearLayout.LayoutParams(-1, -2);
        tlp.topMargin = dp(10);
        toggle.setLayoutParams(tlp);
        toggle.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { opacityExpanded = !opacityExpanded; rerender(); }
        });
        panel.addView(toggle);

        if (opacityExpanded) {
            SeekBar sb = new SeekBar(act);
            sb.setMax(100);
            sb.setProgress(clampOpacity(opacityPct));
            sb.setLayoutParams(new LinearLayout.LayoutParams(-1, -2));
            sb.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
                public void onProgressChanged(SeekBar s, int p, boolean fromUser) {
                    opacityPct = clampOpacity(p);
                    applyOpacity();
                    toggle.setText("Opacity — " + opacityPct + "%   ▾");
                }
                public void onStartTrackingTouch(SeekBar s) {}
                public void onStopTrackingTouch(SeekBar s) { BhVoicePrefs.setOpacity(act, opacityPct); }
            });
            panel.addView(sb);
        }
    }

    private void rerender() {
        if (inCall) renderConnected(); else renderIdle();
    }

    private void cleanup() {
        if (controller != null) { try { controller.hangup(); } catch (Throwable ignored) {} controller = null; }
        if (attached && decor != null && container != null) {
            try { decor.removeView(container); } catch (Throwable ignored) {}
        }
        attached = false;
    }

    // ── pill ───────────────────────────────────────────────────────────────
    private void buildPill() {
        pill = new TextView(act);
        pill.setText("🎧");
        pill.setTextSize(TypedValue.COMPLEX_UNIT_SP, 20);
        pill.setGravity(Gravity.CENTER);
        pill.setPadding(dp(10), dp(14), dp(10), dp(14));
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(COL_PILL);
        bg.setCornerRadii(new float[]{ dp(18), dp(18), 0, 0, 0, 0, dp(18), dp(18) });
        pill.setBackground(bg);
        pill.setAlpha(0.92f);
        pill.setOnTouchListener(new PillTouch());
    }

    private void refreshPillTint() {
        if (pill == null) return;
        android.graphics.drawable.Drawable bg = pill.getBackground();
        if (bg instanceof GradientDrawable) ((GradientDrawable) bg).setColor(inCall ? 0xF22E7D32 : COL_PILL);
    }

    // ── panel ────────────────────────────────────────────────────────────────
    private void buildPanel() {
        panel = new LinearLayout(act);
        panel.setOrientation(LinearLayout.VERTICAL);
        panel.setMinimumWidth(dp(230));
        panel.setPadding(dp(14), dp(12), dp(14), dp(12));
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(COL_BG);
        bg.setCornerRadius(dp(16));
        bg.setStroke(dp(1), 0x40FFFFFF);
        panel.setBackground(bg);
        LinearLayout.LayoutParams plp = new LinearLayout.LayoutParams(-2, -2);
        plp.rightMargin = dp(6);
        panel.setLayoutParams(plp);
        renderIdle();
    }

    /** Idle: nickname + create/join room. */
    private void renderIdle() {
        panel.removeAllViews();
        inCall = false;
        refreshPillTint();

        panel.addView(headerText("🎧  Voice Chat"));

        TextView you = new TextView(act);
        you.setText("You: " + (nickname == null || nickname.isEmpty() ? "(set a nickname in the dashboard)" : nickname));
        you.setTextColor(COL_SUBTEXT);
        you.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12);
        you.setPadding(0, 0, 0, dp(10));
        panel.addView(you);

        codeField = new EditText(act);
        codeField.setHint("Room code");
        codeField.setTextColor(COL_TEXT);
        codeField.setHintTextColor(0xFF6B7280);
        codeField.setSingleLine(true);
        codeField.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14);
        GradientDrawable fbg = new GradientDrawable();
        fbg.setColor(0xFF12151A);
        fbg.setCornerRadius(dp(8));
        fbg.setStroke(dp(1), 0xFF333A45);
        codeField.setBackground(fbg);
        codeField.setPadding(dp(10), dp(8), dp(10), dp(8));
        codeField.setLayoutParams(new LinearLayout.LayoutParams(-1, -2));
        panel.addView(codeField);

        buttons = new LinearLayout(act);
        buttons.setOrientation(LinearLayout.HORIZONTAL);
        buttons.setGravity(Gravity.END);
        LinearLayout.LayoutParams blp = new LinearLayout.LayoutParams(-1, -2);
        blp.topMargin = dp(8);
        buttons.setLayoutParams(blp);
        buttons.addView(button("Create", COL_ACCENT, new View.OnClickListener() {
            public void onClick(View v) {
                String code = randomCode();
                codeField.setText(code);
                startCall(code);
            }
        }));
        buttons.addView(button("Join", COL_PILL, new View.OnClickListener() {
            public void onClick(View v) {
                String code = codeField.getText().toString().trim();
                if (code.isEmpty()) { setStatus("Enter a room code, or Create one."); return; }
                startCall(code);
            }
        }));
        panel.addView(buttons);

        statusLine = new TextView(act);
        statusLine.setTextColor(COL_SUBTEXT);
        statusLine.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12);
        statusLine.setPadding(0, dp(8), 0, 0);
        panel.addView(statusLine);

        addOpacityRow(panel);
    }

    /** In-room box. Shown immediately on Create/Join in a "waiting" state (no peer
     *  yet — a 1-person room can't connect), then becomes a live call with a timer
     *  once someone joins ({@code callConnected}). */
    private void renderConnected() {
        panel.removeAllViews();
        inCall = true;
        refreshPillTint();

        int n = roster.size();
        panel.addView(headerText(callConnected ? "🟢  In call" + (n > 0 ? "  ·  " + n : "")
                                               : "🟡  In room"));

        usersList = new LinearLayout(act);
        usersList.setOrientation(LinearLayout.VERTICAL);
        panel.addView(usersList);
        renderRoster();

        if (callConnected) {
            timer = new Chronometer(act);
            timer.setTextColor(COL_GREEN);
            timer.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18);
            timer.setTypeface(Typeface.MONOSPACE);
            timer.setPadding(0, dp(4), 0, dp(8));
            if (!timerStarted) { timerStarted = true; timer.setBase(SystemClock.elapsedRealtime()); }
            timer.start();
            panel.addView(timer);
        }

        buttons = new LinearLayout(act);
        buttons.setOrientation(LinearLayout.HORIZONTAL);
        buttons.setGravity(Gravity.END);
        buttons.addView(button(muted ? "Unmute" : "Mute", COL_PILL, new View.OnClickListener() {
            public void onClick(View v) { toggleMute(); }
        }));
        buttons.addView(button("🔗 Share", COL_ACCENT, new View.OnClickListener() {
            public void onClick(View v) { shareLink(); }
        }));
        buttons.addView(button("Leave", COL_RED, new View.OnClickListener() {
            public void onClick(View v) { endCall(); }
        }));
        panel.addView(buttons);

        statusLine = new TextView(act);
        statusLine.setTextColor(COL_SUBTEXT);
        statusLine.setTextSize(TypedValue.COMPLEX_UNIT_SP, 11);
        statusLine.setPadding(0, dp(6), 0, 0);
        statusLine.setText(callConnected
                ? "Room code: " + roomCode
                : "Waiting for someone to join…\nShare code “" + roomCode + "” (or tap Share).");
        panel.addView(statusLine);

        addOpacityRow(panel);
    }

    private void renderRoster() {
        if (usersList == null) return;
        usersList.removeAllViews();
        for (String name : roster) {
            TextView t = new TextView(act);
            t.setText("● " + name);
            t.setTextColor(COL_TEXT);
            t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
            t.setPadding(0, dp(1), 0, dp(1));
            usersList.addView(t);
        }
    }

    // ── call control ───────────────────────────────────────────────────────
    private void startCall(String code) {
        if (inCall) return;
        if (!ensureMic()) {
            setStatus("Allow microphone access, then tap Create or Join again.");
            return;
        }
        roomCode = code;
        timerStarted = false;
        callConnected = false;
        muted = false;
        roster.clear();
        roster.add((nickname == null || nickname.isEmpty() ? "You" : nickname) + " (you)");
        controller = new BhVoiceController(act, code, clientId, nickname, this);
        controller.start();
        renderConnected();   // show the in-room (waiting) box right away
    }

    private void endCall() {
        if (controller != null) { try { controller.hangup(); } catch (Throwable ignored) {} controller = null; }
        inCall = false;
        callConnected = false;
        timerStarted = false;
        renderIdle();
        setStatus("Call ended.");
    }

    private void toggleMute() {
        muted = !muted;
        if (controller != null) controller.setMuted(muted);
        if (buttons != null && buttons.getChildCount() > 0) {
            View first = buttons.getChildAt(0);
            if (first instanceof TextView) ((TextView) first).setText(muted ? "Unmute" : "Mute");
        }
    }

    private void shareLink() {
        try {
            String url = BhVoicePrefs.WORKER + "/voice/room?room=" + enc(roomCode);
            Intent send = new Intent(Intent.ACTION_SEND);
            send.setType("text/plain");
            send.putExtra(Intent.EXTRA_TEXT, "Join my BannerHub voice room: " + url);
            Intent chooser = Intent.createChooser(send, "Share voice room");
            chooser.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            act.startActivity(chooser);
        } catch (Throwable t) {
            setStatus("Couldn't open share sheet.");
        }
    }

    // ── BhVoiceController.Host (called off the UI thread by the JS bridge) ────
    @Override public void onVoiceState(final String state, final String detail) {
        act.runOnUiThread(new Runnable() { public void run() {
            if ("in-call".equals(state)) {
                // a peer connected → upgrade the waiting box to a live call
                if (!callConnected) { callConnected = true; renderConnected(); }
            } else if ("connecting".equals(state) || "calling".equals(state)) {
                // the waiting box is already shown by startCall; nothing to do
            } else if ("external".equals(state)) {
                inCall = false; callConnected = false; controller = null;
                renderIdle();
                setStatus("Voice opened in your browser (update Android System WebView for in-app calls).");
            } else if ("ended".equals(state) || "failed".equals(state)) {
                inCall = false; callConnected = false; controller = null; timerStarted = false;
                renderIdle();
                setStatus(detail == null || detail.isEmpty() ? "Call ended." : "Call ended: " + detail);
            }
        }});
    }

    @Override public void onVoiceRoster(final String idsCsv) {
        act.runOnUiThread(new Runnable() { public void run() {
            roster.clear();
            if (idsCsv != null && !idsCsv.isEmpty()) {
                for (String id : idsCsv.split(",")) {
                    if (id.isEmpty()) continue;
                    if (id.equals(clientId)) {
                        roster.add((nickname == null || nickname.isEmpty() ? "You" : nickname) + " (you)");
                    } else {
                        String nm = peerNames.get(id);
                        roster.add(nm == null || nm.trim().isEmpty() ? "Guest" : nm);
                    }
                }
            }
            if (inCall) {
                // update header count + list without resetting the timer
                renderRoster();
                if (panel.getChildCount() > 0 && panel.getChildAt(0) instanceof TextView) {
                    ((TextView) panel.getChildAt(0)).setText(callConnected
                            ? "🟢  In call  ·  " + roster.size()
                            : "🟡  In room");
                }
            }
        }});
    }

    @Override public void onVoiceRosterNames(final String namesJson) {
        act.runOnUiThread(new Runnable() { public void run() {
            if (namesJson == null || namesJson.isEmpty()) return;
            try {
                org.json.JSONObject o = new org.json.JSONObject(namesJson);
                java.util.Iterator<String> it = o.keys();
                while (it.hasNext()) {
                    String id = it.next();
                    peerNames.put(id, o.optString(id, ""));
                }
            } catch (Throwable ignored) {}
        }});
    }

    // ── helpers ──────────────────────────────────────────────────────────────
    // Tapping the pill only shows/hides the panel — it does NOT touch the call.
    // The WebRTC runs in the headless WebView (independent of this panel), so a
    // collapsed pill stays in an active, connected call; only Leave / leaving the
    // game ends it. The pill stays green-tinted while a call is live.
    private void togglePanel() {
        panelOpen = !panelOpen;
        panel.setVisibility(panelOpen ? View.VISIBLE : View.GONE);
        applyOpacity();   // fade the collapsed pill; full while open
    }

    private void setStatus(String msg) {
        if (statusLine != null) statusLine.setText(msg);
    }

    /** The WebView's getUserMedia needs the APP to hold RECORD_AUDIO (a runtime
     *  permission). If it isn't granted, request it (dialog shows over the game)
     *  and return false so the user taps Create/Join again once granted. */
    private boolean ensureMic() {
        try {
            if (act.checkSelfPermission(android.Manifest.permission.RECORD_AUDIO)
                    == android.content.pm.PackageManager.PERMISSION_GRANTED) return true;
            act.requestPermissions(new String[]{ android.Manifest.permission.RECORD_AUDIO }, 0xBA);
            return false;
        } catch (Throwable t) {
            return true; // best effort — let the call attempt proceed
        }
    }

    private TextView headerText(String s) {
        TextView h = new TextView(act);
        h.setText("⠿  " + s);   // grip hint: this header drags the whole box
        h.setTextColor(COL_TEXT);
        h.setTypeface(Typeface.DEFAULT_BOLD);
        h.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14);
        h.setPadding(0, dp(2), 0, dp(8));
        h.setOnTouchListener(new PanelDrag());   // drag the box around the screen
        return h;
    }

    private TextView button(String label, int color, View.OnClickListener onClick) {
        TextView b = new TextView(act);
        b.setText(label);
        b.setTextColor(COL_TEXT);
        b.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
        b.setTypeface(Typeface.DEFAULT_BOLD);
        b.setPadding(dp(14), dp(7), dp(14), dp(7));
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(color);
        bg.setCornerRadius(dp(14));
        b.setBackground(bg);
        b.setOnClickListener(onClick);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-2, -2);
        lp.leftMargin = dp(6);
        b.setLayoutParams(lp);
        return b;
    }

    private String randomCode() {
        final String alphabet = "abcdefghjkmnpqrstuvwxyz23456789";
        Random r = new Random();
        StringBuilder sb = new StringBuilder("bh");
        for (int i = 0; i < 5; i++) sb.append(alphabet.charAt(r.nextInt(alphabet.length())));
        return sb.toString();
    }

    private int dp(int v) { return (int) (v * density + 0.5f); }

    private static String enc(String s) {
        try { return java.net.URLEncoder.encode(s == null ? "" : s, "UTF-8"); } catch (Throwable t) { return s; }
    }

    // Drag the pill vertically along the right edge; a tap toggles the panel.
    // Drag the whole box around the screen via the header (2D). Stays anchored to
    // the top-right; topMargin = Y, rightMargin = distance from right edge.
    private final class PanelDrag implements View.OnTouchListener {
        private float startRawX, startRawY;
        private int startTop, startRight;
        private boolean dragged;

        @Override public boolean onTouch(View v, MotionEvent e) {
            FrameLayout.LayoutParams flp = (FrameLayout.LayoutParams) container.getLayoutParams();
            switch (e.getActionMasked()) {
                case MotionEvent.ACTION_DOWN:
                    startRawX = e.getRawX();
                    startRawY = e.getRawY();
                    startTop = flp.topMargin;
                    startRight = flp.rightMargin;
                    dragged = false;
                    return true;
                case MotionEvent.ACTION_MOVE:
                    int dx = (int) (e.getRawX() - startRawX);
                    int dy = (int) (e.getRawY() - startRawY);
                    if (Math.abs(dx) > dp(4) || Math.abs(dy) > dp(4)) dragged = true;
                    flp.topMargin = Math.max(0, startTop + dy);
                    flp.rightMargin = Math.max(0, startRight - dx); // drag right → toward edge
                    container.setLayoutParams(flp);
                    return true;
                case MotionEvent.ACTION_UP:
                    if (dragged) {
                        BhVoicePrefs.setPillY(act, flp.topMargin);
                        BhVoicePrefs.setPillX(act, flp.rightMargin);
                    }
                    return true;
                default:
                    return false;
            }
        }
    }

    private final class PillTouch implements View.OnTouchListener {
        private float startRawY;
        private int startMargin;
        private boolean dragged;

        @Override public boolean onTouch(View v, MotionEvent e) {
            FrameLayout.LayoutParams flp = (FrameLayout.LayoutParams) container.getLayoutParams();
            switch (e.getActionMasked()) {
                case MotionEvent.ACTION_DOWN:
                    startRawY = e.getRawY();
                    startMargin = flp.topMargin;
                    dragged = false;
                    return true;
                case MotionEvent.ACTION_MOVE:
                    int dy = (int) (e.getRawY() - startRawY);
                    if (Math.abs(dy) > dp(6)) dragged = true;
                    flp.topMargin = Math.max(0, startMargin + dy);
                    container.setLayoutParams(flp);
                    return true;
                case MotionEvent.ACTION_UP:
                    if (dragged) {
                        BhVoicePrefs.setPillY(act, flp.topMargin);
                    } else {
                        togglePanel();
                    }
                    return true;
                default:
                    return false;
            }
        }
    }
}
