shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_always;

uniform float speed : hint_range(0.0, 10.0) = 1.0;
uniform float frequency : hint_range(0.0, 20.0) = 10.0;
uniform vec4 wind_color : source_color = vec4(0.8, 0.9, 1.0, 0.8);
uniform float alpha_scale : hint_range(0.0, 1.0) = 0.5;

// New uniforms to control the drop-off at the top of the mesh.
// These values represent UV.y coordinates where the fade starts and where it reaches full transparency.
uniform float dropoff_start : hint_range(0.0, 1.0) = 0.8;
uniform float dropoff_end   : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // Animate over time
    float t = TIME * speed;

    // Create a sine wave pattern along the UV.y axis to simulate moving wind
    float pattern = sin(UV.y * frequency + t);
    pattern = pattern * 0.5 + 0.5;

    // Fade out the effect toward the sides using UV.x
    float edge_fade = smoothstep(0.0, 0.2, UV.x) * (1.0 - smoothstep(0.8, 1.0, UV.x));

    // Compute the top drop-off factor:
    // Below dropoff_start, top_fade is 1 (no fade), and above dropoff_end it reaches 0 (fully transparent).
    float top_fade = 1.0 - smoothstep(dropoff_end, dropoff_start, UV.y);

    // Apply the wind color and combine all factors to calculate final alpha.
    ALBEDO = wind_color.rgb;
    ALPHA = pattern * edge_fade * alpha_scale * top_fade;
}
