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

// Spawn a Pachy Warrior for the player team
if (_team == TEAM.PLAYER) {
    var u = instance_create_layer(x, y, "ly_units", obj_unit_primal_pachy_warrior);
    u._team = TEAM.PLAYER;
    u._unit_name = "PACHY_WARRIOR";		
    u._spawner = id; // reference to the spawner that spawned them

    // --------------------------
    // Assign initial lane path
    // --------------------------
    var nearest_path = noone;
    var nearest_dist = 99999;

    // 1. Look for nearby friendly fodder units
    with (obj_unit) {
        if (_team == other._team && _unit_name == "FODDER") {
            if (path_exists(_lane_path)) {
                var px = path_get_point_x(_lane_path, 0);
                var py = path_get_point_y(_lane_path, 0);
                var d = point_distance(other.x, other.y, px, py);
                if (d < nearest_dist) {
                    nearest_dist = d;
                    nearest_path = _lane_path;
                }
            }
        }
    }

    // 2. Fallback to spawner's lane
    if (nearest_path == noone && _lane != noone) {
        nearest_path = _lane;
    }

    // Assign lane to Pachy Warrior
    if (nearest_path != noone) {
        u._lane_path = nearest_path;
        u._path_index = 0;
        u._state = UNIT_STATE.MOVE;
    }
}



