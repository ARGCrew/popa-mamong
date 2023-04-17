package;

import flixel.graphics.frames.FlxAtlasFrames;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import lime.utils.Assets;
import openfl.Assets as OpenFlAssets;
#end

import flash.media.Sound;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;

class Paths
{
    static var libs:Array<String> = [];
    static var lib:String = 'shared';
/*
    static var images:FileMap = new FileMap();
    static var sounds:FileMap = new FileMap();
*/

    static var images:ImageMap = new ImageMap();
    static var sounds:SoundMap = new SoundMap();

    public static var currentMod:String = "daMod";

    static var image_extensions:Array<String> = ["png", "jpg", "jpeg"];
    static var sound_extensions:Array<String> = ["ogg", "mp3"];
    static var video_extensions:Array<String> = ["mp4", "webm"]; 

    public static function image(key:String):Dynamic {
        var path:String = 'assets/images/$key';

/*
        for (extension in image_extensions) {
            if (!exists(path)) {
                if (exists('$path.$extension')) {
                    path = '$path.$extension';
                }
            }
        }

        return path;
*/
/*
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
*/

        for (extension in image_extensions) {
            if (!exists(path)) {
                if (exists('$path.$extension')) {
                    path = '$path.$extension';
                    return path;
                }
            }
        }

        if (!exists(path)) {
            path =  'mods/images/$key';

            for (extension in image_extensions) {
                if (!exists(path)) {
                    if (exists('$path.$extension')) {
                        path = '$path.$extension';
                        return FlxGraphic.fromBitmapData(BitmapData.fromFile(path));
                    }
                }
            }
        }

        if (!exists(path)) {
            path =  'mods/$currentMod/images/$key';

            for (extension in image_extensions) {
                if (!exists(path)) {
                    if (exists('$path.$extension')) {
                        path = '$path.$extension';
                        return FlxGraphic.fromBitmapData(BitmapData.fromFile(path));
                    }
                }
            }
        }

        return null;
    }

    public static function file(key:String):Dynamic {
        var path:String = 'assets/$key';

        if (!exists(path)) {
            path = 'mods/$key';
        }
        
        if (!exists(path)) {
            path = 'mods/$currentMod/$key';
        }

        return path;
    }

    public static function sparrowAtlas(key:String) {
        var image = image(key);
        var xml = file('images/$key.xml');

        return FlxAtlasFrames.fromSparrow(image, xml);
    }

    public static function music(key:String) {
        var path:String = 'assets/music/$key';

        for (extension in sound_extensions) {
            if (!exists(path)) {
                if (exists('$path.$extension')) {
                    path = '$path.$extension';
                }
            }
        }
/*
        var sound:Sound = null;

        if (sounds.exists(path) && sounds.get(path) != null)
            return sounds.get(path);

        if (exists(path)) {
            sound = Sound.fromFile(path);
        }
        sounds.set(path, sound);

        return sounds.get(path);
*/
        return path;
    }

    public static function sound(key:String) {
        var path:String = 'assets/sounds/$key';
/*
        for (extension in sound_extensions) {
            if (!exists(path)) {
                if (exists('$path.$extension')) {
                    path = '$path.$extension';
                }
            }
        }

        return path;
*/
/*
        var sound:Sound = null;

        if (sounds.exists(path) && sounds.get(path) != null)
            return sounds.get(path);

        if (exists(path)) {
            sound = Sound.fromFile(path);
        }
        sounds.set(path, sound);

        return sounds.get(path);
*/

        for (extension in image_extensions) {
            if (!exists(path)) {
                if (exists('$path.$extension')) {
                    path = '$path.$extension';
                    return path;
                }
            }
        }

        if (!exists(path)) {
            path = 'mods/sounds/$key';

            for (extension in image_extensions) {
                if (!exists(path)) {
                    if (exists('$path.$extension')) {
                        path = '$path.$extension';
                        return path;
                    }
                }
            }
        }

        if (!exists(path)) {
            path = 'mods/$currentMod/$key';

            for (extension in image_extensions) {
                if (!exists(path)) {
                    if (exists('$path.$extension')) {
                        path = '$path.$extension';
                        return path;
                    }
                }
            }
        }

        return null;
    }

    public static var font:String = "assets/font/Nord-Star-Deco.ttf";

    public static function video(key:String) {
        var path:String = 'assets/videos/$key';
/*
        for (extension in video_extensions) {
            if (!exists(path)) {
                if (exists('$path.$extension')) {
                    path = '$path.$extension';
                }
            }
        }

        return path;
*/

        for (extension in video_extensions) {
            if (!exists(path)) {
                if (exists('$path.$extension')) {
                    path = '$path.$extension';
                }
            }
        }

        if (!exists(path)) {
            path = 'mods/videos/$key';

            for (extension in video_extensions) {
                if (!exists(path)) {
                    if (exists('$path.$extension')) {
                        path = '$path.$extension';
                    }
                }
            }
        }

        if (!exists(path)) {
            path = 'mods/$currentMod/videos/$key';

            for (extension in video_extensions) {
                if (!exists(path)) {
                    if (exists('$path.$extension')) {
                        path = '$path.$extension';
                    }
                }
            }
        }

        return path;
    }

    public static function hscript(key:String, folder:String) {
        return 'assets/levels/$key.hx';

        var path:String = 'assets/$folder/$key.hx';

        if (!exists(path)) {
            path = 'mods/$folder/$key.hx';
        }

        if (!exists(path)) {
            path = 'mods/$currentMod/$folder/$key.hx';
        }
    }

    public static function chart(name:String, diff:String) {
        return 'assets/charts/$name/$diff.json';

        var path:String = 'assets/charts/$name/$diff.json';

        if (!exists(path)) {
            path = 'mods/charts/$name/$diff.json';
        }

        if (!exists(path)) {
            path = 'mods/$currentMod/harts/$name/$diff.json';
        }
    }

    public static function exists(key:String) {
        return (#if sys FileSystem #else Assets #end .exists(key));
    }

    public static function getText(key:String) {
        return #if sys File.getContent #else Assets.getText #end (key);
    }
}

class ImageMap {
    private var keys:Array<String> = [];
    private var images:Array<BitmapData> = [];

    public function new() {}

    public function set(key:String, image:BitmapData) {
        if (keys.contains(key)) {
            var index = keys.indexOf(key);
            images[index] = image;
        } else {
            keys.push(key);
            images.push(image);
        }
    }

    public function get(key:String) {
        var index = keys.indexOf(key);
        return images[index];
    }

    public function exists(key:String) {
        return keys.contains(key);
    }
}

class SoundMap {
    private var keys:Array<String> = [];
    private var sounds:Array<Sound> = [];

    public function new() {}

    public function set(key:String, image:Sound) {
        if (keys.contains(key)) {
            var index = keys.indexOf(key);
            sounds[index] = image;
        } else {
            keys.push(key);
            sounds.push(image);
        }
    }

    public function get(key:String) {
        var index = keys.indexOf(key);
        return sounds[index];
    }

    public function exists(key:String) {
        return keys.contains(key);
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