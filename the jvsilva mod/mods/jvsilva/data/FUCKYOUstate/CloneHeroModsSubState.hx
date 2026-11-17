
import funkin.backend.assets.ModsFolder;
import sys.FileSystem;
import haxe.io.Path;

var modFolders:Array<Dynamic> = [];
var modNames:Array<String> = [];
var modItems:Array<FlxText> = [];

var selected:Int = 0;

function create() {
    FlxG.mouse.visible = true;

    modFolders = [];
    modNames = [];
    modItems = [];
    selected = 0;

    // Background
    add(new FlxSprite().makeGraphic(
        FlxG.width, FlxG.height, 0xFF071321
    ));

    var glow = new FlxSprite(0, FlxG.height * 0.2)
        .makeGraphic(
            FlxG.width,
            Std.int(FlxG.height * 0.7),
            0xFF0D2940
        );

    glow.alpha = 0.7;
    add(glow);

    // Top accent
    add(new FlxSprite(0, 0).makeGraphic(
        FlxG.width, 5, 0xFF49B6D8
    ));

    // Title
    var title = new FlxText(
        55, 35, FlxG.width - 110,
        "MODS // MOD SELECT", 34
    );

    title.setFormat(null, 34, 0xFFFFFFFF, "left");
    add(title);

    // Subtitle
    var subtitle = new FlxText(
        58, 82, FlxG.width - 116,
        "SELECT AN INSTALLED MOD", 12
    );

    subtitle.setFormat(null, 12, 0xFF8EAFC7, "left");
    add(subtitle);

    // Separator
    add(new FlxSprite(55, 111).makeGraphic(
        FlxG.width - 110, 2, 0xFF2F7798
    ));

    loadMods();
    createModItems();

    // Footer
    var footer = new FlxText(
        55,
        FlxG.height - 48,
        FlxG.width - 110,
        "UP / DOWN: SELECT     ENTER: SWITCH MOD     ESC: TITLE SCREEN",
        12
    );

    footer.setFormat(null, 12, 0xFF8EAFC7, "left");
    add(footer);
}




function loadMods() {
    modFolders = [];
    modNames = [];

    var discovered:Array<String> = [];

    // Get mods recognized by Codename Engine.
    try {
        var list = ModsFolder.getModsList({
            descending: false,
            mode: "CLEAN"
        });

        if (list != null) {
            for (mod in list) {
                if (mod != null && !discovered.contains(mod))
                    discovered.push(mod);
            }
        }
    } catch (e:Dynamic) {
        trace("CloneHeroMods: getModsList failed: " + e);
    }

    // Add the currently active mod if it wasn't discovered.
    var current:String = ModsFolder.currentModFolder;

    if (current != null && current != "" && !discovered.contains(current))
        discovered.push(current);

    // Build the list using folder names, not config display names.
    for (mod in discovered) {
        modFolders.push(mod);

        var displayName = mod;

        if (mod == current)
            displayName += "  [CURRENT]";

        modNames.push(displayName);
    }

    // Null is required for Disable Mods.
    modFolders.push(null);
    modNames.push("DISABLE MODS");

    trace("CloneHeroMods: Final mod list: " + modFolders);
}


function createModItems() {
    if (modNames.length == 0) {
        var empty = new FlxText(
            55, 180, FlxG.width - 110,
            "NO MODS FOUND", 24
        );

        empty.setFormat(null, 24, 0xFF9DB2C5, "center");
        add(empty);
        return;
    }

    for (i in 0...modNames.length) {
        var item = new FlxText(
            85,
            145 + i * 53,
            FlxG.width - 170,
            modNames[i],
            24
        );

        item.ID = i;
        item.setFormat(null, 24, 0xFFE7F0F8, "left");

        add(item);
        modItems.push(item);
    }

    changeSelection(0);
}

function update(elapsed:Float) {
    // ESC returns to the title screen.
    if (FlxG.keys.justPressed.ESCAPE ||
        FlxG.keys.justPressed.BACKSPACE) {

        FlxG.switchState(new TitleState());
        return;
    }

    if (modItems.length == 0)
        return;

    // Keyboard navigation.
    if (FlxG.keys.justPressed.UP ||
        FlxG.keys.justPressed.W) {
        changeSelection(-1);
    }

    if (FlxG.keys.justPressed.DOWN ||
        FlxG.keys.justPressed.S) {
        changeSelection(1);
    }

    // Confirm selection.
    if (FlxG.keys.justPressed.ENTER ||
        FlxG.keys.justPressed.SPACE) {
        switchMod();
        return;
    }

    // Mouse navigation and selection.
    for (i in 0...modItems.length) {
        var item = modItems[i];

        if (FlxG.mouse.overlaps(item)) {
            if (selected != i) {
                changeSelection(i - selected);
            }

            if (FlxG.mouse.justPressed) {
                switchMod();
                return;
            }
        }

        // Selected item animation.
        if (i == selected) {
            item.color = 0xFF62D5F0;
            item.alpha = 1;

            item.scale.set(
                FlxMath.lerp(item.scale.x, 1.06, elapsed * 8),
                FlxMath.lerp(item.scale.y, 1.06, elapsed * 8)
            );
        } else {
            item.color = 0xFFE7F0F8;
            item.alpha = 0.65;

            item.scale.set(
                FlxMath.lerp(item.scale.x, 1, elapsed * 8),
                FlxMath.lerp(item.scale.y, 1, elapsed * 8)
            );
        }
    }
}

function changeSelection(change:Int) {
    if (modItems.length == 0)
        return;

    selected = (selected + change + modItems.length)
        % modItems.length;

    FlxG.sound.play(Paths.sound("scrollMenu"), 0.55);
}

function switchMod() {
    if (selected < 0 || selected >= modFolders.length)
        return;

    try {
        // CNE handles the mod switch and game reload.
        ModsFolder.switchMod(modFolders[selected]);

    } catch (e:Dynamic) {
        trace("CloneHeroMods: Switching failed: " + e);
    }
}

