if (_cur_hp <= 0){
	_cur_hp = 0;
	_state = UNIT_STATE.DEAD;
	image_index = 1;
}

switch(_state){
	case UNIT_STATE.IDLE:
	
	break;
	
	case UNIT_STATE.MOVE:
		if (_stance == UNIT_STANCE.PUSH){
			if (distance_to_object(obj_tower) < 300 && _target == undefined){
				var _tower = instance_nearest(x,y,obj_tower);
				if (_tower._team != _team){
					_target = _tower;
				}
			}
		}
		if (_target == undefined){
			var dir = point_direction(x, y, _tar_x, _tar_y);
			x += lengthdir_x(_spd, dir);
			y += lengthdir_y(_spd, dir);

			if (point_distance(x, y, _tar_x, _tar_y) <= _spd) {
				x = _tar_x;
				y = _tar_y;
				_state = UNIT_STATE.IDLE;
			}
		} else {
			var dir = point_direction(x, y, _target.x, _target.y);
			x += lengthdir_x(_spd, dir);
			y += lengthdir_y(_spd, dir);

			if (point_distance(x, y, _target.x, _target.y) <= _spd*3) {
				x = _target.x;
				y = _target.y;
				_state = UNIT_STATE.ATTACK
			}
		}
	break;
	
	case UNIT_STATE.ATTACK:
		if (_attack_cooldown > 0){
			_attack_max_cooldown--;
		} else {
			_attack_cooldown = _attack_max_cooldown;
			_target._cur_hp--;
			if (_target._cur_hp >= 0){
				_target = undefined;	
				x = _tar_x;
				y = _tar_y;
				_state = UNIT_STATE.IDLE;
			}
		}
	break;
	
	case UNIT_STATE.DEAD:
	
	break;	
}