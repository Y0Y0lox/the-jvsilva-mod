#pragma header

uniform float angleX;
uniform float scrollOffset;
uniform float repeatY;
uniform float widthScale; // Smaller value = thinner highway (e.g., 0.45)

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec2 centered = uv - 0.5;

    // 1. Apply 3D X-axis perspective across the whole screen
    float rad = radians(angleX);
    float tilt = sin(rad);
    float z = 1.0 + centered.y * tilt * 1.5;

    if (z <= 0.05) {
        gl_FragColor = vec4(0.0);
        return;
    }

    vec2 projected;
    // Divide by widthScale so the highway becomes thinner inside the 1280px canvas
    projected.x = (centered.x / z) / widthScale + 0.5;
    projected.y = (centered.y / z) * cos(rad) + 0.5;

    // 2. Keep the angled side edges transparent
    if (projected.x < 0.0 || projected.x > 1.0) {
        gl_FragColor = vec4(0.0);
        return;
    }

    // 3. Loop the highway texture continuously
    projected.y = fract(projected.y * repeatY - scrollOffset);

    gl_FragColor = flixel_texture2D(bitmap, projected);
}