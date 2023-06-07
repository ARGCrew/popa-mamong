package system.assets;

import flixel.FlxState;
import flixel.FlxG;
#if MODS
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
        if (FileSystem.exists("mods/modList.json")) {
            if (File.getContent("mods/modList.json") != "{\n}")
                modList = Json.parse(File.getContent("mods/modList.json"));
            for (field in Reflect.fields(modList)) {
                if (Reflect.getProperty(modList, field))
                    addMod(field);
            }
        }
        
        for (mod in FileSystem.readDirectory(modFolder)) {
            if (FileSystem.isDirectory(modFolder) && !ModPaths.mods.exists(mod) && (mod != "readme.txt") && (mod != "modList.json")) {
                Reflect.setProperty(modList, mod, true);
                addMod(mod);
            }
        }

        var modListTxt:String = "{";
        var allMods:Array<String> = Reflect.fields(modList);
        for (i in 0...allMods.length) {
            modListTxt += {
                if (i == 0) '\n\t"${allMods[i]}": ${Reflect.getProperty(modList, allMods[i])}';
                else ',\n\t"${allMods[i]}": ${Reflect.getProperty(modList, allMods[i])}';
            }
        }
        modListTxt += "\n}";
        File.saveContent("mods/modList.json", modListTxt);
        #end

        if (onComplete != null) onComplete(ModPaths.mods);
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