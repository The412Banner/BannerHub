package app.revanced.extension.gamehub;

import android.content.Context;

import java.io.File;

/** Static helper that resolves the install directory for a GOG game. */
public final class GogInstallPath {

    private GogInstallPath() {}

    /**
     * Returns the install directory for a game.
     * Path: {filesDir}/gog_games/{dirName}
     * Mirrors the layout used by BannerHub 5.3.5.
     */
    public static File getInstallDir(Context ctx, String dirName) {
        return new File(new File(ctx.getFilesDir(), "gog_games"), dirName);
    }
}
