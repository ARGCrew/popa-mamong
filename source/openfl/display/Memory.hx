package openfl.display;

class Memory extends openfl.text.TextField {
    @:noCompletion private var cacheCount:Int = 0;
    @:noCompletion private var times:Array<Float>;

    public function new() {
        super();
        x = y = 10;

        defaultTextFormat = new openfl.text.TextFormat(openfl.utils.Assets.getFont(Paths.font).fontName, 14, 0xffFFFFFF);
		autoSize = LEFT;
		multiline = false;
    }

    @:noCompletion
    private #if !flash override #end function __enterFrame(deltaTime:Float) {
        var currentCount = times.length;

        var memoryMegas:Float = 0;
			
		#if openfl
		memoryMegas = Math.abs(flixel.math.FlxMath.roundDecimal(openfl.system.System.totalMemory / 1000000, 1));
		text = visible ? 'Memory: $memoryMegas MB' : "";
		#end

		textColor = 0xFFFFFFFF;
		if (memoryMegas > 3000) {
			textColor = 0xFFFF0000;
		}
    }
}