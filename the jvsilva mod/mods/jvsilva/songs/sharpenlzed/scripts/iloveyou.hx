import funkin.backend.system.framerate.Framerate;
import lime.app.Application;

var shittyshitshit:Int;

var windowY:Float = Application.current.window.y;

function postCreate() {
    shittyshitshit = Framerate.debugMode;
    Framerate.debugMode = 0;

    camHUD.visible = false;

    Application.current.window.borderless = true;
    Application.current.window.opacity = 0;

    Application.current.window.y = windowY * 3;

    startSong();
    FlxTween.tween(Application.current.window, { opacity: 1 }, 5.0);
    FlxTween.tween(Application.current.window, { y: windowY }, 7.5);
}

function onCountdown(event) {
    event.cancel();
}

function onGamePause(event) {
    event.cancel();
}

function destroy() {
    Framerate.debugMode = shittyshitshit;
    Application.current.window.borderless = false;
    Application.current.window.opacity = 1;
}