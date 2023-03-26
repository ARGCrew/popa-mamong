package;

import flixel.FlxG;

class MenuButtonUse extends MusicBeatState
{
    override function create()
    {
        var button:MenuButton = new MenuButton(500, 400);
        button.loadBitmap(Paths.image('indicators/SQUARE'));
        button.onMouseOver = function() {
            FlxG.switchState(new PlayState());
        }
        add(button);
    }
}