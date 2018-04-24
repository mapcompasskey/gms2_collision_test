/// @function scr_simulation_5_create()


/**
 * Set Instance Variables
 *
 */

// values
tick = 0;
cell_size = 10;
draw_cell_index = 0;
collision_point_index = 0;

// collision tilemap
collision_tilemap_layer_id = layer_get_id("Collision_Tiles");
collision_tilemap = layer_tilemap_get_id(collision_tilemap_layer_id);

// movement
sim_x = 0;
sim_y = 0;

move_angle = 0;
move_distance = 60;

move_h = 0;
move_v = 0;

new_move_h = 0;
new_move_v = 0;

// states
update_simulation = true;
is_rotating = false;

// colors
collision_h_color = c_orange;
collision_v_color = c_yellow;
collision_hv_color = c_red;
raycast_h_color = c_orange;
raycast_v_color = c_yellow;
raycast_hv_color = c_red;

// drawing
sprite_index = spr_simulation_3;
mask_index = spr_simulation_3;

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
 * DS Lists
 *
 */

bbox_points = ds_list_create();
draw_cells = ds_list_create();
gui_room_axes = ds_list_create();
gui_room_x_axis = ds_list_create();
gui_room_y_axis = ds_list_create();
gui_axis_points = ds_list_create();


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
 * Presets
 *
 */

if (false)
{
    sim_x = 5 * cell_size;
    sim_y = 5 * cell_size;
    
    // update the camera position
    camera_x = (cell_size * -1);
    camera_y = (cell_size * -1);
    camera_set_view_pos(camera, camera_x, camera_y);
}

if (true)
{
    sim_x = 15 * cell_size;
    sim_y = 5 * cell_size;
    move_angle = 225;
    
    // update the camera position
    camera_x = (cell_size * 9);
    camera_y = (cell_size * -1);
    camera_set_view_pos(camera, camera_x, camera_y);
}

if (false)
{
    sim_x = 5 * cell_size;
    sim_y = 14 * cell_size;
    move_angle = 315;
    
    // update the camera position
    camera_x = (cell_size * -1);
    camera_y = (cell_size * 9);
    camera_set_view_pos(camera, camera_x, camera_y);
}

