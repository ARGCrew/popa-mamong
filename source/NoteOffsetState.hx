package;

import haxe.Json;
import UIButtons.UIButton;
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

    var curID:Int = 0;

    public function new(music:String) {
        super();
        FlxG.sound.playMusic(Paths.music(music));
        FlxG.sound.music.pause();
        trace(music);
    }

    override function create() {
        butts = new ButtonGrid(-(FlxG.width / 5));
        add(butts);

        var openButt:UIButton = new UIButton((FlxG.width / 6) * 5, FlxG.height / 2, "LOAD");
        openButt.onPress = function() {
            openFile();
        }
        add(openButt);

        var saveButt:UIButton = new UIButton(openButt.x - 110, openButt.y, "SAVE");
        saveButt.onPress = function() {
            saveFile();
        }
        add(saveButt);

        var line:FlxSprite = new FlxSprite((FlxG.width / 3) * 2, FlxG.height / 3).makeGraphic(Std.int(FlxG.width / 4), 5, FlxColor.WHITE);
        add(line);

        var vertical:FlxSprite = new FlxSprite(line.x + line.width / 2 - 2.5, line.y - 30).makeGraphic(5, 65, FlxColor.WHITE);
        add(vertical);

        super.create();
    }

    override function update(elapsed:Float) {
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

        super.update(elapsed);
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
        if (!result.endsWith('.json')) {
            result = '$result.json';
        }
        onSaveComplete(result);
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
        File.saveContent('$folder/$file', "");
        #end
    }
}