/// @function scr_simulation_18_movement()


/**
 * Get Movement from Angle
 *
 */

if (move_angle < 0)
{
    move_angle = 360 + move_angle;
}
move_angle = (move_angle mod 360);
move_angle_rads = degtorad(move_angle);

// the horizontal and vertical distances to move this step
move_h = move_distance * cos(move_angle_rads);
move_v = move_distance * sin(move_angle_rads) * -1;


/**
 * Check for Tile Collision and Update Movement Values
 *
 */

// reset collision states
collision_h = false;
collision_v = false;
collision_slope = false;
collision_slope_tile_gradient = 0;

// the actual distances that will be moved this step
new_move_h = 0;
new_move_v = 0;

// the distances to move during each collision test
raycast_redirect_move_h = move_h;
raycast_redirect_move_v = move_v;

// track the distance traveled (delta) against the target distance
move_distance_delta = 0;
move_distance_target = point_distance(0, 0, move_h, move_v);

// prevents an infinite while loop
// *this could occur if the value of a floating point falls too low, causing the distance delta to always be less than the target
var i = 0;

// while the distance traveled is less than the target distance
while (move_distance_delta < move_distance_target && i < 5)
{
    // reset the raycast collision states
    raycast_collision_h = false;
    raycast_collision_v = false;
    raycast_collision_slope = false;
    
    // the position to cast the ray from
    raycast_x = inst_x + new_move_h;
    raycast_y = inst_y + new_move_v;
    
    // the distance to cast the ray
    raycast_new_move_h = raycast_redirect_move_h;
    raycast_new_move_v = raycast_redirect_move_v;
    
    // perform a collision test
    script_execute(script_raycast_collision);

    // update the new movement values
    // *if a collision occurred during the raycast script, the values will have been altered
    new_move_h += raycast_new_move_h;
    new_move_v += raycast_new_move_v;
    
    // merge collision states
    collision_h = (collision_h ? collision_h : raycast_collision_h);
    collision_v = (collision_v ? collision_v : raycast_collision_v);
    
    // if colliding with a slope
    if (raycast_collision_slope)
    {
        // only counts as a vertical collision
        collision_h = false;
        collision_v = true;
    }
    
    // if both horizontal and vertical collision have occurred
    // *there is no longer any reason to continue raycasting
    if (collision_h && collision_v)
    {
        break;
    }
    
    // increment step counter
    i++;
    
    // update the distance traveled
    move_distance_delta = point_distance(0, 0, new_move_h, new_move_v);
}

