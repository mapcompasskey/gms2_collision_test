/// @function scr_simulation_16_raycast(x1, y1, new_move_list, bbox_width, bbox_height, tilemap, cell_size);
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
    
    // if the point is not on a horizontal intersection
    remainder_x = step_x mod cell_size;
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
    while (distance_delta < distance_target)
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
        
        while (distance_delta_2 < distance_target_2)
        {
            // capture the cell
            var _list = ds_list_create();
            ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            
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
    
    /*
    // if the first horizontal point is within the target distance
    if (distance_delta < distance_target)
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
        
        while (distance_delta_2 < distance_target_2)
        {
            // capture the step point
            var _list = ds_list_create();
            ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            
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
        
    }
    */
    
    /** /
    // check if a horizontal intersection is even crossed
    while (distance_delta < distance_target)
    {
        // find the cell this point occupies
        var cell_x = round(step_x / cell_size);
        var cell_y = floor(step_y / cell_size);
        
        // if moving left
        if (move_h < 0)
        {
            cell_x = cell_x - 1;
        }
        
        // if the point is on a vertical intersection
        if (step_y mod cell_size == 0)
        {
            // if there is no slope or moving up
            if (slope == 0 || move_v < 0)
            {
                cell_y = cell_y - 1;
            }
        }
        
        // capture the step point
        var _list = ds_list_create();
        ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
        ds_list_add(global.GUI_AXIS_POINTS, _list);
        ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        ds_list_add(global.DRAW_CELLS, _list);
        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
        
        // get the distance from the step position to the cell
        var distance_delta_2 = point_distance(0, step_y, 0, (cell_y * cell_size));
        
        // set the target height
        var distance_target_2 = (_height + 1);
        
        // if moving up and the y position is on a vertical axis
        if (move_v < 0 && step_y mod cell_size == 0)
        {
            // offset the target height with an additional cell
            distance_target_2 += cell_size;
        }
        
        // if the distance is less than the bounding box height
        while (distance_delta_2 < distance_target_2)
        {
            // capture the next vertical intersection along the horizontal bounding box
            cell_x = cell_x;
            
            if (move_v >= 0)
            {
                cell_y = cell_y - 1;
            }
            else
            {
                cell_y = cell_y + 1;
            }
        
            // capture the step point
            var _list = ds_list_create();
            ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            
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
    /**/
    
    
    /** /
    // update the distance from the starting point
    var distance_delta = point_distance(start_x, start_y, step_x, step_y);
    
    // check if a horizontal intersection is even crossed
    while (distance_delta < distance_target)
    {
        // find the cell this point occupies
        var cell_x = round(step_x / cell_size);
        var cell_y = floor(step_y / cell_size);
        
        // if moving left
        if (move_h < 0)
        {
            cell_x = cell_x - 1;
        }
        
        // if the point is on a vertical intersection
        if (step_y mod cell_size == 0)
        {
            // if there is no slope or moving up
            if (slope == 0 || move_v < 0)
            {
                cell_y = cell_y - 1;
            }
        }
        
        // capture the step point
        var _list = ds_list_create();
        ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
        ds_list_add(global.GUI_AXIS_POINTS, _list);
        ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        ds_list_add(global.DRAW_CELLS, _list);
        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
        
        // get the distance from the step position to the cell
        var distance_delta_2 = point_distance(0, step_y, 0, (cell_y * cell_size));
        
        // set the target height
        var distance_target_2 = (_height + 1);
        if (move_v < 0)
        {
            // offset the target height with an additional cell
            distance_target_2 += cell_size;
        }
        
        // if the distance is less than the bounding box height
        if (distance_delta_2 < distance_target_2)
        {
            // capture the next vertical intersection along the horizontal bounding box
            cell_x = cell_x;
            
            if (move_v >= 0)
            {
                cell_y = cell_y - 1;
            }
            else
            {
                cell_y = cell_y + 1;
            }
        
            // capture the step point
            var _list = ds_list_create();
            ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            
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
    /**/
    
    /** /
    // check if a horizontal intersection is even crossed
    if (distance_delta < distance_target)
    {
        var step_x2 = step_x;
        var step_y2 = step_y;
        
        // find the cell this point occupies
        var cell_x = round(step_x2 / cell_size);
        var cell_y = floor(step_y2 / cell_size);
        
        // if moving left
        if (move_h < 0)
        {
            cell_x = cell_x - 1;
        }
        
        // if the point is on a vertical intersection
        if (step_y2 mod cell_size == 0)
        {
            // if there is no slope or moving up
            if (slope == 0 || move_v < 0)
            {
                cell_y = cell_y - 1;
            }
        }
        
        // capture the step point
        var _list = ds_list_create();
        ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
        ds_list_add(global.GUI_AXIS_POINTS, _list);
        ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        ds_list_add(global.DRAW_CELLS, _list);
        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
        
        
        
        var distance_delta_2 = point_distance(0, step_y2, 0, (cell_y * cell_size));
        var distance_target_2 = (_height + 1);
        if (move_v < 0)
        {
            distance_target_2 += cell_size;
        }
        
        if (distance_delta_2 < distance_target_2)
        {
            // capture the next vertical intersection along the horizontal bounding box
            cell_x = cell_x;
            
            if (move_v >= 0)
            {
                cell_y = cell_y - 1;
            }
            else
            {
                cell_y = cell_y + 1;
            }
        
            // capture the step point
            var _list = ds_list_create();
            ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            
            distance_delta_2 += cell_size;
        }
        
    }
    /**/
    
    /*
    // check if a horizontal intersection is even crossed
    while (distance_delta < distance_target)
    {
        // capture the step point
        var _list = ds_list_create();
        ds_list_add(_list, step_x, step_y, global.COLLISION_H_COLOR);
        ds_list_add(global.GUI_AXIS_POINTS, _list);
        ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        
        var step_x2 = step_x;
        var step_y2 = step_y;
        
        // find the cell this point occupies
        var cell_x = round(step_x2 / cell_size);
        var cell_y = floor(step_y2 / cell_size);
        
        // if moving left
        if (move_h < 0)
        {
            cell_x = cell_x - 1;
        }
        
        // if the point is on a vertical intersection
        if (step_y2 mod cell_size == 0)
        {
            // if there is no slope or moving up
            if (slope == 0 || move_v < 0)
            {
                cell_y = cell_y - 1;
            }
        }
        
        // capture the cell
        var _list = ds_list_create();
        ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
        ds_list_add(global.DRAW_CELLS, _list);
        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
        
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
    */
    
    /*
    // check if a horizontal intersection is even crossed
    if (distance_delta < distance_target)
    {
        // capture the step point
        var _list = ds_list_create();
        ds_list_add(_list, step_x, step_y, global.COLLISION_H_COLOR);
        ds_list_add(global.GUI_AXIS_POINTS, _list);
        ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        
        var step_x2 = step_x;
        var step_y2 = step_y;
        
        // find the cell
        var cell_x = round(step_x2 / cell_size);
        var cell_y = floor(step_y2 / cell_size);
        
        // if moving left
        if (move_h < 0)
        {
            cell_x = cell_x - 1;
        }
        
        // if the point is on a vertical intersection
        if (step_y2 mod cell_size == 0)
        {
            // if there is no slope or moving up
            if (slope == 0 || move_v < 0)
            {
                cell_y = cell_y - 1;
            }
        }
        
        // capture the cell
        var _list = ds_list_create();
        ds_list_add(_list, (cell_x * cell_size), (cell_y * cell_size), global.COLLISION_H_COLOR);
        ds_list_add(global.DRAW_CELLS, _list);
        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
    }
    */
    
}


/**
 * Horizontal Collision Test
 *
 * /

if (move_h != 0)
{
    var distance_delta = 0;
    var collision = false;
    var remainder_x = 0;
    var remainder_y = 0;
    
    // the first point to check horizontally
    var step_x = start_x;
    var step_y = start_y;
    
    // if the point is not on a horizontal intersection
    remainder_x = step_x mod cell_size;
    if (remainder_x != 0)
    {
        // if to the right of the 0 x-axis
        if (remainder_x > 0)
        {
            // step towards the next horizontal intersection
            step_x = round(step_x - remainder_x + (move_h > 0 ? cell_size : 0));
        }
        // else, if to the left of the 0 x-axis
        else
        {
            step_x = round(step_x - remainder_x - (move_h > 0 ? 0 : cell_size));
        }
        
        if (slope != 0)
        {
            step_y = (slope * (step_x - start_x)) + start_y;
        }
        
    }
    
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
            
            // get the distance from a vertical intersection
            remainder_y = step_y2 mod cell_size;
            
            // if the point is not on a vertical intersection
            if (remainder_y != 0)
            {
                // move towards the next vertical intersection
                step_y2 = round(step_y2 - remainder_y + (move_v < 0 ? cell_size : 0));
            }
            // else, if the point is on a vertical intersection
            else
            {
                // step the distance of a cell
                step_y2 = round(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
                // need to check whether remainder_y is +/-
            }
                
            // move away from the line, checking each vertical intersection
            while (collision == false && distance_delta_2 < distance_target_2)
            {
                // check collision at this point
                collision = scr_simulation_16_tile_collision(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 0);
                
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
    
    var remainder_x = 0;
    var remainder_y = 0;
    
    // if the point is not on a horizontal intersection
    remainder_x = step_x mod cell_size;
    if (remainder_x != 0)
    {
        // step towards the next horizontal intersection
        if (remainder_x > 0)
        {
            step_x = round(step_x - remainder_x + (move_h > 0 ? cell_size : 0));
        }
        else
        {
            step_x = round(step_x - remainder_x - (move_h > 0 ? 0 : cell_size));
        }
        
        if (slope != 0)
        {
            step_y = (slope * (step_x - start_x)) + start_y;
        }
        
    }
    
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
            
            if (move_v != 0)
            {
                // if this point is already on a horizontal/vertical intersection
                if (step_x2 mod cell_size == 0 && step_y2 mod cell_size == 0)
                {
                    collision = scr_simulation_16_tile_collision(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 0);
                }
            }
            
            // move along the vertical axis, checking each vertical intersection
            while (collision == false && distance_delta_2 < distance_target_2)
            {
                // find the closest vertical intersection
                remainder_y = step_y2 mod cell_size;
                if (remainder_y == 0)
                {
                    step_y2 = round(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
                }
                else
                {
                    if (remainder_y > 0)
                    {
                        step_y2 = round(step_y2 - remainder_y + (move_v < 0 ? cell_size : 0));
                    }
                    else
                    {
                        step_y2 = round(step_y2 - remainder_y - (move_v < 0 ? 0 : cell_size));
                    }
                }
                
                // check collision at this point
                collision = scr_simulation_16_tile_collision(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 0);
                
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
        step_y = round((floor(step_y / cell_size) * cell_size) + (move_v > 0 ? cell_size : 0));
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
                    step_x2 = round(move_h < 0 ? (step_x2 + cell_size) : (step_x2 - cell_size));
                }
                else
                {
                    step_x2 = round((floor(step_x2 / cell_size) * cell_size) + (move_h < 0 ? cell_size : 0));
                }
                
                // check collision at this point
                collision = scr_simulation_16_tile_collision(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 1);
                
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
                step_y = round(step_y + (cell_size * sign(move_v)));
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

