package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

typedef EventMap = {
    var time:Float;

    var name:String;
    var value1:String;
    var value2:String;
    var value3:String;
}

typedef NoteMap = {
    var time:Float;
    var id:Int;
}

class Note extends FlxSprite {
    public var time:Float;
    public var id:Int;

    public var spawned:Bool = false;
    public var strumTime:Float = 0;

    public var skin:String = 'square';

    public function new(time:Float, id:Int) {
        super();
        this.time = time;
        this.id = id;

        skin = Settings.skin;
        loadGraphic(Paths.image('indicators/${skin.toUpperCase()}'));
        alpha = 0.4;
    }

    override function update(elapsed:Float) {
        var button = PlayState.instance.butts.members[id];

        x = button.x + button.width / 2 - width / 2;
        y = button.y + button.height / 2 - height / 2;
        updateHitbox();

        super.update(elapsed);
    }
}

class NoteTween {
    var note:Note;
    var value:Float;
    var speed:Float;
    var onComplete:()->Void;

    var spawnOffset:Float = 0;

    public function new(note:Note, value:Float, speed:Float, onComplete:()->Void = null) {
        this.note = note;
        this.value = value;
        this.speed = speed;
        this.onComplete = onComplete;

        spawnOffset = FlxG.sound.music.time;

        FlxTween.tween(note.scale, {x: value, y: value}, speed, {onComplete: function(twn:FlxTween) {
            if (onComplete != null) {
                onComplete();
            }
        }});
    }

    public function update(elapsed:Float) {
        /*
        var songPos:Float = Conductor.songPosition - spawnOffset;
        var notePos:Float = note.time - spawnOffset;
        note.scale.x = note.scale.y = ((songPos / notePos) * 0.75) / speed;
        */
    }
}

class ChartNote extends FlxSprite {
    public var hitable:Bool = true;

    public function new(time:Float, id:Int) {
        super();
        makeGraphic(5, 10, FlxColor.WHITE);
    }

    public function hit() {
        alpha = 0.4;
        hitable = false;
    }
    public function unhit() {
        alpha = 1;
        hitable = true;
    }
}