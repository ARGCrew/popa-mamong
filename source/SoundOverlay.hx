package;

import openfl.text.TextField;
import flixel.util.FlxColor;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import flixel.util.FlxTimer;
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

    var hideTimer:FlxTimer = null;

    public function new()
    {
        super();

        value = Settings.masterVolume;

        line = new FlxSprite(FlxG.width + 50, FlxG.height - FlxG.height / 3 - 45).makeGraphic(5, Std.int(FlxG.height / 3));
        add(line);

        handle = new FlxSprite(0, line.y + line.height - (line.height * value)).makeGraphic(25, 5);
        add(handle);

        hitbox = new FlxSprite(0, line.y).makeGraphic(Std.int(handle.width), Std.int(line.height));
        hitbox.visible = false;
        add(hitbox);

        FlxG.mouse.x >= FlxG.width - 100 ? {
            line.x = offsetX;
        } : {
            line.x = FlxG.width + 50;
        }
    }

    override function update(elapsed:Float)
    {
        if (FlxG.mouse.x >= FlxG.width - 100)
            FlxTween.tween(line, {x: offsetX}, 0.1, {ease: FlxEase.sineOut});
        else {
            if (!dragging && hideTimer == null)
            {
                FlxTween.tween(line, {x: FlxG.width + 50}, 0.1, {ease: FlxEase.sineIn});
                Settings.save();
            }
        }

        handle.x = line.x - 10;

        hitbox.x = handle.x;

        if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed) dragging = true;
        if (FlxG.mouse.justReleased) dragging = false;

        if (dragging) handle.y = FlxG.mouse.y;

        if (FlxG.keys.justPressed.PLUS)
        {
            if (hideTimer != null) hideTimer.cancel();
            hideTimer = null;

            FlxTween.tween(line, {x: offsetX}, 0.1, {ease: FlxEase.sineOut});

            handle.y -= line.height / 10;
            hideTimer = new FlxTimer().start(0.5, function(tmr:FlxTimer) {
                FlxTween.tween(line, {x: FlxG.width + 50}, 0.1, {ease: FlxEase.sineIn});
                Settings.save();
                hideTimer = null;
            });
        }
        if (FlxG.keys.justPressed.MINUS)
        {
            if (hideTimer != null) hideTimer.cancel();
            hideTimer = null;

            FlxTween.tween(line, {x: offsetX}, 0.1, {ease: FlxEase.sineOut});

            handle.y += line.height / 10;
            hideTimer = new FlxTimer().start(0.5, function(tmr:FlxTimer) {
                FlxTween.tween(line, {x: FlxG.width + 50}, 0.1, {ease: FlxEase.sineIn});
                Settings.save();
                hideTimer = null;
            });
        }

        if (handle.y < line.y) handle.y = line.y;
        if (handle.y > line.y + line.height) handle.y = line.y + line.height;

        value = ((line.y + line.height) - handle.y) / line.height;

        if (value < 0) value = 0;
        if (value > 1) value = 1;

        Settings.masterVolume = value;

        super.update(elapsed);
    }
}

class BitmapSoundOverlay extends TextField
{
    public static var line:Bitmap;
    public static var handle:Bitmap;
    public static var hitbox:Bitmap;

    public static var instance:BitmapSoundOverlay;

    var value:Float = Settings.masterVolume;
    var offsetX:Float = FlxG.width - 50;
    var dragging:Bool = false;
    var valueLine:Float = 0;
    
    public function new()
    {
        super();

        instance = this;

        line = makeGraphic(5, FlxG.height / 3, FlxColor.WHITE);
        Main.instance.addChild(line);
        handle = makeGraphic(25, 5, FlxColor.WHITE);
        handle.y = line.y + line.height - (line.height * value);
        Main.instance.addChild(handle);
        hitbox = makeGraphic(handle.width, line.height, FlxColor.WHITE);
        hitbox.visible = false;
        Main.instance.addChild(hitbox);

        FlxG.mouse.x >= FlxG.width - 100 ? {
            line.x = offsetX;
        } : {
            line.x = FlxG.width + 50;
        }
        line.y = FlxG.height - FlxG.height / 3 - 45;
        handle.y = line.y;

        hitbox.x = handle.x;
        hitbox.y = line.y;

        valueLine = line.height - handle.height;
    }

    private #if !flash override #end function __enterFrame(deltaTime:Float):Void
    {
        if (FlxG.mouse.x >= FlxG.width - 100)
            FlxTween.tween(line, {x: offsetX}, 0.1, {ease: FlxEase.sineOut});
        else {
            if (!dragging)
            {
                FlxTween.tween(line, {x: FlxG.width + 50}, 0.1, {ease: FlxEase.sineIn});
                trace(value);
                Settings.save();
            }
        }

        handle.x = line.x - 10;

        hitbox.x = handle.x;

        if (FlxG.mouse.x > hitbox.x && FlxG.mouse.x < hitbox.x + hitbox.width
        && FlxG.mouse.y > hitbox.y && FlxG.mouse.y < hitbox.y + hitbox.height
        && FlxG.mouse.pressed) dragging = true;
        if (FlxG.mouse.justReleased) dragging = false;

        if (dragging) handle.y = FlxG.mouse.y;

        if (handle.y < line.y) handle.y = line.y;
        if (handle.y > line.y + line.height) handle.y = line.y + line.height - handle.height;

        value = ((line.y + valueLine) - handle.y) / valueLine;

        if (value < 0) value = 0;
        if (value > 1) value = 1;

        Settings.masterVolume = value;
    }

    function makeGraphic(width:Float, height:Float, color:FlxColor):Bitmap {
        return new Bitmap(FlxG.bitmap.create(Std.int(width), Std.int(height), color).bitmap);
    }
}