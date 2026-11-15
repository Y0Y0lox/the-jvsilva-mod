import flixel.ui.FlxBar;
import flixel.text.FlxTextBorderStyle;

var ratingFC:String = '';

var sicks:Int = 0;
var goods:Int = 0;
var bads:Int = 0;
var shits:Int = 0;

var scoreTxtTween:FlxTween;


var bfCircle;

var bfIcon:FlxSprite;

var modName = "Project Originality Funkin";

// Build path to mod image
var iconPath = "mods/" + modName + "/icons/bf/bf";

function postCreate(){
    var padX = 20; // distance from right edge
    var circleSize = 150;
    var extraOffset = -30;

    for(i in [healthBar, healthBarBG, scoreTxt, missesTxt, accuracyTxt, iconP1]) remove(i);
    doIconBop = false;

    iconP1.camera = camHUD;
    iconP1.scrollFactor.set(0,0);

    rerunBarBG = new FlxSprite(24, downscroll ? 551.7 : 571.5).loadGraphic(Paths.image('huds/pirl/hpbar/hpframe'));
    rerunBarBG.camera = camHUD;
    rerunBarBG.y -= 75/2;

    bfCircle = new FlxSprite(FlxG.width - circleSize - padX, downscroll ? 551.7 : 571.5);
    bfCircle.loadGraphic(Paths.image('huds/pirl/hpbar/bfcircle'));
    bfCircle.camera = camHUD;
    bfCircle.scrollFactor.set(0,0);
    bfCircle.setGraphicSize(circleSize);
    bfCircle.updateHitbox();

    bfCircle.x = FlxG.width - bfCircle.width - padX;
    bfCircle.y -= 75/2 + extraOffset;

    bfIcon = new FlxSprite().loadGraphic(Paths.image('icons/bf/bf'), true, 150, 150);
    bfIcon.frame = 0; // normal frame
    bfIcon.camera = camHUD;
    bfIcon.scrollFactor.set(0,0);
    bfIcon.flipX = true;

    // scale to fit circle
    var iconScale = 0.7;
    bfIcon.setGraphicSize(Std.int(bfCircle.width * iconScale));
    bfIcon.updateHitbox();

    // center in circle
    bfIcon.x = bfCircle.x + (bfCircle.width - bfIcon.width)/2;
    bfIcon.y = bfCircle.y + (bfCircle.height - bfIcon.height)/2;

    healthBar = new FlxBar(rerunBarBG.x + 65, downscroll ? 576 : rerunBarBG.y + 109, FlxBar.LEFT_TO_RIGHT, 561, 29, this, 'health', 0, maxHealth);
    healthBar.createImageBar(Paths.image('huds/pirl/hpbar/empty'), Paths.image('huds/pirl/hpbar/fill'));
    healthBar.camera = camHUD;
    healthBar.numDivisions = 400;
    healthBar.updateHitbox();

    scoreTxt2 = new FlxText(healthBar.x + 70, downscroll ? 646 : rerunBarBG.y + 47, 0, "S: 0 | M: 0 | R: ?", 20);
    scoreTxt2.setFormat(Paths.font("NiseSegaSonic.ttf"), 20, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    scoreTxt2.camera = camHUD;
    scoreTxt2.borderSize = 1.25;

    add(healthBar);
    add(rerunBarBG);
    add(scoreTxt2);
    add(bfCircle);
    add(bfIcon);
}

function onPlayerHit(_){
    if(!_.note.isSustainNote){
        var hitWindow = Options.hitWindow;
        var noteDiff = Math.abs(Conductor.songPosition - _.note.strumTime);

        if (noteDiff > hitWindow * 0.9) shits += 1;
        else if (noteDiff > hitWindow * 0.75)  bads += 1;
        else if (noteDiff > hitWindow * 0.2) goods += 1;
        else if (noteDiff < hitWindow * 0.2) sicks += 1;
    }
}

function postUpdate(){
    iconP2.scale.set(lerp(iconP2.scale.x, 0.6, 0.33), lerp(iconP2.scale.y ,0.6, 0.33));
    iconP2.setPosition(healthBar.x - 57, downscroll ? healthBar.y - 40 : healthBar.y - 85);

    if (bfCircle != null && bfIcon != null) {
        // Smooth scaling (optional)
        bfIcon.scale.set(
            lerp(bfIcon.scale.x, 0.8, 0.33),
            lerp(bfIcon.scale.y, 0.8, 0.33)
        );

        // Center in circle
        bfIcon.x = bfCircle.x + (bfCircle.width - bfIcon.width)/2;
        bfIcon.y = bfCircle.y + (bfCircle.height - bfIcon.height)/2;

        // Health-based frame switching
    if (health < maxHealth * 0.35)
        bfIcon.animation.frameIndex = 1;
    else if (health > maxHealth * 0.7)
        bfIcon.animation.frameIndex = 2;
    else
        bfIcon.animation.frameIndex = 0;
    }
}

function onRatingUpdate(){
    if (sicks > 0) ratingFC = "SFC";
    if (goods > 0) ratingFC = "GFC";
    if (bads > 0 || shits > 0) ratingFC = "FC";
    if (misses > 0 && misses < 10) ratingFC = "SDCB";
    else if (misses >= 10) ratingFC = "Clear";

    scoreTxt2.text = 'S: ' + songScore
    + ' | M: ' + misses
    + ' | R: ' + (accuracy < 0 ? '?' : "(" + CoolUtil.quantize(accuracy * 100, 100) + "%) - " + ratingFC);

    if(scoreTxtTween != null) scoreTxtTween.cancel();
    scoreTxt2.scale.x = 1.075;
    scoreTxt2.scale.y = 1.075;
    scoreTxtTween = FlxTween.tween(scoreTxt2.scale, {x: 1, y: 1}, 0.2);
}

function onDadHit() iconP2.scale.set(0.8, 0.8);

function onPlayerHit() bfIcon.scale.set(1, 1);

function beatHit()
{
iconP2.scale.set(0.8, 0.8);

if (bfIcon != null)
        bfIcon.scale.set(1, 1);
}