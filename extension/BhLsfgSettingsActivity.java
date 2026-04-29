package app.revanced.extension.gamehub;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.TypedValue;
import android.view.Gravity;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;

/**
 * Global LSFG-VK frame generation settings screen.
 *
 * Launched from the BannerHub settings menu (smali injection in SettingBtnHolder).
 * Settings are global (shared across all Wine containers).
 *
 * At Wine launch time (smali injection in WinEmuServiceImpl), call:
 *   BhLsfgManager.ensureRuntimeInstalled(ctx, containerPath)
 *   BhLsfgManager.writeConfig(containerPath, ...)
 */
public class BhLsfgSettingsActivity extends Activity {

    private static final int REQUEST_FILE_PICKER = 300;

    private SharedPreferences prefs;
    private final Handler uiHandler = new Handler(Looper.getMainLooper());

    // UI refs updated by file picker result and auto-detect
    private TextView dllPathTV;
    private TextView dllStatusTV;
    private Button autoDetectBtn;

    // State
    private Switch enableSwitch;
    private int selectedMultiplier; // 0=off, 2, 3, 4
    private String selectedFlowScale;
    private Switch perfModeSwitch;

    // Chip button groups (need refs to toggle selected state)
    private Button[] multiplierChips;
    private Button[] flowScaleChips;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs = getSharedPreferences(BhLsfgManager.PREFS, MODE_PRIVATE);

        selectedMultiplier = BhLsfgManager.getMultiplier(this);
        selectedFlowScale  = BhLsfgManager.getFlowScale(this);

        buildUi();
    }

    private void buildUi() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0D0D0D);

        // ── Header ────────────────────────────────────────────────────────────
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.VERTICAL);
        header.setBackgroundColor(0xFF1A1A2E);
        header.setPadding(dp(16), dp(14), dp(16), dp(14));

        TextView titleTV = new TextView(this);
        titleTV.setText("LSFG-VK Frame Generation");
        titleTV.setTextColor(0xFFFFFFFF);
        titleTV.setTextSize(18f);
        titleTV.setTypeface(null, Typeface.BOLD);
        header.addView(titleTV);

        TextView subtitleTV = new TextView(this);
        subtitleTV.setText("Lossless Scaling frame generation via Vulkan implicit layer.\n" +
                "Hooks the game's swapchain directly — no overlay needed.");
        subtitleTV.setTextColor(0xFF8888AA);
        subtitleTV.setTextSize(12f);
        subtitleTV.setPadding(0, dp(4), 0, 0);
        header.addView(subtitleTV);

        root.addView(header, new LinearLayout.LayoutParams(-1, -2));

        // ── Scrollable content ────────────────────────────────────────────────
        ScrollView scroll = new ScrollView(this);
        LinearLayout content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(dp(16), dp(12), dp(16), dp(32));

        // Enable toggle
        content.addView(buildSection("Enable", buildEnableRow()));

        // Lossless.dll
        content.addView(buildSection("Lossless.dll", buildDllSection()));

        // Multiplier
        content.addView(buildSection("Frame Multiplier", buildMultiplierChips()));

        // Flow Scale
        content.addView(buildSection("Flow Scale", buildFlowScaleChips()));

        // Performance Mode
        content.addView(buildSection("Performance Mode", buildPerfModeRow()));

        // Save button
        Button saveBtn = makeBtn("Save Settings", 0xFF1565C0);
        saveBtn.setOnClickListener(v -> saveAndFinish());
        LinearLayout.LayoutParams saveLp = new LinearLayout.LayoutParams(-1, dp(48));
        saveLp.topMargin = dp(16);
        content.addView(saveBtn, saveLp);

        scroll.addView(content);
        root.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1f));
        setContentView(root);
    }

    // ── Section builder ───────────────────────────────────────────────────────

    private LinearLayout buildSection(String label, android.view.View inner) {
        LinearLayout section = new LinearLayout(this);
        section.setOrientation(LinearLayout.VERTICAL);
        LinearLayout.LayoutParams sLp = new LinearLayout.LayoutParams(-1, -2);
        sLp.bottomMargin = dp(12);
        section.setLayoutParams(sLp);

        GradientDrawable bg = new GradientDrawable();
        bg.setColor(0xFF141428);
        bg.setCornerRadius(dp(8));
        bg.setStroke(dp(1), 0xFF2A2A4A);
        section.setBackground(bg);
        section.setPadding(dp(14), dp(12), dp(14), dp(12));

        TextView labelTV = new TextView(this);
        labelTV.setText(label);
        labelTV.setTextColor(0xFF9999CC);
        labelTV.setTextSize(11f);
        labelTV.setTypeface(null, Typeface.BOLD);
        labelTV.setAllCaps(true);
        LinearLayout.LayoutParams lLp = new LinearLayout.LayoutParams(-1, -2);
        lLp.bottomMargin = dp(8);
        section.addView(labelTV, lLp);

        section.addView(inner);
        return section;
    }

    // ── Enable row ────────────────────────────────────────────────────────────

    private android.view.View buildEnableRow() {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);

        TextView desc = new TextView(this);
        desc.setText("Enable frame generation for all Wine games");
        desc.setTextColor(0xFFDDDDFF);
        desc.setTextSize(13f);
        row.addView(desc, new LinearLayout.LayoutParams(0, -2, 1f));

        enableSwitch = new Switch(this);
        enableSwitch.setChecked(BhLsfgManager.isEnabled(this));
        row.addView(enableSwitch, new LinearLayout.LayoutParams(-2, -2));
        return row;
    }

    // ── DLL section ───────────────────────────────────────────────────────────

    private android.view.View buildDllSection() {
        LinearLayout container = new LinearLayout(this);
        container.setOrientation(LinearLayout.VERTICAL);

        // Path display
        dllPathTV = new TextView(this);
        dllPathTV.setTextColor(0xFFBBBBDD);
        dllPathTV.setTextSize(12f);
        dllPathTV.setPadding(0, 0, 0, dp(6));

        dllStatusTV = new TextView(this);
        dllStatusTV.setTextSize(11f);
        dllStatusTV.setPadding(0, 0, 0, dp(10));

        updateDllDisplay(BhLsfgManager.getDllPath(this));
        container.addView(dllPathTV);
        container.addView(dllStatusTV);

        // Button row
        LinearLayout btnRow = new LinearLayout(this);
        btnRow.setOrientation(LinearLayout.HORIZONTAL);

        autoDetectBtn = makeBtn("Auto-Detect", 0xFF1B5E20);
        autoDetectBtn.setTextSize(12f);
        autoDetectBtn.setOnClickListener(v -> runAutoDetect());
        LinearLayout.LayoutParams autoLp = new LinearLayout.LayoutParams(0, dp(38), 1f);
        autoLp.rightMargin = dp(8);
        btnRow.addView(autoDetectBtn, autoLp);

        Button browseBtn = makeBtn("Browse", 0xFF1A237E);
        browseBtn.setTextSize(12f);
        browseBtn.setOnClickListener(v -> openFilePicker());
        btnRow.addView(browseBtn, new LinearLayout.LayoutParams(0, dp(38), 1f));

        container.addView(btnRow);

        TextView hintTV = new TextView(this);
        hintTV.setText("Lossless Scaling must be installed via the Steam game list (App ID 993090)." +
                " Auto-Detect finds it automatically. Use Browse if it's in a custom location.");
        hintTV.setTextColor(0xFF666688);
        hintTV.setTextSize(11f);
        LinearLayout.LayoutParams hLp = new LinearLayout.LayoutParams(-1, -2);
        hLp.topMargin = dp(8);
        hintTV.setLayoutParams(hLp);
        container.addView(hintTV);

        return container;
    }

    private void updateDllDisplay(String storedPath) {
        String resolved = BhLsfgManager.resolveDll(this);
        if (resolved != null) {
            // Abbreviate long paths for display
            String display = resolved.length() > 60
                    ? "…" + resolved.substring(resolved.length() - 57) : resolved;
            dllPathTV.setText(display);
            dllStatusTV.setText("✓ Found");
            dllStatusTV.setTextColor(0xFF44CC44);
        } else if (!storedPath.isEmpty()) {
            dllPathTV.setText(storedPath);
            dllStatusTV.setText("✗ File not found at stored path");
            dllStatusTV.setTextColor(0xFFCC4444);
        } else {
            dllPathTV.setText("Not set");
            dllStatusTV.setText("Use Auto-Detect or Browse to locate Lossless.dll");
            dllStatusTV.setTextColor(0xFF888888);
        }
    }

    private void runAutoDetect() {
        autoDetectBtn.setEnabled(false);
        autoDetectBtn.setText("Scanning…");
        new Thread(() -> {
            String found = BhLsfgManager.autoDiscoverDll(this);
            uiHandler.post(() -> {
                autoDetectBtn.setEnabled(true);
                autoDetectBtn.setText("Auto-Detect");
                if (found != null) {
                    prefs.edit().putString(BhLsfgManager.KEY_DLL_PATH, found).apply();
                    updateDllDisplay(found);
                    Toast.makeText(this, "Found: " + new File(found).getName(),
                            Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(this,
                            "Not found. Install Lossless Scaling via Steam or use Browse.",
                            Toast.LENGTH_LONG).show();
                }
            });
        }).start();
    }

    private void openFilePicker() {
        // Start in the Wine game install directory where Lossless Scaling lives
        File startDir = new File(getFilesDir(), "xj_winemu/xj_install/game");
        Intent intent = new Intent(this, FilePickerActivity.class);
        intent.putExtra("filter_ext", ".dll");
        intent.putExtra("title", "Select Lossless.dll");
        if (startDir.isDirectory()) {
            intent.putExtra("start_path", startDir.getAbsolutePath());
        }
        startActivityForResult(intent, REQUEST_FILE_PICKER);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_FILE_PICKER && resultCode == RESULT_OK && data != null) {
            String path = data.getStringExtra("path");
            if (path != null) {
                // Warn if the chosen file isn't named Lossless.dll
                if (!new File(path).getName().equalsIgnoreCase("Lossless.dll")) {
                    Toast.makeText(this,
                            "Warning: expected Lossless.dll, got " + new File(path).getName(),
                            Toast.LENGTH_LONG).show();
                }
                prefs.edit().putString(BhLsfgManager.KEY_DLL_PATH, path).apply();
                updateDllDisplay(path);
            }
        }
    }

    // ── Multiplier chips ──────────────────────────────────────────────────────

    private android.view.View buildMultiplierChips() {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);

        String[] labels = { "Off", "2x", "3x", "4x" };
        int[]    values = {  0,     2,    3,    4   };
        multiplierChips = new Button[labels.length];

        for (int i = 0; i < labels.length; i++) {
            final int val = values[i];
            Button chip = makeChip(labels[i], val == selectedMultiplier);
            chip.setOnClickListener(v -> {
                selectedMultiplier = val;
                refreshMultiplierChips();
            });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, dp(38), 1f);
            if (i < labels.length - 1) lp.rightMargin = dp(6);
            row.addView(chip, lp);
            multiplierChips[i] = chip;
        }
        return row;
    }

    private void refreshMultiplierChips() {
        int[] values = { 0, 2, 3, 4 };
        for (int i = 0; i < multiplierChips.length; i++) {
            setChipSelected(multiplierChips[i], values[i] == selectedMultiplier);
        }
    }

    // ── Flow scale chips ──────────────────────────────────────────────────────

    private android.view.View buildFlowScaleChips() {
        LinearLayout col = new LinearLayout(this);
        col.setOrientation(LinearLayout.VERTICAL);

        TextView desc = new TextView(this);
        desc.setText("Lower values reduce GPU cost; 1.00 is full quality.");
        desc.setTextColor(0xFF666688);
        desc.setTextSize(11f);
        LinearLayout.LayoutParams descLp = new LinearLayout.LayoutParams(-1, -2);
        descLp.bottomMargin = dp(8);
        col.addView(desc, descLp);

        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);

        String[] labels = { "1.00", "0.75", "0.50", "0.25" };
        flowScaleChips = new Button[labels.length];

        for (int i = 0; i < labels.length; i++) {
            final String val = labels[i];
            Button chip = makeChip(val, val.equals(selectedFlowScale));
            chip.setOnClickListener(v -> {
                selectedFlowScale = val;
                refreshFlowScaleChips();
            });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, dp(38), 1f);
            if (i < labels.length - 1) lp.rightMargin = dp(6);
            row.addView(chip, lp);
            flowScaleChips[i] = chip;
        }
        col.addView(row);
        return col;
    }

    private void refreshFlowScaleChips() {
        String[] vals = { "1.00", "0.75", "0.50", "0.25" };
        for (int i = 0; i < flowScaleChips.length; i++) {
            setChipSelected(flowScaleChips[i], vals[i].equals(selectedFlowScale));
        }
    }

    // ── Performance mode ──────────────────────────────────────────────────────

    private android.view.View buildPerfModeRow() {
        LinearLayout col = new LinearLayout(this);
        col.setOrientation(LinearLayout.VERTICAL);

        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);

        TextView label = new TextView(this);
        label.setText("Performance mode");
        label.setTextColor(0xFFDDDDFF);
        label.setTextSize(13f);
        row.addView(label, new LinearLayout.LayoutParams(0, -2, 1f));

        perfModeSwitch = new Switch(this);
        perfModeSwitch.setChecked(BhLsfgManager.getPerfMode(this));
        row.addView(perfModeSwitch, new LinearLayout.LayoutParams(-2, -2));

        col.addView(row);

        TextView desc = new TextView(this);
        desc.setText("Trades interpolation quality for lower GPU load.");
        desc.setTextColor(0xFF666688);
        desc.setTextSize(11f);
        LinearLayout.LayoutParams dLp = new LinearLayout.LayoutParams(-1, -2);
        dLp.topMargin = dp(4);
        col.addView(desc, dLp);
        return col;
    }

    // ── Save ──────────────────────────────────────────────────────────────────

    private void saveAndFinish() {
        prefs.edit()
                .putBoolean(BhLsfgManager.KEY_ENABLED,    enableSwitch.isChecked())
                .putInt(BhLsfgManager.KEY_MULTIPLIER,     selectedMultiplier)
                .putString(BhLsfgManager.KEY_FLOW_SCALE,  selectedFlowScale)
                .putBoolean(BhLsfgManager.KEY_PERF_MODE,  perfModeSwitch.isChecked())
                .apply();

        Toast.makeText(this, "Applying to Wine containers…", Toast.LENGTH_SHORT).show();
        new Thread(() -> {
            int n = BhLsfgManager.applyToAllContainers(this);
            uiHandler.post(() -> {
                String msg = n > 0
                        ? "LSFG settings saved — applied to " + n + " container(s)"
                        : "LSFG settings saved (no containers found yet)";
                Toast.makeText(this, msg, Toast.LENGTH_LONG).show();
            });
        }).start();

        setResult(RESULT_OK);
        finish();
    }

    // ── View helpers ──────────────────────────────────────────────────────────

    private Button makeBtn(String text, int color) {
        Button btn = new Button(this);
        btn.setText(text);
        btn.setTextColor(0xFFFFFFFF);
        btn.setTextSize(13f);
        btn.setTypeface(null, Typeface.BOLD);
        btn.setPadding(dp(8), 0, dp(8), 0);
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(color);
        bg.setCornerRadius(dp(8));
        btn.setBackground(bg);
        return btn;
    }

    private Button makeChip(String text, boolean selected) {
        Button chip = new Button(this);
        chip.setText(text);
        chip.setTextSize(13f);
        chip.setPadding(0, 0, 0, 0);
        setChipSelected(chip, selected);
        return chip;
    }

    private void setChipSelected(Button chip, boolean selected) {
        GradientDrawable bg = new GradientDrawable();
        bg.setCornerRadius(dp(6));
        if (selected) {
            bg.setColor(0xFF1565C0);
            bg.setStroke(dp(1), 0xFF42A5F5);
            chip.setTextColor(0xFFFFFFFF);
            chip.setTypeface(null, Typeface.BOLD);
        } else {
            bg.setColor(0xFF1E1E3A);
            bg.setStroke(dp(1), 0xFF3A3A5A);
            chip.setTextColor(0xFF9999BB);
            chip.setTypeface(null, Typeface.NORMAL);
        }
        chip.setBackground(bg);
    }

    private int dp(int v) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v,
                getResources().getDisplayMetrics());
    }
}
