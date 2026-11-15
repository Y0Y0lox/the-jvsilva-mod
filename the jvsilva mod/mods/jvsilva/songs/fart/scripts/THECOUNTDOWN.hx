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
            image = "countdown/yoyothree";
            FlxG.sound.play(Paths.sound("intro3"));

        case 1:
            image = "countdown/yoyotwo";
            FlxG.sound.play(Paths.sound("intro2"));

        case 2:
            image = "countdown/yoyoone";
            FlxG.sound.play(Paths.sound("intro1"));

        case 3:
            image = "countdown/yoyogo";
            FlxG.sound.play(Paths.sound("introGo"));
    }

    if (image != "")
    {
        var spr = new FlxSprite();
        spr.loadGraphic(Paths.image(image));

        spr.scale.set(1, 1);

        spr.cameras = [camHUD];
        add(spr);

        spr.screenCenter();

        FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.15, {
            ease: FlxEase.backInOut
        });

        FlxTween.tween(spr, {alpha: 1}, Conductor.crochet / 1000, {
            ease: FlxEase.elastic,
            onComplete: function(twn)
            {
                spr.destroy();
            }
        });
    }
}
