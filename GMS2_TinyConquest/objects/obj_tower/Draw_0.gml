draw_set_color(c_black);

if (_active){
	var _str = "ACTIVE";
	draw_text(x-(string_width(_str)/2),y+50,_str);
	draw_sprite(spr_tower_zone,1,x,y);	
}
else {
	var _str = "INACTIVE";
	draw_text(x-(string_width(_str)/2),y+50,_str);	
	draw_sprite(spr_tower_zone,0,x,y);	
}

draw_sprite(spr_tower,0,x,y);