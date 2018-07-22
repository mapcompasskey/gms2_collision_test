/// @function scr_simulation_18_raycast();


/**
 * Tile Based Collision Test
 *
 * Cast a ray from the top left corner of an object checking every horizontal and veritcal intersection for collision with a tile.
 * At each horizontal intersection, check every tile the height of the bounding box (of the instance) would pass through.
 * At each vertical intersection, check every tile the width of the bounding box (of the instance) would pass through.
 */

var _capture_step_points = false;
var _capture_step_tiles_h = false;
var _capture_step_tiles_v = false;
var _capture_step_special_tiles = true;
var _capture_collision_tiles = true;

// if there is no movement
if (raycast_new_move_h == 0 && raycast_new_move_v == 0)
{
    exit;
}
scr_output(" ");
scr_output("raycast_new_move_h", raycast_new_move_h);
scr_output("raycast_new_move_v", raycast_new_move_v);
// starting position (always the top left corner of the bounding box)
var _start_x = raycast_x + sprite_bbox_left;
var _start_y = raycast_y + sprite_bbox_top;

// movement values
var _new_move_h = raycast_new_move_h;
var _new_move_v = raycast_new_move_v;

var _redirect_move_h = 0;
var _redirect_move_v = 0;

// collision states
var _collision_h = false;
var _collision_v = false;
var _collision_slope_h = false;
var _collision_slope_v = false;

// tilemap layer and tile size
var _collision_tilemap = collision_tilemap;
var _tile_size = tile_size;


/**
 * Find the X and Y Offsets
 *
 * Apply offsets when the ray should be shifted to the right side or bottom side of the bounding box.
 * Always add one since the width and height of GML bounding boxes are off by one pixel.
 */

// get the size of the bounding box and offsets
var _height = (bbox_height + 1);
var _width = (bbox_width + 1);
var _offset_x = (_new_move_h > 0 ? _width : 0);
var _offset_y = (_new_move_v > 0 ? _height : 0);

// horizontal rays
if (_new_move_h != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _offset_x), _start_y, (_start_x + _offset_x + _new_move_h), (_start_y + _new_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
    
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _offset_x), (_start_y + _height), (_start_x + _offset_x + _new_move_h), (_start_y + _height + _new_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}

// vertical rays
if (_new_move_v != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, _start_x, (_start_y + _offset_y), (_start_x + _new_move_h), (_start_y + _offset_y + _new_move_v), global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
    
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _width), (_start_y + _offset_y), (_start_x + _width + _new_move_h), (_start_y + _offset_y + _new_move_v), global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}


/**
 * Prepare Values
 *
 */

var _cell_x, _cell_y;
var _cell_max_x, _cell_max_y;
var _step_cell_x, _step_cell_y;
var _size_delta, _size_target;
var _remainder_x, _remainder_y;
var _collision_x, _collision_y;
var _collision_slope_move_h, _collision_slope_move_v;

// the tests that can be performed
var _test_h = (_new_move_h == 0 ? false : true);
var _test_v = (_new_move_v == 0 ? false : true);

// the slope of the line
// *using the term "gradient" since "slope" can also refer to a type of tile
var _gradient = 0;
if (_new_move_h != 0 && _new_move_v != 0)
{
    _gradient = (_new_move_v / _new_move_h);
}

// the distances traveled along the ray
var _ray_delta_h = 0;
var _ray_delta_v = 0;

// the maximum distance of the ray
var _ray_target = point_distance(0, 0, _new_move_h, _new_move_v);

// the distance to the closest collision points
var _ray_target_h = _ray_target;
var _ray_target_v = _ray_target;

// the point to check horizontally
var _step_h_x = (_start_x + _offset_x);
var _step_h_y = _start_y;

// the point to check vertically
var _step_v_x = _start_x;
var _step_v_y = (_start_y + _offset_y);

// tile offsets
var _tile_offset_x = (_new_move_h > 0 ? 1 : 0);
var _tile_offset_y = (_new_move_v > 0 ? 1 : 0);

// tile values
var _tile_at_point;
var _tile_solid = global.TILE_SOLID;
var _tile_h_one_way = (_new_move_h > 0 ? global.TILE_SOLID_EAST : global.TILE_SOLID_WEST);
var _tile_v_one_way = (_new_move_v > 0 ? global.TILE_SOLID_SOUTH : global.TILE_SOLID_NORTH);


/**
 * Move Along the Ray Testing for Collisions
 *
 * Move towards each horizontal and veritcal intersection until a tile is found.
 * At each intersection, test the width or height of the bounding box, checking for tiles along the opposite intersection.
 */

// while test can be performed and no collisions have occurred
while ((_test_h || _test_v) && ! _collision_h && ! _collision_v)
{
    // if the horizontal collision test can be performed
    // (and either can't test veritcal collision or the horizontal test is closer than the vertical test)
    if (_test_h && ( ! _test_v || _ray_delta_h <= _ray_delta_v))
    {
        _collision_x = 0;
        _collision_y = 0;
        _collision_slope_move_h = 0;
        _collision_slope_move_v = 0;
        
        // find the cell the first point occupies
        // *the first point is always the top of the bounding box
        _cell_x = floor(_step_h_x / _tile_size);
        _cell_y = floor(_step_h_y / _tile_size);
        
        // find how far from an interseciton the points are
        // *if the remainder is 0, then they are directly on an intersection
        _remainder_x = _step_h_x mod _tile_size;
        _remainder_y = _step_h_y mod _tile_size;
        
        // if the horizontal movement is negative and the point is on a horizontal intersection
        // *the instance is moving left, shift the tile's x position left by one
        if (_new_move_h < 0 && _remainder_x == 0)
        {
            _cell_x -= 1;
        }
            
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the instance is moving up, shift the tile's y position up by one
        if (_new_move_v < 0 && _remainder_y == 0)
        {
            _cell_y -= 1; 
        }
        
        if (_capture_step_points)
        {
            var _list = ds_list_create();
            ds_list_add(_list, _step_h_x, _step_h_y, global.COLLISION_HV_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            
            var _list = ds_list_create();
            ds_list_add(_list, (_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        }
        
        // find the cell the last point occupies
        // *the last point is always the bottom of the bounding box
        var _cell_max_y = floor((_step_h_y + _height) / _tile_size);
        
        // if the last point is on a vertical intersection
        if ((_step_h_y + _height) mod _tile_size == 0)
        {
            // if the vertical movement is less than or equal to 0
            // *the instance is either not moving vertically or is moving up, shift the cell of the last point up by one
            if (_new_move_v <= 0)
            {
                _cell_max_y -= 1;
            }
        }
        
        // for every horizontal intersection the ray is cast through, check every vertical tile between the top and bottom of the bounding box
        for (_step_cell_y = _cell_y; _step_cell_y <= _cell_max_y; _step_cell_y++)
        {
            if (_capture_step_tiles_h)
            {
                // capture the tile
                var _list = ds_list_create();
                ds_list_add(_list, (_cell_x * _tile_size), (_step_cell_y * _tile_size), global.COLLISION_H_COLOR);
                ds_list_add(global.DRAW_CELLS, _list);
                ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            }
            
            // get the tile at this position
            _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _step_cell_y) & tile_index_mask;
            
            // if this tile is empty space
            if (_tile_at_point == 0)
            {
                continue;
            }
            
            // if colliding with a solid tile or one that is solid from this side
            if (_tile_at_point == _tile_solid || _tile_at_point == _tile_h_one_way)
            {
                // if not the first horizontal test, or if the point is on a horizontal intersection
                if (_ray_delta_h != 0 || _remainder_x == 0)
                {
                    // update the horizontal target distance
                    _ray_target_h = point_distance((_start_x + _offset_x), _start_y, _step_h_x, _step_h_y);
                    if (_ray_target_h <= _ray_target_v)
                    {
                        _collision_h = true;
                        _collision_slope_h = false;
                        _collision_x = _step_h_x;
                        _collision_y = _step_h_y;
                        break;
                    }
                    
                }
            }
            
        }
        
        // if a collision occurred this step
        // *this is a special case that only applies to the horizontal test because it happens before the vertical test
        // *if a horizontal collision occurred against the exact corner of a tile below the lowest point, but the space above that tile is clear
        // *or if a horizontal collision occurred against the exact corner of a tile above the highest point, but the space below that tile is clear
        // *the instance should vertically collide against the corner of the tile, then continue straight horizontally in the direction it was traveling since the space is clear
        // *otherwise, its a horizontal collision, and if there are tiles directly above or below, it would also resolve a vertical collision, stopping the instance at that corner
        if (_collision_h && ! _collision_slope_h)
        {
            // get the highest or lowest point on the bounding box
            // *depending on the vertical movement
            var _step_h_y2 = _step_h_y + _offset_y;
            
            // if the point is on a vertical intersection
            if ((_step_h_y2 mod _tile_size) == 0)
            {
                //var _cell_y2 = floor(_step_h_y2 / _tile_size) + (_new_move_v > 0 ? -1 : 0);
                //_tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y2) & tile_index_mask;
                _cell_y = floor(_step_h_y2 / _tile_size) + (_new_move_v > 0 ? -1 : 0);
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
                
                // if this tile is not a solid tile or one that is solid from this side
                if (_tile_at_point != _tile_solid && _tile_at_point != _tile_h_one_way)
                {
                    // ignore this collision and continue testing
                    _collision_h = false;
                    
                    if (_capture_step_special_tiles)
                    {
                        var _list = ds_list_create();
                        //ds_list_add(_list, (_cell_x * _tile_size), (_cell_y2 * _tile_size), global.COLLISION_HV_COLOR);
                        ds_list_add(_list, (_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_HV_COLOR);
                        ds_list_add(global.DRAW_CELLS, _list);
                        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
                    }
                    
                }
                    
            }
            
        }
        
        // if no horizontal collision, check for slope collision
        if ( ! _collision_h)
        {
            // check the tile at the top most point
            _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
            if (_tile_at_point != _tile_solid && _tile_at_point != _tile_h_one_way)
            {
                // prepare the slope collision test
                raycast_slope_x = _step_h_x;
                raycast_slope_y = _step_h_y;
                
                // if colliding with a sloped tile, and a point on the slope is found
                if (script_execute(script_slope_collision, _tile_at_point, _cell_x, _cell_y, _gradient, _ray_target_h))
                {
                    //_ray_target_h = point_distance(0, 0, raycast_slope_move_h, raycast_slope_move_v);
                    //if (_ray_target_h <= _ray_target_v)
                    //{
                        _collision_h = true;
                        _collision_slope_h = true;
                        _collision_x = raycast_slope_x;
                        _collision_y = raycast_slope_y;
                        _collision_slope_move_h = raycast_slope_move_h;
                        _collision_slope_move_v = raycast_slope_move_v;
                    //}
                }
            }
            
            if (_cell_max_y != _cell_y)
            {
                // check the tile at the bottom most point
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_max_y) & tile_index_mask;
                if (_tile_at_point != _tile_solid && _tile_at_point != _tile_h_one_way)
                {
                    // prepare the slope collision test
                    raycast_slope_x = _step_h_x;
                    raycast_slope_y = _step_h_y;
                    
                    // if colliding with a sloped tile, and a point on the slope is found
                    if (script_execute(script_slope_collision, _tile_at_point, _cell_x, _cell_max_y, _gradient, _ray_target_h))
                    {
                        //_ray_target_h = point_distance(0, 0, raycast_slope_move_h, raycast_slope_move_v);
                        //if (_ray_target_h <= _ray_target_v)
                        //{
                            _collision_h = true;
                            _collision_slope_h = true;
                            _collision_x = raycast_slope_x;
                            _collision_y = raycast_slope_y;
                            _collision_slope_move_h = raycast_slope_move_h;
                            _collision_slope_move_v = raycast_slope_move_v;
                        //}
                    }
                }
            }
            
        }
        
        // if a collision occurred during this step
        if (_collision_h)
        {
            _test_h = false;
            
            if (_collision_slope_h)
            {
                // update the movement values
                _new_move_h = _collision_x - _start_x;
                _new_move_v = _collision_y - _start_y;
                
                // update the redirection values for another test
                _redirect_move_h = _collision_slope_move_h;
                _redirect_move_v = _collision_slope_move_v;
            }
            else
            {
                // update the movement values
                _new_move_h = _collision_x - (_start_x + _offset_x);
                _new_move_v = _collision_y - _start_y;
                
                // update the redirection values for another test
                _redirect_move_h = 0;
                _redirect_move_v = (raycast_new_move_v - _new_move_v);
            }
        }
        
        // else, no collision occurred during this step
        else
        {
            // move to the next horizontal intersection
            _step_h_x = round((_cell_x + _tile_offset_x) * _tile_size);
            
            // if there is slope
            if (_gradient != 0)
            {
                // find the new y point
                _step_h_y = (_gradient * (_step_h_x - (_start_x + _offset_x))) + _start_y;
                
                // if the y position is off a vertical intersection by a tiny amount, round towards the intersection
                // *GameMaker returns inconsistent solutions when calculating the sin/cos of an angle
                var _remainder_h_y = (_step_h_y mod _tile_size);
                if (_remainder_h_y < 0.0001) _step_h_y = floor(_step_h_y);
                if (_tile_size - _remainder_h_y < 0.0001) _step_h_y = ceil(_step_h_y);
            }
            
            // update the distance to the next vertical intersection
            _ray_delta_h = point_distance((_start_x + _offset_x), _start_y, _step_h_x, _step_h_y);
            
            // continue collision until the target distance is reached
            _test_h = (_ray_delta_h < _ray_target);
        }
        
    }
    
    // else, if vertical collision test can be performed
    // (and either can't test horizontal collision or the vertical test is closer than the horizontal test)
    else if  (_test_v && ( ! _test_h || _ray_delta_v <= _ray_delta_h))
    {
        _collision_x = 0;
        _collision_y = 0;
        _collision_slope_move_h = 0;
        _collision_slope_move_v = 0;
        
        // find the cell the first point occupies
        // *the first point is always the left side of the bounding box
        _cell_x = floor(_step_v_x / _tile_size);
        _cell_y = floor(_step_v_y / _tile_size);
        
        // find how far from an interseciton the points are
        // *if the remainder is 0, then they are directly on an intersection
        _remainder_x = _step_v_x mod _tile_size;
        _remainder_y = _step_v_y mod _tile_size;
        
        // if the horizontal movement is negative and the point is on a horizontal intersection
        // *the instance is moving left, shift the tile's x position left by one
        if (_new_move_h < 0 && _remainder_x == 0)
        {
            _cell_x -= 1;
        }
        
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the instance is moving up, shift the tile's y position up by one
        if (_new_move_v < 0 && _remainder_y == 0)
        {
            _cell_y -= 1; 
        }
        
        if (_capture_step_points)
        {
            var _list = ds_list_create();
            ds_list_add(_list, _step_v_x, _step_v_y, global.COLLISION_HV_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            
            var _list = ds_list_create();
            ds_list_add(_list, (_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_V_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        }
        
        // find the cell the last point occupies
        // *the last point is always the right side of the bounding box
        var _cell_max_x = floor((_step_v_x + _width) / _tile_size);
        
        // if the last point is on a horizontal intersection
        if ((_step_v_x + _width) mod _tile_size == 0)
        {
            // if the horizontal movement is less than or equal to 0
            // *the instance is either not moving horizontally or is moving to the left, shift the cell of the last point left by one
            if (_new_move_h <= 0)
            {
                _cell_max_x -= 1;
            }
        }
        
        // for every vertical intersection the ray is cast through, check every horizontal tile between the left and right sides of the bounding box
        for (_step_cell_x = _cell_x; _step_cell_x <= _cell_max_x; _step_cell_x++)
        {
            if (_capture_step_tiles_v)
            {
                // capture the tile
                var _list = ds_list_create();
                ds_list_add(_list, (_step_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_V_COLOR);
                ds_list_add(global.DRAW_CELLS, _list);
                ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            }
            
            // get the tile at this position
            _tile_at_point = tilemap_get(_collision_tilemap, _step_cell_x, _cell_y) & tile_index_mask;
            
            // if this tile is empty space
            if (_tile_at_point == 0)
            {
                continue;
            }
            
            // if colliding with a solid tile or one that is solid from this side
            if (_tile_at_point == _tile_solid || _tile_at_point == _tile_v_one_way)
            {
                // if not the first vertical test, or if the point is on a vertical intersection
                if (_ray_delta_v != 0 || _remainder_y == 0)
                {
                    // update the vertical target distance
                    _ray_target_v = point_distance(_start_x, (_start_y + _offset_y), _step_v_x, _step_v_y);
                    if (_ray_target_v <= _ray_target_h)
                    {
                        _collision_v = true;
                        _collision_slope_v = false;
                        _collision_x = _step_v_x;
                        _collision_y = _step_v_y;
                        break; // exit for loop
                    }
                    
                }
            }
            
        }
        
        // if no vertical collision, check for slope collision
        if ( ! _collision_v)
        {
            // check the tile at the left most point
            _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
            if (_tile_at_point != _tile_solid && _tile_at_point != _tile_v_one_way)
            {
                // prepare the slope collision test
                raycast_slope_x = _step_v_x;
                raycast_slope_y = _step_v_y;
                
                // if colliding with a sloped tile, and a point on the slope is found
                if (script_execute(script_slope_collision, _tile_at_point, _cell_x, _cell_y, _gradient, _ray_target_v))
                {
                    _collision_v = true;
                    _collision_slope_v = true;
                    _collision_x = raycast_slope_x;
                    _collision_y = raycast_slope_y;
                    _collision_slope_move_h = raycast_slope_move_h;
                    _collision_slope_move_v = raycast_slope_move_v;
                }
            }
            
            if (_cell_max_x != _cell_x)
            {
                // check the tile at the right most point
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_max_x, _cell_y) & tile_index_mask;
                if (_tile_at_point != _tile_solid && _tile_at_point != _tile_v_one_way)
                {
                    // prepare the slope collision test
                    raycast_slope_x = _step_v_x;
                    raycast_slope_y = _step_v_y;
                    
                    // if colliding with a sloped tile, and a point on the slope is found
                    if (script_execute(script_slope_collision, _tile_at_point, _cell_max_x, _cell_y, _gradient, _ray_target_v))
                    {
                        _collision_v = true;
                        _collision_slope_v = true;
                        _collision_x = raycast_slope_x;
                        _collision_y = raycast_slope_y;
                        _collision_slope_move_h = raycast_slope_move_h;
                        _collision_slope_move_v = raycast_slope_move_v;
                    }
                }
            }
            
        }
        
        // if a collision occurred during this step
        if (_collision_v)
        {
            _test_v = false;
            
            if (_collision_slope_v)
            {
                // update the movement values
                _new_move_h = _collision_x - _start_x;
                _new_move_v = _collision_y - _start_y;
                
                // update the redirection values for another test
                _redirect_move_h = _collision_slope_move_h;
                _redirect_move_v = _collision_slope_move_v;
            }
            else
            {
                // update the movement values
                _new_move_h = _collision_x - _start_x;
                _new_move_v = _collision_y - (_start_y + _offset_y);
                
                // update the redirection values for another test
                _redirect_move_h = (raycast_new_move_h - _new_move_h);
                _redirect_move_v = 0;
            }
        }
        
        // else, no collision occurred during this step
        else 
        {
            // move to the next vertical intersection
            _step_v_y = round((_cell_y + _tile_offset_y) * _tile_size);
            
            // if there is slope
            if (_gradient != 0)
            {
                // find the new y point
                _step_v_x = ((_step_v_y - (_start_y + _offset_y)) / _gradient) + _start_x;
                
                // if the x position is off a horizontal intersection by a tiny amount, round towards the intersection
                // *GameMaker returns inconsistent solutions when calculating the sin/cos of an angle
                var _remainder_v_x = (_step_v_x mod _tile_size);
                if (_remainder_v_x < 0.0001) _step_v_x = floor(_step_v_x);
                if (_tile_size - _remainder_v_x < 0.0001) _step_v_x = ceil(_step_v_x);
            }
            
            // update the distance to the next vertical intersection
            _ray_delta_v = point_distance(_start_x, (_start_y + _offset_y), _step_v_x, _step_v_y);
            
            // continue collision until the target distance is reached
            _test_v = (_ray_delta_v < _ray_target);
        }
        
    }
    
    // else, unexpected condition
    else
    {
        break;
    }
    
}


/**
 * Update Values
 *
 */

// update movement values
raycast_new_move_h = _new_move_h;
raycast_new_move_v = _new_move_v;
raycast_redirect_move_h = _redirect_move_h;
raycast_redirect_move_v = _redirect_move_v;

// update collision states
raycast_collision_h = _collision_h;
raycast_collision_v = _collision_v;
raycast_collision_slope = (_collision_slope_h || _collision_slope_v);

