#ifdef GL_ES
precision highp float;
#endif

#if __VERSION__ >= 140

in vec4 Color0;
in vec2 TexCoord0;
in vec4 ColorizeOut;
in vec3 ColorOffsetOut;
in vec2 TextureSizeOut;
in float PixelationAmountOut;
in vec3 ClipPlaneOut;
out vec4 fragColor;

#else

varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 ColorizeOut;
varying vec3 ColorOffsetOut;
varying vec2 TextureSizeOut;
varying float PixelationAmountOut;
varying vec3 ClipPlaneOut;
#define fragColor gl_FragColor
#define texture texture2D

#endif

uniform sampler2D Texture0;
const vec3 _lum = vec3(0.212671, 0.715160, 0.072169);

const vec2 _waterTL = vec2(64.0, 0.0);

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
	
	vec4 testfragColor;

	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;

	// vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	
	vec4 Color = Color0 * texture(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
	vec4 origColor = texture(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
	
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	testfragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
	
	testfragColor.rgb = mix(testfragColor.rgb, testfragColor.rgb - mod(testfragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmountOut, 0.0, 1.0));
	

	float Time = ColorizeOut.a;
	float proc = (origColor.b - 1.0 - Time * 0.015) * 255.0;
	float rod = (origColor.g  * 256.0) / 25.0;
	float shade = (origColor.r);
	float alpha = (origColor.a);

	if (testfragColor.a > 0.0)   // && proc > 0.0
	{
		//fragColor = vec4(0.0, 0.0, 0.0, 0.001*testfragColor.a);


		vec2 lineCoord = (_waterTL + vec2(0.5 + rod,  mod(-proc * 0.1, 48.0))) / TextureSizeOut;
		vec4 lineCol = Color0 * texture(Texture0, PixelationAmountOut > 0.0 ? lineCoord - mod(lineCoord, pa) + pa * 0.5 : lineCoord);

		lineCol.rgb = lineCol.rgb - vec3(shade, shade*0.5,shade*0.5);
		lineCol.rgba = lineCol.rgba * alpha;
		fragColor = lineCol;
	}
	else
		discard; //fragColor = vec4(0.0, 0.0, 0.0, 1.0);

}