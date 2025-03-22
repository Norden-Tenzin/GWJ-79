shader_type spatial;
uniform vec3 tint : source_color = vec3(1.0, 1.0, 1.0);

uniform float noise_intensity = 1.0;
uniform float noise_speed = 1.0;
uniform float bubblyness = 0.5;
uniform sampler2D noise : hint_default_black;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX += ((NORMAL * abs(cos((TIME) * bubblyness)) + (NORMAL * texture(noise, (TIME * noise_speed) + NORMAL.yz).x * noise_intensity))) * 0.05;
}

void fragment() {
	ALBEDO = tint * clamp(dot(VIEW, NORMAL) * 1.5, 0.9, 1.0);
	// Called for every pixel the material is visible on.
}

void light() {
	float from_light = pow(clamp(dot(NORMAL, LIGHT) - 0.7, 0.0, 1.0), .1) * ATTENUATION;
	DIFFUSE_LIGHT += from_light * LIGHT_COLOR;//vec3(1.0 - pow(clamp(dot(NORMAL, VIEW) - 0.75, 0.0, 1.0), .1)) * ATTENUATION * from_light;
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
}
