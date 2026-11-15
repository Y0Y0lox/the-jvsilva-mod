#pragma header

uniform float angleX;

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec2 p = uv - 0.5;

    float a = radians(angleX);
    float c = cos(a);
    float s = sin(a);

    float z = c - p.y * s;

    uv = p / z + 0.5;
    uv.x = p.x * c / z + 0.5;

    if (uv.x < 0.0 || uv.x > 1.0 ||
        uv.y < 0.0 || uv.y > 1.0)
    {
        gl_FragColor = vec4(0.0);
        return;
    }

    gl_FragColor = flixel_texture2D(bitmap, uv);
}