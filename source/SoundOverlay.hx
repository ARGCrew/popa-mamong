package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class SoundOverlay extends FlxSpriteGroup
{
    var line:FlxSprite;
    var handle:FlxSprite;

    var hitbox:FlxSprite;
    
    var value:Float = Settings.masterVolume;

    var offsetX:Float = FlxG.width - 50;

    var dragging:Bool = false;

    public function new()
    {
        super();

        line = new FlxSprite(FlxG.width + 50, FlxG.height - FlxG.height / 3 - 45).makeGraphic(5, Std.int(FlxG.height / 3));
        add(line);

        handle = new FlxSprite(0, line.y + line.width - value * line.width).makeGraphic(25, 5);
        add(handle);

        hitbox = new FlxSprite(0, line.y).makeGraphic(Std.int(handle.width), Std.int(line.height));
        hitbox.visible = false;
        add(hitbox);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.mouse.x >= FlxG.width - 100)
            FlxTween.tween(line, {x: offsetX}, 0.1, {ease: FlxEase.sineOut});
        else {
            if (!dragging) FlxTween.tween(line, {x: FlxG.width + 50}, 0.1, {ease: FlxEase.sineIn});
        }

        handle.x = line.x - 10;

        hitbox.x = handle.x;

        if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed) dragging = true;
        if (FlxG.mouse.justReleased) dragging = false;

        if (dragging) handle.y = FlxG.mouse.y;

        if (handle.y < line.y) handle.y = line.y;
        if (handle.y > line.y + line.height) handle.y = line.y + line.height;

        value = ((line.y + line.height) - handle.y) / line.height;

        if (value < 0) value = 0;
        if (value > 1) value = 1;

        Settings.masterVolume = value;

        super.update(elapsed);
    }
}
