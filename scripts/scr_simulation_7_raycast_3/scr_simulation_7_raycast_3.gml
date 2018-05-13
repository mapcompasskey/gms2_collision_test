/// @function scr_simulation_7_raycast_3(x1, y1, move_list, collision_list, tilemap_layer, tile_size, bbox_width, bbox_height, redirected);
/// @param {number} x1              - the starting x position
/// @param {number} y1              - the starting y position
/// @param {real} move_list         - the ds_list containing the move_h and move_v values
/// @param {real} collision_list    - the ds_list containing the collision_h and collision_v states
/// @param {real} tilemap_layer     - the layer tilemap id of the collision layer
/// @param {number} tile_size       - the size of the tiles
/// @param {number} bbox_width      - the bounding box width
/// @param {number} bbox_height     - the bounding box height
/// @param {boolean} redirected     - if redirected after a collision


/**
 * Tile Based Collision Test
 *
 * Cast a ray from a point and check each horizontal and veritcal intersection for collision with a tile.
 * At each intersection, move away from the point, the length of the bounding box, checking for collisions with adjacent tiles.
 */

// the starting position
var _start_x = argument0;
var _start_y = argument1;

// the movement valuse
var _move_list = argument2;
var _move_h = _move_list[| 0];
var _move_v = _move_list[| 1];
var _new_move_h = _move_h;
var _new_move_v = _move_v;

// the collision states
var _collision_list = argument3;
var _collision_h = false;
var _collision_v = false;

// the tilemap layer and tile size
var _collision_tilemap = argument4;
var _cell_size = argument5;

// the object size
var _width = argument6;
var _height = argument7;

var _redirected = argument8;

// if there is movement
if (_move_h != 0 || _move_v != 0)
{
    // prepare variables
    var _cell_x, _cell_y;
    var _size_delta, _size_target;
    
    // tile values
    var _tile_at_point;
    var _tile_solid = tile_solid;
    var _tile_one_way = tile_solid;
    
    // the test that can be performed
    var _test_h = (_move_h == 0 ? false : true);
    var _test_v = (_move_v == 0 ? false : true);
    
    // the slope of the line
    // *using a different term since "slope" can also refer to a type of tile
    var _gradient = 0;
    if (_move_h != 0 && _move_v != 0)
    {
        _gradient = (_move_v / _move_h);
    }
    
    // the distances traveled along the ray
    var _ray_delta_h = 0;
    var _ray_delta_v = 0;
    
    // the maximum distance of the ray
    var _ray_target = point_distance(0, 0, _move_h, _move_v);
    
    // the distances to the collision points
    var _ray_collision_h = _ray_target;
    var _ray_collision_v = _ray_target;
    
    // the point to check horizontally
    var _step_h_x = _start_x;
    var _step_h_y = _start_y;
    
    // the point to check vertically
    var _step_v_x = _start_x;
    var _step_v_y = _start_y;
    
    // if testing horizontal collisions
    if (_test_h)
    {
        // if the point is not on a horizontal intersection
        var _remainder_x = _step_h_x mod _cell_size;
        if (_remainder_x != 0)
        {
            if (_remainder_x > 0)
            {
                // get the next horizontal intersection
                _step_h_x = round(_step_h_x - _remainder_x + (_move_h > 0 ? _cell_size : 0));
            }
            else
            {
                // get the next horizontal intersection
                _step_h_x = round(_step_h_x - _remainder_x - (_move_h > 0 ? 0 : _cell_size));
            }
        
            // if there is slope
            if (_gradient != 0)
            {
                // get the new y point
                _step_h_y = (_gradient * (_step_h_x - _start_x)) + _start_y;
            }
        
        }
        
        // get the distance to the first horizontal intersections
        _ray_delta_h = point_distance(_start_x, _start_y, _step_h_x, _step_h_y);
        
        // if the distance is larger than the ray
        if (_ray_delta_h > _ray_target)
        {
            _test_h = false;
        }
    }
    
    // if testing vertical collisions
    if (_test_v)
    {
        // if the point is not on a vertical intersection
        var _remainder_y = _step_v_y mod _cell_size;
        if (_remainder_y != 0)
        {
            if (_remainder_y > 0)
            {
                // get the next vertical intersection
                _step_v_y = round(_step_v_y - _remainder_y + (_move_v > 0 ? _cell_size : 0));
            }
            else
            {
                // get the next vertical intersection
                _step_v_y = round(_step_v_y - _remainder_y - (_move_v > 0 ? 0 : _cell_size));
            }
        
            // if there is slope
            if (_gradient != 0)
            {
                // get the new x point
                _step_v_x = ((_step_v_y - _start_y) / _gradient ) + _start_x;
            }
        
        }
        
        // get the distance to the first vertical intersections
        _ray_delta_v = point_distance(_start_x, _start_y, _step_v_x, _step_v_y);
        
        // if the distance is larger than the ray
        if (_ray_delta_v > _ray_target)
        {
            _test_v = false;
        }
    }
    
    // while test can be performed and no collisions have occurred
    while ((_test_h || _test_v) && ! _collision_h && ! _collision_v)
    {
        // if can test horizontal collision
        // (and either can't test veritcal collision or the horizontal test is closer than the vertical test)
        if (_test_h && ( ! _test_v || _ray_delta_h <= _ray_delta_v))
        {
            _tile_one_way = (_move_h > 0 ? tile_solid_east : tile_solid_west);
            
            // find the cell this point occupies
            _cell_x = round(_step_h_x / _cell_size);
            _cell_y = floor(_step_h_y / _cell_size);
            
            // if the movement is negative
            if (_move_h < 0)
            {
                _cell_x = _cell_x - 1;
            }
            
            // if the point is on the other intersection
            if (_step_h_y mod _cell_size == 0)
            {
                // if there is no slope and the other movement is negative
                if (_gradient == 0 || _move_v < 0)
                {
                    _cell_y = _cell_y - 1;
                }
            }
            
            // get the distance from the point to the TOP LEFT corner of the cell
            _size_delta = point_distance(0, _step_h_y, 0, (_cell_y * _cell_size));
            
            // if the other movement is negative
            if (_move_v < 0)
            {
                // converts the distance to the BOTTOM LEFT corner of the cell
                _size_delta = _cell_size - _size_delta;
            }
            
            // get the total distance to check
            _size_target = (_height + _cell_size + 1);
            
            // while the target size hasn't been reached
            while (_size_delta < _size_target)
            {
                if ( ! _redirected)
                {
                    // capture the cell
                    var _list = ds_list_create();
                    ds_list_add(_list, (_cell_x * _cell_size), (_cell_y * _cell_size), global.COLLISION_H_COLOR);
                    ds_list_add(global.GUI_AXIS_POINTS, _list);
                    ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
                    ds_list_add(global.DRAW_CELLS, _list);
                    ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
                }
                
                // check tile collision
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
                if (_tile_at_point == _tile_solid || _tile_at_point == _tile_one_way)
                {
                    if (_ray_delta_h < _ray_collision_h)
                    {
                        // update collision states
                        _collision_h = true;
                        _test_h = false;
                        
                        // update the movement values
                        _new_move_h = _step_h_x - _start_x;
                        _new_move_v = _step_h_y - _start_y;
                        
                        // update the collision target distance
                        _ray_collision_h = point_distance(0, 0, _new_move_h, _new_move_v);
                    }
                }
                
                // move the cell to the next intersection along the side of the object
                _cell_y = _cell_y + (_move_v >= 0 ? -1 : 1);
                
                // increase the distance traveled
                _size_delta += _cell_size;
            }
            
            // if no collision occurred during this step
            if (_collision_h == false)
            {
                // move along the ray towards the next intersection
                _step_h_x = round(_step_h_x + (_cell_size * sign(_move_h)));
                
                // if there is slope
                if (_gradient != 0)
                {
                    // find the new y point
                    _step_h_y = (_gradient * (_step_h_x - _start_x)) + _start_y;   
                }
                
                // update the distance traveled
                _ray_delta_h = point_distance(_start_x, _start_y, _step_h_x, _step_h_y);
                
                // continue collision until the target distance is reached
                _test_h = (_ray_delta_h < _ray_target);
            
            }
            
        }
        
        // else, if can test vertical collision
        // (and either can't test horizontal collision or the vertical test is closer than the horizontal test)
        else if  (_test_v && ( ! _test_h || _ray_delta_v <= _ray_delta_h))
        {
            _tile_one_way = (_move_v > 0 ? tile_solid_south : tile_solid_north);
            
            // find the cell this point occupies
            _cell_x = floor(_step_v_x / _cell_size);
            _cell_y = round(_step_v_y / _cell_size);
            
            // if the movement is negative
            if (_move_v < 0)
            {
                _cell_y = _cell_y - 1;
            }
            
            // if the point is on the other intersection
            if (_step_v_x mod _cell_size == 0)
            {
                // if there is no slope and the other movement is negative
                if (_gradient == 0 || _move_h < 0)
                {
                    _cell_x = _cell_x - 1;
                }
            }
            
            // get the distance from the point to the TOP LEFT corner of the cell
            _size_delta = point_distance(_step_v_x, 0, (_cell_x * _cell_size), 0);
            
            // if the other movement is negative
            if (_move_h < 0)
            {
                // converts the distance to the TOP RIGHT corner of the cell
                _size_delta = _cell_size - _size_delta;
            }
            
            // get the total distance to check
            _size_target = (_width + _cell_size + 1);
            
            // while the target size hasn't been reached
            while (_size_delta < _size_target)
            {
                if ( ! _redirected)
                {
                    // capture the cell
                    var _list = ds_list_create();
                    ds_list_add(_list, (_cell_x * _cell_size), (_cell_y * _cell_size), global.COLLISION_V_COLOR);
                    ds_list_add(global.GUI_AXIS_POINTS, _list);
                    ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
                    ds_list_add(global.DRAW_CELLS, _list);
                    ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
                }
                
                // check tile collision
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
                if (_tile_at_point == _tile_solid || _tile_at_point == _tile_one_way)
                {
                    if (_ray_delta_v < _ray_collision_v)
                    {
                        // update collision states
                        _collision_v = true;
                        _test_v = false;
                        
                        // update the movement values
                        _new_move_h = _step_v_x - _start_x;
                        _new_move_v = _step_v_y - _start_y;
                        
                        // update the collision target distance
                        _ray_collision_v = point_distance(0, 0, _new_move_h, _new_move_v);
                    }
                }
                
                // move the cell to the next intersection along the side of the object
                _cell_x = _cell_x + (_move_h >= 0 ? -1 : 1);
                
                // increase the distance traveled
                _size_delta += _cell_size;
            }
            
            // if no collision occurred during this step
            if (_collision_v == false)
            {
                // move along the ray towards the next intersection
                _step_v_y = round(_step_v_y + (_cell_size * sign(_move_v)));
                
                // if there is slope
                if (_gradient != 0)
                {
                    // find the new x point
                    _step_v_x = ((_step_v_y - _start_y) / _gradient ) + _start_x;
                }
                
                // update the distance traveled
                _ray_delta_v = point_distance(_start_x, _start_y, _step_v_x, _step_v_y);
                
                // continue collision until the target distance is reached
                _test_v = (_ray_delta_v < _ray_target);
            
            }
            
        }
        
        // else, expected loop condition
        else
        {
            break;
        }
        
    }
    
    /*
    // if this test was not a straight line and a collision occurred
    if (_gradient != 0 && (_collision_h || _collision_v))
    {
        //var _start_x2 = _start_x + _new_move_h;
        //var _start_y2 = _start_y + _new_move_v;
        _start_x += _new_move_h;
        _start_y += _new_move_v;
        
        var _new_move_h2 = 0;
        var _new_move_v2 = 0;
        
        // if horizontal collision
        if (_collision_h)
        {
            // move the remaining vertical distance
            _new_move_h2 = 0;
            _new_move_v2 = _move_v - _new_move_v;
            
            // if the horizontal movement is negative, offset the ray to start on the right edge of the object
            // *the ray is cast from the right edge whenever an object is moving straight up or down
            //_start_x2 += (_move_h < 0 ? (_width + 1) : 0);
            _start_x += (_move_h < 0 ? (_width + 1) : 0);
        }
        
        // else, if vertical collision
        else if (_collision_v)
        {
            // move the remaining horizontal distance
            _new_move_h2 = _move_h - _new_move_h;
            _new_move_v2 = 0;
            
            // if the vertical movement is negative, offset the ray to start on the bottom edge of the object
            // *the ray is cast from the bottom edge whenever an object is moving straight left or right
            //_start_y2 += (_move_v < 0 ? (_height + 1) : 0);
            _start_y += (_move_v < 0 ? (_height + 1) : 0);
        }
        
        //ds_list_add(gui_ray_2_points, _start_x2, _start_y2, (_start_x2 + _new_move_h2), (_start_y2 + _new_move_v2));
        ds_list_add(gui_ray_2_points, _start_x, _start_y, (_start_x + _new_move_h2), (_start_y + _new_move_v2));
        
        // update the ds_list with the new movement variables
        _move_list[| 0] = _new_move_h2;
        _move_list[| 1] = _new_move_v2;
        
        // do another collision check
        //scr_simulation_5_raycast(_start_x2, _start_y2, _move_list, _collision_tilemap, _cell_size, _width, _height, true);
        scr_simulation_5_raycast(_start_x, _start_y, _move_list, _collision_tilemap, _cell_size, _width, _height, true);
        
        // *IF THE NEW DISTANCES ARE BOTH ZERO, THEN I NEED TO ADD THE ADDITIONAL CHECK IN CASE THE PATH TO THE LEFT OR RIGHT ARE CLEAR
        
        // get the new movement after another collision check
        _new_move_h2 = _move_list[| 0];
        _new_move_v2 = _move_list[| 1];
        
        // update movement values
        _new_move_h += _new_move_h2;
        _new_move_v += _new_move_v2;
    }
    */
    
}


/**
 * Update Values
 *
 */

// update the movement list
_move_list[| 0] = _new_move_h;
_move_list[| 1] = _new_move_v;

// update the collision list
_collision_list[| 0] = _collision_h;
_collision_list[| 1] = _collision_v;

