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
            for (i in 0...strumLines.members.length) {
                for (b in 0...strumLines.members[i].characters.length) {
                    strumLines.members[i].characters[b].color = 0x0000;
                }
            }
        }
        else if (value == false || value == "false") {
            bg.visible = false;
            for (i in 0...strumLines.members.length) {
                for (b in 0...strumLines.members[i].characters.length) {
                    strumLines.members[i].characters[b].color = 0xFFFFFF;
                }
            }
        }
    }
}
