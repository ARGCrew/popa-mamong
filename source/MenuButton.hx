package;

import flixel.tweens.FlxTween;
import hxAddons.HxBitmapSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class MenuButton extends HxBitmapSprite
{
    public var offsetX:Float = 0;

    public var moveTween:FlxTween = null;

    public function new(X:Float = 0, Y:Float = 0)
    {
        super(X, Y);
        offsetX = X;
    }
    
    public function set_moveTween(newValue:FlxTween)
    {
        moveTween = newValue;
    }

    override function update(elapsed:Float)
    {
        if (moveTween != null && moveTween.finished) moveTween = null;
        super.update(elapsed);
    }
}