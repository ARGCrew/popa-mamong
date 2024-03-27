package gameplay;

import h2d.RenderContext;
import hxd.Res;
import h2d.Bitmap;
import h2d.Object;

inline var STRUM_SIZE = 189;
inline var STRUM_SPACING = 10;
inline var STRUM_FULLSTACK = STRUM_SIZE + STRUM_SPACING;

class StrumGrid extends Object {
	public var strums:Array<Strum>;

	public function new(?parent:Object) {
		super(parent);

		strums = [
			for (i in 0...9)
				new Strum(i, this)
		];
	}

	override function sync(ctx:RenderContext) {
		x = Stage.getInstance().width - getSize().width;
		y = Stage.getInstance().height - getSize().height;
		
		x /= 2;
		y /= 2;

		super.sync(ctx);
	}
}

class Strum extends Bitmap {
	public var data:Int;

	public function new(data:Int, ?parent:Object) {
		this.data = data;

		super(Res.gameplay.strum.toTile(), parent);
		smooth = true;
		setPosition(STRUM_FULLSTACK * (data % 3), STRUM_FULLSTACK * Std.int(data / 3));
	}
}