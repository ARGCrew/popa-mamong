package;

import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;

class MainMenuState extends MusicBeatState
{
    override public function create()
    {
        var cooltext = new FlxText("Welcome to menu... yea...
                so...");
        cooltext.screenCenter();
        add(cooltext);
    }

    public function new()
    {
        super();

        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
        diamond.persist = true;
        diamond.destroyOnNoUse = false;
        FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.WHITE, 0.3, new FlxPoint(-1, 1),
            {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

        transOut = FlxTransitionableState.defaultTransOut;
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ENTER)
            FlxG.switchState(new PlayState());
    }
}