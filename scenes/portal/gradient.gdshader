shader_type spatial;
render_mode cull_disabled, blend_mix;

uniform vec4 color_bottom : source_color = vec4(0.0, 0.0, 0.0, 0.8);
uniform vec4 color_top    : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float min_height = 0.0;
uniform float max_height = 2.0;
uniform float min_opacity = 0.0; // Minimum opacity to ensure visibility of back faces

// Varying to pass the local vertex position to the fragment shader
varying vec3 local_pos;

void vertex() {
    // Use the local space vertex coordinates so the gradient follows the mesh's own orientation.
    local_pos = VERTEX;
}

void fragment() {
    // Compute the gradient using the local Y coordinate.
    float height = local_pos.y;
    float factor = clamp((height - min_height) / (max_height - min_height), 0.0, 1.0);

    // Interpolate between the two colors based on the local height.
    ALBEDO = mix(color_bottom.rgb, color_top.rgb, factor);

    // Compute the alpha and ensure it doesn't drop below the minimum opacity.
    float alpha = mix(color_bottom.a, color_top.a, factor);
    ALPHA = max(alpha, min_opacity);
}
