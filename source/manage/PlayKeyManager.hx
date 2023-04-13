package manage;

import flixel.FlxG;

class PlayKeyManager {
    public static function manage() {
        var justPressed = FlxG.keys.justPressed;
        var pressed = FlxG.keys.pressed;

        if (justPressed.ESCAPE) {
            FlxG.switchState(new MainMenuState());
            FlxG.sound.music.stop();
        }
        if (justPressed.W) {
            Settings.openWindow();
        }
        if (justPressed.S) {
            FlxG.switchState(new SettingsState(true));
            FlxG.sound.music.stop();
        }
        if (justPressed.B) {
            PlayState.instance.botplay = !PlayState.instance.botplay;
        }
        if (justPressed.C) {
            FlxG.switchState(new NoteOffsetState(PlayState.songName));
        }
    }
}