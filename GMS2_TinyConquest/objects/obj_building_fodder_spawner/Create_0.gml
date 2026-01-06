///////////////////////////////
// OBJ_FODDER_SPAWNER CREATE //
///////////////////////////////
event_inherited();

// SPAWN LOGIC
_spawn_cooldown = 0;
_disabled_cooldown = 3600;

// LANES
_lanes_arr = [];
_lane = noone;

// Generate lanes
scr_regenerate_lane_path(id);
