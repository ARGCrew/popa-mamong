package sprites;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class StrumGrid extends FlxSpriteGroup {
    inline static var spaceX:Float = 30;
    inline static var spaceY:Float = 30;

    public var texture(default, set):String = "CIRCLE";

    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);

        for (i in 0...9) {
            var spr:FlxSprite = new FlxSprite();
            add(spr);
        }
        texture = "CIRCLE";
    }

    public function set_texture(value:String) {
        for (i in 0...9) {
            members[i].loadGraphic(Paths.image('notes/$texture-strum'));
            members[i].x = switch(i) {
                default: 0;
                case 1 | 4 | 7: spaceX + members[i].width;
                case 2 | 5 | 8: (spaceX + members[i].width) * 2;
            }
            members[i].y = switch(i) {
                default: 0;
                case 3 | 4 | 5: spaceY + members[i].height;
                case 6 | 7 | 8: (spaceY + members[i].height) * 2;
            }
        }
        return value;
    }
}