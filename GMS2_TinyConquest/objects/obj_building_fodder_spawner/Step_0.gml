/////////////////////////////
// OBJ_FODDER_SPAWNER STEP //
/////////////////////////////
event_inherited();

if (_flag_disabled == false){
	if (_spawn_cooldown > 0) {
	    _spawn_cooldown--;
	    exit;
	}

	_spawn_cooldown = 300;

	var u;

	if (_team == TEAM.PLAYER) {
	    u = instance_create_layer(x, y, "ly_units", obj_unit_primal_fodder);
	    u._team = TEAM.PLAYER;
	} else {
	    u = instance_create_layer(x, y, "ly_units", obj_unit_slag_fodder);
	    u._team = TEAM.ENEMY;
	}


	u._unit_name = "FODDER";
	u._spawner = id; // reference to the spawner that spawned them

	
	// Lane assignment
	u._lane_path   = _lane;
	u._lane_length = _lane_length;
	u._lane_pos    = 0;

	u._state = UNIT_STATE.MOVE;
} else {
	if (_disabled_cooldown > 0){
		_disabled_cooldown--;	
	} else {
		_cur_hp = _max_hp;
		_flag_disabled = false;
		_flag_destroyed = false;
		_disabled_cooldown = 3600;
	}
}