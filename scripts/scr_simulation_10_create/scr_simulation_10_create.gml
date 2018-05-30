/// @function scr_simulation_10_create()


/**
 * Globals for Helper Function
 *
 */

// values
global.DRAW_CELL_INDEX = 0;

// colors
global.COLLISION_H_COLOR = c_orange;
global.COLLISION_V_COLOR = c_yellow;
global.COLLISION_HV_COLOR = c_lime;
global.COLLISION_SLOPE_COLOR = c_lime;

// lists
global.DRAW_CELLS = ds_list_create();
global.GUI_ROOM_AXES = ds_list_create();
global.GUI_ROOM_X_AXIS = ds_list_create();
global.GUI_ROOM_Y_AXIS = ds_list_create();
global.GUI_AXIS_POINTS = ds_list_create();
global.GUI_BBOX_POINTS = ds_list_create();

// tiles
global.TILE_SIZE = 10;
global.TILE_SOLID = 1;
global.TILE_SOLID_WEST = 2;
global.TILE_SOLID_EAST = 3;
global.TILE_SOLID_SOUTH = 4;
global.TILE_SOLID_NORTH = 5;

global.TILE_SOLID_45_SE = 6; // ◢
global.TILE_SOLID_45_SW = 7; // ◣
global.TILE_SOLID_45_NE = 8; // ◥
global.TILE_SOLID_45_NW = 9; // ◤


/**
 * Set Instance Variables
 *
 */

// values
tick = 0;

// collision tilemap
collision_tilemap_layer_id = layer_get_id("Collision_Tiles");
collision_tilemap = layer_tilemap_get_id(collision_tilemap_layer_id);

// starting position
sim_x = 0;
sim_y = 0;

// movement angle and distance
move_angle = 0;
move_angle_rads = 0;
move_distance = 60;

// movement values
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

// simulation states
update_simulation = true;
is_rotating = false;

// drawing
//sprite_index = spr_simulation_15px;
//mask_index = spr_simulation_15px;

sprite_index = spr_simulation_10px;
mask_index = spr_simulation_10px;

//sprite_index = spr_simulation_8x6px;
//mask_index = spr_simulation_8x6px;

//sprite_index = spr_simulation_6px;
//mask_index = spr_simulation_6px;

//sprite_index = spr_simulation_1px;
//mask_index = spr_simulation_1px;

bbox_width = sprite_get_bbox_right(sprite_index) - sprite_get_bbox_left(sprite_index)
bbox_height = sprite_get_bbox_bottom(sprite_index) - sprite_get_bbox_top(sprite_index)

sprite_bbox_left = sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_right = sprite_get_bbox_right(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_bottom = sprite_get_bbox_bottom(sprite_index) - sprite_get_yoffset(sprite_index);
sprite_bbox_top = sprite_get_bbox_top(sprite_index) - sprite_get_yoffset(sprite_index);

// rotation timers
rotation_time = 0.1;
rotation_timer = 0;
rotation_pause_time = 0.5;
rotation_pause_timer = 0;


/**
 * Create Camera
 *
 */

// get window size
view_scale = 5;
window_width = window_get_width();
window_height = window_get_height();

// camera size
camera_x = (global.TILE_SIZE * -2);
camera_y = (global.TILE_SIZE * -4);
camera_width = (window_width / view_scale);
camera_height = (window_height / view_scale);

// create the camera
camera = camera_create();
    
// update camera properties
camera_set_view_pos(camera, camera_x, camera_y);
camera_set_view_size(camera, camera_width, camera_height);
camera_set_view_angle(camera, 0);
camera_set_view_speed(camera, -1, -1);
camera_set_view_target(camera, -1);
camera_set_view_border(camera, (camera_width / 2), (camera_height / 2));

// set the camera to a view port
view_enabled = true;
view_index = 0;
view_set_camera(view_index, camera);
view_set_visible(view_index, true);

// set the size of the view port
view_set_wport(view_index, window_width);
view_set_hport(view_index, window_height);

// set the view ports position
view_set_xport(view_index, 0);
view_set_yport(view_index, 0);


/**
 * Presets
 *
 */

if (false)
{
    sim_x = 27 * global.TILE_SIZE;
    sim_y = 13 * global.TILE_SIZE;
    move_angle = -10;
    move_distance = 40;
    
    // update the camera position
    camera_x = (global.TILE_SIZE * 22);
    camera_y = (global.TILE_SIZE * 5);
    camera_set_view_pos(camera, camera_x, camera_y);
}

if (false)
{
    sim_x = 5 * global.TILE_SIZE;
    sim_y = 5 * global.TILE_SIZE;
    move_angle = -10;
    move_distance = 40;
    
    // update the camera position
    camera_x = (global.TILE_SIZE * 0);
    camera_y = (global.TILE_SIZE * 0);
    camera_set_view_pos(camera, camera_x, camera_y);
}

if (true)
{
    sim_x = 27 * global.TILE_SIZE;
    sim_y = 4 * global.TILE_SIZE;
    move_angle = -10;
    move_distance = 40;
    
    // update the camera position
    camera_x = (global.TILE_SIZE * 22);
    camera_y = (global.TILE_SIZE * -4);
    camera_set_view_pos(camera, camera_x, camera_y);
}
