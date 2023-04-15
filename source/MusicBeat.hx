package;

import Note;
import haxe.Json;
import haxe.format.JsonParser;

#if sys
import sys.io.File;
#else
import lime.utils.Assets;
#end

using StringTools;

typedef Music = {
	var notes:Array<NoteMap>;
	var events:Array<EventMap>;
	var bpm:Int;
	var speed:Float;
	var song:String;

	var validScore:Bool;
}

class MusicBeat {
	public var notes:Array<NoteMap>;
	public var bpm:Int;
	public var speed:Float = 1;

	public function new(notes, bpm) {
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):Music {
		var rawJson = #if sys File.getContent #else Assets.getText #end (Paths.chart(folder, jsonInput));

		while (!rawJson.endsWith("}")) {
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):Music {
		var swagShit:Music = cast Json.parse(rawJson);
		swagShit.validScore = true;
		return swagShit;
	}
}
