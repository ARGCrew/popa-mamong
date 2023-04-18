package haxeparser;

import flixel.custom.system.FlxCrashHandler;
#if sys
import sys.io.File;
#else
import lime.utils.Assets;
#end
import hscript.*;

using StringTools;

class HaxeParser
{
    public static var parser:Parser = new Parser();
	public var interp:Interp = new Interp();

    public var callFunction:Dynamic = null;
    public var addCallback:Dynamic = null;

    private var importStuff:Map<String, String> = [
        "StringTools" => "StringTools",
        "Std" => "Std",
        "Reflect" => "Reflect",
        "Type" => "Type",
        "Paths" => "Paths"
    ];

    public function new(path:String) {
        var fullHx:String = #if sys File.getContent #else Assets.getText #end (path);
/*
        while (rawHx.length > 0) {
            var line = rawHx[0];

            if (line.startsWith("import")) {
                fullHx = fullHx.replace('$line;', "");
                var toImport:String = line.replace("import", "").replace(" ", "").replace(";", "");

                var libStuff:Array<String> = toImport.split(".");
                var libLike:String = libStuff[libStuff.length - 1];

                if (toImport.contains(" as ")) {
                    libLike = toImport.split(" as ")[1];
                }

                importStuff.set(libLike, toImport);
            }

            rawHx.shift();
        }
*/
        var parseHx:String = fullHx.replace("\n", "");
        var rawHx:Array<String> = parseHx.split(";");
        for (line in rawHx) {
            if (line.replace("\n", "").startsWith("import")) {
                fullHx = fullHx.replace('$line;', "");
                var toImport:String = line.replace("import", "").replace(" ", "").replace(";", "");

                var libStuff:Array<String> = toImport.split(".");
                var libLike:String = libStuff[libStuff.length - 1];

                if (toImport.contains(" as ")) {
                    libLike = toImport.split(" as ")[1];
                }

                importStuff.set(libLike, toImport);
            }
        }

        trace(fullHx);

        @:privateAccess
		parser.line = 1;
		parser.allowTypes = true;
        /*try*/ {
            #if sys
            interp.execute(parser.parseString(fullHx));
            #else
            interp.execute(parser.parseString(fullHx));
            #end
        }
        /*catch(e) {
            FlxCrashHandler.alert("Error on HScript!", e);
        }*/

        callFunction = interp.variables.get;
        addCallback = interp.variables.set;

        for (lib in ImportList.get().keys()) {
            importStuff.set(lib, ImportList.get()[lib]);
        }

        for (lib in importStuff.keys()) {
            addCallback(lib, Type.resolveClass(importStuff[lib]));
        }

        if (hasFunction('init')) {
            callFunction('init')(path);
        }
    }

    public function hasFunction(event:String):Bool {
        return interp.variables.exists(event);
    }
}