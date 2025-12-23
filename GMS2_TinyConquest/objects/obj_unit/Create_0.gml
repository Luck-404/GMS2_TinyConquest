_cur_hp = 10;
_max_hp = 10;
_spd = 3;

_selected = false;

enum UNIT_STATE{
	IDLE,
	MOVE,
	ATTACK,
	DEAD
}
_state = UNIT_STATE.IDLE;

_tar_x = x;
_tar_y = y;

enum UNIT_TEAM {
    PLAYER,
    ENEMY
}

enum UNIT_STANCE {
	DEFEND,
	ATTACK,
	PUSH
}

u_outline_col   = shader_get_uniform(shd_team_outline, "outline_color");
u_outline_size  = shader_get_uniform(shd_team_outline, "outline_size");
u_outline_texel = shader_get_uniform(shd_team_outline, "texel_size");