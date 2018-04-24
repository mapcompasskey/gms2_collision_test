/// @function scr_simulation_14_raycast_3_2(x1, y1, x2, y2, move_list, tilemap, cell_size, axis);
/// @param {number} x1 the starting x position
/// @param {number} y1 the starting y position
/// @param {number} x2 the x position to check
/// @param {number} y2 the y position to check
/// @param {real} new_move_list the ds_list containing the new move_h and move_v
/// @param {real} tilemap the layer tilemap id of the collision layer
/// @param {number} cell_size the size of the tiles
/// @param {number} axis the axis that is being checked (used for GUI drawing)


/**
 * Detect Cell Collision
 *
 */

var _x1 = argument0;
var _y1 = argument1;
var _x2 = argument2;
var _y2 = argument3;
var _move_list = argument4;
var _tilemap = argument5;
var _cell_size = argument6;
var _axis = argument7;

var _collision = false;
var _move_h = _move_list[| 0];
var _move_v = _move_list[| 1];

// record the collision point
var _list = ds_list_create();
if (_axis == 1) ds_list_add(_list, _x2, _y2, global.COLLISION_V_COLOR);
else ds_list_add(_list, _x2, _y2, global.COLLISION_H_COLOR);
ds_list_add(global.GUI_AXIS_POINTS, _list);
ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);

// capture the current cell position
var _cell_x = floor(_x2 / _cell_size);
var _cell_y = floor(_y2 / _cell_size);

// if the horizontal movement is negative and the x position is directly on a cell
if (_move_h <= 0 && (_x2 mod _cell_size) == 0)
{
    // offset the horizontal cell by one
    _cell_x -= 1;
}

// if the vertical movement is negative and the y position is directly on a cell
if (_move_v <= 0 && (_y2 mod _cell_size) == 0)
{
    // offset the vertical cell by one
    _cell_y -= 1;
}

// capture the cell's position
var _list = ds_list_create();
if (_axis == 1) ds_list_add(_list, (_cell_x * _cell_size), (_cell_y * _cell_size), global.COLLISION_V_COLOR);
else ds_list_add(_list, (_cell_x * _cell_size), (_cell_y * _cell_size), global.COLLISION_H_COLOR);
ds_list_add(global.DRAW_CELLS, _list);
ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);

// check tile collision
var _tile_at_point = tilemap_get(_tilemap, _cell_x, _cell_y) & tile_index_mask;
if (_tile_at_point == 1)
{
    // update the horizontal movement
    if (_move_h > 0)
    {
        if (_x2 < (_x1 + _move_h))
        {
            _move_h = _x2 - _x1;
            _collision = true;
        }
    }
    
    else if (_move_h < 0)
    {
        if (_x2 > (_x1 + _move_h))
        {
            _move_h = _x2 - _x1
            _collision = true;
        }
    }
    
    // update the vertical movement
    if (_move_v > 0)
    {
        if (_y2 < (_y1 + _move_v))
        {
            _move_v = _y2 - _y1;
            _collision = true;
        }
    }
    
    else if (_move_v < 0)
    {
        if (_y2 > (_y1 + _move_v))
        {
            _move_v = _y2 - _y1;
            _collision = true;
        }
    }
    
}


/**
 * Update Values
 *
 */

// update the ds_list
_move_list[| 0] = _move_h;
_move_list[| 1] = _move_v;

// return whether a collision occurred
return _collision;

