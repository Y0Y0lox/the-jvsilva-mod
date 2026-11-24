function update(elapsed:float)
{
    if(FlxG.keys.pressed.A)
    {
        boyfriend.x -= 10;
    }

    if(FlxG.keys.pressed.L)
    {
        boyfriend.x += 10;
    }

    if(FlxG.keys.pressed.K)
    {
        boyfriend.y -= 10;
    }

    if(FlxG.keys.pressed.S)
    {
        boyfriend.y += 10;
    }

    if(FlxG.keys.justPressed.SPACE)
    {
        boyfriend.flipX = !boyfriend.flipX;
    }
}