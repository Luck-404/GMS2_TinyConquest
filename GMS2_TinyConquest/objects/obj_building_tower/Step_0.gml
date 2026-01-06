////////////////////////
//// OBJ_TOWER STEP ////
////////////////////////
event_inherited();

// Only act if tower is alive and enabled
if (!_flag_destroyed && !_flag_disabled) {

    var _search_radius = 2 * global._tile_size;
    var _closest_dist  = _search_radius + 1; // Only consider units within radius
    var _target        = undefined;

    // ------------------------
    // Find closest enemy unit
    // ------------------------
    var _list = ds_list_create();
    collision_circle_list(x, y, _search_radius, obj_unit, false, true, _list, true);

    for (var i = 0; i < ds_list_size(_list); i++) {
        var _unit = ds_list_find_value(_list, i);

        if (!instance_exists(_unit)) continue;
        if (_unit._team == _team) continue;
        if (_unit._state == UNIT_STATE.DEAD) continue;

        var _dist = point_distance(x, y, _unit.x, _unit.y);
        if (_dist < _closest_dist) {
            _closest_dist = _dist;
            _target = _unit;
        }
    }

    ds_list_destroy(_list);

    // ------------------------
    // Attack target if valid
    // ------------------------
    if (instance_exists(_target)) {
        _active = true;

        if (_shot_cooldown <= 0) {

            _shot_cooldown = 180; // reset cooldown

            // Spawn projectile
            var _new_shot = instance_create_layer(x, y - 96, "ly_fx", obj_fx_shot);
            _new_shot.direction = point_direction(_new_shot.x, _new_shot.y, _target.x, _target.y);
            _new_shot.speed = 12;

            // Deal damage
            _target._cur_hp--;
            if (_target._cur_hp <= 0) {
                _target._cur_hp = 0;
                _target._state = UNIT_STATE.DEAD;
            }

        } else {
            _shot_cooldown--;
        }

    } else {
        _active = false;
        _shot_cooldown = max(_shot_cooldown - 1, 0);
    }
}
