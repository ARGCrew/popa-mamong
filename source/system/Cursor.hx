package system;

import flixel.FlxG;
import openfl.utils.Assets;
import openfl.display.Bitmap;

enum CursorType {
    NORMAL;
    TYPING;
}

class Cursor extends Bitmap {
    public var type(default, set):CursorType;

    var offset:Dynamic = {
        x: 0.0,
        y: 0.0
    };

    public var typing(default, set):Bool = false;

    public function new() {
        super();
        type = NORMAL;
    }

    public function set_type(value:CursorType) {
        bitmapData = Paths.image("cursor/" + Std.string(value).toLowerCase(), true);

        switch(value) {
            case NORMAL:
                offset.x = offset.y = 0;
            case TYPING:
                offset.x = width / 2;
                offset.y = height / 4;
        }
        return value;
    }

    public function set_typing(value:Bool) {
        type = value ? TYPING : NORMAL;
        return value;
    }

    override function __enterFrame(deltaTime:Int) {
        super.__enterFrame(deltaTime);

        typing = FlxG.keys.pressed.CONTROL;

        FlxG.mouse.visible = false;
        x = FlxG.game.mouseX - offset.x;
        y = FlxG.game.mouseY - offset.y;
    }
}