/// @function scr_simulation_14_raycast_3(x1, y1, new_move_list, bbox_width, bbox_height, tilemap, cell_size);
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
    
    // move along the slope, checking each horizontal intersection
    while (collision == false && distance_delta < distance_target)
    {
        // check collision at this horizontal intersection
        collision = scr_simulation_14_raycast_3_2(start_x, start_y, step_x, step_y, move_list, collision_tilemap, cell_size, 0);
        
        // if there was a collision
        if (collision)
        {
            // update the target distance
            distance_target = point_distance(0, 0, move_list[| 0], move_list[| 1]);
        }
        
        else
        {
            if (1==0) {
            var step_x2 = step_x;
            var step_y2 = step_y;
            var distance_delta_2 = 0;
            
            if (1==0) {
            // if the point is already on a vertical intersection
            if (step_y2 mod cell_size == 0)
            {
                // skip the current step
                //step_y2 = floor(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
            }
            else
            {
                // find the closest vertical intersection
                step_y2 = floor((floor(step_y2 / cell_size) * cell_size) + (move_v < 0 ? cell_size : 0));
                distance_delta_2 = point_distance(step_x, step_y, step_x2, step_y2);
            }
            }
            
            // find the closest vertical intersection
            step_y2 = floor((floor(step_y2 / cell_size) * cell_size) + (move_v < 0 ? cell_size : 0));
            distance_delta_2 = point_distance(step_x, step_y, step_x2, step_y2);
            
            // if the point is not on a vertical intersection
            if (step_y2 mod cell_size == 0)
            {
                // get the next vertical intersection
                step_y2 = floor(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
            }
            }
            
            var step_x2 = step_x;
            var step_y2 = step_y;
            
            var distance_delta_2 = 0;
            var distance_target_2 = (_height + cell_size + 1);
            
            // find the closest vertical intersection
            step_y2 = floor((floor(step_y2 / cell_size) * cell_size) + (move_v < 0 ? cell_size : 0));
            
            // get the next vertical intersection
            step_y2 = floor(move_v < 0 ? (step_y2 + cell_size) : (step_y2 - cell_size));
            
            // update the vertical distance delta
            //distance_delta_2 = point_distance(step_x, step_y, step_x2, step_y2);
            
            // move along the vertical axis, checking each vertical intersection
            while (collision == false && distance_delta_2 < distance_target_2)
            {
                // check collision at this vertical intersection
                collision = scr_simulation_14_raycast_3_2(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 0);
                
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
    if ((move_v > 0 && step_y < (start_y + move_v)) || (move_v < 0 && step_y > (start_y + move_v)))
    {
        // move along the slope, checking each vertical intersection
        while (collision == false && distance_delta < distance_target)
        {
            // check collision at this vertical intersection
            collision = scr_simulation_14_raycast_3_2(start_x, start_y, step_x, step_y, move_list, collision_tilemap, cell_size, 1);
            
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
                
                // find the closest horizontal intersection
                step_x2 = floor((floor(step_x2 / cell_size) * cell_size) + (move_h < 0 ? cell_size : 0));
                
                if (move_h != 0)
                {
                    // get the next horizontal intersection
                    step_x2 = floor(move_h < 0 ? (step_x2 + cell_size) : (step_x2 - cell_size));
                }
                
                // update the horizontal distance delta
                //distance_delta_2 = point_distance(step_x, step_y, step_x2, step_y2);
                
                // move along the horizontal axis, checking each horizontal intersection
                while (collision == false && distance_delta_2 < distance_target_2)
                {
                    // check collision at this horizontal intersection
                    collision = scr_simulation_14_raycast_3_2(start_x, start_y, step_x2, step_y2, move_list, collision_tilemap, cell_size, 1);
                    
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
    
    // check collision at the first horizontal intersection
    collision = scr_simulation_14_raycast_3_2(start_x, start_y, step_x, step_y, move_list, collision_tilemap, cell_size);
    
    // if there wasn't a collision
    if (collision == false)
    {
        // move along the slope, checking each horizontal intersection
        while (collision == false && distance_delta < distance_target)
        {
            collision = scr_simulation_14_raycast_3_2(start_x, start_y, step_x, step_y, move_list, collision_tilemap, cell_size);
            
            // if there was a collision
            if (collision)
            {
                // update the target distance
                distance_target = point_distance(0, 0, move_list[| 0], move_list[| 1]);
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


/**
 * Horizontal Collision Test
 *
 * /

if (move_h != 0)
{
    var distance_delta = 0;
    var collision = false;
    
    // the first point to check horizontally
    var step_h_x = start_x;
    var step_h_y = start_y;
    var step_h_x2 = start_x;
    var step_h_y2 = start_y;
    
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
    
    scr_simulation_14_raycast_3_2(start_x, start_y, step_h_x, step_h_y, move_list, collision_tilemap, cell_size);
    
    // while the current distance is less than the target distance
    // step away towards every horizontal cell that will be crossed by the ray
    while (collision == false && distance_delta < distance_target)
    {
        step_x = step_h_x;
        step_y = step_h_y;
        
        step_h_x2 = step_h_x;
        step_h_y2 = step_h_y;
        
        // if the point is not on a vertical intersection
        if (step_h_y2 mod cell_size != 0)
        {
            // find the next closest vertical intersection
            step_h_y2 = floor((floor(step_h_y2 / cell_size) * cell_size) + (move_v > 0 ? cell_size : 0));
        }
        
        var collision_2 = false;
        var distance_delta_2 = 0;
        
        // step away vertically the height of the bounding box
        while (collision_2 == false && distance_delta_2 < _height)
        {
            step_x2 = step_h_x2;
            step_y2 = step_h_y2;
            
            // record the collision point
            var temp_list = ds_list_create();
            ds_list_add(temp_list, step_x2, step_y2, global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, temp_list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            
            // capture the current cell position
            var cell_x = floor(step_x2 / cell_size);
            var cell_y = floor(step_y2 / cell_size);
            
            // if the horizontal movement is negative and the x position is directly on a cell
            if (move_h < 0 && (step_x2 mod cell_size) == 0)
            {
                // offset the horizontal cell by one
                cell_x -= 1;
            }
            
            // if the vertical movement is negative and the y position is directly on a cell
            if (move_v < 0 && (step_y2 mod cell_size) == 0)
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
                    if (step_x2 < (start_x + new_move_h))
                    {
                        new_move_h = step_x2 - start_x;
                        collision = true;
                    }
                }
                
                else if (move_h < 0)
                {
                    if (step_x2 > (start_x + new_move_h))
                    {
                        new_move_h = step_x2 - start_x;
                        collision = true;
                    }
                }
                
                // update the vertical movement
                if (move_v > 0)
                {
                    if (step_y2 < (start_y + new_move_v))
                    {
                        new_move_v = step_y2 - start_y;
                        collision = true;
                    }
                }
                
                else if (move_v < 0)
                {
                    if (step_y2 > (start_y + new_move_v))
                    {
                        new_move_v = step_y2 - start_y;
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
            step_h_x2 = floor(step_h_x2 + (cell_size * sign(move_h)));
            //if (slope != 0)
            //{
            //    step_h_y2 = (slope * (step_h_x2 - start_x)) + start_y;
            //}
            
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
 * /

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
 * /

// update the ds_list
move_list[| 0] = new_move_h;
move_list[| 1] = new_move_v;
/**/
