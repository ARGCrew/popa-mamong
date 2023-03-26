package;

import sys.io.File;
import haxeparser.HaxeParser;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.ui.FlxUIState;

class PlayState extends FlxUIState
{
    //BUTTONS
    var butts:FlxTypedGroup<FlxSprite>;

    // CUSTOM LEVELS
    public static var instance:PlayState;
    var hscript:HaxeParser = null;
    public var level:String = 'default';

    // CHARTS
    public var notes:Array<Dynamic> = [
        [0, 0, '']
    ];
    public static var songName:String = 'MOLLY';
    public static var curDifficulty:String = 'normal';

    override function create()
    {
        persistentDraw = persistentUpdate = true;

        Palette.parse('assets/palette.txt');

        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, Palette.bg));
        
        butts = new FlxTypedGroup<FlxSprite>();
        add(butts);
        for (i in 0...9) butts.add(new Button(i, Settings.skin));

        parseChart(songName, curDifficulty);

        super.create();

        instance = this;
        hscript = new HaxeParser('assets/maps/$level.hx');
        hscript.addCallback('this', instance);
        hscript.callFunction('create', []);
    }

    override function update(elapsed)
    {
        var justPressed = FlxG.keys.justPressed;
        var pressed = FlxG.keys.pressed;

        if (justPressed.SEVEN)
            FlxG.switchState(new NoteOffsetState(songName));

        if (justPressed.ESCAPE)
            FlxG.switchState(new InitialState());

        // the sexiest easter egg code
        if (pressed.NUMPADONE && pressed.NUMPADFIVE && pressed.NUMPADSIX && pressed.NUMPADEIGHT)
            if (FlxG.random.bool(0.01)) FlxG.switchState(new TicTacToe());

        super.update(elapsed);

        hscript.callFunction('update', [elapsed]);
    }

    function parseChart(music:String, difficulty:String = 'normal')
    {
        var raw:Array<String> = File.getContent('assets/charts/$music/$difficulty.txt').split('\n');
        for (i in raw)
        {
            var note = i.split(' ');
            notes.push([Std.parseInt(note[0]), Std.parseFloat(note[1]), note[2]]);
            trace('' + Std.parseInt(note[0]) + ', ' + Std.parseFloat(note[1]) + ', ' + note[2]);
        }
    }
}
