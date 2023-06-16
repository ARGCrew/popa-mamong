package states.substates;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;

class OutdatedSubState extends DaSubState {
    var bg:FlxSprite;
    var message:FlxText;
    var link:FlxText;

    override function create() {
        super.create();

        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.6;
        add(bg);

        message = new FlxText("Hey!\nYour game is outdated, please, update it");
        message.setFormat("embed/fonts/nsd.ttf", 60, FlxColor.WHITE, LEFT);
        message.screenCenter();
        message.y -= 60;
        add(message);

        link = new FlxText("\n\n\nhttps://github.com/h4master/another-...");
        link.setFormat("embed/fonts/nsd.ttf", 60, FlxColor.YELLOW, LEFT);
        link.screenCenter();
        link.y -= 60;
        add(link);

        var linkHitbox:FlxSprite = new FlxSprite(link.x, link.y + link.height / 4 * 3).makeGraphic(Std.int(link.width), Std.int(link.height / 4), FlxColor.WHITE);
        add(linkHitbox);

        var mouseEvent:FlxMouseEventManager = new FlxMouseEventManager();
        mouseEvent.add(linkHitbox, function(spr:FlxSprite) {
            FlxG.openURL("https://github.com/h4master/another-rhythm-game");
            trace("down!");
        }, null, function(spr:FlxSprite) {
            link.color = FlxColor.RED;
            trace("over!");
        }, function(spr:FlxSprite) {
            link.color = FlxColor.YELLOW;
            trace("out!");
        });
    }
}