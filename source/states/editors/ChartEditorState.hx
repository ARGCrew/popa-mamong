package states.editors;

import flixel.FlxG;
import sprites.StrumGrid;

class ChartEditorState extends DaState {
    var strumGrid:StrumGrid;

    override function create() {
        super.create();

        strumGrid = new StrumGrid();
        strumGrid.screenCenter();
        strumGrid.x -= FlxG.width / 5;
        add(strumGrid);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK) FlxG.switchState(new PlayState());
    }
}