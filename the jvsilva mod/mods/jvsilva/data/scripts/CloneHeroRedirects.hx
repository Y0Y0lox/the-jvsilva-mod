
function preStateSwitch() {
    // Only redirect when Clone Hero Mode is enabled.
    if (FlxG.save.data.cloneHeroMenu != true)
        return;

    var redirects = [
        MainMenuState => "CloneHeroMenuState"
    ];

    for (originalState in redirects.keys()) {
        if (Std.isOfType(FlxG.game._requestedState, originalState)) {
            FlxG.game._requestedState =
                new ModState(redirects.get(originalState));
            return;
        }
    }
}
