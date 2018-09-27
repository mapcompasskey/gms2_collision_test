/// @function scr_simulation_22_movement()


/**
 * Update Movement Values
 *
 */

if (move_angle < 0)
{
    move_angle = 360 + move_angle;
}
move_angle = (move_angle mod 360);
move_angle_rads = degtorad(move_angle);

// the maximum distance to move this step
//move_h = (move_distance * cos(move_angle_rads));
//move_v = (move_distance * sin(move_angle_rads) * -1);
move_h = lengthdir_x(move_distance, move_angle);
move_v = lengthdir_y(move_distance, move_angle);


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
scr_output(" ");
scr_output("_x", string_format(_x, 1, 20));
scr_output("_y", string_format(_y, 1, 20));

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
    scr_output(" ");
    scr_output("_x", string_format(_x, 1, 20));
    scr_output("_y", string_format(_y, 1, 20));
    
    // update the movement values
    _move_h += raycast_move_h;
    _move_v += raycast_move_v;
    scr_output("_move_h", string_format(_move_h, 1, 20));
    scr_output("_move_v", string_format(_move_v, 1, 20));
    
    // get the remaining distance to test next
    _next_move_h = raycast_next_move_h;
    _next_move_v = raycast_next_move_v;
    scr_output("_next_move_h", string_format(_next_move_h, 1, 20));
    scr_output("_next_move_v", string_format(_next_move_v, 1, 20));
    
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


// update the end position
inst_x2 = inst_x + _move_h;
inst_y2 = inst_y + _move_v;

