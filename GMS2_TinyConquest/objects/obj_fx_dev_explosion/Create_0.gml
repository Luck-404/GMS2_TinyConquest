_life = 15;

//deal damage to each unit/building at the spawned location
_units_list = ds_list_create();
_buildings_list = ds_list_create();
instance_position_list(x,y,obj_unit,_units_list,false);
instance_position_list(x,y,obj_building,_buildings_list,false);

//units
for (var _i = 0; _i < ds_list_size(_units_list); _i++){
	var _unit = ds_list_find_value(_units_list,_i);
	if (global._flag_friendly_fire == true){
		_unit._cur_hp-=5;
	} else {
		if (global._dev_team_selected == "PLAYER"){
			if (_unit._team == TEAM.ENEMY){
				_unit._cur_hp-=5;
			}
		} else {
			if (_unit._team == TEAM.PLAYER){
				_unit._cur_hp-=5;
			}
		}
	}
	
}

//buildings
for (var _i = 0; _i < ds_list_size(_buildings_list); _i++){
	var _building = ds_list_find_value(_buildings_list,_i);
	if (_building.sprite_index != spr_flag){
		if (global._flag_friendly_fire == true){
			_building._cur_hp-=5;
		} else {
		if (global._dev_team_selected == "PLAYER"){
			if (_building._team == TEAM.ENEMY){
				_building._cur_hp-=5;
			}
		} else {
			if (_building._team == TEAM.PLAYER){
				_building._cur_hp-=5;
			}
		}
	}
	}
}