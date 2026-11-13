import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var mechanicsCam:FlxCamera;
var farolillo:FlxSprite;
var whiteOverlay:FlxSprite; 

var lightEnabled:Bool = false;
var beatMod:Int = 4;
var counter:Int = 0;
var threshold:Float = 15;
var insideRange:Bool = false;
var pressedInRange:Bool = false;
var canPress:Bool = false;

function create() {
    FlxG.cameras.add(mechanicsCam = new FlxCamera(), false);
    mechanicsCam.bgColor = 0x00000000;

    // Loaded asset matching your local scary-spooky file folder path location
    farolillo = new FlxSprite(0, 50).loadGraphic(Paths.image('game/scary-spooky/evilpend'));
    farolillo.cameras = [mechanicsCam];
    farolillo.scale.set(0.7, 0.7);
    farolillo.updateHitbox();
    farolillo.origin.set(farolillo.width / 2, 0);
    
    var farolX = (FlxG.width / 2) - (farolillo.width / 2);
    farolillo.x = farolX;
    farolillo.alpha = 0;
    add(farolillo);
}

function postCreate() {
    whiteOverlay = new FlxSprite(); 
    whiteOverlay.makeGraphic(1280, 720, FlxColor.WHITE);
    whiteOverlay.scrollFactor.set(0, 0);
    whiteOverlay.alpha = 0;
    whiteOverlay.cameras = [mechanicsCam];
    add(whiteOverlay);

    FlxG.cameras.remove(mechanicsCam, false);
    FlxG.cameras.add(mechanicsCam, false);

    WindowUtils.winTitle = window.title = "this man yo.. he does NOT know how to make lyrics";
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "shitty aethos slop mod";
}

function update(elapsed:Float) {
    var time = Conductor.songPosition / 1000;

    if (lightEnabled) {
        var bps:Float = Conductor.bpm / 60; 
        var halfBpmFreq:Float = (bps * Math.PI) / 2;
        farolillo.angle = Math.sin(time * halfBpmFreq) * 60;
        
        canPress = Math.abs(farolillo.angle) < threshold;

        if (FlxG.keys.justPressed.SPACE) {
            if (canPress && !pressedInRange) {
                counter--;
                if (counter < 0) counter = 0;
                pressedInRange = true;
                
                FlxTween.tween(whiteOverlay, {alpha: whiteOverlay.alpha - 0.07}, 0.6, {ease: FlxEase.cubeOut});
                createGhost();
            } 
            else if (!canPress) {
                counter++;
                FlxTween.tween(whiteOverlay, {alpha: whiteOverlay.alpha + 0.07}, 0.6, {ease: FlxEase.cubeOut});
            }
        }

        if (canPress) {
            if (!insideRange) {
                insideRange = true;
                pressedInRange = false; 
            }
        } else {
            if (insideRange) {
                if (!pressedInRange) {
                    counter++;
                    FlxTween.tween(whiteOverlay, {alpha: whiteOverlay.alpha + 0.07}, 0.6, {ease: FlxEase.cubeOut});
                }
                insideRange = false;
            }
        }
    }

    if (counter >= 14 || whiteOverlay.alpha >= 1) {
        gameOver();
    }
}

function toggleLight(activar:Bool) {
    if (activar) {
        lightEnabled = true;
        FlxTween.tween(farolillo, {alpha: 1}, 0.6, {ease: FlxEase.cubeOut});
    } else {
        lightEnabled = false;
        counter = 0;
        FlxTween.tween(whiteOverlay, {alpha: 0}, 0.8);
        FlxTween.tween(farolillo, {alpha: 0}, 0.6, {ease: FlxEase.cubeIn});
    }
}

function createGhost() {
    var ghost = new FlxSprite(0, 0);
    ghost.loadGraphic(farolillo.graphic);
    ghost.antialiasing = true;
    ghost.scale.set(farolillo.scale.x, farolillo.scale.y);
    ghost.updateHitbox();
    ghost.setPosition(farolillo.x, farolillo.y);
    ghost.origin.set(farolillo.origin.x, farolillo.origin.y);
    ghost.angle = farolillo.angle;
    ghost.cameras = [mechanicsCam];
    ghost.alpha = 0.4;
    add(ghost);

    FlxTween.tween(ghost, {alpha: 0}, 0.4, {
        ease: FlxEase.cubeOut,
        onComplete: function(twn:FlxTween) {
            ghost.destroy();
        }
    });
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 1:
            toggleLight(false);
        case 64: 
            toggleLight(true);
    }
}