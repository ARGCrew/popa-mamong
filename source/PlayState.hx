package;

import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxCamera;
import Note;
import MusicBeat;
import flixel.tweens.FlxTween;
import haxeparser.HaxeParser as HScript;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class PlayState extends MusicBeatState {
    //BUTTONS
    public var butts:ButtonGrid;

    // CUSTOM LEVELS
    public static var instance:PlayState;
    public var level:String = 'default';
    var hscript:HScript = null;

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
    var noteTweens:Map<Note, NoteTween> = [];

    var events:Array<EventMap> = [];

    public static var songName:String = 'Credits';
    public static var curDifficulty:String = 'Normal';

    var music:Music = null;

    public var camGame:FlxCamera;
    public var camHUD:FlxCamera;

    public var botplay:Bool = false;

    var combo:Int = 0;
    var comboTxt:FlxText;

    public static var daPlaying:Bool = false;

    override function create() {
        instance = this;
        persistentDraw = persistentUpdate = true;

        FlxG.sound.playMusic(Paths.music(songName));
        FlxG.sound.music.volume = Settings.masterVolume;

        #if desktop
        changePresence("Playing", '$songName ($curDifficulty)', true, FlxG.sound.music.length);
        #end

        camGame = new FlxCamera();
        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;
        FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camHUD, false);
        FlxG.cameras.setDefaultDrawTarget(camGame, true);

        music = MusicBeat.loadFromJson(curDifficulty, songName);
        Conductor.changeBPM(95);
        Palette.parse('assets/palette.jsonc');

        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, Palette.bg));

        spawnNotes = new FlxTypedGroup<Note>();
        add(spawnNotes);

        for (i in 0...music.notes.length) {
            var daNote = music.notes[i];
            var note:Note = new Note(daNote.time, daNote.id);
            note.scale.set(0.01, 0.01);
            unspawnNotes.push(note);
        }
        for (i in 0...music.events.length) {
            var daEvent = music.events[i];
            events.push(daEvent);
        }
        
        songSpeed = music.speed;
        speedMS = songSpeed * 1000;

        new FlxTimer().start(5, function(tmr:FlxTimer) {
            camGame.flash();
        });
        
        butts = new ButtonGrid();
        add(butts);

        comboTxt = new FlxText(10, FlxG.height - 75, FlxG.width, "");
        comboTxt.setFormat(Paths.font, 48, FlxColor.WHITE, LEFT, NONE);
        comboTxt.cameras = [camHUD];
        add(comboTxt);

        daPlaying = true;
        super.create();
        overlay.cameras = [camHUD];

        if (Paths.exists(Paths.hscript(songName, "levels"))) {
            hscript = new HScript(Paths.hscript(songName, "levels"));

            hscript.addCallback("add", add);
            hscript.addCallback("insert", insert);
            hscript.addCallback("remove", remove);
            hscript.addCallback("members", members);
            hscript.addCallback("cameraFilters", cameraFilters);

            hscript.addCallback("butts", butts);
            hscript.addCallback("triggerEvent", triggerEvent);

            if (hscript.hasFunction('create')) {
                hscript.callFunction('create')();
            }
        }
    }

    override function update(elapsed) {
        Conductor.songPosition = FlxG.sound.music.time;
        FlxG.sound.music.volume = Settings.getMusicVolume();
        speedMS = songSpeed * 1000;
        
        manage.PlayKeyManager.manage();

        if (Settings.camBeat) FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

        if (unspawnNotes.length > 0) {
            var note = unspawnNotes[0];

            if (Conductor.songPosition >= note.time - speedMS && !note.spawned) {
                spawnNotes.add(note);
/*
                // TODO: Это надо пофиксить
                if (note.time < speedMS) {
                    note.scale.x = speedMS / note.time;
                    note.scale.y = note.scale.x;
                }
*/
                noteTweens.set(note, new NoteTween(note, 0.75, songSpeed * 0.75, function() {
                    if (note != null && note.alive) {
                        noteTweens.set(note, new NoteTween(note, 1, songSpeed * 0.25));
                    }
                }));

                note.spawned = true;

                unspawnNotes.shift();
            }
        }

        if (events.length > 0) {
            var event = events[0];

            if (Conductor.songPosition >= event.time - eventInAdvance(event.name)) {
                triggerEvent(event.name, event.value1, event.value2, event.value3);
            }

            events.shift();
        }

        spawnNotes.forEachAlive(function(note:Note) {
            if (noteTweens.exists(note)) {
                noteTweens[note].update(elapsed);
            }

            //note.scale.x = note.scale.y = (Conductor.songPosition / note.time * 0.75) * songSpeed;

            //note.scale.x = note.scale.y = ((Conductor.songPosition / stuff) * 0.01) * songSpeed;

            if (note.scale.x >= 0.75 && botplay) {
                try {
                    goodHit(note);
                } catch(e) {
                    trace(e);
                }
            }
            if (note.scale.x >= 1) {
                miss(note);
            }
        });

        comboTxt.text = 'Combo: $combo';

        super.update(elapsed);

        if (hscript != null && hscript.hasFunction('update')) {

            hscript.addCallback("lastBeat", lastBeat);
            hscript.addCallback("lastStep", lastStep);
            hscript.addCallback("curStep", curStep);
            hscript.addCallback("curBeat", curBeat);
            hscript.addCallback("cameraFilters", cameraFilters);

            hscript.callFunction('update')(elapsed);
        }

        if (FlxG.keys.justPressed.T) {
            trace('Note Time: ${spawnNotes.members[0].time}');
            trace('Song Position: ${Conductor.songPosition}');
            trace('Note Scale: ${spawnNotes.members[0].scale.x}');
        }
    }

    override function beatHit() {
        if (curBeat % 4 == 0 && Settings.camBeat) {
            FlxG.camera.zoom += 0.015;
        }
        super.beatHit();

        if (hscript != null && hscript.hasFunction('beatHit')) {
            hscript.callFunction('beatHit')();
        }
    }

    public function checkHit(butt:Button) {
        if (FlxG.sound.music != null && FlxG.sound.music.playing) {
            var daNoteList:Array<Note> = [];
            spawnNotes.forEachAlive(function(note:Note) {
                daNoteList.push(note);
            });
                
            if (daNoteList.length > 0) {
                var note = daNoteList[0];

                if (note.id == butt.id && note.scale.x > 0.7) {
                    goodHit(note);
                }
                else {
                    missHit(butt);
                }

                daNoteList.shift();
            }
            else {
                missHit(butt);
            }
        }
        
        if (hscript != null && hscript.hasFunction('checkHit')) {
            hscript.callFunction('checkHit')(butt);
        }
    }

    public function goodHit(note:Note) {
        // * [DEPRECATED] Sound.fromFile('assets/sounds/Miss.ogg').play();
        var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Pressed')).play();
        sound.volume = Settings.getSoundVolume();
        butts.members[note.id].color = Palette.confirmed;

        combo ++;

        noteTweens.remove(note);
        note.kill();
        note.destroy();

        if (hscript != null && hscript.hasFunction('goodHit')) {
            hscript.callFunction('goodHit')(note);
        }
    }

    public function release(butt:Button) {
        butt.color = Palette.released;

        if (hscript != null && hscript.hasFunction('release')) {
            hscript.callFunction('release')(butt);
        }
    }

    public function missHit(butt:Button) {
        butt.color = Palette.pressed;
        
        if (!Settings.ghostTapping) {
            // * [DEPRECATED] Sound.fromFile('assets/sounds/Miss.ogg').play();
            var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Miss')).play();
            sound.volume = Settings.getSoundVolume();

            combo = 0;
        }

        if (hscript != null && hscript.hasFunction('missHit')) {
            hscript.callFunction('missHit')(butt);
        }
    }

    public function miss(note:Note) {
        combo = 0;

        noteTweens.remove(note);
        note.kill();
        note.destroy();

        if (hscript != null && hscript.hasFunction('miss')) {
            hscript.callFunction('miss')(note);
        }
    }

    public function triggerEvent(name:String, value1:String, value2:String, value3:String) {
        switch(name) {
            case 'Change BPM':
                Conductor.changeBPM(Std.parseFloat(value1));
            case 'Camera Flash':
                FlxG.camera.flash(Std.parseInt(value1), Std.parseFloat(value2));
            case 'Camera Beat':
                FlxG.camera.zoom += Std.parseFloat(value1);
            case '':
        }

        if (hscript != null && hscript.hasFunction('triggerEvent')) {
            hscript.callFunction('triggerEvent')(name, value1, value2, value3);
        }
    }

    public function eventInAdvance(name:String):Float {
        if (hscript != null && hscript.hasFunction('eventInAdvance')) {
            return hscript.callFunction('eventInAdvance')(name);
        }

        return 0;
    }

    override function destroy() {
        daPlaying = false;
        super.destroy();
    }

    override function openSubState(SubState:FlxSubState) {
        for (twn in noteTweens.keys()) {
            noteTweens[twn].pause();
        }
        FlxG.sound.music.pause();
        persistentUpdate = false;

        super.openSubState(SubState);
    }

    override function closeSubState() {
        for (twn in noteTweens.keys()) {
            noteTweens[twn].resume();
        }
        FlxG.sound.music.resume();
        persistentUpdate = true;

        super.closeSubState();
    }

    override function onFocus() {
        #if desktop
        changePresence("Playing", '$songName ($curDifficulty)', true, FlxG.sound.music.length - Conductor.songPosition);
        #end
    }

    override function onFocusLost() {
        #if desktop
        changePresence("Paused", '${PlayState.songName} (${PlayState.curDifficulty})');
        #end
    }
}
