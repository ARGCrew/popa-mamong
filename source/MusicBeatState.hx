package;

import controls.PlayerSettings;
import controls.Controls;

import openfl.filters.BitmapFilter;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState {
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var controls(get, never):Controls;
	var overlay:SoundOverlay;

	private var cameraFilters:Array<BitmapFilter> = [];

	inline function get_controls():Controls
		return PlayerSettings.current.controls;

	public function new(hasOverlay:Bool = true) {
		super();

		overlay = new SoundOverlay();
		if (hasOverlay) {
			insert(9999, overlay);
		}
	}

	override function update(elapsed:Float) {
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0) {
			stepHit();
		}

		if (FlxG.keys.justPressed.F11) {
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		FlxG.camera.setFilters(cameraFilters);

		super.update(elapsed);
	}

	private function updateBeat() {
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep() {
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length) {
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime) {
				lastChange = Conductor.bpmChangeMap[i];
			}
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit() {
		if (curStep % 4 == 0) {
			beatHit();
		}
	}

	public function beatHit() {}
}
