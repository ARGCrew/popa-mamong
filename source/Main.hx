import haxefmod.FmodManager;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;
import flixel.FlxSprite;
#if windows
import native.Windows;
#end
import flixel.FlxG;
import flixel.FlxGame;

class Main extends FlxGame {
	function new() {
		Lib.current.loaderInfo.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);

		upgradeFullscreen();
		#if windows
		Windows.setDarkMode(true);
		#end

		FlxSprite.defaultAntialiasing = true;

		final framerate:Int = FlxG.stage.application.window.displayMode.refreshRate;
		super(1920, 1080, IntroState, framerate, framerate, false, false);
		FlxG.plugins.add(new Fmod());

		FmodManager.EnableDebugMessages();

		FlxG.mouse.useSystemCursor = true;
		
		// FlxG.mouse.load(Paths.image('cursor'));
		/*FlxG.mouse.useSystemCursor = true;
		Windows.loadCursor('assets/cursor.cur');
		FlxG.stage.application.window.onMouseMove.add(function(x:Float, y:Float) {
			Windows.updateCusror();
		});
		FlxG.stage.application.window.onMouseMoveRelative.add(function(x:Float, y:Float) {
			Windows.updateCusror();
		});
		FlxG.stage.addEventListener(Event.ENTER_FRAME, function(e:Event) {
			Windows.updateCusror();
		});*/
	}

	function upgradeFullscreen() { // бесконечный костыль мортиса
		var windowFullscreen:Bool = !FlxG.stage.application.window.fullscreen;
		function onFullscreen() {
			if (ClientPrefs.data.displayType != 'Borderless')
				return;
	
			FlxG.stage.application.window.fullscreen = false;
			if (!windowFullscreen) {
				FlxG.stage.application.window.borderless = true;
				FlxG.stage.application.window.maximized = true;
				windowFullscreen = true;
			} else {
				FlxG.stage.application.window.maximized = false;
				FlxG.stage.application.window.borderless = false;
				windowFullscreen = false;
			}
		}
		onFullscreen();
		FlxG.stage.application.window.onFullscreen.add(onFullscreen);
	}

	function onUncaughtError(e:UncaughtErrorEvent) {
		FlxG.stage.application.window.alert(Std.string(e), 'Error!');
		Sys.exit(1);
	}
}