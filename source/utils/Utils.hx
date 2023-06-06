package utils;

import flixel.system.FlxSound;
import openfl.media.Sound;

class Utils {
    public static function playSound(sound:Sound) {
        var flxSound:FlxSound = new FlxSound().loadEmbedded(sound).play();
        flxSound.volume = Preference.volume.sound;
        return flxSound;
    }
}