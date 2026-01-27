/////////////////////////////
// OBJ_FODDER_SPAWNER DRAW //
/////////////////////////////
event_inherited(); //INHERIT LOGIC FROM OBJ_BUILDINGS

draw_self();

if (_flag_disabled == false){
	//DRAW SPAWNING COOLDOWN
	draw_set_color(c_white);
	var _str = string(_spawn_cooldown)/60;
	draw_text(x-(string_width(_str)/2),y-50,_str);
}

else {
	//DRAW DISABLED COOLDOWN
	draw_set_color(c_yellow);
	var _str = string(_disabled_cooldown)/60;
	draw_text(x-(string_width(_str)/2),y-50,_str);		
}