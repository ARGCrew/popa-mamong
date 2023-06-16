package hscript;

import system.assets.Paths;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import states.PlayState;

class HScript {
    #if HSCRIPT
    private var interp:Interp = new Interp();
    private var parser:Parser = new Parser();

    private var exclusions:Array<String> = [];
    public var variables(get, never):Dynamic;
    public function get_variables() {
        var returnValue:Dynamic = {};
        for (field in interp.variables.keys()) {
            if (!exclusions.contains(field))
                Reflect.setProperty(returnValue, field, interp.variables[field]);
        }
        return returnValue;
    }
    #end

    public function new(script:String) {
        #if HSCRIPT
        if (Paths.exists(script))
            interp.execute(parser.parseString(Paths.text(script)));

        /*set("require", function(lib:String, as:String = null) {
            var libArray:Array<String> = lib.split(".");
            var libPackage:String = "";
            while (libArray.length > 1) {
                libPackage += libArray[0] + (libArray.length > 2 ? "." : "");
                libArray.shift();
            }
            var libName:String = (as != null) ? as : libArray[0];

            set(libName, Type.resolveClass('$libPackage.$libName'));
        });*/

        set("screenWidth", FlxG.width);
        set("screenHeight", FlxG.height);
        set("Paths", Paths);

        set("RuntimeSprite", RuntimeSprite);
        set("RuntimeText", RuntimeText);
        set("RuntimeTween", FlxTween);
        set("RuntimeTimer", FlxTimer);

        set("PlayState", PlayState);
        set("game", PlayState.instance);
        #end
    }

    public function set(name:String, func:Dynamic) {
        #if HSCRIPT
        exclusions.push(name);
        interp.variables.set(name, func);
        #end
    }

    public function call(event:String, args:Array<Dynamic>) {
        #if HSCRIPT
        if (interp.variables.exists(event))
            return Reflect.callMethod(this, interp.variables[event], args);
        else
            return;
        #end
    }
}

class RuntimeSprite extends FlxSprite {
    public function add()
        PlayState.instance.add(this);

    public function insert(pos:Int)
        PlayState.instance.insert(pos, this);
}

class RuntimeText extends FlxText {
    public function add()
        PlayState.instance.add(this);

    public function insert(pos:Int)
        PlayState.instance.insert(pos, this);
}