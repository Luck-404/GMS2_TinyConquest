////////////////////////////////
// OBJ_PLAYER_CONTROLLER STEP //
////////////////////////////////

//LEFT CLICK SELECTS
#region SELECTION
if (mouse_check_button_pressed(mb_left)) {
    var clicked = noone;
	//TRY SELECTING UNIT FIRST
    clicked = instance_position(mouse_x, mouse_y, obj_unit);
	//TRY BUILDING SECOND
    if (clicked == noone) {
        clicked = instance_position(mouse_x, mouse_y, obj_building);
    }

	//CLICK RESOLUTION
    if (clicked != noone) {

        //CANT CLICK DEAD UNITS
        if (object_is_ancestor(clicked.object_index, obj_unit) &&
            clicked._state == UNIT_STATE.DEAD) 
        {
            clicked = noone;
        }
    }

    //SELECTION STATE VARIABLE UPDATE LOGIC
    if (clicked != noone) {

        //UNSELECT PREVIOUS
        if (_entity_selected != undefined && _entity_selected != noone) {
            _entity_selected._selected = false;
        }

        //SELECT NEW 
        _entity_selected = clicked;
        _entity_selected._selected = true;

    } 
	
	else {

        //IF YOU CLICKED ON EMPTY- UNSELECT
        if (_entity_selected != undefined && _entity_selected != noone) {
            _entity_selected._selected = false;
        }

        _entity_selected = undefined;
    }
}
#endregion

#region UNIT CONTROL/COMMANDS
if (_entity_selected != undefined && _entity_selected._type == "UNIT") {
	if (_entity_selected._unit_name != "FODDER"){
	    if (keyboard_check_pressed(vk_space)) {

			//place target down if you aren't clicking on the wall tilemap
			if (tilemap_get_at_pixel(global._wall_map,mouse_x,mouse_y) == 0){
				_entity_selected._tar_x = mouse_x;
				_entity_selected._tar_y = mouse_y;
			}
			
	        _entity_selected._state = UNIT_STATE.MOVE;

	        show_debug_message("[PLAYER] Move command issued to (" + string(_entity_selected._tar_x) + "," + string(_entity_selected._tar_y));
	    }
	}
}
#endregion


// CAMERA MOVE
#region CAMERA
var cam = view_camera[0];

// half view size
var half_w = camera_get_view_width(cam) * 0.5;
var half_h = camera_get_view_height(cam) * 0.5;

// desired movement
var nx = x;
var ny = y;

if (keyboard_check(ord("W"))) ny -= _cam_spd;
if (keyboard_check(ord("S"))) ny += _cam_spd;
if (keyboard_check(ord("A"))) nx -= _cam_spd;
if (keyboard_check(ord("D"))) nx += _cam_spd;

// clamp camera center to room bounds
nx = clamp(nx, half_w, room_width - half_w);
ny = clamp(ny, half_h, room_height - half_h);

// apply
x = nx;
y = ny;
#endregion