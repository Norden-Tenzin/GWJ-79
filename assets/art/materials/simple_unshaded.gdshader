shader_type spatial;
render_mode unshaded;

uniform vec3 tint : source_color = vec3(1.0, 1.0, 1.0);
uniform float intensity = 1.0;

void fragment() {
	ALBEDO = tint * intensity;
}
