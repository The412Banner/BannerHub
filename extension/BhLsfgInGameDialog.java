package app.revanced.extension.gamehub;

import android.app.Dialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Handler;
import android.os.Looper;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.Window;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;

/**
 * In-game floating dialog for LSFG-VK frame generation settings.
 * Opened from the ⚙ button at the top of the Performance panel.
 * Changes save immediately; conf.toml is rewritten so the layer may
 * pick up multiplier changes without a full game restart.
 */
public class BhLsfgInGameDialog {

    private final Context ctx;
    private final String gameId;
    private final Handler uiHandler = new Handler(Looper.getMainLooper());

    private Switch enableSwitch;
    private Button[] multiplierChips;
    private Button[] flowScaleChips;
    private Switch perfModeSwitch;
    private int selectedMultiplier;
    private String selectedFlowScale;

    public BhLsfgInGameDialog(Context ctx, String gameId) {
        this.ctx = ctx;
        this.gameId = gameId;
    }

    public void show() {
        selectedMultiplier = BhLsfgManager.getMultiplier(ctx, gameId);
        selectedFlowScale  = BhLsfgManager.getFlowScale(ctx, gameId);

        Dialog dialog = new Dialog(ctx, android.R.style.Theme_DeviceDefault_Dialog_NoActionBar);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        if (dialog.getWindow() != null) {
            dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
        }

        LinearLayout root = new LinearLayout(ctx);
        root.setOrientation(LinearLayout.VERTICAL);
        GradientDrawable rootBg = new GradientDrawable();
        rootBg.setColor(0xF0111122);
        rootBg.setCornerRadius(dp(12));
        rootBg.setStroke(dp(1), 0xFF2A2A5A);
        root.setBackground(rootBg);
        root.setPadding(dp(16), dp(14), dp(16), dp(16));

        // ── Header ────────────────────────────────────────────────────────────
        LinearLayout headerRow = new LinearLayout(ctx);
        headerRow.setOrientation(LinearLayout.HORIZONTAL);
        headerRow.setGravity(Gravity.CENTER_VERTICAL);

        TextView title = new TextView(ctx);
        title.setText("⚙  LSFG Frame Gen");
        title.setTextColor(0xFFFFFFFF);
        title.setTextSize(15f);
        title.setTypeface(null, Typeface.BOLD);
        headerRow.addView(title, new LinearLayout.LayoutParams(0, -2, 1f));

        Button closeBtn = new Button(ctx);
        closeBtn.setText("✕");
        closeBtn.setTextColor(0xFFAAAAAA);
        closeBtn.setTextSize(14f);
        closeBtn.setBackground(null);
        closeBtn.setPadding(dp(8), 0, 0, 0);
        closeBtn.setOnClickListener(v -> dialog.dismiss());
        headerRow.addView(closeBtn, new LinearLayout.LayoutParams(-2, -2));

        LinearLayout.LayoutParams headerLp = new LinearLayout.LayoutParams(-1, -2);
        headerLp.bottomMargin = dp(12);
        root.addView(headerRow, headerLp);

        // ── Enable toggle ─────────────────────────────────────────────────────
        root.addView(buildDivider("Enable"));
        LinearLayout enableRow = new LinearLayout(ctx);
        enableRow.setOrientation(LinearLayout.HORIZONTAL);
        enableRow.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout.LayoutParams enableLp = new LinearLayout.LayoutParams(-1, -2);
        enableLp.bottomMargin = dp(10);
        enableRow.setLayoutParams(enableLp);

        TextView enableLabel = new TextView(ctx);
        enableLabel.setText("Frame Generation");
        enableLabel.setTextColor(0xFFDDDDFF);
        enableLabel.setTextSize(13f);
        enableRow.addView(enableLabel, new LinearLayout.LayoutParams(0, -2, 1f));

        enableSwitch = new Switch(ctx);
        enableSwitch.setChecked(BhLsfgManager.isEnabled(ctx, gameId));
        enableRow.addView(enableSwitch, new LinearLayout.LayoutParams(-2, -2));
        root.addView(enableRow);

        // ── Multiplier ────────────────────────────────────────────────────────
        root.addView(buildDivider("Multiplier"));
        root.addView(buildMultiplierRow());

        // ── Flow Scale ────────────────────────────────────────────────────────
        root.addView(buildDivider("Flow Scale"));
        root.addView(buildFlowScaleRow());

        // ── Perf Mode ─────────────────────────────────────────────────────────
        root.addView(buildDivider("Performance Mode"));
        LinearLayout perfRow = new LinearLayout(ctx);
        perfRow.setOrientation(LinearLayout.HORIZONTAL);
        perfRow.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout.LayoutParams perfLp = new LinearLayout.LayoutParams(-1, -2);
        perfLp.bottomMargin = dp(14);
        perfRow.setLayoutParams(perfLp);

        TextView perfLabel = new TextView(ctx);
        perfLabel.setText("Lower quality, less GPU load");
        perfLabel.setTextColor(0xFFAAAAAA);
        perfLabel.setTextSize(12f);
        perfRow.addView(perfLabel, new LinearLayout.LayoutParams(0, -2, 1f));

        perfModeSwitch = new Switch(ctx);
        perfModeSwitch.setChecked(BhLsfgManager.getPerfMode(ctx, gameId));
        perfRow.addView(perfModeSwitch, new LinearLayout.LayoutParams(-2, -2));
        root.addView(perfRow);

        // ── DLL status ────────────────────────────────────────────────────────
        File dll = BhLsfgManager.getSharedDllFile(ctx);
        TextView dllStatus = new TextView(ctx);
        dllStatus.setTextSize(10f);
        if (dll.isFile()) {
            dllStatus.setText("✓ Lossless.dll ready");
            dllStatus.setTextColor(0xFF44AA44);
        } else {
            dllStatus.setText("✗ Lossless.dll not found — configure in game options");
            dllStatus.setTextColor(0xFFAA4444);
        }
        LinearLayout.LayoutParams dllLp = new LinearLayout.LayoutParams(-1, -2);
        dllLp.bottomMargin = dp(12);
        root.addView(dllStatus, dllLp);

        // ── Save button ───────────────────────────────────────────────────────
        Button saveBtn = new Button(ctx);
        saveBtn.setText("Save & Apply");
        saveBtn.setTextColor(0xFFFFFFFF);
        saveBtn.setTextSize(13f);
        saveBtn.setTypeface(null, Typeface.BOLD);
        GradientDrawable saveBg = new GradientDrawable();
        saveBg.setColor(0xFF1565C0);
        saveBg.setCornerRadius(dp(8));
        saveBtn.setBackground(saveBg);
        saveBtn.setOnClickListener(v -> saveAndApply(dialog));
        root.addView(saveBtn, new LinearLayout.LayoutParams(-1, dp(44)));

        dialog.setContentView(root);
        dialog.show();
    }

    private void saveAndApply(Dialog dialog) {
        SharedPreferences prefs = ctx.getSharedPreferences("bh_lsfg_" + gameId, Context.MODE_PRIVATE);
        prefs.edit()
                .putBoolean(BhLsfgManager.KEY_ENABLED,    enableSwitch.isChecked())
                .putInt(BhLsfgManager.KEY_MULTIPLIER,     selectedMultiplier)
                .putString(BhLsfgManager.KEY_FLOW_SCALE,  selectedFlowScale)
                .putBoolean(BhLsfgManager.KEY_PERF_MODE,  perfModeSwitch.isChecked())
                .apply();

        new Thread(() -> {
            BhLsfgManager.applyToContainer(ctx, gameId);
            uiHandler.post(() -> Toast.makeText(ctx,
                    "LSFG settings saved — takes effect on next game launch",
                    Toast.LENGTH_SHORT).show());
        }).start();

        dialog.dismiss();
    }

    // ── Multiplier chips ──────────────────────────────────────────────────────

    private LinearLayout buildMultiplierRow() {
        LinearLayout row = new LinearLayout(ctx);
        row.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams rowLp = new LinearLayout.LayoutParams(-1, -2);
        rowLp.bottomMargin = dp(10);
        row.setLayoutParams(rowLp);

        String[] labels = { "Off", "2x", "3x", "4x" };
        int[]    values = {  0,     2,    3,    4   };
        multiplierChips = new Button[labels.length];

        for (int i = 0; i < labels.length; i++) {
            final int val = values[i];
            Button chip = makeChip(labels[i], val == selectedMultiplier);
            chip.setOnClickListener(v -> {
                selectedMultiplier = val;
                refreshChips(multiplierChips, values, selectedMultiplier);
            });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, dp(36), 1f);
            if (i < labels.length - 1) lp.rightMargin = dp(5);
            row.addView(chip, lp);
            multiplierChips[i] = chip;
        }
        return row;
    }

    private void refreshChips(Button[] chips, int[] values, int selected) {
        for (int i = 0; i < chips.length; i++) {
            setChipSelected(chips[i], values[i] == selected);
        }
    }

    // ── Flow scale chips ──────────────────────────────────────────────────────

    private LinearLayout buildFlowScaleRow() {
        LinearLayout row = new LinearLayout(ctx);
        row.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams rowLp = new LinearLayout.LayoutParams(-1, -2);
        rowLp.bottomMargin = dp(10);
        row.setLayoutParams(rowLp);

        String[] labels = { "1.00", "0.75", "0.50", "0.25" };
        flowScaleChips = new Button[labels.length];

        for (int i = 0; i < labels.length; i++) {
            final String val = labels[i];
            Button chip = makeChip(val, val.equals(selectedFlowScale));
            chip.setOnClickListener(v -> {
                selectedFlowScale = val;
                for (int j = 0; j < flowScaleChips.length; j++) {
                    setChipSelected(flowScaleChips[j], labels[j].equals(selectedFlowScale));
                }
            });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, dp(36), 1f);
            if (i < labels.length - 1) lp.rightMargin = dp(5);
            row.addView(chip, lp);
            flowScaleChips[i] = chip;
        }
        return row;
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private TextView buildDivider(String label) {
        TextView tv = new TextView(ctx);
        tv.setText(label);
        tv.setTextColor(0xFF7777AA);
        tv.setTextSize(10f);
        tv.setTypeface(null, Typeface.BOLD);
        tv.setAllCaps(true);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, -2);
        lp.topMargin = dp(2);
        lp.bottomMargin = dp(4);
        tv.setLayoutParams(lp);
        return tv;
    }

    private Button makeChip(String text, boolean selected) {
        Button chip = new Button(ctx);
        chip.setText(text);
        chip.setTextSize(12f);
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
                ctx.getResources().getDisplayMetrics());
    }
}
