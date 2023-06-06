package system.controls;

import system.controls.Controls;

class PlayerSettings {
    public static var current:PlayerSettings;

    public var id:Int;
    public final controls:Controls;

    function new(id:Int, scheme:KeyboardScheme) {
        this.id = id;
        this.controls = new Controls('player$id', scheme);
    }

    public function setKeyboardScheme(scheme:KeyboardScheme) {
        controls.setKeyboardScheme(scheme);
    }

    public static function init(scheme:KeyboardScheme = None) {
        if (current == null) {
            current = new PlayerSettings(0, scheme);
        }
    }

    public static function reset() {
        current = null;
    }
}
