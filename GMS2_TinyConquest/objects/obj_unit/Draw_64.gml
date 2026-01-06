///////////////////////
// OBJ_UNIT DRAW GUI //
///////////////////////

//IF SELECTED
if (_selected) {

    //BG PANEL, BADGE, SPRITE
	#region BG
    draw_set_color(c_black);
    draw_rectangle(275, 595, 805, 745, false);

    draw_set_color(c_ltgray);
    draw_rectangle(280, 600, 800, 740, false);

    // ----------------------------
    // TEAM BADGE
    // ----------------------------
    if (_team == TEAM.PLAYER) {
        draw_set_color(c_aqua);
    } else {
        draw_set_color(c_red);
    }
    draw_rectangle(285, 605, 404, 724, false);

    // ----------------------------
    // UNIT SPRITE (FULL SIZE)
    // ----------------------------
    draw_sprite(
        sprite_index,
        image_index,
        345,
        665
    );
	#endregion

    //STRING FOR INFO
	#region INFO
    draw_set_color(c_black);

    // ----------------------------
    // STRING HELPERS
    // ----------------------------
    var hp_txt   = string(_cur_hp) + " / " + string(_max_hp);
    var spd_txt  = string(_move_speed);

    var state_txt;
    switch (_state) {
        case UNIT_STATE.IDLE:    state_txt = "IDLE"; break;
        case UNIT_STATE.MOVE:    state_txt = "MOVE"; break;
        case UNIT_STATE.ATTACK:  state_txt = "ATTACK"; break;
        case UNIT_STATE.DEAD:    state_txt = "DEAD"; break;
    }

    // ----------------------------
    // TARGET DESCRIPTION
    // ----------------------------
    var target_txt = "NONE";

    if (instance_exists(_attack_target)) {

        if (object_is_ancestor(_attack_target.object_index, obj_unit)) {
            target_txt = "UNIT";
        }
        else if (object_is_ancestor(_attack_target.object_index, obj_building)) {
            target_txt = "BUILDING";
        }
        else {
            target_txt = "UNKNOWN";
        }

    }
    else {
        // Using fallback position
        if (point_distance(x, y, _tar_x, _tar_y) > 1) {
            target_txt =
                "POSITION (" +
                string(round(_tar_x)) + "," +
                string(round(_tar_y)) + ")";
        }
    }

    // ----------------------------
    // BUILD STRING
    // ----------------------------
    var _str =
        "TYPE: UNIT\n" +
        "HP: " + hp_txt + "\n" +
        "SPEED: " + spd_txt + "\n" +
        "STATE: " + state_txt + "\n" +
        "TARGET: " + target_txt + "\n" +
        "POS: (" + string(round(x)) + "," + string(round(y)) + ")";

    // ----------------------------
    // DRAW TEXT
    // ----------------------------
    draw_text_ext(
        410,
        600,
        _str,
        12,
        360
    );
	#endregion
}
