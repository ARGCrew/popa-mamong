package settings;

import h2d.col.Bounds;
import h2d.col.Circle;
import h3d.Vector;
import hxd.Key;
import h2d.RenderContext;
import h2d.Tile;
import hxd.Res;
import hxd.res.Image;
import h2d.Bitmap;
import h2d.col.Point;
import hxd.BitmapData;
import h2d.Object;

enum CurrentPalette {
	RGB;
	BRT;
}

class Palette extends Object {
	var current:CurrentPalette = null;

	var rgbBitmap:BitmapData;
	var rgb:Bitmap;
	var rgbPointer:Bitmap;
	var rgbMult:Point = new Point();
	var rgbCollider:Circle;

	var brtBitmap:BitmapData;
	var brt:Bitmap;
	var brtPointer:Bitmap;
	var brtMult:Point = new Point();
	var brtCollider:Bounds;

	var rgbVector:Vector = new Vector();
	var brtVector:Vector = new Vector(1, 1, 1);
	var display:Bitmap;

	public function new(?parent:Object) {
		super(parent);

		var rgbImage:Image = Res.settings.palette.rgb;
		rgbBitmap = rgbImage.toBitmap();

		rgb = new Bitmap(rgbImage.toTile(), this);
		rgb.width = 300;
		rgb.height = 300;

		rgbPointer = new Bitmap(Res.settings.palette.rgbPointer.toTile(), this);

		rgbMult.set(rgbBitmap.width / rgb.width, rgbBitmap.height / rgb.height);

		rgbCollider = new Circle(0, 0, rgb.getSize().width / 2);

		var brtImage:Image = Res.settings.palette.brt;
		brtBitmap = brtImage.toBitmap();

		brt = new Bitmap(brtImage.toTile(), this);
		brt.x = rgb.x + rgb.getSize().width + 20;
		brt.width = 25;
		brt.height = 300;

		brtPointer = new Bitmap(Res.settings.palette.brtPointer.toTile(), this);
		brtPointer.width = 35;
		brtPointer.height = 10;

		brtMult.set(brtBitmap.width / brt.width, brtBitmap.height / brt.height);

		brtCollider = new Bounds();
		brtCollider.set(0, 0, brt.getSize().width, brt.getSize().height);
		// brtCollider = new PixelsCollider(brtBitmap.getPixels());

		display = new Bitmap(Tile.fromColor(0xffffffff, 50, 50), this);
		display.x = brt.x + brt.getSize().width + 20;
	}

	override function sync(ctx:RenderContext) {
		rgbCollider.x = rgb.x + rgbCollider.ray + this.x;
		rgbCollider.y = rgb.y + rgbCollider.ray + this.y;

		brtCollider.x = brt.x + this.x;
		brtCollider.y = brt.y + this.y;

		if (Key.isPressed(Key.MOUSE_LEFT)) {
			var mouseX:Float = Stage.getInstance().mouseX;
			var mouseY:Float = Stage.getInstance().mouseY;
			if (rgbCollider.contains(new Point(mouseX, mouseY)))
				current = RGB;

			if (brtCollider.contains(new Point(mouseX, mouseY)))
				current = BRT;
		}

		if (Key.isReleased(Key.MOUSE_LEFT))
			current = null;

		if (current != null && Key.isDown(Key.MOUSE_LEFT)) {
			trace(current);

			var mouseX:Float = Stage.getInstance().mouseX;
			var mouseY:Float = Stage.getInstance().mouseY;

			switch(current) {
				case RGB:
					var rgbPixel:Int = rgbBitmap.getPixel(Std.int((mouseX - rgb.x - this.x) * rgbMult.x), Std.int((mouseY - rgb.y - this.y) * rgbMult.y));
					if (rgbPixel != 0) {
						rgbVector = hex2rgb(rgbPixel);
						display.color.set(rgbVector.r * brtVector.r, rgbVector.g * brtVector.g, rgbVector.b * brtVector.b, 1);
						brt.color.set(rgbVector.r, rgbVector.g, rgbVector.b);

						rgbPointer.setPosition(Stage.getInstance().mouseX - rgbPointer.getSize().width / 2 - this.x, Stage.getInstance().mouseY - rgbPointer.getSize().height / 2 - this.y);
					}

				case BRT:
					var brtPixel:Int = brtBitmap.getPixel(Std.int((mouseX - brt.x - this.x) * brtMult.x), Std.int((mouseY - brt.y - this.y) * brtMult.y));
					if (brtPixel != 0) {
						brtVector = hex2rgb(brtPixel);
						display.color.r = rgbVector.r * brtVector.r;
						display.color.g = rgbVector.g * brtVector.g;
						display.color.b = rgbVector.b * brtVector.b;

						brtPointer.setPosition(brt.x - (brtPointer.getSize().width - brt.getSize().width) / 2, Stage.getInstance().mouseY - brtPointer.getSize().height / 2 - this.y);
					}
			}
		}
		
		super.sync(ctx);
	}

	static inline function hex2rgb(hex:Int):Vector {
		return new Vector(((hex >> 16) & 0xff) / 255, ((hex >> 8) & 0xff) / 255, (hex & 0xff) / 255);
	}
}