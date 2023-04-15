package;

import haxe.Json;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets as LimeAssets;

import flixel.util.FlxColor;

using StringTools;

typedef PaletteFile =  {
    var bgColor:String;
    var releaseColor:String;
    var pressColor:String;
    var confirmColor:String;
}

class Palette {
    public static var bg:FlxColor = 0xff1A1A1A;
    public static var released:FlxColor = 0xffFFFFFF;
    public static var pressed:FlxColor = 0xffD64933;
    public static var confirmed:FlxColor = 0x00CC99;

    public static function parse(file:String) {
        if (#if sys FileSystem #else OpenFlAssets #end .exists(file)) {
            var rawJson:String = #if sys File.getContent #else LimeAssets.getText #end (file);
            var json:PaletteFile = cast Json.parse(rawJson);
            bg = Std.parseInt('0xff' + json.bgColor);
            released = Std.parseInt('0xff' + json.releaseColor);
            pressed = Std.parseInt('0xff' + json.pressColor);
            confirmed = Std.parseInt('0xff' + json.confirmColor);
        }
    }
}