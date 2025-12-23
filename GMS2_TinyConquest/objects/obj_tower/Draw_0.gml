//==============================
// BUILDING UI / ZONE (no shader)
//==============================
draw_set_color(c_black);

// Has a unit entered the radius?
if (_active) {
    var _str = "ACTIVE";
    draw_text(x - (string_width(_str) / 2), y + 50, _str);
    draw_sprite(spr_tower_zone, 1, x, y);
} else {
    var _str = "INACTIVE";
    draw_text(x - (string_width(_str) / 2), y + 50, _str);
    draw_sprite(spr_tower_zone, 0, x, y);
}

//==============================
// TEAM OUTLINE (building sprite)
//==============================
var _col = (_team == BUILDING_TEAM.PLAYER) ? c_blue : c_red;

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
var _uvs = sprite_get_uvs(spr_tower, 0);
// uvs = [u0, v0, u1, v1]

shader_set_uniform_f(u_min, _uvs[0], _uvs[1]);
shader_set_uniform_f(u_max, _uvs[2], _uvs[3]);

//--------------------------------
// Correct texel size (UV per pixel)
//--------------------------------
var sw = sprite_get_width(spr_tower);
var sh = sprite_get_height(spr_tower);

var uv_w = _uvs[2] - _uvs[0];
var uv_h = _uvs[3] - _uvs[1];

shader_set_uniform_f(
    u_texel,
    uv_w / sw,
    uv_h / sh
);

//--------------------------------
// Draw building WITH outline
//--------------------------------
draw_sprite(spr_tower, 0, x, y);

// Disable shader
shader_reset();

draw_set_color(c_white);
var _str = string(_cur_hp) + "/" + string(_max_hp);
draw_text(x - (string_width(_str) / 2), y + 50, _str);