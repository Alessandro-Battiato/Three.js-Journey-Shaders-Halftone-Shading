uniform vec3 uColor;
uniform vec2 uResolution;

varying vec3 vNormal;
varying vec3 vPosition;

#include ../includes/ambientLight.glsl
#include ../includes/directionalLight.glsl

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = uColor;

    // Lights
    vec3 light = vec3(0.0);

    light += ambientLight(
        vec3(1.0), // Light color
        1.0 // Light intensity
    );

    light += directionalLight(
        vec3(1.0, 1.0, 1.0),
        1.0,
        normal,
        vec3(1.0, 1.0, 0.0),
        viewDirection,
        1.0
    );

    color *= light;

    // Halftone
    float repetitions = 50.0;
    vec3 direction = vec3(0.0, -1.0, 0.0);
    float low = - 0.8;
    float high = 1.5;

    float intensity = dot(normal, direction); // dot product
    intensity = smoothstep(low, high, intensity);

    vec2 uv = gl_FragCoord.xy / uResolution.y; // now both x and y of fragCoords are divided by uResolution's y and thus fixes the squares issue
    uv *= repetitions; // how many cells (or squares) we have vertically on each mesh
    uv = mod(uv, 1.0);

    float point = distance(uv, vec2(0.5)); // render a Dot at the center of each cell
    point = 1.0 - step(0.5 * intensity, point);

    // Final color
    gl_FragColor = vec4(point, point, point, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}