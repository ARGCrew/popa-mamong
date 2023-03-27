package flixel.custom.system;

#if desktop
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import lime.app.Application;
import openfl.Lib;
#end
import openfl.display.Sprite;

using StringTools;

class FlxCrashHandler extends Sprite
{
    #if desktop
    public function new()
    {
        super();
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
    }

    function onCrash(e:UncaughtErrorEvent)
    {
        var name:String = format("Another Rhythm Game");

        var errMsg:String = "";

        var callStack:Array<StackItem> = CallStack.exceptionStack(true);
        for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
                default:
					Sys.println(stackItem);
			}
            
		}
        errMsg += '\nUncaught Error: ${e.error}';

        errMsg += '\n\nPlease report this error to the GitHub page: https://github.com/h4master/another-rythm-game';

        Application.current.window.alert(errMsg, 'FlixelCrashHandler/$name');
        Sys.exit(1);
    }

    function format(string:String):String
    {
        var ret:String = string;
        ret = ret.replace(' ', '-');
        ret = ret.replace("'", '');
        return ret;
    }
    #else
    public function new() {
        super();
    }
    #end
}