package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class TicTacToe extends MusicBeatState
{
    var butts:FlxTypedGroup<FlxSprite>;

    override function create()
    {
        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, Palette.bg));

        butts = new FlxTypedGroup<FlxSprite>();
        add(butts);
        for (i in 0...9) {
            add(new Button(i, Settings.skin));
        }
    }

    override function update(elapsed:Float)
    {
        
    }
}