import funkin.backend.MusicBeatState;
import flixel.effects.FlxFlicker;
import flixel.text.FlxTextBorderStyle;
import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.backend.system.macros.GitCommitMacro;
import funkin.backend.utils.DiscordUtil;
import funkin.menus.credits.CreditsMain;

// Codename Engine 1.0.1 - Clone Hero inspired main menu
// Path: data/states/CloneHeroMenuState.hx
// Menu entries route to the matching native FNF/Codename Engine states. ESC returns to TitleState.


var labels = ["FREEPLAY", "NEWS", "MODS", "OPTIONS", "CREDITS"];
var items = [];
var itemButtons = [];
var itemAccents = [];

var selected:Int = 0;
var locked:Bool = false;

function create() {
    FlxG.mouse.visible = true;

    // Background
    add(new FlxSprite().makeGraphic(
        FlxG.width, FlxG.height, 0xFF071321
    ));

    var glow = new FlxSprite(0, FlxG.height * 0.18)
        .makeGraphic(FlxG.width, Std.int(FlxG.height * 0.66), 0xFF0D2940);
    glow.alpha = 0.72;
    add(glow);

    var bandA = new FlxSprite(
        -FlxG.width * 0.08, FlxG.height * 0.69
    ).makeGraphic(Std.int(FlxG.width * 2), 7, 0xFF174E70);
    bandA.angle = -8;
    bandA.alpha = 0.55;
    add(bandA);

    var bandB = new FlxSprite(
        -FlxG.width * 0.10, FlxG.height * 0.82
    ).makeGraphic(Std.int(FlxG.width * 2), 3, 0xFF2C789A);
    bandB.angle = -8;
    bandB.alpha = 0.35;
    add(bandB);

    add(new FlxSprite(0, 0).makeGraphic(
        FlxG.width, 5, 0xFF49B6D8
    ));

    var leftX = 58.0;
    var leftWidth = FlxG.width * 0.49;
    var rightX = FlxG.width * 0.60;
    var rightWidth = FlxG.width * 0.35;

    // Header
    var title = new FlxText(
        leftX, 28, leftWidth + 30,
        "FRIDAY NIGHT FUNKIN'", 48
    );
    title.setFormat(null, 48, 0xFFFFFFFF, "left");
    title.angle = -1;
    add(title);

    var subtitle = new FlxText(
        leftX + 5, 91, leftWidth + 20,
        "COMMUNITY EDITION  //  FRIDAY NIGHT FUNKIN'", 12
    );
    subtitle.setFormat(null, 12, 0xFF8EAFC7, "left");
    add(subtitle);

    var headerLine = new FlxSprite(leftX, 119)
        .makeGraphic(Std.int(leftWidth - 12), 2, 0xFF2F7798);
    headerLine.alpha = 0.8;
    add(headerLine);

    // Navigation buttons
    var buttonY = 145.0;
    var buttonGap = 75.0;
    var buttonW = leftWidth - 18;
    var buttonH = 57;

    for (i in 0...labels.length) {
        var bx = leftX + (i % 2 == 0 ? 0 : 7);
        var by = buttonY + i * buttonGap;

        var button = new FlxSprite(bx, by)
            .makeGraphic(
                Std.int(buttonW),
                Std.int(buttonH),
                0xFF172B40
            );

        button.ID = i;
        button.angle = -1.2;
        add(button);
        itemButtons.push(button);

        var accent = new FlxSprite(bx, by)
            .makeGraphic(6, Std.int(buttonH), 0xFF49B6D8);

        accent.ID = i;
        accent.angle = -1.2;
        add(accent);
        itemAccents.push(accent);

        var item = new FlxText(
            bx + 27, by + 10, buttonW - 45,
            labels[i], 28
        );

        item.setFormat(null, 28, 0xFFE7F0F8, "left");
        item.angle = -1.2;
        item.ID = i;
        add(item);
        items.push(item);
    }

    // News panel
    var newsPanel = new FlxSprite(rightX, 139)
        .makeGraphic(
            Std.int(rightWidth),
            Std.int(FlxG.height * 0.69),
            0xE9112232
        );
    newsPanel.angle = 0.35;
    add(newsPanel);

    add(new FlxSprite(rightX + 12, 151)
        .makeGraphic(
            Std.int(rightWidth - 24), 4, 0xFF49B6D8
        ));

    var newsHeader = new FlxText(
        rightX + 18, 169, rightWidth - 36,
        "LATEST NEWS", 23
    );
    newsHeader.setFormat(null, 23, 0xFFFFFFFF, "left");
    add(newsHeader);

    var newsSub = new FlxText(
        rightX + 19, 199, rightWidth - 38,
        "COMMUNITY UPDATES  /  BULLETIN", 10
    );
    newsSub.setFormat(null, 10, 0xFF69BBD5, "left");
    add(newsSub);

    var newsEntries = [
        {
            category: "BREAKING",
            title: "Y0Y0 SHIT THE BED",
            description: "An unfortunate development. More at 11."
        },
        {
            category: "COMMUNITY",
            title: "PIRL AND JV DISCUSSING DIFFERENT LORE",
            description: "Nobody knows how this conversation started."
        },
        {
            category: "IMPORTANT",
            title: "MATT PLAYING CLONE HERO TRUST",
            description: "He has allegedly been playing Clone Hero."
        }
    ];

    for (i in 0...newsEntries.length) {
        var ny = 231 + i * 112;

        var card = new FlxSprite(rightX + 13, ny)
            .makeGraphic(
                Std.int(rightWidth - 26), 99, 0xFF14283B
            );
        card.alpha = 0.96;
        add(card);

        add(new FlxSprite(rightX + 13, ny)
            .makeGraphic(
                4, 99,
                i == 0 ? 0xFFFF6A70 : 0xFF49B6D8
            ));

        var cat = new FlxText(
            rightX + 27, ny + 9, rightWidth - 54,
            "// " + newsEntries[i].category, 10
        );
        cat.setFormat(null, 10, 0xFF63C6E1, "left");
        add(cat);

        var headline = new FlxText(
            rightX + 27, ny + 27, rightWidth - 54,
            newsEntries[i].title, 15
        );
        headline.setFormat(null, 15, 0xFFF2F7FB, "left");
        add(headline);

        var body = new FlxText(
            rightX + 27, ny + 58, rightWidth - 54,
            newsEntries[i].description, 11
        );
        body.setFormat(null, 11, 0xFF9DB2C5, "left");
        add(body);
    }

    var newsHint = new FlxText(
        rightX + 17, FlxG.height * 0.82,
        rightWidth - 34,
        "SELECT NEWS TO READ ALL UPDATES  >", 10
    );
    newsHint.setFormat(null, 10, 0xFF7EA8C2, "left");
    add(newsHint);

    var footer = new FlxText(
        58, FlxG.height - 39, FlxG.width - 116,
        "UP / DOWN: SELECT     ENTER: CONFIRM     ESC: TITLE SCREEN",
        11
    );
    footer.setFormat(null, 11, 0xFF8EA8C1, "left");
    add(footer);

    changeSelection(0);
}

function update(elapsed:Float) {
    if (locked) return;

    if (FlxG.keys.justPressed.UP ||
        FlxG.keys.justPressed.W)
        changeSelection(-1);

    if (FlxG.keys.justPressed.DOWN ||
        FlxG.keys.justPressed.S)
        changeSelection(1);

    if (FlxG.keys.justPressed.ENTER ||
        FlxG.keys.justPressed.SPACE)
        acceptSelection();

    if (FlxG.keys.justPressed.ESCAPE ||
        FlxG.keys.justPressed.BACKSPACE)
        returnToTitleScreen();

    if (FlxG.keys.justPressed.SEVEN ||
        FlxG.keys.justPressed.NUMPADSEVEN)
        openDebug();

    // Mouse hover
    for (i in 0...itemButtons.length) {
        if (FlxG.mouse.overlaps(itemButtons[i]) &&
            selected != i) {
            changeSelection(i - selected);
        }
    }

    if (FlxG.mouse.justPressed) {
        for (i in 0...itemButtons.length) {
            if (FlxG.mouse.overlaps(itemButtons[i])) {
                if (selected != i)
                    changeSelection(i - selected);

                acceptSelection();
                break;
            }
        }
    }

    // Selection animation
    for (i in 0...items.length) {
        var item = items[i];
        var button = itemButtons[i];
        var accent = itemAccents[i];

        if (i == selected) {
            item.alpha = FlxMath.lerp(
                item.alpha, 1, elapsed * 8
            );
            item.color = 0xFF62D5F0;

            button.color = 0xFF2B526D;
            button.alpha = FlxMath.lerp(
                button.alpha, 1, elapsed * 8
            );
            button.angle = FlxMath.lerp(
                button.angle, -1.9, elapsed * 7
            );

            item.angle = button.angle;
            accent.angle = button.angle;
            accent.alpha = 1;
        } else {
            item.alpha = FlxMath.lerp(
                item.alpha, 0.78, elapsed * 8
            );
            item.color = 0xFFE7F0F8;

            button.color = 0xFF172B40;
            button.alpha = FlxMath.lerp(
                button.alpha, 0.88, elapsed * 8
            );
            button.angle = FlxMath.lerp(
                button.angle, -1.2, elapsed * 7
            );

            item.angle = button.angle;
            accent.angle = button.angle;
            accent.alpha = 0.35;
        }
    }
}

function changeSelection(change:Int) {
    selected = (selected + change + labels.length)
        % labels.length;

    FlxG.sound.play(Paths.sound("scrollMenu"), 0.55);
}

function acceptSelection() {
    if (locked) return;

    locked = true;
    FlxG.sound.play(Paths.sound("confirmMenu"), 0.7);

    switch (labels[selected]) {
        case "FREEPLAY":
            FlxG.switchState(new FreeplayState());

        case "NEWS":
            FlxG.switchState(new ModState("CloneHeroNewsSubState"));

        case "MODS":
            FlxG.switchState(new ModState("CloneHeroModsSubState"));

	case "CREDITS":
    	    FlxG.switchState(new CreditsMain());

	case "OPTIONS":
            FlxG.switchState(new OptionsMenu());
    }
}

function returnToTitleScreen() {
    FlxG.switchState(new TitleState());
}


function returnToTitleScreen() {
    FlxG.switchState(new TitleState());
}

function openDebug() {
    var candidates = [
        "funkin.menus.MasterEditorMenu",
        "funkin.menus.DebugMenuState",
        "MasterEditorMenu"
    ];

    for (name in candidates) {
        var cls = Type.resolveClass(name);

        if (cls != null) {
            try {
                FlxG.switchState(Type.createInstance(cls, []));
                return;
            } catch (e:Dynamic) {
                trace("Debug shortcut: " + e);
            }
        }
    }

    trace("Clone Hero Menu: No known debug state found.");
}