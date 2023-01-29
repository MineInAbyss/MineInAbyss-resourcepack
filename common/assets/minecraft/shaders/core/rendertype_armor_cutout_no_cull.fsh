#version 150

#define RENDERING_ARMOR

#moj_import <fog.glsl>
#moj_import <light.glsl>
#moj_import <fog.glsl>
#moj_import <utils.glsl>
#moj_import <effects_impl.glsl>
#moj_import <effects.glsl>

#define TEX_RES 16
#define ANIM_SPEED 50 // Runs every 24 seconds
#define IS_LEATHER_LAYER texelFetch(Sampler0, ivec2(0, 1), 0) == vec4(1) // If it's leather_layer_X.png texture

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec4 normal;
in vec4 lightMapValue;
in vec2 surfacePosition;
in vec4 clipPos;
in vec3 position;
flat in vec4 tint;
flat in vec3 vNormal;
flat in vec4 texel;

out vec4 fragColor;

void main()
{
    ivec2 atlasSize = textureSize(Sampler0, 0);
    float armorAmount = atlasSize.x / (TEX_RES * 4.0);
    float maxFrames = atlasSize.y / (TEX_RES * 2.0);

    vec2 coords = texCoord0;
    coords.x /= armorAmount;
    coords.y /= maxFrames;

    vec4 color;

    vec4 light = lightMapValue;
    float emissive = 0.0;

    if(IS_LEATHER_LAYER)
    {
        // Texture properties contains extra info about the armor texture, such as to enable shading
        vec4 textureProperties = vec4(0);
        vec4 customColor = vec4(0);

        float h_offset = 1.0 / armorAmount;
        vec2 nextFrame = vec2(0);
        float interpolClock = 0;

        for (int i = 1; i < (armorAmount + 1); i++)
        {
            customColor = texelFetch(Sampler0, ivec2(TEX_RES * 4 * i + 0.5, 0), 0);
            if (tint == customColor){

                coords.x += (h_offset * i);
                vec4 animInfo = texelFetch(Sampler0, ivec2(TEX_RES * 4 * i + 1.5, 0), 0);
                animInfo.rgb *= animInfo.a * 255;
                textureProperties = texelFetch(Sampler0, ivec2(TEX_RES * 4 * i + 2.5, 0), 0);
                textureProperties.rgb *= textureProperties.a * 255;
                if (animInfo != vec4(0))
                {
                    // oh god it's animated
                    // animInfo = amount of frames, speed, interpolation (1||0)
                    // textureProperties = emissive, tint
                    // fract(GameTime * 1200) blinks every second so [0,1] every second
                    float timer = floor(mod(GameTime * ANIM_SPEED * animInfo.g, animInfo.r));
                    if (animInfo.b > 0)
                        interpolClock = fract(GameTime * ANIM_SPEED * animInfo.g);
                    float v_offset = (TEX_RES * 2.0) / atlasSize.y * timer;
                    nextFrame = coords;
                    coords.y += v_offset;
                    nextFrame.y += (TEX_RES * 2.0) / atlasSize.y * mod(timer + 1, animInfo.r);
                }
                break;
            }
        }

        if (textureProperties.r > 1)
        {
            emissive = 1.0;
        }
        else if (textureProperties.r == 1)
        {
            if (texture(Sampler0, vec2(coords.x + h_offset, coords.y)).a != 0)
            {
                emissive = texture(Sampler0, vec2(coords.x + h_offset, coords.y)).a;
            }
        }

        vec4 armor = mix(texture(Sampler0, coords), texture(Sampler0, nextFrame), interpolClock);

        // If it's the first leather texture in the atlas (used for the vanilla leather texture, with no custom color specified)
        vec4 dye = vec4(1.0);
        if (coords.x < (1 / armorAmount))
            dye = tint;
        
        Surface surface;
        surface.normal = normalize(normal.xyz);
        surface.uv = coords;
        surface.surfacePosition = surfacePosition;
        surface.position = position;
        surface.screenPos = clipPos.xy / clipPos.w;
        surface.albedo = armor.rgb;
        surface.alpha = armor.a;
        surface.emissive = emissive;
        surface.applyDye = 1.0;

        surface.normal *= sign(-dot(surface.normal, position));
    
        applyEffects(surface, colorId(tint.rgb));

        color = vec4(surface.albedo, surface.alpha);
        color *= mix(vec4(1.0), dye, surface.applyDye);
        color *= mix(light * vertexColor, vec4(1.0), surface.emissive);
        color *= ColorModulator;
    }
    else // If it's another vanilla armor, for example diamond_layer_1.png or diamond_layer_2.png
    {
        color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    }

    if (color.a < 0.1)
        discard;

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}