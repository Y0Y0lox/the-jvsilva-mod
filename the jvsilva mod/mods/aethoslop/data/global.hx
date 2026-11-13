import funkin.menus.TitleState;
import funkin.menus.MainMenuState;

static var redirectStates:Map<Dynamic, String> = [
    TitleState => "peepeeMenu"
];

function preStateSwitch() {
    for (redirectState in redirectStates.keys()) {
        if (Std.isOfType(FlxG.game._requestedState, redirectState)) {
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
        }
    }
}