package menus;

import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.addons.transition.FlxTransitionableState;

class MainMenuState extends FlxTransitionableState {
	final menuItemNames:Array<String> = [
		'play',
		'settings',
		'credits'
	];
	var menuItems:FlxSpriteGroup;

	var logo:FlxSprite;

	override function create() {
		var mouseEvent:FlxMouseEventManager = new FlxMouseEventManager();
		add(mouseEvent);
		
		menuItems = new FlxSpriteGroup();
		for (i in 0...menuItemNames.length) {
			var menuItem:FlxSprite = new FlxSprite(i * -16, i * 200, Assets.graphic('mainmenu/${menuItemNames[i].toUpperCase()}'));
			menuItems.add(menuItem);
			mouseEvent.add(menuItem, (spr:FlxSprite) -> {
				switch(menuItemNames[i]) {
					case 'play':
						FlxG.switchState(new gameplay.PlayState());
				}
			});
		}
		menuItems.screenCenter(Y);
		menuItems.x += 150;
		add(menuItems);

		logo = new FlxSprite(Assets.graphic('mainmenu/Logo'));
		logo.screenCenter(Y);
		logo.x = FlxG.width * 0.75 - logo.width / 2;
		add(logo);

		super.create();
	}
}