/// @function scr_simulation_9_entity_step_1()


/**
 * Capture the Starting Points
 *
 */

// reset the bounding box points list
ds_list_clear(bbox_points);

var x_sign = 1;
var x_min = (x + sprite_bbox_left);
var x_max = (x + sprite_bbox_right + 1);

var y_sign = 1;
var y_min = (y + sprite_bbox_top);
var y_max = (y + sprite_bbox_bottom + 1);

var x_size = 0;
var x_step_size = 0;
var x_steps = 0;

var y_size = 0;
var y_step_size = 0;
var y_steps = 0;

if (move_h < 0)
{
    x_sign = -1;
    x_min = (x + sprite_bbox_right + 1);
    x_max = (x + sprite_bbox_left);
}

if (move_v < 0)
{
    y_sign = -1;
    y_min = (y + sprite_bbox_bottom + 1);;
    y_max = (y + sprite_bbox_top);
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
var temp_list;

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
    ds_list_mark_as_list(bbox_points, ds_list_size(bbox_points) - 1);
    
    // intermediate x positions
    for (var i = 1; i < x_steps; i++)
    {
        x1 = x_min + (x_step_size * i * x_sign)
        y1 = y_max;
        
        temp_list = ds_list_create();
        ds_list_add(temp_list, x1, y1, axis);
        ds_list_add(bbox_points, temp_list);
        ds_list_mark_as_list(bbox_points, ds_list_size(bbox_points) - 1);
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
    ds_list_mark_as_list(bbox_points, ds_list_size(bbox_points) - 1);
    
    // intermediate y positions
    for (var i = 1; i < y_steps; i++)
    {
        x1 = x_max;
        y1 = y_min + (y_step_size * i * y_sign);
        
        temp_list = ds_list_create();
        ds_list_add(temp_list, x1, y1, axis);
        ds_list_add(bbox_points, temp_list);
        ds_list_mark_as_list(bbox_points, ds_list_size(bbox_points) - 1);
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
ds_list_mark_as_list(bbox_points, ds_list_size(bbox_points) - 1);


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
                
                if (collision)
                {
                    // update the target distance
                    distance_target = point_distance(start_x, start_y, (start_x + new_move_h), (start_y + new_move_v));
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
        velocity_x = -(velocity_x);
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
        velocity_y = -(velocity_y);
    }
}

