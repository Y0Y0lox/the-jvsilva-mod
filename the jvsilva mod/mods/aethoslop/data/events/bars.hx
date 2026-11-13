import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.FlxG;

var topBar:FlxSprite = new FlxSprite();
var bottomBar:FlxSprite = new FlxSprite();

var barHeight:Int = 110; 
var tweenDuration:Float = 0.45;
var def:Float = 0.85;

function postCreate() {
    def = defaultCamZoom;
    topBar.makeGraphic(FlxG.width, barHeight, 0xFF000000);
    topBar.y = -barHeight;
    topBar.cameras = [camHUD];
    topBar.scrollFactor.set(0,0);
    insert(0, topBar);
    add(topBar);

    bottomBar.makeGraphic(FlxG.width, barHeight, 0xFF000000);
    bottomBar.y = FlxG.height;
    bottomBar.cameras = [camHUD];
    bottomBar.scrollFactor.set(0,0);
    insert(0, bottomBar);
    add(bottomBar);

    scoreTxt.y = FlxG.height - 50;
    missesTxt.y = FlxG.height - 50;
    accuracyTxt.y = FlxG.height - 50;
}

function onEvent(event) {
    if (event.event.name == "bars") {
        if (topBar == null || bottomBar == null) return;

        FlxTween.globalManager.completeTweensOf(topBar);
        FlxTween.globalManager.completeTweensOf(bottomBar);
        for (i in 0...strumLines.members[1].members.length) {
            FlxTween.globalManager.completeTweensOf(strumLines.members[1].members[i]);
        }
        for (i in 0...strumLines.members[0].members.length) {
            FlxTween.globalManager.completeTweensOf(strumLines.members[0].members[i]);
        }
        FlxTween.globalManager.completeTweensOf(scoreTxt);
        FlxTween.globalManager.completeTweensOf(missesTxt);
        FlxTween.globalManager.completeTweensOf(accuracyTxt);

        var value = event.event.params[0];

        if (value == true || value == "true") {
            defaultCamZoom = def + 0.183737458138913248134571345;
            FlxTween.tween(scoreTxt, {alpha: 0}, tweenDuration, {ease: FlxEase.quadIn});
            FlxTween.tween(missesTxt, {alpha: 0}, tweenDuration, {ease: FlxEase.quadIn});
            FlxTween.tween(accuracyTxt, {alpha: 0}, tweenDuration, {ease: FlxEase.quadIn});

            FlxTween.tween(scoreTxt, {y: FlxG.height - 20}, tweenDuration, {ease: FlxEase.quadIn});
            FlxTween.tween(missesTxt, {y: FlxG.height - 20}, tweenDuration, {ease: FlxEase.quadIn});
            FlxTween.tween(accuracyTxt, {y: FlxG.height - 20}, tweenDuration, {ease: FlxEase.quadIn});

            for (i in 0...strumLines.members[1].members.length) {
                FlxTween.tween(strumLines.members[1].members[i], {y: (50 + barHeight)}, tweenDuration, {ease: FlxEase.quadOut});
            }
            for (i in 0...strumLines.members[0].members.length) {
                FlxTween.tween(strumLines.members[0].members[i], {y: (50 + barHeight)}, tweenDuration, {ease: FlxEase.quadOut});
            }
            FlxTween.tween(topBar, {y: 0}, tweenDuration, {ease: FlxEase.quadOut});
            FlxTween.tween(bottomBar, {y: FlxG.height - barHeight}, tweenDuration, {ease: FlxEase.quadOut});
        } 
        else if (value == false || value == "false") {
            defaultCamZoom = def;
            for (i in 0...strumLines.members[1].members.length) {
                FlxTween.tween(strumLines.members[1].members[i], {y: 50}, tweenDuration, {ease: FlxEase.quadIn});
            }
            for (i in 0...strumLines.members[0].members.length) {
                FlxTween.tween(strumLines.members[0].members[i], {y: 50}, tweenDuration, {ease: FlxEase.quadIn});
            }
            FlxTween.tween(topBar, {y: -barHeight}, tweenDuration, {ease: FlxEase.quadIn});
            FlxTween.tween(bottomBar, {y: FlxG.height}, tweenDuration, {ease: FlxEase.quadIn});

            FlxTween.tween(scoreTxt, {alpha: 1}, tweenDuration, {ease: FlxEase.quadIn});
            FlxTween.tween(missesTxt, {alpha: 1}, tweenDuration, {ease: FlxEase.quadIn});
            FlxTween.tween(accuracyTxt, {alpha: 1}, tweenDuration, {ease: FlxEase.quadIn});

            FlxTween.tween(scoreTxt, {y: FlxG.height - 50}, tweenDuration, {ease: FlxEase.quadIn});
            FlxTween.tween(missesTxt, {y: FlxG.height - 50}, tweenDuration, {ease: FlxEase.quadIn});
            FlxTween.tween(accuracyTxt, {y: FlxG.height - 50}, tweenDuration, {ease: FlxEase.quadIn});
        }
    }
}
