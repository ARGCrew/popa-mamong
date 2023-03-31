package;

import hxAddons.HxBitmapSprite;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import openfl.display.BitmapData;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import vlc.MP4Handler;

class InitialState extends MusicBeatState
{
    var introSound:FlxSound;
    var intro:FlxSprite;
    var video:MP4Handler;

    override function create()
    {
        var menus:Array<Class<MusicBeatState>> = [
            CreditsState
        ];
        Settings.load();

        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
        FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.WHITE, 0.3, new FlxPoint(-1, 1),
			{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
        
        transIn = FlxTransitionableState.defaultTransIn;

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        add(bg);

        Paths.video('Intro');

/*
        intro = new FlxSprite().loadGraphic(FlxGraphic.fromBitmapData(BitmapData.fromFile(Paths.image('intro'))), true, 1920, 1080);
        var framesArray:Array<Int> = [];
        for (i in 0...intro.frames.frames.length)
            framesArray.push(i);
        intro.animation.add('intro', framesArray, 48, false);
        intro.animation.play('intro');
        intro.setGraphicSize(FlxG.width);
        intro.updateHitbox();
        add(intro);

        introSound = new FlxSound().loadEmbedded(Paths.sound('Intro')).play();
*/

        new FlxTimer().start(0.01, function(tmr:FlxTimer) {
            video = new MP4Handler();
            video.volume = Settings.masterVolume;
            video.finishCallback = function() {
                Tools.switchState(MainMenuState);
            }
            video.playVideo(Paths.video('Intro'));
        });

        FlxG.mouse.load(Paths.image('cursor/normal'));
        // FlxG.mouse.useSystemCursor = true;

    }

    override function update(elapsed:Float)
    {
        /*
        if (intro.animation.curAnim.finished) FlxG.switchState(new MainMenuState());
        introSound.volume = Settings.masterVolume;
        */

        super.update(elapsed);
    }
}
