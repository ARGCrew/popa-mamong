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
import flixel.tweens.FlxTween;

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
    //public static var songName:String = 'tribute';
    public static var songName:String = 'credits';
    public static var curDifficulty:String = 'normal';

    var music:MusicBeat.Music = null;

    var camGame:FlxCamera;

    override function create()
    {
        persistentDraw = persistentUpdate = true;

        FlxG.sound.playMusic(Paths.music(songName));
        FlxG.sound.music.volume = Settings.masterVolume;

        camGame = new FlxCamera();
        FlxG.cameras.reset(camGame);
        FlxG.cameras.setDefaultDrawTarget(camGame, true);

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

        var effectTween:FlxTween;

        if(songName == 'credits')
            {
                var backdrop = new FlxSprite(250, 250, "assets/images/indicators/CIRCLE.png");
		        add(backdrop);

		        var effect = new MosaicEffect();
		        backdrop.shader = effect.shader;

                effectTween = FlxTween.num(MosaicEffect.DEFAULT_STRENGTH, 5);
            }
    }

    override function update(elapsed)
    {
        musicManage();
        manage.PlayKeyManager.manage();

        if (Settings.camBeat) FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

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
        if (curBeat % 4 == 0 && Settings.camBeat)
            FlxG.camera.zoom += 0.015;
        super.beatHit();
    }
    
}
