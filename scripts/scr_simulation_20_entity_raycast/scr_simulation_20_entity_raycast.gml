/// @function scr_simulation_20_entity_raycast();


/**
 * Tile Based Collision Test
 *
 * Cast a ray from the top left corner of an instance and check every horizontal and veritcal intersection for collision with a tile.
 * At each horizontal intersection, check every tile the height of the instance's bounding box would pass through.
 * At each vertical intersection, check every tile the width of the instance's bounding box would pass through.
 *
 * Required Instance Variables:
 *  number      raycast_x
 *  number      raycast_y
 *  number      raycast_new_move_h
 *  number      raycast_new_move_v
 *  number      raycast_redirect_move_h
 *  number      raycast_redirect_move_v
 *  boolean     raycast_collision_h
 *  boolean     raycast_collision_v
 *  boolean     raycast_collision_floor
 *  boolean     raycast_collision_ceiling
 *
 *  number      sprite_bbox_left
 *  number      sprite_bbox_top
 *  number      bbox_height
 *  number      bbox_width
 *  real        collision_tilemap
 *  number      tile_size
 *  number      tile_solid
 *  number      tile_solid_east
 *  number      tile_solid_west
 *  number      tile_solid_south
 *  number      tile_solid_north
 *
 * Required Instance Variables (Slope):
 *  real        script_slope_collision
 *  boolean     raycast_collision_slope
 *  number      raycast_slope_x
 *  number      raycast_slope_y
 *  number      raycast_slope_move_h
 *  number      raycast_slope_move_v
 *  boolean     raycast_slope_collision_floor
 *  boolean     raycast_slope_collision_ceiling
 *
 * The point (raycast_x, raycast_y) is the coordinate where the ray is cast from.
 * The values raycast_new_move_h and raycast_new_move_v represent the horizontal and vertical distance the ray will travel.
 * If a collision occurs, the values raycast_new_move_h and raycast_new_move_v will be updated to reach the point of collision.
 * If a collision occurs, the values raycast_redirect_move_h and raycast_redirect_move_v represent the distances the ray will travel during the next collision test.
 * The values raycast_collision_h and raycast_collision_v track whether a horizontal or vertical collision occurred.
 * If collision occurs, the values raycast_collision_floor and raycast_collision_ceiling store the state of the type of tile that was collided with.
 
 * The values sprite_bbox_left and sprite_bbox_top are the pixel offsets of the bounding box of the instance calling this script.
 * The values bbox_width and bbox_height represent the size of the bounding box of the instance calling this script.
 * The tile_size value represents the size (in pixels) of the tiles being tested against.
 
 
 * If collision occurs, the values raycast_slope_collision_floor and raycast_slope_collision_ceiling store the state of the type of tile that was collided with.
 * If collision occurs, the point (raycast_slope_x, raycast_slope_y) stores the coordinate where the collision occurred.
 */

// if there is no movement
if (raycast_new_move_h == 0 && raycast_new_move_v == 0)
{
    exit;
}

// starting position (always the top left corner of the bounding box)
var _start_x = raycast_x + sprite_bbox_left;
var _start_y = raycast_y + sprite_bbox_top;

// movement values
var _raycast_new_move_h = raycast_new_move_h;
var _raycast_new_move_v = raycast_new_move_v;
var _raycast_redirect_move_h = 0;
var _raycast_redirect_move_v = 0;

// collision states
var _collision = false;
var _collision_slope = false;
var _collision_floor = false;
var _collision_ceiling = false;

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
var _height = (bbox_height + 1);
var _width = (bbox_width + 1);
var _offset_x = (_raycast_new_move_h > 0 ? _width : 0);
var _offset_y = (_raycast_new_move_v > 0 ? _height : 0);


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
var _test_h = (_raycast_new_move_h == 0 ? false : true);
var _test_v = (_raycast_new_move_v == 0 ? false : true);

// the slope of the line
// *using the term "gradient" since "slope" can also refer to a type of tile
var _gradient = 0;
if (_raycast_new_move_h != 0 && _raycast_new_move_v != 0)
{
    _gradient = (_raycast_new_move_v / _raycast_new_move_h);
}

// the distances traveled along the ray
var _ray_delta_h = 0;
var _ray_delta_v = 0;

// the maximum distance of the ray
var _ray_target = point_distance(0, 0, _raycast_new_move_h, _raycast_new_move_v);

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
var _tile_offset_x = (_raycast_new_move_h > 0 ? 1 : 0);
var _tile_offset_y = (_raycast_new_move_v > 0 ? 1 : 0);

// tile values
var _tile_at_point;
var _tile_solid = tile_solid;
var _tile_h_one_way = (_raycast_new_move_h > 0 ? tile_solid_east : tile_solid_west);
var _tile_v_one_way = (_raycast_new_move_v > 0 ? tile_solid_south : tile_solid_north);


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
    // (and either can't test veritcal collision or the next horizontal test is closer than the next vertical test)
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
        if (_raycast_new_move_h < 0 && _remainder_x == 0)
        {
            _cell_x -= 1;
        }
            
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the instance is moving up, shift the tile's y position up by one
        if (_raycast_new_move_v < 0 && _remainder_y == 0)
        {
            _cell_y -= 1; 
        }
        
        // find the cell the last point occupies
        // *the last point is always the bottom of the bounding box
        var _cell_max_y = floor((_step_h_y + _height) / _tile_size);
        
        // if the last point is on a vertical intersection
        if ((_step_h_y + _height) mod _tile_size == 0)
        {
            // if the vertical movement is less than or equal to 0
            // *the instance is either not moving vertically or is moving up, shift the cell of the last point up by one
            if (_raycast_new_move_v <= 0)
            {
                _cell_max_y -= 1;
            }
        }
        
        // for every horizontal intersection the ray is cast through, check every vertical tile between the top and bottom of the bounding box
        for (_step_cell_y = _cell_y; _step_cell_y <= _cell_max_y; _step_cell_y++)
        {
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
                    _collision_move_v = raycast_new_move_v - (_collision_y - _start_y);
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
                //var _cell_y2 = floor(_step_h_y2 / _tile_size) + (_raycast_new_move_v > 0 ? -1 : 0);
                //_tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y2) & tile_index_mask;
                _cell_y = floor(_step_h_y2 / _tile_size) + (_raycast_new_move_v > 0 ? -1 : 0);
                _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
                
                // if this tile is not a solid tile or one that is solid from this side
                if (_tile_at_point != _tile_solid && _tile_at_point != _tile_h_one_way)
                {
                    // ignore this collision and continue testing
                    _collision = false;
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
                // prepare the slope collision test
                raycast_slope_x = _step_h_x;
                raycast_slope_y = _step_h_y;
                
                // if colliding with a sloped tile, and a point on the slope is found
                if (script_execute(script_slope_collision, _tile_at_point, _cell_x, _cell_y, _gradient, _ray_target_h))
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
                    // prepare the slope collision test
                    raycast_slope_x = _step_h_x;
                    raycast_slope_y = _step_h_y;
                    
                    // if colliding with a sloped tile, and a point on the slope is found
                    if (script_execute(script_slope_collision, _tile_at_point, _cell_x, _cell_max_y, _gradient, _ray_target_h))
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
                _raycast_new_move_h = (_collision_x - _start_x);
                _raycast_new_move_v = (_collision_y - _start_y);
                
                // update the redirection values for another test
                _raycast_redirect_move_h = _collision_move_h;
                _raycast_redirect_move_v = _collision_move_v;
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
    // (and either can't test horizontal collision or the next vertical test is closer than the next horizontal test)
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
        if (_raycast_new_move_h < 0 && _remainder_x == 0)
        {
            _cell_x -= 1;
        }
        
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the instance is moving up, shift the tile's y position up by one
        if (_raycast_new_move_v < 0 && _remainder_y == 0)
        {
            _cell_y -= 1; 
        }
        
        // find the cell the last point occupies
        // *the last point is always the right side of the bounding box
        var _cell_max_x = floor((_step_v_x + _width) / _tile_size);
        
        // if the last point is on a horizontal intersection
        if ((_step_v_x + _width) mod _tile_size == 0)
        {
            // if the horizontal movement is less than or equal to 0
            // *the instance is either not moving horizontally or is moving to the left, shift the cell of the last point left by one
            if (_raycast_new_move_h <= 0)
            {
                _cell_max_x -= 1;
            }
        }
        
        // for every vertical intersection the ray is cast through, check every horizontal tile between the left and right sides of the bounding box
        for (_step_cell_x = _cell_x; _step_cell_x <= _cell_max_x; _step_cell_x++)
        {
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
                    _collision_move_h = raycast_new_move_h - (_collision_x - _start_x);
                    _collision_move_v = 0;
                    _collision_floor = (_raycast_new_move_v > 0);
                    _collision_ceiling = (_raycast_new_move_v < 0);
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
                // prepare the slope collision test
                raycast_slope_x = _step_v_x;
                raycast_slope_y = _step_v_y;
                
                // if colliding with a sloped tile, and a point on the slope is found
                if (script_execute(script_slope_collision, _tile_at_point, _cell_x, _cell_y, _gradient, _ray_target_v))
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
                    // prepare the slope collision test
                    raycast_slope_x = _step_v_x;
                    raycast_slope_y = _step_v_y;
                    
                    // if colliding with a sloped tile, and a point on the slope is found
                    if (script_execute(script_slope_collision, _tile_at_point, _cell_max_x, _cell_y, _gradient, _ray_target_v))
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
                _raycast_new_move_h = (_collision_x - _start_x);
                _raycast_new_move_v = (_collision_y - _start_y);
                
                // update the redirection values for another test
                _raycast_redirect_move_h = _collision_move_h;
                _raycast_redirect_move_v = _collision_move_v;
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
 * Update Values
 *
 */

// update movement values
raycast_new_move_h = _raycast_new_move_h;
raycast_new_move_v = _raycast_new_move_v;
raycast_redirect_move_h = _raycast_redirect_move_h;
raycast_redirect_move_v = _raycast_redirect_move_v;

// update collision states
raycast_collision_h = _raycast_collision_h;
raycast_collision_v = _raycast_collision_v;
raycast_collision_slope = _raycast_collision_slope;
raycast_collision_floor = _raycast_collision_floor;
raycast_collision_ceiling = _raycast_collision_ceiling;

