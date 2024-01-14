import flixel.addons.display.FlxRuntimeShader;
import flixel.system.FlxPreloader;

/**
 * DON'T THINK ABOUT IT.
 */
class Preloader extends FlxPreloader {
	override function create() {
		super.create();

		var shader:FlxRuntimeShader = new FlxRuntimeShader('
			#pragma header

			void main() {
				gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
				float color = (gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) / 3;
				gl_FragColor.rgb = vec3(color);
			}
		');

		_buffer.shader = shader;
		_bmpBar.shader = shader;
		_text.shader = shader;
		_logo.shader = shader;
		_logoGlow.shader = shader;
	}
}