package arg.objects;

import arg.states.PlayState;
import flixel.math.FlxPoint;
import arg.backend.Paths;
import flixel.FlxSprite;

class Note extends FlxSprite {
    public var noteData:Int;
    public var strumTime:Float;
    public var noteType(default, set):String = "";

    public var texture(default, set):String = "CIRCLE";

    public function new(data:Int, time:Float, type:String = "") {
        super(Paths.image("notes/CIRCLE-note"));
        
        alpha = 0.2;
        scale.x = scale.y = 0;
        
        var coords:FlxPoint = PlayState.instance.strumGrid.members[data].getGraphicMidpoint();
        x = coords.x;
        y = coords.y;
    }

    public function set_noteType(value:String) {
        return noteType = value;
    }

    public function set_texture(value:String) {
        loadGraphic(Paths.image('notes/$texture-note'));
        return value;
    }

    override function update(elapsed:Float) {
        scale.x = scale.y = (Conductor.songPosition - (strumTime - PlayState.instance.songSpeed * 1000)) * (0.75 / 1000);
        
        super.update(elapsed);

        var coords:FlxPoint = PlayState.instance.strumGrid.members[data].getGraphicMidpoint();
        x = coords.x;
        y = coords.y;
    }
}