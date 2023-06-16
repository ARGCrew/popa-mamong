package states;

import states.substates.OutdatedSubState;
import lime.app.Application;
import utils.WebAPI;
import system.song.Song;
import system.assets.Paths;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;

class TitleState extends DaState {
    var logo:FlxSprite;

    override function create() {
        super.create();

        #if !TESTING
        WebAPI.request("https://raw.githubusercontent.com/h4master/another-rhythm-game/main/gitVersion.txt", {onData: function(data:String) {
            if (Application.current.meta["version"] != data)
                openSubState(new OutdatedSubState());
        }});
        #end

        openSubState(new OutdatedSubState());

        logo = new FlxSprite(Paths.image("titleLogo", true));
        logo.screenCenter();
        add(logo);
    }

    override function beatHit() {
        super.beatHit();

        if (curBeat % 2 == 0)
            logo.scale.set(1.1, 1.1);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        logo.scale.x = logo.scale.y = FlxMath.lerp(1, logo.scale.x, 0.95);

        if (controls.ACCEPT) {
            PlayState.SONG = Song.fromFile("data/songs/lost_error/normal.json");
            FlxG.switchState(new PlayState());
        }
    }
}