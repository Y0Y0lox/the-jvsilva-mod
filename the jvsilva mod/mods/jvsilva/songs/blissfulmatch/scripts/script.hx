import funkin.game.Character;
import funkin.game.PlayState;
import flixel.FlxG;

function create()
{
    // Only replace Pirl (10% chance)
    if (dad.curCharacter == "pirl" && Math.random() < 0.10)
    {
        var oldDad = dad;

        var newDad = new Character(
            0,
            0,
            "pirl",
            stage.isCharFlipped("dad", false)
        );

        stage.applyCharStuff(newDad, "dad", 0);

        strumLines.members[0].characters[0] = newDad;
        dad = newDad;

        remove(oldDad);
        oldDad.destroy();

        trace("ANON SPAWNED! 10% CHANCE");

        // Load anonymous vocals without changing difficulty
        var anonPath = Paths.voices(
            SONG.meta.name,
            PlayState.difficulty,
            "-anon"
        );

        if (Assets.exists(anonPath))
        {
            vocals.stop();
            vocals = FlxG.sound.load(anonPath);
            vocals.group = FlxG.sound.defaultMusicGroup;
            vocals.persist = false;

            for (line in strumLines.members)
            {
                line.vocals.stop();
                line.vocals = FlxG.sound.load(anonPath);
                line.vocals.group = FlxG.sound.defaultMusicGroup;
            }

            trace("ANON VOCALS LOADED!");
        }
        else
        {
            trace("ERROR: ANON VOCALS NOT FOUND: " + anonPath);
        }
    }
}import funkin.game.Character;
import funkin.game.PlayState;
import flixel.FlxG;

function create()
{
    // Only replace Pirl (10% chance)
    if (dad.curCharacter == "pirl" && Math.random() < 0.10)
    {
        var oldDad = dad;

        var newDad = new Character(
            0,
            0,
            "pirl",
            stage.isCharFlipped("dad", false)
        );

        stage.applyCharStuff(newDad, "dad", 0);

        strumLines.members[0].characters[0] = newDad;
        dad = newDad;

        remove(oldDad);
        oldDad.destroy();

        trace("ANON SPAWNED! 10% CHANCE");

// Preserve the exact current Voices.ogg volume
var originalVolume = vocals.volume;

// Load anonymous vocals
var anonPath = Paths.voices(
    SONG.meta.name,
    PlayState.difficulty,
    "-anon"
);

if (Assets.exists(anonPath))
{
    var oldTime = vocals.time;
    var wasPlaying = vocals.playing;

    vocals.stop();

    vocals = FlxG.sound.load(anonPath);
    vocals.volume = originalVolume;
    vocals.group = FlxG.sound.defaultMusicGroup;
    vocals.persist = false;

    if (wasPlaying)
        vocals.play(true, oldTime);

    trace("ANON VOCALS LOADED! Volume: " + originalVolume);
}
else
{
    trace("ERROR: ANON VOCALS NOT FOUND: " + anonPath);
}
    }
}