package backend;

#if hldiscord
import discord.Api;
#end

class Discord {
	public static var running(default, null):Bool = false;

	public static function start() {
		#if hldiscord
		Api.init('1222135030986440744', '');
		Api.updateLargeImageKey('icon');
		Api.updateDetails('In Menus');
		running = true;
		#end
	}

	public static function presence(details:String = '', state:String = '', endTimestamp:Float = 0) {
		#if hldiscord
		if (!running)
			start();

		var startTimestamp:Float = ((endTimestamp > 0) ? Date.now().getTime() : 0) / 1000;
		if (endTimestamp > 0)
			endTimestamp += startTimestamp;

		Api.updateDetails(details);
		Api.updateState(state);
		Api.updateStartTimestamp(Std.int(startTimestamp));
		Api.updateEndTimestamp(Std.int(endTimestamp));
		#end
	}
}