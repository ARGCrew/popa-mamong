package;

import flixel.group.FlxGroup.FlxTypedGroup;

class ButtonGrid extends FlxTypedGroup<Button> {
    public function new() {
        super();
        
        for (i in 0...9) {
            add(new Button(i, Settings.skin));
        }
    }
}