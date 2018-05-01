/// @function scr_simulation_17_step()


/**
 * Update Delta Time
 *
 */

// convert the amount of microseconds that have passed since the last step to seconds
var dt = (1/1000000 * delta_time);

// limit TICK to 8fps: (1 / 1,000,000) * (1,000,000 / 8) = 0.125
tick = min(0.125, dt);


/**
 * Zoom
 *
 */

// zoom in on key (+) press
if (keyboard_check_pressed(ord(chr(187))))
{
    view_scale += 1;
    camera_width = (window_width / view_scale);
    camera_height = (window_height / view_scale);
    camera_set_view_size(camera, camera_width, camera_height);
    camera_set_view_border(camera, (camera_width / 2), (camera_height / 2));
    
    update_simulation = true;
}

// zoom out on key (-) press
else if (keyboard_check_pressed(ord(chr(189))))
{
    if (view_scale > 1)
    {
        view_scale -= 1;
        camera_width = (window_width / view_scale);
        camera_height = (window_height / view_scale);
        camera_set_view_size(camera, camera_width, camera_height);
        camera_set_view_border(camera, (camera_width / 2), (camera_height / 2));
        
        update_simulation = true;
    }
}


/**
 * Move Camera
 *
 */
 
if (keyboard_check_pressed(vk_left))
{
    camera_x -= 10;
    update_simulation = true;
}
else if (keyboard_check_pressed(vk_right))
{
    camera_x += 10;
    update_simulation = true;
}

if (keyboard_check_pressed(vk_up))
{
    camera_y -= 10;
    update_simulation = true;
}
else if (keyboard_check_pressed(vk_down))
{
    camera_y += 10;
    update_simulation = true;
}


/**
 * Move Simulation
 *
 */
 
if (keyboard_check_pressed(ord("A")))
{
    if (keyboard_check(vk_shift)) sim_x -= 10;
    else sim_x -= 1;
    update_simulation = true;
}
else if (keyboard_check_pressed(ord("D")))
{
    if (keyboard_check(vk_shift)) sim_x += 10;
    else sim_x += 1;
    update_simulation = true;
}

if (keyboard_check_pressed(ord("W")))
{
    if (keyboard_check(vk_shift)) sim_y -= 10;
    else sim_y -= 1;
    update_simulation = true;
}
else if (keyboard_check_pressed(ord("S")))
{
    if (keyboard_check(vk_shift)) sim_y += 10;
    else sim_y += 1;
    update_simulation = true;
}


/**
 * Update Simulation Angle
 *
 */
 
if (keyboard_check_pressed(ord("Q")))
{
    if (keyboard_check(vk_shift)) move_angle += 10;
    else move_angle += 1;
    update_simulation = true;
}

else if (keyboard_check_pressed(ord("E")))
{
    if (keyboard_check(vk_shift)) move_angle -= 10;
    else move_angle -= 1;
    update_simulation = true;
}

// if holding down the "Q" key for a moment, automatically rotate the move angle
if (keyboard_check(ord("Q")))
{
    if (is_rotating)
    {
        rotation_timer += tick;
        if (rotation_timer > rotation_time)
        {
            if (keyboard_check(vk_shift)) move_angle += 10;
            else move_angle += 1;
            update_simulation = true;
            rotation_timer = 0;
        }
    }
    else
    {
        rotation_pause_timer += tick;
        if (rotation_pause_timer > rotation_pause_time)
        {
            is_rotating = true;
            rotation_pause_timer = 0;
        }
    }
}

// if the "Q" key was released
if (keyboard_check_released(ord("Q")) && is_rotating)
{
    // reset all timers and stop rotating the move angle
    is_rotating = false;
    rotation_timer = 0;
    rotation_pause_timer = 0;
}

// if holding down the "E" key for a moment, automatically rotate the move angle
if (keyboard_check(ord("E")))
{
    if (is_rotating)
    {
        rotation_timer += tick;
        if (rotation_timer > rotation_time)
        {
            if (keyboard_check(vk_shift)) move_angle -= 10;
            else move_angle -= 1;
            update_simulation = true;
            rotation_timer = 0;
        }
    }
    else
    {
        rotation_pause_timer += tick;
        if (rotation_pause_timer > rotation_pause_time)
        {
            is_rotating = true;
            rotation_pause_timer = 0;
        }
    }
}

// if the "E" key was released
if (keyboard_check_released(ord("E")) && is_rotating)
{
    // reset all timers and stop rotating the move angle
    is_rotating = false;
    rotation_timer = 0;
    rotation_pause_timer = 0;
}
    


/**
 * Check Simulation State
 *
 */

// if the "}" key is pressed
if (keyboard_check_pressed(221))
{
    draw_cell_index++;
    if (draw_cell_index >= ds_list_size(draw_cells))
    {
        draw_cell_index = 0;
    }
}

// if the "{" key is pressed
else if (keyboard_check_pressed(219))
{
    draw_cell_index--;
    if (draw_cell_index < 0)
    {
        draw_cell_index = (ds_list_size(draw_cells) - 1);
    }
}


/**
 * Check Simulation State
 *
 */

if ( ! update_simulation)
{
    exit;
}

draw_cell_index = -1;
update_simulation = false;


/**
 * Update Camera
 *
 */

// update the camera position
camera_set_view_pos(camera, camera_x, camera_y);


/**
 * Update Movement
 *
 */

// *if the move angle is 255, dcos and dsin aren't calculating correctly
//move_h = move_distance * dcos(move_angle);
//move_v = move_distance * dsin(move_angle) * -1;

// get the x and y distance to move each step
// *this is also returning values that are slightly off
//move_angle_rads = degtorad(move_angle);
//move_h = move_distance * cos(move_angle_rads);
//move_v = move_distance * sin(move_angle_rads) * -1;

//move_angle = (move_angle mod 360);
//var rad = ((move_angle + 36000) mod 360);
var rad = ((move_angle + 360) % 360);
move_angle_rads = degtorad(rad);
move_h = move_distance * cos(move_angle_rads);
move_v = move_distance * sin(move_angle_rads) * -1;

new_move_h = move_h;
new_move_v = move_v;

new_move_list[| 0] = new_move_h;
new_move_list[| 1] = new_move_v;


/**
 * Reset the Lists
 *
 */

ds_list_clear(bbox_points);
ds_list_clear(draw_cells);
ds_list_clear(gui_room_axes);
ds_list_clear(gui_room_x_axis);
ds_list_clear(gui_room_y_axis);
ds_list_clear(gui_axis_points);
ds_list_clear(gui_bbox_points);


/**
 * Raycast From the Bounding Box Corner
 *
 */

var x_min = (sim_x + sprite_bbox_left);
var x_max = (sim_x + sprite_bbox_right + 1);
if (move_h < 0)
{
    x_min = (sim_x + sprite_bbox_right + 1);
    x_max = (sim_x + sprite_bbox_left);
}

var y_min = (sim_y + sprite_bbox_top);
var y_max = (sim_y + sprite_bbox_bottom + 1);
if (move_v < 0)
{
    y_min = (sim_y + sprite_bbox_bottom + 1);
    y_max = (sim_y + sprite_bbox_top);
}

var x1 = x_max;
var y1 = y_max;

temp_list = ds_list_create();
ds_list_add(temp_list, x1, y1, 2);
ds_list_add(bbox_points, temp_list);
ds_list_mark_as_list(bbox_points, ds_list_size(bbox_points) - 1);


// capture the bounding box rays
temp_list = ds_list_create();
ds_list_add(temp_list, x_max, y_min, 0);
ds_list_add(gui_bbox_points, temp_list);
ds_list_mark_as_list(gui_bbox_points, ds_list_size(gui_bbox_points) - 1);

temp_list = ds_list_create();
ds_list_add(temp_list, x_min, y_max, 1);
ds_list_add(gui_bbox_points, temp_list);
ds_list_mark_as_list(gui_bbox_points, ds_list_size(gui_bbox_points) - 1);

temp_list = ds_list_create();
ds_list_add(temp_list, x_max, y_max, 2);
ds_list_add(gui_bbox_points, temp_list);
ds_list_mark_as_list(gui_bbox_points, ds_list_size(gui_bbox_points) - 1);


/**
 * Update Movement Values
 *
 */

scr_simulation_17_raycast(x1, y1, new_move_list, bbox_width, bbox_height, collision_tilemap, cell_size);

new_move_h = new_move_list[| 0];
new_move_v = new_move_list[| 1];


/**
 * Find Directional Collision State
 *
 * This is used to determine if the entity was falling and has hit the floor and is now grounded.
 * Can also be used to tell entities they have struck a wall and need to turn around.
 *
 * The only problem is the floating point values that can occur from the cosine and sine functions.
 */

// if the horizontal movement changed
collision_h = false;
if (new_move_h != move_h)
{
    // if the horizontal point is on an intersection
    if ((x_max + new_move_h) mod cell_size == 0)
    {
        collision_h = true;
    }
}

// if the vertical movement changed
collision_v = false;
if (new_move_v != move_v)
{
    // if the vertical point is on an intersection
    if ((y_max + new_move_v) mod cell_size == 0)
    {
        collision_v = true;
    }
}


/**
 * Update the GUI Axes
 *
 * Its cheaper to prepare code in the step event than in a draw event.
 */

var temp_list;
var x1, y1;
var x2, y2;
var room_step_x = (cell_size * view_scale);
var room_step_y = (cell_size * view_scale);

// get horizontal lines
x1 = -((camera_x mod cell_size) * view_scale);
y1 = -((camera_y mod cell_size) * view_scale);
x2 = x1 + (camera_width * view_scale);
y2 = y1;

while (y1 < (camera_height * view_scale))
{
    y1 += room_step_y;
    y2 = y1;
    
    temp_list = ds_list_create();
    ds_list_add(temp_list, x1, y1, x2, y2);
    ds_list_add(gui_room_axes, temp_list);
    ds_list_mark_as_list(gui_room_axes, ds_list_size(gui_room_axes) - 1);
}

// get vertical lines
x1 = -((camera_x mod cell_size) * view_scale);
y1 = -((camera_y mod cell_size) * view_scale);
x2 = x1;
y2 = y1 + (camera_height * view_scale);

while (x1 < (camera_width * view_scale))
{
    x1 += room_step_x;
    x2 = x1;
    
    temp_list = ds_list_create();
    ds_list_add(temp_list, x1, y1, x2, y2);
    ds_list_add(gui_room_axes, temp_list);
    ds_list_mark_as_list(gui_room_axes, ds_list_size(gui_room_axes) - 1);
}


/**
 * Update the GUI Axes at Zero
 *
 * Its cheaper to prepare code in the step event than in a draw event.
 */

var x1, y1, x2, y2;

// get the x-axis at zero
x1 = 0;
y1 = 0 - (camera_y * view_scale);
x2 = x1 + (camera_width * view_scale);
y2 = y1;
ds_list_add(gui_room_x_axis, x1, y1, x2, y2);

// get the y-axis at zero
x1 = 0 - (camera_x * view_scale);
y1 = 0;
x2 = x1;
y2 = y1 + (camera_height * view_scale);
ds_list_add(gui_room_y_axis, x1, y1, x2, y2);

