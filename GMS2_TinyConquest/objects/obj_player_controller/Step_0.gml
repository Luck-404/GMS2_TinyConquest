if (mouse_check_button_pressed(mb_left)) {

	var clicked_unit = instance_position(
		mouse_x,
		mouse_y,
		obj_unit_fodder
	);

	// If we clicked a unit
	if (clicked_unit != noone && clicked_unit._state != UNIT_STATE.DEAD) {

		// Unselect previous unit
		if (_unit_selected != undefined && _unit_selected != noone) {
			_unit_selected._selected = false;
		}

		// Select new unit
		_unit_selected = clicked_unit;
		_unit_selected._selected = true;

	}
	// Clicked empty space
	else {

		if (_unit_selected != undefined && _unit_selected != noone) {
			_unit_selected._selected = false;
		}

		_unit_selected = undefined;
	}
}

if (_unit_selected != undefined){
	if (keyboard_check_pressed(vk_space)) {
		_unit_selected._tar_x = mouse_x;
		_unit_selected._tar_y = mouse_y;
		_unit_selected._state = UNIT_STATE.MOVE;
	}
}	

//CAM
if (keyboard_check(ord("W"))){
		if (y-_cam_spd < 0){
			
		} else {
			y-=_cam_spd;
		}
}

if (keyboard_check(ord("A"))){
		if (x-_cam_spd < 0){
			
		} else {
			x-=_cam_spd;
		}
}

if (keyboard_check(ord("S"))){
		if (y+_cam_spd > 3840){
			
		} else {
			y+=_cam_spd;
		}
}

if (keyboard_check(ord("D"))){
		if (x+_cam_spd > 1920){
			
		} else {
			x+=_cam_spd;
		}
}