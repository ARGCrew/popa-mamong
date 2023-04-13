package;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class UIButton extends FlxSpriteGroup {
    var background:FlxSprite;
    var text:FlxText;

    var bgTween:FlxTween;

    public var onPress:()->Void = null;

    public function new(x:Float = 0, y:Float = 0, string:String) {
        super(x, y);

        background = new FlxSprite().makeGraphic(100, 45, FlxColor.WHITE);
        background.alpha = 0.1;
        add(background);

        text = new FlxText(0, 0, background.width, string, 8);
        text.setFormat(Paths.font, 32, FlxColor.BLACK, CENTER, OUTLINE, FlxColor.TRANSPARENT);
        add(text);
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(background)) {
            bgTween = FlxTween.tween(background, {alpha: 0.3}, 0.05, {onComplete: function(twn:FlxTween) {
                bgTween = null;
            }});
            if (FlxG.mouse.justPressed && onPress != null) {
                onPress();
            }
        } else {
            bgTween = FlxTween.tween(background, {alpha: 0.1}, 0.05, {onComplete: function(twn:FlxTween) {
                bgTween = null;
            }});
        }
        super.update(elapsed);
    }
}

class UIInputText extends FlxSpriteGroup {
    public function new(x:Float = 0, y:Float = 0, text:String) {
        super(x, y);
    }
}