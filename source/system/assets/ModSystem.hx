package system.assets;

#if MODS
import sys.io.File;
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
#end

class ModSystem {
    public static var list:Array<String> = [];
    public static var modFolder:String = "mods";

    static var modList:Dynamic = {};

    public static function searchMods() {
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