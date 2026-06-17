package app.revanced.extension.gamehub;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.xj.winemu.sidebar.BhVoicePrefs;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

/**
 * Dashboard "Voice Chat" settings screen (side-menu item directly under Game
 * Configs).
 *
 * <p>Gates the in-game voice pill behind two steps:
 * <ol>
 *   <li>The user enters a nickname and presses <b>Check availability</b>, which
 *       queries the bannerhub-api worker's nickname registry. Only a free name
 *       (or one already owned by this device) unlocks step 2.</li>
 *   <li>An <b>Activate in-game voice pill</b> checkbox — disabled until step 1
 *       passes. Ticking it claims the nickname server-side and turns the pill on
 *       for games (persisted to {@code bh_prefs}); unticking turns it off.</li>
 * </ol>
 *
 * Nicknames are reserved against a Cloudflare-KV registry on the worker
 * ({@code /voice/nick/check} and {@code /voice/nick/claim}), keyed to this
 * device's stable {@link BhVoicePrefs#clientId(android.content.Context)} so the
 * same user keeps their name.
 */
public class BhVoiceChatSettingsActivity extends Activity {

    private float density = 1f;

    private EditText nickField;
    private TextView status;
    private CheckBox activate;
    private Button checkBtn;

    /** True only while the name currently in the field is confirmed available
     *  (or owned by us). Editing the field clears this and re-locks activation. */
    private boolean availableConfirmed = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        density = getResources().getDisplayMetrics().density;
        getWindow().setBackgroundDrawable(new ColorDrawable(0xCC000000));
        setContentView(buildUi());

        // Prefill any previously-saved nickname + reflect current activation.
        String saved = BhVoicePrefs.nickname(this);
        if (saved != null && !saved.isEmpty()) {
            nickField.setText(saved);
            // A saved + activated name was already claimed by us — treat as
            // confirmed so the box reflects reality without a re-check.
            if (BhVoicePrefs.activated(this)) {
                availableConfirmed = true;
                status.setText("Nickname \"" + saved + "\" is active.");
                status.setTextColor(0xFF6FCF6F);
            }
        }
        refreshActivateState();
        activate.setChecked(BhVoicePrefs.pillEnabled(this));
    }

    private View buildUi() {
        ScrollView scroll = new ScrollView(this);
        scroll.setFillViewport(true);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(dp(20), dp(18), dp(20), dp(18));
        GradientDrawable card = new GradientDrawable();
        card.setColor(0xFF1B1E24);
        card.setCornerRadius(dp(14));
        root.setBackground(card);
        LinearLayout.LayoutParams rootLp = new LinearLayout.LayoutParams(dp(420), ViewGroup.LayoutParams.WRAP_CONTENT);
        rootLp.gravity = Gravity.CENTER;
        rootLp.topMargin = dp(24);
        rootLp.bottomMargin = dp(24);
        root.setLayoutParams(rootLp);

        TextView title = new TextView(this);
        title.setText("Voice Chat");
        title.setTextColor(Color.WHITE);
        title.setTextSize(TypedValue.COMPLEX_UNIT_SP, 20);
        title.setTypeface(Typeface.DEFAULT_BOLD);
        root.addView(title);

        TextView blurb = new TextView(this);
        blurb.setText("Pick a nickname and check it's free. Once it's available you can "
                + "switch on the in-game voice pill — a tab on the side of the screen "
                + "while playing games that lets you talk with friends in a shared room. "
                + "No Steam account or friends list needed.");
        blurb.setTextColor(0xFFB7BDC8);
        blurb.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
        LinearLayout.LayoutParams blurbLp = new LinearLayout.LayoutParams(-1, -2);
        blurbLp.topMargin = dp(8);
        blurb.setLayoutParams(blurbLp);
        root.addView(blurb);

        // ── Nickname row: [ EditText ][ Check ] ────────────────────────────
        LinearLayout nickRow = new LinearLayout(this);
        nickRow.setOrientation(LinearLayout.HORIZONTAL);
        nickRow.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout.LayoutParams nrLp = new LinearLayout.LayoutParams(-1, -2);
        nrLp.topMargin = dp(16);
        nickRow.setLayoutParams(nrLp);

        nickField = new EditText(this);
        nickField.setHint("Your nickname");
        nickField.setTextColor(Color.WHITE);
        nickField.setHintTextColor(0xFF6B7280);
        nickField.setSingleLine(true);
        nickField.setTextSize(TypedValue.COMPLEX_UNIT_SP, 15);
        nickField.setFilters(new InputFilter[]{ new InputFilter.LengthFilter(20) });
        GradientDrawable fieldBg = new GradientDrawable();
        fieldBg.setColor(0xFF12151A);
        fieldBg.setCornerRadius(dp(8));
        fieldBg.setStroke(dp(1), 0xFF333A45);
        nickField.setBackground(fieldBg);
        nickField.setPadding(dp(12), dp(10), dp(12), dp(10));
        LinearLayout.LayoutParams fLp = new LinearLayout.LayoutParams(0, -2, 1f);
        nickField.setLayoutParams(fLp);
        nickField.addTextChangedListener(new TextWatcher() {
            public void beforeTextChanged(CharSequence s, int a, int b, int c) {}
            public void onTextChanged(CharSequence s, int a, int b, int c) {}
            public void afterTextChanged(Editable s) {
                // Any edit invalidates a prior availability check.
                if (availableConfirmed) {
                    availableConfirmed = false;
                    status.setText("");
                    refreshActivateState();
                    if (activate.isChecked()) {
                        activate.setChecked(false);
                        BhVoicePrefs.setActivated(BhVoiceChatSettingsActivity.this, false);
                    }
                }
            }
        });
        nickRow.addView(nickField);

        checkBtn = new Button(this);
        checkBtn.setText("Check");
        checkBtn.setAllCaps(false);
        checkBtn.setTextColor(Color.WHITE);
        GradientDrawable checkBg = new GradientDrawable();
        checkBg.setColor(0xFF2D6CDF);
        checkBg.setCornerRadius(dp(8));
        checkBtn.setBackground(checkBg);
        LinearLayout.LayoutParams cLp = new LinearLayout.LayoutParams(-2, -2);
        cLp.leftMargin = dp(10);
        checkBtn.setLayoutParams(cLp);
        checkBtn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { doCheck(); }
        });
        nickRow.addView(checkBtn);
        root.addView(nickRow);

        status = new TextView(this);
        status.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
        status.setTextColor(0xFFB7BDC8);
        LinearLayout.LayoutParams stLp = new LinearLayout.LayoutParams(-1, -2);
        stLp.topMargin = dp(8);
        status.setLayoutParams(stLp);
        root.addView(status);

        // ── recovery row: Reclaim (force) + Release ────────────────────────
        LinearLayout recRow = new LinearLayout(this);
        recRow.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams rrLp = new LinearLayout.LayoutParams(-1, -2);
        rrLp.topMargin = dp(12);
        recRow.setLayoutParams(rrLp);

        Button reclaim = new Button(this);
        reclaim.setText("Reclaim");
        reclaim.setAllCaps(false);
        reclaim.setTextColor(Color.WHITE);
        GradientDrawable rbg = new GradientDrawable();
        rbg.setColor(0xFF6A4BC0);
        rbg.setCornerRadius(dp(8));
        reclaim.setBackground(rbg);
        reclaim.setLayoutParams(new LinearLayout.LayoutParams(0, -2, 1f));
        reclaim.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { doReclaim(); }
        });
        recRow.addView(reclaim);

        Button release = new Button(this);
        release.setText("Release");
        release.setAllCaps(false);
        release.setTextColor(Color.WHITE);
        GradientDrawable relBg = new GradientDrawable();
        relBg.setColor(0xFF3A4250);
        relBg.setCornerRadius(dp(8));
        release.setBackground(relBg);
        LinearLayout.LayoutParams relLp = new LinearLayout.LayoutParams(0, -2, 1f);
        relLp.leftMargin = dp(8);
        release.setLayoutParams(relLp);
        release.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { doRelease(); }
        });
        recRow.addView(release);
        root.addView(recRow);

        TextView recHint = new TextView(this);
        recHint.setText("Reclaim = take a name back if it shows \"taken\" but it's actually yours "
                + "(e.g. after a reinstall). Release = free your name, e.g. before switching devices.");
        recHint.setTextColor(0xFF6B7280);
        recHint.setTextSize(TypedValue.COMPLEX_UNIT_SP, 11);
        LinearLayout.LayoutParams rhLp = new LinearLayout.LayoutParams(-1, -2);
        rhLp.topMargin = dp(4);
        recHint.setLayoutParams(rhLp);
        root.addView(recHint);

        // ── Activation checkbox (gated) ────────────────────────────────────
        activate = new CheckBox(this);
        activate.setText("Activate in-game voice pill");
        activate.setTextColor(Color.WHITE);
        activate.setTextSize(TypedValue.COMPLEX_UNIT_SP, 15);
        LinearLayout.LayoutParams aLp = new LinearLayout.LayoutParams(-1, -2);
        aLp.topMargin = dp(18);
        activate.setLayoutParams(aLp);
        activate.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton b, boolean checked) {
                if (!b.isPressed()) return; // ignore programmatic state sync
                if (checked) doClaimAndActivate();
                else {
                    BhVoicePrefs.setActivated(BhVoiceChatSettingsActivity.this, false);
                    status.setText("Voice pill turned off.");
                    status.setTextColor(0xFFB7BDC8);
                }
            }
        });
        root.addView(activate);

        Button close = new Button(this);
        close.setText("Done");
        close.setAllCaps(false);
        close.setTextColor(Color.WHITE);
        GradientDrawable closeBg = new GradientDrawable();
        closeBg.setColor(0xFF3A4250);
        closeBg.setCornerRadius(dp(8));
        close.setBackground(closeBg);
        LinearLayout.LayoutParams clLp = new LinearLayout.LayoutParams(-1, -2);
        clLp.topMargin = dp(20);
        close.setLayoutParams(clLp);
        close.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { finish(); }
        });
        root.addView(close);

        scroll.addView(root);
        return scroll;
    }

    /** Enable the activation checkbox only when a name is confirmed available. */
    private void refreshActivateState() {
        boolean ok = availableConfirmed && validName(nickField.getText().toString()) == null;
        activate.setEnabled(ok);
        activate.setAlpha(ok ? 1f : 0.4f);
    }

    /** @return an error message if the name is invalid, else null. */
    private String validName(String raw) {
        if (raw == null) return "Enter a nickname.";
        String n = raw.trim();
        if (n.length() < 3) return "Nickname must be at least 3 characters.";
        if (n.length() > 20) return "Nickname must be 20 characters or fewer.";
        if (!n.matches("[A-Za-z0-9 _\\-]+")) return "Use letters, numbers, spaces, _ or - only.";
        return null;
    }

    private void doCheck() {
        final String name = nickField.getText().toString().trim();
        String err = validName(name);
        if (err != null) { setStatus(err, 0xFFE08A8A); return; }
        setStatus("Checking…", 0xFFB7BDC8);
        checkBtn.setEnabled(false);
        final String self = BhVoicePrefs.clientId(this);
        new Thread(new Runnable() { public void run() {
            String result;
            try {
                String url = BhVoicePrefs.WORKER + "/voice/nick/check?name=" + enc(name) + "&self=" + enc(self);
                String body = httpGet(url);
                result = new JSONObject(body).optString("status", "error");
            } catch (Throwable t) {
                result = "neterror";
            }
            final String r = result;
            runOnUiThread(new Runnable() { public void run() {
                checkBtn.setEnabled(true);
                if ("free".equals(r) || "yours".equals(r)) {
                    availableConfirmed = true;
                    setStatus("\"" + name + "\" is available ✓", 0xFF6FCF6F);
                } else if ("taken".equals(r)) {
                    availableConfirmed = false;
                    setStatus("\"" + name + "\" is already taken — try another.", 0xFFE08A8A);
                } else {
                    availableConfirmed = false;
                    setStatus("Couldn't reach the server. Check your connection and try again.", 0xFFE08A8A);
                }
                refreshActivateState();
            }});
        }}).start();
    }

    private void doClaimAndActivate() {
        final String name = nickField.getText().toString().trim();
        if (validName(name) != null || !availableConfirmed) {
            activate.setChecked(false);
            return;
        }
        setStatus("Reserving \"" + name + "\"…", 0xFFB7BDC8);
        final String self = BhVoicePrefs.clientId(this);
        new Thread(new Runnable() { public void run() {
            String result;
            try {
                JSONObject payload = new JSONObject();
                payload.put("name", name);
                payload.put("self", self);
                String body = httpPostJson(BhVoicePrefs.WORKER + "/voice/nick/claim", payload.toString());
                result = new JSONObject(body).optString("status", "error");
            } catch (Throwable t) {
                result = "neterror";
            }
            final String r = result;
            runOnUiThread(new Runnable() { public void run() {
                if ("ok".equals(r) || "yours".equals(r)) {
                    BhVoicePrefs.setNickname(BhVoiceChatSettingsActivity.this, name);
                    BhVoicePrefs.setActivated(BhVoiceChatSettingsActivity.this, true);
                    requestMicIfNeeded();
                    setStatus("Done — voice pill is on. It appears on the side of the screen in games.", 0xFF6FCF6F);
                } else {
                    activate.setChecked(false);
                    availableConfirmed = false;
                    refreshActivateState();
                    setStatus("taken".equals(r)
                            ? "\"" + name + "\" was just taken by someone else — pick another."
                            : "Couldn't reserve the name. Try again.", 0xFFE08A8A);
                }
            }});
        }}).start();
    }

    /** Force-rebind the name to THIS device's client id — recovery for "it says
     *  taken but it's mine" (lost client id after a reinstall/new device). */
    private void doReclaim() {
        final String name = nickField.getText().toString().trim();
        String err = validName(name);
        if (err != null) { setStatus(err, 0xFFE08A8A); return; }
        setStatus("Reclaiming \"" + name + "\"…", 0xFFB7BDC8);
        final String self = BhVoicePrefs.clientId(this);
        new Thread(new Runnable() { public void run() {
            String result;
            try {
                JSONObject payload = new JSONObject();
                payload.put("name", name);
                payload.put("self", self);
                payload.put("force", true);
                String body = httpPostJson(BhVoicePrefs.WORKER + "/voice/nick/claim", payload.toString());
                result = new JSONObject(body).optString("status", "error");
            } catch (Throwable t) { result = "neterror"; }
            final String r = result;
            runOnUiThread(new Runnable() { public void run() {
                if ("reclaimed".equals(r) || "ok".equals(r) || "yours".equals(r)) {
                    BhVoicePrefs.setNickname(BhVoiceChatSettingsActivity.this, name);
                    BhVoicePrefs.setActivated(BhVoiceChatSettingsActivity.this, true);
                    availableConfirmed = true;
                    refreshActivateState();
                    activate.setChecked(true); // programmatic; listener ignores (not pressed)
                    requestMicIfNeeded();
                    setStatus("Reclaimed — it's yours and the voice pill is on.", 0xFF6FCF6F);
                } else {
                    setStatus("invalid".equals(r) ? "Invalid nickname." : "Couldn't reclaim. Check your connection and try again.", 0xFFE08A8A);
                }
            }});
        }}).start();
    }

    /** Voluntarily free the name this device owns (e.g. before switching devices). */
    private void doRelease() {
        final String name = nickField.getText().toString().trim();
        if (name.isEmpty()) { setStatus("Enter the nickname to release.", 0xFFE08A8A); return; }
        setStatus("Releasing \"" + name + "\"…", 0xFFB7BDC8);
        final String self = BhVoicePrefs.clientId(this);
        new Thread(new Runnable() { public void run() {
            String result;
            try {
                JSONObject payload = new JSONObject();
                payload.put("name", name);
                payload.put("self", self);
                String body = httpPostJson(BhVoicePrefs.WORKER + "/voice/nick/release", payload.toString());
                result = new JSONObject(body).optString("status", "error");
            } catch (Throwable t) { result = "neterror"; }
            final String r = result;
            runOnUiThread(new Runnable() { public void run() {
                if ("released".equals(r) || "free".equals(r)) {
                    BhVoicePrefs.setActivated(BhVoiceChatSettingsActivity.this, false);
                    availableConfirmed = false;
                    if (activate.isChecked()) activate.setChecked(false);
                    refreshActivateState();
                    setStatus("Released. The name is free again and the pill is off.", 0xFFB7BDC8);
                } else if ("not_yours".equals(r)) {
                    setStatus("This device doesn't hold that name — use Reclaim if it's yours.", 0xFFE08A8A);
                } else {
                    setStatus("Couldn't release. Try again.", 0xFFE08A8A);
                }
            }});
        }}).start();
    }

    /** The in-game WebRTC WebView needs the app to hold RECORD_AUDIO at runtime;
     *  request it here (a clean dialog in this normal activity) so it's already
     *  granted before the user ever opens the in-game pill. */
    private void requestMicIfNeeded() {
        try {
            if (checkSelfPermission(android.Manifest.permission.RECORD_AUDIO)
                    != android.content.pm.PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[]{ android.Manifest.permission.RECORD_AUDIO }, 0xBA);
            }
        } catch (Throwable ignored) {}
    }

    private void setStatus(String msg, int color) {
        status.setText(msg);
        status.setTextColor(color);
    }

    // ── tiny HTTP helpers ──────────────────────────────────────────────────
    private static String httpGet(String url) throws Exception {
        HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
        try {
            c.setConnectTimeout(8000);
            c.setReadTimeout(8000);
            c.setRequestMethod("GET");
            return readBody(c);
        } finally { c.disconnect(); }
    }

    private static String httpPostJson(String url, String json) throws Exception {
        HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
        try {
            c.setConnectTimeout(8000);
            c.setReadTimeout(8000);
            c.setRequestMethod("POST");
            c.setDoOutput(true);
            c.setRequestProperty("Content-Type", "application/json");
            OutputStream os = c.getOutputStream();
            os.write(json.getBytes("UTF-8"));
            os.close();
            return readBody(c);
        } finally { c.disconnect(); }
    }

    private static String readBody(HttpURLConnection c) throws Exception {
        int code = c.getResponseCode();
        java.io.InputStream in = (code >= 200 && code < 400) ? c.getInputStream() : c.getErrorStream();
        if (in == null) return "{}";
        BufferedReader br = new BufferedReader(new InputStreamReader(in, "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);
        br.close();
        return sb.toString();
    }

    private static String enc(String s) {
        try { return URLEncoder.encode(s, "UTF-8"); } catch (Exception e) { return s; }
    }

    private int dp(int v) { return Math.round(v * density); }
}
