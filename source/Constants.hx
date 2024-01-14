import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;

class Constants {
	public static inline var GAME_WIDTH:Int = 1920;
	public static inline var GAME_HEIGHT:Int = 1080;
	
	public static inline var STRUM_SIZE:Float = 189;
	public static inline var STRUM_SPACING:Float = 20;

	public static inline var NOTE_HIT_WINDOW:Float = 20 / 60 * 1000;
	public static inline var NOTE_PERFECT_SCALE:Float = 145 / 197; // don't care about this

	public static final CONTROLS:Array<Array<FlxKey>> = [
		[Q, P], 	[W, LBRACKET], 	[E, RBRACKET],
		[A, L], 	[S, SEMICOLON], [D, QUOTE],
		[Z, COMMA], [X, PERIOD], 	[C, SLASH],
	];

	public static inline var STRUM_HIT_COLOR:FlxColor = 0xff46ff8d;
	public static inline var STRUM_MISS_COLOR:FlxColor = 0xffff463f;
	public static inline var STRUM_RELEASE_COLOR:FlxColor = 0xffffffff;
}