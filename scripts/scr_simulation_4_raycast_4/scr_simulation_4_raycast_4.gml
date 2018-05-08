/// @function scr_simulation_4_raycast_2(x1, y1, move_list, tilemap_layer, tile_size, bbox_width, bbox_height);
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
    var _collision, _slope_collision;
    var _tile_solid, _tile_one_way;
    var _tile_slope_45_1, _tile_slope_45_2;
    
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
            
            _tile_solid = tile_solid;
            _tile_one_way = (_move_h > 0 ? tile_solid_east : tile_solid_west);
            _tile_slope_45_1 = (_move_h > 0 ? tile_solid_45_se : tile_solid_45_sw);
            _tile_slope_45_2 = (_move_h > 0 ? tile_solid_45_ne : tile_solid_45_nw);
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
            
            _tile_solid = tile_solid;
            _tile_one_way = (_move_v > 0 ? tile_solid_south : tile_solid_north);
            _tile_slope_45_1 = (_move_v > 0 ? tile_solid_45_se : tile_solid_45_sw);
            _tile_slope_45_2 = (_move_v > 0 ? tile_solid_45_ne : tile_solid_45_nw);
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
        //while (_size_delta < _size_target && (_test_h || _test_v))
        
        // while the target size hasn't been reached
        // *with slope detection included, every side collision must be tested to find the closest
        while (_size_delta < _size_target)
        {
            // capture the cell
            var _list = ds_list_create();
            if (_axis == 1) ds_list_add(_list, (_cell_2 * _cell_size), (_cell_1 * _cell_size), global.COLLISION_V_COLOR);
            else ds_list_add(_list, (_cell_1 * _cell_size), (_cell_2 * _cell_size), global.COLLISION_H_COLOR);
            
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            
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
            
            //if (_tile_at_point == 1)
            if (_tile_at_point == _tile_solid || _tile_at_point == _tile_one_way || _tile_at_point == _tile_slope_45_1 || _tile_at_point == _tile_slope_45_2)
            {
                // reset collision state
                _collision = false;
                _slope_collision = false;
                
                // move_h: _tile_slope_45_1 = (_move_v > 0 ? tile_solid_45_se : tile_solid_45_sw);
                // move_v: _tile_slope_45_1 = (_move_h > 0 ? tile_solid_45_se : tile_solid_45_sw);
                if ( _tile_at_point == _tile_slope_45_1)
                {
                    _slope_collision = true;
                    
                    // if horizontal test
                    if (_axis == 0)
                    {
                        var x1 = _start_1;
                        var y1 = _start_2;
                        
                        var x2 = (_cell_1 * _cell_size);
                        var y2 = (_cell_2 * _cell_size);
                        
                        var m1 = _slope;
                        var m2 = 0;
                        
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
                        
                        // if the slopes are not the same
                        // *if the slopes were the same the lines would never cross
                        if (m1 != m2)
                        {
                            // find the y-intercepts for both lines
                            var b1 = y1 - (m1 * x1);
                            var b2 = y2 - (m2 * x2);
                            
                            // find the point where the lines meet
                            var xx = (b2 - b1) / (m1 - m2);
                            var yy = (m1 * xx) + b1;
                            
                            // if colliding with the exact corner of the sloped tile
                            // *it would end up rounding down to being the tile direclty beneath it
                            if (xx == x2 && yy == y2)
                            {
                                _slope_collision = false;
                                
                                // the ray is colliding with the sloped tile
                                _step_1 = xx;
                                _step_2 = yy - (_move_v < 0 ? (_size + 1) : 0);
                                
                                var _list = ds_list_create();
                                ds_list_add(_list, xx, yy, global.COLLISION_SLOPE_COLOR);
                                ds_list_add(global.GUI_AXIS_POINTS, _list);
                                ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
                            }
                            
                            else
                            {
                                // find the cell where the lines intercept
                                var cell_xx = floor(xx / _cell_size);
                                var cell_yy = floor(yy / _cell_size);
                            
                                // if the lines intercept within the cell this slope occupies
                                if (_cell_1 == cell_xx && _cell_2 == cell_yy)
                                {
                                    // if the distance to the intercept point does not exceede the maximum target distance
                                    if (point_distance(x1, y1, xx, yy) < _ray_target)
                                    {
                                        _slope_collision = false;
                                    
                                        // the ray is colliding with the sloped tile
                                        _step_1 = xx;
                                        _step_2 = yy - (_move_v < 0 ? _size+1 : 0);
                                    
                                        var _list = ds_list_create();
                                        ds_list_add(_list, xx, yy, global.COLLISION_SLOPE_COLOR);
                                        ds_list_add(global.GUI_AXIS_POINTS, _list);
                                        ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
                                    }
                                
                                }
                            }
                            
                        }
                        
                    }
                    
                    // else, if vertical test
                    else if (_axis == 1)
                    {
                        // DO STUFF HERE
                    }
                    
                }
                
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
                
                //if (_collision)
                if (_collision && ! _slope_collision)
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
            // *if collision occurred and it updated
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
            // *if collision occurred and it updated
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

