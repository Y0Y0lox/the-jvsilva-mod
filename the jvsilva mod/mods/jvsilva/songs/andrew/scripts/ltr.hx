import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.media.openal.AL;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.Lib;
import funkin.backend.utils.WindowUtils;
import funkin.game.PlayState;
import lime.app.Application;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import lime.media.AudioBuffer;
import funkin.game.Note;
import funkin.backend.scripting.events.NoteHitEvent;

var centerX:Int = 320;
var centerY:Int = 180;
var evilint:Float = 1.15;
function create (){
	PlayState.SONG.meta.bpm = 210;
}
function postCreate() {

	evilint = 1;
        camHUDZoomMult = 0.1;
	camGameZoomMult = 0.1;
	showRating = false;
	var displayW = FlxG.stage.fullScreenWidth;
	var displayH = FlxG.stage.fullScreenHeight;
	var baseW:Int = 1280;
	var baseH:Int = 720;
	//stage.stageSprites["bg"].alpha = 0;
	strumLines.members[3].characters[0].visible = false;
	for (char in strumLines.members[3].members) {
		char.visible = false;
		
   	}
	centerX = displayW / 2 - baseW / 2;
        centerY = displayH / 2 - baseH / 2;
}
	
function create() {
	
}

function postUpdate(el) {
	Conductor.changeBPM(210);
	if (FlxG.sound.music != null && FlxG.sound.music._channel != null) {
		var instSource = FlxG.sound.music._channel.__source;
		if (instSource != null) {
			instSource.pitch = evilint;
		}
	}
	if (vocals != null && vocals._channel != null) {
		var instSource = vocals._channel.__source;
		if (instSource != null) {
			instSource.pitch = evilint;
		}
	}
	if(FlxG.sound.music.isPlaying && vocals.isPlaying) {
		vocals.time = FlxG.sound.music.time;
	}
}