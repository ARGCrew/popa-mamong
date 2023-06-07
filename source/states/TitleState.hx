package states;

import system.song.Song;
import flixel.math.FlxMath;
import flixel.FlxG;
import system.assets.ModSystem;

import flixel.FlxSprite;

class TitleState extends DaState {
    var logo:FlxSprite;

    override function create() {
        super.create();

        logo = new FlxSprite(Paths.image("rhythmLogo"));
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