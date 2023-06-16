import flixel.FlxG;
import openfl.events.UncaughtErrorEvent;
import flixel.FlxGame;
import openfl.Lib;
#if windows
import h4m.windows.WinAPI;
#end
import system.Cursor;

using StringTools;

class Main {
	public static var cursor:Cursor;

	static function main() {
		#if windows
		WinAPI.GetActiveWindow().darkMode = true;
		#end

		Lib.current.addChild(new FlxGame(1920, 1080, states.InitialState, 60, 60, true, false));
		cursor = new Cursor();
		Lib.current.addChild(cursor);

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, system.CrashHandler.onCrash);
		#end

		FlxG.autoPause = false;
	}
}
