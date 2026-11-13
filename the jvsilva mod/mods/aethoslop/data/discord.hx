import funkin.backend.utils.DiscordUtil;

function onGameOver() {
	DiscordUtil.changePresence('Game Over', PlayState.SONG.meta.displayName + " (" + PlayState.difficulty + ")");
}

function onDiscordPresenceUpdate(e) {
	var data = e.presence;

	if(data.button1Label == null)
		data.button1Label = "pussy"; // "Codename Engine Discord"
	if(data.button1Url == null)
		data.button1Url = "https://discord.gg/Mg6YZsN6vQ";
}

function onPlayStateUpdate() {
	DiscordUtil.changeSongPresence(
		PlayState.instance.detailsText,
		(PlayState.instance.paused ? "bro is fucking dead - " : "") + PlayState.SONG.meta.displayName + " (" + PlayState.difficulty + ")",
		PlayState.instance.inst,
		PlayState.instance.getIconRPC()
	);
}

function onMenuLoaded(name:String) {
	// Name is either "Main Menu", "Freeplay", "Title Screen", "Options Menu", "Credits Menu", "Beta Warning", "Update Available Screen", "Update Screen"
	DiscordUtil.changePresenceSince("Gooning In The Menu idk", null);
}

function onEditorTreeLoaded(name:String) {
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Choosing a Dumbass", null);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("bros trying to make music", null);
		//case "Stage Editor": // secret for now
		//	DiscordUtil.changePresenceSince("Choosing a Stage", null);
	}
}

function onEditorLoaded(name:String, editingThing:String) {
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Editing a Dumbass", editingThing);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("bro is NOT cooking", editingThing);
		//case "Stage Editor":
		//	DiscordUtil.changePresenceSince("Editing a Stage", editingThing);
	}
}