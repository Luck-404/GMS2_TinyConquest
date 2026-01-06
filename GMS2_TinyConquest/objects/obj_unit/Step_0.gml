///////////////////
// OBJ_UNIT STEP //
///////////////////

// --------------------------
// DEATH CHECK
// --------------------------
if (_cur_hp <= 0){
    instance_destroy();
    exit; // skip rest of step
}

// --------------------------
// SOFT PUSH FROM OTHER UNITS
// --------------------------
if (place_meeting(x, y, obj_unit)) {
    var _unit = instance_place(x, y, obj_unit);

    if (_unit != id) {
        var _dir = point_direction(_unit.x, _unit.y, x, y);
        var _dist = point_distance(x, y, _unit.x, _unit.y);
        var _push = max(0, 1 - (_dist / 32)) * 0.5;

        x += lengthdir_x(_push, _dir);
        y += lengthdir_y(_push, _dir);

        _unit.x -= lengthdir_x(_push, _dir);
        _unit.y -= lengthdir_y(_push, _dir);
    }
}

// --------------------------
// ENEMY SEARCH (IDLE or MOVE)
// --------------------------
var search_radius = 3 * global._tile_size;
var closest_dist = search_radius + 1;
var new_target = undefined;

// Enemy units
with (obj_unit) {
    if (_team != other._team && _state != UNIT_STATE.DEAD) {
        var d = point_distance(x, y, other.x, other.y);
        if (d < closest_dist) {
            closest_dist = d;
            new_target = id;
        }
    }
}

// Enemy buildings
if (new_target == undefined) {
    with (obj_building) {
        if (_team != other._team && !_flag_destroyed && !_flag_disabled) {
            var d = point_distance(x, y, other.x, other.y);
            if (d < closest_dist) {
                closest_dist = d;
                new_target = id;
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
        if (_unit_name != "FODDER") {
            // Move toward player _tar_x/_tar_y
            var dist = point_distance(x, y, _tar_x, _tar_y);
            if (dist > _move_speed) {
                var dir = point_direction(x, y, _tar_x, _tar_y);
                x += lengthdir_x(_move_speed, dir);
                y += lengthdir_y(_move_speed, dir);
                if (_tar_x > x) image_xscale = 1;
                else image_xscale = -1;
            }
        }
        break;
    #endregion

    #region MOVE
    case UNIT_STATE.MOVE:

        if (_unit_name != "FODDER") {
            // Move toward _tar_x/_tar_y
            var dist = point_distance(x, y, _tar_x, _tar_y);
            if (dist > _move_speed) {
                var dir = point_direction(x, y, _tar_x, _tar_y);
                x += lengthdir_x(_move_speed, dir);
                y += lengthdir_y(_move_speed, dir);
                if (_tar_x > x) image_xscale = 1;
                else image_xscale = -1;
            } else {
                _state = UNIT_STATE.IDLE;
            }
        } 
        else if (_lane_path != undefined && path_exists(_lane_path)) {
            // Ensure _path_index exists
            if (!variable_instance_exists(id, "_path_index") || _path_index == undefined) {
                _path_index = 0;
            }

            // Move along lane
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

        // Move toward attack target if out of range
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
