/// @function scr_simulation_23_entity_step()


/**
 * Update Delta Time
 *
 */

tick = global.TICK;


/**
 * Update Movement Values
 *
 */

if (has_gravity && is_solid)
{
    // apply gravity
    var _gravity = 500;
    velocity_y += (_gravity * tick);
    clamp(velocity_y, -(speed_v * 4), (speed_v * 4));
    
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
 * Check If Solid
 *
 */

// if solid state has changed
if (keyboard_check_released(ord("Q")))
{
    is_solid = !(is_solid);
}

// if not solid, skip collision
if ( ! is_solid)
{
    inst_x += move_h;
    inst_y += move_v;
    x = inst_x;
    y = inst_y;
    
    // update the camera's position
    camera_set_view_pos(camera, x - camera_width_half, y - camera_height_half);
    exit;   
}


/**
 * Reset Collision States and Values
 *
 */

// collision states
collision_h = false;
collision_v = false
collision_floor = false;
collision_ceiling = false;
collision_slope = false;

// raycasting movement values and states
// *updated by the raycasting collision script
raycast_move_h = 0;
raycast_move_v = 0;
raycast_next_move_h = 0;
raycast_next_move_v = 0;
raycast_collision_h = false;
raycast_collision_v = false;
raycast_collision_slope = false;
raycast_collision_floor = false;
raycast_collision_ceiling = false;

// slope collision values and states
// *updated by the raycasting slope collision script
raycast_slope_x = 0;
raycast_slope_y = 0;
raycast_slope_move_h = 0;
raycast_slope_move_v = 0;
raycast_slope_collision_floor = false;
raycast_slope_collision_ceiling = false;
raycast_slope_collision_gradient = 0;


/**
 * Check for Tile Collision
 *
 */

// get the top left position of the instance
var _x = inst_x + sprite_bbox_left;
var _y = inst_y + sprite_bbox_top;

// the total distance to move this step
var _move_h = 0;
var _move_v = 0;

// the distance to test for collision
var _next_move_h = move_h;
var _next_move_v = move_v;

// run the collision script at least "i" times
var _i = 0;
while (_i < 5)
{
    // check for collisions along the path
    script_execute(script_raycast_collision, _x, _y, _next_move_h, _next_move_v);
    
    // update the starting point
    _x += raycast_move_h;
    _y += raycast_move_v;
    
    // update the movement values
    _move_h += raycast_move_h;
    _move_v += raycast_move_v;
    
    // get the remaining distance to test next
    _next_move_h = raycast_next_move_h;
    _next_move_v = raycast_next_move_v;
    
    // merge collision states
    collision_h = (collision_h ? collision_h : raycast_collision_h);
    collision_v = (collision_v ? collision_v : raycast_collision_v);
    collision_floor = (collision_floor ? collision_floor : raycast_collision_floor);
    collision_ceiling = (collision_ceiling ? collision_ceiling : raycast_collision_ceiling);
    
    // if colliding with a slope
    // *only counts as a vertical collision
    if (raycast_collision_slope)
    {
        collision_h = false;
        collision_v = true;
    }
    
    // if both horizontal and vertical collision have occurred
    // *there is no longer any reason to continue raycasting
    if (collision_h && collision_v)
    {
        break;
    }
    
    // if there is no more horizontal or vertical movement to travel
    // *there is no longer any reason to continue raycasting
    if (_next_move_h == 0 && _next_move_v == 0)
    {
        break;
    }
    
    // increment step counter
    _i++;
}


/**
 * Resolve Wall (Floor & Ceiling) Collision
 *
 */

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


/**
 * Update Position
 *
 */

inst_x += _move_h;
inst_y += _move_v;
x = inst_x;
y = inst_y;

// update the camera's position
camera_set_view_pos(camera, x - camera_width_half, y - camera_height_half);

