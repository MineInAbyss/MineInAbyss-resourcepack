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

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}
float field(in vec3 p,float s) {
	float strength = 7. + .03 * log(1.e-6 + fract(sin(GameTime) * 4373.11));
	float accum = s/4.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < 16; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) / 7.);
		accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
		tw += w;
		prev = mag;
	}
	return max(0., 5. * accum / tw - .7);
}

// Less iterations for second layer
float field2(in vec3 p, float s) {
	float strength = 7. + .03 * log(1.e-6 + fract(sin(GameTime) * 4373.11));
	float accum = s/4.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < 18; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) / 7.);
		accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
		tw += w;
		prev = mag;
	}
	return max(0., 5. * accum / tw - .7);
}

vec3 nrand3( vec3 co )
{
	vec3 a = fract( cos( co.x*8.3e-3 + co.y + co.z*0.1e-3)*vec3(1.3e5, 4.7e5, 2.9e5) );
	vec3 b = fract( sin( co.x*0.3e-3 + co.y + co.z*0.2e-3)*vec3(8.1e5, 1.0e5, 0.1e5) );
	vec3 c = mix(a, b, 0.5);
	return c;
}


vec4 sampleStarfield(vec3 p) {
	p *= 0.8;
	float time = GameTime * 1000.0;
    vec2 uv = vec2(p);
	vec2 uvs = uv * ScreenSize.xy / max(ScreenSize.x, ScreenSize.y);
	
	p += .2 * vec3(sin(time / 16.), sin(time / 12.),  sin(time / 128.));
	
	float freqs[4];
	//Sound
	freqs[0] = noise(vec3( 0.01*100.0, 0.25 ,time/10.0) );
	freqs[1] = noise(vec3( 0.07*100.0, 0.25 ,time/10.0) );
	freqs[2] = noise(vec3( 0.15*100.0, 0.25 ,time/10.0) );
	freqs[3] = noise(vec3( 0.30*100.0, 0.25 ,time/10.0) );

	float t = field(p,freqs[2]);
	float v = (1. - exp((abs(p.x) - 1.) * 6.)) * (1. - exp((abs(p.y) - 1.) * 6.)) * (1. - exp((abs(p.z) - 1.) * 6.));
	
	/*
    //Second Layer
	vec3 p2 = p / (4.+sin(time*0.11)*0.2+0.2+sin(time*0.15)*0.3+0.4) + vec3(2., -1.3, -1.);
	p2 += 0.25 * vec3(sin(time / 16.), sin(time / 12.),  sin(time / 128.));
	float t2 = field2(p2,freqs[3]);
	vec4 c2 = mix(.4, 1., v) * vec4(1.3 * t2 * t2 * t2 ,1.8  * t2 * t2 , t2* freqs[0], t2);
	*/
	
	vec4 c2 = vec4(0);
	
	vec4 starcolor = vec4(0);
	
	//Let's add some stars
	//Thanks to http://glsl.heroku.com/e#6904.0
	/*vec3 seed = p * 2.0;	
	seed = floor(seed * ScreenSize.x);
	vec3 rnd = nrand3( seed );
	starcolor += vec4(pow(rnd.y,40.0));
	
	//Second Layer
	vec3 seed2 = p2 * 2.0;
	seed2 = floor(seed2 * ScreenSize.x);
	vec3 rnd2 = nrand3( seed2 );
	starcolor += vec4(pow(rnd2.y,40.0));*/
	
	return mix(freqs[3]-.3, 1., v) * vec4(1.5*freqs[2] * t * t* t , 1.2*freqs[1] * t * t, freqs[3]*t, 1.0)+c2+starcolor;
}

vec4 transRights(vec3 pos) {
	if (abs(pos.y) > 0.30) {
		return vec4( 96, 205, 248, 255) / 255;
	} else if (abs(pos.y) > 0.10) {
		return vec4(243, 168, 183, 255) / 255;
	} else {
		return vec4(255, 255, 255, 255) / 255;
	}
}

void main() {
    // Obtain a -1..1 screen relative position
    vec2 pos = gl_FragCoord.xy / ScreenSize;
    pos -= vec2(0.5, 0.5);
    pos *= 2;

    // This is a position at the screen we're casting to.
    vec4 cast_pos = vec4(pos, 1.0, 1.0);

    // Apply inverse projective transform to the screen
    // This corrects the aspect ratio, applies the FoV and misc stuff likehttps://twitter.com/selicre view bobbing
    cast_pos = inverse(ProjMat) * cast_pos;

    // Transform the point on the screen into a sphere by normalizing distance
    cast_pos = normalize(cast_pos);

    // Apply the inverse model view transform to rotate the view
    vec3 v = normalize(cast_pos.xyz * mat3(ModelViewMat));

    // Finally, sample the starfield
    fragColor = sampleStarfield(v);
}


