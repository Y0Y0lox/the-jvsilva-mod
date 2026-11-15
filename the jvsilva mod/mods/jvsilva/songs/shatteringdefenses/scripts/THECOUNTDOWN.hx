import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var countdownSprite:FlxSprite;

function onCountdown(event)
{
    event.cancelled = true;

    var image:String = "";

    switch (event.swagCounter)
    {
        case 0:
            image = "countdown/pirlthree";
            FlxG.sound.play(Paths.sound("intro3"));

        case 1:
            image = "countdown/pirltwo";
            FlxG.sound.play(Paths.sound("intro2"));

        case 2:
            image = "countdown/pirlone";
            FlxG.sound.play(Paths.sound("intro1"));

        case 3:
            image = "countdown/pirlgo";
            FlxG.sound.play(Paths.sound("introGo"));
    }

    if (image != "")
    {
        var spr = new FlxSprite();
        spr.loadGraphic(Paths.image(image));

        spr.scale.set(0.6, 0.6);

        spr.cameras = [camHUD];
        add(spr);

        spr.screenCenter();

        FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.15, {
            ease: FlxEase.backOut
        });

        FlxTween.tween(spr, {alpha: 0}, Conductor.crochet / 1000, {
            ease: FlxEase.cubeInOut,
            onComplete: function(twn)
            {
                spr.destroy();
            }
        });
    }
}
