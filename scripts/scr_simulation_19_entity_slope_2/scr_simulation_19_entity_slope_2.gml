/// @function scr_simulation_19_entity_slope_2(tile_at_point, cell_x, cell_y, ray_gradient, ray_target);
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

// if this tile's slope is the same as one already collided against
if (_tile_gradient == collision_slope_tile_gradient)
{
    return false;
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

/** /
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
/**/

/**/
var _sticky = false;
switch (_tile_at_point)
{
    // 45 degress
    case global.TILE_SOLID_45_SE: // ◢
    case global.TILE_SOLID_45_NW: // ◤
        if (_move_h > 0) _sticky = false;
        if (_move_h < 0) _sticky = true;
        break;
                        
    case global.TILE_SOLID_45_SW: // ◣
    case global.TILE_SOLID_45_NE: // ◥
        if (_move_h > 0) _sticky = true
        if (_move_h < 0) _sticky = false;
        break;
                        
    // 22.5 degress
    case global.TILE_SOLID_22_SE_1: // ◢
    case global.TILE_SOLID_22_SE_2: // ◢
    case global.TILE_SOLID_22_NW_1: // ◤
    case global.TILE_SOLID_22_NW_2: // ◤
        if (_move_h > 0) _sticky = false;
        if (_move_h < 0) _sticky = true;
        break;
                        
    case global.TILE_SOLID_22_SW_1: // ◣
    case global.TILE_SOLID_22_SW_2: // ◣
    case global.TILE_SOLID_22_NE_1: // ◥
    case global.TILE_SOLID_22_NE_2: // ◥
        if (_move_h > 0) _sticky = true;
        if (_move_h < 0) _sticky = false;
        break;
}

// get the value that represents the side that is "open space'
var _tile_determinant = tile_definitions[_tile_at_point, 8];
/*
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
*/
// if not sticking to the tile
// *this will allow the entity to jump away from the slope while rising with it
if ( ! _sticky)
{
    // find the side of the tile the end point is on
    var _end_determinant = (((_start_x + _move_h) - _tile_x1) * (_tile_y2 - _tile_y1)) - (((_start_y + _move_v) - _tile_y1) * (_tile_x2 - _tile_x1));
    
    // if the end point is on the open side of the tile
    if (sign(_end_determinant) == _tile_determinant)
    {
        return false;
    }
}
/**/

/** /
var _sticky = false;
switch (_tile_at_point)
{
    // 45 degress
    case global.TILE_SOLID_45_SE: // ◢
    case global.TILE_SOLID_45_NW: // ◤
        if (_move_h > 0) _sticky = false;
        if (_move_h < 0) _sticky = true;
        break;
                        
    case global.TILE_SOLID_45_SW: // ◣
    case global.TILE_SOLID_45_NE: // ◥
        if (_move_h > 0) _sticky = true
        if (_move_h < 0) _sticky = false;
        break;
                        
    // 22.5 degress
    case global.TILE_SOLID_22_SE_1: // ◢
    case global.TILE_SOLID_22_SE_2: // ◢
    case global.TILE_SOLID_22_NW_1: // ◤
    case global.TILE_SOLID_22_NW_2: // ◤
        if (_move_h > 0) _sticky = false;
        if (_move_h < 0) _sticky = true;
        break;
                        
    case global.TILE_SOLID_22_SW_1: // ◣
    case global.TILE_SOLID_22_SW_2: // ◣
    case global.TILE_SOLID_22_NE_1: // ◥
    case global.TILE_SOLID_22_NE_2: // ◥
        if (_move_h > 0) _sticky = true;
        if (_move_h < 0) _sticky = false;
        break;
}

// if not sticking to the tile
// *this will allow the entity to jump away from the slope while rising with it
if ( ! _sticky)
{
    // get the value that represents the side that is "open space'
    var _tile_determinant = tile_definitions[_tile_at_point, 8];
    
    // find the side of the tile the end point is on
    var _end_determinant = (((_start_x + _move_h) - _tile_x1) * (_tile_y2 - _tile_y1)) - (((_start_y + _move_v) - _tile_y1) * (_tile_x2 - _tile_x1));
    
    // if the end point is on the open side of the tile
    if (sign(_end_determinant) == _tile_determinant)
    {
        return false;
    }
}
/**/


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
if (_move_h == 0)
{
    _xx = _start_x;
    _yy = (_tile_gradient * _xx) + _tile_y_intercept;
}

// else, if a horizontal line
// *the ray's y position is always y1, so just plug y into the second line's equation and solve for x
else if (_move_v == 0)
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
        if (_move_h == 0)
        {
            raycast_slope_x = _xx - _offset_x;
            raycast_slope_y = _yy - _offset_y;
            
            // redirect the movement along the slope
            raycast_slope_move_h = 0;
            raycast_slope_move_v = 0;
            
            return true;
        }
        else
        {
            raycast_slope_x = _xx - _offset_x;
            raycast_slope_y = _yy - _offset_y;
            
            /** /
            // redirect the movement along the slope
            raycast_slope_move_h = (_ray_target - _distance) * _tile_cosine;
            raycast_slope_move_v = ((_tile_gradient * (_xx + raycast_slope_move_h)) + _tile_y_intercept) - _yy;
            /**/
            
            var _distance_h = point_distance(_xx, 0, _start_x + _move_h, 0);
            
            // redirect the movement along the slope
            raycast_slope_move_h = _distance_h * _tile_cosine;
            raycast_slope_move_v = ((_tile_gradient * (_xx + raycast_slope_move_h)) + _tile_y_intercept) - _yy;
            
            /** /
            var _tile_sine = 0;
                
            switch (_tile_at_point)
            {
                // 45 degress
                case global.TILE_SOLID_45_SE: // ◢
                case global.TILE_SOLID_45_NW: // ◤
                    if (_move_h > 0) _tile_sine =  0.70710678118;
                    if (_move_h < 0) _tile_sine = -0.70710678118;
                    break;
                        
                case global.TILE_SOLID_45_SW: // ◣
                case global.TILE_SOLID_45_NE: // ◥
                    if (_move_h > 0) _tile_sine = -0.70710678118;
                    if (_move_h < 0) _tile_sine =  0.70710678118;
                    break;
                        
                // 22.5 degress
                case global.TILE_SOLID_22_SE_1: // ◢
                case global.TILE_SOLID_22_SE_2: // ◢
                case global.TILE_SOLID_22_NW_1: // ◤
                case global.TILE_SOLID_22_NW_2: // ◤
                    if (_move_h > 0) _tile_sine =  0.38268343236;
                    if (_move_h < 0) _tile_sine = -0.38268343236;
                    break;
                        
                case global.TILE_SOLID_22_SW_1: // ◣
                case global.TILE_SOLID_22_SW_2: // ◣
                case global.TILE_SOLID_22_NE_1: // ◥
                case global.TILE_SOLID_22_NE_2: // ◥
                    if (_move_h > 0) _tile_sine = -0.38268343236;
                    if (_move_h < 0) _tile_sine =  0.38268343236;
                    break;
            }
            
            // redirect the movement along the slope
            raycast_slope_move_h = (_ray_target - _distance) * _tile_cosine;
            raycast_slope_move_v = (_ray_target - _distance) * _tile_sine * -1;
            /**/
            
            // get the gradient of this tile
            collision_slope_tile_gradient = _tile_gradient;
            
            return true;
        }
        
    }
    
    /*
        var _distance_h = point_distance(_xx, 0, _start_x + _move_h, 0);
    
        // redirect the movement along the slope
        raycast_slope_move_h = _distance_h * cos(_radians);
        raycast_slope_move_v = _distance_h * sin(_radians) * -1;
        
        return true;
    */
    
}

return false;

