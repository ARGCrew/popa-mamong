package;

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
    var video:MP4Handler;

    override function create()
    {
        FlxG.save.bind("Volume", "ThatJustAVolumeGiveMeAAccessToTest");
        Settings.masterVolume = FlxG.sound.volume;

        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
        FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.WHITE, 0.3, new FlxPoint(-1, 1),
			{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
        
        transIn = FlxTransitionableState.defaultTransIn;

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        add(bg);

        Paths.video('Intro');

        new FlxTimer().start(0.01, function(tmr:FlxTimer) {
            video = new MP4Handler();
            video.readyCallback = function() {
                new FlxTimer().start(0.85, function(tmr:FlxTimer) {
                    native.WinAPI.setDarkMode(true);
                });
            }
            video.finishCallback = function() {
                FlxG.switchState(new MainMenuState());
            }
            video.playVideo(Paths.video('Intro'));
        });

        FlxG.mouse.load(BitmapData.fromFile(Paths.image('cursorlmao')));
        // FlxG.mouse.useSystemCursor = true;
    }

    override function update(elapsed:Float)
    {
        //video.volume = Settings.getSoundVolume();
        super.update(elapsed);
    }
}
