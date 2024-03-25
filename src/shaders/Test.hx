package shaders;

import hxsl.Shader;

class Test extends Shader {
	static final SRC = {
		var pixelColor:Vec4;

		function fragment() {
			pixelColor = vec4(1, 0, 0, 1);
		}
	};
}