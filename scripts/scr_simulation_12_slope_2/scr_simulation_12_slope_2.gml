/// @function scr_simulation_12_slope_2(start_x, start_y, tile_x, tile_y, slope, ray_target, tile_at_point);
/// @param {number} x1          - the starting x position
/// @param {number} y1          - the starting y position
/// @param {number} tile_x      - the horizontal tile position
/// @param {number} tile_y      - the vertical tile position
/// @param {number} slope       - the starting x position
/// @param {real} ray_target    - the maximum distance that can be traveled
/// @param {real} tile_at_point - the index of the tile that was collided with


/**
 * Slope Collision
 *
 * point: (x, y)
 * m: slope
 * b: y-intercept
 * 
 * line equation: y = mx + b
 * y-intercept: b = y - mx
 */

// get values
var _start_x = argument0;
var _start_y = argument1;
var _tile_x1 = argument2;
var _tile_y1 = argument3;
var _gradient = argument4;
var _ray_target = argument5;
var _tile_at_point = argument6;

// movement values
var _move_h = raycast_move_h;
var _move_v = raycast_move_v;

// the tile size
var _tile_size = global.TILE_SIZE;

// if there is no movement
if (_move_h == 0 && _move_v == 0)
{
    exit;
}

// slope of the lines
var _m1 = _gradient;
var _m2 = _gradient;

// the starting position of the ray
var _x1 = _start_x;
var _y1 = _start_y;

var _list = ds_list_create();
ds_list_add(_list, (_tile_x1 * _tile_size), (_tile_y1 * _tile_size), global.COLLISION_H_COLOR);
ds_list_add(global.GUI_AXIS_POINTS, _list);
ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);


/**
 * Set the Slope of the Second Line
 *
 * 45 degrees has a slope of either 1 or -1 depending on the direction.
 */

// if colliding with a south east ◢ or north west ◤ slope
if (_tile_at_point == global.TILE_SOLID_45_SE || _tile_at_point == global.TILE_SOLID_45_NW)
{
    // update the slope of this line
    _m2 = -1;
}

// if colliding with a south west ◣ or north east ◥ slope
else if (_tile_at_point == global.TILE_SOLID_45_SW || _tile_at_point == global.TILE_SOLID_45_NE)
{
    // update the slope of this line
    _m2 = 1;
}

// if the slopes are the same the lines would never cross
if (_m1 == _m2)
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
var _x2 = (_tile_x1 * _tile_size);
var _y2 = (_tile_y1 * _tile_size);

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
 * Depending on the sloped tile being tested against, offset the point to be the position that would be the first to collide into the tile.
 */

var _offset_x1 = 0;
var _offset_y1 = 0;
var _d1 = 0;

// if colliding with a south west ◣
if (_tile_at_point == global.TILE_SOLID_45_SW)
{
    _offset_x1 = 0;
    _offset_y1 = (bbox_height + 1);
    _d1 = 1;
}

// if colliding with a south east ◢
else if (_tile_at_point == global.TILE_SOLID_45_SE)
{
    _offset_x1 = (bbox_width + 1);
    _offset_y1 = (bbox_height + 1);
    _d1 = -1;
}

// if colliding with a north west ◤
else if (_tile_at_point == global.TILE_SOLID_45_NW)
{
    _offset_x1 = 0;
    _offset_y1 = 0;
    _d1 = 1;
}

// if colliding with a north east ◥
else if (_tile_at_point == global.TILE_SOLID_45_NE)
{
    _offset_x1 = (bbox_width + 1);
    _offset_y1 = 0;
    _d1 = -1;
}

// update the position
_x1 += _offset_x1;
_y1 += _offset_y1;

var _list = ds_list_create();
ds_list_add(_list, _x1, _y1, global.COLLISION_V_COLOR);
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
var _d2 = ((_x1 - _corner_x1) * (_corner_y2 - _corner_y1)) - ((_y1 - _corner_y1) * (_corner_x2 - _corner_x1));
//scr_output(_m2, _d2);

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
 */

var _xx, _yy;
var _tile_intercept = false;

// if the point falls on the sloped line
if (_d2 == 0)
{
    _xx = _x1;
    _yy = _y1;
    _tile_intercept = true;
}

// else, the starting point is in the "non-solid" side of the line
else
{
    // find the y-intercepts for both lines
    var _b1 = _y1 - (_m1 * _x1);
    var _b2 = _y2 - (_m2 * _x2);

    // if a vertical line
    // *the ray's x position is always x1, so just plug x1 into the second line's equation and solve for y
    if (_move_h == 0)
    {
        _xx = _x1;
        _yy = (_m2 * _xx) + _b2;
    }

    // else, if a horizontal line
    // *the ray's y position is always y1, so just plug y1 into the second line's equation and solve for x
    else if (_move_v == 0)
    {
        _yy = _y1;
        _xx = (_yy - _b2) / _m2;
    }

    // else, both lines are sloped
    else
    {
        // find the point where the lines intersect
        _xx = (_b2 - _b1) / (_m1 - _m2);
        _yy = (_m1 * _xx) + _b1;
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
    else
    {
        // find the tile where the lines intercept
        var _tile_x2 = floor(_xx / _tile_size);
        var _tile_y2 = floor(_yy / _tile_size);
        
        // if the lines intercept within this tile
        if (_tile_x2 == _tile_x1 && _tile_y2 == _tile_y1)
        {
            _tile_intercept = true;
        }
        
    }

}

// if the lines intercepted within the sloped tile
if (_tile_intercept)
{
    // find the distance from the starting point to where the collision occurred
    var _distance = point_distance(_x1, _y1, _xx, _yy);
    
    // if the distance to the intercept point does not exceede the maximum target distance
    if (_distance < _ray_target)
    {
        // get the point of collision (minus the offsets)
        raycast_slope_x = _xx - _offset_x1;
        raycast_slope_y = _yy - _offset_y1;
        
        var _radians = 0;
        
        // if colliding with a south west ◣ or north east ◥ slope
        if (_m2 == 1)
        {
            _radians = degtorad(_move_h >= 0 ? -45 : 135);
        }
        
        // if colliding with a south east ◢ or north west ◤ slope
        if (_m2 == -1)
        {
            _radians = degtorad(_move_h > 0 ? 45 : -135);
        }
        
        // redirect the movement along the slope
        raycast_slope_move_h = (_ray_target - _distance) * cos(_radians);
        raycast_slope_move_v = (_ray_target - _distance) * sin(_radians) * -1;
        
        // capture the point on the slope where collision occurred
        var _list = ds_list_create();
        ds_list_add(_list, _xx, _yy, global.COLLISION_SLOPE_COLOR);
        ds_list_add(global.GUI_AXIS_POINTS, _list);
        ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        
        return true;
    }
}

return false;
