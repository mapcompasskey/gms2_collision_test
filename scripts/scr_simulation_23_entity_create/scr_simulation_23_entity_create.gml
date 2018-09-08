/// @function scr_simulation_23_entity_create()


/**
 * Set Instance Variables
 *
 */

// scripts
script_raycast_collision = scr_simulation_23_entity_raycast;
script_slope_collision = scr_simulation_23_entity_slope;

// values
camera = global.CAMERA;
camera_width_half = global.CAMERA_WIDTH_HALF;
camera_height_half = global.CAMERA_HEIGHT_HALF;

// collision tile and tilemap information
collision_tilemap = global.COLLISION_TILEMAP;
tile_size = global.TILE_SIZE;
sloped_tiles_list = global.SLOPED_TILES_LIST;
tile_definitions = global.TILE_DEFINITIONS;

// tiles
tile_solid = global.TILE_SOLID;
tile_solid_west = global.TILE_SOLID_WEST;   //  --|
tile_solid_east = global.TILE_SOLID_EAST;   // |--
tile_solid_south = global.TILE_SOLID_SOUTH; // ---
tile_solid_north = global.TILE_SOLID_NORTH; // ___

// delta time
tick = 0;

inst_x = x;
inst_y = y;

// movement values
speed_h = 100;
speed_v = 100;
velocity_x = 0;
velocity_y = 0;
move_h = 0;
move_v = 0;

// collision states
collision_h = false;
collision_v = false
collision_floor = false;
collision_ceiling = false;
collision_slope = false;

// raycasting movement values and states
// *updated by the raycasting collision script
raycast_move_h = 0;
raycast_move_v = 0;
raycast_next_move_h = 0;
raycast_next_move_v = 0;
raycast_collision_h = false;
raycast_collision_v = false;
raycast_collision_slope = false;
raycast_collision_floor = false;
raycast_collision_ceiling = false;

// slope collision values and states
// *updated by the raycasting slope collision script
raycast_slope_x = 0;
raycast_slope_y = 0;
raycast_slope_move_h = 0;
raycast_slope_move_v = 0;
raycast_slope_collision_floor = false;
raycast_slope_collision_ceiling = false;
raycast_slope_collision_gradient = 0;

// states
has_gravity = false;
is_jumping = false;
is_standing = false;
is_solid = true;

// drawing
//the_sprite = spr_simulation_15px;
the_sprite = spr_simulation_10px;
//the_sprite = spr_simulation_8x6px;
//the_sprite = spr_simulation_6px;
//the_sprite = spr_simulation_1px;

sprite_index = the_sprite;
mask_index = the_sprite;

bbox_width = sprite_get_bbox_right(sprite_index) - sprite_get_bbox_left(sprite_index)
bbox_height = sprite_get_bbox_bottom(sprite_index) - sprite_get_bbox_top(sprite_index)

sprite_bbox_left = sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_right = sprite_get_bbox_right(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_bottom = sprite_get_bbox_bottom(sprite_index) - sprite_get_yoffset(sprite_index);
sprite_bbox_top = sprite_get_bbox_top(sprite_index) - sprite_get_yoffset(sprite_index);

