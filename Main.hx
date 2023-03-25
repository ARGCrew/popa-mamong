package;

import flixel.FlxGame;
import openfl.events.Event;
import flixel.custom.system.FlxCrashHandler;

using StringTools;

class Main extends openfl.display.Sprite
{
	var window = {
		width: 1280,
		height: 720,
		zoom: -1.0
	};

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		openfl.Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = openfl.Lib.current.stage.stageWidth;
		var stageHeight:Int = openfl.Lib.current.stage.stageHeight;

		var ratioX:Float = stageWidth / 1280;
		var ratioY:Float = stageHeight / 720;
		window.zoom = Math.min(ratioX, ratioY);
		window.width = Math.ceil(stageWidth / window.zoom);
		window.height = Math.ceil(stageHeight / window.zoom);

		addChild(new flixel.FlxGame(window.width, window.height, InitialState, #if (flixel < "5.0.0") window.zoom, #end 120, 120, true, false));
		addChild(new FlxCrashHandler());
	}
}
