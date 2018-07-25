/// @function scr_simulation_18_create()


/**
 * Scripts and Names
 *
 */

simulation_name = "Simulation 18";
script_movement = scr_simulation_18_movement;
script_raycast_collision = scr_simulation_18_raycast_2;
script_slope_collision = scr_simulation_18_slope;


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


/**
 * Tiles
 *
 * The tiles are named for the side or direction that cannot be passed through.
 * The numbers "_45" and "_22" refer to the angle of the slope of the tile (22 is actually 22.5 degrees).
 * The additional "_1" and "_2" refer to multiple tiles that make up a single slope and should always be used together.
 */

global.TILE_SIZE = 10;
global.TILE_SOLID = 1;

// one sided
global.TILE_SOLID_WEST = 2;  //  --|
global.TILE_SOLID_EAST = 3;  // |--
global.TILE_SOLID_SOUTH = 4; // ---
global.TILE_SOLID_NORTH = 5; // ___

// 45 degress
global.TILE_SOLID_45_SE = 10; // ◢
global.TILE_SOLID_45_SW = 30; // ◣
global.TILE_SOLID_45_NE = 20; // ◥
global.TILE_SOLID_45_NW = 40; // ◤

// 22 degress
global.TILE_SOLID_22_SE_1 = 11; // ◢
global.TILE_SOLID_22_SE_2 = 12; // ◢

global.TILE_SOLID_22_SW_1 = 31; // ◣
global.TILE_SOLID_22_SW_2 = 32; // ◣

global.TILE_SOLID_22_NE_1 = 21; // ◥
global.TILE_SOLID_22_NE_2 = 22; // ◥

global.TILE_SOLID_22_NW_1 = 41; // ◤
global.TILE_SOLID_22_NW_2 = 42; // ◤


/**
 * Sloped Tiles Information
 *
 * The gradient is the slope (m) of the tile.
 *
 * The cosine of the angle is used to determine the new x position along the slope to redirect the movement.
 * Then the line equation "y = mx + b" is used to find the new y position.
 * When trying to apply the sine of 22.5 degrees to determine the new y position, it was always off for some reason.
 *
 * The tile's x1 and y1 refer to the left most offset inside the tile the line starts from.
 * The tile's x2 and y2 refer to the right most offset inside the tile that the line ends at.
 * Where (0, 0) is the top left, (1, 1) is the bottom right, and (1, 0.5) is the left middle point of a tile when multiplied by the tile size.
 *
 * The bounding box of the object testing for collision needs to be offset so that the point closest to a slope is tested.
 * The position is always reset to the top left corner of the bounding box and the offset of its width and height are added accordingly.
 * Where (0, 0) is the top left and (1, 1) is the bottom right of the bounding box.
 *
 * The "sign of the determinant" is used to determine if a point is on the open or solid side of a sloped tile.
 *
 * 0: gradient
 * 1: cosine of the angle
 * 2: tile x1
 * 3: tile y1
 * 4: tile x2
 * 5: tile y2
 * 6: bbox width offset
 * 7: bbox height offset
 * 8: sign of the determinant
 */

var _idx = 0;
var _cosine_45 = 0.70710678118; // cosine(45 degrees)
var _cosine_22 = 0.92387953251; // cosine(22.5 degrees)

// 45 degrees, south east ◢
_idx = global.TILE_SOLID_45_SE;
global.TILE_DEFINITIONS[_idx, 0] = -1;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_45;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;

// 45 degrees, north west ◤
_idx = global.TILE_SOLID_45_NW;
global.TILE_DEFINITIONS[_idx, 0] = -1;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_45;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;

// 45 degrees, south west ◣
_idx = global.TILE_SOLID_45_SW;
global.TILE_DEFINITIONS[_idx, 0] = 1;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_45;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;

// 45 degrees, north east ◥
_idx = global.TILE_SOLID_45_NE;
global.TILE_DEFINITIONS[_idx, 0] = 1;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_45;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;

// 22.5 degrees, south east ◢ (1)
_idx = global.TILE_SOLID_22_SE_1;
global.TILE_DEFINITIONS[_idx, 0] = -0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.5;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;

// 22.5 degrees, south east ◢ (2)
_idx = global.TILE_SOLID_22_SE_2;
global.TILE_DEFINITIONS[_idx, 0] = -0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.5;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;

// 22.5 degrees, north west ◤ (1)
_idx = global.TILE_SOLID_22_NW_1;
global.TILE_DEFINITIONS[_idx, 0] = -0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1; 
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.5;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;

// 22.5 degrees, north west ◤ (2)
_idx = global.TILE_SOLID_22_NW_2;
global.TILE_DEFINITIONS[_idx, 0] = -0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.5;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;

// 22.5 degrees, south west ◣ (1)
_idx = global.TILE_SOLID_22_SW_1;
global.TILE_DEFINITIONS[_idx, 0] = 0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.5;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;

// 22.5 degrees, south west ◣ (2)
_idx = global.TILE_SOLID_22_SW_2;
global.TILE_DEFINITIONS[_idx, 0] = 0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.5;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;

// 22.5 degrees, north east ◥ (1)
_idx = global.TILE_SOLID_22_NE_1;
global.TILE_DEFINITIONS[_idx, 0] = 0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.5;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;

// 22.5 degrees, north east ◥ (2)
_idx = global.TILE_SOLID_22_NE_2;
global.TILE_DEFINITIONS[_idx, 0] = 0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.5;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;


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
tile_definitions = global.TILE_DEFINITIONS;

// starting position
inst_x = 0;
inst_y = 0;

// movement angle and distance
move_angle = 0;
move_angle_rads = 0;
move_distance = 60;

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

// slope collision values
raycast_slope_x = 0;
raycast_slope_y = 0;
raycast_slope_move_h = 0;
raycast_slope_move_v = 0;

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

sprite_index = spr_simulation_6px;
mask_index = spr_simulation_6px;

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

// update the camera position
camera_x = inst_x - (camera_width / 2);
camera_y = inst_y - (camera_height / 2);
camera_x = floor(camera_x / global.TILE_SIZE) * global.TILE_SIZE;
camera_y = floor(camera_y / global.TILE_SIZE) * global.TILE_SIZE;
camera_set_view_pos(camera, camera_x, camera_y);
    
    