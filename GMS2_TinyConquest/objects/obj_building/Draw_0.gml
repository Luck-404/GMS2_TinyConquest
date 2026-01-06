///////////////////////
// OBJ_BUILDING DRAW //
///////////////////////

// TEAM OUTLINE
var _col = (_team == TEAM.PLAYER) ? c_blue : c_red;

// Enable shader
shader_set(shd_team_outline);

// Uniforms (cache in Create if you want)
var u_col   = shader_get_uniform(shd_team_outline, "outline_color");
var u_size  = shader_get_uniform(shd_team_outline, "outline_size");
var u_texel = shader_get_uniform(shd_team_outline, "texel_size");
var u_min   = shader_get_uniform(shd_team_outline, "uv_min");
var u_max   = shader_get_uniform(shd_team_outline, "uv_max");

//--------------------------------
// Outline color
//--------------------------------
shader_set_uniform_f(
    u_col,
    colour_get_red(_col) / 255,
    colour_get_green(_col) / 255,
    colour_get_blue(_col) / 255,
    1
);

//--------------------------------
// Outline thickness
//--------------------------------
shader_set_uniform_f(u_size, 1.0);

//--------------------------------
// Sprite UVs (atlas-safe)
//--------------------------------
var _uvs = sprite_get_uvs(sprite_index, 0);
// uvs = [u0, v0, u1, v1]

shader_set_uniform_f(u_min, _uvs[0], _uvs[1]);
shader_set_uniform_f(u_max, _uvs[2], _uvs[3]);

//--------------------------------
// Correct texel size (UV per pixel)
//--------------------------------
var sw = sprite_get_width(sprite_index);
var sh = sprite_get_height(sprite_index);

var uv_w = _uvs[2] - _uvs[0];
var uv_h = _uvs[3] - _uvs[1];

shader_set_uniform_f(
    u_texel,
    uv_w / sw,
    uv_h / sh
);

// Disable shader
shader_reset();

// IF SELECTED, DRAW A RING SPRITE
if (_selected) {
    draw_sprite(spr_selected, 0, x, y);
}