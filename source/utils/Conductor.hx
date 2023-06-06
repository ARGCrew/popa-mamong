package utils;

import system.song.Song;

typedef BPMChangeEvent = {
    var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
    @:optional var stepCrochet:Float;
}

class Conductor {
    @:isVar public static var bpm(get, set):Float = 100;
    public static function get_bpm() return bpm;
    private static function set_bpm(value:Float) return bpm = value;

    public static var crochet:Float = (60 / bpm) * 1000;
    public static var stepCrochet:Float = crochet / 4;
    public static var songPosition:Float = 0;
	public static var lastSongPos:Float;
	public static var offset:Float = 0;

    public static var safeZoneOffset:Float = (Preference.misc.safeFrames * 60) / 1000;

    public static var bpmChangeMap:Array<BPMChangeEvent> = [];
    
    public static function getCrotchetAtTime(time:Float) {
		var lastChange = getBPMFromSeconds(time);
		return lastChange.stepCrochet*4;
	}

    public static function getBPMFromSeconds(time:Float) {
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: bpm,
			stepCrochet: stepCrochet
		}
		for (i in 0...bpmChangeMap.length) {
			if (time >= bpmChangeMap[i].songTime) lastChange = bpmChangeMap[i];
		}

		return lastChange;
	}

    public static function getBPMFromStep(step:Float) {
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: bpm,
			stepCrochet: stepCrochet
		}
		for (i in 0...bpmChangeMap.length) {
			if (bpmChangeMap[i].stepTime <= step) lastChange = bpmChangeMap[i];
		}

		return lastChange;
	}

    public static function beatToSeconds(beat:Float) {
		var step = beat * 4;
		var lastChange = getBPMFromStep(step);
		return lastChange.songTime + ((step - lastChange.stepTime) / (lastChange.bpm / 60) / 4) * 1000;
	}

    public static function getStep(time:Float) {
		var lastChange = getBPMFromSeconds(time);
		return lastChange.stepTime + (time - lastChange.songTime) / lastChange.stepCrochet;
	}

    public static function getStepRounded(time:Float) {
		var lastChange = getBPMFromSeconds(time);
		return lastChange.stepTime + Math.floor(time - lastChange.songTime) / lastChange.stepCrochet;
	}

    public static function getBeat(time:Float) return getStep(time)/4;

    public static function getBeatRounded(time:Float) return Math.floor(getStepRounded(time) / 4);

    public static function mapBPMChanges(song:SongData)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length)
		{
			if(song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM,
					stepCrochet: calculateCrochet(curBPM)/4
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = Math.round(getSectionBeats(song, i) * 4);
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace("new BPM map BUDDY " + bpmChangeMap);
	}

    static function getSectionBeats(song:SongData, section:Int) {
		var val:Null<Float> = null;
		if(song.notes[section] != null) val = song.notes[section].beats;
		return val != null ? val : 4;
	}

    inline public static function calculateCrochet(bpm:Float) return (60/bpm)*1000;

    public static function changeBPM(newBpm:Float) {
		bpm = newBpm;

		crochet = calculateCrochet(bpm);
		stepCrochet = crochet / 4;
	}
}