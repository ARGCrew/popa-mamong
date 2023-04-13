package;

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