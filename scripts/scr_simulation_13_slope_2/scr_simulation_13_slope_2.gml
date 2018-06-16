/// @function scr_simulation_13_slope_2(tile_at_point, cell_x, cell_y, ray_gradient, ray_target);
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

// movement values
var _move_h = raycast_move_h;
var _move_v = raycast_move_v;

// get values
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

var _list = ds_list_create();
ds_list_add(_list, (_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_H_COLOR);
ds_list_add(global.GUI_AXIS_POINTS, _list);
ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);


/**
 * Get the Slope of this Tile
 *
 * 45 degrees has a slope of either 1 or -1 depending on the direction.
 */

var _tile_gradient = _ray_gradient;

// if colliding with a south east ◢ or north west ◤ slope
if (_tile_at_point == global.TILE_SOLID_45_SE || _tile_at_point == global.TILE_SOLID_45_NW)
{
    // update the slope of this line
    _tile_gradient = -1;
}

// if colliding with a south west ◣ or north east ◥ slope
else if (_tile_at_point == global.TILE_SOLID_45_SW || _tile_at_point == global.TILE_SOLID_45_NE)
{
    // update the slope of this line
    _tile_gradient = 1;
}

// if the slopes are the same the lines would never cross
if (_ray_gradient == _tile_gradient)
{
    return;
}


/**
 * Find the Corner Points of the Slope in the Tile
 *
 * Normally, the top left point of a tile is used to determine its point in world (pixel) space and in the tile matrix.
 * But, depending on the gradient of the sloped tile, the point needs to be moved so its on the tile's line.
 * Then, the corner points can be used to determine if the point of intersection occurs exactly on the tile's edge, which could be mistaken for another tile.
 */

var _corner_x1, _corner_y1;
var _corner_x2, _corner_y2;

// top left point of the tile
var _x2 = (_cell_x * _tile_size);
var _y2 = (_cell_y * _tile_size);

// if colliding with a south east ◢ slope
if (_tile_at_point == global.TILE_SOLID_45_SE)
{
    // top right
    _corner_x1 = _x2 + _tile_size;
    _corner_y1 = _y2;
    
    // bottom left
    _corner_x2 = _x2;
    _corner_y2 = _y2 + _tile_size;
}

// else, if colliding with a south west ◣ slope
else if (_tile_at_point == global.TILE_SOLID_45_SW)
{
    // top left
    _corner_x1 = _x2;
    _corner_y1 = _y2;
    
    // bottom right
    _corner_x2 = _x2 + _tile_size;
    _corner_y2 = _y2 + _tile_size;
}

// else, if colliding with a north west ◤ slope
else if (_tile_at_point == global.TILE_SOLID_45_NW)
{
    // top right
    _corner_x1 = _x2 + _tile_size;
    _corner_y1 = _y2;
    
    // bottom left
    _corner_x2 = _x2;
    _corner_y2 = _y2 + _tile_size;
}

// else, if colliding with a north east ◥ slope
else if (_tile_at_point == global.TILE_SOLID_45_NE)
{
    // top left
    _corner_x1 = _x2;
    _corner_y1 = _y2;
    
    // bottom right
    _corner_x2 = _x2 + _tile_size;
    _corner_y2 = _y2 + _tile_size;
}

// update the tile's point
_x2 = _corner_x1;
_y2 = _corner_y1;


/**
 * Update the Offset
 *
 * Offset the starting point to be the point on the bounding box that would be the first to collide with the tile.
 * Then find which side of the tile's slope the starting point is.
 */

var _offset_x = 0;
var _offset_y = 0;
var _d1 = 0;

// if colliding with a south west ◣
if (_tile_at_point == global.TILE_SOLID_45_SW)
{
    _offset_x = 0;
    _offset_y = _height;
    _d1 = 1;
}

// if colliding with a south east ◢
else if (_tile_at_point == global.TILE_SOLID_45_SE)
{
    _offset_x = _width;
    _offset_y = _height;
    _d1 = -1;
}

// if colliding with a north west ◤
else if (_tile_at_point == global.TILE_SOLID_45_NW)
{
    _offset_x = 0;
    _offset_y = 0;
    _d1 = 1;
}

// if colliding with a north east ◥
else if (_tile_at_point == global.TILE_SOLID_45_NE)
{
    _offset_x = _width;
    _offset_y = 0;
    _d1 = -1;
}

// update the position
_start_x += _offset_x;
_start_y += _offset_y;

var _list = ds_list_create();
ds_list_add(_list, _start_x, _start_y, global.COLLISION_V_COLOR);
ds_list_add(global.GUI_AXIS_POINTS, _list);
ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);

/*
var lx = (tileX + def_0) * tilesize;
var ly = (tileY + def_1) * tilesize;
var lvx = (def_2 - def_0) * tilesize;
var lvy = (def_3 - def_1) * tilesize;

// Find the box corner to test, relative to the line
var tx = _x + vx + (lvy < 0 ? width : 0) - lx;
var ty = _y + vy + (lvx > 0 ? height : 0) - ly;

// Is the box corner behind the line?
if (lvx * ty - lvy * tx > 0)
{
    // Lines are only solid from one side - find the dot product of line normal and movement vector and dismiss if wrong side
    if (vx * -lvy + vy * lvx < 0)
    {
        return _solid;
    }
    
    ...
}
*/

// find what side of the sloped tile the starting point falls
// d = (x - x1)(y2 - y1) - (y - y1)(x2 - x1)
var _d2 = ((_start_x - _corner_x1) * (_corner_y2 - _corner_y1)) - ((_start_y - _corner_y1) * (_corner_x2 - _corner_x1));
//scr_output(_tile_gradient, _d2);

// using a point that is on the left side of the line: (x1 - 1, y1), find it's "sign"
//var _d3 = (((_corner_x1 - 1) - _corner_x1) * (_corner_y2 - _corner_y1)) - ((_corner_y1 - _corner_y1) * (_corner_x2 - _corner_x1));
//scr_output(_d1, _d2, _d3);

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

// if the starting point falls on the tile's sloped line
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
    var _b1 = _start_y - (_ray_gradient * _start_x);
    var _b2 = _y2 - (_tile_gradient * _x2);

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
    if ((_xx == _corner_x1 && _yy == _corner_y1) || _xx == _corner_x2 && _yy == _corner_y2)
    {
        _tile_intercept = true;
    }
    
    // else, if the point of intersection is within this cell
    else if (_cell_x == floor(_xx / _tile_size) && _cell_y == floor(_yy / _tile_size))
    {
        _tile_intercept = true;
    }
    
}

// if the lines intercepted within the sloped tile
if (_tile_intercept)
{
    // find the distance from the starting point to where the collision occurred
    var _distance = point_distance(_start_x, _start_y, _xx, _yy);
    
    // if the distance to the intercept point matches or exceedes the target distance
    if (_distance >= _ray_target)
    {
        return false;
    }
    
    // get the point of collision (minus the offsets)
    raycast_slope_x = _xx - _offset_x;
    raycast_slope_y = _yy - _offset_y;
    
    // the angle to redirect the movement values
    var _radians = 0;
    
    // if colliding with a south west ◣ or north east ◥ slope
    if (_tile_gradient == 1)
    {
        _radians = degtorad(_move_h >= 0 ? -45 : 135);
    }
    
    // if colliding with a south east ◢ or north west ◤ slope
    if (_tile_gradient == -1)
    {
        _radians = degtorad(_move_h > 0 ? 45 : -135);
    }
    
    // redirect the movement along the slope
    // *in a top down game, horizontal and veritcal distances are treated equally
    // *so the distance remaining needs to be redirected
    //raycast_slope_move_h = (_ray_target - _distance) * cos(_radians);
    //raycast_slope_move_v = (_ray_target - _distance) * sin(_radians) * -1;
    
    // redirect the movement along the slope
    // *in a side scroller, we only care about the horizontal movement along the slope
    // *so only the remaining horizontal distance needs to be redirected
    var _distance_h = abs(_start_x + _move_h - _xx);
    raycast_slope_move_h = _distance_h * cos(_radians);
    raycast_slope_move_v = _distance_h * sin(_radians) * -1;
    
    // capture the point on the slope where collision occurred
    var _list = ds_list_create();
    ds_list_add(_list, _xx, _yy, global.COLLISION_SLOPE_COLOR);
    ds_list_add(global.GUI_AXIS_POINTS, _list);
    ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
    
    return true;
}

return false;
