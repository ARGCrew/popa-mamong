package;

import flixel.util.FlxTimer;
import flixel.util.FlxAxes;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class UIInteractive extends FlxSpriteGroup {
    public var background:FlxSprite;
    var text:FlxText;

    public var title:String = "";

    public var onChange:Dynamic = null;

    public function new(x:Float = 0, y:Float = 0, title:String, onChange:Dynamic = null) {
        super(x, y);
        this.title = title;
        this.onChange = onChange;

        background = new FlxSprite().makeGraphic(700, 45, FlxColor.WHITE);
        background.alpha = 0.2;
        add(background);

        text = new FlxText(8.5, 5, background.width, title);
        text.setFormat(Paths.font, 28, FlxColor.BLACK, LEFT, NONE);
        add(text);
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(background)) {
            FlxTween.tween(background, {alpha: 0.6}, 0.05);
        } else {
            FlxTween.tween(background, {alpha: 0.2}, 0.05);
        }

        super.update(elapsed);
    }
}

class UIDropDown extends UIInteractive {
    var valueText:FlxText;

    public var values:Array<String> = [];
    public var value:String = null;
    public var curValue:Int = 0;

    public function new(x:Float = 0, y:Float = 0, title:String, values:Array<String>, defaultValue:String, onChange:Dynamic = null) {
        super(x, y, title, onChange);
        this.values = values;
        this.value = defaultValue;
        curValue = values.indexOf(value);

        valueText = new FlxText(0, 5, background.width - 8.5, '< $value >');
        valueText.setFormat(Paths.font, 28, FlxColor.BLACK, RIGHT, NONE);
        add(valueText);
    }

    public function forward() {
        curValue ++;
        curValue = Utils.int.boundTo(curValue, 0, values.length - 1, true);
        value = values[curValue];
        valueText.text = '< $value >';

        var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("Pressed")).play();
        sound.volume = Settings.getSoundVolume();

        if (onChange != null) {
            onChange(value);
        }
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(background) && FlxG.mouse.justPressed) {
            forward();
        }
        super.update(elapsed);
    }
}

class UICheckBox extends UIDropDown {
    public function new(x:Float = 0, y:Float = 0, title:String, defaultValue:Bool, onChange:Dynamic = null) {
        super(x, y, title, ["Enabled", "Disabled"], defaultValue ? "Enabled" : "Disabled", onChange);
    }

    override function forward() {
        super.forward();

        if (onChange != null) {
            onChange(value == "Enabled");
        }
    }
}

class UISlider extends UIInteractive {
    var line:FlxSprite;
    var handle:FlxSprite;
    var hitbox:FlxSprite;

    var value:Float = 0;
    var dragging:Bool = false;
    var valueLine:Float = 0;

    public function new(x:Float = 0, y:Float = 0, title:String, defaultValue:Float, onChange:Dynamic = null) {
        super(x, y, title, onChange);

        line = new FlxSprite().makeGraphic(Std.int(background.width / 2), 5);
        setOnCenter(line);
        line.x = background.width - line.width - 8.5;
        add(line);
        handle = new FlxSprite().makeGraphic(5, 25);
        handle.x = line.x + line.width - (line.width * value);
        setOnCenter(handle, Y);
        add(handle);
        hitbox = new FlxSprite().makeGraphic(Std.int(line.width), Std.int(handle.height));
        hitbox.visible = false;
        setOnCenter(hitbox);
        hitbox.x = line.x;
        add(hitbox);

        valueLine = line.width - handle.width;
    }

    override function update(elapsed:Float) {
        if (handle.x < line.x) {
            handle.x = line.x;
        }
        if (handle.x > line.x + line.width - handle.width) {
            handle.x = line.x + line.width - handle.width;
        }

        if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed) {
            dragging = true;
        }
        if (FlxG.mouse.justReleased) {
            dragging = false;
        }

        if (dragging) {
            handle.x = FlxG.mouse.x;
        }

        if (handle.x < line.x) {
            handle.x = line.x;
        }
        if (handle.x > line.x + line.width) {
            handle.x = line.x + line.width - handle.width;
        }

        value = ((line.x + valueLine) - handle.x) / valueLine;
        value = 1 - value;
        value = Utils.float.boundTo(value, 0, 1, false);

        if (onChange != null) {
            onChange(value);
        }

        super.update(elapsed);
    }

    function setOnCenter(object:FlxSprite, axes:FlxAxes = XY) {
        if (axes == X || axes == XY) {
            object.x = background.width / 2 - object.width / 2;
        }
        if (axes == Y || axes == XY) {
            object.y = background.height / 2 - object.height / 2;
        }
    }
}

class UIButton extends UIInteractive {
    public function new(x:Float = 0, y:Float = 0, width:Float, height:Float, title:String, onChange:Dynamic = null) {
        super(x, y, title, onChange);

        background.setGraphicSize(Std.int(width), Std.int(height));
        background.updateHitbox();
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(background) && FlxG.mouse.justPressed && onChange != null) {
            onChange();
        }
    }
}
/*
class UIButton extends FlxSpriteGroup {
    var background:FlxSprite;
    var text:FlxText;

    var bgTween:FlxTween;

    public var onPress:()->Void = null;

    public function new(x:Float = 0, y:Float = 0, width:Int, height:Int, title:String) {
        super(x, y);

        background = new FlxSprite().makeGraphic(width, height, FlxColor.WHITE);
        background.alpha = 0.2;
        add(background);

        text = new FlxText(0, 0, background.width, title, 8);
        text.setFormat(Paths.font, 32, FlxColor.BLACK, CENTER, OUTLINE, FlxColor.TRANSPARENT);
        add(text);
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(background)) {
            bgTween = FlxTween.tween(background, {alpha: 0.6}, 0.05, {onComplete: function(twn:FlxTween) {
                bgTween = null;
            }});
            if (FlxG.mouse.justPressed && onPress != null) {
                onPress();
            }
        } else {
            bgTween = FlxTween.tween(background, {alpha: 0.2}, 0.05, {onComplete: function(twn:FlxTween) {
                bgTween = null;
            }});
        }
        super.update(elapsed);
    }
}
*/

class UIMenu extends FlxSpriteGroup {
    public var buttons:Array<UIInteractive> = [];

    var background:FlxSprite;

    public function new(x:Float = 0, y:Float = 0, buttons:Array<UIInteractive>) {
        super(x, y);
        this.buttons = buttons;

        background = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
        background.alpha = 0.2;
        add(background);
    }

    override function update(elapsed:Float) {
        for (button in buttons) {
            if (!members.contains(button)) {
                add(button);
            }
        }

        super.update(elapsed);
    }
}

class UIBind extends UIInteractive {
    var textField:FlxSprite;
    public var typedText:FlxText;

    public var waiting:Bool = false;

    public function new(x:Float = 0, y:Float = 0, title:String, defaultValue:String, onChange:Dynamic) {
        super(x, y, title, onChange);

        textField = new FlxSprite(background.width - 75, 5).makeGraphic(70, 35, FlxColor.WHITE);
        add(textField);

        typedText = new FlxText(textField.x + 1, textField.y + 1, textField.width, defaultValue);
        typedText.setFormat(Paths.font, 16, FlxColor.BLACK, CENTER, NONE);
        add(typedText);
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(textField) && FlxG.mouse.justPressed) {
            waiting = true;
        }
        if (!FlxG.mouse.overlaps(textField) && FlxG.mouse.justPressed) {
            waiting = false;
        }

        if (waiting) {
            if (FlxG.keys.getIsDown()[0].ID.toString() == "" || FlxG.keys.getIsDown()[0].ID.toString() == null) {
                typedText.text = "> <";
            } else {
                typedText.text = FlxG.keys.getIsDown()[0].ID.toString();
                onChange(FlxG.keys.getIsDown()[0].ID.toString());
            }
        }
    }
}