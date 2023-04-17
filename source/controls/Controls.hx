package controls;

import flixel.input.FlxInput.FlxInputState;
import flixel.FlxG;
import flixel.input.actions.FlxActionManager;
import flixel.input.keyboard.FlxKey;
import flixel.input.actions.FlxActionSet;
import flixel.input.actions.FlxAction.FlxActionDigital;

enum abstract Action(String) to String from String {
    var SEVEN = "seven";
    var EIGHT = "eight";
    var NINE = "nine";
    var FOUR = "four";
    var FIVE = "five";
    var SIX = "six";
    var ONE = "one";
    var TWO = "two";
    var THREE = "three";

    var SEVEN_P = "seven-press";
    var EIGHT_P = "eight-press";
    var NINE_P = "nine-press";
    var FOUR_P = "four-press";
    var FIVE_P = "five-press";
    var SIX_P = "six-press";
    var ONE_P = "one-press";
    var TWO_P = "two-press";
    var THREE_P = "three-press";

    var SEVEN_R = "seven-release";
    var EIGHT_R = "eight-release";
    var NINE_R = "nine-release";
    var FOUR_R = "four-release";
    var FIVE_R = "five-release";
    var SIX_R = "six-release";
    var ONE_R = "one-release";
    var TWO_R = "two-release";
    var THREE_R = "three-release";

    var UP = "up";
    var DOWN = "down";
    var LEFT = "left";
    var RIGHT = "right";

    var UP_P = "up-press";
    var DOWN_P = "down-press";
    var LEFT_P = "left-press";
    var RIGHT_P = "right-press";

    var UP_R = "up-release";
    var DOWN_R = "down-release";
    var LEFT_R = "left-release";
    var RIGHT_R = "right-release";

    var ACCEPT = "accept";
    var BACK = "back";
}

enum Control {
    SEVEN;
    EIGHT;
    NINE;
    FOUR;
    FIVE;
    SIX;
    ONE;
    TWO;
    THREE;

    UP;
    DOWN;
    LEFT;
    RIGHT;

    ACCEPT;
    BACK;
}

enum Scheme {
    None;
    Numpad;
    NoNumpad;
    Custom;
}

abstract KeyboardScheme(Scheme) from Scheme to Scheme {
    public static function fromString(x:String):Scheme {
        return switch(x.toLowerCase()) {
            case 'nonumpad' | 'nonum' | 'no numpad' | 'no num': NoNumpad;
            case 'numpad' | 'num': Numpad;
            case 'custom': Custom;
            default: None;
        }
    }

    public function toString():String {
        return switch(this) {
            case Numpad: "Numpad";
            case NoNumpad: "No Numpad";
            case Custom: "Custom";
            case None: "None";
        }
    }
}

class Controls extends FlxActionSet {
    var _seven = new FlxActionDigital(Action.SEVEN);
    var _eight = new FlxActionDigital(Action.EIGHT);
    var _nine = new FlxActionDigital(Action.NINE);
    var _four = new FlxActionDigital(Action.FOUR);
    var _five = new FlxActionDigital(Action.FIVE);
    var _six = new FlxActionDigital(Action.SIX);
    var _one = new FlxActionDigital(Action.ONE);
    var _two = new FlxActionDigital(Action.TWO);
    var _three = new FlxActionDigital(Action.THREE);

    var _sevenP = new FlxActionDigital(Action.SEVEN_P);
    var _eightP = new FlxActionDigital(Action.EIGHT_P);
    var _nineP = new FlxActionDigital(Action.NINE_P);
    var _fourP = new FlxActionDigital(Action.FOUR_P);
    var _fiveP = new FlxActionDigital(Action.FIVE_P);
    var _sixP = new FlxActionDigital(Action.SIX_P);
    var _oneP = new FlxActionDigital(Action.ONE_P);
    var _twoP = new FlxActionDigital(Action.TWO_P);
    var _threeP = new FlxActionDigital(Action.THREE_P);

    var _sevenR = new FlxActionDigital(Action.SEVEN_R);
    var _eightR = new FlxActionDigital(Action.EIGHT_R);
    var _nineR = new FlxActionDigital(Action.NINE_R);
    var _fourR = new FlxActionDigital(Action.FOUR_R);
    var _fiveR = new FlxActionDigital(Action.FIVE_R);
    var _sixR = new FlxActionDigital(Action.SIX_R);
    var _oneR = new FlxActionDigital(Action.ONE_R);
    var _twoR = new FlxActionDigital(Action.TWO_R);
    var _threeR = new FlxActionDigital(Action.THREE_R);

    var _up = new FlxActionDigital(Action.UP);
    var _down = new FlxActionDigital(Action.DOWN);
    var _left = new FlxActionDigital(Action.LEFT);
    var _right = new FlxActionDigital(Action.RIGHT);

    var _upP = new FlxActionDigital(Action.UP_P);
    var _downP = new FlxActionDigital(Action.DOWN_P);
    var _leftP = new FlxActionDigital(Action.LEFT_P);
    var _rightP = new FlxActionDigital(Action.RIGHT_P);

    var _upR = new FlxActionDigital(Action.UP_R);
    var _downR = new FlxActionDigital(Action.DOWN_R);
    var _leftR = new FlxActionDigital(Action.LEFT_R);
    var _rightR = new FlxActionDigital(Action.RIGHT_R);

    var _accept = new FlxActionDigital(Action.ACCEPT);
    var _back = new FlxActionDigital(Action.BACK);

    var byName:Map<String, FlxActionDigital> = [];
    public var keyboardScheme:KeyboardScheme = None;

    public var SEVEN(get, never):Bool;

    inline function get_SEVEN() {
        return _seven.check();
    }

    public var EIGHT(get, never):Bool;

    inline function get_EIGHT() {
        return _eight.check();
    }

    public var NINE(get, never):Bool;

    inline function get_NINE() {
        return _nine.check();
    }

    public var FOUR(get, never):Bool;

    inline function get_FOUR() {
        return _four.check();
    }

    public var FIVE(get, never):Bool;

    inline function get_FIVE() {
        return _five.check();
    }

    public var SIX(get, never):Bool;

    inline function get_SIX() {
        return _six.check();
    }

    public var ONE(get, never):Bool;

    inline function get_ONE() {
        return _one.check();
    }

    public var TWO(get, never):Bool;

    inline function get_TWO() {
        return _two.check();
    }

    public var THREE(get, never):Bool;

    inline function get_THREE() {
        return _three.check();
    }

    public var SEVEN_P(get, never):Bool;

    inline function get_SEVEN_P() {
        return _sevenP.check();
    }

    public var EIGHT_P(get, never):Bool;

    inline function get_EIGHT_P() {
        return _eightP.check();
    }

    public var NINE_P(get, never):Bool;

    inline function get_NINE_P() {
        return _nineP.check();
    }

    public var FOUR_P(get, never):Bool;

    inline function get_FOUR_P() {
        return _fourP.check();
    }

    public var FIVE_P(get, never):Bool;

    inline function get_FIVE_P() {
        return _fiveP.check();
    }

    public var SIX_P(get, never):Bool;

    inline function get_SIX_P() {
        return _sixP.check();
    }

    public var ONE_P(get, never):Bool;

    inline function get_ONE_P() {
        return _oneP.check();
    }

    public var TWO_P(get, never):Bool;

    inline function get_TWO_P() {
        return _twoP.check();
    }

    public var THREE_P(get, never):Bool;

    inline function get_THREE_P() {
        return _threeP.check();
    }

    public var SEVEN_R(get, never):Bool;

    inline function get_SEVEN_R() {
        return _sevenR.check();
    }

    public var EIGHT_R(get, never):Bool;

    inline function get_EIGHT_R() {
        return _eightR.check();
    }

    public var NINE_R(get, never):Bool;

    inline function get_NINE_R() {
        return _nineR.check();
    }

    public var FOUR_R(get, never):Bool;

    inline function get_FOUR_R() {
        return _fourR.check();
    }

    public var FIVE_R(get, never):Bool;

    inline function get_FIVE_R() {
        return _fiveR.check();
    }

    public var SIX_R(get, never):Bool;

    inline function get_SIX_R() {
        return _sixR.check();
    }

    public var ONE_R(get, never):Bool;

    inline function get_ONE_R() {
        return _oneR.check();
    }

    public var TWO_R(get, never):Bool;

    inline function get_TWO_R() {
        return _twoR.check();
    }

    public var THREE_R(get, never):Bool;

    inline function get_THREE_R() {
        return _threeR.check();
    }

    public var UP(get, never):Bool;

    inline function get_UP() {
        return _up.check();
    }

    public var DOWN(get, never):Bool;

    inline function get_DOWN() {
        return _down.check();
    }

    public var LEFT(get, never):Bool;

    inline function get_LEFT() {
        return _left.check();
    }

    public var RIGHT(get, never):Bool;

    inline function get_RIGHT() {
        return _right.check();
    }

    public var UP_P(get, never):Bool;

    inline function get_UP_P() {
        return _upP.check();
    }

    public var DOWN_P(get, never):Bool;

    inline function get_DOWN_P() {
        return _downP.check();
    }

    public var LEFT_P(get, never):Bool;

    inline function get_LEFT_P() {
        return _leftP.check();
    }

    public var RIGHT_P(get, never):Bool;

    inline function get_RIGHT_P() {
        return _rightP.check();
    }

    public var UP_R(get, never):Bool;

    inline function get_UP_R() {
        return _upR.check();
    }

    public var DOWN_R(get, never):Bool;

    inline function get_DOWN_R() {
        return _downR.check();
    }

    public var LEFT_R(get, never):Bool;

    inline function get_LEFT_R() {
        return _leftR.check();
    }

    public var RIGHT_R(get, never):Bool;

    inline function get_RIGHT_R() {
        return _rightR.check();
    }

    public var ACCEPT(get, never):Bool;

    inline function get_ACCEPT() {
        return _accept.check();
    }

    public var BACK(get, never):Bool;

    inline function get_BACK() {
        return _back.check();
    }

    public function new(name:Dynamic, scheme:KeyboardScheme) {
        super(Std.string(name));
        
        add(_seven);
        add(_eight);
        add(_nine);
        add(_four);
        add(_five);
        add(_six);
        add(_one);
        add(_two);
        add(_three);

        add(_sevenP);
        add(_eightP);
        add(_nineP);
        add(_fourP);
        add(_fiveP);
        add(_sixP);
        add(_oneP);
        add(_twoP);
        add(_threeP);

        add(_sevenR);
        add(_eightR);
        add(_nineR);
        add(_fourR);
        add(_fiveR);
        add(_sixR);
        add(_oneR);
        add(_twoR);
        add(_threeR);

        add(_up);
        add(_down);
        add(_left);
        add(_right);

        add(_upP);
        add(_downP);
        add(_leftP);
        add(_rightP);

        add(_upR);
        add(_downR);
        add(_leftR);
        add(_rightR);

        add(_accept);
        add(_back);

        for (action in digitalActions) {
            byName[action.name] = action;
        }

        setKeyboardScheme(scheme, false);
    }

    public function checkByName(name:Action):Bool {
        return byName[name].check();
    }

    public function getDialogueName(action:FlxActionDigital):String {
        var input = action.inputs[0];
        return '[${(input.inputID : FlxKey)}]';
    }

    public function getDialogueNameFromToken(token:String):String {
        return getDialogueName(getActionFromControl(Control.createByName(token.toUpperCase())));
    }

    function getActionFromControl(control:Control):FlxActionDigital {
        return switch(control) {
            case SEVEN: _seven;
            case EIGHT: _eight;
            case NINE: _nine;
            case FOUR: _four;
            case FIVE: _five;
            case SIX: _six;
            case ONE: _one;
            case TWO: _two;
            case THREE: _three;

            case UP: _up;
            case DOWN: _down;
            case LEFT: _left;
            case RIGHT: _right;

            case ACCEPT: _accept;
            case BACK: _back;
        }
    }

    static function init() {
        var actions = new FlxActionManager();
        FlxG.inputs.add(actions);
    }

    function forEachBound(control:Control, func:(act:FlxActionDigital, input:FlxInputState)->Void) {
        switch(control) {
            case SEVEN:
                func(_seven, PRESSED);
				func(_sevenP, JUST_PRESSED);
				func(_sevenR, JUST_RELEASED);
            case EIGHT:
                func(_eight, PRESSED);
				func(_eightP, JUST_PRESSED);
				func(_eightR, JUST_RELEASED);
            case NINE:
                func(_nine, PRESSED);
				func(_nineP, JUST_PRESSED);
				func(_nineR, JUST_RELEASED);
            case FOUR:
                func(_four, PRESSED);
				func(_fourP, JUST_PRESSED);
				func(_fourR, JUST_RELEASED);
            case FIVE:
                func(_five, PRESSED);
				func(_fiveP, JUST_PRESSED);
				func(_fiveR, JUST_RELEASED);
            case SIX:
                func(_six, PRESSED);
				func(_sixP, JUST_PRESSED);
				func(_sixR, JUST_RELEASED);
            case ONE:
                func(_one, PRESSED);
				func(_oneP, JUST_PRESSED);
				func(_oneR, JUST_RELEASED);
            case TWO:
                func(_two, PRESSED);
				func(_twoP, JUST_PRESSED);
				func(_twoR, JUST_RELEASED);
            case THREE:
                func(_three, PRESSED);
				func(_threeP, JUST_PRESSED);
				func(_threeR, JUST_RELEASED);

            case UP:
                func(_up, PRESSED);
				func(_upP, JUST_PRESSED);
				func(_upR, JUST_RELEASED);
            case DOWN:
                func(_down, PRESSED);
				func(_downP, JUST_PRESSED);
				func(_downR, JUST_RELEASED);
            case LEFT:
                func(_left, PRESSED);
				func(_leftP, JUST_PRESSED);
				func(_leftR, JUST_RELEASED);
            case RIGHT:
                func(_right, PRESSED);
				func(_rightP, JUST_PRESSED);
				func(_rightR, JUST_RELEASED);

            case ACCEPT:
                func(_accept, JUST_PRESSED);
            case BACK:
                func(_back, JUST_PRESSED);
        }
    }

    public function replaceBinding(control:Control, ?toAdd:Int, ?toRemove:Int) {
        if (toAdd == toRemove) {
			return;
        }

        if (toRemove != null) {
			unbindKeys(control, [toRemove]);
        }
		if (toAdd != null) {
			bindKeys(control, [toAdd]);
        }
    }

    public function copyFrom(controls:Controls) {
        for (name => action in controls.byName) {
			for (input in action.inputs) {
				byName[name].add(cast input);
			}
		}
        mergeKeyboardScheme(controls.keyboardScheme);
    }

    inline public function copyTo(controls:Controls) {
        controls.copyFrom(this);
    }

    function mergeKeyboardScheme(scheme:KeyboardScheme) {
        if (scheme != None) {
            keyboardScheme = scheme;
        }
    }

    public function bindKeys(control:Control, keys:Array<FlxKey>) {
        var copyKeys:Array<FlxKey> = keys.copy();
        for (i in 0...copyKeys.length) {
            if (i == NONE) {
                copyKeys.remove(i);
            }
        }
        inline forEachBound(control, (action, state) -> addKeys(action, copyKeys, state));
    }

    public function unbindKeys(control:Control, keys:Array<FlxKey>) {
        var copyKeys:Array<FlxKey> = keys.copy();
		for (i in 0...copyKeys.length) {
			if(i == NONE) {
                copyKeys.remove(i);
            }
		}
        inline forEachBound(control, (action, _) -> removeKeys(action, copyKeys));
    }

    inline static function addKeys(action:FlxActionDigital, keys:Array<FlxKey>, state:FlxInputState) {
        for (key in keys) {
			if(key != NONE) {
				action.addKey(key, state);
            }
        }
    }

    static function removeKeys(action:FlxActionDigital, keys:Array<FlxKey>) {
        var i = action.inputs.length;
        while (i -- > 0) {
            var input = action.inputs[i];
            if (keys.indexOf(cast input.inputID) != -1) {
				action.remove(input);
            }
        }
    }

    public function setKeyboardScheme(scheme:KeyboardScheme, reset:Bool = true) {
        if (reset) {
            removeKeyboard();
        }

        keyboardScheme = scheme;

        switch(scheme) {
            case None: // ура ура давай ура
            case Numpad:
                inline bindKeys(Control.SEVEN, [NUMPADSEVEN]);
                inline bindKeys(Control.EIGHT, [NUMPADEIGHT]);
                inline bindKeys(Control.NINE, [NUMPADNINE]);
                inline bindKeys(Control.FOUR, [NUMPADFOUR]);
                inline bindKeys(Control.FIVE, [NUMPADFIVE]);
                inline bindKeys(Control.SIX, [NUMPADSIX]);
                inline bindKeys(Control.ONE, [NUMPADONE]);
                inline bindKeys(Control.TWO, [NUMPADTWO]);
                inline bindKeys(Control.THREE, [NUMPADTHREE]);
            case NoNumpad:
                inline bindKeys(Control.SEVEN, [O]);
                inline bindKeys(Control.EIGHT, [P]);
                inline bindKeys(Control.NINE, [LBRACKET]);
                inline bindKeys(Control.FOUR, [L]);
                inline bindKeys(Control.FIVE, [SEMICOLON]);
                inline bindKeys(Control.SIX, [QUOTE]);
                inline bindKeys(Control.ONE, [COMMA]);
                inline bindKeys(Control.TWO, [PERIOD]);
                inline bindKeys(Control.THREE, [SLASH]);
            case Custom: // TODO: Сделать в будущем
        }

        inline bindKeys(Control.UP, [FlxKey.W, FlxKey.UP]);
        inline bindKeys(Control.DOWN, [FlxKey.S, FlxKey.DOWN]);
        inline bindKeys(Control.LEFT, [FlxKey.A, FlxKey.LEFT]);
        inline bindKeys(Control.RIGHT, [FlxKey.D, FlxKey.RIGHT]);

        inline bindKeys(Control.ACCEPT, [SPACE, ENTER]);
        inline bindKeys(Control.BACK, [ESCAPE, BACKSPACE]);
    }

    function removeKeyboard() {
        for (action in this.digitalActions) {
            var i = action.inputs.length;
			while (i -- > 0) {
				action.remove(action.inputs[i]);
			}
        }
    }

    public function getInputsFor(control:Control, ?list:Array<Int>):Array<Int> {
        if (list == null) {
            list = [];
        }

        for (input in getActionFromControl(control).inputs) {
            list.push(input.inputID);
        }

        return list;
    }
}