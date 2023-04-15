package;

import openfl.Lib;

import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;

class ShadersHandler {
    public static var mosaicEffect:MosaicShader = new MosaicShader();
    public static var mosaicFilter:ShaderFilter = new ShaderFilter(new MosaicShader());

    public static var scanlineEffect:ScanlineShader = new ScanlineShader();
    public static var scanlineFilter:ShaderFilter = new ShaderFilter(new ScanlineShader());

    public static function setMosaicStrength(strengthX:Float, strengthY:Float) {
        mosaicEffect.data.uBlocksize.value[0] = strengthX;
		mosaicEffect.data.uBlocksize.value[1] = strengthY;

		mosaicFilter.shader.data.uBlocksize.value[0] = strengthX;
		mosaicFilter.shader.data.uBlocksize.value[1] = strengthY;
	}
}

class MosaicShader extends FlxShader {
	@:glFragmentSource('
		#pragma header
        
		uniform vec2 uBlocksize;

		void main()
		{
			vec2 blocks = openfl_TextureSize / uBlocksize;
			gl_FragColor = flixel_texture2D(bitmap, floor(openfl_TextureCoordv * blocks) / blocks);
		}
    ')

	public function new() {
		super();
	}
}

class ScanlineShader extends FlxShader {
    @:glFragmentSource('
		#pragma header

		const float scale = 1.0;

		void main() {
			if (mod(floor(openfl_TextureCoordv.y * openfl_TextureSize.y / scale), 2.0) == 0.0) {
				gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
			} else {
				gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);
			}
		}
    ')

    public function new() {
        super();
    }
}