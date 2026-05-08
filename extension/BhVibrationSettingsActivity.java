package com.xj.winemu.vibration;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.SeekBar;
import android.widget.Spinner;
import android.widget.TextView;

/**
 * BhVibrationSettingsActivity — dialog-styled settings screen for PC-accurate rumble.
 *
 * Surfaces two controls per game container:
 *   - Mode:      Off | Controller | Device | Both
 *   - Intensity: 0 – 100 %
 *
 * Launched per-game from GameDetailSettingMenu via the static helper
 * {@link #launch(Context, String, String)}. Settings are stored in the
 * stock {@code pc_g_setting<gameId>} SharedPreferences file under prefixed
 * keys ({@code bh_vibration_mode}, {@code bh_vibration_intensity}) so
 * {@code BhSettingsExporter}'s existing per-game export/import path picks
 * them up automatically. Older config files lacking these keys fall back
 * to global defaults.
 */
public class BhVibrationSettingsActivity extends Activity {

    public static final String EXTRA_GAME_ID   = "bh_vibration.gameId";
    public static final String EXTRA_GAME_NAME = "bh_vibration.gameName";

    // Cached once in onCreate so dp() doesn't repeatedly hit Resources.
    private float density = 1f;

    /** Launch entry point used by the BhVibrationLambda smali stub from
     *  GameDetailSettingMenu's per-game options menu. */
    public static void launch(Context ctx, String gameId, String gameName) {
        Intent it = new Intent(ctx, BhVibrationSettingsActivity.class);
        it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (gameId != null) it.putExtra(EXTRA_GAME_ID, gameId);
        if (gameName != null) it.putExtra(EXTRA_GAME_NAME, gameName);
        ctx.startActivity(it);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        density = getResources().getDisplayMetrics().density;
        getWindow().setBackgroundDrawable(new ColorDrawable(0xCC000000));

        String gameId   = getIntent() != null ? getIntent().getStringExtra(EXTRA_GAME_ID)   : null;
        String gameName = getIntent() != null ? getIntent().getStringExtra(EXTRA_GAME_NAME) : null;

        BhVibrationController ctl = BhVibrationController.getInstance();
        ctl.init(this);
        ctl.setContainerForSettings(gameId);

        // Compact landscape layout: tighter paddings, smaller fonts, no
        // long description block. Wraps in a ScrollView so any future
        // additions or larger system font sizes can scroll instead of
        // clipping the title or Close button off-screen.
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(dp(20), dp(14), dp(20), dp(14));
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(0xFF1B1B1B);
        bg.setCornerRadius(dp(12));
        root.setBackground(bg);

        // Title row: "PC Vibration Settings" on left, game name on right.
        // Single line, saves vertical space vs stacking.
        LinearLayout titleRow = new LinearLayout(this);
        titleRow.setOrientation(LinearLayout.HORIZONTAL);
        titleRow.setGravity(Gravity.CENTER_VERTICAL);

        TextView title = new TextView(this);
        title.setText("PC Vibration Settings");
        title.setTextColor(Color.WHITE);
        title.setTextSize(16);
        title.setTypeface(Typeface.DEFAULT_BOLD);
        titleRow.addView(title, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));

        TextView subtitle = new TextView(this);
        if (gameName != null && !gameName.isEmpty()) {
            subtitle.setText(gameName);
        } else if (gameId != null && !gameId.isEmpty()) {
            subtitle.setText("Game " + gameId);
        } else {
            subtitle.setText("Global");
        }
        subtitle.setTextColor(0xFFFFD54F);
        subtitle.setTextSize(12);
        subtitle.setSingleLine(true);
        subtitle.setMaxWidth(dp(160));
        subtitle.setEllipsize(android.text.TextUtils.TruncateAt.END);
        titleRow.addView(subtitle);

        LinearLayout.LayoutParams titleLp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        titleLp.bottomMargin = dp(10);
        titleRow.setLayoutParams(titleLp);
        root.addView(titleRow);

        // ── Mode + Intensity in a single row (left = mode, right = intensity)
        // to keep the dialog short enough for landscape phone screens.
        LinearLayout controlsRow = new LinearLayout(this);
        controlsRow.setOrientation(LinearLayout.HORIZONTAL);

        LinearLayout modeCol = new LinearLayout(this);
        modeCol.setOrientation(LinearLayout.VERTICAL);

        TextView modeLabel = new TextView(this);
        modeLabel.setText("Mode");
        modeLabel.setTextColor(Color.WHITE);
        modeLabel.setTextSize(13);
        modeLabel.setPadding(0, 0, 0, dp(4));
        modeCol.addView(modeLabel);

        final Spinner modeSpinner = new Spinner(this);
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this,
                android.R.layout.simple_spinner_dropdown_item,
                new String[] { "Off", "Controller", "Device", "Both" });
        modeSpinner.setAdapter(adapter);
        modeSpinner.setSelection(clampMode(ctl.getMode()));
        modeCol.addView(modeSpinner);

        // Mode column: wrap_content so the spinner is wide enough to render
        // "Controller" (the longest option label) without truncating to
        // "Control.." Intensity below takes the remaining space.
        LinearLayout.LayoutParams modeColLp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        modeColLp.rightMargin = dp(16);
        controlsRow.addView(modeCol, modeColLp);

        LinearLayout intCol = new LinearLayout(this);
        intCol.setOrientation(LinearLayout.VERTICAL);

        LinearLayout intLabelRow = new LinearLayout(this);
        intLabelRow.setOrientation(LinearLayout.HORIZONTAL);
        intLabelRow.setPadding(0, 0, 0, dp(4));
        TextView intLabel = new TextView(this);
        intLabel.setText("Intensity");
        intLabel.setTextColor(Color.WHITE);
        intLabel.setTextSize(13);
        intLabelRow.addView(intLabel, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));

        final TextView intValue = new TextView(this);
        intValue.setText(ctl.getIntensity() + "%");
        intValue.setTextColor(0xFFFFD54F);
        intValue.setTextSize(13);
        intLabelRow.addView(intValue);
        intCol.addView(intLabelRow);

        final SeekBar bar = new SeekBar(this);
        bar.setMax(100);
        bar.setProgress(ctl.getIntensity());
        intCol.addView(bar);

        controlsRow.addView(intCol, new LinearLayout.LayoutParams(
                0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));

        root.addView(controlsRow);

        // Tiny one-line tip — much shorter than the previous paragraph
        // and only really useful on first launch. Ellipsizes if too long.
        TextView desc = new TextView(this);
        desc.setText("Settings save to this game's PC config (export/import compatible).");
        desc.setTextColor(0xFF999999);
        desc.setTextSize(11);
        LinearLayout.LayoutParams descLp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        descLp.topMargin = dp(8);
        desc.setLayoutParams(descLp);
        root.addView(desc);

        // ── Close ──────────────────────────────────────────────────────────
        LinearLayout btnRow = new LinearLayout(this);
        btnRow.setOrientation(LinearLayout.HORIZONTAL);
        btnRow.setGravity(Gravity.END);
        LinearLayout.LayoutParams btnRowLp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        btnRowLp.topMargin = dp(8);
        btnRow.setLayoutParams(btnRowLp);

        Button close = new Button(this);
        close.setText("Close");
        close.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { finish(); }
        });
        btnRow.addView(close);
        root.addView(btnRow);

        // Wire change handlers → save immediately, no commit button needed.
        modeSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                ctl.setMode(pos);
            }
            @Override public void onNothingSelected(AdapterView<?> parent) { }
        });
        bar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override public void onProgressChanged(SeekBar sb, int progress, boolean fromUser) {
                intValue.setText(progress + "%");
                if (fromUser) ctl.setIntensity(progress);
            }
            @Override public void onStartTrackingTouch(SeekBar sb) { }
            @Override public void onStopTrackingTouch(SeekBar sb) { }
        });

        // Wrap in a ScrollView so the dialog tolerates taller-than-expected
        // content (large system fonts, narrow landscape splits) without
        // ever clipping the title at the top or Close at the bottom.
        // Background lives on the LinearLayout (rounded corners), ScrollView
        // stays transparent.
        ScrollView scroller = new ScrollView(this);
        scroller.setVerticalScrollBarEnabled(true);
        scroller.addView(root);

        FrameLayout wrapper = new FrameLayout(this);
        wrapper.setBackgroundColor(0x00000000);
        // ~480 dp wide so the side-by-side Mode/Intensity row doesn't squeeze
        // the Spinner. Height capped at 85 % of the screen — anything taller
        // becomes scrollable rather than clipped.
        int maxH = (int) (getResources().getDisplayMetrics().heightPixels * 0.85f);
        FrameLayout.LayoutParams scLp = new FrameLayout.LayoutParams(
                dp(480), ViewGroup.LayoutParams.WRAP_CONTENT);
        scLp.gravity = Gravity.CENTER;
        wrapper.addView(scroller, scLp);
        scroller.getLayoutParams().height = ViewGroup.LayoutParams.WRAP_CONTENT;
        // Manually clamp height after first measure.
        final int finalMaxH = maxH;
        final ScrollView finalScroller = scroller;
        scroller.post(new Runnable() {
            @Override public void run() {
                if (finalScroller.getHeight() > finalMaxH) {
                    ViewGroup.LayoutParams lp = finalScroller.getLayoutParams();
                    lp.height = finalMaxH;
                    finalScroller.setLayoutParams(lp);
                }
            }
        });

        setContentView(wrapper);
    }

    private int clampMode(int v) {
        if (v < 0) return 0;
        if (v > 3) return 3;
        return v;
    }

    private int dp(int v) {
        return (int) (v * density + 0.5f);
    }
}
