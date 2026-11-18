public var iconP3:HealthIcon;
public var iconName:String;
public var isPlayer:Bool = false;
var iconP;
var baseScale:Float = 1;

function postCreate()
{
    for (sl in strumLines.members) {
        for (char in sl.characters) {
            if (char == null) continue;

            if (char.curCharacter == "pirlnon") {
                isPlayer = false;
                iconName = "anon";
                baseScale = 1;
            } else if (char.curCharacter == "yoyolore") {
                isPlayer = true;
                iconName = "diamond";
                baseScale = 0.65;
            }
        }
    }

    if (iconName == null) return;

    iconP3 = new HealthIcon(iconName, isPlayer);
    iconP3.camera = camHUD;
    iconP3.scale.set(baseScale, baseScale);
    iconP3.updateHitbox();
    add(iconP3);

    if (isPlayer)
        iconP = iconP1;
    else
        iconP = iconP2;

    iconP3.x = iconP.x - (isPlayer ? -60 : 60);
    iconP3.y = iconP.y - 40;
}

function postUpdate()
{
    if (iconP3 == null) return;

    iconP3.scale.set(iconP.scale.x * baseScale, iconP.scale.y * baseScale);
    iconP3.health = iconP.health;
    iconP3.x = iconP.x - (isPlayer ? -60 : 60);
}
