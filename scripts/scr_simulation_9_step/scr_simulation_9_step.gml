/// @function scr_simulation_9_step()


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
    global.DRAW_CELL_INDEX++;
    if (global.DRAW_CELL_INDEX >= ds_list_size(global.DRAW_CELLS))
    {
        global.DRAW_CELL_INDEX = 0;
    }
}

// if the "{" key is pressed
else if (keyboard_check_pressed(219))
{
    global.DRAW_CELL_INDEX--;
    if (global.DRAW_CELL_INDEX < 0)
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

//move_list[| 0] = new_move_h;
//move_list[| 1] = new_move_v;


/**
 * Reset the Lists
 *
 */

//ds_list_clear(bbox_points);
ds_list_clear(global.DRAW_CELLS);
ds_list_clear(global.GUI_ROOM_AXES);
ds_list_clear(global.GUI_ROOM_X_AXIS);
ds_list_clear(global.GUI_ROOM_Y_AXIS);
ds_list_clear(global.GUI_AXIS_POINTS);
ds_list_clear(global.GUI_BBOX_POINTS);


/**
 * Check for Tile Collision and Update Movement Values
 *
 */

collision_h = false;
collision_v = false;

// perform a collision test
scr_simulation_9_raycast();


/**
 * Check for Tile Collision and Update Movement Values
 *
 * If the first collision check was successful, redirect the object the remaining distance until another collision occurs.
 */

if (collision_h || collision_v)
{
    // backup the current x/y position
    var _sim_x = sim_x;
    var _sim_y = sim_y;
    
    // backup the original movement values
    var _move_h = move_h;
    var _move_v = move_v;
    
    // backup the updated movement values
    var _new_move_h = new_move_h;
    var _new_move_v = new_move_v;
    
    // backup the updated collison states
    var _collision_h = collision_h;
    var _collision_v = collision_v;
    
    // move to the first collision point
    sim_x = _sim_x + _new_move_h;
    sim_y = _sim_y + _new_move_v;
    
    // add the remaining movement distance
    move_h = (_collision_v ? _move_h - _new_move_h : 0);
    move_v = (_collision_h ? _move_v - _new_move_v : 0);
    
    // add the remaining movement distance
    new_move_h = move_h;
    new_move_v = move_v;
    
    // preform another collision test
    scr_simulation_9_raycast();
    
    // if the first test found a horizontal collision and the second test found a vertical collision but was unable to move up or down, try another straight horizontal test
    // *since horizontal collision is tested first, there is a false positive that occurs when a tile is directly diagonal and the vertical path is blocked but the horizontal path is clear
    if (_collision_h && collision_v && new_move_h == 0 && new_move_v == 0)
    {
        // add the remaining movement distance
        move_h = _move_h - _new_move_h;
        move_v = 0;
        
        // add the remaining movement distance
        new_move_h = move_h;
        new_move_v = move_v;
        
        // we know there was a vertical collision
        _collision_h = false;
        _collision_v = true;
        collision_h = _collision_h;
        collision_v = _collision_v;
        
        // preform another collision test
        scr_simulation_9_raycast();
    }
    
    // add the original updated movement values to the new updated movement values
    new_move_h += _new_move_h;
    new_move_v += _new_move_v;
    
    // reset the x/y point
    sim_x = _sim_x;
    sim_y = _sim_y;
    
    // reset the original movement values
    move_h = _move_h;
    move_v = _move_v;
    
    // update new collision states with the previous ones
    collision_h = (_collision_h ? _collision_h : collision_h);
    collision_v = (_collision_v ? _collision_v : collision_v);
    
}


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

