import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.backend.FunkinText;
import openfl.utils.Assets;

// ============================================================
// GALLERY STATE - Codename Engine 1.0.1
//
// Put here:
//   data/states/GalleryState.hx
//
// Images:
//   images/gallery/images/name.png
//
// Description:
//   images/gallery/desc/name.txt
//
// The txt file is JUST normal text.
// If it does not exist or is empty:
//   No description found.
//
// Arrow:
//   images/game/gallery/arrow.png
// ============================================================

var IMAGE_FOLDER:String = "images/gallery/images/";
var DESC_FOLDER:String = "images/gallery/desc/";

var galleryNames:Array<String> = [];
var galleryFiles:Array<String> = [];
var galleryDescriptions:Array<String> = [];

var curSelected:Int = 0;
var moveCooldown:Float = 0;

var bg:FlxSprite;

var leftImage:FlxSprite;
var centerImage:FlxSprite;
var rightImage:FlxSprite;

var leftText:FunkinText;
var centerText:FunkinText;
var rightText:FunkinText;
var counterText:FunkinText;
var helpText:FunkinText;
var emptyText:FunkinText;

var arrow:FlxSprite;


// ============================================================
// CREATE
// ============================================================

function create()
{
    bg = new FlxSprite(0, 0);
    bg.makeGraphic(FlxG.width, FlxG.height, 0xFF06B000);
    bg.scrollFactor.set(0, 0);
    add(bg);

    findGalleryImages();

    leftImage = new FlxSprite();
    leftImage.scrollFactor.set(0, 0);
    leftImage.antialiasing = true;
    add(leftImage);

    rightImage = new FlxSprite();
    rightImage.scrollFactor.set(0, 0);
    rightImage.antialiasing = true;
    add(rightImage);

    centerImage = new FlxSprite();
    centerImage.scrollFactor.set(0, 0);
    centerImage.antialiasing = true;
    add(centerImage);

    createText();
    createArrow();

    if (galleryFiles.length == 0)
    {
        showEmptyGallery();
    }
    else
    {
        curSelected = 0;
        refreshGallery(false, 0);
    }
}


// ============================================================
// AUTOMATIC IMAGE + DESCRIPTION LOADING
// ============================================================

function findGalleryImages()
{
    galleryNames = [];
    galleryFiles = [];
    galleryDescriptions = [];

    var files:Array<String> = Paths.getFolderContent(IMAGE_FOLDER, false);

    for (file in files)
    {
        var lower:String = file.toLowerCase();

        // PNG only on purpose: Paths.image / Flixel is most reliable with PNG
        // in Codename Engine mods.
        if (StringTools.endsWith(lower, ".png"))
        {
            var baseName:String = file.substr(0, file.length - 4);

            galleryNames.push(baseName);
            galleryFiles.push(Paths.file(IMAGE_FOLDER + file));
            galleryDescriptions.push(getDescription(baseName));
        }
    }

    trace("[Gallery] Found " + galleryFiles.length + " image(s).");
}


function getDescription(baseName:String):String
{
    var path:String = Paths.file(DESC_FOLDER + baseName + ".txt");

    if (Assets.exists(path))
    {
        var value:String = Assets.getText(path);

        if (value != null)
        {
            value = StringTools.trim(value);

            if (value.length > 0)
                return value;
        }
    }

    return "No description found.";
}


// ============================================================
// UI
// ============================================================

function createText()
{
    leftText = new FunkinText(25, 465, 280, "", 17, true);
    leftText.alignment = "center";
    leftText.scrollFactor.set(0, 0);
    leftText.alpha = 0.75;
    add(leftText);

    centerText = new FunkinText(325, 490, FlxG.width - 650, "", 27, true);
    centerText.alignment = "center";
    centerText.scrollFactor.set(0, 0);
    add(centerText);

    rightText = new FunkinText(FlxG.width - 305, 465, 280, "", 17, true);
    rightText.alignment = "center";
    rightText.scrollFactor.set(0, 0);
    rightText.alpha = 0.75;
    add(rightText);

    counterText = new FunkinText(0, 20, FlxG.width, "", 18, true);
    counterText.alignment = "center";
    counterText.scrollFactor.set(0, 0);
    add(counterText);

    helpText = new FunkinText(
        0,
        FlxG.height - 28,
        FlxG.width,
        "LEFT / RIGHT KEYBIND or ARROW KEYS  -  BACK / ESC",
        14,
        true
    );
    helpText.alignment = "center";
    helpText.scrollFactor.set(0, 0);
    helpText.alpha = 0.7;
    add(helpText);
}


function createArrow()
{
    arrow = new FlxSprite();
    arrow.scrollFactor.set(0, 0);

    var arrowPath:String = Paths.image("game/gallery/arrow");

    if (Assets.exists(arrowPath))
    {
        arrow.loadGraphic(arrowPath);
        arrow.antialiasing = true;

        if (arrow.width > 130)
            arrow.setGraphicSize(130);

        arrow.updateHitbox();
        arrow.x = (FlxG.width - arrow.width) / 2;
        arrow.y = FlxG.height - 105;

        add(arrow);
    }
    else
    {
        arrow.visible = false;
        add(arrow);
    }
}


function showEmptyGallery()
{
    leftImage.visible = false;
    centerImage.visible = false;
    rightImage.visible = false;

    leftText.visible = false;
    centerText.visible = false;
    rightText.visible = false;
    counterText.visible = false;

    if (arrow != null)
        arrow.visible = false;

    emptyText = new FunkinText(
        80,
        280,
        FlxG.width - 160,
        "No gallery images found.\n\nPut PNG files in:\nimages/gallery/images/",
        28,
        true
    );

    emptyText.alignment = "center";
    emptyText.scrollFactor.set(0, 0);
    add(emptyText);
}


// ============================================================
// GALLERY DISPLAY
// ============================================================

function refreshGallery(animate:Bool, direction:Int)
{
    var leftIndex:Int = wrapIndex(curSelected - 1);
    var rightIndex:Int = wrapIndex(curSelected + 1);

    setupImage(leftImage, leftIndex, -1);
    setupImage(centerImage, curSelected, 0);
    setupImage(rightImage, rightIndex, 1);

    leftText.text = shortText(galleryDescriptions[leftIndex]);
    centerText.text = galleryDescriptions[curSelected];
    rightText.text = shortText(galleryDescriptions[rightIndex]);

    counterText.text = (curSelected + 1) + " / " + galleryFiles.length;

    if (galleryFiles.length == 1)
    {
        leftImage.visible = false;
        rightImage.visible = false;
        leftText.visible = false;
        rightText.visible = false;
    }
    else
    {
        leftImage.visible = true;
        rightImage.visible = true;
        leftText.visible = true;
        rightText.visible = true;
    }

    if (animate)
    {
        animateImages(direction);
    }
}


function setupImage(sprite:FlxSprite, imageIndex:Int, side:Int)
{
    FlxTween.cancelTweensOf(sprite);
    FlxTween.cancelTweensOf(sprite.scale);

    sprite.loadGraphic(galleryFiles[imageIndex]);
    sprite.scale.set(1, 1);
    sprite.updateHitbox();

    var maxW:Float = 430;
    var maxH:Float = 285;

    var fit:Float = Math.min(maxW / sprite.width, maxH / sprite.height);

    if (fit > 1.5)
        fit = 1.5;

    if (side == 0)
    {
        sprite.scale.set(fit, fit);
        sprite.alpha = 1;
        sprite.angle = 0;
        sprite.updateHitbox();

        sprite.x = (FlxG.width - sprite.width) / 2;
        sprite.y = 135;
    }

    if (side < 0)
    {
        sprite.scale.set(fit * 0.55, fit * 0.78);
        sprite.alpha = 0.8;
        sprite.angle = -6;
        sprite.updateHitbox();

        sprite.x = 50;
        sprite.y = 175;
    }

    if (side > 0)
    {
        sprite.scale.set(fit * 0.55, fit * 0.78);
        sprite.alpha = 0.8;
        sprite.angle = 6;
        sprite.updateHitbox();

        sprite.x = FlxG.width - sprite.width - 50;
        sprite.y = 175;
    }
}


function animateImages(direction:Int)
{
    var amount:Float = 55;

    leftImage.x += amount * direction;
    centerImage.x += amount * direction;
    rightImage.x += amount * direction;

    leftImage.alpha = 0.35;
    centerImage.alpha = 0.55;
    rightImage.alpha = 0.35;

    var leftTarget:Float = 50;
    var centerTarget:Float = (FlxG.width - centerImage.width) / 2;
    var rightTarget:Float = FlxG.width - rightImage.width - 50;

    FlxTween.tween(
        leftImage,
        {x: leftTarget, alpha: 0.8},
        0.5,
        {ease: FlxEase.quintOut}
    );

    FlxTween.tween(
        centerImage,
        {x: centerTarget, alpha: 1},
        0.5,
        {ease: FlxEase.quintOut}
    );

    FlxTween.tween(
        rightImage,
        {x: rightTarget, alpha: 0.8},
        0.5,
        {ease: FlxEase.quintOut}
    );
}


function wrapIndex(value:Int):Int
{
    if (value < 0)
        return galleryFiles.length - 1;

    if (value >= galleryFiles.length)
        return 0;

    return value;
}


function shortText(value:String):String
{
    if (value.length > 95)
        return value.substr(0, 92) + "...";

    return value;
}


// ============================================================
// CONTROLS
// ============================================================

function update(elapsed:Float)
{
    if (moveCooldown > 0)
        moveCooldown -= elapsed;

    // Player BACK keybind + physical Escape.
    if (controls.BACK || FlxG.keys.justPressed.ESCAPE)
    {
        FlxG.switchState(new MainMenuState());
        return;
    }

    if (galleryFiles.length == 0)
        return;

    if (moveCooldown > 0)
        return;

    // Player's configured note binds + physical arrows.
    var goLeft:Bool = controls.NOTE_LEFT_P || FlxG.keys.justPressed.LEFT;
    var goRight:Bool = controls.NOTE_RIGHT_P || FlxG.keys.justPressed.RIGHT;

    if (goLeft && !goRight)
    {
        curSelected = wrapIndex(curSelected - 1);
        moveCooldown = 0.10;
        refreshGallery(true, -1);
        return;
    }

    if (goRight && !goLeft)
    {
        curSelected = wrapIndex(curSelected + 1);
        moveCooldown = 0.10;
        refreshGallery(true, 1);
    }
}
