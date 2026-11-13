// Codename Engine v1.0.1 multi-key noteskin
// Put this file directly in your mod's "songs" folder so it runs for every song.

var NOTE_SKIN_PATH = "game/notes/NOTE_assets";

function getLineKeyCount(line) {
    if (line == null)
        return 4;

    if (line.data != null && line.data.keyCount != null)
        return line.data.keyCount;

    if (line.members != null && line.members.length > 0)
        return line.members.length;

    return 4;
}

function getKeyCount(strumLineID) {
    return getLineKeyCount(strumLines.members[strumLineID]);
}

// Controls which receptor/note graphic each lane uses.
function getLaneLayout(keyCount) {
    switch (keyCount) {
        case 1:
            return ["center"];

        case 2:
            return ["left", "right"];

        case 3:
            return ["left", "center", "right"];

        case 4:
            return ["left", "down", "up", "right"];

        case 5:
            return ["left", "down", "center", "up", "right"];

        case 6:
            return ["left", "down", "up", "up", "down", "right"];

        case 7:
            return ["left", "down", "up", "center", "up", "down", "right"];

        case 8:
            return ["left", "down", "up", "right",
                    "left", "down", "up", "right"];

        case 9:
            return ["left", "down", "up", "right", "center",
                    "left", "down", "up", "right"];

        default:
            return ["left", "down", "center", "up", "right"];
    }
}

function getLanePrefix(keyCount, lane) {
    var lanes = getLaneLayout(keyCount);

    if (lane < 0)
        lane = 0;

    return lanes[lane % lanes.length];
}

function getColorPrefix(lanePrefix) {
    switch (lanePrefix) {
        case "left":
            return "purple";

        case "down":
            return "blue";

        case "center":
            return "gray";

        case "up":
            return "green";

        case "right":
            return "red";
    }

    return "gray";
}

// Character singing animations still only have four normal directions:
// 0 = LEFT, 1 = DOWN, 2 = UP, 3 = RIGHT.
//
// For 5K:
// purple = LEFT
// blue   = DOWN
// gray   = UP
// green  = UP
// red    = RIGHT
function getCharacterDirection(keyCount, lane) {
    var directions = null;

    switch (keyCount) {
        case 1:
            directions = [2];

        case 2:
            directions = [0, 3];

        case 3:
            directions = [0, 2, 3];

        case 4:
            directions = [0, 1, 2, 3];

        case 5:
            directions = [0, 1, 2, 2, 3];

        case 6:
            directions = [0, 1, 2, 2, 1, 3];

        case 7:
            directions = [0, 1, 2, 2, 2, 1, 3];

        case 8:
            directions = [0, 1, 2, 3, 0, 1, 2, 3];

        case 9:
            directions = [0, 1, 2, 3, 2, 0, 1, 2, 3];

        default:
            directions = [0, 1, 2, 3];
    }

    if (lane < 0)
        lane = 0;

    return directions[lane % directions.length];
}

function create() {
    // Set the correct receptor layout before Codename generates the strums.
    for (line in strumLines.members) {
        if (line == null)
            continue;

        line.strumAnimPrefix = getLaneLayout(getLineKeyCount(line));
    }
}

function onStrumCreation(event) {
    var keyCount = getKeyCount(event.player);

    event.sprite = NOTE_SKIN_PATH;
    event.animPrefix = getLanePrefix(keyCount, event.strumID);
}

function onNoteCreation(event) {
    // Keep separately scripted/custom note types unchanged.
    if (event.noteType == null)
        event.noteSprite = NOTE_SKIN_PATH;
}

function onPostNoteCreation(event) {
    if (event.noteType != null)
        return;

    var note = event.note;
    var keyCount = getKeyCount(event.strumLineID);
    var lanePrefix = getLanePrefix(keyCount, event.strumID);
    var colorPrefix = getColorPrefix(lanePrefix);

    note.animation.addByPrefix("scroll", colorPrefix + "0");
    note.animation.addByPrefix("hold", colorPrefix + " hold piece");
    note.animation.addByPrefix("holdend", colorPrefix + " hold end");

    if (note.isSustainNote)
        note.animation.play("holdend", true);
    else
        note.animation.play("scroll", true);

    note.updateHitbox();
}

function remapCharacterAnimation(event) {
    if (event == null || event.note == null || event.note.strumLine == null)
        return;

    var keyCount = getLineKeyCount(event.note.strumLine);
    event.direction = getCharacterDirection(keyCount, event.note.strumID);
}

// These run before Codename calls Character.playSingAnim().
function onPlayerHit(event) {
    remapCharacterAnimation(event);
}

function onDadHit(event) {
    remapCharacterAnimation(event);
}

// Also fix the direction when an actual charted note is missed.
function onPlayerMiss(event) {
    remapCharacterAnimation(event);
}
