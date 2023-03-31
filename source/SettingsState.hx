package;

import flixel.FlxG;
import flixel.addons.ui.FlxUICheckBox;

class SettingsState extends MusicBeatState
{
    var daPlaying:Bool;

    public function new(game:Bool)
    {
        super();
        daPlaying = game;
    }

    override function create()
    {
        var circleCheckBox:FlxUICheckBox = new FlxUICheckBox(10, 10, null, null, "Circle Buttons", 100);
        circleCheckBox.checked = (Settings.skin == 'circle');
        circleCheckBox.callback = function() {
            circleCheckBox.checked ? {
                Settings.skin = 'circle';
            } : {
                Settings.skin = 'square';
            }
		}
        add(circleCheckBox);

        var beatCheckBox:FlxUICheckBox = new FlxUICheckBox(10, 40, null, null, "Camera Beat", 100);
        beatCheckBox.checked = Settings.camBeat;
        beatCheckBox.callback = function() {
            Settings.camBeat = beatCheckBox.checked;
		}
        add(beatCheckBox);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ESCAPE)
        {
            daPlaying ? {
                Tools.switchState(PlayState);
            } : {
                Tools.switchState(MainMenuState);
            }
        }
        super.update(elapsed);
    }

    override function destroy()
    {
        Settings.save();
        super.destroy();
    }
}