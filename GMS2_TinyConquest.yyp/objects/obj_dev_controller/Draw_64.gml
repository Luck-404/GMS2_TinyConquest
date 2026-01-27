//
// DEV CONTROLLER DRAW GUI
//

// DEV MODE
if (global._flag_dev){
	draw_text(25,25,"DEV MODE ON (Q)");
} else {
	draw_text(25,25,"DEV MODE OFF (Q)");	
}

if (global._flag_dev){
	draw_set_color(c_white);	

	// FRIENDLY FIRE
	if (global._flag_friendly_fire){
		draw_text(25,50,"FRIENDLY FIRE ON (I)");
	} else {
		draw_text(25,50,"FRIENDLY FIRE OFF (I)");	
	}

	//PAUSE
	if (global._flag_pause){
		draw_text(25,75,"PAUSE ON (P)");
	} else {
		draw_text(25,75,"PAUSE OFF (P)");	
	}

	//OVERLAY MODE
	if (global._flag_overlays){
		draw_text(25,100,"PATHING OVERLAY ON (M)");
	} else {
		draw_text(25,100,"PATHING OVERLAY OFF (M)");	
	}
	
	//DEBUG OUTPUT MODE
	if (global._flag_optional_debug){
		draw_text(25,125,"DEBUG OUTPUT ON (O)");
	} else {
		draw_text(25,125,"DEBUG OUTPUT OFF (O)");	
	}	
	
	//TEAM SELECTED
	if (global._dev_team_selected == "PLAYER"){
		draw_text(25,150,"TEAM SELECTED IS PLAYER (F1)");
	} else {
		draw_text(25,150,"TEAM SELECTED IS ENEMY (F1)");	
	}		
	
	
	//COMMANDS LIST
	draw_text(25,175,"EXPLODE (5 DMG) AT SELECTED>CURSOR (F2)");
	draw_text(25,200,"ZAP (1 DMG) AT SELECTED>CURSOR (F3)");
	draw_text(25,225,"INSTAKILL/DESTROY AT SELECTED>CURSOR (F4)");
	draw_text(25,250,"REVIVE/RESTORE AT SELECTED>CURSOR (F5)");
	draw_text(25,275,"HEAL (1 HP) AT SELECTED>CURSOR (F6)");
	draw_text(25,300,"SPAWN 5 FODDER OF SELECTED TEAM AT CURSOR (F7)");
	draw_text(25,325,"LARGE KNOCKBACK AT CURSOR (F8)");

}