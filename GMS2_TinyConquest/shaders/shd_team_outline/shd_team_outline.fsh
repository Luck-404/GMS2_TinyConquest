varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 outline_color;
uniform float outline_size;
uniform vec2 texel_size;

// sprite UV bounds (passed from GML)
uniform vec2 uv_min;
uniform vec2 uv_max;

void main()
{
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);

    // Normal sprite pixels
    if (base.a > 0.0) {
        gl_FragColor = base * v_vColour;
        return;
    }

    float a = 0.0;
    vec2 px = outline_size * texel_size;
    vec2 uv;

    uv = clamp(v_vTexcoord + vec2( px.x,  0.0), uv_min, uv_max);
    a += texture2D(gm_BaseTexture, uv).a;

    uv = clamp(v_vTexcoord + vec2(-px.x,  0.0), uv_min, uv_max);
    a += texture2D(gm_BaseTexture, uv).a;

    uv = clamp(v_vTexcoord + vec2( 0.0,  px.y), uv_min, uv_max);
    a += texture2D(gm_BaseTexture, uv).a;

    uv = clamp(v_vTexcoord + vec2( 0.0, -px.y), uv_min, uv_max);
    a += texture2D(gm_BaseTexture, uv).a;

    if (a > 0.0) {
        gl_FragColor = outline_color;
    } else {
        discard;
    }
}