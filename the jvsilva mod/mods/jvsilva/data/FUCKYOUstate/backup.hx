import funkin.savedata.FunkinSave;
import flixel.text.FlxText;
import flixel.util.FlxColor;

// ============================================================
// CUSTOM FREEPLAY - Codename Engine 1.0.1
//
// Put this file in:
//   data/states/FreeplayState.hx
//
// Controls:
//   UP / DOWN    = change category
//   LEFT / RIGHT = change song
//   ENTER        = play song (handled by the normal FreeplayState)
//
// Thumbnails:
//   images/freeplay/thumbnails/[category]/[song-id].png
//
// Example:
//   images/freeplay/thumbnails/jvsilva mod/song-one.png
//   images/freeplay/thumbnails/bonus song/secret-song.png
//
// IMPORTANT:
// Song IDs below must match the actual song folder/meta name.
// ============================================================


// -------------------- EDIT THESE --------------------

var categories = [
    {
        label: "jvsilva mod",
        folder: "jvsilva mod",
        songs: [
            "sharpenized",
            "jazzy",
            "andrew",
            "oxygen",
            "blissfulmatch"
        ]
    },
    {
        label: "bonus song",
        folder: "bonus",
        songs: [
            "evil",
            "ragebait",
            "lore",
            "achoastlcma",
            "wares",
            "bobicious"
        ]
    }
];

var FONT:String = "MainMenuFont.ttf";

// layout
var THUMB_X:Float = 520;
var THUMB_Y:Float = 180;
var THUMB_W:Int = 640;
var THUMB_H:Int = 460;

// Animated thumbnail settings.
// Every frame in an animated thumbnail spritesheet should be 640x460.
// Single 640x460 thumbnails still work normally.
var THUMB_FPS:Int = 24;
var THUMB_LOOP:Bool = true;

var CATEGORY_X:Float = 20;
var CATEGORY_Y:Float = 30;
var CATEGORY_GAP:Float = 68;

var SONG_NAME_X:Float = 20;
var SONG_NAME_Y:Float = 325;

var INFO_X:Float = 20;
var ACCURACY_Y:Float = 445;
var SCORE_Y:Float = 505;

// colors
var ACTIVE_CATEGORY:Int = 0xFFD9FF00;
var INACTIVE_CATEGORY:Int = 0xFFB7D86A;
var TEXT_COLOR:Int = 0xFFFFFFFF;


// -------------------- INTERNAL --------------------

var curCategory:Int = 0;
var curCategorySong:Int = 0;
var displayedSongIndex:Int = 0;

var categorySongIndices:Array<Array<Int>> = [];
var categoryTexts:Array<FlxText> = [];

var thumbnail:FlxSprite;
var songNameText:FlxText;
var accuracyText:FlxText;
var customScoreText:FlxText;
var leftArrow:FlxText;
var rightArrow:FlxText;


// Finds a song in Codename's normal Freeplay song list.
function findSongIndex(songID:String):Int {
    for (i in 0...songs.length) {
        if (songs[i].name.toLowerCase() == songID.toLowerCase())
            return i;
    }

    return -1;
}


// Makes the text objects a little easier to create.
function makeText(x:Float, y:Float, width:Float, text:String, size:Int):FlxText {
    var txt = new FlxText(x, y, width, text, size);
    txt.font = Paths.font(FONT);
    txt.color = TEXT_COLOR;
    txt.scrollFactor.set();
    return txt;
}


// Hides all of the normal Freeplay UI we are replacing.
function hideVanillaFreeplay():Void {
    if (grpSongs != null)
        grpSongs.visible = false;

    if (iconArray != null) {
        for (icon in iconArray)
            icon.visible = false;
    }

    if (scoreText != null)
        scoreText.visible = false;

    if (scoreBG != null)
        scoreBG.visible = false;

    if (diffText != null)
        diffText.visible = false;

    if (coopText != null)
        coopText.visible = false;
}


// Builds lists of indexes that point back to Codename's normal `songs` array.
function buildCategories():Void {
    categorySongIndices = [];

    for (cat in categories) {
        var validSongs:Array<Int> = [];

        for (songID in cat.songs) {
            var index = findSongIndex(songID);

            if (index >= 0)
                validSongs.push(index);
            else
                trace('[Custom Freeplay] Song not found: ' + songID);
        }

        categorySongIndices.push(validSongs);
    }
}


// Keeps us away from categories that contain no valid songs.
function findUsableCategory(direction:Int):Void {
    if (categories.length <= 0)
        return;

    var tries:Int = 0;

    while (categorySongIndices[curCategory].length <= 0 && tries < categories.length) {
        curCategory = FlxMath.wrap(curCategory + direction, 0, categories.length - 1);
        tries++;
    }
}


// Changes Codename's REAL Freeplay selection to the song we are displaying.
function syncEngineSelection():Void {
    if (categorySongIndices.length <= 0)
        return;

    if (categorySongIndices[curCategory].length <= 0)
        return;

    curCategorySong = FlxMath.wrap(
        curCategorySong,
        0,
        categorySongIndices[curCategory].length - 1
    );

    var targetIndex:Int = categorySongIndices[curCategory][curCategorySong];

    // The custom UI always redraws the exact song chosen by our category system.
    // This makes UP/DOWN show the new category's first song immediately.
    displayedSongIndex = targetIndex;

    // Keep Codename's real Freeplay selection synced too, so ACCEPT plays it.
    changeSelection(targetIndex - curSelected, true);

    // changeSelection() can make this visible again.
    hideVanillaFreeplay();

    refreshCustomUI();
}


// Changes category.
function changeCategory(amount:Int):Void {
    if (categories.length <= 1)
        return;

    curCategory = FlxMath.wrap(curCategory + amount, 0, categories.length - 1);
    findUsableCategory(amount >= 0 ? 1 : -1);

    curCategorySong = 0;

    CoolUtil.playMenuSFX(SCROLL, 0.7);
    syncEngineSelection();
}


// Changes song inside the current category.
function changeCustomSong(amount:Int):Void {
    if (categorySongIndices[curCategory].length <= 0)
        return;

    curCategorySong = FlxMath.wrap(
        curCategorySong + amount,
        0,
        categorySongIndices[curCategory].length - 1
    );

    syncEngineSelection();
}


// Updates category names in the top-left.
function refreshCategoryText():Void {
    for (i in 0...categoryTexts.length) {
        var selected:Bool = (i == curCategory);

        categoryTexts[i].text =
            categories[i].label + (selected ? "  <" : "");

        categoryTexts[i].color =
            selected ? ACTIVE_CATEGORY : INACTIVE_CATEGORY;
    }
}


// Loads ONLY the thumbnail for the currently selected song.
// There is intentionally NO rectangle/border behind this sprite.
function refreshThumbnail():Void {
    var songID:String = songs[displayedSongIndex].name;
    var categoryFolder:String = categories[curCategory].folder;

    var imagePath:String =
        "freeplay/thumbnails/" + categoryFolder + "/" + songID;

    // Load as a grid spritesheet using 640x460 frames.
    // A regular 640x460 thumbnail simply becomes a one-frame animation,
    // so static thumbnails still work with no separate setup.
    thumbnail.loadGraphic(
        Paths.image(imagePath),
        true,
        THUMB_W,
        THUMB_H
    );

    // Play every frame in the sheet from first to last.
    var thumbnailFrames:Array<Int> = [];
    for (i in 0...thumbnail.frames.frames.length)
        thumbnailFrames.push(i);

    thumbnail.animation.add(
        "thumbnail",
        thumbnailFrames,
        THUMB_FPS,
        THUMB_LOOP
    );
    thumbnail.animation.play("thumbnail", true);

    thumbnail.setGraphicSize(THUMB_W, THUMB_H);
    thumbnail.updateHitbox();

    thumbnail.x = THUMB_X;
    thumbnail.y = THUMB_Y;
    thumbnail.antialiasing = true;
}


// Updates song name + saved score/accuracy.
function refreshSongInfo():Void {
    songNameText.text = songs[displayedSongIndex].displayName;

    if (curDifficulties == null || curDifficulties.length <= 0) {
        accuracyText.text = "accuracy: --";
        customScoreText.text = "score: 0";
        return;
    }

    var saveData = FunkinSave.getSongHighscore(
        curSong.name,
        curDifficulties[curDifficulty],
        curSong.variant,
        []
    );

    var acc:Float = saveData.accuracy * 100;

    accuracyText.text =
        "accuracy: " + FlxMath.roundDecimal(acc, 2) + "%";

    customScoreText.text =
        "score: " + saveData.score;
}


function refreshCustomUI():Void {
    refreshCategoryText();
    refreshThumbnail();
    refreshSongInfo();
}


// Runs after normal Freeplay has created all of its objects.
function postCreate():Void {
    // Stops the vanilla arrows from changing songs/difficulty.
    // ENTER/BACK still work normally.
    canSelect = false;

    hideVanillaFreeplay();
    buildCategories();

    // Category labels
    for (i in 0...categories.length) {
        var txt = makeText(
            CATEGORY_X,
            CATEGORY_Y + (CATEGORY_GAP * i),
            430,
            categories[i].label,
            46
        );

        categoryTexts.push(txt);
        add(txt);
    }

    // Left side song/info
    songNameText = makeText(
        SONG_NAME_X,
        SONG_NAME_Y,
        430,
        "",
        36
    );
    add(songNameText);

    accuracyText = makeText(
        INFO_X,
        ACCURACY_Y,
        430,
        "accuracy: --",
        34
    );
    add(accuracyText);

    customScoreText = makeText(
        INFO_X,
        SCORE_Y,
        430,
        "score: 0",
        34
    );
    add(customScoreText);

    // Thumbnail
    thumbnail = new FlxSprite(THUMB_X, THUMB_Y);
    thumbnail.scrollFactor.set();
    add(thumbnail);

    // Song navigation arrows
    leftArrow = makeText(
        THUMB_X - 75,
        THUMB_Y + (THUMB_H / 2) - 35,
        60,
        "<",
        54
    );
    leftArrow.alignment = "center";
    add(leftArrow);

    rightArrow = makeText(
        THUMB_X + THUMB_W + 15,
        THUMB_Y + (THUMB_H / 2) - 35,
        60,
        ">",
        54
    );
    rightArrow.alignment = "center";
    add(rightArrow);

    // Pick the first category that actually contains a valid song.
    findUsableCategory(1);

    if (categorySongIndices.length > 0 &&
        categorySongIndices[curCategory].length > 0) {
        syncEngineSelection();
    }
}


// Custom controls.
function postUpdate(elapsed:Float):Void {
    // Keep vanilla stuff hidden in case Freeplay turns anything back on.
    hideVanillaFreeplay();

    if (controls.UP_P)
        changeCategory(-1);

    if (controls.DOWN_P)
        changeCategory(1);

    if (controls.LEFT_P)
        changeCustomSong(-1);

    if (controls.RIGHT_P)
        changeCustomSong(1);
}
