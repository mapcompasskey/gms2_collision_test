/// @function scr_simulation_1_step()


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
    sim_x -= 1;
    update_simulation = true;
}
else if (keyboard_check_pressed(ord("D")))
{
    sim_x += 1;
    update_simulation = true;
}

if (keyboard_check_pressed(ord("W")))
{
    sim_y -= 1;
    update_simulation = true;
}
else if (keyboard_check_pressed(ord("S")))
{
    sim_y += 1;
    update_simulation = true;
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
 * Need a smarter way to find these points so there is no overlap.
 */

var temp_list = ds_list_create();

// if moving right
if (move_h > 0)
{
    // add the top right point
    temp_list = ds_list_create();
    ds_list_add(temp_list, (sim_x + sprite_bbox_right + 1), (sim_y + sprite_bbox_top), 0);
    ds_list_add(bbox_points, temp_list);
    
    // add the bottom right point
    temp_list = ds_list_create();
    ds_list_add(temp_list, (sim_x + sprite_bbox_right + 1), (sim_y + sprite_bbox_bottom + 1), 0);
    ds_list_add(bbox_points, temp_list);
}

// else, if moving left
else if (move_h < 0)
{
    // add the top left point
    temp_list = ds_list_create();
    ds_list_add(temp_list, (sim_x + sprite_bbox_left), (sim_y + sprite_bbox_top), 0);
    ds_list_add(bbox_points, temp_list);
    
    // add the bottom left point
    temp_list = ds_list_create();
    ds_list_add(temp_list, (sim_x + sprite_bbox_left), (sim_y + sprite_bbox_bottom), 0);
    ds_list_add(bbox_points, temp_list);
}

// if moving up
if (move_v < 0)
{
    // add the top left point
    temp_list = ds_list_create();
    ds_list_add(temp_list, (sim_x + sprite_bbox_left), (sim_y + sprite_bbox_top), 1);
    ds_list_add(bbox_points, temp_list);
    
    // add the top right point
    temp_list = ds_list_create();
    ds_list_add(temp_list, (sim_x + sprite_bbox_right), (sim_y + sprite_bbox_top), 1);
    ds_list_add(bbox_points, temp_list);
}

// if moving down
else if (move_v > 0)
{
    // add the bottom left point
    temp_list = ds_list_create();
    ds_list_add(temp_list, (sim_x + sprite_bbox_left), (sim_y + sprite_bbox_bottom + 1), 1);
    ds_list_add(bbox_points, temp_list);
    
    // add the bottom right point
    temp_list = ds_list_create();
    ds_list_add(temp_list, (sim_x + sprite_bbox_right + 1), (sim_y + sprite_bbox_bottom + 1), 1);
    ds_list_add(bbox_points, temp_list);
}


/**
 * Detect Cell Collision
 *
 */

var temp_list;
var x1, y1, x2, y2;
var axis;
var step_h_x, step_h_y;
var step_v_x, step_v_y;
var step_cell_h, step_cell_v;
var distance_h, distance_v;
var distance_delta, distance_target;

var slope = (move_v / move_h);

// iterate through all the points around the bounding box
for (var points_idx = 0; points_idx < ds_list_size(bbox_points); points_idx++)
{
    // get the points around the bounding box
    temp_list = ds_list_find_value(bbox_points, points_idx);
    
    // get the starting position
    x1 = ds_list_find_value(temp_list, 0);
    y1 = ds_list_find_value(temp_list, 1);
    
    // get the target position
    x2 = x1 + move_h;
    y2 = y1 + move_v;
    
    // get the axis to test against
    // 0: horizontal, 1: vertical, 2: both
    axis = ds_list_find_value(temp_list, 2);
    
    // the first point to check horizontally
    step_h_x = x1;
    step_h_y = y1;
    
    // the first point to check vertically
    step_v_x = x1;
    step_v_y = y1;
    
    // if the point is not on a horizontal intersection
    if (x1 mod cell_size != 0)
    {
        // find the closest intersection
        step_h_x = (floor(x1 / cell_size) * cell_size) + (move_h > 0 ? cell_size : 0);
        step_h_y = (slope * (step_h_x - x1)) + y1;
    }
    
    // if the point is not on a vertical intersection
    if (y1 mod cell_size != 0)
    {
        // find the closest intersection
        step_v_y = (floor(y1 / cell_size) * cell_size) + (move_v > 0 ? cell_size : 0);
        step_v_x = ((step_v_y - y1) / slope) + x1;
    }
    
    step_cell_h = false;
    step_cell_v = false;
    
    distance_h = 0;
    distance_v = 0;
    
    distance_delta = 0;
    distance_target = point_distance(x1, y1, x2, y2);
    
    // capture the first cell (the one this point is currently inside)
    //temp_list = ds_list_create();
    //ds_list_add(temp_list, floor(x1 / cell_size) * cell_size, floor(y1 / cell_size) * cell_size);
    //ds_list_add(draw_cells, temp_list);
    
    // if the target distance is greater than zero
    // *otherwise the while loop below would never complete
    if (distance_target > distance_delta)
    {
        // while the currnet distance is less than the target distance
        while (distance_delta < distance_target)
        {
            // if the last test stepped through a horizontal cell
            if (step_cell_h)
            {
                // find the next horizontal cell
                step_h_x = step_h_x + (cell_size * sign(move_h));
                step_h_y = (slope * (step_h_x - x1)) + y1;
            }
            
            // if the last test stepped through a vertical cell
            if (step_cell_v)
            {
                // find the next vertical cell
                step_v_y = step_v_y + (cell_size * sign(move_v));
                step_v_x = ((step_v_y - y1) / slope) + x1;
            }
            
            // get the distances to the next horizontal and vertical cells
            distance_h = point_distance(x1, y1, step_h_x, step_h_y);
            distance_v = point_distance(x1, y1, step_v_x, step_v_y);
            
            // if the horizontal distance is shorter
            if (distance_h < distance_v)
            {
                x1 = step_h_x;
                y1 = step_h_y;
            
                step_cell_h = true;
                step_cell_v = false;
                
                distance_delta += distance_h;
                
                if (distance_delta <= distance_target)
                {
                    temp_list = ds_list_create();
                    ds_list_add(temp_list, x1, y1, collision_h_color);
                    ds_list_add(gui_axis_points, temp_list);
                }
            }
            
            // else, if the vertical distance is shorter
            else if (distance_v < distance_h)
            {
                x1 = step_v_x;
                y1 = step_v_y;
                
                step_cell_h = false;
                step_cell_v = true;
                
                distance_delta += distance_v;
                
                if (distance_delta <= distance_target)
                {
                    temp_list = ds_list_create();
                    ds_list_add(temp_list, x1, y1, collision_v_color);
                    ds_list_add(gui_axis_points, temp_list);
                }
            }
            
            // else, the axis are the same distance
            else
            {
                x1 = step_h_x;
                y1 = step_h_y;
                
                step_cell_h = true;
                step_cell_v = true;
                
                distance_delta += distance_h;
                
                if (distance_delta <= distance_target)
                {
                    temp_list = ds_list_create();
                    ds_list_add(temp_list, x1, y1, collision_hv_color);
                    ds_list_add(gui_axis_points, temp_list);
                }
            }
            
            // if the new distance has not passed the target distance
            if (distance_delta <= distance_target)
            {
                // capture the current cell position
                var cell_x = floor(x1 / cell_size);
                var cell_y = floor(y1 / cell_size);
                
                // offset the horizontal cell if moving in a negative direction
                if (step_cell_h && move_h < 0)
                {
                    cell_x -= 1;
                }
                
                // offset the vertical cell if moving in a negative direction
                if (step_cell_v && move_v < 0)
                {
                    cell_y -= 1;
                }
                
                // capture the cell's position
                temp_list = ds_list_create();
                ds_list_add(temp_list, (cell_x * cell_size), (cell_y * cell_size));
                ds_list_add(draw_cells, temp_list);
                
                /*
                // if horizontal and vertical collision occurred, then the point is directly on the cell's corner
                // *i may not need to test the perpendicular cells since another ray around the bounding should find them
                // *this is probably only requred with a ray that has no other bounding box rays
                if (step_cell_h && step_cell_v)
                {
                    temp_list = ds_list_create();
                    ds_list_add(temp_list, ((cell_x - sign(move_h)) * cell_size), (cell_y * cell_size));
                    ds_list_add(draw_cells, temp_list);    
                    
                    temp_list = ds_list_create();
                    ds_list_add(temp_list, (cell_x * cell_size), ((cell_y - sign(move_v)) * cell_size));
                    ds_list_add(draw_cells, temp_list);  
                }
                */
                
            }
            
        }
        
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

