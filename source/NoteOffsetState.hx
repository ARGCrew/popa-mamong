package;

import haxe.Json;
import UIButtons;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;

#if (flash || html5)
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.net.FileReference;
import openfl.net.FileFilter;
#elseif (sys && !hl)
import sys.io.File;
import sys.FileSystem;
import systools.Dialogs;
#end

using StringTools;

class NoteOffsetState extends MusicBeatState {
    var music:String;

    var butts:ButtonGrid;

    var paused:Bool = true;
    var mult:Int = 1;

    var notes:Array<Note> = [];
    var noteStrings:Array<String> = [];

    var bpmInputText:UIInputText;
    var speedInputText:UIInputText;
    var songInputText:UIInputText;

    public function new(music:String) {
        super();
        this.music = music;

        FlxG.sound.playMusic(Paths.music(music));
        FlxG.sound.music.pause();
    }

    override function create() {
        changePresence("Chart Editor", null);

        butts = new ButtonGrid(-(FlxG.width / 5));
        add(butts);

        var openButt:UIButton = new UIButton((FlxG.width / 6) * 5, FlxG.height / 2, 100, 45, "LOAD");
        openButt.onChange = function() {
            openFile();
        }
        add(openButt);

        var saveButt:UIButton = new UIButton(openButt.x - 110, openButt.y, 100, 45, "SAVE");
        saveButt.onChange = function() {
            saveFile();
        }
        add(saveButt);

        bpmInputText = new UIInputText(saveButt.x, saveButt.y + 55, 100, 45);
        add(bpmInputText);

        speedInputText = new UIInputText(bpmInputText.x + 110, bpmInputText.y, 100, 55);
        add(speedInputText);

        songInputText = new UIInputText(bpmInputText.x, speedInputText.y + 110, 210, 55);
        add(songInputText);

        var line:FlxSprite = new FlxSprite((FlxG.width / 3) * 2, FlxG.height / 3).makeGraphic(Std.int(FlxG.width / 4), 5, FlxColor.WHITE);
        add(line);

        var vertical:FlxSprite = new FlxSprite(line.x + line.width / 2 - 2.5, line.y - 30).makeGraphic(5, 65, FlxColor.WHITE);
        add(vertical);

        super.create();
    }

    override function update(elapsed:Float) {
        Conductor.songPosition = FlxG.sound.music.time;

        if (FlxG.keys.pressed.SHIFT) {
            mult = 10;
        } else {
            mult = 1;
        }

        if (FlxG.keys.justPressed.SPACE) {
            paused = !paused;

            paused ? {
                FlxG.sound.music.pause();
            } : {
                FlxG.sound.music.resume();
            }
        }

        if (controls.BACK) {
            FlxG.switchState(new PlayState());
        }

        if (controls.LEFT) {
            paused = true;

            paused ? {
                FlxG.sound.music.pause();
            } : {
                FlxG.sound.music.resume();
            }

            FlxG.sound.music.time -= 100 * mult;
        }
        if (controls.RIGHT) {
            paused = true;

            paused ? {
                FlxG.sound.music.pause();
            } : {
                FlxG.sound.music.resume();
            }

            FlxG.sound.music.time += 100 * mult;
        }

        if (FlxG.keys.justPressed.ENTER) {
            PlayState.songName = music;
            FlxG.switchState(new PlayState());
        }

        if (controls.SEVEN_P) {
            addNote(0);
        }
        if (controls.EIGHT_P) {
            addNote(1);
        }
        if (controls.NINE_P) {
            addNote(2);
        }
        if (controls.FOUR_P) {
            addNote(3);
        }
        if (controls.FIVE_P) {
            addNote(4);
        }
        if (controls.SIX_P) {
            addNote(5);
        }
        if (controls.ONE_P) {
            addNote(6);
        }
        if (controls.TWO_P) {
            addNote(7);
        }
        if (controls.THREE_P) {
            addNote(8);
        }

        super.update(elapsed);
    }

    function addNote(id:Int) {
        notes.push(new Note(Conductor.songPosition, id));
    }

    function openFile() {
		#if (sys && !hl)
		var filters:FILEFILTERS = {
			count: 1,
			descriptions: ["JSON Files"],
			extensions: ["*.json"]
		};
		var result:Array<String> = Dialogs.openFile("Select chart", "", filters);

		onOpenComplete(result);
		#end
	}

	#if (sys && !hl)
	function onOpenComplete(arr:Array<String>) {
		if (arr != null && arr.length > 0) {
			FlxG.switchState(new NoteOffsetState(cast Json.parse(Paths.getText(arr[0])).song));
		}
	}
	#end

    function saveFile() {
        #if (sys && !hl)
        var filters:FILEFILTERS = {
			count: 1,
			descriptions: ["JSON Files (*.json)"],
			extensions: ["*.json"]
		};
		var result:String = Dialogs.saveFile("Save chart", "", Sys.getCwd(), filters);
        if (result != null && !result.endsWith('.json')) {
            result = '$result.json';
        }
        if (result != null) {
            onSaveComplete(result);
        }
        #end
    }

    function onSaveComplete(file:String) {
        #if (sys && !hl)
        var path:Array<String> = file.split('\\');
        var file:String = path[path.length - 1];
        var folder:String = '';
        for (i in 0...path.length) {
            if (path[i] != file) {
                folder += '${path[i]}/';
            }
        }
        
        if (!FileSystem.exists(folder)) {
            FileSystem.createDirectory(folder);
        }

        for (i in 0...notes.length) {
            var note = notes[i];
            var daNote:String = '{\n"time": ${note.time},\n"id": ${note.id}\n}';
            noteStrings.push(daNote);
        }

        File.saveContent('$folder/$file', '{
    "bpm": ${bpmInputText.inputText}, 
    "speed": ${speedInputText.inputText}, 
    "song": "${songInputText.inputText}", 
    "notes": $noteStrings, 
    "events": []
}');
        #end
    }
}