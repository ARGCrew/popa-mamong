package;

import flixel.util.FlxSave;

class Settings {
    public static var skin:String = 'Square';
    public static var camBeat:Bool = true;

    public static var scheme:String = "None";
    public static var ghostTapping:Bool = false;

    public static var masterVolume:Float = 1;
    public static var musicVolume:Float = 1;
    public static var soundVolume:Float = 1;

    public static function getMusicVolume():Float {
        return musicVolume * masterVolume;
    }
    public static function getSoundVolume():Float {
        return soundVolume * masterVolume;
    }

    public static function save() {
        var save:FlxSave = new FlxSave();
        save.bind('arg-save');

        save.data.skin = skin;
        save.data.camBeat = camBeat;

        save.data.scheme = scheme;
        save.data.ghostTapping = ghostTapping;

        save.data.masterVolume = masterVolume;
        save.data.musicVolume = musicVolume;
        save.data.soundVolume = soundVolume;

        save.flush();
    }

    public static function load() {
        var save:FlxSave = new FlxSave();
        save.bind('arg-save');

        if (save.data.skin != null) {
            skin = save.data.skin;
        }
        if (save.data.camBeat != null) {
            camBeat = save.data.camBeat;
        }

        if (save.data.scheme != null) {
            scheme = save.data.scheme;
        }
        if (save.data.ghostTapping != null) {
            ghostTapping = save.data.ghostTapping;
        }

        if (save.data.masterVolume != null) {
            masterVolume = save.data.masterVolume;
        }
        if (save.data.musicVolume != null) {
            musicVolume = save.data.musicVolume;
        }
        if (save.data.soundVolume != null) {
            soundVolume = save.data.soundVolume;
        }
    }
}