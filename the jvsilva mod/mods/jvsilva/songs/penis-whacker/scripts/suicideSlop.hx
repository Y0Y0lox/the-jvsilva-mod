var highwayShader:CustomShader;

function postCreate()
{
    highwayShader = new CustomShader("highway");
    highwayShader.angleX = -45.0;

    FlxG.game.addShader(highwayShader);
}

function destroy()
{
    FlxG.game.removeShader(highwayShader);
}