package app.revanced.extension.gamehub;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.os.Environment;
import android.util.TypedValue;
import android.view.Gravity;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * In-app file picker. Navigates directories and lets the user tap a file to select it.
 *
 * Input extras:
 *   "filter_ext"  (String, optional) — only show files with this extension, e.g. ".dll"
 *   "start_path"  (String, optional) — directory to open on launch
 *   "title"       (String, optional) — screen title (default "Select File")
 *
 * Result extra (RESULT_OK):
 *   "path" (String) — absolute path of the selected file
 *
 * Location dropdown covers three roots:
 *   App Files      — getFilesDir()  (Wine container storage)
 *   Internal       — Environment.getExternalStorageDirectory()
 *   SD Card        — getExternalFilesDirs(null)[1]  (if present)
 */
public class FilePickerActivity extends Activity {

    private String filterExt;
    private File currentDir;
    private File[] rootDirs;
    private String[] rootLabels;

    private TextView pathTV;
    private LinearLayout listContainer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        filterExt = getIntent().getStringExtra("filter_ext");
        String startPath = getIntent().getStringExtra("start_path");
        String title = getIntent().getStringExtra("title");
        if (title == null) title = "Select File";

        File rootAppFiles = getFilesDir();
        File rootInternal = Environment.getExternalStorageDirectory();
        File[] extDirs = getExternalFilesDirs(null);
        File rootSdCard = (extDirs != null && extDirs.length > 1 && extDirs[1] != null)
                ? extDirs[1] : null;

        List<String> labels = new ArrayList<>();
        List<File> dirs = new ArrayList<>();
        labels.add("App Files (Wine containers)"); dirs.add(rootAppFiles);
        labels.add("Internal Storage");            dirs.add(rootInternal);
        if (rootSdCard != null) { labels.add("SD Card"); dirs.add(rootSdCard); }

        rootLabels = labels.toArray(new String[0]);
        rootDirs   = dirs.toArray(new File[0]);

        if (startPath != null) {
            File start = new File(startPath);
            currentDir = start.isDirectory() ? start : rootAppFiles;
        } else {
            currentDir = rootAppFiles;
        }

        buildUi(title);
    }

    private void buildUi(String title) {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0D0D0D);

        // ── Header ────────────────────────────────────────────────────────────
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.VERTICAL);
        header.setBackgroundColor(0xFF1A1A2E);
        header.setPadding(dp(12), dp(10), dp(12), dp(10));

        TextView titleTV = new TextView(this);
        titleTV.setText(title);
        titleTV.setTextColor(0xFFFFFFFF);
        titleTV.setTextSize(16f);
        titleTV.setTypeface(null, Typeface.BOLD);
        header.addView(titleTV);

        if (filterExt != null) {
            TextView hintTV = new TextView(this);
            hintTV.setText("Tap a " + filterExt.toUpperCase() + " file to select it");
            hintTV.setTextColor(0xFF8888AA);
            hintTV.setTextSize(11f);
            hintTV.setPadding(0, dp(3), 0, 0);
            header.addView(hintTV);
        }

        TextView locLabel = new TextView(this);
        locLabel.setText("Location:");
        locLabel.setTextColor(0xFF8888AA);
        locLabel.setTextSize(11f);
        LinearLayout.LayoutParams locLp = new LinearLayout.LayoutParams(-2, -2);
        locLp.topMargin = dp(8);
        locLp.bottomMargin = dp(2);
        header.addView(locLabel, locLp);

        Spinner spinner = new Spinner(this);
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this,
                android.R.layout.simple_spinner_item, rootLabels);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            private boolean first = true;
            @Override
            public void onItemSelected(AdapterView<?> p, android.view.View v, int pos, long id) {
                if (first) { first = false; return; }
                currentDir = rootDirs[pos];
                refreshList();
            }
            @Override public void onNothingSelected(AdapterView<?> p) {}
        });
        header.addView(spinner, new LinearLayout.LayoutParams(-1, -2));

        pathTV = new TextView(this);
        pathTV.setTextColor(0xFF666688);
        pathTV.setTextSize(11f);
        pathTV.setPadding(0, dp(4), 0, 0);
        header.addView(pathTV);

        root.addView(header, new LinearLayout.LayoutParams(-1, -2));

        // ── File list ─────────────────────────────────────────────────────────
        ScrollView scroll = new ScrollView(this);
        listContainer = new LinearLayout(this);
        listContainer.setOrientation(LinearLayout.VERTICAL);
        listContainer.setPadding(dp(12), dp(8), dp(12), dp(24));
        scroll.addView(listContainer);
        root.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1f));

        setContentView(root);
        refreshList();
    }

    private void refreshList() {
        listContainer.removeAllViews();
        updatePathLabel();

        // Up row
        File parent = currentDir.getParentFile();
        if (parent != null && !isRoot(currentDir)) {
            listContainer.addView(makeRow("↑  Up", parent, false, true));
        }

        File[] entries = currentDir.listFiles();
        if (entries == null) {
            addEmptyLabel("(empty or no read permission)");
            return;
        }

        List<File> subdirs = new ArrayList<>();
        List<File> files   = new ArrayList<>();
        for (File f : entries) {
            if (f.isDirectory()) {
                subdirs.add(f);
            } else if (filterExt == null
                    || f.getName().toLowerCase().endsWith(filterExt.toLowerCase())) {
                files.add(f);
            }
        }
        Collections.sort(subdirs, (a, b) -> a.getName().compareToIgnoreCase(b.getName()));
        Collections.sort(files,   (a, b) -> a.getName().compareToIgnoreCase(b.getName()));

        if (subdirs.isEmpty() && files.isEmpty()) {
            String msg = filterExt != null
                    ? "(no " + filterExt.toUpperCase() + " files or subdirectories here)"
                    : "(empty)";
            addEmptyLabel(msg);
            return;
        }

        for (File d : subdirs) listContainer.addView(makeRow("📁  " + d.getName(), d, false, false));
        for (File f : files)   listContainer.addView(makeRow("📄  " + f.getName(), f, true,  false));
    }

    private boolean isRoot(File dir) {
        for (File r : rootDirs) { if (r != null && r.equals(dir)) return true; }
        return false;
    }

    private void updatePathLabel() {
        String abs = currentDir.getAbsolutePath();
        String[] parts = abs.split("/");
        pathTV.setText(parts.length <= 3 ? abs
                : "…/" + parts[parts.length - 2] + "/" + parts[parts.length - 1]);
    }

    private void addEmptyLabel(String msg) {
        TextView tv = new TextView(this);
        tv.setText(msg);
        tv.setTextColor(0xFF555577);
        tv.setTextSize(13f);
        tv.setPadding(dp(4), dp(12), dp(4), dp(8));
        listContainer.addView(tv);
    }

    private LinearLayout makeRow(String label, File target, boolean isFile, boolean isUp) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(dp(12), dp(10), dp(12), dp(10));

        GradientDrawable bg = new GradientDrawable();
        bg.setCornerRadius(dp(6));
        if (isFile) {
            bg.setColor(0xFF1E2A1E);
            bg.setStroke(dp(1), 0xFF2A4A2A);
        } else if (isUp) {
            bg.setColor(0xFF1E1A2E);
            bg.setStroke(dp(1), 0xFF2A2A3A);
        } else {
            bg.setColor(0xFF1A1E2E);
            bg.setStroke(dp(1), 0xFF2A2A3A);
        }
        row.setBackground(bg);

        TextView tv = new TextView(this);
        tv.setText(label);
        tv.setTextColor(isFile ? 0xFF88FF88 : isUp ? 0xFFAAAAAA : 0xFFDDDDFF);
        tv.setTextSize(13f);
        row.addView(tv, new LinearLayout.LayoutParams(0, -2, 1f));

        TextView chevron = new TextView(this);
        chevron.setText(isFile ? "✓" : "›");
        chevron.setTextColor(isFile ? 0xFF44AA44 : 0xFF555577);
        chevron.setTextSize(18f);
        row.addView(chevron, new LinearLayout.LayoutParams(-2, -2));

        row.setOnClickListener(v -> {
            if (isFile) {
                Intent result = new Intent();
                result.putExtra("path", target.getAbsolutePath());
                setResult(RESULT_OK, result);
                finish();
            } else {
                currentDir = target;
                refreshList();
            }
        });

        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(-1, -2);
        lp.bottomMargin = dp(6);
        row.setLayoutParams(lp);
        return row;
    }

    private int dp(int v) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v,
                getResources().getDisplayMetrics());
    }
}
