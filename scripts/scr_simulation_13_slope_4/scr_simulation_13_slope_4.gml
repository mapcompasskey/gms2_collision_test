/// @function scr_simulation_13_slope_4(tile_at_point, cell_x, cell_y, ray_gradient, ray_target);
/// @param {real} tile_at_point  - the index of the tile that was collided with
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
 * Get the Slope of this Tile and its Corner Poiints
 *
 * 45 degrees has a slope of either 1 or -1 depending on the direction.
 *
 * Normally, the top left point of a tile is used to determine its point in world (pixel) space and in the tile matrix.
 * But, depending on the gradient of the sloped tile, the point needs to be moved so its on the tile's line.
 * Then, the corner points can be used to determine if the point of intersection occurs exactly on the tile's edge, which could be mistaken for another tile.
 * (_tile_x1, _tile_y1) needs to be the left most point and (_tile_x2, _tile_y2) needs to be the right most point.
 */

var _tile_x1, _tile_y1;
var _tile_x2, _tile_y2;
var _tile_gradient = _ray_gradient;
var _tile_degrees = 0;
var _tile_radians = 0;

// 45 degrees
switch (_tile_at_point)
{
    // south east ◢ or north west ◤
    case global.TILE_SOLID_45_SE:
    case global.TILE_SOLID_45_NW:
    
        // update the angle
        _tile_gradient = -1;
        _tile_degrees = (_move_h > 0 ? 45 : -135);
        _tile_radians = (_move_h > 0 ? 0.70710678118 : -0.70710678118);
        
        // bottom left
        _tile_x1 = (_cell_x + 0) * _tile_size;
        _tile_y1 = (_cell_y + 1) * _tile_size;
        
        // top right
        _tile_x2 = (_cell_x + 1) * _tile_size;
        _tile_y2 = (_cell_y + 0) * _tile_size;
        
        break;
    
    // south west ◣ or north east ◥
    case global.TILE_SOLID_45_SW:
    case global.TILE_SOLID_45_NE:
    
        // update the angle
        _tile_gradient = 1;
        _tile_degrees = (_move_h >= 0 ? -45 : 135);
        _tile_radians = (_move_h >= 0 ? 0.70710678118 : -0.70710678118);
        
        // top left
        _tile_x1 = (_cell_x + 0) * _tile_size;
        _tile_y1 = (_cell_y + 0) * _tile_size;
        
        // bottom right
        _tile_x2 = (_cell_x + 1) * _tile_size;
        _tile_y2 = (_cell_y + 1) * _tile_size;
        
        break;
}

// 22 degrees
switch (_tile_at_point)
{
    // south east ◢ (1) or north west ◤ (1)
    case global.TILE_SOLID_22_SE_1:
    case global.TILE_SOLID_22_NW_1:
        
        // update the angle
        _tile_gradient = -0.5;
        _tile_degrees = (_move_h > 0 ? 22.5 : -157.5);
        _tile_radians = (_move_h > 0 ? 0.92387953251 : -0.92387953251);
        
        // bottom left
        _tile_x1 = (_cell_x + 0) * _tile_size;
        _tile_y1 = (_cell_y + 1) * _tile_size;
        
        // middle right
        _tile_x2 = (_cell_x + 1) * _tile_size;
        _tile_y2 = (_cell_y + 0.5) * _tile_size;
        
        break;
        
    // south east ◢ (2) or north west ◤ (2)
    case global.TILE_SOLID_22_SE_2:
    case global.TILE_SOLID_22_NW_2:
    
        // update the angle
        _tile_gradient = -0.5;
        _tile_degrees = (_move_h > 0 ? 22.5 : -157.5);
        _tile_radians = (_move_h > 0 ? 0.92387953251 : -0.92387953251);
        
        // middle left
        _tile_x1 = (_cell_x + 0) * _tile_size;
        _tile_y1 = (_cell_y + 0.5) * _tile_size;
        
        // top right
        _tile_x2 = (_cell_x + 1) * _tile_size;
        _tile_y2 = (_cell_y + 0) * _tile_size;
        
        break;
    
    // south west ◣ (1) or north east ◥ (1)
    case global.TILE_SOLID_22_SW_1:
    case global.TILE_SOLID_22_NE_1:
        
        // update the angle
        _tile_gradient = 0.5;
        _tile_degrees = (_move_h > 0 ? -22.5 : 157.5);
        _tile_radians = (_move_h > 0 ? 0.92387953251 : -0.92387953251);
        
        // top left
        _tile_x1 = (_cell_x + 0) * _tile_size;
        _tile_y1 = (_cell_y + 0) * _tile_size;
        
        // middle right
        _tile_x2 = (_cell_x + 1)   * _tile_size;
        _tile_y2 = (_cell_y + 0.5) * _tile_size;
        
        break;
    
    // south west ◣ (2) or north east ◥ (2)
    case global.TILE_SOLID_22_SW_2:
    case global.TILE_SOLID_22_NE_2:
    
        // update the angle
        _tile_gradient = 0.5;
        _tile_degrees = (_move_h > 0 ? -22.5 : 157.5);
        _tile_radians = (_move_h > 0 ? 0.92387953251 : -0.92387953251);
        
        // middle left
        _tile_x1 = (_cell_x + 0)   * _tile_size;
        _tile_y1 = (_cell_y + 0.5) * _tile_size;
        
        // bottom right
        _tile_x2 = (_cell_x + 1) * _tile_size;
        _tile_y2 = (_cell_y + 1) * _tile_size;
        
        break;
        
}


// if the slopes are the same the lines would never cross
if (_ray_gradient == _tile_gradient)
{
    return;
}


/**
 * Offset the Starting Position
 *
 * Offset the starting point to be the point on the bounding box that would be the first to collide with the tile.
 * Then find which side of the tile's slope the starting point is ("_d1" is the "open" side of the tile)
 */

var _offset_x = 0;
var _offset_y = 0;
var _d1 = 0;

// 45 degrees, 22 degrees
switch (_tile_at_point)
{
    // south east ◢
    case global.TILE_SOLID_45_SE:
    case global.TILE_SOLID_22_SE_1:
    case global.TILE_SOLID_22_SE_2:
        _offset_x = _width;
        _offset_y = _height;
        _d1 = 1;
        break;
        
    // north west ◤
    case global.TILE_SOLID_45_NW:
    case global.TILE_SOLID_22_NW_1:
    case global.TILE_SOLID_22_NW_2:
        _offset_x = 0;
        _offset_y = 0;
        _d1 = -1;
        break;
        
    // south west ◣
    case global.TILE_SOLID_45_SW:
    case global.TILE_SOLID_22_SW_1:
    case global.TILE_SOLID_22_SW_2:
        _offset_x = 0;
        _offset_y = _height;
        _d1 = 1;
        break;
        
    // north east ◥
    case global.TILE_SOLID_45_NE:
    case global.TILE_SOLID_22_NE_1:
    case global.TILE_SOLID_22_NE_2:
        _offset_x = _width;
        _offset_y = 0;
        _d1 = -1;
        break;
}

// update the starting position
_start_x += _offset_x;
_start_y += _offset_y;

var _list = ds_list_create();
ds_list_add(_list, _start_x, _start_y, global.COLLISION_V_COLOR);
ds_list_add(global.GUI_AXIS_POINTS, _list);
ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);

// find which side of the tile the starting point is on using: d = (x - x1)(y2 - y1) - (y - y1)(x2 - x1)
var _d2 = ((_start_x - _tile_x1) * (_tile_y2 - _tile_y1)) - ((_start_y - _tile_y1) * (_tile_x2 - _tile_x1));

// if the point is not on the line
// and if the point is on the "solid" side of the line
if (_d2 != 0 && sign(_d2) != sign(_d1))
{
    return false;
}


/**
 * Find the Point of Intersection
 *
 * point: (x, y)
 * m: slope
 * b: y-intercept
 * 
 * line equation: y = mx + b
 * y-intercept: b = y - mx
 */

var _xx, _yy;
var _tile_intercept = false;

// get the y-intercepts of both lines
var _b1 = _start_y - (_ray_gradient * _start_x);
var _b2 = _tile_y1 - (_tile_gradient * _tile_x1);

// if the starting point falls on the tile's slope
if (_d2 == 0)
{
    _xx = _start_x;
    _yy = _start_y;
    _tile_intercept = true;
}

// else, the starting point is on the "non-solid" side of the tile
else
{
    // get the y-intercepts of both lines
    //_b1 = _start_y - (_ray_gradient * _start_x);
    //_b2 = _tile_y1 - (_tile_gradient * _tile_x1);

    // if the ray is a vertical line
    // *the ray's x position is always _start_x, so just plug _start_x into the second line's equation and solve for y
    if (_move_h == 0)
    {
        _xx = _start_x;
        _yy = (_tile_gradient * _xx) + _b2;
    }

    // else, if the ray is a horizontal line
    // *the ray's y position is always _start_y, so just plug _start_y into the second line's equation and solve for x
    else if (_move_v == 0)
    {
        _yy = _start_y;
        _xx = (_yy - _b2) / _tile_gradient;
    }

    // else, both lines are sloped
    else
    {
        // find the point where the lines intersect
        _xx = (_b2 - _b1) / (_ray_gradient - _tile_gradient);
        _yy = (_ray_gradient * _xx) + _b1;
    }
    
    // capture the point on the slope where collision occurred
    //var _list = ds_list_create();
    //ds_list_add(_list, _xx, _yy, global.COLLISION_SLOPE_COLOR);
    //ds_list_add(global.GUI_AXIS_POINTS, _list);
    //ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
    //return false;
    
    // if colliding with the exact corner of the sloped tile
    // *it could end up calculating into another tile when dividing by the _tile_size
    if ((_xx == _tile_x1 && _yy == _tile_y1) || (_xx == _tile_x2 && _yy == _tile_y2))
    {
        _tile_intercept = true;
    }
    
    // else, if the point of intersection is within this cell
    else if (_cell_x == floor(_xx / _tile_size) && _cell_y == floor(_yy / _tile_size))
    {
        _tile_intercept = true;
    }
    
}

// if the lines intercept within the sloped tile
if (_tile_intercept)
{
    // find the distance from the starting point to where the collision occurred
    var _distance = point_distance(_start_x, _start_y, _xx, _yy);
    
    // if the distance to the intercept point matches or exceedes the target distance
    if (_distance >= _ray_target)
    {
        return false;
    }
    
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
}

return false;
