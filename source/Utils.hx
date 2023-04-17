package;

import controls.Controls.KeyboardScheme;
import controls.PlayerSettings;

class Utils {
    public static var int:IntTools = new IntTools();
    public static var float:FloatTools = new FloatTools();
    public static var bool:BoolTools = new BoolTools();
    public static var keys:KeyTools = new KeyTools();
}

class IntTools {
    public function new() {}

    public function convert(float:Float) {
        return Std.int(float);
    }

    public function parse(string:String) {
        return Std.parseInt(string);
    }

    public function boundTo(value:Int, minValue:Int, maxValue:Int, slip:Bool):Int {
        if (value < minValue) {
            value = slip ? maxValue : minValue;
        }
        if (value > maxValue) {
            value = slip ? minValue : maxValue;
        }

        return value;
    }
}

class FloatTools {
    public function new() {}

    public function parse(string:String) {
        return Std.parseFloat(string);
    }

    public function boundTo(value:Float, minValue:Float, maxValue:Float, slip:Bool):Float {
        if (value < minValue) {
            value = slip ? maxValue : minValue;
        }
        if (value > maxValue) {
            value = slip ? minValue : maxValue;
        }

        return value;
    }
}

class BoolTools {
    public function new() {}

    public function parse(string:String) {
        return (string.toLowerCase() == "true" || string.toLowerCase() == "enabled") ? true : false;
    }
}

class KeyTools {
    public function new() {}

    public function setScheme(scheme:KeyboardScheme) {
        switch(scheme) {
            case NoNumpad:
                Settings.scheme = "No Numpad";
                PlayerSettings.current.setKeyboardScheme(scheme);
            case Numpad:
                Settings.scheme = "Numpad";
                PlayerSettings.current.setKeyboardScheme(scheme);
            case Custom:
                Settings.scheme = "Custom";
                PlayerSettings.current.setKeyboardScheme(scheme);
            case None:
        }

        trace('Current keyboard scheme: ${scheme.toString()}');
    }
}