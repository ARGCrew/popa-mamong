package;

import UIButtons.UIButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;

class NoteOffsetState extends MusicBeatState {
    var music:String;

    var butts:ButtonGrid;

    var paused:Bool = true;
    var mult:Int = 1;

    var curID:Int = 0;

    public function new(music:String) {
        super();
        FlxG.sound.playMusic(Paths.music(music));
        FlxG.sound.music.pause();
    }

    override function create() {
        butts = new ButtonGrid(-(FlxG.width / 5));
        add(butts);

        var butt:UIButton = new UIButton((FlxG.width / 6) * 5, FlxG.height / 2, "CUM");
        butt.onPress = function() {
            lime.app.Application.current.window.alert("CUM", "CUM");
        }
        add(butt);

        var line:FlxSprite = new FlxSprite((FlxG.width / 3) * 2, FlxG.height / 3).makeGraphic(Std.int(FlxG.width / 4), 5, FlxColor.WHITE);
        add(line);

        super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.pressed.SHIFT) {
            mult = 10;
        } else {
            mult = 1;
        }

        if (FlxG.keys.justPressed.SPACE) {
            paused = !paused;

            paused ? {
                FlxG.sound.music.pause();
            } : {
                FlxG.sound.music.resume();
            }
        }

        if (FlxG.keys.justPressed.ESCAPE) {
            FlxG.switchState(new PlayState());
        }

        if (FlxG.keys.pressed.LEFT) {
            paused = true;

            paused ? {
                FlxG.sound.music.pause();
            } : {
                FlxG.sound.music.resume();
            }

            FlxG.sound.music.time -= 100 * mult;
        }
        if (FlxG.keys.pressed.RIGHT) {
            paused = true;

            paused ? {
                FlxG.sound.music.pause();
            } : {
                FlxG.sound.music.resume();
            }

            FlxG.sound.music.time += 100 * mult;
        }

        super.update(elapsed);
    }
}