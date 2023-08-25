package arg.backend;

import openfl.display.BitmapData;

#if windows
@:buildXml('
<target id="haxe">
    <lib name="dwmapi.lib" if="windows" />
</target>
')

@:cppFileCode('
    #include <dwmapi.h>
')
#end

class Utils {
    public static function dominantColor(bitmap:BitmapData):Int {
		var countByColor:Map<Int, Int> = [];
		for (x in 0...bitmap.width) {
			for (y in 0...bitmap.height) {
			  var colorOfThisPixel:Int = bitmap.getPixel32(x, y);
			  if (colorOfThisPixel != 0) {
				  if (countByColor.exists(colorOfThisPixel))
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  else if (countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
					 countByColor[colorOfThisPixel] = 1;
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if (countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

    #if windows
    @:functionCode('
        DwmSetWindowAttribute(GetActiveWindow(), DWMWA_BORDER_COLOR, &color, sizeof(color));
    ')
    #end
    public static function changeWindowColor(color:Int) {}
}