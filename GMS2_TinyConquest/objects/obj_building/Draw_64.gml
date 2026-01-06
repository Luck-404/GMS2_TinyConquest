///////////////////////////
// OBJ_BUILDING DRAW GUI //
///////////////////////////
if (_selected){
	#region BACKGROUND, BADGE, SPRITE
	// Draw GUI background
	draw_set_color(c_black);
	draw_rectangle(275, 595, 805, 745, false); // was 300,620,780,720

	draw_set_color(c_ltgray);
	draw_rectangle(280, 600, 800, 740, false); // was 305,625,775,715	

	// Draw colored team badge
	if (_team == TEAM.PLAYER){
		draw_set_color(c_aqua);
		draw_rectangle(285, 605, 404, 724, false); // was 310,630,379,699
	} else {
		draw_set_color(c_red);
		draw_rectangle(285, 605, 404, 724, false);
	}
	
	// Draw sprite of building (unchanged)
	draw_sprite_ext(sprite_index, 0, 347, 667, 0.5, 0.5, 0, c_white, 1);
	#endregion

	// DRAW INFO
	draw_set_color(c_black);
	
	// ----------------------------
	// BASE BUILDING INFO
	// ----------------------------
	var team_name = (_team == TEAM.PLAYER) ? "PLAYER" : "ENEMY";
	var hp_text   = string(_cur_hp) + " / " + string(_max_hp);
	var state_txt = _flag_destroyed ? "DESTROYED" : "OPERATIONAL";

	var _str =
	    "TYPE: " + _type + "\n" +
	    "FACTION: " + team_name + "\n" +
	    "HP: " + hp_text + "\n" +
	    "STATE: " + state_txt;

	#region FLAG SPECIAL INFO
	// ----------------------------
	// FLAG BUILDING INFO
	// ----------------------------
	if (sprite_index == spr_flag) {
	    _str +=
	        "\nFLAG STATUS" +
	        "\nCHARGE: " + string(_cur_charge) + " / " + string(_max_charge) +
	        "\nCHARGING: " + (_charging ? "YES" : "NO") +
	        "\nCOMPLETED: " + (_flag_completed ? "YES" : "NO");
	}
	#endregion

	#region TOWER SPECIAL INFO
	// ----------------------------
	// TOWER BUILDING INFO
	// ----------------------------
	if (sprite_index == spr_tower) {
	    _str +=
	        "\nTOWER STATUS" +
	        "\nACTIVE: " + (_active ? "YES" : "NO") +
	        "\nTARGET: " + ((_target != undefined) ? "TARGET ACQUIRED" : "NO TARGET") +
	        "\nCOOLDOWN: " + string(_shot_cooldown);
	}
	#endregion

	#region FODDER SPAWNER SPECIAL INFO
	// ----------------------------
	// FODDER SPAWNER INFO
	// ----------------------------
	if (sprite_index == spr_fodder_spawner) {
	    _str +=
	        "\nSPAWNER STATUS" +
	        "\nSPAWN CD: " + string(ceil(_spawn_cooldown / 60)) + "s";
	}
	#endregion

	//draw the text output in the box
	draw_text_ext(
	    420, 600,  
	    _str,
	    15,
	    360
	);
	#endregion
}