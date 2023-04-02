package;

import flixel.FlxG;
import flixel.FlxState;

class NoteOffsetState extends FlxState {
    var music:String;

    public function new(music:String) {
        super();
        this.music = music;

        if (FlxG.sound.music != null) {
            FlxG.sound.music.stop();
        }
        FlxG.sound.music = null;
        //FlxG.sound.playMusic(Paths.sound('music/$music.ogg'));
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.pressed.RIGHT) {
            FlxG.sound.music.time ++;
        }
        if (FlxG.keys.pressed.LEFT) {
        }
            FlxG.sound.music.time --;
        if (FlxG.keys.pressed.UP) {
            trace(FlxG.sound.music.time);
        }

        if (FlxG.keys.justPressed.ENTER) {
            FlxG.switchState(new PlayState());
        }

        super.update(elapsed);
    }
}