/// @function scr_simulation_16_entity_slope_2(tile_at_point, cell_x, cell_y, ray_gradient, ray_target);
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
var _tile_size = tile_size;


/**
 * Get the Tile's Information
 *
 * The "sign of the determinant" is used to determine if the starting point is on the open side of the sloped tile
 *
 * 0: gradient
 * 1: radians
 * 2: x1
 * 3: y1
 * 4: x2
 * 5: y2
 * 6: offset_x
 * 7: offset_y 
 * 8: sign of the determinant
 */

// if not an array
if ( ! is_array(tile_definitions))
{
    return false;
}

// if this entry of the array does not have the correct length
if (array_length_2d(tile_definitions, _tile_at_point) != 9)
{
    return false;
}

// get the slope value of this angle
var _tile_gradient = tile_definitions[_tile_at_point, 0];

// if the slopes are the same the lines would never cross
// or they are the same line and touch infinity (collinear)
if (_ray_gradient == _tile_gradient)
{
    return;
}

// get the value for the cosine of the angle
var _tile_cosine  = tile_definitions[_tile_at_point, 1] * (_move_h > 0 ? 1 : -1);

// get the first (left most) point on the tile
var _tile_x1 = (_cell_x + tile_definitions[_tile_at_point, 2]) * _tile_size;
var _tile_y1 = (_cell_y + tile_definitions[_tile_at_point, 3]) * _tile_size;
        
// get the second (right most) point on the tile
var _tile_x2 = (_cell_x + tile_definitions[_tile_at_point, 4]) * _tile_size;
var _tile_y2 = (_cell_y + tile_definitions[_tile_at_point, 5]) * _tile_size;

// get the bounding box offsets
// *this is the point on the bounding box that would collide first with the sloped line
var _offset_x = tile_definitions[_tile_at_point, 6] * _width;
var _offset_y = tile_definitions[_tile_at_point, 7] * _height;

// update the starting position
_start_x += _offset_x;
_start_y += _offset_y;


/**
 * Determine the Side of the Tile
 *
 * The "sign of the determinant" is used to determine if the starting and ending points are on the open side of the sloped tile.
 * The ray only need to be redirected if the starting point is on the open side of the tile and the ending point is on the solid side.
 *
 * d = (x - x1)(y2 - y1) - (y - y1)(x2 - x1)
 */

// get the value that represents the side that is "open space'
var _tile_determinant = tile_definitions[_tile_at_point, 8];

// find the side of the tile the starting point is on
var _start_determinant = ((_start_x - _tile_x1) * (_tile_y2 - _tile_y1)) - ((_start_y - _tile_y1) * (_tile_x2 - _tile_x1));

// if the starting point is not on the line
if (_start_determinant != 0)
{
    // if the starting point is not on the open side of the tile
    if (sign(_start_determinant) != _tile_determinant)
    {
        return false;
    }
}

// find the side of the tile the end point is on
var _end_determinant = (((_start_x + _move_h) - _tile_x1) * (_tile_y2 - _tile_y1)) - (((_start_y + _move_v) - _tile_y1) * (_tile_x2 - _tile_x1));

// if the end point is on the open side of the tile
if (sign(_end_determinant) == _tile_determinant)
{
    return false;
}


/**
 * Find the Point of Intersection
 *
 * The following equation to find the intersection of two lines segments was taken from the following page.
 * https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
 */

var _s1_x = _move_h;
var _s1_y = _move_v;

var _s2_x = _tile_x2 - _tile_x1;
var _s2_y = _tile_y2 - _tile_y1;

// if the denominator equals zero the lines would be collinear or never intersect
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

// get the point of intersection
var _xx = _start_x + (_t * _s1_x);
var _yy = _start_y + (_t * _s1_y);

// update the point of collision (minus the offsets)
raycast_slope_x = _xx - _offset_x;
raycast_slope_y = _yy - _offset_y;


/**
 * Redirect the Ray
 *
 * In a side scroller we only care about the horizontal movement along the slope.
 * So only the remaining horizontal distance needs to be redirected.
 *
 * Just use the line equation to find the y position after getting the x position.
 * Using the sin of the angle to find it never seems to put it in the right place.
 *
 * point: (x, y)
 * m: slope
 * b: y-intercept
 * line equation: y = mx + b
 * y-intercept: b = y - mx
 */

// get the y-intercepts of the tile
var _tile_y_intercept = _tile_y1 - (_tile_gradient * _tile_x1);

// get the remaining horizontal distance from the point of collision
var _distance_h = point_distance(_xx, 0, _start_x + _move_h, 0);

// update the movement to rediret along the slope
raycast_slope_move_h = _distance_h * _tile_cosine;
raycast_slope_move_v = ((_tile_gradient * (_xx + raycast_slope_move_h)) + _tile_y_intercept) - _yy;

return true;

