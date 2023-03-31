package manage;

import flixel.FlxG;

class PlayKeyManager
{
    public static function manage()
    {
        var justPressed = FlxG.keys.justPressed;
        var pressed = FlxG.keys.pressed;

        if (justPressed.SEVEN)
        {
            Tools.switchState(NoteOffsetState, [PlayState.songName]);
            FlxG.sound.music.stop();
        }

        if (justPressed.ESCAPE)
        {
            Tools.switchState(MainMenuState);
            FlxG.sound.music.stop();
        }

        if (justPressed.W)
            Settings.openWindow();

        if (justPressed.S)
        {
            Tools.switchState(SettingsState, [true]);
            FlxG.sound.music.stop();
        }

        // the sexiest easter egg code
        if (pressed.NUMPADONE && pressed.NUMPADTHREE && pressed.NUMPADSIX && pressed.NUMPADEIGHT && FlxG.random.bool(0.01))
        {
            Tools.switchState(TicTacToe);
            FlxG.sound.music.stop();
        }
    }
}