package;

import controls.PlayerSettings;
import flixel.FlxG;
import flixel.FlxSprite;

class Button extends FlxSprite {
    public var id:Int = 0;
    public var skin:String;
    
    private var overlap:Bool = false;

    private var binds:Map<Int, String> = [
        0 => 'SEVEN',
        1 => 'EIGHT',
        2 => 'NINE',
        3 => 'FOUR',
        4 => 'FIVE',
        5 => 'SIX',
        6 => 'ONE',
        7 => 'TWO',
        8 => 'THREE'
    ];

    public function new(id:Int, skin:String) {
        super();
        this.id = id;
        this.skin = skin;

        var offsetX:Float = 400;
        var offsetY:Float = 125;

        var spaceX:Float = 20;
        var spaceY:Float = 20;

        loadGraphic(Paths.image('buttons/${skin.toUpperCase()}'));
        updateHitbox();
        color = Palette.released;

        switch(id) {
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

    override function update(elapsed:Float) {
        if (Reflect.getProperty(PlayerSettings.current.controls, '${binds.get(id)}_P') && PlayState.daPlaying) {
            PlayState.instance.checkHit(this);
        }
        if (Reflect.getProperty(PlayerSettings.current.controls, '${binds.get(id)}_R') && PlayState.daPlaying) {
            PlayState.instance.release(this);
        }

        if (FlxG.mouse.x > x && FlxG.mouse.x < x + width &&
            FlxG.mouse.y > y && FlxG.mouse.y < y + height) {
            if (FlxG.mouse.justPressed && PlayState.daPlaying) {
                color = Palette.pressed;
                PlayState.instance.checkHit(this);
            }
            if (FlxG.mouse.justReleased && PlayState.daPlaying) {
                PlayState.instance.release(this);
            }
            overlap = true;
        }
        else {
            if (overlap && PlayState.daPlaying) {
                PlayState.instance.release(this);
            }
            overlap = false;
        }
    }
}