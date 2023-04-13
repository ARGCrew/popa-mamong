package haxeparser;

#if sys
import sys.io.File;
#else
import lime.utils.Assets;
#end
import hscript.*;

class HaxeParser
{
    public static var parser:Parser = new Parser();
	public var interp:Interp = new Interp();

    public var callFunction:Dynamic = null;
    public var addCallback:Dynamic = null;

    public function new(path:String) {
        @:privateAccess
		parser.line = 1;
		parser.allowTypes = true;
        #if sys
        interp.execute(parser.parseString(File.getContent(path)));
        #else
		interp.execute(parser.parseString(Assets.getText(path)));
        #end

        callFunction = interp.variables.get;
        addCallback = interp.variables.set;

        for (lib in ['StringTools', 'Std', 'Reflect', 'Type', 'Paths'])
            addCallback(lib, Type.resolveClass(lib));

        addCallback('import', function(lib:String, like:String) {
            var libPack:Array<String> = lib.split('.');
			var libName:String = libPack[libPack.length - 1];
			
			if (like != null && like != '')
				libName = like;

			try
				addCallback(libName, Type.resolveClass(lib));
        });

        if (hasFunction('init')) {
            callFunction('init')(path);
        }
    }

    public function hasFunction(event:String):Bool {
        return interp.variables.exists(event);
    }
}