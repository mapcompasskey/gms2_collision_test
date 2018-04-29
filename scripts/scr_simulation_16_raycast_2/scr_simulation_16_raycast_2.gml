/// @function scr_simulation_16_raycast_2(x1, y1, new_move_list, bbox_width, bbox_height, tilemap, cell_size);
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
    
    var remainder_x = 0;
    var remainder_y = 0;
    /*
    // if the point is not on a horizontal intersection
    remainder_x = step_x mod cell_size;
    if (remainder_x != 0)
    {
        // find the horizontal intersection
        step_x = round(step_x - remainder_x + (move_h > 0 ? cell_size : 0));
        if (slope != 0)
        {
            step_y = (slope * (step_x - start_x)) + start_y;
        }
        
    }
    */
    // check if a horizontal intersection is even crossed
    if (point_distance(start_x, start_y, step_x, step_y) < distance_target)
    {
        // move along the line, checking each horizontal intersection
        while (collision == false && distance_delta < distance_target)
        {
            var step_x2 = step_x;
            var step_y2 = step_y;
            
            var distance_delta_2 = 0;
            var distance_target_2 = (_height + 1);
            /*
            if (move_v != 0)
            {
                // if this point is already on a horizontal/vertical intersection
                if (step_x2 mod cell_size == 0 && step_y2 mod cell_size == 0)
                {
                    collision = scr_simulation_16_tile_collision(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 0);
                }
            }
            */
            // move along the vertical axis, checking each vertical intersection
            while (collision == false && distance_delta_2 < distance_target_2)
            {
                /*
                // find the closest vertical intersection
                remainder_y = step_y2 mod cell_size;
                if (remainder_y == 0)
                {
                    step_y2 = round(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
                }
                else
                {
                    step_y2 = round(step_y2 - remainder_y + (move_v < 0 ? cell_size : 0));
                }
                */
                
                // check collision at this point
                collision = scr_simulation_16_tile_collision_2(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 0);
                
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
                    
                    step_y2 = round(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
                }
                
            }
            
            if ( ! collision)
            {
                // find the next horizontal intersection
                step_x = round(step_x + (cell_size * sign(move_h)));
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

