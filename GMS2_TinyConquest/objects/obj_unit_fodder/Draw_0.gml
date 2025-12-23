//==============================
// TEAM OUTLINE (unit sprite)
//==============================
var _col = (_team == UNIT_TEAM.PLAYER) ? c_blue : c_red;

// Enable shader
shader_set(shd_team_outline);

// Get uniforms (cache in Create for performance if desired)
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
// Outline thickness (pixels)
//--------------------------------
shader_set_uniform_f(u_size, 1.0);

//--------------------------------
// Sprite UVs (atlas-safe)
//--------------------------------
var _uvs = sprite_get_uvs(sprite_index, image_index);
// uvs = [u0, v0, u1, v1]

// Pass UV bounds
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

//--------------------------------
// Draw unit WITH outline
//--------------------------------
draw_self();

// Disable shader
shader_reset();


//==============================
// OVERLAYS (no shader)
//==============================

// Selection ring
if (_selected) {
    draw_sprite(spr_selected, 0, x, y);
}

// Move target marker
if ((_tar_x != x) && (_tar_y != y)) {
    draw_sprite(spr_target, 0, _tar_x, _tar_y);
}

// HP text
draw_set_color(c_white);
var _str = string(_cur_hp) + "/" + string(_max_hp);
draw_text(x - (string_width(_str) / 2), y + 50, _str);