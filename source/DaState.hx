import flixel.FlxG;
import states.PlayState;
import utils.Conductor;
import system.controls.PlayerSettings;
import system.controls.Controls;
import flixel.addons.transition.FlxTransitionableState;

class DaState extends FlxTransitionableState {
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
    
    private var controls(get, never):Controls;
    private function get_controls()
        return PlayerSettings.current.controls;

    override function create() {
        persistentUpdate = persistentDraw = true;
		
        super.create();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;

        var oldStep:Int = curStep;
        updateCurStep();
		updateBeat();
        if (oldStep != curStep) {
			if(curStep > 0) stepHit();

			if(PlayState.SONG != null) {
                (oldStep < curStep) ? updateSection() : rollbackSection();
			}
		}

        if (FlxG.keys.justPressed.F)
            FlxG.fullscreen = !FlxG.fullscreen;
    }

    private function updateSection() {
        if (stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while (curStep >= stepsToDo) {
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
    }

    private function rollbackSection() {
		if (curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length) {
			if (PlayState.SONG.notes[i] != null) {
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

    private function updateBeat() {
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

    private function updateCurStep() {
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - Preference.misc.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

    public function stepHit() {
		if (curStep % 4 == 0) beatHit();
	}

	public function beatHit() {}

	public function sectionHit() {}

	function getBeatsOnSection() {
		var val:Null<Float> = 4;
		if (PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].beats;
		return val == null ? 4 : val;
	}
}