package;

import ScanlineShader.ButtonShader;
import openfl.filters.ShaderFilter;

class ShadersHandler {
    public static var mosaicShader:MosaicShader = new MosaicShader();
    public static var mosaicFilter:ShaderFilter = new ShaderFilter(new MosaicShader());

    public static var scanlineShader:ScanlineShader = new ScanlineShader();
    public static var scanlineFilter:ShaderFilter = new ShaderFilter(new ScanlineShader());

    public static var buttonShader:ButtonShader = new ButtonShader();

    public static function setMosaicStrength(strengthX:Float, strengthY:Float) {
        mosaicShader.data.uBlocksize.value[0] = strengthX;
		mosaicShader.data.uBlocksize.value[1] = strengthY;

		mosaicFilter.shader.data.uBlocksize.value[0] = strengthX;
		mosaicFilter.shader.data.uBlocksize.value[1] = strengthY;
	}
}