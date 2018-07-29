/// @function scr_simulation_19_entity_create()


/**
 * Set Instance Variables
 *
 */

// scripts
script_raycast_collision = scr_simulation_19_entity_raycast;
script_slope_collision = scr_simulation_19_entity_slope;

// values
camera = global.CAMERA;
camera_width_half = global.CAMERA_WIDTH_HALF;
camera_height_half = global.CAMERA_HEIGHT_HALF;

tile_size = global.TILE_SIZE;
tile_solid = global.TILE_SOLID;

// one sided
tile_solid_west = global.TILE_SOLID_WEST;   //  --|
tile_solid_east = global.TILE_SOLID_EAST;   // |--
tile_solid_south = global.TILE_SOLID_SOUTH; // ---
tile_solid_north = global.TILE_SOLID_NORTH; // ___

// 45 degrees
tile_solid_45_se = global.TILE_SOLID_45_SE; // ◢
tile_solid_45_sw = global.TILE_SOLID_45_SW; // ◣
tile_solid_45_ne = global.TILE_SOLID_45_NE; // ◥
tile_solid_45_nw = global.TILE_SOLID_45_NW; // ◤

// 22 degress
tile_solid_22_se_1 = global.TILE_SOLID_22_SE_1; // ◢
tile_solid_22_se_2 = global.TILE_SOLID_22_SE_2; // ◢
tile_solid_22_sw_1 = global.TILE_SOLID_22_SW_1; // ◣
tile_solid_22_sw_2 = global.TILE_SOLID_22_SW_2; // ◣
tile_solid_22_ne_1 = global.TILE_SOLID_22_NE_1; // ◥
tile_solid_22_ne_2 = global.TILE_SOLID_22_NE_2; // ◥
tile_solid_22_nw_1 = global.TILE_SOLID_22_NW_1; // ◤
tile_solid_22_nw_2 = global.TILE_SOLID_22_NW_2; // ◤

// collision tile information
tile_definitions = global.TILE_DEFINITIONS;

// collision tilemap
collision_tilemap = global.COLLISION_TILEMAP;

// delta time
tick = 0;

inst_x = x;
inst_y = y;

// movement values
speed_h = 100;
speed_v = 100;//30;

velocity_x = 0;
velocity_y = 0;

// states
has_gravity = true;
is_jumping = false;
is_standing = false;

// movement values
move_h = 0;
move_v = 0;
new_move_h = 0;
new_move_v = 0;
move_distance_delta = 0;
move_distance_target = 0;

// collision states
collision_h = false;
collision_v = false
collision_slope = false;
collision_slope_tile_gradient = 0;
collision_floor = false;
collision_ceiling = false;

// raycasting movement values
raycast_x = 0;
raycast_y = 0;
raycast_new_move_h = 0;
raycast_new_move_v = 0;
raycast_redirect_move_h = 0;
raycast_redirect_move_v = 0;

// raycasting movement states
raycast_collision_h = false;
raycast_collision_v = false;
raycast_collision_slope = false;
raycast_collision_floor = false;
raycast_collision_ceiling = false;

// slope collision values
raycast_slope_x = 0;
raycast_slope_y = 0;
raycast_slope_move_h = 0;
raycast_slope_move_v = 0;
raycast_slope_collision_floor = false;
raycast_slope_collision_ceiling = false;

// drawing
//the_sprite = spr_simulation_15px;
//the_sprite = spr_simulation_10px;
//the_sprite = spr_simulation_8x6px;
the_sprite = spr_simulation_6px;
//the_sprite = spr_simulation_1px;

sprite_index = the_sprite;
mask_index = the_sprite;

bbox_width = sprite_get_bbox_right(sprite_index) - sprite_get_bbox_left(sprite_index)
bbox_height = sprite_get_bbox_bottom(sprite_index) - sprite_get_bbox_top(sprite_index)

sprite_bbox_left = sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_right = sprite_get_bbox_right(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_bottom = sprite_get_bbox_bottom(sprite_index) - sprite_get_yoffset(sprite_index);
sprite_bbox_top = sprite_get_bbox_top(sprite_index) - sprite_get_yoffset(sprite_index);

