package flixel.custom.system;

import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import lime.app.Application;
import openfl.Lib;
import openfl.display.Sprite;

using StringTools;

class FlxCrashHandler extends Sprite
{
    public function new()
    {
        super();
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
    }

    function onCrash(e:UncaughtErrorEvent)
    {
        var name:String = Application.current.window.title;
        name = name.replace(' ', '-');

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

        Application.current.window.alert(errMsg, 'FlixelCrashHandler/$name');
        Sys.exit(1);
    }
}