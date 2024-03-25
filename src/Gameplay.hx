import h2d.Tile;
import h2d.Bitmap;
import h2d.Scene;

class Gameplay extends Scene {
	var strums:StrumGrid;

	var background:Background;

	public function new() {
		super();

		background = new Background(this);

		strums = new StrumGrid(this);
	}
}