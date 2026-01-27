/// scr_regenerate_lane_path(spawner)
function scr_regenerate_lane_path(spawner)
{
    if (!instance_exists(spawner)) return;

    // Ensure wall penalty cache exists
    if (is_undefined(global._wall_penalty_grid))
        scr_build_wall_penalty_cache();

    // Delete old lanes
    for (var i = 0; i < array_length(spawner._lanes_arr); i++)
    {
        if (path_exists(spawner._lanes_arr[i]))
            path_delete(spawner._lanes_arr[i]);
    }
    spawner._lanes_arr = [];

    var tile_size  = global._tile_size;
    var tilemap_id = layer_tilemap_get_id("ly_ground");

    var w = room_width  div tile_size;
    var h = room_height div tile_size;

    var start_tx = spawner.x div tile_size;
    var start_ty = spawner.y div tile_size;

    var goal_y  = (spawner._team == TEAM.PLAYER) ? 3104 : 288;
    var goal_tx = start_tx;
    var goal_ty = goal_y div tile_size;

    var dir_x = [-1, 0, 1, -1, 1, -1, 0, 1];
    var dir_y = [-1,-1,-1,  0, 0,  1, 1, 1];
    var dir_cost = [1.4,1,1.4, 1,1, 1.4,1,1.4];

    // Very small bias so lanes differ by ~1 tile max
    var lane_bias = [-0.15, 0, 0.15];

    for (var lane_i = 0; lane_i < 3; lane_i++)
    {
        var cost   = ds_grid_create(w, h);
        var parent = ds_grid_create(w, h);

        // IMPORTANT: ix / iy, NOT x / y
        for (var ix = 0; ix < w; ix++)
        {
            for (var iy = 0; iy < h; iy++)
            {
                cost[# ix, iy]   = infinity;
                parent[# ix, iy] = -1;
            }
        }

        var open_set = ds_priority_create();
        ds_priority_add(open_set, [start_tx, start_ty], 0);
        cost[# start_tx, start_ty] = 0;

        var found = false;

        while (!ds_priority_empty(open_set))
        {
            var cur = ds_priority_delete_min(open_set);
            var cx = cur[0];
            var cy = cur[1];

            if (cx == goal_tx && cy == goal_ty)
            {
                found = true;
                break;
            }

            for (var d = 0; d < 8; d++)
            {
                var nx = cx + dir_x[d];
                var ny = cy + dir_y[d];

                if (nx < 0 || ny < 0 || nx >= w || ny >= h) continue;

                var wx = nx * tile_size + tile_size * 0.5;
                var wy = ny * tile_size + tile_size * 0.5;
                if (tilemap_get_at_pixel(tilemap_id, wx, wy) == 0) continue;

                var lateral = abs(nx - start_tx) * lane_bias[lane_i];

                var g =
                    cost[# cx, cy] +
                    dir_cost[d] +
                    scr_tile_wall_penalty(nx, ny) +
                    lateral;

                if (g < cost[# nx, ny])
                {
                    cost[# nx, ny] = g;
                    parent[# nx, ny] = cy * w + cx;

                    // Vertical heuristic (MOBA lane style)
                    var h_cost = abs(goal_ty - ny);
                    ds_priority_add(open_set, [nx, ny], g + h_cost);
                }
            }
        }

        // --------------------------
        // RECONSTRUCT
        // --------------------------
        var txs = [];
        var tys = [];

        if (found)
        {
            var cx = goal_tx;
            var cy = goal_ty;

            while (!(cx == start_tx && cy == start_ty))
            {
                array_push(txs, cx);
                array_push(tys, cy);

                var p = parent[# cx, cy];
                cx = p mod w;
                cy = p div w;
            }

            array_push(txs, start_tx);
            array_push(tys, start_ty);
        }

        // --------------------------
        // SMOOTHING
        // --------------------------
        var sx = [];
        var sy = [];

        array_push(sx, txs[0]);
        array_push(sy, tys[0]);

        for (var i = 1; i < array_length(txs) - 1; i++)
        {
            if (!scr_is_collinear(
                sx[array_length(sx)-1], sy[array_length(sy)-1],
                txs[i], tys[i],
                txs[i+1], tys[i+1]))
            {
                array_push(sx, txs[i]);
                array_push(sy, tys[i]);
            }
        }

        array_push(sx, txs[array_length(txs)-1]);
        array_push(sy, tys[array_length(tys)-1]);

        var lane_path = path_add();
        for (var i = array_length(sx) - 1; i >= 0; i--)
        {
            path_add_point(
                lane_path,
                sx[i] * tile_size + tile_size * 0.5,
                sy[i] * tile_size + tile_size * 0.5,
                100
            );
        }

        array_push(spawner._lanes_arr, lane_path);

        ds_priority_destroy(open_set);
        ds_grid_destroy(cost);
        ds_grid_destroy(parent);
    }

    // Default to center lane
    spawner._lane = spawner._lanes_arr[1];
    spawner._lane_length = path_get_length(spawner._lane);
}
