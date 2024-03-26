import hxd.System;
import h3d.Engine;
import hxd.Cursor;
import hxd.Key;
import hxd.Window;
import hxd.Res;
import hxd.App;

@:access(hxd.Window)
class Main extends App {
	public static var current:Main;
	static var cursor:Cursor;

	static function main() {
		current = new Main();

		#if hldx
		/*var window:Window = Window.getInstance();
		var setting:DisplaySetting = window.getCurrentDisplaySetting();

		window.window.setPosition(Std.int((setting.width - window.width) / 2), Std.int((setting.height - window.height) / 2));*/
		Window.getInstance().window.center();
		#end
	}

	override function init() {
		#if desktop
		Res.initLocal();
		#else
		Res.initEmbed();
		#end

		cursor = Custom(new CustomCursor([Res.backend.cursor.toBitmap()], 0, 2, 2));

		setScene(new gameplay.Gameplay());
		// setScene(new settings.Settings());
	}

	override function update(deltaTime:Float) {
		if (Key.isPressed(Key.F11))
			Window.getInstance().displayMode = (Window.getInstance().displayMode == Windowed) ? Borderless : Windowed;
	}

	override function render(e:Engine) {
		System.setCursor(cursor);
		super.render(e);
	}
}