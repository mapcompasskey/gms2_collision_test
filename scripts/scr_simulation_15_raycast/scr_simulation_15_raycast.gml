/// @function scr_simulation_15_raycast(x1, y1, new_move_list, bbox_width, bbox_height, tilemap, cell_size);
/// @param {number} x1 the starting x position
/// @param {number} y1 the starting y position
/// @param {real} new_move_list the ds_list containing the new move_h and move_v
/// @param {number} bbox_width the object width
/// @param {number} bbox_height the object height
/// @param {real} tilemap the layer tilemap id of the collision layer
/// @param {number} cell_size the size of the tiles


/**
 * Detect Cell Collision
 *
 */

// get the starting position
var start_x = argument0;
var start_y = argument1;

var move_list = argument2;
var move_h = move_list[| 0];
var move_v = move_list[| 1];

var new_move_h = move_h;
var new_move_v = move_v;

var _width = argument3;
var _height = argument4;

var collision_tilemap = argument5;
var cell_size = argument6;

// get the slope
var slope = 0;
if (move_h != 0 && move_v != 0)
{
    slope = (move_v / move_h);
}

// get the target distances
var distance_target = point_distance(0, 0, move_h, move_v);


/**
 * Horizontal Collision Test
 *
 */

if (move_h != 0)
{
    var distance_delta = 0;
    var collision = false;
    
    // the first point to check horizontally
    var step_x = start_x;
    var step_y = start_y;
    
    // if the point is not on a horizontal intersection
    if (step_x mod cell_size != 0)
    {
        // find the closest horizontal intersections
        step_x = floor((floor(step_x / cell_size) * cell_size) + (move_h > 0 ? cell_size : 0));
        if (slope != 0)
        {
            step_y = (slope * (step_x - start_x)) + start_y;
        }
        
    }
    
    // check if a horizontal intersection is even crossed
    if (point_distance(start_x, start_y, step_x, step_y) < distance_target)
    {
        // move along the slope, checking each horizontal intersection
        while (collision == false && distance_delta < distance_target)
        {
            var step_x2 = step_x;
            var step_y2 = step_y;
            
            var distance_delta_2 = 0;
            var distance_target_2 = (_height + 1);
            
            // move along the vertical axis, checking each vertical intersection
            while (collision == false && distance_delta_2 < distance_target_2)
            {
                // find the closest vertical intersection
                if (step_y2 mod cell_size == 0)
                {
                    step_y2 = floor(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
                }
                else
                {
                    step_y2 = floor((floor(step_y2 / cell_size) * cell_size) + (move_v < 0 ? cell_size : 0));
                }
                
                // check collision at this point
                collision = scr_simulation_15_tile_collision(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 0);
                
                // if there was a collision
                if (collision)
                {
                    // update the target distance
                    distance_target = point_distance(0, 0, move_list[| 0], move_list[| 1]);
                }
                else
                {
                    // update the horizontal distance delta
                    distance_delta_2 = point_distance(step_x, step_y, step_x2, step_y2);
                }
                
            }
            
            if ( ! collision)
            {
                // find the next horizontal intersection
                step_x = floor(step_x + (cell_size * sign(move_h)));
                if (slope != 0)
                {
                    step_y = (slope * (step_x - start_x)) + start_y;
                }
                
                // update the distance to the next horizontal cell
                distance_delta = point_distance(start_x, start_y, step_x, step_y);
            }
            
        }
    }
    
}


/**
 * Vertical Collision Test
 *
 */

if (move_v != 0)
{
    var distance_delta = 0;
    var collision = false;
    
    // the first point to check horizontally
    var step_x = start_x;
    var step_y = start_y;
    
    // if the point is not on a vertical intersection
    if (step_y mod cell_size != 0)
    {
        // find the closest vertical intersections
        step_y = floor((floor(step_y / cell_size) * cell_size) + (move_v > 0 ? cell_size : 0));
        if (slope != 0)
        {
            step_x = ((step_y - start_y) / slope) + start_x;
        }
    }
    
    // check if a vertical intersection is even crossed
    if (point_distance(start_x, start_y, step_x, step_y) < distance_target)
    {
        // move along the slope, checking each vertical intersection
        while (collision == false && distance_delta < distance_target)
        {
            var step_x2 = step_x;
            var step_y2 = step_y;
            
            var distance_delta_2 = 0;
            var distance_target_2 = (_width + 1);
            
            // move along the horizontal axis, checking each horizontal intersection
            while (collision == false && distance_delta_2 < distance_target_2)
            {
                // find the closest horizontal intersection
                if (step_x2 mod cell_size == 0)
                {
                    step_x2 = floor(move_h < 0 ? (step_x2 + cell_size) : (step_x2 - cell_size));
                }
                else
                {
                    step_x2 = floor((floor(step_x2 / cell_size) * cell_size) + (move_h < 0 ? cell_size : 0));
                }
                
                // check collision at this point
                collision = scr_simulation_15_tile_collision(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 1);
                
                // if there was a collision
                if (collision)
                {
                    // update the target distance
                    distance_target = point_distance(0, 0, move_list[| 0], move_list[| 1]);
                }
                else
                {
                    // update the horizontal distance delta
                    distance_delta_2 = point_distance(step_x, step_y, step_x2, step_y2);
                }
                
            }
            
            if ( ! collision)
            {
                // find the next vertical intersection
                step_y = floor(step_y + (cell_size * sign(move_v)));
                if (slope != 0)
                {
                    step_x = ((step_y - start_y) / slope) + start_x;
                }
            
                // update the distance to the next vertical cell
                distance_delta = point_distance(start_x, start_y, step_x, step_y);
            }
            
        }
    }
    
}


/**
 * Horizontal Collision Test
 *
 * /

if (move_h != 0)
{
    var distance_delta = 0;
    var collision = false;
    
    // the first point to check horizontally
    var step_x = start_x;
    var step_y = start_y;
    
    // if the point is not on a horizontal intersection
    if (step_x mod cell_size != 0)
    {
        // find the closest horizontal intersections
        step_x = floor((floor(step_x / cell_size) * cell_size) + (move_h > 0 ? cell_size : 0));
        if (slope != 0)
        {
            step_y = (slope * (step_x - start_x)) + start_y;
        }
        
    }
    
    // check if a horizontal intersection is even crossed
    if (point_distance(start_x, start_y, step_x, step_y) < distance_target)
    {
        // move along the slope, checking each horizontal intersection
        while (collision == false && distance_delta < distance_target)
        {
            // check collision at this horizontal intersection
            collision = scr_simulation_15_tile_collision(start_x, start_y, step_x, step_y, move_list, collision_tilemap, cell_size, 0);
        
            // if there was a collision
            if (collision)
            {
                // update the target distance
                distance_target = point_distance(0, 0, move_list[| 0], move_list[| 1]);
            }
        
            else
            {
                var step_x2 = step_x;
                var step_y2 = step_y;
                
                var distance_delta_2 = 0;
                var distance_target_2 = _height + (move_v != 0 ? cell_size : 0) + 1;
                
                // if not already on a vertical intersection
                if (step_y2 mod cell_size != 0)
                {
                    // find the closest vertical intersection
                    step_y2 = floor((floor(step_y2 / cell_size) * cell_size) + (move_v < 0 ? cell_size : 0));
                }
                
                if (move_v != 0)
                {
                    // get the next vertical intersection
                    step_y2 = floor(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
                }
                
                // update the vertical distance delta
                //distance_delta_2 = point_distance(step_x, step_y, step_x2, step_y2);
                
                // move along the vertical axis, checking each vertical intersection
                while (collision == false && distance_delta_2 < distance_target_2)
                {
                    // check collision at this vertical intersection
                    collision = scr_simulation_15_tile_collision(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 0);
                    
                    // get the next vertical intersection
                    step_y2 = floor(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
                    
                    // update the vertical distance delta
                    distance_delta_2 = point_distance(step_x, step_y, step_x2, step_y2);
                }
                
                // find the next horizontal intersection
                step_x = floor(step_x + (cell_size * sign(move_h)));
                if (slope != 0)
                {
                    step_y = (slope * (step_x - start_x)) + start_y;
                }
                
                // update the distance to the next horizontal cell
                distance_delta = point_distance(start_x, start_y, step_x, step_y);
            }
        
        }
    }
    
}


/**
 * Vertical Collision Test
 *
 * /

if (move_v != 0)
{
    var distance_delta = 0;
    var collision = false;
    
    // the first point to check horizontally
    var step_x = start_x;
    var step_y = start_y;
    
    // if the point is not on a vertical intersection
    if (step_y mod cell_size != 0)
    {
        // find the closest vertical intersections
        step_y = floor((floor(step_y / cell_size) * cell_size) + (move_v > 0 ? cell_size : 0));
        if (slope != 0)
        {
            step_x = ((step_y - start_y) / slope) + start_x;
        }
    }
    
    // check if a vertical intersection is even crossed
    if (point_distance(start_x, start_y, step_x, step_y) < distance_target)
    {
        // move along the slope, checking each vertical intersection
        while (collision == false && distance_delta < distance_target)
        {
            // check collision at this vertical intersection
            collision = scr_simulation_15_tile_collision(start_x, start_y, step_x, step_y, move_list, collision_tilemap, cell_size, 1);
            
            // if there was a collision
            if (collision)
            {
                // update the target distance
                distance_target = point_distance(0, 0, move_list[| 0], move_list[| 1]);
            }
            
            else
            {
                var step_x2 = step_x;
                var step_y2 = step_y;
                
                var distance_delta_2 = 0;
                var distance_target_2 = _width + (move_h != 0 ? cell_size : 0) + 1;
                
                // if not already on a horizontal intersection
                if (step_x2 mod cell_size != 0)
                {
                    // find the closest horizontal intersection
                    step_x2 = floor((floor(step_x2 / cell_size) * cell_size) + (move_h < 0 ? cell_size : 0));
                }
                
                if (move_h != 0)
                {
                    // get the next horizontal intersection
                    step_x2 = floor(move_h < 0 ? (step_x2 + cell_size) : (step_x2 - cell_size));
                }
                
                // move along the horizontal axis, checking each horizontal intersection
                while (collision == false && distance_delta_2 < distance_target_2)
                {
                    // check collision at this horizontal intersection
                    collision = scr_simulation_15_tile_collision(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 1);
                    
                    // get the next horizontal intersection
                    step_x2 = floor(move_h < 0 ? (step_x2 + cell_size) : (step_x2 - cell_size));
                    
                    // update the horizontal distance delta
                    distance_delta_2 = point_distance(step_x, step_y, step_x2, step_y2);
                }
                
                // find the next vertical intersection
                step_y = floor(step_y + (cell_size * sign(move_v)));
                if (slope != 0)
                {
                    step_x = ((step_y - start_y) / slope) + start_x;
                }
                
                // update the distance to the next vertical cell
                distance_delta = point_distance(start_x, start_y, step_x, step_y);
            }
        
        }
    }
    
}

