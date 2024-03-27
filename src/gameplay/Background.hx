package gameplay;

import h2d.RenderContext;
import h2d.Tile;
import h2d.Object;
import h2d.Bitmap;

class Background extends Bitmap {
	public function new(?parent:Object) {
		super(Tile.fromColor(0xff000000), parent);
	}

	override function sync(ctx:RenderContext) {
		scaleX = Stage.getInstance().width;
		scaleY = Stage.getInstance().height;

		super.sync(ctx);
	}
}