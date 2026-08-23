extern number time;
extern vec2 textureSize;
extern vec2 center;
extern number progress;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
  vec2 aspect = vec2(textureSize.x / textureSize.y, 1.0);

  // position of pixel relative to center
  vec2 fromCenter = (texture_coords - center) * aspect;

  // distance of pixel from center (0 at center, 1 at edge of screen)
  float dist = length(fromCenter);

  // normalized direction from center to pixel (0 to 1)
  vec2 dir = fromCenter / max(dist, 0.0001);

  // direction of pixel relative to center, normalized to UV (aspect ratio)
  vec2 dirUv = vec2(dir.x / aspect.x , dir.y);

  // eased runs from 0 to 1 (center to edge), slows down as it approaches 1
  float eased = 1.0 - pow(1.0 - progress, 2.0);
  float radius = eased * 1.2;

  // signed distance field from the ring edge
  float signedDiff = dist - radius;
  float ringDistance = abs(signedDiff);

  float ringDistanceThreshold = 0.4;
  float ringThickness = 1.0 - smoothstep(0.0, ringDistanceThreshold, ringDistance);

  float rippleFrequency = 20.0;
  float rippleSpeed = 6.0;
  float ripple = sin(signedDiff * rippleFrequency - time * rippleSpeed);

  float fade = 1.0 - smoothstep(0.55, 1.0, progress);
  float strength = ripple * ringThickness * 0.02 * fade;

  vec2 sampleUv = texture_coords + dirUv * strength;
  vec4 samplePixel = Texel(tex, sampleUv);

  return samplePixel * color;
}
