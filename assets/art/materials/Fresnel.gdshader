shader_type spatial;
render_mode unshaded;

uniform vec3 tint : source_color = vec3(1.0, 1.0, 1.0);
uniform float intensity = 1.0;
uniform float fresnel_intensity : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float sharpness : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float ring_size : hint_range(0.0, 1.0, 0.01) = 0.0;

void fragment() {
	ALBEDO = tint * intensity;
	ALPHA = fresnel_intensity * pow(clamp(1.0 - clamp(dot(VIEW, NORMAL), 0.0, 1.0) - ring_size, 0.0, 1.0), 1.0 - (sharpness * 0.9));
}
