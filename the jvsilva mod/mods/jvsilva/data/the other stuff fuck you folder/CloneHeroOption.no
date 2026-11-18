// Helper for the existing Options menu's Clone Hero Menu toggle.
// Register this helper with the mod's current options framework.
class CloneHeroOption {
    public static function getEnabled():Bool {
        return FlxG.save.data.cloneHeroMenu == true;
    }
    public static function setEnabled(value:Bool):Void {
        FlxG.save.data.cloneHeroMenu = value;
        FlxG.save.flush();
    }
}
