import funkin.menus.MainMenuState;
import hxvlc.flixel.FlxVideoSprite;

function create()
{
    // Force background to pure hex black
    FlxG.cameras.bgColor = 0xFF000000;
    FlxG.mouse.visible = false;

    // Initialize and play the video file from your videos folder
    var video:FlxVideoSprite = new FlxVideoSprite();
    video.load(Paths.video("slopintro"));
    add(video);

    // As soon as the video reaches its end, boot into the original MainMenuState
    video.bitmap.onEndReached.add(function() {
        video.destroy();
        FlxG.switchState(new MainMenuState());
    });

    video.play();
}

function update(elapsed:Float)
{
    // Allow pressing BACK to skip the video and jump straight to the menu if desired
    if (controls.BACK) {
        FlxG.switchState(new MainMenuState());
    }
}