package controls;

import controls.Controls.KeyboardScheme;

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

    public static function init() {
        if (current == null) {
            current = new PlayerSettings(0, None);
        }
    }

    public static function reset() {
        current = null;
    }
}