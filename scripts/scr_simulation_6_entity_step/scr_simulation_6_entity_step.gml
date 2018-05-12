/// @function scr_simulation_6_entity_step()


/**
 * Update Delta Time
 *
 */

var tick = global.TICK;


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

// if not moving
if (move_h == 0 && move_v == 0)
{
    exit;
}

// get new move values
new_move_h = move_h;
new_move_v = move_v;
new_move_list[| 0] = new_move_h;
new_move_list[| 1] = new_move_v;

// the bounding box x position
var _x1 = (x + sprite_bbox_right + 1);
if (move_h < 0)
{
    _x1 = (x + sprite_bbox_left);
}

// the bounding box y position
var _y1 = (y + sprite_bbox_bottom + 1);
if (move_v < 0)
{
    _y1 = (y + sprite_bbox_top);
}

// raycast for tile collision
scr_simulation_6_entity_raycast(_x1, _y1, new_move_list, collision_tilemap, tile_size, bbox_width, bbox_height, false);

// update new move values
new_move_h = new_move_list[| 0];
new_move_v = new_move_list[| 1];


/**
 * Update Directional Collision State
 *
 * This is used to determine if the entity was falling and has hit the floor and is now grounded.
 * Can also be used to tell entities they have struck a wall and need to turn around.
 * /

// reset collision states
collision_h = false;
collision_v = false;

// if the horizontal movement changed
if (new_move_h != move_h)
{
    // if the new horizontal point is on an intersection
    if ((_x1 + new_move_h) mod tile_size == 0)
    {
        collision_h = true;
        velocity_x = -(velocity_x);
    }
}

// if the vertical movement changed
if (new_move_v != move_v)
{
    // if the new vertical point is on an intersection
    if ((_y1 + new_move_v) mod tile_size == 0)
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

