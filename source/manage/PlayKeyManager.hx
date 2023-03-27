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
            FlxG.switchState(new NoteOffsetState(PlayState.songName));
            FlxG.sound.music.stop();
        }

        if (justPressed.ESCAPE)
        {
            FlxG.switchState(new MainMenuState());
            FlxG.sound.music.stop();
        }

        if (justPressed.W)
            Settings.openWindow();

        if (justPressed.S)
        {
            FlxG.switchState(new Settings.SetState());
            FlxG.sound.music.stop();
        }

        // the sexiest easter egg code
        if (pressed.NUMPADONE && pressed.NUMPADTHREE && pressed.NUMPADSIX && pressed.NUMPADEIGHT && FlxG.random.bool(0.01))
        {
            FlxG.switchState(new TicTacToe());
            FlxG.sound.music.stop();
        }
    }
}