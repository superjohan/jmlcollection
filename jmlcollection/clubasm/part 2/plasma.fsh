#define PI 3.1415926535897932384626433832795

uniform vec2 resolution;

vec2 iResolution = resolution;
float iTime = u_time * 0.05;
vec2 fragCoord = gl_FragCoord.xy;

vec2 uv = fragCoord/iResolution.xy;

float speed = iTime;

float p1 = sin(uv.x * 11.9 + speed * 2.3) + sin(uv.x * 17.1 - speed * 1.8);
float p2 = sin(uv.y * 6.9 + speed * 3.1) + sin(uv.y * 15.1 - speed * 2.2);

//float shade = floor((p1 + p2 + 4.0)/4.0);
float shade = clamp(p1 + p2, 0.0, 1.0);
float adjusted = 0.8 + (shade * 0.2);

// Output to screen
_output.color = vec4(adjusted, adjusted, adjusted, 1.0);
