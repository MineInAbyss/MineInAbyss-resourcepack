struct Surface {
    vec3 normal;
    vec2 uv;
    vec2 surfacePosition;
    vec3 position;
    vec3 positionVS;
    vec2 screenPos;
    float alpha;
    vec3 albedo;
    float emissive;
    float applyDye;
};

#define PI 3.14159265359
#define TWO_PI 6.28318530718
#define SQRT_TWO 1.41421356237

vec3 rgb(int r, int g, int b) {
    return vec3(r / 255.0, g / 255.0, b / 255.0);
}

vec3 hsv(int h, int s, int v) {
    vec3 c = vec3(h / 255.0, s / 255.0, v / 255.0);
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 hsvToRgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 rgbToHsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec4 layer(vec4 topColor, vec4 bottomColor) {
    return bottomColor * (1.0 - topColor.a) + topColor * topColor.a;
}

vec4 layer(vec4 topColor, vec3 bottomColor) {
    return layer(topColor, vec4(bottomColor, 1.0));
}

uint colorId(vec3 col) {
    uint r = uint(round(col.r * 255.0));
    uint g = uint(round(col.g * 255.0));
    uint b = uint(round(col.b * 255.0));
    return (r << 16) | (g << 8) | (b);
}

float random(vec2 seed) {
    return fract(sin(dot(seed, vec2(12.9898,78.233))) * 43758.5453);
}

#define EFFECTS_FILE_START void applyEffects(inout Surface surface, uint vertexColorId) { switch(vertexColorId) { case 16777215u:
#define EFFECTS_FILE_END return; }}

#define EFFECT(r, g, b) return; case ((uint(r) << 16) | (uint(g) << 8) | uint(b)): surface.applyDye = 0.0;