/// @function scr_simulation_22_slope(x, y, move_h, move_v, tile_at_point, cell_x, cell_y, ray_gradient, ray_target);
/// @param {number} x            - the x position to start
/// @param {number} y            - the y position to start
/// @param {real} tile_at_point  - the index of the tile that was intersected
/// @param {number} cell_x       - the tile's horizontal cell position
/// @param {number} cell_y       - the tile's vertical cell position
/// @param {number} ray_gradient - the slope of the ray
/// @param {real} ray_target     - the maximum distance that can be traveled


/**
 * Slope Collision
 *
 * point: (x, y)
 * m: slope
 * b: y-intercept
 *
 * line equation: y = mx + b
 * y-intercept: b = y - mx
 * slope: (y2 - y1) / (x2 - x1)
 *
 * Instead of creating and returning an array every time this script is called, it relies on the instance calling it to have a number of variables that can be read and updated.
 *
 * Instance Variables to Read:
 *  boolean     has_gravity
 *  number      bbox_width
 *  number      bbox_height
 *  number      tile_size
 *  real        sloped_tiles_list
 *  real        tile_definitions
 *
 * Instance Variables to Update:
 *  number      raycast_slope_x
 *  number      raycast_slope_y
 *  number      raycast_slope_move_h
 *  number      raycast_slope_move_v
 *  boolean     raycast_slope_collision_floor
 *  boolean     raycast_slope_collision_ceiling
 *  number      raycast_slope_collision_gradient
 *
 * The "has_gravity" value stores the state of how the instance interacts with collision tiles.
 * The "bbox_width" and "bbox_height" values store the size of the bounding box of the instance calling this script. 
 * The "tile_size" value stores the size in pixels of the tiles in the collision tilemap.
 * The "sloped_tiles_list" value points to the ds_list containing all the indexes for sloped tiles.
 * The "tile_definintions" value points to the multidimensional array containing all the information about the sloped tiles.
 *
 * The point (raycast_slope_x, raycast_slope_y) stores the coordinate where collision occurrs.
 * The "raycast_slope_move_h" and "raycast_slope_move_v" values represent the remaining distance to redirect the ray after a collision.
 * The "raycast_slope_collision_floor" and "raycast_slope_collision_ceiling" values store the type of tile the collision occurred with.
 * The "raycast_slope_collision_gradient" value stores the gradient of the tile. Its used to prevent consecutive checks against the same type of tile.
 *
 * Instances with gravity could represent a side scrolling game in which only the horizontal movement and direction should be maintained when moving along a slope.
 * Instances without gravity could represent a top down game in which the angle and total distance need to be used when redirecting along a slope.
 */

// the starting position
// *should always be the top left corner of the bounding box
var _start_x = argument0;
var _start_y = argument1;

var _new_move_h = argument2;
var _new_move_v = argument3;

if (_new_move_h == 0 && _new_move_v == 0)
{
    return false;
}

var _tile_at_point = argument4;
var _cell_x = argument5;
var _cell_y = argument6;

var _ray_gradient = argument7;
var _ray_target = argument8;

// get the size of the bounding box
var _width = bbox_width + 1;
var _height = bbox_height + 1;

// the tile size
var _tile_size = tile_size;

if (false)
{
    var _list = ds_list_create();
    ds_list_add(_list, (_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_AXIS_POINTS, _list);
    ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
}


/**
 * Get the Tiles Information
 *
 * The gradient is the slope (m) of the tile.
 *
 * The cosine of the angle is used to determine the new x position along the slope to redirect the movement.
 * Then the line equation "y = mx + b" is used to find the new y position.
 * When trying to apply the sine of 22.5 degrees to determine the new y position, it was always off for some reason.
 *
 * The tile's x1 and y1 refer to the left most offset inside the tile the line starts from.
 * The tile's x2 and y2 refer to the right most offset inside the tile that the line ends at.
 * Where (0, 0) is the top left, (1, 1) is the bottom right, and (1, 0.5) is the right middle point of a tile when multiplied by the tile size.
 *
 * The bounding box of an instance needs to be offset so that the point closest to a slope is tested.
 * The position is always reset to the top left corner of the bounding box and the offset of its width and height are added accordingly.
 * Where (0, 0) is the top left and (1, 1) is the bottom right of the bounding box.
 *
 * The "sign of the determinant" is used to determine if a point is on the open or solid side of a sloped tile.
 * This value needs to represent the side that is "open space".
 *
 * 0: gradient
 * 1: cosine of the angle
 * 2: tile x1
 * 3: tile y1
 * 4: tile x2
 * 5: tile y2
 * 6: bbox width offset
 * 7: bbox height offset
 * 8: 0: ceiling tile, 1: floor tile
 * 9: sign of the determinant
 */

// if this is not a sloped tile
if (ds_list_find_index(sloped_tiles_list, _tile_at_point) == -1)
{
    return false;
}

// if not an array
if ( ! is_array(tile_definitions))
{
    return false;
}

// if this entry of the array does not have the correct length
if (array_length_2d(tile_definitions, _tile_at_point) != 10)
{
    return false;
}

// get the slope value of this angle
var _tile_gradient = tile_definitions[_tile_at_point, 0];

// if the slopes are the same the lines would never cross
// or they are the same line and touch infinity (collinear)
if (_ray_gradient == _tile_gradient)
{
    return false;
}

// if this tile's slope is the same as one already collided against
if (_tile_gradient == raycast_slope_collision_gradient)
{
    return false;
}

// get the value for the cosine of the angle
var _tile_cosine  = tile_definitions[_tile_at_point, 1] * (_new_move_h > 0 ? 1 : -1);

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
 * The "sign of the determinant" is used to determine if the starting and ending points are on the "open" or "solid" sides of the sloped tile.
 * Normally, the ray only needs to be redirected if the starting point is on the open side of the tile and the ending point is on the solid side.
 * But that relies on the floating point math to be extremely precise, which shouldn't be assumed.
 * Instead, just magnitize the instance to the slope unless the instance is attempting to move away from the slope (like if it was jumping).
 * You can determine if its leaving the slope because the "end determinant" will equal the side of the tile that is open space.
 *
 * d = (x - x1)(y2 - y1) - (y - y1)(x2 - x1)
 */

// default state is to stick to the slope
var _sticky = true;

// get whether this type of tile is considered a floor or ceiling
var _is_floor_tile = tile_definitions[_tile_at_point, 8];

// if this instance is always falling
if (has_gravity)
{
    // if the instance is moving up while on a floor tile
    if (_new_move_v < 0 && _is_floor_tile == 1)
    {
        // if ◢ tile (gradient is negative)
        if (sign(_tile_gradient) == -1)
        {
            // if not moving horizontally or moving to the left
            if (_new_move_h == 0 || _new_move_h < 0)
            {
                // the instance is for sure leaving the slope
                return false;
            }
            
            // else, if moving to the right
            else if (_new_move_h > 0)
            {
                // the instance is attempting to leave the slope
                _sticky = false;
            }
        }
        
        // else, if ◣ tile (gradient is positive)
        else if (sign(_tile_gradient) == 1)
        {
            // if not moving horizontally or moving to the right
            if (_new_move_h == 0 || _new_move_h > 0)
            {
                // the instance is for sure leaving the slope
                return false;
            }
            
            // else, if moving to the left
            else if (_new_move_h < 0)
            {
                // the instance is attempting to leave the slope
                _sticky = false;
            }
        }
        
    }
    
    // if this is a "ceiling" tile
    if ( ! _is_floor_tile)
    {
        _sticky = false;
    }
    
}

// if this instance has no graivty
if ( ! has_gravity)
{
    _sticky = false;
}

// if the instance should not stick to the tile
if ( ! _sticky)
{
    // get the value that represents the side that is "open space'
    var _tile_determinant = tile_definitions[_tile_at_point, 9];
    
    // find the side of the tile the end point is on
    var _end_determinant = (((_start_x + _new_move_h) - _tile_x1) * (_tile_y2 - _tile_y1)) - (((_start_y + _new_move_v) - _tile_y1) * (_tile_x2 - _tile_x1));
    
    // if the end point is on the open side of the tile
    if (sign(_end_determinant) == _tile_determinant)
    {
        // the instance is moving into the open side of the tile
        return false;
    }
    
}


/**
 * Find the Point of Intersection
 *
 */

var _xx, _yy;
var _tile_intercept = false;

// find the y-intercepts for both lines
var _ray_y_intercept = _start_y - (_ray_gradient * _start_x);
var _tile_y_intercept = _tile_y1 - (_tile_gradient * _tile_x1);

// if a vertical line
// *the ray's x position is always x1, so just plug x into the second line's equation and solve for y
if (_new_move_h == 0)
{
    _xx = _start_x;
    _yy = (_tile_gradient * _xx) + _tile_y_intercept;
}

// else, if a horizontal line
// *the ray's y position is always y1, so just plug y into the second line's equation and solve for x
else if (_new_move_v == 0)
{
    _yy = _start_y;
    _xx = (_yy - _tile_y_intercept) / _tile_gradient;
}

// else, both lines are sloped
else
{
    // find the point where the lines intersect
    _xx = (_tile_y_intercept - _ray_y_intercept) / (_ray_gradient - _tile_gradient);
    _yy = (_ray_gradient * _xx) + _ray_y_intercept;
}

// find the distance from the starting point to where the collision occurred
var _distance = point_distance(_start_x, _start_y, _xx, _yy);

// if the distance to the point of collision exceedes the maximum target distance
if (_distance >= _ray_target)
{
    return false;
}

// round each value used for comparison to the same nearest decimal place
// *don't rely on javascript to be able to accurately track large floating point values
_xx = round(_xx * 1000) / 1000;
_yy = round(_yy * 1000) / 1000;
_tile_x1 = round(_tile_x1 * 1000) / 1000;
_tile_y1 = round(_tile_y1 * 1000) / 1000;
_tile_x2 = round(_tile_x2 * 1000) / 1000;
_tile_y2 = round(_tile_y2 * 1000) / 1000;

// if colliding with the exact corner or edge of the sloped tile
// *it could end up calculating into another cell when dividing by the _cell_size
if ((_xx == _tile_x1 && _yy == _tile_y1) || _xx == _tile_x2 && _yy == _tile_y2)
{
    _tile_intercept = true;
}
else
{
    // find the cell where the lines intercept
    var _cell_x2 = floor(_xx / _tile_size);
    var _cell_y2 = floor(_yy / _tile_size);
    
    // if the lines intercept within the cell that called this script
    if (_cell_x2 == _cell_x && _cell_y2 == _cell_y)
    {
        _tile_intercept = true;
    }
    
}

// if the lines don't intercept within this tile
if ( ! _tile_intercept)
{
    return false;
}


/**
 * Update Instance Variables
 *
 */

// update the point of collision
raycast_slope_x = _xx - _offset_x;
raycast_slope_y = _yy - _offset_y;

// store the gradient of this tile
raycast_slope_collision_gradient = _tile_gradient;

// update floor/ceiling collision states
raycast_slope_collision_floor = _is_floor_tile;
raycast_slope_collision_ceiling = !_is_floor_tile;

var _raycast_slope_move_h = 0;
var _raycast_slope_move_v = 0;

// if this instance is always falling
if (has_gravity)
{
    // if there is horizontal movement remaining
    if (_new_move_h != 0)
    {
        // redirect only the remaining horizontal movement along the slope
        var _distance_h = point_distance(_xx, 0, _start_x + _new_move_h, 0);
        _raycast_slope_move_h = _distance_h * _tile_cosine;
        _raycast_slope_move_v = ((_tile_gradient * (_xx + _raycast_slope_move_h)) + _tile_y_intercept) - _yy;
    }
}

// else, this instance has no graivty
else
{
    // if the slopes are not opposite
    // *if the slope were opposite, the lines would be perpendicular
    if (_ray_gradient != -(_tile_gradient))
    {
        var _m1 = _ray_gradient;
        var _m2 = _tile_gradient;
        
        // get the angle between two straight lines with slope m1 and m2
        // tan(θ) = ±(m2 - m1) / (1 + m1 * m2)
        var _intersection_angle = darctan((_m2 - _m1) / (1 + (_m1 * _m2)));
        
        // get the angle of the ray
        var _ray_angle = point_direction(0, 0, _new_move_h, _new_move_v);
        
        // redirect the movement along the slope
        var _len = _ray_target - _distance;
        var _dir = _ray_angle - _intersection_angle;
        _raycast_slope_move_h = lengthdir_x(_len, _dir);
        _raycast_slope_move_v = lengthdir_y(_len, _dir);
    }
}

// update the redirection movement values
raycast_slope_move_h = _raycast_slope_move_h;
raycast_slope_move_v = _raycast_slope_move_v;

if (true)
{
    // capture the point on the slope where collision occurred
    var _list = ds_list_create();
    ds_list_add(_list, _xx, _yy, global.COLLISION_SLOPE_COLOR);
    ds_list_add(global.GUI_AXIS_POINTS, _list);
    ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
}

return true;
