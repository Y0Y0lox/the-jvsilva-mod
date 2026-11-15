import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

var allowCountdown:Bool = false;
var inWarning:Bool = false;

var warningCam:FlxCamera;
var bg:FlxSprite;
var titleText:FlxText;
var bodyText:FlxText;
var promptText:FlxText;

function postCreate() {
    // Create a dedicated camera on top of the game and HUD
    warningCam = new FlxCamera();
    warningCam.bgColor = 0; // Transparent background
    FlxG.cameras.add(warningCam, false);

    // Black background cover
    bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    bg.cameras = [warningCam];
    add(bg);

    // Warning Header
    titleText = new FlxText(0, 140, FlxG.width, "WARNING", 48);
    titleText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.RED, "center");
    titleText.cameras = [warningCam];
    add(titleText);

    // Warning Description
    bodyText = new FlxText(100, 240, FlxG.width - 200, 
        "This song is not made for FNF fans lol\n\nmy main insporations for this was archwk and jarvis9999 - matt", 28);
    bodyText.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, "center");
    bodyText.cameras = [warningCam];
    add(bodyText);

    // Continue Prompt
    promptText = new FlxText(0, FlxG.height - 120, FlxG.width, "Press ACCEPT (Enter / Space) to continue", 24);
    promptText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.YELLOW, "center");
    promptText.cameras = [warningCam];
    add(promptText);
}

function onStartCountdown(event) {
    // Cancel the countdown on the first run to show the warning
    if (!allowCountdown) {
        event.cancel();
        inWarning = true;
    }
}

function update(elapsed:Float) {
    if (inWarning && controls.ACCEPT) {
        inWarning = false;
        CoolUtil.playMenuSFX(1); // Plays the confirm menu sound

        // Fade out all warning elements, then start the song
        FlxTween.tween(bg, {alpha: 0}, 0.5);
        FlxTween.tween(titleText, {alpha: 0}, 0.5);
        FlxTween.tween(bodyText, {alpha: 0}, 0.5);
        FlxTween.tween(promptText, {alpha: 0}, 0.5, {
            onComplete: function(twn:FlxTween) {
                // Clean up objects and camera
                remove(bg);
                remove(titleText);
                remove(bodyText);
                remove(promptText);
                FlxG.cameras.remove(warningCam);

                // Resume normal countdown
                allowCountdown = true;
                startCountdown();
            }
        });
    }
}