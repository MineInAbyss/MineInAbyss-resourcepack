#version 150

#moj_import <fog.glsl>

uniform vec4 ColorModulator;
uniform float GameTime;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;

in float vertexDistance;
in vec4 rawPos;

out vec4 fragColor;

//
//  Simplex Perlin Noise 3D
//  Return value range of -1.0->1.0
//
float snoise(vec3 P) {
    //  https://github.com/BrianSharpe/Wombat/blob/master/SimplexPerlin3D.glsl

    //  simplex math constants
    const float SKEWFACTOR = 1.0/3.0;
    const float UNSKEWFACTOR = 1.0/6.0;
    const float SIMPLEX_CORNER_POS = 0.5;
    const float SIMPLEX_TETRAHADRON_HEIGHT = 0.70710678118654752440084436210485;// sqrt( 0.5 )

    //  establish our grid cell.
    P *= SIMPLEX_TETRAHADRON_HEIGHT;// scale space so we can have an approx feature size of 1.0
    vec3 Pi = floor(P + dot(P, vec3(SKEWFACTOR)));

    //  Find the vectors to the corners of our simplex tetrahedron
    vec3 x0 = P - Pi + dot(Pi, vec3(UNSKEWFACTOR));
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 Pi_1 = min(g.xyz, l.zxy);
    vec3 Pi_2 = max(g.xyz, l.zxy);
    vec3 x1 = x0 - Pi_1 + UNSKEWFACTOR;
    vec3 x2 = x0 - Pi_2 + SKEWFACTOR;
    vec3 x3 = x0 - SIMPLEX_CORNER_POS;

    //  pack them into a parallel-friendly arrangement
    vec4 v1234_x = vec4(x0.x, x1.x, x2.x, x3.x);
    vec4 v1234_y = vec4(x0.y, x1.y, x2.y, x3.y);
    vec4 v1234_z = vec4(x0.z, x1.z, x2.z, x3.z);

    // clamp the domain of our grid cell
    Pi.xyz = Pi.xyz - floor(Pi.xyz * (1.0 / 69.0)) * 69.0;
    vec3 Pi_inc1 = step(Pi, vec3(69.0 - 1.5)) * (Pi + 1.0);

    //	generate the random vectors
    vec4 Pt = vec4(Pi.xy, Pi_inc1.xy) + vec2(50.0, 161.0).xyxy;
    Pt *= Pt;
    vec4 V1xy_V2xy = mix(Pt.xyxy, Pt.zwzw, vec4(Pi_1.xy, Pi_2.xy));
    Pt = vec4(Pt.x, V1xy_V2xy.xz, Pt.z) * vec4(Pt.y, V1xy_V2xy.yw, Pt.w);
    const vec3 SOMELARGEFLOATS = vec3(635.298681, 682.357502, 668.926525);
    const vec3 ZINC = vec3(48.500388, 65.294118, 63.934599);
    vec3 lowz_mods = vec3(1.0 / (SOMELARGEFLOATS.xyz + Pi.zzz * ZINC.xyz));
    vec3 highz_mods = vec3(1.0 / (SOMELARGEFLOATS.xyz + Pi_inc1.zzz * ZINC.xyz));
    Pi_1 = (Pi_1.z < 0.5) ? lowz_mods : highz_mods;
    Pi_2 = (Pi_2.z < 0.5) ? lowz_mods : highz_mods;
    vec4 hash_0 = fract(Pt * vec4(lowz_mods.x, Pi_1.x, Pi_2.x, highz_mods.x)) - 0.49999;
    vec4 hash_1 = fract(Pt * vec4(lowz_mods.y, Pi_1.y, Pi_2.y, highz_mods.y)) - 0.49999;
    vec4 hash_2 = fract(Pt * vec4(lowz_mods.z, Pi_1.z, Pi_2.z, highz_mods.z)) - 0.49999;

    //	evaluate gradients
    vec4 grad_results = inversesqrt(hash_0 * hash_0 + hash_1 * hash_1 + hash_2 * hash_2) * (hash_0 * v1234_x + hash_1 * v1234_y + hash_2 * v1234_z);

    //	Normalization factor to scale the final result to a strict 1.0->-1.0 range
    //	http://briansharpe.wordpress.com/2012/01/13/simplex-noise/#comment-36
    const float FINAL_NORMALIZATION = 37.837227241611314102871574478976;

    //  evaulate the kernel weights ( use (0.5-x*x)^3 instead of (0.6-x*x)^4 to fix discontinuities )
    vec4 kernel_weights = v1234_x * v1234_x + v1234_y * v1234_y + v1234_z * v1234_z;
    kernel_weights = max(0.5 - kernel_weights, 0.0);
    kernel_weights = kernel_weights*kernel_weights*kernel_weights;

    //	sum with the kernel and return
    return dot(kernel_weights, grad_results) * FINAL_NORMALIZATION;
}

float fbm(vec3 x) {
    // Properties
    const int octaves = 4;
    float lacunarity = 2.5;
    float gain = 0.5;

    // Initial values
    float amplitude = 0.5;
    float frequency = 1.;
    float y = 0.0;

    // Octave loop
    for (int i = 0; i < octaves; i++) {
        y += amplitude * snoise(frequency*x);
        frequency *= lacunarity;
        amplitude *= gain;
    }
    return y;
}

// This function makes a 3D space that you can sample to get a color.
// In this case, the part that is sampled is a unit sphere around the origin, but you can displace it however you want.
vec3 sampleStarfield(vec3 v) {
    float stars = max(0, snoise(v * 100 + GameTime*100.0)-0.7) * 5;
    float starfield = max(0.05, snoise(v * vec3(1, 1, 0.5) + GameTime*100.0));
    float intensity = 1.0 - (ColorModulator.r + ColorModulator.g + ColorModulator.b);
    if (intensity > 0) {
        stars *= starfield;
    }

    float res = fbm(v * 2 + vec3(GameTime*10.0, 0, 0));
    vec3 sky = vec3(0, 0, 0);
    if (intensity > 0) {
        sky = max(0, res+0.1) * vec3(36, 24, 39)/255;
    } else {
        sky = max(0, res+0.1) * vec3(0, 0, 0)/255;
    }

    float res2 = fbm(v * 2.5 + vec3(0, GameTime*10.0, 0) + vec3(10.4, 0, 0));
    if (intensity > 0) {
        sky += max(0, res2+0.15) * vec3(21, 38, 76)/255;
    } else {
        sky += max(0, res2+0.15) * vec3(128, 128, 128)/255;
    }

    if (intensity > 0) {
        sky += stars;
        sky += starfield * 0.1;
    }

    // Spacial dithering to remove banding
    float grid_position = fract(dot(gl_FragCoord.xy - vec2(0.5, 0.5), vec2(1.0/16.0, 10.0/36.0)+0.25));
    float dither = grid_position / 256;

    sky += dither;

    return sky;
}

void main() {
    // Make sure it is dark enough to do this
    float intensity = 1.0 - (ColorModulator.r + ColorModulator.g + ColorModulator.b);
    // if (intensity < 0) {
    // 	fragColor = ColorModulator;
    // 	return;
    // }
    // Obtain a -1..1 screen relative position
    vec2 pos = gl_FragCoord.xy / ScreenSize;
    pos -= vec2(0.5, 0.5);
    pos *= 2;

    // This is a position at the screen we're casting to.
    vec4 cast_pos = vec4(pos, 1.0, 1.0);

    // Apply inverse projective transform to the screen
    // This corrects the aspect ratio, applies the FoV and misc stuff like view bobbing
    cast_pos = inverse(ProjMat) * cast_pos;

    // Transform the point on the screen into a sphere by normalizing distance
    cast_pos = normalize(cast_pos);

    // Apply the inverse model view transform to rotate the view
    vec3 v = normalize(cast_pos.xyz * mat3(ModelViewMat));

    // Finally, sample the starfield
    if (intensity > 0) {
        fragColor = vec4(sampleStarfield(v), 1.0) /** intensity*/ + ColorModulator;
    } else {
        fragColor = vec4(sampleStarfield(v), 1.0) /** intensity*/ + ColorModulator;
    }
}
