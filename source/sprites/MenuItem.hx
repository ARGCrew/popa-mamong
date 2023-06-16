package sprites;

import system.assets.Paths;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class MenuItem extends FlxSpriteGroup {
    private var button:FlxSprite;

    public var onPress:()->Void;

    public function new(x:Float = 0, y:Float = 0, name:String) {
        super(x, y);

        button = new FlxSprite().loadGraphic(Paths.image("mainmenu/button_" + name.toUpperCase(), true));
        add(button);
    }

    public function press() {
        if (onPress != null) onPress();
    }
}