var foxy:FunkinSprite = new FunkinSprite();
var foxyAudio:FlxSound;
var jumpscaring:Bool = false;
var maxChances:Int = 100;
var curNumber:Int = 0;
public var foxyCamera:FlxCamera = new FlxCamera();

function postCreate() {
    foxyCamera.bgColor = 0;
    FlxG.cameras.add(foxyCamera, false);

    foxy.loadSprite(Paths.image('foxy'));
    foxy.addAnim('boo', 'boo', 24, false);
    foxy.screenCenter();
    foxy.alpha = 0.001;
    foxy.camera = foxyCamera;
    add(foxy);

    foxyAudio = FlxG.sound.load(Paths.sound('jumpscare'));
    foxy.animation.callback = function(name:String) {
        foxyAudio.play();
        jumpscaring = true;
    }
    foxy.animation.finishCallback = function(name:String) {
        foxy.alpha = 0.0001;
        foxyAudio.stop();
        jumpscaring = false;
    }
}

function beatHit()
    if (curBeat % 4 == 0) {
        curNumber = FlxG.random.int(0, maxChances);

        if (!jumpscaring && curNumber == 1) {
            foxy.playAnim('boo');
            foxy.alpha = 1;
        }
    }