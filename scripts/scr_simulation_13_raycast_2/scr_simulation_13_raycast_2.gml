/// @function scr_simulation_13_raycast(x1, y1, move_arr, tilemap, cell_size, axis)
/// @param {number} x1 the starting x position
/// @param {number} y1 the starting y position
/// @param {real} move_arr the array containing the new move_h and move_v
/// @param {real} tilemap the layer tilemap id of the collision layer
/// @param {number} cell_size the size of the tiles
/// @param {number} axis the axis to check collision against


/**
 * Detect Cell Collision
 *
 */

// get the bounding box position and test axis
var step_x = argument0;
var step_y = argument1;

var move_arr = argument2;
var move_h = move_arr[0];
var move_v = move_arr[1];

var new_move_h = move_h;
var new_move_v = move_v;

var collision_tilemap = argument3;
var cell_size = argument4;

// 0: horizontal, 1: vertical, 2: both
var step_axis = argument5;

// get the slope
var slope = 0;
if (move_h != 0 && move_v != 0)
{
    slope = (move_v / move_h);
}

// the current and target distances
var distance_delta = 0;
var distance_target = point_distance(0, 0, move_h, move_v);

// get the starting position 
var start_x = step_x;
var start_y = step_y;

// the first point to check horizontally
var step_h_x = step_x;
var step_h_y = step_y;

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
var step_v_x = step_x;
var step_v_y = step_y;

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
var distance_h = 0;
var distance_v = 0;

var check_h_axis = false;
var check_v_axis = false;
var check_hv_axis = false;

var collision = false;
    
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
        var tile_at_point = tilemap_get(collision_tilemap, cell_x, cell_y) & tile_index_mask;
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

// return array
//var rtn;
//rtn[1] = new_move_v;
//rtn[0] = new_move_h;
//return rtn;

// update the array directory using accessors
move_arr[@0] = new_move_h;
move_arr[@1] = new_move_v;
//return move_arr;

