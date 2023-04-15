package;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class UIButton extends FlxSpriteGroup {
    var background:FlxSprite;
    var text:FlxText;

    var bgTween:FlxTween;

    public var onPress:()->Void = null;

    public function new(x:Float = 0, y:Float = 0, title:String) {
        super(x, y);

        background = new FlxSprite().makeGraphic(100, 45, FlxColor.WHITE);
        background.alpha = 0.1;
        add(background);

        text = new FlxText(0, 0, background.width, title, 8);
        text.setFormat(Paths.font, 32, FlxColor.BLACK, CENTER, OUTLINE, FlxColor.TRANSPARENT);
        add(text);
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(background)) {
            bgTween = FlxTween.tween(background, {alpha: 0.3}, 0.05, {onComplete: function(twn:FlxTween) {
                bgTween = null;
            }});
            if (FlxG.mouse.justPressed && onPress != null) {
                onPress();
            }
        } else {
            bgTween = FlxTween.tween(background, {alpha: 0.1}, 0.05, {onComplete: function(twn:FlxTween) {
                bgTween = null;
            }});
        }
        super.update(elapsed);
    }
}

class UIDropDown extends FlxSpriteGroup {
    public var value:Dynamic = null;
    var curValue:Int = 0;

    public var values:Array<Dynamic> = [];
    public var title:String = "";

    var background:FlxSprite;
    var text:FlxText;

    var lineTrue:FlxSprite;
    var lineFalse:FlxSprite;

    public var onChange:(value:Dynamic)->Void = null;

    public function new(x:Float = 0, y:Float = 0, title:String, values:Array<Dynamic>, defaultValue:Dynamic) {
        super(x, y);
        this.values = values;
        this.title = title;

        curValue = values.indexOf(defaultValue);
        value = values[curValue];

        background = new FlxSprite().makeGraphic(200, 30, FlxColor.WHITE);
        background.alpha = 0.4;
        add(background);

        text = new FlxText(0, 0, background.width, '$title: $value', 8);
        text.setFormat(Paths.font, 14, FlxColor.BLACK, CENTER, OUTLINE, FlxColor.TRANSPARENT);
        add(text);

        lineTrue = new FlxSprite(3, background.height - 8).makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.WHITE);
        add(lineTrue);

        lineFalse = new FlxSprite(background.width / 2 + 3, background.height - 8).makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.WHITE);
        add(lineFalse);

        if (curValue == 0) {
            lineTrue.makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.WHITE);
            lineFalse.makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.BLACK);
        } else {
            lineTrue.makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.BLACK);
            lineFalse.makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.WHITE);
        }
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(background) && FlxG.mouse.justPressed) {
            forward();
        }
    }

    public function forward() {
        curValue ++;
        curValue = Utils.boundTo(curValue, 0, values.length - 1);
        value = values[curValue];

        text.text = '$title: $value';

        if (curValue == 0) {
            lineTrue.makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.WHITE);
            lineFalse.makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.BLACK);
        } else {
            lineTrue.makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.BLACK);
            lineFalse.makeGraphic(Std.int(background.width / 2 - 6), 5, FlxColor.WHITE);
        }

        if (onChange != null) {
            onChange(value);
        }
    }
}

class UIInputText extends FlxSpriteGroup {
    public function new(x:Float = 0, y:Float = 0, text:String) {
        super(x, y);
    }
}