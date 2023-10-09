#version 150

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0, Sampler2;
uniform mat4 ModelViewMat, ProjMat;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
  gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.);
  vertexDistance = length((ModelViewMat * vec4(Position, 1.)).xyz);
  texCoord0 = UV0;

  if ( Color.xyz == vec3( 254 ) / 255.0 ) {
    vec2 dimensions = textureSize( Sampler0, 0 );
    vec2 texShift = 1 / dimensions;

    // Just in case the texture is not its own image
    // Otherwise we could just fetch the pixel at 0, 0
    ivec2 quadrantUV = ivec2( UV0 * dimensions );
    vec4 quadrant = texelFetch( Sampler0, quadrantUV, 0 );
    vec2 newUV0 = UV0;
    if ( quadrant.a == ( 149.0 / 255.0 ) ) {
      vec4 infoPix1 = vec4( 0 );
      vec4 infoPix2 = vec4( 0 );
      vertexColor = vec4( 1 );
      if ( quadrant.r == 1.0 / 255.0 ) {
        infoPix1 = texelFetch( Sampler0, quadrantUV + ivec2( 1, 0 ), 0 );
        infoPix2 = texelFetch( Sampler0, quadrantUV + ivec2( 0, 1 ), 0 );
        newUV0 = newUV0 + ( quadrant.gb * 255 + 1 ) / dimensions;
      } else if ( quadrant.r == 0.0 / 255.0 ) {
        infoPix1 = texelFetch( Sampler0, quadrantUV - ivec2( 1, 0 ), 0 );
        infoPix2 = texelFetch( Sampler0, quadrantUV + ivec2( 0, 1 ), 0 );
        newUV0 = newUV0 + ( quadrant.gb * 255 + vec2( -1, 1 ) ) / dimensions;
      } else if ( quadrant.r == 3.0 / 255.0 ) {
        infoPix1 = texelFetch( Sampler0, quadrantUV - ivec2( 1, 0 ), 0 );
        infoPix2 = texelFetch( Sampler0, quadrantUV - ivec2( 0, 1 ), 0 );
        newUV0 = newUV0 + ( quadrant.gb * 255 - 1 ) / dimensions;
      } else if ( quadrant.r == 2.0 / 255.0 ) {
        infoPix1 = texelFetch( Sampler0, quadrantUV + ivec2( 1, 0 ), 0 );
        infoPix2 = texelFetch( Sampler0, quadrantUV - ivec2( 0, 1 ), 0 );
        newUV0 = newUV0 + ( quadrant.gb * 255 + vec2( 1, -1 ) ) / dimensions;
      } else {
        vertexColor = Color * texelFetch( Sampler2, UV2 / 16, 0 );
        return;
      }

      // Get timing info
      float totalTime = infoPix1.r * 256 + infoPix1.g;
      float startTime = infoPix1.b * 256 + infoPix1.a;
      float endTime = infoPix2.r * 256 + infoPix2.g;

      float lower = startTime / totalTime;
      float upper = endTime / totalTime;
      float total = totalTime / 4705.882352941176;
      float whole = 0;
      float time = modf( GameTime / total, whole );

      vertexColor = vec4( time >= lower && time < upper );

      texCoord0 = newUV0;
    } else {
      vertexColor = Color * texelFetch( Sampler2, UV2 / 16, 0 );
    }
  } else if ( Color.xyz == vec3( floor( 254 / 4. ) / 255. ) ) {
    // Get rid of shadows
    vertexColor = vec4( 0 );
  } else {
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
  }
}