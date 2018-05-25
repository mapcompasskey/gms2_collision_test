/// @function scr_simulation_11_entity_create()


/**
 * Set Instance Variables
 *
 */

// values
tile_size = global.TILE_SIZE;
tile_solid = global.TILE_SOLID;
tile_solid_west = global.TILE_SOLID_WEST;
tile_solid_east = global.TILE_SOLID_EAST
tile_solid_south = global.TILE_SOLID_SOUTH
tile_solid_north = global.TILE_SOLID_NORTH
tile_solild_45_se = global.TILE_SOLID_45_SE = 6; // ◢
tile_solild_45_sw = global.TILE_SOLID_45_SW = 7; // ◣
tile_solild_45_ne = global.TILE_SOLID_45_NE = 8; // ◥
tile_solild_45_nw = global.TILE_SOLID_45_NW = 9; // ◤

// collision tilemap
collision_tilemap = global.COLLISION_TILEMAP;

// delta time
tick = 0;

// movement values
speed_h = 50;
speed_v = 50;

velocity_x = 0;
velocity_y = 0;

move_h = 0;
move_v = 0;
new_move_h = 0;
new_move_v = 0;

// collision states
collision_h = false;
collision_v = false
collision_slope = false;
collision_slope_falling = false;
collision_slope_rising = false;

// raycasting starting position
raycast_x = 0;
raycast_y = 0;
raycast_slope_x = 0;
raycast_slope_y = 0;

// raycasting movement values
raycast_move_h = 0;
raycast_move_v = 0;
raycast_slope_move_h = 0;
raycast_slope_move_v = 0;

// raycasting collision states
raycast_collision_h = false;
raycast_collision_v = false;
raycast_collision_slope = false;

// drawing
// the_sprite = spr_simulation_15px;
the_sprite = spr_simulation_10px;
// the_sprite = spr_simulation_10px;
// the_sprite = spr_simulation_8x6px;
// the_sprite = spr_simulation_6px;
// the_sprite = spr_simulation_1px;

sprite_index = the_sprite;
mask_index = the_sprite;

bbox_width = sprite_get_bbox_right(sprite_index) - sprite_get_bbox_left(sprite_index)
bbox_height = sprite_get_bbox_bottom(sprite_index) - sprite_get_bbox_top(sprite_index)

sprite_bbox_left = sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_right = sprite_get_bbox_right(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_bottom = sprite_get_bbox_bottom(sprite_index) - sprite_get_yoffset(sprite_index);
sprite_bbox_top = sprite_get_bbox_top(sprite_index) - sprite_get_yoffset(sprite_index);

