#pragma transparent
#define PI 3.1415926535897932384626433832795

uniform vec2 resolution;
uniform float offset;
uniform float sphereSize;

vec2 iResolution = resolution;
float iTime = u_time + offset;
vec2 fragCoord = gl_FragCoord.xy;

vec2 coord = fragCoord/iResolution.xy;
vec2 uv = vec2(coord.x*2.0f-1.0f,coord.y*2.0f-1.0f);
float time = iTime;

// initial background color
vec4 color = vec4(0.0f,0.0f,0.0f,0.0f);
// palette
vec3 color1 = vec3(1.0f, 0.984f, 0.835f);
vec3 color2 = vec3(0.698f, 0.039f, 0.173f);

float metaStickyness = 0.4f;

int calculateNormal = 0;
float lightnessBias = 0.4;

vec3 spheres[5];
spheres[0].x = cos(time)*0.5f+0.2f;
spheres[0].y = sin(time)*0.8f+0.3f;
spheres[0].z = sin(time)*0.5f;
spheres[1].x = sin(time)*0.5f-0.5f;
spheres[1].y = cos(time)*0.5f-0.25f;
spheres[1].z = sin(time)+0.5f;
spheres[2].x = cos(time)*0.5f-0.5f;
spheres[2].y = sin(time)*0.7f-0.25f;
spheres[2].z = cos(time)*0.6f+0.3f;
spheres[3].x = cos(time)*0.8f;
spheres[3].y = sin(time)*0.4f;
spheres[3].z = cos(time)*0.8f;
spheres[4].x = sin(time)*0.9f;
spheres[4].y = sin(time)*0.9f;
spheres[4].z = sin(time)*0.2f;

vec3 cameraEye = vec3(0.0f,0.0f,-2.5f);
vec3 cameraUp = vec3(0.0f,1.0f,0.0f);
vec3 cameraRight = vec3(1.0f,0.0f,0.0f);

vec3 cameraTarget = normalize(cross(cameraRight, cameraUp) + cameraRight*uv.x + cameraUp*uv.y);

float rayHitThreshold = 0.08f;
float zFar = 5.0f;
float rayDistance = 0.0f;
int rayMaxSteps = 100;
for(int i = 0; i < rayMaxSteps; i++)
{
    vec3 rayPosition = cameraEye+cameraTarget*rayDistance;
    
    float distanceToSolid = 0.0f;
    
    for(int i = 0; i < 5; i++)
    {
        float sa = length(rayPosition+spheres[i])-sphereSize;
        if (i == 0)
        {
            distanceToSolid = sa;
        }
        else
        {
            //metaball glue
            float h = clamp(0.5f+0.5f*(sa-distanceToSolid)/metaStickyness,0.0f,1.0f);
            distanceToSolid = mix(sa,distanceToSolid,h)-metaStickyness*h*(1.0f-h);
        }
    }
    
    if (rayDistance > zFar)
    {
        break;
    }
    else if (distanceToSolid < rayHitThreshold)
    {
        float lightness = 1.0f;
        if (calculateNormal == 1)
        {
            float normalAccuracy = 0.001f;
            mat3 nmat;
            nmat[0] = vec3(normalAccuracy,0.0f,0.0f);
            nmat[1] = vec3(0.0f,normalAccuracy,0.0f);
            nmat[2] = vec3(0.0f,0.0f,normalAccuracy);
            
            vec3 npos[6];
            npos[0] = rayPosition+nmat[0];
            npos[1] = rayPosition-nmat[0];
            npos[2] = rayPosition+nmat[1];
            npos[3] = rayPosition-nmat[1];
            npos[4] = rayPosition+nmat[2];
            npos[5] = rayPosition-nmat[2];
            
            float nposres[6];
            for (int i = 0; i < 6; i++)
            {
                rayPosition = npos[i];
                distanceToSolid = 0.0f;
                for(int i = 0; i < 5; i++)
                {
                    float sa = length(rayPosition+spheres[i])-sphereSize;
                    if (i == 0)
                    {
                        distanceToSolid = sa;
                    }
                    else
                    {
                        //metaball glue
                        float h = clamp(0.5f+0.5f*(sa-distanceToSolid)/metaStickyness,0.0f,1.0f);
                        distanceToSolid = mix(sa,distanceToSolid,h)-metaStickyness*h*(1.0f-h);
                    }
                }
                
                nposres[i] = distanceToSolid;
            }
            
            vec3 normal = normalize(vec3(nposres[0]-nposres[1],nposres[2]-nposres[3],nposres[4]-nposres[5]));
            lightness = abs((normal.r+normal.g+normal.b)/3.0f);
        }
        
        
        
        vec3 n = rayPosition;
        
        float percent = abs((n.r+n.g+n.b)/3.0f);
        color = vec4(mix(color1, color2, percent) * (1.0-lightnessBias + lightnessBias*lightness), 1.0f);
        
        break;
    }
    
    rayDistance += distanceToSolid;
}

_output.color = color;

//_output.color = vec4(0, 1, 0, 1.0);
