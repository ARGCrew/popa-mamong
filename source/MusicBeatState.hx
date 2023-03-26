package;

import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
    private var curBeat:Int = 0;
    
    public function new()
    {
        super();
        Conductor.changeBPM(Conductor.defaultBpm);
    }

    override function update(elapsed:Float)
    {
        updateBeat();
        super.update(elapsed);
    }

    private function updateBeat()
    {
        curBeat != 0 ? {
            if (Std.int((60 / Conductor.curBpm) / curBeat) % Conductor.curBpm == 0)
                beatHit();
        } : {
            if (60 / Conductor.curBpm % Conductor.curBpm == 0)
                beatHit();
        }
    }

    private function beatHit()
    {
        curBeat ++;
        trace(Std.string(curBeat));
    }
}