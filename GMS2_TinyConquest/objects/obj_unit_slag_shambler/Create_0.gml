////
// SLAG SHAMBLER //
//

_cur_hp = 10;
_max_hp = 10;
_spd = 3;

_selected = false;

enum UNIT_STATE{
	IDLE,
	MOVE,
	DEAD
}
_state = UNIT_STATE.IDLE;

_tar_x = x;
_tar_y = y;

_team = undefined;