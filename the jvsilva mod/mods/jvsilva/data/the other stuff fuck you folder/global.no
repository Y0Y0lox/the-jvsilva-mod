// Codename Engine 1.0.1 - Clone Hero main-menu redirect
// This is a GLOBAL SCRIPT. preStateSwitch() runs before the next state loads.
// The redirect pattern below follows the Codename Engine Script Snippets wiki.

var redirectStates:Map<FlxState, String> = [
    MainMenuState => "CloneHeroMenuState"
];

function new() {
    // Clone Hero Mode is opt-in. The checkbox is defined in data/config/options.xml.
    if (FlxG.save.data.cloneHeroMenu == null) {
        FlxG.save.data.cloneHeroMenu = false;
        FlxG.save.flush();
    }
}

function preStateSwitch() {
    // Leave the engine's normal main menu untouched unless the option is enabled.
    if (FlxG.save.data.cloneHeroMenu != true) return;

    for (redirectState in redirectStates.keys()) {
        if (Std.isOfType(FlxG.game._requestedState, redirectState)) {
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
            return;
        }
    }
}
