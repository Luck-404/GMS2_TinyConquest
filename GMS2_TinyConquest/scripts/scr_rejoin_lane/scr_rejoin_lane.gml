/// scr_rejoin_lane(unit)
function scr_rejoin_lane(u)
{
    if (!instance_exists(u)) return;

    var best_lane = u._lane_path;
    var best_dist = infinity;
    var best_pos  = 0;

    for (var l = 0; l < array_length(u._spawner._lanes_arr); l++)
    {
        var lane = u._spawner._lanes_arr[l];
        if (!path_exists(lane)) continue;

        for (var t = 0; t <= 1; t += 0.05)
        {
            var px = path_get_x(lane, t);
            var py = path_get_y(lane, t);
            var d  = point_distance(u.x, u.y, px, py);

            // Prefer staying on current lane
            if (lane == u._lane_path) d *= 0.8;

            if (d < best_dist)
            {
                best_dist = d;
                best_lane = lane;
                best_pos  = t;
            }
        }
    }

    u._lane_path = best_lane;
    u._lane_pos  = best_pos;
}
