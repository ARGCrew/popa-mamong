package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;

import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;

using StringTools;

class LuaSupport {
    public var lua:State = null;
    private var par:LuaManage = null;

    private var objects:Int = 0;
    private var tweens:Int = 0;
    private var timers:Int = 0;

    public function new(script:String, parrent:LuaManage) {
        lua = LuaL.newstate();
        par = parrent;
        LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

        try{
			var result:Dynamic = LuaL.dofile(lua, script);
			var resultStr:String = Lua.tostring(lua, result);
			if(resultStr != null && result != 0) {
				#if windows
                flixel.custom.system.FlxCrashHandler.alert(resultStr);
				#end
				lua = null;
				return;
			}
		} catch(e:Dynamic) {
			return;
		}

        addCallback("getObjectProperty", function(obj:Dynamic, prop:String) {
            var object:Dynamic = null;
            if (par.objects.exists(obj)) {
                object = par.objects[obj];
            } else {
                object = Reflect.getProperty(instance(), obj);
            }
            return Reflect.getProperty(object, prop);
        });
        addCallback("setObjectProperty", function(obj:Dynamic, prop:String, val:Dynamic) {
            var object:Dynamic = null;
            if (par.objects.exists(obj)) {
                object = par.objects[obj];
            } else {
                object = Reflect.getProperty(instance(), obj);
            }
            Reflect.setProperty(object, prop, val);
        });

        addCallback("getProperty", function(prop:String) {
            return Reflect.getProperty(instance(), prop);
        });
        addCallback("setProperty", function(prop:String, val:Dynamic) {
            Reflect.setProperty(instance(), prop, val);
        });

        addCallback("getClassProperty", function(type:String, prop:String) {
            return Reflect.getProperty(Type.resolveClass(type), prop);
        });
        addCallback("setClassProperty", function(type:String, prop:String, val:Dynamic) {
            Reflect.setProperty(Type.resolveClass(type), prop, val);
        });

        addCallback("luaSprite", function(X:Float = 0, Y:Float = 0):Dynamic {
            var sprite = new FlxSprite(X, Y);
            par.objects.set(objects, sprite);

            var retVal:Dynamic = {
                id: objects,
                x: X, y: Y,
                scrollX: sprite.scrollFactor.x, scrollY: sprite.scrollFactor.y,
                alpha: sprite.alpha, angle: sprite.angle
            };
            objects ++;
            return retVal;
        });
        addCallback("spriteLoadGraphic", function(spr:Int, texture:String) {
            var sprite:FlxSprite = null;
            if (par.objects.exists(spr)) {
                sprite = par.objects[spr];
                sprite.loadGraphic(Paths.image(texture));
            }
        });
        addCallback("spriteMakeGraphic", function(spr:Int, width:Float, height:Float, color:String) {
            var sprite:FlxSprite = null;
            if (par.objects.exists(spr)) {
                sprite = par.objects[spr];
                sprite.makeGraphic(Std.int(width), Std.int(height), FlxColor.fromString(color));
            }
        });
        addCallback("spriteLoadFrames", function(spr:Int, texture:String, type:String = "sparrow") {
            var sprite:FlxSprite = null;
            if (par.objects.exists(spr)) {
                sprite = par.objects[spr];
                switch(type.toLowerCase()) {
                    case 'sparrow':
                        sprite.frames = Paths.sparrowAtlas(texture);
                }
            }
        });

        addCallback("luaText", function(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, Text:String, Size:Int = 8) {
            var id = objects;
            var text:FlxText = new FlxText(X, Y, FieldWidth, Text, Size);
            par.objects.set(id, text);

            objects ++;
            return id;
        });
        addCallback("textSetFormat", function(txt:Int, Size:Int = 8, Color:String = "0xffFFFFFF", Alignment:String, BorderStyle:String,
        BorderColor:String = "0x00000000") {
            var text:FlxText = null;
            if (par.objects.exists(txt)) {
                text = par.objects[txt];
                text.setFormat(Paths.font, Size, FlxColor.fromString(Color), parseAlign(Alignment), parseBorder(BorderStyle), FlxColor.fromString(BorderColor));
            }
        });

        addCallback("indexOf", function(obj:Dynamic) {
            var object:Dynamic = null;
            if (par.objects.exists(obj)) {
                object = par.objects[obj];
            } else {
                object = Reflect.getProperty(instance(), obj);
            }
            return instance().members.indexOf(object);
        });
        addCallback("add", function(obj:Int) {
            var object:Dynamic = null;
            if (par.objects.exists(obj)) {
                object = par.objects[obj];
                instance().add(object);
            }
        });
        addCallback("insert", function(pos:Int, obj:Int) {
            var object:Dynamic = null;
            if (par.objects.exists(obj)) {
                object = par.objects[obj];
                instance().insert(pos, object);
            }
        });
        addCallback("remove", function(obj:Int) {
            var object:Dynamic = null;
            if (par.objects.exists(obj)) {
                object = par.objects[obj];
                instance().remove(object);
            }
        });
        addCallback("delete", function(obj:Int) {
            var object:Dynamic = null;
            if (par.objects.exists(obj)) {
                object = par.objects[obj];
                instance().remove(object);
                par.objects.remove(obj);
            }
        });

        addCallback("doTween", function(obj:Dynamic, props:Dynamic, duration:Float, sets:Dynamic):Int {
            var id:Int = tweens;
            var tween:FlxTween;

            var settings:Dynamic = null;
            if (sets != null) {
                settings = sets;
                if (sets.onComplete != null) {
                    var complete = sets.onComplete;
                }
                /*
                settings.onComplete = function(twn:FlxTween) {
                    if (sets.onComplete != null) {
                        sets.onComplete();
                    }
                }
                */
                if (sets.onComplete != null) {
                    settings.onComplete = function(twn:FlxTween) {
                        call(sets.onComplete, []);
                    }
                }
                if (sets.ease != null) {
                    var ease = sets.ease;
                    settings.ease = parseEase(ease);
                }
            }
            var object:Dynamic = null;
            if (par.objects.exists(obj)) {
                object = par.objects[obj];
            } else {
                object = Reflect.getProperty(instance(), obj);
            }
            tween = FlxTween.tween(object, props, duration, settings);
            par.tweens.set(id, tween);

            tweens ++;
            return id;
        });
        addCallback("pauseTween", function(twn:Dynamic) {
            var tween:Dynamic = null;
            if (par.tweens.exists(twn)) {
                tween = par.tweens[twn];
            } else {
                tween = Reflect.getProperty(instance(), twn);
            }
            tween.pause();
        });
        addCallback("resumeTween", function(twn:Dynamic) {
            var tween:Dynamic = null;
            if (par.tweens.exists(twn)) {
                tween = par.tweens[twn];
            } else {
                tween = Reflect.getProperty(instance(), twn);
            }
            tween.resume();
        });
        addCallback("stopTween", function(twn:Dynamic) {
            var tween:Dynamic = null;
            if (par.tweens.exists(twn)) {
                tween = par.tweens[twn];
            } else {
                tween = Reflect.getProperty(instance(), twn);
            }
            tween.stop();
        });
        addCallback("deleteTween", function(twn:Int) {
            var tween:Dynamic = null;
            if (par.tweens.exists(twn)) {
                tween = par.tweens[twn];
                tween.stop();
                par.tweens.remove(twn);
            }
        });

        addCallback("runTimer", function(time:Float, onComplete:()->Void, loops:Int = 1):Int {
            var id:Int = timers;
            var timer:FlxTimer = new FlxTimer().start(time, function(tmr:FlxTimer) {
                if (onComplete != null) {
                    onComplete();
                }
                call("onTimerCompleted", [id]);
            }, loops);
            par.timers.set(id, timer);

            timers ++;
            return id;
        });
        addCallback("pauseTimer", function(tmr:Dynamic) {
            var timer:Dynamic = null;
            if (par.timers.exists(tmr)) {
                timer = par.timers[tmr];
            } else {
                timer = Reflect.getProperty(instance(), tmr);
            }
            timer.pause();
        });
        addCallback("resumeTimer", function(tmr:Dynamic) {
            var timer:Dynamic = null;
            if (par.timers.exists(tmr)) {
                timer = par.timers[tmr];
            } else {
                timer = Reflect.getProperty(instance(), tmr);
            }
            timer.resume();
        });
        addCallback("stopTimer", function(tmr:Dynamic) {
            var timer:Dynamic = null;
            if (par.timers.exists(tmr)) {
                timer = par.timers[tmr];
            } else {
                timer = Reflect.getProperty(instance(), tmr);
            }
            timer.stop();
        });
        addCallback("deleteTimer", function(tmr:Int) {
            var timer:Dynamic = null;
            if (par.timers.exists(tmr)) {
                timer = par.timers[tmr];
                timer.stop();
                par.timers.remove(tmr);
            }
        });
    }

    private function addCallback(event:String, func:Dynamic) {
        Lua_helper.add_callback(lua, event, func);
    }

    var lastCalledFunction:String = '';
    public function call(func:String, args:Array<Dynamic>) {
		lastCalledFunction = func;
		try {
			Lua.getglobal(lua, func);
			var type:Int = Lua.type(lua, -1);

			for (arg in args) Convert.toLua(lua, arg);
			var status:Int = Lua.pcall(lua, args.length, 1, 0);

			var result:Dynamic = cast Convert.fromLua(lua, -1);

			Lua.pop(lua, 1);
			return result;
		}
	}

    function parseAlign(align:String) {
        switch(align.toLowerCase()) {
            default: return LEFT;
            case 'center': return CENTER;
            case 'right': return RIGHT;
            case 'justify': return JUSTIFY;
        }
    }

    function parseBorder(border:String) {
        switch(border.toLowerCase()) {
            case 'none': return NONE;
            case 'shadow': return SHADOW;
            default: return OUTLINE;
            case 'outline_fast': return OUTLINE_FAST;
        }
    }

    function parseEase(ease:String) {
        switch(ease.toLowerCase()) {
			case 'backin': return FlxEase.backIn;
			case 'backinout': return FlxEase.backInOut;
			case 'backout': return FlxEase.backOut;
			case 'bouncein': return FlxEase.bounceIn;
			case 'bounceinout': return FlxEase.bounceInOut;
			case 'bounceout': return FlxEase.bounceOut;
			case 'circin': return FlxEase.circIn;
			case 'circinout': return FlxEase.circInOut;
			case 'circout': return FlxEase.circOut;
			case 'cubein': return FlxEase.cubeIn;
			case 'cubeinout': return FlxEase.cubeInOut;
			case 'cubeout': return FlxEase.cubeOut;
			case 'elasticin': return FlxEase.elasticIn;
			case 'elasticinout': return FlxEase.elasticInOut;
			case 'elasticout': return FlxEase.elasticOut;
			case 'expoin': return FlxEase.expoIn;
			case 'expoinout': return FlxEase.expoInOut;
			case 'expoout': return FlxEase.expoOut;
			case 'quadin': return FlxEase.quadIn;
			case 'quadinout': return FlxEase.quadInOut;
			case 'quadout': return FlxEase.quadOut;
			case 'quartin': return FlxEase.quartIn;
			case 'quartinout': return FlxEase.quartInOut;
			case 'quartout': return FlxEase.quartOut;
			case 'quintin': return FlxEase.quintIn;
			case 'quintinout': return FlxEase.quintInOut;
			case 'quintout': return FlxEase.quintOut;
			case 'sinein': return FlxEase.sineIn;
			case 'sineinout': return FlxEase.sineInOut;
			case 'sineout': return FlxEase.sineOut;
			case 'smoothstepin': return FlxEase.smoothStepIn;
			case 'smoothstepinout': return FlxEase.smoothStepInOut;
			case 'smoothstepout': return FlxEase.smoothStepInOut;
			case 'smootherstepin': return FlxEase.smootherStepIn;
			case 'smootherstepinout': return FlxEase.smootherStepInOut;
			case 'smootherstepout': return FlxEase.smootherStepOut;
            default: return FlxEase.linear;
		}
    }

    function instance() {
        return PlayState.instance;
    }

    public function stop() {
		if(lua == null) {
			return;
		}

		Lua.close(lua);
		lua = null;
	}
}