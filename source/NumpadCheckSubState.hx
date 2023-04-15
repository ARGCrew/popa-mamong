package;

import flixel.group.FlxSpriteGroup;

import controls.Controls.KeyboardScheme;
import controls.PlayerSettings;

import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxSprite;

class NumpadCheckSubState extends MusicBeatSubState {
    var bg:FlxSprite;
    var text:FlxText;

    var boobs:NumpadButton;
    var noBoobs:NumpadButton;

    var boobsSprite:FlxSprite;
    var noBoobsSprite:FlxSprite;

    var bgTween:FlxTween;

    var curSelected:Int = 0;

    override function create() {
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
        add(bg);

        bgTween = FlxTween.tween(bg, {alpha: 0.6}, 0.2, {ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween) {
            bgTween = null;
        }});

        boobs = new NumpadButton(100, FlxG.height / 6);
        boobs.onPress = function() {
            PlayerSettings.current.setKeyboardScheme(Numpad);
            out();
            MainMenuState.funnyNumpad = false;
        }
        centerOnBound(boobs, -1);
        add(boobs);

        noBoobs = new NumpadButton(FlxG.width - (FlxG.width / 4) - 100, FlxG.height / 6);
        noBoobs.onPress = function() {
            PlayerSettings.current.setKeyboardScheme(NoNumpad);
            out();
            MainMenuState.funnyNumpad = false;
        }
        centerOnBound(noBoobs, 1);
        add(noBoobs);

        boobsSprite = new FlxSprite(boobs.x, boobs.y).loadGraphic(Paths.image('boobs'));
        boobsSprite.setGraphicSize(Std.int(boobs.bg.width));
        boobsSprite.updateHitbox();
        add(boobsSprite);
        noBoobsSprite = new FlxSprite(noBoobs.x, noBoobs.y).loadGraphic(Paths.image('noboobs'));
        noBoobsSprite.setGraphicSize(Std.int(boobs.bg.width));
        noBoobsSprite.updateHitbox();
        add(noBoobsSprite);

        changeSelection();

        super.create();
    }

    override function update(elapsed:Float) {
        if (controls.LEFT_P) {
            changeSelection(-1);
        }
        if (controls.RIGHT_P){
            changeSelection(1);
        }

        if (controls.ACCEPT) {
            var butts = [boobs, noBoobs];
            if (butts[curSelected].onPress != null) {
                butts[curSelected].onPress();
            }
        }
        
        super.update(elapsed);
    }

    function changeSelection(daStep:Int = 0, force:Bool = false) {
        curSelected += daStep;

        if (curSelected > 1) {
            curSelected = 0;
        }
        if (curSelected < 0) {
            curSelected = 1;
        }

        (curSelected == 0 ? boobs : noBoobs).select();
        (curSelected == 1 ? boobs : noBoobs).unselect();
    }

    function centerOnBound(obj:FlxSprite, bound:Int = 0) {
        obj.screenCenter();
        obj.x += bound * (FlxG.width / 4);
    }
    
    function out() {
        remove(boobs);
        remove(noBoobs);

        remove(boobsSprite);
        remove(noBoobsSprite);

        bgTween = FlxTween.tween(bg, {alpha: 0}, 0.2, {ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween) {
            bgTween = null;
            close();
        }});
    }
}

class NumpadButton extends FlxSpriteGroup {
    public var bg:FlxSprite;
    var bgTween:FlxTween;

    public var onPress:()->Void = null;
    public var canPress:Bool = false;

    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);

        bg = new FlxSprite().makeGraphic(Std.int(FlxG.width / 3), Std.int(FlxG.height / 1.5));
        bg.alpha = 0.1;
        add(bg);
    }

    public function select() {
        bgTween = FlxTween.tween(bg, {alpha: 0.3}, 0.05, {onComplete: function(twn:FlxTween) {
            bgTween = null;
        }});
        canPress = true;
    } 

    public function unselect() {
        bgTween = FlxTween.tween(bg, {alpha: 0.1}, 0.05, {onComplete: function(twn:FlxTween) {
            bgTween = null;
        }});
        canPress = false;
    }
}