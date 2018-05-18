/// @function scr_simulation_8_slope(x1, y1, cell_x, cell_y, slope, axis, size, tile_size, move_list, ray_target, tile_at_point);
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

//if (_tile_at_point == _tile_slope_45_1)
//{
    _slope_tile_collision = true;
    
    var m1 = _slope;
    var m2 = _slope;
    
    var x1 = _start_x;
    var y1 = _start_y;
    
    // top left point of the cell
    var x2 = (_cell_x * _cell_size);
    var y2 = (_cell_y * _cell_size);
    
    // collision occurs when traveling south east: ◢
    if (_tile_at_point == global.TILE_SOLID_45_SE)
    {
        // update the slope of this line
        m2 = -1;
        
        // move to the bottom left of the cell
        y2 += _cell_size;
    }
    
    // collision occurs when traveling south west: ◣
    else if (_tile_at_point == global.TILE_SOLID_45_SW)
    {
        // update the slope of this line
        m2 = 1;
        
        // move to the bottom right of the cell
        x2 += _cell_size;
        y2 += _cell_size;
    }
    
    // collision occurs when traveling north west: ◤
    else if (_tile_at_point == global.TILE_SOLID_45_NW)
    {
        // update the slope of this line
        m2 = -1;
        
        // move to the bottom left of the cell
        y2 += _cell_size;
    }
    
    // collision occurs when traveling north east: ◥
    else if (_tile_at_point == global.TILE_SOLID_45_NE)
    {
        // update the slope of this line
        m2 = 1;
        
        // move to the bottom right of the cell
        x2 += _cell_size;
        y2 += _cell_size;
    }
    
    
    /*
    // if horizontal test
    if (_axis == 0)
    {
        // rising east /-|
        if (_move_h > 0)
        {
            m2 = -1;
            y1 += (_move_v < 0 ? (_size + 1) : 0);
            y2 += _cell_size;
        }
        
        // rising west |-\
        else if (_move_h < 0)
        {
            m2 = 1;
            y1 += (_move_v < 0 ? (_size + 1) : 0);
            x2 += _cell_size;
            y2 += _cell_size;
        }
    }
                    
    // else, if vertical test
    else if (_axis == 1)
    {
        // rising east /-|
        if (_move_v > 0)
        {
            m2 = -1;
            x1 += (_move_h < 0 ? (_size + 1) : 0);
            y2 += _cell_size;
        }
        
        // rising west |-\
        else if (_move_v < 0)
        {
            m2 = 1;
            x1 += (_move_h < 0 ? (_size + 1) : 0);
            x2 += _cell_size;
            y2 += _cell_size;
        }
        
    }
    */
    
    // if the slopes are the same the lines would never cross
    if (m1 == m2)
    {
        return;
    }
    
    // find the y-intercepts for both lines
    var b1 = y1 - (m1 * x1);
    var b2 = y2 - (m2 * x2);
    
    // find the point where the lines meet
    var xx = (b2 - b1) / (m1 - m2);
    var yy = (m1 * xx) + b1;
    
    // if a vertical line
    // *the first line's x position is always "_start_x"
    // *so just plug that value into the second line equation to find the point on the line where x = _start_x
    if (_move_h == 0)
    {
        xx = _start_x;
        yy = (m2 * xx) + b2;
    }
    
    scr_output("-");
    scr_output("y-intercepts", "b1", b1, "b2", b2, (b2 - b1));
    scr_output("slopes", "m1", m1, "m2", m2, (m1 - m2));
    scr_output("xx", xx, "yy", yy);
    
    var _list = ds_list_create();
    ds_list_add(_list, xx, yy, global.COLLISION_SLOPE_COLOR);
    ds_list_add(global.GUI_AXIS_POINTS, _list);
    ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
    
    var _list = ds_list_create();
    //ds_list_add(_list, x2, y2, global.COLLISION_SLOPE_COLOR);
    ds_list_add(_list, x2, y2, global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_AXIS_POINTS, _list);
    ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
    
    // if colliding with the exact corner of the sloped tile
    // *it would end up rounding down to being the tile direclty beneath it
    if (xx == x2 && yy == y2)
    {
        _slope_tile_intercept = true;
    }
    else
    {
        // find the cell where the lines intercept
        _cell_slope_x = floor(xx / _cell_size);
        _cell_slope_y = floor(yy / _cell_size);
        
        // if the lines intercept within the cell this slope occupies
        if (_cell_slope_x == _cell_x && _cell_slope_y == _cell_y)
        {
            // if the distance to the intercept point does not exceede the maximum target distance
            if (point_distance(x1, y1, xx, yy) < _ray_target)
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
            //_step_h_x = xx;
            //_step_h_y = yy - (_move_v < 0 ? (_size + 1) : 0);
        }
        else if (_axis == 1)
        {
            //_step_v_x = xx - (_move_h < 0 ? (_size + 1) : 0);
            //_step_v_y = yy;
        }
        
        //var _list = ds_list_create();
        //ds_list_add(_list, xx, yy, global.COLLISION_SLOPE_COLOR);
        //ds_list_add(global.GUI_AXIS_POINTS, _list);
        //ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
    }
    
//}

