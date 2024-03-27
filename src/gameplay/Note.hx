package gameplay;

import hxd.res.Image;
import gameplay.StrumGrid;
import h2d.RenderContext;
import h2d.Object;
import hxd.Res;
import h2d.Bitmap;

inline var NOTE_PERFECT_SCALE = 145 / 197;
inline var NOTE_HIT_WINDOW = 20 / 60;

class Note extends Bitmap {
	public var time:Float;
	public var data:Int;

	public var canBeHit:Bool = false;
	
	public function new(time:Float, data:Int, ?parent:Object) {
		super(Res.gameplay.note.toTile(), parent);
		this.time = time;
		this.data = data;
	}

	var prevPosition:Float = 0;
	override function sync(ctx:RenderContext) {
		if (!Gameplay.instance.song.pause) {
			if (Gameplay.instance.song.position != prevPosition) {
				syncWithMusic(Gameplay.instance.song.position);
				prevPosition = Gameplay.instance.song.position;
			}
		}

		super.sync(ctx);
	}

	function syncWithMusic(position:Float) {
		setScale(Gameplay.instance.song.position - (time - Gameplay.SONG.speed));
	
		var strum:Strum = Gameplay.instance.strumGrid.strums[data];
		x = Gameplay.instance.strumGrid.x + strum.x + strum.getSize().width / 2 - getSize().width / 2;
		y = Gameplay.instance.strumGrid.y + strum.y + strum.getSize().height / 2 - getSize().height / 2;

		var offset:Float = position - time;
		visible = (scaleX > 0) && (offset <= NOTE_HIT_WINDOW);
		canBeHit = (Math.abs(offset) <= NOTE_HIT_WINDOW);
		if (offset <= NOTE_HIT_WINDOW)
			canBeHit = true;
		else
			canBeHit = false;

		if (scaleX >= NOTE_PERFECT_SCALE)
			trace(Gameplay.instance.song.position);
	}
}