///////////////////
// OBJ_UNIT DRAW //
///////////////////

//--------------------------
// Outline Shader
//--------------------------
var _col = (_team == TEAM.PLAYER) ? c_blue : c_red;

shader_set(shd_team_outline);

var u_col   = shader_get_uniform(shd_team_outline, "outline_color");
var u_size  = shader_get_uniform(shd_team_outline, "outline_size");
var u_texel = shader_get_uniform(shd_team_outline, "texel_size");
var u_min   = shader_get_uniform(shd_team_outline, "uv_min");
var u_max   = shader_get_uniform(shd_team_outline, "uv_max");

shader_set_uniform_f(
    u_col,
    colour_get_red(_col)/255,
    colour_get_green(_col)/255,
    colour_get_blue(_col)/255,
    1
);

shader_set_uniform_f(u_size, 1.0);

var _uvs = sprite_get_uvs(sprite_index, image_index);
shader_set_uniform_f(u_min, _uvs[0], _uvs[1]);
shader_set_uniform_f(u_max, _uvs[2], _uvs[3]);

var sw = sprite_get_width(sprite_index);
var sh = sprite_get_height(sprite_index);

shader_set_uniform_f(u_texel, (_uvs[2]-_uvs[0])/sw, (_uvs[3]-_uvs[1])/sh);
shader_reset();

//--------------------------
// Draw the lane path
//--------------------------
if (global._flag_overlays == true){
if (path_exists(_lane_path)) {
    var num_points = path_get_number(_lane_path);
    draw_set_alpha(0.5);
    
    // Lane color by team
    draw_set_color((_team == TEAM.PLAYER) ? c_blue : c_red);
    
    for (var i = 0; i < num_points - 1; i++) {
        var x1 = path_get_point_x(_lane_path, i);
        var y1 = path_get_point_y(_lane_path, i);
        var x2 = path_get_point_x(_lane_path, i + 1);
        var y2 = path_get_point_y(_lane_path, i + 1);
        
        // Draw the line connecting points
        draw_line(x1, y1, x2, y2);
        
        // Highlight diagonal moves
        if (x1 != x2 && y1 != y2) {
            draw_set_color(c_yellow);
            draw_circle((x1+x2)/2, (y1+y2)/2, 8, false);
            draw_set_color((_team == TEAM.PLAYER) ? c_blue : c_red);
        }
        
        // Draw small circles at tile centers
        draw_circle(x1, y1, 4, false);
    }
    
    // Draw last path point
    var last_x = path_get_point_x(_lane_path, num_points - 1);
    var last_y = path_get_point_y(_lane_path, num_points - 1);
    draw_circle(last_x, last_y, 4, false);
    
    // Draw unit's current position on path
    var px = path_get_x(_lane_path, _lane_pos);
    var py = path_get_y(_lane_path, _lane_pos);
    draw_set_color(c_lime);
    draw_circle(px, py, 6, false);
    
    draw_set_alpha(1);
}
}

//--------------------------
// Draw the unit itself
//--------------------------
draw_self();

//--------------------------
// Draw selection indicator
//--------------------------
if (_selected) {
    draw_sprite(spr_selected, 0, x, y);
}

//--------------------------
// Draw HP
//--------------------------
draw_set_color(c_white);
var _str = string(_cur_hp) + "/" + string(_max_hp);
draw_text(x - (string_width(_str)/2), y + 50, _str);

// Draw DEFEND ICON if attached
if (_stance == UNIT_STANCE.DEFEND && variable_instance_exists(id, "_loc_defend_x")) {
    draw_sprite(spr_defend_icon, 0, _loc_defend_x, _loc_defend_y - 24);
}

