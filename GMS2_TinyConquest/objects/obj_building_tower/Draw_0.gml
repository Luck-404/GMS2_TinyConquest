////////////////////
// OBJ_TOWER DRAW //
////////////////////

event_inherited(); // inherit base building draw

// Draw tower sprite
if (!_flag_destroyed && !_flag_disabled){
    draw_sprite(spr_tower, 0, x, y);

    // Draw status text
    draw_set_color(c_black);
    var status_txt = _active ? "ACTIVE" : "INACTIVE";
    draw_text(x - string_width(status_txt)/2, y - 50, status_txt);

    // Draw HP
    draw_set_color(c_white);
    var hp_txt = string(_cur_hp) + "/" + string(_max_hp);
    draw_text(x - string_width(hp_txt)/2, y + 50, hp_txt);

    // Draw attack radius circle
    draw_set_alpha(0.25);
    draw_set_color(_active ? c_red : c_white);
    draw_circle(x, y, 3 * global._tile_size, true);
    draw_set_alpha(1);

} else {
    // Dead tower sprite
    draw_sprite(spr_tower, 1, x, y);
}
