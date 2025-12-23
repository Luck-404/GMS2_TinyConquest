if (place_meeting(x,y,obj_unit_slag_shambler)){
	_active = true;
	_target = instance_nearest(x,y,obj_unit_slag_shambler);

	if (_shot_cooldown > 0){
		_shot_cooldown--;	
	} else {
		_shot_cooldown = 180;
		var _new_shot = instance_create_layer(x,y-96,"ly_fx",obj_shot);
		_new_shot.direction = point_direction(_new_shot.x,_new_shot.y,_target.x,_target.y);
		_new_shot.speed = 12;
		_new_shot._shot_target = _target;
		_target._cur_hp--;
	}
} else {
	_active = false;
	_target = undefined;
	_shot_cooldown = 30;
}