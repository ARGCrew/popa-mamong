package;

import flixel.FlxSprite;
import flixel.FlxG;
import openfl.display.Memory;
#if desktop
import flixel.custom.system.FlxCrashHandler;
#end
import flixel.FlxGame;
import openfl.Lib;

using StringTools;

class Main {
	public static var memory:Memory;

	public static function main() {
		#if desktop
		Lib.current.addChild(new FlxCrashHandler());
		#end
		Lib.current.addChild(new FlxGame(1920, 1080, InitialState, 60, 60, true, false));
		
		memory = new Memory();
		Lib.current.addChild(memory);

		FlxG.sound.muteKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.volumeUpKeys = [];

		FlxSprite.defaultAntialiasing = true;
		native.WinAPI.setDarkMode(true);
	}

	public static function toggleMemory(value:Bool) {
		value ? {
			if (!Lib.current.contains(memory)) {
				Lib.current.addChild(memory);
			}
		} : {
			if (Lib.current.contains(memory)) {
				Lib.current.removeChild(memory);
			}
		}
	}
}