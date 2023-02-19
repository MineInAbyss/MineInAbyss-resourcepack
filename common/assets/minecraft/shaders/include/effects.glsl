EFFECTS_FILE_START


EFFECT(252, 252, 0) {
    vec4 glitter = sfx_glitter(
        surface,
        0.02,                   // speed
        0.5,                    // scale
        1.0,                    // roughness
        rgb(255, 255, 255),     // color
        50.0,                   // scarcity
        0                       // seed
    );

    surface.albedo *= rgb(20, 20, 20); // dye color
    surface.albedo += glitter.rgb;
    surface.emissive = glitter.a;
}

EFFECT(252, 252, 1) {
    vec4 particleLayer1 = sfx_particles(
        surface,
        ivec2(1792, 512),            // top left corner of the particle in the texture
        ivec2(64, 64),            // size of the particle in the texture
        1.5,                    // size the particle should be ingame
        vec2(0.0, -1.5),        // movementspeed of the particle in x and y direction
        60.0,                   // rotation
        0.9,                    // rotation speed
        vec2(1.1, 0.8),         // movement offset
        1.1,                    // movement offset speed
        3,                      // gap
        0                       // seedm
    );

    vec4 particleLayer2 = sfx_particles(
        surface,
        ivec2(1792, 512),            // top left corner of the particle in the texture
        ivec2(64, 64),            // size of the particle in the texture
        2.0,                    // size the particle should be ingame
        vec2(0.0, -1.5),        // movementspeed of the particle in x and y direction
        45.0,                   // rotation
        0.7,                    // rotation speed
        vec2(1.2, 0.4),         // movement offset
        1.0,                    // movement offset speed
        3,                      // gap
        1                       // seed
    );

    vec4 particleLayer3 = sfx_particles(
        surface,
        ivec2(1792, 512),            // top left corner of the particle in the texture
        ivec2(64,64),            // size of the particle in the texture
        5.5,                    // size the particle should be ingame
        vec2(0.0, -1.5),        // movementspeed of the particle in x and y direction
        30.0,                   // rotation
        0.5,                    // rotation speed
        vec2(1.0, 0.5),         // movement offset
        1.0,                    // movement offset speed
        3,                      // gap
        2                       // seed
    );

    surface.albedo = layer(particleLayer1, surface.albedo).rgb;
    surface.albedo = layer(particleLayer2, surface.albedo).rgb;
    surface.albedo = layer(particleLayer3, surface.albedo).rgb;
}

EFFECT(252, 252, 2) {
    vec4 itembox = sfx_itembox(
        surface,
        0.5,                    // scale
        0.5,                    // shift
        0.15,                   // brighten
        vec3(0.92, 0.24, 0.76), // x axis color
        vec3(0.94, 0.89, 0.37), // y axis color
        vec3(0.42, 0.76, 0.93)  // z axis color
    );

    vec4 glint = sfx_glint(
        surface,
        0.5,                    // scale
        5.0,                    // speed
        12.0,                    // gap
        5.0                     // width
    );

    glint.a *= 0.25; // intensity;

    surface.albedo *= itembox.rgb;
    surface.albedo = layer(glint, surface.albedo).rgb;
    surface.emissive = glint.a;
}

EFFECTS_FILE_END
