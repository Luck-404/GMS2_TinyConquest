if (place_meeting(x,y,obj_unit_slag_shambler)){
	_charging = true;
	_cur_charge+=0.2;
	if (_cur_charge > _max_charge){
		_cur_charge = _max_charge;	
	}
} else {
	_charging = false;	
}