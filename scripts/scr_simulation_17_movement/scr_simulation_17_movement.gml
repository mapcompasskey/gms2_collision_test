/// @function scr_simulation_17_movement()


/**
 * Update Movement
 *
 */

//var rad = ((move_angle + 360) % 360);
//move_angle_rads = degtorad(rad);

//move_h = move_distance * cos(move_angle_rads);
//move_v = move_distance * sin(move_angle_rads) * -1;

//var rad = ((move_angle + 360) % 360);
//move_angle_rads = degtorad(rad);

if (move_angle < 0)
{
    move_angle = 360 + move_angle;
}
move_angle = (move_angle mod 360);
move_angle_rads = degtorad(move_angle);

move_h = move_distance * cos(move_angle_rads);
move_v = move_distance * sin(move_angle_rads) * -1;

collision_h = false;
collision_v = false;
collision_slope = false;
collision_slope_tile_gradient = 0;


/**
 * Check for Tile Collision and Update Movement Values
 *
 */

/*
new_move_h = 0;
new_move_v = 0;

raycast_next_move_h = move_h;
raycast_next_move_v = move_v;

for (var i = 0; i < 3; i++)
{
    // update the starting position to the point of collision
    raycast_x = inst_x + new_move_h;
    raycast_y = inst_y + new_move_v;
    
    // get the remaining movement
    raycast_move_h = raycast_next_move_h;
    raycast_move_v = raycast_next_move_v;
    
    // reset the raycast collision states
    raycast_collision_h = false;
    raycast_collision_v = false;
    raycast_collision_slope = false;
    
    // perform another a collision test
    script_execute(script_raycast_collision);
    
    // update the new movement values
    new_move_h += raycast_move_h;
    new_move_v += raycast_move_v;
    
    if (raycast_collision_slope)
    {
        collision_h = false;
        collision_v = true;
    }
    else
    {
        // merge collision states
        collision_h = (collision_h ? collision_h : raycast_collision_h);
        collision_v = (collision_v ? collision_v : raycast_collision_v);
    }
    
    // if no collision occurred
    //if ( ! collision_h && ! collision_v) break;
    
    // if horizontal and vertical collision have occurred
    //if (collision_h && collision_v) break;
    
}
*/

raycast_x = inst_x;
raycast_y = inst_y;

raycast_move_h = move_h;
raycast_move_v = move_v;

raycast_collision_h = false;
raycast_collision_v = false;
raycast_collision_slope = false;

// test for collisions
script_execute(script_raycast_collision);

// update the new movement values
new_move_h = raycast_move_h;
new_move_v = raycast_move_v;

// merge collision states
collision_h = raycast_collision_h;
collision_v = raycast_collision_v;

//while ()
//{
    if (collision_slope)
    {
        collision_h = false;
        collision_v = true;
        collision_slope = false;
        
        raycast_x += new_move_h;
        raycast_y += new_move_v;
    
        raycast_move_h = raycast_next_move_h;
        raycast_move_v = raycast_next_move_v;
    
        raycast_collision_h = false;
        raycast_collision_v = false;
        //raycast_collision_slope = false;
    
        // test for collisions
        script_execute(script_raycast_collision);
        
        new_move_h += raycast_move_h;
        new_move_v += raycast_move_v;
    }
//}

/*
if (raycast_collision_slope)
{
    collision_h = false;
    collision_v = true;
    
    raycast_x += new_move_h;
    raycast_y += new_move_v;
    
    raycast_move_h = raycast_next_move_h;
    raycast_move_v = raycast_next_move_v;
    
    raycast_collision_h = false;
    raycast_collision_v = false;
    //raycast_collision_slope = false;

    scr_output(" ");
    scr_output("Test 2");
    script_execute(script_raycast_collision);
    
    new_move_h += raycast_move_h;
    new_move_v += raycast_move_v;
}
else if (collision_h && collision_v)
{
    // done
}
else if (collision_h || collision_v)
{
    raycast_x = x + new_move_h;
    raycast_y = y + new_move_v;
    
    raycast_move_h = raycast_next_move_h;
    raycast_move_v = raycast_next_move_v;
    
    raycast_collision_h = false;
    raycast_collision_v = false;
    raycast_collision_slope = false;
    
    script_execute(script_raycast_collision);
    
    new_move_h += raycast_move_h;
    new_move_v += raycast_move_v;
}
*/

