/// @function scr_simulation_22_raycast(x, y, move_h, move_v);
/// @param {number} x       - the x position to start
/// @param {number} y       - the y position to start
/// @param {number} move_h  - the horizontal distance to move
/// @param {number} move_v  - the vertical distance to move


// drawing states
var _capture_step_points = false;
var _capture_step_tiles_h = false;
var _capture_step_tiles_v = false;
var _capture_step_special_tiles = true;
var _capture_collision_tiles = true;


/**
 * Tile Based Collision Test
 *
 * Cast a ray from the top left corner of an object checking every horizontal and veritcal intersection for collision with a tile.
 * At each horizontal intersection, check every tile the height of the bounding box (of the instance) would pass through.
 * At each vertical intersection, check every tile the width of the bounding box (of the instance) would pass through.
 *
 * Instead of creating and returning an array every time this script is called, it relies on the instance calling it to have a number of variables that can be read and updated.
 *
 * Instance Variables to Read:
 *  boolean     has_gravity
 *  number      bbox_width
 *  number      bbox_height
 *  real        collision_tilemap
 *  number      tile_size
 *  number      tile_solid
 *  number      tile_solid_east
 *  number      tile_solid_west
 *  number      tile_solid_south
 *  number      tile_solid_north
 *
 * Instance Variables to Update:
 *  number      raycast_move_h
 *  number      raycast_move_v
 *  number      raycast_next_move_h
 *  number      raycast_next_move_v
 *  boolean     raycast_collision_h
 *  boolean     raycast_collision_v
 *  boolean     raycast_collision_slope
 *  boolean     raycast_collision_floor
 *  boolean     raycast_collision_ceiling
 *
 * The "has_gravity" value stores the state of how the instance interacts with collision tiles.
 * The "bbox_width" and "bbox_height" values store the size of the bounding box of the instance calling this script. 
 * The "collision_tilemap" values points to the tilemap layer containing the tiles used for collision test.
 * The "tile_size" value stores the size in pixels of the tiles in the collision tilemap.
 * The "tile_solid" value stores the index of the tile that is solid from every direction.
 * The "tile_solid_east" value stores the index of the tile that is only solid on the eastern side.
 * The "tile_solid_west" value stores the index of the tile that is only solid on the western side.
 * The "tile_solid_south" value stores the index of the tile that is only solid on the southern side.
 * The "tile_solid_north" value stores the index of the tile that is only solid on the northern side.
 *
 * The "raycast_move_h" and "raycast_move_v" values represent the total distance the instance can move before a collision occurs.
 * The "raycast_next_move_h" and "raycast_next_move_h" values represent the remaining distance to redirect the ray after a collision.
 * The "raycast_collision_h" and "raycast_collision_v" values store the horizontal and vertical collision states.
 * The "raycast_collision_slope" value stores the slope collision state.
 * The "raycast_collision_floor" and "raycast_collision_ceiling" values store the states of a vertical (or slope) collision.
 */

// starting position
// *should always be the top left of the bounding box
var _start_x = argument0;
var _start_y = argument1;

// movement values
// *these values update their instance variable equivalents at the end of this script
var _raycast_move_h = argument2;
var _raycast_move_v = argument3;
var _raycast_next_move_h = 0;
var _raycast_next_move_v = 0;

// if there is no movement
if (_raycast_move_h == 0 && _raycast_move_v == 0)
{
    exit;
}

// collision states
var _collision = false;
var _collision_slope = false;
var _collision_floor = false;
var _collision_ceiling = false;

// collision states
// *these values update their instance variable equivalents at the end of this script
var _raycast_collision_h = false;
var _raycast_collision_v = false;
var _raycast_collision_slope = false;
var _raycast_collision_floor = false;
var _raycast_collision_ceiling = false;

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
var _width = (bbox_width + 1);
var _height = (bbox_height + 1);
var _offset_x = (_raycast_move_h > 0 ? _width : 0);
var _offset_y = (_raycast_move_v > 0 ? _height : 0);

// horizontal rays
if (_raycast_move_h != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _offset_x), _start_y, (_start_x + _offset_x + _raycast_move_h), (_start_y + _raycast_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
    
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _offset_x), (_start_y + _height), (_start_x + _offset_x + _raycast_move_h), (_start_y + _height + _raycast_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}

// vertical rays
if (_raycast_move_v != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, _start_x, (_start_y + _offset_y), (_start_x + _raycast_move_h), (_start_y + _offset_y + _raycast_move_v), global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
    
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _width), (_start_y + _offset_y), (_start_x + _width + _raycast_move_h), (_start_y + _offset_y + _raycast_move_v), global.COLLISION_V_COLOR);
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
var _collision_move_h, _collision_move_v;

// the tests that can be performed
var _test_h = (_raycast_move_h == 0 ? false : true);
var _test_v = (_raycast_move_v == 0 ? false : true);

// the slope of the line
// *using the term "gradient" since "slope" can also refer to a type of tile
var _gradient = 0;
if (_raycast_move_h != 0 && _raycast_move_v != 0)
{
    _gradient = (_raycast_move_v / _raycast_move_h);
}

// the distances traveled along the ray
var _ray_delta_h = 0;
var _ray_delta_v = 0;

// the maximum distance of the ray
var _ray_target = point_distance(0, 0, _raycast_move_h, _raycast_move_v);

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
var _tile_offset_x = (_raycast_move_h > 0 ? 1 : 0);
var _tile_offset_y = (_raycast_move_v > 0 ? 1 : 0);

// tile values
var _tile_at_point;
var _tile_solid = tile_solid;
var _tile_h_one_way = (_raycast_move_h > 0 ? tile_solid_east : tile_solid_west);
var _tile_v_one_way = (_raycast_move_v > 0 ? tile_solid_south : tile_solid_north);


/**
 * Move Along the Ray Testing for Collisions
 *
 * Move towards each horizontal and veritcal intersection until a tile is found.
 * At each intersection, test the width or height of the bounding box, checking for tiles along the opposite intersection.
 */

// while test can be performed and no collisions have occurred
while ((_test_h || _test_v) && ! _raycast_collision_h && ! _raycast_collision_v)
{
    // if the horizontal collision test can be performed
    // (and either can't test veritcal collision or the horizontal test is closer than the vertical test)
    if (_test_h && ( ! _test_v || _ray_delta_h <= _ray_delta_v))
    {
        // reset collision values
        _collision = false;
        _collision_slope = false;
        _collision_x = 0;
        _collision_y = 0;
        _collision_move_h = 0;
        _collision_move_v = 0;
        _collision_floor = false;
        _collision_ceiling = false;
        
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
        if (_raycast_move_h < 0 && _remainder_x == 0)
        {
            _cell_x -= 1;
        }
            
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the instance is moving up, shift the tile's y position up by one
        if (_raycast_move_v < 0 && _remainder_y == 0)
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
            if (_raycast_move_v <= 0)
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
                    _collision = true;
                    _collision_slope = false;
                    _collision_x = _step_h_x - _offset_x;
                    _collision_y = _step_h_y;
                    _collision_move_h = 0;
                    _collision_move_v = _raycast_move_v - (_collision_y - _start_y);
                    _collision_floor = false;
                    _collision_ceiling = false;
                    break; // exit for loop
                }
            }
            
        }
        
        // if a collision occurred this step
        // *this is a special case that only applies to the horizontal test because it happens before the vertical test
        // *if a horizontal collision occurred against the exact corner of a tile below the lowest point, but the space above that tile is clear
        // *or if a horizontal collision occurred against the exact corner of a tile above the highest point, but the space below that tile is clear
        // *the instance should vertically collide against the corner of the tile, then continue straight horizontally in the direction it was traveling since the space is clear
        // *otherwise, its a horizontal collision, and if there are tiles directly above or below, it would also resolve a vertical collision, stopping the instance at that corner
        if (_collision && ! _collision_slope)
        {
            // get the highest or lowest point on the bounding box
            // *depending on the vertical movement
            var _step_h_y2 = _step_h_y + _offset_y;
            
            // if the point is on a vertical intersection
            if ((_step_h_y2 mod _tile_size) == 0)
            {
                var _cell_y2 = floor(_step_h_y2 / _tile_size) + (_raycast_move_v > 0 ? -1 : 0);
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y2) & tile_index_mask;
                
                // if this tile is not a solid tile or one that is solid from this side
                if (_tile_at_point != _tile_solid && _tile_at_point != _tile_h_one_way)
                {
                    // ignore this collision and continue testing
                    _collision = false;
                    
                    if (_capture_step_special_tiles)
                    {
                        var _list = ds_list_create();
                        ds_list_add(_list, (_cell_x * _tile_size), (_cell_y2 * _tile_size), global.COLLISION_HV_COLOR);
                        ds_list_add(global.DRAW_CELLS, _list);
                        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
                    }
                    
                }
                    
            }
            
        }
        
        // if no horizontal collision, check for slope collision
        if ( ! _collision)
        {
            // check the tile at the top most point
            _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
            if (_tile_at_point != _tile_solid && _tile_at_point != _tile_h_one_way)
            {
                // if colliding with a sloped tile, and a point on the slope is found
                if (script_execute(script_slope_collision, _start_x, _start_y, _raycast_move_h, _raycast_move_v, _tile_at_point, _cell_x, _cell_y, _gradient, _ray_target_h))
                {
                    _collision = true;
                    _collision_slope = true;
                    _collision_x = raycast_slope_x;
                    _collision_y = raycast_slope_y;
                    _collision_move_h = raycast_slope_move_h;
                    _collision_move_v = raycast_slope_move_v;
                    _collision_floor = raycast_slope_collision_floor;
                    _collision_ceiling = raycast_slope_collision_ceiling;
                }
            }
            
            if (_cell_max_y != _cell_y)
            {
                // check the tile at the bottom most point
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_max_y) & tile_index_mask;
                if (_tile_at_point != _tile_solid && _tile_at_point != _tile_h_one_way)
                {
                    // if colliding with a sloped tile, and a point on the slope is found
                    if (script_execute(script_slope_collision, _start_x, _start_y, _raycast_move_h, _raycast_move_v, _tile_at_point, _cell_x, _cell_max_y, _gradient, _ray_target_h))
                    {
                        _collision = true;
                        _collision_slope = true;
                        _collision_x = raycast_slope_x;
                        _collision_y = raycast_slope_y;
                        _collision_move_h = raycast_slope_move_h;
                        _collision_move_v = raycast_slope_move_v;
                        _collision_floor = raycast_slope_collision_floor;
                        _collision_ceiling = raycast_slope_collision_ceiling;
                    }
                }
            }
            
        }
        
        // if a collision occurred during this step
        if (_collision)
        {
            // update the horizontal target distance
            _ray_target_h = point_distance(_start_x, _start_y, _collision_x, _collision_y);
            
            // if less than the vertical target distance
            if (_ray_target_h < _ray_target_v)
            {
                // update collision states
                _raycast_collision_h = true;
                _raycast_collision_v = false;
                _raycast_collision_slope = _collision_slope;
                _raycast_collision_floor = _collision_floor;
                _raycast_collision_ceiling = _collision_ceiling;
                
                // update the movement values
                _raycast_move_h = (_collision_x - _start_x);
                _raycast_move_v = (_collision_y - _start_y);
                
                // update the redirection values for another test
                _raycast_next_move_h = _collision_move_h;
                _raycast_next_move_v = _collision_move_v;
            }
            
            _test_h = false;
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
        // reset collision values
        _collision = false;
        _collision_slope = false;
        _collision_x = 0;
        _collision_y = 0;
        _collision_move_h = 0;
        _collision_move_v = 0;
        _collision_floor = false;
        _collision_ceiling = false;
        
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
        if (_raycast_move_h < 0 && _remainder_x == 0)
        {
            _cell_x -= 1;
        }
        
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the instance is moving up, shift the tile's y position up by one
        if (_raycast_move_v < 0 && _remainder_y == 0)
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
            if (_raycast_move_h <= 0)
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
                    _collision = true;
                    _collision_slope = false;
                    _collision_x = _step_v_x;
                    _collision_y = _step_v_y - _offset_y;
                    _collision_move_h = _raycast_move_h - (_collision_x - _start_x);
                    _collision_move_v = 0;
                    _collision_floor = (_raycast_move_v > 0);
                    _collision_ceiling = (_raycast_move_v < 0);
                    break; // exit for loop
                }
            }
            
        }
        
        // if no vertical collision, check for slope collision
        if ( ! _collision)
        {
            // check the tile at the left most point
            _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
            if (_tile_at_point != _tile_solid && _tile_at_point != _tile_v_one_way)
            {
                // if colliding with a sloped tile, and a point on the slope is found
                if (script_execute(script_slope_collision, _start_x, _start_y, _raycast_move_h, _raycast_move_v, _tile_at_point, _cell_x, _cell_y, _gradient, _ray_target_v))
                {
                    _collision = true;
                    _collision_slope = true;
                    _collision_x = raycast_slope_x;
                    _collision_y = raycast_slope_y;
                    _collision_move_h = raycast_slope_move_h;
                    _collision_move_v = raycast_slope_move_v;
                    _collision_floor = raycast_slope_collision_floor;
                    _collision_ceiling = raycast_slope_collision_ceiling;
                }
            }
            
            if (_cell_max_x != _cell_x)
            {
                // check the tile at the right most point
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_max_x, _cell_y) & tile_index_mask;
                if (_tile_at_point != _tile_solid && _tile_at_point != _tile_v_one_way)
                {
                    // if colliding with a sloped tile, and a point on the slope is found
                    if (script_execute(script_slope_collision, _start_x, _start_y, _raycast_move_h, _raycast_move_v, _tile_at_point, _cell_max_x, _cell_y, _gradient, _ray_target_v))
                    {
                        _collision = true;
                        _collision_slope = true;
                        _collision_x = raycast_slope_x;
                        _collision_y = raycast_slope_y;
                        _collision_move_h = raycast_slope_move_h;
                        _collision_move_v = raycast_slope_move_v;
                        _collision_floor = raycast_slope_collision_floor;
                        _collision_ceiling = raycast_slope_collision_ceiling;
                    }
                }
            }
            
        }
        
        // if a collision occurred during this step
        if (_collision)
        {
            // update the vertical target distance
            _ray_target_v = point_distance(_start_x, _start_y, _collision_x, _collision_y);
            
            // if less than the horizontal target distance
            if (_ray_target_v < _ray_target_h)
            {
                // update collision states
                _raycast_collision_h = false;
                _raycast_collision_v = true;
                _raycast_collision_slope = _collision_slope;
                _raycast_collision_floor = _collision_floor;
                _raycast_collision_ceiling = _collision_ceiling;
                
                // update the movement values
                _raycast_move_h = (_collision_x - _start_x);
                _raycast_move_v = (_collision_y - _start_y);
                
                // update the redirection values for another test
                _raycast_next_move_h = _collision_move_h;
                _raycast_next_move_v = _collision_move_v;
            }
            
            _test_v = false;
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
 * Update Instance Values
 *
 */

// update movement values
raycast_move_h = _raycast_move_h;
raycast_move_v = _raycast_move_v;
raycast_next_move_h = _raycast_next_move_h;
raycast_next_move_v = _raycast_next_move_v;

// update collision states
raycast_collision_h = _raycast_collision_h;
raycast_collision_v = _raycast_collision_v;
raycast_collision_slope = _raycast_collision_slope;
raycast_collision_floor = _raycast_collision_floor;
raycast_collision_ceiling = _raycast_collision_ceiling;

