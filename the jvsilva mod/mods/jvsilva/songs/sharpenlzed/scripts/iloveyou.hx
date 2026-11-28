import funkin.backend.system.framerate.Framerate;
import lime.app.Application;

var shittyshitshit:Int;

var windowY:Float = Application.current.window.y;

// At the top of the file
import openfl.Lib;
//later

function postCreate() {
    shittyshitshit = Framerate.debugMode;
    Framerate.debugMode = 0;

    camHUD.visible = false;

    Application.current.window.borderless = true;
    Application.current.window.opacity = 0;

    Application.current.window.y = windowY * 2.5;

    startSong();
    FlxTween.tween(Application.current.window, { opacity: 1 }, 7.5, { ease: FlxEase.quartInOut });
    FlxTween.tween(Application.current.window, { y: windowY }, 7.5, { ease: FlxEase.quartInOut });
    
}

function onCountdown(event) {
    event.cancel();
}

function onGamePause(event) {
    event.cancel();
    final gaySexWindow = Lib.application.createWindow({
        width: 400,
        height: 400,
        x: 0,
        y: 0,
        title: "Hey There!",
        resizable: false
    });
}

function destroy() {
    Framerate.debugMode = shittyshitshit;
    Application.current.window.borderless = false;
    Application.current.window.opacity = 1;
    Application.current.window.y = windowY;
}