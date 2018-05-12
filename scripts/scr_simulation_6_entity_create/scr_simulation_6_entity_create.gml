/// @function scr_simulation_6_entity_create()


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

tile_solid_45_se = global.TILE_SOLID_45_SE;
tile_solid_45_sw = global.TILE_SOLID_45_SW;
tile_solid_45_ne = global.TILE_SOLID_45_NE;
tile_solid_45_nw = global.TILE_SOLID_45_NW;

// collision tilemap
collision_tilemap = global.COLLISION_TILEMAP;

// movement
speed_h = 50;
speed_v = 50;

velocity_x = 0;
velocity_y = 0;

move_h = 0;
move_v = 0;

new_move_h = 0;
new_move_v = 0;

new_move_list = ds_list_create();
new_move_list[| 0] = new_move_h;
new_move_list[| 1] = new_move_v;

// states
collision_h = false;
collision_v = false;

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

// ds lists
bbox_points = ds_list_create();
