package;

import flixel.system.FlxSound;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.FlxG;
import hxAddons.HxBitmapSprite;

class Button extends HxBitmapSprite
{
    public var id:Int = 0;
    public var skin:String;

    public function new(id:Int, skin:String)
    {
        super();
        this.id = id;
        this.skin = skin;

        var offsetX:Float = 400;
        var offsetY:Float = 125;

        var spaceX:Float = 20;
        var spaceY:Float = 20;

        loadBitmap(Paths.image('buttons/$skin'));
        setGraphicSize(Std.int(width * 0.7));
        updateHitbox();
        antialiasing = true;
        color = Palette.released;

        switch(id)
        {
            case 0: setPosition(offsetX, offsetY);
            case 1: setPosition(offsetX + spaceX + width, offsetY);
            case 2: setPosition(offsetX + (spaceX + width) * 2, offsetY);
            case 3: setPosition(offsetX, offsetY + spaceY + height);
            case 4: setPosition(offsetX + spaceX + width, offsetY + spaceY + height);
            case 5: setPosition(offsetX + (spaceX + width) * 2, offsetY + spaceY + height);
            case 6: setPosition(offsetX, offsetY + (spaceY + height) * 2);
            case 7: setPosition(offsetX + spaceX + width, offsetY + (spaceY + height) * 2);
            case 8: setPosition(offsetX + (spaceX + width) * 2, offsetY + (spaceY + height) * 2);
        }
    }

    public function keyPress()
    {
        if (active)
        {
            if (FlxG.sound.music != null && FlxG.sound.music.playing)
            {
                if (PlayState.instance.notes[0][0] == id)
                {
                    if (PlayState.instance.notes[0][0][1] == FlxG.sound.music.time)
                    {
                        color = Palette.confirmed;
                        PlayState.instance.notes.shift();
                        //Sound.fromFile('assets/sounds/Pressed.ogg').play();
                        var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Pressed')).play();
                        sound.volume = Settings.getSoundVolume();
                    }
                    else
                    {
                        color = Palette.pressed;
                        //Sound.fromFile('assets/sounds/Miss.ogg').play();
                        var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Miss')).play();
                        sound.volume = Settings.getSoundVolume();
                    }
                }
            }
            else
            {
                if (FlxG.keys.pressed.F)
                {
                    color = Palette.confirmed;
                    //Sound.fromFile('assets/sounds/Pressed.ogg').play();
                    var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Pressed')).play();
                    sound.volume = Settings.getSoundVolume();
                }
                else
                {
                    color = Palette.pressed;
                    //Sound.fromFile('assets/sounds/Miss.ogg').play();
                    var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Miss')).play();
                    sound.volume = Settings.getSoundVolume();
                }
            }
        }
    }

    override function update(elapsed:Float)
    {
        var press = FlxG.keys.justPressed;
        var release = FlxG.keys.justReleased;

        switch(id)
        {
            case 0:
                if (press.NUMPADSEVEN)
                    keyPress();
                if (release.NUMPADSEVEN)
                    color = Palette.released;
            case 1:
                if (press.NUMPADEIGHT)
                    keyPress();
                if (release.NUMPADEIGHT)
                    color = Palette.released;
            case 2:
                if (press.NUMPADNINE)
                    keyPress();
                if (release.NUMPADNINE)
                    color = Palette.released;
            case 3:
                if (press.NUMPADFOUR)
                    keyPress();
                if (release.NUMPADFOUR)
                    color = Palette.released;
            case 4:
                if (press.NUMPADFIVE)
                    keyPress();
                if (release.NUMPADFIVE)
                    color = Palette.released;
            case 5:
                if (press.NUMPADSIX)
                    keyPress();
                if (release.NUMPADSIX)
                    color = Palette.released;
            case 6:
                if (press.NUMPADONE)
                    keyPress();
                if (release.NUMPADONE)
                    color = Palette.released;
            case 7:
                if (press.NUMPADTWO)
                    keyPress();
                if (release.NUMPADTWO)
                    color = Palette.released;
            case 8:
                if (press.NUMPADTHREE)
                    keyPress();
                if (release.NUMPADTHREE)
                    color = Palette.released;
        }
    }
}