package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class LuaManage {
    /*
    public var sprites:Map<String, FlxSprite> = [];
    public var texts:Map<String, FlxText> = [];
    public var tweens:Map<String, FlxTween> = [];
    */
    public var objects:Map<Int, Dynamic> = [];
    public var tweens:Map<Int, FlxTween> = [];
    public var timers:Map<Int, FlxTimer> = [];

    private var lua:LuaSupport;

    public function new(script:String) {
        lua = new LuaSupport(script, this);
    }

    public function call(func:String, args:Array<Dynamic>) {
        lua.call(func, args);
    }
}