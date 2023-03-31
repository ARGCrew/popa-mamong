package;

import hxAddons.HxBitmapSprite;

class OhLine extends HxBitmapSprite
{
    public var targetSprite:MenuButton = null;

    override function update(elapsed:Float)
    {
        if (targetSprite != null) alpha = targetSprite.alpha;
        super.update(elapsed);
    }
}