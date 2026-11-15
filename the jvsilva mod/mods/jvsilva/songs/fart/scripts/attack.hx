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

    new FlxTimer().start(0.5, function() {
      onCooldown = false;
    });
  }
}

function onSongEnd(event:CancellableEvent) {
  if (attackTotal > 3) {
    event.cancel();

    FunkinSave.setSongHighscore(PlayState.SONG.meta?.name, PlayState.difficulty, PlayState.variation, {
      score: songScore,
      misses: misses,
      accuracy: accuracy,
      hits: PlayState.hits,
      date: Date.now().toString()
    }, PlayState.getSongChanges());

    PlayState.loadSong("fart", "hard"); // Or use the loadWeek function, whatever you're doing.
    FlxG.resetState();
  }
} //piss engine coming out 2026 or 2027 (NOT A 67 JOKE)
