package;

import flixel.group.FlxSpriteGroup;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import flixel.FlxObject;
import flixel.input.mouse.FlxMouseEventManager;
import hxAddons.HxBitmapSprite;
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
    var mouseEvent:FlxMouseEventManager;

    var optionShit:Array<String> = [
        'play',
        'options'
    ];
    var grpOptions:FlxSpriteGroup;

    function onMouseDown(object:FlxObject)
    {
        for (i in 0...optionShit.length)
        {
            if (object == grpOptions.members[i])
            {
                switch(optionShit[i].toLowerCase())
                {
                    case 'play':
                        Tools.switchState(PlayState);
                    case 'options':
                        Tools.switchState(Settings.SetState, [false]);
                }
            }
        }
    }

    function onMouseOver(object:FlxObject)
    {
        for (i in 0...optionShit.length)
            if (object == grpOptions.members[i])
                grpOptions.members[i].alpha = 1;
    }

    function onMouseOut(object:FlxObject)
    {
        for (i in 0...optionShit.length)
            if (object == grpOptions.members[i])
               grpOptions.members[i].alpha = 0.4;
    }

    override public function create()
    {
        mouseEvent = new FlxMouseEventManager();
        add(mouseEvent);

        grpOptions = new FlxSpriteGroup();
        add(grpOptions);

        for (i in 0...optionShit.length)
        {
            var offset:Float = FlxG.height / 3 + (new Bitmap(BitmapData.fromFile(Paths.image('menu/Buttonb'))).height * 0.75) * i;

            var button:HxBitmapSprite = new HxBitmapSprite(15, offset).loadBitmap(Paths.image('menu/Buttonb'));
            button.scale.set(0.4, 0.4);
            button.updateHitbox();
            button.alpha = 0.4;
            grpOptions.add(button);
            mouseEvent.add(button, onMouseDown, null, onMouseOver, onMouseOut);

            var text:FlxText = new FlxText(0, 0, button.width, optionShit[i].toUpperCase());
            text.setFormat(Paths.font('Nord-Star-Deco.ttf'), 32, FlxColor.BLACK);
            text.x = button.x + button.width / 2 - text.fieldWidth / 4;
            text.y = button.y + button.height / 2 - text.height / 2;
            add(text);
        }

        super.create();
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

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new InitialState());

        super.update(elapsed);
    }
}