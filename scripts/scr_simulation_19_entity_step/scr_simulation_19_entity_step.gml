/// @function scr_simulation_19_entity_step()


/**
 * Update Delta Time
 *
 */

tick = global.TICK;


/**
 * Update Movement
 *
 */

if (has_gravity)
{
    // apply gravity
    var _gravity = 500;
    velocity_y += (_gravity * tick);
    
    // reset horizontal velocity
    velocity_x = 0;
    
    // if moving left
    if (keyboard_check(ord("A")))
    {
        velocity_x = -(speed_h);
    }
    // else, if moving right
    else if (keyboard_check(ord("D")))
    {
        velocity_x = speed_h;
    }
    
    // if jumping
    if (keyboard_check_pressed(ord("W")))
    {
        velocity_y = -(speed_v * 4);
        is_jumping = true;
    }
    
    // if jumping
    //if (is_standing && keyboard_check_pressed(ord("W")))
    //{
    //    velocity_y = -(speed_v * 4);
    //    is_jumping = true;
    //}
    
}
else
{
    velocity_x = 0;
    velocity_y = 0;

    if (keyboard_check(ord("A")))
    {
        velocity_x = -(speed_h);
    }
    else if (keyboard_check(ord("D")))
    {
        velocity_x = speed_h;
    }

    if (keyboard_check(ord("W")))
    {
        velocity_y = -(speed_v);
    }
    else if (keyboard_check(ord("S")))
    {
        velocity_y = speed_v;
    }

    // reduce diagonal speed
    if (velocity_x != 0 && velocity_y != 0)
    {
        velocity_x *= 0.70710678118 // sin of 45 degrees
        velocity_y *= 0.70710678118 // cos of 45 degrees
    }
    
}

// store velocities
last_velocity_x = velocity_x;
last_velocity_y = velocity_y;

// the maximum distance to move this step
move_h = (velocity_x * tick);
move_v = (velocity_y * tick);


/**
 * Check for Tile Collision
 *
 */

// reset collision states
collision_h = false;
collision_v = false;
collision_slope = false;
collision_slope_tile_gradient = 0;
collision_floor = false;
collision_ceiling = false;

// the distance to move this step
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
    raycast_collision_floor = false;
    raycast_collision_ceiling = false;
    
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
    
    collision_floor = (collision_floor ? collision_floor : raycast_collision_floor);
    collision_ceiling = (collision_ceiling ? collision_ceiling : raycast_collision_ceiling);
    
    // if colliding with a slope
    if (has_gravity && raycast_collision_slope)
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


/**
 * Update Falling Velocity
 *
 */

/** /
if (has_gravity)
{
    // reset grounded state
    is_standing = false;
    
    // if veritcal collision occurred
    if (collision_v)
    {
        // reset vertical velocity
        velocity_y = 0;
        
        // if entity was falling
        if (move_v > 0)
        {
            // update grounded state
            is_standing = true;
        }
        
    }
    
}
/**/

/**/
if (has_gravity)
{
    // reset grounded state
    is_standing = false;
    
    // if colliding with the floor
    if (collision_floor)
    {
        // reset vertical velocity
        velocity_y = 0;
            
        // update grounded state
        is_standing = true;
    }
        
    // else, if colliding with the ceiling
    else if (collision_ceiling)
    {
        // if rising
        if (velocity_y < 0)
        {
            // reset vertical velocity
            velocity_y = 0;
        }
    }
    
}
/**/


/**
 * Update Position
 *
 */

inst_x += new_move_h;
inst_y += new_move_v;
x = inst_x;
y = inst_y;

// update the camera's position
camera_set_view_pos(camera, x - camera_width_half, y - camera_height_half);

