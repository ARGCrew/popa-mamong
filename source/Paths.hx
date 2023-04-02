package;

#if sys
import sys.FileSystem;
#else
import lime.utils.Assets;
#end

import flash.media.Sound;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;

class Paths
{
    static var libs:Array<String> = [];
    static var lib:String = 'shared';

    static var images:FileMap = new FileMap();
    static var sounds:FileMap = new FileMap();

    static var sound_extension:String = #if web "mp3" #else "ogg" #end;

    public static function image(key:String):FlxGraphic {
        var path:String = 'assets/images/$key.png';

        var bitmapData:BitmapData = null;
        var graphic:FlxGraphic = null;

        if (images.exists(path) && images.get(path) != null)
            return images.get(path);

        if (exists(path)) {
            bitmapData = BitmapData.fromFile(path);
            graphic = FlxGraphic.fromBitmapData(bitmapData);
        }
        images.set(path, graphic);

        return images.get(path);
    }

    public static function music(key:String):Sound {
        var path:String = 'assets/music/$key.$sound_extension';

        var sound:Sound = null;

        if (sounds.exists(path) && sounds.get(path) != null)
            return sounds.get(path);

        if (exists(path)) {
            sound = Sound.fromFile(path);
        }
        sounds.set(path, sound);

        return sounds.get(path);
    }

    public static function sound(key:String):Sound {
        var path:String = 'assets/sounds/$key.$sound_extension';

        var sound:Sound = null;

        if (sounds.exists(path) && sounds.get(path) != null)
            return sounds.get(path);

        if (exists(path)) {
            sound = Sound.fromFile(path);
        }
        sounds.set(path, sound);

        return sounds.get(path);
    }

    public static var font:String = "assets/font/Nord-Star-Deco.ttf";

    public static function video(key:String) {
        return 'assets/videos/$key.mp4';
    }

    public static function hscript(key:String) {
        return 'assets/levels/$key.hx';
    }

    public static function chart(name:String, diff:String) {
        return 'assets/charts/$name/$diff.json';
    }

    public static function exists(key:String) {
        return (#if sys FileSystem #else Assets #end .exists(key));
    }
}

typedef MappedFile = flixel.util.typeLimit.OneOfTwo<FlxGraphic, Sound>;

class FileMap {
    private var keys:Array<String> = [];
    private var files:Array<MappedFile> = [];

    public function new() {}

    public function set(key:String, file:MappedFile) {
        if (keys.contains(key)) {
            var index:Int = keys.indexOf(key);
            files[index] = file;
        }
        else {
            keys.push(key);
            files.push(file);
        }
    }

    public function get(key:String) {
        var index:Int = keys.indexOf(key);
        return files[index];
    }

    public function exists(key:String) {
        for (i in keys) {
            if (i == key) {
                return true;
            }
        }

        return false;
    }
}