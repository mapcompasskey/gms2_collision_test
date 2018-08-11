/// @function scr_simulation_19_entity_slope(tile_at_point, cell_x, cell_y, ray_gradient, ray_target);
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
if (raycast_new_move_h == 0 && raycast_new_move_v == 0)
{
    return false;
}

// get values
var _new_move_h = raycast_new_move_h;
var _new_move_v = raycast_new_move_v;
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
if (_tile_gradient == collision_slope_tile_gradient)
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
 * However, that relies on the floating point math to be extremely precise, which shouldn't be assumed.
 * Instead, just magnitize the instance to the slope unless the instance is attempting to move away from it (like when jumping).
 * You can determine if its leaving the slope because the "end determinant" will equal the side of the tile that is open space.
 *
 * d = (x - x1)(y2 - y1) - (y - y1)(x2 - x1)
 */

// get whether this type of tile is considered a floor or ceiling
var _is_floor_tile = tile_definitions[_tile_at_point, 8];

// if this instance is always falling
if (has_gravity)
{
    // if the instance is rising while on a floor tile
    if (_new_move_v < 0 && _is_floor_tile == 1)
    {
        // default state is to stick to the slope
        var _sticky = true;
        
        // if ◢ tile (gradient -1, -0.5)
        if (sign(_tile_gradient) == -1)
        {
            // if standing or descending the slope
            if (_new_move_h == 0 || _new_move_h < 0)
            {
                return false;
            }
            // else, if ascending the slope
            else if (_new_move_h > 0)
            {
                _sticky = false;
            }
        }
        
        // else, if ◣ tile (gradient 1, 0.5)
        else if (sign(_tile_gradient) == 1)
        {
            // if standing or descending the slope
            if (_new_move_h == 0 || _new_move_h > 0)
            {
                return false;
            }
            // else, if ascending the slope
            else if (_new_move_h < 0)
            {
                _sticky = false;
            }
        }
        
        // if the instance is attempting to leave the slope
        if ( ! _sticky)
        {
            // get the value that represents the side that is "open space'
            var _tile_determinant = tile_definitions[_tile_at_point, 9];
            
            // find the side of the tile the end point is on
            var _end_determinant = (((_start_x + _new_move_h) - _tile_x1) * (_tile_y2 - _tile_y1)) - (((_start_y + _new_move_v) - _tile_y1) * (_tile_x2 - _tile_x1));
            
            // if the end point is on the open side of the tile
            if (sign(_end_determinant) == _tile_determinant)
            {
                return false;
            }
        
        }
    
    }
    
    // if this tile is a "ceiling" tile
    // *need to determine if the end point is on the open side of the tile and if so, the instance should no longer stick to the slope of the tile
    if ( ! _is_floor_tile)
    {
        // get the value that represents the side that is "open space'
        var _tile_determinant = tile_definitions[_tile_at_point, 9];
    
        // find the side of the tile the end point is on
        var _end_determinant = (((_start_x + _new_move_h) - _tile_x1) * (_tile_y2 - _tile_y1)) - (((_start_y + _new_move_v) - _tile_y1) * (_tile_x2 - _tile_x1));
    
        // if the end point is on the open side of the tile
        if (sign(_end_determinant) == _tile_determinant)
        {
            return false;
        }
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

// round each value used for comparison to the same nearest decimal place
// *can't rely on javascript to be able to accurately track large floating point values
_xx = round(_xx * 1000) / 1000;
_yy = round(_yy * 1000) / 1000;
_tile_x1 = round(_tile_x1 * 1000) / 1000;
_tile_y1 = round(_tile_y1 * 1000) / 1000;
_tile_x2 = round(_tile_x2 * 1000) / 1000;
_tile_y2 = round(_tile_y2 * 1000) / 1000;

// if colliding with the exact corner of the sloped tile
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

// if the lines intercepted within the sloped tile
if (_tile_intercept)
{
    // find the distance from the starting point to where the collision occurred
    var _distance = point_distance(_start_x, _start_y, _xx, _yy);
    
    // if the distance to the intercept point does not exceede the maximum target distance
    if (_distance < _ray_target)
    {
        raycast_slope_x = _xx - _offset_x;
        raycast_slope_y = _yy - _offset_y;
        
        // reset floor/ceiling collision states
        raycast_slope_collision_floor = false;
        raycast_slope_collision_ceiling = false;
        
        // if this instance is always falling
        if (has_gravity)
        {
            if (_new_move_h == 0)
            {
                // no movement redirection
                raycast_slope_move_h = 0;
                raycast_slope_move_v = 0;
            }
            else
            {
                // redirect the remaining horizontal movement along the slope
                var _distance_h = point_distance(_xx, 0, _start_x + _new_move_h, 0);
                raycast_slope_move_h = _distance_h * _tile_cosine;
                raycast_slope_move_v = ((_tile_gradient * (_xx + raycast_slope_move_h)) + _tile_y_intercept) - _yy;
            }
            
            // update floor/ceiling collision states
            if (_is_floor_tile == 1)
            {
                raycast_slope_collision_floor = true;
                raycast_slope_collision_ceiling = false;
            }
            else
            {
                raycast_slope_collision_floor = false;
                raycast_slope_collision_ceiling = true;
            }
            
        }
        else
        {
            // redirect the movement along the slope
            raycast_slope_move_h = (_ray_target - _distance) * _tile_cosine;
            raycast_slope_move_v = ((_tile_gradient * (_xx + raycast_slope_move_h)) + _tile_y_intercept) - _yy;
        }
        
        // save the gradient of this tile
        collision_slope_tile_gradient = _tile_gradient;
        
        return true;
            
    }
    
}

return false;

