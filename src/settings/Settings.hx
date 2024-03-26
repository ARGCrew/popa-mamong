package settings;

import h2d.Scene;

class Settings extends Scene {
	var palette:Palette;

	public function new() {
		super();

		palette = new Palette(this);
		palette.setPosition(450, 200);
	}
}