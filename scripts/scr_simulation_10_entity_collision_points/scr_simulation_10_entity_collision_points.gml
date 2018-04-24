/// @function scr_simulation_10_entity_collision_points()


/**
 * Detect Cell Collision
 *
 */

//var temp_list;
var start_x, start_y;
var step_x, step_y;
var step_axis;
var step_h_x, step_h_y;
var step_v_x, step_v_y;
var distance_h, distance_v;
var distance_delta, distance_target;
var check_h_axis, check_v_axis, check_hv_axis;
var collision;

//var slope = 0;
//if (move_h != 0 && move_v != 0)
//{
//    slope = (move_v / move_h);
//}

//new_move_h = move_h;
//new_move_v = move_v;

//distance_target = point_distance(0, 0, move_h, move_v);

// iterate through all the points around the bounding box
//for (var points_idx = 0; points_idx < ds_list_size(bbox_points); points_idx++)
//{
    // get the points around the bounding box
    //temp_list = ds_list_find_value(bbox_points, points_idx);
    
    // get the bounding box position and test axis
    // 0: horizontal, 1: vertical, 2: both
    //step_x = ds_list_find_value(temp_list, 0);
    //step_y = ds_list_find_value(temp_list, 1);
    //step_axis = ds_list_find_value(temp_list, 2);
    
    var slope = coliision_slope;
    distance_target = collision_distance_target;
    step_x = collision_x1;
    step_y = collision_y1;
    step_axis = collision_axis;

    // get the starting position 
    start_x = step_x;
    start_y = step_y;
    
    // the first point to check horizontally
    step_h_x = step_x;
    step_h_y = step_y;
    
    //scr_output((step_x mod cell_size), (step_x & ~7));
    
    // if the point is not on a horizontal intersection
    if (step_x mod cell_size != 0)
    {
        // find the closest horizontal intersections
        //step_h_x = floor((floor(step_x / cell_size) * cell_size) + (move_h > 0 ? cell_size : 0));
        step_h_x = (step_x & ~not_cell_size) + (move_h > 0 ? cell_size : 0);
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
        //step_v_y = floor((floor(step_y / cell_size) * cell_size) + (move_v > 0 ? cell_size : 0));
        step_v_y = (step_y & ~not_cell_size) + (move_v > 0 ? cell_size : 0);
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
            scr_output()
            
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
    
//}

