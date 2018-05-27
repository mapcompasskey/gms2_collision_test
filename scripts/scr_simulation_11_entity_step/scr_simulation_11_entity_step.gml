/// @function scr_simulation_11_entity_step()


/**
 * Update Delta Time
 *
 */

tick = global.TICK;


/**
 * Update Movement
 *
 */

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

// store velocities
last_velocity_x = velocity_x;
last_velocity_y = velocity_y;
    
// new x/y positions
move_h = (velocity_x * tick);
move_v = (velocity_y * tick);
new_move_h = move_h;
new_move_v = move_v;

collision_h = false;
collision_v = false;
collision_slope = false;
collision_slope_falling = false;
collision_slope_rising = false;

raycast_x = x;
raycast_y = y;

raycast_slope_x = 0;
raycast_slope_y = 0;

raycast_move_h = move_h;
raycast_move_v = move_v;

raycast_slope_move_h = 0;
raycast_slope_move_v = 0;

raycast_collision_h = false;
raycast_collision_v = false;
raycast_collision_slope = false;


/**
 * Check for Tile Collision and Update Movement Values
 *
 */

// perform a collision test
scr_simulation_11_entity_raycast();

new_move_h = raycast_move_h;
new_move_v = raycast_move_v;

collision_h = raycast_collision_h;
collision_v = raycast_collision_v;
collision_slope = raycast_collision_slope;

// if the collision occurred with a sloped tile
if (collision_slope)
{
    // update the new collision states
    // *there is never horizontal collision with a slope and only veritcal collision if falling onto or rising with a slope
    // *this would be useful in a side scrolling game with gravity
    collision_h = false;
    collision_v = (collision_slope_falling || collision_slope_rising);
    
    // get the updated position at the point of collision
    raycast_x = x + new_move_h;
    raycast_y = y + new_move_v;
    
    // redirect the remaining movement along the path of the slope
    raycast_move_h = raycast_slope_move_h;
    raycast_move_v = raycast_slope_move_v;
    
    // reset the raycast collision states
    raycast_collision_h = false;
    raycast_collision_v = false;
    
    // perform another a collision test
    scr_simulation_11_entity_raycast();
    
    // update the new movement values
    new_move_h += raycast_move_h;
    new_move_v += raycast_move_v;
}

// else, if the collision occurred horizontally or vertically against a flat surface, redirect the object the remaining distance until another collision occurs
else if (collision_h || collision_v)
{
    // get the updated position at the point of collision
    raycast_x = x + new_move_h;
    raycast_y = y + new_move_v;
    
    // redirect the remaining movement either straight horizontal or vertical
    raycast_move_h = (collision_v ? move_h - new_move_h : 0);
    raycast_move_v = (collision_h ? move_v - new_move_v : 0);
    
    // reset the raycast collision states
    raycast_collision_h = false;
    raycast_collision_v = false;
    
    // perform another a collision test
    scr_simulation_11_entity_raycast();
    
    // if the first test found a horizontal collision and the second test found a vertical collision but was unable to move up or down, try another straight horizontal test
    // *since horizontal collision is tested first, there is a false positive that occurs when a tile is directly diagonal and the vertical path is blocked but the horizontal path is clear
    if (collision_h && raycast_collision_v && raycast_move_h == 0 && raycast_move_v == 0)
    {
        // add the remaining movement distance
        raycast_move_h = move_h - new_move_h;
        raycast_move_v = 0;
        
        // we know there was a vertical collision
        collision_h = false;
        collision_v = true;
        raycast_collision_h = collision_h;
        raycast_collision_v = collision_v;
        
        // preform another collision test to find whether the horizontal path is open
        scr_simulation_11_entity_raycast();
    }
    
    // update the new movement values
    new_move_h += raycast_move_h;
    new_move_v += raycast_move_v;
    
    // update the new collision states with the previous ones
    collision_h = (collision_h ? collision_h : raycast_collision_h);
    collision_v = (collision_v ? collision_v : raycast_collision_v);
}


/**
 * Update Position
 *
 */

x += new_move_h;
y += new_move_v;

