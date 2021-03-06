/// @function scr_simulation_14_slope(tile_at_point, cell_x, cell_y, ray_gradient, ray_target);
/// @param {real} tile_at_point  - the index of the tile that was intersected
/// @param {number} cell_x       - the tile's horizontal cell position
/// @param {number} cell_y       - the tile's vertical cell position
/// @param {number} ray_gradient - the slope of the ray
/// @param {real} ray_target     - the maximum distance that can be traveled


/**
 * Slope Collision
 *
 */

// if there is no movement
if (raycast_move_h == 0 && raycast_move_v == 0)
{
    return false;
}

// get values
var _move_h = raycast_move_h;
var _move_v = raycast_move_v;
var _tile_at_point = argument0;
var _cell_x = argument1;
var _cell_y = argument2;
var _ray_gradient = argument3;
var _ray_target = argument4;

// the starting position (always the top left corner of the bounding box)
var _start_x = raycast_x + sprite_bbox_left;
var _start_y = raycast_y + sprite_bbox_top;

// get the size of the bounding box
var _height = bbox_height + 1;
var _width = bbox_width + 1;

// the tile size
var _tile_size = global.TILE_SIZE;

//var _list = ds_list_create();
//ds_list_add(_list, (_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_H_COLOR);
//ds_list_add(global.GUI_AXIS_POINTS, _list);
//ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);


/**
 * Get the Tile's Information
 *
 * 0: gradient
 * 1: radians
 * 2: x1
 * 3: y1
 * 4: x2
 * 5: y2
 * 6: offset_x
 * 7: offset_y 
 *
 */

// if not an array
if ( ! is_array(tile_definitions))
{
    return false;
}

// if this entry of the array does not have the correct length
if (array_length_2d(tile_definitions, _tile_at_point) != 8)
{
    return false;
}

// get the slope value of this angle
var _tile_gradient = tile_definitions[_tile_at_point, 0];

// if the slopes are the same the lines would never cross, or they could be collinear
if (_ray_gradient == _tile_gradient)
{
    return;
}

// get the value for the radian value of this angle
var _tile_radians  = tile_definitions[_tile_at_point, 1] * (_move_h > 0 ? 1 : -1);

// get the first (left most) position on the tile
var _tile_x1 = (_cell_x + tile_definitions[_tile_at_point, 2]) * _tile_size;
var _tile_y1 = (_cell_y + tile_definitions[_tile_at_point, 3]) * _tile_size;
        
// get the second (right most) position on the tile
var _tile_x2 = (_cell_x + tile_definitions[_tile_at_point, 4]) * _tile_size;
var _tile_y2 = (_cell_y + tile_definitions[_tile_at_point, 5]) * _tile_size;

// get the boudning box offsets
var _offset_x = tile_definitions[_tile_at_point, 6] * _width;
var _offset_y = tile_definitions[_tile_at_point, 7] * _height;

// update the starting position
_start_x += _offset_x;
_start_y += _offset_y;


/**
 * Find the Point of Intersection
 *
 * point: (x, y)
 * m: slope
 * b: y-intercept
 * line equation: y = mx + b
 * y-intercept: b = y - mx
 *
 * The following equation to find the intersection of two lines segments was taken from the following page.
 * https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
 */

var _s1_x = _move_h;
var _s1_y = _move_v;

var _s2_x = _tile_x2 - _tile_x1;
var _s2_y = _tile_y2 - _tile_y1;

// if the denominator equals zero
// *the lines would be collinear or never intersect (I think)
var _denominator = (-_s2_x * _s1_y + _s1_x * _s2_y);
if (_denominator == 0)
{
    return false;
}

var _s = (-_s1_y * (_start_x - _tile_x1) + _s1_x * (_start_y - _tile_y1)) / _denominator;
if (_s < 0 || _s > 1)
{
    return false;
}

var _t = ( _s2_x * (_start_y - _tile_y1) - _s2_y * (_start_x - _tile_x1)) / _denominator;
if (_t < 0 || _t > 1)
{
    return false;
}

var _xx = _start_x + (_t * _s1_x);
var _yy = _start_y + (_t * _s1_y);

// update the point of collision (minus the offsets)
raycast_slope_x = _xx - _offset_x;
raycast_slope_y = _yy - _offset_y;

// update the movement to rediret along the slope
// *in a top down game, horizontal and veritcal distances are treated equally, so the distance remaining needs to be redirected
//var _radians = degtorad(_tile_degrees);
//raycast_slope_move_h = (_ray_target - _distance) * cos(_radians);
//raycast_slope_move_v = (_ray_target - _distance) * sin(_radians) * -1;

// update the movement to rediret along the slope
// *in a side scroller, we only care about the horizontal movement along the slope, so only the remaining horizontal distance needs to be redirected
//var _distance_h = abs(_start_x + _move_h - _xx);
//var _radians = degtorad(_tile_degrees);
//raycast_slope_move_h = _distance_h * cos(_radians);
//raycast_slope_move_v = _distance_h * sin(_radians) * -1; <---- THIS DOESN'T APPEAR TO CALCULATE THE CORRECT Y POSITION WITH 22 DEGREES

// update the movement to rediret along the slope
// *in a side scroller, we only care about the horizontal movement along the slope, so only the remaining horizontal distance needs to be redirected
// *just use the line equation to find the y position
//raycast_slope_move_h = (_ray_target - _distance) * _tile_radians;
//var temp_x = _xx + raycast_slope_move_h;
//var temp_y = (_tile_gradient * temp_x) + _b2;
//raycast_slope_move_v = temp_y - _yy;

// capture the point on the slope where collision occurred
var _list = ds_list_create();
ds_list_add(_list, _xx, _yy, global.COLLISION_SLOPE_COLOR);
ds_list_add(global.GUI_AXIS_POINTS, _list);
ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);

return true;

