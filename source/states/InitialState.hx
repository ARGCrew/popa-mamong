package states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import openfl.utils.Assets;
import flixel.graphics.FlxGraphic;
import system.controls.PlayerSettings;

class InitialState extends DaState {
    override function create() {
        DiscordClient.startSession();
        PlayerSettings.init(Numpad);
        FlxSprite.defaultAntialiasing = Preference.visuals.antialiasing;

        ModSystem.searchMods();
        for (mod in ModPaths.)

        var diamond:FlxGraphic = FlxGraphic.fromBitmapData(Assets.getBitmapData("embed/images/transition-diamond.png"));
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
        FlxTransitionableState.defaultTransIn = FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.WHITE, 0.3, new FlxPoint(-1, 1),
			{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
        
        FlxTransitionableState.skipNextTransOut = true;

        #if web
        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY));
        var text:FlxText = new FlxText("PRESS SPACE\nTO START");
        text.size = 64;
        text.alignment = CENTER;
        text.screenCenter();
        add(text);
        #else
        FlxG.switchState(new IntroState());
        #end
    }

    #if web
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE) {
            FlxG.switchState(new IntroState());
        }
    }
    #end
}