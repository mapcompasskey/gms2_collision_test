/// @function scr_simulation_16_entity_raycast();


/**
 * Tile Based Collision Test
 *
 * Cast a ray from a point and check each horizontal and veritcal intersection for collision with a tile.
 * At each intersection, move away from the point, the length of the bounding box, checking for collisions with adjacent tiles.
 */

// if there is no movement
if (raycast_move_h == 0 && raycast_move_v == 0)
{
    exit;
}

// movement values
var _move_h = raycast_move_h;
var _move_v = raycast_move_v;

var _next_move_h = 0;
var _next_move_v = 0;

// the starting position (always the top left corner of the bounding box)
var _start_x = raycast_x + sprite_bbox_left;
var _start_y = raycast_y + sprite_bbox_top;

// the collision states
var _collision_h = false;
var _collision_v = false;

// the tilemap layer and tile size
var _collision_tilemap = collision_tilemap;
var _tile_size = tile_size;

var _slope_collision_script = scr_simulation_16_entity_slope;
//var _slope_collision_script = scr_simulation_16_entity_slope_2;
//var _slope_collision_script = scr_simulation_16_entity_slope_3;


/**
 * Find the X and Y Offsets
 *
 * Apply offsets when the ray should be shifted to the right side or bottom side of the bounding box.
 * Always add one since the width and height of GML boudning boxes are off by one pixel.
 */

// get the size of the bounding box and offsets
var _height = (bbox_height + 1);
var _width = (bbox_width + 1);
var _offset_x = (raycast_move_h > 0 ? _width : 0);
var _offset_y = (raycast_move_v > 0 ? _height : 0);


/**
 * Prepare Values
 *
 */

var _tile_x, _tile_y;
var _tile_max_x, _tile_max_y;
var _tile_step_x, _tile_step_y;
var _size_delta, _size_target;
var _remainder_x, _remainder_y;

// the test that can be performed
var _test_h = (raycast_move_h == 0 ? false : true);
var _test_v = (raycast_move_v == 0 ? false : true);

// the slope of the line
// *using the term "gradient" since "slope" can also refer to a type of tile
var _gradient = 0;
if (raycast_move_h != 0 && raycast_move_v != 0)
{
    _gradient = (raycast_move_v / raycast_move_h);
}

// the distances traveled along the ray
var _ray_delta_h = 0;
var _ray_delta_v = 0;

// the maximum distance of the ray
var _ray_target = point_distance(0, 0, raycast_move_h, raycast_move_v);

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
var _tile_offset_x = (raycast_move_h > 0 ? 1 : 0);
var _tile_offset_y = (raycast_move_v > 0 ? 1 : 0);

// tile values
var _tile_at_point;
var _tile_solid = tile_solid;

var _tile_h_one_way = (raycast_move_h > 0 ? tile_solid_east : tile_solid_west);
var _tile_v_one_way = (raycast_move_v > 0 ? tile_solid_south : tile_solid_north);


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
        // find the tile this point occupies
        _tile_x = floor(_step_h_x / _tile_size);
        _tile_y = floor(_step_h_y / _tile_size);
        
        // find how far from an interseciton the points are
        // *if the remainder is 0, then they are directly on an intersection
        _remainder_x = _step_h_x mod _tile_size;
        _remainder_y = _step_h_y mod _tile_size;
        
        // if the horizontal movement is negative and the point is on a horizontal intersection
        // *the entity is moving left, shift the tile's x position left by one
        if (raycast_move_h < 0 && _remainder_x == 0)
        {
            _tile_x -= 1;
        }
            
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the entity is moving up, shift the tile's y position up by one
        if (raycast_move_v < 0 && _remainder_y == 0)
        {
            _tile_y -= 1; 
        }
        
        // the maximum vertical tile to check
        var _tile_max_y = ceil((_step_h_y + _height) / _tile_size);
        
        // if the vertical movement is positive and the point is on a vertical intersection
        // *the entity is moving down, shift the maximum vertical tile up by one to include the additional tile check
        if (raycast_move_v > 0 && _remainder_y == 0)
        {
            _tile_max_y += 1;
        }
        
        // check every vertical tile the entity would pass through at this horizontal step
        for (_tile_step_y = _tile_y; _tile_step_y < _tile_max_y; _tile_step_y++)
        {
            // get the tile at this position
            _tile_at_point = tilemap_get(_collision_tilemap, _tile_x, _tile_step_y) & tile_index_mask;
            
            // if this tile is empty space
            if (_tile_at_point == 0)
            {
                continue;
            }
            
            // if moving up and this is the first collision step or if moving down and this is the last collision step
            if ((_move_v < 0 && _tile_step_y == _tile_y) || (_move_v > 0 && _tile_step_y == (_tile_max_y - 1)))
            {
                // if colliding with the exact corner of a tile
                // *because horizontal collision is checked first, this would result in a horizontal collision
                // *but if the path above (or below) the tile is clear horizontally, then it should be resolved as a vertical collision and continue horizontally
                if (_tile_at_point == _tile_solid && _remainder_x == 0 && _remainder_y == 0 && _move_v != 0)
                {
                    // shift the current tile one above or below depending on the vertical movement
                    _tile_at_point = tilemap_get(_collision_tilemap, _tile_x, _tile_step_y + (_move_v > 0 ? -1 : 1)) & tile_index_mask;
                    
                    // if this tile is empty space
                    if (_tile_at_point == 0)
                    {
                        continue;
                    }
                    
                }
            }
            
            // if colliding with a solid tile or one that is solid from this side
            if (_tile_at_point == _tile_solid || _tile_at_point == _tile_h_one_way)
            {
                // if not the first horizontal test, or if the point is on a horizontal intersection
                if (_ray_delta_h != 0 || _remainder_x == 0)
                {
                    // update collision states
                    _collision_h = true;
                    _test_h = false;
                    
                    // update the movement values
                    _move_h = _step_h_x - (_start_x + _offset_x);
                    _move_v = _step_h_y - _start_y;
                    
                    // update the movement values for another test
                    _next_move_h = 0;
                    _next_move_v = (raycast_move_v - _move_v);
                    
                    // update the collision target distance
                    _ray_target_h = point_distance(0, 0, _move_h, _move_v);
                    
                    break;
                }
            }
            
            // if colliding with another type of tile
            if (_tile_at_point != _tile_solid && _tile_at_point != _tile_h_one_way)
            {
                // prepare the slope collision test
                raycast_slope_x = _step_h_x;
                raycast_slope_y = _step_h_y;
                raycast_collision_slope = false;
                
                // if a sloped tile, and a point on the slope was found
                if (script_execute(_slope_collision_script, _tile_at_point, _tile_x, _tile_step_y, _gradient, _ray_target_h))
                {
                    // update collision states
                    raycast_collision_slope = true;
                    _collision_h = true;
                    _test_h = false;
                    
                    _collision_v = true;
                    _test_v = false;
                    
                    // update the movement values
                    _move_h = raycast_slope_x - _start_x;
                    _move_v = raycast_slope_y - _start_y;
                    
                    // update the movement values for another test
                    _next_move_h = raycast_slope_move_h;
                    _next_move_v = raycast_slope_move_v;
                    
                    // update the collision target distance
                    _ray_target_h = point_distance(0, 0, _move_h, _move_v);
                    
                    break;
                }
                
            }
            
        }
        
        // if no collision occurred during this step
        if (_collision_h == false)
        {
            // move to the next horizontal intersection
            _step_h_x = round((_tile_x + _tile_offset_x) * _tile_size);
            
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
        // find the tile this point occupies
        _tile_x = floor(_step_v_x / _tile_size);
        _tile_y = floor(_step_v_y / _tile_size);
        
        // find how far from an interseciton the points are
        // *if the remainder is 0, then they are directly on an intersection
        _remainder_x = _step_v_x mod _tile_size;
        _remainder_y = _step_v_y mod _tile_size;
        
        // if the horizontal movement is negative and the point is on a horizontal intersection
        // *the entity is moving left, shift the tile's x position left by one
        if (raycast_move_h < 0 && _remainder_x == 0)
        {
            _tile_x -= 1;
        }
            
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the entity is moving up, shift the tile's y position up by one
        if (raycast_move_v < 0 && _remainder_y == 0)
        {
            _tile_y -= 1; 
        }
        
        // the maximum horizontal tile to check
        var _tile_max_x = ceil((_step_v_x + _width) / _tile_size);
        
        // if the horizontal movement is positive and the point is on a horizontal intersection
        // *the entity is moving right, shift the maximum horizontal tile over by one to include the additional tile check
        if (raycast_move_h > 0 && _remainder_x == 0)
        {
            _tile_max_x += 1;
        }
        
        // check every horizontal tile the entity would pass through at this vertical step
        for (_tile_step_x = _tile_x; _tile_step_x < _tile_max_x; _tile_step_x++)
        {
            // get the tile at this position
            _tile_at_point = tilemap_get(_collision_tilemap, _tile_step_x, _tile_y) & tile_index_mask;
            
            // if this tile is empty space
            if (_tile_at_point == 0)
            {
                continue;
            }
            
            // if colliding with a solid tile or one that is solid from this side
            if (_tile_at_point == _tile_solid || _tile_at_point == _tile_v_one_way)
            {
                if (_ray_delta_v != 0 || _remainder_y == 0)
                {
                    // update collision states
                    _collision_v = true;
                    _test_v = false;
                    
                    // update the movement values
                    _move_h = _step_v_x - _start_x;
                    _move_v = _step_v_y - (_start_y + _offset_y);
                    
                    // update the movement values for another test
                    _next_move_h = (raycast_move_h - _move_h);
                    _next_move_v = 0;
                    
                    // update the collision target distance
                    _ray_target_v = point_distance(0, 0, _move_h, _move_v);
                    
                    break;
                }
            }
            
            // if colliding with another type of tile
            if (_tile_at_point != _tile_solid && _tile_at_point != _tile_v_one_way)
            {
                // prepare the slope collision test
                raycast_slope_x = _step_v_x;
                raycast_slope_y = _step_v_y;
                raycast_collision_slope = false;
                
                // if a sloped tile, and a point on the slope was found
                if (script_execute(_slope_collision_script, _tile_at_point, _tile_step_x, _tile_y, _gradient, _ray_target_v))
                {
                    // update collision states
                    raycast_collision_slope = true;
                    _collision_v = true;
                    _test_v = false;
                    
                    _collision_h = true;
                    _test_h = false;
                    
                    // update the movement values
                    _move_h = raycast_slope_x - _start_x;
                    _move_v = raycast_slope_y - _start_y;
                    
                    // update the movement values for another test
                    _next_move_h = raycast_slope_move_h;
                    _next_move_v = raycast_slope_move_v;
                    
                    // update the collision target distance
                    _ray_target_v = point_distance(0, 0, _move_h, _move_v);
                    
                    break;
                }
                
            }
            
        }
        
        // if no collision occurred during this step
        if (_collision_v == false)
        {
            // move to the next vertical intersection
            _step_v_y = round((_tile_y + _tile_offset_y) * _tile_size);
            
            // if there is slope
            if (_gradient != 0)
            {
                // find the new y point
                _step_v_x = ((_step_v_y - (_start_y + _offset_y)) / _gradient ) + _start_x;
                
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
raycast_move_h = _move_h;
raycast_move_v = _move_v;

raycast_next_move_h = _next_move_h;
raycast_next_move_v = _next_move_v;

// update collision states
raycast_collision_h = _collision_h;
raycast_collision_v = _collision_v;

