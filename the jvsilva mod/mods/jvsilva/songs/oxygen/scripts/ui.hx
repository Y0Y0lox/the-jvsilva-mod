var songText = null;

function postCreate() {
    hitWindow = 175;

    initStatusTextEdits();
    initHealthBarEdits();
    initKadeSongText();
    initIconEdits();
}

function onSongStart() {
    FlxTween.tween(songText, { alpha: 1.0 }, 2.0);
}

function initStatusTextEdits() {
    scoreTxt.visible = false;
    accuracyTxt.visible = false;
    missesTxt.alignment = 0;
    missesTxt.x = 800;
    missesTxt.y += 10;

    missesTxt.borderSize = 2.0;

    if (downscroll) {missesTxt.y -= 60;}
}

function initHealthBarEdits() {
    healthBarBG.scale.y = 1.0;
    healthBarBG.scale.x = 1.0;
    healthBar.scale.x = 1.0;
    healthBar.scale.y = 1.0;
}

function initKadeSongText() {
    songText = new FunkinText(8, FlxG.height - 24, 0, curSong + " by ");

    songText.antialiasing = false;
    songText.textField.antiAliasType = 0;
    songText.textField.sharpness = 400;

    songText.borderSize = 2.0;

    missesTxt.textField = songText.textField;
    songText.alpha = 0.001;
    if (downscroll) {songText.y = 0;}

    switch (curSong) {
        case "oxygen":
            songText.text += "Y0Y0lox";
    }

    add(songText);
    songText.camera = camHUD;
}

function initIconEdits() {
    doIconBop = false;
    if (downscroll) {
        iconP1.y += 20;
        iconP2.y += 20;
    }
}