#version 330

noperspective in vec2 fragTexCoord;

in vec4 fragColor;
in float fragFogDist;

out vec4 finalColor;

uniform sampler2D texture0;
uniform vec4 colDiffuse;

// 4x4 Bayer Dither Matrix
const float ditherMatrix[16] = float[](
        0.0 / 16.0, 8.0 / 16.0, 2.0 / 16.0, 10.0 / 16.0,
        12.0 / 16.0, 4.0 / 16.0, 14.0 / 16.0, 6.0 / 16.0,
        3.0 / 16.0, 11.0 / 16.0, 1.0 / 16.0, 9.0 / 16.0,
        15.0 / 16.0, 7.0 / 16.0, 13.0 / 16.0, 5.0 / 16.0
    );

void main()
{
    // Sample texture (affine due to 'noperspective' in vertex shader)
    vec4 texelColor = texture(texture0, fragTexCoord);

    // Basic tint
    vec4 baseColor = texelColor * colDiffuse * fragColor;

    // Simple Linear Fog (black)
    float fogDensity = 0.05; // We can Adjust this
    float fogFactor = 1.0 - exp(-fragFogDist * fogDensity);
    fogFactor = clamp(fogFactor, 0.0, 1.0);
    vec3 resultColor = mix(baseColor.rgb, vec3(0.0, 0.0, 0.0), fogFactor);

    // Dithering
    // Calculate dither threshold based on pixel position
    int x = int(gl_FragCoord.x) % 4;
    int y = int(gl_FragCoord.y) % 4;
    float ditherValue = ditherMatrix[y * 4 + x];

    // Color Quantization (Reduce to ~15 bit color)
    // 5 bits = 32 levels. We add ditherValue to noise the threshold.
    float colorDepth = 31.0;
    resultColor.r = floor(resultColor.r * colorDepth + ditherValue) / colorDepth;
    resultColor.g = floor(resultColor.g * colorDepth + ditherValue) / colorDepth;
    resultColor.b = floor(resultColor.b * colorDepth + ditherValue) / colorDepth;

    finalColor = vec4(resultColor, baseColor.a);
}
