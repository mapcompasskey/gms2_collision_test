/// @function scr_simulation_22_create()


/**
 * Scripts and Names
 *
 */

simulation_name = "Simulation 18";
script_tile_definitions = scr_simulation_22_create_tiles;
script_movement = scr_simulation_22_movement;
script_raycast_collision = scr_simulation_22_raycast;
script_slope_collision = scr_simulation_22_slope;


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

// include tile definitions
script_execute(script_tile_definitions);


/**
 * Set Instance Variables
 *
 */

// time delta
tick = 0;

// collision tilemap information
collision_tilemap_layer_id = layer_get_id("Collision_Tiles");
collision_tilemap = layer_tilemap_get_id(collision_tilemap_layer_id);
tile_size = global.TILE_SIZE;
sloped_tiles_list = global.SLOPED_TILES_LIST;
tile_definitions = global.TILE_DEFINITIONS;

// tiles
tile_solid = global.TILE_SOLID;
tile_solid_east = global.TILE_SOLID_EAST;
tile_solid_west = global.TILE_SOLID_WEST;
tile_solid_south = global.TILE_SOLID_SOUTH;
tile_solid_north = global.TILE_SOLID_NORTH;

// starting position
inst_x = 0;
inst_y = 0;
inst_x2 = 0;
inst_y2 = 0;

// movement angle and distance
move_angle = 0;
move_angle_rads = 0;
move_distance = 60;

// movement values
move_h = 0;
move_v = 0;

// collision states
collision_h = false;
collision_v = false
collision_slope = false;
collision_slope_tile_gradient = 0;
collision_floor = false;
collision_ceiling = false;

// raycasting movement values
raycast_move_h = 0;
raycast_move_v = 0;
raycast_next_move_h = move_h;
raycast_next_move_v = move_v;

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

// simulation states
update_simulation = true;
is_rotating = false;
has_gravity = false;

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
camera_x = 0;
camera_y = 0;
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
    // 45 degree slopes
    inst_x = 27 * global.TILE_SIZE;
    inst_y = 13 * global.TILE_SIZE;
    move_angle = -10;
    move_distance = 40;
}

if (false)
{
    inst_x =  5 * global.TILE_SIZE + 4;
    inst_y = 20 * global.TILE_SIZE + 4;
    move_angle = -45;
    move_distance = 40;
}

if (true)
{
    // box
    inst_x = 5 * global.TILE_SIZE;
    inst_y = 5 * global.TILE_SIZE;
    move_angle = -45;
    move_distance = 40;
}

if (false)
{
    inst_x = 15 * global.TILE_SIZE;
    inst_y = 5 * global.TILE_SIZE;
    move_angle = -45;
    move_distance = 40;
}

if (false)
{
    inst_x = 26 * global.TILE_SIZE;
    inst_y =  4 * global.TILE_SIZE + 4;
    move_angle = -10;
    move_distance = 40;
}

if (false)
{
    inst_x = -5 * global.TILE_SIZE;
    inst_y = 5 * global.TILE_SIZE + 5;
    move_angle = -180;
    move_distance = 40;
}

if (false)
{
    inst_x = -5 * global.TILE_SIZE;
    inst_y = 5 * global.TILE_SIZE;
    move_angle = -405;
    move_angle = -45;
    move_distance = 40;
}

if (false)
{
    inst_x = 26 * global.TILE_SIZE;
    inst_y = 25 * global.TILE_SIZE;
    move_angle = 315;
    move_distance = 40;
}

if (false)
{
    inst_x = 10 * global.TILE_SIZE;
    inst_y =  6 * global.TILE_SIZE + 4
    move_angle = 315;
    move_distance = 40;
}

if (false)
{
    inst_x =  7 * global.TILE_SIZE;
    inst_y = 32 * global.TILE_SIZE;
    move_angle = 315;
    move_distance = 40;
}

if (false)
{
    inst_x = 38 * global.TILE_SIZE;
    inst_y = 11 * global.TILE_SIZE;
    move_angle = 315;
    move_distance = 40;
}

if (false)
{
    inst_x = 48 * global.TILE_SIZE;
    inst_y = 18 * global.TILE_SIZE;
    move_angle = 315;
    move_distance = 40;
}

if (false)
{
    inst_x = 19 * global.TILE_SIZE;
    inst_y = 21 * global.TILE_SIZE;
    move_angle = 270;
    move_distance = 80;
}

// update the camera position
camera_x = inst_x - (camera_width / 2);
camera_y = inst_y - (camera_height / 2);
camera_x = floor(camera_x / global.TILE_SIZE) * global.TILE_SIZE;
camera_y = floor(camera_y / global.TILE_SIZE) * global.TILE_SIZE;
camera_set_view_pos(camera, camera_x, camera_y);
    
    