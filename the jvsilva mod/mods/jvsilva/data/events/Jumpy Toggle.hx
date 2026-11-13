var jumpyEnabled:Bool = false;
var storedPositions:Bool = false;

var dadBaseX:Float = 0;
var dadBaseY:Float = 0;
var boyfriendBaseX:Float = 0;
var boyfriendBaseY:Float = 0;
var iconP1BaseY:Float = 0;
var iconP2BaseY:Float = 0;

function postCreate() {
    storePositions();
}

function storePositions() {
    if (storedPositions) return;

    dadBaseX = dad.x;
    dadBaseY = dad.y;
    boyfriendBaseX = boyfriend.x;
    boyfriendBaseY = boyfriend.y;

    if (iconP1 != null) iconP1BaseY = iconP1.y;
    if (iconP2 != null) iconP2BaseY = iconP2.y;

    storedPositions = true;
}

function onEvent(event) {
    if (event.event.name != "Jumpy Toggle") return;

    storePositions();
    jumpyEnabled = boolParam(event.event.params[0]);

    if (!jumpyEnabled) resetJumpyObjects();
}

function boolParam(value):Bool {
    var text:String = Std.string(value).toLowerCase();
    return value == true || text == "true" || text == "1" || text == "on" || text == "yes";
}

function beatHit(curBeat:Int) {
    if (!jumpyEnabled) return;
    storePositions();

    FlxTween.tween(dad, {y: dadBaseY - 60}, 0.2, {
        ease: FlxEase.quadOut,
        onComplete: (_) -> FlxTween.tween(dad, {y: dadBaseY}, 0.2, {ease: FlxEase.quadIn})
    });

    FlxTween.tween(boyfriend, {y: boyfriendBaseY - 60}, 0.2, {
        ease: FlxEase.quadOut,
        onComplete: (_) -> FlxTween.tween(boyfriend, {y: boyfriendBaseY}, 0.2, {ease: FlxEase.quadIn})
    });

    if (iconP2 != null) {
        FlxTween.tween(iconP2, {y: iconP2BaseY - 40}, 0.2, {
            ease: FlxEase.quadOut,
            onComplete: (_) -> FlxTween.tween(iconP2, {y: iconP2BaseY}, 0.2, {ease: FlxEase.quadIn})
        });
    }

    if (iconP1 != null) {
        FlxTween.tween(iconP1, {y: iconP1BaseY - 40}, 0.2, {
            ease: FlxEase.quadOut,
            onComplete: (_) -> FlxTween.tween(iconP1, {y: iconP1BaseY}, 0.2, {ease: FlxEase.quadIn})
        });
    }
}

function update(elapsed:Float) {
    if (!jumpyEnabled) return;
    storePositions();

    var songTime:Float = Conductor.songPosition;
    var t:Float = Math.sin(songTime / 500);
    var mid:Float = (dadBaseX + boyfriendBaseX) / 2;
    var range:Float = Math.abs(dadBaseX - boyfriendBaseX) / 2;

    dad.x = mid - t * range;
    boyfriend.x = mid + t * range;
}

function resetJumpyObjects() {
    if (!storedPositions) return;

    dad.x = dadBaseX;
    dad.y = dadBaseY;
    boyfriend.x = boyfriendBaseX;
    boyfriend.y = boyfriendBaseY;

    if (iconP1 != null) iconP1.y = iconP1BaseY;
    if (iconP2 != null) iconP2.y = iconP2BaseY;
}

function destroy() {
    resetJumpyObjects();
}
