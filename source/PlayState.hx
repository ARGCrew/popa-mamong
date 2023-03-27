package;

import MusicBeat.Music;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import sys.io.File;
import haxeparser.HaxeParser;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends MusicBeatState
{
    //BUTTONS
    var butts:FlxTypedGroup<FlxSprite>;

    // CUSTOM LEVELS
    public static var instance:PlayState;
    var hscript:HaxeParser = null;
    public var level:String = 'default';

    // CHARTS
    public var notes:Array<Dynamic> = [
        [0, 0, '']
    ];
    public static var songName:String = 'Tribute';
    public static var curDifficulty:String = 'normal';

    var music:MusicBeat.Music = null;

    var camGame:FlxCamera;

    override function create()
    {
        persistentDraw = persistentUpdate = true;

        FlxG.sound.playMusic(Paths.music('Tribute'));

        camGame = new FlxCamera();
        FlxG.cameras.reset(camGame);
        FlxCamera.defaultCameras = [camGame];

        music = MusicBeat.loadFromJson(curDifficulty, songName);
        Conductor.changeBPM(95);
        Palette.parse('assets/palette.json');

        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, Palette.bg));
        
        butts = new FlxTypedGroup<FlxSprite>();
        add(butts);
        for (i in 0...9) butts.add(new Button(i, Settings.skin));


        super.create();

        instance = this;
        hscript = new HaxeParser(Paths.hscript(level));
        hscript.addCallback('this', instance);
        hscript.callFunction('create', []);
    }

    override function update(elapsed)
    {
        musicManage();

        var justPressed = FlxG.keys.justPressed;
        var pressed = FlxG.keys.pressed;

        if (justPressed.SEVEN)
        {
            FlxG.switchState(new NoteOffsetState(songName));
            FlxG.sound.music.stop();
        }

        if (justPressed.ESCAPE)
        {
            FlxG.switchState(new MainMenuState());
            FlxG.sound.music.stop();
        }

        if (justPressed.W)
            Settings.openWindow();

        if (justPressed.S)
        {
            FlxG.switchState(new Settings.SetState());
            FlxG.sound.music.stop();
        }

        // the sexiest easter egg code
        if (pressed.NUMPADONE && pressed.NUMPADTHREE && pressed.NUMPADSIX && pressed.NUMPADEIGHT && FlxG.random.bool(0.01))
        {
            FlxG.switchState(new TicTacToe());
            FlxG.sound.music.stop();
        }

        FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

        super.update(elapsed);

        hscript.callFunction('update', [elapsed]);
    }

    function musicManage()
    {
        Conductor.songPosition = FlxG.sound.music.time;
        FlxG.sound.music.volume = Settings.getMusicVolume();
    }

    override function beatHit()
    {
        if (curBeat % 4 == 0)
            FlxG.camera.zoom += 0.015;
        super.beatHit();
    }
}
