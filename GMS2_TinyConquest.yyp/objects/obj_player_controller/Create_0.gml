//////////////////////////////////
// OBJ_PLAYER_CONTROLLER CREATE //
//////////////////////////////////
_entity_selected = undefined; //REF TO A UNIT / BUILDING
_cam_spd = 30; //SPEED OF SCROLLING WITH THE CAMERA
global._tile_size = 64;
global._wall_penalty_grid = undefined;
global._wall_layer = layer_get_id("ly_walls");
global._wall_map   = layer_tilemap_get_id(global._wall_layer);

enum TEAM {
    PLAYER,
    ENEMY,
    NEUTRAL
}