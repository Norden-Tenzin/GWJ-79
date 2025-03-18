shader_type spatial;
render_mode cull_disabled, blend_mix;

uniform vec4 color_bottom : source_color = vec4(0.0, 0.0, 0.0, 0.8);
uniform vec4 color_top    : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float min_height = 0.0;
uniform float max_height = 2.0;
uniform float min_opacity = 0.0; // Minimum opacity to ensure visibility of back faces
varying vec3 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX.xy, 0.0, 1.0)).xyz;
}

void fragment() {
    float height = world_position.y - NODE_POSITION_WORLD.y;
    float factor = clamp((height - min_height) / (max_height - min_height), 0.0, 1.0);
    ALBEDO = mix(color_bottom.rgb, color_top.rgb, factor);

    // Calculate alpha but ensure it never goes below min_opacity
    float alpha = mix(color_bottom.a, color_top.a, factor);
    ALPHA = max(alpha, min_opacity);
}