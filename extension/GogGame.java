package app.revanced.extension.gamehub;

/** Simple data class holding one GOG game's metadata. */
public class GogGame {
    public final String gameId;
    public final String title;
    public final String imageUrl;
    public final String description;
    public final String developer;
    public final String category;
    public final int generation; // 1 or 2 (0 = unknown)

    public GogGame(String gameId, String title, String imageUrl,
                   String description, String developer, String category, int generation) {
        this.gameId     = gameId;
        this.title      = title;
        this.imageUrl   = imageUrl;
        this.description = description;
        this.developer  = developer;
        this.category   = category;
        this.generation = generation;
    }
}
