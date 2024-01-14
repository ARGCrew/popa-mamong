package gameplay;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;

class Note extends FlxSprite {
	public var data:Int;
	public var time:Float;

	var scaleMult(default, set):Float = 1;
	function set_scaleMult(value:Float):Float {
		scale.set(value, value);
		return scaleMult = value;
	}

	public function new(struct:NoteStruct) {
		data = struct.data;
		time = struct.time;

		super((Constants.STRUM_SIZE + Constants.STRUM_SPACING) * (data % 3), (Constants.STRUM_SIZE + Constants.STRUM_SPACING) * Std.int(data / 3), Assets.graphic('notes/SQUARE'));

		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			scaleMult = (FlxG.sound.music.time - (time - PlayState.SONG.speed * 1000)) * (Constants.NOTE_PERFECT_SCALE / 1000);
		else
			scaleMult = 0;
	}

	public var hittable(default, null):Bool = false;
	override function update(elapsed:Float) {
		createThread(() -> {
			if (FlxG.sound.music != null && FlxG.sound.music.playing) {
				var deltaTime:Float = FlxG.sound.music.time - time;
				if (Math.abs(deltaTime) <= Constants.NOTE_HIT_WINDOW)
					hittable = true;
	
				scaleMult = (FlxG.sound.music.time - (time - PlayState.SONG.speed * 1000)) * (Constants.NOTE_PERFECT_SCALE / 1000);
				if (scaleMult < 0)
					visible = false;
				else
					visible = true;
	
				if (deltaTime > Constants.NOTE_HIT_WINDOW)
					kill();
			}
		});

		super.update(elapsed);
	}
}

typedef NoteStruct = {
	var data:Int;
	var time:Float;
}