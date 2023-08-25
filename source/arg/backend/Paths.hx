package arg.backend;

import openfl.utils.Assets;
import openfl.display.BitmapData;

class Paths {
    public static function image(name:String):BitmapData {
        return Assets.getBitmapData("assets/images/" + name + ".png");
    }

    public static function text(name:String):String {
        return Assets.getText("assets/" + name);
    }
}