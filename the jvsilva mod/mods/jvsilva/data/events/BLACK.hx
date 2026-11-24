import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.FlxG;

var bg:FlxSprite = new FlxSprite(-512, -512);

function postCreate() {}
function create() {
    
    bg.makeGraphic(500, 500, 0xFF000000);
    bg.scale.x = 10;
    bg.scale.y = 10;
    bg.scrollFactor.set(0, 0);
    bg.visible = false;
    bg.cameras = [camHUD];
    insert(0, bg);
}

function onEvent(event) {
    if (event.event.name == "BLACK") {
        var value = event.event.params[0];

        if (value == true || value == "true") {
            bg.visible = true;
        } 
        else if (value == false || value == "false") {
            bg.visible = false;
        }
    }
}
