/// @function scr_simulation_22_step()


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
 * Move Simulation
 *
 */

if (keyboard_check_pressed(ord("A")))
{
    if (keyboard_check(vk_shift)) inst_x -= 10;
    else inst_x -= 1;
    update_simulation = true;
}
else if (keyboard_check_pressed(ord("D")))
{
    if (keyboard_check(vk_shift)) inst_x += 10;
    else inst_x += 1;
    update_simulation = true;
}

if (keyboard_check_pressed(ord("W")))
{
    if (keyboard_check(vk_shift)) inst_y -= 10;
    else inst_y -= 1;
    update_simulation = true;
}
else if (keyboard_check_pressed(ord("S")))
{
    if (keyboard_check(vk_shift)) inst_y += 10;
    else inst_y += 1;
    update_simulation = true;
}

if (mouse_check_button_pressed(mb_left))
{
    inst_x = round(mouse_x);
    inst_y = round(mouse_y);
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
// *move to the next cell index
if (keyboard_check_pressed(221))
{
    global.DRAW_CELL_INDEX++;
    if (global.DRAW_CELL_INDEX >= ds_list_size(global.DRAW_CELLS))
    {
        global.DRAW_CELL_INDEX = -1;
    }
}

// if the "{" key is pressed
// *move to the previous cell index
else if (keyboard_check_pressed(219))
{
    global.DRAW_CELL_INDEX--;
    if (global.DRAW_CELL_INDEX < -1)
    {
        global.DRAW_CELL_INDEX = (ds_list_size(global.DRAW_CELLS) - 1);
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

global.DRAW_CELL_INDEX = -1;
update_simulation = false;


/**
 * Update Camera
 *
 */

camera_x = inst_x - (camera_width / 2);
camera_y = inst_y - (camera_height / 2);
//camera_x = floor(camera_x / global.TILE_SIZE) * global.TILE_SIZE;
//camera_y = floor(camera_y / global.TILE_SIZE) * global.TILE_SIZE;
camera_set_view_pos(camera, camera_x, camera_y);


/**
 * Reset the Lists
 *
 */

ds_list_clear(global.DRAW_CELLS);
ds_list_clear(global.GUI_DRAW_POINTS);

ds_list_clear(global.GUI_ROOM_AXES);
ds_list_clear(global.GUI_ROOM_X_AXIS);
ds_list_clear(global.GUI_ROOM_Y_AXIS);
ds_list_clear(global.GUI_BBOX_POINTS);


/**
 * Update Movement
 *
 */

script_execute(script_movement);


/**
 * Update the GUI Axes
 *
 * Its cheaper to prepare code in the step event than in a draw event.
 */

var temp_list;
var x1, y1;
var x2, y2;
var room_step_x = (global.TILE_SIZE * view_scale);
var room_step_y = (global.TILE_SIZE * view_scale);

// get horizontal lines
x1 = -((camera_x mod global.TILE_SIZE) * view_scale);
y1 = -((camera_y mod global.TILE_SIZE) * view_scale);
x2 = x1 + (camera_width * view_scale);
y2 = y1;

while (y1 < (camera_height * view_scale))
{
    y1 += room_step_y;
    y2 = y1;
    
    temp_list = ds_list_create();
    ds_list_add(temp_list, x1, y1, x2, y2);
    ds_list_add(global.GUI_ROOM_AXES, temp_list);
    ds_list_mark_as_list(global.GUI_ROOM_AXES, ds_list_size(global.GUI_ROOM_AXES) - 1);
}

// get vertical lines
x1 = -((camera_x mod global.TILE_SIZE) * view_scale);
y1 = -((camera_y mod global.TILE_SIZE) * view_scale);
x2 = x1;
y2 = y1 + (camera_height * view_scale);

while (x1 < (camera_width * view_scale))
{
    x1 += room_step_x;
    x2 = x1;
    
    temp_list = ds_list_create();
    ds_list_add(temp_list, x1, y1, x2, y2);
    ds_list_add(global.GUI_ROOM_AXES, temp_list);
    ds_list_mark_as_list(global.GUI_ROOM_AXES, ds_list_size(global.GUI_ROOM_AXES) - 1);
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
ds_list_add(global.GUI_ROOM_X_AXIS, x1, y1, x2, y2);

// get the y-axis at zero
x1 = 0 - (camera_x * view_scale);
y1 = 0;
x2 = x1;
y2 = y1 + (camera_height * view_scale);
ds_list_add(global.GUI_ROOM_Y_AXIS, x1, y1, x2, y2);

