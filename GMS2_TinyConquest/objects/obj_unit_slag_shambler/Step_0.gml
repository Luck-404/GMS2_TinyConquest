if (_cur_hp <= 0){
	_cur_hp = 0;
	_state = UNIT_STATE.DEAD;
	image_index = 1;
}

switch(_state){
	case UNIT_STATE.IDLE:
	
	break;
	
	case UNIT_STATE.MOVE:
		var dir = point_direction(x, y, _tar_x, _tar_y);
		x += lengthdir_x(_spd, dir);
		y += lengthdir_y(_spd, dir);

		if (point_distance(x, y, _tar_x, _tar_y) <= _spd) {
			x = _tar_x;
			y = _tar_y;
			_state = UNIT_STATE.IDLE;
		}
	break;
	
	case UNIT_STATE.DEAD:
	
	break;	
}