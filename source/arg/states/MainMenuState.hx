package arg.states;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;


class MainMenuState extends FlxTransitionableState {
    override function create() {
        FlxG.switchState(new PlayState());
    }
}