// Codename Engine 1.0.1
// This is an appended MainMenuState script. Codename Engine loads it
// automatically when the normal MainMenuState is created.
// Keep the normal menu untouched when Clone Hero Mode is disabled.
function postCreate() {
    if (FlxG.save.data.cloneHeroMenu == true) {
        // StateRedirects in modpack.ini would ignore the checkbox and always
        // replace the base menu, so use this conditional state-script hook.
        FlxG.switchState(new ModState("CloneHeroMenuState"));
    }
}
