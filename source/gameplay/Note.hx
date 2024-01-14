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
		super((Constants.STRUM_SIZE + Constants.STRUM_SPACING) * (data % 3), (Constants.STRUM_SIZE + Constants.STRUM_SPACING) * Std.int(data / 3), Assets.graphic('notes/SQUARE'));
		this.data = struct.data;
		this.time = struct.time;

		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			scaleMult = (FlxG.sound.music.time - (time - PlayState.SONG.speed * 1000)) * (Constants.NOTE_PERFECT_SCALE / 1000);
	}

	public var hitted:Bool = false;
	public var show(default, null):Bool = false;
	public var hittable(default, null):Bool = false;
	override function update(elapsed:Float) {
		createThread(() -> {
			if (FlxG.sound.music != null && FlxG.sound.music.playing) {
				var deltaTime:Float = FlxG.sound.music.time - time;
				if (Math.abs(deltaTime) <= Constants.NOTE_HIT_WINDOW)
					hittable = true;
	
				scaleMult = (FlxG.sound.music.time - (time - PlayState.SONG.speed * 1000)) * (Constants.NOTE_PERFECT_SCALE / 1000);
	
				if (scaleMult > 0)
					show = true;
				if (deltaTime > Constants.NOTE_HIT_WINDOW)
					show = false;
			}
		});

		if (!show || hitted)
			return;
		
		super.update(elapsed);
	}

	override function draw() {
		if (!show || hitted)
			return;

		super.draw();
	}
}

typedef NoteStruct = {
	var data:Int;
	var time:Float;
}