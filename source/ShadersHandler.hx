package;

import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;

class ShadersHandler {
    public static var mosaicShader:MosaicShader = new MosaicShader();
    public static var mosaicFilter:ShaderFilter = new ShaderFilter(new MosaicShader());

    public static var scanlineShader:ScanlineShader = new ScanlineShader();
    public static var scanlineFilter:ShaderFilter = new ShaderFilter(new ScanlineShader());

	public static var vhsShader:VHSShader = new VHSShader();
    public static var vhsFilter:ShaderFilter = new ShaderFilter(new VHSShader());

    public static function setMosaicStrength(strengthX:Float, strengthY:Float) {
        mosaicShader.data.uBlocksize.value[0] = strengthX;
		mosaicShader.data.uBlocksize.value[1] = strengthY;

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

class VHSShader extends FlxShader {
	@:glFragmentSource('
		#pragma header
		
		uniform float iTime;
		uniform sampler2D noiseTexture;
		uniform float noisePercent;
		
		float rand(vec2 co)
		{
			float a = 12.9898;
			float b = 78.233;
			float c = 43758.5453;
			float dt= dot(co.xy ,vec2(a,b));
			float sn= mod(dt,3.14);
			return fract(sin(sn) * c);
		}
			
		float noise(vec2 p)
		{
			return rand(p) * noisePercent;
		}
		
		float onOff(float a, float b, float c)
		{
			return step(c, sin(iTime + a*cos(iTime*b)));
		}

		float ramp(float y, float start, float end)
		{
			float inside = step(start,y) - step(end,y);
			float fact = (y-start)/(end-start)*inside;
			return (1.-fact) * inside;
		}

		float stripes(vec2 uv)
		{
			float noi = noise(uv*vec2(0.5,1.) + vec2(1.,3.));
			return ramp(mod(uv.y*4. + iTime/2.+sin(iTime + sin(iTime*0.63)),1.),0.5,0.6)*noi;
		}

		vec3 getVideo(vec2 uv)
		{
			vec2 look = uv;
			float window = 1./(1.+20.*(look.y-mod(iTime/4.,1.))*(look.y-mod(iTime/4.,1.)));
			look.x = look.x + sin(look.y*10. + iTime)/50.*onOff(4.,4.,.3)*(1.+cos(iTime*80.))*window;
			float vShift = 0.4*onOff(2.,3.,.9) * (sin(iTime)*sin(iTime*20.) + (0.5 + 0.1*sin(iTime*200.)*cos(iTime)));
			look.y = mod(look.y + vShift, 1.);
			vec3 video = vec3(flixel_texture2D(bitmap,look));
			return video;
		}

		vec2 screenDistort(vec2 uv)
		{
			uv -= vec2(.5,.5);
			uv = uv*1.2*(1./1.2+2.*uv.x*uv.x*uv.y*uv.y);
			uv += vec2(.5,.5);
			return uv;
		}

		void main()
        {
			vec2 uv = openfl_TextureCoordv.xy;
			uv = screenDistort(uv);
			vec3 video = getVideo(uv);
			float vigAmt = 3.+.3*sin(iTime + 5.*cos(iTime*5.));
			float vignette = (1.-vigAmt*(uv.y-.5)*(uv.y-.5))*(1.-vigAmt*(uv.x-.5)*(uv.x-.5));
			
			video += stripes(uv);
			video += noise(uv*2.)/2.;
			video *= vignette;
			video *= (12.+mod(uv.y*30.+iTime,1.))/13.;
			
			gl_FragColor = vec4(video,1.0);
		}
	')

	public function new() {
		super();
		iTime.value = [0.0];
		noisePercent.value = [0.0];
	}

	public function update(elapsed:Float) {
		iTime.value[0] += elapsed;
	}

	public function setNoisePercent(amount:Float) {
		noisePercent.value[0] = amount;
	}
}