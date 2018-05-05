/// @function scr_simulation_3_entity_raycast(x1, y1, move_list, tilemap_layer, tile_size, bbox_width, bbox_height);
/// @param {number} x1 the starting x position
/// @param {number} y1 the starting y position
/// @param {real} move_list the ds_list containing the move_h and move_v
/// @param {real} tilemap_layer the layer tilemap id of the collision layer
/// @param {number} tile_size the size of the tiles
/// @param {number} bbox_width the bounding box width
/// @param {number} bbox_height the bounding box height


/**
 * Tile Based Collision Test
 *
 * Cast a ray from a point and check each horizontal and veritcal intersection for collision with a tile.
 * At each intersection, move away from the point, the length of the bounding box, checking for collisions with adjacent tiles.
 */

// the starting position
var _start_x = argument0;
var _start_y = argument1;

// the movement distances
var _move_list = argument2;
var _move_h = _move_list[| 0];
var _move_v = _move_list[| 1];
var _new_move_h = _move_h;
var _new_move_v = _move_v;

// the tilemap layer and tile size
var _collision_tilemap = argument3;
var _cell_size = argument4;

// the object size
var _width = argument5;
var _height = argument6;

// if there is movement
if (_move_h != 0 || _move_v != 0)
{
    // the test that can be performed
    var _test_h = (_move_h == 0 ? false : true);
    var _test_v = (_move_v == 0 ? false : true);
    
    // the slope of the line
    var _slope = 0;
    if (_move_h != 0 && _move_v != 0)
    {
        _slope = (_move_v / _move_h);
    }
    
    // the distances traveled along the ray
    var _ray_delta_h = 0;
    var _ray_delta_v = 0;
    
    // the maximum distance of the ray
    var _ray_target = point_distance(0, 0, _move_h, _move_v);
    
    // collision states
    var _collision_h = false;
    var _collision_v = false;
    
    // target positions
    var _end_h = (_start_x + _move_h);
    var _end_v = (_start_y + _move_v);
    
    // the first point to check horizontally
    var _step_h_x = _start_x;
    var _step_h_y = _start_y;
    
    // the first point to check vertically
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
            if (_slope != 0)
            {
                // get the new y point
                _step_h_y = (_slope * (_step_h_x - _start_x)) + _start_y;
            }
        
        }
        
        // get the distance to the first horizontal intersections
        _ray_delta_h = point_distance(_start_x, _start_y, _step_h_x, _step_h_y);
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
            if (_slope != 0)
            {
                // get the new x point
                _step_v_x = ((_step_v_y - _start_y) / _slope) + _start_x;
            }
        
        }
        
        // get the distance to the first vertical intersections
        _ray_delta_v = point_distance(_start_x, _start_y, _step_v_x, _step_v_y);
    }
    
    // prepare variables
    var _axis;
    var _start_1, _start_2;
    var _end_1, _end_2;
    var _step_1, _step_2;
    var _move_1, _move_2;
    var _new_move_1, _new_move_2;
    var _cell_1, _cell_2;
    var _size, _size_delta, _size_target;
    var _tile_at_point;
    var _collision;
    
    // while no collisions have occurred and test can be performed
    while ( ! _collision_h && ! _collision_v && (_test_h || _test_v))
    {
        // if can test horizontal collision
        // (and either can't test veritcal collision or the horizontal test is closer than the vertical test)
        if (_test_h && ( ! _test_v || _ray_delta_h <= _ray_delta_v))
        {
            // prepare the horizontal test
            _axis = 0;
            _start_1 = _start_x;
            _start_2 = _start_y;
            _end_1 = _end_h;
            _end_2 = _end_v;
            _step_1 = _step_h_x;
            _step_2 = _step_h_y;
            _move_1 = _move_h;
            _move_2 = _move_v;
            _new_move_1 = _new_move_h;
            _new_move_2 = _new_move_v;
            _size = _height;
        }
        
        // else, if can test vertical collision
        // (and either can't test horizontal collision or the vertical test is closer than the horizontal test)
        else if  (_test_v && ( ! _test_h || _ray_delta_v < _ray_delta_h))
        {
            // prepare the vertical test
            _axis = 1;
            _start_1 = _start_y;
            _start_2 = _start_x;
            _end_1 = _end_v;
            _end_2 = _end_h;
            _step_1 = _step_v_y;
            _step_2 = _step_v_x;
            _move_1 = _move_v;
            _move_2 = _move_h;
            _new_move_1 = _new_move_v;
            _new_move_2 = _new_move_h;
            _size = _width;
        }
        
        // else, unforeseen loop condition
        else
        {
            break;
        }
        
        // find the cell this point occupies
        _cell_1 = round(_step_1 / _cell_size);
        _cell_2 = floor(_step_2 / _cell_size);
        
        // if the movement is negative
        if (_move_1 < 0)
        {
            _cell_1 = _cell_1 - 1;
        }
        
        // if the point is on the other intersection
        if (_step_2 mod _cell_size == 0)
        {
            // if there is no slope and the other movement is negative
            if (_slope == 0 || _move_2 < 0)
            {
                _cell_2 = _cell_2 - 1;
            }
        }
        
        // get the distance from the point to the axes intersection
        // *the top left corner of a cell
        _size_delta = point_distance(0, _step_2, 0, (_cell_2 * _cell_size));
        
        // if the other movement is negative
        if (_move_2 < 0)
        {
            // subtract the distance to the other side of the cell
            // *right side of the cell if the x movement is negative
            // *bottom side of the cell if y movement is negative
            _size_delta = _cell_size - _size_delta;
        }
        
        // get the total distance to check
        _size_target = (_size + _cell_size + 1);
        
        // while the target size hasn't been reached and test can be performed
        while (_size_delta < _size_target && (_test_h || _test_v))
        {
            // check tile collision
            _tile_at_point = 0;
            if (_axis == 0)
            {
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_1, _cell_2) & tile_index_mask;
            }
            else if (_axis == 1)
            {
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_2, _cell_1) & tile_index_mask;
            }
            
            if (_tile_at_point == 1)
            {
                // reset collision state
                _collision = false;
                
                // if the movement is postive
                // and the new point does not exceed the target
                if (_move_1 > 0 && _step_1 < _end_1)
                {
                    _collision = true;
                }
                
                // else, if the movement is negative
                // and the new point does not exceed the target
                else if (_move_1 < 0 && _step_1 > _end_1)
                {
                    _collision = true;
                }
                
                if (_collision)
                {
                    // update the movement value and target
                    _new_move_1 = _step_1 - _start_1;
                    _end_1 = _start_1 + _new_move_1;
                    
                    // if the other movement is positive
                    // and the new point does not exceed the target
                    if (_move_2 > 0 && _step_2 < _end_2)
                    {
                        // update the other movement value and target
                        _new_move_2 = _step_2 - _start_2;
                        _end_2 = _start_2 + _new_move_2;
                    }
                    
                    // else, if the other movement is negative
                    // and the new point does not exceed the target
                    else if (_move_2 < 0 && _step_2 > _end_2)
                    {
                        // update the other movement value and target
                        _new_move_2 = _step_2 - _start_2;
                        _end_2 = _start_2 + _new_move_2;
                    }
                    
                    // if horizontal test
                    if (_axis == 0)
                    {
                        // update collision states
                        _collision_h = true;
                        _test_h = false;
                        
                        // update movement values
                        _new_move_h = _new_move_1;
                        _new_move_v = _new_move_2;
                    }
                    
                    // else, if a veritcal test
                    else if (_axis == 1)
                    {
                        // update collision states
                        _collision_v = true;
                        _test_v = false;
                        
                        // update movement values
                        _new_move_h = _new_move_2;
                        _new_move_v = _new_move_1;
                    }

                    
                }
                
            }
            
            // move the cell to the next intersection along the side of the object
            _cell_2 = _cell_2 + (_move_2 >= 0 ? -1 : 1);
            
            // increase the distance traveled
            _size_delta += _cell_size;
        }
        
        // if horizontal collision was checked during this step and no collision occurred
        if (_axis == 0 && _collision_h == false)
        {
            // move along the ray towards the next intersection
            _step_1 = round(_step_1 + (_cell_size * sign(_move_1)));
            
            // if there is slope
            if (_slope != 0)
            {
                // find the new y point
                _step_2 = (_slope * (_step_1 - _start_1)) + _start_2;   
            }
            
            // capture the current point
            // *to use during the next horizontal test
            _step_h_x = _step_1;
            _step_h_y = _step_2;
            
            // capture the new end point
            // *in case collision occurred and was updated
            _end_h = _end_1;
            _end_v = _end_2;
            
            // update the horizontal distance traveled
            _ray_delta_h = point_distance(_start_1, _start_2, _step_1, _step_2);
            
            // if the distance along the ray has exceeded the target
            if (_ray_delta_h > _ray_target)
            {
                // no more horizontal test
                _test_h = false;
            }
            
        }
        
        // else, if vertical collision was checked during this step and no collision occurred
        else if (_axis == 1 && _collision_v == false)
        {
            // move along the ray towards the next intersection
            _step_1 = round(_step_1 + (_cell_size * sign(_move_1)));
            
            // if there is slope
            if (_slope != 0)
            {
                // find the new x point
                _step_2 = ((_step_1 - _start_1) / _slope) + _start_2;
            }
            
            // capture the current point
            // *to use during the next vertical test
            _step_v_x = _step_2;
            _step_v_y = _step_1;
            
            // capture the new end point
            // *in case collision occurred and was updated
            _end_h = _end_2;
            _end_v = _end_1;
            
            // update the vertical distance traveled
            _ray_delta_v = point_distance(_start_2, _start_1, _step_2, _step_1);
            
            // if the distance along the ray has exceeded the target
            if (_ray_delta_v > _ray_target)
            {
                // no more vertical test
                _test_v = false;
            }
            
        }
        
        // else, unforeseen loop condition
        else
        {
            break;
        }
        
    }
    
}


/**
 * Update Values
 *
 */

// update the ds_list
_move_list[| 0] = _new_move_h;
_move_list[| 1] = _new_move_v;

