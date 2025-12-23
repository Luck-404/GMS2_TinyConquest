if (_shot_target != undefined){
	direction = point_direction(x,y,_shot_target.x,_shot_target.y);
	if (place_meeting(x,y,_shot_target)){
		instance_destroy();	
	}
}
if (_life > 0){
	_life--;	
} else {
	instance_destroy();	
}