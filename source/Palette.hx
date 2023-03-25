package;

import sys.FileSystem;
import sys.io.File;
import flixel.util.FlxColor;

using StringTools;

class Palette
{
    public static var bg:FlxColor = 0xff000000;
    public static var released:FlxColor = 0xffFFFFFF;
    public static var pressed:FlxColor = 0xffFF0000;
    public static var confirmed:FlxColor = 0xff66FF33;

    public static function parse(file:String)
    {
        if (FileSystem.exists(file))
        {
            var array:Array<String> = File.getContent(file).split('\n');
            bg = Std.parseInt('0xff' + array[0]);
            
            var butts:Array<String> = array[1].split(' ');
            released = Std.parseInt('0xff' + butts[0]);
            pressed = Std.parseInt('0xff' + butts[1]);
            confirmed = Std.parseInt('0xff' + butts[2]);
        }
    }
}