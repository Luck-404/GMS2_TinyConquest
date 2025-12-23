if (place_meeting(x,y,obj_unit_fodder)){
	//create list of people in zone
	var _list = ds_list_create();
	instance_place_list(x,y,obj_unit_fodder,_list,false);
	
	//check if enemy is inside zone
	var _enemy_in = false;
	for (var _i = 0; _i < ds_list_size(_list); _i++){
		var _unit = ds_list_find_value(_list,_i);
		if (_unit._state != UNIT_STATE.DEAD && _unit._team != _team){
			_enemy_in = true;
		}
	}
	
	if (_enemy_in == true){
		_charging = true;
		_cur_charge+=0.2;
		if (_cur_charge > _max_charge){
			_cur_charge = _max_charge;	
		}
	}
} else {
	_charging = false;	
}