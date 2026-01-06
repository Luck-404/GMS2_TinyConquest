//////////////////////
// OBJ_TOWER CREATE //
//////////////////////
event_inherited(); //INHERITED FROM OBJ_BUILDING

//SHOT LOGIC
_cur_hp = 1;
_max_hp = 1;

_active = false;
_target = undefined;
_first_enemy = undefined;
_shot_cooldown = 30; //3s cooldown