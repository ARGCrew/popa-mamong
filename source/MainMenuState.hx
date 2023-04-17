package;

import flixel.util.FlxTimer;
import openfl.filters.GlowFilter;
import openfl.display.BitmapData;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxObject;
import MenuButton.MenuLine;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;

class MainMenuState extends MusicBeatState {
    var mouseEvent:FlxMouseEventManager;

    var optionShit:Array<String> = [
        'play',
        'settings',
        'credits'
    ];
    var grpOptions:FlxTypedGroup<MenuButton>;

    public static var curSelected:Int = 0;
    var daChoiced:Bool = false;

    public static var funnyNumpad:Bool = true;

    var logo:FlxSprite;

    function onMouseDown(object:FlxObject) {
        select();
    }

    function onMouseOver(object:FlxObject) {
        for (i in 0...optionShit.length) {
            if (object == grpOptions.members[i]) {
                changeSelection(i, true);
            }
        }
    }

    function onMouseOut(object:FlxObject) {
        for (i in 0...optionShit.length) {
            if (object == grpOptions.members[i]) {
                changeSelection(-100, true);
            }
        }
    }

    override public function create() {
        #if desktop
        changePresence("Main Menu", null);
        #end
        
        mouseEvent = new FlxMouseEventManager();
        add(mouseEvent);

        grpOptions = new FlxTypedGroup<MenuButton>();
        add(grpOptions);

        for (i in 0...optionShit.length) {
            var itemOffsetX = (15 + (80 * i)) * 1.5;
            var itemOffsetY = FlxG.height / 3 + (BitmapData.fromFile(Paths.image('menu/Buttonb')).height * 1.125) * i;

            var line:MenuLine = new MenuLine(itemOffsetX, itemOffsetY);
            add(line);

            var button:MenuButton = new MenuButton(itemOffsetX, itemOffsetY);
            button.loadGraphic(Paths.image('menu/${optionShit[i].toUpperCase()}'));
            button.scale.set(0.6, 0.6);
            button.updateHitbox();
            button.alpha = 0.4;
            grpOptions.add(button);
            mouseEvent.add(button, onMouseDown, null, onMouseOver, onMouseOut);

            line.targetSprite = button;
        }

        logo = new FlxSprite().loadGraphic(Paths.image('rhythmLogo'));
        logo.scale.set(0.7, 0.7);
        logo.updateHitbox();
        logo.screenCenter();
        logo.x += FlxG.width / 4;
        add(logo);

        persistentDraw = persistentUpdate = true;

        new FlxTimer().start(0.3, function(tmr:FlxTimer) {
            if (funnyNumpad) {
                //funnyNumpad = false;
                openSubState(new NumpadCheckSubState());
            }
        });

        super.create();
    }

    public function new() {
        super();

        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
        diamond.persist = true;
        diamond.destroyOnNoUse = false;
        FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.WHITE, 0.3, new FlxPoint(-1, 1),
            {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

        transOut = FlxTransitionableState.defaultTransOut;
    }

    override function update(elapsed:Float) {
        if (controls.UP_P) {
            changeSelection(-1);
        }
        if (controls.DOWN_P) {
            changeSelection(1);
        }
        if (controls.ACCEPT) {
            select();
        }

        super.update(elapsed);
    }

    function select() {
        if (!daChoiced && !funnyNumpad) {
            daChoiced = true;
            switch(optionShit[curSelected]) {
                case 'play': FlxG.switchState(new PlayState());
                case 'settings': FlxG.switchState(new SettingsState(false));
                case 'credits': FlxG.switchState(new CreditsState());
                default: daChoiced = false;
            }
        }
    }

    function changeSelection(step:Int = 0, force:Bool = false) {
        if (!funnyNumpad) {
            force ? {
                curSelected = step;
            } : {
                curSelected += step;
                curSelected = Utils.int.boundTo(curSelected, 0, optionShit.length - 1, true);
            }
    
            for (i in 0...grpOptions.members.length) {
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
}