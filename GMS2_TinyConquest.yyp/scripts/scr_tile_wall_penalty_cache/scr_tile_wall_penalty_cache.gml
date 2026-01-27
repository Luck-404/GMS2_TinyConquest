/// scr_build_wall_penalty_cache()
function scr_build_wall_penalty_cache()
{
    var tile_size = global._tile_size;
    var tilemap_id = layer_tilemap_get_id("ly_ground");
    if (tilemap_id == -1) return;

    var w = room_width  div tile_size;
    var h = room_height div tile_size;

    if (is_undefined(global._wall_penalty_grid))
        global._wall_penalty_grid = ds_grid_create(w, h);

    for (var tx = 0; tx < w; tx++)
    {
        for (var ty = 0; ty < h; ty++)
        {
            var penalty = 0;

            // Wall proximity
            for (var ox = -1; ox <= 1; ox++)
            for (var oy = -1; oy <= 1; oy++)
            {
                if (ox == 0 && oy == 0) continue;

                var px = (tx + ox) * tile_size + tile_size * 0.5;
                var py = (ty + oy) * tile_size + tile_size * 0.5;

                if (px < 0 || py < 0 || px >= room_width || py >= room_height)
                {
                    penalty += 0.5;
                    continue;
                }

                if (tilemap_get_at_pixel(tilemap_id, px, py) == 0)
                    penalty += 0.3;
            }

            // Anti-edge hugging
            var edge_dist = min(
                tx,
                ty,
                w - 1 - tx,
                h - 1 - ty
            );

            if (edge_dist < 2)      penalty += 1.0;
            else if (edge_dist < 4) penalty += 0.5;
            else if (edge_dist < 6) penalty += 0.2;

            global._wall_penalty_grid[# tx, ty] = penalty;
        }
    }
}
