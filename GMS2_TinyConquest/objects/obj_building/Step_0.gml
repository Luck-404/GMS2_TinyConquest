//disable check
if (_cur_hp < 0){
	_cur_hp = 0;	
	_flag_destroyed = true;
	_flag_disabled = true;
	//if (_selected){
	//	_selected = false;
	//	obj_player_controller._entity_selected = undefined;	
	//}	
}