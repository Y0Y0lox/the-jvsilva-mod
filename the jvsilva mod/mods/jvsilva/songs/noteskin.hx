// VS Shaggy noteskin for Codename Engine 1.0.1
// Based on noteskin(2).hx. Place in YOUR_MOD/songs/.
var NOTE_SKIN_PATH = "game/notes/NOTE_shag_assets";

function getLineKeyCount(line) {
    if (line == null) return 4;
    if (line.data != null && line.data.keyCount != null) return line.data.keyCount;
    if (line.members != null && line.members.length > 0) return line.members.length;
    return 4;
}
function getKeyCount(id) { return getLineKeyCount(strumLines.members[id]); }

// Shaggy's actual scrolling-note sprite names (A-I).
function getLaneLayout(keys) {
    switch (keys) {
        case 1: return ["E"];
        case 2: return ["A", "D"];
        case 3: return ["A", "E", "D"];
        case 4: return ["A", "B", "C", "D"];
        case 5: return ["A", "B", "E", "C", "D"];
        case 6: return ["A", "C", "D", "F", "B", "I"]; // Purple L, Green U, Red R, Yellow L, Cyan D, Blue R
        case 7: return ["A", "B", "C", "E", "C", "B", "D"];
        case 8: return ["A", "B", "C", "D", "F", "G", "H", "I"];
        case 9: return ["A", "B", "C", "D", "E", "F", "G", "H", "I"];
        default: return ["A", "B", "C", "D"];
    }
}
function getLanePrefix(keys, lane) {
    var layout = getLaneLayout(keys);
    if (lane < 0) lane = 0;
    return layout[lane % layout.length];
}
function getCharacterDirection(keys, lane) {
    var dirs;
    switch (keys) {
        case 1: dirs = [2];
        case 2: dirs = [0, 3];
        case 3: dirs = [0, 2, 3];
        case 4: dirs = [0, 1, 2, 3];
        case 5: dirs = [0, 1, 2, 2, 3];
        case 6: dirs = [0, 2, 3, 0, 1, 3];
        case 7: dirs = [0, 1, 2, 2, 2, 1, 3];
        case 8: dirs = [0, 1, 2, 3, 0, 1, 2, 3];
        case 9: dirs = [0, 1, 2, 3, 2, 0, 1, 2, 3];
        default: dirs = [0, 1, 2, 3];
    }
    if (lane < 0) lane = 0;
    return dirs[lane % dirs.length];
}
function getReceptorFrame(prefix) {
    switch (prefix) {
        case "A", "F": return "arrowLEFT";
        case "B", "G": return "arrowDOWN";
        case "C", "H": return "arrowUP";
        case "D", "I": return "arrowRIGHT";
        case "E": return "arrowSPACE";
        default: return "arrowSPACE";
    }
}
function onStrumCreation(event) {
    event.sprite = NOTE_SKIN_PATH;
    // This name is only an initial animation prefix for creation.
    event.animPrefix = getReceptorFrame(getLanePrefix(getKeyCount(event.player), event.strumID));
}
function onPostStrumCreation(event) {
    var strum = event.strum;
    var prefix = getLanePrefix(getKeyCount(event.player), event.strumID);
    // IDLE RECEPTORS ARE GREY — NOT THE COLORED A-I SCROLLING FRAMES.
    strum.animation.addByPrefix("static", getReceptorFrame(prefix), 24, false);
    strum.animation.addByPrefix("pressed", prefix + " press", 24, false);
    strum.animation.addByPrefix("confirm", prefix + " confirm", 24, false);
    strum.playAnim("static");
}
function onNoteCreation(event) {
    if (event.noteType == null) event.noteSprite = NOTE_SKIN_PATH;
}
function onPostNoteCreation(event) {
    if (event.noteType != null) return;
    var note = event.note;
    var prefix = getLanePrefix(getKeyCount(event.strumLineID), event.strumID);
    note.animation.addByPrefix("scroll", prefix + "0", 24, false);
    note.animation.addByPrefix("hold", prefix + " hold", 24, false);
    note.animation.addByPrefix("holdend", prefix + " tail", 24, false);
    if (note.isSustainNote) note.animation.play("holdend", true);
    else note.animation.play("scroll", true);
    note.updateHitbox();
}
function remapCharacterAnimation(event) {
    if (event == null || event.note == null || event.note.strumLine == null) return;
    event.direction = getCharacterDirection(getLineKeyCount(event.note.strumLine), event.note.strumID);
}
function onPlayerHit(event) { remapCharacterAnimation(event); }
function onDadHit(event) { remapCharacterAnimation(event); }
function onPlayerMiss(event) { remapCharacterAnimation(event); }
