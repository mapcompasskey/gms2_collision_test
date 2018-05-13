/// @function scr_simulation_7_create()


/**
 * Set Instance Variables
 *
 */

// values
tick = 0;
cell_size = 10;
draw_cell_index = 0;
collision_point_index = 0;

tile_solid = 1;
tile_solid_west = 2;
tile_solid_east = 3;
tile_solid_south = 4;
tile_solid_north = 5;

tile_solid_45_se = 6;
tile_solid_45_sw = 7;
tile_solid_45_ne = 8;
tile_solid_45_nw = 9;

// collision tilemap
collision_tilemap_layer_id = layer_get_id("Collision_Tiles");
collision_tilemap = layer_tilemap_get_id(collision_tilemap_layer_id);

// movement
sim_x = 0;
sim_y = 0;

move_angle = 0;
move_angle_rads = 0;
move_distance = 60;

move_h = 0;
move_v = 0;

new_move_h = 0;
new_move_v = 0;

move_list = ds_list_create();
move_list[| 0] = 0; // horizontal movement
move_list[| 1] = 0; // vertical movement

// collision
collision_h = false;
collision_v = false;

collision_list = ds_list_create();
collision_list[| 0] = false; // horizontal collision
collision_list[| 1] = false; // vertical colission

// states
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

bbox_list = ds_list_create();
bbox_list[| 0] = bbox_width;
bbox_list[| 1] = bbox_height;
bbox_list[| 2] = sprite_bbox_top;
bbox_list[| 3] = sprite_bbox_right;
bbox_list[| 4] = sprite_bbox_bottom;
bbox_list[| 5] = sprite_bbox_left;

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
camera_x = (cell_size * -2);
camera_y = (cell_size * -4);
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
 * Globals for Helper Function
 *
 */

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


/**
 * Presets
 *
 */

if (false)
{
    sim_x = 15 * cell_size;
    sim_y = 15 * cell_size;
    move_angle = 45;
    
    // update the camera position
    camera_x = (cell_size * 10);
    camera_y = (cell_size * 8);
    camera_set_view_pos(camera, camera_x, camera_y);
}

if (false)
{
    sim_x = 27 * cell_size;
    sim_y = 13 * cell_size;
    move_angle = -11;
    move_distance = 40;
    
    // update the camera position
    camera_x = (cell_size * 21);
    camera_y = (cell_size * 7);
    camera_set_view_pos(camera, camera_x, camera_y);
}

if (false)
{
    sim_x = 5 * cell_size;
    sim_y = 5 * cell_size;
    move_angle = -11;
    move_distance = 40;
    
    // update the camera position
    camera_x = (cell_size * 0);
    camera_y = (cell_size * 0);
    camera_set_view_pos(camera, camera_x, camera_y);
}

if (false)
{
    sim_x = 5 * cell_size;
    sim_y = 14 * cell_size;
    move_angle = -11;
    move_distance = 40;
    
    // update the camera position
    camera_x = (cell_size * 0);
    camera_y = (cell_size * 10);
    camera_set_view_pos(camera, camera_x, camera_y);
}

if (true)
{
    sim_x = 3 * cell_size;
    sim_y = 3 * cell_size;
    move_angle = 30;
    move_distance = 40;
    
    // update the camera position
    camera_x = (cell_size * -2);
    camera_y = (cell_size * -2);
    camera_set_view_pos(camera, camera_x, camera_y);
}

