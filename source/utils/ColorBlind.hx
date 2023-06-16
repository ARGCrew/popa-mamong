package utils;

import openfl.filters.ColorMatrixFilter;
import openfl.filters.BitmapFilter;
import flixel.FlxG;

class ColorBlind {
    static var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}> = [
        "Deuteranopia" => {
			var matrix:Array<Float> = [
				0.43, 0.72, -.15, 0, 0,
				0.34, 0.57, 0.09, 0, 0,
				-.02, 0.03,    1, 0, 0,
				   0,    0,    0, 1, 0,
			];

			{filter: new ColorMatrixFilter(matrix)}
		},
		"Protanopia" => {
			var matrix:Array<Float> = [
				0.20, 0.99, -.19, 0, 0,
				0.16, 0.79, 0.04, 0, 0,
				0.01, -.01,    1, 0, 0,
				   0,    0,    0, 1, 0,
			];

			{filter: new ColorMatrixFilter(matrix)}
		},
		"Tritanopia" => {
			var matrix:Array<Float> = [
				0.97, 0.11, -.08, 0, 0,
				0.02, 0.82, 0.16, 0, 0,
				0.06, 0.88, 0.18, 0, 0,
				   0,    0,    0, 1, 0,
			];

			{filter: new ColorMatrixFilter(matrix)}
		}
    ];

    public var mode(default, set):String;

    public function new() {}

    public function load() {
        if (FlxG.save != null && FlxG.save.data.colorBlindMode != null)
            mode = FlxG.save.data.colorBlindMode;
        else mode = "None";

        return this;
    }

    public function set_mode(value:String) {
        if (value == "None") FlxG.game.setFilters([]);
        else {
            if (filterMap.exists(value)) {
                var filter = filterMap[value].filter;
                if (filter != null) FlxG.game.setFilters([filter]);
            }
        }
		FlxG.save.data.colorBlindMode = value;

        return value;
    }
}