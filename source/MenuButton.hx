package;

import flixel.FlxG;
import hxAddons.HxBitmapSprite;

class MenuButton extends HxBitmapSprite
{
    public var onMouseDown:()->Void = null; // если нажать
    public var onMouseUp:()->Void = null; // если отпустить
    public var onMouseOver:()->Void = null; // если навести
    public var onMouseOut:()->Void = null; // если убрать
    
    private var over:Bool = false;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.mouse.overlaps(this)) onMouseOver();
        if (!FlxG.mouse.overlaps(this) && over)
        {
            mouseOut();
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
        if (onMouseOver != null) onMouseOver();
        if (FlxG.mouse.justPressed) mouseDown();
        if (FlxG.mouse.justReleased) mouseUp();
        over = true;
    }

    private function mouseOut() {
        if (onMouseOut != null) onMouseOut();
        over = false;
    }
}