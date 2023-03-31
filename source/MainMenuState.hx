package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import flixel.FlxObject;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;

class MainMenuState extends MusicBeatState
{
    var mouseEvent:FlxMouseEventManager;

    var optionShit:Array<Array<Dynamic>> = [
        ['play', null, PlayState],
        ['settings', [false], SettingsState],
        ['credits', null, CreditsState]
    ];
    var grpOptions:FlxTypedGroup<MenuButton>;

    static var curSelected:Int = 0;
    var daChoiced:Bool = false;

    var itemStartPoses:Array<Float> = [];

    function onMouseDown(object:FlxObject)
    {
        select();
    }

    function onMouseOver(object:FlxObject)
    {
        for (i in 0...optionShit.length)
            if (object == grpOptions.members[i])
                changeSelection(i, true);
    }

    function onMouseOut(object:FlxObject)
    {
        for (i in 0...optionShit.length)
            if (object == grpOptions.members[i])
                changeSelection(-100, true);
    }

    override public function create()
    {
        mouseEvent = new FlxMouseEventManager();
        add(mouseEvent);

        grpOptions = new FlxTypedGroup<MenuButton>();
        add(grpOptions);

        for (i in 0...optionShit.length)
        {
            var itemOffsetX = 15 + (80 * i);
            var itemOffsetY = FlxG.height / 3 + (new Bitmap(BitmapData.fromFile(Paths.image('menu/Buttonb'))).height * 0.75) * i;

            var line:OhLine = new OhLine(itemOffsetX, itemOffsetY);
            line.loadBitmap(Paths.image('menu/jstfknln'));
            line.scale.set(0.4, 0.4);
            line.updateHitbox();
            line.alpha = 0.4;
            add(line);

            var button:MenuButton = new MenuButton(itemOffsetX, itemOffsetY);
            button.loadBitmap(Paths.image('menu/${optionShit[i][0].toUpperCase()}'));
            button.scale.set(0.4, 0.4);
            button.updateHitbox();
            button.alpha = 0.4;
            grpOptions.add(button);
            mouseEvent.add(button, onMouseDown, null, onMouseOver, onMouseOut);

            line.targetSprite = button;
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

        if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP)
            changeSelection(-1);
        if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN)
            changeSelection(1);
        if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
            select();

        super.update(elapsed);
    }

    function mouseOverlaps(obj:FlxSprite)
    {
        var mos = FlxG.mouse;

        if (mos.x > obj.x && mos.x < obj.x + obj.width
            && mos.y > obj.y && mos.y < obj.y + obj.height)
            return true;
        
        return false;
    }

    function select()
    {
        if (!daChoiced)
        {
            daChoiced = true;
            var daState = optionShit[curSelected][2];
            Tools.switchState(daState, optionShit[curSelected][1]);
        }
    }

    function changeSelection(step:Int = 0, force:Bool = false)
    {
        force ? {
            curSelected = step;
        } : {
            curSelected != -100 ? {
                curSelected += step;
                if (curSelected > optionShit.length - 1)
                    curSelected = 0;
                if (curSelected < 0)
                    curSelected = optionShit.length - 1;
            } : {
                curSelected = 0;
            }
        }

        for (i in 0...grpOptions.members.length)
        {
            var spr = grpOptions.members[i];
        
            curSelected == i ? {
                spr.alpha = 1;
                spr.moveTween = FlxTween.tween(spr, {x: spr.offsetX + 10}, 0.2, {ease: FlxEase.sineOut});
            } : {
                spr.alpha = 0.4;
                spr.moveTween = FlxTween.tween(spr, {x: spr.offsetX}, 0.2, {ease: FlxEase.sineOut});
            }
        }
    }
}