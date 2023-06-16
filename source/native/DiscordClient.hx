package native;

#if discord_rpc
import discord_rpc.DiscordRpc;
#end

using StringTools;

class DiscordClient {
    public static var sessionStarted:Bool = false;
	public function new() {
        #if discord_rpc
		DiscordRpc.start({
			clientID: "1097431325834743879",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});

	    while (true) {
	    	DiscordRpc.process();
	    	Sys.sleep(2);
	    }

	    DiscordRpc.shutdown();
        #end
	}

	public static function closeSession() {
        #if discord_rpc
	    DiscordRpc.shutdown();
        #end
    }

	static function onReady() {
        #if discord_rpc
	    DiscordRpc.presence({
	    	details: "Title Menu",
	    	state: null,
	    	largeImageKey: "icon",
	    	largeImageText: "ARG v0.1.0"
	    });
        #end
	}

	static function onError(_code:Int, _message:String)
	    trace(_message);

	static function onDisconnected(_code:Int, _message:String)
        trace(_message);

	public static function startSession() {
        #if discord_rpc
		var DiscordDaemon = sys.thread.Thread.create(() -> {
			new DiscordClient();
		});
        trace("Discord Client initialized");
        sessionStarted = true;
        #end
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?smallImageText:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float) {
        #if discord_rpc
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
			endTimestamp = startTimestamp + endTimestamp;

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: "icon",
	    	largeImageText: "ARG v0.1.0",
	    	smallImageKey : smallImageKey,
            smallImageText : smallImageText,
	    	// Obtained times are in milliseconds so they are divided so Discord can use it
	    	startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
	    });
        #end
	}
}