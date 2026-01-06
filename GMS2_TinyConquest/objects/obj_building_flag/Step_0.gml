///////////////////
// OBJ_FLAG STEP //
///////////////////

//WHILE THERE IS STILL CHARGE LEFT TO BE HAD
if (_flag_completed == false){
	
	//CHECK IF THERE IS A UNIT WITHIN THE ZONE
	if (place_meeting(x,y,obj_unit)){
		//create list of people in zone
		var _list = ds_list_create();
		instance_place_list(x,y,obj_unit,_list,false);
	
		//check if an enemy is inside zone
		var _enemy_in = false;
		for (var _i = 0; _i < ds_list_size(_list); _i++){
			var _unit = ds_list_find_value(_list,_i);
			if (_unit._state != UNIT_STATE.DEAD && _unit._team != _team){
				_enemy_in = true;
			}
		}
	
		//IF THERE IS AN ENEMY IN, INCREMENT THE CHARGE
		if (_enemy_in == true){
			_charging = true;
			_cur_charge+=0.2;
			//ONCE MAX CHARGE IS MET, COMPLETE THE OBJECTIVE
			if (_cur_charge > _max_charge){
				_cur_charge = _max_charge;	
				_flag_completed = true;
			}
		}
	} 
	//IF THERE IS NO ENEMY, THE FLAG IS NOT CHARGING
	else {
		_charging = false;	
	}
}