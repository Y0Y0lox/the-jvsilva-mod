import funkin.savedata.FunkinSave;
import haxe.Date;

using StringTools;

var attackTotal:Int = 0;
var onCooldown:Bool = false;

function update() {
  if (FlxG.keys.justPressed.SPACE && !onCooldown) {
    onCooldown = true;
    attackTotal++;

    if (boyfriend.animation.exists("pre attack")) {
        boyfriend.playAnim("pre attack", true);
        new FlxTimer().start(0.3, function(tmr:FlxTimer) {
        boyfriend.playAnim('attack', true);
        });
    }

    new FlxTimer().start(1, function() {
      onCooldown = false;
    });
  }
}