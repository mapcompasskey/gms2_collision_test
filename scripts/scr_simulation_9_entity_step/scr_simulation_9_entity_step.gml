/// @function scr_simulation_9_entity_step()


/**
 * Update Delta Time
 *
 */

var tick = global.TICK;


/**
 * Update Position
 *
 */

// store velocities
last_velocity_x = velocity_x;
last_velocity_y = velocity_y;
    
// new x/y positions
move_h = (velocity_x * tick);
move_v = (velocity_y * tick);

// if not moving
if (move_h == 0 && move_v == 0)
{
    exit;
}


scr_simulation_9_entity_step_1();
//scr_simulation_9_entity_step_2();


/**
 * Update Position
 *
 */

x += new_move_h;
y += new_move_v;

