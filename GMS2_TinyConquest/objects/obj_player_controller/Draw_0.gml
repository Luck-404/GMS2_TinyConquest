/// scr_debug_draw_ground_tiles()
/// Draws yellow circles at every ground tile in ly_ground

// Get tilemap ID
var tilemap_id = layer_tilemap_get_id("ly_ground");
if (tilemap_id == -1) return; // Layer not found

// Tile size (adjust if needed)
var tile_size = 64;

// Room grid dimensions
var grid_width  = room_width div tile_size;
var grid_height = room_height div tile_size;

// Loop through every tile coordinate
for (var tx = 0; tx < grid_width; tx++)
{
    for (var ty = 0; ty < grid_height; ty++)
    {
        var tile_index = tilemap_get(tilemap_id, tx, ty);
        
        if (tile_index != 0)
        {
            // Compute center of tile
            var px = tx * tile_size + tile_size/2;
            var py = ty * tile_size + tile_size/2;
            
            // Draw yellow circle
            draw_set_color(c_yellow);
            draw_circle(px, py, 8, false);
        }
    }
}

// Reset color
draw_set_color(c_white);
