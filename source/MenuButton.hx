package;

import flixel.FlxG;
import hxAddons.HxBitmapSprite;

class MenuButton extends HxBitmapSprite
{
    public var onMouseDown:()->Void = null;
    public var onMouseUp:()->Void = null;
    public var onMouseOver:()->Void = null;
    public var onMouseOut:()->Void = null;

    private var outed:Bool = false;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.mouse.overlaps(this)) onMouseOver();
        if (!FlxG.mouse.overlaps(this) && !outed)
        {
            mouseOut();
            outed = true;
        }
        super.update(elapsed);
    }

    private function mouseDown()
    {
        if (onMouseDown != null) onMouseDown();
    }

    private function mouseUp() {
        if (onMouseUp != null) onMouseUp();
    }

    private function mouseOver()
    {
        if (onMouseOver !- null) onMouseOver();
        if (FlxG.mouse.justPressed) mouseDown();
        if (FlxG.mouse.justReleased) mouseUp();
    }

    private function mouseOut() {
        if (onMouseOut != null) onMouseOut();
    }
}