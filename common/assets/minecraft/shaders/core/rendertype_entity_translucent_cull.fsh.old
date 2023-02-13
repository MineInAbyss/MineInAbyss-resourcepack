#version 150

#define RENDERING_ITEM

#moj_import <fog.glsl>
#moj_import <utils.glsl>
#moj_import <effects_impl.glsl>
#moj_import <effects.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec4 normal;
in vec4 lightMapValue;
in vec4 baseColor;
in vec2 surfacePosition;
in vec4 clipPos;
in vec3 position;

out vec4 fragColor;

void main() {
    vec4 texSample = texture(Sampler0, texCoord0);

    Surface surface;
    surface.normal = normalize(normal.xyz);
    surface.uv = texCoord0;
    surface.surfacePosition = surfacePosition;
    surface.position = position;
    surface.screenPos = clipPos.xy / clipPos.w;
    surface.albedo = texSample.rgb;
    surface.alpha = texSample.a;
    surface.emissive = 0.0;
    surface.applyDye = 1.0;

    surface.normal *= sign(-dot(surface.normal, position));
    
    applyEffects(surface, colorId(baseColor.rgb));

    vec4 color = vec4(surface.albedo, surface.alpha);
    color *= mix(vec4(1.0), baseColor, surface.applyDye);
    color *= mix(lightMapValue * vertexColor, vec4(1.0), surface.emissive);
    color *= ColorModulator;

    if (color.a < 0.1) {
        discard;
    }

    //fragColor = baseColor;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
