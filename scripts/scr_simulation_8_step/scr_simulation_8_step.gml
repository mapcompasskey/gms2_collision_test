/// @function scr_simulation_8_step()


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


/**
 * Reset the Lists
 *
 */

ds_list_destroy(bbox_points);
ds_list_destroy(draw_cells);
ds_list_destroy(gui_room_axes);
ds_list_destroy(gui_room_x_axis);
ds_list_destroy(gui_room_y_axis);
ds_list_destroy(gui_axis_points);

bbox_points = ds_list_create();
draw_cells = ds_list_create();
gui_room_axes = ds_list_create();
gui_room_x_axis = ds_list_create();
gui_room_y_axis = ds_list_create();
gui_axis_points = ds_list_create();


/**
 * Capture the Starting Points
 *
 */

var x_sign = 1;
var x_min = (sim_x + sprite_bbox_left);
var x_max = (sim_x + sprite_bbox_right + 1);

var y_sign = 1;
var y_min = (sim_y + sprite_bbox_top);
var y_max = (sim_y + sprite_bbox_bottom + 1);

var x_size = 0;
var x_step_size = 0;
var x_steps = 0;

var y_size = 0;
var y_step_size = 0;
var y_steps = 0;

if (move_h < 0)
{
    x_sign = -1;
    x_min = (sim_x + sprite_bbox_right + 1);
    x_max = (sim_x + sprite_bbox_left);
}

if (move_v < 0)
{
    y_sign = -1;
    y_min = (sim_y + sprite_bbox_bottom + 1);;
    y_max = (sim_y + sprite_bbox_top);
}

// if moving horizontally
if (move_h != 0)
{
    y_steps = 1;
    y_size = abs(y_max - y_min);
    
    // if this side is greater than the cell size
    if (y_size >= cell_size)
    {
        // increase the number of steps
        y_steps = floor(y_size / (cell_size / 2));
    }
    
    // set the vertical step size
    y_step_size = (y_size / y_steps);
}

// if moving veritcally
if (move_v != 0)
{
    x_steps = 1;
    x_size = abs(x_max - x_min);
    
    // if this side is greater than the cell size
    if (x_size >= cell_size)
    {
        // increase the number of steps
        x_steps = floor(x_size / (cell_size / 2));
    }
    
    // set the horizontal step size
    x_step_size = (x_size / x_steps);
}


var x1, y1, axis;

// if moving vertically
if (x_steps > 0)
{
    axis = 1;
    
    // minimum x position
    x1 = x_min;
    y1 = y_max;
    
    temp_list = ds_list_create();
    ds_list_add(temp_list, x1, y1, axis);
    ds_list_add(bbox_points, temp_list);
    
    // intermediate x positions
    for (var i = 1; i < x_steps; i++)
    {
        x1 = x_min + (x_step_size * i * x_sign)
        y1 = y_max;
        
        temp_list = ds_list_create();
        ds_list_add(temp_list, x1, y1, axis);
        ds_list_add(bbox_points, temp_list);
    }
    
}

// if moving horizontally
if (y_steps > 0)
{
    axis = 0;
    
    // minimum y position
    x1 = x_max;
    y1 = y_min;
    
    temp_list = ds_list_create();
    ds_list_add(temp_list, x1, y1, axis);
    ds_list_add(bbox_points, temp_list);
    
    // intermediate y positions
    for (var i = 1; i < y_steps; i++)
    {
        x1 = x_max;
        y1 = y_min + (y_step_size * i * y_sign);
        
        temp_list = ds_list_create();
        ds_list_add(temp_list, x1, y1, axis);
        ds_list_add(bbox_points, temp_list);
    }
    
}

// if moving vertically and horizontally
if (x_steps > 0 && y_steps > 0)
{
    axis = 2;
}

// else, if only moving vertically
else if (x_steps > 0)
{
    axis = 1;
}

// else, if only moving horizontally
else if (y_steps > 0)
{
    axis = 0;
}

// maximum x/y position
x1 = x_max;
y1 = y_max;

temp_list = ds_list_create();
ds_list_add(temp_list, x1, y1, axis);
ds_list_add(bbox_points, temp_list);


/**
 * Detect Cell Collision
 *
 */

var temp_list;
var start_x, start_y;
var step_x, step_y;
var step_axis;
var step_h_x, step_h_y;
var step_v_x, step_v_y;
var distance_h, distance_v;
var distance_delta, distance_target;
var check_h_axis, check_v_axis, check_hv_axis
var collision;

var slope = 0;
if (move_h != 0 && move_v != 0)
{
    slope = (move_v / move_h);
}

new_move_h = move_h;
new_move_v = move_v;

distance_target = point_distance(0, 0, move_h, move_v);

// iterate through all the points around the bounding box
for (var points_idx = 0; points_idx < ds_list_size(bbox_points); points_idx++)
{
    // get the points around the bounding box
    temp_list = ds_list_find_value(bbox_points, points_idx);
    
    // get the bounding box position and test axis
    // 0: horizontal, 1: vertical, 2: both
    step_x = ds_list_find_value(temp_list, 0);
    step_y = ds_list_find_value(temp_list, 1);
    step_axis = ds_list_find_value(temp_list, 2);
    
    // get the starting position 
    start_x = step_x;
    start_y = step_y;
    
    // the first point to check horizontally
    step_h_x = step_x;
    step_h_y = step_y;
    
    // if the point is not on a horizontal intersection
    if (step_x mod cell_size != 0)
    {
        // find the closest horizontal intersections
        step_h_x = floor((floor(step_x / cell_size) * cell_size) + (move_h > 0 ? cell_size : 0));
        if (slope != 0)
        {
            step_h_y = (slope * (step_h_x - step_x)) + step_y;
        }
    }
    
    // the first point to check vertically
    step_v_x = step_x;
    step_v_y = step_y;
    
    // if the point is not on a vertical intersection
    if (step_y mod cell_size != 0)
    {
        // find the closest vertical intersection
        step_v_y = floor((floor(step_y / cell_size) * cell_size) + (move_v > 0 ? cell_size : 0));
        if (slope != 0)
        {
            step_v_x = ((step_v_y - step_y) / slope) + step_x;
        }
        
    }
    
    // distance to the axes
    distance_h = 0;
    distance_v = 0;
    
    // the current distance
    distance_delta = 0;
    
    check_h_axis = false;
    check_v_axis = false;
    check_hv_axis = false;
    
    collision = false;
    
    // while the current distance is less than the target distance
    while (collision == false && distance_delta < distance_target)
    {
        // if the last test checked against a horizontal cell
        if (check_h_axis || check_hv_axis)
        {
            // find the next horizontal intersection
            step_h_x = floor(step_h_x + (cell_size * sign(move_h)));
            if (slope != 0)
            {
                step_h_y = (slope * (step_h_x - step_x)) + step_y;
            }
        }
        
        // if the last test checked against a vertical cell
        if (check_v_axis || check_hv_axis)
        {
            // find the next vertical intersection
            step_v_y = floor(step_v_y + (cell_size * sign(move_v)));
            if (slope != 0)
            {
                step_v_x = ((step_v_y - step_y) / slope) + step_x;
            }
        }
        
        // reset collision test states
        check_h_axis = false;
        check_v_axis = false;
        check_hv_axis = false;
        
        // if checking against horizontal axes
        if (step_axis == 0)
        {
            check_h_axis = true;
            
            // get the distance to the next horizontal cell
            distance_h = point_distance(step_x, step_y, step_h_x, step_h_y);
        }
        
        // else, if checking against vertical axes
        else if (step_axis == 1)
        {
            check_v_axis = true;
            
            // get the distance to the next vertical cell
            distance_v = point_distance(step_x, step_y, step_v_x, step_v_y);
        }
        
        // else, if checking against both axes
        else if (step_axis == 2)
        {
            // get the distances to the next horizontal and vertical cells
            distance_h = point_distance(step_x, step_y, step_h_x, step_h_y);
            distance_v = point_distance(step_x, step_y, step_v_x, step_v_y);
            
            // if the horizontal distance is shorter
            if (distance_h < distance_v)
            {
                check_h_axis = true;
            }
                
            // else, if the vertical distance is shorter
            else if (distance_v < distance_h)
            {
                check_v_axis = true;
            }
                
            // else, if they are the same distance
            else
            {
                check_hv_axis = true;
            }
                
        }
        
        // if checking against horizontal axes
        if (check_h_axis)
        {
            // update the position and distance
            step_x = step_h_x;
            step_y = step_h_y;
            distance_delta += distance_h;
        }
        
        // else, if checking against vertical axes
        else if (check_v_axis)
        {
            // update position and distance
            step_x = step_v_x;
            step_y = step_v_y;
            distance_delta += distance_v;
        }
        
        // if checking against both a horizontal and vertical axes
        else if (check_hv_axis)
        {
            // update the position and distance
            step_x = floor(step_h_x);
            step_y = floor(step_v_y);
            distance_delta += distance_h;
        }
        
        // if the new distance has not passed the target distance
        if (distance_delta <= distance_target)
        {
            // record the collision point
            temp_list = ds_list_create();
            if (check_h_axis) ds_list_add(temp_list, step_x, step_y, collision_h_color);
            else if (check_v_axis) ds_list_add(temp_list, step_x, step_y, collision_v_color);
            else ds_list_add(temp_list, step_x, step_y, collision_hv_color);
            ds_list_add(gui_axis_points, temp_list);
            
            // capture the current cell position
            var cell_x = floor(step_x / cell_size);
            var cell_y = floor(step_y / cell_size);
            
            // if the horizontal movement is negative and the x position is directly on a cell
            if (move_h < 0 && (step_x mod cell_size) == 0)
            {
                // offset the horizontal cell by one
                cell_x -= 1;
            }
            
            // if the vertical movement is negative and the y position is directly on a cell
            if (move_v < 0 && (step_y mod cell_size) == 0)
            {
                // offset the vertical cell by one
                cell_y -= 1;
            }
            
            // capture the cell's position
            temp_list = ds_list_create();
            ds_list_add(temp_list, (cell_x * cell_size), (cell_y * cell_size));
            ds_list_add(draw_cells, temp_list);
            
            // check tile collision
            tile_at_point = tilemap_get(collision_tilemap, cell_x, cell_y) & tile_index_mask;
            if (tile_at_point == 1)
            {
                if (move_h > 0)
                {
                    if (step_x < (start_x + new_move_h))
                    {
                        new_move_h = step_x - start_x;
                        collision = true;
                    }
                }
                
                else if (move_h < 0)
                {
                    if (step_x > (start_x + new_move_h))
                    {
                        new_move_h = step_x - start_x;
                        collision = true;
                    }
                }
                
                if (move_v > 0)
                {
                    if (step_y < (start_y + new_move_v))
                    {
                        new_move_v = step_y - start_y;
                        collision = true;
                    }
                }
                
                else if (move_v < 0)
                {
                    if (step_y > (start_y + new_move_v))
                    {
                        new_move_v = step_y - start_y;
                        collision = true;
                    }
                }
                
                if (stop_at_first_collision)
                {
                    if (collision)
                    {
                        // update the target distance
                        distance_target = point_distance(start_x, start_y, (start_x + new_move_h), (start_y + new_move_v));
                    }
                }
                
            }
            
        }
        
    }
    
}


/**
 * Find Directional Collision State
 *
 * This is used to determine if the entity was falling and has hit the floor and is now grounded.
 * Can also be used to tell entities they have struck and wall and need to turn around.
 *
 * The only problem is the floating point values that can occur from the cosine and sine functions.
 */

// if the horizontal movement changed
collision_h = false;
if (new_move_h != move_h)
{
    // if the horizontal point is on an intersection
    if ((start_x + new_move_h) mod cell_size == 0)
    {
        collision_h = true;
    }
}

// if the vertical movement changed
collision_v = false;
if (new_move_v != move_v)
{
    // if the vertical point is on an intersection
    if ((start_y + new_move_v) mod cell_size == 0)
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

