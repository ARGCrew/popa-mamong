package system.assets;

import flixel.FlxState;
import flixel.FlxG;
#if MODS
import system.assets.Paths.ModPaths;
import sys.io.File;
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
#end

class ModSystem extends DaState {
    public static var list:Array<String> = [];
    public static var modFolder:String = "mods";

    static var modList:Dynamic = {};

    private function new(mods:Map<String, ModMetaData>, targetState:FlxState) {
        super();

        /*#if MODS
        var toLoad:Map<String, String> = [];
        for (mod in mods.keys()) {
            for (folder in FileSystem.readDirectory('$modFolder/$mod')) {
                for (file in FileSystem.readDirectory('$modFolder/$mod/$folder')) {
                    if (file != "readme.txt" || file != "preload.txt") {
                        toLoad.set(file, switch(folder) {
                            case "images": "image";
                            case "music": "music";
                            case "sounds": "sound";
                            case "songs": "song";
                            default: null;
                        });
                    } else if (file == "preload.txt") {
                        var files:Array<String> = File.getContent('$modFolder/$mod/$folder/preload.txt').split("\n");
                        for (preloadFile in files) {
                            if (FileSystem.exists('$modFolder/$mod/$folder/$preloadFile'))
                                toLoad.set(preloadFile, switch(folder) {
                                    case "images": "image";
                                    case "music": "music";
                                    case "sounds": "sound";
                                    case "songs": "song";
                                    default: null;
                                });
                        }
                    }
                }
            }
        }

        for (key in toLoad.keys()) {
            switch(toLoad[key]) {
                case "image": Paths.image(key);
                case "music": Paths.music(key);
                case "sound": Paths.sound(key);
                case "song": Paths.song(key);
            }
            trace('$key: ' + toLoad[key]);
        }
        #end*/
        FlxG.switchState(targetState);
    }

    public static function loadMods() {
        #if MODS
        searchMods(function(mods:Map<String, ModMetaData>) {
            FlxG.switchState(new ModSystem(mods, FlxG.state));
        });
        #end
    }

    public static function searchMods(?onComplete:(mods:Map<String, ModMetaData>)->Void) {
        #if MODS
        for (mod in FileSystem.readDirectory(modFolder)) {
            if (FileSystem.isDirectory(modFolder) && !ModPaths.mods.exists(mod) && (mod != "readme.txt"))
                addMod(mod);
        }

        if (onComplete != null) onComplete(ModPaths.mods);
        #end
    }

    public static function addMod(folder:String) {
        #if MODS
        var mod:ModMetaData = {
            path: Path.join([modFolder, folder])
        }
        list.push(folder);
        ModPaths.mods.set(folder, mod);
        #end
    }
}

typedef ModMetaData = {
    /*
    var title:String;
    var description:String;
    */
    var path:String;
}