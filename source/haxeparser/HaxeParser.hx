package haxeparser;

import hscript.*;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
#end

class HaxeParser {
    public static var parser:Parser = new Parser();
	public var interp:Interp = new Interp();

    public var variables(get, never):Map<String, Dynamic>;
    public function get_variables() {
		return interp.variables;
	}

    public function new(path:String) {
        @:privateAccess
		parser.line = 1;
		parser.allowTypes = true;
        #if sys 
        if (FileSystem.exists(path))
            interp.execute(parser.parseString(File.getContent(path)));
        #else
        if (OpenFlAssets.exists(path))
		    interp.execute(parser.parseString(Assets.getText(path)));
        #end

        for (lib in ['StringTools', 'Std', 'Reflect', 'Type']) {
            addCallback(lib, Type.resolveClass(lib));
        }

        addCallback('import', function(lib:String, like:String) {
            var libPack:Array<String> = lib.split('.');
			var libName:String = libPack[libPack.length - 1];
			
			if (like != null && like != '')
				libName = like;

			try
				addCallback(libName, Type.resolveClass(lib));
        });
    }

    public function callFunction(event:String, args:Array<Dynamic>) {
        if (!variables.exists(event)) {
            return;
        }
        var method = variables.get(event);
        switch(args.length) {
            case 0:
                method();
            case 1:
                method(args[0]);
            case 2:
                method(args[0], args[1]);
            case 3:
                method(args[0], args[1], args[2]);
            case 4:
                method(args[0], args[1], args[2], args[3]);
            case 5:
                method(args[0], args[1], args[2], args[3], args[4]);
        } // WOWOWOOWOWOOWOWOWOOWWOWOWWWOOWOOOWOWOWOWOOWOWOWOWOWOWOOWOWOWOWOWOOWOWOWOWOWOWOWO
    }

    public function addCallback(name:String, value:Dynamic) {
        interp.variables.set(name, value);
    }
}