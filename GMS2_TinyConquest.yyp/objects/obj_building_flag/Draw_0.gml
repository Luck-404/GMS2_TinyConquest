///////////////////
// OBJ_FLAG DRAW //
///////////////////
event_inherited(); //INHERITS FROM OBJ_BUILDING

//VISUAL CHARGE NUMBER
draw_set_color(c_black);
var _str = string(_cur_charge)+"/"+string(_max_charge);
draw_text(x-(string_width(_str)/2),y-50,_str);

//CHARGE SPRITE VISUAL CHANGES
if (_charging == true){
	draw_sprite(spr_flag_zone,1,x,y);
} else if (_flag_completed == true){
	draw_sprite(spr_flag_zone,2,x,y);		
}
else {
	draw_sprite(spr_flag_zone,0,x,y);
}

//CHANGE FLAG SPRITE IF FLAG IS COMPLETED
if (_flag_completed == true){
	draw_sprite(spr_flag,1,x,y);
} else {
	draw_sprite(spr_flag,0,x,y);	
}