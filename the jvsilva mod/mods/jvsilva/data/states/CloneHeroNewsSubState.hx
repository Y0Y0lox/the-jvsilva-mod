// Codename Engine 1.0.1 - editable funny news feed
var newsEntries = [
    { category: "BREAKING", title: "Y0Y0 SHIT THE BED", description: "An unfortunate development. More at 11." },
    { category: "COMMUNITY", title: "PIRL AND JV DISCUSSING DIFFERENT LORE", description: "Nobody knows how this conversation started." },
    { category: "IMPORTANT", title: "MATT PLAYING CLONE HERO TRUST", description: "He has allegedly been playing Clone Hero." }
];
function create() {
    var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xF5080E18); add(bg);
    var head = new FlxText(48, 30, FlxG.width - 96, "NEWS // COMMUNITY BULLETIN", 30);
    head.setFormat(null, 30, 0xFFFFFFFF, "left"); add(head);
    add(new FlxSprite(48, 78).makeGraphic(FlxG.width - 96, 3, 0xFF49B6D8));
    for (i in 0...newsEntries.length) {
        var y = 112 + i * 112;
        var cat = new FlxText(58, y, FlxG.width - 116, "[" + newsEntries[i].category + "]", 12);
        cat.setFormat(null, 12, 0xFF49B6D8, "left"); add(cat);
        var title = new FlxText(58, y + 20, FlxG.width - 116, newsEntries[i].title, 21);
        title.setFormat(null, 21, 0xFFFFFFFF, "left"); add(title);
        var body = new FlxText(58, y + 50, FlxG.width - 116, newsEntries[i].description, 14);
        body.setFormat(null, 14, 0xFF9EB1C5, "left"); add(body);
    }
    var footer = new FlxText(48, FlxG.height - 45, FlxG.width - 96, "ESC / BACKSPACE / ENTER: RETURN", 13);
    footer.setFormat(null, 13, 0xFF8EA8C1, "left"); add(footer);
}
function update(elapsed:Float) {
    if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ENTER) close();
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.ESCAPE) {
        FlxG.switchState(new ModState("CloneHeroMenuState"));
    }
}
