/// @function scr_simulation_9_slope(x1, y1, cell_x, cell_y, slope, axis, size, tile_size, move_list, ray_target, tile_at_point);
/// @param {number} x1          - the starting x position
/// @param {number} y1          - the starting y position
/// @param {number} cell_x      - the horizontal cell position
/// @param {number} cell_y      - the vertical cell position
/// @param {number} slope       - the starting x position
/// @param {number} axis        - the axis to test against
/// @param {number} size        - the distance to check along the other axis
/// @param {number} tile_size   - the size of the tiles
/// @param {real} move_list     - the ds_list containing the move_h and move_v values
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
var _cell_x = argument2;
var _cell_y = argument3;
var _slope = argument4;
var _axis = argument5;
var _size = argument6;
var _cell_size = argument7;

var _move_list = argument8;
var _move_h = _move_list[| 0];
var _move_v = _move_list[| 1];

var _ray_target = argument9;
var _tile_at_point = argument10;

var _cell_slope_x, _cell_slope_y;

// reset collision states
var _slope_tile_collision = false;
var _slope_tile_intercept = false;

// slope of the lines
var _m1 = _slope;
var _m2 = _slope;

// the starting position of the ray
var _x1 = _start_x;
var _y1 = _start_y;


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
 * Find the Corner Points of the Slope in the Cell
 *
 * Normally, the top left point of a cell is used to determine its point in world (pixel) space and in the tile matrix.
 * But, depending the gradient of the sloped tile, the point needs to be moved so its on the tile's line.
 * Then, the corner points can be used to determine if the point of intersection occurs exactly on the tile's edge, which could be mistaken for another cell.
 */

var _corner_x1, _corner_y1;
var _corner_x2, _corner_y2;

// top left point of the cell
var _x2 = (_cell_x * _cell_size);
var _y2 = (_cell_y * _cell_size);

// if colliding with a south east ◢ slope
if (_tile_at_point == global.TILE_SOLID_45_SE)
{
    // top right
    _corner_x1 = _x2 + _cell_size;
    _corner_y1 = _y2;
    
    // bottom left
    _corner_x2 = _x2;
    _corner_y2 = _y2 + _cell_size;
}

// else, if colliding with a south west ◣ slope
else if (_tile_at_point == global.TILE_SOLID_45_SW)
{
    // top left
    _corner_x1 = _x2;
    _corner_y1 = _y2;
    
    // bottom right
    _corner_x2 = _x2 + _cell_size;
    _corner_y2 = _y2 + _cell_size;
}

// else, if colliding with a north west ◤ slope
else if (_tile_at_point == global.TILE_SOLID_45_NW)
{
    // top right
    _corner_x1 = _x2 + _cell_size;
    _corner_y1 = _y2;
    
    // bottom left
    _corner_x2 = _x2;
    _corner_y2 = _y2 + _cell_size;
}

// else, if colliding with a north east ◥ slope
else if (_tile_at_point == global.TILE_SOLID_45_NE)
{
    // top left
    _corner_x1 = _x2;
    _corner_y1 = _y2;
    
    // bottom right
    _corner_x2 = _x2 + _cell_size;
    _corner_y2 = _y2 + _cell_size;
}

// update the cell's point
_x2 = _corner_x1;
_y2 = _corner_y1;


/**
 * Update the Horizontal Offset
 *
 * Depending on the direction of the ray and the tile, the x position of the ray may need to be offset by the width of the object.
 */

var _offset_x1 = 0;

// if colliding with a north west ◤ or south west ◣ slope
if (_tile_at_point == global.TILE_SOLID_45_NW || _tile_at_point == global.TILE_SOLID_45_SW)
{
    // if the horizontal movement is zero or positive
    // *these rays are cast from the right side of the bounding box, reposition it to the left side of the object
    if (_move_h >= 0)
    {
        _offset_x1 = -(_size + 1);
    }
}

// else, if colliding with a north east ◥ or south east ◢ slope
else if (_tile_at_point == global.TILE_SOLID_45_NE || _tile_at_point == global.TILE_SOLID_45_SE)
{
    // if the horizontal movement is negative
    // *these rays are cast from the left side of the bounding box, reposition it to the right side of the object
    if (_move_h < 0)
    {
        _offset_x1 = (_size + 1);
    }
}

// update the x position
_x1 += _offset_x1;


/**
 * Update the Vertical Offset
 *
 * Depending on the direction of the ray and the tile, the y position of the ray may need to be offset by the height of the object.
 */

var _offset_y1 = 0;

// if colliding with a south west ◣ or south east ◢ slope
if (_tile_at_point == global.TILE_SOLID_45_SW || _tile_at_point == global.TILE_SOLID_45_SE)
{
    // if the vertical movement is negative
    // *these rays are cast from the top of the bounding box, reposition it to the bottom of the object
    if (_move_v < 0)
    {
        _offset_y1 = (_size + 1);
    }
}

// else, if colliding with a north west ◤ or north east ◥ slope
else if (_tile_at_point == global.TILE_SOLID_45_NW || _tile_at_point == global.TILE_SOLID_45_NE)
{
    // if the vertical movement is zero or positive
    // *these rays are cast from the bottom of the boudning box, reposition it to the top of the object
    if (_move_v >= 0)
    {
        _offset_y1 = -(_size + 1);
    }
}

// update the y position
_y1 += _offset_y1;


/**
 * Find the Point of Intersection
 *
 */

var _xx, _yy;

// find the y-intercepts for both lines
var _b1 = _y1 - (_m1 * _x1);
var _b2 = _y2 - (_m2 * _x2);

// if a vertical line
// *the ray's x position is always x1, so just plug x into the second line's equation and solve for y
if (_move_h == 0)
{
    _xx = _x1;
    _yy = (_m2 * _xx) + _b2;
}

// else, if a horizontal line
// *the ray's y position is always y1, so just plug y into the second line's equation and solve for x
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


//var _list = ds_list_create();
//ds_list_add(_list, _xx, _yy, global.COLLISION_SLOPE_COLOR);
//ds_list_add(global.GUI_AXIS_POINTS, _list);
//ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);

//var _list = ds_list_create();
//ds_list_add(_list, _x2, _y2, global.COLLISION_V_COLOR);
//ds_list_add(global.GUI_AXIS_POINTS, _list);
//ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);


// if colliding with the exact corner of the sloped tile
// *it could end up calculating into another cell when dividing by the _cell_size
if ((_xx == _corner_x1 && _yy == _corner_y1) || _xx == _corner_x2 && _yy == _corner_y2)
{
    _slope_tile_intercept = true;
}
else
{
    // find the cell where the lines intercept
    _cell_slope_x = floor(_xx / _cell_size);
    _cell_slope_y = floor(_yy / _cell_size);
    
    // if the lines intercept within the cell this slope occupies
    if (_cell_slope_x == _cell_x && _cell_slope_y == _cell_y)
    {
        // if the distance to the intercept point does not exceede the maximum target distance
        if (point_distance(_x1, _y1, _xx, _yy) < _ray_target)
        {
            _slope_tile_intercept = true;
        }
    }
    
}

// if the lines intercepted within the sloped tile
if (_slope_tile_intercept)
{
    if (_axis == 0)
    {
        //_step_h_x = _xx;
        //_step_h_y = _yy - (_move_v < 0 ? (_size + 1) : 0);
    }
    else if (_axis == 1)
    {
        //_step_v_x = _xx - (_move_h < 0 ? (_size + 1) : 0);
        //_step_v_y = _yy;
    }
    
    var _list = ds_list_create();
    ds_list_add(_list, _xx, _yy, global.COLLISION_SLOPE_COLOR);
    ds_list_add(global.GUI_AXIS_POINTS, _list);
    ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
}

