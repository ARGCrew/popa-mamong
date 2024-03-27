package gameplay;

import hxd.Event;
import backend.Discord;
import h2d.RenderContext;
import Song;
import hxd.Res;
import hxd.snd.Channel;
import h2d.Scene;

class Gameplay extends Scene {
	public static var instance:Gameplay;

	public static var SONG:Song;
	public var song:Channel;

	public var strumGrid:StrumGrid;
	var notes:Array<Note> = [];

	var background:Background;

	public function new() {
		super();
		instance = this;

		SONG = getSong('lost_error');

		song = Res.load('songs/${SONG.data.name}.mp3').toSound().play();
		// song.pause = true;

		background = new Background(this);

		strumGrid = new StrumGrid(this);

		for (i in 0...SONG.notes.length) {
			var time:Float = SONG.notes[i][0];
			var data:Int = SONG.notes[i][1];

			var note:Note = new Note(time, data, this);
			notes.insert(0, note);
		}

		Discord.presence(SONG.data.name, song.duration);

		addEventListener(onFocus);
	}

	function onFocus(e:Event) {
		if (e.kind == EFocusLost) {
			song.pause = true;
			Discord.presence(SONG.data.name, 'Paused — ${Util.formatTime(song.position)} / ${Util.formatTime(song.duration)}');
		} else if (e.kind == EFocus)
			song.pause = false;
	}

	override function sync(ctx:RenderContext) {
		if (!song.pause)
			Discord.presence(SONG.data.name, 'Playing — ${Util.formatTime(song.position)} / ${Util.formatTime(song.duration)}');

		super.sync(ctx);
	}
}