package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import flixel.FlxG;

class CreditsState extends MusicBeatState
{
    var creditShit:Array<CreditMetaData> = [
        new CreditMetaData("h4mster", "", "Programmer"),
        new CreditMetaData("Funduk", "", "Artits")
    ];
    
    override function create()
    {
        for (i in 0...creditShit.length)
        {
            var data = creditShit[i];

            var itemOffsetX = 15 + (80 * i);
            var itemOffsetY = FlxG.height / 3 + (new Bitmap(BitmapData.fromFile(Paths.image('menu/Buttonb'))).height * 0.75) * i;

            var optionText:FlxText = new FlxText(itemOffsetX, itemOffsetY, FlxG.width / 2, data.name);
            optionText.setFormat(Paths.font, 32, FlxColor.WHITE);
            add(optionText);
        }
    }
}

class CreditMetaData
{
    public var name:String;
    public var image:String;
    public var description:String;

    public function new(Name:String, Image:String, Description:String)
    {
        name = Name;
        image = Image;
        description = Description;
    }
}