import flixel.FlxCamera;

var camNotes:FlxCamera;
var highwayShader:CustomShader;

function postCreate()
{
    camNotes = new HudCamera();
    camNotes.downscroll = true;
    camNotes.bgColor = 0x00000000;
    FlxG.cameras.add(camNotes, false);

    for (line in strumLines.members)
    {
        line.cameras = [camNotes];

        for (strum in line.members)
            strum.cameras = [camNotes];
    }

    highwayShader = new CustomShader("highway");
    highwayShader.angleX = -25.0;

    camNotes.addShader(highwayShader);
}