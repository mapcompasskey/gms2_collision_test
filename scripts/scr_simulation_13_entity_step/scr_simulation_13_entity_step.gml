/// @function scr_simulation_13_entity_step()


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

new_move_h = move_h;
new_move_v = move_v;

// if not moving
if (move_h == 0 && move_v == 0)
{
    exit;
}


/**
 * Test Collisions Around Bounding Box
 *
 */

var x1, y1, axis;

var x_sign = 1;
var x_min = (x + sprite_bbox_left);
var x_max = (x + sprite_bbox_right + 1);

var y_sign = 1;
var y_min = (y + sprite_bbox_top);
var y_max = (y + sprite_bbox_bottom + 1);

if (move_h < 0)
{
    x_sign = -1;
    x_min = (x + sprite_bbox_right + 1);
    x_max = (x + sprite_bbox_left);
}

if (move_v < 0)
{
    y_sign = -1;
    y_min = (y + sprite_bbox_bottom + 1);;
    y_max = (y + sprite_bbox_top);
}

// update the movement array
//new_move_arr[@0] = new_move_h;
//new_move_arr[@1] = new_move_v;

new_move_list[| 0] = new_move_h;
new_move_list[| 1] = new_move_v;

// if moving veritcally
if (move_v != 0)
{
    axis = 1;
    
    var x_steps = 1;
    var x_size = abs(x_max - x_min);
    
    // if this side is greater than the cell size
    if (x_size >= cell_size)
    {
        // increase the number of steps
        x_steps = floor(x_size / (cell_size / 2));
    }
    
    // set the horizontal step size
    var x_step_size = (x_size / x_steps);
    
    // minimum x position
    x1 = x_min;
    y1 = y_max;
    
    // update the movement list
    scr_simulation_13_raycast_3(x1, y1, new_move_list, collision_tilemap, cell_size, axis);
    
    // intermediate x positions
    for (var i = 1; i < x_steps; i++)
    {
        x1 = x_min + (x_step_size * i * x_sign)
        y1 = y_max;
        
        // update the movement list
        scr_simulation_13_raycast_3(x1, y1, new_move_list, collision_tilemap, cell_size, axis);
    }
    
}

// if moving horizontally
if (move_h != 0)
{
    axis = 0;
    
    var y_steps = 1;
    var y_size = abs(y_max - y_min);
    
    // if this side is greater than the cell size
    if (y_size >= cell_size)
    {
        // increase the number of steps
        y_steps = floor(y_size / (cell_size / 2));
    }
    
    // set the vertical step size
    var y_step_size = (y_size / y_steps);
    
    // minimum y position
    x1 = x_max;
    y1 = y_min;
    
    // update the movement array
    //scr_simulation_13_raycast_2(x1, y1, new_move_arr, collision_tilemap, cell_size, axis);
    scr_simulation_13_raycast_3(x1, y1, new_move_list, collision_tilemap, cell_size, axis);
    
    // intermediate y positions
    for (var i = 1; i < y_steps; i++)
    {
        x1 = x_max;
        y1 = y_min + (y_step_size * i * y_sign);
        
        // update the movement array
        //scr_simulation_13_raycast_2(x1, y1, new_move_arr, collision_tilemap, cell_size, axis);
        scr_simulation_13_raycast_3(x1, y1, new_move_list, collision_tilemap, cell_size, axis);
    }
    
}

// if moving vertically and horizontally
if (move_h != 0 && move_v != 0)
{
    axis = 2;
}

// else, if only moving vertically
else if (move_v != 0)
{
    axis = 1;
}

// else, if only moving horizontally
else if (move_h != 0)
{
    axis = 0;
}

// maximum x/y position
x1 = x_max;
y1 = y_max;

// update the movement array
//scr_simulation_13_raycast_2(x1, y1, new_move_arr, collision_tilemap, cell_size, axis);
scr_simulation_13_raycast_3(x1, y1, new_move_list, collision_tilemap, cell_size, axis);

// get the new movement distances
//new_move_h = new_move_arr[0];
//new_move_v = new_move_arr[1];

new_move_h = new_move_list[| 0];
new_move_v = new_move_list[| 1];


/**
 * Find Directional Collision State
 *
 * This is used to determine if the entity was falling and has hit the floor and is now grounded.
 * Can also be used to tell entities they have struck and wall and need to turn around.
 *
 * The only problem is the floating point values that can occur from the cosine and sine functions.
 */

// if the horizontal movement changed
collision_h = false;
if (new_move_h != move_h)
{
    // if the horizontal point is on an intersection
    if ((x_max + new_move_h) mod cell_size == 0)
    {
        collision_h = true;
        velocity_x = -(velocity_x);
    }
}

// if the vertical movement changed
collision_v = false;
if (new_move_v != move_v)
{
    // if the vertical point is on an intersection
    if ((y_max + new_move_v) mod cell_size == 0)
    {
        collision_v = true;
        velocity_y = -(velocity_y);
    }
}


/**
 * Update Position
 *
 */

x += new_move_h;
y += new_move_v;

