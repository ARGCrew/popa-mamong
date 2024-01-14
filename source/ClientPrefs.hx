import flixel.FlxG;

@:structInit
class ClientSave {
	public var displayType(default, set):String = 'Borderless';
	function set_displayType(value:String) {
		displayType = value;

		if (this == ClientPrefs.data)
			FlxG.fullscreen = value != 'Windowed';

		return value;
	}
}

class ClientPrefs {
	public static var data:ClientSave = {};
	public static var defaults:ClientSave = {};
}