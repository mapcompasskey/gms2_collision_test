/// @function scr_simulation_15_step()


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
 * Update Movement
 *
 */

//var rad = ((move_angle + 360) % 360);
//move_angle_rads = degtorad(rad);

//move_h = move_distance * cos(move_angle_rads);
//move_v = move_distance * sin(move_angle_rads) * -1;

//var rad = ((move_angle + 360) % 360);
//move_angle_rads = degtorad(rad);

if (move_angle < 0)
{
    move_angle = 360 + move_angle;
}
move_angle = (move_angle mod 360);
move_angle_rads = degtorad(move_angle );

move_h = move_distance * cos(move_angle_rads);
move_v = move_distance * sin(move_angle_rads) * -1;

collision_h = false;
collision_v = false;
collision_slope = false;
collision_slope_falling = false;
collision_slope_rising = false;


/**
 * Check for Tile Collision and Update Movement Values
 *
 */

new_move_h = 0;
new_move_v = 0;

raycast_next_move_h = move_h;
raycast_next_move_v = move_v;

for (var i = 0; i < 3; i++)
{
    // update the starting position to the point of collision
    raycast_x = sim_x + new_move_h;
    raycast_y = sim_y + new_move_v;
    
    // get the remaining movement
    raycast_move_h = raycast_next_move_h;
    raycast_move_v = raycast_next_move_v;
    
    // reset the raycast collision states
    raycast_collision_h = false;
    raycast_collision_v = false;
    raycast_collision_slope = false;
    
    // perform another a collision test
    scr_simulation_15_raycast();
    
    // update the new movement values
    new_move_h += raycast_move_h;
    new_move_v += raycast_move_v;
    
    // merge collision states
    collision_h = (collision_h ? collision_h : raycast_collision_h);
    collision_v = (collision_v ? collision_v : raycast_collision_v);
    
    // if no collision occurred
    //if ( ! collision_h && ! collision_v) break;
    
    // if horizontal and vertical collision have occurred
    //if (collision_h && collision_v) break;
    
}
scr_output("---");


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

