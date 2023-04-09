package;

import flixel.system.FlxSound;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxCamera;
import MusicBeat.Music;
import flixel.tweens.FlxTween;
import haxeparser.HaxeParser;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends MusicBeatState {
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
    public var songSpeed:Float = 2;
    public var speedMS:Float = 0;
    var noteTweens:Map<Note, FlxTween> = [];

    public static var songName:String = 'Credits';
    public static var curDifficulty:String = 'normal';

    var music:Music = null;

    var camGame:FlxCamera;

    override function create() {
        persistentDraw = persistentUpdate = true;

        FlxG.sound.playMusic(Paths.music(songName));
        FlxG.sound.music.volume = Settings.masterVolume;

        speedMS = songSpeed * 1000;

        camGame = new FlxCamera();
        FlxG.cameras.reset(camGame);
        FlxG.cameras.setDefaultDrawTarget(camGame, true);

        music = MusicBeat.loadFromJson(curDifficulty, songName);
        Conductor.changeBPM(95);
        Palette.parse('assets/palette.json');

        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, Palette.bg));

        spawnNotes = new FlxTypedGroup<Note>();
        add(spawnNotes);

        for (i in 0...music.notes.length) {
            var section = music.notes[i];
            for (b in 0...section.sectionNotes.length) {
                var daNote = section.sectionNotes[b];
                var note:Note = new Note(daNote.time, daNote.id);
                note.scale.set(0.01, 0.01);
                unspawnNotes.push(note);
            }
        }

        new FlxTimer().start(5, function(tmr:FlxTimer) {
            camGame.flash();
        });
        
        butts = new FlxTypedGroup<FlxSprite>();
        add(butts);
        for (i in 0...9) butts.add(new Button(i, Settings.skin));

        super.create();

        instance = this;
        hscript = new HaxeParser(Paths.hscript(level));
        hscript.addCallback('this', instance);
        hscript.callFunction('create', []);
    }

    override function update(elapsed) {
        Conductor.songPosition = FlxG.sound.music.time;
        FlxG.sound.music.volume = Settings.getMusicVolume();
        
        manage.PlayKeyManager.manage();

        if (Settings.camBeat) FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

        for (i in 0...unspawnNotes.length)  {
            var note = unspawnNotes[i];

            if (Conductor.songPosition >= note.time - speedMS && !note.spawned) {
                spawnNotes.add(note);
                unspawnNotes.shift();
                noteTweens.set(note, FlxTween.tween(note.scale, {x: 0.75, y: 0.75}, songSpeed, {onComplete: function(twn:FlxTween) {
                    if (note != null && note.alive) {
                        noteTweens.set(note, FlxTween.tween(note.scale, {x: 1, y: 1}, songSpeed * 0.25));
                    }
                }}));
                note.spawned = true;
                // TODO: Это надо пофиксить
                if (note.time < speedMS) {
                    note.scale.x = speedMS / note.time;
                    note.scale.y = note.scale.x;
                }
            }
        }

        spawnNotes.forEachAlive(function(note:Note) {
            if (note.scale.x >= 1) {
                miss(note);
            }
        });

        super.update(elapsed);

        hscript.callFunction('update', [elapsed]);
    }

    function musicManage() {
        Conductor.songPosition = FlxG.sound.music.time;
        FlxG.sound.music.volume = Settings.getMusicVolume();
    }

    override function beatHit() {
        if (curBeat % 4 == 0 && Settings.camBeat) {
            FlxG.camera.zoom += 0.015;
        }
        super.beatHit();
    }

    public function checkHit(butt:Button) {
        if (FlxG.sound.music != null && FlxG.sound.music.playing) {
            var daNoteList:Array<Note> = [];
            spawnNotes.forEachAlive(function(note:Note) {
                daNoteList.push(note);
            });
                
            if (daNoteList.length > 0) {
                spawnNotes.forEachAlive(function(note:Note) {
                    if (note.id == butt.id && note.scale.x > 0.7) {
                        goodHit(note);
                    }
                    else {
                        missHit(butt);
                    }
                });
            }
            else {
                missHit(butt);
            }
        }
    }

    public function goodHit(note:Note) {
        // * [DEPRECATED] Sound.fromFile('assets/sounds/Miss.ogg').play();
        var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Pressed')).play();
        sound.volume = Settings.getSoundVolume();
        butts.members[note.id].color = Palette.confirmed;

        noteTweens.remove(note);
        note.kill();
        note.destroy();
        remove(note);
    }

    public function release(butt:Button) {
        butt.color = Palette.released;
    }

    public function missHit(butt:Button) {
        butt.color = Palette.pressed;
        // * [DEPRECATED] Sound.fromFile('assets/sounds/Miss.ogg').play();
        var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Miss')).play();
        sound.volume = Settings.getSoundVolume();
    }

    public function miss(note:Note) {
        noteTweens.remove(note);
        note.kill();
        note.destroy();
        spawnNotes.remove(note);
    }
}
