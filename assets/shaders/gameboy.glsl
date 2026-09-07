// pass the color palette (four sets of rgb values)
extern vec3 palette[4];

// pass flash/dark amount values [0,1] to brighten or darken screen
// recommend staggering for retro effect instead of smooth values
extern float flashAmount;
extern float darkenAmount;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords)
{
	vec4 pixel = Texel(tex, uv);

	// get dot product of rgb
	// multiply by 0.299,0.587,0.114
	// because humans perceive green as brighter, blue as darker
	// brightness is [0,1]
	float brightness = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));

	// apply flash and darken
	brightness = brightness + flashAmount - darkenAmount;
	brightness = clamp(brightness, 0.0, 1.0);

	// luminance quantization into 4 discrete levels
	float level = min(int(brightness * 4.0), 3);

	// brightness 0 -> 0.25 = 0
	// brightness 0.25 -> 0.5 = 1
	// brightness 0.5 -> 0.75 = 2
	// brightness 0.75 -> 1 = 3
	level = min(level, 3.0);

	vec3 gbColor;

	if (level == 0)
		gbColor = palette[0];
	else if (level == 1)
		gbColor = palette[1];
	else if (level == 2)
		gbColor = palette[2];
	else
		gbColor = palette[3];

	return vec4(gbColor, pixel.a) * color;
}
