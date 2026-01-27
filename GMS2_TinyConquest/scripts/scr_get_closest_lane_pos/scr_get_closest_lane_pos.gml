/// scr_get_closest_lane_pos(unit)
/// Returns the best forward-facing path index for this unit
function scr_get_closest_lane_pos(u)
{
    if (!instance_exists(u)) return 0;
    if (u._lane_path == undefined || !path_exists(u._lane_path)) return 0;

    var p = u._lane_path;
    var point_count = path_get_number(p);

    var best_index = 0;
    var best_score = infinity;

    // Determine lane direction bias
    // PLAYER moves down, ENEMY moves up
    var forward_sign = (u._team == TEAM.PLAYER) ? 1 : -1;

    for (var i = 0; i < point_count; i++)
    {
        var px = path_get_point_x(p, i);
        var py = path_get_point_y(p, i);

        // How far vertically from the lane point
        var dy = py - u.y;

        // Reject points that are clearly "behind" the unit
        if (dy * forward_sign < -16) continue;

        var dx = abs(px - u.x);
        var dy_abs = abs(dy);

        // Weighted score:
        // prioritize Y alignment, then X distance
        var _score = dy_abs * 2 + dx;

        if (_score < best_score)
        {
            best_score = _score;
            best_index = i;
        }
    }

    // Nudge forward so we don’t stall on the same node
    best_index = clamp(best_index + 1, 0, point_count - 1);

    return best_index;
}
