shader_type canvas_item;

// liest vom Bildschirm (live)
uniform sampler2D screen_tex : hint_screen_texture;

// Stärke des Blurs in Pixeln (nicht UV)
uniform float radius : hint_range(0.0, 32.0) = 32.0;

// wie viele Samples in jede Richtung (kleiner = schneller)
uniform int samples : hint_range(1, 6) = 6;

// wie stark das "milchige" mischen ist (0 = original, 1 = komplett unscharf)
uniform float milk_alpha : hint_range(0.0, 1.0) = 1;

void fragment() {
    vec2 uv = SCREEN_UV;
    // Größe eines Bildschirmpixels in UV-Koordinaten
    vec2 px = SCREEN_PIXEL_SIZE;

    vec4 blurcol = vec4(0.0);
    int cnt = 0;

    // einfacher box/gauss-artiger Blur (kostet O(samples^2))
    for (int x = -samples; x <= samples; x++) {
        for (int y = -samples; y <= samples; y++) {
            vec2 offset = vec2(float(x), float(y)) * (radius * px);
            blurcol += texture(screen_tex, uv + offset);
            cnt++;
        }
    }
    blurcol /= float(cnt);

    // Originalfarbe des Hintergrunds
    vec4 orig = texture(screen_tex, uv);

    // Mische zwischen Original und Unschärfe -> milchiger Effekt
    COLOR = mix(orig, blurcol, milk_alpha);

    // Optional: kannst du hier noch eine halbtransparente Tönung draufpacken,
    // z.B. COLOR.rgb = mix(COLOR.rgb, vec3(1.0), 0.04);
}
