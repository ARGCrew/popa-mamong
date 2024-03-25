import h3d.Vector4;
import hxd.res.Image;
import h2d.col.Point;
import hxd.BitmapData;
import h2d.col.Circle;
import h2d.Tile;
import h2d.RenderContext;
import hxd.Res;
import h2d.Bitmap;
import h2d.Scene;

class Settings extends Scene {
	var palette:Bitmap;
	var pointer:Bitmap;
	var display:Bitmap;

	var paletteBitmap:BitmapData;
	// var paletteCollider:Circle;

	public function new() {
		super();

		var paletteImage:Image = Res.settings.palette;

		paletteBitmap = paletteImage.toBitmap();

		palette = new Bitmap(Tile.fromBitmap(paletteBitmap), this);
		palette.smooth = true;
		palette.width = 300;
		palette.height = 300;

		pointer = new Bitmap(Res.settings.pointer.toTile(), this);
		pointer.smooth = true;

		display = new Bitmap(Tile.fromColor(0xffffffff, 50, 50), this);

		// paletteCollider = new Circle(palette.x, palette.y, palette.width * 2);
	}

	override function sync(ctx:RenderContext) {
		pointer.setPosition(window.mouseX - 5, window.mouseY - 5);

		var point:Point = new Point(pointer.x + pointer.width / 2, pointer.y + pointer.height / 2);
		var pixel:Int = paletteBitmap.getPixel(Std.int((point.x - palette.x) / (palette.width / paletteBitmap.width)), Std.int((point.y - palette.y) / (palette.height / paletteBitmap.width)));
		if (pixel != 0)
			display.color = new Vector4(((pixel >> 16) & 0xff) / 255, ((pixel >> 8) & 0xff) / 255, (pixel & 0xff) / 255, 1);
		
		/*if (paletteCollider.contains(point)) {
			trace('collided');
			var pixel:Int = paletteBitmap.getPixel(Std.int(point.x - palette.x), Std.int(point.y - palette.y));
			display.color = new Vector4(((pixel >> 16) & 0xff) / 255, ((pixel >> 8) & 0xff) / 255, (pixel & 0xff) / 255, 1);
			// display.colorKey = paletteBitmap.getPixel(Std.int(palette.x - point.x), Std.int(palette.y - point.y));
		}*/

		super.sync(ctx);
	}
}