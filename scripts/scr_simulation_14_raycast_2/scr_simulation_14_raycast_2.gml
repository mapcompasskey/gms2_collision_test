/// @function scr_simulation_14_raycast_2(x1, y1, new_move_list, tilemap, cell_size);
/// @param {number} x1 the starting x position
/// @param {number} y1 the starting y position
/// @param {real} new_move_list the ds_list containing the new move_h and move_v
/// @param {real} tilemap the layer tilemap id of the collision layer
/// @param {number} cell_size the size of the tiles


/**
 * Detect Cell Collision
 *
 */

// get the starting position
var start_x = argument0;
var start_y = argument1;

var step_x = start_x;
var step_y = start_y;

var move_list = argument2;
var move_h = move_list[| 0];
var move_v = move_list[| 1];

var new_move_h = move_h;
var new_move_v = move_v;

var collision_tilemap = argument3;
var cell_size = argument4;

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
    var step_h_x = start_x;
    var step_h_y = start_y;
    
    // if the point is not on a horizontal intersection
    if (start_x mod cell_size != 0)
    {
        // find the closest horizontal intersections
        step_h_x = floor((floor(start_x / cell_size) * cell_size) + (move_h > 0 ? cell_size : 0));
        if (slope != 0)
        {
            step_h_y = (slope * (step_h_x - start_x)) + start_y;
        }
    }
    
    // while the current distance is less than the target distance
    while (collision == false && distance_delta < distance_target)
    {
        step_x = step_h_x;
        step_y = step_h_y;
        
        // record the collision point
        var temp_list = ds_list_create();
        ds_list_add(temp_list, step_x, step_y, global.COLLISION_H_COLOR);
        ds_list_add(global.GUI_AXIS_POINTS, temp_list);
        ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        
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
        var temp_list = ds_list_create();
        ds_list_add(temp_list, (cell_x * cell_size), (cell_y * cell_size));
        ds_list_add(global.DRAW_CELLS, temp_list);
        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
        
        // check tile collision
        var tile_at_point = tilemap_get(collision_tilemap, cell_x, cell_y) & tile_index_mask;
        if (tile_at_point == 1)
        {
            // update the horizontal movement
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
            
            // update the vertical movement
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
            
            // update the target distance
            if (collision)
            {
                distance_target = point_distance(start_x, start_y, (start_x + new_move_h), (start_y + new_move_v));    
            }
            
        }
        
        // find the next horizontal intersection
        step_h_x = floor(step_h_x + (cell_size * sign(move_h)));
        if (slope != 0)
        {
            step_h_y = (slope * (step_h_x - start_x)) + start_y;
        }
        
        // update the distance to the next horizontal cell
        distance_delta += point_distance(step_x, step_y, step_h_x, step_h_y);
        
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
    var step_v_x = start_x;
    var step_v_y = start_y;
    
    // if the point is not on a vertical intersection
    if (start_y mod cell_size != 0)
    {
        // find the closest vertical intersection
        step_v_y = floor((floor(start_y / cell_size) * cell_size) + (move_v > 0 ? cell_size : 0));
        if (slope != 0)
        {
            step_v_x = ((step_v_y - start_y) / slope) + start_x;
        }
    }
    
    // while the current distance is less than the target distance
    while (collision == false && distance_delta < distance_target)
    {
        step_x = step_v_x;
        step_y = step_v_y;
        
        // record the collision point
        var temp_list = ds_list_create();
        ds_list_add(temp_list, step_x, step_y, global.COLLISION_V_COLOR);
        ds_list_add(global.GUI_AXIS_POINTS, temp_list);
        ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        
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
        var temp_list = ds_list_create();
        ds_list_add(temp_list, (cell_x * cell_size), (cell_y * cell_size));
        ds_list_add(global.DRAW_CELLS, temp_list);
        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
        
        // check tile collision
        var tile_at_point = tilemap_get(collision_tilemap, cell_x, cell_y) & tile_index_mask;
        if (tile_at_point == 1)
        {
            // update thehorizontal movemvent
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
            
            // update the vertical movement
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
            
            // update the target distance
            if (collision)
            {
                distance_target = point_distance(start_x, start_y, (start_x + new_move_h), (start_y + new_move_v));
            }
        }
        
        // find the next vertical intersection
        step_v_y = floor(step_v_y + (cell_size * sign(move_v)));
        if (slope != 0)
        {
            step_v_x = ((step_v_y - start_y) / slope) + start_x;
        }
        
        // update the distance to the next veritcal cell
        distance_delta += point_distance(step_x, step_y, step_v_x, step_v_y);
    
    }
    
}


/**
 * Update Values
 *
 */

// update the ds_list
move_list[| 0] = new_move_h;
move_list[| 1] = new_move_v;

