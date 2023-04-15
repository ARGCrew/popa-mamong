package;

import flixel.group.FlxGroup.FlxTypedGroup;

class ButtonGrid extends FlxTypedGroup<Button> {
    public function new(xAdd:Float = 0, yAdd:Float = 0) {
        super();
        
        for (i in 0...9) {
            add(new Button(i, Settings.skin));
        }
        for (button in members) {
            button.x += xAdd;
            button.y += yAdd;
        }
    }
}