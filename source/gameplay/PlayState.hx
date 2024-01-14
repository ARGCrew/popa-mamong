package gameplay;

import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
import flixel.FlxG;
import openfl.media.Sound;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.addons.transition.FlxTransitionableState;

class PlayState extends FlxTransitionableState {
	public static var SONG:Song = {
		data: {
			name: 'lost_error',
			artist: 'JustFunduk'
		},
		notes: [
			{
				data: 0,
				time: 3000
			},
			{
				data: 1,
				time: 6000
			},
			{
				data: 2,
				time: 9000
			}
		]
	};
	var strums:FlxTypedSpriteGroup<Strum>;
	var notes:FlxTypedSpriteGroup<Note>;
	
	override function create() {
		Fmod.playSound(FmodSFX.NoteHitPress, 'sfx_NoteHitPress');
		Fmod.stopSound('sfx_NoteHitPress');
		Fmod.playSound(FmodSFX.NoteMissPress, 'sfx_NoteMissPress');
		Fmod.stopSound('sfx_NoteMissPress');

		notes = new FlxTypedSpriteGroup<Note>();
		for (i in 0...SONG.notes.length) {
			var note:Note = new Note(SONG.notes[i]);
			notes.add(note);
		}
		add(notes);

		strums = new FlxTypedSpriteGroup<Strum>();
		for (i in 0...9) {
			var strum:Strum = new Strum(i);
			strums.add(strum);
		}
		strums.screenCenter();
		add(strums);

		notes.setPosition(strums.x, strums.y);

		super.create();
	}

	override function update(elapsed:Float) {
		Fmod.update();

		for (i in 0...strums.length) {
			var keys:Array<FlxKey> = Constants.CONTROLS[i];
			var pressed:Bool = FlxG.keys.anyJustPressed(keys);
			var released:Bool = FlxG.keys.anyJustReleased(keys);
			var strum:Strum = strums.members[i];

			if (pressed) {
				strum.color = Constants.STRUM_HIT_COLOR;
				Fmod.playSoundOneshot(FmodSFX.NoteHitPress);
			} else if (released) {
				strum.color = Constants.STRUM_RELEASE_COLOR;
			}
		}
	}
}