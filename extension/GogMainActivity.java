package app.revanced.extension.gamehub;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

/**
 * Entry point for the GOG integration.
 * Shows either a login card or a signed-in card depending on
 * whether "bh_gog_prefs" contains a valid access_token.
 *
 * Launched from the side menu (ID=10).
 * On resume (return from GogLoginActivity) refreshes the card visibility.
 */
public class GogMainActivity extends Activity {

    private LinearLayout loginCard;
    private LinearLayout loggedInCard;
    private TextView usernameView;

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FrameLayout root = new FrameLayout(this);
        root.setBackgroundColor(0xFF0D0D0D);

        loginCard    = buildLoginCard();
        loggedInCard = buildLoggedInCard();

        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(-1, -1); // MATCH_PARENT
        root.addView(loginCard, lp);
        root.addView(loggedInCard, new FrameLayout.LayoutParams(-1, -1));

        setContentView(root);
        refreshView();
    }

    @Override
    protected void onResume() {
        super.onResume();
        // If GogGamesActivity stored a pending launch, finish this activity
        // so LandscapeLauncherMainActivity resumes and fires checkPendingLaunch.
        if (getSharedPreferences("bh_gog_prefs", 0)
                .getString("pending_gog_exe", null) != null) {
            finish();
            return;
        }
        refreshView();
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private int dp(int v) {
        float density = getResources().getDisplayMetrics().density;
        return (int) (v * density);
    }

    private boolean isLoggedIn() {
        String token = getSharedPreferences("bh_gog_prefs", 0)
                .getString("access_token", null);
        return token != null;
    }

    private void refreshView() {
        if (loginCard == null) return;
        boolean loggedIn = isLoggedIn();
        loginCard.setVisibility(loggedIn ? View.GONE : View.VISIBLE);
        loggedInCard.setVisibility(loggedIn ? View.VISIBLE : View.GONE);

        if (loggedIn && usernameView != null) {
            String user = getSharedPreferences("bh_gog_prefs", 0)
                    .getString("username", "Unknown");
            usernameView.setText("Signed in as: " + user);
        }
    }

    // ── Login card ────────────────────────────────────────────────────────────

    private LinearLayout buildLoginCard() {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundColor(0xFF1A1A2E);
        card.setGravity(Gravity.CENTER);
        int pad = dp(40);
        card.setPadding(pad, pad, pad, pad);

        // Title
        TextView title = new TextView(this);
        title.setText("GOG.com");
        title.setTextSize(32f);
        title.setTextColor(0xFFFFFFFF);
        title.setGravity(Gravity.CENTER);
        title.setTypeface(null, Typeface.BOLD);
        card.addView(title);

        // Subtitle
        TextView sub = new TextView(this);
        sub.setText("Sign in to access your GOG game library");
        sub.setTextSize(14f);
        sub.setTextColor(0xFFAAAAAA);
        sub.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams subLp = new LinearLayout.LayoutParams(-2, -2);
        subLp.topMargin = dp(16);
        card.addView(sub, subLp);

        // Login button
        Button loginBtn = new Button(this);
        loginBtn.setText("Login with GOG");
        loginBtn.setBackgroundColor(0xFF7033FF);
        loginBtn.setTextColor(0xFFFFFFFF);
        LinearLayout.LayoutParams btnLp = new LinearLayout.LayoutParams(-2, -2);
        btnLp.topMargin = dp(24);
        loginBtn.setOnClickListener(v ->
                startActivity(new Intent(this, GogLoginActivity.class)));
        card.addView(loginBtn, btnLp);

        return card;
    }

    // ── Logged-in card ────────────────────────────────────────────────────────

    private LinearLayout buildLoggedInCard() {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setBackgroundColor(0xFF1A1A2E);
        card.setGravity(Gravity.CENTER);
        int pad = dp(40);
        card.setPadding(pad, pad, pad, pad);

        // Title
        TextView title = new TextView(this);
        title.setText("GOG.com");
        title.setTextSize(32f);
        title.setTextColor(0xFFFFFFFF);
        title.setGravity(Gravity.CENTER);
        title.setTypeface(null, Typeface.BOLD);
        card.addView(title);

        // Username
        usernameView = new TextView(this);
        usernameView.setText("");
        usernameView.setTextSize(14f);
        usernameView.setTextColor(0xFFCCCCCC);
        usernameView.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams userLp = new LinearLayout.LayoutParams(-2, -2);
        userLp.topMargin = dp(16);
        card.addView(usernameView, userLp);

        // View Library button
        Button libraryBtn = new Button(this);
        libraryBtn.setText("View Game Library");
        libraryBtn.setBackgroundColor(0xFF7033FF);
        libraryBtn.setTextColor(0xFFFFFFFF);
        LinearLayout.LayoutParams libLp = new LinearLayout.LayoutParams(-2, -2);
        libLp.topMargin = dp(24);
        libraryBtn.setOnClickListener(v ->
                startActivity(new Intent(this, GogGamesActivity.class)));
        card.addView(libraryBtn, libLp);

        // Sign out button
        Button signOutBtn = new Button(this);
        signOutBtn.setText("Sign Out");
        signOutBtn.setBackgroundColor(0xFF444444);
        signOutBtn.setTextColor(0xFFFFFFFF);
        LinearLayout.LayoutParams soLp = new LinearLayout.LayoutParams(-2, -2);
        soLp.topMargin = dp(16);
        signOutBtn.setOnClickListener(v -> {
            getSharedPreferences("bh_gog_prefs", 0).edit().clear().apply();
            refreshView();
        });
        card.addView(signOutBtn, soLp);

        return card;
    }
}
