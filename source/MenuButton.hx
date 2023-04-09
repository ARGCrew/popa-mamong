package;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class MenuLine extends FlxSprite {
    public var targetSprite:MenuButton = null;

    public function new(X:Float = 0, Y:Float = 0) {
        super(X, Y);
        loadGraphic(Paths.image('menu/jstfknln'));
        scale.set(0.4, 0.4);
        updateHitbox();
    }

    override function update(elapsed:Float) {
        if (targetSprite != null) {
            alpha = targetSprite.alpha;
        }
        super.update(elapsed);
    }
}

class MenuButton extends FlxSprite {
    public var offsetX:Float = 0;

    public var moveTween:FlxTween = null;

    public function new(X:Float = 0, Y:Float = 0) {
        super(X, Y);
        offsetX = X;
    }

    override function update(elapsed:Float) {
        if (moveTween != null && moveTween.finished) {
            moveTween = null;
        }
        super.update(elapsed);
    }
}