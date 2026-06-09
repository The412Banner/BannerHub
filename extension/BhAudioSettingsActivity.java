package com.xj.winemu.audio;

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
import android.widget.Spinner;
import android.widget.TextView;

/**
 * BhAudioSettingsActivity — dialog-styled per-game PulseAudio mode picker.
 *
 * One control:
 *   - Mode: Low latency (default) | Recording-compatible
 *
 * Recording-compatible loads module-aaudio-sink with pm=0 so the AAudio
 * stream stays on the AudioFlinger mixer and Android screen recording
 * captures game audio (the stock LOW_LATENCY stream can be granted as
 * exclusive MMAP, which bypasses the mixer that MediaProjection taps).
 * Only affects the PulseAudio driver; ALSA always records fine.
 *
 * Launched per-game from GameDetailSettingMenu via the static helper
 * {@link #launch(Context, String, String)} (BhAudioLambda smali stub).
 * The value is stored in the stock {@code pc_g_setting<gameId>}
 * SharedPreferences under {@code bh_audio_recording_mode} so
 * {@code BhSettingsExporter}'s per-game export/import picks it up
 * automatically. Layout/styling cloned from BhVibrationSettingsActivity —
 * the activity runs under Theme.Translucent.NoTitleBar, so every widget
 * gets explicit colors (system defaults render invisible there).
 */
public class BhAudioSettingsActivity extends Activity {

    public static final String EXTRA_GAME_ID   = "bh_audio.gameId";
    public static final String EXTRA_GAME_NAME = "bh_audio.gameName";

    private float density = 1f;

    /** Launch entry point used by the BhAudioLambda smali stub from
     *  GameDetailSettingMenu's per-game options menu. */
    public static void launch(Context ctx, String gameId, String gameName) {
        Intent it = new Intent(ctx, BhAudioSettingsActivity.class);
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

        final String gameId   = getIntent() != null ? getIntent().getStringExtra(EXTRA_GAME_ID)   : null;
        final String gameName = getIntent() != null ? getIntent().getStringExtra(EXTRA_GAME_NAME) : null;

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(dp(20), dp(14), dp(20), dp(14));
        GradientDrawable bg = new GradientDrawable();
        bg.setColor(0xFF1B1B1B);
        bg.setCornerRadius(dp(12));
        root.setBackground(bg);

        // Title row: "PC Audio Settings" on left, game name on right.
        LinearLayout titleRow = new LinearLayout(this);
        titleRow.setOrientation(LinearLayout.HORIZONTAL);
        titleRow.setGravity(Gravity.CENTER_VERTICAL);

        TextView title = new TextView(this);
        title.setText("PC Audio Settings");
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

        // ── PulseAudio mode ────────────────────────────────────────────────
        TextView modeLabel = new TextView(this);
        modeLabel.setText("PulseAudio mode");
        modeLabel.setTextColor(Color.WHITE);
        modeLabel.setTextSize(13);
        modeLabel.setPadding(0, 0, 0, dp(4));
        root.addView(modeLabel);

        final Spinner modeSpinner = new Spinner(this);
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this,
                android.R.layout.simple_spinner_dropdown_item,
                new String[] { "Low latency (default)", "Recording-compatible" });
        modeSpinner.setAdapter(adapter);
        modeSpinner.setSelection(BhAudioController.isRecordingMode(this, gameId) ? 1 : 0);
        root.addView(modeSpinner, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        TextView desc = new TextView(this);
        desc.setText("Recording-compatible keeps PulseAudio on the Android mixer so screen "
                + "recordings capture game audio (slightly higher audio latency). Only affects "
                + "the PulseAudio driver — ALSA always records fine. Takes effect on next game "
                + "launch. Saves to this game's PC config (export/import compatible).");
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

        // Save immediately on selection, no commit button (vibration-dialog
        // convention). Guard against the initial onItemSelected Android fires
        // during layout by skipping the first callback.
        modeSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            private boolean first = true;
            @Override public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                if (first) { first = false; return; }
                BhAudioController.setRecordingMode(BhAudioSettingsActivity.this, gameId, pos == 1);
            }
            @Override public void onNothingSelected(AdapterView<?> parent) { }
        });

        ScrollView scroller = new ScrollView(this);
        scroller.setVerticalScrollBarEnabled(true);
        scroller.addView(root);

        FrameLayout wrapper = new FrameLayout(this);
        wrapper.setBackgroundColor(0x00000000);
        int maxH = (int) (getResources().getDisplayMetrics().heightPixels * 0.85f);
        FrameLayout.LayoutParams scLp = new FrameLayout.LayoutParams(
                dp(480), ViewGroup.LayoutParams.WRAP_CONTENT);
        scLp.gravity = Gravity.CENTER;
        wrapper.addView(scroller, scLp);
        scroller.getLayoutParams().height = ViewGroup.LayoutParams.WRAP_CONTENT;
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

    private int dp(int v) {
        return (int) (v * density + 0.5f);
    }
}
