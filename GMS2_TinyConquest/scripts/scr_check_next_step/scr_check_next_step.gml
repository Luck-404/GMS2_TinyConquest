/// scr_check_next_step(_unit, _dir, _step)
/// Checks if the next step will hit a wall and adjusts direction if needed
/// _unit = the moving unit
/// _dir = current movement direction in degrees
/// _step = speed/step size

function scr_check_next_step(_unit, _dir, _step) {

    var next_x = _unit.x + lengthdir_x(_step, _dir);
    var next_y = _unit.y + lengthdir_y(_step, _dir);

    // Check global wall map
    var wall_val = tilemap_get_at_pixel(global._wall_map, next_x, next_y);

    if (wall_val == 0) {
        // No wall, safe to move
        return _dir;
    }

    // Obstacle ahead → try pivot 45° and 90° each direction
    var angles = [45, -45, 90, -90, 135, -135, 180];
    for (var i = 0; i < array_length(angles); i++) {
        var test_dir = _dir + angles[i];
        var test_x = _unit.x + lengthdir_x(_step, test_dir);
        var test_y = _unit.y + lengthdir_y(_step, test_dir);
        if (tilemap_get_at_pixel(global._wall_map, test_x, test_y) == 0) {
            return test_dir;
        }
    }

    // No safe direction found → stop
    return -1; 
}