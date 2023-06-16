package states;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import system.song.Song;
import states.PlayState;
import system.assets.Paths;
import flixel.FlxSprite;

class MainMenuState extends DaState {
    var logo:FlxSprite;

    var menuItemOptions:Array<Dynamic> = [
        {
            name: "PLAY",
            yOffset: FlxG.height / 3,
            onPress: function() {
                PlayState.SONG = Song.fromFile("data/songs/lost_error/normal.json");
                FlxG.switchState(new PlayState());
            }
        },
        {
            name: "SETTINGS",
            yOffset: (FlxG.height / 3) + (Paths.image("mainmenu/button_empty").height * 1.2),
            onPress: function() {}
        },
        {
            name: "CREDITS",
            yOffset: (FlxG.height / 3) + ((Paths.image("mainmenu/button_empty").height * 1.2) * 2),
            onPress: function() {}
        }
    ];
    var menuItems:FlxTypedGroup<FlxSprite>;

    private static var curSelected:Int = 0;

    /*override function create() {
        super.create();
        
        logo = new FlxSprite().loadGraphic(Paths.image("menuLogo", true));
        logo.screenCenter();
        logo.x = (FlxG.width / 3 * 2) - (logo.width / 2);
        logo.y += FlxG.height / 15;
        add(logo);

        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);

        for (i in 0...menuItemOptions.length) {
            var scaleMult:Float = 1 - (0.07 * i);
            var xOffset:Float = 45 - (15 * i);

            var menuItem:FlxSprite = new FlxSprite(xOffset, menuItemOptions[i].yOffset, Paths.image("mainmenu/button_" + menuItemOptions[i].name.toUpperCase()));
            menuItem.setGraphicSize(Std.int(menuItem.width * scaleMult));
            menuItem.updateHitbox();
            menuItems.add(menuItem);
        }
    }*/

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.ACCEPT) {
            if (curSelected >= 0 && curSelected <= menuItems.members.length - 1) {
                menuItemOptions[curSelected].onPress();
            }
        }
    }
}