package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.ui.FlxUICheckBox;
import lime.graphics.RenderContextType;
import lime.app.Application;
import lime.ui.Window;

class Settings
{
    public static var skin:String = 'square';
    public static var camBeat:Bool = true;

    public static var masterVolume:Float = 1;
    public static var musicVolume:Float = 1;
    public static var soundVolume:Float = 1;

    public static function getMusicVolume():Float {
        return musicVolume * masterVolume;
    }
    public static function getSoundVolume():Float {
        return soundVolume * masterVolume;
    }

    public static function save()
    {
        FlxG.save.bind('arg-save', 'ARG');

        FlxG.save.data.skin = skin;
        FlxG.save.data.camBeat = camBeat;

        FlxG.save.data.masterVolume = masterVolume;
        FlxG.save.data.musicVolume = musicVolume;
        FlxG.save.data.soundVolume = soundVolume;

        FlxG.save.flush();
    }

    public static function load()
    {
        FlxG.save.bind('arg-save', 'ARG');
        if (FlxG.save == null) save();

        if (FlxG.save.data.skin != null) skin = FlxG.save.data.skin;
        if (FlxG.save.data.camBeat != null) skin = FlxG.save.data.camBeat;

        if (FlxG.save.data.masterVolume != null) skin = FlxG.save.data.masterVolume;
        if (FlxG.save.data.musicVolume != null) skin = FlxG.save.data.musicVolume;
        if (FlxG.save.data.soundVolume != null) skin = FlxG.save.data.soundVolume;

        FlxG.save.flush();
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
        var circleCheckBox:FlxUICheckBox = new FlxUICheckBox(10, 10, null, null, "Circle Buttons", 100);
        circleCheckBox.checked = (Settings.skin == 'circle');
        circleCheckBox.callback = function() {
            circleCheckBox.checked ? {
                Settings.skin = 'circle';
            } : {
                Settings.skin = 'square';
            }
		}
        add(circleCheckBox);

        var beatCheckBox:FlxUICheckBox = new FlxUICheckBox(10, 40, null, null, "Camera Beat", 100);
        beatCheckBox.checked = Settings.camBeat;
        beatCheckBox.callback = function() {
            Settings.camBeat = beatCheckBox.checked;
		}
        add(beatCheckBox);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new PlayState());
        super.update(elapsed);
    }

    override function destroy()
    {
        Settings.save();
        super.destroy();
    }
}