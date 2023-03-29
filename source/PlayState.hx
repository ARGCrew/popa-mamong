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
    public var butts:FlxTypedGroup<FlxSprite>;

    // CUSTOM LEVELS
    public static var instance:PlayState;
    var hscript:HaxeParser = null;
    public var level:String = 'default';

    // CHARTS
    /*
    * [DEPRECATED]
    * public var notes:Array<Dynamic> = [
    *    [0, 0, '']
    * ];
    */
    public var unspawnNotes:Array<Note> = [];
    public var spawnNotes:FlxTypedGroup<Note>;
    public var songSpeed:Float = 0.5;

    public static var songName:String = 'Tribute';
    public static var curDifficulty:String = 'normal';

    var music:MusicBeat.Music = null;

    var camGame:FlxCamera;

    override function create()
    {
        persistentDraw = persistentUpdate = true;

        FlxG.sound.playMusic(Paths.music('Tribute'));
        FlxG.sound.music.volume = Settings.masterVolume;

        camGame = new FlxCamera();
        FlxG.cameras.reset(camGame);
        FlxG.cameras.setDefaultDrawTarget(camGame, true);

        music = MusicBeat.loadFromJson(curDifficulty, songName);
        Conductor.changeBPM(95);
        Palette.parse('assets/palette.json');

        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, Palette.bg));

        spawnNotes = new FlxTypedGroup<Note>();
        add(spawnNotes);

        for (i in 0...music.notes.length)
        {
            var section = music.notes[i];
            for (b in 0...section.sectionNotes.length)
            {
                var daNote = section.sectionNotes[b];
                var note:Note = new Note(daNote.time, daNote.id);
                note.scale.set(0.01, 0.01);
                unspawnNotes.push(note);
            }
        }
        
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
        manage.PlayKeyManager.manage();

        if (Settings.camBeat) FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

        for (i in 0...unspawnNotes.length)
        {
            var note = unspawnNotes[i];

            if (note.time <= Conductor.songPosition + ((1 / songSpeed) * 1000))
            {
                spawnNotes.add(note);
                unspawnNotes.shift();
            }
        }

        spawnNotes.forEachAlive(function(note:Note)
        {
            if (note.time <= Conductor.songPosition + ((1 / songSpeed) * 1000))
            {
                note.scale.x += (0.01 / songSpeed) / 5;
                note.scale.y = note.scale.x;
            }
            else
            {
                note.kill();
                note.destroy();
                spawnNotes.remove(note);
            }
        });

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
