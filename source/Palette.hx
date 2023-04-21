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
    var indicatorsColor:String;
}

class Palette {
    public static var bg:FlxColor = 0x1A1A1A;
    public static var released:FlxColor = 0xFFFFFF;
    public static var pressed:FlxColor = 0xD64933;
    public static var confirmed:FlxColor = 0x00CC99;
    public static var indicators:FlxColor = 0xC7FFFFFF;

    public static function parse(file:String) {
        if (Paths.exists(file)) {
            var rawJson:String = Paths.getText(file);
            var json:PaletteFile = cast Json.parse(rawJson);
            bg = Std.parseInt(json.bgColor);
            released = Std.parseInt(json.releaseColor);
            pressed = Std.parseInt(json.pressColor);
            confirmed = Std.parseInt(json.confirmColor);
            indicators = Std.parseInt(json.indicatorsColor);
        }
    }
}