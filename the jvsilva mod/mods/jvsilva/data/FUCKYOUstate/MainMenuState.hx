import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.backend.FunkinText;

// ============================================================
// Y0Y0LOX CUSTOM MAIN MENU
// Put this file in:
// data/states/MainMenuState.hx
//
// Font:
// fonts/MainMenuFont.ttf
//
// Preview images:
// images/mainmenu/freeplay.png
// images/mainmenu/gallery.png
// images/mainmenu/options.png
// images/mainmenu/credits.png
// ============================================================

var customBG:FlxSprite;
var previewImage:FlxSprite;

var customMenuTexts:Array<FunkinText> = [];
var uiReady:Bool = false;

// Mockup colours
var BG_COLOR:Int = 0xFF06B000;
var TEXT_COLOR:Int = 0xFFC4FF0E;

// Left menu layout
var MENU_X:Float = 40;
var MENU_START_Y:Float = 125;
var MENU_SPACING:Float = 140;
var MENU_FONT_SIZE:Int = 82;

// Selected item animation
var SELECT_OFFSET_X:Float = 30;
var SELECT_SCALE:Float = 1.12;
var NORMAL_SCALE:Float = 1.0;
var TWEEN_TIME:Float = 0.5;

// Right preview area
var PREVIEW_X:Float = 578;
var PREVIEW_Y:Float = 51;
var PREVIEW_W:Float = 612;
var PREVIEW_H:Float = 669;

// How far to the right the image starts before sliding in
var PREVIEW_SLIDE_DISTANCE:Float = 300;


// This runs from MainMenuState's super.create() BEFORE the normal
// menu buttons are generated, so we can force the menu to only
// contain these three choices.
function create()
{
    optionShit = [
        "freeplay",
        "gallery",
        "options",
        "credits"
    ];
}


// Runs after Codename has finished making its normal Main Menu.
function postCreate()
{
    forceCenterX = false;

    // Hide Codename's normal visual menu.
    // We keep the objects alive because MainMenuState still uses them
    // internally for selection and opening states.
    for (item in menuItems.members)
    {
        if (item != null)
        {
            item.visible = false;
            item.alpha = 0;
        }
    }

    // ---------- FULL GREEN BACKGROUND ----------
    customBG = new FlxSprite(0, 0);
    customBG.makeGraphic(FlxG.width, FlxG.height, BG_COLOR);
    customBG.scrollFactor.set(0, 0);
    add(customBG);

    previewImage = new FlxSprite();
    previewImage.scrollFactor.set(0, 0);
    previewImage.antialiasing = true;
    add(previewImage);


    // ---------- LEFT MENU TEXT ----------
    var displayNames:Array<String> = [
        "Freeplay",
        "Gallery",
        "Options",
        "Credits"
    ];

    for (i in 0...displayNames.length)
    {
        var text:FunkinText = new FunkinText(
            MENU_X,
            MENU_START_Y + (i * MENU_SPACING),
            0,
            displayNames[i],
            MENU_FONT_SIZE,
            false
        );

        text.setFormat(
            Paths.font("MainMenuFont.ttf"),
            MENU_FONT_SIZE,
            TEXT_COLOR
        );

        text.scrollFactor.set(0, 0);
        text.antialiasing = true;
        text.ID = i;

        add(text);
        customMenuTexts.push(text);
    }

    uiReady = true;

    // Draw the initial selection without tweening into it.
    updateCustomSelection(curSelected, false);
}


// MainMenuState calls this whenever Up/Down/mouse wheel changes selection.
function onChangeItem(event)
{
    if (!uiReady)
        return;

    updateCustomSelection(event.value, true);
}


// Opens our custom GalleryState when Gallery is selected.
// Cancelling the event stops MainMenuState's default selection handler.
function onSelectItem(event)
{
    if (event.name == "gallery")
    {
        event.cancel();
        FlxG.switchState(new ModState("GalleryState"));
    }
}


// Updates text animation + right-side picture.
function updateCustomSelection(selected:Int, tween:Bool)
{
    for (i in 0...customMenuTexts.length)
    {
        var item:FunkinText = customMenuTexts[i];

        FlxTween.cancelTweensOf(item);
        FlxTween.cancelTweensOf(item.scale);

        var targetX:Float = MENU_X;
        var targetScale:Float = NORMAL_SCALE;

        if (i == selected)
        {
            targetX += SELECT_OFFSET_X;
            targetScale = SELECT_SCALE;
        }

        if (tween)
        {
            FlxTween.tween(
                item,
                {x: targetX},
                TWEEN_TIME,
                {ease: FlxEase.quintOut}
            );

            FlxTween.tween(
                item.scale,
                {x: targetScale, y: targetScale},
                TWEEN_TIME,
                {ease: FlxEase.quintOut}
            );
        }
        else
        {
            item.x = targetX;
            item.scale.set(targetScale, targetScale);
        }
    }

    updatePreview(selected, tween);
}


// Loads the image matching the selected option.
// When scrolling, the new image starts 300px to the right
// and slides into place over 0.5 seconds with quintOut.
function updatePreview(selected:Int, tween:Bool)
{
    if (selected < 0 || selected >= optionShit.length)
        return;

    var imageName:String = optionShit[selected];

    // Stop an old slide if the player scrolls again quickly.
    FlxTween.cancelTweensOf(previewImage);

    previewImage.scale.set(1, 1);
    previewImage.loadGraphic(Paths.image("mainmenu/" + imageName));
    previewImage.updateHitbox();

    if (previewImage.width <= 0 || previewImage.height <= 0)
        return;

    // Keep the original aspect ratio and fit inside 612x669.
    var fitScale:Float = Math.min(
        PREVIEW_W / previewImage.width,
        PREVIEW_H / previewImage.height
    );

    previewImage.scale.set(fitScale, fitScale);
    previewImage.updateHitbox();

    // Work out where the image should FINISH.
    var finalX:Float = PREVIEW_X + ((PREVIEW_W - previewImage.width) / 2);
    var finalY:Float = PREVIEW_Y + ((PREVIEW_H - previewImage.height) / 2);

    previewImage.y = finalY;
    previewImage.visible = true;
    previewImage.alpha = 1;

    if (tween)
    {
        // Start visibly to the RIGHT.
        previewImage.x = finalX + PREVIEW_SLIDE_DISTANCE;

        // Then actually move it into position.
        FlxTween.tween(
            previewImage,
            {x: finalX},
            TWEEN_TIME,
            {ease: FlxEase.quintOut}
        );
    }
    else
    {
        // First menu load: no slide, just show it normally.
        previewImage.x = finalX;
    }
}
