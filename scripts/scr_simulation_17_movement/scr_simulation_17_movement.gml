/// @function scr_simulation_17_movement()


/**
 * Update Movement
 *
 */



// update movement values







/**
 * Check for Tile Collision and Update Movement Values
 *
 */

// update movement values
if (move_angle < 0)
{
    move_angle = 360 + move_angle;
}
move_angle = (move_angle mod 360);
move_angle_rads = degtorad(move_angle);

// the horizontal and vertical distances to move this step
move_h = move_distance * cos(move_angle_rads);
move_v = move_distance * sin(move_angle_rads) * -1;

// the collision free distance to move this step
new_move_h = 0;
new_move_v = 0;

// the distance to check for collisions
raycast_new_move_h = 0;
raycast_new_move_v = 0;
raycast_redirect_move_h = move_h;
raycast_redirect_move_v = move_v;

// reset collision states
collision_h = false;
collision_v = false;
collision_slope = false;
collision_slope_tile_gradient = 0;

// track the distance traveled (delta) against the target distance
move_distance_delta = 0;
move_distance_target = point_distance(0, 0, move_h, move_v);

// prevent an infinite loop from occurring in the event the distance delta is always less than the target
// *this could occur if the value of a floating point falls to low
var i = 0;

// whle the distance traveled is less than the target distance
while (move_distance_delta < move_distance_target && i < 5)
{
    // get the position to start the raycast from
    raycast_x = inst_x + new_move_h;
    raycast_y = inst_y + new_move_v;
    
    // update the raycast movement values
    raycast_new_move_h = raycast_redirect_move_h;
    raycast_new_move_v = raycast_redirect_move_v;
    
    // reset the raycast collision states
    raycast_collision_h = false;
    raycast_collision_v = false;
    raycast_collision_slope = false;
    
    // perform another a collision test
    script_execute(script_raycast_collision);
    
    // update the new movement values
    new_move_h += raycast_new_move_h;
    new_move_v += raycast_new_move_v;
    
    // merge collision states
    collision_h = raycast_collision_h;
    collision_v = raycast_collision_v;
    
    // if both horizontal and vertical collision
    if (collision_h && collision_v)
    {
        break;
    }
    
    // increment step counter
    i++;
    
    // update the distance traveled
    move_distance_delta = point_distance(0, 0, new_move_h, new_move_v);
}

