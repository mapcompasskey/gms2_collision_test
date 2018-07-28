/// @function scr_simulation_19_create()


/**
 * Globals for Helper Function
 *
 */

show_debug_overlay(true);

// values
global.TICK = 0;

// collision tilemap
collision_tilemap_layer_id = layer_get_id("Collision_Tiles");
global.COLLISION_TILEMAP = layer_tilemap_get_id(collision_tilemap_layer_id);


/**
 * Tiles
 *
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
 * The "sign of the determinant" is used to determine if a point is on the open side of a sloped tile.
 *
 * We only use the cosine of the angle to determine the x position along the slope.
 * When trying to apply the sin of the angle to determine the y position, its always off.
 *
 * 0: gradient
 * 1: cosine of the angle
 * 2: x1
 * 3: y1
 * 4: x2
 * 5: y2
 * 6: offset_x
 * 7: offset_y 
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

// 22 degrees, south east ◢ (1)
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

// 22 degrees, south east ◢ (2)
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

// 22 degrees, north west ◤ (1)
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

// 22 degrees, north west ◤ (2)
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

// 22 degrees, south west ◣ (1)
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

// 22 degrees, south west ◣ (2)
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

// 22 degrees, north east ◥ (1)
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

// 22 degrees, north east ◥ (2)
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

// instances layer
instances_layer_id = layer_get_id("Instances");

// frames per second
fps_timer = 0;
low_fps = 0;
high_fps = 0;


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
global.CAMERA_WIDTH_HALF = (camera_width / 2);
global.CAMERA_HEIGHT_HALF = (camera_height / 2)

// camera offsets
if (camera_width > room_width)
{
    camera_x = -((camera_width - room_width) / 2);
}

if (camera_height > room_height)
{
    camera_y = -((camera_height - room_height) / 2);
}

// create the camera
camera = camera_create();
global.CAMERA = camera;

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
 * Create Entities
 *
 */

/*
var pos_x = (room_width / 2);
var pos_y = (room_height / 2);

for (var i = 0; i < 50; i++)
{
    instance_create_layer(pos_x, pos_y, instances_layer_id, obj_simulation_16_entity);
}
*/

var pos_x = (room_width / 2);
var pos_y = (room_height / 2);
var _player = instance_create_layer(pos_x, pos_y, instances_layer_id, obj_simulation_16_entity);
//camera_set_view_target(camera, _player);

