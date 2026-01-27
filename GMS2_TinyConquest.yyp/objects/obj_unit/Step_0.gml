///////////////////
// OBJ_UNIT STEP //
///////////////////
if (global._flag_pause == false){
// --------------------------
// DEATH CHECK
// --------------------------
if (_cur_hp <= 0){
	if (_selected){
		_selected = false;
		obj_player_controller._entity_selected = undefined;
	}
    instance_destroy();
    exit; // skip rest of step
}

// --------------------------
// SOFT PUSH FROM OTHER UNITS (STRONGER)
// --------------------------
var push_strength = 2.0; 
if (place_meeting(x, y, obj_unit)) {
    var _unit = instance_place(x, y, obj_unit);
    if (_unit != id) {
        var _dir = point_direction(_unit.x, _unit.y, x, y);
        var _dist = point_distance(x, y, _unit.x, _unit.y);
        if (_dist > 0) {
            var _push = max(0, (1 - (_dist / 32)) * push_strength);
            x += lengthdir_x(_push, _dir);
            y += lengthdir_y(_push, _dir);
            _unit.x -= lengthdir_x(_push, _dir);
            _unit.y -= lengthdir_y(_push, _dir);
        }
    }
}

// --------------------------
// KNOCKBACK OVERRIDE
// --------------------------
if (_flag_knockback)
{
    x += lengthdir_x(_knockback_force, _knockback_dir);
    y += lengthdir_y(_knockback_force, _knockback_dir);

    _knockback_force *= 0.85; // damping feels good

    _knockback_timer--;

    if (_knockback_timer <= 0)
    {
        _flag_knockback = false;

        // Restore state
        _state  = _saved_state;
        _stance = _saved_stance;

        // Rejoin lane cleanly
        if (_lane_path != undefined && path_exists(_lane_path))
        {
            _path_index = scr_get_closest_lane_pos(id);
        }
    }

    exit;
} else {
// --------------------------
// ENEMY SEARCH (IDLE or MOVE) - modified for DEFEND
// --------------------------
var search_radius = 3 * global._tile_size;
if (_stance == UNIT_STANCE.DEFEND) search_radius = 5 * global._tile_size; // defend only searches short distance

var closest_dist = search_radius + 1;
var new_target = undefined;

// Enemy units
with (obj_unit) {
    if (_team != other._team && _state != UNIT_STATE.DEAD) {
        var d = point_distance(x, y, other.x, other.y);
        if (other._stance != UNIT_STANCE.DEFEND || d <= search_radius) { 
            if (d < closest_dist) {
                closest_dist = d;
                new_target = id;
            }
        }
    }
}

// Enemy buildings
if (new_target == undefined) {
    with (obj_building) {
        if (_team != other._team && !_flag_destroyed && !_flag_disabled) {
            var d = point_distance(x, y, other.x, other.y);
            if (other._stance != UNIT_STANCE.DEFEND || d <= search_radius) {
                if (d < closest_dist) {
                    closest_dist = d;
                    new_target = id;
                }
            }
        }
    }
}

// Switch to ATTACK if target found
if (new_target != undefined) {
    _attack_target = new_target;
    _state = UNIT_STATE.ATTACK;
}

// --------------------------
// STATE MACHINE
// --------------------------
switch(_state) {

    #region IDLE
    case UNIT_STATE.IDLE:

        // --------------------------
        // DEFEND STANCE: stay near defend point
        // --------------------------
        if (_stance == UNIT_STANCE.DEFEND && variable_instance_exists(id, "_loc_defend_x")) {
            var dist = point_distance(x, y, _loc_defend_x, _loc_defend_y);
            if (dist > 2) {
                var dir = point_direction(x, y, _loc_defend_x, _loc_defend_y);
                x += lengthdir_x(_move_speed*0.5, dir);
                y += lengthdir_y(_move_speed*0.5, dir);
                if (_loc_defend_x > x) image_xscale = 1;
                else image_xscale = -1;
            }
        }
        break;
    #endregion

    #region MOVE
    case UNIT_STATE.MOVE:

        // --------------------------
        // FODDER MOVE (lane)
        // --------------------------
        if (_unit_name == "FODDER" && _lane_path != undefined && path_exists(_lane_path)) {
            if (!variable_instance_exists(id, "_path_index") || _path_index == undefined) _path_index = 0;

            var target_x = path_get_point_x(_lane_path, _path_index);
            var target_y = path_get_point_y(_lane_path, _path_index);
            var dir = point_direction(x, y, target_x, target_y);
            var dist = point_distance(x, y, target_x, target_y);

            var step = min(_move_speed, dist);
            x += lengthdir_x(step, dir);
            y += lengthdir_y(step, dir);

            if (target_x > x) image_xscale = 1;
            else if (target_x < x) image_xscale = -1;

            if (dist <= _move_speed) _path_index = min(_path_index + 1, path_get_number(_lane_path)-1);
        }

        // --------------------------
        // NON-FODDER UNITS
        // --------------------------
        else {

            // --------------------------
            // PUSH STANCE: follow lane like fodder
            // --------------------------
            if (_stance == UNIT_STANCE.PUSH) {
                // Assign lane if none exists
                if (_lane_path == undefined || !path_exists(_lane_path)) {
                    var nearest_path = noone;
                    var nearest_dist = 99999;

                    // Look for nearby friendly fodder units
                    with (obj_unit) {
                        if (_team == other._team && _unit_name == "FODDER" && path_exists(_lane_path)) {
                            var px = path_get_point_x(_lane_path, 0);
                            var py = path_get_point_y(_lane_path, 0);
                            var d = point_distance(other.x, other.y, px, py);
                            if (d < nearest_dist) {
                                nearest_dist = d;
                                nearest_path = _lane_path;
                            }
                        }
                    }

                    // Fallback to spawner lane
                    if (nearest_path == noone && variable_instance_exists(_spawner, "_lane") && _spawner._lane != noone) {
                        nearest_path = _spawner._lane;
                    }

                    if (nearest_path != noone) {
                        _lane_path = nearest_path;
                        _path_index = 0;
                    }
                }

                // Follow assigned lane
                if (_lane_path != undefined && path_exists(_lane_path)) {
                    if (!variable_instance_exists(id, "_path_index") || _path_index == undefined) _path_index = 0;

                    var target_x = path_get_point_x(_lane_path, _path_index);
                    var target_y = path_get_point_y(_lane_path, _path_index);
                    var dir = point_direction(x, y, target_x, target_y);
                    var dist = point_distance(x, y, target_x, target_y);

                    var step = min(_move_speed, dist);
                    x += lengthdir_x(step, dir);
                    y += lengthdir_y(step, dir);

                    if (target_x > x) image_xscale = 1;
                    else if (target_x < x) image_xscale = -1;

                    if (dist <= _move_speed) _path_index = min(_path_index + 1, path_get_number(_lane_path)-1);
                }
            }

            // --------------------------
            // MANUAL OR DEFEND MOVE (toward target / defend point)
            // --------------------------
            if (_stance == UNIT_STANCE.MANUAL || _stance == UNIT_STANCE.DEFEND) {
                var tx, ty;

                if (_stance == UNIT_STANCE.MANUAL) {
                    tx = _tar_x;
                    ty = _tar_y;
                } else if (_stance == UNIT_STANCE.DEFEND && variable_instance_exists(id, "_loc_defend_x")) {
                    tx = _loc_defend_x;
                    ty = _loc_defend_y;
                }

                var dist = point_distance(x, y, tx, ty);
                if (dist > 1) {
                    var move_dir = point_direction(x, y, tx, ty);
                    var safe_dir = scr_check_next_step(id, move_dir, _move_speed*3);

                    if (safe_dir != -1) {
                        var step = min(_move_speed, dist);
                        x += lengthdir_x(step, safe_dir);
                        y += lengthdir_y(step, safe_dir);

                        if (tx > x) image_xscale = 1;
                        else image_xscale = -1;
                    }
                } else {
                    _state = UNIT_STATE.IDLE;
                }
            }
        }

        break;
    #endregion

    #region ATTACK
    case UNIT_STATE.ATTACK:

        if (_attack_target == undefined || !instance_exists(_attack_target)) {
            _attack_target = undefined;

            // Fodder returns to lane
            if (_unit_name == "FODDER" && variable_instance_exists(id, "_spawner") && instance_exists(_spawner)) {
                scr_rejoin_lane(id);
                _state = UNIT_STATE.MOVE;
            } else if (_unit_name != "FODDER") {
                _state = UNIT_STATE.MOVE;
            }

            break;
        }

        var dist = point_distance(x, y, _attack_target.x, _attack_target.y);
        if (dist > _attack_range) {
            var dir = point_direction(x, y, _attack_target.x, _attack_target.y);
            x += lengthdir_x(_move_speed, dir);
            y += lengthdir_y(_move_speed, dir);
            if (_attack_target.x > x) image_xscale = 1;
            else image_xscale = -1;
        } else {
            if (_attack_cooldown <= 0) {
                _attack_target._cur_hp -= 1;
                _attack_cooldown = 60;
            } else _attack_cooldown--;
        }

        break;
    #endregion

    #region DEAD
    case UNIT_STATE.DEAD:
        if (_dead_timer > 0) _dead_timer--;
        else instance_destroy();
        break;
    #endregion
}
}
}