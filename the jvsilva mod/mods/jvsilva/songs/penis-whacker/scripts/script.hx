import flixel.FlxCamera;

var camNotes:FlxCamera;
var highwayShader:CustomShader;
var highwayShader2:CustomShader;
var highwayBar:FlxSprite;
var scrollPos:Float = 0;

function create() {
    dad.visible = false;
    
    highwayShader = new CustomShader("highway");
    highwayShader.angleX = -45;

    highwayShader2 = new CustomShader("die");
    highwayShader2.angleX = 45;
    highwayShader2.scrollOffset = 0.0;
    highwayShader2.repeatY = 2.0;
    highwayShader2.widthScale = 0.65;

    camNotes = new HudCamera();
    camNotes.downscroll = true;
    camNotes.bgColor = 0x00000000;
    FlxG.cameras.add(camNotes, false);

    camNotes.addShader(highwayShader);

    var shitFucker = new FlxSprite(0, 0);
    shitFucker.makeGraphic(1920, 1920, 0xFF000000);
    shitFucker.scrollFactor.set(0, 0);
    shitFucker.screenCenter();
    add(shitFucker);

    highwayBar = new FlxSprite(0, 0).loadGraphic(Paths.image('clone/defaultThumb'));
    highwayBar.setGraphicSize(690, 800);
    highwayBar.scrollFactor.set(0, 0);
    highwayBar.screenCenter();
    highwayBar.shader = highwayShader2;
    add(highwayBar);

    railLeft = new FlxSprite(0, 0).loadGraphic(Paths.image('clone/myBallsItch'));
    railLeft.setGraphicSize(80, 800);
    railLeft.scrollFactor.set(0, 0);
    railLeft.screenCenter();
    railLeft.x = railLeft.x - 400;
    add(railLeft);

    var shitFucker2 = new FlxSprite(0, 0);
    shitFucker2.makeGraphic(480, 240, 0xFF000000);
    shitFucker2.scrollFactor.set(0, 0);
    shitFucker2.screenCenter();
    shitFucker2.y = shitFucker2.y - 300;
    add(shitFucker2);

    grad = new FlxSprite(0, 0).loadGraphic(Paths.image('clone/black'));
    grad.setGraphicSize(1080, 360);
    grad.scrollFactor.set(0, 0);
    grad.screenCenter();
    grad.y = grad.y + 300;
    grad.cameras = [camNotes];
    add(grad);

    for (line in strumLines.members)
    {
        line.cameras = [camNotes];

        for (strum in line.members)
            strum.cameras = [camNotes];
    }
}

function update(elapsed:Float) {
    scrollPos += ((450 * (scrollSpeed)) / highwayBar.height) * elapsed;
    highwayShader2.scrollOffset = scrollPos % 1.0;
}