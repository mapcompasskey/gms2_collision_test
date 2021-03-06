/// @function scr_simulation_1_raycast(x1, y1, new_move_list, bbox_width, bbox_height, tilemap, cell_size);
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

var end_x = (start_x + move_h);
var end_y = (start_y + move_v);

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

// From the Start position, step forward to the next horizontal position and get its Step X and Y.
// At the Step position, move vertically to each vertical intersection until the height of the bounding box is exceeded.
// Then step forward to the next horizontal position and get its Step X and Y.
// Then repeat until the total movement distance is exceeded.

if (move_h != 0)
{
    var distance_delta = 0;
    var collision = false;
    
    // the first point to check horizontally
    var step_x = start_x;
    var step_y = start_y;
    
    // if the point is not on a horizontal intersection
    var remainder_x = step_x mod cell_size;
    if (remainder_x != 0)
    {
        if (remainder_x > 0)
        {
            // step towards the next horizontal intersection
            step_x = round(step_x - remainder_x + (move_h > 0 ? cell_size : 0));
        }
        else
        {
            // step towards the next horizontal intersection
            step_x = round(step_x - remainder_x - (move_h > 0 ? 0 : cell_size));
        }
        
        // if there is slope
        if (slope != 0)
        {
            // find the new y point
            step_y = (slope * (step_x - start_x)) + start_y;
        }
        
    }
    
    // update the distance from the starting point
    var distance_delta = point_distance(start_x, start_y, step_x, step_y);
    
    // if the first horizontal point is within the target distance
    while ( ! collision && distance_delta < distance_target)
    {
        // find the cell this point occupies
        var cell_x = round(step_x / cell_size);
        var cell_y = floor(step_y / cell_size);
        
        // if horizontal movement is negative
        if (move_h < 0)
        {
            cell_x = cell_x - 1;
        }
        
        // if the point is on a vertical intersection
        if (step_y mod cell_size == 0)
        {
            // if there is no slope and the vertical movement is negative
            if (slope == 0 || move_v < 0)
            {
                cell_y = cell_y - 1;
            }
        }
        
        var distance_delta_2 = point_distance(0, step_y, 0, (cell_y * cell_size));
        if (move_v < 0)
        {
            distance_delta_2 = cell_size - distance_delta_2;
        }
        
        var distance_target_2 = (_height + cell_size + 1);
        
        while ( ! collision && distance_delta_2 < distance_target_2)
        {
            // capture the cell
            var _list = ds_list_create();
            ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            
            // check tile collision
            var tile_at_point = tilemap_get(collision_tilemap, cell_x, cell_y) & tile_index_mask;
            if (tile_at_point == 1)
            {
                // update the horizontal movement
                if (move_h > 0)
                {
                    if (step_x < end_x)
                    {
                        collision = true;
                    }
                }
                
                else if (move_h < 0)
                {
                    if (step_x > end_x)
                    {
                        collision = true;
                    }
                }
                
                if (collision)
                {
                    // update the horizontal movement
                    new_move_h = step_x - start_x;
                    end_x = start_x + new_move_h;
                    
                    // update the vertical movement
                    if (move_v > 0)
                    {
                        if (step_y < end_y)
                        {
                            new_move_v = step_y - start_y;
                            end_y = start_y + new_move_v;
                        }
                    }
                    
                    else if (move_v < 0)
                    {
                        if (step_y > end_y)
                        {
                            new_move_v = step_y - start_y;
                            end_y = start_y + new_move_v;
                        }
                    }
                    
                }
                
            }
            
            // capture the next vertical intersection along the horizontal bounding box
            if (move_v >= 0)
            {
                cell_y = cell_y - 1;
            }
            else
            {
                cell_y = cell_y + 1;
            }
            
            distance_delta_2 += cell_size;
        }
        
        // move towards the next horizontal intersection
        step_x = round(step_x + (cell_size * sign(move_h)));
        
        // if there is slope
        if (slope != 0)
        {
            // find the new y point
            step_y = (slope * (step_x - start_x)) + start_y;
        }
        
        // update the distance from the starting point
        distance_delta = point_distance(start_x, start_y, step_x, step_y);
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
    
    // the first point to check vertically
    var step_x = start_x;
    var step_y = start_y;
    
    // if the point is not on a vertical intersection
    var remainder_y = step_y mod cell_size;
    if (remainder_y != 0)
    {
        if (remainder_y > 0)
        {
            // step towards the next vertical intersection
            step_y = round(step_y - remainder_y + (move_v > 0 ? cell_size : 0));
        }
        else
        {
            // step towards the next vertical intersection
            step_y = round(step_y - remainder_y - (move_v > 0 ? 0 : cell_size));
        }
        
        // if there is slope
        if (slope != 0)
        {
            // find the new x point
            step_x = ((step_y - start_y) / slope) + start_x;
        }
        
    }
    
    // update the distance from the starting point
    var distance_delta = point_distance(start_x, start_y, step_x, step_y);
    
    // if the first vertical point is within the target distance
    while ( ! collision && distance_delta < distance_target)
    {
        // find the cell this point occupies
        var cell_x = floor(step_x / cell_size);
        var cell_y = round(step_y / cell_size);
        
        // if vertical movement is negative
        if (move_v < 0)
        {
            cell_y = cell_y - 1;
        }
        
        // if the point is on a horizontal intersection
        if (step_x mod cell_size == 0)
        {
            // if there is no slope and the horizontal movement is negative
            if (slope == 0 || move_h < 0)
            {
                cell_x = cell_x - 1;
            }
        }
        
        var distance_delta_2 = point_distance(step_x, 0, (cell_x * cell_size), 0);
        if (move_h < 0)
        {
            distance_delta_2 = cell_size - distance_delta_2;
        }
        
        var distance_target_2 = (_width + cell_size + 1);
        
        while ( ! collision && distance_delta_2 < distance_target_2)
        {
            // capture the cell
            var _list = ds_list_create();
            ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_V_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            
            // check tile collision
            var tile_at_point = tilemap_get(collision_tilemap, cell_x, cell_y) & tile_index_mask;
            if (tile_at_point == 1)
            {
                // update the vertical movement
                if (move_v > 0)
                {
                    if (step_y < end_y)
                    {
                        collision = true;
                    }
                }
                
                else if (move_v < 0)
                {
                    if (step_y > end_y)
                    {
                        collision = true;
                    }
                }
                
                if (collision)
                {
                    // update the vertical movement
                    new_move_v = step_y - start_y;
                    end_y = start_y + new_move_v;
                    
                    // update the horizontal movement
                    if (move_h > 0)
                    {
                        if (step_x < end_x)
                        {
                            new_move_h = step_x - start_x;
                            end_x = start_x + new_move_h;
                        }
                    }
                    
                    else if (move_h < 0)
                    {
                        if (step_x > end_x)
                        {
                            new_move_h = step_x - start_x;
                            end_x = start_x + new_move_h;
                        }
                    }
                    
                }
                
            }
        
            // capture the next horizontal intersection along the vertical bounding box
            if (move_h >= 0)
            {
                cell_x = cell_x - 1;
            }
            else
            {
                cell_x = cell_x + 1;
            }
            
            distance_delta_2 += cell_size;
        }
        
        // move towards the next vertical intersection
        step_y = round(step_y + (cell_size * sign(move_v)));
        
        // if there is slope
        if (slope != 0)
        {
            // find the new x point
            step_x = ((step_y - start_y) / slope) + start_x;
        }
        
        // update the distance from the starting point
        distance_delta = point_distance(start_x, start_y, step_x, step_y);
    }
    
}


/**
 * Update Values
 *
 */

// update the ds_list
move_list[| 0] = new_move_h;
move_list[| 1] = new_move_v;

