import haxe.io.Path;
#if sys
import sys.FileSystem;
#end
import openfl.media.Sound;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;

class Assets {
	public static inline function graphic(key:String):FlxGraphic {
		var graphic:FlxGraphic = FlxG.bitmap.get('image::$key');
		
		if (graphic == null)
			graphic = FlxG.bitmap.add('assets/images/$key.png', 'image::$key');

		return graphic;
	}

	public static inline function video(key:String):String {
		return 'assets/videos/$key.mp4';
	}

	/*public static inline function song(key:String):Sound {
		var sound:Sound = new Sound();
		#if sys
		var list:Array<String> = FileSystem.readDirectory('saved/songs/');
		for (i in 0...list.length) {
			var songName:String = list[i].substr(0, list[i].lastIndexOf('.'));
			if (songName == key) {
				retrace('Song found: ${list[i]}', GRAY);
				sound = Sound.fromFile('saved/songs/${list[i]}');
				break;
			}
		}
		#end
		return sound;
	}*/
}