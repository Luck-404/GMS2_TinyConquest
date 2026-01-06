/////////////////////
// OBJ_UNIT CREATE //
/////////////////////

// HEALTH
_cur_hp = 10;
_max_hp = 10;
_dead_timer = 300;

// MOVEMENT
_move_speed = 2;

// VISUAL
image_xscale = -1;

// SELECTION
_selected = false;
_type = "UNIT";

// STATE
enum UNIT_STATE {
    IDLE,
    MOVE,
    ATTACK,
    DEAD
}
_state = UNIT_STATE.IDLE;

// TEAM
_team = TEAM.PLAYER;

// LANE PATHING
_lane_path   = noone;
_lane_length = 1;
_lane_pos    = 0;
_path_index  = 0; // important for lane-following units

// COMBAT
_attack_target = undefined;
_attack_cooldown = 60;
_attack_range = 16;

// UNIT SELECTION
_tar_x = x;
_tar_y = y;

// SPawner reference (set when spawned)
_spawner = undefined;
