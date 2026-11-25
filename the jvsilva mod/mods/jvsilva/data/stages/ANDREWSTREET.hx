import flixel.graphics.frames.FlxAtlasFrames;
import haxe.ds.StringMap;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.FlxG;

var Techzasttemp:StringMap<String,Dynamic> = new StringMap<String,Dynamic>();
var chance = 0;
var getajobloseryoufelloff:Float = 0.0;

function MOOVEEE2(char:String) {
    var data = Techzasttemp.get(char);
    if (data == null || data.sprite == null) return;

    var spr:FlxSprite = data.sprite;

    var rightBound = 2700 + data.xo;
    var leftBound = 0 + data.xo;

    if (spr.x >= rightBound || spr.x <= leftBound) {
        chance = Std.random(10);
        if (chance >= 5) {
            data.active = 1;
            spr.x = 2700 + data.xo;
        } else {
            data.active = 0;
            spr.x = 0 + data.xo;
        }
        var FUCKYOURSELF = FlxG.random.bool(35);

        if (FUCKYOURSELF) {
            spr.y = (325 + Std.random(50)) + data.yo;

            if (data.active == 0) {
                data.active = 1;
                spr.flipX = true;

                if (data.twinactive != null) data.twinactive.cancel();

                data.twinactive = FlxTween.tween(spr, {x: 2700 + data.xo}, (15 + Std.random(5)), {
                    ease: FlxEase.linear
                });
            } else {
                data.active = 0;
                spr.flipX = false;

                if (data.twinactive != null) data.twinactive.cancel();

                data.twinactive = FlxTween.tween(spr, {x: 0 + data.xo}, (15 + Std.random(5)), {
                    ease: FlxEase.linear
                });
            }
        }
    }
}
function postUpdate(elapsed:Float) {
	if (getajobloseryoufelloff > 0.5) {
		getajobloseryoufelloff = 0;
		var killme = ["Techzast", "fatass_walking", "raynpc", "sop"];

        for (i in 0...killme.length) {
            var charName = killme[i];
            var data = Techzasttemp.get(charName);

            if (data != null) {
                var isTweening:Bool = (data.twinactive != null && data.twinactive.active);

                if (!isTweening) {
		    var FUCKYOURSELF = FlxG.random.bool(35);

        	    if (FUCKYOURSELF) {
                    	MOOVEEE2(charName);
		    }
                }
            }
        }

	} else {
		getajobloseryoufelloff += elapsed;
	}
}
function create() {
  // background
  createbs("dofwk",'dofwk', true, 24, -800, 0, 0.85, 0.85, false,false);
  createbs("bred",'bread', false, 1, -1250, 134, 1, 1, false,false);
  
  // foreground (HEY IM FUCKING WALKING HERE)
  createbs("Techzast", 'IST THAT TEHZATER', false, 0, -200, -400, 0.35, 0.35, true, true);
  createbs("fatass_walking", 'fatass_walking', true, 8, 0, 0, 0.8, 0.8, true, true);
  createbs("raynpc", 'ray_npc', false, 0, 0, 350, 1, 1, true, true);
  createbs("sop", 'soapy', true, 24, 0, 80, 0.5, 0.5, true, true);
}
function createbs(char, img, animated, fps, xo, yo, xs, ys, front, sr) {
    var chara:FlxSprite = new FlxSprite(2700 + xo, 450 + yo);
    
    var struct = {
        sprite: chara,
        yo: yo,
        xo: xo,
        active: 0,
        twinactive: null,
        aniffunction: false
    };
    
    Techzasttemp.set(char, struct);
    chance = Std.random(10);

    if (animated == true) {
        chara.frames = Paths.getSparrowAtlas("stages/andrew/" + img);
        chara.animation.addByPrefix('IMFUCKINGWALKINGINGBABY', 'WALKN', fps, true);
        chara.scale.set(xs, ys);
	if (front == false) {insert(members.indexOf(dad), chara);} else {add(chara);}
        chara.animation.play('IMFUCKINGWALKINGINGBABY');
    } else {
        chara.loadGraphic(Paths.image("stages/andrew/" + img));
        chara.scale.set(xs, ys);
	if (front == false) {insert(members.indexOf(dad), chara);} else {add(chara);}

    }

    if (sr == true) {
        if (chance >= 5) {
            struct.active = 1;
            chara.x = 2700 + xo;
        } else {
            struct.active = 0;
            chara.x = 0 + xo;
        }
    }
    
}