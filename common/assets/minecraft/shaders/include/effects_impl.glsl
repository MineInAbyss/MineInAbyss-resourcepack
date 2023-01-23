uniform float GameTime;
uniform sampler2D Sampler0;

vec4 sfx_glitter(Surface surface, float speed, float scale, float roughness, vec3 color, float scarcity, float seed) {
    vec2 ts = vec2(textureSize(Sampler0, 0));
    vec2 pixelatedUv = scale * floor(surface.uv * ts / scale) / ts;

    float theta = TWO_PI * random(pixelatedUv + seed);
    float phi = acos(1.0 - 2.0 * random(pixelatedUv + seed + 1.0));
    vec3 normal = vec3(sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi));
    
    vec3 n = surface.normal;
    vec3 t = normalize(cross(surface.normal, vec3(0.0, 1.0, 0.0)));
    vec3 b = normalize(cross(surface.normal, t));

    normal = mix(n, normal.x * t + normal.y * n + normal.z * b, roughness);

    vec3 toCamera = normalize(-surface.position);

    float glitter = max(dot(normal, toCamera), 0.0);
    glitter = pow(glitter, scarcity);
    
    return vec4(color * glitter, surface.alpha * glitter);
}

vec4 sfx_particles(Surface surface, ivec2 topLeftCorner, ivec2 particleTextureSize, float size, vec2 movementSpeed, float rotation, float rotationSpeed, vec2 movementOffset, float movementOffsetSpeed, int gap, float seed) {
    vec2 ts = vec2(textureSize(Sampler0, 0));

    float cellSize = size * SQRT_TWO;

    float timeOffset = random(vec2(seed, seed));
    vec2 uvOffset = vec2(random(vec2(seed + 1.0, seed)), random(vec2(seed, seed + 1.0)));
    float invertRotation = sign(random(vec2(seed + 2.0, seed)) - 0.5);
    
    float angle = invertRotation * sin((timeOffset + GameTime) * 1200.0 * PI * rotationSpeed) * rotation * PI / 180.0;

    vec2 uv = (surface.uv + uvOffset) * ts / cellSize;
    uv += movementSpeed * ((timeOffset + GameTime) * 1200.0 / cellSize);
    uv += movementOffset * sin((timeOffset + GameTime) * 1200.0 * PI * movementOffsetSpeed / cellSize);

    ivec2 gridPos = ivec2(floor(uv));
    if(!((gridPos.x + 1000) % gap == 0 && (gridPos.y + 1000) % gap == 0))
        return vec4(0.0);

    vec2 cellUv = fract(uv);
    cellUv = (mat2(
        cos(angle), -sin(angle),
        sin(angle), cos(angle)
    ) * (cellUv - 0.5) * SQRT_TWO) + 0.5;
    if(cellUv.x < 0.0 || cellUv.x > 1.0 || cellUv.y < 0.0 || cellUv.y > 1.0)
        return vec4(0.0);

    vec4 tex = texture(Sampler0, (cellUv * vec2(particleTextureSize) + vec2(topLeftCorner)) / ts);
    tex.a *= surface.alpha;
    return tex;
}

vec4 sfx_glint(Surface surface, float scale, float glintSpeed, float glintGap, float glintSize) {
    vec2 ts = vec2(textureSize(Sampler0, 0));
    vec2 scaledUv = surface.uv * ts;
    ivec2 pixel = ivec2(floor(surface.uv * ts / scale));

    float glintT = scaledUv.x + scaledUv.y - GameTime * 1200.0 * glintSpeed;
    if(pixel.x % 2 == 0 && pixel.y % 2 == 0)
        glintT += 1.5;
        
    float glint = (mod(glintT, glintGap + glintSize) < glintSize) ? 1.0 : 0.0;
    return vec4(1.0, 1.0, 1.0, glint * surface.alpha);
}

vec4 sfx_itembox(Surface surface, float scale, float shift, float brighten, vec3 xcol, vec3 ycol, vec3 zcol) {
    vec2 ts = vec2(textureSize(Sampler0, 0));
    ivec2 pixel = ivec2(floor(surface.uv * ts / scale));
    vec3 normal = surface.normal;

    if(pixel.x % 2 == 0 && pixel.y % 2 == 0)
        normal = normalize(mix(normal, normal.yzx, shift));

    vec3 triPlanarWeights = abs(normal * normal * normal);
    triPlanarWeights /= (triPlanarWeights.x + triPlanarWeights.y + triPlanarWeights.z);

    vec3 color = vec3(0.0);
    color += xcol * max(0.0, triPlanarWeights.x);
    color += ycol * max(0.0, triPlanarWeights.y);
    color += zcol * max(0.0, triPlanarWeights.z);

    if(pixel.x % 2 == 0 && pixel.y % 2 == 0)
        color += vec3(brighten);

    return vec4(color, surface.alpha);
}