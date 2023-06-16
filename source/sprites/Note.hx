package sprites;

import utils.Conductor;
import system.assets.Paths;
import states.PlayState;
import flixel.FlxSprite;

class Note extends FlxSprite {
    public var noteData:Int;
    public var strumTime:Float;
    public var noteType(default, set):String = "";

    public var texture(default, set):String = "CIRCLE";

    public function new(data:Int, time:Float) {
        super();

        noteData = data;
        strumTime = time;
        
        alpha = 0.2;
        scale.x = scale.y = 0;
        
        var strum = PlayState.instance.strumGrid.members[noteData];
        x = strum.getGraphicMidpoint().x;
        y = strum.getGraphicMidpoint().y;
    }

    public function set_noteType(value:String) {
        switch(value) {
            default:
                texture = "CIRCLE";
        }

        return value;
    }

    public function set_texture(value:String) {
        loadGraphic(Paths.image('notes/$texture-note'));
        return value;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        var strum = PlayState.instance.strumGrid.members[noteData];
        x = strum.getGraphicMidpoint().x - (width / 2);
        y = strum.getGraphicMidpoint().y - (width / 2);

        scale.x = scale.y = (Conductor.songPosition - (strumTime - PlayState.instance.songSpeed * 1000)) * (0.75 / 1000);
    }
}