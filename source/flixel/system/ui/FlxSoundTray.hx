package flixel.system.ui;

import openfl.display.Bitmap;
import openfl.display.Sprite;

class FlxSoundTray extends Sprite {
	public var active:Bool;
	public var volumeUpSound:String = "flixel/sounds/beep";
	public var volumeDownSound:String = 'flixel/sounds/beep';
	public var silent:Bool = false;
	public function new() {
		super();
	}

	public function update(MS:Float):Void {}

	public function show(up:Bool = false):Void {}

	public function screenCenter():Void {}
}
