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
	public static function main() {
		#if desktop
		Lib.current.addChild(new FlxCrashHandler());
		#end
		Lib.current.addChild(new FlxGame(1280, 720, InitialState, 60, 60, true, false));
		Lib.current.addChild(new Memory());

		FlxG.sound.muteKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.volumeUpKeys = [];

		FlxSprite.defaultAntialiasing = true;
		native.WinAPI.setDarkMode(true);
	}
}