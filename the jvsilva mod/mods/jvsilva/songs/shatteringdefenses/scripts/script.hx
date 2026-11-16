import funkin.game.Character;
import funkin.game.PlayState;
import flixel.FlxG;

function create()
{
    // Replace Pirl (currently 100% for testing - change 1 to 0.10 for 10% easter egg)
    if (dad.curCharacter == "pirl" && Math.random() < 0.10)
    {
        var oldDad = dad;

        var newDad = new Character(
            0,
            0,
            "pirlnon",
            stage.isCharFlipped("dad", false)
        );

        stage.applyCharStuff(newDad, "dad", 0);

        strumLines.members[0].characters[0] = newDad;
        dad = newDad;

        remove(oldDad);
        oldDad.destroy();

        trace("ANON SPAWNED!");

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

