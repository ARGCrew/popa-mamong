package arg.states;

import arg.objects.Note;
import arg.backend.Paths;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.addons.transition.FlxTransitionableState;

class PlayState extends FlxTransitionableState {
    public static var instance:PlayState;

    public var strumGrid:FlxSpriteGroup;

    override function create() {
        instance = this;

        strumGrid = new FlxSpriteGroup();

        var note:Note = new Note(new FlxSprite(Paths.image("notes/CIRCLE-strum")), 0, 0);
    }
}