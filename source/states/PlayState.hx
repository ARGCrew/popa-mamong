package states;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import system.song.Section.SectionData;
import system.song.Note;
import sprites.Note;
import flixel.group.FlxGroup.FlxTypedGroup;
import hscript.HScript;
import flixel.util.FlxColor;
import flixel.FlxG;
import sprites.StrumGrid;
import system.song.Song;

class PlayState extends DaState {
    public static var SONG:SongData;
    public var songSpeed:Float = 1;

    public var strumGrid:StrumGrid;

    public var stunned:Bool = true;
    public var controlArray:Array<String> = [
        "SEVEN", "EIGHT",  "NINE",
         "FOUR",  "FIVE",   "SIX",
          "ONE",   "TWO", "THREE"
    ];

    public var unspawnNotes:Array<Note> = [];
    public var spawnNotes:FlxTypedGroup<Note>;
    public var events:Array<EventNoteData> = [];

    public var camBG:FlxCamera;
    public var camGame:FlxCamera;
    public var camHUD:FlxCamera;

    public static var instance:PlayState;
    private var hscript:HScript;

    override function create() {
        super.create();
        instance = this;

        camBG = new FlxCamera();
        camGame = new FlxCamera();
        camGame.bgColor.alpha = 0;
        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;

        FlxG.cameras.reset(camBG);
        FlxG.cameras.add(camGame, false);
        FlxG.cameras.add(camHUD, false);
        FlxG.cameras.setDefaultDrawTarget(camGame, true);

        spawnNotes = new FlxTypedGroup<Note>();
        add(spawnNotes);

        strumGrid = new StrumGrid();
        strumGrid.screenCenter();
        add(strumGrid);

        for (section in SONG.notes) {
            for (note in section.notes) {
                var daNote:Note = new Note(note.data, note.time);
                daNote.noteType = note.type;
                unspawnNotes.push(daNote);
            }
        }
        events = SONG.events;

        startCountdown();

        hscript = new HScript("scripts/" + SONG.song + ".hx");
        hscript.call("create", []);
    }

    private var startTimer:FlxTimer = null;
    private function startCountdown() {
        Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 3;

        var countBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        countBG.alpha = 0.6;
        add(countBG);

        var counter:Int = 0;
        var texts:Array<String> = ["3", "2", "1"];

        startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer) {
            if (counter == 3) {
                FlxG.sound.playMusic(Paths.song(SONG.song));
                stunned = false;

                hscript.call("startSong", [SONG.song]);
            } else {
                var intro:FlxText = new FlxText(texts[counter], 256);
                intro.font = "embed/fonts/fs.ttf";
                intro.screenCenter();
                intro.cameras = [camHUD];
                add(intro);

                FlxTween.tween(intro, {alpha: 0}, Conductor.crochet / 1000, {
                    ease: FlxEase.cubeInOut,
                    onComplete: function(twn:FlxTween) {
                        intro.destroy();
                    }
                });
                Utils.playSound(Paths.sound("hit"));

                if (counter == 2)
                    FlxTween.tween(countBG, {alpha: 0}, Conductor.crochet / 1000, {
                        ease: FlxEase.cubeInOut,
                        onComplete: function(twn:FlxTween) {
                            countBG.destroy();
                        }
                    });
            }

            counter ++;
        }, 4);
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);

        for (i in 0...controlArray.length) {
            if (!stunned && Reflect.getProperty(controls, controlArray[i] + "_P")) {
                var isGoodHit:Bool = checkHit(i);
                if (isGoodHit) {
                    Utils.playSound(Paths.sound("hit")).volume = Preference.volume.hitsound;
                    strumGrid.members[i].color = FlxColor.LIME;
                } else {
                    Utils.playSound(Paths.sound("miss")).volume = Preference.volume.misssound;
                    strumGrid.members[i].color = FlxColor.RED;
                }
            }

            if (!Reflect.getProperty(controls, controlArray[i]))
                strumGrid.members[i].color = FlxColor.WHITE;
        }

        for (note in unspawnNotes) {
            if (Conductor.songPosition > note.strumTime - (songSpeed * 1000)) {
                spawnNotes.add(note);
                unspawnNotes.remove(note);
            }
        }

        for (note in spawnNotes) {
            if (note.scale.x >= 0.75 + Conductor.safeZoneOffset / 2)
                missNote(note);
        }

        for (event in events) {
            if (Conductor.songPosition >= event.time - eventNoteOffset(event)) {
                triggerEventNote(event);
                events.remove(event);
            }
        }

        if (controls.DEBUG_1) {
            FlxG.switchState(new states.editors.ChartEditorState());
            FlxG.sound.music.stop();
        }

        hscript.call("update", [elapsed]);
    }

    public function triggerEventNote(event:EventNoteData) {
        var type:String = event.type;
        var value1:String = event.value1;
        var value2:String = event.value2;
        var value3:String = event.value3;

        switch(type) {
            case "Flash Camera":
                var cameras:Map<String, FlxCamera> = ["BG" => camBG, "GAME" => camGame, "HUD" => camHUD];
                cameras[value1].flash(FlxColor.fromString(value2), Std.parseFloat(value3));
        }
    }

    private function eventNoteOffset(event:EventNoteData) {
        return 0;
    }

    private function checkHit(data:Int) {
        var isGoodHit:Bool = false;
        for (note in spawnNotes) {
            if ((note.noteData == data) && (note.scale.x > 0.75 - Conductor.safeZoneOffset / 2)) {
                isGoodHit = true;
                goodHit(note);
            }
        }
        if (!isGoodHit) missHit();

        return isGoodHit;
    }

    private function goodHit(note:Note) {
        spawnNotes.remove(note);
    }

    private function missHit() {}

    private function missNote(note:Note) {
        spawnNotes.remove(note);
    }

    override function stepHit() {
        super.stepHit();

        hscript.call("stepHit", [curStep]);
    }

    override function beatHit() {
        super.beatHit();

        hscript.call("beatHit", [curBeat]);
    }

    override function sectionHit() {
        super.sectionHit();

        hscript.call("sectionHit", [curSection]);
    }
}