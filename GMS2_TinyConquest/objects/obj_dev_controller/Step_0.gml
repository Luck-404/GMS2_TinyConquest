//
// CONTROLLER DEV STEP
//

if (keyboard_check_pressed(vk_escape)){
	show_debug_message("\n\n ENDING GAME WITH ESC");
	game_end();
}

if (keyboard_check_pressed(ord("F"))){
	show_debug_message("\n\n TOGGLING FULLSCREEN");
	window_set_fullscreen(!window_get_fullscreen());	
}

if (keyboard_check_pressed(ord("I"))){
	show_debug_message("\n\n TOGGLING FRIENDLY FIRE");
	global._flag_friendly_fire = !global._flag_friendly_fire;
}

if (keyboard_check_pressed(ord("Q"))){
	show_debug_message("\n\n TOGGLING DEV MODE")
	global._flag_dev = !global._flag_dev;
}

if (keyboard_check_pressed(ord("P"))){
	show_debug_message("\n\n TOGGLING PAUSE MODE")
	global._flag_pause = !global._flag_pause;	
}

if (keyboard_check_pressed(ord("M"))){
	show_debug_message("\n\n TOGGLING OVERLAY MODE")
	global._flag_overlays = !global._flag_overlays;
}

if (keyboard_check_pressed(ord("O"))){
	show_debug_message("\n\n TOGGLING DEBUG OUTPUT MODE")
	global._flag_optional_debug = !global._flag_optional_debug;
}


#region DEV COMMAND EXECUTION

	//TOGGLE BETWEEN PLAYER AND ENEMY TEAM SELECTED
	#region TOGGLE TEAM F1
	if (keyboard_check_pressed(vk_f1)){
		if (global._dev_team_selected == "PLAYER"){
			global._dev_team_selected = "ENEMY"
		} else {
			global._dev_team_selected = "PLAYER";
		}	
	}
	#endregion
	
	//TRIGGER AN EXPLOSION AT THE SELECTED UNIT/BUILDING IF THERE IS ONE, OTHERWISE AT THE CURSOR
	#region EXPLOSION 5 F2
	if (keyboard_check_pressed(vk_f2)){
		var _tarx;
		var _tary;
		if (obj_player_controller._entity_selected != undefined){
			_tarx = obj_player_controller._entity_selected.x;
			_tary = obj_player_controller._entity_selected.y;
		}
		else {
			_tarx = mouse_x;
			_tary = mouse_y;		
		}

		instance_create_layer(_tarx,_tary,"ly_fx",obj_fx_explosion);
	}	
	#endregion
	
	//TRIGGER A ZAP AT THE SELECTED UNIT/BUILDING IF THERE IS ONE, OTHERWISE AT THE CURSOR
	#region ZAP 1 F3
	if (keyboard_check_pressed(vk_f3)){
		
		//spawn FX
		var _tarx;
		var _tary;
		if (obj_player_controller._entity_selected != undefined){
			_tarx = obj_player_controller._entity_selected.x;
			_tary = obj_player_controller._entity_selected.y;
		}
		else {
			_tarx = mouse_x;
			_tary = mouse_y;		
		}
		instance_create_layer(_tarx,_tary,"ly_fx",obj_fx_zap);		
		
		
		//DEAL DMG
		if (obj_player_controller._entity_selected != undefined){
			if (global._flag_friendly_fire == true){
				obj_player_controller._entity_selected._cur_hp--;
				} else {
				if (global._dev_team_selected == "PLAYER"){
					if (obj_player_controller._entity_selected._team == TEAM.ENEMY){
						obj_player_controller._entity_selected._cur_hp--;
					}
				} else {
					if (obj_player_controller._entity_selected._team == TEAM.PLAYER){
						obj_player_controller._entity_selected._cur_hp--;
					}
				}
			}
		}
		else {
		if (position_meeting(mouse_x,mouse_y,obj_unit)){
			var _unit = instance_position(mouse_x,mouse_y,obj_unit);
			if (global._flag_friendly_fire == true){
				_unit._cur_hp--;
				} else {
				if (global._dev_team_selected == "PLAYER"){
					if (_unit._team == TEAM.ENEMY){
						_unit._cur_hp--;
					}
				} else {
					if (_unit._team == TEAM.PLAYER){
						_unit._cur_hp--;
					}
				}
			}
		} else if (position_meeting(mouse_x,mouse_y,obj_building)){
			var _building = instance_position(mouse_x,mouse_y,obj_building);
			if (global._flag_friendly_fire == true){
				_building._cur_hp--;
				} else {
				if (global._dev_team_selected == "PLAYER"){
					if (_building._team == TEAM.ENEMY){
						_building._cur_hp--;
					}
				} else {
					if (_building._team == TEAM.PLAYER){
						_building._cur_hp--;
					}
				}
			}
		}
	}		
	}
	#endregion	

	//TRIGGER AN INSTAKILL AT THE SELECTED UNIT/BUILDING IF THERE IS ONE, OTHERWISE AT THE CURSOR
	#region INSTAKILL F4
	if (keyboard_check_pressed(vk_f4)){	
	
		//KILL SELECTED
		if (obj_player_controller._entity_selected != undefined){
			obj_player_controller._entity_selected._cur_hp = 0;
		}
		
		//KILL AT CURSOR
		else {
			if (position_meeting(mouse_x,mouse_y,obj_unit)){
				var _unit = instance_position(mouse_x,mouse_y,obj_unit);
				_unit._cur_hp = 0;
			} else if (position_meeting(mouse_x,mouse_y,obj_building)){
				var _building = instance_position(mouse_x,mouse_y,obj_building);
					_building._cur_hp = 0;
			}
		}
	}		
#endregion

	//TRIGGER A FULL RESTORE AT THE SELECTED UNIT/BUILDING IF THERE IS ONE, OTHERWISE AT THE CURSOR
	#region FULL RESTORE F5
	if (keyboard_check_pressed(vk_f5)){	
	
		//REVIVE SELECTED
		if (obj_player_controller._entity_selected != undefined){
			obj_player_controller._entity_selected._cur_hp = obj_player_controller._entity_selected._max_hp;
			if(object_is_ancestor(obj_player_controller._entity_selected.object_index,obj_building)){
				obj_player_controller._entity_selected._flag_disabled = false;
				obj_player_controller._entity_selected._flag_destroyed = false;
			} else {
				obj_player_controller._entity_selected._state = UNIT_STATE.MOVE;
			}
		}
		
		//RESTORE AT CURSOR
		else {
			if (position_meeting(mouse_x,mouse_y,obj_unit)){
				var _unit = instance_position(mouse_x,mouse_y,obj_unit);
				_unit._cur_hp = _unit._max_hp;
				_unit._state = UNIT_STATE.MOVE;
			} else if (position_meeting(mouse_x,mouse_y,obj_building)){
				var _building = instance_position(mouse_x,mouse_y,obj_building);
					_building._cur_hp = _building._max_hp;
					_building._flag_disabled = false;
					_building._flag_destroyed = false;
			}
		}
	}		
#endregion

	//TRIGGER A HEAL AT THE SELECTED UNIT/BUILDING IF THERE IS ONE, OTHERWISE AT THE CURSOR
	#region HEAL 1 F6
	if (keyboard_check_pressed(vk_f6)){	
	
		//REVIVE SELECTED
		if (obj_player_controller._entity_selected != undefined){
				obj_player_controller._entity_selected._cur_hp++;
				if (obj_player_controller._entity_selected._cur_hp > obj_player_controller._entity_selected._max_hp){
					obj_player_controller._entity_selected._cur_hp = obj_player_controller._entity_selected._max_hp;	
				}
			if(object_is_ancestor(obj_player_controller._entity_selected.object_index,obj_building)){
				obj_player_controller._entity_selected._flag_disabled = false;
				obj_player_controller._entity_selected._flag_destroyed = false;
			} else {
				
				obj_player_controller._entity_selected._state = UNIT_STATE.MOVE;
			}
		}
		
		//RESTORE AT CURSOR
		else {
			if (position_meeting(mouse_x,mouse_y,obj_unit)){
				var _unit = instance_position(mouse_x,mouse_y,obj_unit);
				_unit._cur_hp++;
				if (_unit._cur_hp > _unit._max_hp){
					_unit._cur_hp = _unit._max_hp;	
				}
				_unit._state = UNIT_STATE.MOVE;
			} else if (position_meeting(mouse_x,mouse_y,obj_building)){
				var _building = instance_position(mouse_x,mouse_y,obj_building);
					_building._cur_hp++;
					if (_building._cur_hp > _building._max_hp){
						_building._cur_hp = _building._max_hp;	
					}
					_building._flag_disabled = false;
					_building._flag_destroyed = false;
			}
		}
	}		
#endregion

	//SPAWN 5 FODDER OF SELECT TEAM AT CURSOR
	#region SPAWN 5 FODDER  F7
	if (keyboard_check_pressed(vk_f7)){	
		if (tilemap_get_at_pixel(global._wall_map,mouse_x,mouse_y) == 0){

			//if unit is selected, grab the path from the unit
			if (obj_player_controller._entity_selected != undefined){
				var _tarx = obj_player_controller._entity_selected.x;
				var _tary = obj_player_controller._entity_selected.x;	
				for (var _i = 0; _i<5; _i++){
					var _xrand = irandom_range(-100,100);
					var _yrand = irandom_range(-100,100);
					var _unit = instance_create_layer(_tarx+_xrand,_tary+_yrand,"ly_units",obj_unit_general_fodder);
					//based on the team, give them that distinction
					if (global._dev_team_selected == "PLAYER"){
						_unit._team = TEAM.PLAYER;
					} else {
						_unit._team = TEAM.ENEMY;							
					}
					_unit._lane_path = obj_player_controller._entity_selected._lane_path;
					_unit._spawner = obj_player_controller._entity_selected._spawner;
					_unit._state = UNIT_STATE.MOVE;
					_unit._stance = UNIT_STANCE.PUSH;
					scr_rejoin_lane(_unit);
				}				
			}
			
			//if there is not a unit selected- use mouse
			else {
				//spawn 5
				for (var _i = 0; _i<5; _i++){
					var _xrand = irandom_range(-100,100);
					var _yrand = irandom_range(-100,100);
					var _unit = instance_create_layer(mouse_x+_xrand,mouse_y+_yrand,"ly_units",obj_unit_general_fodder);
					var _spawner = undefined;
					
					//based on the team, give them that distinction
					if (global._dev_team_selected == "PLAYER"){
						_unit._team = TEAM.PLAYER;	
						if (mouse_y > room_height/2){
							_spawner = instance_furthest(mouse_x,mouse_y,obj_building_fodder_spawner);
						} else {
							_spawner = instance_nearest(mouse_x,mouse_y,obj_building_fodder_spawner);
						}
					} else {
						_unit._team = TEAM.ENEMY;	
						if (mouse_y < room_height/2){
							_spawner = instance_furthest(mouse_x,mouse_y,obj_building_fodder_spawner);
						} else {
							_spawner = instance_nearest(mouse_x,mouse_y,obj_building_fodder_spawner);
						}						
					}
					_unit._lane_path = _spawner._lane;	
					_unit._spawner = _spawner;
					_unit._state = UNIT_STATE.MOVE;
					_unit._stance = UNIT_STANCE.PUSH;
					scr_rejoin_lane(_unit);				
				}
			}
		}
	}		
	
	//SPAWN 1 FODDER
	#region SPAWN 1 FODDER F8
	if (keyboard_check_pressed(vk_f8)){	
		
	}
	
	//TRIGGER A LARGE KNOCKBACK AT CURSOR
	#region TRIGGER LARGE KNOCKBACK F9
	if (keyboard_check_pressed(vk_f9)){	
		
	}			
#endregion

#endregion