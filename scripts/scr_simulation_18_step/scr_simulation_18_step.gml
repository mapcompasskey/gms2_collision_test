/// @function scr_simulation_18_step()


/**
 * Update Delta Time
 *
 */

// convert the amount of microseconds that have passed since the last step to seconds
//var dt = (1/1000000 * delta_time);

// limit TICK to 8fps: (1 / 1,000,000) * (1,000,000 / 8) = 0.125
//global.TICK = min(0.125, dt);

// using high speed collision detection negates needing to limit frame rate
global.TICK = (1/1000000 * delta_time);

