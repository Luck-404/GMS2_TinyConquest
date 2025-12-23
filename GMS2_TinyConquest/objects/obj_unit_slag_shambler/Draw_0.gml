draw_self();

if (_selected){
	draw_sprite(spr_selected,0,x,y);
}

if ((_tar_x != x) && (_tar_y != y)){
	draw_sprite(spr_target,0,_tar_x,_tar_y);	
}

draw_set_color(c_white);
var _str = string(_cur_hp) + "/" + string(_max_hp);
draw_text(x-(string_width(_str)/2),y+50,_str);