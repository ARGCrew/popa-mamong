package states;

import system.assets.Paths;
import flixel.addons.transition.FlxTransitionableState;
import system.video.VideoHandler;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class IntroState extends DaState {
    override function create() {
        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE));
        var player:VideoHandler = new VideoHandler();
        player.finishCallback = function() {
            FlxG.switchState(new TitleState());
        }
        player.canSkip = false;
        player.playVideo(Paths.video("Intro", true));
    }
}