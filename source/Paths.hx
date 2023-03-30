package;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.media.Sound;
import sys.FileSystem;

class Paths
{
    static var libs:Array<String> = [];
    static var lib:String = 'shared';

    public static function image(key:String)
    {
        return 'assets/images/$key.png';
    }

    public static function music(key:String)
    {
        return Sound.fromFile('assets/music/$key.ogg');
    }

    public static function sound(key:String)
    {
        return Sound.fromFile('assets/sounds/$key.ogg');
    }

    public static function hscript(key:String)
    {
        return 'assets/levels/$key.hx';
    }

    public static function video(key:String)
    {
        return 'assets/videos/$key.mp4';
    }

    public static function chart(name:String, diff:String)
    {
        return 'assets/charts/$name/$diff.json';
    }

    public static function sparrowAtlas(key:String)
    {
        return FlxAtlasFrames.fromSparrow(image(key), 'assets/images/$key.xml');
    }

    public static function font(key:String)
    {
        return 'assets/font/$key';
    }
}