import flixel.FlxBasic;
import haxefmod.FmodManager;

class Fmod extends FlxBasic {
	public function new() {
		super();
	}

	public static inline function initialize() {
		FmodManager.Initialize();
	}

	public static var initialized(get, never):Bool;
	static inline function get_initialized():Bool {
		return FmodManager.IsInitialized();
	}

	override function update(elapsed:Float) {
		FmodManager.Update();
	}

	public static inline function playSong(key:String) {
		FmodManager.PlaySong(key);
	}

	public static inline function setSongParameter(key:String, value:Float) {
		FmodManager.SetEventParameterOnSong(key, value);
	}

	public static inline function stopSong(immediately:Bool = true) {
		if (immediately)
			FmodManager.StopSongImmediately();
		else
			FmodManager.StopSong();
	}

	public static inline function pauseSong() {
		FmodManager.PauseSong();
	}

	public static inline function unpauseSong() {
		FmodManager.UnpauseSong();
	}

	public static inline function playSoundOneshot(key:String) {
		FmodManager.PlaySoundOneShot(key);
	}

	public static inline function playSound(key:String, id:String) {
		FmodManager.PlaySoundAndAssignId(key, id);
	}

	public static inline function stopSound(id:String, immediately:Bool = true) {
		if (immediately)
			FmodManager.StopSoundImmediately(id);
		else
			FmodManager.StopSound(id);
	}
}