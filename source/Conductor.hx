package;

typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Int;
}

class Conductor
{
    public static var defaultBpm:Float = 130;
    public static var curBpm:Float = defaultBpm;
	public static var crochet:Float = ((60 / curBpm) * 1000); // beats in milliseconds
    public static var bpmChangeMap:Array<BPMChangeEvent> = [];

    public static var stepCrochet:Float = crochet / 4; // steps in milliseconds
    public static var songPosition:Float = 0;

    public static function changeBPM(newBpm:Float)
    {
        curBpm = newBpm;
        crochet = ((60 / newBpm) * 1000);
    }
}