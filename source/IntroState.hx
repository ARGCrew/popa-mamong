import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.display.FlxBackdrop;
import hxcodec.VideoHandler;
// import hxcodec.flixel.FlxVideo;
import haxe.io.Path;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionableState;

class IntroState extends FlxTransitionableState {
	var introFinished:Bool = false;
	var fmodIntroStarted:Bool = false;

	var fmodIntro:FmodIntro;

	override function create() {
		var bg:FlxBackdrop = new FlxBackdrop(FlxG.bitmap.create(FlxG.width, FlxG.height, 0xffffffff));
		add(bg);

		final diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
		FlxTransitionableState.defaultTransIn = new TransitionData(TILES, 0xffffffff, 0.3, FlxPoint.get(-1, 1), {asset: diamond, width: 32, height: 32}, FlxRect.get(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = FlxTransitionableState.defaultTransIn;
		FlxTransitionableState.skipNextTransOut = true;

		fmodIntro = new FmodIntro();
		fmodIntro.finishCallback = () -> {
			haxe.Timer.delay(() -> {
				FlxG.switchState(new menus.MainMenuState());
			}, 300);
		}
		add(fmodIntro);

		var intro:VideoHandler = new VideoHandler();
		intro.finishCallback = () -> {
			FlxG.removeChild(intro);
			introFinished = true;
		}
		FlxG.addChildBelowMouse(intro);
		intro.playVideo(Assets.video('Intro'));

		Fmod.initialize();

		super.create();
	}

	override function update(elapsed:Float) {
		if (introFinished) {
			if (!fmodIntroStarted) {
				fmodIntro.start();
				fmodIntroStarted = true;
			}
		}
		super.update(elapsed);
	}

	/*function createFmodLogo(x:Float = 0, y:Float = 0, width:Int, height:Int):FlxSprite {
		var svg:SVG = new SVG(openfl.Assets.getText('embed/fmod.svg'));
		var shape:Shape = new Shape();
		svg.render(shape.graphics, 0, 0, width, height);

		var bitmap:BitmapData = new BitmapData(width, height, true, 0x00000000);
		bitmap.draw(shape);

		return new FlxSprite(x, y, bitmap);
	}*/
}

class FmodIntro extends FlxGroup {
	var fmod:FlxSprite;

	public function new() {
		super();

		fmod = new FlxSprite('embed/fmod.png');
		fmod.screenCenter();
		fmod.alpha = 0;
		add(fmod);
	}

	public function start() {
		FlxTween.tween(fmod, {alpha: 1}, 0.3, {ease: FlxEase.quadOut, startDelay: 0.3, onComplete: (twn:FlxTween) -> {
			FlxTween.tween(fmod, {alpha: 0}, 0.3, {ease: FlxEase.quadIn, startDelay: 0.5, onComplete: (twn:FlxTween) -> {
				finishCallback();
			}});
		}});
	}

	public dynamic function finishCallback() {}
}