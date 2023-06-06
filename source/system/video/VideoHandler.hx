package system.video;

import openfl.events.Event;
#if !hxCodec
import openfl.Lib;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class VideoHandler extends Video {
    public var canSkip:Bool = true;
    public var skipKeys:Array<FlxKey> = [SPACE];

    public var canUseSound:Bool = true;
    public var canUseAutoResize:Bool = true;

    public var openingCallback:()->Void;
    public var finishCallback:()->Void;

    private var pauseMusic:Bool = false;

    public function new(indexModifier:Int = 0) {
        super(calcSize(0), calcSize(1));

        onOpening = onVidOpening;
        onEndReached = onVidEndReached;

        FlxG.addChildBelowMouse(this, indexModifier);
    }

    private function onVidOpening() {
        volume = Std.int(#if FLX_SOUND_SYSTEM ((FlxG.sound.muted || !canUseSound) ? 0 : 1) * #end FlxG.sound.volume * 100);
        
        if (openingCallback != null) openingCallback();
    }

    private function onVidEndReached() {
        if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();

        if (FlxG.stage.hasEventListener(Event.ENTER_FRAME))
			FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);

        if (FlxG.autoPause) {
			if (FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.remove(resume);

			if (FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.remove(pause);
		}

        dispose();

        FlxG.removeChild(this);

        if (finishCallback != null) finishCallback();
    }

    public function playVideo(path:String, loop:Bool = false, pauseMusic:Bool = false) {
        this.pauseMusic = pauseMusic;

        if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.pause();

        FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

        if (FlxG.autoPause) {
			FlxG.signals.focusGained.add(resume);
			FlxG.signals.focusLost.add(pause);
		}

        play(path, loop);
    }

    private function update(?e:Event) {
        #if FLX_KEYBOARD
		if (canSkip && (FlxG.keys.anyJustPressed(skipKeys) #if android || FlxG.android.justReleased.BACK #end) && (isPlaying))
			onVidEndReached();
		#elseif android
		if (canSkip && FlxG.android.justReleased.BACK && (isPlaying && isDisplaying))
			onVidEndReached();
		#end

        if (canUseAutoResize && (videoWidth > 0 && videoHeight > 0)) {
			width = calcSize(0);
			height = calcSize(1);
		}

        volume = (canUseSound ? 1 : 0) * Preference.volume.master;
    }

    public function calcSize(Ind:Int) {
		var appliedWidth:Float = Lib.current.stage.stageHeight * (FlxG.width / FlxG.height);
		var appliedHeight:Float = Lib.current.stage.stageWidth * (FlxG.height / FlxG.width);

		if (appliedHeight > Lib.current.stage.stageHeight)
			appliedHeight = Lib.current.stage.stageHeight;

		if (appliedWidth > Lib.current.stage.stageWidth)
			appliedWidth = Lib.current.stage.stageWidth;

		switch (Ind)
		{
			case 0:
				return Std.int(appliedWidth);
			case 1:
				return Std.int(appliedHeight);
		}

		return 0;
	}
}
#else
class VideoHandler extends hxcodec.VideoHandler {
    override function update(?e:Event) {
        super.update(e);

        volume = Std.int((canUseSound ? 1 : 0) * Preference.volume.master) * 100;
    }
}
#end