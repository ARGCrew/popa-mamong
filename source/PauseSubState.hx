package;

import flixel.FlxG;

class PauseSubState extends MusicBeatSubState {
    override function update(elapsed:Float) {
        changePresence("Paused", '${PlayState.songName} (${PlayState.curDifficulty})');
    }
}