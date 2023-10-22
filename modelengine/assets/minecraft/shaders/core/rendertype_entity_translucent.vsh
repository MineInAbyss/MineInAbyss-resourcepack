#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec4 normal;
out float part;

#define SPACING 1024.0
#define MAXRANGE (0.5 * SPACING)

const vec4[] subuvs = vec4[](
	// 4x4x12
	vec4(4.0,  0.0,  8.0,  4.0 ), // Top
	vec4(8.0,  0.0,  12.0, 4.0 ), // Bottom
	vec4(0.0,  4.0,  4.0,  16.0), // Right
	vec4(4.0,  4.0,  8.0,  16.0), // Front
	vec4(8.0,  4.0,  12.0, 16.0), // Left
	vec4(12.0, 4.0,  16.0, 16.0), // Back

	// 4x3x12
	vec4(4.0,  0.0,  7.0,  4.0 ),
	vec4(7.0,  0.0,  10.0, 4.0 ),
	vec4(0.0,  4.0,  4.0,  16.0),
	vec4(4.0,  4.0,  7.0,  16.0),
	vec4(7.0,  4.0,  11.0, 16.0),
	vec4(11.0, 4.0,  14.0, 16.0),

	// 4x8x12
	vec4(4.0,  0.0,  12.0, 4.0 ),
	vec4(12.0,  0.0, 20.0, 4.0 ),
	vec4(0.0,  4.0,  4.0,  16.0),
	vec4(4.0,  4.0,  12.0, 16.0),
	vec4(12.0, 4.0,  16.0, 16.0),
	vec4(16.0, 4.0,  24.0, 16.0)
);

const vec2[] origins = vec2[](
	vec2(40.0, 16.0), // right arm
	vec2(40.0, 32.0),
	vec2(32.0, 48.0), // left arm
	vec2(48.0, 48.0),
	vec2(16.0, 16.0), // torso
	vec2(16.0, 32.0),
	vec2(0.0,  16.0), // right leg
	vec2(0.0,  32.0),
	vec2(16.0, 48.0), // left leg
	vec2(0.0,  48.0)
);

void main() {
	vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, normalize(Normal), Color);
	lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
	overlayColor = texelFetch(Sampler1, UV1, 0);
	normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);

	ivec2 dim = textureSize(Sampler0, 0);

	if (ProjMat[2][3] == 0.0 || dim.x != 64 || dim.y != 64) { // short circuit if cannot be player
		part = 0.0;
		texCoord0 = UV0;
		texCoord1 = vec2(0.0);
		vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
		gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
	}
	else {
		vec3 wpos = IViewRotMat * Position;
		vec2 UVout = UV0;
		vec2 UVout2 = vec2(0.0);
		int partId = -int((wpos.y - MAXRANGE) / SPACING);

		part = float(partId);

		if (partId == 0) { // higher precision position if no translation is needed
			gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
		}
		else {
			vec4 samp1 = texture(Sampler0, vec2(54.0 / 64.0, 20.0 / 64.0));
			vec4 samp2 = texture(Sampler0, vec2(55.0 / 64.0, 20.0 / 64.0));
			bool slim = samp1.a == 0.0 || (((samp1.r + samp1.g + samp1.b) == 0.0) && ((samp2.r + samp2.g + samp2.b) == 0.0) && samp1.a == 1.0 && samp2.a == 1.0);
			int outerLayer = (gl_VertexID / 24) % 2;

			// True face ID
			int tFaceId = gl_VertexID % 24 / 4;
			int vertexId = gl_VertexID % 4;

			// Convert UV into int coords, and try to offset them back to the top right corner
			// This would fail to offset the coords correctly if it is the bottom face
			int u = int(UV0.x * 64);
			int v = int(UV0.y * 64);
			switch(vertexId) {
				case 0:
					u -= 8;
					break;
				case 1:
					break;
				case 2:
					v -= 8;
					break;
				case 3:
					u -= 8;
					v -= 8;
					break;
			}

			// Assume the face is bottom
			int faceId = 1;
			// Unique ID for each pixel
			int pixel = u + v * 16;
			if(v >= 0) { // If V is in the negative, it means it is the bottom face since vertex 2 and 3 is at V 0
				switch(pixel) {
					case 8:
					case 40:
						faceId = 0; // UP
						break;
					case 128:
					case 160:
						faceId = 2; // RIGHT
						break;
					case 136:
					case 168:
						faceId = 3; // FRONT
						break;
					case 144:
					case 176:
						faceId = 4; // LEFT
						break;
					case 152:
					case 184:
						faceId = 5; // BACK
						break;
				}
			}

			// Face ID 1, could be VANILLA BOTTOM or IRIS RIGHT
			// Check for vanilla face 1. If UV is at the wrong place, it is the bottom face
			// Sanity check. In this case, true face ID points to bottom face
			if(tFaceId == 1) {
				// If the pixel doesn't points to top right of right face on skin and hat layer.
				// It must be the bottom face
				// Assuming it is VANILLA, it will point to 144 or 176 (Bottom)
				// Assuming it is IRIS, it will point to 128 or 160 (Right face)
				if(pixel != 128 && pixel != 160)
					faceId = 1;
			}

			// Face ID 3, could be VANILLA FORWARD or IRIS BOTTOM
			// Same as above, but check for iris face 3.
			// Sanity check. In this case, true face ID points to right face
			else if(tFaceId == 3) {
				// If the pixel doesn't points to top right of front face on skin and hat layer.
				// It must be the bottom face
				// Assuming it is VANILLA, it will point to 136 or 168 (Forward face)
				// Assuming it is IRIS, it will point to 144 or 176 (Bottom)
				if(pixel != 136 && pixel != 168)
					faceId = 1;
			}

			int subuvIndex = faceId;

			wpos.y += SPACING * partId;
			gl_Position = ProjMat * ModelViewMat * vec4(inverse(IViewRotMat) * wpos, 1.0);

			UVout = origins[2 * (partId - 1) + outerLayer];
			UVout2 = origins[2 * (partId - 1)];

			if (slim && (partId == 1 || partId == 2)) {
				subuvIndex += 6;
			}
			else if (partId == 3) {
				subuvIndex += 12;
			}

			vec4 subuv = subuvs[subuvIndex];

			vec2 offset = vec2(0.0);
			if (faceId == 1) {
				if (vertexId == 0) {
					offset += subuv.zw;
				}
				else if (vertexId == 1) {
					offset += subuv.xw;
				}
				else if (vertexId == 2) {
					offset += subuv.xy;
				}
				else {
					offset += subuv.zy;
				}
			}
			else {
				if (vertexId == 0) {
					offset += subuv.zy;
				}
				else if (vertexId == 1) {
					offset += subuv.xy;
				}
				else if (vertexId == 2) {
					offset += subuv.xw;
				}
				else {
					offset += subuv.zw;
				}
			}

			UVout += offset;
			UVout2 += offset;
			UVout /= 64.0;
			UVout2 /= 64.0;
		}

		vertexDistance = fog_distance(ModelViewMat, wpos, FogShape);
		texCoord0 = UVout;
		texCoord1 = UVout2;
	}
}