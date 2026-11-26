import funkin.backend.system.framerate.Framerate;
import lime.app.Application;

var shittyshitshit:Int;

function postCreate() {
    shittyshitshit = Framerate.debugMode;
    Framerate.debugMode = 0;

    camHUD.visible = false;
    startSong();
    Application.current.window.borderless = true;
    Application.current.window.opacity = 1;
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