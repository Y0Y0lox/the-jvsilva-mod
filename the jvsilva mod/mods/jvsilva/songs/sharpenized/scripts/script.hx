import funkin.game.Character;

function create()
{
    // Only replace JVSilva
    if (dad.curCharacter == "jvsilva" && Math.random() < 0.10)
    {
        var oldDad = dad;

        var newDad = new Character(
            0,
            0,
            "realjv",
            stage.isCharFlipped("dad", false)
        );

        stage.applyCharStuff(newDad, "dad", 0);

        strumLines.members[0].characters[0] = newDad;
        dad = newDad;

        remove(oldDad);
        oldDad.destroy();

        trace("REAL JV SPAWNED! 10% CHANCE");
    }
}