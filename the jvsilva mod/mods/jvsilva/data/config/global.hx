var cursorLoaded:Bool = false;

function applyCustomCursor() {
    FlxG.mouse.useSystemCursor = false;

    // Smaller custom cursor
    FlxG.mouse.load(Paths.image("jvsilva cursor idle"), 0.6, 12, 13);

    FlxG.mouse.visible = true;
    cursorLoaded = true;
}

function postGameStart() {
    applyCustomCursor();
}

function postStateSwitch() {
    applyCustomCursor();
}

function postUpdate(elapsed:Float) {
    FlxG.mouse.useSystemCursor = false;
    FlxG.mouse.visible = true;

    if (!cursorLoaded)
        applyCustomCursor();
}