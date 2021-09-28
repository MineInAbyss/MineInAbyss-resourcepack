#version 150

in vec3 Position;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out float vertexDistance;
out vec4 rawPos;

void main() {
    //gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vec4 pos = ProjMat * vec4(Position, 1.0);
  	pos.y = -pos.z;
  	
  	gl_Position = pos;

    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    rawPos = vec4(Position, 1.0);
}
