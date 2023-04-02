package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class SoundOverlay extends FlxSpriteGroup {
    public static var line:FlxSprite;
    public static var handle:FlxSprite;
    public static var hitbox:FlxSprite;

    public static var instance:SoundOverlay;

    var value:Float = Settings.masterVolume;
    static var dragging:Bool = false;
    var valueLine:Float = 0;
    
    public function new() {
        super();

        instance = this;

        line = new FlxSprite().makeGraphic(5, Std.int(FlxG.height / 3));
        add(line);
        handle = new FlxSprite().makeGraphic(25, 5);
        handle.y = line.y + line.height - (line.height * value);
        add(handle);
        hitbox = new FlxSprite().makeGraphic(Std.int(handle.width), Std.int(line.height));
        hitbox.visible = false;
        add(hitbox);

        FlxG.mouse.x >= FlxG.width - 100 ? {
            line.x = FlxG.width - 50;
        } : {
            line.x = FlxG.width + 50;
        }
        line.y = FlxG.height - FlxG.height / 3 - 45;
        handle.y = (line.y + (line.height - handle.height)) - (Settings.masterVolume * (line.height - handle.height));

        hitbox.x = handle.x;
        hitbox.y = line.y;

        valueLine = line.height - handle.height;
    }

    override function update(elapsed:Float) {
        FlxG.mouse.x >= FlxG.width - 100 ? {
            FlxTween.tween(line, {x: FlxG.width - 50}, 0.1, {ease: FlxEase.sineOut});
        } : {
            if (!dragging)
                {
                    FlxTween.tween(line, {x: FlxG.width + 50}, 0.1, {ease: FlxEase.sineIn});
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
}