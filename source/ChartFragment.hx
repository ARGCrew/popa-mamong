package;

typedef ChartNote = 
{
	var time:Float;
	var id:Int;
}

typedef ChartFrag =
{
	var sectionNotes:Array<Dynamic>;
	var lengthInSteps:Int;
	var bpm:Int;
	var changeBPM:Bool;
}

class ChartFragment
{
	public var sectionNotes:Array<Dynamic> = [];

	public var lengthInSteps:Int = 16;

	/**
	 *	Copies the first section into the second section!
	 */
	public static var COPYCAT:Int = 0;

	public function new(lengthInSteps:Int = 16)
	{
		this.lengthInSteps = lengthInSteps;
	}
}
