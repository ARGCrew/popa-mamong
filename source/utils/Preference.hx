package utils;

import flixel.FlxG;

class Preference {
    public static var visuals:Visuals = new Visuals();
    public static var gameplay:Gameplay = new Gameplay();
    public static var misc:Misc = new Misc();
    public static var volume:Volume = new Volume();
}

private class Visuals {
    public var antialiasing:Bool = true;
    public var colorBlind:ColorBlind = new ColorBlind();

    public function new() {}
}

private class Gameplay {
    public function new() {}
}

private class Misc {
    public var safeFrames:Int = 10;
    public var noteOffset:Float = 0;

    public function new() {}
}

private class Volume {
    public var master:Float = 1;

    public var music(get, default):Float = 1;
    public var sound(get, default):Float = 1;

    public var hitsound(get, default):Float = 1;
    public var misssound(get, default):Float = 1;

    public function new() {}

    public function get_music() return music * master;
    public function get_sound() return sound * master;

    public function get_hitsound() return hitsound * Preference.volume.sound;
    public function get_misssound() return misssound * Preference.volume.sound;
}