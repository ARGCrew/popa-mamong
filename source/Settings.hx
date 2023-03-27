package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.ui.FlxUIButton;
import lime.graphics.RenderContextType;
import lime.app.Application;
import lime.ui.Window;

class Settings
{
    public static var skin:String = 'square';

    public static var mouse:Bool = true;

    public static var masterVolume:Float = 1;
    public static var musicVolume:Float = 1;
    public static var soundVolume:Float = 1;

    public static function getMusicVolume():Float {
        return musicVolume * masterVolume;
    }
    public static function getSoundVolume():Float {
        return soundVolume * masterVolume;
    }

    public static function openWindow()
    {
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
        window.stage.addChild(new flixel.FlxGame(800, 720, SetState, 120, 120, true, false));
    }
}

class SetState extends MusicBeatState
{
    var squareSkin:Bool = (Settings.skin == 'squares');

    override function create()
    {
        var skinButton = new FlxUIButton(10, 10, "Skin", function() {
            squareSkin = !squareSkin;
            Settings.skin = squareSkin ? 'square' : 'circle';
            trace(Settings.skin);
        });
        add(skinButton);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new PlayState());
        super.update(elapsed);
    }
}