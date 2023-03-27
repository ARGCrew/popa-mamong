package;

import ChartFragment.ChartFrag;
import haxe.Json;
import haxe.format.JsonParser;
import sys.io.File;

using StringTools;

typedef Music =
{
	var notes:Array<ChartFrag>;
	var bpm:Int;
	var speed:Float;

	var validScore:Bool;
}

class MusicBeat
{
	public var notes:Array<ChartFrag>;
	public var bpm:Int;
	public var speed:Float = 1;

	public function new(notes, bpm)
	{
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):Music
	{
		var rawJson = File.getContent(Paths.chart(folder, jsonInput));

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):Music
	{
		var swagShit:Music = cast Json.parse(rawJson);
		swagShit.validScore = true;
		return swagShit;
	}
}
