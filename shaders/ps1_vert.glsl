#version 330

// Input attributes from raylib
in vec3 vertexPosition;
in vec2 vertexTexCoord;
in vec3 vertexNormal;
in vec4 vertexColor;

// Uniform provided by Raylib
uniform mat4 mvp;

// Output to Fragment Shader
noperspective out vec2 fragTexCoord;
out vec4 fragColor;
out float fragFogDist;

// custom uniform
uniform vec2 resolution = vec2(320.0, 240.0);

void main() {
    // Clip Space Position
    vec4 pos = mvp * vec4(vertexPosition, 1.0);

    vec2 grid = resolution * 0.5;

    // Vertex Snapping
    // Convert to normalized device coordinate, snap to pixels, then convert it back again
    vec4 snappedPos = pos;
    snappedPos.xyz = pos.xyz / pos.w; // Convert to NDC
    snappedPos.xy = floor(grid * snappedPos.xy) / grid; // Snap
    snappedPos.xyz *= pos.w; // convert back

    gl_Position = snappedPos;

    // Pass data to Fragment shader
    fragTexCoord = vertexTexCoord;
    fragColor = vertexColor;

    // Calculate simple distance for fog things
    fragFogDist = pos.z;
}
