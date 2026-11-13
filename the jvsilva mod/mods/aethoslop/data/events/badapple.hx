import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.FlxG;

var bg:FlxSprite = new FlxSprite(-512, -512);

function postCreate() {}
function create() {
    
    bg.makeGraphic(500, 500, 0xFFFFFFFF);
    bg.scale.x = 10;
    bg.scale.y = 10;
    bg.scrollFactor.set(0, 0);
    bg.visible = false;
    insert(4, bg);
}

function onEvent(event) {
    if (event.event.name == "badapple") {
        var value = event.event.params[0];

        if (value == true || value == "true") {
            bg.visible = true;
            dad.color = 0x000000;
            bf.color = 0x000000;
            gf.color = 0x000000;
        } 
        else if (value == false || value == "false") {
            bg.visible = false;
            dad.color = 0xFFFFFF;
            bf.color = 0xFFFFFF;
            gf.color = 0xFFFFFF;
        }
    }
}
