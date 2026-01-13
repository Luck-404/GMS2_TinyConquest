if (global._flag_pause == false){
	//disable check
	if (_cur_hp <= 0){
		_cur_hp = 0;	
		_flag_destroyed = true;
		_flag_disabled = true;
	}
}