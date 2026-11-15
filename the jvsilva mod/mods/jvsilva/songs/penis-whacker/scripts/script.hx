// haxe makes me want to throw rocks at peoples windows
// i want to code lua again but NO FUCK YOU NO LUA SUPPORT YOU CAN'T USE THE LANGUAGE YOU'VE CODED FOR LIKE 3 YEARS GO FUCK YOURSELF

// y0y0 wants me to suffer

function create() {
    dad.visible = false;

    var shitFucker = new FlxSprite(0, 0);
    shitFucker.makeGraphic(1920, 1920, 0xFF000000);
    shitFucker.scrollFactor.set(0, 0);
    shitFucker.screenCenter();
    add(shitFucker);

    var thePenisBar = new FlxSprite(0, 0).loadGraphic(Paths.image("clone/defaultThumb"));
    thePenisBar.scrollFactor.set(0, 0);
    thePenisBar.screenCenter();
    thePenisBar.scale.set(1.125, 1.125);
    add(thePenisBar);
}