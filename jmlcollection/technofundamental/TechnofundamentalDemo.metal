	//
	//  Demo.metal
	//  Nova18
	//
	//  Created by Chris Wood on 27/05/2018.
	//  Copyright © 2018 Interealtime. All rights reserved.
	//

#include <metal_stdlib>
using namespace metal;


#pragma mark - Function constants

constant int scene1 [[function_constant(0)]];
//constant int scene2 [[function_constant(1)]];
//constant bool scene2Active = is_function_constant_defined(scene2);
//constant bool videoFriendly [[function_constant(2)]];

constant float3 palette[] = {
	float3(1.,.18,.047),
	float3(.259,.58,.988),
	float3(.98,.914,.157),
	float3(.42,1.,.165),
	float3(.929,.149,.514),
	float3(.427,.988,.996),
	float3(1.,.502,.071),
	float3(.22,.047,.988)
};


constant float3 palette2[] = {
	float3(1,0,0),
	float3(0,1,0),
	float3(0,0,1)
};

constant float3 camPositions[] = {
	float3(9, 9, 9),
	float3(3, 0, 9),
	float3(30, -9, 0),
	float3(-5, 0, 0),
};

constant float3 camPositions2[] = {
	float3(9, 9, 9),
	float3(3, 4.5, 9),
	float3(30, -9, 0),
	float3(-6, 4.5, 0),
};

constant float3 camPositions3[] = {
	float3(-8, 10, 5),
	float3(8, 15, 5),
	float3(-8, 10, -5),
	float3(8, 15, -5),
};

	//constant bool crossfadeActive = scene1 != scene2;
	//constant bool3 octreeRepeat = bool3(false, false, false);
	//constant float3 octreeScale = float3(1, 1, 1);

	//constant float aperture = 0.05;
	//constant float exposure = 1. / 30.;

#define RAYCOUNT 64
#define MAXBOUNCES 4

#define E 1e-4 // epsilon

#define BRIGHTNESS 1.0

	//if ((p.x) > 79 && abs(p.y-40) < 10)

	//W(sin(t*.3)*25,30,sin(t*.3)*25,5)
#define LIGHTPOS Z(0, 1, 0)
#define LIGHTSIZE .1

#pragma mark Shader defines
	//=======================//

#define X float
#define Y float2
#define Z float3
#define W float4
#define R return
#define S struct
#define TH thread

#pragma mark Utilities
	//==================//

#define CLAMP(X,A,B) max(A, min(X, B))
#define MIX(A,B,X) A*(1.0-X)+B*X
#define SMOOTHSTEP(x) x*x*(3.0-2.0*x)
#define RO(p,a) p=cos(a)*p+sin(a)*Y(-p.y,p.x);
#define mod(a, b) (a - b * floor(a/b))


#pragma mark Enums

enum MatID {
	Matte, Light, UniformLight, Glass, Sky, Null, Bright
};

#pragma mark Structs

S Scene {
	Z lo, ls;
	bool4 useL; // Check order: RoI, mainLight, volume (0) or directional (1), secondScene
				//	TexturePack textures1, textures2;
};

S Ray {
	W o,d; // Origin + time, direction + minSDFL / isROI (+ve = minSDFL, -ve = isROI)
		   //	Z p; // time, percentage of frame, minSDFL
		   //	texture3d <X> sdf, sdfData;
	texture2d <X> tex1, tex2;
	Scene scene;
};

S TexturePack {
		//	texture3d <X> sdf1;
		//	texture3d <X> sdfData1;
	texture2d <X> tex1;
		//	texture3d <X> sdf2 [[function_constant(scene2Active)]];
		//	texture3d <X> sdfData2 [[function_constant(scene2Active)]];
	texture2d <X> tex2;
};

S Box {
	Z a,b;
};

S Mat {
	MatID id;
	Z c;
	/* New:
	 Matte: Roughness, fresnel
	 Glass: Roughness, dispersion
	 */
	Y properties;
};

S Hit {
	W r; // Result: xyz = normal, w = dist
	Mat m; // Material
		   //	Scene s; // Scene number
};

S SDFHit {
	float d;
	float m;
};


struct Box2 {
	float3 o, s;
	float r;
};

struct Ball {
	float3 o;
	float r;
};


#pragma mark - Materials

#define TEXTUREDBRASS {Matte, Z(1., 0.6, 0.4), Y(ra(mapPos).x*.3, 0)}
#define GRASS {Matte, Z(.44, 0.45, .05), Y(1,0)} //Y(ra(mapPos).x*.3,0)} //113 114 8
#define MATTEWHITE {Matte, Z(1), Y(1,0)}
#define MIRROR {Matte, Z(1), Y(0,0)}
#define GLASS {Glass, Z(.2, 0.6 , 0.8), Y(0,0)}
#define GLASSDISPERSIVE {Glass, Z(1), Y(0.0,.2)}
#define MUSHROOMLIGHT {Light, Z(0,3,0), Y(0,0)}

#pragma mark - Samplers

	//constexpr sampler sdfSampler(filter::nearest, mip_filter::nearest, address::repeat);
	//constexpr sampler dataSampler(filter::linear, mip_filter::nearest, address::repeat);
constexpr sampler skySampler(filter::linear, mip_filter::linear, address::repeat);
constexpr sampler texSampler(filter::linear, mip_filter::nearest, address::clamp_to_zero);


#pragma mark Prototypes
	//===================//

float2 rectCoords(float3 dir);
void sky(Ray r, Z i, TH Z &o,Mat m);
float3 skyCol(Ray r);
Hit iS(TH Ray &r);


#pragma mark - General functions
	//==========================//

#pragma mark Random
X ra(X p){
	R fract(sin(p) * 43758.5453123);
}

Z ra(Z p) {
	p=fract(p*Z(443.897,441.423,437.195));
	p+=dot(p,p.yxz+19.19);
	R fract((p.xxy+p.yxx)*p.zyx);
}

	//Z noise(Z p) {
	//	Z f = fract(p);
	//	p = floor(p);
	//	R mix(Z(ra(p.x), ra(p.y), ra(p.z)), Z(ra(p.x+1), ra(p.y+1), ra(p.z+1)), f);
	//}

#pragma mark Sampling
	//=================//

Z lS(Z n, Y r) { // C + O
	Z uvs = Z(6.283185*r.x, 2*r.y-1,0);
	
	uvs.z = sqrt(1-uvs.y*uvs.y);
	uvs =Z(cos(uvs.x) * uvs.z, sin(uvs.x) * uvs.z, uvs.y);
	R normalize(uvs + n);
}

	//Z lS2(Z n, Z ref, X spec, Z k) { // C + O
	//	X u=6.283185*k.x, v=2*k.y-1;
	//
	//	X s = sqrt(1-v*v);
	//	Z h=Z(cos(u) * s, sin(u) * s, v);
	//	h *= pow(k.z, spec);
	//	R normalize(h + ref);
	//}

#pragma mark Get Light

float3 lightDir(Ray r, Hit h, Z k) {
		//	Z a = (k*2-1)*h.s.ls;
	k = r.scene.useL.z ?
	(r.scene.lo + r.scene.ls * (k * 2. - 1.)) // light direction
	
	:
	r.scene.lo + normalize((k*2-1)*r.scene.ls)*(r.scene.ls)-r.o.xyz; // light volume
																	 //	h.s.lo+((k*2-1)*h.s.ls)-r.o.xyz;
	R normalize(k);
}

void gL(Ray r, Hit h, Z k, W i, TH Z&o, X d){
	r.d.xyz = lightDir(r, h, k);
	X c=dot(r.d.xyz,h.r.xyz);
	if(c<0.1)R;
	Hit s = iS(r);
	d = clamp(pow(d + s.r.w, -2), 0., 1000.);
	c *= d;
	if (s.m.id == Sky) {
		o += skyCol(r) * i.xyz * k.z;
	}
	if (s.m.id == Light) {
		o += s.m.c * i.xyz * c * k.z;
	}
}

float2 rectCoords(float3 dir) {
	return Y(atan2(dir.z, dir.x) * 0.5, acos(dir.y)) / M_PI_F;
}

#pragma mark - Materials
	//====================//

#pragma mark Texturing
bool mask(Ray r, TH Hit &h, X s) {
	r.o.xyz=r.o.xyz+r.d.xyz*h.r.w;
	R r.tex1.sample(texSampler, r.o.xz).r > 0.5;
}

#pragma mark check
void check(Ray r,TH Hit&h,X s) {
	r.o.xyz=r.o.xyz+r.d.xyz*h.r.w;
	r.o.xz=mod(floor(r.o.xz*s),2);
	h.m.c*=floor(fmod(r.o.x+r.o.z,2)*.95+.05);
}

#pragma mark polka
void polka(Ray r,TH Hit&h,X s){ // C+O
	r.o.xyz=r.o.xyz+r.d.xyz*h.r.w;
	h.m.c*=1.-step(.35,length(mod(r.o.xz*s,1)-.5));
}

#pragma mark sky
	//float3 skyColour( float3 ray ){
	//		//	return exp2(-ray.y/float3(.1,.3,.6)); // blue
	//		//	return exp2(-ray.y/float3(.18,.2,.28))*float3(1,.95,.8); // overcast
	//		//return exp2(-ray.y/float3(.1,.2,.8))*float3(1,.75,.5); // dusk
	//	R exp2(-ray.y/float3(.03,.2,.9)); // tropical blue
	//									  //    return exp2(-ray.y/float3(.4,.06,.01)); // orange-red
	//									  //    return exp2(-ray.y/float3(.1,.2,.01)); // green
	//}

float3 skyCol(Ray r) {
	return r.tex1.sample(skySampler, rectCoords(r.d.xyz)).rgb;
}

void sky(TH Ray &r,W i,TH Z&o,Mat m){ // C + O
	o += skyCol(r) * i.rgb;
}

#pragma mark light
void applyLight(W i,TH Z&o,Mat m,X d){ // C + O
	d = m.id == Light ? clamp(pow(d, -2), 0., 1000.) : 1.0;
	
	o += m.c*i.rgb*d;
}

#pragma mark glass
Z getSpectrum(X h) {
	Y p = Y(step(1./3., h), step(2./3., h));
	R Z(
		1-p.x,
		p.x-p.y,
		p.y
		) * 3.0;
}

void applyGlassColour(thread W &i, X dist, Z col) {
	col = (1.0 - col) * dist;
	i.rgb = max(0, i.rgb - col);
}

void applyGlass(thread Ray &ray, thread bool3 &rayInfo, Hit hit, Z randomValue, thread W &i) {
	
		// Fresnel term
	X f = 1.0 - max(0.0, -dot(ray.d.xyz, hit.r.xyz));
	f *= f*f;
	f = f * 0.95 + 0.05;
	
		// If non-fresnel, refract
	if (randomValue.z > f ) {
			// refraction
			// Index of refraction
		X ior = 1.5 + i.w * hit.m.properties.y;
		if (!rayInfo.y) {
			ior = 1./ior;
		}
		
			// Find refraction angle, accounting for surface roughness
		Z refractionDir = normalize(mix(refract(ray.d.xyz, hit.r.xyz, ior), lS(-hit.r.xyz, randomValue.xy), hit.m.properties.x));
		
			// Test for total internal reflection
		if (dot(-hit.r.xyz, refractionDir) > 0.0) {
				// We're OK to refract
				// Step through surface
			ray.o.xyz -= hit.r.xyz * E * 2.;
			
				// Go spectral if needed
			if (!rayInfo.x && hit.m.properties.y > 0.0) {
				i.rgb *= getSpectrum(i.w)*3;
				rayInfo.x = true;
			}
			
				// Colour ray if internal
			if (rayInfo.y) { applyGlassColour(i, hit.r.w, hit.m.c.rgb); }
			
			ray.d.xyz = refractionDir;
			rayInfo.y = !rayInfo.y;
			return;
		}
	}
	
		// reflection
	ray.d.xyz = mix(reflect(ray.d.xyz, hit.r.xyz), lS(hit.r.xyz, randomValue.xy), hit.m.properties.x);
	
		// Colour ray if internal
	if (rayInfo.y) { applyGlassColour(i, hit.r.w, hit.m.c.rgb); }
}

/*void applyGlass(TH Ray &r, TH bool3 &rayInfo, Hit h, Z k, TH W &i) {
		// Fresnel term
	
	X f = 1.0 - max(0.0, -dot(r.d.xyz, h.r.xyz));
	f *= f*f;
	
		//	f = -0.;
		//	f = f * 0.9 + 0.1;
	
		// Roughen surface normal
	h.r.xyz = normalize(mix(h.r.xyz, lS(h.r.xyz, rayInfo.y ? k.xy : k.yz), h.m.properties.x));
	
	if (rayInfo.y || k.x > f ) {
			// refraction
			// Go spectral if needed
		if (!rayInfo.x) {
			i.rgb *= getSpectrum(i.w);
			i.rgb *= h.m.c;
			rayInfo.x = true;
		}
		
			//		if (rayInfo.y) h.r.xyz *= -1;
		r.o.xyz += h.r.xyz * -.02;
			//X ior = 1.5 + ((1-k.y) * (h.m.scale) - (h.m.scale * .5));
			//X shift = k.y * h.m.scale * 2 - h.m.scale; // -1..1
		f = 1.5 + (i.w) * h.m.properties.y; // f is now ior
		if (!rayInfo.y) {
			f = 1./f;
		}
		r.d.xyz = (refract(normalize(r.d.xyz), normalize(h.r.xyz), f));
			//if (dot(r.d, h.r.xyz) > 0.0) { r.d = h.r.xyz; }
			//h.m.c = normalize(h.m.c + max(Z(0), Z(-shift, 1 - abs(shift), shift))) * length(h.m.c);
			//h.m.c = shift < 0 ? mix(h.m.c, Z(h.m.c.yz, 0), -shift) : mix(h.m.c, Z(0, h.m.c.xy), shift);
			//shift *= 0.5;
			//h.m.c = Z(h.m.c.yz,0) * shift*.5 + Z(h.m.c.z,0,0) * shift + Z(0, h.m.c.xy) * -shift*.5 + Z(0,0,h.m.c.x) * -shift;
			//h.m.c *= shift < 0 ? mix(Z(0,1,0), Z(0,0,1), max(0., -shift)) : mix(Z(0,1,0), Z(1,0,0), max(0., shift));
			//h.m.c *= 1.5;
			//i *= rayInfo ? 1.0 - pow(1-h.m.c, (h.r.w * 0.1)) : 1;
			//		i.rgb *= rayInfo ? max(0., h.m.c - (h.m.c * h.r.w * (1.-h.m.c)))*.1 : 1;
			//		i.rgb *= rayInfo.y ? max(0., h.m.c - (h.m.c * h.r.w)) : h.m.c;
		
		rayInfo.y = !rayInfo.y;
		return;
	}
		//	i *= 0.0;
		//	R;
		//
		//		// reflection
	r.d.xyz = reflect(r.d.xyz, h.r.xyz);
}*/



#pragma mark surface
void applySurface(TH Ray &r, Hit h, Z k, TH W &i, TH Z &o, X td) {
		// useL = {use ROI, mainLight}
		//Specular component (0..1), specular sharpness (0..1!), fresnel (-1..1?)
		// useROI, useMainLight, angular (0=volume)
	i.rgb *= h.m.c;
	if (r.scene.useL.y && k.z < h.m.properties.x){
		gL(r, h, k, i, o, td);
	}
	else if(r.scene.useL.x) {
			// Use ROI rays, based on random factor and material shininess
			//		if (k.z > (k.x + (1 - h.m.properties.x))) {
		if (k.y < h.m.properties.x) {
				// Cast a ROI ray
			Z y = lightDir(r, h, k);
			X d = dot(h.r.xyz, y);
				//			if (d > k.x) {
			if (d > 0) {
				i.rgb *= d * k.y;// * k.x;
				r.d.xyz = y;
				r.d.w = -1;
				R;
			}
		}
	}
	
		// Get matte, reflective vectors, fresnel factor
	
		// xyz = reflection direction, w = fresnel
	W ref = W(reflect(r.d.xyz, h.r.xyz), 1-max(0., -dot(r.d.xyz, h.r.xyz)));
	Z mte = lS(h.r.xyz, k.xy);
		//	X fresnel = 1-max(0., -dot(r.d.xyz, h.r.xyz));
	ref.w = step(k.y, (ref.w*ref.w * h.m.properties.y)*0.5 + h.m.properties.y * 0.5);
		//	h.m.properties.x = 0.0;
	
//#warning Testing:
	r.d.xyz = (mix(mix(ref.xyz, mte, h.m.properties.x), ref.xyz, ref.w));
		//	float spec = pow(h.m.properties.y, 4.) * 64.;
		//	r.d = fresnel || k.x > h.m.properties.x ? lS2(h.r.xyz, ref, spec, k) : mte;
		//	//r.d = mte;
	i.rgb *= max(ref.w, dot(r.d.xyz, h.r.xyz)*.5+.5);
	
}


#pragma mark - Ray intersection functions
	//===================================//

#pragma mark Cube // C + O
void iC(Ray r,Box c,TH Hit&t,Mat m){
	Z a=(c.a-r.o.xyz)/r.d.xyz, // near
	b=(c.b-r.o.xyz)/r.d.xyz, // far
	f=max(a,b), // furthest
	n=min(a,b); // nearest
	X x=min(f.x,min(f.y,f.z)), // furthest plane
	d=max(n.x,max(n.y,n.z)), // nearest plane
	o = d<0?x:d; // nearest in front
	if(isnan(n.x) || d>=x || o>t.r.w || o<0)R; // d>=x = invalid, o>t = behind other geometry, o<0 behind
	t.r.w=o;
	t.r.xyz=normalize(step(E,abs(a-t.r.w))-step(E,abs(b-t.r.w)))*sign(d);
	t.r.x = -t.r.x;
	t.m=m;
}

#pragma mark ball // C + O
void iB(Ray r,W s,TH Hit&t,Mat m){
	r.o.xyz -= s.xyz;
	r.o.w = dot(r.d.xyz,r.o.xyz)*2;
	X a = dot(r.o.xyz,r.o.xyz)-s.w*s.w;
	a = r.o.w*r.o.w-4*a;
	if(a < 0)R;
	a = sqrt(a);
	Y h=(Y(-a,a)-r.o.w)/2;
	a = h.x < 0 ? h.y : h.x;
	s.w*=sign(h.x);
	if(a> t.r.w || a < 0)R;
	t.r=W((r.d.xyz * a + r.o.xyz)/s.w, a);
	t.m=m;
}


#pragma mark ground // C + O
void iG(Ray r,TH Hit&t,Mat m){
	r.o.w = -r.o.y/r.d.y;
	if(r.o.w > 0 && r.o.w < t.r.w){
		t={{0,1,0,r.o.w},m};}
}

#pragma mark plane
void iP(Ray r, W p, TH Hit &t, Mat m) {
	r.o.w = dot(p.xyz * p.w - r.o.xyz, p.xyz) / dot(r.d.xyz, p.xyz);
	if(r.o.w > 0 && r.o.w < t.r.w){
		t = {W(p.xyz * -sign(dot(r.d.xyz, p.xyz)), r.o.w), m};
	}
}


#pragma mark - scene
	//================//

Hit sceneA(TH Ray &r) {
	Hit h = {W(0,0,0, 10000), { UniformLight, Z(1.5), Y(1,0)}};
		// Floor
	iG(r, h, { Matte, Z(1.0), Y(1,0.3)});
	if (h.m.id == Matte) { check(r, h, 1.5); }
	
	Mat mat = { Matte, Z(1), Y(1,0)};
	iB(r, W(0,1,0,1), h, mat);
	
	iB(r, W(1.3,0.5,0,0.5), h, mat);
	iB(r, W(-1.3,0.5,0,0.5), h,  mat);
	iB(r, W(0,0.5,1.3,0.5), h,  mat);
	iB(r, W(0,0.5,-1.3,0.5), h,  mat);
	
	iB(r, W(0.9,0.45,0.9,0.45), h,  mat);
	iB(r, W(-0.9,0.45,0.9,0.45), h,  mat);
	iB(r, W(0.9,0.45,-0.9,0.45), h,  mat);
	iB(r, W(-0.9,0.45,-0.9,0.45), h,  mat);
	
	R h;
}

Hit sceneB(TH Ray &r) {
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	
		// Floor
	iG(r, h, { Matte, Z(0), Y(0,0)});
	
	
	Hit h2 = h;
	iP(r, W(0,0,1,10), h2, { Bright, Z(1,0,0)*3., Y(0)});
	
		// texturise
	Y c = r.o.xy + r.d.xy * h2.r.w;
	float t = r.tex1.sample(texSampler, 1.-(c * Y(0.2/6.0, 0.2) + Y(0.5, 0))).a;
	
	if (h2.r.w < h.r.w && t>0.5) { h = h2; }
	
	R h;
}

Hit sceneC(TH Ray &r) {
		// Credits
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	int idx1 = int(fmod(floor(r.o.w/4.), 8.));
	int idx2 = (idx1 + 1) % 8;
		//	int idx2 = int(fmod(floor((r.o.w+2.)/4.)+1., 8.));
	iP(r, W(0,0,1,20), h, { Bright, palette[idx1], Y(0)});
	
	Hit h2 = h;
	iP(r, W(0,0,1,10), h2, { Bright, palette[idx2], Y(0)});
	
		// texturise
	Y c = r.o.xy + r.d.xy * h2.r.w;
	RO(c, r.o.w);
	c = 1.-(c * Y(.2/6., 0.2) + Y(0.5, 0.5));
	float t = r.tex1.sample(texSampler, c).a;
	
	if (h2.r.w < h.r.w && t>0.5) { h = h2; }
	
	R h;
}

Hit sceneD(TH Ray &r) {
		// tunnel
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	
	iC(r, {Z(-MAXFLOAT, -10, -10), Z(MAXFLOAT,10,10)}, h, { Matte, Z(1.0), Y(1,0)});
	
	Z p = r.o.xyz + r.d.xyz * h.r.w;
	p.yz += p.yz * p.yz*0.25;
	p.x += r.o.w*16. + p.y + p.z;
	h.m.c *= floor(mod(p.x*0.25, 2.0));
	
	iB(r, W(r.scene.lo, r.scene.ls.x), h, { Light, Z(200.0), Y(0)});
	
	R h;
}

Hit sceneE(TH Ray &r) {
		// tunnel + cube
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	
	iC(r, {Z(-MAXFLOAT, -10, -10), Z(MAXFLOAT,10,10)}, h, { Matte, Z(1.0), Y(1,0)});
	
	Z p = r.o.xyz + r.d.xyz * h.r.w;
	p.yz += p.yz * p.yz*0.25;
	p.x += r.o.w*16. + p.y + p.z;
	h.m.c *= floor(mod(p.x*0.25, 2.0));
	
	iB(r, W(r.scene.lo, r.scene.ls.x), h, { Light, Z(200.0), Y(0)});
	
		// Rotatosphere
	iB(r, W(3,0,0,5), h, { Matte, Z(1), Y(0,0)});
	
	R h;
}

Hit sceneF(TH Ray &r) {
		// tunnel + cube
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	
	int idx = int(floor(fmod(r.o.w*.5, 8.0)));
	int idx2 = (idx+2) % 8;
	
	iC(r, {Z(-MAXFLOAT, -10, -10), Z(MAXFLOAT,10,10)}, h, { Matte, palette[idx], Y(1,0)});
	
	X p = r.o.x + r.d.x * h.r.w + r.o.w*16.;
	h.m.c *= floor(mod(p*0.25, 2.0));
	
	iB(r, W(r.scene.lo, r.scene.ls.x), h, { Light, Z(200.0), Y(0)});
	
		// Rotatosphere
	iB(r, W(3,0,0,5), h, { Matte, palette[idx2], Y(0,0)});
	
	R h;
}

Hit sceneG(TH Ray &r) {
		// tunnel + glass sphere
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	
	iC(r, {Z(-MAXFLOAT, -10, -MAXFLOAT), Z(MAXFLOAT,10,MAXFLOAT)}, h, { Matte, Z(1), Y(1,0)});
	
	X p = r.o.x + r.d.x * h.r.w + r.o.w*16.;
	h.m.c *= floor(mod(p*0.25, 2.0));
	
	iB(r, W(r.scene.lo, r.scene.ls.x), h, { Light, Z(200.0), Y(0)});
	
		// Rotatosphere=
	iB(r, W(3,0,0,5), h, { Glass, Z(1,0,0), Y(0,0)});
	
	R h;
}

Hit sceneH(TH Ray &r) {
		// tunnel + glass sphere variations
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	
	int idx = int(floor(r.o.w*.5)) % 3;
		//	int idx2 = (idx+2) % 8;
	
	iC(r, {Z(-MAXFLOAT, -10, -MAXFLOAT), Z(MAXFLOAT,10,MAXFLOAT)}, h, { Matte, Z(1), Y(1,0)});
	
	X p = r.o.x + r.d.x * h.r.w + r.o.w*16.;
	h.m.c *= floor(mod(p*0.25, 2.0));
	
	iB(r, W(r.scene.lo, r.scene.ls.x), h, { Light, Z(200.0), Y(0)});
	
		// Rotatosphere
	iB(r, W(3,0,0,5), h, { Glass, palette2[idx], Y(0,0)});
	
	R h;
}

Hit sceneI(TH Ray &r) {
		// Glass box from gimbal
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	
	iG(r, h, { Matte, Z(1.0), Y(1,0.0)});
	iB(r, W(r.scene.lo, r.scene.ls.x), h, { Light, Z(1000.0), Y(0)});
	
	Ray r2 = r;
	X d = h.r.w;
	r2.o.y -= 5.;
	RO(r2.o.xy, r2.o.w);
	RO(r2.d.xy, r2.o.w);
	RO(r2.o.xz, r2.o.w);
	RO(r2.d.xz, r2.o.w);
		//	r.o.y += 3.;
	iC(r2, {Z(-1,-3,-3), Z(1,3,3)}, h, { Glass, Z(0,1,1), Y(0,0)});
	if (d != h.r.w) {
//		Z p = r2.o.xyz + r2.d.xyz * h.r.w;
			//		h.m.properties.x = length(p) < 2.0 ? 0 : 1;
		RO(h.r.xy, -r.o.w);
		RO(h.r.xz, -r.o.w);
	}
	
	R h;
}

Hit sceneJ(TH Ray &r) {
		// Glass box from gimbal
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	
	iG(r, h, { Matte, Z(1.0), Y(1,0.0)});
	if (h.m.id == Matte) {
		Z p = r.o.xyz+r.d.xyz*h.r.w;
		h.m.c *= 1.-step(.35,length(mod(p.xz*0.2,1)-.5));
	}
	iB(r, W(r.scene.lo, r.scene.ls.x), h, { Light, Z(1000.0), Y(0)});
	
	Ray r2 = r;
	r2.o.y -= 5.;
	RO(r2.o.xy, r2.o.w);
	RO(r2.d.xy, r2.o.w);
	RO(r2.o.xz, r2.o.w);
	RO(r2.d.xz, r2.o.w);
	
	iC(r2, {Z(-1.5,-4.5,-4.5), Z(1.5,4.5,4.5)}, h, { Glass, Z(1.), Y(1,1)});
	if (h.m.id == Glass) {
		Z p = r2.o.xyz + r2.d.xyz * h.r.w;
		h.m.properties.x = mod(floor(p.y * 1.0), 2.0)*0.1;
		RO(h.r.xy, -r.o.w);
		RO(h.r.xz, -r.o.w);
	}
	
	R h;
}

Hit sceneK(TH Ray &r) {
		// Glass box with polka
	Hit h = {W(0,0,0, 10000), { Null, Z(0), Y(0)}};
	
	iG(r, h, { Matte, Z(1.0), Y(1,0.0)});
	
	Z p = r.o.xyz+r.d.xyz*h.r.w;
	p.z += r.o.w * 4.0;
	h.m.c *= 1.-step(.35,length(mod(p.xz*0.2,1)-.5));
	
	iB(r, W(0,4,0,4), h, { Glass, Z(1.0), Y(0, 1.)});
	
	iB(r, W(r.scene.lo, r.scene.ls.x), h, { Light, Z(2000.0), Y(0)});
	
		//	Ray r2 = r;
		//	X d = h.r.w;
		//	r2.o.y -= 5.;
		//	RO(r2.o.xy, r2.o.w);
		//	RO(r2.d.xy, r2.o.w);
		//	RO(r2.o.xz, r2.o.w);
		//	RO(r2.d.xz, r2.o.w);
		//		//	r.o.y += 3.;
		////	int idx = int(floor(fmod(r.o.w*.5, 8.0)));
		//	iC(r2, {Z(-1,-3,-3), Z(1,3,3)}, h, { Glass, Z(1), Y(0,1)});
		//	if (d != h.r.w) {
		////		Z p = r2.o.xyz + r2.d.xyz * h.r.w;
		////		h.m.properties.x = floor(fmod(length(p) - r.o.w, 2.0))*.5;// < 2.0 ? 0 : 1;
		//		RO(h.r.xy, -r.o.w);
		//		RO(h.r.xz, -r.o.w);
		//	}
	
	R h;
}

Hit iS(TH Ray &r) {
		//	iP(r, W(normalize(Z(0,0,1)), 1000.0), h, { Matte, Z(0.5), Y(0.2,0)});
		//    iC(r, {{0, 0, 0}, {1,1,1}}, h, { Matte, Z(1), Y(1,0)});
	
	Hit h;
	
	if (scene1 == 1 || scene1 == 2) {
			// logo
		h = sceneB(r);
	} else if (scene1 == 3) {
			// credits
		h = sceneC(r);
	} else if (scene1 == 4) {
			// tunnel appears
		h = sceneD(r);
	} else if (scene1 == 5) {
			// tunnel appears
		h = sceneE(r);
	} else if (scene1 == 6) {
			// tunnel appears
		h = sceneF(r);
	} else if (scene1 == 7) {
			// glass appears
		h = sceneG(r);
	} else if (scene1 == 8) {
			// glass appears
		h = sceneH(r);
	} else if (scene1 == 9) {
			// glass box
		h = sceneI(r);
	} else if (scene1 == 10 || scene1 == 11) {
			// glass box / matte
		h = sceneJ(r);
	} else {
			// clear box, polka lights
		h = sceneK(r);
	}
	
	R h;
}

#pragma mark - Camera

void setCam(TH Ray &r, X time, X percentage, Z k) {
	if (scene1 == 0) {
			// config screen
		
			// Motion blur
		r.o.w = time + (1./30.) * percentage;
		
		X camDist = (sin(r.o.w*0.5)+3);
		r.o.xyz = Z(sin(r.o.w*.5)* camDist,cos(r.o.w*0.25)+1.,cos(r.o.w*0.5)* camDist) + Z(0.,0.06, 0.);
		r.d.xyz = Z(sin(r.o.w*0.75), sin(r.o.w * 0.375), sin(r.o.w*1.25));
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * 0.005; // Standard DoF
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = 0;
		
	} else if (scene1 == 1) {
			// logo screen
		
			// Motion blur
		r.o.w = time + (1./30.) * k.x;
		
		r.o.xyz = mix(Z(18, 1.25, 7.0), Z(-18, 1.25, 7), (r.o.w / 16.));
		r.d.xyz = mix(Z(12, 1.25, 10), Z(-12, 1.25, 10), SMOOTHSTEP(r.o.w / 16.0));
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * (0.1 + max(0., 0.1 - fmod(r.o.w, 1.)*0.25));
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = 0;
		
	} else if (scene1 == 2) {
			// logo spin
			// Motion blur
		r.o.w = time + min(1.0, ((time*time)/90.)) * k.x;
		
		r.o.xyz = Z(-cos(r.o.w)*((-cos(r.o.w*M_PI_F/16.)*.5+.5)*10.+18.-r.o.w*0.5), (-cos(r.o.w*M_PI_F/16.)*.5+.5)*10. + 0.5, -sin(r.o.w)*((-cos(r.o.w*M_PI_F/16.)*.5+.5)*10.+18.-r.o.w*0.5)+10.);
		r.d.xyz = Z(0,1.25,10);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * 0.5;
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = 0;
		
	} else if (scene1 == 3) {
			// credits
		
			// Motion blur
		r.o.w = clamp(time + (1./10.) * k.y, floor(time/4.)*4., ceil(time/4.)*4.);
		
		r.o.xyz = Z(0, 0, min(9.9, fmod(r.o.w, 4.) *11.-30.));
			//Z(0, 0, fmod(r.o.w, 4.) *11.-30.);
		r.d.xyz = Z(0, 0, fmod(r.o.w, 4.) *11.-28.);
		
			// Depth of field
			//			r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * 0.05;
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * max(0.05, 1.-fmod(r.o.w, 4.0));
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = 0;
		
	} else if (scene1 == 4) {
			// tunnel appears
		
			// Motion blur
		r.o.w = time + (1./30.) * k.y;
		
		r.o.xyz = Z(-5, 0, 0);
		r.d.xyz = Z(0);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * max(0.05, 1.-r.o.w * 0.25);
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = {0,1,0,0};
		r.scene.lo = Z(sin(r.o.w*M_PI_F*.25)*8., 0, cos(r.o.w*M_PI_F*.25)*8.);
		RO(r.scene.lo.xy, r.o.w);
		r.scene.lo.x += 3.;
		r.scene.ls = Z(1.0);
		
	} else if (scene1 == 5) {
			// mirrorsphere appears
		
			// Motion blur
		r.o.w = time + (1./30.) * k.y;
		
		r.o.xyz = Z(-5, 0, 0);
		r.d.xyz = Z(3, 0, 0);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * max(0.05, 1.-(r.o.w * 0.25));
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = {0,1,0,0};
		r.scene.lo = Z(sin(r.o.w*M_PI_F*.25)*8., 0, cos(r.o.w*M_PI_F*.25)*8.);
		RO(r.scene.lo.xy, r.o.w);
		r.scene.lo.x += 3.;
		r.scene.ls = Z(1.0);
		
	} else if (scene1 == 6) {
			// mirrorsphere variations
		
			// Motion blur
		r.o.w = time + (1./30.) * k.y;
		
		int idx = int(floor(fmod(r.o.w*.25, 4.0)));
		r.o.xyz = camPositions[idx];
		r.d.xyz = Z(3, 0, 0);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * 0.2;
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = {0,1,0,0};
		r.scene.lo = Z(sin(r.o.w*M_PI_F*.25)*8., 0, cos(r.o.w*M_PI_F*.25)*8.);
		RO(r.scene.lo.xy, r.o.w);
		r.scene.lo.x += 3.;
		r.scene.ls = Z(1.0);
		
	} else if (scene1 == 7) {
			// glass sphere appears
		
			// Motion blur
		r.o.w = time + (1./30.) * k.y;
		
		X t = smoothstep(0., 1., saturate((r.o.w - 8.) / 8.0)) * M_PI_F * 0.5;
		r.o.xyz =  Z(-cos(t)*8. +.3, t*5.0, sin(t)*8.);
		
		r.d.xyz = Z(3, 0, 0);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * max(0.05, 1.-r.o.w*0.25);
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = {1,0,0,0};
		r.scene.lo = Z(15.,0,0);
		r.scene.ls = Z(1.0);
		
	} else if (scene1 == 8) {
			// glass sphere variations
		
			// Motion blur
		r.o.w = time + (1./30.) * k.y;
		
			//			X t = smoothstep(0., 1., saturate((r.o.w - 8.) / 8.0)) * M_PI_F * 0.5;
		
		int idx = int(floor(fmod(r.o.w*.25, 4.0)));
		r.o.xyz = camPositions2[idx];
		
		r.d.xyz = Z(3, 0, 0);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * 0.05;
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = {1,0,0,0};
		r.scene.lo = Z(sin(r.o.w*M_PI_F*.25)*8., 0, cos(r.o.w*M_PI_F*.25)*8.);
		RO(r.scene.lo.xy, r.o.w);
		r.scene.lo.x += 3.;
		r.scene.ls = Z(1.0);
	} else if (scene1 == 9) {
			// glass box
		
			// Motion blur
		r.o.w = time + (1./30.) * k.y;
		
		X t = smoothstep(0., 1., saturate((r.o.w - 8.) / 8.0));
		
		r.o.xyz = mix(Z(-5, 10, 0), Z(-8, 10, 5), t);
		
		r.d.xyz = Z(-5, 7, 0);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * max(0.05, 1.-r.o.w*0.25);
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = {1,0,0,0};
		r.scene.lo = Z(15.0);
		r.scene.ls = Z(3.0);
	} else if (scene1 == 10) {
			// glass box + matte + colour change
		
			// Motion blur
		r.o.w = time + (1./30.) * k.y;
		
		r.o.xyz = Z(-8, 10, 5);
		
		r.d.xyz = Z(-5, 7, 0);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * 0.05;
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = {1,0,0,0};
		r.scene.lo = Z(15.0);
		r.scene.ls = Z(3.0);
		
	} else if (scene1 == 11) {
			// glass box + matte + camera change
		
			// Motion blur
		r.o.w = time + (1./30.) * k.y;
		
		int idx = int(floor(fmod(r.o.w*.25, 4.0)));
		int idx2 = (idx + 1) % 4;
		r.o.xyz = mix(camPositions3[idx], camPositions3[idx2], fmod(r.o.w, 4.0)/4.0);
		
		r.d.xyz = Z(-5, 7, 0);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * 0.05;
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = {1,0,0,0};
		r.scene.lo = Z(15.0);
		r.scene.ls = Z(3.0);
		
	} else {
			// glass box + matte + camera change
		
			// Motion blur
		r.o.w = time + (1./10.) * k.y;
		
			//			Change y to sin fun start low go very high, 20+
//		r.o.xyz = Z(sin(r.o.w*.5)*5., r.o.w + 2.0, cos(r.o.w*.5)*5.);
		r.o.xyz = Z(sin(r.o.w*.5)*5., -cos(r.o.w*M_PI_F * 0.125) * 8. + 10.0, cos(r.o.w*.5)*5.);
		
		r.d.xyz = Z(0, 5, 0);
		
			// Depth of field
		r.o.xyz += lS(normalize(r.d.xyz - r.o.xyz), k.xy) * max(0.2, max(1.-r.o.w, r.o.w - 28.0));
		r.d.xyz = normalize(r.d.xyz - r.o.xyz);
		
			// Lighting
		r.scene.useL = {1,0,0,0};
		r.scene.lo = Z(15.0);
		r.scene.ls = Z(3.0);
	}
	
		//	if (scene1 == 0) {
		//		r.scene.lo = Z(0.0, 0.5, 0.0);
		//		r.scene.ls = Z(1.0);
		//			// RoI, mainlight, directional
		//		r.scene.useL = {0,0,0,0};
		//	} else {
		////	} else if (scene1 == 1) {
		//		scene.ls = 0.35;
		//		scene.useL = {1, 1, 1}; // RoI, mainlight, directional
		//		scene.useL = {0,1,0};
		//	}
}

#pragma mark Tracing
	//================//

Z trace(Y uv, X ps, X time, TexturePack tex) {
		// Fisheye the lens and zoom
	
	if (scene1 == 4 || scene1 == 5) {
		uv = mix(uv, uv * pow(length(uv), 3.), 0.1) * (sin(time * .25 * M_PI_F)*2.+3.5);
	} else {
		uv = mix(uv, uv * pow(length(uv), 3.), 0.1);
	}
	
	Z o = 0, k;
	
	k = ra(Z(uv+time, time));
	
		// Scene setup
	Ray r;
		//	if (scene2Active) {
	r.tex1 = tex.tex1;
	r.tex2 = tex.tex2;
		//	} else {
		//		r.tex = tex.tex1;
		//	}
	
	X percentage = 0;
	
		// Go through rays
	for (int j=0; j<RAYCOUNT; j++) {
			// x = spectral, y = inside, shouldBreak
		bool3 rayInfo = false;
		
			// Set time
		r.d.w = 0;
		
		
			// setup cam
		setCam(r, time, percentage, k);
		
			// Orient the ray according to UVs
		Z u=normalize(cross(r.d.xyz,Z(0,1,0)));
#if AA
		Y a = uv + k.xy * ps;
#else
		Y a = uv;
#endif
		r.d.xyz = normalize ( a.x*u + a.y*normalize ( cross (u,r.d.xyz) ) + r.d.xyz);
		
			// Initial light value is 1, hue is percentage or ray count
		W i = W(
				1,1,1,
				percentage
				);
		
		X td = 0;
		
			// iterate through bounces
		for (int bounce = 0; bounce < MAXBOUNCES; bounce++) {
				// intersect and move ray
			Hit h = iS(r);
			if (bounce > 0)  { td += h.r.w; }
				// if (bounce == uniforms.raySpec.y - 1) { R Z(td); }
				// Kill speckles…
				//			if(any(isnan(h.r)) ) { continue; }// R {1000,0,0}; }
			
			r.o.xyz += r.d.xyz * h.r.w + h.r.xyz * E;
			
			rayInfo.z = 0;
			
			if (h.m.id == Bright) { h.m.id = bounce == 0 ? UniformLight : Light; }
			
			switch (h.m.id) {
					
				case Sky:
					o += skyCol(r) * i.rgb;
					rayInfo.z = 1;
					break;
					
				case Light:
					applyLight(i, o, h.m, td);
					rayInfo.z = 1;
					break;
					
				case UniformLight:
					applyLight(i, o, h.m, td);
					rayInfo.z = 1;
					break;
					
				case Glass:
					applyGlass(r, rayInfo, h, k, i);
					break;
					
				case Matte:
					if (r.d.w < 0) {
						rayInfo.z = 1;
						break;
					}
					applySurface(r, h, k, i, o, td);
					break;
					
				case Null:
					rayInfo.z = 1;
					break;
					
				case Bright:
					break;
			}
			
			if(rayInfo.z | all(i.xyz < 0.05)) {
					//				o.g += 1;
				break;
			}
			
		}
			// New k value
		k = ra(k);
		percentage+=1.0 / float(RAYCOUNT - 1);
	}
	R o;
}


#pragma mark YUV
float3 rgbToYUV709 (float3 rgb) {
	return float3x3( float3(1.0, 1.0, 1.0), float3(0.0, -0.21482, 2.12798), float3(1.28033, -0.21482, 0.0) ) * rgb;
}

float3 yuv709ToRGB (float3 yuv) {
	return float3x3( float3(0.132246, -0.0621462, 0.677758), float3(0.788187, -0.370392, -0.615612), float3(0.0795676, 0.432538, -0.0621462) ) * yuv;
}

#pragma mark Compute function
	//=========================//
kernel void demo (
				  texture2d<float,access::write> o [[texture(0)]],
				  //				  texture3d<X,access::sample> sdf1 [[texture(1)]],
				  //				  texture3d<X,access::sample> sdfData1 [[texture(2)]],
				  texture2d<float,access::sample> tex1 [[texture(1)]],
				  //				  texture3d<X,access::sample> sdf2 [[texture(4), function_constant(scene2)]],
				  //				  texture3d<X,access::sample> sdfData2 [[texture(5), function_constant(scene2)]],
				  texture2d<float,access::sample> tex2 [[texture(2)]],
				  constant X&t[[buffer(0)]],
				  uint2 g [[thread_position_in_grid]]
				  ) {
	Y r=Y(o.get_width(),o.get_height());
		//	X rays = 30; // 13 max
	Y uv = (Y(g*2)-r)/Y(r.y,-r.y);
	
	X ps = 4.0/r.x;
		//if (uv.x + uv.y == 0.0) {uv += 0.01;}
	float3 result;
	
		//	if (scene2Active) {
		//		TexturePack tex = {tex1, tex2};
		//		result = trace(uv, ps, uniforms, tex);
		//	} else {
	TexturePack tex = {tex1, tex2};
	result = trace(uv, ps, t, tex);
		//	}
	
	result /= RAYCOUNT;
	result *= BRIGHTNESS;
	if (scene1 > 11) {
		result *= saturate(4.0 - t * 0.125);
	}
		//	result += max(0.0, 1. - fmod(uniforms.time.x/4., 1.0) * 4.0);
	
	o.write(W(pow(result, 1./2.2), 1),g);
	
		//	if (scene1 == 0) { o.write(W(1,0,0,1), g); }
		//	if (scene1 == 1) { o.write(W(0,1,0,1), g); }
}

