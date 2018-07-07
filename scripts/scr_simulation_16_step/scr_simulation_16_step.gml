/// @function scr_simulation_16_step()


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



/**
 * Update the Current and Min/Max FPS
 *
 */

fps_timer += global.TICK
if (fps_timer > 0.5)
{
    var _fps = fps_real;
    
    if (low_fps == 0 || _fps < low_fps)
    {
        low_fps = _fps;
    }
    
    if (high_fps == 0 || _fps > high_fps)
    {
        high_fps = _fps;
    }
    
    fps_timer = 0;
}

