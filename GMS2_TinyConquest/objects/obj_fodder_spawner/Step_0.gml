if (_spawn_cooldown > 0){
	_spawn_cooldown--;	
}
//spawn unit
else {
	_spawn_cooldown = 600;
	var _new_unit = instance_create_layer(x,y,"ly_units",obj_unit_fodder);
	if (_team == BUILDING_TEAM.PLAYER){
		_new_unit._team = UNIT_TEAM.PLAYER;
		_new_unit._state = UNIT_STATE.MOVE;
		_new_unit._tar_x = x;
		_new_unit._tar_y = 3500;
	} else {
		_new_unit._team = UNIT_TEAM.ENEMY;
		_new_unit._state = UNIT_STATE.MOVE;
		_new_unit._tar_x = x;
		_new_unit._tar_y = 250;	
	}
}