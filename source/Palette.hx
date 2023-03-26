package;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import flixel.util.FlxColor;

using StringTools;

typedef PaletteFile = 
{
    var bgColor:String;
    var releaseColor:String;
    var pressColor:String;
    var confirmColor:String;
}

class Palette
{
    public static var bg:FlxColor = 0xff000000;
    public static var released:FlxColor = 0xffFFFFFF;
    public static var pressed:FlxColor = 0xffD64933;
    public static var confirmed:FlxColor = 0x00CC99;

    public static function parse(file:String)
    {
        if (FileSystem.exists(file))
        {
            var rawJson:String = File.getContent(file);
            var json:PaletteFile = cast Json.parse(rawJson);
            bg = Std.parseInt('0xff' + json.bgColor);
            released = Std.parseInt('0xff' + json.releaseColor);
            pressed = Std.parseInt('0xff' + json.pressColor);
            confirmed = Std.parseInt('0xff' + json.confirmColor);
        }
    }
}