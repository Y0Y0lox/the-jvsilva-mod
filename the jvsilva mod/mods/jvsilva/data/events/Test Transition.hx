function onEvent(e) {
    if (e.event.name != "Test Transition") return;
    
    var shitMoves = new FlxSprite();
    shitMoves.loadGraphic(Paths.image("testing"));

    shitMoves.setGraphicSize(Std.int(FlxG.width * 1.5), FlxG.height);
    shitMoves.updateHitbox();

    shitMoves.cameras = [camHUD];
    shitMoves.scrollFactor.set(0, 0);

    shitMoves.x = -shitMoves.width;
    shitMoves.y = 0;

    insert(members.length, shitMoves);

    var bbbbb = e.event.params[0];

    if (bbbbb == null)
        bbbbb = 4;

    var stupidAssTime = (Conductor.stepCrochet * bbbbb) / 1000;

    FlxTween.tween(shitMoves, {
        x: FlxG.width
    }, stupidAssTime, {
        ease: FlxEase.linear,

        onComplete: function(fuckOffScreen) {
            remove(shitMoves, true);
            shitMoves.destroy();
        }
    });
}