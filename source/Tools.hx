package;

import flixel.FlxG;
import flixel.FlxState;

class Tools
{
    public static var curState:FlxState = null;
    public static var curStateName:String = null;

    public static function switchState(nextState:Class<Dynamic>, args:Array<Dynamic> = null)
    {
        var stateStuff = null;
        if (args == null)
            stateStuff = Type.createInstance(nextState, []);
        else
            stateStuff = Type.createInstance(nextState, args);

        FlxG.switchState(stateStuff);
        curState = stateStuff;

        curStateName = Type.getClassName(nextState);
    }

    public static function setState(nextState:Class<Dynamic>, args:Array<Dynamic> = null)
    {
        var stateStuff = null;
        if (args == null)
            stateStuff = Type.createInstance(nextState, []);
        else
            stateStuff = Type.createInstance(nextState, args);

        curState = stateStuff;
        curStateName = Type.getClassName(nextState);
    }

    public static function output(string:String)
    {
        Sys.println('$curStateName: $string');
    }
}