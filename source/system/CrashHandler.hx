package system;

import flixel.FlxG;
import native.DiscordClient;
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;

using StringTools;

enum abstract ErrorCode(Int) {
    var NULLOBJECTREFERENCE = 0;
    var UNKNOWN = -1;
    var INVALIDJSON = 2;
    var NULLFUNCTIONPOINTER = 3;
    var INVALIDFILE = 4;
    var INVALIDLIBRARY = 5;
    var INVALIDHSCRIPT = 6;
}

class CrashHandler {
    public static function onCrash(e:UncaughtErrorEvent) {
        #if CRASH_HANDLER
        var errorCode:ErrorCode = resolveCode(e.error);

        var errMsg:String = 'Error Code: $errorCode';
        #if RELEASED
        errMsg += "\n\nPlease report this error to the GitHub page:\nhttps://github.com/h4master/another-rhythm-game";
        #else
        errMsg += "\n\n" + e.error;
        #end

        Application.current.window.alert(errMsg, "HaxeFlixel/AnotherRhythmGame");

        DiscordClient.closeSession();
        #if RELEASED
        FlxG.openURL("https://github.com/h4master/another-rhythm-game");
        #end
		Sys.exit(1);
        #end
    }

    public static function initCrash(e:String, code:ErrorCode) {
        #if CRASH_HANDLER
        var errMsg:String = 'Error Code: $code';
        #if RELEASED
        errMsg += "\n\nPlease report this error to the GitHub page:\nhttps://github.com/h4master/another-rhythm-game";
        #else
        errMsg += "\n\n" + e;
        #end

        lime.app.Application.current.window.alert(errMsg, "HaxeFlixel/AnotherRhythmGame");

        DiscordClient.closeSession();
        #if RELEASED
        FlxG.openURL("https://github.com/h4master/another-rhythm-game");
        #end
		Sys.exit(1);
        #end
    }

    static function resolveCode(error:Dynamic) {
        var error:String = Std.string(error).toLowerCase();

        return {
            if (error == "null object reference")
                NULLOBJECTREFERENCE;
            else if (error.startsWith("invalid char"))
                INVALIDJSON;
            else if (error == "null function pointer")
                NULLFUNCTIONPOINTER;
            else if (error.startsWith("hscript"))
                INVALIDHSCRIPT;
            else
                UNKNOWN;
        }
    }
}