/// @function scr_simulation_19_create()


/**
 * Globals for Helper Function
 *
 */

object_entity = obj_simulation_19_entity;
script_tile_definitions = scr_simulation_19_create_tiles;


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

// include tile definitions
script_execute(script_tile_definitions);


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
    instance_create_layer(pos_x, pos_y, instances_layer_id, object_entity);
}
*/

var pos_x = (room_width / 2);
var pos_y = (room_height / 2);
var _player = instance_create_layer(pos_x, pos_y, instances_layer_id, object_entity);
//camera_set_view_target(camera, _player);

