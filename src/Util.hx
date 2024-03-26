class Util {
	// stolen from flixel lol
	public static function formatTime(Seconds:Float):String {
		var timeString:String = Std.int(Seconds / 60) + ":";
		while (timeString.length < 3)
			timeString = '0$timeString';
		var timeStringHelper:Int = Std.int(Seconds) % 60;
		if (timeStringHelper < 10)
		{
			timeString += "0";
		}
		timeString += timeStringHelper;

		return timeString;
	}
}