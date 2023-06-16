package utils;

import flixel.system.FlxSound;
import openfl.media.Sound;

class Utils {
    public static function playSound(sound:Sound) {
        var flxSound:FlxSound = new FlxSound().loadEmbedded(sound).play();
        flxSound.volume = Preference.volume.sound;
        return flxSound;
    }

    public static function boundTo(value:Float, min:Float, max:Float)
        return Math.max(min, Math.min(max, value));
}