import arg.backend.Utils;
import openfl.display.BitmapData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import openfl.events.Event;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;

class Main {
    static function main() {
        Lib.current.addChild(new FlxGame(1920, 1080, arg.states.MainMenuState));
        FlxG.stage.addEventListener(Event.ENTER_FRAME, enterFrame);

        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
        var data:TransitionData = new TransitionData(TILES, FlxColor.WHITE, 0.3, new FlxPoint(-1, 1),
			{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
        
        FlxTransitionableState.defaultTransIn = data;
        FlxTransitionableState.defaultTransOut = data;
        FlxTransitionableState.skipNextTransOut = true;
    }

    static function enterFrame(?e:Event) {
        var bitmapData:BitmapData = new BitmapData(FlxG.stage.stageWidth, FlxG.stage.stageHeight);
        bitmapData.draw(FlxG.stage);
        Utils.changeWindowColor(0xffFFC0CB);
    }
}