package;

import controls.Controls.KeyboardScheme;
import controls.PlayerSettings;

import flixel.util.FlxSave;
import lime.graphics.RenderContextType;
import lime.app.Application;
import lime.ui.Window;

class Settings {
    public static var skin:String = 'square';
    public static var camBeat:Bool = true;

    @:isVar public static var scheme(get, set):String = null;

    public static function set_scheme(value:String):String {
        scheme = value;
        PlayerSettings.current.setKeyboardScheme(value == "Numpad" ? Numpad : NoNumpad);
        return scheme;
    }

    public static function get_scheme() {
        return scheme;
    }

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

        save.data.masterVolume = masterVolume;
        save.data.musicVolume = musicVolume;
        save.data.soundVolume = soundVolume;

        save.flush();
    }

    public static function load() {
        var save:FlxSave = new FlxSave();
        save.bind('arg-save');

        if (save.data.skin != null) skin = save.data.skin;
        if (save.data.camBeat != null) camBeat = save.data.camBeat;

        if (save.data.masterVolume != null) masterVolume = save.data.masterVolume;
        if (save.data.musicVolume != null) musicVolume = save.data.musicVolume;
        if (save.data.soundVolume != null) soundVolume = save.data.soundVolume;
    }

    public static function openWindow() {
        var window:Window = Application.current.createWindow({
            allowHighDPI: true,
            alwaysOnTop: true,
            borderless: false,
            context: {
                antialiasing: 1,
                background: null,
                colorDepth: 0,
                depth: true,
                hardware: false,
                stencil: false,
                type: RenderContextType.CANVAS,
                version: "Settings",
                vsync: true
            },
            element: null,
            frameRate: 120,
            fullscreen: false,
            height: 720,
            hidden: false,
            maximized: false,
            minimized: false,
            parameters: null,
            resizable: false,
            title: "Settings",
            width: 800,
            x: Application.current.window.x + 400,
            y: Application.current.window.y + 360
        });
        window.stage.addChild(new flixel.FlxGame(800, 720, SettingsState, 120, 120, true, false));
    }
}