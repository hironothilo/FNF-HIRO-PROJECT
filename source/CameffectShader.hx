package;

import flixel.system.FlxAssets.FlxShader;

class CameffectShader
{
    public var shader(default, null):CamShader = new CamShader();

    public function new():Void
	{
		//shader.distort.value = [0];
	}
}
class CamShader extends FlxShader{
    @:glFragmentSource('
    #pragma header

    /**
    * https://www.shadertoy.com/view/wsdBWM
    **/

    uniform float distort;

    vec2 pincushionDistortion(in vec2 uv, float strength) {
        vec2 st = uv - 0.5;
        float uvA = atan(st.x, st.y);
        float uvD = dot(st, st);
        return 0.5 + vec2(sin(uvA), cos(uvA)) * sqrt(uvD) * (1.0 - strength * uvD);
    }

    void main() {
        float rChannel = texture2D(bitmap, pincushionDistortion(openfl_TextureCoordv, 0.15 * distort)).r;
        float gChannel = texture2D(bitmap, pincushionDistortion(openfl_TextureCoordv, 0.075 * distort)).g;
        float bChannel = texture2D(bitmap, pincushionDistortion(openfl_TextureCoordv, 0.0375 * distort)).b;
        gl_FragColor = vec4(rChannel, gChannel, bChannel, 1.0);
    }
    ')
    public function new()
    {
        super();
    }
}