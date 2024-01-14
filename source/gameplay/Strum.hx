package gameplay;

import flixel.FlxSprite;

class Strum extends FlxSprite {

	public var data(default, null):Int;

	public function new(data:Int) {
		this.data = data;
		super((Constants.STRUM_SIZE + Constants.STRUM_SPACING) * (data % 3), (Constants.STRUM_SIZE + Constants.STRUM_SPACING) * Std.int(data / 3), Assets.graphic('strums/SQUARE'));
	}
}