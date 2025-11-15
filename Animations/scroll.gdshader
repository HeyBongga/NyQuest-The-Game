shader_type canvas_item;

uniform float speed = 0.05;
uniform float amplitude = 0.5; // Stärke der Wellenbewegung

void vertex() {
    // X weiterscrollen
    UV.x += TIME * speed;

    // Sinus sorgt für hoch/runter Bewegung
    UV.y += sin(TIME * speed) * amplitude;
}

