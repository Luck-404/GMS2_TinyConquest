// create list of units in tower zone
var _list = ds_list_create();
instance_place_list(x, y, obj_unit_fodder, _list, true);

_active = false;
_target = undefined;

// scan for first living enemy
for (var _i = 0; _i < ds_list_size(_list); _i++) {
    var _unit = ds_list_find_value(_list, _i);
    if (_unit._state != UNIT_STATE.DEAD && _unit._team != _team) {
        _target = _unit;
        _active = true;
        break; // stop at first living enemy
    }
}

// free the temporary list
ds_list_destroy(_list);

// handle shooting
if (_active && _target != undefined) {
    if (_shot_cooldown > 0) {
        _shot_cooldown--;
    } else {
        _shot_cooldown = 180;

        // create shot
        var _new_shot = instance_create_layer(x, y - 96, "ly_fx", obj_shot);
        _new_shot.direction = point_direction(_new_shot.x, _new_shot.y, _target.x, _target.y);
        _new_shot.speed = 12;
        _new_shot._shot_target = _target;

        // deal damage
        _target._cur_hp--;

        // optional: if unit dies instantly, mark as dead immediately
        if (_target._cur_hp <= 0) {
            _target._cur_hp = 0;
            _target._state = UNIT_STATE.DEAD;
        }
    }
} else {
    // no enemies in zone
    _shot_cooldown = 30;
}